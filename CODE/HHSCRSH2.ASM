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
	.include	"hhscr_sh.tbl"
	.include	"hhscrmsh.tbl"
	.include	"nextras1.tbl"
	.include	"nextras2.tbl"
	.include	"hhscrsh2.e"
	.include	"hhscr_fn.g"
	.include	"hhscr_sh.g"
	.include	"hhcontrl.g"
	.include	"hhpuck.g"
	.include	"hhmath.g"
	.include	"hhscr_ms.g"
	.include	"hhshow.g"
	.include	"hhgame.g"
	.include	"hhscr_sk.g"
	.include	"hhplayer.g"

; end of include files

	.TEXT
	.EVEN

anim_sommersault_shot_1
anim_sommersault_shot_5
	LWL	SA13F01,AFUNC|2,a_set_release_est_r+3
	WL	 56,a_set_15_flip
	LWL	SA13F02,AFUNC|3,a_no_shoot_button
	LW	SA13F03,3
	LW	SA13F05,3
	LW	SA13F06,5

	LWL	SS43F03,AFUNC|2,a_setv_vs
	LW	SS43F05,2
	LW	SS43F06,2
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LW	SS43F10,2

	LW	SS43F03,2
	LW	SS43F05,2
	LW	SS43F06,2
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LW	SS43F10,2

	LW	SS43F03,2
	LW	SS43F05,2
	LW	SS43F06,2
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LWL	SS43F10,AFUNC|2,a_clear_fb
	LWL	SA13F11,AFUNC|8,a_tshoot_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_sommersault_shot_2
anim_sommersault_shot_3
anim_sommersault_shot_4
	LWWL	SA13F01,AFUNC|AFLIP|2,0,a_set_release_est+1
	.word	 56
	LWL	SA13F02,AFUNC|3,a_no_shoot_button
	LW	SA13F03,3
	LW	SA13F05,3
	LW	SA13F06,5

	LWL	SS43F03,AFUNC|2,a_setv_vs
	LW	SS43F05,2
	LW	SS43F06,2
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LW	SS43F10,2

	LW	SS43F03,2
	LW	SS43F05,2
	LW	SS43F06,2
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LW	SS43F10,2

	LW	SS43F03,2
	LW	SS43F05,2
	LW	SS43F06,2
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LWL	SS43F10,AFUNC|2,a_clear_fb
	LWL	SA13F11,AFUNC|8,a_tshoot_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_sommersault_shot_6
anim_sommersault_shot_7
anim_sommersault_shot_8
	LWWL	SA13F01,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est+1
	.word	 56
	LWL	SA13F02,AFUNC|3,a_no_shoot_button
	LW	SA13F03,3
	LW	SA13F05,3
	LW	SA13F06,5

	LWL	SS43F03,AFUNC|2,a_setv_vs
	LW	SS43F05,2
	LW	SS43F06,2
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LW	SS43F10,2

	LW	SS43F03,2
	LW	SS43F05,2
	LW	SS43F06,2
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LW	SS43F10,2

	LW	SS43F03,2
	LW	SS43F05,2
	LW	SS43F06,2
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LWL	SS43F10,AFUNC|2,a_clear_fb
	LWL	SA13F11,AFUNC|8,a_tshoot_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0


anim_up_down_shot_1
anim_up_down_shot_2
anim_up_down_shot_3
anim_up_down_shot_4
	LWWL	TS13F08,AFUNC|AFLIP|2,0,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F01,AFUNC|3,a_spinv_v
	LWL	TS13F02,AFUNC|2,a_whoosh_sound
	LW	TS13F03,3
	LW	TS13F04,2
	LW	TS13F05,2
	LW	TS13F06,2
	LW	TS13F07,1
	LW	TS13F08,2
	LWL	TS13F01,AFUNC|1,a_whoosh_sound
	LW	TS13F02,2
	LW	TS13F03,1
	LW	TS13F04,2
	LW	TS13F05,1
	LW	TS13F06,1
	LW	TS13F07,1
	LW	TS13F08,1
	LWL	TS13F01,AFUNC|1,a_whoosh_sound
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,1
	LW	TS13F07,1
	LW	TS13F08,1
	LWL	TS13F01,AFUNC|1,a_whoosh_sound
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,1
	LWL	TS13F07,AFUNC|1,a_whoosh_sound
	LWL	TS13F08,AFUNC|1,a_tshoot_done_1
	LW	TS13F01,1
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,2
	LW	TS13F07,1
	LW	TS13F08,2
	LW	TS13F01,1
	LW	TS13F02,2
	LW	TS13F03,2
	LW	TS13F04,2
	LW	TS13F05,3
	LW	TS13F06,2
	LWL	TS13F07,3|AFUNC,a_clear_fb
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_up_down_shot_5
anim_up_down_shot_6
anim_up_down_shot_7
anim_up_down_shot_8
	LWWL	TS13F08,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F01,AFUNC|3,a_spinv_v
	LWL	TS13F02,AFUNC|2,a_whoosh_sound
	LW	TS13F03,3
	LW	TS13F04,2
	LW	TS13F05,2
	LW	TS13F06,2
	LW	TS13F07,1
	LW	TS13F08,2
	LWL	TS13F01,AFUNC|1,a_whoosh_sound
	LW	TS13F02,2
	LW	TS13F03,1
	LW	TS13F04,2
	LW	TS13F05,1
	LW	TS13F06,1
	LW	TS13F07,1
	LW	TS13F08,1
	LWL	TS13F01,AFUNC|1,a_whoosh_sound
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,1
	LW	TS13F07,1
	LW	TS13F08,1
	LWL	TS13F01,AFUNC|1,a_whoosh_sound
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,1
	LWL	TS13F07,AFUNC|1,a_whoosh_sound
	LWL	TS13F08,AFUNC|1,a_tshoot_done_1
	LW	TS13F01,1
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,2
	LW	TS13F07,1
	LW	TS13F08,2
	LW	TS13F01,1
	LW	TS13F02,2
	LW	TS13F03,2
	LW	TS13F04,2
	LW	TS13F05,3
	LW	TS13F06,2
	LWL	TS13F07,3|AFUNC,a_clear_fb
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

a_spinv_v
	move	@PUCK_OBJECT,a9,L
	move	*a9(ODT_PFLAGS),a0,W
	ori	M_INFRONT,a0
	move	a0,*a9(ODT_PFLAGS),W
	movi	-08f000h,a0
	move	a0,*a8(OYVEL),L
	movi	[0,08100h],a0
	move	a0,*a8(OYACCEL),L

	move	*a8(OXVEL),a14,L
	sra	1,a14
	move	a14,*a8(OXVEL),L
	move	*a8(ODT_REALXVEL),a14,L
	sra	1,a14
	move	a14,*a8(ODT_REALXVEL),L
	move	*a8(OZVEL),a14,L
	sra	1,a14
	move	a14,*a8(OZVEL),L
	move	*a8(ODT_VEL),a14,L
	sra	1,a14
	move	a14,*a8(ODT_VEL),L
	rets

a_setv_vs
	move	@PUCK_OBJECT,a9,L
	move	*a9(ODT_PFLAGS),a0,W
	ori	M_INFRONT,a0
	move	a0,*a9(ODT_PFLAGS),W
	movi	-0a8000h,a0
	move	a0,*a8(OYVEL),L
	movi	[0,08100h],a0
	move	a0,*a8(OYACCEL),L

	move	*a8(OXVEL),a14,L
	sra	1,a14
	move	a14,*a8(OXVEL),L
	move	*a8(ODT_REALXVEL),a14,L
	sra	1,a14
	move	a14,*a8(ODT_REALXVEL),L
	move	*a8(OZVEL),a14,L
	sra	1,a14
	move	a14,*a8(OZVEL),L
	move	*a8(ODT_VEL),a14,L
	sra	1,a14
	move	a14,*a8(ODT_VEL),L
	rets

a_clear_fb
	move	@PUCK_OBJECT,a9,L
	move	*a9(ODT_PFLAGS),a0,W
	andni	M_INFRONT|M_INBACK,a0
	move	a0,*a9(ODT_PFLAGS),W
	rets

anim_wrist_shot_1
anim_wrist_shot_5
	LWL	SB13F04,3|AFUNC,a_set_release_est_r+3
	WL	13,a_set_15_flip
	LW	SB13F05,3
	LW	SB13F06,3
	LWL	SB13F07,AFUNC|3,a_safety_shot_check_1
	LW	SB13F08,1
	LWL	1,AFUNC|8,a_wrist_shot_done_1
	LW	SB13F02,2
	LWL	1,AFUNC|1,a_wrist_shot_done_2
	.long	0

