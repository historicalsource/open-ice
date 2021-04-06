 	.MLIB	"HHMACS.LIB"
	.FILE	"HHSCR_FN.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhscr_fn.e"
	.include	"hhpuck.g"
	.include	"hhmath.g"
	.include	"hhshow.g"
	.include	"hhutil.g"
	.include	"hhram.g"
	.include	"hhplayer.g"
	.include	"hhgame.g"
	.include	"hhcontrl.g"
	.include	"hhd.g"
	.include	"hhscr_sk.g"
	.include	"hhscr_sh.g"
	.include	"hhscr_ch.g"
	.include	"hhpall.g"
	.include	"hhscrchf.g"
	.include	"hhscrsh2.g"

; end of include files

	.TEXT
	.EVEN

**************************************************************************
*								         *
* start_panim_if_not_ta14						 *
* start_panim_if_not							 *
* 									 *
* PASS:									 *
* A6  = PLAYER BLOCK							 *
* A8  = PLAYER OBJECT							 *
* A14 = DIRECTION SCRIPT TABLE (ONLY FOR start_panim_if_not_ta14)	 *
* 									 *
* RETURN:								 *
* A1  = SCRIPT, IF SET							 *
* Z SET IF SCRIPT NOT SET, CLR IF SET					 *
* TRASHES: A0, A1						         *
*								         *
**************************************************************************
start_panim_if_not_ta14
	movb	*a6(POF_DIRECTION),a0

	dec	a0
	sll	24,a0
	srl	24,a0
	inc	a0		;safety

	sll	5,a0
	add	a14,a0
	move	*a0,a1,L
	move	*a8(ANIMSCR),a0,L
	cmp	a1,a0
	jrz	pain_9			;are scripts are the same, don't clear buffer
	movb	*a6(POF_BDIRECTION),a0
	jrz	pain_1			;no buffered direction,

	dec	a0
	sll	24,a0
	srl	24,a0
	inc	a0		;safety

	movb	a0,*a6(POF_DIRECTION)	;store our buffered direction
	movb	a0,*a6(POF_LAST_DIRECTION)	;and our last (on buffer only)
	clr	a1
	movb	a1,*a6(POF_BDIRECTION)	;zero our buffer
	sll	5,a0
	add	a14,a0			;add our table start
	move	*a0,a1,L		;get our new script and check again
start_panim_if_not
	move	*a8(ANIMSCR),a0,L
	cmp	a1,a0
	jrz	pain_9
pain_1	clr	a0			;clear out all lean data
	calla	set_deke_lean_noa3
	move	a0,*a6(POF_LEAN_GOAL),W
	move	a0,*a6(POF_LEAN),W
	move	a0,*a6(POF_LEAN_TIME),L
	;a0 cleared
	move	a1,*a8(ANIMSCR),L
	move	a1,*a8(ANIMFRM),L
	MOVE	A0,*A8(ANIMSLP),W			;CLEAR BOTH SLEEPS

	MOVE	A0,*A8(ODT_FOCIOFF0),L			;RESET FOCIS
	MOVE	A0,*A8(ODT_FOCIOFF1),L
	MOVE	A0,*A8(ODT_FHEIGHT),W

	MOVK	STAND_COLLRANGE,A0
	MOVE	*A6(POF_FLAGS),A14,W
	BTST	B_PF_GOALIE,A14
	JRZ	PAIN_D_COLL			;BR=PLAYER COLLISION RANGE
	ADDK	GSTAND_COLLRANGE-STAND_COLLRANGE,A0	;ADD GOALIE DIFFERENCE
PAIN_D_COLL
	MOVE	A0,*A6(POF_D_COLL),W
	MOVE	A0,A0				;CLR Z, SCRIPT SET

pain_9	;IF YOU JUMP HERE Z MUST BE SET TO FLAG SCRIPT NOT SET
	rets

