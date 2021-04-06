;**************************************************************************
;*									  *
;* 		SYSTEM "ASSEMBLY TIME" CONDITIONALS			  *
;*									  *
;**************************************************************************

BILL		EQU	0	;BILL'S ASSEMBLY SWITCH			
NOBODY		EQU	1	;NO ASSEMBLY SWITCH

	.if BILL+NOBODY != 1

	DIS AIN'T RIGHT!!!

	.endif

DEBUG		EQU	0	;THIS VERSION IS CURRENTLY UNDER CONSTRUCTION
;DEBUG		EQU	0	;ADD THIS BEFORE RELEASE!!!!!

WRITE_TO_ROM_INT	.EQU	1	;ENABLE
;WRITE_TO_ROM_INT	.EQU	0	;DISABLE

bog_line	equ	0	;if 1, draw bog lines

NO_HELP_WINDOWS	EQU	0	;DISABLE HELP WINDOWS ONLY FOR TESTING

SHOT_DATA	EQU	0	;DISABLE HELP WINDOWS ONLY FOR TESTING

NOTFINAL	EQU	1	;IF = 1, NOT PRODUCTION QUALITY PROGRAM
;NOTFINAL	EQU	0	;ADD THIS BEFORE RELEASE!!!!!

FORCEFREE	EQU	0	;1 = GAME HARDWIRED FREE
FULLPRICE	EQU	1	;1 = ALL THE PRICINGS ARE INCLUDED

NO_PUCK_HOG	EQU	0	;disable slow down of player who is hogging puck

XUNIT		equ	0

self_play	equ	0
freeze_ok	equ	1	;game can be frozen with game_frozen
new_speech	equ	1

	.if DEBUG = 0

;	.if bog_line+NO_HELP_WINDOWS+NO_PUCK_HOG+self_play != 0
	.if bog_line+self_play != 0

	SOMETHING'S WRONG!!!

	.endif

	.endif
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
OM_DADDR		.set	4000h

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
OSPPOS			EQU	490h	;UHL address of x offset (if M_SPPOS)
ODATA			EQU	4b0h
ODATAX  		EQU	ODATA+0340H	;mdp 280
*ENDSTRUCT
OBSIZ			EQU	ODATAX 	;Object Block Size
OCLRSIZ 		EQU	ODATA		;GETOBJ WILL CLEAR UPTO AND NOT INCLUDING HERE

NOBJ	EQU	400

***** MISCELLANEOUS OFFSETS
;**** OFFSETS for ANIM
*STRUCT	ANIM+OBJ
ANIMNXT			EQU	OVAR1		;UHL  link to next obj of Animy linked list
ANIMFRM			EQU	OVAR2		;UHL  ptr to current animation frame
ANIMSCR			EQU	OVAR3		;UHL  ptr to animation script
ANIMSLP			EQU	OVAR4		;UDB  reset value for AnimSlp
ANISLP			EQU	OVAR4+8		;UDB  # tiks before next ANI
ANIMLOOP		EQU	OVAR4+16	;UDB	General purpose Loop counter
ANIMOPEN		EQU	OVAR4+24	;UDB  reserved for future definition (keep cleared)
*ENDSTRUCT
ANIMRETSCR		EQU	OVAR5		;UHL ANIMATION RETURN SCRIPT
ANIMRETFRM		EQU	OVAR6		;UHL ANIMATION RETURN FRAME
OPARTID			EQU	OVAR7		;UHB # of part in multi-parter, stuffed by MULTIMAKE
OZOFF			EQU	OVAR7+8		;UHB Z OFFSET
ANIMARG			EQU	OVAR8		;stuffed by AnimP for use by GETAFARG_xxxx
OPLAYER			EQU	OVAR9

;*** ANIFLY SCRIPT FLAGS ***
AFLIP			EQU	08000H	;flip bits in aniscript flag
Axxxxxx			EQU	04000H	;unused
;AMULTI			EQU	02000H	;animate down multi-parter list?
AFUNC			EQU	01000H	;call function in aniscript flag

;*** BITS SET IN FLAGS:SLEEP WORD OF AN ANIM SCRIPT ***
B_AFLIP			EQU	15 	;WARNING don't move, tested w/ jrnn in AnimP (hhc)
B_xxxxxx 		EQU	14
;B_AMULTI 		EQU	13
B_AFUNC			EQU	12

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
M_SPPOS			EQU  00002H	;special position (uses OSPPOS)
M_FVELADD		EQU  00004H	;freeze veladd for 1 frame when set
;M_MANSCALE		EQU  00020H	;MANUAL SCALING (You set scale, sizes computed when M_NOSCALE clr)
M_NOPARTANI		EQU  00040H	;IF IN MULTI-SCRIPT, THEN DON'T ANIMATE
M_OFSCRN 		EQU  00080H	;if 1, VELADD has marked as OFF SCREEN
M_NOVEL			EQU  00100H	;if 1, do not ever VELADD
M_OPARTSXY 		EQU  00200H
;mdpM_NOCOLL		EQU  02000H	;Don't do regular collisions...
M_ANIM			EQU  04000H	;set if on ANIFLY list
M_SCRNOBJ		EQU  08000H	;SCREEN OBJECT

*BIT POSITIONS FOR OFLAGS
B_NOSCALE		EQU  	0	
B_SPPOS			EQU	1
B_FVELADD		EQU	2	;freeze veladd 1 frame
;B_MANSCALE		EQU	5	;MANUAL SCALING (You set scale, sizes computed automatically)
B_NOPARTANI		EQU	6	 
B_OFSCRN		EQU	7
B_NOVEL			EQU	8  	;if 1, do not ever VELADD
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

*
*MACHINE TIMINGS
*

	.if	XUNIT

MACHINE_CYCLE	.EQU	100	;NUMBER OF nanoSECONDS PER MACHINE CYCLE on the 34020:
				;	40MHz = 100 ns
	.else
MACHINE_CYCLE	.EQU	160	;NUMBER OF nanoSECONDS PER MACHINE CYCLE on the 34010:
				;	40MHz = 200 ns
				;	50MHz = 160 ns
	.endif

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

IROM		.SET	02000000h	;IMAGE ROM 
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
CMOS		.EQU	1400000h		;START OF CMOS RAM
SCREEN		.SET	00h			;START OF SCREEN MEMORY
SCRNE		.SET	0200000h		;END OF SCREEN+1
PSCREEN		.SET	000000h		;START OF PALETTE SCREEN MEMORY

;SCRATCH_END	.EQU	1400000H		;END OF SCRATCH+1
;STCKST		.SET	13ffff0h		;TOP OF STACK

SCRATCH_END	.EQU	13F7400H		;END OF SCRATCH+2
STCKST		.SET	13F73E0H		;TOP OF STACK

COLRAM		.SET	1880000H		;COLOR RAM B0-B4 BLU, B5-B9 GRN, B10-B14 RED
PALSIZE		.SET	01000H		;PHYSICAL SIZE OF A PALETTE IN COLOR RAM
*
*USEFUL SYSTEM ADDRESSES
*
ROM		.SET	0ff800000h		;PROGRAM ROM

