/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/nn.c#L88
 *
 * Given an example, generate a prediction by doing a forward pass through the
 * network. This modifies the network's o1 and o2 properties, and also returns
 * o2 after the forward pass has been computed for convenience.
 * 
 * @param X0 the network to run the example through
 * @param X1 the example
 * @return the network's final prediction, in D0
 */

.global _nn_forward
.align 2

// Works pretty much how you expect; we proceed layer by layer. We first compute
// raw activations for the hidden layer via a matrix multiplication with the
// w01 matrix and the input. Then we iterate through the hidden layer again,
// clamping the activations with sigmoid. Finally, we do one more matrix
// multiplication to get the final output.
_nn_forward:

	// Allocate 3 sets of 8 bytes on stack. Layout is as follows:
	// [SP + 0]: Stores return address
	// [SP + 8]: Stores pointer to network
	// [SP + 16]: First we use it to store the pointer to the example, x. After
	// calculating the raw activations, though, we are done with it, and can
	// reuse this slot to store the iterator in the sigmoid loop.
	SUB SP, SP, #32                  // Of course, need to keep SP 16-byte aligned
	STR LR, [SP]                     // Store the return address in [SP]
	STR X0, [SP, #8]                 // Store pointer to net in [SP + 8]
	STR X1, [SP, #16]                // Store pointer to example in [SP + 16]

	// Since we compute the outputs for each neuron by iteratively summing, we
	// need to make sure we are starting from zero (otherwise previous forward
	// passes will affect the output of this current pass). This is what
	// zero_outputs is for.
	BL _zero_outputs                 // Reset all net->o1, net->o2 to zero
	LDR X0, [SP, #8]                 // Reload pointer to net back into X0
	LDR X7, [SP, #16]                // Reload pointer to example into X7

	// The first matrix multiplication (w01 * example) does not require any
	// function calls, so for convenience we just go ahead and load
	// net->input_size and net->hidden_size into registers so we don't have to
	// load them each iteration of the loop.
	LDR W1, [X0]                     // W1 = net->input_size
	LDR W2, [X0, #4]                 // W2 = net->hidden_size

	MOV X3, #0                       // int i = 0; (outer loop iterator)
for_input_layer:
	CMP X3, X1                       // i < net->input_size?
	B.GE end_for_input_layer         // if not, exit the outer loop

	MOV X4, #0                       // int j = 0; (inner loop iterator)
for_hidden_neuron:
	CMP X4, X2                       // j < net->hidden_size?
	B.GE end_for_hidden_neuron       // if not, move on to the next neuron

	MADD X5, X3, X2, X4              // X5 = i*net->hidden_size + j
	LSL X5, X5, #3                   // Multiply by sizeof(double) for byte offset
	LDR X6, [X0, #16]                // Get address of net->w01[0] in X6
	LDR D0, [X6, X5]                 // D0 = net->w01[i*net->hidden_size + j]
	
	LSL X5, X3, #3                   // Multiply i by sizeof(double)
	LDR D1, [X7, X5]                 // D1 = x[i]

	LSL X5, X4, #3                   // Multiply j by sizeof(double)
	LDR X6, [X0, #32]                // Get address of net->o1[0] in X6
	LDR D2, [X6, X5]                 // D2 = net->o1[j]
	
	FMADD D2, D0, D1, D2             // D2 += x[i]*net->w01[i*net->hidden_size+j]
	STR D2, [X6, X5]                 // Store updated value of D2 back
	ADD X4, X4, #1                   // increment j++
	B for_hidden_neuron              // Loop back to condition of inner loop

// At this point, we've computed the ith input neuron's contribution to all
// hidden neurons, so we just increment i and loop to the next neuron
end_for_hidden_neuron:
	ADD X3, X3, #1                   // .. so increment i
	B for_input_layer                // and then loop back to outer loop condition

// Done calculating raw activation values for all neurons in the hidden layer.
// This label is just a few instructions to set up for the next for loop.
end_for_input_layer:
	MOV X3, #0                       // Reset i back to 0
	STR X3, [SP, #16]                // Have to start storing i in the stack now
	LDR X0, [SP, #8]                 // Load the net pointer into X0

// And now we go back through the hidden layer one more time, applying the
// sigmoid activation function to all hidden neuron outputs. Since we are
// calling external functions here, we have to save i on the stack and retrieve
// it after calls to _sigmoid.
activate_hidden_outputs:           // Assumes X3 is iterator, X0 is net pointer
	LDR W1, [X0, #4]                 // Get net->hidden_size
	CMP X3, X1                       // i < net->hidden_size?
	B.GE end_activate_hidden_outputs // If not, done; exit this loop

	LSL X3, X3, #3                   // Multiply i by sizeof(double) to get offset
	LDR X2, [X0, #32]                // Get location of net->o1 in memory
	LDR D0, [X2, X3]                 // Load value of net->o1[i] into D0

	LDR X2, [X0, #24]                // Get location of net->b1 in memory
	LDR D1, [X2, X3]                 // Load value of net->b1[i] ito D1
	FADD D0, D0, D1                  // 1st arg to sigmoid: net->o1[i]+net->b1[i]
	BL _sigmoid                      // compute sigmoid of activation + bias

	LDR X0, [SP, #8]                 // Reload net ptr into X0 for next iteration
	LDR X3, [SP, #16]                // Get i back from stack for updating
	LDR X1, [X0, #32]                // X1 is the location of net->o1[0]
	LSL X2, X3, #3                   // Compute byte offset; i*sizeof(double)
	STR D0, [X1, X2]                 // store sigmoid output into net->o1[i]

	ADD X3, X3, #1                   // i++;
	STR X3, [SP, #16]                // store incremented value back into stack
	B activate_hidden_outputs        // Loop back to the condition

// At this point the outputs from the second layer have been finalized (passed
// through sigmoid function) so we just need to multiply each hidden neuron's
// output by its respective w12 weight and sum the result in o2.
end_activate_hidden_outputs:
	MOV X3, #0                       // int i = 0;

// Loop through each hidden neuron. Note we have no need to reload the pointer
// to the network in X0, or net->hidden_size in X1; this is guaranteed to
// already be ready by the previous loop.
for_hidden_layer:                  // Assumes X3 is iterator, X1 is hidden_size
	CMP X3, X1                       // i < net->hidden_size?
	B.GE end_for_hidden_layer        // if not, exit the loop

	LSL X2, X3, #3                   // Get byte offset of i-th elt in double array
	LDR X4, [X0, #32]                // X4 = location of net->o1[0]
	LDR D0, [X4, X2]                 // D0 = net->o1[i]
	LDR X4, [X0, #40]                // X4 = location of net->w12[0]
	LDR D1, [X4, X2]                 // D1 = net->w12[i]
	LDR D2, [X0, #56]                // D2 = net->o2

	FMADD D2, D0, D1, D2             // D2 = net->o2 + net->o1[i] * net->w12[i];
	STR D2, [X0, #56]                // Store the resulting sum back into net->o2

	ADD X3, X3, #1                   // increment i++
	B for_hidden_layer               // Loop back to the condition

// Almost done at this point, all that remains to do is to add the layer 2 bias
// term to the output neuron and then return.
end_for_hidden_layer:
	LDR D0, [X0, #56]                // Load net->o2 into D0 once more
	LDR D1, [X0, #48]                // Load net->b2 into D1
	FADD D0, D0, D1                  // D0 = net->o2 + net->b2
	STR D0, [X0, #56]                // Store this sum into net->o2

	// We are now fully done with the forward pass - all outputs have been updated
	// in the network, and we have the final activation ready to be returned i
	// D0.
	LDR LR, [SP]                     // Load return address into LR
	ADD SP, SP, #32                  // Deallocate stack space for this function
	RET                              // return
