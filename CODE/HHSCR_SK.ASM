 	.MLIB	"HHMACS.LIB"
	.FILE	"HHGSCR2.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhscr_sk.tbl"
	.include	"hhscrmsk.tbl"
	.include	"hhscr_sk.e"
	.include	"hhscr_fn.g"
	.include	"hhscr_cb.g"
	.include	"hhshow.g"
	.include	"hhcontrl.g"
	.include	"hhmath.g"
	.include	"hhram.g"
	.include	"hhscr_ms.g"
;	.include	"hhpuck.g"
	.ref	PUCK_CONTROL
	.include	"hhutil.g"

; end of include files

	.TEXT
	.EVEN

set_dump_script
set_run_script
	calla	give_player_control
	movb	*a6(POF_DIRECTION),a0
	cmpi	1,a0			;just until we get other dirs
	jrz	nctc
	cmpi	5,a0
	jrz	nctc
cctc	callr	are_we_backwards
	jac	set_reverse_run_script
nctc	move	*a6(POF_FLAGS),a0,W
	btst	B_PF_HIGHER,a0
	jrnz	srss1
	btst	B_PF_HIGHER_W,a0
	jrnz	srss1
	callr	do_we_quick_step_glide
	jrz	srss1a
	jrc	set_quick_step_script
	jruc	set_glide_script
srss1a	callr	do_we_deke_split
	jrz	srss1
	jrc	set_deke_shoulder_script
	jruc	set_split_legs_script
srss1	callr	do_we_switch_180
	jac	set_backwards_to_forwards_script

	callr	get_desired_lean
	move	@WAVEIRQS,a3,L
	move	*a8(ODT_DVEL),a14,L
	move	a0,a0
	jrnz	gdl_nz
	move	a14,a14
	jrz	gdl_st0			;track to 0 lean slow
	jruc	gdl_mog			;match to our old goal
gdl_nz	move	a0,a1
	sra	31,a14
	sra	31,a1
	cmp	a1,a14
	jrnz	gdl_ft			;track to desired lean fast
	jruc	gdl_mgl			;match lean desired or old goal (if sign matches)
gdl_mgl	move	*a6(POF_LEAN_GOAL),a14,W
	jrz	gdl_ft			;old goal straight, go to desired lean now
	sra	31,a14
	cmp	a1,a14
	jrz	gdl_mog
gdl_ft	callr	set_deke_lean
	move	a0,*a6(POF_LEAN),W
	move	a0,*a6(POF_LEAN_GOAL),W
	move	a3,*a6(POF_LEAN_TIME),L
	jruc	gdl_9
gdl_st0	move	a0,*a6(POF_LEAN_GOAL),W
	move	*a6(POF_LEAN_TIME),a1,L
	move	a3,a2
	sub	a1,a2
	cmpi	3,a2
	jrlt	glab
	move	*a6(POF_LEAN),a0,W
	move	a0,a14
	abs	a0
	sra	1,a0
	move	a14,a14
	jrz	gdlnn
	neg	a0
gdlnn	callr	set_deke_lean
	move	a0,*a6(POF_LEAN),W
	move	a3,*a6(POF_LEAN_TIME),L
	jruc	gdl_9
gdl_mog	move	*a8(ODT_DVEL),a14,L
	abs	a14
	cmpi	XD0010,a14
	jrlt	gdlnn
	move	*a6(POF_LEAN_GOAL),a0,W
	callr	set_deke_lean
	move	a0,*a6(POF_LEAN),W	;probably redundant
	jruc	gdl_9
glab 	move	*a6(POF_LEAN),a0,W
gdl_9	move	a0,a0
	jrz	gdl9i			;we are not leaning
	clr	a14			;we are leaning
	dec	a14
	movb	a14,*a6(POF_SKATE_RATE_D)	;clear our skate rate
	sll	5,a0
	addi	srrstt,a0
	move	*a0,a0,L
	clr	a14
	dec	a14
	move	a14,*a6(POF_QS_OK),W	;no more quick steps
	move	*a6(POF_PPMOD),a14,W
	sll	5,a14
	add	a0,a14
	move	*a14,a14,L
	subk	32,a14
	jauc	start_lean_panim_if_not_ta14

gdl9i	movb	*a6(POF_SKATE_RATE_G),a0	;get our goal skate rate
	movb	*a6(POF_DIRECTION),a1
	movb	*a6(POF_SKATE_RATE_D),a14
	cmp	a1,a14
	jrnz	gdl_aok			;our goal rate is ok
	move	*a6(POF_SKATE_RATE_T),a0,W	;our old skate rate is what we use
gdl_aok	sll	5,a0
	addi	ssrtab,a0
	move	*a0,a0,L
	clr	a14
	dec	a14
	move	a14,*a6(POF_QS_OK),W	;no more quick steps
	move	*a6(POF_PPMOD),a14,W
	sll	5,a14
	add	a0,a14
	move	*a14,a14,L
	subk	32,a14
	jauc	start_lean_panim_if_not_ta14

set_deke_lean_noa3
	mmtm	sp,a0,a1,a3,a4
	move	@WAVEIRQS,a3,L
	jruc	sdl1a
set_deke_lean	;a3 = waveirqs, a0 = new lean (check old lean)
	mmtm	sp,a0,a1,a3,a4
sdl1a	move	*a6(POF_LEAN),a4,W
	cmp	a0,a4
	jrz	sdl9
	move	*a6(POF_DEKE_TIME),a14,L
	move	a3,a1
	sub	a14,a1
	cmpi	60,a1
	jrlt	sdl1
	clr	a1
	move	a1,*a6(POF_DEKE_COUNT),W
sdl1	move	a3,*a6(POF_DEKE_TIME),L
	move	a0,a0
	jrz	sdl9
	move	a0,a1
	srl	31,a1
	srl	31,a4
	cmp	a1,a4		;sign of leans
	jrz	sdl9
	move	*a6(POF_DEKE_COUNT),a14,W
	inc	a14
	move	a14,*a6(POF_DEKE_COUNT),W
sdl9	mmfm	sp,a0,a1,a3,a4
	rets

	.long	srrr2_tab
	.long	srrr1_tab
srrstt	.long	srsttab			;lean -2 - +2
	.long	srrl1_tab
	.long	srrl2_tab

ssrtab	.long	srsttab			;skate rate 0 (normal)
	.long	srs1_tab		;skate rate 1 (turbo, 1 hand)

get_desired_lean
	clr	a0
	move	*a8(ODT_VEL),a2,L
	cmpi	[8,04000h],a2		;8.6
	jrls	sdl_9			;to slow, straight up
	move	*a8(ODT_DVEL),a14,L
	move	a14,a1
	abs	a14
	cmpi	XD0020,a14		;straight line, straight up
	jrlt	sdl_9
	movk	1,a0
	move	a1,a1
	jrnn	sdl_21
	neg	a0
sdl_21	cmpi	[8,0a000h],a2
	jrls	sdl_9
	sll	1,a0
sdl_9	rets

**************************************************************************
*								         *
* do_we_switch_180							 *
* 	input	a6,a8							 *
* 	output	c = we are switching 180				 *
* 		nc= we are not						 *
*								         *
**************************************************************************
do_we_switch_180
	movb	*a6(POF_DIRECTION),a14
	cmpi	1,a14
	jrz	dw18_n
	cmpi	5,a14
	jrz	dw18_n
dw18_o	movb	*a6(POF_LAST_DIRECTION),a1
	addk	4,a1
	cmpi	8,a1
	jrls	dw181
	subk	8,a1
dw181	cmp	a1,a14
	jrnz	dw18_n
	setc
	rets
dw18_n	clrc
	rets

**************************************************************************
*								         *
* are_we_backwards							 *
* 	input	a6,a8							 *
* 		a0 = POF_DIRECTION					 *
* 	output	c  = backwards						 *
* 		nc = not backwards					 *
*								         *
**************************************************************************
are_we_backwards
	calla	dir_to_degrees
	move	*a8(ODT_DIR),a1,L
	sub	a1,a0
	THETA_H	a0
	abs	a0
	cmpi	XD0900,a0
	jrhi	awb_y
	clrc
	rets
awb_y	setc
	rets

**************************************************************************
*								         *
* do_we_deke_split							 *
* 	input	a6,a8							 *
* 	output	z = normal						 *
* 		nz							 *
* 		 c = deke						 *
* 		 nc= split						 *
*								         *
**************************************************************************
do_we_deke_split	;careful regs if change
	movb	*a6(POF_NUMBER),a3
	move	@PUCK_CONTROL,a14,W
	cmp	a3,a14
	jrnz	dwds9n
	move	*a8(OXVAL),a0,L
	move	*a8(OXVEL),a14,L
	dec	a3
	sra	2,a3
	jrz	ddg1
	neg	a0
	neg	a14
ddg1	move	a14,a14
	jrn	dwdsnx		;not toward goal
	jrz	dwdsnx		;not toward goal
	cmpi	[233,0],a0
	jrlt	dwds9n		;not over blue line
	move	*a6(POF_DSP_TYPE),a1,W
	cmpi	2,a1
	jrz	dwds9n
	move	*a6(POF_DSP_TIME),a0,L
	jrz	dwd_yes
	move	@WAVEIRQS,a14,L
	sub	a0,a14
	cmpi	180,a14
	jrhs	dwdsnx
dwd_yes	move	a1,a1
	jrp	ddydk
	jrn	ddysp
	move	@WAVEIRQS,a14,L
	move	a14,*a6(POF_DSP_TIME),L
	movk	2,a0
	calla	RAND0
	sll	1,a0
	dec	a0	;+,-1
	move	a0,*a6(POF_DSP_TYPE),W
	jrp	ddydk
ddysp	clrc
	movk	1,a0
	rets
ddydk	setc
	movk	1,a0
	rets
dwdsnx	movk	2,a0
	move	a0,*a6(POF_DSP_TYPE),W
dwds9n	clr	a0
	rets


**************************************************************************
*								         *
* do_we_quick_step_glide						 *
* 	input	a6							 *
* 	output	z   =, normal						 *
* 		nz							 *
* 		 c  =, quick step					 *
* 		 nc =, glide						 *
*								         *
**************************************************************************
do_we_quick_step_glide
	move	*a6(POF_PPMOD),a14,W
	jrnz	dwe_n
	calla	are_we_intended
	jrnc	dwsdws
	movb	*a6(POF_DIRECTION),a14
	cmpi	1,a14
	jrz	dwsdws
	cmpi	5,a14
	jrnz	dwe_gl
dwsdws	move	*a6(POF_SPEED_GL),a14,L
	move	*a8(ODT_VEL),a0,L
	sub	a14,a0
	jrnn	srss2			;we are not increasing
	move	*a6(POF_QS_OK),a14,W
	jrn	dwe_n
	jrz	dwe_qs
	movb	*a6(POF_DIRECTION),a0
	cmp	a0,a14
	jrz	dwe_qs
	jruc	dwe_n
srss2	movb	*a6(POF_DIRECTION),a14
	cmpi	1,a14
	jrz	dwe_n
	cmpi	5,a14
	jrz	dwe_n
	cmpi	[1,08000h],a0
	jrgt	dwe_gl
dwe_n	clr	a14		;set z
	rets
dwe_qs	movk	1,a14
	move 	a14,a14
	setc
	rets
dwe_gl	movk	1,a14
	move 	a14,a14
	clrc
	rets

srrr2_tab
	.long	r2srs_tab
	.long	r2tight_skate_right_tab
	.long	r2tight_skate_left_tab
	.long	tight_skate_right_left_tab