SOUND		.SET	1680000h		;SOUND I/O (B0-B7 = SOUND#)

SWITCH		.SET	1860000H		;PLAYER 1 & 2 INPUTS
SWITCH2		.SET	1860010H		;PLAYER 3 & 4 INPUTS
DIPSWITCH	.SET	1860020H		;DIP-SWITCH INPUTS
COINS		.SET	1860030H		;COINS, STARTS, VOLUME CONTROL,
						; SERVICE, TEST, SLAM
MISCIN		.SET	1860040H		;MISCELLANOUS INPUTS

AUX_PORT	.EQU	1860000H		;AUXILLARY PORT
COIN_COUNTERS	.EQU	1860010H		;COIN COUNTER DRIVERS
MISCOUT		.EQU	1860020H		;MISCELLANOUS OUTPUTS
WDOG_BONE	.EQU	1860030H		;ACCESS HERE TO FEED THE DOG

IROM		.SET	2000000h		;IMAGE ROM (assuming 4Mbit parts, 16MB total)
;IROM		.SET	2000000h		;IMAGE ROM (assuming 8Mbit parts, 32MB total)
CMAPSEL		.SET	1a00080h		;COLOR MAP SELECT (0-15)

SYSCTRL		.SET	1b00000H		;SYSTEM CONTROL LATCH

IROM_WR_ENABLE	.set	0080h		; Enable writes to IROM
IROM_BANK_SEL0	.set	0100h		; IROM Bank select bit 0
IROM_BANK_SEL1	.set	0200h		; IROM Bank select bit 1
LED_ON		.set	0400h		; LED on
PALEN		.set	0800h		; Color Palette Enable
ROMWRINTDIS	.set	1000h		; Disable Write to ROM interrupt
CLR_WRROMINT	.set	2000h		; Clear Write to ROM interrupt
EXTINTENB	.set	4000h		; EXTERNAL INTERRUPT ENABLE

;SYSCINIT	.equ  (IROM_WR_ENABLE|PALEN|ROMWRINTDIS|CLR_WRROMINT)

	.if	WRITE_TO_ROM_INT
SYSCINIT	.equ  (IROM_WR_ENABLE|PALEN|CLR_WRROMINT)
	.else
SYSCINIT	.equ  (IROM_WR_ENABLE|PALEN|ROMWRINTDIS)
	.endif

;WRONG! SYSC_COLD	.EQU	0		;System control register upon cold start

VMUX_CONTROL	.equ	1800000h	; VMUX Control Register
VMUX_BREG0		.equ	1820000h	; VMUX Background Register 0
VMUX_BREG1		.equ	1830000h	; VMUX Background Register 1
VMUX_PMATCH		.equ	1840000h	; VMUX Palette Match Register
VMUX_STATUS		.equ	1800000h	; VMUX Status Register

VMUX_INIT		.equ	0			; Initial VMUX mode

CMOSENAB			.equ	1480000h	;enable CMOS

SOUNDIRQ			.equ	1860040h	; Sound IRQ Address
SNDRSTBIT		.equ	16			; Bit used to reset sound section
;soundbit			.equ	0100h		; Sound system strobe bit

IORSTBIT		.equ	32			; Bit used to reset I/O SUB-SECTION

	.endif

**************************************************************************
*								         *
* MISCELLANOUS OUTPUTS							 *
*								         *
**************************************************************************

;M_LEFT_LAMP	EQU	001B		;LEFT LAMP MASK
;	.if	ONE_LAMP
;M_RGHT_LAMP	EQU	001B		;LEFT LAMP MASK
;	.else
;M_RGHT_LAMP	EQU	010B		;RIGHT LAMP MASK
;	.endif



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
ICMAP		.equ	70H	;palette
ICPUCK		.equ	070h	;same as above (images with points have no palette)
ICPUCKX		.equ	070h
ICPUCKY		.equ	080h
ICHEADX		.equ	090h
ICHEADY		.equ	0a0h
ICHEADZ		.equ	0b0h
ICHEADN		.equ	0c0h
ICSPRAYX	.equ	0d0h	;for images with ice spray point
ICSPRAYY	.equ	0e0h	;for images with ice spray point
ICSPRAYZ	.equ	0f0h	;for images with ice spray point

* 	.word	puckx,pucky						 *
* 	.word	headx,heady,headz					 *
* 	.word	head#							 *


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

CHUTES		EQU	5		;MAXIMUM COIN CHUTES IN GAME.

L_COIN_BIT	EQU	0001H
C_COIN_BIT	EQU	0080H
R_COIN_BIT	EQU	0002H
X_COIN_BIT	EQU	0100H
DBV_BIT		equ	8000h
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

N_AUDITS	EQU	100		;ALLOCATE AMPLE AUDIT SPACE


**************************************************************************
*                                                                        *
*          ADJUSTMENTS                                                   *
*                                                                        *
**************************************************************************
ADJ_SIZE	EQU	C_LONG_SIZE
N_ADJUSTS	EQU	37		;31 NORMAL ADJUSTMENTS


**************************************************************************
*                                                                        *
*                                                                        *
*          CMOS STUFF FOR HSTD..........MOVE THIS TO SPECIAL EQUATE FILE *
*          SOME DAY                                                      *
*                                                                        *
*                                                                        *
**************************************************************************

**************************************************************************
*								         *
* CMOS memory map							 *
*   2K - audits/credit data/hsr count					 *
*   1K - adjustments							 *
*   2K - dumps								 *
*   1K - miscellaneous (game counter + free)				 *
*  15K - player records							 *
*   3K - player rival records						 *
*   2K - team records							 *
*   2K - team vs team rival records					 *
*   4K - free								 *
*								         *
**************************************************************************

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
DUMP_PTR	EQU	DUMP_ORG		;WORD....NUMBER OF ENTRIES!
DUMP_DATA	EQU	DUMP_PTR+C_WORD_SIZE	;DUMPS GO HERE!
DUMP_CMOSMEM	EQU	2*CMOS_1K		;TOTAL CMOS FOR DUMPS
DUMP_END	EQU	DUMP_ORG+DUMP_CMOSMEM

CM_ORG		EQU	DUMP_ORG+DUMP_CMOSMEM
CM_MISC		EQU	CM_ORG
CM_MISCCMOSMEM	EQU	CMOS_1K
CM_MISCEND	EQU	CM_ORG+CM_MISCCMOSMEM

CM_PLAYERSTART	EQU	CM_MISCEND
CM_PLYRCMOSMEM	EQU	15*CMOS_1K
CM_PLYREND	EQU	CM_PLAYERSTART+CM_PLYRCMOSMEM

CM_STANLEY	EQU	CM_PLYREND
CM_STANLCMOSMEM	EQU	1*CMOS_1K		;way too much room
CM_STANLYEND	EQU	CM_STANLEY+CM_STANLCMOSMEM

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

ZWRAP		.EQU	[2350,0]

radius	.set	120


**************************************************************************
*								         *
* TEAM_DATA TABLE EQUATES						 *
*								         *
**************************************************************************

;	.long	logo1,logo2_init
;	.long	 member_1_list,member_2_list
;	.long	 away_uniform_pal,away_uniform_goalie_pal
;	.long	 home_uniform_pal,home_uniform_goalie_pal
;	.long	 home_p1_turbo_pal,home_p2_turbo_pal
;	.long	 home_p3_turbo_pal,home_p4_turbo_pal
;	.long	 away_p1_turbo_pal,away_p2_turbo_pal
;	.long	 away_p3_turbo_pal,away_p4_turbo_pal
;	.long	 long_name_init
;	.long	 goalie_list
;	.LONG	 TEAM NAME IMAGE, TEAM LOGO IMAGE
;	.word	 home_helmet_palette_offset,away_helmet_palette_offset
;	.word	  goalie_helmet_palette_offset
;	.LONG	 CITY NAME IMAGE, CITY NAME STRING
;	.LONG	 TEAM NICKNAME
;	.word	 video clip primary pal, video clip secondary pal
;	.long	 away_bench_palette,home_bench_palette

TD_ALTTEAMLOGO	equ	0020h			;UHL
TD_MEMBER1_LIST	EQU	0040H			;UHL
TD_MEMBER2_LIST	EQU	0060H			;UHL

TD_GOALIE_APAL	EQU	00A0H			;UHL
TD_GOALIE_HPAL	EQU	00E0H			;UHL

TD_GOALIE_LIST	EQU	0220H			;UHL	
TD_TEAMNAME_IMG	EQU	0240H			;UHL	
TD_TEAMLOGO_IMG	EQU	0260H			;UHL
TD_HOME_HELMET	equ	0280h			;UHW
TD_AWAY_HELMET	equ	0290h			;UHW
TD_GOALIE_HELMET equ	02A0h			;UHW
;TD_NOT_USED	EQU	02B0H			;UHW
TD_CITY_IMG	EQU	02C0H			;UHL
TD_CITY_STR	EQU	02E0H			;UHL
TD_BIG_GHELM_PAL EQU	0300H			;UHL
TD_NICKNAME_STR	EQU	0320H			;UHL
TD_VCLIP_1	equ	0340H			;UHW
TD_VCLIP_2	equ	0350H			;UHW
TD_BENCHP_AWAY	equ	0360H			;UHL
TD_BENCHP_HOME	equ	0380H			;UHL
TD_ALT_NAME	equ	03a0H			;UHL

**************************************************************************
*								         *
* TEAM PLAYER ENTRY EQUATES						 *
*								         *
**************************************************************************

;	.byte	" "," "," ",month,day,0,0,0
;	.long	head_table,unused
;	.long	shot_table,scale_table
;	.word	mass,0
;	.byte	speed,stopping,cornering,shooting
;	.byte	,passing,dumping,puck handling,checking
;	.long	NAME IMAGE, MUG SHOT IMAGE + HFLIP FLAG
;	.word	helmet_type

TP_HEAD_TABLE	EQU	0040H			;UHL
TP_HELMET_OFF	EQU	0060h		;uhl - set if no helmet is used (no palette)
TP_SECRET_CHAR	EQU	TP_HELMET_OFF
TP_SPEED	equ	00e0h
TP_STOP		equ	00e8h
TP_CORNER	equ	00f0h
TP_SHOOT	equ	00f8h
TP_PASS		equ	0100h
TP_FACEOFF	equ	0108h
TP_HANDLE	equ	0110h
TP_CHECK	equ	0118h
TP_PLYRNAME_IMG	EQU	0120H			;UHL
TP_PLYRMUG_IMG	EQU	0140H			;UHL
TP_HELMET_TYPE	equ	0160h			;UHW

**************************************************************************
*								         *
* SWITCH EQUATES							 *
*								         *
**************************************************************************

M_SW_U	EQU	1		;JOYSTICK UP
M_SW_D	EQU	2		;JOYSTICK DOWN
M_SW_L	EQU	4		;JOYSTICK LEFT
M_SW_R	EQU	8		;JOYSTICK RIGHT
M_SW_S	EQU	16		;SHOOT
M_SW_P	EQU	32		;PASS
M_SW_T	EQU	64		;TURBO
M_SW_ALL	EQU	07FH	;ALL PLAYER SWITCHES

B_SW_U	EQU	0		;JOYSTICK UP
B_SW_D	EQU	1		;JOYSTICK DOWN
B_SW_L	EQU	2		;JOYSTICK LEFT
B_SW_R	EQU	3		;JOYSTICK RIGHT
B_SW_S	EQU	4		;SHOOT
B_SW_P	EQU	5		;PASS
B_SW_T	EQU	6		;TURBO

**************************************************************************
*								         *
* GENERAL SCREEN EQUATES						 *
*								         *
**************************************************************************

P1_X_CENTER	EQU	60
P2_X_CENTER	EQU	160
P3_X_CENTER	EQU	260
P4_X_CENTER	EQU	350

P1_2P_X_CENTER	EQU	60
P2_2P_X_CENTER	EQU	350

**************************************************************************
*								         *
* GENERAL RINK EQUATES							 *
*								         *
**************************************************************************

;LEFT IS LEFT
;RIGHT IS RIGHT
;TOP IS FAR
;BOTTOM IS CLOSE

TOP_SIDEBOARD_Z	EQU	[679,0]		;02A70000H
BOT_SIDEBOARD_Z	EQU	0

LEFT_ENDBOARD_X	EQU	[-798,0]	;-031E0000H
RGHT_ENDBOARD_X	EQU     [798,0]		; 031E0000H

CENTER_X	EQU	0
CENTER_Z	EQU	[339,32768]	;01538000H

LEFT_BLUELINE_X	EQU	[-233,0]	;-0E90000H
RGHT_BLUELINE_X	EQU	[233,0]		; 0E90000H

LEFT_GOALLINE_X	EQU	[-688,0]	;-02B00000H
RGHT_GOALLINE_X	EQU     [688,0]		; 02B00000H

GOAL_DEPTH_X	EQU	[42,0]		;02A0000H

TOP_GOALPOST_Z	EQU	[393,0]		;01890000H
BOT_GOALPOST_Z	EQU	[286,0]		;011E0000H

GOAL_RADIUS	EQU	(TOP_GOALPOST_Z-BOT_GOALPOST_Z)/2 ;0358000H
CREASE_RADIUS	EQU	GOAL_RADIUS+01FF000H		  ;0557000H

TOP_CREASE_Z	EQU	CENTER_Z+CREASE_RADIUS
BOT_CREASE_Z	EQU	CENTER_Z-CREASE_RADIUS

**************************************************************************
*								         *
* GENERAL GOAL EQUATES							 *
*								         *
**************************************************************************

OFRONT_OBJ	EQU	ODATA		;UHL FRONT GOAL OBJECT
;OFRONT_OFFSET	EQU	ODATA+020H	;UHL [Y,X] OFFSET FROM UPPER LEFT
;					;    OF FRONT TO UPPER LEFT OF REAR 	


**************************************************************************
*								         *
* GENERAL PUCK EQUATES							 *
*								         *
**************************************************************************

ROUGH_PUCK_MAX	.set	[35,0]		;THIS IS REALLY ROUGH! [32,0] ACTUAL
					; MAX SHOT SPEED + MAX PLAYER SPEED

NORM_GRAVITY	.EQU	[0,3000h]	;if we change this,
					; change y position routines to match

SHOT_GRAVITY	.EQU	[0,2a00h]	;if we change this,
					; change y position routines to match

MAX_SAVE_PUCK_SPEED	EQU	[8,08000h]	;[9,0] ;[15,0]	;MAX PUCK SPEED OFF A SAVE

**************************************************************************
*								         *
* GENERAL PLAYER EQUATES						 *
*								         *
**************************************************************************

STAND_COLLRANGE		EQU	30
GSTAND_COLLRANGE	EQU	40


**************************************************************************
*								         *
* GENERAL GOALIE EQUATES						 *
*								         *
**************************************************************************

;GOALIE POSITION AT GOAL LINE

POSITION_RADIUS	EQU	GOAL_RADIUS+01E8000H

GOALIE_XOFF	EQU	01D0000H ;0D0000H

LEFT_GOALIE_AT_GOAL	EQU	LEFT_GOALLINE_X+GOALIE_XOFF
RGHT_GOALIE_AT_GOAL	EQU	RGHT_GOALLINE_X-GOALIE_XOFF

GSLOW_PUCK	EQU	[16,0]	;[2,0]

FREEZE_TIME	EQU	60	;MAXIMUM TIME PUCK CAN BE HELD UNTIL FROZEN

MAX_SAVE_TTIME	EQU	120

MAX_GAIN_POSSY	EQU	-040000H	;MAXIMUM GAIN POSSESSION Y HEIGHT

MAX_FREEZES	EQU	3		;ALLOWED FREEZES PER PERIOD

FREEZE_PROB	EQU	102 ;10%	;FREEZE PROBABILITY AFTER ALLOWED

;GFLAGS BITS

B_FREEZE	EQU	0	;DON'T MOVE
B_TMOVE		EQU	1	;MOVE TO POSITION WITH TURBO
B_SAVEMADE	EQU	2	;SAVE SUCCESSFUL
B_MISSSAVE	EQU	3	;MISS ON THIS SAVE
B_FETCHING	EQU	4	;FETCHING THE PUCK
B_GLOVESIDE	EQU	5	;PUCK SAVED ON GLOVE SIDE
B_PUCKCHECK	EQU	6	;PUCK CHECKS GOALIE
B_GOHOME	EQU	7	;GOING HOME WITH THE PUCK
B_RSMOTH	EQU	8	;REVERSE SMOTHER

M_FREEZE	EQU	1
M_TMOVE		EQU	2
M_SAVEMADE	EQU	4
M_MISSSAVE	EQU	8
M_FETCHING	EQU	16
M_GLOVESIDE	EQU	32
M_PUCKCHECK	EQU	64
M_GOHOME	EQU	128
M_RSMOTH	EQU	256

;PUCK_GOALIE_CHECK PROCESS DATA EQUATES

PGTIMPACT	EQU	PDATA		;UHL TIME TIL IMPACT POSITION FOR 3(7)
PGXIMPACT	EQU	PDATA+020H	;UHL TIME TIL IMPACT POSITION FOR 3(7)
PGZIMPACT	EQU	PDATA+040H	;UHL Z IMPACT POSITION FOR ANGLE 3(7)
PGDIMPACT	EQU	PDATA+060H	;UHL DISTANCE TO IMPACT POSITION FOR 3(7)

;GOALIE_SPEECH INDEXES

GS_REBOUND	EQU	0 ;		;PUCK REBOUNDS OFF GOALIE (NOT FROM A SAVE!)
GS_SMOTHERED	EQU	1 ;ACTIVE	;SUCCESSFUL SMOTHER
GS_POKECHECK	EQU	2 ;ACTIVE	;SUCCESSFUL POKE CHECK
GS_CROSSCHECK	EQU	3 ;		;SUCCESSFUL CROSS CHECK
GS_FRUSTRATED	EQU	4 ;	 	;GOALIE IS FRUSTRATED
GS_PASSED	EQU	5 ;ACTIVE	;PASS REQUESTED BY PLAYER
GS_FROZEN	EQU	6 ;ACTIVE	;GOALIE FROZE PUCK

;ALL ACTIVE
GS_SAVE		EQU	7		;ALL PURPOSE SAVE CALL
GS_BUTTERFLY	EQU	8
GS_PADSTACK	EQU	9
GS_STICK	EQU	10
GS_GLOVE	EQU	11
GS_BLOCKER	EQU	12
GS_STOMACH	EQU	13		;INTO THE GUT
GS_SKATE	EQU	14

GS_GAINS_POSS	EQU	15		;GOALIE GAINS POSSESSION

**************************************************************************

XD0000	.set	[000,00000h]
XD0005	.set	[000,08000h]
XD0009	.set	[000,0e666h]
XD0010	.set	[001,00000h]
XD0011	.set	[001,0199ah]
XD0012	.set	[001,03333h]
XD0014	.set	[001,06666h]
XD0015	.set	[001,08000h]
XD0017	.set	[001,0b333h]
XD0018	.set	[001,0cccdh]
XD0019	.set	[001,0e666h]
XD0020	.set	[002,00000h]
XD0021	.set	[002,0199ah]
XD0022	.set	[002,03333h]
XD0023	.set	[002,04ccdh]
XD0024	.set	[002,06666h]
XD0025	.set	[002,08000h]
XD0027	.set	[002,0b333h]
XD0029	.set	[002,0e666h]
XD0030	.set	[003,00000h]
XD0031	.set	[003,0199ah]
XD0033	.set	[003,04ccdh]
XD0035	.set	[003,08000h]
XD0036	.set	[003,0999ah]
XD0038	.set	[003,0cccdh]
XD0039	.set	[003,0e666h]
XD0040	.set	[004,00000h]
XD0041	.set	[004,0199ah]
XD0042	.set	[004,03333h]
XD0043	.set	[004,04ccdh]
XD0044	.set	[004,06666h]
XD0045	.set	[004,08000h]
XD0047	.set	[004,0b333h]
XD0048	.set	[004,0cccdh]
XD0050	.set	[005,00000h]
XD0052	.set	[005,03333h]
XD0053	.set	[005,04ccdh]
XD0054	.set	[005,06666h]
XD0055	.set	[005,08000h]
XD0056	.set	[005,0999ah]
XD0057	.set	[005,0b333h]
XD0058	.set	[005,0cccdh]
XD0060	.set	[006,00000h]
XD0063	.set	[006,04ccdh]
XD0066	.set	[006,0999ah]
XD0069	.set	[006,0e666h]
XD0070	.set	[007,00000h]
XD0073	.set	[007,04ccdh]
XD0075	.set	[007,08000h]
XD0077	.set	[007,0b333h]
XD0080	.set	[008,00000h]
XD0090	.set	[009,00000h]
XD0100	.set	[010,00000h]
XD0110	.set	[011,00000h]
XD0120	.set	[012,00000h]
XD0130	.set	[013,00000h]
XD0140	.set	[014,00000h]
XD0150	.set	[015,00000h]
XD0200	.set	[020,00000h]
XD0225	.set	[022,08000h]
XD0250	.set	[025,00000h]
XD0300	.set	[030,00000h]
XD0350	.set	[035,00000h]
XD0400	.set	[040,00000h]	;40 degrees is our crossover point
XD0450	.set	[045,00000h]
XD0500	.set	[050,00000h]
XD0540	.set	[054,00000h]
XD0570	.set	[057,00000h]	;57 degrees is our crossover point
XD0600	.set	[060,00000h]
XD0675	.set	[067,08000h]
XD0700	.set	[070,00000h]
XD0750	.set	[075,00000h]
XD0800	.set	[080,00000h]	;80 degrees is our crossover point
XD0900	.set	[090,00000h]
XD1000	.set	[100,00000h]
XD1100	.set	[110,00000h]
XD1125	.set	[112,08000h]
XD1350	.set	[135,00000h]
XD1575	.set	[157,08000h]
XD1600	.set	[160,00000h]
XD1800	.set	[180,00000h]
XD2025	.set	[202,08000h]
XD2250	.set	[225,00000h]
XD2475	.set	[247,08000h]
XD2500	.set	[250,00000h]
XD2600	.set	[260,00000h]
XD2700	.set	[270,00000h]
XD2925	.set	[292,08000h]
XD3150	.set	[315,00000h]
XD3375	.set	[337,08000h]
XD3500	.set	[350,00000h]
XD3600	.set	[360,00000h]
XD3825	.set	[382,08000h]
XD4050	.set	[405,00000h]
XD7200	.set	[720,00000h]

*ODATA EQUATES

;EVERYTHING
ODT_DIR		.equ	ODATA		;UHL direction object is moving (s15:16 radians)
ODT_VEL		.equ	ODATA+020H	;UHL velocity magnitude of object (s15:16)
ODT_REALXVEL	.equ	ODATA+040H	;SHL x velocity before onscreen quick takes over
ODT_EVEND	.EQU	ODATA+060H	;END OF EVERYTHING

;PLAYER	GLOBAL
ODT_DVEL	.equ	ODT_EVEND	;UHL angular velocity of object (s15:16 radians/tick)
ODT_PBK		.equ	ODT_EVEND+020H	;UHL player block address
ODT_TIGHT	.equ	ODT_EVEND+040H	;UHW tight UDLR
ODT_SAVEVEL	.equ	ODT_EVEND+050H	;UHL save old velocity during 'rubber band' push
ODT_SAVEDIR	.equ	ODT_EVEND+070H	;UHL direction saved for script use
ODT_GDIR	.equ	ODT_EVEND+090H	;UHL goal direction to move to - temporary
ODT_TURBO	.equ	ODT_EVEND+0B0H	;UHW non zero for non turbo - temporary
ODT_FOCIOFF0	.EQU	ODT_EVEND+0C0H	;UHL FOCI [Z,X] WORLD OFFSET FROM ANIMP
ODT_FOCIOFF1	.EQU	ODT_EVEND+0E0H	;UHL FOCI [Z,X] WORLD OFFSET FROM ANIMP
ODT_FHEIGHT	.equ	ODT_EVEND+0100h	;UHW height of player for puck checks)
ODT_LOOPC	.equ	ODT_EVEND+0110h	;UHW loop counter used in some animation scripts
ODT_PLEND	.equ	ODT_EVEND+0120H	;END OF PLAYER

