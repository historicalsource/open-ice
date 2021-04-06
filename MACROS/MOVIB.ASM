**************************************************************************
*								         *
* MOVIB - MOVE IMMEADIATE VALUE TO MEMORY BYTE				 *
* 									 *
* 	MOVIM	IMMEADIATE,MEMORY					 *
*								         *
**************************************************************************
MOVIB	.macro	IMM,MEM
	MOVI	:IMM:,A14
	MOVB	A14,:MEM:
	.endm

