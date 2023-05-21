/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/nn.c#L185
 *
 * Save the network into a file at the given filepath. The serialization format
 * we use here is stupid simple. We simply store the struct how you would
 * expect; first 4 bytes stores the input size, next 4 bytes stores the hidden
 * size, next 8 bytes stores the learning rate, next 8 bytes stores the layer 2
 * bias, and then we just copy in our big block from memory that has the rest of
 * our weights and biases in it.
 *
 * @param X0 a pointer to the network to save
 * @param X1 a char*; the path to save the network at.
 * Returns nothing.
 */

.global _nn_save
.align 2

// This implementation actually improves the reference implementation; instead
// of making three separate calls to write to save the input_size, hidden_size,
// and learning_rate, we simply take advantage of the fact that they are stored
// exactly how we want in the struct already (input_size being the first 4
// bytes, hidden the next 4, and lr the next 8) so we just write everything with
// one call to write.
// We have to save the return address, pointer to the net, and file descriptor
// on the stack between calls to write. Stack layout:
// [SP + 0]: Store the old link register value, our correct return address
// [SP + 8]: Store the pointer to the network to save
// [SP + 16]: Stores the file descriptor to the opened file that we write to.
_nn_save:
	SUB SP, SP, #32             // Allocate space on stack, per above
	STR LR, [SP]                // Store the return address into [SP + 0]
	STR X0, [SP, #8]            // Store the pointer to the net in [SP + 8]

	// We want to (potentially create and) open the file given at the path in X1.
	MOV X0, X1                  // First argument to open: path to file to open
	MOV X1, #0x601              // Flags: O_WRONLY | O_CREAT | O_TRUNC
	MOV X2, #448                // Create the file with full permissions
	BL _open                    // Open the file for writing
	CMP X0, #0                  // Check if returned file descriptor is negative
	B.LT open_err               // If so, couldn't open the file
	STR X0, [SP, #16]           // Otherwise, save the fd in the stack

	// We now set up our first call to write, which will save input_size,
	// hidden_size, and learning_rate. Conveniently, the first argument to write
	// (the file to write to) is already in X0.
	LDR X1, [SP, #8]            // Second argument to write: pointer to net struct
	MOV X2, #16                 // Third argument: size (int+int+double) to write
	BL _write                   // Save input_size, hidden_size, and lr to file

	// We also need to save the layer two bias, which is unfortunately not
	// held contiguously with the other three properties, so we do it in this
	// separate write call.
	LDR X0, [SP, #16]           // First argument to write: our saved fd
	LDR X1, [SP, #8]            // Second argument: pointer to net struct,
	ADD X1, X1, #48             // but offset by 48 bytes so it points at net->b2.
	MOV X2, #8                  // Third argument: sizeof(double)
	BL _write                   // Save net->b2 to the file

	// The only thing left to do now is to save all of the other parameters to
	// the file. Recall that we allocate space for the network in one big block;
	// this is very convenient as now we can just save it all in one swoop.
	// First, we call compute_mem_reqs to figure out how big that block was.
	LDR X1, [SP, #8]            // Get pointer to network into X1
	LDR W0, [X1]                // First argument to compute_mem_reqs: input_size
	LDR W1, [X1, #4]            // Second argument: hidden_size
	BL _compute_mem_reqs        // X0 = total size of memory block in bytes

	// We now write that entire block to the file. This will save all of w01,
	// b1, and w12.
	MOV X2, X0                  // Third argument to write: size of the block
	LDR X0, [SP, #16]           // First argument: same fd as before
	LDR X1, [SP, #8]            // Load pointer to network into X1
	LDR X1, [X1, #16]           // Second arg: net->w01, the start of the block
	BL _write                   // Save that entire thing to the file

	// We are done saving everything, so we close the file.
	LDR X0, [SP, #16]           // First argument to close: fd
	BL _close                   // close(fd);

	LDR LR, [SP]                // Reload return address into link register
	ADD SP, SP, #32             // Deallocate the stack space for this function
	RET                         // return

// We only reach here if something bad happens when we try to create or open
// the file for writing. If this happens, we can't proceed, so we exit with the
// appropriate non-zero exit code.
open_err:
	MOV X0, #3                   // Load 3 into the first argument
	BL _exit                     // exit(3);
