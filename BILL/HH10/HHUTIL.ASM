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

rink_palette
   .word   256
   .word   00000h,021dfh,002a0h,03affh,05400h,05415h,05540h,056b5h
   .word   0294ah,0295fh,02beah,02bffh,07d4ah,07d5fh,07feah,07fffh
   .word   077bdh,06f7bh,06b5ah,06318h,05ad6h,056b5h,04e73h,04631h
   .word   03defh,039ceh,0318ch,0294ah,02529h,01ce7h,014a5h,01084h
   .word   07c00h,07400h,07000h,06800h,06400h,05c00h,05800h,05000h
   .word   04c00h,04400h,03c00h,03800h,03000h,02c00h,02400h,02000h
   .word   07f7bh,07ef7h,07e73h,07defh,07d6bh,07d08h,07c84h,07d29h
   .word   07eabh,07e68h,07e24h,07de0h,071a0h,06580h,05940h,04d20h
   .word   07ffbh,07ff7h,07ff3h,07fefh,07febh,07fc8h,07fc4h,07fc0h
   .word   07360h,06700h,05aa0h,04e60h,04200h,039a0h,02d40h,02100h
   .word   06bebh,063e8h,05be4h,053e0h,04b80h,04320h,03ac0h,03260h
   .word   06ffbh,05ff7h,04ff3h,043efh,033ebh,023e8h,013e4h,003e0h
   .word   003e0h,003a0h,00380h,00340h,00320h,002e0h,002c0h,00280h
   .word   00260h,00220h,001e0h,001c0h,00180h,00160h,00120h,00100h
   .word   06fffh,05fffh,04fffh,03fffh,02fffh,023ffh,013ffh,003ffh
   .word   0039ch,00339h,002d6h,00273h,00210h,001ceh,0016bh,00108h
   .word   02effh,022dfh,012bfh,0027fh,0023ch,001f9h,001b6h,00173h
   .word   06f7fh,05effh,04e7fh,03e1fh,02d9fh,0211fh,0109fh,0001fh
   .word   0001fh,0001dh,0001ch,0001ah,00019h,00017h,00016h,00014h
   .word   00013h,00011h,0000fh,0000eh,0000ch,0000bh,00009h,00008h
   .word   07b7fh,072ffh,06e7fh,069ffh,0657fh,05d1fh,0589fh,0541fh
   .word   04c1ch,04019h,03816h,03013h,02810h,0200eh,0180bh,01408h
   .word   07f7fh,07effh,07e7fh,07dffh,07d7fh,07d1fh,07c9fh,07c1fh
   .word   0701ch,06419h,05816h,04c13h,04010h,0340eh,02c0bh,02008h
   .word   07fbbh,07f9ah,07f78h,07f57h,07f36h,07f14h,07ef3h,07ef2h
   .word   07ed0h,07e8eh,07e6ch,07a4bh,0762bh,06e2ah,06a0ah,065e9h
   .word   05de9h,059c8h,055a8h,05187h,04d87h,04966h,04566h,04145h
   .word   03925h,03524h,02d04h,028e3h,024e3h,020c3h,01ca2h,01481h
   .word   00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h
   .word   060a5h,06125h,061c5h,06265h,06305h,04f05h,03b05h,02705h
   .word   01706h,0170bh,01711h,01716h,016b8h,015f8h,01558h,014b8h
   .word   02cb8h,040b8h,058b8h,060b5h,060b0h,060aah,060a5h,07fffh

