**************************************************************************
*								         *
* THETA_N: normalizes register to 0<= r < 2pi				 *
*								         *
**************************************************************************
THETA_N	.macro	REG
	move	:REG:,:REG:
	jrnn	tns1?
tnl1?	addi	XD3600,:REG:
	jrn	tnl1?
tns1?	cmpi	XD3600,:REG:
	jrlt	tns2?
	subi	XD3600,:REG:
	jruc	tns1?
tns2?
	.endm
