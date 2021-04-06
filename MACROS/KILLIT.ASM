*
*KILL PROCESS(ES)
*P1=ID-->A0,P2=MASK-->A1
*
KILLIT	.macro	P1,P2
	MOVI	:P1:,A0
	MOVI	:P2:,A1
	CALLA	KILALL
	.endm

