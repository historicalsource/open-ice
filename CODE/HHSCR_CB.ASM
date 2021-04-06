 	.MLIB	"HHMACS.LIB"
	.FILE	"HHSCR_CB.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhscrmcb.tbl"
	.include	"hhcontrl.g"
	.include	"hhproc.g"
	.include	"hhutil.g"
	.include	"hhtimer.g"
	.include	"hhgame.g"
	.include	"hhscore.g"
	.include	"hhmath.g"
	.include	"hhscr_cb.e"
	.include	"hhscr_fn.g"
	.include	"hhplayer.g"
	.include	"hhscr_sk.g"
	.include	"hhcmos.g"
	.include	"hhcontr2.g"

; end of include files

	.TEXT
	.EVEN

**************************************************************************
*								         *
* for player objects, OIMG looks like this				 *
* 	.word	control,xsize,ysize					 *
* 	.long	sag							 *
* 	.word	anix,aniy						 *
* 	.word	puckx,pucky						 *
* 	.word	headx,heady,headz					 *
* 	.word	head#							 *
*								         *
**************************************************************************
test_go
	movk	6,a0
	GBLOCK	a0,a6
	move	*a6(POF_OBJECT),a8,L
	calla	take_player_control
	movi	tg_tab-32,a14
	calla	start_panim_if_not_ta14
	jauc	SUCIDE

tg_tab
	.long	anim_test
	.long	anim_test
	.long	anim_test
	.long	anim_test
	.long	anim_test
	.long	anim_test
	.long	anim_test
	.long	anim_test
anim_test
	LW	CH53F01,4
	LWL	1,AFUNC|1,start_j1_grav
	LW	CH53F02,3
	LW	CH53F03,2
	LW	CH53F04,2
	LW	CH53F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH53F05,11
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH53F06,2
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

;	LW	CH63F01,4
;	LWL	1,AFUNC|1,start_j1_grav
;	LW	CH63F02,3
;	LW	CH63F03,2
;	LW	CH63F04,2
;	LW	CH63F05,6
;	LWL	1,AFUNC|1,start_j11_grav
;;	LW	CH63F05,19
;	LW	CH63F05,11
;	LWL	1,AFUNC|1,stop_j1_grav
;	LW	CH63F06,2
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0

**************************************************************************
*								         *
* for player objects, OIMG looks like this				 *
* 	.word	control,xsize,ysize					 *
* 	.long	sag							 *
* 	.word	anix,aniy						 *
* 	.word	puckx,pucky						 *
* 	.word	headx,heady,headz					 *
* 	.word	head#							 *
*								         *
**************************************************************************
score_celebrations
	move	@period,a0
	cmpi	4,a0
	jrnz	sc_rck
	movk	ADJPAYOT,a0
	calla	GET_ADJ
	jrz	scdoit2			;do celebration for both players always on overtime goal
sc_rck	move	@scored_by,a0,W
	jrz	sc_n9
	move	@hot_player,a14,W
	cmp	a0,a14
	jrz	scdoit2			;hot player scored, do 1 or 2 player celebration
sc_n9	rets

scdoit2	move	@scored_by,a0,W
	callr	celebrate_goal_player
	dec	a0
	xori	1,a0
	inc	a0
	callr	celebrate_happy_player
	dec	a0
	srl	2,a0
	xori	1,a0
	sll	2,a0
	inc	a0
	callr	celebrate_not_happy_player
	inc	a0
	jruc	celebrate_not_happy_player

celebrate_goal_player
	movi	celebrate_goal,a7
	jruc	cgp_1
celebrate_happy_player
	movi	celebrate_happy,a7
	jruc	cgp_1
celebrate_not_happy_player
	movi	celebrate_not_happy,a7
cgp_1	move	a0,a8
	move	a0,a1
	sll	8,a1
	addi	PIDOF_CELEBRATE,a1
	calla	GETPRC
	move	a8,a0
	rets

celebrate_happy
celebrate_not_happy
	jauc	SUCIDE

celebrate_goal
celebrate_around
	move	@scored_by,a14,W
	GBLOCK	a14,a6
	move	*a6(POF_OBJECT),a8,L
	movb	*a6(POF_NUMBER),a0
	dec	a0
	srl	2,a0
	jrnz	cat2
cat1	move	*a8(OXPOS),a0,W
	cmpi	233,a0
	jrlt	cat1_fr
	jruc	cat1_pg

