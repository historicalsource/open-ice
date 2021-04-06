*
*JUMP RELATIVE IF Rd.X < Rs.X AFTER A CMPXY
JRXLT	.macro	P1
	JRXN	P1.S
	.endm