grey_player_pal
   .word   255
   .word   035adH,06f7cH,0637cH,0675cH,0633cH,0671cH,0673aH,05b3cH
   .word   05f1cH,0631bH,0633aH,062fcH,0671aH,05b1cH,05f1bH,05efcH
   .word   05afcH,05efbH,05b1bH,056fcH,0571bH,05afbH,05adcH,05edbH
   .word   056fbH,052fcH,056dcH,052dcH,056bcH,056dbH,05abbH,052bcH
   .word   052dbH,052faH,05af8H,04edcH,056bbH,05a9bH,0569bH,052daH
   .word   04edbH,04ebcH,04edaH,0569aH,052d9H,04e9bH,04abaH,0527aH
   .word   04eb9H,04e5bH,05697H,04e7aH,05279H,052b6H,0469aH,0427bH
   .word   04a7aH,04e5aH,04e79H,04ab8H,04a5bH,04a98H,0467aH,04698H
   .word   04a97H,05695H,05295H,04e57H,04a78H,0423bH,04279H,04659H
   .word   04678H,0461bH,04a77H,04658H,04278H,04677H,04e75H,04619H
   .word   04259H,04258H,04638H,04a37H,04219H,04257H,05254H,04a74H
   .word   04e54H,03e58H,04238H,04618H,03a39H,03e57H,04237H,03e38H
   .word   04236H,03e37H,04217H,03a37H,04a34H,04a53H,03a17H,03a36H
   .word   04632H,04234H,04613H,04232H,04612H,03e14H,03a15H,04611H
   .word   045f1H,04211H,03dd4H,039d5H,041f1H,04210H,041f0H,039f2H
   .word   03df0H,041d0H,03defH,039f0H,03dd0H,035d2H,039d0H,039ceH
   .word   035b0H,039aeH,035adH,07377H,06f38H,06f17H,06718H,072d4H
   .word   06ed4H,06ad6H,06af3H,06ed2H,06ed3H,05ef6H,062f4H,066b4H
   .word   06ab3H,062b5H,066b3H,062b4H,066b2H,062d3H,05ab4H,06293H
   .word   06272H,05eb1H,06292H,06291H,05ab2H,05e72H,05e91H,05e70H
   .word   05e71H,05a92H,05692H,05673H,05e51H,05a72H,05654H,05691H
   .word   05a51H,05a52H,05a70H,05a71H,05671H,05272H,05271H,05631H
   .word   05650H,05651H,04e72H,05252H,05251H,05250H,04e52H,05231H
   .word   04e51H,04e32H,04e50H,0522fH,05230H,0524fH,04e31H,0520fH
   .word   04a32H,04e30H,04e4fH,0522eH,04e11H,04e10H,04e2fH,04a31H
   .word   04e2dH,04e0eH,04defH,04e0fH,04a11H,04631H,04a2fH,04a30H
   .word   04a10H,04a0fH,04a2dH,049f0H,04a2eH,049eeH,04a0eH,04230H
   .word   049efH,0460eH,04a0dH,04610H,0460fH,045f0H,049edH,0420fH
   .word   045efH,041efH,045ceH,045edH,045eeH,041eeH,041cfH,041ceH
   .word   041cdH,03dcfH,03dceH,03dcdH,03dadH,039cdH,039adH,0378eH
   .word   0374dH,0372eH,0370eH,036eeH,036cdH,0368dH,0364dH,0360dH
   .word   0738dH,0739cH,06b5aH,06318H,05ad6H,05294H,0738dH