cat1_fr		;past blue line
	movi	ca1fr_1,a10
	callr	do_celebration
	jauc	SUCIDE

cat1_pg		;past goal
	movi	ca1pg1u,a10
	move	*a8(OZPOS),a0,W
	cmpi	339,a0
	jrlt	cat1pg1
	movi	ca1pg1d,a10
cat1pg1	callr	do_celebration
	jauc	SUCIDE


cat2	move	*a8(OXPOS),a0,W
	cmpi	-233,a0
	jrgt	cat2_fr
	jruc	cat2_pg

cat2_fr		;past blue line
	movi	ca2fr_1,a10
	callr	do_celebration
	jauc	SUCIDE

cat2_pg		;past goal
	movi	ca2pg1u,a10
	move	*a8(OZPOS),a0,W
	cmpi	339,a0
	jrlt	cat2pg1
	movi	ca2pg1d,a10
cat2pg1	callr	do_celebration
	jauc	SUCIDE

DC_DCM	.macro	script,xpos,zpos,dist,vel
	.word	1
	.long	[:xpos:,0],[:zpos:,0],[:dist:,0],[:vel:,0]
	.long	:script:
	.endm

DC_DC	.macro	script,face,xvel,zvel
	.word	2
	.word	:face:
	.long	[:xvel:,0],[:zvel:,0]
	.long	:script:
	.endm

ca1fr_1	DC_DCM	set_regular_run_script		,500,420,30,6
	DC_DCM	set_regular_run_script		,600,420,30,6
	DC_DCM	set_regular_run_script		,640,400,30,6
	DC_DCM	set_regular_run_script		,660,380,30,6
	DC_DCM	set_regular_run_script		,660,370,30,6
	DC_DCM	set_regular_run_script		,640,365,30,6
	DC_DCM	set_regular_run_script		,600,365,30,6
	DC_DC	set_random_celebrate_script	,7,-5,0
	DC_DC	set_random_celebrate_script	,7,-5,0
	.word	0

ca1pg1u
	DC_DCM	set_celebrate_spin_move1_script	,780,250,30,6
	DC_DCM	set_celebrate_spin_move1_script	,780,500,30,6
	DC_DCM	set_celebrate_spin_move1_script	,760,535,30,6
	DC_DCM	set_celebrate_spin_move1_script	,710,540,30,6
	DC_DC	set_random_celebrate_script	,7,-5,0
	DC_DC	set_random_celebrate_script	,7,-5,0
	.word	0

ca1pg1d
	DC_DCM	set_celebrate_spin_move2_script	,780,429,30,6
	DC_DCM	set_celebrate_spin_move2_script	,780,178,30,6
	DC_DCM	set_celebrate_spin_move2_script	,760,143,30,6
	DC_DCM	set_celebrate_spin_move2_script	,710,138,30,6
	DC_DC	set_random_celebrate_script	,7,-5,0
	DC_DC	set_random_celebrate_script	,7,-5,0
	.word	0

ca2fr_1	DC_DCM	set_regular_run_script		,-500,420,30,6
	DC_DCM	set_regular_run_script		,-600,420,30,6
	DC_DCM	set_regular_run_script		,-640,400,30,6
	DC_DCM	set_regular_run_script		,-660,380,30,6
	DC_DCM	set_regular_run_script		,-660,370,30,6
	DC_DCM	set_regular_run_script		,-640,365,30,6
	DC_DCM	set_regular_run_script		,-600,365,30,6
	DC_DC	set_random_celebrate_script	,3,5,0
	DC_DC	set_random_celebrate_script	,3,5,0
	.word	0

ca2pg1u
	DC_DCM	set_celebrate_spin_move1_script	,-780,250,30,6
	DC_DCM	set_celebrate_spin_move1_script	,-780,500,30,6
	DC_DCM	set_celebrate_spin_move1_script	,-760,535,30,6
	DC_DCM	set_celebrate_spin_move1_script	,-710,540,30,6
	DC_DC	set_random_celebrate_script	,3,5,0
	DC_DC	set_random_celebrate_script	,3,5,0
	.word	0

ca2pg1d
	DC_DCM	set_celebrate_spin_move2_script	,-780,429,30,6
	DC_DCM	set_celebrate_spin_move2_script	,-780,178,30,6
	DC_DCM	set_celebrate_spin_move2_script	,-760,143,30,6
	DC_DCM	set_celebrate_spin_move2_script	,-710,138,30,6
	DC_DC	set_random_celebrate_script	,3,5,0
	DC_DC	set_random_celebrate_script	,3,5,0
	.word	0