start_lean_panim_if_not_ta14		;does not clear leans
	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	add	a14,a0
	move	*a0,a1,L
	move	*a8(ANIMSCR),a0,L
	cmp	a1,a0
	jrz	lpain_9			;are scripts are the same, don't clear buffer
	movb	*a6(POF_BDIRECTION),a0
	jrz	lpain_1			;no buffered direction,
	movb	a0,*a6(POF_DIRECTION)	;store our buffered direction
	movb	a0,*a6(POF_LAST_DIRECTION)	;and our last (on buffer only)
	clr	a1
	movb	a1,*a6(POF_BDIRECTION)	;zero our buffer
	sll	5,a0
	add	a14,a0			;add our table start
	move	*a0,a1,L		;get our new script and check again
start_lean_panim_if_not
	move	*a8(ANIMSCR),a0,L
	cmp	a1,a0
	jrz	lpain_9
lpain_1	move	a1,*a8(ANIMSCR),L
	move	a1,*a8(ANIMFRM),L
	clr	a0
	MOVE	A0,*A8(ANIMSLP),W			;CLEAR BOTH SLEEPS

	MOVE	A0,*A8(ODT_FOCIOFF0),L			;RESET FOCIS
	MOVE	A0,*A8(ODT_FOCIOFF1),L
	MOVE	A0,*A8(ODT_FHEIGHT),W

	MOVK	STAND_COLLRANGE,A0
	MOVE	*A6(POF_FLAGS),A14,W
	BTST	B_PF_GOALIE,A14
	JRZ	lPAIN_D_COLL			;BR=PLAYER COLLISION RANGE
	ADDK	GSTAND_COLLRANGE-STAND_COLLRANGE,A0	;ADD GOALIE DIFFERENCE
lPAIN_D_COLL
	MOVE	A0,*A6(POF_D_COLL),W
	MOVE	A0,A0				;CLR Z, SCRIPT SET
lpain_9	;IF YOU JUMP HERE Z MUST BE SET TO FLAG SCRIPT NOT SET
	rets

start_anim_if_not
	mmtm	sp,a0
	move	*a8(ANIMSCR),a0,L
	cmp	a1,a0
	jrz	sain_9
	calla	STRT_ANIM
	move	a8,a8		;clear z
sain_9	mmfm	sp,a0
	rets

**************************************************************************
*								         *
* a_set_pal_to_img - sets palette to that stored in oimg		 *
* 	parameters - none						 *
*								         *
**************************************************************************
a_set_pal_to_img
	move	*a8(OIMG),a1,L
	move	*a1(ICMAP),a0,L
	jauc	CHANGE_PAL

**************************************************************************
*								         *
* a_safe_branch - branch script to address				 *
* 	parameters (2 longs)						 *
* 		label to compare our animscr to				 *
* 		label to branch to on animscr match			 *
*								         *
**************************************************************************
a_safe_branch
	move	*a8(ANIMARG),a1,L
	move	*a1+,a2,L
	move	*a8(ANIMSCR),a14,L
	cmp	a2,a14
	jrnz	asb98
	move	*a1+,a3,L
	move	a3,*a8(ANIMSCR),L
	move	a3,*a8(ANIMFRM),L
asb98	rets

**************************************************************************
*								         *
* a_branch - branch script to address					 *
* 	parameters (1 long)						 *
* 		label to branch script to				 *
*								         *
**************************************************************************
a_branch
	move	*a8(ANIMARG),a14,L
	move	*a14,a14,L
	move	a14,*a8(ANIMFRM),L
	move	a14,*a8(ANIMSCR),L
	rets

**************************************************************************
*								         *
* a_speed_branchil - branch script to address if velocity is > parm	 *
*  or if we are destination of pass					 *
* 	parameters (2 longs)						 *
* 		velocity to compare against				 *
* 		label to branch script to if > velocity			 *
*								         *
**************************************************************************
a_speed_branchil
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	asbt_9			;if another animation is controlling us, abort
	btst	B_PF_HIGHER,a14
	jrnz	asbt_9
	btst	B_PF_HIGHER_W,a14
	jrnz	asbt_9
	calla	are_we_intended
	jrc	asbga
	move	*a8(ANIMARG),a14,L
	move	*a14+,a0,L
	move	*a8(ODT_VEL),a1,L
	cmp	a0,a1
	jrls	asb_9
	move	*a14,a14,L
	move	a14,*a8(ANIMFRM),L
