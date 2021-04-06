   	.MLIB	"HHMACS.LIB"
	.FILE	"HHADJ.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

**************************************************************************
*								         *
* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		 *
* 		       ALL RIGHTS RESERVED.				 *
*								         *
**************************************************************************

	.INCLUDE	"hh.inc"
	.INCLUDE	"IMGTBL.GLO"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"HHDICT.H"
	.include	"hhadj.e"
	.include	"hhproc.g"
	.include	"hhutil.g"
	.include	"hhtext.g"
	.include	"hhmenu.g"
	.include	"hhcmos.g"
	.include	"hhdtst.g"
	.include	"hhcoin.g"
	.include	"hhsnd.g"

; end of include files

	.bss	ramtemp1,32
	.bss	ramtemp2,32
	.bss	justlooking,32

	.TEXT

**************************************************************************
*								         *
* 	 GET_CSPT							 *
* 									 *
* 	 THIS IS CALLED TO RETURN IN A6 THE CURRENT			 *
* 	 CSELCT LINE AS STORED IN THE ADJUSTMENT TABLE.			 *
*								         *
**************************************************************************
GET_CSPT
	MMTM	SP,A0
	MOVI	ADJPRICE,A0
	CALLA	GET_ADJ		;GET THE COIN SELECT NUMBER BEING USED.
	CALLR	CS_POINT
	MMFM	SP,A0
	RETS

**************************************************************************
*								         *
* 	 CS_POINT							 *
* 									 *
* 	 THIS IS CALLED TO POINT AT AN ENTRY IN THE COINAGE		 *
* 	 SELECT TABLE.							 *
* 									 *
* 	 IT TAKES OFFSET IN A0.						 *
* 	 IT RETURNS POINTER IN A6.					 *
*								         *
**************************************************************************
CS_POINT
	MMTM	SP,A0,A1
	MOVE	A0,A0		;ZERO?
	JRZ	CS1		;YEP...RETURN FIRST LINE

	CMPI	CS_ENTS,A0	;IN RANGE?
	JRLS	CS2		;YEP...CONTINUE
	MOVI	1,A0		;TOO LARGE.......USE 1ST LINE.
CS2	DEC	A0		;INDEX INTO TABLE
CS1	MOVI	CS_SIZE,A1	;SIZE PER ENTRY
	MPYU	A0,A1		;OFFSET INTO TABLE
	ADDI	CSELCT,A1
	MOVE	A1,A6		;RETURN THE POINTER
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*								         *
* 	 BINBCD								 *
* 									 *
* 	 CONVERT BINARY NUMBER IN A0 TO BCD.				 *
*								         *
**************************************************************************
BINBCD
	MMTM	SP,A1,A2,A3,A4,A5
	CMPI	99999999,A0		;ARE WE TOO BIG?
	JRLS	BBIR			;IN RANGE
	MOVI	99999999H,A0		;RETURN THE LARGEST NUMBER WE HAVE!
	JRUC	BB_RET
BBIR	MOVI	10,A1			;ALWAYS DIVIDE BY A0
	CLR	A5			;ACCUMULATE RESULT IN A5
	CLR	A4			;A4 HAS CURRENT SHIFT COUNT
	MOVE	A0,A3			;<A2><A3> HAS NUMERATOR
DO_BCD_AGAIN
	CLR	A2
	DIVU	A1,A2			;A2 HAS LEFTOVER...A3 HAS CURRENT DIGIT
	SLL	A4,A3			;SHIFT IT CORRECT NUMBER OF TIMES
	ADD	A3,A5			;ADD IT INTO RESULT REG
	ADDK	4,A4			;ADD 4 TO SHIFT COUNT
	MOVE	A2,A3			;REFRESH NUMERATOR
	JRNZ	DO_BCD_AGAIN
	MOVE	A5,A0			;PUT OUT RESULT
BB_RET	MMFM	SP,A1,A2,A3,A4,A5
	RETS

**************************************************************************
*								         *
* 	 BCDBIN								 *
* 									 *
* 	 THIS TURNS A BCD NUMBER (IN A0) INTO A BINARY			 *
* 	 NUMBER.							 *
*								         *
**************************************************************************
BCDBIN
	MMTM	SP,A1,A2,A3,A4,A5	;WORK REGGIES.
	CLR	A2			;ACCUMULATE IN A2
	MOVI	1,A3			;CURRENT FACTOR IS 1.
	MOVI	10,A4			;SAVE SOME MOVI INSTS LATER
	MOVI	16,A5			;DIVIDE IT DOWN BY 16 AT A TIME
BCBLOOP
	MOVE	A0,A1			;DIVIDEND IN <A0><A1>
	JRZ	BCBDONE			;ALL UNITS EXHAUSTED!
	CLR	A0
	DIVU	A5,A0			;DIVIDE BY 10H...(REMAINDER IN A1)
	MPYU	A3,A1			;TIMES POSITION FACTOR
	ADD	A1,A2			;INTO ACCUMULATION REGISTER
	MPYU	A4,A3			;NEXT DIGIT IS WORTH 10 TIMES THIS ONE
	JRUC	BCBLOOP

BCBDONE
	MOVE	A2,A0			;RETURN RESULT IN A0
	MMFM	SP,A1,A2,A3,A4,A5	;WORK REGGIES.
	RETS

*
*	Adjustment menu requested.....make sure CMOS is ok!
*
GO_GADJ
	MOVI	MEN_GADJ,A8
	MOVI	COLOR_WHITE,A14
	MOVE	A14,@LASTCOLOR,W
        jruc    GEN_ADJUST

GO_PADJ
	MOVI	MEN_PADJ,A8
	MOVI	COLOR_WHITE,A14
	MOVE	A14,@LASTCOLOR,W

GEN_ADJUST
	MOVE	A8,-*A12,L		;PUSH MENU ON STACK

	CALLA	CMOS_VAL		;CHECK OUT THE REGION
	JRZ	SET_OK			;ITS OK.....CONTINUE....
	CALLA	FAC_SET
;	JSRP    GET_FAC	    ;BRING TO FACTORY SETTINGS OR QUIT.
;	JSRP    ANY_BUT

	CALLA	CMOS_VAL		;CAN'T GO IF WE'RE NOT OK NOW
	JRNZ	GO_ADQ			;ITS NOT VALID....NO ADJUSTING!

SET_OK
	MOVK	1,A0
	MOVE	A0,-*A12,W		;LIKE GEN_MENU...KEEP NUMBER ON STACK
*
ADJ_LOOP
	CALLA	CLR_SCRN		;CLEAR THE SCREEN!

	MOVI	ADJ_ADV,A8
	JSRP	L_MESS			;PRINT THE NEW INSTRUCTIONS

	MOVE	*A12(WORD_SIZE),A8,L	;GET THE MENU
	JSRP	MENU_TOP		;PRINT OUT THE TOP.
	MOVI	COLOR_RED,A9
	CALLA	COL_INST		;PUT UP A DIFFERENT INSTR. BOX

	MOVE	*A12,A9,W		;GET INDEX TO USE.
	JSRP	B_MENU			;FETCH THE ENTRY TO ADJUST.
*
*	EACH ADJUSTMENT HAS A STRUCTURE ASSOCIATED WITH IT.
*	A9 RETURNS A STRUCTURE FOR THE ITEM SELECTED.
*
	MOVE	A9,A9			;0 IS RETURN TO MAIN MENU
	JRZ	GO_ADJX
*
*	A8 HAS THE MENU NUMBER.....UNLIKE GEN_MENU...DON'T STEP!
*
	MOVE	A8,*A12,W		;PUT IT SAFELY ON OUR STACK.

	MOVE	*A9(AD_ROUT),A0,L	;GET THE ROUTINE TO CALL FOR ACTIVATION
	MOVI	ADJ_LOOP,A7
	MOVE	A7,-*A12,L		;PUSH RETURN ADDRESS
	JUMP	A0			;"CALL THE ROUTINE (PASSING STRUCT IN A9)
GO_ADJX
	ADDI	WORD_SIZE,A12		;"POP" THE POSITION INDICATOR
GO_ADQ
	ADDI	LONG_SIZE,A12		;POP MENU
	RETP				;OK...RETURN!

**************************************************************************
*								         *
* 	 PRICE_ADJ							 *
* 									 *
* 	 THIS IS EXECUTED WHEN THE "CUSTOM PRICING" ENTRY IS		 *
* 	 SELECTED FOR ADJUSTMENT FROM THE ADJUSTMENT MENU.		 *
* 									 *
* 	 IT CREATES A WHOLE NEW ADJUSTMENT MENU CONTIANING:		 *
* 									 *
* 									 *
* 			LEFT CHUTE UNITS				 *
* 			RIGHT CHUTE UNITS				 *
* 			THIRD CHUTE UNITS				 *
* 			FOURTH CHUTE UNITS				 *
* 			UNITS / CREDIT					 *
* 			UNITS / BONUS					 *
* 			MINIMUM UNITS					 *
* 			CREDITS TO START				 *
* 			CREDITS TO CONTINUE				 *
* 			COINS PER DOLLAR				 *
* 			MAXIMUM CREDITS					 *
*								         *
**************************************************************************
PRICE_ADJ
	MOVI    MEN_CUST,A8	  ;HANDLE JUST LIKE MAIN ADJ. MENU
	MOVI	COLOR_BLUE,A14
	MOVE	A14,@LASTCOLOR,W
	JAUC    GEN_ADJUST


MULT_ADJ:
	movi	MEN_MULT,a8	      ;handle just like main adj. menu
	movi	COLOR_BLUE,a14
	move	a14,@LASTCOLOR,W
	jauc	GEN_ADJUST


DO_MULT:
	.long	MULT_ADJ 	     ;routine to run
	.long	MESS_MULT
	.long	HELP_MULT
	.word	ADJPRICE	     ;cmos adjustment we're setting
	.long	1		     ;minimum value
	.long	99       	     ;maximum value
	.long	1		     ;move up and down by 1's
	.long	0		     ;don't sub zero for any
	.long	MULT_VAL	     ;routine for showing current value
	.word	WRAP_VAL	     ;wrap around on coin modes
	.long	0		     ;list of messages for this adj.
	.long	MESS_MULT 

MESS_MULT:
	.string "CUSTOM MULTIPLIERS"
	.byte 0
	.even



**************************************************************************
*								         *
* 	 GEN_ADJ							 *
* 									 *
* 	 THIS IS THE ROUTINE THAT IS EXECUTED TO DO			 *
* 	 THE ADJUSTING ONCE A BUTTON IS CLICKED ON			 *
* 	 AN ADJUSTMENT.							 *
* 									 *
* 	 A9 -> ADJUSTMENT STRUCTURE!					 *
*								         *
**************************************************************************
MEN_OFF  EQU     PDATA		;WORD-OFFSET INTO MENU OF SELECTION
MEN_ROUT EQU     MEN_OFF+WORD_SIZE    ;LONG-ROUTINE FOR SELECTION
MEN_ROM  EQU     MEN_ROUT+LONG_SIZE   ;LONG-POINTER TO ROM STRUCTURE
MEN_ULX  EQU     MEN_ROM+LONG_SIZE    ;WORD-LEFT X  (CENTER X WHEN CENTERING)
MEN_ULY  EQU     MEN_ULX+WORD_SIZE    ;WORD-TOP Y
MEN_DY   EQU     MEN_ULY+WORD_SIZE    ;WORD-Y UNITS PER ENTRY
MEN_COLR EQU     MEN_DY+WORD_SIZE     ;WORD-COLOR FOR ENTRIES
MEN_BAR  EQU     MEN_COLR+WORD_SIZE   ;WORD-HEIGHT OF SELECTION BAR
MEN_BDY  EQU     MEN_BAR+WORD_SIZE    ;WORD-DY FROM TOP OF TEXT TO TOP OF BAR.
MEN_BDX  EQU     MEN_BDY+WORD_SIZE    ;WORD-DX FROM LEFT OF WORD TO LEFT OF BAR
MEN_BWID EQU     MEN_BDX+WORD_SIZE    ;WORD-WIDTH OF BAR
MEN_SCOL EQU     MEN_BWID+WORD_SIZE   ;WORD-COLOR OF SELECTED TEXT
MEN_TPTR EQU     MEN_SCOL+WORD_SIZE    ;LONG-POINTER TO BEGINNING OF TEXT ENTRIES.
MEN_ENTS EQU     MEN_TPTR+LONG_SIZE   ;WORD-NUMBER OF ENTRIES IN MENU
MEN_CUR  EQU     MEN_ENTS+WORD_SIZE   ;WORD-CURRENT SELECTION (1ST IS 1)
MEN_WALK EQU     MEN_CUR+WORD_SIZE    ;WORD-NUMBER OF ENTRY WE'RE ON AS WE WALK
MEN_STIK EQU     MEN_WALK+WORD_SIZE   ;LONG-"STUCK" STATE OF SWITCHES
MEN_ACT  EQU     MEN_STIK+LONG_SIZE   ;LONG-SWITCH WE'RE ACTING ON. (BIT)
MEN_TYPO EQU     MEN_ACT+LONG_SIZE    ;WORD-TYPOMATIC COUNTER
MEN_HITS EQU     MEN_TYPO+WORD_SIZE   ;WORD-CONSECUTIVE TYPOMATIC HITS
MEN_ADV  EQU     MEN_HITS+WORD_SIZE   ;WORD-NON-ZERO IF ADVANCE WAS BUTTON USED

GEN_ADJ
	MOVE	A9,*A13(PDATA),L	;SAVE THE STRUCTURE POINTER

	MOVE	A9,A8			;GET TO GENERAL POINTING REGISTER
	JSRP	DO_IN_WHITE		;GO FROM LF TO WHITE RIGHT AWAY.

;	JSRP	ADJ_DOOR		;CAN'T DO IT UNLESS DOOR IS OPEN.
;	MOVE	A0,A0
;	JRNZ	ADJ_CAN			;CANCELLED
*
	CALLR	CLR_MAIN		;CLEAR OUT THE MAIN MENU REGION
	CALLR	ADJ_INST		;PUT INSTRUCTIONS AT BOTTOM.
	JSRP	ST_STICK		;LOCKOUT STUCK SWITCHES
	CLR	A0
	MOVE	A0,*A13(MEN_HITS),W
	MOVE	A0,*A13(MEN_TYPO),L

	SLEEP	1			;STOP RACE ON INSTRUCTIONS
	SLEEP	1			;BE OVER PARANOID
ADJ_CHNG
	SLEEP	1			;NOW LOOP ON STICK...EXIT

	JSRP	GETSTICK		;CHECK OUT THE PLAYER BOARD
	MOVE	A0,A0
	JRNZ	ML1			;BR = GOT SOMETHING
	MOVE	A0,*A13(MEN_HITS),W	;CLEAR TIMER AND DIRECTION
	MOVE	A0,*A13(MEN_TYPO),W
	JRUC	ADJ_CHNG
ML1
	MOVE	*A13(MEN_HITS),A1,W	;GET LAST DIRECTION
	ANDI	7,A1			;MASK OFF REPEAT BIT
	CMP	A0,A1
	JRZ	ML2			;BR = YES, STILL SAME THING
	MOVE	A0,*A13(MEN_HITS),W
	CLR	A1
	MOVE	A1,*A13(MEN_TYPO),W	;CLEAR THE TIMER
	JRUC	MLDONE			;PROCESS INITIAL HIT
ML2
	MOVE	*A13(MEN_HITS),A1,W	;SNAG THE REPEAT BIT
	ANDI	80H,A1
	JRNZ	ML3			;BR = IN REPEAT MODE
	MOVE	*A13(MEN_TYPO),A0,W	;GET TIMER
	INC	A0
	MOVE	A0,*A13(MEN_TYPO),W
	CMPI	15,A0
	JRLO	ADJ_CHNG		;GO BACK TO SLEEP
	CLR	A0
	MOVE	A0,*A13(MEN_TYPO),W	;CLEAR OUT THE TIMER
	MOVE	*A13(MEN_HITS),A1,W
	MOVE	A1,A0
	ORI	80H,A1			;PUT UPPER BIT ON
	MOVE	A1,*A13(MEN_HITS),W	;SET DIRECTION WITH REPEAT ON
	JRUC	MLDONE
ML3
	MOVE	*A13(MEN_TYPO),A0,W	;GET TIMER
	INC	A0
	MOVE	A0,*A13(MEN_TYPO),W
	CMPI	5,A0
	JRLO	ADJ_CHNG		;GO BACK TO SLEEP
	CLR	A0
	MOVE	A0,*A13(MEN_TYPO),W	;CLEAR OUT THE TIMER
	MOVE	*A13(MEN_HITS),A0,W
	ANDI	7H,A0			;TURN OFF REPEAT BIT
MLDONE
	MOVE	*A13(PDATA),A8,L	;GET OUR POINTER
	MOVE	A0,A1			;KEEP GETSTICK VALUE
	JRZ	ADJ_CHNG		;ITS ZERO....NO MORE WORK NEEDED

	MOVE	*A8(AD_CMOS),A0,W	;GET ADJ NUMBER
	MOVE	A0,A2			;COPY FOR LATER

	CALLR	GET_EADJ		;READ IT OUT (FIXING ZERO IF NEC)
	MOVE	A0,A3			;SAVE "OLD" VALUE
*
*	A0 = ADJUSTMENT VALUE
*	A1 = GET_STICK VALUE
*	A2 = ADJUSTMENT NUMBER
*	A3 = ADJUSTMENT VALUE READ!
*	A8 = ADJUSTMENT STRUCTURE POINTER
*
	CMPI	3,A1			;BUTTON......BACK TO ADJ MENU!
	JRZ	ADJ_BUTT		;YEP....WE'RE OUT OF HERE.

	CMPI	2,A1
	JRZ	ADJ_DOWN		;ITS DOWN....
*
*	REQUEST TO GO UP....
*
	CALLR   INC_ADJ			;INCREMENT IT
	JRUC	ADJ_JOIN

ADJ_DOWN
	CALLR	DEC_ADJ			;DECREMENT IT
ADJ_JOIN
	MOVE	A2,A0			;ADJUSTMENT NUMBER
	CALLR	GET_EADJ		;READ IT OUT (FIXING ZERO IF NEC)
	CMP	A0,A3			;DID IT NOT CHANGE?
	JRZ	ADJ_CHNG		;NOPE....NO ACTION!
*
*	IT CHANGED....WE NEED TO BEEP AND RE-PLOT LOWER
*	PORTION TO REFLECT NEW SETTING.
*
        movi    S_TIMER_TICK,a4
        calla   do_sound                ; MAKE A CHANGE VALUE BEEP.

	JSRP	DO_IN_WHITE		;AND UPDATE THE ADJUSTMENT

	JRUC	ADJ_CHNG		;AND LOOP!

DO_IN_WHITE
	CALLR	CLR_CUR			;CLEAR OUT CURRENT SETTING
	MOVI	COLOR_WHITE,A11		;THEY'RE STARING....NO HEADACHES
	JAUC	AD_CRVAL		;PRINT THE NEW VALUE

ADJ_BUTT
        movi    S_CURSOR_SELECT,a4
        calla   do_sound                ; MAKE AN ACCEPT BEEP
*
*	KILL THE FLASHING ARROW
*
*	MOVE    *A13(PROCID),A0,W	     ;NOW KILL HIM
*	MOVI    0FFFFH,A1
*	CALLA   KILALL			;THIS WILL DO IT!

ADJ_CAN  RETP

PRICE_CHECK
	CMPI	DO_PRICE,A8
	JRNZ	PRICE_RET
	MMTM	SP,A0,A1,A6
	MOVI    ADJ1ST6,A0	; NON-STANADARD TITLE IF 1ST 6 MODIFIED
	CALLA   GET_ADJ	     	; WELL?
	JRNZ	PRICE_PROC_RET	; PUT OUT THE TITLE LINE AS TAMPERED!
	MOVI	ADJ1ST6,A0
	MOVK	1,A1
	CALLA	PUT_ADJ
	CALLR	GET_CSPT
	CALLR	SET_COIN_ADJ		; SET THE ADJUSTMENTS UP IN CMOS
	MMFM	SP,A0,A1,A6
	MOVE	A0,A3
	INC	A0
	SETZ
	JRUC	PRICE_RET
PRICE_PROC_RET
	MMFM	SP,A0,A1,A6
	CLRZ
PRICE_RET
	RETS

**************************************************************************
*								         *
* 	 DEC_ADJ							 *
* 									 *
* 	 THIS IS CALLED TO MOVE TO THE PREVIOUS VALUE.			 *
* 	 A0 = VALUE READ FROM CMOS					 *
* 	 A2 = ADJUSTMENT NUMBER (TO WRITE IT BACK)			 *
* 	 A8 = ADJUSTMENT STRUCTURE POINTER.				 *
* 									 *
* 	 INC_ADJ IS USED TO STEP TO THE NEXT VALUE			 *
*								         *
**************************************************************************
DEC_ADJ
	MMTM	SP,A0,A1,A2,A3
	CALLR	PRICE_CHECK
	JRZ	FINISH_CHANGE
	MOVE	A0,A3			;COPY ORIGINAL VALUE
	MOVE	*A8(AD_DELTA),A1,L	;GET UNITS BETWEEN VALUES
	CALLR	MAKE_BIN_IF_NEC		;CHANGE RADIX FOR MATH IF NECESSARY
	SUB	A1,A0			;REMOVE THIS FROM READ VALUE
	JRUC	FINISH_CHANGE		;GO TO COMMON ROUTINE TO WRAP IT UP

INC_ADJ
	MMTM	SP,A0,A1,A2,A3
	CALLR	PRICE_CHECK
	JRZ	FINISH_CHANGE
	MOVE	A0,A3			;COPY ORIGINAL VALUE
	MOVE	*A8(AD_DELTA),A1,L	;GET UNITS BETWEEN VALUES
	CALLR	MAKE_BIN_IF_NEC
	ADD	A1,A0			;REMOVE THIS FROM READ VALUE

FINISH_CHANGE
	CALLR	BCD_IF_NEC		;BACK TO BCD AFTER THE MATH
	CALLR	PUT_IN_RANGE		;ADJUST TO ACCOUNT FOR WRAP AND LIMITS
	MOVE	*A8(AD_ZEQU),A1,L	;This number becomes zero
	CMP	A0,A1			;is this the number?
	JRNZ	FC_NZ			;NOPE...STORE IT!
	CLR	A0			;USE ZERO IN PLACE OF THIS NUMBER!

FC_NZ
	MOVE	A0,A1			;WRITING REG
	MOVE	A2,A0			;ADJUSTMENT NUMBER
	CALLA	PUT_ADJ			;WRITE IT BACK
*
*	SEE IF WE'RE DOING MASTER COINAGE.
*
	CMP     A1,A3			 ;DID THE NUMBER CHANGE?
	JRZ     NOT_COIN		      ;NOPE...DON'T LOAD IT UP!
*
*	AT THIS POINT WE KNOW THAT THE VALUE BEING ADJUSTED CHANGED.
*
	CALLR   DIRTY_IF_NEC		  ;IF ITS A COIN VALUE TAKE NOTE!

	CMPI    ADJPRICE,A0		   ;IS IT?
	JRNZ    NOT_COIN		      ;NOT COIN

;	CALLA   LD_CTAB			;BATCH WRITE THE VALUES IN!
	CALLA   NO_CREDS		      ;REMOVE CREDITS AND FRACTIONS WHEN
*					      ;MODE CHANGES

NOT_COIN
	CALLA   F_ADC_S			;MAKE CHECKSUM VALID!
	MMFM    SP,A0,A1,A2,A3
	RETS

**************************************************************************
*								         *
* 	 DIRTY_IF_NEC							 *
* 									 *
* 	 THIS IS CALLED BY ALL ADJUSTMENTS WHEN THEY ACTUALLY		 *
* 	 CHANGE THEIR VALUE.  FOR THE COINAGE ADJUSTMENTS,		 *
* 	 IF ANY OF THE 1ST 6 VALUES ARE TOUCHED WE NEED TO MAKE		 *
* 									 *
* 			 ADJ1ST6 = ZERO.				 *
* 									 *
* 	 IF ANY OF THE 1ST 8 VALUES ARE TOUCHED WE NEED TO MAKE		 *
* 									 *
* 			 ADJVIRGIN = ZERO.				 *
* 									 *
* 	 THE AD_FLAGS FIELD IN THE ADJUSTMENT STRUCTURE HAVE BITS	 *
* 	 INDICATING WHICH (IF ANY) SHOULD BE DIRTYED.			 *
*								         *
**************************************************************************
DIRTY_IF_NEC
	MMTM    SP,A0,A1,A2
	MOVE    *A8(AD_FLAGS),A2,W	;FETCH THE FLAGS

	BTST    VIRG_BIT,A2	      ;DOES CHANGING THIS SAY SET VIRG BIT.
	JRZ     NOT_1ST_8		;NOPE

	MOVI    ADJVIRGIN,A0
	CLR     A1
	CALLA   PUT_ADJ

NOT_1ST_8
	BTST    SIX_BIT,A2		;1ST 6?
	JRZ     NOT_1ST_6

	MOVI    ADJ1ST6,A0
	CLR     A1
	CALLA   PUT_ADJ
NOT_1ST_6
	BTST    HSR_BIT,A2		;HIGH SCORE RESET NUM?
	JRZ     NOT_HSR		  ;NOPE

;	CALLA   INIT_HSR		 ;IT WAS CHANGED....STUFF THE VALUE!

NOT_HSR
	MMFM    SP,A0,A1,A2
	RETS

