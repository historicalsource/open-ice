 	.MLIB	"HHMACS.LIB"
	.FILE	"HHC.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

**************************************************************************
*								         *
* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		 *
* 		       ALL RIGHTS RESERVED.				 *
*								         *
**************************************************************************


*	GET THE SYSTEM STUFF
	.INCLUDE	"HH.INC"
	.include	"hhc.e"
	.include	"hhd.g"
	.include	"hhproc.g"
	.include	"hhram.g"

; end of include files

	.BSS	IN_ANIM,16	;UHB '1' when processing anim funcs
	.bss	xxxx,16		;fill space to 32 bits

	.bss	bog_cpu,16
	.bss	bog_dma,16

	.text

*
*The following align encompasses a CACHE segement from here to the end
*of the DMAINT.
*
	.ALIGN

**************************************************************************
;*** DEPENDS ON A LOT OF REGISTERS BEING SET UP IN DISPLAY -- careful ***

PutPlanes

*
*	DISPLAY FOREGROUND
*
DispFG
	movi	FGLIST,a0
	move	a0,a4
	callr	DISPNEXT_FG
	.if	bog_line

	movi	01000100h,a2
	movi	COLOR_PRED,a3
	movi	00010190h,a9
	move	@bog_cpu,a10
	sll	16,a10
	movi	3000000h,a11
	movi	900c0000h,a12
	callr	xbgln

	movi	01000100h,a2
	movi	COLOR_PGREEN,a3
	movi	00010190h,a9
	move	@bog_dma,a10
	sll	16,a10
	movi	3000000h,a11
	movi	900c0000h,a12
	callr	xbgln

	jruc	xbg9

*A2 = Y-SCALE:X-SCALE
*A3 = CONST:PALETTE XLATE
*A9 = VSIZE:HSIZE
*A10 = DESTINATION Y:X
*A11 = IMAGE SAG
*A12 = CONTROL:OFFSET


xbgln	addxy	A5,A10		; add PAGE OFFSET to dest Y:X
	cmp	B12,B13		;Is Q Non-Empty?
	jrle	xskip		; JUMP IF Q EMPTY, RIGHT?
xQIt	;*** WE HAVE ENOUGH TIME TO CLIP ANOTHER, PUSH THIS ONE ***

	move	B12,A7
	MMTM	A7,A2,A3,A9,A10,A11,A12	;STORE THE DMA REGS
	move	A7,B12
	setf	1,0,0		;field 0 is 1 bit
	movk	1,A7
	move	A7,@(INTENB+B_X1E),0
	setf	16,1,0
	jruc	boglinex
xskip	move	B11,A7		;DMAREGS
	MOVE	*B1,B14,L	;XUNIT @DMACTRL,  DMA BUSY?
	jrn	xQIt		;Last obj plotted was big, Q this sucker..

	MMTM	A7,A2,A3,A9,A10,A11,A12	;STUFF THE DMA REGS

boglinex
	rets
xbg9
	.endif
	rets

**************************************************************************
*								         *
* DMAINT is now first, so it can take up a single cache segment when	 *
*  dispnext is done							 *
*								         *
**************************************************************************

	.ALIGN
DMAINT
	;*** PULL FROM Q, PUSH ON DMA ***
	move	-*B13,-*B11,L	;Y-SCALE:X-SCALE
	move	-*B13,-*B11,L	;CONST:PALETTE XLATE
	move	-*B13,-*B11,L	;VSIZE:HSIZE, NO, B11 IS not FOR THE DMAQ SIZE
	move	-*B13,-*B11,L	;DESTINATION Y:X
	move	-*B13,-*B11,L	;IMAGE SAG
	MOVE	-*B13,-*B11,L	;CTRL:OFFSET
	addi	6*020h,b11	;bring b11 back to dmaregs
	cmp	B12,B13		;Is Q Non-Empty?
	jrgt	dmadn		;branch if Q not empty
	move	@VCOUNT,@DMATMP,W
	.if	bog_line
	move	@VCOUNT,@bog_dma,W
	.endif
	setf	1,0,0		;field 0 is 1 bit
	move	sp,@(INTENB+B_X1E),0	;*** DISABLE DMA INTERRUPT ***
