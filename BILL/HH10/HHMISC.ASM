	.MLIB	"HHMACS.LIB"
	.FILE	"HHMISC.ASM"
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
	.include	"hhmisc.e"
	.include	"hhram.g"
	.include	"hhproc.g"
	.include	"hhcmos.g"
	.include	"hhpall.g"

; end of include files


*SYMBOLS IN APPROC.ASM
	.IF NOTFINAL
	.REF	THISWAKE
	.ENDIF

	.EVEN
	.TEXT

**************************************************************************
*								         *
* 	NOTE: PLACE THESE TWO DUMB COLLISION VECTORS IN A USABLE	 *
* 	      POSITION SOMEDAY!!!!					 *
*								         *
**************************************************************************
DUMCRETS			;COLLISION RETURN TO CONTINUE SCAN
	CLRZ
	RETS

DUMCOLL				;LABEL FOR THE COMMON CAUSE
	.WORD	0
	.LONG	DUMCRETS	;DO NOTHING

**************************************************************************
*								         *
* DUMPPRINT - Do a register dump to the Printer, if it's installed.	 *
* 		If not, then go to CMOS.				 *
* 									 *
* 		If DEBUG  then we jsut hang here.			 *
* 		If PRINTER & ~DEBUG  then PRINT registers.		 *
* 		If ~PRINTER & ~DEBUG  then Write to CMOS.		 *
*								         *
**************************************************************************
DUMPPRINT
	.IF DEBUG

	JRUC	$
	RETS			;USE THIS TO JUMP BACK.

	.ELSE

	MOVE	*SP,B14,L	;Grab the return address for dump

	 PUSH	A0
	 AUDIT	AUDWARNING
	 PULLQ	A0
	 CLR	A14
	 JRUC	DUMP_IT

	 .ENDIF