anim_wrist_shot_2
anim_wrist_shot_3
anim_wrist_shot_4
	LWWL	SB13F04,AFUNC|AFLIP|3,0,a_set_release_est+1
	.word	13
	LW	SB13F05,3
	LW	SB13F06,3
	LWL	SB13F07,AFUNC|3,a_safety_shot_check_1
	LW	SB13F08,1
	LWL	1,AFUNC|8,a_wrist_shot_done_1
	LW	SB13F02,2
	LWL	1,AFUNC|1,a_wrist_shot_done_2
	.long	0

anim_wrist_shot_6
anim_wrist_shot_7
anim_wrist_shot_8
	LWWL	SB13F04,AFUNC|AFLIP|3,M_FLIPH,a_set_release_est+1
	.word	13
	LW	SB13F05,3
	LW	SB13F06,3
	LWL	SB13F07,AFUNC|3,a_safety_shot_check_1
	LW	SB13F08,1
	LWL	1,AFUNC|8,a_wrist_shot_done_1
	LW	SB13F02,2
	LWL	1,AFUNC|1,a_wrist_shot_done_2
	.long	0

a_wrist_shot_done_1
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	shoot_script_done_1
a_wrist_shot_done_2
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	shoot_script_done_2

anim_spin_around_slap_1
anim_spin_around_slap_5
	LWL	SD13F04,4|AFUNC,a_set_release_est_r+3
	WL	18,a_set_15_flip
	LW	SD13F07,4
	LWL	SD13F08,AFUNC|4,a_no_shoot_button
	LW	SD13F10,3
	LW	SD13F12,3
	LWL	SD13F14,AFUNC|3,a_tshoot_done_1
	LW	SD13F15,10
	LW	SD13F18,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_spin_around_slap_2
anim_spin_around_slap_3
anim_spin_around_slap_4
	LWWL	SD13F04,AFUNC|AFLIP|4,0,a_set_release_est+1
	.word	18
	LW	SD13F07,4
	LWL	SD13F08,AFUNC|4,a_no_shoot_button
	LW	SD13F10,3
	LW	SD13F12,3
	LWL	SD13F14,AFUNC|3,a_tshoot_done_1
	LW	SD13F15,10
	LW	SD13F18,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_spin_around_slap_6
anim_spin_around_slap_7
anim_spin_around_slap_8
	LWWL	SD13F04,AFUNC|AFLIP|4,M_FLIPH,a_set_release_est+1
	.word	18
	LW	SD13F07,4
	LWL	SD13F08,AFUNC|4,a_no_shoot_button
	LW	SD13F10,3
	LW	SD13F12,3
	LWL	SD13F14,AFUNC|3,a_tshoot_done_1
	LW	SD13F15,10
	LW	SD13F18,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_turbo_backhand_1
anim_turbo_backhand_5
	LWL	SC13F02,4|AFUNC,a_set_release_est_r+3
	WL	12,a_set_15_flip
	LWL	SC13F03,AFUNC|3,a_no_shoot_button
	LWL	SC13F04,AFUNC|4,a_safety_shot_check_1
	LW	SC13F05,1
	LWL	1,AFUNC|2,a_tshoot_done_1
	LW	SC13F06,3
	LW	SC13F07,3
	LW	SC13F08,8
	LW	SC13F09,3
	LW	SC13F10,2
	LW	SC13F11,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_turbo_backhand_2
anim_turbo_backhand_3
anim_turbo_backhand_4
	LWWL	SC13F02,AFUNC|AFLIP|4,0,a_set_release_est+1
	.word	12
	LWL	SC13F03,AFUNC|3,a_no_shoot_button
	LWL	SC13F04,AFUNC|4,a_safety_shot_check_1
	LW	SC13F05,1
	LWL	1,AFUNC|2,a_tshoot_done_1
	LW	SC13F06,3
	LW	SC13F07,3
	LW	SC13F08,8
	LW	SC13F09,3
	LW	SC13F10,2
	LW	SC13F11,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_turbo_backhand_6
anim_turbo_backhand_7
anim_turbo_backhand_8
	LWWL	SC13F02,AFUNC|AFLIP|4,M_FLIPH,a_set_release_est+1
	.word	12
	LWL	SC13F03,AFUNC|3,a_no_shoot_button
	LWL	SC13F04,AFUNC|4,a_safety_shot_check_1
	LW	SC13F05,1
	LWL	1,AFUNC|2,a_tshoot_done_1
	LW	SC13F06,3
	LW	SC13F07,3
	LW	SC13F08,8
	LW	SC13F09,3
	LW	SC13F10,2
	LW	SC13F11,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_pool_cue_script_1
anim_pool_cue_script_5
	LWL	SE13F01,AFUNC|3,a_set_release_est_r+3
	WL	24,a_flip_no_shoot_button
	LW	SE13F03,3
	LW	SE13F04,3
	LW	SE13F05,3
	LW	SE13F06,3
	LW	SE13F07,5
	LW	SE13F09,2
	LW	SE13F10,2
	LWL	SE13F11,AFUNC|6,a_tshoot_done_1
	LW	SE13F12,3
	LW	SE13F13,3
	LW	SE13F15,2
	LW	SE13F16,3
	LW	SE13F17,2
	LW	SE13F18,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_pool_cue_script_2
anim_pool_cue_script_3
anim_pool_cue_script_4
	LWWL	SE13F01,AFUNC|AFLIP|3,0,a_set_release_est_r+3
	WL	24,a_no_shoot_button
	LW	SE13F03,3
	LW	SE13F04,3
	LW	SE13F05,3
	LW	SE13F06,3
	LW	SE13F07,5
	LW	SE13F09,2
	LW	SE13F10,2
	LWL	SE13F11,AFUNC|6,a_tshoot_done_1
	LW	SE13F12,3
	LW	SE13F13,3
	LW	SE13F15,2
	LW	SE13F16,3
	LW	SE13F17,2
	LW	SE13F18,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_pool_cue_script_6
anim_pool_cue_script_7
anim_pool_cue_script_8
	LWWL	SE13F01,AFUNC|AFLIP|3,M_FLIPH,a_set_release_est_r+3
	WL	24,a_no_shoot_button
	LW	SE13F03,3
	LW	SE13F04,3
	LW	SE13F05,3
	LW	SE13F06,3
	LW	SE13F07,5
	LW	SE13F09,2
	LW	SE13F10,2
	LWL	SE13F11,AFUNC|6,a_tshoot_done_1
	LW	SE13F12,3
	LW	SE13F13,3
	LW	SE13F15,2
	LW	SE13F16,3
	LW	SE13F17,2
	LW	SE13F18,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_wrist_shot_down_1
anim_wrist_shot_down_5
	LWL	SF13F01,AFUNC|3,a_set_release_est_r+3
	WL	11,a_set_15_flip
	LWL	SF13F02,AFUNC|5,a_no_shoot_button
	LW	SF13F03,3
	LWL	SF13F04,AFUNC|3,a_shoot_done_1
	LW	SF13F05,8
	LW	SF13F06,3
	LWL	1,AFUNC|1,a_shoot_done_2
	.long	0

anim_wrist_shot_down_2
anim_wrist_shot_down_3
anim_wrist_shot_down_4
	LWWL	SF13F01,AFUNC|AFLIP|3,0,a_set_release_est+1
	.word	11
	LWL	SF13F02,AFUNC|5,a_no_shoot_button
	LW	SF13F03,3
	LWL	SF13F04,AFUNC|3,a_shoot_done_1
	LW	SF13F05,8
	LW	SF13F06,3
	LWL	1,AFUNC|1,a_shoot_done_2
	.long	0

anim_wrist_shot_down_6
anim_wrist_shot_down_7
anim_wrist_shot_down_8
	LWWL	SF13F01,AFUNC|AFLIP|3,M_FLIPH,a_set_release_est+1
	.word	11
	LWL	SF13F02,AFUNC|5,a_no_shoot_button
	LW	SF13F03,3
	LWL	SF13F04,AFUNC|3,a_shoot_done_1
	LW	SF13F05,8
	LW	SF13F06,3
	LWL	1,AFUNC|1,a_shoot_done_2
	.long	0

anim_slap_shot_down_1
anim_slap_shot_down_5
	LWL	SF23F01,AFUNC|2,a_set_release_est_r+3
	WL	11,a_set_15_flip
	LWL	SF23F02,AFUNC|2,a_no_shoot_button
	LW	SF23F03,5
	LW	SF23F04,2
	LWL	SF23F05,AFUNC|8,a_tshoot_done_1
	LW	SF23F06,3
	LW	SF23F06,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_slap_shot_down_2
