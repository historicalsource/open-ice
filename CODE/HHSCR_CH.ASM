 	.MLIB	"HHMACS.LIB"
	.FILE	"HHSCR_CH.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhscr_ch.tbl"
	.include	"hhscrmch.tbl"
	.include	"extras1.tbl"
	.include	"extras2.tbl"
	.include	"extras3.tbl"
	.include	"hhscr_ch.e"
	.include	"hhscr_fn.g"
	.include	"hhscrchf.g"
	.include	"hhshow.g"
	.include	"hhscr_sk.g"

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
set_gofly_script_a7
	mmtm	sp,a0,a1,a6,a8
	move	a7,a6
	move	*a6(POF_OBJECT),a8,L
	movi	sgfl_tab-32,a14
	calla	start_panim_if_not_ta14
	mmfm	sp,a0,a1,a6,a8
	rets

sgfl_tab
	.long	anim_fly_to_stomach_1
	.long	anim_fly_to_stomach_2
	.long	anim_fly_to_stomach_3
	.long	anim_fly_to_stomach_4
	.long	anim_fly_to_stomach_5
	.long	anim_fly_to_stomach_6
	.long	anim_fly_to_stomach_7
	.long	anim_fly_to_stomach_8

anim_fly_to_stomach_1
anim_fly_to_stomach_2
anim_fly_to_stomach_3
	LWWL	HC22F03,3|AFUNC|AFLIP,0,a_set_flyv_1
	LW	HD32F02,2
	LW	HD32F03,2
	LW	HD32F04,2
	LW	HD32F05,2
	LW	HD32F02,2
	LW	HD32F03,2
	LW	HC22F04,3
	LW	HC22F06,3
	LWL	HC22F07,AFUNC|3,a_screen_shake_snd
	LWL	HC22F08,AFUNC|3,zero_a8_y
	LW	HC22F10,3
	LW	HC22F12,3
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_stop_v
	LW	RA12F02,3
	LW	RA12F03,3
	LW	RA12F04,3
	LW	RA12F06,3
	LW	RA12F07,3
	LW	RA12F08,3
	LWL	1,AFUNC|3,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_fly_to_stomach_4
anim_fly_to_stomach_5
	LWWL	HC14F02,3|AFUNC|AFLIP,0,a_set_flyv_1
	LW	HD34F02,2
	LW	HD34F04,2
	LW	HD34F05,2
	LW	HD34F06,2
	LW	HD34F02,2
	LW	HD34F04,2
	LW	HC14F04,3
	LW	HC14F05,3
	LWL	HC14F06,AFUNC|3,a_screen_shake_snd
	LWL	HC14F07,AFUNC|3,zero_a8_y
	LW	HC14F08,3
	LW	HC14F10,3
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_stop_v
	LW	RA14F01,3
	LW	RA14F02,3
	LW	RA14F03,3
	LW	RA14F04,3
	LW	RA14F05,3
	LW	RA14F06,3
	LWL	1,AFUNC|3,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_fly_to_stomach_6
	LWWL	HC14F02,3|AFUNC|AFLIP,M_FLIPH,a_set_flyv_1
	LW	HD34F02,2
	LW	HD34F04,2
	LW	HD34F05,2
	LW	HD34F06,2
	LW	HD34F02,2
	LW	HD34F04,2
	LW	HC14F04,3
	LW	HC14F05,3
	LWL	HC14F06,AFUNC|3,a_screen_shake_snd
	LWL	HC14F07,AFUNC|3,zero_a8_y
	LW	HC14F08,3
	LW	HC14F10,3
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_stop_v
	LW	RA14F01,3
	LW	RA14F02,3
	LW	RA14F03,3
	LW	RA14F04,3
	LW	RA14F05,3
	LW	RA14F06,3
	LWL	1,AFUNC|3,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_fly_to_stomach_7
anim_fly_to_stomach_8
	LWWL	HC22F03,3|AFUNC|AFLIP,M_FLIPH,a_set_flyv_1
	LW	HD32F02,2
	LW	HD32F03,2
	LW	HD32F04,2
	LW	HD32F05,2
	LW	HD32F02,2
	LW	HD32F03,2
	LW	HC22F04,3
	LW	HC22F06,3
	LWL	HC22F07,AFUNC|3,a_screen_shake_snd
	LWL	HC22F08,AFUNC|3,zero_a8_y
	LW	HC22F10,3
	LW	HC22F12,3
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_slow_v
	LWL	1,AFUNC|4,a_stop_v
	LW	RA12F02,3
	LW	RA12F03,3
	LW	RA12F04,3
	LW	RA12F06,3
	LW	RA12F07,3
	LW	RA12F08,3
	LWL	1,AFUNC|3,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

set_elbow_script
	clr	a14
	move	a14,*a6(POF_HAS_CHECKED),W
	movi	set_elbow_team1,a0
	movb	*a6(POF_NUMBER),a14
	cmpi	4,a14
	jrls	se9i
	movi	set_elbow_team2,a0
se9i	jump	a0

set_elbow_team1
	movi	sebt1_tab-32,a14
	jauc	start_panim_if_not_ta14

sebt1_tab
	.long	anim_elbow_1_l
	.long	anim_elbow_2_l
	.long	anim_elbow_3_l
	.long	anim_elbow_4_l
	.long	anim_elbow_5_l
	.long	anim_elbow_6_l
	.long	anim_elbow_7_l
	.long	anim_elbow_8_l

set_elbow_team2
	movi	sebt2_tab-32,a14
	jauc	start_panim_if_not_ta14

sebt2_tab
	.long	anim_elbow_1_r
	.long	anim_elbow_2_r
	.long	anim_elbow_3_r
	.long	anim_elbow_4_r
	.long	anim_elbow_5_r
	.long	anim_elbow_6_r
	.long	anim_elbow_7_r
	.long	anim_elbow_8_r

set_1flipped_script_a7
	mmtm	sp,a0,a1,a6,a8
	move	a7,a6
	move	*a6(POF_OBJECT),a8,L
	movi	sflp_tab-32,a14
	calla	start_panim_if_not_ta14
	mmfm	sp,a0,a1,a6,a8
	rets

set_2flipped_script_a7
	mmtm	sp,a0,a1,a6,a8
	move	a7,a6
	move	*a6(POF_OBJECT),a8,L
	movi	sflp2tab-32,a14
	calla	start_panim_if_not_ta14
	mmfm	sp,a0,a1,a6,a8
	rets

sflp_tab
	.long	anim_get_1flipped_1
	.long	anim_get_1flipped_2
	.long	anim_get_1flipped_3
	.long	anim_get_1flipped_4
	.long	anim_get_1flipped_5
	.long	anim_get_1flipped_6
	.long	anim_get_1flipped_7
	.long	anim_get_1flipped_8

sflp2tab
	.long	anim_get_2flipped_1
	.long	anim_get_2flipped_2
	.long	anim_get_2flipped_3
	.long	anim_get_2flipped_4
	.long	anim_get_2flipped_5
	.long	anim_get_2flipped_6
	.long	anim_get_2flipped_7
	.long	anim_get_2flipped_8

set_fall_script
set_fall_to_stomach_script
	movi	sfts_tab-32,a14
	jauc	start_panim_if_not_ta14

sfts_tab
	.long	anim_fall_to_stomach_1
	.long	anim_fall_to_stomach_2
	.long	anim_fall_to_stomach_3
	.long	anim_fall_to_stomach_4
	.long	anim_fall_to_stomach_5
	.long	anim_fall_to_stomach_6
	.long	anim_fall_to_stomach_7
	.long	anim_fall_to_stomach_8

set_high_stick_script
	movi	shss_tab-32,a14
	jauc	start_panim_if_not_ta14

shss_tab
	.long	anim_high_stick_1
	.long	anim_high_stick_2
	.long	anim_high_stick_3
	.long	anim_high_stick_4
	.long	anim_high_stick_5
	.long	anim_high_stick_6
	.long	anim_high_stick_7
	.long	anim_high_stick_8

set_slash_script
	movi	ssl_tab-32,a14
	jauc	start_panim_if_not_ta14

ssl_tab
	.long	anim_slash_1
	.long	anim_slash_2
	.long	anim_slash_3
	.long	anim_slash_4
	.long	anim_slash_5
	.long	anim_slash_6
	.long	anim_slash_7
	.long	anim_slash_8

set_swing_script
	movi	ssws_tab-32,a14
	jauc	start_panim_if_not_ta14

ssws_tab
	.long	anim_swing_script_1
	.long	anim_swing_script_2
	.long	anim_swing_script_3
	.long	anim_swing_script_4
	.long	anim_swing_script_5
	.long	anim_swing_script_6
	.long	anim_swing_script_7
	.long	anim_swing_script_8

set_hip_check_up_script
	movi	shcub_tab-32,a14
	jauc	start_panim_if_not_ta14

shcub_tab
	.long	anim_hip_check_up_script_1
	.long	anim_hip_check_up_script_2
	.long	anim_hip_check_up_script_3
	.long	anim_hip_check_up_script_4
	.long	anim_hip_check_up_script_5
	.long	anim_hip_check_up_script_6
	.long	anim_hip_check_up_script_7
	.long	anim_hip_check_up_script_8

set_hip_check_down_script
	movi	shcdb_tab-32,a14
	jauc	start_panim_if_not_ta14

shcdb_tab
	.long	anim_hip_check_down_script_1
	.long	anim_hip_check_down_script_2
	.long	anim_hip_check_down_script_3
	.long	anim_hip_check_down_script_4
	.long	anim_hip_check_down_script_5
	.long	anim_hip_check_down_script_6
	.long	anim_hip_check_down_script_7
	.long	anim_hip_check_down_script_8

set_backward_sweep_check_script
	movi	sbsc_tab-32,a14
	jauc	start_panim_if_not_ta14

sbsc_tab
	.long	anim_back_sweep_check_script_1
	.long	anim_back_sweep_check_script_2
	.long	anim_back_sweep_check_script_3
	.long	anim_back_sweep_check_script_4
	.long	anim_back_sweep_check_script_5
	.long	anim_back_sweep_check_script_6
	.long	anim_back_sweep_check_script_7
	.long	anim_back_sweep_check_script_8

set_reverse_face_spear_script
	movi	sfsp_tab-32,a14
	jauc	start_panim_if_not_ta14
sfsp_tab
	.long	anim_rev_face_spear_1
	.long	anim_rev_face_spear_2
	.long	anim_rev_face_spear_3
	.long	anim_rev_face_spear_4
	.long	anim_rev_face_spear_5
	.long	anim_rev_face_spear_6
	.long	anim_rev_face_spear_7
	.long	anim_rev_face_spear_8

set_reverse_face_check_script
	movi	sfck_tab-32,a14
	jauc	start_panim_if_not_ta14
sfck_tab
	.long	anim_rev_face_check_1
	.long	anim_rev_face_check_2
	.long	anim_rev_face_check_3
	.long	anim_rev_face_check_4
	.long	anim_rev_face_check_5
	.long	anim_rev_face_check_6
	.long	anim_rev_face_check_7
	.long	anim_rev_face_check_8

