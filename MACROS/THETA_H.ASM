**************************************************************************
*								         *
* THETA_H: normalizes register to -pi= r <= pi				 *
*								         *
**************************************************************************
THETA_H	.macro	REG
	move	:REG:,:REG:
tnl1?	cmpi	-XD1800,:REG:
	jrgt	tns1?
	addi	XD3600,:REG:
	jruc	tnl1?
tns1?	cmpi	XD1800,:REG:
	jrle	tns2?
	subi	XD3600,:REG:
	jruc	tns1?
tns2?
	.endm

