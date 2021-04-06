   	.MLIB	"HHMACS.LIB"
	.FILE	"HHCOIN.ASM"
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
	.include	"hhcoin.e"
	.include	"hhram.g"
	.include	"hhsnd.g"
	.include	"hhtext.g"
	.include	"hhd.g"
	.include	"hhmisc.g"
	.include	"hhproc.g"
	.include	"hhcmos.g"
	.include	"hhadj.g"
	.include	"hh.g"
	.include	"hhmenu.g"
	.include	"hhdtst.g"
	.include	"hhutil.g"
	.include	"hhattrct.g"
	.include	"hhpick.g"
	.include	"hhpall.g"
	.include	"hhgame.g"

; end of include files

	.if	DEBUG
	.ref	VCOUNT0
	.ref	VCOUNT1
	.endif

**************************************************************************
*								         *
* 	GLOBAL VARIABLES						 *
*								         *
**************************************************************************

	.BSS	C_FLAGS,5*32		;INTERRUPT COIN BOUNCE
	.BSS	CTRLEFT,16		; FOR THE COIN COUNTERS
	.BSS	CTRRIGHT,16  
	.BSS	COINFLAG,16
	.BSS	GAMEUNITS,16		;UNITS USED PER CURRENT GAME
	.BSS	TIMECNT,16		;TIME COUNTER
	.BSS	SUBTIMECNT,16		;YET ANOTHER TIMER COUNTER
	.BSS	OCTO_FLAG,16		;OCTOPUS FLAG
;	.bss	xxxx,16		;fill space to 32 bits
	.BSS	NEWCRED,16		;"NEW" CREDIT MESSAGE FLAG
	.BSS	TEXT_BUFF,30*16		;TEMP FOR BUILDING STRINGS

**************************************************************************
*								         *
* 	COIN EQUATES							 *
*								         *
**************************************************************************

LC_FLAG  EQU     C_FLAGS
RC_FLAG  EQU     C_FLAGS+8
CC_FLAG  EQU     RC_FLAG+8
XC_FLAG	EQU	CC_FLAG+8
DBV_FLAG equ	XC_FLAG+8

RUN_TIME EQU     32+8		;2ND LONG WORD COUNTS DOWN LONG TIME
OPENS_LEFT EQU   RUN_TIME+32+8	;3RD LONG WORD COUNTS DOWN CONSEC OPENS

PULSE_MAX        EQU     700/16       ;FRAMES TILL ITS TOO LINE.
MIN_OPENS        EQU     4
ACC_LIMIT        EQU     80H          ;AFTER 2 SECONDS OF NO-REPLY....RE-SET FLAG!
COIN_SBIT        EQU     0
COIN_SUCC_BIT    EQU     1
COIN_FAIL_BIT    EQU     2
COIN_ACK_BIT     EQU     3

COIN_SFLAG       EQU     1
COIN_SUCC_VAL    EQU     2
COIN_FAIL_VAL    EQU     4
COIN_ACK_VAL     EQU     8

**************************************************************************
*								         *
* 	COIN ROUTINES							 *
*								         *
**************************************************************************

	.TEXT
	.EVEN

**************************************************************************
*								         *
* 	COINCOUNTER							 *
* 									 *
* 	PROCESS THAT DEALS WITH THE COIN COUNTER			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
COINCOUNTER
	CLR	A8
	MOVE	@CTRLEFT,A1,W
	JRZ	CC1
	MOVI	LEFT_COIN,A8
	DEC	A1
	MOVE	A1,@CTRLEFT,W
CC1
	MOVE	@CTRRIGHT,A1,W
	JRZ	CC2
	ORI	RIGHT_COIN,A8
	DEC	A1
	MOVE	A1,@CTRRIGHT,W
CC2
	MOVE	A8,A8
	JRZ	CCDIE			; BOTH WERE EMPTY

* the following is commented out in MK3
;	CALLA	READ_DIP
;	ANDI	DPCOUNTER,A0
;	JRNZ	CC3
;   	ORI	RIGHT_COIN,A8
;	ORI	LEFT_COIN,A8		; MAKE SURE BOTH TRIGGER
;CC3
*
	MOVE	A8,A0
	CALLA	COUNTER_ON

	SLEEP	7			; THIS SUCKS, BUT CARY LIKES IT

	MOVE	A8,A0
	CALLA	COUNTER_OFF

	SLEEP	7			; GIVE THEM TIME TO BE OFF
	JRUC	COINCOUNTER
CCDIE
	DIE

**************************************************************************
*								         *
* COIL_ON - TURN A COIL ON VIA THE SECURITY CHIP.			 *
* A0 = COIL MASK							 *
* RETURNS:								 *
* 	NOTHING								 *
*								         *
**************************************************************************
COUNTER_ON
	PUSH	A1
	MOVE	@COUNTER_COPY,A1,W
	OR	A0,A1
	MOVE	A1,@COUNTER_COPY,W
	ori	20h,a1
	MOVE	A1,@COIN_COUNTERS,W
	PULL	A1
	RETS

**************************************************************************
*								         *
* COIL_OFF - TURN A COIL OFF VIA THE SECURITY CHIP.			 *
* A0 = COIL MASK							 *
* RETURNS:								 *
* 	NOTHING								 *
*								         *
**************************************************************************
COUNTER_OFF
	PUSH	A1
	MOVE	@COUNTER_COPY,A1,W
	ANDN	A0,A1
	MOVE	A1,@COUNTER_COPY,W
	ori	20h,a1                  ; 
	MOVE	A1,@COIN_COUNTERS,W
	PULL	A1
	RETS

**************************************************************************
*								         *
* 	COINCTR_P							 *
* 									 *
* 	IS THERE A COIN COUNTER PROCESS RUNNING				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		.EQ.	NO						 *
* 		.NE.	YES						 *
*								         *
**************************************************************************

COINCTR_P
	MOVI    PID_COINCTR,A0
        CALLA   EXISTP_ALL
	RETS

CREDIT_JUMP
	MOVE	@VOLUME_SET,A14,W
	JRZ	CREDIT_JUMP2			;BR=VOLUME NOT SET

	CALLA	kill_all_sound
	MOVE	@SOUNDSUP,A0,W
	CLR	A14
	MOVE	A14,@SOUNDSUP,W
	MOVI	S_CREDIT,A4
	CALLA	do_sound
	MOVE	A0,@SOUNDSUP,W
CREDIT_JUMP2
	calla	ATSTRT_CREDITS
	jauc	SUCIDE

;	JSRP	CREDIT_SCREEN
;
;	MOVI	PID_ATTRACT_MODE,A0
;	MOVE	A0,*A13(PROCID),W
;
;	CLR	A14
;	MOVE	A14,*A13(PDATA),W		;RESET ATT_MODE_COUNT
;
;	JAUC	ATT_MODE_CREDIT_RETURN

**************************************************************************
*								         *
* 	CREDIT_SCREEN							 *
* 									 *
* 	PLOT THE APPROPRIATE CREDIT SCREEN -- DESTROY ANYTHING THAT	 *
* 	HAPPENS TO BE AROUND AT THE TIME				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

CREDIT_SCREEN:
	.if	DEBUG
	MOVE	@VCOUNT,@VCOUNT0,W
	.endif

	MOVI	PID_ATTRACT_MODE,A0
	CALLA	KILLPROC_ALL
	MOVI	PID_IND,A0
	CALLA	KILLPROC_ALL

	MOVE	@COINFLAG,A0,W
	JRN	CS_NAP			;BR=MAXIMUM CREDITS
	JRNZ	CS1			;BR=ON THIS PAGE ALREADY

	MOVE	@in_at_game,A14,W
	JRZ	CS_WIPE			;BR=NOT RUNNIN'
	CALLA	stop_attract_game_quick_SNDOK
CS_WIPE
	CALLA	WIPEOUT			; LATER, DUDES!
	DISPON

	MOVI	GFONT10CP,A0
	CALLA	GETFPAL
	MOVI	REDTXT3P,A0
	CALLA	GETFPAL
	MOVI	BLUTXT3P,A0
	CALLA	GETFPAL
	MOVI	GRNTXT3P,A0
	CALLA	GETFPAL
	MOVI	GLDTXT1P,A0
	CALLA	GETFPAL
	MOVI	ORGTXT1P,A0
	CALLA	GETFPAL

	MOVK	1,A14
	MOVE	A14,@GAMERASE,W

	CALLA	OPEN_ICE_BGND

        MOVI    ADJFREPL,A0
        CALLA   GET_ADJ
	JRNZ	CS_STATUS_PROC				;BR=FREE PLAY
*
*       not free play, print out coinage description
*
	calla	TAMPEREDP		;are we in custom coinage?
	jrz	show_nothing		;br = yes
        CALLR   PLOTCOINAGE
show_nothing:

;	MOVI    ADJCUNIT,A0
;	CALLA   GET_ADJ
;	MOVI	CREDIT_PER_COIN_MESS,A8
;	CMPI	1,A0
;	JREQ	CS_COIN					;BR=1 COIN
;	MOVE	A0,@RAMTEMP1,W
;	MOVI	CREDIT_PER_COINS_MESS,A8
;CS_COIN
;	JSRP	LM_PRINTF

	MOVI    ADJCSTRT,A0
	CALLA   GET_ADJ
	MOVI	START_CREDIT_MESS,A8
	CMPI	1,A0
	JREQ	CS_START				;BR=1 COIN
	MOVE	A0,@RAMTEMP1,W
	MOVI	START_CREDITS_MESS,A8
CS_START
	PUSH	A0
	JSRP	LM_PRINTF

	MOVI    ADJCCONT,A0
	CALLA   GET_ADJ
	MOVI	CONT_CREDIT_MESS,A8
	CMPI	1,A0
	JREQ	CS_CONTXX	        	; BR=1 COIN
	MOVE	A0,@RAMTEMP1,W
	MOVI	CONT_CREDITS_MESS,A8
CS_CONTXX                                       ; 
	PUSH	A0
	JSRP	LM_PRINTF
	MMFM	SP,A1,A2
	MOVI    ADJFULLGAME,A0
	CALLA   GET_ADJ

	CMP	A1,A0
	JRLT	CS_DOLLAR_BILL				;BR=FULL GAME TOO LOW

	SLL	1,A2					;2 CONTINUES
	ADD	A1,A2					;PLUS 1 START

	CMP	A2,A0
	JRGT	CS_DOLLAR_BILL				;BR=FULL GAME TOO HIGH

	MOVE	A0,@RAMTEMP1,W
	MOVI	FULL_GAME_MESS,A8
	JSRP	LM_PRINTF
CS_DOLLAR_BILL
	MOVE	@DIPSWITCH,A14,W
	BTST	8,A14
	JRNZ	CS_STATUS_PROC				;BR=NO BILLS
	MOVI	DOLLAR_BILL_MESS,A8
	JSRP	LM_PRINTF

CS_STATUS_PROC
	CREATE	PID_CREDIT,CREDIT_STATUS_PROC

	MOVK	1,A0
	MOVE	A0,@COINFLAG,W		; FLAG WE ARE ON THE COIN PAGE
;	SLEEP	1
CS1
	SLEEP	1

	MOVI	OID_CREDIT,A0
	CALLA	KILOBJ_ALL

	MOVI	OID_CREDIT,B1			;[SOUND,OID]
	CLR	A0				;NO SLEEP TIL
	MOVI	STRCNCONV,A1			;ROUTINE
	MOVI	HFPAL+0404H,A5			;[COLOR,PALETTE]
	MOVI	[127-63-6-4,200],A9			;[Y,X] SCREEN ADDRESS
	MOVI	[0,-1],A10			;[Y,X] SPACING
	MOVI	H18FONT,A11			;FONT

	CALLR	GET_CSTR		; GET THE CHARACTER STRING
	JSRP	PRINTF
