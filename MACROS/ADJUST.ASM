**************************************************************************
*								         *
* ADJUST - GET THE VALUE OF A CMOS GAME ADJUSTMENT.			 *
* 	ADJUST	ADJUST_LOC						 *
* RETURNS:								 *
* A0 = VALUE OF GAME ADJUSTMENT						 *
*								         *
**************************************************************************
ADJUST	.macro	P1
	MOVI	:P1:,A0
	CALLA	GET_ADJ
	.endm