anim_slap_shot_down_3
anim_slap_shot_down_4
	LWWL	SF23F01,AFUNC|AFLIP|2,0,a_set_release_est+1
	.word	11
	LWL	SF23F02,AFUNC|2,a_no_shoot_button
	LW	SF23F03,5
	LW	SF23F04,2
	LWL	SF23F05,AFUNC|8,a_tshoot_done_1
	LW	SF23F06,3
	LW	SF23F06,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_slap_shot_down_6
anim_slap_shot_down_7
anim_slap_shot_down_8
	LWWL	SF23F01,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est+1
	.word	11
	LWL	SF23F02,AFUNC|2,a_no_shoot_button
	LW	SF23F03,5
	LW	SF23F04,2
	LWL	SF23F05,AFUNC|8,a_tshoot_done_1
	LW	SF23F06,3
	LW	SF23F06,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_backhand_shot_up_1
anim_backhand_shot_up_5
	LWL	SF33F01,AFUNC|4,a_set_release_est_r+3
	WL	8,a_set_15_flip
	LWL	SF33F02,AFUNC|4,a_safety_1_no_shoot_button
	LWL	SF33F03,AFUNC|3,a_shoot_done_1
	LW	SF33F04,3
	LW	SF33F05,3
	LWL	1,AFUNC|1,a_shoot_done_2
	.long	0

anim_backhand_shot_up_2
anim_backhand_shot_up_3
anim_backhand_shot_up_4
	LWWL	SF33F01,AFUNC|AFLIP|4,0,a_set_release_est+1
	.word	8
	LWL	SF33F02,AFUNC|4,a_safety_1_no_shoot_button
	LWL	SF33F03,AFUNC|3,a_shoot_done_1
	LW	SF33F04,3
	LW	SF33F05,3
	LWL	1,AFUNC|1,a_shoot_done_2
	.long	0

anim_backhand_shot_up_6
anim_backhand_shot_up_7
anim_backhand_shot_up_8
	LWWL	SF33F01,AFUNC|AFLIP|4,M_FLIPH,a_set_release_est+1
	.word	8
	LWL	SF33F02,AFUNC|4,a_safety_1_no_shoot_button
	LWL	SF33F03,AFUNC|3,a_shoot_done_1
	LW	SF33F04,3
	LW	SF33F05,3
	LWL	1,AFUNC|1,a_shoot_done_2
	.long	0

anim_turbo_backhand_shot_up_1
anim_turbo_backhand_shot_up_5
	LWL	SF43F01,AFUNC|4,a_set_release_est_r+3
	WL	11,a_set_15_flip
	LWL	SF43F02,AFUNC|7,a_safety_1_no_shoot_button
	LWL	SF43F03,AFUNC|3,a_tshoot_done_1
	LW	SF43F04,3
	LW	SF43F05,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_turbo_backhand_shot_up_2
anim_turbo_backhand_shot_up_3
anim_turbo_backhand_shot_up_4
	LWWL	SF43F01,AFUNC|AFLIP|4,0,a_set_release_est+1
	.word	11
	LWL	SF43F02,AFUNC|7,a_safety_1_no_shoot_button
	LWL	SF43F03,AFUNC|3,a_tshoot_done_1
	LW	SF43F04,3
	LW	SF43F05,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_turbo_backhand_shot_up_6
anim_turbo_backhand_shot_up_7
anim_turbo_backhand_shot_up_8
	LWWL	SF43F01,AFUNC|AFLIP|4,M_FLIPH,a_set_release_est+1
	.word	11
	LWL	SF43F02,AFUNC|7,a_safety_1_no_shoot_button
	LWL	SF43F03,AFUNC|3,a_tshoot_done_1
	LW	SF43F04,3
	LW	SF43F05,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_pass_1
anim_pass_5
anim_tpass_1
anim_tpass_5
	LWL	SB13F04,3|AFUNC,a_set_release_est_r+3
	WL	13,a_set_15_flip
	LW	SB13F05,3
	LW	SB13F06,3
	LW	SB13F07,3
anim_pass_early_1
anim_pass_early_5
	LW	SB13F08,1
	LWL	1,AFUNC|2,a_pass_done_12
	.long	0

anim_pass_2
anim_pass_3
anim_pass_4
anim_tpass_2
anim_tpass_3
anim_tpass_4
	LWWL	SB13F04,AFUNC|AFLIP|3,0,a_set_release_est+1
	.word	13
	LW	SB13F05,3
	LW	SB13F06,3
	LW	SB13F07,3
anim_pass_early_2
anim_pass_early_3
anim_pass_early_4
	LW	SB13F08,1
	LWL	1,AFUNC|2,a_pass_done_12
	.long	0

anim_pass_6
anim_pass_7
anim_pass_8
anim_tpass_6
anim_tpass_7
anim_tpass_8
	LWWL	SB13F04,AFUNC|AFLIP|3,M_FLIPH,a_set_release_est+1
	.word	13
	LW	SB13F05,3
	LW	SB13F06,3
	LW	SB13F07,3
anim_pass_early_6
anim_pass_early_7
anim_pass_early_8
	LW	SB13F08,1
	LWL	1,AFUNC|2,a_pass_done_12
	.long	0

a_pass_done_12
	callr	a_pass_done_1
	jauc	pass_script_done_2

**************************************************************************
*								         *
* a_pass_done_1_safe							 *
* 									 *
* PASS:									 *
* A8 = PLAYER OBJECT							 *
*								         *
**************************************************************************

a_pass_done_1_safe
	CALLA	pass_done_1_safe
	JRNC	APD1S_ABORT_PASS		;BR=NOT SUCCESSFUL
	RETS
APD1S_ABORT_PASS
	CALLA	clear_all_signals
	JAUC	pass_script_done_2

**************************************************************************
*								         *
* pass_done_1_safe							 *
* 									 *
* PASS:									 *
* A8 = PLAYER OBJECT							 *
* RETURN:								 *
* C SET IF PASS SUCCESSFUL, OTHERWISE C CLR				 *
* 									 *
* TRASHES A BUNCH OF REGISTERS						 *
*								         *
**************************************************************************

pass_done_1_safe
	PUSH	A8
	move	*a8(ODT_PBK),a6,L		;get player block
	movb	*a6(POF_NUMBER),a0
	mmtm	sp,a0
	calla	pass_script_done_zero
	mmfm	sp,a14
	jrnc	PD1S_ABORT			;BR=FLAG NO PASS

	MOVE	A2,A2
	JRZ	PD1S_PASS			;BR=NO X VELOCITY

	MOVE	A0,A5

	SUBK	5,A14
	JRNN	PD1S_RIGHT_TEAM			;BR=ON THE RIGHT

	MOVE	A2,A2				;CHECK LEFT TEAM'S PASS X DIR
	JRP	PD1S_PASS			;BR=HEADIN' RIGHT
	MOVI	LEFT_GOALLINE_X,A0
	JRUC	PD1S_Z_CHECK
PD1S_RIGHT_TEAM
	MOVE	A2,A2				;CHECK RIGHT TEAM'S PASS X DIR
	JRN	PD1S_PASS			;BR=HEADIN' LEFT
	MOVI	RGHT_GOALLINE_X,A0
PD1S_Z_CHECK

	MOVE	@PUCK_OBJECT,A9,L
	MOVE	*A9(OXVAL),A1,L
	SUB	A1,A0
	
	MOVE	A2,A1
	CALLA	SAFEDIV
	JRV	PD1S_ABORT			;BR=OVERFLOW!

	MOVE	A3,A0
	CALLA	SAFEMULT
	JRNC	PD1S_PASS0			;BR=WAY OUT THERE!
	MOVE	*A9(OZVAL),A14,L
	ADD	A14,A1				;Z @ GOAL LINE X

	CMPI	TOP_GOALPOST_Z,A1
	JRGT	PD1S_PASS0			;BR=ABOVE GOAL
	CMPI	BOT_GOALPOST_Z,A1
	JRGE	PD1S_ABORT			;BR=INSIDE GOAL

PD1S_PASS0
	MOVE	A5,A0
PD1S_PASS
	CALLA	pass_script_done_zero_one
	SETC					;PASS FLAG
	PULLQ	A8
	RETS
PD1S_ABORT
	CLRC					;NO PASS FLAG
	PULLQ	A8
	RETS

**************************************************************************

a_pass_done_1
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	pass_script_done_1
a_pass_done_2
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	pass_script_done_2

