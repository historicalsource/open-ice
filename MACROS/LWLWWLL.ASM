LWLWWLL	.macro	a1,a2,a3,a4,a5,A6,A7
	.long	:a1:
	.word	:a2:
	.LONG	:a3:
	.WORD	:a4:,:a5:
	.LONG	:A6:,:A7:
	.endm