dmadn	reti

DISPNEXT_FG
	movi	10001h,a13
	movi	OFSET,a14
	move	b12,a7			;for fast loop, we only need to move once
	move	@rink_on,b2,W
	jrnz	dn_fast
	movk	1,b2
	setf	1,0,0		;field 0 is 1 bit
	jruc	DISPNEXT

**************************************************************************
*								         *
* FAST _ NO CHECKING CLIP LOOP						 *
*								         *
**************************************************************************
cl_fast	movb	*a0(OFLAGS),a1
	jrn	dn_fast			; don't bother if marked as offscreen
	move	a0,a1
	add	a14,a1			;OFSET
	move	*a1+,a12,L
			; CTRL:OFSET in a12,
	jrnn	dn_fast
	mmfm	a1,a11,a10,a9,a6,a3,a2
			; SAG in a11,
			; DAG in a10,
			; Unscaled size in a9,
			; SCALED SIZE in a6,
			; CONST:PAL in a3,
			; SCALE Y:X in a2
	subxy	a13,a6
	clr	a1
	btst	B_FLIPH+16,a12
	jrz	noh_f	       		;BR=OBJECT IS NOT HORIZONTALLY FLIPPED
	movx	a6,a1
noh_f	btst	B_FLIPV+16,a12
	jrz	nov_f			;BR=OBJECT IS NOT VERTICALLY FLIPPED
	movy	a6,a1
nov_f	addxy	a1,a10			;COMPENSATE
	addxy	a5,a10			; add PAGE OFFSET to dest Y:X
;	move	b12,a7		;redundant
	mmtm	a7,a2,a3,a9,a10,a11,a12	;STORE THE DMA REGS
	move	a7,b12
dn_fast	move	*a0(OBLINK),a0,L 	;GET NEXT LINK
	cmp	a0,a4
	jrnz	cl_fast
	rets

**************************************************************************
*								         *
* regular clip loop							 *
*								         *
**************************************************************************
CLIP_LOOP
	movb	*a0(OFLAGS),a1
	jrn	DISPNEXT	; don't bother if marked as offscreen
	move	a0,a1
	add	a14,a1		;OFSET
	mmfm	a1,a12,a11,a10,a9,a6,a3,a2
			; CTRL:OFSET in a12,
			; SAG in a11,
			; DAG in a10,
			; Unscaled size in a9,
			; SCALED SIZE in a6,
			; CONST:PAL in a3,
			; SCALE Y:X in a2
	MOVE	A12,A12
	JRNN	DISPNEXT		;BR = OBJECT IS OFF

;	MOVE	A2,B14		;not needed anymore with moved scale_mama
;	CMP	B6,B14		;Did scale_mama process us?
;	JREQ	DISPNEXT	;BR = No

	subxy	a13,a6
	clr	a1
	btst	B_FLIPH+16,A12
	jrz	NOH	       		;BR=OBJECT IS NOT HORIZONTALLY FLIPPED
	movx	A6,A1
NOH	btst	B_FLIPV+16,A12
	jrz	NOV			;BR=OBJECT IS NOT VERTICALLY FLIPPED
	movy	A6,A1
NOV	addxy	A1,A10			;COMPENSATE
	addxy	A5,A10		; add PAGE OFFSET to dest Y:X
	cmp	B12,B13		;Is Q Non-Empty?
	jrle	SkipQIt		; JUMP IF Q EMPTY, RIGHT?
QIt	move	b12,a7
	mmtm	a7,a2,a3,a9,a10,a11,a12	;STORE THE DMA REGS
	move	a7,b12
	move	b2,@(INTENB+B_X1E),0		;**** ENABLE DMAINT ****