anim_pass_1_7
	LWWL	PS11F01,AFUNC|AFLIP|4,0,a_set_release_est+1
	.word	8
	LW	PS11F03,4
anim_pass_early_1_7
	LWL	PS11F04,AFUNC|7,a_pass_done_1
	LW	PS11F03,3
	LW	PS11F01,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_3_7
	LWWL	PS33F02,AFUNC|AFLIP|4,0,a_set_release_est+1
	.word	8
	LW	PS33F03,4
anim_pass_early_3_7
	LWL	PS33F04,AFUNC|7,a_pass_done_1
	LW	PS33F03,3
	LW	PS33F02,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_thru_3_7
	LWWL	PS43F01,AFUNC|AFLIP|4,0,a_set_release_est+1
	.word	8
	LW	PS43F02,4
anim_pass_thru_early_3_7
	LWL	PS43F03,AFUNC|7,a_pass_done_1
	LW	PS43F02,3
	LW	PS43F01,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_5_7
	LWWL	PS25F01,AFUNC|AFLIP|4,0,a_set_release_est+1
	.word	8
	LW	PS25F02,4
anim_pass_early_5_7
	LWL	PS25F03,AFUNC|7,a_pass_done_1
	LW	PS25F02,3
	LW	PS25F01,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_r3_r3
	LWWL	SB13F04,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est+1
	.word	8
	LW	SB13F05,2
	LW	SB13F06,2
	LW	SB13F07,2
anim_pass_early_r3_r3
	LWL	SB13F08,AFUNC|1,a_pass_done_12
	.long	0

anim_pass_1_3
	LWWL	PS21F01,AFUNC|AFLIP|4,0,a_set_release_est+1
	.word	8
	LW	PS21F02,4
anim_pass_early_1_3
	LWL	PS21F03,AFUNC|7,a_pass_done_1
	LW	PS21F02,4
	LW	PS21F01,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_3_3
	LWWL	SB13F04,AFUNC|AFLIP|2,0,a_set_release_est+1
	.word	8
	LW	SB13F05,2
	LW	SB13F06,2
	LW	SB13F07,2
anim_pass_early_3_3
	LWL	SB13F08,AFUNC|1,a_pass_done_12
	.long	0

anim_pass_5_3
	LWWL	PS15F01,AFUNC|AFLIP|4,0,a_set_release_est+1
	.word	8
	LW	PS15F02,4
anim_pass_early_5_3
	LWL	PS15F03,AFUNC|7,a_pass_done_1
	LW	PS15F02,4
	LW	PS15F01,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_r3_r7
	LWWL	PS33F02,AFUNC|AFLIP|4,M_FLIPH,a_set_release_est+1
	.word	8
	LW	PS33F03,4
anim_pass_early_r3_r7
	LWL	PS33F04,AFUNC|7,a_pass_done_1
	LW	PS33F03,4
	LW	PS33F02,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_thru_r3_r7
	LWWL	PS43F01,AFUNC|AFLIP|4,M_FLIPH,a_set_release_est+1
	.word	8
	LW	PS43F02,4
anim_pass_thru_early_r3_r7
	LWL	PS43F03,AFUNC|7,a_pass_done_1
	LW	PS43F02,4
	LW	PS43F01,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_p3_1
	LWL	PS23F01,AFUNC|4,a_set_release_est_r+3
	WL	8,a_set_15_flip
	LW	PS23F02,4
anim_pass_early_p3_1
	LWL	PS23F03,AFUNC|7,a_pass_done_1
	LW	PS23F02,4
	LW	PS23F01,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_3_1
	LWWL	PS23F01,AFUNC|AFLIP|4,0,a_set_release_est+1
	.word	8
	LW	PS23F02,4
anim_pass_early_3_1
	LWL	PS23F03,AFUNC|7,a_pass_done_1
	LW	PS23F02,4
	LW	PS23F01,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_r3_1
	LWWL	PS23F01,AFUNC|AFLIP|4,M_FLIPH,a_set_release_est+1
	.word	8
	LW	PS23F02,4
anim_pass_early_r3_1
	LWL	PS23F03,AFUNC|7,a_pass_done_1
	LW	PS23F02,4
	LW	PS23F01,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_p3_5
	LWL	PS13F01,AFUNC|4,a_set_release_est_r+3
	WL	8,a_set_15_flip
	LW	PS13F02,4
anim_pass_early_p3_5
	LWL	PS13F03,AFUNC|7,a_pass_done_1
	LW	PS13F02,4
	LW	PS13F01,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_3_5
	LWWL	PS13F01,AFUNC|AFLIP|4,0,a_set_release_est+1
	.word	8
	LW	PS13F02,4
anim_pass_early_3_5
	LWL	PS13F03,AFUNC|7,a_pass_done_1
	LW	PS13F02,4
	LW	PS13F01,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_pass_r3_5
	LWWL	PS13F01,AFUNC|AFLIP|4,M_FLIPH,a_set_release_est+1
	.word	8
	LW	PS13F02,4
anim_pass_early_r3_5
	LWL	PS13F03,AFUNC|7,a_pass_done_1
	LW	PS13F02,4
	LW	PS13F01,1
	LWL	1,AFUNC|2,a_pass_done_2
	.long	0

anim_shoot_early_1
anim_shoot_early_5
	LWL	SA13F08,AFUNC|3,a_set_release_est_r+3
	WL	5,a_flip_no_shoot_button
	LW	SA13F09,2
	LWL	1,AFUNC|1,a_shoot_done_1
	LW	SA13F11,10
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_shoot_done_2
	.long	0

anim_shoot_early_2
anim_shoot_early_3
anim_shoot_early_4
	LWWL	SA13F08,AFLIP|AFUNC|3,0,a_set_release_est_r+3
	WL	5,a_no_shoot_button
	LW	SA13F09,2
	LWL	1,AFUNC|1,a_shoot_done_1
	LW	SA13F11,10
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_shoot_done_2
	.long	0

anim_shoot_early_6
anim_shoot_early_7
anim_shoot_early_8
	LWWL	SA13F08,AFLIP|AFUNC|3,M_FLIPH,a_set_release_est_r+3
	WL	5,a_no_shoot_button
	LW	SA13F09,2
	LWL	1,AFUNC|1,a_shoot_done_1
	LW	SA13F11,10
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_shoot_done_2
	.long	0