CS_NAP
	.if	DEBUG
	MOVE	@VCOUNT,@VCOUNT1,W
	.endif

	SLEEP	60*5

	CLR	A0
	MOVE	A0,@COINFLAG,W
	RETP

FULL_GAME_MESS
;	MESS_MAC2 H11WFONT,-1,0,200,20,HFPAL+0101H,STRCNCONV,OID_JUNK
	MESS_MAC2 H11WFONT,-1,0,200,20,HFPAL+0505H,STRCNCONV,OID_JUNK
	.STRING	"PURCHASE FULL GAME FOR\n\fONLY %u CREDITS PER PLAYER!",0
	.LONG	[-3,0]
	.LONG	RAMTEMP1
	.EVEN

CPC_YPOS	EQU	127+2

CREDIT_PER_COIN_MESS
	MESS_MAC2 H11WFONT,-1,0,200,CPC_YPOS,HFPAL+0202H,STRCNCONV,OID_JUNK
	.STRING	"1 CREDIT / 1 COIN",0
	.EVEN

CREDIT_PER_COINS_MESS
	MESS_MAC2 H11WFONT,-1,0,200,CPC_YPOS,HFPAL+0202H,STRCNCONV,OID_JUNK
	.STRING	"1 CREDIT / %u COINS",0
	.LONG	RAMTEMP1
	.EVEN

START_CREDIT_MESS
	MESS_MAC2 H11WFONT,-1,0,200,CPC_YPOS+13,HFPAL+0202H,STRCNCONV,OID_JUNK
	.STRING	"1 CREDIT TO START",0
	.EVEN

START_CREDITS_MESS
	MESS_MAC2 H11WFONT,-1,0,200,CPC_YPOS+13,HFPAL+0202H,STRCNCONV,OID_JUNK
	.STRING	"%u CREDITS TO START",0
	.LONG	RAMTEMP1
	.EVEN

CONT_CREDIT_MESS
	MESS_MAC2 H11WFONT,-1,0,200,CPC_YPOS+26,HFPAL+0202H,STRCNCONV,OID_JUNK
	.STRING	"1 CREDIT TO CONTINUE",0
	.EVEN

CONT_CREDITS_MESS
	MESS_MAC2 H11WFONT,-1,0,200,CPC_YPOS+26,HFPAL+0202H,STRCNCONV,OID_JUNK
	.STRING	"%u CREDITS TO CONTINUE",0
	.LONG	RAMTEMP1
	.EVEN

DOLLAR_BILL_MESS
	MESS_MAC2 H11WFONT,-1,0,200,CPC_YPOS+44,HFPAL+0101H,STRCNCONV,OID_JUNK
	.STRING	"THIS GAME ACCEPTS DOLLAR BILLS",0
	.EVEN


**************************************************************************
*								         *
* CREDIT_STATUS_PROC - DISPLAY CREDIT PLAY STATUS			 *
* 									 *
* PASS:									 *
* NUTIN'								 *
*								         *
**************************************************************************

CREDIT_STATUS_PROC
        MOVI    ADJFREPL,A0
        CALLA   GET_ADJ
	JRZ	CSP_CREDIT

	MOVK	4,A0
	MOVE	A0,@RAMTEMP1,W
	MOVI	READY_NP_MESS,A8
	JSRP	LM_PRINTF
CSP_FREE_PRESS_FLASH

	MOVE	@VOLUME_SET,A14,W
	JRZ	CSP_FPF_NAP			;BR=VOLUME NOT SET

	MOVI	PRESS_START_MESS,A8
	JSRP	LM_PRINTF

	SLEEP	30

	MOVI	OID_PROMPT2,A0
	CALLA	KILOBJ_ALL
CSP_FPF_NAP
	SLEEP	15

	JRUC	CSP_FREE_PRESS_FLASH

CSP_CREDIT
	CLR	A11				;READY FOR NOBODY, ZERO COUNT

	MOVK	ADJCSTRT,A0
	CALLA	GET_ADJ				;GET NUMBER OF CREDITS TO START
	MOVE	A0,A9

	MOVK	ADJMAXC,A0
	CALLA	GET_ADJ				;GET NUMBER MAXIMUM CREDITS
	MOVE	A0,A10
CSP_NEW_CREDIT
	CLR	A14
	MOVE	A14,@NEWCRED,W			;RESET "NEW" CREDIT MESSAGE FLAG

	MOVE	A10,A10
	JRZ	CSP_CHECK_NEW			;BR=AT MAXIMUM CREDITS

	CALLA	CRED_P
	MOVE	A0,A1
	CMPI	1,A11
	JRGE	CSP_CHECK_READY			;BR=ALREADY "PRESS START"

	MOVI	OID_PROMPT2,A0
	CALLA	KILOBJ_ALL

	MOVI	PRESS_START_MESS,A8
	CMP	A9,A1
	JRGE	CSP_CHECK_VOLUME		;BR=ENOUGH CREDITS, CHECK VOLUME
	MOVI	INSERT_COIN_MESS,A8
	JRUC	CSP_UPDATE_MESS

CSP_CHECK_VOLUME
	MOVE	@VOLUME_SET,A14,W
	JRZ	CSP_CHECK_READY			;BR=VOLUME NOT SET

CSP_UPDATE_MESS
	MMTM	A12,A1,A8,A9,A10,A11
	JSRP	LM_PRINTF
	MMFM	A12,A1,A8,A9,A10,A11

CSP_CHECK_READY
	CMP	A10,A1
	JRLT	CSP_GET_READY_COUNT		;BR=NOT A MAXIMUM CREDITS
	CLR	A10				;FLAG MAXIMUM CREDIT MESSAGE

	MMTM	A12,A1,A8,A9,A10,A11
	MOVI	MAX_CREDIT_MESS,A8
	JSRP	LM_PRINTF
	MMFM	A12,A1,A8,A9,A10,A11

CSP_GET_READY_COUNT
	CMPI	4,A11
	JREQ	CSP_CHECK_NEW			;BR=MAX READY MESSAGE

	DIVU	A9,A1
	CMP	A11,A1
	JREQ	CSP_CHECK_NEW			;BR=SAME READY COUNT
	CMPI	4,A1
	JRLE	CSP_NEW_READY			;BR=VALID READY COUNT
	MOVK	4,A1				;MAX READY COUNT
CSP_NEW_READY
	MOVE	A1,A11				;UPDATE PLAYER READY COUNT

	MOVI	OID_PROMPT,A0
	CALLA	KILOBJ_ALL

	MMTM	A12,A8,A9,A10,A11
	MOVI	READY_1P_MESS,A8
	CMPI	1,A11
	JREQ	CSP_DO_READY_MESS		;BR=READY FOR 1 PLAYER
	KITN	4
	JREQ	CSP_NP_MESS			;BR=4 PLAYER KIT
	MOVK	2,A11				;2 PLAYER MAXIMUM
CSP_NP_MESS
	MOVE	A11,@RAMTEMP1,W
	MOVI	READY_NP_MESS,A8
CSP_DO_READY_MESS
	JSRP	LM_PRINTF
	MMFM	A12,A8,A9,A10,A11
CSP_CHECK_NEW
	MOVK	30,A0
CSP_CHECK_NEW_LUPE
	PUSHP	A0
	SLEEP	1
	PULLPQ	A0
	MOVE	@NEWCRED,A14,W
	JRNZ	CSP_NEW_CREDIT			;BR="NEW" CREDIT FLAG
	DSJ	A0,CSP_CHECK_NEW_LUPE

	MOVI	OID_PROMPT2,A0
	CALLA	KILOBJ_ALL

	SLEEP	15

	CMPI	PRESS_START_MESS,A8
	JRNE	CSP_PRINT_MESS			;BR="INSERT COIN" MESSAGE

	MOVE	@VOLUME_SET,A14,W
	JRZ	CSP_CHECK_NEW			;BR=VOLUME NOT SET

CSP_PRINT_MESS
	MMTM	A12,A8,A9,A10,A11
	JSRP	LM_PRINTF
	MMFM	A12,A8,A9,A10,A11

	JRUC	CSP_CHECK_NEW

MAX_CREDIT_MESS
	MESS_MAC2 H18TFONT,-1,0,200,84-6-4,HFPAL+0101H,STRCNCONV,OID_JUNK
	.STRING	"MAXIMUM CREDITS",0
	.EVEN

READY_1P_MESS
	MESS_MAC2 H18TFONT,-1,0,200,190+2,HFPAL+0303H,STRCNCONV,OID_PROMPT
	.STRING	"READY FOR 1 PLAYER",0
	.EVEN

READY_NP_MESS
	MESS_MAC2 H18TFONT,-1,0,200,190+2,HFPAL+0303H,STRCNCONV,OID_PROMPT
	.STRING	"READY FOR 1-%u PLAYERS",0
	.LONG	RAMTEMP1
	.EVEN

INSERT_COIN_MESS
	MESS_MAC2 H18FONT,-1,0,200,220,HFPAL+0101H,STRCNCONV,OID_PROMPT2
	.STRING	"INSERT COIN",0
	.EVEN

PRESS_START_MESS
	MESS_MAC2 H18FONT,-1,0,200,220,HFPAL+0303H,STRCNCONV,OID_PROMPT2
	.STRING	"PRESS START",0
	.EVEN

;**************************************************************************
;*								         *
;* 	PLOTCOINAGE							 *
;* 									 *
;* 	PLOT OUT THE CURRENT COINAGE ON THE SCREEN			 *
;* 									 *
;* 	ENTRY								 *
;* 		NOTHING							 *
;* 									 *
;* 	EXIT								 *
;* 		NOTHING							 *
;*								         *
;**************************************************************************

CM_Y_ADDGAP	EQU	[13,200]

PLOTCOINAGE:
	MMTM	SP,A0,A1,A6
	CLR	A2
	MOVI	ADJFREPL,A0
	CALLA	GET_ADJ
	JRNZ	PCNOHEAD

	MOVI	ADJPRICE,A0
	CALLA	GET_ADJ			; GET THE CURRENT PRICING
        CALLA   GET_CSPT
        MOVE    *A6(CS_LIST),A2,L
        JRZ	PCNOHEAD		; NO HEADER, BELIEVE IT OR NOT
	MOVI	PCSETUP,A8
	CALLA	LM_SETUP
	MMTM	SP,A0,A1,A2
	CLR	A0
PC2
	MOVE	*A2+,A1,L		; COUNT UP NUMBER OF MESSAGES
	JRZ	PC3
	inc     A0
	JRUC	PC2
PC3
	SLL	4,A0
	ADDI	CM_YTAB,A0
	MOVE	*A0,A9,W
	SLL	16,A9
	ADDI	200,A9
	MMFM	SP,A0,A1,A2
PCNEXTHEAD
        MOVE    *A2+,A8,L            	; PICKUP THE NEXT POINTER
	JRZ	PCDONE
        mmtm    a12,a2
	JSRP	PRINTF
        mmfm    a12,a2
	SRL	16,A9
	SLL	16,A9			; MASK OFF X ADDRESS
	ADDI	CM_Y_ADDGAP,A9
	JRUC	PCNEXTHEAD
PCDONE
	MOVK	1,A2
	JRUC	PCRET

PCNOHEAD
	CLR	A2
PCRET
	MMFM	SP,A0,A1,A6
	RETS

PCSETUP
	MESS_MAC2 H11WFONT,-1,0,200,CPC_YPOS,HFPAL+0202H,STRCNCONV,OID_JUNK

CM_YTAB	.WORD	0,CPC_YPOS-6+2, CPC_YPOS-19+2, CPC_YPOS-32+2


