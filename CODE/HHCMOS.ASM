   	.MLIB	"HHMACS.LIB"
	.FILE	"HHCMOS.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

**************************************************************************
*								         *
* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		 *
* 		       ALL RIGHTS RESERVED.				 *
*								         *
**************************************************************************

	.INCLUDE	"HH.INC"		;SYSTEM STUFF
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhcmos.e"
	.include	"hhutil.g"
	.include	"hhmenu.g"
	.include	"hhtext.g"
	.include	"hhproc.g"
	.include	"hhsnd.g"
	.include	"hhcoin.g"
	.include	"hhram.g"

; end of include files


*
*        BAD_AUD - ANYTIME AN AUDIT NUMBER IS FETCHED, IF ITS
*                  CHECKSUM IS BAD, THEN BAD_AUD GETS SET TO 1
*                  THIS CAUSES "ERROR" IF ANY AUDIT IN A CALCULATION
*                  IS CORRUPTED, AND KEEPS A BAD CHECKSUM BAD WHEN
*                  AN AUDIT IS CHANGED.

        .BSS    BAD_AUD,16   ;(BAD_AUD...NOT BAD_DOG!)
	.bss	xxxx,16		;fill space to 32 bits
        .TEXT

**************************************************************************
*                                                                        *
*          CMOS UTILITIES                                                *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
*          FOR ALL OF THESE CMOS ROUTINES.                               *
*                                                                        *
*                  A7 = POINTER TO MEMORY                                *
*                  A0 = DATA TO/FROM MEMORY                              *
*                                                                        *
**************************************************************************
*
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*
*        NOTE THAT REQUESTS FOR WORDS RETURN THE 2 BYTES PACKED
*        INTO A WORD AS <1ST BYTE><2ND BYTE>.   THIS IS NOT
*        THE SAME WAY THAT THE GSP HANDLES A WORD POINTED AT
*        WITH A POINTER.
*
*        LONG WORDS WORK SIMILARLY:
*
*           MSB                                              LSB
*               <1ST BYTE> <2ND BYTE> <3RD BYTE> <4TH BYTE>
*
*        TOUGH LUCK INTEL HACKERS!
*
*
*        RC_BYTE
*        WC_BYTE
*
*        These 2 routines are the only routines that ever touch
*        CMOS ram.  This is done to localize the effect of
*        changes in the architecture.  All efforts to deal with
*        CMOS should come through these routines.  Locking
*        hardware will be easily added in the future (as well
*        as different memory mapping).
*
RC_BYTE
	MOVB	*A7,A0
	ANDI	BYTE_MASK,A0
	RETS

WC_BYTE
	.if	XUNIT=0

;	ori	080000h,a7
;	movb	a0,*a7
;	xori	080000h,a7

	MOVB	A0,@01480000H

	.endif

	MOVB	A0,*A7		;WRITE OUT THE BYTE
	RETS			;AND RETURN

**************************************************************************
*								         *
* 	RC_BYTEI							 *
* 									 *
* 	READ BYTE POINTED TO BY A7...INCREMENT POINTER TO		 *
* 	"NEXT" BYTE.							 *
*								         *
**************************************************************************
RC_BYTEI
	CALLR	RC_BYTE
	ADDI	C_BYTE_SIZE,A7	;WORDS SEPARATE CMOS BYTES.
	MOVE	A0,A0		;RETURN FLAGS ACCORDINGLY
	RETS

RC_WORD
	MMTM	SP,A1,A7	;USE A1 TO COMBINE BYTES
	CALLR	RC_BYTEI	;GET A BYTE
	MOVE	A0,A1		;SAVE IN A1
	ANDI	BYTE_MASK,A1	;MASK ONLY BYTE
	SLL	8,A1		;SHIFT TO HIGH BYTE
	CALLR	RC_BYTE		;GET THE 2ND BYTE
	ANDI	BYTE_MASK,A0
	OR	A1,A0		;A0 HAS THE WORD
	MMFM	SP,A1,A7
	RETS

RC_WORDI
	CALLR	RC_WORD
	ADDI	C_WORD_SIZE,A7	;LONG SEPARATE CMOS WORDS.
	MOVE	A0,A0		;RETURN FLAGS ACCORDINGLY
	RETS

RC_LONG
	MMTM	SP,A1,A7	;USE A1 TO COMBINE BYTES
	CALLR	RC_WORDI	;GET A WORD
	MOVE	A0,A1		;SAVE IN A1
	ANDI	WORD_MASK,A1	;MASK ONLY WORD
	SLL	16,A1		;SHIFT TO HIGH WORD
	CALLR	RC_WORD		;GET THE 2ND WORD
	ANDI	WORD_MASK,A0
	OR	A1,A0		;A0 HAS THE LONG WORD
	MMFM	SP,A1,A7
	RETS

