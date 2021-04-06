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
	.include	"hhscore.tbl"
	.INCLUDE	"NETEXPLO.TBL"
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
	.include	"hhshow.g"
	.include	"hhmisc.g"
	.include	"hhspeech.g"
	.include	"hhpall.g"
	.include	"hhselect.g"
	.include	"hhstable.g"
	.include	"hhstabl2.g"
;	.include	"hhmath.g"
	.ref	set_obj_to_rect
	.ref	move_to_speed_x
	.include	"hhscr_fn.g"
	.include	"hhscr_cb.g"
	.include	"hhcmos.g"
	.include	"hhcontr2.g"
;	.include	"hhndrone.g"
	.ref	set_drone_levels
	.include	"hhcontrl.g"
	.include	"hhstats.g"
	.include	"hhvids.g"
	.include	"hhsnd.g"
	.include	"hhcontr3.g"

; end of include files

	.bss	has_scored,16
	.bss	scored_by,16
	.bss	assist_by,16
	.bss	team_scored,16

	.bss	VIDCLIP_PLAYER,16
	.bss	VIDCLIP_TIME,32

	.bss	VIDCLIP_TYPE,16
	.bss	FIRE_GOAL,16

	.BSS	EXPLO_FLAG,16			;UHW GOAL EXPLODING FLAG
	.BSS	EXPLO_COVER_FLAG,16		;UHW EXPLOSION COVER FLAG

	.TEXT
	.EVEN

;types from hhspeech

DEKE_TYPE	.equ	5
SLOT_TYPE	.equ	8

SLAP_TYPE	.equ	-1	;not a location type
SPIN_TYPE	.equ	-3	;not a location type

;SCORE_LAMP_PROC
;	MOVE	A9,A0
;	CALLA	LAMP_ON
;	SLEEP	120
;	MOVE	A9,A0
;	CALLA	LAMP_OFF
;	DIE

score_left_team
	move	@has_scored,a14,W
	jrnz	sc99
	move	@WAVEIRQS,@time_score_left,L	;easier
	move	@team1_score,a14,W
	inc	a14
	move	a14,@has_scored,W
	move	a14,@team1_score,W
	movk	1,a14
	move	a14,@team_scored,W
	callr	record_goal_assist_t1
;	MOVK	M_RGHT_LAMP,A9
;	CREATE	PID_LAMP,SCORE_LAMP_PROC
	move	@GAME_STATE,a14
	cmpi	INAMODE,a14
	jrz	sltrk
	mmtm	sp,a0,a4
	movi	AUD_LEFT_GOALS,a0
	calla	AUD1
	calla	find_cpu_team
	cmpi	1,a4
	jrnz	nonc1
	movi	AUD_CPU_TEAM_GOALS,a0
	calla	AUD1
nonc1	mmfm	sp,a0,a4
sltrk	jruc	sc_50
score_right_team
	move	@has_scored,a14,W
	jrnz	sc99
	move	@WAVEIRQS,@time_score_right,L	;easier
	move	@team2_score,a14,W
	inc	a14
	move	a14,@has_scored,W
	move	a14,@team2_score,W
	movk	2,a14
	move	a14,@team_scored,W
	callr	record_goal_assist_t2
;	MOVK	M_LEFT_LAMP,A9
;	CREATE	PID_LAMP,SCORE_LAMP_PROC
	move	@GAME_STATE,a14
	cmpi	INAMODE,a14
	jrz	srtrk
	mmtm	sp,a0,a4
	movi	AUD_RIGHT_GOALS,a0
	calla	AUD1
	calla	find_cpu_team
	cmpi	2,a4
	jrnz	nonc2
	movi	AUD_CPU_TEAM_GOALS,a0
	calla	AUD1
nonc2	mmfm	sp,a0,a4
srtrk	
sc_50
	clr	a14
	move	a14,@global_control_slow,W
	calla	clean_fill_scores
	calla	flash_team_who_scored
	calla	fix_palette_lights
	callr	goal_cycle
	movi	99,a0
	calla	set_safe_puck_mode_a0		;turn control off
	calla	kill_all_trails

	MOVE	@GOALIE_MISS,A0,W
	JRZ	SC_CHECK_PAY_OT			;BR=GOALIE SUCKED!

	MOVE	@GAME_STATE,A0,W
	CMPI	INAMODE,A0
	JREQ	SC_CHECK_PAY_OT			;BR=IN ATTRACT MODE
	MOVE	@PUCK_MODE,A0,W
	CMPI	PUM_FACEOFF,A0
	JRHS	SC_CHECK_PAY_OT			;BR=FACEOFF OR END OF PERIOD
	MOVI	AUD_GOALIE_MISSES,A0
	CALLA	AUD1
SC_CHECK_PAY_OT

	move	@period,a0,W
	cmpi	4,a0
	JRNE	SC_GO				;BR=NOT OVERTIME

	MOVK	ADJPAYOT,A0
	CALLA	GET_ADJ				;CHECK FOR FULL OVERTIME
	JRZ	sc_51				;BR=NOPE, SUDDEN DEATH
SC_GO
	callr	score_by_window
	calla	set_drone_levels
	calla	check_on_fire
	calla	spx_score
	calla	score_celebrations
	jruc	canned_puck_score
sc99	rets
sc_51	calla	spx_score_game_over
	P_FORK	period_over	;we can use our id, because it gets changed right away
	; taken out by mdp for doz callr	score_by_window
	;
canned_puck_score
	C_A_K	PID_CANNED_SCORE,can_puck_score_process
	;do some extra stuff here to help with display
	calla	kill_all_trails
	move	@PUCK_OBJECT,a7,L
	move	*a7(OCTRL),a14,W
	ori	M_WRNONZ,a14
	move	a14,*a7(OCTRL),W
	move	@PUCK_SHADOW,a7,L
	move	*a7(OCTRL),a14,W
	ori	M_WRNONZ,a14
	move	a14,*a7(OCTRL),W


	rets

**************************************************************************
*								         *
* get_potential_scorer							 *
* 	input	a1 = 0 for right goal, 1 for left goal			 *
* 	output	a0 = player who will be credited for score (or 0)	 *
*								         *
**************************************************************************
get_potential_scorer
	mmtm	sp,a2,a3
	movk	8,a14
	move	@puck_owner_pointer,a2,L
gps_1	callr	rtea	;get last owner in a3
	move	a3,a0
	dec	a3
	sra	2,a3
	cmp	a3,a1	;does owner match team
	jrz	gps_2	;goal scorer found
	dsjs	a14,gps_1
	clr	a0
gps_2	mmfm	sp,a2,a3
	rets

record_goal_assist_t1
	mmtm	sp,a1,a2,a3,a4,a6
	clr	a1
	jruc	rga1
record_goal_assist_t2
	mmtm	sp,a1,a2,a3,a4,a6
	movk	1,a1
rga1	mmtm	sp,a0
	move	@GAME_STATE,a0,W
	cmpi	INAMODE,a0
	jrz	nadj1
	movi	AUD_GOALS,a0
	calla	AUD1
nadj1	mmfm	sp,a0
	movk	8,a14
	move	@puck_owner_pointer,a2,L
rga2	callr	rtea	;get last owner in a3
	move	a3,a0
	dec	a3
	sra	2,a3
	cmp	a3,a1	;does owner match team
	jrz	rg_gf	;goal scorer found
	dsjs	a14,rga2
	clr	a14
	move	a14,@scored_by,W
	mmtm	sp,a0
	movi	AUD_UNCREDITED_GOALS,a0
	calla	AUD1
	mmfm	sp,a0
	jruc	rga9	;no scorer found (freak bounce?)
rg_gf	move	a0,@scored_by,W
	GBLOCK	a0,a6			;tally scorer in a0
	mmtm	sp,a0,a14
	movi	AUD_HUMAN_GOALS,a0
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrnz	ahg_0
	move	@GAME_STATE,a0,W
	cmpi	INAMODE,a0
	jrz	nadj4
	movi	AUD_CPU_PLAYER_GOALS,a0
ahg_0	calla	AUD1
nadj4	mmfm	sp,a0,a14
	move	@period,a4,W
	sll	3,a4
	addi	POF_GOALS_P1-8,a4
	add	a6,a4	;a4 POF_SHOTS offset by period
	CLR	A3
	MOVE	A3,*A6(POF_SHOT_ATTEMPTS),W		;CLEAR SCORER'S ATTEMPTS
	movb	*a4,a3
	inc	a3
	movb	a3,*a4	;assume we don't get >255 goals/period
	cmpi	1,a14
	jrz	rg_na	;we went back 8, no assist
	callr	rtea
	cmp	a0,a3
	jrz	rg_na	;we were last, no assist
	move	a3,a0
	dec	a3
	sra	2,a3
	cmp	a3,a1
	jrz	rg_af	;we have an assist
rg_na	clr	a0	;the other team (or 0) touched it before us, no assist
rg_af	move	a0,@assist_by,W
	move	a0,a0
	jrz	rga9	;don't tally, no assister
	mmtm	sp,a0
	move	@GAME_STATE,a0,W
	cmpi	INAMODE,a0
	jrz	nadj5
	movi	AUD_ASSISTS,a0
	calla	AUD1
nadj5	mmfm	sp,a0
	GBLOCK	a0,a6	;tally assister in a0
	move	@period,a4,W
	sll	3,a4
	addi	POF_ASSISTS_P1-8,a4
	add	a6,a4	;a4 POF_ASSISTS offset by period
	movb	*a4,a3
	inc	a3
	movb	a3,*a4	;assume we don't get >255 goals/period
rga9	mmfm	sp,a1,a2,a3,a4,a6
	rets

**************************************************************************
*								         *
* get_very_last_player							 *
*								         *
**************************************************************************
get_very_last_player
	move	@puck_owner_pointer,a2,L
	;