anim_trailshoot_1
anim_trailshoot_5
	LWL	SA13F01,2|AFUNC,a_set_release_est_r+3
	WL	22,a_set_15_flip
	LW	SA13F02,3
	LW	SA13F03,3
	LW	SA13F04,3
	LW	SA13F05,3
	LW	SA13F06,9
	LWL	SA13F08,AFUNC|2,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LW	SA13F11,8
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_trailshoot_2
anim_trailshoot_3
anim_trailshoot_4
	LWWL	SA13F01,AFUNC|AFLIP|2,0,a_set_release_est+1
	.word	22
	LW	SA13F02,3
	LW	SA13F03,3
	LW	SA13F04,3
	LW	SA13F05,3
	LW	SA13F06,9
	LWL	SA13F08,AFUNC|2,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LW	SA13F11,8
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_trailshoot_6
anim_trailshoot_7
anim_trailshoot_8
	LWWL	SA13F01,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est+1
	.word	22
	LW	SA13F02,3
	LW	SA13F03,3
	LW	SA13F04,3
	LW	SA13F05,3
	LW	SA13F06,9
	LWL	SA13F08,AFUNC|2,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LW	SA13F11,8
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_scaleshoot_1
anim_scaleshoot_5
	LWL	SA13F01,AFUNC|2,0,a_set_release_est_r+3
	WL	22,a_set_15_flip
	LWLW	SA13F02,AFUNC|1,a_bodywhoosh+1,0fch
	LWLW	SA13F02,AFUNC|1,a_bodyscale+1,0fah
	LWLW	SA13F02,AFUNC|1,a_bodyscale+1,0f8h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0f6h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0f2h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0f0h
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0ech
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0eah
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0e6h
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0e4h
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0e0h
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0deh
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0dah
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0d8h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0d0h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ceh
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0cah
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0c8h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0c4h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0c2h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0beh
	LWL	SA13F08,AFUNC|2,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0c4h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0cah
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0d0h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0d6h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0dch
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0e2h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0e8h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0eeh
	LWLW	SA13F13,AFUNC|1,a_bodyscale+1,0f4h
	LWLW	SA13F13,AFUNC|1,a_bodyscale+1,0fah
	LWLW	SA13F14,AFUNC|1,a_bodyscale+1,0100h
	LWLW	SA13F14,AFUNC|1,a_bodyscale+1,0100h
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_scaleshoot_2
anim_scaleshoot_3
anim_scaleshoot_4
	LWWL	SA13F01,AFUNC|AFLIP|2,0,a_set_release_est+1
	.word	22
	LWLW	SA13F02,AFUNC|1,a_bodywhoosh+1,0fch
	LWLW	SA13F02,AFUNC|1,a_bodyscale+1,0fah
	LWLW	SA13F02,AFUNC|1,a_bodyscale+1,0f8h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0f6h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0f2h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0f0h
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0ech
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0eah
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0e6h
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0e4h
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0e0h
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0deh
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0dah
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0d8h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0d0h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ceh
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0cah
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0c8h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0c4h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0c2h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0beh
	LWL	SA13F08,AFUNC|2,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0c4h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0cah
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0d0h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0d6h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0dch
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0e2h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0e8h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0eeh
	LWLW	SA13F13,AFUNC|1,a_bodyscale+1,0f4h
	LWLW	SA13F13,AFUNC|1,a_bodyscale+1,0fah
	LWLW	SA13F14,AFUNC|1,a_bodyscale+1,0100h
	LWLW	SA13F14,AFUNC|1,a_bodyscale+1,0100h
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_scaleshoot_6
anim_scaleshoot_7
anim_scaleshoot_8
	LWWL	SA13F01,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est+1
	.word	22
	LWLW	SA13F02,AFUNC|1,a_bodywhoosh+1,0fch
	LWLW	SA13F02,AFUNC|1,a_bodyscale+1,0fah
	LWLW	SA13F02,AFUNC|1,a_bodyscale+1,0f8h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0f6h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0f2h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0f0h
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0ech
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0eah
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0e6h
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0e4h
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0e0h
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0deh
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0dah
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0d8h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0d0h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ceh
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0cah
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0c8h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0c4h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0c2h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0beh
	LWL	SA13F08,AFUNC|2,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0c4h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0cah
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0d0h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0d6h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0dch
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0e2h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0e8h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0eeh
	LWLW	SA13F13,AFUNC|1,a_bodyscale+1,0f4h
	LWLW	SA13F13,AFUNC|1,a_bodyscale+1,0fah
	LWLW	SA13F14,AFUNC|1,a_bodyscale+1,0100h
	LWLW	SA13F14,AFUNC|1,a_bodyscale+1,0100h
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

a_bodyscale
	move	*a8(ANIMARG),a14,L
	move	*a14+,a0,W
	jauc	scale_body_to_pct
a_bodywhoosh
	calla	a_bodyscale
	jruc	a_whoosh_sound

anim_bscaleshoot_1
anim_bscaleshoot_5
	LWWL	SA13F01,AFUNC|AFLIP|2,0,a_set_release_est_r+3
	WL	22,a_set_15_flip
	LWLW	SA13F02,AFUNC|1,a_bodywhoosh+1,0fah
	LWLW	SA13F02,AFUNC|1,a_bodyscale+1,0f4h
	LWLW	SA13F02,AFUNC|1,a_bodyscale+1,0eeh
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0e8h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0e2h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0dch
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0d6h
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0d0h
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0cah
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0c4h
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0beh
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0b8h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0b2h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;0a6h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;0a0h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;09ah
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;094h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;08eh
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;088h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;082h
	LWL	SA13F08,AFUNC|2,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0b2h	;08ah
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0b2h	;094h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0b2h	;0a8h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0b2h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0bch
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0c6h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0d0h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0dah
	LWLW	SA13F13,AFUNC|1,a_bodyscale+1,0e4h
	LWLW	SA13F13,AFUNC|1,a_bodyscale+1,0f8h
	LWLW	SA13F14,AFUNC|1,a_bodyscale+1,100h
	LWLW	SA13F14,AFUNC|1,a_bodyscale+1,100h
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_bscaleshoot_2
anim_bscaleshoot_3
anim_bscaleshoot_4
	LWWL	SA13F01,AFUNC|AFLIP|2,0,a_set_release_est+1
	.word	22
	LWLW	SA13F02,AFUNC|1,a_bodywhoosh+1,0fah
	LWLW	SA13F02,AFUNC|1,a_bodyscale+1,0f4h
	LWLW	SA13F02,AFUNC|1,a_bodyscale+1,0eeh
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0e8h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0e2h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0dch
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0d6h
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0d0h
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0cah
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0c4h
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0beh
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0b8h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0b2h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;0a6h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;0a0h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;09ah
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;094h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;08eh
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;088h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;082h
	LWL	SA13F08,AFUNC|2,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0b2h	;08ah
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0b2h	;094h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0b2h	;0a8h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0b2h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0bch
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0c6h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0d0h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0dah
	LWLW	SA13F13,AFUNC|1,a_bodyscale+1,0e4h
	LWLW	SA13F13,AFUNC|1,a_bodyscale+1,0f8h
	LWLW	SA13F14,AFUNC|1,a_bodyscale+1,100h
	LWLW	SA13F14,AFUNC|1,a_bodyscale+1,100h
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_bscaleshoot_6
anim_bscaleshoot_7
anim_bscaleshoot_8
	LWWL	SA13F01,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est+1
	.word	22
	LWLW	SA13F02,AFUNC|1,a_bodywhoosh+1,0fah
	LWLW	SA13F02,AFUNC|1,a_bodyscale+1,0f4h
	LWLW	SA13F02,AFUNC|1,a_bodyscale+1,0eeh
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0e8h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0e2h
	LWLW	SA13F03,AFUNC|1,a_bodyscale+1,0dch
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0d6h
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0d0h
	LWLW	SA13F04,AFUNC|1,a_bodyscale+1,0cah
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0c4h
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0beh
	LWLW	SA13F05,AFUNC|1,a_bodyscale+1,0b8h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0b2h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;0a6h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;0a0h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;09ah
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;094h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;08eh
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;088h
	LWLW	SA13F06,AFUNC|1,a_bodyscale+1,0ach	;082h
	LWL	SA13F08,AFUNC|2,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0b2h	;08ah
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0b2h	;094h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0b2h	;0a8h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0b2h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0bch
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0c6h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0d0h
	LWLW	SA13F11,AFUNC|1,a_bodyscale+1,0dah
	LWLW	SA13F13,AFUNC|1,a_bodyscale+1,0e4h
	LWLW	SA13F13,AFUNC|1,a_bodyscale+1,0f8h
	LWLW	SA13F14,AFUNC|1,a_bodyscale+1,100h
	LWLW	SA13F14,AFUNC|1,a_bodyscale+1,100h
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tshoot_1
anim_tshoot_5
	LWL	SA13F01,2|AFUNC,a_set_release_est_r+3
	WL	22,a_set_15_flip
	LW	SA13F02,3
	LW	SA13F03,3
	LW	SA13F04,3
	LW	SA13F05,3
	LW	SA13F06,5
	LWL	SA13F08,AFUNC|2,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LW	SA13F11,8
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tshoot_2
anim_tshoot_3
anim_tshoot_4
	LWWL	SA13F01,AFUNC|AFLIP|2,0,a_set_release_est+1
	.word	22
	LW	SA13F02,3
	LW	SA13F03,3
	LW	SA13F04,3
	LW	SA13F05,3
	LW	SA13F06,5
	LWL	SA13F08,AFUNC|2,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LW	SA13F11,8
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tshoot_6
anim_tshoot_7
anim_tshoot_8
	LWWL	SA13F01,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est+1
	.word	22
	LW	SA13F02,3
	LW	SA13F03,3
	LW	SA13F04,3
	LW	SA13F05,3
	LW	SA13F06,5
	LWL	SA13F08,AFUNC|2,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LW	SA13F11,8
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

a_tshoot_done_1
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	turbo_shoot_script_done_1

a_tshoot_done_2
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	turbo_shoot_script_done_2

