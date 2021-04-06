 	.MLIB	"HHMACS.LIB"
	.FILE	"HHDRONE.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*

	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhdrone.e"
	.include	"hhpuck.g"
	.include	"hhtimer.g"
	.include	"hhplayer.g"
	.include	"hhgame.g"
	.include	"hhcontrl.g"
	.include	"hhproc.g"

; end of include files

	.bss	rm_puck,16
	.bss	rm_time,16
	.bss	rm_location,16
	.bss	rm_team_pos,16
	.bss	rm_puck_loc,16
	.bss	rm_signal,16
	.bss	rm_score,16
	.bss	xxxxx,16

do_drone_logic
	movk	4,a0
	move	@PUCK_CONTROL,a14,W
	jrz	p_puck8
	movk	1,a0
	movb	*a6(POF_NUMBER),a1
	cmp	a1,a14
	jrz	p_puck8
	movk	2,a0
	dec	a1
	dec	a14
	srl	2,a1
	srl	2,a14
	cmp	a1,a14
	jrz	p_puck8
	movk	3,a0
p_puck8	move	a0,@rm_puck,W
p_time	movk	1,a0
	move	@minutes,a1,W
	jrnz	p_time8
	move	@tenseconds,a1,W
	jrnz	p_time8
	movk	2,a0
	move	@seconds,a1,W
	cmpi	3,a1
	jrhs	p_time8
	movk	3,a0
p_time8	move	a0,@rm_time,W
p_loc	movb	*a6(POF_NUMBER),a0
	move	*a8(OXPOS),a1,W
	callr	floc
	move	a1,@rm_location,W
p_team	movb	*a6(POF_NUMBER),a0
	move	a0,a5
	sll	7,a5
	addi	tclist-128,a5
	move	*a5+,a7,L
	move	*a7,a7,L
	move	*a7(OXPOS),a1,W
	callr	floc
	move	a1,a2
	move	*a5+,a7,L
	move	*a7,a7,L
	move	*a7(OXPOS),a1,W
	callr	floc
	.if	nskaters=3
	move	a1,a3
	move	*a5+,a7,L
	move	*a7,a7,L
	move	*a7(OXPOS),a1,W
	callr	floc
	cmp	a1,a3
	jrls	ptx2
	move	a3,a1
ptx2
	.endif
	cmp	a1,a2
	jrls	ptx3
	move	a2,a1
ptx3	move	a1,@rm_team_pos,W
p_ploc	move	@PUCK_OBJECT,a1,W
	move	*a1(OXPOS),a1,W
	movb	*a6(POF_NUMBER),a0
	callr	floc
	move	a1,@rm_puck_loc,W
p_sgnl	movk	1,a1
	movb	*a6(POF_NUMBER),a5
	sll	7,a5
	addi	tclist-128,a5
	move	*a5+,a7,L
	callr	chksig
	move	*a5+,a7,L
	callr	chksig
	.if	nskaters=3
	move	*a5+,a7,L
	callr	chksig
	.endif
	move	a1,@rm_signal,W
p_scor	movk	3,a0
	move	@team1_score,a1,W
	move	@team2_score,a2,W
	sub	a2,a1
	jrz	pscr8
	jrn	pscr2
	movk	4,a0
	cmpi	1,a1
	jrz	pscr8
	movk	5,a0
	jruc	pscr8
pscr2	movk	2,a0
	cmpi	-1,a1
	jrz	pscr8
	movk	1,a0
pscr8	subk	6,a0
	neg	a0
	move	a0,@rm_score,W
	movi	rm_puck,a5
	movi	drone_top_level,a9
	MOVE	*A6(POF_FLAGS),A14,W
	BTST	B_PF_GOALIE,A14
	JRZ	match_table			;BR=NOT A GOALIE DRONE
	MOVI	DRONE_GOALIE_TOP_LEVEL,A9
	jruc	match_table

floc	move	a0,a14
	dec	a14
	srl	2,a14
	jrz	fl1
	neg	a1
fl1	cmpi	-235,a1
	jrle	fli1
	cmpi	235,a1
	jrle	fli2
fli3	movk	3,a1
	rets
fli2	movk	2,a1
	rets
fli1	movk	1,a1
	rets

chksig	cmpi	2,a1
	jrz	chk9
	subi	POF_OBJECT,a7
	move	*a7(POF_FLAGS),a14,W
	btst	B_PF_SIG_PASS,a14
	jrnz	cs_2
	btst	B_PF_SIG_SHOOT,a14
	jrnz	cs_3
