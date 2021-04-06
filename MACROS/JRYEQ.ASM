*
*JUMP RELATIVE IF Rd.Y = Rs.Y AFTER A CMPXY
JRYEQ	.macro	P1
	JRYZ	P1.S
	.endm

