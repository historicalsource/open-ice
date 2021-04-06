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
	.include	"hhscr_sh.e"
	.include	"hhscr_fn.g"
	.include	"hhcontrl.g"
	.include	"hhspeech.g"
	.include	"hhutil.g"
	.include	"hhscr_sk.g"
	.include	"hhpuck.g"
	.include	"hhplayer.g"
	.include	"hhgame.g"
	.include	"hhtimer.g"
;	.include	"hhmath.g"
	.ref	SAFEDIV
	.ref	SAFEMULT
	.include	"hhscr_ms.g"
	.include	"hhshow.g"
	.include	"hhscrsh2.g"

; end of include files

	.TEXT
	.EVEN

set_turbo_shoot_script
;	movi	-090000h,a0
;	move	a0,*a8(OYVEL),L
;	movi	[0,08100h],a0
;	move	a0,*a8(OYACCEL),L


	movb	*a6(POF_NUMBER),a0
	move	*a8(OXVEL),a1,L
	move	*a8(OZVEL),a2,L
	move	*a8(OXVAL),a3,L
	move	*a8(ODT_DIR),a4,L
	move	*a8(OZPOS),a5,W
	dec	a0
	srl	2,a0
	jrz	sll_t1
	neg	a1
	neg	a3
	addi	XD1800,a4
	neg	a4
sll_t1	THETA_H	a4
	callr	do_we_quick_release
	jrc	quick_release_turbo_shot
	move	a4,a14		;are we in a direct line with the goal
	abs	a14
	cmpi	XD0200,a14
	jrhs	slcd		; no
	cmpi	260,a5
	jrlt	slcd		; no
	cmpi	419,a5
	jrge	slcd		; no
	cmpi	[5,0],a1
	jrlt	sl__s
	cmpi	[300,0],a3
	jrlt	sl__ss		;special straight
	jruc	sl__s

;	jrlt	sl__s		; yes
slcd	cmpi	-XD0200,a4	;are we going down (< -20)
	jrgt	sl_nd		; no
	cmpi	-XD1600,a4
	jrlt	sl_nd		;no
	cmpi	339,a5		;are we low
	jrgt	sl__d		; no
	cmpi	[500,0],a3	;are we close
	jrgt	sl__dlc		; yes
	jruc	sl__dl		; no
sl_nd	move	a1,a1		;are we away
	jrnn	sl_na		; no
	cmpi	[500,0],a3	;are we close
	jrgt	sl__ac		; yes
	jruc	sl__a		;no
sl_na	cmpi	[500,0],a3	;are we close
	jrgt	sl__c		; yes
sl__o	movi	ss_other,a1		;NON SPECIAL CASE HERE
	jruc	ss_go
sl__s	movi	ss_straight_on,a1
	jruc	ss_go
sl__ss	movi	ss_special_straight_on,a1
	jruc	ss_go
sl__d	movi	ss_down,a1
	jruc	ss_go
sl__dlc	movi	ss_down_and_low_close,a1
	jruc	ss_go
sl__dl	movi	ss_down_and_low,a1
	jruc	ss_go
sl__ac	movi	ss_away_and_close,a1
	jruc	ss_go
sl__a	movi	ss_away,a1
	jruc	ss_go
sl__c	movi	ss_close,a1
ss_go	move	*a1+,a0,W
	calla	RAND0
	sll	5,a0
	add	a0,a1
	move	*a1,a0,L
	jump	a0

do_we_quick_release	;a3 = adjusted x
	move	@minutes,a14,W
	jrnz	dwcr2
	move	@tenseconds,a14,W
	jrnz	dwcr2
	move	@seconds,a14,W
	cmpi	3,a14
	jrls	dwcry
dwcr2	cmpi	[460,0],a3
	jrgt	dwcry
	clrc
	rets
dwcry	setc
	rets

quick_release_turbo_shot
	jruc	set_turbo_shoot_early_script

**************************************************************************
*								         *
* if straight on - s							 *
* if down								 *
*    if low								 *
*       if close - dlc							 *
*       else     - dl							 *
*    else	 - d							 *
* if away								 *
*    if close    - ac							 *
*    else	 - a							 *
* if close       - c							 *
* else	         - o							 *
*								         *
**************************************************************************

