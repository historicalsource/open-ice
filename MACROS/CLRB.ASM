**************************************************************************
*								         *
* CLRB - CLEAR MEMORY BYTE						 *
* 	CLRM	ADDR							 *
* A14 DESTROYED, 'A' REGISTER TYPE INSTRUCTIONS ONLY			 *
*								         *
**************************************************************************
CLRB	.macro	P1
	CLR	A14
	MOVB	A14,:P1:
	.endm

