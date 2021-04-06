**************************************************************************
*								         *
* AUDIT - INCREMENT A CMOS AUDIT COUNTER ONCE.				 *
* 	AUDIT	AUDIT_LOC						 *
* NOTE: TRASHES A0 							 *
*								         *
**************************************************************************
AUDIT	.macro	P1
	MOVI	:P1:,A0
	CALLA	AUD1
	.endm

