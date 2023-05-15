/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/dataset.c#L254
 *
 * Split a dataset into training and testing sets. This does not shuffle the
 * dataset beforehand, please do it manually first with ds_shuffle if desired.
 * 
 * @param X0 the dataset to split into training and testing sets
 * @param X1 a pointer to an uninitialized dataset, to be filled with
 * 	training examples
 * @param X2 a pointer to an uninitialized dataset, to be filled with
 * 	testing examples
 * @param D0 The proportion of the original set to turn into testing
 * 	examples.
 * Returns nothing.
 */

.global _ds_train_test_split
.align 2

// This function uses two mmaps, one for each of train_set and test_set.
// Most of the other work is just initializing the various fields of train_set
// and test_set. This implementation improves over the ref impl by
// error-checking the two mmap calls.
_ds_train_test_split:
	// We allocate 32 bytes on the stack space, for use as follows:
	// [SP]: LR,
	// [SP + 8]: *original,
	// [SP + 16]: *train_set,
	// [SP + 24]: *test_set
	// We just save everything once in the beginning, and reload these data
	// into registers after calls to e.g. mmap
	SUB SP, SP, #32              // Allocate 32 bytes of stack space
	STR LR, [SP]                 // Store return address in [SP]
	STR X0, [SP, #8]             // Store pointer to original dataset in [SP + 8]
	STR X1, [SP, #16]            // Store pointer to *train* dataset in [SP + 16]
	STR X2, [SP, #24]            // Store pointer to *test* dataset in [SP + 24]

	// Clamping the value of test_ratio (D0). It only makes sense if its between
	// 0 and 1. (And really should only make sense if it is strictly between 0
	// and 1, but that's not implemented)
	FMOV D1, #0.0                // D1 = 0 (load 0 into register just for FMAX)
	FMAX D0, D0, D1              // if (D0 < 0) D0 = 0;
	FMOV D1, #1.0                // Same process for the upper bound
	FMIN D0, D0, D1              // if (D0 > 1) D0 = 1;

	// Computing the integer sizes of the test and train sets based on the
	// provided ratio.
	LDR W3, [X0, #8]             // W3 = original->num_examples.
	SCVTF D1, W3                 // We need to upgrade it to a double for FMUL
	FMUL D0, D0, D1              // D0 = test_ratio * original->num_examples.
	FCVTZS W4, D0                // We take the floor of D0 to get test_size
	STR W4, [X2, #8]             // Store test_size into test_set->num_examples
	SUB W4, W3, W4               // The train_size is just whatever's left over
	STR W4, [X1, #8]             // Store train_size into train_set->num_examples
	
	// Initializing the num_attributes and _mmap_ptr fields of the struct.
	// We set _mmap_ptr to zero because its not possible to deep_destroy a ds
	// created by train_test_split (we just don't store enough size info to do so).
	// So if the user tries to deep_destroy train or test set, they will get a
	// munmap error
	LDR W3, [X0, #12]            // Get num_attributes from original dataset
	STR W3, [X1, #12]            // And copy into train_set
	STR W3, [X2, #12]            // and test_set
	MOV X3, #0                   // Need 0 to be in a register for STR
	STR X3, [X1, #16]            // Zeroing out _mmap_ptr in train_set
	STR X3, [X2, #16]            // and test_set

	// We've now initialized all fields of the train and test structs except for
	// the data **examples field. We handle that now; what follows is just
	// two mmap calls that allocate space for the test and train datasets'
	// examples[] array.
	LDR W4, [X2, #8]             // Get num_examples out of test set
	LSL W4, W4, #3               // test_set->num_examples * sizeof(data*)
	MOV X0, #0                   // Setting up mmap call: first argument NULL
	MOV X1, X4                   // Second argument size required
	MOV X2, #3                   // Third argument: PROT_READ | PROT_WRITE
	MOV X3, #0x1001              // Fourth argument: MAP_SHARED | MAP_ANONYMOUS
	MOV X4, #-1                  // set fd to -1 since we just want space
	MOV X5, #0                   // no offset
	BL _mmap                     // call mmap
	CMP X0, #0                   // error check the returned pointer
	B.LT err_test_mmap           // If MAP_FAILED, exit with correct error code
	LDR X1, [SP, #24]            // Otherwise get the test_set ptr out of stack
	STR X0, [X1]                 // store mmap's return val in test_set->examples

	LDR X1, [SP, #16]            // Same process except for train set.
	LDR W1, [X1, #8]             // get train size
	LSL W1, W1, #3               // multiply by sizeof(data*) to get total size needed
	MOV X0, #0                   // First argument to mmap: NULL
	MOV X2, #3                   // Third argument: PROT_READ | PROT_WRITE
	MOV X3, #0x1001              // Fourth argument: MAP_SHARED | MAP_ANONYMOUS
	MOV X4, #-1                  // set fd to -1
	MOV X5, #0                   // no offset
	BL _mmap                     // call mmap
	CMP X0, #0                   // Error checking again
	B.LT err_train_mmap          // if error, we return with different error code
	LDR X1, [SP, #16]            // Otherwise store it as above
	STR X0, [X1]

	// At this point all fields of both train_set and test_set have been fully
	// initialized, and all that remains is to copy the data* over from the
	// original dataset into the train and test set's examples[] array.
	// We do this in two for loops; X0 is our iterator which we maintain between
	// the two

	MOV X0, #0                   // int i = 0;
	LDR X1, [SP, #24]            // We want test_set->num_examples, so load *test_set
	LDR W3, [X1, #8]             // and then load test_set->test_size

	// It's been used many times before (even in this file), but I want to stress
	// one nuance of the above instruction. We *must* load into W3, not X3.
	// If we load into X3, we will end up reading 8 bytes - the concatenation of
	// both int num_examples and int num_attributes. This will cause SIGSEGV.
	// We _only_ want num_examples, a 4-byte value. So we use 4-byte register.

	LDR X2, [SP, #8]             // Get pointer to original dataset from stack
	LDR X1, [X1]                 // ptr to test_set->examples[0]
	LDR X2, [X2]                 // ptr to original->examples[0]

// First for loop is for initializing test_set->examples
test_for:
	CMP X0, X3                   // i < test_size?
	B.GE end_test_for            // if not, exit for loop
	LSL X4, X0, #3               // X4 = i * sizeof(data*)
	LDR X5, [X2, X4]             // X5 = original->examples[i]
	STR X5, [X1, X4]             // test_set->examples[i] = X5
	ADD X0, X0, #1               // i++
	B test_for                   // go back to condition

// We reach here after filling out all of test_set->examples. We use this space
// between loops to reinitialize some variables for initializing train_set.
end_test_for:
	// No need to touch X0 - that currently has value test_size, exactly what we
	// want
	LDR X2, [SP, #8]             // We'll now be comparing against original->num_examples,
	LDR W6, [X2, #8]             // So we load that value into W6 (still need W3)
	LDR X2, [X2]                 // Set X2 back to ptr to original->examples[0]
	LDR X1, [SP, #16]
	LDR X1, [X1]                 // X1 = ptr to train_set->examples[0]

// Second for loop: filling out train_set->examples
train_for:
	CMP X0, X6                   // i < original->num_examples?
	B.GE end_train_for           // if not, exit the loop
	LSL X4, X0, #3               // X4 = i * sizeof(data*)
	LDR X5, [X2, X4]             // X5 = original->examples[i]
	SUB X4, X0, X3
	LSL X4, X4, #3               // X4 = sizeof(data*) * (i - test_size)
	STR X5, [X1, X4]             // train_set[i - test_size] = X5
	ADD X0, X0, #1               // i++
	B train_for                  // go back to condition

// Now we've finished initializing everything. Nothing left to be done here.
end_train_for:
	LDR LR, [SP]                 // Reload the correct return address
	ADD SP, SP, #32              // deallocate stack space
	RET                          // return

// This label is reached if there is some error that caused mmap for the
// test_set to fail. We just exit with a unique non-zero exit code.
err_test_mmap:
	MOV X0, #16
	B _exit                      // exit(16);

// This label is reached if there is some error that caused mmap for the
// train_set to fail. We just exit with a unique non-zero exit code.
err_train_mmap:
	MOV X0, #17
	B _exit                      // exit(17);
