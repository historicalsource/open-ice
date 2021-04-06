	.MLIB	"HHMACS.LIB"
	.FILE	"HHUTIL.ASM"
	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST

**************************************************************************
*								         *
* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		 *
* 		       ALL RIGHTS RESERVED.				 *
*								         *
**************************************************************************

*	GET THE SYSTEM STUFF
	.INCLUDE	"HH.INC"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhutil.e"
	.include	"hhd.g"
	.include	"hhproc.g"
	.include	"hh.g"
	.include	"hhram.g"
	.include	"hhpall.g"
	.include	"hhc.g"
	.include	"hhsnd.g"
	.include	"hhtext.g"

; end of include files

	.EVEN
	.TEXT

**************************************************************************
*                                                                        *
* CLRPDATA - CLEAR THE PDATA AREA OF A PROCESS BLOCK			 *
* A13 = PTR TO PROCESS BLOCK						 *
*                                                                        *
**************************************************************************
CLRPDATA
	MMTM	SP,A1,A6,A14
	MOVE	A13,A14
	CLR	A1
	ADDI	PDATA,A14
	MOVI	(PSDATA-PDATA)/16,A6
CLRSHL
	SRL	1,A6
	JRNC	CLRPDL
	MOVE	A1,*A14+,W	;STUFF THE ODD WORD
CLRPDL
	MOVE	A1,*A14+,L
	DSJS	A6,CLRPDL
	MMFM	SP,A1,A6,A14
	RETS

T2FIXED:
	.word	 25
	.word	00H,07C00H,06739H,01FH,035ADH,077A0H,0741AH,03A0H
	.word	00H,010H,07E3H,07FFFH,07DADH,06420H,02108H,03DEFH
	.word	04210H,05AD6H,05EF7H,0C0H,0120H,0982H,0221H,0782H
	.word	047F1H

**************************************************************************
*                                                                        *
* MYOINIT - INITIALIZE SUPPLEMENTAL OBJECT LIST HEADERS			 *
*                                                                        *
**************************************************************************
MYOINIT
	MMTM	SP,A0,A1,A2,A3,A4,A5
	PUSHST

	CALLA	RESET_MAX_PALXFERS

	CALLA	CLRPAL
	MOVI	T2FIXED,A0
	CALLA	GETFPAL			;GET THE FIXED FOREGROUND PALETTE
	MOVI	TEXTPAL,A0		;FIX THE TEXT PALETTE
	CALLA	GETFPAL			;IF YOU CHANGE THIS, CHANGE TEXT_PAL
	calla	build_whitepal

;	MOVE	A0,@CURPAL,W		;STUFF THIS HERE FOR FIXED STUFF
	DINT
	MOVE	@INTENB,A0,W
	ANDNI	X1E,A0			;NO MORE DMA INTERRUPTS
	MOVE	A0,@INTENB,W
	POPST
	CLR	A0
	MOVE	A0,@GAMERASE
	CALLR	DMAWAIT			;WAIT ON DMA
	CALLA	IAUTOE

*INITIALIZE SUPPLEMENTAL LIST HEADERS
	MOVI	SUPPLSTS,A1		 ;GET THE SUPPLEMENTAL LIST AREA
	CLR	A0
MYOINITS:
	MOVE	A0,*A1+,L
	CMPI	SUPPLSTSX,A1
	JRLO	MYOINITS
	clr	a0
	move	a0,@rink_on,W
	move	a0,@small_timer_on,W
	MMFM	SP,A0,A1,A2,A3,A4,A5
	JAUC	OINIT

**************************************************************************
*                                                                        *
* RANDOM - GENERATE A RANDOM NUMBER					 *
* RETURNS:								 *
* A0 = 32 BIT RANDOM #							 *
*                                                                        *
**************************************************************************
RANDOM:
	MOVE	@RAND,A0,L
	SLA	1,A0
	JRV	RND2
	ORI	2,A0
RND2:	MOVE	A0,@RAND,L
	CLR	A14
	ADDC	A14,A0	;GET LAST BIT BACK TO MAKE 32
	MOVE	@HCOUNT,A14,W
	RL	A14,A0	;RANDOM ROTATION
	MOVE	A0,A0	;SET STATUS BITS
	RETS

