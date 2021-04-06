 	.MLIB	"HHMACS.LIB"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhrscr.tbl"
	.include	"hhrscr.e"
	.include	"hhplayer.g"
	.include	"hhpuck.g"
	.include	"hhshow.g"
	.include	"hhscr_fn.g"
	.include	"hhhigher.g"
	.include	"hhd.g"
	.include	"hhmath.g"

; end of include files

	.TEXT
	.EVEN

	.bss	ref_size,16

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

set_ref_look_script
	move	@ref_size,a1,W
	sll	5,a1
	addi	srlok_l,a1
	move	*a1,a1,L
	jauc	start_anim_if_not

srlok_l	.long	ref_look_large_script
	.long	ref_look_medium_script
	.long	ref_look_small_script

set_ref_stand_script
	move	@ref_size,a1,W
	sll	5,a1
	addi	srsts_l,a1
	move	*a1,a1,L
	jauc	start_anim_if_not

srsts_l	.long	ref_stand_large_script
	.long	ref_stand_medium_script
	.long	ref_stand_small_script

set_ref_setup_script
	move	@faceoff_type,a14,W
	jrnz	srst
	move	@ref_size,a1,W
	sll	5,a1
	addi	srsss_l,a1
	move	*a1,a1,L
	jauc	start_anim_if_not
srst	movi	ref_alt_setup_medium_script,a1
	jauc	start_anim_if_not

srsss_l	.long	ref_setup_large_script
	.long	ref_setup_medium_script
	.long	ref_setup_small_script

set_ref_drop_script
	move	@faceoff_type,a14,W
	jrnz	srdt
	move	@ref_size,a1,W
	sll	5,a1
	addi	srddd_l,a1
	move	*a1,a1,L
	jauc	start_anim_if_not
srdt	movi	ref_alt_drop_medium_script,a1
	jauc	start_anim_if_not
srddd_l	.long	ref_drop_large_script
	.long	ref_drop_medium_script
	.long	ref_drop_small_script

set_ref_skate_right_script
	move	@ref_size,a1,W
	sll	5,a1
	addi	srsrd_l,a1
	move	*a1,a1,L
	jauc	start_anim_if_not
srsrd_l	.long	ref_skate_right_large_script
	.long	ref_skate_right_medium_script
	.long	ref_skate_right_small_script

set_ref_skate_left_script
	move	@ref_size,a1,W
	sll	5,a1
	addi	srsld_l,a1
	move	*a1,a1,L
	jauc	start_anim_if_not
srsld_l	.long	ref_skate_left_large_script
	.long	ref_skate_left_medium_script
	.long	ref_skate_left_small_script

set_ref_skate_right_norm_script
	move	@ref_size,a1,W
	sll	5,a1
	addi	srsrndl,a1
	move	*a1,a1,L
	jauc	start_anim_if_not
srsrndl	.long	ref_skate_right_f_large_script
	.long	ref_skate_right_f_medium_script
	.long	ref_skate_right_f_small_script

set_ref_skate_left_norm_script
	move	@ref_size,a1,W
	sll	5,a1
	addi	slsrndl,a1
	move	*a1,a1,L
	jauc	start_anim_if_not
slsrndl	.long	ref_skate_left_f_large_script
	.long	ref_skate_left_f_medium_script
	.long	ref_skate_left_f_small_script

set_ref_stop_left_right_script
	move	@ref_size,a1,W
	sll	5,a1
	addi	srstndl,a1
	move	*a1,a1,L
	jauc	start_anim_if_not
srstndl	.long	ref_stop_f_large_script
	.long	ref_stop_f_medium_script
	.long	ref_stop_f_small_script

set_ref_stop_backwards_script
	move	@ref_size,a1,W
	sll	5,a1
	addi	srstbwl,a1
	move	*a1,a1,L
	jauc	start_anim_if_not
srstbwl	.long	ref_stop_b_large_script
	.long	ref_stop_b_medium_script
	.long	ref_stop_b_small_script

set_ref_skate_back_script
	rets