anim_tshoot_early_1
anim_tshoot_early_5
	LWL	SA13F08,AFUNC|2,a_set_release_est_r+3
	WL	3,a_flip_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LW	SA13F11,8
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tshoot_early_2
anim_tshoot_early_3
anim_tshoot_early_4
	LWWL	SA13F08,AFLIP|AFUNC|2,0,a_set_release_est_r+3
	WL	3,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LW	SA13F11,8
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tshoot_early_6
anim_tshoot_early_7
anim_tshoot_early_8
	LWWL	SA13F08,AFLIP|AFUNC|2,M_FLIPH,a_set_release_est_r+3
	WL	3,a_no_shoot_button
	LW	SA13F09,1
	LWL	1,AFUNC|1,a_tshoot_done_1
	LW	SA13F11,8
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_onetime_1
anim_onetime_5
	LWL	SA13F03,3|AFUNC,a_set_release_est_r+3
	WL	17,a_set_15_flip
	LW	SA13F04,3
	LW	SA13F05,3
	LW	SA13F06,3
	LWL	SA13F08,AFUNC|3,a_clear_otd
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|9,a_onetime_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_onetime_2
anim_onetime_3
anim_onetime_4
	LWWL	SA13F03,AFUNC|AFLIP|3,0,a_set_release_est+1
	.word	17
	LW	SA13F04,3
	LW	SA13F05,3
	LW	SA13F06,3
	LWL	SA13F08,AFUNC|3,a_clear_otd
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|9,a_onetime_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_onetime_6
anim_onetime_7
anim_onetime_8
	LWWL	SA13F03,AFUNC|AFLIP|3,M_FLIPH,a_set_release_est+1
	.word	17
	LW	SA13F04,3
	LW	SA13F05,3
	LW	SA13F06,3
	LWL	SA13F08,AFUNC|3,a_clear_otd
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|9,a_onetime_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

a_onetime_done_fff1
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	onetime_script_done_fff1
a_onetime_done_ff1
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	onetime_script_done_ff1
a_onetime_done_f1
a_onetime_done_1
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	onetime_script_done_1

a_onetime_done_2
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	onetime_script_done_2

anim_fonetime_1
anim_fonetime_5
	LWL	SA13F03,3|AFUNC,a_set_release_est_r+3
	WL	11,a_set_15_flip
	LW	SA13F04,3
	LWL	SA13F08,AFUNC|3,a_clear_otd
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|9,a_onetime_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_fonetime_2
anim_fonetime_3
anim_fonetime_4
	LWWL	SA13F03,AFUNC|AFLIP|3,0,a_set_release_est+1
	.word	11
	LW	SA13F04,3
	LWL	SA13F08,AFUNC|3,a_clear_otd
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|9,a_onetime_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_fonetime_6
anim_fonetime_7
anim_fonetime_8
	LWWL	SA13F03,AFUNC|AFLIP|3,M_FLIPH,a_set_release_est+1
	.word	11
	LW	SA13F04,3
	LWL	SA13F08,AFUNC|3,a_clear_otd
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|9,a_onetime_done_1
	LWL	1,AFUNC|1,a_onetime_done_f1
	LW	SA13F11,10
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_fafonetime_1
anim_fafonetime_5
	LWL	SA13F03,1|AFUNC,a_set_release_est_r+3
	WL	8,a_set_15_flip
	LW	SA13F04,2
	LWL	SA13F08,AFUNC|2,a_clear_otd
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|9,a_onetime_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_fafonetime_2
anim_fafonetime_3
anim_fafonetime_4
	LWWL	SA13F03,AFUNC|AFLIP|1,0,a_set_release_est+1
	.word	8
	LW	SA13F04,2
	LWL	SA13F08,AFUNC|2,a_clear_otd
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|9,a_onetime_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_fafonetime_6
anim_fafonetime_7
anim_fafonetime_8
	LWWL	SA13F03,AFUNC|AFLIP|1,M_FLIPH,a_set_release_est+1
	.word	8
	LW	SA13F04,2
	LWL	SA13F08,AFUNC|2,a_clear_otd
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F09,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|1,a_onetime_done_1
	LWL	SA13F11,AFUNC|9,a_onetime_done_1
	LWL	1,AFUNC|1,a_onetime_done_f1
	LW	SA13F11,10
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_ffonetime_1
anim_ffonetime_5
	LWL	AA53F03,AFUNC|1,a_set_release_est_r_otd+3
	WL	2,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_2
	.long	0

anim_ffonetime_2
anim_ffonetime_3
anim_ffonetime_4
	LWWL	AA53F03,AFLIP|AFUNC|1,0,a_set_release_est_r_otd+3
	WL	2,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_2
	.long	0

anim_ffonetime_6
anim_ffonetime_7
anim_ffonetime_8
	LWWL	AA53F03,AFLIP|AFUNC|1,M_FLIPH,a_set_release_est_r_otd+3
	WL	2,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_ff1
	LWL	AA53F03,AFUNC|1,a_onetime_done_2
	.long	0