**************************************************************************
*								         *
* 	 MAKE_BIN_IF_NEC						 *
* 									 *
* 	 THIS IS CALLED AFTER THE A0 HAS THE ADJUSTMENT AND		 *
* 	 A1 HAS THE AMOUNT TO ADD OR SUBTRACT.  IF WE'RE		 *
* 	 DOING BCD MATH THEN CONVERT BOTH A0 AND A1.			 *
*								         *
**************************************************************************
MAKE_BIN_IF_NEC
	MMTM    SP,A2
	MOVE    *A8(AD_FLAGS),A2,W	    ;GET THE FLAGS
	BTST    BCD_BIT,A2		    ;BCD?
	JRZ     MBINX			 ;NOPE

	CALLA   BCDBIN			;CONVERT A0 TO BINARY
	MOVE    A0,A2			 ;SAVE
	MOVE    A1,A0			 ;NOW A1
	CALLA   BCDBIN
	MOVE    A0,A1
	MOVE    A2,A0			 ;NOW PUT A0 BACK
MBINX	MMFM    SP,A2
	RETS

**************************************************************************
*								         *
* 	 BCD_IF_NEC							 *
* 									 *
* 	 A0 HAS A RESULT OF THE ADJUSTMENT.....IN BINARY.		 *
* 	 CONVERT BACK TO BCD IF THAT'S THE MODE.			 *
*								         *
**************************************************************************
BCD_IF_NEC
	MMTM	SP,A2
	MOVE	*A8(AD_FLAGS),A2,W	;GET THE FLAGS
	BTST	BCD_BIT,A2		;BCD?
	JRZ	BINX			;NOPE

	CALLA	BINBCD			;BACK TO BCD
BINX
	MMFM	SP,A2
	RETS

ADJ_BEEP .WORD	0F3DFH,010H,080B6H,0	;ADJUSTMENT CHANGED
ADJ_CASH .WORD	0F3DFH,010H,08105H,0	;ADJUSTMENT STORED

**************************************************************************
*								         *
* 	 CLR_CUR							 *
* 									 *
* 	 THIS IS CALLED TO CLEAR OUT THE AREA WHERE THE			 *
* 	 "CURRENT SETTING" IS BEING DISPLAYED.				 *
*								         *
**************************************************************************
CLR_CUR
	MMTM	SP,A3,A4
	MOVE	*A13(ADS_STRUCT),A4,L
	CMPI	DO_PRICE,A4
	JRZ	CCSKIP
	CMPI	DO_PARAM,A4
	JRZ	CCSKIP

	MOVI	AM_HX,A3		;THIS IS LEFT MARGIN OF HELP AREA

	MOVI	CUR_LRX,A4		;RIGHT X
	SUB	A3,A4			;A4 HAS X DISTANCE

	ADDI	ADJ_ULY*10000H,A3	;UPPER LEFT Y
	ADDI	(400-ADJ_ULY)*10000H,A4	;Y GOES TO BOTTOM OF SCREEN
	CALLA	BLNKAREA		;ITS BLANK NOW!
CCSKIP
	MMFM	SP,A3,A4
	RETS

**************************************************************************
*								         *
* 	 CLR_MAIN							 *
* 									 *
* 	 THIS IS CALLED TO CLEAR OUT THE ADJUSTMENT MENU AND		 *
* 	 THE CYAN INSTRUCTIONS FOR THIS MENU.				 *
*								         *
**************************************************************************
CLR_MAIN
	MMTM	SP,A3,A4
	MOVI	TIT_ULX,A3		;LEFT EDGE
	MOVI	AM_HX,A4		;UP TO THIS EDGE
	SUB	A3,A4			;X'S ARE SET.
	ADDI	INST_ULY*10000H,A3	;TOP Y
	ADDI	(400-INST_ULY)*10000H,A4	;Y DISTANCE
	CALLA	BLNKAREA
	MMFM	SP,A3,A4
	RETS

ADJ_LBEEP
	.WORD	0F3DFH,010H,080A2H,0		;LOW BEEP

**************************************************************************
*								         *
* 	 ADJ_INST							 *
* 									 *
* 	 THIS IS CALLED TO PUT AN INSTRUCTION BOX OUT			 *
* 	 WHILE ADJUSTMENT IS TAKING PLACE.				 *
*								         *
**************************************************************************
ADJ_INST
	MOVE    *A13(PDATA),A8,L     ;PASS THE ADJUSTMENT POINTER
;	MOVI    ADJ_INST_P,A7
;	CALLA   P_FORK	      ;START IT UP!
	P_FORK	ADJ_INST_P
	RETS

**************************************************************************
*								         *
* 	 ADJ_INST_P							 *
* 									 *
* 	 THIS IS CALLED TO PUT INSTRUCTIONS FOR ADJUSTMENT		 *
* 	 MODIFICAITION UP AND FLASH THE ARROW (IF ITS NOT		 *
* 	 TOO ANNOYING)							 *
*								         *
**************************************************************************
ADJ_INST_P
	JSRP	ADJUSTING	;PUT UP "ADJUSTING DIFFICULTY" MESSAGE

	MOVE	A10,A3		;STASH # OF ARROWS WHERE IT WILL BE SAFE
	CALLR	ADINBOX		;PUT THE BOX OUT

	MOVI	INST_TO_ADJ,A8
	JSRP	L_MESS		;PRINT OUT INSTRUCTIONS

	MOVI	ADJ_ARROW,A8
	JSRP	LM_PRINTF

	JAUC	SUCIDE

**************************************************************************
*								         *
* 	 ADINBOX							 *
* 									 *
* 	 THIS PUTS A BOX AROUND THE ADJUSTMENT INSTRUCTIONS.		 *
*								         *
**************************************************************************
INBOX_HEIGHT	EQU	72H     ; 

ADINBOX
	MMTM	SP,A10
	MOVI	CUR_ULY,A10	;PLOT TO SQUARE UP WITH "CURRENT SETTING"
	SLL	16,A10
	MOVI	TIT_ULX,A4	;UPPER RIGHT X
	MOVY	A10,A4		;UPPER RIGHT

	MOVI	AM_RX,A5
	MOVY	A10,A5		;START WITH BASE Y
	ADDI	INBOX_HEIGHT*10000H,A5

	CALLR	WH_BORD
	MMFM	SP,A10
	RETS

**************************************************************************
*								         *
* 	 ADJUSTING							 *
* 									 *
* 	 THIS IS CALLED WHEN WE ENTER THE "ADJUSTING" PHASE		 *
* 	 IT PUTS A BOX IN THE LEFT AREA TO SAY WHAT WE ARE ADJUSTING.	 *
*								         *
**************************************************************************
ADJUSTING
	MOVE	A8,A2			;PUT ADJUSTMENT BLOCK PTR WHERE ITS SAFE
	MOVI	(CUR_ULY-30H)*10000H,A4	;FOR DO_BORDER
	ADDI	TIT_ULX,A4		;A4 IS REASONABLY EASY

	MOVI	(CUR_ULY+MB_YWID)*10000H,A5	;OVERLAP THE ONE BELOW IT
	ADDI	AM_RX,A5		;THIS IS RIGHT EDGE

	CALLR	WH_BORD			;DO A WHITE BORDER

	MOVI	MES_ADNAME,A8		;PUT THE ADJUSTMENT NAME UP
	CALLA	LM_SETUP
	MOVE	*A2(AD_MAIN),A8,L	;GET THE MAIN MENU MESSAGE
	JSRP	PRINTF

	MOVI	MES_ADJUSTING,A8
	JSRP	L_MESS
	RETP

MULT_VAL
	clr	a4
	movk	7,a1			  ;setup a box for a bunch of lines
	callr	MADJ_BOX

	movi	M_MULTVAL,a8
	movi	COLOR_DECAY,a11
	JSRP	PRINT_SMALL_LINE	;header for coin slot value

	movi	COLOR_WHITE,a11		;don't glow inside box if that's the mode
	addk	14,a10

	MOVI    M_NO,A2		  ;ASSUME "NO"
	CALLA	READ_DIP
	ANDI	DPCOUNTER,A0      ; IF TWO COIN COUNTERS, SAY NO
	JRNZ	SAY_NO
	movi	ADJTOTALIZER,a0
	CALLA   GET_ADJ		  ;GET THE FREE PLAY ADJUSTMENT
	JRZ     SAY_NO
	MOVI    M_YES,A2
SAY_NO:
        movi	M_TOTMESS,a8
	JSRP	SMALL_LEFT_RIGHT

	addk	11,a10
	movi	M_MULTVAL1,a8
	movi	ADJLTOTMULT,a0
	JSRP	ADJ_LEFT_RIGHT

	addk	11,a10
	movi	M_MULTVAL2,a8
	movi	ADJRTOTMULT,a0
	JSRP	ADJ_LEFT_RIGHT

	addk	11,a10
	movi	M_MULTVAL3,a8
	movi	ADJCTOTMULT,a0
	JSRP	ADJ_LEFT_RIGHT

	addk	11,a10
	movi	M_MULTVAL4,a8
	movi	ADJXTOTMULT,a0
	JSRP	ADJ_LEFT_RIGHT

	addk	11,a10
	movi	M_MULTVAL5,a8
	movi	ADJBTOTMULT,a0
	JSRP	ADJ_LEFT_RIGHT

	retp

**************************************************************************
*								         *
* 	 PARAM_VAL							 *
* 									 *
* 	 This is called to summarize the values of the			 *
* 	 important adjustments on the parameter page.			 *
*								         *
**************************************************************************

*
*	WE WILL PRING OUT 3 LINES IN A BOX.
*
*	1) Pricing:
*	2) Free Play:   yes/no
*	3) Maximum Credits:
*

;PDY      EQU     HELP_DY+(HELP_DY/2)
PDY      EQU     12
PMARG    EQU     17

PARAM_VAL
	MOVI    4,A1		     ;Setup a box for our 3 lines
	MOVK	5,A4
	CALLR   PADJ_BOX		  ;(a10 is set as y for the 3 lines)

	SUBI	3,A10			; MOVE THAT LITTLE PUPPY AROUND

	CALLR   GET_COIN_TITLE	   ;COIN MODE
	MOVI    MESS_GP,A8
	JSRP    SMALL_LEFT_RIGHT	 ;PRINT THE LINES

	ADDI    PDY,A10	      ;PUSH TO NEXT LINE

	MOVI    M_NO,A2		  ;ASSUME "NO"
	MOVI    ADJFREPL,A0
	CALLA   GET_ADJ		  ;GET THE FREE PLAY ADJUSTMENT
	JRZ     NOT_FREE
	MOVI    M_YES,A2

NOT_FREE MOVI    MESS_FP,A8
	JSRP    SMALL_LEFT_RIGHT	 ;PRINT THE LINES

	ADDI    PDY,A10	      ;PUSH TO NEXT LINE

	MOVI    ADJMAXC,A0
	MOVI    MESS_MAX,A8
	JSRP    ADJ_LEFT_RIGHT       ;A0 = ADJUST  A8 = MESSAGE
*
*	CREDITS TO START AND CONTINUE NEEDS TO HANDLE PLURAL ETC.
*
	ADDI    PDY,A10	      ;PUSH TO NEXT LINE
	MOVI    ADJCSTRT,A0	 ;GET CREDITS REQUIRED TO START
	MOVI    M_CTS_PL,A8
	JSRP    ADJ_LEFT_RIGHT       ;A0 = ADJUST  A8 = MESSAGE
*
*	NOW THE CREDITS TO CONTINUE
*
	ADDI    PDY,A10	      ;PUSH TO NEXT LINE
	MOVI    ADJCCONT,A0	 ;GET CREDITS REQUIRED TO CONTINU
	MOVI    M_CTC_PL,A8
	JSRP    ADJ_LEFT_RIGHT       ;A0 = ADJUST  A8 = MESSAGE

	RETP

**************************************************************************
*								         *
* 	 ADJ_LEFT_RIGHT							 *
* 									 *
* 	 A8 HAS MESSAGE							 *
* 	 A0 HAS ADJUSTMENT						 *
* 	 A10 HAS HEIGHT.						 *
* 									 *
* 	 LEFT JUSTIFY A8 MESSAGE					 *
* 	 RIGHT JUSTIFY A0 ADJUSTMENT (AFTER READING IT)			 *
*								         *
**************************************************************************
ADJ_LEFT_RIGHT
	MOVE    A8,A3		;STASH MESSAGE

	CALLA   GET_ADJ
	MOVE    A0,A8
	CALLA   HEXTOASC	    ;A8 POINTS TO NUMBER STRING

	MOVE    A8,A2
	MOVE    A3,A8		;GET MESSAGE IN A8

	JRUC    SMALL_LEFT_RIGHT

**************************************************************************
*								         *
* 	 SMALL_LEFT_RIGHT						 *
* 									 *
* 	 THIS IS CALLED TO PRINT A LEFT AND RIGHT JUSTIFIED		 *
* 	 PAIR OF STRINGS IN THE "CURRENT SETTING BOX"			 *
* 									 *
* 	 A2 = RIGHT JUSTIFIED STRING					 *
* 	 A8 = LEFT JUSTIFIED STRING TO PRINT				 *
* 	 A10 = Y VALUE							 *
*								         *
**************************************************************************
SMALL_LEFT_RIGHT
	MMTM	A12,A11,A6,A10,A9,A3

	MOVI	COLOR_PWHITE,A5
	MOVI	RD7FONT,A11		;USE BABY FONT

	MOVI	AM_HX+PMARG,A9		;LEFT X IS INSIDE LEFT LINE

	MOVE	A10,A3			;SAVE Y IN A3
	SLL	16,A3
	MOVY	A3,A9			;POINTER SET!

	MOVI	SPACING07,A10

	CLR	A0
	CALLA	STRINGF
	JSRP	STRLNRM			;DO IT!

	MOVE	A2,A8			;GET RIGHT JUSTIFIED STRING
	MOVI	TIT_LRX-PMARG,A9	;INSIDE RIGHT MARGIN
	MOVY	A3,A9			;AT OUR Y
	CALLA	STRINGF
	JSRP	STRRNRM			;PRINT IT!

	MMFM	A12,A11,A6,A10,A9,A3
	RETP

**************************************************************************
*								         *
* 	 COIN_SET							 *
* 									 *
* 	 THIS IS THE ROUTINE THAT IS CALLED TO DISPLAY THE CURRENT	 *
* 	 COINAGE SETTINGS.						 *
* 									 *
* 	 A8 HAS POINTER TO ADJUSTMENT BLOCK				 *
* 	 A11 HAS THE COLOR TO USE					 *
*								         *
**************************************************************************
COIN_SET
        move    a11,@justlooking
	CALLR	TAMPEREDP	;HAS THE 1ST 6 COIN VALUE BEEN TAMPERED WITH?
	JRZ	SBO		;YEP....SMALL BOX ONLY!

	CALLR	CLR_CUR
	MOVI	6,A1		;BIG BOX FOR OUTSIDE
	MOVK	5,A4		;GROSS KLUDGE TO OFFSET BOX
	CALLR	CADJ_BOX
SBO
	MOVI	1,A1		;DRAW A BOX TO HOLD 1 LINE
	CLR	A4
	CALLR	CADJ_BOX	;DRAW THE BOX....PASS BACK 1ST PLOT LINE

	MOVI	[ADJ_CULY+5,AM_HX+4],A3
	MOVI	[21,179],A4
	CALLA	BLNKAREA
	MOVI	[ADJ_CULY+31,AM_HX+4],A3
	MOVI	[61,179],A4            
	CALLA	BLNKAREA

*
*	THE ABOVE 2 CALLS SHOULD CREATE A BOX LIKE:
*
*
*		   ษอออออออออออออออออออป
*		   บ  CURRENT SETTING  บ
*		   ศอออออออออออออออออออผ
*		   ษอออออออออออออออออออป
*		   บ     U.S.A. 1      บ
*		   บอออออออออออออออออออน
*		   บ 1 COIN / 1 CREDIT บ
*		   บ		       บ
*		   บ		       บ
*		   บ 25c   $1.00   25c บ
*		   ศอออออออออออออออออออผ
*
*		F10 HAS THE PLACE TO PLOT THE TITLE LINE.
*
	MOVE    A10,A4	      ;KEEP THE Y HANDY.
*
	CALLR   GET_COIN_TITLE       ;GET TITLE FOR BIG BOX IN A2.
*
*	A2 HAS STRING
*	A11 IS COLOR
*	A10 IS Y TO PRINT
*
COIN_TIT
;	ADDI    2,A10		    ;CENTER THE LARGE TEXT
;	INC	A10
	subk	5,a10
	JSRP    DO_BIG_LINE	      ;PRINT THIS LINE!

	MOVI    COLOR_WHITE,A11      ;DON'T GLOW INSIDE BOX IF THAT'S THE MODE
;	CALLR	CKDIP
;	JRZ	NO_INFO

	CALLR   TAMPEREDP	;HAS THE 1ST 6 COIN VALUE BEEN TAMPERED WITH?
	JRZ     NO_INFO	        ;YEP....JUST GIVE THE STARTS AND CONTINUES

	CALLA   GET_CSPT	   ;A6 POINTS AT THE CSELECT BLOCK

        move    @justlooking,a14
        cmpi    COLOR_LF,a14            ; a14 = COLOR_LF if just looking
        jreq    dont_reset
	CALLR	SET_COIN_ADJ	        ; SETUP THE COIN ADJUSTMENTS
dont_reset:

	MOVE    *A6(CS_LIST),A2,L       ;FETCH POINTER TO MESSAGE LIST
	JRZ     NO_HEADERS	        ;NO LIST!

	MOVI    COIN_HEAD_Y,A10      ;AT THIS HEIGHT

NEXT_HEADER
	MOVE    *A2+,A8,L
	JRZ     NO_HEADERS	  ;HEADERS ARE OUT...CONTINUE

	JSRP    PRINT_SMALL_LINE     ;PRINT THE LINE
	ADDK    11,A10	      ;PUSH TO NEXT LINE
	JRUC    NEXT_HEADER

NO_HEADERS
*
*       PRINT COLUMN HEADINGS     S1   S2    S3    S4    BILL
*
        movi    "1S",a3
        move    a3,@ramtemp1,L
	MOVI    MESS_CTS,A10	;SET Y FOR COIN SLOT LINE.

        movk    4,a5
        movi    AM_HX+20,a9
PSL_LP2:
        movi    ramtemp1,a8
	JSRP    PRINT_SM_XO_LINE      ;PRINT THE COLUMN HEADING
        addi    100h,a3
        move    a3,@ramtemp1,L
        addi    36,a9
        dsjs    a5,PSL_LP2

        movi    M_SLOTVAL,a8
        JSRP    PRINT_SM_XO_LINE        ; "BILL"

	ADDK    11,A10	      ; PUSH Y UP FOR A GAP	    *

	CALLA   GET_CSPT	    ;A6 POINTS AT THE CSELECT BLOCK
	MOVE    *A6(CS_SLOTS),A3,L   ;PRINT COIN SLOT INFO
        movk    5,a5
        movi    AM_HX+20,a9
PSL_LP:
        move    *a3+,a8,L
        jrz     skip_PSL
	JSRP    PRINT_SM_XO_LINE      ;PRINT THE LINE
skip_PSL:
        addi    36,a9
        dsjs    a5,PSL_LP
                

	movi	ADJCSTRT,a0		; credits to start
	calla	GET_ADJ	
	move	a0,@ramtemp1,L
*print the credits required to continue
	movi	ADJCCONT,a0		; credits to continue
	calla	GET_ADJ	
	move	a0,@ramtemp2,L
	movi	TOSTOC_MESS,a8
	JSRP	LM_PRINTF
NO_INFO
	RETP			;DONE FOR NOW

TOSTOC_MESS
       MESS_MAC  RD7FONT,SPACING07,AM_HX+90,ADJ_CULY+17,COLOR_PWHITE,STRCNRM,0
	.string	"%d TO START. %d TO CONTINUE.",0
	.long	ramtemp1
	.long	ramtemp2


ERASE_CUR
	MOVI	(CUR_ULY2*10000H),A4
	MOVE	*A13(ADS_LX),A9,W		;GET LEFT X
	MOVX	A9,A4				;SET IT FOR THIS BOX.
	MOVI	CUR_LRX+(CUR_LRY2*10000H),A5
	MOVI	COLOR_BLACK,A9
	CALLA	STD_BORD			;ADJUSTMENT BORDER IS UP.

	MOVI	MESS_CURSET,A8			;PUT UP THE CURRENT MESSAGE TEXT
	CALLA	LM_SETUP
	MOVI	COLOR_PBLACK,A5

	MOVE	*A13(ADS_CX),A2,W		;GET CENTER X
	MOVX	A2,A9				;PUT CENTER X IN
	JSRP	PRINTF
	RETS


**************************************************************************
*								         *
* 	 GET_COIN_TITLE							 *
* 									 *
* 	 THIS IS CALLED TO FETCH THE CHARACTER STRING MESSAGE		 *
* 	 FOR THE CURRENT COIN MODE.  IF ITS STANDARD, THEN		 *
* 	 IT IS FETCHED BASED ON THE COIN SELECT TABLE.			 *
* 									 *
* 	 IF THE 1ST 6 PARAMETERS HAVE BEEN MODIFIED, THEN		 *
* 	 IT RETURNS THE STRING "NON-STANDARD".				 *
*								         *
**************************************************************************
GET_COIN_TITLE
	MMTM    SP,A6		;PRESERVE FOR COIN SELECT TABLE

	CALLA   GET_CSPT	    ;A6 POINTS AT THE CSELECT BLOCK
	MOVI	MESS_DIP,A2
	CALLR	CKDIP
	JRZ	GCTX

	MOVI    MESS_TAMPERED,A2

	MOVI    ADJ1ST6,A0	  ;NON-STANADARD TITLE IF 1ST 6 MODIFIED
	CALLA   GET_ADJ	     ;WELL?
	JRZ     GCTX		;PUT OUT THE TITLE LINE AS TAMPERED!

	MOVE    *A6(CS_TITLE),A2,L   ;GET THE CSELECT TITLE FOR ITS VALUES

GCTX	MMFM    SP,A6		;PRESERVE FOR COIN SELECT TABLE
	RETS

**************************************************************************
*								         *
* 	 TAMPEREDP							 *
* 									 *
* 	 HAVE THE COIN PARAMETERS BEEN TAMPERED WITH.			 *
* 	 THIS RETURNS ZERO IF ANY OF THE 1ST 6 COIN			 *
* 	 PARAMETERS HAVE BEEN CUSTOM ADJUSTED.				 *
*								         *
**************************************************************************
TAMPEREDP
	MMTM	SP,A0
	MOVI	ADJ1ST6,A0	;JUST CHECK THE 1ST 6
	CALLA	GET_ADJ		;HAS IT BEEN TAMPERED WITH (0 MEANS YES)
	MMFM	SP,A0
	RETS

CKDIP
	CALLA	READ_DIP
	ANDI	DPUSECMOS,A0
	MOVE	A0,A0
	RETS

**************************************************************************
*								         *
* 	SET_COIN_ADJ							 *
* 									 *
* 	SET THE COIN ADJUSTMENT STUFF FROM WHATEVER IS POINTED TO BY	 *
* 	A6								 *
* 									 *
* 	ENTRY								 *
* 		A6	POINTER TO THE FIRST 6 ADJUSTMENTS ( SORT OF )	 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
SET_COIN_ADJ:
	MMTM	SP,A0,A1,A6,A7
	MOVI	ADJLMULT,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	MOVI	ADJCMULT,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	MOVI	ADJRMULT,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	MOVI	ADJ4MULT,A0		; NEW ADDITION, FOLKS!
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	movi	ADJDBVMULT,a0		; new addition, folks!
	move	*a6+,a1,W
	calla	PUT_ADJ
	MOVI	ADJCUNIT,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	MOVI	ADJBUNIT,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	MOVI	ADJMUNIT,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	movi	ADJCSTRT,a0
	move	*a6+,a1,W
	calla	PUT_ADJ
	movi	ADJCCONT,a0
	move	*a6+,a1,W
	calla	PUT_ADJ
	MOVI	ADJCDIV,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	MOVI	ADJFRAC,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ

	movi	ADJLTOTMULT,a0
	move	*a6+,a1,W
	calla	PUT_ADJ
	movi	ADJCTOTMULT,a0
	move	*a6+,a1,W
	calla	PUT_ADJ
	movi	ADJRTOTMULT,a0
	move	*a6+,a1,W
	calla	PUT_ADJ
	movi	ADJXTOTMULT,a0
	move	*a6+,a1,W
	calla	PUT_ADJ
	movi	ADJBTOTMULT,a0
	move	*a6+,a1,W
	calla	PUT_ADJ

	movi	ADJTOTALIZER,a0
        movk	1,a1
	calla	PUT_ADJ

	CALLA   F_ADC_S			;MAKE CHECKSUM VALID!

	MMFM	SP,A0,A1,A6,A7
	RETS

