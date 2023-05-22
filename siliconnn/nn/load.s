/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/nn.c#L210
 *
 * Loads a network from the given filepath into net. You can use this and
 * nn_save to pretrain a model on a large set of training data, save it,
 * and load it later (perhaps in a context without the training data) and have
 * it be ready to go.
 *
 * @param X0 a pointer to the nn struct to load the pretrained network into.
 * @param X1 a char*; the path to the nn file that contains dumped data
 */

.global _nn_load
.align 2

// The corresponding operation to save. The simplicity of the serialization
// format also makes this incredibly easy. We call nn_init on the net struct
// just so it sets up the w01, w12, b1, etc pointers for us and zeros out the
// activations, and then we copy in all of the data from our file.
// nn_init mmaps a new space for the data, so we have to copy it over. That
// renders this file mapping useless, so we munmap it and close it after we
// are done.
// We have to allocate a fair amount of stack space:
// [SP + 0]: Stores the old value of the link register, our return address
// [SP + 8]: Stores the pointer to the nn struct to populate from the file
// [SP + 16]: Stores the file descriptor of the opened .nn file
// [SP + 24]: Serves as the struct stat passed to fstat (to obtain file size)
// [SP + 24]: Stores the pointer to the beginning of the mmap-ed file
// [SP + 32]: Stores the size of the file from fstat, used with mmap
_nn_load:
	SUB SP, SP, #176           // Allocate space on stack per above
	STR LR, [SP]               // Store the return address in [SP + 0]
	STR X0, [SP, #8]           // Store the pointer to the nn struct in [SP + 8]

	// First we open the file at the specified path for reading. This will take
	// the string path that the user provides and create a file descriptor which
	// we can use to read from.
	MOV X0, X1                 // First argument to open is the filepath
	MOV X1, #0                 // Second argument: open the file in read-only mode
	BL _open                   // Open the file. X0 becomes the file descriptor.
	CMP X0, #0                 // Make sure X0 is a nonnegative integer
	B.LT err_open              // If not, it's an error, so we exit.
	STR X0, [SP, #16]          // Otherwise, we store the fd on the stack as above

	// Our eventual goal is to mmap the file into memory, but to do this we need
	// to know the size of the mapping first. To do this, we use the fstat syscall
	// to find the file's size.
	// The first argument to fstat, the file descriptor, is already in place in
	// X0. We just need to provide the second argument, a pointer to a struct stat
	ADD X1, SP, #24            // Use the space allocated at [SP + 24] onwards
	BL _fstat                  // and populate it with info about the file.
	CBNZ X0, err_fstat         // If return was nonnegative, an error occurred

	// fstat gives us a lot of other info we don't care about, and stat::st_size
	// is located somewhere deep in the struct (96 byte offset). For organization,
	// we pull st_size out and put it at [SP + 32].
	LDR X1, [SP, #120]         // struct at [SP + 24]; st_size is 96 bytes after
	STR X1, [SP, #32]          // re-store st_size at [SP + 32]

	// Setting up for the mmap call to map the file into virtual memory. This
	// allows us to read the file without allocating a ton of space on the stack
	// for it. The second argument (size of mapping) is already in X1, so we just
	// set up all the other parameters.
	MOV X0, #0                 // First argument to mmap: NULL
	MOV X2, #0x01              // Second argument: PROT_READ (read-only mapping)
	MOV X3, #0x01              // Third argument: MAP_PRIVATE. Not sure this matters
	LDR X4, [SP, #16]          // Fourth argument: the file descriptor from earlier
	MOV X5, #0                 // Fifth argument: zero offset
	BL _mmap                   // Call mmap to map the .nn file into memory
	CMP X0, #0                 // If the returned pointer is negative,
	B.LT err_mmap              // that means we got a MAP_FAILED, so we exit.
	STR X0, [SP, #24]          // Otherwise store that pointer on the stack

	// We now have the raw data available, but a lot of other fields of the struct
	// (i.e. w01, b1, w12, etc) are uninitialized and not stored in the nn file.
	// Thus we call nn_init on the struct to set up all of those pointers.
	LDR W1, [X0]               // Second argument to nn_init: the desired input size
	LDR W2, [X0, #4]           // Third argument: hidden_size, per the .nn file
	LDR D0, [X0, #8]           // Fourth argument: learning_rate, also from file
	LDR X0, [SP, #8]           // First argument: pointer to the net to initialize
	BL _nn_init                // Initialize network with correct ptrs and memory

	// We now override some of nn_init's defaults with our own. Instead of
	// randomized weights, we instead want to use the pretrained weights from the
	// file.
	LDR X0, [SP, #24]          // Get the pointer to the file back from the stack
	LDR D0, [X0, #16]          // file_ptr + 16 is the network's layer 2 bias
	LDR X1, [SP, #8]           // Get the pointer to the net into X1
	STR D0, [X1, #48]          // and fix the net's b2 property according to file

	// Now, we need to loop through all of the remaining weights and biases, which
	// are just stored in the file as one big block. We copy all of those weights
	// into the memory allocated for the net by nn_init.
	// First, we figure out how many doubles the memory is. This is equivalent to
	// compute_mem_reqs(input_size, hidden_size) / 3, so refer to formula.s for
	// more info.
	LDR W0, [X1]               // X0 = net->input_size
	LDR W1, [X1, #4]           // X1 = net->hidden_size
	ADD X0, X0, #3             // X0 = net->input_size + 3
	MUL X0, X0, X1             // X0 = net->hidden_size * (net->input_size + 3).

	// We will now copy X0 many doubles from the file to the nn's w01 memory.
	LDR X1, [SP, #8]           // Get the pointer to the net into X1,
	LDR X1, [X1, #16]          // and use it to load the location of net->w01[0].
	LDR X2, [SP, #24]          // On the file side, get file pointer from stack
	// We know w01 in the file starts after the input/hidden sizes, learning rate,
	// and b2 value, so we offset this pointer accordingly as well so it points
	// at w01.
	ADD X2, X2, #24            // X2 += 2 * sizeof(int) + 2 * sizeof(double)
	MOV X3, #0                 // Setting up for the loop: int i = 0;
for:
	CMP X3, X0                 // i < # of doubles to copy over?
	B.GE end_for               // If not, we are done setting up the weights; exit
	LSL X5, X3, #3             // i * sizeof(double) gives us the byte offset
	LDR D4, [X2, X5]           // D4 = file's w01[i], using the above offset
	STR D4, [X1, X5]           // Store this value of D4 into net->w01[i].
	ADD X3, X3, #1             // i++;
	B for                      // Loop back to the condition.

// At this point, we have fully initialized the struct with the file's data.
// Since we copied over everything we needed into the struct, we no longer need
// the file; we get rid of the mapping and close the file.
end_for:
	// Setting up for munmap call
	LDR X0, [SP, #24]          // Get the pointer to the mapping into first arg,
	LDR X1, [SP, #32]          // and the size of the mapping into the second arg.
	BL _munmap                 // munmap(file_ptr, statbuf.st_size);
	CBNZ X0, err_munmap        // If munmap returns a nonzero code, error happened
	
	// Setting up for close call
	LDR X0, [SP, #16]          // First argument to close: fd
	BL _close                  // close(fd);

	// Now we are totally done; we get the return address back out of the stack
	// and return
	LDR LR, [SP]               // Put correct return address into link register
	ADD SP, SP, #176           // Deallocate stack space for this function call
	RET                        // return

// The below labels are only reached if something bad happens with a system
// call. In each case, we simply load the corresponding non-zero return code
// into X0 and exit.
err_open:
	MOV X0, #4
	BL _exit                   // exit(4);

err_fstat:
	MOV X0, #5
	BL _exit                   // exit(5);

err_mmap:
	MOV X0, #6
	BL _exit                   // exit(6);

err_munmap:
	MOV X0, #7
	BL _exit                   // exit(7);
