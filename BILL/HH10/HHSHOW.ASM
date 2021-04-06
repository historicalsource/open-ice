	.MLIB	"HHMACS.LIB"
	.FILE	"HHSHOW.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

	.INCLUDE	"HH.INC"		;Game equates
	.include	"hhshow.e"
	.include	"hhutil.g"
	.include	"hhsnd.g"
	.include	"hhmath.g"
	.include	"hhpuck.g"
	.include	"hhproc.g"

; end of include files

	.TEXT

	.bss	skate_sound_type,16
	.bss	xxxxxx,16
	.bss	last_corner_vel,32

puck_drop_sound		;a1 = puck y velocity
	mmtm	sp,a0,a1,a4,a5
	move	@puck_bounce_track,a0,W
	jrz	pds_1
	mmtm	sp,a1
	clr	a1
	calla	set_track_time			;let it continue if it can
	mmfm	sp,a1
pds_1	move	a1,a5
	sra	16,a1
	movi	puck_drop_table,a4
	callr	pbs_tab
	move	a4,@trigger_puck_sound	;here is a convenient place to store a trigger
	cmpi	s_puck_drop_3,a4
	jrz	pds_v
	calla	do_sound
	jrnc	pds_9
	move	a4,@puck_bounce_track,W
	jruc	pds_9
pds_v	sra	8,a5
	move	a5,a1
	calla	do_sound_at_volume
	jrnc	pds_9
	move	a4,@puck_bounce_track,W
pds_9	mmfm	sp,a0,a1,a4,a5
	rets

puck_drop_table
	.word	4,s_puck_drop_1
	.word	2,s_puck_drop_in_net
	.word	1,s_puck_drop_2
	.word	-1,s_puck_drop_3

puck_board_corner_sound
	mmtm	sp,a0,a1,a4
	move	@PUCK_CONTROL,a0,W
	jrnz	pbs_9
	cmpi	XD0200,a3,L
	jrhs	pbss_s
	move	*a8(ODT_VEL),a1,L
	move	@last_corner_vel,a14,L
	move	a1,@last_corner_vel,L
	cmp	a14,a1
	jrls	nocs
	movi	s_ice_crunch_2,a4
	srl	11,a1
	calla	do_sound_at_volume
	mmfm	sp,a0,a1,a4
	rets
nocs	clr	a1
	dec	a1
	move	a1,@trigger_puck_sound,W
	mmfm	sp,a0,a1,a4
	rets

puck_goal_sound		;a3 = delta from parallel
			;a8 = puck object
puck_board_sound	;a3 = delta from parallel
			;a8 = puck object
	mmtm	sp,a0,a1,a4
	move	@PUCK_CONTROL,a0,W
	jrnz	pbs_9
pbss_s	clr	a0
	move	a0,@last_corner_vel,L
	cmpi	XD0040,a3,L
	jrls	pbs_9
	move	a3,a0
	calla	GETSIN
	move	*a8(ODT_VEL),a1,L
	calla	MULT
	move	a1,a4		;save it
	srl	16,a1
	move	*a8(OYPOS),a0,W
	abs	a0
	cmpi	8,a0
	jrls	pbs_l
pbs_h	movi	puck_high_table,a4
	jruc	pbs_l1
pbs_l	cmpi	2,a1
	jrhs	pbs_l2
	move	a4,a1
	srl	10,a1
	cmpi	40,a1
	jrls	pbs_9
	movi	s_plastic_board_hit_2,a4
	calla	do_sound_at_volume
	jruc	pbs_9
pbs_l2	movi	puck_low_table,a4
pbs_l1	callr	pbs_tab
	move	a4,@trigger_puck_sound	;here is a convenient place to store a trigger
	calla	do_sound
pbs_9	mmfm	sp,a0,a1,a4
	rets

pbs_tab	move	*a4,a14,W
	jrn	pbs_h2
	cmp	a14,a1
	jrhs	pbs_h2
	addk	32,a4
	jruc	pbs_tab
pbs_h2	move	*a4(16),a4,W
	rets

puck_low_table
	.word	12,s_plastic_board_hit_2
	.word	8,s_puck_to_metal_1
	.word	4,s_puck_to_metal_0
	.word	-1,s_puck_to_metal_2

