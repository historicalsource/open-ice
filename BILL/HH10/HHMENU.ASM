      	.MLIB	"HHMACS.LIB"
	.FILE	"HHMENU.ASM"
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
	.INCLUDE	"HHDICT.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhmenu.e"
	.include	"hh.g"
	.include	"hhcmos.g"
	.include	"hhram.g"
	.include	"hhsnd.g"
	.include	"hhdtst.g"
	.include	"hhd.g"
	.include	"hhproc.g"
	.include	"hhtext.g"
	.include	"hhmisc.g"
	.include	"hhutil.g"
	.include	"hhadj.g"
	.include	"hhcoin.g"

; end of include files

*SYMBOLS IN THIS MODULE


*SYMBOLS IN APDTST.ASM
	.REF	SWITCHTEST, CONV_PLOT, DIPTEST
	.REF	COLORBAR

*
*        MAIN_RET
*
*        POSITIVE NUMBER HERE SAYS RETURN (UPWARD) TO MAIN MENU (GEN_MENU ONLY)
*        NEGATIVE NUMBER HERE SAYS SETUP RESTORE AFTER RAM TEST. (GEN_MENU)
*
	.BSS	MAIN_RET,16		;FLAG SAYS RETURN TO MAIN MENU
	.BSS	GMENULEV,16		;HOW DEEP INTO GEN_MENU WE ARE
	.BSS	SND_MADE,16		;SOUND TEST FLAG
	.BSS	NO_CLEAR,16		;FLAG TELLS GET_MENU NOT TO CLEAR!
	.BSS	LAST_BUT,32
	.BSS	SCODE,16
	.BSS	DCODE,16
	.BSS    FAC_FLAG,16          ;FLAG SAYS CLEAR AUDITS AND HSTABLE
	.bss	xxxx,16		;fill space to 32 bits
	.BSS	SWSET1,32
	.BSS	SWSET2,32
	.BSS	CHAROUT,16
	.BSS	BLINE,16
	.BSS	BCHAR,16
	.BSS	PTSIZE,16		; BOGUS 15 PT FONT FLAG
	.BSS	LASTCOLOR,32

         .TEXT


;XUNIT START

READ_SW1_CNS:
	move	@SWITCH,a0
	move	@COINS,a14
	sll	16,a14
	movy	a14,a0
	RETS

READ_SW2_DIP:
	move	@SWITCH2,a0
	move	@DIPSWITCH,a14
	sll	16,a14
	movy	a14,a0
	RETS

**************************************************************************
*								         *
* 	READ_SW1_SW2							 *
* 									 *
* 	Combine the locations SWITCH and SWITCH2 into one		 *
* 	LONG word looking like this [SWITCH2,SWITCH]			 *
*								         *
**************************************************************************
READ_SW1_SW2
	move	@SWITCH,a0
	move	@SWITCH2,a14
	sll	16,a14
	movy	a14,a0
	RETS

;XUNIT END



**************************************************************************
*								         *
* 	DIAG								 *
* 									 *
* 	PROCESS STARTED WHEN DIAG SWITCH IS HIT				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		WARMBOOTS THE PROCESSOR					 *
*								         *
**************************************************************************
DIAG
	CALLA	QSNDRST			;TURN OFF THAT STUPID SOUND BOARD
	SOUNDON
	MOVE	@GAME_STATE,A0,W
	CMPI	INDIAG,A0
	JRNZ	DIAG_JUMP
	JAUC	SUCIDE

DIAG_JUMP
	CLR	A0
	MOVE	A0,@PTSIZE,W		;EVERYTHING IN 7PT
	CALLR	DIGSRT			;MAKE SURE WE'RE IN TEST MODE

	CLR	A0
	MOVE	A0,@MAIN_RET,W		;CLEAR THE FLOAT TO TOP FLAG.
	MOVE    A0,@GMENULEV,W		;INDICATE WE'RE AT LEVEL ZERO.

DIAG_RESTART
	MOVI	MEN_MAIN,A8
	JSRP	GEN_MENU		;PROCESS THIS MENU!

**************************************************************************
*								         *
* 	DIAG_EX								 *
* 									 *
* 	DIAGNOSTIC EXIT							 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
DIAG_EX:
	SLEEP	2
	CALLA	CLR_SCRN
	CALLA	CMOS_VAL		; VALIDATE THE CMOS
	CALLA	CKTEST
	CALLA	READ_DIP
	ANDI	DPTEST,A0
	JRZ	DE2
	MOVI	NOTCLOSEDDIP,A8
	CALLA	LM_SETUP
	JSRP	PRINTF
DE2
	CALLR	READ_SW1_CNS		; XUNIT
	NOT	A0
	ANDI	00100000H,A0
	JRZ	DE3
	MOVI	NOTCLOSEDJAMMA,A8
	CALLA	LM_SETUP
	JSRP	PRINTF
DE3
	MOVI	NOTCLOSEDWAIT,A8
	CALLA	LM_SETUP
	JSRP	PRINTF
	CALLR	READ_SW1_CNS		; XUNIT HANGOUT FOR A WHILE
	ANDI	00343030H,A0
	MOVE	A0,@SWSET1,L
	CALLR	READ_SW2_DIP		; XUNIT
	ANDI	0100001FH,A0
	MOVE	A0,@SWSET2,L
DE4
	SLEEP	1			;APPEASE THE MAIN LOOP
	CALLR	CKTEST			;CHECK STATUS OF TEST SWITCH
	CALLR	READ_SW1_CNS		; XUNIT GOTTA SEE IF TIME TO LEAVE
	MOVE	@SWSET1,A1,L
	MOVE	A0,A3			;SAVE A COPY AROUND
	ANDI	00243030H,A0
	ANDI	00243030H,A1
	CMP	A0,A1
	JRNZ	DE5
	CALLR	READ_SW2_DIP		; XUNIT
****	MOVE	@SWSET2,A1,L
	MOVE	A0,A4			;SAVE A COPY
****	ANDI	1FH,A0
****	ANDI	1FH,A1
****	CMP	A0,A1
****	JRNZ	DE5

	MOVE	@SWSET1,A1,L
	ANDI	00100000H,A1
	ANDI	00100000H,A3
	CMP	A1,A3
	JRNZ	DIAG_EX			; WELL ONE OF THEM IS OPEN NOW
	MOVE	@SWSET2,A1,L
	ANDI	01000000H,A1
	ANDI	01000000H,A4
	CMP	A1,A4
	JRNZ	DIAG_EX
	JRUC	DE4
DE5
	CALLR	CKTEST			; ONE FINAL TIME ( STILL WRONG )
	JRUC	DIAG_JUMP

NOTCLOSEDDIP
	MESS_MAC RD7FONT,SPACING07,200,50,COLOR_PRED,STRCNRM,0
	.STRING	W_DIPSWITCH," ",W_TEST," SELECT (UJ2 # 8) ",W_CLOSED,".",0
	.EVEN

NOTCLOSEDJAMMA
	MESS_MAC RD7FONT,SPACING07,200,70,COLOR_PRED,STRCNRM,0
	.STRING	W_COIN," DOOR ",W_TEST," ",W_SWITCH," ",W_CLOSED,".",0
	.EVEN

NOTCLOSEDWAIT
	MESS_MAC RD7FONT,SPACING07,200,120,COLOR_PRED,STRCNRM,0
	.STRING	"PRESS ANY ",W_BUTTON," TO ",W_RETURN," TO ",W_TEST," MODE\nOR"
	.STRING	"\nOPEN THE ",W_SWITCH,"(S) TO ",W_RETURN," TO ",W_GAME,".",0
	.EVEN

**************************************************************************
*                                                                        *
*          DIGSRT                                                        *
*                                                                        *
*          THIS IS CALLED ON ENTRY TO DIAGNOSTICS.                       *
*                                                                        *
**************************************************************************
DIGSRT
	CALLR	DIAG_STATE
	CALLA	WIPEOUT		;INITIALIZE THE OBJECT LIST
	PAGEOFF			;MAKE SURE PAGE FLIPPING IS OFF
	CALLA	COLOR_START	;START UP THE COLOR PROCESSES
	CALLA	QSNDRST		;kill any sounds in progress
	CALLA	DIPINIT		;INITIALIZE WHAT WE CAN FROM THE DIPS
	MOVK	1,A0
	MOVE	A0,@DISPLAYON,W	;WE NEED TO SEE THE STUFF JACK

	CALLA	CLR_SCRN	;CLEAR THE SCREEN!

	RETS

**************************************************************************
*								         *
* 	DIAG_STATE							 *
* 									 *
* 	GET EVERYTHING SETUP/KILLED OFF FOR DIAG STATE			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
DIAG_STATE
	CLR	A1
	CALLA	KILALL			;KILL ABSOLUTELY EVERYONE!

	MOVI	PID_DIAG,A1		;SET OUR ID TO DIAGNOSTICS MAN
	MOVE	A1,*A13(PROCID),W	;PASS OUR ID TO FORKED PROCESS

	MOVI	INDIAG,A0
	MOVE	A0,@GAME_STATE,W	;PUT US IN TEST MODE!
	RETS

**************************************************************************
*								         *
* 	GO_DIAG								 *
* 									 *
* 	ENTER THE DIAGNOSTICS MENU					 *
*								         *
**************************************************************************

GO_DIAG
	MOVI	MEN_DIAG,A8		;PUT UP THE MENU AND GO!
	JAUC	GEN_MENU		;THIS WILL RETURN TO LEVEL ABOVE US!

GO_SWITCH
	MMTM	SP,A12,A13
	DISPOFF
	CALLA	CLR_SCRN
	CALLA	SWITCHTEST
	MMFM	SP,A12,A13
DIAG_RESTORE
	CALLA	CLRDMAQ
	CALLA	MYOINIT
	DISPON
	CALLA	CLR_SCRN
	RETP

GO_DIP
	MMTM	SP,A12,A13
	DISPOFF
	CALLA	CLR_SCRN
	CALLA	DIPTEST
	MMFM	SP,A12,A13
	JRUC	DIAG_RESTORE

GO_CPU
	DISPOFF
	JAUC	DIAGCPUTEST

GO_BURN
	DISPOFF
	JAUC	BURNIN

CPU_RET
	CLR	A0
	MOVE	A0,@GMENULEV,W	;INDICATE WE'RE AT LEVEL ZERO.

	MOVI	RTR_LEV,A0	;THIS IS THE LEVEL TO DIVE TO
	NEG	A0		;NEGATE IT AS FLAG TO DIVE.
	MOVE	A0,@MAIN_RET,W	;INDICATE
	PAGEOFF			;MAKE SURE PAGE FLIPPING IS OFF
	JAUC	DIAG_RESTART	;NOW START IT UP....

GO_CONV
	MMTM	SP,A12,A13
	DISPOFF
	CALLA	CLR_SCRN
	CALLA	CONV_PLOT
	MMFM	SP,A12,A13
	JSRP	WAIT_BUT	;NOW WAIT FOR ANY BUTTON!
	JRUC	DIAG_RESTORE

GO_BARS
	MMTM	SP,A12,A13
	DISPOFF
	CALLA	CLR_SCRN
	CALLA	COLORBAR
	MMFM	SP,A12,A13
	JSRP	WAIT_BUT	;NOW WAIT FOR ANY BUTTON!
	JRUC	DIAG_RESTORE


**************************************************************************
*								         *
* 	OPERATOR MESSAGE ENTRY						 *
*								         *
**************************************************************************

OP_LINE_CHAR	EQU	PDATA
OP_LINE_LINE	EQU	PDATA+WORD_SIZE
OP_LETS		EQU	OP_LINE_LINE+WORD_SIZE
OP_STIME      	EQU	OP_LETS+(30 * BYTE_SIZE)
OP_SVAL		EQU	OP_STIME+WORD_SIZE

LET_DIST_X	EQU	25
LET_DIST_Y	EQU	20
LET_BOX_CX	EQU	6
LET_BOX_CY	EQU	3
LET_BOX_WX	EQU	3
LET_BOX_WY	EQU	1
LET_START_Y1	EQU	175
LET_START_Y2	EQU	LET_START_Y1+LET_DIST_Y
LET_START_Y3	EQU	LET_START_Y2+LET_DIST_Y
LET_START_Y4	EQU	LET_START_Y3+LET_DIST_Y
LET_INST1	EQU	60
LET_START_X	EQU	15
LET_LINE_MAX	EQU	3
LET_CHAR_MAX	EQU	14
LET_TEXT_GAP	EQU	11
LET_TEXT1	EQU	120
LET_TEXT2	EQU	LET_TEXT1+LET_TEXT_GAP
LET_TEXT3	EQU	LET_TEXT2+LET_TEXT_GAP
OP_MAX_CHARS	EQU	CMESS_CHARS


BLASTMESS:
	CALLA	CMOSUNLOCK
;XUNIT        CALLA   ADJ_PAGE		; GUY ENTERETED A WHOLE MESSAGE
	CLR	A0
        MOVI    VALID_CUSTOM,A7
        CALLA   WC_WORD
	CALLA	CMOSLOCK
        CALLA   F_ADC_S			; FIX UP THE CHECKSUM
	RETS

**************************************************************************
*								         *
* 	SOUND SYSTEM TEST						 *
*								         *
**************************************************************************

TO_SD_BD EQU     0
TO_Y_BD  EQU     3               ;A5 FOR SNDSND
TEST_YAM EQU     0F2H            ;A3 GETS CODE
TEST_DAC EQU     0F2H

**************************************************************************
*								         *
* 	GO_STEST							 *
* 									 *
* 	SETUP THE MENU FOR THE SOUND TEST				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
GO_STEST CLR     A0
         MOVE    A0,@SCODE,W          ;NO "CURRENT" SYNTH YET
         MOVE    A0,@DCODE,W          ;NO "CURRENT" DIG YET
         MOVI    MEN_STEST,A8         ;PUT UP THE MENU AND GO!
         JAUC    GEN_MENU             ;THIS WILL RETURN TO LEVEL ABOVE US!

**************************************************************************
*								         *
* 	SEND_YAM							 *
* 									 *
* 	SEND A CODE PASSED IN A3 OUT TO THE YAMAMAHA			 *
* 									 *
* 	ENTRY								 *
* 		A3	CODE						 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
SEND_YAM
	MMTM	SP,A5
	MOVI	TO_Y_BD,A5
	MOVE	A3,@SND_MADE,W		;INDICATE WE MADE A SOUND!
;	CALLA	SNDSND			;SEND IT!
	MMFM	SP,A5
	RETS

**************************************************************************
*								         *
* 	SHUT_UP								 *
* 									 *
* 	TELL THE SOUND BOARD TO GET SCREWED				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

SHUT_UP
;	MOVI	SND_ALLOFF,A0	;TURN OFF SOUNDS
;	CALLA	ONESND
        SLEEP   1
        RETP

INC_IF_NEC
	MOVE	A3,A3		;IF ITS ZERO...KICK IT!
	JRZ	INC_IT
	MOVE	@LAST_BUT,A0,L	;SEE WHICH BUTTON
	CMPI	2,A0
	JRNZ	NO_INC		;THEN USE SAME CODE
INC_IT
	INC	A3
NO_INC
	RETS

SCTAB
	.WORD	4CH,3FH,11BH,12AH,0F7H,2,0AH,3,5,6,0FH,0CH
	.WORD	100H,101H,102H,104H,105H,106H,107H,108H,109H,10AH,10DH
	.WORD	10EH,12EH,12FH,130H,131H,132H,133H,134H,136H,137H,13AH,13BH
	.WORD	14EH,14FH,150H,151H,152H,153H,154H,158H,15EH,15FH,160H,15AH
	.WORD	167H
	.WORD	146H,147H,184H

LAST_SCODE       EQU     ($-SCTAB)/WORD_SIZE
         .EVEN


**************************************************************************
*								         *
* 	GO_DIGT								 *
* 									 *
* 	SETUP A GENERIC SOUND BOARD TEST				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
GO_DIGT
	CALLA	QSNDRST			;RESET IN CASE CRASHED!
	SLEEP	4			;LET IT GO A SEC!
	CALLA	CLR_SCRN
	MOVI	M_DIGT,A2
	MOVI	COLOR_GREEN,A3
	JSRP	TOP_BOX			;PRINT TITLE BOX.

        CALLA	SURE_BOX		;PUT A NICE BOX UP!

	MOVI	0FD00H,A0
;	MOVE	A0,@SOUND,W
	MOVI	8,A14
	DSJS	A14,$			;SLOW IT DOWN A BIT
	MOVI	0FF00H,A0
;	MOVE	A0,@SOUND,W		;PULL ON THE SOUND INTERRUPT

	MOVI	8,A14
	DSJS	A14,$			;LET LINE SETTLE

	MOVE	@INT_REG,A14,L		;ARE WE CONNECTED?
	btst	B_SIRQ,a14
	JRNZ	SOUND_IRQ_CONNECTED	;BR = YES SIRREE

	MOVI	SIRQ_ERR,A8
	JSRP	L_MESS			;PRINT ERROR

	JSRP	ANY_BUT			;AND TELL EM ANY BUTTON TO CONTINUE

	CALLR	BLNK_SURE_BOX

	MOVI	SIRQ_ERR2,A8
	JSRP	L_MESS			;REMIND THE GUY OF THE PREVIOUS ERROR
	JRUC	SOUND_DONGER
SOUND_IRQ_CONNECTED
	MOVI	SIRQ_DETECT,A8
	JSRP	L_MESS			;NOTIFY THAT SOUND IRQ WAS CHECKED
SOUND_DONGER
	CALLA	SNDRES			;RESET TO GET THE DINGS
        MOVI    DAC_ERR,A8
	JSRP	L_MESS			;PRINT ERROR
	JAUC	ANY_BUT			;AND TELL EM ANY BUTTON TO CONTINUE

**************************************************************************
*                                                                        *
*          GO_SYNP                                                       *
*                                                                        *
*          THIS IS THE "PLAY SYNTHESIZER" CODE.                          *
*                                                                        *
*          GET THE NEXT CODE...SEND IT TO THE YAMAHA AND                 *
*          DISPLAY THE CORRESPONDING TITLE.                              *
*                                                                        *
**************************************************************************
GO_SYNP
	CLR	A3
	CALLA	SEND_YAM		;KILL CURRENT SOUND
	MOVE	@SCODE,A3,W		;GET THE NEXT CODE
	CALLR	INC_IF_NEC
	CMPI	LAST_SCODE,A3		;HAVE WE HIT THE LAST CODE?
	JRLS	GO_SYNP1		;BR = NO
	MOVK	1,A3			;RESET SOUND LIST
GO_SYNP1
	MOVE	A3,@SCODE,W		;STORE CURRENT CODE COUNTER
	MOVI	SCTAB,A0
	DEC	A3			;ZERO DOESN'T COUNT
	SLL	4,A3			;INDEX TO WORDS
	ADD	A3,A0
	MOVE	*A0,A3,W
	ANDI	WORD_MASK,A3
	CALLR	SEND_YAM
	MOVK	1,A0
	MOVE	A0,@NO_CLEAR
	RETP				;THATS IT!

**************************************************************************
*								         *
* 	GAME UTILITIES SELECTED						 *
*								         *
**************************************************************************

GO_UTIL  MOVI    MEN_UTIL,A8
         JAUC    GEN_MENU             ;PROCESS THE UTILITY MENU!

**************************************************************************
*								         *
* 	DO_FACSET							 *
* 									 *
* 	RESET THE CMOS TO FACTORY SETTINGS				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

DO_FACSET:
        MOVI    MESS_FACSET,A8
        MOVK    1,A0
        JRUC    DEF_ADJ_PART

**************************************************************************
*								         *
* 	DO_DEF_ADJ							 *
* 									 *
* 	JUST RESET THE ADJUSTMENTS TO THE FACTORY SETTINGS		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

DO_DEF_ADJ:
        MOVI    MESS_DEF_ADJ,A8
        CLR     A0

;	FALL THROUGH

**************************************************************************
*								         *
* 	DEF_ADJ_PART							 *
* 									 *
* 	SETUP CMOS TO DEFAULT ADJUSTMENTS				 *
* 									 *
* 	ENTRY								 *
* 		A0	HOW MUCH TO CLEAR				 *
* 		A8	MESSAGE TO USE					 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

DEF_ADJ_PART:
        MOVE    A0,@FAC_FLAG,W       ;INDICATE THIS IS ADJUSTMENTS ONLY

        MOVE    A8,-*A12,L           ;PUSH THE MESSAGE
        MOVE    *A12+,A8,L           ;RESTORE MESSAGE

        MOVI    DEFADJSOFT,A9
        MOVI    NULL_ST,A10          ;DON'T PRINT ANYTHING....ROUTINE WILL.
        JSRP    AREUSURE
        RETP
*
*        RETURN A0=0 FOR FAILURE
*
DO_CANCEL
        CLR     A0
        RETP

DEFADJSOFT
*
*        NOW SMASH THE CHECKSUM
*
        CALLA   FORM_ADC               ;FORM THE CKSUM
        MOVE    A1,A0                  ;PUT IN CMOS WRITING REGGIE
        MOVI    ADJ_CKSUM,A7
        INC     A0                     ;THIS SMASHES ADJUSTMENTS
	CALLA	CMOSUNLOCK
        CALLA   WC_WORD                ;AND STORE IT
	CALLA	CMOSLOCK
*
*        NOW MAKE SURE ITS SMASHED
*
        CALLA   CMOS_VAL
        JRZ     AD_FAIL                ;WE CAN'T DO IT.....PRINT FAILURE.
*
*        NOW SET THE ADJUSTMENTS TO THE FACTORY VALUE.
*
        CALLA   FAC_SET             ;THIS DOES THE DEED!
        CALLA   CMOS_VAL            ;IS IT OK NOW?
        JRNZ    AD_FAIL             ;NOPE...PRINT FAILURE

	MOVI	DEFRESMESS,A8
        MOVE    @FAC_FLAG,A0,W      ;DO WE NEED TO CLEAR THE TABLES?
        JRZ     DAX                 ;NOPE...POST SINGLE MESSAGE
        MOVI    MESS_DEFCONF,A8     ;THIS IS SINGLE MESSAGE

        CALLA   CLR_SCRN        ;CLEAR THE SCREEN FOR OUR MESSAGES.
        CALLR   FAC_STUF        ;DO AUDITS AND HIGH SCORE TABLE

        MOVI    MESS_FFSCONF,A8 ;PRINT THE REST OF THE MESSAGES
        JSRP    L_MESS          ;THAT DOES IT!

NOTABS   RETP

AD_FAIL  MOVI    MESS_FACFAIL,A8
         JRUC    DAX

DEF_CAN  MOVI    MESS_CANCELLED,A8

DAX      CALLA   CLR_SCRN
         JSRP    SUR_MESS
         RETP

DEFRESMESS
	.STRING	W_ADJUSTMENTS," RESTORED",0
	.EVEN


*
*        ON A FULL FACTORY SETTING (EITHER REQUESTED OR
*        ADJUSTMENT FAILURE) THIS CLEARS THE AUDITS AND
*        HIGH SCORE TABLE.
*
FAC_STUF
	CALLA   CLR_AUD         ;CLEAR AUDITS TOO
        CALLR   RES_ALL         ;ALL TIME TABLE
        CALLR   INVALID_CUSTOM
        RETS

**************************************************************************
*								         *
* 	INVALID_CUSTOM							 *
* 									 *
* 	THIS KILLS THE CUSTOM MESSAGE SO THAT THE FACTORY MESSAGE	 *
* 	WILL BE USED.  NOTE THAT THIS CHECKSUMS THE ADJUSTMENTS,	 *
* 	SO BE CAREFUL WITH IT!						 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
INVALID_CUSTOM:
        MMTM    SP,A0,A7
;XUNIT        CALLA   ADJ_PAGE             ;POINT AT ADJUSTMENT PAGE
        CLR     A0
        MOVI    VALID_CUSTOM,A7
	calla	CMOSUNLOCK
	CALLA   WC_WORD
	calla	CMOSLOCK
        CALLA   F_ADC_S              ;FIXUP CHECKSUM FOR OUR DEED!
	MMFM    SP,A0,A7
	RETS

**************************************************************************
*                                                                        *
*         COIN BOOKKEEPING SELECTED                                      *
*                                                                        *
**************************************************************************
GO_BOOK
	CALLA	CLR_SCRN
	MOVI	MES_BOOK,A2
	MOVI	COLOR_WHITE,A3
	JSRP	TOP_BOX			;PRINT TITLE BOX.

	MOVI	COIN_AUDS,A0		;PUT TABLE UP.
	JSRP	PRNT_AUD

	MOVI	MEN_DETAIL,A8
	MOVI	1,A9			;CURSOR ON 1ST ENTRY
	JSRP	B_MENU			;SEE IF THEY WANT PAGE 2.

	CMPI	1,A8			;DID WE GET 1'ST ENTRY?
	JRNZ	NO_DETAIL		;NOPE...RETURN TO OUR CALLER
DETAIL_SCREEN
	CALLA	CLR_SCRN		;CLEAR OUT FOR ACTION!
	MOVI	MES_TOTALS,A2
	MOVI	COLOR_WHITE,A3
	JSRP	TOP_BOX			;PRINT TITLE BOX.

	MOVK	1,A0
	MOVE	A0,@PTSIZE,W		;THIS BOX IS IN 15 PT

	MOVI	COIN_D1,A2		;DETAILED AUDIT 1
	MOVI	ADJCDIV,A0
	CALLA	GET_ADJ
	JRNZ	DSGO
	MOVI	COIN_SD1,A2
