*
*PROCESS LOOP SLEEP
*P1=SLEEP TIME -->A0, P2 =WAKEUP ADDR-->A7
*
SLOOP	.macro	P1,P2
	.if	P1 < 33
	MOVK	:P1:,A0
	.else	
	MOVI	:P1:,A0
	.endif
	MOVI	:P2:,A7,L
	JAUC	PRCLSP
	.endm

