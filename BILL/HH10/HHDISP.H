**************************************************************************
*								         *
* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		 *
* 		       ALL RIGHTS RESERVED.				 *
*								         *
**************************************************************************

BOGUS_SCL  .set 	[800h,800h]		; bogus scale to fool SCALE_MAMA

*********************************************
*	        MultiMake Option Flags           *
*********************************************
;mdpOM_GUNV     	.set	0001h		; A Gunvector follows (OBJECT)
OM_COLL			.set	0002h		; A Collision vector follows (OBJECT, WHOLE)
OM_ANIM			.set	0004h		; An animation script follows (OBJECT)
OM_CFUNC		.set	0008h		; A creation function follows (OBJECT)
OM_POS			.set	0010h		; A position is supplied (WHOLE)
OM_OID			.set	0100h 		; An OID follows (OBJECT)
OM_DUMCOLL		.set	0200h		; Use DUMCOLL as default (instead of 0)
OM_PRVANIM		.set	0400h 		; Use the previously set Animation Script
OM_INSERT		.set	0800h 		; call INSERT_OBJ upon completion
OM_OPARTS		.set	1000h		; Supply an OPARTSX and Y for this object.
OM_SCTAB		.set	2000h		; Use the previously set Gun Vector.

SCRTOP			.EQU	0		;set to line after static top area
SCRBOT			.EQU	253
SCRLFT			.EQU	0
SCRRGT			.EQU	399

SCALE_1TO1		.EQU	01000100H	;1 TO 1 SCALE FOR DMA.  

HALFX	 		.EQU	199				;3-D TRANSLATION X-OFFSET
HALFY			.EQU	127

SCRNST_FULL		.EQU	[SCRTOP,SCRLFT]	;TOP LEFT WITH NO SCORE AREA
SCRNEND			.EQU	[SCRBOT,SCRRGT] ;BOT RIGHT OF SCREEN (for SCRNBR, clipper)
SCRWIDTH		.EQU	SCRRGT-SCRLFT+1
SCRHGHT			.EQU	SCRBOT-SCRTOP+1

;* PLANE TABLE STRUCT
*STRUCT PLANE
P_LSTHD			EQU	0  	;UHL ptr to head of OBJECT LIST
P_LSTTL			EQU	020H	;UHL ptr to tail of OBJECT LIST
*ENDSTRUCT
PLNSIZ			EQU	040H	;size of PLANE STRUCTURE

;**** LSTHD, LSTTL offsets above must match OLINK, OBLINK offset of OBJ ****