chk9	rets
cs_2	movk	2,a1
	rets
cs_3	movk	3,a1
	rets

tclist	.long	PLAYER_2_BLOCK+POF_OBJECT
	.long	PLAYER_4_BLOCK+POF_OBJECT
	.long	PLAYER_3_BLOCK+POF_OBJECT
	.long	0

	.long	PLAYER_1_BLOCK+POF_OBJECT
	.long	PLAYER_4_BLOCK+POF_OBJECT
	.long	PLAYER_3_BLOCK+POF_OBJECT
	.long	0

	.long	PLAYER_1_BLOCK+POF_OBJECT
	.long	PLAYER_2_BLOCK+POF_OBJECT
	.long	PLAYER_4_BLOCK+POF_OBJECT
	.long	0

	.long	PLAYER_1_BLOCK+POF_OBJECT
	.long	PLAYER_2_BLOCK+POF_OBJECT
	.long	PLAYER_3_BLOCK+POF_OBJECT
	.long	0

	.long	PLAYER_6_BLOCK+POF_OBJECT
	.long	PLAYER_8_BLOCK+POF_OBJECT
	.long	PLAYER_7_BLOCK+POF_OBJECT
	.long	0

	.long	PLAYER_5_BLOCK+POF_OBJECT
	.long	PLAYER_8_BLOCK+POF_OBJECT
	.long	PLAYER_7_BLOCK+POF_OBJECT
	.long	0

	.long	PLAYER_5_BLOCK+POF_OBJECT
	.long	PLAYER_6_BLOCK+POF_OBJECT
	.long	PLAYER_8_BLOCK+POF_OBJECT
	.long	0

	.long	PLAYER_5_BLOCK+POF_OBJECT
	.long	PLAYER_6_BLOCK+POF_OBJECT
	.long	PLAYER_7_BLOCK+POF_OBJECT
	.long	0

**************************************************************************
*								         *
* match_table								 *
* 	input	a5 = pointer to list of items to match			 *
* 		a9= pointer to table to match against			 *
*								         *
**************************************************************************
match_table
c2	move	a9,a11
	move	a5,a7
	movk	7,b1
c1	move	*a7+,a14,W
	move	*a11+,a0,W
	jrz	cy
	cmp	a14,a0
	jrnz	cn
cy	dsjs	b1,c1
	move	*a11+,a0,L
	jump	a0
cn	addi	144,a9
	jruc	c2

**************************************************************************
*								         *
* PUCK 1 us     TIME 1 plenty     LOCATION 1 our side   TEAM POS. 1 our	 *
*      2 team        2 not much	           2 center ice		  2 cntr *
*      3 opponent    3 very little	   3 other side		  3 othr *
*      4 nobody								 *
* 									 *
* PUCK LOC. 1 our side    SIGNAL 1 nothing	SCORE  1 ahead more	 *
* 	    2 center ice	 2 pass		       2 ahead one	 *
* 	    3 other side	 3 shoot	       3 tied		 *
* 			         		       4 behind one	 *
* 			         		       5 behind more	 *
* 									 *
*  WWWWWWWL PUCK,TIME,LOCATION,TEAM_POS,PUCK_LOC,SIGNAL,SCORE,address	 *
*								         *
**************************************************************************
;		 P T L T P S S
;		 U I O E L I C
;		 C M C A O G O
;		 K E   M C   R
drone_top_level
	WWWWWWWL 1,0,0,0,0,2,0,dr_pass
	WWWWWWWL 1,0,0,0,0,3,0,dr_shoot
	WWWWWWWL 1,3,3,0,0,0,1,dr_hold_dump_or_shoot
	WWWWWWWL 1,3,0,0,0,0,1,dr_hold_or_dump
	WWWWWWWL 1,3,0,0,0,0,2,dr_hold_dump_or_shoot
	WWWWWWWL 1,3,0,0,0,0,0,dr_shoot
	WWWWWWWL 1,2,1,2,0,0,0,dr_pass_or_skate_forward
	WWWWWWWL 1,2,1,0,0,0,0,dr_skate_forward_or_pass
	WWWWWWWL 1,2,2,1,0,0,0,dr_skate_forward
	WWWWWWWL 1,2,2,0,0,0,0,dr_skate_forward_or_pass
	WWWWWWWL 1,2,0,3,0,0,1,dr_set_up_shot_or_pass
	WWWWWWWL 1,2,0,0,0,0,1,dr_set_up_shot
	WWWWWWWL 1,2,0,3,0,0,2,dr_set_up_shot_or_pass
	WWWWWWWL 1,2,0,0,0,0,2,dr_set_up_shot
	WWWWWWWL 1,2,0,3,0,0,3,dr_set_up_shot_or_pass
	WWWWWWWL 1,2,0,0,0,0,3,dr_set_up_shot
	WWWWWWWL 1,2,0,3,0,0,4,dr_shoot_set_up_shot_or_pass
	WWWWWWWL 1,2,0,0,0,0,4,dr_shoot_or_set_up_shot
	WWWWWWWL 1,2,0,3,0,0,0,dr_shoot_set_up_shot_or_pass
	WWWWWWWL 1,2,0,0,0,0,0,dr_shoot_or_set_up_shot
	WWWWWWWL 1,1,1,2,0,0,0,dr_pass_or_skate_forward
	WWWWWWWL 1,1,1,0,0,0,0,dr_skate_forward_or_pass
	WWWWWWWL 1,1,2,2,0,0,0,dr_skate_forward_or_pass
	WWWWWWWL 1,1,2,3,0,0,0,dr_skate_forward_or_pass
	WWWWWWWL 1,1,2,0,0,0,0,dr_skate_forward
	WWWWWWWL 1,1,0,3,0,0,0,dr_shoot_set_up_shot_or_pass
	WWWWWWWL 1,1,0,0,0,0,0,dr_shoot_or_set_up_shot
	WWWWWWWL 0,0,0,0,0,0,0,dr_none

