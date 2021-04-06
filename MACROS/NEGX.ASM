**************************************************************************
*								         *
* NEGX - MACRO TO NEGATE THE X PART OF A REGISTER			 *
* 									 *
* 	NEGX	REG							 *
* 									 *
* NOTE: TRASHES A14							 *
*								         *
**************************************************************************
NEGX	.MACRO	REG
	CLR	A14
	MOVX	:REG:,A14
	NEG	A14
	MOVX	A14,:REG:
	.ENDM