**************************************************************************
*                                                                        *
* RANDU - GENERATE A UNIFORMLY DISTRIBUTED RANDOM # BETWEEN 1 AND [A0]	 *
* A0 = RANGE INPUT							 *
* RETURNS:								 *
* A0 = RANDOM #								 *
*                                                                        *
**************************************************************************
RANDU:	PUSH	A1
	MOVE	A0,A1
	CALLR	RANDOM
	MPYU	A1,A0
	INC	A0
	MMFM	SP,A1
	RETS

**************************************************************************
*								         *
* 	RAND0								 *
* 									 *
* 	Generate a uniformly distributed random # between 0 and		 *
* 	[A0 - 1].							 *
* 									 *
* 	A0 = Distribution range						 *
* 									 *
* 	Returns:							 *
* 		A0 = Number (Status bits reflect value in A0)		 *
*								         *
**************************************************************************
RAND0:
	PUSH	A1
	MOVE	A0,A1
	CALLR	RANDOM
	MPYU	A1,A0
	MOVE	A0,A0
	MMFM	SP,A1
	RETS

*
*GET SIGNED RANDOM # IN RANGE +/- A0
*CALLING PARAMETERS: A0
*RETURNS A0
*
SRAND:
	PUSH	A0
	SLL	1,A0
	CALLA	RANDU
	PULLQ	A14
	SUB	A14,A0
	RETS
**************************************************************************
*                                                                        *
* RANGRAND - GENERATE A RANDOM NUMBER IN A GIVEN RANGE.			 *
* A0 = UPPER BOUND							 *
* A1 = LOWER BOUND							 *
* RETURNS								 *
* A0 = RANDOM #								 *
*                                                                        *
**************************************************************************
RANGRAND
	SUB	A1,A0		;NORMALIZE THE RANGE
	CALLR	RANDU
	ADD	A1,A0
	RETS

**************************************************************************
* RANGERND - GENERATE A RANDOM NUMBER IN A GIVEN RANGE.
* A0 = VAL 1 (SIGNED, UPPER BOUND)
* A1 = VAL 2 (SIGNED, LOWER BOUND)
* RETURNS
* A0 = RANDOM #	BETWEEN VAL 1 AND VAL 2
* CLOBBERS A1
RANGERND
	CMP	A1,A0
	JRGE	VALSOK	;WANT A0 > A1
	SWAP	A1,A0
VALSOK
	SUB	A1,A0
	CALLR	RAND0
	ADD	A1,A0
	RETS

*
*RANDPER - RANDOM % ROUTINE
*CALLING PARAMETERS:
*A0=PROBABILITY OF EVENT (0-1023) P(A0=1024) = 1; P(A0=1) = 1/1024.
*RETURNS CS IF PROBABILITY IS TRUE, CC FOR FALSE
*RETURNS A0 = ACTUAL RANDOM # 0-1023
RANDPER:
	PUSH	A0
	CALLA	RANDOM
	SRL	22,A0
	PULLQ	A14
	CMP	A14,A0
	RETS

**************************************************************************
*                                                                        *
* FILLAREA - FILL A GIVEN SQUARE AREA ON THE SCREEN WITH A COLOR	 *
* A1 = [COLOR,PALETTE]							 *
* A3 = DAG OF AREA [YPOS,XPOS]						 *
* A4 = [Y,X] SIZE OF AREA						 *
*                                                                        *
**************************************************************************
FILLAREA
	MMTM	SP,A0,A1,A2,A4,A5,A7
	MOVI	QDMAN,A7
	JRUC	AREACON

**************************************************************************
*                                                                        *
* BLNKAREA - BLANK A GIVEN SQUARE AREA ON THE SCREEN			 *
* A3 = DAG OF AREA [YPOS,XPOS]						 *
* A4 = [Y,X] SIZE OF AREA						 *
*                                                                        *
**************************************************************************
BLNKAREA
	MMTM	SP,A0,A1,A2,A4,A5,A7
	MOVI	QDMAN,A7
	CLR	A1			;CONSTANT 0:PALETTE 0
	JRUC	AREACON

AREACON
	MOVI	[0100H,0100H],A0
	MOVE	A4,A2
	MOVI	IROM,A4		;SOMEWHERE IN IMAGE ROM
	MOVI	DMACAL,A5
	SLL	16,A5
	CALL	A7
	MMFM	SP,A0,A1,A2,A4,A5,A7
	RETS

