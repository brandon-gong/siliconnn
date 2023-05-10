/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/util.c#L70
 *
 * This file contains a trio of three functions which together satisfy the
 * random needs of the program - a seeding function, so the program generates
 * different results on each run, a rand01 function, which generates a double
 * in the range (0, 1), and a rand_ul function, which generates a random
 * unsigned long.
 *
 * All of these functions take no parameters.
 * - seed() sets the random seed based on the system time (in seconds). Nothing
 *   is returned.
 * - rand01() returns a double in D0 between 0 and 1. This is used for assigning
 *   random weights and biases on NN initialization. It is merely a convenience
 *   function over rand_ul, dividing the result by ULONG_MAX.
 * - rand_ul() returns an unsigned long in X0 between 0 and ULONG_MAX. This is
 *   used for shuffling datasets by Fisher-Yates.
 */

.global _seed
.global _rand01
.global _rand_ul
.align 2

// rand_ul, the core functionality of this set of random subroutines, is an
// assembly implementation of the very simple and high quality XorShift64*
// pseudo-random number generator. The reference implementation is at
// https://en.wikipedia.org/wiki/Xorshift#xorshift*.
_rand_ul:
	// This pair of instructions, ADRP + [LDR/STR], is used throughout this file
	// to load/store the state from the .data section in memory. We do this
	// because we have to maintain state between runs of the function.
	// Otherwise, this wouldn't be much of an RNG.

	ADRP X2, state@PAGE             // Loading state from memory: get address of page
	LDR X0, [X2, state@PAGEOFF]     // get address of state specifically and load

	// Begin the implementation of XorShift64* here
	LSR X1, X0, #12                 // X1 = X0 >> 12
	EOR X0, X0, X1                  // X0 ^= X1
	LSL X1, X0, #25                 // X1 = X0 << 25
	EOR X0, X0, X1                  // X0 ^= X1
	LSR X1, X0, #27                 // X1 = X0 >> 27
	EOR X0, X0, X1                  // X0 ^= X1

	// We want to do X0 * 0x2545F4914F6CDD1D. We need to load 0x2545F4914F6CDD1D
	// into a register so we can MUL with it, but we can't do it in one go,
	// because we can only load 16-bit immediates at a time. Thus we need to do
	// it in 4 chunks
	MOV X1, #0xDD1D                 // Lowest 16 bits
	MOVK X1, #0x4F6C, LSL #16       // Next 16. MOVK = don't clear out lower bits
	MOVK X1, #0xF491, LSL #32       // etc
	MOVK X1, #0x2545, LSL #48       // Now X1 has the full constant in it
	MUL X0, X0, X1                  // Perform the multiplication.

	// X0 is our new state and starting point for next time this function runs,
	// so we store it much how we loaded it in the beginning of the function
	ADRP X2, state@PAGE
	STR X0, [X2, state@PAGEOFF]     // Locate location of state in mem and STR
	RET                             // return


// rand01 is just a thin wrapper over rand_ul; we obtain a random long from
// rand_ul and divide it by ULONG_MAX.
_rand01:
	// Store our link register's current address in prep for BL-ing to rand_ul
	// Yes, X8 is a volatile register, but we know for sure that rand_ul doesn't
	// touch X8, which makes this ok. Is this bad style? probably.
	MOV X8, LR
	BL _rand_ul                     // Get our random long in X0
	UCVTF D0, X0                    // convert its unsigned repr to fp register
	
	// Pretty easy to get ulong_max; just zero out the register, invert all of
	// the bits, and there we go. No sign stuff to worry about of course.
	MOV X0, #0                      // X0 = 0 (64 0 bits)
	MVN X0, X0                      // X0 = ~X0 (64 1 bits)
	UCVTF D1, X0                    // Also convert this to fp, unsigned of course
	FDIV D0, D0, D1                 // Do the division, storing result in D0
	MOV LR, X8                      // Restore LR back to correct address
	RET                             // return

// seed() sets the seed based on the current system time, in seconds. This is
// not critical for generating random numbers _within_ runs, but it certainly
// is necessary for generating random numbers _between_ runs. If you start your
// PRNG off with the same seed each run, you'll get the same sequence of "random"
// numbers back, by nature of it being a deterministic function.
_seed:
	// We need to make stack space for a `struct timespec` (16 bytes) and the
	// address from our link register (8 bytes). So we move the stack ptr by 32
	// bytes (to keep it 16-byte aligned)
	SUB SP, SP, #32
	STR LR, [SP]                    // Store LR for later

	// Setting up + calling clock_gettime
	MOV X0, #0                      // First argument: CLOCK_REALTIME
	ADD X1, SP, #8                  // Second argument: ptr to struct timespec
	BL _clock_gettime               // call clock_gettime()
	CBNZ X0, exit                   // If something went wrong, skip to exit label
	LDR X0, [SP, #8]                // X0 = current system time, in seconds
	ADRP X2, state@PAGE
	STR X0, [X2, state@PAGEOFF]     // store it as starting value for state
// The below label can be reached either through a syscall error to clock_gettime
// or just through natural flow of execution. Unlike other syscalls, it's not
// too critical if this fails. The state will just start from 1 as normal.
// We can just return normally, no need to panic
exit:
	LDR LR, [SP]                    // Restore return address from stack
	ADD SP, SP, #32                 // Deallocate stack space
	RET	                            // return

// This directive is critical so that state is placed in modifiable area in
// memory. Otherwise, we'll get a SIGBUS when we try to store to it.
.data
state: .quad 1                    // Allocate 8 bytes of space, default val 1
