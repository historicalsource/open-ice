**************************************************************************
*								         *
* CMPIXY - MACRO TO COMPARE AN IMMEADIATE VALUE WITH THE CMPXY INSTRUCTI *
* 	CMPIXY	IMM,REG							 *
*								         *
**************************************************************************
CMPIXY	.macro	IMM,REG
	MOVI	:IMM:,A14
	CMPXY	A14,:REG:
	.endm
