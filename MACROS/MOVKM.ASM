**************************************************************************
*								         *
* MOVKM - MOVE CONSTANT VALUE TO MEMORY					 *
* 									 *
* 	MOVKM	CONSTANT,MEMORY,FIELD SIZE				 *
*								         *
**************************************************************************
MOVKM	.macro	KON,MEM,FS
	MOVK	:KON:,A14
	MOVE	A14,:MEM:,:FS:
	.endm

