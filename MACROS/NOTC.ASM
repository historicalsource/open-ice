*
*COMPLEMENT THE C BIT
*	NOTC
* STATUS BITS:
*		N Unaffected
*		C Complemented
*		Z Undefined
*		V Unaffected
* NOTE: A14 IS SET TO 1
*
NOTC	.macro
	GETST	A14
	XORI	CBIT,A14		;COMPLEMENT C
	PUTST	A14	
	.endm