DSGO
	MOVE	A2,A0
	JSRP	PRNT_AUD		;PRINT IT
	CLR	A0
	MOVE	A0,@PTSIZE,W

         MOVI    MEN_CLR_SUB,A8       ;CLEAR SUBTOTAL OR RETURN TO MAIN MENU
         MOVI    2,A9                 ;CURSOR ON 2ND ENTRY
         JSRP    B_MENU

         CMPI    1,A8                 ;CHOICE 1 IS CLEAR.....
         JRNZ    NO_CLEAR_SUB         ;NOPE...RETURN TO CALLER!

         MOVI    MESS_CLEAR_SUBS,A8   ;CLEAR COIN SUB-TOTALS...ARE YOU SURE
         MOVI    CLR_COINS,A9          ;ROUTINE TO DO IT
         MOVI    MESS_SUBS_CLEAR,A10  ;CONFIRMATION.
         JSRP    AREUSURE             ;ASK EM.
         JRUC    DETAIL_SCREEN        ;NOW PUT THIS SCREEN BACK UP.

NO_CLEAR_SUB
NO_DETAIL
	RETP

**************************************************************************
*                                                                        *
*          GAME AUDITS SELECTED                                          *
*                                                                        *
**************************************************************************
GO_AUD
	JSRP	NEW_AUDIT_PAGE

	MOVI	GAME_AUDS,A0
	JSRP	PRNT_AUD		;PLOT PAGE ONE

	MOVI	MEN_AP1,A8		;OPTIONS FOR FIRST PAGE
	MOVI	1,A9			;CURSOR ON 1ST ENTRY
	JSRP	B_MENU			;WAIT FOR OPERATOR ENTRY

	CMPI	1,A8			;DOES HE WANT NEXT PAGE?
	JRNZ	NO_AP2			;BR = NO, RETURN TO MAIN MENU

GA2
	JSRP	NEW_AUDIT_PAGE

	MOVI	GAME_AUD2,A0
	JSRP	PRNT_AUD		;PLOT PAGE TWO

	MOVI	MEN_AP2,A8		;PAGE 2 OPTIONS
	MOVI	1,A9			;CURSOR ON 1ST ENTRY
	JSRP	B_MENU			;WAIT FOR OPERATOR ENTRY

	CMPI	1,A8			;NEXT PAGE?
	JRZ	GA3			;BR = YES
	CMPI	2,A8			;PREVIOUS PAGE?
	JRZ	GO_AUD			;BR = YES
	JRUC	NO_AP2			;MUST WANT OUT

GA3
	JSRP	NEW_AUDIT_PAGE		;WIPE TO NEW PAGE

	MOVI	GAME_AUD3,A0
	JSRP	PRNT_AUD		;PLOT PAGE 3

	MOVI	MEN_AP3,A8		;PAGE 3 OPTIONS
	MOVI	2,A9			;CURSOR ON 2ND ENTRY
	JSRP	B_MENU			;WAIT FOR OPERATOR ENTRY

	CMPI	1,A8			;PREVIOUS PAGE?
	JRZ	GA2			;BR = YES

	CALLR	READ_SW1_CNS		; XUNIT
	ANDI	200000H,A0		;HOLDING P2 START?
	JRNZ	NO_AP2

*THE FOLLOWING ARE CONSIDERED HIDDEN AUDITS
	JSRP	NEW_AUDIT_PAGE		;WIPE TO NEW PAGE

	MOVI	GAME_AUD4,A0
	JSRP	PRNT_AUD		;PLOT PAGE 4

	MOVI	MEN_AP3,A8		;PAGE 4 OPTIONS
	MOVI	2,A9			;CURSOR ON 2ND ENTRY
	JSRP	B_MENU			;WAIT FOR OPERATOR ENTRY

	CMPI	1,A8			;PREVIOUS PAGE?
	JRZ	GA3			;BR = YES

	JSRP	DISPDUMP		;DISPLAY THE DUMPS

NO_AP2
	RETP

**************************************************************************
*								         *
* OCTO_AUDS - PRINT OUT AUDITS DURING OCTOPUS PAGE			 *
*								         *
**************************************************************************
OCTO_AUDS
	JSRP	NEW_AUDIT_PAGE
	MOVI	GAME_AUDS,A0
	JSRP	PRNT_AUD		;PLOT PAGE ONE
	SLEEP	15
	MOVI	2000,A0
;	JSRP	SLEEP_SWITCHX

	JSRP	NEW_AUDIT_PAGE
	MOVI	GAME_AUD2,A0
	JSRP	PRNT_AUD		;PLOT PAGE ONE
	SLEEP	15
	MOVI	2000,A0
;	JSRP	SLEEP_SWITCHX

	JSRP	NEW_AUDIT_PAGE
	MOVI	GAME_AUD3,A0
	JSRP	PRNT_AUD		;PLOT PAGE ONE
	SLEEP	15
	MOVI	2000,A0
;	JSRP	SLEEP_SWITCHX

	JSRP	NEW_AUDIT_PAGE
	MOVI	GAME_AUD4,A0
	JSRP	PRNT_AUD		;PLOT PAGE ONE
	SLEEP	15
	MOVI	2000,A0
;	JSRP	SLEEP_SWITCHX

	JAUC	DISPDUMP		;DISPLAY THE DUMPS

**************************************************************************
*								         *
* NEW_AUDIT_PAGE - INITIALIZE A NEW AUDIT PAGE, CLEAR SCREEN AND	 *
* 		 PLOT THE HEADER BOX.					 *
* NOTE: CALL WITH JSRP							 *
*								         *
**************************************************************************
NEW_AUDIT_PAGE
	CALLA	CLR_SCRN
	MOVI	MES_AUD,A2
	MOVI	COLOR_BLUE,A3
	JRUC	TOP_BOX			;PRINT TITLE BOX.

**************************************************************************
*                                                                        *
*          PRNT_AUD                                                      *
*                                                                        *
*          THIS IS CALLED TO PRINT OUT AN AUDIT TABLE.                   *
*                                                                        *
**************************************************************************
AT_PTR   EQU     PDATA                ;LONG
AT_Y     EQU     PDATA+LONG_SIZE      ;WORD
AT_DY    EQU     AT_Y+WORD_SIZE       ;WORD
AT_LX    EQU     AT_DY+WORD_SIZE      ;WORD   LEFT MARGIN X
AT_RX    EQU     AT_LX+WORD_SIZE      ;WORD   RIGHT MARGIN X
AT_OBJ   EQU     AT_RX+WORD_SIZE      ;LONG   OBJECT POINTER FOR COLLECTION ROUT
AT_MESS  EQU     AT_OBJ+LONG_SIZE     ;LONG   PRINT_MONEY MESSAGE STASH

PRNT_AUD
	MOVE	*A0+,A1,W		;GET STARTING HEIGHT
	MOVE	A1,*A13(AT_Y),W		;STORE

	MOVE	*A0+,A1,W		;GET DY TO USE
	MOVE	A1,*A13(AT_DY),W	;STASH IT AWAY

	MOVI	40,A14
	MOVE	@PTSIZE,A1,W
	JRZ	PAGO_PT
	MOVI	33,A14
PAGO_PT
	MOVE	*A0+,A1,W		;GET LEFT MARGIN
	ADD	A14,A1
	MOVE	A1,*A13(AT_LX),W	;STORE
	MOVE	*A0+,A1,W		;GET RIGHT MARGIN
	SUB	A14,A1
	MOVE	A1,*A13(AT_RX),W	;STASH IT AWAY
	MOVE	A0,*A13(AT_PTR),L	;SAVE POINTER INTO AREA

PA1
	MOVE	@LASTCOLOR,A14,L
	CMPI	COLOR_PYELLOW,A14
	JRZ	PACOLFLIP1
	MOVI	COLOR_PYELLOW,A14
	JRUC	PACOLFLIP2
PACOLFLIP1
	MOVI	COLOR_PPURPLE,A14
PACOLFLIP2
	MOVE	A14,@LASTCOLOR,L

	JSRP	DO_AN_AUDIT		;PRINT OUT THE CURRENT AUDIT

	MOVE	*A13(AT_PTR),A0,L	;GET POINTER
	ADDI	AUD_T_SIZE,A0
	MOVE	A0,*A13(AT_PTR),L	;PUT BACK

	CALLR	ADD_AUDIT_DY

	MOVE	*A0,A1,L		;ARE WE DONE?
	JRNZ	PA1

	RETP

**************************************************************************
*                                                                        *
*          ADD_AUDIT_DY                                                  *
*                                                                        *
*          THIS IS CALLED TO MOVE THE AUDIT Y (STORE IN                  *
*          PROCESS AREA) TO THE NEXT AUDIT BY ADDING THE                 *
*          CURRENT DY (ALSO STORED IN PROCESS AREA).                     *
*                                                                        *
**************************************************************************
ADD_AUDIT_DY
         MMTM    SP,A1,A2
         MOVE    *A13(AT_Y),A1,W
         MOVE    *A13(AT_DY),A2,W      ;GET DELTA Y
         ADD     A2,A1                 ;MOVE THE Y DOWN
         MOVE    A1,*A13(AT_Y),W
	MMFM    SP,A1,A2
	RETS

BEGIN_AUDIT
         MMTM    SP,A0
         CLR     A0
         MOVE    A0,@BAD_AUD,W            ;MONITOR CORRUPTION.
	MMFM    SP,A0
	RETS

DO_AN_AUDIT
	CALLR	BEGIN_AUDIT
	MOVE	*A13(AT_PTR),A3,L	;GET POINTER
	MOVE	*A3(AUD_ROUTINE),A4,L	;ROUTINE TO CALL?
	JRZ	DO_BY_NUMBER		;NOPE....DO IT BY NUMBER

	MOVI	DAA_RET,A7
	MOVE	A7,-*A12,L		;PUSH RET ADDR
	JUMP	A4			;"CALL" THE ROUTINE

DO_BY_NUMBER
	MOVE	*A3(AUD_NUMBER),A0,W	;FETCH THE AUDIT NUMBER
	CALLA	GET_AUD			;TURN INTO AUDIT COUNT!
	MOVE	A1,A3			;PROTECT FOR A SECOND.

	JSRP	NUMBER_WORK		;GET THE NUMBER IN A3 UP THERE!

DAA_RET
	MOVI	MESS_AUD_LINE,A8
	MOVE	@PTSIZE,A14,W
	JRZ	DAA_GO
	MOVI	MESS15_AUD_LINE,A8
DAA_GO
	CALLA	LM_SETUP		;SETUP FOR AUDIT PRINTING.
	MOVE	@LASTCOLOR,A5,L

	MOVE	*A13(AT_PTR),A3,L	;GET AUDIT POINTER
	MOVE	*A3(AUD_MESS),A8,L	;GET TEXT POINTER

	JSRP	LEFT_FINISH
	RETP				;THAT'S ALL WE DO!

*
*        LEFT_FINISH   AND    RIGHT_FINISH
*
*        THESE ARE CALLED TO PUT AUDIT INFO
*        ON THE LEFT OR RIGHT SIDE ONCE A8 POINTS AT
*        THE CORRECT DATA TO PRINT
*
LEFT_FINISH
	CALLR	TURN_RED_IF_NEC
	CALLR	SET_FOR_Y		;SET FOR AUDIT'S Y
	CALLR	SET_LEFT_X		;SET FOR LEFT X
	JSRP	PRINTF		;AND TYPE UP THE MESSAGE!
	RETP

RIGHT_FINISH
	CALLR	TURN_RED_IF_NEC		;CHANGE COLOR IF CORRUPTED.
	CALLR	SET_FOR_Y		;SET FOR AUDIT'S Y
	CALLR	SET_RIGHT_X
	JSRP	PRINTF		;FINISH THE JOB!

	MOVE	@BAD_AUD,A0,W		;IS IT CORRUPTED?
	JRZ	RFX			;NOPE....RETURN

	MOVI	MESS_ERROR,A8
	CALLA	LM_SETUP		;SETUP "ERROR"

	CALLR	SET_FOR_Y		;SET FOR AUDIT'S Y
****	ADDI	40000H,A9		;PUSH 4 Y UNITS TO CENTER
	CALLR	SET_RIGHT_X
	JSRP	PRINTF		;FINISH THE JOB!

RFX
	RETP

TURN_RED_IF_NEC
	MMTM	SP,A3
	MOVE	@BAD_AUD,A3,W		;CHANGE TO RED?
	JRZ	DAA_1			;NOPE...ITS OK!
	MOVI	COLOR_PRED,A5		;CHANGE COLOR TO RED
DAA_1
	MMFM    SP,A3
	RETS

SET_FOR_Y
	MMTM	SP,A3
	MOVE	*A13(AT_Y),A3,W		;GET Y COORDINATE
	SLL	16,A3			;PUT IT IN POSITION
	MOVY	A3,A9			;PUT IT IN PLACE
	MMFM    SP,A3
	RETS

SET_LEFT_X
	MMTM	SP,A3
	MOVE	*A13(AT_LX),A3,W
	MOVX	A3,A9			;PUT THE X IN PLACE
	MMFM	SP,A3
	RETS

SET_RIGHT_X
	MMTM	SP,A3
	MOVE	*A13(AT_RX),A3,W
	MOVX	A3,A9			;PUT THE X IN PLACE
	MMFM	SP,A3
	RETS

**************************************************************************
*                                                                        *
*          NUMBER_WORK                                                   *
*                                                                        *
*          A3 HAS THE NUMBER TO DISPLAY.....DO IT!                       *
*                                                                        *
**************************************************************************
NUMBER_WORK
	MOVI	MESS_AUD_NUM,A8		;SETUP FOR AUDIT NUMBER
	MOVE	@PTSIZE,A14,W
	JRZ	NUMGO
	MOVI	MESS15_AUD_NUM,A8
NUMGO
	CALLA	LM_SETUP
	MOVE	@LASTCOLOR,A5,L
	MOVE	A3,A8                   ;NOW WE HAVE BINARY NUMBER
	CALLA	HEXTOASC		;NOW WE POINT TO THE STRING.

	JSRP	RIGHT_FINISH

	RETP

STARTS
	CALLR	GET_STARTS
	MOVE	A2,A3			;GET IN PRINTOUT REG.
	JRUC	NUMBER_WORK		;AND PRINT IT

CONTINS
	CALLR	GET_CONTS
	MOVE	A2,A3			;GET IN PRINTOUT REG.
	JRUC	NUMBER_WORK		;AND PRINT IT

DOPLAYS
	CALLR	GET_PLAYS
	MOVE	A2,A3			;PUT IN PLACE
	JRUC	NUMBER_WORK

DOTOTTIME
	CLR	A3
	JRUC	NUMBER_WORK

DOHSLEFT
	MOVI	ADJHSRES,A0
	CALLA	GET_ADJ			;IS IF OFF?
	JRZ	DOHSOFF			;YEP...PRINT IT

;mdp	CALLA	GET_HSC			;GET THE COUNTER VALUE
;mdp	MOVE	A0,A3
;mdp	JRUC	NUMBER_WORK		;AND SHOW IT!

DOHSOFF
	MOVI	MESS_AUD_NUM,A8
	CALLA	LM_SETUP		;SETUP FOR AUDIT PRINTING.
	MOVE	@LASTCOLOR,A5,L
	MOVI	M_HSOFF,A8		;THIS EFFECTIVELY ERASES LINE!
	JAUC	RIGHT_FINISH

**************************************************************************
*								         *
* 	GET_STARTS							 *
* 									 *
* 	RETURN THE TOTAL GAME STARTS					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A2	TOTAL GAME STARTS				 *
*								         *
**************************************************************************
GET_STARTS:
        MMTM    SP,A0,A1
        MOVI    AUDSTART,A0
        CALLA   GET_AUD
        MOVE    A1,A2
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*								         *
* 	GET_CONTS							 *
* 									 *
* 	RETURN TOTAL GAME CONTINUES IN A2				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A2	TOTAL GAME CONTINUES				 *
*								         *
**************************************************************************
GET_CONTS:
        MMTM    SP,A0,A1
        MOVI    AUDCONTTAKEN,A0
        CALLA   GET_AUD
        MOVE    A1,A2
	MMFM    SP,A0,A1
	RETS


**************************************************************************
*								         *
* 	GET_PLAYS							 *
* 									 *
* 	RETURN THE TOTAL PLAYS ( STARTS + CONTINUES )			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A2	TOTAL PLAYS					 *
*								         *
**************************************************************************
GET_PLAYS:
        MMTM    SP,A0
        CALLR   GET_STARTS
        MOVE    A2,A0
        CALLR   GET_CONTS
        ADD     A0,A2
	MMFM    SP,A0
	RETS

DO_PTIME
	MOVI	AUDPTIME,A0
	JRUC	TIMEGO

DO_AVGTC
	CLR	A3
	MOVI	AUDNUMTC,A0
	CALLA	GET_AUD		; GET THE DIVISOR
	MOVE	A1,A2
	JRZ	DTCGO		; NO /0'S HERE, BUD
	MOVI	AUDAVGTC,A0
	CALLA	GET_AUD		; GET TOTAL TIME
	CLR	A0
	DIVU	A2,A0		; A0 CONTAINS THE REAL NUMBER
	MOVE	A0,A3		; NUMBER TO DISPLAY
DTCGO
	JRUC	PLOTTIME

**************************************************************************
*								         *
* 	SET_AVGWAVE							 *
* 									 *
* 	CALL FOR SETTING THE AVERAGE WAVE				 *
* 									 *
* 	ENTRY								 *
* 		A1	WAVE REACHED					 *
* 									 *
* 	EXOT								 *
* 		NOTHING							 *
* 									 *
* 	CALL								 *
* 		CALL							 *
*								         *
**************************************************************************

SET_AVGWAVE:
	MMTM	SP,A0,A1,A2
	MOVE	A1,A2			; SAVE AWAY FOR POSTERITY
	MOVI	AUDNUMTG,A0
	CALLA	AUD1
	MOVI	AUDWAVECNT,A0		; WAVE COUNTER THINGIE
	CALLA	GET_AUD
	ADD	A2,A1
	CALLA	STORE_AUDIT
	MOVI	AUDAVGGC,A0
	CALLA	GET_AUD
	MOVE	@GAMEUNITS,A2,W		; UNITS USED IN THIS GAME
	ADD	A2,A1
	CALLA	STORE_AUDIT
	MMFM	SP,A0,A1,A2
	RETS

DO_AVGWAVE
	CLR	A3
	MOVI	AUDNUMTG,A0
	CALLA	GET_AUD		; GET THE DIVISOR
	MOVE	A1,A2
	JRZ	DAWAVEGO 	; NO /0'S HERE, BUD
	MOVI	AUDWAVECNT,A0
	CALLA	GET_AUD		; GET TOTAL TIME
	CLR	A0
	DIVU	A2,A0		; A0 CONTAINS THE REAL NUMBER
	MOVE	A0,A3		; NUMBER TO DISPLAY
DAWAVEGO
	JAUC	NUMBER_WORK

*
*CALCULATE PERCENTAGE OF CONTINUES TAKEN
*
DO_PCTCONT
	CLR	A3
	MOVI	AUDCONTOFFER,A0
	CALLA	GET_AUD		;CONTINUES OFFERED IS THE DIVISOR
	MOVE	A1,A2
	JRZ	DAPCTGO		;BR = 0 NOT ALLOWED IN THIS DIVIDE

	MOVI	AUDCONTTAKEN,A0
	CALLA	GET_AUD		;CONTINUES TAKEN IS THE DIVIDEND
	MOVI	100,A0		;MAKE IT A PERCENTAGE
	MPYU	A0,A1
	DIVU	A2,A1		;AND GET IT
	MOVE	A1,A3		;NUMBER TO DISPLAY
DAPCTGO
	JAUC	NUMBER_WORK

DO_AVGGC
	CLR	A3
	MOVI	AUDNUMTG,A0
	CALLA	GET_AUD		; GET THE DIVISOR
	MOVE	A1,A2
	JRZ	DAGCGO 		; NO /0'S HERE, BUD
	MOVI	AUDAVGGC,A0
	CALLA	GET_AUD		; GET TOTAL CREDITS
	CLR	A0
	DIVU	A2,A0		; A0 CONTAINS THE REAL NUMBER
	MOVE	A0,A3		; NUMBER TO DISPLAY
DAGCGO
	JAUC	NUMBER_WORK



DO_UPTIME
	MOVI	AUDUPTIME,A0
	JRUC	TIMEGO

DO_AVGTL
	CLR	A3
	MOVI	AUDNUMTL,A0
	CALLA	GET_AUD		; GET THE DIVISOR
	MOVE	A1,A2
	JRZ	DTLGO		; NO /0'S HERE, BUD
	MOVI	AUDAVGTL,A0
	CALLA	GET_AUD		; GET TOTAL TIME
	CLR	A0
	DIVU	A2,A0		; A0 CONTAINS THE REAL NUMBER
	MOVE	A0,A3		; NUMBER TO DISPLAY
DTLGO
	JRUC	PLOTTIME

DO_P1TIME
	MOVI	AUD1TIME,A0
	JRUC	TIMEGO

DO_P2TIME
	MOVI	AUD2TIME,A0
	JRUC	TIMEGO

DO_P3TIME
	MOVI	AUD3TIME,A0
	JRUC	TIMEGO

TIMEGO
	CALLA	GET_AUD
	MOVE	A1,A3
	JRUC	PLOTTIME

**************************************************************************
*								         *
* 	PLOTTIME								 *
* 									 *
* 	PLOT OUT THE TIME SPECIFIED IN A3				 *
* 									 *
* 	ENTRY								 *
* 		A3	TIME ( IN SECONDS )				 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

PLOTTIME:
	MOVI	MESS_AUD_NUM,A8
	CALLA	LM_SETUP
	MOVE	@LASTCOLOR,A5,L

	MMTM	SP,A0,A1,A2,A7,A9,A10,A11
	CLR	A9			; NO SECONDS
	CLR	A10			; NO MINUTES
	CLR	A11			; NO HOURS
	MOVI	STRINGF_RAM,A7		; STRING TO BUILD IN
	MOVE	A3,A1			; BASE VALUE
	JRZ	PNOTIME

	CLR	A0			; DIVIDEND IN <A0><A1>
	MOVI	60,A2			; 60 SECS/MINUTE
	DIVU	A2,A0			; A0 = MINUTES, A1 = SECONDS
	MOVE	A1,A9			; SET SECONDS
	MOVE	A0,A1			; MINUTES/HOURS
	JRZ	PNOTIME
	CLR	A0
	DIVU	A2,A0			; A0 = HOURS, A1 = MINUTES
	MOVE	A1,A10
	MOVE	A0,A11

PNOTIME
	MOVE	A11,A0
	JRZ	PNOHOURS
	CALLA	CAT_A0			; HOURS
	MOVI	ME_COLON,A8
	CALLA	STRCAT
PNOHOURS
	MOVE	A10,A0
	CMPI	10,A0
	JRHS	P1
	MOVE	A11,A11			; NO LEADING ZERO IF NO HOURS
	JRZ	P1
	CLR	A0
	CALLA	CAT_A0			; INSERT EXTRA ZERO
	MOVE	A10,A0
P1
	CALLA	CAT_A0			; MINUTES
	MOVI	ME_COLON,A8
	CALLA	STRCAT
	MOVE	A9,A0
	CMPI	10,A0
	JRHS	P2
	CLR	A0
	CALLA	CAT_A0			; INSERT EXTRA ZERO
	MOVE	A9,A0
P2
	CALLA	CAT_A0			; SECONDS
	MMFM	SP,A0,A1,A2,A7,A9,A10,A11
	MOVI	STRINGF_RAM,A8
	JSRP	RIGHT_FINISH
	RETP

ME_COLON:
	.STRING	":",0
	.EVEN

**************************************************************************
*								         *
* DO_MONEY - ROUTINE TO OUTPUT MONEY TOTALS FOR A GIVEN STANDARD COINAGE *
* 		IF THE COINAGE IS CUSTOM, IT JUST TOTALS COINS		 *
* 		RECEIVED IN COIN SLOTS.  USED ON THE DETAILED		 *
* 		BOOKKEEPING PAGE.					 *
*								         *
**************************************************************************
DO_MONEY:
	MOVI	COLOR_PWHITE,A8
	MOVE	A8,@LASTCOLOR,L			; A GROSS KLUDGE
	MOVE	*A13(AT_Y),A8,W
	ADDI	10H,A8
	MOVE	A8,*A13(AT_Y),W
	MOVI	MESS_AUD_NUM,A8
	MOVE	@PTSIZE,A14,W
	JRZ	DO_M_GO
	MOVI	MESS15_AUD_NUM,A8
DO_M_GO
	CALLA	LM_SETUP
	MOVE	@LASTCOLOR,A5,L
	MMTM	SP,A0,A1,A2,A3,A4,A5,A7,A10,A11

	CALLR	BEGIN_AUDIT		;KEEP TRACK OF SANITY OF CALC.
	MOVI	AUDLCOIN,A8		;NOW PRINT MONEY FOR THE CHUTES

	CALLR	SUM_COINS

	MOVK	1,A0			;DIVIDE COINS BY 1 IF ITS BEEN TAMPERED WITH
	CALLR	SIXP
	JRZ	DIV_BY_1		;TAMPERED WITH...DIVIDE BY 1 FOR "COINS"

	MOVI	ADJCDIV,A0		;GET THE COIN PARTS PLEASE
	CALLA	GET_ADJ
DIV_BY_1
	MOVE	A2,A11                ;SETUP <A10><A11> AS DIVIDEND
	CLR	A10
	DIVU	A0,A10		      ; DOLLARS IN A10, CHANGE IN A11
	MOVI	100,A5
	DIVU	A0,A5
	MPYU	A5,A11

	MOVI	STRINGF_RAM,A7		; STRING TO BUILD IN
	CALLR	SIXP			;HAVE THE 6 BEEN TAMPERED
	JRZ	NO_PREFIX
	CALLA	GET_CSPT
	MOVE	*A6(CS_LMES),A8,L
	CALLA	STRCAT
NO_PREFIX

	MOVE	A0,A2			;KEEP DIVISOR FOR CHECK
	MOVE	A10,A0
	CALLA	CAT_A0			;STUFF IN THE WHOLE GRAIN VALUE
	CMPI	1,A2			;WE'RE WE DEALING FRACTIONS?
	JREQ	NO_FRACTION		;BR = NO
	MOVI	PERIODSIGN,A8
	CALLA	STRCAT
	CMPI	10,A11
	JRHS	DM2
	CLR	A0
	CALLA	CAT_A0