set_steal_script
	movi	ssls_tab-32,a14
	jauc	start_panim_if_not_ta14

ssls_tab
	.long	anim_steal_1
	.long	anim_steal_2
	.long	anim_steal_3
	.long	anim_steal_4
	.long	anim_steal_5
	.long	anim_steal_6
	.long	anim_steal_7
	.long	anim_steal_8

set_shake_script
	movi	ssfs_tab-32,a14
	jauc	start_panim_if_not_ta14

ssfs_tab
	.long	anim_shake_1
	.long	anim_shake_2
	.long	anim_shake_3
	.long	anim_shake_4
	.long	anim_shake_5
	.long	anim_shake_6
	.long	anim_shake_7
	.long	anim_shake_8

set_push_script
	movi	ssps_tab-32,a14
	jauc	start_panim_if_not_ta14

ssps_tab
	.long	anim_push_1
	.long	anim_push_2
	.long	anim_push_3
	.long	anim_push_4
	.long	anim_push_5
	.long	anim_push_6
	.long	anim_push_7
	.long	anim_push_8

set_body_check_script
	movi	sbcp_tab-32,a14
	jauc	start_panim_if_not_ta14

sbcp_tab
	.long	anim_body_check_1
	.long	anim_body_check_2
	.long	anim_body_check_3
	.long	anim_body_check_4
	.long	anim_body_check_5
	.long	anim_body_check_6
	.long	anim_body_check_7
	.long	anim_body_check_8

set_body_check_wall_script
	movi	sbcw_tab-32,a14
	jauc	start_panim_if_not_ta14

sbcw_tab
	.long	anim_body_check_wall_1
	.long	anim_body_check_wall_2
	.long	anim_body_check_wall_3
	.long	anim_body_check_wall_4
	.long	anim_body_check_wall_5
	.long	anim_body_check_wall_6
	.long	anim_body_check_wall_7
	.long	anim_body_check_wall_8

set_body_check_down_script
	movi	sbcd_tab-32,a14
	jauc	start_panim_if_not_ta14

sbcd_tab
	.long	anim_body_check_down_1
	.long	anim_body_check_down_2
	.long	anim_body_check_down_3
	.long	anim_body_check_down_4
	.long	anim_body_check_down_5
	.long	anim_body_check_down_6
	.long	anim_body_check_down_7
	.long	anim_body_check_down_8

set_body_chkd_back_script
set_body_chkd_face_script
	movi	sbcfs_tab-32,a14
	jauc	start_panim_if_not_ta14

sbcfs_tab
	.long	anim_body_checked_face_1
	.long	anim_body_checked_face_2
	.long	anim_body_checked_face_3
	.long	anim_body_checked_face_4
	.long	anim_body_checked_face_5
	.long	anim_body_checked_face_6
	.long	anim_body_checked_face_7
	.long	anim_body_checked_face_8

set_body_chkd_back_wall_script
set_body_chkd_face_wall_script
	movi	sbcfws_tab-32,a14
	jauc	start_panim_if_not_ta14

sbcfws_tab
	.long	anim_body_checked_face_wall_1
	.long	anim_body_checked_face_wall_2
	.long	anim_body_checked_face_wall_3
	.long	anim_body_checked_face_wall_4
	.long	anim_body_checked_face_wall_5
	.long	anim_body_checked_face_wall_6
	.long	anim_body_checked_face_wall_7
	.long	anim_body_checked_face_wall_8

set_body_chkd_back_down_script
set_body_chkd_face_down_script
	movi	sbcfds_tab-32,a14
	jauc	start_panim_if_not_ta14

sbcfds_tab
	.long	anim_body_checked_face_down_1
	.long	anim_body_checked_face_down_2
	.long	anim_body_checked_face_down_3
	.long	anim_body_checked_face_down_4
	.long	anim_body_checked_face_down_5
	.long	anim_body_checked_face_down_6
	.long	anim_body_checked_face_down_7
	.long	anim_body_checked_face_down_8

;set_body_chkd_back_script
;	movi	sbcbs_tab-32,a14
;	jauc	start_panim_if_not_ta14
;
;sbcbs_tab
;	.long	anim_body_checked_back_1
;	.long	anim_body_checked_back_2
;	.long	anim_body_checked_back_3
;	.long	anim_body_checked_back_4
;	.long	anim_body_checked_back_5
;	.long	anim_body_checked_back_6
;	.long	anim_body_checked_back_7
;	.long	anim_body_checked_back_8
;
;set_body_chkd_back_wall_script
;	movi	sbcbws_tab-32,a14
;	jauc	start_panim_if_not_ta14
;
;sbcbws_tab
;	.long	anim_body_checked_back_wall_1
;	.long	anim_body_checked_back_wall_2
;	.long	anim_body_checked_back_wall_3
;	.long	anim_body_checked_back_wall_4
;	.long	anim_body_checked_back_wall_5
;	.long	anim_body_checked_back_wall_6
;	.long	anim_body_checked_back_wall_7
;	.long	anim_body_checked_back_wall_8
;
;set_body_chkd_back_down_script
;	movi	sbcbds_tab-32,a14
;	jauc	start_panim_if_not_ta14
;
;sbcbds_tab
;	.long	anim_body_checked_back_down_1
;	.long	anim_body_checked_back_down_2
;	.long	anim_body_checked_back_down_3
;	.long	anim_body_checked_back_down_4
;	.long	anim_body_checked_back_down_5
;	.long	anim_body_checked_back_down_6
;	.long	anim_body_checked_back_down_7
;	.long	anim_body_checked_back_down_8

set_whack_goalie_script
	movi	wckgl_tab-32,a14
	jauc	start_panim_if_not_ta14

wckgl_tab
	.long	anim_whack_goalie_1
	.long	anim_whack_goalie_2
	.long	anim_whack_goalie_3
	.long	anim_whack_goalie_4
	.long	anim_whack_goalie_5
	.long	anim_whack_goalie_6
	.long	anim_whack_goalie_7
	.long	anim_whack_goalie_8

anim_elbow_1_l
	LWW	TE31F01,5|AFLIP,0
	LWL	TE31F02,3|AFUNC,a_collision+6
	.long	[-10,60],[-50,50],get_elbowed
	LW	TE31F03,4
	LW	FI11F07,4
	LW	TE51F01,5
	LWL	TE51F02,3|AFUNC,a_collision+6
	.long	[-60,10],[-50,50],get_elbowed
	LW	TE51F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_1_r
	LWW	TE51F01,5|AFLIP,0
	LWL	TE51F02,3|AFUNC,a_collision+6
	.long	[-60,10],[-50,50],get_elbowed
	LW	TE51F03,4
	LW	FI11F07,4
	LW	TE31F01,5
	LWL	TE31F02,3|AFUNC,a_collision+6
	.long	[-10,60],[-50,50],get_elbowed
	LW	TE31F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_2_l
	LWW	TE12F01,5|AFLIP,0
	LWL	TE12F02,3|AFUNC,a_collision+6
	.long	[-10,45],[-10,45],get_elbowed
	LW	TE12F03,4
	LW	FI12F08,4
	LW	TE32F01,5
	LWL	TE32F02,3|AFUNC,a_collision+6
	.long	[-45,10],[-45,10],get_elbowed
	LW	TE32F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_2_r
	LWW	TE32F01,5|AFLIP,0
	LWL	TE32F02,3|AFUNC,a_collision+6
	.long	[-45,10],[-45,10],get_elbowed
	LW	TE32F03,4
	LW	FI12F08,4
	LW	TE12F01,5
	LWL	TE12F02,3|AFUNC,a_collision+6
	.long	[-10,45],[-10,45],get_elbowed
	LW	TE12F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_3_l
	LWW	TE23F01,5|AFLIP,0
	LWL	TE23F02,3|AFUNC,a_collision+6
	.long	[-50,50],[-10,60],get_elbowed
	LW	TE23F03,4
	LW	FI13F04,4
	LW	TE13F01,5
	LWL	TE13F02,3|AFUNC,a_collision+6
	.long	[-50,50],[-60,10],get_elbowed
	LW	TE13F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_3_r
	LWW	TE13F01,5|AFLIP,0
	LWL	TE13F02,3|AFUNC,a_collision+6
	.long	[-50,50],[-60,10],get_elbowed
	LW	TE13F03,4
	LW	FI13F04,4
	LW	TE23F01,5
	LWL	TE23F02,3|AFUNC,a_collision+6
	.long	[-50,50],[-10,60],get_elbowed
	LW	TE23F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_4_l
	LWW	TE64F01,5|AFLIP,0
	LWL	TE64F02,3|AFUNC,a_collision+6
	.long	[-45,10],[-10,45],get_elbowed
	LW	TE64F03,4
	LW	FI14F07,4
	LW	TE44F01,5
	LWL	TE44F02,3|AFUNC,a_collision+6
	.long	[-10,45],[-45,10],get_elbowed
	LW	TE44F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_4_r
	LWW	TE44F01,5|AFLIP,0
	LWL	TE44F02,3|AFUNC,a_collision+6
	.long	[-10,45],[-45,10],get_elbowed
	LW	TE44F03,4
	LW	FI14F07,4
	LW	TE64F01,5
	LWL	TE64F02,3|AFUNC,a_collision+6
	.long	[-45,10],[-10,45],get_elbowed
	LW	TE64F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_5_l
	LWW	TE25F01,5|AFLIP,0
	LWL	TE25F02,3|AFUNC,a_collision+6
	.long	[-60,10],[-50,50],get_elbowed
	LW	TE25F03,4
	LW	FI15F06,4
	LW	TE45F01,5
	LWL	TE45F02,3|AFUNC,a_collision+6
	.long	[-10,60],[-50,50],get_elbowed
	LW	TE45F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_5_r
	LWW	TE45F01,5|AFLIP,0
	LWL	TE45F02,3|AFUNC,a_collision+6
	.long	[-10,60],[-50,50],get_elbowed
	LW	TE45F03,4
	LW	FI15F06,4
	LW	TE25F01,5
	LWL	TE25F02,3|AFUNC,a_collision+6
	.long	[-60,10],[-50,50],get_elbowed
	LW	TE25F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_6_l
	LWW	TE44F01,5|AFLIP,M_FLIPH
	LWL	TE44F02,3|AFUNC,a_collision+6
	.long	[-45,10],[-45,10],get_elbowed
	LW	TE44F03,4
	LW	FI14F07,4
	LW	TE64F01,5
	LWL	TE64F02,3|AFUNC,a_collision+6
	.long	[-10,45],[-10,45],get_elbowed
	LW	TE64F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_6_r
	LWW	TE64F01,5|AFLIP,M_FLIPH
	LWL	TE64F02,3|AFUNC,a_collision+6
	.long	[-10,45],[-10,45],get_elbowed
	LW	TE64F03,4
	LW	FI14F07,4
	LW	TE44F01,5
	LWL	TE44F02,3|AFUNC,a_collision+6
	.long	[-45,10],[-45,10],get_elbowed
	LW	TE44F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_7_l
	LWW	TE13F01,5|AFLIP,M_FLIPH
	LWL	TE13F02,3|AFUNC,a_collision+6
	.long	[-50,50],[-60,10],get_elbowed
	LW	TE13F03,4
	LW	FI13F04,4
	LW	TE23F01,5
	LWL	TE23F02,3|AFUNC,a_collision+6
	.long	[-50,50],[-10,60],get_elbowed
	LW	TE23F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_7_r
	LWW	TE23F01,5|AFLIP,M_FLIPH
	LWL	TE23F02,3|AFUNC,a_collision+6
	.long	[-50,50],[-10,60],get_elbowed
	LW	TE23F03,4
	LW	FI13F04,4
	LW	TE13F01,5
	LWL	TE13F02,3|AFUNC,a_collision+6
	.long	[-50,50],[-60,10],get_elbowed
	LW	TE13F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_8_l
	LWW	TE32F01,5|AFLIP,M_FLIPH
	LWL	TE32F02,3|AFUNC,a_collision+6
	.long	[-10,45],[-45,10],get_elbowed
	LW	TE32F03,4
	LW	FI12F08,4
	LW	TE12F01,5
	LWL	TE12F02,3|AFUNC,a_collision+6
	.long	[-45,10],[-10,45],get_elbowed
	LW	TE12F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_elbow_8_r
	LWW	TE12F01,5|AFLIP,M_FLIPH
	LWL	TE12F02,3|AFUNC,a_collision+6
	.long	[-45,10],[-10,45],get_elbowed
	LW	TE12F03,4
	LW	FI12F08,4
	LW	TE32F01,5
	LWL	TE32F02,3|AFUNC,a_collision+6
	.long	[-10,45],[-45,10],get_elbowed
	LW	TE32F03,4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_get_2flipped_1
