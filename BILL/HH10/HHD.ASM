	.MLIB	"HHMACS.LIB"
	.FILE	"HHD.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

**************************************************************************
*								         *
* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		 *
* 		       ALL RIGHTS RESERVED.				 *
*								         *
**************************************************************************

	.include	"HH.INC"
	.include	"HHRINK.TBL"
	.include	"hhd.e"
	.include	"hhram.g"
	.include	"hhc.g"
	.include	"hhpall.g"
	.include	"hhproc.g"
	.include	"hhutil.g"
	.include	"hhmisc.g"
	.include	"hhtables.g"
	.include	"hhpuck.g"

; end of include files


	.bss	rink_on,16
		
;
*	GLOBAL VARIABLES
*
	.sect	"OFIXED"


FGLIST
	.long	0,0
FGLISTX

BGLISTSX

;# OF ENTRIES MUST = 2**#bits of SUPP field in OID
SUPPLSTS
	.long	0,0,0,0,0,0,0,0
	.long	0,0,0,0,0,0,0,0
	.long	0,0,0,0,0,0,0,0
	.long	0,0,0,0,0,0,0,0
SUPPLSTSX

OFREE		.long	0	;LIST OF FREE OBJECTS
ENDOFREE	.long	0	;PTR TO LAST OBJ ON FREE LIST
ANIOBJS		.long	0	;LIST OF OBJECTS for ANIM PROCESS
	.BSS	ANIFUNCS,040h*NOBJ+020h,1 ;list of ANIM FUNCTIONS TO BE CALLED
					;+020h for list terminating 0
	.BSS	ANIFUNCSX,0


	.IF DEBUG
	.def	CPUCHK1,CPUCHK2,CPUCHK3,CPUCHK4,CPUCHK5
	.def	CLIPTIM,VELTIM,SCALETIM,PROCTIM
	.ENDIF
*
	.bss	DMATMP,16		; VLINE at which DMA is done for frame
	.bss	DMALFT,16		; % of DMA TIME left (0-1000)
	.bss	DMAAVG,16		; Average % DMA TIME left
	.bss	xxxx2,16		;fill space to 32 bits
	.IF DEBUG
	.bss	CLIPTIM,16 		; % of screen time for clip loop
	.bss	VELTIM,16		; % of screen time for vel loop
	.bss	SCALETIM,16		; % of screen time for scale
	.bss	PROCTIM,16		; % of screen time for processes
	.bss	CPUCHK1,16		; VLINE @ start of clip
	.bss	CPUCHK2,16		; VLINE @ end of clip/start of VELADD
	.bss	CPUCHK3,16		; VLINE @ end of VELADD
	.bss	CPUCHK4,16		; VLINE @ start of SCALE_MAMA
	.bss	CPUCHK5,16		; VLINE @ end of SCALE_MAMA
	.bss	xxxx3,16		;fill space to 32 bits
	.ENDIF
	.BSS	SCROLLX,32		;X SCROLL VALUE
	.BSS	SCROLLY,32		;Y SCROLL VALUE
	.BSS	WORLDX,32		;world coordinates
	.BSS	WORLDY,32		;world coordinates
	.BSS	SCRNTL,32		;TOP LEFT [Y,X] SCREEN (SCRN COORD.)
	.BSS	SCRNBR,32		;LOWER RIGHT [Y,X] SCREEN (SCRN COORD.)
	.BSS	OFREECNT,16		;# objects on free list
	.bss	xxxx4,16		;fill space to 32 bits
  	.BSS	OBJSTR,NOBJ*OBSIZ	;OBJECT SPACE START
	.BSS	OBJSTRX,0		;OBJECT SPACE END
	.BSS	DMAQCUR,32		;CURRENT DMAQ
QSIZE	.SET	NOBJ*BQCELL		;SIZE OF A QUEUE
	.BSS	DMAQ,QSIZE		;MISC. NON-SYNC DMA QUEUE
	.BSS	QDMAFLG,16		;SPECIAL DMAQ BEING UPDATED=1
	.BSS	DISPLAYON,16		;DO DISPLAY PROCESSING WHEN != 0
  	.BSS	DMAIQSTR,(NOBJ+300)*6*020h	;SPACE TO STORE DMAINT Q
	.BSS	DMAIQBOT,0		;
  	.BSS	DMAIQSTR2,(NOBJ+300)*6*020h	;SPACE TO STORE DMAINT Q
	.BSS	DMAIQBOT2,0		;
  	.BSS	DMAIQACT,32		;ACTIVE DMA Q

	.BSS	INVELADD,16		;we're VELADDing or we just did
	.bss	xxxx5,16			;pad to 32 bits
*LOCAL VARS

	.text

**************************************************************************
CLRDMAQ
	;*** GET STUFF READY FOR DMAINTS ***
	PUSHST
	DINT
	movi	DMAREGS,B11
	movi	DMAIQBOT2,B13	;DMAQTL Assume Q2
	MOVE	@DMAIQACT,B12,L	;DMAQHD
	CMPI	DMAIQBOT,B12
	JRHI	DIS_THE_INT
	movi	DMAIQBOT,B13	;DMAQTL
DIS_THE_INT
	setf	1,0,0
	clr	B14
	move	B14,@(INTENB+B_X1E),0	;disable interrupt no that we're done
	POPST
	rets

**************************************************************************
*								         *
*  DISPLAY								 *
* 									 *
* 	DO MANUAL DMAs							 *
* 	PLOT ROAD							 *
*  	ADD VELOCITIES, GRAVITY						 *
* 	DISPLAY THE FOREGROUND & BACKGROUND PLANES			 *
* 									 *
* 	CALLED AT END OF SCREEN INTERRUPT				 *
* 									 *
* NOTE: IT IS ASSUMED THAT THE DMA IS STOPPED UPON ENTRY		 *
* 									 *
* DOUBLE NOTE: A14 IS USED THROUGHOUT THIS ROUTINE AS SCREEN TOP/LEFT,	 *
* 		THEREFORE, DO NOT USE MACROS THAT TRASH A14!!		 *
*								         *
**************************************************************************
DISPLAY:
	MOVE	@DISPLAYON,A0,W
	JREQ	DISPX	;BR = STOP ALL NEW DISPLAY PROCESSING

	callr	CLRDMAQ

	MOVE	@SCRNTL,A14,L	;GET SCREEN BOUNDARIES
	MOVE	@SCRNBR,A13,L	;THESE MUST STAY VALID FROM HERE THRU CLIP

	movi	DMAGOREG,B1
*
* Dump the MANUAL DMA Queue.  The DMA clip window will be opened all of
* the way.  Therefore these DMAs do not heed the normal	object world
* constraints.
*
	MOVE	@QDMAFLG,A2		;Q BEING MODIFIED?
	JRNE	DISPMANX		;YES, DON'T SCREW WITH IT
	MOVE	@DMAQCUR,A8,L
	MOVI	DMAQ+QSIZE,A1
	CMP	A1,A8			;ANYTHING IN THE QUEUE?
	JREQ	DISPMANX		;NONE
	MOVE	A1,@DMAQCUR,L		;RESET TOP OF QUEUE
	MOVI	[2*SCRHGHT,0],A2
 	MOVE	A2,@DMAWINDOW,L		;FULL HEIGHT WINDOW
 	MOVE	@DMACFIGCOPY,A2,L	; XUNIT
 	ANDNI	DMAWIN,A2
 	MOVE	A2,@DMACONFIG,L		; XUNIT CONFIGURE DMA TO ADJUST WINDOW WIDTH
	MOVI	[511,SCRLFT],A0
	MOVE	A0,@DMAWINDOW,L		;FULL WIDTH
	ORI	DMAWIN,A2
	MOVE	A2,@DMACONFIG,L		; XUNIT LEAVE CONFIG'D FOR TOP/BOT ADJUSTMENT
DMANLP	subi	32*6,A1
	move	A1,A0
	mmfm	A0,A9,A6,A5,A4,A3,A2
	movi	DMAREGS,A7
	;*** WAIT FOR DMA NOT BUSY ***
DMAWT1	MOVE	*B1,B14,L	;DMA BUSY?
	JRN	DMAWT1		;BR = YES
	;STUFF DMA REGS
	mmtm	A7,A2,A3,A4,A5,A6,A9
				;A2  Y-SCALE:X-SCALE
				;A3  CONST:PALETTE
				;A4  Y-SIZE:X-SIZE
				;A5  DAG
				;A6  SAG
				;A9 CONTROL:OFFSET
DMAWT2	MOVE	*B1,B14,L	;DMA BUSY?
	JRN	DMAWT2		;BR = YES
	CMP	A8,A1		;HAVE WE EMPTIED THE QUEUE?
	JRHI	DMANLP		;BR = NO, LET'S DO SOME MORE
DISPMANX

	MOVE	@PAUSE_GAME,A0,W	;ARE WE IN PAUSE MODE?
	JRNZ	SkSCROLL
	move	@SCROLLX,A0,L		;ADJUST WORLD COORS FOR SCROLL
	move	@WORLDX,A1,L
	add	A0,A1
	move	A1,@WORLDX,L
	move	@SCROLLY,A0,L
	move	@WORLDY,A1,L
	add	A0,A1
	move	A1,@WORLDY,L
SkSCROLL

;*SET THE DMA WINDOW FOR OBJECT CLIPPING
	MOVE	A14,A0			;GET THE SCREEN WINDOW TOP
	SRL	16,A0			;POSITION IT PROPERLY
	MOVY	A13,A0			;GET THE SCREEN WINDOW BOTTOM Y
	move	@PAGE,A7,W
	jrz	DISP_DMA_WIN
	ADDI	[SCRHGHT,SCRHGHT],A0
DISP_DMA_WIN
	MOVE	A0,@DMAWINDOW,L		;SET WORLD HEIGHT
	MOVE	@DMACFIGCOPY,A7,L
	ANDNI	DMAWIN,A7
	MOVE	A7,@DMACONFIG,L		;CONFIGURE DMA TO ADJUST WINDOW WIDTH
	movi	[511,0],a0
	move	a0,@DMAWINDOW,L
	ORI	DMAWIN,A7
	MOVE	A7,@DMACONFIG,L		;LEAVE CONFIG'D FOR TOP/BOT ADJUSTMENT
	MOVE	@SKIPDISP,A0,W		;IS THE DISPLAY TURNED OFF?
	jrnz	DISPX			;BR = YES


	callr	do_rink		;**** NOTE also does veladd ****
	callr	SCALE_MAMA	;mdp note: scale mama is here instead of hhc so we
				;no longer run extra frame behind (slower this way)
	callr	shift_shadows

***	MOVE	@SCRNTL,A14,L		;GET SCREEN BOUNDARIES
***	MOVE	@SCRNBR,A13,L
	move	@PAGEADDR,A5,L
	movi	SCREEN_WIDTH-1,B10	; for DCLIP_MIRROR
;	MOVI	BOGUS_SCL,B6		;This means scale_mama didn't do it (not needed with moved scale_mama)
	MOVE	@SCRNTL,A14,L	;GET SCREEN BOUNDARIES
	movi	DMAGOREG,b1
	jauc	PutPlanes
DISPX	rets

;	.IF DEBUG
;	move	@VCOUNT,@CPUCHK1
;	.ENDIF

**************************************************************************
*								         *
* 3D SYSTEM FOR RINK PERSPECTIVE					 *
* 									 *
* constants that determine rink size/shape				 *
* 	h  = height of observer (in pixels)	(579)			 *
* 	d1 = distance of observer from screen	(1379)			 *
* 									 *
* coordinate transformation						 *
* 	yn = y0-worldy-(z0*h)/(d1+z0)+HALFY	;z maps to y		 *
* 	sc = d1/(d1+z0)			;scale based on z0		 *
* 	ds = ((d1+z0)/d1)*100h		;dma scale is (inverse of scale) *
* 					; * 100h			 *
* 	xn = ((x0-worldx)*sc)+HALFX	;x maps to distance from center	 *
* 					 * scale			 *
* rink formulas								 *
* 	for each line going up						 *
* 	 dagadd = -(x0-worldx))/h					 *
*								         *
**************************************************************************