;*OBJECT BLOCK LAYOUT
*STRUCT	OBJ
OLINK			EQU	000h	;UHL Link to next object block
OBLINK			EQU	020h	;UHL Back Link to previous obj
OSLINK			EQU	040h	;UHL Supplemental lists (OID class)
OPLINK			EQU	060h	;UHL Link to controlling process
OCVECT			EQU	080h	;UHL vector to collision table
OPART1			EQU	0a0h	;UHL ptr to head of multi-part obj
OPARTS			EQU	0c0h	;UHL linked list of multi-parts
OZVEL			EQU	0e0h	;SHL Z VELOCITY
OXVEL			EQU	100h	;SHL X VELOCITY
OYVEL			EQU	120h	;SHL Y VELOCITY
OXVAL			EQU	140h	;SHL BIT X POSITION
OXFRAC			EQU	140h	; Fractional portion of X position
OXPOS			EQU	150h	; Integer portion of X position
OYVAL			EQU	160h	;SHL BIT Y POSITION
OYFRAC			EQU	160h	; Fractional portion of Y position
OYPOS			EQU	170h	; Integer portion of Y position
OZVAL			EQU	180h	;SHL Z POSITION
OZFRAC			EQU	180h	; Fractional portion of Z position
OZPOS			EQU	190h	; INTEGER Z position of object
OPARTSXY 		EQU	1a0h	;UHL multi part position offset
OANIOFF			EQU	1c0h	;UHL ADJUSTED ANIMATION OFFSET
OANIOFFX 		EQU	1c0h	; X ANIMATION OFFSET FROM TOP LEFT ADJUSTED FOR FLIP
OANIOFFY 		EQU	1d0h	; Y ANIMATION OFFSET FROM TOP LEFT ADJUSTED FOR FLIP
OFSET			EQU	1e0h	;UHW PRECOMPUTED OFFSET
OCTRL			EQU	1f0h	;UHW DMA #2 CONTROL WORD
OSAG			EQU	200h	;UHL SOURCE ADDRESS (UNCLIPPED, ADJUSTED FOR FLIPS)
ODAG			EQU	220h	;UHL Screen Pos (saved as intermediate step in DISPLAY! NEW)
ODAGX			EQU	220h	
ODAGY			EQU	230h	
OUSIZE			EQU	240h	;UHL DMA #2 UNSCALED SIZE
OUSIZEX			EQU	240h	; X-SIZE
OUSIZEY			EQU	250h	; Y-SIZE
OSIZE			EQU	260h	;UHL H,W OF OBJECT (16,16)	W=ADJUSTED FOR MORSEL
OSIZEX			EQU	260h	; X SIZE
OSIZEY			EQU	270h	; Y SIZE
OPAL			EQU	280h	;UHW B(0-15) PALETTE; B(16-31) CONSTANT COLOR
OCONST			EQU	290h	;UHW CONSTANT COLOR
OSCALE			EQU	2a0h	;UHL DMA #2 SCALE
OSCALEX			EQU	2a0h	; X-SCALE
OSCALEY			EQU	2b0h	; Y-SCALE
OIMG			EQU	2c0h	;UHL Pointer to image data table
ONuManScl 		EQU	2e0h	;UHW New scale for manually scaled imgs
OYACCEL			EQU	2f0h	;UHW just the fraction for Grav
OVAR1			EQU	300h	;UHL #
OVAR2			EQU	320h	;UHL #
OVAR3			EQU	340h	;UHL #used by
OVAR4			EQU	360h	;UHL #  ANIM
OVAR5			EQU	380h	;UHL @used by		
OVAR6			EQU	3a0h	;UHL @	FlashWyt
OVAR7			EQU	3c0h	;UHL 2nd byte used for MULTI-PART Z alignment (OZOFF)
OVAR8			EQU	3e0h	;UHL used as AnimArg
OVAR9			EQU	400h	;UHL
OFLAGS			EQU	420h	;UHW General purpose flags
OID			EQU	430h	;UHW Object ID
OUANIOFF 		EQU	440h	;UHL UNSCALED ANIMATION OFFSET
OUANIOFFX 		EQU	440h	; X ANIMATION OFFSET FROM TOP LEFT ADJUSTED FOR FLIP
OUANIOFFY 		EQU	450h	; Y ANIMATION OFFSET FROM TOP LEFT ADJUSTED FOR FLIP
OIHOFF			EQU	460h	;UHW OFFSET TO IMAGE HEADER	; NEW
OSCTAB			EQU	470h	;UHL address of scale table
ODATA			EQU	490h	; SCRATCH SPACE FOR USER ROUTINES
ODATAX  		EQU	680h	; = 0480H + 0200H
*ENDSTRUCT
OBSIZ			EQU	ODATAX 	;Object Block Size
OCLRSIZ 		EQU	ODATA		;GETOBJ WILL CLEAR UPTO AND NOT INCLUDING HERE

NOBJ	EQU	400