DM2
	MOVE	A11,A0
	CALLA	CAT_A0
NO_FRACTION
	CALLR	SIXP			;HAVE THE 6 BEEN TAMPERED
	JRZ	NO_SUFFIX
	MOVE	*A6(CS_RMES),A8,L
	CALLA	STRCAT
NO_SUFFIX

	MMFM	SP,A0,A1,A2,A3,A4,A5,A7,A10,A11
	MOVI	STRINGF_RAM,A8
	JSRP	RIGHT_FINISH
	RETP

**************************************************************************
*                                                                        *
*          SUM_COINS                                                     *
*                                                                        *
*          A8 HAS FIRST OF THE "CHUTES" AUDIT NUMBERS OF INTEREST        *
*                                                                        *
*          RETURN COINS TIMES THEIR FACTORS IN A2.                       *
*                                                                        *
**************************************************************************
SUM_COINS
	MMTM	SP,A0,A1,A3,A6,A4

	MOVE	A8,A0			;POINT AT AUDIT NUMBER
	CLR	A2			;SUM = ZERO

	CALLA	GET_CSPT		;A6 POINTS AT CSELECT TABLE
	ADDI	CS_LVAL,A6		;POINT AT 1ST MULTIPLIER

	MOVI	CHUTES,A4		;NOW...ITERATE OVER THE CHUTES

NEXT_CHUTE
	MOVE	*A6+,A3,W		;GET MULTPLIER FOR THIS CHUTE
	CALLR	FIX_A3			;REPLACE A3 WITH 1 (MULTIPLIER) IF
*					;ITS SOME CUSTOM MODE.
	CALLR	ADD_AUD_A0_TIMES_A3_TO_A2
	INC	A0			;NEXT AUDIT
	DSJS	A4,NEXT_CHUTE

	MMFM	SP,A0,A1,A3,A6,A4
	RETS

ADD_AUD_A0_TIMES_A3_TO_A2
	CALLA	GET_AUD			;FETCH THE AUDIT
	MPYU	A1,A3			;TIME THE FACTOR
	ADD	A3,A2
	RETS

**************************************************************************
*                                                                        *
*          FIX_A3                                                        *
*                                                                        *
*          THIS IS CALLED BY THE LOW LEVEL MONEY TOTALIZER.              *
*          THE MULTIPLIER FOR THE COIN SLOT THAT ITS WORKING             *
*          ON IS IN A3.  WE REPLACE IT WITH "1" TO SUM "TOTAL COINS"     *
*          IF ITS IN A NON-STANDARD COIN MODE.                           *
*                                                                        *
**************************************************************************
FIX_A3
	CALLR	SIXP			;HAS IT BEEN TAMPERED WITH?
	JRNZ	FIX_A3X			;NOPE...LEAVE A3
	MOVK	1,A3
FIX_A3X
	RETS

**************************************************************************
*                                                                        *
*          SIXP                                                          *
*                                                                        *
*          THIS IS CALLED TO SEE IF THE 1ST 6 COIN PARAMETERS HAVE       *
*          BEEN TAMPERED WITH.                                           *
*                                                                        *
*          .EQ.            YES                                           *
*          .NE.            NO                                            *
*                                                                        *
**************************************************************************
SIXP
	MMTM	SP,A0
	MOVI	ADJ1ST6,A0
	CALLA	GET_ADJ              ;HAS IT BEEN TAMPERED WITH?
	MMFM	SP,A0
	RETS

PERIODSIGN:
	.STRING	".",0
	.EVEN

**************************************************************************
*								         *
* 	UTILITY ROUTINES FOR UTILITIES MENU				 *
*								         *
**************************************************************************
DO_CLCRED
	MOVI	MESS_CLCRED,A8		;CLEAR COIN SUB-TOTALS...ARE YOU SURE
	MOVI	CLR_CREDITS,A9		;ROUTINE TO DO IT
	MOVI	MESS_CCCONF,A10		;CONFIRMATION.
	JAUC	AREUSURE		;ASK EM......THEN RETURN!

CLR_CREDITS
	CALLA	NO_CREDS		;CALL THE ROUTINE THAT DOES IT
	RETP

DO_CLCOIN
	MOVI	MESS_CLCOIN,A8		;CLEAR COIN SUB-TOTALS...ARE YOU SURE
	MOVI	CLR_COINS,A9		;ROUTINE TO DO IT
	MOVI	MESS_CCNCONF,A10	;CONFIRMATION.
	JAUC	AREUSURE		;ASK EM......THEN RETURN!

CLR_COINS
	MOVI	FRST_C,A0
	MOVI	LAST_C,A1
	CALLA	CLR_AUDR
         RETP

DO_CLAUD
	MOVI	MESS_CLAUD,A8		;CLEAR COIN SUB-TOTALS...ARE YOU SURE
	MOVI	CLR_AUDITS,A9		;ROUTINE TO DO IT
	MOVI	MESS_CAUDCONF,A10	;CONFIRMATION.
	JAUC	AREUSURE		;ASK EM......THEN RETURN!

CLR_AUDITS
	MOVI	FRSTGAUD,A0
	MOVI	LASTGAUD,A1
	CALLA	CLR_AUDR
	CALLA	DUMP_FS			;AND START THE "DUMP" RECORDS OVER
	RETP

DO_HSRES
	MOVI	MESS_HSRESET,A8
	MOVI	HSSOFT,A9
	MOVI	MESS_HSRCONF,A10
	JAUC	AREUSURE

HSSOFT
	CALLR	RES_ALL
	RETP				;PROGRAM TO DO THE JOB!

**************************************************************************
*								         *
* 	RES_ALL								 *
* 									 *
* 	RESET THE ALL TIME HIGHSCORE TABLE AND THE RESET COUNTER	 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
RES_ALL:
;	MOVI	ALL_TAB,A8		;ALWAYS CLEAR OUT TODAYS TABLE
;	CALLA	INIT_TB
;	CALLA	INIT_HSR		;RE-SET THE HIGH SCORE RESET COUNTER
	RETS

**************************************************************************
*                                                                        *
*          MONITOR PATTERNS                                              *
*                                                                        *
**************************************************************************
GO_PATTERNS
	MOVI	MEN_PATTERNS,A8		;PUT UP THE MENU AND GO!
	JAUC	GEN_MENU		;THIS WILL RETURN TO LEVEL ABOVE US!
* A1 = <COLOR><PALETTE>
* A3 = DAG OF AREA [YPOS,XPOS]
* A4 = [Y,X] SIZE OF AREA
GO_RED
	MOVI	COLOR_RED,A1
	JAUC	SC_COL
GO_GREEN
	MOVI	COLOR_GREEN,A1
	JAUC	SC_COL
GO_BLUE
	MOVI	COLOR_BLUE,A1
SC_COL
	SLL	16,A1			;PALETTE 0....COLOR UP HIGH
	CLR	A3			;UPPER LEFT
	MOVI	00FF0190H,A4
	CALLA	FILLAREA		;THIS DOES THE SCREEN
	JAUC	WAIT_BUT		;NOW WAIT FOR ANY BUTTON!

**************************************************************************
*								         *
* 	WAIT FOR A BUTTON MENU						 *
*								         *
**************************************************************************
ANY_BUT
         MOVI    ANY_MENU,A8          ;ANY BUTTON TO CONTINUE
         MOVI    1,A9                 ;CURSOR ON ENTRY 1
         JAUC    B_MENU               ;DO IT....RETURN WHEN PRESSED.

**************************************************************************
*                                                                        *
*          WAIT_BUT                                                      *
*                                                                        *
*          THIS IS CALLED ON RETURN FROM MANY OF THE "HARD"              *
*          DIAGNOSTIC TESTS TO HOLD CONTROL TILL ANY BUTTON IS           *
*          HIT.                                                          *
*                                                                        *
**************************************************************************
WAIT_BUT
	PUSHP	A8
	CLR	A8
*WAIT FIRST FOR ALL SWITCHES TO BE OPEN, TIMEOUT IS 8 SECONDS
WB_OPEN_WAIT
	CALLR	READ_SW1_CNS		; XUNIT  HANGOUT FOR A WHILE
	ANDI	00243030H,A0
	CMPI	00243030H,A0		;ARE ALL SWITCHES OFF?
	JREQ	WB_GO			;BR = YES
	INC	A8
	CMPI	300,A8			;HAVE WE WAITED TOO LONG?
	JRHS	WB_GO
	SLOOP	1,WB_OPEN_WAIT

WB_GO
	PULLP	A8
	MOVE	A0,@SWSET1,L

WB1
	CALLR	CKTEST			; CHECK TEST SWITCHES
	CALLR	READ_SW1_CNS		; XUNIT GOTTA SEE IF TIME TO LEAVE
	ANDI	00243030H,A0
	MOVE	@SWSET1,A1,L
	CMP	A0,A1
	JRNZ	WBEND
	SLEEP	1
	JRUC	WB1
WBEND
	RETP

**************************************************************************
*								         *
* 	CKTEST								 *
* 									 *
* 	CHECK TO SEE IF EITHER OF THE TEST BUTTONS IS CLOSED,		 *
* 	IF NOT, HEAD OUT TO WARMSET					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
CKTEST
	PUSH	A0
	CALLA	READ_DIP
	ANDI	DPTEST,A0
	JRNZ	CKRET
	CALLR	READ_SW1_CNS		; XUNIT
	NOT	A0
	ANDI	00100000H,A0
	JAZ	WARMSET			; WE BE OUTTA HERE!
CKRET
	PULL	A0
	RETS

**************************************************************************
*								         *
* 	CKDIAG								 *
* 									 *
* 	CHECK TO SEE IF WE NEED TO GO OFF TO THE DIAGNOSTICS ROUTINES	 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A0	0 = COOL, 1 = GO TO DIAGS			 *
*								         *
**************************************************************************
CKDIAG
	CLR	A0
	CALLA	READ_DIP
	ANDI	DPTEST,A0
	JRNZ	CKDGO
	CALLR	READ_SW1_CNS		; XUNIT
	NOT	A0
	ANDI	00100000H,A0
	JRZ	CKDRET
CKDGO
	MOVK	1,A0
CKDRET
	MOVE	A0,A0
	RETS

**************************************************************************
*                                                                        *
*          FORCE_MAIN                                                    *
*                                                                        *
*          THIS IS CALLED TO GET TO MAIN MENU FROM LEVEL FURTHER         *
*          THAN 1 DOWN.  IT SETS THE GLOBAL FLAG "MAIN_RET"              *
*          NON ZERO.  GEN_MENU WILL KEEP RETURNING UNTIL                 *
*          IT GETS BACK TO THE MAIN MENU.                                *
*                                                                        *
**************************************************************************
FORCE_MAIN
	MOVK	1,A0			;POSITIVE NUMBER FORCES MAIN MENU.
	MOVE	A0,@MAIN_RET,W
	RETP				;NOW "RETURN TO THE MENU"


**************************************************************************
*                                                                        *
*          GEN_MENU                                                      *
*                                                                        *
*          THIS IS A GENERAL MENU HANDLER.  IT POSTS THE MENU            *
*          WITH SELECTION 1 AVAILABLE.  AFTER A SELECTION IS             *
*          MADE, IF IT HAS A ROUTINE CODE OF ZERO, (EXIT)                *
*          IT RETURNS TO THE LEVEL ABOVE IT.  ELSE, IT                   *
*          JSRP'S THE NEW ROUTINE.  WHEN THE NEW ROUTINE                 *
*          RETURNS, WE RE-POST THE SAME MENU WITH THE                    *
*          BAR ON THE FOLLOWING ENTRY.                                   *
*                                                                        *
*          A8 = MENU DESCRIPTOR                                          *
*                                                                        *
**************************************************************************
*
*        MENU ROM OFFSETS
*
MR_FONT  EQU     0
MR_TCAL  EQU     MR_FONT+LONG_SIZE
MR_TITLE EQU     MR_TCAL+LONG_SIZE    ;POINTER TO TITLE FOR TILE BOX (IF NEC)
MR_TCLR  EQU     MR_TITLE+LONG_SIZE   ;COLOR OF TITLE
MR_WORDS EQU     MR_TCLR+WORD_SIZE    ;STREAM OF WORDS TO COPY TO PDATA STARTS HERE
MR_X     EQU     MR_WORDS
MR_Y     EQU     MR_X+WORD_SIZE
MR_DY    EQU     MR_Y+WORD_SIZE
MR_COL   EQU     MR_DY+WORD_SIZE
MR_HITE  EQU     MR_COL+WORD_SIZE
MR_BDY   EQU     MR_HITE+WORD_SIZE
MR_DX    EQU     MR_BDY+WORD_SIZE
MR_WID   EQU     MR_DX+WORD_SIZE

GEN_MENU
	CALLR	CKTEST			;ROUND ABOUT 100 ON PLOTBUG
	MOVE	@GMENULEV,A0,W		;KICK LEVEL POINTER
	INC	A0
	MOVE	A0,@GMENULEV,W
*
	MOVE	A8,-*A12,L		;SAVE MENU PTR
	MOVI	1,A8			;START WITH "FIRST" ENTRY
	MOVE	A8,-*A12,W		;PUT MENU NUMBER AS A WORD
*
*	IF WE GET HERE AND MAIN_RET IS NOT ZERO, THE WE MUST
*	RETURN TO LEVEL ABOVE US IF WE'RE NOT THE MAIN
*	MENU.
*
GEN_LOOP
	MOVE	@MAIN_RET,A0,W		;ARE WE IN "EXIT" MODE?
	JRZ	NO_EXIT			;NO

	JRN	DIVE_TO_MONITOR		;WE'RE DIVING TO MONITOR PATTERNS.

	MOVE	@GMENULEV,A0,W		;CHECK LEVEL
	CMPI	1,A0			;ARE WE AT LEVEL 1
	JRNZ	GEN_EXIT		;NOPE.....POP UP A LEVEL.
*
*	WE'RE AT LEVEL 1....CLEAR OUT THE FLAG THAT
*	GOT US HERE.
*
DIVE_COMPLETE
	CLR	A0
	MOVE	A0,@MAIN_RET,W		;NOW WE MAY PROCEED!

NO_EXIT
	MOVE	@NO_CLEAR,A0,W		;INHIBIT CLEAR?
	JRNZ	SKIP_CLR

	CALLA	CLR_SCRN		;CLEAR THE SCREEN

SKIP_CLR
	CLR	A0
	MOVE	A0,@NO_CLEAR,W		;AND RE-SET IT!

	MOVE	*A12(WORD_SIZE),A8,L	;GET MENU DESCRIPTOR
	JSRP	MENU_TOP
	JSRP	CYAN_BOX		;PUT UP MAIN MENU INSTRUCTIONS

	MOVE	*A12,A9,W		;GET MENU NUMBER TO USE
	JSRP	B_MENU			;GET RESULT

PHONEY_MENU_RET
	MOVE	A10,A10			;WAS IT ADVANCE?
	JRZ	NO_KICK			;NOPE....LEAVE WHERE HE CAME FROM

	INC	A8			;KICK INDEX BY 1 FOR NEXT TIME
NO_KICK
	MOVE	A8,*A12,W		;AND LEAVE ON THE STACK

	MOVE	A9,A9			;NOW JSRP THE ROUTINE
	JRZ	GEN_EXIT		;NONE THERE....ITS "EXIT"
*
*	JSRP TO A9
*
	MOVI	GEN_LOOP,A7
	MOVE	A7,-*A12,L		;PUSH RET ADDR
	JUMP	A9

GEN_EXIT
	ADDI	WORD_SIZE+LONG_SIZE,A12	;POP THE ARGUMENTS
	MOVE	@GMENULEV,A0,W		;KICK LEVEL POINTER
	DEC	A0
	MOVE	A0,@GMENULEV,W
	RETP

**************************************************************************
*                                                                        *
*          DIVE_TO_MONITOR                                               *
*                                                                        *
*          WE GET CONTROL HERE WHEN WE ARE KLUDGING THE RETURN           *
*          FROM "CPU" TEST (WHICH BLOWS AWAY RAM!)                       *
*                                                                        *
**************************************************************************
DIVE_TO_MONITOR
         MOVE    @GMENULEV,A0,W            ;CHECK LEVEL
         CMPI    1,A0                      ;ARE WE AT LEVEL 1
         JRNZ    DTM1                      ;NOPE....SET "MONITOR" LEVEL
*
*        WE'RE AT LEVEL 1......."SELECT" THE DIAGNOSTIC MENU
*        A8 = 1.....A9 = ROUTINE FOR DIAGNOSTIC MENU
*
         MOVK    1,A8
         MOVI    GO_DIAG,A9           ;ROUTINE FOR DIAGNOSTIC MENU
         MOVK    1,A10                ;RETURN AS IF ADVANCE WAS PRESSED
         JRUC    PHONEY_MENU_RET      ;WE'RE READY TO CALL DIAG MENU
*
*        WE'RE IN DIAGNOSTIC MENU....NOW WE JUST NEED TO MAKE
*        THE "CURRENT" SELECTION THE ONE AFTER CPU TEST
*        (MONITOR PATTERNS)
*
DTM1     MOVE    @MAIN_RET,A8,W            ;FLAG IS OPPOSITE OF ENTRY NUMBER
         NEG     A8                        ;THIS IS RETURN LEVEL!
         MOVI    RTR_LEV,A8                ;START WITH "RETURN" ENTRY NUMBER
         MOVE    A8,*A12,W                 ;PUT MENU NUMBER AS A WORD
         JRUC    DIVE_COMPLETE             ;THIS COMPLETES THE DIVE!

*
*          FOR DOBORDER
*
*          A4 = UPPER LEFT Y,X
*          A5 = LOWER RIGHT Y,X
*          A0 = Y,X WIDTH OF BORDER
*          A9 = COLOR OF BORDER.

**************************************************************************
*                                                                        *
*          TOP_BOX                                                       *
*                                                                        *
*          THIS DISPLAYS THE TEST BOX AT THE TOP.                        *
*                                                                        *
*          A2 POINTS AT THE STRING TO CENTER IN THE BOX.                 *
*          A3 IS COLOR TO DO IT IN.                                      *
*                                                                        *
**************************************************************************
MENU_TOP
	MOVE	*A8(MR_TITLE),A2,L	;GET TITLE INTO A2
	MOVE	*A8(MR_TCLR),A3,W	;AND COLOR INTO A3

TOP_BOX
	MOVE	A8,-*A12,L		;PUSH MENU PTR
*
*	FIRST MAKE THE BOX...IT BLACKS OUT THE REGION
*
	CALLR	SCR_BOX			;PUT UP THE TITLE BOX

	MOVI	MESS_TITLE,A8		;SET PARAMETERS
	CALLA	LM_SETUP		;PUT IT OUT.

	MOVE	A2,A8			;GET STRING IN THE CORRECT REGGIE
	MOVE	A3,A6			;MOVE COLOR TO COLOR REGGIE
;	MOVE	A3,A5			;FIXING THIS WOULD BREAK EVERYTHING!
*
	JSRP	PRINTF		;AND PRINT IT!

	JSRP	SCR_REV			;NOW ADD THE REV.

	MOVE	*A12+,A8,L		;RESTORE THE MENU PTR

	RETP

**************************************************************************
*								         *
*          SCR_REV							 *
* 									 *
*          DISPLAY REV IN TITLE BOX.					 *
*								         *
**************************************************************************
SCR_REV
	MOVI	MESS_REV,A8	;GET READY FOR REV MESSAGE
	CALLA	LM_SETUP	;SETUP FOR REV MESSAGE

	MOVI	ROM_NAME,A8	;USE ROM COPY OF REV.
	JSRP	PRINTF	;FINISH PRINTING MESSAGE
	RETP

**************************************************************************
*								         *
*          SCR_REV_OBJ							 *
* 									 *
*          DISPLAY REV IN TITLE BOX AS OBJECTS				 *
*								         *
**************************************************************************
SCR_REV_OBJ
	MOVI	MESS_REV,A8	;GET READY FOR REV MESSAGE
	CALLA	LM_SETUP	;SETUP FOR REV MESSAGE
	MOVI	STRCNRMO,A1
	MOVI	ROM_NAME,A8	;USE ROM COPY OF REV.
	JSRP	PRINTF	;FINISH PRINTING MESSAGE
	RETP

**************************************************************************
*                                                                        *
*          SCR_BOX                                                       *
*                                                                        *
*          THIS DISPLAYS THE TITLE BOX.                                  *
*                                                                        *
**************************************************************************
SCR_BOX
	MOVI	TIT_ULX+(10000H*TIT_ULY),A4	;UPPER LEFT
	MOVI	TIT_LRX+(10000H*TIT_LRY),A5	;LOWER RIGHT
	MOVI	COLOR_YELLOW,A9
	CALLR	STD_BORD	;TACO BELL HAS YOUR ORDER, MAKE A RU-UUUN......
	RETS

**************************************************************************
*								         *
*          SCR_BOX_OBJ							 *
* 									 *
*          THIS DISPLAYS THE TITLE BOX AS OBJECTS			 *
*								         *
**************************************************************************
SCR_BOX_OBJ
	MOVI	COLOR_PYELLOW,A1
	MOVI	TIT_ULX+(10000H*TIT_ULY),A3	;UPPER LEFT
	MOVI	MB_XWID,A2			;LINE THICKNESS
	MOVI	(TIT_LRX+(10000H*TIT_LRY))-(TIT_ULX+(10000H*TIT_ULY)),A0 ;SIZE
	CALLA	DRAWBOX_OBJ			;DRAW DAT BOX
	RETS

**************************************************************************
*                                                                        *
*          REV_TO_PDATA                                                  *
*                                                                        *
*          THIS COPIES THE CURRENT REV. DATA TO THE                      *
*          CALLING (CONTROLLING) PROCESSES' PDATA AREA.                  *
*                                                                        *
**************************************************************************
*                                                                        *
* REV_TO_PDATA                                                           *
*          MMTM    SP,A2,A7,A6,A0                                        *
*          CALLA   ADJ_PAGE                                              *
*          MOVI    NAME_REV,A7          ;POINT AT CMOS NAME STORAGE      *
*          MOVE    A13,A6               ;POINT WITH A6                   *
*          ADDI    PDATA,A6                                              *
*          MOVI    NAME_REV_SIZE,A2     ;MAXIMUM NAME SIZE               *
*                                                                        *
* REV_XFER_LOOP                                                          *
*          CALLA   RC_BYTEI             ;FETCH A BYTE                    *
*          MOVB    A0,*A6               ;PUT IN PROCESS AREA             *
*          ADDI    BYTE_SIZE,A6         ;PUSH THIS POINTER               *
*          DSJS    A2,REV_XFER_LOOP                                      *
*                                                                        *
*          CLR     A0                   ;STORE A ZERO BEYOND IN CASE ITS *
*          MOVE    A0,*A6,W             ;2 BYTES DOESN'T HURT            *
* 	MMFM    SP,A2,A7,A6,A0                                          *
* 	RETS                                                            *
*                                                                        *
**************************************************************************
*
*        THIS PRINTS THE "MOVE JOYSTICK" BOX.
*
*        A8 = MENU DESCRIPTOR THAT WILL ACCOMPANY IT
*        ON SCREEN.  WE ADJUST THE BOX EDGES AND
*        MESSAGE CENTER IN "X" ONLY TO CORRESPOND
*        TO THE MENU BOX.
*
CYAN_BOX
	MOVE	A8,-*A12,L		;PUSH THE MENU PTR

	MOVI	COLOR_RED,A9
	CALLR	COL_INST		;THIS PRINTS BOX AND STASHES
*					;CENTER X AT *A13(PDATA),W

	MOVI	MM_INST1,A8		;POINT AT INSTRUCTIONS MESSAGE
	JSRP	C_PD_M

	MOVI	MM_INST2,A8		;POINT AT INSTRUCTIONS MESSAGE
	JSRP	C_PD_M

	MOVE	*A12+,A8,L		;GET BACK MENU PTR.
	RETP

**************************************************************************
*                                                                        *
*          COL_INST                                                      *
*                                                                        *
*          THIS PRINTS OUT THE "CYAN" INSTRUCTION BOX                    *
*          IN THE COLOR SPECIFIED BY A9.                                 *
*                                                                        *
**************************************************************************
COL_INST
*
*	WE NEED TO DETERMINE LEFT AND RIGHT X
*
	CALLR	STUFF_MENU_PROCESS		;MOVE DATA INTO PDATA AREA
	CALLR	MEN_NUMS			;GET THE NUMBERS FOR THIS MENU
	MOVE	A6,*A13(PDATA),W		;STASH THE X CENTER
	ADDI	10000H*INST_ULY,A4		;UPPER LEFT Y
	ADDI	10000H*INST_LRY,A5		;UPPER LEFT X
	CALLR	STD_BORD	;TACO BELL HAS YOUR ORDER, MAKE A RU-UUUN......
	RETS

**************************************************************************
*                                                                        *
*          MEN_NUMS                                                      *
*                                                                        *
*          THIS IS CALLED TO GET SOME NUMBERS ASSOCIATED                 *
*          WITH A MENU BOX.                                              *
*                                                                        *
*          THIS RETURNS:                                                 *
*                                                                        *
*          A4 = LEFT X                                                   *
*          A5 = RIGHT X                                                  *
*          A6 = CENTER X                                                 *
*                                                                        *
**************************************************************************
MEN_NUMS
	CALLR	MENU_UL_A4_A5		;LEFT X IN A4
	CALLR	MENU_LR_A6_A5		;RIGHT X IN A6
	MOVE	A6,A5			;COPY RIGHT X INTO A5
	ADD	A4,A6			;FIND CENTER
	SRL	1,A6			;A6 NOW HAS CENTER X (FOR LATER)
	RETS