;GOALIE	GLOBAL
ODT_GFLAGS	.EQU	ODT_PLEND	;UHW GOALIE FLAGS
ODT_GSAVETIME	.EQU	ODT_PLEND+010H	;UHW TIME TO START SAVE ANIMATION
ODT_GSAVE	.EQU	ODT_PLEND+020H	;UHL SAVE ROUTINE
ODT_GZIMPACT	.EQU	ODT_PLEND+040H	;UHL Z IMPACT POSITION
ODT_GXIMPACT	.EQU	ODT_PLEND+060H	;UHL X IMPACT POSITION
ODT_GLASTSIRQ	.EQU	ODT_PLEND+080H	;UHL IRQ TIME OF LAST SAVE
ODT_GTSAVES	.EQU	ODT_PLEND+0A0H	;UHW TOTAL SAVES, WITHIN MAX_TSAVE_TIME
ODT_GPOSSIRQ	.EQU	ODT_PLEND+0B0H	;UHL IRQ TIME OF POSSESSION
ODT_GZPOSPOSS	.EQU	ODT_PLEND+0D0H	;UHL Z POSITION AT TIME OF POSSESSION
ODT_GCOMPTIME	.EQU	ODT_PLEND+0F0H	;UHL TIME OF LAST SAVE COMPUTATION
ODT_GFREEZES	.EQU	ODT_PLEND+0110H	;UHB TOTAL GOALIE FREEZES THIS PERIOD
;ODT_GUNUSED	.EQU	ODT_PLEND+0110H	;UHB UNUSED
ODT_GEND	.EQU	ODT_PLEND+0120H	;END OF GOALIE

;PUCK
ODT_PSPOT	.equ	ODT_EVEND	;UHW puck object, adjustment for players rink location
ODT_PHOT	.equ	ODT_EVEND+010H	;UHW puck object, adjustment for players hot/cold
ODT_POPEN	.equ	ODT_EVEND+020H	;UHW puck object, adjustment for players openness when shooting
ODT_PTYPE	.equ	ODT_EVEND+030H	;UHW puck object, adjustment for type of shot player made
ODT_XDEST	.equ	ODT_EVEND+040H	;SHL x destination of pass
ODT_ZDEST	.equ	ODT_EVEND+060H	;SHL z destination of pass
ODT_PFLAGS	.EQU	ODT_EVEND+080H	;UHW PUCK FLAGS
ODT_XSTRT	.equ	ODT_EVEND+090H	;SHL x start of pass
ODT_ZSTRT	.equ	ODT_EVEND+0b0H	;SHL z start of pass
ODT_PFTIME	.equ	ODT_EVEND+0e0H	;UHW loops at current frame for flat puck
ODT_PEND	.EQU	ODT_EVEND+0f0H	;END OF PUCK

;ICE SPRAY
ODT_POBJ	.equ	ODT_EVEND	;UHL player object
ODT_PANIMSCR	.equ	ODT_EVEND+020h	;UHL work for player on this script only

;MISC FOR PLAYER ANIMATION INDIVIDUAL USE
ODT_TEMP1	.equ	ODT_GEND	;UHL
ODT_TEMP2	.equ	ODT_GEND+020h	;UHL
ODT_SC_OVERRIDE	.equ	ODT_GEND+040h	;UHL scale to override scale table
ODT_SC_XSCALE	.equ	ODT_GEND+060h	;UHW scale of overrided imaged @Z=0 (multiplier * scaletable@z=0) (for head placement only)
ODT_MEND	.equ	ODT_GEND+070h	;end of misc

ODT_END		.EQU	ODATA+0340H	;AIN'T NO MORE AFTER DIS (ODATAX)

	.if	(ODT_END < ODT_EVEND)|(ODT_END < ODT_PLEND)|(ODT_END < ODT_GEND)|(ODT_END < ODT_PEND)|(ODT_END < ODT_MEND)
	ODATA BLOWN!
	.endif

**************************************************************************
*								         *
* PUCK EQUATES								 *
*								         *
**************************************************************************

;PUCK_MODE, only valid if puck_control = 0

PUM_OPEN	EQU	0	;open puck
PUM_FACE	EQU	1	;puck at face off, always get control
PUM_PASS	EQU	10	;pass
PUM_TPASS	EQU	11	;turbo pass
PUM_SHOT	EQU	12	;regular shot
PUM_SSHOT	EQU	13	;slap shot
PUM_ONETIME	EQU	14	;one timer
PUM_DUMP	EQU	15	;dump into zone
PUM_SCORE	EQU	99	;puck has scored a goal, no one can touch it till face off
PUM_FACEOFF	EQU	100	;face off, can't control yet
PUM_ENDPER	EQU	101	;end of period, can't control

;PUCK FLAGS

M_INFRONT	EQU	1	;PLACE PUCK IN FRONT OF PLAYER
M_INBACK	EQU	2	;PLACE PUCK IN BACK OF PLAYER

B_INFRONT	EQU	0
B_INBACK	EQU	1

**************************************************************************
*								         *
* PLAYER BLOCK EQUATES							 *
*								         *
**************************************************************************

PLAYER_BLOCK_BSIZE .equ	12			;shift 12 bits to get block #
PLAYER_BLOCK_SIZE  .equ	4096			;= PLAYER_2_BLOCK-PLAYER_1_BLOCK

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
POF_HOME		.equ	0090h	;UHW 0 - home, 1 - visitor
POF_MASS		.equ	00a0h	;UHW player mass
POF_INITIAL1		.equ	00b0h	;UHB 0-25 A-Z, 26 = ' '
POF_INITIAL2		.equ	00b8h	;UHB 0-25 A-Z, 26 = ' '
POF_INITIAL3		.equ	00c0h	;UHB 0-25 A-Z, 26 = ' '
POF_BMONTH		.equ	00c8h	;UHB 1-12
POF_BDAY		.equ	00d0h	;UHB 1-31
********************************
*			       *
* PLAYER ABILITY DATA	       *
*			       *
********************************
POF_S_SPED		.equ	00e0h	;UHL table pointer - player speed data
POF_S_STOP		.equ	0100h	;UHL table pointer - player stopping data
POF_S_CORN		.equ	0120h	;UHL table pointer - player cornering data
POF_S_SHOT		.equ	0140h	;UHL table pointer - player shooting data
POF_S_PASS		.equ	0160h	;UHL table pointer - player passing data
POF_S_FACE		.equ	0180h	;UHL table pointer - player dumping data
POF_S_HAND		.equ	01a0h	;UHL table pointer - player handling data
POF_S_CHEK		.equ	01c0h	;UHL table pointer - player check data
POF_S_STAB		.equ	01e0h	;UHL table pointer - player shot table
********************************
*			       *
* PLAYER STATES		       *
*			       *
********************************
POF_FLAGS		.equ	0200h	;UHW - see below
POF_MODE		.equ	0210h	;UHW what player is doing (not valid during higher control)
POF_RELEASE_TIME	.equ	0220h	;UHL waveirqs of estimated shot release time
**************************************************************************
*								         *
* PLAYER PALETTES							 *
*								         *
**************************************************************************
POF_NORMALPAL		.equ	0240h	;UHL non turbo player palette
POF_TURBOPAL		.equ	0260h	;UHL turbo player palette
********************************
*			       *
* PLAYER RELATED OBJECTS       *
*			       *
********************************
POF_OBJECT		.equ	0280h	;UHL players object
POF_SHADOW		.equ	02a0h	;UHL players shadow object
POF_GOALIE_OBJECT	.equ	02c0h	;UHL object of teams goalie
POF_ARROW		.equ	02e0h	;UHL object of players arrow
POF_TURBO_BOX		.equ	0300h	;UHL turbo box object (or press start/insert coin)
POF_TURBO_BAR		.equ	0320h	;UHL turbo bar object (or to control)
POF_TURBO_NAME		.equ	0340h	;UHL turbo name object (both modes)
POF_ARROW_CPU		.equ	0360h	;UHL if player is not human, object for his cpu title
********************************
*			       *
* PLAYER JOYSTICK DATA	       *
*			       *
********************************
POF_BUTTONS		.equ	0380h	;UHW buttons of player
POF_DIRECTION		.equ	0390h	;UHB last facing direction of player
POF_JOY			.equ	0398h	;UHB joystick direction (1-8)
POF_I_JOY		.equ	03a0h	;UHB ignore this joystick direction
POF_M_JOY		.equ	03a8h	;UHB modified joystick direction (1-8)
POF_CORNER_TEMP		.equ	03b0h	;UHB last corner check for diagonal removal
POF_PPMOD		.equ	03c0h	;UHW puck point might be too close to wall, use close script
POF_BDIRECTION		.equ	03d0h	;UHB buffered direction (takes effect on script change)
POF_LAST_DIRECTION	.equ	03d8h	;UHB last POF_DIRECTION (for backwards/forwards thing)
POF_FAKE_DIRECTION	.equ	03e0h	;UHW fake direction for drone use at faceoff
********************************
*			       *
* MISC PLAYER DATA	       *
*			       *
********************************
POF_SHOT_FAKE		.equ	0400h	;UHL time of last shot start (waveirqs)
POF_SHOT_START		.equ	0420h	;UHL started shooting at this time (for fake test and dump puck tests)
POF_SPEED_GL		.equ	0440h	;UHL used to see if we are speeding up or slowing down
POF_PASS_START		.equ	0460h	;UHL started passing at this time (for dump puck tests)
POF_SHOOT_CURRENT	.equ	0480h	;UHL current shoot speed (for calculations and reference)
POF_SPEED_BOOST		.equ	04a0h	;SHL stuffed at control start, is 0 or defense boost, or negative puck against
POF_TURBO_AMOUNT	.equ	04c0h	;SHL turbo amount s15:16
POF_SHOT_RELEASE	.equ	04e0h	;UHL call this on a release of shoot, during a shoot
POF_SHOT_PASS		.equ	0500h	;UHL call this on a pass during a shoot
POF_LAST_BOARD_CVEL	.equ	0520h	;UHL last velocity of board crash
POF_PASS_RELEASE	.equ	0540h	;UHL call this on a release of shoot, during a shoot
POF_ARROW_TIME		.equ	0560h	;UHW time left to show arrow
POF_TURBO_DELAY		.equ	0570h	;SHW delay till we bring turbo up
POF_TURBO_MODE		.equ	0580h	;SHW turbo is on when <> 0
POF_STAND_STILL		.equ	0590h	;UHB player is standing still # ticks
POF_IGNORE_PUCK		.equ	0598h	;UHB ignore puck till this is zero
POF_ARROW_HYST		.equ	05a0h	;UHB player arrow hysteresis
POF_TOP_MODE		.equ	05a8h	;UHB current state of top
POF_SKID_BOOST		.equ	05b0h	;UHB current skid boost
POF_TURBO_OB		.equ	05c0h	;UHW turbo is off button pushed, countdown code
POF_HAS_CHECKED		.equ	05d0h	;UHW player has checked this script
POF_TIRED		.equ	05e0h	;UHW last tired count (turbo left before faceoff)
POF_QS_OK		.equ	05f0h	;UHW ok to do quick start (+ = direction ok, 0 = ok all, -1 = nok)
********************************
*			       *
* PLAYER DISTANCE DATA	       *
*			       *
********************************
POF_D_1P		.equ	0600h	;UHW distance to player 1
POF_D_2P		.equ	0610h	;UHW distance to player 2
POF_D_3P		.equ	0620h	;UHW distance to player 3
POF_D_4P		.equ	0630h	;UHW distance to player 4
POF_D_5P		.equ	0640h	;UHW distance to player 5
POF_D_6P		.equ	0650h	;UHW distance to player 6
POF_D_7P		.equ	0660h	;UHW distance to player 7
POF_D_8P		.equ	0670h	;UHW distance to player 8
POF_D_PUCK		.equ	0680h	;UHW distance to puck (only valid if free puck, or opposing team)
POF_D_COLL		.EQU	0690H	;UHW COLLISION DISTANCE
POF_D_LASTPUCK0		.EQU	06A0H	;UHW LAST DISTANCE TO PUCK
POF_D_LASTPUCK1		.EQU	06B0H	;UHW LAST DISTANCE TO PUCK