**************************************************************************
*								         *
* do_celebration_move							 *
* 	input	a6  = player block					 *
* 		a8  = player object					 *
* 		a11 = script set address (skating)			 *
* 		a2  = x point to move to				 *
* 		a3  = z point to move to				 *
* 		a4  = target distance from point (come this close)	 *
* 		a5  = speed to move to point				 *
*								         *
**************************************************************************
do_celebration_table_move
	move	*a8(ODT_PBK),a6,L
	move	*a6(POF_CELEBRATION),a10,L
	move	*a10+,a2,L
	move	*a10+,a3,L
	move	*a10+,a4,L
	move	*a10+,a5,L
	move	*a10+,a11,L
	move	a10,*a6(POF_CELEBRATION),L
	JSRP	do_celebration_move
	callr	do_celeb_script
	jauc	SUCIDE
do_celebration_move
	move	a2,a9
	move	a3,a10
	move	a4,*a8(ODT_TEMP2),L
	move	a5,*a8(ODT_TEMP1),L
	move	a2,a0
	move	a3,a1
dcm1	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	move	*a8(ODT_PBK),a6,L
	calla	find_dirdis_to_point
	cmp	a4,a1
	jrls	dcm8
	move	a5,a1
	mmtm	sp,a0
	calla	set_obj_to_polar
	mmfm	sp,a0
	mmtm	sp,a11
	calla	dir_to_18
	mmfm	sp,a11
	movb	a0,*a6(POF_DIRECTION)
	call	a11
	SLEEP	1
	move	a9,a0
	move	a10,a1
	move	*a8(ODT_TEMP2),a4,L
	move	*a8(ODT_TEMP1),a5,L
	jruc	dcm1
dcm8	RETP

**************************************************************************
*								         *
* do_celebration							 *
* 	input	a6  = player block					 *
* 		a10 = celebration script address			 *
*								         *
**************************************************************************
do_celebration
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_CELEBRATE,a14
	move	a14,*a6(POF_FLAGS),W
	move	a10,*a6(POF_CELEBRATION),L
	calla	take_player_control
do_celeb_script
	move	*a6(POF_CELEBRATION),a10,L
	jrz	dcs_abr				;this is part one of our fix for no script set before function
	move	*a10+,a14,W
	move	a10,*a6(POF_CELEBRATION),L
	sll	5,a14
	addi	dcs_bs,a14
	move	*a14,a14,L
	jump	a14
dcs_abr	rets

dcs_bs	.long	dsc_0
	.long	dsc_1
	.long	dsc_2

dsc_0	move	*a8(ODT_PBK),a6,L	;get player block
	clr	a0
	move	a0,*a6(POF_CELEBRATION),L
	move	a0,*a6(POF_MODE),W
	move	*a6(POF_FLAGS),a14,W
	andni	M_PF_CELEBRATE,a14
	move	a14,*a6(POF_FLAGS),W
	movi	100,a0
	move	a0,*a8(ANISLP),W		;this is part two of our fix for no script set before function
	jauc	give_player_control
dsc_1	movi	PID_CELEBRATION_P,a1
	movi	do_celebration_table_move,a7
	jauc	GETPRC
dsc_2	move	*a8(ODT_PBK),a6,L	;get player block
	move	*a6(POF_CELEBRATION),a10,L
	move	*a10+,a14,W
	movb	a14,*a6(POF_DIRECTION)
	move	*a10+,a14,L
	move	a14,*a8(OXVEL),L
	move	*a10+,a14,L
	move	a14,*a8(OZVEL),L
	move	*a10+,a14,L
	move	a10,*a6(POF_CELEBRATION),L
	jump	a14

;0 - done
;1 - dcm - x,z,t,s,script
;2 - dc  - face,xv,zv,script

dcs9	move	*a8(ODT_PBK),a6,L	;get player block
	clr	a0
	move	a0,*a6(POF_CELEBRATION),L
	move	a0,*a6(POF_MODE),W
	jauc	give_player_control

a_celebrate_script_done
	move	*a8(ODT_PBK),a6,L
	jruc	do_celeb_script