**************************************************************************
*								         *
* do_rink	 - dma's out the data for rink based on world coordinate *
* 	goes line by line from bottom to top				 *
* 	DAG is bottom left corner of rink (in WORLDXY)			 *
* 	SAG is beginning of binary load + 350*8 (half image - half scree *
*								         *
**************************************************************************

RINK_X	.set	[0,08000h]
RINK_Y	.set	0

	.if	two_line_rink

do_rink
	mmtm	sp,a14
	move	@rink_on,b4,W
	jrz	pw_exit
	movi	DMAGOREG,b4
	movi	01000100h,a2		;scale 100%
	move	@PAGEADDR,a9,L		;page a9
	movi	[1,400],a4
	movk	1,b3			;for dmaint enable
	movi	(INTENB+B_X1E),b8	;to enable dmaint
	movi	HALF1+(798*8-HALFX*8),a10		;sag over (1596 / 2) - 199
	move	@WORLDX,a0,L
	cmpi	[-224,0],a0
	jrlt	dr_got
	movi	HALF2+(798*8-HALFX*8)-736*8,a10		;sag over (1596 / 2) - 199
	cmpi	[224,0],a0
	jrgt	dr_got
	movi	HALF12+(798*8-HALFX*8)-368*8,a10	;sag over (1596 / 2) - 199
dr_got	movi	860*8,a11
	movi	00202h,a14		;rink palette
	movi	RINK_X,a8
	movi	RINK_Y,a5
	sub	a0,a8			;dag incr amount =-xoff/H
	clr	a1
	sub	a8,a1
	movi	579,a0			;579, 682, 480 = H
	divs	a0,a1			;a1 = incr amount
	move	@WORLDY,a0,L
	sub	a0,a5
	sra	16,a5
	addi	HALFY,a5
	movi	192,b6			;192 lines
	move	a5,b14			;if #lines > (dag+1)
	inc	b14			; .
	cmp	b14,b6			; .
	jrle	pwsd2			;br= #lines <= (dag+1)
	move	b14,b6			; if #lines > (dag+1) then #lines <- (dag+1)
	cmpi	1,b6
	jrlt	pw_exit			;br=nothing to do, exit
pwsd2	cmpi	SCRBOT,a5		;if dag > screen bottom
	jrls	pwsd3			;br= not off bottom
	move	a5,b14			;move dag to b's
	subi	SCRBOT,b14		;loop count = dag-screenbottom
pwsdl	add	a11,a10			;run through loop adding SAG amount
	add	a1,a8			; and add incr amount
	dsjs	b14,pwsdl		; (loop is so we can change sag amount per line)
	move	a5,b14			;dag to b's
	sub	b14,b6			;#lines = #lines - dag + screen bottom
	addi	SCRBOT,b6		; .
	cmpi	1,b6
	jrlt	pw_exit			;br=nothing to do, exit
	movi	SCRBOT,a5		;dag = screen bottom
pwsd3	move	a14,a3
	sll	16,a5
	addxy	a9,a5
	movk	2,a9
	sll	16,a9			;[1,0]
	setf	1,0,1
***	send dummy clear line so we don't check again
	move	b11,a7		;dmaregs
	movi	080000000h,a14		;control/offset clear line
	mmtm	a7,a2,a3,a4,a5,a6,a14
		;a2 = scale	;a3 = const/palette	;a4 = size
		;a5 = dag	;a6 = sag	;a14 = control/offset
	move	b3,*b8,1		;**** ENABLE DMAINT ****
	movi	080220000h,a14		;control/offset correct
	movi	2,a4
	sll	16,a4
	inc	b6		;inc it so divide by two, can round up
	srl	1,b6
	movi	400,a12
	move	b12,a7		;
	move	b6,b5		;
	sll	6,b5		; move b12 ahead of all of our moves, save two cycles per loop
	sub	b5,b12		; we can do this because we are still dmaing out blank line
	sll	1,b5		;
	sub	b5,b12		;
pw_f2	move	a10,a6			;sag of start
	move	a8,a0
	sra	16,a0			;subtract 8 times dots over from sag
	sll	3,a0
	sub	a0,a6			;move sag
	add	a1,a8			;come back from clip, get next x dag
	add	a11,a10			;next line
	move	a8,a13
	sra	16,a13
	sll	3,a13
	neg	a13
	add	a10,a13
	sub	a6,a13
	srl	3,a13
	movx	a13,a4		;width	;width = (dag2 - dag1)/8
	movx	a13,a14
	sub	a12,a14		;offset	;offset = width - 400
	mmtm	a7,a2,a3,a4,a5,a6,a14
	add	a1,a8			;come back from clip, get next x dag
	add	a11,a10			;next line
	sub	a9,a5
	dsjs	b6,pw_f2		;repeat til image is done
	setf	32,1,1			;long word
pw_exit	mmfm	sp,a14

	.else

do_rink
	mmtm	sp,a14
	move	@rink_on,b4,W
	jrz	pw_exit
	movi	DMAGOREG,b4
	movi	01000100h,a2		;scale 100%
	move	@PAGEADDR,a9,L		;page a9
	movi	[1,400],a4
	movk	1,b3			;for dmaint enable
	movi	(INTENB+B_X1E),b8	;to enable dmaint
	movi	RINK+(798*8-HALFX*8),a10	;sag over (1596 / 2) - 199
	movi	1596*8,a11		;offset to add to get next line sag
	movi	00202h,a14		;rink palette
	movi	RINK_X,a8
	movi	RINK_Y,a5
	move	@WORLDX,a0,L
	sub	a0,a8			;dag incr amount =-xoff/H
	clr	a1
	sub	a8,a1
	.if	XUNIT=1
	movi	764,a0			;579, 682, 480 = H
	.else
	movi	579,a0
	.endif
	divs	a0,a1			;a1 = incr amount
	move	@WORLDY,a0,L
	sub	a0,a5
	sra	16,a5
	addi	HALFY,a5
	movi	192,b6			;192 lines
	move	a5,b14			;if #lines > (dag+1)
	inc	b14			; .
	cmp	b14,b6			; .
	jrle	pwsd2			;br= #lines <= (dag+1)
	move	b14,b6			; if #lines > (dag+1) then #lines <- (dag+1)
	cmpi	1,b6
	jrlt	pw_exit			;br=nothing to do, exit
pwsd2	cmpi	SCRBOT,a5		;if dag > screen bottom
	jrls	pwsd3			;br= not off bottom
	move	a5,b14			;move dag to b's
	subi	SCRBOT,b14		;loop count = dag-screenbottom
pwsdl	add	a11,a10			;run through loop adding SAG amount
	add	a1,a8			; and add incr amount
	dsjs	b14,pwsdl		; (loop is so we can change sag amount per line)
	move	a5,b14			;dag to b's
	sub	b14,b6			;#lines = #lines - dag + screen bottom
	addi	SCRBOT,b6		; .
	cmpi	1,b6
	jrlt	pw_exit			;br=nothing to do, exit
	movi	SCRBOT,a5		;dag = screen bottom
pwsd3	move	a14,a3
	sll	16,a5
	addxy	a9,a5
	movk	1,a9
	sll	16,a9			;[1,0]
	setf	1,0,1
***	send dummy clear line so we don't check again
	move	b11,a7		;dmaregs
	movi	080000000h,a14		;control/offset clear line
	mmtm	a7,a2,a3,a4,a5,a6,a14
		;a2 = scale	;a3 = const/palette	;a4 = size
		;a5 = dag	;a6 = sag	;a14 = control/offset
	move	b3,*b8,1		;**** ENABLE DMAINT ****
	movi	080220000h,a14		;control/offset correct
	move	b12,a7		;
	move	b6,b5		;
	sll	6,b5		; move b12 ahead of all of our moves, save two cycles per loop
	sub	b5,b12		; we can do this because we are still dmaing out blank line
	sll	1,b5		;
	sub	b5,b12		;
pw_f2	move	a10,a6			;sag of start
	move	a8,a0
	sra	16,a0			;subtract 8 times dots over from sag
	sll	3,a0
	sub	a0,a6			;move sag
	mmtm	a7,a2,a3,a4,a5,a6,a14
	add	a1,a8			;come back from clip, get next x dag
	add	a11,a10			;next line
	sub	a9,a5
	dsjs	b6,pw_f2		;repeat til image is done
	setf	32,1,1			;long word
pw_exit	mmfm	sp,a14

	.endif

	;fall through to veladd

**************************************************************************
*								         *
* VELOCITY ADD AND SCREEN BOUNDARY CHECK				 *
* 									 *
* 	a0  = Obj Block							 *
* 	a2  = End of Obj List						 *
* 	a3  = scratch							 *
* 	a4  = ZMAX_REAL-800h (univ)					 *
* 	a5  = XBASE							 *
* 	a6  = M_OFSCRN (const)						 *
* 	a7  = Multi part obj block					 *
* 	a8  = ZPOS							 *
* 	a9  = YPOS							 *
* 	a10 = XPOS							 *
* 	a11 = YVEL							 *
* 	a12 = XVEL							 *
* 	a13 = ZVEL							 *
* 	a14 = OFLAGS							 *
*								         *
* 	B0  = PRIMARY X LEFT SHIFT VALUE FOR UNIVERSE CHECK		 *
* 	B1  = PRIMARY Y LEFT SHIFT VALUE FOR UNIVERSE CHECK		 *
* 	B2  = SCRATCH							 *
* 	B4  = SCRATCH							 *
* 	b5  =   avail							 *
* 	B6  = SCRATCH							 *
* 	B7  = SECONDARY X LEFT SHIFT VALUE FOR UNIVERSE CHECK		 *
* 	B8  = SECONDARY Y LEFT SHIFT VALUE FOR UNIVERSE CHECK		 *
* 	B9  = YBASE							 *
* 	B14 = SCRATCH							 *
*								         *
**************************************************************************
VELADD
vf0 	MOVE	@PAUSE_GAME,A14,W	;ARE WE IN PAUSE MODE?
	JRNZ	vaddx
	MOVK	1,A14
	MOVE	A14,@INVELADD,W		;we're VELADDing
	MOVI	FGLIST,A0
	move	a0,a2
	movi	M_OFSCRN,a6
	movi	M_FVELADD,a1
	movi	OZVEL,a7		;const in add below
	jruc	VADD

	.align

*LOAD A13:OZVEL, A12:OXVEL, A11:0YVEL, A10:OXPOS, A9:OYPOS, A8:OZPOS
DVEL	move	a0,a3			;get obj base in A3 for pull of vals
	add	a7,a3			;add in OZVEL
	move	*a0(OFLAGS),a14,W
	andn	a6,a14		; Assume onscreen first
	mmfm	a3,a8,a9,a10,a11,a12,a13
	btst	B_FVELADD,a14	;do we add this frame?
	jrnz	vaddnok
	add	a13,a8		;add z velocity to zval
	add	a12,a10		;add x velocity to xval
	add	a11,a9		;add y velocity to yval
	mmtm	a3,a8,a9,a10
skyvad0	move	a14,*a0(OFLAGS),W
	btst	B_SCRNOBJ,a14
	jrz	notscrn
	srl	16,a10
	movy	a9,a10
	move	a10,*a0(ODAG),L
notscrn	move	*a0(OYACCEL),a3,W
	jrnz	dograv
gravb
VADD	move  	*a0,a0,L     	;GET NEXT ONE FOLKS
	cmp	a0,a2
	jrnz  	DVEL
vaddx	rets

vaddnok	andn	a1,a14		;turn bit off now
	jruc	skyvad0		;and skip vadd

dograv	add	A3,A11
	move	A11,*A0(OYVEL),L
	jruc	gravb

	.text

**************************************************************************
*								         *
* SCALE_MAMA - compute scale factor algorithmically	, then Scrn Pos  *
*								         *
**************************************************************************
*
*	a0 = obj
*	a1 = scratch
*	a2 = new YSCALE
*	a3 = 10000h for inverse scale computation
*		B3 = OZVAL
*	a4 = start of FGLIST
*	a5 = SCRN TL
*		B5 = OYVAL
*	a6 = new XSCALE
*	a7 =
*		B7 = OXVAL
*		B8 = XBASE
*	a8 = OFLAGS
* 	a9 = scratch, then ODAG
*		B10 = YBASE
*	a11 = scratch
* 	a12 = Scrn BR
*	a13 = inverse scale
*	a14 = IHDRSIZ

SCALE_MAMA
	MOVI	FGLIST,A0
	MOVE	A0,A4
	movi	invscale_table,a3
	movi	OXVAL,B0
	movi	HALFX,B4
	MOVI	HALFY,B6
	movi	10001h,a10	;for flips
	movi	M_OFSCRN,a14
	move	@WORLDX,b8,L
	move	@WORLDY,b10,L
	MOVE	@SCRNTL,A5,L	;GET SCREEN BOUNDARIES
	MOVE	@SCRNBR,A12,L	; FOR OFSCRN COMPUTATION in COMP_SCRN_POS
	JRUC	SCL_NXT_OBJ
	.align
SCALE_LP
	MOVE	*A0(OFLAGS),A8,W
	btst	B_OFSCRN,a8	; if OFSCRN, do not scale or compute DEST
	jrnz	SCL_NXT_OBJ
	BTST	B_SCRNOBJ,A8
	JRNZ	SCL_NXT_OBJ
	move	A0,B1		;get obj base in b1 for pull of vals
	add	B0,B1		; offset by OXVAL
	MMFM	B1,B3,B5,B7	;LOAD B7:OXPOS, B5:OYPOS, B3:OZPOS
	MOVE	*A0(OSCALE),A7,L	 ; previous scale in a7
	BTST	B_NOSCALE,A8
	JRNZ	KEEP_OLD_SCALE
	BTST	B_MANSCALE,A8
	JRZ	SkpSclLod
	ORI	M_NOSCALE,a8	; reset rescale signal
	move	a8,*a0(OFLAGS)
	move	*a0(ONuManScl),a6
	clr	a7		; force new scale
	jruc	ManScaleSt

SkpSclLod:
	move	B3,a6		; save ZPOS for DAG computation
	sra	16,a6
	sll	5,a6
	move	*a0(OSCTAB),a11,L
	add	a11,a6
	move	*a6,a6,L
ManScaleSt:
ChkNxtScl:
	cmp	a6,a7		 ; new X scale in a6
	JRNE	DO_NEW_SCALE
KEEP_OLD_SCALE
	MOVE	*A0(OSIZE),a9,L
	MOVE	*A0(OANIOFF),a1,L
	JRUC	COMP_SCRN_POS

DO_NEW_SCALE
	MOVE	A6,*A0(OSCALE),L
	MOVE	*A0(OUSIZE),A9,L	;Unscaled size in a1
	MOVE	*A0(OUANIOFF),A1,L	;Unscaled animation pnt in A1
	move	a6,a7
	srl	16,a7
	sll	4,a7
	add	a3,a7
	move	*a7,a13,W
	sll	16,a6
	srl	12,a6
	add	a3,a6
	move	*a6,a7,W		;fake some divides
NORMAL_SCALE
	setf	12,1,1		; change FS1 to quicken multiplies
	clr	a11
	movx	A9,a11
	mpyu	A7,A11		  ; result in a11
	srl	8,a11
	srl	8,A9
	mpyu	a13,A9
	movx	a11,A9
	move	A1,A11
	sext	a11
	mpys	A7,A11		  ; result in a11
	sra	8,a11
	sra	16,A1
	mpys	a13,A1
NORMAL_SCALE_FINISH
	sll	8,A1
	movx	a11,A1
	setf	32,0,1		; restore FS1	 !!!
	MOVE	A1,*A0(OANIOFF),L
	MOVE	A9,*A0(OSIZE),L
nochg
;	ANIOFF is in A1
;	SIZE is in a9

COMP_SCRN_POS	   		; Compute Screen Position
	sub	B8,B7	       	; Universe to World X
	sub	B10,B5	       	; Universe to World Y

;b3 = z,  b7 = xoff, b5 = yoff
	sra	16,b5
	sra	16,b3
	sll	4,b3
	addi	zybase_table,b3
	move	*b3,b14
	sub	b14,b5
	add	b6,b5
	sll	16,b5
	sra	14,b7		;shift xval down 14 bits
	addi	xzy_offset,b3
	move	*b3,b14		;get scale of x
	mpys	b14,b7		;multiply scale * x
	sra	16,b7		;move x to lower halh
	add	b4,b7
	move	b7,b9
	movy	b5,b9

;	ANIOFF is in A1
;	SIZE is in a9
;
;BIG NOTE: On 10/6/93 A slight change was made that requires
;		A1 to be ANIOFF and A9 to be OSIZE at this point.

	sub	a10,a9		;a10 = 10001
	move	a9,a7		; save for ofscrn check  12/22/93
	subxy	a1,a9		; adjusted anioff in a9
	move	*a0(OCTRL),a6
	btst	B_FLIPH,a6
	jrz	noh
	movx	a9,a1
noh:	btst	B_FLIPV,a6
	jrz	nov
	movy	a9,a1
nov:	move	b9,a9
	subxy	a1,a9
	move	a9,*a0(ODAG),L		; save DAG for Clipping computation
	CMPXY	A12,A9			; IS IT LOWER THAN LOWER RT?
	JRYGE	offs			; LOWER
	JRXGE	offs			; TO THE RIGHT
	addxy	a9,a7			; get lower right of obj in a7
	CMPXY	A5,A7
	JRYLE	offs			;ABOVE...
	JRXLE	offs			;TO THE LEFT..

SCL_NXT_OBJ:
	MOVE	*a0,a0,L		; save a word MOVE *A0(OLINK),A0,L
	CMP	A0,A4
	JRNE	SCALE_LP
	RETS

offs	or	a14,a8		;m_ofscrn
	move	a8,*a0(OFLAGS)
	jruc	SCL_NXT_OBJ

shift_shadows
	move	@SUPPLSTS+2*20h,a8,L		;supplst2
	jrz	sshd_9
	movk	1,a1
	move	@WAVEIRQS,a0,L
	sra	1,a0
	jrc	ssh_2
ssh_1	move	*a8(ODAGX),a0,W
	andn	a1,a0
	move	a0,*a8(ODAGX),W
	move	*a8(OSLINK),a8,L
	jrnz	ssh_1
	rets
ssh_2	move	*a8(ODAGX),a0,W
	or	a1,a0
	move	a0,*a8(ODAGX),W
	move	*a8(OSLINK),a8,L
	jrnz	ssh_2
sshd_9	rets

;OB_GUNV	.set	0
OB_COLL		.set	1
OB_ANIM		.set	2
OB_CFUNC	.set	3
OB_POS		.set	4
;OB_WPOS	.set	5
;OB_SPOS	.set	6
;OB_GRND	.set	7
OB_OID		.set	8
OB_DUMCOLL	.set	9
OB_PRVANIM	.set	10
OB_INSERT	.set	11
OB_OPARTS	.set	12
OB_SCTAB	.set	13

****************************************************************************
*    The  "NEW"  MULTIMAKE
*
*    Uses a Create Script to allocate and initialize obj(s)
*
*    B0 = ptr to Create Script w/ following format
*
*        .byte OBJCNT, PRCCNT, IMGPALCNT, PALCNT
*             PRCCNT must be >= # of procs that will be allocated in CFUNCS
*     FOR each IMGPALCNT...
*        .long IMG->PAL        ;PAL TO BE FOUND OR HAVE AVAILABLE SLOT FOR
*     FOR each PALCNT...
*        .long PAL                ;PAL TO BE FOUND OR HAVE AVAILABLE SLOT FOR
*        .word OID, GLOBAL_OPTIONS (OM_COLL | OM_DUMCOLL,
*                                   OM_POS ,OM_SCTAB
*                                   OM_INSERT )
*
*                   OM_COLL  to supply a default coll vector for all objects.
*                                otherwise, 0 is used.)
*                   OM_POS  if you want to supply a position (universe default).
*                   OM_DUMCOLL to use DUMCOLL as the default collision vector.
*                   OM_INSERT  to call INSERT_OBJ when completed
*		    OM_SCTAB   to specify a scale table
*        		(not implemented yet)
*     FOR each OBJCNT...
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS
*               (OM_OID, OM_OPARTS, OM_COLL, OM_GUNV, OM_ANIM,
*                OM_PRVANIM, OM_PRVGUNV, OM_CFUNC)
*
*                OM_OID requires a word to follow the option word.
*		 OM_OPARTS requires 2 words to follow (OPARTSX and Y)
*                OM_COLL, OM_GUNV, OM_ANIM, OM_CFUNC require a long word
*                         to follow the option word.
*                OM_PRVANIM requires that a previous object had OM_ANIM set.
*                OM_PRVGUNV requires that a previous GUN vect had OM_GUNV set.
*
*        NOTE:  DATA WHICH FOLLOWS THE OPTION WORD MUST APPEAR IN THE CORRECT
*               ORDER! (namely, OID, COLL, GUNV, ANIM, xPOS, SCTAB CFUNC)
*
* MULTIMAKE automatically links all objs together as multi-parter w/
* 1st obj as head obj
*
* A10-A11 passed to each PROC created unless they are modified by CFUNCS
*
* RETURNS
*   A8 = ptr to head obj of uninserted multi-parter.
*   Immediately follow with INSERT_OBJ to insert.
*   Zflag set if not enough OBJS, PROCS or PALS
* !!!!!!!!  assume ALL REGS (A&B) TRASHED but A9,A10,A11,A12,A13  !!!!!!!!!
*
*
* CFUNC - Create Functions
*   A0 = new obj , initialized and linked into MULTI-PARTER
*   A8 = ptr to first obj of script (head of MULTI-PARTER)
*   B0 = ptr to Create Script, must adjust B0 as CFUNC parms read.
*   Can trash all A regs but A8,A9,A10,A11,A12,A13
*   Must preserve ALL BREGS except B14 and B0 which must point
*                 after CFUNC parms
*
MULTIMAKE:
	mmtm	sp,a6,a7,A9,a10,a11
	clr	A8			;First Obj

	;*** CHECK OBJCNT
	movb	*B0,B7			;B7 # objs to allocate
	move	b7,a6
	move	@OFREECNT,a14,W
	cmp	a14,a6
	jrgt	MAKEX
	addk	8,B0

	;*** CHECK PRCCNT
	movb	*B0,B1			;B1 >= # of procs to allocate
	move	@PFREECNT,B2,W
	cmp	B2,B1
	jrgt	MAKEX
	addk	8,B0

	move	@FREEPALCNT,B3,W
	;FOR EACH PAL NOT FOUND, DEC FREEPALCNT - JRN MAKEX
	movb	*B0,B1			;IMGPALCNT
	addk	8,B0
	movb	*B0,B2			;PALCNT
	addk	8,B0

	inc	B1
ImgPalLp
	dec	B1
	jrle	SkImgPalCk
	move	*B0+,B4,L
	move	B4,A0
	move	*A0(ICMAP),A0,L
	calla	FINDPAL
	jrnz	ImgPalLp
	;*** PAL NOT FOUND ***
	dec	B3
	jrn	MAKEX
	jruc	ImgPalLp
SkImgPalCk

	inc	B2
PalLp
	dec	B2
	jrle	SkPalCk
	move	*B0+,B4,L
	move	B4,A0
	calla	FINDPAL
	jrnz	PalLp
	;*** PAL NOT FOUND ***
	dec	B3
	jrn	MAKEX
	jruc	PalLp
SkPalCk
	move	*B0+,B14,W		;Load OID
	move	b14,a11			; default OID
*
*	Process Options for All Parts of Multiparter (OID, COLL, POS)
*
	clr	b10		; default collision vector
	move	*b0+,b2		; options for all objects
	btst	OB_DUMCOLL,b2
	jrz	NxtGopt1X
	movi	DUMCOLL,b10
	jruc	NxtGopt1
NxtGopt1X:
	btst	OB_COLL,b2
	jrz	NxtGopt1
	move	*b0+,b10,L	; user-supplied default collision vector
NxtGopt1:
	btst	OB_POS,b2
	jrz	NxtGopt2
	mmfm	b0,b4,b5,b6	;b6=x,b5=y,b4=z
	srl	16,b6
	movx	b6,b5		;b5 = xy, b4 = z
NxtGopt2
	;THERE IS ENOUGH OBJS, PROCS AND PALS SO GO AHEAD AND ALLOCATE
	clr	a7		;OBJECT #
MkObjLp
	inc	a7
	move	*B0+,B1,L
	move	B1,A1
	callr	GETOBJ
	callr	FPSTFOBJ0
	move	A0,B1
	movb	a7,*A0(OPARTID)		;store # of PART

	move	*B0+,B14,W		;Load OCTRL
	MOVE	*B0+,B9,W		;Load OFLAGS
	MOVE	B9,*B1(OFLAGS),W
	btst	B_FLIPH,B14
	jrnz	MkFlp
	btst	B_FLIPV,B14
	jrz	SkMkFlp
MkFlp
	move	B14,A4
	PUSH	A8
	move	A0,A8
	;A1 still set from above
	calla	ANI
	PULLQ	A8
	jruc	MkFlagsOk
SkMkFlp
	move	*B1(OCTRL),B3,W
	OR	B14,B3
	move	B3,*B1(OCTRL),W
MkFlagsOk
	clr	b3			; assume no OPARTSXY

	MOVE	*B0+,B14,W		; Load OZOFF
	MOVB	B14,*B1(OZOFF)
	sll	16,b14
	movy	b14,b2

	move	A8,A8			; is first obj in a0?
	jrnz	SkMkFirst		; jump if no
*
*	First part only (b9 = OFLAGS, b2 = GBL OPTION flgs)
*
	move	A0,A8
	jruc	SkINSPART
SkMkFirst
	MOVE	A0,*A9(OPARTS),L	;LINK NEW OBJECT AT END
SkINSPART
	MOVE	A8,*A0(OPART1),L	;VALIDATE HEAD PTR
	MOVE	A0,A9			;KEEP PREVIOUS PART FOR PART LINKUP
*
*	Process Optional parameters
*
	move	*b0+,b7		; option flags

	move	a11,a14
	btst	OB_OID,b7 		; check for:  SUPPLIED OID
	jrz	NxtOpt6			; jump if default
	move	*b0+,b14		; if not default
	move	b14,a14
NxtOpt6:
	move	a14,*a0(OID)

	clr	b3
	btst	OB_OPARTS,b7
	jrz	NxtOpt7
	move	*b0+,b3,L
	move	b3,*b1(OPARTSXY),L
NxtOpt7:
	move	b10,b14
	btst	OB_COLL,b7		; check for:  COLLISION VECTOR
	jrz	NxtOpt2			; jump if default
	move	*b0+,b14,L		; if not default
NxtOpt2:
	move	b14,*b1(OCVECT),L
NxtOpt1:				;      switched with below
	btst	OB_PRVANIM,b7		; check for:  USE PREVIOUS ANIMATION
	jrnz	prev_anim
	btst	OB_ANIM,b7		; check for:  SUPPLIED ANIMATION
	jrz	NxtOpt3
	move	*b0+,b14,L
	move	b14,a10
prev_anim:
	move	a10,a1
	callr	STRTANIM
NxtOpt3:

	btst	OB_POS,b2 		; was a position supplied?
	jrz	NxtOpt4