RC_LONGI
	CALLR	RC_LONG
	ADDI	C_LONG_SIZE,A7	;DOUBLE THE DISTANCE FOR BRAIN DAMIJ
	MOVE	A0,A0		;RETURN FLAGS ACCORDINGLY
	RETS

WC_BYTEI
	CALLR	WC_BYTE
	ADDI	C_BYTE_SIZE,A7
	RETS

WC_WORD
	MMTM	SP,A0,A1,A7
	MOVE	A0,A1		;MAKE COPY OF WORD
	SRL	8,A0		;GET HIGH BYTE IN A0
	CALLR	WC_BYTEI	;WRITE THE HIGH BYTE
	MOVE	A1,A0		;NOW GET THE LOW BYTE BACK
	CALLR	WC_BYTE		;WRITE IT
	MMFM	SP,A0,A1,A7	;AND RESTORE ALL WE TOUCHED
	RETS

WC_WORDI
	CALLR	WC_WORD
	ADDI	C_WORD_SIZE,A7
	RETS

WC_LONG
	MMTM	SP,A0,A1,A7
	MOVE	A0,A1		;MAKE COPY OF LONG
	SRL	16,A0		;GET HIGH WORD IN A0
	CALLR	WC_WORDI	;WRITE THE HIGH WORD
	MOVE	A1,A0		;NOW GET THE LOW WORD BACK
	CALLR	WC_WORD		;WRITE IT
	MMFM	SP,A0,A1,A7	;AND RESTORE ALL WE TOUCHED
	RETS

WC_LONGI
	CALLR	WC_LONG
	ADDI	C_LONG_SIZE,A7
	RETS

**************************************************************************
*                                                                        *
*         AUDIT HANDLING                                                 *
*                                                                        *
**************************************************************************
*                                                                        *
*          POINT_AT_AUDIT                                                *
*                                                                        *
*          THIS IS CALLED TO POINT AT THE AUDIT INDICATED BY             *
*          A0.  A0 IS THE AUDIT NUMBER 0-30.  A7 IS RETURNED             *
*          POINTING AT THE BEGINNING OF THE AUDIT.                       *
*                                                                        *
**************************************************************************
POINT_AT_AUDIT
	MMTM	SP,A1
	MOVI	AUD_SIZE,A7		;THIS IS SIZE PER AUDIT
	MPYU	A0,A7			;A1 NOW HAS OFFSET
	ADDI	AUDITORG,A7		;ADD BASE
	MMFM	SP,A1
	RETS

**************************************************************************
*                                                                        *
*          FORM_AUD_CKSUM                                                *
*                                                                        *
*          THIS IS CALLED TO FORM THE CHECKSUM FOR THE AUDIT             *
*          SPECIFIED IN A0.                                              *
*                                                                        *
*          A1 RETURNS THE CHECKSUM.                                      *
*                                                                        *
*          Z BIT IS SET BASED ON WHETHER IT MATCHES THE CHECKSUM THERE.  *
*                                                                        *
**************************************************************************
FORM_AUD_CKSUM
	MMTM	SP,A0,A4,A7
	CALLR	POINT_AT_AUDIT		;A7 = POINTER TO CURRENT ENTRY
	MMTM	SP,A7			;SAVE POINTER TO ENTRY
	MOVI	AUD_BYTES_TO_CHECK,A4	;COUNT DOWN THE BYTES
	CLR	A1			;KEEP SUM IN A1
ADD_A_BYTE
	CALLA	RC_BYTEI		;GET A BYTE INTO A0
	ADD	A0,A1			;ADD TO SUM
	DSJ	A4,ADD_A_BYTE		;ONE MORE ADDED
	NOT	A1			;CHECKSUM IS NOW IN LOW WORD
	ANDI	WORD_MASK,A1		;MASK SO ITS COOL
	MMFM	SP,A7			;GET POINTER BACK
	ADDI	AUD_CKSUM,A7		;POINT AT CHECKBYTE
	CALLA	RC_WORD			;READ IN THE CKSUM
	CMP	A0,A1			;COMPARE WHAT'S THERE TO WHAT WE GOT
	MMFM	SP,A0,A4,A7		;Z BIT RETURNS COMPARE
	RETS				;A1 RETURNS CKSUM

**************************************************************************
*                                                                        *
*          STORE_AUD_CKSUM                                               *
*                                                                        *
*          THIS WILL STORE THE AUDIT CHECKSUM IN A1 FOR THE              *
*          AUDIT NUMBER SPECIFIED BY A0.                                 *
*                                                                        *
**************************************************************************
STORE_AUD_CKSUM
	MMTM	SP,A7,A0		;POINTING REGISTER
	CALLR	POINT_AT_AUDIT		;A7 POINTS AT AUDIT
	ADDI	AUD_CKSUM,A7		;POINT AT CHECKBYTE
	MOVE	A1,A0			;GET CHECKBYTE IN A0
	CALLA	WC_WORD			;WRITE THE CKSUM
	MMFM	SP,A7,A0		;POINTING REGISTER
	RETS

