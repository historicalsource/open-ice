*
*JUMP RELATIVE IF Rd.Y <> Rs.Y AFTER A CMPXY
JRYNE	.macro	P1
	JRYNZ	P1.S
	.endm

