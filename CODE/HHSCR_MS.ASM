 	.MLIB	"HHMACS.LIB"
	.FILE	"HHSCR_MS.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhscr_ms.tbl"
	.include	"hhscrmms.tbl"
	.include	"hhscr_ms.e"
	.include	"hhcontrl.g"
	.include	"hhtimer.g"
	.include	"hhgame.g"
	.include	"hhscr_fn.g"
	.include	"hhafunc.g"
	.include	"hhshow.g"
	.include	"hhc.g"
	.include	"hhpuck.g"
	.include	"hhscr_sk.g"
	.include	"hhd.g"
	.include	"hhmath.g"
	.include	"hhplayer.g"
	.include	"hhstable.g"

; end of include files

	.TEXT
	.EVEN

**************************************************************************
*								         *
* do_flash								 *
* 	input	a0 = x pos						 *
* 		a1 = z pos						 *
* 		a2 = y pos						 *
*								         *
**************************************************************************
do_flash
	movi	FLASH_INIT,b0
	mmtm	sp,a0,a1,a2
	calla	EASYMAKE
	mmfm	sp,a0,a1,a2
	move	a0,*a8(OXPOS),W
	move	a1,*a8(OZPOS),W
	move	a2,*a8(OYPOS),W
	rets

FLASH_INIT
	.long	flash1
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT|OM_ANIM
	.word	OID_FLASH
	.long	FLASH_ANIM

FLASH_ANIM
	LW	flash1,3
	LW	flash2,3
	LW	flash1,3
	LWL	1,1|AFUNC,a_delete_obj
	.long	0

set_go_into_faceoff_script
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_REV_FACE,a14
	janz	set_reverse_go_faceoff_script
	movi	sgif_tab-32,a14
	jauc	start_panim_if_not_ta14

sgif_tab
	.long	anim_go_faceoff_script_1
	.long	anim_go_faceoff_script_2
	.long	anim_go_faceoff_script_3
	.long	anim_go_faceoff_script_4
	.long	anim_go_faceoff_script_5
	.long	anim_go_faceoff_script_6
	.long	anim_go_faceoff_script_7
	.long	anim_go_faceoff_script_8


a_set_faceoff_ready_scriptc
	move	*a8(ODT_PBK),a6,L
	calla	give_player_control
a_set_faceoff_ready_script
	move	*a8(ODT_PBK),a6,L
set_faceoff_ready_script
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_REV_FACE,a14
	janz	set_reverse_face_ready_script
	movk	2,a1			;start offset at 2
	move	*a6(POF_TIRED),a14,W
	jrz	ool1
	addk	2,a1			;low turbo: +2
ool1	move	@minutes,a14,W
	jrnz	ool3
	addk	1,a1			;end of period: +1
ool2	move	@period,a14,W
	cmpi	3,a14
	jrnz	ool3
	subk	2,a1			;end of third period: -2
ool3	move	@team1_score,a14,W
	move	@team2_score,a2,W
	sub	a2,a14
	abs	a14
	cmpi	2,a14
	jrhi	ool4
	subk	1,a1			;close score: -1
ool4	move	@minutes,a14,W
	cmpi	2,a14
	jrlo	ool5
	subk	1,a1			;beginning of period: -1
ool5	movb	*a6(POF_NUMBER),a14
	dec	a14
	srl	2,a14
	jrz	oot1
oot2	move	@team1_score,a14,W
	move	@team2_score,a2,W
	sub	a2,a14
	cmpi	5,a14
	jrls	ool6
	addk	2,a1			;losing by a lot: +2
	jruc	ool6
oot1	move	@team2_score,a14,W
	move	@team1_score,a2,W
	sub	a2,a14
	cmpi	5,a14
	jrls	ool6
	addk	2,a1			;losing by a lot: +2
ool6	move	@period,a14,W
	cmpi	4,a14
	jrlo	ool7
	movk	1,a1			;overtime: 1 - always
ool7
oolxx	move	a1,a1
	jrnn	oolx1
	clr	a1
oolx1	cmpi	4,a1
	jrls	oolx2
	movk	4,a1
oolx2	sll	5,a1
	addi	sfr_list,a1
	move	*a1,a14,L
	jump	a14

sfr_list
	.long	set_faceoff_ready1_script
	.long	set_faceoff_ready2_script
	.long	set_faceoff_ready3_script
	.long	set_faceoff_ready4_script
	.long	set_faceoff_ready5_script

set_faceoff_ready1_script
	movi	sfrt1_tab-32,a14
	jauc	start_panim_if_not_ta14

sfrt1_tab
	.long	anim_faceoff_ready1_script_1
	.long	anim_faceoff_ready1_script_2
	.long	anim_faceoff_ready1_script_3
	.long	anim_faceoff_ready1_script_4
	.long	anim_faceoff_ready1_script_5
	.long	anim_faceoff_ready1_script_6
	.long	anim_faceoff_ready1_script_7
	.long	anim_faceoff_ready1_script_8

set_faceoff_ready2_script
	movi	sfrt2_tab-32,a14
	jauc	start_panim_if_not_ta14

sfrt2_tab
	.long	anim_faceoff_ready2_script_1
	.long	anim_faceoff_ready2_script_2
	.long	anim_faceoff_ready2_script_3
	.long	anim_faceoff_ready2_script_4
	.long	anim_faceoff_ready2_script_5
	.long	anim_faceoff_ready2_script_6
	.long	anim_faceoff_ready2_script_7
	.long	anim_faceoff_ready2_script_8

set_faceoff_ready3_script
	movi	sfrt3_tab-32,a14
	jauc	start_panim_if_not_ta14

sfrt3_tab
	.long	anim_faceoff_ready3_script_1
	.long	anim_faceoff_ready3_script_2
	.long	anim_faceoff_ready3_script_3
	.long	anim_faceoff_ready3_script_4
	.long	anim_faceoff_ready3_script_5
	.long	anim_faceoff_ready3_script_6
	.long	anim_faceoff_ready3_script_7
	.long	anim_faceoff_ready3_script_8

set_faceoff_ready4_script
	movi	sfrt4_tab-32,a14
	jauc	start_panim_if_not_ta14

sfrt4_tab
	.long	anim_faceoff_ready4_script_1
	.long	anim_faceoff_ready4_script_2
	.long	anim_faceoff_ready4_script_3
	.long	anim_faceoff_ready4_script_4
	.long	anim_faceoff_ready4_script_5
	.long	anim_faceoff_ready4_script_6
	.long	anim_faceoff_ready4_script_7
	.long	anim_faceoff_ready4_script_8

set_faceoff_ready5_script
	movi	sfrt5_tab-32,a14
	jauc	start_panim_if_not_ta14

sfrt5_tab
	.long	anim_faceoff_ready5_script_1
	.long	anim_faceoff_ready5_script_2
	.long	anim_faceoff_ready5_script_3
	.long	anim_faceoff_ready5_script_4
	.long	anim_faceoff_ready5_script_5
	.long	anim_faceoff_ready5_script_6
	.long	anim_faceoff_ready5_script_7
	.long	anim_faceoff_ready5_script_8

set_faceoff_tap_script
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_REV_FACE,a14
	janz	set_rev_face_tap_script
	movi	sftt_tab-32,a14
	jauc	start_panim_if_not_ta14

sftt_tab
	.long	anim_faceoff_tap_script_1
	.long	anim_faceoff_tap_script_2
	.long	anim_faceoff_tap_script_3
	.long	anim_faceoff_tap_script_4
	.long	anim_faceoff_tap_script_5
	.long	anim_faceoff_tap_script_6
	.long	anim_faceoff_tap_script_7
	.long	anim_faceoff_tap_script_8

set_faceoff_take_back_script
	movi	sftb_tab-32,a14
	jauc	start_panim_if_not_ta14

sftb_tab
	.long	anim_faceoff_take_back_script_1
	.long	anim_faceoff_take_back_script_2
	.long	anim_faceoff_take_back_script_3
	.long	anim_faceoff_take_back_script_4
	.long	anim_faceoff_take_back_script_5
	.long	anim_faceoff_take_back_script_6
	.long	anim_faceoff_take_back_script_7
	.long	anim_faceoff_take_back_script_8

set_face_take_up_back_script
	movi	sftu_tab-32,a14
	jauc	start_panim_if_not_ta14

sftu_tab
	.long	anim_face_take_up_back_script_1
	.long	anim_face_take_up_back_script_2
	.long	anim_face_take_up_back_script_3
	.long	anim_face_take_up_back_script_4
	.long	anim_face_take_up_back_script_5
	.long	anim_face_take_up_back_script_6
	.long	anim_face_take_up_back_script_7
	.long	anim_face_take_up_back_script_8

set_faceoff_take_up_script
	movi	sfru_tab-32,a14
	jauc	start_panim_if_not_ta14

sfru_tab
	.long	anim_faceoff_take_up_script_1
	.long	anim_faceoff_take_up_script_2
	.long	anim_faceoff_take_up_script_3
	.long	anim_faceoff_take_up_script_4
	.long	anim_faceoff_take_up_script_5
	.long	anim_faceoff_take_up_script_6
	.long	anim_faceoff_take_up_script_7
	.long	anim_faceoff_take_up_script_8

