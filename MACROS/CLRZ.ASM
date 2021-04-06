*
*CLR THE Z BIT
*	CLRZ
* STATUS BITS:
*		N Unaffected
*		C Unaffected
*		Z 0
*		V Unaffected
* NOTE: A14 IS SET TO 1
*
CLRZ	.macro
	CLR	A14
	NOT	A14
	.endm

