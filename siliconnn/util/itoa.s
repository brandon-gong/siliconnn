/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/util.c#L8
 *
 * Converts a POSITIVE integer to a string, putting it into the given buffer.
 * We don't support negative ints, simply because we don't need them!
 * Does not zero-pad.
 * @param X0 the buffer to store the stringified int in
 * @param X1 the int to stringify
 * @returns the length of the stringified int, in X0
 */

.global _itoa
.align 2

// Your very typical itoa function: continually take mod 10's to get
// each individual digit out, starting from the ones place and going up
// and storing it in the *buf. Then, once we've gotten all of the digits,
// we reverse the resulting array so that the ones place comes at the
// end.
_itoa:
	// Basic initializations: we move the char *buf pointer away from the
	// return register so we don't have to do any juggling later, initialize
	// the return register (which will be the length of the string) to 0,
	// and put our radix into X4 for UDIV and MSUB later
	MOV X2, X0                   // Move the pointer to X2
	MOV X0, #0                   // Set n = 0
	MOV X4, #10                  // store radix into register

	// In the special case where the int to stringify is 0, we just
	// set the first character in the buffer to '0' and return string length
	// 1.
	CBNZ X1, while               // if X1 nonzero, skip special case
	MOV X3, #48                  // else (if 0) load '0' into register for STRB
	STRB W3, [X2]                // Store '0' as the first byte of the buffer
	MOV X0, #1                   // set n = 1
	RET                          // return n

// Otherwise, do the algorithm as described earlier.
while:
	CBZ X1, endwhile             // if X1 = 0, no more digits to get
	UDIV X5, X1, X4              // Else we want X1 % 10; first do X5 = floor(X1 / 10)
	MSUB X3, X5, X4, X1          // Then do X1 - (X5 * 10). Now X3 is the next digit
	ADD X3, X3, #48              // convert to ascii; X3 += '0'
	MOV X1, X5                   // X1 = floor(X1/10) (get rid of that digit)
	STRB W3, [X2, X0]            // store the digit we just got into the string
	ADD X0, X0, #1               // increment index (aka length of string)
	B while                      // loop

// Once we are here, we know we ran out of digits to get from the string. All
// we have to do is reverse the order of the characters so ones place comes last
// instead of first etc
endwhile:
	LSR X5, X0, #1               // Setting up for for loop; X5 = n/2
	MOV X1, #0                   // int i = 0;
for:
	CMP X1, X5                   // i < n/2?
	B.GE endfor                  // if not, exit the loop
	LDRB W3, [X2, X1]            // W3 (tmp) is the i-th character from the string
	SUB X4, X0, X1
	SUB X4, X4, #1               // Computing n - i - 1 (index to swap with)
	ADD X4, X2, X4               // Using that, compute memory location to swap with
	// SWPB will store buf[i] into buf[n-i-1], and "pop" the old value out from
	// memory back into W3.
	SWPB W3, W3, [X4]            // Do swap
	STRB W3, [X2, X1]            // Store the old value of buf[n-i-1] into buf[i]
	ADD X1, X1, #1               // i++;
	B for                        // loop back to condition

// Done reversing the string. Didn't mess with LR, and no stack space to
// deallocate, so we can just return immediately.
endfor:
	RET
