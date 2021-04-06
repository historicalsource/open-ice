**************************************************************************
*								         *
* SLEEPSW - MACRO TO MAKE A CALL TO SLEEP_SWITCH.  SLEEP FOR THE	 *
* 	  GIVEN AMOUNT OF TICKS. IF A SWITCH IS HIT DURING, BRANCH.	 *
* 									 *
* 	SLEEPSW	TICKS,BRANCH						 *
*								         *
**************************************************************************
SLEEPSW	.macro	TICKS,BRANCH
	MOVI	:TICKS:,A0
	JSRP	SLEEP_SWITCHX
	JRNZ	:BRANCH:
	.endm