**************************************************************************
*								         *
* 	 PRINT_SMALL_LINE						 *
* 									 *
* 	 THIS IS CALLED TO PRINT A LINE IN THE "CURRENT SETTING"	 *
* 	 BOX FOR THE COINAGE.						 *
* 									 *
* 	 A8 = STRING TO PRINT						 *
* 	 A11 = COLOR							 *
* 	 A10 = Y VALUE							 *
* 									 *
* 	 PRINT IN THE 7 POINT FONT WITH X CENTERED FOR THE		 *
* 	 HELP SYSTEM.							 *
*								         *
**************************************************************************
PRINT_SM_XO_LINE                ; Small Centered line w/X in a9
	MMTM    A12,A11,A6,A10,A9,A5,a3

	MOVE	A11,A5
	SLL	16,A5			; FIX IT UP SOME MORE
	MOVI    RD7FONT,A11	 ;USE BABY FONT

	MOVE    A10,A0
	SLL     16,A0
	MOVY    A0,A9		;POINTER SET!

	MOVI    SPACING07,A10

	CLR     A0

	CALLA	STRINGF
	JSRP    STRCNRM	     ;DO IT!

	MMFM    A12,A11,A6,A10,A9,A5,a3
	RETP

PRINT_SMALL_LINE
	MMTM    A12,A11,A6,A10,A9

;	MOVE    A11,A6	      ;COLOR SET
	MOVE	A11,A5
	SLL	16,A5			; FIX IT UP SOME MORE
	MOVI    RD7FONT,A11	 ;USE BABY FONT

	MOVI    AM_HX,A9,W	  ;GET LEFT X
	CALLR   LEFT_TO_CENTER       ;CONVERT IT

	MOVE    A10,A0
	SLL     16,A0
	MOVY    A0,A9		;POINTER SET!

	MOVI    SPACING07,A10

	CLR     A0

	CALLA	STRINGF
	JSRP    STRCNRM	     ;DO IT!

	MMFM    A12,A11,A6,A10,A9
	RETP

*
*	DO_ADJH
*
*	THIS IS CALLED TO PLOT THE RIGHT HALF OF THE SCREEN
*	FOR EACH ADJUSTMENT AS THE USER SELECTS THEM ON
*	THE ADJUSTMENT MENU.
*
*	THE FORMAT IS AS FOLLOWS:
*
*    ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
*    บ		       A D J U S T M E N T    M E N U			 บ
*    บ		        HOCKEY - REVISION  x.xx 			 บ
*    ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*    ษอออออออออออออออออออออออออออออป  ษออออออออออออออออออออออออออออออออออป
*    บ   SELECT BLAH BLAH BLAH     บ  บ	 GAME DIFFICULTY		 บ
*    ศอออออออออออออออออออออออออออออผ  ศออออออออออออออออออออออออออออออออออผ
*    ษอออออออออออออออออออออออออออออป  ษออออออออออออออออออออออออออออออออออป
*    บ	  RETURN TO MAIN MENU  	   บ  บ  THIS CONTROLS THE OVERALL       บ
*    บ	    STANDARD PRICING	   บ  บ  DIFFICULTY OF GAME PLAY.	 บ
*    บ	     CUSTOM PRICING        บ  บ					 บ
*    บ         FREE PLAY	   บ  บ  RANGE OF SETTINGS:  1-9	 บ
*    บ======GAME DIFFICULTY========บ  บ					 บ
*    บ      ENERGY PER PLAY        บ  บ  EASIEST SETTING: 1		 บ
*    บ      BOMBS PER PLAY	   บ  บ  HARDEST SETTING: 9	     	 บ
*    บ     MIN. TIME PER PLAY  	   บ  บ  FACTORY SETTING: 5	     	 บ
*    บ     ATTRACT-MODE SOUND	   บ  ศออออออออออออออออออออออออออออออออออผ
*    บ    AUTO HIGH SCORE RESET	   บ  ษออออออออออออออออออออออออออออออออออป
*    บ      HIGH SCORE ENTRY       บ  บ	CURRENT SETTING			 บ
*    บ	  RETURN TO MAIN MENU  	   บ  ศออออออออออออออออออออออออออออออออออผ
*    ศอออออออออออออออออออออออออออออผ  ษออออออออออออออออออออออออออออออออออป
*    			   	      บ					 บ
*    			   	      บ	 9 - EXTRA HARD			 บ
*    			   	      บ					 บ
*    				      ศออออออออออออออออออออออออออออออออออผ
*
*
*	ON ENTRY....A1 POINTS AT THE 3 WORDS FOR CURRENT
*	MENU ENTRY.
*
DO_ADJH
*
*	FIRST WE BLANK OUT THE AREA...WE NEED TO DO THIS FROM
*	THE MENU PROCESS SINCE THE RIGHT EDGE IS DETERMINED BY
*	MENU PDATA STUFF.  IT WILL RETURN IN A9 THE MARGIN WE
*	SHOULD WORK FROM.
*
	CALLA   BLNKHELP	    ;BLANK OUT THE AREA WE'RE PLOTTING!
	MOVE    A1,A8		;PASS THE STRUCTURE POINTER TO NEW PROCESS!
;	MOVI    AD_SLAVE,A7
;	CALLA   P_FORK	      ;THIS CREATES IT!
	P_FORK	AD_SLAVE
	RETS			;NOW RETURN TO MENU HANDLER!

**************************************************************************
*								         *
* 	 AD_SLAVE							 *
* 									 *
* 	 THIS IS FORKED TO PLOT THE RIGHT SIDE...IT HAS			 *
* 	 ITS OWN PDATA AREA FOR INFO STORAGE.				 *
* 									 *
* 	 A8 = POINTER TO THE MENU SELECTION 3 LONG-WORD ENTRY		 *
* 	 A9 = LEFT X MARGIN FOR OUR WORK.				 *
*								         *
**************************************************************************
ADS_STRUCT EQU	PDATA			;LONG-POINTER TO ADJUSTMENT STRUCTURE
ADS_LX	EQU	ADS_STRUCT+LONG_SIZE	;WORD-LEFT X TO WORK FROM
ADS_CX	EQU	ADS_LX+WORD_SIZE	;WORD-CENTER X FOR WORK

AD_SLAVE
	MOVE	*A8(MENU_ROUTINE),A11,L	;NOW WE HAVE OUR SPECIAL STRUCTURE!
	MOVE	A11,*A13(ADS_STRUCT),L	;STASH IT...WE'LL NEED IT
	MOVE	A9,*A13(ADS_LX),W	;ALSO THE X.....

	MOVE	A9,A4			;COPY LEFT FOR BORDER ROUT
	CALLR	LEFT_TO_CENTER

	MOVE	A9,*A13(ADS_CX),W	;STASH THE CENTER
*
*	A4 = UPPER LEFT Y,X
*	A5 = LOWER RIGHT Y,X
*	A0 = Y,X WIDTH OF BORDER
*	A9 = COLOR OF BORDER.
*
	ADDI	INST_ULY*10000H,A4	;ADD IN THE Y
	MOVI	(INST_LRY*10000H)+TIT_LRX,A5	;THIS IS OTHER EDGE.
	MOVI	COLOR_PURPLE,A9

	CMPI	DO_PARAM,A11		;REALLY DISGUSTING WAY TO RESET
	JRNZ	ADS1			;WHITE COLOR ON RETURN FROM CUSTOM
	MOVI	COLOR_WHITE,A9
	MOVE	A9,@LASTCOLOR,W
ADS1
	MOVE	@LASTCOLOR,A9,W
	CALLA	STD_BORD		;ADJUSTMENT BORDER IS UP.
*
	MOVI	ADJT_SETUP,A8
	CALLA	LM_SETUP		;SETUP TO PRINT TITLE

	MOVE	*A13(ADS_CX),A2,W	;GET THE X
	MOVX	A2,A9			;SUBSTITUTE OUR X IN.

	MOVE	*A13(ADS_STRUCT),A2,L	;GET STRUCTURE POINTER
	MOVE	*A2(AD_TITLE),A8,L	;GET MESSAGE POINTER

	JSRP	PRINTF			;BOX AND TITLE ARE UP.
;
;	HERE IS A REALLY NEAT PLACE TO SCREW WITH THE HELP STRUCTURE FOR
;	DIPSWITCH SETTING HELP -- GROSS, HUH?
;
	MOVE	*A2(AD_HELP),A8,L	;GET THE HELP STRUCTURE
	CALLR	CKDIP
	JRNZ	ADSSKIP
	CMPI	HELP_MULT,A8		;PRICING HELP
	JRZ	ADSDIP
	CMPI	HELP_PRICE,A8		;PRICING HELP
	JRZ	ADSDIP
	CMPI	HELP_PARAM,A8		;PARAMETER HELP
	JRZ	ADSDIP
	CMPI	HELP_FREE,A8		;FREEPLAY HELP
	JRNZ	ADSSKIP
ADSDIP
	MOVI	HELP_DIP,A8
ADSSKIP
	MOVE	*A13(ADS_LX),A9,W	;LEFT X FOR HELP BOX
	MOVI	INST_LRY+BOX_YGAP,A10	;THIS IS HELP BOX POSITION
	ADDI	10000H,A10		;FLAG THAT THIS IS TOP..NOT CENTER!

;	MOVI	H_SLAVE,A7		;FORK OFF SO IT CAN USE PDATA!
;	CALLA	P_FORK			;START UP ANOTHER W/ SAME ID
	P_FORK	H_SLAVE
*
*	NOW WE NEED TO SHOW THE CURRENT SETTING ON THE LOWER HALF OF
*	THE SCREEN.
*
*	LETS BUILD THE "CURRENT SETTING" TITLE BOX FIRST.
*
;
;	PLOTS BOX 3 OF THINGS ON THE RIGHT HAND SIDE
;
	MOVE	*A13(ADS_STRUCT),A4,L
	CMPI	DO_PRICE,A4
	JRZ	SKIPCURRENT
	CMPI	DO_PARAM,A4
	JRZ	SKIPCURRENT

	cmpi	DO_MULT,a4
	jrz	SKIPCURRENT

	MOVE	*A4(AD_NAMEIT),A4,L	;Does this line have an adjustment?
	JRZ	SKIPCURRENT		;BR = No, so don't print current adj.

	MOVI	((CUR_ULY2+5)*10000H),A4
	MOVE	*A13(ADS_LX),A9,W	;GET LEFT X
	MOVX	A9,A4			;SET IT FOR THIS BOX.
	MOVI	CUR_LRX+(CUR_LRY2*10000H),A5
	MOVE	@LASTCOLOR,A9,W
	CALLA	STD_BORD		;ADJUSTMENT BORDER IS UP.

	MOVI	MESS_CURSET,A8		;PUT UP THE CURRENT MESSAGE TEXT
	CALLA	LM_SETUP

	MOVE	*A13(ADS_CX),A2,W	;GET CENTER X
	MOVX	A2,A9			;PUT CENTER X IN
	JSRP	PRINTF
SKIPCURRENT
	MOVE	*A13(ADS_STRUCT),A8,L	;GET THE ADJUSTMENT STRUCTURE
	MOVI	COLOR_LF,A11		;INDICATE STANDARD COLOR.
	JSRP	AD_CRVAL		;PRINT SCREEN SHOWING THE CURRENT VALUE

	JAUC	SUCIDE			;OUR JOB IS DONE!...EXIT

**************************************************************************
*								         *
* 	 LEFT_TO_CENTER							 *
* 									 *
* 	 THIS IS CALLED TO FIND THE CENTER POINT FOR A BOX BASED ON	 *
* 	 THE LEFT PASSED IN A9.  CENTER X RETURNED IN A9.		 *
*								         *
**************************************************************************
LEFT_TO_CENTER
	ADDI    TIT_LRX,A9		;FIND BOX CENTER
	SRL     1,A9		     ;NOW WE HAVE THE CENTER
	ADDI    C_KLUDGE,A9	      ;MAKE IT CENTER CORRECTLY
	RETS

**************************************************************************
*								         *
* 	 AD_CRVAL							 *
* 									 *
* 	 THIS IS CALLED TO PRINT THE CURRENT VALUE FOR ANY		 *
* 	 ADJUSTMENT.  THE VALUE SHOULD BE PRINTED AND BOXED		 *
* 	 IN THE LOWER RIGHT REGION UNDER THE "CURRENT SETTING"		 *
* 	 HEADER.							 *
* 									 *
* 	 A8 -> ADJUSTMENT STRUCTURE					 *
* 	 A11  -> COLOR TO USE						 *
* 	 ADJ_LEFX (GLOBAL RAM) CONTAINS LEFT MARGIN FOR THIS.		 *
*								         *
**************************************************************************
AD_CRVAL
	MOVE	*A8(AD_NAMEIT),A0,L	;FETCH THE "NAME-IT" ROUTINE
	JRNZ	ADCR_JUMP
	RETP				;WE DON'T HAVE ANYTHING TO PRINT
ADCR_JUMP
	JUMP	A0			;AND "JSRP" THAT ROUTINE

**************************************************************************
*								         *
* 	 HEX_OR_MESS							 *
* 									 *
* 	 THIS IS CALLED FOR THE EXTRA MAN EVERY...AND			 *
* 	 "LAST EXTRA MAN" ADJUSTMENTS.  IT PRINTS OUT			 *
* 	 THE HEX ADJUSTMENT WITH COMMAS, OR PRINTS			 *
* 	 THE MESSAGE STORED AT A8(AD_NAMPTR) ON ITS LOWEST VALUE.	 *
* 									 *
* 	 ****** NOTE THAT "BIN_OR_MESS" (BELOW) USES PARTS OF THIS!	 *
*								         *
**************************************************************************
HEX_OR_MESS
	MMTM	SP,A8			;PRESERVE A8 PLEASE

	CALLR	ADJ_STUFF		;GET THE REGGIES FIXED UP.
*
*	NOW A0 HAS THE ADJUSTMENT....FORM THE C-STRING
*
	MOVE	*A8(AD_MIN),A1,L	;GET MINIMUM VALUE
	CMP	A0,A1			;ARE WE AT MINIMUM?
	JRNZ	NOT_MIN			;NOPE
AT_MIN
	MOVE	*A8(AD_NAMPTR),A8,L	;GET THE MESSAGE POINTER
	JRUC	PRT_MIN
NOT_MIN
	MOVE	A0,A8
	MOVK	1,A3			;INDICATE COMMAS ARE DESIRED
	CALLA	HTOHXASC		;CONVERT A8 TO THIS NUMBER
PRT_MIN
	MOVE	A8,A2
	MMFM	SP,A8			;PRESERVE A8 PLEASE

	SUBI	4,A10
	JSRP	DO_BIG_LINE		;NOW PRINT IT OUT
	RETP				;AND RETURN

**************************************************************************
*								         *
* 	 BIN_OR_MESS							 *
* 									 *
* 	 THIS IS CALLED TO PRINT A BINARY NUMBER OR			 *
* 	 A MESSAGE AT A8(AD_NAMPTR) IF IT IS AT MINIMUM.		 *
*								         *
**************************************************************************
BIN_OR_MESS
	MMTM    SP,A8		    ;PRESERVE A8 PLEASE

	CALLR   ADJ_STUFF		;GET THE REGGIES FIXED UP.
*
*	NOW A0 HAS THE ADJUSTMENT....FORM THE C-STRING
*
	MOVE    *A8(AD_MIN),A1,L	 ;GET MINIMUM VALUE
	CMP     A0,A1		    ;ARE WE AT MINIMUM?
	JRZ     AT_MIN		   ;YEP.....PRINT "OFF"

	CALLA   BINBCD		   ;TURN TO BCD PLEASE
	JRUC    NOT_MIN		  ;AND NOW PRINT WITH COMMAS.

**************************************************************************
*								         *
* 	 JUST_BIN							 *
* 									 *
* 	 THIS IS CALLED TO PRINT OUT THE ADJUSTMENT			 *
* 	 (STORED IN BINARAY) IN DECIMAL.				 *
*								         *
**************************************************************************
JUST_BIN
	MMTM    SP,A8		    ;PRESERVE A8 PLEASE

	CALLR   ADJ_STUFF		;GET THE REGGIES FIXED UP.
*
*	NOW A0 HAS THE ADJUSTMENT....FORM THE C-STRING
*
	CALLA   BINBCD		   ;TURN IT TO BCD!
	JRUC    NOT_MIN

**************************************************************************
*								         *
* 	 LIST_1LINE							 *
* 									 *
* 	 THIS IS CALLED TO DO A 1 LINE LISTING OF MESSAGES		 *
* 	 ASSOCAITED WITH THE CURRENT ADJUSTMENT.			 *
* 	 A8 = STRUCTURE							 *
* 	 A11 = COLOR OF TEXT INSIDE BOX.				 *
*								         *
**************************************************************************
LIST_1LINE
	CALLR   ADJ_STUFF		;GET THE REGGIES FIXED UP.

	MOVE    *A8(AD_MAX),A1,L	 ;IS IT TOO HIGH?
	CMP     A1,A0		    ;COMPARE TO ADJUSTMENT
	JRLS    L1L1		     ;IN RANGE.....
*
*	ADJUSTMENT IS TOO HIGH...DON'T GO THROUGH TABLE!
*
	MOVI    M_NULL,A2		;USE NULL POINTER
	JRUC    L1L2

L1L1     MOVE    *A8(AD_MIN),A1,L	 ;GET THE LOWEST VALUE
	SUB     A1,A0		    ;THIS IS OFFSET
	MOVI    LONG_SIZE,A1	     ;THIS MANY LONG WORDS
	MPYU    A0,A1		    ;THIS IS OFFSET INTO TABLE
	MOVE    *A8(AD_NAMPTR),A0,L       ;THIS IS TABLE BASE
;
;	THIS IS REALLY GROSS HERE, BUT IT IS EASIER THAN DOING IT RIGHT
;
	CMPI	DO_FREE,A8		; IS IT A FREEPLAY ITEM
	JRNZ	LIGO
	PUSH	A0
	CALLA	CKDIP			; CHECK FOR DIP SWITCH SETTING
	PULL	A0
	JRNZ	LIGO
	MOVI	LIST_DIPNOYES,A0
LIGO

	CMPI	DO_TOTALIZER,A8		; IS IT TOTALIZER ON/OFF?
	JRNZ	LIGO2
	PUSH	A0
	CALLA	READ_DIP
	ANDI	DPCOUNTER,A0            ; IF TWO COIN COUNTERS, THIS IS
	PULL	A0                      ; ALWAYS "NO"
	JRZ	LIGO2
	MOVI	LIST_DIPNONO,A0
LIGO2


	ADD     A1,A0		    ;A0 HAS THE TEXT OF THE SINGLE LINE
	MOVE    *A0,A2,L		 ;GET THE VECTOR



	CALLA	READ_DIP
	ANDI	DPUSECMOS,A0
	MOVE	A0,A0


*
*	TEXT POINTER IN A2
*	COLOR IN A11
*	Y IN A10
*
L1L2
	SUBI	4,A10		; AUTOPOSITION THE SINGLE LINE
	JSRP    DO_BIG_LINE	      ;PRINT OUT THIS LINE
	RETP			     ;NOW RETURN

**************************************************************************
*								         *
* 	 ADJ_STUFF							 *
* 									 *
* 	 THIS IS CALLED BY THE ROUTINES THAT DISPLAY			 *
* 	 ADJUSTMENTS.  IT PLOTS THE BOX AND RETURNS:			 *
* 									 *
* 		 A10 = HEIGHT FOR 15 POINT SINGLE TEXT LINE		 *
* 		 A0 =  ADJUSTMENT WITH ZERO SUBSTITUTION COMPLETED.	 *
*								         *
**************************************************************************
ADJ_STUFF
	MOVI	2,A1		;INDICATE 2 PUNY LINES (FOR OUR BIG ONE)
	CALLR	ADJ_BOX		;DRAW THE BOX....PASS BACK 1ST PLOT LINE
*
*	A10 HAS Y HEIGHT OF 1ST ENTRY.
*
	ADDI	2,A10		;CENTER THE LARGE TEXT
*
	MOVE	*A8(AD_CMOS),A0,W	;GET ADJUSTMENT NUMBER
	CALLR	GET_EADJ	;FETCH THE CURRENT VALUE.

	CALLR	PUT_IN_RANGE	;IF ITS OUT OF RANGE, FIX IT!
	RETS

**************************************************************************
*								         *
* 	 DO_BIG_LINE							 *
* 									 *
* 	 THIS IS CALLED TO DO A SINGLE LINE FOR AN ADJUSTMENT		 *
* 	 "CURRENT ADJUSTMENT" BOX.					 *
* 									 *
* 	 A2 = POINTER TO TEXT						 *
* 	 A10 = Y COORDINATE						 *
* 	 A11 = COLOR							 *
* 									 *
* 	 X LEFT COORDINATE IS IN GLOBAL "ADJ_LEFX"			 *
*								         *
**************************************************************************
DO_BIG_LINE
	MMTM    A12,A10,A11,A8       ;SAVE STUFF FOR CALLER
;	MOVE    A11,A6
	MOVE	A11,A5
	SLL	16,A5
	MOVI    AM_HX,A9,W	  ;GET LEFT X
	CALLR   LEFT_TO_CENTER       ;CONVERT IT
	SLL     16,A10	      ;SHIFT Y DOWN
	MOVY    A10,A9	      ;X,Y SET
	MOVE    A2,A8		;TEXT POINTER
	CLR     A0		  ;NO SLEEP
	MOVI	SPACING07,A10
	MOVI	RD7FONT,A11
	CALLA	STRINGF
	JSRP    STRCNRM	     ;DO IT!
	MMFM    A12,A10,A11,A8       ;POP THE STUFF.
	RETP

**************************************************************************
*								         *
* 	 GET_EADJ							 *
* 									 *
* 	 THIS IS LIKE GET_ADJ, HOWEVER IF ZERO COMES OUT,		 *
* 	 WE CHECK TO SEE IF THERE IS A LOGICAL NUMBER TO		 *
* 	 PASS OUT IN PLACE OF THE ZERO.					 *
* 									 *
* 	 A8 POINTS AT THE ADJUSTMENT STRUCTURE.				 *
*								         *
**************************************************************************
GET_EADJ
	MMTM    SP,A1
	CALLA   GET_ADJ	     ;FETCH THE ADJUSTMENT
	JRNZ    GET_EA1	     ;ITS NOT ZERO....RETURN
*
*	ITS ZERO....SEE IF THERE'S A VALUE TO SUB
*
	MOVE    *A8(AD_ZEQU),A1,L    ;IS THERE A SUB VALUE?
	JRZ     GET_EA1	     ;NOPE...RETURN THE ZERO (AND FLAG)

	MOVE    A1,A0		;RETURN THE SUBSTITUTE VALUE
GET_EA1	MMFM    SP,A1
	RETS

**************************************************************************
*								         *
* 	 PUT_IN_RANGE							 *
* 									 *
* 	 THIS IS CALLED TO TAKE AN ADJUSTMENT AND MAKE SURE		 *
* 	 IT HAS A VALID VALUE.  IF ITS BETWEEN THE MIN AND MAX		 *
* 	 (INCLUSIVE) ALLOWED, THEN WE RETURN WITH NO ACTION.		 *
* 									 *
* 	 IF ITS OUTSIDE, THEN WE SET IT ACCORDING TO THE		 *
* 	 "WRAP_AROUND" PARAMETER.					 *
* 									 *
* 	 A0 HAS ADJUSTMENT VALUE					 *
* 	 A8 POINTS AT ADJUSTMENT STRUCTURE.				 *
* 									 *
* 	 RETURN NEW VALUE IN A0.					 *
*								         *
**************************************************************************
PUT_IN_RANGE
	MMTM    SP,A1,A2,A3
	MOVE    *A8(AD_MIN),A1,L	 ;GET MINIMUM
	MOVE    *A8(AD_MAX),A2,L	 ;GET MAXIMUM
	MOVE    *A8(AD_FLAGS),A3,W	;ARE WE WRAPPING AROUND
	BTST    WRAP_BIT,A3	      ;WELL?
	JRNZ    CK_WRAP		  ;YEP....USE A FANCY HANDLER.

	CMP     A1,A0		    ;ARE WE TOO LOW?
	JRHS    NOT_LO
*
*	ITS TOO LOW.....USE MINIMUM
*
USE_LO   MOVE    A1,A0

*
*	WE'RE NOT WRAPPING AROUNG....IF ITS MEGA-HIGH....KEEP IT
*	AT THE LOW BOUNDARY.
*
NOT_LO   CMPI    090000000H,A0
	JRHI    USE_LO		   ;USE THE LOW VALUE!

	CMP     A2,A0
	JRLS    PIRX

USE_HI   MOVE    A2,A0
	JRUC    PIRX
*
*	WE NEED TO WRAP FROM LOWEST TO HIGHEST
*
CK_WRAP
	CMPI    090000000H,A0	    ;IN THIS RANGE, WE MUST HAVE WRAPPED DOWN
	JRHI    USE_HI		   ;SO USE HIGH VALUE

	CMP     A1,A0		    ;IS IT LOWER THAN LO?
	JRLO    USE_HI		   ;IT IS ....USE THE HIGH ONE.

	CMP     A2,A0		    ;IS IT TOO HIGH?
	JRHI    USE_LO		   ;IT IS....USE THE LOW ONE.

PIRX  	MMFM    SP,A1,A2,A3
	RETS

**************************************************************************
*								         *
* 	 ADJ_BOX							 *
* 									 *
* 	 A1 HAS NUMBER OF LINES FOR ADJUSTMENT				 *
* 	 RETURN A10 AT Y IF 1ST LINE OF BOX.				 *
*								         *
**************************************************************************

CADJ_BOX
	MMTM	SP,A4,A5,A0,A9
	MOVI	ADJ_CULY,A10
	JRUC	ADJ_ENT

MADJ_BOX
	mmtm	sp,a4,a5,a0,a9
	movi	ADJ_PULY-37,a10
	jruc	ADJ_ENT

PADJ_BOX
	MMTM	SP,A4,A5,A0,A9
	MOVI	ADJ_PULY-12,A10
	JRUC	ADJ_ENT

