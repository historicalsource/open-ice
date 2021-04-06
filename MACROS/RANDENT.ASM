**************************************************************************
*								         *
* RANDENT - GET A RANDOM ENTRY FROM A TABLE.				 *
* 	RANDENT TABLE,COUNT,SHIFT,LENGTH				 *
*								         *
**************************************************************************
RANDENT .macro	TABLE,COUNT,SHIFT,LENGTH
	MOVK	:COUNT:,A0
	CALLA	RAND0
	SLL	:SHIFT:,A0
	ADDI	:TABLE:,A0
	MOVE	*A0,A0,:LENGTH:
	.endm

