*
*JUMP RELATIVE IF Rd.Y < Rs.Y AFTER A CMPXY
JRYLT	.macro	P1
	JRYN	P1.S
	.endm