**************************************************************************
*                                                                        *
* MYOINIT - INITIALIZE SUPPLEMENTAL OBJECT LIST HEADERS			 *
*                                                                        *
**************************************************************************
MYOINIT
	MMTM	SP,A0,A1,A2,A3,A4,A5
	PUSHST
	CALLA	CLRPAL
	MOVI	T2FIXED,A0
	CALLA	GETFPAL			;GET THE FIXED FOREGROUND PALETTE
	MOVI	TEXTPAL,A0		;FIX THE TEXT PALETTE
	CALLA	GETFPAL			;IF YOU CHANGE THIS, CHANGE TEXT_PAL
	movi	rink_palette,a0
	calla	GETFPAL
	MOVE	A0,@CURPAL,W		;STUFF THIS HERE FOR FIXED STUFF
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
*                                                                        *
* FRANIM - ANIMATION SCRIPT PROCESSOR					 *
* A1 = [SLEEP_MULTIPLIER, COMMAND]					 *
*      COMMAND: 00 = PROCESS CURRENT FRAME.				 *
* 		01 = PROCESS TO END OF LIST.				 *
* 		02 = PROCESS X # OF FRAMES OR TO END. A1=[SM,#FRMS:02]	 *
* 		03 = INFINITELY LOOP ON THE LIST.			 *
* 		04 = PROCESS CURRENT FRAME, NO SLEEP(TIME RETRN'D IN A0) *
*	SLEEP_MULTIPLIER:						 *
*		IF = 0 THEN, NO MULTIPLY				 *
*		IF <> 0 THEN, BITS 16-23 FRACTION			 *
*			      BITS 24-31 INTEGER			 *
* A8 = PTR TO OBJECT BLOCK						 *
* A9 = PTR TO CURRENT FRAME						 *
* RETURN(S)								 *
* CARRY SET IF END OF ANIMATION LIST WAS HIT				 *
* A9 = POINTING TO NEXT FRAME, IF NOT AT END OF LIST			 *
* SETS EPARENT OF THE SPAWNED CHILD POINTING TO THIS PROCESS		 *
* NOTE: CALL WITH JSRP, IT SLEEPS					 *
* 									 *
* ANIMATION SCRIPT FORMAT						 *
* 	.LONG	IMAGE_HEADER<-- IF = 0 END OF SCRIPT			 *
* 	.WORD	SLEEP_TIME  <-- BITS 0 - 7 ARE THE SLEEP TIME.	 	 *
* 			    <-- BITS 8 -15 ARE THE FLAGS:		 *
* 				 BIT #	DESCRIPTION		SIZE	 *
* 				 -----	-----------		----	 *
* 				   8	NEW SCRIPT ADDRESS 	(32)	 *
* 				   9	SOUND SCRIPT TO EXECUTE (32)	 *
* 				  10	UNUSED				 *
* 				  11	DELTA Y			(16) 	 *
* 				  12	PACKED DELTAS FOR X&Z 	(16)	 *
* 				  13	NEW PALETTE ADDRESS	(32)	 *
* 				  14	NEW FLIP BITS		(16)	 *
* 				  15	SPAWN PROCESS W/OFFSETS	(80)	 *
* 					 .WORD XOFF,YOFF,PROCID		 *
* 					 .LONG PROCADDR			 *
* 				FLAG HIERARCHY: 15 --> 8		 *
* 				 OPTIONS SHOULD FOLLOW IN THIS ORDER.    *
*                                                                        *
**************************************************************************
FRANIM
	MMTM	A12,A3,A11
	MOVE	A9,A11			;SAVE ENTRYPOINT FOR INFINITE CASE
	MOVY	A1,A2
	SRL	16,A2			;ISOLATE SLEEP TIME MULTIPLIER
	ZEXT	A1			;AND CLEAR IT FROM A1
	SLL	8,A1			;PUT EXTRA BYTE IN HIGH WORD
	CLR	A3			;TO KEEP COMPATIBLE
	MOVX	A1,A3
	SRL	8,A3			;SLIDE THE COMMAND BACK DOWN
	MOVX	A3,A1			;AND RETURN IT TO A1
FRAN1
	MOVE	A1,A3

	.IF	DEBUG
	CMPI	0FFC00000H,A9
	JRLO	$
	.ENDIF

	MOVE	*A9+,A1,L		;GET THE FRAME
	JREQ	FRANND			;BR = END WAS HIT

	MMTM	SP,A2,A4,A5,A6,A7,A10

      	MOVE	*A8(OCTRL),A4,W		;GRAB THE FLAGS
;   	MOVE	*A8(OFLAGS),A4,W	;GRAB THE FLAGS

	MOVE	*A9+,A0,W
	MOVE	A0,B0			;XFER FLAGS HERE
	SLL	24,A0
	SRL	24,A0			;WIPE OFF THE FLAGS

	SRL	8,B0			;STRIP THE SLEEP TIME
	SLL	24,B0			;MOVE FLAGGIES UP HERE
	JRZ	FRANANI			;BR = NO FLAGS

	SLL	1,B0
	JRNC	FRANNOSP
*SPAWN A PROCESS
	MMTM	SP,A0,A1
	MOVE	*A9+,A10,L	;X AND Y FIRING OFFSETS PASSED IN A10
	MOVE	*A9+,A1,W	;GET PROCESS ID
	MOVE	*A9+,A7,L	;PROCESS STARTING ADDRESS
	CALLA	GETPRC		;SPAWN THE PROCESS
FRSPAWNF
	MMFM	SP,A0,A1
FRANNOSP
	SLL	1,B0
	JRNC	FRANNOBI
*STUFF SOME NEW FLAGS
	MOVE	*A9+,A2,W		;GET THE NEW FLIP FLAGS
	ANDNI	(M_FLIPV+M_FLIPH),A4	;CLEAR THE CURRENT FLIP STATUS
	OR	A2,A4			;SET DESIRED BITS

FRANNOBI:
	SLL	1,B0
	JRNC	FRANNOPA
*ACTIVATE A NEW PALETTE
	PUSH	A0
	MOVE	*A9+,A0,L		;GET THE NEW PALETTE ADDRESS
	CALLA	CHANGE_PAL		;SWITCH THE PALETTES
	PULL	A0
FRANNOPA
	SLL	1,B0
	JRNC	FRANNDXZ
*ADD DELTA X AND Z
	MOVE	*A9+,A7,W		;GET THE DELTAS
	MOVE	A7,A6
	SLL	24,A6
	SRA	24,A6			;BRING THE SIGN BACK DOWN
	JRZ	FNODX			;BR = THERE'S NO DELTA HERE
	BTST	B_FLIPH,A4
	JREQ	FNOFDX
	NEG	A6			;HE'S FLIPPED, NEGATE
FNOFDX
	MOVE	*A8(OXPOS),A5,W
	ADD	A6,A5
	MOVE	A5,*A8(OXPOS),W		;ADJUST X POSITION
FNODX
	SRA	8,A7
	JRZ	FRANNDXZ		;BR = NO Z OFFSET

	MOVE	*A8(OZPOS),A5,W
	ADD	A7,A5
	MOVE	A5,*A8(OZPOS),W		;ADJUST Z POSITION

FRANNDXZ
	SLL	1,B0
	JRNC	FRANNDY
*ADD DELTA Y
	MOVE	*A9+,A7,W
	JRZ	FRANNDY
	BTST	B_FLIPV,A4
	JREQ	FNOFDY
	NEG	A7
FNOFDY
	MOVE	*A8(OYPOS),A5,W
	ADD	A7,A5
	MOVE	A5,*A8(OYPOS),W		;ADJUST Y POSITION
FRANNDY
	SLL	2,B0		;GET TO BIT 9, SKIP 10
	JRNC	FRANNSND	;BR = NO SOUND TO MAKE
	PUSH	A0
	MOVE	*A9+,A0,L	;GET SOUND SCRIPT
;	CALLA	ONESND		;AND PROCESS IT
	PULL	A0
FRANNSND:
	SLL	1,B0
	JRNC	FRANNNA		;BR = NO NEW SCRIPT ADDRESS
	MOVE	*A9,A9,L	;LOAD IN THE NEW SCRIPT ADDRESS
FRANNNA:
*JUST TO THE ANIMATION
FRANANI:
	CALLA	ANI		;SETUP NEW ANIMATION

	MMFM	SP,A2,A4,A5,A6,A7,A10

	MOVE	A3,A1		;GET THE COMMAND BACK
	MOVE	A2,A2		;MULTIPLY?
	JRZ	FRAN_NO_MULT	;BR = NO
	MOVE	A0,A3
	SLL	8,A3 		;MAKE FRACTION ZERO
	MPYU	A2,A3		;MULTIPLY
	SRL	16,A3
	JRNZ	FRAN_SLEEP_OK
	MOVK	1,A3		;DEFAULT TO SHORTEST SLEEP
FRAN_SLEEP_OK:
	MOVE	A3,A0		;INTEGER ONLY TO SLEEP
FRAN_NO_MULT:
	CMPI	4,A1		;ONE FRAME, NO SLEEP?
	JREQ	FRAN3		;YES

	MMTM	A12,A1,A2
	CALLA	PRCSLP		;SLEEP THE PROPER TIME
	MMFM	A12,A1,A2

	CMPI	1,A1
	JREQ	FRAN1		;BR = LOOP 'TIL END OF LIST
	JRLT	FRAN3		;BR = ONE FRAME AT A TIME
	CMPI	3,A1
	JREQ	FRAN1		;BR = INFINTE LOOP

	SUBI	010000h,A1	;DECREMENT FRAME COUNT
    	CLR	A0
	CMPXY	A0,A1
	JRYGT	FRAN1		;FRAME COUNT HAS NOT BEEN EXHAUSTED

FRAN3	CLRC			;CLEAR END FLAG
	JRUC	FRANX

FRANND	MOVE	A3,A1
	CMPI	3,A1
	JRNE	FRAN4		;BR = EXIT

	MOVE	A11,A9		;GET THE STARTING POINTER BACK
	JRUC	FRAN1		;LOOP INFINITELY

FRAN4	SETC			;OTHERWISE, RETURN WITH END FLAG SET
FRANX
	MMFM	A12,A3,A11
	RETP

**************************************************************************
*                                                                        *
* FRAMSKIP - SKIP TO THE NEXT FRAME OF AN ANIMATION SCRIPT		 *
* A9 = SCRIPT PTR							 *
* RETURNS:								 *
* 	C CLR = A9 IS POINTING TO NEXT FRAME				 *
* 	C SET = SCRIPT END WAS HIT, A9 POINTS TO NEXT WORD		 *
*                                                                        *
**************************************************************************
FRAMSKIP
	MMTM	SP,A1
	MOVE	*A9+,A1,L		;GET THE FRAME
	JREQ	FRAMSSC			;BR = END WAS HIT
	MOVE	*A9+,A1,W
	SRL	8,A1			;STRIP THE SLEEP
	SLL	24,A1			;MOVE FLAGGIES UP HERE
	JRZ	FRAMSANI		;BR = NO FLAGS

	SLL	1,A1
	JRNC	FRAMSNSP
	ADDI	32+16+32,A9		;PROCESS SPAWN
FRAMSNSP
	SLL	1,A1
	JRNC	FRAMSNF
	ADDK	16,A9			;NEW FLAGS
FRAMSNF
	SLL	1,A1
	JRNC	FRAMSNP
	ADDK	32,A9			;NEW PALETTE
FRAMSNP
	SLL	1,A1
	JRNC	FRAMSNXZ
	ADDK	16,A9			;DELTA X & DELTA Z
FRAMSNXZ
	SLL	1,A1
	JRNC	FRAMSNY
	ADDK	16,A9			;DELTA Y
FRAMSNY
	SLL	2,A1
	JRNC	FRAMSNSND
	ADDK	32,A9			;SOUND TO MAKE
FRAMSNSND:
	SLL	1,A1
	JRNC	FRAMSNNSA
	MOVE	*A9,A9,L		;JUMP TO NEW FRAME
FRAMSNNSA:
FRAMSANI:
	CLRC
	JRUC	FRAMSND
FRAMSSC
	SETC
FRAMSND
	MMFM	SP,A1
	RETS

**************************************************************************
*								         *
* SKIP_ANIMATION - ROUTINE TO SKIP TO THE END OF AN ANIMATION SCRIPT.	 *
*		   THERE IS A 20 FRAME MAX SKIP IMPOSED.		 *
* A9 = PTR TO SCRIPT							 *
* RETURNS:								 *
* A9 = PTR TO WORD AFTER SCRIPT END					 *
*								         *
**************************************************************************
SKIP_ANIMATION
	PUSH	A0
	MOVK	20,A0
SKA_LP
	CALLR	FRAMSKIP
	JRC	SKA_X
	DSJS	A0,SKA_LP
SKA_X
	PULL	A0
	RETS

**************************************************************************
*								         *
* ANIMATE_TIME - RUN AN ANIMATION FOR THE GIVEN AMOUNT OF TICKS.	 *
* A8 = OBJECT								 *
* A9 = SCRIPT (MAKE SURE IT'S LONG ENOUGH TO LAST THE GIVEN TIME)	 *
* A10 = TIME								 *
* NOTE: CALL WITH JSRP							 *
*								         *
**************************************************************************
ANIMATE_TIME
	MOVK	4,A1
	JSRP	FRANIM
	MOVE	A10,A14			;KEEP TIME LEFT, IN CASE WE HIT BOTTOM
	SUB	A0,A10
	JRLE	ANIMATE_TX
       	SLOOPR	A0,ANIMATE_TIME
ANIMATE_TX
	SLEEPR	A14			;ANIMATE THE FINAL TIME
	RETP

**************************************************************************
*                                                                        *
* ANIMATOR - INDEPENDENT ANIMATION PROCESS, PROCESSES AN ANIMATION	 *
* 	     SCRIPT WITH A COMMAND.		     			 *
* A8 = OBJECT TO ANIMATE						 *
* A9 = SCRIPT								 *
* A11 = FRANIM COMMAND							 *
*                                                                        *
**************************************************************************
ANIMATOR
	MOVE	A11,A1
	JSRP	FRANIM
	CLR	A0
	MOVE	A0,*A8(OPLINK),L
	DIE

**************************************************************************
*								         *
* ANIMATE_DEL - INDEPENDENT ANIMATION PROCESS, PROCESSES AN ANIMATION	 *
* 	     SCRIPT WITH A COMMAND THEN DELETE THE OBJECT.		 *
* A8 = OBJECT TO ANIMATE						 *
* A9 = SCRIPT								 *
* A11 = FRANIM COMMAND							 *
*								         *
**************************************************************************
ANIMATE_DEL:
	MOVE	A11,A1
	JSRP	FRANIM
	CLR	A0
	MOVE	A0,*A8(OPLINK),L
	CALLA	DELETE_OBJ
	DIE

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
	move	*A8(AnimScr),A14,L
	cmpi	UNFLASH,A14
	jreq	SkWhite				;BR = already unflashing..
	move	A14,*A8(OVAR5),L
	move	*A8(AnimFrm),*A8(OVAR6),L
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
	LWL	1,1|AFunc,UnFlash

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
	move	A1,*A8(AnimFrm),L
	move	*A8(OVAR5),*A8(AnimScr),L
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
