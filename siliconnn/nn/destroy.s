/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/nn.c#L78
 *
 * Frees resources associated with this nn (just the big w01+b1+o1+w12 array).
 * @param X0 the pointer to the net to destroy
 * Returns nothing.
 */

.global _nn_destroy
.align 2

// Because we allocated all of the memory for the net as just a single,
// contiguous block, this is function is incredibly simple to implement. We
// first use compute_mem_reqs to compute the total amount of space to free, and
// then we call mmap to free that space.
// We need to save the return address and pointer to the net on the stack
// between those calls, so we allocate 16 bytes of stack space.
_nn_destroy:
	SUB SP, SP, #16              // Allocate stack space per above
	STR LR, [SP]                 // Store return address into the first slot
	STR X0, [SP, #8]             // Store pointer to the net in the second slot

	// Setup for a call to compute_mem_reqs(input_size, hidden_size)
	MOV X1, X0                   // Move the pointer to X1, so we can write into X0
	LDR W0, [X1]                 // Set X0 to be net->input_size
	LDR W1, [X1, #4]             // Set X1 to be net->hidden_size
	BL _compute_mem_reqs         // X0 is now the total memory in bytes to deallocate

	// Setup for a call to munmap.
	MOV X1, X0                   // Size to deallocate is second arg to munmap
	LDR X0, [SP, #8]             // Load pointer to net from stack
	LDR X0, [X0, #16]            // in order to retrieve location of net->w01
	BL _munmap                   // munmap(net->w01, mem_size)
	CBNZ X0, err_munmap          // If munmap returned nonzero code, it failed.

	LDR LR, [SP]                 // Otherwise, reload return address into LR
	ADD SP, SP, #16              // Deallocate stack space
	RET                          // return

// If munmap fails, we exit with status 2.
err_munmap:
	MOV X0, #2                   // Load error code 2 into first argument
	BL _exit                     // exit(2);