*
*	adjust position based on OPARTSXY (b3) and OZOFF (MSW b2)
*
	btst	B_SCRNOBJ,b9	; skip following if not screen obj
	jrz	pos_is_uni
	addxy	b3,b5			; Y:X in b5
	move	b5,b6
	move	*b1(OANIOFF),b14,L
	subxy	b14,b6
	move	b6,*b1(ODAG),L
;
;       Future note:
;       The following should save the animation point adjusted by OPARTSXY
;       (b5) as the position of a screen obj, NOT THE DAG (b6)!
;
	move	b6,*b1(OXPOS),W
	srl	16,b6
	move	b6,*b1(OYPOS),W
	jruc	do_z
pos_is_uni
oparts_is_0
nodoadj	movx	b3,b14			; OPARTS X
	sext	b14
	sll	15,b14
	add	b6,b14			; adjust X by OPARTSX
	move	b14,*b1(OXVAL),L
	move	b3,b14
	sra	16,b14			; OPARTS Y
	sll	15,b14
	add	b5,b14			; adjust Y by OPARTSY
	move	b14,*b1(OYVAL),L

do_z	movy	b2,b14
	sra	16,b14			; OZOFF
	add	b4,b14			; adjust Z by ZOFF
	move	b14,*b1(OZVAL),L

NxtOpt4:
	btst	OB_CFUNC,b7		; check for:  CREATE FUNCTION
	jrz	NxtOpt5
	move	*B0+,B7,L		; Load CFUNC
	jrz	NxtOpt5
	PUSH	A8
	call	B7			; DO CFUNC
	PULLQ	A8
NxtOpt5:

MkNxtObj
	dsj	a6,MkObjLp
	.if XUNIT=1
	CMPK	1,a7		;MORE THAN ONE OBJECT CREATED?
	.else
	cmpi	1,a7
	.endif
	JRNE	MAKEX		;BR = YES, IT IS MULTI
	CLR	A14
	MOVE	A14,*A8(OPART1),L	;MAKE IT LOOK SINGLE
MAKEX
	mmfm	sp,a6,a7,a9,a10,a11
	move	A8,A8		;Set Z Flag
	jrz	MM_ABT
        btst	OB_INSERT,b2
	jrnz	INSERT_OBJ
	inc	a14		; clr z flag
MM_ABT:
	rets

****************************************************************************
*    EASYMAKE for single part objects
*
*    Uses a Create Script to allocate and initialize obj(s)
*
*    B0 = ptr to Create Script w/ following format
*
*        .long IMG
*        .word OCTRL, OFLAGS
*        .word OPTIONS
*               (OM_OID,  OM_COLL, OM_ANIM,
*		 OM_POS, OM_GRND,
*		 OM_DUMCOLL, OM_INSERT)
*
*                OM_OID requires a word to follow the option word.
*                OM_COLL, OM_GUNV, OM_ANIM require a long word
*                         to follow the option word.
*
*  		OM_OID     to supply an OID (otherwise, OID_JUNK is used)
*               OM_COLL    to supply a coll vector.
*		OM_DUMCOLL to use DUMCOLL as a coll. vector (if neither
*			    OM_COLL or OM_DUMCOLL are specified, 0 is used.)
*               OM_ANIM    to supply an animation script.
*               OM_POS     to supply a position.
*               OM_CFUNC   to call a special function.
*               OM_INSERT  to call INSERT_OBJ when completed
*		OM_SCTAB   to specify a scale table
*
*        NOTE:  DATA WHICH FOLLOWS THE OPTION WORD MUST APPEAR IN THE CORRECT
*               ORDER! (namely, OID, POS, COLL, ANIM, SCTAB,CFUNC)
*
*
* RETURNS
*   A8 = ptr to obj
*   Immediately follow with INSERT_OBJ to insert if OM_INSERT not specified.
*
* !!!!!!!!  assume ALL B REGS TRASHED
* !!!!!!!!  also   A0, A1, and A14 TRASHED
*
* CFUNC - Create Functions
*   gets new obj in A0, it is initialized.
*   ptr to Create Script in B0, must inc B0 as CFUNC parms read.
*   Is free to trash all A regs but A8 - A13
*   Must preserve all BREGS except B14 and
*   B0 which must point after CFUNC parms
*
EASYMAKE:
	move	*B0+,B1,L	; get IMG
	move	B1,A1
	callr	GETOBJ
	jrz	EASY_ABT
	callr	FPSTFOBJ0
	mmtm	sp,a4
	move	A0,B1
	move	*B0+,B14,W		;Load OCTRL
	MOVE	*B0+,B2,W		;Load OFLAGS
	MOVE	B2,*B1(OFLAGS),W
	btst	B_FLIPH,B14
	jrnz	EMkFlp
	btst	B_FLIPV,B14
	jrz	ESkMkFlp
EMkFlp
	move	B14,A4
	move	A0,A8
	;A1 still set from above
	calla	ANI
	jruc	EMkFlagsOk
ESkMkFlp
	move	*B1(OCTRL),B3,W
	OR	B14,B3
	move	B3,*B1(OCTRL),W
EMkFlagsOk
*
*	Process Optional parameters
*
	move	*b0+,b9		; option flags

	movi	OID_JUNK,a14
	btst	OB_OID,b9 		; check for:  SUPPLIED OID
	jrz	ENxtOpt6			; jump if default
	move	*b0+,b14		; if not default
	move	b14,a14
ENxtOpt6:
	move	a14,*a0(OID)

	clr	b14
	btst	OB_DUMCOLL,b9
	jrz	ENxtOpt2A
	movi	DUMCOLL,b14
	jruc	ENxtOpt2
ENxtOpt2A:
	btst	OB_COLL,b9		; check for:  COLLISION VECTOR
	jrz	ENxtOpt2			; jump if default
	move	*b0+,b14,L		; if not default
ENxtOpt2:
	move	b14,*b1(OCVECT),L
ENxtOpt1:
	btst	OB_ANIM,b9		; check for:  SUPPLIED ANIMATION
	jrz	ENxtOpt3
	move	*b0+,b14,L
	move	b14,a1
	callr	STRTANIM
ENxtOpt3:
	btst	OB_SCTAB,b9
	jrz	ENxtOpt7
	move	*b0+,b14,L
	move	b14,a14
	move	a14,*a0(OSCTAB),L	;scale table
ENxtOpt7
	btst	OB_POS,b9 	; was a position supplied?
	jrz	ENxtOpt4

******************************
*		             *
*    Get supplied position   *
*		             *
******************************

	mmfm	b0,b4,b5,b6	;b6=x,b5=y,b4=z
	btst	B_SCRNOBJ,b2	;
	jrnz	E_do_scrnobj
world_b_free
	move	b6,*b1(OXVAL),L
	move	b5,*b1(OYVAL),L
	move	b4,*b1(OZVAL),L
	jruc	e_dont_z
E_do_scrnobj
	srl	16,b6
	movx	b6,b5
	move	*b1(OANIOFF),b14,L
	subxy	b14,b5
	move	b5,*b1(ODAG),L
	move	b5,*b1(OXPOS),W
	srl	16,b5
	move	b5,*b1(OYPOS),W
	move	b4,*b1(OZVAL),L
e_dont_z
ENxtOpt4
	btst	OB_CFUNC,b9		; check for:  CREATE FUNCTION
	jrz	ENxtOpt5
	move	*B0+,B7,L		; Load CFUNC
	jrz	ENxtOpt5
	PUSH	A0
	call	B7			; DO CFUNC
	PULLQ	A0
ENxtOpt5:
	mmfm	sp,a4

	btst	OB_INSERT,b9
	JRZ	EM_NOINSERT
	CALLR	INSOBJ
EM_NOINSERT
	MOVE	A0,A8			;Clear the Z flag
EASY_ABT
	rets

**************************************************************************
*								         *
* GET_SCALED_SIZE - RETURNS THE SCALED SIZE OF AN IMAGE.		 *
* A0 = SCALE FACTOR [Y,X]						 *
* A2 = UNSCALED SIZE [Y,X]						 *
* RETURNS								 *
* 	A6 = [Y,X] SCALED SIZE						 *
*								         *
**************************************************************************
GET_SCALED_SIZE
	PUSH	A5

	MOVX	A0,A14		;GET X-SCALE FACTOR
	SEXT	A14
	MOVX	A2,A5		;GET UNSCALED X-SIZE
	SEXT	A5
	SLL	8,A5
	DIVS	A14,A5		;(in case using for ani pts)
	MOVX	A5,A6		;SEND BACK SCALED X-SIZE

	MOVY	A0,A14		;GET Y-SCALE FACTOR
	SRA	16,A14
	MOVY	A2,A5		;GET UNSCALED Y-SIZE
	SRA	16,A5
	SLL	8,A5
	DIVS	A14,A5		;(in case using for ani pts)
	SLL	16,A5
	MOVY	A5,A6		;SEND BACK SCALED Y-SIZE

	PULLQ	A5
	RETS

**************************************************************************
*								         *
* 			MANUAL DMA ROUTINES				 *
* 			-------------------				 *
* 									 *
* 		THESE ROUTINES ARE USED TO FIRE OFF A SINGLE DMA	 *
* 		ALONG WITH THE NORMAL "OBJECTS" BEING DISPLAYED.	 *
* 		THEY ARE USED AS FOLLOWS:				 *
* 									 *
* 		QDMA (QDMA2) -						 *
* 			A1 = [CONSTANT COLOR,PALETTE]			 *
* 			A3 = DESTINATION [Y,X]				 *
* 			A5 = [CONTROL,OFFSET]				 *
* 			A14= ADDRESS OF IMAGE HEADER (THE REST OF	 *
* 				THE INFO WILL BE TAKEN FROM HERE).	 *
* 									 *
* 									 *
* 		QDMAN (QDMAN2) - 					 *
* 			A0 = SCALE [Y,X]				 *
* 			A1 = [CONSTANT COLOR,PALETTE]			 *
* 			A2 = [HEIGHT,WIDTH]				 *
* 			A3 = DESTINATION [Y,X]				 *
* 			A4 = SOURCE ADDRESS				 *
* 			A5 = [CONTROL,OFFSET]				 *
* 									 *
* 									 *
* 		NOTE: QDMA2 AND QDMAN2 DMA TWICE, ONE TO EACH DISPLAY	 *
* 			PAGE.						 *
*								         *
**************************************************************************
QDMAN	MMTM	SP,A0,A2,A3,A4,A5,A6,A13
	JRUC	QDMANE
QDMA	MMTM	SP,A0,A2,A3,A4,A5,A6,A13
	MOVI	[0100H,0100H],A0	;SCALE IS 1:1
	MOVE	*A14(ISIZE),A2,L    	;GET VSIZE:HSIZE
	MOVE	*A14(ISAG),A4,L		;GET SAG
	MOVE	*A14(ICTRL),A13,W
	SLL	16,A13
	OR	A13,A5			;OR IN THE VITAL SHIT
QDMANE	CALLR	GET_SCALED_SIZE		;GET THE SCALED SIZE FOR US
QDMANE_2
	CLR	A13
	BTST	B_FLIPH+16,A5
	JREQ	NOHF
	MOVX	A6,A13
	DEC	A13
NOHF	BTST	B_FLIPV+16,A5
	JREQ	NOVF
	MOVY	A6,A13
	SUBI	10000h,A13
NOVF	ADDXY	A13,A3
	MOVE	@PAGEADDR,A13,L		;GET THE CURRENT PAGE ADDRESS
	MOVE	@NOPGFLIP,A6,W		;IS PAGE FLIPPING ACTIVE?
	JRNZ	QD_NOPFLP		;BR = NO
	XORI	TOGGLE_PAGE_XY,A13	;XUNIT COMPENSATE FOR BEING 1 PAGE BEHIND

QD_NOPFLP
	addxy	A13,A3			;DO PAGE OFFSET
	MOVK	1,A13
	MOVE	A13,@QDMAFLG,W		;Q BEING MODIFIED
	MOVE	@DMAQCUR,A13,L
	CMPI	DMAQ,A13
	JRLS	QDMAX			;Q OVERLOAD, CAN IT
	MMTM	A13,A0,A1,A2,A3,A4,A5
	MOVE	A13,@DMAQCUR,L
QDMAX	CLR	A13
	MOVE	A13,@QDMAFLG,W
	MMFM	SP,A0,A2,A3,A4,A5,A6,A13
	RETS

**************************************************************************
*								         *
* THESE ARE THE DOUBLE-PAGE VERSIONS					 *
*								         *
**************************************************************************
QDMAN2
	MMTM	SP,A0,A2,A3,A4,A5,A6,A13
	JRUC	QDMANE2
QDMA2	MMTM	SP,A0,A2,A3,A4,A5,A6,A13
	MOVI	[0100H,0100H],A0	;SCALE IS 1:1
	MOVE	*A14(ISIZE),A2,L     	;GET VSIZE:HSIZE
	MOVE	*A14(ISAG),A4,L		;GET SAG
	MOVE	*A14(ICTRL),A13,W
	SLL	16,A13
	OR	A13,A5			;OR IN THE VITAL SHIT
QDMANE2
	CALLR	GET_SCALED_SIZE		;GET THE SCALED SIZE FOR US
QDMANE2_2
	CLR	A13
	BTST	B_FLIPH+16,A5
	JREQ	NOHF2
	MOVX	A6,A13
	DEC	A13
NOHF2	BTST	B_FLIPV+16,A5
	JREQ	NOVF2
	MOVY	A6,A13
	SUBI	10000h,A13
NOVF2	ADDXY	A13,A3
	MOVK	1,A13
	MOVE	A13,@QDMAFLG,W		;Q BEING MODIFIED
	MOVE	@DMAQCUR,A13,L
	CMPI	DMAQ,A13
	JRLS	QDMA2X			;Q OVERLOAD, CAN IT
	ADDI	PAGE0ADR,A3
	MMTM	A13,A0,A1,A2,A3,A4,A5
	;*** Q it for PAGE 2 also
	ADDI	PAGE1ADR-PAGE0ADR,A3
	CMPI	DMAQ,A13
	JRLS	QDMA2X			;Q OVERLOAD, CAN IT
	MMTM	A13,A0,A1,A2,A3,A4,A5
	MOVE	A13,@DMAQCUR,L
QDMA2X	CLR	A13
	MOVE	A13,@QDMAFLG,W
	MMFM	SP,A0,A2,A3,A4,A5,A6,A13
	RETS

**************************************************************************

	.ALIGN

**************************************************************************
* YZSORT
* SORT EACH SCREEN OBJECT LIST IN Z:Y PRIORITY
* IF OBJ DOESN'T HAVE NOAUTOZ SET, MOVE FROM LIST TO LIST BASED ON Z COOR
* CALL FROM EXEC LOOP
YZSORT:

	.IF DEBUG
	callr	CkOFREE
	callr	CkAnim
	.ENDIF

YZPlnLp
	movi	FGLIST,A10	;NEW
	move	A10,A0		;A10 START OF LIST

	;PRESTUFF Z,Y OF PREVIOUS OBJ
	MOVI	080000000H,A6	;LOWEST POSSIBLE Z
	MOVI	07FFFFFFFH,A5	;HIGHEST POSSIBLE Y
	MOVE	A5,A4
	JRUC	YZLP

YZLP0	MOVE	*A1(OZVAL),A8,L		;NEXT OBJ Z
	MOVE	*A1(OYVAL),A7,L		;NEXT OBJ Y
	CMP   	A6,A8
	jrgt	priok
	jrlt	PRISWAP
	CMP	A5,A7
	jrle	priok
PRISWAP	PUSHST
	dint
	MOVE	@INVELADD,A14,W
	JRNZ	YZ_ABORT		;BR=we VELADDed, so get outta dodge

NOTIMER_CHECK
	;unlink A0 from list
	move	*A0(OBLINK),A14,L
	move  	A1,*A14,L		;LINK FORWARD OVER A0
	move	A14,*A1(OBLINK),L	;LINK BACKWARD OVER A0
	move  	*A1,A14,L
	move	A14,*A0,L		;INSERT A0 AFTER A1
	move	A0,*A1,L		;
	move	A1,*A0(OBLINK),L	;
	move  	A0,*A14(OBLINK),L	;
	POPST
	MOVE	A4,A5
	JRUC	YZLP
priok	MOVE	A6,A9
	move  	A1,A0
	move  	A8,A6		;Z
	move	A7,A5		;Y
YZLP	move	*A0,A1,L	     	;next link in A1
	cmp	A1,A10
	jrne  	YZLP0
	RETS
YZ_ABORT
	POPST
	RETS

**************************************************************************
* END OF DISPLAY SYSTEM
**************************************************************************

**************************************************************************
* DISPLAY UTILITY ROUTINES
**************************************************************************

****************************************************************************
* FINDOID
* A0 - SUPP LIST
* A1 - OID MASK
* A2 - PATTERN TO MATCH
* RETS  A0 pts to obj, else ZFLAG set
FINDOID:
	PUSH	A3
	and	A1,A2
FindLp:
	move	*A0(OSLINK),A0,L
	jrz	FindOidX
	move	*A0(OID),A3,W
	and	A1,A3
	cmp	A2,A3
	jrne	FindLp
FindOidX:
	PULLQ	A3
	move	A0,A0
	rets


**************************************************************************
* OINIT
* INITIALIZE FREE LIST, OBJ PLANES, ANIOBJS, QUEUES
OINIT:
	MMTM	SP,A0,A1,A2,A3	;SAVE REG

	PUSHST
	DINT
	MOVE	@INTENB,A0,W
	ANDNI	X1E,A0		;NO MORE DMA INTERRUPTS
	MOVE	A0,@INTENB,W
	POPST

	MOVI	SCRNST_FULL,A0,L	;INIT SCREEN TOP LEFT [Y,X]
	MOVE	A0,@SCRNTL,L
	MOVI	SCRNEND,A0,L	;INIT SCREEN LOWER RIGHT [Y,X]
	MOVE	A0,@SCRNBR,L

	movi	DMAIQBOT,B12
	move	B12,B13		;set dma Q to be clear so DMAWAIT won't hang
	MOVE	B12,@DMAIQACT,L	;INIT ACTIVE DMA Q

	MOVI	DMAQ+QSIZE,A1
	MOVE	A1,@DMAQCUR,L		;INIT MISC DMA QUEUE

	CLR     A0
	MOVE	A0,@ANIOBJS,L

	MOVE	A0,@INVELADD,W	;INIT VELADD FLAG

	PUSHST
	DINT

	;*** INITIALIZE LINK FIELDS OF PLNS ***
	movi	FGLIST,A1
InitPlns
	move	A1,*A1,L		;Make P_LSTHD point at P_LSTHD
	move	A1,*A1(020h),L		;Make P_LSTTL point at P_LSTHD

	POPST

	;*** CLEAR OUT OBJ SPACE ***
	movi	OBJSTR,A1
  	movi	NOBJ*OBSIZ/010h,A2
CLROBST	move	A0,*A1+,W
	dsjs	A2,CLROBST

	MOVI	OBJSTR,A1,L
	MOVE	A1,@OFREE,L	;SETUP FREE LIST
  	movi	NOBJ,A3			;Init FREECNT to # of objs
	move	A3,@OFREECNT		;
oinitl:
	MOVE	A1,A2
	ADDI	OBSIZ,A1,W
	MOVE	A1,*A2,L		;LINK EM UP
	DSJS	A3,oinitl		;CONTINUE FOR NPROC
    	MOVE	A0,*A2,L		;ZERO LAST LINK
	move	A2,@ENDOFREE,L		;keep ptr to last obj on free list
	MMFM	SP,A0,A1,A2,A3	;RESTORE REGS
	RETS