;	movi	ref_skate_back_script,a1
;	jauc	start_anim_if_not

set_ref_bump_script
	rets
;	movi	ref_bump_boards_script,a1
;	jauc	start_anim_if_not

ref_setup_large_script
	LWW	RFL51F01,AFLIP|6,0
	LW	RFL51F02,6
	LW	RFL51F03,15
	LW	RFL51F04,3
	LW	RFL51F05,6
	LW	RFL51F06,6
	LW	RFL51F07,9
	LWL	RFL51F08,AFUNC|127,a_ref_hold_puck
	LW	RFL51F08,127
	LW	RFL51F08,127
	LW	RFL51F08,127
	LW	RFL51F08,127
	LW	RFL51F08,127
	LW	RFL51F08,127
	LW	RFL51F08,127
	LW	RFL51F08,127
	LW	RFL51F08,127
	LW	RFL51F08,127
	LW	RFL51F08,127
	LW	RFL51F08,127
	LW	RFL51F08,127
	LW	RFL51F08,127
	.long	0

ref_setup_medium_script
	LWW	RFM51F01,AFLIP|6,0
	LW	RFM51F02,6
	LW	RFM51F03,15
	LW	RFM51F04,3
	LW	RFM51F05,6
	LW	RFM51F06,6
	LW	RFM51F07,9
	LWL	RFM51F08,AFUNC|127,a_ref_hold_puck
	LW	RFM51F08,127
	LW	RFM51F08,127
	LW	RFM51F08,127
	LW	RFM51F08,127
	LW	RFM51F08,127
	LW	RFM51F08,127
	LW	RFM51F08,127
	LW	RFM51F08,127
	LW	RFM51F08,127
	LW	RFM51F08,127
	LW	RFM51F08,127
	LW	RFM51F08,127
	LW	RFM51F08,127
	LW	RFM51F08,127
	.long	0

ref_setup_small_script
	LWW	RFS51F01,AFLIP|6,0
	LW	RFS51F02,6
	LW	RFS51F03,15
	LW	RFS51F04,3
	LW	RFS51F05,6
	LW	RFS51F06,6
	LW	RFS51F07,9
	LWL	RFS51F08,AFUNC|127,a_ref_hold_puck
	LW	RFS51F08,127
	LW	RFS51F08,127
	LW	RFS51F08,127
	LW	RFS51F08,127
	LW	RFS51F08,127
	LW	RFS51F08,127
	LW	RFS51F08,127
	LW	RFS51F08,127
	LW	RFS51F08,127
	LW	RFS51F08,127
	LW	RFS51F08,127
	LW	RFS51F08,127
	LW	RFS51F08,127
	LW	RFS51F08,127
	.long	0

ref_alt_setup_medium_script
	LWW	RMD61F01,AFLIP|5,0
	LW	RMD61F02,4
	LW	RMD61F03,5
	LW	RMD61F04,9
	LW	RMD61F05,7
	LW	RMD61F06,4
	LW	RMD61F07,5
	LW	RMD61F08,9
	LW	RMD61F09,6
	LW	RMD61F10,7
	LW	RMD61F11,7
	LW	RMD71F02,5
	LW	RMD71F03,5
	LW	RMD71F04,5
	LWL	RMD71F05,AFUNC|7,a_ref_hold_puck
	LWL	RMD71F06,AFUNC|127,a_ref_hold_puck
	LW	RMD71F06,127
	LW	RMD71F06,127
	LW	RMD71F06,127
	LW	RMD71F06,127
	LW	RMD71F06,127
	LW	RMD71F06,127
	LW	RMD71F06,127
	LW	RMD71F06,127
	LW	RMD71F06,127
	LW	RMD71F06,127
	LW	RMD71F06,127
	LW	RMD71F06,127
	LW	RMD71F06,127
	LW	RMD71F06,127
	.long	0