set_random_celebrate_script
	movk	6,a0
	calla	RAND0
	sll	5,a0
	addi	srcstab,a0
	move	*a0,a0,L
	jump	a0

srcstab	.long	set_pump_arm_script
	.long	set_toe_run_script
	.long	set_leap1l_script
	.long	set_leap2l_script
	.long	set_celebrate_spin_script
	.long	set_knee_walk_script

set_celebrate_skate_script
	movi	scs_tab-32,a14
	jauc	start_panim_if_not_ta14
scs_tab
	.long	anim_crun_1
	.long	anim_crun_2
	.long	anim_crun_3
	.long	anim_crun_4
	.long	anim_crun_5
	.long	anim_crun_6
	.long	anim_crun_7
	.long	anim_crun_8

set_pump_arm_script
	movi	spak_tab-32,a14
	jauc	start_panim_if_not_ta14
spak_tab
	.long	anim_pump_arm_1
	.long	anim_pump_arm_2
	.long	anim_pump_arm_3
	.long	anim_pump_arm_4
	.long	anim_pump_arm_5
	.long	anim_pump_arm_6
	.long	anim_pump_arm_7
	.long	anim_pump_arm_8

set_pump_arm_move_script
	movi	spakm_tab-32,a14
	jauc	start_panim_if_not_ta14
spakm_tab
	.long	anim_pump_arm_m1
	.long	anim_pump_arm_m2
	.long	anim_pump_arm_m3
	.long	anim_pump_arm_m4
	.long	anim_pump_arm_m5
	.long	anim_pump_arm_m6
	.long	anim_pump_arm_m7
	.long	anim_pump_arm_m8

set_toe_run_script
	movi	strs_tab-32,a14
	jauc	start_panim_if_not_ta14
strs_tab
	.long	anim_toe_run_1
	.long	anim_toe_run_2
	.long	anim_toe_run_3
	.long	anim_toe_run_4
	.long	anim_toe_run_5
	.long	anim_toe_run_6
	.long	anim_toe_run_7
	.long	anim_toe_run_8

set_leap1l_script
	movi	sl1_tab-32,a14
	jauc	start_panim_if_not_ta14
sl1_tab
	.long	anim_leap1l_1
	.long	anim_leap1l_2
	.long	anim_leap1l_3
	.long	anim_leap1l_4
	.long	anim_leap1l_5
	.long	anim_leap1l_6
	.long	anim_leap1l_7
	.long	anim_leap1l_8

set_leap1h_script
	movi	sl1h_tab-32,a14
	jauc	start_panim_if_not_ta14
sl1h_tab
	.long	anim_leap1h_1
	.long	anim_leap1h_2
	.long	anim_leap1h_3
	.long	anim_leap1h_4
	.long	anim_leap1h_5
	.long	anim_leap1h_6
	.long	anim_leap1h_7
	.long	anim_leap1h_8

set_leap2l_script
	movi	sl2_tab-32,a14
	jauc	start_panim_if_not_ta14
sl2_tab
	.long	anim_leap2l_1
	.long	anim_leap2l_2
	.long	anim_leap2l_3
	.long	anim_leap2l_4
	.long	anim_leap2l_5
	.long	anim_leap2l_6
	.long	anim_leap2l_7
	.long	anim_leap2l_8

set_leap2h_script
	movi	sl2h_tab-32,a14
	jauc	start_panim_if_not_ta14
sl2h_tab
	.long	anim_leap2h_1
	.long	anim_leap2h_2
	.long	anim_leap2h_3
	.long	anim_leap2h_4
	.long	anim_leap2h_5
	.long	anim_leap2h_6
	.long	anim_leap2h_7
	.long	anim_leap2h_8

set_celebrate_spin_script
	movi	scsp_tab-32,a14
	jauc	start_panim_if_not_ta14
scsp_tab
	.long	anim_cspin_1
	.long	anim_cspin_2
	.long	anim_cspin_3
	.long	anim_cspin_4
	.long	anim_cspin_5
	.long	anim_cspin_6
	.long	anim_cspin_7
	.long	anim_cspin_8

set_celebrate_spin_move1_script		;(team1)
	movi	scspm1_tab-32,a14
	jauc	start_panim_if_not_ta14
scspm1_tab
	.long	anim_cspinm1_1
	.long	anim_cspinm1_2
	.long	anim_cspinm1_3
	.long	anim_cspinm1_4
	.long	anim_cspinm1_5
	.long	anim_cspinm1_6
	.long	anim_cspinm1_7
	.long	anim_cspinm1_8