set_faceoff_take_down_script
	movi	sfrd_tab-32,a14
	jauc	start_panim_if_not_ta14

sfrd_tab
	.long	anim_faceoff_take_down_script_1
	.long	anim_faceoff_take_down_script_2
	.long	anim_faceoff_take_down_script_3
	.long	anim_faceoff_take_down_script_4
	.long	anim_faceoff_take_down_script_5
	.long	anim_faceoff_take_down_script_6
	.long	anim_faceoff_take_down_script_7
	.long	anim_faceoff_take_down_script_8


set_down_block_script
	callr	point_at_puck
	callr	get_p_point
	jruc	set_udlr1_script

set_down_knees_script
	callr	point_at_puck
	callr	get_point_goal
	jruc	set_udlr2_script

point_at_puck
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	move	@PUCK_OBJECT,a0,L
	move	*a0(OZVAL),a1,L
	move	*a0(OXVAL),a0,L
	calla	find_dir_to_point_18
	movb	a0,*a6(POF_DIRECTION)
	rets

get_p_point
	callr	is_passing
	jrc	get_point_intended
	callr	is_shooting
	jrc	get_point_goal
	jruc	get_point_intended
get_point_intended
	move	@PUCK_INTENDED,a0,W
	jrnz	gpi_pl			;get point of this player
	move	@PUCK_CONTROL,a0,W
	jrz	get_point_goal
	cmpi	4,a0
	jrz	get_point_goal
	cmpi	8,a0
	jrz	get_point_goal
	dec	a0
	xori	1,a0
	inc	a0
gpi_pl	GBLOCK	a0,a0
	move	*a0(POF_OBJECT),a0,L
	move	*a0(OZVAL),a1,L
	move	*a0(OXVAL),a0,L
	rets
get_point_goal
	move	@PUCK_CONTROL,a0,W
	jrnz	gpg_p
	move	@PUCK_INTENDED,a0,W
	jrnz	gpg_p
	move	@PUCK_LAST_CONTROL,a0,W
	jrz	gp_pk		;in doubt, point at puck
gpg_p	dec	a0
	srl	2,a0
	sll	5,a0
	addi	gpn_x,a0
	move	*a0,a0,L
	movi	[339,08000h],a1
	rets
gp_pk	move	@PUCK_OBJECT,a0,L
	move	*a0(OZVAL),a1,L
	move	*a0(OXVAL),a0,L
	rets
gpn_x	.long	[688,0],[-688,0]

is_passing
	move	@PUCK_MODE,a14
	cmpi	PUM_PASS,a14
	jrz	ips_y
	cmpi	PUM_TPASS,a14
	jrz	ips_y
	move	@PUCK_CONTROL,a14,W
	jrz	ips_n
	GBLOCK	a14,a14
	move	*a14(POF_MODE),a14,W
	cmpi	PM_PASS,a14
	jrz	ips_y
ips_n	clrc
	rets
ips_y	setc
	rets

is_shooting
	move	@PUCK_MODE,a14
	cmpi	PUM_SHOT,a14
	jrz	ish_y
	cmpi	PUM_SSHOT,a14
	jrz	ish_y
	move	@PUCK_CONTROL,a14,W
	jrz	ish_n
	GBLOCK	a14,a14
	move	*a14(POF_MODE),a14,W
	cmpi	PM_SHOOT,a14
	jrz	ish_y
	cmpi	PM_ONETIME,a14
	jrz	ish_y
ish_n	clrc
	rets
ish_y	setc
	rets


;	movi	sdbs_tab-32,a14
;	jauc	start_panim_if_not_ta14
;
;sdbs_tab
;	.long	anim_down_block_in_7_face_5
;	.long	anim_down_block_in_8_face_6
;	.long	anim_down_block_in_1_face_3
;	.long	anim_down_block_in_2_face_4
;	.long	anim_down_block_in_3_face_5
;	.long	anim_down_block_in_4_face_6
;	.long	anim_down_block_in_5_face_7
;	.long	anim_down_block_in_6_face_4
;
;set_down_knees_script
;	movi	sdks_tab-32,a14
;	jauc	start_panim_if_not_ta14
;sdks_tab
;	.long	anim_down_knees_1
;	.long	anim_down_knees_2
;	.long	anim_down_knees_3
;	.long	anim_down_knees_4
;	.long	anim_down_knees_5
;	.long	anim_down_knees_6
;	.long	anim_down_knees_7
;	.long	anim_down_knees_8

set_reverse_go_faceoff_script
	movi	srgf_tab-32,a14
	jauc	start_panim_if_not_ta14
srgf_tab
	.long	anim_rev_go_faceoff_1
	.long	anim_rev_go_faceoff_2
	.long	anim_rev_go_faceoff_3
	.long	anim_rev_go_faceoff_4
	.long	anim_rev_go_faceoff_5
	.long	anim_rev_go_faceoff_6
	.long	anim_rev_go_faceoff_7
	.long	anim_rev_go_faceoff_8

set_reverse_face_ready_script
	movi	srfr_tab-32,a14
	jauc	start_panim_if_not_ta14
srfr_tab
	.long	anim_rev_face_ready_1
	.long	anim_rev_face_ready_2
	.long	anim_rev_face_ready_3
	.long	anim_rev_face_ready_4
	.long	anim_rev_face_ready_5
	.long	anim_rev_face_ready_6
	.long	anim_rev_face_ready_7
	.long	anim_rev_face_ready_8

set_rev_face_take_spin_script
	movi	srts_tab-32,a14
	jauc	start_panim_if_not_ta14
srts_tab
	.long	anim_rev_face_spin_1
	.long	anim_rev_face_spin_2
	.long	anim_rev_face_spin_3
	.long	anim_rev_face_spin_4
	.long	anim_rev_face_spin_5
	.long	anim_rev_face_spin_6
	.long	anim_rev_face_spin_7
	.long	anim_rev_face_spin_8

set_rev_face_take_back_script
	movi	srtb_tab-32,a14
	jauc	start_panim_if_not_ta14
srtb_tab
	.long	anim_rev_face_back_1
	.long	anim_rev_face_back_2
	.long	anim_rev_face_back_3
	.long	anim_rev_face_back_4
	.long	anim_rev_face_back_5
	.long	anim_rev_face_back_6
	.long	anim_rev_face_back_7
	.long	anim_rev_face_back_8

set_rev_face_tap_script
	movi	srtp_tab-32,a14
	jauc	start_panim_if_not_ta14
srtp_tab
	.long	anim_rev_face_tap_1
	.long	anim_rev_face_tap_2
	.long	anim_rev_face_tap_3
	.long	anim_rev_face_tap_4
	.long	anim_rev_face_tap_5
	.long	anim_rev_face_tap_6
	.long	anim_rev_face_tap_7
	.long	anim_rev_face_tap_8

;temporaries

	.if	BILL

	.def	ARROW_INIT

ARROW_INIT
	.long	arrow
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT|OM_ANIM
	.word	OID_JUNK
	.long	ARROW_UPDATE_ANIM

ARROW_UPDATE
	MOVE	*A8(ODATA),A9,L
	MOVE	*A9(OXVAL),*A8(OXVAL),L
	MOVE	*A9(OYVAL),*A8(OYVAL),L
	MOVE	*A9(OZVAL),A14,L
	SUBI	ZWRAP,A14
	MOVE	A14,*A8(OZVAL),L
	RETS

ARROW_UPDATE_ANIM
	LWL	1,1|AFUNC,ARROW_UPDATE
	.long	0

	.endif

anim_go_faceoff_script_1
;	LW	FO11F01,5
;	LW	FO11F02,5
;	LW	FO11F03,5
;	LW	FO11F04,5
;	LW	FO11F05,5
;	LWL	1,AFUNC|11,a_set_faceoff_ready_script
;	.long	0
anim_go_faceoff_script_2
	LWW	FO12F02,AFLIP|5,0
	LW	FO12F04,5
	LW	FO12F06,5
	LW	FO12F08,5
	LW	FO12F10,5
	LWL	1,AFUNC|11,a_set_faceoff_ready_script
	.long	0
anim_go_faceoff_script_3
	LWW	FO13F01,AFLIP|5,0
	LW	FO13F02,5
	LW	FO13F04,5
	LW	FO13F06,5
	LW	FO13F08,5
	LWL	1,AFUNC|11,a_set_faceoff_ready_script
	.long	0
anim_go_faceoff_script_5
anim_go_faceoff_script_4
	LWW	FO14F01,AFLIP|5,0
	LW	FO14F03,5
	LW	FO14F04,5
	LW	FO14F05,5
	LW	FO14F06,5
	LWL	1,AFUNC|11,a_set_faceoff_ready_script
	.long	0
;anim_go_faceoff_script_5
;	LW	FO15F01,5
;	LW	FO15F03,5
;	LW	FO15F04,5
;	LW	FO15F05,5
;	LW	FO15F06,5
;	LWL	1,AFUNC|11,a_set_faceoff_ready_script
;	.long	0
anim_go_faceoff_script_6
	LWW	FO14F01,AFLIP|5,M_FLIPH
	LW	FO14F03,5
	LW	FO14F04,5
	LW	FO14F05,5
	LW	FO14F06,5
	LWL	1,AFUNC|11,a_set_faceoff_ready_script
	.long	0