DISPNEXT
	MOVE	*A0(OBLINK),A0,L 	;GET NEXT LINK
	CMP	A0,A4
	JRNE	CLIP_LOOP
	setf	16,1,0
	RETS

SkipQIt	move	*b1,b14,L	;XUNIT @DMACTRL,  DMA BUSY?
	jrn	QIt		;Last obj plotted was big, Q this sucker..
	move	B11,A7		;DMAREGS

*A2 = Y-SCALE:X-SCALE
*A3 = CONST:PALETTE XLATE
*A9 = VSIZE:HSIZE
*A10 = DESTINATION Y:X
*A11 = IMAGE SAG
*A12 = CONTROL:OFFSET
STUFF 	MMTM	A7,A2,A3,A9,A10,A11,A12	;STUFF THE DMA REGS
	jruc	DISPNEXT

**************************************************************************
*								         *
* The following align contains the entire Animation loop.		 *
*								         *
**************************************************************************

	.ALIGN

**************************************************************************
;PROCESS TO ANIMATE, EXECUTE FUNCTIONS for OBJECTS/MULTIPARTERS on ANIOBJS
NxtAni
	move	A8,B8
	movb	*A8(AnimSlp),A6
	SUB	A4,A6	    	;A4 SHOULD = LAST_TIMER, HERE
	jrp	Sleeping

	;***** PROCESS AN ANIMATION SCRIPT ENTRY *******
	move	*A8(AnimFrm),A0,L
	move	*A0+,A1,L		;grab frame ptr
	jrnz	SkLpFrm
	move	*A8(AnimScr),A0,L
NxtMultiAni
	move	*A0+,A1,L
SkLpFrm
*FOR ANY FLAG PROCESSING, DO NOT ACTUALLY AFFECT THE OBJECT WITH
* THE CHANGES UNTIL AFTER SkDead, IN CASE OF NOPARTANI.
 	move	*A8(OFLAGS),A4,W
	MOVE	*A8(OCTRL),A7,W		;GET THE DMA CONTROL, CHANGES IN ANI
	move	*A0+,A6,W		;get flags:Sleep
	jrnN	SkOpartsYAdj0

;*** FIX OPARTSXY FOR CHANGING FLIP BITS
	move	*A0+,A5,W		;get flip bits from script
	move	A5,A14
	xor	A7,A14			;which flip bits are changing??
	andn	A12,A7			;mask out M_FLIPH|M_FLIPV
	or	A5,A7			;set for animator code
SkOpartsYAdj0
	MOVE	B8,A14
	CMP	A8,A14			;ALWAYS PROCESS SINGLE/HEAD OBJECT?
	JREQ	DoEverything		;BR = YES, NO PART CHECK
	btst	B_NOPARTANI,A4		;SHOULD WE ANIMATE THIS PART OF MULTI
	jrz	DoEverything
	;IF OBJ IS IN MULTI-SCRIPT, BUT MARKED NOPARTANI
	;   SKIP FUNCTION, ARGS & ANIMATION(flag stuff too)
	btst	B_AFunc,A6		;Skip over func?
	jrz	SkANI0
	move	*A0+,A14,L		;Load function from script
	sll	28,A14			;just want arg count bits
	srl	24,A14			; arg count is in words
	add	A14,A0			;skip script ptr past args
	jruc	SkANI0

DoEverything
	;**** CHECK FOR ANIM FUNCTION ****
	btst	B_AFunc,A6
	jrz	SkAFunc
	move	*A0+,A14,L
	move	A14,*A10+,L	;QUEUE UP FUNCTION CALL
	move	A8,*A10+,L	;QUEUE UP OBJ PTR FOR FUNCTION CALL
	sll	28,A14		;just want arg count bits
	srl	24,A14		; arg count is in words
	jrz	SkAFunc
	move	A0,*A8(AnimArg),L
	add	A14,A0		;skip script ptr past args
SkAFunc