ADJ_BOX
	MMTM	SP,A4,A5,A0,A9
	MOVI	ADJ_ULY,A10		;THIS IS TOP OF BOX
	CLR	A4

ADJ_ENT
	CMPI	2,A1
	JRNZ	ADJ_ENT_NORMAL
	MOVK	8,A5			;1 LINER KLUDGE
	JRUC	ADJ_ENT_GO
ADJ_ENT_NORMAL
	MOVI	HELP_DY,A5		;DISTANCE PER ENTRY
	MPYU	A1,A5			;DISTANCE FOR ALL ENTRIES
ADJ_ENT_GO
	ADD	A4,A5			;FIX IT UP A LITTLE
	ADDI	HELP_Y_MARGIN+(MB_YWID*2)+HELP_YLO_MARGIN,A5
*
*	A5 NOW CONTAINS FULL HEIGHT OF BOX
*
*
*	NOW FORM UPPER LEFT IN A4
*
	MOVE	A10,A4			;MOVE Y OVER
	SLL	16,A4			;MAKE ROOM FOR X
	ADDI	AM_HX,A4		;PUT IN THE X...THIS IS UPPER LEFT!

	ADD	A10,A5			;ADD BASE TO OFFSET
	SLL	16,A5			;PUT IN Y POSITION
	ADDI	TIT_LRX,A5		;ADD IN THE X FOR THE CORNER
*
*	NOW ADJUST FROM TOP OF BOX TO POSITION OF
*	1ST ENTRY.
*
	ADDI	MB_YWID+HELP_Y_MARGIN,A10	;Y OF 1ST ENTRY
*
*	A10 IS NOW SET FOR RETURN VALUE
*
	MOVI	COLOR_YELLOW,A9		;MAKE THESE BOXES YELLOW

	CALLA	STD_BORD
	MMFM	SP,A4,A5,A0,A9
	RETS

WH_BORD
	MMTM	SP,A9
	MOVI	COLOR_WHITE,A9
	CALLA	STD_BORD
	MMFM	SP,A9
	RETS

**** DATA SECTION BEGINS ****

	.data
*
*	GAME ADJUSTMENT
*
*	THE FOLLOWING STRUCTURES ARE FOR EACH ADJUSTMENT
*
*	AD_ROUT	EQU	0			;LONG...ROUTINE TO RUN WHEN SELECTED.
*	AD_TITLE EQU	AD_ROUT+LONG_SIZE	;LONG...POINTER TO TITLE FOR RIGHT COLUMN
*	AD_HELP	EQU	AD_TITLE+LONG_SIZE	;LONG...POINT TO HELP STRUCT FOR EXPLANATION
*	AD_CMOS	EQU	AD_HELP+LONG_SIZE	;WORD...GET_ADJ / PUT_ADJ NUMBER.
*	AD_MIN	EQU	AD_CMOS+WORD_SIZE	;LONG...MINIMUM VALUE FOR ADJ.
*	AD_MAX	EQU	AD_MIN+LONG_SIZE	;LONG...MAXIMUM VALUE FOR ADJ.
*	AD_DELTA EQU	AD_MAX+LONG_SIZE	;LONG...UNITS BETWEEN VALUES.
*	AD_ZEQU	EQU	AD_DELTA+LONG_SIZE	;LONG...NUMBER TO STORE IN MEMORY AS ZERO
*	AD_NAMEIT EQU	AD_ZEQU+LONG_SIZE	;LONG...ROUTINE TO PRINT VALUES.
*	AD_WRAP	EQU	AD_NAMEIT+LONG_SIZE	;WORD...NON ZERO TO WRAP FROM HIGHEST TO LOWEST
*	AD_NAMPTR EQU	AD_WRAP+WORD_SIZE	;LONG...POINTER TO DATA FOR NAMEIT ROUTINE
*
DO_PRICE
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	MESS_PRICE	;POINTER TO HEADER MESSAGE
	.LONG	HELP_PRICE	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJPRICE	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	1		;MINIMUM VALUE
	.LONG	CS_ENTS		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	COIN_SET	;MESSAGE LIST USED FOR VALUES.
	.WORD	WRAP_VAL	;WRAP AROUND ON COIN MODES
	.LONG	0		;LIST OF MESSAGES FOR THIS ADJ.
	.LONG	MESS_PRICE	;POINTER TO HEADER MESSAGE

DO_PARAM
	.LONG	PRICE_ADJ	;ROUTINE TO RUN
	.LONG	MESS_PARAM	;POINTER TO HEADER MESSAGE
	.LONG	HELP_PARAM	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJPRICE	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	1		;MINIMUM VALUE
	.LONG	CS_ENTS		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	PARAM_VAL	;Routine for showing current value
	.WORD	WRAP_VAL	;WRAP AROUND ON COIN MODES
	.LONG	0		;LIST OF MESSAGES FOR THIS ADJ.
	.LONG	MESS_PARAM	;POINTER TO HEADER MESSAGE


DO_DIFF
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	MESS_DIFF	;POINTER TO HEADER MESSAGE
	.LONG	HELP_DIFF	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJDIFF		;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	1		;MINIMUM VALUE
	.LONG	10		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	LIST_1LINE	;MESSAGE LIST USED FOR VALUES.
	.WORD	0		;DON'T WRAP AROUND
	.LONG	LIST_DIFF	;LIST OF MESSAGES FOR THIS ADJ.
	.LONG	MESS_DIFF	;POINTER TO HEADER MESSAGE

;DO_ENERGY
;	.LONG	GEN_ADJ		;ROUTINE TO RUN
;	.LONG	MESS_ENERGY	;POINTER TO HEADER MESSAGE
;	.LONG	HELP_ENERGY	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
;	.WORD	ADJENERGY	;CMOS ADJUSTMENT WE'RE SETTING
;	.LONG	5		;MINIMUM VALUE
;	.LONG	200		;MAXIMUM VALUE
;	.LONG	5		;MOVE UP AND DOWN BY 5'S
;	.LONG	0		;DON'T SUB ZERO FOR ANY
;	.LONG	JUST_BIN	;MESSAGE LIST USED FOR VALUES.
;	.WORD	0		;DON'T WRAP AROUND
;	.LONG	MESS_OFF	;LIST OF MESSAGES FOR THIS ADJ.
;	.LONG	MESS_ENERGY	;POINTER TO HEADER MESSAGE

;DO_BOMBS
;	.LONG	GEN_ADJ		;ROUTINE TO RUN
;	.LONG	MESS_BOMBS	;POINTER TO HEADER MESSAGE
;	.LONG	HELP_BOMBS	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
;	.WORD	ADJPAYOT	;CMOS ADJUSTMENT WE'RE SETTING
;	.LONG	0		;MINIMUM VALUE
;	.LONG	1		;MAXIMUM VALUE
;	.LONG	1		;MOVE UP AND DOWN BY 1'S
;	.LONG	0		;DON'T SUB ZERO FOR ANY
;	.LONG	JUST_BIN	;MESSAGE LIST USED FOR VALUES.
;	.WORD	0		;DON'T WRAP AROUND
;	.LONG	MESS_OFF	;LIST OF MESSAGES FOR THIS ADJ.
;	.LONG	MESS_BOMBS	;POINTER TO HEADER MESSAGE

DO_TMRSPD
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	MESS_TMRSPD	;POINTER TO HEADER MESSAGE
	.LONG	HELP_TMRSPD	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJTMRSPD	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	0		;MINIMUM VALUE
	.LONG	4		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	LIST_1LINE	;MESSAGE LIST USED FOR VALUES.
	.WORD	0		;DON'T WRAP AROUND
	.LONG	LIST_TMRSPD	;LIST OF MESSAGES FOR THIS ADJ.
	.LONG	MESS_TMRSPD	;POINTER TO HEADER MESSAGE


DO_AMODE
;	.LONG   GEN_ADJ		;ROUTINE TO RUN
;	.LONG   MESS_AMOD2	;POINTER TO HEADER MESSAGE
;	.LONG   HELP_AMODE	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
;	.WORD   ADJATMSND	;CMOS ADJUSTMENT WE'RE SETTING
;	.LONG   0		;MINIMUM VALUE
;	.LONG   1		;MAXIMUM VALUE
;	.LONG   1		;MOVE UP AND DOWN BY 1'S
;	.LONG   0		;DON'T SUB ZERO FOR ANY
;	.LONG   LIST_1LINE	;MESSAGE LIST USED FOR VALUES.
;	.WORD   WRAP_VAL	;WRAP AROUND
;	.LONG   LIST_AMODE	;LIST OF MESSAGES FOR THIS ADJ.
;	.LONG   MESS_AMODE	;POINTER TO HEADER MESSAGE

DO_HSOFF
	.LONG   GEN_ADJ		;ROUTINE TO RUN
	.LONG   MESS_HSOFF2	;POINTER TO HEADER MESSAGE
	.LONG   HELP_HSOFF	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD   ADJHSON		;CMOS ADJUSTMENT WE'RE SETTING
	.LONG   0		;MINIMUM VALUE
	.LONG   1		;MAXIMUM VALUE
	.LONG   1		;MOVE UP AND DOWN BY 1'S
	.LONG   0		;DON'T SUB ZERO FOR ANY
	.LONG   LIST_1LINE	;MESSAGE LIST USED FOR VALUES.
	.WORD   WRAP_VAL	;WRAP AROUND
	.LONG   LIST_NOYES	;LIST OF MESSAGES FOR THIS ADJ.
	.LONG   MESS_HSOFF	;POINTER TO HEADER MESSAGE

;DO_AHSRES
;	.LONG   GEN_ADJ		;ROUTINE TO RUN
;	.LONG   MESS_HSR2	;POINTER TO HEADER MESSAGE
;	.LONG   HELP_AHSRES	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
;	.WORD   ADJHSRES	;CMOS ADJUSTMENT WE'RE SETTING
;	.LONG   0		;MINIMUM VALUE
;	.LONG   25000		;MAXIMUM VALUE
;	.LONG   250		;MOVE UP AND DOWN BY 250'S
;	.LONG   0		;DON'T SUB ZERO FOR ANY
;	.LONG   BIN_OR_MESS	;MESSAGE LIST USED FOR VALUES.
;	.WORD   WRAP_VAL^HSR_VAL	;WRAP AROUND AND RESET HSC IF TOUCHED
;	.LONG   MESS_OFF	;LIST OF MESSAGES FOR THIS ADJ.
;	.LONG   MESS_AHSRES	;POINTER TO HEADER MESSAGE

DO_TOURMODE
	.LONG   GEN_ADJ		;ROUTINE TO RUN
	.LONG   MESS_TOURMODE	;POINTER TO HEADER MESSAGE
	.LONG   HELP_TOURMODE	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD   ADJTOURMODE	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG   0		;MINIMUM VALUE
	.LONG   1		;MAXIMUM VALUE
	.LONG   1		;MOVE UP AND DOWN BY 1'S
	.LONG   0		;DON'T SUB ZERO FOR ANY
	.LONG   LIST_1LINE	;MESSAGE LIST USED FOR VALUES.
	.WORD   WRAP_VAL	;WRAP AROUND AND RESET HSC IF TOUCHED
	.LONG   LIST_OFFON	;LIST OF MESSAGES FOR THIS ADJ.
	.LONG   MESS_TOURMODE	;POINTER TO HEADER MESSAGE

DO_CHALMODE
	.LONG   GEN_ADJ		;ROUTINE TO RUN
	.LONG   MESS_CHALMODE	;POINTER TO HEADER MESSAGE
	.LONG   HELP_CHALMODE	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD   ADJCHALMODE	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG   0		;MINIMUM VALUE
	.LONG   3		;MAXIMUM VALUE
	.LONG   1		;MOVE UP AND DOWN BY 1'S
	.LONG   0		;DON'T SUB ZERO FOR ANY
	.LONG   LIST_1LINE	;MESSAGE LIST USED FOR VALUES.
	.WORD   WRAP_VAL	;WRAP AROUND AND RESET HSC IF TOUCHED
	.LONG   LIST_CHALLENGE	;LIST OF MESSAGES FOR THIS ADJ.
	.LONG   MESS_CHALMODE	;POINTER TO HEADER MESSAGE

DO_PAY4OT
	.LONG   GEN_ADJ		;ROUTINE TO RUN
	.LONG   MESS_PAY4OT	;POINTER TO HEADER MESSAGE
	.LONG   HELP_PAY4OT	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD   ADJPAYOT	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG   0		;MINIMUM VALUE
	.LONG   1		;MAXIMUM VALUE
	.LONG   1		;MOVE UP AND DOWN BY 1'S
	.LONG   0		;DON'T SUB ZERO FOR ANY
	.LONG   LIST_1LINE	;MESSAGE LIST USED FOR VALUES.
	.WORD   WRAP_VAL	;WRAP AROUND AND RESET HSC IF TOUCHED
	.LONG   LIST_NOYES	;LIST OF MESSAGES FOR THIS ADJ.
	.LONG   MESS_PAY4OT	;POINTER TO HEADER MESSAGE
        

DO_MINVOL
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	MESS_MINVOL	;POINTER TO HEADER MESSAGE
	.LONG	HELP_MINVOL	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJMINVOL	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	0		;MINIMUM VALUE
	.LONG	128		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 5'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	JUST_BIN	;MESSAGE LIST USED FOR VALUES.
	.WORD	0		;DON'T WRAP AROUND
	.LONG	MESS_OFF	;LIST OF MESSAGES FOR THIS ADJ.
	.LONG	MESS_MINVOL	;POINTER TO HEADER MESSAGE

*
*	THESE ARE ALL FOR THE CUSTOM PRICING MENU
*
COINBITS	EQU     WRAP_VAL+VIRG_VAL+SIX_VAL

DO_LCOIN
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	M_LCU		;POINTER TO HEADER MESSAGE
	.LONG	HELP_LCU	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJLMULT	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	0		;MINIMUM VALUE
	.LONG	99		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	JUST_BIN	;JUST SHOW THE NUMBER
	.WORD	COINBITS	;WRAP AROUND
	.LONG	0		;NO EXTRA INFO NEEDED
	.LONG   M_LCU		;POINTER TO HEADER MESSAGE

DO_CCOIN
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	M_CCU		;POINTER TO HEADER MESSAGE
	.LONG	HELP_CCU	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJCMULT	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	0		;MINIMUM VALUE
	.LONG	99		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	JUST_BIN	;JUST SHOW THE NUMBER
	.WORD	COINBITS	;WRAP AROUND
	.LONG	0		;NO EXTRA INFO NEEDED
	.LONG	M_CCU		;POINTER TO HEADER MESSAGE

DO_RCOIN
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	M_RCU		;POINTER TO HEADER MESSAGE
	.LONG	HELP_RCU	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJRMULT	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	0		;MINIMUM VALUE
	.LONG	99		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	JUST_BIN	;JUST SHOW THE NUMBER
	.WORD	COINBITS	;WRAP AROUND
	.LONG	0		;NO EXTRA INFO NEEDED
	.LONG	M_RCU		;POINTER TO HEADER MESSAGE

DO_4COIN
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	M_4CU		;POINTER TO HEADER MESSAGE
	.LONG	HELP_4CU	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJ4MULT	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	0		;MINIMUM VALUE
	.LONG	99		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	JUST_BIN	;JUST SHOW THE NUMBER
	.WORD	COINBITS	;WRAP AROUND
	.LONG	0		;NO EXTRA INFO NEEDED
	.LONG	M_4CU		;POINTER TO HEADER MESSAGE


DO_DBV
	.long	GEN_ADJ	     ;routine to run
	.long	M_DBV		;pointer to header message
	.long	HELP_DBV	    ;pointer to help messages for right side
	.word	ADJDBVMULT	    ;cmos adjustment we're setting
	.long	0		   ;minimum value
	.long	99		  ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	JUST_BIN	    ;just show the number
	.word	COINBITS	    ;wrap around
	.long	0		   ;no extra info needed
	.long	M_DBV		;pointer to header message

DO_TOTALIZER
	.long	GEN_ADJ 	     ;routine to run
	.long	M_TOTALIZER		     ;pointer to header message
	.long	HELP_TOTALIZER	     ;pointer to help messages for right side
	.word	ADJTOTALIZER	     ;cmos adjustment we're setting
	.long	0		     ;minimum value
	.long	1		     ;maximum value
	.long	1		     ;move up and down by 1's
	.long	0		     ;don't sub zero for any
	.long	LIST_1LINE	     ;just show the number
	.word	WRAP_VAL	     ;wrap around
	.long	LIST_NOYES		     ;no extra info needed
	.long	M_TOTALIZER		     ;pointer to header message

DO_LMULT
	.long	GEN_ADJ 	     ;routine to run
	.long	M_LMULT		     ;pointer to header message
	.long	HELP_LMULT	     ;pointer to help messages for right side
	.word	ADJLTOTMULT	     ;cmos adjustment we're setting
	.long	0		     ;minimum value
	.long	99		     ;maximum value
	.long	1		     ;move up and down by 1's
	.long	0		     ;don't sub zero for any
	.long	JUST_BIN	     ;just show the number
	.word	COINBITS	     ;wrap around
	.long	0		     ;no extra info needed
	.long	M_LMULT		     ;pointer to header message
DO_RMULT
	.long	GEN_ADJ 	     ;routine to run
	.long	M_RMULT		     ;pointer to header message
	.long	HELP_RMULT	     ;pointer to help messages for right side
	.word	ADJRTOTMULT	     ;cmos adjustment we're setting
	.long	0		     ;minimum value
	.long	99		     ;maximum value
	.long	1		     ;move up and down by 1's
	.long	0		     ;don't sub zero for any
	.long	JUST_BIN	     ;just show the number
	.word	COINBITS	     ;wrap around
	.long	0		     ;no extra info needed
	.long	M_RMULT		     ;pointer to header message
DO_CMULT
	.long	GEN_ADJ 	     ;routine to run
	.long	M_CMULT		     ;pointer to header message
	.long	HELP_CMULT	     ;pointer to help messages for right side
	.word	ADJCTOTMULT	     ;cmos adjustment we're setting
	.long	0		     ;minimum value
	.long	99		     ;maximum value
	.long	1		     ;move up and down by 1's
	.long	0		     ;don't sub zero for any
	.long	JUST_BIN	     ;just show the number
	.word	COINBITS	     ;wrap around
	.long	0		     ;no extra info needed
	.long	M_CMULT		     ;pointer to header message
DO_XMULT
	.long	GEN_ADJ 	     ;routine to run
	.long	M_XMULT		     ;pointer to header message
	.long	HELP_XMULT	     ;pointer to help messages for right side
	.word	ADJXTOTMULT	     ;cmos adjustment we're setting
	.long	0		     ;minimum value
	.long	99		     ;maximum value
	.long	1		     ;move up and down by 1's
	.long	0		     ;don't sub zero for any
	.long	JUST_BIN	     ;just show the number
	.word	COINBITS	     ;wrap around
	.long	0		     ;no extra info needed
	.long	M_XMULT		     ;pointer to header message

DO_DBVMULT
	.long	GEN_ADJ 	     ;routine to run
	.long	M_DBVMULT		     ;pointer to header message
	.long	HELP_BMULT	     ;pointer to help messages for right side
	.word	ADJBTOTMULT	     ;cmos adjustment we're setting
	.long	0		     ;minimum value
	.long	99		     ;maximum value
	.long	1		     ;move up and down by 1's
	.long	0		     ;don't sub zero for any
	.long	JUST_BIN	     ;just show the number
	.word	COINBITS	     ;wrap around
	.long	0		     ;no extra info needed
	.long	M_DBVMULT		     ;pointer to header message

DO_UC
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	M_UC		;POINTER TO HEADER MESSAGE
	.LONG	HELP_UC		;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJCUNIT	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	1		;MINIMUM VALUE
	.LONG	99		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	JUST_BIN	;JUST SHOW THE NUMBER
	.WORD	COINBITS	;WRAP AROUND
	.LONG	0		;NO EXTRA INFO NEEDED
	.LONG	M_UC		;POINTER TO HEADER MESSAGE

DO_UB
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	M_UB		;POINTER TO HEADER MESSAGE
	.LONG	HELP_UB		;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJBUNIT	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	0		;MINIMUM VALUE
	.LONG	99		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	BIN_OR_MESS	;JUST SHOW THE NUMBER
	.WORD	COINBITS	;WRAP AROUND
	.LONG	M_NOBONUS	;NO EXTRA INFO NEEDED
	.LONG	M_UB		;POINTER TO HEADER MESSAGE

DO_UM
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	M_UM2		;POINTER TO HEADER MESSAGE
	.LONG	HELP_UM		;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJMUNIT	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	0		;MINIMUM VALUE
	.LONG	99		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	BIN_OR_MESS	;JUST SHOW THE NUMBER
	.WORD	COINBITS	;WRAP AROUND
	.LONG	M_NOMIN		;NO EXTRA INFO NEEDED
	.LONG	M_UM		;POINTER TO HEADER MESSAGE

CREDBITS	EQU	VIRG_VAL+SIX_VAL

DO_CST
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	M_CST		;POINTER TO HEADER MESSAGE
	.LONG	HELP_CS		;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJCSTRT	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	1		;MINIMUM VALUE
	.LONG	4		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	JUST_BIN	;JUST SHOW THE NUMBER
	.WORD	CREDBITS	;WRAP AROUND
	.LONG	0		;NO EXTRA INFO NEEDED
	.LONG	M_CST		;POINTER TO HEADER MESSAGE

DO_CONT
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	M_CONT2		;POINTER TO HEADER MESSAGE
	.LONG	HELP_CC		;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJCCONT	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	1		;MINIMUM VALUE
	.LONG	4		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	JUST_BIN	;JUST SHOW THE NUMBER
	.WORD	CREDBITS	;WRAP AROUND
	.LONG	0		;NO EXTRA INFO NEEDED
	.LONG	M_CONT		;POINTER TO HEADER MESSAGE


DO_CPD
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	M_CPD		;POINTER TO HEADER MESSAGE
	.LONG	HELP_CPD	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJCDIV		;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	0		;MINIMUM VALUE
	.LONG	20		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	BIN_OR_MESS	;JUST SHOW THE NUMBER
	.WORD	0		;NO WRAP AROUND
	.LONG	M_NO_COL	;NO EXTRA INFO NEEDED
	.LONG	M_CPD		;POINTER TO HEADER MESSAGE

DO_MAX
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	M_MAX		;POINTER TO HEADER MESSAGE
	.LONG	HELP_MAX	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJMAXC		;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	5		;MINIMUM VALUE
	.LONG	99		;MAXIMUM VALUE
	.LONG	1		;MOVE UP AND DOWN BY 1'S
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	JUST_BIN	;JUST SHOW THE NUMBER
	.WORD	WRAP_VAL	;WRAP AROUND
	.LONG	0		;NO EXTRA INFO NEEDED
	.LONG	M_MAX		;POINTER TO HEADER MESSAGE

DO_FREE
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	MESS_FREE	;POINTER TO HEADER MESSAGE
	.LONG	HELP_FREE	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJFREPL	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	0		;MINIMUM VALUE
	.LONG	1		;MAXIMUM VALUE
	.LONG	1
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.LONG	LIST_1LINE	;MESSAGE LIST USED FOR VALUES.
	.WORD	WRAP_VAL	;WRAP AROUND
*
*	G_FREE:	REPLACE  ".LONG LIST_NOYES"   WITH  ".LONG LIST_YESNO"
*
*	.LONG	LIST_YESNO	;LIST OF MESSAGES FOR THIS ADJ.
	.LONG	LIST_NOYES	;LIST OF MESSAGES FOR THIS ADJ.
	.LONG	MESS_FREE	;POINTER TO HEADER MESSAGE

DO_FULL
	.LONG	GEN_ADJ		;ROUTINE TO RUN
	.LONG	MESS_FULL	;POINTER TO HEADER MESSAGE
	.LONG	HELP_FULL	;POINTER TO HELP MESSAGES FOR RIGHT SIDE
	.WORD	ADJFULLGAME	;CMOS ADJUSTMENT WE'RE SETTING
	.LONG	3		;MINIMUM VALUE
	.LONG	12		;MAXIMUM VALUE
	.LONG	1
	.LONG	0		;DON'T SUB ZERO FOR ANY
	.long	JUST_BIN	     ;just show the number
	.WORD	0		;DON'T WRAP AROUND
	.LONG	0		;NO EXTRA INFO NEEDED
	.LONG	MESS_FULL	;POINTER TO HEADER MESSAGE

*
*	ADJUSTMENT MENU IS SKINNY..LEAVING ROOM FOR EXPLANATION.
*
AM_BDY	EQU	-7
;AM_WID	EQU	139
AM_WID	EQU	BAR_WID
AM_X	EQU	TIT_ULX+GAP+MB_XWID+(AM_WID/2)+C_KLUDGE
AM_Y	EQU	INST_LRY+BOX_YGAP+MB_YWID+GAP-AM_BDY
*
*	RIGHT MARGIN OF ADJUST MENU BOX
*
AM_RX	EQU	TIT_ULX+(2*GAP)+AM_WID+(2*MB_XWID)
*
*	LEFT MARGIN OF HELP BOX
*
AM_HX	EQU	AM_RX+BOX_XGAP