rtea	subk	8,a2
	cmpi	puck_owner_data,a2
	jrhs	rte1
	movi	puck_owner_pointer-8,a2
rte1	movb	*a2,a3
	rets

goal_cycle
	C_A_K	PID_GOAL_CYCLE,gc_1
	rets

gc_1	;calla	puck_score_show
	move	@period,a0,W
	cmpi	4,a0
	jrnz	gc4
	movk	ADJPAYOT,a0
	calla	GET_ADJ
	jrz	gc5
gc4	movi	400,a0			;take us through to face off
	calla	show_timer
gc5	calla	stop_timer
	move	@period,a14,W
	cmpi	4,a14
	jrnz	gc_45
	movk	ADJPAYOT,a0
	calla	GET_ADJ
	jrz	gcccc1
gc_45	calla	store_players_tired


GC_EXPLO_WAIT
	SLEEP	1
	MOVE	@EXPLO_FLAG,A14,W
	JRNZ	GC_EXPLO_WAIT		;BR=STILL EXPLODIN'

	sleep	80	;100
;	calla	reset_puck_position
	calla	reset_players_turbo
	clr	a0		;faceoff at 0,339
	movi	339,a1
	calla	spx_goal_faceoff
	calla	faceoff
gcccc1	jauc	SUCIDE

score_by_window
	move	@scored_by,a14,W
	jrz	sbw9
	C_A_KP	PID_SCORED_BY,score_by_ud
sbw9	rets

score_by_ud
	move	@scored_by,a14
	jrz	scort9		;safety
	GBLOCK	a14,a6
	callr	create_scored_by
suds2	move	@SUPPLSTS+5*020h,a8,L
	move	*a8(OYVAL),a14,L
	cmpi	[155,0],a14
	jrle	suds1
	movi	[155-22,0],a0
	sub	a14,a0
	sra	4,a0
	callr	svsupp5
	SLEEP	2
	jruc	suds2

;	movi	[-8,0],a0
;	callr	svsupp5
;	SLEEP	27

suds1	clr	a0
	callr	svsupp5
	SLEEP	60
	movi	[8,0],a0
	callr	svsupp5
	SLEEP	17
	clr	a14
	move	a14,@scored_by,W
	SLEEP	11
	movi	PID_BOXCOLOR,a0
	calla	KILLPROC_ALL
	movi	OID_SCORED_BY,a0
	calla	KILOBJ_ALL
scort9	jauc	SUCIDE

svsupp5	pushst
	dint
	move	@SUPPLSTS+5*020h,a8,L
	jrz	sbud2
sbud3	move	a0,*a8(OYVEL),L
	move	*a8(OSLINK),a8,L
	jrnz	sbud3
sbud2	popst
	rets

**************************************************************************
*								         *
* start_clip_running_us							 *
*								         *
**************************************************************************

start_clip_running_us

;	MOVK	1,A0
;	sll	5,a0
;	addi	all_clips_us,a0
;	move	*a0,a1,L
;
;	MOVI	video_33_clip,A1	
;	jauc	STRT_ANIM

	MOVI	video_1_clip,A1	
	MOVE	@PUCK_MODE,A14,W
	CMPI	PUM_ENDPER,A14
	JAEQ	STRT_ANIM			;BR=END OF PERIOD

	MOVE	@minutes,A14,W
	SUBK	3,A14
	JAZ	STRT_ANIM			;BR=BEGINNING OF PERIOD
	
	MOVE	@scored_by,A2,W
	JRZ	SCRUS_GENERAL			;BR=WHO?
	GBLOCK	A2,A6

	MOVI	POF_GOALS_P1,A0
	CALLA	TOTAL_STAT
	MOVE	A1,A3

	MOVI	video_14_clip,A1	
	SUBK	3,A3
	JAZ	STRT_ANIM			;BR=HAT TRICK
	MOVI	video_11_clip,A1	
	SUBK	6,A3
	JAZ	STRT_ANIM			;BR=HAT RACK

	MOVE	@FIRE_GOAL,A3,W
	JRZ	SCRUS_CHECK_SPEECH		;BR=NO CHANGE IN FIRE

	CLR	A14
	MOVE	A14,@FIRE_GOAL,W

	MOVI	ON_FIRE_CLIP_TABLE,A1
	MOVE	A3,A3
	JRP	A				;BR=ON FIRE GOAL
	MOVI	OFF_FIRE_CLIP_TABLE,A1		;OFF FIRE GOAL
	JRUC	A

SCRUS_CHECK_SPEECH

	MOVE	@VIDCLIP_PLAYER,A14,W
	CMP	A2,A14
	JRNE	SCRUS_CHECK_DETROIT		;BR=NOT THIS PLAYER

	MOVE	@VIDCLIP_TIME,A0,L
	MOVE	@WAVEIRQS,A14,L
	SUB	A0,A14
	CMPI	120,A14
	JRGT	SCRUS_CHECK_DETROIT		;BR=DIDN'T JUST HAPPEN

	MOVE	@VIDCLIP_TYPE,A3,W

	CLR	A14
	MOVE	A14,@VIDCLIP_TIME,L
	MOVE	A14,@VIDCLIP_PLAYER,W
	MOVE	A14,@VIDCLIP_TYPE,W

	MOVI	512,A0
	CALLA	RANDPER
	JRNC	SCRUS_CHECK_DETROIT		;BR=NOT THIS TIME

	MOVI	video_2_clip,A1	
	CMPI	SLOT_TYPE,A3
	JAEQ	STRT_ANIM			;BR=FROM THE SLOT

	MOVI	video_3_clip,A1	
	CMPI	SLAP_TYPE,A3
	JAEQ	STRT_ANIM			;BR=SLAP SHOT

	MOVI	DEKE_CLIP_TABLE,A1
	CMPI	DEKE_TYPE,A3
	JREQ	A				;BR=DEKE

	MOVI	SPIN_CLIP_TABLE,A1
	CMPI	SPIN_TYPE,A3
	JREQ	A				;BR=SPIN

SCRUS_CHECK_DETROIT

;IF DETROIT HOME GOAL
	
	SRL	2,A2
	SLL	4,A2				;TEAM OFFSET

	MOVI	team1,A0
	ADD	A2,A0
	MOVE	*A0,A0,W
	SUBK	team_red_wings,A0
	JRNZ	SCRUS_GENERAL			;BR=NOT DETROIT

	MOVI	team1_home,A0
	ADD	A2,A0
	MOVE	*A0,A0,W
	DEC	A0
	JRNZ	SCRUS_GENERAL			;BR=NOT HOME

	MOVI	512,A0
	CALLA	RANDPER
	JRNC	SCRUS_GENERAL			;BR=NO OCTOPUSES

	MOVI	video_33_clip,A1
	JAUC	STRT_ANIM

SCRUS_GENERAL

	MOVI	GENERAL_CLIP_TABLE,A1
	JRUC	A


**************************************************************************
*								         *
* A									 *
*								         *
**************************************************************************
	
A
	MOVE	*A1+,A0,W
	CALLA	RAND0
	SLL	5,A0
	ADD	A0,A1
	MOVE	*A1,A1,L
	JAUC	STRT_ANIM

GENERAL_CLIPS	EQU	14

GENERAL_CLIP_TABLE
	.WORD	GENERAL_CLIPS
	.long	video_5_clip
	.long	video_10_clip
	.long	video_12_clip
	.long	video_13_clip
	.long	video_19_clip
	.long	video_20_clip
	.long	video_22_clip
	.long	video_23_clip
	.long	video_24_clip
	.long	video_26_clip
	.long	video_29_clip
	.long	video_30_clip
	.long	video_31_clip
	.long	video_32_clip

DEKE_CLIPS	EQU	2

DEKE_CLIP_TABLE
	.WORD	DEKE_CLIPS
	.long	video_4_clip
	.long	video_8_clip

ON_FIRE_CLIPS	EQU	3

ON_FIRE_CLIP_TABLE
	.WORD	ON_FIRE_CLIPS
	.long	video_16_clip
	.long	video_17_clip
	.long	video_21_clip

OFF_FIRE_CLIPS	EQU	2

OFF_FIRE_CLIP_TABLE
	.WORD	OFF_FIRE_CLIPS
	.long	video_18_clip
	.long	video_27_clip

SPIN_CLIPS	EQU	2

SPIN_CLIP_TABLE
	.WORD	SPIN_CLIPS
	.long	video_15_clip
	.long	video_25_clip

	.if	0

all_clips_us
	.long	video_1_clip
	.long	video_2_clip
	.long	video_3_clip
	.long	video_4_clip
	.long	video_5_clip
	.long	video_8_clip
	.long	video_10_clip
	.long	video_11_clip
	.long	video_12_clip
	.long	video_13_clip
	.long	video_14_clip
	.long	video_15_clip
	.long	video_16_clip
	.long	video_17_clip
	.long	video_18_clip
	.long	video_19_clip
	.long	video_20_clip
	.long	video_21_clip
	.long	video_22_clip
	.long	video_23_clip
	.long	video_24_clip
	.long	video_25_clip
	.long	video_26_clip
	.long	video_27_clip
	.long	video_29_clip
	.long	video_30_clip
	.long	video_31_clip
	.long	video_32_clip
	.long	video_33_clip

	.endif

**************************************************************************
*								         *
* create_scored_by							 *
* 	input	a6 = player block					 *
*								         *
**************************************************************************
create_scored_by
	movb	*a6(POF_NUMBER),a0
	sll	4,a0
	addi	sbdx,a0
	move	*a0,a2,W
	movi	355,a3
	movi	-07000h,a4
	movi	score_box_list1,a11
	callr	make_score_stuff1
