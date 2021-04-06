LWWLLL	.macro	a1,a2,a3,A4,A5,a6
	.long	:a1:
	.word	:a2:,:a3:
	.long	:A4:,:A5:,:a6:
	.endm

