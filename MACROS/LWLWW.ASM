LWLWW	.macro	a1,a2,a3,A4,A5
	.long	:a1:
	.word	:a2:
	.long	:a3:
	.WORD	:A4:,:A5:
	.endm