;	callr	start_clip_running

	MOVI	CYCLEGLP3,A8
	MOVK	1,A9
	MOVK	15,A10
	MOVK	2,A11
	CREATE	PID_BOXCOLOR,CYCLE16

	mmtm	sp,a4
	movi	score_by_init,b0
	calla	EASYMAKE
	move	a2,a14
	addi	47,a14
	move	a14,*a8(OXPOS),W
	move	a14,a0
	move	a3,a14
	addi	79,a14
	move	a14,*a8(OYPOS),W
	sll	16,a14
	movy	a14,a0
	move	a4,a14
;	addk	2,a14
	move	a14,*a8(OZPOS),W
	calla	set_scrnobj_to_pos
	move	*a6(POF_CHARACTER),a14,W
	sll	5,a14
	addi	player_data,a14
	move	*a14,a14,L
	move	*a14(TP_PLYRMUG_IMG),a10,L
	srl	4,a10
	sll	4,a10
	move	*a14(TP_PLYRNAME_IMG),a9,L
	move	*a10(070h),a0,L
	calla	CHANGE_PAL
	move	a10,a1
	move	*a8(OCTRL),a4,W
	calla	ANI
	calla	INSERT_OBJ

	movi	score_by_init,b0
	calla	EASYMAKE
	move	a2,a14
	addi	51,a14
	move	a14,*a8(OXPOS),W
	move	a14,a0
	move	a3,a14
	addk	8,a14
	move	a14,*a8(OYPOS),W
	sll	16,a14
	movy	a14,a0

	mmfm	sp,a4
	mmtm	sp,a4

	move	a4,a14
	subk	2,a14

	move	a14,*a8(OZPOS),W
	calla	set_scrnobj_to_pos
	move	*a9(070h),a0,L
	calla	CHANGE_PAL
	move	a9,a1
	move	*a8(OCTRL),a4,W
	calla	ANI
	calla	INSERT_OBJ
	mmfm	sp,a4

	movb	*a6(POF_GOALS_P1),a0
	movb	*a6(POF_GOALS_P2),a14
	add	a14,a0
	movb	*a6(POF_GOALS_P3),a14
	add	a14,a0
	movb	*a6(POF_GOALS_PO),a14
	add	a14,a0
	cmpi	10,a0
	jrlt	csb_1d
csb_2d	move	a0,a1
	clr	a0
	movk	10,a14
	divu	a14,a0
	move	a1,a5
	movi	score_box_2digits,a11
	callr	do_digt
	move	a5,a0
	jruc	csbpnum
csb_1d	movi	score_box_1digit,a11
csbpnum	callr	do_digt
	movb	*a6(POF_NUMBER),a11
	sll	7,a11
	addi	score_box_playernum,a11
	move	*a11+,a10,L
	jruc	mss_11

sbdx	.word	-120
	.word	0+5,100,-120,-120
	.word	200,300-5,-120,-120

**************************************************************************
*								         *
* make_score_stuff1							 *
* 	input	a11 = pointer to list to create				 *
* 		a2  = x offset to add to list positions			 *
* 		a3  = y offset to add to list positions			 *
* 		a4  = z offset to add to list positions			 *
*								         *
**************************************************************************
make_score_stuff1
mss_0	move	*a11+,a10,L
	jrz	mss_7
	mmtm	sp,a2,a3,a4
	callr	mss_11
	mmfm	sp,a2,a3,a4
	jruc	mss_0
mss_7	rets

do_digt	sll	5,a0
	addi	score_box_digitl,a0
	move	*a0,a10,L
mss_11	movi	score_by_init,b0
	calla	EASYMAKE
	move	*a11+,a0,L
	calla	CHANGE_PAL
	move	*a11+,a14,W
	add	a2,a14
	move	a14,*a8(OXPOS),W
	move	a14,a0
	move	*a11+,a14,W
	add	a3,a14
	move	a14,*a8(OYPOS),W
	sll	16,a14
	movy	a14,a0
	move	*a11+,a14,W
	add	a4,a14
	move	a14,*a8(OZPOS),W
	calla	set_scrnobj_to_pos
	mmtm	sp,a4
	move	*a8(OCTRL),a4
	move	a10,a1
	calla	ANI
	mmfm	sp,a4
	calla	set_scrnobj_to_pos
	jauc	INSERT_OBJ

score_by_init
	.long	PLYRBOX
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE
	.word	OM_OID
	.word	OID_SCORED_BY

score_box_list1
	LLWWW	PLYRBOX,PLYRBXP,0,0,-1
	LLWWW	PCKTRI01,TRI,70,17,-2
	LLWWW	PPLAYER,PLAYERP,4,23-5,-2
	LLWWW	PLYRBCK,PLYRBCK2P,16,16,0
	LLWWW	GOALS,POSITP,18,81,-2
	LLWWW	CYCLEGL3,CYCLEGLP3,63,78,-1
;	LLWWW	LEAFSM4,LEAFSM4P,-1,78,-2
;	LLWWW	VIDEO101,VIDEOSP,15,15,0	;keep the animated one last in list

	.long	0

score_box_playernum
	LLWWW	G01,POSITP,4,4,-3
	.word	 0
	LLWWW	G01,POSITP,4,4,-3
	.word	 0
	LLWWW	G02,POSITP,4,4,-3
	.word	 0
	LLWWW	G02,POSITP,4,4,-3
	.word	 0
	LLWWW	G02,POSITP,4,4,-3
	.word	 0
	LLWWW	G03,POSITP,4,4,-3
	.word	 0
	LLWWW	G04,POSITP,4,4,-3
	.word	 0
	LLWWW	G04,POSITP,4,4,-3
	.word	 0
	LLWWW	G04,POSITP,4,4,-3

score_box_digitl
	.long	G00
	.long	G01
	.long	G02
	.long	G03
	.long	G04
	.long	G05
	.long	G06
	.long	G07
	.long	G08
	.long	G09

score_box_1digit
	LWWW	GNUMS,70,81,-2

score_box_2digits
	LWWW	GNUMS,66,81,-2
	LWWW	GNUMS,76,81,-2

clean_up_net_anims
	clr	a14
	move	a14,@hold_net_anim,W
	move	a14,@side_brightness,W
	move	@lgoalF_object,a8,L
	callr	cuns
	move	@rgoalF_object,a8,L
cuns	movi	GOALP,a0
	calla	CHANGE_PAL
	move	*a8(OFLAGS),a14,W
	btst	B_ANIM,a14
	jrz	cuns8
	jauc	PULL_ANIM
cuns8	rets

can_puck_score_process
	CLR	A14
	MOVE	A14,@EXPLO_FLAG,W		;DEFAULT TO NO EXPLOSION

	calla	score_board_animate		;here is safe, we can trash anything
	calla	wall_goal
	calla	kill_all_trails
	clr	a0
	move	@PUCK_OBJECT,a9,L
	move	a0,@PUCK_CONTROL,W

	movk	1,a0
	move	a0,@hold_net_anim,W
	move	@lgoalF_object,a8,L
	move	@WORLDX+010h,a14,W
	jrn	cpsp1
	move	@rgoalF_object,a8,L
cpsp1	move	@hot_player,a1,W

;	JRUC	cps_on_fire

	jrz	cpspnf
	move	@scored_by,a14,W
	cmp	a1,a14
	jrz	cps_on_fire
cpspnf	movi	nb_ls_script,a1
	move	*a9(OYPOS),a14,W
	cmpi	-1,a14
	jrge	cps_onice

	move	*a9(OYPOS),a14,W
	movi	net_low_c_table,a2
	cmpi	-7,a14
	jrge	mendo
	movi	net_mid_c_table,a2
	cmpi	-35,a14
	jrge	mendo
	move	*a9(OYVEL+010H),a14,W
	cmpi	-3,a14
	jrgt	mendo
	movi	net_high_c_table,a2
mendo	move	*a9(ODT_VEL),a3,L
	cmpi	[10,0],a3
	jrlt	mndo1
	addk	32,a2
	cmpi	[18,0],a3
	jrlt	mndo1
	addk	32,a2
mndo1	move	*a9(OZVEL),a14,L
	move	a14,a0
	abs	a0
	cmpi	[6,0],a0
	jrlt	mndo11
	addi	32*3,a2
	move	a14,a14
	jrp	mndo11
	addi	32*3,a2
mndo11	clr	a0
	move	a0,*a9(OXVEL),L
	move	a0,*a9(OYVEL),L
	move	a0,*a9(OZVEL),L
	move	a0,*a9(ODT_VEL),L
	move	a0,*a9(ODT_DIR),L
	move	@PUCK_SHADOW,a9,L
	move	a0,*a9(OXVEL),L
	move	a0,*a9(OYVEL),L
	move	a0,*a9(OZVEL),L
	move	a0,*a9(ODT_VEL),L
	move	a0,*a9(ODT_DIR),L
	move	*a2,a1,L
mndo2	calla	STRT_ANIM
	SLEEP	60
	callr	clean_up_net_anims
	jauc	SUCIDE

cps_onice
	movi	nb_ls_script,a1
	jruc	mndo2

cps_on_fire
	MOVI	S_NET_IGNITE,A4
	CALLA	do_sound

	movi	nb_flame_script,a1
	calla	STRT_ANIM

	movi	AUD_ON_FIRE_GOALS,a0
	calla	AUD1

	move	@hot_goals,a14,W
	cmpi	3,a14
	jrnz	CPS_OF_FIRE
;	JRUC	CPS_OF_FIRE

	MOVK	1,A14
	MOVE	A14,@EXPLO_FLAG,W

	CREATE	PID_IND,NET_EXPLO_PROC

	move	@lgoalR_object,a0,L
	CALLA	OBJOFF
	move	@rgoalR_object,a0,L
	CALLA	OBJOFF

