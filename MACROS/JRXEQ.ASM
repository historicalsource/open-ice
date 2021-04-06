*
*JUMP RELATIVE IF Rd.X = Rs.X AFTER A CMPXY
JRXEQ	.macro	P1
	JRXZ	P1.S
	.endm