ss_straight_on
	.word	22+19
	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_spin_shot_script
	.long	set_spin_backhand_script
	.long	set_spin_backhand_script
	.long	set_spin_backhand_script
	.long	set_spin_slapshot_script
	.long	set_spin_slapshot_script

	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
	.long	set_trail_spin_shot_script
	.long	set_spin_slapshot_script
;	.long	set_scaleshoot_script
;	.long	set_scaletrail_shoot_script
;	.long	set_scaleshoot_script
;	.long	set_scaletrail_shoot_script
	.long	set_up_sommersault_shot_script
	.long	set_up_down_shot_script
	.long	set_up_sommersault_shot_script
	.long	set_up_down_shot_script

	.long	set_side_snapshot_script
	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_regular_slap_shot_script
	.long	set_regular_slap_shot_script
	.long	set_regular_slap_shot_script
	.long	set_pool_cue_shot_script
	.long	set_pool_cue_shot_script
	.long	set_pool_cue_shot_script
	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_spin_shot_script
	.long	set_spin_backhand_script
	.long	set_spin_backhand_script
	.long	set_spin_slapshot_script
	.long	set_spin_slapshot_script

ss_special_straight_on
	.word	24+24
	.long	set_tornado_shot_script
	.long	set_tornado_shot_script
	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script

	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
	.long	set_trail_spin_shot_script
	.long	set_spin_slapshot_script
;	.long	set_scaleshoot_script
;	.long	set_scaletrail_shoot_script
;	.long	set_scaleshoot_script
;	.long	set_scaletrail_shoot_script
	.long	set_up_sommersault_shot_script
	.long	set_up_down_shot_script
	.long	set_up_sommersault_shot_script
	.long	set_up_down_shot_script
	.long	set_up_sommersault_shot_script
	.long	set_up_down_shot_script
	.long	set_up_sommersault_shot_script
	.long	set_up_down_shot_script
	.long	set_up_sommersault_shot_script
	.long	set_up_down_shot_script
	.long	set_up_sommersault_shot_script
	.long	set_up_down_shot_script
	.long	set_up_sommersault_shot_script
	.long	set_up_down_shot_script
	.long	set_up_sommersault_shot_script
	.long	set_up_down_shot_script

	.long	set_side_snapshot_script
	.long	set_tornado_shot_script
	.long	set_tornado_shot_script
	.long	set_tornado_shot_script
	.long	set_tornado_shot_script
	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
	.long	set_turbo_backhand_script
	.long	set_spin_around_slapshot_script
	.long	set_regular_slap_shot_script
	.long	set_pool_cue_shot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_tornado_script
	.long	set_trail_tornado_script
	.long	set_spin_backhand_script
	.long	set_spin_backhand_script
	.long	set_spin_slapshot_script
	.long	set_spin_slapshot_script

ss_down_and_low_close
	.word	9+4
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script

	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_regular_slap_shot_script

ss_down_and_low
	.word	7+4
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script

	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_regular_slap_shot_script

ss_down
	.word	4+2
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script

	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_spin_around_slapshot_script
	.long	set_regular_slap_shot_script

ss_away_and_close
	.word	14+12
	.long	set_tornado_shot_script
	.long	set_tornado_shot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_tornado_script
	.long	set_trail_tornado_script
	.long	set_spin_backhand_script
	.long	set_spin_slapshot_script

	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
	.long	set_trail_spin_shot_script
	.long	set_spin_slapshot_script
;	.long	set_scaleshoot_script
;	.long	set_scaletrail_shoot_script
;	.long	set_scaleshoot_script
;	.long	set_scaletrail_shoot_script

	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_regular_slap_shot_script
	.long	set_tornado_shot_script
	.long	set_tornado_shot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_tornado_script
	.long	set_trail_tornado_script
	.long	set_spin_backhand_script
	.long	set_spin_slapshot_script

ss_away
	.word	13+9
	.long	set_tornado_shot_script
	.long	set_tornado_shot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_tornado_script
	.long	set_spin_backhand_script
	.long	set_spin_slapshot_script

	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
;	.long	set_scaleshoot_script
;	.long	set_scaletrail_shoot_script

	.long	set_turbo_backhand_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_regular_slap_shot_script
	.long	set_tornado_shot_script
	.long	set_tornado_shot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_spin_shot_script
	.long	set_trail_tornado_script
	.long	set_spin_backhand_script
	.long	set_spin_slapshot_script

ss_close
	.word	6+4
	.long	set_trail_spin_shot_script
	.long	set_trail_spin_shot_script

	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
