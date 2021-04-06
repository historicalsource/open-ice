/*	MAIN linker command file					*/
-e WARMSET			/* entry point of program		*/
/* -e POWERUP */			/* entry point of program		*/
-f 0xFFFF			/* fill unspecified memory with value	*/
-o HH.out			/* specify output file			*/
-m HH.map			/* map file				*/
-s				/* Kill the symbol table		*/

/*   KEEP .OBJs ALPHABETICAL!!  */

HH.OBJ			/* INITS AND INTS		*/
HHAFUNC.OBJ		/* GENERAL ANIMATION FUNCTIONS  */
HHC.OBJ			/* IMAGE HANDLER		*/
HHD.OBJ			/* IMAGE HANDLER		*/
HHRT.OBJ		/* rink table for plot */
HHRAM.OBJ		/* RAM ALLOCATONS		*/
HHPUCK.OBJ		/* puck movement */
HHA.OBJ			/* switches */
HHPLAYER.OBJ		/* player block ram code */
HHCONTRL.OBJ		/* player object creation and control */
HHCONTR2.OBJ		/* more player control */
HHGCTRL.OBJ		/* GOALIE CONTROL STUFF */
HHGAME.OBJ		/* game state control code */
HHPICK.OBJ		/* INITIAL AND TEAM SELECT */
HHPICK2.OBJ		/* MORE INITIAL AND TEAM SELECT */
HHPUP.OBJ		/* POWER-UPS */
HHSCORE.OBJ		/* score stuff */
HHHIGHER.OBJ		/* greater control routines */
HHATTRCT.OBJ		/* attract mode */
HHSCR_CH.OBJ		/* checking/falling down/stealing scripts */
HHSCR_FN.OBJ		/* script global functions */
HHSCR_MS.OBJ		/* scripts, miscellaneous */
HHSCR_SH.OBJ		/* shooting and passing scripts */
HHSCRSH2.OBJ		/* shooting and passing scripts */
HHSCR_SK.OBJ		/* skating, standing, gliding scripts */
HHSCR_CB.OBJ		/* celebrations scripts */
HHSELECT.OBJ		/* team/player selection code/data */
HHSTATS.OBJ		/* INTERMISSION STATISTICS */
HHSTABLE.OBJ		/* tables for hhselect.asm */
HHSTABL2.OBJ		/* tables for hhselect.asm */
HHSTABL3.OBJ		/* tables for hhselect.asm (heads) */
HHSTABL4.OBJ		/* tables for hhselect.asm (heads) */
HHSTABL5.OBJ		/* tables for hhselect.asm (heads) */
HHSHOW.OBJ		/* sound effect routines and shows */
HHTIMER.OBJ		/* score and timer routines/display */
HHTG.OBJ		/* TONIGHT'S GAME */
HHNDRONE.OBJ		/* new drone code */
HHGDRONE.OBJ		/* GOALIE drone code */
HHGSCR.OBJ		/* GOALIE SCRIPTS */
HHGSCR2.OBJ		/* GOALIE SCRIPTS PART 2 */
HHGSCRF.OBJ		/* GOALIE SCRIPT FUNCTIONS */
HHCX.OBJ		/* initial manipulation cmos stuff */
HHRSCR.OBJ		/* ? */
HHSPEECH.OBJ		/* announcer speech processor */
HHSPECH2.OBJ		/* announcer speech processor part 2*/
HHVIDS.OBJ		/* VIDEO ANIMATIONS */
HHFIX.OBJ		/* fixes for winner stays */
HHCONTR3.OBJ		/* more player control (actually misc stuff) */
HHSYSTEM.RLO		/* LINK IN THE SYSTEM STUFF	*/
HHDIAG.RLO		/* LINK IN THE DIAGNOSTICS CODE */
HHSCRCHF.OBJ		/* checking/falling down/stealing functions */

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
	VECTORS: {}	> TRAP31
	IMAGES:	{}	> IROM
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
