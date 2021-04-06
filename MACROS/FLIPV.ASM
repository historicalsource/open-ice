*	FLIPV
*	Flip the object located in *a8() vertically
*	as warranted by call
FLIPV	.macro
	move	*a8(OFLAGS),a14,W
	xori	M_FLIPV,a14
	move	a14,*a8(OFLAGS),W
	.endm