**************************************************************************
*								         *
* DRAWBOX_OBJ - DRAW A BOX AS OBJECTS USING THE DISPLAY SYSTEM		 *
* A0 = [H,W] SIZE OF BOX						 *
* A1 = [COLOR,PALETTE]							 *
* A2 = LINE THICKNESS IN PIXELS						 *
* A3 = [Y,X] SCREEN ADDRESS OF BOX					 *
*								         *
**************************************************************************
DRAWBOX_OBJ
	MMTM	SP,A0,A2,A3,A4,A5,A6,A7,A8
	MOVE	A0,A4
	MOVE	A3,A7
	MOVE	A2,A8			;KEEP PIXEL THICKNESS HERE
	SLL	16,A2
	MOVX	A4,A2
	MOVE	A2,A6

	MOVI	BOXLINE_INIT,A5
	CALLA	CREATE_OBJ
	JRZ	DBO_X
	MOVE	A1,*A0(OPAL),L
	MOVE	A3,*A0(OXPOS),W
	MOVE	A3,*A0(OYVAL),L
	MOVE	A2,*A0(OSIZE),L
	CALLA	INSOBJ

	RL	16,A2
	MOVY	A4,A2
	MOVE	A2,A4

	MOVI	BOXLINE_INIT,A5
	CALLA	CREATE_OBJ
	JRZ	DBO_X
	MOVE	A1,*A0(OPAL),L
	MOVE	A3,*A0(OXPOS),W
	MOVE	A3,*A0(OYVAL),L
	MOVE	A2,*A0(OSIZE),L
	CALLA	INSOBJ

	SRL	16,A2
	SLL	16,A2
	RL	16,A8
	SUBXY	A8,A2			;ADJUST FOR PIXEL THICKNESS
	ADDXY	A2,A3			;MOVE TO LL CORNER
	MOVE	A6,A2

	MOVI	BOXLINE_INIT,A5
	CALLA	CREATE_OBJ
	JRZ	DBO_X
	MOVE	A1,*A0(OPAL),L
	MOVE	A3,*A0(OXPOS),W
	MOVE	A3,*A0(OYVAL),L
	MOVE	A2,*A0(OSIZE),L
	CALLA	INSOBJ

	ZEXT	A2
	DEC	A2
	RL	16,A8
	SUBK	1,A8			;BASE ON 1 PIXEL
	SUBXY	A8,A2			;ADJUST FOR PIXEL THICKNESS
	ADDXY	A2,A7
	MOVE	A7,A3			;MOVE TO UR CORNER
	MOVE	A4,A2

	MOVI	BOXLINE_INIT,A5
	CALLA	CREATE_OBJ
	JRZ	DBO_X
	MOVE	A1,*A0(OPAL),L
	MOVE	A3,*A0(OXPOS),W
	MOVE	A3,*A0(OYVAL),L
	MOVE	A2,*A0(OSIZE),L
	CALLA	INSOBJ

DBO_X
	MMFM	SP,A0,A2,A3,A4,A5,A6,A7,A8
	RETS

BOXLINE_INIT
	.LONG	BOXLINE,0
	.WORD	OID_JUNK,DMACAL,M_SCRNOBJ|M_NOSCALE,0
	.LONG	0

BOXLINE:
	.word	4,4
	.long	IROM
	.word   0,0,00H
	.long	T2FIXED

**************************************************************************
*                                                                        *
* DMAWAIT - WAIT ON THE DMA BUSY BIT TO CLEAR				 *
*                                                                        *
**************************************************************************
DMAWAIT
	MOVE	@DMAGOREG,A14,W	;DMA BUSY?
	JRN	DMAWAIT		;BR = YES
	RETS

**************************************************************************
*								         *
* DMAQWAIT - WAIT ON DMA QUEUE TO EMPTY, THEN DMA BUSY TO CLEAR		 *
*								         *
**************************************************************************
DMAQWAIT
	cmp	B12,B13		;Is Q Empty?
	jrgt	DMAQWAIT
	MOVE	@DMAGOREG,A14,W	;DMA BUSY?
	JRN	DMAQWAIT	;BR = YES
	RETS

