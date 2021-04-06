**************************************************************************
*								         *
* MOVIY - MOVE WORD TO Y PORTION OF A REGISTER				 *
* 									 *
* 	MOVIY	WORD,REGISTER						 *
*								         *
**************************************************************************
MOVIY	.macro	IMM,REG
	MOVI	:IMM:*10000H,A14
	MOVY	A14,:REG:
	.endm

