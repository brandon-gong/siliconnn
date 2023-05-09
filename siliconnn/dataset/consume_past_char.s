/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/dataset.c#L49
 *
 * In our CSV parser we frequently find ourselves needing to throw away parts
 * of the input, e.g. when we want to skip the header row, or we've finished
 * parsing a number and want to skip past the comma or newline. This function
 * moves the pointer through the CSV string data until its past the char c we
 * specify.
 *
 * @param X0 the ptr to move
 * @param X1 the rightmost limit of X0; this is a stop condition in case there
 * 	are no more of c to consume. Without this, we may sigfault
 * @param X2 the character to consume past.
 */

.global	_consume_past_char 
.align 2

// Here I use a sequence of LDR-ADD-STR to perform (*ptr)++. I think this is
// how it has to be done, not sure if there is a better way
_consume_past_char:
	LDR X3, [X0]                // X3 = *X0
	LDR W3, [X3]                // X3 = *X3 (Double deref, so X3 is just the char)

	// This is the tricky bit: we have to clear out the higher ordered bits of
	// W2 and W3 before CMP, because they may contain trash data (and we only 
	// care about the lowest order 8 bits since we are comparing chars)
	BFC W2, #8, #24
	BFC W3, #8, #24
	CMP W3, W2                  // while(**X0 != X2)
	B.EQ end_loop               // if they are equal, jump to the end
	MOV X3, #1
	STADD X3, [X0]      // (*X0)++
	CMP X3, X1                  // if (*X0 == X1)
	B.NE _consume_past_char     // If not at end, go back to beginning of loop
	RET                         // else we hit the end, return

// If we've reached here, that means we've found a matching character. Thus
// we need to increment *X0 one more time (since we are consuming *past* the
// given char) and then return
end_loop:
	MOV X3, #1
	STADD X3, [X0]              // (*X0)++
	RET                         // return
