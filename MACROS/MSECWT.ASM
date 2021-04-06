**************************************************************************
*								         *
* 	MSECWT								 *
* 									 *
* 	Macro to delay the given number of micro-seconds.		 *
* 									 *
* 	DELAY = Number micro-seconds to wait				 *
* 									 *
* 	Note: Trashes A14						 *
*								         *
**************************************************************************
MSECWT	.macro	DELAY
	MOVI	(:DELAY:*MICRO_SECOND)/2,A14	;Load the time
	DSJS	A14,$				;And wait it out
	.endm
