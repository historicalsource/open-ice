LWWLL	.macro	a1,a2,a3,a4,a5
	.long	:a1:
	.word	:a2:,:a3:
	.LONG	:a4:,:a5:
	.endm


