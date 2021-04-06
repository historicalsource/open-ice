 	.MLIB	"HHMACS.LIB"
	.FILE	"HHMATH.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

	.INCLUDE	"HH.INC"
	.include	"hhmath.e"
	.include	"hhmisc.g"
	.include	"hhutil.g"
	.include	"hhd.g"
	.include	"hhpuck.g"

; end of include files


	.text
	.even

	.bss	cdist_store_a5,32
	.bss	cdist_store_a4,32
	.bss	cdist_store_angle,32

**************************************************************************
*								         *
* GETSIN								 *
* ; PARMS   - A0 = theta in s15.16					 *
* ; RETURNS - A0 = sin(theta) in s15.16					 *
*								         *
**************************************************************************
GETSIN
	THETA_N	a0
	sra	13,A0
	sll	5,A0
	addi	sin_table,A0
	move	*A0,A0,L
	rets

**************************************************************************
*								         *
* GETCOS								 *
* ; PARMS   - A0 = theta in s15.16					 *
* ; RETURNS - A0 = cos(theta) in s15.16					 *
*								         *
**************************************************************************
GETCOS
	THETA_N	a0
	sra	13,A0
	sll	5,A0
	addi	cos_table,a0
	move	*A0,A0,L
	rets

**************************************************************************
*								         *
* GETSINCOS								 *
* ; PARMS   - A0 = theta in s15.16					 *
* ; RETURNS - A0 = sin(theta) in s15.16					 *
* ; RETURNS - A1 = cos(theta) in s15.16					 *
*								         *
**************************************************************************
GETSINCOS
	THETA_N	a0
	sra	13,a0
	sll	5,a0
	addi	sin_table,a0
	move	*a0(cos_table-sin_table),a1,L
	move	*a0,a0,L
	rets

**************************************************************************
*								         *
* GETATAN								 *
* ; PARMS   - A0 = tangent in s15.16 (must be from angle < pi/4)	 *
* ; RETURNS - A0 = theta in s15.16					 *
* ;mdp	note: more resolution for angles closer to pi/4			 *
*								         *
**************************************************************************
GETATAN
	srl	7,a0
	sll	5,a0
	addi	ATAN_TABLE,a0
	move	*a0,a0,L
	rets

**************************************************************************
*								         *
* get_correct_y_velocity						 *
* 	input	a3 = distance						 *
* 		a1 = horizontal velocity				 *
* 		a2 = y position						 *
* 	output	a3 = y velocity						 *
*								         *
**************************************************************************
get_correct_y_velocity
	move	a3,a0
	jrz	gcyv9
	callr	DIV		;a1 = d/v = time
	move	a2,a0
	move	a1,a2		;save time
	callr	DIV		;a1 = Y/t
	move	a1,a3		;save Y/t
	movi	[0,1500h],a0	;1/2 gravity (was [0,1800h])
	move	a2,a1
	callr	MULT		;a1 = 1/2 a * time
	sub	a1,a3		;a3 = velocity
gcyv9	rets

**************************************************************************
*								         *
* SQUARE								 *
* 	squares a number in the form s15:16 and returns s15:16		 *
* input:   a1 = s15:16 number						 *
* output   a1 = s15:16 number						 *
*								         *
**************************************************************************
SQUARE	mmtm	sp,a0,a2
	move	a1,a0
	sra	4,a0
	mpys	a0,a0
	sll	16,a0
	move	a1,a2
	srl	16,a2
	movx	a2,a0
	sll	8,a0
	srl	8,a1
	movy	a0,a1
	mmfm	sp,a0,a2
	rets

**************************************************************************
*								         *
* MULT									 *
* 	multiplies two numbers in the form s15:16 and returns s15:16	 *
* input    a0 = s15:16 number						 *
*          a1 = s15:16 number						 *
* output   a1 = s15:16 number						 *
*								         *
**************************************************************************
MULT
	.if	DEBUG

	CALLR	SAFEMULT
	LOCKON	NC
	RETS

	.endif
QMULT
	mmtm	sp,a0,a2
	sra	4,a0
	sra	4,a1
	mpys	a1,a0
	sll	16,a0
	move	a1,a2
	srl	16,a2
	movx	a2,a0
	sll	8,a0
	srl	8,a1
	movy	a0,a1
	mmfm	sp,a0,a2
	rets

**************************************************************************
*								         *
* SAFEMULT - same as MULT, but flags overflow with C clear		 *
*								         *
**************************************************************************