**************************************************************************
*                                                                        *
*          FORM_AUD_CKSUM_AND_STORE                                      *
*                                                                        *
*          THE VALUE AT BAD_AUD IS USED TO DETERMINE WHETHER TO STORE    *
*          THE CORRECT OR INCORRECT VALUE!                               *
*                                                                        *
*          A0 = AUDIT NUMBER                                             *
*                                                                        *
**************************************************************************
FORM_AUD_CKSUM_AND_STORE
	MMTM	SP,A1,A2
	CALLR	FORM_AUD_CKSUM
	MOVE	@BAD_AUD,A2,W		;GET THE "FUDGE" WORD
	XOR	A2,A1			;MAKE CKSUM BAD IF AUDIT IS BAD
	CALLR	STORE_AUD_CKSUM
	MMFM	SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
*          GET_AUD                                                       *
*                                                                        *
*          THIS IS CALLED TO FETCH THE AUDIT VALUE FOR THE AUDIT         *
*          SPECIFIED IN A0 INTO A1.  IF THE CHECKBYTE FOR THE            *
*          AUDIT IS INCORRECT, THEN RAM LOCATION BAD_AUD WILL BE         *
*          SET TO 1.                                                     *
*                                                                        *
**************************************************************************
GET_AUD
	MMTM	SP,A7,A0
	CALLR	FORM_AUD_CKSUM		;SEE IF CKSUM IS OK
	JRZ	FETCH_AUDIT_1		;ITS OK....
*
*	CHECKSUM IS BAD....SET GLOBAL
*
	MOVK	1,A1
	MOVE	A1,@BAD_AUD,W		;SET THE FLAG!

FETCH_AUDIT_1
	CALLR	POINT_AT_AUDIT		;A7 POINTS AT AUDIT
	ADDI	AUD_DATA,A7		;ADD ZERO OFFSET
	CALLA	RC_LONG			;FETCH THE LONG WORD TO A0
	MOVE	A0,A1			;RETURN IN A1
	MMFM	SP,A7,A0
	RETS

**************************************************************************
*                                                                        *
*          STORE_AUDIT                                                   *
*                                                                        *
*          A0 = AUDIT NUMBER TO STORE VALUE FOR                          *
*          A1 = VALUE TO STORE.                                          *
*          BAD_AUD = NON ZERO IF BAD CHECKSUM IS TO BE MAINTAINED.       *
*                                                                        *
**************************************************************************
STORE_AUDIT
	MMTM	SP,A0,A7
	callr  CMOSUNLOCK
	CALLR	POINT_AT_AUDIT		;A7 POINTS AT AUDIT
	ADDI	AUD_DATA,A7		;ADD ZERO OFFSET
	MOVE	A1,A0			;MOVE DATA TO WRITING REGISTER
	CALLA	WC_LONG			;WRITE THE DATA BACK
	MMFM	SP,A0,A7		;GET AUDIT NUMBER BACK
	CALLR	FORM_AUD_CKSUM_AND_STORE ;STORE GOOD OR BAD CKSUM BASED
*					 ;ON BAD_AUD
	jruc	CMOSLOCK
**************************************************************************
*                                                                        *
*          CLR_SUBS                                                      *
*                                                                        *
*          THIS IS CALLED TO CLEAR OUT THE COINAGE SUB-TOTALS.           *
*                                                                        *
**************************************************************************
CLR_SUBS
	RETP
*	MOVI	FRST_SUB,A0
*	MOVI	LAST_SUB,A1
*	CALLR	CLR_AUDR		;CLEAR EM OUT!
*	RETP

**************************************************************************
*								         *
*          CLR_AUDR							 *
* 									 *
*          THIS IS CALLED TO CLEAR OUT A RANGE OF AUDITS.		 *
*          A0 = 1ST AUDIT NUMBER					 *
*          A1 = LAST AUDIT NUMBER (INCLUSIVE)				 *
*								         *
**************************************************************************
CLR_AUDR
	MMTM	SP,A0,A1,A2
	MOVE	A1,A2			;MOVE "LAST" TO A2
	CLR	A1			;WE'LL STORE ZEROS
	MOVE	A1,@BAD_AUD		;MAKE CKSUMS GOOD ON STORING
CAR1	CALLR	STORE_AUDIT		;STORE THIS AUDIT
	INC	A0			;KICK TO NEXT AUDIT
	CMP	A2,A0
	JRLS	CAR1
	MMFM	SP,A0,A1,A2
	RETS