**************************************************************************
*                                                                        *
* DMAHALT - HALT THE DMA						 *
*                                                                        *
**************************************************************************
DMAHALT
	CLR	A14
	MOVE	A14,@DMAGOREG,L		;HALT THE DMA
	MOVE	A14,@DMAGOREG,L		;CLEAR THE DMA
	RETS


*
*CMAPRS - RESET THE COLOR MAP SELECT
CMAPRS	CLR	A0
*CMAPSL - SELECT THE COLOR MAP(0-15 IN A0)
CMAPSL	MOVE	A1,-*SP,L
	CALLA	DMAWAIT
	MOVE	A0,@CMAPSEL
	MOVE	*SP+,A1,L
	RETS

*
*SCRCLR - CLEAR THE SCREEN WITH EUGENE
*ONLY CALL WITH INTERRUPTS DISABLED AND THE DMA SHUT DOWN, OTHERWISE
*	USE CLR_SCRN
SCRCLR	CLR	A0
*SCRFIL - FILL SCREEN WITH A0
SCRFIL:
	MMTM	SP,A1,A2
	CLR	A1
	MOVE	A1,@CMAPSEL,W			;SELECT COLOR MAP 0
	MOVI	SCREEN,A1,L
	MOVI	(SCRNE-SCREEN)/32,A2,L
SCRLP	MOVE	A0,*A1+,L
	DSJS	A2,SCRLP
	MMFM	SP,A1,A2
	RETS

*
*LAST2CLR - CLEAR LAST TWO LINES OF BIT MAP(I.E. SET AUTO ERASE COLOR)
LAST2CLR
	CLR	A0
*
*LAST2FIL - FILL LAST TWO LINES OF BIT MAP
*A0 = FILL COLOR
LAST2FIL
	MOVE	A0,@ERASELOC,W			;STUFF DA COLOR
	RETS
**************************************************************************
*                                                                        *
* SETPPROC - SETUP TI'S PIXEL PROCESSING REGISTER'S (BFILE), TO MATCH 	 *
* 	   THE ZUNIT SYSTEM.						 *
* NOTE:	   IF YOU WANT TO DO ANY SPECIAL TRICKS, DON'T USE THIS. 	 *
*                                                                        *
**************************************************************************
SETPPROC
	PUSH	A0
	MOVI	OFFSETVAL,B4	;Set up OFFSET register
	MOVI	0,B8		 	;Set background color
	MOVI	SCRN_PTCH,A0 		;Get Screen Pitch
	MOVE	A0,B1
	MOVE	A0,B3
	LMO	A0,A0			;Convert in temporary register
	MOVE	A0,@CONVSP		;Move to CONVSP io register
	MOVE	A0,@CONVDP		;Move to CONVDP io register
	PULL	A0
	RETS


**************************************************************************
*                                                                        *
* CLRBLOCK - CLEAR A BLOCK OF MEMORY. SIZE MUST BE A FACTOR OF 16	 *
*	     MAKE SURE BLOCK SIZE IS 32 BITS OR GREATER.		 *
* A1 = START ADDRESS							 *
* A2 = END ADDRESS							 *
*                                                                        *
**************************************************************************
CLRBLOCK:
	PUSH	A3
	CLR	A3
	CALLR	FILBLOCK
	PULL	A3
	RETS

**************************************************************************
*                                                                        *
* FILBLOCK - FILL A BLOCK OF MEMORY. SIZE MUST BE A FACTOR OF 16	 *
*	     MAKE SURE BLOCK SIZE IS 32 BITS OR GREATER.		 *
* A1 = START ADDRESS							 *
* A2 = END ADDRESS							 *
* A3 = FILL VALUE							 *
*                                                                        *
**************************************************************************
FILBLOCK:
	MMTM	SP,A1,A2
	SUB	A1,A2
	SRL	5,A2
	JRNC	FIL32LP
	MOVE	A3,*A1+,W		;MOVE THE ODD WORD
FIL32LP:
	MOVE	A3,*A1+,L		;JUST MOVE LONG
	DSJS	A2,FIL32LP
	MMFM	SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
* CLR_SCRN - CLEAR THE WHOLE BIT MAP					 *
* NOTE : TRASHES A0							 *
*                                                                        *
**************************************************************************
CLR_SCRN:
	CLR	A0