;	.long	set_scaleshoot_script
;	.long	set_scaletrail_shoot_script

	.long	set_turbo_backhand_script
	.long	set_turbo_backhand_script
	.long	set_spin_around_slapshot_script
	.long	set_spin_around_slapshot_script
	.long	set_regular_slap_shot_script
	.long	set_trail_spin_shot_script

ss_other
	.word	10+6
	.long	set_trail_slapshot_script
	.long	set_trail_spin_shot_script
	.long	set_spin_backhand_script
	.long	set_spin_slapshot_script

	.long	set_trail_slapshot_script
	.long	set_trail_slapshot_script
;	.long	set_scaleshoot_script
;	.long	set_scaletrail_shoot_script

	.long	set_side_snapshot_script
	.long	set_turbo_backhand_script
	.long	set_spin_around_slapshot_script
	.long	set_regular_slap_shot_script
	.long	set_regular_slap_shot_script
	.long	set_regular_slap_shot_script
	.long	set_trail_slapshot_script
	.long	set_trail_spin_shot_script
	.long	set_spin_backhand_script
	.long	set_spin_slapshot_script

set_up_down_shot_script
	movi	suds_tab-32,a14
	jauc	start_panim_if_not_ta14

suds_tab
	.long	anim_up_down_shot_1
	.long	anim_up_down_shot_2
	.long	anim_up_down_shot_3
	.long	anim_up_down_shot_4
	.long	anim_up_down_shot_5
	.long	anim_up_down_shot_6
	.long	anim_up_down_shot_7
	.long	anim_up_down_shot_8

set_up_sommersault_shot_script
	movi	susss_tab-32,a14
	jauc	start_panim_if_not_ta14

susss_tab
	.long	anim_sommersault_shot_1
	.long	anim_sommersault_shot_2
	.long	anim_sommersault_shot_3
	.long	anim_sommersault_shot_4
	.long	anim_sommersault_shot_5
	.long	anim_sommersault_shot_6
	.long	anim_sommersault_shot_7
	.long	anim_sommersault_shot_8

set_wrist_shot_script
	mmtm	sp,a2
	clr	a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	swss_tab-32,a14
	jauc	start_panim_if_not_ta14

swss_tab
	.long	anim_wrist_shot_1
	.long	anim_wrist_shot_2
	.long	anim_wrist_shot_3
	.long	anim_wrist_shot_4
	.long	anim_wrist_shot_5
	.long	anim_wrist_shot_6
	.long	anim_wrist_shot_7
	.long	anim_wrist_shot_8

set_trail_spin_shot_script
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_TRAILS,a14
	move	a14,*a6(POF_FLAGS),W
	mmtm	sp,a2
	movk	4,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	sars_tab-32,a14
	jauc	start_panim_if_not_ta14

set_spin_around_slapshot_script
	mmtm	sp,a2
	movk	4,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	sars_tab-32,a14
	jauc	start_panim_if_not_ta14

sars_tab
	.long	anim_spin_around_slap_1
	.long	anim_spin_around_slap_2
	.long	anim_spin_around_slap_3
	.long	anim_spin_around_slap_4
	.long	anim_spin_around_slap_5
	.long	anim_spin_around_slap_6
	.long	anim_spin_around_slap_7
	.long	anim_spin_around_slap_8

set_trail_tornado_script
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_TRAILS,a14
	move	a14,*a6(POF_FLAGS),W
set_tornado_shot_script
	mmtm	sp,a2
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_CONTROLM,a14
	move	a14,*a6(POF_FLAGS),W
	movk	5,a2
	calla	spx_shot1
	mmfm	sp,a2
	calla	RANDOM
	sra	1,a0
	jrc	stss1
	movi	storscw_tab-32,a14
	jruc	stss2
stss1	movi	storsccw_tab-32,a14
stss2	jauc	start_panim_if_not_ta14

storsccw_tab
	.long	anim_tornadoccw_shot_1
	.long	anim_tornadoccw_shot_2
	.long	anim_tornadoccw_shot_3
	.long	anim_tornadoccw_shot_4
	.long	anim_tornadoccw_shot_5
	.long	anim_tornadoccw_shot_6
	.long	anim_tornadoccw_shot_7
	.long	anim_tornadoccw_shot_8

storscw_tab
	.long	anim_tornadocw_shot_1
	.long	anim_tornadocw_shot_2
	.long	anim_tornadocw_shot_3
	.long	anim_tornadocw_shot_4
	.long	anim_tornadocw_shot_5
	.long	anim_tornadocw_shot_6
	.long	anim_tornadocw_shot_7
	.long	anim_tornadocw_shot_8

