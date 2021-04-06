LWLL	.macro	a1,a2,a3,A4
	.long	:a1:
	.word	:a2:
	.long	:a3:
	.LONG	:A4:
	.endm