**************************************************************************
*                                                                        *
* 	KILL_AUD							 *
* 									 *
* 	This is called to clear out an audit.				 *
* 									 *
* 	A0 = audit number.						 *
*                                                                        *
**************************************************************************
KILL_AUD
	MMTM	SP,A1
	CLR	A1			;WE'LL STORE ZEROS
	MOVE	A1,@BAD_AUD		;MAKE CKSUMS GOOD ON STORING
	CALLR	STORE_AUDIT		;STORE THIS AUDIT
	MMFM	SP,A1
	RETS

**************************************************************************
*                                                                        *
*          AUD                                                           *
*                                                                        *
*          A0 = AUDIT NUMBER.......A1 = COUNT TO ADD.                    *
*                                                                        *
**************************************************************************
AUD	MMTM	SP,A1,A2
	CLR	A2		;SET "BAD_AUD" GOOD UNTIL OTHERWISE PROVEN!
	MOVE	A2,@BAD_AUD,W	;ITS GOOD.
	MOVE	A1,A2		;COPY OUR COUNT
	CALLR	GET_AUD		;FETCH THE CURRENT AUDIT COUNTER
	ADD	A2,A1		;ADD THE NEW COUNT
	CALLR	STORE_AUDIT	;STORE IT BACK
	MMFM	SP,A1,A2
	RETS

AUD1	MMTM	SP,A1
	MOVK	1,A1
	CALLR	AUD
	MMFM	SP,A1
	RETS

**************************************************************************
*                                                                        *
*          CLR_AUD                                                       *
*                                                                        *
*          This is called to clear out all of the audits.                *
*                                                                        *
*          A relatively easy task given the primitives available.        *
*                                                                        *
**************************************************************************
CLR_AUD
	MMTM	SP,A0,A1
	MOVI	1,A0			;START AT AUDIT 1
	MOVI	LAST_AUDIT,A1		;THIS IS TOTAL ALLOCATED
	CALLR	CLR_AUDR
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
*          ADJUSTMENTS                                                   *
*                                                                        *
**************************************************************************

**************************************************************************
*								         *
* 	CMOS_VAL							 *
* 									 *
* 	VALIDATE THE CMOS VALUES					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		.EQ.	COOL						 *
* 		.NE.	IT IS HOSED					 *
*								         *
**************************************************************************
CMOS_VAL
	CALLR	FORM_ADC		;SEE IF CKSUM IS OK.
	JRNZ	CMOS_BAD		;NOPE....RETURN .NE.
	CALLR	CHECK_NAME_AND_REV	;HOW ABOUT THE NAME AND REV?
CMOS_BAD
	RETS

**************************************************************************
*								         *
* 	FORM_ADC							 *
* 									 *
* 	DO A CHECKSUM OF THE ADJUSTMENTS AREA -- RETURNED IN A1		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A1	CHECKSUM VALUE					 *
* 		.EQ.	AGREES WITH STORED CHECKSUM			 *
* 		.NE.	IT DON'T					 *
*								         *
**************************************************************************
FORM_ADC:
	MMTM	SP,A7,A0,A6
	MOVI	ADJUSTORG,A7		;POINT AT FIRST BYTE
	MOVI	ADJ_BYTES_TO_CHECK,A6	;NUMBER OF BYTES
	CLR	A1			;ACCUMULATE CKSUM HERE
ADJ_C1	CALLA	RC_BYTEI		;READ A BYTE
	ADD	A0,A1			;ADD THE BYTE TO THE SUM
	DSJS	A6,ADJ_C1
	NOT	A1			;COMPLEMENT THE SUM
	ANDI	WORD_MASK,A1		;KEEP A WORD.
	MOVI	ADJ_CKSUM,A7
	CALLA	RC_WORD			;FETCH THE CHECKSUM
	CMP	A0,A1			;COMPARE TO FETCHED VALUE
	MMFM	SP,A7,A0,A6
	RETS

**************************************************************************
*								         *
* 	F_ADC_S								 *
* 									 *
* 	FORM AN ADJUSTMENT CHECKSUM AND STORE THE VALUE			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
F_ADC_S:
	MMTM	SP,A0,A1,A7
	CALLR	CMOSUNLOCK
	CALLR	FORM_ADC		;FORM THE CKSUM
	MOVE	A1,A0			;PUT IN CMOS WRITING REGGIE
	MOVI	ADJ_CKSUM,A7
	CALLA	WC_WORD			;AND STORE IT
	CALLR	CMOSLOCK
	MMFM	SP,A0,A1,A7
	RETS

**************************************************************************
*								         *
* 	GET_ADJ								 *
* 									 *
* 	GETS AN ADJUSTMENT VALUE					 *
* 									 *
* 	ENTRY								 *
* 		A0	ADJUSTMENT NUMBER TO GET			 *
* 									 *
* 	EXIT								 *
* 		A0	VALUE OF ADJUSTMENT				 *
*								         *
**************************************************************************
GET_ADJ:
	MMTM	SP,A1,A7
	.IF	FORCEFREE
	CMPI	ADJFREPL,A0
	JRNZ	GANOTFREE
	MOVK	1,A0
	JRUC	GADONE
