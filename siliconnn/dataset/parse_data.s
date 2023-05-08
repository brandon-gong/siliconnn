/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/dataset.c#L138
 *
 * Parses a single row of CSV data into a `data` struct (as defined in
 * dataset.h - simply an example and its corresponding label), also consuming
 * this row from the input. We can repeatedly call this to parse a CSV
 * row-by-row; this is done by ds_load.
 * 
 * @param X0 a pointer to the char* CSV data; the char* will be modified by
 * 	this function to point to the first character after the next newline.
 * @param X1 a pointer to the `struct data` to populate with the values from
 * 	this row of CSV data.
 * @param X2 the number of attributes the example has; the row should have a 
 * 	total of X2 + 1 columns
 * @param X3 the rightmost bound of *X0, i.e. the end of the CSV file.
 * 	This will prevent segfaults in _some_ cases where we have syntax errors in
 * 	the CSV file, but not always.
 * Returns nothing.
 */

.global _parse_data
.align 2

// This function really is quite simple, as the bulk of the serious logic has
// been done in parse_int, parse_double, and consume_past_char. Most of the work
// we will do here is loading/storing pointers and making calls to these
// functions.
_parse_data:

	// X0 - X17 are volatile registers, so when we make function calls their
	// values may (and probably will) be overwritten. Thus we save the stuff we
	// care about onto the stack before jumping to subroutines.
	SUB	SP, SP, #48                   // Reserve 6 8-byte chunks of memory

	// Here's the plan for those 6 chunks:
	// [SP]: the char**
	// [SP + 8]: the data*
	// [SP + 16]: num_attributes
	// [SP + 24]: char *end
	// [SP + 32]: our return address, which we need to reload before calling RET
	//            so that we jump back to the right place after this function
	// [SP + 40]: int i, our iterator in the for loop

	STP X0, X1, [SP]                  // Store X0 -> [SP], X1 -> [SP + 8]
	STP X2, X3, [SP, #16]             // Store X2 -> [SP + 16], X3 -> [SP + 24]
	STR LR, [SP, #32]                 // Store current value of LR in [SP + 32]
	
	// X1 currently is the pointer to the data struct. Relative to the start of
	// the struct, the first element of the double[] is stored 16 bytes away
	// (because sizeof(data) is 16, and the array is stored directly after in
	// memory)
	ADD X2, X1, #16                   // X2 = data pointer + sizeof(data)
	STR X2, [X1, #8]                  // data->example = (double*) X2

	// Happily, our X0 already comes being set to the **ptr, which is exactly the
	// first and only argument to parse_int. So we don't need to do any work
	// setting up this function call.
	BL _parse_int                     // parse_int(ptr)
	LDR X1, [SP, #8]                  // X1 might be overwritten, reload old data*
	STR X0, [X1]                      // data->label = the int we just parsed

	// We've initialized all of the fields of the struct, now we just need to
	// add all of the elements of the double[]. This is the `for` loop in the
	// reference implementation.
	MOV X0, #0                        // int i = 0;
for:
	LDR X1, [SP, #16]                 // reload num_attributes back into X1
	CMP W0, W1                        // is i < num_attributes?
	B.GE endfor                       // if not, exit the for loop

	// In preparation for the call to consume_past_char, we need to:
	STR X0, [SP, #40]                 // Save i on stack (X0 will be overwritten)
	LDR X0, [SP]                      // First argument: load ptr into X0
	LDR X1, [SP, #24]                 // Second argument: load end into X1
	MOV X2, #44                       // Third argument: load ',' into X2
	BL _consume_past_char             // consume_past_char(ptr, end, ',')

	// X0 might have been overwritten by consume_past_char, so just reload it
	LDR X0, [SP]                      // First argument: load ptr into X0
	BL _parse_double                  // double D0 = parse_double(ptr)

	// We've just parsed the next double value from the input; we now need to
	// store it. Where we store it depends on the index, and we saved that on
	// the stack earlier:
	LDR X0, [SP, #40]                 // Reload i from the stack
	LDR X1, [SP, #8]                  // X1 = data pointer
	LDR X1, [X1, #8]                  // X1 = *(data->example)
	// So now X1 points to the space for the first element in the double[].
	LSL X2, X0, #3                    // X2 = i * sizeof(double) = i << 3
	ADD X1, X1, X2                    // Now X1 points to the i-th element
	STR D0, [X1]                      // Store our parsed double at X1
	ADD X0, X0, #1                    // i++
	B for                             // Loop back to the condition

// We reach here after parsing num_attributes doubles and successfully
// populating our data struct with the values from this CSV row. All that's
// left to do now is place the ptr at the first char in the next row, so we
// consume past the newline in this row.
endfor:
	// Setting up for a call to consume_past_char, much like before
	LDR X0, [SP]                      // First argument: load ptr into X0
	LDR X1, [SP, #24]                 // Second argument: load end into X1
	MOV X2, #10                       // Third argument: load '\n' into X2
	BL _consume_past_char             // consume_past_char(ptr, end, '\n')
	
	// The instruction address we were supposed to jump back to from this function
	// has long been overwritten by the many BL's we've done, but we saved it
	// in the stack!
	LDR LR, [SP, #32]                 // Reload correct return address into LR
	ADD SP, SP, #48                   // Deallocate stack space for this function
	RET                               // return