anim_get_2flipped_2
anim_get_2flipped_3
	LWWL	HD52F02,3|AFUNC|AFLIP,0,a_set_flipv_2
	LW	HD52F04,3
	LW	HD52F06,3
	LW	HD62F01,3
	LW	HD62F03,3
	LW	HD82F04b,3
	LW	HD52F02,3
	LW	HD52F04,3
	LW	HD52F06,3
	LW	HD62F01,3
	LW	HD62F03,3
	LW	HD92F05,3
	LW	HD92F07,3
	LWL	HD92F09,3|AFUNC,a_screen_shake_snd
	LWL	HE12F01,4|AFUNC,zero_a8_y
	LWL	HE11F01,4|AFUNC,a_slow_v
	LWWL	HE12F01,4|AFLIP|AFUNC,M_FLIPH,a_slow_v
	LWL	HE13F01,4|AFUNC,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWWL	HE15F01,4|AFLIP|AFUNC,0,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWL	HE13F01,4|AFUNC,a_slow_v
	LWL	HE12F01,4|AFUNC,a_slow_v
	LWL	HE12F02,4|AFUNC,a_stop_v
	LW	HE12F03,4
	LW	HE12F05,4
	LW	HE12F06,4
	LWL	HE12F07,4|AFUNC,a_maybe_spagetti
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_get_2flipped_4
anim_get_2flipped_5
	LWWL	HD44F02,3|AFUNC|AFLIP,0,a_set_flipv_1
	LW	HD44F05,3
	LW	HD44F08,3
	LW	HD54F02,3
	LW	HD64F06,3
	LW	HD64F03b,3
	LW	HD44F02,3
	LW	HD44F05,3
	LW	HD44F08,3
	LW	HD54F02,3
	LW	HD64F06,3
	LW	HD74F04,3
	LW	HD74F05,3
	LWL	HD74F06,3|AFUNC,a_screen_shake_snd
	LWL	HD74F07,4|AFUNC,zero_a8_y
	LWL	HE13F01,4|AFUNC,a_slow_v
	LWL	HE12F01,4|AFUNC,a_slow_v
	LWL	HE11F01,4|AFUNC,a_slow_v
	LWWL	HE12F01,4|AFLIP|AFUNC,M_FLIPH,a_slow_v
	LWL	HE13F01,4|AFUNC,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWWL	HE15F01,4|AFLIP|AFUNC,0,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWL	HE14F01,4|AFUNC,a_stop_v
	LW	HE14F02,4
	LW	HE14F04,4
	LW	HE14F06,4
	LWL	HE14F07,4|AFUNC,a_maybe_spagetti
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_get_2flipped_6
	LWWL	HD44F02,3|AFUNC|AFLIP,M_FLIPH,a_set_flipv_1
	LW	HD44F05,3
	LW	HD44F08,3
	LW	HD54F02,3
	LW	HD64F06,3
	LW	HD64F03b,3
	LW	HD44F02,3
	LW	HD44F05,3
	LW	HD44F08,3
	LW	HD54F02,3
	LW	HD64F06,3
	LW	HD74F04,3
	LW	HD74F05,3
	LWL	HD74F06,3|AFUNC,a_screen_shake_snd
	LWL	HD74F07,4|AFUNC,zero_a8_y
	LWL	HE13F01,4|AFUNC,a_slow_v
	LWL	HE12F01,4|AFUNC,a_slow_v
	LWL	HE11F01,4|AFUNC,a_slow_v
	LWWL	HE12F01,4|AFLIP|AFUNC,0,a_slow_v
	LWL	HE13F01,4|AFUNC,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWWL	HE15F01,4|AFLIP|AFUNC,M_FLIPH,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWL	HE14F01,4|AFUNC,a_stop_v
	LW	HE14F02,4
	LW	HE14F04,4
	LW	HE14F06,4
	LWL	HE14F07,4|AFUNC,a_maybe_spagetti
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_get_2flipped_7
anim_get_2flipped_8
	LWWL	HD52F02,3|AFUNC|AFLIP,M_FLIPH,a_set_flipv_2
	LW	HD52F04,3
	LW	HD52F06,3
	LW	HD62F01,3
	LW	HD62F03,3
	LW	HD82F04b,3
	LW	HD52F02,3
	LW	HD52F04,3
	LW	HD52F06,3
	LW	HD62F01,3
	LW	HD62F03,3
	LW	HD92F05,3
	LW	HD92F07,3
	LWL	HD92F09,3|AFUNC,a_screen_shake_snd
	LWL	HE12F01,4|AFUNC,zero_a8_y
	LWL	HE11F01,4|AFUNC,a_slow_v
	LWWL	HE12F01,4|AFLIP|AFUNC,0,a_slow_v
	LWL	HE13F01,4|AFUNC,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWWL	HE15F01,4|AFLIP|AFUNC,M_FLIPH,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWL	HE13F01,4|AFUNC,a_slow_v
	LWL	HE12F01,4|AFUNC,a_slow_v
	LWL	HE12F02,4|AFUNC,a_stop_v
	LW	HE12F03,4
	LW	HE12F05,4
	LW	HE12F06,4
	LWL	HE12F07,4|AFUNC,a_maybe_spagetti
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_get_1flipped_1
anim_get_1flipped_2
anim_get_1flipped_3
	LWWL	HD52F02,4|AFUNC|AFLIP,0,a_set_flipv_1
	LW	HD52F04,4
	LW	HD52F06,4
	LW	HD62F01,4
	LW	HD62F03,4
	LW	HD92F05,4
	LW	HD92F07,4
	LWL	HD92F09,4|AFUNC,a_screen_shake_snd
	LWL	HE12F01,4|AFUNC,zero_a8_y
	LWL	HE11F01,5|AFUNC,a_slow_v
	LWWL	HE12F01,4|AFLIP|AFUNC,M_FLIPH,a_slow_v
	LWL	HE13F01,5|AFUNC,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWWL	HE15F01,5|AFLIP|AFUNC,0,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWL	HE13F01,5|AFUNC,a_slow_v
	LWL	HE12F01,4|AFUNC,a_slow_v
	LWL	HE12F02,4|AFUNC,a_stop_v
	LW	HE12F03,4
	LW	HE12F05,4
	LW	HE12F06,4
	LW	HE12F07,4
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_get_1flipped_4
anim_get_1flipped_5
	LWWL	HD44F02,4|AFUNC|AFLIP,0,a_set_flipv_1
	LW	HD44F05,4
	LW	HD44F08,4
	LW	HD54F02,4
	LW	HD64F06,4
	LW	HD74F04,4
	LW	HD74F05,4
	LWL	HD74F06,4|AFUNC,a_screen_shake_snd
	LWL	HD74F07,4|AFUNC,zero_a8_y
	LWL	HE13F01,4|AFUNC,a_slow_v
	LWL	HE12F01,4|AFUNC,a_slow_v
	LWL	HE11F01,4|AFUNC,a_slow_v
	LWWL	HE12F01,4|AFLIP|AFUNC,M_FLIPH,a_slow_v
	LWL	HE13F01,4|AFUNC,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWWL	HE15F01,4|AFLIP|AFUNC,0,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWL	HE14F01,4|AFUNC,a_stop_v
	LW	HE14F02,4
	LW	HE14F04,4
	LW	HE14F06,4
	LW	HE14F07,4
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_get_1flipped_6
	LWWL	HD44F02,4|AFUNC|AFLIP,M_FLIPH,a_set_flipv_1
	LW	HD44F05,4
	LW	HD44F08,4
	LW	HD54F02,4
	LW	HD64F06,4
	LW	HD74F04,4
	LW	HD74F05,4
	LWL	HD74F06,4|AFUNC,a_screen_shake_snd
	LWL	HD74F07,4|AFUNC,zero_a8_y
	LWL	HE13F01,4|AFUNC,a_slow_v
	LWL	HE12F01,4|AFUNC,a_slow_v
	LWL	HE11F01,4|AFUNC,a_slow_v
	LWWL	HE12F01,4|AFLIP|AFUNC,0,a_slow_v
	LWL	HE13F01,4|AFUNC,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWWL	HE15F01,4|AFLIP|AFUNC,M_FLIPH,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWL	HE14F01,4|AFUNC,a_stop_v
	LW	HE14F02,4
	LW	HE14F04,4
	LW	HE14F06,4
	LW	HE14F07,4
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_get_1flipped_7
anim_get_1flipped_8
	LWWL	HD52F02,4|AFUNC|AFLIP,M_FLIPH,a_set_flipv_1
	LW	HD52F04,4
	LW	HD52F06,4
	LW	HD62F01,4
	LW	HD62F03,4
	LW	HD92F05,4
	LW	HD92F07,4
	LWL	HD92F09,4|AFUNC,a_screen_shake_snd
	LWL	HE12F01,4|AFUNC,zero_a8_y
	LWL	HE11F01,5|AFUNC,a_slow_v
	LWWL	HE12F01,4|AFLIP|AFUNC,0,a_slow_v
	LWL	HE13F01,5|AFUNC,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWWL	HE15F01,5|AFLIP|AFUNC,M_FLIPH,a_slow_v
	LWL	HD74F07,4|AFUNC,a_slow_v
	LWL	HE13F01,5|AFUNC,a_slow_v
	LWL	HE12F01,4|AFUNC,a_slow_v
	LWL	HE12F02,4|AFUNC,a_stop_v
	LW	HE12F03,4
	LW	HE12F05,4
	LW	HE12F06,4
	LW	HE12F07,4
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_fall_to_stomach_2
anim_fall_to_stomach_3
af231	LWW	HC22F03,AFLIP|3,0
	LWL	HC22F04,AFUNC|1,a_start_get_up_count
	LW	HC22F06,3
	LWL	HC22F07,AFUNC|3,body_fall_sound
	LWL	HC22F08,AFUNC|3,a_fall_stopv
	LW	HC22F10,3