puck_high_table
	.word	14,s_loud_board_1
	.word	11,s_loud_board_3
	.word	7,s_loud_board_2
	.word	4,s_puck_hit_board_2
	.word	2,s_puck_hit_board_1
	.word	-1,s_puck_hit_board_3

puck_slide_sound
	mmtm	sp,a0,a1,a7
	C_A_K	PID_PUCK_SOUND,pss_1
	mmfm	sp,a0,a1,a7
	rets
pss_1	move	@puck_ice_track,a0,W
	jrz	pss_6
	calla	cancel_track_sound
	clr	a0
	move	a0,@puck_ice_track,W
pss_6	movi	s_long_puck_slide_6,a4
	calla	RANDOM
	btst	0,a0
	jrnz	pss_4
	movi	s_long_puck_slide_7,a4
pss_4	calla	do_sound
	jrnc	pss_99
	movi	07ffffh,a10		;sliding velocity compare
	move	a4,@puck_ice_track,W
pss_3	move	@PUCK_CONTROL,a0,W
	jrnz	pss_9
	move	@PUCK_OBJECT,a8,L
	move	*a8(OYVAL),a0,L
	jrn	pss_9
	move	*a8(OYVEL),a0,L
	jrn	pss_9
	move	*a8(ODT_VEL),a0,L
	cmp	a10,a0
	jrls	pss_2
	move	a10,a0
pss_2	srl	11,a0
	move	a0,a1
	jrz	pss_9
	move	@puck_ice_track,a0,W
	calla	set_track_volume
	SLEEP	3
	subi	2800h,a10
	move	@puck_ice_track,a14,W
	jrz	pss_99
	jruc	pss_3
pss_9	move	@puck_ice_track,a0,W
	calla	cancel_track_sound
	clr	a0
	move	a0,@puck_ice_track,W
pss_99	jauc	SUCIDE


down_check_sound
	callr	check_for_abort
	movi	XD0900,a1
	jruc	coa_1
up_check_sound
	callr	check_for_abort
	movi	XD2700,a1
	jruc	coa_1
left_check_sound
	callr	check_for_abort
	clr	a1
	jruc	coa_1
right_check_sound
	callr	check_for_abort
	movi	XD1800,a1
	jruc	coa_1
ll_check_sound
	rets
	callr	check_for_abort
ul_check_sound
	rets
	callr	check_for_abort
lr_check_sound
	rets
	callr	check_for_abort
ur_check_sound
	rets
	callr	check_for_abort

coa_1	mmtm	sp,a0,a1,a4
	move	*a8(OFLAGS),a0,W
	btst	B_OFSCRN,a0
	jrnz	coa_9
	move	*a8(ODT_DIR),a0,L
	sub	a1,a0
	abs	a0
	THETA_N	a0
	cmpi	XD0900,a0
	jrls	coa_9
	cmpi	XD2700,a0
	jrhs	coa_9
	calla	GETCOS
	abs	a0
	move	*a8(ODT_VEL),a1,L
	calla	MULT
	sra	17,a1
	jrz	coa_9
	cmpi	5,a1
	jrls	coa_2
	movk	5,a1
coa_2	sll	4,a1
	addi	body_into_board_table-16,a1
	move	*a1,a4,W
	calla	do_sound
	clr	a4
	dec	a4
	move	a4,*a6(POF_LAST_BOARD_CVEL),L
coa_9	mmfm	sp,a0,a1,a4
	rets

check_for_abort
	mmtm	sp,a0,a8,a14
	move	*a8(ODT_VEL),a0,L
	move	*a6(POF_LAST_BOARD_CVEL),a14,L
	jrn	cfa_n
	move	a0,*a6(POF_LAST_BOARD_CVEL),L
	cmp	a14,a0
	jrls	cfa_n
cfa_y	mmfm	sp,a0,a8,a14
	rets
cfa_n	mmfm	sp,a0,a8,a14
	addk	32,sp		;pull return address
	rets			;return to above where we were called

body_into_board_table
	.word	s_board_crash_8
	.word	s_board_crash_9
	.word	s_board_crash_5
	.word	s_board_crash_10
	.word	s_board_crash_4