asbt_9	rets
asbga	move	*a8(ANIMARG),a14,L
	move	*a14(020h),a0,L
	move	a0,*a8(ANIMFRM),L
	rets

**************************************************************************
*								         *
* a_speed_branch - branch script to address if velocity is > parm	 *
* 	parameters (2 longs)						 *
* 		velocity to compare against				 *
* 		label to branch script to if > velocity			 *
*								         *
**************************************************************************
a_speed_branch
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	asb_9			;if another animation is controlling us, abort
	btst	B_PF_HIGHER,a14
	jrnz	asb_9
	btst	B_PF_HIGHER_W,a14
	jrnz	asb_9
	move	*a8(ANIMARG),a14,L
	move	*a14+,a0,L
	move	*a8(ODT_VEL),a1,L
	cmp	a0,a1
	jrls	asb_9
	move	*a14,a14,L
	move	a14,*a8(ANIMFRM),L
asb_9	rets

**************************************************************************
*								         *
* a_intend_loop - loop script to label if we are destination of pass	 *
* 	parameters (1 longs)						 *
* 		label to branch script to if > velocity			 *
*								         *
**************************************************************************
a_intend_loop
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	ail_9			;if another animation is controlling us, abort
	btst	B_PF_HIGHER,a14
	jrnz	ail_9
	btst	B_PF_HIGHER_W,a14
	jrnz	ail_9
	calla	are_we_intended
	jrnc	ail_9
	move	*a8(ANIMARG),a14,L
	move	*a14+,a0,L
	move	a0,*a8(ANIMFRM),L
ail_9	rets

**************************************************************************
*								         *
* a_puck_wait   - branch script to address if we don't			 *
* 		have the puck						 *
* 	parameters (1 longs)						 *
* 		label to branch script to if we don't have puck		 *
*								         *
**************************************************************************
a_puck_wait
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	apw_9			;if another animation is controlling us, abort
	btst	B_PF_HIGHER,a14
	jrnz	apw_9
	btst	B_PF_HIGHER_W,a14
	jrnz	apw_9
	movb	*a6(POF_NUMBER),a14
	move	@PUCK_CONTROL,a0,W
	cmp	a0,a14
	jrz	apw_9
	move	*a8(ANIMARG),a14,L
	move	*a14,a14,L
	move	a14,*a8(ANIMFRM),L
apw_9	rets

**************************************************************************
*								         *
* a_accelerate_start - starts accelerating towards a player if we are cl *
* 	parameters (3 words)						 *
* 		x offset						 *
* 		z offset						 *
* 		time til we need to be in range				 *
*								         *
**************************************************************************
a_accelerate_start
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a6(POF_FLAGS),a1,W
	btst	B_PF_HUMAN,a1
	jrz	aps8			;no assistance on drone
	calla	get_push_block
	move	*a8(ANIMARG),a10,L
	move	*a11+,a1,W
	callr	accelerate_close_enough
	jrc	pmt
	move	*a11+,a1,W
	callr	accelerate_close_enough
	jrc	pmt
	move	*a11+,a1,W
	callr	accelerate_close_enough
	jrc	pmt