**************************************************************************
* CkOFREE
* WALK FREE LIST, VERIFY LENGTH AND THAT EACH OBJ'S INUSE BIT IS CLEAR
* LOCKUP ON ERROR
	.IF DEBUG
CkOFREE:
	mmtm	SP,A0,A1,A2
	clr	A1
	move	@OFREE,A0,L
	jrz	GotFreCt
CntFree	inc	A1
	movb	*A0(OCTRL+B_INUSE-7),A2
	LOCKON	N
	move	*A0,A0,L
	jrnz	CntFree
GotFreCt:
	move	@OFREECNT,A0,W
	cmp	A0,A1
	LOCKON	NE
	mmfm	SP,A0,A1,A2
	rets
	.ENDIF


**************************************************************************
* IsAnObj
* CHECK A0 FOR BEING AN OBJECT PTR
* LOCKS UP IF BAD OBJ
IsAnObj:
	PUSH	A0
	subi	OBJSTR,A0
	LOCKON	N
	cmpi	OBJSTRX,A0
	LOCKON	GE
	movi	OBSIZ,A14
	modu	A14,A0
	LOCKON	NZ
	PULLQ	A0
	rets

**************************************************************************
* GETOBJ
* GET A FREE OBJECT BLOCK FOR USE
*
* RETURNS A0 = PTR TO OBJECT BLOCK
*    IF NO BLOCKS WERE AVAILABLE THEN THE Z FLAG IS SET
GETOBJ:
 	MOVE  	@OFREE,A0,L	; pointer to next available obj block
	jreq  	getox
	.IF DEBUG
	callr	IsAnObj
	movb	*A0(OCTRL+B_INUSE-7),A14
	LOCKON	N
	.ENDIF
	move	@OFREECNT,A14,W	;dec obj free list count
	dec	A14		;
	move	A14,@OFREECNT,W	;
	LOCKON	N
	jrp	SkClrEnd
	move	@ENDOFREE,A14,L
	cmp	A14,A0
	LOCKON	NE
	clr	A14
	move	A14,@ENDOFREE,L
SkClrEnd:
	move  	*A0,A14,L
	move  	A14,@OFREE,L	; adjust pointer to free list

	;*** CLEAR OUT THE VITAL PART OF THE OBJECT BLOCK ***
	clr	A14
	movi	OCLRSIZ,B14
	srl	5,B14
	jrnc	SkObjWord
	move	A14,*A0+,W
SkObjWord
	srl	1,B14
	jrnc	SkObjLong
	move	A14,*A0+,L
SkObjLong
ObjClrLp
	move	A14,*A0+,L
	move	A14,*A0+,L
	dsjs	B14,ObjClrLp
	subi	OCLRSIZ,A0

	movi	DMAWNZ|M_INUSE,A14
	move	A14,*A0(OCTRL),L	;init offset:flags
	movi	zscale_100_100_table,a14
	move	a14,*a0(OSCTAB),L
	move	A0,A0		; clear Z flag
getox:
	rets

**************************************************************************
*								         *
* CLRODATA - ROUTINE TO CLEAR THE ODATA AREA OF AN OBJECT.		 *
* 		A0 VERSION						 *
* A0 = PTR TO OBJECT							 *
*								         *
**************************************************************************
CLRODATA
	PUSH	A8
	MOVE	A0,A8
	CALLR	CLR_ODATA
	PULLQ	A8
	RETS

**************************************************************************
*								         *
* CLR_ODATA - ROUTINE TO CLEAR THE ODATA AREA OF AN OBJECT		 *
* A8 = PTR TO OBJECT							 *
* RETURNS								 *
* 	Z bit Clear							 *
*								         *
**************************************************************************
CLR_ODATA
	MMTM	SP,A1,A2
	MOVE	A8,A1
	MOVE	A1,A2
	ADDI	ODATA,A1
	ADDI	ODATAX,A2
	CALLA	CLRBLOCK
	CLRM	*A8(OPLAYER),L
	MOVE	A8,A8			;Clear Z for compatability
	MMFM	SP,A1,A2
	RETS

**************************************************************************
*								         *
* INSERT_OBJ - If head of multi-parter, entire multi-parter inserted.	 *
* 	     If sub-part of multi-parter, just sub-part inserted.	 *
* 	     OID is checked to insert object on supplemental list.	 *
* A8 = OBJ								 *
* RETURNS								 *
* 	nothing								 *
*								         *
**************************************************************************
INSERT_OBJ:
	PUSH	A0
	move	*A8(OPART1),A0,L
	jrz	SkInsMulti
	cmp	A0,A8			;Is Part Head Obj
	jrne	SkInsMulti

InsMulti
;* TO INSERT A HEAD OBJECT, INSERT SUBPARTS FIRST
;* THIS COULD BE MADE MORE EFFICIENT BY INSERTING ENTIRE MULTI-PARTER
;* TOGETHER INSTEAD OF CALLING INSOBJ FOR EACH PIECE
	move	*A0(OPARTS),A0,L
	jrz	SkInsMulti
	callr	INSOBJ			;INSERT Sub-Part
	jruc	InsMulti
SkInsMulti
	move	A8,A0
	callr	INSOBJ
	PULLQ	A0
	rets
****************************************************************************

**************************************************************************
*								         *
* INSERT_ON_OBJ - SAME AS INSERT_OBJ, EXCEPT, SUB-PARTS WILL ONLY BE	 *
* 		INSERTED IF THEY ARE ON, I.E. DMA WILL WRITE.		 *
* A8 = PTR TO OBJ							 *
*								         *
**************************************************************************
INSERT_ON_OBJ
	PUSH	A0
	MOVE	*A8(OPART1),A0,L	;CHECK FOR HEAD
	JRZ	SkInsMulti
	CMP	A0,A8			;IS IT?
	JRNE	SkInsMulti		;BR = NO
IOO_LP
;* TO INSERT A HEAD OBJECT, INSERT SUBPARTS FIRST, IF THEY'RE ON.
;* THIS COULD BE MADE MORE EFFICIENT BY INSERTING ENTIRE MULTI-PARTER
;* TOGETHER INSTEAD OF CALLING INSOBJ FOR EACH PIECE
	MOVE	*A0(OPARTS),A0,L	;GET SUB-PART
	JRZ	SkInsMulti		;BR = NO MORE
	MOVE	*A0(OCTRL),A14,W
	SLL	28,A14			;IS THIS OBJECT ON?
	JRZ	IOO_LP			;BR = NO, THEN DON'T INSERT YET
	CALLR	INSOBJ			;INSERT LOS SUB-PART
	JRUC	IOO_LP			;AND DO NEXT

**************************************************************************
*								         *
* INSOBJ - Insert obj into doubly linked object list			 *
* 	 List is sorted by increasing Z and increasing Y		 *
* 	 OID is checked to insert object on supplemental list		 *
* A0 = OBJ								 *
* *A0(OPLANE) = Plane # if no AUTOZ					 *
* RETURNS								 *
* 	nothing								 *
*								         *
**************************************************************************
INSOBJ:
	mmtm 	SP,A1,A2,A3,A4,A5
	;ERROR CHECKS
	callr	IsAnObj

	move	*A0,A4,L
	jrnz	INSOBJX		;obj is already inserted

	movi	FGLIST,A3
InsGotPln
	move	A3,A4
	move 	*A0(OZVAL),A1,L		; GET Z POSITION
ins_zloop:
	move  	*A3,A3,L
	cmp	A3,A4
	jreq 	do_ins			; bra if at end of list
	move 	*A3(OZVAL),A2,L		; ZPOS in A3
	cmp    	A2,A1
	jrgt 	ins_zloop
	jrlt	do_ins

	move	*A0(OYVAL),A5,L		; GET Y POSITION
	jruc	ins_ytest
ins_yloop
	move  	*A3,A3,L
	cmp	A3,A4
	jreq 	do_ins			; bra if at end of list
	move 	*A3(OZVAL),A2,L		; ZPOS in A3
	cmp    	A2,A1
	jrlt 	do_ins
ins_ytest
	move	*A3(OYVAL),A2,L		;TEST Y POSITION
	cmp	A2,A5
	jrlt	ins_yloop
do_ins
	PUSHST
	DINT
	move 	*A3(OBLINK),A2,L	; get ptr to previous

	move	A3,*A0,L		;IF BACK LINKS USED FROM INTERRUPT
	move	A0,*A2,L		; THIS WILL NEED TO BE DINT
	move	A0,*A3(OBLINK),L	;
	move	A2,*A0(OBLINK),L	;
	POPST

	callr	INSSUPP			;INSERT ON SUPPLEMENTAL LIST
INSOBJX
	mmfm 	SP,A1,A2,A3,A4,A5
	rets


**************************************************************************
* PULL_OBJ
* PULLS OBJECT FROM A DOUBLY LINKED OBJECT LIST
* MULTI-PART PIECES ARE NOT UNLINKED
* IF HEAD OF MULTI-PARTER, ENTIRE MULTI-PARTER PULLED
* IF SUB-PART OF MULTI-PARTER, JUST SUB-PART PULLED
* OID IS CHECKED TO PULL OBJECT FROM SUPPLEMENTAL LIST
*
* A8 = OBJ to be pulled
* RETS nothing
PULL_OBJ:
	PUSH	A0
	move	*A8(OPART1),A0,L
	jrz	SkPullMulti
	cmp	A0,A8			;Is Part Head Obj
	jrne	SkPullMulti

PullMulti ;* TO PULL A HEAD OBJECT, PULL ANY SUBPARTS FIRST
	move	*A0(OPARTS),A0,L
	jrz	SkPullMulti
	callr	PULLOBJ			;Pull Sub-Part
	jruc	PullMulti
SkPullMulti
	move	A8,A0
	callr	PULLOBJ
	PULLQ	A0
	rets

**************************************************************************
*								         *
* 	PULLOBJ								 *
* 									 *
* 	Pull an object from the Doubly linked object list.		 *
* 	If object is not inserted, then nothing is done.		 *
* 	Object is also pulled from the supplemental list		 *
* 	defined by its OID.						 *
* 	OLINK is cleared to mark object as not inserted.		 *
* 									 *
* 	A0 = Ptr to object						 *
* 									 *
* 	Returns:							 *
* 									 *
* 		Nothing							 *
*								         *
**************************************************************************
PULLOBJ:
	;PULL OBJ OUT OF ACTIVE OBJ LIST
;No zero checks needed because there will always be ptrs from both ends
	move	*A0(OLINK),A14,L	;IS OBJ INSERTED?
	jrz	SkPULLOBJ
	PUSH	A1
	PUSHST
	DINT				;Interrupts off now
	move	*A0(OBLINK),A1,L	;A1 - Prev Obj
	move	*A0,A14,L		;A14 - Next Obj
	move	A14,*A1,L		;LINK FORWARD AROUND OBJ A0
	move	A1,*A14(OBLINK),L	;LINK BACKWARD AROUND OBJ A0
	clr	A14
	move	A14,*A0(OLINK),L	;OBJ NOT INSERTED
	POPST
	callr	PULLSUPP	;PULL FROM SUPPLEMENTAL LIST
	PULLQ	A1
SkPULLOBJ
	rets

**************************************************************************
*								         *
* 	DELETE_OBJ				@		 *
* 									 *
* 	Delete an object from the object list and put it on the		 *
* 	end of the FREE list.						 *
* 									 *
* 	If object is HEAD of a multi-parter the entire multi-parter	 *
* 	is pulled from the object list and put on the FREE list		 *
* 	but it is not disassembled as a multi-parter.			 *
* 									 *
* 	If object is a sub-part of a multi-parter, object is		 *
* 	unlinked from the multi-parter, pulled from the object list	 *
* 	and put on the FREE list.					 *
* 									 *
* 	If object is solo then it is pulled from the object list and	 *
* 	put on the FREE list.						 *
* 									 *
* 	All objects:							 *
* 									 *
* 		- Pulled from the Animation list, if Animating.		 *
* 		- Shadow pulled and freed, if object has a shadow.	 *
* 		- Palette is deallocated.				 *
* 									 *
* 	Entrypoints:							 *
* 									 *
* 		DELETE_OBJ_PROC - Kills controlling process.		 *
* 		ZAP_OBJ - Skips the OPLINK safety check.		 *
* 									 *
* 	A8 = Ptr to object to be freed					 *
* 									 *
* 	Returns:							 *
* 		Nothing							 *
*								         *
**************************************************************************
DELETE_OBJ:
	.IF DEBUG
	move	*A8(OPLINK),A14,L
	jrz	ZAP_OBJ
	cmp	A14,A13
	LOCKON	NE
	.ENDIF
	JRUC	ZAP_OBJ

*
*Entrypoint: Kills linked process before deleting
*
DELETE_OBJ_PROC
	CALLA	OBJPROC_KILL
*
*	Fall through to ZAP_OBJ!

*
*Entrypoint: If OPLINK should not be checked
*
ZAP_OBJ:
	PUSH	A0
	move	*A8(OPART1),A0,L
	jrz	SkFreeMulti
	cmp	A0,A8			;Is Part Head Obj
	jreq	FreeMulti
	callr	PULL_PART		;SubPart just gets unlinked
	jruc	SkFreeMulti