ref_drop_large_script
	LWWL	RFL51F09,AFUNC|AFLIP|1,0,a_ref_hold_puck
	LWL	RFL51F09,AFUNC|1,a_ref_puck_half
	LWL	RFL51F09,AFUNC|1,a_ref_puck_0
	LW	RFL51F11,2
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	LW	RFL51F11,127
	.long	0

ref_drop_medium_script
	LWWL	RFM51F09,AFUNC|AFLIP|1,0,a_ref_hold_puck
	LWL	RFM51F09,AFUNC|1,a_ref_puck_half
	LWL	RFM51F09,AFUNC|1,a_ref_puck_0
	LW	RFM51F11,2
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	LW	RFM51F11,127
	.long	0

ref_drop_small_script
	LWWL	RFS51F09,AFUNC|AFLIP|1,0,a_ref_hold_puck
	LWL	RFS51F09,AFUNC|1,a_ref_puck_half
	LWL	RFS51F09,AFUNC|1,a_ref_puck_0
	LW	RFS51F11,2
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	LW	RFS51F11,127
	.long	0

ref_alt_drop_medium_script
	LWWL	RMD71F07,AFUNC|AFLIP|1,0,a_ref_hold_puck
	LWL	RMD71F07,AFUNC|1,a_ref_puck_half
	LWL	RMD71F07,AFUNC|1,a_ref_puck_0
	LW	RMD71F08,3
	LW	RMD71F09,127
	LW	RMD71F09,127
	LW	RMD71F09,127
	LW	RMD71F09,127
	LW	RMD71F09,127
	LW	RMD71F09,127
	LW	RMD71F09,127
	LW	RMD71F09,127
	LW	RMD71F09,127
	LW	RMD71F09,127
	LW	RMD71F09,127
	LW	RMD71F09,127
	.long	0

ref_look_large_script
	LWW	RFL51F01b,AFLIP|30,0
	LW	RFL51F01a,7
	LW	RFL51F01b,7
	LW	RFL51F01c,7
	LW	RFL51F01d,7
	LW	RFL51F01c,7
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	LW	RFL51F01b,127
	.long	0

ref_look_medium_script
	LWW	RFM51F01b,AFLIP|30,0
	LW	RFM51F01a,7
	LW	RFM51F01b,7
	LW	RFM51F01c,7
	LW	RFM51F01d,7
	LW	RFM51F01c,7
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	LW	RFM51F01b,127
	.long	0

ref_look_small_script
	LWW	RFS51F01b,AFLIP|30,0
	LW	RFS51F01a,7
	LW	RFS51F01b,7
	LW	RFS51F01c,7
	LW	RFS51F01d,7
	LW	RFS51F01c,7
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	LW	RFS51F01b,127
	.long	0

ref_stand_large_script
	LWW	RFL51F03,AFLIP|127,0
	.long	0
ref_stand_medium_script
	LWW	RFM51F03,AFLIP|127,0
	.long	0
ref_stand_small_script
	LWW	RFS51F03,AFLIP|127,0
	.long	0

ref_skate_right_large_script
	LWW	RSTL3F01,AFLIP|1,0
	LW	RSTL3F02,2
	LWL	RSTL3F03,AFUNC|2,a_spd_right
	LW	RSTL3F09,3
	LW	RSKL3F02,3
	LW	RSKL3F03,3
	LW	RSKL3F04,3
	LW	RSKL3F05,3
	LWL	RLG23F02,AFUNC|3,a_speed_up
	LW	RLG23F03,3
	LW	RLG23F04,3
	LW	RLG23F05,3
rskl1	LW	RLG23F06,8
	LW	RLG63F06,8
	LWL	RLG23F06,AFUNC|8,a_ref_logic_right
	LWL	RLG63F06,AFUNC|8,a_branch+2
	.long	 rskl1
	.long	0

ref_skate_right_medium_script
	LWW	RSTM3F01,AFLIP|1,0
	LW	RSTM3F02,2
	LWL	RSTM3F03,AFUNC|2,a_spd_right
	LW	RSTM3F09,3
	LW	RSKM3F02,3
	LW	RSKM3F03,3
	LW	RSKM3F04,3
	LW	RSKM3F05,3
	LWL	RMD23F02,AFUNC|3,a_speed_up
	LW	RMD23F03,3
	LW	RMD23F04,3
	LW	RMD23F05,3
