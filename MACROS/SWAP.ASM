* Swap contents of two registers that reside in same file

SWAP	.macro R1,R2
	XOR    :R1:,:R2:
	XOR    :R2:,:R1:
	XOR    :R1:,:R2:
	.endm