CPS_OF_EXPLO_WAIT
	SLEEP	1
	MOVE	@EXPLO_FLAG,A14,W
	JRNZ	CPS_OF_EXPLO_WAIT		;BR=STILL EXPLODIN'

	SLEEP	240

	MOVE	*A8(OZVAL),A14,L
	SUBI	ZWRAP,A14
	MOVE	A14,*A8(OZVAL),L

	move	@lgoalR_object,a8,L
	CALLA	OBJ_ON
	move	@rgoalR_object,a8,L
	CALLA	OBJ_ON

	callr	clean_up_net_anims
	jauc	SUCIDE

CPS_OF_FIRE
	SLEEP	240

	callr	clean_up_net_anims
	jauc	SUCIDE

**************************************************************************
*								         *
* NET_EXPLO_PROC							 *
*								         *
* PASS:								         *
* A8 = NET OBJECT							 *
*								         *
**************************************************************************

NET_EXPLO_PROC
;	CREATE	PID_COLLISION,FRAG_COLLISION_PROC

	MOVK	15,A9
NEP_LUPE
	CALLR	MAKE_SMALL_EXPLO		;small explode here
	calla	small_fire_inc

	MOVK	3,A0
	CALLA	RAND0
	MOVE	A0,A0
	JRZ	NEP_2ND_SMALL

	SLEEPR	A0

NEP_2ND_SMALL
	CALLR	MAKE_SMALL_EXPLO		;small explode here
	calla	small_fire_inc

	MOVK	5,A0
	MOVK	1,A1
	CALLA	RANGERND
	SLEEPR	A0

	DSJ	A9,NEP_LUPE

	SLEEP	15

	CALLR	MAKE_BIG_EXPLO			;big explode here
	calla	big_fire_inc

NEP_COVER_WAIT
	SLEEP	1
	MOVE	@EXPLO_COVER_FLAG,A14,W
	JRZ	NEP_COVER_WAIT

	MOVE	*A8(OZVAL),A14,L
	ADDI	ZWRAP,A14
	MOVE	A14,*A8(OZVAL),L

	MOVI	LEFTOVER_FRAME_ANIM,A1
	CALLA	STRT_ANIM

	MOVK	5,A9
NEP_BIG_FIREBALLS_LUPE
	calla	small_fire_inc
	CALLR	MAKE_BIG_FIREBALL		;throw debris
	CALLR	MAKE_BIG_FIREBALL
	CALLR	MAKE_BIG_FIREBALL
	CALLR	MAKE_BIG_FIREBALL
	CALLR	MAKE_BIG_FIREBALL

	CALLR	THROW_PIPES

	SLEEP	1

	DSJ	A9,NEP_BIG_FIREBALLS_LUPE

;	SLEEP	60

	MOVI	OID_PIPE,A0
	CALLA	KILOBJ_ALL

;	MOVI	PID_COLLISION,A0
;	CALLA	KILALL

	CLR	A14
	MOVE	A14,@EXPLO_FLAG,W

	DIE

**************************************************************************
*								         *
* THROW_PIPES								 *
*								         *
**************************************************************************

THROW_PIPES
	MOVI	512,A0
	CALLA	RANDPER
	JRNC	TP_SHORT

	MOVK	2,A0
	MOVI	LONG_PIPE_TABLE,A1

	CALLR	MAKE_PIPE
	RETS
TP_SHORT
	MOVK	4,A0
	MOVI	SHORT_PIPE_TABLE,A1
	CALLR	MAKE_PIPE

	MOVK	4,A0
	MOVI	SHORT_PIPE_TABLE,A1
	CALLR	MAKE_PIPE
	RETS

**************************************************************************
*								         *
* MAKE_BIG_EXPLO							 *
* 									 *
* PASS:									 *
* A8 = NET OBJECT							 *
*								         *
**************************************************************************

MAKE_BIG_EXPLO
	PUSH	A8
	MOVE	A8,A14
	ADDI	OXVAL,A14
	MMFM	A14,A2,A3,A4

	SUBK	2,A2
	SUBI	0180000H,A3			;Y "

	MOVI	0100000H,A14
	MOVE	*A8(OCTRL),A0,W
	BTST	B_FLIPH,A0
	JRZ	MBE_X
	NEG	A14				;RIGHT GOAL
MBE_X
	SUB	A14,A4				;X POSITION

	MOVK	1,A14
	MOVE	A14,@EXPLO_COVER_FLAG,W

	MOVI	EXPLO_INIT,B0
	CALLA	EASYMAKE
	JRZ	MBE_ABORT

	CLR	A14
	MOVE	A14,@EXPLO_COVER_FLAG,W

;	MOVE	*A8(OFLAGS),A14,W
;	ORI	M_NOSCALE,A14
;	MOVE	A14,*A8(OFLAGS),W

	MOVE	A8,A14
	ADDI	OZVAL+020H,A14
	MMTM	A14,A2,A3,A4

	MOVI	0800080H,A14
	MOVE	A14,*A8(ODT_SC_OVERRIDE),L

	CALLA	INSERT_OBJ

;	MOVI	S_EXPLO_4,A4
	MOVI	S_NET_EXPLO,A4
	CALLA	do_sound

MBE_ABORT
	PULLQ	A8
	RETS

**************************************************************************
*								         *
* MAKE_SMALL_EXPLO							 *
* 									 *
* PASS:									 *
* A8 = NET OBJECT							 *
*								         *
**************************************************************************

MAKE_SMALL_EXPLO
	PUSH	A8
	MOVE	A8,A14
	ADDI	OXVAL,A14
	MMFM	A14,A2,A3,A4

	DEC	A2				;Z POSITION

	MOVI	0400000H,A0
	CLR	A1
	CALLA	RANGERND
	SUB	A0,A3				;Y POSITION

	MOVI	0200000H,A0
	MOVI	020000H,A1
	CALLA	RANGERND

	MOVK	1,A5
	CMPI	(0200000H-020000H)/2+020000H,A0
	JRLT	MSE_CHECK_FLIPH
	CLR	A5

MSE_CHECK_FLIPH
	MOVE	*A8(OCTRL),A1,W
	BTST	B_FLIPH,A1
	JRZ	MSE_X
	NEG	A0				;RIGHT GOAL
	XORI	1,A5
MSE_X
	SUB	A0,A4				;X POSITION

	MOVI	EXPLO_INIT,B0
	CALLA	EASYMAKE
	JRZ	MSE_ABORT

	MOVE	*A8(OFLAGS),A14,W
	ORI	M_NOSCALE,A14
	MOVE	A14,*A8(OFLAGS),W

	MOVE	A8,A14
	ADDI	OZVAL+020H,A14
	MMTM	A14,A2,A3,A4

	MOVI	010000H,A0
	CLR	A1
	CALLA	RANGERND

	MOVE	A5,A5
	JRNZ	MSE_SET_XVEL
	NEG	A0
MSE_SET_XVEL
	MOVE	A0,*A8(OXVEL),L

	MOVI	512,A0
	CALLA	RANDPER
	JRC	MSE_INSERT

	MOVI	FBOOM2,A0
	CALLA	CHANGE_PAL

MSE_INSERT
	CALLA	INSERT_OBJ

	CALLR	MAKE_FIREBALL
	
;	MOVI	S_NET_EXPLO,A4
;	MOVI	127,A1
;	CALLA	do_sound_at_volume

MSE_ABORT
	PULLQ	A8
	RETS

FBOOM2:
   .word   32 
   .word   00000h,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fdeh
   .word   07bbdh,0739ch,06f7bh,06b5ah,06739h,062f7h,05eb6h,05a95h
   .word   05674h,05253h,04e32h,041d0h,0631bh,07fffh,07ffch,07ff9h
   .word   07ff7h,07ff2h,07fefh,07fe0h,07f40h,07ec0h,07e60h,07e60h

**************************************************************************
*								         *
* MAKE_FIREBALL								 *
* 									 *
* PASS:									 *
* A8 = NET OBJECT							 *
*								         *
**************************************************************************

MAKE_FIREBALL
	PUSH	A8

	MOVI	FIREBALL_INIT,B0
	CALLA	EASYMAKE
	JRZ	MFB_ABORT

	MOVE	*A8(OFLAGS),A14,W
	ORI	M_NOSCALE,A14
	MOVE	A14,*A8(OFLAGS),W

	MOVE	A8,A14
	ADDI	OZVAL+020H,A14
	MMTM	A14,A2,A3,A4

	MOVI	-020000H,A0
	MOVI	-040000H,A1
	CALLA	RANGERND
	MOVE	A0,*A8(OYVEL),L

	MOVI	010000H,A0
	MOVI	040000H,A1
	CALLA	RANGERND

	MOVE	A5,A5
	JRNZ	MFB_SET_XVEL
	NEG	A0
MFB_SET_XVEL
	MOVE	A0,*A8(OXVEL),L

	MOVI	NORM_GRAVITY,A0
	MOVE	A0,*A8(OYACCEL),W

	CALLA	INSERT_OBJ

MFB_ABORT
	PULLQ	A8
	RETS

**************************************************************************
*								         *
* MAKE_BIG_FIREBALL								 *
* 									 *
* PASS:									 *
* A8 = NET OBJECT							 *
*								         *
**************************************************************************

MAKE_BIG_FIREBALL
	PUSH	A8

	MOVE	A8,A14
	ADDI	OXVAL,A14
	MMFM	A14,A2,A3,A4

	DEC	A2				;Z POSITION

	MOVI	0380000H,A0
	MOVI	0280000H,A1
	CALLA	RANGERND
	SUB	A0,A3				;Y POSITION

	MOVI	0200000H,A0
	MOVI	020000H,A1
	CALLA	RANGERND

	MOVK	1,A5
	CMPI	(0200000H-020000H)/2+020000H,A0
	JRLT	MBFB_CHECK_FLIPH
	CLR	A5