rskm1	LW	RMD23F06,8
	LW	RMD63F06,8
	LWL	RMD23F06,AFUNC|8,a_ref_logic_right
	LWL	RMD63F06,AFUNC|8,a_branch+2
	.long	 rskm1
	.long	0

ref_skate_right_small_script
	LWW	RSTS3F01,AFLIP|1,0
	LW	RSTS3F02,2
	LWL	RSTS3F03,AFUNC|2,a_spd_right
	LW	RSTS3F09,3
	LW	RSKS3F02,3
	LW	RSKS3F03,3
	LW	RSKS3F04,3
	LW	RSKS3F05,3
	LWL	RSM23F02,AFUNC|3,a_speed_up
	LW	RSM23F03,3
	LW	RSM23F04,3
	LW	RSM23F05,3
rsks1	LW	RSM23F06,8
	LW	RSM63F06,8
	LWL	RSM23F06,AFUNC|8,a_ref_logic_right
	LWL	RSM63F06,AFUNC|8,a_branch+2
	.long	 rsks1
	.long	0

a_spd_right
	movi	[6,0],a0
	move	a0,*a8(OXVEL),L
	rets

ref_skate_left_large_script
	LWW	RSTL3F01,AFLIP|1,M_FLIPH
	LW	RSTL3F02,2
	LWL	RSTL3F03,AFUNC|2,a_spd_left
	LW	RSTL3F09,3
	LW	RSKL3F02,3
	LW	RSKL3F03,3
	LW	RSKL3F04,3
	LW	RSKL3F05,3
	LWL	RLG23F02,AFUNC|3,a_speed_up
	LW	RLG23F03,3
	LW	RLG23F04,3
	LW	RLG23F05,3
lskl1	LW	RLG23F06,8
	LW	RLG63F06,8
	LWL	RLG23F06,AFUNC|8,a_ref_logic_left
	LWL	RLG63F06,AFUNC|8,a_branch+2
	.long	 lskl1
	.long	0

ref_skate_left_medium_script
	LWW	RSTM3F01,AFLIP|1,M_FLIPH
	LW	RSTM3F02,2
	LWL	RSTM3F03,AFUNC|2,a_spd_left
	LW	RSTM3F09,3
	LW	RSKM3F02,3
	LW	RSKM3F03,3
	LW	RSKM3F04,3
	LW	RSKM3F05,3
	LWL	RMD23F02,AFUNC|3,a_speed_up
	LW	RMD23F03,3
	LW	RMD23F04,3
	LW	RMD23F05,3
lskm1	LW	RMD23F06,8
	LW	RMD63F06,8
	LWL	RMD23F06,AFUNC|8,a_ref_logic_left
	LWL	RMD63F06,AFUNC|8,a_branch+2
	.long	 lskm1
	.long	0

ref_skate_left_small_script
	LWW	RSTS3F01,AFLIP|1,M_FLIPH
	LW	RSTS3F02,2
	LWL	RSTS3F03,AFUNC|2,a_spd_left
	LW	RSTS3F09,3
	LW	RSKS3F02,3
	LW	RSKS3F03,3
	LW	RSKS3F04,3
	LW	RSKS3F05,3
	LWL	RSM23F02,AFUNC|3,a_speed_up
	LW	RSM23F03,3
	LW	RSM23F04,3
	LW	RSM23F05,3
lsks1	LW	RSM23F06,8
	LW	RSM63F06,8
	LWL	RSM23F06,AFUNC|8,a_ref_logic_left
	LWL	RSM63F06,AFUNC|8,a_branch+2
	.long	 lsks1
	.long	0

a_spd_left
	movi	[-6,0],a0
	move	a0,*a8(OXVEL),L
	rets

