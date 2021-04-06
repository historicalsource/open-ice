LWLWWWL	.macro	a1,a2,a3,A4,A5,A6,A7
	.long	:a1:
	.word	:a2:
	.long	:a3:
	.WORD	:A4:,:A5:,:A6:
	.long	:A7:
	.endm