srrr1_tab
	.long	r1srs_tab
	.long	r1tight_skate_right_tab
	.long	r1tight_skate_left_tab
	.long	tight_skate_right_left_tab

srsttab	.long	srs_tab
	.long	tight_skate_right_tab
	.long	tight_skate_left_tab
	.long	tight_skate_right_left_tab

srrl1_tab
	.long	l1srs_tab
	.long	l1tight_skate_right_tab
	.long	l1tight_skate_left_tab
	.long	tight_skate_right_left_tab

srrl2_tab
	.long	l2srs_tab
	.long	l2tight_skate_right_tab
	.long	l2tight_skate_left_tab
	.long	tight_skate_right_left_tab

srs1tab	.long	srs1_tab				;skate rate 1
	.long	tight_skate_right_tab
	.long	tight_skate_left_tab
	.long	tight_skate_right_left_tab

set_regular_run_script
	movi	srs_tab-32,a14
	jauc	start_panim_if_not_ta14

r2srs_tab
	.long	anim_r2run_1
	.long	anim_r2run_2
	.long	anim_r2run_3
	.long	anim_r2run_4
	.long	anim_r2run_5
	.long	anim_r2run_6
	.long	anim_r2run_7
	.long	anim_r2run_8
r1srs_tab
	.long	anim_r1run_1
	.long	anim_r1run_2
	.long	anim_r1run_3
	.long	anim_r1run_4
	.long	anim_r1run_5
	.long	anim_r1run_6
	.long	anim_r1run_7
	.long	anim_r1run_8
srs_tab
	.long	anim_run_1
	.long	anim_run_2
	.long	anim_run_3
	.long	anim_run_4
	.long	anim_run_5
	.long	anim_run_6
	.long	anim_run_7
	.long	anim_run_8
l1srs_tab
	.long	anim_l1run_1
	.long	anim_l1run_2
	.long	anim_l1run_3
	.long	anim_l1run_4
	.long	anim_l1run_5
	.long	anim_l1run_6
	.long	anim_l1run_7
	.long	anim_l1run_8
l2srs_tab
	.long	anim_l2run_1
	.long	anim_l2run_2
	.long	anim_l2run_3
	.long	anim_l2run_4
	.long	anim_l2run_5
	.long	anim_l2run_6
	.long	anim_l2run_7
	.long	anim_l2run_8

r2tight_skate_right_tab
	.long	anim_r2run_1
	.long	anim_tight_2
	.long	anim_tight_3
	.long	anim_tight_4
	.long	anim_r2run_5
	.long	anim_r2run_6
	.long	anim_r2run_7
	.long	anim_r2run_8
r1tight_skate_right_tab
	.long	anim_r1run_1
	.long	anim_tight_2
	.long	anim_tight_3
	.long	anim_tight_4
	.long	anim_r1run_5
	.long	anim_r1run_6
	.long	anim_r1run_7
	.long	anim_r1run_8
tight_skate_right_tab
	.long	anim_run_1
	.long	anim_tight_2
	.long	anim_tight_3
	.long	anim_tight_4
	.long	anim_run_5
	.long	anim_run_6
	.long	anim_run_7
	.long	anim_run_8
l1tight_skate_right_tab
	.long	anim_l1run_1
	.long	anim_tight_2
	.long	anim_tight_3
	.long	anim_tight_4
	.long	anim_l1run_5
	.long	anim_l1run_6
	.long	anim_l1run_7
	.long	anim_l1run_8
l2tight_skate_right_tab
	.long	anim_l1run_1
	.long	anim_tight_2
	.long	anim_tight_3
	.long	anim_tight_4
	.long	anim_l1run_5
	.long	anim_l2run_6
	.long	anim_l2run_7
	.long	anim_l2run_8

r2tight_skate_left_tab
	.long	anim_r2run_1
	.long	anim_r2run_2
	.long	anim_r2run_3
	.long	anim_r2run_4
	.long	anim_r2run_5
	.long	anim_tight_6
	.long	anim_tight_7
	.long	anim_tight_8
r1tight_skate_left_tab
	.long	anim_r1run_1
	.long	anim_r1run_2
	.long	anim_r1run_3
	.long	anim_r1run_4
	.long	anim_r1run_5
	.long	anim_tight_6
	.long	anim_tight_7
	.long	anim_tight_8
tight_skate_left_tab
	.long	anim_run_1
	.long	anim_run_2
	.long	anim_run_3
	.long	anim_run_4
	.long	anim_run_5
	.long	anim_tight_6
	.long	anim_tight_7
	.long	anim_tight_8
l1tight_skate_left_tab
	.long	anim_l1run_1
	.long	anim_l1run_2
	.long	anim_l1run_3
	.long	anim_l1run_4
	.long	anim_l1run_5
	.long	anim_tight_6
	.long	anim_tight_7
	.long	anim_tight_8
l2tight_skate_left_tab
	.long	anim_l2run_1
	.long	anim_l2run_2
	.long	anim_l2run_3
	.long	anim_l2run_4
	.long	anim_l2run_5
	.long	anim_tight_6
	.long	anim_tight_7
	.long	anim_tight_8

tight_skate_right_left_tab
	.long	anim_run_1
	.long	anim_tight_2
	.long	anim_tight_3
	.long	anim_tight_4
	.long	anim_run_5
	.long	anim_tight_6
	.long	anim_tight_7
	.long	anim_tight_8


set_glide_script
	calla	clear_srt		;clear skate rate
	callr	do_we_switch_180
	jac	set_backwards_to_forwards_script
	move	*a6(POF_PPMOD),a14,W
	sll	5,a14
	movb	*a6(POF_NUMBER),a0
	dec	a0
	srl	2,a0
	jrz	sgs_team1