a_ref_logic_left
	move	@SCROLLX,a1,L
	move	a1,a14
	abs	a14
	cmpi	[2,0],a14
	move	*a8(OXVEL),a0,L
	move	a1,a14
	move	a0,a2
	sra	31,a14
	sra	31,a2
	cmp	a14,a2
	jrnz	a_speed_up	;different direction

	subi	[20,0],a0
	cmp	a1,a0
	jrgt	a_speed_up
	jruc	set_ref_stop_backwards_script

a_ref_logic_right
	move	@SCROLLX,a1,L
	move	a1,a14
	abs	a14
	cmpi	[2,0],a14
	move	*a8(OXVEL),a0,L
	move	a1,a14
	move	a0,a2
	sra	31,a14
	sra	31,a2
	cmp	a14,a2
	jrnz	a_speed_up	;different direction

	addi	[20,0],a0
	cmp	a1,a0
	jrlt	a_speed_up
	jruc	set_ref_stop_backwards_script

a_speed_up
	move	*a8(OXVEL),a0,L
	move	a0,a14
	sra	2,a14
	add	a14,a0
	sra	1,a14
	add	a14,a0
	move	a0,*a8(OXVEL),L
	rets

a_ref_hold_puck
	calla	get_players_puck_point_rz
	subi	200,a1
	move	@PUCK_OBJECT,a8,L
	clr	a14
	move	a14,*a8(OXVEL),L
	move	a14,*a8(OYVEL),L
	move	a14,*a8(OZVEL),L
	move	a0,*a8(OXVAL),L
	move	a1,*a8(OZVAL),L
	move	a2,*a8(OYVAL),L
	calla	set_puck_script
	jauc	turn_puck_on

a_ref_puck_half
	move	@PUCK_OBJECT,a9,L
	clr	a14
	move	a14,*a9(OXVEL),L
	move	a14,*a9(OYVEL),L
	move	a14,*a9(OZVEL),L
	move	*a9(OYVAL),a2,L
	sra	1,a2
	move	a2,*a9(OYVAL),L
	rets

a_ref_puck_0
	move	@PUCK_OBJECT,a9,L
	clr	a2
	move	a2,*a9(OYVAL),L
	jauc	puck_faceoff_drop_show


ref_skate_right_f_large_script
	LWW	RSTL3F09,AFLIP|3,0
	LW	RSKL3F02,3
	LW	RSKL3F03,3
	LW	RSKL3F04,3
	LW	RSKL3F05,3
	LW	RSKL3F06,3
	LW	RSKL3F07,3
	LW	RSKL3F08,3
	LW	RSKL3F09,3
	LW	RSKL3F10,3
	.long	0
ref_skate_right_f_medium_script
	LWW	RSTM3F09,AFLIP|3,0
	LW	RSKM3F02,3
	LW	RSKM3F03,3
	LW	RSKM3F04,3
	LW	RSKM3F05,3
	LW	RSKM3F06,3
	LW	RSKM3F07,3
	LW	RSKM3F08,3
	LW	RSKM3F09,3
	LW	RSKM3F10,3
	.long	0
ref_skate_right_f_small_script
	LWW	RSTS3F09,AFLIP|3,0
	LW	RSKS3F02,3
	LW	RSKS3F03,3
	LW	RSKS3F04,3
	LW	RSKS3F05,3
	LW	RSKS3F06,3
	LW	RSKS3F07,3
	LW	RSKS3F08,3
	LW	RSKS3F09,3
	LW	RSKS3F10,3
	.long	0

ref_skate_left_f_large_script
	LWW	RSTL3F09,AFLIP|3,M_FLIPH
	LW	RSKL3F02,3
	LW	RSKL3F03,3
	LW	RSKL3F04,3
	LW	RSKL3F05,3
	LW	RSKL3F06,3
	LW	RSKL3F07,3
	LW	RSKL3F08,3
	LW	RSKL3F09,3
	LW	RSKL3F10,3
	.long	0
