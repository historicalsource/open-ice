 	.MLIB	"HHMACS.LIB"
	.FILE	"HHSCRCHF.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhscrchf.e"
	.include	"hhcontrl.g"
	.include	"hh.g"
	.include	"hhshow.g"
	.include	"hhpuck.g"
	.include	"hhutil.g"
	.include	"hhcontr2.g"
	.include	"hhmath.g"
	.include	"hhspeech.g"
	.include	"hhscr_fn.g"
	.include	"hhplayer.g"
	.include	"hhcontr3.g"
	.include	"hhram.g"
	.include	"hhpup.g"
	.include	"hhscr_ch.g"
	.include	"hhgscr.g"
	.include	"hhc.g"
	.include	"hhgscrf.g"

; end of include files

	.TEXT
	.EVEN
a_set_flyv_1
	movi	-054800h,a0
	move	a0,*a8(OYVEL),L
	movi	[0,08100h],a0
	move	a0,*a8(OYACCEL),L
	rets

a_pf_set_flipv_1
	clr	a0
	move	*a8(OXVEL),a14,L
	jrnn	apfv1
	movi	M_FLIPH,a0
apfv1	move	*a8(OCTRL),a1,W
	andni	M_FLIPH,a1
	or	a0,a1
	move	a1,*a8(OCTRL),W
	rets

a_slow_v
	move	*a8(ODT_VEL),a0,L
	callr	i8i8
	move	a0,*a8(ODT_VEL),L
	move	*a8(OXVEL),a0,L
	callr	i8i8
	move	a0,*a8(OXVEL),L
	move	*a8(OZVEL),a0,L
	callr	i8i8
	move	a0,*a8(OZVEL),L
	rets

a_stop_v
	clr	a0
	move	a0,*a8(ODT_VEL),L
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OZVEL),L
	rets

i8i8	move	a0,a14
	sra	3,a14
	sub	a14,a0
	rets

a_set_flipv_1
	movi	-050000h,a0
	move	a0,*a8(OYVEL),L
	movi	[0,08100h],a0
	move	a0,*a8(OYACCEL),L
	rets

a_set_flipv_2
	movi	-085000h,a0
	move	a0,*a8(OYVEL),L
	movi	[0,08100h],a0
	move	a0,*a8(OYACCEL),L
	rets

a_screen_shake_snd
	calla	body_fall_sound
	calla	body_slam_sound
	calla	body_fall_sound
	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jaz	screen_shake	;shake us if on screen
	rets

a_maybe_spagetti
	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrnz	amss_9
	movi	10,a0
	calla	RANDPER
	jrnc	amss_9
	calla	spx_spagetti
amss_9	rets

a_slow_us_chk
	callr	a_slow_us
	jauc	a_collision
a_slow_us
	move	*a8(ODT_VEL),a1,L
	clr	a2
	movi	20,a3
	calla	move_to_s_no_r
	move	*a8(ODT_DIR),a0,L
	jauc	set_obj_to_polar

a_set_whack
	move	@whack_goalie_count,a14,W
	inc	a14
	move	a14,@whack_goalie_count,W
	rets

;--

a_sound_for_steal
	move	*a8(ODT_PBK),a6,L
	movb	*a6(POF_NUMBER),a0
	move	@PUCK_CONTROL,a1,W
	jrz	ass_fr		;we freed it
	cmp	a0,a1
	jrz	ass_gt		;we got it
ass_ng	jauc	steal_miss_sound
ass_fr	jauc	steal_freed_sound
ass_gt	jauc	steal_made_sound

resolve_count_a6a7_long
	mmtm	sp,a0,a1
	move	*a6(POF_PUP_FLAGS),a14,W
	btst	B_PUP_CHECK,a14
	jrz	nprck1
	movi	15,a0
	jruc	nprck1a
nprck1	move	*a6(POF_S_CHEK),a14,L		;pup chek change here
	move	*a14(PS_CK_SKILL),a0,W
nprck1a	move	*a7(POF_S_CHEK),a14,L		;no pup chek change needed
	move	*a14(PS_CK_SKILL),a1,W
	sub	a1,a0
	addk	5,a0		;1 to 9, light to medium hit
	sll	5,a0		;* 32
	addi	80,a0
	move	a0,*a7(POF_GET_UP_GOAL),W
	mmfm	sp,a0,a1
	rets

resolve_count_a6a7
	mmtm	sp,a0,a1
	move	*a6(POF_PUP_FLAGS),a14,W
	btst	B_PUP_CHECK,a14
	jrz	nprck2
	movi	15,a0
	jruc	nprck2a
nprck2	move	*a6(POF_S_CHEK),a14,L		;pup chek change here
	move	*a14(PS_CK_SKILL),a0,W
nprck2a	move	*a7(POF_S_CHEK),a14,L		;no pup chek change needed
	move	*a14(PS_CK_SKILL),a1,W
	sub	a1,a0
	addk	5,a0		;1 to 9, light to medium hit
	sll	5,a0		;* 32
	move	*a6(POF_OBJECT),a1,L
	move	*a1(ODT_VEL+010h),a1,W
	cmpi	10,a1
	jrls	rc67_1
	movk	10,a1
rc67_1	sll	3,a1
	add	a1,a0
	move	a0,*a7(POF_GET_UP_GOAL),W
	mmfm	sp,a0,a1
	rets

a_start_get_up_count
	move	*a8(ODT_PBK),a6,L
	clr	a14
	move	a14,*a6(POF_GET_UP_COUNT),W
	rets

a_wait_get_up
	move	*a8(ANIMARG),a1,L
	move	*a1+,a14,L
	move	*a8(ANIMSCR),a6,L
	cmp	a6,a14
	jrnz	awgu_9
	move	*a8(ODT_PBK),a6,L
	move	*a6(POF_GET_UP_COUNT),a14,W
	addk	10,a14
	move	a14,*a6(POF_GET_UP_COUNT),W
	move	*a6(POF_GET_UP_GOAL),a0,W
	cmp	a0,a14
	jrhs	awgu_9
	move	*a1+,a14,L
	move	a14,*a8(ANIMFRM),L
awgu_9	rets

a_fall_stopv
	clr	a0
	move	a0,*a8(ODT_VEL),L	;vector velocity
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OZVEL),L
	rets

a_fall_done
	move	*a8(ODT_PBK),a6,L	;get player block
	clr	a0
	move	a0,*a6(POF_MODE),W
	jauc	give_player_control


a_steal_done
	move	*a8(ODT_PBK),a6,L	;get player block
	clr	a0
	move	a0,*a6(POF_MODE),W
	jauc	give_player_control