;*** NOTE A0 MUST BE KEPT VALID THROUGH ANIMATION TO PROCESS MULTI ***

	btst	0,A1		;if bottom bit of frame ptr, skip ani
	jrnz	SkANI0

*****************************  ANI  *********************************
* ANIMATION SUBROUTINE
* A1=NEW IMAGE POINTER
* A8=OBJECT STRUCTURE POINTER TO BE UPDATED

	;GET AND STUFF NEW SIZE,SAG,OFFSET
	move	a1,a14
	BTST	B_MANSCALE,A4		;IS THIS A MANUALLY SCALED OBJECT?
	jrz	nomanscl
	andni	M_NOSCALE,a4		; force RESCALE
	move	a4,*a8(OFLAGS)		;
nomanscl
	MOVE	*A14+,A2,W	;GET NEW FRAMES ICTRL IN A2
	AND	A11,A7		;MASK OUT OLD CONTROL PARMS, KEEP FLIP
	OR	A7,A2		;SETUP CONTROL AND FLIP FOR NEW FRAME
	MMFM	A14,A3,A5,A7	;A7, SIZE
				;A5, SAG
				;A3, ANIP
	MOVE	A8,A14
	ADDI	OCTRL,A14
	MOVE	A2,*A14+,W		;OCTRL
	MOVE	A5,*A14+,L		;OSAG
	ADDK	020H,A14
	MOVE	A7,*A14+,L		;OUSIZE
	MOVE	A7,*A14,L		;OSIZE
 	MOVE	A1,*A8(OIMG),L
	BTST	B_SCRNOBJ,A4		;IS THIS A SCREEN RELATIVE OBJECT?
	JRZ	ANIMP_WORLD		;BR = NO
	MOVE	*A8(OUANIOFF),A5,L	;WE MUST DO ANIMATION PNT OURSELVES
	MOVE	*A8(ODAG),A14,L
	ADDXY	A5,A14			;GET POSITION OF ANIMATION PNT ONSCREEN
	SUBI	10001H,A7		;GET SIZE READY FOR FLIPS
	SUBXY	A3,A7
	BTST	B_FLIPH,A2
	JREQ	ANIMP_NOFLIPH
	MOVX	A7,A3
ANIMP_NOFLIPH
	BTST	B_FLIPV,A2
	JREQ	ANIMP_NOFLIPV
	MOVY	A7,A3
ANIMP_NOFLIPV
	SUBXY	A3,A14
	MOVE	A14,*A8(ODAG),L
	MOVE	A14,*A8(OXPOS),W
	SRL	16,A14
	MOVE	A14,*A8(OYPOS),W

ANIMP_WORLD
	MOVE	A3,*A8(OUANIOFF),L
	move	a3,*a8(OANIOFF),L	; assume same for NOSCALE objects
	BTST	B_MANSCALE,A4
	JRNZ	ANIMP_MAN_SCALE
	BTST	B_NOSCALE,A4
	JRNZ	ANIMP_CK_SHADOW
	MOVE	A9,*A8(OSCALE),L	;FOOL SCALE MAMA INTO DOIN' US
ANIMP_CK_SHADOW
ANIMP_MAN_SCALE

****************************************************************

SkANI0	btst	B_AMulti,A6	;DO WE ANIMATE DOWN MULTI-PARTER LIST
	jrz	SkAFMulti
	move	*A8(OPARTS),A8,L
	jrnz	NxtMultiAni
SkAFMulti
	move	B8,A8
	move	A0,*A8(AnimFrm),L
	sll	24,A6
	srl	24,A6
	jrnz	GotSlp
	movb	*A8(AnimSLP),A6
GotSlp	MOVE	@LAST_TIMER,A4,W	;RELOAD THE TIME FACTOR
Sleeping
	movb	A6,*A8(AnimSlp)
	move	*A8(AnimNxt),A8,L
	jrnz	NxtAni
;******************* END OF 1st CACHEABLE BLOCK OF CACHE3 ***************

ANISCALE
	clr	A0	  	;MARK END OF ANIM FUNC LIST
	move	A0,*A10+,L