*
*YOU PROVIDE THE COLOR IN A0
FILL_SCRN:
	MMTM	SP,A1,A2,A3
	MOVE	@DISPLAYON,A3,W
	CLR	A1
	MOVE	A1,@DISPLAYON,W
	CALLR	DMAQWAIT			;WAIT ON DMA
	CLR	A1
	MOVE	A1,@CMAPSEL,W			;SELECT COLOR MAP 0
	MOVI	SCREEN,A1,L
	MOVI	((SCRNE-2000H)-SCREEN)/32,A2,L
CLRLP	MOVE	A0,*A1+,L
	DSJS	A2,CLRLP
	MOVE	A3,@DISPLAYON,W
	MMFM	SP,A1,A2,A3
	RETS


**************************************************************************
*								         *
* 	CLEAR_PAGE2							 *
* 									 *
* 	Clear just screen page 2					 *
*								         *
**************************************************************************
CLEAR_PAGE2
	MMTM	SP,A0,A1,A2,A3
	CLR	A0
	MOVE	@DISPLAYON,A3,W
	MOVE	A0,@DISPLAYON,W
	CALLA	DMAQWAIT			;WAIT ON DMA
	CLR	A1
	MOVE	A1,@CMAPSEL,W			;SELECT COLOR MAP 0
	MOVI	PAGE2_START,A1,L
	MOVI	((PAGE2_END + 1) - PAGE2_START)/32,A2,L
	JRUC	CLRP0LP

**************************************************************************
*								         *
* 	CLEAR_PAGE3							 *
* 									 *
* 	Clear just screen page 2					 *
*								         *
**************************************************************************
CLEAR_PAGE3
	MMTM	SP,A0,A1,A2,A3
	CLR	A0
	MOVE	@DISPLAYON,A3,W
	MOVE	A0,@DISPLAYON,W
	CALLA	DMAQWAIT			;WAIT ON DMA
	CLR	A1
	MOVE	A1,@CMAPSEL,W			;SELECT COLOR MAP 0
	MOVI	PAGE3_START,A1,L
	MOVI	((PAGE3_END + 1) - PAGE3_START)/32,A2,L
CLRP0LP	MOVE	A0,*A1+,L
	DSJS	A2,CLRP0LP
	MOVE	A3,@DISPLAYON,W
	MMFM	SP,A0,A1,A2,A3
	RETS

**************************************************************************
*								         *
* FlshWyte - FLASH AN OBJECT TO CONSTANT COLOR USE ANIM TO UNFLASH.	 *
* 	     TO USE THIS FUNCTION OBJ MUST NOT USE OVAR5,OVAR6		 *
* 		BUT IT CAN BE ON ANIM.					 *
* A1 = OCONST								 *
*								         *
**************************************************************************
FlshWyte:
	PUSH	A1
	movb	*A8(OFLAGS+B_ANIM-7),A14	;already animating??
	jrnn	FlashIt0			;NO..

	;save current anim info in OVAR5,OVAR6
	move	*A8(ANIMSCR),A14,L
	cmpi	UNFLASH,A14
	jreq	SkWhite				;BR = already unflashing..
	move	A14,*A8(OVAR5),L
	move	*A8(ANIMFRM),*A8(OVAR6),L
	jruc	FlashIt
FlashIt0
	CLRM	*A8(OVAR6),L
FlashIt
	move	A1,*A8(OCONST),W
	movi	UNFLASH,A1
	calla	STRT_ANIM
	move	*A8(OCTRL),A14,W
;	move	*A8(OFLAGS),A14,W
	andni	M_WRNONZ,A14	;Don't Write Non-Zero Data
	ori	M_CONNON,A14	;Do Replace Non-Zero Data with constant
	move	A14,*A8(OCTRL),W
;	move	A14,*A8(OFLAGS),W
SkWhite:
	PULLQ	A1
	rets

*FLASH ANIM SCRIPT
UNFLASH
	LW	1,4
	LWL	1,1|AFUNC,UnFlash

****************************************************************************
* UnFlash
* Anim function used by FlshWyte to unflash an object and restore its
* previous action
UnFlash:
	move	*A8(OCTRL),A1,W
;	move	*A8(OFLAGS),A1,W
	ori	M_WRNONZ,A1	;Do Write Non-Zero Data
	andni	M_CONNON,A1	;Don't Replace Non-Zero Data with constant
	move	A1,*A8(OCTRL),W