;**************************************************************************
;*								         *
;* REQUIRE_PROC - PROCESS TO FLASH THE CREDIT REQUIREMENTS FOR THIS GAME. *
;*								         *
;**************************************************************************
;REQUIRE_PROC
;	CALLR	CHECKFREE
;	JANZ	SUCIDE
;
;	MOVI	REQUIRE_MESS,A8
;	JSRP	LM_PRINTF
;RP_LP
;*PRINT THE CREDITS REQUIRED TO START
;	MOVIM	SUFFIX_BS,@RAMTEMP2,L
;	ADJUST	ADJCSTRT
;	MOVE	A0,@RAMTEMP1,L
;	CMPI	1,A0
;	JRNE	RP_TOSTART
;	MOVIM	SUFFIX_NULL,@RAMTEMP2,L
;RP_TOSTART
;	MOVI	RTOSTART_MESS,A8
;	JSRP	LM_PRINTF
;
;	SLEEP	45
;	MOVI	OID_REQUIRED,A0
;	CALLA	KILOBJ_ALL
;
;*PRINT THE CREDITS REQUIRED TO CONTINUE
;	MOVIM	SUFFIX_BS,@RAMTEMP2,L
;	ADJUST	ADJCCONT
;	MOVE	A0,@RAMTEMP1,L
;	CMPI	1,A0
;	JRNE	RP_TOCONTINUE
;	MOVIM	SUFFIX_NULL,@RAMTEMP2,L
;RP_TOCONTINUE
;	MOVI	RTOCONTINUE_MESS,A8
;	JSRP	LM_PRINTF
;
;	SLEEP	45
;	MOVI	OID_REQUIRED,A0
;	CALLA	KILOBJ_ALL
;     	JRUC	RP_LP
;
;
;REQUIRE_MESS
;         MESS_MAC  RD7FONT,SPACING20,200,CREDIT_Y+70,COLOR_PWHITE,STRCNRMO,OID_TEXT
;	.STRING	"THIS GAME REQUIRES:",0
;	.EVEN
;
;RTOSTART_MESS
;         MESS_MAC  RD15FONT,SPACING20,200,CREDIT_Y+82,COLOR_PLF,STRCNRMO,OID_REQUIRED
;	.STRING	"%d CREDIT%p TO START.",0
;	.LONG	RAMTEMP1
;	.LONG	RAMTEMP2
;	.EVEN
;
;RTOCONTINUE_MESS
;         MESS_MAC  RD15FONT,SPACING20,200,CREDIT_Y+92,COLOR_PLF,STRCNRMO,OID_REQUIRED
;	.STRING	"%d CREDIT%p TO CONTINUE.",0
;	.LONG	RAMTEMP1
;	.LONG	RAMTEMP2
;	.EVEN
;
;SUFFIX_BS:
;	.STRING	"S",0
;

;**************************************************************************
;*								         *
;* 	OUTPUT_CUSTOM							 *
;* 									 *
;* 	OUTPUT THE COINUP MESSAGE.  THIS PLOTS ALL THE DIFFERENT	 *
;* 	FORMS OF IT..							 *
;* 									 *
;* 	ENTRY								 *
;* 		NOTHING							 *
;* 									 *
;* 	EXIT								 *
;* 		A2	NUMBER OF LINES PLOTTED				 *
;*								         *
;**************************************************************************
;
;CM_LINE1 EQU     CUSTOM_MESSAGE
;CM_LINE2 EQU     CUSTOM_MESSAGE+CMESS_LINE_SIZE
;CM_LINE3 EQU     CUSTOM_MESSAGE+(2*CMESS_LINE_SIZE)
;
;CM_Y_GAP	EQU	13
;CM_Y1		EQU	25
;CM_Y2		EQU	15
;CM_Y3		EQU	7
;
;OUTPUT_CUSTOM
;	MOVI	OID_CUSTOM,A0
;	CALLA	KILOBJ_ALL		;KILL CURRENT CUSTOM MESSAGE
;
;	CLR	A2
;	CALLR	CHECKFREE
;	JRNZ	OCGO			; BR = FREEPLAY
;
;        MOVI    ADJMAXC,A0
;        CALLA   GET_ADJ			; MAX CREDITS ALLOWED
;        JRZ	OCGO			; BR = NO MAX CREDITS
;	MOVE	A0,A1
;        CALLR   CRED_P
;	JRZ	OCGO			; AIN'T GOT NO CREDITS
;	CMP	A1,A0
;	JRLO	OCGO			; CREDITS < MAXCREDITS
;	MOVI	MESS_MAX,A8
;	JSRP	LM_PRINTF
;	MOVI	1,A2
;	JRUC	OCRET
;;	JRUC	OCNOMESS
;OCGO
;;XUNIT  CALLA   ADJ_PAGE
;        MOVI    VALID_CUSTOM,A7
;        CALLA   RC_WORD
;        CMPI    VALID_VALUE,A0		; CHECK TO SEE IF MESSAGE IS VALID
;	JRNZ	OCNOMESS		; BR = NOT VALID
;
;	CALLR	NUM_CLINES		; COMPUTE NUMBER OF DISPLAYABLE LINES
;	JRZ	OCNOMESS		; NOTHING TO SHOW
;	MOVK	1,A2
;	SLL	4,A0
;	ADDI	CM_YTAB,A0
;	MOVE	*A0,A9,W
;
;	MOVI	CM_LINE1,A10
;	CALLR	CK_LINE			; LOAD IT UP, BABY!
;	JRZ	OC1
;	CALLR	CPLOTLINE
;OC1
;	MOVI	CM_LINE2,A10
;	CALLR	CK_LINE
;	JRZ	OC2
;	CALLR	CPLOTLINE
;OC2
;	MOVI	CM_LINE3,A10
;	CALLR	CK_LINE
;	JRZ	OC3
;	CALLR	CPLOTLINE
;OC3
;	JRUC	OCRET
;OCNOMESS
;	CALLA	TAMPEREDP		;ARE WE IN CUSTOM COINAGE?
;	JRZ	OCRET			;BR = YES
;	CALLR	PLOTCOINAGE
;OCRET
;	RETS
;

;**************************************************************************
;*								         *
;* 	CPLOTLINE							 *
;* 									 *
;* 	PLOT THE LINE IN PDATA OUT ON THE SCREEN			 *
;* 									 *
;* 	ENTRY								 *
;* 		A9	Y LOCATION TO PLOT AT				 *
;* 									 *
;* 	EXIT								 *
;* 		A9	NEW Y LOCATION					 *
;*								         *
;**************************************************************************
;
;CPLOTLINE:
;	PUSH	A9
;	PUSH	A9
;	MOVI	CUSTOM_SETUP,A8
;	CALLA	LM_SETUP
;;	MOVE	A13,A8
;;	ADDI	PDATA,A8
;	MOVI	TEXT_BUFF,A8
;	PULL	A9
;	SLL	16,A9
;	ADDI	200,A9
;	JSRP	PRINTF
;	PULL	A9
;	ADDI	CM_Y_GAP,A9
;	RETS
;
;CUSTOM_SETUP:
;         MESS_MAC  RD7FONT,SPACING20,196,0,COLOR_PWHITE,STRCNRMO,OID_CUSTOM
;
;
;MESS_MAX:
;         MESS_MAC  RD15FONT,SPACING20,200,CM_Y1-5,COLOR_PLF,STRCNRMO,OID_CUSTOM
;	.STRING	"MAXIMUM CREDITS",0
;	.EVEN
;
;
;**************************************************************************
;*								         *
;* 	NUM_CLINES							 *
;* 									 *
;* 	COMPUTE THE NUMBER OF DISPLAYABLE LINES IN CUSTOM RAM		 *
;* 									 *
;* 	ENTRY								 *
;* 		NOTHING							 *
;* 									 *
;* 	EXIT								 *
;* 		A0	NUMBER OF LINES					 *
;*								         *
;**************************************************************************
;
;NUM_CLINES
;	MMTM	SP,A1,A10
;	CLR	A1
;	MOVI	CM_LINE1,A10
;	CALLR	CK_LINE
;	JRZ	NC2
;	INC	A1
;NC2
;	MOVI	CM_LINE2,A10
;	CALLR	CK_LINE
;	JRZ	NC3
;	INC	A1
;NC3
;	MOVI	CM_LINE3,A10
;	CALLR	CK_LINE
;	JRZ	NC4
;	INC	A1
;NC4
;	MOVE	A1,A0
;	MMFM	SP,A1,A10
;	RETS
;
;**************************************************************************
;*								         *
;* 	CK_LINE								 *
;* 									 *
;* 	COPY A LINE INTO PDATA AREA, AND RETURN IN A0 NUMBER OF CHARS	 *
;* 									 *
;* 	ENTRY								 *
;* 		A10	POINTER TO CMOS LOC OF LINE			 *
;* 									 *
;* 	EXIT								 *
;* 		A0	NUMBER OF VALID CHARS IN LINE			 *
;*								         *
;**************************************************************************
;
;CK_LINE:
;	MMTM    SP,A1,A2,A3,A4,A7,A10
;        MOVE    A10,A7               ;INPUT POINTER TO CMOS
;;        MOVE    A13,A2              ;OUR PDATA AREA
;;        ADDI    PDATA,A2            ;A10 IS DESTINATION.
;	MOVI	TEXT_BUFF,A2
;
;        MOVI    CMESS_CHARS,A1       ;COUNTER
;;XUNIT  CALLA   ADJ_PAGE             ;POINT THE PAGE
;	CLR	A3  		; ONLY SPACES SO FAR
;
;CK_LOOP CALLA   RC_BYTEI             ;FETCH A BYTE
;        MOVB    A0,*A2               ;STORE
;	MOVE	A0,A0
;	JRZ	CKLX			; END OF STRING
;	CMPI	20H,A0			; CHECK FOR NON-SPACES
;	JRZ	CKGO
;	INC	A3
;CKGO
;        ADDI    BYTE_SIZE,A2
;        DSJS    A1,CK_LOOP
;	CLR	A0
;	MOVE	A0,*A2,W		; MAKE SURE OF THINGS
;CKLX
;;XUNIT  CALLA   DEF_PAGE             ;POINT AWAY NOW
;	MOVE	A3,A3			; HOW MANY "REAL" CHARACTERS
;	MMFM    SP,A1,A2,A3,A4,A7,A10
;	RETS
;
**************************************************************************
*								         *
* 	GET_CSTR							 *
* 									 *
* 	CREATE THE CREDIT STRING AND RETURN IT IN TEXT_BUFF		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A8	POINTS TO TEXT_BUFF				 *
*								         *
**************************************************************************
GET_CSTR:
	MMTM	SP,A0,A1,A7,A10

	CALLR	CHECKFREE
	JRZ	NOT_FREE

	MOVI	MESS_FREEP,A8		;FREEPLAY MESSAGE
	JRUC	GET_CX
NOT_FREE
	MOVI	TEXT_BUFF,A7		;TEXT STRING TO BUILD IN
	MOVI	MESS_CREDITS,A8		;POINT AT TEXT PART
	CALLA	STRCAT			;BUILD THIS IN.
	CALLR	CRED_P
	MOVE	A0,A10			;SAVE CREDITS
	CALLR	CAT_A0
*
*	NOW WE NEED TO SEE IF WE SHOULD ADD A FRACTION.
*
	MOVI	ADJFRAC,A0
	CALLA	GET_ADJ			;CHECK THE ADJUSTMENT
	JRZ	NSFRAC			;DON'T SHOW IT!
*
*	ADD ANY FRACTION WE HAVE.
*
;XUNIT	CALLR	COIN_PAG		;PUT US ON COIN PAGE
	CALLR	GET_CUNITS		;A0 HAS CUNITS
;XUNIT	CALLA	DEF_PAGE		;FLIP CMOS AWAY
	MOVE	A0,A0			;ZERO?
	JRZ	NSFRAC			;THEN NO FRACTION.
*
*	WE HAVE A FRACTION...WERE THE CREDITS ZERO?
*
	MOVE	A10,A10			;WE SAVED EM IN A10
	JRNZ	NZM			;NON ZERO MANTISSA

	MOVI	TEXT_BUFF,A8		;LOOK FOR THE TERMINATOR
