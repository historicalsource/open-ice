LWWLLLWL	.macro	a1,a2,a3,a4,a5,A6,A7,A8
	.long	:a1:
	.word	:a2:,:a3:
	.LONG	:a4:,:a5:,:a6:
	.WORD	:A7:
	.LONG	:A8:
	.endm


