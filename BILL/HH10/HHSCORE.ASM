 	.MLIB	"HHMACS.LIB"
	.FILE	"HHSCORE.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhscore.e"
	.include	"hhpuck.g"
	.include	"hhproc.g"
	.include	"hhgame.g"
	.include	"hh.g"
	.include	"hhd.g"
	.include	"hhram.g"
	.include	"hhplayer.g"
	.include	"hhhigher.g"
	.include	"hhc.g"
	.include	"hhutil.g"
	.include	"hhtimer.g"

; end of include files


	.TEXT
	.EVEN

score_left_team
	move	@team1_score,a14,W
	inc	a14
	move	a14,@team1_score,W
	callr	goal_cycle
	jruc	sc_50
score_right_team
	move	@team2_score,a14,W
	inc	a14
	move	a14,@team2_score,W
	callr	goal_cycle
sc_50	movk	1,a0
	move	a0,@puck_allowed_state,W
	movi	99,a0
	move	a0,@PUCK_MODE,W			;turn control off
	rets

goal_cycle
	C_A_K	PID_GOAL_CYCLE,gc_1
	rets

gc_1	movi	400,a0			;take us through to face off
	calla	show_timer_ts		;show timer for 3 seconds
	calla	stop_timer
	sleep	100
	calla	reset_puck_position
	calla	reset_players_turbo
	calla	faceoff
	jauc	SUCIDE
