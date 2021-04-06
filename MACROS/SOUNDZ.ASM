**************************************************************************
*								         *
* SOUNDZ - Make a sound using the GSP Sound Processor			 *
* 	 based on the current Z position of the object.			 *
* 									 *
* A8 = Ptr to object from which to reference Z position			 *
*								         *
**************************************************************************
SOUNDZ	.macro SNDNUM
	MOVI :SNDNUM:,A0
	CALLA ONESND_Z
	.endm