MBFB_CHECK_FLIPH
	MOVE	*A8(OCTRL),A1,W
	BTST	B_FLIPH,A1
	JRZ	MBFB_X
	NEG	A0				;RIGHT GOAL
	XORI	1,A5
MBFB_X
	SUB	A0,A4				;X POSITION

	MOVI	FIREBALL_INIT,B0
	CALLA	EASYMAKE
	JRZ	MBFB_ABORT

	MOVE	A8,A14
	ADDI	OZVAL+020H,A14
	MMTM	A14,A2,A3,A4

	MOVI	-040000H,A0
	MOVI	-080000H,A1
	CALLA	RANGERND
	MOVE	A0,*A8(OYVEL),L

	MOVI	040000H,A0
	MOVI	08000H,A1
	CALLA	RANGERND

	MOVE	A5,A5
	JRNZ	MBFB_SET_XVEL
	NEG	A0
MBFB_SET_XVEL
	MOVE	A0,*A8(OXVEL),L

	MOVI	NORM_GRAVITY,A0
	MOVE	A0,*A8(OYACCEL),W

	MOVI	0800080H,A14
	MOVE	A14,*A8(ODT_SC_OVERRIDE),L

	CALLA	INSERT_OBJ

MBFB_ABORT
	PULLQ	A8
	RETS

**************************************************************************
*								         *
* MAKE_PIPE								 *
* 									 *
* PASS:									 *
* A0 = NUMBER OF PIPES							 *
* A1 = PIPE TABLE							 *
* A8 = NET OBJECT							 *
*								         *
**************************************************************************

MAKE_PIPE
	PUSH	A8

	CALLA	RAND0
	SLL	5,A0
	ADD	A1,A0
	MOVE	*A0,A6,L

	MOVE	A8,A14
	ADDI	OXVAL,A14
	MMFM	A14,A2,A3,A4

	DEC	A2				;Z POSITION

	MOVI	0380000H,A0
	MOVI	0280000H,A1
	CALLA	RANGERND
	SUB	A0,A3				;Y POSITION

	MOVI	0200000H,A0
	MOVI	020000H,A1
	CALLA	RANGERND

	MOVK	1,A5
	CMPI	(0200000H-020000H)/2+020000H,A0
	JRLT	MP_CHECK_FLIPH
	CLR	A5

MP_CHECK_FLIPH
	MOVE	*A8(OCTRL),A1,W
	BTST	B_FLIPH,A1
	JRZ	MP_X
	NEG	A0				;RIGHT GOAL
	XORI	1,A5
MP_X
	SUB	A0,A4				;X POSITION

	MOVI	PIPE_INIT,B0
	CALLA	EASYMAKE
	JRZ	MP_ABORT

	MOVE	A8,A14
	ADDI	OZVAL+020H,A14
	MMTM	A14,A2,A3,A4

	MOVI	-038000H,A0
	MOVI	-048000H,A1
	CALLA	RANGERND
	MOVE	A0,*A8(OYVEL),L

	MOVI	040000H,A0
	MOVI	08000H,A1
	CALLA	RANGERND

	MOVE	A5,A5
	JRNZ	MP_SET_XVEL
	NEG	A0
MP_SET_XVEL
	MOVE	A0,*A8(OXVEL),L

;	MOVI	NORM_GRAVITY,A0
;	MOVE	A0,*A8(OYACCEL),W

	MOVE	A6,A1
	CALLA	STRT_ANIM

	CALLA	INSERT_OBJ

MP_ABORT
	PULLQ	A8
	RETS





;**************************************************************************
;*								         *
;* MAKE_FIREBALL								 *
;* 									 *
;* PASS:									 *
;* A8 = NET OBJECT							 *
;*								         *
;**************************************************************************
;
;MAKE_FIREBALL
;	PUSH	A8
;	MOVE	A8,A14
;	ADDI	OXVAL,A14
;	MMFM	A14,A2,A3,A4
;
;	DEC	A2				;Z POSITION
;
;	SUBI	0140000H,A3			;Y "
;	MOVI	0100000H,A0
;
;;	MOVI	0400000H,A0
;;	CLR	A1
;;	CALLA	RANGERND
;;	SUB	A0,A3				;Y POSITION
;;
;;	MOVI	0200000H,A0
;;	MOVI	020000H,A1
;;	CALLA	RANGERND
;
;	MOVE	*A8(OCTRL),A1,W
;	BTST	B_FLIPH,A1
;	JRZ	MFB_X
;	NEG	A0				;RIGHT GOAL
;MFB_X
;	SUB	A0,A4				;X POSITION
;
;	MOVI	FIREBALL_INIT,B0
;	CALLA	EASYMAKE
;	JRZ	MFB_ABORT
;
;	MOVE	A8,A14
;	ADDI	OZVAL+020H,A14
;	MMTM	A14,A2,A3,A4
;
;	MOVI	-020000H,A0
;	MOVI	-020000H,A1
;	MOVE	A0,A1
;	CALLA	RANGERND
;;	MOVE	A0,*A8(OYVEL),L
;
;	MOVI	010000H,A0
;	MOVI	020000H,A1
;	MOVE	A0,A1
;	CALLA	RANGERND
;;	MOVE	A0,*A8(OXVEL),L
;
;	MOVI	04000H,A0
;;	MOVE	A0,*A8(OYACCEL),W
;
;	CALLA	INSERT_OBJ
;
;MFB_ABORT
;	PULLQ	A8
;	RETS
;
;
;**************************************************************************
;*								         *
;* FRAG_COLLISION_PROC							 *
;*								         *
;**************************************************************************
;
;FRAG_COLLISION_PROC
;	MOVI	SUPPLSTS-OSLINK+8*020H,A8
;
;FCP_LUPE
;	MOVE	*A8(OSLINK),A8,L
;	JRZ	FCP_NAP
;
;	MOVE	*A8(OYVEL),A0,L
;	JRN	FCP_LUPE
;	JRZ	FCP_LUPE
;
;	MOVE	*A8(OYVAL),A14,L
;	JRN	FCP_LUPE
;
;	SRA	1,A0
;	NEG	A0
;	MOVE	A0,*A8(OYVEL),L
;
;	JRUC	FCP_LUPE
;
;FCP_NAP
;	SLEEP	1
;	JRUC	FRAG_COLLISION_PROC



EXPLO_INIT
	.long	FHKEXPLOC1
	.word	DMAWNZ,0
	.word	OM_OID|OM_ANIM
	.word	OID_JUNK
	.LONG	EXPLO_ANIM

EXPLO_ANIM
;	LW	FHKEXPLOC2,120
;	LW	1,120
;	LWL	1,1|AFUNC,DELETE_OBJ

	LW	1,3
	LWL	FHKEXPLOC2,3|AFUNC,A_COVER_FLAG
	LW	FHKEXPLOC3,3
	LW	FHKEXPLOC4,3
	LW	FHKEXPLOC5,3
	LW	FHKEXPLOC6,3
	LW	FHKEXPLOC7,3
	LW	FHKEXPLOC8,3
	LW	FHKEXPLOC9,3
	LW	FHKEXPLOC10,3
	LW	FHKEXPLOC11,3
	LWL	1,1|AFUNC,DELETE_OBJ

A_COVER_FLAG
	MOVK	1,A14
	MOVE	A14,@EXPLO_COVER_FLAG,W
	RETS

LONG_PIPE_TABLE
	.LONG	PIPE2_ANIM,PIPE2R_ANIM	

SHORT_PIPE_TABLE
	.LONG	PIPE3_ANIM,PIPE3R_ANIM	
	.LONG	PIPE6_ANIM,PIPE6R_ANIM	

PIPE_INIT
	.long	PIPE201
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID
	.word	OID_PIPE

PIPE2_ANIM
	LW	PIPE201,3
	LW	PIPE202,3
	LW	PIPE203,3
	LW	PIPE204,3
	LW	PIPE205,3
	LW	PIPE206,3
	LW	PIPE207,3
	LW	PIPE208,3
	LW	PIPE209,3
	LW	PIPE210,3
	.long	0

PIPE2R_ANIM
	LW	PIPE210,3
	LW	PIPE209,3
	LW	PIPE208,3
	LW	PIPE207,3
	LW	PIPE206,3
	LW	PIPE205,3
	LW	PIPE204,3
	LW	PIPE203,3
	LW	PIPE202,3
	LW	PIPE201,3
	.long	0

PIPE3_ANIM
	LW	PIPE301,3
	LW	PIPE302,3
	LW	PIPE303,3
	LW	PIPE304,3
	LW	PIPE305,3
	LW	PIPE306,3
	LW	PIPE307,3
	LW	PIPE308,3
	LW	PIPE309,3
	LW	PIPE310,3
	.long	0

PIPE3R_ANIM
	LW	PIPE310,3
	LW	PIPE309,3
	LW	PIPE308,3
	LW	PIPE307,3
	LW	PIPE306,3
	LW	PIPE305,3
	LW	PIPE304,3
	LW	PIPE303,3
	LW	PIPE302,3
	LW	PIPE301,3
	.long	0

PIPE6_ANIM
	LW	PIPE601,3
	LW	PIPE602,3
	LW	PIPE603,3
	LW	PIPE604,3
	LW	PIPE605,3
	LW	PIPE606,3
	LW	PIPE607,3
	LW	PIPE608,3
	LW	PIPE609,3
	LW	PIPE610,3
	.long	0

PIPE6R_ANIM
	LW	PIPE610,3
	LW	PIPE609,3
	LW	PIPE608,3
	LW	PIPE607,3
	LW	PIPE606,3
	LW	PIPE605,3
	LW	PIPE604,3
	LW	PIPE603,3
	LW	PIPE602,3
	LW	PIPE601,3
	.long	0