af232	LWL	HC22F12,AFUNC|1,a_wait_get_up+4
	.long	 af231,af232
	LW	RA12F02,3
	LW	RA12F03,3
	LW	RA12F04,3
	LW	RA12F06,3
	LW	RA12F07,3
	LW	RA12F08,3
	LWL	1,AFUNC|3,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0
anim_fall_to_stomach_4
af41	LWW	HC14F02,AFLIP|3,0
	LWL	HC14F04,AFUNC|1,a_start_get_up_count
	LW	HC14F05,3
	LWL	HC14F06,AFUNC|3,body_fall_sound
	LWL	HC14F07,AFUNC|3,a_fall_stopv
	LW	HC14F08,3
af42	LWL	HC14F10,AFUNC|1,a_wait_get_up+4
	.long	 af41,af42
	LW	RA14F01,3
	LW	RA14F02,3
	LW	RA14F03,3
	LW	RA14F04,3
	LW	RA14F05,3
	LW	RA14F06,3
	LWL	1,AFUNC|3,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_fall_to_stomach_6
af61	LWW	HC14F02,AFLIP|3,M_FLIPH
	LWL	HC14F04,AFUNC|1,a_start_get_up_count
	LW	HC14F05,3
	LWL	HC14F06,AFUNC|3,body_fall_sound
	LWL	HC14F07,AFUNC|3,a_fall_stopv
	LW	HC14F08,3
af62	LWL	HC14F10,AFUNC|1,a_wait_get_up+4
	.long	 af61,af62
	LW	RA14F01,3
	LW	RA14F02,3
	LW	RA14F03,3
	LW	RA14F04,3
	LW	RA14F05,3
	LW	RA14F06,3
	LWL	1,AFUNC|3,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_fall_to_stomach_7
anim_fall_to_stomach_8
af781	LWW	HC22F03,AFLIP|3,M_FLIPH
	LWL	HC22F04,AFUNC|1,a_start_get_up_count
	LW	HC22F06,3
	LWL	HC22F07,AFUNC|3,body_fall_sound
	LWL	HC22F08,AFUNC|3,a_fall_stopv
	LW	HC22F10,3
af782	LWL	HC22F12,AFUNC|1,a_wait_get_up+4
	.long	 af781,af782
	LW	RA12F02,3
	LW	RA12F03,3
	LW	RA12F04,3
	LW	RA12F06,3
	LW	RA12F07,3
	LW	RA12F08,3
	LWL	1,AFUNC|3,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_fall_to_stomach_1
af11	LWL	HC22F03,3|AFUNC,a_set_15_flip
	LWL	HC22F04,AFUNC|1,a_start_get_up_count
	LW	HC22F06,3
	LWL	HC22F07,AFUNC|3,body_fall_sound
	LWL	HC22F08,AFUNC|3,a_fall_stopv
	LW	HC22F10,3
af12	LWL	HC22F12,AFUNC|1,a_wait_get_up+4
	.long	 af11,af12
	LW	RA12F02,3
	LW	RA12F03,3
	LW	RA12F04,3
	LW	RA12F06,3
	LW	RA12F07,3
	LW	RA12F08,3
	LWL	1,AFUNC|3,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0
anim_fall_to_stomach_5
af51	LWL	HC14F02,3|AFUNC,a_set_15_flip
	LWL	HC14F04,AFUNC|1,a_start_get_up_count
	LW	HC14F05,3
	LWL	HC14F06,AFUNC|3,body_fall_sound
	LWL	HC14F07,AFUNC|3,a_fall_stopv
	LW	HC14F08,3
af52	LWL	HC14F10,AFUNC|1,a_wait_get_up+4
	.long	 af51,af52
	LW	RA14F01,3
	LW	RA14F02,3
	LW	RA14F03,3
	LW	RA14F04,3
	LW	RA14F05,3
	LW	RA14F06,3
	LWL	1,AFUNC|3,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0
anim_high_stick_1
	LWL	CD23F01,AFUNC|3,a_flip_accelerate_start+3
	.word	0,-40,8
	LW	CD23F02,3
	LW	CD23F03,3
	LWL	CD23F05,AFUNC|3,a_collision+6
	.long	[-50,50],[-80,10],get_highsticked
	LW	CD23F06,2
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CD23F07,3
	LW	CD23F08,3
	LW	CD23F09,3
	LW	CD23F11,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_high_stick_2
	LWWL	CD23F01,AFUNC|AFLIP|3,0,a_accelerate_start+3
	.word	30,-30,8
	LW	CD23F02,3
	LW	CD23F03,3
	LWL	CD23F05,AFUNC|3,a_collision+6
	.long	[-10,65],[-65,10],get_highsticked
	LW	CD23F06,2
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CD23F07,3
	LW	CD23F08,3
	LW	CD23F09,3
	LW	CD23F11,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_high_stick_3
	LWWL	CD23F01,AFUNC|AFLIP|3,0,a_accelerate_start+3
	.word	40,0,8
	LW	CD23F02,3
	LW	CD23F03,3
	LWL	CD23F05,AFUNC|3,a_collision+6
	.long	[-10,80],[-50,50],get_highsticked
	LW	CD23F06,2
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CD23F07,3
	LW	CD23F08,3
	LW	CD23F09,3
	LW	CD23F11,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_high_stick_4
	LWWL	CD23F01,AFUNC|AFLIP|3,0,a_accelerate_start+3
	.word	30,30,8
	LW	CD23F02,3
	LW	CD23F03,3
	LWL	CD23F05,AFUNC|3,a_collision+6
	.long	[-10,65],[-10,65],get_highsticked
	LW	CD23F06,2
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CD23F07,3
	LW	CD23F08,3
	LW	CD23F09,3
	LW	CD23F11,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_high_stick_5
	LWL	CD23F01,AFUNC|3,a_flip_accelerate_start+3
	.word	0,40,8
	LW	CD23F02,3
	LW	CD23F03,3
	LWL	CD23F05,AFUNC|3,a_collision+6
	.long	[-50,50],[-10,80],get_highsticked
	LW	CD23F06,2
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CD23F07,3
	LW	CD23F08,3
	LW	CD23F09,3
	LW	CD23F11,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_high_stick_6
	LWWL	CD23F01,AFUNC|AFLIP|3,M_FLIPH,a_accelerate_start+3
	.word	-30,30,8
	LW	CD23F02,3
	LW	CD23F03,3
	LWL	CD23F05,AFUNC|3,a_collision+6
	.long	[-65,10],[-10,65],get_highsticked
	LW	CD23F06,2
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CD23F07,3
	LW	CD23F08,3
	LW	CD23F09,3
	LW	CD23F11,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_high_stick_7
	LWWL	CD23F01,AFUNC|AFLIP|3,M_FLIPH,a_accelerate_start+3
	.word	-40,0,8
	LW	CD23F02,3
	LW	CD23F03,3
	LWL	CD23F05,AFUNC|3,a_collision+6
	.long	[-80,10],[-50,50],get_highsticked
	LW	CD23F06,2
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CD23F07,3
	LW	CD23F08,3
	LW	CD23F09,3
	LW	CD23F11,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_high_stick_8
	LWWL	CD23F01,AFUNC|AFLIP|3,M_FLIPH,a_accelerate_start+3
	.word	-30,-30,8
	LW	CD23F02,3
	LW	CD23F03,3
	LWL	CD23F05,AFUNC|3,a_collision+6
	.long	[-65,10],[-65,10],get_highsticked
	LW	CD23F06,2
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CD23F07,3
	LW	CD23F08,3
	LW	CD23F09,3
	LW	CD23F11,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_slash_1
	LWL	CB12F01,AFUNC|3,a_set_15_flip
	LW	CB12F02,3
	LW	CB12F03,3
	LW	CB12F04,3
	LW	CB12F05,3
	LW	CB12F06,3
	LWL	CB12F07,AFUNC|3,a_collision+6
	.long	[-50,50],[-80,10],get_slashed
	LW	CB12F05,3
	LW	CB12F02,3
	LW	CB12F01,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_slash_2
	LWW	CB12F01,AFLIP|3,0
	LW	CB12F02,3
	LW	CB12F03,3
	LW	CB12F04,3
	LW	CB12F05,3
	LW	CB12F06,3
	LWL	CB12F07,AFUNC|3,a_collision+6
	.long	[-10,65],[-65,10],get_slashed
	LW	CB12F05,3
	LW	CB12F02,3
	LW	CB12F01,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_slash_3
	LWW	CB13F01,AFLIP|3,0
	LW	CB13F02,3
	LW	CB13F03,3
	LW	CB13F04,3
	LW	CB13F05,3
	LWL	CB13F06,AFUNC|3,a_collision+6
	.long	[-10,80],[-50,50],get_slashed
	LW	CB13F05,3
	LW	CB13F02,3
	LW	CB13F01,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_slash_4
	LWW	CB14F01,AFLIP|3,0
	LW	CB14F02,3
	LW	CB14F03,3
	LW	CB14F04,3
	LW	CB14F05,3
	LWL	CB14F06,AFUNC|3,a_collision+6
	.long	[-10,65],[-10,65],get_slashed
	LW	CB14F05,3
	LW	CB14F02,3
	LW	CB14F01,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_slash_5
	LWL	CB14F01,AFUNC|3,a_set_15_flip
	LW	CB14F02,3
	LW	CB14F03,3
	LW	CB14F04,3
	LW	CB14F05,3
	LWL	CB14F06,AFUNC|3,a_collision+6
	.long	[-50,50],[-10,80],get_slashed
	LW	CB14F05,3
	LW	CB14F02,3
	LW	CB14F01,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_slash_6
	LWW	CB14F01,AFLIP|3,M_FLIPH
	LW	CB14F02,3
	LW	CB14F03,3
	LW	CB14F04,3
	LW	CB14F05,3
	LWL	CB14F06,AFUNC|3,a_collision+6
	.long	[-65,10],[-10,65],get_slashed
	LW	CB14F05,3
	LW	CB14F02,3
	LW	CB14F01,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_slash_7
	LWW	CB13F01,AFLIP|3,M_FLIPH
	LW	CB13F02,3
	LW	CB13F03,3
	LW	CB13F04,3
	LW	CB13F05,3
	LWL	CB13F06,AFUNC|3,a_collision+6
	.long	[-80,10],[-50,50],get_slashed
	LW	CB13F05,3
	LW	CB13F02,3
	LW	CB13F01,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_slash_8
	LWW	CB12F01,AFLIP|3,M_FLIPH
	LW	CB12F02,3
	LW	CB12F03,3
	LW	CB12F04,3
	LW	CB12F05,3
	LW	CB12F06,3
	LWL	CB12F07,AFUNC|3,a_collision+6
	.long	[-65,10],[-65,10],get_slashed
	LW	CB12F05,3
	LW	CB12F02,3
	LW	CB12F01,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_swing_script_1
