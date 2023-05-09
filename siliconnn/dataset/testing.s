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

.global _ds_load
.align 2

_ds_load:
	// [SP] LR
	// [SP + 8] fd
	// [SP + 16] num_examples
	// [SP + 24] num_attributes
	// [SP + 32] X3 *ds
	// [SP + 40] struct stat
	// [SP + 40] st_size
	// [SP + 48] file_ptr
	// [SP + 56] parse_ptr
	// [SP + 64] end

	// total space needed for alloc: 192 B (stat is 144UL starting at SP+40
	// then rd up to multiple of 16 so we dont SIGBUS)
	/*SUB SP, SP, #192

	SUB X1, X1, #1
	SUB 
*/

/*
	SUB SP, SP, #176
	STR LR, [SP]
	STR X0, [SP, #8]
	STR X3, [SP, #16]

	SUB W1, W1, #1 // num_examples
	SUB W2, W2, #1 // num_attributes
	STP W1, W2, [X3, #8] // storing num_examples, num_attributes

	LSL X2, X2, #3
	ADD X2, X2, #16
	MUL X1, X1, X2 // X1 = block_size, lost num_examples

	MOV X0, #0 // first arg null, second arg block_size already in place
	MOV X2, #0x3 // PROT_READ | PROT_WRITE
	MOV X3, #0x1001 // MAP_SHARED | MAP_ANONYMOUS
	MOV X4, #-1
	MOV X5, #0
	BL _mmap
	CMP X0, #-1
	B.EQ err_data_mmap

	LDR X3, [SP, #16]
	STR X0, [X3, #16]

	LDR X0, [SP, #8]
	MOV X1, #0 // O_RDONLY
	BL _open
	CMP X0, #0
	B.LT err_open

	ADD X1, SP, #24
	BL _fstat
	CBNZ X0, err_fstat

	LDR X0, [SP, #104]
	LDR LR, [SP]
	
	ADD SP, SP, #176
	RET

err_data_mmap:
	MOV X0, #10
	B _exit

err_open:
	MOV X0, #11
	B _exit

err_fstat:
	MOV X0, #12
	B _exit
 */