***** MISCELLANEOUS OFFSETS
;**** OFFSETS for ANIM
*STRUCT	ANIM+OBJ
AnimNxt			EQU	OVAR1		;UHL  link to next obj of Animy linked list
AnimFrm			EQU	OVAR2		;UHL  ptr to current animation frame
AnimScr			EQU	OVAR3		;UHL  ptr to animation script
AnimSLP			EQU	OVAR4		;UDB  reset value for AnimSlp
AnimSlp			EQU	OVAR4+8		;UDB  # tiks before next ANI
AnimLoop		EQU	OVAR4+16	;UDB	General purpose Loop counter
AnimOpen		EQU	OVAR4+24	;UDB  reserved for future definition (keep cleared)
*ENDSTRUCT
AnimRetScr		EQU	OVAR5		;UHL ANIMATION RETURN SCRIPT
AnimRetFrm		EQU	OVAR6		;UHL ANIMATION RETURN FRAME
OPARTID			EQU	OVAR7		;UHB # of part in multi-parter, stuffed by MULTIMAKE
OZOFF			EQU	OVAR7+8		;UHB Z OFFSET
AnimArg			EQU	OVAR8		;stuffed by AnimP for use by GETAFARG_xxxx
OPLAYER			EQU	OVAR9

;*** ANIFLY SCRIPT FLAGS ***
AFlip			EQU	08000H	;flip bits in aniscript flag
Axxxxxx			EQU	04000H	;unused
AMulti			EQU	02000H	;animate down multi-parter list?
AFunc			EQU	01000H	;call function in aniscript flag

;*** BITS SET IN FLAGS:SLEEP WORD OF AN ANIM SCRIPT ***
B_AFlip			EQU	15 	;WARNING don't move, tested w/ jrnn in AnimP (hhc)
B_xxxxxx 		EQU	14
B_AMulti 		EQU	13
B_AFunc			EQU	12

BQCELL			EQU	0C0H	;SIZE OF DMA QUEUE ELEMENT

***********************
*  Values for OCTRL   *
***********************
M_WRZERO 		EQU  00001H	;Write Zero Data
M_WRNONZ 		EQU  00002H	;Write Non-Zero Data
M_CONZER 		EQU  00004H	;Replace Zero Data with constant
M_CONNON 		EQU  00008H	;Replace Non-Zero Data with constant
M_CONST			EQU  0000CH	;any constant data replacement
M_FLIPH			EQU  00010H	;Flip Horizontally
M_FLIPV			EQU  00020H	;Flip Vertically
M_LRCLIP		EQU  00040H	;left right clipping using the offset register
M_COMPRESS		EQU  00080H	;zero compression
M_INUSE			EQU  08000H	;obj not on free list

*BIT POSITIONS FOR OCTRL
B_WRZERO		EQU  	0
B_WRNONZ		EQU  	1
B_CONZER		EQU  	2
B_CONNON		EQU  	3
B_FLIPH			EQU  	4
B_FLIPV			EQU  	5
B_LRCLIP		EQU	6
B_COMPRESS		EQU	7
B_INUSE			EQU	15

***********************
*  Values for OFLAGS  *
***********************
M_NOSCALE		EQU  00001H	;NO AUTO SCALING (or controls RESCALING if MANSCALE)

M_FVELADD		EQU  00004H	;freeze veladd for 1 frame when set
M_MANSCALE		EQU  00020H	;MANUAL SCALING (You set scale, sizes computed when M_NOSCALE clr)
M_NOPARTANI		EQU  00040H	;IF IN MULTI-SCRIPT, THEN DON'T ANIMATE
M_OFSCRN 		EQU  00080H	;if 1, VELADD has marked as OFF SCREEN
M_OPARTSXY 		EQU  00200H
;mdpM_NOCOLL		EQU  02000H	;Don't do regular collisions...
M_ANIM			EQU  04000H	;set if on ANIFLY list
M_SCRNOBJ		EQU  08000H	;SCREEN OBJECT

*BIT POSITIONS FOR OFLAGS
B_NOSCALE		EQU  	0	

B_FVELADD		EQU	2	;freeze veladd 1 frame
B_MANSCALE		EQU	5	;MANUAL SCALING (You set scale, sizes computed automatically)
B_NOPARTANI		EQU	6	 
B_OFSCRN		EQU	7
B_OPARTSXY 		EQU	9	;USE OPARTSXY FIELD INSTEAD OF OANIOFF FOR OFFSET
;mdpB_NOCOLL		EQU	13
B_ANIM			EQU	14
B_SCRNOBJ		EQU	15	;SCREEN OBJECT
