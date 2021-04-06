*	COORSTO	reg
*	Place corrdinates from *a8() into REG's y:x format
*		>a14 trashed
COORSTO	.macro	reg
	move	*a8(OXPOS),:reg:,W
	move	*a8(OYPOS),a14,W
	sll	16,a14
	movy	a14,:reg:
	.endm

