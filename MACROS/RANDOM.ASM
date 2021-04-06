*	RANDOM	limit
*	Will give a random number from 0 to (limit - 1) in A0
*		>A0 thrashed
RANDOM	.macro	limit
	.if	limit < 33
	MOVK	:limit:,a0
	.else
	MOVI	:limit:,a0
	.endif
	CALLA	RAND0
	.endm

