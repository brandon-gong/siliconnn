/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/dataset.c#L7
 *
 * Destroy a `dataset` (freeing its `examples` list back to the OS), but
 * preserves the underlying data. Use this when you have multiple datasets over
 * the same block of underlying data.
 * 
 * @param X0 a pointer to the dataset to destroy.
 * Returns nothing.
 */

.global _ds_destroy
.align 2

// We are given the address of the dataset we want to destroy in X0.
// We need to calculate size to free for the second argument of munmap;
// this is given by ds->num_examples * 8.
_ds_destroy:
	SUB SP, SP, #16           // Allocate space on stack to store return address
	STR LR, [SP]              // Store the return address
	LDR W1, [X0, #8]          // W1 = ds->num_examples
	LSL W1, W1, #3            // W1 *= 8
	LDR X0, [X0]              // Dereference X0 to obtain pointer to examples
	BL _munmap                // Call munmap(ds->examples, ds->num_examples * 8)
	CBNZ X0, exit             // If syscall returned nonzero code, exit with error

	LDR LR, [SP]              // Reload return address into LR
	ADD SP, SP, #16           // Deallocate stack space
	RET                       // Return back to caller

// The only way this label is reached is from the CBNZ instruction from above
// (equivalent to if(err != 0) error checking in C). Here, we want to exit
// with code 8, which will signify a munmap error in ds_destroy.
exit:
	MOV X0, #8   // X0 = 8
	B _exit      // exit(8)