slide_to_stop_sound
slide_to_reverse_sound
	mmtm	sp,a0,a1,a2,a3,a4
	move	*a8(ODT_VEL),a1,L
	cmpi	0fffffh,a1
	jrls	stss_1
	movi	0fffffh,a1
stss_1	move	a1,a4
	srl	12,a1
	movk	3,a0
	calla	RAND0
	srl	17,a4			;0 to 7
	add	a4,a0
	sll	4,a0
	addi	sts_list,a0
	move	*a0,a4,W
stss_2	movk	10,a2
	callr	check_skate_sound
	mmfm	sp,a0,a1,a2,a3,a4
	rets
sts_list
	.word	s_skate_stop_or_turn_2
	.word	s_skate_stop_or_turn_3
	.word	s_skate_stop_or_turn_2
	.word	s_skate_stop_or_turn_3
	.word	s_hard_skate_stop_5
	.word	s_hard_skate_stop_1
	.word	s_hard_skate_stop_4
	.word	s_hard_skate_stop_2
	.word	s_hard_skate_stop_3
	.word	s_hard_skate_stop_3

a_light_push
a_medium_push
	mmtm	sp,a0,a1,a2,a3,a4
	movk	4,a0
	calla	RAND0
	sll	4,a0
	addi	amp_tab,a0
	move	*a0,a4,W
	movi	75,a1
	movk	8,a2
	callr	check_skate_sound
	mmfm	sp,a0,a1,a2,a3,a4
	rets

amp_tab	.word	s_skate_36
	.word	s_skate_37
	.word	s_skate_2
	.word	s_skate_35

turn_sound
	mmtm	sp,a0,a1,a2,a3,a4
	move	*a8(ODT_VEL),a1,L
	cmpi	0fffffh,a1
	jrls	tss_1
	movi	0fffffh,a1
tss_1	move	a1,a4
	srl	13,a1
	subi	12,a1
	jrnn	tss_2
	clr	a1
tss_2	movk	2,a0
	calla	RAND0
	sll	4,a0
	addi	tss_l,a0
	move	*a0,a4,W
	movk	5,a2
	callr	check_skate_sound
	mmfm	sp,a0,a1,a2,a3,a4
	rets

tss_l	.word	s_skate_33			;turn
	.word	s_skate_29			;turn

check_skate_sound
	move	a1,a3
	move	*a8(OFLAGS),a0,W
	btst	B_OFSCRN,a0
	jrnz	csss_9
	move	@ice_skate_track,a0,W
	jrz	csss_o
	calla	get_track_time
	move	a1,a1
	jrz	csss_o		;expired, do always
	move	@skate_sound_type,a14,W
	cmp	a14,a2
	jrlo	csss_9
	clr	a1
	calla	set_track_time		;turn sound off logically, but let it continue if it can
csss_o	move	a2,@skate_sound_type,W
	move	a3,a1
	calla	do_sound_at_volume
	move	a4,@ice_skate_track,W
csss_9	rets

puck_stop_sound		;a8 = puck, a6 = player
	mmtm	sp,a0,a1,a2,a3,a4,a7
	move	*a6(POF_OBJECT),a7,L
	move	*a8(OXVEL),a0,L
	move	*a8(OZVEL),a1,L
	move	*a7(OXVEL),a2,L
	move	*a7(OZVEL),a3,L
	calla	find_dis_to_point_whole
	move	a4,a1
	sll	5,a1
	movi	s_slapshot_7,a4
	calla	do_sound_at_volume
	mmfm	sp,a0,a1,a2,a3,a4,a7
	rets

puck_rebound_sound
	mmtm	sp,a1,a4
	movi	s_slapshot_7,a4
	movi	120,a1
	calla	do_sound_at_volume
	mmfm	sp,a1,a4
	rets
wrist_shot_sound
	mmtm	sp,a4
	movi	s_slapshot_6,a4
	calla	do_sound
	mmfm	sp,a4
	rets
slap_shot_sound
	mmtm	sp,a4
	movi	s_slapshot_1,a4
	calla	do_sound
	mmfm	sp,a4
	rets

;other pushes
;	.word	s_skate_16
;	.word	s_skate_14
;	.word	s_skate_15
;	.word	s_skate_13
;	.word	s_skate_12
;	.word	s_skate_28
;	.word	s_skate_stop_or_turn_2
;	.word	s_skate_stop_or_turn_3