KILL_Z
	MOVB	*A8,A1			;GET A BYTE
	JRZ	NZM			;COULDN'T FIND IT....GO ON.
	CMPI	LET_0,A1		;IS THIS THE ZERO?
	JRZ	GOT_ZERO
	ADDI	BYTE_SIZE,A8
	JRUC	KILL_Z
GOT_ZERO
	CLR	A1
	MOVB	A1,*A8			;KILL THE ZERO
	MOVE	A8,A7			;UPDATE END OF STRING LOCATION

NZM
	MOVI	MESS_2SPACE,A8		;SPACE BET. MANTISSA AND DENMO
	CALLA	STRCAT

NOT_ZM
	CALLR	CAT_A0			;ADD A0 ONTO FRACTION

	MOVI	MESS_SLASH,A8
	CALLA	STRCAT			;ADD SLASH

	MOVI	ADJCUNIT,A0		;UNITS REQUIRED FOR CREDIT
	CALLA	GET_ADJ
	CALLR	CAT_A0			;DENOMINATOR

NSFRAC
	MOVI	TEXT_BUFF,A8
GET_CX
	CLRC				;RETURN OK
GET_CXX
	MMFM	SP,A0,A1,A7,A10
	RETS

**************************************************************************
*								         *
* 	CAT_A0								 *
* 									 *
* 	TURN A0 INTO A DECIMAL NUMBER AND THEN CONCATENATE IT ONTO	 *
* 	THE END OF THE STRING WE ARE BUILDING				 *
* 									 *
* 	ENTRY								 *
* 		A0	NUMBER FOR THE END OF THE STRING		 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

CAT_A0
	MMTM    SP,A8
        MOVE    A0,A8                          ;CREDIT COUNT IN A8
        CALLA   HEXTOASC                       ;STRING
        CALLA   STRCAT                         ;NOW WE HAVE WHOLE NUMBER.
	MMFM    SP,A8
	RETS

**************************************************************************
*								         *
* 	STRCAT								 *
* 									 *
* 	CONCATENATE THE STRING POINTED TO BY A8 ONTO A7 STARTING AT	 *
* 	A7.  GROSS BUT EFFECTIVE					 *
* 									 *
* 	ENTRY								 *
* 		A7	STARTING POSITION IN STRING			 *
* 		A8	ZERO-TERMINATED STRING TO STICK ONTO A7		 *
* 									 *
* 	EXIT								 *
* 		A7	POINTS AT ZERO TERMINATOR			 *
*								         *
**************************************************************************

STRCAT
	PUSH	A0
STRLOOP
	MOVB	*A8,*A7			; STICK NEXT CHAR IN
	MOVB	*A7,A0			; MOVB SUCKS
	JRZ	STRDONE
	ADDI	8,A7
	ADDI	8,A8			; WOOF WOOF WHO CARES
	JRUC	STRLOOP
STRDONE
	PULL	A0
	RETS

**************************************************************************
*								         *
* 	ADD_PROMPT							 *
* 									 *
* 	THIS IS CALLED ON THE CREDITS PAGE TO ADD A WORD OF 		 *
* 	WISDOM BELOW THE CREDITS MESSAGE -- IT PICKS OUT THE 		 *
* 	BEST MESSAGES AND BLINKS THEM					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

ADD_PROMPT:
;        MOVI    PROMPT_PROC,A7
;        CALLA   P_FORK               ;START UP ANOTHER W/ SAME ID TO FLASH!
	P_FORK	PROMPT_PROC
        RETP

**************************************************************************
*								         *
* 	PROMPT_PROC							 *
* 									 *
* 	PROCESS TO PICK A GOOD MESSAGE AND SHOW IT			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

PROMPT_PROC:
	CALLR	CHECKFREE
	JRNZ	PPFREE			; BR = FREEPLAY

        CALLR   CRED_P
        JRZ     PPNOCOIN		; BR = NOT ENOUGH TO START 1 PLAYER

	MOVE	A0,A1			; STORE CREDS IN A1
	MOVI	ADJCSTRT,A0		; CREDITS TO START
	CALLA	GET_ADJ
	CMP	A0,A1
	JRLO	PPNOCOIN		; BR = NOT ENOUGH TO START
	MOVE	A0,A2			; CREDS REQUIRED IN A2
	SUB	A2,A1			; GET US GOING HERE
	MOVK	1,A0			; HAVE ENOUGH FOR 1 PLAYER
	SUB	A2,A1
	JRN	PPMESS			; BR = NOT ENOUGH FOR 2
	INC	A0
	SUB	A2,A1
	JRN	PPMESS			; BR = NOT ENOUGH FOR 3
	INC	A0
	SUB	A2,A1
	JRN	PPMESS			; BR = NOT ENOUGH FOR 4
	INC	A0
	JRUC	PPMESS			; CAN HAVE UP TO 4 PLAYERS

PPFREE
	MOVK	4,A0			; FREEPLAY IS MAX PLAYERS
;
;	A0	NUMBER OF PLAYERS WE ARE READY FOR ( 0 = NONE )
;
PPMESS
	MOVE	@NPLAYERS,A1,W		; GRAB GAME NUMBER OF PLAYERS
	INC	A1
	CMP	A1,A0
	JRLS	PPMESS1			; BR = COOL NUMBER
	MOVE	A1,A0			; SET TO MAXIMUM NUMBER OF PLAYERS
PPMESS1
	SLL	5,A0
	ADDI	PROMPT_TAB,A0
	MOVE	*A0,A0,L		; GET APPROPRIATE MESSAGE
	JRZ	PPNOCOIN
	PUSH	A0
	MOVI	PROMPT_SETUP,A8
	CALLA	LM_SETUP
	PULL	A8			; PULL OUT THE MESSAGE STRING
	JSRP	PRINTF
	MOVK	1,A0
	JRUC	BLINKINIT
PPNOCOIN
	CLR	A0
BLINKINIT
	MOVE	A0,*A13(PDATA),W	; FLASH "PRESS START"
	MOVI	PROMPT_COLOR,A0
	MOVE	A0,*A13(PDATA+10H),L	; COLOR TO FLASH IT IN

BLINKLOOP
	MOVI	PROMPT_SETUP2,A8
	CALLA	LM_SETUP
	MOVE	*A13(PDATA),A8,W	; GET STRING
	SLL	5,A8
	ADDI	PROMPT_MESSTAB,A8
	MOVE	*A8,A8,L
	JSRP	PRINTF
	SLEEP	10H
	MOVI	OID_PROMPT2,A0
	CALLA	KILOBJ_ALL
	SLEEP	10H
	JRUC	BLINKLOOP

PROMPT_COLOR	EQU	COLOR_PWHITE

MESS_SLASH .STRING "/"
           .BYTE 0
           .EVEN

MESS_2SPACE .STRING " "
MESS_NULL   .BYTE 0
            .EVEN

CREDIT_Y .EQU	31


MESS_CREDITS
         .STRING   "CREDITS "
         .BYTE     0
         .EVEN


PROMPT_SETUP
         MESS_MAC  RD7FONT,SPACING20,196,CREDIT_Y+28,COLOR_PYELLOW,STRCNRMO,OID_PROMPT

PROMPT_SETUP2
         MESS_MAC  RD15FONT,SPACING20,200,CREDIT_Y+44,PROMPT_COLOR,STRCNRMO,OID_PROMPT2


PROMPT_1
	.STRING	"READY FOR 1 PLAYER.",0
	.EVEN
PROMPT_2
	.STRING	"READY FOR 1 OR 2 PLAYERS.",0
	.EVEN


PROMPT_TAB
	.LONG	0,PROMPT_1, PROMPT_2, PROMPT_2, PROMPT_2


PROMPT_INSCOIN
	.STRING	"INSERT COIN.",0
	.EVEN
PROMPT_PRESSSTART
	.STRING	"PRESS START.",0
	.EVEN


PROMPT_MESSTAB
	.LONG	PROMPT_INSCOIN, PROMPT_PRESSSTART

*
*        NORMAL CREDITS SETUP STRING
*


MESS_FREEP
         .STRING   "FREE  PLAY"
         .BYTE     0
         .EVEN


**************************************************************************
*								         *
* 	COIN UTILITY ROUTINES						 *
*								         *
**************************************************************************

**************************************************************************
*								         *
* 	CRED_STRING							 *
* 									 *
* 	RETURN A STRING TO JUST THE NUMBER OF CREDITS IN A8		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A8	STRING POINTING TO CREDITS			 *
*								         *
**************************************************************************

CRED_STRING:
	MMTM	SP,A0
	CALLR	CRED_P			; GET CREDITS IN A0
	MOVE	A0,A8
	CALLA	HEXTOASC
	MMFM	SP,A0
	RETS

**************************************************************************
*								         *
* 	CHECKFREE							 *
* 									 *
* 	CHECK TO SEE IF THE GAME IS IN FREEPLAY STATE			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NZ	= FREEPLAY					 *
* 		Z	= NOT IN FREEPLAY				 *
*								         *
**************************************************************************

CHECKFREE:
	.IF	FORCEFREE
	MOVK	1,A0
	JRUC	CFRET
	.ENDIF

        MOVI    ADJFREPL,A0
        CALLA   GET_ADJ
CFRET
	MOVE	A0,A0
	RETS

**************************************************************************
*								         *
* 	SCOIN								 *
* 									 *
* 	PROCESS CALLED WHEN SERVICE COIN SWITCH TRIGGERED		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
SCOIN:
	MOVE	@COINS,A14,W
	BTST	13,A14
	JRZ	CRX			;BR=COIN DOOR INTERLOCK OPEN

	MOVE	@GAME_STATE,A0,W	;DIAGNOSTICS?
	CMPI	INDIAG,A0
	JREQ	CRX			;THEN NO ACTION!

	MOVI	PID_LC,A0		;USE THIS FOR SERVICE
	MOVE	A0,*A13(PROCID),W	;SET OUR ID (IN CASE TABLE IS WRONG)

	CALLR	CK_MAX			;ARE WE AT MAXIMUM CREDITS?
	JRHS	SCOIN_KURT_DAMAGE	;BR = YES, SKIP THIS KURT BONER

	MOVI	AUDPAIDC,A0
	MOVI	-1,A1
	CALLA	AUD			;OFFSET FOR SERVICE, GROSS!!

SCOIN_KURT_DAMAGE
****	MOVI	AUDSCOIN,A11
****	MOVK	1,A8

	AUDIT	AUDSCOIN
	CALLR	FETCH_REQ
	MOVE	A2,A8			;NEED THIS MANY FOR A CREDIT HERE

	JRUC	CGOPROC

**************************************************************************
*								         *
* 	DBVCOIN								 *
* 									 *
* 	PROCESS CALLED WHEN FOURTH COIN SWITCH TRIGGERED		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
DBVCOIN
	MOVI	ADJDBVMULT,A8
	MOVI	DBV_FLAG,A10	;fix this
	MOVI	AUD_DBV,A11
	JRUC	COIN_ROUTINE

**************************************************************************
*								         *
* 	XCOIN								 *
* 									 *
* 	PROCESS CALLED WHEN FOURTH COIN SWITCH TRIGGERED		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
XCOIN
	MOVI	ADJ4MULT,A8
	MOVI	XC_FLAG,A10		;FOURTH COIN FLAG
	MOVI	AUD4COIN,A11
	JRUC	COIN_ROUTINE

**************************************************************************
*								         *
* 	LCOIN								 *
* 									 *
* 	PROCESS CALLED WHEN LEFT COIN SWITCH TRIGGERED			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
LCOIN
	MOVI	ADJLMULT,A8
	MOVI	LC_FLAG,A10		;LEFT COIN FLAG
	MOVI	AUDLCOIN,A11
	JRUC	COIN_ROUTINE

**************************************************************************
*								         *
* 	CCOIN								 *
* 									 *
* 	PROCESS CALLED WHEN CENTER COIN SWITCH TRIGGERED		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
CCOIN
	MOVI	ADJCMULT,A8
	MOVI	CC_FLAG,A10		;CENTER COIN FLAG
	MOVI	AUDCCOIN,A11
	JRUC	COIN_ROUTINE

