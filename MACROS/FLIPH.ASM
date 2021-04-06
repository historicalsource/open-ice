*	FLIPH
*	Flip the object located in *a8() horizontally
*	as warranted by call
FLIPH	.macro
	move	*a8(OFLAGS),a14,W
	xori	M_FLIPH,a14
	move	a14,*a8(OFLAGS),W
	.endm