ref_skate_left_f_medium_script
	LWW	RSTM3F09,AFLIP|3,M_FLIPH
	LW	RSKM3F02,3
	LW	RSKM3F03,3
	LW	RSKM3F04,3
	LW	RSKM3F05,3
	LW	RSKM3F06,3
	LW	RSKM3F07,3
	LW	RSKM3F08,3
	LW	RSKM3F09,3
	LW	RSKM3F10,3
	.long	0
ref_skate_left_f_small_script
	LWW	RSTS3F09,AFLIP|3,M_FLIPH
	LW	RSKS3F02,3
	LW	RSKS3F03,3
	LW	RSKS3F04,3
	LW	RSKS3F05,3
	LW	RSKS3F06,3
	LW	RSKS3F07,3
	LW	RSKS3F08,3
	LW	RSKS3F09,3
	LW	RSKS3F10,3
	.long	0

ref_stop_f_large_script
rslr10	LW	RLG43F02,3
	LW	RLG43F03,3
rslr11	LWLLL	RLG43F04,AFUNC|1,a_loop_til_zero+4,rslr10,rslr11
	LW	RLG43F05,127
	LW	RLG43F05,127
	LW	RLG43F05,127
	LW	RLG43F05,127
	.long	0
ref_stop_f_medium_script
rsmr10	LW	RMD43F02,3
	LW	RMD43F03,3
rsmr11	LWLLL	RMD43F04,AFUNC|1,a_loop_til_zero+4,rsmr10,rsmr11
	LW	RMD43F05,127
	LW	RMD43F05,127
	LW	RMD43F05,127
	LW	RMD43F05,127
	.long	0
ref_stop_f_small_script
rssr10	LW	RSM43F02,3
	LW	RSM43F03,3
rssr11	LWLLL	RSM43F04,AFUNC|1,a_loop_til_zero+4,rssr10,rssr11
	LW	RSM43F05,127
	LW	RSM43F05,127
	LW	RSM43F05,127
	LW	RSM43F05,127
	.long	0

ref_stop_b_large_script
rslb10	LW	RLG33F02,3
	LW	RLG33F03,3
rslb11	LWLLL	RLG33F04,AFUNC|1,a_loop_til_zeros+4,rslb10,rslb11
	LW	RLG33F05,6
	LWL	1,AFUNC|1,a_smart_ref_direction
	.long	0
ref_stop_b_medium_script
rsmb10	LW	RMD33F02,3
	LW	RMD33F03,3
rsmb11	LWLLL	RMD33F04,AFUNC|1,a_loop_til_zeros+4,rsmb10,rsmb11
	LW	RMD33F05,6
	LWL	1,AFUNC|1,a_smart_ref_direction
	.long	0
ref_stop_b_small_script
rssb10	LW	RSM33F02,3
	LW	RSM33F03,3
rssb11	LWLLL	RSM33F04,AFUNC|1,a_loop_til_zeros+4,rssb10,rssb11
	LW	RSM33F05,6
	LWL	1,AFUNC|1,a_smart_ref_direction
	.long	0

a_smart_ref_direction
	move	@SCROLLX,a2,L
	move	a2,a14
	abs	a14
	cmpi	[4,0],a14
	jrhi	asrd1
	move	*a8(OXPOS),a2,W
asrd1	movi	set_ref_skate_right_script,a1
	move	a2,a2
	jrn	asrd9
	movi	set_ref_skate_left_script,a1
asrd9	jump	a1

a_loop_til_zeros
	move	*a8(OXVEL),a1,L
	clr	a2
	movk	25,a3
	calla	move_to_speed_x
	move	a1,a14
	abs	a14
	cmpi	[2,0],a14
	jrhi	ahrr
	clr	a1
ahrr	move	a1,*a8(OXVEL),L
	;
a_loop_til_zero
	move	*a8(OXVEL),a0,L
	jrz	altz9
	move	*a8(ANIMARG),a0,L
	move	*a8(ANIMSCR),a1,L
	move	*a0+,a14,L
	cmp	a1,a14
	jrnz	altz9
	move	*a0+,a14,L
	move	a14,*a8(ANIMFRM),L
altz9	rets