**************************************************************************
*								         *
* DUMP_IT - Dump Registers and relevent info to the CMOS dump pages.	 *
* A14 = Dump Code							 *
* B14 = Return Address							 *
*								         *
**************************************************************************
DUMP_IT
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8
	MOVE	A0,A7

	PUSH	A14
	PUSH	B14
	MOVI	AUDUPTIME,A0
	CALLA	GET_AUD
	MOVE	A1,A6
	PULLQ	B14
	PULLQ	A14

	MOVE	@TIMER,A0,W
	SLL	4,A0
	OR	A14,A0
	SLL	16,A0
	MOVE	@GAME_STATE,A14,W
	MOVX	A14,A0			;A0 = [CODE, GSTATE]

	MOVE	@CURPLYRS,A14,W
	MOVX	A14,A1			;A1 = [WAVE, # OF PLAYERS]

;	MOVE	*SP(120H),A2,L		;A2 = RETURN ADDRESS
	MOVE	B14,A2			;A2 = RETURN ADDRESS

	.IF NOTFINAL
	MOVE	@THISWAKE,A3,L		;A3 = LAST WAKE-UP ADDRESS
	.ENDIF

	CALLA	ADD_DUMP

	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8
	RETS

**************************************************************************
*                                                                        *
* COLOR_START - START THE COLOR RAM PROCESSES				 *
*                                                                        *
**************************************************************************
COLOR_START
	MMTM	SP,A0,A1,A7
	MOVI	PID_COLOR,A0
	CALLA	KILLPROC_ALL
	CREATE	PID_COLOR,LFLASH
	CREATE	PID_COLOR,RGB
	CREATE	PID_COLOR,BPR
	CREATE	PID_COLOR,DECAY
	MMFM	SP,A0,A1,A7
	RETS

**************************************************************************
*                                                                        *
* TABLE DRIVEN COLOR RAM PROCESSES					 *
*                                                                        *
**************************************************************************
*	xxxxxA0(10)	-	RGB
*	xxxxxB0(11)	-	BPR
*	xxxxxC0(12)	-	DECAY
*	xxxxxD0(13)	-	LASER FLASH

RGB	CALLR	TABDRIVE
	.LONG	RGBTAB,COLRTEMP+0A0H
	.WORD	8
RGBTAB	.WORD	07C00H,001FH,077A0h,0741Ah,0FFFFH

*
DECAY	CALLR	TABDRIVE
	.LONG	DCATAB,COLRTEMP+0C0H
	.WORD	2
DCATAB	.WORD	001CH,001CH,011CH,021CH,031CH,039CH,239CH,2390H,2388H
	.WORD	2380H,4300H,5280H,7180H,6180H,7080H,7000H,6000H,5000H
	.WORD	4000H,3000H,2000H,1000H,0FFFFH
*
BPR	CALLR	TABDRIVE
	.LONG	BPRTAB,COLRTEMP+0B0H
	.WORD	1
BPRTAB	.WORD	001CH,101CH,201CH,301CH,401CH,501CH,601CH,701CH,7010H
	.WORD	7010H,7008H,7008H,7000H,7000H,7008H,7008H,7010H,7010H
	.WORD	701CH,701CH,601CH,501CH,401CH,301CH,201CH,101CH,0FFFFH

**************************************************************************
*								         *
* LFLASH - PROCESS TO CREATE THE FAMOUS LASER FLASH COLOR 		 *
*								         *
**************************************************************************
LFLASH	MOVI	07FFFH,A0
	MOVE	A0,@COLRTEMP+0D0H,W
	SLEEP	2
LFLASH1
	MOVE	@RAND,A0,W
	ANDI	0000001FH,A0
	MOVI	COLTAB,A1
	SLL	4,A0
	ADD	A0,A1
	MOVE	*A1,A1,W
	MOVE	A1,@COLRTEMP+0D0H,W
	SLEEP	6
	JRUC	LFLASH

COLTAB	.WORD	0380H,1380H,2380H,3380H,4380H,5380H,6380H,7380H,7300H
	.WORD	7280H,7200H,7180H,7080H,7008H,7008H,7010H,7010H,701CH
	.WORD	701CH,601CH,501CH,409CH,309CH,209CH,219CH,029CH,039CH
	.WORD	139CH,239CH,339CH,539CH,739CH,7390H,7380H,6380H,4380H
	.WORD	0FFFFH

**************************************************************************
*                                                                        *
* THE TABLE DRIVEN PROCESS						 *
*                                                                        *
**************************************************************************
TABDRIVE
	MOVE	*SP+,A0,L
	MOVE	*A0+,A11,L	;A11 = TABLE START
	MOVE	*A0+,A9,L	;A9 = LOCATION TO STUFF COLOR
	MOVE	*A0,A10,W	;A10 = SLEEP TIME
TABDRV1
	MOVE	A11,A8		;RESET TO START OF TABLE
TABDRV2
	MOVE	*A8+,A0,W	;GET A COLOR
	JRN	TABDRV1		;BR = END OF TABLE
	MOVE	A0,*A9,W
	MOVE	A10,A0
	MOVI	TABDRV2,A7
	JAUC	PRCLSP		;LOOP SLEEP

**************************************************************************
*								         *
* CYCLE16 - PROCESS TO CYCLE UP TO SIXTEEN COLORS OF A GIVEN PALETTE.	 *
* A8 = PTR TO PALETTE (PALETTE MUST BE ALLOCATED).			 *
* A9 = START COLOR #							 *
* A10 = END COLOR #							 *
* A11 = SPEED								 *
*								         *
**************************************************************************
CYCLE16:
	MOVE	A11,*A13(PDATA),W	;KEEP THE SLEEP TIME
	MOVE	A10,A2
	CLR	A11			;THIS WILL BE THE DIRECTION FLAG
	SUB	A9,A2
	JRNN	CYCLE16_FOR		;BR = FOWARD CYCLE
	ABS	A2
	NOT	A11			;FLAG A REVERSE CYCLE
	SWAP	A9,A10			;SWAP THESE FOR LOAD

CYCLE16_FOR:
	MOVE	A9,*A13(PDATA+10H),W	;STORE THE START COLOR
	MOVE	A9,A3
	MOVE	A13,A9
	ADDI	PDATA+60H,A9		;START COLOR ADDRESS
	MOVE	A9,A10
	MOVE	A2,A4
	SLL	4,A4
	ADD	A4,A10			;END COLOR ADDRESS

	MOVE	A8,A0
	MOVE	A9,A1			;THIS IS THE STARTING COLOR LOCATION
	ADDK	16,A0			;SKIP THE COLOR COUNT
	SLL	4,A3
	ADD	A3,A0			;AND GET TO THE START COLOR
	INC	A2
	MOVE	A2,*A13(PDATA+20H),W	;STORE THE COLOR COUNT

CYCLE16_LOAD:
	MOVE	*A0+,*A1+,W		;TRANSFER THE PALETTE TO RAM
	DSJS	A2,CYCLE16_LOAD

CYCLE16_WAIT:
	MOVE	A8,A0
	CALLA	FINDPAL			;DOES THIS PALETTE EXIST?
	JRNZ	CYCLE16_FND		;BR = YES, GO AHEAD AND CYCLE
	SLOOP	6,CYCLE16_WAIT		;WAIT FOR IT TO EXIST

CYCLE16_FND:
	MOVE	A0,A7			;STORE FOUND PALETTE NUMBER HERE
	MOVE	*A13(PDATA+20H),A4,W	;DO IT THIS MANY TIMES
	DEC	A4			;WATCH THE ZERO BASE

	MOVE	A11,A11			;CHECK DIRECTION
	JRNN	CYCLE16_UP		;BR = CYCLE COLORS UP
	MOVE	A9,A1			;GET THE END COLOR
	MOVE	*A1,A3,W		;STORE THE COLOR
	MOVE	A10,A2
	MOVE	A1,A0
	ADDK	16,A1
CYCLE16_DN_LP:
	MOVE	*A1+,*A0+,W
	DSJS	A4,CYCLE16_DN_LP
	JRUC	CYCLE16_DONE

CYCLE16_UP:
	MOVE	A10,A1			;GET THE END COLOR
	MOVE	*A1,A3,W		;STORE THE COLOR
	MOVE	A9,A2
	MOVE	A1,A0
	ADDK	16,A1
CYCLE16_UP_LP:
	MOVE	-*A0,-*A1,W
	DSJS	A4,CYCLE16_UP_LP
CYCLE16_DONE:
	MOVE	A3,*A2,W		;WRAP COLOR
	MOVE	A9,A0
	MOVE	*A13(PDATA+10H),A1,W
	ZEXT	A7
	SRL	8,A7
	SLL	8,A7
	OR	A7,A1			;DESTINATION: 8-15 PALETTE, 0-7 START
	MOVE	*A13(PDATA+20H),A2,W	;GET THE COUNT
	CALLA	PALSET			;SETUP A TRANSFER
	MOVE	*A13(PDATA),A0,W
	SLOOPR	A0,CYCLE16_WAIT

**************************************************************************
*								         *
* CYCLE1 - PROCESS TO CYCLE ONE COLOR OF A PALETTE THROUGH DIFFERENT	 *
*	   VALUES.							 *
* A8 = PALETTE I.D. PROCESS WILL WAIT 'TIL PALETTE IS ALLOCATED.	 *
* A9 = TABLE OF COLORS							 *
* A10 = COLOR #								 *
* A11 = SPEED								 *
*								         *
**************************************************************************
CYCLE1:
	MOVE	A9,*A13(PDATA+10H),L	;STORE THE TABLE START ADDRESS
CYCLE1_WAIT:
	MOVE	A8,A0
	CALLA	FINDPAL			;DOES THIS PALETTE EXIST?
	JRNZ	CYCLE1_FND		;BR = YES, GO AHEAD AND CYCLE
	SLOOP	6,CYCLE1_WAIT		;WAIT FOR IT TO EXIST
CYCLE1_FND:
	MOVE	A0,A8			;KEEP FOR SUCCESSIVE ITERATIONS
	MOVE	A0,A5
	CALLA	INC_PALCNT		;SURELY YOUR NOT GOING ANYWHERE
	ZEXT	A8
	SRL	8,A8
	SLL	8,A8
CYCLE1_LP
	MOVE	A10,A1			;COLOR NUMBER
	OR	A8,A1			;DESTINATION: 8-15 PALETTE, 0-7 START
	MOVE	A9,A0
	MOVK	1,A2
	CALLA	PALSET			;SETUP A TRANSFER
	ADDK	16,A9			;INCREMENT TABLE PTR
	MOVE	*A9,A14,W
	JRNN	CYCLE1_SLP
	MOVE	*A13(PDATA+10H),A9,L	;RESET TO THE HEAD OF THE TABLE
CYCLE1_SLP
	SLOOPR	A11,CYCLE1_LP


**************************************************************************
*                                                                        *
* GWINCENT - GET THE CURRENT TEXT WINDOW CENTER POINT.			 *
* RETURNS:								 *
* A0 = CENTER PNT.							 *
*                                                                        *
**************************************************************************
GWINCENT
	MOVI	[88,198],A0
	RETS

**************************************************************************
*                                                                        *
* XCOLOR - COLOR VALUE MULTIPLIER					 *
* A0 = COLOR VALUE							 *
* A1 = X FACTOR (MSW:INTEGER LSW:FRACTION)				 *
* RETURNS								 *
* A0 = X COLOR VALUE							 *
*                                                                        *
**************************************************************************
XCOLOR
	MMTM	SP,A3,A4
	CLR	A4
	MOVE	A0,A3
	SLL	27,A3
	SRL	27,A3		;NOW I GOT 'DA BLUES
	MPYU	A1,A3
	SLL	11,A3
	SRL	27,A3
	OR	A3,A4
	MOVE	A0,A3
	SLL	22,A3
	SRL	27,A3		;GREENS
	MPYU	A1,A3
	SLL	11,A3		;STRIP GARBAGE
	SRL	27,A3
	SLL	5,A3
	OR	A3,A4
	MOVE	A0,A3
	SLL	17,A3
	SRL	27,A3		;NOW REDS
	MPYU	A1,A3
	SLL	11,A3
	SRL	27,A3
	SLL	10,A3
	OR	A3,A4
	MOVE	A4,A0
	MMFM	SP,A3,A4
	RETS