FreeMulti ;* TO FREE A HEAD OBJECT, FREE ANY SUBPARTS FIRST (don't unlink)
	move	*A0(OPARTS),A0,L
	jrz	SkFreeMulti
	MOVE	*A0(OFLAGS),A14,W
	callr	ZAPOBJ			;Delete Sub-Part
	jruc	FreeMulti
SkFreeMulti
	move	A8,A0
	callr	ZAPOBJ
	PULLQ	A0
	rets


**************************************************************************
* DELOBJ
* FREEOBJ
* FREEGOBJ
* IF OPLINK SET, IT MUST POINT TO CURRENT PROCESS
* OID IS CHECKED TO PULL OBJECT FROM SUPPLEMENTAL LIST
* PUTS OBJ ON END OF FREE LIST
* INUSE BIT CLEARED
* FREEGOBJ (free garbage obj) Skips the following checks
*   IF PART ON AN OBJLST, IT IS PULLED
*   IF PART WAS ON ANIM, IT IS PULLED
*   SHADOW OBJ IS FREED
*   PALETTE IS DEALLOCATED
* ERRORS if obj not valid ptr, obj is already free
*
* A0 = OBJ to be deleted/freed
* RETS nothing
**************************************************************************
FREEGOBJ:
	callr	IsAnObj
	move	*A0(OCTRL),A14,W
	andni	M_INUSE,A14
	move	A14,*A0(OCTRL),W
	clr	A14
	move	A14,*A0,L	;OBJ GOES TO END OF FREE LIST, PTS AT NOTHING
	jruc	DOFREE
**************************************************************************
DELOBJ:
FREEOBJ:
	.IF DEBUG
;	MOVE	*A0(OID),A14,W
;	CMPI	OID_UNIV,A14
;	JREQ	ZAPOBJ
	move	*A0(OPLINK),A14,L
	jrz	ZAPOBJ
	cmp	A14,A13
	LOCKON	NE
	.ENDIF
ZAPOBJ:
* ENTRY POINT IF PLINK SHOULD NOT BE CHECKED

	callr	IsAnObj

	;CLEAR INUSE BIT TO MARK OBJ AS ON FREE LIST
	move	*A0(OCTRL),A14,W
	btst	B_INUSE,A14
	LOCKON	Z
	andni	M_INUSE,A14
	move	A14,*A0(OCTRL),W
	move	*A0(OFLAGS),A14,W
	;PULL FROM ANIM IF NECESSARY
	btst	B_ANIM,A14
	jrz	NoAnim
	callr	PULLANIM
NoAnim
	callr	PULLOBJ
	calla	DELPAL

DOFREE
	;PUT OBJ ON FREE LIST
	move	@OFREECNT,A14,W	;inc obj free list count
	inc	A14		;
	move	A14,@OFREECNT,W	;

	move	@ENDOFREE,A14,L
	jrz	HdLink1
	move	A0,*A14,L
	jruc	DidLink1
HdLink1
	move	A0,@OFREE,L
DidLink1
	move	A0,@ENDOFREE,L
	rets





;6/17
**************************************************************************
*								         *
* FPSTFOBJ0								 *
* FIND PAL AND THEN..							 *
* STFOBJ0								 *
* INIT OBJ W/ STARTING FRAME						 *
* A0 = PTR TO THE OBJ							 *
* A1 = PTR TO 1st Frame							 *
* 									 *
* 	  Z = FAILURE IN SOME WAY OR ANOTHER.				 *
*        NZ = SUCCESS							 *
*								         *
**************************************************************************
FPSTFOBJ0:
	PUSH	A2
	move	A0,A2
	move	*A1(ICMAP),A0,L
	calla	GETFPAL
	JRNZ	STFOBJ_PAL		;BR = WE HAVE PALETTE!
	MOVE	A2,A0			;ERROR CONDITION, RESTORE OBJECT
	SETZ				;Z TO FLAG ERROR
	JRUC	STFOBJX			;RETURN
STFOBJ_PAL
	move	A0,*A2(OPAL),W
	move	A2,A0
	jruc	STFOBJE
STFOBJ0
	PUSH	A2
STFOBJE
	move	A1,*A0(OIMG),L
	move	*A1(ISIZE),A14,L
	move	A14,*A0(OSIZE),L
	MOVE	A14,*A0(OUSIZE),L
	move	*A1(ISAG),*A0(OSAG),L
	MOVE	*A1(ICTRL),*A0(OCTRL),W

	MOVE	*A1(IANIOFF),A14,L
	MOVE	A14,*A0(OANIOFF),L
	move	A14,*A0(OUANIOFF),L
	clr	a14
	move	A14,*A0(OPARTSXY),L

	MOVI	01000100H,A14
	MOVE	A14,*A0(OSCALE),L
	sll	1,a14
	move	a14,*a0(ODAG),L		; place offscreen

	MOVE	A0,A0
STFOBJX
	PULL	A2
	RETS

****************************************************************************
* CFUNCS (creation funcs) for MULTIMAKE
****************************************************************************


****************************************************************************
* C_GETPRC
* MULTIMAKE CFUNC - GET A PROCESS AND LINK IT TO THE OBJECT JUST MADE
* REQUIRES
*  .word  PROCID
*  .long  WAKEUP
* After CFUNC entry of MULTIMAKE script
C_GETPRC
	move	*B0+,B14,W	;PROCID
	move	B14,A1
	move	*B0+,B14,L	;WAKEUP
	move	B14,A7
	PUSH	A8
	move	A0,A8
	calla	GETPRC
	move	A0,*A8(OPLINK),L
	PULLQ	A8
	rets

****************************************************************************
* C_ANIM
* MULTIMAKE CFUNC - PUT OBJ JUST MADE ON ANIM
*
* REQUIRES
*  .long  ANIM_INIT_TABLE w/ format of
* After CFUNC entry of MULTIMAKE script
C_ANIM
	move	*B0+,B14,L	;ANIM_INIT_TABLE
	move	B14,A1
	callr	STFANIM
	rets

**************************************************************************
*								         *
* C_STRTANIM - OBJECT CREATE CFUNC TO DO A QUICK START OF AN ANIM.	 *
* 		CLEARS STUFFS SCRIPT AND LOOP BACK THE SAME. CLEARS	 *
* 		ANISLP.							 *
* REQUIRES								 *
* 	.LONG	ANIM SCRIPT PTR						 *
*								         *
**************************************************************************
C_STRTANIM
	MOVE	*B0+,B14,L
	MOVE	B14,A1
	CALLR	STRTANIM
	RETS


**************************************************************************
*								         *
* SET_FLIP - SET THE FLIP BITS OF ONE OBJECT.				 *
* A8 = PTR TO OBJECT							 *
* A0 = NEW FLIP BITS							 *
*								         *
**************************************************************************
SET_FLIP
	PUSH	A4
	MOVE	*A8(OCTRL),A4,L
	ANDNI	M_FLIPH|M_FLIPV,A4
	OR	A0,A4
	CALLR	SET_OCTRL_OPARTSXY
	PULLQ	A4
	RETS

**************************************************************************
*								         *
* TOGGLE_FLIP - ROUTINE TO TOGGLE THE SPECIFIED FLIP BITS OF AN OBJECT.	 *
* A0 = FLIP BITS TO TOGGLE						 *
* A8 = PTR TO OBJECT							 *
*								         *
**************************************************************************
TOGGLE_FLIP
	PUSH	A4
	MOVE	*A8(OCTRL),A4,L
	XOR	A0,A4
	CALLR	SET_OCTRL_OPARTSXY
	PULLQ	A4
	RETS


**************************************************************************
*								         *
* SET_OCTRL_OPARTSXY - SET NEW OCTRL AND ADJUST OPARTSXY FOR FLIPPING	 *
* PASS:									 *
* A4 = NEW OCTRL							 *
* RETURNS:								 *
* NUTIN'								 *
*								         *
**************************************************************************

SET_OCTRL_OPARTSXY
	PUSH	A0
	move	*A8(OCTRL),A0,W
	xor	A4,A0
	btst	B_FLIPH,A0
	jrz	SOO_NOX

	move	*A8(OPARTSXY),A14,W
	NEG	A14
	move	A14,*A8(OPARTSXY),W
SOO_NOX
	btst	B_FLIPV,A0
	jrz	SOO_NOY

	move	*A8(OPARTSXY+010H),A14,W
	NEG	A14
	move	A14,*A8(OPARTSXY+010H),W
SOO_NOY
	MOVE	A4,*A8(OCTRL),W
	PULLQ	A0
	RETS



****************************************************************************
* CNTRANIP
* Stuff ANIOFF W/ center point of object
* A0 = OBJ
CNTRANIP
	move	*A0(OSIZEX),A14,W
	srl	1,A14
	move	A14,*A0(OANIOFFX),W
	move	*A0(OSIZEY),A14,W
	srl	1,A14
	move	A14,*A0(OANIOFFY),W
	rets


**************************************************************************
* GETANIXY
* GET THE X AND Y POSITIONS OF AN OBJECTS ANIMATION PT.
* A8 = OBJ
* RETS	A2=ANI OYPOS (16), A3=ANI OXPOS (16)
GETANIXY
	move	*A8(OYPOS),A2,W
	sll	16,A2
	move	*A8(OXPOS),A3,W
	movx	A3,A2
	move	*A8(OANIOFF),A3,L
	addxy	A3,A2
	move	A2,A3
	sra	16,A2
	sext	A3,W
	rets

**************************************************************************
* GETANIXYL
* GET THE X AND Y LONG POSITIONS OF AN OBJECTS ANIMATION PT.
* A8 = OBJ
* RETS	A2=ANI OYPOS (16.16), A3=ANI OXPOS (16.16)
GETANIXYL
	move	*A8(OANIOFFX),A14,W
	sll	16,A14
	move	*A8(OXVAL),A3,L
	add	A14,A3
	move	*A8(OANIOFFY),A14,W
	sll	16,A14
	move	*A8(OYVAL),A2,L
	add	A14,A2
	rets

**************************************************************************
* GETANIXL
* GET THE X ANIMATION PT OF AN OBJ (16.16).
* A8 = OBJ
* RETS	A0=ANI OXPOS (16.16)
GETANIXL
	move	*A8(OXVAL),A0,L
	move	*A8(OANIOFFX),A14,W
	sll	16,A14
	add	A14,A0
	rets

**************************************************************************
* GETANIX
* GET ANIMATION POINT X COOR (16)
* A8 = OBJ
* RETS	A0=ANI OXPOS (16)
GETANIX
	move	*A8(OXPOS),A0,W
	move	*A8(OANIOFFX),A14,W
	add	A14,A0
	rets

**************************************************************************
* GETANIYL
* GET THE Y ANIMATION PT OF AN OBJ (16.16).
* A8 = OBJ
* RETS	A0=ANI OYPOS (16.16)
GETANIYL
	move	*A8(OYVAL),A0,L
	move	*A8(OANIOFFY),A14,W
	sll	16,A14
	add	A14,A0
	rets

**************************************************************************
* GETANIY
* GET ANIMATION POINT Y COOR (16)
* A8 = OBJ
* RETS	A0=ANI OYPOS (16)
GETANIY
	move	*A8(OYPOS),A0,W
	move	*A8(OANIOFFY),A14,W
	add	A14,A0
	rets

**************************************************************************
* MATCHOPARTSXY
* Parms
* A8 ptr to BASE OBJ
* A0 ptr to obj which is to have its OPARTSXY set so that its offset pt
* is at the same point as the BASE OBJ
MATCHOPARTSXY
	PUSH	A1
	move	*A8(OPARTSXY),A1,W
	move	*A0(OXPOS),A14,W
	sub	A14,A1
	move	*A8(OXPOS),A14,W
	add	A14,A1
	move	A1,*A0(OPARTSXY),W

	move	*A8(OPARTSXY+010h),A1,W
	move	*A0(OYPOS),A14,W
	sub	A14,A1
	move	*A8(OYPOS),A14,W
	add	A14,A1
	move	A1,*A0(OPARTSXY+010h),W
	PULLQ	A1
	rets

**************************************************************************
* MATCHANIP
* Parms
* A8 ptr to BASE OBJ
* A0 ptr to obj which is to have its position set so that its anim pt
* is at the same coors as the BASE OBJ
MATCHANIP:
	PUSH	A1
	move	*A8(OANIOFF),A1,L
	move	*A0(OANIOFF),A14,L
	subxy	A14,A1
	move	*A8(OYPOS),A14,W
	rl	16,A1
	addxy	A1,A14
	move	A14,*A0(OYPOS),W
	rl	16,A1

	move	*A8(OXPOS),A14,W
	addxy	A1,A14
	move	A14,*A0(OXPOS),W

	;UPDATE FRACTIONAL PORTIONS TOO!
	move	*A8(OXVAL),*A0(OXVAL),W
	move	*A8(OYVAL),*A0(OYVAL),W
	PULLQ	A1
	rets

**************************************************************************
* GETANIP
* A0 PTR TO OBJ
* RETURNS  A1 = Y:X ANI POINT
GETANIP:
	MOVE	*A0(ODAG),A1,L
	move	*A0(OANIOFF),A14,L
	addxy	A14,A1
	rets

**************************************************************************
* GET_ANIP
* A8 PTR TO OBJ
* RETURNS  A1 = Y:X ANI POINT
GET_ANIP:
	MOVE	*A8(ODAG),A1,L
	move	*A8(OANIOFF),A14,L
	addxy	A14,A1
	rets

**************************************************************************
*								         *
* ADD_OFF2ANIP - ROUTINE TO ADD A GIVEN OFFSET TO THE ANIMATION PNT	 *
* 		OF AN OBJECT, AND RETURN THAT POINT.  FLIPS ARE		 *
* 		ACCOUNTED FOR.						 *
* A4 = [Y,X] OFFSET POINT						 *
* A8 = PTR TO OBJECT WE ARE OFFSETING FROM				 *
* RETURNS								 *
* 	A3 = [Y,X] POINT						 *
*								         *
**************************************************************************
ADD_OFF2ANIP
	MMTM	SP,A1,A4
	MOVE	*A8(OCTRL),A1,W		;ADJUST LAUNCH OFFSET IF NECESSARY
	BTST	B_FLIPH,A1
	JREQ	AO_CKV
	NEGX	A4
AO_CKV
	BTST	B_FLIPV,A1
	JREQ	AO_OFF
	NEGY	A4
AO_OFF
	CALLA	GET_ANIP
	MOVE	A1,A3
	ADDXY	A4,A3
	MMFM	SP,A1,A4
	RETS

**************************************************************************
* GETOFFP
* Get object's position using offset point.
* Uses OPARTSXY if M_OPARTSXY of OFLAGS2 set.
* Else uses OANIOFF (GETANIP).
* A0 OBJ
* RETURNS  A1 = Y:X OBJECT OFFSET POINT
GETOFFP:
	movb	*A0(OFLAGS+B_OPARTSXY-7),A14
	jrnn	GETANIP

	;USE OPARTSXY
	move	*A0(OYPOS),A1,W
	sll	16,A1
	move	*A0(OXPOS),A14,W
	movx	A14,A1
	move	*A0(OPARTSXY),A14,L
	addxy	A14,A1
	rets

**************************************************************************
* SET_OPARTSXY
* A8 obj
* A1 OPARTSXY OFFSET
* ADJUSTS OFFSET FOR CURRENT FLIP
SET_OPARTSXY
	PUSH	A0
	move	A8,A0
	callr	SETOPARTSXY
	PULLQ	A0
	rets

**************************************************************************
* SETOPARTSXY
* A0 obj
* A1 OPARTSXY OFFSET
* ADJUSTS OFFSET FOR CURRENT FLIP
* RETURNS
*	A1 = *A0(OPARTSXY),L = OPARTSXY ADJUSTED FOR FLIP
*
SETOPARTSXY:
	movb	*A0(OCTRL+B_FLIPH-7),A14
	jrnn	SkHFlpOf
	move	*A0(OSIZEX),A14,W	;THS-1-OPARTSX FOR H-FLIP
	dec	A14
	subxy	A1,A14
	movx	A14,A1
SkHFlpOf
	movb	*A0(OCTRL+B_FLIPV-7),A14
        jrnn	SkVFlpOf
	move	*A0(OSIZEY),A14,W	;THS-1-OPARTSY FOR V-FLIP
	dec	A14
	sll	16,A14
	subxy	A1,A14
	movy	A14,A1
SkVFlpOf
	move	A1,*A0(OPARTSXY),L
	rets


**************************************************************************
* GET_OFFP
* Get object's position using offset point.
* Uses OPARTSXY if M_OPARTSXY of OFLAGS2 set.
* Else uses OANIOFF (GETANIP).
* A8 OBJ
* RETURNS  A1 = Y:X OBJECT OFFSET POINT
GET_OFFP:
	PUSH	A0
	move	A8,A0
	callr	GETOFFP
	PULLQ	A0
	rets

**************************************************************************
* SETANIP
* SET OBJ POSITION SO ANIPT IS ON A POINT.
*
* A1 = Y:X POINT
* A0 = PTR TO OBJECT
SETANIP:
	PUSH	A1
	move	*A0(OANIOFF),A14,L
	subxy	A14,A1
	move	A1,*A0(OXPOS),W
	srl	16,A1
	move	A1,*A0(OYPOS),W
	PULLQ	A1
	rets

**************************************************************************
*								         *
* SET_ANIXP - SET OBJ POSITION SO ANIPT IS ON AN X POINT.		 *
* 	    WILL ADJUST ENTIRE MULTI-PARTER.				 *
* A1 = X POINT								 *
* A8 = PTR TO OBJECT							 *
* RETURNS								 *
* 	A1 = [Y,X] WORLD ANIMATION POINT				 *
*								         *
**************************************************************************
SET_ANIXP:
	PUSH	A0
	callr	GETANIY	;A0 ANI OYPOS
	sll	16,A0
	movy	A0,A1
	jruc	SET_ANIPe

**************************************************************************
*								         *
* SET_ANIYP - SET OBJ POSITION SO ANIPT IS ON A Y POINT.		 *
* 	    WILL ADJUST ENTIRE MULTI-PARTER.				 *
* A1 = Y POINT								 *
* A8 = PTR TO OBJECT							 *
* RETURNS								 *
* 	A1 = [Y,X] WORLD ANIMATION POINT				 *
*								         *
**************************************************************************
SET_ANIYP:
	PUSH	A0
	CALLR	GETANIX		;A0 ANI OXPOS
	SLL	16,A1
	MOVX	A0,A1
	JRUC	SET_ANIPe

**************************************************************************
* SET_ANIP
* SET OBJ POSITION SO ANIPT IS ON A POINT.
* WILL ADJUST ENTIRE MULTI-PARTER.
*
* A1 = Y:X POINT
* A8 = PTR TO OBJECT
SET_ANIP:
	PUSH	A0
SET_ANIPe
	move	A8,A0
	callr	SETANIP
	callr	SETOBJS
	PULLQ	A0
	rets

**************************************************************************
* MATCHOFFP
* Parms
* A8 ptr to BASE OBJ
* A0 ptr to obj which is to have its position set so that its anim pt
* is at the same coors as the BASE OBJ
MATCHOFFP:
	PUSH	A1
	callr	GET_OFFP
	callr	SETOFFP

	;UPDATE FRACTIONAL PORTIONS TOO!
	move	*A8(OXVAL),*A0(OXVAL),W
	move	*A8(OYVAL),*A0(OYVAL),W
	PULLQ	A1
	rets

**************************************************************************
* SETOFFP
* Set object's position using offset point.
* Uses OPARTSXY if M_OPARTSXY of OFLAGS2 set.
* Else uses OANIOFF (SETANIP).
* A0 OBJ
* A1 = Y:X OBJECT OFFSET POINT
* RETURNS nothing
SETOFFP:
	movb	*A0(OFLAGS+B_OPARTSXY-7),A14
	jrnn	SETANIP

	PUSH	A1
	;USE OPARTSXY
	move	*A0(OPARTSXY),A14,L
	subxy	A14,A1
	move	A1,*A0(OXPOS),W
	srl	16,A1
	move	A1,*A0(OYPOS),W
	PULLQ	A1
	rets

**************************************************************************
* SET_OFFP
* Set object's position using offset point.
* Uses OPARTSXY if M_OPARTSXY of OFLAGS2 set.
* Else uses OANIOFF (SETANIP).
* A8 OBJ
* A1 = Y:X OBJECT OFFSET POINT
* RETURNS nothing
SET_OFFP:
	PUSH	A0
	move	A8,A0
	callr	SETOFFP
	callr	SETOBJS
	PULLQ	A0
	rets


**************************************************************************
SET_OBJS:
;UPDATE POS AMONG PARTS OF A MULTI-PART OBJ
;A8 ptr to an obj
	mmtm	SP,A0,A1,A8
	jruc	SetObjE
SETOBJS:
;UPDATE POS AMONG PARTS OF A MULTI-PART OBJ
;A0 ptr to an obj
	mmtm	SP,A0,A1,A8
	move	A0,A8

SetObjE
	callr	GET_OFFP		;A1 OBJ OFFSET OF A8
	move	*A8(OPART1),A0,L
	jruc	Part1

PartsLp:
	move	*A0(OPARTS),A0,L
Part1:
	jrz	PartsX
	cmp	A0,A8
	jreq	PartsLp

	;* UPDATE THE POSITIONS
	callr	SETOFFP
	;UPDATE FRACTIONAL PORTIONS TOO!
	move	*A8(OXVAL),*A0(OXVAL),W
	move	*A8(OYVAL),*A0(OYVAL),W
	jruc	PartsLp

PartsX:
	mmfm	SP,A0,A1,A8
	rets
**************************************************************************


**************************************************************************
**************************************************************************
**************************************************************************

**************************************************************************
**************************************************************************

**************************************************************************
*								         *
* SETANIPU								 *
* SET OBJ POSITION'S ANIMATION POINT IN THE UNIVERSE			 *
* 									 *
* PASS:									 *
* A0 = OBJECT								 *
* A1 = UNIVERSE X							 *
* A2 = UNIVERSE Y							 *
* A3 = UNIVERSE Z							 *
*								         *
**************************************************************************
SETANIPU
	move	A1,*A0(OXVAL),L
	move	A2,*A0(OYVAL),L
	move	A3,*A0(OZVAL),L
	rets

**************************************************************************
* GET_ANIPU
* GET_OFFPU
* Get object's UNIVERSE position (USES OPARTSXY IF SET IN OFLAGS)
* A8 OBJ
* RETURNS
* A1 = UNIVERSE X							 *
* A2 = UNIVERSE Y							 *
* A3 = UNIVERSE Z							 *
GET_ANIPU:
GET_OFFPU:
	PUSH	A0
	move	A8,A0
	callr	GETOFFPU
	PULLQ	A0
	rets

**************************************************************************
* GETANIPU
* GETOFFPU
* Get object's UNIVERSE position (USES OPARTSXY IF SET IN OFLAGS)
* A0 OBJ
* RETURNS
* A1 = UNIVERSE X							 *
* A2 = UNIVERSE Y							 *
* A3 = UNIVERSE Z							 *
GETANIPU:
GETOFFPU:
	move	*A0(OXVAL),A1,L
	move	*A0(OYVAL),A2,L
	move	*A0(OZVAL),A3,L
	MOVB	*A0(OZOFF),A14
	SUB	A14,A3

	movb	*A0(OFLAGS+B_OPARTSXY-7),A14
	jrnn	GET_U_DONE

	move	*A0(OPARTSXY),A14,L

	SEXT	A14,W
	SLL	15,A14
	SUB	A14,A1

	move	*A0(OPARTSXY+010H),A14,L

	SEXT	A14,W
	SLL	15,A14
	SUB	A14,A2

GET_U_DONE
	rets

**************************************************************************
**************************************************************************
**************************************************************************


**************************************************************************
* INITPART
* Makes obj a multi-parter w/ self
* A8 = OBJ to be made the head object of a multi-parter
INITPART
	clr	A14
	move	A14,*A8(OPARTS),L
	move	A8,*A8(OPART1),L
	rets

**************************************************************************
*								         *
* CNTMPART - COUNT THE NUMBER OF PARTS CONTAINED IN THIS		 *
* 		MULTI-PARTER. RETURNS 0 IF NOT A MULTI-PARTER.		 *
* A0 = PTR TO ANY PART							 *
* RETURNS								 *
* 	 Z = NOT A MULTI-PARTER						 *
* 		A1 = 0							 *
* 	NZ = MULTI-PARTER						 *
* 		A1 = NUMBER OF PARTS					 *
*								         *
**************************************************************************
CNTMPART:
	PUSH	A0
	clr	A1
	move	*A0(OPART1),A0,L
	jrz	CntPartsX
CntParts:
	inc	A1
	move	*A0(OPARTS),A0,L
	jrnz	CntParts
CntPartsX
	MOVE	A1,A1
	PULL	A0
	rets
**************************************************************************

**************************************************************************
* INSPART
* A0 ptr to an obj (or multi-parter) to be added to a multi-parter
* A8 obj to be head or obj in a multiparter, which contains head obj
INSPART:
	mmtm	SP,A0,A1,A2,A3,A8
	move	*A8(OPART1),A1,L
	jrnz	SkMkHd
	callr	INITPART
	jruc	IGotHd
SkMkHd
	move	A1,A8
IGotHd
	.IF	DEBUG
	callr	CkMPART
	.ENDIF

	move	*A8(OPART1),A1,L
	move	*A0(OPART1),A2,L
	jrnz	InsParts
	move	A0,A2

InsParts
	;*** ADD A LIST OF OBJS TO ANOTHER LIST ***
	move	A2,A3
InsPLp
	move	A2,A0
	move	A1,*A0(OPART1),L
	move	*A0(OPARTS),A2,L
	jrnz	InsPLp
*THIS MAKES ANY NEWLY INSERTED PARTS GO TO THE END OF THE MULTI-PARTER
INS_TO_END_LP
	MOVE	A1,A2				;KEEP PREVIOUS PART
	MOVE	*A1(OPARTS),A1,L		;ANY MORE PARTS?
	JRNZ	INS_TO_END_LP			;BR = YES
****	move	*A1(OPARTS),*A0(OPARTS),L
****	move	A3,*A1(OPARTS),L
	MOVE	A3,*A2(OPARTS),L		;WE KNOW WE'RE AT THE END

	.IF	DEBUG
	callr	CkMPART
	.ENDIF

	mmfm	SP,A0,A1,A2,A3,A8
	rets
**************************************************************************

**************************************************************************
* CkMPART1
* Checks if obj is part of invalid multi-parter
* checks that obj is valid head obj
*
* A8 = OBJ to be checked
CkMPART1
	mmtm	SP,A6,A7,A8
	move	*A8(OPART1),A7,L
	jrz	CkMPARTX
	cmp	A8,A7
	LOCKON	NZ
	jruc	CkMPARTE
**************************************************************************
* CkMPART
* Checks if obj is part of invalid multi-parter
*
* A0 = OBJ to be checked
CkMPART:
	mmtm	SP,A6,A7,A8
	move	*A0(OPART1),A7,L
	jrz	CkMPARTX		;NOT IN MULTI-PARTER -> OK
CkMPARTE:
	move	A7,A8
CkMPLp
	move	*A8(OPART1),A6,L
	cmp	A6,A7
	LOCKON	NE
	move	*A8(OPARTS),A8,L
	jrnz	CkMPLp
CkMPARTX
	mmfm	SP,A6,A7,A8
	rets

**************************************************************************
* PULL_PART
* REMOVE OBJ FROM A MULTI PARTER
* A8 = piece of a multi-part obj
* PULLPART
* A0 = piece of a multi-part obj
PULL_PART:
	PUSH	A0
	move	A8,A0
	callr	PULLPART
	PULLQ	A0
	rets
PULLPART:
;A0 ptr to a piece of a multi-part obj
	PUSH	A2
	move	*A0(OPART1),A14,L
	LOCKON	Z
	cmp	A14,A0		;CAN'T USE TO PULL HEAD
	LOCKON	EQ
	callr	CkMPART

FindPrev
	move	A14,A2
	move	*A2(OPARTS),A14,L
	LOCKON	Z
	jrz	PullPrtX
	cmp	A14,A0
	jrne	FindPrev

	;*** GOT THE PTR TO THE PREVIOUS OBJ IN A2
	move	*A0(OPARTS),*A2(OPARTS),L	;link around A0

	move	*A0(OPART1),A14,L
	move	*A14(OXVEL),*A0(OXVEL),L
	move	*A14(OYVEL),*A0(OYVEL),L
	move	*A14(OZVEL),*A0(OZVEL),L
	clr	A14
	move	A14,*A0(OPART1),L
	move	A14,*A0(OPARTS),L

PullPrtX
	PULLQ	A2
	rets

**************************************************************************
* PULL_PART1
* PULLS HEAD OBJ FROM MULTI-PARTER, MAKES NEXT OBJ NEW HEAD
* A8 = Head obj of a multi-part obj
* RETS A0 new Head Obj
PULL_PART1:
	PUSH	A2
	.IF DEBUG
	callr	CkMPART1
	.ENDIF
	move	A8,A0

	move	*A0(OPARTS),A14,L
	jrz	NoPull1
	move	A14,A2
HdLnks
	move	A14,*A2(OPART1),L
	move	*A2(OPARTS),A2,L
	jrnz	HdLnks

NoPull1
	clr	A2
	move	A2,*A0(OPART1),L
	move	A2,*A0(OPARTS),L

	move	A14,A0
	PULL	A2
	rets

****************************************************************************
* FINDPART
* A1 # of part to be found
* A8 ptr to obj in multiparter
* RETS A0 if part found, Z set if not
FINDPART:
	andi	0FFh,A1
	move	*A8(OPART1),A0,L
FindMPLp
	movb	*A0(OPARTID),A14
	andi	0FFh,A14
	cmp	A14,A1
	jreq	FoundMP
	move	*A0(OPARTS),A0,L
	jrnz	FindMPLp
FoundMP
	move	A0,A0
	rets

**************************************************************************
*								         *
* GET_HEAD_PART - ROUTINE TO GET THE PTR TO THE HEAD OBJECT OF A	 *
* 		MULTI-PARTER, IF THE OBJECT IS SOLO THEN NOTHING	 *
* 		CHANGES.						 *
* A8 = PTR TO PART							 *
* RETURNS								 *
* 	 Z = NOT A MULTI-PARTER						 *
* 		A8 = SAME						 *
* 	NZ = MULTI-PARTER						 *
* 		A8 = PTR TO HEAD OBJECT					 *
*								         *
**************************************************************************
GET_HEAD_PART
	MOVE	*A8(OPART1),A14,L	;GET HEAD PART
	JRZ	GHP_X			;BR = SOLO OBJECT
	MOVE	A14,A8			;RETURN PART
GHP_X
	RETS

**************************************************************************
*								         *
* GETHEADPART - A0 Version of GET_HEAD_PART				 *
* A0 = Ptr to part							 *
* Returns:								 *
* 	 Z = Not a Multi-Parter						 *
* 		A0 = Same						 *
* 	NZ = Object is part of a Multi-Parter				 *
* 		A0 = Ptr to HEAD object					 *
*								         *
**************************************************************************
GETHEADPART
	MOVE	*A0(OPART1),A14,L	;GET HEAD PART
	JRZ	GHPA0_X			;BR = SOLO OBJECT
	MOVE	A14,A0			;RETURN PART
GHPA0_X
	RETS

**************************************************************************
*								         *
* GET_HEAD_PART_A0 - ROUTINE TO GET THE PTR TO THE HEAD OBJECT OF A	 *
* 		MULTI-PARTER, IF THE OBJECT IS SOLO THEN NOTHING	 *
* 		CHANGES.						 *
* A8 = PTR TO PART							 *
* RETURNS								 *
* 	A0 = PTR TO HEAD OBJECT						 *
*								         *
**************************************************************************
GET_HEAD_PART_A0
	MOVE	*A8(OPART1),A14,L	;GET HEAD PART
	JRZ	GHPA_NOMULTI		;BR = SOLO OBJECT
	MOVE	A14,A0			;RETURN PART
	RETS
GHPA_NOMULTI
	MOVE	A8,A0			;RETURN "HEAD" PART REGARDLESS
	SETZ				;FLAG IT.
	RETS



	.align		;This replaces the old CACHE4 section

**************************************************************************
*								         *
* GANIOF - RETURN ANIMATION PNT. OF GIVEN IMAGE				 *
* A2 = [HEIGHT,WIDTH]							 *
* A5 = OFLAGS								 *
* GARBOF - SAME AS GANIOF EXCEPT YOU PROVIDE				 *
* A6 = OFFSET								 *
* RETURNS								 *
*  	A6 = X ANIMATION OFFSET (32 BIT)				 *
* 	A7 = Y ANIMATION OFFSET (32 BIT)				 *
*								         *
**************************************************************************
GANIOF:
	MMTM	SP,A2,A3
	MOVE	*A1(IANIOFF),A6,L
	jruc	GotOf
GARBOF:
;A6 has offset from TL
	MMTM	SP,A2,A3
GotOf	CLR	A7		;MAKE SURE A7 IS 0
	MOVY	A6,A7
	SLL	16,A6		;MOVE TO UPPER WORD
	SUBI	00010001h,A2	;ADJUST FOR -1
	CLR	A3
	MOVY	A2,A3
	SLL	16,A2		;MOVE TO UPPER WORD
	BTST	B_FLIPH,A5
        JRZ	GANI1
	NEG	A6
	ADD	A2,A6		;SUB THS-1 FOR H-FLIP
GANI1:
	BTST	B_FLIPV,A5
	JRZ	GANI2
	NEG	A7
	ADD	A3,A7		;SUB TVS-1 FOR V-FLIP
GANI2:
	MMFM	SP,A2,A3
	RETS

**************************************************************************
* SetArbP
* A8 ptr to BASE OBJ
* A7 BASE OBJ TL offset
* A0 ptr to obj which is to have its position set so that its offset pt
*	is at the same coors as the BASE OBJ offset pt
* A1 SUBORDINATE OBJ TL offset
SetArbP:
	mmtm	SP,A2,A3,A4,A5,A6,A7
;* get POSITION from first obj..
	move	*A8(OSIZE),A2,L
	move	*A8(OCTRL),A4,W
*GARBOF: A6=ANIOFF, A2=H:W, A4=OCTRL -> A6=X ANIOFF<<16, A7=Y ANIOFF<<16
	move	A7,A6
	callr	GARBOF
	move	A6,A3
	move	A7,A5

	move	*A0(OSIZE),A2,L
	move	*A8(OCTRL),A4,W
*GARBOF: A6=ANIOFF, A2=H:W, A4=OCTRL -> A6=X ANIOFF<<16, A7=Y ANIOFF<<16
	move	A1,A6
	callr	GARBOF
	sub	A7,A5
	sub	A6,A3

	move	*A8(OYVAL),A7,L
	add	A7,A5
	move	A5,*A0(OYVAL),L
	move	*A8(OXVAL),A6,L
	add	A6,A3
	move	A3,*A0(OXVAL),L
	mmfm	SP,A2,A3,A4,A5,A6,A7
	rets



**************************************************************************
* STRT_ANIM
* A1 SCRIPT PTR
* A8 OBJ TO BE STARTED ON ANIM
STRT_ANIM:
	PUSH	A0
	move	A8,A0
	callr	STRTANIM
	PULLQ	A0
	rets
* STRTANIM
* A1 SCRIPT PTR
* A0 OBJ TO BE STARTED ON ANIM



STRTANIM:
	PUSH	A1
	move	A1,*A0(AnimFrm),L
	move	A1,*A0(AnimScr),L
	clr	A1
	movb	A1,*A0(AnimSlp)
	callr	CKINSANI
	PULLQ	A1
	rets

*
* Same as STRTANIM, but starts in middle of sequence
* A1 START FRAME
* A14 SCRIPT PTR
* A0 OBJ TO BE STARTED ON ANIM
*
STRTANIM_OFF:
	PUSH	A1
	move	A14,*A0(AnimScr),L
	move	A1,*A0(AnimFrm),L
	clr	A1
	movb	A1,*A0(AnimSlp)
	callr	CKINSANI
	PULLQ	A1
	rets

**************************************************************************
* STFANIM
* A1 = Ptr to ANIM Structure (see below)
* A0 = Ptr to Object to be inserted
*   STRUCT .long FRAME (ptr), SCRIPT (reset)
*	   .byte AnimSLP (reset), AnimSlp (ctr)
*          .word RESERVED (set to 0)
*
STFANIM:
	mmtm	SP,A1,A2
	move	A0,A2
	addi	AnimFrm,A2
	move	*A1+,*A2+,L
	move	*A1+,*A2+,L
	move	*A1+,*A2+,L
	callr	CKINSANI
	mmfm	SP,A1,A2
	rets

****************************************************************************
* INSANIM - errors if already on
* CKINSANI - only inserts if not already on
* A0 = OBJ to be Animated/Flown by ANIMP
* ***NOTE***
* the following obj fields must be appropriately initialized before insertion.
* AnimScr 	-ptr to longnull terminated animation script w/ format of
*  .long	frame		;if Bit 0 of frame ptr = '1' don't animate..
*  .word (FlipFlag.1:unusedFlag.1:FuncFlag.1:MultiFlag.1:0.4 : SleepTime.8)
*  [.word FlipBits] if FlipFlag set
*  [.long Function|# of ARG words (0-15)] if FuncFlag set
*	!!!!! WARNING WARNING WARNING WARNING WARNING WARNING !!!!!
*	!!!!! 						      !!!!!
*	!!!!! The low four bits of the animation function     !!!!!
*	!!!!! Address are used to indicate the number of      !!!!!
*	!!!!! WORD arguments used by this function.	      !!!!!
*	!!!!! ALWAYS use GETAFARG_xxxx to grab arguments.     !!!!!
*	!!!!! 						      !!!!!
*	!!!!! WARNING WARNING WARNING WARNING WARNING WARNING !!!!!
*  if MultiFlag Set, loop on OPARTS & process another script entry
*    this causes stuffing of sleep time to be skipped, thus sleep value of
*    last entry of multiscript will be used.
*	If the NOPARTANI Bit of OFLAGS is set for a subpart, that
*	part will not be processed during the Multi-Script.
* 	Function can clobber all but A12,A13
*	!!!!! WARNING WARNING WARNING WARNING WARNING WARNING !!!!!
*          A12 must stay untouched throughout anim func because a call
*          to DELOBJ or PULLANIM will scan to pull QUEUED(A12) Anim func.
*	!!!!! WARNING WARNING WARNING WARNING WARNING WARNING !!!!!
* AnimFrm	-ptr to current entry in animation script
* AnimSlp	-byte, # tiks before next ani
* AnimSLP -byte, overlayed on AnimScr, resets AnimSlp when SleepTime=0
* AnimGrv	-word, amount to add to Yvel each tik
*
* AnimArg	-set by AnimP, used by GETAFARG_xxxx

CKINSANI:
;*** ONLY INSERT OBJ IF IT ISN'T ALREADY ON ***
	movb	*A0(OFLAGS+B_ANIM-7),A14
	jrn	SkInsAni
INSANIM:
	.IF	DEBUG
	callr	IsAnObj
	callr	CkAnim
	callr	OnAnim
	.ENDIF

	PUSH	A1

	;**** MARK OBJ AS BEING ON ANIM LIST ****
	PUSHST
	DINT

	move	*A0(OFLAGS),A1,W
	btst	B_ANIM,A1
	LOCKON	NZ
	ori	M_ANIM,A1
	move	A1,*A0(OFLAGS),W

	;LINK OBJ INTO HEAD OF ANIOBJS LIST
	move	@ANIOBJS,A1,L
	move	A1,*A0(AnimNxt),L
	move	A0,@ANIOBJS,L
    	POPST
****	EINT

	PULLQ	A1
	.IF	DEBUG
;	callr	CkAnim
	.ENDIF
SkInsAni
	rets


**************************************************************************
* PULL_ANIM
* A8 = OBJ to be pulled from ANIOBJS
* NOTE, CURRENTLY DOESN'T PULL ALL OF MULTI-PARTER IF HEAD
PULL_ANIM:
	PUSH	A0
	move	A8,A0
	callr	PULLANIM
	PULLQ	A0
	rets

**************************************************************************
*								         *
* PULL_ANIM_ALL - PULL OBJECT FROM ANIOBJS ALONG WITH ALL OF ITS	 *
* 		PARTS.							 *
* A8 = PTR TO HEAD OBJECT OF MULTI-PARTER				 *
*								         *
**************************************************************************
PULL_ANIM_ALL
	PUSH	A1
	CLR	A1
	CALLR	PULL_ANIM_MULTI
	PULLQ	A1
	RETS

**************************************************************************
*								         *
* PULL_ANIM_MULTI - PULL GIVEN NUMBER OF OBJECTS OF A MULTI-PARTER	 *
* 			STARTING WITH THE GIVEN OBJECT.			 *
* 			THE NOPARTANI FLAG OF EACH OBJECT WILL		 *
* 			BE CLEARED AT THIS POINT.			 *
* A1 = # OF OBJECTS TO PULL (IF A1 IS 0 PULL ALL FROM THIS POINT)	 *
* A8 = PTR TO PART OF MULTI-PARTER					 *
* RETURNS								 *
* 	A1 = DECREMENTED TO REFLECT NUMBER OF PARTS PULLED		 *
*								         *
**************************************************************************
PULL_ANIM_MULTI
	PUSH	A0
	MOVE	A8,A0			;PULL THE FIRST OBJECT
PAM_LP
****	MOVB	*A0(OFLAGS+B_DEAD-7),A14	;IS THIS OBJECT DEAD?
****	JRN	PAM_SKIP_NOPART			;BR = YES, DO NOT FOOL AROUND
	MOVB	*A0(OFLAGS+B_ANIM-7),A14	;IS HE ON ANIOBJS?
	JRNN	PAM_SKIP		;BR = NO
	CALLR	PULLANIM
PAM_SKIP
****	MOVB	*A0(OFLAGS2+B_DEAD-7),A14	;IS THIS OBJECT DEAD?
****	JRN	PAM_SKIP_NOPART			;BR = YES, DO NOT FOOL AROUND
	ANDNIM	M_NOPARTANI,*A0(OFLAGS),W	;REVOKE HIS INDEPENDENCE
PAM_SKIP_NOPART
	DEC	A1			;ARE WE FINISHED?
	JRZ	PAM_X			;BR = YES
	MOVE	*A0(OPARTS),A0,L	;GET THE NEXT OBJECT TO PULL
	JRNZ	PAM_LP			;IF THERE ARE NO MORE, EXIT
PAM_X
	PULLQ	A0
	RETS

**************************************************************************
* PULLANIM
* A0 = OBJ to be pulled from ANIOBJS
;A12 if IN_ANIM, A12 must be pointing to ANIM FUNC QUEUE
CKPULLANIM	;PULL FROM ANIM IF NECESSARY
	movb	*A0(OFLAGS+B_ANIM-7),A14
	jrnn	SkPullAnim
PULLANIM:
	PUSH	A2
	.IF	DEBUG
;	callr	CkAnim
	.ENDIF

	;**** MARK OBJ AS BEING OFF ANIM LIST ****
	move	*A0(OFLAGS),A2,W
	btst	B_ANIM,A2
	LOCKON	Z
	andni	M_ANIM,A2
	move	A2,*A0(OFLAGS),W

	calla	PULLANIMFUNC	;stop any queued anim func

	MOVE	@ANIOBJS,A14,L
	cmp	A0,A14
	jrne	PullLp
	;*** PULLING FIRST OBJ ***
	move	*A0(AnimNxt),A14,L
	MOVE	A14,@ANIOBJS,L
	jruc	NoPull

PullLp:
	MOVE 	A14,A2			;PTR TO PREVIOUS IN A2
	MOVE 	*A2(AnimNxt),A14,L	;PTR TO NEXT IN A14
	LOCKON	Z
	CMP  	A14,A0			;IS THIS THE GUY?
	JRNE 	PullLp
	MOVE 	*A0(AnimNxt),*A2(AnimNxt),L 	;LINK AROUND THIS OBJECT

NoPull:

	.IF	DEBUG
	callr	CkAnim
	.ENDIF
	PULLQ	A2
SkPullAnim
	RETS

**************************************************************************
* CkAnim
* Walk ANIOBJS list, hang if anything is wrong
	.IF DEBUG
CkAnim:
	mmtm	SP,A0,A2
	move	@ANIOBJS,A0,L
	jrz	AniCkLpX
AniCkLp:
	move	*A0(OFLAGS),A2,W
	btst	B_ANIM,A2
	LOCKON	Z
	move	*A0(OCTRL),A2,W
	btst	B_INUSE,A2
	LOCKON	Z

;	callr	IsAnObj

	move	*A0(AnimNxt),A0,L
	jrnz	AniCkLp
AniCkLpX:
	mmfm	SP,A0,A2
	rets
	.ENDIF

**************************************************************************
* OnAnim
* hang if A0 is on ANIOBJS LIST
	.IF DEBUG
OnAnim:
	move	@ANIOBJS,A14,L
	jrz	AniOnLpX
AniOnLp:
	cmp	A0,A14
	LOCKON	Z
	move	*A14(AnimNxt),A14,L
	jrnz	AniOnLp
AniOnLpX:
	rets
	.ENDIF

**************************************************************************
*								         *
* GETAFARG_WORD - GET A WORD ARGUMENT FOR AFunc, IT IS PULLED FROM THE	 *
* 		ANIM SCRIPT.						 *
* A8 = PTR TO OBJECT ANIMATING						 *
* *A8(AnimArg),L = PTR TO ARGUMENT TO BE PULLED				 *
* RETURNS								 *
* 	A0 = ARGUMENT							 *
*	N & Z = SET TO REFLECT ARGUMENT	     				 *
* 	*A8(AnimArg),L = POINTING TO NEXT				 *
*								         *
**************************************************************************
GETAFARG_WORD
	MOVE	*A8(AnimArg),A14,L
	MOVE	*A14+,A0,W
	MOVE	A14,*A8(AnimArg),L
	RETS

**************************************************************************
*								         *
* GETAFARG_LONG - GET A LONG ARGUMENT FOR AFunc, IT IS PULLED FROM THE	 *
* 		ANIM SCRIPT.						 *
* A8 = PTR TO OBJECT ANIMATING						 *
* *A8(AnimArg),L = PTR TO ARGUMENT TO BE PULLED				 *
* RETURNS								 *
* 	A0 = ARGUMENT							 *
*	N & Z = SET TO REFLECT ARGUMENT	     				 *
* 	*A8(AnimArg),L = POINTING TO NEXT				 *
*								         *
**************************************************************************
GETAFARG_LONG
	MOVE	*A8(AnimArg),A14,L
	MOVE	*A14+,A0,L
	MOVE	A14,*A8(AnimArg),L
	RETS

**************************************************************************
* A_GOTO - Anim Func
* takes two args from anim script
* .long label to branch to.
* .word %chance (RANDPER) to take branch
A_GOTO
	callr	GETAFARG_LONG	;Arg in A0
	move	A0,A1
	callr	GETAFARG_WORD	;Arg in A0
	calla	RANDPER
	jrnc	A_GOTOX
	move	A1,*A8(AnimFrm),L
A_GOTOX
	rets


**************************************************************************
*								         *
* A_AnimGo - ANIM FUNC TO GO TO NEW ANIM SCRIPT/FRAME			 *
* A8 = PTR TO OBJECT							 *
*								         *
**************************************************************************
A_AnimGo
	CALLR	GETAFARG_LONG		;GET NEW PTR OFF OF SCRIPT
	MOVE	A0,*A8(AnimFrm),L
	MOVE	A0,*A8(AnimScr),L
	RETS

**************************************************************************
*								         *
* A_AnimFrm - ANIM FUNC TO GO TO NEW ANIM FRAME				 *
* A8 = PTR TO OBJECT							 *
*								         *
**************************************************************************
A_AnimFrm
	CALLR	GETAFARG_LONG		;GET NEW PTR OFF OF SCRIPT
	MOVE	A0,*A8(AnimFrm),L
	RETS

**************************************************************************
*								         *
* A_AnimScr - ANIM FUNC TO SET A NEW LOOP BACK PTR FOR AN ANIMATION	 *
* 		SCRIPT.							 *
* A8 = PTR TO OBJECT							 *
*								         *
**************************************************************************
A_AnimScr
	CALLR	GETAFARG_LONG		;GET NEW PTR OFF OF SCRIPT
	MOVE	A0,*A8(AnimScr),L
	RETS

**************************************************************************
*								         *
* A_CHANGE_OID - ANIM FUNC TO STUFF A NEW OID INTO AN OBJECT		 *
* A8 = PTR TO OBJECT							 *
* AARG+,W = NEW OID TO STUFF						 *
*								         *
**************************************************************************
A_CHANGE_OID
	CALLA	GETAFARG_WORD
	MOVE	A0,A1
	JRUC	CHANGE_OID

**************************************************************************
*								         *
* CREATE_OBJ - CREATE AN OBJECT AND STUFF IT, LEAVE IT UNINSERTED.	 *
* 		USES THE "NEW" (11/15/90) INITIALIZATION TABLE.		 *
* A5 = PTR TO INIT TABLE						 *
* RETURNS								 *
* 	 Z = FAILURE TO CREATE EITHER OBJECT OR PALETTE.		 *
* 		A0 = 0							 *
* 	NZ = O.K.							 *
* 		A0 = POINTER TO OBJECT					 *
* 		A5 = NEXT WORD AFTER INITIALIZATION			 *
*								         *
**************************************************************************
CREATE_OBJ
	CALLR	GETOBJ
	JRZ	CO_X			;OBJECT BLOCK FAILURE
	CALLR	INIT_OBJ
	JRNZ	CO_X
	CALLR	FREEOBJ			;DO THIS ON MASTER PALETTE FAILURE
	CLR	A0			;SET THE Z FLAG
CO_X:
	RETS
**************************************************************************
*								         *
* INIT_OBJ - INITIALIZE AN OBJECT BLOCK USING AN INITIALIZATION TABLE.	 *
* A0 = OBJECT BLOCK TO INITIALIZE					 *
* A5 = PTR TO "NEW" INITIALIZATION TABLE				 *
* A8 - A11 = MUST BE PASSED TO CREATE FUNC IF CALLED.			 *
* RETURNS:								 *
* 	 Z = PALETTE ALLOCATE FAILURE, OBJECT NOT STUFFED		 *
* 	NZ = ALL IS WELL						 *
* A5 = POINTING TO NEXT WORD AFTER INITIALIZATION TABLE			 *
* 									 *
* 		 INITIALIZATION TABLE					 *
* 		 --------------------					 *
* 	.LONG	OIMG,OCVECT						 *
* 	.WORD	OID,OCTRL,OFLAGS,OZOFF					 *
* 	.LONG	CFUNC							 *
*								         *
**************************************************************************
INIT_OBJ
	PUSH	A1
	MMTM	SP,B0,B1,B2,B3

	MOVE	*A5+,A1,L
	CALLR	FPSTFOBJ0
	JRZ	IO_X

	MOVE	A5,B0
	move	A0,B1
	move	*B0+,B2,L		;Load OCVECT
	move	B2,*B1(OCVECT),L
	move	*B0+,B2,W		;Load OID
	move	B2,*B1(OID),W

	move	*B0+,B2,W		;Load OCTRL
	MOVE	*B0+,B3,W		;Load OFLAGS
	MOVE	B3,*B1(OFLAGS),W
	btst	B_FLIPH,B2
	jrnz	IO_FLIP
	btst	B_FLIPV,B2
	jrz	IO_SKIPFLIP
IO_FLIP
	MMTM	SP,A4,A8
	move	B2,A4
	move	A0,A8
	;A1 still set from above
	calla	ANI
	MMFM	SP,A4,A8
	jruc	IO_FLAGSOK
IO_SKIPFLIP
	MOVE	*B1(OCTRL),B3,W
	OR	B2,B3
	move	B3,*B1(OCTRL),W
IO_FLAGSOK
	MOVE	*B0+,B2,W		;Load OZOFF

	MOVB	B2,*B1(OZOFF)

	MOVE	*B0+,B2,L		;GET THE CFUNC
	JRZ	IO_NOCFUNC
	CALL	B2			;CALL IT
IO_NOCFUNC
	MOVE	B0,A5
IO_X
	MMFM	SP,B0,B1,B2,B3
	PULL	A1
	RETS

**************************************************************************
* GET_SUPP
* Returns ptr to supplemental list header
*
* A8 = obj
* RETURNS A0 = supp list header - OSLINK (Z set if not on any list)
GET_SUPP:
	move	A8,A0
	callr	GETSUPP
	move	A14,A0
	rets

**************************************************************************
* GETSUPP
* GETSUPP_FROM_OID
* Returns ptr to supplemental list header
*
* A0 = obj
* A14 = OID FOR GETSUPP_FROM_OID
* RETURNS A14 = supp list header - OSLINK (Z set if not on any list)
GETSUPP
	move	*A0(OID),A14,W
GETSUPP_FROM_OID
	srl	SR_SUPP,A14
	jrz	NoSupp
	sll	5,A14			;convert to offset, multiple of 020H
	addi	SUPPLSTS-OSLINK,A14
NoSupp
	rets

**************************************************************************
* INSSUPP
* Inserts object onto a supplemental list
* List is selected by the SUPP field of the OID
*
* A0 = OBJ to insert
* RETURNS nothing
INSSUPP:
	callr	GETSUPP
	jrz	SkInsSupp

	.IF DEBUG
	;***** CHECK IF OBJECT IS ALREADY ON SUPPLEMENTAL LIST ******
	PUSH	A14
CkSupp:
	cmp	A14,A0
	jreq	$
	move	*A14(OSLINK),A14,L
	jrnz	CkSupp
	PULLQ	A14
	.ENDIF

	move	*A14(OSLINK),*A0(OSLINK),L
	move	A0,*A14(OSLINK),L
SkInsSupp
	rets


**************************************************************************
* INSERT_SUPP
* Inserts object onto a supplemental list
* List is selected by the SUPP field of the OID
*
* A8 = OBJ to insert
INSERT_SUPP:
  	PUSH	A0
	move	A8,A0
	callr	INSSUPP
	PULLQ	A0
	RETS


**************************************************************************
* PULLSUPP
* pulls object from a supplemental list
* List is selected by the SUPP field of the OID
*
* A0 = OBJ to pull
* RETURNS nothing
PULLSUPP:
	PUSH	A1
	callr	GETSUPP
	jrz	SkPullSupp

PulSupLp
	move	A14,A1
	move	*A14(OSLINK),A14,L
	LOCKON	Z
	cmp	A14,A0
	jrne	PulSupLp

	move	*A0(OSLINK),*A1(OSLINK),L	;link around A0
	clr	A1
	move	A1,*A0(OSLINK),L
SkPullSupp
	PULLQ	A1
	rets

**************************************************************************
* PULL_SUPP
* pulls object from a supplemental list
* List is selected by the SUPP field of the OID
*
* A8 = OBJ to insert
PULL_SUPP:
	PUSH	A0
	move	A8,A0
	callr	PULLSUPP
	PULLQ	A0
	RETS


**************************************************************************
* CNTSUPP
* COUNT THE NUMBER OF OBJECTS ON GIVEN SUPPLEMENTAL LIST.
*
* A14 = SUPPLEMENTAL LIST HEADER - OSLINK
* RETURNS A0 = OBJECT CNT (SETS THE Z BIT)
*         A14 = TRASHED
CNTSUPP:
	clr	A0
CntSupLp
	move	*A14(OSLINK),A14,L
	jrz	CNTSUPPX
	inc	A0
	cmpi	NOBJ,A0
	LOCKON	GE		;WE'VE MAXED, SOMETHING IS WRONG
	jruc	CntSupLp
CNTSUPPX
	move	A0,A0
	rets


**************************************************************************
*                                                                        *
* OBJ_OFF - TURN AN OBJECT "OFF" I.E. SET DMA OUTPUT = 0		 *
* A8 = PTR TO OBJECT BLOCK						 *
*                                                                        *
**************************************************************************
OBJ_OFF:
	MOVE	*A8(OCTRL),A14,W
	SRL	4,A14
	SLL	4,A14
	MOVE	A14,*A8(OCTRL),W
OBJ_OFF_X
	RETS

**************************************************************************
*								         *
* OBJOFF - TURN AN OBJECT "OFF" I.E. SET DMA OUTPUT = 0			 *
* 	 A0 VERSION							 *
* A0 = PTR TO OBJECT							 *
*								         *
**************************************************************************
OBJOFF
	PUSH	A8
	MOVE	A0,A8
	CALLR	OBJ_OFF
	PULLQ	A8
	RETS

**************************************************************************
*                                                                        *
* OBJ_ON - TURN AN OBJECT "ON" I.E. SET DMA OUTPUT TO WRITE <> 0	 *
* A8 = PTR TO OBJECT BLOCK						 *
*                                                                        *
**************************************************************************
OBJ_ON:
	MOVE	*A8(OCTRL),A14,W
	SRL	4,A14
	SLL	4,A14
	ADDK	DMAWNZ&0FH,A14
	MOVE	A14,*A8(OCTRL),W
OON_X
	RETS

**************************************************************************
*								         *
* OBJON - TURN AN OBJECT "ON" I.E. SET DMA OUTPUT TO WRITE <> 0		 *
* 	 A0 VERSION							 *
* A0 = PTR TO OBJECT							 *
*								         *
**************************************************************************
OBJON
	PUSH	A8
	MOVE	A0,A8
	CALLR	OBJ_ON
	PULLQ	A8
	RETS

**************************************************************************
*                                                                        *
* OBJ_CONST - Turn an object to Constant on non-zero pixels.		 *
* A8 = Ptr to object							 *
*                                                                        *
**************************************************************************
OBJ_CONST
	MOVE	*A8(OCTRL),A14,W
	SRL	4,A14
	SLL	4,A14
	addk	DMACNZ&0Fh,A14
	MOVE	A14,*A8(OCTRL),W
	RETS

**************************************************************************
*								         *
* 	OBJCONST							 *
* 									 *
* 	Turn an object to Constant on non-zero pixels.			 *
* 	A0 Version.							 *
* 									 *
* 	A0 = Ptr to object						 *
*								         *
**************************************************************************
OBJCONST
	PUSH	A8
	MOVE	A0,A8
	CALLR	OBJ_CONST
	PULLQ	A8
	RETS

**************************************************************************
*								         *
* OBJ_OFF_MULTI - TURN ALL OF THE PARTS OF A MULTI-PARTER "OFF" FROM	 *
* 		THIS OBJECT ON DOWN.					 *
* A8 = PTR TO FIRST PART TO TURN "OFF"					 *
*								         *
**************************************************************************
OBJ_OFF_MULTI
	PUSH	A8
OOFFM_LP
	CALLR	OBJ_OFF
	MOVE	*A8(OPARTS),A8,L
	JRNZ	OOFFM_LP
	PULLQ	A8
	RETS

**************************************************************************
*								         *
* OBJ_ON_MULTI - TURN ALL OF THE PARTS OF A MULTI-PARTER "ON" FROM	 *
* 		THIS OBJECT ON DOWN.					 *
* A8 = PTR TO FIRST PART TO TURN "ON"					 *
*								         *
**************************************************************************
OBJ_ON_MULTI
	PUSH	A8
OONM_LP
	CALLR	OBJ_ON
	MOVE	*A8(OPARTS),A8,L
	JRNZ	OONM_LP
	PULLQ	A8
	RETS

**************************************************************************
*								         *
* IS_OBJ_OFF - DETERMINE IF GIVEN OBJECT IS "TURNED OFF"		 *
* A8 = PTR TO OBJECT							 *
* RETURNS								 *
* 	 Z = OBJECT IS OFF						 *
* 	NZ = OBJECT IS ON						 *
* NOTE: TRASHES A14							 *
*								         *
**************************************************************************
IS_OBJ_OFF
	MOVE	*A8(OCTRL),A14,W
	SLL	28,A14
	RETS

**************************************************************************
*								         *
* OBJECTS_ON - TURN A CLASS OF OBJECTS "ON"				 *
* A0 = OID OF OBJECTS TO TURN ON					 *
* A1 = MASK (0 BITS = DON'T CARE)					 *
* A4 = DMA WRITE FLAGS (LOW FOUR BITS) TO USE.				 *
* NOTE: TRASHES A14							 *
*								         *
**************************************************************************
OBJECTS_ON:
	MMTM	SP,A2,A3,A4
	MOVI	FGLIST,A3
	MOVE	*A3(P_LSTHD),A2,L		;GET THE OBJECT LIST
	CMP	A2,A3
	JREQ	OBJSON_X
	SEXT	A0
	AND	A1,A0				;FORM MATCH
	SLL	28,A4
	SRL	28,A4				;ONLY CONCERNED WITH WRITES
OBJSON_LP:
	MOVE	*A2(OID),A14,W
	AND	A1,A14				;MASK OFF THE DON'T CARES
	CMP	A0,A14
	JRNE	OBJSON_NXT			;BR = THIS IS NOT ONE OF THEM
	ORM	A4,*A2(OCTRL),W			;ON WITH YOU
OBJSON_NXT:
	MOVE	*A2,A2,L
	CMP	A2,A3
	JRNE	OBJSON_LP			;BR = NOT FINISHED YET
OBJSON_X:
	MMFM	SP,A2,A3,A4
	RETS

**************************************************************************
*								         *
* OBJECTS_OFF - TURN A CLASS OF OBJECTS "OFF"				 *
* A0 = OID OF OBJECTS TO TURN OFF					 *
* A1 = MASK (0 BITS = DON'T CARE)					 *
* NOTE: TRASHES A14							 *
*								         *
**************************************************************************
OBJECTS_OFF:
	MMTM	SP,A2,A3

	MOVI	FGLIST,A3
	MOVE	*A3(P_LSTHD),A2,L		;GET THE OBJECT LIST
	CMP	A2,A3
	JREQ	OOFF_X
	SEXT	A0
	AND	A1,A0				;FORM MATCH
OOFF_LP:
	MOVE	*A2(OID),A14,W
	AND	A1,A14				;MASK OFF THE DON'T CARES
	CMP	A0,A14
	JRNE	OOFF_NXT			;BR = THIS IS NOT ONE OF THEM
	MOVE	*A2(OCTRL),A14,W
	SRL	4,A14
	SLL	4,A14				;OFLAGS SAY OFF!
	MOVE	A14,*A2(OCTRL),W
OOFF_NXT:
	MOVE	*A2,A2,L
	CMP	A2,A3
	JRNE	OOFF_LP				;BR = NOT FINISHED YET
OOFF_X:
	MMFM	SP,A2,A3
	RETS

**************************************************************************
*                                                                        *
* COPY_OBJ - COPIES THE CONTENTS OF ONE OBJECT BLOCK TO THE OTHER.	 *
* A0 = PTR TO DESTINATION BLOCK						 *
* A8 = PTR TO SOURCE BLOCK						 *
* NOTE: TRASHES A14							 *
*                                                                        *
**************************************************************************
COPY_OBJ:
	MMTM	SP,B0,B2,B7

	MOVE	A0,B2
	MOVE	A8,B0
	ADDI	OZVEL,B2
	ADDI	OZVEL,B0
	MOVI	OBSIZ-OZVEL,B7

	.if XUNIT=1
	BLMOVE	1,1
	.else
	srl	5,b7
_omove:
	move	*b0+,*b2+,L
	dsjs	b7,_omove
	.endif

	MOVE	*A0(OFLAGS),A14,W
	ANDNI	M_ANIM,A14		;CLEAR ANY IRRELEVANT FLAGS HERE
	MOVE	A14,*A0(OFLAGS),W

	MMFM	SP,B0,B2,B7
	RETS

**************************************************************************
*								         *
* 	CREATE_COPY							 *
* 									 *
* 	Create an exact copy of the given object.			 *
* 									 *
* 	A8 = Ptr to object to copy					 *
* 									 *
* 	Returns:							 *
* 		 Z = Failure allocating copy, A0 = 0			 *
* 		NZ = Copy created successfully, A0 = Ptr to copy	 *
*								         *
**************************************************************************
CREATE_COPY
	CALLR	GETOBJ
	JRZ	CC_X
	CALLR	COPY_OBJ
	PUSH	A5
	MOVE	*A0(OPAL),A5,W
	CALLA	INC_PALCNT
	PULLQ	A5
	MOVE	A0,A0
CC_X
	RETS

**************************************************************************
*								         *
* OBJ_TO_PNT - PUT AN OBJECT DIRECTLY ON A POINT.			 *
* 		WILL ALSO ADJUST THE SLAVE OBJECTS HANGING		 *
* 		OFF OF THIS OBJECT.					 *
* A3 = [Y,X] POINT							 *
* A8 = PTR TO OBJECT							 *
*								         *
**************************************************************************
OBJ_TO_PNT:
	PUSH	A1
	MOVE	A3,A1
	CALLR	SET_ANIP
	PULLQ	A1
	RETS

**************************************************************************
*								         *
* OBJTOPNT - PUT AN OBJECT DIRECTLY ON A POINT (A0 VERSION)		 *
* A0 = PTR TO OBJECT							 *
* A3 = [Y,X] POINT							 *
*								         *
**************************************************************************
OBJTOPNT:
	PUSH	A1
	MOVE	A3,A1
	CALLR	SETANIP
	PULLQ	A1
	RETS

**************************************************************************
*								         *
* CLEAR_OPLINKS - ROUTINE TO CLEAR THE OPLINKS FOR ALL ACTIVE OBJECTS	 *
* 		ON ALL PLANES.						 *
*								         *
**************************************************************************
CLEAR_OPLINKS
	PUSH	A7
	MOVI	CLEAR_OPLINK,A7
	CALLR	FGPLANE_LP
	PULLQ	A7
	RETS

CLEAR_OPLINK
	CLR	A14
	MOVE	A14,*A8(OPLINK),L
	RETS

**************************************************************************
*								         *
* STOPOBJS - ROUTINE TO CLEAR VELOCITIES OF ALL OBJECTS ON ALL PLANES.	 *
*								         *
**************************************************************************
STOPOBJS
	PUSH	A7
	MOVI	STOPOBJ,A7
	CALLR	FGPLANE_LP
	PULLQ	A7
	RETS

**************************************************************************
*								         *
* CLR_VEL - CLEAR ALL VELOCITIES OF OBJECT				 *
* A8 = PTR TO OBJECT							 *
*								         *
**************************************************************************
CLR_VEL
STOPOBJ
	CLR	A14
	MOVE	A14,*A8(OYACCEL),W
	MOVE	A14,*A8(OXVEL),L
	MOVE	A14,*A8(OYVEL),L
	MOVE	A14,*A8(OZVEL),L
	RETS

**************************************************************************
*								         *
* CLRVEL - CLEAR VELOCITIES OF OBJECT IN A0				 *
* A0 = PTR TO OBJECT							 *
*								         *
**************************************************************************
CLRVEL
	PUSH	A8
	MOVE	A0,A8
	CALLR	CLR_VEL
	PULLQ	A8
	RETS

**************************************************************************
*								         *
* CHANGE_OID - ROUTINE TO CHANGE THE OID OF AN ACTIVE OBJECT.  THIS	 *
* 		MUST BE USED TO HANDLE CORRECT SUPP LIST		 *
* 		SWITCHING.						 *
* A1 = NEW OID								 *
* A8 = PTR TO OBJECT							 *
*								         *
**************************************************************************
CHANGE_OID
	CALLR	PULL_SUPP		;GET IT OFF ITS CURRENT LIST
	MOVE	A1,*A8(OID),W		;SHOW US THE WAY
	JRUC	INSERT_SUPP		;AND PUT IT ON THE NEW LIST


**************************************************************************
*								         *
* CHANGE_OID_MULTI - Change the OID of every object in a Multiparter	 *
* 			including and after the given object.		 *
* A1 = New OID								 *
* A8 = Ptr to first part to change					 *
*								         *
**************************************************************************
CHANGE_OID_MULTI
	PUSH	A8
COM_LP
	CALLR	CHANGE_OID
	MOVE	*A8(OPARTS),A8,L
	JRNZ	COM_LP
	PULLQ	A8
	RETS

**************************************************************************
*								         *
* CHANGEOID - ROUTINE TO CHANGE THE OID OF AN ACTIVE OBJECT.  THIS	 *
* 		MUST BE USED TO HANDLE CORRECT SUPP LIST		 *
* 		SWITCHING.						 *
* 		A0 VERSION.						 *
* A0 = PTR TO OBJECT							 *
* A1 = NEW OID								 *
*								         *
**************************************************************************
CHANGEOID
	CALLR	PULLSUPP		;GET IT OFF ITS CURRENT LIST
	MOVE	A1,*A0(OID),W		;SHOW US THE WAY
	JRUC	INSSUPP			;AND PUT IT ON THE NEW LIST

**************************************************************************
*								         *
* CHANGE_OIDS - CHANGE ALL MATCHING OID'S ON EVERY PLANE TO A NEW ONE.	 *
* A0 = OID TO CHANGE							 *
* A1 = NEW OID								 *
*								         *
**************************************************************************
CHANGE_OIDS
	PUSH	A7
	MOVI	CHANGE1OID,A7
	CALLR	FGPLANE_LP
	PULLQ	A7
	RETS

CHANGE1OID
	MOVE	*A8(OID),A14,W
	CMP	A0,A14
	JRNE	CHNG1X			;THIS IS NOT ONE OF THEM
	CALLR	PULL_SUPP
	MOVE	A1,*A8(OID),W		;STUFF THE NEW ONE
	CALLR	INSERT_SUPP
CHNG1X
	RETS

**************************************************************************
*								         *
* FGPLANE_LP - VERY GENERIC ROUTINE TO APPLY A FUNCTION TO EVERY	 *
* 		OBJECT ON THE FOREGROUND PLANE.				 *
* A7 = PTR TO FUNCTION							 *
*								         *
**************************************************************************
FGPLANE_LP
	MMTM	SP,A8,A9
	MOVI	FGLIST,A8
	MOVE	A8,A9
	JRUC	FGP_TST
FGP_LP
	CALL	A7
FGP_TST
	MOVE	*A8,A8,L
	CMP	A8,A9
	JRNZ	FGP_LP

	MMFM	SP,A8,A9
	RETS

**************************************************************************
*								         *
* STORE_ZVAL - STORE THE GIVEN 32 BIT Z VALUE IN THE OBJECT AND ALL	 *
* 		OF ITS PARTS. PARTS WILL HAVE ZVAL CHANGED BY OZOFF.	 *
* A1 = ZVAL								 *
* A8 = OBJECT (HEAD IF MULTI-PARTER)					 *
*								         *
**************************************************************************
STORE_ZVALH
;alternate entry point to use OZOFF for head obj
	PUSH	A8
	jruc	SZ_LP
STORE_ZVAL
	PUSH	A8
	MOVE	A1,*A8(OZVAL),L		;SET HEAD OBJECT, NO OZOFF USED
	MOVE	*A8(OPARTS),A8,L	;MORE PARTS?
	JRZ	SZ_X			;BR = NO
SZ_LP
	MOVB	*A8(OZOFF),A14
	ADD	A1,A14
	MOVE	A14,*A8(OZVAL),L
	MOVE	*A8(OPARTS),A8,L	;IS THERE ANOTHER PART?
	JRNZ	SZ_LP			;BR = YES
SZ_X
	PULLQ	A8
	RETS

**************************************************************************
*								         *
* STOREZVAL - STORE THE GIVEN 32 BIT Z VALUE IN THE OBJECT AND ALL	 *
* 		OF ITS PARTS. ALL WILL HAVE ZVAL CHANGED BY OZOFF.	 *
* 		A0 VERSION						 *
* A0 = OBJECT (HEAD IF MULTI-PARTER)					 *
* A1 = ZVAL								 *
*								         *
**************************************************************************
STOREZVAL
	PUSH	A8
	MOVE	A0,A8
	CALLR	STORE_ZVALH
	PULLQ	A8
	RETS

**************************************************************************
*								         *
* KILOBJ_ALL - KILL ALL OBJECTS OF THE GIVEN I.D.			 *
* A0 = OID (16 BITS)							 *
*								         *
**************************************************************************
KILOBJ_ALL:
	PUSH	A1
	CLR	A1
	NOT	A1
	CALLR	KILOBJ
	PULLQ	A1
	RETS


**************************************************************************
*								         *
* KILOBJ - KILL A CLASS OF OBJECTS ON ALL FOREGROUND PLANES		 *
* A0 = OID (16 BITS)							 *
* A1 = MASK: MASK BITS OF ZERO ARE DONT CARES (16 BITS)			 *
*								         *
**************************************************************************
KILOBJ
	MMTM	SP,A0,A2,A3,A8
	MOVI	FGLIST,A8

	MOVE	A0,A2
	SEXT	A2
	AND	A1,A2		;FORM MATCH

	MOVE	A8,A0
	JRUC	KO_TST
KO_LP
	MOVE	*A0(OID),A14,W
	AND	A1,A14		;CAN DONT CARE BITS
	CMP	A2,A14		;MATCH?
	JRNE	KO_TST		;NO

	MOVE	*A0,A3,L
	CALLR	DELOBJ
	MOVE	A3,A0
	JRUC	KO_TST2
KO_TST
	MOVE	*A0,A0,L
KO_TST2
	CMP	A0,A8
	JRNE	KO_LP

	MMFM	SP,A0,A2,A3,A8
	RETS

**************************************************************************
*								         *
* EXISTOBJ_ALL - FIND ANY OCCURANCE OF AN OBJECT OF GIVEN I.D.		 *
* A0 = OID								 *
* RETURNS:								 *
* 	Z BIT SET = NO OBJECT, A0 = 0					 *
* 	Z BIT CLR = OBJECT, A0 = PTR TO OBJECT				 *
*								         *
**************************************************************************
EXISTOBJ_ALL
	PUSH	A1
	CLR	A1
	NOT	A1
	CALLR	EXISTOBJ
	PULL	A1
	RETS

**************************************************************************
*								         *
* 	EXIST_OBJ_ALL							 *
* 									 *
* 	Find any occurance of an object of Given I.D.			 *
* 									 *
* 	A0 = OID							 *
* 									 *
* 	Returns:							 *
* 		 Z = No object found, A8 = 0				 *
* 		NZ = Found match, A8 = Ptr to object			 *
*								         *
**************************************************************************
EXIST_OBJ_ALL
	PUSH	A0
	CALLA	EXISTOBJ_ALL
	MOVE	A0,A8
	PULL	A0
	RETS

**************************************************************************
*								         *
* 	RESUME_EXIST_OBJ_ALL						 *
* 									 *
* 	Resume search for objects of given I.D.				 *
* 									 *
* 	A0 = OID							 *
* 	A8 = Last object found						 *
* 									 *
* 	Returns:							 *
* 		 Z = No more objects found, A8 = 0			 *
* 		NZ = Found another one, A8 = Ptr to object		 *
*								         *
**************************************************************************
RESUME_EXIST_OBJ_ALL
	MMTM	SP,A0,A1
	CLR	A1
	NOT	A1
	CALLR	RESUME_EXIST_OBJ
	MOVE	A0,A8
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*								         *
* 	RESUME_EXISTOBJ							 *
* 									 *
* 	Entrypoint to EXISTOBJ, where you give the starting		 *
* 	point of the search.						 *
* 									 *
* 	A0 = OID to search for						 *
* 	A1 = OID mask (0 bits mean "don't care")			 *
* 	A8 = Search entrypoint, non-inclusive				 *
* 									 *
* 	Returns:							 *
* 									 *
* 		 Z = No object found, A0 = 0				 *
* 		NZ = Matching object found, A0 = Ptr to object		 *
*								         *
**************************************************************************
RESUME_EXIST_OBJ
	MMTM	SP,A2,A8
	MOVE	A0,A2
	SEXT	A2
	AND	A1,A2		;FORM MATCH
	MOVE	A8,A0
	MOVI	FGLIST,A8
	JRUC	EO_TST

**************************************************************************
*								         *
* 	EXISTOBJ							 *
* 									 *
* 	Search for an object of certain class on the foreground		 *
* 	list.								 *
* 									 *
* 	A0 = OID							 *
* 	A1 = OID Mask (0 bits mean "don't care")			 *
* 									 *
* 	Returns:							 *
* 									 *
* 		 Z = No object found, A0 = 0				 *
* 		NZ = Matching object found, A0 = Ptr to object		 *
*								         *
**************************************************************************
EXISTOBJ
	MMTM	SP,A2,A8
	MOVI	FGLIST,A8

	MOVE	A0,A2
	SEXT	A2
	AND	A1,A2		;FORM MATCH

	MOVE	A8,A0
	JRUC	EO_TST

EO_LP
	MOVE	*A0(OID),A14,W
	AND	A1,A14		;CAN DONT CARE BITS
	CMP	A2,A14		;MATCH?
	JREQ	EO_X		;YES!

EO_TST
	MOVE	*A0,A0,L	;GET NEXT OBJECT
	CMP	A0,A8		;IS THAT ALL?
	JRNE	EO_LP		;BR = NO, TRY MORE
	CLR	A0		;FAILED
EO_X
	MOVE	A0,A0

	MMFM	SP,A2,A8
	RETS

**************************************************************************
*								         *
* COUNT_HEADS - COUNT ONLY THE HEAD PARTS OF MULTI-PART OBJECTS.	 *
* A0 = OID (16 BITS) TO COUNT						 *
* A1 = MASK: MASK BITS OF ZERO ARE DONT CARES (16 BITS)			 *
* RETURNS								 *
* 	A6 = COUNT							 *
*								         *
**************************************************************************
COUNT_HEADS
	MMTM	SP,A0,A2,A3

	MOVE	A0,A3
	SEXT	A3
	AND	A1,A3		;FORM MATCH

	CLR	A6

	MOVI	FGLIST,A2

	MOVE	A2,A0
	JRUC	CHP_TST

CHP_LP
	MOVE	*A0(OID),A14
	AND	A1,A14		;CAN DONT CARE BITS
	CMP	A3,A14		;MATCH?
	JRNE	CHP_TST		;NO

	MOVE	*A0(OPART1),A14,L
	JRNZ	CHP_HEAD_TST	;BR = A MULTI-PARTER
	INC	A6		;COUNT THE SOLO OBJECT
	JRUC	CHP_TST
CHP_HEAD_TST
	CMP	A0,A14		;IS THIS THE HEAD?
	JRNE	CHP_TST		;BR = NO
	INC	A6
CHP_TST
	MOVE	*A0,A0,L
	CMP	A0,A2
	JRNE	CHP_LP

	MMFM	SP,A0,A2,A3
	RETS

**************************************************************************
*								         *
* FIND_HEAD - FIND A HEAD PART ON A PLANE THAT MATCHES THE		 *
* 		  GIVEN I.D.						 *
* A0 = OID (16 BITS) TO COUNT						 *
* A1 = MASK: MASK BITS OF ZERO ARE DONT CARES (16 BITS)			 *
* RETURNS								 *
* 	 Z = NONE FOUND							 *
* 		A0 = 0							 *
* 	NZ = FOUND ONE							 *
* 		A0 = PTR TO OBJECT					 *
*								         *
**************************************************************************
FIND_HEAD
	MMTM	SP,A2,A3

	MOVE	A0,A3
	SEXT	A3
	AND	A1,A3		;FORM MATCH
	MOVI	FGLIST,A2
	MOVE	A2,A0
	JRUC	FHP_TST

FHP_LP
	MOVE	*A0(OID),A14
	AND	A1,A14		;CAN DONT CARE BITS
	CMP	A3,A14		;MATCH?
	JRNE	FHP_TST		;NO

	MOVE	*A0(OPART1),A14,L
	JRZ	FHP_TST		;BR = NOT A MULTI-PARTER
	CMP	A0,A14		;IS THIS THE HEAD?
	JRNE	FHP_TST		;BR = NO
	MOVE	A0,A0
	JRUC	FHP_X
FHP_TST
	MOVE	*A0,A0,L
	CMP	A0,A2
	JRNE	FHP_LP
     	CLR	A0
FHP_X
	MMFM	SP,A2,A3
	RETS

**************************************************************************
*								         *
* SET_SCRNOBJ								 *
* IN:  A1, [Y,X]							 *
*      A2, long ZVAL							 *
*      a8, object							 *
* OUT: NUTN'								 *
*								         *
**************************************************************************

SET_SCRNOBJ
	MMTM	SP,A8,A0
	MOVE	A1,A0
SS_PART_LUPE
	MOVE	A0,A1
	MOVE	*A8(OANIOFF),A14,L
	SUBXY	A14,A1
	MOVE	A1,*A8(ODAG),L
	MOVE	A1,*A8(OXPOS),W
	SRL	16,A1
	MOVE	A1,*A8(OYPOS),W
	MOVE	A2,*A8(OZVAL),L
	MOVE	*A8(OPARTS),A8,L
	JRNZ	SS_PART_LUPE
	MMFM	SP,A8,A0
	RETS

**************************************************************************
*								         *
* SET_MANSCALE								 *
*  a1 = scale								 *
*  a8 = object								 *
*								         *
**************************************************************************
SET_MANSCALE
	move	a8,a14
sms1	move	a1,*a14(ONuManScl)
	move	*a14(OPARTS),a14,L
	jrnz	sms1
	rets

**************************************************************************
*								         *
* find_screen_from_world						 *
* find_screen_from_world_zero_y						 *
* 	input  a0 = world x						 *
* 	       a1 = world z						 *
* 	       a2 = world y						 *
* 	output a0 = screen x						 *
* 	       a1 = screen y						 *
* 	  Yscreen = y - (z * h) / (d1 + z) - worldy + HALFY		 *
* 	  Xscreen = ((x - worldx) * sc) + HALFX				 *
* 	    where sc = scale for z = d1 / (d1 + z)			 *
*								         *
**************************************************************************
find_screen_from_world_zero_y
	clr	a2
find_screen_from_world
	sra	16,a0
	sra	16,a1
	sra	16,a2
	move	@WORLDX+010h,a3,W
	move	@WORLDY+010h,a4,W
	sub	a0,a3
	neg	a3
	sub	a4,a2
	addi	HALFY,a2
	move	a1,a5
	sll	4,a5
	addi	zybase_table,a5
	move	*a5,a1,W
	sub	a2,a1
	neg	a1
	addi	xzy_offset,a5
	move	*a5,a5
	mpys	a5,a3
	move	a3,a0
	sll	2,a0
	addi	HALFX<<16,a0
	sll	16,a1
	rets

**************************************************************************
*								         *
* find_world_from_screen						 *
* 	input  a0 = screen x						 *
* 	       a1 = screen y						 *
* 	output a0 = world x						 *
* 	       a1 = world z (assume we want a 0 world y)		 *
* 	  first we take and get an adjusted y				 *
* 	     Yk = Yscreen + worldy - halfy				 *
* 	  then we compute z based on Yk					 *
* 	     z = (-d1 * yk) / (yk + h)	;uses a table lookup for this	 *
* 	  then we compute x based on z and our old x			 *
* 	     x = ((Xscreen - halfx) / sc) + worldx			 *
* 	      where sc = scale for z = d1/(d1 + z)			 *
*                we multiply by a table lookup for 1/sc			 *
*								         *
**************************************************************************
find_rworld_from_z	;a2 = z
	movi	HALFX,a0
	jruc	fwfs
find_lworld_from_z
	movi	-HALFX,a0
	jruc	fwfs
find_world_from_screen
	sra	16,a1		;convert y down to short form
	move	@WORLDY+010h,a2,W
	add	a2,a1
	subi	HALFY,a1
	sll	4,a1
	addi	fws_table,a1
	move	*a1,a1,W
	move	a1,a2		;save if for x calculation
	sll	16,a1		;convert it to long	;now a1 = z
	sra	16,a0		;convert it down to short form
	subi	HALFX,a0
fwfs	sll	5,a2
	addi	zscale_100_100_table,a2 ;we use dma scale for 100% because it is inv
	move	*a2,a2,W
	sll	8,a2		;if we shift now, we don't shift later
	mpys	a0,a2
	move	a3,a0
	move	@WORLDX,a2,L
	add	a2,a0
	rets

set_scrnobj_to_pos	;a0 = xy
			;no flips
	move	*a8(OIMG),a9,L
	move	*a9(050h),a1,L
	subxy	a1,a0
	move	a0,*a8(ODAG),L
	rets