MEN_PADJ
	.LONG	RD7FONT			;FONT
	.LONG	STRCNRM			;CENTER PLEASE
	.LONG	M_PADJ			;TITLE
	.WORD	COLOR_WHITE		;COLOR OF TITLE
	.WORD	MENU_X			;UL X
	.WORD	MENU_Y-6		;UL Y
	.WORD	14
	.WORD	COLOR_WHITE		;COLOR WHEN NOT SELECTED
	.WORD	14			;HEIGHT OF SELECTION BAR
	.WORD	-3			;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX			;EXTRA X ON EACH SIDE.
	.WORD	BAR_WID			;WIDTH OF BAR!
	.WORD	COLOR_DECAY		;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_MM,0,BLNK_HELP	;RETURN TO MAIN MENU
	.LONG	MESS_PRICE,DO_PRICE,ADJ_HELP	;STANDARD PRICING
	.long	MESS_MULT,DO_MULT,ADJ_HELP
	.LONG	MESS_PARAM,DO_PARAM,ADJ_HELP	;CUSTOM PRICING
	.LONG	MESS_FREE,DO_FREE,ADJ_HELP	;FREE PLAY
	.LONG	MESS_FULL,DO_FULL,ADJ_HELP	;FULL GAME
	.LONG	MESS_MM,0,BLNK_HELP	;RETURN TO MAIN MENU
	.LONG	0			;END


MEN_GADJ
	.LONG	RD7FONT			;FONT
	.LONG	STRCNRM			;CENTER PLEASE
	.LONG	M_GADJ			;TITLE
	.WORD	COLOR_WHITE		;COLOR OF TITLE
	.WORD	MENU_X			;UL X
	.WORD	MENU_Y-6		;UL Y
	.WORD	14
	.WORD	COLOR_WHITE		;COLOR WHEN NOT SELECTED
	.WORD	14			;HEIGHT OF SELECTION BAR
	.WORD	-3			;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX			;EXTRA X ON EACH SIDE.
	.WORD	BAR_WID			;WIDTH OF BAR!
	.WORD	COLOR_DECAY		;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_MM,0,BLNK_HELP	;RETURN TO MAIN MENU
	.LONG	MESS_HSOFF,DO_HSOFF,ADJ_HELP
	.LONG	MESS_DIFF,DO_DIFF,ADJ_HELP	;DIFFICULTY
	.LONG	MESS_TMRSPD,DO_TMRSPD,ADJ_HELP
	.LONG	MESS_TOURMODE,DO_TOURMODE,ADJ_HELP
	.LONG	MESS_CHALMODE,DO_CHALMODE,ADJ_HELP
	.LONG	MESS_PAY4OT,DO_PAY4OT,ADJ_HELP
	.LONG	MESS_MINVOL,DO_MINVOL,ADJ_HELP
	.LONG	MESS_MM,0,BLNK_HELP	;RETURN TO MAIN MENU
	.LONG	0			;END


;MEN_ADJ2
;	.LONG   RD7FONT			;FONT
;	.LONG   STRCNRM			;CENTER PLEASE
;	.LONG   M_MOREGADJ		;TITLE
;	.WORD   COLOR_WHITE		;COLOR OF TITLE
;	.WORD   MENU_X			;UL X
;	.WORD   MENU_Y			;UL Y
;	.WORD   14			;VERTICAL SPACING
;	.WORD   COLOR_WHITE		;COLOR WHEN NOT SELECTED
;	.WORD   14			;HEIGHT OF SELECTION BAR
;	.WORD   -3			;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
;	.WORD   BAR_DX			;EXTRA X ON EACH SIDE.
;	.WORD   BAR_WID			;WIDTH OF BAR!
;	.WORD   COLOR_DECAY		;TEXT COLOR OF SELECTED ITEM
;	.LONG   MESS_AM,0,BLNK_HELP	;RETURN TO ADJUSTMENT MENU
;	.LONG	MESS_AMODE,DO_AMODE,ADJ_HELP
;	.LONG	MESS_AHSRES,DO_AHSRES,ADJ_HELP
;	.LONG	MESS_HSOFF,DO_HSOFF,ADJ_HELP
;	.LONG	MESS_MINVOL,DO_MINVOL,ADJ_HELP
;	.LONG   MESS_AM,0,BLNK_HELP	;RETURN TO ADJUSTMENT MENU
;	.LONG   0			;END


MEN_CUST
	.LONG   RD7FONT			;FONT
	.LONG   STRCNRM			;CENTER PLEASE
	.LONG   M_CUSPRI		;TITLE
	.WORD   COLOR_BLUE		;COLOR OF TITLE
	.WORD   MENU_X			;UL X
	.WORD   MENU_Y-8		;UL Y
	.WORD   11			;VERTICAL SPACING
	.WORD   COLOR_BLUE		;COLOR WHEN NOT SELECTED
	.WORD   12			;HEIGHT OF SELECTION BAR
	.WORD   -2			;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD   BAR_DX			;EXTRA X ON EACH SIDE.
	.WORD   BAR_WID			;WIDTH OF BAR!
	.WORD   COLOR_DECAY		;TEXT COLOR OF SELECTED ITEM
	.LONG   MESS_AM,0,BLNK_HELP	;RETURN TO MAIN MENU
	.LONG   M_LCU,DO_LCOIN,ADJ_HELP	;LEFT SLOT UNITS
	.LONG   M_RCU,DO_RCOIN,ADJ_HELP	;RIGHT SLOT UNITS
	.LONG   M_CCU,DO_CCOIN,ADJ_HELP	;CENTER SLOT UNITS
	.LONG	M_4CU,DO_4COIN,ADJ_HELP	;FOURTH SLOT UNITS
	.long	M_DBV,DO_DBV,ADJ_HELP	;dollar bill validator
	.LONG   M_UC,DO_UC,ADJ_HELP	;UNITS FOR CREDIT
	.LONG   M_UB,DO_UB,ADJ_HELP	;UNITS FOR BONUS
	.LONG   M_UM,DO_UM,ADJ_HELP	;MINIMUM UNITS
	.LONG   M_CST,DO_CST,ADJ_HELP	;CREDITS REQUIRED TO START
	.LONG   M_CONT,DO_CONT,ADJ_HELP	;CREDITS REQUIRED TO CONTINUE
	.LONG   M_CPD,DO_CPD,ADJ_HELP	;COINS PER DOLLAR
	.LONG   M_MAX,DO_MAX,ADJ_HELP	;MAXIMUM CREDITS
	.LONG   MESS_AM,0,BLNK_HELP	;RETURN TO MAIN MENU
	.LONG   0			;END

MEN_MULT:
	.long	RD7FONT 		;font
	.long	STRCNRM 		;center please
	.long	MESS_MULT  		;title
	.word	COLOR_BLUE		;color of title
	.word	MENU_X	   ;ul x
	.word	MENU_Y	   ;ul y
	.word	11			;vertical spacing
	.word	COLOR_BLUE		;color of title
	.word	12			;height of selection bar
	.word	-2	     ;distance of bar from top of text (negative)
	.word	BAR_DX	 ;extra x on each side.
	.word	BAR_WID	 ;width of bar!
	.word	COLOR_DECAY     ;text color of selected item
	.long	MESS_AM,0,BLNK_HELP	;return to main menu
	.long	M_TOTALIZER,DO_TOTALIZER,ADJ_HELP
	.long	M_LMULT,DO_LMULT,ADJ_HELP	;left slot units
	.long	M_RMULT,DO_RMULT,ADJ_HELP	;left slot units
	.long	M_CMULT,DO_CMULT,ADJ_HELP	;left slot units
	.long	M_XMULT,DO_XMULT,ADJ_HELP	;left slot units
	.long	M_DBVMULT,DO_DBVMULT,ADJ_HELP	;left slot units
	.long	MESS_AM,0,BLNK_HELP	;return to main menu
	.long	0

M_PADJ
        .STRING W_PRICING," OPTIONS",0
        .EVEN



M_GADJ
	.STRING	W_GAME," ",W_ADJUSTMENT,0
	.EVEN
M_MOREGADJ
	.STRING	"MORE ",W_GAME," ",W_ADJUSTMENTS,0
	.EVEN
M_CUSPRI
	.STRING	W_CUSTOM," ",W_PRICING,0
	.EVEN
MESS_FREE
	.STRING	W_FREE," ",W_PLAY,0
	.EVEN
MESS_PRICE
	.STRING	W_STANDARD," ",W_PRICING,0
	.EVEN
MESS_PARAM
	.STRING	W_CUSTOM," ",W_PRICING,0
	.EVEN

MESS_FULL    
        .STRING W_CREDITS," FOR FULL ",W_GAME,0
        .EVEN
MESS_DIFF
	.STRING	"COMPUTER DIFFICULTY",0
	.EVEN
MESS_TMRSPD
	.STRING	"GAME TIMER SPEED",0
        .EVEN
MESS_TOURMODE
	.STRING	"TOURNAMENT MODE",0	;FOR MENU
	.EVEN
MESS_CHALMODE
	.STRING	"CHALLENGE MODE",0	;FOR MENU
	.EVEN
MESS_PAY4OT
	.STRING	"CHARGE FOR OVERTIME",0	;FOR MENU
	.EVEN

;MESS_AMODE
;MESS_AMOD2
;	.STRING	"ATTRACT-MODE SOUND",0		;MENU TITLE
;	.EVEN


MESS_HSOFF
MESS_HSOFF2
	.STRING	"HIGH SCORE DISPLAY",0          ; 
	.EVEN


MESS_MINVOL
	.STRING	"SET ",W_MINIMUM," VOLUME",0
	.EVEN
M_LCU
	.STRING "LEFT ",W_CHUTE," ",W_UNITS,0
	.EVEN
M_CCU
	.STRING "THIRD ",W_CHUTE," ",W_UNITS,0
	.EVEN
M_RCU
	.STRING "RIGHT ",W_CHUTE," ",W_UNITS,0
	.EVEN
M_4CU
	.STRING "FOURTH ",W_CHUTE," ",W_UNITS,0
	.EVEN
M_TOTALIZER
	.string "TOTALIZER MODE"
	.byte 0
	.even
M_LMULT
	.string "CHUTE 1 TOTALIZER"
	.byte 0
	.even
M_RMULT
	.string "CHUTE 2 TOTALIZER"
	.byte 0
	.even
M_CMULT
	.string "CHUTE 3 TOTALIZER"
	.byte 0
	.even
M_XMULT
	.string "CHUTE 4 TOTALIZER"
	.byte 0
	.even
M_DBVMULT
	.string "DBV TOTALIZER"
	.byte 0
	.even
M_DBV	
	.string "DBV ",W_UNITS
	.byte 0
	.even
M_UC
	.STRING W_UNITS," / ",W_CREDIT,0
	.EVEN
M_UB
	.STRING W_UNITS," / BONUS",0
	.EVEN
M_UM2
M_UM
	.STRING "MINIMUM ",W_UNITS," REQUIRED",0
	.EVEN
M_CST
	.STRING W_CREDITS," TO START",0
	.EVEN
M_CONT2
M_CONT
	.STRING W_CREDITS," TO CONTINUE",0
	.EVEN
M_CPD
	.STRING W_COINS," PER DOLLAR",0
	.EVEN
M_MAX
	.STRING "MAXIMUM ",W_CREDITS,0
	.EVEN
MESS_AM
	.STRING "RETURN TO ADJ. MENU",0
	.EVEN

*
*	THIS IS THE ADJUSTMENT NAME IN THE UPPER RIGHT
*	BOX
*
ADJT_Y	EQU	INST_ULY+12		;CENTER IN THE BOX
ADJT_SETUP
	MESS_MAC RD7FONT,SPACING07,200,ADJT_Y,COLOR_PLF,STRCNRM,0

CSET_Y	EQU	CUR_ULY2+12
MESS_CURSET
	MESS_MAC RD7FONT,SPACING07,200,CSET_Y+2,COLOR_PYELLOW,STRCNRM,0
	.STRING	"CURRENT SETTING",0
	.EVEN

IN_Y1	EQU	CUR_ULY+20
IN_Y2	EQU	IN_Y1+10
IN_Y2A	EQU	IN_Y1+20
;IN_Y3	EQU	IN_Y2+62
IN_Y3	EQU	IN_Y1+28H
IN_Y4	EQU	IN_Y3+10


INST_TO_ADJ
	MESS_MAC RD7FONT,SPACING07,AM_X,IN_Y1,COLOR_PWHITE,STRCNRM,0
	.STRING	"MODIFY VALUE WITH",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,AM_X,IN_Y2,COLOR_PWHITE,STRCNRM,0
	.STRING	"JOYSTICK",0
	.EVEN
	.WORD	1
;	MESS_MAC RD7FONT,SPACING07,AM_X,IN_Y2A,COLOR_PWHITE,STRCNRM,0
;	.STRING	"PLAYER 2 START = DOWN",0
;	.EVEN
;	.WORD	1
	MESS_MAC RD7FONT,SPACING07,AM_X,IN_Y3,COLOR_PWHITE,STRCNRM,0
	.STRING	"PRESS ANY BUTTON",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,AM_X,IN_Y4,COLOR_PWHITE,STRCNRM,0
	.STRING	"WHEN VALUE IS CORRECT",0
	.EVEN
	.WORD	0

*
*	FOR THE WORD UNDER "ADJUSTING" WHILE THE ADJUSTING
*	IS ACTUALLY BEING DONE
*
ADNOW_Y1 EQU     CUR_ULY-33
ADNOW_Y2 EQU     ADNOW_Y1+14

MES_ADJUSTING
	MESS_MAC  RD7FONT,SPACING07,AM_X,ADNOW_Y1,COLOR_PLF,STRCNRM,0
	.STRING   "ADJUSTING"
	.BYTE   0
	.EVEN
	.WORD	0

MES_ADNAME
	MESS_MAC  RD7FONT,SPACING07,AM_X,ADNOW_Y2,COLOR_PLF,STRCNRM,0

INSTR_Y  EQU     INST_ULY+5
INSTR_2Y EQU     INSTR_Y+11

ADJ_ADV
	MESS_MAC RD7FONT,SPACING07,AM_X,INSTR_Y,COLOR_PRGB,STRCNRM,0
	.STRING	"SELECT WITH ANY JOYSTICK",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,AM_X,INSTR_2Y,COLOR_PRGB,STRCNRM,0
	.STRING	"ACTIVATE WITH ACTION BUTTON",0
	.EVEN
	.WORD	0


;AAY      EQU     IN_Y1+28H
AAY	EQU	IN_Y2+72
*AAX      EQU     AM_RX-12

ADJ_ARROW
	MESS_MAC RD15FONT,3,AM_X,AAY-10,COLOR_PLF,STRCNRM,0
	.STRING	">>>>>>>",0
	.EVEN
*
*	IF COIN SETTINGS DON'T NEATLY FIT INTO
*	A MODE
*


MESS_TAMPERED
	.STRING W_CUSTOM,0
	.EVEN
MESS_DIP
	.STRING	"DIPSWITCH",0
	.EVEN
MESS_GP
	.STRING W_PRICING,":",0
	.EVEN
MESS_FP
	.STRING W_FREE," ",W_PLAY,":",0
	.EVEN
MESS_MAX
	.STRING "MAXIMUM ",W_CREDITS,":",0
	.EVEN
M_CTS_PL
	.STRING W_CREDITS," TO START:",0
	.EVEN
M_CTC_PL
	.STRING W_CREDITS," TO CONTINUE:",0
	.EVEN
;M_SLOTVAL
;	.STRING W_COIN," SLOT VALUE",0
;	.EVEN


M_MULTVAL
	 .string "MULTIPLIER VALUES"
	 .byte	 0
	 .even
M_TOTMESS
	 .string "USING MULTIPLIERS : "
	 .byte	 0
	 .even
M_MULTVAL1
	 .string "CHUTE 1 MULTIPLIER : "
	 .byte	 0
	 .even
M_MULTVAL2
	 .string "CHUTE 2 MULTIPLIER : "
	 .byte	 0
	 .even
M_MULTVAL3
	 .string "CHUTE 3 MULTIPLIER : "
	 .byte	 0
	 .even
M_MULTVAL4
	 .string "CHUTE 4 MULTIPLIER : "
	 .byte	 0
	 .even
M_MULTVAL5
	 .string "VALIDATOR MULTIPLIER : "
	 .byte	 0
	 .even
M_SLOTVAL
	.string "BILL",0
	.byte	0
	.even

**************************************************************************
*									*
*	 HELP STRUCTURES FOR MAIN ADJUSTMENT MENU!		    *
*									*
**************************************************************************
HELP_DIFF
	.WORD   1	      ;CENTER JUSTIFY
	.WORD   COLOR_BLUE    ;COLOR
	.WORD   6	      ;6 ENTRIES
	.LONG   DH_0
	.LONG   DH_1
	.LONG   DH_2            ;  
	.LONG   DH_3
	.LONG   DH_4
	.LONG   DH_5

HELP_PRICE
	.WORD   0	      ;CENTER JUSTIFY
	.WORD   COLOR_BLUE    ;COLOR
	.WORD   3	      ;5 ENTRIES
	.LONG   PH_0
	.LONG   PH_1
	.LONG   PH_2

HELP_MULT
	 .word	 0		 ;center justify
	 .word	 COLOR_BLUE	;color
	 .word	 3		 ;5 entries
	 .long	 mh_0
	 .long	 mh_1
	 .long	 mh_2


HELP_DIP
	.WORD   0	      ;CENTER JUSTIFY
	.WORD   COLOR_RED	;COLOR
	.WORD	3
	.LONG   DIH_0
	.LONG   DIH_1
	.LONG   DIH_2

HELP_PARAM
	.WORD   0	      ;CENTER JUSTIFY
	.WORD   COLOR_BLUE    ;COLOR
	.WORD   5	      ;5 ENTRIES
	.LONG   PP_0
	.LONG   PP_1
	.LONG   PP_2
	.LONG   PP_3
	.LONG   PP_4

;HELP_ENERGY
;	.WORD	0		;CENTER JUSTIFY
;	.WORD	COLOR_BLUE	;COLOR
;	.WORD	6		;6 ENTRIES
;	.LONG	LH_0
;	.LONG	LH_1
;	.LONG	LH_2
;	.LONG	LH_3
;	.LONG	M_NULL
;	.LONG	LH_4

;HELP_BOMBS
;	.WORD	0		;CENTER JUSTIFY
;	.WORD	COLOR_BLUE	;COLOR
;	.WORD	6		;6 ENTRIES
;	.LONG	BH_0
;	.LONG	BH_1
;	.LONG	BH_2
;	.LONG	BH_3
;	.LONG	M_NULL
;	.LONG	BH_4

HELP_TMRSPD
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	5		;6 ENTRIES
	.LONG	MTH_0
	.LONG	MTH_1
	.LONG	MTH_2
	.LONG	M_NULL
	.LONG	MTH_4

;HELP_AMODE
;	.WORD   0	      ;CENTER JUSTIFY
;	.WORD   COLOR_BLUE    ;COLOR
;	.WORD   5	      ;6 ENTRIES
;	.LONG   HAM_1
;	.LONG   HAM_2
;	.LONG   HAM_3
;	.LONG   M_NULL
;	.LONG   HAM_4

HELP_HSOFF
	.WORD   0	      ;CENTER JUSTIFY
	.WORD   COLOR_BLUE    ;COLOR
	.WORD   6	      ;6 ENTRIES
	.LONG   HAM_1
	.LONG   HSO_2
	.LONG   HSO_3
	.LONG	HSO_4
	.LONG   M_NULL
	.LONG   HSO_5

HELP_TOURMODE
	.WORD   0	      ;CENTER JUSTIFY
	.WORD   COLOR_BLUE    ;COLOR
	.WORD   6	      ;6 ENTRIES
	.LONG   HAH_1
	.LONG   HAH_2
	.LONG   HAH_3
	.LONG   HAH_4
	.LONG   M_NULL
	.LONG   HAH_5

HELP_CHALMODE
	.WORD   0	      ;CENTER JUSTIFY
	.WORD   COLOR_BLUE    ;COLOR
	.WORD   6	      ;6 ENTRIES
	.LONG   CHM_1
	.LONG   CHM_2
	.LONG   CHM_3
	.LONG   CHM_4
	.LONG   M_NULL
	.LONG   CHM_5

HELP_PAY4OT
	.WORD   0	      ;CENTER JUSTIFY
	.WORD   COLOR_BLUE    ;COLOR
	.WORD   6	      ;6 ENTRIES
	.LONG   POT_1
	.LONG   POT_2
	.LONG   POT_3
	.LONG   POT_4
	.LONG   M_NULL
	.LONG   POT_5


HELP_MINVOL
	.WORD   0	      ;CENTER JUSTIFY
	.WORD   COLOR_BLUE    ;COLOR
	.WORD   5	      ;6 ENTRIES
	.LONG   HMV_1
	.LONG   HMV_2
	.LONG   HMV_3
	.LONG   M_NULL
	.LONG   HMV_4

HELP_FREE
	.WORD   0
	.WORD   COLOR_BLUE
	.WORD   6
	.LONG   FP_M1
	.LONG   FP_M2
	.LONG   FP_M3
	.LONG   FP_M4
	.LONG   M_NULL
	.LONG   FP_M5


HELP_FULL
	.WORD   0
	.WORD   COLOR_BLUE
	.WORD   6
	.LONG   FG_M1
	.LONG   FG_M2
	.LONG   FG_M3
	.LONG   FG_M4
	.LONG   FG_M5
	.LONG   FG_M6

FG_M1   .STRING "ALLOWS PURCHASING A FULL "
        .BYTE 0
	.EVEN

FG_M2   .STRING W_GAME," AT A DISCOUNT FROM"
        .BYTE 0
	.EVEN

FG_M3   .STRING "NORMAL START/BUY-IN"
        .BYTE 0
	.EVEN

FG_M4   .STRING "PRICING."
        .BYTE 0
	.EVEN

FG_M5   .STRING W_MINIMUM,": 3, ",W_MAXIMUM,": 12"
        .BYTE 0
	.EVEN

FG_M6   .STRING "FACTORY SETTING: 6"
        .BYTE 0
	.EVEN


HELP_LCU
	.WORD   0
	.WORD   COLOR_WHITE
	.WORD   6
	.LONG   LC_M1
	.LONG   LC_M2
	.LONG   LC_M3
	.LONG   LC_M4
	.LONG   LC_M5
	.LONG   LC_M6

HELP_CCU
	.WORD   0
	.WORD   COLOR_WHITE
	.WORD   6
	.LONG   LC_M1
	.LONG   LC_M2
	.LONG   LC_M3
	.LONG   LC_M4
	.LONG   CC_M5
	.LONG   LC_M6

HELP_RCU
	.WORD   0
	.WORD   COLOR_WHITE
	.WORD   6
	.LONG   LC_M1
	.LONG   LC_M2
	.LONG   LC_M3
	.LONG   LC_M4
	.LONG   RC_M5
	.LONG   LC_M6

HELP_4CU
	.WORD   0
	.WORD   COLOR_WHITE
	.WORD   6
	.LONG   LC_M1
	.LONG   LC_M2
	.LONG   LC_M3
	.LONG   LC_M4
	.LONG   C4C_M5
	.LONG   LC_M6

HELP_LMULT
	 .word	 0
	 .word	 COLOR_WHITE
	 .word	 3
	 .long	 mz_m1
	 .long	 mz_m2
	 .long	 mz_c1

HELP_RMULT
	 .word	 0
	 .word	 COLOR_WHITE
	 .word	 3
	 .long	 mz_m1
	 .long	 mz_m2
	 .long	 mz_c2

HELP_CMULT
	 .word	 0
	 .word	 COLOR_WHITE
	 .word	 3
	 .long	 mz_m1
	 .long	 mz_m2
	 .long	 mz_c3

HELP_XMULT
	 .word	 0
	 .word	 COLOR_WHITE
	 .word	 3
	 .long	 mz_m1
	 .long	 mz_m2
	 .long	 mz_c4

HELP_BMULT
	 .word	 0
	 .word	 COLOR_WHITE
	 .word	 3
	 .long	 mz_m1
	 .long	 mz_m2
	 .long	 mz_db

HELP_TOTALIZER
	 .word	 0
	 .word	 COLOR_WHITE
	 .word	 6
	 .long	 mr_m1
	 .long	 mr_m2
	 .long	 mr_m3
	 .long	 mr_m4
	 .long	 mr_m5
	 .long	 mr_m6

HELP_DBV
	 .word	 0
	 .word	 COLOR_WHITE
	 .word	 6
	 .long	 LC_M1
	 .long	 LC_M2
	 .long	 LC_M3
	 .long	 LC_M4
	 .long	 dbv_m5
	 .long	 LC_M6


HELP_UC  .WORD   0
	.WORD   COLOR_WHITE
	.WORD   3
	.LONG   UC_M1
	.LONG   UC_M2
	.LONG   UC_M3

HELP_UB  .WORD   0
	.WORD   COLOR_WHITE
	.WORD   3
	.LONG   UB_M1
	.LONG   UB_M2
	.LONG   UB_M3

HELP_UM  .WORD   0
	.WORD   COLOR_WHITE
	.WORD   3
	.LONG   UM_M1
	.LONG   UM_M2
	.LONG   UM_M3


HELP_CS  .WORD   0
	.WORD   COLOR_WHITE
	.WORD   3
	.LONG   CS_M1
	.LONG   CS_M2
	.LONG   CS_M3

HELP_CC  .WORD   0
	.WORD   COLOR_WHITE
	.WORD   3
	.LONG   CS_M1
	.LONG   CS_M2
	.LONG   CC_M3

HELP_CPD .WORD   0
	.WORD   COLOR_WHITE
	.WORD   6
	.LONG   CPD_M1
	.LONG   CPD_M2
	.LONG   CPD_M3
	.LONG   CPD_M4
	.LONG   CPD_M5
	.LONG   CPD_M6

