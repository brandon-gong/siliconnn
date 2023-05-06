.global _ds_destroy
.align 2

_ds_destroy:
	LDR W1, [X0, #8]
	LSL W1, W1, #3
	LDR X0, [X0]
	MOV	X16, #73
	SVC	#0x80
	CBNZ X0, ds_destroy_exit
	RET

ds_destroy_exit:
	MOV X0, #8
	MOV X16, #1
	SVC #0x80
