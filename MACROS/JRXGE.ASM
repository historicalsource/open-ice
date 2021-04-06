*
*JUMP RELATIVE IF Rd.X >= Rs.X AFTER A CMPXY
JRXGE	.macro	P1
	JRXNN	P1.S
	.endm