anim_swing_script_5
	LWL	CE13F02,AFUNC|3,a_set_15_flip
	LW	CE13F04,3
	LWL	CE13F05,AFUNC|3,a_collision+6
	.long	 [-10,50],[0,110],get_highsticked
	LWL	CE13F07,AFUNC|3,a_collision+6
	.long	 [-10,100],[-50,50],get_highsticked
	LWL	CE13F08,AFUNC|3,a_collision+6
	.long	 [-10,50],[-110,0],get_highsticked
	LW	CE13F09,3
	LW	CE13F10,3
	LW	CE13F11,3
	LW	CE13F12,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_swing_script_2
anim_swing_script_3
anim_swing_script_4
	LWW	CE13F02,AFLIP|3,0
	LW	CE13F04,3
	LWL	CE13F05,AFUNC|3,a_collision+6
	.long	 [-10,50],[0,110],get_highsticked
	LWL	CE13F07,AFUNC|3,a_collision+6
	.long	 [-10,100],[-50,50],get_highsticked
	LWL	CE13F08,AFUNC|3,a_collision+6
	.long	 [-10,50],[-110,0],get_highsticked
	LW	CE13F09,3
	LW	CE13F10,3
	LW	CE13F11,3
	LW	CE13F12,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0


anim_swing_script_6
anim_swing_script_7
anim_swing_script_8
	LWW	CE13F02,AFLIP|3,M_FLIPH
	LW	CE13F04,3
	LWL	CE13F05,AFUNC|3,a_collision+6
	.long	 [-50,10],[0,110],get_highsticked
	LWL	CE13F07,AFUNC|3,a_collision+6
	.long	 [-100,10],[-50,50],get_highsticked
	LWL	CE13F08,AFUNC|3,a_collision+6
	.long	 [-50,10],[-110,0],get_highsticked
	LW	CE13F09,3
	LW	CE13F10,3
	LW	CE13F11,3
	LW	CE13F12,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0


anim_hip_check_up_script_1
anim_hip_check_up_script_2
anim_hip_check_up_script_3
anim_hip_check_up_script_4
anim_hip_check_up_script_5
anim_hip_check_up_script_6
anim_hip_check_up_script_7
anim_hip_check_up_script_8
	LWL	AF13F03,AFUNC|1,a_slow_us
	LWL	1,AFUNC|1,a_slow_us
	LWL	1,AFUNC|1,a_slow_us
	LWL	AF13F04,AFUNC|1,a_slow_us
	LWL	1,AFUNC|1,a_slow_us
	LWL	1,AFUNC|1,a_slow_us
	LWL	AF13F06,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	AF13F09,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	AF13F11,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-5,60],get_hipped
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_hip_check_down_script_1
anim_hip_check_down_script_2
anim_hip_check_down_script_3
anim_hip_check_down_script_4
anim_hip_check_down_script_5
anim_hip_check_down_script_6
anim_hip_check_down_script_7
anim_hip_check_down_script_8
	LWL	AF23F02,AFUNC|1,a_slow_us
	LWL	1,AFUNC|1,a_slow_us
	LWL	1,AFUNC|1,a_slow_us
	LWL	AF23F04,AFUNC|1,a_slow_us
	LWL	1,AFUNC|1,a_slow_us
	LWL	1,AFUNC|1,a_slow_us
	LWL	AF23F05,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	AF23F07,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	AF23F09,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_slow_us_chk+6
	.long	[-40,40],[-60,5],get_hipped
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_back_sweep_check_script_1
anim_back_sweep_check_script_5
	LW	AE73F07,6
	LW	AE73F09,4
	LW	AE73F10,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0

anim_back_sweep_check_script_2
	LWWL	AE42F02,AFLIP|AFUNC|2,0,a_collision_puck+6
	.long	[-10,100],[-100,10],take_puck_or_free_only
	LWL	AE42F02,AFUNC|2,a_collision_puck+6
	.long	[-10,100],[-100,10],take_puck_or_free_only
	LWL	AE42F02,AFUNC|1,a_collision_puck+6
	.long	[-10,100],[-100,10],take_puck_or_free_only
	LWL	1,1|AFUNC,a_sound_for_steal
	LW	AE42F03,4
	LW	AE42F04,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0

anim_back_sweep_check_script_3
	LWWL	AE73F07,AFLIP|AFUNC|2,0,a_collision_puck+6
	.long	[-10,140],[-40,40],take_puck_or_free_only
	LWL	AE73F07,AFUNC|2,a_collision_puck+6
	.long	[-10,140],[-40,40],take_puck_or_free_only
	LWL	AE73F07,AFUNC|1,a_collision_puck+6
	.long	[-10,140],[-40,40],take_puck_or_free_only
	LWL	1,1|AFUNC,a_sound_for_steal
	LW	AE73F09,4
	LW	AE73F10,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0

anim_back_sweep_check_script_4
	LWWL	AE24F02,AFLIP|AFUNC|2,0,a_collision_puck+6
	.long	[-10,100],[-10,100],take_puck_or_free_only
	LWL	AE24F02,AFUNC|2,a_collision_puck+6
	.long	[-10,100],[-10,100],take_puck_or_free_only
	LWL	AE24F02,AFUNC|1,a_collision_puck+6
	.long	[-10,100],[-10,100],take_puck_or_free_only
	LWL	1,1|AFUNC,a_sound_for_steal
	LW	AE24F03,4
	LW	AE24F04,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0

anim_back_sweep_check_script_6
	LWWL	AE24F02,AFLIP|AFUNC|2,M_FLIPH,a_collision_puck+6
	.long	[-100,10],[-10,100],take_puck_or_free_only
	LWL	AE24F02,AFUNC|2,a_collision_puck+6
	.long	[-100,10],[-10,100],take_puck_or_free_only
	LWL	AE24F02,AFUNC|1,a_collision_puck+6
	.long	[-100,10],[-10,100],take_puck_or_free_only
	LWL	1,1|AFUNC,a_sound_for_steal
	LW	AE24F03,4
	LW	AE24F04,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0

anim_back_sweep_check_script_7
	LWWL	AE73F07,AFLIP|AFUNC|2,M_FLIPH,a_collision_puck+6
	.long	[-140,10],[-40,40],take_puck_or_free_only
	LWL	AE73F07,AFUNC|2,a_collision_puck+6
	.long	[-140,10],[-40,40],take_puck_or_free_only
	LWL	AE73F07,AFUNC|1,a_collision_puck+6
	.long	[-140,10],[-40,40],take_puck_or_free_only
	LWL	1,1|AFUNC,a_sound_for_steal
	LW	AE73F09,4
	LW	AE73F10,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0

anim_back_sweep_check_script_8
	LWWL	AE42F02,AFLIP|AFUNC|2,M_FLIPH,a_collision_puck+6
	.long	[-100,10],[-100,10],take_puck_or_free_only
	LWL	AE42F02,AFUNC|2,a_collision_puck+6
	.long	[-100,10],[-100,10],take_puck_or_free_only
	LWL	AE42F02,AFUNC|1,a_collision_puck+6
	.long	[-100,10],[-100,10],take_puck_or_free_only
	LWL	1,1|AFUNC,a_sound_for_steal
	LW	AE42F03,4
	LW	AE42F04,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0

anim_rev_face_spear_1
anim_rev_face_spear_5
	LW	FP63F01,3
	LW	FP63F04,3
	LW	FP63F06,3
	LW	FP63F08,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_rev_face_spear_2
anim_rev_face_spear_3
anim_rev_face_spear_4
	LWW	FP63F01,AFLIP|3,0
	LW	FP63F04,3
	LW	FP63F06,3
	LW	FP63F08,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_rev_face_spear_6
anim_rev_face_spear_7
anim_rev_face_spear_8
	LWW	FP63F01,AFLIP|3,M_FLIPH
	LW	FP63F04,3
	LW	FP63F06,3
	LW	FP63F08,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_rev_face_check_1
anim_rev_face_check_5
	LW	FP73F04,3
	LW	FP73F07,3
	LW	FP73F08,3
	LW	FP73F10,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_rev_face_check_2
anim_rev_face_check_3
anim_rev_face_check_4
	LW	FP73F04,AFLIP|3,0
	LW	FP73F07,3
	LW	FP73F08,3
	LW	FP73F10,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_rev_face_check_6
anim_rev_face_check_7
anim_rev_face_check_8
	LW	FP73F04,AFLIP|3,M_FLIPH
	LW	FP73F07,3
	LW	FP73F08,3
	LW	FP73F10,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_shake_1
anim_shake_5
	LWL	HB14F03,3|AFUNC,a_set_15_flip
	LW	HB14F04,3
	LW	HB14F05,3
	LW	HB14F06,3
	LWL	HB14F07,AFUNC|3,a_fall_stopv
	LW	HB14F08,3
	LW	HB14F10,3
	LW	HB14F11,3
	LWL	1,AFUNC|4,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_shake_2
anim_shake_3
	LWW	HA12F02,AFLIP|3,0
	LW	HA12F04,3
	LW	HA12F06,3
	LW	HA12F07,3
	LW	HA12F08,3
	LWL	HA12F09,AFUNC|3,a_fall_stopv
	LW	HA12F10,3
	LW	HA12F12,3
	LW	HA12F14,3
	LW	HA12F16,3
	LWL	1,AFUNC|4,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_shake_4
	LWW	HB14F03,AFLIP|3,0
	LW	HB14F04,3
	LW	HB14F05,3
	LW	HB14F06,3
	LWL	HB14F07,AFUNC|3,a_fall_stopv
	LW	HB14F08,3
	LW	HB14F10,3
	LW	HB14F11,3
	LWL	1,AFUNC|4,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_shake_6
	LWW	HB14F03,AFLIP|3,M_FLIPH
	LW	HB14F04,3
	LW	HB14F05,3
	LW	HB14F06,3
	LWL	HB14F07,AFUNC|3,a_fall_stopv
	LW	HB14F08,3
	LW	HB14F10,3
	LW	HB14F11,3
	LWL	1,AFUNC|4,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_shake_7
anim_shake_8
	LWW	HA12F02,AFLIP|3,M_FLIPH
	LW	HA12F04,3
	LW	HA12F06,3
	LW	HA12F07,3
	LW	HA12F08,3
	LWL	HA12F09,AFUNC|3,a_fall_stopv
	LW	HA12F10,3
	LW	HA12F12,3
	LW	HA12F14,3
	LW	HA12F16,3
	LWL	1,AFUNC|4,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	LWL	1,AFUNC|10,a_fall_done
	.long	0

