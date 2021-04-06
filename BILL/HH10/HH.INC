;**************************************************************************
;*									  *
;* 		SYSTEM "ASSEMBLY TIME" CONDITIONALS			  *
;*									  *
;**************************************************************************

DEBUG		EQU	1	;THIS VERSION IS CURRENTLY UNDER CONSTRUCTION
;DEBUG		EQU	0	;ADD THIS BEFORE RELEASE!!!!!

bog_line	equ	1	;if 1, draw bog lines

GERMAN		EQU	0	;ENGLISH RELEASE
;GERMAN		EQU	1	;GERMAN RELEASE

NOTFINAL	EQU	1	;IF = 1, NOT PRODUCTION QUALITY PROGRAM
;NOTFINAL	EQU	0	;ADD THIS BEFORE RELEASE!!!!!

FORCEFREE	EQU	0	;1 = GAME HARDWIRED FREE
FULLPRICE	EQU	1	;1 = ALL THE PRICINGS ARE INCLUDED

nskaters	equ	2
two_line_rink	equ	1
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
******************************* MPROC.H ********************************
*VARS

;Moved sound labels to HHGLO.H

*
*PROCESS DATA STRUCTURE
*NOTE: MAKE SURE THIS IS EVENLY DIVISIBLE BY 32
*STRUCT	PRC
PLINK	EQU	0	;UHL LINK TO NEXT 32 BITS
PROCID	EQU	020H	;UHW PROCESS ID 16 BITS
PTIME	EQU	030H	;UHW SLEEP TIME X 16MSEC 16 BITS
PWAKE	EQU	0E0H	;UHL
PA8	EQU	0C0H	;UHL
PA9	EQU	0A0H	;UHL
PA10	EQU	080H	;UHL
PA11	EQU	060H	;UHL
PSPTR	EQU	040H	;UHL PROCESS STACK POINTER 32 BITS
PDATA	EQU	0100H	;UHL PROCESS DATA STORE
****PSDATA	EQU	0500H	;UHL PROCESS STACK DATA
PSDATA	EQU	0900H	;UHL PROCESS STACK DATA
PTEMP1	EQU	PSDATA-0A0H	;UHL	;PROCESS TEMPORARY STORE AREAS
PTEMP2	EQU	PSDATA-080H	;UHL
PTEMP3	EQU	PSDATA-060H	;UHL
PTEMP4	EQU	PSDATA-040H	;UHL
PCTIME	EQU	PSDATA-020H	;UHW PROCESS CREATION TIME (DEBUGGING)
PCOMM	EQU	PSDATA-010H	;UHW PROCESS COMMUNICATION AREA
*ENDSTRUCT
;PRCSIZ	EQU   0700H	;END OF DATA STRUCTURE
PRCSIZ	EQU   1200H	;END OF DATA STRUCTURE
NPROC	EQU   256	;NUMBER OF PROCESSES
**************************************************************************
*                                                                        *
* 	THE X-UNIT SYSTEM SPECIFIC EQUATES 				 *
*                                                                        *
**************************************************************************
XUNIT	equ	0

*
*MACHINE TIMINGS
*
MACHINE_CYCLE	.EQU	100	;NUMBER OF nanoSECONDS PER MACHINE CYCLE on the 34020:
				;	32MHz = 132 ns
				;	40MHz = 100 ns
MICRO_SECOND	.EQU	1000/MACHINE_CYCLE	;MACHINE CYCLES PER microSECOND

*
*GENERAL SYSTEM EQUATES
*

*
*PIXBLT STUFF
PXSIZE		.set	8
SCRN_PTCH	.set	512*PXSIZE
CONV_PTCH	.SET	13
PLANEMSK	.set	0

INI_CFG		.set	1108h
INI_CTRL	.set	0	 

SCREEN_WIDTH	.EQU	400		;SCREEN WIDTH IN PIXELS

SCREEN_HEIGHT	.EQU	254		;SCREEN LENGTH IN PIXELS  NEW

*
*SYSTEM Z MEMORY MAP
*
	.if	XUNIT=1
SCRATCH		.SET	20000000h	;START OF SCRATCH
CMOS		.EQU	0a0440000h	;START OF CMOS RAM
SCREEN		.SET	00h		;START OF SCREEN MEMORY
SCRNE		.SET	0200000h	;END OF SCREEN+1
PSCREEN		.SET	800000h		;START OF PALETTE SCREEN MEMORY

SCRATCH_END	.EQU	20800000H	;END OF SCRATCH+1
STCKST		.SET	207ffff0h	;TOP OF STACK
COLRAM		.SET	0a0800000H	;COLOR RAM B0-B4 BLU, B5-B9 GRN, B10-B14 RED
PALSIZE		.SET	02000H		;PHYSICAL SIZE OF A PALETTE IN COLOR RAM
*
*USEFUL SYSTEM ADDRESSES
*
ROM		.SET	20800000h	;PROGRAM ROM
SWITCH		.SET	60c00000h	;I/O (JAMMA CONNECTOR AND WIRED INPUTS)
SWITCH2		.SET	60c00020H	;I/O (WIRED INPUTS AND DIP SWITCHES) 
COINS		.SET	60c00040H
DIPSWITCH	.EQU	60c00060H	;DIP SWITCHES FOR X UNIT

