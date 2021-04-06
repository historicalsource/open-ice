**************************************************************************
*								         *
* MOVIX - MOVE WORD TO X PORTION OF A REGISTER				 *
* 									 *
* 	MOVIX	WORD,REGISTER						 *
*								         *
**************************************************************************
MOVIX	.macro	IMM,REG
	MOVI	:IMM:,A14,W
	MOVX	A14,:REG:
	.endm

