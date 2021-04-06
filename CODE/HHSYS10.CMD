/*	MAIN linker command file					*/
-e SETUP			/* entry point of program		*/
-f 0xFFFF			/* fill unspecified memory with value	*/
-o HHSYSTEM.rlo			/* specify output file			*/
-m HHSYSTEM.map			/* map file				*/
-r				/* relocatable file			*/

HHTABLES.OBJ		/* tables for scale */
HHUTIL.OBJ		/* UTILITIES			*/
HHPALL.OBJ		/* PALETTE ROUTINES		*/
HHPROC.OBJ		/* MULTI-TASKER			*/
HHSND.OBJ		/* SOUND PROCESSOR		*/
HHUART.OBJ		/* UART HANDLER			*/
HHMATH.OBJ		/* SIN, COS FUNCS		*/
HHTEXT.OBJ		/* TEXT PROCESSING ROUTINES	*/
HHMISC.OBJ		/* MISCELLANEOUS ROUTINES	*/
HHFADE.OBJ		/* TODD'S PALETTE FADER		*/
HHTV.OBJ		/* TODDVIEW HOOKS		*/
IMGPAL.OBJ		/* PALETTE DATA			*/
IMGTBL.OBJ		/* GLOBAL IMAGE HEADERS		*/

MEMORY        			/* set up memory for sdb board */
{
	SCRATCH:	org = 0x01000000,	len = 0x3f7300
	SCRATCH2:	org = 0x013F7300,	len = 0x008D00
	ROM:		org = 0xFF800000,	len = 0x7a0000
	ROM2:		org = 0xFFFF6F00,	len = 0x8D00
	TRAP31:		org = 0xFFFFFC00,	len = 0x400
	IROM:		org = 0x02000000,	len = 0x400000
}

SECTIONS       /* linker sections directive */
{
	VECTORS:  {} 	> TRAP31
	IMAGES:   {}    > IROM
	GROUP:
	{
		OFIXED: {}
		.BSS: {}
		.bss: {}
	} > SCRATCH
	.text: {} > ROM
	.TEXT: {} > ROM
	.data: {} > ROM
	.DATA: {} > ROM
}

