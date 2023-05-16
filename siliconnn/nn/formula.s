/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/nn.c#L4
 *
 * This file contains two small functions that implement simple formulas used
 * by the neural network implementation.
 *
 * One is sigmoid, our old friend; σ(x) = 1 / (1 + e^-x).
 * The other one is a function for computing the memory requirements for the
 * network (the space needed to store its activations, weights, and biases),
 * called compute_mem_reqs.
 */

.global _sigmoid
.global _compute_mem_reqs
.align 2

// Sigmoid implementation.
// As noted in the README, we call the C standard library exp() here; this
// is purely because I can't figure out how to achieve it using arm64
// instructions. Because of this, we need to store the return address on the
// stack.
_sigmoid:
	SUB SP, SP, #16           // Allocate stack space
	STR LR, [SP]              // Store return address on stack
	FNEG D0, D0               // -x
	BL _exp                   // e^-x
	FMOV D1, #1.0             // Load 1.0 into D1 for FADD and FDIV
	FADD D0, D0, D1           // 1 + e^-x
	FDIV D0, D1, D0           // 1 / (1 + e^-x). Done computing sigmoid(D0)
	LDR LR, [SP]              // Restore return address into link register
	ADD SP, SP, #16           // Deallocate stack space
	RET                       // return

// Function for computing memory requirements.
// This formula is used fairly often throughout, so just decided to pull it into
// a helper function. It is derived by
// |w01| + |b1| + |o1| + |w12|
// = input_size * hidden_size + hidden_size + hidden_size + hidden_size
// = hidden_size * (input_size + 1 + 1 + 1)
// = hidden_size * (input_size + 3)
// and then we multiply the result by sizeof(double) to get the total memory
// requirement in bytes (for mmap).
_compute_mem_reqs:
	ADD X0, X0, #3            // input_size + 3
	MUL X0, X0, X1            // hidden_size * (input_size + 3)
	LSL X0, X0, #3            // sizeof(double) * hidden_size * (input_size + 3)
	RET                       // return