SAFEMULT
	mmtm	sp,a0,a2
	sra	4,a0
	sra	4,a1
	mpys	a1,a0
	move	a0,a2		;store our high order r into a2 (temp
	sra	7,a2		;we just want to look at top 25 bits
	NEG	A2		;a2 = 0 or 1 on no overflow
	srl	1,a2		;drop our 1 bit
	jrnz	mulerr		;if we have anything left, we have overflow
	sll	16,a0
	move	a1,a2
	srl	16,a2
	movx	a2,a0
	sll	8,a0
	srl	8,a1
	movy	a0,a1
	mmfm	sp,a0,a2
	setc
	rets
mulerr	mmfm	sp,a0,a2
	clrc
	rets

**************************************************************************
*								         *
* DIV									 *
* 	divides two numbers in the form s15:16 and returns s15:16	 *
* input    a0 = s15:16 number						 *
*          a1 = s15:16 number						 *
* output   a1 = s15:16 number (a0 / a1)					 *
*								         *
**************************************************************************
DIV
	.if	DEBUG

	CALLR	SAFEDIV
	LOCKON	V
	RETS

	.else

	mmtm	sp,a0,a2
	move	a1,a2
	move	a0,a1
	sll	16,a1
	sra	16,a0
	divs	a2,a0
	move	a0,a1
	mmfm	sp,a0,a2
	rets

	.endif

**************************************************************************
*								         *
* DIV									 *
* 	divides two numbers in the form s15:16 and returns s15:16	 *
* input    a0 = s15:16 number						 *
*          a1 = s15:16 number						 *
* output   a1 = s15:16 number (a0 / a1)					 *
*          V SET IF OVERFLOW						 *
*								         *
**************************************************************************
SAFEDIV
	mmtm	sp,a0,a2
	move	a1,a2
	move	a0,a1
	sll	16,a1
	sra	16,a0
	divs	a2,a0
	JRV	SAFEDIV_ABORT		;BR=WE HAVE AN OVERFLOW, ABORT!
	move	a0,a1
SAFEDIV_ABORT
	mmfm	sp,a0,a2
	rets

**************************************************************************
*								         *
* SQUARE_ROOT								 *
* 	to get square root of a s15:16 number, we get the squareroot	 *
* 	of it as a 32 bit and then we shift left 8 bits			 *
* input:   a1 = s15:16 number (unsigned)				 *
* output:  a1 = s15:16 square root (unsigned)				 *
*								         *
**************************************************************************
SQUARE_ROOT
	callr	SQROOT
	sll	8,a1
	rets

**************************************************************************
*                                                                        *
*  SQROOT                                                                *
*                                                                        *
*  Jason's square root routine !!                                        *
*                                                                        *
*  Input:   A1 = 32 bit number (unsigned)                                *
*  Returns: A1 = 16 bit square root (integer)                            *
*                                                                        *
**************************************************************************
SQROOT	mmtm	sp,a0
	srl	5,a1
	lmo	a1,a0
	neg	a0
	addk	32,a0
	clr	a14	;# to shift left when we're done
	subk	10,a0
	jrle	sqg
	inc	a0
	srl	1,a0
	move	a0,a14
	sll	1,a0
	neg	a0
	srl	a0,a1
sqg	sll	3,a1
	addi	sqroot_tab,a1
	movb	*a1,a1
	sll	32-8,a1
	srl	32-8,a1
	sll	a14,a1
	mmfm	sp,a0
	rets

**************************************************************************
*								         *
* polar_to_rect: convert from a polar velocity (theta and r)		 *
*                        to a rectangular velocity (x and z)		 *
* 	input:  a0 = angle						 *
* 	        a1 = velocity						 *
* 	output: a0 = x velocity						 *
* 	        a1 = z velocity						 *
*								         *
**************************************************************************
polar_to_rect
	mmtm	sp,a2,a3,a4,a5
	move	a1,a2
	move	a1,a4
	callr	GETSINCOS
	mpys	a1,a2
	sll	16,a2
	srl	16,a3
	movx	a3,a2
	mpys	a0,a4
	sll	16,a4
	srl	16,a5
	movx	a5,a4
	move	a4,a1
	move	a2,a0
	mmfm	sp,a2,a3,a4,a5
	rets

**************************************************************************
*								         *
* rect_to_polar: convert from a rectangular velocity (x and z)		 *
*                        to a polar velocity (theta and r)		 *
* 	THIS IS MUCH SLOWER THAN POLAR TO RECTANGULAR			 *
* 	input:  a0 = x velocity						 *
* 	        a1 = z velocity						 *
* 	output: a0 = angle						 *
* 	        a1 = velocity						 *
* rect_to_dir: convert from a rectangular velocity (x and z)		 *
*                        to a polar angle (theta)			 *
* 	THIS IS MUCH SLOWER THAN POLAR TO RECTANGULAR			 *
* 	input:  a0 = x velocity						 *
* 	        a1 = z velocity						 *
* 	output: a0 = angle						 *
* 									 *
* 	we split the circle into 8 parts				 *
* 	 0     < a < pi/4   a = atan(y/x)				 *
* 	 pi/4  < a < pi/2   a = pi/2 - atan(x/y)			 *
* 	 pi/2  < a < 3pi/4  a = pi/2 + atan(-x/y)			 *
* 	 3pi/4 < a < pi     a = pi - atan(y/-x)				 *
* 	 pi    < a < 5pi/4  a = pi + atan(-y/-x)			 *
* 	 5pi/4 < a < 3pi/2  a = 3pi/2 - atan(-x/-y)			 *
* 	 3pi/2 < a < 7pi/4  a = 3pi/2 + atan(x/-y)			 *
* 	 7pi/4 < a < 2pi    a = 2pi - atan(-y/x)			 *
*								         *
**************************************************************************
rect_to_dir
	PUSH	a1
	callr	rttd
	PULLQ	a1
	rets
rttd	mmtm	sp,a3,a4,a5,a6,a7
	clr	a6		;set for just direction
	jruc	rtpa
rect_to_polar
	mmtm	sp,a3,a4,a5,a6,a7
	movk	1,a6		;set for both direction and magnitude
rtpa
	move	a0,a4		;save x
	srl	31,a4		;move sign of x into bit 0
	sll	1,a4		;and over to bit 1
	move	a1,a5		;test sign of z
	jrnn	rtp1		;br= z not negative, leave sign alone
	inc	a4		;z sign into bit 0.  a4 = sign bits of x and z
rtp1	abs	a0		;get abs of x
	move	a0,a3		;save abs x for magnitude
	abs	a5		;get abs of z
	move	a5,a7		;save abs z for magnitude
	cmp	a5,a0		;compare x and z magnitudes
	jrlt	rtpxz		;br= x magnitude less than z
	addk	4,a4		;now a4 is bitwise x>z:signx:signz
	swap	a5,a0		;for z < x, swap registers for divide
rtpxz	move	a0,a1		;put into register pair a0:a1 for divide
	sra	16,a0		;move mantissa down
	sll	16,a1		;move fraction up
	move	a5,a5		;check for divide by zero, we are stopped
	jrz	rtp_stp		;br= we are stopped
	divs	a5,a0		;tan now in a0
	callr	GETATAN		;now a0 is angle 0 - pi/4
	sll	5,a4		;now get address to jump to to finish
	addi	rtp_table,a4
	move	*a4,a4,L
	jump	a4
rtp_stp	clr	a0		;direction is cleared for stopped puck
	jruc	smag		;now finish with magnitude if necessary
rtp_table	.long	sqd12	;(x)<(z), x positive, z positive
		.long	sqd41	;(x)<(z), x positive, z negative
		.long	sqd21	;(x)<(z), x negative, z positive
		.long	sqd32	;(x)<(z), x negative, z negative
		.long	sqd11	;(x)>(z), x positive, z positive
		.long	sqd42	;(x)>(z), x positive, z negative
		.long	sqd22	;(x)>(z), x negative, z positive
		.long	sqd31	;(x)>(z), x negative, z negative
sqd12	movi	XD0900,a1	;angle is p/2 - atan x/y
	jruc	sqi
sqd21	movi	XD0900,a1	;angle is p2 + atan -x/y
	add	a1,a0
	jruc	smag
sqd22	movi	XD1800,a1		;angle is p - atan y/-x
	jruc	sqi
sqd31	movi	XD1800,a1		;angle is p + atan y/x
	add	a1,a0
	jruc	smag
sqd32	movi	XD2700,a1	;angle is 3p/2 - atan x/y
	jruc	sqi
sqd41	movi	XD2700,a1	;angle is 3p/2 + atan x/-y
	add	a1,a0
	jruc	smag
sqd42	movi	XD3600,a1		;angle is 2p - atan -y/x
sqi	sub	a0,a1
	move	a1,a0
sqd11				;angle is atan y/x
smag	move	a6,a6		;if we just want direction, leave
	jrz	smg9		;br= just direction
	sra	16,a3
	move	a3,a1
	mpys	a1,a3
	sra	16,a7
	move	a7,a1
	mpys	a7,a1
	add	a3,a1
	callr	SQROOT
	sll	16,a1
smg9	mmfm	sp,a3,a4,a5,a6,a7
	rets

**************************************************************************
*								         *
* find_dsquared_to_point	finds squared distance from one point to *
* find_dis_to_point		find distance from one point to another	 *
* find_dir_to_point		find angle from one point to another	 *
* find_dirdis_to_point	find distance and angle from 1 point to another	 *
* 									 *
* input		a0 = xval of point 2					 *
* 		a1 = zval of point 2					 *
* 		a2 = xval of point 1					 *
* 		a3 = zval of point 1					 *
* output	a0 = angle	(if output)				 *
* 		a1 = distance	(if output)				 *
* 		a4 = distance	(if output)				 *
*								         *
**************************************************************************
find_dis_to_point_whole
	mmtm	sp,a0,a1,a2
	setf	12,1,1		;quicken multiplies (12 is about the limit we can safely go)
	sub	a2,a0		;x distance
	sub	a3,a1		;z distance
	addi	[0,08000h],a0			;half
	sra	16,a0
	sra	16,a1
	mpys	a1,a1
	move	a1,a2
	move	a0,a1
	mpys	a1,a1
	add	a2,a1
	callr	SQROOT
	move	a1,a4		;***** NOTE ***** here we assume SQROOT resets field size to 32 bits
	setf	32,0,1		;(it doesn't anymore, so we do here)
	mmfm	sp,a0,a1,a2
	rets

find_dsquared_to_point_whole
	mmtm	sp,a0,a1,a2
	setf	12,1,1		;quicken multiplies (12 is about the limit we can safely go)
	sub	a2,a0		;x distance
	sub	a3,a1		;z distance
	addi	[0,08000h],a0			;half
	sra	16,a0
	sra	16,a1
	mpys	a1,a1
	move	a1,a2
	move	a0,a1
	mpys	a1,a1
	add	a2,a1
	move	a1,a4
	setf	32,0,1
	mmfm	sp,a0,a1,a2
	rets

find_dsquared_to_point_whole_a1
	mmtm	sp,a0,a2
	setf	12,1,1
	sub	a2,a0		;x distance
	sub	a3,a1		;z distance
	addi	[0,08000h],a0			;half
	sra	16,a0
	sra	16,a1
	mpys	a1,a1
	move	a1,a2
	move	a0,a1
	mpys	a1,a1
	add	a2,a1
	setf	32,0,1
	mmfm	sp,a0,a2
	rets

dir_to_182
	move	a0,a11
	srl	16+3,a11	;angles/8
	sll	3,a11		;bytes
	addi	dt182_tab,a11
	movb	*a11,a0
	rets

dt182_tab
	.byte	3,3,3,3,3,3,5,5,5,5,5,5,5,5,5,5
	.byte	5,7,7,7,7,7,7,7,7,7,7,7,7,1,1,1
	.byte	1,1,1,1,1,1,1,1,3,3,3,3,3,3,3,3
	.byte	3,3,3,3

	.even

**************************************************************************
*								         *
* find_dir_to_point_18 - FROM POINT A TO B				 *
* 									 *
* PASS:									 *
* A0 = X POSITION OF POINT B						 *
* A1 = Z POSITION OF POINT B						 *
* A2 = X POSITION OF POINT A						 *
* A3 = Z POSITION OF POINT A						 *
* RETURN:								 *
* A0 = DIRECTION (1 THROUGH 8)						 *
* 									 *
* THRASHES: A1, A11							 *
*								         *
**************************************************************************
find_dir_to_point_18
	move	a0,a11
	sub	a2,a11
	jrn	fexn			;x is negative
fexp	sub	a3,a1			;x is positive
	jrn	fexpzn			;x is positive, z is negative
fexpzp	cmp	a1,a11			;x is positive, z is positive
	jrgt	fexpgzp			;x is positive and greater than z is positive
fexplzp	movi	27146,a0		;x is positive and less than z is positive
	callr	QMULT				;tan 22.5
	cmp	a11,a1
	jrgt	f18_5				;if z * tan 22.5 > x then dir = 5
f18_4	movk	4,a0				;if z * tan 22.5 < x then dir = 4
	rets
fexpgzp	movi	158218,a0		;x is positive and greater than z is positive
	callr	QMULT				;cot 22.5
	cmp	a11,a1
	jrgt	f18_4				;if z * cot 22.5 > x then dir = 4
	movk	3,a0				;if z * cot 22.5 < x then dir = 3
	rets
fexpzn	neg	a1
	cmp	a1,a11			;x is positive, z is negative
	jrgt	fexpgzn			;x is positive and greater than z is negative
fexplzn	movi	27146,a0		;x is positive and less than z is negative
	callr	QMULT				;tan 22.5
	cmp	a11,a1
	jrgt	f18_1				;if z * tan 22.5 > x then dir = 1
f18_2	movk	2,a0				;if z * tan 22.5 < x then dir = 2
	rets
fexpgzn	movi	158218,a0		;x is positive and greater than z is negative
	callr	QMULT				;cot 22.5
	cmp	a11,a1
	jrgt	f18_2				;if z * cot 22.5 > x then dir = 2
	movk	3,a0				;if z * cot 22.5 < x then dir = 3
	rets
fexn	neg	a11			;x is negative
	sub	a3,a1
	jrn	fexnzn			;x is negative, z is negative
fexnzp	cmp	a1,a11			;x is negative, z is positive
	jrgt	fexngzp			;x is negative and greater than z is positive
fexnlzp	movi	27146,a0		;x is negative and less than z is positive
	callr	QMULT				;tan 22.5
	cmp	a11,a1
	jrgt	f18_5				;if z * tan 22.5 > x then dir = 5
f18_6	movk	6,a0				;if z * tan 22.5 < x then dir = 6
	rets
fexngzp	movi	158218,a0		;x is negative and greater than z is positive
	callr	QMULT				;cot 22.5
	cmp	a11,a1
	jrgt	f18_6				;if z * cot 22.5 > x then dir = 6
	movk	7,a0				;if z * cot 22.5 < x then dir = 7
	rets
fexnzn	neg	a1
	cmp	a1,a11			;x is negative, z is negative
	jrgt	fexngzn			;x is negative and greater than z is negative
fexnlzn	movi	27146,a0		;x is negative and less than z is negative
	callr	QMULT				;tan 22.5
	cmp	a11,a1
	jrgt	f18_1				;if z * tan 22.5 > x then dir = 1
f18_8	movk	8,a0				;if z * tan 22.5 < x then dir = 8
	rets
fexngzn	movi	158218,a0		;x is negative and greater than z is negative
	callr	QMULT				;cot 22.5
	cmp	a11,a1
	jrgt	f18_8				;if z * cot 22.5 > x then dir = 8
	movk	7,a0				;if z * cot 22.5 < x then dir = 7
	rets
f18_1	movk	1,a0
	rets
f18_5	movk	5,a0
	rets

dir_to_1357
	sll	7,a0
	srl	16+2+7,a0
;	srl	16+2,a0		;angles/4

	sll	3,a0		;bytes
	addi	dt1357_tab,a0
	movb	*a0,a0
	rets

dt1357_tab
	.byte	3,3,3,3,3,3,3,3,3,3,3,3,5,5,5,5
	.byte	5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
	.byte	5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,7
	.byte	7,7,7,7,7,7,7,7,7,1,1,1,1,1,1,1
	.byte	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3
	.byte	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	.byte	3

	.byte	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	.byte	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	.byte	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	.byte	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3

	.even

dir_to_18
	sll	7,a0
	srl	16+2+7,a0
;	srl	16+2,a0		;angles/4

	sll	3,a0		;bytes
	addi	dt18_tab,a0
	movb	*a0,a0
	rets

dt18_tab
	.byte	3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4
	.byte	4,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6
	.byte	6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7
	.byte	7,7,7,8,8,8,8,8,8,8,8,8,8,8,1,1
	.byte	1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2
	.byte	2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3
	.byte	4

	.byte	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	.byte	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	.byte	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	.byte	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3

	.even

**************************************************************************
*								         *
* find_dir_to_point							 *
* find_dirdis_to_point - FROM POINT 0 (X0,Z0) TO POINT 1 (X1,Z1)	 *
* 									 *
* PASS:									 *
* A0 = X1								 *
* A1 = Z1								 *
* A2 = X0								 *
* A3 = Z0 								 *
* 									 *
* RETURN:								 *
* A0 = ANGLE								 *
* A1 = SPEED (DISTANCE FOR find_dirdis_to_point)			 *
*								         *
**************************************************************************
find_dir_to_point
	sub	a2,a0
	sub	a3,a1
	jruc	rect_to_dir

find_dirdis_to_point
	sub	a2,a0
	sub	a3,a1
	jruc	rect_to_polar

**************************************************************************
*								         *
* MOVED to HHGAME							 *
*								         *
**************************************************************************
;find_dist_quick
;	sub	a2,a0
;	abs	a0
;	sub	a3,a1
;	abs	a1
;	cmp	a1,a0
;	jrls	fdq1
;fdq0	srl	1,a1
;	move	a1,a4
;	add	a0,a4
;	rets
;fdq1	srl	1,a0
;	move	a0,a4
;	add	a1,a4
;	rets

**************************************************************************
*								         *
* dir_to_degrees							 *
* 	input	a0 = direction of travel (1-8)				 *
* 	output	a0 = degrees						 *
*								         *
**************************************************************************
dir_to_degrees
	sll	5,a0
	addi	dtr_tab,a0
	move	*a0,a0,L
	rets
dtr_tab	.long	0		;0 = 0
	.long	XD2700		;1 = 3pi/2
	.long	XD3150		;2 = 7pi/4
	.long	0		;3 = 0
	.long	XD0450		;4 = pi/4
	.long	XD0900		;5 = pi/2
	.long	XD1350		;6 = 3pi/4
	.long	XD1800		;7 = pi
	.long	XD2250		;8 = 5pi/4

**************************************************************************
*								         *
* predict_obj								 *
* 	input	a8 = object						 *
* 		a0 = time ahead to predict				 *
* 	output	a0 = x position at time now+a0				 *
* 		a1 = z position at time now+a0				 *
*								         *
**************************************************************************
predict_obj
	move	a0,a14
	move	*a8(ODT_REALXVEL),a1,L
	mpys	a14,a1
	move	*a8(OXVAL),a0,L
	add	a1,a0
	move	*a8(OZVEL),a1,L
	mpys	a14,a1
	move	*a8(OZVAL),a14,L
	add	a14,a1
	rets

**************************************************************************
*								         *
* set_obj_to_polar							 *
* 	sets object vectors to the polar coordinates specified		 *
*    input    a8 = object						 *
*             a0 = angle						 *
*             a1 = velocity						 *
*    output to puck object						 *
* 									 *
* set_obj_to_rect							 *
* 	sets object vectors to the rectangular coordinates specified	 *
*    input    a8 = object						 *
*             a0 = xvel							 *
*             a1 = zvel							 *
*    output to object							 *
*								         *
**************************************************************************
set_obj_to_polar_p	;takes a6 player (doubles offscreen (if going on)
	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrz	set_obj_to_polar
	move	@PUCK_MODE,a14,W
	cmpi	PUM_PASS,a14
	jrz	soo2			;passes our pass mode test
	cmpi	PUM_TPASS,a14
	jrnz	soo1			;doesn't pass our pass mode test
soo2	move	@PUCK_INTENDED,a14,W
	movb	*a6(POF_NUMBER),a2
	cmp	a2,a14
	jrz	set_obj_to_polar	;normal if we are receiving puck
soo1	move	a0,*a8(ODT_DIR),L
	move	a1,*a8(ODT_VEL),L
	callr	polar_to_rect
	move	a0,*a8(ODT_REALXVEL),L
	move	a1,*a8(OZVEL),L
	move	*a8(OXPOS),a2,W
	move	@WORLDX+010h,a14,W
	cmp	a14,a2
	jrlt	sop_fr
sop_fl	move	a0,a0
	jrp	sop_9
	jruc	sop9a
sop_fr	move	a0,a0
	jrn	sop_9
sop9a
	sub	a2,a14
	cmpi	350,a14
	jrgt	sop9b
	cmpi	-350,a14
	jrge	sop9d
sop9b	sra	5,a14
	add	a14,a2
	move	a2,*a8(OXPOS),W

sop9d	sll	1,a0
sop_9	move	a0,*a8(OXVEL),L
	rets
set_obj_to_polar_v	;takes a6 player into account
	move	a0,a2
	move	a1,a3
	move	*a6(POF_OBJECT),a9,L
	move	*a9(ODT_DIR),a1,L
	sub	a1,a0
	calla	GETCOS
	move	*a9(ODT_VEL),a1,L
	sra	1,a1
	calla	MULT
	move	a2,a0
	move	a1,a1
	jrn	sopv8
	add	a1,a3
sopv8	move	a3,a1
set_obj_to_polar
	move	a0,*a8(ODT_DIR),L
	move	a1,*a8(ODT_VEL),L
	callr	polar_to_rect
	move	a0,*a8(OXVEL),L
	move	a0,*a8(ODT_REALXVEL),L
	move	a1,*a8(OZVEL),L
	rets
set_obj_to_rect
	move	a0,*a8(OXVEL),L
	move	a0,*a8(ODT_REALXVEL),L
	move	a1,*a8(OZVEL),L
	callr	rect_to_polar
	move	a0,*a8(ODT_DIR),L
	move	a1,*a8(ODT_VEL),L
	rets

**************************************************************************
*								         *
* move_to_speed_x 	input	;a1 = old speed				 *
* 				;a2 = desired end speed			 *
* 				;a3 = amount to move close (0-255)	 *
* 		   output	;a1 = new speed				 *
* 	DO NOT TRASH A14						 *
*								         *
**************************************************************************
move_to_speed_x		;a3 = 0-255 = % of new vs old
	mmtm	sp,a2,a3,a5,a6
	sll	24,a3
	move	a1,a6
	movk	8,a5
mta	sra	1,a6
	sra	1,a2
	sll	1,a3
	jrnc	mtan
	sub	a6,a1
	add	a2,a1
mtan	dsjs	a5,mta
	mmfm	sp,a2,a3,a5,a6
	rets

**************************************************************************
*								         *
* find_angle_difference							 *
* 	input	a0 = angle 1						 *
* 		a1 = angle 2						 *
* 	output	a3 = angle difference (abs)				 *
*								         *
**************************************************************************
find_angle_difference
	move	a0,a3
	sub	a1,a3
	THETA_H	a3
	abs	a3
	rets

**************************************************************************
*								         *
* find_closest_distance_1o						 *
* 	finds the closest distance between a vector			 *
* 	and a moving object						 *
* 	input	a0 = vector direction					 *
* 		a1 = vector velocity					 *
* 		a2 = starting vector x direction			 *
* 		a3 = starting vector z direction			 *
* 		a9 = object to check against				 *
* 	output	a0 = distance						 *
* find_closest_distance							 *
* 	finds the shortest distance between two moving object		 *
*     	assumes objects are moving at a constant velocity		 *
* 	input	a8 = object 1						 *
* 		a9 = object 2						 *
* 	output	a0 = distance						 *
* find_closest_dist_r							 *
* 	finds the shortest distance between two moving object		 *
*     	assumes objects are moving at a constant velocity		 *
* 	input	a0 = x position difference				 *
* 		a1 = z position difference				 *
* 		a2 = xvel difference					 *
* 		a3 = zvel difference					 *
*								         *
**************************************************************************
find_closest_distance_1o
	mmtm	sp,a1,a2,a3,a4,a5,a6,a7,a10,a11
	calla	polar_to_rect
	SWAP	a0,a2
	SWAP	a1,a3
	move	*a9(OXVAL),a14,L
	sub	a14,a0			;a0 = x0 difference
	move	*a9(OZVAL),a14,L
	sub	a14,a1			;a1 = z0 difference
	move	*a9(OXVEL),a14,L
	sub	a14,a2			;a2 = xvel difference
	move	*a8(OZVEL),a14,L
	sub	a14,a3			;a3 = zvel difference
	jruc	fcd_1
find_closest_distance
	mmtm	sp,a1,a2,a3,a4,a5,a6,a7,a10,a11
	move	*a8(OXVAL),a14,L
	move	*a9(OXVAL),a0,L
	sub	a14,a0			;a0 = x0 difference
	move	*a8(OZVAL),a14,L
	move	*a9(OZVAL),a1,L
	sub	a14,a1			;a1 = z0 difference
	move	*a8(OXVEL),a14,L
	move	*a9(OXVEL),a2,L
	sub	a14,a2			;a2 = xvel difference
	move	*a8(OZVEL),a14,L
	move	*a9(OZVEL),a3,L
	sub	a14,a3			;a3 = zvel difference
	jruc	fcd_1
find_closest_dist_r
	mmtm	sp,a1,a2,a3,a4,a5,a6,a7,a10,a11
fcd_1	move	a2,a2
	jrz	fcd_x0			;xv difference = 0 ; special case
	move	a3,a3
	jrz	fcd_z0			;zv difference = 0 ; special case
	move	a0,a10
	mpys	a3,a10
	divs	a2,a10
	move	a1,a5
	sub	a10,a5			;a5 = a1 - a3 * a0 / a2 = z @x=0
	move	a5,@cdist_store_a5,L		;for angle determination
	abs	a5
	move	a1,a10
	mpys	a2,a10
	divs	a3,a10
	move	a0,a4
	sub	a10,a4			;a4 = a0 - a2 * a1 / a3 = z @x=0
	move	a4,@cdist_store_a4,L		;for angle determination
	abs	a4
	cmp	a4,a5
	jrhs	fcd2
	SWAP	a4,a5
	SWAP	a0,a2
	SWAP	a1,a3
fcd2	move	a4,a6
	move	a4,a7
	sra	16,a6
	sll	16,a7
	divs	a5,a6
	move	a6,a0
	callr	GETATAN			;a0 = atan (a4 / a5)
	move	a0,@cdist_store_angle,L
	callr	GETCOS
	mpys	a4,a0			;a0 = Xz0 * cos (a0) = distance
	mmfm	sp,a1,a2,a3,a4,a5,a6,a7,a10,a11
	rets
fcd_z0	move	a1,a0
fcd_x0	abs	a0
	srl	16,a0
	mmfm	sp,a1,a2,a3,a4,a5,a6,a7,a10,a11
	rets

**************************************************************************
*								         *
* find_cdist_angle							 *
* 	call after calling find_closest_distance			 *
* 	finds angle from 1st object to second object			 *
* 									 *
* 	input	data stored at cdist_store_*				 *
* 	output	a0 = angle						 *
*								         *
**************************************************************************
find_cdist_angle
	mmtm	sp,a3,a4,a5
	move	@cdist_store_a5,a5,L
	move	@cdist_store_a4,a4,L
	move	@cdist_store_angle,a0,L
	move	a4,a14
	abs	a14
	move	a5,a3
	abs	a3
	cmp	a3,a14
	jrls	fca1
	subi	XD0900,a0
	abs	a0
fca1	move	a4,a4
	jrnn	fca2
	subi	XD1800,a0
	abs	a0
fca2	move	a5,a5
	jrnn	fca3
	subi	XD3600,a0
	abs	a0
fca3	mmfm	sp,a3,a4,a5
	rets

	.data
	.even

**************************************************************************
*								         *
* ATAN_TABLE - shift atan down 7 bits (/128) and then up wordsize	 *
*            - for angles less than pi/4				 *
*								         *
**************************************************************************
ATAN_TABLE
	.long	0,7334,14668,22001,29335,36668,44001,51334,58666,65998
	.long	73329,80660,87990,95320,102648,109976,117304,124630,131955,139279
	.long	146603,153925,161246,168565,175884,183201,190517,197831,205144,212455
	.long	219765,227072,234379,241683,248986,256286,263585,270882,278177,285469
	.long	292760,300048,307334,314618,321899,329178,336454,343728,350999,358268
	.long	365534,372797,380058,387315,394570,401821,409070,416316,423558,430798
	.long	438034,445267,452496,459722,466945,474164,481380,488592,495801,503006
	.long	510207,517404,524598,531788,538973,546155,553333,560507,567676,574842
	.long	582003,589160,596312,603461,610605,617744,624879,632009,639135,646256
	.long	653372,660484,667591,674693,681790,688882,695970,703052,710129,717201
	.long	724268,731330,738387,745438,752484,759524,766560,773589,780613,787632
	.long	794645,801653,808654,815651,822641,829625,836604,843577,850544,857505
	.long	864460,871409,878352,885289,892219,899143,906062,912974,919879,926779
	.long	933672,940558,947438,954311,961178,968039,974893,981740,988580,995414
	.long	1002241,1009062,1015875,1022682,1029481,1036274,1043060,1049839,1056611,1063376
	.long	1070133,1076884,1083627,1090363,1097092,1103814,1110529,1117236,1123936,1130628
	.long	1137313,1143991,1150661,1157324,1163979,1170627,1177267,1183899,1190524,1197141
	.long	1203751,1210353,1216947,1223533,1230111,1236682,1243245,1249800,1256347,1262886
	.long	1269417,1275940,1282455,1288962,1295461,1301952,1308435,1314910,1321377,1327835
	.long	1334285,1340727,1347161,1353587,1360004,1366413,1372813,1379206,1385590,1391965
	.long	1398333,1404691,1411042,1417383,1423717,1430042,1436358,1442666,1448965,1455256
	.long	1461538,1467811,1474076,1480332,1486580,1492819,1499049,1505270,1511483,1517687
	.long	1523882,1530068,1536246,1542415,1548575,1554726,1560869,1567002,1573127,1579243
	.long	1585349,1591447,1597536,1603616,1609687,1615750,1621803,1627847,1633882,1639909
	.long	1645926,1651934,1657933,1663923,1669904,1675876,1681839,1687793,1693738,1699673
	.long	1705600,1711517,1717426,1723325,1729215,1735096,1740967,1746830,1752683,1758527
	.long	1764362,1770188,1776005,1781812,1787610,1793399,1799179,1804949,1810710,1816462
	.long	1822205,1827939,1833663,1839378,1845084,1850780,1856467,1862145,1867814,1873473
	.long	1879124,1884764,1890396,1896018,1901631,1907235,1912829,1918414,1923990,1929556
	.long	1935113,1940661,1946200,1951729,1957249,1962760,1968261,1973753,1979236,1984709
	.long	1990173,1995628,2001074,2006510,2011937,2017355,2022763,2028162,2033552,2038932
	.long	2044303,2049666,2055018,2060361,2065695,2071020,2076336,2081642,2086939,2092226
	.long	2097505,2102774,2108034,2113285,2118526,2123758,2128981,2134195,2139399,2144595
	.long	2149780,2154957,2160125,2165283,2170432,2175572,2180703,2185825,2190937,2196040
	.long	2201134,2206219,2211295,2216362,2221419,2226468,2231507,2236537,2241558,2246570
	.long	2251572,2256566,2261551,2266526,2271493,2276450,2281398,2286337,2291268,2296189
	.long	2301101,2306004,2310898,2315783,2320659,2325526,2330385,2335233,2340074,2344905
	.long	2349727,2354541,2359345,2364141,2368927,2373705,2378474,2383234,2387985,2392727
	.long	2397461,2402185,2406901,2411608,2416306,2420995,2425676,2430347,2435010,2439664
	.long	2444310,2448946,2453574,2458193,2462804,2467406,2471999,2476584,2481159,2485726
	.long	2490285,2494835,2499376,2503909,2508433,2512948,2517455,2521954,2526443,2530925
	.long	2535397,2539862,2544317,2548764,2553203,2557634,2562055,2566469,2570873,2575270
	.long	2579658,2584038,2588409,2592772,2597126,2601473,2605811,2610140,2614462,2618774
	.long	2623079,2627375,2631664,2635944,2640215,2644479,2648734,2652981,2657220,2661450
	.long	2665673,2669887,2674093,2678292,2682482,2686664,2690837,2695003,2699161,2703310
	.long	2707452,2711586,2715712,2719829,2723939,2728041,2732134,2736220,2740298,2744368
	.long	2748430,2752484,2756531,2760569,2764600,2768623,2772638,2776645,2780644,2784636
	.long	2788620,2792596,2796564,2800525,2804478,2808423,2812361,2816291,2820213,2824128
	.long	2828035,2831934,2835826,2839711,2843587,2847456,2851318,2855172,2859019,2862858
	.long	2866690,2870514,2874330,2878140,2881942,2885736,2889523,2893302,2897075,2900840
	.long	2904597,2908348,2912090,2915826,2919554,2923276,2926989,2930695,2934395,2938087
	.long	2941772,2945449,2949121,2952784,2956440

sin_table
	.long	0,143,286,429,572,715,858,1001
	.long	1144,1287,1430,1573,1716,1858,2001,2144
	.long	2287,2430,2573,2716,2859,3001,3144,3287
	.long	3430,3573,3715,3858,4001,4144,4286,4429
	.long	4572,4714,4857,4999,5142,5284,5427,5569
	.long	5712,5854,5997,6139,6281,6424,6566,6708
	.long	6850,6993,7135,7277,7419,7561,7703,7845
	.long	7987,8129,8271,8412,8554,8696,8838,8979
	.long	9121,9262,9404,9545,9687,9828,9970,10111
	.long	10252,10393,10534,10676,10817,10958,11098,11239
	.long	11380,11521,11662,11802,11943,12084,12224,12364
	.long	12505,12645,12785,12926,13066,13206,13346,13486
	.long	13626,13766,13905,14045,14185,14324,14464,14603
	.long	14742,14882,15021,15160,15299,15438,15577,15716
	.long	15855,15993,16132,16270,16409,16547,16686,16824
	.long	16962,17100,17238,17376,17514,17651,17789,17927
	.long	18064,18202,18339,18476,18613,18750,18887,19024
	.long	19161,19298,19434,19571,19707,19843,19980,20116
	.long	20252,20388,20524,20659,20795,20930,21066,21201
	.long	21336,21472,21607,21742,21876,22011,22146,22280
	.long	22415,22549,22683,22817,22951,23085,23219,23352
	.long	23486,23619,23753,23886,24019,24152,24285,24418
	.long	24550,24683,24815,24947,25080,25212,25343,25475
	.long	25607,25739,25870,26001,26132,26263,26394,26525
	.long	26656,26786,26917,27047,27177,27307,27437,27567
	.long	27697,27826,27956,28085,28214,28343,28472,28601
	.long	28729,28858,28986,29114,29242,29370,29498,29625
	.long	29753,29880,30007,30134,30261,30388,30515,30641
	.long	30767,30893,31019,31145,31271,31397,31522,31647
	.long	31772,31897,32022,32147,32271,32396,32520,32644
	.long	32768,32892,33015,33139,33262,33385,33508,33631
	.long	33754,33876,33998,34120,34242,34364,34486,34607
	.long	34729,34850,34971,35092,35212,35333,35453,35573
	.long	35693,35813,35933,36052,36172,36291,36410,36529
	.long	36647,36766,36884,37002,37120,37238,37355,37473
	.long	37590,37707,37824,37940,38057,38173,38289,38405
	.long	38521,38637,38752,38867,38982,39097,39212,39326
	.long	39441,39555,39669,39782,39896,40009,40122,40235
	.long	40348,40461,40573,40685,40797,40909,41021,41132
	.long	41243,41354,41465,41576,41686,41796,41906,42016
	.long	42126,42235,42344,42453,42562,42671,42779,42887
	.long	42995,43103,43211,43318,43425,43532,43639,43746
	.long	43852,43958,44064,44170,44275,44381,44486,44591
	.long	44695,44800,44904,45008,45112,45216,45319,45422
	.long	45525,45628,45730,45833,45935,46037,46138,46240
	.long	46341,46442,46543,46643,46744,46844,46944,47043
	.long	47143,47242,47341,47440,47538,47636,47735,47832
	.long	47930,48027,48125,48222,48318,48415,48511,48607
	.long	48703,48798,48894,48989,49084,49178,49273,49367
	.long	49461,49554,49648,49741,49834,49927,50019,50111
	.long	50203,50295,50387,50478,50569,50660,50751,50841
	.long	50931,51021,51111,51200,51289,51378,51467,51555
	.long	51643,51731,51819,51906,51993,52080,52167,52253
	.long	52339,52425,52511,52596,52682,52766,52851,52936
	.long	53020,53104,53187,53271,53354,53437,53519,53602
	.long	53684,53766,53847,53929,54010,54091,54171,54252
	.long	54332,54412,54491,54570,54650,54728,54807,54885
	.long	54963,55041,55118,55196,55273,55349,55426,55502
	.long	55578,55653,55729,55804,55879,55953,56028,56102
	.long	56175,56249,56322,56395,56468,56540,56612,56684
	.long	56756,56827,56898,56969,57040,57110,57180,57250
	.long	57319,57388,57457,57526,57594,57662,57730,57798
	.long	57865,57932,57999,58065,58131,58197,58263,58328
	.long	58393,58458,58522,58586,58650,58714,58777,58841
	.long	58903,58966,59028,59090,59152,59213,59274,59335
	.long	59396,59456,59516,59576,59635,59694,59753,59812
	.long	59870,59928,59986,60043,60100,60157,60214,60270
	.long	60326,60382,60437,60493,60547,60602,60656,60710
	.long	60764,60817,60870,60923,60976,61028,61080,61132
	.long	61183,61234,61285,61336,61386,61436,61485,61535
	.long	61584,61632,61681,61729,61777,61825,61872,61919
	.long	61966,62012,62058,62104,62149,62195,62239,62284
	.long	62328,62372,62416,62460,62503,62546,62588,62630
	.long	62672,62714,62755,62796,62837,62878,62918,62958
	.long	62997,63037,63075,63114,63152,63191,63228,63266
	.long	63303,63340,63376,63413,63449,63484,63520,63555
	.long	63589,63624,63658,63692,63725,63758,63791,63824
	.long	63856,63888,63920,63951,63983,64013,64044,64074
	.long	64104,64133,64163,64192,64220,64249,64277,64304
	.long	64332,64359,64386,64412,64439,64464,64490,64515
	.long	64540,64565,64589,64613,64637,64661,64684,64707
	.long	64729,64751,64773,64795,64816,64837,64858,64878
	.long	64898,64918,64937,64957,64975,64994,65012,65030
	.long	65048,65065,65082,65098,65115,65131,65146,65162
	.long	65177,65192,65206,65220,65234,65248,65261,65274
	.long	65287,65299,65311,65323,65334,65345,65356,65366
	.long	65376,65386,65396,65405,65414,65422,65431,65439
	.long	65446,65454,65461,65467,65474,65480,65485,65491
	.long	65496,65501,65505,65510,65514,65517,65520,65523
	.long	65526,65528,65530,65532,65534,65535,65535,65536
cos_table
	.long	65536,65536,65535,65535,65534,65532,65530,65528
	.long	65526,65523,65520,65517,65514,65510,65505,65501
	.long	65496,65491,65485,65480,65474,65467,65461,65454
	.long	65446,65439,65431,65422,65414,65405,65396,65386
	.long	65376,65366,65356,65345,65334,65323,65311,65299
	.long	65287,65274,65261,65248,65234,65220,65206,65192
	.long	65177,65162,65146,65131,65115,65098,65082,65065
	.long	65048,65030,65012,64994,64975,64957,64937,64918
	.long	64898,64878,64858,64837,64816,64795,64773,64751
	.long	64729,64707,64684,64661,64637,64613,64589,64565
	.long	64540,64515,64490,64464,64439,64412,64386,64359
	.long	64332,64304,64277,64249,64220,64192,64163,64133
	.long	64104,64074,64044,64013,63983,63951,63920,63888
	.long	63856,63824,63791,63758,63725,63692,63658,63624
	.long	63589,63555,63520,63484,63449,63413,63376,63340
	.long	63303,63266,63228,63191,63152,63114,63075,63037
	.long	62997,62958,62918,62878,62837,62796,62755,62714
	.long	62672,62630,62588,62546,62503,62460,62416,62372
	.long	62328,62284,62239,62195,62149,62104,62058,62012
	.long	61966,61919,61872,61825,61777,61729,61681,61632
	.long	61584,61535,61485,61436,61386,61336,61285,61234
	.long	61183,61132,61080,61028,60976,60923,60870,60817
	.long	60764,60710,60656,60602,60547,60493,60437,60382
	.long	60326,60270,60214,60157,60100,60043,59986,59928
	.long	59870,59812,59753,59694,59635,59576,59516,59456
	.long	59396,59335,59274,59213,59152,59090,59028,58966
	.long	58903,58841,58777,58714,58650,58586,58522,58458
	.long	58393,58328,58263,58197,58131,58065,57999,57932
	.long	57865,57798,57730,57662,57594,57526,57457,57388
	.long	57319,57250,57180,57110,57040,56969,56898,56827
	.long	56756,56684,56612,56540,56468,56395,56322,56249
	.long	56175,56102,56028,55953,55879,55804,55729,55653
	.long	55578,55502,55426,55349,55273,55196,55118,55041
	.long	54963,54885,54807,54728,54650,54570,54491,54412
	.long	54332,54252,54171,54091,54010,53929,53847,53766
	.long	53684,53602,53519,53437,53354,53271,53187,53104
	.long	53020,52936,52851,52766,52682,52596,52511,52425
	.long	52339,52253,52167,52080,51993,51906,51819,51731
	.long	51643,51555,51467,51378,51289,51200,51111,51021
	.long	50931,50841,50751,50660,50569,50478,50387,50295
	.long	50203,50111,50019,49927,49834,49741,49648,49554
	.long	49461,49367,49273,49178,49084,48989,48894,48798
	.long	48703,48607,48511,48415,48318,48222,48125,48027
	.long	47930,47832,47735,47636,47538,47440,47341,47242
	.long	47143,47043,46944,46844,46744,46643,46543,46442
	.long	46341,46240,46138,46037,45935,45833,45730,45628
	.long	45525,45422,45319,45216,45112,45008,44904,44800
	.long	44695,44591,44486,44381,44275,44170,44064,43958
	.long	43852,43746,43639,43532,43425,43318,43211,43103
	.long	42995,42887,42779,42671,42562,42453,42344,42235
	.long	42126,42016,41906,41796,41686,41576,41465,41354
	.long	41243,41132,41021,40909,40797,40685,40573,40461
	.long	40348,40235,40122,40009,39896,39782,39669,39555
	.long	39441,39326,39212,39097,38982,38867,38752,38637
	.long	38521,38405,38289,38173,38057,37940,37824,37707
	.long	37590,37473,37355,37238,37120,37002,36884,36766
	.long	36647,36529,36410,36291,36172,36052,35933,35813
	.long	35693,35573,35453,35333,35212,35092,34971,34850
	.long	34729,34607,34486,34364,34242,34120,33998,33876
	.long	33754,33631,33508,33385,33262,33139,33015,32892
	.long	32768,32644,32520,32396,32271,32147,32022,31897
	.long	31772,31647,31522,31397,31271,31145,31019,30893
	.long	30767,30641,30515,30388,30261,30134,30007,29880
	.long	29753,29625,29498,29370,29242,29114,28986,28858
	.long	28729,28601,28472,28343,28214,28085,27956,27826
	.long	27697,27567,27437,27307,27177,27047,26917,26786
	.long	26656,26525,26394,26263,26132,26001,25870,25739
	.long	25607,25475,25343,25212,25080,24947,24815,24683
	.long	24550,24418,24285,24152,24019,23886,23753,23619
	.long	23486,23352,23219,23085,22951,22817,22683,22549
	.long	22415,22280,22146,22011,21876,21742,21607,21472
	.long	21336,21201,21066,20930,20795,20659,20524,20388
	.long	20252,20116,19980,19843,19707,19571,19434,19298
	.long	19161,19024,18887,18750,18613,18476,18339,18202
	.long	18064,17927,17789,17651,17514,17376,17238,17100
	.long	16962,16824,16686,16547,16409,16270,16132,15993
	.long	15855,15716,15577,15438,15299,15160,15021,14882
	.long	14742,14603,14464,14324,14185,14045,13905,13766
	.long	13626,13486,13346,13206,13066,12926,12785,12645
	.long	12505,12364,12224,12084,11943,11802,11662,11521
	.long	11380,11239,11098,10958,10817,10676,10534,10393
	.long	10252,10111,9970,9828,9687,9545,9404,9262
	.long	9121,8979,8838,8696,8554,8412,8271,8129
	.long	7987,7845,7703,7561,7419,7277,7135,6993
	.long	6850,6708,6566,6424,6281,6139,5997,5854
	.long	5712,5569,5427,5284,5142,4999,4857,4714
	.long	4572,4429,4286,4144,4001,3858,3715,3573
	.long	3430,3287,3144,3001,2859,2716,2573,2430
	.long	2287,2144,2001,1858,1716,1573,1430,1287
	.long	1144,1001,858,715,572,429,286,143
	.long	0,-143,-286,-429,-572,-715,-858,-1001
	.long	-1144,-1287,-1430,-1573,-1716,-1858,-2001,-2144
	.long	-2287,-2430,-2573,-2716,-2859,-3001,-3144,-3287
	.long	-3430,-3573,-3715,-3858,-4001,-4144,-4286,-4429
	.long	-4572,-4714,-4857,-4999,-5142,-5284,-5427,-5569
	.long	-5712,-5854,-5997,-6139,-6281,-6424,-6566,-6708
	.long	-6850,-6993,-7135,-7277,-7419,-7561,-7703,-7845
	.long	-7987,-8129,-8271,-8412,-8554,-8696,-8838,-8979
	.long	-9121,-9262,-9404,-9545,-9687,-9828,-9970,-10111
	.long	-10252,-10393,-10534,-10676,-10817,-10958,-11098,-11239
	.long	-11380,-11521,-11662,-11802,-11943,-12084,-12224,-12364
	.long	-12505,-12645,-12785,-12926,-13066,-13206,-13346,-13486
	.long	-13626,-13766,-13905,-14045,-14185,-14324,-14464,-14603
	.long	-14742,-14882,-15021,-15160,-15299,-15438,-15577,-15716
	.long	-15855,-15993,-16132,-16270,-16409,-16547,-16686,-16824
	.long	-16962,-17100,-17238,-17376,-17514,-17651,-17789,-17927
	.long	-18064,-18202,-18339,-18476,-18613,-18750,-18887,-19024
	.long	-19161,-19298,-19434,-19571,-19707,-19843,-19980,-20116
	.long	-20252,-20388,-20523,-20659,-20795,-20930,-21066,-21201
	.long	-21336,-21472,-21607,-21742,-21876,-22011,-22146,-22280
	.long	-22415,-22549,-22683,-22817,-22951,-23085,-23219,-23352
	.long	-23486,-23619,-23753,-23886,-24019,-24152,-24285,-24418
	.long	-24550,-24683,-24815,-24947,-25080,-25212,-25343,-25475
	.long	-25607,-25739,-25870,-26001,-26132,-26263,-26394,-26525
	.long	-26656,-26786,-26917,-27047,-27177,-27307,-27437,-27567
	.long	-27697,-27826,-27956,-28085,-28214,-28343,-28472,-28601
	.long	-28729,-28858,-28986,-29114,-29242,-29370,-29498,-29625
	.long	-29753,-29880,-30007,-30134,-30261,-30388,-30515,-30641
	.long	-30767,-30893,-31019,-31145,-31271,-31397,-31522,-31647
	.long	-31772,-31897,-32022,-32147,-32271,-32396,-32520,-32644
	.long	-32768,-32892,-33015,-33139,-33262,-33385,-33508,-33631
	.long	-33754,-33876,-33998,-34120,-34242,-34364,-34486,-34607
	.long	-34729,-34850,-34971,-35092,-35212,-35333,-35453,-35573
	.long	-35693,-35813,-35933,-36052,-36172,-36291,-36410,-36529
	.long	-36647,-36766,-36884,-37002,-37120,-37238,-37355,-37473
	.long	-37590,-37707,-37824,-37940,-38057,-38173,-38289,-38405
	.long	-38521,-38637,-38752,-38867,-38982,-39097,-39212,-39326
	.long	-39441,-39555,-39669,-39782,-39896,-40009,-40122,-40235
	.long	-40348,-40461,-40573,-40685,-40797,-40909,-41021,-41132
	.long	-41243,-41354,-41465,-41576,-41686,-41796,-41906,-42016
	.long	-42126,-42235,-42344,-42453,-42562,-42671,-42779,-42887
	.long	-42995,-43103,-43211,-43318,-43425,-43532,-43639,-43746
	.long	-43852,-43958,-44064,-44170,-44275,-44381,-44486,-44591
	.long	-44695,-44800,-44904,-45008,-45112,-45216,-45319,-45422
	.long	-45525,-45628,-45730,-45833,-45935,-46037,-46138,-46240
	.long	-46341,-46442,-46543,-46643,-46744,-46844,-46944,-47043
	.long	-47143,-47242,-47341,-47440,-47538,-47636,-47735,-47832
	.long	-47930,-48027,-48125,-48222,-48318,-48415,-48511,-48607
	.long	-48703,-48798,-48894,-48989,-49084,-49178,-49273,-49367
	.long	-49461,-49554,-49648,-49741,-49834,-49927,-50019,-50111
	.long	-50203,-50295,-50387,-50478,-50569,-50660,-50751,-50841
	.long	-50931,-51021,-51110,-51200,-51289,-51378,-51467,-51555
	.long	-51643,-51731,-51819,-51906,-51993,-52080,-52167,-52253
	.long	-52339,-52425,-52511,-52596,-52682,-52766,-52851,-52936
	.long	-53020,-53104,-53187,-53271,-53354,-53437,-53519,-53602
	.long	-53684,-53766,-53847,-53929,-54010,-54091,-54171,-54252
	.long	-54332,-54412,-54491,-54571,-54650,-54728,-54807,-54885
	.long	-54963,-55041,-55118,-55196,-55272,-55349,-55426,-55502
	.long	-55578,-55653,-55729,-55804,-55879,-55953,-56028,-56102
	.long	-56175,-56249,-56322,-56395,-56468,-56540,-56612,-56684
	.long	-56756,-56827,-56898,-56969,-57040,-57110,-57180,-57250
	.long	-57319,-57388,-57457,-57526,-57594,-57662,-57730,-57798
	.long	-57865,-57932,-57999,-58065,-58131,-58197,-58263,-58328
	.long	-58393,-58458,-58522,-58586,-58650,-58714,-58777,-58841
	.long	-58903,-58966,-59028,-59090,-59152,-59213,-59274,-59335
	.long	-59396,-59456,-59516,-59576,-59635,-59694,-59753,-59812
	.long	-59870,-59928,-59986,-60043,-60100,-60157,-60214,-60270
	.long	-60326,-60382,-60437,-60493,-60547,-60602,-60656,-60710
	.long	-60764,-60817,-60870,-60923,-60976,-61028,-61080,-61132
	.long	-61183,-61234,-61285,-61336,-61386,-61436,-61485,-61535
	.long	-61584,-61632,-61681,-61729,-61777,-61825,-61872,-61919
	.long	-61966,-62012,-62058,-62104,-62149,-62195,-62239,-62284
	.long	-62328,-62372,-62416,-62460,-62503,-62546,-62588,-62630
	.long	-62672,-62714,-62755,-62796,-62837,-62878,-62918,-62958
	.long	-62997,-63037,-63075,-63114,-63152,-63191,-63228,-63266
	.long	-63303,-63340,-63376,-63413,-63449,-63484,-63520,-63555
	.long	-63589,-63624,-63658,-63692,-63725,-63758,-63791,-63824
	.long	-63856,-63888,-63920,-63951,-63983,-64013,-64044,-64074
	.long	-64104,-64133,-64163,-64192,-64220,-64249,-64277,-64304
	.long	-64332,-64359,-64386,-64412,-64439,-64464,-64490,-64515
	.long	-64540,-64565,-64589,-64613,-64637,-64661,-64684,-64707
	.long	-64729,-64751,-64773,-64795,-64816,-64837,-64858,-64878
	.long	-64898,-64918,-64937,-64957,-64975,-64994,-65012,-65030
	.long	-65048,-65065,-65082,-65098,-65115,-65131,-65146,-65162
	.long	-65177,-65192,-65206,-65220,-65234,-65248,-65261,-65274
	.long	-65287,-65299,-65311,-65323,-65334,-65345,-65356,-65366
	.long	-65376,-65386,-65396,-65405,-65414,-65422,-65431,-65439
	.long	-65446,-65454,-65461,-65467,-65474,-65480,-65485,-65491
	.long	-65496,-65501,-65505,-65510,-65514,-65517,-65520,-65523
	.long	-65526,-65528,-65530,-65532,-65534,-65535,-65535,-65536
	.long	-65536,-65536,-65535,-65535,-65534,-65532,-65530,-65528
	.long	-65526,-65523,-65520,-65517,-65514,-65510,-65505,-65501
	.long	-65496,-65491,-65485,-65480,-65474,-65467,-65461,-65454
	.long	-65446,-65439,-65431,-65422,-65414,-65405,-65396,-65386
	.long	-65376,-65366,-65356,-65345,-65334,-65323,-65311,-65299
	.long	-65287,-65274,-65261,-65248,-65234,-65220,-65206,-65192
	.long	-65177,-65162,-65146,-65131,-65115,-65098,-65082,-65065
	.long	-65048,-65030,-65012,-64994,-64975,-64957,-64937,-64918
	.long	-64898,-64878,-64858,-64837,-64816,-64795,-64773,-64751
	.long	-64729,-64707,-64684,-64661,-64637,-64613,-64589,-64565
	.long	-64540,-64515,-64490,-64464,-64439,-64412,-64386,-64359
	.long	-64332,-64304,-64277,-64249,-64220,-64192,-64163,-64133
	.long	-64104,-64074,-64044,-64013,-63983,-63951,-63920,-63888
	.long	-63856,-63824,-63791,-63758,-63725,-63692,-63658,-63624
	.long	-63589,-63555,-63520,-63484,-63449,-63413,-63376,-63340
	.long	-63303,-63266,-63228,-63191,-63152,-63114,-63075,-63037
	.long	-62997,-62958,-62918,-62878,-62837,-62796,-62755,-62714
	.long	-62672,-62630,-62588,-62546,-62503,-62460,-62416,-62372
	.long	-62328,-62284,-62239,-62195,-62149,-62104,-62058,-62012
	.long	-61966,-61919,-61872,-61825,-61777,-61729,-61681,-61632
	.long	-61584,-61535,-61485,-61436,-61386,-61336,-61285,-61234
	.long	-61183,-61132,-61080,-61028,-60976,-60923,-60870,-60817
	.long	-60764,-60710,-60656,-60602,-60547,-60493,-60437,-60382
	.long	-60326,-60270,-60214,-60157,-60100,-60043,-59986,-59928
	.long	-59870,-59812,-59753,-59694,-59635,-59576,-59516,-59456
	.long	-59396,-59335,-59274,-59213,-59152,-59090,-59028,-58966
	.long	-58903,-58841,-58777,-58714,-58650,-58586,-58522,-58458
	.long	-58393,-58328,-58263,-58197,-58131,-58065,-57999,-57932
	.long	-57865,-57798,-57730,-57662,-57594,-57526,-57457,-57388
	.long	-57319,-57250,-57180,-57110,-57040,-56969,-56898,-56827
	.long	-56756,-56684,-56612,-56540,-56468,-56395,-56322,-56249
	.long	-56175,-56102,-56028,-55953,-55879,-55804,-55729,-55653
	.long	-55578,-55502,-55426,-55349,-55272,-55196,-55118,-55041
	.long	-54963,-54885,-54807,-54728,-54650,-54571,-54491,-54412
	.long	-54332,-54252,-54171,-54091,-54010,-53929,-53847,-53766
	.long	-53684,-53602,-53519,-53437,-53354,-53271,-53187,-53104
	.long	-53020,-52936,-52851,-52766,-52682,-52596,-52511,-52425
	.long	-52339,-52253,-52167,-52080,-51993,-51906,-51819,-51731
	.long	-51643,-51555,-51467,-51378,-51289,-51200,-51110,-51021
	.long	-50931,-50841,-50751,-50660,-50569,-50478,-50387,-50295
	.long	-50203,-50111,-50019,-49927,-49834,-49741,-49648,-49554
	.long	-49461,-49367,-49273,-49178,-49084,-48989,-48894,-48798
	.long	-48703,-48607,-48511,-48415,-48318,-48221,-48125,-48027
	.long	-47930,-47832,-47735,-47636,-47538,-47440,-47341,-47242
	.long	-47143,-47043,-46944,-46844,-46744,-46643,-46543,-46442
	.long	-46341,-46240,-46138,-46037,-45935,-45833,-45730,-45628
	.long	-45525,-45422,-45319,-45216,-45112,-45008,-44904,-44800
	.long	-44695,-44591,-44486,-44381,-44275,-44170,-44064,-43958
	.long	-43852,-43746,-43639,-43532,-43425,-43318,-43211,-43103
	.long	-42995,-42887,-42779,-42671,-42562,-42453,-42344,-42235
	.long	-42126,-42016,-41906,-41796,-41686,-41576,-41465,-41354
	.long	-41243,-41132,-41021,-40909,-40797,-40685,-40573,-40461
	.long	-40348,-40235,-40122,-40009,-39896,-39782,-39669,-39555
	.long	-39441,-39326,-39212,-39097,-38982,-38867,-38752,-38637
	.long	-38521,-38405,-38289,-38173,-38057,-37940,-37824,-37707
	.long	-37590,-37473,-37355,-37238,-37120,-37002,-36884,-36766
	.long	-36647,-36529,-36410,-36291,-36172,-36052,-35933,-35813
	.long	-35693,-35573,-35453,-35333,-35212,-35092,-34971,-34850
	.long	-34729,-34607,-34486,-34364,-34242,-34120,-33998,-33876
	.long	-33754,-33631,-33508,-33385,-33262,-33139,-33015,-32892
	.long	-32768,-32644,-32520,-32396,-32271,-32147,-32022,-31897
	.long	-31772,-31647,-31522,-31397,-31271,-31145,-31019,-30893
	.long	-30767,-30641,-30515,-30388,-30261,-30134,-30007,-29880
	.long	-29753,-29625,-29498,-29370,-29242,-29114,-28986,-28858
	.long	-28729,-28601,-28472,-28343,-28214,-28085,-27956,-27826
	.long	-27697,-27567,-27437,-27307,-27177,-27047,-26917,-26786
	.long	-26656,-26525,-26394,-26263,-26132,-26001,-25870,-25738
	.long	-25607,-25475,-25344,-25212,-25080,-24947,-24815,-24683
	.long	-24550,-24418,-24285,-24152,-24019,-23886,-23753,-23619
	.long	-23486,-23352,-23219,-23085,-22951,-22817,-22683,-22549
	.long	-22415,-22280,-22146,-22011,-21876,-21742,-21607,-21472
	.long	-21336,-21201,-21066,-20930,-20795,-20659,-20524,-20388
	.long	-20252,-20116,-19980,-19843,-19707,-19571,-19434,-19298
	.long	-19161,-19024,-18887,-18750,-18613,-18476,-18339,-18202
	.long	-18064,-17927,-17789,-17651,-17514,-17376,-17238,-17100
	.long	-16962,-16824,-16686,-16547,-16409,-16270,-16132,-15993
	.long	-15855,-15716,-15577,-15438,-15299,-15160,-15021,-14882
	.long	-14742,-14603,-14464,-14324,-14185,-14045,-13905,-13766
	.long	-13626,-13486,-13346,-13206,-13066,-12926,-12785,-12645
	.long	-12505,-12364,-12224,-12084,-11943,-11802,-11662,-11521
	.long	-11380,-11239,-11098,-10958,-10817,-10676,-10534,-10393
	.long	-10252,-10111,-9970,-9828,-9687,-9545,-9404,-9262
	.long	-9121,-8979,-8838,-8696,-8554,-8412,-8271,-8129
	.long	-7987,-7845,-7703,-7561,-7419,-7277,-7135,-6993
	.long	-6850,-6708,-6566,-6424,-6281,-6139,-5997,-5854
	.long	-5712,-5569,-5427,-5284,-5142,-4999,-4857,-4714
	.long	-4572,-4429,-4286,-4144,-4001,-3858,-3715,-3573
	.long	-3430,-3287,-3144,-3001,-2859,-2716,-2573,-2430
	.long	-2287,-2144,-2001,-1858,-1716,-1573,-1430,-1287
	.long	-1144,-1001,-858,-715,-572,-429,-286,-143
end_of_sin_here
	.long	0,143,286,429,572,715,858,1001
	.long	1144,1287,1430,1573,1716,1858,2001,2144
	.long	2287,2430,2573,2716,2859,3001,3144,3287
	.long	3430,3573,3715,3858,4001,4144,4286,4429
	.long	4572,4714,4857,4999,5142,5284,5427,5569
	.long	5712,5854,5997,6139,6281,6424,6566,6708
	.long	6850,6993,7135,7277,7419,7561,7703,7845
	.long	7987,8129,8271,8412,8554,8696,8838,8979
	.long	9121,9262,9404,9545,9687,9828,9970,10111
	.long	10252,10393,10534,10676,10817,10958,11098,11239
	.long	11380,11521,11662,11802,11943,12084,12224,12364
	.long	12505,12645,12785,12926,13066,13206,13346,13486
	.long	13626,13766,13905,14045,14185,14324,14464,14603
	.long	14742,14882,15021,15160,15299,15438,15577,15716
	.long	15855,15993,16132,16270,16409,16547,16686,16824
	.long	16962,17100,17238,17376,17514,17651,17789,17927
	.long	18064,18202,18339,18476,18613,18750,18887,19024
	.long	19161,19298,19434,19571,19707,19843,19980,20116
	.long	20252,20388,20524,20659,20795,20930,21066,21201
	.long	21336,21472,21607,21742,21876,22011,22146,22280
	.long	22415,22549,22683,22817,22951,23085,23219,23352
	.long	23486,23619,23753,23886,24019,24152,24285,24418
	.long	24550,24683,24815,24947,25080,25212,25343,25475
	.long	25607,25739,25870,26001,26132,26263,26394,26525
	.long	26656,26786,26917,27047,27177,27307,27437,27567
	.long	27697,27826,27956,28085,28214,28343,28472,28601
	.long	28729,28858,28986,29114,29242,29370,29498,29625
	.long	29753,29880,30007,30134,30261,30388,30515,30641
	.long	30767,30893,31019,31145,31271,31397,31522,31647
	.long	31772,31897,32022,32147,32271,32396,32520,32644
	.long	32768,32892,33015,33139,33262,33385,33508,33631
	.long	33754,33876,33998,34120,34242,34364,34486,34607
	.long	34729,34850,34971,35092,35212,35333,35453,35573
	.long	35693,35813,35933,36052,36172,36291,36410,36529
	.long	36647,36766,36884,37002,37120,37238,37355,37473
	.long	37590,37707,37824,37940,38057,38173,38289,38405
	.long	38521,38637,38752,38867,38982,39097,39212,39326
	.long	39441,39555,39669,39782,39896,40009,40122,40235
	.long	40348,40461,40573,40685,40797,40909,41021,41132
	.long	41243,41354,41465,41576,41686,41796,41906,42016
	.long	42126,42235,42344,42453,42562,42671,42779,42887
	.long	42995,43103,43211,43318,43425,43532,43639,43746
	.long	43852,43958,44064,44170,44275,44381,44486,44591
	.long	44695,44800,44904,45008,45112,45216,45319,45422
	.long	45525,45628,45730,45833,45935,46037,46138,46240
	.long	46341,46442,46543,46643,46744,46844,46944,47043
	.long	47143,47242,47341,47440,47538,47636,47735,47832
	.long	47930,48027,48125,48222,48318,48415,48511,48607
	.long	48703,48798,48894,48989,49084,49178,49273,49367
	.long	49461,49554,49648,49741,49834,49927,50019,50111
	.long	50203,50295,50387,50478,50569,50660,50751,50841
	.long	50931,51021,51111,51200,51289,51378,51467,51555
	.long	51643,51731,51819,51906,51993,52080,52167,52253
	.long	52339,52425,52511,52596,52682,52766,52851,52936
	.long	53020,53104,53187,53271,53354,53437,53519,53602
	.long	53684,53766,53847,53929,54010,54091,54171,54252
	.long	54332,54412,54491,54570,54650,54728,54807,54885
	.long	54963,55041,55118,55196,55273,55349,55426,55502
	.long	55578,55653,55729,55804,55879,55953,56028,56102
	.long	56175,56249,56322,56395,56468,56540,56612,56684
	.long	56756,56827,56898,56969,57040,57110,57180,57250
	.long	57319,57388,57457,57526,57594,57662,57730,57798
	.long	57865,57932,57999,58065,58131,58197,58263,58328
	.long	58393,58458,58522,58586,58650,58714,58777,58841
	.long	58903,58966,59028,59090,59152,59213,59274,59335
	.long	59396,59456,59516,59576,59635,59694,59753,59812
	.long	59870,59928,59986,60043,60100,60157,60214,60270
	.long	60326,60382,60437,60493,60547,60602,60656,60710
	.long	60764,60817,60870,60923,60976,61028,61080,61132
	.long	61183,61234,61285,61336,61386,61436,61485,61535
	.long	61584,61632,61681,61729,61777,61825,61872,61919
	.long	61966,62012,62058,62104,62149,62195,62239,62284
	.long	62328,62372,62416,62460,62503,62546,62588,62630
	.long	62672,62714,62755,62796,62837,62878,62918,62958
	.long	62997,63037,63075,63114,63152,63191,63228,63266
	.long	63303,63340,63376,63413,63449,63484,63520,63555
	.long	63589,63624,63658,63692,63725,63758,63791,63824
	.long	63856,63888,63920,63951,63983,64013,64044,64074
	.long	64104,64133,64163,64192,64220,64249,64277,64304
	.long	64332,64359,64386,64412,64439,64464,64490,64515
	.long	64540,64565,64589,64613,64637,64661,64684,64707
	.long	64729,64751,64773,64795,64816,64837,64858,64878
	.long	64898,64918,64937,64957,64975,64994,65012,65030
	.long	65048,65065,65082,65098,65115,65131,65146,65162
	.long	65177,65192,65206,65220,65234,65248,65261,65274
	.long	65287,65299,65311,65323,65334,65345,65356,65366
	.long	65376,65386,65396,65405,65414,65422,65431,65439
	.long	65446,65454,65461,65467,65474,65480,65485,65491
	.long	65496,65501,65505,65510,65514,65517,65520,65523
	.long	65526,65528,65530,65532,65534,65535,65535,65536
end_of_cos_here			;what follows is extra at end of table
	.long	65536,65536,65535,65535,65534,65532,65530,65528
	.long	65526,65523,65520,65517,65514,65510,65505,65501
	.long	65496,65491,65485,65480,65474,65467,65461,65454
	.long	65446,65439,65431,65422,65414,65405,65396,65386
	.long	65376,65366,65356,65345,65334,65323,65311,65299
	.long	65287,65274,65261,65248,65234,65220,65206,65192
	.long	65177,65162,65146,65131,65115,65098,65082,65065
	.long	65048,65030,65012,64994,64975,64957,64937,64918
	.long	64898,64878,64858,64837,64816,64795,64773,64751
	.long	64729,64707,64684,64661,64637,64613,64589,64565
	.long	64540,64515,64490,64464,64439,64412,64386,64359
	.long	64332,64304,64277,64249,64220,64192,64163,64133
	.long	64104,64074,64044,64013,63983,63951,63920,63888
	.long	63856,63824,63791,63758,63725,63692,63658,63624
	.long	63589,63555,63520,63484,63449,63413,63376,63340
	.long	63303,63266,63228,63191,63152,63114,63075,63037
	.long	62997,62958,62918,62878,62837,62796,62755,62714
	.long	62672,62630,62588,62546,62503,62460,62416,62372
	.long	62328,62284,62239,62195,62149,62104,62058,62012
	.long	61966,61919,61872,61825,61777,61729,61681,61632
	.long	61584,61535,61485,61436,61386,61336,61285,61234
	.long	61183,61132,61080,61028,60976,60923,60870,60817
	.long	60764,60710,60656,60602,60547,60493,60437,60382
	.long	60326,60270,60214,60157,60100,60043,59986,59928
	.long	59870,59812,59753,59694,59635,59576,59516,59456
	.long	59396,59335,59274,59213,59152,59090,59028,58966
	.long	58903,58841,58777,58714,58650,58586,58522,58458
	.long	58393,58328,58263,58197,58131,58065,57999,57932
	.long	57865,57798,57730,57662,57594,57526,57457,57388
	.long	57319,57250,57180,57110,57040,56969,56898,56827
	.long	56756,56684,56612,56540,56468,56395,56322,56249
	.long	56175,56102,56028,55953,55879,55804,55729,55653
	.long	55578,55502,55426,55349,55273,55196,55118,55041
	.long	54963,54885,54807,54728,54650,54570,54491,54412
	.long	54332,54252,54171,54091,54010,53929,53847,53766
	.long	53684,53602,53519,53437,53354,53271,53187,53104
	.long	53020,52936,52851,52766,52682,52596,52511,52425
	.long	52339,52253,52167,52080,51993,51906,51819,51731
	.long	51643,51555,51467,51378,51289,51200,51111,51021
	.long	50931,50841,50751,50660,50569,50478,50387,50295


;1024 entries - square root of multiples of 32.
sqroot_tab
	.byte	0,6,8,10,11,13,14,15,16,17,18,19,20,20,21,22
	.byte	23,23,24,25,25,26,27,27,28,28,29,29,30,30,31,31
	.byte	32,32,33,33,34,34,35,35,36,36,37,37,38,38,38,39
	.byte	39,40,40,40,41,41,42,42,42,43,43,43,44,44,45,45
	.byte	45,46,46,46,47,47,47,48,48,48,49,49,49,50,50,50
	.byte	51,51,51,52,52,52,52,53,53,53,54,54,54,55,55,55
	.byte	55,56,56,56,57,57,57,57,58,58,58,59,59,59,59,60
	.byte	60,60,60,61,61,61,61,62,62,62,62,63,63,63,63,64
	.byte	64,64,64,65,65,65,65,66,66,66,66,67,67,67,67,68
	.byte	68,68,68,69,69,69,69,70,70,70,70,70,71,71,71,71
	.byte	72,72,72,72,72,73,73,73,73,74,74,74,74,74,75,75
	.byte	75,75,75,76,76,76,76,77,77,77,77,77,78,78,78,78
	.byte	78,79,79,79,79,79,80,80,80,80,80,81,81,81,81,81
	.byte	82,82,82,82,82,83,83,83,83,83,84,84,84,84,84,84
	.byte	85,85,85,85,85,86,86,86,86,86,87,87,87,87,87,87
	.byte	88,88,88,88,88,89,89,89,89,89,89,90,90,90,90,90
	.byte	91,91,91,91,91,91,92,92,92,92,92,92,93,93,93,93
	.byte	93,93,94,94,94,94,94,94,95,95,95,95,95,95,96,96
	.byte	96,96,96,96,97,97,97,97,97,97,98,98,98,98,98,98
	.byte	99,99,99,99,99,99,100,100,100,100,100,100,101,101,101,101
	.byte	101,101,102,102,102,102,102,102,102,103,103,103,103,103,103,104
	.byte	104,104,104,104,104,104,105,105,105,105,105,105,106,106,106,106
	.byte	106,106,106,107,107,107,107,107,107,107,108,108,108,108,108,108
	.byte	109,109,109,109,109,109,109,110,110,110,110,110,110,110,111,111
	.byte	111,111,111,111,111,112,112,112,112,112,112,112,113,113,113,113
	.byte	113,113,113,114,114,114,114,114,114,114,115,115,115,115,115,115
	.byte	115,116,116,116,116,116,116,116,116,117,117,117,117,117,117,117
	.byte	118,118,118,118,118,118,118,119,119,119,119,119,119,119,119,120
	.byte	120,120,120,120,120,120,121,121,121,121,121,121,121,121,122,122
	.byte	122,122,122,122,122,123,123,123,123,123,123,123,123,124,124,124
	.byte	124,124,124,124,124,125,125,125,125,125,125,125,125,126,126,126
	.byte	126,126,126,126,126,127,127,127,127,127,127,127,127,128,128,128
	.byte	128,128,128,128,128,129,129,129,129,129,129,129,129,130,130,130
	.byte	130,130,130,130,130,131,131,131,131,131,131,131,131,132,132,132
	.byte	132,132,132,132,132,133,133,133,133,133,133,133,133,134,134,134
	.byte	134,134,134,134,134,134,135,135,135,135,135,135,135,135,136,136
	.byte	136,136,136,136,136,136,136,137,137,137,137,137,137,137,137,138
	.byte	138,138,138,138,138,138,138,138,139,139,139,139,139,139,139,139
	.byte	139,140,140,140,140,140,140,140,140,141,141,141,141,141,141,141
	.byte	141,141,142,142,142,142,142,142,142,142,142,143,143,143,143,143
	.byte	143,143,143,143,144,144,144,144,144,144,144,144,144,145,145,145
	.byte	145,145,145,145,145,145,146,146,146,146,146,146,146,146,146,147
	.byte	147,147,147,147,147,147,147,147,148,148,148,148,148,148,148,148
	.byte	148,148,149,149,149,149,149,149,149,149,149,150,150,150,150,150
	.byte	150,150,150,150,151,151,151,151,151,151,151,151,151,151,152,152
	.byte	152,152,152,152,152,152,152,153,153,153,153,153,153,153,153,153
	.byte	153,154,154,154,154,154,154,154,154,154,155,155,155,155,155,155
	.byte	155,155,155,155,156,156,156,156,156,156,156,156,156,156,157,157
	.byte	157,157,157,157,157,157,157,157,158,158,158,158,158,158,158,158
	.byte	158,158,159,159,159,159,159,159,159,159,159,159,160,160,160,160
	.byte	160,160,160,160,160,160,161,161,161,161,161,161,161,161,161,161
	.byte	162,162,162,162,162,162,162,162,162,162,163,163,163,163,163,163
	.byte	163,163,163,163,164,164,164,164,164,164,164,164,164,164,165,165
	.byte	165,165,165,165,165,165,165,165,166,166,166,166,166,166,166,166
	.byte	166,166,166,167,167,167,167,167,167,167,167,167,167,168,168,168
	.byte	168,168,168,168,168,168,168,168,169,169,169,169,169,169,169,169
	.byte	169,169,170,170,170,170,170,170,170,170,170,170,170,171,171,171
	.byte	171,171,171,171,171,171,171,171,172,172,172,172,172,172,172,172
	.byte	172,172,173,173,173,173,173,173,173,173,173,173,173,174,174,174
	.byte	174,174,174,174,174,174,174,174,175,175,175,175,175,175,175,175
	.byte	175,175,175,176,176,176,176,176,176,176,176,176,176,176,177,177
	.byte	177,177,177,177,177,177,177,177,177,178,178,178,178,178,178,178
	.byte	178,178,178,178,179,179,179,179,179,179,179,179,179,179,179,180
	.byte	180,180,180,180,180,180,180,180,180,180,180,181,181,181,181,181

