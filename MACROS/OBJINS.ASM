*	OBJINS	
*	Insert block located in A8 onto the object list
*		>A0 trashed
OBJINS	.macro
	move	a8,a0
	calla	INSOBJ
	.endm