;		 P T L T P S S
;		 U I O E L I C
;		 C M C A O G O
;		 K E   M C   R
DRONE_GOALIE_TOP_LEVEL
	WWWWWWWL 1,0,0,0,0,2,0,DRG_PASS
	WWWWWWWL 0,0,0,0,0,0,0,DRG_NONE

DRG_NONE
	rets

DRG_PASS
	movb	*a6(POF_NUMBER),a1
	sll	8,a1
	addi	PIDOF_PASS,a1
	movi	dpr,a7
	calla	GETPPRC
	rets

dr_none
	clr	a1
	jruc	do_joy_and_move
dr_pass
	movb	*a6(POF_NUMBER),a1
	sll	8,a1
	addi	PIDOF_PASS,a1
	movi	dpr,a7
	calla	GETPPRC
	clr	a1
	jruc	do_joy_and_move
dpr	move	a10,a0
	calla	get_player_block
	move	*a6(POF_OBJECT),a8,L
	jauc	pass_puck
dr_shoot
	mmtm	sp,a10
	calla	clear_all_signals
	calla	sp_turbo
	clr	a1
	callr	do_joy_and_move
	mmfm	sp,a10
	rets
dr_dump
	rets
dr_hold_dump_or_shoot
	callr	is_our_position_safe
	jrc	dhds1
	callr	is_our_shot_good
	jrc	dr_shoot
	jruc	dr_dump
dhds1	clr	a1
	jruc	do_joy_and_move
dr_hold_or_dump
	callr	is_our_position_safe
	jrc	dhd1
	jruc	dr_dump
dhd1	clr	a1
	jruc	do_joy_and_move
dr_pass_or_skate_forward
	movk	3,a1
	jruc	do_joy_and_move
dr_skate_forward_or_pass
	movk	3,a1
	jruc	do_joy_and_move
dr_skate_forward
	callr	set_drone_turbo_on
	movk	3,a1
	jruc	do_joy_and_move
dr_set_up_shot_or_pass
	clr	a1
	jruc	do_joy_and_move
dr_set_up_shot
	clr	a1
	jruc	do_joy_and_move
dr_shoot_set_up_shot_or_pass
	clr	a1
	callr	do_joy_and_move
	jruc	dr_shoot
dr_shoot_or_set_up_shot
	clr	a1
	callr	do_joy_and_move
	jruc	dr_shoot

set_drone_turbo_on
	movk	1,a14
	move	a14,*a6(POF_TURBO_MODE),W
	rets
set_drone_turbo_off
	clr	a14
	move	a14,*a6(POF_TURBO_MODE),W
	rets
do_joy_and_move

	calla	set_team_adjusted_drone_joystick
	calla	move_player
	jauc	face_player

is_our_position_safe
is_our_shot_good
	clrc
	rets