GANOTFREE
	.ENDIF
	PUSH	A0
	CALLR	FORM_ADC		;CHECKSUM THINGS
	PULL	A0
	JRZ	GACOOL			;BR = CMOS IS COOL
	SLL	5,A0
	ADDI	FACTORY_TABLE,A0
	MOVE	*A0,A0,L		;READ UP THE FACTORY ADJUSTMENT
	JRUC	GADONE
GACOOL	CALLR	ADJPOINT		;POINT AT ADJUSTMENT
	CALLA	RC_LONG			;FETCH THE ADJUST PLEASE
GADONE	MOVE	A0,A0			;RETURN Z BIT BASED ON ADJUSTMENT!
	MMFM	SP,A1,A7
	RETS

**************************************************************************
*								         *
* 	PUT_ADJ								 *
* 									 *
* 	STORE AN ADJUSTMENT VALUE.  NOTE!  DOES NOT RECHECKSUM!!	 *
* 									 *
* 	ENTRY								 *
* 		A0	ADJUSTMENT NUMBER				 *
* 		A1	ADJUSTMENT VALUE				 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
PUT_ADJ:
	MMTM	SP,A7,A0
	CALLR	CMOSUNLOCK
	CALLR	ADJPOINT		;POINT AT REQUESTED ADJ.
	MOVE	A1,A0			;GET VALUE IN WRITING REGGIE!
	CALLA	WC_LONG			;WRITE THE ADJUSTMENT
	CALLR	CMOSLOCK
	MMFM	SP,A7,A0
	RETS

**************************************************************************
*								         *
* 	ADJPOINT							 *
* 									 *
* 	POINT A7 AT THE CMOS MEMLOC FOR THE ADJUSTMENT			 *
* 									 *
* 	ENTRY								 *
* 		A0	ADJUSTMENT NUMBER				 *
* 									 *
* 	EXIT								 *
* 		A7	POINTER TO CMOS MEMORY				 *
*								         *
**************************************************************************
ADJPOINT:
	MOVI	ADJ_SIZE,A7		;SIZE PER ADJUSTMENT IN A7
	MPYU	A0,A7			;TIMES ADJUSTMENT REQUESTED.
	ADDI	ADJUSTORG,A7		;ADD TO BASE
	RETS

**************************************************************************
*								         *
* 	CHECK_NAME_AND_REV						 *
* 									 *
* 	CHECK THE NAME AND THE REVISION AGAINST THE CMOS		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		.EQ.	COOL						 *
* 		.NE.	NOT COOL					 *
*								         *
**************************************************************************
CHECK_NAME_AND_REV:
	MMTM	SP,A0,A1,A2,A3,A7
	MOVI	NAME_REV,A7		;POINT AT CMOS NAME STORAGE
	MOVI	ROM_NAME,A1		;POINT AT OUR VERSION
	MOVI	NAME_REV_SIZE,A2	;MAXIMUM NAME SIZE

NEXT_LET1
	CALLA	RC_BYTEI		;FETCH A BYTE
	MOVB	*A1,A3			;GET 1 FROM ROM
	ANDI	BYTE_MASK,A3		;MASK ANY SIGN EXTENDS

	CMP	A3,A0			;THEY BETTER BE THE SAME
	JRNZ	RETURN_NOW		;NOPE....BYE  (RETURN .NE.)

	ADDI	BYTE_SIZE,A1		;KICK SOURCE POINTER
	MOVE	A0,A0			;WAS IT A ZERO?
	JRZ	RETURN_NOW		;YEP....NO MORE (RETURN .EQ.)
	DSJS	A2,NEXT_LET1
	CLR	A0			;RETURN .EQ.

RETURN_NOW
	MMFM	SP,A0,A1,A2,A3,A7
	RETS

**************************************************************************
*								         *
* 	FAC_SET								 *
* 									 *
* 	RESTORE THE FACTORY SETTINGS TO THE ADJUSTMENT CMOS		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
FAC_SET:
	MMTM	SP,A0,A1,A2,A7
	CALLR	DUMP_FS
	CALLA	NO_CREDS		;REMOVE ANY COINS
	CALLR	CMOSUNLOCK

	MOVI	FACTORY_TABLE,A1	;ROM
	MOVI	ADJUSTORG,A7		;CMOS
	MOVI	N_ADJUSTS,A2		;NUMBER OF ADJUSTMENTS ALLOCATED
FACS1
	MOVE	*A1+,A0,L		;FETCH A ROM LONG WORD
	CALLA	WC_LONGI		;WRITE THE WORD TO CMOS
	DSJS	A2,FACS1		;WRITE 1 LONG WORD PER ADJUST