**************************************************************************
*								         *
* 	RCOIN								 *
* 									 *
* 	PROCESS CALLED WHEN RIGHT COIN SWITCH TRIGGERED			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
RCOIN
	MOVI	ADJRMULT,A8
	MOVI	RC_FLAG,A10		;RIGHT COIN FLAG
	MOVI	AUDRCOIN,A11

;	FALL THROUGH

**************************************************************************
*                                                                        *
*          COIN_ROUTINE                                                  *
*                                                                        *
*          THIS IS CALLED FROM EACH OF THE COIN SWITCHES WHEN            *
*          MADE.  IT CONTAINS THE FOLLOWING:                             *
*                                                                        *
*                  A8 = MULTIPLIER FOR THAT SWITCH.                      *
*                  A10 = BASE OF RAM POINTERS                            *
*                  A11 = BASE AUDIT NUMBER                               *
*                                                                        *
**************************************************************************
COIN_ROUTINE
	MOVE	@GAME_STATE,A0,W	;DIAGNOSTICS?
	CMPI	INDIAG,A0
	JREQ	CRX			;THEN NO ACTION!

	MOVE	A8,A0			;MOVE MULTIPLIER ADJUST NUMBER TO A0
	CALLA	GET_ADJ			;FETCH IT
	MOVE	A0,A8			;AND BACK TO STATIC REG...ANY THERE?
	JRZ	CRX			;NOPE....DON'T WASTE THE TIME!

	CALLR	SLAM_P			;SLAM AROUND?
	JRNZ	CRX			;THEN NO ACTION

	MOVI	PID_LC,A0		;ALL 3 SLOTS USE THIS ID NOW
	MOVE	A0,*A13(PROCID),W	;SET OUR ID (IN CASE TABLE IS WRONG)

	MOVB	*A10,A0			;GET FLAG BYTE
	JRNZ	CRX			;SOMEONE ELSE THERE...WE'RE A BOUNCE!
*
*	OK....THIS IS A NEW POSITIVE EDGE....START THE TIMING
*	WHEELS   (A0 HAS A ZERO!)
*
	MOVI	PULSE_MAX,A1		;MAXIMUM PULSE WIDTH
	MOVB	A1,*A10(RUN_TIME)	;COUNT IT DOWN HERE.

	MOVI	MIN_OPENS,A1		;THIS MANY FRAMES OF OPEN TIL OPEN
	MOVB	A1,*A10(OPENS_LEFT)

	MOVI	COIN_SFLAG,A1
	MOVB	A1,*A10			;TELL INTERRUPT TO START!

	MOVI	100H,A9			;4 SECONDS MAX
COIN_LOOP
	SLEEP	1			;NOW SLEEP TIGHTLY TILL WE GET SUCCESS OR FAIL
	MOVB	*A10,A0			;GET THE FLAGS
	BTST	COIN_FAIL_BIT,A0	;TOO LONG?
	JRZ	CK_SUCC
*
*	WE HAVE FAILURE...ACKNOWLEDGE IT
*
	ORI	COIN_ACK_VAL,A0		;THIS ACKNOWLEDGES WE SAW IT.
	MOVB	A0,*A10			;PUT IT BACK
	JRUC	CRX			;AND GET OUT

CK_SUCC
	BTST	COIN_SUCC_BIT,A0
	JRNZ	COIN_GO			;GOT IT!...CONTINUE!

	DSJS	A9,COIN_LOOP		;TIME OUT FOR SAFETY


	.IF	DEBUG			;THIS IS A STUPID PLACE TO BE
	JRUC	$
	.ENDIF

	JRUC	CRX			;TIMED OUT....JUST DIE!

COIN_GO
	CLR	A0
	MOVB	A0,*A10			;CLEAR THE FLAGS BACK OUT!

	CALLR	SLAM_P			;SLAM?
	JRNZ	CRX			;THEN WE'RE OUT OF HERE
*
*        WE SURVIVED 1/2 SECOND WITHOUT A SLAM....ITS TIME TO CASH
*        IN HIS STACHE.
*
; add JAKE code from MK3 for TOTALIZER

	calla	READ_DIP                ; DIP takes precedence
	andi	DPCOUNTER,a0            ; if set for 2 counters,
	jrnz	two_counters            ; skip totalizing 

	movi	CTRLEFT,a1              ; 
	movi	ADJTOTALIZER,a0         ; do we want to totalize?
	calla	GET_ADJ                 ; if no, click the counter once
	jrz	no_totalizer
	movi	ADJTOTALIZER,a0
	add	a11,a0
	calla	GET_ADJ                 ;number of clicks to make in a2
	move	a0,a2
        jruc    mech3b

*multiple of least value coin mode
;normal_totalizer:
;	calla	GET_CSPT		;point to coin table a6
;
;	addi	CS_LVAL,a6		;add in offset to chute values
;	move	a11,a2
;	dec	a2			;get your click count
;	sll	4,a2			;offset for chute, word correct
;	add	a2,a6
;	move	*a6,a2			;get money value
;	move	a2,a2
;	jrz	mech10			;something illegal happened, just one

two_counters:	
	movi	CTRLEFT,a1              ; assume left counter
	cmpi	AUDLCOIN,a11
	jreq	no_totalizer
	cmpi	AUDRCOIN,a11
	jrne	mech4
	movi	CTRRIGHT,a1             ; DIP must be set for 2 counters.
no_totalizer:
	movk	1,a2
mech3b
	move	*a1,a0
	add	a2,a0
	move	a0,*a1

	callr	COINCTR_P		; check to see if process exists
	jrne	mech4
	CREATE	PID_COINCTR,COINCOUNTER
mech4
	CALLR	CHALK_COIN		;STRIKE UP THE AUDIT(S)
*
CGOPROC
	MOVE	A8,A8			;NO CUNITS?
	JRZ	CRX			;THEN NO MORE WORK TO DO.

	MOVK	1,A14
	MOVE	A14,@NEWCRED,W		;FLAG "NEW" CREDIT MESSAGE

	CALLR	ADJUST_CREDITS		;GIVE CREDIT FOR THE MONEY.
;XUNIT	CALLA	DEF_PAGE		;POINT PAGE AWAY!

	MOVE	@SOUNDSUP,A1,W
	SOUNDON
;	SOUND1	COINSND
	MOVE	A1,@SOUNDSUP,W

	MOVE	@GAME_STATE,A0,W	;CHECK FOR ATTRACT MODE
	CMPI	INAMODE,A0
	JRNZ	CRCALL

	MOVI	PID_IND,A0
	MOVE	A0,*A13(PROCID),W	;MAKE ME KILLABLE
	JRUC	CREDIT_JUMP
CRCALL
	CALLR	CREDIT_SOUND

;	CALLR	GET_CSTR		;GET CREDIT STRING
;	CALLA	G_CRED			;CALL GEORGE
CRX
	JAUC	SUCIDE

CREDIT_SOUND
	PUSH	A4
	MOVI	S_CREDIT,A4
	CALLA	do_sound
	PULLQ	A4
	RETS

**************************************************************************
*                                                                        *
*          CHALK_COIN                                                    *
*                                                                        *
*          A11 contains the base audit number.  Chalk the audit for      *
*          1 more coin hit there!                                        *
*                                                                        *
*          3 away from the base is the "door-closed" counter             *
*                                                                        *
*          3 away from that is the "sub-total".                          *
*                                                                        *
*          3 away from that is the "door-closed" sub-total.              *
*                                                                        *
*                                                                        *
**************************************************************************
CHALK_COIN:
	MMTM	SP,A0
	MOVE	A11,A0
	CALLR	CHALK_FOR_A0	;CHALK RELEVANT COUNTERS
	MMFM	SP,A0
	RETS

**************************************************************************
*                                                                        *
*          CHALK_FOR_A0                                                  *
*                                                                        *
*          THIS IS CALLED TO CHALK THE AUDITS FOR A COIN SWITCH.         *
*          A0 HAS THE BASE AUDIT FOR THE COIN SWITCH.                    *
*                                                                        *
**************************************************************************
CHALK_FOR_A0
	MMTM	SP,A0
	CALLA	AUD1		;CHALK THE DIRECT AUDIT
	MMFM	SP,A0
	RETS

**************************************************************************
*								         *
* 	ADJUST_CREDITS							 *
* 									 *
* 	TAKES A VALID COIN SWITCH HIT AND COUNTS IT TOWARDS CREDITS	 *
* 									 *
* 	ENTRY								 *
* 		A8	CHUTE MULTIPLIER				 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

ADJUST_CREDITS
	MMTM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
        CALLR   CK_MAX          ;ARE WE AT MAXIMUM CREDITS?
        JRHS    ADCRXX          ;YEP.....DON'T ROCK THE BOAT!
*
        CALLR   CCCC            ;VALIDATE THE CURRENT TOTALS (OR CLEAR!)

        CALLR   FETCH_REQ       ;GET THE REQUIRED FOR CREDIT, BONUS AND MINIMUM
*
*        A2 = REQUIRED FOR CREDIT
*        A3 = FOR BONUS
*        A4 = MINIMUM
*
	CALLA	CMOSUNLOCK
        CALLR   ADD_TO_CUNITS   ;ADD TO OUR CUNITS
        MOVE    A3,A3           ;BONUS EFFECTIVE?
        JRZ     NO_BUNITS       ;NOPE....DON'T RUN UP THE COUNTER!

        CALLR   ADD_TO_BUNITS   ;ADD TO BONUS UNITS

NO_BUNITS
        MOVE    A4,A4           ;MINIMUM REQUIRED?
        JRZ     NO_MINIMUM      ;NOPE.....LEAVE ALONE.

        MOVI    MINUNITS,A7     ;POINT AT MINIMUM
        CALLA   RC_WORD         ;GET THE AMOUNT ACCUMULATED
        ADD     A8,A0           ;ADD AMOUNT RECEIVED
        CALLA   WC_WORD         ;WRITE THE MINUNITS BACK IN CASE NOT ENOUGH.

        SUB     A4,A0           ;DO WE HAVE ENOUGH TO ACT?
        JRLO    ADCRX           ;NOPE....NO CREDITS YET!

        CLR     A0              ;CLEAR OUT MINIMUM FOR NEXT SHOT!
        CALLA   WC_WORD         ;REMOVE ACCUMULATED MINIMUM.

NO_MINIMUM
        CLR     A6              ;COUNT ACCUMULATED CREDITS IN A6
        CLR     A10             ;IN CASE NO BONUS!

        CLR     A8
        MOVI    BUNITS,A7
        CALLA   RC_WORD         ;GET THE NUMBER OF BUNITS
        MOVE    A0,A9           ;INTO A9

        MOVE    A3,A3           ;DON'T DIVIDE BY ZERO!
        JRZ     NO_BU_BU
        DIVU    A3,A8           ;DIVIDE BUNITS BY NUMBER NEEDED FOR BONUS

        MOVE    A9,A0           ;WRITE REMAINDER BACK
        CALLA   WC_WORD

        MOVE    A8,A6           ;NUMBER OF BONUS CREDITS EARNED.
        MOVE    A8,A10          ;REMEMBER IF ANY BONUS CREDITS WERE EARNED!

NO_BU_BU
        CLR     A8
        CALLR   GET_CUNITS      ;READ IN THE CUNITS
        MOVE    A0,A9

        MOVE    A2,A2           ;DON'T DIVIDE BY ZERO.
        JRZ     NO_CR

        DIVU    A2,A8           ;GET CREDITS!
        MOVE    A9,A0           ;REMAINDER IS LEFTOVER CUNITS
        CALLR   PUT_CUNITS
        ADD     A8,A6           ;A6 HAS WHAT WE'VE WON!