**************************************************************************
*								         *
* DRONE LOGIC DATA							 *
*								         *
**************************************************************************
POF_DRONE1		.equ	0700h	;UHW drone point data
POF_DRONE2		.equ	0710h	;UHW drone point data
POF_DRONEC		.equ	0720h	;UHW drone - set on a collision with rink or player
POF_DRONE_PX		.equ	0730h	;UHW drone point goto position (after random adjust)
POF_DRONE_PZ		.equ	0740h	;UHW drone point goto position (after random adjust)
POF_DRONECT		.equ	0750h	;UHW drone count of hits since last change
POF_DRONEPST		.equ	0760h	;UHW drone # steps before we pass or shoot
POF_DRONE_OM		.equ	0770H	;UHW drone offensive mode (0 = normal get open, 1 = breakaway)
**************************************************************************
*								         *
* PLAYER STAT DATA							 *
*								         *
**************************************************************************
POF_SHOTS_P1		.equ	0780h	;UHB shots on goal - period 1
POF_SHOTS_P2		.equ	0788h	;UHB shots on goal - period 2
POF_SHOTS_P3		.equ	0790h	;UHB shots on goal - period 3
POF_SHOTS_PO		.equ	0798h	;UHB shots on goal - overtime
POF_GOALS_P1		.equ	07a0h	;UHB goals scored - period 1
POF_GOALS_P2		.equ	07a8h	;UHB goals scored - period 2
POF_GOALS_P3		.equ	07b0h	;UHB goals scored - period 3
POF_GOALS_PO		.equ	07b8h	;UHB goals scored - overtime
POF_ASSISTS_P1		.equ	07c0h	;UHB assists on goals - period 1
POF_ASSISTS_P2		.equ	07c8h	;UHB assists on goals - period 2
POF_ASSISTS_P3		.equ	07d0h	;UHB assists on goals - period 3
POF_ASSISTS_PO		.equ	07d8h	;UHB assists on goals - overtime
POF_PASSES_P1		.equ	07e0h	;UHB passes - period 1
POF_PASSES_P2		.equ	07e8h	;UHB passes - period 2
POF_PASSES_P3		.equ	07f0h	;UHB passes - period 3
POF_PASSES_PO		.equ	07f8h	;UHB passes - overtime
POF_STEALS_P1		.equ	0800h	;UHB steals - period 1
POF_STEALS_P2		.equ	0808h	;UHB steals - period 2
POF_STEALS_P3		.equ	0810h	;UHB steals - period 3
POF_STEALS_PO		.equ	0818h	;UHB steals - overtime
POF_CHECKS_P1		.equ	0820h	;UHB checks - period 1
POF_CHECKS_P2		.equ	0828h	;UHB checks - period 2
POF_CHECKS_P3		.equ	0830h	;UHB checks - period 3
POF_CHECKS_PO		.equ	0838h	;UHB checks - overtime
POF_SAVES		.EQU	0840H	;UHW SAVES - GOALIE ONLY
**************************************************************************
*								         *
* PLAYER GAME DATA							 *
*								         *
**************************************************************************
POF_PERIODS_PAID	.equ	0900H	;UHB periods paid for (bits 0-3)
**************************************************************************
*								         *
* PLAYER MORE MISC DATA							 *
*								         *
**************************************************************************
POF_LAST_GINTENSITY	.equ	0940h	;UHW last intensity of goalie phrase
POF_LAST_GSAVE		.equ	0950h	;UHL last time of goalie save phrase
;POF_CELEBRATION		.equ	0970h	;UHL celebration script pointer
POF_LEAN_GOAL		.equ	0980h	;SHW last lean
POF_LEAN		.equ	0990h	;SHW -2,-1 - lean to left, 1,2 to right
POF_LEAN_TIME		.equ	09A0h	;UHL waveirqs of lean change
POF_NOFACE		.equ	09C0h	;UHW bits indicate directions we are not allowed to face
POF_DRONE_BUTTONS	.equ	09d0h	;UHW drone button states (for one timer)
POF_DRONE_NETTIME	.equ	09e0h	;UHW used by drone to time guys behind net (written by opponent)
POF_SKATE_RATE_T	.equ	09f0h	;UHW 0-regular skating, 1-fast skating, 2-1 hand fast skating
POF_SKATE_RATE_D	.equ	0a00h	;UHB direction for valid skate_rate restrictions
POF_SKATE_RATE_G	.equ	0a08h	;UHB goal skate_rate_t
POF_TRAIL_PAL		.equ	0a10h	;UHL palette used for trails
POF_DEKE_TIME		.equ	0a30h	;UHL time of last deke count inc
POF_DEKE_COUNT		.equ	0a50h	;UHW deke count value
POF_SAFETY_WARNING	.equ	0a60h	;UHW safety warning on shot
POF_DRONE_OP_STATE	.equ	0a70h	;UHW drone is going through 'o' or 'p' match points
POF_DRONE_OP_TIME	.equ	0a90h	;UHL drone 'o'/'p' switch time
POF_DRONE_MEANNESS	.equ	0ab0h	;UHW count for drone meanness level
POF_DRONE_MEANSTATE	.equ	0ac0h	;UHW drone mean state
POF_DRONE_OUTSIDE	.equ	0ad0h	;UHW drone is from outside if non zero
POF_DRONE_PATTERN	.equ	0ae0h	;UHW pattern # of drone
POF_DRONE_PADDR		.equ	0af0h	;UHL address into current pattern
POF_DRONE_CTIME		.equ	0b10h	;UHL time drone threw check
POF_DRONE_STIME		.equ	0b30h	;UHL time drone shot puck
POF_HOT_OBJECT		.equ	0b50h	;UHL object for player's hot object
POF_HOT_VALUE		.equ	0b70h	;UHW player's hot build up value
POF_HOT_PAL		.equ	0b80h	;UHL palette of hot object
POF_SHOT_ATTEMPTS	.EQU	0BA0H	;UHW NUMBER OF ATTEMPTS SINCE LAST GOAL
POF_DSP_TIME		.equ	0bb0h	;UHL time player deked/split
POF_DSP_TYPE		.equ	0bd0h	;UHW 1 = deke, -1 = split, 0 undecided, 2 = not available
POF_DRONE_LEVEL		.equ	0be0h	;UHW 0-10 drone difficulty level (if drone)
POF_HOT_VALUE_D		.equ	0bf0h	;UHW displayed hot value
POF_FREEZE_BITS		.equ	0c00h	;UHW bits of freeze game messages we have shown player
POF_FREEZE_OFFTIME	.equ	0c10h	;UHW time player is off screen
POF_CELEBRATION		.equ	0c20h	;UHL celebration script pointer
POF_LOCKED_CHAR		.EQU	0C40H	;UHW LOCKED CHARACTER
POF_PUP_FLAGS		.equ	0C50H	;UHW POWERUP FLAGS
POF_DRONE_NO_CHECK	.equ	0c60h	;UHL drone cannot check until after this time
POF_REDPAL		.equ	0c80h	;UHL palette used for trails (red)
POF_TTIME		.equ	0c90h	;UHL time drone button pushed (elbow)
**************************************************************************
*								         *
* PLAYER CHECK DATA							 *
*								         *
**************************************************************************
POF_CHECK_LAST		.equ	0d00h	;UHL time of last checked
POF_CHECK_COUNT		.equ	0d20h	;UHW count of checks close together
POF_HIT_BOARDS		.equ	0d30h	;UHW body checks - hit boards
POF_CONTROL_OBJECT	.equ	0d40h	;UHL pointer to controlling object
POF_CONTROL_SCRIPT	.equ	0d60h	;UHL controlling objects script (we abort if no match)
POF_CONTROLLED		.equ	0d80h	;UHL pointer to object we are controlling
POF_CONTROLLED_SCRIPT	.equ	0da0h	;UHL controlled objects script (we abort if no match)
POF_CWALL_TIME		.equ	0dc0h	;UHW time locked to wall
POF_HIT_BOARDS_A	.equ	0dd0h	;UHW angle we bounced off boards
POF_ATTACH_X		.equ	0de0h	;UHW x offset to attached player
POF_ATTACH_Z		.equ	0df0h	;UHW z offset to attached player
POF_ATTACH_Y		.equ	0e00h	;UHW y offset to attached player
POF_GET_UP_COUNT	.equ	0e10h	;UHW current get up count of fallen player
POF_GET_UP_GOAL		.equ	0e20h	;UHW get up count goal of fallen player
POF_ATTACH_VDIR		.equ	0e30h	;UHL attach velocity dir
POF_ATTACH_VVEL		.equ	0e50h	;UHL attach velocity
POF_ATTACH_ABORT	.equ	0e70h	;UHW abort count for attach
POF_ATTACH_F		.equ	0e80h	;UHW 0 if facing wall, non zero else
;POF_END		.EQU	01000H

;POF_TOP_MODE
;	0 - nothing on top
;	1 - name/turbo bar
;	2 - press start
;	3 - insert coin(s)
;	4 - to control/player
;	5 - please wait

;POF_MODE

;PLAYER MODES

PM_STAND	EQU	0	;standing
PM_SKATE	EQU	1	;skating
PM_PASS		EQU	2	;passing
PM_SHOOT	EQU	3	;shooting
PM_SKID		EQU	4	;skidding to stop (for reverse or stop)
PM_STEAL	EQU	5	;steal puck
PM_CROSSCHECK	EQU	6	;pushing
PM_SHAKE	EQU	7	;get shaken up
PM_DUMP		EQU	8	;dumping
;PM_STANCE	EQU	9	;IN GOALIE STANCE
PM_FALL		EQU	10	;fall to stomach/back
;PM_DEFLECT	EQU	11	;GOALIE DEFLECTING
;PM_SAVE	EQU	12	;GOALIE SAVE
PM_ONETIME	EQU	13	;player is one timing
PM_HIGHSTICK	EQU	14	;player is highsticking
PM_SLASH	EQU	15	;player is slashing
PM_SWING	EQU	16	;player is flagrantly swinging
PM_HIP		EQU	17	;player is hip checking (or other backwards check)
PM_BLOCK	EQU	18	;player is blocking a shot (somehow)

;GOALIE MODES

PM_GSTAND	EQU	0	;GOALIE STANDING
PM_GSKATE	EQU	1	;GOALIE SKATING
PM_GPASS	EQU	2	;GOALIE PASSING
;PM_GSHOOT	EQU	3	;shooting
PM_GSKID	EQU	4	;skidding to stop (for reverse or stop)
;PM_GSTEAL	EQU	5	;steal puck
PM_GCROSSCHECK	EQU	6	;GOALIE CROSS CHECKING
;PM_GSHAKE	EQU	7	;get shaken up
;PM_GDUMP	EQU	8	;dumping
;PM_GSTANCE	EQU	9	;GOALIE IN STANCE
;PM_GFALL	EQU	10	;fall to stomach/back
PM_GDEFLECT	EQU	11	;GOALIE DEFLECTING PUCK
PM_GSAVE	EQU	12	;GOALIE SAVING PUCK
;PM_GONETIME	EQU	13	;player is one timing
PM_GSMOTHER	EQU	14	;GOALIE SMOTHERING PUCK
PM_GHOLDING	EQU	15	;GOALIE HOLDING PUCK
PM_GGOAL	EQU	16	;GOALIE AFTER GOAL
PM_GCROUCH	EQU	17	;CROUCH AT FACEOFF
PM_GHUGPOST	EQU	18	;HUG POST
PM_GSIDESHUFF	EQU	19	;SIDE SHUFFLE
PM_GCHECKED	EQU	20	;RECEIVING A CHECK


;POF_BUTTONS
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
B_PF_BPASS	.equ	8	;pass is of bounce type
B_PF_CONTROLM	.equ	9	;player under ~PF_CONTROL has control of movement
B_PF_CONTROLB	.equ	10	;player under ~PF_CONTROL has control of buttons (pass, shoot)
B_PF_REV_FACE	.equ	11	;player is doing a reverse grab faceoff
B_PF_CELEBRATE	.equ	12	;celebration script has player
B_PF_OTD	.equ	13	;player has one timed already on this script
B_PF_TRAILS	.equ	14	;player trails follow player

M_PF_HUMAN	.equ	0000000000000001b
M_PF_CONTROL	.equ	0000000000000010b
M_PF_GOALIE	.equ	0000000000000100b
M_PF_OKDIR	.equ	0000000000001000b
M_PF_HIGHER	.equ	0000000000010000b
M_PF_HIGHER_W	.equ	0000000000100000b
M_PF_SIG_SHOOT	.equ	0000000001000000b
M_PF_SIG_PASS	.equ	0000000010000000b
M_PF_BPASS	.equ	0000000100000000b
M_PF_CONTROLM	.equ	0000001000000000b
M_PF_CONTROLB	.equ	0000010000000000b
M_PF_REV_FACE	.equ	0000100000000000b
M_PF_CELEBRATE	.equ	0001000000000000b
M_PF_OTD	.equ	0010000000000000b
M_PF_TRAILS	.equ	0100000000000000b


