*	ONSCRN	label
*	if the object (*a8) is not on screen control will be transfered to
*	'label'
ONSCRN	.macro	label
	movb	*A8(OFLAGS+B_ONSCR-7),A14
	jrnn	:label:
	.endm