LEFTOVER_FRAME_ANIM
	LWL	FRAME01,4|AFUNC,a_kigp2
	LWL	FRAME02,4|AFUNC,a_kig
	LWL	FRAME03,4|AFUNC,a_kig
	LWL	FRAME04,4|AFUNC,a_kig
	LWL	FRAME05,4|AFUNC,a_kig
	.long	0

net_low_c_table
	.long	nb_lcs_script		;low y slow center
	.long	nb_lcm_script		;low y medium center
	.long	nb_lcf_script		;low y fast center
	.long	nb_mts_script		;mid y slow high z
	.long	nb_mtm_script		;mid y medium high z
	.long	nb_mtf_script		;mid y fast high z
	.long	nb_mbs_script		;mid y slow low z
	.long	nb_mbm_script		;mid y medium low z
	.long	nb_mbf_script		;mid y fast low z
net_mid_c_table
	.long	nb_mcs_script		;mid y slow center
	.long	nb_mcm_script		;mid y medium center
	.long	nb_mcf_script		;mid y fast center
	.long	nb_mts_script		;mid y slow high z
	.long	nb_mtm_script		;mid y medium high z
	.long	nb_mtf_script		;mid y fast high z
	.long	nb_mbs_script		;mid y slow low z
	.long	nb_mbm_script		;mid y medium low z
	.long	nb_mbf_script		;mid y fast low z
net_high_c_table
	.long	nb_hcs_script		;mid y slow center
	.long	nb_hcm_script		;mid y medium center
	.long	nb_hcf_script		;mid y fast center
	.long	nb_mts_script		;mid y slow high z
	.long	nb_mtm_script		;mid y medium high z
	.long	nb_mtf_script		;mid y fast high z
	.long	nb_mbs_script		;mid y slow low z
	.long	nb_mbm_script		;mid y medium low z
	.long	nb_mbf_script		;mid y fast low z

nb_flame_script
	LWL	GFLM101,AFUNC|2,a_kigp
	LWL	GFLM102,AFUNC|2,a_kigf
	LWL	GFLM103,AFUNC|2,a_kig
	LWL	GFLM104,AFUNC|2,a_kig
	LWL	GFLM105,AFUNC|2,a_kig
	LWL	GFLM106,AFUNC|2,a_kigfb
	LWL	GFLM107,AFUNC|2,a_kig
	LWL	GFLM108,AFUNC|2,a_kig
	LWL	GFLM109,AFUNC|2,a_kigf
nbfl1	LWL	GFLM201,AFUNC|1,A_CHANGE_PAL+2
	.long	 GFLM2P
	LWL	GFLM201,AFUNC|1,a_kigfb
	LWL	GFLM202,AFUNC|2,a_kig
	LWL	GFLM203,AFUNC|2,a_kig
	LWL	GFLM204,AFUNC|2,a_kigf
	LWL	GFLM205,AFUNC|2,a_kig
	LWL	GFLM206,AFUNC|2,a_kig
	LWL	GFLM207,AFUNC|2,a_kig
	LWL	GFLM208,AFUNC|2,a_kigfb
	LWL	GFLM209,AFUNC|2,a_kig
	LWL	GFLM210,AFUNC|2,a_kig
	LWL	GFLM211,AFUNC|2,a_kigf
	LWL	GFLM212,AFUNC|2,a_kigf
	LWL	GFLM213,AFUNC|2,a_kig
	LWL	GFLM214,AFUNC|2,a_kig
	LWL	GFLM215,AFUNC|2,a_kigfb
	LWL	GFLM216,AFUNC|2,a_kig
	LWL	GFLM217,AFUNC|2,a_kig
	LWL	GFLM218,AFUNC|2,a_kig
	LWL	GFLM219,AFUNC|2,a_kigfb
	LWL	GFLM220,AFUNC|2,a_kig
	LWL	GFLM221,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_branch+2
	.long	 nbfl1
	.long	0

nb_ls_script
	LWL	ghit101,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

a_kigp2
	move	@PUCK_MODE,a0,W
	cmpi	PUM_FACEOFF,a0
	jrz	akig5
	MOVI	FRAME3,A0
	calla	CHANGE_PAL
	jruc	akjg

a_kigfb	callr	a_kig
	jauc	big_fire_inc
a_kigf	callr	a_kig
	jauc	small_fire_inc

a_kigp	move	@PUCK_MODE,a0,W
	cmpi	PUM_FACEOFF,a0
	jrz	akig5
	movi	GFLM1P,a0
	calla	CHANGE_PAL
	jruc	akjg
a_kig	move	@PUCK_MODE,a0,W
	cmpi	PUM_FACEOFF,a0
	jrz	akig5
akjg	move	@PUCK_OBJECT,a9,L
	move	@PUCK_SHADOW,a10,L
	move	*a9(OCTRL),a14,W
	ori	M_WRNONZ,a14
	move	a14,*a9(OCTRL),W
	move	*a10(OCTRL),a14,W
	ori	M_WRNONZ,a14
	move	a14,*a10(OCTRL),W
	move	*a9(OXVAL),a0,L
	move	a0,a4
	jrp	akig1
	abs	a0
akig1	cmpi	[729,0],a0
	jrls	akig2
	movi	[728,0],a0
	move	*a9(ODT_VEL),a1,L
	sra	3,a1
	move	a1,*a9(ODT_VEL),L
	move	a1,*a10(ODT_VEL),L
	move	a4,a4
	jrp	ao1i
	neg	a0
ao1i	move	a0,*a9(OXVAL),L
	move	a0,*a10(OXVAL),L
akig2	move	*a9(OZVAL),a0,L
	cmpi	[383,0],a0
	jrlt	akig3
	movi	[382,0],a0
	jruc	akig4
akig3	cmpi	[296,0],a0
	jrgt	akig5
	movi	[297,0],a0
akig4	move	a0,*a9(OZVAL),L
	move	a0,*a10(OZVAL),L
akig5	rets

nb_lcs_script
	LWL	ghit403,AFUNC|1,ppckc+3
	.word	 02dfh,0156h,-03h
	LWL	ghit404,AFUNC|1,ppckc+3
	.word	 02e1h,0156h,-02h
	LWL	ghit405,AFUNC|5,ppckc+3
	.word	 02e4h,0156h,-01h
	LWL	ghit404,AFUNC|4,ppckc+3
	.word	 02e1h,0156h,-02h
	LWL	ghit403,AFUNC|5,ppckc+3
	.word	 02dfh,0156h,-03h
	LWL	ghit402,AFUNC|5,ppckcv+3
	.word	 02dbh,0156h,-02h
	LWL	ghit401,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_lcm_script
	LWL	ghit405,AFUNC|5,ppckc+3
	.word	 02e4h,0156h,-01h
	LWL	ghit404,AFUNC|4,ppckc+3
	.word	 02e1h,0156h,-02h
	LWL	ghit403,AFUNC|3,ppckc+3
	.word	 02dfh,0156h,-03h
	LWL	ghit402,AFUNC|3,ppckcv+3
	.word	 02dbh,0156h,-02h
	LWL	ghit401,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_lcf_script
	LWL	ghit405,AFUNC|1,ppckc+3
	.word	 02e4h,0156h,-01h
	LWL	ghit404,AFUNC|3,ppckc+3
	.word	 02e1h,0156h,-02h
	LWL	ghit403,AFUNC|3,ppckc+3
	.word	 02dfh,0156h,-03h
	LWL	ghit402,AFUNC|3,ppckcv+3
	.word	 02dbh,0156h,-02h
	LWL	ghit401,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_mcs_script
	LWL	ghit103,AFUNC|1,ppckc+3
	.word	 02d2h,014dh,-012h
	LWL	ghit104,AFUNC|1,ppckc+3
	.word	 02d6h,014ch,-011h
	LWL	ghit105,AFUNC|5,ppckc+3
	.word	 02dbh,014dh,-010h
	LWL	ghit104,AFUNC|4,ppckc+3
	.word	 02d6h,014ch,-0fh
	LWL	ghit103,AFUNC|5,ppckc+3
	.word	 02d2h,014dh,-0fh
	LWL	ghit102,AFUNC|5,ppckcv+3
	.word	 02cbh,0149h,-0fh
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,5
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_mcm_script
	LWL	ghit105,AFUNC|5,ppckc+3
	.word	 02dbh,014dh,-010h
	LWL	ghit104,AFUNC|4,ppckc+3
	.word	 02d6h,014ch,-0fh
	LWL	ghit103,AFUNC|3,ppckc+3
	.word	 02d2h,014dh,-0fh
	LWL	ghit102,AFUNC|3,ppckcv+3
	.word	 02cbh,0149h,-0fh
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_mcf_script
	LWL	ghit105,AFUNC|1,ppckc+3
	.word	 02dbh,014dh,-010h
	LWL	ghit104,AFUNC|3,ppckc+3
	.word	 02d6h,014ch,-0fh
	LWL	ghit103,AFUNC|3,ppckc+3
	.word	 02d2h,014dh,-0fh
	LWL	ghit102,AFUNC|3,ppckcv+3
	.word	 02cbh,0149h,-0fh
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_mts_script
	LWL	ghit202,AFUNC|1,ppckc+3
	.word	 02cah,0146h,-01eh
	LWL	ghit203,AFUNC|1,ppckc+3
	.word	 02cfh,014eh,-020h
	LWL	ghit204,AFUNC|5,ppckc+3
	.word	 02d1h,0154h,-021h
	LWL	ghit203,AFUNC|4,ppckc+3
	.word	 02cfh,014eh,-020h
	LWL	ghit202,AFUNC|5,ppckc+3
	.word	 02cah,0146h,-01eh
	LWL	ghit201,AFUNC|5,ppckcv+3
	.word	 02c7h,014dh,-01ah
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_mtm_script
	LWL	ghit204,AFUNC|5,ppckc+3
	.word	 02d1h,0154h,-021h
	LWL	ghit203,AFUNC|4,ppckc+3
	.word	 02cfh,014eh,-020h
	LWL	ghit202,AFUNC|3,ppckc+3
	.word	 02cah,0146h,-01eh
	LWL	ghit201,AFUNC|3,ppckcv+3
	.word	 02c7h,014dh,-01ah
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_mtf_script
	LWL	ghit204,AFUNC|1,ppckc+3
	.word	 02d1h,0154h,-021h
	LWL	ghit203,AFUNC|3,ppckc+3
	.word	 02cfh,014eh,-020h
	LWL	ghit202,AFUNC|3,ppckc+3
	.word	 02cah,0146h,-01eh
	LWL	ghit201,AFUNC|3,ppckcv+3
	.word	 02c7h,014dh,-01ah
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_mbs_script
	LWL	ghit303,AFUNC|1,ppckc+3
	.word	 02cfh,0163h,-02h
	LWL	ghit304,AFUNC|1,ppckc+3
	.word	 02d4h,015ch,-01h
	LWL	ghit305,AFUNC|5,ppckc+3
	.word	 02d8h,015fh,-04h
	LWL	ghit304,AFUNC|4,ppckc+3
	.word	 02d4h,015ch,-01h
	LWL	ghit303,AFUNC|5,ppckc+3
	.word	 02cfh,0163h,-02h
	LWL	ghit302,AFUNC|5,ppckcv+3
	.word	 02ceh,0163h,-01h
	LWL	ghit301,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_mbm_script
	LWL	ghit305,AFUNC|5,ppckc+3
	.word	 02d8h,015fh,-04h
	LWL	ghit304,AFUNC|4,ppckc+3
	.word	 02d4h,015ch,-01h
	LWL	ghit303,AFUNC|3,ppckc+3
	.word	 02cfh,0163h,-02h
	LWL	ghit302,AFUNC|3,ppckcv+3
	.word	 02ceh,0163h,-01h
	LWL	ghit301,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_mbf_script
	LWL	ghit305,AFUNC|1,ppckc+3
	.word	 02d8h,015fh,-04h
	LWL	ghit304,AFUNC|3,ppckc+3
	.word	 02d4h,015ch,-01h
	LWL	ghit303,AFUNC|3,ppckc+3
	.word	 02cfh,0163h,-02h
	LWL	ghit302,AFUNC|3,ppckcv+3
	.word	 02ceh,0163h,-01h
	LWL	ghit301,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_hcs_script
	LWL	ghit503,AFUNC|1,ppckc+3
	.word	 02c4h,015bh,-02fh
	LWL	ghit504,AFUNC|1,ppckc+3
	.word	 02c4h,015bh,-032h
	LWL	ghit505,AFUNC|5,ppckc+3
	.word	 02c5h,014ch,-03ah
	LWL	ghit504,AFUNC|4,ppckc+3
	.word	 02c4h,015bh,-032h
	LWL	ghit503,AFUNC|5,ppckc+3
	.word	 02c4h,015bh,-02fh
	LWL	ghit502,AFUNC|5,ppckcv+3
	.word	 02c2h,015bh,-02dh
	LWL	ghit501,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_hcm_script
	LWL	ghit505,AFUNC|5,ppckc+3
	.word	 02c5h,014ch,-03ah
	LWL	ghit504,AFUNC|4,ppckc+3
	.word	 02c4h,015bh,-032h
	LWL	ghit503,AFUNC|3,ppckc+3
	.word	 02c4h,015bh,-02fh
	LWL	ghit502,AFUNC|3,ppckcv+3
	.word	 02c2h,015bh,-02dh
	LWL	ghit501,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