anim_go_faceoff_script_7
	LWW	FO13F01,AFLIP|5,M_FLIPH
	LW	FO13F02,5
	LW	FO13F04,5
	LW	FO13F06,5
	LW	FO13F08,5
	LWL	1,AFUNC|11,a_set_faceoff_ready_script
	.long	0
anim_go_faceoff_script_8
	LWW	FO12F02,AFLIP|5,M_FLIPH
	LW	FO12F04,5
	LW	FO12F06,5
	LW	FO12F08,5
	LW	FO12F10,5
	LWL	1,AFUNC|11,a_set_faceoff_ready_script
	.long	0


anim_faceoff_ready5_script_1
	LW	FO11F08,13
	LW	FO11F09,10
	LW	FO11F10,13
	LW	FO11F09,10
	.long	0
anim_faceoff_ready4_script_1
	LW	FO11F08,9
	LW	FO11F09,8
	LW	FO11F10,9
	LW	FO11F09,8
	.long	0
anim_faceoff_ready3_script_1
	LW	FO11F08,7
	LW	FO11F09,6
	LW	FO11F10,7
	LW	FO11F09,6
	.long	0
anim_faceoff_ready2_script_1
	LW	FO11F08,4
	LW	FO11F09,3
	LW	FO11F10,4
	LW	FO11F09,3
	.long	0
anim_faceoff_ready1_script_1
	LW	FO11F08,3
	LW	FO11F09,3
	LW	FO11F10,3
	LW	FO11F09,3
	.long	0

anim_faceoff_ready5_script_2
	LWW	FO12F13,AFLIP|13,0
	LW	FO12F14,10
	LW	FO12F15,13
	LW	FO12F14,10
	.long	0
anim_faceoff_ready4_script_2
	LWW	FO12F13,AFLIP|9,0
	LW	FO12F14,8
	LW	FO12F15,9
	LW	FO12F14,8
	.long	0
anim_faceoff_ready3_script_2
	LWW	FO12F13,AFLIP|7,0
	LW	FO12F14,6
	LW	FO12F15,7
	LW	FO12F14,6
	.long	0
anim_faceoff_ready2_script_2
	LWW	FO12F13,AFLIP|4,0
	LW	FO12F14,3
	LW	FO12F15,3
	LW	FO12F14,4
	.long	0
anim_faceoff_ready1_script_2
	LWW	FO12F13,AFLIP|3,0
	LW	FO12F14,3
	LW	FO12F15,3
	LW	FO12F14,3
	.long	0

;	LWW	FO22F01,AFLIP|3,0
;	LW	FO22F03,3
;	LW	FO22F05,3
;	.long	0

anim_faceoff_ready5_script_3
	LWW	FO13F12,AFLIP|7,0	;tired
	LW	FO13F13,7
	LW	FO13F14,7
	LW	FO13F15,7
	LW	FO13F14,7
	LW	FO13F13,7
	.long	0

;	LWW	FO53F10,AFLIP|13,0	;VERY tired
;	LW	FO53F11,10
;	LW	FO53F12,13
;	LW	FO53F11,10
;	.long	0
anim_faceoff_ready4_script_3
	LWW	FO13F12,AFLIP|7,0	;tired
	LW	FO13F13,6
	LW	FO13F14,6
	LW	FO13F15,7
	LW	FO13F14,6
	LW	FO13F13,6
	.long	0

;	LWW	FO53F10,AFLIP|9,0	;VERY tired
;	LW	FO53F11,8
;	LW	FO53F12,9
;	LW	FO53F11,8
;	.long	0
anim_faceoff_ready3_script_3
	LWW	FO13F12,AFLIP|6,0	;tired
	LW	FO13F13,5
	LW	FO13F14,5
	LW	FO13F15,6
	LW	FO13F14,5
	LW	FO13F13,5
	.long	0
anim_faceoff_ready2_script_3
	LWW	FO13F12,AFLIP|4,0	;tired
	LW	FO13F13,4
	LW	FO13F14,4
	LW	FO13F15,4
	LW	FO13F14,4
	LW	FO13F13,4
	.long	0

;	LWW	FP13F01,AFLIP|4,0
;	LW	FP13F02,4
;	LW	FP13F03,4
;	LW	FP13F02,4
;	.long	0

;	LWW	FO13F12,AFLIP|3,0	;alert
;	LW	FO13F13,3
;	LW	FO13F14,3
;	LW	FO13F15,3
;	LW	FO13F14,3
;	LW	FO13F13,3
;	.long	0
anim_faceoff_ready1_script_3
	LWW	FO13F12,AFLIP|3,0	;tired
	LW	FO13F13,3
	LW	FO13F14,3
	LW	FO13F15,3
	LW	FO13F14,3
	LW	FO13F13,3
	.long	0

;	LWW	FO33F04,AFLIP|3,0	;hyper
;	LW	FO33F06,3
;	LW	FO33F08,3
;	.long	0

anim_faceoff_ready5_script_4
	LWW	FO14F08,AFLIP|13,0
	LW	FO14F09,10
	LW	FO14F10,13
	LW	FO14F09,10
	.long	0

anim_faceoff_ready4_script_4
	LWW	FO14F08,AFLIP|9,0
	LW	FO14F09,8
	LW	FO14F10,9
	LW	FO14F09,8
	.long	0

anim_faceoff_ready3_script_4
	LWW	FI14F01,AFLIP|7,0
	LW	FI14F03,6
	LW	FI14F04,7
	LW	FI14F03,6
	.long	0

anim_faceoff_ready2_script_4
	LWW	FI14F01,AFLIP|4,0
	LW	FI14F03,3
	LW	FI14F04,4
	LW	FI14F03,3
	.long	0

anim_faceoff_ready1_script_4
	LWW	FI14F01,AFLIP|3,0
	LW	FI14F03,3
	LW	FI14F04,3
	LW	FI14F03,3
	.long	0


anim_faceoff_ready5_script_5
	LW	FO15F09,13
	LW	FO15F10,10
	LW	FO15F11,13
	LW	FO15F10,10
	.long	0
anim_faceoff_ready4_script_5
	LW	FO15F09,9
	LW	FO15F10,8
	LW	FO15F11,9
	LW	FO15F10,8
	.long	0
anim_faceoff_ready3_script_5
	LW	FO15F09,7
	LW	FO15F10,6
	LW	FO15F11,7
	LW	FO15F10,6
	.long	0
anim_faceoff_ready2_script_5
	LW	FO15F09,4
	LW	FO15F10,3
	LW	FO15F11,4
	LW	FO15F10,3
	.long	0
anim_faceoff_ready1_script_5
	LW	FO15F09,3
	LW	FO15F10,3
	LW	FO15F11,3
	LW	FO15F10,3
	.long	0

anim_faceoff_ready5_script_6
	LWW	FO14F08,AFLIP|13,M_FLIPH
	LW	FO14F09,10
	LW	FO14F10,13
	LW	FO14F09,10
	.long	0

anim_faceoff_ready4_script_6
	LWW	FO14F08,AFLIP|9,M_FLIPH
	LW	FO14F09,8
	LW	FO14F10,9
	LW	FO14F09,8
	.long	0

anim_faceoff_ready3_script_6
	LWW	FI14F01,AFLIP|7,M_FLIPH
	LW	FI14F03,6
	LW	FI14F04,7
	LW	FI14F03,6
	.long	0

anim_faceoff_ready2_script_6
	LWW	FI14F01,AFLIP|4,M_FLIPH
	LW	FI14F03,3
	LW	FI14F04,4
	LW	FI14F03,3
	.long	0

anim_faceoff_ready1_script_6
	LWW	FI14F01,AFLIP|3,M_FLIPH
	LW	FI14F03,3
	LW	FI14F04,3
	LW	FI14F03,3
	.long	0

anim_faceoff_ready5_script_7
	LWW	FO13F12,AFLIP|7,M_FLIPH	;tired
	LW	FO13F13,7
	LW	FO13F14,7
	LW	FO13F15,7
	LW	FO13F14,7
	LW	FO13F13,7
	.long	0
;	LWW	FO53F10,AFLIP|13,M_FLIPH	;VERY tired
;	LW	FO53F11,10
;	LW	FO53F12,13
;	LW	FO53F11,10
;	.long	0
anim_faceoff_ready4_script_7
	LWW	FO13F12,AFLIP|7,M_FLIPH	;tired
	LW	FO13F13,6
	LW	FO13F14,6
	LW	FO13F15,7
	LW	FO13F14,6
	LW	FO13F13,6
	.long	0
;	LWW	FO53F10,AFLIP|9,M_FLIPH		;VERY tired
;	LW	FO53F11,8
;	LW	FO53F12,9
;	LW	FO53F11,8
;	.long	0
anim_faceoff_ready3_script_7
	LWW	FO13F12,AFLIP|6,M_FLIPH	;tired
	LW	FO13F13,5
	LW	FO13F14,5
	LW	FO13F15,6
	LW	FO13F14,5
	LW	FO13F13,5
	.long	0