NO_CR   MOVE    A6,A1
        MOVI    AUDPAIDC,A0
        CALLA   AUD             ;CHALK UP THE EARNED CREDITS!

        CALLR   GET_CREDITS
        ADD     A6,A0           ;ADD IN THE NEW ONES.
        CALLR   PUT_CREDITS     ;NOW STORE EM BACK (ENFORCE MAX)

        MOVE    A10,A10         ;WAS THE BONUS EARNED?
        JRZ     ADCRX           ;NOPE...EXIT!
*
*        WHEN BONUS EARNED...WE START THE WHOLE SYSTEM OVER!
*
        CALLR   CLEAR_UNITS

ADCRX
	CALLR   FORM_COIN_CKSUM_AND_STORE
	CALLA	CMOSLOCK
ADCRXX
	MMFM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	RETS

**************************************************************************
*								         *
* 	PUT_CREDITS							 *
* 									 *
* 	STORE THE CREDIT COUNT IN A0 TO CMOS -- ENFORCE MAX CREDITS	 *
* 									 *
* 	ENTRY								 *
* 		A0	CREDIT COUNT					 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

PUT_CREDITS
	MMTM    SP,A0,A6,A7
        CALLR   GET_MAX         ;GET MAX CREDS IN A1....BE ON COIN PAGE
        CMP     A1,A0           ;SEE HOW WE STACK UP.
        JRLO    USE_A0          ;WE'RE LOWER...JUST STORE.
*
*        WE'RE AT (OR OVER) MAXIMUM CREDITS
*
        CALLR   CLEAR_UNITS     ;CLEAR OUT THE UNIT FRACTIONS.
        MOVE    A1,A0           ;USE MAXIMUM

USE_A0  MOVI    CREDITS,A7
	CALLA	CMOSUNLOCK
        CALLA   WC_BYTE         ;WRITE THE CREDITS OUT.
	CALLA	CMOSLOCK
	MMFM    SP,A0,A6,A7
	RETS

**************************************************************************
*								         *
* 	GET_MAX								 *
* 									 *
* 	GET MAXIMUM CREDITS IN A1 ( LEAVES YOU ON COIN PAGE )		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A1	MAXIMUM CREDITS					 *
*								         *
**************************************************************************

GET_MAX
	MMTM    SP,A0
        MOVI    ADJMAXC,A0
        CALLA   GET_ADJ    ;FETCH MAXIMUM CREDITS (PUT US ON COIN PAGE)
        MOVE    A0,A1
	MMFM    SP,A0
	RETS

**************************************************************************
*								         *
* 	CK_MAX								 *
* 									 *
* 	CALED TO SEE IF WE ARE AT MAXIMUM CREDITS			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		.HS.	AT MAXIMUM CREDITS				 *
*								         *
**************************************************************************

CK_MAX 	MMTM    SP,A0,A1
        CALLR   GET_MAX              ;GET MAXIMUM IN A1
        CALLR   CRED_P               ;GET CREDITS IN A0 (AND FLIP PAGE AWAY)
        CMP     A1,A0                ;JRHS FOR MAXIMUM CREDITS!
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*								         *
* 	CLEAR_UNITS							 *
* 									 *
* 	CLEAR OUT ANY FRACTIONS OF A UNIT IN CMOS			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

CLEAR_UNITS
	MMTM    SP,A0,A7
        CLR     A0
        MOVI    CUNITS,A7       ;3 CONSECUTIVE WORDS OF CMOS
        CALLA   WC_WORDI
        CALLA   WC_WORDI
        CALLA   WC_WORD
	MMFM    SP,A0,A7
	RETS

**************************************************************************
*								         *
* 	FETCH_REQ							 *
* 									 *
* 	SNAG THE NUMBER OF UNITS REQUIRED FOR CREDIT, BONUS AND		 *
* 	MINIMUM								 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A2	REQUIRED FOR CREDITS				 *
* 		A3	REQUIRED FOR BONUS				 *
* 		A4	MINIMUM						 *
*								         *
**************************************************************************

FETCH_REQ
	MMTM    SP,A0
        MOVI    ADJCUNIT,A0
        CALLA   GET_ADJ
        MOVE    A0,A2

        MOVI    ADJBUNIT,A0
        CALLA   GET_ADJ
        MOVE    A0,A3

        MOVI    ADJMUNIT,A0
        CALLA   GET_ADJ
        MOVE    A0,A4
	MMFM    SP,A0
	RETS


**************************************************************************
*								         *
* 	CRED_P								 *
* 									 *
* 	RETURN NUMBER OF CREDITS IN A0.  ALSO CLEARS Z BIT IF		 *
* 	CREDITS EXIST OR IN FREE PLAY					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A0	NUMBER OF CREDITS				 *
* 		.NZ.	CREDITS OR FREEPLAY				 *
*								         *
**************************************************************************

CRED_P:
	CALLR   CCCC			; CHECKSUM COIN CREDITS

GET_CREDITS
        MMTM    SP,A7
;XUNIT  CALLR	COIN_PAG		; COIN PAGE
        MOVI    CREDITS,A7		; WANT NUMBER OF CREDITS
        CALLA   RC_BYTE         ;READ CURRENT CREDITS
;        JRNZ    GC1             ;WE GOT SOME!

;        MOVI    ADJFREPL,A0
;        CALLA   GET_ADJ         ;SEE IF FREEPLAY......(Z BIT CLEAR IF SO!)

GC1:
;XUNIT	CALLA   DEF_PAGE        ;FLIP CMOS AWAY
	MMFM    SP,A7
	RETS

**************************************************************************
*								         *
* 	ADD_TO_CUNITS							 *
* 									 *
* 	ADD A VALUE TO THE CREDIT UNITS					 *
* 									 *
* 	ENTRY								 *
* 		A8	NUMBER OF CUNITS TO ADD				 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

ADD_TO_CUNITS
        MMTM    SP,A0,A7
        CALLR   GET_CUNITS
        ADD     A8,A0
        CALLR   PUT_CUNITS
	MMFM    SP,A0,A7
	RETS

**************************************************************************
*								         *
* 	GET_CUNITS							 *
* 									 *
* 	GET THE NUMBER OF CREDIT UNITS HANGING AROUND			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A0	NUMBER OF CUNITS				 *
*								         *
**************************************************************************

GET_CUNITS
        MMTM    SP,A7
        MOVI    CUNITS,A7
        CALLA   RC_WORD
	MMFM    SP,A7
	RETS

**************************************************************************
*								         *
* 	PUT_CUNITS							 *
* 									 *
* 	PUT THE NUMBER OF CREDIT UNITS IN A0 OUT TO CMOS		 *
* 									 *
* 	ENTRY								 *
* 		A0	NUMBER OF CUNITS				 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

PUT_CUNITS
        MMTM    SP,A7
        MOVI    CUNITS,A7
        CALLA   WC_WORD
	MMFM    SP,A7
	RETS

**************************************************************************
*								         *
* 	ADD_TO_BUNITS							 *
* 									 *
* 	ADD A NUMBER OF BONUS UNITS TO THE BONUS COUNTER		 *
* 									 *
* 	ENTRY								 *
* 		A8	NUMBER OF BONUS UNITS TO ADD			 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

ADD_TO_BUNITS
        MMTM    SP,A7,A0
        MOVI    BUNITS,A7
        CALLA   RC_WORD
        ADD     A8,A0
        CALLA   WC_WORD
	MMFM    SP,A7,A0
	RETS

**************************************************************************
*								         *
* 	FORM_COIN_CKSUM							 *
* 									 *
* 	THIS ROUTINE IS CALLED TO FORM THE COINS/CREDITS CHECKSUM.	 *
* 	THE CHECKSUM IS RETURNED IN A1					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A1	CHECKSUM					 *
* 		.EQ.	MATCHES WHAT'S THERE				 *
* 		.NE.	IT DON'T MATCH, DUDE				 *
*								         *
**************************************************************************

FORM_COIN_CKSUM:
        MMTM    SP,A0,A7,A2
;XUNIT  CALLR   COIN_PAG                 ;MAKE SURE WE'RE ON THE RIGHT PAGE.
        MOVI    COIN_CKSUM_START,A7       ;POINT AT FIRST BYTE TO CHECK
        MOVI    COIN_CKSUM_BYTES,A2
        CLR     A1                        ;CLEAR OUT CHECKSUM

CN_SUM  CALLA   RC_BYTEI                  ;FETCH A BYTE IN A0
        ADD     A0,A1                     ;ADD TO SUM
        DSJS    A2,CN_SUM                 ;TILL WE HAVE EM ALL

        NOT     A1                        ;COMPLEMENT OF COURSE
        ANDI    BYTE_MASK,A1              ;AND KEEP THE BYTE

        MOVI    COIN_CKSUM,A7
        CALLA   RC_BYTE                   ;FETCH THE CURRENT CKSUM
        CMP     A0,A1                     ;COMPARE TO THIS
	MMFM    SP,A0,A7,A2
	RETS

**************************************************************************
*								         *
* 	FORM_COIN_CKSUM_AND_STORE					 *
* 									 *
* 	CHECKSUM THE COINS AND THEN STORE IT OUT 			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

FORM_COIN_CKSUM_AND_STORE
        MMTM    SP,A1,A7,A0
        CALLR   FORM_COIN_CKSUM
        MOVI    COIN_CKSUM,A7
        MOVE    A1,A0
	CALLA	CMOSUNLOCK
        CALLA   WC_BYTE
	CALLA	CMOSLOCK
	MMFM    SP,A1,A7,A0
	RETS

**************************************************************************
*								         *
* 	CCCC								 *
* 									 *
* 	CHECK COIN AND CLEAR ON BAD CHECKSUM -- BASICALLY JUST 		 *
* 	CHECKS OUT THE COIN CHECKSUMS AND IF THEY ARE WRONG IT		 *
* 	CLEARS THEM OUT							 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

CCCC
	MMTM    SP,A0,A1,A7,A2
        CALLR   FORM_COIN_CKSUM      ;THIS SETS US TO THE COINAGE PAGE!
        JRZ     CCCCX                ;ALL IS OK!

	calla	CMOSUNLOCK
        MOVI    COIN_CKSUM_START,A7  ;POINT AT FIRST BYTE
        MOVI    COIN_CKSUM_BYTES,A2  ;NUMBER OF BYTES TO CLEAR
        CLR     A0

CCCC_LOOP
        CALLA   WC_BYTEI             ;WRITE A BYTE
        DSJS    A2,CCCC_LOOP         ;UNTIL THEY'RE DONE!

        CALLR   FORM_COIN_CKSUM_AND_STORE  ;NOW MAKE THE CKSUM VALID
	calla	CMOSLOCK

CCCCX   MMFM    SP,A0,A1,A7,A2
	RETS


**************************************************************************
*								         *
* 	NO_CREDS							 *
* 									 *
* 	THIS IS CALLED TO REMOVE CREDITS AND STUFF FROM THE MACHINE	 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

NO_CREDS
	MMTM    SP,A0,A1,A7
        CALLR   FORM_COIN_CKSUM
        MOVI    COIN_CKSUM,A7
        MOVE    A1,A0
        INC     A0              ;MAKE THE CKSUM BAD!
	calla	CMOSUNLOCK
	CALLA   WC_BYTE
	calla	CMOSLOCK
	MMFM    SP,A0,A1,A7
	RETS

**************************************************************************
*								         *
* 	CR_BOTH								 *
* 									 *
* 	CHECK TO SEE IF THINGS ARE GOOD FOR A LOT OF STUFF		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A2	0 = NEITHER					 *
* 			1 = CAN START					 *
* 			2 = CAN CONTINUE				 *
* 			3 = YOU CAN DO ANYTHING YOU WANT		 *
*								         *
**************************************************************************

