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