**************************************************************************
*                                                                        *
*          C_PD_M                                                        *
*                                                                        *
*          THIS PRINTS A L_MESS MESSAGE PASSED IN A8, CENTERED           *
*          ON THE X STORED AT *A13(PDATA),W                              *
*                                                                        *
**************************************************************************
C_PD_M
	CALLA	LM_SETUP		;SETUP THE MESSAGE
	ANDI	0FFFF0000H,A9		;REMOVE X
	MOVE	*A13(PDATA),A3,W	;GET THE X
	ADD	A3,A9			;PUT OUR X IN
;	JUMP	A1			;AND "CALL" THE ROUTINE
	JAUC	PRINTF

**************************************************************************
*                                                                        *
*          WT_ADV                                                        *
*                                                                        *
*          WAIT TILL ADVANCE.  THIS HOLDS CONTROL UNTIL ADVANCE          *
*          BUTTON IS PRESSED.                                            *
*                                                                        *
**************************************************************************
WT_ADV
	SLEEP	2
WT_A6
	CALLR	GET_ADV			;SCAN THE BUTTON
	JRNZ	WT_ADV			;NOT PRESSED.
	RETP

BEEP_1	.WORD	0F3DFH,010H,08082H,0	;MENU ITEM SCAN SOUND
WOLF	.WORD	0F3DFH,010H,080AEH,0	;MENU ITEM SELECT SOUND
UHOH	.WORD	0F3DFH,010H,0813AH,0	;FAILURE OF ANY KIND

**************************************************************************
*                                                                        *
*          WW_ADV                                                        *
*                                                                        *
*          WAIT WHILE ADVANCE.  THIS HOLDS CONTROL WHILE ADVANCE         *
*          BUTTON IS HELD (OR STUCK).                                    *
*                                                                        *
**************************************************************************
WW_ADV
	SLEEP	2
	CALLR	GET_ADV
	JRZ	WW_ADV
	RETP

**************************************************************************
*                                                                        *
*          GET_ADV                                                       *
*                                                                        *
*          THIS GETS PHYSICAL STATE OF ADVANCE BUTTON.                   *
*                                                                        *
*          .EQ.    PRESSED                                               *
*          .NE.    OPEN                                                  *
*                                                                        *
**************************************************************************
GET_ADV
	MMTM	SP,A0
	MOVE	@COINS,A0,W	;FETCH COIN SWITCHES (LOOKING FOR ADVANCE)
;	ANDI	ADV_BIT,A0	;KEEP ADVANCE BIT.
	MMFM	SP,A0
	RETS

**************************************************************************
*                                                                        *
*          GET_MENU                                                      *
*                                                                        *
*          This routine is called (via JSRP) to display a menu on        *
*          screen and receive a selection from the operator.             *
*                                                                        *
*          The menu descriptor is passed in A8.                          *
*                                                                        *
*          The selection number is returned in a8. (line 1 = 1)          *
*          The routine address is returned in a9.                        *
*          A10 is returned non-zero if advance was the button used       *
*                                                                        *
*          A menu (pointed to by A8) is defined as follows:              *
*                                                                        *
*                      FONT TO BE USED             (LONG)                *
*                      X FOR LEFT MARGIN           (WORD)                *
*                      Y FOR TOP LINE              (WORD)                *
*                      DY PER ENTRY                (WORD)                *
*                      TEXT_COLOR                  (WORD)                *
*                      HEIGHT OF SELECTION BAR     (WORD)                *
*                      DX FROM TOP OF TEXT TO SEL. BAR  (WORD)           *
*                                                                        *
*          A9 POINTS AT ENTRY TO START WITH                              *
*                                                                        *
*          Then for each entry:                                          *
*                                                                        *
*                      TEXT POINTER        (LONG)                        *
*                      ACTIVATION ROUTINE  (LONG)                        *
*                                                                        *
*          The list is terminated by a zero.                             *
*                                                                        *
*          This routine forks a separate process to do the work          *
*          for it.  Therefore the caller has full use of                 *
*          the PDATA area.                                               *
*                                                                        *
**************************************************************************
*
*        Equates for GET_MENU slave process.
*
MEN_OFF	EQU	PDATA			;WORD-OFFSET INTO MENU OF SELECTION
MEN_ROUT EQU	MEN_OFF+WORD_SIZE	;LONG-ROUTINE FOR SELECTION
MEN_ROM	EQU	MEN_ROUT+LONG_SIZE	;LONG-POINTER TO ROM STRUCTURE
MEN_ULX	EQU	MEN_ROM+LONG_SIZE	;WORD-LEFT X  (CENTER X WHEN CENTERING)
MEN_ULY	EQU	MEN_ULX+WORD_SIZE	;WORD-TOP Y
MEN_DY	EQU	MEN_ULY+WORD_SIZE	;WORD-Y UNITS PER ENTRY
MEN_COLR EQU	MEN_DY+WORD_SIZE	;WORD-COLOR FOR ENTRIES
MEN_BAR	EQU	MEN_COLR+WORD_SIZE	;WORD-HEIGHT OF SELECTION BAR
MEN_BDY	EQU	MEN_BAR+WORD_SIZE	;WORD-DY FROM TOP OF TEXT TO TOP OF BAR.
MEN_BDX	EQU	MEN_BDY+WORD_SIZE	;WORD-DX FROM LEFT OF WORD TO LEFT OF BAR
MEN_BWID EQU	MEN_BDX+WORD_SIZE	;WORD-WIDTH OF BAR
MEN_SCOL EQU	MEN_BWID+WORD_SIZE	;WORD-COLOR OF SELECTED TEXT
MEN_TPTR EQU	MEN_SCOL+WORD_SIZE	;LONG-POINTER TO BEGINNING OF TEXT ENTRIES.
MEN_ENTS EQU	MEN_TPTR+LONG_SIZE	;WORD-NUMBER OF ENTRIES IN MENU
MEN_CUR  EQU	MEN_ENTS+WORD_SIZE	;WORD-CURRENT SELECTION (1ST IS 1)
MEN_WALK EQU	MEN_CUR+WORD_SIZE	;WORD-NUMBER OF ENTRY WE'RE ON AS WE WALK
MEN_STIK EQU	MEN_WALK+WORD_SIZE	;LONG-"STUCK" STATE OF SWITCHES
MEN_ACT  EQU	MEN_STIK+LONG_SIZE	;LONG-SWITCH WE'RE ACTING ON. (BIT)
MEN_TYPO EQU	MEN_ACT+LONG_SIZE	;WORD-TYPOMATIC COUNTER
MEN_HITS EQU	MEN_TYPO+WORD_SIZE	;WORD-CONSECUTIVE TYPOMATIC HITS
MEN_ADV  EQU	MEN_HITS+WORD_SIZE	;WORD-NON-ZERO IF ADVANCE WAS BUTTON USED

WORD_ENTS EQU	(MEN_TPTR-MEN_ULX)/WORD_SIZE	;NUMBER OF WORD ENTRIES

B_MENU
	MOVI	BD_SLAVE,A7
	JRUC	GMJMP

GET_MENU
	MOVI	GM_SLAVE,A7		;THIS IS ROUTINE
GMJMP
	MOVI	MENU_PID,A1		;THIS IS ID
	CALLA	GETPRC			;CREATE IT

	MOVE	A0,A10			;SAVE HIS POINTER
GM1
	SLEEP	2

	MOVI	MDUN_PID,A0
	CALLA	EXISTP_ALL		;WAIT FOR ID TO CHANGE TO THIS!

	JRZ	GM1			;LOOP UNTIL IT EXISTS!

	MOVE	*A10(MEN_OFF),A8,W	;RETURN OFFSET OF SELECTION
	MOVE	*A10(MEN_ROUT),A9,L	;AND ROUTINE THAT WAS SELECTED.
	MOVE	*A10(MEN_ADV),A10,W	;INDICATE WHETHER ADVANCE WAS USED

	MOVI	MDUN_PID,A0
	CALLA	KILLPROC_ALL		;KILL THE HANGING MENU GETTER!
	RETP				;AND RETURN

**************************************************************************
*                                                                        *
*          GM_SLAVE                                                      *
*                                                                        *
*          This displays the menu.......moves the selection bar          *
*          and returns the selection information by stuffing             *
*          it in its process area and changing its ID to                 *
*          MDUN_PID once selection is made.                              *
*                                                                        *
*          On entry....A8 points at the GET_MENU data structure.         *
*                      A9 is which entry to start with selected.         *
*                                                                        *
**************************************************************************
BD_SLAVE
	CALLR	MENU_BORDER		;DRAW THE BORDER FOR SELCTIONS.
GM_SLAVE
	JSRP	ST_STICK		;TELL STICK(S) AND BUTTONS WE'RE STARTING.

	CALLR	STUFF_MENU_PROCESS	;MOVE DATA INTO PDATA AREA
*
*	PLOT ENTIRE MENU
*
*	DO_MENU_LINE WILL RETURN CARRY SET
*	WHEN WE GET BEYOND THE END.
*
	MOVK	1,A0			;SETUP FOR LINE 1.
DO_ANOTHER_LINE
	MOVE	A0,*A13(MEN_WALK),W	;WALK THROUGH.

	JSRP	DO_MENU_LINE		;PUT OUT LINE IN A0.
	MOVE	*A13(MEN_WALK),A0,W	;GET BACK THE COUNTER

	INC	A0			;MOVE TO NEXT ENTRY.
	MOVE	*A13(MEN_ENTS),A1,W	;SEE IF WE'RE DONE.
	CMP	A1,A0
	JRLS	DO_ANOTHER_LINE
*
*	MAIN MENU PLOTTED......NOW LET THE DMA UN-LOAD BEFORE PLOTTING HELP
*
	CALLR	PLOT_HELP		;PLOT HELP FOR 1ST IF NECESSARY

*
*	NOW WE JUST WANT TO UPDATE BASED ON STICK...ACT
*	ON BUTTONS!
*
*	RESPONSES:   UP....DOWN....BUTTON....NOTHING....
*
*	NOTHING = 0
*	UP = 1
*	DOWN = 2
*	BUTTON = 3
*
*	A0 = RESPONSE
*	A1 = MEN_CUR VALUE.
*

	CLR	A0
	MOVE	A0,*A13(MEN_HITS),W
	MOVE	A0,*A13(MEN_TYPO),L
MENU_LOOP
	SLEEP   1
        JSRP    GETSTICK		;CHECK OUT THE PLAYER BOARD
        MOVE    A0,A0
	JRNZ	ML1			;BR = GOT SOMETHING
	MOVE	A0,*A13(MEN_HITS),W	;CLEAR TIMER AND DIRECTION
	MOVE	A0,*A13(MEN_TYPO),W
	JRUC	MENU_LOOP
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
	JRLO	MENU_LOOP		;GO BACK TO SLEEP
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
	JRLO	MENU_LOOP		;GO BACK TO SLEEP
	CLR	A0
	MOVE	A0,*A13(MEN_TYPO),W	;CLEAR OUT THE TIMER
	MOVE	*A13(MEN_HITS),A0,W
	ANDI	7H,A0			;TURN OFF REPEAT BIT
MLDONE
	MOVE	*A13(MEN_CUR),A1,W	;GET CURRENT ENTRY...IN A1

	CMPI	3,A0			;BUTTON?
	JRZ	MENU_BUTTON		;YEP....WE'RE OUT OF HERE.

	CMPI	2,A0
	JRZ	MENU_DOWN		;ITS DOWN....
*
*	REQUEST TO GO UP....ARE WE AT #1
*
	CMPI	1,A1			;WELL?
	JRLS	MENU_LOOP		;YEP....IGNORE

	JSRP	UN_SELECT		;PUT BACK THE OLD "CURRENT ONE
	MOVE	*A13(MEN_CUR),A0,W	;GET CURRENT ENTRY
	DEC	A0			;MAKE ONE LESS.
	JRUC	JOIN_DOWN		;NOW PLOT THE NEW ONE.

MENU_DOWN
	MOVE	*A13(MEN_ENTS),A2,W	;GET NUMBER IN MENU
	CMP	A2,A1			;ARE WE AT MAX
	JRHS	MENU_LOOP		;YEP...NO ACTION

	JSRP	UN_SELECT		;PUT BACK THE OLD "CURRENT ONE

	MOVE	*A13(MEN_CUR),A0,W	;GET CURRENT ENTRY
	INC	A0			;MAKE THIS THE NEXT.

JOIN_DOWN
	MOVE	A0,*A13(MEN_CUR),W	;PUT BACK
	JSRP	DO_MENU_LINE		;PUT OUT LINE IN A0.
*
*	MAKE THE "DINK" SOUND HERE FOR ENTRY TO ENTRY MOVEMENT
*
	CALLR	PLOT_HELP		;PLOT HELP NEW ONE
	SLEEP	1			;DELAY BEEP 1 FRAME
;	SOUND1	BEEP_1			;MAKE A BEEP.
	JRUC	MENU_LOOP		;AND WAIT FOR NEXT RESPONSE.
*
*	CONTROL COMES HERE WHEN A BUTTON IS PRESSED
*
*	The selection number is returned in a8. (line 1 = 1)
*	The routine address is returned in a9.

MENU_BUTTON
*
*	A0 HAS A 3.
*	A2 HAS THE BUTTON BIT.....IS IT ADVANCE?
*
	MOVE	*A13(MEN_ROM),A0,L
	CMPI	MEN_ADJ,A0		;SPECIAL CASE FOR MENU ADJ
	JRNZ	MBNOTADJ
	CALLA	CKDIP
	JRNZ	MBNOTADJ		;NOT USING DIP SWITCHES
	MOVE	*A13(MEN_CUR),A0,W	;GET THE SELECT ITEM
	CMPI	2,A0			;"STANDARD PRICING"
	JRZ	MBABORT
	CMPI	3,A0			;"CUSTOM PRICING"
	JRZ	MBABORT
	CMPI	4,A0			;"FREE PLAY"
	JRNZ	MBNOTADJ
MBABORT
;	SOUND1	UHOH
	JRUC	MENU_LOOP
MBNOTADJ
	CLR	A0			;NOT ADVANCE
IS_ADV
	MOVE	A0,*A13(MEN_ADV),W	;NON ZERO IF IT WAS ADVANCE

	JSRP	BUTTON_STALL		;HIGHLIGHT SELECTION AND HANG ON BUTTON

	MOVE	*A13(MEN_CUR),A0,W	;GET "CURRENT" ENTRY.
	CALLR	GET_MENU_DATA		;A1=CURRENT_OFFSET  A2=TEXT  A3=ROUTINE
	MOVE	A0,*A13(MEN_OFF),W	;STORE THE OFFSET (CHOICE NUM)
	MOVE	A3,*A13(MEN_ROUT),L	;AND THE ROUTINE POINTER
	MOVI	MDUN_PID,A0
	MOVE	A0,*A13(PROCID),W	;CHANGE OUR ID.
MENU_DONE
	SLEEP	20
	JRUC	MENU_DONE		;NOW HANG TILL DISPATCHER SEES ID.

**************************************************************************
*                                                                        *
*                 MENU UTILITIES                                         *
*                                                                        *
**************************************************************************
**************************************************************************
*                                                                        *
*          BUTTON_STALL                                                  *
*                                                                        *
*          THIS IS CALLED WHEN THE MENU GETS A BUTTON HIT.               *
*          A1 HAS THE BIT OF THE BUTTON.                                 *
*                                                                        *
*          WE PAINT THE MENU SQUARE TO FEEDBACK THE HIT.                 *
*                                                                        *
*          THEN WE HANG ON THE BUTTON UNTIL ITS LET GO.                  *
*                                                                        *
**************************************************************************
BUTTON_STALL
         MOVE    A2,@LAST_BUT,L       ;PUSH THE BUTTON STATE

         MOVE    @SCODE,A0,W          ;NO CASH FOR REPEAT SOUND CODES
         MOVE    @DCODE,A1,W
         OR      A0,A1
         JRNZ    DONT_WAIT            ;ITS A SOUND REPEAT....DON'T HOLD EITHER!

;         SOUND1  WOLF                 ;MAKE THE CASH SOUND

         MOVE    *A13(MEN_CUR),A0,W   ;GET CURRENT SELECTION
         MOVI    COLOR_YELLOW,A1
         CALLR   MENU_BAR             ;CHANGE THE BAR COLOR.

         CALLR   GET_MENU_DATA             ;GET OUR TEXT POINTER BACK
         MOVI    COLOR_WHITE,A1            ;WHITE ON ORANGE DURING HOT MOMENT
         JSRP    MENU_TEXT                 ;AND WRITE INVERTED TEXT

         MOVE    @LAST_BUT,A8,L            ;GET BUTTON BACK
         MOVI    08H,A9                    ;MINIMUM TIME FOR BUTTON HIGHLITE

         MOVI    2AH,A10              ;.5 SECONDS OF ADVANCE HOLD-DOWN
*                                     ;WILL EXIT TEST MODE.
WAIT_FOR_RELEASE
;         CMPI    ADV_HIGH,A8               ;IS IT ADVANCE BUTTON?
;         JRNZ    NOT_ADV                   ;NOPE.....NEVER MIND

;         DEC     A10                  ;1 LESS TIME UNIT
;         JRZ     DIAG_EX            ;IF HE HOLDS ADVANCE...WE'RE GONE!

NOT_ADV  SLEEP   1

         MOVE    A9,A9                ;REDUCE FOR HELD TIME
         JRZ     WAIT_1               ;ZEROED OUT ALREADY.
         DEC     A9

WAIT_1
         CALLR   FORM_SWS        ;WAIT FOR THIS ONE TO GO TO ZERO
         AND     A8,A0                ;IS OUR BUTTON STILL DOWN?
         JRNZ    WAIT_FOR_RELEASE
*
*        ITS RELEASED...NOW SHOW ORANGE BAR FOR MINIMUM TIME

         INC     A9                   ;MAKE SURE A9 HAS 1 OR MORE
WAIT_2
         SLEEP   1
         DSJS    A9,WAIT_2

DONT_WAIT
         MOVE    *A13(MEN_CUR),A0,W   ;GET CURRENT SELECTION
         CLR     A1                   ;ERASE BAR
         CALLR   MENU_BAR             ;CHANGE THE BAR COLOR.

         CALLR   GET_MENU_DATA             ;GET OUR TEXT POINTER BACK
         MOVE    *A13(MEN_COLR),A1,W       ;RE-PLOT THE NORMAL TEXT
         JSRP    MENU_TEXT

         SLEEP   2                    ;NOW GIVE SOME BOUNCE PROTECTION.

         RETP

**************************************************************************
*                                                                        *
*          STUFF_MENU_PROCESS                                            *
*                                                                        *
*          THIS IS CALLED TO STUFF THE MENU ROM DATA INTO THE            *
*          CURRENT PROCESSES PDATA AREA.                                 *
*                                                                        *
**************************************************************************
STUFF_MENU_PROCESS
         MMTM    SP,A0,A1,A2,A3,A8
         MOVE    A13,A0               ;POINT IN PROCESS AREA
         ADDI    MEN_ROM,A0           ;THIS IS WHERE 1ST TIDBIT GOES
         MOVE    A8,*A0+,L            ;STORE OUR BASE POINTER IN STRUCTURE
         ADDI    MR_WORDS,A8          ;MOVE TO WORD LIST

         MOVI    WORD_ENTS,A2         ;NOW THIS MANY MORE WORDS.

GMS1     MOVE    *A8+,A1,W
         MOVE    A1,*A0+,W
         DSJS    A2,GMS1
*
*        ALL THE MENU PARAMETERS ARE NOW IN THE PDATA AREA.
*        A8 POINTS AT THE FIRST ITEM TO DISPLAY.
*
         MOVE    A8,*A13(MEN_TPTR),L  ;STORE IN PROCESS AREA.
*
*        NOW WE WANT TO FIND THE NUMBER OF ENTRIES IN THE MENU
*
         CLR     A0                        ;START AT #1.
HOW_MANY
         INC     A0                        ;MOVE TO NEXT ENTRY.
         CALLR   GET_MENU_DATA             ;GET THE PARAMETERS FOR THIS ENTRY
         MOVE    A2,A2                     ;AND SEE IF A2=0
         JRNZ    HOW_MANY                  ;ITS REAL.....PUT IT UP.

         DEC     A0                        ;PREVIOUS LINE WAS THE LAST.
         MOVE    A0,*A13(MEN_ENTS),W       ;STUFF NUMBER IN MENU.

         MOVE    A9,A9                     ;DID BOZO PASS ZERO AS CURRENT?
         JRZ     USE_LAST
         CMP     A0,A9                     ;MAKE SURE ITS NOT TOO HIGH
         JRHI    USE_LAST                  ;A9 IS TOO HIGH
         MOVE    A9,A0                     ;USE THE ONE PAST

USE_LAST MOVE    A0,*A13(MEN_CUR),W   ;MAKE ENTRY "1" CURRENT.

	MMFM    SP,A0,A1,A2,A3,A8
	RETS

**************************************************************************
*                                                                        *
*          DO_MENU_LINE                                                  *
*                                                                        *
*          A0 HAS THE LINE TO DO. (1 THROUGH N).                         *
*          PRINT TEXT NORMAL IF NOT "MEN_CUR".                           *
*          PRINT INVERT BAR FOLLOWED BY BLACK TEXT IF                    *
*          ITS THE CURRENT ENTRY.                                        *
*                                                                        *
**************************************************************************
DO_MENU_LINE
         CALLR   GET_MENU_DATA             ;GET "CURRENT" IN A1
         CMP     A0,A1                     ;IS IT "CURRENT" ENTRY?
         JRZ     DO_CURRENT_ENT            ;YEP....DO INVERSE STUFF
*
*        A0 HAS OFFSET (FOR POSITIONING)
*        A2 HAS TEXT POINTER (FOR MESSAGE)
*        A1 NEEDS COLOR FOR MESSAGE.
*
         MOVE    *A13(MEN_COLR),A1,W       ;USE THE NORMAL ENTRY COLOR
         JSRP    MENU_TEXT                 ;PUT UP THE "TEXT" PORTION.
         RETP                              ;AND RETURN

DO_CURRENT_ENT
         MOVI    COLOR_WHITE,A1            ;DO THE BAR IN WHITE (AT A0 HEIGHT)
         CALLR   MENU_BAR                  ;PUT IT UP (A0 PRESERVED)

         CALLR   GET_MENU_DATA             ;GET OUR TEXT POINTER BACK
         MOVE    *A13(MEN_SCOL),A1,W       ;GET "SELECTED" COLOR
         JSRP    MENU_TEXT                 ;AND WRITE INVERTED TEXT
         RETP                              ;THAT'S ALL FOLKS.

**************************************************************************
*                                                                        *
*          UN_SELECT                                                     *
*                                                                        *
*          THIS IS CALLED TO "UN-SELECT" THE CURRENT ENTRY.              *
*                                                                        *
**************************************************************************
UN_SELECT
         MOVE    *A13(MEN_CUR),A0,W        ;POINT AT CURRENT ENTRY
         CLR     A1                        ;USE BLACK FOR BACKGROUND
         CALLR   MENU_BAR                  ;THIS REMOVES THE BAR.

         CALLR   GET_MENU_DATA             ;NOW GET A2 TO TEXT POINTER
         MOVE    *A13(MEN_COLR),A1,W       ;USE THE NORMAL ENTRY COLOR
         JSRP    MENU_TEXT                 ;PUT UP THE "TEXT" PORTION.
         RETP                              ;AND RETURN

**************************************************************************
*                                                                        *
*          MENU_BAR                                                      *
*                                                                        *
*          THIS IS CALLED TO PUT UP THE SELECTION BAR FOR                *
*          THE ENTRY IN A0, IN THE COLOR IN A1.                          *
*                                                                        *
*          THIS ROUTINE MUST PRESERVE A0.                                *
*                                                                        *
**************************************************************************
* STRNGLEN - RETURNS THE LENGTH, IN PIXELS, OF A GIVEN STRING		 *
* A8 = PTR TO STRING							 *
* A10 = [Y,X] SPACING OF STRING						 *
* A11 = PTR TO FONT TABLE						 *
* RETURNS:								 *
* A7 = LENGTH OF STRING							 *
* Z BIT SET IF LENGTH IS ZERO						 *
*
*        FOR FILLAREA
*
* A1 = <COLOR><PALETTE>
* A3 = DAG OF AREA [YPOS,XPOS]
* A4 = [Y,X] SIZE OF AREA
*
MENU_BAR MMTM    SP,A0,A1,A3,A4,A5,A6,A7,A8    ;SAVE THE OFFSET
         MMTM    SP,A1                     ;SAVE COLOR!
         CALLR   GET_MENU_DATA             ;GET THE TEXT POINTER
         CALLR   STLEN_SETUP               ;SETUP FOR STRLEN CALL.
         CALLA   STRNGLEN                  ;FIND WIDTH OF STRING.
*
*        A7 HAS LENGTH OF STRING.
*
*        WE NEED TO GET INTO A3 THE COORDINATES UF UPPER LEFT
*        AND A4 THE LENGTH.
*
*        IF WE'RE CENTERING, WE USE THE BAR WIDTH PARAMETER
*        ALONG THE CENTER LINE.
*
*        IF WE'RE LEFT JUSTIFIED, WE'LL LET THE BOX GO THE
*        LENGTH OF THE TEXT FOR NOW.
*
         MOVE    *A13(MEN_ULX),A3,W        ;LEFT X IN A3
*
*        IF WE'RE CENTERING....WE NEED TO MOVE THE "LEFT X" BACK HALF
*        THE WIDTH OF THE STRING.
*
         MOVE    *A13(MEN_ROM),A6,L        ;GET ROM POINTER
         MOVE    *A6(MR_TCAL),A6,L         ;CHECK ROUTINE
         CMPI    STRCNRM,A6
         JRNZ    NOT_CENTERING