anim_faceoff_ready2_script_7
	LWW	FO13F12,AFLIP|4,M_FLIPH	;tired
	LW	FO13F13,4
	LW	FO13F14,4
	LW	FO13F15,4
	LW	FO13F14,4
	LW	FO13F13,4
	.long	0

;	LWW	FP13F01,AFLIP|4,M_FLIPH
;	LW	FP13F02,4
;	LW	FP13F03,4
;	LW	FP13F02,4
;	.long	0
;	LWW	FO13F12,AFLIP|3,M_FLIPH	;alert
;	LW	FO13F13,3
;	LW	FO13F14,3
;	LW	FO13F15,3
;	LW	FO13F14,3
;	LW	FO13F13,3
;	.long	0
anim_faceoff_ready1_script_7
	LWW	FO13F12,AFLIP|3,M_FLIPH	;tired
	LW	FO13F13,3
	LW	FO13F14,3
	LW	FO13F15,3
	LW	FO13F14,3
	LW	FO13F13,3
	.long	0
;	LWW	FO33F04,AFLIP|3,M_FLIPH	;hyper
;	LW	FO33F06,3
;	LW	FO33F08,3
;	.long	0

anim_faceoff_ready5_script_8
	LWW	FO12F13,AFLIP|13,M_FLIPH
	LW	FO12F14,10
	LW	FO12F15,13
	LW	FO12F14,10
	.long	0
anim_faceoff_ready4_script_8
	LWW	FO12F13,AFLIP|9,M_FLIPH
	LW	FO12F14,8
	LW	FO12F15,9
	LW	FO12F14,8
	.long	0
anim_faceoff_ready3_script_8
	LWW	FO12F13,AFLIP|7,M_FLIPH
	LW	FO12F14,6
	LW	FO12F15,7
	LW	FO12F14,6
	.long	0
anim_faceoff_ready2_script_8
	LWW	FO12F13,AFLIP|4,M_FLIPH
	LW	FO12F14,3
	LW	FO12F15,3
	LW	FO12F14,4
	.long	0
anim_faceoff_ready1_script_8
	LWW	FO12F13,AFLIP|3,M_FLIPH
	LW	FO12F14,3
	LW	FO12F15,3
	LW	FO12F14,3
	.long	0

;	LWW	FO22F01,AFLIP|3,M_FLIPH
;	LW	FO22F03,3
;	LW	FO22F05,3
;	.long	0

anim_faceoff_tap_script_1
anim_faceoff_tap_script_5
	LW	FO43F01,3
	LW	FO43F03,3
	LW	FO43F04,3
	LW	FO43F05,2
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FO43F06,3
	LW	FO43F07,3
	LWL	1,AFUNC|11,a_set_faceoff_ready_scriptc
	.long	0
anim_faceoff_tap_script_2
anim_faceoff_tap_script_3
anim_faceoff_tap_script_4
	LWW	FO43F01,AFLIP|3,0
	LW	FO43F03,3
	LW	FO43F04,3
	LW	FO43F05,2
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FO43F06,3
	LW	FO43F07,3
	LWL	1,AFUNC|11,a_set_faceoff_ready_scriptc
	.long	0
anim_faceoff_tap_script_6
anim_faceoff_tap_script_7
anim_faceoff_tap_script_8
	LWW	FO43F01,AFLIP|3,M_FLIPH
	LW	FO43F03,3
	LW	FO43F04,3
	LW	FO43F05,2
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FO43F06,3
	LW	FO43F07,3
	LWL	1,AFUNC|11,a_set_faceoff_ready_scriptc
	.long	0

anim_faceoff_take_back_script_1
anim_faceoff_take_back_script_5
	LW	FO43F01,3
	LW	FO43F03,3
	LW	FO43F04,3
	LW	FO43F05,2
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FO43F06,3
	LW	FO43F07,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_faceoff_take_back_script_2
anim_faceoff_take_back_script_3
anim_faceoff_take_back_script_4
	LWW	FO43F01,AFLIP|3,0
	LW	FO43F03,3
	LW	FO43F04,3
	LW	FO43F05,2
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FO43F06,3
	LW	FO43F07,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_faceoff_take_back_script_6
anim_faceoff_take_back_script_7
anim_faceoff_take_back_script_8
	LWW	FO43F01,AFLIP|3,M_FLIPH
	LW	FO43F03,3
	LW	FO43F04,3
	LW	FO43F05,2
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FO43F06,3
	LW	FO43F07,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_face_take_up_back_script_1
anim_face_take_up_back_script_5
	LW	FO23F02,2
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FO23F03,3
	LW	FO23F04,3
	LW	FO23F07,3
	LW	FO23F08,3
	LW	FO23F10,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_face_take_up_back_script_2
anim_face_take_up_back_script_3
anim_face_take_up_back_script_4
	LWW	FO23F02,AFLIP|2,0
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FO23F03,3
	LW	FO23F04,3
	LW	FO23F07,3
	LW	FO23F08,3
	LW	FO23F10,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_face_take_up_back_script_6
anim_face_take_up_back_script_7
anim_face_take_up_back_script_8
	LWW	FO23F02,AFLIP|2,M_FLIPH
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FO23F03,3
	LW	FO23F04,3
	LW	FO23F07,3
	LW	FO23F08,3
	LW	FO23F10,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_faceoff_take_up_script_1
anim_faceoff_take_up_script_5
	LW	FP13F11,2
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FP13F12,3
	LW	FP13F13,6
	LW	FP13F14,6
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_faceoff_take_up_script_2
anim_faceoff_take_up_script_3
anim_faceoff_take_up_script_4
	LWW	FP13F11,AFLIP|2,0
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FP13F12,3
	LW	FP13F13,6
	LW	FP13F14,6
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_faceoff_take_up_script_6
anim_faceoff_take_up_script_7
anim_faceoff_take_up_script_8
	LWW	FP13F11,AFLIP|2,M_FLIPH
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FP13F12,3
	LW	FP13F13,6
	LW	FP13F14,6
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_faceoff_take_down_script_1
anim_faceoff_take_down_script_5
	LW	FP23F05,2
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FP23F06,3
	LW	FP23F08,3
	LW	FP23F09,6
	LW	FP23F10,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_faceoff_take_down_script_2
anim_faceoff_take_down_script_3
anim_faceoff_take_down_script_4
	LWW	FP23F05,AFLIP|2,0
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FP23F06,3
	LW	FP23F08,3
	LW	FP23F09,6
	LW	FP23F10,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_faceoff_take_down_script_6
anim_faceoff_take_down_script_7
anim_faceoff_take_down_script_8
	LWW	FP23F05,AFLIP|2,M_FLIPH
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FP23F06,3
	LW	FP23F08,3
	LW	FP23F09,6
	LW	FP23F10,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0


**************************************************************************
*								         *
* set_udlr1_script - down in 1 knee to block				 *
* 	input	a0 = x position to point to (goal, receiver, etc.)	 *
* 		a1 = z position to point to (goal, receiver, etc.)	 *
* 		POF_DIRECTION = set to point to puck			 *
* 	output	script in player set					 *
*								         *
**************************************************************************
set_udlr1_script
	callr	udxsub1
	addi	udlrp1t,a0
	jruc	udxsub2

**************************************************************************
*								         *
* set_udlr2_script - down in 2 knees to block				 *
* 	input	a0 = x position to point to (goal, receiver, etc.)	 *
* 		a1 = z position to point to (goal, receiver, etc.)	 *
* 		POF_DIRECTION = set to point to puck			 *
* 	output	script in player set					 *
*								         *
**************************************************************************
set_udlr2_script
	callr	udxsub1
	addi	udlrp2t,a0
	jruc	udxsub2

udxsub1	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point
	move	a0,a2
	calla	dir_to_1357
	dec	a0		;0,2,4,6
	sll	4,a0		;0,32,64,96
	rets

udxsub2	move	*a0,a0,L
	movb	*a6(POF_DIRECTION),a14
	dec	a14
	sll	5,a14
	add	a14,a0
	move	*a0,a0,L
	jump	a0

udlrp1t	.long	down1_down
	.long	down1_right
	.long	down1_up
	.long	down1_left

udlrp2t	.long	down2_down
	.long	down2_right
	.long	down2_up
	.long	down2_left

down1_up
	.long	st_anim_2k_1_pick
	.long	st_anim_1k_3_5
	.long	st_anim_1k_3_5
	.long	st_anim_1k_4_6
	.long	st_anim_1k_5_pick
	.long	st_anim_1k_6_4
	.long	st_anim_1k_7_5
	.long	st_anim_1k_7_5

down1_right
	.long	st_anim_2k_1_3
	.long	st_anim_1k_3_5
	.long	st_anim_1k_3_pick
	.long	st_anim_1k_4_2
	.long	st_anim_1k_5_3
	.long	st_anim_1k_6_4
	.long	st_anim_1k_7_pick
	.long	st_anim_2k_8_2

down1_down
	.long	st_anim_2k_1_pick
	.long	st_anim_2k_2_8
	.long	st_anim_1k_3_1
	.long	st_anim_1k_4_2
	.long	st_anim_1k_5_pick
	.long	st_anim_1k_6_8
	.long	st_anim_1k_7_1
	.long	st_anim_2k_8_2

