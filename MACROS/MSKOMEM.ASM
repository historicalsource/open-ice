*
*	MSKOMEM	bitfield, addr, field size
*	Mask Out of Memory the bitfield	(ANDNI into memory)
MSKOMEM	.macro	bits,addr,fs
	MOVE	:addr:,a14,:fs:
	ANDNI	:bits:,a14
	MOVE	a14,:addr:,:fs:
	.endm