anim_steal_1
	LWL	PK11F02,AFUNC|2,a_flip_collision+6
	.long	[-50,50],[-100,10],take_puck
	LWL	PK11F02,AFUNC|2,a_collision+6
	.long	[-50,50],[-100,10],take_puck
	LWL	PK11F02,AFUNC|1,a_collision+6
	.long	[-50,50],[-100,10],take_puck
	LWL	PK11F02,AFUNC|1,a_collision_puck+6
	.long	[-50,50],[-100,10],take_puck_or_free_only
	LWL	PK11F03,4|AFUNC,a_sound_for_steal
	LW	PK11F04,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0
anim_steal_2
	LWWL	PK12F02,AFLIP|AFUNC|2,0,a_collision+6
	.long	[-10,70],[-70,10],take_puck
	LWL	PK12F02,AFUNC|2,a_collision+6
	.long	[-10,70],[-70,10],take_puck
	LWL	PK12F02,AFUNC|1,a_collision+6
	.long	[-10,70],[-70,10],take_puck
	LWL	PK12F02,AFUNC|1,a_collision_puck+6
	.long	[-10,70],[-70,10],take_puck_or_free_only
	LWL	PK12F03,4|AFUNC,a_sound_for_steal
	LW	PK12F04,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0
anim_steal_3
	LWWL	PK13F02,AFLIP|AFUNC|2,0,a_collision+6
	.long	[-10,100],[-50,50],take_puck
	LWL	PK13F02,AFUNC|2,a_collision+6
	.long	[-10,100],[-50,50],take_puck
	LWL	PK13F02,AFUNC|1,a_collision+6
	.long	[-10,100],[-50,50],take_puck
	LWL	PK13F02,AFUNC|1,a_collision_puck+6
	.long	[-10,100],[-50,50],take_puck_or_free_only
	LWL	PK13F03,4|AFUNC,a_sound_for_steal
	LW	PK13F04,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0
anim_steal_4
	LWWL	PK14F02,AFLIP|AFUNC|2,0,a_collision+6
	.long	[-10,70],[-10,70],take_puck
	LWL	PK14F02,AFUNC|2,a_collision+6
	.long	[-10,70],[-10,70],take_puck
	LWL	PK14F02,AFUNC|1,a_collision+6
	.long	[-10,70],[-10,70],take_puck
	LWL	PK14F02,AFUNC|1,a_collision_puck+6
	.long	[-10,70],[-10,70],take_puck_or_free_only
	LWL	PK14F03,4|AFUNC,a_sound_for_steal
	LW	PK14F04,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0
anim_steal_5
	LWL	PK15F02,AFUNC|2,a_flip_collision+6
	.long	[-50,50],[-10,100],take_puck
	LWL	PK15F02,AFUNC|2,a_collision+6
	.long	[-50,50],[-10,100],take_puck
	LWL	PK15F02,AFUNC|1,a_collision+6
	.long	[-50,50],[-10,100],take_puck
	LWL	PK15F02,AFUNC|1,a_collision_puck+6
	.long	[-50,50],[-10,100],take_puck_or_free_only
	LWL	PK15F03,4|AFUNC,a_sound_for_steal
	LW	PK15F04,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0
anim_steal_6
	LWWL	PK14F02,AFLIP|AFUNC|2,M_FLIPH,a_collision+6
	.long	[-70,10],[-10,70],take_puck
	LWL	PK14F02,AFUNC|2,a_collision+6
	.long	[-70,10],[-10,70],take_puck
	LWL	PK14F02,AFUNC|1,a_collision+6
	.long	[-70,10],[-10,70],take_puck
	LWL	PK14F02,AFUNC|1,a_collision_puck+6
	.long	[-70,10],[-10,70],take_puck_or_free_only
	LWL	PK14F03,4|AFUNC,a_sound_for_steal
	LW	PK14F04,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0
anim_steal_7
	LWWL	PK13F02,AFLIP|AFUNC|2,M_FLIPH,a_collision+6
	.long	[-100,10],[-50,50],take_puck
	LWL	PK13F02,AFUNC|2,a_collision+6
	.long	[-100,10],[-50,50],take_puck
	LWL	PK13F02,AFUNC|1,a_collision+6
	.long	[-100,10],[-50,50],take_puck
	LWL	PK13F02,AFUNC|1,a_collision_puck+6
	.long	[-100,10],[-50,50],take_puck_or_free_only
	LWL	PK13F03,4|AFUNC,a_sound_for_steal
	LW	PK13F04,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0
anim_steal_8
	LWWL	PK12F02,AFLIP|AFUNC|2,M_FLIPH,a_collision+6
	.long	[-70,10],[-70,10],take_puck
	LWL	PK12F02,AFUNC|2,a_collision+6
	.long	[-70,10],[-70,10],take_puck
	LWL	PK12F02,AFUNC|1,a_collision+6
	.long	[-70,10],[-70,10],take_puck
	LWL	PK12F02,AFUNC|1,a_collision_puck+6
	.long	[-70,10],[-70,10],take_puck_or_free_only
	LWL	PK12F03,4|AFUNC,a_sound_for_steal
	LW	PK12F04,4
	LWL	1,AFUNC|3,a_steal_done
	.long	0

anim_push_1
	LWL	CA13F01,AFUNC|3,a_flip_accelerate_start+3
	.word	0,-40,6
	LW	CA13F02,2
	LW	CA13F03,2
	LWL	1,AFUNC|2,a_collision+6
	.long	[-50,50],[-60,10],get_pushed
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CA13F04,3
	LW	CA13F05,3
	LW	CA13F07,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_push_2
	LWWL	CA13F01,AFUNC|AFLIP|3,0,a_accelerate_start+3
	.word	30,-30,6
	LW	CA13F02,2
	LW	CA13F03,2
	LWL	1,AFUNC|2,a_collision+6
	.long	[-10,45],[-45,10],get_pushed
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CA13F04,3
	LW	CA13F05,3
	LW	CA13F07,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_push_3
	LWWL	CA13F01,AFUNC|AFLIP|3,0,a_accelerate_start+3
	.word	40,0,6
	LW	CA13F02,2
	LW	CA13F03,2
	LWL	1,AFUNC|2,a_collision+6
	.long	[-10,60],[-50,50],get_pushed
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CA13F04,3
	LW	CA13F05,3
	LW	CA13F07,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_push_4
	LWWL	CA13F01,AFUNC|AFLIP|3,0,a_accelerate_start+3
	.word	30,30,6
	LW	CA13F02,2
	LW	CA13F03,2
	LWL	1,AFUNC|2,a_collision+6
	.long	[-10,45],[-10,45],get_pushed
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CA13F04,3
	LW	CA13F05,3
	LW	CA13F07,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_push_5
	LWL	CA13F01,AFUNC|3,a_flip_accelerate_start+3
	.word	0,40,6
	LW	CA13F02,2
	LW	CA13F03,2
	LWL	1,AFUNC|2,a_collision+6
	.long	[-50,50],[-10,60],get_pushed
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CA13F04,3
	LW	CA13F05,3
	LW	CA13F07,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_push_6
	LWWL	CA13F01,AFUNC|AFLIP|3,M_FLIPH,a_accelerate_start+3
	.word	-30,30,6
	LW	CA13F02,2
	LW	CA13F03,2
	LWL	1,AFUNC|2,a_collision+6
	.long	[-45,10],[-10,45],get_pushed
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CA13F04,3
	LW	CA13F05,3
	LW	CA13F07,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_push_7
	LWWL	CA13F01,AFUNC|AFLIP|3,M_FLIPH,a_accelerate_start+3
	.word	-40,0,6
	LW	CA13F02,2
	LW	CA13F03,2
	LWL	1,AFUNC|2,a_collision+6
	.long	[-60,10],[-50,50],get_pushed
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CA13F04,3
	LW	CA13F05,3
	LW	CA13F07,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_push_8
	LWWL	CA13F01,AFUNC|AFLIP|3,M_FLIPH,a_accelerate_start+3
	.word	-30,-30,6
	LW	CA13F02,2
	LW	CA13F03,2
	LWL	1,AFUNC|2,a_collision+6
	.long	[-45,10],[-45,10],get_pushed
	LWL	1,AFUNC|1,a_accelerate_restore
	LW	CA13F04,3
	LW	CA13F05,3
	LW	CA13F07,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_check_1
ac110	LW	BC11F01,1
	LWL	BC11F02,AFUNC|1,a_ch_vels
ac111	LWL	1,AFUNC|1,a_wall_branch+8
	.long	 ac110,ac111,[-50,50],[-60,10]
	.long	0
anim_body_check_wall_1
ac120	LWL	BC11F03,AFUNC|1,a_wall_branch+8
	.long	 ac120,ac120,[-50,50],[-60,10]
	.long	0
anim_body_check_down_1
ac130	LWL	BC11F04,AFUNC|1,a_go_down
ac131	LWL	1,AFUNC|1,a_until_ground+4
	.long	 ac130,ac131
	LWL	BC11F05,AFUNC|3,a_bface+1
	.word	 3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_check_2
ac210	LW	BC12F01,1
	LWL	BC12F02,AFUNC|1,a_ch_vels
ac211	LWL	1,AFUNC|1,a_wall_branch+8
	.long	 ac210,ac211,[-10,45],[-45,10]
	.long	0
anim_body_check_wall_2
ac220	LWL	BC12F03,AFUNC|1,a_wall_branch+8
	.long	 ac220,ac220,[-10,45],[-45,10]
	.long	0
anim_body_check_down_2
ac230	LWL	BC12F04,AFUNC|1,a_go_down
ac231	LWL	1,AFUNC|1,a_until_ground+4
	.long	 ac230,ac231
	LW	BC12F05,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_check_8
ac810	LW	BC12F01,1
	LWL	BC12F02,AFUNC|1,a_ch_vels
ac811	LWL	1,AFUNC|1,a_wall_branch+8
	.long	 ac810,ac811,[-45,10],[-45,10]
	.long	0
anim_body_check_wall_8
ac820	LWL	BC12F03,AFUNC|1,a_wall_branch+8
	.long	 ac820,ac820,[-45,10],[-45,10]
	.long	0
anim_body_check_down_8
ac830	LWL	BC12F04,AFUNC|1,a_go_down
ac831	LWL	1,AFUNC|1,a_until_ground+4
	.long	 ac830,ac831
	LW	BC12F05,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_check_7
ac710	LW	BC13F01,1
	LWL	BC13F02,AFUNC|1,a_ch_vels
ac711	LWL	1,AFUNC|1,a_wall_branch+8
	.long	 ac710,ac711,[-60,10],[-50,50]
	.long	0
anim_body_check_wall_7
ac720	LWL	BC13F03,AFUNC|1,a_wall_branch+8
	.long	 ac720,ac720,[-60,10],[-50,50]
	.long	0