down1_left
	.long	st_anim_2k_1_7
	.long	st_anim_2k_2_8
	.long	st_anim_1k_3_pick
	.long	st_anim_1k_4_6
	.long	st_anim_1k_5_7
	.long	st_anim_1k_6_8
	.long	st_anim_1k_7_pick
	.long	st_anim_1k_7_5

down2_up	;4 5 6
	.long	st_anim_2k_1_pick
	.long	st_anim_1k_3_5
	.long	st_anim_1k_3_5
	.long	st_anim_1k_4_6
	.long	st_anim_2k_5_pick
	.long	st_anim_1k_6_4
	.long	st_anim_1k_7_5
	.long	st_anim_1k_7_5

down2_right	;2 3 4
	.long	st_anim_2k_1_3
	.long	st_anim_1k_3_5
	.long	st_anim_2k_3_pick ;(1k for 5)
	.long	st_anim_2k_4_2
	.long	st_anim_2k_5_3
	.long	st_anim_1k_6_4
	.long	st_anim_2k_7_pick ;(1k for 5)
	.long	st_anim_2k_8_2

down2_down	;8 1 2
	.long	st_anim_2k_1_pick
	.long	st_anim_2k_2_8
	.long	st_anim_2k_3_1
	.long	st_anim_2k_4_2
	.long	st_anim_2k_5_pick
	.long	st_anim_2k_6_8
	.long	st_anim_2k_7_1
	.long	st_anim_2k_8_2

down2_left	;6 7 8
	.long	st_anim_2k_1_7
	.long	st_anim_2k_2_8
	.long	st_anim_2k_3_pick ;(1k for 5)
	.long	st_anim_2k_4_2
	.long	st_anim_2k_5_7
	.long	st_anim_2k_6_8
	.long	st_anim_2k_7_pick ;(1k for 5)
	.long	st_anim_1k_7_5

st_anim_1k_3_1
	movi	anim_1k_3_1,a1
	jruc	st_a12k_go

st_anim_1k_3_5
	movi	anim_1k_3_5,a1
	jruc	st_a12k_go

st_anim_1k_3_pick
	movi	anim_1k_3_1,a1
	cmpi	XD1800,a2
	jrhs	st_a12k_go
	movi	anim_1k_3_5,a1
	jruc	st_a12k_go

st_anim_1k_4_2
	movi	anim_1k_4_2,a1
	jruc	st_a12k_go

st_anim_1k_4_6
	movi	anim_1k_4_6,a1
	jruc	st_a12k_go

st_anim_1k_5_3
	movi	anim_1k_5_3,a1
	jruc	st_a12k_go

st_anim_1k_5_7
	movi	anim_1k_5_7,a1
	jruc	st_a12k_go

st_anim_1k_5_pick
	movi	anim_1k_5_3,a1
	cmpi	XD0900,a2
	jrls	st_a12k_go
	cmpi	XD2700,a2
	jrhs	st_a12k_go
	movi	anim_1k_5_7,a1
	jruc	st_a12k_go

st_anim_1k_6_4
	movi	anim_1k_6_4,a1
	jruc	st_a12k_go

st_anim_1k_6_8
	movi	anim_1k_6_8,a1
	jruc	st_a12k_go

st_anim_1k_7_1
	movi	anim_1k_7_1,a1
	jruc	st_a12k_go

st_anim_1k_7_5
	movi	anim_1k_7_5,a1
	jruc	st_a12k_go

st_anim_1k_7_pick
	movi	anim_1k_7_1,a1
	cmpi	XD1800,a2
	jrhs	st_a12k_go
	movi	anim_1k_7_5,a1
	jruc	st_a12k_go

st_anim_2k_1_3
	movi	anim_2k_1_3,a1
	jruc	st_a12k_go

st_anim_2k_1_7
	movi	anim_2k_1_7,a1
	jruc	st_a12k_go

st_anim_2k_1_pick
	movi	anim_2k_1_3,a1
	cmpi	XD0900,a2
	jrls	st_a12k_go
	cmpi	XD2700,a2
	jrhs	st_a12k_go
	movi	anim_2k_1_7,a1
	jruc	st_a12k_go

st_anim_2k_2_8
	movi	anim_2k_2_8,a1
	jruc	st_a12k_go

st_anim_2k_3_1
	movi	anim_2k_3_1,a1
	jruc	st_a12k_go

st_anim_2k_3_pick	;(1k for 5)
	movi	anim_2k_3_1,a1
	cmpi	XD1800,a2
	jrhs	st_a12k_go
	movi	anim_1k_3_5,a1
	jruc	st_a12k_go

st_anim_2k_4_2
	movi	anim_2k_4_2,a1
	jruc	st_a12k_go

st_anim_2k_5_3
	movi	anim_2k_5_3,a1
	jruc	st_a12k_go

st_anim_2k_5_7
	movi	anim_2k_5_7,a1
	jruc	st_a12k_go

st_anim_2k_5_pick
	movi	anim_2k_5_3,a1
	cmpi	XD0900,a2
	jrls	st_a12k_go
	cmpi	XD2700,a2
	jrhs	st_a12k_go
	movi	anim_2k_5_7,a1
	jruc	st_a12k_go

st_anim_2k_6_8
	movi	anim_2k_6_8,a1
	jruc	st_a12k_go

st_anim_2k_7_1
	movi	anim_2k_7_1,a1
	jruc	st_a12k_go

st_anim_2k_7_pick	;(1k for 5)
	movi	anim_2k_7_1,a1
	cmpi	XD1800,a2
	jrhs	st_a12k_go
	movi	anim_1k_7_5,a1
	jruc	st_a12k_go

st_anim_2k_8_2
	movi	anim_2k_8_2,a1
st_a12k_go
	jauc	start_panim_if_not


anim_1k_3_1
	LWW	BK11F02,AFLIP|3,0
	LW	BK11F04,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
koh1	LWL	BK11F06,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[50,37],[74,13]
	.long	 a_dec_or_lshoot,koh1
	LW	BK11F04,3
	LW	BK11F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_1k_3_5
	LWW	BK15F03,AFLIP|3,M_FLIPH
	LW	BK15F05,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
koh2	LWL	BK15F06,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[45,16],[15,20]
	.long	 a_dec_or_lshoot,koh2
	LW	BK15F05,3
	LW	BK15F03,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_1k_4_2
	LWW	BK12F02,AFLIP|3,0
	LW	BK12F04,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
koh3	LWL	BK12F06,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[54,46],[75,83]
	.long	 a_dec_or_lshoot,koh3
	LW	BK12F04,3
	LW	BK12F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_1k_4_6
	LWW	BK14F02,AFLIP|3,M_FLIPH
	LW	BK14F04,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
koh4	LWL	BK14F06,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[41,71],[45,131]
	.long	 a_dec_or_lshoot,koh4
	LW	BK14F04,3
	LW	BK14F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_1k_5_3
	LWW	BK13F02,AFLIP|3,0
	LW	BK13F04,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
koh5	LWL	BK13F07,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[47,97],[57,157]
	.long	 a_dec_or_lshoot,koh5
	LW	BK13F04,3
	LW	BK13F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_1k_5_7
	LWW	BK13F02,AFLIP|3,M_FLIPH
	LW	BK13F04,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
koh6	LWL	BK13F07,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[47,97],[57,157]
	.long	 a_dec_or_lshoot,koh6
	LW	BK13F04,3
	LW	BK13F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_1k_6_4
	LWW	BK14F02,AFLIP|3,0
	LW	BK14F04,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
koh7	LWL	BK14F06,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[41,71],[45,131]
	.long	 a_dec_or_lshoot,koh7
	LW	BK14F04,3
	LW	BK14F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_1k_6_8
	LWW	BK12F02,AFLIP|3,M_FLIPH
	LW	BK12F04,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
koh8	LWL	BK12F06,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[54,46],[75,83]
	.long	 a_dec_or_lshoot,koh8
	LW	BK12F04,3
	LW	BK12F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_1k_7_5
	LWW	BK15F03,AFLIP|3,0
	LW	BK15F05,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
koh9	LWL	BK15F06,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[45,16],[15,20]
	.long	 a_dec_or_lshoot,koh9
	LW	BK15F05,3
	LW	BK15F03,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_1k_7_1
	LWW	BK11F02,AFLIP|3,M_FLIPH
	LW	BK11F04,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
koha	LWL	BK11F06,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[50,37],[74,13]
	.long	 a_dec_or_lshoot,koha
	LW	BK11F04,3
	LW	BK11F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_2k_1_7
	LWW	BK21F03,AFLIP|3,0
	LW	BK21F04,2
 	LWL	 1,AFUNC|1,a_down_on_knees_show
	LW	BK21F05,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
kohb	LWL	BK21F06,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[54,15],[47,82]
	.long	 a_dec_or_lshoot,kohb
	LW	BK21F05,3
	LW	BK21F04,3
	LW	BK21F03,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_2k_1_3
	LWW	BK21F03,AFLIP|3,M_FLIPH
	LW	BK21F04,2
 	LWL	 1,AFUNC|1,a_down_on_knees_show
	LW	BK21F05,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
