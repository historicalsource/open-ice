 	.MLIB	"HHMACS.LIB"
	.FILE	"HHDTST.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

**************************************************************************
*								         *
* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		 *
* 		       ALL RIGHTS RESERVED.				 *
*								         *
**************************************************************************

	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhdtst.e"
	.include	"hhadj.g"
	.include	"hhram.g"
	.include	"hhcmos.g"
	.include	"hh.g"
	.include	"hhmenu.g"
	.include	"hhdutl.g"
	.include	"hhd.g"
	.include	"hhmisc.g"
	.include	"hhproc.g"

; end of include files

**************************************************************************
*								         *
* 	DEFS AND REFS							 *
*								         *
**************************************************************************

	.DEF	SWITCHTEST, CONV_PLOT, DIPTEST, COLORBAR


*DIAGNOSTIC SOUND EQUATES
CMOS_ERROR_SND	.EQU	5EH
CPU_ERROR_SND	.EQU	5EH
DIP_SND		.EQU	83H
SWITCH_SND	.EQU	82H
**************************************************************************
*								         *
* 			SOME RAM FOR YOU				 *
*								         *
**************************************************************************
	.BSS	SWSET1,32		; FOR SWITCH TEST
	.BSS	SWSET2,32
	.BSS	SWPREV1,32
	.BSS	SWPREV2,32

	.BSS	DIPVAL,16
	.BSS	DIP1ST,16

	.BSS	FORCEDIP,16		; FOR FORCING THE USE OF THE DIP
	.bss	xxxx,16		;fill space to 32 bits
	.BSS	CERRORS,32
	.BSS	CPASSES,32

	.if XUNIT=0
	.bss	_snd_status,32
	.bss	_b6_save,32		; Temporary register fer me
	.bss	_temporary,32		; Another temp fer me
	.bss	_snd_diag_code,16	; Temporary storage for sound diag code
	.bss	_snd_chip_count,16	; Temporary register fer me
	.bss	_pic_raw,128		; Stuff fer the PIC
	.bss	_pic_temp,64
	.endif

**************************************************************************
*								         *
* 	USEFUL MACROS							 *
*								         *
**************************************************************************
BUT_MAC	.MACRO  X,Y,RADIUS,COLOR,MASK,SHIFT,EXTEND
	.WORD	:X:
	.WORD	:Y:
	.WORD	:RADIUS:
	.LONG	:COLOR:
	.LONG	:MASK:
	.WORD	:SHIFT:
	.WORD	:EXTEND:
        .ENDM

STR_MAC	.MACRO  X,Y,STRING,COLOR,DIR
	.WORD	:X:
	.WORD	:Y:
	.LONG	:STRING:
	.WORD	:COLOR:
	.WORD	:DIR:
        .ENDM

SW_MAC	.MACRO  X,Y,STRING,COLOR,DIR,MASK
	.WORD	:X:
	.WORD	:Y:
	.LONG	:STRING:
	.WORD	:COLOR:
	.WORD	:DIR:
	.LONG	:MASK:
        .ENDM

VECMAC	.MACRO	COLOR,X1,Y1,X2,Y2
	.WORD	:COLOR:
	.WORD	:X1:
	.WORD	:Y1:
	.WORD	:X2:
	.WORD	:Y2:
	.ENDM

DOTMAC	.MACRO	COLOR,X,Y
	.WORD	:COLOR:
	.WORD	:X:
	.WORD	:Y:
	.ENDM

RECTMAC	.MACRO	COLOR,X,Y,W,H
	.WORD	:W:
	.WORD	:H:
	.WORD	:X:
	.WORD	:Y:
	.WORD	:COLOR:
	.ENDM

CHIPMAC	.MACRO	NUM,X1,Y1,X2,Y2,X3,Y3,STRING,DIR,X4,Y4,STUFFED
	.WORD	:NUM:
	.WORD	:X1:
	.WORD	:Y1:
	.WORD	:X2:
	.WORD	:Y2:
	.WORD	:X3:
	.WORD	:Y3:
	.LONG	:STRING:
	.WORD	:DIR:
	.WORD	:X4:
	.WORD	:Y4:
	.WORD	:STUFFED:
	.ENDM


CMNUM		EQU	0
CMLOC		EQU	CMNUM+16
CMXLOC		EQU	CMLOC
CMYLOC		EQU	CMLOC+16
CMSIZE		EQU	CMLOC+32
CMXSIZE		EQU	CMSIZE
CMYSIZE		EQU	CMSIZE+16
CMOFFSET	EQU	CMSIZE+32
CMSTRING	EQU	CMOFFSET+32
CMDIR		EQU	CMSTRING+32
CMPINLOC	EQU	CMDIR+16
CMSTUFFED	EQU	CMPINLOC+32
CMEND		EQU	CMSTUFFED+16


**************************************************************************
*								         *
* RAM_CHIP: MACRO DEFINES A RAM CHIP RECORD.				 *
* 									 *
*       CHIP_NO    -- CHIP NUMBER					 *
*       WIDTH      -- CHIP CELL SIZE IN BITS (MUST BE > 0)		 *
*       INTERLEAVE -- DISTANCE BETWEEN ADJACENT CELLS ON CHIP (IN BITS)	 *
*       START_ADDR -- ADDRESS OF FIRST CELL ON CHIP			 *
*       END_ADDR   -- ADDRESS OF LAST CELL ON CHIP			 *
*								         *
**************************************************************************

RAM_CHIP .MACRO TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR

         .WORD  :WIDTH:
         .WORD  :INTERLEAVE:
         .WORD  :CHIP_NO:
         .LONG  :START_ADDR:
         .LONG  :END_ADDR:
	.LONG	:TAB_LINK:
         .ENDM

RAM_WDTH EQU 	000H                ; OFFSETS INTO RAM CHIP RECORD
RAM_ITLV EQU	010H
RAM_NMBR EQU 	020H
RAM_SADR EQU 	030H
RAM_EADR EQU 	050H
RAM_LINK	EQU	070H
RAM_SIZE EQU 	090H

ROM_CKSM	EQU	000H
ROM_WDTH	EQU	010H                ; OFFSETS INTO ROM CHIP RECORD
ROM_ITLV 	EQU	020H
ROM_NMBR 	EQU	030H
ROM_SADR 	EQU	040H
ROM_EADR 	EQU	060H
ROM_LINK	EQU	080H
ROM_SIZE 	EQU	0A0H

**************************************************************************
*								         *
* ROM_CHIP: MACRO DEFINES A ROM CHIP RECORD.				 *
* 									 *
*       CHIP_NO    -- CHIP NUMBER					 *
*       WIDTH      -- CHIP CELL SIZE IN BITS (MUST BE > 0)		 *
*       INTERLEAVE -- DISTANCE BETWEEN ADJACENT CELLS ON CHIP (IN BITS)	 *
*       START_ADDR -- ADDRESS OF FIRST CELL ON CHIP			 *
*       END_ADDR   -- ADDRESS OF LAST CELL ON CHIP			 *
*       CHECK_SUM  -- DATAIO CHECK SUM FOR CHIP				 *
*								         *
**************************************************************************

ROM_CHIP .MACRO TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR, CHECK_SUM

	.WORD	:CHECK_SUM:
        .WORD  :WIDTH:
        .WORD  :INTERLEAVE:
        .WORD  :CHIP_NO:
        .LONG  :START_ADDR:
        .LONG  :END_ADDR:
	.LONG	:TAB_LINK:

         .ENDM


RANDOM_SEED EQU 5A5A5A5Ah              ; RAM TESTS: PSEUDO-RANDOM SEQUENCE
ZERO_EXTEND EQU 1Fh                    ; PARAMETERS
SIGN_EXTEND EQU 20h

	.TEXT
        .EVEN

FREAD_SW1_CNS:
	move	@SWITCH,a0
	move	@COINS,a14
	sll	16,a14
	movy	a14,a0
	FRET	b6

FREAD_SW2_DIP:
	move	@SWITCH2,a10
	move	@DIPSWITCH,a14
	sll	16,a14
	movy	a14,a10
	FRET	b6

**************************************************************************
*								         *
* 	POWERCMOS							 *
* 									 *
* 	CHECK THE CMOS AND DO A LOT OF OTHER STUFF -- SHOW THE		 *
* 	POWER UP MESSAGES						 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

POWERCMOS:
	DINT
	MOVI	SYSCINIT,A1
	MOVE	A1,@SYSCOPY

	.if	XUNIT=1
	MOVE	A1,@SYSCTRL0,L		; XUNIT
	srl	8,a1			; XUNIT
	move	a1,@SYSCTRL1,L		; XUNIT
	.else
	move	a1,@SYSCTRL,W
	.endif

	CLR	A14
	MOVE	A14,@DMAGOREG,L
	MOVE	A14,@DMAGOREG,L

*INITIALIZE IO REGISTERS
	MOVI	INITDATA,B0
	MOVI	IDATALEN,B7

	.if	XUNIT=1
	MOVI	VESYNC,B2
	BLMOVE	1,1			;TRANSFER I/O REGS
	movi	DPYSTRT0,a14	; XUNIT
	move	a14,@DPYST,L	; XUNIT
	.else
	movi	HESYNC,b2
	srl	5,b7
_t1
	move	*b0+,*b2+,L
	dsjs	b7,_t1
	movi	0fffch,a14
	move	a14,@DPYSTRT,W
	.endif

	CLR	A13			; USED TO DECIDE WHETHER PAUSE OR NOT
	FCALL	INITCOLR,B5		; FIX UP THE COLORS
	FCALL	DSCRCLR,B6		; MAKE SURE OF SCREEN
	MOVI	ROM_NAME,A0
	FCALL	STRINGCENTER,B6		; GET WIDTH OF STRING
	ADDI	[30,0],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	CALLA	CMOS_VAL		; CHECKSUM AUDITS/ADJUSTMENTS
	JREQ	CMOSOK

	CALLA	FAC_SET			; BUMMER, BABY!  RESET TO FACTORY
	CALLA	BLASTMESS
	CALLA	CLR_AUD
;	MOVI    ALL_TAB,A8           	; ALWAYS CLEAR OUT TODAYS TABLE
;        CALLA   INIT_TB
;	MOVI	TOD_TAB,A8
;	CALLA	INIT_TB
;        CALLA   INIT_HSR             	; RE-SET THE HIGH SCORE RESET COUNTER

	MOVK	1,A13			; FLAG ERROR
	CALLA	CMOS_VAL		; TRY AGAIN
	JREQ	CMOSB1
	MOVI	CMOS_BAD,A0
	FCALL	STRINGCENTER,B6
	ADDI	[50,0],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	MOVI	CMOS_UNFAC,A0
	FCALL	STRINGCENTER,B6
	ADDI	[65,0],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	JRUC	CMOS1
CMOSB1
	MOVI	CMOS_FACRES,A0
	FCALL	STRINGCENTER,B6
	ADDI	[50,0],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	JRUC	CMOS1
CMOSOK
	MOVI	CMOS_OK,A0
	FCALL	STRINGCENTER,B6
	ADDI	[50,0],A1
	CLR	A2
	MOVI	COLOR_GREEN,A3
	FCALL	STRING,B6

CMOS1
	MOVI	AUDONTIME,A0
	CLR	A1
	CALLA	STORE_AUDIT
;mdp	MOVI	TOD_TAB,A8
;mdp	CALLA	INIT_TB			; LATER, ON TODAY'S TABLE
;mdp	MOVI	TOD_TAB,A8		; OK, VALIDATE IT
;mdp	CLR	A2			; FOR RECURSION
;mdp	CALLA	VAL_TAB
;mdp	JRNC	CTAGO
;mdp	MOVK	1,A13			; FLAG ERROR
;mdp	MOVI	CMOS_TBAD,A0
;mdp	FCALL	STRINGCENTER,B6
;mdp	ADDI	[77,0],A1
;mdp	CLR	A2
;mdp	MOVI	COLOR_RED,A3
;mdp	FCALL	STRING,B6
;mdpCTAGO
;mdp	MOVI	ALL_TAB,A8
;mdp	CALLA	VAL_TAB			; VALIDATE THE ALLTIME TABLE
;mdp	JRNC	CTA1
;mdp	MOVK	1,A13			; FLAG ERROR
;mdp	MOVI	CMOS_ABAD,A0
;mdp	FCALL	STRINGCENTER,B6
;mdp	ADDI	[89,0],A1
;mdp	CLR	A2
;mdp	MOVI	COLOR_RED,A3
;mdp	FCALL	STRING,B6
;mdp	JRUC	CMOS2
;mdpCTA1
;mdp	CALLA	CLEAR_HSCOLORS		; WIPE OUT ALL THE COLORATION
;mdp	MOVE	A2,A2
;mdp	JRNZ	CTA2			; IT GOT INITIALIZED
;mdp	CALLA	GET_HSC			; GET HIGHSCORE COUNTER
;mdp	JRNZ	CMOS2			; BR = NOT TIME YET
;mdp	MOVI	ADJHSRES,A0		; GET ADJUSTED VALUE
;mdp	CALLA	GET_ADJ
;mdp	JRZ	CMOS2			; TURNED OFF, NOTHING TO DO
;mdp
;mdp	MOVI	ALL_TAB,A8
;mdp	CALLA	INIT_TB			; LATER ON ALLTIME TABLE
CTA2
	MOVI	CMOS_ALL,A0
	FCALL	STRINGCENTER,B6
	ADDI	[90,0],A1
	CLR	A2
	MOVI	COLOR_GREEN,A3
	FCALL	STRING,B6
;mdp	CALLA	INIT_HSR		; RESET THE HIGHSCORE COUNTER
;
;	BY HERE, THE CMOS SHOULD BE FIXED UP AS GOOD AS POSSIBLE -- NOTE
;	THAT IF CMOS IS BUSTED, THE GUY IS FUCKED FOR COINAGE
;
;	WITH SOME THOUGHT THAT MIGHT BE FIXABLE
;
CMOS2
	CALLR	READ_DIP
	ANDI	DPUSECMOS,A0
	JRNZ	CMOS3		 	; BR = USING CMOS COINAGE

*LOAD COINAGE FROM DIPSWITCH
	MOVI	CMOS_DIP,A0
	FCALL	STRINGCENTER,B6
	ADDI	[110,0],A1
	CLR	A2
	MOVI	COLOR_WHITE,A3
	FCALL	STRING,B6

	CALLR	READ_DIP
	MOVE	A0,A2
	ANDI	DPCOUNTRY,A0
	SRL	3,A0
	ADDI	DIPCOINTAB,A0
	MOVE	*A0,A1,L		; POINTER TO RIGHT COIN TABLE
	ANDI	DPCOINAGE,A2
	CMPI	DPCOINAGE,A2		; CHECK FOR FREEPLAY
	JRZ	CMOS21
	SLL	2,A2
	ADD	A2,A1
	MOVE	*A1,A1,W		; WHICH COIN TABLE TO USE
	MOVI	ADJPRICE,A0		; MASTER PRICING
	CALLA	PUT_ADJ			; STUFF IT IN CMOS
	MOVI	ADJFREPL,A0
	CLR	A1			; MAKE SURE NO FREEPLAY
	CALLA	PUT_ADJ
CMOS20
	MOVI	ADJ1ST6,A0		;MAKE THEM UNTOUCHED PLEASE
	MOVK	1,A1
	CALLA	PUT_ADJ

	CALLA	GET_CSPT
	CALLA	SET_COIN_ADJ		; SET THE ADJUSTMENTS UP IN CMOS

	CALLR	READ_DIP		;SET UP CREDITS TO START/CONTINUE
	MOVE	A0,A2
	ANDI	DPCREDITS,A2
	SRL	1,A2
	ADDI	DIPCREDTAB,A2
	MOVB	*A2,A1
	ADDK	8,A2
	MOVI	ADJCSTRT,A0
	CALLA	PUT_ADJ
	MOVB	*A2,A1
	MOVI	ADJCCONT,A0
	CALLA	PUT_ADJ
	CALLA   F_ADC_S			;CHECKSUM THE ADJUSTMENTS
	JRUC	CMOS4

CMOS21
	MOVI	ADJFREPL,A0
	MOVK	1,A1			; FREEPLAY, DUDE!
	CALLA	PUT_ADJ
	JRUC	CMOS20
CMOS3
;
;	USING CMOS HERE
;
	MOVI	CMOS_CMOS,A0
	FCALL	STRINGCENTER,B6
	ADDI	[110,0],A1
	CLR	A2
	MOVI	COLOR_WHITE,A3
	FCALL	STRING,B6
CMOS4
;	CALLR	PLOTCOINAGE		; PLOT SOME COINAGE
	FCALL	FREAD_SW1_CNS,B6		; READ SWITCH & COINS
	NOT	A0
	ANDI	00080000H,A0
	JRZ	CMOSRET
	MOVI	CMOS_TILT,A0
	FCALL	STRINGCENTER,B6
	ADDI	[205,0],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	MOVK	1,A13			; FLAG ERROR
CMOSRET
	MOVE	A13,A13
	JRZ	CTMP0
	MOVI	CMOS_ERROR_SND,A0
;	MOVE	A0,@SOUND,W
	MOVI	CMOS_WAIT,A0
	FCALL	STRINGCENTER,B6
	ADDI	[230,0],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	FCALL	FREAD_SW1_CNS,B6		;XUNIT  HANGOUT FOR A WHILE
	ANDI	00243030H,A0
	MOVE	A0,@SWSET1,L
CTMP1
	FCALL	FREAD_SW1_CNS,B6		; XUNIT GOTTA SEE IF TIME TO LEAVE
	MOVE	@SWSET1,A1,L
	ANDI	00243030H,A0
	CMP	A0,A1
	JREQ	CTMP1
	JRUC	CTMP2
CTMP0
	PAUSE	200000H,B6
CTMP2
	JAUC	PCMOSRET


	.IF GERMAN
CMOS_FACRES
	.STRING	"CMOS FEHLER -- FABRIKDATENEINSTELLUNG",0
	.EVEN
CMOS_WAIT
	.STRING	"SPIELFORTSETZUNG MIT BELIEBIGEM KNOPF",0
	.EVEN
CMOS_BAD
	.STRING	"CMOS RAM U49 FEHLER",0
	.EVEN


	.ELSE
CMOS_FACRES
	.STRING	"CMOS INVALID -- FACTORY SETTINGS RESTORED",0
	.EVEN
CMOS_WAIT
	.STRING	"ERRORS DETECTED -- ANY BUTTON TO CONTINUE",0
	.EVEN
CMOS_BAD
	.STRING	"CMOS CHIP U49 BAD",0
	.EVEN


	.ENDIF

CMOS_TILT
	.STRING	"WARNING -- SLAM SWITCH CLOSED",0
	.EVEN

CMOS_DIP
	.STRING	"USING DIPSWITCH COINAGE",0
	.EVEN

CMOS_CMOS
	.STRING	"USING CMOS COINAGE",0
	.EVEN

CMOS_UNFAC
	.STRING	"UNABLE TO RESTORE FACTORY SETTINGS",0
	.EVEN

CMOS_OK
	.STRING	"CMOS OK",0
	.EVEN

