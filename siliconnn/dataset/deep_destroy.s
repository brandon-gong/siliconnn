/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/dataset.c#L20
 *
 * Destroy a `dataset`, freeing everything - including the underlying data -
 * back to the OS. If you have multiple datasets over the same block of data,
 * calling ds_deep_destroy will invalidate all of them. This function
 * automatically calls ds_destroy to cleanup the `examples` list as well.
 * 
 * @param X0 a pointer to the dataset to destroy.
 * Returns nothing.
 */

.global _ds_deep_destroy
.align 2

// Very similar process to ds_deep_destroy, we need to compute the size of the
// data we want to free. After computing the block size and storing in W1,
// we set X0 to point to the _mmap_ptr, and then we call munmap.
_ds_deep_destroy:
	LDR W1, [X0, #12]              // W1 = ds->num_attributes
	LSL W1, W1, #3                 // W1 *= 8 (8 bytes per attribute)
	ADD W1, W1, #4                 // W1 += 4 (example is attributes + int label)
	LDR W2, [X0, #8]               // W2 = ds->num_examples
	MUL W1, W1, W2                 // W1 *= W2 (so now W1 is total block size)

	// We need to keep track of X0, our pointer to the dataset, for later, since
	// we will be invoking ds_destroy to cleanup the examples list as well.
	MOV X2, X0                     // X2 = X0
	LDR X0, [X0, #16]              // X0 = ds->_mmap_ptr
	MOV	X16, #73                   // syscall code for munmap is 73
	SVC	#0x80                      // munmap(X0, W1)
	CBNZ X0, exit  // If syscall returned nonzero code, exit with error
	
	// We now prepare to invoke ds_destroy. We need to put the original dataset
	// pointer back into X0 so its the first argument, and also *store our return
	// address (in LR) so we know where to jump back to later*.
	MOV X0, X2                     // Restore the original pointer back to X0
	MOV X2, LR                     // Save the return address for *this* function
	BL _ds_destroy                 // Jump to ds_destroy, overwriting LR
	MOV LR, X2                     // restore the return address for this function
	RET                            // return

// This is very similar to the exit in ds_destroy; we reach here if something
// went wrong with munmap, in which we exit with the appropriate exit code (9).
exit:
	MOV X0, #9   // X0 = 9
	MOV X16, #1  // syscall code for exit is 1
	SVC #0x80    // exit(X0)