set_celebrate_spin_move2_script		;(team2)
	movi	scspm2_tab-32,a14
	jauc	start_panim_if_not_ta14
scspm2_tab
	.long	anim_cspinm2_1
	.long	anim_cspinm2_2
	.long	anim_cspinm2_3
	.long	anim_cspinm2_4
	.long	anim_cspinm2_5
	.long	anim_cspinm2_6
	.long	anim_cspinm2_7
	.long	anim_cspinm2_8

set_knee_walk_script
	movi	skws_tab-32,a14
	jauc	start_panim_if_not_ta14
skws_tab
	.long	anim_knee_walk_1
	.long	anim_knee_walk_2
	.long	anim_knee_walk_3
	.long	anim_knee_walk_4
	.long	anim_knee_walk_5
	.long	anim_knee_walk_6
	.long	anim_knee_walk_7
	.long	anim_knee_walk_8

anim_pump_arm_1
	LW	CH11F01,4
	LW	CH11F02,4
	LW	CH11F03,4
	LW	CH11F04,4
	LW	CH11F05,4
	LW	CH11F07,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_pump_arm_2
	LWW	CH12F01,4|AFLIP,0
	LW	CH12F02,4
	LW	CH12F03,4
	LW	CH12F04,4
	LW	CH12F05,4
	LW	CH12F08,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_pump_arm_3
	LWW	CH13F01,4|AFLIP,0
	LW	CH13F02,4
	LW	CH13F03,4
	LW	CH13F04,4
	LW	CH13F05,4
	LW	CH13F08,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_pump_arm_4
	LWW	CH14F01,4|AFLIP,0
	LW	CH14F02,4
	LW	CH14F03,4
	LW	CH14F04,4
	LW	CH14F05,4
	LW	CH14F07,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_pump_arm_5
	LW	CH15F01,4
	LW	CH15F02,4
	LW	CH15F03,4
	LW	CH15F04,4
	LW	CH15F05,4
	LW	CH15F07,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_pump_arm_6
	LWW	CH14F01,4|AFLIP,M_FLIPH
	LW	CH14F02,4
	LW	CH14F03,4
	LW	CH14F04,4
	LW	CH14F05,4
	LW	CH14F07,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_pump_arm_7
	LWW	CH13F01,4|AFLIP,M_FLIPH
	LW	CH13F02,4
	LW	CH13F03,4
	LW	CH13F04,4
	LW	CH13F05,4
	LW	CH13F08,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_pump_arm_8
	LWW	CH12F01,4|AFLIP,M_FLIPH
	LW	CH12F02,4
	LW	CH12F03,4
	LW	CH12F04,4
	LW	CH12F05,4
	LW	CH12F08,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_pump_arm_m1
	LW	CH11F01,4
	LW	CH11F02,4
	LW	CH11F03,4
	LW	CH11F04,4
	LW	CH11F05,4
	LW	CH11F07,4
	.long	0

anim_pump_arm_m2
	LWW	CH12F01,4|AFLIP,0
	LW	CH12F02,4
	LW	CH12F03,4
	LW	CH12F04,4
	LW	CH12F05,4
	LW	CH12F08,4
	.long	0

anim_pump_arm_m3
	LWW	CH13F01,4|AFLIP,0
	LW	CH13F02,4
	LW	CH13F03,4
	LW	CH13F04,4
	LW	CH13F05,4
	LW	CH13F08,4
	.long	0

anim_pump_arm_m4
	LWW	CH14F01,4|AFLIP,0
	LW	CH14F02,4
	LW	CH14F03,4
	LW	CH14F04,4
	LW	CH14F05,4
	LW	CH14F07,4
	.long	0

anim_pump_arm_m5
	LW	CH15F01,4
	LW	CH15F02,4
	LW	CH15F03,4
	LW	CH15F04,4
	LW	CH15F05,4
	LW	CH15F07,4
	.long	0

anim_pump_arm_m6
	LWW	CH14F01,4|AFLIP,M_FLIPH
	LW	CH14F02,4
	LW	CH14F03,4
	LW	CH14F04,4
	LW	CH14F05,4
	LW	CH14F07,4
	.long	0

