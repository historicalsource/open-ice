LWLLLW	.macro	a1,a2,a3,a4,a5,A6
	.long	:a1:
	.word	:a2:
	.LONG	:a3:,:a4:,:a5:
	.WORD	:A6:
	.endm