B_PUP_BIGHEAD	.EQU	0	;BIG HEAD, JUST LIKE THAT EDHALL SONG
B_PUP_HUGEHEAD	.EQU	1
B_PUP_TINYHEAD	.EQU	2
B_PUP_FATHEAD	.EQU	3
B_PUP_NORMHEAD	.EQU	4

B_PUP_FORCEFAT	.EQU	5	;FORCE TINY HEAD
B_PUP_SPEED	.EQU	6	;INCREASE SPEED
B_PUP_SHOOT	.EQU	7	;         SHOOTING
B_PUP_PASS 	.EQU	8	;         PASSING
B_PUP_CHECK	.EQU	9	;         CHECKING
B_PUP_PUCK 	.EQU	10	;         PUCK HANDLING
B_PUP_TURBO	.EQU	11	;FAST TURBO RECOVERY

M_PUP_BIGHEAD  	.EQU	00001H
M_PUP_HUGEHEAD 	.EQU	00002H
M_PUP_TINYHEAD 	.EQU	00004H
M_PUP_FATHEAD 	.EQU	00008H
M_PUP_NORMHEAD 	.EQU	00010H

M_PUP_FORCEFAT	.EQU	00020H
M_PUP_SPEED	.EQU	00040H
M_PUP_SHOOT	.EQU	00080H
M_PUP_PASS 	.EQU	00100H
M_PUP_CHECK	.EQU	00200H
M_PUP_PUCK 	.EQU	00400H
M_PUP_TURBO	.EQU	00800H

M_PUP_HEADS	.EQU	M_PUP_BIGHEAD|M_PUP_HUGEHEAD|M_PUP_TINYHEAD|M_PUP_FATHEAD|M_PUP_NORMHEAD

M_PUP_ATTR	.EQU	M_PUP_SPEED|M_PUP_SHOOT|M_PUP_PASS|M_PUP_CHECK|M_PUP_PUCK|M_PUP_TURBO


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
;PS_DP_DUMP_SPEED		.equ	0000h	;UHL speed used to dump puck
;PS_DP_DUMP_TURBO		.equ	0020h	;UHL turbo speed used to dump
;PS_DP_DUMP_CHANGE		.equ	0040h	;UHL called to change dump shot angle
;PS_DP_TDUMP_CHANGE		.equ	0060h	;UHL called to change turbo dump shot angle

***************
*	      *
* POF_S_HAND  *
*	      *
***************
PS_HN_INT_CONTROL		.equ	0000h	;UHL called to see if we control after an intended pass
PS_HN_OFF_CONTROL		.equ	0020h	;UHL called to see if we control after an offensive stop
PS_HN_DEF_CONTROL		.equ	0040h	;UHL called to see if we control after a defensive stop

***************
*	      *
* POF_S_CHEK  *
*	      *
***************
;following are indexed, and NOT referenced by equate
PS_CK_NO_LOSS		.equ	0000h	;UHL turbo removed for throwing check
PS_CK_SOME_LOSS		.equ	0020h	;UHL turbo removed for checking somebody 
PS_CK_DOWN_LOSS		.equ	0040h	;UHL extra turbo removed for checking down person
PS_CK_SKILL		.equ	0060h	;UHW checking 1-5 skill level

**************************************************************************
*								         *
* CMOS PLAYER EQUATES							 *
*								         *
**************************************************************************
;CMX_INITIAL1	.equ	0	;5
;CMX_INITIAL2	.equ	5	;5
;CMX_INITIAL3	.equ	10	;5
;CMX_BIRTHDAY	.equ	15	;9
;CMX_TEAMSBEAT	.equ	24	;32
;CMX_NEXTTEAM	.equ	56	;5
;CMX_WINS	.equ	61	;11
;CMX_LOSSES	.equ	71	;10
;CMX_TIES	.equ	81	;8
;CMX_FIGHTWINS	.equ	89	;9
;CMX_FIGHTLOSSES	.equ	98	;9
;CMX_LASTTEAM	.equ	107	;5
;CMX_LASTRIVAL	.equ	112	;5
;CMX_LASTSCORE1	.equ	117	;6
;CMX_LASTSCORE2	.equ	123	;6
;CMX_LASTVISITOR	.equ	129	;1
;CMX_N		.equ	130	;x
;CMX_CHECKSUM	.equ	248	;8
;CMX_END		.equ	256	

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
SUPP_3	.EQU	01800H		;back wall
SUPP_4	.EQU	02000H		;alt wnz/wnone (halves of dims) (midway logo)
SUPP_5	.EQU	02800H		;player scored by box
SUPP_6	.EQU	03000H		;REAR GOAL PARTS
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
OID_REF_SHAD		EQU	SUPP_2+001f0H

OID_PUCK		EQU	0200h
OID_HEAD		EQU	0201h
OID_PUCK_SHADOW		EQU	0202h
OID_GOAL		EQU	0203H		;goal objects
OID_BACKWALL		EQU	SUPP_3+0204H	;back wall images
OID_EDGE		EQU	0205H		;edge rink pieces
OID_BIGPUCK		EQU	0206H
OID_PUCK_TRAIL		EQU	0207H
OID_SCORED_BY		EQU	SUPP_5+0208H	;scored_by box (picture, goals...)
OID_RGOAL		EQU	SUPP_6+0209H	;REAR goal objects
OID_PIPE		EQU	020AH		;PIPE FRAGMENT
OID_FLASH		EQU	020BH		;camera flash

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
OID_TURBOSBAR_1		EQU	0331H		;small turbo bar
OID_TURBOSBAR_2		EQU	0332H		;small turbo bar
OID_TURBOSBAR_5		EQU	0335H		;small turbo bar
OID_TURBOSBAR_6		EQU	0336H		;small turbo bar

OID_LOGO		EQU	0400H		;attract mode logos
OID_DUMMYPAGE		EQU	0401H		;dummy page filler objects
OID_BIGGIRLS		EQU	0402H		;big girl images and stanley cup stuff
OID_GIRLTEXT		EQU	SUPP_7+0403H	;text for big girls (26 teams beat)

OID_TEXT		EQU	0480H		;"OBJECT LIST" TEXT
OID_CREDIT		EQU	0488H		;CREDIT MESSAGE TEXT
OID_PROMPT		EQU	0489H		;"READY FOR" MESSAGE
OID_PROMPT2		EQU	048AH		;"PRESS START" MESSAGE
OID_CUSTOM		EQU	048BH		;CUSTOM MESSAGE, COINAGE, MAX CRED, ETC.
OID_REQUIRED		EQU	048CH		;CREDITS REQUIRED MESSAGE
OID_TIMER		EQU	048DH		;TIMER DIGIT

OID_SELECT_1		EQU	0490H		;SELECT GRAPHICS LEVEL 1
OID_SELECT_2		EQU	0491H		;SELECT GRAPHICS LEVEL 2
OID_SELECT_3		EQU	0492H		;SELECT GRAPHICS LEVEL 3

OID_STAT_1		EQU	SUPP_9+04A0H	;INTERMISSION STAT
OID_STAT_2		EQU	SUPP_10+04A0H	;INTERMISSION STAT
OID_STAT_3		EQU	SUPP_11+04A0H	;INTERMISSION STAT
OID_STAT_4		EQU	SUPP_12+04A0H	;INTERMISSION STAT
OID_STAT_5		EQU	SUPP_13+04A0H	;INTERMISSION STAT
OID_STAT_6		EQU	SUPP_14+04A0H	;INTERMISSION STAT
OID_STAT_7		EQU	SUPP_15+04A0H	;INTERMISSION STAT

OID_ARROW		EQU	0500H		;arrow objects
OID_CPU			EQU	0501H		;cpu label objects
OID_REF			EQU	0502H		;referee object oid
OID_FROZEN_MESSAGE	EQU	0503H		;message box when game is frozen
OID_PUCK_PTR		EQU	0504H		;POINT TO STOPPED PUCK OBJECTS
OID_GCARD		EQU	0505H		;GOALIE CARD OBJECT

MASK_OID_NEW_TIMER	EQU	07F0H
;OID_NEW_SCORE_BOX_1	EQU	SUPP_4+0600H
;OID_NEW_SCORE_BOX_2	EQU	SUPP_4+0601H
;OID_NEW_SCORE_T1	EQU	0602H
;OID_NEW_SCORE_T2	EQU	0603H		;SHUT UP
;OID_NEW_SCORE_T1_S1	EQU	0604H
;OID_NEW_SCORE_T1_S2	EQU	0605H
;OID_NEW_SCORE_T2_S1	EQU	0606H
;OID_NEW_SCORE_T2_S2	EQU	0607H
;OID_NEW_SCORE_TM_1	EQU	0608H		;minutes    /  tenseconds
;OID_NEW_SCORE_TM_2	EQU	0609H		;colon      /  seconds
;OID_NEW_SCORE_TM_3	EQU	060AH		;tenseconds /  decimal
;OID_NEW_SCORE_TM_4	EQU	060BH		;seconds    /  tenths
;OID_NEW_SCORE_PER	EQU	060CH
;OID_NEW_SCORE_MID1	EQU	SUPP_4+060DH		;midway part 1
;OID_NEW_SCORE_MID2	EQU	SUPP_4+060EH		;midway part 1

OID_BIG_SCORE_BAR	EQU	0610H
OID_BIG_SCORE_ANIMATION	EQU	0611H
;OID_BIG_SCORE_NHL	EQU	0612H
OID_BIG_SCORE_FLASHER1	EQU	0612H
OID_BIG_SCORE_JITTER1	EQU	SUPP_4+0611H
OID_BIG_SCORE_JITTER2	EQU	SUPP_4+0612H
;OID_BIG_SCORE_NHLPA	EQU	0613H
OID_BIG_SCORE_FLASHER2	EQU	0613H
OID_BIG_SCORE_T1	EQU	0614H
OID_BIG_SCORE_T2	EQU	0615H		;SHUT UP
OID_BIG_SCORE_T1_S1	EQU	0616H
OID_BIG_SCORE_T1_S2	EQU	0617H
OID_BIG_SCORE_T2_S1	EQU	0618H
OID_BIG_SCORE_T2_S2	EQU	0619H
OID_BIG_SCORE_TM_1	EQU	061AH		;minutes    /  tenseconds
OID_BIG_SCORE_TM_2	EQU	061BH		;colon      /  seconds
OID_BIG_SCORE_TM_3	EQU	061CH		;tenseconds /  decimal
OID_BIG_SCORE_TM_4	EQU	061DH		;seconds    /  tenths
OID_BIG_SCORE_PER	EQU	061EH
OID_BIG_SCORE_LOGO	EQU	061FH

OID_ATTRACT_LOGOS	EQU	0700H		;attract mode logos

OID_PLAYER_TRAILS	EQU	0701H
OID_PLAYER_SPRAY	EQU	0702H

OID_JUNK		EQU	07FFH		;SHIT THAT CLUTTERS THE PLAYFIELD

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
B_INDESTRUCT		EQU	15

PID_IND			EQU	0000CH		;INDEPENDENT PROCESS
PID_INDW		EQU	0200CH		;WAVE END WILL NOT KILL IND. PROCESS

PID_COLOR		EQU	02CC0H		;COLOR CYCLE PROCESSES
PID_BOXCOLOR		EQU	02CC1H		;COLOR CYCLE PROCESSES (for scored by boxes)
PID_TIMECOLOR		EQU	02CC2H		;timer float cycle process
PID_POWCOLOR		EQU	02CC3H		;GENERAL POWER-UP COLOR CYCLE
PID_PFADE		EQU	02D00H		;FADER PROCESSES ( LOW BYTE = PAL )
PID_SKY			EQU	02E00H		;SKY FADER PROCESS
PID_WHITEFADE		EQU	02E01H		;fade screen from white at period start

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

;PID_ILAMP		EQU	08F0AH		;INDESTRUCTIBLE LAMP PROCESS
;PID_LAMP		EQU	00F0AH		;LAMP PROCESS

PID_PLAYER_1		EQU	00100H		;base for player
PID_PLAYER_2		EQU	00200H		; specific processes
PID_PLAYER_3		EQU	00300H		;
PID_PLAYER_4		EQU	00400H		;
PID_PLAYER_5		EQU	00500H		;
PID_PLAYER_6		EQU	00600H		;
PID_PLAYER_7		EQU	00700H		;
PID_PLAYER_8		EQU	00800H		;

PID_PLAYER_1_MESS	EQU	00105H		;PLAYER MESSAGES
PID_PLAYER_2_MESS	EQU	00205H		;
PID_PLAYER_5_MESS	EQU	00505H		;
PID_PLAYER_6_MESS	EQU	00605H		;

PID_WATCH		EQU	00900H
PID_GAME_TIMER		EQU	00903H		;game timer decrement
PID_PUCK_SOUND		EQU	00904H		;delay to let puck stuff happen before sound
PID_NEW_SCORE		EQU	00905H		;timer is coming/going
PID_BIG_SCORE		EQU	00906H		;big timer is coming/going
PID_SCORE_MOVE		EQU	00907H
PID_CREDIT		EQU	00908H		;DISPLAY CREDIT PROCESS
PID_DISPLAY_CREDIT	EQU	08908H		;GAME DISPLAY CREDIT PROCESS
PID_TIMER		EQU	00909H		;TIMER PROCESS
PID_INITIAL_SEL		EQU	0090AH		;INITIAL SELECT PROCESS
PID_TEAM_SEL		EQU	0090BH		;TEAM SELECT PROCESS
PID_SUB_SEL		EQU	0090CH		;SUBSTITUTION SELECT PROCESS
PID_POWERUP		EQU	0090DH		;POWERUP PROCESS
PID_GCARD		EQU	0090EH		;GOALIE CARD PROCESS
PID_GCARD_FREEZE	EQU	0090FH		;GOALIE CARD FREEZE PROCESS
PID_SIDE_BRIGHT		EQU	00910H		;side brightness dimmer process