CR_BOTH:
	MMTM    SP,A0,A1

	.IF	FORCEFREE
	MOVK	3,A2
	JRUC	CR_BX
	.ENDIF

	MOVK	3,A2		; ASSUME FREEPLAY

        MOVI    ADJFREPL,A0
        CALLA   GET_ADJ		; ARE WE IN FREE PLAY?
	MOVE	A0,A0
	JRNZ	CR_BX

	CLR	A2		; ASSUME NOTHING
        CALLR   GET_CREDITS	; GET CURRENT CREDS
	CMPI	1,A0
	JRLO	CR_BX
        MOVE    A0,A1
        MOVI    ADJCSTRT,A0
        CALLA   GET_ADJ		; GET START CREDS
        CMP     A0,A1
	JRLO	CR_B1
	MOVK	1,A2		; YES, ENOUGH TO START
CR_B1
	MOVI	ADJCCONT,A0
	CALLA	GET_ADJ		; GET CONTINUE CREDS
	CMP	A0,A1
	JRLO	CR_BX
	ORI	2,A2		; SET SECOND BIT

CR_BX	MMFM    SP,A0,A1
	RETS

**************************************************************************
*								         *
* 	CR_STRTP							 *
* 									 *
* 	CHECK TO SEE IF THERE ARE ENOUGH CREDITS TO START		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		.HS.	ENOUGH CREDITS TO START				 *
*								         *
**************************************************************************
CR_STRTP:
	MMTM	SP,A0,A1

	.IF	FORCEFREE
	MOVK	1,A0
	CMPI	0,A0
	JRUC	CR_STX
	.ENDIF

	MOVI	ADJFREPL,A0
	CALLA	GET_ADJ		;ARE WE IN FREE PLAY?
	MOVE	A0,A0
	JRNZ	CR_STX

	CALLR	CCCC		;CHECK IT OUT

	CALLR	GET_CREDITS	;GET CURRENT CREDITS
	CMPI	1,A0
	JRLO	CR_STX
	MOVE	A0,A1
	MOVI	ADJCSTRT,A0
	CALLA	GET_ADJ		;GET NUMBER NEEDED
	CMP	A0,A1		;DO WE HAVE ENOUGH TO START?
CR_STX
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*								         *
* 	CR_CONTP							 *
* 									 *
* 	CHECK TO SEE IF THERE ARE ENOUGH CREDITS TO CONTINUE		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		.HS.	ENOUGH CREDITS TO START				 *
*								         *
**************************************************************************
CR_CONTP
	MMTM	SP,A0,A1

	.IF	FORCEFREE
	MOVK	1,A0
	CMPI	0,A0
	JRUC	CR_CTX
	.ENDIF

	MOVI	ADJFREPL,A0
	CALLA	GET_ADJ		;ARE WE IN FREE PLAY?
	MOVE	A0,A0
	JRNZ	CR_CTX

	CALLR	CCCC		;CHECK IT OUT

	CALLR	GET_CREDITS	;GET CURRENT CREDITS
	MOVE	A0,A1
	CMPI	1,A0
	JRLO	CR_STX
	MOVI	ADJCCONT,A0
	CALLA	GET_ADJ		;GET NUMBER NEEDED
	CMP	A0,A1		;DO WE HAVE ENOUGH TO START?
CR_CTX
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*								         *
* 	P_START								 *
* 									 *
* 	PLAYER STARTED -- DEDUCT REQUISITE NUMBER OF CREDITS		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
P_START
	MMTM	SP,A0,A1,A8
	CALLR	CRED_P
	MOVE	A0,A1
	MOVI	ADJCSTRT,A0
	CALLA	GET_ADJ			;GET NUMBER NEEDED ( IN A0 )
	ADDRM	A0,@GAMEUNITS,W		;CONTINUING COST OF THE GAME
	CALLR	REMOVE_CREDITS
;	CALLA	DEC_HSR			;TAKE 1 FROM HIGH SCORE RESET COUNTER
;	CALLR	GET_CSTR		;GET CREDIT STRING
;	CALLA	G_CRED			;CALL GEORGE
	MMFM	SP,A0,A1,A8
	RETS

**************************************************************************
*								         *
* 	P_CONT								 *
* 									 *
* 	PLAYER CONTINUED -- DEDUCT REQUISITE NUMBER OF CREDITS		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

P_CONT  MMTM    SP,A0,A1,A8
        CALLR   CRED_P
        MOVE    A0,A1
        MOVI    ADJCCONT,A0
        CALLA   GET_ADJ              ;GET NUMBER NEEDED
	ADDRM	A0,@GAMEUNITS,W		; CONTINUING COST OF THE GAME
        CALLR   REMOVE_CREDITS
;        CALLA   DEC_HSR              ;TAKE 1 FROM HIGH SCORE RESET COUNTER
;	CALLR	GET_CSTR		; GET CREDIT STRING
;	CALLA	G_CRED			; CALL GEORGE
	MMFM    SP,A0,A1,A8
	RETS

**************************************************************************
*								         *
* 	P_FULL_GAME_BALANCE						 *
* 									 *
* 	FULL GAME PURCHASED -- DEDUCT BALANCE				 *
* 									 *
* 	ENTRY								 *
* 		A1	BALANCE CREDITS					 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

P_FULL_GAME_BALANCE
	MMTM    SP,A0,A1,A8
        CALLR   CRED_P
	SWAP	A0,A1
	ADDRM	A0,@GAMEUNITS,W		; CONTINUING COST OF THE GAME
        CALLR   REMOVE_CREDITS
	MMFM    SP,A0,A1,A8
	RETS

**************************************************************************
*								         *
* 	REMOVE_CREDITS							 *
* 									 *
* 	REMOVE N CREDITS FROM THE MACHINE				 *
* 									 *
* 	ENTRY								 *
* 		A0	NUMBER OF CREDITS TO REMOVE			 *
* 		A1	NUMBER OF CREDITS ON THE MACHINE		 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

REMOVE_CREDITS
        SUB     A0,A1                ;REMOVE START AMOUNT FROM WHAT WE HAVE
        JRHS    PS1                  ;WE'RE OK.
        CLR     A1                   ;IT WENT NEGATIVE....MAKE ZERO.
PS1:
;XUNIT  CALLR   COIN_PAG
        MOVI    CREDITS,A7
        MOVE    A1,A0                ;PUT WHATS LEFT OUT TO WRITE
	calla	CMOSUNLOCK
	CALLA   WC_BYTE              ;WRITE THE NEW AMOUNT
        CALLR   FORM_COIN_CKSUM_AND_STORE
	calla	CMOSLOCK
;XUNIT  CALLA   DEF_PAGE             ;POINT AT DEFAULT PAGE.
        RETS

TIMEINIT
;	MOVI	PTAB,A0
;TILOOP
;	MOVE	*A0+,A1,L
;	JRZ	TIDONE
;	CLR	A2
;	MOVE	A2,*A1(PTOTTIME),L
;	JRUC	TILOOP
;TIDONE
	RETS


**************************************************************************
*								         *
* 	TIMEINT								 *
* 									 *
* 	TIME INTERRUPT -- CALLED ONCE EVERY TIME THROUGH THE EXEC	 *
* 	LOOP..								 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
* 									 *
* NOTE: TRASHES A0,A1,A2,A3,A14						 *
*								         *
**************************************************************************
MINRES		EQU	1			;MINIMUM TIME RESOLUTION
ONE_SECOND	EQU	55			;THIS MANY TICKS PER SECOND

TIMEINT:
	MOVE	@LAST_TIMER,A0,W		;DO IT VIA TIMER
	MOVE	@GAME_STATE,A3,W		;STATE MUST STAY IN A3
	SRL	3,A3				;SHIFT OUT SUB STATE
	SLL	3,A3

	MOVE	@SUBTIMECNT,A14,W
	ADD	A0,A14
****	INC	A14				;CLICK ANOTHER TICK
	MOVE	A14,@SUBTIMECNT,W
	CMPI	MINRES,A14			;IS IT TIME TO PROCESS?
	JRLO	TIMECHECK			;BR = NO, JUST RETURN

	CLR	A14
	MOVE	A14,@SUBTIMECNT,W
;
;	EVERY MINRES TICKS
;


*
*CHECK FOR ANY OCTOPUS STUFF HERE
*
TIME_OCTO_CHECK:
	CMPI	INAMODE,A3		;OCTOS ONLY ALLOWED IN ATTRACT MODE
	JRNZ	TIMECHECK

	MOVE	@OCTO_FLAG,A0
	JRNZ	TIME_OCTO_PART2		;BR = WORKING ON SECOND PART YET

	MOVE	@SWITCH,A1,L		; GET SWITCH STATE
	NOT	A1
	ANDI	3030H,A1		; BUTTONS ONLY, DUDE
	CMPI	3030H,A1		; ALL TRIGGERS AND BOMBS
	JRNZ	TIME_OCTO_FAIL
	MOVK	1,A0
	MOVE	A0,@SWITCH_SPOKEN,W	;STOP THE "NO WAY JOSE"
	MOVK	1,A0
	MOVE	A0,@OCTO_FLAG,W		;SET THE "WE SAW IT" FLAG
TIME_OCTO_PART2:
	CMPI	2,A0
	JRHS	TIME_OCTO_PART3
	MOVE	@SWITCH,A1,L
	NOT	A1
	MOVE	A1,A2
	ANDI	3030H,A1		;ANY OF THOSE SWITCHES STILL HELD?
	JRNZ	TIME_HSTD_CHECK		;YEP, KEEP WAITING
	MOVE	A2,A1
	ANDI	00240000H,A1		;JUST CHECK THE STARTS
	CMPI	00240000H,A1		;BOTH HELD?
	JRNZ	TIME_OCTO_FAIL
	MOVK	1,A0
	MOVE	A0,@SWITCH_SPOKEN,W	;STOP THE "NO WAY JOSE"
	MOVK	2,A0
	MOVE	A0,@OCTO_FLAG,W		;SET THE "WE SAW IT AGAIN" FLAG
TIME_OCTO_PART3
	MOVE	@COINS,A1		; XUNIT
	sll	16,a1			; XUNIT
	move	@SWITCH,a2		; XUNIT
	NOT	A1
	NOT	a2
	ANDI	00240000H,A1		;STILL HOLDING A START BUTTON?
	JRNZ	TIME_HSTD_CHECK		;BR = YES
	ANDI	3030H,A2		;NOW LOOK AT THE GUN
	CMPI	2020H,A2		;ARE JUST THE BOMB BUTTONS HELD?
	JRNZ	TIME_OCTO_FAIL		;BR = NO SIR, YOU FAILED
;	CREATE	PID_INDW,OCTO_PAGE	;FIRE OFF THE PUSSY PAGE
TIME_OCTO_FAIL:
	CLR	A0
	MOVE	A0,@OCTO_FLAG,W
;
;	CHECK FOR P1 DOWN, P2 DOWN FOR HSTD PAGE
;
TIME_HSTD_CHECK:
****	MOVE	@SWITCH,A1,L		; GET SWITCH STATE
****	NOT	A1
****	ANDI	1F1FH,A1		; STICKS AND BUTTONS ONLY, DUDE
****	CMPI	0202H,A1		; P1 DOWN, P2 DOWN
****	JRNZ	TIME_CRED_CHECK
****	MOVE	@ON_HSTD,A2,W
****	JRNZ	TIMECHECK
****	ADJUST	ADJHSON			; CHECK TO SEE IF HIGHSCORE EXISTS
****	JREQ	TIMECHECK
****	CREATE	PID_INDW,HSTD_ENTRY_POINT
****	JRUC	TIMECHECK
TIME_CRED_CHECK:
****	CMPI	0408H,A1
****	JRNZ	TIMECHECK
****	MOVE	@ON_CRED,A2,W
****	JRNZ	TIMECHECK
****	CREATE	PID_INDW,CRED_ENTRY_POINT

;
;EVERY TICK
;
TIMECHECK
	MOVE	@DISPATCH_DELAY,A14,W
	JRZ	TC_TICK1
	DEC	A14
	MOVE	A14,@DISPATCH_DELAY,W
