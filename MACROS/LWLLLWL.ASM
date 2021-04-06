LWLLLWL	.macro	a1,a2,a3,a4,a5,A6,A7
	.long	:a1:
	.word	:a2:
	.LONG	:a3:,:a4:,:a5:
	.WORD	:A6:
	.LONG	:A7:
	.endm

