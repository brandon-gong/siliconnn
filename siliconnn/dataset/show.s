/**
 * Reference Implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/dataset.c#L295
 *
 * Prints a dataset to the terminal, for debugging purposes. Along with
 * the label + attributes for each training example, it also prints
 * out row numbers, which are helpful for making sure we are getting
 * the number of examples in the set that we expect.
 *
 * @param X0 a pointer to the dataset to print.
 * Returns nothing.
 */

.global _ds_show
.align 2

// There is nothing algorithmically difficult about this function, but it is
// one of the hairier ones in terms of the number of different places we need
// to load/store data from and the sheer number of function calls we make.
// In terms of actual logic, though, all we are doing is just iterating through
// each example; for each example, we print its label and then iterate through
// its attributes, printing those out as well.
_ds_show:

	// Since we need to make space for a buffer for _itoa and _dtoa to write into,
	// we need to subtract a fair amount from the stack pointer. The layout will
	// be as such:
	// [SP]: our return address; the value in LR will be overwritten whenever we BL
	// [SP + 8]: Pointer to the dataset; the argument to this function. Never changed
	// [SP + 16]: i, the iterate counter for the for-each-example (outer) loop
	// [SP + 24]: j, the iterate counter for the for-each_attribute (inner) loop
	// [SP + 32]: Pointer to ds->examples[i], so we don't have to keep i in register
	// [SP + 40]: The buffer. This extends all the way up to SP's old value,
	// so right now the buffer is a total of 40 bytes long (plenty of space).
	// Also note that we put buffer at the end of the stack, so if there is some
	// overflow in some very unlikely world, it won't overwrite our other stuff
	// and cause crazy confusing bugs. (probably will just crash)

	SUB SP, SP, #80               // Allocate space on stack as per above
	STR LR, [SP]                  // store correct return address in [SP + 0]
	STR X0, [SP, #8]              // Store pointer &ds in [SP + 8]

	// Setting up for the outer for loop, which will iterate for each example in
	// the dataset.
	MOV X1, #0                    // int i = 0;
	STR X1, [SP, #16]             // also i = 0 in stack; X1 will be overwritten

for_examples:                   // At the start of each iter, we expect X1 to be i
	LDR X2, [SP, #8]              // Get pointer to dataset from the stack
	LDR W3, [X2, #8]              // and then get ds->num_examples
	CMP X1, X3                    // i < ds->num_examples?
	B.GE end_for_examples         // If not, exit the loop

	// Loading ds->examples[i] into [SP, #32]
	LDR X2, [X2]                  // X2 = memory location of ds->examples[0]
	LSL X3, X1, #3                // X3 = i * sizeof(data*)
	ADD X2, X2, X3                // Now X2 = memory location of ds->examples[i]
	LDR X2, [X2]                  // deref once to actually be at ds->examples[i]
	STR X2, [SP, #32]             // store this address in the right place on stack

	// Setting up call for itoa. X1 is still i at this point, so we don't need to
	// worry about that, but we need to have X0 point to the start of the buffer.
	ADD X0, SP, #40               // X0 = buf
	BL _itoa                      // X0 = itoa(buf, i);

	// move X0 (string length) into X2, since its the third argument for `write`.
	MOV X2, X0                    // Third argument to write: length from itoa
	MOV X0, #1                    // First argument to write: STDOUT_FILENO
	ADD X1, SP, #40               // Second argument: buf
	BL _write                     // call write() to print the row index out

	// Printing out the " | " delimiter between the row index and the actual data
	MOV X0, #1                    // Again, first argument is STDOUT_FILENO
	ADR X1, show_delimiters       // Pointer to the .ascii data declared below
	MOV X2, #3                    // Just write the first three characters of that
	BL _write                     // call write() to print " | " out

	// Now we work on printing this example's label out; we need to first get
	// its string representation into a buffer with itoa, and then write that
	// buffer out with write.
	ADD X0, SP, #40               // First argument to itoa, the start of buf
	LDR X1, [SP, #32]             // Get ds->examples[i] from the stack
	LDR W1, [X1]                  // Second argument: ds->examples[i]->label
	BL _itoa                      // call itoa(buf, ds->examples[i]->label)

	MOV X2, X0                    // Again move returned length into third argument
	MOV X0, #1                    // First argument to write: STDOUT_FILENO
	ADD X1, SP, #40               // Second argument: buf
	BL _write                     // call write() to print the example label out

	// Setting up for the inner loop, which will go through each attribute in
	// this example's example[] array and print them out, delimited by commas.
	MOV X1, #0                    // int j = 0;
	STR X1, [SP, #24]             // store j = 0 on stack as well
for_attributes:                 // At the start of each iter, we expect X1 to be j
	LDR X2, [SP, #8]              // Similar to the outer loop, except we check...
	LDR W3, [X2, #12]             // ...against ds->num_attributes instead.
	CMP X1, X3                    // j < ds->num_attributes?
	B.GE end_for_attributes       // if not, exit the inner loop

	LSL X3, X1, #3                // Save j * sizeof(double*), so we can reuse X1

	// Printing the comma delimiter first. 
	MOV X0, #1                    // First argument, you guessed it, STDOUT_FILENO
	ADR X1, show_delimiters       // Again we will be printing from show_delimiters
	ADD X1, X1, #3                // But this time skipping past the " | "
	MOV X2, #1                    // and only printing one character, the comma
	BL _write                     // write(STDOUT_FILENO, ",", 1);

	// We now want to print out the j-th attribute. First we call dtoa to load
	// its string representation into the buffer, and then we call write.
	ADD X0, SP, #40               // First argument to dtoa: buf
	LDR X2, [SP, #32]             // Get ds->examples[i] out of the stack
	LDR X2, [X2, #8]              // X2 = location of ds->examples[i]->example[0]
	ADD X2, X2, X3                // Now we see why we saved X3 = j * sizeof(double*)
	LDR D0, [X2]                  // D0 = ds->examples[i]->example[j]
	MOV X1, #2                    // Third argument: precision = 2 decimal places
	BL _dtoa                      // call dtoa

	// We now have the stringified representation of this attribute in buf,
	// So we just want to print it out.
	MOV X2, X0                    // Move length from dtoa into third argument
	MOV X0, #1                    // First argument: STDOUT_FILENO
	ADD X1, SP, #40               // Second argument: buf
	BL _write                     // call write() to print the j-th attribute out

	// We are finished with this iteration of the inner loop. Now we set up for
	// the next iteration of the loop
	LDR X1, [SP, #24]             // Get j back out from the stack
	ADD X1, X1, #1                // increment it
	STR X1, [SP, #24]             // and store its incremented value back in stack
	B for_attributes              // loop back to the condition of inner loop

end_for_attributes:
	// At this point, we have fully printed out the index, label, and attributes
	// of the i-th example. All that remains to do is print out a newline so the
	// next example starts on the next line and then set up for the next loop
	MOV X0, #1                    // First argument to write: STDOUT_FILENO
	ADR X1, show_delimiters       // Again we will be printing from show_delimiters
	ADD X1, X1, #4                // Except skip past the " | ,"
	MOV X2, #1                    // and only print one character from there
	BL _write                     // write(STDOUT_FILENO, "\n", 1);

	LDR X1, [SP, #16]             // Get i back out from the stack
	ADD X1, X1, #1                // increment it
	STR X1, [SP, #16]             // and store its incremented value back in stack
	B for_examples                // loop back to the condition of outer loop

end_for_examples:
	// We've finished printing all of the examples out in the dataset, so there's
	// nothing more to be done.
	LDR LR, [SP]                  // Reload correct return address into LR
	ADD SP, SP, #80               // Deallocate stack space
	RET                           // return

// This one show_delimiters string (stored in section .text) contains
// " | ", which is printed between the row index and label,
// ",", printed between label and each attribute, and
// "\n", printed after each example is fully printed.
// We just pick and choose the start and length we want to print from this string
show_delimiters: .ascii " | ,\n"
