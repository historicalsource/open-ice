*
*SET THE Z BIT
*	SETZ
* STATUS BITS:
*		N Unaffected
*		C Unaffected
*		Z 1
*		V Unaffected
* NOTE: A14 IS CLEARED
*
SETZ	.macro
	CLR	A14
	.endm

