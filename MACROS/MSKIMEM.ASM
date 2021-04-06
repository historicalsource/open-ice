*
*	MSKIMEM	bitfield, addr, field size
*	Mask Into Memory the bitfield	(OR into memory)
MSKIMEM	.macro	bits,addr,fs
	MOVE	:addr:,a14,:fs:
	ORI	:bits:,a14
	MOVE	a14,:addr:,:fs:
	.endm