;mdp	CALLA	SCALE_MAMA		;UPDATE SCALES and compute SCREEN POS
;mdp note: scale mama is now in hhd so we no longer run extra frame behind
;mdp       (slower this way) - the alternative is to put a buffer on worldxy
;mdp       in the plot rink code to line everything up

**** WBD NOTE: Should we put an EINT here? (See DINT NOTE)

	MOVI	ACTIVE,A13

;******************* Start OF 2d Block (only 040h words long) *************
	;**** PROCESS QUEUED UP ANIM FUNCS ****
	movk	1,A0
	movb	A0,@IN_ANIM
	movi	ANIFUNCS,A12	;reset to top of list to pull funcs

	;**** PULL OUT NEXT ANIM FUNCTION ****
ANIFNCLP				;MAKE SURE THIS LOOP DOESN'T
	move	*A12+,A0,L		;SPAN CACHE BLOCK BOUNDARY
	jrz	ANIFNCX			;
	srl	4,A0			;mask out arg count
	sll	4,A0			;
	move	*A12+,A8,L		;
	call	A0			;
	jruc	ANIFNCLP		;
ANIFNCX	clr	A0
	movb	A0,@IN_ANIM

AniLpX	rets

**************************************************************************
*								         *
* ANIMP - FUNCTION TO PROCESS THE ANIMATION LIST.			 *
* 	CALLED ONCE EVERY TICK.						 *
*								         *
**************************************************************************
ANIMP
*THE FOLLOWING REGISTERS MUST REMAIN UNCHANGED UNTIL THE ANIM FUNCS ARE CALLED
	movi	M_FLIPH|M_FLIPV,A12	;used to mask out M_FLIPH|M_FLIPV
	MOVI	0807FH,A11		;MASK FOR CONTROL WORD
	movi	ANIFUNCS,A10		;GET READY TO QUEUE UP ANIM FUNCS
	MOVI	BOGUS_SCL,A9		;BOGUS SCALE TO FOOL SCALE_MAMA
	MOVE	@LAST_TIMER,A4,W	;LOAD THE TIME FACTOR

*** WBD NOTE:  Should we put a DINT here? to make sure DIRQ doesn't happen before
***            Ani is done and SCALE_MAMA is called?

	move	@ANIOBJS,A8,L
	jrnz	NxtAni
	JRUC	ANISCALE

**************************************************************************
*								         *
* End of Animation cache loop						 *
*								         *
**************************************************************************

	.text
**************************************************************************
PULLANIMFUNC
;*** CALLED FROM PULLANIM TO ALSO PULL A QUEUED UP ANIM FUNC
;A0 obj being pulled from anim
;A12 if IN_ANIM, A12 must be pointing to ANIM FUNC QUEUE
	mmtm	SP,A1,A12
	;** CAN ONLY BE A QUEUED UP FUNCTION IF CURRENTLY IN ANIM LIST **
	movb	@IN_ANIM,A14
	jrz	PULANIFNCX

	.IF DEBUG
	;MAKE SURE NO ONE HAS FUCKED WITH A12
	cmpi	ANIFUNCS,A12
	jrlo	$
	cmpi	ANIFUNCSX,A12
	jrhi	$
	.ENDIF

	;SCAN REST OF ANIM FUNC QUEUE FOR FUNC WITH THIS OBJ.
PULANIFNCLP
	move	*A12+,A14,L	;another func?
	jrz	PULANIFNCX
	move	*A12+,A14,L	;check the obj to match A0
	cmp	A0,A14
	jrne	PULANIFNCLP

	;*** WE HAVE A QUEUED UP ANIM FUNC FOR THIS OBJ, PULL IT ***
	;*** Pull by shifting other funcs up queue ***
SHIFTANIFNCLP
	move	A12,A14		;A12 src, A14 dest
	subi	040h,A14
	move	*A12+,A1,L	;FUNC, set the ZFLAG
	move	A1,*A14+,L
	move	*A12+,*A14+,L	;OBJ
	move	A1,A1
	jrnz	SHIFTANIFNCLP