HELP_MAX .WORD   0
	.WORD   COLOR_WHITE
	.WORD   6
	.LONG   MC_M1
	.LONG   MC_M2
	.LONG   MC_M3
	.LONG   MC_M4
	.LONG   M_NULL
	.LONG   MC_M5

**************************************************************************
*								         *
* 	 HELP MESSAGES FOR MAIN ADJUSTMENT MENU!			 *
*								         *
**************************************************************************
*
*DIFFICULTY ADJUSTMENT
*
DH_0
	.STRING "THIS CONTROLS THE",0
	.EVEN
DH_1
	.STRING "DIFFICULTY OF COMPUTER",0
        .EVEN
DH_2    
        .string "CONTROLLED PLAYERS."
M_NULL
	.BYTE 0
	.EVEN
DH_3
	.STRING "   EASIEST  SETTING: 1",0
	.EVEN
DH_4
	.STRING "   HARDEST SETTING: 10",0
	.EVEN
DH_5
	.STRING "   ",W_FACSET,":  5",0
	.EVEN

*
*STANDARD PRICING
*
PH_0
	.STRING "SELECT BUILT-IN ",W_PRICING,0
	.EVEN
PH_1
	.STRING "MODE. (",W_COINS," PER ",W_CREDIT,",",0
	.EVEN
PH_2
	.STRING "AND ",W_COIN," SLOT VALUES)",0
	.EVEN


mh_0	 .string "CUSTOMISE THE INTERNAL"
	 .byte 0
	 .even
mh_1	 .string "COIN CHUTE MULTIPLIERS"
	 .byte 0
	 .even
mh_2	 .string "FOR EACH CHUTE."
	 .byte 0
	 .even

DIH_0
	.STRING	"THIS OPTION IS BEING",0
	.EVEN
DIH_1
	.STRING	"ADJUSTED FROM DIPSWITCH",0
	.EVEN
DIH_2
	.STRING	"SETTINGS.",0
	.EVEN


*
*GAME TIMER SPEED ADJUSTMENT
*
MTH_0
	.STRING "THIS CONTROLS HOW",0
	.EVEN
MTH_1
	.STRING "FAST THE ",W_GAME,0
	.EVEN
MTH_2
	.STRING "TIMER COUNTS DOWN.",0
	.EVEN
MTH_4
	.STRING	W_FACSET,": NORMAL",0
     	.EVEN


*
*ATTRACT MODE SOUND
*

HAM_1    .STRING "THIS DETERMINES WHETHER",0
	.EVEN


*
*ALLOW HIGH SCORE ENTRY
*
HSO_2
	.STRING	"THE ",W_GAME," WILL ALLOW",0
	.EVEN
HSO_3
	.STRING	"DISPLAY OF THE HIGH",0
	.EVEN
HSO_4
	.STRING	"SCORE TABLE.",0
	.EVEN
HSO_5
	.STRING W_FACSET,": YES",0
	.EVEN

*
* PAY FOR OVERTIME
*
POT_1    .STRING "AFTER A 3RD PERIOD TIE:"
	.BYTE 0
	.EVEN
POT_2    .STRING "IF YES, PLAYERS PAY FOR A"
	.BYTE 0
	.EVEN
POT_3    .STRING "FULL 4TH PERIOD.  IF NO,"
	.BYTE 0
	.EVEN
POT_4    .STRING "THERE IS FREE SUDDEN DEATH."
	.BYTE 0
	.EVEN
POT_5    .STRING W_FACSET,": NO"
	.BYTE 0
	.EVEN

*
* TOURNAMENT MODE
*
HAH_1    .STRING "IF ON, THIS DISABLES"
	.BYTE 0
	.EVEN
HAH_2    .STRING "POWERUPS, SECRET"
	.BYTE 0
	.EVEN
HAH_3    .STRING "CHARACTERS AND"
	.BYTE 0
	.EVEN
HAH_4    .STRING "COMPUTER ASSISTANCE."
	.BYTE 0
	.EVEN
HAH_5    .STRING W_FACSET,": OFF"
	.BYTE 0
	.EVEN

*
* CHALLENGE MODE
*
CHM_1    .STRING "IF ON, THE WINNING TEAM"
	.BYTE 0
	.EVEN
CHM_2    .STRING "PLAYS THE NEXT GAME FOR"
	.BYTE 0
	.EVEN
CHM_3    .STRING "FREE.  ONLY THE"
	.BYTE 0
	.EVEN
CHM_4    .STRING "CHALLENGING TEAM PAYS."
	.BYTE 0
	.EVEN
CHM_5    .STRING W_FACSET,": ON"
	.BYTE 0
	.EVEN
        

*
*MINIMUM VOLUME
*
HMV_1
	.STRING "THIS IS THE MINIMUM LEVEL",0
	.EVEN
HMV_2
	.STRING "ALLOWED WHEN SETTING THE",0
	.EVEN
HMV_3
	.STRING "VOLUME OF THE SOUND BOARD.",0
	.EVEN
HMV_4
	.STRING W_FACSET,": 31",0
	.EVEN

*
*FREE PLAY
*
FP_M1    .STRING "SETTING ",W_FREE," ",W_PLAY," TO"
	.BYTE 0
	.EVEN
FP_M2    .BYTE   ASCII_DQ
	.STRING "YES"
	.BYTE   ASCII_DQ
	.STRING " ALLOWS UNLIMITED"
	.BYTE 0
	.EVEN
FP_M3    .STRING W_PLAY," WITHOUT INSERTING"
	.BYTE 0
	.EVEN
FP_M4    .STRING "ANY ",W_COINS,"."
	.BYTE 0
	.EVEN

FP_M5
	.STRING W_FACSET,": NO",0
	.EVEN

PP_0     .STRING "ADJUST ",W_PRICING," PARAMETERS"
	.BYTE 0
	.EVEN
PP_1     .STRING "(FOR NON-",W_STANDARD," MODES),"
	.BYTE 0
	.EVEN
PP_2     .STRING W_FREE," ",W_PLAY,", MAXIMUM ",W_CREDITS,","
	.BYTE 0
	.EVEN
PP_3     .STRING W_CREDITS," TO START AND"
	.BYTE 0
	.EVEN
PP_4     .STRING W_CREDITS," TO CONTINUE."
	.BYTE 0
	.EVEN

LC_M1    .STRING W_COINS," INSERTED ACCUMULATE"
	.BYTE 0
	.EVEN
LC_M2    .STRING W_UNITS,".  THIS ",W_ADJUSTMENT
	.BYTE 0
	.EVEN
LC_M3    .STRING "SPECIFIES THE NUMBER OF"
	.BYTE 0
	.EVEN
LC_M4    .STRING W_UNITS," GIVEN FOR EACH"
	.BYTE 0
	.EVEN
LC_M5    .STRING W_COIN," IN THE LEFT ",W_CHUTE,"."
	.BYTE 0
	.EVEN
LC_M6    .STRING "(SEE "
	.BYTE ASCII_DQ
	.STRING W_UNITS," / ",W_CREDIT
	.BYTE ASCII_DQ
	.STRING ")"
	.BYTE 0
	.EVEN
CC_M5    .STRING W_COIN," IN THE THIRD ",W_CHUTE,"."
	.BYTE 0
	.EVEN
RC_M5    .STRING W_COIN," IN THE RIGHT ",W_CHUTE,"."
	.BYTE 0
	.EVEN

C4C_M5    .STRING W_COIN," IN THE FOURTH ",W_CHUTE,"."
	.BYTE 0
	.EVEN

mz_m1	 .string "MODIFY TOTALIZING"    ; 
	 .byte 0
	 .even
mz_m2	 .string "MULTIPLER VALUE FOR"
	 .byte 0
	 .even
mz_c1	 .string "CHUTE 1."
	 .byte 0
	 .even
mz_c2	 .string "CHUTE 2."
	 .byte 0
	 .even
mz_c3	 .string "CHUTE 3."
	 .byte 0
	 .even
mz_c4	 .string "CHUTE 4."
	 .byte 0
	 .even

mr_m1	 .string "IF DIPSW IS SET FOR ONE"
	 .byte 0
	 .even

mr_m2	 .string "COUNTER, THEN YES MEANS"
	 .byte 0
	 .even

mr_m3	 .string "MULTIPLIERS DETERMINE"
	 .byte 0
	 .even

mr_m4	 .string "COIN COUNTER CLICKS."
	 .byte 0
	 .even


mr_m5	 .string "IF NO, YOU GET ONE CLICK"
	 .byte 0
	 .even

mr_m6	 .string "PER COIN ON ANY CHUTE."
	 .byte 0
	 .even

mz_db
        .string "BILL VALIDATOR.",0
        .even
                
dbv_m5	 .string "BILL VALIDATED."
	 .byte 0
	 .even

UC_M1    .STRING "THIS IS THE NUMBER OF ",W_COIN
	.BYTE 0
	.EVEN
UC_M2    .STRING W_UNITS," REQUIRED TO BUY ONE"
	.BYTE 0
	.EVEN
UC_M3    .STRING W_CREDIT,"."
	.BYTE 0
	.EVEN
UB_M1    .STRING "1 BONUS ",W_CREDIT," IS AWARDED"
	.BYTE 0
	.EVEN
UB_M2    .STRING "AFTER THIS MANY ",W_COIN," ",W_UNITS
	.BYTE 0
	.EVEN
UB_M3    .STRING "HAVE ACCUMULATED."
	.BYTE 0
	.EVEN

UM_M1    .STRING "NO ",W_CREDITS," WILL BE AWARDED"
	.BYTE 0
	.EVEN
UM_M2    .STRING "UNTIL THIS MANY ",W_COIN
	.BYTE 0
	.EVEN
UM_M3    .STRING W_UNITS," HAVE ACCUMULATED."
	.BYTE 0
	.EVEN

CS_M1    .STRING "EACH ",W_PLAY,"ER NEEDS THIS"
	.BYTE 0
	.EVEN
CS_M2    .STRING "MANY ",W_CREDITS," TO"
	.BYTE 0
	.EVEN
CS_M3    .STRING "BEGIN ",W_PLAY,"."
	.BYTE 0
	.EVEN

CC_M3    .STRING "CONTINUE A ",W_GAME,"."
	.BYTE 0
	.EVEN

CPD_M1   .STRING "THE DETAILED BOOKKEEPING"
	.BYTE 0
	.EVEN
CPD_M2   .STRING "SCREEN SHOWS TOTAL"
	.BYTE 0
	.EVEN
CPD_M3   .STRING "COLLECTIONS BASED ON THIS"
	.BYTE 0
	.EVEN
CPD_M4   .STRING "MANY ",W_COINS," PER DOLLAR."
	.BYTE 0
	.EVEN
CPD_M5   .STRING "(SET TO ZERO TO DISABLE THE"
	.BYTE 0
	.EVEN
CPD_M6   .STRING "DISPLAY OF MONEY TOTALS.)"
	.BYTE 0
	.EVEN

MC_M1    .STRING "THIS IS THE LIMIT FOR"
	.BYTE 0
	.EVEN
MC_M2    .STRING "THE ",W_CREDITS," COUNTER."
	.BYTE 0
	.EVEN
MC_M3    .STRING "ADDITIONAL ",W_COINS," INSERTED"
	.BYTE 0
	.EVEN
MC_M4    .STRING "WILL BE LOST."
	.BYTE 0
	.EVEN
;MC_M5    .STRING W_FACSET,": 30"
MC_M5    .STRING W_FACSET,": 50"
	.BYTE 0
	.EVEN

*
*	ADJUSTMENT ENUMERATION STRINGS
*
LIST_DIFF
	.LONG   DIFF_1,DIFF_2,DIFF_3,DIFF_4,DIFF_5
	.LONG   DIFF_6,DIFF_7,DIFF_8,DIFF_9,DIFF_10

LIST_OFFON
	.LONG   MESS_OFF,MESS_ON

LIST_CHALLENGE
	.long	MESS_OFF,MESS_4PC,MESS_APC,MESS_PVSP

MESS_4PC
	.STRING "4 PLAYERS",0
	.EVEN
MESS_APC
	.STRING "ALL GAMES",0
	.EVEN
MESS_PVSP
	.STRING	"PLAYER VS PLAYER",0
	.even

LIST_TMRSPD
        .long   M_XSLOW,M_SLOW,M_NORMAL,M_FAST,M_XFAST

M_XSLOW   .STRING "(EXTRA SLOW)",0
	.EVEN
M_SLOW   .STRING "(SLOW)",0
	.EVEN
M_NORMAL   .STRING "(NORMAL)",0
	.EVEN
M_FAST   .STRING "(FAST)",0
	.EVEN
M_XFAST   .STRING "(EXTRA FAST)",0
	.EVEN


LIST_NOYES
	.LONG   M_NO,M_YES

LIST_YESNO
	.LONG   M_YES,M_NO

LIST_DIPNONO
        .long   M_DNO
LIST_DIPNOYES
	.LONG	M_DNO, M_DYES


M_NO
	.STRING "NO",0
	.EVEN
M_YES
	.STRING	"YES",0
	.EVEN
M_DYES
	.STRING	"DIPSWITCH - YES",0
	.EVEN
M_DNO
	.STRING	"DIPSWITCH - NO",0
	.EVEN
MESS_OFF
	.STRING "OFF",0
	.EVEN
MESS_ON
	.STRING "ON",0
	.EVEN


DIFF_1   .STRING "1 (EXTRA EASY)"
	.BYTE   0
	.EVEN
DIFF_2   .STRING "2 (EASIER)"
	.BYTE   0
	.EVEN
DIFF_3   .STRING "3 (EASY)"
	.BYTE   0
	.EVEN
DIFF_4   .STRING "4 (MEDIUM-EASY)"
	.BYTE   0
	.EVEN
DIFF_5   .STRING "5 (MEDIUM)"
	.BYTE   0
	.EVEN
DIFF_6   .STRING "6 (MEDIUM-HARD)"
	.BYTE   0
	.EVEN
DIFF_7   .STRING "7 (HARD)"
	.BYTE   0
	.EVEN
DIFF_8   .STRING "8 (HARDER)"
	.BYTE   0
	.EVEN
DIFF_9   .STRING "9 (EXTRA HARD)"
	.BYTE   0
	.EVEN
DIFF_10  .STRING "10 (EXTRA HARD)"
	.BYTE   0
	.EVEN

M_NOBONUS
	.STRING "NO BONUS ",W_CREDIT,0
	.EVEN

M_NOMIN
	.STRING "NO MINIMUM",0
	.EVEN

M_NO_COL
	.STRING "NO MONEY TOTALS",0
	.EVEN


**************************************************************************
*								         *
* 		MASTER COINAGE TABLES					 *
*								         *
**************************************************************************
CSELCT

**************************************************************************
*											     *
*   USA 1: 1 COIN = 1 CREDIT								     *
* 											     *
*          2 TO START / 2 TO CONTINUE							     *
*											     *
**************************************************************************
	.WORD	1,0,1,0,4,1,0,0,2,2	;WILLY PRICING
	.WORD	4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD	1			;DISPLAY COIN FRACTIONS
	.WORD	1,0,1,0,4			;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	OCOP			;ONE COIN ONE PLAY
	.LONG	USA_1			;TITLE OF COIN MODE
	.LONG	Q_Q		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_NONE		;NO PRICING LINE ON 2/1
	.LONG	USA_QDQ			;QUARTER

**************************************************************************
*											     *
*   USA 2: 1 COIN = 1 CREDIT								     *
* 											     *
*          2 TO START / 1 TO CONTINUE							     *
*											     *
**************************************************************************
	.WORD	1,0,1,0,4,1,0,0,2,1	;WILLY PRICING
	.WORD	4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD	1			;DISPLAY COIN FRACTIONS
	.WORD	1,0,1,0,4			;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	OCOP			;ONE COIN ONE PLAY
	.LONG	USA_2			;TITLE OF COIN MODE
	.LONG	Q_Q		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_NONE		;NO PRICING LINE ON 2/1
	.LONG	USA_QDQ			;QUARTER


**************************************************************************
*											     *
* 	USA 3	 COINAGE IS 25 CENT		 					     *
*		 1 TO START / 1 TO CONTINUE						*
*											     *
**************************************************************************

	.WORD	1,0,1,0,4,1,0,0,1,1	   ;WILLY PRICING
	.WORD	4				;4 COINS PER DOLLAR (FOR CALC)
	.WORD	1				;DISPLAY COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;ONE COIN ONE PLAY
	.LONG	USA_3			 ;TITLE OF COIN MODE
	.LONG	Q_Q			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_NONE		;NO PRICING LINE ON 2/1
	.LONG	USA_QDQ			;QUARTER

**************************************************************************
*											     *
* 	USA 4	 COINAGE IS 50 CENT	 3/$1.00					     *
*		 1 TO START / 1 TO CONTINUE						*
*											     *
**************************************************************************

	.WORD	1,0,1,0,4,2,4,0,1,1     ; WILLY PRICING
	.WORD	4		  	; 4 COINS PER DOLLAR (FOR CALC)
	.WORD	1		  	; DISPLAY COIN FRACTIONS
	.WORD	1,0,1,0,4		   	; COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	; CHARACTER STRINGS.
	.LONG	CSM_LIST		; PRINT THE 2 THE OP SEES
	.LONG	USA_4			; TITLE OF COIN MODE
	.LONG	DOLLAR_3		; 1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			; SHOW LINE 2
	.LONG	USA_QDQ			; QUARTER
						

**************************************************************************
*											     *
*  ADDITION "FULL PRICE" COINAGES							     *
*											     *
**************************************************************************

	.IF	FULLPRICE

**************************************************************************
*											     *
* 	USA 5	 COINAGE IS 50 CENT	 4/$1.00					     *
*		 2 TO START / 1 TO CONTINUE						*
*											     *
**************************************************************************

	.WORD	3,0,3,0,12,4,12,6,2,1	 ;WILLY PRICING
	.WORD	4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD	0				;NO COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;PRINT THE 2 THE OP SEES
	.LONG	USA_5			 ;TITLE OF COIN MODE
	.LONG	DOLLAR_4			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG	USA_QDQ			;QUARTER

*
*	USA 6	 50 PER CREDIT
*
	.WORD	1,0,1,0,4,2,0,0,1,1	; WILLY PRICING
	.WORD	4				;4 COINS PER DOLLAR (FOR CALC)
	.WORD	1				;DISPLAY COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;2 COINS PER PLAYER
	.LONG	USA_6			 ;TITLE OF COIN MODE
	.LONG	F_F_1S1C		 ;2 COINS PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_1			;SHOW LINE 1
	.LONG	USA_QDQ			;QUARTER
*						
*	USA 7	 COINAGE IS 50 CENT	 3/$1.00
*

	.WORD	1,0,1,0,4,2,4,0,1,1     ; WILLY PRICING
	.WORD	4				;4 COINS PER DOLLAR (FOR CALC)
	.WORD	0				;DISPLAY COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;PRINT THE 2 THE OP SEES
	.LONG	USA_7			 ;TITLE OF COIN MODE
	.LONG	UFS3D			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG	USA_QDQ			;QUARTER

*						
*	USA 8	 COINAGE IS 50 CENT	 4/$1.00
*
*	       L, C,R, 4,DBV,U/C,U/B,MINUNITS /START /CONTINUE
	.WORD	3,0,3,0,12,4,12,6,2,2	 ;WILLY PRICING
	.WORD	4				;4 COINS PER DOLLAR (FOR CALC)
	.WORD	0				;NO COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;PRINT THE 2 THE OP SEES
	.LONG	USA_8			 ;TITLE OF COIN MODE
	.LONG	UFS4D			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG	USA_QDQ			;QUARTER

*	USA 9	 COINAGE IS 50 CENT	 4/$1.00
*
*	       L, C,R, 4,DBV,U/C,U/B,MINUNITS /START /CONTINUE
	.WORD	1,0,1,0,4,1,0,1,3,2	 ;WILLY PRICING
	.WORD	4				;4 COINS PER DOLLAR (FOR CALC)
	.WORD	0				;NO COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;PRINT THE 2 THE OP SEES
	.LONG	USA_9			 ;TITLE OF COIN MODE
	.LONG	Q_Q		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG	USA_QDQ			;QUARTER

*	USA 10	 COINAGE IS 50 CENT	 4/$1.00
*
	.WORD	1,0,1,0,4,1,0,1,3,3	 ;WILLY PRICING
	.WORD	4				;4 COINS PER DOLLAR (FOR CALC)
	.WORD	0				;NO COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;PRINT THE 2 THE OP SEES
	.LONG	USA_10			 ;TITLE OF COIN MODE
	.LONG	Q_Q		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG	USA_QDQ			;QUARTER

	.ENDIF
*
*	USA ELECTRONIC
*
	.WORD	20,2,5,1,20,5,0,0,2,2	; L,C,R,4,U/C,U/B,MINUNITS
	.WORD	20			; COINS/DOLLAR
	.WORD	1			; DISPLAY FRACTIONS
	.WORD	20,2,5,1,20		; L,C,R,4
	.LONG	DOLLAR_LEAD,NULL_ST	; CHARACTER STRINGS.
	.LONG	USA_ELECTRONIC		; SPECIAL MESSAGE
	.LONG	USA_ELECTITLE		; TITLE OF COIN MODE
	.LONG	USA_EL			; SETTINGS DESCRIPTION
	.WORD	SHOW_2			; LINES TO SHOW ON
	.LONG	USA_ESLOT		; QUARTER

*
*	GERMAN 1    COINAGE IS 6 PLAYS FOR 5 DM
*			 2 TO START, 2 TO CONTINUE
*
	.WORD	6,0,30,0,0,5,0,0,2,2	 ;WILLY PRICING
	.WORD	1		   	 ;DMS HAVE NO FRACTIONS
	.WORD	0			 ;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,DM_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	GERMAN_1			 ;TITLE OF COIN MODE
	.LONG	DM_6			  ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	GERMAN_15			;1 DM / 5 DM

G1SEL	EQU	($-CSELCT)/CS_SIZE	    ;COIN SELECT VALUE FOR GERMAN 1
*
*	GERMAN 2    COINAGE IS 7 PLAYS FOR 5 DM
*			 2 TO START, 1 TO CONTINUE
*
	.WORD	6,0,30,0,0,5,30,0,2,1		;WILLY PRICING
	.WORD	1				;DMS HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,DM_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	GERMAN_2			 ;TITLE OF COIN MODE
	.LONG	DM_7			  ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	GERMAN_15			;1 DM / 5 DM
*
*	GERMAN 3    COINAGE IS 8 PLAYS FOR 5 DM
*			 2 TO START, 1 TO CONTINUE
*
	.WORD	7,0,35,0,0,5,35,0,2,1		;WILLY PRICING
	.WORD	1				;DMS HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,DM_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	GERMAN_3			 ;TITLE OF COIN MODE
	.LONG	DM_8			  ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	GERMAN_15			;1 DM / 5 DM
*
*	GERMAN 4    COINAGE IS 5 PLAYS FOR 5 DM
*			 2 TO START, 1 TO CONTINUE
*
	.WORD	1,0,5,0,0,1,0,0,2,1	   ;WILLY PRICING
	.WORD	1				;DMS HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,DM_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	GERMAN_4			 ;TITLE OF COIN MODE
	.LONG	DM_5			  ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	GERMAN_15			;1 DM / 5 DM

*
*	GERMAN 5    COINAGE IS 6 PLAYS FOR 5 DM
*			 2 TO START, 1 TO CONTINUE
*
	.WORD	6,0,30,0,0,5,0,0,2,1	 ;WILLY PRICING
	.WORD	1		   	 ;DMS HAVE NO FRACTIONS
	.WORD	0			 ;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,DM_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	GERMAN_5			 ;TITLE OF COIN MODE
	.LONG	DM_6			  ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	GERMAN_15			;1 DM / 5 DM

*
*	GERMAN ELECTRONIC
*			 2 TO START, 2 TO CONTINUE
*
	.WORD	60,12,24,0,0,10,0,0,2,2	; L,C,R,4,U/C,U/B,MINUNITS
	.WORD	1			; COINS/DOLLAR
	.WORD	0			; DISPLAY FRACTIONS
	.WORD	5,1,2,0,0			; L,C,R,4
	.LONG	NULL_ST,DM_TRAIL	;CHARACTER STRINGS.
	.LONG	GERMAN_ELECTRONIC	; SPECIAL MESSAGE
	.LONG	GERMAN_ELECTITLE	; TITLE OF COIN MODE
	.LONG	DM112265		; SETTINGS DESCRIPTION
	.WORD	SHOW_3			; LINES TO SHOW ON
	.LONG	GERMAN_ESLOT		; QUARTER

****************************************************************************
****************************************************************************
*******	THE FOLLOWING NUMBERS ARE FIGURED FOR THE FRENCH SETTINGS
*******	REQUESTED BY DIMITRI K. OF P.S.D.
*******
*******			 	1F   5F   10F   U/C   U/B  M/U
*******				--------------------------------
*******	1/2F  3/5F    7/10F	3	15	 30	  5	  30    0
*******	1/3F  2/5F    5/10F	2	10	 20	  5	  20    0
*******	1/5F  3/10F		1	 5	 10    5    10    0
*******	1/5F  3/10F   7/20F	3	15	 30	 10	  60   15
*******	2/5F  4/10F   9/20F	2	10	 20	  5	  40   10
*******	2/5F  5/10F  11/20F	1	 5	 10	  2	  20    5
*******
*
*
*	FRENCH 1	      2/5F	 5/10F
*
*
	.WORD	2,0,4,0,0,1,4,0,2,2		; 2/5F    5/10F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST			;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_1			;TITLE OF COIN MODE
	.LONG	FIVE_10				;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	FRENCH510