**************************************************************************
*								         *
* collision_check							 *
* 	input	a6 = player block					 *
* 		a8 = player object					 *
* 		a2 = z range to check against [low,high]		 *
* 		a3 = x range to check against [low,high]		 *
* 		a11= routine to run on collision			 *
*								         *
**************************************************************************
collision_check
	PUSH	a11
	subi	[1,0],a2
	subi	[1,0],a3	;makes checks easier
	move	*a8(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
;	move	*a8(OXPOS),a0,W		;half
	move	a0,a14
	sll	16,a14
	movx	a0,a14
	addxy	a14,a3
	move	*a8(OZPOS),a0,W
	move	a0,a14
	sll	16,a14
	movx	a0,a14
	addxy	a14,a2			;now a2 and a3 are adjusted for our position
	callr	get_push_block		;returns a11 pointing to list
	movk	5,b1
ccx1	move	*a11+,a0,W
	callr	check_collision_player
	jrc	ccx_7
	dsjs	b1,ccx1
rrx7n	PULLQ	a11
	clrc
	rets
ccx_7	move	*a7(POF_CONTROL_OBJECT),a14,L
	jrnz	rrx7n
	move	*a7(POF_CONTROLLED),a14,L
	jrnz	rrx7n
	move	*a7(POF_CONTROL_SCRIPT),a14,L
	jrnz	rrx7n
	move	*a7(POF_CONTROLLED_SCRIPT),a14,L
	jrnz	rrx7n
ccx7y	move	@PUCK_CONTROL,a11,W
	jrnz	ccx77
	move	@PUCK_MODE,a11,W
	cmpi	PUM_PASS,a11
	jrz	ccx78
	cmpi	PUM_TPASS,a11
	jrnz	ccx77
ccx78	move	@PUCK_INTENDED,a11,W
	cmp	a0,a11
	jrnz	ccx77
	clr	a11
	move	a11,@not_free_receiver,W	;free to move after hit
ccx77	PULLQ	a11
	call	a11	;a0 = player we hit, a7 = block, a9 = obj
	setc
	rets

get_push_block
	movb	*a6(POF_NUMBER),a0
	dec	a0
	move	a0,a11
	move	a0,a14
	sll	4,a0
	sll	5,a11
	sll	6,a14
	add	a11,a0
	add	a14,a0			;112 * (player - 1)
	move	@PUCK_CONTROL,a11,W
	move	a11,a14
	move	a11,a10
	sll	7,a11
	sll	8,a14
	sll	9,a10
	add	a14,a11
	add	a10,a11			; 896 * puck_control
	add	a0,a11			;112 pl + 896 puck
	addi	push_order_list,a11	;a11 is address of check order list
	rets

check_collision_puck	;a2,a3 = range
	move	@PUCK_OBJECT,a9,L
	move	*a9(OXVAL),a1,L
	addi	[0,08000h],a1
	sra	16,a1
	move	a1,a14
	sll	16,a14
	movx	a1,a14
	cmpxy	a3,a14
	jryle	cppn
	jrxgt	cppn
	move	*a9(OZPOS),a1,W
	move	a1,a14
	sll	16,a14
	movx	a1,a14
	cmpxy	a2,a14
	jryle	cppn
	jrxgt	cppn
cppy	setc
	rets
cppn	clrc
	rets

check_collision_player	;a0 = player, a2,a3 = range
	GBLOCK	a0,a7
	move	*a7(POF_OBJECT),a9,L
	move	*a9(OYVAL),a14,L
	jrn	ccpn			;if we are flying through the air, no collision
	move	*a9(OXVAL),a1,L
	addi	[0,08000h],a1
	sra	16,a1
	move	a1,a14
	sll	16,a14
	movx	a1,a14
	cmpxy	a3,a14
	jryle	ccpn
	jrxgt	ccpn
	move	*a9(OZPOS),a1,W
	move	a1,a14
	sll	16,a14
	movx	a1,a14
	cmpxy	a2,a14
	jryle	ccpn
	jrxgt	ccpn
ccpy	setc
	rets
ccpn	clrc
	rets

push_order_list
	.word	5,6,8,2,4,0,0	;player 1 - nobody has puck
	.word	6,5,8,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	5,6,8,2,1,0,0	;player 4
	.word	2,1,4,6,8,0,0	;player 5
	.word	1,2,4,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	2,1,4,5,6,0,0	;player 8

	.word	5,6,8,2,4,0,0	;player 1 - player 1 has puck
	.word	6,5,8,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	5,6,8,2,1,0,0	;player 4
	.word	1,2,4,6,8,0,0	;player 5
	.word	1,2,4,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	1,2,4,5,6,0,0	;player 8

	.word	5,6,8,2,4,0,0	;player 1 - player 2 has puck
	.word	6,5,8,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	5,6,8,2,1,0,0	;player 4
	.word	2,1,4,6,8,0,0	;player 5
	.word	2,1,4,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	2,1,4,5,6,0,0	;player 8

	.word	1,1,1,1,1,0,0	;player 1 - player 3 has puck
	.word	1,1,1,1,1,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	1,1,1,1,1,0,0	;player 4
	.word	1,1,1,1,1,0,0	;player 5
	.word	1,1,1,1,1,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	1,1,1,1,1,0,0	;player 8

	.word	5,6,8,2,4,0,0	;player 1 - player 4 has puck
	.word	6,5,8,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	5,6,8,2,1,0,0	;player 4
	.word	4,2,1,6,8,0,0	;player 5
	.word	4,1,2,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	4,2,1,5,6,0,0	;player 8

	.word	5,6,8,2,4,0,0	;player 1 - player 5 has puck
	.word	5,6,8,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	5,6,8,2,1,0,0	;player 4
	.word	2,1,4,6,8,0,0	;player 5
	.word	1,2,4,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	2,1,4,6,5,0,0	;player 8

	.word	6,5,8,2,4,0,0	;player 1 - player 6 has puck
	.word	6,5,8,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	6,5,8,2,1,0,0	;player 4
	.word	2,1,4,6,8,0,0	;player 5
	.word	1,2,4,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	2,1,4,5,6,0,0	;player 8

	.word	1,1,1,1,1,0,0	;player 1 - player 7 has puck
	.word	1,1,1,1,1,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	1,1,1,1,1,0,0	;player 4
	.word	1,1,1,1,1,0,0	;player 5
	.word	1,1,1,1,1,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	1,1,1,1,1,0,0	;player 8

	.word	8,5,6,2,4,0,0	;player 1 - player 8 has puck
	.word	8,6,5,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	8,5,6,2,1,0,0	;player 4
	.word	2,1,4,6,8,0,0	;player 5
	.word	1,2,4,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	2,1,4,5,6,0,0	;player 8

**************************************************************************
*								         *
* resolve collision routines						 *
* 	input	a0 = player hit						 *
* 		a7 = player hit's block					 *
* 		a9 = player hit's object				 *
* 		a6 = player doing hit's block				 *
* 		a8 = player doing hit's object				 *
*								         *
**************************************************************************
**************************************************************************
*								         *
* take_puck								 *
*								         *
**************************************************************************
take_puck
	move	@PUCK_CONTROL,a14,W
	cmp	a0,a14
	jrnz	tpff9
	;
take_puck_or_free_only
	move	@WAVEIRQS,a14,L
	move	@PUCK_NEWDIR_TIME,a0,L
	sub	a0,a14
	cmpi	60,a14		;1 second
	jrlt	tpff9
	move	*a6(POF_HAS_CHECKED),a14,W
	inc	a14
	move	a14,*a6(POF_HAS_CHECKED),W
	movb	*a6(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	move	@PUCK_CONTROL,a14,W
	jrz	tpff9
	cmp	a0,a14
	jrz	tpff9
	GBLOCK	a14,a7
	move	*a7(POF_MODE),a14,W
	cmpi	PM_ONETIME,a14
	jrz	tpfff
	movb	*a7(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	MOVE	*A7(POF_FLAGS),A14,W
	BTST	B_PF_GOALIE,A14
	jrnz	tpff9
	CLR	A0
	MOVE	A0,*A7(POF_MODE),W
	calla	record_steal_a6
	calla	inc_hot_single
	calla	a6_take_from_a7_swat		;we will free it if we are near net
	calla	puck_steal_show
	calla	spx_steal
	move	@PUCK_CONTROL,a0,W
	jrnz	tpff9			;we didn't free puck, don't mess with it
	calla	record_puck_a6		;give us a touch, if we free it
	move	@PUCK_OBJECT,a8,L
	move	*a8(ODT_REALXVEL),a0,L
	move	*a8(OZVEL),a1,L
	calla	rect_to_dir
	move	*a8(ODT_VEL),a1,L
	jauc	set_obj_to_polar
tpfff	clr	a0
	move	a0,@PUCK_CONTROL,W	;if it is open, then we get it
	jauc	new_puck_control
tpff9	rets

**************************************************************************
*								         *
* get_elbowed								 *
*								         *
**************************************************************************
get_elbowed
	move	*a6(POF_HAS_CHECKED),a14,W
	inc	a14
	move	a14,*a6(POF_HAS_CHECKED),W
	move	*a7(POF_FLAGS),a14,W
	btst	B_PF_HIGHER,a14
	jrnz	gp9
	btst	B_PF_HIGHER_W,a14
	jrnz	gp9
	btst	B_PF_GOALIE,a14
	jrnz	gp9			;can't elbow goalie
	callr	zero_a9_y
	calla	inc_hot_single
	movk	1,a0
	callr	take_turbo
	callr	take_extra_check
	calla	record_check_a6
	calla	take_player_control_a7
	movb	*a7(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	movb	*a6(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	calla	player_grunt_sound
	callr	a6_take_from_a7
	move	*a7(POF_MODE),a0,W
	cmpi	PM_FALL,a0
	jrz	gp9
	movk	PM_SHAKE,a0
	move	a0,*a7(POF_MODE),W
	calla	set_player_script_a79
	calla	spx_check_hit_elbow
	jruc	give_velocity_to_a9_eb

**************************************************************************
*								         *
* get_pushed								 *
*								         *
**************************************************************************
get_pushed
	callr	is_flying_ok
	jrc	get_pushed_flying
	move	*a6(POF_HAS_CHECKED),a14,W
	inc	a14
	move	a14,*a6(POF_HAS_CHECKED),W
	move	*a7(POF_FLAGS),a14,W
	btst	B_PF_HIGHER,a14
	jrnz	gp9
	btst	B_PF_HIGHER_W,a14
	jrnz	gp9
	btst	B_PF_GOALIE,a14
	jrnz	GHS_GOALIE

	callr	zero_a9_y
	calla	inc_hot_ifp_a7
	movk	1,a0
	callr	take_turbo
	callr	take_extra_check
	calla	record_check_a6
	calla	take_player_control_a7
	movb	*a7(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	movb	*a6(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	callr	is_hitback
	jrc	hit_bck
hit_fnt	calla	player_grunt_sound
	callr	a6_take_from_a7
	move	*a7(POF_MODE),a0,W
	cmpi	PM_FALL,a0
	jrz	gp9
	movk	PM_SHAKE,a0
	move	a0,*a7(POF_MODE),W
	calla	set_player_script_a79
	calla	spx_check_hit_push1
	jruc	give_velocity_to_a9
hit_bck	calla	body_slam_sound
	callr	a6_take_from_a7
	move	*a7(POF_MODE),a0,W
	cmpi	PM_FALL,a0
	jrz	gp9
	movk	PM_FALL,a0
	move	a0,*a7(POF_MODE),W
	callr	resolve_count_a6a7
	calla	set_player_script_a79
	calla	spx_check_hit_push2
	jruc	give_velocity_to_a9
gp9	rets

is_flying_ok
	move	*a8(ODT_SAVEVEL),a14,L
	cmpi	[7,0],a14
	jrls	ifo_n
	move	*a7(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	ifo_n
	setc
	rets
ifo_n	clrc
	rets

get_pushed_flying
	callr	zero_a9_y

	mmtm	sp,a0,a1,a8
	movb	*a6(POF_DIRECTION),*a7(POF_DIRECTION)
	move	*a8(ODT_SAVEVEL),a1,L
	move	a1,a14
	sra	3,a14
	sub	a14,a1
	move	*a8(ODT_DIR),a0,L
	move	a9,a8
	calla	set_obj_to_polar
	mmfm	sp,a0,a1,a8

	calla	inc_hot_ifp_a7
	movk	1,a0
	callr	take_turbo
	callr	take_extra_check
	calla	record_check_a6
	calla	spx_check_hit_flying
	calla	take_player_control_a7
	movb	*a7(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	movb	*a6(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	calla	player_grunt_sound
	calla	body_slam_sound
	movk	PM_FALL,a0
	move	a0,*a7(POF_MODE),W
	callr	resolve_count_a6a7
	calla	set_gofly_script_a7
	movb	*a7(POF_NUMBER),a0
	move	@PUCK_CONTROL,a14,W
	cmp	a0,a14
	jrnz	ghh9
	movk	30,a0
	movb	a0,*a6(POF_IGNORE_PUCK)
	movb	a0,*a7(POF_IGNORE_PUCK)
	move	@PUCK_OBJECT,a0,L
	move	*a0(OXVEL),a14,L
	sra	1,a14
	move	a14,*a0(OXVEL),L
	move	*a0(OZVEL),a14,L
	sra	1,a14
	move	a14,*a0(OZVEL),L
	move	*a0(ODT_VEL),a14,L
	sra	1,a14
	move	a14,*a0(ODT_VEL),L
	clr	a0
	move	a0,@PUCK_CONTROL,W
	jauc	new_puck_control

**************************************************************************
*								         *
* get_highsticked							 *
*								         *
**************************************************************************
get_slashed
	move	*a7(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	ghs9
	btst	B_PF_HIGHER,a14
	jrnz	ghs9
	btst	B_PF_HIGHER_W,a14
	jrnz	ghs9
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrz	ghs_go1				;br=not goalie
	movb	*a6(POF_NUMBER),a0		;GOALIE
	movb	*a7(POF_NUMBER),a1		;PLAYER			
	EQTEAM	a0,a1
	jrz	ghs9				;br=both on same side
ghs_go1	calla	spx_check_hit_slash
	callr	zero_a9_y
	calla	inc_hot_ifp_a7
	movk	1,a0
	callr	take_turbo
	callr	take_extra_check
	calla	record_check_a6
	calla	take_player_control_a7
	movb	*a7(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	movb	*a6(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	calla	player_grunt_sound
	calla	body_slam_sound
	callr	a6_take_from_a7
	move	*a7(POF_MODE),a0,W
	cmpi	PM_FALL,a0
	jrz	ghs9
	movk	PM_FALL,a0
	move	a0,*a7(POF_MODE),W
	callr	resolve_count_a6a7

	calla	set_1flipped_script_a7

	MOVI	diropr,A1			;PLAYER THROW TABLE
	MOVE	*A6(POF_FLAGS),A14,W
	BTST	B_PF_GOALIE,A14
	JRZ	THROW_A9			;BR=PLAYER IS THROWING
	MOVI	GDIROPT,A1			;GOALIE THROW TABLE
	JRUC	THROW_A9			;GOALIE IS THROWING

get_highsticked
	callr	is_flying_ok
	jrc	get_pushed_flying
	move	*a7(POF_FLAGS),a14,W
	btst	B_PF_HIGHER,a14
	jrnz	ghs9
	btst	B_PF_HIGHER_W,a14
	jrnz	ghs9
	btst	B_PF_GOALIE,a14
	jrnz	GHS_GOALIE

	MOVE	*A6(POF_FLAGS),A14,W
	BTST	B_PF_GOALIE,A14
	JRZ	GHS_GO				;BR=NOT GOALIE

	MOVB	*A6(POF_NUMBER),A0		;GOALIE
	MOVB	*A7(POF_NUMBER),A1		;PLAYER			
	EQTEAM	A0,A1
	JRZ	ghs9				;BR=BOTH ON SAME SIDE
GHS_GO
	calla	spx_check_hit_high
ghs_con	callr	zero_a9_y
	calla	inc_hot_ifp_a7
	movk	1,a0
	callr	take_turbo
	callr	take_extra_check
	calla	record_check_a6
	calla	take_player_control_a7
	movb	*a7(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	movb	*a6(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	calla	player_grunt_sound
	calla	body_slam_sound
	callr	a6_take_from_a7
	move	*a7(POF_MODE),a0,W
	cmpi	PM_FALL,a0
	jrz	ghs9
	movk	PM_FALL,a0
	move	a0,*a7(POF_MODE),W
	callr	resolve_count_a6a7
	calla	set_player_script_a79

	MOVI	diropr,A1			;PLAYER THROW TABLE
	MOVE	*A6(POF_FLAGS),A14,W
	BTST	B_PF_GOALIE,A14
	JRZ	THROW_A9			;BR=PLAYER IS THROWING
	MOVI	GDIROPT,A1			;GOALIE THROW TABLE
	JRUC	THROW_A9			;GOALIE IS THROWING
ghs9	rets

GDIROPT
	.word	-8,0
	.word	-6,6
	.word	0,8
	.word	6,6
	.word	8,0
	.word	6,-6
	.word	0,-8
	.word	-6,-6

GHS_GOALIE
	MOVE	*A7(POF_MODE),A14,W
	CMPI	PM_GHUGPOST,A14
	JREQ	GHS_G_GO
;	CMPI	PM_GSIDESHUFF,A14
;	JREQ	GHS_G_GO
	CMPI	PM_GSTAND,A14
	JREQ	GHS_G_GO
	CMPI	PM_GSKID,A14
	JREQ	GHS_G_GO
	CMPI	PM_GSKATE,A14
	JREQ	GHS_G_GO
;	JREQ	GHS_G_CHECK_CTRL		;BR=CHECK IF PUCK ON STICK
	CMPI	PM_GHOLDING,A14
	JRNE	ghs9				;BR=HOLDING PUCK

;GHS_G_CHECK_CTRL
	MOVB	*A7(POF_NUMBER),A0
	MOVE	@PUCK_CONTROL,A14,W
	CMP	A0,A14
	JRNE	GHS_G_GO

	calla	inc_hot_ifp_a7

	CLR	A14				;PUM_OPEN
	calla	set_safe_puck_mode_a14
	MOVE	@PUCK_CONTROL,@PUCK_LAST_CONTROL,W
	CLR	A14
	MOVE	A14,@PUCK_INTENDED,W
	MOVE	A14,@PUCK_CONTROL,W
	CALLA	new_puck_control

	CLR	A14
	MOVE	A14,*A9(ODT_GPOSSIRQ),L		;RESET IRQ TIME OF POSSESSION

	PUSH	A8

	MOVI	60,A0
	CALLA	ALL_IGNORE_PUCK

	MOVB	*A7(POF_DIRECTION),A0
	CALLA	dir_to_degrees
	MOVE	A0,A1
	ADDI	XD0450,A0
	SUBI	XD0450,A1
	CALLA	RANGERND
	MOVE	A0,A2

	MOVI	018000H,A0
	MOVI	010000H,A1
	CALLA	RANGERND
	MOVE	A0,A1
	THETA_N	A2
	MOVE	A2,A0

	MOVE	@PUCK_OBJECT,A8,L
	CALLA	set_obj_to_polar

;	MOVE	*A7(POF_MODE),A14,W
;	CMPI	PM_GSKATE,A14
;	JREQ	GHS_G_PUCK_LOST			;BR=ON GROUND

	MOVI	-060000H,A0
	MOVI	-020000H,A1
	CALLA	RANGERND
	MOVE	A0,*A8(OYVEL),L

	MOVI	NORM_GRAVITY,A14
	MOVE	A14,*A8(OYACCEL),W

;GHS_G_PUCK_LOST
	PULLQ	A8

GHS_G_GO
	movk	1,a0
	callr	take_turbo
	calla	record_check_a6

	calla	player_grunt_sound
	calla	body_slam_sound

	MOVE	A7,A6
	MOVE	A9,A8

	CLR	A14
	MOVE	A14,*A8(ODT_VEL),L
	MOVE	A14,*A8(OXVEL),L
	MOVE	A14,*A8(OZVEL),L

	MOVK	PM_GCHECKED,A14
	MOVE	A14,*A6(POF_MODE),W
	CALLA	take_player_control
	CALLA	SET_GCHECKED_SCRIPT

	MOVE	A8,A0
	CALLA	PULLANIMFUNC

	JRUC	ghs9

**************************************************************************
*								         *
* get_hipped								 *
*								         *
**************************************************************************
get_hipped
	move	*a6(POF_HAS_CHECKED),a14,W
	inc	a14
	move	a14,*a6(POF_HAS_CHECKED),W
	move	*a7(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	ghs9
	btst	B_PF_HIGHER,a14
	jrnz	ghs9
	btst	B_PF_HIGHER_W,a14
	jrnz	ghs9
	move	*a7(POF_OBJECT),a14,L
	move	*a14(ODT_VEL),a14,L
	cmpi	[6,0],a14
	jrhi	get_hipped_flip
	callr	zero_a9_y
	calla	inc_hot_ifp_a7
	movk	1,a0
	callr	take_turbo
	callr	take_extra_check
	calla	record_check_a6
	calla	spx_check_hit_hip
	calla	take_player_control_a7
	movb	*a7(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	movb	*a6(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	calla	player_grunt_sound
	calla	body_slam_sound
	movk	PM_FALL,a0
	move	a0,*a7(POF_MODE),W
	callr	resolve_count_a6a7
	calla	set_player_script_a79
	movb	*a7(POF_NUMBER),a0
	move	@PUCK_CONTROL,a14,W
	cmp	a0,a14
	jrnz	ghh9
	movk	30,a0
	movb	a0,*a6(POF_IGNORE_PUCK)
	movb	a0,*a7(POF_IGNORE_PUCK)
	clr	a0
	move	a0,@PUCK_CONTROL,W
	jauc	new_puck_control
ghh9	rets

get_hipped_flip
	callr	zero_a9_y
	calla	inc_hot_ifp_a7
	movk	1,a0
	callr	take_turbo
	callr	take_extra_check
	calla	record_check_a6
	calla	spx_check_hit_hip
	calla	take_player_control_a7
	movb	*a7(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	movb	*a6(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	calla	player_grunt_sound
	calla	body_slam_sound
	movk	PM_FALL,a0
	move	a0,*a7(POF_MODE),W
	callr	resolve_count_a6a7
	movi	set_1flipped_script_a7,a0
	move	*a7(POF_OBJECT),a14,L
	move	*a14(ODT_VEL),a14,L
	cmpi	[8,0],a14
	jrls	sdfrr1
	movi	set_2flipped_script_a7,a0
sdfrr1	call	a0
	movb	*a7(POF_NUMBER),a0
	move	@PUCK_CONTROL,a14,W
	cmp	a0,a14
	jrnz	ghh9
	movk	30,a0
	movb	a0,*a6(POF_IGNORE_PUCK)
	movb	a0,*a7(POF_IGNORE_PUCK)
	move	@PUCK_OBJECT,a0,L
	move	*a0(OXVEL),a14,L
	sra	1,a14
	move	a14,*a0(OXVEL),L
	move	*a0(OZVEL),a14,L
	sra	1,a14
	move	a14,*a0(OZVEL),L
	move	*a0(ODT_VEL),a14,L
	sra	1,a14
	move	a14,*a0(ODT_VEL),L
	clr	a0
	move	a0,@PUCK_CONTROL,W
	jauc	new_puck_control

**************************************************************************
*								         *
* take_turbo								 *
*								         *
**************************************************************************
take_turbo	;takes table entry a0 of turbo (for checks)
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	ttth9			;this doesn't work on drones
	move	@UNLIM_TURBO,a14,W
	jrnz	ttth9
	movb	*a6(POF_NUMBER),a14
	move	@hot_player,a1,W
	cmp	a1,a14
	jrz	ttth9			;if player is hot, he doesn't lose turbo
	move	*a6(POF_S_CHEK),a14,L	;no pup check needed
	sll	5,a0
	add	a0,a14
	move	*a14,a14,L
	move	*a6(POF_TURBO_AMOUNT),a0,L
	sub	a14,a0
	jrnn	ttth1
	clr	a0
ttth1	move	a0,*a6(POF_TURBO_AMOUNT),L
ttth9	rets

**************************************************************************
*								         *
* take_extra_check  - takes extra turbo if we knock a down guy down	 *
*								         *
**************************************************************************
take_extra_check
	move	*a7(POF_MODE),a14,W
	cmpi	PM_FALL,a14
	jrz	tecy
	cmpi	PM_SHAKE,a14
	jrnz	tecn
tecy	movk	2,a0
	jruc	take_turbo
tecn	rets

**************************************************************************
*								         *
* THROW_A9 - THROW PLAYER IN A9 WITH GIVEN VELOCITY TABLE		 *
* 									 *
* PASS:									 *
* A1 = VELOCITY TABLE							 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************
THROW_A9
	mmtm	sp,a8
	movb	*a6(POF_DIRECTION),a2
	sll	5,a2
	SUBK	32,A1
	ADD	A1,A2
	JRUC	GVTA9_GO

zero_a8_y
	clr	a14
	move	a14,*a8(OYACCEL),W
	move	a14,*a8(OYVEL),L
	move	a14,*a8(OYVAL),L
	rets
zero_a9_y
	clr	a14
	move	a14,*a9(OYACCEL),W
	move	a14,*a9(OYVEL),L
	move	a14,*a9(OYVAL),L
	rets

give_velocity_to_a9
	mmtm	sp,a8
	movb	*a6(POF_DIRECTION),a2
	sll	5,a2
	addi	diropr-32,a2
GVTA9_GO
	move	*a2,a1,W
	sll	16,a1
	move	*a2(16),a0,W
	sll	16,a0
	move	*a8(ODT_REALXVEL),a14,L
	add	a14,a0
	move	*a8(OZVEL),a14,L
	add	a14,a1
	calla	rect_to_polar
	move	*a9(ODT_VEL),a14,L
	cmp	a14,a1
	jrhs	gvb1
	move	a14,a1
gvb1	move	a9,a8
	calla	set_obj_to_polar
	mmfm	sp,a8
	rets

give_velocity_to_a9_eb
	mmtm	sp,a8
	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	callr	find_dir_to_point_18
	sll	5,a0
	addi	diropr-32,a0
	move	a0,a2
	jruc	GVTA9_GO

a6_free_from_a7_slow
	movb	*a7(POF_NUMBER),a0
	move	@PUCK_CONTROL,a14,W
	cmp	a0,a14
	jrnz	a5tx
	move	*a7(POF_MODE),a0,W
	cmpi	PM_ONETIME,a0
	jrz	take_nt
	callr	no_tak
	move	@PUCK_OBJECT,a0,L
	move	*a0(OXVEL),a14,L
	sra	2,a14
	move	a14,*a0(OXVEL),L
	move	a14,*a0(ODT_REALXVEL),L
	move	*a0(OZVEL),a14,L
	sra	2,a14
	move	a14,*a0(OZVEL),L
	move	*a0(ODT_VEL),a14,L
	sra	2,a14
	move	a14,*a0(ODT_VEL),L
	rets


a6_take_from_a7_swat
	mmtm	sp,a11
	clr	a11
	callr	a6tf7
	mmfm	sp,a11
	rets
a6_take_from_a7
	mmtm	sp,a11
	movk	1,a11
	callr	a6tf7
	mmfm	sp,a11
	rets

a6tf7	movb	*a7(POF_NUMBER),a0
	move	@PUCK_CONTROL,a14,W
	cmp	a0,a14
	jrnz	a5tx
	move	*a7(POF_MODE),a0,W
	cmpi	PM_ONETIME,a0
	jrz	take_nt
	move	*a6(POF_PPMOD),a0,W
	jrnz	no_tak
	movb	*a6(POF_NUMBER),a0
	dec	a14
	dec	a0
	srl	2,a14
	srl	2,a0
	cmp	a0,a14
	jrz	yes_tak				;always take from our team

	move	*a6(POF_PUP_FLAGS),a14,W
	btst	B_PUP_PUCK,a14
	jrnz	yes_tak				;always take on pup puck

	movi	750,a0		;was 500
	calla	RANDPER
	jrc	yes_tak
no_tak	calla	record_puck_a6		;give us a touch, if we free it
	movk	30,a0
	movb	a0,*a6(POF_IGNORE_PUCK)
	movb	a0,*a7(POF_IGNORE_PUCK)

	move	*a9(ODT_DIR),a0,L
	move	a11,a11
	jrnz	nor_di
	move	*a8(ODT_DIR),a0,L
nor_di	MOVE	*A6(POF_FLAGS),A14,W
	BTST	B_PF_GOALIE,A14
	JRZ	A6TFA7_RAND_DIR			;BR=NOT GOALIE
	MOVB	*A6(POF_DIRECTION),A0		;USE GOALIE'S FACING DIRECION
	CALLA	dir_to_degrees			; SO PUCK DON'T SCORE
A6TFA7_RAND_DIR
	move	a0,a1
	subi	XD0200,a0
	addi	XD0200,a1
	calla	RANGERND
	move	a0,b0
	move	*a9(ODT_VEL),a0,L
	addi	[5,0],a0
	move	a0,a1
	sra	2,a1
	sub	a0,a1
	abs	a1
	move	a0,a14
	sra	1,a14
	add	a14,a0
	calla	RANGERND
	move	a0,a1
	move	b0,a0
	move	a8,b0
	move	@PUCK_OBJECT,a8,L
	calla	set_obj_to_polar
	move	b0,a8
	clr	a0
	jruc	wpc_x

yes_tak	movb	*a6(POF_NUMBER),a0

	MOVE	*A6(POF_FLAGS),A14,W
	BTST	B_PF_GOALIE,A14
	JRZ	wpc_x					;BR=NOT GOALIE

	addi	30,a14
	move	a14,*a7(POF_DRONE_NO_CHECK),L

	MOVE	@WAVEIRQS,A14,L
	MOVE	A14,*A8(ODT_GPOSSIRQ),L			;IRQ TIME OF POSSESSION
	MOVE	@PUCK_OBJECT,A14,L
	MOVE	*A14(OZVAL),*A8(ODT_GZPOSPOSS),L	;Z POSITION
wpc_x	move	a0,@PUCK_CONTROL,W
	jauc	new_puck_control
a5tx	rets
take_nt	clr	a0
	jruc	wpc_x

diropr	.word	-6,0
	.word	-4,4
	.word	0,6
	.word	4,4
	.word	6,0
	.word	4,-4
	.word	0,-6
	.word	-4,-4

is_hitback	;a6 = us, a7 = them
	mmtm	sp,a0,a1,a2
	movb	*a6(POF_DIRECTION),a0
	sll	4,a0
	addi	is_back_list-16,a0
	movk	5,a1
	movb	*a7(POF_DIRECTION),a2
ish1	move	*a0+,a14,W
	cmp	a14,a2
	jrz	ishy
	dsjs	a1,ish1
	clrc
	mmfm	sp,a0,a1,a2
	rets
ishy	setc
	mmfm	sp,a0,a1,a2
	rets

is_back_list
	.word	7,8,1,2,3,4,5,6,7,8,1,2

copy_attach_wall_angle
	move	*a7(POF_HIT_BOARDS_A),*a6(POF_HIT_BOARDS_A),W
	rets

copy_wall_angle
	move	*a6(POF_HIT_BOARDS_A),*a7(POF_HIT_BOARDS_A),W
	rets

script_logic
	move	*a8(ODT_PBK),a6,L
	callr	are_we_attached_to_player
	jrnc	awa_n
	callr	are_we_locked_on_wall
	jrnc	awlw_n
	callr	set_ua_to_fveladd
	callr	dec_attach_wall_time
	jrnc	sla_9
	callr	set_up_exit_scripts
	callr	deattach
	jruc	sl_9
awlw_n	callr	have_we_hit_ground
	jrnc	hwg_n
	callr	set_up_ground_scripts
	callr	deattach
	jruc	sl_9
hwg_n	callr	has_attached_hit_wall
	jrnc	hahw_n
	callr	copy_attach_wall_angle
	callr	set_attach_wall_time
	callr	set_ua_to_fveladd
	callr	set_up_wall_scripts
	callr	do_wall_collision_effect
	calla	spx_check_hit_boards
	jruc	sla_9
hahw_n	callr	have_we_hit_wall
	jrnc	hwhw_n
	callr	copy_wall_angle
	callr	set_attach_wall_time
	callr	set_ua_to_fveladd
	callr	set_up_wall_scripts
	callr	do_wall_collision_effect
	calla	spx_check_hit_glass_only
	jruc	sla_9
hwhw_n	jruc	sla_9
awa_n	callr	are_we_locked_on_wall
	jrnc	uwl_n
	callr	set_u_to_fveladd
	callr	dec_attach_wall_time
	jrnc	sl_9
	callr	set_up_exit_script
	jruc	sl_9
uwl_n	callr	have_we_hit_ground
	jrnc	uwg_n
	callr	set_up_ground_script
	jruc	sl_9
uwg_n	callr	have_we_hit_wall
	jrnc	uww_n
	callr	set_attach_wall_time
	callr	set_u_to_fveladd
	callr	set_up_wall_script
	callr	do_wall_collision_effect
	calla	spx_check_hit_glass_only
	jruc	sl_9
uww_n	callr	have_we_hit_player
	jrnc	hwhp_n
	callr	do_we_follow_through
	jrnc	dwft_n
	callr	a6_free_from_a7_slow
	calla	inc_hot_ifp_a7
	callr	set_collision_velocity_scripts
	callr	attach_to_player
	jruc	sl_9
dwft_n	callr	set_collision_bounce_vs
	jruc	sl_9
hwhp_n	jruc	sl_9

sla_9	jruc	keep_player_attached	;attached exit
sl_9	rets			;unattached exit

are_we_attached_to_player
	move	*a6(POF_CONTROLLED),a9,L
	jrz	awap_9n
	move	*a9(ANIMSCR),a0,L
	move	*a6(POF_CONTROLLED_SCRIPT),a14,L
	cmp	a0,a14
	jrnz	awap_9n
	move	*a9(ODT_PBK),a7,L
	move	*a7(POF_CONTROL_OBJECT),a14,L
	cmp	a14,a8
	jrnz	awap_9n
	move	*a7(POF_CONTROL_SCRIPT),a14,L
	move	*a8(ANIMSCR),a0,L
	cmp	a0,a14
	jrnz	awap_9n
awap_9y	setc
	rets
awap_9n	clrc
	rets

are_we_locked_on_wall
	move	*a6(POF_CWALL_TIME),a14,W
	jrnz	awl9y
	clrc
	rets
awl9y	setc
	rets

has_attached_hit_wall
	move	*a7(POF_HIT_BOARDS),a14,W
	jrnz	awhb9y
	clrc
	rets
awhb9y	setc
	rets

have_we_hit_ground
	move	*a8(OYVAL),a14,L
	jrnn	hwgg_y
	clrc
	rets
hwgg_y	setc
	rets

have_we_hit_wall
	move	*a6(POF_HIT_BOARDS),a14,W
	jrnz	awhw9y
	clrc
	rets
awhw9y	setc
	rets

dec_attach_wall_time
	move	*a6(POF_CWALL_TIME),a14,W
	jrz	dwt9y
	dec	a14
	move	a14,*a6(POF_CWALL_TIME),W
	jrz	dwt9y
	clrc
	rets
dwt9y	setc
	rets

attach_to_player
	movb	*a6(POF_DIRECTION),a14
	sll	5,a14
	addi	atp_ptl,a14
	move	*a14+,a0,W
	move	*a14,a14,W
	move	a0,*a6(POF_ATTACH_X),W
	move	a14,*a6(POF_ATTACH_Z),W
	clr	a14
	move	a14,*a6(POF_ATTACH_Y),W
	move	a14,*a7(POF_HIT_BOARDS),W
	move	a14,*a7(POF_ATTACH_ABORT),W
	move	a8,*a7(POF_CONTROL_OBJECT),L
	move	a9,*a6(POF_CONTROLLED),L
	move	*a8(ANIMSCR),*a7(POF_CONTROL_SCRIPT),L
	move	*a9(ANIMSCR),*a6(POF_CONTROLLED_SCRIPT),L
	calla	take_player_control_a7
	calla	resolve_count_a6a7_long
	calla	attach_to_player_show
	rets

atp_ptl	.word	0,0
	.word	0,-20
	.word	14,-14
	.word	20,0
	.word	14,14
	.word	0,20
	.word	-14,14
	.word	-20,0
	.word	-14,-14

deattach
	clr	a14
	move	a14,*a6(POF_CONTROL_OBJECT),L
	move	a14,*a6(POF_CONTROL_SCRIPT),L
	move	a14,*a6(POF_CONTROLLED),L
	move	a14,*a6(POF_CONTROLLED_SCRIPT),L
	move	a7,a7
	jrz	dea9
	move	a14,*a7(POF_CONTROL_OBJECT),L
	move	a14,*a7(POF_CONTROL_SCRIPT),L
	move	a14,*a7(POF_CONTROLLED),L
	move	a14,*a7(POF_CONTROLLED_SCRIPT),L
dea9	rets

keep_player_attached
	move	*a8(OXVAL),a1,L
	addi	[0,08000h],a1
	sra	16,a1
	move	*a6(POF_ATTACH_X),a14,W
	add	a14,a1
	move	a1,*a9(OXPOS),W
	move	*a8(OZPOS),a1,W
	move	*a6(POF_ATTACH_Z),a14,W
	add	a14,a1
	move	a1,*a9(OZPOS),W
	move	*a8(OYPOS),a1,W
	move	*a6(POF_ATTACH_Y),a14,W
	add	a14,a1
	move	a1,*a9(OYPOS),W
	move	*a8(OXVEL),*a9(OXVEL),L
	move	*a8(OZVEL),*a9(OZVEL),L
	move	*a8(OYVEL),*a9(OYVEL),L
	move	*a8(OYACCEL),*a9(OYACCEL),W
	rets

set_attach_wall_time
	move	*a6(POF_CWALL_TIME),a14,W
	jrnz	sawt_1
	movk	4,a14
	move	a14,*a6(POF_CWALL_TIME),W
sawt_1	rets

set_ua_to_fveladd
	move	*a9(OFLAGS),a14,W
	ori	M_FVELADD,a14
	move	a14,*a9(OFLAGS),W
set_u_to_fveladd
	move	*a8(OFLAGS),a14,W
	ori	M_FVELADD,a14
	move	a14,*a8(OFLAGS),W
	rets

set_up_wall_scripts
	mmtm	sp,a8
	move	a9,a8
	move	*a7(POF_ATTACH_F),a14,W
	jrz	suws1
	calla	set_body_chkd_back_wall_script
	jruc	suws2
suws1	calla	set_body_chkd_face_wall_script
suws2	mmfm	sp,a8
	callr	set_up_wall_script
	jruc	attach_to_player
set_up_wall_script
	jauc	set_body_check_wall_script

have_we_hit_player
	move	*a8(ANIMARG),a14,L
	move	*a14+,a3,L
	move	*a14+,a2,L
	movi	DUMRETS,a11
	jruc	collision_check

do_wall_collision_effect
	move	*a8(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
	move	*a8(OZPOS),a1,W
	sll	16,a1
	movy	a1,a0
	calla	animate_boards
	calla	body_fall_show
	rets

set_collision_bounce_vs
	rets
set_collision_velocity_scripts
	mmtm	sp,a0,a1,a8
	move	a9,a8
	movb	*a6(POF_DIRECTION),a0
	movb	*a7(POF_DIRECTION),a1
	sll	6,a0
	sll	3,a1
	add	a0,a1
	addi	fb_fl-64-8,a1
	movb	*a1,a1
	move	a1,*a7(POF_ATTACH_F),W
	jrz	scff
	calla	set_body_chkd_back_script
	mmfm	sp,a0,a1,a8
	rets
scff	calla	set_body_chkd_face_script
	mmfm	sp,a0,a1,a8
	rets

fb_fl	.byte	0,0,0,1,1,1,0,0
	.byte	0,0,0,0,1,1,1,0
	.byte	0,0,0,0,0,1,1,1
	.byte	1,0,0,0,0,0,1,1
	.byte	1,1,0,0,0,0,0,1
	.byte	1,1,1,0,0,0,0,0
	.byte	0,1,1,1,0,0,0,0
	.byte	0,0,1,1,1,0,0,0

set_up_exit_scripts
	mmtm	sp,a8
	move	a9,a8
	move	*a7(POF_ATTACH_F),a14,W
	jrz	suxs1
	calla	set_body_chkd_back_down_script
	jruc	suxs2
suxs1	calla	set_body_chkd_face_down_script
suxs2	mmfm	sp,a8
	;
set_up_exit_script
	jauc	set_body_check_down_script


set_up_ground_scripts
	mmtm	sp,a8
	move	a9,a8
	callr	set_up_ground_script
	mmfm	sp,a8
	;
set_up_ground_script
	callr	zero_a8_y
	jauc	a_control_script_done

do_we_follow_through
	move	*a7(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrz	dwfty
	clrc
	rets
dwfty	setc
	rets

a_go_down_c
	move	*a8(ODT_PBK),a6,L
	move	*a8(ODT_SAVEVEL),a1,L
	movi	[2,08000h],a1
	jruc	agd_q1
a_go_down
	move	*a8(ODT_PBK),a6,L
	move	*a8(ODT_SAVEVEL),a1,L
agd_q1	move	a1,a14
	sra	1,a1
	sra	3,a14
	add	a14,a1
	move	*a6(POF_HIT_BOARDS_A),a0,W
	jrn	agd1
	sll	16,a0
	move	a0,*a8(POF_ATTACH_VDIR),L
	move	a1,*a8(POF_ATTACH_VVEL),L
	calla	set_obj_to_polar
agd1	movi	[0,08100h],a0
	move	a0,*a8(OYACCEL),W
	rets

a_watch_ground_loop
	move	*a8(ODT_PBK),a6,L
	move	*a8(OYVAL),a0,L
	jrn	awgl1
	callr	zero_a8_y
	move	*a6(POF_ATTACH_ABORT),a14,W
	jrnz	awgl1
	movk	1,a14
	move	a14,*a6(POF_ATTACH_ABORT),W
awgl1	move	*a8(ANIMARG),a0,L
	move	*a0+,a1,L
	move	*a0+,a2,L
	move	*a8(ANIMSCR),a14,L
	cmp	a1,a14
	jrnz	awgl9
	move	a2,*a8(ANIMFRM),L
	move	*a6(POF_ATTACH_ABORT),a14,W
	inc	a14
	move	a14,*a6(POF_ATTACH_ABORT),W
	cmpi	5,a14
	jrls	awgl9
	jauc	give_player_control
awgl9	rets

a_until_ground_c
	callr	a_until_ground
	move	*a8(OYACCEL),a14,W
	jrnz	augc9
	move	*a8(ODT_DIR),a0,L
	clr	a1
	jauc	set_obj_to_polar
augc9	rets

a_until_ground
	move	*a8(POF_ATTACH_VDIR),a0,L
	move	*a8(POF_ATTACH_VVEL),a1,L
	calla	set_obj_to_polar
	move	*a8(ANIMARG),a0,L
	move	*a0+,a1,L
	move	*a0+,a2,L
	move	*a8(ANIMSCR),a14,L
	cmp	a1,a14
	jrnz	aug_9
	callr	have_we_hit_ground
	jrc	aug_g
	move	a2,*a8(ANIMFRM),L
aug_9	rets
aug_g	callr	zero_a8_y
	move	*a8(ODT_PBK),a6,L
	clr	a7
	jruc	deattach

a_wall_branch
	move	*a8(ANIMARG),a0,L
	move	*a0+,a1,L
	move	*a0+,a2,L
	move	*a8(ANIMSCR),a14,L
	move	a0,*a8(ANIMARG),L
	cmp	a1,a14
	jrnz	awb_9
	move	a2,*a8(ANIMFRM),L
	callr	script_logic
awb_9	rets

a_ch_vels
	move	*a8(ODT_VEL),*a8(ODT_SAVEVEL),L
	move	*a8(ODT_DIR),*a8(ODT_SAVEDIR),L
	movi	-[4,00000h],a0
	move	a0,*a8(OYVEL),L
	movi	[0,08100h],a0
	move	a0,*a8(OYACCEL),W
	move	*a8(ODT_VEL),a14,L
	move	a14,a0
	sra	2,a0
	add	a0,a14
	sra	1,a0
	add	a0,a14
	move	a14,*a8(ODT_VEL),L
	move	*a8(ODT_REALXVEL),a14,L
	move	a14,a0
	sra	2,a0
	add	a0,a14
	sra	1,a0
	add	a0,a14
	move	a14,*a8(OXVEL),L
	move	a14,*a8(ODT_REALXVEL),L
	move	*a8(OZVEL),a14,L
	move	a14,a0
	sra	2,a0
	add	a0,a14
	sra	1,a0
	add	a0,a14
	move	a14,*a8(OZVEL),L
	rets