anim_fionetime_1
anim_fionetime_5
	LWL	1,AFUNC|1,a_set_release_est_r_otd+3
	WL	1,a_onetime_done_fff1
	LW	AA53F03,3
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_fionetime_2
anim_fionetime_3
anim_fionetime_4
	LWL	1,AFUNC|1,a_set_release_est_r_otd+3
	WL	1,a_onetime_done_fff1
	LWW	AA53F03,AFLIP|3,0
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_fionetime_6
anim_fionetime_7
anim_fionetime_8
	LWL	1,AFUNC|1,a_set_release_est_r_otd+3
	WL	1,a_onetime_done_fff1
	LWW	AA53F03,AFLIP|3,M_FLIPH
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_tornadoccw_shot_1
	LWWL	TS13F03,AFUNC|AFLIP|2,0,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F04,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|3,a_tornado_release_check
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F03,AFUNC|1,a_tshoot_done_1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,1
	LW	TS13F07,1
	LW	TS13F08,1
	LW	TS13F01,2
	LW	TS13F02,1
	LW	TS13F03,2
	LW	TS13F04,1
	LW	TS13F05,2
	LW	TS13F06,2
	LW	TS13F07,2
	LW	TS13F08,3
	LW	TS13F01,2
	LW	TS13F02,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadoccw_shot_2
	LWWL	TS13F02,AFUNC|AFLIP|2,0,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F03,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|3,a_tornado_release_check
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F02,AFUNC|1,a_tshoot_done_1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,1
	LW	TS13F07,1
	LW	TS13F08,2
	LW	TS13F01,1
	LW	TS13F02,2
	LW	TS13F03,1
	LW	TS13F04,2
	LW	TS13F05,2
	LW	TS13F06,2
	LW	TS13F07,3
	LW	TS13F08,2
	LW	TS13F01,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadoccw_shot_3
	LWWL	TS13F01,AFUNC|AFLIP|2,0,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F02,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|3,a_tornado_release_check
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F01,AFUNC|1,a_tshoot_done_1
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,1
	LW	TS13F07,2
	LW	TS13F08,1
	LW	TS13F01,2
	LW	TS13F02,1
	LW	TS13F03,2
	LW	TS13F04,2
	LW	TS13F05,2
	LW	TS13F06,3
	LW	TS13F07,2
	LW	TS13F08,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadoccw_shot_4
	LWWL	TS13F08,AFUNC|AFLIP|2,0,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F01,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|3,a_tornado_release_check
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F08,AFUNC|1,a_tshoot_done_1
	LW	TS13F01,1
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,2
	LW	TS13F07,1
	LW	TS13F08,2
	LW	TS13F01,1
	LW	TS13F02,2
	LW	TS13F03,2
	LW	TS13F04,2
	LW	TS13F05,3
	LW	TS13F06,2
	LW	TS13F07,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadoccw_shot_5
	LWWL	TS13F07,AFUNC|AFLIP|2,0,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F08,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|3,a_tornado_release_check
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F07,AFUNC|1,a_tshoot_done_1
	LW	TS13F08,1
	LW	TS13F01,1
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,2
	LW	TS13F06,1
	LW	TS13F07,2
	LW	TS13F08,1
	LW	TS13F01,2
	LW	TS13F02,2
	LW	TS13F03,2
	LW	TS13F04,3
	LW	TS13F05,2
	LW	TS13F06,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadoccw_shot_6
	LWWL	TS13F06,AFUNC|AFLIP|2,0,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F07,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|3,a_tornado_release_check
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F06,AFUNC|1,a_tshoot_done_1
	LW	TS13F07,1
	LW	TS13F08,1
	LW	TS13F01,1
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,2
	LW	TS13F05,1
	LW	TS13F06,2
	LW	TS13F07,1
	LW	TS13F08,2
	LW	TS13F01,2
	LW	TS13F02,2
	LW	TS13F03,3
	LW	TS13F04,2
	LW	TS13F05,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadoccw_shot_7
	LWWL	TS13F05,AFUNC|AFLIP|2,0,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F06,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|3,a_tornado_release_check
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F05,AFUNC|1,a_tshoot_done_1
	LW	TS13F06,1
	LW	TS13F07,1
	LW	TS13F08,1
	LW	TS13F01,1
	LW	TS13F02,1
	LW	TS13F03,2
	LW	TS13F04,1
	LW	TS13F05,2
	LW	TS13F06,1
	LW	TS13F07,2
	LW	TS13F08,2
	LW	TS13F01,2
	LW	TS13F02,3
	LW	TS13F03,2
	LW	TS13F04,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadoccw_shot_8
	LWWL	TS13F04,AFUNC|AFLIP|2,0,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F05,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|3,a_tornado_release_check
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F04,AFUNC|1,a_tshoot_done_1
	LW	TS13F05,1
	LW	TS13F06,1
	LW	TS13F07,1
	LW	TS13F08,1
	LW	TS13F01,1
	LW	TS13F02,2
	LW	TS13F03,1
	LW	TS13F04,2
	LW	TS13F05,1
	LW	TS13F06,2
	LW	TS13F07,2
	LW	TS13F08,2
	LW	TS13F01,3
	LW	TS13F02,2
	LW	TS13F03,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadocw_shot_1
	LWWL	TS13F03,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F04,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|3,a_tornado_release_check
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F03,AFUNC|1,a_tshoot_done_1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,1
	LW	TS13F07,1
	LW	TS13F08,1
	LW	TS13F01,2
	LW	TS13F02,1
	LW	TS13F03,2
	LW	TS13F04,1
	LW	TS13F05,2
	LW	TS13F06,2
	LW	TS13F07,2
	LW	TS13F08,3
	LW	TS13F01,2
	LW	TS13F02,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadocw_shot_2
	LWWL	TS13F04,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F05,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|3,a_tornado_release_check
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F04,AFUNC|1,a_tshoot_done_1
	LW	TS13F05,1
	LW	TS13F06,1
	LW	TS13F07,1
	LW	TS13F08,1
	LW	TS13F01,1
	LW	TS13F02,2
	LW	TS13F03,1
	LW	TS13F04,2
	LW	TS13F05,1
	LW	TS13F06,2
	LW	TS13F07,2
	LW	TS13F08,2
	LW	TS13F01,3
	LW	TS13F02,2
	LW	TS13F03,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadocw_shot_3
	LWWL	TS13F05,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F06,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|3,a_tornado_release_check
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F05,AFUNC|1,a_tshoot_done_1
	LW	TS13F06,1
	LW	TS13F07,1
	LW	TS13F08,1
	LW	TS13F01,1
	LW	TS13F02,1
	LW	TS13F03,2
	LW	TS13F04,1
	LW	TS13F05,2
	LW	TS13F06,1
	LW	TS13F07,2
	LW	TS13F08,2
	LW	TS13F01,2
	LW	TS13F02,3
	LW	TS13F03,2
	LW	TS13F04,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadocw_shot_4
	LWWL	TS13F06,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F07,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|3,a_tornado_release_check
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F06,AFUNC|1,a_tshoot_done_1
	LW	TS13F07,1
	LW	TS13F08,1
	LW	TS13F01,1
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,2
	LW	TS13F05,1
	LW	TS13F06,2
	LW	TS13F07,1
	LW	TS13F08,2
	LW	TS13F01,2
	LW	TS13F02,2
	LW	TS13F03,3
	LW	TS13F04,2
	LW	TS13F05,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadocw_shot_5
	LWWL	TS13F07,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F08,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|3,a_tornado_release_check
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F07,AFUNC|1,a_tshoot_done_1
	LW	TS13F08,1
	LW	TS13F01,1
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,2
	LW	TS13F06,1
	LW	TS13F07,2
	LW	TS13F08,1
	LW	TS13F01,2
	LW	TS13F02,2
	LW	TS13F03,2
	LW	TS13F04,3
	LW	TS13F05,2
	LW	TS13F06,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadocw_shot_6
	LWWL	TS13F08,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F01,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|3,a_tornado_release_check
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F08,AFUNC|1,a_tshoot_done_1
	LW	TS13F01,1
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,2
	LW	TS13F07,1
	LW	TS13F08,2
	LW	TS13F01,1
	LW	TS13F02,2
	LW	TS13F03,2
	LW	TS13F04,2
	LW	TS13F05,3
	LW	TS13F06,2
	LW	TS13F07,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadocw_shot_7
	LWWL	TS13F01,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F02,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|3,a_tornado_release_check
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|2,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F03,AFUNC|2,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|2,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F03,AFUNC|1,a_tornado_release_check
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F01,AFUNC|1,a_tshoot_done_1
	LW	TS13F02,1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,1
	LW	TS13F07,2
	LW	TS13F08,1
	LW	TS13F01,2
	LW	TS13F02,1
	LW	TS13F03,2
	LW	TS13F04,2
	LW	TS13F05,2
	LW	TS13F06,3
	LW	TS13F07,2
	LW	TS13F08,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_tornadocw_shot_8
	LWWL	TS13F02,AFUNC|AFLIP|2,M_FLIPH,a_set_release_est_r+3
	WL	37,a_no_shoot_button
	LWL	TS13F03,AFUNC|3,a_tornado_rel_check_whoosh
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|3,a_tornado_release_check
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|2,a_tornado_release_check
	LWL	TS13F08,AFUNC|2,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|2,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F04,AFUNC|2,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|2,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_release_check
	LWL	TS13F02,AFUNC|1,a_tornado_release_check
	LWL	TS13F03,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F04,AFUNC|1,a_tornado_release_check
	LWL	TS13F05,AFUNC|1,a_tornado_release_check
	LWL	TS13F06,AFUNC|1,a_tornado_release_check
	LWL	TS13F07,AFUNC|1,a_tornado_release_check
	LWL	TS13F08,AFUNC|1,a_tornado_release_check
	LWL	TS13F01,AFUNC|1,a_tornado_rel_check_whoosh
	LWL	TS13F02,AFUNC|1,a_tshoot_done_1
	LW	TS13F03,1
	LW	TS13F04,1
	LW	TS13F05,1
	LW	TS13F06,1
	LW	TS13F07,1
	LW	TS13F08,2
	LW	TS13F01,1
	LW	TS13F02,2
	LW	TS13F03,1
	LW	TS13F04,2
	LW	TS13F05,2
	LW	TS13F06,2
	LW	TS13F07,3
	LW	TS13F08,2
	LW	TS13F01,3
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

a_tornado_rel_check_whoosh
	callr	a_whoosh_sound
a_tornado_release_check
	move	*a8(ODT_PBK),a6,L
	movb	*a6(POF_NUMBER),a0
	move	@PUCK_CONTROL,a14,W
	cmp	a0,a14
	jrnz	atrc_9
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	atrc_9
	move	*a6(POF_BUTTONS),a14,W
	btst	0,a14
	jrz	a_tshoot_done_1
atrc_9	rets

a_safety_1_no_shoot_button
	callr	a_safety_shot_check_1
	jruc	a_no_shoot_button
