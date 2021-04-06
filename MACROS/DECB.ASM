**************************************************************************
*								         *
* 	DECB								 *
* 									 *
* 	Decrement BYTE sized memory.					 *
* 									 *
* 	Usage: DECB ADDR						 *
* 									 *
* 	Note: Destroys A14						 *
*								         *
**************************************************************************
DECB	.macro	P1
	MOVB	:P1:,A14
	DEC	A14
	MOVB	A14,:P1:
	.endm



