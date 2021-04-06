/*	MAIN linker command file					*/
-e SETUP			/* entry point of program		*/
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
 SCRATCH	: org = 0x2000c000,	len = 0x7f4000

 WBD_RAM      	: org = 0x20800000,   	len = 0x2000
 WBD_ROM      	: org = 0xFF800000,   	len = 0x2000

 CODE_RAM	: org = 0x20802000,	len = 0x7f7000
 CODE_ROM	: org = 0xFF802000,	len = 0x7ee000

 GSPOT		: org = 0x20FF9000,	len = 0x1000 	  /* reserved for GSPOT */
 TV		: org = 0x20FFA000,	len = 0x5bc0 	  /* reserved for toddview */

 COLD_ROM	: org = 0xFFFF0000,	len = 0xFBC0

 CKSMAREA	: org = 0xFFFFFBC0,	len = 0x40

 IROM		: org = 0xF8000000,	len = 0x7800000 

 TRAP_RAM	: org = 0x20FFFE00,	len = 0x400 
 TRAP_ROM	: org = 0xFFFFFE00,	len = 0x400 
}
/* These are Global constants that the program will use to load code	*/
/* You must change these to reflect the above code mappings.		*/
code_start = 0xFF800000;
code_end = 0xFFFF0000;
code_dest = 0x20800000;

vector_start = 0xFFFFFE00;
vector_end = 0;
vector_dest = 0x20FFFE00;


SECTIONS       /* linker sections directive */
 {
	VECTORS:	{}	load = TRAP_ROM, run = TRAP_RAM
	CKSUMS:		{}	> CKSMAREA
	IMAGES:		{}	> IROM
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
	      }			load = CODE_ROM, run = CODE_RAM	

	COLDSTRT:	{}	> COLD_ROM

 }


