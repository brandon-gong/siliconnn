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

//.global _ds_load
//.align 2

//_ds_load:
	// TODO : our first real behemoth function, going to be a serious
	// challenge to make it work

.global _get_fsize
.align 2

_get_fsize:
	SUB SP, SP, #160
	STR LR, [SP]
	MOV X1, #0 // O_RDONLY
	BL _open
	CMP X0, #0
	B.LT err_open

	ADD X1, SP, 8
	BL _fstat
	//CBNZ X0, err_fstat

	LDR X0, [SP, #104]
	LDR LR, [SP]
	
	ADD SP, SP, #160
	RET

err_open:
	MOV X0, #11
	MOV X16, #1
	SVC #0x80

err_fstat:
	//MOV X0, #12
	MOV X16, #1
	SVC #0x80
