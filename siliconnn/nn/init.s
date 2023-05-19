/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/nn.c#L54
 *
 * Initializes a neural network from the given input layer size, hidden layer
 * size, and learning rate. This function zeros out all outputs and randomizes
 * all of the weights, so networks are ready to train.
 * 
 * @param X0 a reference to the nn struct to initialize
 * @param X1 the number of input neurons, should match num_attributes
 * 	in the training data.
 * @param X2 the number of hidden neurons. This can be tuned, but must
 * 	be greater than 0.
 * @param D0 the learning rate. Should be strictly positive
 * 	(and probably small) value.
 */

.global _nn_init
.align 2

// This function has to take care of setting all of the appropriate fields of
// the net struct to correct values, mmap-ing the required space needed for the
// weights and biases, and initializing everything to expected values
// (randomizing the weights and biases, zeroing out activations).
// We don't actually need too much stack space for this function, just 2
// double-words (one for the return address, and one for the pointer to the net)
_nn_init:
	SUB SP, SP, #16                // Allocate 2 quads of stack space
	STR LR, [SP]                   // Store correct return address into first slot
	STR X0, [SP, #8]               // Store pointer to the net in second slot

	// First we store input_size, hidden_size, learning_rate parameters into the
	// net struct.
	STR W1, [X0]                   // net->input_size = input_size
	STR W2, [X0, #4]               // net->hidden_size = hidden_size
	STR D0, [X0, #8]               // net->learning_rate = learning_rate

	// We need to compute the total amount of memory we need to allocate for the
	// network via a call to compute_mem_reqs.
	MOV X0, X1                     // First argument: input_size
	MOV X1, X2                     // Second argument: hidden_size
	BL _compute_mem_reqs           // Get total required memory in X0

	// Setting up for call to mmap to reserve the amount of heap space we just
	// calculated
	MOV X1, X0                     // Total size is second argument to mmap
	MOV X0, #0                     // First argument to mmap: NULL
	MOV X2, #3                     // Third argument: PROT_READ | PROT_WRITE
	MOV X3, #0x1001                // Fourth argument: MAP_SHARED | MAP_ANONYMOUS
	MOV X4, #-1                    // Set fd to -1 because this is a virtual mapping
	MOV X5, #0                     // Zero offset
	BL _mmap                       // call mmap

	CMP X0, #0                     // Check if MAP_FAILED was returned
	B.LT err_mmap                  // If so, exit with unique nonzero code

	// At this point, we have successfully reserved all of the space we need for
	// this network with mmap; all that is required now is to set up the w01,
	// b1, o1, and w12 pointers into this big block of memory.
	LDR X1, [SP, #8]               // Get pointer to net from stack
	STR X0, [X1, #16]              // Set net->w01 = start of the mmap-ed block

	// w01 has input_size * hidden_size total elements, so we calculate the offset
	// from the beginning of the block to the start of b1 as
	// sizeof(double) * input_size * hidden_size.
	LDR W2, [X1]                   // Get input_size from net struct
	LDR W3, [X1, #4]               // and hidden_size as well
	LSL X3, X3, #3                 // Multiply hidden_size by sizeof(double)
	MADD X2, X2, X3, X0            // w01 + input_size*hidden_size*sizeof(double);
	STR X2, [X1, #24]              // Store that X2 value into net->b1
	ADD X2, X2, X3                 // o1 starts hidden_size*sizeof(double) after b1
	STR X2, [X1, #32]              // Store start of o1 into net->o1
	ADD X2, X2, X3                 // w12 starts same offset after o1
	STR X2, [X1, #40]              // Store start of w12 into net->w12

	// At this point, all fields of the struct are set to the correct value, and
	// we just want to update the memory in the block to be good starting values
	// for training. This means zeroing out any potentially-nonzero output values,
	// and then setting the weights and biases to randomized initial starting
	// values.
	MOV X0, X1                     // X1 still holds ptr to net; move to first arg
	BL _zero_outputs               // Zero out all output values for the net
	LDR X0, [SP, #8]               // Reload pointer to net into first argument
	BL _random_weights             // Randomize all weights and biases for the net

	// Fully done, clean up and exit
	LDR LR, [SP]                   // Load correct return address into LR
	ADD SP, SP, #16                // Deallocate stack space
	RET                            // return

// This label is for handling failures in mmap. We exit with code 1, which
// indicates to the user that there was an issue with nn_init mmap.
err_mmap:
	MOV X0, #1                     // Load exit code 1 into first argument
	B _exit                        // exit(1);