PULANIFNCX
	mmfm	SP,A1,A12
	rets

****	.sect	"CACHE5"

	.ALIGN

**************************************************************************
*								         *
* 	ANI								 *
* 									 *
* 	Single frame animation subroutine.				 *
* 									 *
* 	A1 = New IMAGE pointer						 *
* 	A4 = New OCTRL							 *
* 	A8 = Ptr to object to animate					 *
* 									 *
* 	Returns:							 *
* 		Nothing							 *
*								         *
**************************************************************************
ANI
	mmtm	SP,A0,A2,A3,A5,A7
	;CHECK IF FLIP BITS CHANGE FOR OPARTSXY FUDGE
	move	*A8(OCTRL),A2,W
	xor	A4,A2
	btst	B_FLIPH,A2
	jrz	SkOpartsXAdj			;BR=FLIPH DIDN'T CHANGE
	move	*A8(OPARTSXY),A3,W		;ADJUST X PARTS
	NEG	A3
	move	A3,*A8(OPARTSXY),W

SkOpartsXAdj
	btst	B_FLIPV,A2
	jrz	SkOpartsYAdj			;BR=FLIPV DIDN'T CHANGE
	move	*A8(OPARTSXY+010H),A3,W		;ADJUST Y PARTS
	NEG	A3
	move	A3,*A8(OPARTSXY+010H),W

SkOpartsYAdj

	;GET AND STUFF NEW SIZE,SAG,OFFSET

;Bill- start 11/12/1993
	MOVE	A1,A14
;Bill- end 11/12/1993
	MOVE	*A14+,A2,W	; ICTRL IN A2
	MMFM	A14,A3,A5,A7	;A7, SIZE
				;A5, SAG
				;A3, ANIP
	ANDI	0807FH,A4
	OR	A2,A4
	MOVE	A1,*A8(OIMG),L
	MOVE	A7,*A8(OUSIZE),L
	MOVE	A7,*A8(OSIZE),L
	MOVE	A5,*A8(OSAG),L
	MOVE	A4,*A8(OCTRL),W
	MOVE	*A8(OFLAGS),A2,W
	BTST	B_SCRNOBJ,A2		;IS THIS A SCREEN RELATIVE OBJECT?
	JRZ	ANI_WORLD		;BR = NO

;This is the added computation for a screen object

	MOVE	*A8(OUANIOFF),A5,L	;WE MUST DO ANIMATION PNT OURSELVES
	MOVE	*A8(ODAG),A14,L
	ADDXY	A5,A14			;GET POSITION OF ANIMATION PNT ONSCREEN
	SUBI	10001H,A7		;GET SIZE READY FOR FLIPS
	SUBXY	A3,A7
	BTST	B_FLIPH,A4
	JREQ	ANI_NOFLIPH
	MOVX	A7,A3
ANI_NOFLIPH
	BTST	B_FLIPV,A4
	JREQ	ANI_NOFLIPV
	MOVY	A7,A3
ANI_NOFLIPV
	SUBXY	A3,A14
	MOVE	A14,*A8(ODAG),L
	MOVE	A14,*A8(OXPOS),W
	SRL	16,A14
	MOVE	A14,*A8(OYPOS),W
;	JRUC	ANI_FINISH		;Skip shadow stuff for screen object

;Added support for shadows is used in world objects only
ANI_WORLD
ANI_FINISH
	MOVE	A3,*A8(OUANIOFF),L
	MOVE	A3,*A8(OANIOFF),L
	mmfm	SP,A0,A2,A3,A5,A7
	rets

