**************************************************************************
*								         *
* CREATEP - MACRO TO CREATE A PRIORITY PROCESS				 *
* 									 *
* 	CREATEP	PROCESS_ID, PROCESS_ADDRESS				 *
*								         *
**************************************************************************
CREATEP	.macro	P1,P2
 	MOVI	:P1:,A1
	MOVI	:P2:,A7,L
	CALLA	GETPPRC
	.endm