set_turbo_backhand_script
	mmtm	sp,a2
	movk	3,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	stbs_tab-32,a14
	jauc	start_panim_if_not_ta14

stbs_tab
	.long	anim_turbo_backhand_1
	.long	anim_turbo_backhand_2
	.long	anim_turbo_backhand_3
	.long	anim_turbo_backhand_4
	.long	anim_turbo_backhand_5
	.long	anim_turbo_backhand_6
	.long	anim_turbo_backhand_7
	.long	anim_turbo_backhand_8

set_pool_cue_shot_script
	mmtm	sp,a2
	movk	5,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	spcs_tab-32,a14
	jauc	start_panim_if_not_ta14

spcs_tab
	.long	anim_pool_cue_script_1
	.long	anim_pool_cue_script_2
	.long	anim_pool_cue_script_3
	.long	anim_pool_cue_script_4
	.long	anim_pool_cue_script_5
	.long	anim_pool_cue_script_6
	.long	anim_pool_cue_script_7
	.long	anim_pool_cue_script_8

set_pass_script
	movi	sphs_tab-32,a14
	jauc	start_panim_if_not_ta14

sphs_tab
	.long	anim_pass_1
	.long	anim_pass_2
	.long	anim_pass_3
	.long	anim_pass_4
	.long	anim_pass_5
	.long	anim_pass_6
	.long	anim_pass_7
	.long	anim_pass_8

set_turbo_pass_script
	movi	spths_tab-32,a14
	jauc	start_panim_if_not_ta14

spths_tab
	.long	anim_tpass_1
	.long	anim_tpass_2
	.long	anim_tpass_3
	.long	anim_tpass_4
	.long	anim_tpass_5
	.long	anim_tpass_6
	.long	anim_tpass_7
	.long	anim_tpass_8

set_pass_early_script
	movi	spers_tab-32,a14
	jauc	start_panim_if_not_ta14

spers_tab
	.long	anim_pass_early_1
	.long	anim_pass_early_2
	.long	anim_pass_early_3
	.long	anim_pass_early_4
	.long	anim_pass_early_5
	.long	anim_pass_early_6
	.long	anim_pass_early_7
	.long	anim_pass_early_8

set_wrist_shot_down_script
	mmtm	sp,a2
	clr	a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	swsd_tab-32,a14
	jauc	start_panim_if_not_ta14

swsd_tab
	.long	anim_wrist_shot_down_1
	.long	anim_wrist_shot_down_2
	.long	anim_wrist_shot_down_3
	.long	anim_wrist_shot_down_4
	.long	anim_wrist_shot_down_5
	.long	anim_wrist_shot_down_6
	.long	anim_wrist_shot_down_7
	.long	anim_wrist_shot_down_8

set_backhand_shot_up_script
	mmtm	sp,a2
	movk	2,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	sbsu_tab-32,a14
	jauc	start_panim_if_not_ta14

sbsu_tab
	.long	anim_backhand_shot_up_1
	.long	anim_backhand_shot_up_2
	.long	anim_backhand_shot_up_3
	.long	anim_backhand_shot_up_4
	.long	anim_backhand_shot_up_5
	.long	anim_backhand_shot_up_6
	.long	anim_backhand_shot_up_7
	.long	anim_backhand_shot_up_8

set_slap_shot_down_script
	mmtm	sp,a2
	movk	1,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	sssd_tab-32,a14
	jauc	start_panim_if_not_ta14

sssd_tab
	.long	anim_slap_shot_down_1
	.long	anim_slap_shot_down_2
	.long	anim_slap_shot_down_3
	.long	anim_slap_shot_down_4
	.long	anim_slap_shot_down_5
	.long	anim_slap_shot_down_6
	.long	anim_slap_shot_down_7
	.long	anim_slap_shot_down_8

set_turbo_back_shot_up_script
	mmtm	sp,a2
	movk	3,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	stbsu_tab-32,a14
	jauc	start_panim_if_not_ta14

stbsu_tab
	.long	anim_turbo_backhand_shot_up_1
	.long	anim_turbo_backhand_shot_up_2
	.long	anim_turbo_backhand_shot_up_3
	.long	anim_turbo_backhand_shot_up_4
	.long	anim_turbo_backhand_shot_up_5
	.long	anim_turbo_backhand_shot_up_6
	.long	anim_turbo_backhand_shot_up_7
	.long	anim_turbo_backhand_shot_up_8