*
*        WE'RE CENTERING....CENTER X IS IN A3
*
         MOVE    *A13(MEN_BWID),A7,W       ;A7 IS THE REGISTER FOR BAR WIDTH
         MOVE    A7,A4                     ;GET COPY IN A4
         SRL     1,A4                      ;1/2 OF WIDTH COMES OFF OF CENTER
         SUB     A4,A3                     ;A3 NOW HAS "LEFT X"
         JRUC    CENTERING                 ;A7 IS WIDTH...A3 IS X

*
*        LEFT JUSTIFIED....DO IT THE OLD WAY!
*
NOT_CENTERING
         MOVE    *A13(MEN_BDX),A4,W        ;GET EXTRA X UNITS FOR BAR
         SUB     A4,A3

*        NOW ADD TWICE THE EXTRA X TO THE STRING LENGTH TO
*        FORM THE BAR LENGTH.
*
         SLL     1,A4                      ;NOW DOUBLE THE EXCESS DX FOR BAR
         ADD     A4,A7                     ;NOW A7 HAS WIDTH OF BAR

CENTERING
         SUBI    C_KLUDGE,A3          ;KLUDGE TO NULLIFY FINAL SPACE.

         CALLR   GET_ENTRY_Y               ;GET Y FOR ENTRY IN A5

         MOVE    *A13(MEN_BDY),A6,W        ;GET BAR DY (NEGATIVE)
         ADD     A6,A5                     ;ADJUST Y BY BAR DY
         SLL     16,A5                     ;SHIFT Y INTO POSITION

         ADD     A5,A3                     ;A3 NOW POINTS AT UPPER LEFT

         MOVE    *A13(MEN_BAR),A4,W        ;Y HEIGHT OF BAR
         SLL     16,A4                     ;IN POSITION
         ADD     A7,A4                     ;A7 HAS X WIDTH OF BAR.

         MMFM    SP,A1                     ;NOW GET COLOR BACK!
         SLL     16,A1                     ;SHIFT COLOR TO HIGH HALF (PAL. 0)
         CALLA   FILLAREA                  ;FILL IT UP!

	MMFM    SP,A0,A1,A3,A4,A5,A6,A7,A8    ;SAVE THE OFFSET
	RETS

**************************************************************************
*                                                                        *
*          MENU_TEXT                                                     *
*                                                                        *
*          THIS IS CALLED TO DISPLAY THE TEXT FOR AN ENTRY.              *
*                                                                        *
*          A0 HAS OFFSET (FOR POSITIONING)                               *
*          A1 HAS COLOR FOR MESSAGE.                                     *
*          A2 HAS TEXT POINTER (FOR MESSAGE)                             *
*                                                                        *
*          WE NEED TO SHIFT THE DATA FOR THE TEXT ROUTINE                *
*          AS FOLLOWS:                                                   *
*                                                                        *
*          A0 = SLEEP                                                    *
*          A5 = COLOR                                                    *
*          A8 = POINTER                                                  *
*          A9 = ADDRESS                                                  *
*          A10 = SPACING                                                 *
*          A11 = FONT                                                    *
*                                                                        *
**************************************************************************
MENU_TEXT
         CALLR   GET_ENTRY_Y               ;GET Y FOR ENTRY IN A5
         SLL     16,A5                     ;SHIFT Y INTO POSITION
         MOVE    *A13(MEN_ULX),A9,W        ;GET THE X
         ADD     A5,A9                     ;A9 SET WITH SCREEN ADDRESS

;         MOVE    A1,A6                     ;COLOR -- THIS IS NARC STYLE
	MOVE	A1,A5			; FIX FOR PASSING COLORS -- JKM
	SLL	16,A5
         CLR     A0                        ;NO SLEEP

         CALLR   STLEN_SETUP

         MOVE    *A13(MEN_ROM),A1,L
         MOVE    *A1(MR_TCAL),A1,L         ;GET THE ROUTINE TO USE
;         JUMP    A1                        ;AND CALL IT!
	JAUC	PRINTF

STLEN_SETUP
         MOVE    A2,A8                     ;TEXT POINTER
         MOVI    SPACING20,A10             ;SPACING
         MOVE    *A13(MEN_ROM),A11,L
         MOVE    *A11(MR_FONT),A11,L       ;LOAD FONT
         RETS

**************************************************************************
*                                                                        *
*          MENU JOYSTICK HANDLING                                        *
*                                                                        *
**************************************************************************

**************************************************************************
*								         *
* 	ST_STICK							 *
* 									 *
* 	INITIALIZE THE STUCK STICK STUFF				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

ST_STICK
	CALLR	READ_SW1_CNS		; XUNIT
	MOVE	A0,*A13(MEN_STIK),L	; BITS TO IGNORE PART 1
	RETP

**************************************************************************
*								         *
* 	GETSTICK							 *
* 									 *
* 	CHECKS OUT ALL THE STICKS ON THE BOARD AND RETURNS SOME		 *
* 	USEFUL INFO ABOUT THEM						 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A0	STICK/BUTTON CONDITION				 *
* 			0 = NOTHING					 *
* 			1 = STICK UP					 *
* 			2 = STICK DOWN					 *
* 			3 = BUTTON DOWN					 *
*								         *
**************************************************************************

GETSTICK:
;
	CALLR	CKTEST			; CHECK THE TEST SWITCH
;
	MMTM	SP,A3,A4
;
;	THIS ALSO TAKES CARE OF STUCK SWITCHES
;
	CALLR	READ_SW1_CNS		; XUNIT
	move	a0,a2
	MOVE	*A13(MEN_STIK),A0,L
	NOT	A0			; THIS IS SOOOOO GROSS
	NOT	A2
	AND	A2,A0
	NOT	A0
	MOVE	A0,*A13(MEN_STIK),L
	AND	A0,A2			; IGNORE SOME BITS

;
;	SCAN FOR BUTTONS
;

	MOVE	A2,A4			;CHECK ALL BUTTONS
	ANDI	00003030H,A4
	JRZ	GSCKSTK			;BR = NO BUTTONS
	ANDI	00001010H,A4		;FIRE BUTTONS?
	JRZ	GSCK1			;BR = NO
	MOVK	2,A2
	JRUC	GSGOTBUTS
GSCK1
	MOVK	1,A2			;MUSTA BEEN A BOMB BUTTON
	JRUC	GSGOTBUTS
*
*	SCAN FOR START BUTTONS
*
GSCKSTK
	BTST	18,A2
	JRNZ	GSGOTUP
	BTST	21,A2
	JRNZ	GSGOTDOWN
GSAINTGOT
	CLR	A0
	JRUC	GSRET

GSGOTUP
	MOVK	1,A0
	JRUC	GSRET

GSGOTDOWN
	MOVK	2,A0
	JRUC	GSRET

GSGOTBUTS
	MOVK	3,A0

GSRET
	MOVE	A0,A0			; SET THE FLAGS
	MMFM	SP,A3,A4
	RETP

**************************************************************************
*                                                                        *
*          FRST_BIT                                                      *
*                                                                        *
*          A0 HAS 1 OR MORE BITS SET....RETURN 1 OF THEM.                *
*                                                                        *
**************************************************************************
FRST_BIT MMTM    SP,A1,A2
         MOVK    1,A1            ;SHIFT TILL WE FIND IT.
FB1      MOVE    A0,A2
         AND     A1,A2
         JRNZ    GOT_IT          ;WE HAVE ON (IN A1)
         SLL     1,A1            ;SHIFT IT
         JRUC    FB1
GOT_IT   MOVE    A1,A0           ;RETURN THE BIT
	MMFM    SP,A1,A2
	RETS

**************************************************************************
*								         *
*          FORM_SWS							 *
* 									 *
*          GET THE SWITCHES....1=CLOSED.....AND SAVE			 *
*          THIS SCAN AS "LAST STATE".  RETURN:				 *
* 									 *
*          CURRENT STATE IN A0						 *
*          PREVIOUS STATE IN A1						 *
*								         *
**************************************************************************
FORM_SWS
	MOVE	*A13(MEN_STIK),A1,L	;RETURN PREVIOUS STATE
	CALLR	READ_SW1_CNS		; XUNIT GET BOTH SWITCH WORDS
	NOT	A0			;COMPLEMENT
	MOVE	A0,*A13(MEN_STIK),L	;SAVE "STUCK" STATE.
	RETS

**************************************************************************
*                                                                        *
*          GET_MENU_DATA                                                 *
*                                                                        *
*          A0 IS OFFSET OF ENTRY OF INTEREST                             *
*                                                                        *
*          RETURN  A1 = CURRENT OFFSET                                   *
*                  A2 = TEXT POINTER                                     *
*                  A3 = ROUTINE                                          *
*                                                                        *
**************************************************************************
GET_MENU_DATA
         MMTM    SP,A0                ;DON'T ALTER A0

         CALLR   PM_ENTRY     ;POINT A1 AT ENTRY

         MOVE    *A1(MENU_TEXT_PTR),A2,L   ;FETCH THE TEXT POINTER
         MOVE    *A1(MENU_ROUTINE),A3,L    ;FETCH THE ROUTINE
         MOVE    *A13(MEN_CUR),A1,W        ;RETURN CURRENT ENTRY IN A1
	MMFM    SP,A0                ;DON'T ALTER A0
	RETS

**************************************************************************
*                                                                        *
*          PM_ENTRY                                                      *
*                                                                        *
*          A0 = MENU ENTRY OF INTEREST                                   *
*          RETURN A1 -> POINTS AT <TEXT><ROUTINE><HELP> FOR THIS         *
*          ENTRY.                                                        *
*                                                                        *
**************************************************************************
PM_ENTRY
         MMTM    SP,A0
         DEC     A0                   ;INDEX FROM ZERO
         MOVI    MENU_ENTRY_SIZE,A1   ;TIMES SIZE PER ENTRY
         MPYU    A0,A1                ;A1 CONTAINS OFFSET INTO TABLE

         MOVE    *A13(MEN_TPTR),A0,L  ;GET THE BASE OF THE MENU TEXT ENTRIES
         ADD     A0,A1                ;ADD TO OFFSET
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          PLOT_HELP                                                     *
*                                                                        *
*          THIS ROUTINE PLOTS (OR CLEARS) THE HELP AREA                  *
*          FOR THE CURRENT ENTRY.                                        *
*                                                                        *
**************************************************************************
PLOT_HELP
         MOVE    *A13(MEN_CUR),A0,W        ;GET CURRENT ENTRY
         CALLR   PM_ENTRY          ;A1 POINTS AT GROUP
         MOVE    *A1(MENU_HELP),A8,L       ;GET HELP TABLE
         CMPI    NO_HELP,A8                ;NOT A "HELP" SITUATION?
         JRZ     NO_HELP_FOR_THIS_ONE
         CMPI    ADJ_HELP,A8               ;ADJUSTMENT HELP REQUESTED?
         JAEQ    DO_ADJH                   ;THEN DO IT IN ADJ MODULE!
         CMPI    SND_HELP,A8               ;ARE WE IN SOUND TEST?
         JREQ    DO_SHELP
         CMPI    SND_PLAY,A8
         JREQ    DO_SPLAY
         CALLR   DO_HELP_MENU
NO_HELP_FOR_THIS_ONE
         RETS

**************************************************************************
*                                                                        *
*          DO_SHELP                                                      *
*                                                                        *
*          THIS IS CALLED FOR EACH NON PLAYING ENTRY IN THE SOUND        *
*          TABLE MENU.  IT CAUSES THE SOUND BOARD TO BE SHUT             *
*          UP AND THE BOTTOM LINE (WHERE TITLES APPEAR)                  *
*          TO BE ERASED.                                                 *
*                                                                        *
**************************************************************************
DO_SHELP
	MOVE	@SND_MADE,A0,W	;DID SOMEONE MAKE A SOUND?
	JRZ	DO_SH1		;NOPE
	CLR	A0
	MOVE	A0,@SND_MADE,W	;CLEAR THIS AND RESET THE BOARD!
	MOVE	A0,@SCODE,W
	MOVE	A0,@DCODE,W
	CALLA	QSNDRST		;kill any sounds in progress
DO_SH1
	CALLR	BLNKSNAM	;BLANK OUT ANY WRITING!
	RETS
*
*	A0 CONTAINS 3 FOR SYNTHESIZER...4 FOR DIGITIZER...
*	IF CORRESPONDING "CODE" BYTE IS NON ZERO, THEN DISPLAY
*	THE TEXTLINE THAT CORRESPONDS.  ELSE BLANK OUT THE
*	AREA.
*
DO_SPLAY
	CALLR	BLNKSNAM	;BLANK OUT LAST MESSAGE
	CMPI	2,A0		;SYNTHESIZER?
	JRZ	CK_SYNT		;YEP.

	CLR	A1
	JRUC	DO_SPQX

CK_SYNT
	MOVE	@DCODE,A1,W	;HOLD INFO IF DIGITIZER WAS RUNNING
	CLR	A0
	MOVE	A0,@DCODE,W	;CLEAR OUT DIG CODE
	MOVE	@SCODE,A0	;ANY CODE
	JRZ	DO_SPQX		;NOTHING HERE.

	MOVI	STABLE,A1	;BASE OF POINTER TABLE FOR DIGITIZER
DO_SP1
	CALLR	MEN_NUMS	;A4 = LEFT X  A5 = RIGHT X
	.IF GERMAN
	SUBK	3,A4
	ADDK	6,A5
	.ENDIF
	ADDI	10000H*SND_MESS_Y,A4               ;UPPER LEFT Y
	ADDI	10000H*(SND_MESS_Y+SND_BOX_H),A5   ;UPPER LEFT X
	MOVI	COLOR_WHITE,A9
	CALLR	STD_BORD	;TACO BELL HAS YOUR ORDER, MAKE A RU-UUUN......

	DEC	A0		;INDEX FROM 1.
	SLL	5,A0
	ADD	A0,A1
	MOVE	*A1,A2,L	;NOW WE HAVE THE MESSAGE

	MOVI	SND_INST,A8
	JSRP	L_MESS		;PUT INSTRUCTION OUT.

	MOVI	SND_SETUP,A8
	CALLA	LM_SETUP

	MOVE	A2,A8
	JSRP	PRINTF	;DO THE DEED
	RETS			;AND RETURN

DO_SPQX
	MOVE	A1,A1		;OUR SELECTION ISN'T RUNNING...WAS OTHER?
	JRZ	DO_SPX		;NOPE
	CALLA	QSNDRST		;KILL SOUNDS IN PROGRESS
	CLR	A0
	MOVE	A0,@SND_MADE,W	;NO RESET NECESSARY NOW
DO_SPX
	RETS

**************************************************************************
*                                                                        *
*          BLNKSNAM                                                      *
*                                                                        *
*          CALLED TO BLANK OUT THE SOUND CODE NAME DURING                *
*          SOUND TEST.                                                   *
*                                                                        *
**************************************************************************
*
*        A3 = POINTER
*        A4 = SIZE
*
BLNKSNAM
         MOVI    (SND_MESS_Y*10000H)+20H,A3
         MOVI    (SND_BOX_H*10000H)+1E0H,A4
         JAUC    BLNKAREA                  ;ITS BLANK!

**************************************************************************
*                                                                        *
*          GET_ENTRY_Y                                                   *
*                                                                        *
*          THIS RETURNS THE Y POSITIONS FOR THE ENTRY SPECIFIED          *
*          IN A0.                                                        *
*                                                                        *
*          A5 = Y VALUE IN UNITS.                                        *
*                                                                        *
**************************************************************************
GET_ENTRY_Y
         MMTM    SP,A0,A1
         MOVE    *A13(MEN_ULY),A5,W
         MOVE    *A13(MEN_DY),A1,W
         DEC     A0
         MPYU    A0,A1                ;A1 HAS OFFSET PER ENTRY
         ADD     A1,A5
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
*          MENU_BORDER                                                   *
*                                                                        *
*          THIS IS CALLED TO PUT A BORDER AROUND THE MENU.               *
*                                                                        *
*          A8 = MENU STRUCTURE                                           *
*          A9 = 1st item to activate as current                          *
*                                                                        *
*          BORDER IS DONE IN MENU TEXT COLOR                             *
*                                                                        *
*          THIS ASSUMES MENU IS IN THE CENTERING FORMAT                  *
*                                                                        *
**************************************************************************
*
*        1ST WE NEED TO FIND UPPER LEFT.
*
*
*        X = MENU_X - (BAR_WIDTH/2) - 2       (LESS BORDER WIDTH)
*        Y = MENU_Y - BDY                     (LESS BORDER HEIGHT)
*
*        LOWER RIGHT :
*
*        X = MENU_X + (BAR_WIDTH/2) - 2       (PLUS BORDER WIDTH)
*        Y = MENU_Y + (MENU_ENTRIES-1) * DY)) - BDY + BAR_HITE
*
*
MENU_BORDER
         MMTM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9
         CALLR   STUFF_MENU_PROCESS   ;MOVE DATA INTO PDATA AREA
*
*        FIRST COMPUTE UPPER LEFT
*
         CALLR   MENU_UL_A4_A5             ;GET UPPER LEFT COORDINATES
         SLL     16,A5
         ADD     A5,A4                     ;A4 POINTS TO UPPER LEFT.
*
*        FORM LOWER RIGHT
*
         CALLR   MENU_LR_A6_A5
         SLL     16,A5                     ;SHIFT A5 DOWN
         ADD     A6,A5                     ;A5 POINTS AT LOWER RIGHT

         MOVE    *A13(MEN_COLR),A9,W       ;GET MENU TEXT COLOR
         CALLR   STD_BORD

	MMFM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9
	RETS