sgs_team2
	move	*a8(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
;	move	*a8(OXPOS),a0,W		;half
	cmpi	-300,a0
	jrlt	sgsf
	jruc	sgss
sgs_team1
	move	*a8(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
;	move	*a8(OXPOS),a0,W		;half
	cmpi	300,a0
	jrgt	sgsf
sgss	addi	scsttab,a14
	jruc	sgstt
sgsf	addi	fscsttb,a14
sgstt	move	*a14,a14,L
	subk	32,a14
	jauc	start_panim_if_not_ta14

scsttab	.long	scs_tab
	.long	tight_glide_right_tab
	.long	tight_glide_left_tab
	.long	tight_glide_right_left_tab

scs_tab
	.long	anim_glide_1
	.long	anim_glide_2
	.long	anim_glide_3
	.long	anim_glide_4
	.long	anim_glide_5
	.long	anim_glide_6
	.long	anim_glide_7
	.long	anim_glide_8

tight_glide_right_tab
	.long	anim_run_1
	.long	anim_tight_2
	.long	anim_tight_3
	.long	anim_tight_4
	.long	anim_run_5
	.long	anim_glide_6
	.long	anim_glide_7
	.long	anim_glide_8
tight_glide_left_tab
	.long	anim_run_1
	.long	anim_glide_2
	.long	anim_glide_3
	.long	anim_glide_4
	.long	anim_run_5
	.long	anim_tight_6
	.long	anim_tight_7
	.long	anim_tight_8
tight_glide_right_left_tab
	.long	anim_run_1
	.long	anim_tight_2
	.long	anim_tight_3
	.long	anim_tight_4
	.long	anim_run_5
	.long	anim_tight_6
	.long	anim_tight_7
	.long	anim_tight_8


fscsttb	.long	fscs_tab
	.long	ftight_glide_right_tab
	.long	ftight_glide_left_tab
	.long	ftight_glide_right_left_tab

fscs_tab
	.long	anim_fglide_1
	.long	anim_fglide_2
	.long	anim_fglide_3
	.long	anim_fglide_4
	.long	anim_fglide_5
	.long	anim_fglide_6
	.long	anim_fglide_7
	.long	anim_fglide_8

ftight_glide_right_tab
	.long	anim_run_1
	.long	anim_tight_2
	.long	anim_tight_3
	.long	anim_tight_4
	.long	anim_run_5
	.long	anim_fglide_6
	.long	anim_fglide_7
	.long	anim_fglide_8
ftight_glide_left_tab
	.long	anim_run_1
	.long	anim_fglide_2
	.long	anim_fglide_3
	.long	anim_fglide_4
	.long	anim_run_5
	.long	anim_tight_6
	.long	anim_tight_7
	.long	anim_tight_8
ftight_glide_right_left_tab
	.long	anim_run_1
	.long	anim_tight_2
	.long	anim_tight_3
	.long	anim_tight_4
	.long	anim_run_5
	.long	anim_tight_6
	.long	anim_tight_7
	.long	anim_tight_8

set_skid_script
	movb	*a6(POF_DIRECTION),a0
	calla	are_we_backwards
	jrc	set_reverse_skid_script
	move	*a8(ODT_DIR),a0,L
	calla	dir_to_18
	movb	a0,*a6(POF_DIRECTION)		;go into skid script based on movement, not face
	movi	ssks_tab-32,a14
	jauc	start_panim_if_not_ta14

ssks_tab
	.long	anim_skid_1
	.long	anim_skid_2
	.long	anim_skid_3
	.long	anim_skid_4
	.long	anim_skid_5
	.long	anim_skid_6
	.long	anim_skid_7
	.long	anim_skid_8

set_reverse_skid_script
	movi	srsk_tab-32,a14
	jauc	start_panim_if_not_ta14

srsk_tab
	.long	anim_skid_5
	.long	anim_skid_6
	.long	anim_rskid_3
	.long	anim_skid_8
	.long	anim_skid_1
	.long	anim_skid_2
	.long	anim_rskid_7
	.long	anim_skid_4

set_quick_step_script
	calla	clear_srt		;clear skate rate
	movi	sqss_tab-32,a14
	jauc	start_panim_if_not_ta14

sqss_tab
	.long	anim_quick_step_1
	.long	anim_quick_step_2
	.long	anim_quick_step_3
	.long	anim_quick_step_4
	.long	anim_quick_step_5
	.long	anim_quick_step_6
	.long	anim_quick_step_7
	.long	anim_quick_step_8

set_reverse_run_script
	calla	clear_srt		;clear skate rate
	calla	do_we_quick_step_glide
	jrz	srrs1
	jrc	set_reverse_quick_step_script
	jruc	set_reverse_glide_script
srrs1	calla	do_we_switch_180
	jrc	set_forwards_to_backwards_script
	movi	srrs_tab-32,a14
	jauc	start_panim_if_not_ta14

srrs_tab
	.long	anim_backward_skate_2
	.long	anim_backward_skate_2
	.long	anim_backward_skate_3
	.long	anim_backward_skate_4
	.long	anim_backward_skate_6
	.long	anim_backward_skate_6
	.long	anim_backward_skate_7
	.long	anim_backward_skate_8

set_reverse_quick_step_script
	movi	srqs_tab-32,a14
	jauc	start_panim_if_not_ta14

srqs_tab
	.long	anim_backward_qs_2
	.long	anim_backward_qs_2
	.long	anim_backward_qs_3
	.long	anim_backward_qs_4
	.long	anim_backward_qs_6
	.long	anim_backward_qs_6
	.long	anim_backward_qs_7
	.long	anim_backward_qs_8

set_reverse_glide_script
	calla	do_we_switch_180
	jrc	set_forwards_to_backwards_script
	movi	srgs_tab-32,a14
	jauc	start_panim_if_not_ta14

srgs_tab
	.long	anim_backward_gl_2
	.long	anim_backward_gl_2
	.long	anim_backward_gl_3
	.long	anim_backward_gl_4
	.long	anim_backward_gl_6
	.long	anim_backward_gl_6
	.long	anim_backward_gl_7
	.long	anim_backward_gl_8


set_forwards_to_backwards_script
	movb	*a6(POF_LAST_DIRECTION),*a6(POF_DIRECTION)
	movi	sftr_tab-32,a14
	jauc	start_panim_if_not_ta14

sftr_tab
	.long	anim_for_t_rev_script_2
	.long	anim_for_t_rev_script_2
	.long	anim_for_t_rev_script_3
	.long	anim_for_t_rev_script_4
	.long	anim_for_t_rev_script_6
	.long	anim_for_t_rev_script_6
	.long	anim_for_t_rev_script_7
	.long	anim_for_t_rev_script_8

set_backwards_to_forwards_script
	calla	clear_srt		;clear skate rate
	movb	*a6(POF_LAST_DIRECTION),*a6(POF_DIRECTION)
	movi	srtf_tab-32,a14
	jauc	start_panim_if_not_ta14

srtf_tab
	.long	anim_rev_t_for_script_2
	.long	anim_rev_t_for_script_2
	.long	anim_rev_t_for_script_3
	.long	anim_rev_t_for_script_4
	.long	anim_rev_t_for_script_6
	.long	anim_rev_t_for_script_6
	.long	anim_rev_t_for_script_7
	.long	anim_rev_t_for_script_8

set_split_legs_script
	movi	ssplw_tab-32,a14
	jauc	start_panim_if_not_ta14
ssplw_tab
	.long	anim_split_legs_wide_1
	.long	anim_split_legs_wide_2
	.long	anim_split_legs_wide_3
	.long	anim_split_legs_wide_4
	.long	anim_split_legs_wide_5
	.long	anim_split_legs_wide_6
	.long	anim_split_legs_wide_7
	.long	anim_split_legs_wide_8

set_deke_shoulder_script
	movi	sdsscr_tab-32,a14
	jauc	start_panim_if_not_ta14
sdsscr_tab
	.long	anim_deke_shoulder_1
	.long	anim_deke_shoulder_2
	.long	anim_deke_shoulder_3
	.long	anim_deke_shoulder_4
	.long	anim_deke_shoulder_5
	.long	anim_deke_shoulder_6
	.long	anim_deke_shoulder_7
	.long	anim_deke_shoulder_8

set_spinarama_right_script
	movi	ssprar_tab-32,a14
	jauc	start_panim_if_not_ta14
ssprar_tab
	.long	anim_spinarama_right_1
	.long	anim_spinarama_right_2
	.long	anim_spinarama_right_3
	.long	anim_spinarama_right_4
	.long	anim_spinarama_right_5
	.long	anim_spinarama_right_6
	.long	anim_spinarama_right_7
	.long	anim_spinarama_right_8

set_spinarama_left_script
	movi	sspral_tab-32,a14
	jauc	start_panim_if_not_ta14
sspral_tab
	.long	anim_spinarama_left_1
	.long	anim_spinarama_left_2
	.long	anim_spinarama_left_3
	.long	anim_spinarama_left_4
	.long	anim_spinarama_left_5
	.long	anim_spinarama_left_6
	.long	anim_spinarama_left_7
	.long	anim_spinarama_left_8

anim_skid_1
	LWL	1,AFUNC|1,a_skid_pick_s+8
	.long	 skid1_1801,skid1_1802,skid1_cw,skid1_ccw
skid1_1801
skid1_ccw
s11	LWWLWL	AC21F01,AFLIP|AFUNC|1,0,a_bfaceiloop+3,3,s11
s12	LWLL	AC21F02,AFUNC|2,a_intend_loop+2,s12
s13	LWLL	AC21F03,AFUNC|1,a_intend_loop+2,s13
s14	LWLL	AC21F04,AFUNC|1,a_intend_loop+2,s14
s15	LWLL	AC21F05,AFUNC|1,a_intend_loop+2,s15
ask11	LWLLL	1,AFUNC|1,a_speed_branchil+4,14000h,ask11
	LW	AC21F06,127
	.long	0
skid1_1802
skid1_cw
s16	LWWLWL	AC21F01,AFLIP|AFUNC|1,M_FLIPH,a_bfaceiloop+3,7,s16	;can change to flipped 3
s17	LWLL	AC21F02,AFUNC|2,a_intend_loop+2,s17
s18	LWLL	AC21F03,AFUNC|1,a_intend_loop+2,s18
s19	LWLL	AC21F04,AFUNC|1,a_intend_loop+2,s19
s20	LWLL	AC21F05,AFUNC|1,a_intend_loop+2,s20
ask12	LWLLL	1,AFUNC|1,a_speed_branchil+4,14000h,ask12
	LW	AC21F06,127
	.long	0

anim_skid_2
	LWL	1,AFUNC|1,a_skid_pick_s+8
	.long	 skid2_1801,skid2_1802,skid2_cw,skid2_ccw
skid2_1801
skid2_1802
skid2_cw
skid2_ccw
s21	LWWLWL	AC12F02,AFLIP|AFUNC|1,0,a_bfaceiloop+3,4,s21
s22	LWLL	AC12F03,AFUNC|2,a_intend_loop+2,s22
s23	LWLL	AC12F04,AFUNC|1,a_intend_loop+2,s23
s24	LWLL	AC12F05,AFUNC|1,a_intend_loop+2,s24
ask21	LWLLL	1,AFUNC|1,a_speed_branchil+4,18000h,ask21
s25	LWLL	AC12F06,AFUNC|1,a_intend_loop+2,s25
ask22	LWLLL	1,AFUNC|1,a_speed_branchil+4,0e000h,ask22
	LW	AC12F07,127
	.long	0

anim_skid_3
	LWL	1,AFUNC|1,a_skid_pick_s+8
	.long	 skid3_1801,skid3_1802,skid3_cw,skid3_ccw
skid3_1801
skid3_1802
skid3_cw
s26	LWWLWL	AC33F01,AFLIP|AFUNC|1,0,a_bfaceiloop+3,1,s26
s27	LWLL	AC33F03,AFUNC|2,a_intend_loop+2,s27
s28	LWLL	AC33F04,AFUNC|1,a_intend_loop+2,s28
s29	LWLL	AC33F06,AFUNC|1,a_intend_loop+2,s29
ask31	LWLLL	1,AFUNC|1,a_speed_branchil+4,18000h,ask31
s30	LWLL	AC33F07,AFUNC|1,a_intend_loop+2,s30
ask32	LWLLL	1,AFUNC|1,a_speed_branchil+4,0e000h,ask32
	LW	AC33F08,127
	.long	0
skid3_ccw
s31	LWWLWL	AC43F02,AFLIP|AFUNC|1,0,a_bfaceiloop+3,5,s31
s32	LWLL	AC43F03,AFUNC|2,a_intend_loop+2,s32
s33	LWLL	AC43F05,AFUNC|1,a_intend_loop+2,s33
s34	LWLL	AC43F06,AFUNC|1,a_intend_loop+2,s34
ask33	LWLLL	1,AFUNC|1,a_speed_branchil+4,18000h,ask33
s35	LWLL	AC43F07,AFUNC|1,a_intend_loop+2,s35
ask34	LWLLL	1,AFUNC|1,a_speed_branchil+4,0e000h,ask34
	LW	AC43F08,127
	.long	0

anim_skid_4
	LWL	1,AFUNC|1,a_skid_pick_s+8
	.long	 skid4_1801,skid4_1802,skid4_cw,skid4_ccw
skid4_1801
skid4_cw
s36	LWWLWL	AC14F01,AFLIP|AFUNC|1,0,a_bfaceiloop+3,2,s36
s37	LWLL	AC14F02,AFUNC|2,a_intend_loop+2,s37
s38	LWLL	AC14F03,AFUNC|1,a_intend_loop+2,s38
s39	LWLL	AC14F04,AFUNC|1,a_intend_loop+2,s39
s40	LWLL	AC14F06,AFUNC|1,a_intend_loop+2,s40
ask41	LWLLL	1,AFUNC|1,a_speed_branchil+4,14000h,ask41
	LW	AC14F08,127
	.long	0
skid4_1802
skid4_ccw
s41	LWWLWL	AC24F02,AFLIP|AFUNC|1,0,a_bfaceiloop+3,6,s41
s42	LWLL	AC24F03,AFUNC|2,a_intend_loop+2,s42
s43	LWLL	AC24F04,AFUNC|1,a_intend_loop+2,s43
s44	LWLL	AC24F05,AFUNC|1,a_intend_loop+2,s44
ask42	LWLLL	1,AFUNC|1,a_speed_branchil+4,18000h,ask42
s45	LWLL	AC24F06,AFUNC|1,a_intend_loop+2,s45
ask43	LWLLL	1,AFUNC|1,a_speed_branchil+4,0e000h,ask43
	LW	AC24F07,127
	.long	0

anim_skid_5
	LWL	1,AFUNC|1,a_skid_pick_s+8
	.long	 skid5_1801,skid5_1802,skid5_cw,skid5_ccw
skid5_1801
skid5_cw
s46	LWWLWL	AC15F02,AFLIP|AFUNC|1,0,a_bfaceiloop+3,3,s46
s47	LWLL	AC15F03,AFUNC|2,a_intend_loop+2,s47
s48	LWLL	AC15F04,AFUNC|1,a_intend_loop+2,s48
s49	LWLL	AC15F05,AFUNC|1,a_intend_loop+2,s49
ask51	LWLLL	1,AFUNC|1,a_speed_branchil+4,18000h,ask51
s50	LWLL	AC15F06,AFUNC|1,a_intend_loop+2,s50
ask52	LWLLL	1,AFUNC|1,a_speed_branchil+4,0e000h,ask52
	LW	AC15F07,127
	.long	0
skid5_1802
skid5_ccw
s51	LWWLWL	AC15F02,AFLIP|AFUNC|1,M_FLIPH,a_bfaceiloop+3,7,s51		;can change to flipped 3
s52	LWLL	AC15F03,AFUNC|2,a_intend_loop+2,s52
s53	LWLL	AC15F04,AFUNC|1,a_intend_loop+2,s53
s54	LWLL	AC15F05,AFUNC|1,a_intend_loop+2,s54
ask53	LWLLL	1,AFUNC|1,a_speed_branchil+4,18000h,ask53
s55	LWLL	AC15F06,AFUNC|1,a_intend_loop+2,s55
ask54	LWLLL	1,AFUNC|1,a_speed_branchil+4,0e000h,ask54
	LW	AC15F07,127
	.long	0

anim_skid_6
	LWL	1,AFUNC|1,a_skid_pick_s+8
	.long	 skid6_1801,skid6_1802,skid6_cw,skid6_ccw
skid6_1802
skid6_ccw
s56	LWWLWL	AC14F01,AFLIP|AFUNC|1,M_FLIPH,a_bfaceiloop+3,8,s56
s57	LWLL	AC14F02,AFUNC|2,a_intend_loop+2,s57
s58	LWLL	AC14F03,AFUNC|1,a_intend_loop+2,s58
s59	LWLL	AC14F04,AFUNC|1,a_intend_loop+2,s59
s60	LWLL	AC14F06,AFUNC|1,a_intend_loop+2,s60
ask61	LWLLL	1,AFUNC|1,a_speed_branchil+4,14000h,ask61
	LW	AC14F08,127
	.long	0
skid6_1801
skid6_cw
s61	LWWLWL	AC24F02,AFLIP|AFUNC|1,M_FLIPH,a_bfaceiloop+3,4,s61
s62	LWLL	AC24F03,AFUNC|2,a_intend_loop+2,s62
s63	LWLL	AC24F04,AFUNC|1,a_intend_loop+2,s63
s64	LWLL	AC24F05,AFUNC|1,a_intend_loop+2,s64
ask62	LWLLL	1,AFUNC|1,a_speed_branchil+4,18000h,ask62
s65	LWLL	AC24F06,AFUNC|1,a_intend_loop+2,s65
ask63	LWLLL	1,AFUNC|1,a_speed_branchil+4,0e000h,ask63
	LW	AC24F07,127
	.long	0

anim_skid_7
	LWL	1,AFUNC|1,a_skid_pick_s+8
	.long	 skid7_1801,skid7_1802,skid7_cw,skid7_ccw
skid7_1801
skid7_1802
skid7_ccw
s66	LWWLWL	AC33F01,AFLIP|AFUNC|1,M_FLIPH,a_bfaceiloop+3,1,s66
s67	LWLL	AC33F03,AFUNC|2,a_intend_loop+2,s67
s68	LWLL	AC33F04,AFUNC|1,a_intend_loop+2,s68
s69	LWLL	AC33F06,AFUNC|1,a_intend_loop+2,s69
ask71	LWLLL	1,AFUNC|1,a_speed_branchil+4,18000h,ask71
s70	LWLL	AC33F07,AFUNC|1,a_intend_loop+2,s70
ask72	LWLLL	1,AFUNC|1,a_speed_branchil+4,0e000h,ask72
	LW	AC33F08,127
	.long	0
skid7_cw
s71	LWWLWL	AC43F02,AFLIP|AFUNC|1,M_FLIPH,a_bfaceiloop+3,5,s71
s72	LWLL	AC43F03,AFUNC|2,a_intend_loop+2,s72
s73	LWLL	AC43F05,AFUNC|1,a_intend_loop+2,s73
s74	LWLL	AC43F06,AFUNC|1,a_intend_loop+2,s74
ask73	LWLLL	1,AFUNC|1,a_speed_branchil+4,18000h,ask73
s75	LWLL	AC43F07,AFUNC|1,a_intend_loop+2,s75
ask74	LWLLL	1,AFUNC|1,a_speed_branchil+4,0e000h,ask74
	LW	AC43F08,127
	.long	0

anim_skid_8
	LWL	1,AFUNC|1,a_skid_pick_s+8
	.long	 skid8_1801,skid8_1802,skid8_cw,skid8_ccw
skid8_1801
skid8_1802
skid8_cw
skid8_ccw
s76	LWWLWL	AC12F02,AFLIP|AFUNC|1,M_FLIPH,a_bfaceiloop+3,6,s76
s77	LWLL	AC12F03,AFUNC|2,a_intend_loop+2,s77
s78	LWLL	AC12F04,AFUNC|1,a_intend_loop+2,s78
s79	LWLL	AC12F05,AFUNC|1,a_intend_loop+2,s79
ask81	LWLLL	1,AFUNC|1,a_speed_branchil+4,18000h,ask81
s80	LWLL	AC12F06,AFUNC|1,a_intend_loop+2,s80
ask82	LWLLL	1,AFUNC|1,a_speed_branchil+4,0e000h,ask82
	LW	AC12F07,127
	.long	0

anim_stand_1
amst1	LWW	FI11F06,AFLIP|4,0
	LW	FI11F07,4
	LW	FI11F08,4
	LWL	FI11F07,AFUNC|4,a_puck_wait+2
	.long	amst1
	LW	FI11F06,4
	LW	FI11F04,4
	LW	FI11F03,4
	LW	FI11F02,4
	LW	FI11F03,4
	LW	FI11F04,4
	.long	0
anim_stand_2
amst2	LWW	FI12F06,AFLIP|4,0
	LW	FI12F08,4
	LW	FI12F09,4
	LWL	FI12F08,AFUNC|4,a_puck_wait+2
	.long	amst2
	LW	FI12F06,4
	LW	FI12F05,4
	LW	FI12F04,4
	LW	FI12F02,4
	LW	FI12F04,4
	LW	FI12F05,4
	.long	0
anim_stand_3
	LWW	FI13F03,AFLIP|4,0
	LW	FI13F04,4
	LWL	FI13F05,AFUNC|4,a_puck_wait+2
	.long	amst3
	LW	FI13F06,4
	LW	FI13F08,4
	LW	FI13F10,4
	LW	FI13F08,4
	LW	FI13F06,4
	LW	FI13F05,4
amst3	LW	FI13F04,4
	.long	0
anim_stand_4
amst4	LWW	FI14F06,AFLIP|4,0
	LW	FI14F07,4
	LW	FI14F08,4
	LWL	FI14F07,AFUNC|4,a_puck_wait+2
	.long	amst4
	LW	FI14F06,4
	LW	FI14F04,4
	LW	FI14F03,4
	LW	FI14F01,4
	LW	FI14F03,4
	LW	FI14F04,4
	.long	0
anim_stand_5
amst5	LWW	FI15F05,AFLIP|4,0
	LW	FI15F06,4
	LW	FI15F07,4
	LWL	FI15F06,AFUNC|4,a_puck_wait+2
	.long	amst5
	LW	FI15F05,4
	LW	FI15F04,4
	LW	FI15F03,4
	LW	FI15F02,4
	LW	FI15F03,4
	LW	FI15F04,4
	.long	0
anim_stand_6
amst6	LWW	FI14F06,AFLIP|4,M_FLIPH
	LW	FI14F07,4
	LW	FI14F08,4
	LWL	FI14F07,AFUNC|4,a_puck_wait+2
	.long	amst6
	LW	FI14F06,4
	LW	FI14F04,4
	LW	FI14F03,4
	LW	FI14F01,4
	LW	FI14F03,4
	LW	FI14F04,4
	.long	0
anim_stand_7
	LWW	FI13F03,AFLIP|4,M_FLIPH
	LW	FI13F04,4
	LWL	FI13F05,AFUNC|4,a_puck_wait+2
	.long	amst7
	LW	FI13F06,4
	LW	FI13F08,4
	LW	FI13F10,4
	LW	FI13F08,4
	LW	FI13F06,4
	LW	FI13F05,4
amst7	LW	FI13F04,4
	.long	0
anim_stand_8
amst8	LWW	FI12F06,AFLIP|4,M_FLIPH
	LW	FI12F08,4
	LW	FI12F09,4
	LWL	FI12F08,AFUNC|4,a_puck_wait+2
	.long	amst8
	LW	FI12F06,4
	LW	FI12F05,4
	LW	FI12F04,4
	LW	FI12F02,4
	LW	FI12F04,4
	LW	FI12F05,4
	.long	0

anim_quick_step_1
	LWWL	AD21F03,AFUNC|AFLIP|3,0,a_quick_step_sound
	LW	AD21F04,3
	LWL	AD21F05,AFUNC|3,a_quick_step_sound
	LW	AD21F06,3
	LWL	AD21F07,AFUNC|3,a_set_qs_dir_sound
	LW	AD21F08,3
	LWL	AD21F09,AFUNC|3,a_quick_step_sound
	LW	AD21F10,3
	LWL	AD21F11,AFUNC|3,a_quick_step_sound
	LW	AD21F12,3
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

anim_quick_step_2
	LWWL	AD12F04,AFUNC|AFLIP|3,0,a_quick_step_sound
	LW	AD12F05,3
	LWL	AD12F06,AFUNC|3,a_quick_step_sound
	LW	AD12F07,3
	LWL	AD12F08,AFUNC|3,a_set_qs_dir_sound
	LW	AD12F10,3
	LW	AD12F11,3
	LWL	AD12F12,AFUNC|3,a_quick_step_sound
	LW	AD12F13,3
	LWL	AD12F14,AFUNC|3,a_quick_step_sound
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

anim_quick_step_3
	LWWL	AD23F07,AFUNC|AFLIP|3,0,a_quick_step_sound
	LW	AD23F08,3
	LW	AD23F09,3
	LWL	AD23F10,AFUNC|3,a_quick_step_sound
	LWL	AD23F11,AFUNC|3,a_set_qs_dir
	LW	AD23F12,3
	LWL	AD23F13,AFUNC|3,a_quick_step_sound
	LW	AD23F14,3
	LW	AD23F15,3
	LWL	AD23F16,AFUNC|3,a_quick_step_sound
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

anim_quick_step_4
	LWWL	AD14F03,AFUNC|AFLIP|3,0,a_quick_step_sound
	LW	AD14F05,3
	LWL	AD14F07,AFUNC|3,a_quick_step_sound
	LW	AD14F09,3
	LWL	AD14F10,AFUNC|3,a_set_qs_dir_sound
	LW	AD14F11,3
	LW	AD14F12,3
	LWL	AD14F14,AFUNC|3,a_quick_step_sound
	LW	AD14F15,3
	LWL	AD14F16,AFUNC|3,a_quick_step_sound
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

anim_quick_step_5
	LWWL	AD15F02,AFUNC|AFLIP|3,0,a_quick_step_sound
	LW	AD15F03,3
	LW	AD15F04,3
	LWL	AD15F05,AFUNC|3,a_quick_step_sound
	LWL	AD15F06,AFUNC|3,a_set_qs_dir
	LW	AD15F07,3
	LWL	AD15F08,AFUNC|3,a_quick_step_sound
	LW	AD15F09,3
	LW	AD15F10,3
	LWL	AD15F11,AFUNC|3,a_quick_step_sound
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

anim_quick_step_6
	LWWL	AD14F03,AFUNC|AFLIP|3,M_FLIPH,a_quick_step_sound
	LW	AD14F05,3
	LWL	AD14F07,AFUNC|3,a_quick_step_sound
	LW	AD14F09,3
	LWL	AD14F10,AFUNC|3,a_set_qs_dir_sound
	LW	AD14F11,3
	LW	AD14F12,3
	LWL	AD14F14,AFUNC|3,a_quick_step_sound
	LW	AD14F15,3
	LWL	AD14F16,AFUNC|3,a_quick_step_sound
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

anim_quick_step_7
	LWWL	AD23F07,AFUNC|AFLIP|3,M_FLIPH,a_quick_step_sound
	LW	AD23F08,3
	LW	AD23F09,3
	LWL	AD23F10,AFUNC|3,a_quick_step_sound
	LWL	AD23F11,AFUNC|3,a_set_qs_dir
	LW	AD23F12,3
	LWL	AD23F13,AFUNC|3,a_quick_step_sound
	LW	AD23F14,3
	LW	AD23F15,3
	LWL	AD23F16,AFUNC|3,a_quick_step_sound
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

anim_quick_step_8
	LWWL	AD12F04,AFUNC|AFLIP|3,M_FLIPH,a_quick_step_sound
	LW	AD12F05,3
	LWL	AD12F06,AFUNC|3,a_quick_step_sound
	LW	AD12F07,3
	LWL	AD12F08,AFUNC|3,a_set_qs_dir_sound
	LW	AD12F10,3
	LW	AD12F11,3
	LWL	AD12F12,AFUNC|3,a_quick_step_sound
	LW	AD12F13,3
	LWL	AD12F14,AFUNC|3,a_quick_step_sound
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

a_set_qs_dir_sound
	callr	a_set_qs_dir
a_quick_step_sound
	jauc	quick_step_dig_show

a_set_qs_dir
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_DIRECTION),a14
	move	a14,*a6(POF_QS_OK),W
	rets
a_set_no_qs
	move	*a8(ODT_PBK),a6,L	;get player block
	clr	a14
	dec	a14
	move	a14,*a6(POF_QS_OK),W
	rets

a_set_yes_qs
	move	*a8(ODT_PBK),a6,L	;get player block
	clr	a14
	move	a14,*a6(POF_QS_OK),W
	rets

anim_backward_qs_2
	LWWL	AE32F01,AFLIP|AFUNC|3,0,a_light_push
	LW	AE32F02,3
	LW	AE32F03,3
	LWL	AE32F04,AFUNC|3,a_light_push
	LW	AE32F05,3
	LWL	AE32F01,AFUNC|4,a_light_push
	LW	AE32F02,4
	LW	AE32F03,4
	LWL	AE32F04,AFUNC|4,a_light_push
	LW	AE32F05,4
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

anim_backward_qs_3
	LWW	AE83F02,AFLIP|3,0
	LWL	AE83F04,AFUNC|3,a_light_push
	LW	AE83F05,3
	LWL	AE83F06,AFUNC|3,a_light_push
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

anim_backward_qs_4
	LWWL	AE14F02,AFLIP|AFUNC|3,0,a_light_push
	LW	AE14F03,3
	LW	AE14F04,3
	LWL	AE14F05,AFUNC|3,a_light_push
	LW	AE14F06,3
	LWL	AE14F02,AFUNC|4,a_light_push
	LW	AE14F03,4
	LW	AE14F04,4
	LWL	AE14F05,AFUNC|4,a_light_push
	LW	AE14F06,4
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

anim_backward_qs_6
	LWWL	AE14F02,AFLIP|AFUNC|3,M_FLIPH,a_light_push
	LW	AE14F03,3
	LW	AE14F04,3
	LWL	AE14F05,AFUNC|3,a_light_push
	LW	AE14F06,3
	LWL	AE14F02,AFUNC|4,a_light_push
	LW	AE14F03,4
	LW	AE14F04,4
	LWL	AE14F05,AFUNC|4,a_light_push
	LW	AE14F06,4
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

anim_backward_qs_7
	LWW	AE83F02,AFLIP|3,M_FLIPH
	LWL	AE83F04,AFUNC|3,a_light_push
	LW	AE83F05,3
	LWL	AE83F06,AFUNC|3,a_light_push
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

anim_backward_qs_8
	LWWL	AE32F01,AFLIP|AFUNC|3,M_FLIPH,a_light_push
	LW	AE32F02,3
	LW	AE32F03,3
	LWL	AE32F04,AFUNC|3,a_light_push
	LW	AE32F05,3
	LWL	AE32F01,AFUNC|4,a_light_push
	LW	AE32F02,4
	LW	AE32F03,4
	LWL	AE32F04,AFUNC|4,a_light_push
	LW	AE32F05,4
	LWL	1,AFUNC|20,a_set_no_qs
	.long	0

;anim_backward_qs_3
;	LWW	AE43F01,AFLIP|5,0
;	LW	AE43F02,5
;	LWL	AE43F03,AFUNC|5,a_light_push
;	LW	AE43F01,5
;	LW	AE43F02,6
;	LWL	AE43F03,AFUNC|5,a_light_push
;	LWL	AE43F01,AFUNC|6,a_set_qs_dir
;	LW	AE43F02,6
;	LWL	AE43F03,AFUNC|6,a_light_push
;	LW	AE43F01,6
;	LW	AE43F02,7
;	LWL	AE43F03,AFUNC|6,a_light_push
;	LWL	1,AFUNC|20,a_set_no_qs
;	.long	0
;
;anim_backward_qs_7
;	LWW	AE43F01,AFLIP|5,M_FLIPH
;	LW	AE43F02,5
;	LWL	AE43F03,AFUNC|5,a_light_push
;	LW	AE43F01,5
;	LW	AE43F02,6
;	LWL	AE43F03,AFUNC|5,a_light_push
;	LWL	AE43F01,AFUNC|6,a_set_qs_dir
;	LW	AE43F02,6
;	LWL	AE43F03,AFUNC|6,a_light_push
;	LW	AE43F01,6
;	LW	AE43F02,7
;	LWL	AE43F03,AFUNC|6,a_light_push
;	LWL	1,AFUNC|20,a_set_no_qs
;	.long	0

anim_backward_skate_2
	LWWL	AE32F01,AFLIP|AFUNC|5,0,a_light_push
	LW	AE32F02,5
	LW	AE32F03,5
	LWL	AE32F04,AFUNC|5,a_light_push
	LW	AE32F05,5
	.long	0

anim_backward_skate_3
	LWWL	AE53F05,AFLIP|AFUNC|5,0,a_light_push
	LW	AE53F06,5
	LW	AE53F07,5
	LWL	AE53F08,AFUNC|5,a_light_push
	LW	AE53F09,5
	.long	0

anim_backward_skate_4
	LWWL	AE14F02,AFLIP|AFUNC|5,0,a_light_push
	LW	AE14F03,5
	LW	AE14F04,5
	LWL	AE14F05,AFUNC|5,a_light_push
	LW	AE14F06,5
	.long	0

anim_backward_skate_6
	LWWL	AE14F02,AFLIP|AFUNC|5,M_FLIPH,a_light_push
	LW	AE14F03,5
	LW	AE14F04,5
	LWL	AE14F05,AFUNC|5,a_light_push
	LW	AE14F06,5
	.long	0

anim_backward_skate_7
	LWWL	AE53F05,AFLIP|AFUNC|5,M_FLIPH,a_light_push
	LW	AE53F06,5
	LW	AE53F07,5
	LWL	AE53F08,AFUNC|5,a_light_push
	LW	AE53F09,5
	.long	0

anim_backward_skate_8
	LWWL	AE32F01,AFLIP|AFUNC|5,M_FLIPH,a_light_push
	LW	AE32F02,5
	LW	AE32F03,5
	LWL	AE32F04,AFUNC|5,a_light_push
	LW	AE32F05,5
	.long	0

;anim_backward_skate_3
;	LWW	AE43F01,AFLIP|7,0
;	LW	AE43F02,7
;	LWL	AE43F03,AFUNC|7,a_light_push
;	.long	0
;
;anim_backward_skate_7
;	LWW	AE43F01,AFLIP|7,M_FLIPH
;	LW	AE43F02,7
;	LWL	AE43F03,AFUNC|7,a_light_push
;	.long	0

anim_backward_gl_2
	LWW	AE32F04,AFLIP|20,0
	.long	0
anim_backward_gl_3
	LWW	AE53F07,AFLIP|20,0
	.long	0
anim_backward_gl_4
	LWW	AE14F03,AFLIP|20,0
	.long	0
anim_backward_gl_6
	LWW	AE14F03,AFLIP|20,M_FLIPH
	.long	0
anim_backward_gl_7
	LWW	AE53F07,AFLIP|20,M_FLIPH
	.long	0
anim_backward_gl_8
	LWW	AE32F04,AFLIP|20,M_FLIPH
	.long	0

anim_rskid_3
	LWWL	AE63F03,AFUNC|AFLIP|1,0,a_create_spray_r
	LW	AE63F04,1
	LW	AE63F05,1
arsk3	LWLLL	1,AFUNC|1,a_speed_branch+4,12000h,arsk3
	LW	AE63F07,20
	LW	AE63F07,20
	LW	AE63F07,20
	LW	AE63F07,20
	.long	0
anim_rskid_7
	LWWL	AE63F03,AFUNC|AFLIP|1,M_FLIPH,a_create_spray_r
	LW	AE63F04,1
	LW	AE63F05,1
arsk7	LWLLL	1,AFUNC|1,a_speed_branch+4,12000h,arsk7
	LW	AE63F07,20
	LW	AE63F07,20
	LW	AE63F07,20
	LW	AE63F07,20
	.long	0

anim_for_t_rev_script_2
	LWLL	1,AFUNC|1,a_rev_pick+2,a_ftr2_2
	LWWLW	AG12F01,AFUNC|AFLIP|3,0,a_bface+1,6
	LW	AG12F02,3
	LW	AG12F03,3
	LW	AG12F04,3
	LWL	1,AFUNC|1,a_2face+1,6
	.long	0
a_ftr2_2
	LWWLW	AG22F01,AFUNC|AFLIP|3,0,a_bface+1,6
	LW	AG22F02,3
	LW	AG22F03,3
	LW	AG22F04,3
	LW	AG22F05,3
	LWL	1,AFUNC|1,a_2face+1,6
	.long	0

anim_for_t_rev_script_3
	LWLL	1,AFUNC|1,a_rev_pick+2,a_ftr3_2
	LWWLW	AG23F01,AFUNC|AFLIP|3,0,a_bface+1,7
	LW	AG23F03,3
	LW	AG23F05,3
	LW	AG23F06,3
	LW	AG23F07,3
	LW	AG23F08,3

	LWL	1,AFUNC|1,a_2face+1,7
;	LWL	1,AFUNC|1,A_2FUNCS+5
;	.long	a_set_yes_qs
;	LW	a_2face+1,7
	.long	0
a_ftr3_2
	LWWLW	AD43F02,AFUNC|AFLIP|3,0,a_bface+1,7
	LW	AD43F03,3
	LW	AD43F04,3
	LW	AD43F05,3
	LW	AD43F06,3

	LWL	1,AFUNC|1,a_2face+1,7
;	LWL	1,AFUNC|1,A_2FUNCS+5
;	.long	a_set_yes_qs
;	LW	a_2face+1,7
	.long	0

anim_for_t_rev_script_4
	LWLL	1,AFUNC|1,a_rev_pick+2,a_ftr4_2
	LWWLW	AG14F01,AFUNC|AFLIP|3,0,a_bface+1,8
	LW	AG14F02,3
	LW	AG14F03,3
	LW	AG14F04,3
	LW	AG14F05,3
	LWL	1,AFUNC|1,a_2face+1,8
	.long	0
a_ftr4_2
	LWWLW	AG24F01,AFUNC|AFLIP|3,0,a_bface+1,8
	LW	AG24F02,3
	LW	AG24F03,3
	LW	AG24F04,3
	LW	AG24F05,3
	LWL	1,AFUNC|1,a_2face+1,8
	.long	0

anim_for_t_rev_script_6
	LWLL	1,AFUNC|1,a_rev_pick+2,a_ftr6_2
	LWWLW	AG14F01,AFUNC|AFLIP|3,M_FLIPH,a_bface+1,2
	LW	AG14F02,3
	LW	AG14F03,3
	LW	AG14F04,3
	LW	AG14F05,3
	LWL	1,AFUNC|1,a_2face+1,8
	.long	0
a_ftr6_2
	LWWLW	AG24F01,AFUNC|AFLIP|3,M_FLIPH,a_bface+1,2
	LW	AG24F02,3
	LW	AG24F03,3
	LW	AG24F04,3
	LW	AG24F05,3
	LWL	1,AFUNC|1,a_2face+1,8
	.long	0

anim_for_t_rev_script_7
	LWLL	1,AFUNC|1,a_rev_pick+2,a_ftr7_2
	LWWLW	AG23F01,AFUNC|AFLIP|3,M_FLIPH,a_bface+1,3
	LW	AG23F03,3
	LW	AG23F05,3
	LW	AG23F06,3
	LW	AG23F07,3
	LW	AG23F08,3

	LWL	1,AFUNC|1,a_2face+1,3
;	LWL	1,AFUNC|1,A_2FUNCS+5
;	.long	a_set_yes_qs
;	LW	a_2face+1,3
	.long	0
a_ftr7_2
	LWWLW	AD43F02,AFUNC|AFLIP|3,M_FLIPH,a_bface+1,3
	LW	AD43F03,3
	LW	AD43F04,3
	LW	AD43F05,3
	LW	AD43F06,3

	LWL	1,AFUNC|1,a_2face+1,3
;	LWL	1,AFUNC|1,A_2FUNCS+5
;	.long	a_set_yes_qs
;	LW	a_2face+1,3
	.long	0

anim_for_t_rev_script_8
	LWLL	1,AFUNC|1,a_rev_pick+2,a_ftr8_2
	LWWLW	AG12F01,AFUNC|AFLIP|3,M_FLIPH,a_bface+1,4
	LW	AG12F02,3
	LW	AG12F03,3
	LW	AG12F04,3
	LWL	1,AFUNC|1,a_2face+1,4
	.long	0
a_ftr8_2
	LWWLW	AG22F01,AFUNC|AFLIP|3,M_FLIPH,a_bface+1,4
	LW	AG22F02,3
	LW	AG22F03,3
	LW	AG22F04,3
	LW	AG22F05,3
	LWL	1,AFUNC|1,a_2face+1,4
	.long	0

anim_rev_t_for_script_2
	LWLL	1,AFUNC|1,a_rev_pick+2,a_rtf2_2
	LWWLW	AG12F04,AFUNC|AFLIP|3,0,a_bface+1,6
	LW	AG12F03,3
	LW	AG12F02,3
	LW	AG12F01,3
	LWL	1,AFUNC|1,a_2face+1,6
	.long	0
a_rtf2_2
	LWWLW	AG22F05,AFUNC|AFLIP|3,0,a_bface+1,6
	LW	AG22F04,3
	LW	AG22F03,3
	LW	AG22F02,3
	LW	AG22F01,3
	LWL	1,AFUNC|1,a_2face+1,6
	.long	0

anim_rev_t_for_script_3
	LWLL	1,AFUNC|1,a_rev_pick+2,a_rtf3_2
	LWWLW	AG23F08,AFUNC|AFLIP|3,M_FLIPH,a_bface+1,7
	LW	AG23F07,3
	LW	AG23F06,3
	LW	AG23F05,3
	LW	AG23F03,3
	LW	AG23F01,3
	LWL	1,AFUNC|1,a_2face+1,7
	.long	0
a_rtf3_2
	LWWLW	AD43F06,AFUNC|AFLIP|3,M_FLIPH,a_bface+1,7
	LW	AD43F05,3
	LW	AD43F04,3
	LW	AD43F03,3
	LW	AD43F02,3
	LWL	1,AFUNC|1,a_2face+1,7
	.long	0

anim_rev_t_for_script_4
	LWLL	1,AFUNC|1,a_rev_pick+2,a_rtf4_2
	LWWLW	AG14F05,AFUNC|AFLIP|3,0,a_bface+1,8
	LW	AG14F04,3
	LW	AG14F03,3
	LW	AG14F02,3
	LW	AG14F01,3
	LWL	1,AFUNC|1,a_2face+1,8
	.long	0
a_rtf4_2
	LWWLW	AG24F05,AFUNC|AFLIP|3,0,a_bface+1,8
	LW	AG24F04,3
	LW	AG24F03,3
	LW	AG24F02,3
	LW	AG24F01,3
	LWL	1,AFUNC|1,a_2face+1,8
	.long	0

anim_rev_t_for_script_6
	LWLL	1,AFUNC|1,a_rev_pick+2,a_rtf6_2
	LWWLW	AG14F05,AFUNC|AFLIP|3,M_FLIPH,a_bface+1,2
	LW	AG14F04,3
	LW	AG14F03,3
	LW	AG14F02,3
	LW	AG14F01,3
	LWL	1,AFUNC|1,a_2face+1,8
	.long	0
a_rtf6_2
	LWWLW	AG24F05,AFUNC|AFLIP|3,M_FLIPH,a_bface+1,2
	LW	AG24F04,3
	LW	AG24F03,3
	LW	AG24F02,3
	LW	AG24F01,3
	LWL	1,AFUNC|1,a_2face+1,8
	.long	0

anim_rev_t_for_script_7
	LWLL	1,AFUNC|1,a_rev_pick+2,a_rtf7_2
	LWWLW	AG23F08,AFUNC|AFLIP|3,0,a_bface+1,3
	LW	AG23F07,3
	LW	AG23F06,3
	LW	AG23F05,3
	LW	AG23F03,3
	LW	AG23F01,3
	LWL	1,AFUNC|1,a_2face+1,3
	.long	0
a_rtf7_2
	LWWLW	AD43F06,AFUNC|AFLIP|3,0,a_bface+1,3
	LW	AD43F05,3
	LW	AD43F04,3
	LW	AD43F03,3
	LW	AD43F02,3
	LWL	1,AFUNC|1,a_2face+1,3
	.long	0

anim_rev_t_for_script_8
	LWLL	1,AFUNC|1,a_rev_pick+2,a_rtf8_2
	LWWLW	AG12F04,AFUNC|AFLIP|3,M_FLIPH,a_bface+1,4
	LW	AG12F03,3
	LW	AG12F02,3
	LW	AG12F01,3
	LWL	1,AFUNC|1,a_2face+1,4
	.long	0
a_rtf8_2
	LWWLW	AG22F05,AFUNC|AFLIP|3,M_FLIPH,a_bface+1,4
	LW	AG22F04,3
	LW	AG22F03,3
	LW	AG22F02,3
	LW	AG22F01,3
	LWL	1,AFUNC|1,a_2face+1,4
	.long	0

set_relaxed_fast_skate_script
	movb	*a6(POF_DIRECTION),a14
	cmpi	1,a14
	jaz	set_run_script
	cmpi	5,a14
	jaz	set_run_script
	movi	srxsk_tab-32,a14
	jauc	start_panim_if_not_ta14
srxsk_tab
	.long	anim_relax_skate_1
	.long	anim_relax_skate_2
	.long	anim_relax_skate_3
	.long	anim_relax_skate_4
	.long	anim_relax_skate_5
	.long	anim_relax_skate_6
	.long	anim_relax_skate_7
	.long	anim_relax_skate_8

set_relaxed_stand_script
	movi	srst_tab-32,a14
	jauc	start_panim_if_not_ta14
srst_tab
	.long	anim_relax_stand_1
	.long	anim_relax_stand_2
	.long	anim_relax_stand_3
	.long	anim_relax_stand_4
	.long	anim_relax_stand_5
	.long	anim_relax_stand_6
	.long	anim_relax_stand_7
	.long	anim_relax_stand_8

anim_relax_skate_1
anim_relax_skate_5
	LW	AG13F03,4
	LW	AG13F04,4
	LWL	AG13F05,AFUNC|4,a_light_push
	LW	AG13F06,4
	LW	AG13F07,4
	LW	AG13F08,4
	LW	AG13F09,4
	LWL	AG13F10,AFUNC|4,a_light_push
	LW	AG13F11,4
	LW	AG13F12,4
	.long	0

anim_relax_skate_2
anim_relax_skate_3
anim_relax_skate_4
	LWW	AG13F03,AFLIP|4,0
	LW	AG13F04,4
	LWL	AG13F05,AFUNC|4,a_light_push
	LW	AG13F06,4
	LW	AG13F07,4
	LW	AG13F08,4
	LW	AG13F09,4
	LWL	AG13F10,AFUNC|4,a_light_push
	LW	AG13F11,4
	LW	AG13F12,4
	.long	0
anim_relax_skate_6
anim_relax_skate_7
anim_relax_skate_8
	LWW	AG13F03,AFLIP|4,M_FLIPH
	LW	AG13F04,4
	LWL	AG13F05,AFUNC|4,a_light_push
	LW	AG13F06,4
	LW	AG13F07,4
	LW	AG13F08,4
	LW	AG13F09,4
	LWL	AG13F10,AFUNC|4,a_light_push
	LW	AG13F11,4
	LW	AG13F12,4
	.long	0

anim_relax_stand_1
anim_relax_stand_5
	LW	AG13F07,7
	.long	0
anim_relax_stand_2
anim_relax_stand_3
anim_relax_stand_4
	LWW	AG13F07,AFLIP|7,0
	.long	0
anim_relax_stand_6
anim_relax_stand_7
anim_relax_stand_8
	LWW	AG13F07,AFLIP|7,M_FLIPH
	.long	0

srs1_tab			;skate rate 1, 1 hand on stick
	.long	srsk1t
	.long	tight_skate_right_tab
	.long	tight_skate_left_tab
	.long	tight_skate_right_left_tab

srsk1t	.long	anim_1_skate_fast_1
	.long	anim_1_skate_fast_2
	.long	anim_1_skate_fast_3
	.long	anim_1_skate_fast_4
	.long	anim_1_skate_fast_5
	.long	anim_1_skate_fast_6
	.long	anim_1_skate_fast_7
	.long	anim_1_skate_fast_8


anim_1_skate_fast_1
	LWWL	AH21F06,AFLIP|AFUNC|3,0,a_set_srt_1
	LWL	AH21F07,AFUNC|3,a_light_push
	LW	AH21F08,3
	LW	AH21F02,3
	LW	AH21F03,3
	LWL	AH21F04,AFUNC|3,a_light_push
	LWL	AH21F05,AFUNC|3,a_set_srt_off
	.long	0

anim_1_skate_fast_2
	LWWL	AH22F04,AFLIP|AFUNC|4,0,a_set_srt_1
	LWL	AH22F05,AFUNC|4,a_light_push
	LW	AH22F06,4
	LW	AH22F07,4
	LWL	AH22F02,AFUNC|4,a_light_push
	LWL	AH22F03,AFUNC|4,a_set_srt_off
	.long	0

anim_1_skate_fast_3
	LWWL	AH33F03,AFLIP|AFUNC|4,0,a_set_srt_1
	LWL	AH33F04,AFUNC|4,a_light_push
	LW	AH33F05,4
	LW	AH33F06,4
	LWL	AH33F07,AFUNC|4,a_light_push
	LWL	AH33F08,AFUNC|4,a_set_srt_off
	.long	0

anim_1_skate_fast_4
	LWWL	AH24F04,AFLIP|AFUNC|3,0,a_set_srt_1
	LWL	AH24F05,AFUNC|3,a_light_push
	LW	AH24F06,3
	LW	AH24F07,3
	LW	AH24F08,3
	LWL	AH24F09,AFUNC|3,a_light_push
	LW	AH24F10,3
	LWL	AH24F03,AFUNC|3,a_set_srt_off
	.long	0

anim_1_skate_fast_5
	LWWL	AH25F03,AFLIP|AFUNC|3,0,a_set_srt_1
	LWL	AH25F04,AFUNC|3,a_light_push
	LW	AH25F05,3
	LW	AH25F06,3
	LW	AH25F07,3
	LWL	AH25F08,AFUNC|3,a_light_push
	LWL	AH25F02,AFUNC|3,a_set_srt_off
	.long	0

anim_1_skate_fast_6
	LWWL	AH24F04,AFLIP|AFUNC|3,M_FLIPH,a_set_srt_1
	LWL	AH24F05,AFUNC|3,a_light_push
	LW	AH24F06,3
	LW	AH24F07,3
	LW	AH24F08,3
	LWL	AH24F09,AFUNC|3,a_light_push
	LW	AH24F10,3
	LWL	AH24F03,AFUNC|3,a_set_srt_off
	.long	0

anim_1_skate_fast_7
	LWWL	AH33F03,AFLIP|AFUNC|4,M_FLIPH,a_set_srt_1
	LWL	AH33F04,AFUNC|4,a_light_push
	LW	AH33F05,4
	LW	AH33F06,4
	LWL	AH33F07,AFUNC|4,a_light_push
	LWL	AH33F08,AFUNC|4,a_set_srt_off
	.long	0

anim_1_skate_fast_8
	LWWL	AH22F04,AFLIP|AFUNC|4,M_FLIPH,a_set_srt_1
	LWL	AH22F05,AFUNC|4,a_light_push
	LW	AH22F06,4
	LW	AH22F07,4
	LWL	AH22F02,AFUNC|4,a_light_push
	LWL	AH22F03,AFUNC|4,a_set_srt_off
	.long	0

a_set_srt_0
	clr	a0
	jruc	ssrt1
a_set_srt_1
	movk	1,a0
ssrt1	move	*a8(ODT_PBK),a6,L
	move	a0,*a6(POF_SKATE_RATE_T),W
	movb	*a6(POF_DIRECTION),*a6(POF_SKATE_RATE_D)
	rets

a_set_srt_off
	move	*a8(ODT_PBK),a6,L
clear_srt
	clr	a14
	dec	a14
	movb	a14,*a6(POF_SKATE_RATE_D)	;make our direction match noone
	rets
set_stand_script
	calla	give_player_control
	move	*a6(POF_PPMOD),a14,W
	sll	5,a14
	addi	sst_tab,a14
	move	*a14,a14,L
	subk	32,a14
	jauc	start_panim_if_not_ta14

sst_tab	.long	sss_tab
	.long	tight_stand_right_tab
	.long	tight_stand_left_tab
	.long	tight_stand_right_left_tab

sss_tab
	.long	anim_stand_1
	.long	anim_stand_2
	.long	anim_stand_3
	.long	anim_stand_4
	.long	anim_stand_5
	.long	anim_stand_6
	.long	anim_stand_7
	.long	anim_stand_8

tight_stand_right_tab
	.long	anim_stand_1
	.long	anim_tight_2
	.long	anim_tight_3
	.long	anim_tight_4
	.long	anim_stand_5
	.long	anim_stand_6
	.long	anim_stand_7
	.long	anim_stand_8

tight_stand_left_tab
	.long	anim_stand_1
	.long	anim_stand_2
	.long	anim_stand_3
	.long	anim_stand_4
	.long	anim_stand_5
	.long	anim_tight_6
	.long	anim_tight_7
	.long	anim_tight_8

tight_stand_right_left_tab
	.long	anim_stand_1
	.long	anim_tight_2
	.long	anim_tight_3
	.long	anim_tight_4
	.long	anim_stand_5
	.long	anim_tight_6
	.long	anim_tight_7
	.long	anim_tight_8

anim_tight_2
anim_tight_3
anim_tight_4
	LWW	GL13F01,AFLIP|10,0
	.long	0
anim_tight_6
anim_tight_7
anim_tight_8
	LWW	GL13F01,AFLIP|10,M_FLIPH
	.long	0

anim_glide_1
anim_run_1
	LWWL	AA11F13,AFUNC|AFLIP|3,0,a_set_srt_0
	LW	AA11F14,3
	LW	AA11F15,3
	LWL	AA11F05,AFUNC|4,a_light_push
	LW	AA11F06,3
	LW	AA11F07,3
	LW	AA11F08,3
	LW	AA11F09,3
	LWL	AA11F11,AFUNC|4,a_light_push
	LWL	AA11F12,AFUNC|3,a_set_srt_off
	.long	0

anim_r1run_1
	LWW	RL41F02,AFLIP|10,0
	.long	0
anim_r2run_1
	LWW	RL31F02,AFLIP|10,0
	.long	0

anim_l1run_1
	LWW	LL41F01,AFLIP|10,0
	.long	0
anim_l2run_1
	LWW	LL31F01,AFLIP|10,0
	.long	0

anim_run_2
	LWWL	AA22F02,AFUNC|AFLIP|4,0,a_set_srt_0
	LWL	AA22F03,AFUNC|3,a_light_push
	LW	AA22F04,3
	LW	AA22F05,3
	LW	AA22F06,3
	LWL	AA22F07,AFUNC|4,a_light_push
	LW	AA22F08,3
	LW	AA22F09,3
	LW	AA22F10,3
	LWL	AA22F12,AFUNC|3,a_set_srt_off
	.long	0

anim_r1run_2
	LWW	RL42F02,AFLIP|10,0
	.long	0
anim_r2run_2
	LWW	RL32F02,AFLIP|10,0
	.long	0

anim_l1run_2
	LWW	LL42F01,AFLIP|10,0
	.long	0
anim_l2run_2
	LWW	LL32F01,AFLIP|10,0
	.long	0

anim_run_3
	LWWL	AA53F06,AFUNC|AFLIP|4,0,a_set_srt_0
	LWL	AA53F07,AFUNC|3,a_light_push
	LW	AA53F08,3
	LW	AA53F09,3
	LW	AA53F10,3
	LWL	AA53F01,AFUNC|4,a_light_push
	LW	AA53F02,3
	LW	AA53F03,3
	LW	AA53F04,3
	LWL	AA53F05,AFUNC|3,a_set_srt_off
	.long	0

anim_r1run_3
	LWW	RL43F01,AFLIP|10,0
	.long	0
anim_r2run_3
	LWW	RL33F03,AFLIP|10,0
	.long	0

anim_l1run_3
	LWW	LL43F01,AFLIP|10,0
	.long	0
anim_l2run_3
	LWW	LL33F01,AFLIP|10,0
	.long	0

anim_run_4
	LWWL	AA14F07,AFUNC|AFLIP|4,0,a_set_srt_0
	LWL	AA14F08,AFUNC|3,a_light_push
	LW	AA14F10,3
	LW	AA14F11,3
	LW	AA14F12,3
	LWL	AA14F01,AFUNC|4,a_light_push
	LW	AA14F02,3
	LW	AA14F03,3
	LW	AA14F04,3
	LWL	AA14F05,AFUNC|3,a_set_srt_off
	.long	0

anim_r1run_4
	LWW	RL44F01,AFLIP|10,0
	.long	0
anim_r2run_4
	LWW	RL34F01,AFLIP|10,0
	.long	0

anim_l1run_4
	LWW	LL44F01,AFLIP|10,0
	.long	0
anim_l2run_4
	LWW	LL34F01,AFLIP|10,0
	.long	0

anim_glide_5
anim_run_5
	LWWL	AA15F11,AFUNC|AFLIP|4,0,a_set_srt_0
	LWL	AA15F12,AFUNC|3,a_light_push
	LW	AA15F01,3
	LW	AA15F02,3
	LW	AA15F03,3
	LWL	AA15F04,AFUNC|4,a_light_push
	LW	AA15F05,3
	LW	AA15F07,3
	LW	AA15F08,3
	LWL	AA15F09,AFUNC|3,a_set_srt_off
	.long	0

anim_r1run_5
	LWW	RL45F01,AFLIP|10,0
	.long	0
anim_r2run_5
	LWW	RL35F01,AFLIP|10,0
	.long	0

anim_l1run_5
	LWW	LL45F01,AFLIP|10,0
	.long	0
anim_l2run_5
	LWW	LL35F01,AFLIP|10,0
	.long	0

anim_run_6
	LWWL	AA14F07,AFUNC|AFLIP|4,M_FLIPH,a_set_srt_0
	LWL	AA14F08,AFUNC|3,a_light_push
	LW	AA14F10,3
	LW	AA14F11,3
	LW	AA14F12,3
	LWL	AA14F01,AFUNC|4,a_light_push
	LW	AA14F02,3
	LW	AA14F03,3
	LW	AA14F04,3
	LWL	AA14F05,AFUNC|3,a_set_srt_off
	.long	0

anim_r1run_6
	LWW	LL44F01,AFLIP|10,M_FLIPH
	.long	0
anim_r2run_6
	LWW	LL34F01,AFLIP|10,M_FLIPH
	.long	0

anim_l1run_6
	LWW	RL44F01,AFLIP|10,M_FLIPH
	.long	0
anim_l2run_6
	LWW	RL34F01,AFLIP|10,M_FLIPH
	.long	0

anim_run_7
	LWWL	AA53F06,AFUNC|AFLIP|4,M_FLIPH,a_set_srt_0
	LWL	AA53F07,AFUNC|3,a_light_push
	LW	AA53F08,3
	LW	AA53F09,3
	LW	AA53F10,3
	LWL	AA53F01,AFUNC|4,a_light_push
	LW	AA53F02,3
	LW	AA53F03,3
	LW	AA53F04,3
	LWL	AA53F05,AFUNC|3,a_set_srt_off
	.long	0

anim_r1run_7
	LWW	LL43F01,AFLIP|10,M_FLIPH
	.long	0
anim_r2run_7
	LWW	LL33F01,AFLIP|10,M_FLIPH
	.long	0

anim_l1run_7
	LWW	RL43F01,AFLIP|10,M_FLIPH
	.long	0
anim_l2run_7
	LWW	RL33F03,AFLIP|10,M_FLIPH
	.long	0

anim_run_8
	LWWL	AA22F02,AFUNC|AFLIP|4,M_FLIPH,a_set_srt_0
	LWL	AA22F03,AFUNC|3,a_light_push
	LW	AA22F04,3
	LW	AA22F05,3
	LW	AA22F06,3
	LWL	AA22F07,AFUNC|4,a_light_push
	LW	AA22F08,3
	LW	AA22F09,3
	LW	AA22F10,3
	LWL	AA22F12,AFUNC|3,a_set_srt_off
	.long	0

anim_r1run_8
	LWW	LL42F01,AFLIP|10,M_FLIPH
	.long	0
anim_r2run_8
	LWW	LL32F01,AFLIP|10,M_FLIPH
	.long	0

anim_l1run_8
	LWW	RL42F02,AFLIP|10,M_FLIPH
	.long	0
anim_l2run_8
	LWW	RL32F02,AFLIP|10,M_FLIPH
	.long	0

anim_crun_1
	LWW	AA11F13,AFLIP|3,0
	LW	AA11F14,3
	LW	AA11F15,3
	LWL	AA11F05,AFUNC|4,a_light_push
	LW	AA11F06,3
	LW	AA11F07,3
	LW	AA11F08,3
	LW	AA11F09,3
	LWL	AA11F11,AFUNC|4,a_light_push
	LW	AA11F12,3
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_crun_2
	LWWL	AA22F02,AFLIP|AFUNC|4,0,a_light_push
	LW	AA22F03,3
	LW	AA22F04,3
	LW	AA22F05,3
	LW	AA22F06,3
	LWL	AA22F07,AFUNC|4,a_light_push
	LW	AA22F08,3
	LW	AA22F09,3
	LW	AA22F10,3
	LW	AA22F12,3
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_crun_3
	LWWL	AA53F06,AFLIP|AFUNC|4,0,a_light_push
	LW	AA53F07,3
	LW	AA53F08,3
	LW	AA53F09,3
	LW	AA53F10,3
	LWL	AA53F01,AFUNC|4,a_light_push
	LW	AA53F02,3
	LW	AA53F03,3
	LW	AA53F04,3
	LW	AA53F05,3
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_crun_4
	LWWL	AA14F07,AFLIP|AFUNC|4,0,a_light_push
	LW	AA14F08,3
	LW	AA14F10,3
	LW	AA14F11,3
	LW	AA14F12,3
	LWL	AA14F01,AFUNC|4,a_light_push
	LW	AA14F02,3
	LW	AA14F03,3
	LW	AA14F04,3
	LW	AA14F05,3
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_crun_5
	LWWL	AA15F11,AFLIP|AFUNC|4,0,a_light_push
	LW	AA15F12,3
	LW	AA15F01,3
	LW	AA15F02,3
	LW	AA15F03,3
	LWL	AA15F04,AFUNC|4,a_light_push
	LW	AA15F05,3
	LW	AA15F07,3
	LW	AA15F08,3
	LW	AA15F09,3
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_crun_6
	LWWL	AA14F07,AFLIP|AFUNC|4,M_FLIPH,a_light_push
	LW	AA14F08,3
	LW	AA14F10,3
	LW	AA14F11,3
	LW	AA14F12,3
	LWL	AA14F01,AFUNC|4,a_light_push
	LW	AA14F02,3
	LW	AA14F03,3
	LW	AA14F04,3
	LW	AA14F05,3
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_crun_7
	LWWL	AA53F06,AFLIP|AFUNC|4,M_FLIPH,a_light_push
	LW	AA53F07,3
	LW	AA53F08,3
	LW	AA53F09,3
	LW	AA53F10,3
	LWL	AA53F01,AFUNC|4,a_light_push
	LW	AA53F02,3
	LW	AA53F03,3
	LW	AA53F04,3
	LW	AA53F05,3
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_crun_8
	LWWL	AA22F02,AFLIP|AFUNC|4,M_FLIPH,a_light_push
	LW	AA22F03,3
	LW	AA22F04,3
	LW	AA22F05,3
	LW	AA22F06,3
	LWL	AA22F07,AFUNC|4,a_light_push
	LW	AA22F08,3
	LW	AA22F09,3
	LW	AA22F10,3
	LW	AA22F12,3
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
**************************************************************************
*								         *
* a_skid_pick - pick skid script branch based on ODT_DIR and ODT_GDIR	 *
* 	parameters (4 longs)						 *
* 		script branch address for 180 degree change (TEAM 1)	 *
* 		script branch address for 180 degree change (TEAM 2)	 *
* 		script branch address for clockwise direction change	 *
* 		script branch address for counter-clockwise direction ch *
*								         *
**************************************************************************
a_skid_pick_s
	callr	a_skid_pick
	jauc	a_create_spray

a_skid_pick
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	asp_99			;if another animation is controlling us, abort
	btst	B_PF_HIGHER,a14
	jrnz	asp_99
	btst	B_PF_HIGHER_W,a14
	jrnz	asp_99
	move	*a8(ANIMARG),a14,L
	move	*a8(ODT_GDIR),a0,L
	move	*a8(ODT_DIR),a1,L
	sub	a1,a0			;a0 is our difference
	THETA_H	a0
	cmpi	XD1800,a0
	jrz	asp_180			;180 change, do 180
	cmpi	-XD1800,a0
	jrz	asp_180			;-180 change, do 180
	move	a0,a0
	jrz	asp_180			;no change, do 180
	jrn	asp_cw			;going cw
asp_ccw	move	*a14(060h),a14,L	;going ccw
	jruc	asp_9
asp_cw	move	*a14(040h),a14,L
	jruc	asp_9
asp_180	movb	*a6(POF_NUMBER),a6
	dec	a6
	srl	2,a6
	sll	5,a6
	add	a6,a14			;add team offset to a14 (0 or 20h)
	move	*a14,a14,L		;get 180 script
asp_9	move	a14,*a8(ANIMFRM),L	;jump us to this frame
asp_99	rets


**************************************************************************
*								         *
* a_rev_pick - pick reversal script based on OZPOS			 *
* 	parameters (1 long)						 *
* 		script branch address if z < midpoint			 *
*								         *
**************************************************************************
a_rev_pick
	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	rvp_99			;if another animation is controlling us, abort
	btst	B_PF_HIGHER,a14
	jrnz	rvp_99
	btst	B_PF_HIGHER_W,a14
	jrnz	rvp_99
	move	*a8(ANIMARG),a14,L
	move	*a8(OZPOS),a1,W
	cmpi	339,a1
	jrgt	rvp_99
	move	*a14,a14,L		;get 180 script
	move	a14,*a8(ANIMFRM),L	;jump us to this frame
rvp_99	rets


;anim_glide_1
;	LWL	AB12F04,6|AFUNC,a_set_15_flip
;	LW	AB12F05,6
;	LW	AB12F06,6
;	.long	0

anim_glide_2
	LWW	AB12F04,AFLIP|6,0
	LW	AB12F05,6
	LW	AB12F06,6
	.long	0

anim_glide_3
	LWW	AB23F01,AFLIP|6,0
	LW	AB23F02,6
	LW	AB23F03,6
	.long	0

anim_glide_4
	LWW	AB14F01,AFLIP|6,0
	LW	AB14F02,6
	LW	AB14F03,6
	.long	0

;anim_glide_5
;	LWL	AB14F01,6|AFUNC,a_set_15_flip
;	LW	AB14F02,6
;	LW	AB14F03,6
;	.long	0

anim_glide_6
	LWW	AB14F01,AFLIP|6,M_FLIPH
	LW	AB14F02,6
	LW	AB14F03,6
	.long	0

anim_glide_7
	LWW	AB23F01,AFLIP|6,M_FLIPH
	LW	AB23F02,6
	LW	AB23F03,6
	.long	0

anim_glide_8
	LWW	AB12F04,AFLIP|6,M_FLIPH
	LW	AB12F05,6
	LW	AB12F06,6
	.long	0

anim_fglide_1
	LWL	AB12F04,3|AFUNC,a_set_15_flip
	LW	AB12F05,3
	LW	AB12F06,3
	.long	0

anim_fglide_2
	LWW	AB12F04,AFLIP|3,0
	LW	AB12F05,3
	LW	AB12F06,3
	.long	0

anim_fglide_3
	LWW	AB23F01,AFLIP|3,0
	LW	AB23F02,3
	LW	AB23F03,3
	.long	0

anim_fglide_4
	LWW	AB14F01,AFLIP|3,0
	LW	AB14F02,3
	LW	AB14F03,3
	.long	0

anim_fglide_6
	LWW	AB14F01,AFLIP|3,M_FLIPH
	LW	AB14F02,3
	LW	AB14F03,3
	.long	0

anim_fglide_5
	LWL	AB14F01,3|AFUNC,a_set_15_flip
	LW	AB14F02,3
	LW	AB14F03,3
	.long	0

anim_fglide_7
	LWW	AB23F01,AFLIP|3,M_FLIPH
	LW	AB23F02,3
	LW	AB23F03,3
	.long	0

anim_fglide_8
	LWW	AB12F04,AFLIP|3,M_FLIPH
	LW	AB12F05,3
	LW	AB12F06,3
	.long	0



anim_split_legs_wide_1
	LWW	SP11F01,AFLIP|4,0
	LW	SP11F03,4
	LW	SP11F05,7
	LW	SP11F03,4
	.long	0
anim_split_legs_wide_2
	LWW	SP12F01,AFLIP|4,0
	LW	SP12F03,4
	LW	SP12F05,7
	LW	SP12F03,4
	.long	0
anim_split_legs_wide_3
	LWW	SP13F01,AFLIP|4,0
	LW	SP13F02,4
	LW	SP13F03,4
	LW	SP13F04,5
	LW	SP13F03,4
	LW	SP13F02,4
	.long	0
anim_split_legs_wide_4
	LWW	SP14F01,AFLIP|4,0
	LW	SP14F03,4
	LW	SP14F04,7
	LW	SP14F03,4
	.long	0
anim_split_legs_wide_5
	LWW	SP15F01,AFLIP|4,0
	LW	SP15F03,4
	LW	SP15F05,7
	LW	SP15F03,4
	.long	0
anim_split_legs_wide_6
	LWW	SP14F01,AFLIP|4,M_FLIPH
	LW	SP14F03,4
	LW	SP14F04,7
	LW	SP14F03,4
	.long	0
anim_split_legs_wide_7
	LWW	SP13F01,AFLIP|4,M_FLIPH
	LW	SP13F02,4
	LW	SP13F03,4
	LW	SP13F04,5
	LW	SP13F03,4
	LW	SP13F02,4
	.long	0
anim_split_legs_wide_8
	LWW	SP12F01,AFLIP|4,M_FLIPH
	LW	SP12F03,4
	LW	SP12F05,7
	LW	SP12F03,4
	.long	0

anim_deke_shoulder_1
	LWW	DK11F02,AFLIP|3,0
	LW	DK11F03,3
	LW	DK11F04,3
	LW	DK11F05,3
	LW	DK11F04,3
	LW	DK11F03,3
	.long	0
anim_deke_shoulder_2
	LWW	DK12F02,AFLIP|3,0
	LW	DK12F03,3
	LW	DK12F04,3
	LW	DK12F05,3
	LW	DK12F04,3
	LW	DK12F03,3
	.long	0
anim_deke_shoulder_3
	LWW	DK13F02,AFLIP|3,0
	LW	DK13F03,3
	LW	DK13F04,3
	LW	DK13F05,3
	LW	DK13F04,3
	LW	DK13F03,3
	.long	0
anim_deke_shoulder_4
	LWW	DK14F04,AFLIP|3,0
	LW	DK14F05,3
	LW	DK14F06,3
	LW	DK14F07,3
	LW	DK14F06,3
	LW	DK14F05,3
	.long	0
anim_deke_shoulder_5
	LWW	DK15F01,AFLIP|3,0
	LW	DK15F02,3
	LW	DK15F03,3
	LW	DK15F04,3
	LW	DK15F03,3
	LW	DK15F02,3
	.long	0
anim_deke_shoulder_6
	LWW	DK14F04,AFLIP|3,M_FLIPH
	LW	DK14F05,3
	LW	DK14F06,3
	LW	DK14F07,3
	LW	DK14F06,3
	LW	DK14F05,3
	.long	0
anim_deke_shoulder_7
	LWW	DK13F02,AFLIP|3,M_FLIPH
	LW	DK13F03,3
	LW	DK13F04,3
	LW	DK13F05,3
	LW	DK13F04,3
	LW	DK13F03,3
	.long	0
anim_deke_shoulder_8
	LWW	DK12F02,AFLIP|3,M_FLIPH
	LW	DK12F03,3
	LW	DK12F04,3
	LW	DK12F05,3
	LW	DK12F04,3
	LW	DK12F03,3
	.long	0

anim_spinarama_right_1
anim_spinarama_right_5
	LW	FF23F01,4
	LW	FF23F02,3
	LW	FF23F03,3
	LW	FF23F04,3
	LW	FF93F03,3
	LW	FF93F04,2
	LW	FF93F05,2
	.long	0

anim_spinarama_right_2
anim_spinarama_right_3
anim_spinarama_right_4
	LWW	FF23F01,AFLIP|4,0
	LW	FF23F02,3
	LW	FF23F03,3
	LW	FF23F04,3
	LW	FF93F03,3
	LW	FF93F04,2
	LW	FF93F05,2
	.long	0

anim_spinarama_right_6
anim_spinarama_right_7
anim_spinarama_right_8
	LWW	FF23F01,AFLIP|4,M_FLIPH
	LW	FF23F02,3
	LW	FF23F03,3
	LW	FF23F04,3
	LW	FF93F03,3
	LW	FF93F04,2
	LW	FF93F05,2
	.long	0

anim_spinarama_left_1
anim_spinarama_left_5
	LW	FF33F02,5
	LW	FF33F03,4
	LW	FF33F04,4
	LW	FF73F04,4
	LW	FF83F04,3
	LW	FF83F06,3
	.long	0

anim_spinarama_left_2
anim_spinarama_left_3
anim_spinarama_left_4
	LWW	FF33F02,AFLIP|5,0
	LW	FF33F03,4
	LW	FF33F04,4
	LW	FF73F04,4
	LW	FF83F04,3
	LW	FF83F06,3
	.long	0

anim_spinarama_left_6
anim_spinarama_left_7
anim_spinarama_left_8
	LWW	FF33F02,AFLIP|5,M_FLIPH
	LW	FF33F03,4
	LW	FF33F04,4
	LW	FF73F04,4
	LW	FF83F04,3
	LW	FF83F06,3
	.long	0

