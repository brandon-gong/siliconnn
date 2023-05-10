/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/dataset.c#L240
 *
 * Shuffle a dataset in place, changing the order of its examples, using
 * Fisher-Yates. This should be used before train-test-split, and is
 * automatically applied between epochs during training.
 * 
 * @param ds the dataset to shuffle.
 * Returns nothing.
 */

.global _ds_shuffle
.align 2

// This is a very trivial and direct usage of Fisher-Yates, since all we are
// doing is moving pointers around, and not touching the underlying data at all.
// So there's no need to copy memory around.
_ds_shuffle:
	// We need to allocate 3 double-words of space:
	// [SP] is where we store the return address for this function
	// [SP+8]: address of ds->examples[0], for convenience later (don't have to
	// reach into the ds struct every time)
	// [SP+16]: `i`, the iterator in the for loop
	SUB SP, SP, #32                 // Allocate 32 bytes (4 double words)
	STR LR, [SP]                    // Store return address (so we can call rand)
	LDR X1, [X0]                    // X1 = address of ds->examples[0]
	STR X1, [SP, #8]                // store into stack
	LDR W1, [X0, #8]                // i = ds->num_examples
	SUB X1, X1, #1                  // i--;

for:
	CMP X1, #0                      // i > 0?
	B.LE endloop                    // if so, exit the for loop
	STR X1, [SP, #16]               // store i on stack in prep for function call
	BL _rand_ul                     // X0 = rand_ul() (random unsigned long)
	LDR X1, [SP, #16]               // get i back from the stack
	ADD X2, X1, #1                  // X2 = (i + 1)

	// We want to compute rand_ul() % (i + 1) = X0 % X2. There is no "modulus"
	// instruction, but we can achieve this by the following computation:
	UDIV X3, X0, X2                 // X3 = X0 / X2 (floor division)
	MSUB X0, X2, X3, X0             // j = X0 - (X2 * X3) (reusing register X0)

	// We now wish to swap ds->examples[X0] with ds->examples[X1].
	LSL X2, X1, #3                  // X2 = i * sizeof(double)
	LSL X0, X0, #3                  // X0 = j * sizeof(double)
	LDR X3, [SP, #8]                // load address of ds->examples[0] from stack
	ADD X2, X2, X3                  // X2 = address of ds->examples[i]
	ADD X0, X0, X3                  // X0 = address of ds->examples[j]
	LDR X4, [X0]                    // tmp = ds->examples[j]
	// Store tmp into ds->examples[i]; the old value of ds->examples[i] gets
	// loaded into X5.
	SWP X4, X5, [X2]
	STR X5, [X0]                    // now store old value (X5) into ds-examples[j]

	// Finished swapping; decrement i and loop
	SUB X1, X1, #1
	B for

// We reach here when we are done shuffling the array, so we just reload
// return address into LR and return
endloop:
	LDR LR, [SP]                    // Reload correct return address into LR
	ADD SP, SP, #32                 // Deallocate stack memory
	RET                             // return