set_pass_left_thru_script
	movi	splts_tab-32,a14
	jauc	start_panim_if_not_ta14
splts_tab
	.long	anim_pass_1_7
	.long	anim_pass_thru_3_7
	.long	anim_pass_thru_3_7
	.long	anim_pass_thru_3_7
	.long	anim_pass_5_7
	.long	anim_pass_r3_r3
	.long	anim_pass_r3_r3
	.long	anim_pass_r3_r3

set_pass_left_thru_early_script
	movi	spltes_tab-32,a14
	jauc	start_panim_if_not_ta14

spltes_tab
	.long	anim_pass_early_1_7
	.long	anim_pass_thru_early_3_7
	.long	anim_pass_thru_early_3_7
	.long	anim_pass_thru_early_3_7
	.long	anim_pass_early_5_7
	.long	anim_pass_early_r3_r3
	.long	anim_pass_early_r3_r3
	.long	anim_pass_early_r3_r3

set_pass_left_script
	movi	spls_tab-32,a14
	jauc	start_panim_if_not_ta14

spls_tab
	.long	anim_pass_1_7
	.long	anim_pass_3_7
	.long	anim_pass_3_7
	.long	anim_pass_3_7
	.long	anim_pass_5_7
	.long	anim_pass_r3_r3
	.long	anim_pass_r3_r3
	.long	anim_pass_r3_r3

set_pass_left_early_script
	movi	sples_tab-32,a14
	jauc	start_panim_if_not_ta14

sples_tab
	.long	anim_pass_early_1_7
	.long	anim_pass_early_3_7
	.long	anim_pass_early_3_7
	.long	anim_pass_early_3_7
	.long	anim_pass_early_5_7
	.long	anim_pass_early_r3_r3
	.long	anim_pass_early_r3_r3
	.long	anim_pass_early_r3_r3

set_pass_right_thru_script
	movi	sprts_tab-32,a14
	jauc	start_panim_if_not_ta14
sprts_tab
	.long	anim_pass_1_3
	.long	anim_pass_3_3
	.long	anim_pass_3_3
	.long	anim_pass_3_3
	.long	anim_pass_5_3
	.long	anim_pass_thru_r3_r7
	.long	anim_pass_thru_r3_r7
	.long	anim_pass_thru_r3_r7

set_pass_right_thru_early_script
	movi	sprtes_tab-32,a14
	jauc	start_panim_if_not_ta14

sprtes_tab
	.long	anim_pass_early_1_3
	.long	anim_pass_early_3_3
	.long	anim_pass_early_3_3
	.long	anim_pass_early_3_3
	.long	anim_pass_early_5_3
	.long	anim_pass_thru_early_r3_r7
	.long	anim_pass_thru_early_r3_r7
	.long	anim_pass_thru_early_r3_r7

set_pass_right_script
	movi	sprs_tab-32,a14
	jauc	start_panim_if_not_ta14

sprs_tab
	.long	anim_pass_1_3
	.long	anim_pass_3_3
	.long	anim_pass_3_3
	.long	anim_pass_3_3
	.long	anim_pass_5_3
	.long	anim_pass_r3_r7
	.long	anim_pass_r3_r7
	.long	anim_pass_r3_r7

set_pass_right_early_script
	movi	spres_tab-32,a14
	jauc	start_panim_if_not_ta14

spres_tab
	.long	anim_pass_early_1_3
	.long	anim_pass_early_3_3
	.long	anim_pass_early_3_3
	.long	anim_pass_early_3_3
	.long	anim_pass_early_5_3
	.long	anim_pass_early_r3_r7
	.long	anim_pass_early_r3_r7
	.long	anim_pass_early_r3_r7

set_pass_up_script
	movi	spus_tab-32,a14
	jauc	start_panim_if_not_ta14

spus_tab
	.long	anim_pass_p3_1
	.long	anim_pass_3_1
	.long	anim_pass_3_1
	.long	anim_pass_3_1
	.long	anim_pass_p3_1
	.long	anim_pass_r3_1
	.long	anim_pass_r3_1
	.long	anim_pass_r3_1

set_pass_up_early_script
	movi	spues_tab-32,a14
	jauc	start_panim_if_not_ta14

