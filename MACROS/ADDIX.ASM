**************************************************************************
*								         *
* ADDIX - ADD WORD TO X PORTION OF A REGISTER				 *
* 									 *
* 	ADDIX	WORD,REGISTER						 *
*								         *
**************************************************************************
ADDIX	.macro	IMM,REG
	MOVI	:IMM:,A14,W
	ADDXY	A14,:REG:
	.endm
