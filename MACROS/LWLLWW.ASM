LWLLWW	.macro	a1,a2,a3,A4,A5,A6
	.long	:a1:
	.word	:a2:
	.long	:a3:,:A4:
	.WORD	:A5:,:A6:
	.endm