spues_tab
	.long	anim_pass_early_p3_1
	.long	anim_pass_early_3_1
	.long	anim_pass_early_3_1
	.long	anim_pass_early_3_1
	.long	anim_pass_early_p3_1
	.long	anim_pass_early_r3_1
	.long	anim_pass_early_r3_1
	.long	anim_pass_early_r3_1

set_pass_down_script
	movi	spds_tab-32,a14
	jauc	start_panim_if_not_ta14

spds_tab
	.long	anim_pass_p3_5
	.long	anim_pass_3_5
	.long	anim_pass_3_5
	.long	anim_pass_3_5
	.long	anim_pass_p3_5
	.long	anim_pass_r3_5
	.long	anim_pass_r3_5
	.long	anim_pass_r3_5

set_pass_down_early_script
	movi	spdes_tab-32,a14
	jauc	start_panim_if_not_ta14

spdes_tab
	.long	anim_pass_early_p3_5
	.long	anim_pass_early_3_5
	.long	anim_pass_early_3_5
	.long	anim_pass_early_3_5
	.long	anim_pass_early_p3_5
	.long	anim_pass_early_r3_5
	.long	anim_pass_early_r3_5
	.long	anim_pass_early_r3_5

set_shoot_early_script
	mmtm	sp,a2
	clr	a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	ssehs_tab-32,a14
	jauc	start_panim_if_not_ta14

ssehs_tab
	.long	anim_shoot_early_1
	.long	anim_shoot_early_2
	.long	anim_shoot_early_3
	.long	anim_shoot_early_4
	.long	anim_shoot_early_5
	.long	anim_shoot_early_6
	.long	anim_shoot_early_7
	.long	anim_shoot_early_8

set_scaletrail_shoot_script
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_TRAILS,a14
	move	a14,*a6(POF_FLAGS),W
set_scaleshoot_script
	mmtm	sp,a2
	movk	1,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	scrshs_tab-32,a14
	jauc	start_panim_if_not_ta14

scrshs_tab
	.long	anim_scaleshoot_1
	.long	anim_scaleshoot_2
	.long	anim_scaleshoot_3
	.long	anim_scaleshoot_4
	.long	anim_scaleshoot_5
	.long	anim_scaleshoot_6
	.long	anim_scaleshoot_7
	.long	anim_scaleshoot_8

set_bscaleshoot_script
	mmtm	sp,a2
	movk	1,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	bscrshs_tab-32,a14
	jauc	start_panim_if_not_ta14

bscrshs_tab
	.long	anim_bscaleshoot_1
	.long	anim_bscaleshoot_2
	.long	anim_bscaleshoot_3
	.long	anim_bscaleshoot_4
	.long	anim_bscaleshoot_5
	.long	anim_bscaleshoot_6
	.long	anim_bscaleshoot_7
	.long	anim_bscaleshoot_8

set_side_snapshot_script
	mmtm	sp,a2
	clr	a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	sidesns_tab-32,a14
	jauc	start_panim_if_not_ta14
sidesns_tab
	.long	anim_sidesnap_1
	.long	anim_sidesnap_2
	.long	anim_sidesnap_3
	.long	anim_sidesnap_4
	.long	anim_sidesnap_5
	.long	anim_sidesnap_6
	.long	anim_sidesnap_7
	.long	anim_sidesnap_8

set_trail_slapshot_script
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_TRAILS,a14
	move	a14,*a6(POF_FLAGS),W
set_regular_slap_shot_script
	mmtm	sp,a2
	movk	1,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	ssths_tab-32,a14
	jauc	start_panim_if_not_ta14

ssths_tab
	.long	anim_trailshoot_1
	.long	anim_trailshoot_2
	.long	anim_trailshoot_3
	.long	anim_trailshoot_4
	.long	anim_trailshoot_5
	.long	anim_trailshoot_6
	.long	anim_trailshoot_7
	.long	anim_trailshoot_8

set_turbo_shoot_early_script
	mmtm	sp,a2
	movk	1,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	sseths_tab-32,a14
	jauc	start_panim_if_not_ta14

sseths_tab
	.long	anim_tshoot_early_1
	.long	anim_tshoot_early_2
	.long	anim_tshoot_early_3
	.long	anim_tshoot_early_4
	.long	anim_tshoot_early_5
	.long	anim_tshoot_early_6
	.long	anim_tshoot_early_7
	.long	anim_tshoot_early_8

