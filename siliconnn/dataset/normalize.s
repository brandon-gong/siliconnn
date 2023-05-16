/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/dataset.c#L318
 *
 *
 * Normalizes all attributes in the dataset to have mean of 0 and standard
 * deviation of 1. This generally boosts accuracy as no particular attribute
 * gets weighted unfairly.
 *
 * @param X0 a pointer to the dataset to normalize.
 * Returns nothing.
 */

.global _ds_normalize
.align 2

// Memory management-wise, this is kind of the opposite of ds_show; we don't
// need to allocate any stack space or call any external functions, so we can
// get by without touching the stack pointer at all. Instead, we rely heavily on
// use of the volatile registers, as follows:
// X0: Stores the pointer to the dataset to normalize.
// X1: Stores ds->num_attributes, for convenience (no need to load from X0 always)
// X2: Stores ds->num_examples
// X3: Stores i, which iterates through each attribute in the dataset
// X4: Stores j, the iterator for each of the three passes
// X5: Stores the location of ds->examples[j]->example[i]
// X6: temporary scratch register
// X7: Stores return address
// D0: Stores mean of i-th attribute
// D1: Stores standard deviation of i-th attribute
// As mentioned above, we do three passes for each attribute: the first one
// to compute the mean, the second one to calculate the standard deviation, and
// the third one to update all of the values.
_ds_normalize:
	LDR W1, [X0, #12]                 // Save ds->num_attributes in X1, as above
	LDR W2, [X0, #8]                  // Save ds->num_examples in X2
	MOV X7, LR                        // Save return address in X7

	// Outer loop: iterating over each attribute in the dataset
	MOV X3, #0                        // int i = 0;
for_each_attribute:
	CMP X3, X1                        // i < ds->num_attributes?
	B.GE end_for_each_attribute       // if not, exit the outer loop

	FMOV D0, #0.0                     // Initialize the mean to zero
	FMOV D1, #0.0                     // Initialize std to zero
	
	// First pass: Calculating the mean to the i-th attribute, by summing over
	// all elements in the column and dividing by the total number of examples.
	MOV X4, #0                        // int j = 0;
for_mean:
	CMP X4, X2                        // j < ds->num_examples?
	B.GE end_for_mean                 // if so, exit this inner loop

	// This helper function sets X5 to the location of ds->examples[X4]->example[X3],
	// and sets D2 to the actual value. It doesn't modify X0-X4, X7, D0, or D1.
	// See the bottom of the file for more documentation.
	BL load_examples_ji               // D2 = ds->examples[X4]->example[X3]
	FADD D0, D0, D2                   // mean += ds->examples[X4]->example[X3]
	ADD X4, X4, #1                    // j++
	B for_mean                        // Loop back to the start of this inner loop
end_for_mean:
	// At this point, we've summed all of the attributes in this column; now to
	// finish computing the mean we just need to divide it by num_examples
	UCVTF D2, X2                      // Cast ds->num_examples to double for FDIV
	FDIV D0, D0, D2                   // mean /= ds->num_examples


	// Finished computing the mean, now do the second pass - computing the
	// standard deviation. This is \sqrt{\frac{\sum_i=0^n(x_i-mean)^2}{n}}.
	MOV X4, #0                        // int j = 0;
for_std:
	CMP X4, X2                        // j < ds->num_examples?
	B.GE end_for_std                  // if so, exit this inner loop
	BL load_examples_ji               // D2 = ds->examples[X4]->example[X3]
	FSUB D2, D2, D0                   // D2 - mean
	FMUL D2, D2, D2                   // (D2 - mean)^2
	FADD D1, D1, D2                   // std += (D2 - mean)^2
	ADD X4, X4, #1                    // j++
	B for_std                         // Loop back to condition of this inner loop
end_for_std:
	// we have \sum_i=0^n(x_i-mean)^2, now we just need to divide it by the
	// population size and take the square root at the end
	UCVTF D2, X2                      // Again cast ds->num_examples to double
	FDIV D1, D1, D2                   // Divide the summed value by num_examples
	FSQRT D1, D1                      // Take the square root.

	// Finally, we have the mean and standard deviation in hand; we do one more
	// pass to update everything (for each cell, subtract the mean and divide by
	// the standard deviation)
	MOV X4, #0                        // int j = 0;
for_update:
	CMP X4, X2                        // j < ds->num_examples?
	B.GE end_for_update               // if so, exit this inner loop

	// Load address of ds->examples[X4]->example[X3] into X5, and value into 
	// D2.
	BL load_examples_ji

	FSUB D2, D2, D0                   // Subtract the mean from this cell
	FDIV D2, D2, D1                   // divide by standard deviation
	STR D2, [X5]                      // Store it back to where we got it
	ADD X4, X4, #1                    // j++
	B for_update                      // Loop back to condition of this inner loop

end_for_update:
	// We have finished all three passes and have successfully normalized this
	// attribute; move on to the next one
	ADD X3, X3, #1                    // i++
	B for_each_attribute              // loop back to condition of the outer loop

end_for_each_attribute:
	// At this point, we are totally done; just load the return address back into
	// LR and return.
	MOV LR, X7
	RET

// Small helper function to load the address of ds->examples[X4]->example[X3]
// into X5, and the value into D2. It assumes the pointer to the dataset to be
// in X0, and will overwrite the value of X6. It doesn't touch X7, which is why
// we can call this function without storing the return address on the stack.
load_examples_ji:
	LDR X5, [X0]                      // X5 = address of ds->examples[0]
	LSL X6, X4, #3                    // X6 = X4 * sizeof(data*)
	ADD X5, X5, X6                    // now X5 is the address of ds->examples[X4]
	LDR X5, [X5]                      // Dereference once
	LDR X5, [X5, #8]                  // X5 = address of ds->examples[X4]->example[0]
	LSL X6, X3, #3                    // X6 = X3 * sizeof(double*)
	ADD X5, X5, X6                    // now X5 is the address of ds->examples[X4]->example[X3]
	LDR D2, [X5]                      // Load the actual value into D2
	RET                               // return to caller
