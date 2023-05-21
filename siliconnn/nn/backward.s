/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/nn.c#L118
 *
 * Given an example and its true label, update the network weights via 
 * backpropagation. You must run nn_forward on this same example before calling
 * this function for reasonable results. This function modifies the w01, b1,
 * w12, and b2 values.
 *
 * This is where things get a little gnarly, especially because we have to work
 * around not having a linalg library handy, and I also don't want to deal with
 * allocating extra space for temporary variables. For reference, here are the
 * math formulas I derived. It is almost directly translated into the code;
 * updating everything in this order allows us to do the whole thing in-place
 * iteratively.
 *
 * grad_b2 = 2 * (o2 - y)
 * grad_w12_i = 2 * (o2 - y) * o1_i
 * grad_b1_i = 2 * (o2 - y) * w12_i * o1_i * (1 - o1_i) (sigmoid derivative here)
 * grad_w01_ji = 2 * (o2 - y) * w12_i * o1_i * (1 - o1_i) * x_i
 *
 * Simplifying, we have
 *
 * grad_b2 = 2 * (o2 - y)
 * grad_w12_i = grad_b2 * o1_i
 * grad_b1_i = grad_w12_i * w12_i * (1 - o1_i)
 * grad_w01_ji = grad_b1_i * x_i
 * 
 * @param X0 the network to update
 * @param X1 the example that was just run through the net with nn_forward
 * @param X2 the example's true label
 * Returns nothing.
 */

.global _nn_backward
.align 2

