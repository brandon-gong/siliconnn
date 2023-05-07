/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/dataset.c#L93
 * 
 * Parse a signed double from the given char**, also consuming the double from the 
 * input. This function has two tasks, one is to actually parse a double value,
 * and the other is to update the char* so that it points to the character right
 * after the double.
 *
 * In the context of the CSV parser, this means typically after calling this the
 * char* will be pointing at a comma or newline character.
 *
 * @param X0 a pointer to the char* to update
 */

.global _parse_double
.align 2

// Many parallels can be drawn between this function's implementation and
// parse_int. We also include some extra logic for dealing with the decimal
// point, including keeping track of an exponent after we encounter the first
// decimal point. The number is converted to an integer in a very similar
// fashion as parse_int, and at the end we divide it by 10^exponent to get the
// final parsed value.
_parse_double:
	FMOV D0, #0                 // r in the C source; will hold our final retval
	FMOV D2, #10                // Again store radix in register for FMADD and FMUL
	MOV X1, #1                  // X1 is the sign, either +1 or -1.

	// These are new compared to parse_int; X2 is a flag that is 0 if we haven't
	// seen a decimal point yet, and 1 if we have, and X3 is the exponent, i.e.
	// the number of digits we've seen since the decimal
	MOV X2, #0                  // is_exp in the C source
	MOV X3, #0                  // exp in the C source

	// Same trick as consume_past_char to get **X0. We dereference twice with
	// LDR, and then we use BFC to clear out the trash bits that lay above the
	// char we care about
	LDR X4, [X0]
	LDR W4, [X4]
	BFC W4, #8, #24

	// Dealing with potential negative sign in the beginning. Same as parse_int
	CMP W4, #45                 // if(**X0 == '-')
	B.NE while                  // If the first char is not '-', skip to the loop
	NEG X1, X1                  // Else flip sgn to negative, and..
	LDR X4, [X0]      
	ADD X4, X4, #1
	STR X4, [X0]                // ...increment *X0 to point to the next char.

while:
	// Get **X0. I stored in X4 instead of W4, probably unnecessarily, but it
	// doesn't really matter
	LDR X4, [X0]
	LDR X4, [X4]
	BFC X4, #8, #56

	CMP X4, #46                 // Does **X0 == '.'?
	B.NE not_decimal_pt         // If not, skip past the next 3 instructions

	// If X2 (our seen-decimal-already) flag is already set, we can't have two
	// decimal points, so the valid double we parsed ends here.
	CBNZ X2, end_while

	MOV X2, #1                  // Else set the seen-decimal flag,
	B endif                     // then skip past the logic for handling digits.

not_decimal_pt:               // This label is only reached if **X0 != '.'
	CMP X4, #48                 // Is **X0 < '0'?
	B.LT end_while              // If so, not a digit, so end parse.
	CMP X4, #57                 // Likewise, is **X0 > '9'?
	B.GT end_while              // If so, not a digit, so end parse.
	SUB X4, X4, #48             // Subtract **X0 - '0' to get actual digit value

	// X4 now stores the digit's value (int between 0 and 9); we need to move this
	// int value to a FP register in preparation for FMADDD. SCVTF does this, and
	// converts the int to the corresponding FP representation properly
	SCVTF D1, X4                // D1 = (double) (**X0 - '0')
	FMADD D0, D0, D2, D1        // D0 = D0 * 10 + (**X0 - '0'), same as parse_int
	// Increment the exponent by 0 if we haven't seen the decimal point yet,
	// and 1 if we've already seen it.
	ADD X3, X2, X3

// This is the last line inside the while loop; we could have gotten here in
// two cases (both '.' or digit would lead here). We just increment char* to
// point at the next char in the string and loop
endif:
	LDR X4, [X0]
	ADD X4, X4, #1
	STR X4, [X0]                // (*X0)++
	B while                     // Go back to the beginning of the while loop

// This is after the end of the first while loop; we actually have another
// mini while loop here that repeatedly divides D0 by the radix according to
// the exponent we stored.
end_while:
	CBZ X3, finish              // If exp is 0, no need to divide by 10 anymore
	SUB X3, X3, 1               // otherwise decrement exp and do
	FDIV D0, D0, D2             // D0 = D0 / 10
	B end_while

finish:                       // Last thing to do is to perform sgn*r
	SCVTF D1, X1                // Move the sign flag to a FP register for FMUL
	FMUL D0, D0, D1             // D0 = D0 * sign
	RET                         // return D0
