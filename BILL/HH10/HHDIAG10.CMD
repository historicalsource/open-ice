/*	MAIN linker command file					*/
-e SETUP			/* entry point of program		*/
-f 0xFFFF			/* fill unspecified memory with value	*/
-o HHDIAG.rlo			/* specify output file			*/
-m HHDIAG.map			/* map file				*/
-r				/* relocatable file			*/

HHMENU.OBJ		/* MENU PROCESSING			*/
HHDTST.OBJ		/* DIAGNOSTIC ROUTINES			*/
HHDUTL.OBJ		/* DIAG UTILITIES			*/
HHCMOS.OBJ		/* RANDOM ROUTINES			*/
HHCOIN.OBJ		/* COINAGE HANDLING ROUTINES		*/
HHWORD.OBJ		/* WORD SUBSTITUTIONS FOR STRINGS	*/
HHSYSFNT.OBJ		/* SYSTEM FONT IN PROGRAM ROM		*/
HHADJ.OBJ		/* GAME ADJUSTMENTS, LINK THIS LAST!!!	*/

MEMORY        			/* set up memory for sdb board */
{
	SCRATCH:	org = 0x01000000,	len = 0x400000
	ROM:		org = 0xFF800000,	len = 0x7a0000
	ROM2:		org = 0xFFFF6F00,	len = 0x8D00
	TRAP31:		org = 0xFFFFFC00,	len = 0x400
	IROM:		org = 0x02000000,	len = 0x400000
}

SECTIONS       /* linker sections directive */
{
	VECTORS: {}	> TRAP31
	IMAGES:	{}	> IROM
	GROUP:
	{
		OFIXED: {}
		.BSS: {}
		.bss: {}
	} > SCRATCH
	GROUP:
	{	
		.text: {}
		.TEXT: {}
		.data: {}
		.DATA: {}
	} > ROM
}
