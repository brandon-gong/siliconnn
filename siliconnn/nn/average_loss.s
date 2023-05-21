/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/nn.c#L138
 *
 * Computes the mean squared error of the network. If n is the number of examples,
 * x is the networks predictions, and y are the true labels, this is given by
 * \frac{1}{n}\sum_{i=0}^{n}(x_i - y_i)^2.
 * Lower values are more desirable. Use this function to tune your
 * hyperparameters and minimize this value on the held-out test set.
 * 
 * @param X0 the network to compute average loss on
 * @param X1 the dataset to compute average loss for. This will call nn_forward
 * 	on each example in ds.
 */

.global _nn_average_loss
.align 2

// We allocate 48 bytes on the stack for this function, used for the following
// purposes:
// [SP + 0]: Stores the old value of LR, the correct return address
// [SP + 8]: Stores the pointer to the network to compute average L2 loss on
// [SP + 16]: Stores the pointer to the dataset to check performance against
// [SP + 24]: Stores i, the iterator through each example in the dataset
// [SP + 32]: Stores the total L2 loss incurred so far. Divided by total in the
//            end to obtain the average loss over all examples.
// [SP + 40]: Stores the memory location of ds->examples[i], as this is a bit
//            annoying to recompute, and we have these 8 bytes of space anyway.
_nn_average_loss:

	// Basic stack initializations
	SUB SP, SP, #48               // Allocate 6 double-words of space as per above
	STR LR, [SP]                  // Store return address into [SP + 0]
	STR X0, [SP, #8]              // Store pointer to net in [SP + 8]
	STR X1, [SP, #16]             // Store pointer to ds in [SP + 16]
	FMOV D0, #0.0                 // Initialize total_loss to zero
	STR D0, [SP, #32]             // Store this initialized value in [SP + 32]

	// We will now loop through each example in the dataset. For each example,
	// we run a forward pass through the network, and compute the L2 loss for the
	// example by comparing the network's output against the true label. We
	// accumulate total L2 loss over all examples.
	MOV X0, #0                    // Initialize the for loop iterator: int i = 0;
	STR X0, [SP, #24]             // Store this initialized value in [SP + 24]
for:                            // Expects X0 to hold the value of i
	LDR X1, [SP, #16]             // Get the pointer to the dataset in X1
	LDR W2, [X1, #8]              // And then use it to retrieve ds->num_examples
	CMP X0, X2                    // i < ds->num_examples?
	B.GE end_for                  // If not, we've gotten L2 loss from all; break

	// From i and the pointer to the dataset, we now compute the address on the
	// heap of ds->examples[i], and store it on the stack so we can still access
	// it after calling nn_forward.
	LDR X1, [X1]                  // X1 is the location of ds->examples[0]
	LSL X0, X0, #3                // Convert i from index to byte offset
	LDR X1, [X1, X0]              // X1 now is the start of ds->examples[i]
	STR X1, [SP, #40]             // Store this address on the stack for later

	// Setting up and calling nn_forward on this example's attributes
	LDR X1, [X1, #8]              // Second argument: ds->examples[i]->example
	LDR X0, [SP, #8]              // First argument: pointer to the net
	BL _nn_forward                // D0=nn_forward(net, ds->examples[i]->example)

	// X0 now holds the network's estimated label given the attributes; we wish
	// to compare it against the true label, ds->examples[i]->label.
	LDR X1, [SP, #40]             // We already know where ds->examples[i] is,
	LDR W1, [X1]                  // so it is easy to pull out its label.

	// We want to add the squared loss, that is, (true label - predicted)^2, to
	// total_loss.
	SCVTF D1, X1                  // Convert the true label to flaot for FSUB
	FSUB D1, D1, D0               // D1 = true_label - predicted
	LDR D0, [SP, #32]             // Get total_loss from the stack into D0
	FMADD D0, D1, D1, D0          // total_loss += (true_label - predicted)^2
	STR D0, [SP, #32]             // Store total loss back onto the stack.

	LDR X0, [SP, #24]             // We are done with this example; reload i
	ADD X0, X0, #1                // i++;
	STR X0, [SP, #24]             // Store incremented i back onto the stack
	B for                         // Loop back to the condition

// We now have the total squared loss of the network over all examples in the
// dataset. We now need to divide by the number examples to get the mean squared
// error.
end_for:
	LDR X1, [SP, #16]             // Get the pointer to the dataset from stack
	LDR W2, [X1, #8]              // and use it to load ds->num_examples.
	SCVTF D1, X2                  // Convert num_examples to float for FDIV

	// Note at this point D0 is guaranteed to be total_loss; no need to reload.
	// Just compute the MSE and put the result in the return register.
	FDIV D0, D0, D1              // mse = total_loss / num_examples 

	// Done here; cleanup and return.
	LDR LR, [SP]                 // Reload return address into link register
	ADD SP, SP, #48              // Move stack pointer back to where we found it
	RET                          // return
