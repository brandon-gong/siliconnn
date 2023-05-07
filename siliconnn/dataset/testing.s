/*
extern int ds_dbl_val(int val);
.global _ds_dbl_val
.align 2

_ds_dbl_val:
	ADD W0, W0, W0
	ret
*/
/*
//extern int ds_num_examples(dataset *ds);
.global	_ds_num_examples 
.align 2

_ds_num_examples:
	LDR W1, [X0, #12]
	MOV W0, W1
	ret
	*/

/*
// extern long myrand();
.global _myrand
.align 2

_myrand:
	LSR seed #12 // X0 = seed >> 12
	EOR X0 seed X0  // X0 = seed ^ (seed >> 12)
	LSL X1 X0 #25
	EOR X0 X1 X0
	LSR X1 X0 #27
	EOR X0 X1 X0
	STR X0, seed
	RET

.seed: .quad 1
*/


/* 
.global _inc_pointer
.align 2

_inc_pointer:
	LDR W1, [X0]
	ADD W1, W1, #1
	STR W1, [X0]
	RET
*/

.global _parse_data
.align 2

_parse_data:
	// TODO, need to learn about alloc stack space for saving volatile registers
	// and LR before calling other functions