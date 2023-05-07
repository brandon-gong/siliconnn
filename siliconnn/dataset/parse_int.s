/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/dataset.c#L61
 * 
 * Parse a signed int from the given char**, also consuming the int from the 
 * input. This function has two tasks, one is to actually parse an int value,
 * and the other is to update the char* so that it points to the character right
 * after the int.
 *
 * In the context of the CSV parser, this means typically after calling this the
 * char* will be pointing at a comma or newline character.
 */

.global _parse_int
.align 2

// We make use of the following registers in the code:
// W1: r in the C code - stores the final resulting int from parsing
// W2: sgn in the C code - stores 1 if the sign is positive, -1 if negative
// W3: variously stores *ptr and **ptr, used for cmp and updating
// W4: stores the constant value 10
// We can freely use and modify these registers because they are volatile.
_parse_int:

	// Initializing variables
	MOV W1, #0        // result = 0
	MOV W2, #1        // sign = +1
	MOV W4, #10       // need to store 10 in W4 for MADD later

	LDR X3, [X0]
	LDR W3, [X3]
	BFC W3, #8, #24   // Same trick as consume_past_char to get **X0

	// Dealing with potential negative sign in beginning of parse
	CMP W3, #45       // if(**X0 == '-')
	B.NE while        // if not, skip to the while loop
	NEG W2, W2        // Flip W2 to negative
	LDR X3, [X0]      
	ADD X3, X3, #1
	STR X3, [X0]      // (*X0)++

while:
	LDR X3, [X0]
	LDR W3, [X3]
	BFC W3, #8, #24  // Same trick as above to get **X0

	// This series of two CMPs is used to implement the while loop condition,
	// (**X0 >= '0' && **X0 <= '9')
	CMP W3, #48            // Comparing **X0 with '0'
	B.LT finish           // If its strictly less, its not a digit, exit loop
	CMP W3, #57            // Otherwise, proceed to compare **X0 with '9'
	B.GT finish           // If its strictly greater, again not a digit
	SUB W3, W3, #48        // W3 = (**X0 - '0')
	MADD W1, W1, W4, W3    // result = result * 10 + (**X0 - '0')
	LDR X3, [X0]
	ADD X3, X3, #1
	STR X3, [X0]           // (*X0)++
	B while                // go back to condition of while loop
finish:
	MUL W0, W1, W2         // Store sign*result in the W0, the return register
	RET                    // return