PID_GOAL_CYCLE		EQU	00a00H		;process that handles sequence from goal to face off
PID_MOVE_TO		EQU	00a01H		;for moving 1 player to a point (higher control)
PID_SCORE_DISPLAY	EQU	00a02H		;puts up and takes down scores
PID_SEQUENCE		EQU	00a03H		;handles sequence from initial entry to start of period 1
PID_PLW			EQU	00a04H		;debug mode - player coords
PID_PLW2		EQU	00a05H		;position recorder
PID_PGC			EQU	00a06H		;pull goalie timeout switch count process
PID_CANNED_SCORE	EQU	00a07H		;canned puck/net interaction sequence
PID_SCORED_BY		EQU	00a08H		;scored by window up/down process
PID_STEAL_RESOLVE	EQU	00a09H		;to isolate us from surroundings and do steal speech call
PID_CELEBRATIONS	EQU	00a0aH		;move process for main celebration animation
PID_CELEBRATION_P	EQU	00a0bH		;move processes for celebration animations
PID_SCORES_FLASH	EQU	00a0cH		;flash the teams score who score
PID_RESTART_WINNER	EQU	08A0DH		;RESTART GAME FOR WINNERS
;PID_RESTART_WINNER	EQU	00A0DH		;RESTART GAME FOR WINNERS
PID_HOT_CYCLE		EQU	00a0eH
PID_BOARD_ADEL		EQU	00a0fH		;used to delete board animations
PID_GOAL_SLIDE		EQU	00A10H		;GOAL SLIDING BACK

PID_FACEOFF		EQU	00b00H		;process that handles faceoffs
PID_REF			EQU	00b01H		;ref controll process
PID_HELP_WINDOW		EQU	00B02H		;HELP WINDOW THINGY
PID_PUCK_PTR		EQU	00B03H		;POINT TO STOPPED PUCK
PID_PUCK_INSURE		EQU	00b04h		;insure puck is earthbound
PID_TRY_GPOST		EQU	00b05h		;try to do off the goalpost speech

PID_ATTRACT_MODE	EQU	01000H		;attract mode process
PID_ORGAN		EQU	01001H		;background organ process
PID_CROWD_NOISE		EQU	01002H		;background crowd noise process
PID_CROWD_REACT_NOISE	EQU	01002H		;background crowd noise process

PID_OCTOPUS_BUTTON	EQU	01010H		;timing process for octopus buttons
PID_FROZEN_MESSAGE	EQU	09011H		;process dealing with game frozen
PID_FROZEN_TURBOCHECK	EQU	01012H		;process that one at a time, check to see if people turbo
PID_FROZEN_PFADE	EQU	0AD00H		;FROZEN FADER PROCESSES
PID_CONGRATS_SND	EQU	01013H		;sound/music sequencer for all 26 beaten
PID_SHAKE		EQU	01014h		;screen shake process

;offsets from player base for player processes
PIDOF_WATCH_SHOOT	EQU	00001H		;watch for shoot button open
PIDOF_WATCH_PASS	EQU	00002H		;watch for pass button open
PIDOF_PASS_SHOOT	EQU	00003H		;pass and shoot process id
PIDOF_PASS_HOLDW	EQU	00004H		;pass 
PIDOF_MESS		EQU	00005H		;player messages
PIDOF_CELEBRATE		EQU	00006H		;player celebrations/get pissed

;frozen message equates
PFRZ_OFFSCREEN		EQU	1		;you are off the screen too long
PFRZ_SHOOTFAR		EQU	2		;you are shooting from too far away
PFRZ_SHOOTPASS		EQU	3		;you are never shooting or passing
PFRZ_DRONE_SHOOTPASS	EQU	4		;you never tell your drone to shoot or pass
PFRZ_TURBO		EQU	5		;you never use turbo
PFRZ_SMOTHERPASS	EQU	6		;you let the goalie smother
;
PFRAZ_TURBOED		EQU	10		;flag used in freeze bits to indicate we have turboed
M_PFRAZ_TURBOED		EQU	0000010000000000b

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
ININTRO_INITQ	.EQU	ININTRO+0001B
ININTRO_INITENT	.EQU	ININTRO+0010B
ININTRO_TEAMSEL	.EQU	ININTRO+0011B
ININTRO_TG	.EQU	ININTRO+0100B
INPLAY		.EQU	20H
INAMODE		.EQU	30H
INDIAG		.EQU	40H
INGAMEOV 	.EQU	50H
INEPILOG	.EQU	60H
INSTAT		.EQU	70H
INSUBST		.EQU	80H
INBUYIN		.EQU	90H

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
ADJ_CULY	EQU	ADJ_ULY-64			;WBD COIN UPPER LEFT Y
ADJ_PULY	EQU	ADJ_ULY-28
*
;COIN_HEAD_Y	EQU	CUR_ULY+91	;1ST OF TOP COIN INFO LINES
COIN_HEAD_Y	EQU	CUR_ULY+56	;WBD 1ST OF TOP COIN INFO LINES
MESS_CTS	EQU	CUR_ULY+92  	;WBD S1  S2   S3   S4  BILL line

**************************************************************************
*								         *
* 		COIN SELECT TABLE OFFSETS				 *
*								         *
**************************************************************************
*
*	IF "CHUTES" VALUE CHANGES.....EXTRA WORDS MUST BE PUT HERE
*
; WBD ST
CS_LMULT	EQU	0
CS_CMULT	EQU	CS_LMULT+WORD_SIZE
CS_RMULT	EQU	CS_CMULT+WORD_SIZE
CS_XMULT	EQU	CS_RMULT+WORD_SIZE
CS_DBV	        equ	CS_XMULT+WORD_SIZE
CS_UCRED        equ	CS_DBV+WORD_SIZE
CS_UBON		EQU	CS_UCRED+WORD_SIZE
CS_UMIN		EQU	CS_UBON+WORD_SIZE
CS_STRT	        EQU	CS_UMIN+WORD_SIZE     
CS_CONT	        EQU	CS_STRT+WORD_SIZE     
CS_CDIV		EQU	CS_CONT+WORD_SIZE
CS_FRAC		EQU	CS_CDIV+WORD_SIZE
CS_COPY		EQU	CS_FRAC+WORD_SIZE	;UP TO HERE IS COPIED AS ADJUSTMENTS
CS_LVAL		EQU	CS_COPY
CS_CVAL		EQU	CS_LVAL+WORD_SIZE
CS_RVAL		EQU	CS_CVAL+WORD_SIZE
CS_XVAL		EQU	CS_RVAL+WORD_SIZE
CS_DBVVAL	equ	CS_XVAL+WORD_SIZE
CS_LMES	        equ	CS_DBVVAL+WORD_SIZE
CS_RMES		EQU	CS_LMES+LONG_SIZE
CS_PROMPT	EQU	CS_RMES+LONG_SIZE
CS_TITLE	EQU	CS_PROMPT+LONG_SIZE
CS_LIST		EQU	CS_TITLE+LONG_SIZE
CS_PICK		EQU	CS_LIST+LONG_SIZE	;WHICH LINE TO ADD TO 2 TO START...1 TO
CS_SLOTS	EQU	CS_PICK+WORD_SIZE	;TEXT DESCRIBING COIN SLOTS
CS_SIZE		EQU	CS_SLOTS+LONG_SIZE
; WBD END
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

*
*  HOCKEY SWITCH ASSIGNMENT
*
*******************************************************
*
* SW1    Function
*
*   1    OFF=Dipswitch Coinage      ON = CMOS Coinage
*
* 2-4    COINAGE OPTIONS
*
* 5-6    COUNTRY OPTIONS
*
*   7    COUNTER/TOTALIZER
*
*   8    Unused
*
*******************************************************
*
* SW2    Function
*
*   1    OFF=No Bill Validator      ON = Bill Validator installed
*
*   2    OFF=Attract Mode Sounds    ON = No Attract Mode Sounds
*
*   3    OFF=Powerup Test ON        ON = Powerup Test Off
*
*   4    OFF=Normal Heads           ON = Big Heads
*
*   5    OFF=4 Players              ON = 2 Players
*
*   6    Unused
*
*   7    OFF=Normal Mode            ON = Video Freeze (undocumented)
*
*   8    OFF=Normal Mode            ON = Test Mode
*
*
*******************************************************

DPUSECMOS	EQU	0001H		;USE CMOS MASK

DPCOINAGE	EQU	00EH		;COINAGE MASK
SR_DPCOINAGE	EQU	1		;shift count to Right justify COINAGE bits

DPCOUNTRY	EQU	030H		;COUNTRY MASK
SR_DPCOUNTRY	EQU	4		;shift count to Right justify COUNTRY bits


DPCOUNTER	EQU	040H		;NUMBER OF COIN COUNTERS

DPVALIDATOR	EQU	 100h		;DOLLAR BILL VALIDATOR INSTALLED
DPATTSNDS   EQU    200h    ;Attract Mode Sounds on/off
DPPWRUP     EQU    400h    ;Powerup test on/off
DPHEADS     EQU    800h    ;type of heads (Normal/Big)
DPPLAYERS	EQU	1000H		;NUMBER OF HARDWARE PLAYERS 
SR_DPPLAYERS	EQU	12		;shift count to Right justify PLAYERS bits
DPUNUSED1	EQU	2000H		;UNUSED BIT 2
DPFREEZE	   EQU	4000H		;FREEZE SWITCH
DPTEST		EQU	8000H		;TEST SWITCH


;DPPOWER		EQU	64		;Tournament mode
;DPPOWER_B	EQU	6
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
AUD_DBV		equ	5	; total coins in fifth chute  
AUDSCOIN	EQU	6	;TOTAL SERVICE CREDITS
AUDPAIDC	EQU	7	;TOTAL PAID CREDITS
*
FRST_C		EQU	AUDLCOIN	;FOR CLEARING COINS
LAST_C		EQU	AUDPAIDC
*
AUD_STARTS		equ	10
AUD_PERIOD1		equ	11	;keep
AUD_PERIOD2		equ	12	;these
AUD_PERIOD3		equ	13	;four
AUD_PERIODOT		equ	14	;together
AUD_PL_STARTS		equ	15
AUD_PL_PERIODS		equ	16
AUD_PLAYTIME		equ	17
AUD_UPTIME		equ	18
AUD_ONTIME		equ	19
AUD_1_TIME		equ	20
AUD_2_TIME		equ	21
AUD_3_TIME		equ	22
AUD_4_TIME		equ	23
AUD_INITIALS_ENTERED	equ	24
AUD_TIES		equ	25	;keep these
AUD_LEFT_WINS		equ	26	;three
AUD_RIGHT_WINS		equ	27	;together
AUD_CPU_WIN		equ	28
AUD_CPU_LOSS		equ	29
AUD_CPU_TIE		equ	30
AUD_GOALS		equ	31
AUD_ASSISTS		equ	32
AUD_LEFT_GOALS		equ	33
AUD_RIGHT_GOALS		equ	34
AUD_CPU_TEAM_GOALS	equ	35
AUD_CPU_PLAYER_GOALS	equ	36
AUD_HUMAN_GOALS		equ	37
AUD_UNCREDITED_GOALS	equ	38
AUD_GOALIE_SAVES	equ	39
AUD_GOALIE_MISSES	equ	40
AUD_ON_FIRE		equ	41
AUD_ON_FIRE_GOALS	equ	42
AUD_BRUINS		equ	43	;keep
AUD_SABRES		equ	44	;all
AUD_WHALERS		equ	45	;of
AUD_CANADIENS		equ	46	;these
AUD_SENATORS		equ	47	;26
AUD_PENGUINS		equ	48	;teams
AUD_AVALANCHE		equ	49	;in
AUD_PANTHERS		equ	50	;the
AUD_DEVILS		equ	51	;order
AUD_ISLANDERS		equ	52	;of
AUD_RANGERS		equ	53	;their
AUD_FLYERS		equ	54	;team
AUD_LIGHTNING		equ	55	;numbers
AUD_CAPITALS		equ	56	;found
AUD_BLACKHAWKS		equ	57	;in
AUD_STARS		equ	58	;the
AUD_RED_WINGS		equ	59	;file
AUD_BLUES		equ	60	;'hhnhl.h'
AUD_MAPLE_LEAFS		equ	61	;or
AUD_JETS		equ	62	;else
AUD_MIGHTY_DUCKS	equ	63	;things
AUD_FLAMES		equ	64	;will
AUD_OILERS		equ	65	;not
AUD_KINGS		equ	66	;work
AUD_SHARKS		equ	67	;correctly
AUD_CANUCKS		equ	68	; - mdp
AUD_ALL_BEATEN		equ	69
AUD_RANDOM_PICKED	equ	70
AUD_SECRET_CHAR		equ	71
AUD_SLAMS		equ	72
AUD_AUTO		equ	73
AUD_DOG			equ	74
AUD_WARNING		equ	75
AUD_BADTRAP		equ	76
AUD_SECURITY		equ	77
AUD_FREEP		equ	78	;free periods given

LAST_AUDIT		equ	78	;last audit for audit clear info
FRSTGAUD		equ	AUD_STARTS
LASTGAUD		equ	LAST_AUDIT