anim_body_check_down_7
ac730	LWL	BC13F04,AFUNC|1,a_go_down
ac731	LWL	1,AFUNC|1,a_until_ground+4
	.long	 ac730,ac731
	LWL	1,AFUNC|1,a_bface+1
	.word	 1
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_check_3
ac310	LW	BC13F01,1
	LWL	BC13F02,AFUNC|1,a_ch_vels
ac311	LWL	1,AFUNC|1,a_wall_branch+8
	.long	 ac310,ac311,[-10,60],[-50,50]
	.long	0
anim_body_check_wall_3
ac320	LWL	BC13F03,AFUNC|1,a_wall_branch+8
	.long	 ac320,ac320,[-10,60],[-50,50]
	.long	0
anim_body_check_down_3
ac330	LWL	BC13F04,AFUNC|1,a_go_down
ac331	LWL	1,AFUNC|1,a_until_ground+4
	.long	 ac330,ac331
	LWL	1,AFUNC|1,a_bface+1
	.word	 1
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_check_6
ac610	LW	BC23F01,1
	LWL	BC23F02,AFUNC|1,a_ch_vels
ac611	LWL	1,AFUNC|1,a_wall_branch+8
	.long	 ac610,ac611,[-45,10],[-10,45]
	.long	0
anim_body_check_wall_6
ac620	LWL	BC23F03,AFUNC|1,a_wall_branch+8
	.long	 ac620,ac620,[-45,10],[-10,45]
	.long	0
anim_body_check_down_6
ac630	LWL	BC23F04,AFUNC|1,a_go_down
ac631	LWL	1,AFUNC|1,a_until_ground+4
	.long	 ac630,ac631
	LWL	BC23F05,AFUNC|3,a_bface+1
	.word	 8
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_check_4
ac410	LW	BC23F01,1
	LWL	BC23F02,AFUNC|1,a_ch_vels
ac411	LWL	1,AFUNC|1,a_wall_branch+8
	.long	 ac410,ac411,[-10,45],[-10,45]
	.long	0
anim_body_check_wall_4
ac420	LWL	BC23F03,AFUNC|1,a_wall_branch+8
	.long	 ac420,ac420,[-10,45],[-10,45]
	.long	0
anim_body_check_down_4
ac430	LWL	BC23F04,AFUNC|1,a_go_down
ac431	LWL	1,AFUNC|1,a_until_ground+4
	.long	 ac430,ac431
	LWL	BC23F05,AFUNC|3,a_bface+1
	.word	 2
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_check_5
ac510	LW	BC15F01,1
	LWL	BC15F02,AFUNC|1,a_ch_vels
ac511	LWL	1,AFUNC|1,a_wall_branch+8
	.long	 ac510,ac511,[-50,50],[-10,60]
	.long	0
anim_body_check_wall_5
ac520	LWL	BC15F03,AFUNC|1,a_wall_branch+8
	.long	 ac520,ac520,[-50,50],[-10,60]
	.long	0
anim_body_check_down_5
ac530	LWL	BC15F04,AFUNC|1,a_go_down
ac531	LWL	1,AFUNC|1,a_until_ground+4
	.long	 ac530,ac531
	LWL	BC15F05,AFUNC|3,a_bface+1
	.word	 2
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_checked_face_1
axc11	LWW	HE112F01,AFLIP|3,0
axc12	LWL	HE112F02,AFUNC|1,a_watch_ground_loop+4
	.long	 axc11,axc12
	.long	0
anim_body_checked_face_wall_1
ayc11	LWL	HE112F02,AFUNC|1,a_watch_ground_loop+4
	.long	 ayc11,ayc11
	.long	0
anim_body_checked_face_down_1
acf10	LWWL	HE112F03,AFUNC|AFLIP|3,0,a_go_down_c
acf11	LWL	HE112F06,AFUNC|1,a_until_ground_c+4
	.long	 acf10,acf11
	LWL	RA12F02,AFUNC|1,a_start_get_up_count
aqcf10	LWL	1,AFUNC|1,a_wait_get_up+4
	.long	acf10,aqcf10
	LW	RA12F03,3
	LW	RA12F04,3
	LW	RA12F06,3
	LW	RA12F07,3
	LWL	RA12F08,AFUNC|3,a_bface+1
	.word	 2
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_checked_face_2
axc21	LWW	HE122F01,AFLIP|3,0
axc22	LWL	HE122F02,AFUNC|1,a_watch_ground_loop+4
	.long	 axc21,axc22
	.long	0
anim_body_checked_face_wall_2
ayc21	LWL	HE122F02,AFUNC|1,a_watch_ground_loop+4
	.long	 ayc21,ayc21
	.long	0
anim_body_checked_face_down_2
acf20	LWWL	HE122F03,AFUNC|AFLIP|3,0,a_go_down_c
acf21	LWL	HE122F04,AFUNC|1,a_until_ground_c+4
	.long	 acf20,acf21
	LW	HE122F07,3
	LWL	RA14F01,AFUNC|1,a_start_get_up_count
aqcf20	LWL	1,AFUNC|1,a_wait_get_up+4
	.long	acf20,aqcf20
	LW	RA14F02,3
	LW	RA14F03,3
	LW	RA14F04,3
	LW	RA14F05,3
	LWL	RA14F06,AFUNC|3,a_bface+1
	.word	 4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_checked_face_3
axc31	LWW	HE132F01,AFLIP|3,0
axc32	LWL	HE132F03,AFUNC|1,a_watch_ground_loop+4
	.long	 axc31,axc32
	.long	0
anim_body_checked_face_wall_3
ayc31	LWL	HE132F03,AFUNC|1,a_watch_ground_loop+4
	.long	 ayc31,ayc31
	.long	0
anim_body_checked_face_down_3
acf30	LWWL	HE132F04,AFUNC|AFLIP|3,0,a_go_down_c
acf31	LWL	HE132F05,AFUNC|1,a_until_ground_c+4
	.long	 acf30,acf31
	LW	HE132F07,3
	LWL	RB15F01,AFUNC|1,a_start_get_up_count
aqcf30	LWL	1,AFUNC|1,a_wait_get_up+4
	.long	acf30,aqcf30
	LW	RB15F03,3
	LW	RB15F04,3
	LW	RB15F06,3
	LW	RB15F08,3
	LWL	RB15F09,AFUNC|3,a_bface+1
	.word	 5
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_checked_face_4
axc41	LWW	HE142F01,AFLIP|3,0
axc42	LWL	HE142F02,AFUNC|1,a_watch_ground_loop+4
	.long	 axc41,axc42
	.long	0
anim_body_checked_face_wall_4
ayc41	LWL	HE142F02,AFUNC|1,a_watch_ground_loop+4
	.long	 ayc41,ayc41
	.long	0
anim_body_checked_face_down_4
acf40	LWWL	HE142F03,AFUNC|AFLIP|3,0,a_go_down_c
acf41	LWL	HE142F05,AFUNC|1,a_until_ground_c+4
	.long	 acf40,acf41
	LW	HE142F07,3
	LWL	HE12F02,AFUNC|1,a_start_get_up_count
aqcf40	LWL	1,AFUNC|1,a_wait_get_up+4
	.long	acf40,aqcf40
	LW	HE12F03,3
	LW	HE12F05,3
	LW	HE12F06,3
	LW	HE12F07,3
	LWL	HE12F09,AFUNC|3,a_bface+1
	.word	 6
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_checked_face_5
axc51	LWW	HE152F01,AFLIP|3,0
axc52	LWL	HE152F02,AFUNC|1,a_watch_ground_loop+4
	.long	 axc51,axc52
	.long	0
anim_body_checked_face_wall_5
ayc51	LWL	HE152F02,AFUNC|1,a_watch_ground_loop+4
	.long	 ayc51,ayc51
	.long	0
anim_body_checked_face_down_5
acf50	LWWL	HE152F03,AFUNC|AFLIP|3,0,a_go_down_c
acf51	LWL	RB15F01,AFUNC|1,a_until_ground_c+4
	.long	 acf50,acf51
	LWL	RB15F03,AFUNC|1,a_start_get_up_count
aqcf50	LWL	1,AFUNC|1,a_wait_get_up+4
	.long	acf50,aqcf50
	LW	RB15F04,3
	LW	RB15F06,3
	LW	RB15F08,3
	LW	RB15F09,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_checked_face_6
axc61	LWW	HE142F01,AFLIP|3,M_FLIPH
axc62	LWL	HE142F02,AFUNC|1,a_watch_ground_loop+4
	.long	 axc61,axc62
	.long	0
anim_body_checked_face_wall_6
ayc61	LWL	HE142F02,AFUNC|1,a_watch_ground_loop+4
	.long	 ayc61,ayc61
	.long	0
anim_body_checked_face_down_6
acf60	LWWL	HE142F03,AFUNC|AFLIP|3,M_FLIPH,a_go_down_c
acf61	LWL	HE142F05,AFUNC|1,a_until_ground_c+4
	.long	 acf60,acf61
	LW	HE142F07,3
	LWL	HE12F02,AFUNC|1,a_start_get_up_count
aqcf60	LWL	1,AFUNC|1,a_wait_get_up+4
	.long	acf60,aqcf60
	LW	HE12F03,3
	LW	HE12F05,3
	LW	HE12F06,3
	LW	HE12F07,3
	LWL	HE12F09,AFUNC|3,a_bface+1
	.word	 4
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_checked_face_7
axc71	LWW	HE132F01,AFLIP|3,M_FLIPH
axc72	LWL	HE132F03,AFUNC|1,a_watch_ground_loop+4
	.long	 axc71,axc72
	.long	0
anim_body_checked_face_wall_7
ayc71	LWL	HE132F03,AFUNC|1,a_watch_ground_loop+4
	.long	 ayc71,ayc71
	.long	0
anim_body_checked_face_down_7
acf70	LWWL	HE132F04,AFUNC|AFLIP|3,M_FLIPH,a_go_down_c
acf71	LWL	HE132F05,AFUNC|1,a_until_ground_c+4
	.long	 acf70,acf71
	LW	HE132F07,3
	LWL	RB15F01,AFUNC|1,a_start_get_up_count
aqcf70	LWL	1,AFUNC|1,a_wait_get_up+4
	.long	acf70,aqcf70
	LW	RB15F03,3
	LW	RB15F04,3
	LW	RB15F06,3
	LW	RB15F08,3
	LWL	RB15F09,AFUNC|3,a_bface+1
	.word	 5
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

anim_body_checked_face_8
axc81	LWW	HE122F01,AFLIP|3,M_FLIPH
axc82	LWL	HE122F02,AFUNC|1,a_watch_ground_loop+4
	.long	 axc81,axc82
	.long	0
anim_body_checked_face_wall_8
ayc81	LWL	HE122F02,AFUNC|1,a_watch_ground_loop+4
	.long	 ayc81,ayc81
	.long	0