CMOS_ALL
	.STRING	"ALL TIME HIGH SCORES RESET",0
	.EVEN

CMOS_ABAD
	.STRING	"UNABLE TO RESET ALLTIME HIGHSCORE TABLE",0
	.EVEN
CMOS_TBAD
	.STRING	"UNABLE TO RESET DAILY HIGHSCORE TABLE",0
	.EVEN

**************************************************************************
*								         *
* 	PLOTCOINAGE							 *
* 									 *
* 	PLOT OUT THE CURRENT COINAGE ON THE SCREEN			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
****PLOTCOINAGE:
****	.IF	PRINTER
****	RETS
****	.ELSE
****	MOVI	ADJFREPL,A0
****	CALLA	GET_ADJ
****	JRNZ	PCFREE
****PC1
****	MOVI	ADJPRICE,A0
****	CALLA	GET_ADJ			; GET THE CURRENT PRICING
****        CALLA   GET_CSPT
****        MOVE    *A6(CS_LIST),A7,L
****        JRZ	PCNOHEAD		; NO HEADER, BELIEVE IT OR NOT
****	MOVI	[130,0],A8		; BASE ADDRESS FOR STRING
****PCNEXTHEAD
****        MOVE    *A7+,A0,L            	; PICKUP THE NEXT POINTER
****	JRZ	PCNOHEAD
****
****	FCALL	STRINGCENTER,B6
****	ADD	A8,A1
****	CLR	A2
****	MOVI	COLOR_YELLOW,A3
****	FCALL	STRING,B6
****	ADDI	[12,0],A8		; MOVE DOWN A LINE
****
****	JRUC	PCNEXTHEAD
****	JRUC	PCNOHEAD
****PCFREE
****	MOVI	DUCOIN7,A0
****	FCALL	STRINGCENTER,B6
****	ADDI	[130,0],A1
****	CLR	A2
****	MOVI	COLOR_YELLOW,A3
****	FCALL	STRING,B6
****PCNOHEAD
****	RETS
****	.ENDIF

**************************************************************************
*								         *
* 									 *
* 	CPU TESTING ROUTINES						 *
* 									 *
*								         *
**************************************************************************

**************************************************************************
*								         *
* 	BURNIN								 *
* 									 *
* 	FACTORY BURNIN TEST -- EXITS BY RESETING THE GAME		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING 						 *
* 									 *
* 	CALL								 *
* 		JAUC							 *
*								         *
**************************************************************************

BURNIN:
	DINT
	MOVI	AUDAUTO,A0		;ZERO OUT BURNIN AUDIT
	CALLA	KILL_AUD
BURNLOOP
	FCALL	CPUTEST,SP
BURNSP:
	SETF	16,1,0
	SETF	32,1,1
	MOVI	STCKST,SP,L		;RESTORE THE STACK PTR
	MOVI	SYSCINIT,A0		;RE-INITIALIZE SYSTEM CONTROL
	MOVE	A0,@SYSCOPY		;KEEP A COPY IN RAM

	.if	XUNIT=1
	MOVE	A0,@SYSCTRL0,L		; XUNIT
	srl	8,a0			; XUNIT
	MOVE	A0,@SYSCTRL1,L		; XUNIT
	.else
	move	a0,@SYSCTRL,W
	.endif

	MOVI	AUDAUTO,A0
	CALLA	AUD1			;ANOTHER ONE WORKED
	JRUC	BURNLOOP

**************************************************************************
*								         *
* 	DIAGCPUTEST							 *
* 									 *
* 	DIAGNOSTIC CALL FOR THE CPU TEST				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		JUMPS TO *EXEC_LP* AFTER SETTING EVERYTHING UP		 *
* 									 *
* 	CALL								 *
* 		JAUC							 *
*								         *
**************************************************************************

DIAGCPUTEST:
	DINT
	FCALL	CPUTEST,SP
DIAGSP:
	SETF	16,1,0			; WORD NO SIGN EXTEND
	SETF	32,1,1			; LONG WORD
	MOVI	STCKST,SP,L
	CALLA	CLSCRACH
	MOVI	SYSCINIT,A0
	MOVE	A0,@SYSCOPY,W

	.if	XUNIT=1
	MOVE	A0,@SYSCTRL0,L		; XUNIT
	srl	8,a0			; XUNIT
	MOVE	A0,@SYSCTRL1,L		; XUNIT
	.else
	move	a0,@SYSCTRL,W
	.endif

	CALLA	MAIN_INIT

	CALLA	COLOR_START		;FIRE UP THE COLORS

	EINT				; ENABLE INTERRUPTS AND WE'RE OFF
	DISPON				; ENABLE THE DISPLAY SYSTEM
	CREATE	PID_DIAG,CPU_RET
	MOVI	INDIAG,A0
	MOVE	A0,@GAME_STATE,W
	JAUC	EXEC_LP

**************************************************************************
*								         *
* 	POWERCPUTEST							 *
* 									 *
* 	CHECK OUT THE CPU ON POWER ON					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		JUMPS TO *PONTEST*					 *
* 									 *
* 	CALL								 *
* 		JAUC							 *
*								         *
**************************************************************************

POWERCPUTEST:
	DINT
	MOVE	@DIPSWITCH,A0,L		; CHECK FOR POWER ON BYPASS
	NOT	A0
	ANDI	2000H,A0
	JANZ	PONTEST
	FCALL	CPUTEST,SP
	JAUC	PONTEST


	.if XUNIT=1
**************************************************************************
*								         *
* 	CPUTEST								 *
* 									 *
* 	THE ACTUAL CPU TEST STUFF					 *
* 									 *
* 	ENTRY								 *
* 		SP	RETURN ADDRESS					 *
* 									 *
* 	EXIT								 *
* 		WHO KNOWS						 *
* 									 *
* 	CALL								 *
* 		FCALL	CPUTEST,SP					 *
*								         *
**************************************************************************
CPUT_X	.EQU	25	;TEXT X POSITION
CPUT_Y1	.EQU	128	;TEXT ROW 1 Y POSITION
CPUT_Y2	.EQU	140	;TEXT ROW 2 Y POSITION
CPUT_Y3	.EQU	152	;TEXT ROW 3 Y POSITION
CPUT_CLR .EQU	[CPUT_Y1,CPUT_X]	;CLEAR START
CPUT_CLRS .EQU	[CPUT_Y3-CPUT_Y1+15,200-CPUT_X]

CPUTEST:	
	MOVB	A0,@WDOG_BONE		;HERE DOGGY DOGGY
	FCALL	INITCOLR,B5		;HEY! IT LOOKS BETTER THIS WAY
	FCALL	DSCRCLR,B6		;BLOW THE SCREEN OR IT LOOKS TOO UGLY

	CLR	B0
	MOVI	VRAMCHIPS,A14		;VERIFY BIT MAP
	FCALL	RAMCHECK,B5

;	ENABLE VIDEO PALETTE MAP ACCESS

	MOVI	PALCHIPS,A14		;VERIFY OBJECT PALETTE RAM
	FCALL	RAMCHECK,B5
	MOVE	B0,A12
	
;	DISABLE VIDEO PALETTE MAP ACCESS

	FCALL	INITCOLR,B5		;RELOAD THE COLORS
	FCALL	DSCRCLR,B6

	FCALL	CPUDRAW,B5		;SHOW THE CPU
	MOVI	CPU,A10			;WE GOT THIS FAR, CPU MUST BE OK
	MOVI	1,A11
	FCALL	CHIPOUT,B5

	MOVI	VRAMTAB,A9
	FCALL	CHIPTABLE,B5		;PLOT OUT THE CHIP TABLE

	MOVE	A12,A12
	JRZ	PSRAMCK
PBADRAM
	MOVI	RAMBADMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	JRUC	PCPUBAD

PSRAMCK
	MOVI	SRAMCHECK,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	CLR	B0
	MOVI	SRAMCHIPS,A14			;VERIFY SCRATCH RAMS
	FCALL	RAMCHECK,B5
	MOVE	B0,A12
	
	MOVI	CPUT_CLR,A0
	MOVI	CPUT_CLRS,A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6

	MOVE	A12,A12
	JRNZ	PBADRAM