set_onetime_script
	mmtm	sp,a0
	movi	200,a0
	calla	RANDPER
	jrnc	sos_rs1
	calla	RANDOM
	jrc	sos_rs3
	movi	soos2tab-32,a14
	jruc	sos_rs2
sos_rs3	movi	soos1tab-32,a14
	jruc	sos_rs2
sos_rs1	movi	sots_tab-32,a14
sos_rs2	calla	start_panim_if_not_ta14
	mmfm	sp,a0
	rets

sots_tab
	.long	anim_onetime_1
	.long	anim_onetime_2
	.long	anim_onetime_3
	.long	anim_onetime_4
	.long	anim_onetime_5
	.long	anim_onetime_6
	.long	anim_onetime_7
	.long	anim_onetime_8

soos1tab
	.long	anim_onespinccw_1
	.long	anim_onespinccw_2
	.long	anim_onespinccw_3
	.long	anim_onespinccw_4
	.long	anim_onespinccw_5
	.long	anim_onespinccw_6
	.long	anim_onespinccw_7
	.long	anim_onespinccw_8

soos2tab
	.long	anim_onespincw_1
	.long	anim_onespincw_2
	.long	anim_onespincw_3
	.long	anim_onespincw_4
	.long	anim_onespincw_5
	.long	anim_onespincw_6
	.long	anim_onespincw_7
	.long	anim_onespincw_8

set_faster_onetime_script
	movi	sotfs_tab-32,a14
	jauc	start_panim_if_not_ta14

sotfs_tab
	.long	anim_fonetime_1
	.long	anim_fonetime_2
	.long	anim_fonetime_3
	.long	anim_fonetime_4
	.long	anim_fonetime_5
	.long	anim_fonetime_6
	.long	anim_fonetime_7
	.long	anim_fonetime_8

set_a_fastest_onetime_script
	movi	satffs_tab-32,a14
	jauc	start_panim_if_not_ta14

satffs_tab
	.long	anim_fafonetime_1
	.long	anim_fafonetime_2
	.long	anim_fafonetime_3
	.long	anim_fafonetime_4
	.long	anim_fafonetime_5
	.long	anim_fafonetime_6
	.long	anim_fafonetime_7
	.long	anim_fafonetime_8

set_fastest_onetime_script
	movi	sotffs_tab-32,a14
	jauc	start_panim_if_not_ta14

sotffs_tab
	.long	anim_ffonetime_1
	.long	anim_ffonetime_2
	.long	anim_ffonetime_3
	.long	anim_ffonetime_4
	.long	anim_ffonetime_5
	.long	anim_ffonetime_6
	.long	anim_ffonetime_7
	.long	anim_ffonetime_8

set_immediate_onetime_script
	movi	sotfis_tab-32,a14
	jauc	start_panim_if_not_ta14

sotfis_tab
	.long	anim_fionetime_1
	.long	anim_fionetime_2
	.long	anim_fionetime_3
	.long	anim_fionetime_4
	.long	anim_fionetime_5
	.long	anim_fionetime_6
	.long	anim_fionetime_7
	.long	anim_fionetime_8

set_spin_slapshot_script
	mmtm	sp,a2
	movk	5,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	sspsp1_tab-32,a14
	jauc	start_panim_if_not_ta14
sspsp1_tab
	.long	anim_spin_slapshot_1
	.long	anim_spin_slapshot_2
	.long	anim_spin_slapshot_3
	.long	anim_spin_slapshot_4
	.long	anim_spin_slapshot_5
	.long	anim_spin_slapshot_6
	.long	anim_spin_slapshot_7
	.long	anim_spin_slapshot_8

set_spin_backhand_script
	mmtm	sp,a2
	movk	5,a2
	calla	spx_shot1
	mmfm	sp,a2
	movi	ssbhp1_tab-32,a14
	jauc	start_panim_if_not_ta14
ssbhp1_tab
	.long	anim_spin_backhand_1
	.long	anim_spin_backhand_2
	.long	anim_spin_backhand_3
	.long	anim_spin_backhand_4
	.long	anim_spin_backhand_5
	.long	anim_spin_backhand_6
	.long	anim_spin_backhand_7
	.long	anim_spin_backhand_8

;set_wraparound_up_script
;	movi	anim_wrap_up,a1
;	jauc	start_panim_if_not
;
;set_wraparound_down_script
;	movi	anim_wrap_down,a1
;	jauc	start_panim_if_not