;	CALLR	SWITCH_FOR_JUMPER	;CHANGE COINAGE BASED ON JUMPER.
;	CALLR	LD_CTAB			;EXPAND THE CSELCT VALUE

	CALLR	CMOSLOCK

	CALLR	F_ADC_S			;MAKE THE CHECKSUM CORRECT.

	CALLR	CMOSUNLOCK
*
*	NOW STORE THE GAME NAME AND REVISION INFO
*
	MOVI	NAME_REV,A7		;POINT AT CMOS NAME STORAGE
	MOVI	ROM_NAME,A1		;POINT AT OUR VERSION
	MOVI	NAME_REV_SIZE,A2	;MAXIMUM NAME SIZE

NEXT_LETTER
	MOVB	*A1,A0			;FETCH A BYTE
	CALLA	WC_BYTEI		;WRITE IT TO CMOS
	ADDI	BYTE_SIZE,A1		;KICK SOURCE POINTER
	MOVE	A0,A0			;WAS IT A ZERO?
	JRZ	NAME_DONE		;YEP....NO MORE!
	DSJS	A2,NEXT_LETTER

NAME_DONE
	CALLR	CMOSLOCK
	MMFM	SP,A0,A1,A2,A7
	RETS

**************************************************************************
*                                                                        *
*          CMOSUNLOCK and CMOSLOCK                                       *
*                                                                        *
*          THIS SETS (CLRS) THE WRITE CMOS ENABLE BIT IN SYSCTRL0        *
*                                                                        *
**************************************************************************
CMOSUNLOCK:
	.if	XUNIT=1
	MOVE	@SYSCOPY,a14,L
	ori	CMOSENAB,a14
	move	a14,@SYSCOPY,L
	move	a14,@SYSCTRL0
	.endif
	rets

CMOSLOCK:
	.if	XUNIT=1
	MOVE	@SYSCOPY,a14,L
	andni	CMOSENAB,a14
	move	a14,@SYSCOPY,L
	move	a14,@SYSCTRL0
	.endif
	rets


**************************************************************************
*                                                                        *
*          DUMPING SOFTWARE                                              *
*                                                                        *
**************************************************************************
DUMP_FS
	callr	CMOSUNLOCK
	CLR	A0
	MOVI	DUMP_PTR,A7
	CALLA	WC_WORD		;SET NUMBER OF DUMPS TO ZERO
	callr	CMOSLOCK
	RETS

**************************************************************************
*								         *
* 	CLR_DUMP_AUD							 *
* 									 *
* 	This is called if both BOMB buttons pressed while looking	 *
* 	at dump page.   It clears out the audits associated		 *
* 	with that page.							 *
*								         *
**************************************************************************
CLR_DUMP_AUD
	MOVI	AUD_DOG,A0
	CALLR	KILL_AUD
	MOVI	AUD_WARNING,A0
	CALLR	KILL_AUD
	MOVI	AUD_BADTRAP,A0
	CALLR	KILL_AUD
	RETS

**************************************************************************
*								         *
*          ADD_DUMP							 *
* 									 *
*          THIS IS CALLED TO RECORD A DUMP.  A0 THROUGH A8 ARE		 *
*          RECORDED IN CMOS MEMORY.					 *
*								         *
**************************************************************************
	.BSS	DUMP_ARRAY,9*32	;DUMP PRINT ARRAY

DUMP_SIZE	.EQU	9*C_LONG_SIZE	;9 LONG WORDS.
DUMP_LAST	.EQU	DUMP_END-DUMP_SIZE ;ALLOW EM TO USE THE WHOLE PAGE!
TOTAL_DUMPS	.EQU	(DUMP_END-DUMP_ORG)/DUMP_SIZE	;THIS MANY DUMPS ALLOWED
DUMPS_PP	.EQU	9		;MAX DUMPS PER PAGE

ADD_DUMP
	MMTM	SP,B0,B1,B2
	MMTM	SP,A0,A1,A7
	callr	CMOSUNLOCK
	MOVE	A0,B0
	MOVE	A7,B2			;SAVE THESE!
	MOVE	A1,B1

	MOVI	DUMP_PTR,A7
	CALLA	RC_WORD			;GET THE INDICATOR OF HOW MANY.
	MOVI	DUMP_SIZE,A1
	MPYU	A0,A1			;THIS IS OFFSET INTO CMOS FOR THIS ENTRY!

	ADDI	DUMP_DATA,A1		;NOW A1 POINTS WHERE WE'RE PUTTING THE DATA!
	CMPI	DUMP_LAST,A1		;ARE WE TOO FAR FOR ANOTHER?
	JRHS	NO_DUMP			;YEP....SKIP IT

	INC	A0			;1 MORE OUT THERE!
	CALLA	WC_WORD			;CHALK IT!

	MOVE	A1,A7			;THIS IS POINTER TO STORE DATA.
	MOVE	B0,A0			;THIS IS A0
	CALLA	WC_LONGI
	MOVE	B1,A0			;THIS IS A1
	CALLA	WC_LONGI
	MOVE	A2,A0			;THIS IS A2
	CALLA	WC_LONGI
	MOVE	A3,A0			;THIS IS A3
	CALLA	WC_LONGI
	MOVE	A4,A0			;THIS IS A4
	CALLA	WC_LONGI
	MOVE	A5,A0			;THIS IS A5
	CALLA	WC_LONGI
	MOVE	A6,A0			;THIS IS A6
	CALLA	WC_LONGI
	MOVE	B2,A0			;THIS IS A7
	CALLA	WC_LONGI
	MOVE	A8,A0			;THIS IS A8
	CALLA	WC_LONGI
