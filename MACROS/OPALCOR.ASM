*	OPALCOR	pal
*	Stuff the Object in *A8 with the pallette 'pal'
*	and initialize the coordinates
OPALCOR	.macro	pal
	movi	:pal:,a1
	move	a8,a0
	calla	FPSTFOBJ
	calla	InitCoor
	.endm

