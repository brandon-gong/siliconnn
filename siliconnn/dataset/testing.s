/* 
.global _testexp
.align 2

_testexp:
	SUB SP, SP, #16
	STR LR, [SP]
	BL _exp
	LDR LR, [SP]
	ADD SP, SP, #16
	RET
*/