;	move	A1,*A8(OFLAGS),W

	move	*A8(OVAR6),A1,L
	jrz	UFPul
	;*** JUST RESTORE TO OLD ANIM SCRIPT ***
	move	A1,*A8(ANIMFRM),L
	move	*A8(OVAR5),*A8(ANIMSCR),L
	jruc	UnFlashX

UFPul	calla	PULL_ANIM
UnFlashX
	rets


**************************************************************************
*                                                                        *
* SLINEVEL - GET THE X & Y VELOCITIES TO MAKE AN OBJECT TRAVEL		 *
* 	   FROM PNT. A TO PNT. B ALONG THE SHORTEST PATH.		 *
* A2 = PNT. A [Y,X] POSITION						 *
* A3 = PNT. B [Y,X] POSITION						 *
* A4 = DURATION(# OF TICKS TO GET FROM A TO B)				 *
* RETURNS:								 *
* A1 = X VEL (32 BITS)							 *
* A2 = Y VEL (32 BITS)							 *
* NOTE: DON'T CALL WITH THE A=B, IT'S A WAIST OF TIME AND UNDEFINED.	 *
*                                                                        *
**************************************************************************
SLINEVEL
	PUSH	A3
	SUBXY	A2,A3		;GET THE DIFFERENCE
	MOVX	A3,A1		;A1 = X DISTANCE
	SRL	16,A3
	SLL	16,A3		;CLEAR OUT THE X PART
	DIVS	A4,A3		;A3 = Y VELOCITY(32 BITS)
	SLL	16,A1
	DIVS	A4,A1		;A1 = X VELOCITY(32 BITS)
	MOVE	A3,A2		;RETURN Y VEL HERE FOR CONSISTENCY
	PULLQ	A3
	RETS

	.END

;**************************************************************************
;*								         *
;* LAMPS_OFF - TURN BOTH LAMPS OFF					 *
;* 									 *
;* PASS:									 *
;* NUTIN'								 *
;* RETURN:								 *
;* NUTIN'								 *
;*								         *
;**************************************************************************
;
;LAMPS_OFF
;	MOVE	@MISCOUT_COPY,A14,W
;;	ORI	M_LEFT_LAMP|M_RGHT_LAMP,A14
;	ANDNI	M_LEFT_LAMP|M_RGHT_LAMP,A14
;	MOVE	A14,@MISCOUT_COPY,W
;	MOVE	A14,@MISCOUT,W
;	RETS
;
;**************************************************************************
;*								         *
;* LAMP_OFF - TURN A LAMP OFF						 *
;* 									 *
;* PASS:									 *
;* A0 = LAMP MASK							 *
;* RETURN:								 *
;* NUTIN'								 *
;*								         *
;**************************************************************************
;
;LAMP_OFF
;	MOVE	@MISCOUT_COPY,A14,W
;;	OR	A0,A14
;	ANDN	A0,A14
;	MOVE	A14,@MISCOUT_COPY,W
;	MOVE	A14,@MISCOUT,W
;	RETS
;
;**************************************************************************
;*								         *
;* LAMPS_ON - TURN BOTH LAMPS ON						 *
;* 									 *
;* PASS:									 *
;* NUTIN'								 *
;* RETURN:								 *
;* NUTIN'								 *
;*								         *
;**************************************************************************
;
;LAMPS_ON
;	MOVE	@MISCOUT_COPY,A14,W
;;	ANDNI	M_LEFT_LAMP|M_RGHT_LAMP,A14
;	ORI	M_LEFT_LAMP|M_RGHT_LAMP,A14
;	MOVE	A14,@MISCOUT_COPY,W
;	MOVE	A14,@MISCOUT,W
;	RETS
;
;**************************************************************************
;*								         *
;* LAMP_ON - TURN A LAMP ON						 *
;* 									 *
;* PASS:									 *
;* A0 = LAMP MASK							 *
;* RETURN:								 *
;* NUTIN'								 *
;*								         *
;**************************************************************************
;
;LAMP_ON
;	MOVE	@MISCOUT_COPY,A14,W
;;	ANDN	A0,A14
;	OR	A0,A14
;	MOVE	A14,@MISCOUT_COPY,W
;	MOVE	A14,@MISCOUT,W
;	RETS