;c.AUD_STARTS			7
;c.AUD_PERIOD1			8	;keep
;c.AUD_PERIOD2			9	;these
;c.AUD_PERIOD3			10	;four
;c.AUD_PERIODOT			11	;together
;c.AUD_PL_STARTS			12
;
;c.AUD_PL_PERIODS			14
;c.AUD_PLAYTIME			15
;c.AUD_UPTIME			16
;.AUD_ONTIME			17
;c.AUD_1_TIME			18
;c.AUD_2_TIME			19
;c.AUD_3_TIME			20
;c.AUD_4_TIME			21
;c.AUD_INITIALS_ENTERED		22
;
;c.AUD_TIES			25	;keep these
;c.AUD_LEFT_WINS			26	;three
;c.AUD_RIGHT_WINS			27	;together
;c.AUD_CPU_WIN			28
;c.AUD_CPU_LOSS			29
;c.AUD_CPU_TIE			30
;c.AUD_GOALS			34
;c.AUD_ASSISTS			35
;c.AUD_LEFT_GOALS			23
;c.AUD_RIGHT_GOALS		24
;c.AUD_CPU_TEAM_GOALS		31
;c.AUD_CPU_PLAYER_GOALS		32
;c.AUD_HUMAN_GOALS			33
;c.AUD_UNCREDITED_GOALS		36
;c.AUD_GOALIE_SAVES
;c.AUD_GOALIE_MISSES
;
;c.AUD_ON_FIRE			37
;c.AUD_ON_FIRE_GOALS		38
;
;c.AUD_BRUINS			39	;keep
;c.AUD_SABRES			40	;all
;c.AUD_WHALERS			41	;of
;c.AUD_CANADIENS			42	;these
;c.AUD_SENATORS			43	;26
;c.AUD_PENGUINS			44	;teams
;c.AUD_AVALANCHE			45	;in
;c.AUD_PANTHERS			46	;the
;c.AUD_DEVILS			47	;order
;c.AUD_ISLANDERS			48	;of
;c.AUD_RANGERS			49	;their
;c.AUD_FLYERS			50	;team
;c.AUD_LIGHTNING			51	;numbers
;c.AUD_CAPITALS			52	;found
;c.AUD_BLACKHAWKS			53	;in
;c.AUD_STARS			54	;the
;c.AUD_RED_WINGS			55	;file
;c.AUD_BLUES			56	;'hhnhl.h'
;c.AUD_MAPLE_LEAFS			57	;or
;c.AUD_JETS			58	;else
;c.AUD_MIGHTY_DUCKS		59	;things
;c.AUD_FLAMES			50	;will
;c.AUD_OILERS			61	;not
;c.AUD_KINGS			62	;work
;c.AUD_SHARKS			63	;correctly
;c.AUD_CANUCKS			64	; - mdp
;
;c.AUD_ALL_BEATEN			65
;c.AUD_RANDOM_PICKED		66
;cAUD_SECRET_CHAR			67
;
;c.AUD_SLAMS			68
;c.AUD_AUTO			69
;c.AUD_DOG				70
;c.AUD_WARNING			71
;c.AUD_BADTRAP			72
;cAUD_SECURITY			73
;


;AUDSTART	EQU	7	;PLAYER STARTS
;;
;AUD1TIME	EQU	8	;TIME 1 PLAYER ONLY
;AUD2TIME	EQU	9	;TIME 2 PLAYER SIMULTANEOUS
;AUD3TIME	EQU	10	;TIME 3 PLAYER SIMULTANEOUS
;AUD4TIME	EQU	11	;TIME 4 PLAYER SIMULTANEOUS
;AUDPTIME	EQU	12	;TOTAL PLAY TIME
;;
;AUDSLAMS	EQU	13	;NUMBER OF TIMES BEEN SLAMMED
;AUDUPTIME	EQU	14	;GAME TOTAL UPTIME ( POWER ON TIME )
;AUDCONTOFFER	EQU	15	;GAME CONTINUES OFFERED		;check this
;AUDCONTTAKEN	EQU	16	;GAME CONTINUES TAKEN
;AUDONTIME	EQU	17	;GAME POWER ON TIME
;AUDAUTO		EQU	18	;AUTO CYCLE PASSES
;AUDDOGGY	EQU	19	;WATCHDOG HITS
;AUDWARNING	EQU	20	;SOFTWARE WARNING
;AUDBADTRAP	EQU	21	;SOFTWARE TRAPS
;AUDSECURITY	EQU	22	;SECURITY BREECH COUNT		;check this
*
;LAST_AUDIT	EQU	43	;LAST AUDIT FOR AUDIT CLEAR INFO
*
;FRSTGAUD	EQU	AUDSTART
;LASTGAUD	EQU	LAST_AUDIT

*
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
ADJTOURMODE     EQU	14    ; Tournament Mode
ADJCHALMODE     EQU	15	   ; Challenge Mode
ADJFULLGAME     EQU	16	;Credits for Full Game
*
*  The following 2 items are not used and are available
*
ADJNUMEXTRA     EQU	17	;MAXIMUM NUMBER EXTRA MEN/COIN
ADJATMSND       EQU	18	;ATTRACT MODE SOUND
*
*
ADJMAXC         EQU	19	;MAXIMUM CREDITS
ADJFREPL        EQU	20	;NON-ZERO MEANS FREE PLAY
ADJVIRGIN       EQU	21	;NON-ZERO MEANS 1ST 8 OF COIN ADJUST BLOCK UNTOUCHED
ADJPAYOT	EQU	22	;NON-ZERO MEANS FULL 3 MINUTE OVERTIME PERIOD
ADJ1ST6         EQU	23	;NON-ZERO MEANS 1ST 6 UNTOUCHED.
ADJNOCPAG       EQU	24
ADJBUYIN        EQU	25
ADJHSON		    EQU	26	; IF = 0, DON'T ALLOW HIGH SCORE DISPLAY
ADJTMRSPD	    EQU	27	; Game Timer Speed
ADJVOLUME	    EQU	28	; Current sound board volume
ADJMINVOL	    EQU	29	; Minimum volume allowed
ADJDBVMULT      equ  30
ADJTOTALIZER    equ  31
ADJLTOTMULT     equ  32
ADJCTOTMULT     equ  33
ADJRTOTMULT     equ  34
ADJXTOTMULT     equ  35
ADJBTOTMULT     equ  36
LAST_ADJUST     EQU	36

team_bruins		.set	1		;00000000000000000000000001
team_sabres		.set	2		;00000000000000000000000010
team_whalers		.set	3		;00000000000000000000000100
team_canadiens		.set	4		;00000000000000000000001000
team_senators		.set	5		;00000000000000000000010000
team_penguins		.set	6		;00000000000000000000100000
team_avalanche		.set	7		;00000000000000000001000000
team_panthers		.set	8		;00000000000000000010000000
team_devils		.set	9		;00000000000000000100000000
team_islanders		.set	10		;00000000000000001000000000
team_rangers		.set	11		;00000000000000010000000000
team_flyers		.set	12		;00000000000000100000000000
team_lightning		.set	13		;00000000000001000000000000
team_capitals		.set	14		;00000000000010000000000000
team_blackhawks		.set	15		;00000000000100000000000000
team_stars		.set	16		;00000000001000000000000000
team_red_wings		.set	17		;00000000010000000000000000
team_blues		.set	18		;00000000100000000000000000
team_maple_leafs	.set	19		;00000001000000000000000000
team_jets		.set	20		;00000010000000000000000000
team_mighty_ducks	.set	21		;00000100000000000000000000
team_flames		.set	22		;00001000000000000000000000
team_oilers		.set	23		;00010000000000000000000000
team_kings		.set	24		;00100000000000000000000000
team_sharks		.set	25		;01000000000000000000000000
team_canucks		.set	26		;10000000000000000000000000

team_special_01		.set	27
team_special_02		.set	28
team_special_03		.set	29
team_special_04		.set	30
team_special_05		.set	31
team_special_06		.set	32
team_special_07		.set	33
team_special_08		.set	34
team_special_09		.set	35
team_special_10		.set	36
team_special_11		.set	37
team_special_12		.set	38
team_special_13		.set	39
team_special_14		.set	40
team_special_15		.set	41
team_special_16		.set	42
team_special_17		.set	43
team_special_18		.set	44
team_special_19		.set	45
team_special_20		.set	46
team_special_21		.set	47
team_special_22		.set	48
team_special_23		.set	49
team_special_24		.set	50
team_special_25		.set	51
team_special_26		.set	52
team_special_27		.set	53
team_special_28		.set	54
team_special_29		.set	55
team_special_30		.set	56
team_special_31		.set	57
team_special_32		.set	58
team_special_33		.set	59
team_special_34		.set	60
team_special_35		.set	61
team_special_36		.set	62
team_special_37		.set	63
team_special_38		.set	64
team_special_39		.set	65
team_special_40		.set	66
team_special_41		.set	67
team_special_42		.set	68
team_special_43		.set	69
team_special_44		.set	70
team_special_45		.set	71
team_special_46		.set	72
team_special_47		.set	73
team_special_48		.set	74
team_special_49		.set	75
team_special_50		.set	76
team_special_51		.set	77
team_special_52		.set	78
team_special_53		.set	79
team_special_54		.set	80
team_special_55		.set	81
team_special_56		.set	82
team_special_57		.set	83
team_special_58		.set	84
team_special_59		.set	85
team_special_60		.set	86
team_special_61		.set	87
team_special_62		.set	88
team_special_63		.set	89
team_special_64		.set	90
team_special_65		.set	91

first_special_team	.equ	team_special_01
last_special_team	.equ	team_special_65
num_special_teams	.equ	(team_special_65 - team_special_01 +1)

s_mark_messier		.set	  1
s_petr_nedved		.set	  2
s_john_maclean		.set	  3
s_stephane_richer	.set	  4
s_joe_juneau		.set	  5
s_peter_bondra		.set	  6
s_eric_lindros		.set	  7
s_rod_brindamour	.set	  8
s_kirk_muller		.set	  9
s_steve_thomas		.set	 10
s_gord_murphy		.set	 11
s_scott_mellanby	.set	 12
s_brian_bradley		.set	 13
s_petr_klima		.set	 14
s_jaromir_jagr		.set	 15
s_luc_robitaille	.set	 16
s_joe_sakic		.set	 17
s_wendel_clark		.set	 18
s_pat_lafontaine	.set	 19
s_alexander_mogilny	.set	 20
s_vincent_damphousse	.set	 21
s_mark_recchi		.set	 22
s_ray_bourque		.set	 23
s_cam_neely		.set	 24
s_andrew_cassels	.set	 25
s_geoff_sanderson	.set	 26
s_alexandre_daigle	.set	 27
s_alexei_yashin		.set	 28
s_sergei_fedorov	.set	 29
s_steve_yzerman		.set	 30
s_doug_gilmour		.set	 31
s_dave_andreychuk	.set	 32
s_brett_hull		.set	 33
s_brendan_shanahan	.set	 34
s_bernie_nicholls	.set	 35
s_chris_chelios		.set	 36
s_teemu_selanne		.set	 37
s_keith_tkachuk		.set	 38
s_mike_modano		.set	 39
s_kevin_hatcher		.set	 40
s_pavel_bure		.set	 41
s_trevor_linden		.set	 42
s_theoren_fleury	.set	 43
s_robert_reichel	.set	 44
s_sandis_ozolinsh	.set	 45
s_ulf_dahlen		.set	 46
s_wayne_gretzky		.set	 47
s_jari_kurri		.set	 48
s_paul_kariya		.set	 49
s_tom_kurvers		.set	 50
s_igor_kravchuk		.set	 51
s_shayne_corson		.set	 52
s_mike_richter		.set	 53
s_martin_brodeur	.set	 54
s_jim_carey		.set	 55
s_ron_hextall		.set	 56
s_jamie_mclennan	.set	 57
s_john_vanbiesbrouck	.set	 58
s_darren_puppa		.set	 59
s_ken_wregget		.set	 60
s_stephane_fiset	.set	 61
s_dominik_hasek		.set	 62
s_patrick_roy		.set	 63
s_blaine_lacher		.set	 64
s_sean_burke		.set	 65
s_don_beaupre		.set	 66
s_mike_vernon		.set	 67
s_felix_potvin		.set	 68
s_curtis_joseph		.set	 69
s_ed_belfour		.set	 70
s_tim_chevaldae		.set	 71
s_andy_moog		.set	 72
s_kirk_mclean		.set	 73
s_trevor_kidd		.set	 74
s_arturs_irbe		.set	 75
s_kelly_hrudey		.set	 76
s_guy_hebert		.set	 77
s_bill_ranford		.set	 78
s_jeremy_roenick	.set	 79
s_bob_corkum		.set	 80
s_adam_oates		.set	 81
s_derek_plante		.set	 82
s_phil_housley		.set	 83
s_denis_savard		.set	 84
s_dave_gagner		.set	 85
s_paul_coffey		.set	 86
s_dino_ciccarelli	.set	 87
s_doug_weight		.set	 88
s_jason_arnott		.set	 89
s_jesse_belanger	.set	 90
s_rick_tocchet		.set	 91
s_pierre_turgeon	.set	 92
s_claude_lemieux	.set	 93
s_scott_stevens		.set	 94
s_ray_ferraro		.set	 95
s_brian_leetch		.set	 96
s_radek_bonk		.set	 97
s_mikael_renberg	.set	 98
s_eric_desjardins	.set	 99
s_mario_lemieux		.set	100
s_owen_nolan		.set	101
s_sergei_makarov	.set	102
s_esa_tikkanen		.set	103
s_roman_hamrlik		.set	104
s_mats_sundin		.set	105
s_sylvain_cote		.set	106
s_alexei_zhamnov	.set	107
s_dale_hawerchuk	.set	108

s_doug_bodger		.set	109
s_derek_king		.set	110
s_joe_nieuwendyk	.set	111