anim_body_checked_face_down_8
acf80	LWWL	HE122F03,AFUNC|AFLIP|3,M_FLIPH,a_go_down_c
acf81	LWL	HE122F04,AFUNC|1,a_until_ground_c+4
	.long	 acf80,acf81
	LW	HE122F07,3
	LWL	RA14F01,AFUNC|1,a_start_get_up_count
aqcf80	LWL	1,AFUNC|1,a_wait_get_up+4
	.long	acf80,aqcf80
	LW	RA14F02,3
	LW	RA14F03,3
	LW	RA14F04,3
	LW	RA14F05,3
	LWL	RA14F06,AFUNC|3,a_bface+1
	.word	 6
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

;anim_body_checked_back_1
;bxc11	LWW	HE21F01,AFLIP|3,0
;bxc12	LWL	HE21F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 bxc11,bxc12
;	.long	0
;anim_body_checked_back_wall_1
;byc11	LWL	HE21F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 byc11,byc11
;	.long	0
;anim_body_checked_back_down_1
;acb10	LWWL	HE21F03,AFUNC|AFLIP|3,0,a_go_down_c
;acb11	LWL	HE21F05,AFUNC|1,a_until_ground_c+4
;	.long	 acb10,acb11
;	LWL	HE14F01,AFUNC|1,a_start_get_up_count
;apcb10	LWL	1,AFUNC|1,a_wait_get_up+4
;	.long	acb10,apcb10
;	LW	HE14F02,3
;	LW	HE14F04,3
;	LW	HE14F06,3
;	LW	HE14F07,3
;	LWL	HE14F09,AFUNC|3,a_bface+1
;	.word	 8
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_body_checked_back_2
;bxc21	LWW	HE122F01,AFLIP|3,0
;bxc22	LWL	HE122F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 bxc21,bxc22
;	.long	0
;anim_body_checked_back_wall_2
;byc21	LWL	HE122F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 byc21,byc21
;	.long	0
;anim_body_checked_back_down_2
;acb20	LWWL	HE122F03,AFUNC|AFLIP|3,0,a_go_down_c
;acb21	LWL	HE122F04,AFUNC|1,a_until_ground_c+4
;	.long	 acb20,acb21
;	LW	HE122F07,3
;	LWL	RA14F01,AFUNC|1,a_start_get_up_count
;apcb20	LWL	1,AFUNC|1,a_wait_get_up+4
;	.long	acb20,apcb20
;	LW	RA14F02,3
;	LW	RA14F03,3
;	LW	RA14F04,3
;	LW	RA14F05,3
;	LWL	RA14F06,AFUNC|3,a_bface+1
;	.word	 4
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_body_checked_back_3
;bxc31	LWW	HE23F01,AFLIP|3,0
;bxc32	LWL	HE23F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 bxc31,bxc32
;	.long	0
;anim_body_checked_back_wall_3
;byc31	LWL	HE23F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 byc31,byc31
;	.long	0
;anim_body_checked_back_down_3
;acb30	LWWL	HE23F03,AFUNC|AFLIP|3,0,a_go_down_c
;acb31	LWL	HE23F05,AFUNC|1,a_until_ground_c+4
;	.long	 acb30,acb31
;	LW	HE23F07,3
;	LW	HE23F08,3
;	LWL	HE14F01,AFUNC|1,a_start_get_up_count
;apcb30	LWL	1,AFUNC|1,a_wait_get_up+4
;	.long	acb30,apcb30
;	LW	HE14F02,3
;	LW	HE14F04,3
;	LW	HE14F06,3
;	LW	HE14F07,3
;	LWL	HE14F09,AFUNC|3,a_bface+1
;	.word	 8
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_body_checked_back_4
;bxc41	LWW	HE24F01,AFLIP|3,0
;bxc42	LWL	HE24F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 bxc41,bxc42
;	.long	0
;anim_body_checked_back_wall_4
;byc41	LWL	HE24F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 byc41,byc41
;	.long	0
;anim_body_checked_back_down_4
;acb40	LWWL	HE24F03,AFUNC|AFLIP|3,0,a_go_down_c
;acb41	LWL	HE24F04,AFUNC|1,a_until_ground_c+4
;	.long	 acb40,acb41
;	LW	HE24F06,3
;	LWL	RB11F01,AFUNC|1,a_start_get_up_count
;apcb40	LWL	1,AFUNC|1,a_wait_get_up+4
;	.long	acb40,apcb40
;	LW	RB11F03,3
;	LW	RB11F05,3
;	LW	RB11F07,3
;	LW	RB11F09,3
;	LWL	RB11F10,AFUNC|3,a_bface+1
;	.word	 1
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_body_checked_back_5
;bxc51	LWW	HE25F01,AFLIP|3,0
;bxc52	LWL	HE25F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 bxc51,bxc52
;	.long	0
;anim_body_checked_back_wall_5
;byc51	LWL	HE25F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 byc51,byc51
;	.long	0
;anim_body_checked_back_down_5
;acb50	LWWL	HE25F03,AFUNC|AFLIP|3,0,a_go_down_c
;acb51	LWL	HE25F04,AFUNC|1,a_until_ground_c+4
;	.long	 acb50,acb51
;	LWL	RA12F02,AFUNC|1,a_start_get_up_count
;apcb50	LWL	1,AFUNC|1,a_wait_get_up+4
;	.long	acb50,apcb50
;	LW	RA12F03,3
;	LW	RA12F04,3
;	LW	RA12F06,3
;	LW	RA12F07,3
;	LWL	RA12F08,AFUNC|3,a_bface+1
;	.word	 2
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_body_checked_back_6
;bxc61	LWW	HE24F01,AFLIP|3,M_FLIPH
;bxc62	LWL	HE24F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 bxc61,bxc62
;	.long	0
;anim_body_checked_back_wall_6
;byc61	LWL	HE24F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 byc61,byc61
;	.long	0
;anim_body_checked_back_down_6
;acb60	LWWL	HE24F03,AFUNC|AFLIP|3,M_FLIPH,a_go_down_c
;acb61	LWL	HE24F04,AFUNC|1,a_until_ground_c+4
;	.long	 acb60,acb61
;	LW	HE24F06,3
;	LWL	RB11F01,AFUNC|1,a_start_get_up_count
;apcb60	LWL	1,AFUNC|1,a_wait_get_up+4
;	.long	acb60,apcb60
;	LW	RB11F03,3
;	LW	RB11F05,3
;	LW	RB11F07,3
;	LW	RB11F09,3
;	LWL	RB11F10,AFUNC|3,a_bface+1
;	.word	 1
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_body_checked_back_7
;bxc71	LWW	HE23F01,AFLIP|3,M_FLIPH
;bxc72	LWL	HE23F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 bxc71,bxc72
;	.long	0
;anim_body_checked_back_wall_7
;byc71	LWL	HE23F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 byc71,byc71
;	.long	0
;anim_body_checked_back_down_7
;acb70	LWWL	HE23F03,AFUNC|AFLIP|3,M_FLIPH,a_go_down_c
;acb71	LWL	HE23F05,AFUNC|1,a_until_ground_c+4
;	.long	 acb70,acb71
;	LW	HE23F07,3
;	LW	HE23F08,3
;	LWL	HE14F01,AFUNC|1,a_start_get_up_count
;apcb70	LWL	1,AFUNC|1,a_wait_get_up+4
;	.long	acb70,apcb70
;	LW	HE14F02,3
;	LW	HE14F04,3
;	LW	HE14F06,3
;	LW	HE14F07,3
;	LWL	HE14F09,AFUNC|3,a_bface+1
;	.word	 2
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0
;
;anim_body_checked_back_8
;bxc81	LWW	HE122F01,AFLIP|3,M_FLIPH
;bxc82	LWL	HE122F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 bxc81,bxc82
;	.long	0
;anim_body_checked_back_wall_8
;byc81	LWL	HE122F02,AFUNC|1,a_watch_ground_loop+4
;	.long	 byc81,byc81
;	.long	0
;anim_body_checked_back_down_8
;acb80	LWWL	HE122F03,AFUNC|AFLIP|3,M_FLIPH,a_go_down_c
;acb81	LWL	HE122F04,AFUNC|1,a_until_ground_c+4
;	.long	 acb80,acb81
;	LW	HE122F07,3
;	LWL	RA14F01,AFUNC|1,a_start_get_up_count
;apcb80	LWL	1,AFUNC|1,a_wait_get_up+4
;	.long	acb80,apcb80
;	LW	RA14F02,3
;	LW	RA14F03,3
;	LW	RA14F04,3
;	LW	RA14F05,3
;	LWL	RA14F06,AFUNC|3,a_bface+1
;	.word	 6
;	LWL	1,AFUNC|1,a_control_script_done
;	.long	0

anim_whack_goalie_1
	LWW	WG11F02,3|AFLIP,0
	LW	WG11F03,3
	LW	WG11F04,3
	LWL	WG11F09,AFUNC|3,a_set_whack
	LW	WG11F04,3
	LW	WG11F03,3
	LW	WG11F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_whack_goalie_2
	LWW	WG12F02,3|AFLIP,0
	LW	WG12F03,3
	LW	WG12F04,3
	LWL	WG12F05,AFUNC|3,a_set_whack
	LW	WG12F04,3
	LW	WG12F03,3
	LW	WG12F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_whack_goalie_3
	LWW	WG13F01,3|AFLIP,0
	LW	WG13F02,3
	LW	WG13F03,3
	LWL	WG13F04,AFUNC|3,a_set_whack
	LW	WG13F03,3
	LW	WG13F02,3
	LW	WG13F01,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_whack_goalie_4
	LWW	WG14F03,3|AFLIP,0
	LW	WG14F04,3
	LW	WG14F05,3
	LWL	WG14F06,AFUNC|3,a_set_whack
	LW	WG14F05,3
	LW	WG14F04,3
	LW	WG14F03,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_whack_goalie_5
	LWW	WG15F03,3|AFLIP,0
	LW	WG15F04,3
	LW	WG15F05,3
	LWL	WG15F06,AFUNC|3,a_set_whack
	LW	WG15F05,3
	LW	WG15F04,3
	LW	WG15F03,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_whack_goalie_6
	LWW	WG14F03,3|AFLIP,M_FLIPH
	LW	WG14F04,3
	LW	WG14F05,3
	LWL	WG14F06,AFUNC|3,a_set_whack
	LW	WG14F05,3
	LW	WG14F04,3
	LW	WG14F03,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_whack_goalie_7
	LWW	WG13F01,3|AFLIP,M_FLIPH
	LW	WG13F02,3
	LW	WG13F03,3
	LWL	WG13F04,AFUNC|3,a_set_whack
	LW	WG13F03,3
	LW	WG13F02,3
	LW	WG13F01,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0
anim_whack_goalie_8
	LWW	WG12F02,3|AFLIP,M_FLIPH
	LW	WG12F03,3
	LW	WG12F04,3
	LWL	WG12F05,AFUNC|3,a_set_whack
	LW	WG12F04,3
	LW	WG12F03,3
	LW	WG12F02,3
	LWL	1,AFUNC|1,a_control_script_done
	.long	0