F1SEL	EQU	($-CSELCT)/CS_SIZE	    ;COIN SELECT VALUE FOR FRENCH 1

*
*	FRENCH 2	      2/5F	 4/10F
*
*
	.WORD	2,0,4,0,0,1,0,0,2,1	   ; 2/5F    4/10F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_2			 ;TITLE OF COIN MODE
	.LONG	FOUR_10			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	FRENCH510
*
*	FRENCH 3	      1/5F  3/10F	
*
*
	.WORD	1,0,2,0,0,1,2,0,2,1	    ;1/5F  3/10F	
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_3			 ;TITLE OF COIN MODE
	.LONG	THREE_10			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	FRENCH510
*
*	FRENCH 4	      1/5F  2/10F 
*
*
	.WORD	1,0,2,0,0,1,0,0,2,1	 ;1/5F  2/10F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_4			 ;TITLE OF COIN MODE
	.LONG	TWO_10			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_1
	.LONG	FRENCH510

	.IF	FULLPRICE

*
*
*	FRENCH 5	      2/5F	 5/10F	11/2 X 10F
*
*
	.WORD	5,0,10,0,0,2,20,0,2,1		 ;2/5F  5/10F	11/20F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_5			 ;TITLE OF COIN MODE
	.LONG	FIVE_10_11		    ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_3			;USE LINE 3 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH510
*
*	FRENCH 6	      2/5F	 4/10F	9/2 X 10F
*
*
	.WORD	2,0,4,0,0,1,8,0,2,1		   ;2/5F	4/10F   9/20F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_6			 ;TITLE OF COIN MODE
	.LONG	FOUR_10_9			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_3			;USE LINE 3 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH510
*
*	FRENCH 7	      1/5F	 3/10F	7/2 X 10F
*
*
	.WORD	3,0,6,0,0,2,12,0,2,1		  ;1/5F  3/10F   7/20F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_7			 ;TITLE OF COIN MODE
	.LONG	THREE_10_7		    ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_3			;USE LINE 3 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH510
*
*	FRENCH 8	      1/5F	 2/10F	5/2 X 10F
*
*
	.WORD	1,0,2,0,0,1,4,0,2,1		   ;1/5F	2/10F  5/20F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_8			 ;TITLE OF COIN MODE
	.LONG	TWO_10_5			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_3			;USE LINE 3 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH510

*
*	FRENCH 9	      1/3 X 1F	  2/5F
*
*	COIN SLOTS ARE	1F -- 5F
*
*
	.WORD	2,0,10,0,0,5,0,0,2,1		  ;1/3X1F  2/5F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_9			 ;TITLE OF COIN MODE
	.LONG	F1325			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;USE LINE 2 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH1F5F
*
*	FRENCH 10	      1/2 X 1F	  3/5F
*
*	COIN SLOTS ARE	1F -- 5F
*
*
	.WORD	3,0,15,0,0,5,0,0,2,1		  ;1/2X1F  3/5F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_10			;TITLE OF COIN MODE
	.LONG	F1235			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;USE LINE 2 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH1F5F
*
*	FRENCH 11	      1/3 X 1F	  2/5F	5/2 X 5F
*
*	COIN SLOTS ARE	1F -- 5F
*
*
	.WORD	2,0,10,0,0,5,20,0,2,1		 ;1/3X1F	2/5F  5/10F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_11			;TITLE OF COIN MODE
	.LONG	F13255			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_3			;USE LINE 2 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH1F5F

*
*	FRENCH 12	      1/2 X 1F	  3/5F	  7 / 2 X 5F
*
*	COIN SLOTS ARE	1F -- 5F
*
*
	.WORD	3,0,15,0,0,5,30,0,2,1		 ;1/2X1F	3/5F  7/10F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_12			;TITLE OF COIN MODE
	.LONG	F12355			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_3			;USE LINE 2 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH1F5F

	.ENDIF

*
*	FRANCE ELECTRONIC
*
	.WORD	1,15,6,0,0,3,0,0,2,2	; L,C,R,4,U/C,U/B,MINUNITS
	.WORD	1			; COINS/DOLLAR
	.WORD	0			;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,10,5,0,0		; L,C,R,4
	.LONG	NULL_ST,FRANC_TRAIL	; CHARACTER STRINGS.
	.LONG	FRANCE_ELECTRONIC	; SPECIAL MESSAGE
	.LONG	FRENCH_ELECTITLE	; TITLE OF COIN MODE
	.LONG	FR_ECA			;COIN PAGE DESCRIPTION
	.WORD	SHOW_3			;THREE LINES FOR THIS BABY
	.LONG	FRANCE_ESLOT		; QUARTER

*
*	CANADA    COINAGE IS 50 CENT   3/$1.00
*
	.WORD   1,0,4,0,4,2,4,0,2,2    ;WILLY PRICING
	.WORD	4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD	1			;DISPLAY COIN FRACTIONS
	.WORD	1,0,4,0,4			;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	CSM_LIST		;PRINT THE 2 THE OP SEES
	.LONG   CANADA			;TITLE OF COIN MODE
	.LONG	CAN_1503D		;1 PLAY 50, 3 FOR A DOLLAR
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG   CAN_QD			;QUARTER

	.IF	FULLPRICE

*	SWISS 1    COINAGE IS 6 PLAYS FOR 5 FRANC

	.WORD	6,0,30,0,0,5,0,0,2,2		 ;WILLY PRICING
	.WORD	1				;FRANCS HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SWISS_1			;TITLE OF COIN MODE
	.LONG	SFRANC_6			 ;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_2
	.LONG	SWISS15

*	SWISS 2    COINAGE IS 7 PLAYS FOR 5 FRANC

	.WORD	6,0,30,0,0,5,30,0,2,2		;WILLY PRICING
	.WORD	1				;FRANCS HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SWISS_2			;TITLE OF COIN MODE
	.LONG	SFRANC_7			 ;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_2
	.LONG	SWISS15

*	SWISS 3     COINAGE IS 8 PLAYS FOR 5 FRANC

	.WORD	7,0,35,0,0,5,35,0,2,2		;WILLY PRICING
	.WORD	1				;FRANCS HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
	.WORD	1,0,5,0,0				;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SWISS_3				;TITLE OF COIN MODE
	.LONG	SFRANC_8			;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_2
	.LONG	SWISS15

*	ITALY COINAGE IS 1 PLAYS FOR 500 LIRE

	.WORD	1,0,1,0,0,1,0,0,2,2		;WILLY PRICING
	.WORD	1				;LIRE HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
;	.WORD	500,0,500,0,0			 ;COIN VALUE
	.WORD	1,0,1,0,0			 ;COIN VALUE
	.LONG	NULL_ST,LIRE_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	ITALY_1			;TITLE OF COIN MODE
	.LONG	P1500L			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	ITALYLIRE

*	U.K. ELECTRONIC 1

*	CENTER = 20P  XTRA = 10P  LEFT = 1P  RIGHT = 50P
*	1 PLAY / 50 P
*	3 PLAY / 1 POUND

*		 L, C,	R, 4,DBV,U/C,U/B,MINUNITS /START /CONTINUE
	.WORD	10, 2, 5, 1, 0, 5,  10,0,1,1		;NUMBERS FOR 1L/20P/50P/10P
	.WORD	10					;PENCE SUCK!
	.WORD	0					;DON'T DISPLAY COIN FRACTIO
	.WORD	10,2,5,1,0				;COIN VALUE
	.LONG	NULL_ST,POUND_TRAIL	;CHARACTER STRINGS.
	.LONG	UK_ELECTRONIC1				;SPECIAL TITLE W/ POUND
	.LONG	UK_1					;TITLE OF COIN MODE
	.LONG	UK_420					;
	.WORD	SHOW_2
	.LONG	UK_ELEC

*	U.K. ELECTRONIC 2  (CCU)

*	CREDITS ARE AWARDED 1 COIN / 1 PLAY.....

*	CCU ACCUMULATES 4 COINS AND STROKES US AS FOLLOWS:

*	1 PLAY / 50 P
*	2 PLAY / 1 POUND

*		 L, C,	R, 4,DBV,U/C,U/B,MINUNITS /START /CONTINUE
	.WORD	10, 2, 5, 1, 0, 5,  0,0,1,1		;NUMBERS FOR 1L/20P/50P/10P
	.WORD	10				;PENCE ARE FRACTIONS!
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
	.WORD	10,2,5,1,0				;COIN VALUE
	.LONG	NULL_ST,COINS_TRAIL	   ;CHARACTER STRINGS.
	.LONG	UK_ELECTRONIC2		 ;SPECIAL TITLE W/ POUND
	.LONG	UK_2			  ;TITLE OF COIN MODE
	.LONG	UK_320			;
	.WORD	SHOW_2
	.LONG	UK_ELEC

*	U.K. 3	 COINAGE IS 1 PLAY FOR 30P   2 FOR 50P  5 FOR 1.00

	.WORD	20,4,10,2,0,5,20,0,1,1	;WILLY PRICING
	.WORD	10			;PENCE ARE FRACTIONS!
	.WORD	0			;DON'T DISPLAY COIN FRACTIO
	.WORD	10,2,5,1,0				;COIN VALUE
	.LONG	NULL_ST,POUND_TRAIL	;CHARACTER STRINGS.
	.LONG	UK_ELECTRONIC3		 ;SPECIAL TITLE W/ POUND
	.LONG	UK_3			;TITLE OF COIN MODE
	.LONG	UK_120			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	UK_ELEC

*	U.K. 4  

	.WORD	10, 0, 5, 0, 0, 5,  10,0,1,1		;NUMBERS FOR 1L/20P/50P/10P
	.WORD	10					;PENCE SUCK!
	.WORD	0					;DON'T DISPLAY COIN FRACTIO
	.WORD	10,0,5,0,0				;COIN VALUE
	.LONG	NULL_ST,POUND_TRAIL	;CHARACTER STRINGS.
	.LONG	UK_ELECTRONIC1
	.LONG	UK_4					;TITLE OF COIN MODE
	.LONG	UK_220					;
	.WORD	SHOW_2
	.LONG	UK2050

*	U.K. 5  


*	1 PLAY / 50 P
*	2 PLAY / 1 POUND

*		 L, C,	R, 4,DBV,U/C,U/B,MINUNITS /START /CONTINUE
	.WORD	10, 0, 5, 0, 0, 5,  0,0,1,1		;NUMBERS FOR 1L/20P/50P/10P
	.WORD	10				;PENCE ARE FRACTIONS!
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
	.WORD	10,0,5,0,0				;COIN VALUE
	.LONG	NULL_ST,COINS_TRAIL	   ;CHARACTER STRINGS.
	.LONG	UK_ELECTRONIC2
	.LONG	UK_5			  ;TITLE OF COIN MODE
	.LONG	UK_520			;
	.WORD	SHOW_2
	.LONG	UK2050

*	DONE BECAUSE WE LEARNED SOME NEW SPANISH SHIT!

*	SPAIN 1     1 PLAY / 100 PESETA   6 PLAY / 500 PESETA

	.WORD	1,0,5,0,0,1,5,0,2,2		;WILLY PRICING
	.WORD	1				;NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
	.WORD	1,0,5,0,0			;COIN VALUE
	.LONG	NULL_ST,PESETA_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SP_1				;TITLE OF COIN MODE
	.LONG	SP_5100				;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	PESETA100


*	SPAIN 2     1 PLAY / 25 PESETA   5 PLAY / 100 PESETA

	.WORD	1,0,5,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
	.WORD	1,0,5,0,0			;COIN VALUE
	.LONG	NULL_ST,PESETA_TRAIL	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SP_2			  ;TITLE OF COIN MODE
	.LONG	SP_4100			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	PESETA100