NO_DUMP
	callr	CMOSLOCK
	MMFM	SP,A0,A1,A7
	MMFM	SP,B0,B1,B2
	RETS

**************************************************************************
*								         *
* DISPDUMP - PAGE THROUGH ALL OF THE CURRENT DUMP DATA.			 *
*								         *
**************************************************************************
DISPDUMP
	MOVI	DUMP_PTR,A7
	CALLA	RC_WORD			;GET THE INDICATOR OF HOW MANY.
	JRZ	DUMP_NONE
	CMPI	TOTAL_DUMPS,A0		;TOO MANY INDICATED?
	JRLS	DD_NUM_OK		;BR = NO
	MOVI	TOTAL_DUMPS,A0		;JUST DISPLAY MAX NUMBER
DD_NUM_OK
	CLR	A9			;THIS IS CURRENT ONE
	MOVE	A0,A8			;THIS IS THE LAST ONE TO DO

DO_ANOTHER_DPAGE
	CALLA	CLR_SCRN		;CLEAR SCREEN
	MOVI	20,A10			;THIS IS Y COORDIANTE OF CURRENT ONE!
	MOVI	DUMPS_PP,A11		;THIS IS MAX NUMBER PER PAGE.

DO_ANOTHER_DUMP
	JSRP	DO_DUMP
	ADDI	25,A10			;KICK Y UP
	INC	A9			;KICK TO NEXT DUMP
	CMP	A8,A9			;UNTIL THEY'RE ALL DONE!
	JRHS	DUMP_DONE		;WE'RE NOT ALL DONE YET!

	DSJS	A11,DO_ANOTHER_DUMP	;NOT FOR THIS PAGE EITHER!

	JSRP	WAIT_MUT		;WAIT AND WATCH FOR CLEAR
	JRUC	DO_ANOTHER_DPAGE

DUMP_DONE
	JSRP	WAIT_MUT
DUMP_NONE
         RETP                         ;AND RETURN TO CALLER!

**************************************************************************
*								         *
*          WAIT_MUT							 *
* 									 *
*          THIS IS LIKE "WAIT_BUT"....WAIT FOR ANY BUTTON EXCEPT	 *
*          THAT IT WILL CLEAR OUT THE DUMPS IF BOTH BOMB BUTTONS ARE	 *
*          PUSHED IN.							 *
*								         *
**************************************************************************
WAIT_MUT
	CALLA	FORM_SWS	;1ST STATE DOESN'T COUNT
*
*        RETURN CURRENT STATE IN A0..PREVIOUS STATE IN A1.
*
WB1
	SLEEP	1

	CALLA	FORM_SWS
	MOVE	A0,A2
	ANDI	2020H,A2
	CMPI	2020H,A2
	JRNZ	WB2		;NOT "CLEAR"

        movi    air_horn_blast,a4
        calla   do_sound
	CALLR	DUMP_FS		;CLEAR OUT THE DUMPS!
	CALLR	CLR_DUMP_AUD	;AND THE AUDITS
	JRUC	WB1

WB2
	NOT	A1		;LAST = 0 AND NOW = 1 MEANS EDGE!

	AND	A1,A0		;1'S WHERE WE HAVE POSITIVE EDGE.
	ANDI	00241010H,A0	;TRIGGER OR START BUTTON?
	JRZ	WB1
        movi    S_CURSOR_SELECT,a4
        calla   do_sound
	RETP

DCLR_SND
	.WORD	0F1FEH,030H,08164H,0	;DUMP CLEAR SOUND

**************************************************************************
*								         *
*          DO_DUMP							 *
* 									 *
*          A9 = DUMP NUMBER TO DO					 *
*          A10 = Y POSITION.						 *
*								         *
**************************************************************************
DO_DUMP
	MMTM	A12,A8,A9,A10,A11

	MOVI	DUMP_SIZE,A7
	MPYU	A9,A7		;THIS IS OFFSET INTO CMOS FOR THIS ENTRY!

	MOVI	9,A5		;NUMBER OF LONGS TO DUMP
	ADDI	DUMP_DATA,A7	;NOW A1 POINTS WHERE WE'RE PUTTING THE DATA!
	MOVI	DUMP_ARRAY,A6
