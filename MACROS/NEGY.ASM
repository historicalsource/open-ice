**************************************************************************
*								         *
* NEGY - MACRO TO NEGATE THE Y PART OF A REGISTER			 *
* 									 *
* 	NEGY	REG							 *
* 									 *
* NOTE: TRASHES A14							 *
*								         *
**************************************************************************
NEGY	.MACRO	REG
	CLR	A14
	MOVY	:REG:,A14
	NEG	A14
	MOVY	A14,:REG:
	.ENDM