PROMCK
	MOVI	ROMCMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	MOVI	CPUEXIT1_MESS,A0
	MOVI	[CPUT_Y2,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	MOVI	CPUEXIT2_MESS,A0
	MOVI	[CPUT_Y3,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	CLR	B0			;KEEP THE STATS HERE

	MOVI	PROMCHIPS,A14
	FCALL	ROMCHECK,B5
	JRNZ	PROMABORT

	MOVI	IROMCHIPS,A14
	FCALL	ROMCHECK,B5
PROMABORT
	MOVE	B0,A12
	MOVI	CPUT_CLR,A0
	MOVI	CPUT_CLRS,A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6

	MOVE	A12,A12
	JRNZ	PBADROM

*WE CHECK ON THE DMA HERE
PDMACK
	MOVI	DMACMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	FCALL	DMACHECK,B5		;CHECK THE DMA
	MOVI	DMA,A10
	MOVE	A0,A11
	MOVE	A0,A12
	INC	A11			;GREEN/RED
	FCALL	CHIPOUT,B5

	MOVI	CPUT_CLR,A0
	MOVI	CPUT_CLRS,A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6

	MOVE	A12,A12
	JRZ	PCPUGOOD
	MOVI	DMABADMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	JRUC	PCPUBAD

PBADROM
	MOVI	CPUT_CLR,A0
	MOVI	CPUT_CLRS,A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6
	MOVI	ROMBADMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6

PCPUBAD
	MOVI	CPUPAUSE,A0
	MOVI	[CPUT_Y2,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6

PCPUWAIT
        MOVB	B14,@WDOG_BONE

	MOVI	CPU_ERROR_SND,A0
;	MOVE	A0,@SOUND,W

	MOVE	A13,B5
	PAUSE	10000,B6
	FCALL	FREAD_SW1_CNS,B6		; XUNIT
	ANDI	00243030H,A0
	MOVE	A0,@SWSET1,L
	MOVI	-1,B0			; ASSUME DON'T TIMEOUT
	CMPI	DIAGSP,SP
	JRZ	PCPUTMP1
	CMPI	BURNSP,SP
	JRZ	PCPUTMP1
	MOVI	200000H,B0
PCPUTMP1
        MOVB	B14,@WDOG_BONE
	MOVE	B0,B0
	JRN	PCPUNOTIMEOUT
	DEC	B0
	JRZ	PCPURET			; TIMEOUT HERE
PCPUNOTIMEOUT
	FCALL	FREAD_SW1_CNS,B6		; XUNIT GOTTA SEE IF TIME TO LEAVE
	MOVE	@SWSET1,A1,L
	ANDI	00243030H,A0
	CMP	A0,A1
	JRNZ	PCPURET
	JRUC	PCPUTMP1
PCPUGOOD
	CLR	A0
	JRUC	PCPUREALRET
PCPURET
	MOVK	1,A0
PCPUREALRET
	MOVE	A0,A0
	FRET	SP

	.IF GERMAN

DMACMESS
	.STRING	"UE13 PRUEFEN",0
	.EVEN
DMABADMESS
	.STRING	"UE13 DEFEKT",0
	.EVEN

ROMCMESS
	.STRING	"ROMS PRUEFEN",0
	.EVEN
ROMBADMESS
	.STRING	"ROM DEFEKT",0
	.EVEN

RAMBADMESS
	.STRING	"RAM DEFEKT",0
	.EVEN

CPUGOOD
	.STRING	"CPU-PLATINE OK",0
	.EVEN

CPUWAIT1
CPUPAUSE
	.STRING	"BELIEBIGEN KNOPF DRUECKEN",0
	.EVEN

CPUEXIT1_MESS
	.STRING "HALTE START",0
	.EVEN
CPUEXIT2_MESS
	.STRING "ZUM VERLASSEN.",0
	.EVEN

	.ELSE

DMACMESS
	.STRING	"CHECKING CUSTOM",0
	.EVEN
DMABADMESS
	.STRING	"CUSTOM CHIP UE13 BAD",0
	.EVEN

ROMCMESS
	.STRING	"CHECKING ROMS",0
	.EVEN
ROMBADMESS
	.STRING	"ROM CHIPS BAD",0
	.EVEN

RAMBADMESS
	.STRING	"RAM CHIPS BAD",0
	.EVEN

CPUGOOD
	.STRING	"CPU BOARD OK",0
	.EVEN

CPUWAIT1
CPUPAUSE
	.STRING	"PRESS ANY BUTTON",0
	.EVEN

CPUEXIT1_MESS
	.STRING "HOLD START BUTTON",0
	.EVEN
CPUEXIT2_MESS
	.STRING "TO EXIT.",0
	.EVEN

	.ENDIF

	.else

***********************************************
* PICCHECK - Power up test for the PIC MicroController
* Checks basic communications with the PIC chip
*
PICCHECK
	movi	1fh,a0			;Command code 0xf
	move	a0,@PIC_COMMAND,W
	movi	0fh,a0
	move	a0,@PIC_COMMAND,W
	movi	100000,a0		;Wait for Acknowledge
pic_loop
	move	a1,@WDOG_BONE,W
;	move	@_watchdog_addr,a1,L
;	move	a1,*a1,W
;	move	@_soundirq_addr,a1,L
;	move	*a1,a1,W
	move	@SOUNDIRQ,a1,W
	btst	12,a1
	jrz	_got_pic_ack		;BR = got acknowledge
	dsjs	a0,pic_loop
	movk	1,a0
	jruc	_piccheck_done
_got_pic_ack
	move	@PIC_DATA,a0,W		;Read the data
	movi	010h,a1
	move	a1,@PIC_COMMAND,W	;Tell PIC we took data
	movi	100000,a1
_pic_nack_loop
;	move	@_watchdog_addr,a2,L
;	move	a2,*a2,W
	move	a2,@WDOG_BONE,W
;	move	@_soundirq_addr,a2,L
;	move	*a2,a2,W
	move	@SOUNDIRQ,a2,W
	btst	12,a2
	jrnz	_got_pic_nack
	dsjs	a1,_pic_nack_loop
	movk	1,a0
	jruc	_piccheck_done
_got_pic_nack
	andi	0fh,a0
	cmpi	0fh,a0
	jrz	_pic_ok
	movk	1,a0
	jruc	_piccheck_done
_pic_ok
	clr	a0
_piccheck_done
	FRET	b5

***************************************************
* SNDCHECK - Sound Subsystem Check during CPUTEST
*
SNDCHECK
	move	b6,@_b6_save,L
;	move	@_coin_counter_addr,a0,L
	movi	030h,a1
;	move	a1,*a0,W
	move	a1,@COIN_COUNTERS,W
	movi	8,a1
	dsjs	a1,$
	movi	020h,a1
	move	a1,*a0,W
	movi	1000000,a1
dsp_loop1
;	move	@_watchdog_addr,a0,L
;	move	a0,*a0,W
	move	a0,@WDOG_BONE,W
;	move	@_soundirq_addr,a0,L
;	move	*a0,a2,W
	move	@SOUNDIRQ,a2,W
	btst	B_SDAV,a2
	jrz	dsp_lp1_exit
	dsjs	a1,dsp_loop1
	movi	DSP,a10
	movk	1,a0
	move	a0,a11
	inc	a11
	FCALL	CHIPOUT,b5
	movk	1,a0
	jruc	dspcheck_done
dsp_lp1_exit
;	move	@_sound_addr,a0,L
;	move	*a0,a0,W
	move	@SOUND,a0,W
	andi	0ffh,a0
	cmpi	079h,a0
	jrz	dsp_next_byte
	movi	DSP,a10
	movk	1,a0
	move	a0,a11
	inc	a11
	FCALL	CHIPOUT,b5
	movk	1,a0
	jruc	dspcheck_done
dsp_next_byte
	movi	10000000,a1
dsp_loop2
;	move	@_watchdog_addr,a0,L
;	move	a0,*a0,W
	move	a0,@WDOG_BONE,W
;	move	@_soundirq_addr,a0,L
;	move	*a0,a2,W
	move	@SOUNDIRQ,a2,W
	btst	B_SDAV,a2
	jrz	dsp_lp2_exit
	dsjs	a1,dsp_loop2
	movi	DSP,a10
	movk	1,a0
	move	a0,a11
	inc	a11
	FCALL	CHIPOUT,b5
	movk	1,a0
	jruc	dspcheck_done
dsp_lp2_exit
	movi	DSP,a10
	clr	a0
	move	a0,a11
	inc	a11
	FCALL	CHIPOUT,b5
;	move	@_sound_addr,a0,L
;	move	*a0,a0,W
	move	@SOUND,a0,W
	andi	0ffh,a0
	move	a0,a14
	clr	a0
	move	a0,a0
	jrz	dsp_ok
	movk	1,a0
	jruc	dspcheck_done
dsp_ok
	clr	a0
	move	a0,@_snd_status,L
	subi	2,a14
	move	a14,@_snd_diag_code,W
	clr	a14
	move	a14,@_snd_chip_count,W
	movi	SROMTAB,a12,L
snd_romok_loop
	move	*a12+,a10,L
	jrz	sndrom_done
	move	@_snd_chip_count,a14,W
	move	@_snd_diag_code,a11,W
	cmp	a11,a14
	jrnz	sndchip_ok
	movk	2,a11
	move	a11,@_snd_status,L
	jruc	snd_chip_out
sndchip_ok
	movk	1,a11
snd_chip_out
	addk	1,a14
	move	a14,@_snd_chip_count,W
	FCALL	CHIPOUT,b5
	move	@_snd_status,a11,L
	jrz	snd_romok_loop
	movk	1,a0
	jruc	dspcheck_done
sndrom_done
	movi	SNDRAMTAB,a12,L
snd_ramok_loop
	move	*a12+,a10,L
	jrz	sndram_done
	move	@_snd_diag_code,a14,W
	cmpi	8,a14
	jrnz	sndram_ok
	movk	2,a11
	move	a11,@_snd_status,L
	jruc	snd_ram_out
sndram_ok
	movk	1,a11
snd_ram_out
	FCALL	CHIPOUT,b5
	move	@_snd_status,a11,L
	jrz	snd_ramok_loop
	movk	1,a0
	jruc	dspcheck_done
sndram_done
	clr	a0
dspcheck_done
	movi	1000000,a1
dspcheck_wait_exit_loop
;	move	@_watchdog_addr,a2,L
;	move	a2,*a2,W
	move	a2,@WDOG_BONE,W
	dsjs	a1,dspcheck_wait_exit_loop
	move	@_b6_save,b6,L
	FRET	b6

**************************************************************************
*SPECIAL DIAGNOSTIC VERSION OF fudge_switches
*USE FCALL WITH B6 AS THE RETURN REGISTER WHEN CALLING.
*
fudge_switches_diag
	move	@SWITCH,a0,W		;GET BOTH SWITCH WORDS
;	move	@_switch_addr,a0,L
;	move	*a0,a0,W
;	move	@_coin_addr,a1,L
;	move	*a1,a1,W
	move	@COIN_COUNTERS,a1,W
	sll	16,a1
	or	a1,a0
	not	a0			;COMPLEMENT
	move	@SWITCH+20h,a1		;move action 5 buttons into low 32 bits
;	move	@_switch2_addr,a1,L
;	move	*a1,a1
	not	a1
;;;	andi	011b,a1
	andi	01111b,a1
	sll	4,a1
	or	a1,a0

	FRET	B6

**************************************************************************
*								         *
* 	CPUTEST								 *
* 									 *
* 	THE ACTUAL CPU TEST STUFF					 *
* 									 *
* 	ENTRY								 *
* 		SP	RETURN ADDRESS					 *
* 									 *
* 	EXIT								 *
* 		WHO KNOWS						 *
* 									 *
* 	CALL								 *
* 		FCALL	CPUTEST,SP					 *
*								         *
**************************************************************************
;CPUT_X	.EQU	25	;TEXT X POSITION
;CPUT_Y1	.EQU	128	;TEXT ROW 1 Y POSITION
;CPUT_Y2	.EQU	140	;TEXT ROW 2 Y POSITION
;CPUT_Y3	.EQU	152	;TEXT ROW 3 Y POSITION
;CPUT_CLRS .EQU	[CPUT_Y3-CPUT_Y1+15,200-CPUT_X]

CPUT_X	.EQU	180	;TEXT X POSITION
CPUT_Y1	.EQU	118	;TEXT ROW 1 Y POSITION
CPUT_Y2	.EQU	130	;TEXT ROW 2 Y POSITION
CPUT_Y3	.EQU	142	;TEXT ROW 3 Y POSITION
CPUT_CLRS .EQU	[CPUT_Y3-CPUT_Y1+10,389-CPUT_X]

CPUT_CLR .EQU	[CPUT_Y1,CPUT_X]	;CLEAR START

CPUTEST:
	move	a0,@WDOG_BONE		;Reset
;	move	@_watchdog_addr,a0,L
;	move	a0,*a0
	FCALL	INITCOLR,B5		;HEY! IT LOOKS BETTER THIS WAY
	FCALL	DSCRCLR,B6		;BLOW THE SCREEN OR IT LOOKS TOO UGLY

	CLR	B0

	movi	SYSCINIT,a13

	MOVE	A13,@SYSCTRL,W		;MAKE SURE WE'RE WRITING TO BIT MAP
	MOVI	VRAMCHIPS,A14		;VERIFY BIT MAP
	FCALL	RAMCHECK,B5

;	ENABLE VIDEO PALETTE MAP ACCESS



;	movi	PALENB,a13
	movi	SYSCINIT,a13
	andni	PALENB,a13

	MOVE	A13,@SYSCTRL,W
	MOVI	PALCHIPS,A14		;VERIFY OBJECT PALETTE RAM
	FCALL	RAMCHECK,B5
	MOVE	B0,A12
	
;	DISABLE VIDEO PALETTE MAP ACCESS


	movi	SYSCINIT,a13

	MOVE	A13,@SYSCTRL,W
	FCALL	INITCOLR,B5		;RELOAD THE COLORS
	FCALL	DSCRCLR,B6

	FCALL	CPUDRAW,B5		;SHOW THE CPU
	MOVI	CPU,A10			;WE GOT THIS FAR, CPU MUST BE OK
	MOVI	1,A11
	FCALL	CHIPOUT,B5

	MOVI	VRAMTAB,A9
	FCALL	CHIPTABLE,B5		;PLOT OUT THE CHIP TABLE

	MOVE	A12,A12
	JRZ	PSRAMCK
PBADRAM
	MOVI	RAMBADMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	JRUC	PCPUBAD

PSRAMCK
	MOVI	SRAMCHECK,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	CLR	B0
	MOVI	SRAMCHIPS,A14		;VERIFY SCRATCH RAMS
	FCALL	RAMCHECK,B5
	MOVE	B0,A12
;	move	sp,a1
;	movi	STCKST,sp		; Set up a temporary stack
;	calla	InitAddresses		; Reset the I/O Addresses
;	move	a1,sp
	
	MOVI	CPUT_CLR,A0
	MOVI	CPUT_CLRS,A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6

	MOVE	A12,A12
	JRNZ	PBADRAM

PROMCK
	MOVI	ROMCMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	MOVI	CPUEXIT1_MESS,A0
	MOVI	[CPUT_Y2,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	MOVI	CPUEXIT2_MESS,A0
	MOVI	[CPUT_Y3,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	CLR	B0			;KEEP THE STATS HERE

	MOVI	PROMCHIPS,A14
	FCALL	ROMCHECK,B5
;	JRNZ	PROMABORT

	MOVI	IROMCHIPS,A14
	FCALL	ROMCHECK,B5
;OUT FOR TEST	jrnz	PROMABORT
	movi	SYSCINIT,a14
	ori	0100h,a14
	move	a14,@SYSCTRL,W		; Image IROM bank 1
	movi	IROMCHIPS1,a14
	FCALL	ROMCHECK,b5
;OUT FOR TEST	jrnz	PROMABORT
	move	b0,a12
	movi	CPUT_CLR,a0
	movi	CPUT_CLRS,a1
	movi	COLOR_BLACK,a2
	FCALL	RECTANGLE,b6
	movi	SYSCINIT,a14
	move	a14,@SYSCTRL,W		; Back to IROM bank 0
	move	a12,a12
;OUT FOR TEST	jrnz	PBADROM
PROMABORT
	movi	SYSCINIT,a14
	move	a14,@SYSCTRL,W		; Back to IROM bank 0
	MOVE	B0,A12
	MOVI	CPUT_CLR,A0
	MOVI	CPUT_CLRS,A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6

	MOVE	A12,A12
;	JRNZ	PBADROM

*WE CHECK ON THE DMA HERE
PDMACK
	MOVI	DMACMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	FCALL	DMACHECK,B5		;CHECK THE DMA
	MOVI	DMA,A10
	MOVE	A0,A11
	MOVE	A0,A12
	INC	A11			;GREEN/RED
	FCALL	CHIPOUT,B5

	MOVI	CPUT_CLR,A0
	MOVI	CPUT_CLRS,A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6

	MOVE	A12,A12
	jrnz	PBADDMA
	movi	SNDCMESS,a0
	movi	[CPUT_Y1,CPUT_X],a1
	clr	a2
	movi	COLOR_YELLOW,a3
	FCALL	STRING,b6
	FCALL	SNDCHECK,b6
;	movi	DSP,a10
;	move	a0,a11
	move	a0,a12
;	inc	a11
;	FCALL	CHIPOUT,b5
	movi	CPUT_CLR,a0
	movi	CPUT_CLRS,a1
	movi	COLOR_BLACK,a2
	FCALL	RECTANGLE,b6
	move	a12,a12
	jrnz	PBADSND

	movi	PICCMESS,a0
	movi	[CPUT_Y1,CPUT_X],a1
	clr	a2
	movi	COLOR_YELLOW,a3
	FCALL	STRING,b6
	FCALL	PICCHECK,b5
	movi	PIC,a10
	move	a0,a11
	move	a0,a12
	inc	a11
	FCALL	CHIPOUT,b5
	movi	CPUT_CLR,a0
	movi	CPUT_CLRS,a1
	movi	COLOR_BLACK,a2
	FCALL	RECTANGLE,b6
	move	a12,a12
	JRZ	PCPUGOOD
	movi	PICBADMESS,a0
	movi	[CPUT_Y1,CPUT_X],a1
	clr	a2
	movi	COLOR_RED,a3
	FCALL	STRING,b6
	jruc	PCPUBAD
PBADSND
	movi	SNDBADMESS,a0
	movi	[CPUT_Y1,CPUT_X],a1
	clr	a2
	movi	COLOR_RED,a3
	FCALL	STRING,b6
	jruc	PCPUBAD
PBADDMA
	MOVI	DMABADMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	JRUC	PCPUBAD
PBADROM
	MOVI	CPUT_CLR,A0
	MOVI	CPUT_CLRS,A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6
	MOVI	ROMBADMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6

PCPUBAD
	MOVI	CPUPAUSE,A0
	MOVI	[CPUT_Y2,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6

PCPUWAIT
	move	a0,@WDOG_BONE		;Reset
;	move	@_watchdog_addr,a0,L
;	move	a0,*a0

;	.IF	TUNIT
;	MOVI	CPU_ERROR_SND,A0
;	MOVE	A0,@SOUND,W
;;	move	@_sound_addr,a3,L
;;	move	a0,*a3,W
;	.ELSE
	MOVI	0FD00H|CPU_ERROR_SND,A0
	MOVE	A0,@SOUND,W
;	move	@_sound_addr,a3,L
;	move	a0,*a3,W
	MOVI	0FF00H|CPU_ERROR_SND,A0
	MOVE	A0,@SOUND,W		; LET HIM HEAR IT
;	move	@_sound_addr,a3,L
;	move	a0,*a3,W
;	.ENDIF

	MOVE	A13,B5
	PAUSE	10000,B6
	FCALL	fudge_switches_diag,B6
	andi	BUTTONS|START_BITS,a0
	MOVE	A0,B1
	MOVI	-1,B0			; ASSUME DON'T TIMEOUT
	CMPI	DIAGSP,SP
	JRZ	PCPUTMP1
	CMPI	BURNSP,SP
	JRZ	PCPUTMP1
	MOVI	200000H,B0
PCPUTMP1
	move	a0,@WDOG_BONE		;Reset
;	move	@_watchdog_addr,a0,L
;	move	a0,*a0
	MOVE	B0,B0
	JRN	PCPUNOTIMEOUT
	DEC	B0
	JRZ	PCPURET			; TIMEOUT HERE
PCPUNOTIMEOUT
	FCALL	fudge_switches_diag,B6
	andi	BUTTONS|START_BITS,a0
	MOVE	B1,A1
	CMP	A0,A1
	JRNZ	PCPURET
	JRUC	PCPUTMP1
PCPUGOOD
	CLR	A0
	JRUC	PCPUREALRET
PCPURET
	MOVK	1,A0
PCPUREALRET
	MOVE	A0,A0
	FRET	SP

DMACMESS
	.STRING	"CHECKING CUSTOM",0
	.EVEN
DMABADMESS
;	.STRING	"CUSTOM CHIP UE13 BAD",0
	.STRING	"CUSTOM CHIP U33 BAD",0
	.EVEN

ROMCMESS
	.STRING	"CHECKING ROMS",0
	.EVEN
ROMBADMESS
	.STRING	"ROM CHIPS BAD",0
	.EVEN

RAMBADMESS
	.STRING	"RAM CHIPS BAD",0
	.EVEN

SNDCMESS
	.string	"CHECKING SOUND SECTION",0
	.even
SNDBADMESS
	.string	"SOUND SECTION BAD",0
	.even
PICCMESS
	.string	"CHECKING PIC CHIP",0
	.even
PICBADMESS
	.string	"PIC CHIP BAD",0
	.even

CPUGOOD
	.STRING	"CPU BOARD OK",0
	.EVEN

CPUPAUSE
	.STRING	"PRESS ANY BUTTON",0
	.EVEN

CPUEXIT1_MESS
	.STRING "HOLD START BUTTON",0
	.EVEN
CPUEXIT2_MESS
	.STRING "TO EXIT.",0
	.EVEN

	.endif

**************************************************************************
*								         *
* 	CPUDRAW								 *
* 									 *
* 	PLOT THE CPU BOARD AND DRAW ALL THE CHIPS			 *
* 									 *
* 	ENTRY								 *
* 		B5	RETURN ADDRESS					 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

CPUDRAW:
	MOVI	CPU_VECS,A9		; POINT AT VECTOR TABLE
CPUDLP1
	MOVE	*A9+,A2,W		; GET COLOR
	JRZ	CPUD1
	MOVE	*A9+,A0,L		; START POINT
	MOVE	*A9+,A1,L		; END POINT
	FCALL	HVLINE,B6
	JRUC	CPUDLP1
CPUD1
	MOVE	B5,A13
	FCALL	CHIPPLOT,B5		; PLOT ALL THE CHIPS
	MOVI	BOARDSTRING,A0
	MOVI	[25,11],A1
	CLR	A2
	MOVI	COLOR_WHITE,A3
	FCALL	STRING,B6
	MOVI	BOARDSTRING2,A0
	MOVI	[37,13],A1
	FCALL	STRING,B6
	MOVE	A13,B5
	FRET	B5

BOARDSTRING
	.STRING	"5770-12878-02",0
	.EVEN

BOARDSTRING2
	.STRING	"NBA JAM",0
	.EVEN

**************************************************************************
*								         *
* 	CHIPTABLE							 *
* 									 *
* 	UPDATE A LIST OF CHIPS, BASED ON THEIR VALUES IN A12		 *
* 									 *
* 	ENTRY								 *
* 		A9	POINTER TO TABLE				 *
* 		A12	LIST OF ON/OFF BITS				 *
* 		B5	RETURN ADDRESS					 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

CHIPTABLE:
	MOVE	B5,A14
CTABLOOP
	MOVE	*A9+,A10,L		; GET POINTER TO CHIP RECORD
	JRZ	CTABDONE
	MOVK	1,A11
	MOVE	*A10(CMNUM),A0,W	; GET THE BIT NUMBER
	BTST	A0,A12			; CHECK BIT NUMBER
	JRZ	CTABL2
	MOVK	2,A11
CTABL2
	FCALL	CHIPOUT,B5
	JRUC	CTABLOOP

CTABDONE
	MOVE	A14,B5
	FRET	B5

**************************************************************************
*								         *
* 	CHIPPLOT							 *
* 									 *
* 	PLOT OUT THE CHIP LIST						 *
* 									 *
* 	ENTRY								 *
* 		B5	RET VALUE					 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
**************************************************************************

CHIPPLOT:
	MOVE	B5,A14
	MOVI	CPU_CHIPS,A10
CPPLOTLOOP
	CLR	A11
	MOVE	*A10,A0,L
	JRZ	CPPLOTDONE
	FCALL	CHIPOUT,B5
	ADDI	CMEND,A10
	JRUC	CPPLOTLOOP

CPPLOTDONE
	MOVE	A14,B5
	FRET	B5

**************************************************************************
*								         *
* 	CHIPOUT								 *
* 									 *
* 	ACTUALLY PLOT THE CHIP						 *
* 									 *
* 	ENTRY								 *
* 		A10	POINTS TO CHIP TO PLOT				 *
* 		A11	COLOR OF CHIP					 *
* 				00 = OUTLINE				 *
* 				01 = GREEN				 *
* 				02 = RED				 *
* 				03 = GREY				 *
* 									 *
* 	EXIT								 *
* 		A10	IS INTACT					 *
*								         *
**************************************************************************

CHIPOUT:
	MOVE	*A10(CMLOC),A5,L	; CHIP OUTLINE
	MOVE	A5,A6
	MOVE	A5,A7
	MOVE	A5,A8
	MOVE	*A10(CMXSIZE),A0,W
	ADD	A0,A6
	ADD	A0,A7
	MOVE	*A10(CMYSIZE),A0,W
	SLL	16,A0
	ADD	A0,A7
	ADD	A0,A8
	MOVE	A5,A0
	MOVE	A6,A1
	MOVI	COLOR_WHITE,A2
	FCALL	HVLINE,B6
	MOVE	A6,A0
	MOVE	A7,A1
	ADDI	[1,0],A1
	MOVI	COLOR_WHITE,A2
	FCALL	HVLINE,B6
	MOVE	A8,A0
	MOVE	A7,A1
	MOVI	COLOR_WHITE,A2
	FCALL	HVLINE,B6
	MOVE	A5,A0
	MOVE	A8,A1
	MOVI	COLOR_WHITE,A2
	FCALL	HVLINE,B6
;
	MOVE	*A10(CMSTUFFED),A0,W	; CHECK FOR STUFFED
	JRNZ	CONOSTUF
	MOVK	3,A11			; WANT IT GREY, DUDE

CONOSTUF
	MOVE	A11,A11			; CHECK FOR FILLING THE CHIP
	JRZ	CONOFILL
	MOVE	*A10(CMLOC),A0,L
	ADDI	00010001H,A0
	MOVE	*A10(CMSIZE),A1,L
	SUBI	00010001H,A1		; GET INTERNAL AREA
	MOVE	A11,A2
	SLL	4,A2
	ADDI	CHIPCOLORS,A2
	MOVE	*A2,A2,W		;XUNIT  GET ME A COLOR
	FCALL	RECTANGLE,B6
CONOFILL
	MOVE	*A10(CMPINLOC),A1,L	; PIN LOCATION
	MOVE	A5,A0
	ADD	A1,A0
	MOVI	COLOR_WHITE,A1
	FCALL	POINT,B6

	MOVE	*A10(CMSTRING),A0,L	; CHIP TEXT
	MOVE	A5,A1
	MOVE	*A10(CMOFFSET),A2,L
	ADD	A2,A1
	MOVE	*A10(CMDIR),A2,W
	MOVI	COLOR_BLACK,A3
	MOVE	A11,A11			; CHECK FOR COLOR
	JRNZ	COBLACK
	MOVI	COLOR_WHITE,A3
COBLACK
	FCALL	STRING,B6
	FRET	B5

CHIPCOLORS:
	.WORD	COLOR_BLACK
	.WORD	COLOR_GREEN
	.WORD	COLOR_RED
	.WORD	COLOR_GREY

**************************************************************************
*								         *
* 	DMACHECK							 *
* 									 *
* 	CHECK THE DMA OUT						 *
* 									 *
* 	ENTRY								 *
* 		B5	RETURN ADDRESS					 *
* 									 *
* 	EXIT								 *
* 		A0	DMA STATUS					 *
* 				0 = GOOD				 *
* 				1 = BAD					 *
*								         *
**************************************************************************
DMACHECK			; rewritten for XUNIT
        MOVB	B14,@WDOG_BONE
	CLR	A14
	MOVE	A14,@DMAGOREG,L
	MOVE	A14,@DMAGOREG,L

	MOVi	DMACF4,A14		; XUNIT
	MOVE	A14,@DMACONFIG,L	;ADJUST WINDOW RIGHT/LEFT BORDER
	MOVI	[511,0],A14
	MOVE	A14,@DMAWINDOW,L		;OPEN LEFT TO RIGHT
	MOVI	DMAWIN|DMACF4,A14
	MOVE	A14,@DMACONFIG,W	;ADJUST WINDOW RIGHT/LEFT BORDER
	MOVI	[511,0],A14
	MOVE	A14,@DMAWINDOW,L		;FULL HEIGHT WINDOW
	MOVI	[100H,100H],A14
	MOVE	A14,@DMAXYSCL,L

	MOVI	[1,448],A14		;BLOW OUT TRADEMARK
	MOVE	A14,@DMAHVSIZE,L

	MOVI	IROM,A14		;DMA LOGO LOCATION
	MOVE	A14,@DMASAG,L

	MOVI	[257,0],A14
	MOVE	A14,@DMAHV,L		;OFFSCREEN PLOT

	MOVI	0505H,A14
	MOVE	A14,@DMACMAPCON,L	; CONST = 0, CMAP = 505h

	MOVI	[8003H,0],A14		;USE IMAGE ROM - WRITE ALWAYS
	MOVE	A14,@DMAOFFCTL,L 	;KICK OFF THE DMA

	MOVI	7FFFH,A14		;LOAD TIMEOUT COUNTER
DMACWAIT
        MOVE	B14,@WDOG_BONE
	MOVE	@DMAGOREG,A0,L		;DMA BUSY?
	JRNN	DMADONE			;BR = NO, TIME TO CHECK
	DSJS	A14,DMACWAIT
	JRUC	DMACBAD			;DMA TIMED OUT

DMADONE
	CLR	A0			;GET BACK TO A REAL PALETTE
	MOVE	A0,@DMACMAPCON,L
	MOVI	0101000H,A0		;LINEAR SCREEN LOCATION OF DATA
	MOVI	IROM,A1		;DMA LOGO LOCATION
	MOVI	448,A2			;NUMBER OF BYTES TO COMPARE
DMACLOOP
	MOVB	*A0,A3			;DESTINATION BYTE
;	SLL	28,A3
;	SRL	28,A3
	MOVB	*A1,A4			;SOURCE BYTE
;	SLL	28,A4
;	SRL	28,A4
	ADDK	8,A0
	ADDK	8,A1
	CMP	A3,A4
	JRNZ	DMACBAD			;BR = DATA ERROR
	DSJS	A2,DMACLOOP
*
*CHECK DATA IN OBJECT PALETTE
*
	MOVI	0901000H,A0		;LOCATION
	MOVI	224,A2			;NUMBER OF WORDS TO COMPARE
DMACLOOP2
	MOVE	*A0+,A3,W
;	ANDI	0F0FH,A3
	CMPI	0505H,A3
	JRNZ	DMACBAD
	DSJS	A2,DMACLOOP2
	CLR	A0
	JRUC	DMACRET
DMACBAD
	CLR	A0			;GET BACK TO A REAL PALETTE
	MOVE	A0,@DMAOFFCTL,L
	MOVE	A0,@DMACMAPCON,L
	MOVK	1,A0
DMACRET
	MOVE	A0,A0
	FRET	B5

**************************************************************************
*								         *
* 	POWERTST							 *
* 									 *
* 	POWERUP SELF TEST ROUTINES					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

POWERTST
        DINT
        SETF 16, 0, 0
        SETF 32, 0, 1
	MOVI	STCKST,SP,L
	MOVB	B14,@WDOG_BONE		;THROW A BONE

;	HALT DMA AND ENABLE CACHE

        CLR  A14
        MOVE A14, @DMAGOREG,L
        MOVE A14, @DMAGOREG,L
        MOVE A14, @CONTROL

;	DISABLE VIDEO PALETTE RAMS, AUTOERASE AND ERROR LED

	MOVI	SYSCINIT,A13

	.if	XUNIT=1
	MOVE	A13,@SYSCTRL0,L		; XUNIT
	srl	8,a13			; XUNIT
	MOVE	A13,@SYSCTRL1,L		; XUNIT
	.else
	move	a13,@SYSCTRL,W
	.endif

;	INITIALIZE IO REGISTERS

	MOVI	INITDATA,B0
	MOVI	IDATALEN,B7

	.if	XUNIT=1
	MOVI	VESYNC,B2
	BLMOVE	1,1			;TRANSFER I/O REGS
	movi	DPYSTRT0,a14	; XUNIT
	move	a14,@DPYST,L	; XUNIT

	.else
	movi	HESYNC,b2
	srl	5,b7
_t2:
	move	*b0+,*b2+,L
	dsjs	b7,_t2
	movi	0fffch,a14
	move	a14,@DPYSTRT,W
	.endif

	JRUC	POWERCPUTEST
PONTEST
	MOVI	SYSCINIT,A0
	MOVE	A0,@SYSCOPY,W

	.if	XUNIT=1
	MOVE	A0,@SYSCTRL0,L		; XUNIT
	srl	8,a0			; XUNIT
	MOVE	A0,@SYSCTRL1,L		; XUNIT
	.else
	move	a0,@SYSCTRL,W
	.endif

	JAUC	POWERRET

DOG_COUNT	.EQU	8000H	;EVERY 32K
**************************************************************************
*								         *
* 	RAMCHECK							 *
* 									 *
* 	CHECK A BANK OF RAM, GIVEN A STARTING TABLE ADDRESS		 *
* 									 *
* 	ENTRY								 *
* 		A14	POINTER TO RAM TABLE				 *
* 		B5	RETURN ADDRESS					 *
* 									 *
* 	EXIT								 *
* 		B0	LIST OF ERRORS					 *
*								         *
**************************************************************************

	.ALIGN			;LET'S CACHE THIS BITCH

RAMCHECK:
	MOVB	B14,@WDOG_BONE		;THROW A BONE
        SETF 16, 0, 0
        SETF 32, 0, 1

;	SNAG NEXT CHIP RECORD

RAMLOOP:
	CLR	B2
	MOVE	*A14(RAM_SADR),A12,L	; STARTING ADDRESS
	MOVE	*A14(RAM_EADR),A13,L	; ENDING ADDRESS
	MOVE	*A14(RAM_ITLV),A11,W	; INTERLEAVE
	MOVE	*A14(RAM_WDTH),A10,W	; WIDTH

;	CELL COUNT

        SUB  A12, A13                   ; (END-START)/INTERLEAVE+1
        DIVU A11, A13
        INC  A13

;	SET FIELD SIZES

        MOVE A11, A9                    ; FS1 = INTERLEAVE
        ANDI ZERO_EXTEND, A9
        EXGF A9, 1

        MOVE A10, A9                    ; FS0 = WIDTH
        ANDI ZERO_EXTEND, A9
        EXGF A9, 0

;	FILL IN ASCENDING ORDER

        MOVE A13, A9                    ; XEROX COUNT
        MOVE A12, A8                    ; XEROX START

        MOVI RANDOM_SEED, A7, L
        CLR	A5
	MOVI	DOG_COUNT,B14

RAC1:
	SLA	1,A7			; GENERATE A PSEUDO
	JRV	RAC2			; RANDOM NUMBER
	ORI	2,A7
RAC2:
	MOVE	A7,A6
	ADDC	A5,A6

	MOVE	A6,*A8+,1		; WRITE
	DSJS	B14,RAC1_NODOG
	MOVB	B14,@WDOG_BONE		;THROW A BONE
	MOVI	DOG_COUNT,B14		;AND RELOAD COUNT
RAC1_NODOG
	DSJS	A9,RAC1

;	READBACK IN ASCENDING ORDER

        MOVE A13, A9                    ; XEROX COUNT
        MOVE A12, A8                    ; XEROX START

        MOVI RANDOM_SEED, A7, L
	MOVI	DOG_COUNT,B14

RAC3:   SLA  1, A7                      ; GENERATE A PSEUDO
        JRV  RAC4                       ; RANDOM NUMBER
        ORI  2, A7
RAC4:   MOVE A7, A6
        ADDC A5, A6

        MOVE *A8+, A4, 1                ; READ

        ZEXT  A6
        ZEXT  A4

        CMP A6, A4
        JRZ RAC5
;
;	GOT AN ERROR HERE
;
	SETF	16,0,0			; RESET FIELDS
	SETF	32,0,1
	MOVE	*A14(RAM_NMBR),A4,W	; GET BIT NUMBER TO SET
	MOVE	A4,B1
	MOVK	1,B2
	SLL	B1,B2
	OR	B2,B0			; SET THAT BIT
	JRUC	RAC6			; BREAK !!
RAC5
	DSJS	B14,RAC5_NODOG
	MOVB	B14,@WDOG_BONE		;THROW A BONE
	MOVI	DOG_COUNT,B14		;AND RELOAD COUNT
RAC5_NODOG
	DSJS	A9,RAC3

RAC6
	MOVB	B14,@WDOG_BONE		;THROW A BONE FOR GOOD MEASURE
	SETF	16,0,0			; RESET FIELDS
	SETF	32,0,1
;
;	B1 SHOULD BE ZERO IF THE CHIP IS COOL HERE
;
	MOVE	*A14(RAM_LINK),A10,L
	JRZ	RAMNOPLOT
	MOVK	1,A11
	MOVE	B2,B2
	JRZ	RAMPLOT
	MOVK	2,A11
RAMPLOT
	MOVE	B5,A9			; I HOPE THIS ONE IS SAFE!
	MOVE	B0,A13
	FCALL	CHIPOUT,B5
	MOVE	A13,B0
	MOVE	A9,B5

RAMNOPLOT
	ADDI	RAM_SIZE,A14		; ADVANCE TO NEXT GUY
	MOVE	*A14,A7,W
	JRNZ	RAMLOOP			; HERE WE GO AGAIN
	FRET	B5

**************************************************************************
*								         *
* 		   START OF DIAG CACHE SEGMENT				 *
*								         *
**************************************************************************

	.ALIGN			;LET'S CACHE THIS BITCH

**************************************************************************
*								         *
* ROMCHECK - ROUTINE TO CHECKSUM THE PROGRAM AND IMAGE ROMS.		 *
* RETURNS								 *
* 	B0  = BITS SET FOR BAD ROMS.					 *
* 	 Z = TEST FINISHED.						 *
* 	NZ = TEST ABORTED BY USER.					 *
*								         *
**************************************************************************
ROMCHECK:
	MOVB	B14,@WDOG_BONE		;THROW A BONE
ROMLOOP
	CLR	B2
	MOVE	*A14(ROM_CKSM),A13,L	; CHECK TO SEE IF ROM SOCKET THERE
	JRZ	ROMEMPTY
	CLR	A8			; CHECKSUM

	MOVI	DOG_COUNT,B14

	MOVE	*A14(ROM_SADR),A12,L	; STARTING ADDRESS
	MOVE	*A14(ROM_EADR),A13,L	; ENDING ADDRESS
	MOVE	*A14(ROM_ITLV),A11,W	; INTERLEAVE
;
;	SUM UP A GIVEN IMAGE ROM -- THE TUNIT WAY
;
	SUB	A12,A13			; (( EADDR - SADDR ) / INTERLEAVE) + 1
	DIVU	A11,A13
	INC	A13
RCILP
	MOVB	*A12,A7
	SLL	24,A7
	SRL	24,A7
	ADD	A11,A12
	ADD	A7,A8
	DSJS	B14,RCILP_NODOG
	MOVB	B14,@WDOG_BONE		;THROW A BONE
	MOVI	DOG_COUNT,B14		;AND RELOAD COUNT
RCILP_NODOG
	DSJS	A13,RCILP

	MOVE	*A14(ROM_WDTH),A10,W	; WIDTH
	JRNZ	ROMCKCK			;ACTUALLY A FLAG FOR IMAGE OR PROG

	MOVE	*A14(ROM_NMBR),A4,W	;WHICH PROGRAM ROM ARE WE CHECKING?
	JRNZ	PROGRAM_1		;BR = HIGH BYTE ROM
	MOVE	@CHECKSUM0,A7,W		;LOAD HARD CODED CHECKSUM
	JRUC	ROM_COMPARE
PROGRAM_1
	MOVE	@CHECKSUM1,A7,W
	JRUC	ROM_COMPARE

*LAND HERE FROM IMAGE CHECKSUM TO DETERMINE IF WE HIT IT
ROMCKCK
	MOVE	*A14(ROM_CKSM),A7,W
ROM_COMPARE
	ZEXT	A7
	ZEXT	A8
	CMP	A7,A8
	JRZ	ROMRELOOP
	MOVE	*A14(ROM_NMBR),A4,W	; GET BIT NUMBER TO SET
	MOVE	A4,B1
	MOVK	1,B2
	SLL	B1,B2
	OR	B2,B0			; SET THAT BIT
ROMRELOOP
	MOVB	B14,@WDOG_BONE		;THROW A BONE
	MOVE	*A14(ROM_LINK),A10,L
	JRZ	ROMNOPLOT
	MOVK	1,A11
	MOVE	B2,B2
	JRZ	ROMPLOT
	MOVK	2,A11
ROMPLOT
	MOVE	B5,A9			; I HOPE THIS ONE IS SAFE!
	MOVE	B0,A13
	FCALL	CHIPOUT,B5
	MOVE	A13,B0
	MOVE	A9,B5

ROMNOPLOT
	ADDI	ROM_SIZE,A14
*CHECKING FOR EARLY EXIT BY OPERATOR
	MOVE	@COINS,A13,W		; XUNIT
	MOVE	A13,A8
	ANDI	00000004H,A13		;CHECK PLAYER 1 START
	JRZ	ROMABORT		;BR = IT'S PRESSED
	ANDI	00000020H,A8		;CHECK PLAYER 2 START
	JRZ	ROMABORT		;BR = IT'S PRESSED
	JRUC	ROMLOOP			;BACK FOR THE NEXT
*HERE ON OPERATOR ABORT
ROMABORT
	CLRZ
ROMEMPTY
	FRET	B5

**************************************************************************
*								         *
* 	MONITOR STUFF							 *
*								         *
**************************************************************************

CONV_PLOT:
	MOVI	MON_RECS,A9
CPRLP1
	MOVE	*A9+,A2,W		; GET COLOR
	JRZ	CPRDONE
	MOVE	*A9+,A0,L		; START POINT
	MOVE	*A9+,A1,L		; DIMENSIONS
	FCALL	RECTANGLE,B6
	JRUC	CPRLP1
CPRDONE
	MOVI	MON_VECS,A9		; POINT AT VECTOR TABLE
CPVLP1
	MOVE	*A9+,A2,W		; GET COLOR
	JRZ	CPVDONE
	MOVE	*A9+,A0,L		; START POINT
	MOVE	*A9+,A1,L		; END POINT
	FCALL	HVLINE,B6
	JRUC	CPVLP1
CPVDONE
	MOVI	MON_DOTS,A9		; POINT AT DOT TABLE
CPDLP1
	MOVE	*A9+,A1,W		; GET COLOR
	JRZ	CPDDONE
	MOVE	*A9+,A0,L		; GET THE POINT
	FCALL	POINT,B6
	JRUC	CPDLP1
CPDDONE
	RETS


**************************************************************************
*								         *
* 	COLORBAR							 *
*								         *
**************************************************************************
COLORBAR:
;       =========================
;       | SET PALETTE 0 FOR     |
;       | COLOR BARS.           |
;       =========================

	MOVI	INTENSITIES_START,A0,L
	MOVI	COLRAM+(5*PALSIZE),A1,L	;START UP A LITTLE BIT

	MOVK	16,A2		;5 BITS/COLOR
        MOVK  	1,A6		;1 PALETTE(S) TO COVER 8 BARS
CB2
	MOVK	8,A7		;8 BARS/PALETTE
CB3
	MOVE	*A0+,A3		;STARTING COLOR
	MOVE	*A0+,A4		;COLOR DECREMENT
	MOVE	A2,A5
CB4
	.if	XUNIT=1
	MOVE	A3,*A1+,L	; XUNIT
	.else
	move	a3,*a1+,W
	.endif

	SUB	A4,A3
	DSJS	A5,CB4
	DSJS	A7,CB3

	ADDI	16*PALSIZE/NUMPAL,A1
        DSJS 	A6,CB2

;       =========================
;       | DISPLAY COLOR BARS    |
;       =========================

	CLR	A14
	MOVE	A14,@DMAGOREG,L		;HALT THE DMA
	MOVI	[0,0101H],A14		;PALETTE INCREMENT
	MOVI	[0,0505H],A8		;START AT THIS PALETTE

	MOVI	COLOR_BARS,A3,L		;COLOR BAR TABLE
	MOVI	[16,0],A13,L		;POSITION INCRMENT
	MOVI	01010101H,A12		; XUNIT
	MOVK	16,A11			;# INTENSITIES / BAR
	MOVK	1,A6			;THIS MANY GROUPS OF 8 BARS
	CLR	A2			;STARTING COLOR
CB5
	MOVK	8,A7			;THIS MANY BARS PER PALETTE
CB6
	MOVE	*A3+,A1,L
	JRZ	CB8
	MOVE	A8,@DMACMAPCON,L		;STUFF PALETTE
	MOVE	*A3+,A0,L
	ADDK	16,A3
	MOVE	A11,A10
CB7
	FCALL	RECTANGLE,B6
	ADD	A13,A0
	ADD	A12,A2
	DSJS	A10,CB7
	DSJ	A7,CB6			;NEXT BAR PLEASE
	ADD	A14,A8			;NEXT BAR & PALETTE PLEASE
	DSJ	A6,CB5
CB8
	CLR	A14
	MOVE	A14,@DMACMAPCON,L
	RETS


INTENSITIES_START:

        .WORD 03E0H                ; GREEN
        .WORD 0040H                ; BUMP GREEN

        .WORD 7C00H                ; RED
        .WORD 0800H                ; BUMP RED

        .WORD 001FH                ; BLUE
        .WORD 0002H                ; BUMP BLUE

        .WORD 0000H                ; BLACK
        .WORD 0000H                ; BUMP BLACK

        .WORD 7FFFH                ; WHITE
        .WORD 0842H                ; BUMP WHITE

        .WORD 7FE0H                ; YELLOW
        .WORD 0840H                ; BUMP YELLOW

        .WORD 7C1FH                ; PURPLE
        .WORD 0802H                ; BUMP PURPLE

        .WORD 03FFH                ; CYAN
        .WORD 0042H                ; BUMP CYAN

	.LONG	0


**************************************************************************
*								         *
* 	DIPTEST								 *
* 									 *
* 	DIP SWITCH TESTING						 *
*								         *
**************************************************************************

DIPTEST:
	MOVKM	1,@DIAG_DFLAG,W
	MOVKM	1,@DIP1ST,W		;YES THIS IS THE FIRST TIME THROUGH
DT_PLOT
	CALLA	DIAG_SRT_CLR
	MOVI	DIP_VECS,A9		; POINT AT VECTOR TABLE
DTVLP1
	MOVE	*A9+,A2,W		; GET COLOR
	JRZ	DTVDONE
	MOVE	*A9+,A0,L		; START POINT
	MOVE	*A9+,A1,L		; END POINT
	FCALL	HVLINE,B6
	JRUC	DTVLP1
DTVDONE
	MOVI	DIP_STRS,A9
	CALLR	STR_PLOT
	CALLR	DIPPLOT
	CALLR	DIPSTATE

	MOVE	@DIP1ST,A14,W
	JRNZ	DTL_SKIP_SND

	MOVI	DIP_SND,A0
;	MOVE	A0,@SOUND,W

DTL_SKIP_SND
	CLRM	@DIP1ST,W

	PAUSE	10000,B6
	FCALL	FREAD_SW1_CNS,B6		; XUNIT
	ANDI	00243030H,A0
	MOVE	A0,@SWSET1,L
DTLOOP
	CALLA	CKTEST			; EMERGENCY EXIT
	FCALL	FREAD_SW1_CNS,B6		; XUNIT GOTTA SEE IF TIME TO LEAVE
	MOVE	@SWSET1,A1,L
	ANDI	00243030H,A0
	CMP	A0,A1
	JRNZ	DT_X

	CALLR	READ_DIP
	MOVE	@DIPVAL,A1,W
	ANDI	0FFFFH,A1		;FUCKING SIGN EXTEND
	CMP	A0,A1
	JRZ	DTLOOP			;BR = NO CHANGE
	MOVE	A0,@DIPVAL,W		;SAVE THE OLD
	JRUC	DT_PLOT			;PLOT THE NEW SWITCH STUFF
DT_X
	CLRM	@DIAG_DFLAG,W

	RETS

**************************************************************************
*								         *
* 	DIPSTATE							 *
* 									 *
* 	PLOT OUT THE STATES OF ALL THE DIP SWITCHES			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
DIPSTATE
	CALLR	READ_DIP
	MOVE	A0,A10			;LET'S KEEP A COPY

	CLR	A2
	MOVI	COLOR_WHITE,A3

	MOVI	DMIRROR_0,A1
	ANDI	DPMIRROR,A0		;MIRROR?
	JRZ	SD1
	MOVI	DMIRROR_1,A1
SD1
	MOVE	A1,A0
	MOVI	[39,75],A1
	FCALL	STRING,B6

	MOVI	DUSECMOS_0,A1
	MOVE	A10,A0
	ANDI	DPUSECMOS,A0
	JRZ	DS1
	MOVI	DUSECMOS_1,A1
DS1
	MOVE	A1,A0
	MOVI	[51,75],A1
	FCALL	STRING,B6

*PLOT CURRENT COINAGE
	MOVI	COLOR_WHITE,A3
	MOVI	[69,75],A1
	MOVI	DCOINAGE,A0
	FCALL	STRING,B6
	MOVE	A10,A0
	ANDI	DPCOUNTRY,A0
	SRL	SR_DPCOUNTRY,A0
	SLL	5,A0
DCC_CZ
	ADDI	DCOINTAB,A0
	MOVE	*A0,A1,L		; POINTER TO RIGHT COIN TABLE
	MOVE	A10,A0
	ANDI	DPCOINAGE,A0
	SRL	SR_DPCOINAGE,A0
	SLL	5,A0
	ADD	A0,A1
	MOVE	*A1,A0,L		; NOW POINTING AT MESSAGE
	CLR	A2
	MOVI	[81,75],A1
	FCALL	STRING,B6

*PLOT CREDITS TO START, CREDITS TO CONTINUE
	MOVI	DCREDITS,A0
	MOVI	[101,75],A1
	FCALL	STRING,B6

	MOVI	DTOSTART,A0
	MOVI	[112,88],A1
	FCALL	STRING,B6

	MOVI	DTOCONTINUE,A0
	MOVI	[123,88],A1
	FCALL	STRING,B6

	MOVE	A10,A7
	ANDI	DPCREDITS,A7
	SRL	SR_DPCREDITS,A7
	SLL	5,A7
	ADDI	DCREDTAB,A7
	MOVE	*A7+,A0,L
	MOVI	[112,75],A1
	FCALL	STRING,B6
	MOVE	*A7+,A0,L
	MOVI	[123,75],A1
	FCALL	STRING,B6

*PLOT COUNTRY SELECTION
	MOVE	A10,A0
	ANDI	DPCOUNTRY,A0
	SRL	SR_DPCOUNTRY,A0
	SLL	5,A0
	ADDI	DCOUNTRY_TAB,A0
	MOVE	*A0,A0,L
	MOVI	[45,285],A1
	FCALL	STRING,B6

	MOVI	DUNUSED,A0
	MOVI	[63,285],A1
	FCALL	STRING,B6

	MOVI	DCOUNTER_0,A1
	MOVE	A10,A0
	ANDI	DPCOUNTER,A0		; COUNTER
	JRZ	SD2
	MOVI	DCOUNTER_1,A1
SD2
	MOVE	A1,A0
	MOVI	[75,285],A1
	FCALL	STRING,B6

	MOVE	A10,A0
	ANDI	DPPLAYERS,A0
	SRL	SR_DPPLAYERS,A0
	SLL	5,A0
	ADDI	DPLAYER_TAB,A0
	MOVE	*A0,A0,L
	MOVI	[93,285],A1
	FCALL	STRING,B6

	MOVI	DFREEZE_0,A0
	MOVI	[111,285],A1
	FCALL	STRING,B6

	MOVI	DTEST_0,A0
	MOVI	[123,285],A1
	FCALL	STRING,B6

	RETS

**************************************************************************
*								         *
* 	CHECKDIPFREE							 *
* 									 *
* 	CHECK TO SEE IF EITHER OF THE COIN SLOTS IS ON FREE PLAY,	 *
* 	AND IF SO RETURN Z, OTHERWISE DON'T				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		.EQ.	YES, FREEPLAY					 *
*								         *
**************************************************************************

CHECKDIPFREE:
	PUSH	A0
	CALLR	READ_DIP
	ANDI	DPCOINAGE,A0
	CMPI	DPCOINAGE,A0
CDFRET
	PULL	A0
	RETS

**************************************************************************
*								         *
* 	DIPPLOT								 *
* 									 *
* 	PLOT OUT THE DIP SWITCHES					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

DIPPLOT:
	CALLR	READ_DIP
	CLR	A2
DIPLOOP
	MOVE	A2,A3
	SLL	5,A3
	ADDI	DIPYTAB,A3
	MOVE	*A3,A3,L
	SLL	16,A3			; GOT THE Y LOC

	CLR	A5
	CMPI	8,A2			;Is this switch in the Second bank?
	JRLO	DIPL2			;BR = No
	MOVI	210,A5			;Second bank, change X plot position
DIPL2
	MOVX	A5,A3

	BTST	A2,A0			; CHECK IF BIT IS SET
	JRNZ	DIPON
	MOVI	DP_OFF,A1
	ADDI	29,A3
	MOVI	COLOR_GREY,A4
	JRUC	DIPSTR

DIPON
	MOVI	DP_ON,A1
	ADDI	32,A3
	MOVI	COLOR_WHITE,A4

DIPSTR
	MMTM	SP,A0,A2
	MOVE	A1,A0			; SET STRING
	MOVE	A3,A1			; SET LOCATION
	MOVE	A4,A3
	CLR	A2			; HORIZONTAL
	FCALL	STRING,B6
	MMFM	SP,A0,A2
	INC	A2
	CMPI	16,A2
	JRLO	DIPLOOP
	RETS


DIPYTAB
	.LONG	39,51,63,75,87,99,111,123
	.LONG	39,51,63,75,87,99,111,123

**************************************************************************
*								         *
* 	READ_DIP							 *
* 									 *
* 	READ IN BOTH DIP SWITCHES					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A0	DIP SWITCH					 *
*								         *
**************************************************************************

READ_DIP:
	MOVE	@DIPSWITCH,A0,W		; READ IT IN
	NOT	A0			; INVERT IT FOR TRUE BITS
	RETS


**************************************************************************
*								         *
* 	SWITCHTEST							 *
* 									 *
* 	DRAW OUT THE TROG SWITCHES -- A PRETTY PICTURE			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

SWITCHTEST:
;	PUSHST
;	DINT
	MOVKM	1,@DIAG_DFLAG,W
	CLR	A13			; THE HOLD ME REGISTER
	MOVE	A13,@SWSET1,L
	MOVE	A13,@SWSET2,L
	MOVE	A13,@SWPREV1,L
	MOVE	A13,@SWPREV2,L
	MOVI	BUT_TABLE,A9
	CLR	A10
	CALLR	BUT_PLOT		; PLOT SOME BUTTONS
	MOVI	STR_TABLE,A9
	CALLR	STR_PLOT		; PLOT THE STRINGS
	MOVI	00B90005H,A0
	MOVI	00B9018BH,A1
	MOVI	COLOR_WHITE,A2
	FCALL	HVLINE,B6		; DRAW LITTLE WHITE LINE
SDLOOP
	FCALL	FREAD_SW1_CNS,B6		; XUNIT GRAB ME A SWITCH REGISTER
	NOT	A0
	MOVE	A0,A10
	ANDI	DONEMASK,A0
	CMPI	DONEMASK,A0,L		; CHECK FOR DONE
	JRNZ	SDGO
;	POPST
	CLRM	@DIAG_DFLAG,W
	RETS
SDGO
	MOVE	@SWSET1,A11,L
	CMP	A11,A10			; CHECK FOR CHANGES
	JRZ	SDCK2
	MOVE	A10,@SWSET1,L
	FCALL	FREAD_SW2_DIP,B6		; XUNIT
	NOT	A10
	ANDI	0FFH,A10
	MOVE	A10,@SWSET2,L
	JRUC	SDPROC
SDCK2
	FCALL	FREAD_SW2_DIP,B6		; XUNIT
	NOT	A10
	ANDI	0FFH,A10
	MOVE	@SWSET2,A11,L
	CMP	A11,A10
	JRZ	SDLOOP
	MOVE	A10,@SWSET2,L
SDPROC

	MOVI	BUT_TABLE,A9
	CALLR	BUT_PLOT
	MOVI	SWITCHSTR_TAB,A9
	CALLR	SWITCHSTR_PLOT

	MOVE	@SWPREV1,A1,L
	NOT	A1
	MOVE	@SWSET1,A2,L
	NOT	A2
	OR	A2,A1
	CMP	A1,A2
	JRNZ	SDSOUND
	MOVE	@SWPREV2,A1,L
	NOT	A1
	MOVE	@SWSET2,A2,L
	NOT	A2
	OR	A2,A1
	CMP	A1,A2
	JRZ	SDNOSOUND

SDSOUND
	MOVI	SWITCH_SND,A0
;	MOVE	A0,@SOUND,W

SDNOSOUND
	MOVE	@SWSET1,@SWPREV1,L
	MOVE	@SWSET2,@SWPREV2,L
	JRUC	SDLOOP

**************************************************************************
*								         *
* 	BUT_PLOT							 *
* 									 *
* 	PLOT A BUTTON TABLE ON THE SCREEN				 *
* 									 *
* 	ENTRY								 *
* 		A9	POINTS TO BUTTON TABLE LIST			 *
* 		A10	SETTINGS OF THE SWITCH REGISTER			 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
BUT_PLOT:
	MOVE	*A9+,A1,L		; XY LOC
	JRZ	BPDONE
	MOVE	*A9+,A0,W		; RADIUS
	MOVE	*A9+,A6,L		; COLOR
	MOVE	*A9+,A11,L		; GET MASK
	ADDK	16,A9			; SHIFT COUNT
	MOVE	*A9+,A8,W		; JAMMA EXTEND-O-BIT
	JRZ	BPLOW
	MOVE	@SWSET2,A10,L
	JRUC	BPAND
BPLOW
	MOVE	@SWSET1,A10,L
BPAND
	AND	A10,A11			; MASK OFF SOMETHING USEFUL
	JRZ	BPHOLLOW
	SUBK	2,A0
	ADDI	CFILL,A6		; MASK IN THE FILL BITS
	JRUC	BPCIRC
BPHOLLOW
	MMTM	SP,A0,A1,A6
	SUBK	2,A0
	MOVI	COLOR_BLACK,A6
	ADDI	CFILL,A6
	FCALL	CIRCLE,B6
	MMFM	SP,A0,A1,A6
BPCIRC
	FCALL	CIRCLE,B6
	JRUC	BUT_PLOT
BPDONE
	RETS

**************************************************************************
*								         *
* SWITCHSTR_PLOT - CHECK SWITCHES AND PLOT CORRESPONDING STRING.	 *
* A9 = POINTS TO SWITCH STRING TABLE LIST				 *
* A10 = SETTINGS OF THE SWITCH REGISTER					 *
*								         *
**************************************************************************
SWITCHSTR_PLOT:
	MOVE	*A9+,A1,L		;XY LOC
	JRZ	SSTR_DONE
	MOVE	*A9+,A0,L		;STRING PTR
	MOVE	*A9+,A3,W		;COLOR
	MOVE	*A9+,A2,W		;DIRECTION
	MOVE	*A9+,A11,L		;GET MASK
	MOVE	@SWSET1,A10,L
	AND	A10,A11			;CHECK JUST OUR SWITCH
	JRNZ	SSTR_PLOT
	MOVI	COLOR_BLACK,A3
SSTR_PLOT
	FCALL	STRING,B6
	JRUC	SWITCHSTR_PLOT
SSTR_DONE
	RETS

**************************************************************************
*								         *
* 	STR_PLOT							 *
* 									 *
* 	PLOT A STRING TABLE ON THE SCREEN				 *
* 									 *
* 	ENTRY								 *
* 		A9	POINTS TO STRING TABLE LIST			 *
*								         *
**************************************************************************

STR_PLOT:
	MOVE	*A9+,A1,L		; XY LOC
	JRZ	STDONE
	MOVE	*A9+,A0,L		; STRING PTR
	MOVE	*A9+,A3,W		; COLOR
	MOVE	*A9+,A2,W		; DIRECTION
	FCALL	STRING,B6
	JRUC	STR_PLOT
STDONE
	RETS

CFILL	EQU	0FFFF0000H

;
;	FORMAT
;
;	X,Y,RADIUS,COLOR,MASK,SHIFT COUNT ( FOR JOYSTICK STUFF ), EXTENDBIT
;

COLOR_P1	EQU	COLOR_BLUE
COLOR_P2	EQU	COLOR_RED

**************************************************************************
*								         *
* 	Y-UNIT DEFS							 *
*								         *
**************************************************************************


BUT_TABLE:
	BUT_MAC	260,199,10,COLOR_GREEN,00080000H,0,0	; SLAM
	BUT_MAC	260,222,10,COLOR_GREEN,00100000H,0,0	; TEST
;XUNIT	BUT_MAC	260,245,10,COLOR_GREEN,01000000H,0,0	; VIDEO FREEZE
	BUT_MAC 30,207,10,COLOR_GREEN,00010000H,0,0	; COIN LEFT
	BUT_MAC	75,207,10,COLOR_GREEN,00020000H,0,0	; COIN RIGHT
	BUT_MAC	120,207,10,COLOR_GREEN,00800000H,0,0	; COIN CENTER
	BUT_MAC	165,207,10,COLOR_GREEN,01000000H,0,0	; XUNIT FOURTH COIN
;XUNIT	BUT_MAC	165,207,10,COLOR_GREEN,02000000H,0,0	; FOURTH COIN
	BUT_MAC	214,207,10,COLOR_GREEN,00400000H,0,0	; SERVICE CREDIT
	.LONG	0

DONEMASK	EQU	00040010H			; P1 START + P1 TRIGGER

SWITCHSTR_TAB
	SW_MAC	10,30,P1START,COLOR_P1,0,00040000H		;P1 START
	SW_MAC	240,30,P2START,COLOR_P2,0,00200000H	;P2 START
	SW_MAC	10,40,P1_TRIGGER,COLOR_P1,0,00000010H	;P1 TRIGGER
	SW_MAC	10,50,P1_BOMB,COLOR_P1,0,00000020H		;P1 BOMB
	SW_MAC	240,40,P2_TRIGGER,COLOR_P2,0,00001000H	;P2 TRIGGER
	SW_MAC	240,50,P2_BOMB,COLOR_P2,0,00002000H	;P2 BOMB
	.LONG	0

STR_TABLE:
	STR_MAC	88,5,SWITCH_TITLE,COLOR_WHITE,0		;TITLE
	STR_MAC	275,196,SLAM,COLOR_GREEN,0			;SLAM
	STR_MAC	275,219,TEST,COLOR_GREEN,0			;TEST SWITCH
;XUNIT	STR_MAC	275,242,VIDEO,COLOR_GREEN,0		;VIDEO FREEZE
	STR_MAC	12,233,LEFTSLOT,COLOR_GREEN,0		;LEFT COIN
	STR_MAC	56,233,RIGHTSLOT,COLOR_GREEN,0		;RIGHT COIN
	STR_MAC	103,222,CENTER,COLOR_GREEN,0		;CENTER COIN
	STR_MAC	147,222,FOURTH,COLOR_GREEN,0		;COIN MIDDLE
	STR_MAC	10,222,COINMESS1,COLOR_GREEN,0		;BOTTOM MESSAGE
	STR_MAC	55,222,COINMESS2,COLOR_GREEN,0
	STR_MAC	193,222,SERVICE1,COLOR_GREEN,0		;SERVICE CREDIT
	STR_MAC	197,233,SERVICE2,COLOR_GREEN,0		;SERVICE CREDIT
	.IF GERMAN
	STR_MAC	100,150,EXITMESS1,COLOR_WHITE,0		;EXIT MESSAGE 1
	STR_MAC	153,160,EXITMESS2,COLOR_WHITE,0		;EXIT MESSAGE 2
	.ELSE
	STR_MAC	90,150,EXITMESS1,COLOR_WHITE,0		;EXIT MESSAGE 1
	STR_MAC	157,160,EXITMESS2,COLOR_WHITE,0		;EXIT MESSAGE 2
	.ENDIF
	.LONG	0

	.IF GERMAN

SWITCH_TITLE
	.STRING	"HOCKEY - KONTAKT-TEST",0
EXITMESS1
	.STRING	"SPIELER 1 START UND TRIGGER",0
	.EVEN
EXITMESS2
	.STRING "ZUM VERLASSEN",0
	.EVEN
LEFTSLOT
	.STRING "LINK.",0
	.EVEN
RIGHTSLOT
	.STRING	"RECHT.",0
	.EVEN
SERVICE1
	.STRING	"SERVICE",0
	.EVEN
SERVICE2
	.STRING	"KREDIT",0
	.EVEN

	.ELSE

SWITCH_TITLE
	.STRING	"HOCKEY - SWITCH TEST",0
EXITMESS1
	.STRING	"PLAYER 1 START AND TRIGGER",0
	.EVEN
EXITMESS2
	.STRING "TO EXIT",0
	.EVEN
LEFTSLOT
	.STRING "LEFT",0
	.EVEN
RIGHTSLOT
	.STRING	"RIGHT",0
	.EVEN
SERVICE1
	.STRING	"SERVICE",0
	.EVEN
SERVICE2
	.STRING	"CREDIT",0
	.EVEN

	.ENDIF

STSTART
	.STRING	"STARTS",0
	.EVEN

P1START
	.STRING	"TERMINATOR 1 START",0
	.EVEN
P2START
	.STRING	"TERMINATOR 2 START",0
	.EVEN
P1_TRIGGER
	.STRING	"TERMINATOR 1 TRIGGER",0
	.EVEN
P2_TRIGGER
	.STRING	"TERMINATOR 2 TRIGGER",0
	.EVEN
P1_BOMB
	.STRING	"TERMINATOR 1 BOMB",0
	.EVEN
P2_BOMB
	.STRING	"TERMINATOR 2 BOMB",0
	.EVEN

COINMESS1
	.STRING	"COIN1",0
	.EVEN
COINMESS2
	.STRING	"COIN2",0
	.EVEN

CENTER
	.STRING	"COIN3",0
	.EVEN
FOURTH
	.STRING	"COIN4",0
	.EVEN

SLAM
	.STRING	"SLAM - TILT",0
	.EVEN
TEST
	.STRING	"TEST",0
	.EVEN
VIDEO
	.STRING	"VIDEO FREEZE",0
	.EVEN



**************************************************************************
*								         *
* 	MONITOR TEST DATA AREA						 *
*								         *
**************************************************************************

MON_VECS:
	VECMAC	COLOR_WHITE,004,004,396,004
	VECMAC	COLOR_WHITE,004,004,004,250
	VECMAC	COLOR_WHITE,004,250,396,250
	VECMAC	COLOR_WHITE,396,250,396,004
	VECMAC	COLOR_WHITE,060,005,060,250
	VECMAC	COLOR_WHITE,115,005,115,250
	VECMAC	COLOR_WHITE,170,005,170,250
	VECMAC	COLOR_WHITE,225,005,225,250
	VECMAC	COLOR_WHITE,280,005,280,250
	VECMAC	COLOR_WHITE,335,005,335,250
	VECMAC	COLOR_WHITE,005,54,396,54
	VECMAC	COLOR_WHITE,005,103,396,103
	VECMAC	COLOR_WHITE,005,152,396,152
	VECMAC	COLOR_WHITE,005,201,396,201
	.LONG	0

MON_RECS:
	VECMAC	COLOR_RED,182,000,030,005	; TOP
	VECMAC	COLOR_GREEN,182,005,030,006
	VECMAC	COLOR_RED,182,250,030,005	; BOTTOM
	VECMAC	COLOR_GREEN,182,244,030,006
	VECMAC	COLOR_RED,000,117,005,020	; LEFT
	VECMAC	COLOR_GREEN,005,117,006,020
	VECMAC	COLOR_RED,396,117,005,020	; RIGHT
	VECMAC	COLOR_GREEN,390,117,006,020
	.LONG	0

MON_DOTS:
	DOTMAC	COLOR_WHITE,032,029
	DOTMAC	COLOR_WHITE,087,029
	DOTMAC	COLOR_WHITE,142,029
	DOTMAC	COLOR_WHITE,197,029
	DOTMAC	COLOR_WHITE,252,029
	DOTMAC	COLOR_WHITE,307,029
	DOTMAC	COLOR_WHITE,362,029

	DOTMAC	COLOR_WHITE,032,078
	DOTMAC	COLOR_WHITE,087,078
	DOTMAC	COLOR_WHITE,142,078
	DOTMAC	COLOR_WHITE,197,078
	DOTMAC	COLOR_WHITE,252,078
	DOTMAC	COLOR_WHITE,307,078
	DOTMAC	COLOR_WHITE,362,078

	DOTMAC	COLOR_WHITE,032,127
	DOTMAC	COLOR_WHITE,087,127
	DOTMAC	COLOR_WHITE,142,127
	DOTMAC	COLOR_WHITE,197,127
	DOTMAC	COLOR_WHITE,252,127
	DOTMAC	COLOR_WHITE,307,127
	DOTMAC	COLOR_WHITE,362,127

	DOTMAC	COLOR_WHITE,032,176
	DOTMAC	COLOR_WHITE,087,176
	DOTMAC	COLOR_WHITE,142,176
	DOTMAC	COLOR_WHITE,197,176
	DOTMAC	COLOR_WHITE,252,176
	DOTMAC	COLOR_WHITE,307,176
	DOTMAC	COLOR_WHITE,362,176

	DOTMAC	COLOR_WHITE,032,225
	DOTMAC	COLOR_WHITE,087,225
	DOTMAC	COLOR_WHITE,142,225
	DOTMAC	COLOR_WHITE,197,225
	DOTMAC	COLOR_WHITE,252,225
	DOTMAC	COLOR_WHITE,307,225
	DOTMAC	COLOR_WHITE,362,225
	.LONG	0

PRIMARY_COLORS:

	RECTMAC	COLOR_RED,0,0,395,255
	RECTMAC	COLOR_GREEN,0,0,395,255
	RECTMAC	COLOR_BLUE,0,0,395,255
	.LONG	0

COLOR_BARS:

        RECTMAC	COLOR_BLACK,   0, 0, 49, 16
        RECTMAC	COLOR_BLACK,  49, 0, 49, 16
        RECTMAC	COLOR_BLACK,  98, 0, 49, 16
        RECTMAC	COLOR_BLACK, 147, 0, 49, 16
        RECTMAC	COLOR_BLACK, 196, 0, 49, 16
        RECTMAC	COLOR_BLACK, 245, 0, 49, 16
        RECTMAC	COLOR_BLACK, 294, 0, 49, 16
        RECTMAC	COLOR_BLACK, 343, 0, 49, 16
	.LONG	0




**************************************************************************
*								         *
* 	DIP SWITCH DISPLAY STUFF					 *
*								         *
**************************************************************************

DIP_VECS:
	VECMAC	COLOR_RED,20,32,60,32		; DS1
	VECMAC	COLOR_RED,20,32,20,138
	VECMAC	COLOR_RED,20,138,60,138
	VECMAC	COLOR_RED,60,32,60,138

	VECMAC	COLOR_RED,230,32,270,32	; DS2
	VECMAC	COLOR_RED,230,32,230,138
	VECMAC	COLOR_RED,230,138,270,138
	VECMAC	COLOR_RED,270,32,270,138

	VECMAC	COLOR_WHITE,63,42,73,42

	VECMAC	COLOR_WHITE,63,54,73,54

	VECMAC	COLOR_WHITE,63,66,68,66
	VECMAC	COLOR_WHITE,63,90,68,90
	VECMAC	COLOR_WHITE,68,66,68,90
	VECMAC	COLOR_WHITE,68,78,73,78

	VECMAC	COLOR_WHITE,63,102,68,102
	VECMAC	COLOR_WHITE,63,126,68,126
	VECMAC	COLOR_WHITE,68,102,68,126
	VECMAC	COLOR_WHITE,68,114,73,114

	VECMAC	COLOR_WHITE,273,42,278,42	;COUNTRY
	VECMAC	COLOR_WHITE,273,54,278,54
	VECMAC	COLOR_WHITE,278,42,278,54
	VECMAC	COLOR_WHITE,278,48,283,48

	VECMAC	COLOR_WHITE,273,66,283,66	;UNUSED
	VECMAC	COLOR_WHITE,273,78,283,78	;# OF COIN COUNTERS

	VECMAC	COLOR_WHITE,273,90,278,90	;# OF PLAYERS
	VECMAC	COLOR_WHITE,273,102,278,102
	VECMAC	COLOR_WHITE,278,90,278,102
	VECMAC	COLOR_WHITE,278,96,283,96

	VECMAC	COLOR_WHITE,273,114,283,114	;VIDEO FREEZE
	VECMAC	COLOR_WHITE,273,126,283,126	;TEST SWITCH

	.LONG	0

DIP_STRS:
	STR_MAC	124,8,DP_TITLE,COLOR_GREEN,0
   	STR_MAC	30,20,DP_DS1,COLOR_WHITE,0
	STR_MAC	240,20,DP_DS2,COLOR_WHITE,0
	STR_MAC	7,39,DP_DSN1,COLOR_WHITE,0
	STR_MAC	7,51,DP_DSN2,COLOR_WHITE,0
	STR_MAC	7,63,DP_DSN3,COLOR_WHITE,0
	STR_MAC	7,75,DP_DSN4,COLOR_WHITE,0
	STR_MAC	7,87,DP_DSN5,COLOR_WHITE,0
	STR_MAC	7,99,DP_DSN6,COLOR_WHITE,0
	STR_MAC	7,111,DP_DSN7,COLOR_WHITE,0
	STR_MAC	7,123,DP_DSN8,COLOR_WHITE,0

	STR_MAC	217,39,DP_DSN1,COLOR_WHITE,0
	STR_MAC	217,51,DP_DSN2,COLOR_WHITE,0
	STR_MAC	217,63,DP_DSN3,COLOR_WHITE,0
	STR_MAC	217,75,DP_DSN4,COLOR_WHITE,0
	STR_MAC	217,87,DP_DSN5,COLOR_WHITE,0
	STR_MAC	217,99,DP_DSN6,COLOR_WHITE,0
	STR_MAC	217,111,DP_DSN7,COLOR_WHITE,0
	STR_MAC	217,123,DP_DSN8,COLOR_WHITE,0

	STR_MAC	100,150,DP_INS1,COLOR_WHITE,0

	.LONG	0

DP_DS1:
	.STRING	"U105",0
	.EVEN
DP_DS2:
	.STRING	"U108",0
	.EVEN

DP_DSN1
	.STRING	"1",0
	.EVEN
DP_DSN2
	.STRING	"2",0
	.EVEN
DP_DSN3
	.STRING	"3",0
	.EVEN
DP_DSN4
	.STRING	"4",0
	.EVEN
DP_DSN5
	.STRING	"5",0
	.EVEN
DP_DSN6
	.STRING	"6",0
	.EVEN
DP_DSN7
	.STRING	"7",0
	.EVEN
DP_DSN8
	.STRING	"8",0
	.EVEN

DUSECMOS_1:
	.STRING	"CMOS COINAGE",0
	.EVEN

DUSECMOS_0:
	.STRING	"DIPSWITCH COINAGE",0
	.EVEN

DMIRROR_0
	.STRING	"MIRROR DISPLAY",0
	.EVEN

DMIRROR_1
	.STRING	"NORMAL DISPLAY",0
	.EVEN

DCOUNTER_0
	.STRING	"ONE COUNTER",0
	.EVEN

DCOUNTER_1
	.STRING	"TWO COUNTERS",0
	.EVEN

DCOINAGE
	.STRING	"COINAGE",0
	.EVEN

DCOUNTRY_0
	.STRING	"USA",0
	.EVEN
DCOUNTRY_2
	.STRING	"FRENCH",0
	.EVEN


DFREEZE_0
	.STRING	"VIDEO FREEZE",0
	.EVEN

DPLAYER_TAB
	.LONG	DPLAYER_0, DPLAYER_1, DPLAYER_2, DPLAYER_3

	.IF GERMAN
DCOUNTRY_1
	.STRING	"DEUTSCH",0
	.EVEN

DCOUNTRY_TAB
	.LONG	DCOUNTRY_1, DCOUNTRY_0, DCOUNTRY_2, DCOUNTRY_3

DCREDITS
	.STRING	"KREDITE...",0
	.EVEN
DTOSTART
	.STRING	"BEI SPIELBEGINN",0
	.EVEN
DTOCONTINUE
	.STRING	"ZUR SPIELFORTSET.",0
	.EVEN

DTEST_0
	.STRING	"TEST",0
	.EVEN

DPLAYER_0
	.STRING	"3 SPIELER",0
	.EVEN
DPLAYER_1
	.STRING	"2 SPIELER",0
	.EVEN
DPLAYER_2
	.STRING	"1 SPIELER",0
	.EVEN
DPLAYER_3
	.STRING	"1 SPIELER",0
	.EVEN

DUCOIN7
	.STRING	"FREISPIEL",0
	.EVEN

DCOINTAB
	.LONG	DGCOINTAB, DUCOINTAB, DFCOINTAB, DUCOINTAB

DP_TITLE
	.STRING	"DIP-SCHALTER-TEST",0
	.EVEN

DP_INS1
	.STRING	"BELIEBIGEN KNOPF DRUECKEN",0
	.EVEN

DP_ON
	.STRING	"EIN",0
	.EVEN
DP_OFF
	.STRING	"AUS",0

	.ELSE
DCOUNTRY_1
	.STRING	"GERMAN",0
	.EVEN

DCOUNTRY_TAB
	.LONG	DCOUNTRY_0, DCOUNTRY_1, DCOUNTRY_2, DCOUNTRY_3

DCREDITS
	.STRING	"CREDITS...",0
	.EVEN
DTOSTART
	.STRING	"TO START",0
	.EVEN
DTOCONTINUE
	.STRING	"TO CONTINUE",0
	.EVEN

DTEST_0
	.STRING	"TEST SWITCH",0
	.EVEN

DPLAYER_0
	.STRING	"3 PLAYER",0
	.EVEN
DPLAYER_1
	.STRING	"2 PLAYER",0
	.EVEN
DPLAYER_2
	.STRING	"1 PLAYER",0
	.EVEN
DPLAYER_3
	.STRING	"1 PLAYER",0
	.EVEN

DUCOIN7
	.STRING	"FREEPLAY",0
	.EVEN

DCOINTAB
	.LONG	DUCOINTAB, DGCOINTAB, DFCOINTAB, DUCOINTAB

DP_TITLE
	.STRING	"DIPSWITCH SETTINGS",0
	.EVEN

DP_INS1
	.STRING	"PRESS ANY BUTTON TO EXIT",0
	.EVEN

DP_ON
	.STRING	"ON",0
	.EVEN
DP_OFF
	.STRING	"OFF",0

	.ENDIF


DUNUSED
DGCOIN4
DCOUNTRY_3
	.STRING	"UNUSED",0
	.EVEN

DUCOINTAB
	.LONG	USA_1,USA_2,USA_3,USA_4,USA_ELECTITLE,DGCOIN4
	.LONG	DGCOIN4,DUCOIN7

DGCOINTAB
	.LONG	GERMAN_1,GERMAN_2,GERMAN_3,GERMAN_4,GERMAN_ELECTITLE
	.LONG	DGCOIN4,DGCOIN4,DUCOIN7

DFCOINTAB
	.LONG	FRENCH_1,FRENCH_2,FRENCH_3,FRENCH_4,FRENCH_ELECTITLE
	.LONG	DGCOIN4,DGCOIN4,DUCOIN7

DCREDTAB
	.LONG	DP_DSN2,DP_DSN1
	.LONG	DP_DSN1,DP_DSN1
	.LONG	DP_DSN2,DP_DSN2
	.LONG	DP_DSN3,DP_DSN1
	.LONG	DP_DSN4,DP_DSN1
	.LONG	DP_DSN3,DP_DSN2
	.LONG	DP_DSN4,DP_DSN2
	.LONG	DP_DSN3,DP_DSN3


	.if	XUNIT=1
**************************************************************************
*								         *
* 	CPU BOARD INFORMATION						 *
*								         *
**************************************************************************

CPU_VECS:		       
	VECMAC	COLOR_WHITE,5,15,390,15		; BOARD OUTLINE
	VECMAC	COLOR_WHITE,390,15,390,254
	VECMAC	COLOR_WHITE,5,253,390,253
	VECMAC	COLOR_WHITE,5,15,5,100
	VECMAC	COLOR_WHITE,5,100,15,100
	VECMAC	COLOR_WHITE,15,100,15,115
	VECMAC	COLOR_WHITE,5,115,15,115
	VECMAC	COLOR_WHITE,5,115,5,135
	VECMAC	COLOR_WHITE,5,135,15,135
	VECMAC	COLOR_WHITE,15,135,15,138
	VECMAC	COLOR_WHITE,5,138,15,138
	VECMAC	COLOR_WHITE,5,138,5,215
	VECMAC	COLOR_WHITE,5,215,15,215
	VECMAC	COLOR_WHITE,15,215,15,230
	VECMAC	COLOR_WHITE,5,230,15,230
	VECMAC	COLOR_WHITE,5,230,5,254
	.LONG	0

CPUXBASE	EQU	5
CPUYBASE	EQU	5


CPU_CHIPS:
CRAM1	CHIPMAC	0,125,25,20,45,7,11,CNAMEA8,1,2,2,1	; COLOR RAM
CRAM2	CHIPMAC	1,125,75,20,45,7,11,CNAMEC8,1,2,2,1	; COLOR RAM

VRAM1	CHIPMAC	2,190,25,15,38,6,2,CNAMEA11,1,2,2,1	; BANK 1 VIDEO RAM
VRAM2	CHIPMAC	3,207,25,15,38,6,2,CNAMEA12,1,2,2,1	;   (PALETTE)
VRAM3	CHIPMAC	4,224,25,15,38,6,2,CNAMEA13,1,2,2,1
VRAM4	CHIPMAC	5,241,25,15,38,6,2,CNAMEA14,1,2,2,1

VRAM5	CHIPMAC	6,190,71,15,38,6,2,CNAMEB11,1,2,2,1	; BANK 2 VIDEO RAM
VRAM6	CHIPMAC	7,207,71,15,38,6,2,CNAMEB12,1,2,2,1	;   (PIXEL)
VRAM7	CHIPMAC	8,224,71,15,38,6,2,CNAMEB13,1,2,2,1
VRAM8	CHIPMAC	9,241,71,15,38,6,2,CNAMEB14,1,2,2,1

CPU	CHIPMAC	0,330,60,35,35,4,13,CNAMEB21,0,3,3,1	; CPU

DMA	CHIPMAC	0,201,120,38,38,6,16,CNAMEE13,0,3,3,1	; DMA

PROM1	CHIPMAC	1,155,210,20,40,7,3,CNAMEJ12,1,2,2,1	; PROGRAM ROM 1
PROM2	CHIPMAC	0,155,167,20,40,7,3,CNAMEG12,1,2,2,1	; PROGRAM ROM 2

IROM1	CHIPMAC	1,195,167,20,40,7,3,CNAMEG14,1,2,2,1	; IMAGE ROM
IROM2	CHIPMAC	2,217,167,20,40,7,3,CNAMEG16,1,2,2,1	; IMAGE ROM
IROM3	CHIPMAC	3,239,167,20,40,7,3,CNAMEG17,1,2,2,1	; IMAGE ROM
IROM4	CHIPMAC	4,261,167,20,40,7,3,CNAMEG18,1,2,2,1	; IMAGE ROM

IROM5	CHIPMAC	5,283,167,20,40,7,3,CNAMEG19,1,2,2,1	; IMAGE ROM
IROM6	CHIPMAC	6,305,167,20,40,7,3,CNAMEG20,1,2,2,1	; IMAGE ROM
IROM7	CHIPMAC	7,327,167,20,40,7,3,CNAMEG22,1,2,2,1	; IMAGE ROM
IROM8	CHIPMAC	8,349,167,20,40,7,3,CNAMEG23,1,2,2,1	; IMAGE ROM

IROM9	CHIPMAC	9,195,210,20,40,7,3,CNAMEJ14,1,2,2,1	; IMAGE ROM
IROM10	CHIPMAC	10,217,210,20,40,7,3,CNAMEJ16,1,2,2,1	; IMAGE ROM
IROM11	CHIPMAC	11,239,210,20,40,7,3,CNAMEJ17,1,2,2,1	; IMAGE ROM
IROM12	CHIPMAC	12,261,210,20,40,7,3,CNAMEJ18,1,2,2,1	; IMAGE ROM

IROM13	CHIPMAC	13,283,210,20,40,7,3,CNAMEJ19,1,2,2,1	; IMAGE ROM
IROM14	CHIPMAC	14,305,210,20,40,7,3,CNAMEJ20,1,2,2,1	; IMAGE ROM
IROM15	CHIPMAC	15,327,210,20,40,7,3,CNAMEJ22,1,2,2,1	; IMAGE ROM
IROM16	CHIPMAC	16,349,210,20,40,7,3,CNAMEJ23,1,2,2,1	; IMAGE ROM

SRAM1	CHIPMAC	0,50,210,13,33,4,4,CNAMEJ4,1,2,2,1	; SCRATCH PAD
SRAM2	CHIPMAC	1,67,210,13,33,4,4,CNAMEJ5,1,2,2,1	; SCRATCH PAD
SRAM3	CHIPMAC	2,84,210,13,33,4,4,CNAMEJ6,1,2,2,1	; SCRATCH PAD
SRAM4	CHIPMAC	3,101,210,13,33,4,4,CNAMEJ7,1,2,2,1	; SCRATCH PAD
	.LONG	0

VRAMTAB	.LONG	CRAM1,CRAM2
	.LONG	VRAM1,VRAM2,VRAM3,VRAM4,VRAM5,VRAM6
	.LONG	VRAM7,VRAM8
	.LONG	0
PROMTAB	.LONG	PROM1,PROM2
	.LONG	0
IROMTAB	.LONG	IROM1,IROM2,IROM3,IROM4
	.LONG	IROM5,IROM6,IROM7,IROM8
	.LONG	IROM9,IROM10,IROM11,IROM12
	.LONG	IROM13,IROM14,IROM15,IROM16
	.LONG	0
SRAMTAB	.LONG	SRAM1,SRAM2,SRAM3,SRAM4
	.LONG	0
	
CNAMEA8
	.STRING	"UA8",0
	.EVEN
CNAMEA11	
	.STRING	"UA11",0
	.EVEN
CNAMEA12	
	.STRING	"UA12",0
	.EVEN
CNAMEA13	
	.STRING	"UA13",0
	.EVEN
CNAMEA14	
	.STRING	"UA14",0
	.EVEN
CNAMEC8
	.STRING	"UC8",0
	.EVEN
CNAMEB11
	.STRING	"UB11",0
	.EVEN
CNAMEB12
	.STRING	"UB12",0
	.EVEN
CNAMEB13
	.STRING	"UB13",0
	.EVEN
CNAMEB14
	.STRING	"UB14",0
	.EVEN
CNAMEB21
	.STRING	"UB21",0
	.EVEN
CNAME49
	.STRING	"U49",0
	.EVEN
CNAMEJ4
	.STRING	"UJ4",0
	.EVEN
CNAMEJ5
	.STRING	"UJ5",0
	.EVEN
CNAMEJ6
	.STRING	"UJ6",0
	.EVEN
CNAMEJ7
	.STRING	"UJ7",0
	.EVEN
CNAMEG12	
	.STRING	"UG12",0
	.EVEN
CNAMEG14
	.STRING	"UG14",0
	.EVEN
CNAMEG16	
	.STRING	"UG16",0
	.EVEN
CNAMEG17
	.STRING	"UG17",0
	.EVEN
CNAMEG18	
	.STRING	"UG18",0
	.EVEN
CNAMEG19	
	.STRING	"UG19",0
	.EVEN
CNAMEG20	
	.STRING	"UG20",0
	.EVEN
CNAMEG22	
	.STRING	"UG22",0
	.EVEN
CNAMEG23	
	.STRING	"UG23",0
	.EVEN
CNAMEE13
	.STRING	"UE13",0
	.EVEN
CNAMEJ12
	.STRING	"UJ12",0
	.EVEN
CNAMEJ14
       	.STRING	"UJ14",0
	.EVEN
CNAMEJ16
	.STRING	"UJ16",0
	.EVEN
CNAMEJ17
	.STRING	"UJ17",0
	.EVEN
CNAMEJ18
	.STRING	"UJ18",0
	.EVEN
CNAMEJ19
	.STRING	"UJ19",0
	.EVEN
CNAMEJ20
	.STRING	"UJ20",0
	.EVEN
CNAMEJ22
	.STRING	"UJ22",0
	.EVEN
CNAMEJ23
	.STRING	"UJ23",0
	.EVEN
CNAME115
	.STRING	"U115",0
	.EVEN


**************************************************************************
*								         *
* 	RAM CHIP DATA							 *
*								         *
**************************************************************************

;
;	MAKE SURE THESE TABLES CORRESPOND WITH THE STUFF ABOVE
;

VRAMCHIPS:
;	COLOR RAMS

	RAM_CHIP 0,0, 8, 16, 1800000H, 187FFF0H		; UA8  (  0 - 3  )
	RAM_CHIP 0,1, 8, 16, 1800008H, 187FFF8H		; UC8  (  8 - 11 )

;	VIDEO RAMS
;	RAM_CHIP $MACRO TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR 		

	RAM_CHIP 0, 6, 8, 32, 0000018H, 03FFFF8H	; UB11 ( 24 - 27 )
	RAM_CHIP 0, 8, 8, 32, 0000010H, 03FFFF0H	; UB13 ( 16 - 19 )
	RAM_CHIP 0, 7, 8, 32, 0000008H, 03FFFE8H	; UB12 (  8 - 11 )
	RAM_CHIP 0, 9, 8, 32, 0000000H, 03FFFE0H	; UB14 (  0 - 3  )

	.LONG	0

PALCHIPS:
;	VIDEO PALETTE RAMS
;	RAM_CHIP $MACRO TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR 		

	RAM_CHIP 0,2, 8, 32, 0800018H, 0BFFFF8H		; UA11 (  24 - 27 )
	RAM_CHIP 0,4, 8, 32, 0800010H, 0BFFFF0H		; UA13 (  16 - 19  )
	RAM_CHIP 0,3, 8, 32, 0800008H, 0BFFFE8H		; UA12 (  8 - 11 )
	RAM_CHIP 0,5, 8, 32, 0800000H, 0BFFFE0H		; UA14 (  0 - 3  )

	.LONG	0

;	SCRATCH RAMS

SRAMCHECK
	.STRING	"CHECKING SCRATCH RAMS",0
	.EVEN

SRAMCHIPS			    ;  ???XUNIT???   needs to change
	RAM_CHIP SRAM4,3, 4, 16, 1000004H, 13FFFF4H	; UJ7 (  4 - 7  )
	RAM_CHIP SRAM3,2, 4, 16, 1000000H, 13FFFF0H	; UJ6 (  0 - 3  )
	RAM_CHIP SRAM2,1, 4, 16, 1000008H, 13FFFF8H	; UJ5 (  8 - 11 )
	RAM_CHIP SRAM1,0, 4, 16, 100000CH, 13FFFFCH	; UJ4 ( 12 - 15 )

	.LONG	0

PROMCHIPS		 	    ;  ???XUNIT???   needs to change
	ROM_CHIP PROM1,0,0,16, 0FF800000H, 0FFFFFFF0H, 0FFFFH	; UJ12
	ROM_CHIP PROM2,1,0,16, 0FF800008H, 0FFFFFFF8H, 0FFFFH	; UG12
	.LONG	0

	.if XUNIT=1
	.SECT	"CKSUMS"
	.endif
CHECKSUM0
	.WORD	0FFFFH		;UJ12 CHECKSUM
CHECKSUM1
	.WORD	0FFFFH		;UG12 CHECKSUM

* CHECKSUM PATCHES
	.WORD	0H		;1'S COMPLEMENT OF THE UJ12 CHECKSUM
	.WORD	0H		;1'S COMPLEMENT OF THE UG12 CHECKSUM

	.TEXT

**************************************************************************
*								         *
* 		     IMAGE ROM CHECKSUM TABLES				 *
* 									 *
* 		NOTE: COMMENT OUT ANY UNSTUFFED PARTS THAT		 *
* 			EXIST BEFORE THE .LONG 0 TERMINATOR!		 *
*								         *
**************************************************************************
;	ROM_CHIP $MACRO TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR, CHECK_SUM
IROMCHIPS
	.EVEN
	ROM_CHIP IROM1,  1, 8,32,  2000000H, 2FFFFE0H, 0FFFFH	; UG14
	ROM_CHIP IROM9,  9, 8,32,  2000008H, 2FFFFE8H, 0FFFFH	; UJ14
	ROM_CHIP IROM5,  5, 8,32,  2000010H, 2FFFFF0H, 0FFFFH	; UG19 
	ROM_CHIP IROM13,13, 8,32,  2000018H, 2FFFFF8H, 0FFFFH	; UJ19 

	ROM_CHIP IROM2,  2, 8,32,  3000000H, 3FFFFE0H, 0FFFFH	; UG16
	ROM_CHIP IROM10,10, 8,32,  3000008H, 3FFFFE8H, 0FFFFH	; UJ16
	ROM_CHIP IROM6,  6, 8,32,  3000010H, 3FFFFF0H, 0FFFFH	; UG20
	ROM_CHIP IROM14,14, 8,32,  3000018H, 3FFFFF8H, 0FFFFH	; UJ20

	ROM_CHIP IROM3,  3, 8,32,  4000000H, 4FFFFE0H, 0FFFFH	; UG17
	ROM_CHIP IROM11,11, 8,32,  4000008H, 4FFFFE8H, 0FFFFH	; UJ17
	ROM_CHIP IROM7,  7, 8,32,  4000010H, 4FFFFF0H, 0FFFFH	; UG22
	ROM_CHIP IROM15,15, 8,32,  4000018H, 4FFFFF8H, 0FFFFH	; UJ22

	ROM_CHIP IROM4,  4, 8,32,  5000000H, 5FFFFE0H, 0FFFFH	; UG18
	ROM_CHIP IROM12,12, 8,32,  5000008H, 5FFFFE8H, 0FFFFH	; UJ18
	ROM_CHIP IROM8,  8, 8,32,  5000010H, 5FFFFF0H, 0FFFFH	; UG23
	ROM_CHIP IROM16,16, 8,32,  5000018H, 5FFFFF8H, 0FFFFH	; UJ23

	.LONG	0		; FORCE IT TO STOP HERE

	.else

**************************************************************************
*								         *
* 	CPU BOARD INFORMATION						 *
*								         *
**************************************************************************

CPU_VECS:
;	VECMAC	COLOR_WHITE,5,15,390,15		; BOARD OUTLINE
;	VECMAC	COLOR_WHITE,390,15,390,254
;	VECMAC	COLOR_WHITE,5,253,390,253
;	VECMAC	COLOR_WHITE,5,15,5,100
;	VECMAC	COLOR_WHITE,5,100,15,100
;	VECMAC	COLOR_WHITE,15,100,15,115
;	VECMAC	COLOR_WHITE,5,115,15,115
;	VECMAC	COLOR_WHITE,5,115,5,135
;	VECMAC	COLOR_WHITE,5,135,15,135
;	VECMAC	COLOR_WHITE,15,135,15,138
;	VECMAC	COLOR_WHITE,5,138,15,138
;	VECMAC	COLOR_WHITE,5,138,5,215
;	VECMAC	COLOR_WHITE,5,215,15,215
;	VECMAC	COLOR_WHITE,15,215,15,230
;	VECMAC	COLOR_WHITE,5,230,15,230
;	VECMAC	COLOR_WHITE,5,230,5,254

	VECMAC	COLOR_WHITE,5,5,5,243		; BOARD OUTLINE
	VECMAC	COLOR_WHITE,5,243,390,243
	VECMAC	COLOR_WHITE,390,243,390,5
	VECMAC	COLOR_WHITE,390,5,355,5
	VECMAC	COLOR_WHITE,355,5,355,10
	VECMAC	COLOR_WHITE,355,10,343,10
	VECMAC	COLOR_WHITE,343,10,343,5
	VECMAC	COLOR_WHITE,343,5,326,5
	VECMAC	COLOR_WHITE,326,5,326,10
	VECMAC	COLOR_WHITE,326,10,323,10
	VECMAC	COLOR_WHITE,323,10,323,5
	VECMAC	COLOR_WHITE,323,5,212,5
	VECMAC	COLOR_WHITE,212,5,212,10
	VECMAC	COLOR_WHITE,212,10,200,10
	VECMAC	COLOR_WHITE,200,10,200,5
	VECMAC	COLOR_WHITE,200,5,5,5
	.LONG	0

CPUXBASE	EQU	5
CPUYBASE	EQU	5


CPU_CHIPS:
;CRAM1	CHIPMAC	0,125,25,20,45,7,11,CNAMEA8,1,2,2,1	; COLOR RAM
;CRAM2	CHIPMAC	1,125,75,20,45,7,11,CNAMEC8,1,2,2,1	; COLOR RAM

;VRAM1	CHIPMAC	2,190,25,15,38,6,2,CNAMEA11,1,2,2,1	; BANK 1 VIDEO RAM
;VRAM2	CHIPMAC	3,207,25,15,38,6,2,CNAMEA12,1,2,2,1	;   (PALETTE)
;VRAM3	CHIPMAC	4,224,25,15,38,6,2,CNAMEA13,1,2,2,1
;VRAM4	CHIPMAC	5,241,25,15,38,6,2,CNAMEA14,1,2,2,1

;VRAM5	CHIPMAC	6,190,71,15,38,6,2,CNAMEB11,1,2,2,1	; BANK 2 VIDEO RAM
;VRAM6	CHIPMAC	7,207,71,15,38,6,2,CNAMEB12,1,2,2,1	;   (PIXEL)
;VRAM7	CHIPMAC	8,224,71,15,38,6,2,CNAMEB13,1,2,2,1
;VRAM8	CHIPMAC	9,241,71,15,38,6,2,CNAMEB14,1,2,2,1

;CPU	CHIPMAC	0,330,60,35,35,4,13,CNAMEB21,0,3,3,1	; CPU

;DMA	CHIPMAC	0,201,120,38,38,6,16,CNAMEE13,0,3,3,1	; DMA

;PROM1	CHIPMAC	1,155,210,20,40,7,3,CNAMEJ12,1,2,2,1	; PROGRAM ROM 1
;PROM2	CHIPMAC	0,155,167,20,40,7,3,CNAMEG12,1,2,2,1	; PROGRAM ROM 2

;IROM1	CHIPMAC	1,195,167,20,40,7,3,CNAMEG14,1,2,2,1	; IMAGE ROM
;IROM2	CHIPMAC	2,217,167,20,40,7,3,CNAMEG16,1,2,2,1	; IMAGE ROM
;IROM3	CHIPMAC	3,239,167,20,40,7,3,CNAMEG17,1,2,2,1	; IMAGE ROM
;IROM4	CHIPMAC	4,261,167,20,40,7,3,CNAMEG18,1,2,2,1	; IMAGE ROM

;IROM5	CHIPMAC	5,283,167,20,40,7,3,CNAMEG19,1,2,2,1	; IMAGE ROM
;IROM6	CHIPMAC	6,305,167,20,40,7,3,CNAMEG20,1,2,2,1	; IMAGE ROM
;IROM7	CHIPMAC	7,327,167,20,40,7,3,CNAMEG22,1,2,2,1	; IMAGE ROM
;IROM8	CHIPMAC	8,349,167,20,40,7,3,CNAMEG23,1,2,2,1	; IMAGE ROM

;IROM9	CHIPMAC	9,195,210,20,40,7,3,CNAMEJ14,1,2,2,1	; IMAGE ROM
;IROM10	CHIPMAC	10,217,210,20,40,7,3,CNAMEJ16,1,2,2,1	; IMAGE ROM
;IROM11	CHIPMAC	11,239,210,20,40,7,3,CNAMEJ17,1,2,2,1	; IMAGE ROM
;IROM12	CHIPMAC	12,261,210,20,40,7,3,CNAMEJ18,1,2,2,1	; IMAGE ROM

;IROM13	CHIPMAC	13,283,210,20,40,7,3,CNAMEJ19,1,2,2,1	; IMAGE ROM
;IROM14	CHIPMAC	14,305,210,20,40,7,3,CNAMEJ20,1,2,2,1	; IMAGE ROM
;IROM15	CHIPMAC	15,327,210,20,40,7,3,CNAMEJ22,1,2,2,1	; IMAGE ROM
;IROM16	CHIPMAC	16,349,210,20,40,7,3,CNAMEJ23,1,2,2,1	; IMAGE ROM

;SRAM1	CHIPMAC	0,50,210,13,33,4,4,CNAMEJ4,1,2,2,1	; SCRATCH PAD
;SRAM2	CHIPMAC	1,67,210,13,33,4,4,CNAMEJ5,1,2,2,1	; SCRATCH PAD
;SRAM3	CHIPMAC	2,84,210,13,33,4,4,CNAMEJ6,1,2,2,1	; SCRATCH PAD
;SRAM4	CHIPMAC	3,101,210,13,33,4,4,CNAMEJ7,1,2,2,1	; SCRATCH PAD


CRAM1	CHIPMAC	0,347,152,30,13,5,3,CNAMEU36,0,28,2,1	; COLOR RAM (U36)
CRAM2	CHIPMAC	1,313,152,30,13,5,3,CNAMEU37,0,28,2,1	; COLOR RAM (U37)

VRAM1	CHIPMAC	2,347,207,38,13,8,3,CNAMEU14,0,36,2,1	; BANK 1 VIDEO RAM (U14)
VRAM2	CHIPMAC	3,307,207,38,13,8,3,CNAMEU15,0,36,2,1	;   (PALETTE) (U15)
VRAM3	CHIPMAC	4,267,207,38,13,8,3,CNAMEU16,0,36,2,1	; (U16)
VRAM4	CHIPMAC	5,227,207,38,13,8,3,CNAMEU17,0,36,2,1	; (U17)

VRAM5	CHIPMAC	6,347,225,38,13,8,3,CNAMEU10,0,36,2,1	; BANK 2 VIDEO RAM (U10)
VRAM6	CHIPMAC	7,307,225,38,13,8,3,CNAMEU11,0,36,2,1	;   (PIXEL) (U11)
VRAM7	CHIPMAC	8,267,225,38,13,8,3,CNAMEU12,0,36,2,1	; (U12)
VRAM8	CHIPMAC	9,227,225,38,13,8,3,CNAMEU13,0,36,2,1	; (U13)

CPU	CHIPMAC	0,330,50,35,35,7,13,CNAMEU59,0,3,3,1	; CPU (U59)

DMA	CHIPMAC	0,246,157,38,38,8,16,CNAMEU33,0,3,3,1	; DMA (U33)

PROM1	CHIPMAC	1,220,65,40,13,9,3,CNAMEU63,0,38,2,1	; PROGRAM ROM 1 (U63)
PROM2	CHIPMAC	0,220,83,40,13,9,3,CNAMEU54,0,38,2,1	; PROGRAM ROM 2 (U54)

IROM1	CHIPMAC	1,10,122,40,13,6,3,  CNAMEU133,0,38,2,1	; IMAGE ROM (U133)
IROM2	CHIPMAC	2,52,122,40,13,6,3,  CNAMEU132,0,38,2,1	; IMAGE ROM (U132)
IROM3	CHIPMAC	3,94,122,40,13,6,3,  CNAMEU131,0,38,2,1	; IMAGE ROM (U131)
IROM4	CHIPMAC	4,136,122,40,13,6,3, CNAMEU130,0,38,2,1	; IMAGE ROM (U130)

IROM5	CHIPMAC	5,10,137,40,13,6,3,  CNAMEU129,0,38,2,1	; IMAGE ROM (U129)
IROM6	CHIPMAC	6,52,137,40,13,6,3,  CNAMEU128,0,38,2,1	; IMAGE ROM (U128)
IROM7	CHIPMAC	7,94,137,40,13,6,3,  CNAMEU127,0,38,2,1	; IMAGE ROM (U127)
IROM8	CHIPMAC	8,136,137,40,13,6,3, CNAMEU126,0,38,2,1	; IMAGE ROM (U126)

IROM9	CHIPMAC	9,10,152,40,13,6,3,  CNAMEU125,0,38,2,1	; IMAGE ROM (U125)
IROM10	CHIPMAC	10,52,152,40,13,6,3, CNAMEU124,0,38,2,1	; IMAGE ROM (U124)
IROM11	CHIPMAC	11,94,152,40,13,6,3, CNAMEU123,0,38,2,1	; IMAGE ROM (U123)
IROM12	CHIPMAC	12,136,152,40,13,6,3,CNAMEU122,0,38,2,1	; IMAGE ROM (U122)

IROM13	CHIPMAC	13,10,167,40,13,6,3, CNAMEU121,0,38,2,1	; IMAGE ROM (U121)
IROM14	CHIPMAC	14,52,167,40,13,6,3, CNAMEU120,0,38,2,1	; IMAGE ROM (U120)
IROM15	CHIPMAC	15,94,167,40,13,6,3, CNAMEU119,0,38,2,1	; IMAGE ROM (U119)
IROM16	CHIPMAC	16,136,167,40,13,6,3,CNAMEU118,0,38,2,1	; IMAGE ROM (U118)

IROM17	CHIPMAC	17,10,182,40,13,6,3, CNAMEU117,0,38,2,1	; IMAGE ROM (U117)
IROM18	CHIPMAC	18,52,182,40,13,6,3, CNAMEU116,0,38,2,1	; IMAGE ROM (U116)
IROM19	CHIPMAC	19,94,182,40,13,6,3, CNAMEU115,0,38,2,1	; IMAGE ROM (U115)
IROM20	CHIPMAC	20,136,182,40,13,6,3,CNAMEU114,0,38,2,1	; IMAGE ROM (U114)

IROM21	CHIPMAC	21,10,197,40,13,6,3, CNAMEU113,0,38,2,1	; IMAGE ROM (U113)
IROM22	CHIPMAC	22,52,197,40,13,6,3, CNAMEU112,0,38,2,1	; IMAGE ROM (U112)
IROM23	CHIPMAC	23,94,197,40,13,6,3, CNAMEU111,0,38,2,1	; IMAGE ROM (U111)
IROM24	CHIPMAC	24,136,197,40,13,6,3,CNAMEU110,0,38,2,1	; IMAGE ROM (U110)

IROM25	CHIPMAC	25,10,212,40,13,6,3, CNAMEU109,0,38,2,1	; IMAGE ROM (U109)
IROM26	CHIPMAC	26,52,212,40,13,6,3, CNAMEU108,0,38,2,1	; IMAGE ROM (U108)
IROM27	CHIPMAC	27,94,212,40,13,6,3, CNAMEU107,0,38,2,1	; IMAGE ROM (U107)
IROM28	CHIPMAC	28,136,212,40,13,6,3,CNAMEU106,0,38,2,1	; IMAGE ROM (U106)

IROM29	CHIPMAC	29,10,227,40,13,6,3, CNAMEU105,0,38,2,1	; IMAGE ROM (U105)
IROM30	CHIPMAC	30,52,227,40,13,6,3, CNAMEU104,0,38,2,1	; IMAGE ROM (U104)
IROM31	CHIPMAC	31,94,227,40,13,6,3, CNAMEU103,0,38,2,1	; IMAGE ROM (U103)
IROM32	CHIPMAC	32,136,227,40,13,6,3,CNAMEU102,0,38,2,1	; IMAGE ROM (U102)

SRAM1	CHIPMAC	0,225,101,30,13,4,3,CNAMEU49,0,28,2,1	; SCRATCH PAD (U49)

PIC	CHIPMAC	0,177,65,40,13,9,3,CNAMEU64,0,38,2,1	; PIC CHIP (U64)

SROM1	CHIPMAC	1,49,57,40,13,14,3, CNAMEU2,0,38,2,1	; Sound Rom (U2)
SROM2	CHIPMAC	2,49,72,40,13,14,3, CNAMEU3,0,38,2,1	; Sound Rom (U3)
SROM3	CHIPMAC	3,49,87,40,13,14,3, CNAMEU4,0,38,2,1	; Sound Rom (U4)
SROM4	CHIPMAC	4,49,102,40,13,14,3,CNAMEU5,0,38,2,1	; Sound Rom (U5)
SROM5	CHIPMAC	5,7,57,40,13,14,3,  CNAMEU6,0,38,2,1	; Sound Rom (U6)
SROM6	CHIPMAC	6,7,72,40,13,14,3,  CNAMEU7,0,38,2,1	; Sound Rom (U7)
SROM7	CHIPMAC	7,7,87,40,13,14,3,  CNAMEU8,0,38,2,1	; Sound Rom (U8)
SROM8	CHIPMAC	8,7,102,40,13,14,3, CNAMEU9,0,38,2,1	; Sound Rom (U9)

DSP	CHIPMAC	0,118,77,35,35,13,13,CNAMEU1,0,3,3,1	; Sound DSP (U1)

SNDRAM1	CHIPMAC	1,115,29,40,13,9,3,CNAMEU86,0,38,2,1	; Sound Ram 1 (U86)
SNDRAM2	CHIPMAC	2,115,44,40,13,9,3,CNAMEU80,0,38,2,1	; Sound Ram 2 (U80)
SNDRAM3	CHIPMAC	3,115,59,40,13,9,3,CNAMEU73,0,38,2,1	; Sound Ram 3 (U73)
	.LONG	0

VRAMTAB	.LONG	CRAM1,CRAM2
	.LONG	VRAM1,VRAM2,VRAM3,VRAM4,VRAM5,VRAM6
	.LONG	VRAM7,VRAM8
	.LONG	0
PROMTAB	.LONG	PROM1,PROM2
	.LONG	0
IROMTAB	.LONG	IROM1,IROM2,IROM3,IROM4
	.LONG	IROM5,IROM6,IROM7,IROM8
	.LONG	IROM9,IROM10,IROM11,IROM12
	.LONG	IROM13,IROM14,IROM15,IROM16
	.long	IROM17,IROM18,IROM19,IROM20
	.long	IROM21,IROM22,IROM23,IROM24
	.long	IROM25,IROM26,IROM27,IROM28
	.long	IROM29,IROM30,IROM31,IROM32
	.LONG	0
;SRAMTAB	.LONG	SRAM1,SRAM2,SRAM3,SRAM4
SRAMTAB	.LONG	SRAM1
	.LONG	0
SROMTAB	.long	SROM1, SROM2, SROM3, SROM4
	.long	SROM5, SROM6, SROM7, SROM8
	.long	0
SNDRAMTAB
	.long	SNDRAM1, SNDRAM2, SNDRAM3
	.long	0
	
CNAMEU1
	.string	"U1",0
	.even
CNAMEU2
	.string	"U2",0
	.even
CNAMEU3
	.string	"U3",0
	.even
CNAMEU4
	.string	"U4",0
	.even
CNAMEU5
	.string	"U5",0
	.even
CNAMEU6
	.string	"U6",0
	.even
CNAMEU7
	.string	"U7",0
	.even
CNAMEU8
	.string	"U8",0
	.even
CNAMEU9
	.string	"U9",0
	.even
CNAMEU10
	.string	"U10",0
	.even
CNAMEU11
	.string	"U11",0
	.even
CNAMEU12
	.string	"U12",0
	.even
CNAMEU13
	.string	"U13",0
	.even
CNAMEU14
	.string	"U14",0
	.even
CNAMEU15
	.string	"U15",0
	.even
CNAMEU16
	.string	"U16",0
	.even
CNAMEU17
	.string	"U17",0
	.even
CNAMEU33
	.string	"U33",0
	.even
CNAMEU36
	.string	"U36",0
	.even
CNAMEU37
	.string	"U37",0
	.even
CNAMEU49
	.string	"U49",0
	.even
CNAMEU54
	.string	"U54",0
	.even
CNAMEU59
	.string	"U59",0
	.even
CNAMEU63
	.string	"U63",0
	.even
CNAMEU64
	.string	"U64",0
	.even
CNAMEU73
	.string	"U73",0
	.even
CNAMEU80
	.string	"U80",0
	.even
CNAMEU86
	.string	"U86",0
	.even
CNAMEU133
	.string	"U133",0
	.even
CNAMEU132
	.string	"U132",0
	.even
CNAMEU131
	.string	"U131",0
	.even
CNAMEU130
	.string	"U130",0
	.even
CNAMEU129
	.string	"U129",0
	.even
CNAMEU128
	.string	"U128",0
	.even
CNAMEU127
	.string	"U127",0
	.even
CNAMEU126
	.string	"U126",0
	.even
CNAMEU125
	.string	"U125",0
	.even
CNAMEU124
	.string	"U124",0
	.even
CNAMEU123
	.string	"U123",0
	.even
CNAMEU122
	.string	"U122",0
	.even
CNAMEU121
	.string	"U121",0
	.even
CNAMEU120
	.string	"U120",0
	.even
CNAMEU119
	.string	"U119",0
	.even
CNAMEU118
	.string	"U118",0
	.even
CNAMEU117
	.string	"U117",0
	.even
CNAMEU116
	.string	"U116",0
	.even
CNAMEU115
	.string	"U115",0
	.even
CNAMEU114
	.string	"U114",0
	.even
CNAMEU113
	.string	"U113",0
	.even
CNAMEU112
	.string	"U112",0
	.even
CNAMEU111
	.string	"U111",0
	.even
CNAMEU110
	.string	"U110",0
	.even
CNAMEU109
	.string	"U109",0
	.even
CNAMEU108
	.string	"U108",0
	.even
CNAMEU107
	.string	"U107",0
	.even
CNAMEU106
	.string	"U106",0
	.even
CNAMEU105
	.string	"U105",0
	.even
CNAMEU104
	.string	"U104",0
	.even
CNAMEU103
	.string	"U103",0
	.even
CNAMEU102
	.string	"U102",0
	.even


**************************************************************************
*								         *
* 	RAM CHIP DATA							 *
*								         *
**************************************************************************

;
;	MAKE SURE THESE TABLES CORRESPOND WITH THE STUFF ABOVE
;

VRAMCHIPS:
;	COLOR RAMS


;	RAM_CHIP 0,0, 8, 16, 1880000H, 18FFFF0H		; UA8  (  0 - 3  )
;	RAM_CHIP 0,1, 8, 16, 1880008H, 18FFFF8H		; UC8  (  8 - 11 )

	RAM_CHIP 0,1, 8, 16, 1880000H, 18FFFF0H		; U37  (  0 - 7  )
	RAM_CHIP 0,0, 7, 16, 1880008H, 18FFFF8H		; U36  (  8 - 14 )


;	VIDEO RAMS
;	RAM_CHIP $MACRO TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR
;	RAM_CHIP 0, 6, 8, 32, 0000018H, 03FFFF8H	; UB11 ( 24 - 27 )
;	RAM_CHIP 0, 8, 8, 32, 0000010H, 03FFFF0H	; UB13 ( 16 - 19 )
;	RAM_CHIP 0, 7, 8, 32, 0000008H, 03FFFE8H	; UB12 (  8 - 11 )
;	RAM_CHIP 0, 9, 8, 32, 0000000H, 03FFFE0H	; UB14 (  0 - 3  )
	RAM_CHIP 0, 8, 8, 32, 0000018H, 03FFFF8H	; U12
	RAM_CHIP 0, 4, 8, 32, 0000010H, 03FFFF0H	; U16
	RAM_CHIP 0, 9, 8, 32, 0000008H, 03FFFE8H	; U13
	RAM_CHIP 0, 5, 8, 32, 0000000H, 03FFFE0H	; U17

	.LONG	0

PALCHIPS:
;	VIDEO PALETTE RAMS
;	RAM_CHIP $MACRO TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR
;	RAM_CHIP 0,2, 8, 32, 0000018H, 03FFFF8H		; UA11 (  24 - 27 )
;	RAM_CHIP 0,4, 8, 32, 0000010H, 03FFFF0H		; UA13 (  16 - 19  )
;	RAM_CHIP 0,3, 8, 32, 0000008H, 03FFFE8H		; UA12 (  8 - 11 )
;	RAM_CHIP 0,5, 8, 32, 0000000H, 03FFFE0H		; UA14 (  0 - 3  )
	RAM_CHIP 0,6, 8, 32, 0000018H, 03FFFF8H		; U10
	RAM_CHIP 0,2, 8, 32, 0000010H, 03FFFF0H		; U14
	RAM_CHIP 0,7, 8, 32, 0000008H, 03FFFE8H		; U11
	RAM_CHIP 0,3, 8, 32, 0000000H, 03FFFE0H		; U15
	.LONG	0

;	SCRATCH RAMS

SRAMCHECK
	.STRING	"CHECKING SCRATCH RAMS",0
	.EVEN

SRAMCHIPS
;	RAM_CHIP SRAM4,3, 4, 16, 1000004H, 13FFFF4H	; UJ7 (  4 - 7  )
;	RAM_CHIP SRAM3,2, 4, 16, 1000000H, 13FFFF0H	; UJ6 (  0 - 3  )
;	RAM_CHIP SRAM2,1, 4, 16, 1000008H, 13FFFF8H	; UJ5 (  8 - 11 )
;	RAM_CHIP SRAM1,0, 4, 16, 100000CH, 13FFFFCH	; UJ4 ( 12 - 15 )
	RAM_CHIP SRAM1,0, 16, 16, 1000000H, 13FFFF0H	; U49 (0-15)

	.LONG	0

   .EVEN
*
*		ROM chip definitions and checksums
*
CHECKSUM0	.equ	0ac9fh	;a911
CHECKSUM1	.equ	0a0e2h	;9fff

PROMCHIPS
;	ROM_CHIP PROM1,0,0,16, 0FF800000H, 0FFFFFFF0H, CKSUM1	; UJ12
;	ROM_CHIP PROM2,1,0,16, 0FF800008H, 0FFFFFFF8H, CKSUM2	; UG12
	ROM_CHIP PROM2,1,0,16, 0FF800000H, 0FFFFFFF0H, CHECKSUM0	; U54
	ROM_CHIP PROM1,0,0,16, 0FF800008H, 0FFFFFFF8H, CHECKSUM1	; U63
	.LONG	0

* CHECKSUM PATCHES
	.WORD	0ffffh-CHECKSUM0	;1'S COMPLEMENT OF THE UJ12 CHECKSUM
	.WORD	0ffffh-CHECKSUM1	;1'S COMPLEMENT OF THE UG12 CHECKSUM


**************************************************************************
*								         *
* 		     IMAGE ROM CHECKSUM TABLES				 *
* 									 *
* 		NOTE: COMMENT OUT ANY UNSTUFFED PARTS THAT		 *
* 			EXIST BEFORE THE .LONG 0 TERMINATOR!		 *
*								         *
**************************************************************************
;	ROM_CHIP $MACRO TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR, CHECK_SUM
IROMCHIPS
	.EVEN
	ROM_CHIP IROM1,  0, 8,32,  2000000H, 2FFFFE0H, 01161H	; U133
	ROM_CHIP IROM2,  1, 8,32,  2000008H, 2FFFFE8H, 0748dH	; U132
	ROM_CHIP IROM3,  2, 8,32,  2000010H, 2FFFFF0H, 08b9dH	; U131
	ROM_CHIP IROM4,  3, 8,32,  2000018H, 2FFFFF8H, 05afeH	; U130

	ROM_CHIP IROM5,  4, 8,32,  3000000H, 3FFFFE0H, 03e9bH	; U129
	ROM_CHIP IROM6,  5, 8,32,  3000008H, 3FFFFE8H, 05ca0H	; U128
	ROM_CHIP IROM7,  6, 8,32,  3000010H, 3FFFFF0H, 0c6ecH	; U127
	ROM_CHIP IROM8,  7, 8,32,  3000018H, 3FFFFF8H, 0c336H	; U126

	ROM_CHIP IROM9,  8, 8,32,  4000000H, 4FFFFE0H, 0f400H	; U125
	ROM_CHIP IROM10, 9, 8,32,  4000008H, 4FFFFE8H, 0b70dH	; U124
	ROM_CHIP IROM11,10, 8,32,  4000010H, 4FFFFF0H, 0f731H	; U123
	ROM_CHIP IROM12,11, 8,32,  4000018H, 4FFFFF8H, 07be3H	; U122

	ROM_CHIP IROM13,12, 8,32,  5000000H, 5FFFFE0H, 0bdd6H	; U121
	ROM_CHIP IROM14,13, 8,32,  5000008H, 5FFFFE8H, 0f515H	; U120
	ROM_CHIP IROM15,14, 8,32,  5000010H, 5FFFFF0H, 0ef39H	; U119
	ROM_CHIP IROM16,15, 8,32,  5000018H, 5FFFFF8H, 0b948H	; U118
	.LONG	0

; This and possibly other tables need to be set up yet
IROMCHIPS1
	ROM_CHIP IROM17,16, 8,32,  2000000H, 2FFFFE0H, 01161H	; U117
	ROM_CHIP IROM18,17, 8,32,  2000008H, 2FFFFE8H, 0748dH	; U116
	ROM_CHIP IROM19,18, 8,32,  2000010H, 2FFFFF0H, 08b9dH	; U115
	ROM_CHIP IROM20,19, 8,32,  2000018H, 2FFFFF8H, 05afeH	; U114

	ROM_CHIP IROM21,20, 8,32,  3000000H, 3FFFFE0H, 03e9bH	; U113
	ROM_CHIP IROM22,21, 8,32,  3000008H, 3FFFFE8H, 05ca0H	; U112
	ROM_CHIP IROM23,22, 8,32,  3000010H, 3FFFFF0H, 0c6ecH	; U111
	ROM_CHIP IROM24,23, 8,32,  3000018H, 3FFFFF8H, 0c336H	; U110

	ROM_CHIP IROM25,24, 8,32,  4000000H, 4FFFFE0H, 0f400H	; U109
	ROM_CHIP IROM26,25, 8,32,  4000008H, 4FFFFE8H, 0b70dH	; U108
	ROM_CHIP IROM27,26, 8,32,  4000010H, 4FFFFF0H, 0f731H	; U107
	ROM_CHIP IROM28,27, 8,32,  4000018H, 4FFFFF8H, 07be3H	; U106

	ROM_CHIP IROM29,28, 8,32,  5000000H, 5FFFFE0H, 0bdd6H	; U105
	ROM_CHIP IROM30,29, 8,32,  5000008H, 5FFFFE8H, 0f515H	; U104
	ROM_CHIP IROM31,30, 8,32,  5000010H, 5FFFFF0H, 0ef39H	; U103
	ROM_CHIP IROM32,31, 8,32,  5000018H, 5FFFFF8H, 0b948H	; U102
	.LONG	0		; FORCE IT TO STOP HERE

	.endif
	