anim_pump_arm_m7
	LWW	CH13F01,4|AFLIP,M_FLIPH
	LW	CH13F02,4
	LW	CH13F03,4
	LW	CH13F04,4
	LW	CH13F05,4
	LW	CH13F08,4
	.long	0

anim_pump_arm_m8
	LWW	CH12F01,4|AFLIP,M_FLIPH
	LW	CH12F02,4
	LW	CH12F03,4
	LW	CH12F04,4
	LW	CH12F05,4
	LW	CH12F08,4
	.long	0

anim_toe_run_1
anim_toe_run_5
	LW	CH43F01,5
	LW	CH43F02,5
	LW	CH43F03,5
	LW	CH43F04,5
	LW	CH43F05,5
	LW	CH43F06,5
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_toe_run_2
anim_toe_run_3
anim_toe_run_4
	LWW	CH43F01,5|AFLIP,0
	LW	CH43F02,5
	LW	CH43F03,5
	LW	CH43F04,5
	LW	CH43F05,5
	LW	CH43F06,5
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_toe_run_6
anim_toe_run_7
anim_toe_run_8
	LWW	CH43F01,5|AFLIP,M_FLIPH
	LW	CH43F02,5
	LW	CH43F03,5
	LW	CH43F04,5
	LW	CH43F05,5
	LW	CH43F06,5
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_leap1l_1
anim_leap1l_5
	LW	CH63F01,4
	LWL	1,AFUNC|1,start_j1_grav
	LW	CH63F02,3
	LW	CH63F03,2
	LW	CH63F04,2
	LW	CH63F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH63F05,11
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH63F06,2
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_leap1l_2
anim_leap1l_3
anim_leap1l_4
	LWW	CH63F01,4|AFLIP,0
	LWL	1,AFUNC|1,start_j1_grav
	LW	CH63F02,3
	LW	CH63F03,2
	LW	CH63F04,2
	LW	CH63F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH63F05,11
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH63F06,2
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_leap1l_6
anim_leap1l_7
anim_leap1l_8
	LWW	CH63F01,4|AFLIP,M_FLIPH
	LWL	1,AFUNC|1,start_j1_grav
	LW	CH63F02,3
	LW	CH63F03,2
	LW	CH63F04,2
	LW	CH63F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH63F05,11
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH63F06,2
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_leap1h_1
anim_leap1h_5
	LW	CH63F01,4
	LWL	1,AFUNC|1,start_jh1_grav
	LW	CH63F02,3
	LW	CH63F03,2
	LW	CH63F04,2
	LW	CH63F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH63F05,19
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH63F06,2
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_leap1h_2
anim_leap1h_3
anim_leap1h_4
	LWW	CH63F01,4|AFLIP,0
	LWL	1,AFUNC|1,start_jh1_grav
	LW	CH63F02,3
	LW	CH63F03,2
	LW	CH63F04,2
	LW	CH63F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH63F05,19
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH63F06,2
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_leap1h_6
anim_leap1h_7
anim_leap1h_8
	LWW	CH63F01,4|AFLIP,M_FLIPH
	LWL	1,AFUNC|1,start_jh1_grav
	LW	CH63F02,3
	LW	CH63F03,2
	LW	CH63F04,2
	LW	CH63F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH63F05,19
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH63F06,2
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

start_j1_grav
	movi	0fffa6000h,a0
	move	a0,*a8(OYVEL),L
	movi	[0,07780h],a0
	move	a0,*a8(OYACCEL),W
	rets
start_jh1_grav
	movi	[-7,0],a0
	move	a0,*a8(OYVEL),L
	movi	[0,07530h],a0
	move	a0,*a8(OYACCEL),W
	rets
start_j11_grav
	movi	[0,06000h],a0
	move	a0,*a8(OYACCEL),W
	rets
stop_j1_grav
	clr	a0
	move	a0,*a8(OYACCEL),W
	move	a0,*a8(OYVEL),L
	move	a0,*a8(OYVAL),L
	rets

