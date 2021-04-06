*
*JUMP RELATIVE IF Rd.X <> Rs.X AFTER A CMPXY
JRXNE	.macro	P1
	JRXNZ	P1.S
	.endm