SOUND		.SET	60c00080h	;SOUND I/O (B0-B7 = SOUND#)
					;	    B8 =  RESET (0 EN)

COIN_COUNTERS	.EQU	60c000a0H	;COIN COUNTER DRIVERS
WDOG_BONE	.EQU	60c000c0H	;ACCESS HERE TO FEED THE DOG
A2D_PORT	.EQU	80800000H	;A/D PORT
AUX_PORT	.EQU	060C00080H	;AUXILLARY PORT

IROM		.SET	0f8000000h	;IMAGE ROM (assuming 4Mbit parts, 16MB total)
;IROM		.SET	0f0000000h	;IMAGE ROM (assuming 8Mbit parts, 32MB total)
CMAPSEL		.SET	0C0800080h	;COLOR MAP SELECT (0-15)
UART		.SET	80c00000h	;UART (8 long word registers)

SYSCTRL0	.SET	40800000H	;SYSTEM CONTROL LATCH 0
SYSCTRL1	.SET	40C00000H	;SYSTEM CONTROL LATCH 1
SECCHIP		.set	60000000h	;security register
INT_REG		.set	60400000h	;interrupt register
RST_REG		.set	60800000h	;reset register (bit 0 only)

*										 
*   SYSCTRL0      bit 3             bit 2           bit 1           bit 0
*
*    if set:    VECTORS FROM      ENABLE CMOS    WRITE PROTECT   WRITE PROTECT
*                  DRAM              WRITE         BANK 1 HI        BANK 1 LO
*
*
*   SYSCTRL1      bit 3             bit 2           bit 1           bit 0
*
*    if set:    DMA BANK 1        LED IS ON	  I/O RESET       DMA ENABLED				 
*
*
RAMVECTS	.equ	8		;use RAM VECTORS (not ROM)
CMOSENAB	.equ	4		;enable CMOS
WRPROTHI	.equ	2		;Write Protect Hi half of DRAM Bank 1
WRPROTLO	.equ	1		;Write Protect Lo half of DRAM Bank 1

DMABANK1	.equ	8		;Select Hi BANK of IMAGE ROM (for DMA)
LED_ON		.equ	4		;Turn on LED
SND_RESET	.equ	2		;Reset Sound Board and PIC chip
DMAENAB		.equ	1		;Enable DMA

SYSCINIT	.equ  (DMAENAB<<8)+RAMVECTS		; for XUNIT
SYSC_COLD	.EQU	0		;System control register upon cold start

	.else

SCRATCH		.SET	1000000h		;START OF SCRATCH
CMOS			.EQU	1400000h		;START OF CMOS RAM
SCREEN		.SET	00h			;START OF SCREEN MEMORY
SCRNE			.SET	0200000h		;END OF SCREEN+1
PSCREEN		.SET	000000h		;START OF PALETTE SCREEN MEMORY

SCRATCH_END	.EQU	1400000H		;END OF SCRATCH+1
STCKST		.SET	13ffff0h		;TOP OF STACK
COLRAM		.SET	1880000H		;COLOR RAM B0-B4 BLU, B5-B9 GRN, B10-B14 RED
PALSIZE		.SET	01000H		;PHYSICAL SIZE OF A PALETTE IN COLOR RAM
*
*USEFUL SYSTEM ADDRESSES
*
ROM			.SET	0ff800000h	;PROGRAM ROM
SWITCH		.SET	1860000h		;I/O (JAMMA CONNECTOR AND WIRED INPUTS)
SWITCH2		.SET	1860010H		;I/O (WIRED INPUTS AND DIP SWITCHES) 
COINS			.SET	1860030H
DIPSWITCH	.EQU	1860020H		;DIP SWITCHES FOR X UNIT

SOUND			.SET	1680000h		;SOUND I/O (B0-B7 = SOUND#)
										;B8 =  RESET (0 EN)

COIN_COUNTERS	.EQU	1860010H	;COIN COUNTER DRIVERS
WDOG_BONE		.EQU	1860030H	;ACCESS HERE TO FEED THE DOG
AUX_PORT			.EQU	1860000H	;AUXILLARY PORT

IROM			.SET	2000000h		;IMAGE ROM (assuming 4Mbit parts, 16MB total)
;IROM			.SET	2000000h		;IMAGE ROM (assuming 8Mbit parts, 32MB total)
CMAPSEL		.SET	1a00080h		;COLOR MAP SELECT (0-15)
INT_REG		.set	1860040h		;interrupt register

SYSCTRL		.SET	1b00000H		;SYSTEM CONTROL LATCH

IROM_WR_ENABLE	.set	0080h		; Enable writes to IROM
IROM_BANK_SEL0	.set	0100h		; IROM Bank select bit 0
IROM_BANK_SEL1	.set	0200h		; IROM Bank select bit 1
LED_ON			.set	0400h		; LED on
PALEN				.set	0800h		; Color Palette Enable
ROMWRINTDIS		.set	1000h		; Disable Write to ROM interrupt
CLR_WRROMINT	.set	2000h		; Clear Write to ROM interrupt
TEST_BIT			.set	4000h		; General purpose test bit

SYSCINIT			.equ  (IROM_WR_ENABLE|PALEN|ROMWRINTDIS|CLR_WRROMINT|TEST_BIT)
SYSC_COLD		.EQU	0			;System control register upon cold start

VMUX_CONTROL	.equ	1800000h	; VMUX Control Register
VMUX_BREG0		.equ	1820000h	; VMUX Background Register 0
VMUX_BREG1		.equ	1830000h	; VMUX Background Register 1
VMUX_PMATCH		.equ	1840000h	; VMUX Palette Match Register
VMUX_STATUS		.equ	1800000h	; VMUX Status Register

VMUX_INIT		.equ	0			; Initial VMUX mode

CMOSENAB			.equ	1480000h	;enable CMOS

SOUNDIRQ			.equ	1860040h	; Sound IRQ Address
SNDRSTBIT		.equ	16			; Bit used to reset sound section
soundbit			.equ	0100h		; Sound system strobe bit

	.endif

	.if	XUNIT=1
	.IF UART
LINT2_INTS	.EQU	4		;LINT2 interrupts, with UART
	.ELSE
LINT2_INTS	.EQU	0		;LINT2 interrupts, without UART
	.ENDIF
*
*UART Equates
*
UART_CSR 	.EQU	20H		;UART Clock Select Register
UART_CR		.EQU	40H		;UART Control Register
UART_THR	.EQU	60H		;UART Transmit Hold Register
UART_ACR	.EQU	80H		;UART Auxiliary Control Register
UART_IMR	.EQU	0A0H		;UART Interrupt Mask Register
	.else
LINT2_INTS	.equ	0
	.endif

*
AUTOERAS	.EQU	10H
OBJPALET	.EQU	20H

*COIN COUNTER EQUATES					  ???WBDHELP???
	.if	XUNIT=1

LEFT_COIN	.EQU	01H		;LEFT COIN MASK
RIGHT_COIN	.EQU	02H		;RIGHT COIN MASK
*EQUATES FOR READING SOUND BOARD IRQ REQUEST LINE
B_WDOG		.EQU	30		;(L) FOR WATCHDOG TRIGGERED
B_A2D		.EQU	0		;(L) FOR CONVERSION COMPLETE
B_SIRQ		.EQU	2		;BIT TO READ FOR SOUND IRQ LINE

	.else

LEFT_COIN	.EQU	01H		;LEFT COIN MASK
RIGHT_COIN	.EQU	02H		;RIGHT COIN MASK

*EQUATES FOR READING SOUND BOARD IRQ REQUEST LINE

B_WDOG		.EQU	8			;(L) FOR WATCHDOG TRIGGERED
B_SIRQ		.EQU	11			;BIT TO READ FOR SOUND IRQ LINE

	.endif

*
*INTERRUPT CONSTANTS
ENDVBLNK	.EQU	14H		;SCAN LINE TO END VERTICAL BLANKING
HSINT		.EQU	135+ENDVBLNK	;HALF SCREEN
EOSINT		.EQU	254+ENDVBLNK	;END OF SCREEN
DIRQ2INT	.EQU	246+ENDVBLNK	;JUST BEFORE EOS
*SCOREINT	.EQU	18+ENDVBLNK	;END OF SCORE AREA INTERRUPT

	.if	XUNIT=1
ERASELOC		.EQU	COLRAM + (03F0H*2)	;GAME AUTO ERASE COLOR LOCATION
ERASECOL		.EQU	03F3F3F3FH				;GAME AUTO ERASE COLOR #

GNDERALOC	.EQU	COLRAM + (03E0H*2)	;GAME AUTO ERASE COLOR LOCATION
GNDERACOL	.EQU	03e3e3e3EH				;GAME AUTO ERASE COLOR #
	.else
ERASELOC		.EQU	COLRAM + (03F0H)		;GAME AUTO ERASE COLOR LOCATION
ERASECOL		.EQU	03F3F3F3FH				;GAME AUTO ERASE COLOR #

GNDERALOC	.EQU	COLRAM + (03E0H)		;GAME AUTO ERASE COLOR LOCATION
GNDERACOL	.EQU	03e3e3e3EH				;GAME AUTO ERASE COLOR #
	.endif


CENTER_XSHIFT	.EQU	56

BITMAP_OFFSET	.EQU	CENTER_XSHIFT*8

PAGE0ADR 	.EQU	[0,CENTER_XSHIFT] ;(1 dead, 44 score, 210 playfield)*2, 2 autoerase
PAGE1ADR 	.EQU	[SCRHGHT,CENTER_XSHIFT]	;SCRHGHT*8*512
PAGE2ADR	.EQU	[512,CENTER_XSHIFT]	;Video page 2 XY address
PAGE3ADR	.EQU	[768,CENTER_XSHIFT]	;Video page 3 XY address

OFFSETVAL .set		BITMAP_OFFSET
TOGGLE_PAGE_XY	.set  [SCRHGHT,0]
TOGGLE_PAGE_L 	.set  SCRHGHT*SCRN_PTCH
	.if XUNIT=1
DPYSTRT0	.set	BITMAP_OFFSET
DPYSTRT1 .set  (SCRHGHT*SCRN_PTCH)+BITMAP_OFFSET
DPYSTRT2	.EQU	(512*SCRN_PTCH)+BITMAP_OFFSET
DPYSTRT3	.EQU	(768*SCRN_PTCH)+BITMAP_OFFSET
	.endif


PAGE0E		.EQU	0FE000h	;END OF PAGE0+1
PAGE2_START	.EQU	0200000H	;Start of video page 2
PAGE2_END	.EQU	02FFFFFH	;End of video page 2
PAGE3_START	.EQU	0300000H	;Start of video page 3
PAGE3_END	.EQU	03FFFFFH	;End of video page 3

*
*DMA STUFF
*
	.if	XUNIT=1
DMAREGS:	.equ	0C08000C0h	;BOTTOM OF DMA REGISTERS FOR MMTM

					;BIT 15:
					;1=START DMA (WRITE)
					;0=STOP DMA  (WRITE)
				
					;1=DMA BUSY (READ)
					;0=DMA IDLE (READ)
;DMAOFFST:	.EQU	0C0800000h	;DMA OFFSET REGISTER
;DMACTRL:		.equ	0C0800010h	;DMA CONTROL REGISTER
;DMASAGL:		.equ	0C0800020h	;DMA DATA STARTING ADDRESS LOW 16 BITS
;DMASAGH:		.equ	0C0800030h	;DMA DATA STARTING ADDRESS HIGH 16 BITS
;DMAHORIZ:	.equ	0C0800040h	;DMA DESTINATION, X COORDINATE
;DMAVERT:		.equ	0C0800050h	;DMA DESTINATION, Y COORDINATE
;DMAHSIZE:	.equ	0C0800060h	;DMA DESTINATION, X SIZE	
;DMAVSIZE:	.equ	0C0800070h	;DMA DESTINATION, Y SIZE
;DMACMAP:		.equ	0C0800080h	;DMA COLOR MAP SELECT
;DMACONST:	.equ	0C0800090h	;DMA CONSTANT COLOR SUBSTITUTE
;DMAXSCL:		.equ	0C08000A0h	;DMA X SCALE REG
;DMAYSCL:		.equ	0C08000B0h	;DMA Y SCALE REG
;DMATPLFT:	.equ	0C08000C0h	;DMA TOP LEFT WINDOW BORDER
;DMARTBOT:	.equ	0C08000D0h	;DMA RT BOTTOM WINDOW BORDER
;DMACONFIG:	.equ	0C08000E0h	;DMA CONFIG REGISTER

;		ALL DMA REGS ARE 32 BITS!!!	

DMAOFFCTL:	.EQU	0C0800000h	;DMA OFFSET & CONTROL REGISTERS
DMASAG:		.equ	0C0800020h	;DMA DATA STARTING ADDRESS
DMAHV:		.equ	0C0800040h	;DMA DESTINATION, XY  COORDINATE
DMAHVSIZE:	.equ	0C0800060h	;DMA DESTINATION, XY SIZE	
DMACMAPCON:	.equ	0C0800080h	;DMA COLOR MAP SELECT, CONST
DMAXYSCL: 	.equ	0C08000A0h	;DMA XY SCALE REG
DMAWINDOW:	.equ	0C08000C0h	;DMA BOT:TOP  or  RT:LEFT WINDOW BORDER
DMACONFIG:	.equ	0C08000E0h	;DMA CONFIG REGISTER

DMAGOREG		.equ	0C0C00000h	; for read/write of DMA GO BIT ONLY (in bit 31)
										; NOTE: trashes offset & control regs on a write.
	.else

DMAOFFST	.equ	1a00000h	; DMA offset
DMACTRL		.equ	1a00010h	; DMA control. BIT 15:
					; 0=DMA IDLE (R), 1=DMA BUSY (R)
					; 0=STOP DMA (W*2), 1=START DMA (W)
DMASAGL		.equ	1a00020h	; *Data start (low 16 bits)
DMASAGH		.equ	1a00030h	; *Data start (high 16 bits)
DMAHORIZ	.equ	1a00040h	; Dest X
DMAVERT		.equ	1a00050h	; Dest Y
DMAHSIZE	.equ	1a00060h	; WIDTH
DMAVSIZE	.equ	1a00070h	; HEIGHT
DMACMAP		.equ	1a00080h	; Color map select
DMACONST	.equ	1a00090h	; Constant color
DMASCALEX	.equ	1a000a0h	; X scale 8:8
DMASCALEY	.equ	1a000b0h	; Y ^
DMAWINDOW	.equ	1a000c0h	; Window LR or TB
DMALT		.equ	1a000c0h	; Window [ LEFT : TOP ]
DMARB		.equ	1a000d0h	; Window [ RIGHT : BOTTOM ]
DMATEST		.equ	1a000e0h	; RESERVED (TEST REGISTER)
DMACONF		.equ	1a000f0h	; Config

DMAREGS:		.equ	1a000C0h		;BOTTOM OF DMA REGISTERS FOR MMTM

;		ALL DMA REGS ARE 32 BITS!!!	

DMAOFFCTL:	.EQU	1A00000h		;DMA OFFSET & CONTROL REGISTERS
DMASAG:		.equ	1A00020h		;DMA DATA STARTING ADDRESS
DMAHV:		.equ	1A00040h		;DMA DESTINATION, XY  COORDINATE
DMAHVSIZE:	.equ	1A00060h		;DMA DESTINATION, XY SIZE	
DMACMAPCON:	.equ	1A00080h		;DMA COLOR MAP SELECT, CONST
DMAXYSCL: 	.equ	1A000A0h		;DMA XY SCALE REG
DMAWINDOW:	.equ	1A000C0h		;DMA BOT:TOP  or  RT:LEFT WINDOW BORDER
DMACONFIG:	.equ	1A000E0h		;DMA CONFIG REGISTER

DMAGOREG		.equ	1A00000h		; for read/write of DMA GO BIT ONLY (in bit 31)
										; NOTE: trashes offset & control regs on a write.

PIC_COMMAND	.equ	01600000h	;PIC Command Port
PIC_DATA	.equ	PIC_COMMAND	;PIC Data Port

UP_BITS		equ	00000001000000000000000100000001b
DOWN_BITS	equ	00000010000000000000001000000010b
BUTTONS		equ	010110000101001000111000001110000b
ACTION_BITS	equ	010110000000000000111000001110000b
START_BITS	equ	0101001000000000000000000b

B_SDAV		.equ	10		;sound data available bit # (active hi)
B_SIRQ		.equ	11		;Irq bit #
PALENB		.equ	0800h	;Enable Color Palette
DMACF4_A		.equ	010h	; BIT 4	  TIMING PARAMETER

	.endif


*	LAYOUT OF DMA CONTROL REGISTER
DMAWZ	.set	8001h	; Bit 0	     write zero data
DMAWNZ	.set	8002h	; Bit 1	     write non-zero data
DMACZ	.set	8004h	; Bit 2	     subst zero data with constant
DMACNZ	.set	8008h	; Bit 3      subst non-zero data with constant
DMAWAL	.SET	8003h	; WRITE BOTH ZERO & NON-ZERO DATA
DMACAL	.SET	800ch	; WRITE CONSTANT ON BOTH ZERO & NON-ZERO DATA
DMAHFL	.set	0010h	; Bit 4	     Horz flip
DMAVFL	.set	0020h	; Bit 5	     Vert flip
DMACLP	.set	0040h	; Bit 6	     Clip using UDLR method (0=offset method)
DMACMP	.set	0080h	; Bit 7	     Zero Compression on
DMALDX	.set	0300h	; Bits 8-9   Leading Zero Multiplier (0-3 = 1x,2x,4x,8x)
DMATRX	.set	0c00h	; Bits 10-11 Trailing Zero Multiplier (0-3 = 1x,2x,4x,8x)
DMABPP	.set	7000h	; Bits 12-14 Bits Per Pixel (1-7, 0=8)
DMAGO	.set	8000h	; Bit 15     DMA Go/Halt
			;	    (one '0' write halts DMA,
			;     	     two '0' writes kills xfer,
			;     	     one '1' write restarts/starts) 

*	LAYOUT OF DMA CONFIG REGISTER
DMAWIN	.set	200000h	; Bit 5	  (0 = rt/lft, 1 = top/bot)
DMACF4	.SET	100000H	; BIT 4	  TIMING PARAMETER

* LAYOUT OF IMAGE HEADER   NEW

ICTRL	 	.EQU	0H
ISIZE		.equ	10h
ISIZEX		.EQU	10h
ISIZEY		.EQU	20H
ISAG		.equ	30h
IANIOFF      	.equ	50H
IANIOFFX 	.EQU	50H
IANIOFFY 	.EQU	60H
ICMAP		.equ	70H
ICBOX		.equ	90H
ICBOXSIZ	.equ	0A0H

IHDRSIZ	equ	90h

ZM	.set	1		;Z MINUS MULTIPLIER
ZP	.set	010000h		;Z PLUS MULTIPLIER
*
*SOUND PROCESSOR EQUATES
NINT	.EQU	0800H		;SOUND NON-INTERRUPTABLE    ???WBDHELP???

*------- Register names for TMS34010 assembly language functions -------

*-----------------------------------------------------------------------
* Define names of I/O registers
*-----------------------------------------------------------------------
	.if	XUNIT=1
VESYNC	.set	0C0000000h
HESYNC	.set	0C0000010h
VEBLNK	.set	0C0000020h
HEBLNK	.set	0C0000030h
VSBLNK	.set	0C0000040h
HSBLNK	.set	0C0000050h
VTOTAL	.set	0C0000060h
HTOTAL	.set	0C0000070h
DPYCTL	.set	0C0000080h
DPYSTRT	.set	0C0000090h
DPYINT	.set	0C00000A0h
CONTROL	.set	0C00000B0h
HSTDATA	.set	0C00000C0h
HSTADRL	.set	0C00000D0h
HSTADRH	.set	0C00000E0h
HSTCTLL	.set	0C00000F0h
HSTCTLH	.set	0C0000100h
INTENB	.set	0C0000110h
INTPEND	.set	0C0000120h
CONVSP	.set	0C0000130h
CONVDP	.set	0C0000140h
PSIZE	   .set	0C0000150h
PMASKL	.set	0C0000160h
PMASKH	.set  0C0000170h
CONVMP	.set	0C0000180h
CONFIG	.set	0C00001a0h
DPYTAP	.set	0C00001b0h
* I/O register locations 23-27 are reserved for future expansion
VCOUNT	.set	0C00001C0h
HCOUNT	.set	0C00001D0h
DPYADR	.set	0C00001E0h
REFADR	.set	0C00001F0h
*
DPYMSK	.set	0C00002E0h	; replaces DPYTAP
DPYST		.set	0C0000200h	; replaces DPYSTRT
DPYNX		.SET	0C0000220H	; replaces DPYADR
	.else
VESYNC	.set	0C0000040h
HESYNC	.set	0C0000000h
VEBLNK	.set	0C0000050h
HEBLNK	.set	0C0000010h
VSBLNK	.set	0C0000060h
HSBLNK	.set	0C0000020h
VTOTAL	.set	0C0000070h
HTOTAL	.set	0C0000030h
DPYCTL	.set	0C0000080h
DPYSTRT	.set	0C0000090h
DPYINT	.set	0C00000A0h
CONTROL	.set	0C00000B0h
HSTDATA	.set	0C00000C0h
HSTADRL	.set	0C00000D0h
HSTADRH	.set	0C00000E0h
HSTCTLL	.set	0C00000F0h
HSTCTLH	.set	0C0000100h
INTENB	.set	0C0000110h
INTPEND	.set	0C0000120h
CONVSP	.set	0C0000130h
CONVDP	.set	0C0000140h
PSIZE	   .set	0C0000150h
PMASK		.set	0C0000160h
DPYTAP	.set	0C00001b0h
* I/O register locations 23-27 are reserved for future expansion
VCOUNT	.set	0C00001d0h
HCOUNT	.set	0C00001c0h
DPYADR	.set	0C00001E0h
REFADR	.set	0C00001F0h
*
	.endif

X	.set	1
Y	.set	010000h
W	.SET	0
L	.set	1

* Declarations for condition codes in Macros
GT	.set	'GT'
GE	.set	'GE'
LT	.set	'LT'
LE	.set	'LE'
EQ	.set	'EQ'
NE	.set	'NE'
Z	.set	'Z'
NZ	.set	'NZ'
NC	.set	'NC'
UC	.set	'UC'
N	.set	'N'

*-----------------------------------------------------------------------
* Masks for I/O register fields:
*-----------------------------------------------------------------------

*	STATUS BIT MASKS
CBIT	.EQU	40000000H

*	DISPLAY CONTROL REGISTER BIT DEFINITIONS
HSD	.set	01h		; Horizontal Sync Direction
VSD	.set	02h		; Vertical Sync Direction
CSD	.set	04h		; Composite Sync Direction
CVD	.set	08h		; Composite Video Disable
SSV	.set	040h		; Midline reload enable
VCE	.set	080h		; Video capture enable
CST	.set	0800h		; CPU serial register transfer enable
SRE	.set	01000h		; Screen Refresh Enable
NIL	.set	04000h		; Non-InterLaced video enable
ENV	.set	08000h		; ENable Video
*BIT POSITIONS IN DISPLAY CONTROL
B_CST	.SET	11		; BIT TO ENABLE CSTs
B_SSV	.SET	6		; BIT TO ENABLE SRTs

*	BIT FIELDS WITHIN CONTROL REGISTER
CD	.set	08000h		;Mask for Cache Dis bit in CONTROL
PPOP	.set	07C00h		;Mask for Pix Proc OPer in CONTROL
PBH	.set	0200h		;Mask for PBH bit in CONTROL
PBV	.set	0100h		;Mask for PBV bit in CONTROL
WIN	.set	0C0h		;Mask for Window field in CONTROL
T	 .set	020h		;Mask for Transparency field in CONTROL
TMD .set 3			;Mask for Transparency MODE in CONTROL
;old RR	.set	018h		;Mask for dram Refresh Rate bit in CONFIG
;old RM	.set	04h		;Mask for dram Refresh Mode bit in CONFIG

*	BITS WITHIN INTPEND AND INTENB
WVP	.set	0800h		;Mask for Window Violation in INTPEND
DIE	.set	0400h		;Mask for Disp Int in INTPEND
HIE	.set	0200h		;Mask for Host Int in INTPEND
X2E	.set	04h		;Mask for Ext Int 2 in INTPEND 
X1E	.set	02h		;Mask for Ext Int 1 in INTPEND
B_X1E	.set	1		;Bit Pos for Ext Int 1 in INTPEND
*	BIT POSITIONS IN INTPEND
DIP	.EQU	10		;BIT TEST FOR DISPLAY INTERRUPT PENDING

*	FIELDS WITHIN HSTCTLL
MSGIN	.set	07h	; Message from Host to GSP
INTIN_MSK	.set	08h	; GSP can write 0 to this bit (ANDNI)
INTIN_BIT	.set	03h		; GSP can write 0 to this bit (ANDNI)
INTOUT_MSK .set	080h	; GSP can write 1 to this bit (ORI)
INTOUT_BIT .set	07h		; GSP can write 1 to this bit (ORI)

* OPTIONS FOR WINDOW FIELD IN CONTROL REG
*W0	(ANDNI) No writes inhibited, no interrupt
W3	.set 0C0h	;inhibit writes outside window, no interrupt
W2	.set	080h 	;Int on attempt to write outside window.
W1	.set	040h 	;Inhibit all writes, Int on attempt to write within window

*OPTIONS FOR PIXEL PROC OPERATIONS IN CONTROL REG 
* PPOP  (ANDNI)	replace
P_AND	.set	0400h
P_ANDNOT	.set	0800h
P_ZERO	.set	0C00h
P_ORNOT	.set	01000h
P_XNOR	.set	01400h
P_NEG	.set	01800h
P_NOR	.set	01C00h
P_OR	.set	02000h
P_NOP	.set	02400h
P_XOR	.set	02800h
P_NOTAND	.set	02C00h
P_ONES	.set	03000h
P_NOTOR	.set	03400h
P_NAND	.set	03800h
P_NOT	.set	03C00h
P_ADD	.set	04000h
P_ADDS	.set	04400h
P_SUB	.set	04800h
P_SUBS	.set	04C00h
P_MAX	.set	05000h
P_MIN	.set	05400h

*-----------------------------------------------------------------------
* Define special A- and B-file registers
*-----------------------------------------------------------------------
* Special A-file registers:
***fp	.set	A13		;Frame, param. stack
***pstk	.set	A14		;Parameter stack pointer
***frame_pntr	.set	A14	;Used by C Compiler
* Special B-file registers:
*
*	B FILE REGISTER GRAPHICS DEFINITIONS
*
***saddr	.set	B0
***sptch	.set	B1
***daddr	.set	B2
***dptch	.set	B3
***offset	.set	B4
***wstart	.set	B5
***wend	.set	B6
***dydx	.set	B7
***color0	.set	B8
***color1	.set	B9
***count	.set	B10
***inc1	.set	B11
***inc2	.set	B12
***pattrn	.set	B13
*
SADDR	.set	B0		;Source address register
SPTCH	.set	B1		;Source pitch register
DADDR	.set	B2		;Dest. address register
DPTCH	.set	B3		;Dest. pitch register
OFFSET	.set	B4		;XY offset register
***WSTART	.set	B5		;Window start register
***WEND	.set	B6		;Window end register
DYDX	.set	B7		;Delta X/delta Y register
COLOR0	.set	B8		;Color 0 register
COLOR1	.set	B9		;Color 1 register
***COUNT	.set	B10
***INC1	.set	B11
***INC2	.set 	B12
***PATTRN	.set	B13

;**************************************************************************
;*									  *
;* 	            CMOS RAM EQUATE FILE				  *
;* 									  *
;* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		  *
;* 		       ALL RIGHTS RESERVED.				  *
;*									  *
;**************************************************************************

**************************************************************************
*								         *
* 	COINAGE STUFF							 *
*								         *
**************************************************************************

CHUTES		EQU	4		;MAXIMUM COIN CHUTES IN GAME.

L_COIN_BIT	EQU	1H
C_COIN_BIT	EQU	4H
R_COIN_BIT	EQU	2H
X_COIN_BIT	EQU	80H
SLAM_BIT	EQU	8H

MENU_PID	EQU	0AC1H		;GET_MENU SLAVE
MDUN_PID	EQU	0AC2H		;MENU SLAVE CHANGES TO THIS WHEN DONE

LONG_SIZE	EQU	32
WORD_SIZE	EQU	16
BYTE_SIZE	EQU	8

	.if	XUNIT=1
C_LONG_SIZE	EQU	128
C_WORD_SIZE	EQU	64
C_BYTE_SIZE	EQU	32
	.else
C_LONG_SIZE	EQU	64
C_WORD_SIZE	EQU	32
C_BYTE_SIZE	EQU	16
	.endif
CMOS_1K		EQU	C_BYTE_SIZE*1024

BYTE_MASK	EQU	0FFH
BM		EQU	BYTE_MASK	;STINKY SHORT-HAND
WORD_MASK	EQU	0FFFFH

SX_MASK		EQU	0FFFFH
SY_MASK		EQU	0FFFF0000H

**************************************************************************
*                                                                        *
*          ASCII STUFF                                                   *
*                                                                        *
**************************************************************************

SPACE		EQU	20H
EX_PT		EQU	21H
LET_0		EQU	30H
LET_A		EQU	41H
LET_Z		EQU	5AH
UNDERSCORE	EQU	5FH
FONT_SPACE	EQU	7EH
FONT_RUB	EQU	FONT_SPACE+1
FONT_END	EQU	FONT_RUB+1
FONT_RQUOTE	EQU	FONT_END+1
FONT_EPOUND	EQU	FONT_RQUOTE+1
FONT_CR		EQU	FONT_EPOUND+1
ASCII_COMMA	EQU	2CH
RIGHT_PAREN	EQU	29H
ASCII_DQ	EQU	22H

**************************************************************************
*                                                                        *
*          AUDIT STRUCTURE                                               *
*                                                                        *
**************************************************************************

AUD_DATA	EQU	0	;THE COUNTER IS 4 BYTES STARTING AT ZERO
AUD_CKSUM	EQU	AUD_DATA+(4*C_BYTE_SIZE)  ;CHECKSUM = 2 BYTES
AUD_SIZE	EQU	AUD_CKSUM+C_WORD_SIZE
AUD_BYTES_TO_CHECK EQU	(AUD_SIZE/C_BYTE_SIZE)-2  ;# TO ADD FOR CHECKSUM

N_AUDITS	EQU	75		;ALLOCATE AMPLE AUDIT SPACE


**************************************************************************
*                                                                        *
*          ADJUSTMENTS                                                   *
*                                                                        *
**************************************************************************
ADJ_SIZE	EQU	C_LONG_SIZE
N_ADJUSTS	EQU	31		;31 NORMAL ADJUSTMENTS


**************************************************************************
*                                                                        *
*                                                                        *
*          CMOS STUFF FOR HSTD..........MOVE THIS TO SPECIAL EQUATE FILE *
*          SOME DAY                                                      *
*                                                                        *
*                                                                        *
**************************************************************************

CMOS_PAGE_SELECT_BITS EQU 0C0H	;BITS 6 AND 7 OF SYSCTRL SELECT CMOS PAGE
CMOS_PAGE_SELECT_UNIT EQU 040H	;4 PAGES USE MULTIPLES OF THIS

*
*        AUDIT PAGE AUDIT DATA AND CREDITS
*
AUDITORG	EQU	CMOS				 ;AUDITS LIVE HERE

CREDITS		EQU	AUDITORG+(N_AUDITS*AUD_SIZE)	;BYTE FOR CREDITS
CUNITS		EQU	CREDITS+C_BYTE_SIZE		;WORD
BUNITS		EQU	CUNITS+C_WORD_SIZE		;WORD
MINUNITS	EQU	BUNITS+C_WORD_SIZE		;WORD
COIN_CKSUM	EQU	MINUNITS+C_WORD_SIZE		;BYTE
HSR_C		EQU	COIN_CKSUM+C_BYTE_SIZE		;LONG = HIGH SCORE RESET COUNTER
AUDIT_CMOSMEM	EQU	2*CMOS_1K			;TOTAL CMOS FOR AUDITS
*
*	NEXT TWO ARE ASSUMED TO BE BACK TO BACK
*
HRESET_COUNTER	EQU	HSR_C+C_LONG_SIZE		;LONG = HIGH SCORE RESET COUNTER
HRESET_VERIFY	EQU	HRESET_COUNTER+C_LONG_SIZE	;LONG = 2ND COPY INVERTED.

COIN_CKSUM_START EQU	CREDITS
COIN_CKSUM_SIZE  EQU	COIN_CKSUM-COIN_CKSUM_START	;SIZE OF REGION TO CHECK
COIN_CKSUM_BYTES EQU	COIN_CKSUM_SIZE/C_BYTE_SIZE	;NUMBER OF BYTES TO ADD

AUDIT_SELECT	EQU	CMOS_PAGE_SELECT_UNIT*1
HSR_SELECT	EQU	AUDIT_SELECT		;HIGH SCORE RESET COUNTER
COIN_SELECT	EQU	AUDIT_SELECT		;COINS AND CREDITS
*
ADJUST_SELECT	EQU	CMOS_PAGE_SELECT_UNIT*1
*
*
*	CUSTOM MESSAGE DEFINITIONS
*
CMESS_CHARS	EQU	18				;25 CHARS/LINE OF CUSTOM MESSAGE
CMESS_LINES	EQU	3				;3 LINES
CMESS_LINE_SIZE	EQU	CMESS_CHARS*C_BYTE_SIZE
CMESS_SIZE	EQU	CMESS_LINES*CMESS_LINE_SIZE

VALID_VALUE	EQU	0EABCH			;STORED AT "VALID_CUSTOM" IF OK!

NAME_REV_SIZE	EQU	30			;NAME AND REV DATA

ADJUSTORG	EQU	AUDITORG+AUDIT_CMOSMEM	;FIRST ADJUSTMENT HERE
CUSTOM_MESSAGE	EQU	ADJUSTORG+(N_ADJUSTS*ADJ_SIZE)
VALID_CUSTOM	EQU	CUSTOM_MESSAGE+CMESS_SIZE	;WORD = EABC IF OK.
END_CK_REGION	EQU	VALID_CUSTOM+C_WORD_SIZE
ADJ_AREA_SIZE	EQU	END_CK_REGION-ADJUSTORG		;ADJUSTS+CUSTOM MESSAGE
ADJ_CKSUM	EQU	END_CK_REGION			;WORD CHECK FOR ADJUSTS
ADJ_BYTES_TO_CHECK EQU	ADJ_AREA_SIZE/C_BYTE_SIZE	;NUMBER OF BYTES IN CHECKSUM.
NAME_REV	EQU	ADJ_CKSUM+C_WORD_SIZE
END_ADJ		EQU	NAME_REV+(NAME_REV_SIZE*C_BYTE_SIZE)
ADJUST_CMOSMEM	EQU	CMOS_1K				;TOTAL CMOS FOR ADJUSTMENTS

DUMP_ORG	EQU	ADJUSTORG+ADJUST_CMOSMEM
DUMP_SELECT	EQU	CMOS_PAGE_SELECT_UNIT*3
DUMP_PTR	EQU	DUMP_ORG		;WORD....NUMBER OF ENTRIES!
DUMP_DATA	EQU	DUMP_PTR+C_WORD_SIZE	;DUMPS GO HERE!
DUMP_CMOSMEM	EQU	2*CMOS_1K		;TOTAL CMOS FOR DUMPS
DUMP_END	EQU	DUMP_ORG+DUMP_CMOSMEM


**************************************************************************
*                                                                        *
*          COLOR STUFF -- PALETTE 0                                      *
*                                                                        *
**************************************************************************
TEXT_PAL	EQU	0101H			;FIXED TEXT PALETTE NUMBER
COLOR_RED	EQU	0101H
COLOR_WHITE	EQU	0202H
COLOR_BLUE	EQU	0303H
COLOR_GREY	EQU	0404H
COLOR_YELLOW	EQU	0505H
COLOR_PURPLE	EQU	0606H
COLOR_GREEN	EQU	0707H
COLOR_BLACK	EQU	0808H
COLOR_RGB	EQU	3B3BH
COLOR_DECAY	EQU	3C3CH
COLOR_BPR	EQU	3B3BH
COLOR_LF	EQU	3D3DH
*COLOR + PALETTE [COLOR,PALETTE]
COLOR_PRED	EQU	COLOR_RED*10000H+TEXT_PAL
COLOR_PWHITE	EQU	COLOR_WHITE*10000H+TEXT_PAL
COLOR_PBLUE	EQU	COLOR_BLUE*10000H+TEXT_PAL
COLOR_PGREY	EQU	COLOR_GREY*10000H+TEXT_PAL
COLOR_PYELLOW	EQU	COLOR_YELLOW*10000H+TEXT_PAL
COLOR_PPURPLE	EQU	COLOR_PURPLE*10000H+TEXT_PAL
COLOR_PGREEN	EQU	COLOR_GREEN*10000H+TEXT_PAL
COLOR_PBLACK	EQU	COLOR_BLACK*10000H+TEXT_PAL
COLOR_PRGB	EQU	COLOR_RGB*10000H+0000H
COLOR_PBPR	EQU	COLOR_BPR*10000H+0000H
COLOR_PDECAY	EQU	COLOR_DECAY*10000H+0000H
COLOR_PLF	EQU	COLOR_LF*10000H+0000H
;**************************************************************************
;*									  *
;* 	                 MASTER EQUATE FILE				  *
;*									  *
;**************************************************************************
radius	.set	120

XD0005	.set	0023ch
XD0010	.set	00478h
XD0015	.set	006b4h
XD0020	.set	008f0h
XD0030	.set	00d67h
XD0040	.set	011dfh
XD0050	.set	01657h
XD0060	.set	01acfh
XD0070	.set	01f47h
XD0080	.set	023bfh
XD0090	.set	02836h
XD0100	.set	02caeh
XD0110	.set	03126h
XD0120	.set	0359eh
XD0130	.set	03a16h
XD0140	.set	03e8dh
XD0150	.set	04305h
XD0200	.set	0595ch
XD0225	.set	06488h
XD0250	.set	06fb3h
XD0300	.set	0860bh
XD0400	.set	0b2b9h		;40 degrees is our crossover point
XD0450	.set	0c910h
XD0500	.set	0df67h
XD0570	.set	0feaeh		;57 degrees is our crossover point
XD0675	.set	12d98h
XD0800	.set	16572h		;80 degrees is our crossover point
XD0900	.set	19220h
XD1125	.set	1f6a8h
XD1350	.set	25b30h
XD1575	.set	2bfb7h
XD1800	.set	3243fh
XD2025	.set	388c7h
XD2250	.set	3ed4fh
XD2475	.set	451d7h
XD2700	.set	4b65fh
XD2925	.set	51ae7h
XD3150	.set	57f6fh
XD3375	.set	5e3f7h
XD3600	.set	6487fh
XD3825	.set	6ad07h
XD4050	.set	7118Fh

*ODATA EQUATES
ODT_DIR		.equ	ODATA		;UHL direction object is moving (s15:16 radians)
ODT_VEL		.equ	ODATA+020H	;UHL velocity magnitude of object (s15:16)
ODT_DVEL	.equ	ODATA+040H	;UHL angular velocity of object (s15:16 radians/tick)
ODT_PBK		.equ	ODATA+060H	;UHL player block address
ODT_GDIR	.equ	ODATA+080H	;UHL goal direction to move to - temporary
ODT_TURBO	.equ	ODATA+0a0H	;UHW non zero for non turbo - temporary

**************************************************************************
*								         *
* PLAYER BLOCK EQUATES							 *
*								         *
**************************************************************************
********************************
*			       *
* PLAYER PHYSICAL DATA	       *
*			       *
********************************
POF_NUMBER		.equ	0000h	;UHB 1-8
;
POF_IMAGE_TABLE		.equ	0020h	;UHL table for players images
POF_HEAD_TABLE		.equ	0040h	;UHL table to player head/helmet data
POF_CMOS		.equ	0060h	;UHW CMOS entry number for player
POF_CHARACTER		.equ	0070h	;UHW which player this is (person)
POF_TEAM		.equ	0080h	;UHW which team this is
POF_VISITOR		.equ	0090h	;UHW 0 - home, 1 - visitor
POF_MASS		.equ	00a0h	;UHW player mass
********************************
*			       *
* PLAYER ABILITY DATA	       *
*			       *
********************************
POF_S_SPED		.equ	0100h	;UHL table pointer - player speed data
POF_S_STOP		.equ	0120h	;UHL table pointer - player stopping data
POF_S_CORN		.equ	0140h	;UHL table pointer - player cornering data
POF_S_SHOT		.equ	0160h	;UHL table pointer - player shooting data
POF_S_PASS		.equ	0180h	;UHL table pointer - player passing data
POF_S_DUMP		.equ	01a0h	;UHL table pointer - player dumping data
POF_S_HAND		.equ	01c0h	;UHL table pointer - player handling data
POF_S_STAB		.equ	01e0h	;UHL table pointer - player shot table
********************************
*			       *
* PLAYER STATES		       *
*			       *
********************************
POF_FLAGS		.equ	0280h	;UHW - see below
POF_MODE		.equ	0290h	;UHW what player is doing (not valid during higher control)
********************************
*			       *
* PLAYER RELATED OBJECTS       *
*			       *
********************************
POF_OBJECT		.equ	0300h	;UHL players object
POF_SHADOW		.equ	0320h	;UHL players shadow object
POF_GOALIE_OBJECT	.equ	0340h	;UHL object of teams goalie
POF_ARROW		.equ	0360h	;UHL object of players arrow
POF_TURBO_BOX		.equ	0380h	;UHL turbo box object (or press start/insert coin)
POF_TURBO_BAR		.equ	03a0h	;UHL turbo bar object (or to control)
POF_TURBO_NAME		.equ	03c0h	;UHL turbo name object (both modes)
POF_ARROW_CPU		.equ	03e0h	;UHL if player is not human, object for his cpu title
********************************
*			       *
* PLAYER JOYSTICK DATA	       *
*			       *
********************************
POF_BUTTONS		.equ	0400h	;UHW buttons of player
POF_DIRECTION		.equ	0410h	;UHB last facing direction of player
POF_JOY			.equ	0418h	;UHB joystick direction (1-8)
POF_I_JOY		.equ	0420h	;UHB ignore this joystick direction
POF_M_JOY		.equ	0428h	;UHB modified joystick direction (1-8)
POF_CORNER_TEMP		.equ	0430h	;UHB last corner check for diagonal removal
********************************
*			       *
* MISC PLAYER DATA	       *
*			       *
********************************
POF_SHOT_FAKE		.equ	0500h	;UHL time of last shot start (waveirqs)
POF_SHOT_START		.equ	0520h	;UHL started shooting at this time (for fake test and dump puck tests)
POF_SPEED_GL		.equ	0540h	;UHL used to see if we are speeding up or slowing down
POF_PASS_START		.equ	0560h	;UHL started passing at this time (for dump puck tests)
POF_SHOOT_CURRENT	.equ	0580h	;UHL current shoot speed (for calculations and reference)
POF_SPEED_BOOST		.equ	05a0h	;SHL stuffed at control start, is 0 or defense boost, or negative puck against
POF_TURBO_AMOUNT	.equ	05c0h	;SHL turbo amount s15:16
POF_SHOT_RELEASE	.equ	05e0h	;UHL call this on a release of shoot, during a shoot
POF_SHOT_PASS		.equ	0600h	;UHL call this on a pass during a shoot
POF_LAST_BOARD_CVEL	.equ	0620h	;UHL last velocity of board crash
POF_ARROW_TIME		.equ	0640h	;UHW time left to show arrow
;POF_STRAIGHT_TIME	.equ	0650h	;UHW time spent going in a straight line
POF_TURBO_DELAY		.equ	0660h	;SHW delay till we bring turbo up
POF_TURBO_MODE		.equ	0670h	;SHW turbo is on when <> 0
POF_STAND_STILL		.equ	0680h	;UHB player is standing still # ticks
POF_IGNORE_PUCK		.equ	0688h	;UHB ignore puck till this is zero
POF_ARROW_HYST		.equ	0690h	;UHB player arrow hysteresis
POF_TOP_MODE		.equ	0698h	;UHB current state of top
POF_SKID_BOOST		.equ	06a0h	;UHB current skid boost
********************************
*			       *
* PLAYER DISTANCE DATA	       *
*			       *
********************************
POF_D_1P		.equ	0700h	;UHW distance to player 1
POF_D_2P		.equ	0710h	;UHW distance to player 2
POF_D_3P		.equ	0720h	;UHW distance to player 3
POF_D_4P		.equ	0730h	;UHW distance to player 4
POF_D_5P		.equ	0740h	;UHW distance to player 5
POF_D_6P		.equ	0750h	;UHW distance to player 6
POF_D_7P		.equ	0760h	;UHW distance to player 7
POF_D_8P		.equ	0770h	;UHW distance to player 8


;POF_TOP_MODE
;	0 - nothing on top
;	1 - name/turbo bar
;	2 - press start
;	3 - insert coin(s)
;	4 - to control/player
;	5 - please wait

;POF_MODE
;	0  - standing
;	1  - skating
;	2  - passing
;	3  - shooting
;	4  - skidding to stop (for reverse or stop)
;	5  - swatting at puck
;	6  - pushing
;	7  - falling
;	8  - player directed, non destination shot (dump)
;	100 - goalie standing

;POF_BUTTONS		.equ	01a0h	;UHW buttons of player
;	bit 0 - shoot
;	    1 - pass
;	    2 - turbo


*POF_FLAGS EQUATES
B_PF_HUMAN	.equ	0	;player is human
B_PF_CONTROL	.equ	1	;player has control over his man
B_PF_GOALIE	.equ	2	;PLAYER BLOCK IS GOALIE
B_PF_OKDIR	.equ	3	;ok to set player direction exactly
B_PF_HIGHER	.equ	4	;a higher power has control of player (after score, etc)
B_PF_HIGHER_W	.equ	5	;a higher power is waiting to take control
B_PF_SIG_SHOOT	.equ	6	;player is signalling shoot
B_PF_SIG_PASS	.equ	7	;player is signalling pass

M_PF_HUMAN	.equ	0000000000000001b
M_PF_CONTROL	.equ	0000000000000010b
M_PF_GOALIE	.equ	0000000000000100b
M_PF_OKDIR	.equ	0000000000001000b
M_PF_HIGHER	.equ	0000000000010000b
M_PF_HIGHER_W	.equ	0000000000100000b
M_PF_SIG_SHOOT	.equ	0000000001000000b
M_PF_SIG_PASS	.equ	0000000010000000b

***************
*	      *
* POF_S_SPED  *
*	      *
***************
PS_SP_SPEED_0			.equ	0000h	;UHL speed to start moving
PS_SP_SPEED_1			.equ	0020h	;UHL player speed 1
PS_SP_SPEED_2			.equ	0040h	;UHL player speed 2
PS_SP_S0_THRESH			.equ	0060h	;UHL threshhold to switch from speed 0 to speed 1
PS_SP_SPEED_THRESH		.equ	0080h	;UHL threshold to switch speeds from speed_1 to speed_2
PS_SP_TURBO_0			.equ	00A0h	;UHL turbo speed to start moving
PS_SP_TURBO_1			.equ	00C0h	;UHL player turbo speed 1
PS_SP_TURBO_2			.equ	00E0h	;UHL player turbo speed 2
PS_SP_T0_THRESH			.equ	0100h	;UHL threshhold to switch from turbo 0 to turbo 1
PS_SP_TURBO_THRESH		.equ	0120h	;UHL threshold to switch speeds from turbo_1 to turbo_2
PS_SP_DEFENSE_BOOST		.equ	0140h	;UHL add to speeds when on defense
PS_SP_CONTROL_PENALTY		.equ	0160h	;UHL penalty for when player has puck (is subtracted)
PS_SP_SAME_0_MT			.equ	0180h	;UHB same direction starting speed move to
PS_SP_SAME_L_MT			.equ	0188h	;UHB same direction low speed move to
PS_SP_SAME_H_MT			.equ	0190h	;UHB same direction high speed move to
;
PS_SP_TURBO_DOWN		.equ	01A0h	;UHW to add going down
PS_SP_TURBO_UP			.equ	01B0h	;UHW to add going up

***************
*	      *
* POF_S_STOP  *
*	      *
***************
PS_ST_STOP_THRESH		.equ	0000h	;UHL player will stop when going this slow
PS_ST_RSTOP_THRESH		.equ	0020h	;UHL player will stop when reverse going this slow
PS_ST_SKID_R_MT			.equ	0040h	;UHB skid reverse move to
PS_ST_SKID_S_MT			.equ	0048h	;UHB skid stop move to
PS_ST_TSKID_R_MT		.equ	0050h	;UHB turbo skid reverse move to
PS_ST_TSKID_S_MT		.equ	0058h	;UHB turbo skid stop move to
PS_ST_DEFENSE_SKID		.equ	0060h	;UHB add to skid mt if defense
;

***************
*	      *
* POF_S_CORN  *
*	      *
***************
PS_CR_SKID			.equ	0000h	;UHL if we want to change by > this, skid to stop
PS_CR_TURN_TABLE		.equ	0020h
PS_CR_TURN_TABLE_D		.equ	0040h
PS_CR_TURN_TABLE_C		.equ	0060h
***************
*	      *
* POF_S_SHOT  *
*	      *
***************
PS_SH_SHOOT0_SPEED		.equ	0000h	;UHL initial speed used to shoot at goal
PS_SH_SHOOT_SPEED		.equ	0020h	;UHL final speed used to shoot at goal
PS_SH_SHOOT0_TURBO		.equ	0040h	;UHL initial turbo speed used to shoot at goal
PS_SH_SHOOT_TURBO		.equ	0060h	;UHL final turbo speed used to shoot at goal
PS_SH_MAX_YVEL			.equ	0080h	;UHL maximum y velocity player can give to puck (negative of yvel)
PS_SH_SHOOT_MT			.equ	00A0h	;UHB move to amount on shoot speed
PS_SH_SHOOTT_MT			.equ	00A8h	;UHB move to amount on shoot speed turbo
PS_SH_SHOT_CHANGE		.equ	00B0h	;UHL called to change shot angle
PS_SH_TSHOT_CHANGE		.equ	00D0h	;UHL called to change turbo shot angle

***************
*	      *
* POF_S_PASS  *
*	      *
***************
PS_PS_PASS_SPEED		.equ	0000h	;UHL speed used to pass to other player
PS_PS_PASS_TURBO		.equ	0020h	;UHL turbo speed used to pass to other player
PS_PS_PASS_GTHRESH		.equ	0040h	;UHW passes below this distance stay on ice
PS_PS_PASS_MTHRESH		.equ	0050h	;UHW passes below this distance sometimes stay on ice
PS_PS_TPASS_GTHRESH		.equ	0060h	;UHW turbo passes below this distance stay on ice
PS_PS_TPASS_MTHRESH		.equ	0070h	;UHW turbo passes below this distance sometimes stay on ice
PS_PS_PASS_CHANGE		.equ	0080h	;UHL called to change pass angle
PS_PS_TPASS_CHANGE		.equ	00A0h	;UHL called to change turbo shot angle

***************
*	      *
* POF_S_DUMP  *
*	      *
***************
PS_DP_DUMP_SPEED		.equ	0000h	;UHL speed used to dump puck
PS_DP_DUMP_TURBO		.equ	0020h	;UHL turbo speed used to dump
PS_DP_DUMP_CHANGE		.equ	0040h	;UHL called to change dump shot angle
PS_DP_TDUMP_CHANGE		.equ	0060h	;UHL called to change turbo dump shot angle

***************
*	      *
* POF_S_HAND  *
*	      *
***************
PS_HN_INT_CONTROL		.equ	0000h	;UHL called to see if we control after an intended pass
PS_HN_OFF_CONTROL		.equ	0020h	;UHL called to see if we control after an offensive stop
PS_HN_DEF_CONTROL		.equ	0040h	;UHL called to see if we control after a defensive stop

;**************************************************************************
;*									  *
;* OBJECT I.D. EQUATES							  *
;* 	       15		   0					  *
;* OID FORMAT -- SSSS SIII IIII IIII	new				  *
;* 	S = SUPPLEMENTAL LIST #						  *
;* 	I = IDENTIFIER(SUB-TYPE)					  *
;* 									  *
;* xxxx x000 0000 0000 (OID) xxxx=bit positions of supp field		  *
;*									  *
;**************************************************************************
;If # of bits changed, fix size of ram table SUPPLSTS
SR_SUPP	.set	11	;knock off bottom bits

*
*GENERIC OBJECT SUPPLEMENTAL I.D. EQUATES
*
SUPP_0	.EQU	0
SUPP_1	.EQU	00800H		;players
SUPP_2	.EQU	01000H		;players shadows
SUPP_3	.EQU	01800H
SUPP_4	.EQU	02000H
SUPP_5	.EQU	02800H
SUPP_6	.EQU	03000H
SUPP_7	.EQU	03800H
SUPP_8	.EQU	04000H
SUPP_9	.EQU	04800H
SUPP_10	.EQU	05000H
SUPP_11	.EQU	05800H
SUPP_12	.EQU	06000H
SUPP_13	.EQU	06800H
SUPP_14	.EQU	07000H
SUPP_15	.EQU	07800H

*
*POWERUP PROCESS AND OBJECT IDENTIFIER EQUATES
*

OID_JUNK		EQU	0300H		;SHIT THAT CLUTTERS THE PLAYFIELD

OID_TEXT		EQU	0480H		;"OBJECT LIST" TEXT
OID_CREDIT		EQU	0488H		;CREDIT MESSAGE TEXT
OID_PROMPT		EQU	0489H		;"READY FOR" MESSAGE
OID_PROMPT2		EQU	048AH		;"PRESS START" MESSAGE
OID_CUSTOM		EQU	048BH		;CUSTOM MESSAGE, COINAGE, MAX CRED, ETC.
OID_REQUIRED		EQU	048CH		;CREDITS REQUIRED MESSAGE

OID_PLAYER_1		EQU	SUPP_1+00110H
OID_PLAYER_2		EQU	SUPP_1+00120H
OID_PLAYER_3		EQU	SUPP_1+00130H
OID_PLAYER_4		EQU	SUPP_1+00140H
OID_PLAYER_5		EQU	SUPP_1+00150H
OID_PLAYER_6		EQU	SUPP_1+00160H
OID_PLAYER_7		EQU	SUPP_1+00170H
OID_PLAYER_8		EQU	SUPP_1+00180H
OID_PLAYER_1_SHAD	EQU	SUPP_2+00111H
OID_PLAYER_2_SHAD	EQU	SUPP_2+00121H
OID_PLAYER_3_SHAD	EQU	SUPP_2+00131H
OID_PLAYER_4_SHAD	EQU	SUPP_2+00141H
OID_PLAYER_5_SHAD	EQU	SUPP_2+00151H
OID_PLAYER_6_SHAD	EQU	SUPP_2+00161H
OID_PLAYER_7_SHAD	EQU	SUPP_2+00171H
OID_PLAYER_8_SHAD	EQU	SUPP_2+00181H

OID_PUCK		EQU	0200h
OID_HEAD		EQU	0201h
OID_PUCK_SHADOW		EQU	0202h
OID_GOAL		EQU	0203H		;goal objects
OID_BACKWALL		EQU	0204H		;back wall images
OID_EDGE		EQU	0205H		;edge rink pieces

OID_TURBO_1		EQU	0301H		;turbo images (score display)
OID_TURBO_2		EQU	0302H		;turbo images (score display)
OID_TURBO_5		EQU	0305H		;turbo images (score display)
OID_TURBO_6		EQU	0306H		;turbo images (score display)
OID_TURBOBAR_1		EQU	0311H		;turbo bar image (score display)
OID_TURBOBAR_2		EQU	0312H		;turbo bar image (score display)
OID_TURBOBAR_5		EQU	0315H		;turbo bar image (score display)
OID_TURBOBAR_6		EQU	0316H		;turbo bar image (score display)
OID_TURBONAME_1		EQU	0321H		;turbo images (turbo name)
OID_TURBONAME_2		EQU	0322H		;turbo images (turbo name)
OID_TURBONAME_5		EQU	0325H		;turbo images (turbo name)
OID_TURBONAME_6		EQU	0326H		;turbo images (turbo name)

OID_LOGO		EQU	0400H		;attract mode logos
OID_DUMMYPAGE		EQU	0401H		;dummy page filler objects

OID_ARROW		EQU	0500H		;arrow objects
OID_CPU			EQU	0501H		;cpu label objects

MASK_OID_TIMER_SCORE	EQU	07F8H
OID_TIMER_1		EQU	0600H		;timer objects
OID_TIMER_2		EQU	0601H		;timer objects
OID_TIMER_3		EQU	0602H		;timer objects
OID_TIMER_4		EQU	0603H		;timer objects
OID_TIMER_5		EQU	0604H		;timer objects

OID_SCORE_1		EQU	0610H		;score objects
OID_SCORE_2		EQU	0611H		;score objects
OID_SCORE_3		EQU	0612H		;score objects
OID_SCORE_4		EQU	0613H		;score objects
OID_SCORE_5		EQU	0614H		;score objects
OID_SCORE_6		EQU	0615H		;score objects
OID_SCORE_7		EQU	0616H		;score objects
OID_SCORE_8		EQU	0617H		;score objects


;**************************************************************************
;*									  *
;* PROCESS I.D. EQUATES							  *
;*      	       15                  0				  *
;* PID FORMAT --	NIII IIII IIII IIII				  *
;* 	N = NON-DESTRUCTIBLE						  *
;* 	O = RESERVED FOR PROCESSES ASSOCIATED WITH OBJECTS OF LIKE I.D.s  *
;* 	I = PROC. SPECIFIC I.D.						  *
;*									  *
;**************************************************************************
M_INDESTRUCT		EQU	08000H		;MASK FOR NON-DESTRUCTIBLE BIT

PID_IND			EQU	0000CH		;INDEPENDENT PROCESS
PID_INDW		EQU	0200CH		;WAVE END WILL NOT KILL IND. PROCESS

PID_COLOR		EQU	02CC0H		;COLOR CYCLE PROCESSES
PID_PFADE		EQU	02D00H		;FADER PROCESSES ( LOW BYTE = PAL )

PID_LC			EQU	08F00H	;08F00H	;LEFT COIN      
PID_CC			EQU	08F01H	;08F20H	;CENTER COIN    
PID_RC			EQU	08F02H	;08F40H	;RIGHT COIN     
PID_XC			EQU	08F03H	;08F60H	;FOURTH COIN SLOT
PID_SLAM		EQU	08F04H	;08F80H	;SLAM TILT PROCESS
PID_COINCTR		EQU	08F05H	;08FA0H	;COIN COUNTER PROCESS
PID_DIAG		EQU	08F06H	;08100H	;DIAGNOSTICS PROCESS
PID_VOLUME		EQU	08F07H		;Volume adjust process
;PID_VOLUME_DISP	EQU	08F08H		;Volume display page deleter process
PID_VOLRESET		EQU	08F09H		;Delayed volume set process

PID_PLAYER_1		EQU	00100H		;base for player
PID_PLAYER_2		EQU	00200H		; specific processes
PID_PLAYER_3		EQU	00300H		;
PID_PLAYER_4		EQU	00400H		;
PID_PLAYER_5		EQU	00500H		;
PID_PLAYER_6		EQU	00600H		;
PID_PLAYER_7		EQU	00700H		;
PID_PLAYER_8		EQU	00800H		;

PID_RINK_WATCH		EQU	00900H		;rink movement process
PID_PUCK_WATCH		EQU	00901H		;puck watching process
PID_PLAYER_WATCH	EQU	00902H		;keep players on the ice
PID_GAME_TIMER		EQU	00903H		;game timer decrement
PID_PUCK_SOUND		EQU	00904H		;delay to let puck stuff happen before sound

PID_GOAL_CYCLE		EQU	00a00H		;process that handles sequence from goal to face off
PID_MOVE_TO		EQU	00a01H		;for moving 1 player to a point (higher control)
PID_SCORE_DISPLAY	EQU	00a02H		;puts up and takes down scores
PID_SEQUENCE		EQU	00a03H		;handles sequence from initial entry to start of period 1

PID_FACEOFF		EQU	00b00H		;process that handles faceoffs
PID_ATTRACT_MODE	EQU	01000H		;attract mode process

;offsets from player base for player processes
PIDOF_WATCH_SHOOT	EQU	00001H		;watch for shoot button open
PIDOF_PASS		EQU	00002H		;pass process id (so pass and shoot can kill)
PIDOF_PASS_SHOOT	EQU	00003H		;pass and shoot process id

;**************************************************************************
;*									  *
;* 		PALETTE ALLOCATOR EQUATES				  *
;*									  *
;**************************************************************************

*PALETTE ALLOCATION RAM
*FOR EACH COLOR PALETTE:
*PALETTE ID 32 BITS, PALETTE COUNT 16 BITS, PALETTE TIME 16 BITS.
*IF PALCNT>0 PALETTE IS ALLOCATED.
*IF (PALCNT=0) & (CURTIME-PALTIME >= 1) THEN PALETTE IS FREE
*
NUMPAL		.SET	128	;NUMBER OF DYNAMICS ALLOCATED PALETTES
NMFPAL		.SET	128	;NUMBER OF FOREGROUND PALETTES

*PALETTE ENTRY DATA STRUCTURE
PALID		.SET	0		;PALETTE I.D.				(32)
PALCNT		.SET	020H		;PALETTE ALLOCATION COUNT		(16)
PALTIME		.SET	030H		;TIME WHEN PAL WAS DELETED
PALRSIZ		.SET	040H		;SIZE OF PALETTE ALLOCATION RAM
;mdp*
;mdp*PALETTE TRANSFER RAM DATA STRUCTURE
;mdpPLDCNT	.SET	0	;COLOR COUNT					(16)
;mdpPALSRC	.SET	010H  	;SOURCE ADDRESS OF PALETTE COLOR DATA 		(32)
;mdpPALDEST	.SET	030H	;DESTINATION PALETTE|START COLOR		(16)
;mdpPTRSIZ	.SET	040H	;SIZE OF EACH CELL
;mdpNUMPTR	.SET	32	;NUMBER OF TRANSFERS ALLOWED
;mdp
;mdp*PALETTE MODE STUFF

M_FADE_WHITE			EQU	1
M_DONT_FADE_RED			EQU	2
M_DONT_FADE_GREEN		EQU	4
M_DONT_FADE_BLUE		EQU	8

B_FADE_WHITE			EQU	0
B_DONT_FADE_RED			EQU	1
B_DONT_FADE_GREEN		EQU	2
B_DONT_FADE_BLUE		EQU	3

*FIXED COLOR CYCLE EQUATES
*
	.if	XUNIT=1
CYCOLORS	.EQU	COLRAM+(300H*2)	;CYCLABLE COLORS LAST LINE OF 1st PALETTE
	.else
CYCOLORS	.EQU	COLRAM+(300H)		;CYCLABLE COLORS LAST LINE OF 1st PALETTE
	.endif
COLROFFST	.EQU	090H  		;OFFSET TO START COLORS
COLRCNT		.EQU	6	     	;TOTAL NUMBER OF COLORS TO CYCLE

;mdp;PCYCLEPAL	.EQU	0H		;PLAYER CYCLERS
;mdp;PCOLROFFST	.EQU	300H+090H	;OFFSET TO 1st PLAYER CYCLER
;mdp;PCOLRCNT	.EQU	2		;NUMBER OF PLAYER CYCLERS

*
*GAME STATE CONSTANTS
INGAME		.EQU	10H
ININTRO		.EQU	18H
INPLAY		.EQU	20H
INAMODE		.EQU	30H
INDIAG		.EQU	40H
INGAMEOV 	.EQU	50H
INEPILOG	.EQU	60H
*
*DISPLAY FLAGS FOR FORE/BACKGROUND OBJECTS
;mdpM_SPAWNP EQU	80H		;SPAWN A PROCESS WITH THIS OBJECT IN A8
;mdpB_SPAWNP EQU	7
;**************************************************************************
;*									  *
;* 	             MENU EQUATE FILE					  *
;* 									  *
;* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		  *
;* 		       ALL RIGHTS RESERVED.				  *
;*									  *
;**************************************************************************

*
*	FOR EACH ENTRY IN THE MENU
*
MENU_TEXT_PTR	EQU	0		;OFFSET OF TEXT POINTER
MENU_ROUTINE	EQU	LONG_SIZE	;OFFSET OF ROUTINE
MENU_HELP	EQU	MENU_ROUTINE+LONG_SIZE
MENU_ENTRY_SIZE	EQU	3*LONG_SIZE   
*
BLNK_HELP	EQU	0		;NO HELP BOX FOR THIS ENTRY
NO_HELP		EQU	00000001H	;NO HELP AREA IN THIS MENU 
ADJ_HELP	EQU	00000002H	;PASS STRUCTURE POINTER TO ADJUSTMENT HELP ROUT
SND_HELP	EQU	00000003H	;CALLED ON SOUND TEST MENU
SND_PLAY	EQU	00000004H	;CALLED FROM SOUND "PLAY" SELECTIONS
*
SND_MESS_Y       EQU	190
SND_BOX_H        EQU	57

*
*	SPACING BETWEEN BOXES ON SCREEN
*
BOX_YGAP EQU	3
BOX_XGAP EQU	5
*
*
*	A CENTERED BOX NEEDS TO BE MOVED LEFT THIS AMOUNT
*	(PIXELS) TO CORRECTELY FRAME CENTERED TEXT AT
*	THE SAME POSITION
*
*C_KLUDGE EQU	3		;BEFORE "SPACE WIDTH" BUG FIX
C_KLUDGE EQU	1
*
*	THESE DETERMINE THE THICKNESS OF THE BOX LINES
*
MB_XWID	EQU	3
MB_YWID	EQU	3

*
*	GAP BETWEEN A MENU BORDER BOX AND
*	THE SELECTION BAR
*
GAP	EQU	2		;GAP BETWEEN BORDER AND SELECTION BAR
*
*	CONSTANT TO PASS TO "DO_BORDER" FOR OUR
*	BOX SIZE
*
BORDER_SIZE	EQU	(MB_YWID*10000H)+MB_XWID

*******************************TEST TITLE CONSTANTS****************************
*
*	THESE ARE USED TO SET TOP BOX AND MAIN TITLE.
*	THE MENUS AND HELP SCREENS WILL SQUARE OFF 
*	TO THE NUMBERS SET HERE.
*
TM_X	EQU	200
TM_Y	EQU	24

TIT_ULX	EQU	TM_X-195
TIT_LRX	EQU	TM_X+189
TIT_ULY	EQU	TM_Y-06
TIT_LRY	EQU	TM_Y+32

********************************MAIN MENU CONSTANTS***************************

INST_ULY	EQU	TIT_LRY+BOX_YGAP	;Y RANGE FOR INSTRUCTION BOX
INST_LRY	EQU	INST_ULY+29
BAR_DY		EQU	-8
BAR_WID		EQU	183
;BAR_WID	EQU	(TIT_LRX-TIT_ULX)
;MENU_DY	EQU	27
MENU_DY		EQU	23
BAR_HITE	EQU	26
BAR_DX		EQU	6

MENU_X		EQU	TIT_ULX+GAP+MB_XWID+(BAR_WID/2)+C_KLUDGE
MENU_Y		EQU	INST_LRY+BOX_YGAP+MB_YWID+GAP-BAR_DY
*
*	HELP DRAWER CONSTANTS
*
HELP_X_MARGIN	EQU	10		;MARGIN FOR LEFT JUSTIFIED HELP TEXT
HELP_Y_MARGIN	EQU	8		;TOP OF BOX TO 1ST ENTRY
HELP_YLO_MARGIN	EQU	HELP_Y_MARGIN-4	;BOTTOM MARGIN IS A TOUCH LESS DUE
*					;TO SPACING
HELP_DY		EQU	12		;SCREEN UNITS PER ITEM.
*
*
*	ADJUSTMENT MENU CONSTANTS
*
*	"CURRENT SETTING" BOX
*
CUR_ULY		EQU	125
CUR_LRX		EQU	TIT_LRX
CUR_LRY		EQU	CUR_ULY+(INST_LRY-INST_ULY)	;SAME HEIGHT AS TOP BOX
CUR_ULY2	EQU	180
CUR_LRY2	EQU	CUR_ULY2+(INST_LRY-INST_ULY)
*
ADJ_ULY		EQU	CUR_LRY2+BOX_YGAP		;USE OUR "FIXED" SPACING.
ADJ_CULY	EQU	ADJ_ULY-50			;COIN UPPER LEFT Y
ADJ_PULY	EQU	ADJ_ULY-28
*
;COIN_HEAD_Y	EQU	CUR_ULY+91	;1ST OF TOP COIN INFO LINES
COIN_HEAD_Y	EQU	CUR_ULY+71	;1ST OF TOP COIN INFO LINES
MESS_CTS	EQU	COIN_HEAD_Y+35	;START/CONTINUE PLACE

**************************************************************************
*								         *
* 		COIN SELECT TABLE OFFSETS				 *
*								         *
**************************************************************************
*
*	IF "CHUTES" VALUE CHANGES.....EXTRA WORDS MUST BE PUT HERE
*
CS_LMULT	EQU	0
CS_CMULT	EQU	CS_LMULT+WORD_SIZE
CS_RMULT	EQU	CS_CMULT+WORD_SIZE
CS_XMULT	EQU	CS_RMULT+WORD_SIZE
CS_UCRED	EQU	CS_XMULT+WORD_SIZE
CS_UBON		EQU	CS_UCRED+WORD_SIZE
CS_UMIN		EQU	CS_UBON+WORD_SIZE
*CS_STRT	EQU	CS_UMIN+WORD_SIZE     
*CS_CONT	EQU	CS_STRT+WORD_SIZE     
CS_CDIV		EQU	CS_UMIN+WORD_SIZE
CS_FRAC		EQU	CS_CDIV+WORD_SIZE
CS_COPY		EQU	CS_FRAC+WORD_SIZE	;UP TO HERE IS COPIED AS ADJUSTMENTS
CS_LVAL		EQU	CS_COPY
CS_CVAL		EQU	CS_LVAL+WORD_SIZE
CS_RVAL		EQU	CS_CVAL+WORD_SIZE
CS_XVAL		EQU	CS_RVAL+WORD_SIZE
CS_LMES		EQU	CS_XVAL+WORD_SIZE
CS_RMES		EQU	CS_LMES+LONG_SIZE
CS_PROMPT	EQU	CS_RMES+LONG_SIZE
CS_TITLE	EQU	CS_PROMPT+LONG_SIZE
CS_LIST		EQU	CS_TITLE+LONG_SIZE
CS_PICK		EQU	CS_LIST+LONG_SIZE	;WHICH LINE TO ADD TO 2 TO START...1 TO
CS_SLOTS	EQU	CS_PICK+WORD_SIZE	;TEXT DESCRIBING COIN SLOTS
CS_SIZE		EQU	CS_SLOTS+LONG_SIZE
*
*
*	ADJUSTMENT STRUCTURE.   THIS STRUCTURE IS
*	POINTED TO BY THE 2ND MENU LONG WORD (WHERE NORMALLY
*	THE ROUTINE LIVES).  
*
AD_ROUT		EQU	0			;LONG...ROUTINE TO RUN WHEN SELECTED.
AD_TITLE	EQU	AD_ROUT+LONG_SIZE	;LONG...POINTER TO TITLE FOR RIGHT COLUMN
AD_HELP		EQU	AD_TITLE+LONG_SIZE	;LONG...POINT TO HELP STRUCT FOR EXPLANATION
AD_CMOS		EQU	AD_HELP+LONG_SIZE	;WORD...GET_ADJ / PUT_ADJ NUMBER.
AD_MIN		EQU	AD_CMOS+WORD_SIZE	;LONG...MINIMUM VALUE FOR ADJ.
AD_MAX		EQU	AD_MIN+LONG_SIZE	;LONG...MAXIMUM VALUE FOR ADJ.
AD_DELTA	EQU	AD_MAX+LONG_SIZE	;LONG...UNITS BETWEEN VALUES.
AD_ZEQU		EQU	AD_DELTA+LONG_SIZE	;LONG...NUMBER TO STORE AS A ZERO.
AD_NAMEIT	EQU	AD_ZEQU+LONG_SIZE	;LONG...ROUTINE TO PRINT VALUES.
AD_FLAGS	EQU	AD_NAMEIT+LONG_SIZE	;WORD...bit zero non zero says wrap 
						;	bit one non zero says BCD
						;	bit two says flag "1st 8 coinage changed"  (ADJVIRGIN)
						;	bit three says flag 1st 6 changed  (ADJ1st6)
						;	bit four says its hsr counter
AD_NAMPTR	EQU	AD_FLAGS+WORD_SIZE	;LONG...POINTER TO DATA FOR NAMEIT ROUTINE
AD_MAIN		EQU	AD_NAMPTR+LONG_SIZE	;LONG...MAIN MENU STRING

WRAP_BIT	EQU	0
BCD_BIT		EQU	1
VIRG_BIT	EQU	2
SIX_BIT		EQU	3
HSR_BIT		EQU	4
WRAP_VAL	EQU	1
BCD_VAL		EQU	2
VIRG_VAL	EQU	4
SIX_VAL		EQU	8
HSR_VAL		EQU	16
*
*	FOR CSELECT TABLE......
*
*	A1 = 1  PLOT ONLY THE STRING LIST (1 OR 2 POINTERS
*		CENTERED APPROPRIATELY
*
*	A1 = 2  PLOT THE 1ST LINE OF THE STRING LIST ALONG
*		WITH THE 2 CREDITS TO START...1 TO CONTINUE
*        
*	A1 = 3  PLOT THE 2ND LINE OF THE STRING LIST ALONG
*		WITH THE 2 CREDITS TO START...1 TO CONTINUE
*
CSM_LIST	EQU	1
CSM_1W_21	EQU	2
CSM_2W_21	EQU	3
CSM_3W_21	EQU	4
CSM_LAST	EQU	4

*
*	FOR CS_PICK:
*
SHOW_NONE	EQU	0		;JUST USE 2/1 BY ITSELF 
SHOW_1		EQU	2		;SHOW 1ST LINE
SHOW_2		EQU	3		;SHOW 2ND LINE
SHOW_3		EQU	4		;SHOW 3RD LINE

;**************************************************************************
;*									  *
;* 	                 DIPSWITCH EQUATE FILE				  *
;* 									  *
;* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		  *
;* 		       ALL RIGHTS RESERVED.				  *
;* 									  *
;**************************************************************************
;	DIP SWITCH
DPMIRROR	EQU	0001H		;MIRROR DISPLAY SWITCH
DPMIRROR_RAW	EQU	0001H		;RAW POSITION FROM PORT (Steve & John fixed it!)

DPUSECMOS	EQU	0002H		;USE CMOS MASK

DPCOINAGE	EQU	001CH		;COINAGE MASK
SR_DPCOINAGE	EQU	2		;shift count to Right justify COINAGE bits

DPCREDITS	EQU	00E0H		;CREDITS TO START/CONTINUE MASK
SR_DPCREDITS	EQU	5		;shift count to Right justify CREDITS bits

DPCOUNTRY	EQU	0300H		;COUNTRY MASK
SR_DPCOUNTRY	EQU	8		;shift count to Right justify COUNTRY bits

DPUNUSED1	EQU	0400H		;UNUSED BIT 1
DPCOUNTER	EQU	0800H		;NUMBER OF COIN COUNTERS

DPPLAYERS	EQU	3000H		;NUMBER OF HARDWARE PLAYERS 
SR_DPPLAYERS	EQU	12		;shift count to Right justify PLAYERS bits

DPFREEZE	EQU	4000H		;FREEZE SWITCH
DPTEST		EQU	8000H		;TEST SWITCH

	.if XUNIT=0					; I assigned these to unused switches
DPVALIDATOR	EQU	128		;DOLLAR BILL VALIDATOR INSTALLED
DPVALIDATOR_SRL	EQU	7		;SHIFT TO RIGHT JUSTIFY

DPPOWER		EQU	64		;Tournament mode
DPPOWER_B	EQU	6
	.endif
;
;	0 = OFF
;	1 = ON
;
;	THANKS TO MARK LOFFREDO FOR REAMING ME OVER AND REVERSING THE
;	DIP SWITCHES
;
;	DPMIRROR ( DS1 - 1 )
;
;	0 	= VIDEO SCREEN VIEWED THROUGH A MIRROR (IN CABINET)
;	1 	= VIDEO SCREEN VIEWED NORMALLY (FOR TEST BENCH)
;
;	DPUSECMOS ( DS1 - 2 )
;
;	0 	= DIP SWITCH COINAGE USED
;	1	= CMOS COINAGE USED
;
;	DPRIGHTSLOT ( DS1 - 5 4 3 ) 
;
;	000 	= 1 COIN / 1 CREDIT
;	001	= 2 COIN / 1 CREDIT 
;	010	= 3 COIN / 1 CREDIT
;	011	= 4 COIN / 1 CREDIT
;	100	= 1 COIN / 2 CREDIT
;	101	= 1 COIN / 3 CREDIT
;	110	= 1 COIN / 4 CREDIT
;	111	= FREEPLAY
;
	.if XUNIT=1
;	DPUNUSED ( DS1 - 6 )
	.else
;	DPPOWER (DS1 - 6)
;	0		= RUN POWER UP TESTS
;	1		= DO NOT RUN POWER UP TESTS
	.endif
;
	.if XUNIT=1
;	DPUNUSED ( DS1 - 7 )
	.else
;	DPVALIDATOR (DS1 - 7)
;	0		= NO BILL VALIDATOR
;	1		= BILL VALIDATOR
	.endif
;
;	DPUNUSED ( DS1 - 8 )
;
;	DPCOUNTRY ( DS2 - 2 1 )
;
;	00	= USA
;	01	= GERMAN
;	10	= FRENCH
;	11	= OUTERSPACE
;
;	DPUNUSED ( DS2 - 3 )
;
;	DPCOUNTER ( DS2 - 4 )
;
;	0	= 1 COUNTER 
;	1	= 2 COUNTERS
;
;	DPPLAYERS ( DS2 - 6 5 )
;
;	00	= GAME CONFIGURED FOR 3 PLAYERS
;	01	= GAME CONFIGURED FOR 2 PLAYERS
;	10	= GAME CONFIGURED FOR 1 PLAYER
;	11	= GAME CONFIGURED FOR 1 PLAYER
;
;	DPFREEZE ( DS2 - 7 )
;
;	0	= DON'T FREEZE SCREEN
;	1	= FREEZE SCREEN ( NOTE : MUST HAVE A TRANSITION TO WORK )
;
;	DPTEST ( DS2 - 8 )
;
;	0	= NORMAL NON-TEST
;	1	= TEST MODE
;
**************************************************************************
*								         *
* 	 	AUDIT AND ADJUSTMENT EQUATE FILE			 *
* 									 *
* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		 *
* 		       ALL RIGHTS RESERVED.				 *
*								         *
**************************************************************************

*OFTEN REFERENCED CMOS ROUTINES

*
*        AUDITS
*
*        AUDITS ARE HANDLED BY AUDITS NUMBER OFF OF THE BASE
*        OF THE AUDIT REGION
*
*
*        IF "CHUTES" VALUE IS CHANGED....EXTRA VALUES MUST
*        BE PUT IN THIS TABLE.  (AND ADJUSTMENT TABLE OF COURSE)
*
AUDNULL		EQU	0

AUDLCOIN	EQU	1	;TOTAL COINS IN LEFT CHUTE
AUDCCOIN	EQU	2	;TOTAL COINS IN CENTER CHUTE
AUDRCOIN	EQU	3	;TOTAL COINS IN RIGHT CHUTE
AUD4COIN	EQU	4	;TOTAL COINS IN FOURTH CHUTE
AUDSCOIN	EQU	5	;TOTAL SERVICE CREDITS
AUDPAIDC	EQU	6	;TOTAL PAID CREDITS
*
FRST_C		EQU	AUDLCOIN	;FOR CLEARING COINS
LAST_C		EQU	AUDPAIDC
*
AUDSTART	EQU	7	;PLAYER STARTS

AUD1TIME	EQU	15	;TIME 1 PLAYER ONLY
AUD2TIME	EQU	16	;TIME 2 PLAYER SIMULTANEOUS
AUD3TIME	EQU	17	;TIME 3 PLAYER SIMULTANEOUS

AUDPTIME	EQU	19	;TOTAL PLAY TIME
AUDAVGTL	EQU	20	;AVERAGE TIME/LIFE
AUDAVGTC	EQU	21	;AVERAGE TIME/CREDIT

AUDMAXWAVE	EQU	22	;MAX WAVE REACHED

AUDDEARNED	EQU	25	;DINOS EARNED 
AUDMAXBOZO	EQU	26	;MAXIMUM BOZO LEVEL ACHIEVED
AUDSLAMS	EQU	27	;NUMBER OF TIMES BEEN SLAMMED
AUDUPTIME	EQU	28	;GAME TOTAL UPTIME ( POWER ON TIME )
AUDCONTOFFER	EQU	29	;GAME CONTINUES OFFERED
AUDCONTTAKEN	EQU	30	;GAME CONTINUES TAKEN
AUDONTIME	EQU	31	;GAME POWER ON TIME
AUDAUTO		EQU	32	;AUTO CYCLE PASSES
AUDDOGGY	EQU	33	;WATCHDOG HITS
AUDAVGGC	EQU	34	;AVERAGE GAME COST
AUDNUMTL	EQU	35	;DIVISOR FOR TIME/LIFE
AUDNUMTC	EQU	36	;DIVISOR FOR TIME/CREDIT
AUDNUMTG	EQU	37	;GAMES COMPLETED

AUDWARNING	EQU	39	;SOFTWARE WARNING
AUDBADTRAP	EQU	40	;SOFTWARE TRAPS
AUDSECURITY	EQU	41	;SECURITY BREECH COUNT
AUDWAVECNT	EQU	42	;COUNTER FOR AVG WAVE REACHED
AUDFINISH	EQU	43	;GAMES THAT HAVE BEEN FINISHED
*
LAST_AUDIT	EQU	43	;LAST AUDIT FOR AUDIT CLEAR INFO
*
FRSTGAUD	EQU	AUDSTART
LASTGAUD	EQU	LAST_AUDIT

AUDCAL1UL	EQU	LAST_AUDIT+1	;PLAYER 1 UPPER LEFT CALIBRATION
AUDCAL1LR	EQU	LAST_AUDIT+2	;PLAYER 1 LOWER LEFT CALIBRATION
AUDCAL2UL	EQU	LAST_AUDIT+3	;PLAYER 2 UPPER LEFT CALIBRATION
AUDCAL2LR	EQU	LAST_AUDIT+4	;PLAYER 2 LOWER LEFT CALIBRATION
AUDCAL3UL	EQU	LAST_AUDIT+5	;PLAYER 3 UPPER LEFT CALIBRATION
AUDCAL3LR	EQU	LAST_AUDIT+6	;PLAYER 3 LOWER LEFT CALIBRATION
*
CALIBRATE_START	.EQU	AUDCAL1UL
CALIBRATE_END	.EQU	AUDCAL3LR

*
*	ADJUSTMENTS ARE ALL LONG WORDS REFERENCED BY ADJUSTMENT
*	NUMBER.
*
ADJNULL         EQU	0
ADJPRICE        EQU	1		;MASTER PRICING
ADJLMULT        EQU	2		;LEFT SLOT MULTIPLIER
ADJC1           EQU	ADJLMULT	;FIRST COIN TABLE ADJUSTMENT
ADJCMULT        EQU	3		;CENTER SLOT MULTIPLIER
ADJRMULT        EQU	4		;RIGHT SLOT MULTIPLIER
ADJ4MULT	EQU	5		;FOURTH SLOT MULTIPLIER
ADJCUNIT        EQU	6
ADJBUNIT        EQU	7
ADJMUNIT        EQU	8
ADJCDIV         EQU	9
ADJFRAC         EQU	10		;NON ZERO SAYS SHOW HALF CREDITS
ADJCSTRT        EQU	11		;CREDITS REQUIRED TO START
ADJCCONT        EQU	12		;CREDITS REQUIRED TO CONTINUE
ADJCX           EQU	ADJCCONT	;LAST COIN TABLE ADJUSTMENT
ADJDIFF         EQU	13
ADJHSRES        EQU	14
ADJENERGY	EQU	15	;ENERGY PER PLAY
ADJEXTRA        EQU	16	;EXTRA MAN EVERY
ADJNUMEXTRA     EQU	17	;MAXIMUM NUMBER EXTRA MEN/COIN
ADJMUSIC        EQU	18	;ATTRACT MODE SOUND
ADJMAXC         EQU	19	;MAXIMUM CREDITS
ADJFREPL        EQU	20	;NON-ZERO MEANS FREE PLAY
ADJVIRGIN       EQU	21	;NON-ZERO MEANS 1ST 8 OF COIN ADJUST BLOCK UNTOUCHED
ADJBOMBS	EQU	22	;NUMBER OF BOMBS PER GAME
ADJ1ST6         EQU	23	;NON-ZERO MEANS 1ST 6 UNTOUCHED.
ADJNOCPAG       EQU	24
ADJBUYIN        EQU	25
ADJHSON		EQU	26	;IF = 0, DON'T ALLOW HIGH SCORE ENTRY
ADJMINTIME	EQU	27	;MINIMUM TIME GUARANTEED PER CREDIT
ADJVOLUME	EQU	28	;Current sound board volume
ADJMINVOL	EQU	29	;Minimum volume allowed
LAST_ADJUST     EQU	29



team_mighty_ducks	.set	0
team_bruins		.set	1
team_sabres		.set	2
team_flames		.set	3
team_blackhawks		.set	4
team_stars		.set	5
team_red_wings		.set	6
team_oilers		.set	7
team_panthers		.set	8
team_whalers		.set	9
team_kings		.set	10
team_canadiens		.set	11
team_devils		.set	12
team_islanders		.set	13
team_rangers		.set	14
team_senators		.set	15
team_flyers		.set	16
team_penguins		.set	17
team_nordiques		.set	18
team_sharks		.set	19
team_blues		.set	20
team_lightning		.set	21
team_maple_leafs	.set	22
team_canucks		.set	23
team_capitals		.set	24
team_jets		.set	25

skater_harper		.set	0
skater_mcdaniel		.set	1
skater_ewing		.set	2
skater_stockton		.set	3
skater_shiek		.set	4
skater_malone		.set	5
s_board_crash_10	.equ	0
s_board_crash_4		.equ	1
s_board_crash_5		.equ	2
s_board_crash_8		.equ	3
s_board_crash_9		.equ	4
s_board_crash_j1	.equ	5
s_skates_upended	.equ	6
s_goalie_mitt_1		.equ	7
s_goalie_mitt_2		.equ	8
s_goalie_mitt_5		.equ	9
s_goalie_mitt_7		.equ	10
s_goalie_pad_1		.equ	11
s_goalie_pad_2		.equ	12
s_goalie_skate_1	.equ	13
s_goalie_skate_2	.equ	14
s_goalie_skate_3	.equ	15
s_goalie_skate_4	.equ	16
s_goalie_skate_5	.equ	17
s_goalie_skate_6	.equ	18
s_goalie_stick_1	.equ	19
s_goalie_stick_2	.equ	20
s_goalie_stick_3	.equ	21
s_goalie_stick_4	.equ	22
s_hard_skate_stop_1	.equ	23
s_hard_skate_stop_2	.equ	24
s_hard_skate_stop_3	.equ	25
s_hard_skate_stop_4	.equ	26
s_hard_skate_stop_5	.equ	27
s_ice_crunch_1		.equ	28
s_ice_crunch_2		.equ	29
s_loud_board_1		.equ	30
s_loud_board_2		.equ	31
s_loud_board_3		.equ	32
s_long_skate_1		.equ	33
s_long_skate_2		.equ	34
s_long_skate_3		.equ	35
s_long_skate_4		.equ	36
s_long_skate_5		.equ	37
s_long_skate_6		.equ	38
s_long_skate_7		.equ	39
s_puck_to_board_score_1	.equ	40
s_puck_drop_1		.equ	41
s_puck_drop_2		.equ	42
s_puck_drop_3		.equ	43
s_puck_to_goalie_mask_1	.equ	44
s_puck_hit_board_1	.equ	45
s_puck_hit_board_2	.equ	46
s_puck_hit_board_3	.equ	47
s_puck_drop_in_net	.equ	48
s_puck_in_net_1		.equ	49
s_puck_in_net_2		.equ	50
s_puck_in_net_3		.equ	51
s_puck_in_net_4		.equ	52
s_puck_in_net_5		.equ	53
s_puck_in_net_6		.equ	54
s_plastic_impact_1	.equ	55
s_plastic_impact_2	.equ	56
s_plastic_board_hit_1	.equ	57
s_plastic_board_hit_2	.equ	58
s_puck_to_metal_0	.equ	59
s_puck_to_metal_1	.equ	60
s_puck_to_metal_2	.equ	61
s_puck_pass_1		.equ	62
s_puck_pass_2		.equ	63
s_puck_pass_3		.equ	64
s_puck_pass_4		.equ	65
s_puck_pass_5		.equ	66
s_puck_ricochet_1	.equ	67
s_puck_ricochet_2	.equ	68
s_puck_ricochet_3	.equ	69
s_puck_slide_2		.equ	70
s_puck_slide_3		.equ	71
s_puck_slide_4		.equ	72
s_puck_slide_6		.equ	73
s_skate_1		.equ	74
s_skate_2		.equ	75
s_skate_3		.equ	76
s_skate_4		.equ	77
s_skate_5		.equ	78
s_skate_6		.equ	79
s_skate_7		.equ	80
s_skate_8		.equ	81
s_skate_9		.equ	82
s_skate_10		.equ	83
s_skate_11		.equ	84
s_skate_12		.equ	85
s_skate_13		.equ	86
s_skate_14		.equ	87
s_skate_15		.equ	88
s_skate_16		.equ	89
s_skate_17		.equ	90
s_skate_18		.equ	91
s_skate_19		.equ	92
s_skate_20		.equ	93
s_skate_21		.equ	94
s_skate_22		.equ	95
s_skate_23		.equ	96
s_skate_24		.equ	97
s_skate_25		.equ	98
s_skate_26		.equ	99
s_skate_27		.equ	100
s_skate_28		.equ	101
s_skate_29		.equ	102
s_skate_30		.equ	103
s_skate_31		.equ	104
s_skate_32		.equ	105
s_skate_33		.equ	106
s_skate_34		.equ	107
s_skate_35		.equ	108
s_skate_36		.equ	109
s_skate_37		.equ	110
s_skate_up_foreground	.equ	111
s_run_on_skates_1	.equ	112
s_run_on_skates_2	.equ	113
s_slapshot_1		.equ	114
s_slapshot_2		.equ	115
s_slapshot_3		.equ	116
s_slapshot_4		.equ	117
s_slapshot_6		.equ	118
s_slapshot_7		.equ	119
s_stick_sound_1		.equ	120
s_stick_to_pad_1	.equ	121
s_stick_bounce_1	.equ	122
s_stick_slide_1		.equ	123
s_skate_stop_or_turn_1	.equ	124
s_skate_stop_or_turn_2	.equ	125
s_skate_stop_or_turn_3	.equ	126
s_skate_stop_or_turn_4	.equ	127
s_skate_stop_or_turn_5	.equ	128
s_skate_stop_or_turn_6	.equ	129
s_long_puck_slide_5	.equ	130
s_long_puck_slide_6	.equ	131
s_long_puck_slide_7	.equ	132
