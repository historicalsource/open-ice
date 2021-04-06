**************************************************************************
*								         *
* LOCKON - Macro to lock up based on the Status bits.			 *
* 	 where "op" = Z,NZ,EQ,UC, etc.					 *
*								         *
**************************************************************************
LOCKON	.macro	op
	JR:op:	lab?
	JRUC	lab2?
lab?
	CALLA	DUMPPRINT
lab2?
	.endm