aps8	move	*a8(ODT_VEL),*a8(ODT_SAVEVEL),L
aps9	rets
pmt	GBLOCK	a1,a7
	move	*a7(POF_OBJECT),a9,L
	move	*a9(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
;	move	*a9(OXPOS),a0,W		;half
	move	*a9(OZPOS),a3,W
	sll	16,a3
	movx	a0,a3
	move	*a8(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
;	move	*a8(OXPOS),a0,W		;half
	move	*a8(OZPOS),a2,W
	move	*a10(010h),a4,W	;z offset
	add	a4,a2		;get offset to our push point
	move	*a10,a4,W	;x offset
	add	a4,a0
	sll	16,a2
	movx	a0,a2
	move	*a10(020h),a4,W	;time offset
	calla	SLINEVEL
	move	a1,a0
	move	a2,a1
	calla	rect_to_polar
	move	*a8(ODT_VEL),a14,L
	cmpi	[2,0],a14
	jrls	pmt_ad			;we are going slow enough, any dir is ok
	move	*a8(ODT_DIR),a14,L
	sub	a0,a14
	THETA_H	a14
	abs	a14
	cmpi	XD0500,a14
	jrhi	pmt9
pmt_ad	move	*a8(ODT_VEL),a14,L
	sub	a1,a14
	cmpi	[5,0],a14
	jrle	pmtx2
	move	*a8(ODT_VEL),a1,L
	subi	[5,0],a1
	jruc	pmxtt
pmtx2	cmpi	[-5,0],a14
	jrge	pmxtt
	move	*a8(ODT_VEL),a1,L
	addi	[5,0],a1
pmxtt	move	*a8(ODT_VEL),*a8(ODT_SAVEVEL),L
	jauc	set_obj_to_polar
pmt9	rets

accelerate_close_enough
	mmtm	sp,a1,a5,a10,a11
	move	*a10(020h),a4	;time offset
	GBLOCK	a1,a7
	move	*a7(POF_OBJECT),a9,L
	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
	move	*a9(ODT_REALXVEL),a5,L
	move	*a9(OZVEL),a10,L
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	move	*a8(ODT_REALXVEL),a11,L
	move	*a8(OZVEL),a14,L
ace1	add	a5,a0
	add	a10,a1
	add	a11,a2
	add	a14,a3
	dsjs	a4,ace1
	sra	16,a0
	sra	16,a1
	sra	16,a2
	sra	16,a3
	calla	find_dist_quick
	cmpi	100,a4
	jrls	aok
	clrc
	mmfm	sp,a1,a5,a10,a11
	rets
aok	setc
	mmfm	sp,a1,a5,a10,a11
	rets

a_accelerate_restore
	move	*a8(ODT_SAVEVEL),a1,L
	move	*a8(ODT_DIR),a0,L
	jauc	set_obj_to_polar

**************************************************************************
*								         *
* a_control_script_done							 *
* 	called at end of script						 *
* 	give control back and sets mode correctly for control		 *
*								         *
**************************************************************************
a_control_script_done
	move	*a8(ODT_PBK),a6,L	;get player block
	clr	a0
	move	a0,*a6(POF_MODE),W
	jauc	give_player_control

**************************************************************************
*								         *
* a_set_height								 *
* 	change height of image						 *
* 	parameters (1 word)						 *
* 		new height						 *
*								         *
**************************************************************************
a_set_height
	move	*a8(ANIMARG),a14,L
	move	*a14,a14,W
	move	a14,*a8(ODT_FHEIGHT),W
	rets

**************************************************************************
*								         *
* a_check_puck_cross							 *
* 	check and resolves puck crossing between points			 *
* 	parameters (4 words)						 *
* 		point1 offset [z,x] - adjusted for flip			 *
* 		point2 offset [z,x] - adjusted for flip			 *
*								         *
**************************************************************************
a_check_puck_cross
	move	*a8(ODT_PBK),a6,L
	move	*a6(POF_IGNORE_PUCK),a14,W
	jrnz	acpc9
	move	@PUCK_CONTROL,a14,W
	jrz	acpc1
	GBLOCK	a14,a7
	move	*a7(POF_MODE),a0,W
	cmpi	PM_ONETIME,a0
	jrnz	acpc9
acpc1	move	@PUCK_OBJECT,a9,L
	move	*a9(OYPOS),a14,W
	cmpi	-12,a14
	jrlt	acpc9			;puck must be lower than 12 units
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a8(ANIMARG),a14,L
	move	*a14+,a2,L
	move	*a14+,a1,L
	calla	get_supplied_offset_point
	move	a0,a6
	move	a1,a7
	move	a2,a1
	calla	get_supplied_offset_point
	move	a0,a4
	move	a1,a5
	move	*a9(OXVAL),a0,L
	move	a0,a2
	move	*a9(OXVEL),a14,L
	add	a14,a2
	sll	1,a14
	sub	a14,a0
	move	*a9(OZVAL),a1,L
	move	a1,a3
	move	*a9(OZVEL),a14,L
	add	a14,a3
	sll	1,a14
	sub	a14,a1
	callr	do_segments_cross
	jrnc	acpc9
	clr	a0
	move	a0,@PUCK_INTENDED,W
	move	a0,@PUCK_LAST_CONTROL,W
	move	a0,@bhit_dest_time,L
	move	*a9(OFLAGS),a14,W	;
	ori	M_FVELADD,a14		; makes puck stick one veladd
	move	a14,*a9(OFLAGS),W	;
	movk	30,a14
	mmtm	sp,a6
	move	*a8(ODT_PBK),a6,L
	move	a14,*a6(POF_IGNORE_PUCK),W
	move	@WAVEIRQS,@PUCK_NEWDIR_TIME,L
	calla	set_puck_outlaw
	calla	record_puck_a6
	mmfm	sp,a6


	calla	RANDOM
	btst	0,a0
	jrnz	hs_bn		;hits stick, bounces off
hs_bo	move	*a9(ODT_DIR),a0,L	;bounces over
	move	a0,a1
	addi	XD0200,a0
	subi	XD0200,a1
	calla	RANGERND
	jruc	hs_cont
hs_bn	move	a4,a0
	move	a5,a1
	move	a6,a2
	move	a7,a3
	calla	find_dir_to_point	;now get our stick angle
	addi	XD0900,a0		;get normal to stick
	move	a0,a2
	move	*a9(ODT_DIR),a1,L
	calla	compute_bounce_angle
	jrc	hs_bn1
	addi	XD1800,a2
	THETA_N	a2
	calla	compute_bounce_angle
hs_bn1	move	a3,a0
	move	a3,a1
	addi	XD0200,a0
	subi	XD0200,a1
	calla	RANGERND
	add	a2,a0
hs_cont	THETA_N	a0
	move	*a9(ODT_VEL),a1,L
	sra	2,a1
	move	a1,a4
	move	a8,a10
	move	a9,a8
	calla	set_obj_to_polar
	move	a4,a0
	calla	RAND0		;random y vel based on speed
	cmpi	[1,0],a0
	jrlt	acpc3		;no y velocity if too low
	neg	a0
	move	a0,*a8(OYVEL),L
	calla	give_puck_gravity
acpc3	calla	puck_stick_bounce_sound
	move	a10,a8
acpc9	move	*a8(ANIMARG),a14,L
	addi	64,a14
	move	a14,*a8(ANIMARG),L
	rets

**************************************************************************
*								         *
* do_segments_cross							 *
* 	input	a0,a1	point 1 line 1					 *
* 		a2,a3	point 2 line 1					 *
* 		a4,a5	point 1 line 2					 *
* 		a6,a7	point 2 line 2					 *
*								         *
**************************************************************************
do_segments_cross
	mmtm	sp,a0,a1,a2,a3,a5,a6
	move	a0,b0
	move	a1,b1
	move	a2,b2
	move	a3,b3			;save our necessary stuff

	move	b0,a2
	move	b1,a3
	move	a4,a0
	move	a5,a1
	calla	find_dir_to_point	;line 1 point 1 (0) to line 2 point 1 (2)
	move	a0,b4
	move	a4,a2
	move	a5,a3
	move	b2,a0
	move	b3,a1
	calla	find_dir_to_point	;line 2 point 1 (2) to line 1 point 2 (1)
	move	a0,b5
	move	b0,a2
	move	b1,a3
	move	a6,a0
	move	a7,a1
	calla	find_dir_to_point	;line 1 point 1 (0) to line 2 point 2 (3)
	move	a0,b6
	move	a6,a2
	move	a7,a3
	move	b2,a0
	move	b3,a1
	calla	find_dir_to_point	;line 2 point 2 (3) to line 1 point 2 (1)
	move	a0,a3
	move	b6,a2
	move	b5,a1
	move	b4,a0
	jruc	gc_cw1

**************************************************************************
*								         *
* get_c_cw								 *
* 	input	a0 = angle 0 to 2					 *
* 		a1 = angle 2 to 1					 *
* 		a2 = angle 0 to 3					 *
* 		a3 = angle 3 to 1					 *
* 	output	c  = line segments intersect				 *
* 		nc = line segments don't intersect			 *
*								         *
**************************************************************************
get_c_cw
	mmtm	sp,a0,a1,a2,a3,a5,a6
gc_cw1	move	a1,a5
	move	a3,a6
	sub	a0,a1
	THETA_H	a1
	sub	a2,a3
	THETA_H	a3
	sra	31,a3
	sra	31,a1
	cmp	a3,a1
	jrz	gccwn
	addi	XD1800,a0
	addi	XD1800,a6
	sub	a0,a2
	THETA_H	a2
	sub	a5,a6
	THETA_H	a6
	sra	31,a6
	sra	31,a2
	cmp	a6,a2
	jrz	gccwn
gccwy	setc
	mmfm	sp,a0,a1,a2,a3,a5,a6
	rets
gccwn	clrc
	mmfm	sp,a0,a1,a2,a3,a5,a6
	rets

**************************************************************************
*								         *
* a_collision	- checks and resolves collision in animation scripts	 *
* 	parameters (6 words)						 *
* 		x range [-,+]						 *
* 		z range [-,+]						 *
* 		routine to run on collision				 *
*								         *
**************************************************************************
a_collision
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a6(POF_HAS_CHECKED),a14,W
	jrnz	acolle
	move	*a8(ANIMARG),a14,L
	move	*a14+,a3,L		;x range
	move	*a14+,a2,L		;z range
	move	*a14+,a11,L
	jauc	collision_check
acolle	rets

**************************************************************************
*								         *
* a_collision_puck - checks and resolves collision in animation scripts	 *
* 	parameters (6 words)						 *
* 		x range [-,+]						 *
* 		z range [-,+]						 *
* 		routine to run on collision				 *
*								         *
**************************************************************************
a_collision_puck
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a6(POF_HAS_CHECKED),a14,W
	jrnz	acplle
	move	*a8(ANIMARG),a14,L
	move	*a14+,a3,L		;x range
	move	*a14+,a2,L		;z range
	move	*a14+,a11,L
	jruc	puck_collision_check
acplle	rets

**************************************************************************
*								         *
* puck_collision_check							 *
* 	input	a6 = player block					 *
* 		a8 = player object					 *
* 		a2 = z range to check against [low,high]		 *
* 		a3 = x range to check against [low,high]		 *
* 		a11= routine to run on collision			 *
*								         *
**************************************************************************
puck_collision_check
	PUSH	a11
	subi	[1,0],a2
	subi	[1,0],a3	;makes checks easier
	move	*a8(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
	move	a0,a14
	sll	16,a14
	movx	a0,a14
	addxy	a14,a3
	move	*a8(OZPOS),a0,W
	move	a0,a14
	sll	16,a14
	movx	a0,a14
	addxy	a14,a2			;now a2 and a3 are adjusted for our position
	calla	check_collision_puck
	jrc	ccp_7
	PULLQ	a11
	rets
ccp_7	move	@PUCK_CONTROL,a11,W
	jrnz	cpx77
	move	@PUCK_MODE,a11,W
	cmpi	PUM_PASS,a11
	jrz	cpx78
	cmpi	PUM_TPASS,a11
	jrnz	cpx77
cpx78	move	@PUCK_INTENDED,a11,W
	cmp	a0,a11
	jrnz	cpx77
	clr	a11
	move	a11,@not_free_receiver,W	;free to move after hit
cpx77	PULLQ	a11
	jump	a11	;a0 = player we hit, a7 = block, a9 = obj
a_flip_no_shoot_button
	callr	a_set_15_flip
	jauc	a_no_shoot_button
a_flip_accelerate_start
	callr	a_set_15_flip
	jruc	a_accelerate_start
a_flip_collision_puck
	callr	a_set_15_flip
	jruc	a_collision_puck
a_flip_collision
	callr	a_set_15_flip
	jruc	a_collision

a_set_15_flip
	move	*a8(ODT_PBK),a6,L
	move	*a8(OCTRL),a14,W
	andni	M_FLIPH,a14
	movb	*a6(POF_NUMBER),a0
	dec	a0
	srl	2,a0
	jrz	sfnf
	ori	M_FLIPH,a14
sfnf	move	a14,*a8(OCTRL),W
	rets

a_clear_otd
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a6(POF_FLAGS),a0,W
	andni	M_PF_OTD,a0
	move	a0,*a6(POF_FLAGS),W
	rets
a_set_release_est_r_otd
	callr	a_set_release_est
	move	*a6(POF_FLAGS),a0,W
	andni	M_PF_OTD,a0
	move	a0,*a6(POF_FLAGS),W
	move	*a14,a0,L
	jump	a0
a_set_release_est_r
	callr	a_set_release_est
	move	*a14,a0,L
	jump	a0

a_set_release_est
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a8(ANIMARG),a14,L
	move	*a14+,a0,W
	move	@WAVEIRQS,a1,L
	add	a1,a0
	move	a0,*a6(POF_RELEASE_TIME),L
	rets

**************************************************************************
*								         *
* a_bface - changes buffered direction (POF_BDIRECTION) for use when	 *
*  changing scripts							 *
* 	parameters (1 word)						 *
* 		POF_BDIRECTION						 *
*								         *
**************************************************************************
a_bface
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a8(ANIMARG),a14,L
	move	*a14,a14,W
	movb	a14,*a6(POF_BDIRECTION)
	rets

**************************************************************************
*								         *
* a_bfaceiloop - changes buffered direction for use when changing        *
*  scripts - loops when intended					 *
* 	parameters (3 words)						 *
* 		POF_BDIRECTION						 *
* 		loop address						 *
*								         *
**************************************************************************
a_bfaceiloop
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a8(ANIMARG),a14,L
	move	*a14+,a0,W
	movb	a0,*a6(POF_BDIRECTION)
	move	*a14,a0,L
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	abil_9			;if another animation is controlling us, abort
	btst	B_PF_HIGHER,a14
	jrnz	abil_9
	btst	B_PF_HIGHER_W,a14
	jrnz	abil_9
	calla	are_we_intended
	jrnc	abil_9
	move	a0,*a8(ANIMFRM),L
abil_9	rets

**************************************************************************
*								         *
* a_2face - sets direction, and last direction				 *
* 	(f to r, r to f)						 *
* 	parameters (1 word)						 *
* 		POF_DIRECTION						 *
*								         *
**************************************************************************
a_2face
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a8(ANIMARG),a14,L
	move	*a14,a14,W
	movb	a14,*a6(POF_DIRECTION)
	movb	a14,*a6(POF_LAST_DIRECTION)
	rets

**************************************************************************
*								         *
* a_set_loopc - sets loop count						 *
* 	parameters (1 word)						 *
* 		loop count value					 *
*								         *
**************************************************************************
a_set_loopc
	move	*a8(ANIMARG),a14,L
	move	*a14+,a0,W
	move	a0,*a8(ODT_LOOPC),W
	rets

**************************************************************************
*								         *
* a_dec_or_lshoot - decrements loop count				 *
* 		 loops if count <>0 or shoot button is up		 *
* 		 aborts if mode is not PM_BLOCK (we've been hit)	 *
* 		 aborts if we are in ignore mode (we just hit puck)	 *
* 	parameters (2 words)						 *
* 		address to branch to					 *
*								         *
**************************************************************************
a_dec_or_lshoot
	move	*a8(ODT_LOOPC),a14,W
	dec	a14
	jrz	ados_9
	move	a14,*a8(ODT_LOOPC),W
	move	*a8(ODT_PBK),a6,L
	move	*a6(POF_IGNORE_PUCK),a14,W
	jrz	ados_1
	move	*a8(ODT_LOOPC),a14,W
	cmpi	15,a14
	jrls	ados_1
	movk	15,a14
	move	a14,*a8(ODT_LOOPC),W
ados_1	move	*a6(POF_MODE),a14,W
	cmpi	PM_BLOCK,a14
	jrnz	ados_9
	move	*a6(POF_BUTTONS),a14,W
	btst	0,a14
	jrz	ados_9
	move	*a8(ANIMARG),a14,L
	move	*a14,a14,L
	move	a14,*a8(ANIMFRM),L
ados_9	rets

a_delete_obj
	jauc	DELETE_OBJ