NEXT_ELE
	CALLA	RC_LONGI	;GET A REGISTER
	MOVE	A0,*A6+,L	;AND STORE IT
NO_SKIP_NOW
	DSJS	A5,NEXT_ELE
	MOVI	MESS_DUMP,A8
	BTST	0,A9		;SELECT ALTERNATING COLOR, WHITE = EVEN
	JREQ	DD_WHITE	;			   PURPLE = ODD
	MOVI	COLOR_PPURPLE,A2
	JRUC	DD_LOADY
DD_WHITE
	MOVI	COLOR_PWHITE,A2
DD_LOADY
	MOVE	A10,A3		;Y IN A3
	CALLA	LM_SETUP
	MOVE	A2,A5
	SLL	16,A3
	MOVY	A3,A9
	JSRP	PRINTF

	MMFM	A12,A8,A9,A10,A11
	RETP

MESS_DUMP
	MESS_MAC  RD7FONT,1,10,355,COLOR_PWHITE,STRLNRM,0
	.STRING	"%08lX %08lX %08lX %08lX %08lX %08lX\n%08lX %08lX %08lX",0
	.LONG	DUMP_ARRAY
	.LONG	DUMP_ARRAY+20H
	.LONG	DUMP_ARRAY+40H
	.LONG	DUMP_ARRAY+60H
	.LONG	DUMP_ARRAY+80H
	.LONG	DUMP_ARRAY+0A0H
	.LONG	DUMP_ARRAY+0C0H
	.LONG	DUMP_ARRAY+0E0H
	.LONG	DUMP_ARRAY+100H


FACTORY_TABLE
	.LONG	0000H	;ADJ_UNUSED		EQU	0
	.LONG	0001H	;ADJ_PRICING		EQU	1
	.LONG	0001H	;ADJ_LEFT_MULT		EQU	2
	.LONG	0004H	;ADJ_CENTER_MULT	EQU	3
	.LONG   0001H	;ADJ_RIGHT_MULT   	EQU     4
	.LONG	0001H	;ADJ_FOURTH_MULT	EQU	5
	.LONG	0001H	;ADJ_UNITS_CREDIT	EQU	6
	.LONG	0000H	;ADJ_UNITS_BONUS	EQU	7
	.LONG	0000H	;ADJ_MIN_UNITS		EQU	8
	.LONG	0004H	;ADJCDIV		EQU	9
	.LONG	0001H	;SHOW FRACTIONS		EQU	10
	.LONG	0002H	;ADJ_START_CRED		EQU	11
	.LONG	0002H	;ADJ_CONT_CRED		EQU	12
	.LONG	0005H	;ADJ_DIFFICULTY		EQU	13
	.LONG	    0	;ADJ_TOURMODE		EQU	14
	.LONG	    3	;ADJ_CHALMODE		EQU	15
	.LONG       6	;ADJ_FULL GAME		EQU	16 
	.LONG	    2	;ADJ_NUM_EXTRA_MEN	EQU	17
	.LONG	    0	;ATTRACT MODE SOUND	EQU	18
	.LONG	   50	;MAXIMUM CREDITS	EQU	19
	.LONG	0000H	;FREEPLAY		EQU	20
	.LONG	0001H	;NON-ZERO MEANS COIN BLOCK (1ST 8) UNTOUCHED 21
	.LONG	0000H	;PAY FOR 3 MIN OVERTIME	EQU	22
	.LONG	0001H	;NON-ZERO MEANS 1ST 6 UNTOUCHED.           23
	.LONG	0000H	;NON-ZERO MEANS NO COIN-SPECIFIC MESSAGE ON COIN PAGE  24
	.LONG	0002H	;25 ADJBUYIN - 0 = NEVER, 1 = SOMETIMES, 2 = ALWAYS
	.LONG	0001H	;26 ADJHSON  - 0 = NO, 1 = YES
	.LONG	   2	;ADJ_TMRSPD		EQU	27
	.LONG	FACTORY_VOLUME	;ADJVOLUME		EQU	28
	.LONG	FACTORY_MINVOL	;ADJMINVOL		EQU	29
	.LONG	0004H	;ADJDBVMULT  	EQU	30
	.LONG	0001H	;ADJTOTALIZER	EQU	31
	.LONG	0001H	;ADJLTOTMULT 	EQU	32
	.LONG	0000H	;ADJCTOTMULT 	EQU	33
	.LONG	0001H	;ADJRTOTMULT 	EQU	34
	.LONG	0000H	;ADJXTOTMULT 	EQU	35
	.LONG	0004H	;ADJBTOTMULT 	EQU	36