*	AUSTRALIA 1   1 PLAY / 3 X 20 CENTS	2 FOR $1.00

	.WORD	2,0,10,0,0,5,0,0,2,2		  ;WILLY PRICING
	.WORD	5				;DOLLARS
	.WORD	0				;DON'T SHOW FRACTIONS FOR T
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	AUS_1			 ;TITLE OF COIN MODE
	.LONG	AU_60			 ;1 COIN PER CREDIT (SERIES OF S
	.WORD	SHOW_2
	.LONG	AUST20C
*
*	AUSTRALIA 2   1 PLAY / $1.00    2 PLAYS FOR $2.00
*
	.WORD	1,0,5,0,0,5,0,0,1,1	 ; WILLY PRICING
	.WORD	5			 ; DOLLARS
	.WORD	1			 ; SHOW FRACTIONS FOR THE 3 C
	.WORD	1,0,5,0,0			 ; COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	 ; CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	AUS_2			 ; TITLE OF COIN MODE
	.LONG	AU_100			 ; 1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	AUST20C

	.ENDIF

*	JAPAN 1  1 PLAY / 100 YEN

	.WORD	1,0,1,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	1,0,1,0,0		   ;COIN VALUE
	.LONG	NULL_ST,YEN_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	JAP_1			 ;TITLE OF COIN MODE
	.LONG	JAP_100			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	YEN100

	.IF	FULLPRICE
*	JAPAN 2  2 PLAY / 100 YEN

	.WORD	2,0,2,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	1,0,1,0,0		   ;COIN VALUE
	.LONG	NULL_ST,YEN_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	JAP_2			 ;TITLE OF COIN MODE
	.LONG	JAP_200			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	YEN100

*	AUSTRIA  1   1 PLAY / 5 SCHILLING  2 PLAY / 10 SCHILLING

	.WORD	1,0,2,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	5,0,10,0,0			;COIN VALUE
	.LONG	NULL_ST,SHILL_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	ASTA_1			 ;TITLE OF COIN MODE
	.LONG	ASTA_15			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	SHILL510

*	AUSTRIA  2   1 PLAY / 2 X 5 SCHILLING	3 PLAY / 10 SCHILLING

	.WORD	1,0,2,0,0,2,4,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	5,0,10,0,0			;COIN VALUE
	.LONG	NULL_ST,SHILL_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	ASTA_2			 ;TITLE OF COIN MODE
	.LONG	ASTA_10			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	SHILL510

*	BELGIUM 1  1 PLAY / 20F

	.WORD	1,0,1,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	4,0,4,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	BEL_1			 ;TITLE OF COIN MODE
	.LONG	BEL_120			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	FRANC20

*	BELGIUM 2  3 PLAY / 20F

	.WORD	3,0,3,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	4,0,4,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	BEL_2			 ;TITLE OF COIN MODE
	.LONG	BEL_320			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	FRANC20

*	BELGIUM 3  2 PLAY / 20F

	.WORD	2,0,2,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	4,0,4,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	BEL_3			 ;TITLE OF COIN MODE
	.LONG	BEL_220			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	FRANC20

*
*	BELGIUM ELECTRONIC
*
	.WORD	10,1,4,0,0,4,0,0,2,2		; L,C,R,4,U/C,U/B,MINUNITS
	.WORD	1			; COINS/DOLLAR
	.WORD	1			; DISPLAY FRACTIONS
	.WORD	10,1,4,0,0		; L,C,R,4
	.LONG	NULL_ST,FRANC_TRAIL		 ;CHARACTER STRINGS.
	.LONG	BELGIUM_ELECTRONIC		; SPECIAL MESSAGE
	.LONG	BELGIUM_ELECTITLE		; TITLE OF COIN MODE
	.LONG	BEL_ELEC			; SETTINGS DESCRIPTION
	.WORD	SHOW_2			; LINES TO SHOW ON
	.LONG	BELGIUM_ESLOT		; QUARTER

*	SWEDEN	1 PLAY / 3 X 1 KRONA   2 PLAY	5 KRONA

	.WORD	2,0,10,0,0,5,0,0,2,2		 ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,KRONA_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SWED_1			;TITLE OF COIN MODE
	.LONG	SWED_2X5			 ;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_1
	.LONG	KRONA5

*	NEW ZEALAND 1	1 PLAY / 3 X 20 CENT

	.WORD	1,0,1,0,0,3,0,0,1,1		   ;WILLY PRICING
	.WORD	5				;FIVE PER
	.WORD	1				;SHOW FRACTIONS
	.WORD	1,0,1,0,0			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	NZ_1			  ;TITLE OF COIN MODE
	.LONG	NZ_13			 ;1 COIN PER CREDIT (SERIES OF S
	.WORD	SHOW_1
	.LONG	NZ20


*	NEW ZEALAND 2	1 PLAY / 2 X 20 CENT

	.WORD	1,0,1,0,0,2,0,0,1,1		   ;WILLY PRICING
	.WORD	5				;FIVE PER
	.WORD	1				;SHOW FRACTIONS
	.WORD	1,0,1,0,0			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	NZ_2			  ;TITLE OF COIN MODE
	.LONG	NZ_12			 ;1 COIN PER CREDIT (SERIES OF S
	.WORD	SHOW_1
	.LONG	NZ20

*	NETHERLANDS	1 PLAY / 1 HFL.	3 PLAY / 2.5 HFL.

	.WORD	1,0,3,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;FIVE PER
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	2,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,HFL_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	NETH			  ;TITLE OF COIN MODE
	.LONG	NETH_HF			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	HFSLOT


*	FINLAND	1 PLAY / 1 MARKKA

	.WORD	1,0,1,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;FIVE PER
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	1,0,1,0,0			 ;COIN VALUE
	.LONG	NULL_ST,MARKKA_TRAIL	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	FINLAND			;TITLE OF COIN MODE
	.LONG	FINMKA			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	MKSLOT

*	NORWAY	1 PLAY / 2 X 1 KRONE    3/ 5 X 1 KRONE

	.WORD	3,0,3,0,0,5,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;FIVE PER
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	1,0,1,0,0			 ;COIN VALUE
	.LONG	NULL_ST,KRONE_TRAIL	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	NORWAY			;TITLE OF COIN MODE
	.LONG	KR_LIST			 ;1 COIN PER CREDIT (SERIES OF STRI
	.WORD	SHOW_2
	.LONG	NKRSLOT

*	DENMARK	1 PLAY / 2 X 1 KRONE    3/ 5 KRONE	  7 / 10 KRONE

	.WORD	3,0,15,0,0,5,30,0,2,2		 ;WILLY PRICING
	.WORD	1				;FIVE PER
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,KRONE_TRAIL	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	DENMARK			;TITLE OF COIN MODE
	.LONG	DKR_LIST			 ;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_3
	.LONG	DKRSLOT


*	ANTILLES      1 PLAY / 25 CENTS	4 PLAYS / 1 GUILDER

	.WORD	1,0,4,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	4				;FIVE PER
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	1,0,4,0,0			 ;COIN VALUE
	.LONG	NULL_ST,GUILDER_TRAIL	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	ANTILLES			 ;TITLE OF COIN MODE
	.LONG	ANT_LIST			 ;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_1
	.LONG	ANTSLOT

*	HUNGARY     1 CREDIT / 2X10 FORINT  3 CREDITS / 2X20 FORINT

	.WORD	1,0,2,0,0,2,4,0,2,2		;WILLY PRICING
	.WORD	1				;1 TO 1
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	1,0,2,0,0			;COIN VALUE
	.LONG	NULL_ST,FORINT_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	HUNGARY				;TITLE OF COIN MODE
	.LONG	HUNG_LIST			 ;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_1
	.LONG	HUNGSLOT

	.ENDIF


CS_ENTS  EQU     ($-CSELCT)/CS_SIZE	    ;NUMBER OF ENTRIES IN TABLE


;
;	DIP SWITCH TABLES
;

USABASE	EQU	1
GERBASE	EQU	G1SEL
FRABASE	EQU	F1SEL

	.IF	FULLPRICE

USADIP	.WORD	USABASE+0, USABASE+1, USABASE+2, USABASE+3, USABASE+10
	.WORD	USABASE+8, USABASE+9

GERDIP	.WORD	GERBASE+0, GERBASE+1, GERBASE+2, GERBASE+3, GERBASE+5
	.WORD	GERBASE+4, GERBASE+5

FRADIP	.WORD	FRABASE+0, FRABASE+1, FRABASE+2, FRABASE+3, FRABASE+12
	.WORD	FRABASE+10, FRABASE+11

	.ELSE

USADIP	.WORD	USABASE+0, USABASE+1, USABASE+2, USABASE+3, USABASE+4
	.WORD	USABASE+4, USABASE+4

GERDIP	.WORD	GERBASE+0, GERBASE+1, GERBASE+2, GERBASE+3, GERBASE+4
	.WORD	GERBASE+4, GERBASE+4

FRADIP	.WORD	FRABASE+0, FRABASE+1, FRABASE+2, FRABASE+3, FRABASE+4
	.WORD	FRABASE+4, FRABASE+4

	.ENDIF


DIPCOINTAB	.LONG	USADIP, GERDIP, FRADIP, USADIP



**************************************************************************
*									*
*	 COLLECTION MESSAGES					  *
*									*
**************************************************************************
ME_ZERO
	.STRING "0",0
	.EVEN

ME_DECIMAL
	.STRING	".",0
	.EVEN

ME_COLON
	.STRING ":",0
	.EVEN

DOLLAR_LEAD
	.STRING	"$  "
NULL_ST
	.BYTE   0
	.EVEN

POUND_LEAD
	.STRING	FONT_EPOUND,"  ",0
	.EVEN
POUND_TRAIL
	.string	"  PND",0
	.even

DM_TRAIL
	.STRING "  DM",0
	.EVEN

FRANC_TRAIL
	.STRING	"  FRANC",0
	.EVEN

LIRE_TRAIL
	.STRING	"  LIRE",0
	.EVEN

PESETA_TRAIL
	.STRING	"  PESETA",0
	.EVEN

YEN_TRAIL
	.STRING "  YEN",0
	.EVEN

	.IF	FULLPRICE

SHILL_TRAIL
	.STRING "  SCHILLINGS"
	.BYTE   0
	.EVEN

KRONA_TRAIL
	.STRING "  KRONA"
	.BYTE   0
	.EVEN

COINS_TRAIL
	.STRING "  ",W_COINS
	.BYTE   0
	.EVEN

HFL_TRAIL
	.STRING "  HFI."
	.BYTE   0
	.EVEN

MARKKA_TRAIL
	.STRING "  MARKKA"
	.BYTE   0
	.EVEN

KRONE_TRAIL
	.STRING "  KRONE"
	.BYTE 0
	.EVEN

GUILDER_TRAIL
	.STRING "  GUILDER"
	.BYTE 0
	.EVEN

FORINT_TRAIL
	.STRING	"  FT",0
        .EVEN

	.endif


*
*	FOR THE COINAGE ADJUSTMENT MODE:
*
*
*	THIS SET IS TITLES FOR THE CANNED MODES.
*


USA_1	.STRING "USA 1",0
	.EVEN
USA_2	.STRING "USA 2",0
	.EVEN
USA_3	.STRING "USA 3",0
	.EVEN
USA_4	.STRING "USA 4",0
	.EVEN

	.IF	FULLPRICE
USA_5	.STRING "USA 5",0
	.EVEN
USA_6	.STRING "USA 6",0
	.EVEN
USA_7	.STRING "USA 7",0
	.EVEN
USA_8	.STRING "USA 8",0
	.EVEN
* JAKE START
USA_9	.STRING "USA 9",0
	.EVEN
USA_10	.STRING "USA 10",0
	.EVEN
* JAKE END
	.ENDIF

USA_ELECTITLE
	.STRING	"USA ECA",0
	.EVEN

FRENCH_ELECTITLE
	.STRING	"FRANCE ECA",0
	.EVEN

GERMAN_ELECTITLE
	.STRING	"GERMAN ECA",0
	.EVEN

* JAKE START
BEL_ELECTITLE
	.STRING	"BELGUIM ECA",0
	.EVEN
* JAKE END

GERMAN_1 .STRING "GERMAN 1",0
	.EVEN
GERMAN_2 .STRING "GERMAN 2",0
	.EVEN
GERMAN_3 .STRING "GERMAN 3",0
	.EVEN
GERMAN_4 .STRING "GERMAN 4",0
	.EVEN
GERMAN_5 .STRING "GERMAN 5",0
	.EVEN

FRENCH_1 .STRING "FRANCE 1",0
	.EVEN
FRENCH_2 .STRING "FRANCE 2",0
	.EVEN
FRENCH_3 .STRING "FRANCE 3",0
	.EVEN
FRENCH_4 .STRING "FRANCE 4",0
	.EVEN

	.IF	FULLPRICE
FRENCH_5 .STRING W_FRANCE," 5",0
	.EVEN
FRENCH_6 .STRING W_FRANCE," 6",0
	.EVEN
FRENCH_7 .STRING W_FRANCE," 7",0
	.EVEN
FRENCH_8 .STRING W_FRANCE," 8",0
	.EVEN
FRENCH_9 .STRING "FRANCE 9",0
	.EVEN
FRENCH_10 .STRING "FRANCE 10",0
	.EVEN
FRENCH_11 .STRING "FRANCE 11",0
	.EVEN
FRENCH_12 .STRING "FRANCE 12",0         ; 
	.EVEN

CANADA
	.STRING	"CANADA",0
	.EVEN

SWISS_1 .STRING "SWISS 1"
	.BYTE	0
	.EVEN
SWISS_2 .STRING "SWISS 2"
	.BYTE	0
	.EVEN
SWISS_3 .STRING "SWISS 3"
	.BYTE	0
	.EVEN
ITALY_1 .STRING "ITALY"
	.BYTE	0
	.EVEN

UK_1	.STRING "U.K. 1 ECA"
	.BYTE	0
	.EVEN
UK_2	.STRING "U.K. 2 ECA"
	.BYTE	0
	.EVEN
UK_3	.STRING "U.K. 3 ECA"
	.BYTE	0
	.EVEN
UK_4	.STRING "U.K. 4"
	.BYTE	0
	.EVEN
UK_5	.STRING "U.K. 5"
	.BYTE	0
	.EVEN

SP_1	.STRING "SPAIN 1"
	.BYTE	0
	.EVEN
SP_2	.STRING "SPAIN 2"
	.BYTE	0
	.EVEN
AUS_1	.STRING "AUSTRALIA 1"
	.BYTE	0
	.EVEN
AUS_2	.STRING "AUSTRALIA 2"
	.BYTE	0
	.EVEN
	.ENDIF

JAP_1	.STRING "JAPAN 1"
	.BYTE	0
	.EVEN

	.IF	FULLPRICE
JAP_2	.STRING "JAPAN 2"
	.BYTE	0
	.EVEN
ASTA_1	.STRING "AUSTRIA 1"
	.BYTE	0
	.EVEN
ASTA_2	.STRING "AUSTRIA 2"
	.BYTE	0
	.EVEN
BEL_1	.STRING "BELGIUM 1"
	.BYTE	0
	.EVEN
BEL_2	.STRING "BELGIUM 2"
	.BYTE	0
	.EVEN
BEL_3	.STRING "BELGIUM 3"
	.BYTE	0
	.EVEN
BELGIUM_ELECTITLE
	.STRING	"BELGIUM ECA",0
	.EVEN
SWED_1	.STRING "SWEDEN"
	.BYTE	0
	.EVEN
NZ_1	.STRING "NEW ZEALAND 1"
	.BYTE	0
	.EVEN
NZ_2	.STRING "NEW ZEALAND 2"
	.BYTE	0
	.EVEN
NETH	.STRING "NETHERLANDS"
	.BYTE	0
	.EVEN

FINLAND	.STRING "FINLAND"
	.BYTE 0
	.EVEN

NORWAY	.STRING "NORWAY"
	.BYTE 0
	.EVEN

DENMARK	.STRING "DENMARK"
	.BYTE 0
	.EVEN

ANTILLES .STRING "ANTILLES"
	.BYTE 0
	.EVEN

HUNGARY
	.STRING "HUNGARY",0
	.EVEN

	.ENDIF
*
*	THIS SECTION IS A POINTER TO STRING LISTS
*	FOR THE "CURRENT SETTING" BOX.
*
USA_EL
	.LONG	EC1
	.LONG	DOLL4
	.LONG	0
*
*	1 COIN / 1 CREDIT
Q_Q
	.LONG	C11		 ;THIS POINTS AT MESSAGE
	.LONG	0		   ;THIS ENDS LIST
*
*	2 COINS / 1 CREDIT
*
F_F_1S1C
	.LONG	C21
	.LONG	0

*************************************************************************


*
*	2 COINS / 1 CREDIT
*	4 COINS / 3 CREDITS
*
DOLLAR_3 .LONG	C21
	.LONG	C43
	.LONG	0
*
*	2 COINS / 1 CREDIT
*	4 COINS / 4 CREDITS
*
DOLLAR_4 .LONG	C21
	.LONG	C44
	.LONG	0


********************************************************************


	.IF	FULLPRICE

U1Q4D	.LONG	C11		 ;THIS POINTS AT MESSAGE
	.LONG	DOLL4		;4 FOR A DOLLAR
	.LONG	0

;UFS2D	.LONG	C21		; THIS POINTS AT MESSAGE
;	.LONG	DOLL2		; 2 FOR A DOLLAR
;	.LONG	0

UFS3D	.LONG	C21		 ;THIS POINTS AT MESSAGE
	.LONG	DOLL3		;3 FOR A DOLLAR
	.LONG	0

UFS4D	.LONG	C21		 ;THIS POINTS AT MESSAGE
	.LONG	DOLL4		;4 FOR A DOLLAR
	.LONG	0

	.ENDIF

*
*	1 PLAY 1/DM
*	5 PLAY 5/DM
*
DM_5	.LONG	DM11
	.LONG	DM55
	.LONG	0

DM_6	.LONG	DM11
	.LONG	DM65
	.LONG	0

DM_7	.LONG	DM11
	.LONG	DM75
	.LONG	0

DM_8	.LONG	DM11
	.LONG	DM85
	.LONG	0

DM112265
	.LONG	DM11
	.LONG	DM22
	.LONG	DM65
	.LONG	0

SFRANC_6     .LONG   SFRANC11
	.LONG	SFRANC65
	.LONG	0

CAN_1503D
	.LONG   C15		;THIS POINTS AT MESSAGE
	.LONG   DOLL3		;3 FOR A DOLLAR
	.LONG   0

SFRANC_7     .LONG   SFRANC11
	.LONG	SFRANC75
	.LONG	0

SFRANC_8     .LONG   SFRANC11
	.LONG	SFRANC85
	.LONG	0
*
*	2 PLAYS 5F / 5 PLAYS 10F
*
FIVE_10	.LONG	F25
	.LONG	F510
	.LONG	0

FIVE_10_11
	.LONG	F25
	.LONG	F510
	.LONG	F1120
	.LONG	0

FOUR_10	.LONG	F25
	.LONG	F410
	.LONG	0

FOUR_10_9
	.LONG	F25
	.LONG	F410
	.LONG	F4109
	.LONG	0

THREE_10 .LONG	F15
	.LONG	F310
	.LONG	0

THREE_10_7
	.LONG	F15
	.LONG	F310
	.LONG	F4107
	.LONG	0

TWO_10	.LONG	F15
	.LONG	F210
	.LONG	0

TWO_10_5 .LONG	F15
	.LONG	F210
	.LONG	F4105
	.LONG	0

F1325	.LONG	F3X1F
	.LONG	F2F5
	.LONG	0

F13255	.LONG	F3X1F
	.LONG	F2F5
	.LONG	F52X5
	.LONG	0

FR_ECA	.LONG	F3X1F
	.LONG	F2F5
	.LONG	F5X10F
	.LONG	0

F1235	.LONG	F2X1F
	.LONG	F3F5
	.LONG	0

F12355	.LONG	F2X1F
	.LONG	F3F5
	.LONG	F72X5
	.LONG	0

	.IF	FULLPRICE

*	500 LIRE

P1500L	.LONG	P1500L_P
	.LONG	0

*	1 PLAY / 20 P	 3 PLAYS 50 P

UK_120	.LONG	UK_1201
	.LONG	UK_1202
	.LONG	UK_1203
	.LONG	0

;UK_220	.LONG	UK_2201
;	.LONG	UK_2202
;	.LONG	0

UK_520
UK_320	.LONG	UK_3201
;	.LONG	UK_3202
	.LONG	UK_3203
	.LONG	0

UK_220
UK_420	.LONG	UK_4201
	.LONG	UK_4202
;	.LONG	UK_4203
	.LONG	0

SP_4100	.LONG	SP_11
	.LONG	SP_44
	.LONG	0

SP_5100	.LONG	SP_11
	.LONG	SP_54
	.LONG	0

AU_60	.LONG	AU_36
	.LONG	AU_2D
	.LONG	0

AU_100	.LONG	AU_520
	.LONG	AU_1D
	.LONG	0

	.ENDIF

JAP_100	.LONG	JAP_101
	.LONG	0

	.IF	FULLPRICE

JAP_200	.LONG	JAP_201
	.LONG	0

ASTA_10	.LONG	ASTA101
	.LONG	ASTA102
	.LONG	0

ASTA_15	.LONG	ASTA151
	.LONG	ASTA152
	.LONG	0

BEL_120	.LONG	BEL_1201
	.LONG	0
BEL_220	.LONG	BEL_2201
	.LONG	0
BEL_320	.LONG	BEL_3201
	.LONG	0
BEL_ELEC
	.LONG	BEL_1201
	.LONG	0

SWED_2X5 .LONG	SWED_S51
	.LONG	SWED_S52
	.LONG	0

NZ_12	.LONG	NZ_121
	.LONG	0

NZ_13	.LONG	NZ_131
	.LONG	0

NETH_HF	.LONG	HF_11
	.LONG	HF_32
	.LONG	0

FINMKA	.LONG	FIN_1
	.LONG	0

KR_LIST	.LONG	NOR_12
	.LONG	NOR_35
	.LONG	0

DKR_LIST .LONG	DEN_12
	.LONG	DEN_35
	.LONG	DEN_710
	.LONG	0

ANT_LIST .LONG	ANT1P25
	.LONG	ANT4DOL
	.LONG	0

HUNG_LIST
	.LONG	HUNG2X10
	.LONG	HUNG2X20
	.LONG	0

	.ENDIF

EC1	.STRING	"1 CREDIT / 25 CENTS",0
	.EVEN
C11	.STRING  "1 ",W_CREDIT," / 1 ",W_COIN
	.BYTE 0
	.EVEN
C21	.STRING  "1 ",W_CREDIT," / 2 ",W_COINS
	.BYTE 0
	.EVEN
C43	.STRING  "3 ",W_CREDIT,"S / 4 ",W_COINS
	.BYTE 0
	.EVEN
C44	.STRING  "4 ",W_CREDIT,"S / 4 ",W_COINS
	.BYTE 0
	.EVEN
C15
	.STRING	"1 ",W_CREDIT," / 2 X 25 CENTS",0
	.EVEN

DOLL2	.STRING  "2 ",W_CREDIT,"S / $1.00"
	.BYTE 0
	.EVEN

DOLL3	.STRING  "3 ",W_CREDIT,"S / $1.00"
	.BYTE 0
	.EVEN

DOLL4	.STRING  "4 ",W_CREDIT,"S / $1.00"
	.BYTE 0
	.EVEN

DM11	.STRING  "1 ",W_CREDIT," / 1 DM",0
	.EVEN
DM22	.STRING  "2 ",W_CREDIT,"S / 2 DM",0
	.EVEN
DM55	.STRING  "5 ",W_CREDIT,"S / 5 DM",0
	.EVEN
DM65	.STRING  "6 ",W_CREDIT,"S / 5 DM",0
	.EVEN
DM75	.STRING  "7 ",W_CREDIT,"S / 5 DM",0
	.EVEN
DM85	.STRING  "8 ",W_CREDIT,"S / 5 DM",0
	.EVEN

F3F5	.STRING  "3 ",W_CREDIT,"S / 5F"
	.BYTE 0
	.EVEN
F2F5
F25	.STRING  "2 ",W_CREDIT,"S / 5F"
	.BYTE 0
	.EVEN
F15	.STRING  "1 ",W_CREDIT," / 5F"
	.BYTE 0
	.EVEN
F510	.STRING  "5 ",W_CREDIT,"S / 10F"
	.BYTE 0
	.EVEN
F1120	.STRING  "11 ",W_CREDIT,"S / 2 X 10F"
	.BYTE 0
	.EVEN
F4109	.STRING  "9 ",W_CREDIT,"S / 2 X 10F"
	.BYTE 0
	.EVEN
F4107	.STRING  "7 ",W_CREDIT,"S / 2 X 10F"
	.BYTE 0
	.EVEN
F4105	.STRING  "5 ",W_CREDIT,"S / 2 X 10F"
	.BYTE 0
	.EVEN
F410	.STRING  "4 ",W_CREDIT,"S / 10F"
	.BYTE 0
	.EVEN
F310	.STRING  "3 ",W_CREDIT,"S / 10F"
	.BYTE 0
	.EVEN
F210	.STRING  "2 ",W_CREDIT,"S / 10F"
	.BYTE 0
	.EVEN

F3X1F	.STRING  "1 ",W_CREDIT," / 3 X 1F"
	.BYTE	0
	.EVEN

F2X1F	.STRING  "1 ",W_CREDIT," / 2 X 1F"
	.BYTE	0
	.EVEN

F52X5	.STRING  "5 ",W_CREDIT,"S / 2 X 5F"
	.BYTE	0
	.EVEN

F5X10F	.STRING  "5 ",W_CREDIT,"S / 10F"
	.BYTE	0
	.EVEN

F72X5	.STRING  "7 ",W_CREDIT,"S / 2 X 5F"
	.BYTE	0
	.EVEN

SFRANC11     .STRING  "1 ",W_CREDIT," / 1F"
	.BYTE 0
	.EVEN
SFRANC65     .STRING  "6 ",W_CREDIT,"S / 5F"
	.BYTE 0
	.EVEN
SFRANC75     .STRING  "7 ",W_CREDIT,"S / 5F"
	.BYTE 0
	.EVEN
SFRANC85     .STRING  "8 ",W_CREDIT,"S / 5F"
	.BYTE 0
	.EVEN

	.IF	FULLPRICE
P1500L_P .STRING      "1 CREDIT / 500 LIRE"
	.BYTE 0
	.EVEN

UK_1201	.STRING	"1 CREDIT / 30 P"
	.BYTE 0
	.EVEN
UK_1202	.STRING	"2 CREDITS / 50 P"
	.BYTE 0
	.EVEN
UK_1203	.STRING	"5 CREDITS / L1.00"
	.BYTE 0
	.EVEN

UK_2201	.STRING	"2 CREDITS / 20 P"
	.BYTE 0
	.EVEN
UK_2202	.STRING	"5 CREDITS / 50 P"
	.BYTE 0
	.EVEN

UK_3201	.STRING	"1 CREDIT / 50 P"
	.BYTE 0
	.EVEN
;UK_3202	.STRING	"2 CREDITS / 50 P"
;	.BYTE 0
;	.EVEN
UK_3203	.STRING	"2 CREDITS / L1.00"
	.BYTE 0
	.EVEN

UK_4201	.STRING	"1 CREDIT / 50 P"
	.BYTE 0
	.EVEN
UK_4202	.STRING	"3 CREDITS / L1.00"
	.BYTE 0
	.EVEN
;UK_4203	.STRING	"7 CREDITS / L1.00"
;	.BYTE 0
;	.EVEN

SP_11	.STRING	"1 CREDIT / 100 PESETA"
	.BYTE	0
	.EVEN

SP_44	.STRING	"5 CREDITS / 500 PESETA"
	.BYTE	0
	.EVEN

SP_54	.STRING	"6 CREDITS / 500 PESETA"
	.BYTE	0
	.EVEN
NZ_131
AU_36	.STRING	"1 CREDIT / 3 X 20 CENTS"
	.BYTE	0
	.EVEN
AU_2D	.STRING	"2 CREDITS / $ 1.00"
	.BYTE	0
	.EVEN
AU_520	.STRING	"1 CREDIT / 5 X 20 CENTS"
	.BYTE	0
	.EVEN
AU_1D	.STRING	"1 CREDIT / $ 1.00"
	.BYTE	0
	.EVEN
	.ENDIF

JAP_101	.STRING	"1 CREDIT / 100 YEN"
	.BYTE	0
	.EVEN

	.IF FULLPRICE

JAP_201	.STRING	"2 CREDITS / 100 YEN"
	.BYTE	0
	.EVEN
ASTA101	.STRING	"1 CREDIT / 2 X 5 SCHILLING"
	.BYTE	0
	.EVEN
ASTA102	.STRING	"3 CREDITS / 2 X 10 SCHILLING"
	.BYTE	0
	.EVEN
ASTA151	.STRING	"1 CREDIT / 5 SCHILLING"
	.BYTE	0
	.EVEN
ASTA152	.STRING	"2 CREDITS / 10 SCHILLING"
	.BYTE	0
	.EVEN

BEL_1201 .STRING	"1 CREDIT / 2OF"
	.BYTE	0
	.EVEN
BEL_2201 .STRING	"2 CREDITS / 2OF"
	.BYTE	0
	.EVEN
BEL_3201 .STRING	"3 CREDITS / 2OF"
	.BYTE	0
	.EVEN

SWED_S51 .STRING	"1 CREDIT / 3 X 1 KRONA"
	.BYTE	0
	.EVEN
SWED_S52 .STRING	"2 CREDITS / 5 KRONA"
	.BYTE	0
	.EVEN

NZ_121	.STRING	"1 CREDIT / 2 X 20 CENTS"
	.BYTE	0
	.EVEN

HF_11	.STRING	"1 CREDIT / 1 HFI"
	.BYTE	0
	.EVEN

HF_32	.STRING	"3 CREDITS / 2.5 HFI"
	.BYTE	0
	.EVEN

FIN_1	.STRING	"1 CREDIT / 1 MARKKA"
	.BYTE	0
	.EVEN

DEN_12
NOR_12	.STRING	"1 CREDIT / 2 X 1 KRONE"
	.BYTE 0
	.EVEN

NOR_35	.STRING	"3 CREDITS / 5 X 1 KRONE"
	.BYTE 0
	.EVEN

DEN_35	.STRING	"3 CREDITS / 5 KRONE"
	.BYTE 0
	.EVEN

DEN_710	.STRING	"7 CREDITS / 2 X 5 KRONE"
	.BYTE 0
	.EVEN

ANT1P25	.STRING	"1 CREDIT / 25 CENTS"
	.BYTE 0
	.EVEN

ANT4DOL	.STRING	"4 CREDITS / 1 GUILDER"
	.BYTE 0
	.EVEN

HUNG2X10
	.STRING	"1 CREDIT / 2 X 10 FORINT",0
	.EVEN

HUNG2X20
	.STRING	"3 CREDITS / 2 X 20 FORINT",0
	.EVEN

	.ENDIF

**************************************************************************
*								         *
* 	 COIN SLOT TITLES						 *
*								         *
**************************************************************************
********************************** PRIMITIVES    ST

AQRTR   .string ".25",0
        .even

ANICKEL   .string ".05",0
        .even

ADIME   .string ".10",0
        .even

ADOLLR   .string "$1.00",0
        .even

AFRANC   .string "1F",0
        .even

FIVFRNC   .string "5F",0
        .even

TENFRNC   .string "10F",0
        .even

FIFTYF   .string "50F",0
        .even

TWENTYF   .string "20F",0
        .even

FIVEDM   .string "5DM",0
        .even

TWODM   .string "2DM",0
        .even

ONEDM   .string "1DM",0
        .even

FIVHUNDL        .string "500L",0
        .even

APOUND  .string"L1.00",0
        .even

FIFTYP   .string "50P",0
        .even

FIVHUNP   .string "500P",0
        .even

ONEHUNP   .string "100P",0
        .even

TWENTYP   .string "20P",0
        .even

TENP   .string "10P",0
        .even

TWENTYC   .string ".20",0
        .even

ONEHUNY .string "100Y",0
        .even

ONEKR   .string "1 KR",0
        .even

FIVEKR   .string "5 KR",0
        .even

ONEHFI  .string "1HFI",0
        .even


TWOHFI  .string "2.5HFI",0
        .even

ONEMARKKA   .STRING   "1M",0
	    .EVEN

FIVESCH  .STRING   "5SCH",0
	    .EVEN

TENSCH  .STRING   "10SCH",0
	    .EVEN

TENFOR .STRING	"10FT",0
	.EVEN

TWENTFOR .STRING	"20FT",0
	.EVEN

AGUILDER    .STRING   "1G",0
	    .EVEN


********************************** PRIMITIVES END

; EACH OF THE FOLLOWING CONSISTS OF FIVE STRINGS REPRESENTING
;              S1,  S2,  S3,  S4,  and BILL 
;       Zero means print nothing under that field.
;       Some (but VERY few) are kludged (see MKSLOT for instance)


USA_ESLOT	
        .long   ADOLLR,AQRTR,ADIME,ANICKEL,ADOLLR
;	.STRING	"$1.00  .10    .25      .5    $1.00",0

FRANCE_ESLOT
        .long   AFRANC,FIVFRNC,TENFRNC,0,0
;	.STRING	"1F     5F    10F",0

GERMAN_ESLOT
        .long   FIVEDM,TWODM,ONEDM,0,0
;	.STRING	"5DM    2DM    1DM",0

BELGIUM_ESLOT
        .long   FIFTYF,TWENTYF,FIVFRNC,0,0
;	.STRING	"50F    20F    5F",0

	.IF	FULLPRICE
USA_QDQ
        .long   AQRTR,AQRTR,0,0,ADOLLR
;	.STRING   ".25    .25                    $1.00",0
	.ENDIF

GERMAN_15 
        .long   ONEDM,FIVEDM,0,0,0
;           .STRING   "1 DM  5 DM"

FRENCH510
        .long   FIVFRNC,TENFRNC,0,0,0
;           .STRING   "5F    10F"

FRENCH1F5F
        .long   AFRANC,FIVFRNC,0,0,0
;	.STRING       "1F    5F",0

CAN_QD
        .long   AQRTR,ADOLLR,0,0,ADOLLR
;	.STRING	".25  $1.00                  $1.00",0

	.IF	FULLPRICE
SWISS15	  
        .long   AFRANC,FIVFRNC,0,0,0
;	    .STRING       "1F    5F",0


ITALYLIRE
        .long   FIVHUNDL,FIVHUNDL,0,0,0
;           .STRING   "500L 500L"

UK2050
        .long   APOUND,FIFTYP,0,0,0
;           .STRING   "L1.00 50 P"


UK_ELEC
        .long   APOUND,FIFTYP,TWENTYP,TENP,0
;           .STRING   "L1.00   50P    20P    10P"

UK_CCU	    .STRING   "CCU ON LEFT SLOT	   "
	    .BYTE 0
	    .EVEN

PESETA100
        .long   ONEHUNP,FIVHUNP,0,0,0
;	.STRING   "100 P  500 P",0

AUST20C
        .long   TWENTYC,ADOLLR,0,0,0
;	.STRING   ".20   $ 1.00",0

	.ENDIF

YEN100
        .long   ONEHUNY,ONEHUNY,0,0,0
;           .STRING   "100Y 100Y"

	.IF	FULLPRICE
SHILL510
        .long   FIVESCH,TENSCH,0,0,0
;        .STRING   "5       10 SCHILLING"

FRANC20	    
        .long   TWENTYF,TWENTYF,0,0,0
;           .STRING   "20F   20F"

DKRSLOT
KRONA5
        .long   ONEKR,FIVEKR,0,0,0
;            .STRING   "1 KR  5 KR"

NZ20
        .long   TWENTYC,TWENTYC,0,0,0
;           .STRING   ".20     .20"

HFSLOT 
        .long   ONEHFI,TWOHFI,0,0,0
;           .STRING   "1HFI  2.5HFI"

MKSLOT
        .long   ONEMARKKA,ONEMARKKA,0,0,0
;           .STRING   "1       1 MARKKA"             

NKRSLOT
        .long   ONEKR,ONEKR,0,0,0
;           .STRING   "1 KR  1 KR"

ANTSLOT	
        .long   AQRTR,AGUILDER,0,0,0
;           .STRING   ".25    1 GUILDER"

HUNGSLOT
        .long   TENFOR,TWENTFOR,0,0,0
;	.STRING	"10     20 FORINT",0

	.ENDIF


OCOP	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_11,COLOR_PLF,STRCNRM,0
	.STRING   "1 ",W_COIN," / 1 ",W_PLAY
	.BYTE	  0,0
	.EVEN

USA_ELECTRONIC:
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,COLOR_PLF,STRCNRM,0
	.STRING	"1 CREDIT  /  25 CENTS"	
	.STRING	"\N4 CREDITS /  1 DOLLAR",0,1
	.EVEN

FRANCE_ELECTRONIC:
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,COLOR_PLF,STRCNRM,0
	.STRING	"1 CREDIT  /  25 CENTS"	
	.STRING	"\N4 CREDITS /  1 DOLLAR",0,1
	.EVEN

GERMAN_ELECTRONIC:
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,COLOR_PLF,STRCNRM,0
	.STRING	"1 CREDIT  /  1 DM"	
	.STRING	"\N6 CREDITS /  5 DM",0,1
	.EVEN

	.IF	FULLPRICE
BELGIUM_ELECTRONIC:
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,COLOR_PLF,STRCNRM,0
	.STRING	"1 CREDIT  /  20 FR"	
	.EVEN

	.ENDIF
* JAKE START
UK_ELECTRONIC1
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,COLOR_PLF,STRCNRM,0
	.STRING   "1 ",W_CREDIT," / 50 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_33,COLOR_PLF,STRCNRM,0
	.STRING	"3 ",W_CREDIT,"S / "
	.BYTE	  FONT_EPOUND
	.STRING	"1.00"
	.BYTE	  0,0
	.EVEN
UK_ELECTRONIC2
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,COLOR_PLF,STRCNRM,0
	.STRING   "1 ",W_CREDIT," / 50 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_33,COLOR_PLF,STRCNRM,0
	.STRING	"2 ",W_CREDIT,"S / "
	.BYTE	  FONT_EPOUND
	.STRING	"1.00"
	.BYTE	  0,0
	.EVEN
UK_ELECTRONIC3
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,COLOR_PLF,STRCNRM,0
	.STRING   "1 ",W_CREDIT," / 30 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_23,COLOR_PLF,STRCNRM,0
	.STRING   "2 ",W_CREDIT,"S / 50 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_33,COLOR_PLF,STRCNRM,0
	.STRING	"5 ",W_CREDIT,"S / "
	.BYTE	  FONT_EPOUND
	.STRING	"1.00"
	.BYTE	  0,0
	.EVEN


CP_CX	EQU	200
CP_11	EQU	11
CP_13	EQU	13
CP_23	EQU	23
CP_33	EQU	33