// No need to allocate any space on the stack for this function, we can make it
// all happen with the registers available to do this. We use volatile registers
// D0-D4 and X0-X8. The following registers have fixed purposes; the others are
// just used as scratch registers for different purposes throughout.
// D0: Stores learning_rate
// D1: Store grad_b2
// X0: Stores the pointer to the network to perform backprop on
// X1: Stores the pointer to the example that network.forward() was run on
// X2: Stores the true label
// X3: Stores i, the iterator for the outer loop (0 thru hidden_size)
// X4: Stores j, the iterator for the inner loop (0 thru input_size)
// X5: Stores net->input_size, the upper bound of j
// X6: Stores net->hidden_size, the upper bound of i
_nn_backward:
	LDR D0, [X0, #8]               // Set D0 to learning_rate from the net struct
	LDR W5, [X0]                   // Set X5 to net->input_size
	LDR W6, [X0, #4]               // set X6 to net->hidden_size
	
	// Computing the gradient of layer two bias (grad_b2). See above for formula
	LDR D1, [X0, #56]              // D1 = net->o2
	SCVTF D2, X2                   // Promote the true label (int) to float value
	FSUB D1, D1, D2                // D1 = net->o2 - y
	FMOV D2, #2.0                  // Put the constant 2 into a register for FMUL
	FMUL D1, D1, D2                // D1 = grad_b2 = 2 * (net->o2 - y)

	// Use the computed gradient to update the layer two bias.
	LDR D2, [X0, #48]              // Get current value of net->b2 into D2
	FMSUB D2, D0, D1, D2           // D2 = net->b2 - learning_rate * grad_b2
	STR D2, [X0, #48]              // Store updated bias value back into net->b2

	// The next loop will update the rest of the parameters in the network. It
	// loops for each neuron in the hidden layer, first updating the weight and
	// bias from that neuron to the output neuron, and then propagating further
	// backwards to adjust the weights from all of the input neurons to that one
	// hidden neuron.
	MOV X3, #0                     // Setup iterator for loop: int i = 0;
for_hidden:
	CMP X3, X6                     // i < net->hidden_size?
	B.GE end_for_hidden            // If not, we are done; exit the loop
	LSL X7, X3, #3                 // Convenience: get byte offset of i-th double

	// We first compute the gradient of the weight of the connection between this
	// i-th hidden neuron and the output neuron, grad_w12_i. See formula above.
	LDR X8, [X0, #32]              // X8 = location of net->o1[0]
	LDR D3, [X8, X7]               // D3 = net->o1[i]
	FMUL D2, D1, D3                // D2 = grad_w12_i = grad_b2 * net->o1[i]

	// Before we can actually update the weight with the gradient, we also need
	// to use the old weight's value to compute the gradient of the bias
	// (grad_b1_i), which we will go ahead and do here.
	FMOV D4, #1.0                  // Load the constant 1 into register for FSUB
	FSUB D3, D4, D3                // D3 = (1 - net->o1[i])
	LDR X8, [X0, #40]              // X8 = location of net->w12[0]
	LDR D4, [X8, X7]               // D4 = net->w12[i]
	FMUL D3, D3, D4                // D3 *= net->w12[i]
	FMUL D3, D3, D2                // D3 *= grad_w12_i

	// We now have the gradient of the weight in D2, and the gradient of the bias
	// in D3. We update net->w12[i] and net->b1[i] respectively according to these
	// gradients.
	FMSUB D4, D0, D2, D4           // D4 = net->w12[i] - learning_rate*grad_w12_i
	STR D4, [X8, X7]               // Store updated weight back into net->w12[i]
	LDR X8, [X0, #24]              // X8 = location of net->b1[0] in memory
	LDR D4, [X8, X7]               // D4 = old value of net->b1[i]
	FMSUB D4, D0, D3, D4           // D4 = net->b1[i] - learning_rate * grad_b1_i
	STR D4, [X8, X7]               // Store updated bias back into net->b1[i]

	// For this particular neuron, we've now successfully updated its bias and
	// corresponding weight between it and the output neuron. Now, we propagate
	// one layer further back and update all of the weights between all of the
	// input neurons and this particular hidden neuron.
	MOV X4, #0                     // Setup iterator for inner loop: int j = 0;
for_input:
	CMP X4, X5                     // j < net->input_size?
	B.GE end_for_input             // if not, exit the inner loop
	LSL X8, X4, #3                 // Two convenience values: byte offset of j-...
	LSL X7, X3, #3                 // ... and i-th values respectively.

	// D2 used to store grad_w12_i, which we don't need anymore, so we will use it
	// to store the gradient of the weight between the j-th input neuron and the
	// i-th hidden neuron. See above formula for grad_w01_ji.
	LDR D2, [X1, X8]               // D2 = x[j]
	FMUL D2, D2, D3                // D2 = x[j] * grad_b1_i

	// Updating the weight: have to do a bit of math with the indices i and j to 
	// retrieve the old value of the weight; then we do similar business with the
	// FMSUB and store.
	MADD X8, X8, X6, X7            // X8 = sizeof(double) * (j * hidden_size + i)
	LDR X7, [X0, #16]              // X7 = location of net->w01[0] in memory
	LDR D4, [X7, X8]               // D4 = net->w01[j*net->hidden_size + i]
	FMSUB D4, D0, D2, D4           // D4 = D4 - learning_rate * grad_w01_ji
	STR D4, [X7, X8]               // Store this updated value back in same place
	
	// We've updated the weight between the j-th input neuron and i-th hidden
	// layer neuron; we continue this process until we've updated weights between
	// all input neurons and the i-th hidden neuron.
	ADD X4, X4, #1                 // j++;
	B for_input                    // loop back to condition of inner loop

// At this point, we've successfully updated all weights and biases associated
// with the i-th hidden neuron. This includes its weight and bias in relation
// to the output neuron, as well as weights of all incoming connections from
// input neurons. We repeat this process for all hidden neurons.
end_for_input:
	ADD X3, X3, #1                 // i++;
	B for_hidden                   // loop back to the condition of outer loop

// Now, we've finished updating everything. We didn't allocate any stack space
// or call any external functions with BL, so there's no cleanup to do. We can
// simply return.
end_for_hidden:
	RET                            // return