anim_leap2l_1
anim_leap2l_5
	LW	CH53F01,4
	LWL	1,AFUNC|1,start_j1_grav
	LW	CH53F02,3
	LW	CH53F03,2
	LW	CH53F04,2
	LW	CH53F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH53F05,11
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH53F06,2
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_leap2l_2
anim_leap2l_3
anim_leap2l_4
	LWW	CH53F01,4|AFLIP,0
	LWL	1,AFUNC|1,start_j1_grav
	LW	CH53F02,3
	LW	CH53F03,2
	LW	CH53F04,2
	LW	CH53F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH53F05,11
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH53F06,2
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_leap2l_6
anim_leap2l_7
anim_leap2l_8
	LWW	CH53F01,4|AFLIP,M_FLIPH
	LWL	1,AFUNC|1,start_j1_grav
	LW	CH53F02,3
	LW	CH53F03,2
	LW	CH53F04,2
	LW	CH53F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH53F05,11
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH53F06,2
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_leap2h_1
anim_leap2h_5
	LW	CH53F01,4
	LWL	1,AFUNC|1,start_jh1_grav
	LW	CH53F02,3
	LW	CH53F03,2
	LW	CH53F04,2
	LW	CH53F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH53F05,19
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH53F06,2
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_leap2h_2
anim_leap2h_3
anim_leap2h_4
	LWW	CH53F01,4|AFLIP,0
	LWL	1,AFUNC|1,start_jh1_grav
	LW	CH53F02,3
	LW	CH53F03,2
	LW	CH53F04,2
	LW	CH53F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH53F05,19
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH53F06,2
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_leap2h_6
anim_leap2h_7
anim_leap2h_8
	LWW	CH53F01,4|AFLIP,M_FLIPH
	LWL	1,AFUNC|1,start_jh1_grav
	LW	CH53F02,3
	LW	CH53F03,2
	LW	CH53F04,2
	LW	CH53F05,6
	LWL	1,AFUNC|1,start_j11_grav
	LW	CH53F05,19
	LWL	1,AFUNC|1,stop_j1_grav
	LW	CH53F06,2
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_cspin_1
anim_cspin_5
	LW	CH73F02,4
	LW	CH73F04,4
	LW	CH73F05,4
	LW	CH73F07,4
	LW	CH73F09,4
	LW	CH73F11,4
	LW	CH73F13,4
	LW	CH73F14,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_cspin_2
anim_cspin_3
anim_cspin_4
	LWW	CH73F02,4|AFLIP,0
	LW	CH73F04,4
	LW	CH73F05,4
	LW	CH73F07,4
	LW	CH73F09,4
	LW	CH73F11,4
	LW	CH73F13,4
	LW	CH73F14,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_cspin_6
anim_cspin_7
anim_cspin_8
	LWW	CH73F02,4|AFLIP,M_FLIPH
	LW	CH73F04,4
	LW	CH73F05,4
	LW	CH73F07,4
	LW	CH73F09,4
	LW	CH73F11,4
	LW	CH73F13,4
	LW	CH73F14,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0

anim_cspinm1_1
anim_cspinm1_2
anim_cspinm1_3
anim_cspinm1_4
anim_cspinm1_5
anim_cspinm1_6
anim_cspinm1_7
anim_cspinm1_8
	LWW	CH73F02,4|AFLIP,0
	LW	CH73F04,4
	LW	CH73F05,4
	LW	CH73F07,4
	LW	CH73F09,4
	LW	CH73F11,4
	LW	CH73F13,4
	LW	CH73F14,4
	.long	0
anim_cspinm2_1
anim_cspinm2_2
anim_cspinm2_3
anim_cspinm2_4
anim_cspinm2_5
anim_cspinm2_6
anim_cspinm2_7
anim_cspinm2_8
	LWW	CH73F02,4|AFLIP,M_FLIPH
	LW	CH73F04,4
	LW	CH73F05,4
	LW	CH73F07,4
	LW	CH73F09,4
	LW	CH73F11,4
	LW	CH73F13,4
	LW	CH73F14,4
	.long	0

anim_knee_walk_1
anim_knee_walk_5
	LW	CH23F03,4
	LW	CH23F04,4
	LW	CH23F05,4
	LW	CH23F06,4
	LW	CH23F07,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_knee_walk_2
anim_knee_walk_3
anim_knee_walk_4
	LWW	CH23F03,4|AFLIP,0
	LW	CH23F04,4
	LW	CH23F05,4
	LW	CH23F06,4
	LW	CH23F07,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
anim_knee_walk_6
anim_knee_walk_7
anim_knee_walk_8
	LWW	CH23F03,4|AFLIP,M_FLIPH
	LW	CH23F04,4
	LW	CH23F05,4
	LW	CH23F06,4
	LW	CH23F07,4
	LWL	1,AFUNC|1,a_celebrate_script_done
	.long	0