nb_hcf_script
	LWL	ghit505,AFUNC|1,ppckc+3
	.word	 02c5h,014ch,-03ah
	LWL	ghit504,AFUNC|3,ppckc+3
	.word	 02c4h,015bh,-032h
	LWL	ghit503,AFUNC|3,ppckc+3
	.word	 02c4h,015bh,-02fh
	LWL	ghit502,AFUNC|3,ppckcv+3
	.word	 02c2h,015bh,-02dh
	LWL	ghit501,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	goal1a,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	ghit101,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|1,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	ghit101,1
	LWL	1,AFUNC|1,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	goal1a,1
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LWL	1,AFUNC|2,a_kig
	LW	1,120
	LW	1,120
	.long	0

ppckcv	callr	ppckc
	movi	[0,08000h],a0
	move	*a9(OXPOS),a14,W
	jrn	pcv1
	neg	a0
pcv1	clr	a1
	calla	RANGERND
	move	a9,a8
	move	a0,a2
	movi	[1,0],a0
	move	a0,a1
	neg	a1
	calla	RANGERND
	move	a0,a1
	move	a2,a0
	jauc	set_obj_to_rect

ppckc
	callr	a_kig

	move	@PUCK_OBJECT,a9,L
	move	@PUCK_SHADOW,a10,L
	move	*a9(OCTRL),a14,W
	ori	M_WRNONZ,a14
	move	a14,*a9(OCTRL),W
	move	*a10(OCTRL),a14,W
	ori	M_WRNONZ,a14
	move	a14,*a10(OCTRL),W
	move	*a8(ANIMARG),a4,L
	move	*a4+,a2,W
	move	*a9(OXPOS),a14,W
	jrnn	ppcc1
	neg	a2
ppcc1	sll	16,a2
	move	*a9(OXVAL),a1,L
	move	a1,a5
	movi	50,a3
	calla	move_to_speed_x
	move	a1,*a9(OXVAL),L
	move	a1,*a10(OXVAL),L

	move	*a9(OZVAL),a1,L
	move	a1,a6
	move	*a4+,a2,W
	sll	16,a2
	movi	24,a3
	calla	move_to_speed_x
	move	a1,*a9(OZVAL),L
	move	a1,*a10(OZVAL),L

	move	*a9(OYVAL),a1,L
	move	a1,a7
	move	*a4+,a2,W
	sll	16,a2
	movi	24,a3
	calla	move_to_speed_x
	move	a1,*a9(OYVAL),L
	move	a1,*a10(OYVAL),L
	move	*a9(OYVEL),a0,L
	jrnn	ppcc8
	clr	a0
	move	a0,*a9(OYVEL),L
ppcc8	rets

**************************************************************************
*								         *
* SHOW_GCARDS_INTRO							 *
*								         *
**************************************************************************

SHOW_GCARDS_INTRO
	MOVI	PLAYER_4_BLOCK,A9
	MOVI	[150,-87],A10
	CREATE	PID_GCARD,SHOW_GCARD_PROC

	MOVI	PLAYER_8_BLOCK,A9
	MOVI	[150,399+1],A10
	CREATE	PID_GCARD,SHOW_GCARD_PROC

	MOVI	CYCLEGLP3,A8
	MOVK	1,A9
	MOVK	15,A10
	MOVK	2,A11
	CREATE	PID_BOXCOLOR,CYCLE16

SGI_WAIT
	SLEEP	1
	MOVI	PID_GCARD,A0
	CALLA	EXISTP_ALL
	JRNZ	SGI_WAIT			;BR=STILL OUT THERE

	movi	PID_BOXCOLOR,a0
	calla	KILLPROC_ALL

	RETP

**************************************************************************
*								         *
* SHOW_GCARDS_FREEZE							 *
*								         *
* PASS:									 *
* A9 = PLAYER BLOCK ADDRESS						 *
*								         *
**************************************************************************

SHOW_GCARDS_FREEZE_PROC
	MOVE	A9,A6				;SAVE PLAYER BLOCK
	MOVI	CYCLEGLP3,A8
	MOVK	1,A9
	MOVK	15,A10
	MOVK	2,A11
	C_A_K	PID_BOXCOLOR,CYCLE16
	MOVE	A6,A9				;RESTORE PLAYER BLOCK

	MOVE	@small_timer_on,A11,W		;SAVE SMALL TIMER STATE
	CLR	A2				;TURN OFF ON LEFT SIDE

	MOVI	[150,-87],A10
	CMPI	PLAYER_4_BLOCK,A9
	JREQ	SGFP_GO				;BR=LEFT GOALIE CARD
	MOVI	[150,399+1],A10
	MOVE	A11,A2				;USE CURRENT STATE
SGFP_GO
	CREATE	PID_GCARD,SHOW_GCARD_PROC

	MOVE	A2,@small_timer_on,W		;SET SMALL TIMER

SGFP_WAIT
	SLEEP	1
	MOVI	PID_GCARD,A0
	CALLA	EXISTP_ALL
	JRNZ	SGFP_WAIT			;BR=STILL OUT THERE

	MOVE	A11,@small_timer_on,W		;RESTORE SMALL TIMER STATE

	movi	PID_BOXCOLOR,a0
	calla	KILLPROC_ALL

	DIE

**************************************************************************
*								         *
* SHOW_GCARDS_ENDPER							 *
*								         *
**************************************************************************

SHOW_GCARDS_ENDPER
	MOVI	PLAYER_4_BLOCK,A9
	MOVI	[50,-87],A10
	CREATE	PID_GCARD,SHOW_GCARD_PROC

	MOVI	PLAYER_8_BLOCK,A9
	MOVI	[50,399+1],A10
	CREATE	PID_GCARD,SHOW_GCARD_PROC

	MOVI	CYCLEGLP3,A8
	MOVK	1,A9
	MOVK	15,A10
	MOVK	2,A11
	C_A_K	PID_BOXCOLOR,CYCLE16

	RETP

**************************************************************************
*								         *
* SHOW_GCARDS_GOALSUM							 *
*								         *
**************************************************************************

