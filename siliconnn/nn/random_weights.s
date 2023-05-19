/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/nn.c#L37
 *
 * Helper function called by nn_init to randomize all of the weights and biases
 * of a network. Necessary to establish independence between all of the neurons.
 *
 * This routine uses _rand01, whose implementation can be found in
 * util/random.s. It is based off of XorShift64*, and in my testing returns
 * fairly uniformly distributed results.
 * 
 * @param X0 a pointer to the network to randomize weights for.
 * Returns nothing.
 */

.global _random_weights
.align 2

// We need to randomize weights in four places: w01, b1, w12, and b2. For w01,
// we need a nested loop to iterate through all #hidden_size * input_size values;
// for b1 and w12, we only need a single loop to iterate through all of the
// #hidden_size values. To make it simpler, I thus incorporate the inner loop
// of w01 as well as the updates for b1 and w12 into one big for_hidden loop.
// This is the memory setup on the stack:
// [SP + 0]: LR, our return address. LR is overwritten when calling _rand01.
// [SP + 8]: Pointer to the net struct.
// [SP + 16]: Stores i, the iterator of the for_hidden loop
// [SP + 24]: Stores j, the iterator of the for_input loop (for w01)
_random_weights:
	SUB SP, SP, #32              // Allocate stack space per above
	STR LR, [SP]                 // Store return address into [SP]
	STR X0, [SP, #8]             // Store nn pointer into [SP + 8]
	MOV X1, #0                   // int i = 0;
	STR X1, [SP, #16]            // Store this value of i on stack for later
for_hidden:                    // This expects i to be in X1 at start of loop
	LDR X2, [SP, #8]             // Load the pointer to the network into X2...
	LDR W2, [X2, #4]             // ... so we can get X2 = net->hidden_size
	CMP X1, X2                   // i < net->hidden_size?
	B.GE end_for_hidden          // if not, exit the outer loop

	MOV X1, #0                   // Set up for inner loop. int j = 0
	STR X1, [SP, #24]            // store j on the stack as well
for_input:                     // Expects j to be in X1 at start of loop
	LDR X2, [SP, #8]             // Load the pointer to the network into X2...
	LDR W2, [X2]                 // ... so we can get X2 = net->input_size
	CMP X1, X2                   // j < net->input_size?
	B.GE end_for_input           // if not, exit the inner loop

	// We wish to put a random value in net->w01[j * net->hidden_size + i], for
	// all values of j. With this nested loop setup, eventually all weights in w01
	// will be initialized to random values.
	BL _rand01                   // Get a new random number in D0
	LDR X2, [SP, #8]             // We need to get hidden_size again
	LDR W2, [X2, #4]             // Store net->hidden_size into X2
	LDR X0, [SP, #16]            // get i out of stack
	LDR X1, [SP, #24]            // get j out of stack
	MADD X0, X1, X2, X0          // X0 = j * net->hidden_size + i;
	LSL X0, X0, #3               // multiply X0 by sizeof(double)
	LDR X2, [SP, #8]             // Get the net pointer from stack one more time
	LDR X2, [X2, #16]            // this time to load the location of net->w01[0]
	ADD X0, X0, X2               // Add this offset to X0
	STR D0, [X0]                 // net->w01[j * net->hidden_size + i] = rand01();

	ADD X1, X1, #1               // increment j, the inner loop counter
	STR X1, [SP, #24]            // store incremented value back into the stack
	BL for_input                 // loop back to the condition of the inner loop

end_for_input:
	// We've finished filling out the column of random numbers in w01 for this
	// particular value of i. We still have to populate w12[i] and b1[i] with
	// random values as well.
	BL _rand01                   // Get a new random value in D0
	FMOV D2, D0                  // Save in D2 for later. rand01 doesn't modify D2
	BL _rand01                   // Get another new random value in D0
	LDR X1, [SP, #16]            // Get i from stack
	LSL X0, X1, #3               // X0 = i * sizeof(double)

	LDR X2, [SP, #8]             // Want to store first random value in b1[i]
	LDR X2, [X2, #24]            // offsetof(nn, b1) is 24 bytes. X2 points at b1[0]
	ADD X2, X0, X2               // add offset X0, so now X2 points at b1[i]
	STR D2, [X2]                 // store the first RNG value into b1[i]

	LDR X2, [SP, #8]             // Similar process, except this time we load...
	LDR X2, [X2, #40]            // the address of w12[0] into X2 instead of b1
	ADD X2, X0, X2               // Same thing as before, adding the same offset X0
	STR D0, [X2]                 // so we can store the second RNG value in w12[i]

	ADD X1, X1, #1               // increment i, the outer loop counter
	STR X1, [SP, #16]            // store the incremented value back in the stack
	BL for_hidden                // loop back to outer loop condition

end_for_hidden:
	// All that is left to do at this point is to populate net->b2 with a random
	// value, and then cleanup and return.
	BL _rand01                   // Get one last value from the RNG source
	LDR X2, [SP, #8]             // Get pointer to net into X2.
	// Since b2 is stored directly, there's no need to do any extra dereferencing.
	STR D0, [X2, #48]            // offsetof(nn, b2) is 48. Store the random value

	LDR LR, [SP]                 // Prepare to return: reload return address into LR
	ADD SP, SP, #32              // Deallocate stack space
	RET                          // return
