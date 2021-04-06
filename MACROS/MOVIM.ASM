**************************************************************************
*								         *
* MOVIM - MOVE IMMEADIATE VALUE TO MEMORY				 *
* 									 *
* 	MOVIM	IMMEADIATE,MEMORY,FIELD SIZE				 *
*								         *
**************************************************************************
MOVIM	.macro	IMM,MEM,FS
	MOVI	:IMM:,A14
	MOVE	A14,:MEM:,:FS:
	.endm