**************************************************************************
*                                                                        *
*          MCSETUP                                                       *
*                                                                        *
*          RETURN:                                                       *
*                  A0 = CENTER OF MENU                                   *
*                  A1 = 1/2 BAR WIDTH                                    *
*                  A2 = Y FOR FIRST LINE OF TEXT OF MENU                 *
*                  A3 = DELTA Y (NEGATIVE TO GET FROM TEXT TO BAR.       *
*                                                                        *
**************************************************************************
MCSETUP
         MOVE    *A13(MEN_ULX),A0,W        ;UPPER LEFT X (ACTUALLY CENTER)
         MOVE    *A13(MEN_BWID),A1,W       ;BAR_WIDTH
         SRL     1,A1                      ;ALL CALCS USE BAR_WIDTH/2
         MOVE    *A13(MEN_ULY),A2,W        ;UPPER LEFT Y
         MOVE    *A13(MEN_BDY),A3,W        ;DELTA Y (NEGATIVE)
         RETS


**************************************************************************
*                                                                        *
*          MENU_UL_A4_A5                                                 *
*                                                                        *
*          RETURN WINDOW UPPER LEFT CORNER                               *
*                                                                        *
*          A4 = X                                                        *
*          A5 = Y                                                        *
*                                                                        *
**************************************************************************
MENU_UL_A4_A5
         MMTM    SP,A0,A1,A2,A3
         CALLR   MCSETUP                   ;STUFF THE REGGIES
         MOVE    A0,A4                     ;FORM ULX
         SUB     A1,A4
         SUBI    C_KLUDGE,A4          ;A4 HAS UPPER LEFT X

         MOVE    A2,A5
         ADD     A3,A5                     ;A5 HAS UPPER LEFT Y

         SUBI    MB_XWID+GAP,A4            ;NOW WE POINT AT UPPER LEFT FOR FRAME
         SUBI    MB_YWID+GAP,A5
	MMFM    SP,A0,A1,A2,A3
	RETS

**************************************************************************
*                                                                        *
*          MENU_LR_A6_A5                                                 *
*                                                                        *
*          RETURN WINDOW LOWER RIGHT CORNER                              *
*                                                                        *
*          A6 = X                                                        *
*          A5 = Y                                                        *
*                                                                        *
**************************************************************************
MENU_LR_A6_A5
         MMTM    SP,A0,A1,A2,A3
         CALLR   MCSETUP                   ;STUFF THE REGGIES

         MOVE    A0,A6                     ;LOWER RIGHT X
         ADD     A1,A6
         SUBI    C_KLUDGE,A6          ;THIS IS THE X

         MOVE    *A13(MEN_ENTS),A0,W       ;THIS IS LAST ENTRY
         CALLR   GET_ENTRY_Y               ;A5 HAS THE Y FOR THE LAST ENTRY
         ADD     A3,A5                     ;A5 NOW HAS TOP OF LAST BOX
         MOVE    *A13(MEN_BAR),A7,W        ;HEIGHT OF BAR
         ADD     A7,A5                     ;A5 NOW HAS LOWER RIGHT Y

         ADDI    MB_YWID+GAP,A5
         ADDI    MB_XWID+GAP,A6            ;THIS IS END OF BORDER
	MMFM    SP,A0,A1,A2,A3
	RETS


**************************************************************************
*                                                                        *
*          F_TITLE                                                       *
*                                                                        *
*          THIS IS CALLED TO FRAME A TITLE IN THE SAME WIDTH             *
*          AS THE MAIN TITLE.                                            *
*                                                                        *
*          A0 = Y LEVEL OF 15 POINT TEXT                                 *
*          A9 = COLOR                                                    *
*                                                                        *
**************************************************************************
F_TITLE  MMTM    SP,A4,A5,A0
         MOVE    A0,A4           ;COPY Y
;         SUBI    12,A4
	SUBI	8,A4
         SLL     16,A4
         ADDI    TIT_ULX,A4      ;UPPER LEFT SET

         MOVE    A0,A5           ;LOWER RIGHT
;         ADDI    27,A5
	ADDI	23,A5
         SLL     16,A5
         ADDI    TIT_LRX,A5      ;LOWER RIGHT SET

         CALLR   STD_BORD       ;TACO BELL HAS YOUR ORDER, MAKE A RU-UUUN......
	MMFM    SP,A4,A5,A0
	RETS

FIRST_BORDER_COLOR       EQU     0E0E0H
LAST_BORDER_COLOR        EQU     0EFEFH
**************************************************************************
*                                                                        *
*          G_BORDER                                                      *
*                                                                        *
*          THIS IS CALLED TO DO A "HSTD TABLE" TYPE CYCLING              *
*          BORDER.  THIS ROUTINE GETS:                                   *
*                                                                        *
*          A4 = UPPER LEFT Y,X                                           *
*          A5 = LOWER RIGHT Y,X                                          *
*          A6 = NUMBER OF SLICES GOING IN.                               *
*                                                                        *
**************************************************************************
G_BORDER MMTM    SP,A0,A1,A2,A3,A4,A5,A6
         MOVI    10001H,A0                 ;1 BY 1 DIMENSION

         MOVI    LAST_BORDER_COLOR,A9      ;USE LAST ONE 1ST
NEXT_RING
         CALLR   DOBORDER                  ;DO THIS RING

         MOVI    10001H,A1                  ;THIS IS 1 UNIT IN X AND Y
         ADDXY   A1,A4
         SUBXY   A1,A5

         SUBI    101H,A9
         CMPI    FIRST_BORDER_COLOR,A9
         JRHS    COLOK
         MOVI    LAST_BORDER_COLOR,A9

COLOK    DSJS    A6,NEXT_RING
	MMFM    SP,A0,A1,A2,A3,A4,A5,A6
	RETS

**************************************************************************
*                                                                        *
*          DOBORDER                                                     *
*                                                                        *
*          THIS IS CALLED TO DRAW A BORDER FRAME.                        *
*                                                                        *
*          A4 = UPPER LEFT Y,X                                           *
*          A5 = LOWER RIGHT Y,X                                          *
*          A0 = Y,X WIDTH OF BORDER                                      *
*          A9 = COLOR OF BORDER.                                         *
*                                                                        *
*          THIS ROUTINE *** CLEARS OUT ALL AREA INSIDE THE BORDER***     *
*          AS A FUNCTION OF ITS OPERATION.                               *
*                                                                        *
*          THE BORDER IS DONE IN THE "FIXED" PALETTE                     *
*                                                                        *
*          IT IS ASSUMED THAT THE DISPLAY SYSTEM IS RUNNING!             *
*                                                                        *
**************************************************************************
*
* A1 = <COLOR><PALETTE>
* A3 = DAG OF AREA [YPOS,XPOS]
* A4 = [Y,X] SIZE OF AREA
*
DOBORDER
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9
	MOVE	A9,A1			;GET COLOR
	SLL	16,A1			;COLOR ON TOP..PALETTE 0
*
*	NOW WE NEED TO MAKE 4 BARS!
*
	MOVE	A0,A2			;SEPARATE DELTA
	ANDI	SX_MASK,A0
	ANDI	SY_MASK,A2

	MOVE	A4,A6			;UPPER LEFTS HERE
	MOVE	A4,A7

	MOVE	A5,A8			;LOWER RIGHTS HERE
	MOVE	A5,A9

	ANDI	SX_MASK,A6		;LEFT X
	ANDI	SX_MASK,A8		;RIGHT X

	ANDI	SY_MASK,A7		;TOP Y
	ANDI	SY_MASK,A9		;BOTTOM Y

*
*	FIRST BAR GOES FROM ORIGINAL UL XY TO RIGHT X
*	AND TOP Y+DELTA Y
*
*	A3 IS ORIGINAL A4 PASSED.
*	FORM DESTINATION IN A4
*
	MOVE	A4,A3

	MOVX	A8,A4
	MOVY	A7,A4
	ADDXY	A2,A4			;ADD THE DELTA

	CALLR	DO_A_LINE		;DO THIS LINE
*
*	GOING AROUND CLOCKWISE.....THIS ONE STARTS AT RIGHT X-DELTA
*	AND TOP Y
*
	MOVX	A8,A3
	SUBXY	A0,A3
	MOVY	A7,A3
*
*	THIS IS THE NATURAL LOWER RIGHT CORNER
*
	MOVX	A8,A4
	MOVY	A9,A4

	CALLR	DO_A_LINE
*
*	NOW FOR BOTTOM LINE.....A4 IS STILL SET!
*
	MOVX	A6,A3
	MOVY	A9,A3
	SUBXY	A2,A3

	CALLR	DO_A_LINE
*
*	LEFT WALL....FROM UPPER LEFT
*
	MOVX	A6,A3
	MOVY	A7,A3

	MOVX	A6,A4
	ADDXY	A0,A4
	MOVY	A9,A4

	CALLR	DO_A_LINE

	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9
	RETS

DO_A_LINE
	MMTM	SP,A4
	SUBXY	A3,A4           ;FORM DISTANCE
	CALLA	FILLAREA        ;AND DO THE FILL
	MMFM	SP,A4
	RETS

STD_BORD
	MMTM	SP,A0
	MOVI	BORDER_SIZE,A0
	CALLA	DOBORDER
	MMFM	SP,A0
	RETS

**************************************************************************
*                                                                        *
*          DO_HELP_MENU                                                  *
*                                                                        *
*          THIS IS CALLED TO DISPLAY A HELP MENU FOR THE CURRENT         *
*          MENU ENTRY.                                                   *
*                                                                        *
*          A HELP MENU IS DEFINED AS FOLLOWS:                            *
*                                                                        *
*          HM_JUST         WORD    0=CENTER   1=LEFT                     *
*          HM_COLOR        WORD    COLOR OF MENU                         *
*          HM_ENTS         WORD    NUMBER OF LINES IN MENU               *
*                          LONG    LONG WORD POINTERS FOR EACH LINE!     *
*                                                                        *
*          THE PROCESS AREA IS FILLED WITH THE CURRENT MENU              *
*          PARAMETERS.                                                   *
*                                                                        *
*          A8 = POINTER TO HELP MENU STRUCTURE ABOVE                     *
*                                                                        *
**************************************************************************
DO_HELP_MENU
         CALLR   BLNKHELP

         MOVE    A8,A8                ;CHECK IF HELP MENU EXISTS.
         JRZ     DHMX                 ;NOPE JUST CLEARING WAS OUR JOB.

         MOVE    *A13(MEN_CUR),A0,W   ;THIS IS CURRENT ENTRY
         MOVE    A0,A11               ;PASS ENTRY NUMBER IN A11
         CALLR   GET_ENTRY_Y          ;A5 HAS THE Y FOR THE CURRENT ENTRY
*
*        NOW WE NEED TO MOVE TO MAKE TOP ENTRY BOX LINE UP.
*
         MOVE    *A13(MEN_BDY),A10,W  ;THIS IS NEGATIVE TO GIVE US BOX TOP
         ADD     A5,A10               ;NOW WE HAVE BOX TOP

         MOVE    *A13(MEN_BAR),A5,W   ;GET BAR HEIGHT
         SRL     1,A5                 ;FIND CENTER OF BAR
         ADD     A5,A10               ;NOW WE'RE AT BAR CENTER.

*         SUBI    MB_YWID+GAP,A10      ;THIS IS MAIN MENU TOP. (FOR TOP ENTRY)

         MOVI    H_SLAVE,A7        ;FORK OFF SO IT CAN USE PDATA!
         CALLA   P_FORK               ;START UP ANOTHER W/ SAME ID TO FLASH!
DHMX     RETS

**************************************************************************
*                                                                        *
*          BLNKHELP                                                      *
*                                                                        *
*          THIS IS CALLED TO BLANK OUT THE HELP AREA.  IT IS             *
*          USED BY BOTH THE "NORMAL" HELP PLOTTER AND IS                 *
*          CALLED BY THE ADJUSTMENT HELP PROGRAM.                        *
*                                                                        *
*          THIS RETURNS THE LEFT X FOR THE HELP MENU IN A9               *
*                                                                        *
**************************************************************************
BLNKHELP
         MMTM    SP,A3,A4,A5,A6
         CALLR   MENU_LR_A6_A5        ;GET RIGHT X OF MAIN MENU IN A6
         MOVE    A6,A9                ;PASS TO HELP MENU SLAVE
*
*        NOW BLANK OUT THE "HELP" REGION
*
         MOVE    A6,A3                ;UPPER LEFT X OF REGION TO BLANK OUT
         ADDI    INST_ULY*10000H,A3   ;THIS IS UPPER LEFT OF BLOCK

         MOVI    TIT_LRX+(10000H*400),A4 ;COORDINATE OF LOWER RIGHT OF HELP AREA
         SUBXY   A3,A4                   ;THIS IS SIZE OF REGION TO BLANK
         CALLA   BLNKAREA                ;BLANK OUT THE HELP AREA
         ADDI    BOX_XGAP,A9             ;RETURN X FOR HELP MENUS
	MMFM    SP,A3,A4,A5,A6
	RETS

P_FORK
        MMTM    SP,A1
        MOVE    *A13(PROCID),A1,W    ;PASS OUR ID TO FORKED PROCESS
        CALLA   GETPRC               ;MAKE THE PROCESS
	MMFM    SP,A1
	RETS


**************************************************************************
*                                                                        *
*          H_SLAVE                                                       *
*                                                                        *
*          THIS IS A PROCESS CREATED TO PLOT THE HELP BOX.               *
*          IT DOES ITS PLOTTING THEN DIES.   THIS ALLOWS IT              *
*          TO USE THE PDATA AREA WITHOUT DISTURBING THE CALLER.          *
*                                                                        *
*          A8 = POINTER TO HELP BOX STRUCTURE                            *
*          A9 = LEFT MARGIN FOR THE HELP BOX.                            *
*          A10 = Y OF CENTER OF BOX ...HIGH HALF IS ZERO FOR Y CENTING   *
*                IF HIGH HALF IS NON-ZERO, THEN THIS IS TOP OF BOX       *
*                                                                        *
**************************************************************************
HM_JUST          EQU     0
HM_COLOR         EQU     HM_JUST+WORD_SIZE
HM_ENTS          EQU     HM_COLOR+WORD_SIZE
HM_DATA          EQU     HM_ENTS+WORD_SIZE      ;ENTRY POINTERS

HS_ROUT          EQU     PDATA             ;LONG-TEXT ROUTINE
HS_X             EQU     HS_ROUT+LONG_SIZE ;WORD-X FOR TEXT ROUTINE
HS_Y             EQU     HS_X+WORD_SIZE    ;WORD-CURRENT Y
HS_ENTS          EQU     HS_Y+WORD_SIZE    ;WORD-ENTRIES LEFT TO DO
HS_COLOR         EQU     HS_ENTS+WORD_SIZE ;WORD-COLOR OF MENU
HS_PTR           EQU     HS_COLOR+WORD_SIZE ;LONG-CURRENT TEXT POINTER

H_SLAVE
*
*        A9 HAS RIGHT X OF MENU
*
         MOVE    A9,A1                     ;PUT THIS X VALUE IN A1

         MOVE    *A8(HM_JUST),A0,W         ;0 = CENTER  1=LEFT
         JRZ     HS_CENT                   ;CENTER....SETUP X ACCORDINGLY
*
*        LEFT JUSTIFY....STORE ROUTINE
*
         MOVI    STRLNRM,A0                ;LEFT JUSTIFY ROUTIN
*
*        NOW FORM X AS SOME MARGIN FROM WINDOW....
*
         ADDI    MB_XWID+HELP_X_MARGIN,A1  ;ADD MARGIN TO FORM X FOR TEXT
         JRUC    CENTER_JOIN               ;CONTINUE

HS_CENT  MOVI    STRCNRM,A0                ;USE CENTERING ROUTINE
*
*        A1 HAS LEFT X OF HELP BOX...FIND RIGHT X
*
         ADDI    TIT_LRX,A1
         SRL     1,A1                      ;THIS IS CENTER X

CENTER_JOIN
         MOVE    A1,*A13(HS_X),W           ;STORE X
         MOVE    A0,*A13(HS_ROUT),L        ;STORE ROUTINE

         MOVE    *A8(HM_ENTS),A1,W         ;GET NUMBER OF ENTRIES
         MOVE    A1,*A13(HS_ENTS),W        ;COUNT IT DOWN IN P-AREA

         MOVE    *A8(HM_COLOR),A0,W        ;GET COLOR
         MOVE    A0,*A13(HS_COLOR),W       ;STASH IT

         ADDI    HM_DATA,A8                ;POINT AT 1ST ENTRY
         MOVE    A8,*A13(HS_PTR),L         ;NOW WE'RE READY.
*
*        ALL PDATA AREA SET.....NOW WE NEED TO DRAW THE BORDER
*
*          FOR DOBORDER
*
*          A4 = UPPER LEFT Y,X
*          A5 = LOWER RIGHT Y,X
*          A0 = Y,X WIDTH OF BORDER
*          A9 = COLOR OF BORDER.
*
*        LOWER RIGHT X IS SUCH THAT IT LINES UP WITH TITLE BOX.
*        THE Y IS A BIT TRICKIER......NUMBER OF ENTRIES IS
*        SITTING IN A1
*
         MOVI    HELP_DY,A5                ;DISTANCE PER ENTRY
         MPYU    A1,A5                     ;DISTANCE FOR ALL ENTRIES
         ADDI    HELP_Y_MARGIN+(MB_YWID*2)+HELP_YLO_MARGIN,A5
*
*        A5 NOW CONTAINS FULL HEIGHT OF BOX
*
*        NOW SEE IF WE'RE CENTERING ON A10 OR IF A10 IS THE TOP.
*
         CALLR   TOP_IN_A10
*
*        NOW FORM UPPER LEFT IN A4
*
         MOVE    A10,A4                    ;MOVE Y OVER
         SLL     16,A4                     ;MAKE ROOM FOR X
         ADD     A9,A4                     ;PUT IN THE X...THIS IS UPPER LEFT!

         ADD     A10,A5                    ;ADD BASE TO OFFSET
         SLL     16,A5                     ;PUT IN Y POSITION
         ADDI    TIT_LRX,A5                ;ADD IN THE X FOR THE CORNER
*
*        NOW ADJUST FROM TOP OF BOX TO POSITION OF
*        1ST ENTRY.
*
         ADDI    MB_YWID+HELP_Y_MARGIN,A10  ;Y OF 1ST ENTRY
         MOVE    A10,*A13(HS_Y),W           ;PUT AWAY

         MOVE    *A13(HS_COLOR),A9,W       ;GET THE COLOR FOR DOBORDER

         CALLR   STD_BORD
*
*        NOW WE NEED TO WALK THROUGH AND PLOT THE HELP
*        MENU ENTRIES.
*
*        A0 = SLEEP
*        A1 = ROUTINE
*        A6 = COLOR
*        A8 = POINTER
*        A9 = ADDRESS
*        A10 = SPACING
*        A11 = FONT
*        A14 = FLAGS
*
NEXT_HELP
         MOVE    *A13(HS_PTR),A2,L         ;GET OUR CURRENT POINTER
         MOVE    *A2+,A8,L                 ;GET THE CURRENT MESSAGE POINTER
         MOVE    A2,*A13(HS_PTR),L         ;AND PUT POINTER BACK

         CLR     A0
         MOVE    *A13(HS_ROUT),A1,L        ;ROUTINE IN A1
;         MOVE    *A13(HS_COLOR),A6,W       ;STUFF COLOR -- OLD NARC STYLE
        MOVE    *A13(HS_COLOR),A5,W       ;STUFF COLOR
	SLL	16,A5

         MOVE    *A13(HS_Y),A9,W           ;GET Y
         SLL     16,A9                     ;SHIFT INTO PLACE
         MOVE    *A13(HS_X),A10,W
         ADD     A10,A9                    ;A9 IS NOW POINTING AT SCREEN

         MOVI    SPACING07,A10             ;SPACING
         MOVI    RD7FONT,A11               ;FONT IS BABY FONT
         JSRP    PRINTF                  ;PRINT IT OUT!

         MOVE    *A13(HS_Y),A9,W           ;GET THE Y
         ADDI    HELP_DY,A9                ;KICK IT
         MOVE    A9,*A13(HS_Y),W           ;PUT IT BACK

         MOVE    *A13(HS_ENTS),A0,W        ;ENTRY COUNT
         DEC     A0
         MOVE    A0,*A13(HS_ENTS),W        ;PUT IT BACK
         JRNZ    NEXT_HELP

         JAUC    SUCIDE                    ;OUR WORK IS DONE!

**************************************************************************
*                                                                        *
*          TOP_IN_A10                                                    *
*                                                                        *
*          THIS IS CALLED BY H_SLAVE TO GET THE UPPER LEFT               *
*          CORNER OF THE BOX IN A10.  A10 HAS THE PASSED PARAMETER.      *
*          A5 HAS THE HEIGHT OF THE BOX.  IF THE TOP HALF OF A10         *
*          IS ZERO, THEN THEN WE WANT THE BOX CENTER AT THE              *
*          A10 LEVEL.  IF THE TOP HALF OF A10 IS NON-ZERO THEN           *
*          A10 WAS PASSED AS THE TOP.                                    *
*                                                                        *
*          RETURN A10 AS THE Y FOR THE TOP OF THE HELP BOX.              *
*                                                                        *
**************************************************************************
TOP_IN_A10
         MMTM    SP,A5
         CMPI    0FFFFH,A10                ;IS THE TOP HALF ZERO?
         JRHI    TOP_IS_TOP                ;TOP IS SET..RETURN
         SRL     1,A5                      ;TOP OF BOX IS HALF UP FROM MAIN MENU BAR CENTER
         SUB     A5,A10                    ;NOW A10 HAS Y BASE OF BOX
TOP_IS_TOP
	MMFM    SP,A5
	RETS

**************************************************************************
*                                                                        *
*          AREUSURE                                                      *
*                                                                        *
*          THIS IS CALLED TO GET A CONFIRMATION FROM THE USER.           *
*          A8 = PROMPT...THIS WILL APPEAR ABOVE THE "ARE YOU SURE"       *
*          A9 = ROUTINE TO JSRP TO DO THE DESIRED ACTION                 *
*          A10 = MESSAGE TO DISPLAY CONFIRMING COMPLETION                *
*                                                                        *
*          RETURN A0=0 MEANS YES WAS CHOSEN.                             *
*                 A0 .NE. 0 MEANS NO                                     *
*                                                                        *
**************************************************************************
AREUSURE
         CALLA   CLR_SCRN             ;BLANK IT ALL OUT!
         MOVE    A9,*A13(PDATA),L     ;SAVE ROUTINE
         MOVE    A10,-*A12,L          ;AND CONFIRM MESSAGE

         CALLR   SURE_BOX

         MOVE    A8,A2                ;PUT MESSAGE TEXT IN SAFE PLACE
         MOVI    MESS_SURE,A8         ;SETUP FOR TITLE
         CALLA   LM_SETUP             ;STUFF REGGIES
         MOVE    A2,A8                ;GET STRING IN THERE
         JSRP    PRINTF             ;AND PRINT IT

         MOVI    M_SURE,A8            ;NOW THE "ARE YOU SURE" PART
         JSRP    L_MESS               ;PUT IT UP.

         MOVI    MEN_YN,A8            ;PUT UP THE "YES/NO" SELECTOR.
         MOVI    2,A9                 ;CURSOR ON 2ND ENTRY (NO)

         JSRP    B_MENU               ;AND GET A RESPONSE.
         CMPI    1,A8                 ;WAS IT YES?
         JRNZ    SURE_X               ;NOPE....GET OUT

         CALLA   CLR_SCRN             ;CLEAR THE SCREEN FIRST, SO ROUTINE CAN PLOT!

         MOVE    *A13(PDATA),A0,L     ;GET THE ROUTINE TO CALL
         MOVI    SURE_RET,A7
         MOVE    A7,-*A12,L           ;PUSH RETURN ADDRESS
         JUMP    A0                   ;AND "JSRP" THE ROUTINE

SURE_RET CALLR   SURE_BOX             ;BOX IT!
         MOVE    *A12+,A8,L
         JSRP    SUR_MESS             ;PRINT THE MESSAGE

         JSRP    ANY_BUT              ;NOW RETRIEVE ANY BUTTON THEN RETURN

         CLR     A0                   ;RETURN SUCCESS
         RETP

SURE_X   ADDI    LONG_SIZE,A12        ;POP MESSAGE
         MOVI    2,A0                 ;RETURN FAILURE
         RETP

**************************************************************************
*                                                                        *
*          SUR_MESS                                                      *
*                                                                        *
*          THIS PRINTS MESSAGE IN A8 IN THE ARE U SURE BOX               *
*          CONFIRMATION SPOT.                                            *
*                                                                        *
**************************************************************************
SUR_MESS
	MOVE	A8,-*A12,L
	MOVI	MESS_CONFIRM,A8
	CALLA	LM_SETUP		;GET CONFIRMATION DATA READY.
	MOVE	*A12+,A8,L
	JSRP	PRINTF		;PRINT OUR PART
	RETP

SURE_BOX
	MOVI	COLOR_YELLOW,A9
	MOVI	003D0025H,A4
	MOVI	00F6016AH,A5
	CALLR	STD_BORD		;BORDER-IZE THE WHOLE THING.
	RETS

*
*BLANK THE INSIDE OF THE "ARE YOU SURE BOX"
*
BLNK_SURE_BOX
	MOVI	[41H,29H],A3
	MOVI	[0F2H,166H]-[41H,29H],A4
	JAUC	BLNKAREA		;ITS BLANK!

CENT_BOX
	MOVI	COLOR_RED,A9
CBOX_COL
	MOVI	0006E0030H,A4
	MOVI	0011A01D0H,A5
	CALLR	STD_BORD		;BORDER-IZE THE WHOLE THING.
	RETS

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
*****************************    MESSAGES    *********************************
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

INSTR_Y  EQU     INST_ULY+6
INSTR_2Y EQU     INSTR_Y+10

	.IF GERMAN

MM_INST1
	MESS_MAC RD7FONT,SPACING07,MENU_X,INSTR_Y,COLOR_PRGB,STRCNRM,0
	.STRING	"P1 START-AUF/P2 START-AB",0
	.EVEN

MM_INST2
	MESS_MAC RD7FONT,SPACING07,MENU_X,INSTR_2Y,COLOR_PRGB,STRCNRM,0
	.STRING	"START MIT TRIGGER",0
	.EVEN

	.ELSE

MM_INST1
	MESS_MAC RD7FONT,SPACING07,MENU_X,INSTR_Y,COLOR_PRGB,STRCNRM,0
	.STRING	"P1 START-UP/P2 START-DOWN",0
	.EVEN

MM_INST2
	MESS_MAC RD7FONT,SPACING07,MENU_X,INSTR_2Y,COLOR_PRGB,STRCNRM,0
	.STRING	"ACTIVATE WITH TRIGGER",0
	.EVEN

	.ENDIF

MESS_FAIL
         MESS_MAC  RD15FONT,SPACING20,256,176,COLOR_PRED,STRCNRM,0
         .STRING  "INVALID ",W_GAME," ",W_SETTINGS
         .BYTE   0,1                  ;0 = END OF STRING...1 = MORE MESSAGES!
         .EVEN
         MESS_MAC  RD15FONT,SPACING20,256,226,COLOR_PWHITE,STRCNRM,0
         .STRING  "ATTEMPT TO RESTORE"
         .BYTE   0,1                  ;0 = END OF STRING...1 = MORE MESSAGES!
         .EVEN
         MESS_MAC  RD15FONT,SPACING20,256,256,COLOR_PWHITE,STRCNRM,0
         .STRING  W_FACSET,"S HAS FAILED."
         .BYTE    0,0
         .EVEN

MESS_TITLE
         MESS_MAC  RD15FONT,SPACING20,TM_X,TM_Y,COLOR_PGREEN,STRCNRM,0

RV_Y	EQU	TM_Y+18

MESS_REV
         MESS_MAC  RD7FONT,SPACING07,TM_X,RV_Y,COLOR_PYELLOW,STRCNRM,0
*
*        THIS IS SETUP FOR THE QUESTION BEING ASKED
*        BY "ARE YOU SURE"
*
MESS_SURE
         MESS_MAC  RD15FONT,SPACING20,200,102,COLOR_PLF,STRCNRM,0
*
*        THIS IS THE "ARE YOU SURE" PART.
*
M_SURE
         MESS_MAC  RD15FONT,SPACING20,200,128,COLOR_PYELLOW,STRCNRM,0
	.IF GERMAN

	.STRING "OK?"

	.ELSE

         .STRING   "ARE YOU SURE?"

	.ENDIF

	.BYTE	0
	.EVEN
	.WORD	0

MESS_CONFIRM
         MESS_MAC  RD15FONT,SPACING20,200,115,COLOR_PLF,STRCNRM,0

SIY1     EQU     SND_MESS_Y+30
SIY3     EQU     SND_MESS_Y+41
SIY2     EQU     SND_MESS_Y+8

	.IF GERMAN

SND_INST
	MESS_MAC RD7FONT,SPACING07,200,SIY1,COLOR_PWHITE,STRCNRM,0
	.STRING	"WIEDERHOLUNG MIT BOMBEN-TASTE",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,200,SIY3,COLOR_PWHITE,STRCNRM,0
	.STRING	"N",C_GERA,"CHSTES GER",C_GERA,"USCH MIT TRIGGER",0
	.EVEN
	.WORD	0

	.ELSE

SND_INST
	MESS_MAC RD7FONT,SPACING07,200,SIY1,COLOR_PWHITE,STRCNRM,0
	.STRING	"BOMB BUTTON TO REPEAT",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,200,SIY3,COLOR_PWHITE,STRCNRM,0
	.STRING	"TRIGGER FOR NEXT SOUND",0
	.EVEN
	.WORD	0

	.ENDIF

SND_SETUP MESS_MAC  RD15FONT,SPACING20,200,SIY2,COLOR_PLF,STRCNRM,0

STABLE
	.LONG	ST2,ST2A,ST2B,ST2C,ST3,ST1,ST1A0,ST1A,ST1B,ST1B1,ST1B2,ST1C
	.LONG	ST4,ST4A,ST4B,ST4C,ST4D,ST4E,ST4F,ST4G,ST4H,ST4I,ST4J,ST4K
	.LONG	ST4L,ST4M,ST4N,ST4O,ST4P,ST4Q,ST4R,ST4S,ST4T,ST4U,ST4V,ST4W
	.LONG	ST4X,ST4Y,ST4Z,ST4Z1,ST4Z2,ST4Z3,ST4Z4,ST4Z5,ST4Z6,ST4Z7
	.LONG	ST4Z8,ST4Z9
	.LONG	ST5,ST5A,ST6

ST2	.STRING "OKI TRACK 1",0
	.EVEN
ST2A	.STRING	"OKI TRACK 2",0
	.EVEN
ST2B	.STRING	"OKI TRACK 3",0
	.EVEN
ST2C	.STRING	"OKI TRACK 4",0
	.EVEN
ST3	.STRING	"YAMAHA",0
	.EVEN
ST1	.STRING	"BATTLEFIELD",0
	.EVEN
ST1A0	.STRING	"HK THEME",0
	.EVEN
ST1A	.STRING	"HUMAN HIDEOUT",0
	.EVEN
ST1B	.STRING	"SKYNET",0
	.EVEN
ST1B1	.STRING	"SWAT CHASE",0
	.EVEN
ST1B2	.STRING	"CRYOCO FIGHT",0
	.EVEN
ST1C	.STRING	"BONUS GROOVE",0
	.EVEN

ST4	.STRING	"FIRE AT WILL",0
	.EVEN
ST4A	.STRING	"GREAT SHOT",0
	.EVEN
ST4B	.STRING	"I'LL BE BACK",0
	.EVEN
ST4C	.STRING	"WELL DONE",0
	.EVEN
ST4D	.STRING	"AWESOME",0
	.EVEN
ST4E	.STRING	"JUDGMENT DAY",0
	.EVEN
ST4F	.STRING	"I AM THE FUTURE",0
	.EVEN
ST4G	.STRING	"WAY TO GO",0
	.EVEN
ST4H	.STRING	"HASTA LA VISTA",0
	.EVEN
ST4I	.STRING	"EXCELLENT",0
	.EVEN
ST4J	.STRING	"NICE SHOT",0
	.EVEN
ST4K	.STRING	"LET'S GO",0
	.EVEN
ST4L	.STRING	"TIME TO GO",0
	.EVEN
ST4M	.STRING	"RIGHT NOW",0
	.EVEN
ST4N	.STRING	"DON'T MOVE",0
	.EVEN
ST4O	.STRING	"THEY'RE HERE",0
	.EVEN
ST4P	.STRING	"OUT OF THE WAY",0
	.EVEN
ST4Q	.STRING	"LOOK OUT",0
	.EVEN
ST4R	.STRING	"TERMINATOR",0
	.EVEN
ST4S	.STRING	"DESTROY EVERYTHING",0
	.EVEN
ST4T	.STRING	"TERMINATED",0
	.EVEN
ST4U	.STRING	"NO WAY JOSE",0
	.EVEN
ST4V	.STRING	"NO PROBLEMO",0
	.EVEN
ST4W	.STRING	"GET THE CPU",0
	.EVEN
ST4X	.STRING	"HURRY UP",0
	.EVEN
ST4Y	.STRING	"DIRECT HIT",0
	.EVEN
ST4Z	.STRING	"GO",0
	.EVEN
ST4Z1	.STRING	"RUN",0
	.EVEN
ST4Z2	.STRING	"INCOMING",0
	.EVEN
ST4Z3	.STRING	"DESTROY SKYNET",0
	.EVEN
ST4Z4	.STRING	"SECURITY LEVEL 1",0
	.EVEN
ST4Z5	.STRING	"SECURITY LEVEL 2",0
	.EVEN
ST4Z6	.STRING	"SECURITY LEVEL 3",0
	.EVEN
ST4Z7	.STRING	"SECURITY LEVEL 4",0
	.EVEN
ST4Z8	.STRING	"ABOVE YOU",0
	.EVEN
ST4Z9	.STRING	"YOU ARE SUPERIOR",0
	.EVEN

ST5	.STRING	"INTRUDER ALERT",0
	.EVEN
ST5A	.STRING	"GLOBAL DESTRUCTION",0
	.EVEN

ST6	.STRING	"WHOOOA!",0
	.EVEN

ROM_NAME .STRING   "NHL NHLPA HOCKEY- SANS REVISION",0
         .EVEN

**************************************************************************
*								         *
* 			     MENU DATA					 *
*								         *
**************************************************************************

**************************************************************************
*								         *
* 	MAIN TEST MENU AND ASSOCIATED DATA 				 *
*								         *
**************************************************************************


	.IF GERMAN
MEN_MAIN
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESSMAIN	;TITLE
	.WORD	COLOR_WHITE	;COLOR OF TITLE
	.WORD	MENU_X		;UL X
	.WORD	MENU_Y+2	;UL Y
	.WORD	MENU_DY-2	;VERTICAL SPACING
	.WORD	COLOR_WHITE	;COLOR WHEN NOT SELECTED
	.WORD	BAR_HITE-2	;HEIGHT OF SELECTION BAR
	.WORD	BAR_DY		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	BAR_WID		;WIDTH OF BAR!
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_DIAG,GO_DIAG,DIAG_HELP
	.LONG	MESS_COIN_AUD,GO_BOOK,BLNK_HELP
	.LONG	MESS_GAME_AUD,GO_AUD,BLNK_HELP
	.LONG	MESS_GAME_ADJ,GO_ADJ,BLNK_HELP
	.LONG	MESS_UTIL,GO_UTIL,UTIL_HELP
;	.LONG	M_CALIBRATE,GO_CALIBRATE,BLNK_HELP
	.LONG	MESS_EXIT,0,BLNK_HELP
	.LONG	0		;END
	.ELSE
MEN_MAIN
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESSMAIN	;TITLE
	.WORD	COLOR_WHITE	;COLOR OF TITLE
	.WORD	MENU_X		;UL X
	.WORD	MENU_Y+2	;UL Y
	.WORD	MENU_DY-2	;VERTICAL SPACING
	.WORD	COLOR_WHITE	;COLOR WHEN NOT SELECTED
	.WORD	BAR_HITE-2	;HEIGHT OF SELECTION BAR
	.WORD	BAR_DY		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	BAR_WID		;WIDTH OF BAR!
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_DIAG,GO_DIAG,DIAG_HELP
	.LONG	MESS_COIN_AUD,GO_BOOK,COIN_HELP
	.LONG	MESS_GAME_AUD,GO_AUD,AUDIT_HELP
	.LONG	MESS_GAME_ADJ,GO_ADJ,ADJUST_HELP
	.LONG	MESS_UTIL,GO_UTIL,UTIL_HELP
;	.LONG	M_CALIBRATE,GO_CALIBRATE,CALIBRATE_HELP
	.LONG	MESS_EXIT,0,EXIT_HELP
	.LONG	0		;END
	.ENDIF


	.IF GERMAN

MESSMAIN
	.STRING	"NHL HOCKEY  ",W_TEST,"  MEN",C_GERU,0
	.EVEN

MESS_DIAG
	.STRING	"DIAGNOSE-",W_TEST,"S",0
	.EVEN

MES_BOOK
MESS_COIN_AUD
	.STRING	"M{NZBUCHHALTUNG",0
	.EVEN

MES_AUD
MESS_GAME_AUD
	.STRING	"AUSLESEDATEN",0
	.EVEN

MESS_GAME_ADJ
	.STRING	"SPIEL-EINSTELLUNG",0
	.EVEN

MESS_UTIL
	.STRING	W_TEST,"-FUNKTIONEN",0
	.EVEN

M_CALIBRATE
	.STRING	"PISTOLEN KALIBRIEREN",0
	.EVEN

MESS_EXIT
	.STRING	"{BERGANG INS SPIELENDE",0
	.EVEN

	.ELSE

MESSMAIN
	.STRING	"NHL HOCKEY  ",W_TEST,"  MENU",0
	.EVEN

MESS_DIAG
	.STRING	"DIAGNOSTIC ",W_TEST,"S",0
	.EVEN

MES_BOOK
MESS_COIN_AUD
	.STRING	W_COIN," ",W_BOOK,"KEEPING",0
	.EVEN

MES_AUD
MESS_GAME_AUD
	.STRING	W_GAME," ",W_AUDITS,0
	.EVEN

MESS_GAME_ADJ
	.STRING	W_GAME," ",W_ADJUSTMENT,0
	.EVEN

MESS_UTIL
	.STRING	"UTILITIES",0
	.EVEN

M_CALIBRATE
	.STRING	"CALIBRATE GUNS",0
	.EVEN

MESS_EXIT
	.STRING	"EXIT TO ",W_GAME," OVER",0
	.EVEN

	.ENDIF

DIAG_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	7		;2 ENTRIES
	.LONG	MESS_SWTEST
	.LONG	MESS_DIPTEST
	.LONG	MESS_CPUTEST
	.LONG	M_STEST
	.LONG	MESS_PATTERNS
	.LONG	MESS_DRIVER
	.LONG	U_BURNIN

COIN_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD	COLOR_BLUE      ;COLOR
         .WORD   3               ;2 ENTRIES
         .LONG   CH_0
         .LONG   CH_1
         .LONG   CH_2

AUDIT_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD	COLOR_BLUE      ;COLOR
         .WORD   2               ;2 ENTRIES
         .LONG   AH_1
         .LONG   AH_2

ADJUST_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD	COLOR_BLUE      ;COLOR
         .WORD   3               ;3 ENTRIES
         .LONG   AD_1
         .LONG   AD_2
         .LONG   AD_3

CALIBRATE_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD	COLOR_BLUE      ;COLOR
         .WORD   3               ;3 ENTRIES
         .LONG   GCH_1
         .LONG   GCH_2
         .LONG   GCH_3

UTIL_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	5		;NUMBER OF ENTRIES
****	.LONG	U_OPMESS
	.LONG	U_CLR_CRED
	.LONG	U_CLR_COIN
	.LONG	U_CLR_AUD
	.LONG	U_HSRESET
	.LONG	U_FACTORY

EXIT_HELP
         .WORD   0               ;CENTER JUSTIFY
         .WORD	COLOR_BLUE      ;COLOR
         .WORD   1               ;1 ENTRY
         .LONG   U_END

	 .IF GERMAN

MESS_SWTEST
	.STRING	"KONTAKT-",W_TEST,0
	.EVEN
MESS_DIPTEST
	.STRING "DIP-SCHALTER-",W_TEST,0
	.EVEN
MESS_CPUTEST
	.STRING "CPU-PLATINEN-",W_TEST,0
	.EVEN
MESS_STEST
M_STEST
	.STRING	"SOUND-PLATINEN-",W_TEST,0
	.EVEN
MESS_PATTERNS
	.STRING "MONITOR-MUSTER",0
	.EVEN
MESS_DRIVER
	.STRING	"TREIBER-PLATINEN-",W_TEST,0
	.EVEN

MESS_BURN
U_BURNIN
	.STRING "BURN-IN-",W_TEST,0
	.EVEN

	.ELSE

MESS_SWTEST
	.STRING	W_SWITCH," ",W_TEST,0
	.EVEN
MESS_DIPTEST
	.STRING "DIP ",W_SWITCH," ",W_TEST,0
	.EVEN
MESS_CPUTEST
	.STRING "CPU ",W_BOARD," ",W_TEST,0
	.EVEN
MESS_STEST
M_STEST
	.STRING	"SOUND ",W_BOARD," ",W_TEST,0
	.EVEN
MESS_PATTERNS
	.STRING "MONITOR PATTERNS",0
	.EVEN
MESS_DRIVER
	.STRING	"DRIVER ",W_BOARD," ",W_TEST,0
	.EVEN

MESS_BURN
U_BURNIN
	.STRING "BURN-IN ",W_TEST,0
	.EVEN

	.ENDIF

CH_0
	.STRING	"VIEW COINBOX",0
	.EVEN
CH_1
	.STRING	W_TOTALS," AND",0
	.EVEN
CH_2
	.STRING	W_GAME,W_PLAY," COUNTERS",0
	.EVEN

AH_1
	.STRING	"VIEW ",W_GAME,0
	.EVEN
AH_2
	.STRING	W_PLAY," STATISTICS",0
	.EVEN

AD_1
	.STRING	"MAKE CHANGES",0
	.EVEN
AD_2
	.STRING	"TO PRICING AND",0
	.EVEN
AD_3
	.STRING	W_GAME," DIFFICULTY",0
	.EVEN

GCH_1
	.STRING	"ALIGN GUNS",0
	.EVEN
GCH_2
	.STRING	"SO THAT CURSOR",0
	.EVEN
GCH_3
	.STRING	"TRACKS ACCURATELY.",0
	.EVEN

	.IF GERMAN

MESS_MM
	.STRING	"ZUR",C_GERU,"CH INS HAUPTMEN",C_GERU,0
	.EVEN
MESS_HSRESET
U_HSRESET
	.STRING "HIGHSCORE L",C_GERO,"SCHEN",0
	.EVEN

U_FACTORY
	.STRING "FABRIKDATENEINSTELLUNG",0
	.EVEN

	.ELSE

MESS_MM
	.STRING	"RETURN TO MAIN MENU",0
	.EVEN
MESS_HSRESET
U_HSRESET
	.STRING "RESET HIGH SCORES",0
	.EVEN
U_FACTORY
	.STRING W_FACSET,"S",0
	.EVEN

	.ENDIF

****U_OPMESS
****	.STRING "OPERATOR ",W_MESSAGE,0
****	.EVEN
U_END
	.STRING "END ",W_TEST,"ING",0
	.EVEN

**************************************************************************
*								         *
* 	SOUNDS SYSTEM TESTS MENU					 *
*								         *
**************************************************************************

MEN_STEST
         .LONG   RD7FONT	;FONT
         .LONG   STRCNRM	;CENTER PLEASE
         .LONG   M_STEST	;TITLE
         .WORD   COLOR_GREEN	;COLOR OF TITLE
         .WORD   200		;UL X
         .WORD   MENU_Y-3	;UL Y
         .WORD   18             ;VERTICAL SPACING
         .WORD   COLOR_RED	;COLOR WHEN NOT SELECTED
         .WORD   18		;HEIGHT OF SELECTION BAR
         .WORD   -6		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
         .WORD   BAR_DX		;EXTRA X ON EACH SIDE.
         .WORD   195		;WIDTH OF BAR!
         .WORD   COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
         .LONG   M_DIGT,GO_DIGT,SND_HELP
         .LONG   M_SYNP,GO_SYNP,SND_PLAY

         .LONG   MESS_DIAGM,0,SND_HELP
         .LONG   MESS_MM,FORCE_MAIN,SND_HELP
         .LONG   0

	 .IF GERMAN

M_DIGT
	.STRING	"ALLGEMEINER ",W_TEST,0
	.EVEN
M_SYNP
	.STRING	"MUSIK SPIELEN",0
	.EVEN

	.ELSE

M_DIGT
	.STRING	"GENERAL ",W_TEST,0
	.EVEN
M_SYNP
	.STRING	W_PLAY," SOUNDS",0
	.EVEN

	.ENDIF

DAC_LX   EQU     125

*
*MESSAGE FOR SOUND BOARD IRQ NOT WORKING
*
SIRQ_ERR
	MESS_MAC RD15FONT,SPACING07,200,95,COLOR_PLF,STRCNRM,0
	.STRING	"** WARNING! **",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,200,120,COLOR_PYELLOW,STRCNRM,0
	.STRING	"UNABLE TO DETECT ",W_SOUND," BOARD IRQ.",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,200,135,COLOR_PYELLOW,STRCNRM,0
	.STRING	"THIS MAY RESULT IN ERRANT ",W_SOUND,"S.",0
	.EVEN
	.WORD	0

*
*FOOTNOTE MESSAGE TO REMIND US THAT THE IRQ FAILED
*
SIRQ_ERR2
	MESS_MAC RD7FONT,SPACING07,200,165,COLOR_PRED,STRCNRM,0
	.STRING	W_ERROR," - ",W_SOUND," IRQ NOT DETECTED.",0
	.EVEN
	.WORD	0

	.IF GERMAN

*
*FOOTNOTE MESSAGE TO TELL US THAT THE IRQ LINE WAS CHECKED
*
SIRQ_DETECT
         MESS_MAC  RD7FONT,SPACING07,200,165,COLOR_PGREEN,STRCNRM,0
	.STRING	W_SOUND," IRQ FUNKTIONIERT.",0
	.EVEN
	.WORD	0

*
*CLUE OPERATOR IN ON HOW TO TELL IF HIS SOUND BOARD IS WORKING
*
DAC_LX2  EQU     DAC_LX+52

DAC_ERR
	MESS_MAC RD7FONT,SPACING07,200,80,COLOR_PLF,STRCNRM,0
	.STRING	"AUF GER[SCHE ACHTEN:",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,DAC_LX,105,COLOR_PYELLOW,STRLNRM,0
	.STRING	"0 GER[SCHE - HARDWARE PR{FEN",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,DAC_LX,117,COLOR_PYELLOW,STRLNRM,0
	.STRING	"1 GER[SCHE - ",W_SOUND,"-PLATINE OK",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,DAC_LX,129,COLOR_PYELLOW,STRLNRM,0
	.STRING	"2 GER[SCHE - RAM-FEHLER U2",0
	.EVEN
	.WORD	1
         MESS_MAC  RD7FONT,SPACING07,DAC_LX,141,COLOR_PYELLOW,STRLNRM,0
	.STRING	"3 GER[SCHE - ROM-FEHLER U3",0
	.EVEN
	.WORD	0

	.ELSE

*
*FOOTNOTE MESSAGE TO TELL US THAT THE IRQ LINE WAS CHECKED
*
SIRQ_DETECT
         MESS_MAC  RD7FONT,SPACING07,200,165,COLOR_PGREEN,STRCNRM,0
	.STRING	W_SOUND," IRQ DETECT FUNCTIONAL.",0
	.EVEN
	.WORD	0

*
*CLUE OPERATOR IN ON HOW TO TELL IF HIS SOUND BOARD IS WORKING
*
DAC_LX2  EQU     DAC_LX+52

DAC_ERR
	MESS_MAC RD7FONT,SPACING07,200,80,COLOR_PLF,STRCNRM,0
	.STRING	"LISTEN FOR ",W_TONE,"S:",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,DAC_LX,105,COLOR_PYELLOW,STRLNRM,0
	.STRING	"0 ",W_TONE,"S - CHECK HARDWARE",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,DAC_LX,117,COLOR_PYELLOW,STRLNRM,0
	.STRING	"1 ",W_TONE," ",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,DAC_LX2,117,COLOR_PYELLOW,STRLNRM,0
	.STRING	"- ",W_SOUND," BOARD OK",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,DAC_LX,129,COLOR_PYELLOW,STRLNRM,0
	.STRING	"2 ",W_TONE,"S - RAM ",W_ERROR," U2",0
	.EVEN
	.WORD	1
         MESS_MAC  RD7FONT,SPACING07,DAC_LX,141,COLOR_PYELLOW,STRLNRM,0
	.STRING	"3 ",W_TONE,"S - ROM ",W_ERROR," U3",0
	.EVEN
	.WORD	0

	.ENDIF

**************************************************************************
*								         *
* 	DIAGNOSTIC TESTS MENU						 *
*								         *
**************************************************************************

MEN_DIAG
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESS_DIAG	;TITLE
	.WORD	COLOR_RED	;COLOR OF TITLE
	.WORD	200		;UL X
	.WORD	MENU_Y-3	;UL Y
	.WORD	MENU_DY-6	;VERTICAL SPACING
	.WORD	COLOR_RED	;COLOR WHEN NOT SELECTED
	.WORD	BAR_HITE-7	;HEIGHT OF SELECTION BAR
	.WORD	-6		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	195		;WIDTH OF BAR!  (A LITTLE FATTER)
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM (SHOULD BE DECAY)
	.LONG	MESS_SWTEST,GO_SWITCH,BLNK_HELP
	.LONG	MESS_DIPTEST,GO_DIP,BLNK_HELP
ROM_LEV	EQU	3		;TEST NUMBER FOLLOWING ROM TEST
	.LONG	MESS_CPUTEST,GO_CPU,BLNK_HELP
RTR_LEV	EQU	4		;TEST NUMBER FOLLOWING CPU TEST (FOR RETURN)
	.LONG	M_STEST,GO_STEST,BLNK_HELP
	.LONG	MESS_PATTERNS,GO_PATTERNS,BLNK_HELP
;	.LONG	MESS_DRIVER,GO_DRIVER,BLNK_HELP
	.LONG	MESS_BURN,GO_BURN,BLNK_HELP
	.LONG	MESS_MM,0,BLNK_HELP        ;RETURN TO MAIN MENU
	.LONG	0

**************************************************************************
*								         *
* 	BOOKKEEPING							 *
*								         *
**************************************************************************

**************************************************************************
*                                                                        *
*          AUDIT TABLE STRUCTURE                                         *
*                                                                        *
**************************************************************************

AUD_MESS	EQU	0			;LONG-PTR TO TEXT
AUD_ROUTINE	EQU	AUD_MESS+LONG_SIZE	;LONG - NON ZERO MEANS CALL FOR NUMBER
AUD_NUMBER	EQU	AUD_ROUTINE+LONG_SIZE	;WORD - IF ABOVE ZERO, THEN AUDIT NUMBER
AUD_T_SIZE	EQU	AUD_NUMBER+WORD_SIZE

AMAC     .MACRO  MESS,ROUT,AUDIT
         .LONG   :MESS:
         .LONG   :ROUT:
         .WORD   :AUDIT:
         .ENDM

AUD_LM		EQU	TIT_ULX			;SQUARE OFF AUDITS W/ HEADER.
AUD_RM		EQU	TIT_LRX
AUD_Y_START	EQU	61
AUD_DY		EQU	18

CP2_Y		EQU	142			;PART 2 OF COIN AUDIT PAGE.

MES_TOTALS
	.STRING	W_TOTAL," ",W_COLLECTION,0
	.EVEN

*
*	DETAILED COINAGE AVAILABLE (ON 1ST COINAGE PAGE)
*
MEN_DETAIL
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESS_PATTERNS	;TITLE
	.WORD	COLOR_YELLOW	;COLOR OF TITLE
	.WORD	200		;UL X	(CENTER IT!)
	.WORD	227		;UL Y
	.WORD	12		;VERTICAL SPACING
	.WORD	COLOR_BLUE	;COLOR WHEN NOT SELECTED
	.WORD	12		;HEIGHT OF SELECTION BAR
	.WORD	-2		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	170		;WIDTH OF BAR!
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_DETAIL,0,NO_HELP		;DETAILED SECTION
	.LONG	MESS_MM,FORCE_MAIN,NO_HELP	;RETURN TO MAIN MENU
	.LONG	0

	.IF GERMAN

MESS_DETAIL
         .STRING         "WEITERE DATEN"
         .BYTE           0
         .EVEN

	.ELSE

MESS_DETAIL
         .STRING         "MORE DETAILED DATA"
         .BYTE           0
         .EVEN

	.ENDIF


*
*        TOP HALF OF COIN AUDIT PAGE 1 TABLE
*
COIN_AUDS
	.WORD	AUD_Y_START		;Y START
	.WORD	16			;Y BETWEEN ENTRIES
	.WORD	AUD_LM			;LEFT MARGIN X
	.WORD	AUD_RM			;RIGHT MARGIN X
	AMAC	M_LCOIN,0,AUDLCOIN
	AMAC	M_RCOIN,0,AUDRCOIN
	AMAC	M_CCOIN,0,AUDCCOIN
	AMAC	M_4COIN,0,AUD4COIN
	AMAC	M_SCOIN,0,AUDSCOIN
	AMAC	M_PAIDC,0,AUDPAIDC
	AMAC	M_START,STARTS,0
	AMAC	M_CONT,CONTINS,0
	AMAC	M_PLAYS,DOPLAYS,0
	AMAC	M_HSLEFT,DOHSLEFT,0
	.LONG	0

	.IF GERMAN

M_WDOG:
	.STRING	"WATCHDOGS AUSGEL",C_GERO,"ST",0
	.EVEN
M_SECURITY
	.STRING	"FEHLSTARTS",0
	.EVEN

	.ELSE

M_WDOG:
	.STRING	"WATCHDOGS TRIGGERED",0
	.EVEN
M_SECURITY
	.STRING	"START FAILURES",0
	.EVEN

	.ENDIF

M_BADTRAP
	.STRING	"SOFTWARE TRAPS",0
	.EVEN
M_WARNING
	.STRING	"SOFTWARE WARNINGS",0
	.EVEN

*
*        BOTTOM HALF OF COIN AUDIT PAGE 1 TABLE
*

	.IF GERMAN

M_LCOIN
	.STRING "LINKER M",C_GERU,"NZEINWURF",0
        .EVEN
M_CCOIN
	.STRING "3. M",C_GERU,"NZEINWURF",0
        .EVEN
M_RCOIN
	.STRING "RECHTER M",C_GERU,"NZEINWURF",0
        .EVEN
M_4COIN
	.STRING	"4. M",C_GERU,"NZEINWURF",0
	.EVEN
M_SCOIN
	.STRING	"SERVICE-KREDITE",0
	.EVEN
M_PAIDC
	.STRING "GESPIELTE KREDITE",0
	.EVEN
M_START
	.STRING	"GESTARTETE SPIELE",0
	.EVEN
M_CONT
	.STRING	"SPIELFORTSETZUNGEN",0
	.EVEN
M_PLAYS
	.STRING	"GESAMTSPIELE",0
	.EVEN
M_HSLEFT
	.STRING	"SPIELE BIS H.S.-R",C_GERU,"CKSTELLUNG",0
	.EVEN
M_HSOFF
	.STRING "OFF",0
	.EVEN

	.ELSE

M_LCOIN
	.STRING W_LEFT," ",W_SLOT," ",W_COINS,0
        .EVEN
M_CCOIN
	.STRING "THIRD ",W_SLOT," ",W_COINS,0
        .EVEN
M_RCOIN
	.STRING W_RIGHT," ",W_SLOT," ",W_COINS,0
        .EVEN
M_4COIN
	.STRING	W_FOURTH," ",W_SLOT," ",W_COINS,0
	.EVEN
M_SCOIN
	.STRING	"SERVICE ",W_CREDITS,0
	.EVEN
M_PAIDC
	.STRING "PAID ",W_CREDITS,0
	.EVEN
M_START
	.STRING W_GAMES," ",W_START,"ED",0
	.EVEN
M_CONT
	.STRING W_GAMES," ",W_CONTINUE,"D",0
	.EVEN
M_PLAYS
	.STRING W_TOTAL," ",W_PLAYS,0
	.EVEN
M_HSLEFT
	.STRING W_PLAYS," UNTIL H.S. RESET",0
	.EVEN
M_HSOFF
	.STRING "OFF",0
	.EVEN

	.ENDIF

*
*        AUDIT TEXT
*
MESS_ERROR
         MESS_MAC  RD7FONT,SPACING07,0,0,COLOR_PRED,STRLNRM,0
         .STRING   "  ",W_ERROR
         .BYTE     0
         .EVEN

MESS_AUD_NUM
         MESS_MAC  RD7FONT,SPACING07,367,227,COLOR_PYELLOW,STRRNRM,0

MESS15_AUD_NUM
         MESS_MAC  RD15FONT,SPACING07,367,227,COLOR_PYELLOW,STRRNRM,0

MESS_AUD_LINE
         MESS_MAC  RD7FONT,SPACING07,30,355,COLOR_PYELLOW,STRLNRM,0

MESS15_AUD_LINE
         MESS_MAC  RD15FONT,SPACING07,30,355,COLOR_PYELLOW,STRLNRM,0

**************************************************************************
*                                                                        *
*          COIN_D1                                                       *
*                                                                        *
*          THIS IS TOP HALF OF DETAILED COIN AUDIT PAGE                  *
*          ITS THE SAME AS THE OTHER COIN PAGE WITH THE Y POSITIONING    *
*          A LITTLE DIFFERENT                                            *
*                                                                        *
**************************************************************************
COIN_D1
	.WORD	AUD_Y_START+7
	.WORD	24			;Y BETWEEN ENTRIES
	.WORD	AUD_LM			;LEFT MARGIN X
	.WORD	AUD_RM			;RIGHT MARGIN X
	AMAC	M_LCOIN,0,AUDLCOIN
	AMAC	M_RCOIN,0,AUDRCOIN
	AMAC	M_CCOIN,0,AUDCCOIN
	AMAC	M_4COIN,0,AUD4COIN
	AMAC	M_TOTCOL,DO_MONEY,0
	.LONG	0

COIN_SD1
	.WORD	AUD_Y_START+7
	.WORD	24			;Y BETWEEN ENTRIES
	.WORD	AUD_LM			;LEFT MARGIN X
	.WORD	AUD_RM			;RIGHT MARGIN X
	AMAC	M_LCOIN,0,AUDLCOIN
	AMAC	M_RCOIN,0,AUDRCOIN
	AMAC	M_CCOIN,0,AUDCCOIN
	AMAC	M_4COIN,0,AUD4COIN
	.LONG	0

*
*        DOOR CLOSED AUDITS.
*
M_TOTCOL
	.STRING	W_TOTAL,0
	.EVEN

	.IF GERMAN

MESS_CLEAR_SUBS
	.STRING	"M",C_GERU,"NZZ",C_GERA,"HLER-L",C_GERO,"SCHEN",0
	.EVEN

	.ELSE

MESS_CLEAR_SUBS
	.STRING	W_CLEAR," ",W_COINCOUNTS,0
	.EVEN

	.ENDIF

MESS_SUBS_CLEAR
	.STRING	W_COINCOUNTS," ",W_CLEAR,"ED",0
	.EVEN

	.IF GERMAN

MESS_YES
	.STRING	"JA",0
	.EVEN
MESS_NO
	.STRING	"NEIN",0
	.EVEN

	.ELSE

MESS_YES
	.STRING	"YES",0
	.EVEN
MESS_NO
	.STRING	"NO",0
	.EVEN

	 .ENDIF

*
*	CLEAR SUB-TOTALS (ON DETAILED COINAGE PAGE)
*
MEN_CLR_SUB
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESS_PATTERNS	;TITLE
	.WORD	COLOR_YELLOW	;COLOR OF TITLE
	.WORD	200		;UL X	(CENTER IT!)
	.WORD	227		;UL Y
	.WORD	12		;VERTICAL SPACING
	.WORD	COLOR_BLUE	;COLOR WHEN NOT SELECTED
	.WORD	12		;HEIGHT OF SELECTION BAR
	.WORD	-2		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	170		;WIDTH OF BAR!
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG   MESS_CLEAR_SUBS,0,NO_HELP	;CLEAR SUB-TOTALS
	.LONG	MESS_MM,FORCE_MAIN,NO_HELP	;RETURN TO MAIN MENU
	.LONG	0

*
*	YES/NO	(FOR ARE YOU SURE?)
*
MEN_YN
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESS_PATTERNS	;TITLE
	.WORD	COLOR_RED	;COLOR OF TITLE
	.WORD	200		;UL X
	.WORD	166		;UL Y
	.WORD	17		;VERTICAL SPACING
	.WORD	COLOR_YELLOW	;COLOR WHEN NOT SELECTED
	.WORD	17		;HEIGHT OF SELECTION BAR
	.WORD	-4		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	78		;WIDTH OF BAR!  (A LITTLE FATTER)
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_YES,0,NO_HELP
	.LONG	MESS_NO,0,NO_HELP
	.LONG	0

**************************************************************************
*								         *
*          	GAME PLAY AUDIT PAGES					 *
*								         *
**************************************************************************
GAME_AUDS
	.WORD	61			;Y START
	.WORD	17			;Y BETWEEN ENTRIES
	.WORD	AUD_LM			;LEFT MARGIN X
	.WORD	AUD_RM			;RIGHT MARGIN X
	AMAC	M_PLAYS,DOPLAYS,0	;PLAYS ON TOP
	AMAC	M_START,STARTS,0
	AMAC	M_CONT,CONTINS,0
	AMAC	M_TTIME,DO_PTIME,0
	AMAC	M_UPTIME,DO_UPTIME,0
	AMAC	M_AVGTC,DO_AVGTC,0
	AMAC	M_1TIME,DO_P1TIME,0
	AMAC	M_2TIME,DO_P2TIME,0
	AMAC	M_3TIME,DO_P3TIME,0
	.LONG	0

GAME_AUD2
	.WORD	61			;Y START
	.WORD	17			;Y BETWEEN ENTRIES
	.WORD	AUD_LM			;LEFT MARGIN X
	.WORD	AUD_RM			;RIGHT MARGIN X
	AMAC 	M_PLAYS,DOPLAYS,0	;PLAYS ON TOP
	AMAC	M_CONTOFF,0,AUDCONTOFFER
	AMAC	M_CONTTAK,0,AUDCONTTAKEN
	AMAC	M_PCTCONT,DO_PCTCONT,0
	AMAC	M_COSTPG,DO_AVGGC,0
	AMAC	M_WAVER,DO_AVGWAVE,0
	AMAC	M_GAMEC,0,AUDFINISH
	AMAC	M_MAXWAVE,0,AUDMAXWAVE
	.LONG	0

GAME_AUD3
	.WORD	61			;Y START
	.WORD 	17			;Y BETWEEN ENTRIES
	.WORD 	AUD_LM			;LEFT MARGIN X
	.WORD 	AUD_RM			;RIGHT MARGIN X
	AMAC	M_SLAMS,0,AUDSLAMS
	AMAC	M_BURNIN,0,AUDAUTO
	AMAC	M_SECURITY,0,AUDSECURITY
	.LONG	0

GAME_AUD4
	.WORD	61			;Y START
	.WORD 	17			;Y BETWEEN ENTRIES
	.WORD 	AUD_LM			;LEFT MARGIN X
	.WORD 	AUD_RM			;RIGHT MARGIN X
	AMAC	M_WDOG,0,AUDDOGGY
	AMAC	M_WARNING,0,AUDWARNING
	AMAC	M_BADTRAP,0,AUDBADTRAP
	.LONG	0

**************************************************************************
*								         *
* 		    AUDIT PAGE OPTIONS #1				 *
* 									 *
* 			TO NEXT PAGE					 *
* 		     RETURN TO MAIN MENU				 *
*								         *
**************************************************************************
MEN_AP1
	.LONG	RD7FONT			;FONT
	.LONG	STRCNRM			;CENTER PLEASE
	.LONG	MESS_PATTERNS		;TITLE
	.WORD	COLOR_YELLOW		;COLOR OF TITLE
	.WORD	200			;UL X      (CENTER IT!)
	.WORD	227			;UL Y
	.WORD	12			;VERTICAL SPACING
	.WORD	COLOR_BLUE		;COLOR WHEN NOT SELECTED
	.WORD	12			;HEIGHT OF SELECTION BAR
	.WORD	-2			;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX+5		;EXTRA X ON EACH SIDE.
	.WORD	170			;WIDTH OF BAR!
	.WORD	COLOR_DECAY		;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_TOPAGE2,0,NO_HELP		;"TO NEXT PAGE"
	.LONG	MESS_MM,FORCE_MAIN,NO_HELP	;"RETURN TO MAIN MENU"
	.LONG	0

**************************************************************************
*								         *
* 		    AUDIT PAGE OPTIONS #2				 *
* 									 *
* 			TO NEXT PAGE					 *
* 		      TO PREVIOUS PAGE					 *
* 		     RETURN TO MAIN MENU				 *
*								         *
**************************************************************************
MEN_AP2
	.LONG	RD7FONT			;FONT
	.LONG	STRCNRM			;CENTER PLEASE
	.LONG	MESS_PATTERNS		;TITLE
	.WORD	COLOR_YELLOW		;COLOR OF TITLE
	.WORD	200			;UL X      (CENTER IT!)
	.WORD	216			;UL Y
	.WORD	12			;VERTICAL SPACING
	.WORD	COLOR_BLUE		;COLOR WHEN NOT SELECTED
	.WORD	12			;HEIGHT OF SELECTION BAR
	.WORD	-2			;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX+5		;EXTRA X ON EACH SIDE.
	.WORD	170			;WIDTH OF BAR!
	.WORD	COLOR_DECAY		;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_TOPAGE2,0,NO_HELP		;"TO NEXT PAGE"
	.LONG	MESS_BACKP1,0,NO_HELP		;"TO PREVIOUS PAGE"
	.LONG	MESS_MM,FORCE_MAIN,NO_HELP	;"RETURN TO MAIN MENU"
	.LONG	0

**************************************************************************
*								         *
* 		    AUDIT PAGE OPTIONS #3				 *
* 									 *
* 		      TO PREVIOUS PAGE					 *
* 		     RETURN TO MAIN MENU				 *
*								         *
**************************************************************************
MEN_AP3
	.LONG	RD7FONT			;FONT
	.LONG	STRCNRM			;CENTER PLEASE
	.LONG	MESS_PATTERNS		;TITLE
	.WORD	COLOR_YELLOW		;COLOR OF TITLE
	.WORD	200			;UL X      (CENTER IT!)
	.WORD	227			;UL Y
	.WORD	12			;VERTICAL SPACING
	.WORD	COLOR_BLUE		;COLOR WHEN NOT SELECTED
	.WORD	12			;HEIGHT OF SELECTION BAR
	.WORD	-2			;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX+5		;EXTRA X ON EACH SIDE.
	.WORD	170			;WIDTH OF BAR!
	.WORD	COLOR_DECAY		;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_BACKP1,0,NO_HELP	;"TO PREVIOUS PAGE"
	.LONG	MESS_MM,FORCE_MAIN,NO_HELP	;"RETURN TO MAIN MENU"
	.LONG	0


**************************************************************************
*								         *
* 			AUDIT PAGE MESSAGES				 *
*								         *
**************************************************************************
	.IF GERMAN

MESS_TOPAGE2
	.STRING	"N",C_GERA,"CHSTE AUSLESE-SEITE",0
	.EVEN
MESS_BACKP1
	.STRING	"VORHERIGE AUSLESE-SEITE",0
	.EVEN
M_GAMEC
	.STRING	"KOMPLETT DURCHGESPIELTE SPIELE",0
	.EVEN
M_WAVER
	.STRING	"DURCHSCHN. ERREICHTE WELLE",0
	.EVEN
M_COSTPG
	.STRING	"DURCHSCHN. KREDIT/SPIEL",0
	.EVEN
M_BURNIN
	.STRING	"BURN-IN-TEST ERFOLGREICH BEENDET",0
	.EVEN
M_1TIME
	.STRING	"ZEIT F. 1 SPIELER",0
	.EVEN
M_2TIME
	.STRING	"ZEIT F. 2 SPIELER",0
	.EVEN
M_3TIME
	.STRING	"ZEIT F. 3 SPIELER",0
	.EVEN
M_TTIME
	.STRING	"GESAMT-SPIELZEIT",0
	.EVEN
M_UPTIME
	.STRING	"EINSCHALTZEIT",0
	.EVEN
M_AVGTL
	.STRING	"DURCHSCHN. ZEIT/LIFE",0
	.EVEN
M_AVGTC
	.STRING	"DURCHSCHN. ZEIT/KREDIT",0
	.EVEN
M_MAXWAVE
	.STRING	"MAXIMUM-WELLE ERREICHT",0
	.EVEN
M_CONTOFF
	.STRING "ANGEBOTENE SPIELFORTSETZUNGEN",0
	.EVEN
M_CONTTAK
	.STRING	"ANGENOMMENE SPIELFORTSETZUNGEN",0
	.EVEN
M_PCTCONT
	.STRING	"PERCENTAGE OF ",W_CONTINUES," TAKEN",0
	.EVEN
M_SLAMS
	.STRING	"M",C_GERU,"NZT",C_GERU,"R-SLAMS",0
	.EVEN

	.ELSE

MESS_TOPAGE2
	.STRING	"NEXT ",W_AUDIT," PAGE",0
	.EVEN
MESS_BACKP1
	.STRING	"PREVIOUS ",W_AUDIT," PAGE",0
	.EVEN
M_GAMEC
	.STRING	W_GAME,"S ",W_PLAY,"ED TO COMPLETION",0
	.EVEN
M_WAVER
	.STRING	W_AVERAGE," WAVE REACHED",0
	.EVEN
M_COSTPG
	.STRING	W_AVERAGE," ",W_CREDITS,"/",W_GAME,0
	.EVEN
M_BURNIN
	.STRING	"BURNIN LOOPS SUCCESSFULLY COMPLETED",0
	.EVEN
M_1TIME
	.STRING	W_TIME," 1 ",W_PLAYER," ONLY",0
	.EVEN
M_2TIME
	.STRING	W_TIME," 2 ",W_PLAYER," ",W_SIMULTANEOUS,0
	.EVEN
M_3TIME
	.STRING	W_TIME," 3 ",W_PLAYER," ",W_SIMULTANEOUS,0
	.EVEN
M_TTIME
	.STRING	W_TOTAL," ",W_PLAY," ",W_TIME,0
	.EVEN
M_UPTIME
	.STRING	W_TOTAL," ",W_GAME," UPTIME",0
	.EVEN
M_AVGTL
	.STRING	W_AVERAGE," ",W_TIME," / LIFE",0
	.EVEN
M_AVGTC
	.STRING	W_AVERAGE," ",W_TIME," / ",W_CREDIT,0
	.EVEN
M_MAXWAVE
	.STRING	"MAXIMUM WAVE COMPLETED",0
	.EVEN
M_CONTOFF
	.STRING W_GAME," ",W_CONTINUES," OFFERED",0
	.EVEN
M_CONTTAK
	.STRING	W_GAME," ",W_CONTINUES," TAKEN",0
	.EVEN
M_PCTCONT
	.STRING	"PERCENTAGE OF ",W_CONTINUES," TAKEN",0
	.EVEN
M_SLAMS
	.STRING	W_COIN," DOOR SLAMS",0
	.EVEN

	.ENDIF

**************************************************************************
*								         *
* 	UTILITIES MENU							 *
*								         *
**************************************************************************

*
*        UTILITES MENU GOES LEFT OF CENTER
*

UM_WID   EQU     206
UM_X     EQU     TIT_ULX+GAP+MB_XWID+(UM_WID/2)+C_KLUDGE

	.IF GERMAN

MEN_UTIL
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESS_UTIL	;TITLE
	.WORD	COLOR_WHITE	;COLOR OF TITLE
	.WORD	UM_X		;UL X
	.WORD	MENU_Y-5	;UL Y
	.WORD	20		;VERTICAL SPACING
	.WORD	COLOR_WHITE	;COLOR WHEN NOT SELECTED
	.WORD	19		;HEIGHT OF SELECTION BAR
	.WORD	-5		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	UM_WID		;WIDTH OF BAR!
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
****	.LONG	MESS_OPMESS,DO_OPMESS,BLNK_HELP
	.LONG	MESS_CLCRED,DO_CLCRED,BLNK_HELP
	.LONG	MESS_CLCOIN,DO_CLCOIN,BLNK_HELP
	.LONG	MESS_CLAUD,DO_CLAUD,BLNK_HELP
	.LONG	MESS_HSRES,DO_HSRES,BLNK_HELP
	.LONG	MESS_DEF_ADJ,DO_DEF_ADJ,BLNK_HELP
	.LONG	MESS_FACSET,DO_FACSET,BLNK_HELP
	.LONG	MESS_MM,0,BLNK_HELP		;RETURN TO MAIN MENU
	.LONG	0		;END

MESS_CLCRED
U_CLR_CRED
MESS_CCCONF
	.STRING "KREDITE-L]SCHUNG",0
	.EVEN
MESS_CLCOIN
U_CLR_COIN
	.STRING "M{NZZ[HLER-L]SCHUNG",0
	.EVEN
MESS_CLAUD
U_CLR_AUD
	.STRING "AUSLESEDATEN L]SCHEN",0
	.EVEN
MESS_HSRES
	.STRING "HIGHSCORE L]SCHEN",0
	.EVEN
MESS_FACSET
	.STRING "FABRIKDATENEINSTELLUNG",0
	.EVEN
MESS_FACFAIL
	.STRING	"CMOS SCHLECHT",0
	.EVEN
MESS_CANCELLED
	.STRING "CANCELLED",0
	.EVEN
MESS_DEF_ADJ
	.STRING "VORGEW[HLTE EINSTELLUNG",0
	.EVEN

	.ELSE
MEN_UTIL
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESS_UTIL	;TITLE
	.WORD	COLOR_WHITE	;COLOR OF TITLE
	.WORD	UM_X		;UL X
	.WORD	MENU_Y-5	;UL Y
	.WORD	20		;VERTICAL SPACING
	.WORD	COLOR_WHITE	;COLOR WHEN NOT SELECTED
	.WORD	19		;HEIGHT OF SELECTION BAR
	.WORD	-5		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	UM_WID		;WIDTH OF BAR!
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
****	.LONG	MESS_OPMESS,DO_OPMESS,OPMESS_HELP
	.LONG	MESS_CLCRED,DO_CLCRED,CLCRED_HELP
	.LONG	MESS_CLCOIN,DO_CLCOIN,CLCOIN_HELP
	.LONG	MESS_CLAUD,DO_CLAUD,CLAUD_HELP
	.LONG	MESS_HSRES,DO_HSRES,HSRES_HELP
	.LONG	MESS_DEF_ADJ,DO_DEF_ADJ,DEF_ADJ_HELP
	.LONG	MESS_FACSET,DO_FACSET,FACSET_HELP
	.LONG	MESS_MM,0,BLNK_HELP		;RETURN TO MAIN MENU
	.LONG	0		;END

MESS_CLCRED
U_CLR_CRED
	.STRING W_CLEAR," ",W_CREDITS,0
	.EVEN
MESS_CCCONF
	.STRING W_CREDITS," ",W_CLEAR,"ED",0
	.EVEN
MESS_CLCOIN
U_CLR_COIN
	.STRING W_CLEAR," ",W_COINCOUNTS,0
	.EVEN
MESS_CLAUD
U_CLR_AUD
	.STRING W_CLEAR," ",W_GAME," ",W_AUDITS,0
	.EVEN
MESS_HSRES
	.STRING "RESET ",W_HIGH," ",W_SCORE,"S",0
	.EVEN
MESS_FACSET
	.STRING "FULL FACTORY RESTORE",0
	.EVEN
MESS_FACFAIL
	.STRING  "FAILURE IN CMOS RAM",0
	.EVEN
MESS_CANCELLED
	.STRING "CANCELLED",0
	.EVEN
MESS_DEF_ADJ
	.STRING "DEFAULT ",W_ADJUSTMENTS,0
	.EVEN

	.ENDIF

*
*        HELP FOR UTILITY MENU
*
CLCRED_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	3		;2 ENTRIES
	.LONG	MEH_CLCRED1
	.LONG	MEH_CLCRED2
	.LONG	MEH_CLCRED3

CLCOIN_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	4		;2 ENTRIES
	.LONG	MEH_CLCOIN1
	.LONG	MEH_CLCOIN2
	.LONG	MEH_CLCOIN3
	.LONG	MEH_CLCOIN4

CLAUD_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	2		;2 ENTRIES
	.LONG	MEH_CLAUD1
	.LONG	MEH_CLAUD2

HSRES_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	3		;2 ENTRIES
	.LONG	MEH_RESHS1
	.LONG	MEH_RESHS2
	.LONG	MEH_RESHS3

OPMESS_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	4		;2 ENTRIES
	.LONG	MEH_CUSM1
	.LONG	MEH_CUSM2
	.LONG	MEH_CUSM3
	.LONG	MEH_CUSM4

DEF_ADJ_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	4		;2 ENTRIES
	.LONG	MEH_DEFA1
	.LONG	MEH_DEFA2
	.LONG	MEH_DEFA3
	.LONG	MEH_DEFA4

FACSET_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	3		;2 ENTRIES
	.LONG	MEH_FAC1
	.LONG	MEH_FAC2
	.LONG	MEH_FAC3

**************************************************************************
*                                                                        *
*          STRINGS FOR UTILITY HELP MENUS                                *
*                                                                        *
**************************************************************************
MEH_CLCRED1
	.STRING "REMOVE ANY",0
	.EVEN
MEH_CLCRED2
	.STRING "POSTED ",W_CREDITS,0
	.EVEN
MEH_CLCRED3
	.STRING "FROM THE ",W_GAME,0
	.EVEN
MEH_CLCOIN1
	.STRING W_CLEAR," OUT PAID",0
	.EVEN
MEH_CLCOIN2
	.STRING W_CREDITS," ",W_TOTAL,0
	.EVEN
MEH_CLCOIN3
	.STRING "AND THE ",W_COIN,0
	.EVEN
MEH_CLCOIN4
	.STRING W_SLOT," COUNTERS",0
	.EVEN
MEH_CLAUD1
	.STRING W_CLEAR," ",W_GAME,W_PLAY,0
	.EVEN
MEH_CLAUD2
	.STRING "STATISTICS",0
	.EVEN
MEH_RESHS1
	.STRING "RESET ",W_HIGH," ",W_SCORE,0
	.EVEN
MEH_RESHS2
	.STRING "TABLE TO FACTORY",0
	.EVEN
MEH_RESHS3
	.STRING "DEFAULT VALUES",0
	.EVEN
MEH_CUSM1
	.STRING "ENTER YOUR OWN",0
	.EVEN
MEH_CUSM2
	.STRING W_MESSAGE," TO",0
	.EVEN
MEH_CUSM3
	.STRING "APPEAR IN THE",0
	.EVEN
MEH_CUSM4
	.STRING "ATTRACT MODE",0
	.EVEN
MEH_DEFA1
	.STRING "SET ALL ",W_GAME,0
	.EVEN
MEH_DEFA2
	.STRING W_ADJUSTMENTS," TO",0
	.EVEN
MEH_DEFA3
	.STRING "THEIR FACTORY",0
	.EVEN
MEH_DEFA4
	.STRING "DEFAULT VALUE",0
	.EVEN
MEH_FAC1
	.STRING "RESET ALL ",W_AUDITS,",",0
	.EVEN
MEH_FAC2
	.STRING "COUNTERS, ",W_ADJUSTMENTS,0
	.EVEN
MEH_FAC3
	.STRING "AND THE ",W_HIGH," ",W_SCORE,"S.",0
	.EVEN

**************************************************************************
*								         *
* 	PRESS ANY BUTTON TO CONTINUE					 *
*								         *
**************************************************************************
ANY_MENU
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	0		;TITLE
	.WORD	0		;COLOR OF TITLE
	.WORD	200		;UL X
	.WORD	195		;UL Y
	.WORD	MENU_DY		;VERTICAL SPACING
	.WORD	COLOR_BLUE	;COLOR WHEN NOT SELECTED
	.WORD	BAR_HITE	;HEIGHT OF SELECTION BAR
	.WORD	BAR_DY		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	234		;WIDTH OF BAR!
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_ANY,0,NO_HELP
	.LONG	0

	 .IF GERMAN

MESS_ANY
	.STRING	"WEITER MIT BELIEBIGEM KNOPF",0
	.EVEN

MESS_FFSCONF
MESS_FAC
	MESS_MAC  RD7FONT,SPACING07,200,96,COLOR_PWHITE,STRCNRM,0
MESS_DEFCONF
	.STRING	"VORGEW",C_GERA,"HLTE EINSTELLUNG.",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,200,112,COLOR_PYELLOW,STRCNRM,0
	.EVEN
MESS_CCNCONF
	.STRING	"M",C_GERU,"NZZ",C_GERA,"HLER-L",C_GERO,"SCHUNG.",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,200,128,COLOR_PBLUE,STRCNRM,0
MESS_CAUDCONF
	.STRING	"AUSLESEDATEN L",C_GERO,"SCHEN.",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,200,144,COLOR_PRED,STRCNRM,0
MESS_HSRCONF
	.STRING  "HIGHSCORE L",C_GERO,"SCHEN.",0
	.EVEN
	.WORD	0

	.ELSE

MESS_ANY
	.STRING	"ANY ",W_BUTTON," TO ",W_CONTINUE,0
	.EVEN

MESS_FFSCONF
MESS_FAC
	MESS_MAC  RD7FONT,SPACING07,200,96,COLOR_PWHITE,STRCNRM,0
MESS_DEFCONF
	.STRING	"DEFAULT ",W_ADJUSTMENTS," RESTORED.",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,200,112,COLOR_PYELLOW,STRCNRM,0
	.EVEN
MESS_CCNCONF
	.STRING	W_COINCOUNTS," ",W_CLEAR,"ED.",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,200,128,COLOR_PBLUE,STRCNRM,0
MESS_CAUDCONF
	.STRING	W_GAME," ",W_AUDITS," ",W_CLEAR,"ED.",0
	.EVEN
	.WORD	1
	MESS_MAC RD7FONT,SPACING07,200,144,COLOR_PRED,STRCNRM,0
MESS_HSRCONF
	.STRING  W_HIGH," ",W_SCORE," TABLE RESET.",0
	.EVEN
	.WORD	0

	.ENDIF

*
*        MONITOR PATTERNS
*

MEN_PATTERNS
         .LONG   RD7FONT        ;FONT
         .LONG   STRCNRM         ;CENTER PLEASE
         .LONG   MESS_PATTERNS         ;TITLE
         .WORD	COLOR_RED    ;COLOR OF TITLE
         .WORD   200             ;UL X      (CENTER IT!)
         .WORD   MENU_Y-3        ;UL Y
         .WORD   20              ;VERTICAL SPACING
         .WORD	COLOR_YELLOW    ;COLOR WHEN NOT SELECTED
         .WORD   20              ;HEIGHT OF SELECTION BAR
         .WORD   -6             ;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
         .WORD   BAR_DX          ;EXTRA X ON EACH SIDE.
         .WORD   234             ;WIDTH OF BAR!
         .WORD	COLOR_DECAY      ;TEXT COLOR OF SELECTED ITEM
         .LONG   MESS_RED,GO_RED,BLNK_HELP
         .LONG   MESS_GREEN,GO_GREEN,BLNK_HELP
         .LONG   MESS_BLUE,GO_BLUE,BLNK_HELP
         .LONG   MESS_BARS,GO_BARS,BLNK_HELP
         .LONG   MESS_CROSS,GO_CONV,BLNK_HELP
         .LONG   MESS_DIAGM,0,BLNK_HELP
         .LONG   MESS_MM,FORCE_MAIN,NO_HELP        ;RETURN TO MAIN MENU
         .LONG   0

	.IF GERMAN

MESS_RED
	.STRING "ROT",0
	.EVEN
MESS_GREEN
	.STRING "GR",C_GERU,"N",0
	.EVEN
MESS_BLUE
	.STRING "BLAU",0
	.EVEN
MESS_BARS
	.STRING "FARBBALKEN",0
	.EVEN
MESS_CROSS
	.STRING "GITTERMUSTER",0
	.EVEN
MESS_DIAGM
	.STRING "ZUR",C_GERU,"CK ZUM DIAGNOSE-MEN",C_GERU,0
	.EVEN

	.ELSE

MESS_RED
	.STRING "RED ",W_SCREEN,0
	.EVEN
MESS_GREEN
	.STRING "GREEN ",W_SCREEN,0
	.EVEN
MESS_BLUE
	.STRING "BLUE ",W_SCREEN,0
	.EVEN
MESS_BARS
	.STRING "COLOR BARS",0
	.EVEN
MESS_CROSS
	.STRING "CROSSHATCH  PATTERN",0
	.EVEN
MESS_DIAGM
	.STRING "BACK TO DIAGNOSTICS MENU",0
	.EVEN

	.ENDIF


NULL_ST
	.BYTE	0
	.EVEN

