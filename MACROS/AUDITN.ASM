**************************************************************************
*								         *
* AUDITN - INCREMENT A CMOS AUDIT COUNTER N TIMES.			 *
* 	AUDIT	AUDIT_LOC,N						 *
* NOTE: TRASHES A0,A1 							 *
*								         *
**************************************************************************
AUDITN	.macro	P1,P2
	MOVI	:P1:,A0
	MOVI	:P2:,A1
	CALLA	AUD
	.endm

