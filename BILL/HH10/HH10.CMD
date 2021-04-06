/*	MAIN linker command file					*/
-e WARMSET			/* entry point of program		*/
-f 0xFFFF			/* fill unspecified memory with value	*/
-o HH.out			/* specify output file			*/
-m HH.map			/* map file				*/
-s				/* Kill the symbol table		*/

/*   KEEP .OBJs ALPHABETICAL!!  */

HH.OBJ			/* INITS AND INTS		*/
HHAFUNC.OBJ		/* GENERAL ANIMATION FUNCTIONS  */
HHC.OBJ			/* IMAGE HANDLER		*/
HHD.OBJ			/* IMAGE HANDLER		*/
HHRAM.OBJ		/* RAM ALLOCATONS		*/
HHPUCK.OBJ		/* puck movement */
HHA.OBJ			/* switches */
HHPLAYER.OBJ		/* player block ram code */
HHCONTRL.OBJ		/* player object creation and control */
HHTABLES.OBJ		/* tables for scale */
HHGAME.OBJ		/* game state control code */
HHSCRIPT.OBJ		/* player movement scripts */
HHSCORE.OBJ		/* score stuff */
HHHIGHER.OBJ		/* greater control routines */
HHATTRCT.OBJ		/* attract mode */
HHSELECT.OBJ		/* team/player selection code/data */
HHSHOW.OBJ		/* sound effect routines and shows */
HHTIMER.OBJ		/* score and timer routines/display */
HHDRONE.OBJ		/* drone code */
HHSYSTEM.RLO		/* LINK IN THE SYSTEM STUFF	*/
HHDIAG.RLO		/* LINK IN THE DIAGNOSTICS CODE */

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