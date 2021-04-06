**************************************************************************
*								         *
* MOVKB - MOVE CONSTANT VALUE TO MEMORY BYTE				 *
* 									 *
* 	MOVIM	CONSTANT,MEMORY						 *
*								         *
**************************************************************************
MOVKB	.macro	CON,MEM
	MOVK	:CON:,A14
	MOVB	A14,:MEM:
	.endm


