/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/util.c#L38
 *
 * Converts a double value, positive or negative, into a string, putting it in
 * the given buffer. The number of decimal places after the decimal point
 * can be specified by adjusting the precision argument.
 * @param X0 the buffer to store the stringified double in
 * @param D0 the double to stringify
 * @param X1 the desired precision, i.e. the number of places after the decimal
* 	point
 * @returns the length of the stringified double.
 */

.global _dtoa
.align 2

// Printing doubles is notoriously harder than it looks, but I am not too 
// concerned about precision. We won't be dealing with scientific notation,
// or infinities, or NaN in this implementation. This function relies on itoa
// for handling the integral part, and handles the fractional part on its own.
_dtoa:
	MOV X2, X0                   // Same as itoa, save buf to X2
	FCMP D0, #0.0                // Special case: zero is easy (same as itoa)
	B.NE handle_negative         // If not, skip to handle_negative
	MOV X3, #48                  // else (if 0) load '0' into register for STRB
	STRB W3, [X2]                // Store '0' as the first byte of the buffer
	MOV X0, #1                   // set n = 1
	RET                          // return

// If the number we are given is nonzero, we actually have to work. We allocate
// 4 double-words of stack space, for the following purposes:
// [SP]: LR, the return address
// [SP + 8]: *buf, the pointer to the beginning of the buffer we write to
// [SP + 16]: precision, the number of digits after decimal point
// [SP + 24]: isneg, a flag that is 0 if the number is positive, 1 if negative
handle_negative:
	SUB SP, SP, #32              // Allocate stack space, as per above
	MOV X4, #0                   // X4 is isneg.
	B.GT get_int_part            // Using same FCMP, if positive, skip to printing
	MOV X4, #1                   // Otherwise, it is negative, so set isneg = 1
	MOV X3, #45                  // load a '-' into X3
	STRB W3, [X2]                // store it as first character in return buffer
	FNEG D0, D0                  // and negate the input, making it positive

// Again, we are just using itoa for handling the integral part of the number,
// so this is mostly just setting up for the call to itoa. Note that we don't
// store D0 on the stack, since we know for sure itoa doesn't touch it.
get_int_part:
	STR LR, [SP]                 // Storing values as per above; LR in 1st slot
	STR X0, [SP, #8]             // pointer to start of buffer in second slot
	STR X1, [SP, #16]            // precision in third slot
	STR X4, [SP, #24]            // isneg in last slot

	// First argument to itoa is the buf* (we advance it by one element if
	// negative so itoa doesn't overwrite the '-' we stored earlier), second
	// argument is the int itself to stringify
	ADD X0, X0, X4               // increments X0 if negative, else does nothing
	FCVTZS X1, D0                // Floor D0 and store result in X1
	BL _itoa                     // Call itoa

	// X0 now holds the length of the integral part we just stringified, excluding
	// the potential negative sign
	LDR X2, [SP, #24]            // get isneg back out from the stack
	LDR X1, [SP, #8]             // and also the original start of the buffer
	ADD X0, X0, X2               // make X0 the true length by accounting for negative
	MOV X3, #46                  // load '.' (decimal point) into X3
	STRB W3, [X1, X0]            // Store the '.' right after the stringified int
	ADD X0, X0, #1               // increment X0, the string length

	// We're finished stringifying the integral part, so we can get rid of it.
	// We do this by rounding D0 down to the nearest integer and then subtracting
	// that integer away, leaving the fractional part only.
	FRINTZ D1, D0                // D1 = floor(D0)
	FSUB D0, D0, D1              // D0 = D0 - D1

	// Setting up for the while loop: we get precision back from the stack
	// and loop until precision is zero, decrementing it each iteration
	LDR X3, [SP, #16]
while:
	CBZ X3, endloop              // If no more digits left to write, skip to end
	FMOV D1, #10.0               // Else prepare to get the next decimal digit out
	FMUL D0, D0, D1              // Pop next digit into ones place; D0 *= 10
	FCVTZS X2, D0                // Floor D0, leaving just that digit behind in X2
	ADD X2, X2, #48              // Convert to ASCII digit; X2 += '0'
	STRB W2, [X1, X0]            // store it at the next slot in buf
	ADD X0, X0, #1               // increment string length
	FRINTZ D1, D0                // Floor D0 again, this time leaving it as a float
	FSUB D0, D0, D1              // Same trick as before to get rid of integral part
	SUB X3, X3, #1               // one less digit of precision left to write
	B while                      // loop

// Now X0 already contains the length of the final string, and we've already
// written everything we need into the buf, so there is nothing left to be done
// here except deallocating space and returning
endloop:
	LDR LR, [SP]                 // Reload the correct return address into LR
	ADD SP, SP, #32              // Deallocate stack space
	RET                          // return