kohc	LWL	BK21F06,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[54,15],[47,82]
	.long	 a_dec_or_lshoot,kohc
	LW	BK21F05,3
	LW	BK21F04,3
	LW	BK21F03,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_2k_2_8
	LWW	BK22F04,AFLIP|3,0
	LW	BK22F05,2
 	LWL	 1,AFUNC|1,a_down_on_knees_show
	LW	BK22F06,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
kohd	LWL	BK22F07,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[72,23],[53,69]
	.long	 a_dec_or_lshoot,kohd
	LW	BK22F06,3
	LW	BK22F05,3
	LW	BK22F04,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_2k_3_1
	LWW	BK23F02,AFLIP|3,0
	LW	BK23F03,2
 	LWL	 1,AFUNC|1,a_down_on_knees_show
	LW	BK23F04,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
kohe	LWL	BK23F05,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[51,51],[70,77]
	.long	 a_dec_or_lshoot,kohe
	LW	BK23F04,3
	LW	BK23F03,3
	LW	BK23F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_2k_4_2
	LWW	BK24F04,AFLIP|3,0
	LW	BK24F05,2
 	LWL	 1,AFUNC|1,a_down_on_knees_show
	LW	BK24F06,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
kohf	LWL	BK24F07,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[45,55],[68,121]
	.long	 a_dec_or_lshoot,kohf
	LW	BK24F06,3
	LW	BK24F05,3
	LW	BK24F04,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_2k_5_3
	LWW	BK25F03,AFLIP|3,0
	LW	BK25F04,2
 	LWL	 1,AFUNC|1,a_down_on_knees_show
	LW	BK25F05,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
kohg	LWL	BK25F06,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[43,47],[52,106]
	.long	 a_dec_or_lshoot,kohg
	LW	BK25F05,3
	LW	BK25F04,3
	LW	BK25F03,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_2k_5_7
	LWW	BK25F03,AFLIP|3,M_FLIPH
	LW	BK25F04,2
 	LWL	 1,AFUNC|1,a_down_on_knees_show
	LW	BK25F05,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
kohh	LWL	BK25F06,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[43,47],[52,106]
	.long	 a_dec_or_lshoot,kohh
	LW	BK25F05,3
	LW	BK25F04,3
	LW	BK25F03,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_2k_6_8
	LWW	BK24F04,AFLIP|3,M_FLIPH
	LW	BK24F05,2
 	LWL	 1,AFUNC|1,a_down_on_knees_show
	LW	BK24F06,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
kohi	LWL	BK24F07,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[45,55],[68,121]
	.long	 a_dec_or_lshoot,kohi
	LW	BK24F06,3
	LW	BK24F05,3
	LW	BK24F04,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_2k_7_1
	LWW	BK23F02,AFLIP|3,M_FLIPH
	LW	BK23F03,2
 	LWL	 1,AFUNC|1,a_down_on_knees_show
	LW	BK23F04,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
kohj	LWL	BK23F05,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[51,51],[70,77]
	.long	 a_dec_or_lshoot,kohj
	LW	BK23F04,3
	LW	BK23F03,3
	LW	BK23F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_2k_8_2
	LWW	BK22F04,AFLIP|3,M_FLIPH
	LW	BK22F05,2
 	LWL	 1,AFUNC|1,a_down_on_knees_show
	LW	BK22F06,2
	LWLW	 1,AFUNC|1,a_set_loopc+1,120
kohk	LWL	BK22F07,AFUNC|1,A_3FUNCS+12
	.long	 a_slow_object_down
	.long	 a_check_puck_cross,[72,23],[53,69]
	.long	 a_dec_or_lshoot,kohk
	LW	BK22F06,3
	LW	BK22F05,3
	LW	BK22F04,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

;-----------------------------------------------------------------------------
;anim_down_block_in_1_face_3
;	LWW	BK11F02,AFLIP|3,0
;	LW	BK11F04,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adb13	LWL	BK11F06,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[50,37],[74,13]
;	.long	 a_dec_or_lshoot,adb13
;	LW	BK11F04,3
;	LW	BK11F02,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;anim_down_block_in_2_face_4
;	LWW	BK12F02,AFLIP|3,0
;	LW	BK12F04,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adb24	LWL	BK12F06,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[54,46],[75,83]
;	.long	 a_dec_or_lshoot,adb24
;	LW	BK12F04,3
;	LW	BK12F02,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;anim_down_block_in_3_face_5
;	LWW	BK13F02,AFLIP|3,0
;	LW	BK13F04,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adb35	LWL	BK13F07,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[47,97],[57,157]
;	.long	 a_dec_or_lshoot,adb35
;	LW	BK13F04,3
;	LW	BK13F02,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;anim_down_block_in_4_face_6
;	LWW	BK14F02,AFLIP|3,0
;	LW	BK14F04,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adb46	LWL	BK14F06,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[41,71],[45,131]
;	.long	 a_dec_or_lshoot,adb46
;	LW	BK14F04,3
;	LW	BK14F02,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;anim_down_block_in_5_face_7
;	LWW	BK15F03,AFLIP|3,0
;	LW	BK15F05,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adb57	LWL	BK15F06,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[45,16],[15,20]
;	.long	 a_dec_or_lshoot,adb57
;	LW	BK15F05,3
;	LW	BK15F03,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;anim_down_block_in_6_face_4
;	LWW	BK14F02,AFLIP|3,M_FLIPH
;	LW	BK14F04,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adb64	LWL	BK14F06,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[41,71],[45,131]
;	.long	 a_dec_or_lshoot,adb64
;	LW	BK14F04,3
;	LW	BK14F02,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;anim_down_block_in_7_face_5
;	LWW	BK13F02,AFLIP|3,M_FLIPH
;	LW	BK13F04,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adb75	LWL	BK13F07,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[47,97],[57,157]
;	.long	 a_dec_or_lshoot,adb75
;	LW	BK13F04,3
;	LW	BK13F02,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;anim_down_block_in_8_face_6
;	LWW	BK12F02,AFLIP|3,M_FLIPH
;	LW	BK12F04,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adb86	LWL	BK12F06,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[54,46],[75,83]
;	.long	 a_dec_or_lshoot,adb86
;	LW	BK12F04,3
;	LW	BK12F02,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;

a_slow_object_down
	jauc	slow_object_down


;anim_down_knees_1
;	LWW	BK21F03,AFLIP|3,0
;	LW	BK21F04,2
;	LWL	 1,AFUNC|1,a_down_on_knees_show
;	LW	BK21F05,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adkn1	LWL	BK21F06,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[54,15],[47,82]
;	.long	 a_dec_or_lshoot,adkn1
;	LW	BK21F05,3
;	LW	BK21F04,3
;	LW	BK21F03,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_down_knees_2
;	LWW	BK22F04,AFLIP|3,0
;	LW	BK22F05,2
;	LWL	 1,AFUNC|1,a_down_on_knees_show
;	LW	BK22F06,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adkn2	LWL	BK22F07,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[72,23],[53,69]
;	.long	 a_dec_or_lshoot,adkn2
;	LW	BK22F06,3
;	LW	BK22F05,3
;	LW	BK22F04,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_down_knees_3
;	LWW	BK23F02,AFLIP|3,0
;	LW	BK23F03,2
;	LWL	 1,AFUNC|1,a_down_on_knees_show
;	LW	BK23F04,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adkn3	LWL	BK23F05,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[51,51],[70,77]
;	.long	 a_dec_or_lshoot,adkn3
;	LW	BK23F04,3
;	LW	BK23F03,3
;	LW	BK23F02,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_down_knees_4
;	LWW	BK24F04,AFLIP|3,0
;	LW	BK24F05,2
;	LWL	 1,AFUNC|1,a_down_on_knees_show
;	LW	BK24F06,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adkn4	LWL	BK24F07,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[45,55],[68,121]
;	.long	 a_dec_or_lshoot,adkn4
;	LW	BK24F06,3
;	LW	BK24F05,3
;	LW	BK24F04,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_down_knees_5
;	LWW	BK25F03,AFLIP|3,0
;	LW	BK25F04,2
;	LWL	 1,AFUNC|1,a_down_on_knees_show
;	LW	BK25F05,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adkn5	LWL	BK25F06,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[43,47],[52,106]
;	.long	 a_dec_or_lshoot,adkn5
;	LW	BK25F05,3
;	LW	BK25F04,3
;	LW	BK25F03,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_down_knees_6
;	LWW	BK24F04,AFLIP|3,M_FLIPH
;	LW	BK24F05,2
;	LWL	 1,AFUNC|1,a_down_on_knees_show
;	LW	BK24F06,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adkn6	LWL	BK24F07,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[45,55],[68,121]
;	.long	 a_dec_or_lshoot,adkn6
;	LW	BK24F06,3
;	LW	BK24F05,3
;	LW	BK24F04,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_down_knees_7
;	LWW	BK23F02,AFLIP|3,M_FLIPH
;	LW	BK23F03,2
;	LWL	 1,AFUNC|1,a_down_on_knees_show
;	LW	BK23F04,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adkn7	LWL	BK23F05,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[51,51],[70,77]
;	.long	 a_dec_or_lshoot,adkn7
;	LW	BK23F04,3
;	LW	BK23F03,3
;	LW	BK23F02,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_down_knees_8
;	LWW	BK22F04,AFLIP|3,M_FLIPH
;	LW	BK22F05,2
;	LWL	 1,AFUNC|1,a_down_on_knees_show
;	LW	BK22F06,2
;	LWLW	 1,AFUNC|1,a_set_loopc+1,120
;adkn8	LWL	BK22F07,AFUNC|1,A_3FUNCS+12
;	.long	 a_slow_object_down
;	.long	 a_check_puck_cross,[72,23],[53,69]
;	.long	 a_dec_or_lshoot,adkn8
;	LW	BK22F06,3
;	LW	BK22F05,3
;	LW	BK22F04,3
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0

