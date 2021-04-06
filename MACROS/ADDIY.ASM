**************************************************************************
*								         *
* ADDIY - ADD WORD TO Y PORTION OF A REGISTER				 *
* 									 *
* 	ADDIY	WORD,REGISTER						 *
*								         *
**************************************************************************
ADDIY	.macro	IMM,REG
	MOVI	:IMM:,A14
	SLL	16,A14
	ADDXY	A14,:REG:
	.endm