**************************************************************************
* ANINP - ANIMATION SUBROUTINE (no position update)			 *
* A1=NEW IMAGE POINTER							 *
* A4=NEW OFLAGS								 *
* A8=OBJECT STRUCTURE POINTER TO BE UPDATED				 *
ANINP	mmtm	SP,A2,A3,A5
	;GET AND STUFF NEW SIZE,SAG,OFFSET
	zext	A4,W		;ZERO OFFSET IN A4
	move	*A1(ISIZE),A2,L	;A2 ISIZE
	addk	3,A2		;ADJUST HOR SIZE FOR MORSEL
	srl	2,A2
	sll	2,A2
	MOVE	*A1(ISAG),A3,L	;GET TOP LEFT SAG (here to use hidden cycles)
	clr	A5
	movx	A2,A5
	sll	3,A5		;A5 = IMAGE WIDTH IN BITS
	;HORIZONTAL FLIP CASE
	btst	B_FLIPH,A4
	jrz	SkSagHN		;NO H FLIP, TRY VERT FLIP
SagHN	;FIX SAG FOR HFLIP
	add	A5,A3		;ADD THS-1 TO SAG
	subk	8,A3
	;FIX OFFSET FOR HFLIP
	move	A5,A14		;A5=THS*8, 2*THS-1 TO OFFSET
	subk	4,A14
	sll	14,A14		;ADJUST FOR B16-31
	addxy	A14,A4
SkSagHN

*VERTICAL FLIP CASE
	btst	B_FLIPV,A4
	jrz	SkSagVN		;NO VERT FLIP
	;FIX SAG FOR VFLIP
	movy	A2,A14		;GET HEIGHT
	srl	16,A14
	dec	A14		;FIRST ENTRY LAST ROW
	mpyu	A14,A5		;THS*(TVS-1)
	add	A5,A3		;ADD TO SAG
	;FIX OFFSET FOR VFLIP
	movx	A2,A5
	sll	17,A5		;*2, offset in top 16 of A4
	subxy	A5,A4		;offset -= 2*THS
SkSagVN	move	A8,A14
	addi	OFLAGS+080h,A14
	mmtm	A14,A1,A2,A3,A4 ;IMG,SIZE,SAG,FLAGS
	mmfm	SP,A2,A3,A5
	rets
**************************************************************************

**************************************************************************
* SETANIOF
* A0 obj
* SETS OANIOFF FIELD BASED ON OIMG FIELD AND CURRENT FLIP BITS
* SETANIOF0
* INSTEAD OF LOADING IANIOFF FROM *A0(OIMG), ASSUMES 0
SETANIOF0
;* ENTRY POINT FOR OBJS WITHOUT AN ANIMATION POINT
	mmtm	SP,A4,A5,A6
	move	*A0(OIMG),A14,L
	clr	A5			;NO ANI OFFSET
	jruc	aniofe
SETANIOF
;**** SET OANIOFF FIELD OF OBJECT IN A0 ****
	mmtm	SP,A4,A5,A6
	move	*A0(OIMG),A14,L
	move	*A14(IANIOFF),A5,L	;A5 = X COMPONENT OF IANIOFF
aniofe	move	A5,A6			;A6 = Y COMPONENT OF IANIOFF
	move	*A0(OFLAGS),A4,W
	move	*A14(ISIZE),A14,L	;A14 ISIZE
	addk	3,A14		;ADJUST HOR SIZE FOR MORSEL
	srl	2,A14
	sll	2,A14
	btst	B_FLIPH,A4
        jrz	SkSAHF
	;ADJUST X COMPONENT OF ANIOFF
	subxy	A14,A5		;bottom 16 of A14 has X SIZE
	sext	A5
	neg	A5
	dec	A5		;SUB THS-1 FROM ANIOFFX FOR H-FLIP
SkSAHF	btst	B_FLIPV,A4
	jrz	SkSAVF
	;ADJUST Y COMPONENT OF ANIOFF
	neg	A6
	addxy	A14,A6		;SUB TVS-1 FOR V-FLIP
	subi	010000h,A6
SkSAVF	movy	A6,A5		;A5 = OANIOFF
	move	A5,*A0(OANIOFF),L
	mmfm	SP,A4,A5,A6
	rets