a_down_on_knees_show
	jauc	down_on_knees_show
anim_rev_go_faceoff_1
anim_rev_go_faceoff_5
	LW	FP53F01,5
	LW	FP53F03,5
	LW	FP53F05,6
	LW	FP53F06,6
	LW	FP53F07,6
	LWL	1,AFUNC|11,a_set_faceoff_ready_script
	.long	0

anim_rev_go_faceoff_2
anim_rev_go_faceoff_3
anim_rev_go_faceoff_4
	LWW	FP53F01,AFLIP|5,0
	LW	FP53F03,5
	LW	FP53F05,6
	LW	FP53F06,6
	LW	FP53F07,6
	LWL	1,AFUNC|11,a_set_faceoff_ready_script
	.long	0

anim_rev_go_faceoff_6
anim_rev_go_faceoff_7
anim_rev_go_faceoff_8
	LWW	FP53F01,AFLIP|5,M_FLIPH
	LW	FP53F03,5
	LW	FP53F05,6
	LW	FP53F06,6
	LW	FP53F07,6
	LWL	1,AFUNC|11,a_set_faceoff_ready_script
	.long	0

anim_rev_face_ready_1
anim_rev_face_ready_5
	LW	FP53F10,9
	LW	FP53F11,8
	LW	FP53F12,9
	LW	FP53F11,8
	.long	0

anim_rev_face_ready_2
anim_rev_face_ready_3
anim_rev_face_ready_4
	LWW	FP53F10,AFLIP|9,0
	LW	FP53F11,8
	LW	FP53F12,9
	LW	FP53F11,8
	.long	0

anim_rev_face_ready_6
anim_rev_face_ready_7
anim_rev_face_ready_8
	LWW	FP53F10,AFLIP|9,M_FLIPH
	LW	FP53F11,8
	LW	FP53F12,9
	LW	FP53F11,8
	.long	0

anim_rev_face_spin_1
anim_rev_face_spin_5
	LW	FP33F02,3
	LW	FP33F04,3
	LW	FP33F06,3
	LW	FP33F07,3
	LW	FP33F08,2
	LW	FP33F09,2
	LW	FP33F12,2
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_rev_face_spin_2
anim_rev_face_spin_3
anim_rev_face_spin_4
	LWW	FP33F02,AFLIP|3,0
	LW	FP33F04,3
	LW	FP33F06,3
	LW	FP33F07,3
	LW	FP33F08,2
	LW	FP33F09,2
	LW	FP33F12,2
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_rev_face_spin_6
anim_rev_face_spin_7
anim_rev_face_spin_8
	LWW	FP33F02,AFLIP|3,M_FLIPH
	LW	FP33F04,3
	LW	FP33F06,3
	LW	FP33F07,3
	LW	FP33F08,2
	LW	FP33F09,2
	LW	FP33F12,2
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_rev_face_back_1
anim_rev_face_back_5
	LW	FP43F06,4
	LW	FP43F08,6
	LW	FP43F09,4
	LW	FP43F10,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_rev_face_back_2
anim_rev_face_back_3
anim_rev_face_back_4
	LW	FP43F06,AFLIP|4,0
	LW	FP43F08,6
	LW	FP43F09,4
	LW	FP43F10,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_rev_face_back_6
anim_rev_face_back_7
anim_rev_face_back_8
	LWW	FP43F06,AFLIP|4,M_FLIPH
	LW	FP43F08,6
	LW	FP43F09,4
	LW	FP43F10,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_rev_face_tap_1
anim_rev_face_tap_5
	LW	FP43F06,3
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FP43F08,4
	LW	FP43F06,3
	LWL	1,AFUNC|11,a_set_faceoff_ready_scriptc
	.long	0

anim_rev_face_tap_2
anim_rev_face_tap_3
anim_rev_face_tap_4
	LW	FP43F06,AFLIP|3,0
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FP43F08,4
	LW	FP43F06,3
	LWL	1,AFUNC|11,a_set_faceoff_ready_scriptc
	.long	0

anim_rev_face_tap_6
anim_rev_face_tap_7
anim_rev_face_tap_8
	LWW	FP43F06,AFLIP|3,M_FLIPH
	LWL	1,AFUNC|1,faceoff_tap_show
	LW	FP43F08,4
	LW	FP43F06,3
	LWL	1,AFUNC|11,a_set_faceoff_ready_scriptc
	.long	0

start_head_script
	movi	anim_head,a1
	jauc	start_anim_if_not

nul_script				;for players who need a script because they are on a different list
	LW	1,10
	.long	0

anim_head
	LWL	1,AFUNC|1,a_head_animate
	.long	0

scale_body_to_pct
	mmtm	sp,a1,a2,a3,a5,a8
	callr	scbpc
	move	*a1,a1,W
	move	a1,*a8(ODT_SC_XSCALE),W
	move	*a8(OPARTS),a8,L
	jrz	sbtp1
	callr	scbpc
sbtp1	mmfm	sp,a1,a2,a3,a5,a8
	rets

scbpc	move	*a8(OSCTAB),a1,L
	move	*a8(OZPOS),a14,W
	srl	2,a14		;new osctab
	sll	5,a14
	add	a1,a14
	move	*a14+,a3,W
	move	a3,a2
	mpys	a0,a3
	sra	8,a3
	move	*a14,a5,W
	mpys	a0,a5
	sll	16-8,a5
	movx	a3,a5
	move	a5,*a8(ODT_SC_OVERRIDE),L
	rets

a_head_animate
	move	*a8(OPART1),a7,L	;a7 is object of body
	move	*a7(OFLAGS),a6,W
	btst	B_OFSCRN,a6
	jrnz	aha_7
	move	*a7(ODT_PBK),a6,L	;a6 is player block
	move	*a7(OIMG),a10,L		;a10 is image data
	move	*a10(IANIOFFX),a14,W	;animation point of image (x)
	move	*a10(ICHEADX),a3,W		;animation point of head (x)
	sub	a14,a3			;a3 is x animation point
	move	*a7(ODT_SC_XSCALE),a1,W
	jrz	ahasf
	sll	8,a3
	divs	a1,a3
	move	a3,a2			;a2 = scaled x animation point
	move	*a10(IANIOFFY),a14,W	;animation point of image (y)
	move	*a10(ICHEADY),a3,W		;animation point of head (y)
	sub	a14,a3			;a3 is y animation point
	move	*a7(ODT_SC_OVERRIDE+010h),a1,W
	jruc	aha_sg

ahasf	move	*a7(OSCTAB),a0,L
	move	*a0,a1,W		;a1 is x scale at full image (base world scale for body)
	sll	8,a3
	divs	a1,a3
	move	a3,a2			;a2 = scaled x animation point
	move	*a10(IANIOFFY),a14,W	;animation point of image (y)
	move	*a10(ICHEADY),a3,W		;animation point of head (y)
	sub	a14,a3			;a3 is y animation point
	move	*a7(OZPOS),a1,W		;index into table from z
	srl	2,a1		;new osctab
	sll	5,a1
	add	a0,a1
	move	*a1(010h),a1,W		;a1 = y scale at z image (y coordinates do not scale on their own)
