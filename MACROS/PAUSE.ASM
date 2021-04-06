*
*	TIMED PAUSE
*
PAUSE	.macro	TIME,REG1,REG2
	movi	:TIME:>>10,:REG1:
lbl1?:	movi	0400h,:REG2:
lbl2?:	nop
	dsjs	:REG2:,lbl2?
	move	:REG2:,@WDOG_BONE,W
	dsjs	:REG1:,lbl1?
	.endm