a_safety_shot_check_1
	move	*a8(ODT_PBK),a6,L
	move	@PUCK_OBJECT,a7,L
	move	*a7(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
	move	*a7(OZPOS),a1,W
	movb	*a6(POF_NUMBER),a4
	dec	a4
	srl	2,a4
	neg	a4
	addk	2,a4
	sll	2,a4	;other team's goalie
	GBLOCK	a4,a4
	move	*a4(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrz	asscc9			;the goalie is pulled
	move	*a4(POF_OBJECT),a4,L
	move	*a4(OXVAL),a2,L
	addi	[0,08000h],a2
	sra	16,a2
	move	*a4(OZPOS),a3,W
	calla	find_dist_quick
	cmpi	100,a4
	jrhi	asscc9
	movk	1,a14
	move	a14,*a6(POF_SAFETY_WARNING),W
asscc9	rets

anim_onespinccw_1
anim_onespinccw_2
anim_onespinccw_3
anim_onespinccw_4
anim_onespinccw_5
anim_onespinccw_6
anim_onespinccw_7
anim_onespinccw_8
	LWWL	TS13F01p,AFUNC|AFLIP|1,0,a_set_release_est+1
	.word	17
	LWL	TS13F02p,1|AFUNC,a_whoosh_sound
	LW	TS13F03p,1
	LW	TS13F04p,1
	LW	TS13F05p,1
	LW	TS13F06p,1
	LW	TS13F07p,1
	LW	TS13F08p,1
	LW	TS13F01p,1
	LWL	TS13F02p,1|AFUNC,a_whoosh_sound
	LW	TS13F03p,1
	LWL	TS13F04p,AFUNC|1,a_clear_otd
	LW	TS13F05p,1
	LWL	TS13F06p,1|AFUNC,a_whoosh_sound
	LWL	TS13F07p,AFUNC|1,a_onetime_done_1
	LWL	TS13F08p,AFUNC|1,a_onetime_done_1
	LWL	TS13F01p,AFUNC|1,a_onetime_done_1
	LWL	TS13F02p,AFUNC|1,a_onetime_done_1
	LWL	TS13F03p,AFUNC|1,a_onetime_done_1
	LW	TS13F04p,1
	LW	TS13F05p,1
	LW	TS13F06p,1
	LW	TS13F07p,1
	LW	TS13F08p,1
	LW	TS13F01p,1
	LW	TS13F02p,1
	LW	TS13F03p,1
	LW	TS13F04p,1
	LW	TS13F05p,1
	LW	TS13F06p,1
	LW	TS13F07p,1
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_onespincw_1
anim_onespincw_2
anim_onespincw_3
anim_onespincw_4
anim_onespincw_5
anim_onespincw_6
anim_onespincw_7
anim_onespincw_8
	LWWL	TS13F01p,AFUNC|AFLIP|1,M_FLIPH,a_set_release_est+1
	.word	17
	LWL	TS13F02p,1|AFUNC,a_whoosh_sound
	LW	TS13F03p,1
	LW	TS13F04p,1
	LW	TS13F05p,1
	LW	TS13F06p,1
	LW	TS13F07p,1
	LW	TS13F08p,1
	LW	TS13F01p,1
	LWL	TS13F02p,1|AFUNC,a_whoosh_sound
	LW	TS13F03p,1
	LWL	TS13F04p,AFUNC|1,a_clear_otd
	LW	TS13F05p,1
	LWL	TS13F06p,1|AFUNC,a_whoosh_sound
	LWL	TS13F07p,AFUNC|1,a_onetime_done_1
	LWL	TS13F08p,AFUNC|1,a_onetime_done_1
	LWL	TS13F01p,AFUNC|1,a_onetime_done_1
	LWL	TS13F02p,AFUNC|1,a_onetime_done_1
	LWL	TS13F03p,AFUNC|1,a_onetime_done_1
	LW	TS13F04p,1
	LW	TS13F05p,1
	LW	TS13F06p,1
	LW	TS13F07p,1
	LW	TS13F08p,1
	LW	TS13F01p,1
	LW	TS13F02p,1
	LW	TS13F03p,1
	LW	TS13F04p,1
	LW	TS13F05p,1
	LW	TS13F06p,1
	LW	TS13F07p,1
	LWL	1,AFUNC|1,a_onetime_done_2
	.long	0

anim_spin_slapshot_1
anim_spin_slapshot_5
	LWL	SA13F01,AFUNC|2,a_set_release_est+1
	.word	 30
	LWL	SA13F02,AFUNC|3,a_no_shoot_button
	LW	SA13F03,3
	LW	SA13F05,3
	LW	SA13F06,5
	LW	SS43F03,2
	LW	SS43F05,2
	LW	SS43F06,2
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LW	SS43F10,2
	LWL	SA13F11,AFUNC|8,a_tshoot_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_spin_slapshot_2
anim_spin_slapshot_3
anim_spin_slapshot_4
	LWWL	SA13F01,AFLIP|AFUNC|2,0,a_set_release_est+1
	.word	 30
	LWL	SA13F02,AFUNC|3,a_no_shoot_button
	LW	SA13F03,3
	LW	SA13F05,3
	LW	SA13F06,5
	LW	SS43F03,2
	LW	SS43F05,2
	LW	SS43F06,2
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LW	SS43F10,2
	LWL	SA13F11,AFUNC|8,a_tshoot_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_spin_slapshot_6
anim_spin_slapshot_7
anim_spin_slapshot_8
	LWWL	SA13F01,AFLIP|AFUNC|2,M_FLIPH,a_set_release_est+1
	.word	 30
	LWL	SA13F02,AFUNC|3,a_no_shoot_button
	LW	SA13F03,3
	LW	SA13F05,3
	LW	SA13F06,5
	LW	SS43F03,2
	LW	SS43F05,2
	LW	SS43F06,2
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LW	SS43F10,2
	LWL	SA13F11,AFUNC|8,a_tshoot_done_1
	LW	SA13F13,2
	LW	SA13F14,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_spin_backhand_1
anim_spin_backhand_5
	LWL	SC13F02,AFUNC|3,a_set_release_est+1
	.word	 22
	LWL	SC13F03,AFUNC|3,a_no_shoot_button
	LW	SC13F04,3
	LW	SC13F05,3
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LW	SS43F10,2
	LW	SS43F03,2
	LWL	SC13F09,AFUNC|2,a_tshoot_done_1
	LW	SC13F10,2
	LW	SC13F11,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0
anim_spin_backhand_2
anim_spin_backhand_3
anim_spin_backhand_4
	LWWL	SC13F02,AFLIP|AFUNC|3,0,a_set_release_est+1
	.word	 22
	LWL	SC13F03,AFUNC|3,a_no_shoot_button
	LW	SC13F04,3
	LW	SC13F05,3
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LW	SS43F10,2
	LW	SS43F03,2
	LWL	SC13F09,AFUNC|2,a_tshoot_done_1
	LW	SC13F10,2
	LW	SC13F11,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0
anim_spin_backhand_6
anim_spin_backhand_7
anim_spin_backhand_8
	LWWL	SC13F02,AFLIP|AFUNC|3,M_FLIPH,a_set_release_est+1
	.word	 22
	LWL	SC13F03,AFUNC|3,a_no_shoot_button
	LW	SC13F04,3
	LW	SC13F05,3
	LW	SS43F07,2
	LW	SS43F08,2
	LW	SS43F09,2
	LW	SS43F10,2
	LW	SS43F03,2
	LWL	SC13F09,AFUNC|2,a_tshoot_done_1
	LW	SC13F10,2
	LW	SC13F11,2
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

;anim_wrap_down
;	LW	WR21F04,3
;	LWL	WR21F05,AFUNC|3,a_no_shoot_button
;	LW	WR21F06,3
;	LW	WR21F07,3
;	LW	WR21F08,3
;	LWL	WR21F09,AFUNC|3,a_shoot_done_1
;	LW	WR21F10,3
;	LW	WR21F11,3
;	LWL	1,AFUNC|1,a_shoot_done_2
;	.long	0
;
;anim_wrap_up
;	LW	WR25F04,3
;	LWL	WR25F05,AFUNC|3,a_no_shoot_button
;	LW	WR25F06,3
;	LW	WR25F07,3
;	LWL	WR25F08,AFUNC|3,a_shoot_done_1
;	LW	WR25F09,3
;	LW	WR25F10,3
;	LWL	1,AFUNC|1,a_shoot_done_2
;	.long	0

anim_sidesnap_1
anim_sidesnap_5
	LWL	FF13F01,AFUNC|3,a_set_release_est_r+3
	WL	15,a_set_15_flip
	LWL	FF13F02,AFUNC|3,a_no_shoot_button
	LW	FF13F03,3
	LW	FF13F04,3
	LW	FF13F05,3
	LWL	FF13F06,AFUNC|3,a_tshoot_done_1
	LW	FF13F07,3
	LW	FF13F08,7
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_sidesnap_2
anim_sidesnap_3
anim_sidesnap_4
	LWWL	FF13F01,AFLIP|AFUNC|3,0,a_set_release_est+1
	.word	15
	LWL	FF13F02,AFUNC|3,a_no_shoot_button
	LW	FF13F03,3
	LW	FF13F04,3
	LW	FF13F05,3
	LWL	FF13F06,AFUNC|3,a_tshoot_done_1
	LW	FF13F07,3
	LW	FF13F08,7
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

anim_sidesnap_6
anim_sidesnap_7
anim_sidesnap_8
	LWWL	FF13F01,AFLIP|AFUNC|3,M_FLIPH,a_set_release_est+1
	.word	15
	LWL	FF13F02,AFUNC|3,a_no_shoot_button
	LW	FF13F03,3
	LW	FF13F04,3
	LW	FF13F05,3
	LWL	FF13F06,AFUNC|3,a_tshoot_done_1
	LW	FF13F07,3
	LW	FF13F08,7
	LWL	1,AFUNC|1,a_tshoot_done_2
	.long	0

a_whoosh_sound
	jauc	whoosh_show

a_no_shoot_button
	move	*a8(ODT_PBK),a6,L	;get player block
	movi	no_shoot_release,a14
	move	a14,*a6(POF_SHOT_RELEASE),L
	rets
a_shoot_done_1
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	shoot_script_done_1
a_shoot_done_2
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	shoot_script_done_2