aha_sg	sll	8,a3
	divs	a1,a3			;a3 = scaled y animation point
	move	*a7(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
	move	*a7(OYPOS),a1,W
	move	*a7(OCTRL),a4,W		;new octrl = octrl from head
	btst	B_FLIPH,a4
	jrz	aha_1
	neg	a2
aha_1	add	a2,a0
	add	a3,a1
	move	a0,*a8(OXPOS),W		;store x
	move	a1,*a8(OYPOS),W		;store y
	move	*a7(OZVAL),a0,L
	move	*a10(ICHEADZ),a14,W	;z offset
	add	a14,a0
	move	a0,*a8(OZVAL),L
	move	*a10(ICHEADN),a0,W		;head #
	sll	6,a0
	move	*a6(POF_HEAD_TABLE),a14,L
	add	a0,a14
	move	*a14+,a1,L		;new image pointer
	move	*a14,a14,W		;flip bits for image
	xor	a14,a4			;xored with image flips
	movi	BOGUS_SCL,a14
	move	a14,*a8(OSCALE),L
	move	*a7(OXVEL),*a8(OXVEL),L
	move	*a7(OYVEL),*a8(OYVEL),L
	move	*a7(OZVEL),*a8(OZVEL),L
	jauc	maybe_ani
aha_7	move	*a7(OXPOS),*a8(OXPOS),W
	move	*a7(OYPOS),*a8(OYPOS),W
	move	*a7(OZPOS),*a8(OZPOS),W
aha_9	rets


a_create_spray_r
	movi	sprlsl-32,a2
	jruc	acs1
a_create_spray
	movi	spslsl-32,a2
acs1	move	a8,a7
	movi	spray_init,b0
	calla	EASYMAKE
	move	*a7(ODT_PBK),a6,L
	movb	*a6(POF_DIRECTION),a1
	sll	5,a1
	add	a2,a1
	move	*a1,a1,L
	CALLA	STRT_ANIM
	move	a7,*a8(ODT_POBJ),L
	move	*a7(ANIMSCR),*a8(ODT_PANIMSCR),L
	move	a8,a9
	move	a7,a8
	rets

spray_init
	.long	SPRAY1m1
	.word	DMAWNZ,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_SPRAY
	.long	[-1000,0],[0,0],[0,0]

sprlsl	.long	spray_script_5
	.long	spray_script_6
	.long	spray_script_7
	.long	spray_script_8
spslsl	.long	spray_script_1
	.long	spray_script_2
	.long	spray_script_3
	.long	spray_script_4
	.long	spray_script_5
	.long	spray_script_6
	.long	spray_script_7
	.long	spray_script_8

spray_script_1
	LWL	SPRAY1m1,AFUNC|1,a_spray_animate
	LWL	SPRAY1m2,AFUNC|1,a_spray_animate
	LWL	SPRAY1m1,AFUNC|1,a_spray_animate
	LWL	SPRAY1m2,AFUNC|1,a_spray_animate
	LWL	SPRAY1m1,AFUNC|1,a_spray_animate
	LWL	SPRAY1m2,AFUNC|1,a_spray_animate
	LW	SPRAY1m3,3
	LW	SPRAY1m4,3
	LW	SPRAY1m5,3
	LWL	1,AFUNC|1,a_delete_obj
	.long	0

spray_script_2
	LWL	SPRAY2m1,AFUNC|1,a_spray_animate
	LWL	SPRAY2m2,AFUNC|1,a_spray_animate
	LWL	SPRAY2m1,AFUNC|1,a_spray_animate
	LWL	SPRAY2m2,AFUNC|1,a_spray_animate
	LWL	SPRAY2m1,AFUNC|1,a_spray_animate
	LWL	SPRAY2m2,AFUNC|1,a_spray_animate
	LW	SPRAY2m3,3
	LW	SPRAY2m4,3
	LW	SPRAY2m5,3
	LWL	1,AFUNC|1,a_delete_obj
	.long	0

spray_script_3
	LWL	SPRAY3m1,AFUNC|1,a_spray_animate
	LWL	SPRAY3m2,AFUNC|1,a_spray_animate
	LWL	SPRAY3m1,AFUNC|1,a_spray_animate
	LWL	SPRAY3m2,AFUNC|1,a_spray_animate
	LWL	SPRAY3m1,AFUNC|1,a_spray_animate
	LWL	SPRAY3m2,AFUNC|1,a_spray_animate
	LW	SPRAY3m3,3
	LW	SPRAY3m4,3
	LW	SPRAY3m5,3
	LWL	1,AFUNC|1,a_delete_obj
	.long	0

spray_script_4
	LWL	SPRAY4m1,AFUNC|1,a_spray_animate
	LWL	SPRAY4m2,AFUNC|1,a_spray_animate
	LWL	SPRAY4m1,AFUNC|1,a_spray_animate
	LWL	SPRAY4m2,AFUNC|1,a_spray_animate
	LWL	SPRAY4m1,AFUNC|1,a_spray_animate
	LWL	SPRAY4m2,AFUNC|1,a_spray_animate
	LW	SPRAY4m3,3
	LW	SPRAY4m4,3
	LW	SPRAY4m5,3
	LWL	1,AFUNC|1,a_delete_obj
	.long	0

spray_script_5
	LWL	SPRAY5m1,AFUNC|1,a_spray_animate
	LWL	SPRAY5m2,AFUNC|1,a_spray_animate
	LWL	SPRAY5m1,AFUNC|1,a_spray_animate
	LWL	SPRAY5m2,AFUNC|1,a_spray_animate
	LWL	SPRAY5m1,AFUNC|1,a_spray_animate
	LWL	SPRAY5m2,AFUNC|1,a_spray_animate
	LW	SPRAY5m3,3
	LW	SPRAY5m4,3
	LW	SPRAY5m5,3
	LWL	1,AFUNC|1,a_delete_obj
	.long	0

spray_script_6
	LWWL	SPRAY4m1,AFUNC|AFLIP|1,M_FLIPH,a_spray_animate
	LWL	SPRAY4m2,AFUNC|1,a_spray_animate
	LWL	SPRAY4m1,AFUNC|1,a_spray_animate
	LWL	SPRAY4m2,AFUNC|1,a_spray_animate
	LWL	SPRAY4m1,AFUNC|1,a_spray_animate
	LWL	SPRAY4m2,AFUNC|1,a_spray_animate
	LW	SPRAY4m3,3
	LW	SPRAY4m4,3
	LW	SPRAY4m5,3
	LWL	1,AFUNC|1,a_delete_obj
	.long	0

spray_script_7
	LWWL	SPRAY3m1,AFUNC|AFLIP|1,M_FLIPH,a_spray_animate
	LWL	SPRAY3m2,AFUNC|1,a_spray_animate
	LWL	SPRAY3m1,AFUNC|1,a_spray_animate
	LWL	SPRAY3m2,AFUNC|1,a_spray_animate
	LWL	SPRAY3m1,AFUNC|1,a_spray_animate
	LWL	SPRAY3m2,AFUNC|1,a_spray_animate
	LW	SPRAY3m3,3
	LW	SPRAY3m4,3
	LW	SPRAY3m5,3
	LWL	1,AFUNC|1,a_delete_obj
	.long	0

spray_script_8
	LWWL	SPRAY2m1,AFUNC|AFLIP|1,M_FLIPH,a_spray_animate
	LWL	SPRAY2m2,AFUNC|1,a_spray_animate
	LWL	SPRAY2m1,AFUNC|1,a_spray_animate
	LWL	SPRAY2m2,AFUNC|1,a_spray_animate
	LWL	SPRAY2m1,AFUNC|1,a_spray_animate
	LWL	SPRAY2m2,AFUNC|1,a_spray_animate
	LW	SPRAY2m3,3
	LW	SPRAY2m4,3
	LW	SPRAY2m5,3
	LWL	1,AFUNC|1,a_delete_obj
	.long	0

a_spray_animate
	move	*a8(ODT_POBJ),a7,L	;a7 is object of body
	move	*a8(ODT_PANIMSCR),a14,L
	move	*a7(ANIMSCR),a6,L
	cmp	a6,a14			;does players script match what we want
	jrnz	asa_d			;script has changed, no longer attach to player
	move	*a7(OFLAGS),a6,W
	btst	B_OFSCRN,a6
	jrnz	sha_7
	move	*a7(ODT_PBK),a6,L	;a6 is player block
	move	*a7(OIMG),a10,L		;a10 is image data
	move	*a10(IANIOFFX),a14,W	;animation point of image (x)
	move	*a10(ICSPRAYX),a3,W		;animation point of head (x)
	sub	a14,a3			;a3 is x animation point
	move	*a7(OSCTAB),a0,L
	move	*a0,a1,W		;a1 is x scale at full image (base world scale for body)
	sll	8,a3
	divs	a1,a3
	move	a3,a2			;a2 = scaled x animation point
	move	*a10(IANIOFFY),a14,W	;animation point of image (y)
	move	*a10(ICSPRAYY),a3,W		;animation point of head (y)
	sub	a14,a3			;a3 is y animation point
	move	*a7(OZPOS),a1,W		;index into table from z
	srl	2,a1		;new osctab
	sll	5,a1
	add	a0,a1
	move	*a1(ISIZEX),a1,W		;a1 = y scale at z image (y coordinates do not scale on their own)
	sll	8,a3
	divs	a1,a3			;a3 = scaled y animation point
	move	*a7(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
	move	*a7(OYPOS),a1,W
	move	*a7(OCTRL),a4,W		;test octrl from body
	btst	B_FLIPH,a4
	jrz	sha_1
	neg	a2
sha_1	add	a2,a0
	add	a3,a1
	move	a0,*a8(OXPOS),W		;store x
	move	a1,*a8(OYPOS),W		;store y
	move	*a7(OZVAL),a0,L
	move	*a10(ICSPRAYZ),a14,W	;z offset
	add	a14,a0
	move	a0,*a8(OZVAL),L
	move	*a7(OXVEL),*a8(OXVEL),L
	move	*a7(OYVEL),*a8(OYVEL),L
	move	*a7(OZVEL),*a8(OZVEL),L
	rets
sha_7	move	*a7(OXPOS),*a8(OXPOS),W
	move	*a7(OYPOS),*a8(OYPOS),W
	move	*a7(OZPOS),*a8(OZPOS),W
asa_d	rets