TC_TICK1
	MOVE	@TIMECNT,A0,W
	MOVE	@TIMER,A14,W
	ADD	A14,A0
	MOVE	A0,@TIMECNT,W
	CMPI	ONE_SECOND,A0
	JRLO	TIME_REAL_RET
;
;EVERY "SECOND"
;
	CLR	A0
	MOVE	A0,@TIMECNT,W		; RESET TIMER

	MOVI	AUD_UPTIME,A0		; TOTAL GAME POWER ON TIME
	CALLA	AUD1

	MOVI	AUD_ONTIME,A0		; GAME POWER ON TIME
	CALLA	AUD1

	CMPI	INPLAY,A3
	JREQ	TIMEGAME
	CMPI	INGAME,A3
	JREQ	TIMEGAME
	CMPI	ININTRO,A3
	JREQ	TIMEGAME
;	CMPI	ININTRO_INITQ,A3
;	JREQ	TIMEGAME
;	CMPI	ININTRO_INITENT,A3
;	JREQ	TIMEGAME
;	CMPI	ININTRO_TEAMSEL,A3
;	JREQ	TIMEGAME
	CMPI	INSTAT,A3
	JREQ	TIMEGAME
	CMPI	INSUBST,A3
	JREQ	TIMEGAME
	CMPI	INBUYIN,A3
	JREQ	TIMEGAME
	CMPI	INEPILOG,A3
	JREQ	TIMEGAME
	CMPI	INGAMEOV,A3
	JRNE	TIME_REAL_RET
TIMEGAME
	MOVI	AUD_PLAYTIME,A0		; GAME PLAY TIME
	CALLA	AUD1

	CMPI	INPLAY,A3
	JREQ	TIMEPLAYER
	CMPI	ININTRO,A3
	JREQ	TIMEPLAYER
;	CMPI	ININTRO_INITQ,A3
;	JREQ	TIMEPLAYER
;	CMPI	ININTRO_INITENT,A3
;	JREQ	TIMEPLAYER
;	CMPI	ININTRO_TEAMSEL,A3
;	JREQ	TIMEPLAYER
	MOVE	@period,A1,W			;LAST PERIOD
	CALLA	get_period_players
	MOVE	@PLAYER_BITS,A1,W
	OR	A0,A1

	CLR	A0				;RESET NUMBER OF PLAYERS
	CLR	A14
TG_LUPE
	BTST	A14,A1
	JRZ	TG_NEXT				;BR=PLAYER NOT ACTIVE
	INC	A0
TG_NEXT
	INC	A14
	CMPI	4,A14
	JRNE	TG_LUPE				;BR=NEXT PLAYER

	JRUC	TIMEPLAYER1

TIMEPLAYER
	MOVE	@CURPLYRS,A0,W
TIMEPLAYER1
	DEC	A0
	SLL	4,A0
	ADDI	PLAYER_TIME_TABLE,A0
	MOVE	*A0,A0,W
	CALLA	AUD1

TIME_REAL_RET
TI_XXX
	RETS

PLAYER_TIME_TABLE
	.word	AUD_1_TIME,AUD_2_TIME,AUD_3_TIME,AUD_4_TIME

**************************************************************************
*								         *
* 	COININT								 *
* 									 *
* 	INTERRUPT ROUTINE PROCESSING FOR COINS				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
COININT:
	move	@C_FLAGS,a0,L		;any flags set?
	jrnz	okay_guys
	move	@C_FLAGS+32,a10
	sll	24,a10
	srl	24,a10
	jrz	NO_COIN_WORK		;nope!
okay_guys

	MOVI	C_FLAGS,A10		;WALK THROUGH THE 3 COUNTERS
	MOVI	5,A9
;	MOVI	L_COIN_BIT,A8		;THIS IS THE BIT TO CHECK
NEXT_SLOT
	cmpi	1,a9
	jrne	no_dbv_kludge
	move	@C_FLAGS+32,a0
	sll	24,a0
	srl	24,a0
no_dbv_kludge
*
*I BELIEVE THAT LC_FLAG IS IN THE LOW BYTE...THEN CC_FLAG...THEN RC_FLAG
*
	MOVE	A0,A1			;GET CURRENT BYTE IN A1
	SRL	8,A0			;SHIFT DOWN TO NEXT
	ANDI	0FFH,A1			;JUST HOLD LEFT SWITCH
	JRZ	TRY_NEXT		;NOT LEFT

	BTST	COIN_FAIL_BIT,A1 	;FAIL LOOKING FOR OPEN?
	JRZ	CHECK_START		;YEP...THAT'S ALL WE NEED DO!
*
*	WE'RE IN A FAIL CONDITION SEE IF WE CAN CANCEL IT!
*
	BTST	COIN_ACK_BIT,A1		;HAS IT BEEN ACKNOWLEDGED?
	JRNZ	FAIL_ACKED		;YEP.....JUST RUN DOWN THE "OPEN" TIMER
*
*	HASN'T BEEN ACKNOWLEDGED.....TIME DOWN AND AUTO ACK IF
*	PROCESS IS DEAD!        THIS SHOULDN'T HAPPEN, BUT
*	DEADLOCKS ARE UGLY!
*
	MOVB	*A10(RUN_TIME),A3	;WE'RE RUNNING OUT OF TIME
	DEC	A3
	MOVB	A3,*A10(RUN_TIME)	;PUT IT BACK!
	JRNZ	TRY_TO_OPEN		;NOW CONTINUE TO OPEN THE SWITCH
*
*	NO ACK IN ALL THIS TIME!
*	PROVIDE THE ACK OURSELVES!
*
	.IF	DEBUG			;THIS IS A FAIL-SAFE...TRAP DURING DEBUG
	JRUC	$
	.ENDIF

	ORI	COIN_ACK_VAL,A1		;ADD IN THE ACK!
	MOVB	A1,*A10			;AND STORE IT BACK!
*
*	WE HAVE ACK...HAVE WE HAD OUR OPEN?
*
FAIL_ACKED
	MOVB	*A10(OPENS_LEFT),A3	;HAVE WE MADE IT?
	JRNZ	TRY_TO_OPEN		;NOT YET...KEEP TRYING.
*
*	WERE OPEN AND HAVE OUR ACK CLEAR OUT THE FLAGS!
*
	MOVB	A3,*A10			;THIS CLEARS OUT THE FLAG
	JRUC	TRY_NEXT		;FLAGS ARE CLEAR...STEP TO NEXT

CHECK_START
	BTST	COIN_SBIT,A1		;"START" FLAG?
	JRNZ	TIME_START		;YEP......KEEP TIMING
*
*	HERE BY PROCESS OF ELIMINATION...ITS "SUCC" BIT OR
*	SOMTHING ELSE GOT SET.....SIMPLY TIME IT DOWN
*	IN CASE SOMEONE TRASHED IN ON THIS BYTE
*
	MOVB	*A10(RUN_TIME),A3	;WE'RE RUNNING OUT OF TIME
	DEC	A3
	MOVB	A3,*A10(RUN_TIME)	;PUT IT BACK!
	JRNZ	TRY_NEXT		;WHEN IT HITS ZERO...WE'LL CLEAR OUT!

	.IF	DEBUG			;THIS IS A FAIL-SAFE...TRAP DURING DEBUG
	JRUC	$
	.ENDIF

	MOVB	A3,*A10			;CLEAR OUT THE FLAGS...PROC IS GONE!
	JRUC	TRY_NEXT		;MUST BE SUCCESS...NO ACTION.

TIME_START
	MOVB	*A10(RUN_TIME),A3	;WE'RE RUNNING OUT OF TIME
	DEC	A3
	MOVB	A3,*A10(RUN_TIME)	;PUT IT BACK!
	JRNZ	TRY_TO_OPEN		;NOW CONTINUE TO OPEN THE SWITCH
*
*	THIS ONE TIMED OUT......ITS FAIL FLAG TIME!
*
	MOVI	COIN_FAIL_VAL,A3
	MOVB	A3,*A10			;WE HAVE FAILURE

	MOVI	ACC_LIMIT,A3
	MOVB	A3,*A10(RUN_TIME)	;THIS IS TIME LIMIT FOR PROCESS TO ANSWER!
*
TRY_TO_OPEN
;        CMPI	8,A8
;	JRZ	TTOFOURTH		;	ANOTHER KLUDGE FOR XCOIN
;	MOVE	@COINS,A2,W		;THE SWITCH HAS 1/2 SECOND TO OPEN
;	CMPI	4,A8			;	SPECIAL CHECK FOR CENTER CHUTE
;	JRZ	TTOCENTER
;	AND     A8,A2			;A1 CONTIAINS ZERO FOR CLOSED
;	JRZ	STILL_CLOSED		;ITS CLOSED...RE-START THE OPEN COUNT
;	JRUC	TTOGO
;TTOCENTER
;	ANDI	80H,A2			;MASK FOR JAMMA CENTER
;	JRZ	STILL_CLOSED
;	JRUC	TTOGO
;TTOFOURTH
;	MOVE	@SWITCH2,A2,W
;	ANDI	20H,A2
;	JRZ	STILL_CLOSED
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
; very inelegant, and besides, it doesn't work !
;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
; better way to do it, using a table
	move	a9,a8
	dec	a8			;avoid being 1 to many
	sll	4,a8
	addi	which_bits_to_test,a8
	move	*a8,a8
	move	@COINS,a2,W		;the switch has 1/2 second to open
	and	a8,a2
	sll	16,a2
	jrz	STILL_CLOSED
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
TTOGO
*
*	ITS OPEN
*
	MOVB	*A10(OPENS_LEFT),A3	;HAVE WE MADE IT?
	JRZ	HIT_ZERO		;WE HAVE A LONG ENOUGH OPEN
	DEC	A3
	MOVB	A3,*A10(OPENS_LEFT)	;PUT IT BACK
	JRNZ	TRY_NEXT		;TRY THE NEXT BYTE
*
*	WE HIT ZERO....IF "START FLAG" IS ON THEN WE HAVE SUCCESS
*
HIT_ZERO
	BTST	COIN_SBIT,A1		;"START" FLAG?
	JRZ	TRY_NEXT		;NOPE....

	MOVI	COIN_SUCC_VAL,A3
	MOVB	A3,*A10			;INDICATE WE MADE IT!

	MOVI	ACC_LIMIT,A3
	MOVB	A3,*A10(RUN_TIME)	;THIS IS TIME LIMIT FOR PROCESS TO ANSWER!

	JRUC	TRY_NEXT

STILL_CLOSED
	MOVI	MIN_OPENS,A1		;THIS MANY FRAMES OF OPEN TIL OPEN
	MOVB	A1,*A10(OPENS_LEFT)

TRY_NEXT
	ADDI	8,A10			;NEXT BYTE
	SLL	1,A8			;NEXT COIN BIT

	DSJ	A9,NEXT_SLOT

NO_COIN_WORK
	RETS


which_bits_to_test
	.word	DBV_BIT
	.word	X_COIN_BIT
	.word	C_COIN_BIT
	.word	R_COIN_BIT
	.word	L_COIN_BIT

**************************************************************************
*									 *
* 	SLAM_P								 *
* 									 *
* 	IS THERE A SLAM PROCESS RUNNING					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		.EQ.	NO						 *
* 		.NE.	YES						 *
*								         *
**************************************************************************
SLAM_P
	MOVI	PID_SLAM,A0
	CALLA	EXISTP_ALL
	RETS

**************************************************************************
*								         *
* 	SLAM								 *
* 									 *
* 	PROCESS THAT STARTS UP WHEN WE GET SLAMMED ON			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
SLAM
	MOVI	AUD_SLAMS,A0
	CALLA	AUD1
	MOVI	PID_SLAM,A0		;YOU KNOW WHO YOU ARE DAHLINGS
	MOVE	A0,*A13(PROCID),W	;SET OUR ID TO SLAM
	CALLA	KILLPROC_ALL		;KILL ANY OTHER INCARNATIONS
	SLEEP	40H			;1 SECOND OF COIN IGNORING.
	JAUC	SUCIDE