SHOW_GCARDS_GOALSUM
	MOVI	PLAYER_4_BLOCK,A9
	MOVI	[50,-87],A10
	CREATE	PID_GCARD,SHOW_GCARD_PROC

	MOVI	PLAYER_8_BLOCK,A9
	MOVI	[50,399+1],A10
	CREATE	PID_GCARD,SHOW_GCARD_PROC

	MOVI	CYCLEGLP3,A8
	MOVK	1,A9
	MOVK	15,A10
	MOVK	2,A11
	C_A_K	PID_BOXCOLOR,CYCLE16

	RETP


**************************************************************************
*								         *
* SHOW_GCARD_PROC							 *
*								         *
**************************************************************************

SHOW_GCARD_PROC
	MOVI	GCARD_INIT,B0
	CALLA	MULTIMAKE
	JRZ	SGP_ABORT			;BR=CAN'T DO IT
	MOVE	A8,A11

	MOVI	GCARD_DIGIT_INIT,B0
	CALLA	EASYMAKE
	JRZ	SGP_INSERT			;BR=NO OBJECTS

	MOVI	-3,A7
	MOVB	A7,*A8(OZOFF)

	MOVE	*A9(POF_SAVES),A5,W
	CMPI	100,A5
	JRLT	SGP_SAVES			;BR=UNDER MAX
	MOVI	99,A5
SGP_SAVES
	CLR	A4
	MOVK	10,A14
	DIVU	A14,A4

	MOVE	A5,A6
	SLL	5,A6
	ADDI	score_box_digitl,A6
	MOVE	*A6,A1,L
	MOVE	A4,A6
	MOVI	DMAWNZ,A4
	CALLA	ANI
	MOVE	A6,A4

	MOVI	[82,70],A6
	MOVE	A4,A4
	JRZ	SGP_LAST_DIGIT			;BR=SAVES IN A SINGLE DIGIT

	MOVI	[82,75],A6
	CMPI	1,A4
	JRNE	SGP_ONES_DIGIT			;BR=ADD ONES DIGIT PART
	MOVI	[82,73],A6
SGP_ONES_DIGIT
	MOVE	A6,*A8(OPARTSXY),L
	MOVE	A0,A8
	MOVE	A11,A8
	CALLA	INSPART

	MOVI	GCARD_DIGIT_INIT,B0
	CALLA	EASYMAKE
	JRZ	SGP_INSERT			;BR=NO OBJECTS

	MOVB	A7,*A8(OZOFF)

	SLL	5,A4
	ADDI	score_box_digitl,A4
	MOVE	*A4,A1,L
	MOVI	DMAWNZ,A4
	CALLA	ANI

	MOVI	[82,65],A6
	CMPI	1,A5
	JRNE	SGP_LAST_DIGIT			;BR=ADD TENS DIGIT PART
	MOVI	[82,67],A6

SGP_LAST_DIGIT
	MOVE	A6,*A8(OPARTSXY),L
	MOVE	A0,A8
	MOVE	A11,A8
	CALLA	INSPART

SGP_INSERT
	MOVE	A10,A1
	MOVI	TEXTZVAL+100,A2
	CALLA	SET_SCRNOBJ
	CALLA	INSERT_OBJ

	MOVE	*A9(POF_CHARACTER),A5,W
	SLL	5,A5
	ADDI	player_data,A5
	MOVE	*A5,A5,L

	PUSHP	A8

	MOVE	*A8(OPARTS),A8,L
	MOVE	*A5(TP_PLYRMUG_IMG),A1,L
	MOVI	DMAWNZ,A4
	CALLA	ANI
	MOVE	*A1(ICMAP),A0,L
	CALLA	CHANGE_PAL

	MOVE	*A8(OPARTS),A8,L
	MOVE	*A5(TP_PLYRNAME_IMG),A1,L
	MOVI	DMAWNZ,A4
	CALLA	ANI

	PULLPQ	A8

	SLEEP	1

	MOVI	0100000H,A10
	MOVI	-010000H,A11

	MOVE	@GAME_STATE,A14,W
	CMPI	INEPILOG,A14
	JRNE	SGP_CHECK_RIGHT			;BR=AT GOAL SUMMARY
	MOVI	-018000H,A11

SGP_CHECK_RIGHT
	CMPI	PLAYER_8_BLOCK,A9
	JRNE	SGP_SET_INIT_XVEL		;BR=LEFT CARD
	NEG	A10				;RIGHT CARD XVEL
	NEG	A11
SGP_SET_INIT_XVEL
	MOVE	A10,A0
	CALLR	SET_XVEL_MULTI

SGP_ON_LUPE
	SLEEP	1
	MOVE	*A8(OXVEL),A0,L
	JRZ	SGP_ON_WAIT			;BR=STOPPED
	ADD	A11,A0
	JRZ	SGP_ON_SET			;BR=SET ZERO
	GETST	A1
	MOVE	A11,A11
	GETST	A14
	XOR	A1,A14
	BTST	31,A14
	JRNZ	SGP_ON_SET			;BR=NOT BACKIN' UP
	CLR	A0
SGP_ON_SET
	CALLR	SET_XVEL_MULTI
	JRUC	SGP_ON_LUPE

SGP_ON_WAIT
	MOVE	*A8(ODAG),A1,L
	MOVE	*A8(OZVAL),A2,L
	CALLA	SET_SCRNOBJ

	MOVE	@GAME_STATE,A14,W
	CMPI	INEPILOG,A14
	JAEQ	SUCIDE				;BR=AT GOAL SUMMARY

	CMPI	PUM_ENDPER,A14
	JAEQ	SUCIDE				;BR=LEAVE ON SCREEN

	MOVE	@PUCK_MODE,A14,W
	CMPI	PUM_ENDPER,A14
	JAEQ	SUCIDE				;BR=LEAVE ON SCREEN

;	SLEEP	20
;	move	a8,a9
;	movi	70,a8
;	JSRP	button_wait
;	move	a9,a8
	SLEEP	70

	ABS	A10
SGP_OFF_LUPE
	SLEEP	1
	MOVE	*A8(OXVEL),A0,L
	MOVE	A0,A14
	ABS	A14
	CMP	A10,A14
	JRGT	SGP_DELETE			;BR=SHOULD BE OFF SCREEN
	ADD	A11,A0
	CALLR	SET_XVEL_MULTI
	JRUC	SGP_OFF_LUPE

SGP_DELETE
	CALLA	DELETE_OBJ
SGP_ABORT
;	CMPI	PLAYER_8_BLOCK,A9
;	JAEQ	SUCIDE				;BR=DON'T HAVE TO CLEAN UP
;
;	movi	PID_BOXCOLOR,a0
;	calla	KILLPROC_ALL

	DIE

**************************************************************************
*								         *
* SET_XVEL_MULTI							 *
*								         *
**************************************************************************

SET_XVEL_MULTI
	PUSH	A8
SXM_LUPE
	MOVE	A0,*A8(OXVEL),L
	MOVE	*A8(OPARTS),A8,L
	JRNZ	SXM_LUPE			;BR=ANOTHER PART
	PULLQ	A8
	RETS

GCARD_INIT
	.byte	9, 0, 0, 9	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	PLYRBXP		;IMGPAL
	.long	CHELIOS1P	;IMGPAL
	.long	LSTNME1P	;IMGPAL
	.long	PLAYERP		;IMGPAL
	.long	PLYRBCK2P	;IMGPAL
	.long	TRI		;IMGPAL
	.long	POSITP		;IMGPAL
	.long	CYCLEGLP3	;IMGPAL
	.long	GHLM5AP		;IMGPAL
	.word	OID_GCARD, 0	;OID, GLOBAL_OPTIONS
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	PLYRBOX, DMAWNZ, M_SCRNOBJ|M_NOSCALE, 0, 0
	LWWWW	M_CHELIOS, DMAWNZ, M_SCRNOBJ|M_NOSCALE, 2, OM_OPARTS
	.long	[77,50]
	LWWWW	CHELIOS1, DMAWNZ, M_SCRNOBJ|M_NOSCALE, -1, OM_OPARTS
	.long	[8,50]
	LWWWW	GOALTND, DMAWNZ, M_SCRNOBJ|M_NOSCALE, -1, 0
	LWWWW	PLYRBCK, DMAWNZ, M_SCRNOBJ|M_NOSCALE, 3, OM_OPARTS
	.LONG	[15,16]
	LWWWW	PCKTRI01, DMAWNZ, M_SCRNOBJ|M_NOSCALE, 1, OM_OPARTS
	.LONG	[17,70]
	LWWWW	SAVES, DMAWNZ, M_SCRNOBJ|M_NOSCALE, -1, 0
	LWWWW	CYCLEGL3, DMAWNZ, M_SCRNOBJ|M_NOSCALE, -1, OM_OPARTS
	.LONG	[78,63]
	LWWWW	GHLM5A01, DMAWNZ, M_SCRNOBJ|M_NOSCALE, -2, OM_OPARTS|OM_ANIM
	.LONG	[26,77]
	.LONG	GCARD_HELM_ANIM

GCARD_DIGIT_INIT
	.long	G00
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE
	.word	OM_OID
	.word	OID_GCARD

GCARD_HELM_ANIM
	LW	GHLM5A01,5
	LW	GHLM5A02,5
	LW	GHLM5A03,5
	LW	GHLM5A04,5
	LW	GHLM5A05,5
	LW	GHLM5A06,5
	LW	GHLM5A07,5
	LW	GHLM5A08,5
	LW	GHLM5A09,5
	LW	GHLM5A10,5
	LW	GHLM5A11,5
	LW	GHLM5A12,5
	LW	GHLM5A13,5
	LW	GHLM5A14,5
	LW	GHLM5A15,5
	LW	GHLM5A16,5
	LW	GHLM5A17,5
	LW	GHLM5A18,5
	LW	GHLM5A19,5
	LW	GHLM5A20,5
	.long	0
	


	.end