s_martin_martinez	.set	112
s_jack_haeger		.set	113
s_bill_dabelstein	.set	114
s_josh_tsui		.set	115
s_mark_penacho		.set	116
s_maryann_rohn		.set	117
s_carlos_pesina		.set	118
s_jim_tianis		.set	119
s_mike_waldron		.set	120
s_mike_vinikour		.set	121
s_warren_davis		.set	122
s_ed_boon		.set	123
s_john_tobias		.set	124
s_steve_beran		.set	125
s_pat_cox		.set	126
s_jim_gentile		.set	127
s_sal_divita		.set	128
s_nik_ehrlik		.set	129
s_eddie_ferrier		.set	130
s_eugene_geer		.set	131
s_tony_goskie		.set	132
s_jennifer_hedrick	.set	133
s_jon_hey		.set	134
s_mike_lynch		.set	135
s_dave_michicich	.set	136
s_john_carlton		.set	137
s_brian_eddie		.set	138
s_mark_loffredo		.set	139
s_cary_mednick		.set	140
s_eugene_jarvis		.set	141
s_mike_ossian		.set	142
s_joan_faux		.set	143
s_luis_mangubat		.set	144
s_jason_skiles		.set	145
s_al_lasko		.set	146
s_jim_rohn		.set	147
s_ray_gay		.set	148
;s_george_petro		.set	149
s_ted_barber		.set	150
s_dave_zabodoul		.set	151
s_christa_woss		.set	152
s_paul_dussault		.set	153
s_jack_h_haeger		.set	154
s_jennifer_fedesna	.set	155
s_bridgitte_fedesna	.set	156
s_mark_turmell		.set	157
s_art_tianis		.set	158
s_jim_greene		.set	159
s_sheridan_oursler	.set	160
s_ed_keenan		.set	161
s_matt_booty		.set	162
s_matt_davis		.set	163
s_steve_correll		.set	164
s_john_lowes		.set	165
s_glenn_shipp		.set	166
s_tony_metke		.set	167
s_ray_macika		.set	168
s_ken_williams		.set	169
s_jake_simpson		.set	170
s_john_newcomer		.set	171
s_xion_cooper		.set	172
s_chris_bobrowski	.set	173
s_andy_lycke		.set	174
s_ted_valvanis		.set	175
s_ross_shaffer		.set	176
s_jon_casey		.set	177
s_kevin_stevens		.set	178
s_zarley_zalapski	.set	179
s_craig_janney		.set	180
s_gordie_howe		.set	181
s_matt_cooney		.set	182
s_kevin_daley		.set	183
s_sidney_strong		.set	184
s_pat_foley		.set	185
s_rebecca_scott		.set	186
s_heather_beach		.set	187
s_goalie_haeger		.set	188
s_goalie_hedrick	.set	189
s_jay_cohen		.set	190
s_jeff_johnson		.set	191
s_jeff_peters		.set	192
s_dan_thompson		.set	193
s_evil_haeger		.set	194
s_tommy_soderstrom	.set	195
s_chris_osgood		.set	196
s_grant_fuhr		.set	197
s_board_crash_10	.equ	0
s_board_crash_4		.equ	1
s_board_crash_5		.equ	2
s_board_crash_8		.equ	3
s_board_crash_9		.equ	4
;s_board_crash_j1	.equ	5
;s_skates_upended	.equ	6
;s_goalie_mitt_1		.equ	7
;s_goalie_mitt_2		.equ	8
s_goalie_mitt_5		.equ	9
;s_goalie_mitt_7		.equ	10
s_goalie_pad_1		.equ	11
s_goalie_pad_2		.equ	12
;s_goalie_skate_1	.equ	13
;s_goalie_skate_2	.equ	14
;s_goalie_skate_3	.equ	15
;s_goalie_skate_4	.equ	16
;s_goalie_skate_5	.equ	17
;s_goalie_skate_6	.equ	18
s_goalie_stick_1	.equ	19
;s_goalie_stick_2	.equ	20
;s_goalie_stick_3	.equ	21
s_goalie_stick_4	.equ	22
;s_hard_skate_stop_1	.equ	23
s_hard_skate_stop_2	.equ	24
s_hard_skate_stop_3	.equ	25
;s_hard_skate_stop_4	.equ	26
s_hard_skate_stop_5	.equ	27
;s_ice_crunch_1		.equ	28
s_ice_crunch_2		.equ	29
s_loud_board_1		.equ	30
s_loud_board_2		.equ	31
s_loud_board_3		.equ	32
;s_long_skate_1		.equ	33
;s_long_skate_2		.equ	34
;s_long_skate_3		.equ	35
;s_long_skate_4		.equ	36
;s_long_skate_5		.equ	37
;s_long_skate_6		.equ	38
;s_long_skate_7		.equ	39
;s_puck_to_board_score_1	.equ	40
s_puck_drop_1		.equ	41
s_puck_drop_2		.equ	42
s_puck_drop_3		.equ	43
s_puck_to_goalie_mask_1	.equ	44
s_puck_hit_board_1	.equ	45
s_puck_hit_board_2	.equ	46
s_puck_hit_board_3	.equ	47
s_puck_drop_in_net	.equ	48
;s_puck_in_net_1		.equ	49
;s_puck_in_net_2		.equ	50
;s_puck_in_net_3		.equ	51
;s_puck_in_net_4		.equ	52
;s_puck_in_net_5		.equ	53
s_puck_in_net_6		.equ	54
s_plastic_impact_1	.equ	55
s_plastic_impact_2	.equ	56
s_plastic_board_hit_1	.equ	57
s_plastic_board_hit_2	.equ	58
s_puck_to_metal_0	.equ	59
s_puck_to_metal_1	.equ	60
s_puck_to_metal_2	.equ	61
;s_puck_pass_1		.equ	62
;s_puck_pass_2		.equ	63
;s_puck_pass_3		.equ	64
;s_puck_pass_4		.equ	65
;s_puck_pass_5		.equ	66
;s_puck_ricochet_1	.equ	67
;s_puck_ricochet_2	.equ	68
s_puck_ricochet_3	.equ	69
;s_puck_slide_2		.equ	70
;s_puck_slide_3		.equ	71
;s_puck_slide_4		.equ	72
;s_puck_slide_6		.equ	73
;s_skate_1		.equ	74
s_skate_2		.equ	75
;s_skate_3		.equ	76
;s_skate_4		.equ	77
;s_skate_5		.equ	78
;s_skate_6		.equ	79
;s_skate_7		.equ	80
s_skate_8		.equ	81
s_skate_9		.equ	82
s_skate_10		.equ	83
s_skate_11		.equ	84
;s_skate_12		.equ	85
;s_skate_13		.equ	86
;s_skate_14		.equ	87
;s_skate_15		.equ	88
;s_skate_16		.equ	89
;s_skate_17		.equ	90
s_skate_18		.equ	91
s_skate_19		.equ	92
s_skate_20		.equ	93
s_skate_21		.equ	94
s_skate_22		.equ	95
;s_skate_23		.equ	96
s_skate_24		.equ	97
s_skate_25		.equ	98
s_skate_26		.equ	99
;s_skate_27		.equ	100
;s_skate_28		.equ	101
s_skate_29		.equ	102
;s_skate_30		.equ	103
;s_skate_31		.equ	104
;s_skate_32		.equ	105
s_skate_33		.equ	106
;s_skate_34		.equ	107
s_skate_35		.equ	108
s_skate_36		.equ	109
s_skate_37		.equ	110
;s_skate_up_foreground	.equ	111
;s_run_on_skates_1	.equ	112
;s_run_on_skates_2	.equ	113
s_slapshot_1		.equ	114
;s_slapshot_2		.equ	115
;s_slapshot_3		.equ	116
;s_slapshot_4		.equ	117
s_slapshot_6		.equ	118
s_slapshot_7		.equ	119
s_stick_sound_1		.equ	120
;s_stick_to_pad_1	.equ	121
;s_stick_bounce_1	.equ	122
;s_stick_slide_1		.equ	123
s_skate_stop_or_turn_1	.equ	124
;s_skate_stop_or_turn_2	.equ	125
;s_skate_stop_or_turn_3	.equ	126
s_skate_stop_or_turn_4	.equ	127
;s_skate_stop_or_turn_5	.equ	128
;s_skate_stop_or_turn_6	.equ	129
;s_long_puck_slide_5	.equ	130
s_long_puck_slide_6	.equ	131
s_long_puck_slide_7	.equ	132
score_net_1		.equ	133
score_net_11		.equ	134
score_net_10b		.equ	135
;body_crash_1		.equ	136
;body_crash_2		.equ	137
;body_crash_3		.equ	138
;body_crash_5		.equ	139
body_fall_1		.equ	140
body_fall_2		.equ	141
body_fall_3		.equ	142
body_fall_4		.equ	143
body_fall_5		.equ	144
;body_fall_6		.equ	145
body_fall_7		.equ	146
body_fall_8		.equ	147
body_fall_9		.equ	148
body_fall_11		.equ	149
body_fall_12		.equ	150
body_fall_13		.equ	151
;body_fall_14		.equ	152
body_fall_15		.equ	153
body_slam_1		.equ	154
body_slam_2		.equ	155
body_slam_3		.equ	156
body_slam_4		.equ	157
body_slam_5		.equ	158
body_slam_6		.equ	159
body_slam_7		.equ	160
body_slam_7b		.equ	161
body_slam_8		.equ	162
body_slam_9		.equ	163
body_slam_10		.equ	164
;body_slam_11		.equ	165
body_slam_vince7	.equ	166
body_slam_vince8	.equ	167
;Organ_dah_DAH_dah_F	.equ	168
;Organ_dah_DAH_dah_FS	.equ	169
;Organ_dah_DAH_dah_G	.equ	170
;Organ_charge_C		.equ	171
;Organ_line_G_		.equ	172
;Organ_line_Ab		.equ	173
;Organ_line_A_		.equ	174
;Organ_charge_A		.equ	175
;Organ_charge_Bb	.equ	176
;Organ_charge_B		.equ	177
;player_grunt_bill_10	.equ	178
;player_grunt_bill_16	.equ	179
;player_grunt_bill_18	.equ	180
;player_grunt_bill_19	.equ	181
;player_grunt_bill_21	.equ	182
;player_grunt_bill_23	.equ	183
;player_grunt_bill_24	.equ	184
;player_grunt_bill_26	.equ	185
player_grunt_carlos_05	.equ	186
player_grunt_carlos_10	.equ	187
player_grunt_carlos_11	.equ	188
player_grunt_carlos_12	.equ	189
player_grunt_carlos_16	.equ	190
player_grunt_carlos_21	.equ	191
player_grunt_carlos_23	.equ	192
player_grunt_carlos_25	.equ	193
player_grunt_carlos_26	.equ	194
player_grunt_carlos_29	.equ	195
player_grunt_carlos_31	.equ	196
player_grunt_carlos_32	.equ	197
player_grunt_jackh_01	.equ	198
player_grunt_jackh_03	.equ	199
player_grunt_jackh_06	.equ	200
player_grunt_jackh_08	.equ	201
player_grunt_jackh_13	.equ	202
player_grunt_jackh_17	.equ	203
player_grunt_jackh_34	.equ	204
player_grunt_jackh_45	.equ	205
player_grunt_jackh_47	.equ	206
player_grunt_markp_01	.equ	207
player_grunt_markp_02	.equ	208
player_grunt_markp_07	.equ	209
player_grunt_marty_05	.equ	210
player_grunt_marty_07	.equ	211
player_grunt_marty_10	.equ	212
player_grunt_marty_11	.equ	213
player_grunt_marty_14	.equ	214
player_grunt_marty_15	.equ	215
player_grunt_marty_20	.equ	216
player_grunt_marty_33	.equ	217
player_grunt_marty_34	.equ	218
player_grunt_marty_40	.equ	219
player_grunt_marty_45	.equ	220
player_grunt_marty_49	.equ	221
player_grunt_marty_51	.equ	222
player_grunt_marty_53	.equ	223
player_grunt_marty_62	.equ	224
crowd_noise_1		.equ	225
crowd_noise_2		.equ	226
crowd_noise_3		.equ	227
crowd_noise_4		.equ	228
crowd_noise_5		.equ	229
crowd_noise_6		.equ	230
crowd_noise_7		.equ	231
crowd_noise_8		.equ	232
crowd_noise_9		.equ	233
crowd_noise_10		.equ	234
crowd_noise_11		.equ	235
crowd_noise_12		.equ	236
crowd_noise_13		.equ	237
air_horn_blast		.equ	238
S_ORGAN_DAH_F		.EQU	239
S_ORGAN_DAH_FSHARP	.EQU	240
S_ORGAN_DAH_G		.EQU	241
S_ORGAN_CHARGE_C	.EQU	242
S_ORGAN_LINE_G 		.EQU	243
S_ORGAN_LINE_AFLAT	.EQU	244
S_ORGAN_LINE_A 		.EQU	245
S_ORGAN_CHARGE_A	.EQU	246
S_ORGAN_CHARGE_BFLAT	.EQU	247
S_ORGAN_CHARGE_B	.EQU	248
s_crowd_high_noise_1	.equ	249
s_crowd_high_noise_2	.equ	250
s_crowd_high_noise_3	.equ	251
s_crowd_high_noise_4	.equ	252
s_crowd_high_noise_5	.equ	253
s_crowd_high_noise_6	.equ	254
s_crowd_high_noise_7	.equ	255
s_crowd_high_noise_8	.equ	256
s_crowd_high_noise_9	.equ	257
s_crowd_high_noise_10	.equ	258
s_crowd_high_noise_11	.equ	259
s_crowd_high_noise_12	.equ	260
s_crowd_high_noise_13	.equ	261
s_tune_down_knees	.equ	262
S_CURSOR_MOVE		.EQU	263
S_CURSOR_SELECT		.EQU	264
S_CURSOR_SWAP		.EQU	265
S_SIDE_TOGGLE		.EQU	266
S_TIMER_TICK		.EQU	267
S_CREDIT		.EQU	268
S_PERIOD_PAID		.EQU	269
S_FULL_GAME		.EQU	270
S_TOPTEN_PLAYER		.EQU	271
s_whistle		.equ	272
s_time_running_out	.equ	273
S_CROWD_1		.EQU	274
;S_CROWD_2		.EQU	275
S_CROWD_3		.EQU	276
S_CROWD_4		.EQU	277
S_CROWD_5		.EQU	278
;S_CROWD_6		.EQU	279
S_CROWD_7		.EQU	280
;S_CROWD_8		.EQU	281
S_CROWD_9		.EQU	282
S_CROWD_10		.EQU	283
S_EXPLO_4		.EQU	284
S_SLIDE_SWISH_1		.EQU	285
s_scoring_horn		.equ	286
S_PUCK_POINT		.EQU	287
S_STAT_HILITE		.EQU	288
S_P1_POWERUP		.EQU	289
S_P2_POWERUP		.EQU	290
S_P3_POWERUP		.EQU	291
S_P4_POWERUP		.EQU	292
S_POWERUP_REPORT	.EQU	293
S_FLASHBULB		.EQU	294
S_HELMETS_STARTUP	.EQU	295
S_NET_IGNITE		.EQU	296
s_break_glass		.equ	297
s_whoosh_sound_1	.equ	298
s_whoosh_sound_2	.equ	299
s_whoosh_sound_3	.equ	300
s_flame_shoot_sound	.equ	301
S_SPECIAL_CHAR		.EQU	302
s_steal_miss		.equ	303
s_steal_made		.equ	304
S_NET_EXPLO		.equ	305
