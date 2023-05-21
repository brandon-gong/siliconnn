/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/nn.c#L151
 *
 * Trains a neural network on the given dataset for the specified number of
 * epochs. Training is done via stochastic gradient descent with a batch size
 * of 1. After each epoch, useful stats such as epoch number and average loss
 * are logged.
 * 
 * @param net the network to train
 * @param ds the dataset to train on
 * @param num_epochs the number of epochs to train for
 */
.global _nn_train
.align 2

// For each epoch, do forward and backward pass with all the examples in the
// training set, and then log useful data to the terminal. Then shuffle the
// data and go to the next epoch.
// Since we make a ton of external function calls, we need to reserve a fair
// bit of stack space for saving local variables. The layout is as follows:
// [SP + 0]: Stores old value of link register, the correct return address
// [SP + 8]: Stores pointer to the network to train. The net will be modified.
// [SP + 16]: Stores pointer to the training datset. The ds will be modified.
// [SP + 24]: Stores i, the iterator for 0 through num_epochs.
// [SP + 32]: Stores num_epochs, the upper bound of i
// [SP + 40]: Stores j, the iterator for each example in the training dataset
// [SP + 48]: Stores location of ds->examples[j] between forward and backward
// [SP + 48]: bytes 48-80 relative to the stack pointer is a buffer for
//            itoa and dtoa to write into.
// Note we reuse the [SP + 48] slot, since when we get to the printing part we
// no longer need location of any ds->examples[j].
_nn_train:
	SUB SP, SP, #80               // Allocate 80 bytes of space on stack per above
	STR LR, [SP]                  // Store correct return address in [SP + 0]
	STR X0, [SP, #8]              // Store pointer to network in [SP + 8]
	STR X1, [SP, #16]             // Store pointer to dataset in [SP + 16]
	STR X2, [SP, #32]             // Store num_epochs in [SP + 32]

	// The outer loop will run once for each epoch. Each epoch, we train the
	// network on the dataset, then print out average loss to stdout.
	MOV X0, #0                    // Setup for the loop: int i = 0;
	STR X0, [SP, #24]             // Store i in [SP + 24] per above
for_epochs:                     // This loop expects i to be in X0
	LDR X1, [SP, #32]             // Get num_epochs from the stack
	CMP X0, X1                    // i < num_epochs?
	B.GE end_for_epochs           // If not, done training; exit the loop

	// For each epoch, we need to train the network on the dataset. This means
	// running through each example in the dataset and performing a step of
	// gradient descent with each example.
	MOV X0, #0                    // Setup for the inner loop: int j = 0;
	STR X0, [SP, #40]             // Store j in [SP + 40] per above
for_examples:                   // This loop expects j to be in X0
	LDR X1, [SP, #16]             // We grab the pointer to the dataset from stack
	LDR W1, [X1, #8]              // in order to get ds->num_examples into X1.
	CMP X0, X1                    // j < ds->num_examples?
	B.GE end_for_examples         // If not, we've seen all examples; print info

	// Computing location of ds->examples[j] and storing in stack.
	LDR X1, [SP, #16]             // X1 points at the start of the ds struct
	LDR X1, [X1]                  // Now X1 is the location of example[0]
	LSL X0, X0, #3                // j from index to offset; j * sizeof(example*)
	LDR X1, [X1, X0]              // Now X1 points at the start of ds->example[j]
	STR X1, [SP, #48]             // Store this location in the stack for later

	// Setting up and calling nn_forward on ds->examples[j]
	LDR X1, [X1, #8]              // Second argument: ds->examples[j]->example
	LDR X0, [SP, #8]              // First argument: pointer to the network
	BL _nn_forward                // Compute the forward pass with this example

	// Setting up and calling nn_backward
	LDR X0, [SP, #8]              // First argument is again pointer to the net
	LDR X2, [SP, #48]             // Grab location of ds->examples[j] from earlier
	LDR X1, [X2, #8]              // Second argument: ds->examples[j]->example
	LDR W2, [X2]                  // Third argument: ds->examples[j]->label
	BL _nn_backward               // Perform a step of SGD with this example

	// We've done a step of gradient descent with this one training example; we
	// repeat the process for the rest of the examples in this dataset.
	LDR X0, [SP, #40]             // Get value of j back out of stack
	ADD X0, X0, #1                // Increment j: j++
	STR X0, [SP, #40]             // Store incremented value back into the stack
	B for_examples                // Loop back to the inner loop's condition

// At this point, we've done stochastic gradient descent for every example in
// the dataset, which means we've completed this training epoch. Now, we print
// the average training loss to stdout for diagnostic purposes and loop.
end_for_examples:
	// Printing "Epoch " to stdout. We print part of the train_log string,
	// declared below.
	MOV X0, #1                    // First argument to write: STDOUT_FILENO
	ADR X1, train_log             // Second argument: pointer to train_log
	MOV X2, #6                    // Third argument: length to print, here 6
	BL _write                     // Print first 6 chars of train_log to stdout

	// Now we want to print the epoch number, which is given by our outer loop
	// index i. First we need to call itoa to convert this integer value into
	// characters, and then we call write to write those characters to stdout.
	ADD X0, SP, #48               // First argument to itoa: pointer to buffer
	LDR X1, [SP, #24]             // Second argument: i
	BL _itoa                      // Convert i to decimal chars, stored in buffer

	// Note X0 is now the length of the converted string by itoa.
	MOV X2, X0                    // Third argument to write: length to print
	MOV X0, #1                    // First argument: STDOUT_FILENO
	ADD X1, SP, #48               // Second argument: pointer to buffer
	BL _write                     // Print epoch number out following "Epoch "

	// Print a delimiter between the epoch number and the average training loss;
	// we print out " | Loss: ", so the final output will look something like
	// "Epoch xx | Loss: x.xxx".
	MOV X0, #1                    // First argument to write: STDOUT_FILENO
	ADR X1, train_log             // Second argument: pointer to train_log string,
	ADD X1, X1, #5                // ..except skip the "Epoch" part (5 chars)
	MOV X2, #9                    // Third argument: Print out 9 characters
	BL _write                     // Print " | Loss: " to stdout

	// Actually compute average training loss for this epoch, via nn_average_loss
	LDR X0, [SP, #8]              // First argument to nn_average_loss: net ptr
	LDR X1, [SP, #16]             // Second argument: pointer to the train dataset
	BL _nn_average_loss           // Compute average training loss and store in D0

	// We now need to convert this floating point value in D0 to a string for
	// printing. Conveniently, D0 is already the right parameter register for
	// dtoa, so we just need to set up arguments 1 and 3 to dtoa and call it.
	ADD X0, SP, #48               // First argument to dtoa: pointer to buffer
	MOV X1, #10                   // Third argument: 10 decimals of precision
	BL _dtoa                      // Convert average loss to string, stored in buf

	// We now have the stringified training loss in the buffer, and the length of
	// that string in X0. We call write to print the result to stdout.
	MOV X2, X0                    // Move the length of string to third argument
	MOV X0, #1                    // First argument to write: STDOUT_FILENO
	ADD X1, SP, #48               // Second argument: pointer to buffer
	BL _write                     // Print average training loss for this epoch

	// Almost done - just need to print out a newline so next epoch starts on
	// a new line.
	MOV X0, #1                    // First argument to write: STDOUT_FILENO
	ADR X1, train_log             // Second argument: pointer to train_log string,
	ADD X1, X1, #14               // except skip everything except the last \n.
	MOV X2, #1                    // Third argument: just print a single character
	BL _write                     // Print out a newline to stdout

	// Shuffling the dataset for the next epoch
	LDR X0, [SP, #16]             // First argument to ds_shuffle: pointer to ds
	BL _ds_shuffle                // ds_shuffle(ds);

	// We are now fully done with everything we have to do for this epoch; repeat
	// this process for all other epochs.
	LDR X0, [SP, #24]             // Get old value of i back out of the stack
	ADD X0, X0, #1                // i++;
	STR X0, [SP, #24]             // Store this incremented value into the stack
	B for_epochs                  // Loop back to outer loop condition

// At this point, we have finished training the net for the given number of
// epochs. There's nothing left to do besides clean up and return.
end_for_epochs:
	LDR LR, [SP]                  // Load correct return address to link register
	ADD SP, SP, #80               // Deallocate stack space
	RET                           // return

// We print substrings of the below string to delimit epoch # and training loss
// for each epoch.
train_log: .ascii "Epoch | Loss: \n"
