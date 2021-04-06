 	.MLIB	"HHMACS.LIB"
	.FILE	"HHGAME.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"goals.tbl"
	.include	"HHGAME.TBL"
	.include	"HHHELP.TBL"
	.include	"hhgame.e"
	.include	"hhpick.g"
	.include	"hhtimer.g"
	.include	"hhattrct.g"
	.include	"hhselect.g"
	.include	"hhstabl2.g"
	.include	"hhstabl3.g"
	.include	"hhram.g"
	.include	"hhutil.g"
	.include	"hhsnd.g"
	.include	"hhpuck.g"
	.include	"hhtg.g"
	.include	"hhcontr2.g"
	.include	"hhtext.g"
	.include	"hhd.g"
	.include	"hhpall.g"
;	.include	"hhmath.g"
	.ref	find_dir_to_point
	.ref	dir_to_182
	.ref	set_obj_to_polar
	.include	"hhcoin.g"
;	.include	"hhcx.g"
	.ref	cx_game_start
	.ref	cx_game_over
	.include	"hhstats.g"
	.include	"hhproc.g"
;	.include	"hhcmos.g"
	.ref	GET_ADJ
	.ref	AUD1
	.include	"hhplayer.g"
	.include	"hhmisc.g"
	.include	"hhfade.g"
;	.include	"hhc.g"
	.ref	ANI
	.ref	maybe_ani
	.ref	small_timer_on
	.include	"hhscore.g"
	.include	"hhstable.g"
	.include	"hh.g"
;	.include	"hhcontrl.g"
	 .ref	global_control_slow
	 .ref	clean_up_players
;	.include	"hhndrone.g"
	.ref	set_drone_levels
	.ref	maybe_set_drone_levels
	.include	"hhspeech.g"
	.include	"hhtables.g"
	.include	"hhpick2.g"
	.include	"hhpup.g"
	.include	"hhhigher.g"
	.include	"hhfix.g"
	.include	"hhcontr3.g"

; end of include files

	.bss	team1,16		;team 1 1-26
	.bss	team2,16		;team 2 1-26
	.bss	TEAM1_SWAP,16
	.bss	TEAM2_SWAP,16
	.bss	team1_home,16
	.bss	team2_home,16

	;DON'T CHANGE ORDER FROM HERE
	.bss	team1_score_P1,16
	.bss	team1_score_P2,16
	.bss	team1_score_P3,16
	.bss	team1_score,16
	.bss	team2_score_P1,16
	.bss	team2_score_P2,16
	.bss	team2_score_P3,16
	.bss	team2_score,16
	;TO HERE, DAMMIT!

	.bss	period,16
	.bss	lgoalF_object,32	;LEFT GOAL FRONT PART FACING PLAYERS
	.bss	lgoalR_object,32	;LEFT GOAL REAR PART
	.bss	rgoalF_object,32	;RIGHT GOAL FRONT PART
	.bss	rgoalR_object,32	;RIGHT GOAL REAR PART
	.bss	ledge_object,32
	.bss	redge_object,32
	.bss	ledge2_object,32
	.bss	redge2_object,32
	.bss	world_mt_point,16	;for rink_watch
	.bss	last_wp_oxval,32	;for rink_watch, last watch oxval
	.bss	xobj1,32
	.bss	xobj2,32
	.bss	xobj3,32
	.bss	xobj4,32
	.bss	zobj1,32
	.bss	zobj2,32
	.bss	zobj3,32
	.bss	zobj4,32
	.bss	plwatch,16
	.bss	puck_op,16		;used for world points
	.bss	hold_net_anim,16	;non zero means we don't do normal net update (front only)
	.bss	record_data,32*10
	.bss	record_data_pointer,32
	.bss	force_buyin,16		;force bill's buyin page to come up

	.BSS	HELP_WINDOW_COUNT,16	;NUMBER OF HELP WINDOWS ON SCREEN

	.BSS	SHOW_START_SHIT,16	;SLIDE GRAPHICS, SHOW GOALIE CARDS,
					; SHOW HELP WINDOWS, REPORT POWER-UPS
	.bss	edge_28_piece,32
	.bss	back_wall_script,32
	.bss	edge_28_script,32
	.bss	teampal1,32
	.bss	teampal2,32
	.bss	all_beaten_bits,16

	.bss	saved_period_players,16
	.bss	last_control_scroll,16
	.bss	side_brightness,16

	.even

;attract mode		inamode
;initial entry		inintro
;TONIGHTS GAME		inintro
;period one		inplay
;period over		ingame
; END OF PERIOD STATS	INSTAT
; SUBSTITUTIONS		INSUBST
; buy in		INBUYIN
;period two		inplay
;period over		ingame
; END OF PERIOD STATS	INSTAT
; SUBSTITUTIONS		INSUBST
; buy in		INBUYIN
;period three		inplay
;period over		ingame
; END OF PERIOD STATS	INSTAT
; SUBSTITUTIONS		INSUBST
; buy in		INBUYIN
;period overtime	inplay
;period over		ingame
;FINAL GAME STATS(CMOS) INEPILOG
;game over		ingameov

**************************************************************************
*								         *
* player_start - START A PLAYER WHEN A PLAYER START BUTTON IS HIT	 *
* 									 *
* PASS:									 *
* A0 = PLAYER NUMBER (1, 2, 5, OR 6)					 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************

player_start
	MOVE	@VOLUME_SET,A14,W
	JAZ	SUCIDE				;BR=VOLUME NOT SET

	move	@GAME_STATE,a3,W

	CMPI	ININTRO_TEAMSEL,A3
	JRNE	PLS_GO				;BR=NOT TEAM SELECT
	MOVE	A0,A1
	DEC	A1
	CMPI	2,A1
	JRLT	PLS_GET_PBITS			;BR=PLAYER INDEX OKAY
	SUBK	2,A1
PLS_GET_PBITS
	MOVB	@TEAM_SELECT_BITS,A14
	BTST	A1,A14
	JRZ	PLS_GO				;BR=PLAYER NOT SELECTING TEAM

	MOVE	@SWITCH,A2,L
	NOT	A2

	KITN	4
	JREQ	PLS_TRANSLATE			;BR=4 PLAYER KIT
	MOVE	A1,A1
	JRZ	PLS_CHECK_SWITCHES		;BR=PLAYER 1
	SRL	8,A2				;PLAYER 2(4) FUDGE
	MOVK	24,A1
	JRUC	PLS_CHECK_SWITCHES

PLS_TRANSLATE
	SLL	3,A1				;TRANSLATE INDEX TO SHIFT VALUE
	NEG	A1
	SRL	A1,A2

PLS_CHECK_SWITCHES
	ANDI	M_SW_ALL,A2
	JRZ	PLS_GO				;BR=NO SWITCHES

	XORI	M_SW_U,A2
;	JRNZ	PLS_ABORT			;BR=SWITCHES OTHER THAN UP
	JRNZ	PLS_GO				;BR=SWITCHES OTHER THAN UP

	MOVK	1,A14				;FLAG RANDOM SELECT ENABLED
	ABS	A1
	SRL	3,A1
	SLL	A1,A14
	MOVB	@RANDOM_ENABLE_BITS,A1
	OR	A14,A1
	MOVB	A1,@RANDOM_ENABLE_BITS
	JRUC	PLS_ABORT			;DON'T EVEN START

PLS_GO
	SRL	3,A3				;SHIFT OUT SUB-STATE
	SLL	3,A3
	movi	player_start_table,a1
ps_l	move	*a1,a2,W
	jrz	ps_9				;BR=END OF TABLE
	cmp	a2,a3
	jrz	ps_g				;BR=FOUND THE STATE
	addi	48,a1
	jruc	ps_l
ps_9	LOCKUP
ps_g	move	*a1(16),a2,L
	jump	a2
PLS_ABORT
	JAUC	SUCIDE

player_start_table
	WL	INGAME,pcheck_game
	WL	ININTRO,pcheck_intro
	WL	INPLAY,pcheck_play
	WL	INAMODE,pcheck_amode
	WL	INDIAG,pcheck_diag
	WL	INGAMEOV,pcheck_gameov
	WL	INEPILOG,pcheck_epilog
	WL	INSTAT,PCHECK_SUCIDE
	WL	INSUBST,PCHECK_SUBST
	WL	INBUYIN,PCHECK_BUYIN
	.word	0

**************************************************************************
*								         *
* PCHECK_SUCIDE - JUST DIE!						 *
*								         *
* PASS:									 *
* A0 = PLAYER NUMBER (1, 2, 5, OR 6)					 *
* 									 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************

PCHECK_SUCIDE
	JAUC	SUCIDE

**************************************************************************
*								         *
* PCHECK_SUBST - DISPLAY "PLEASE WAIT" IF ENOUGH CREDITS 		 *
*								         *
* PASS:									 *
* A0 = PLAYER NUMBER (1, 2, 5, OR 6)					 *
* 									 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************

PCHECK_SUBST
;;;;;;;	callr	restart_if_new_player_rsgap
	MOVE	@period,A1,W
	CALLR	can_we_add_period_player
	JRNC	PCS_DONE			;BR=NOPE

	CALLR	do_we_continue_start
	JRNC	PCS_START			;BR=we need a start(not continue)

	CALLR	do_we_have_continue_credits
	JRNC	PCS_DONE			;BR=NOT enough to continue
	JRUC	PCS_MESS
PCS_START
	CALLR	do_we_have_start_credits
	JRNC	PCS_DONE			;BR=we don't have start credits
PCS_MESS
	MOVE	A0,A9
	DEC	A9
	CMPI	4,A9
	JRLT	PCS_NO_FUDGE
	SUBK	2,A9
PCS_NO_FUDGE
	CALLA	get_period_players
	BTST	A9,A0
	JRNZ	PCS_DONE			;BR=PLAYED LAST PERIOD

	SLL	4,A9
	MOVE	A9,A14
	ADDI	SUBST_OID_TABLE,A14
	MOVE	*A14,A2,W

	MOVI	SUPPLSTS-OSLINK+020H,A0
	MOVI	0FFFFH,A1
	CALLA	FINDOID
	JRNZ	PCS_DONE			;BR=ALREADY WAITING

	MOVK	1,A14
	MOVE	A14,@force_buyin,W

	MOVE	A2,A10

	MOVI	PLEASE_WAIT_INIT,B0
	CALLA	EASYMAKE

	MOVE	A10,*A8(OID),W

	ADDI	SUBST_X_TABLE,A9
	MOVE	*A9,A1,W
	ADDI	[243,0],A1
	CLR	A2
	CALLA	SET_SCRNOBJ

	CALLA	INSERT_OBJ
PCS_DONE
	JAUC	SUCIDE

PLEASE_WAIT_INIT
	.long	PLWAIT
	.word	DMAWNZ,M_SCRNOBJ|M_NOVEL|M_NOSCALE
	.word	0

SUBST_OID_TABLE
	.WORD	OID_PLAYER_1,OID_PLAYER_2,OID_PLAYER_3,OID_PLAYER_4

SUBST_X_TABLE
	.WORD	63,143,258,338

**************************************************************************
*								         *
* pcheck_amode - START GAME FROM ATTRACT MODE				 *
* 									 *
* PASS:									 *
* A0 = PLAYER NUMBER (1, 2, 5, OR 6)					 *
* 									 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************

pcheck_gameov
	CALLR	do_we_have_start_credits
	JANC	SUCIDE				;BR=NOT ENOUGH CREDITS

	CLR	A14
	MOVE	A14,@IRQSKYE,W			;BLACK BACKGROUND
	CALLA	OINIT				;FREE ALL OBJECTS

pcheck_amode
	.if	self_play

	callr	start_game	;this better set a different mode
	callr	fix_curplyrs

	.else

	callr	do_we_have_start_credits
	jrnc	pca99n

	mmtm	sp,a0
	movi	AUD_STARTS,a0		;audit games started
	calla	AUD1
	callr	start_game	;this better set a different mode
	mmfm	sp,a0
	jruc	player_start

	.endif

pca99
pca99n
	MOVE	@COINFLAG,A14,W
	JANZ	SUCIDE				;BR=ON CREDIT PAGE ALREADY
	MOVE	@CREDIT_PAGE_JUMPS,A14,W
	DEC	A14
	JAN	SUCIDE				;BR=TAKE OFF YOU HOSER!
	MOVE	A14,@CREDIT_PAGE_JUMPS,W
	calla	ATSTRT_CREDITS_NOCPJ
	jauc	SUCIDE
;	MOVE	A14,@CREDIT_PAGE_JUMPS,W
;	JAUC	CREDIT_JUMP2			;SHOW CREDIT PAGE

**************************************************************************
*								         *
* pcheck_intro - CHECK IF PLAYER MAY START DURING INTRO	GAME MODE	 *
* 									 *
* PASS:									 *
* A0 = PLAYER NUMBER (1, 2, 5, OR 6)					 *
* 									 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************

pcheck_intro
	movk	1,a1
	callr	do_start_button
	jrnc	pcin99

	MOVB	@TEAM_SELECT_BITS,A1
	MOVE	A1,A2
	MOVE	A1,A5

	MOVI	team1_home,A3
	MOVI	team2_home,A4

	KITN	4
	JREQ	PCI_4P			;BR=4 PLAYER KIT

	CMPI	2,A0
	JRLT	PCI_MASK		;BR=CHECK PLAYER 1
	SUBK	2,A0			;OFFSET 2 BITS LOWER
	SWAP	A3,A4
	JRUC	PCI_ADD
PCI_4P
	CMPI	5,A0
	JRLT	PCI_MASK		;BR=CHECK PLAYERS 1 AND 2
	SRL	2,A2			;CHECK PLAYERS 5 AND 6
	SUBK	2,A0			;OFFSET 2 BITS LOWER
	SWAP	A3,A4
PCI_MASK
	ANDI	011B,A2			;MASK OUT TEAM
	JRNZ	pcin99			;BR=TEAMMATE ALREADY CHOSEN
PCI_ADD
	DEC	A0
	MOVK	1,A14
	SLL	A0,A14
	OR	A14,A1			;ADD PLAYER TO CHOOSE TEAM
	MOVB	A1,@TEAM_SELECT_BITS

	MOVE	A5,A5
	JRNZ	PCI_TOGGLE		;BR=ALREADY CHOSE DEFAULT HOME/AWAY

	CLR	A14
	MOVE	A14,*A4,W		;SET FIRST PLAYER'S OPPONENT'S SIDE
PCI_TOGGLE
	MOVE	*A4,A14,W
	XORI	1,A14			;TOGGLE OTHER SIDE			
	MOVE	A14,*A3,W
pcin99	jauc	SUCIDE

**************************************************************************
*								         *
* pcheck_game								 *
* PCHECK_BUYIN								 *
*								         *
**************************************************************************

pcheck_game
PCHECK_BUYIN
	MOVE	A0,A1
	DEC	A1
	CMPI	1,A1
	JRLE	PCG_SAVE_STARTSW		;BR=PLAYER 1 OR 2
	SUBK	2,A1				;ADJUST PLAYER 3 OR 4
PCG_SAVE_STARTSW
	MOVK	1,A14
	SLL	A1,A14
	MOVE	@STARTSW,A1,W
	OR	A14,A1
	MOVE	A1,@STARTSW,W

	move	@period,a1
	inc	a1
;;;;;	callr	do_start_button_rsgap
	callr	do_start_button
	jauc	SUCIDE

pcheck_play
	callr	check_for_player
	jrc	pcp_ig
	move	@period,a1,W
;;;;;	callr	do_start_button_rsgap
	callr	do_start_button
	jauc	SUCIDE

pcp_ig			;button pressed during gameplay
	move	@period,a1,W
;;;;;	callr	do_start_button_rsgap
	callr	do_start_button
	jauc	SUCIDE

pcheck_diag
pcheck_epilog
	jauc	SUCIDE

**************************************************************************
*								         *
* CROWD_NOISE_PROC							 *
* 									 *
* PASS:									 *
* NUTIN'								 *
*								         *
**************************************************************************

SOFTEST_CROWD	EQU	127	;80
LOUDEST_CROWD	EQU	223	;191

CROWD_NOISE_PROC
	MOVK	CROWD_NOISES,A8
	MOVI	CROWD_NOISE_TABLE,A9
	MOVI	SOFTEST_CROWD,A10
	JRUC	CN_START
CN_LUPE
	MOVE	@crowd_track,A0,W
	JRZ	CN_START			;BR=NO CROWD NOISE
	CLR	A1				;OPEN CROWD TRACK
	MOVE	A1,@crowd_track,W
	CALLA	set_track_time
CN_START
	MOVE	@PUCK_MODE,A14,W
	CMPI	PUM_ENDPER,A14
	JAEQ	SUCIDE

	MOVE	@PUCK_CONTROL,A0,W
	JRNZ	CN_NOSCORE			;BR=SOMEBODY HAS CONTROL

	CMPI	PUM_SCORE,A14
	JRNE	CN_NOSCORE			;BR=NO GOAL

	MOVI	PID_CROWD_REACT_NOISE,A0
	CALLA	EXISTP_ALL
	JRNZ	CN_NOSCORE			;BR=ALREADY GOT ONE GOING

	MOVI	CROWD_CHEER_PROC,A7

	MOVE	@PLAYER_BITS,A14,W		;GET CURRENT PLAYERS
	JRZ	CN_REACT			;BR=ATTRACT MODE
	MOVE	@PUCK_OBJECT,A1,L
	MOVE	*A1(OXVAL),A1,L
	JRNN	CN_HUMAN_TEST			;BR=TEST FOR PLAYERS 1 AND 2
	SRL	2,A14				;TEST FOR PLAYERS 5 AND 6
CN_HUMAN_TEST
	ANDI	3,A14
	JRNZ	CN_REACT			;BR=AT LEAST ONE HUMAN PLAYER
	MOVI	CROWD_BOO_PROC,A7
CN_REACT
	MOVI	PID_CROWD_REACT_NOISE,A1
	CALLA	GETPRC

CN_NOSCORE
	MOVE	A8,A0
	MOVE	A10,A1
	CALLA	RAND0				;PICK SOUND FROM TABLE
	SLL	5,A0
	ADD	A9,A0
	MOVE	*A0+,A4,W
	CALLA	do_sound_at_volume
	JRC	CN_SUCCESS			;BR=COULDN'T MAKE SOUND
	SLEEP	1
	JRUC	CN_LUPE
CN_SUCCESS
	MOVE	A4,@crowd_track,W		;SAVE CROWD TRACK
	MOVE	*A0,A11,W
CN_NAP
	SLEEP	1

	MOVE	@PUCK_MODE,A14,W
	CMPI	PUM_ENDPER,A14
	JAEQ	SUCIDE

	MOVE	@PUCK_CONTROL,A0,W
	JRNZ	CN_CHECK_ZONE			;BR=SOMEBODY HAS CONTROL

	CMPI	PUM_SCORE,A14
;	JREQ	CN_LUPE				;BR=GOAL! MAKE CROWD REACT
	JRNE	CN_CHECK_ZONE			;BR=NO GOAL

	MOVI	PID_CROWD_REACT_NOISE,A0
	CALLA	EXISTP_ALL
	JRZ	CN_LUPE				;BR=GOAL! MAKE CROWD REACT

CN_CHECK_ZONE
	MOVE	@PUCK_OBJECT,A14,L
	MOVE	*A14(OXVAL),A0,L		;WHERE "PUCK" IS IT?

	CMPI	LEFT_BLUELINE_X,A0
	JRLE	CN_OFFZONE			;BR=IN LEFT ZONE
	CMPI	RGHT_BLUELINE_X,A0
	JRLT	CN_NEUTRAL			;BR=IN NEUTRAL ZONE
CN_OFFZONE
	CMPI	LOUDEST_CROWD,A10
	JRGE	CN_NEXT
	INC	A10
	JRUC	CN_ADJUST_CROWD
CN_NEUTRAL
	CMPI	SOFTEST_CROWD,A10
	JRLE	CN_NEXT
	DEC	A10
CN_ADJUST_CROWD
	MOVE	@crowd_track,A0,W		;CROWD TRACK
;	JRZ	CN_NEXT
	JRZ	CN_LUPE
	MOVE	A10,A1
	CALLA	set_track_volume
CN_NEXT
	DSJ	A11,CN_NAP

	JRUC	CN_LUPE

**************************************************************************
*								         *
* CROWD_CHEER_PROC							 *
*								         *
**************************************************************************

CROWD_CHEER_PROC
	MOVI	S_CROWD_5,A8
	MOVI	S_CROWD_9,A9
	MOVI	265,A10

	MOVI	511,A0
	CALLA	RANDPER
	JRC	CCP_GO
	SWAP	A8,A9
	MOVI	195,A10
CCP_GO
	MOVE	A8,A4
	CALLA	do_sound

	MOVK	31,A0
	CALLA	RAND0
	SLEEPR	A0

	MOVE	A9,A4
	CALLA	do_sound

	SLEEPR	A10

	DIE

**************************************************************************
*								         *
* CROWD_BOO_PROC							 *
*								         *
**************************************************************************

CROWD_BOO_PROC
	MOVI	crowd_noise_2,A8
	MOVI	crowd_noise_7,A9
	MOVI	162,A10

	MOVI	511,A0
	CALLA	RANDPER
	JRC	CBP_GO
	SWAP	A8,A9
	MOVI	225,A10
CBP_GO
	MOVE	A8,A4
	CALLA	do_sound

	MOVK	31,A0
	CALLA	RAND0
	SLEEPR	A0

	MOVE	A9,A4
	CALLA	do_sound

	SLEEPR	A10

	DIE


CROWD_NOISES	EQU	5

CROWD_NOISE_TABLE
	.word	S_CROWD_1,195
	.word	S_CROWD_4,268			;FIX HEAD-TAIL OVERLAP

	.word	S_CROWD_7,249

	.word	S_CROWD_3,160
	.word	S_CROWD_10,130

CROWD_CHEERS	EQU	2

CROWD_CHEER_TABLE
	.word	S_CROWD_5,174
	.word	S_CROWD_9,226

CROWD_BOOS	EQU	2

CROWD_BOO_TABLE
	.word	crowd_noise_2,214
	.word	crowd_noise_7,151


**************************************************************************
*								         *
* ORGAN_PROC - ORGAN PROCESS						 *
* 									 *
* PASS:									 *
* NUTIN'								 *
*								         *
**************************************************************************

;ORGAN_CHARGE_TABLE
; 	.LONG	S_ORGAN_CHARGE_C,S_ORGAN_CHARGE_BFLAT,S_ORGAN_CHARGE_B

ORGAN_PROC
	MOVE	@WAVEIRQS,A10,L			;DON'T PLAY UNTIL THIS TIME
OP_FACEOFF
	MOVE	@team1_score,A8,W
	MOVE	@team2_score,A14,W
	SUB	A14,A8				;LEFT - RIGHT SCORE
OP_F_WATCH
	SLEEP	1
	MOVE	@PUCK_MODE,A14,W
	CMPI	PUM_ENDPER,A14
	JAEQ	SUCIDE

	MOVE	@PUCK_CONTROL,A0,W
	JRNZ	OP_F_WATCH			;BR=SOMEBODY HAS CONTROL

	CMPI	PUM_FACEOFF,A14
	JRNE	OP_F_WATCH			;BR=NOT AT FACEOFF

OP_F_NOPOSS
	SLEEP	1
	MOVE	@PUCK_CONTROL,A1,W
	JRZ	OP_F_NOPOSS			;BR=NOBODY HAS CONTROL

	DEC	A1				;COMPUTE TEAM (0=LEFT, 1=RIGHT)
	SRL	2,A1

	CLR	A9				;IN NEUTRAL ZONE
	MOVE	A1,A11				;TEAM IN POSSESSION OF PUCK

	JRNZ	OP_F_RIGHT_CHECK		;BR=RIGHT TEAM HAS PUCK
	MOVE	A8,A8				;LEFT TEAM HAS PUCK
	JRP	OP_P_CHANGE			;BR=LEFT SIDE WINNING
	JRZ	OP_P_CHANGE
	MOVK	1,A2				;PLAY FOR LEFT SIDE
	JRUC	OP_F_PLAY
OP_F_RIGHT_CHECK
	MOVE	A8,A8
	JRN	OP_P_CHANGE			;BR=RIGHT SIDE WINNING
	JRZ	OP_P_CHANGE
	MOVK	2,A2				;PLAY FOR RIGHT SIDE
OP_F_PLAY
	MOVI	60*10,A3			;DELAY TIL NEXT ORGAN
;	MOVK	3,A0
;	CALLA	RAND0
;	SLL	5,A0
;	ADDI	ORGAN_CHARGE_TABLE,A0
;	MOVE	*A0,A4,L
	MOVI	S_ORGAN_CHARGE_C,A4		;FACEOFF CHARGE
	MOVI	1024*3/4,A0			;% CHANCE OF PLAYING
	CALLR	PLAY_ORGAN
	JRUC	OP_P_CHANGE
OP_POSS
	MOVE	@PUCK_OBJECT,A11,L
OP_P_WATCH
	SLEEP	1
	MOVE	@PUCK_MODE,A14,W
	CMPI	PUM_ENDPER,A14
	JAEQ	SUCIDE

	MOVE	@PUCK_CONTROL,A1,W
	JRNZ	OP_P_CHECK			;BR=SOMEBODY HAS CONTROL

	CMPI	PUM_SCORE,A14
	JREQ	OP_FACEOFF			;BR=SOMEBODY JUST SCORED
	CMPI	PUM_FACEOFF,A14
	JREQ	OP_F_NOPOSS			;BR=WE'RE AT A FACEOFF

	JRUC	OP_P_WATCH
OP_P_CHECK

**************************************************************************
*								         *
* ADD RANDOM PLAY?							 *
*								         *
**************************************************************************

	MOVE	*A11(OXVAL),A0,L		;WHERE "PUCK" IS IT?

;	CALLR	GET_ZONE

	CLR	A14
	DEC	A14
	CMPI	LEFT_BLUELINE_X,A0
	JRLE	OP_GOT_ZONE			;BR=IN LEFT ZONE
	INC	A14
	CMPI	RGHT_BLUELINE_X,A0
	JRLT	OP_GOT_ZONE			;BR=IN NEUTRAL ZONE
	INC	A14				;IN RIGHT ZONE
OP_GOT_ZONE
	MOVE	A14,A14
	JRNZ	OP_P_GET_TEAM			;BR=NOT IN NEUTRAL ZONE
	CLR	A9				;IN NEUTRAL ZONE
	JRUC	OP_P_WATCH
OP_P_GET_TEAM
	DEC	A1
	SRL	2,A1
	JRNZ	OP_P_RIGHT_CHECK		;BR=RIGHT TEAM HAS PUCK
	MOVE	A8,A8				;LEFT TEAM HAS PUCK
	JRZ	OP_P_WATCH			;BR=TIE SCORE
	JRP	OP_P_WATCH			;BR=LEFT SIDE WINNING
	MOVE	A14,A14
	JRP	OP_P_WATCH			;BR=ON RIGHT SIDE

	MOVK	1,A2				;PLAY FOR LEFT SIDE
	CLR	B9
	DEC	B9				;FLAG LEFT ZONE

	JRUC	OP_P_PLAY
OP_P_RIGHT_CHECK
	MOVE	A8,A8
	JRZ	OP_P_WATCH			;BR=TIE SCORE
	JRN	OP_P_WATCH			;BR=RIGHT SIDE WINNING
	MOVE	A14,A14
	JRN	OP_P_WATCH			;BR=ON LEFT SIDE

	MOVK	2,A2				;PLAY FOR RIGHT SIDE
	MOVK	1,B9				;FLAG RIGHT ZONE
OP_P_PLAY
	MOVE	A9,A9
	JRNZ	OP_P_WATCH			;BR=ALREADY PLAYED
	MOVE	A1,B1
	MOVI	60*15,A3
;	MOVI	1024/2,A0
	MOVI	1024*3/4,A0

	MOVE	@WAVEIRQS,A14,W
	MOVE	A8,A4
	ABS	A4
	CMPI	3,A4
	JRLT	OP_P_NORM			;BR=NOT BEHIND ENOUGH
;	MOVI	1024*3/4,A0
	MOVI	1024,A0
	SRL	1,A14
	JRC	OP_P_NORM			;BR=PLAY A NORMAL SCRIPT
	MOVI	60*20,A3
	MOVI	S_ORGAN_CHARGE_A,A4		;SUCCESSIVE CHARGES
;	MOVI	S_ORGAN_CHARGE_BFLAT,A4
	MOVI	CHARGE_SCRIPT,B2
	JRUC	OP_P_PLAY_SET
OP_P_NORM
	MOVI	S_ORGAN_DAH_F,A4
	MOVI	DAH_SCRIPT,B2			;DAH-DAH-DAH TUNE
	SRL	1,A14
	JRC	OP_P_PLAY_SET			;BR=PLAY THE OTHER ONE
	MOVI	S_ORGAN_LINE_G,A4		;THE OTHER TUNE
	MOVI	LINE_SCRIPT,B2
OP_P_PLAY_SET
	CALLR	PLAY_ORGAN
	JRNZ	OP_P_SCRIPT			;BR=ORGAN HAS STARTED

	MOVE	@WAVEIRQS,A2,L			;CHECK LAST TIME ORGAN PLAYED
	MOVE	A2,A14
	SUB	A10,A14
	CMPI	60*45,A14
	JRGE	OP_P_WATCH			;BR=DON'T DELAY ANY MORE

	MOVI	1024/2,A0
	CALLA	RANDPER
	JRNC	OP_P_WATCH			;BR=DON'T DELAY

	MOVI	60*5,A0				;ADD RANDOM DELAY
	MOVI	60,A1
	CALLA	RANGERND
	MOVE	A2,A10
	ADD	A0,A10

	JRUC	OP_P_WATCH
OP_P_SCRIPT
	MOVE	B9,A9				;ZONE ORGAN STARTED PLAYING
	MOVE	B1,A11				;TEAM IN POSSESSION OF PUCK

	MOVE	B2,A2
	JRUC	ORGAN_SCRIPT

OP_P_CHANGE
	SLEEP	1

**************************************************************************
*								         *
* ADD RANDOM PLAY?							 *
*								         *
**************************************************************************

	MOVE	@PUCK_MODE,A14,W
	CMPI	PUM_ENDPER,A14
	JAEQ	SUCIDE

	MOVE	@PUCK_CONTROL,A1,W
	JRNZ	OP_P_CHANGE_CHECK		;BR=SOMEBODY HAS CONTROL

	CMPI	PUM_SCORE,A14
	JREQ	OP_FACEOFF			;BR=SOMEBODY JUST SCORED
	CMPI	PUM_FACEOFF,A14
	JREQ	OP_F_NOPOSS			;BR=WE'RE AT A FACEOFF
	JRUC	OP_P_CHANGE
OP_P_CHANGE_CHECK
	DEC	A1
	SRL	2,A1
	CMP	A11,A1
	JREQ	OP_P_CHANGE			;BR=POSSESSION DIDN'T CHANGE
	JRUC	OP_POSS

LINE_SCRIPT
	.word	60,S_ORGAN_LINE_AFLAT
	.word	60,S_ORGAN_LINE_A
	.word	61,S_ORGAN_CHARGE_C
	.word	0

DAH_SCRIPT
	.word	72,S_ORGAN_DAH_FSHARP
	.word	67,S_ORGAN_DAH_G
	.word	69,S_ORGAN_CHARGE_C
	.word	0

CHARGE_SCRIPT
	.word	130,S_ORGAN_CHARGE_BFLAT
	.word	130,S_ORGAN_CHARGE_B
;	.word	130,S_ORGAN_CHARGE_C
	.word	0

**************************************************************************
*								         *
* ORGAN_SCRIPT								 *
*								         *
* PASS:									 *
* A2  = SCRIPT								 *
* A11 = TEAM IN POSSESSION						 *
*								         *
**************************************************************************

ORGAN_SCRIPT
	MOVI	1024/2,A0			;% CHANCE NOT TO ABORT SCRIPT
	CALLA	RANDPER
	GETST	A3
OS_LUPE
	MOVE	*A2+,A0,W
	JRZ	OP_P_CHANGE			;BR=DONE, NOW WATCH FOR CHANGE
	MMTM	A12,A2,A3
	SLEEPR	A0
	MMFM	A12,A2,A3

	MOVE	@PUCK_MODE,A14,W
	CMPI	PUM_ENDPER,A14
	JAEQ	SUCIDE

	MOVE	@PUCK_CONTROL,A1,W
	JRNZ	OS_CHECK			;BR=SOMEBODY HAS CONTROL

	CMPI	PUM_SCORE,A14
	JREQ	OP_FACEOFF			;BR=SOMEBODY JUST SCORED
	CMPI	PUM_FACEOFF,A14
	JREQ	OP_F_NOPOSS			;BR=WE'RE AT A FACEOFF

	PUTST	A3
	JRC	OS_GO				;BR=DON'T ABORT SCRIPT

;	CMPI	PUM_SHOT,A14
;	JREQ	OS_GO				;BR=CONTINUE SCRIPT ON SHOT
;	CMPI	PUM_SSHOT,A14
;	JREQ	OS_GO				;BR=CONTINUE SCRIPT ON SHOT
;	CMPI	PUM_ONETIME,A14
;	JREQ	OS_GO				;BR=CONTINUE SCRIPT ON SHOT

	MOVE	@PUCK_INTENDED,A1,W
	CMPI	PUM_PASS,A14
	JREQ	OS_CHECK			;BR=CHECK PASS RECEIVER
	CMPI	PUM_TPASS,A14
	JRNE	OP_POSS				;BR=DON'T CONTINUE SCRIPT
OS_CHECK
	PUTST	A3
	JRC	OS_GO				;BR=DON'T ABORT SCRIPT

	DEC	A1
	SRL	2,A1
	CMP	A11,A1
	JRNE	OP_POSS				;BR=CHANGE IN POSSESSION
OS_GO
	MOVE	@organ_track,A0,W
	JRZ	OS_SOUND			;BR=NO ORGAN PLAYING
	CLR	A14				;OPEN ORGAN TRACK
	MOVE	A14,@organ_track,W
	CALLA	cancel_track_sound
OS_SOUND
	MOVE	*A2+,A4,W
	CALLA	do_sound
	JRNC	OP_P_CHANGE			;BR=COULDN'T PLAY SOUND

	MOVE	A4,@organ_track,W		;SAVE ORGAN TRACK

	JRUC	OS_LUPE

**************************************************************************
*								         *
* PLAY_ORGAN								 *
*								         *
* PASS:									 *
* A0  = % CHANCE TO PLAY						 *
* A2  = SIDE TO PLAY FOR (0=BOTH, 1=LEFT, 2=RIGHT)			 *
* A3  = MAXIMUM DELAY UNTIL NEXT ORGAN					 *
* A4  = ORGAN SOUND							 *
* A10 = DON'T PLAY BEFORE THIS TIME					 *
* 									 *
* RETURN:								 *
* Z SET IF COULDN'T PLAY						 *
*								         *
**************************************************************************

PLAY_ORGAN
	MOVE	A2,A2
	JRZ	PO_GO
	MOVE	@PLAYER_BITS,A14,W		;GET CURRENT PLAYERS
	JRZ	PO_TEST				;BR=ATTRACT MODE
	DEC	A2
	JRZ	PO_TEST				;BR=TEST FOR PLAYERS 1 AND 2
	SRL	2,A14				;TEST FOR PLAYERS 5 AND 6
PO_TEST
	ANDI	3,A14
	JRZ	PO_FAIL				;BR=BOTH COMPUTER PLAYERS
PO_GO
	MOVE	@WAVEIRQS,A1,L
	CMP	A10,A1
	JRLT	PO_FAIL				;BR=TOO EARLY, DON'T PLAY YET
	CALLA	RANDPER
	JRNC	PO_FAIL				;BR=DON'T PLAY

	MOVE	@organ_track,A0,W
	JRZ	PO_SOUND			;BR=NO ORGAN PLAYING
	CLR	A14				;OPEN ORGAN TRACK
	MOVE	A14,@organ_track,W
	CALLA	cancel_track_sound
PO_SOUND
	CALLA	do_sound
	JRNC	PO_FAIL				;BR=COULDN'T PLAY SOUND

	MOVE	A4,@organ_track,W		;SAVE ORGAN TRACK

	MOVE	A1,A10				;COMPUTE NEXT TIME TO PLAY
	MOVE	A3,A0
	MOVI	60*10,A1
	CALLA	RANGERND
	ADD	A0,A10
	RETS
PO_FAIL
	CLR	A14
	RETS

;**************************************************************************
;*								         *
;* GET_ZONE								 *
;*								         *
;**************************************************************************
;
;GET_ZONE
;	CLR	A14
;	DEC	A14
;	CMPI	LEFT_BLUELINE_X,A0
;	JRLE	GZ_DONE
;	INC	A14
;	CMPI	RGHT_BLUELINE_X,A0
;	JRLT	GZ_DONE
;	INC	A14
;GZ_DONE
;	MOVE	A14,A14
;	RETS

**************************************************************************
*								         *
* start_game - START DA GAME						 *
* 									 *
* PASS:									 *
* NUTIN'								 *
* 									 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************
start_game_awin		;start game for a free winner
start_game_force_new_initials
start_game
	SOUNDON
	CALLA	GRAMINIT
	CLR	A14
	MOVB	A14,@TEAM_SELECT_BITS
	move	@in_at_game,a14,W
	jrz	sggg1
	calla	stop_attract_game_quick
sggg1	calla	init_speech_buffer
	CALLR	MY_WIPEOUT_NOVIDEO
	movi	ININTRO,a14
	move	a14,@GAME_STATE,W
	clr	a0
	move	a0,@team1_score,W
	move	a0,@team2_score,W
	move	a0,@period,W
	move	a0,@hot_player,W
	move	a0,@hold_net_anim,W
	callr	clear_all_player_blocks
	C_A_K	PID_SEQUENCE,game_start_sequence
	rets

clear_all_player_blocks
	movi	(8*PLAYER_BLOCK_SIZE)>>8,a2	;8 players * block size >>3 to byte >>2 to longword >>3 8 stores/loop
	movi	PLAYER_1_BLOCK,a1
plup	move	a0,*a1+,L
	move	a0,*a1+,L
	move	a0,*a1+,L
	move	a0,*a1+,L
	move	a0,*a1+,L
	move	a0,*a1+,L
	move	a0,*a1+,L
	move	a0,*a1+,L
	dsjs	a2,plup
	rets

game_start_sequence
	calla	cx_game_start
;	calla	attract_tune_end

	.if	self_play

	movk	26,a0
	calla	RANDU
	move	a0,@team1,W
	movk	26,a0
	calla	RANDU
	move	a0,@team2,W
	clr	a0
	move	a0,@team2_home,W
	inc	a0
	move	a0,@team1_home,W
	.else

	SLEEP	1

	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W

;	CLR	A0
;	CALLA	FADEOUT				;FADE DOWN ALL PALETTES
;	MOVK	16,A9
;	CREATE	PID_SKY,SKYDOWN			;FADE DOWN "SKY" COLOR

	CLR	A0
	CALLA	FADEOUTF			;FADE DOWN ALL PALETTES
	MOVK	9,A9
	CREATE	PID_SKY,SKYDOWN			;FADE DOWN "SKY" COLOR

	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS

	CALLA	MYOINIT			;RE-INIT THE OBJECT LIST
	CALLA	CLR_SCRN		;WIPE OUT THE BIT MAP

;	CLR	A14
;	MOVE	A14,@SUPRESS_PAGE_FLIP,W

	MOVK	1,A0
	MOVE	A0,@GAMERASE,W		;AUTO-ERASE FULL
;	MOVE	A0,@DISPLAYON,W

	.if	XUNIT=1
	MOVI	DPYSTRT0,A0
	MOVE	A0,@DPYST,L		;XUNIT RESET DISPLAY START POINT
	.else
;	movi	0fffch,a0
	movi	0ch,a0
	move	a0,@DPYSTRT,W
	.endif

	clr	a0
	move	a0,@WORLDX,L
	move	a0,@WORLDY,L
	move	a0,@glass_hit,W		;count for broken glass
	move	a0,@glass_break,W	;glass has not broken yet

	.if	1

	JSRP	INITIAL_ENTRY

	.else

	movk	26,a0
	calla	RANDU
	move	a0,@team1,W
	movk	26,a0
	calla	RANDU
	move	a0,@team2,W
	clr	a0
	move	a0,@team2_home,W
	inc	a0
	move	a0,@team1_home,W

;	JSRP	SUBSTITUTION_PAGE

	BLACKON
	MOVI	FONTGRYP,A0
	CALLA	GETFPAL

	.endif

	JSRP	TONIGHTS_GAME

;	CALLA	LAMPS_OFF

	.endif

	movk	1,a0
	move	a0,@period,W
	callr	period_start
	jauc	SUCIDE


**************************************************************************
*								         *
* restart_game_mode							 *
*								         *
**************************************************************************

restart_game_mode
	movi	INPLAY,a0
	move	a0,@GAME_STATE,W
	movi	-124,a0
	move	a0,@WORLDY+010h,W
	clr	a0
	move	a0,@WORLDX,L
	calla	create_puck
	C_A_KP	PID_WATCH,all_watch		;must create watch before players, so it runs after players
	calla 	create_players			;players are now cleaned up in watch process
	calla	create_rink
	C_A_KP	PID_GAME_TIMER,game_timer

	MOVI	[13,201],A9			;SCREEN [Y,X] POSITION
	MOVI	[1000,0],A10			;Z POSITION
	C_A_KP	PID_DISPLAY_CREDIT,DISPLAY_CREDIT_PROC

	jruc	fix_curplyrs

all_watch
aw0	callr	player_watch
	calla	puck_watch
	callr	set_world_point
	callr	update_shifted_images
	callr	slow_down_watch
	calla	update_walls
	calla	clean_up_players	;(place puck, fix arrows, etc)
	SLEEP	1
	jruc	aw0

slow_down_watch
	move	@PUCK_CONTROL_START,a0,L
	move	@WAVEIRQS,a14,L
	sub	a0,a14
	cmpi	520,a14		;time
	jrlt	sdw1

	.if	NO_HELP_WINDOWS
	.else
	move	@PUCK_CONTROL,a0,W
	jrz	sdw1e
	calla	annoy_player_shootpass
	.endif

sdw1e	move	@global_control_slow,a0,L
	addi	325,a0
	cmpi	[1,0f000h],a0
	jrhi	sdw1
	move	a0,@global_control_slow,L
sdw1	rets

premature_game_over
;	calla	kill_all_sound
	movi	INEPILOG,a0
	move	a0,@GAME_STATE,W
	callr	MY_WIPEOUT_NOVIDEO
	clr	a0
	move	a0,@timer_on,W
	move	a0,@cdronemod,W		;we ended early, no coin drone mod
	move	@PLAYER_BITS,@LAST_PLAYER_BITS,W
	move	a0,@PLAYER_BITS,W
	callr	fix_curplyrs

	MOVI	FONTGRYP2,A0
	CALLA	GETFPAL
	MOVE	A0,A5

	CLR	A0				;NO SLEEP TIL
	MOVI	STRCNCONV,A1			;ROUTINE
	MOVI	GAME_OVER_STRING,A8		;POINTER TO STRING
	MOVI	[75,199],A9		;[Y,X] SCREEN ADDRESS
	MOVI	[55,-2],A10			;[Y,X] SPACING
	MOVI	H50FONT,A11			;FONT
	MOVI	OID_JUNK,B1			;[SOUND,OID]
	JSRP	PRINTF

	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W

	MOVI	GO2_PAL_LIST,A0
	CALLA	FADEOUT				;FADE DOWN ALL PALETTES
;	MOVK	16,A9
;	CREATE	PID_SKY,SKYDOWN			;FADE DOWN "SKY" COLOR

	movi	INGAMEOV,a0
	move	a0,@GAME_STATE,W

	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS

;	SLEEP	120

	CALLA	END_INTERMISSION_TUNE
	SLEEP	161

	calla	kill_all_sound
	callr	MY_WIPEOUT
	calla	ATSTRT_TOPTEN
	jauc	SUCIDE

GO2_PAL_LIST
	.LONG	FONTGRYP2,0

game_over
	calla	cx_game_over
;	calla	kill_all_sound
	movi	INEPILOG,a0
	move	a0,@GAME_STATE,W
	move	@timer_on,a0,W
	jrz	go1p
	movk	2,a0
	move	a0,@timer_on,W
go1p	clr	a0
	move	a0,@small_timer_on,W
	SLEEP	1
	calla	set_game_over_tune
	move	@period,a14,W
	cmpi	4,a14
	jrnz	gojtp
	movk	ADJPAYOT,a0
	calla	GET_ADJ				;CHECK FOR FULL OVERTIME
	jrz	gojtn
gojtp	calla	spx_game_over
gojtn	MOVI	FONTGRYP2,A0
	CALLA	GETFPAL
	MOVE	A0,A5				;[COLOR,PALETTE]
	callr	audit_wins_losses
	MOVI	TIE_SCORE_STRING,A8
	MOVI	[75,199],A9			;[Y,X] SCREEN ADDRESS
	MOVI	[175,199],A4
	CLR	A10
	MOVE	@team1,A0,W
	MOVE	@team1_score,A1,W
	MOVE	@team2_score,A2,W
	CMP	A1,A2
	JREQ	GO_SAVE_SCORE			;BR=TIE GAME
	JRLT	GO_CHECK_SHUTOUT		;BR=LEFT TEAM WON
	SWAP	A1,A2				
	MOVE	@team2,A0,W			;RIGHT TEAM WON
GO_CHECK_SHUTOUT
	MOVE	A2,A2
	JRNZ	GO_NO_SHUTOUT			;BR=NOPE
;	MOVI	[75,199-6],A9			;[Y,X] SCREEN ADDRESS
;	MOVI	[75-50,199],A9			;[Y,X] SCREEN ADDRESS
	MOVI	SHUTOUT_STRING,A8
	JRUC	GO_SAVE_SCORE

GO_NO_SHUTOUT
	MOVI	WIN_STRING,A8
	MOVI	[50,199],A9			;[Y,X] SCREEN ADDRESS
	CMPI	team_maple_leafs,A0
	JRNE	GO_CHECK_DUCKS			;BR=NO DUCK FUDGE
	MOVI	[50-20,199],A9			;[Y,X] SCREEN ADDRESS
	MOVI	[200,199],A4
GO_CHECK_DUCKS
	CMPI	team_mighty_ducks,A0
	JRNE	GO_GET_TEAM_OFFSET		;BR=NO LEAF FUDGE
	MOVI	[50-20,199],A9			;[Y,X] SCREEN ADDRESS
	MOVI	[200,199],A4
GO_GET_TEAM_OFFSET
	SLL	10,A0
	ADDI	team_data,A0
	MOVE	*A0(TD_NICKNAME_STR),A10,L
	MOVI	WIN_STRING,A8
GO_SAVE_SCORE
	MOVE	A1,@RAMTEMP2,W			;WINNER
	MOVE	A2,@RAMTEMP3,W			;LOSER
	MOVE	A5,A11				;[COLOR,PALETTE]
	CREATE	PID_IND,FLASH_FINAL_MESS_PROC
	CLR	A0				;NO SLEEP TIL
	MOVI	STRCNCONV,A1			;ROUTINE
	MOVI	SCORE_STRING,A8
	MOVE	A4,A9
	MOVI	[0,-2],A10			;[Y,X] SPACING
	MOVI	H50FONT,A11			;FONT
	MOVI	OID_JUNK,B1			;[SOUND,OID]
	JSRP	PRINTF
	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	MOVI	GO_PAL_LIST,A0
	calla	FADE_FULL2HALF
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS
	SLEEP	180
	calla	kill_all_but_speech_tune
	move	@PLAYER_BITS,@LAST_PLAYER_BITS,W
	clr	a0
	move	a0,@PLAYER_BITS,W
	callr	fix_curplyrs
	callr	MY_WIPEOUT
	move	@all_beaten_bits,a0,W
	jrz	notabt
	JSRP	congratulations_page
notabt	JSRP	gameover_intermission_page
	SLEEP	60*1
	MOVI	60*10,A8
	JSRP	button_s_wait
	callr	MY_WIPEOUT
	MOVK	4,A0
	MOVI	PLAYER_1_BLOCK,A6
GO_RECORD_CHECK
;mdp yescmosrecord
;	MOVE	*A6(POF_LOCKED_CHAR),A14,W
;	JRNZ	GO_RC_NEXT			;BR=SPECIAL CHARACTER
;mdp yescmosrecord
	MOVE	*A6(POF_CMOS),A14,W
	JRNN	GO_RECORDS			;BR=WE HAVE A CMOS RECORD
GO_RC_NEXT
	CMPI	3,A0
	JRNE	GO_RC_N				;BR=NOT PLAYER 2
	ADDI	PLAYER_BLOCK_SIZE*2,A6		;SKIP DRONE PLAYER BLOCKS
GO_RC_N
	ADDI	PLAYER_BLOCK_SIZE,A6		;NEXT PLAYER BLOCK
	DSJS	A0,GO_RECORD_CHECK
	JRUC	GO_GAME_SUMMARY			;BR=NO RECORDS

GO_RECORDS
	JSRP	DISPLAY_UPDATED_RECORDS
	SLEEP	60*1
	MOVI	60*10,A8
	JSRP	button_s_wait
	callr	MY_WIPEOUT
GO_GAME_SUMMARY
	JSRP	GAME_SUMMARY
	SLEEP	60*1
	MOVI	60*7,A8
	JSRP	button_s_wait

	movi	PID_BOXCOLOR,a0
	calla	KILLPROC_ALL

	jauc	check_restart_gameover

**************************************************************************
*								         *
* GO_MESS								 *
* 	this is the return from check restart in hhfix			 *
*								         *
**************************************************************************
GO_MESS
	MOVI	FONTGRYP2,A0
	CALLA	GETFPAL
	MOVE	A0,A5
	CLR	A0				;NO SLEEP TIL
	MOVI	STRCNCONV,A1			;ROUTINE
	MOVI	GAME_OVER_STRING,A8		;POINTER TO STRING
	MOVI	[75,199],A9			;[Y,X] SCREEN ADDRESS
	MOVI	[55,-2],A10			;[Y,X] SPACING
	MOVI	H50FONT,A11			;FONT
	MOVI	OID_PROMPT,B1			;[SOUND,OID]
	JSRP	PRINTF

	MOVE	A2,A8
	CALLA	PULL_OBJ			;REMOVE	FROM LIST
GO_ZMOD_LUPE
	MOVE	*A2(OZVAL),A14,L		;MOVE Z IN FRONT OF OTHER TEXT
	DEC	A14
	MOVE	A14,*A2(OZVAL),L
	MOVE	*A2(OPARTS),A2,L
	JRNZ	GO_ZMOD_LUPE			;BR=ANOTHER PART
	CALLA	INSERT_OBJ			;RE-INSERT WITH CORRECTED Z

	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	MOVI	GO2_PAL_LIST,A0
	CALLA	FADEOUT				;FADE DOWN ALL PALETTES
	movi	INGAMEOV,a0
	move	a0,@GAME_STATE,W
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS
	CALLA	END_INTERMISSION_TUNE
	SLEEP	161
	calla	kill_all_sound
	callr	MY_WIPEOUT
	calla	ATSTRT_TOPTEN
	jauc	SUCIDE

**************************************************************************
*								         *
* fill_up_ot								 *
*								         *
**************************************************************************
fill_up_ot
	GBLOCK	a8,a6
	movb	*a6(POF_PERIODS_PAID),a14
	ori	00001111b,a14
	movb	a14,*a6(POF_PERIODS_PAID)
	jauc	SUCIDE

**************************************************************************
*								         *
* audit_wins_losses							 *
*								         *
**************************************************************************

audit_wins_losses
	mmtm	sp,a0,a1,a2,a3,a4
	clr	a3
	move	@team1_score,a1,W
	move	@team2_score,a2,W
	cmp	a2,a1
	jrz	awl_d
	movk	1,a3
	cmp	a2,a1
	jrhi	awl_d
	movk	2,a3
awl_d	movi	AUD_TIES,a0
	add	a3,a0
	calla	AUD1
	move	a3,a3
	jrnz	awld_wl
	callr	find_cpu_team
	move	a4,a4
	jrz	awl9
	movi	AUD_CPU_TIE,a0
	jruc	awla9
awld_wl	movi	AUD_CPU_WIN,a0
	calla	find_cpu_team
	cmp	a4,a3
	jrz	awla9
	movi	AUD_CPU_LOSS,a0
awla9	calla	AUD1
awl9	mmfm	sp,a0,a1,a2,a3,a4
	rets

**************************************************************************
*								         *
* find_cpu_team								 *
* 	output	a4 = 0 - no total cpu team				 *
* 		     1 - team 1 is all cpu				 *
* 		     2 - team 2 is all cpu				 *
*								         *
**************************************************************************
find_cpu_team
	mmtm	sp,a0,a5
	movk	1,a0
	callr	fcpo
	move	a4,a5
	callr	fcpo
	add	a4,a5
	jrz	fcpt1
	movk	5,a0
	callr	fcpo
	move	a4,a5
	callr	fcpo
	add	a4,a5
	jrnz	fcpt0
fcpt2	movk	2,a4
	mmfm	sp,a0,a5
	rets
fcpt1	movk	1,a4
	mmfm	sp,a0,a5
	rets
fcpt0	clr	a4
	mmfm	sp,a0,a5
	rets
fcpo	clr	a4
	GBLOCK	a0,a14
	move	*a14(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	fcpo8
	movk	1,a4
fcpo8	inc	a0
	rets

**************************************************************************
*								         *
* FLASH_FINAL_MESS_PROC - FLASH FINAL RESULT MESSAGE			 *
* 									 *
* PASS:									 *
* A8  = MESSAGE								 *
* A9  = POSITION							 *
* A10 = WINNING TEAM, IF ANY						 *
* A11 = PALETTE NUMBER							 *
*								         *
**************************************************************************

FLASH_FINAL_MESS_PROC
	MOVE	A10,@RAMTEMP1,L
	MMTM	A12,A8,A9,A10,A11
	CLR	A0				;NO SLEEP TIL
	MOVI	STRCNCONV,A1			;ROUTINE
	MOVE	A11,A5				;[COLOR,PALETTE]

	MOVE	A10,A14
	MOVI	[55,-2],A10			;[Y,X] SPACING
	MOVE	A14,A14
	JRZ	FFFMP_PRINT			;BR=DON'T FUCK WITH THIS STRING!

	CMPI	COLO_NICK_STR,A14
	JRNE	FFFMP_CHECK_HAWKS		;BR=NOT AVALANCHE KLUDGE
	MOVI	[55,-3],A10			;[Y,X] SPACING
	
FFFMP_CHECK_HAWKS
	CMPI	CHIC_NICK_STR,A14
	JRNE	FFFMP_PRINT			;BR=NOT BLACKHAWKS KLUDGE
	MOVI	[55,-8],A10			;[Y,X] SPACING

FFFMP_PRINT
	MOVI	H50FONT,A11			;FONT
	MOVI	OID_TEXT,B1			;[SOUND,OID]
	JSRP	PRINTF

	MOVE	@RAMTEMP1,A10,L
	JRZ	FFFMP_OKAY			;BR=DON'T FUCK WITH THIS STRING!

	CMPI	COLO_NICK_STR,A10
	JREQ	FFFMP_FIX_Z			;BR=FIX FUCKIN' AVALANCHE
	CMPI	CHIC_NICK_STR,A10
	JRNE	FFFMP_OKAY			;BR=NOT THE FUCKIN' BLACKHAWKS

FFFMP_FIX_Z
	MOVE	A2,A8
	MOVE	*A2(OZVAL),A6,L	

FFFMP_FIX_Z_LUPE
	MOVE	*A2(OPARTS),A2,L		;W
	JRZ	FFFMP_REINSERT			;BR=THIS SHOULDN'T HAPPEN!
	MOVE	*A2(OPARTS),A3,L		;I
	MOVE	*A3(OPARTS),A4,L		;N
	MOVE	*A4(OPARTS),A5,L		;!
	MOVE	*A5(OIMG),A14,L
	CMPI	FONT51EXC,A14
	JREQ	FFFMP_REINSERT			;BR=DON'T SCREW WITH "WIN !"
	INC	A6
	MOVE	A6,*A2(OZVAL),L
	JRUC	FFFMP_FIX_Z_LUPE
	
FFFMP_REINSERT
	CALLA	PULL_OBJ
	CALLA	INSERT_OBJ
FFFMP_OKAY
	MMFM	A12,A8,A9,A10,A11

	SLEEP	20

	CALLA	CLRTEXT

	SLEEP	10

	JRUC	FLASH_FINAL_MESS_PROC

GAME_OVER_STRING
	.STRING	"GAME\nOVER",0
	.EVEN

WIN_STRING
	.STRING	"%p\n\iWIN !",0
	.LONG	RAMTEMP1
	.LONG	[0,-2]
	.EVEN

SCORE_STRING
	.STRING	"%u - %u",0
	.LONG	RAMTEMP2
	.LONG	RAMTEMP3
	.EVEN

TIE_SCORE_STRING
	.STRING	"TIE GAME !",0
	.EVEN

OVERTIME_STRING
	.STRING	"OVERTIME !",0
	.EVEN

SHUTOUT_STRING
	.STRING	"SHUTOUT !",0
;	.STRING	"A\nSHUTOUT !",0
;	.STRING	"A\fSHUTOUT!",0
;	.LONG	[0,14]
	.EVEN


**************************************************************************
*								         *
* GAME_SUMMARY								 *
*								         *
**************************************************************************

GAME_SUMMARY
	MOVI	FONTGRYP,A0
	CALLA	GETFPAL
	MOVI	ORGTXT1P,A0
	CALLA	GETFPAL
	MOVI	REDTXT3P,A0
	CALLA	GETFPAL
	MOVI	BLUTXT3P,A0
	CALLA	GETFPAL

	MOVI	METAL_ICE_INIT,B0
	CALLA	MULTIMAKE

	MOVI	GAME_SUM_MESS,A8
	JSRP	LM_PRINTF

	MOVE	@team1,A3,W
	SLL	10,A3
	ADDI	team_data,A3
	MOVE	*A3(TD_CITY_STR),A14,L
	MOVE	A14,@RAMTEMP1,L

	MOVI	DUMMY_INIT,B0
	CALLA	EASYMAKE
	MOVI	[90+10,99+45],A1
	movi	TEXTZVAL,a2
	CALLA	SET_SCRNOBJ
	CALLA	INSERT_OBJ

	move	*a3(TD_ALTTEAMLOGO),a1,L
	jrnz	nalit2
	MOVE	*A3(TD_TEAMLOGO_IMG),A1,L
nalit2	MOVI	DMAWNZ,A4
	CALLA	ANI
	MOVE	*A1(ICMAP),A0,L
	CALLA	CHANGE_PAL

	MOVE	@team2,A3,W
	SLL	10,A3
	ADDI	team_data,A3
	MOVE	*A3(TD_CITY_STR),A14,L
	MOVE	A14,@RAMTEMP2,L

	MOVI	DUMMY_INIT,B0
	CALLA	EASYMAKE
	MOVI	[90+10,299-45],A1
	movi	TEXTZVAL,a2
	CALLA	SET_SCRNOBJ
	CALLA	INSERT_OBJ

	move	*a3(TD_ALTTEAMLOGO),a1,L
	jrnz	nalit1
	MOVE	*A3(TD_TEAMLOGO_IMG),A1,L
nalit1	MOVI	DMAWNZ,A4
	CALLA	ANI
	MOVE	*A1(ICMAP),A0,L
	CALLA	CHANGE_PAL

	MOVI	TEAMS_MESS,A8
	JSRP	LM_PRINTF

	MOVE	@team1_score,@RAMTEMP1,L
	MOVE	@team2_score,@RAMTEMP2,L

	MOVI	[168-28+30,230],A9		;[Y,X] SCREEN ADDRESS
	MOVK	5,A10
	MOVI	team1_score_P1,A11

GS_PERIOD_GOALS_LUPE
	MOVE	*A11,A0,W
	MOVE	*A11(040H),A1,W
	CMPI	5,A10
	JREQ	GS_SET_PERIOD_GOALS		;BR=1ST PERIOD
	CMPI	1,A10
	JRNE	GS_GET_PREVIOUS_GOALS		;BR=NOT TOTAL SCORE
	MOVE	*A11(-010H),A0,W		;TOTAL SCORES
	MOVE	*A11(040H-010H),A1,W
	JRUC	GS_SET_PERIOD_GOALS

GS_GET_PREVIOUS_GOALS
	MOVE	*A11(-010H),A14,W
	SUB	A14,A0
	MOVE	*A11(040H-010H),A14,W
	SUB	A14,A1
GS_SET_PERIOD_GOALS
	MOVE	A0,@RAMTEMP1,L
	MOVE	A1,@RAMTEMP2,L

	CMPI	2,A10
	JRNE	GS_GET_STRING			;BR=NOT OVERTIME
	MOVE	@period,A14,W
	CMPI	4,A14
	JREQ	GS_GET_STRING			;BR=OVERTIME VALID
	MOVI	OT_EMPTY_STRING,A8		;NO OVERTIME THIS GAME
	JRUC	GS_DISPLAY_STRING

GS_GET_STRING
	MOVE	A10,A8
	DEC	A8
	SLL	5,A8
	ADDI	GOALS_HEADER_TABLE,A8
	MOVE	*A8,A8,L
GS_DISPLAY_STRING
	MMTM	SP,A9,A10,A11
	CLR	A0				;NO SLEEP TIL
	MOVI	STRCNCONV,A1			;ROUTINE
;	MOVI	PERIOD_SCORES_STRING,A8		;POINTER TO STRING
	MOVI	[0,-1],A10			;[Y,X] SPACING
	MOVI	H18FONT,A11			;FONT
	MOVI	OID_TEXT,B1			;[SOUND,OID]
	JSRP	PRINTF
	MMFM	SP,A9,A10,A11

	ADDI	[0,35],A9
	ADDK	010H,A11

	DSJ	A10,GS_PERIOD_GOALS_LUPE

	SLEEP	1

	JSRP	SHOW_GCARDS_GOALSUM

	SLEEP	25

	MOVI	[50+70+25,6+6+57],A9
	MOVI	PLAYER_4_BLOCK,A6
	MOVE	@team2_score,A1,W
	MOVI	OID_PLAYER_4,B1
	CALLR	GS_GOALIE_DATA
	MOVE	A10,A11

	PUSH	A11
	MOVI	[50+70+25,306+6+57-8],A9
	MOVI	PLAYER_8_BLOCK,A6
	MOVE	@team1_score,A1,W
	MOVI	OID_PLAYER_8,B1
	CALLR	GS_GOALIE_DATA
	PULLQ	A11

	SLEEP	1

	CMP	A10,A11
	JRNE	GS_ONE_BEST			;BR=ONLY ONE BEST	

	MOVE	A10,A10
	JRZ	GS_DONE				;BR=BOTH 0%

	MOVI	OID_PLAYER_4,A2			;BOTH EQUAL
	CALLR	GS_SET_GOLD_PAL
	MOVI	OID_PLAYER_8,A2
	CALLR	GS_SET_GOLD_PAL
	JRUC	GS_DONE

GS_ONE_BEST
	MOVI	OID_PLAYER_4,A2
	CMP	A10,A11
	JRGT	GS_OB_GO			;BR=LEFT GOALIE IS BEST
	MOVI	OID_PLAYER_8,A2			;RIGHT GOALIE IS BEST
GS_OB_GO
	CALLR	GS_SET_GOLD_PAL

GS_DONE
	RETP

**************************************************************************
*								         *
* GS_SET_GOLD_PAL							 *
*								         *
**************************************************************************

GS_SET_GOLD_PAL
	MOVI	SUPPLSTS-OSLINK+1*020H,A8

GS_SGP_LUPE
	MOVE	*A8(OID),A14,W
	CMP	A2,A14
	JRNE	GS_SGP_NEXT			;BR=NOT BEST OBJECT

	MOVI	GLDTXT5P,A0
	CALLA	CHANGE_PAL

GS_SGP_NEXT
	MOVE	*A8(OSLINK),A8,L
	JRNZ	GS_SGP_LUPE			;BR=NOT DONE

	MOVI	STARS_INIT,B0
	CALLA	EASYMAKE
	JRZ	GS_SGP_DONE

	MOVI	[50+46,6+43],A1
	CMPI	OID_PLAYER_4,A2
	JREQ	GS_SGP_SET_STARS
	MOVI	[50+46,306+43],A1

GS_SGP_SET_STARS
	MOVI	TEXTZVAL+110,A2
	CALLA	SET_SCRNOBJ
	CALLA	INSERT_OBJ

GS_SGP_DONE
	RETS

**************************************************************************
*								         *
* GS_GOALIE_DATA							 *
* 									 *
* PASS:									 *
* A1 = OPPOSING TEAM SCORE						 *
* A6 = GOALIE DATA BLOCK						 *
* A9 = [Y,X] POSITION							 *
* B1 = OID								 *
*								         *
* RETURN:								 *
* A10 = SAVE PCTG							 *
*								         *
**************************************************************************

GS_GOALIE_DATA
	MMTM	SP,A1,A6,A9
	CLR	A0				;NO SLEEP TIL
	MOVI	STRRNCONV,A1			;ROUTINE
	MOVI	HFPAL,A5
	MOVI	SHOTS_ON_STR,A8
	MOVI	[11,-1],A10			;[Y,X] SPACING
	MOVI	H10FONT,A11			;FONT
	JSRP	PRINTF
	MMFM	SP,A1,A6,A9

	MOVE	*A6(POF_SAVES),A0,W

	MOVE	A0,A7

	ADD	A1,A0

	MOVE	A0,A2

	CMPI	100,A0
	JRLT	GS_SHOTS			;BR=UNDER MAXIMUM
	MOVI	99,A0
GS_SHOTS
	MOVE	A0,@RAMTEMP1,L

	MMTM	SP,A2,A6,A7,A9
	CMPI	PLAYER_8_BLOCK,A6
	JRNE	GS_PRINT_SHOTS
	ADDK	8,A9
GS_PRINT_SHOTS
	CLR	A0				;NO SLEEP TIL
	MOVI	STRCNCONV,A1			;ROUTINE
	MOVI	HFPAL,A5
	MOVI	SHOTS_VALUE_STR,A8
	ADDI	[0,11],A9
	MOVI	[0,-1],A10			;[Y,X] SPACING
	MOVI	H10FONT,A11			;FONT
	JSRP	PRINTF
	MMFM	SP,A2,A6,A7,A9

	MOVI	10000,A10

	MOVI	PCTG_1000_STRING,A8
	CMP	A2,A7
	JRNE	GS_CALC_PCTG			;BR=CALCULATE PCTG
	MOVE	A2,A2
	JRNZ	GS_PCTG				;BR=100%
	MOVK	1,A2				;0% FUDGE

GS_CALC_PCTG
	CMPI	PLAYER_8_BLOCK,A6
	JRNE	GS_CP_GO
	ADDK	3,A9

GS_CP_GO
	MOVI	10000,A14
	MPYU	A14,A7
	DIVU	A2,A7
	ADDK	5,A7				;ROUND UP
	MOVI	10,A14
	DIVU	A14,A7

	MOVE	A7,A10

	CLR	A6
	DIVU	A14,A6
	MOVE	A7,@RAMTEMP3,W			;THOUSANTHS
	MOVE	A6,A7
	CLR	A6
	DIVU	A14,A6
	MOVE	A7,@RAMTEMP2,W			;HUNDRETHS
	MOVE	A6,A7
	CLR	A6
	DIVU	A14,A6
	MOVE	A7,@RAMTEMP1,W			;TENTHS

	MOVI	PCTG_FORMAT_STRING,A8
GS_PCTG
	PUSH	A10
	CLR	A0				;NO SLEEP TIL
	MOVI	STRLNCONV,A1			;ROUTINE
	MOVI	HFPAL,A5
	MOVI	[11,3],A14
	ADDXY	A14,A9
	MOVI	[0,-1],A10			;[Y,X] SPACING
	MOVI	H10FONT,A11			;FONT
	JSRP	PRINTF
	PULLQ	A10

	RETS


PCTG_1000_STRING
	.STRING	"1.000",0

PCTG_FORMAT_STRING
	.STRING	".%u%u%u",0
	.LONG	RAMTEMP1
	.LONG	RAMTEMP2
	.LONG	RAMTEMP3
	.EVEN

SHOTS_ON_STR
;	.STRING	"SHOTS ON:",0
	.STRING	"SHOTS ON:\nSAVE PCTG:",0
	.EVEN

;SAVE_PCTG_STR
;	.STRING	"SAVE PCTG:",0
;	.EVEN

SHOTS_VALUE_STR
	.STRING	"%u",0
	.LONG	RAMTEMP1
	.EVEN


DUMMY_INIT
	.long	CSECS01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID
	.word	OID_JUNK

GOALS_HEADER_TABLE
	.LONG	F_STRING,OT_STRING,THIRD_STRING,SECOND_STRING,FIRST_STRING

GAME_SUM_MESS
	MESS_MAC2 H18FONT,-1,0,199,20,HFPAL+0101H,STRCNCONV,OID_TEXT
;	.STRING	"GAME SUMMARY",0
	.STRING	"GOAL SUMMARY",0
	.EVEN

TEAMS_MESS
	MESS_MAC2 H18FONT,-1,0,20,168+30,HFPAL,STRLNCONV,OID_TEXT
	.STRING	"\p%p\n\p%p",0
	.LONG	BLUTXT3P
	.long	RAMTEMP1
	.LONG	REDTXT3P
	.long	RAMTEMP2
	.EVEN

;PERIOD_SCORES_STRING
;	.STRING	"\p%p\n\p%u\n\p%u",0
;	.LONG	FONTGRYP
;	.long	RAMTEMP3
;	.LONG	BLUTXT3P
;	.long	RAMTEMP1
;	.LONG	REDTXT3P
;	.long	RAMTEMP2
;	.EVEN

FIRST_STRING
	.STRING	"\p1\dST\d\n\p%u\n\p%u",0
	.LONG	FONTGRYP
;	.long	H11WFONT
	.long	H10FONT
	.long	H18FONT
	.LONG	BLUTXT3P
	.long	RAMTEMP1
	.LONG	REDTXT3P
	.long	RAMTEMP2
	.EVEN

SECOND_STRING
	.STRING	"\p2\dND\d\n\p%u\n\p%u",0
	.LONG	FONTGRYP
;	.long	H11WFONT
	.long	H10FONT
	.long	H18FONT
	.LONG	BLUTXT3P
	.long	RAMTEMP1
	.LONG	REDTXT3P
	.long	RAMTEMP2
	.EVEN

THIRD_STRING
	.STRING	"\p3\dRD\d\n\p%u\n\p%u",0
	.LONG	FONTGRYP
;	.long	H11WFONT
	.long	H10FONT
	.long	H18FONT
	.LONG	BLUTXT3P
	.long	RAMTEMP1
	.LONG	REDTXT3P
	.long	RAMTEMP2
	.EVEN

OT_STRING
	.STRING	"\p\dOT\d\n\p%u\n\p%u",0
	.LONG	FONTGRYP
	.long	H18TFONT
	.long	H18FONT
	.LONG	BLUTXT3P
	.long	RAMTEMP1
	.LONG	REDTXT3P
	.long	RAMTEMP2
	.EVEN

OT_EMPTY_STRING
	.STRING	"\p\dOT",0
	.LONG	FONTGRYP
	.long	H18TFONT
	.EVEN

F_STRING
	.STRING	"\pF\n\p%u\n\p%u",0
	.LONG	FONTGRYP
	.LONG	BLUTXT3P
	.long	RAMTEMP1
	.LONG	REDTXT3P
	.long	RAMTEMP2
	.EVEN

**************************************************************************
*								         *
* period_start								 *
*								         *
**************************************************************************
period_start
	calla	set_background_tune
	callr	MY_WIPEOUT
	clr	a14
	move	a14,@scored_by,W	;no halt on timer
	move	a14,@glass_break,W

	movi	FLOATRCP,a0		;palette for small score box
	calla	GETFPAL
	movi	CITYP,a0		;palette for small score box stuff
	calla	GETFPAL

	CREATE	PID_ORGAN,ORGAN_PROC
	CREATE	PID_CROWD_NOISE,CROWD_NOISE_PROC

	CREATE	PID_PUCK_PTR,PUCK_PTR_PROC

	CLR	A14
	MOVE	A14,@SHOW_START_SHIT,W		;DEFAULT NOT 1ST PERIOD

	move	@period,a1,W
	CMPI	1,A1
	JRNE	PS_GO				;BR=NOT 1ST PERIOD

	MOVK	1,A14
	MOVE	A14,@SHOW_START_SHIT,W		;DO IT

	CLR	A14
	MOVE	A14,@HELP_WINDOW_COUNT,W	;RESET COUNT

	CALLA	START_FACEOFF_POWERUP_PROC
	CALLA	DISPLAY_TEAM_GRAPHICS
PS_GO
	callr	update_period_players
	callr	clear_all_please_waits
	callr	restart_game_mode
	calla	hotbar_periodstart
	calla	set_drone_levels
	clr	a0
	move	a0,@timer_on,W
	move	a0,@timer_ok,W
	calla	init_timer_value
	movi	400,a0			;take us through to face off

	move	@period,a1,W
	cmpi	1,a1
	jrz	ps_1p

	calla	show_timer		;show timer for a while
ps_1p	clr	a0		;faceoff at 0,339
	movi	339,a1
	calla	spx_period_faceoff
	calla	period_faceoff
	move	@WAVEIRQS,@time_score_left,L	;easier
	move	@WAVEIRQS,@time_score_right,L	;easier
	jauc	store_players_tired

clear_all_please_waits
	movk	1,a1
	callr	capw1
	callr	capw1
	movk	5,a1
	callr	capw1
capw1	GBLOCK	a1,a6
	movb	*a6(POF_TOP_MODE),a0
	cmpi	7,a0
	jrz	capw2
	cmpi	5,a0
	jrnz	uppus
capw2	movk	4,a0
	movb	a0,*a6(POF_TOP_MODE)
uppus	inc	a1
	rets

period_over
	calla	spx_period_over1
	clr	a14
	move	a14,@scored_by,W	;no halt on timer
	callr	fix_palette_lights
	move	@period,a0,W
	addi	AUD_PERIOD1-1,a0
	calla	AUD1
	subi	AUD_PERIOD1-1,a0

	DEC	A0
	SLL	4,A0
	ADDI	team1_score_P1,A0
	MOVE	@team1_score,A14,W
	MOVE	A14,*A0,W
	MOVE	@team2_score,A14,W
	MOVE	A14,*A0(040H),W

	calla	replace_all_turbo_palettes

;	MOVI	255,A1
	MOVI	LOUDEST_CROWD,A1
	MOVE	@crowd_track,A0,W
	JRZ	PO_KILL_SOUND			;BR=NO CROWD
	SLL	6,A0
	ADDI	track_0_volume,A0
	MOVE	*A0,A1,W
PO_KILL_SOUND
	calla	kill_all_sound_but_speech
	MOVI	air_horn_blast,A4
	CALLA	do_sound

	MOVI	S_CROWD_3,A4
	CALLA	do_sound_at_volume

;	MOVI	CROWD_CHEER_PROC,A7
;
;	MOVE	@PLAYER_BITS,A14,W		;GET CURRENT PLAYERS
;	MOVE	@PUCK_OBJECT,A1,L
;	MOVE	*A1(OXVAL),A1,L
;	JRNN	CN_HUMAN_TEST			;BR=TEST FOR PLAYERS 1 AND 2
;	SRL	2,A14				;TEST FOR PLAYERS 5 AND 6
;PO_HUMAN_TEST
;	ANDI	3,A14
;	JRNZ	CN_REACT			;BR=AT LEAST ONE HUMAN PLAYER
;	MOVI	CROWD_BOO_PROC,A7
;PO_REACT
;	MOVI	PID_CROWD_REACT_NOISE,A1
;	CALLA	GETPRC

	movi	PID_SEQUENCE,a14
	move	a14,*a13(PROCID),W	;set our id
	movi	INGAME,a0,W
	move	a0,@GAME_STATE,W
	calla	stop_timer
	clr	a0
	move	a0,@timer_on,W		;so when we turn it on next, is not <0
;	movi	200,a0
;	calla	show_timer		;show timer for 3 seconds
	movi	101,a0
	move	a0,@PUCK_MODE,W		;puck is in period over mode
	move	@PUCK_OBJECT,a8,L
	move	*a8(ODT_VEL),a1,L
	sra	3,a1
	move	*a8(ODT_DIR),a0,L
	calla	set_obj_to_polar
	clr	a0
	move	a0,@SCROLLX,L
	SLEEP	2
	movi	PID_COLOR,a0
	calla	KILLPROC_ALL

	move	@period,a0,W
	cmpi	4,a0
	jrz	game_over
	cmpi	3,a0
	JRNE	PO_FADE				;BR=NOT END OF 3RD PERIOD

	move	@team1_score,a0,W
	move	@team2_score,a1,W
	cmp	a0,a1
	JRNE	game_over			;BR=NO OVER TIME

	MOVI	OVERTIME_STRING,A8
	MOVI	[50,199],A9			;[Y,X] SCREEN ADDRESS
;	MOVI	FONTGRYP2,A0
	MOVI	REDTXT3P,A0
	CALLA	GETFPAL
	MOVE	A0,A11				;[COLOR,PALETTE]
	CLR	A10
	CREATE	PID_IND,FLASH_FINAL_MESS_PROC

	movi	200,a0
	calla	show_timer		;show timer for 3 seconds

	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	MOVI	GO_PAL_LIST,A0
	calla	FADE_FULL2HALF
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS

	SLEEP	120

	MOVK	ADJPAYOT,A0
	CALLA	GET_ADJ				;CHECK FOR FULL OVERTIME
	JRNZ	PO_INT				;BR=YEP, DO INTERMISSION

	MOVK	6,A0
	MOVI	PLAYER_1_BLOCK,A6
PO_FREE_OT_LUPE
	MOVB	*A6(POF_PERIODS_PAID),A14
	BTST	2,A14
	JRZ	PO_FOTL_NEXT			;BR=DIDN'T PAY FOR 3RD PERIOD
	ORI	01000B,A14
	MOVB	A14,*A6(POF_PERIODS_PAID)	;ADD FREE OVERTIME
PO_FOTL_NEXT
	ADDI	PLAYER_BLOCK_SIZE,A6		;NEXT PLAYER BLOCK
	DSJS	A0,PO_FREE_OT_LUPE

	move	@period,a0,W
	inc	a0
	move	a0,@period,W
	callr	period_start
	jauc	SUCIDE
PO_INT
	jruc	intermission

PO_FADE
;	move	@period,a0,W
;	cmpi	4,a0
;	jrz	artott
	movi	200,a0
	calla	show_timer		;show timer for 3 seconds
;artott
	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	MOVI	EOP_PAL_LIST,A0
	calla	FADE_FULL2HALF
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS

	SLEEP	10

	JSRP	SHOW_GCARDS_ENDPER

	SLEEP	120
	calla	spx_period_over2
	jruc	intermission


GO_PAL_LIST
	.LONG	FONTGRYP2,REDTXT3P
EOP_PAL_LIST
	.long   FREEBOXP
	.long	PRPTRBOP,BLUTRBOP,YLWTRBOP,GRNTRBOP
	.long	LSTNME1P,NAMEBARP
	.long	SCOREBAR,JITTERP,CITYP,SCORESP,PERIODP,LEDSP	;,SCCITYP

nolist	.long	T2FIXED,TEXTPAL
	.long	player_1_turbopal,player_2_turbopal
	.long	player_3_turbopal,player_4_turbopal
	.long	0

intermission
	callr	MY_WIPEOUT

;	move	@period,a0,W
;	cmpi	4,a0
;	jrz	game_over
;	cmpi	3,a0
;	jrz	normal_game_over
	JSRP	intermission_page
	move	@period,a0,W
	cmpi	1,a0
	jrnz	nohint
	callr	MY_WIPEOUT
	JSRP	hint_page
nohint	JSRP	SUBSTITUTION_PAGE

	jruc	buy_in

gameover_intermission_page
;	calla	set_game_over_tune		;now done at game over
	JSRP	DISPLAY_INTERMISSION_PAGE
	RETP

intermission_page
	calla	set_intermission_tune
	MOVI	INSTAT,A14
	MOVE	A14,@GAME_STATE,W
	JSRP	DISPLAY_INTERMISSION_PAGE
	SLEEP	60*2
	MOVI	60*7,A8
	JSRP	GAME_BUTTON_WAIT
	RETP

hint_page
	BLACKON
	JSRP	build_random_hint
	BLACKOFF
	movi	99,a14
	move	a14,@MAX_PALXFERS,W
	clr	a0
	calla	FADEINF			;fade down all palettes
	JSRP	FADE_WAIT
	calla	RESET_MAX_PALXFERS
	SLEEP	25
	movi	300,a8
	JSRP	GAME_BUTTON_WAIT
	RETP

**************************************************************************
*								         *
* il_string_m		;string,MESS_MAC				 *
*								         *
**************************************************************************

il_string_m		;string,MESS_MAC
	move	*sp,a8,L
	mmfm	a8,a0,a1,a5,a9,a10,a11,a14
	move	a8,*sp,L			;past our inline args
	move	a0,b1
	clr	a0
	move	a14,a8
	rets

**************************************************************************
*								         *
* buy_in								 *
*								         *
**************************************************************************

buy_in
	MOVI	INBUYIN,A14
	MOVE	A14,@GAME_STATE,W

	callr	MY_WIPEOUT

	.if	self_play
	.else

	MOVE	@period,A1,W

	CMPI	3,A1
	JRLT	BI_GO				;BR=NOT OVERTIME

	MOVK	ADJPAYOT,A0
	CALLA	GET_ADJ				;CHECK FOR PAY OVERTIME
	JRNZ	BI_DOIT				;BR=PAY UP SLOBS

	MOVK	6,A0
	MOVI	PLAYER_1_BLOCK,A6
BI_FREE_OT_LUPE
	MOVB	*A6(POF_PERIODS_PAID),A14
	BTST	2,A14
	JRZ	BI_FOTL_NEXT			;BR=DIDN'T PAY FOR 3RD PERIOD
	ORI	01000B,A14
	MOVB	A14,*A6(POF_PERIODS_PAID)	;ADD FREE OVERTIME
BI_FOTL_NEXT
	ADDI	PLAYER_BLOCK_SIZE,A6		;NEXT PLAYER BLOCK
	DSJS	A0,BI_FREE_OT_LUPE

	JRUC	bi_9				;START OVERTIME

BI_GO
	MOVE	@force_buyin,A14,W
	JRNZ	BI_DOIT				;BR=SOMEBODY WANTS IN

	MOVE	@PLAYER_BITS,A2,W		;GET CURRENT PLAYERS
	JRZ	BI_DOIT				;BR=NOBODY

	MOVI	01111B,A3
	MOVE	@NPLAYERS,A14,W
	SUBK	2,A14
	JRNZ	BI_CHECK_ALL			;BR=4 PLAYER KIT
	MOVI	01001B,A3
BI_CHECK_ALL
	INC	A1
	CALLR	get_period_players		;GET NEXT PERIOD PAID PLAYERS
	CMP	A3,A2
	JRNE	BI_CHECK_REST			;BR=ALL NOT PLAYING
	XOR	A0,A2
	JRZ	bi_9				;BR=ALL PAID NEXT PERIOD
	JRUC	BI_DOIT

BI_CHECK_REST
	CMPI	2,A1
	JRGT	BI_DOIT				;BR=3RD PERIOD BUY-IN

	CALLR	COUNT_PLAYER_BITS
	DEC	A14
	JRZ	BI_DOIT				;BR=ONLY ONE PLAYER ACTIVE

	MOVE	A0,A4
	INC	A1
;	CMPI	3,A1
;	JRGT	BI_CR_CHECK			;BR=3RD PERIOD BUY-IN
	CALLR	get_period_players		;GET 3RD PERIOD PAID PLAYERS
	AND	A0,A4				;GET PLAYERS PAID REST OF GAME
BI_CR_CHECK
	XOR	A4,A2
	JRZ	bi_9				;BR=ALL PLAYING, PAID REST

BI_DOIT
	JSRP	DO_BUY_IN

	CLR	A14
	MOVE	A14,@force_buyin,W

	MOVE	@period,A1,W
	INC	A1
	CALLR	get_period_players
	MOVE	A0,A0
	JRZ	premature_game_over		;BR=END DA GAME

	.endif

bi_9
;	CALLA	END_INTERMISSION_TUNE
;	SLEEP	161

	move	@period,a0,W
	inc	a0
	move	a0,@period,W
	callr	period_start
	jauc	SUCIDE

player_watch
pwc_0	movi	pwmst,a10
	callr	pw_msh

	jruc	pw_mph
;	callr	pw_mph
;	SLEEP	1
;	jruc	pwc_0

pw_msh	movk	15,a5
;	movk	9,a5

	JRUC	pwms4

**************************************************************************
*								         *
* COUNT_PLAYER_BITS							 *
* 									 *
* PASS:									 *
* A0 = BITS								 *
* RETURN:								 *
* A14 = NUMBER OF BITS 0 THROUGH 3 HIGH					 *
*								         *
**************************************************************************

COUNT_PLAYER_BITS
	PUSH	A1
	MOVK	3,A1
	CLR	A14
CPB_TOTAL_LUPE
	BTST	A1,A0
	JRZ	CPB_TL_NEXT			;BR=PLAYER NOT ACTIVE
	INC	A14				;COUNT ACTIVE PLAYER
CPB_TL_NEXT
	DEC	A1
	JRNN	CPB_TOTAL_LUPE			;BR=NEXT PLAYER
	PULLQ	A1
	RETS

**************************************************************************
*								         *
* find_dist_quick2							 *
*								         *
**************************************************************************

	.align
find_dist_quick2
	sub	a2,a0
	abs	a0
	sub	a3,a1
	abs	a1
	cmp	a1,a0
	jrls	fdq12
fdq02	srl	1,a1
	add	a0,a1
	rets
fdq12	srl	1,a0
	add	a0,a1
	rets

**************************************************************************
*								         *
* pwms4									 *
*								         *
**************************************************************************

pwms4	mmfm	a10,a9,a8,a7,a6
	move	*a9,a9,L	;object
	move	*a8,a8,L	;object

	MOVE	*A9(ODT_FOCIOFF1),A4,L
	GETST	B9
	MOVE	*A8(ODT_FOCIOFF1),A0,L
	GETST	B8
	JRZ	PWM_GO				;BR=CIRCLE VS. CIRCLE OR
						;   CIRCLE VS. ELLIPSE
	SWAP	A8,A9				;FIX ELLIPSE VS. CIRCLE
	MOVE	A0,A14
	MOVE	A4,A0
;	GETST	B8
	MOVE	A14,A4
;	GETST	B9
PWM_GO
	move	*a8(OXVAL),a2,L
;	addi	[0,08000h],a2
;	sra	16,a2
	SRA	12,A2			;ROUND UP FRACTION
	ADDK	8,A2
	SRA	4,A2
	MOVE	A2,B2			;A8 X ANIMP
	move	*a8(OZPOS),a3,W
	MOVE	A3,B3			;A8 Z ANIMP

;	MOVE	*A8(ODT_FOCIOFF1),A0,L
;	GETST	B8

	MOVE	A0,A14
	SLL	16,A14
	SRA	16,A14
	ADD	A14,A2			;ADD X OFFSET
	MOVE	A2,B4			;A8 X FOCI 1

	SRA	16,A0
	ADD	A0,A3			;ADD Z OFFSET
	MOVE	A3,B5			;A8 Z FOCI 1

	move	*a9(OXVAL),a0,L
;	addi	[0,08000h],a0
;	sra	16,a0
	SRA	12,A0			;ROUND UP FRACTION
	ADDK	8,A0
	SRA	4,A0
	MOVE	A0,B0			;A9 X ANIMP
	move	*a9(OZPOS),a1,W
	MOVE	A1,B1			;A9 Z ANIMP

;	MOVE	*A9(ODT_FOCIOFF1),A4,L
;	GETST	B9
;	MOVE	A4,B14

	MOVE	A4,A14
	SLL	16,A14
	SRA	16,A14
	ADD	A14,A0			;ADD X OFFSET
	MOVE	A0,B6			;A9 X FOCI 1

	SRA	16,A4
	ADD	A4,A1			;ADD Z OFFSET
	MOVE	A1,B7			;A9 Z FOCI 1

	callr	find_dist_quick2	;find quick, slightly incorrect distance
	AND	B8,B9
	BTST	29,B9
	JRNZ	PWM_STORE		;BR=CIRCLE AGAINST CIRCLE

	MOVE	A1,A11

;**************************************************************************
;**************************************************************************
;	;IF BIT 29, Z FLAG SET, THEN JUMP TO LAST find_dist_quick2
;
;	BTST	29,B8
;	JRZ	PWM_EGO			;BR=A8 IS AN ELLIPSE
;
;	MOVE	*A9(ODT_FOCIOFF0),A4,L
;
;	MOVE	B0,A0			;A9 ANIMP
;	MOVE	B1,A1
;
;	MOVE	A4,A14
;	SLL	16,A14
;	SRA	16,A14
;	ADD	A14,A0			;ADD X OFFSET TO GET A9 X FOCI 0
;
;	SRA	16,A4
;	ADD	A4,A1			;ADD Z OFFSET TO GET A9 Z FOCI 0
;
;	;A8 FOCI 1 IN A2,A3
;
;	SLL	1,A11
;	CLR	A4
;	JRUC	PWM_LAST_QUICKY
;PWM_EGO
;**************************************************************************
;**************************************************************************

	MOVE	*A8(ODT_FOCIOFF0),A0,L
	MOVE	B2,A2			;A8 ANIMP
	MOVE	B3,A3

	MOVE	A0,A14
	SLL	16,A14
	SRA	16,A14
	ADD	A14,A2			;ADD X OFFSET
	MOVE	A2,B2			;A8 X FOCI 0

	SRA	16,A0
	ADD	A0,A3			;ADD Z OFFSET
;	MOVE	A3,B3			;A8 Z FOCI 0

	MOVE	B6,A0			;A9 FOCI 1
	MOVE	B7,A1

	callr	find_dist_quick2	;find quick, slightly incorrect distance
	ADD	A1,A11

;	MOVE	B14,B14
;	JRZ	PWM_HALF		;BR=ELLIPSE AGAINST A CIRCLE

	MOVE	*A9(ODT_FOCIOFF0),A2,L

	MOVE	B0,A0			;A9 ANIMP
	MOVE	B1,A1

	MOVE	A2,A14
	SLL	16,A14
	SRA	16,A14
	ADD	A14,A0			;ADD X OFFSET
	MOVE	A0,B0			;A9 X FOCI 0

	SRA	16,A2
	ADD	A2,A1			;ADD Z OFFSET
	MOVE	A1,B1			;A9 Z FOCI 0

	MOVE	B2,A2			;A8 X FOCI 0
	;A8 Z FOCI 0 IN A3

	callr	find_dist_quick2	;find quick, slightly incorrect distance
	MOVE	A1,A4

	MOVE	B4,A2			;A8 FOCI 1
	MOVE	B5,A3

	MOVE	B0,A0			;A9 FOCI 0
	MOVE	B1,A1
;PWM_LAST_QUICKY
	callr	find_dist_quick2	;find quick, slightly incorrect distance
	ADD	A4,A1
;	MOVE	A4,A4
;	JRNZ	PWM_PICK_SHORTER
;	SLL	1,A1
;PWM_PICK_SHORTER
	CMP	A1,A11
	JRGE	PWM_HALF		;BR=DISTANCE TO FOCI 0 SHORTER
	MOVE	A11,A1			;DISTANCE TO FOCI 1 SHORTER
PWM_HALF
	SRA	1,A1
PWM_STORE
	move	A1,*A7,W	;store in distance block
	move	A1,*A6,W	;store in distance block
;	dsjs	a5,pwms4
	dsj	a5,pwms4
pwsxx	movi	PLAYER_1_BLOCK,a6
	movk	8,a10			;it is quicker here to just run through everyone regardless
	movi	PLAYER_BLOCK_SIZE,a5
	move	@PUCK_CONTROL,a0,W	;now do puck distances
	jrz	nb_np			;do puck distance
	sll	4,a0
	addi	POF_D_1P-16,a0
nb_hp	move	a6,a7
	add	a0,a7
	move	*a7,a14,W
	move	a14,*a6(POF_D_PUCK),W
	add	a5,a6
	dsjs	a10,nb_hp
	rets
nb_np	move	@PUCK_OBJECT,a9,L

	move	*a9(OXVAL),a2,L
	addi	[0,08000h],a2
	sra	16,a2
;	move	*a9(OXPOS),a2,W		;half

	move	*a9(OZPOS),a3,W
nbnp1	move	*a6(POF_OBJECT),a8,L
	jrz	nbnpk

	move	*a8(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
;	move	*a8(OXPOS),a0,W		;half

	move	*a8(OZPOS),a1,W

	MOVE	*A8(ODT_FOCIOFF1),A4,L
	JRZ	NB_GET_DIST		;BR=CIRCLE COLLISION

	MOVE	A0,A7
	MOVE	A1,A11

	MOVE	A4,A14
	SLL	16,A14
	SRA	16,A14
	ADD	A14,A0			;ADD X OFFSET
	SRA	16,A4
	ADD	A4,A1			;ADD Z OFFSET

	callr	find_dist_quick		;FROM PUCK TO FOCI 1

	MOVE	A7,A0
	MOVE	A11,A1

	MOVE	A4,A7			;SAVE DISTANCE TO FOCI 1

	MOVE	*A8(ODT_FOCIOFF0),A4,L

	MOVE	A4,A14
	SLL	16,A14
	SRA	16,A14
	ADD	A14,A0			;ADD X OFFSET
	SRA	16,A4
	ADD	A4,A1			;ADD Z OFFSET

	callr	find_dist_quick		;FROM PUCK TO FOCI 0

	CMP	A7,A4
	JRLE	NG_SET_DIST		;BR=DISTANCE TO FOCI 0 SHORTER
	MOVE	A7,A4			;DISTANCE TO FOCI 1 SHORTER 
	JRUC	NG_SET_DIST
NB_GET_DIST
	callr	find_dist_quick
NG_SET_DIST
	move	a4,*a6(POF_D_PUCK),W
nbnpk	add	a5,a6
	dsj	a10,nbnp1
	rets

find_dist_quick
	sub	a2,a0
	abs	a0
	sub	a3,a1
	abs	a1
	cmp	a1,a0
	jrls	fdq1
fdq0	srl	1,a1
	move	a1,a4
	add	a0,a4
	rets
fdq1	srl	1,a0
	move	a0,a4
	add	a1,a4
	rets

pwmst
	.long	PLAYER_1_BLOCK+POF_OBJECT,PLAYER_2_BLOCK+POF_OBJECT,PLAYER_2_BLOCK+POF_D_1P,PLAYER_1_BLOCK+POF_D_2P
	.long	PLAYER_1_BLOCK+POF_OBJECT,PLAYER_4_BLOCK+POF_OBJECT,PLAYER_4_BLOCK+POF_D_1P,PLAYER_1_BLOCK+POF_D_4P
	.long	PLAYER_1_BLOCK+POF_OBJECT,PLAYER_5_BLOCK+POF_OBJECT,PLAYER_5_BLOCK+POF_D_1P,PLAYER_1_BLOCK+POF_D_5P
	.long	PLAYER_1_BLOCK+POF_OBJECT,PLAYER_6_BLOCK+POF_OBJECT,PLAYER_6_BLOCK+POF_D_1P,PLAYER_1_BLOCK+POF_D_6P
	.long	PLAYER_1_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_D_1P,PLAYER_1_BLOCK+POF_D_8P
	.long	PLAYER_2_BLOCK+POF_OBJECT,PLAYER_4_BLOCK+POF_OBJECT,PLAYER_4_BLOCK+POF_D_2P,PLAYER_2_BLOCK+POF_D_4P
	.long	PLAYER_2_BLOCK+POF_OBJECT,PLAYER_5_BLOCK+POF_OBJECT,PLAYER_5_BLOCK+POF_D_2P,PLAYER_2_BLOCK+POF_D_5P
	.long	PLAYER_2_BLOCK+POF_OBJECT,PLAYER_6_BLOCK+POF_OBJECT,PLAYER_6_BLOCK+POF_D_2P,PLAYER_2_BLOCK+POF_D_6P
	.long	PLAYER_2_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_D_2P,PLAYER_2_BLOCK+POF_D_8P
	.long	PLAYER_4_BLOCK+POF_OBJECT,PLAYER_5_BLOCK+POF_OBJECT,PLAYER_5_BLOCK+POF_D_4P,PLAYER_4_BLOCK+POF_D_5P
	.long	PLAYER_4_BLOCK+POF_OBJECT,PLAYER_6_BLOCK+POF_OBJECT,PLAYER_6_BLOCK+POF_D_4P,PLAYER_4_BLOCK+POF_D_6P
	.long	PLAYER_4_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_D_4P,PLAYER_4_BLOCK+POF_D_8P
	.long	PLAYER_5_BLOCK+POF_OBJECT,PLAYER_6_BLOCK+POF_OBJECT,PLAYER_6_BLOCK+POF_D_5P,PLAYER_5_BLOCK+POF_D_6P
	.long	PLAYER_5_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_D_5P,PLAYER_5_BLOCK+POF_D_8P
	.long	PLAYER_6_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_D_6P,PLAYER_6_BLOCK+POF_D_8P

pw_mph	movk	4,a0
;	movi	30,a9
	movi	PLAYER_4_BLOCK,a7
	movi	PLAYER_BLOCK_SIZE,a10
	movi	POF_D_8P,a11
pwol	cmpi	3,a0
	jrz	pw_btol
	move	a7,a6
	movk	4,a1
	add	a11,a6
	MOVE	*A7(POF_D_COLL),A9,W		;COLLISION DISTANCE
pwil	cmpi	3,a1
	jrz	pw_btl
	move	*a6,a14,W
	cmp	a9,a14
	jrls	pw_sp
pw_btl	subk	16,a6
	dsjs	a1,pwil
pw_btol	sub	a10,a7
	dsjs	a0,pwol
	rets

pw_sp	mmtm	sp,a0,a1,a6,a7,a9,a10,a11
	move	*a7(POF_OBJECT),a9,L
	move	a1,a0
	addk	4,a0
	GBLOCK	a0,a6
	move	*a6(POF_OBJECT),a8,L
	move	*a9(OFLAGS),a5,W		;if player is off screen, no check
	move	*a8(OFLAGS),a14,W		;if player is off screen, no check
	or	a14,a5
	btst	B_OFSCRN,a5
	jrnz	pw8
	move	*a6(POF_CONTROLLED),a14,L
	jrz	pwspr
	cmp	a14,a9
	jrz	pw8			;attached player, no spread
pwspr	move	*a7(POF_CONTROLLED),a14,L
	jrz	pwspr2
	cmp	a14,a8
	jrz	pw8
pwspr2	move	*a7(POF_FLAGS),a5,W
	move	*a6(POF_FLAGS),a14,W
	or	a14,a5
	btst	B_PF_HIGHER,a5
	jrnz	pw8
	btst	B_PF_CELEBRATE,a5
	jrnz	pw8
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	MOVE	A2,B2				;STORE A8 ANIMP POSITION
	MOVE	A3,B3
	MOVE	*A8(ODT_FOCIOFF0),A14,L		;ADD AVERAGE OF OFFSETS TO VALS
	MOVE	*A8(ODT_FOCIOFF1),A1,L
	ADDXY	A14,A1
	MOVE	A1,A14
	SLL	16,A14
	SRA	1,A14
	ADD	A14,A2				;X CENTER
	SRA	16,A1
	SLL	15,A1
	ADD	A1,A3				;Z CENTER
	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
	MOVE	A0,B0				;STORE A9 ANIMP POSITION
	MOVE	A1,B1
	MOVE	*A9(ODT_FOCIOFF0),A14,L		;ADD AVERAGE OF OFFSETS TO VALS
	MOVE	*A9(ODT_FOCIOFF1),A6,L
	ADDXY	A14,A6
	MOVE	A6,A14
	SLL	16,A14
	SRA	1,A14
	ADD	A14,A0				;X CENTER
	SRA	16,A6
	SLL	15,A6
	ADD	A6,A1				;Z CENTER
	move	*a8(ODT_VEL),a6,L
	move	*a9(ODT_VEL),a14,L
	move	*a8(ODT_PBK),a10,L
	cmpi	PLAYER_8_BLOCK,a10
	jrz	pwa8e
	cmpi	PLAYER_4_BLOCK,a7
	jrz	pwa8f
	cmp	a6,a14
	jrlo	pwa8f		;pick our swap
	jrhi	pwa8e		; on our lowest speed guy
	move	@WAVEIRQS,a14,W	;just get low bits (we are equal, do we swap)
	sra	1,a14
	jrc	pwa8f
pwa8e	SWAP	a8,a9
	SWAP	a0,a2
	SWAP	a1,a3
	SWAP	B0,B2				;SWAP ANIMP POSITIONS
	SWAP	B1,B3
pwa8f	MOVE	A0,B4				;STORE A9(A8) CENTER POSITION
	MOVE	A1,B5
	calla	find_dir_to_point
	move	*a8(ODT_DIR),a1,L
	sub	a0,a1
	THETA_H	a1
	abs	a1
	cmpi	XD0900,a1
	jrhs	pw8
	calla	dir_to_182
	sra	1,a0
	sll	5,a0
	addi	fddtab,a0
	move	*a0,a0,L
	call	a0
	move	*a8(ODT_DIR),a0,L
	move	*a9(ODT_DIR),a14,L
	sub	a0,a14
	THETA_H	a14
	abs	a14
	move	*a9(ODT_VEL),a0,L	;get slower guys vel
	cmpi	XD0900,a14		;are we going in same general
	jrls	pwss5
	clr	a0
pwss5	move	a0,*a8(ODT_VEL),L
	move	*a8(ODT_PBK),a6,L
	movk	1,a0
	move	a0,*a6(POF_DRONEC),W
pw8	mmfm	sp,a0,a1,a6,a7,a9,a10,a11
	jruc	pw_btl

fddtab	.long	split_vertical_down
	.long	split_horizontal_right
	.long	split_vertical_up
	.long	split_horizontal_left

split_vertical_up
	MOVE	B3,A3				;GET ANIMP Z POSITION
	subi	[5,0],a3
	jruc	svu1
split_vertical_down
	MOVE	B3,A3				;GET ANIMP Z POSITION
	addi	[5,0],a3
svu1	move	a3,*a8(OZVAL),L
;	move	*a9(OXVAL),a14,L
	MOVE	B4,A14				;GET CENTER X POSITION
	cmp	a14,a2
	jrlt	svl
	jrgt	svr
	move	@WAVEIRQS,a14,W
	sra	1,a14
	jrc	svl
svr	MOVE	B2,A2				;GET ANIMP X POSITION
	addi	[2,08000h],a2
	jruc	svv1
svl	MOVE	B2,A2				;GET ANIMP X POSITION
	subi	[2,08000h],a2
svv1	move	a2,*a8(OXVAL),L
	rets

split_horizontal_right
	MOVE	B2,A2				;GET ANIMP X POSITION
	subi	[5,0],a2
	jruc	shr1
split_horizontal_left
	MOVE	B2,A2				;GET ANIMP X POSITION
	addi	[5,0],a2
shr1	move	a2,*a8(OXVAL),L
;	move	*a9(OZVAL),a14,L
	MOVE	B5,A14				;GET CENTER Z POSITION
	cmp	a14,a3
	jrlt	shd
	jrgt	shu
	move	@WAVEIRQS,a14,W
	sra	1,a14
	jrc	shd
shu	MOVE	B3,A3				;GET ANIMP Z POSITION
	addi	[2,08000h],a3
	jruc	shh1
shd	MOVE	B3,A3				;GET ANIMP Z POSITION
	subi	[2,08000h],a3
shh1	move	a3,*a8(OZVAL),L
	rets

fix_curplyrs
	clr	a3
	move	@PLAYER_BITS,a1,W
	movk	4,a2
fc1	srl	1,a1
	jrnc	fc2
	inc	a3
fc2	dsjs	a2,fc1
	move	a3,@CURPLYRS
	move	@PLAYER_BITS,a7
	movi	dpl_lst,a9
	movk	4,a5
	movk	3,a4
fh6	move	*a9+,a6,L
	move	*a6(POF_FLAGS),a14,W
	andni	M_PF_HUMAN,a14
	btst	a4,a7
	jrz	fh5
	ori	M_PF_HUMAN,a14
fh5	move	a14,*a6(POF_FLAGS),W
	dec	a4
	dsjs	a5,fh6
	jauc	maybe_set_drone_levels

dpl_lst	.long	PLAYER_6_BLOCK
	.long	PLAYER_5_BLOCK
	.long	PLAYER_2_BLOCK
	.long	PLAYER_1_BLOCK

check_for_player
	mmtm	sp,a0,a1
	move	@PLAYER_BITS,a1,W
	sll	4,a0
	addi	sp2_tof-16,a0
	move	*a0,a0,W
	btst	a0,a1
	jrz	cfp_0
	mmfm	sp,a0,a1
	setc
	rets
cfp_0	mmfm	sp,a0,a1
	clrc
	rets

sp2_tof	.word	0,1,1,1,2,3,3,3

big_fire_inc
	callr	small_fire_inc
small_fire_inc
	move	@side_brightness,a14,W
	inc	a14
	cmpi	3,a14
	jrhi	bfi_gt
	move	a14,@side_brightness,W
bfi_gt	C_A_K	PID_SIDE_BRIGHT,sb_1
	rets

sb_1	calla	fix_palette_lights
	SLEEP	2
	move	@side_brightness,a14,W
	dec	a14
	jrn	sb_9
	move	a14,@side_brightness,W
	jruc	sb_1
sb_9	calla	fix_palette_lights
	jauc	SUCIDE

create_rink
	clr	a0
	move	a0,@world_mt_point,W
	move	a0,@WORLDX,L
	movi	T2BP,a0
	move	@DARK_RINK,a14,W
	jrnz	crrr1
	movi	npal_0,a0	;34
	move	@period,a14,W
	cmpi	4,a14
	jrnz	crrr1
	movi	npal_109,a0
crrr1	calla	GETFPAL
	move	a0,@rinkpal,W
	movk	1,a0
	move	a0,@rink_on,W
	movi	rpallist,a0
	move	a0,@rinkpallist,L
	calla	init_timer_dma
	calla	create_goals
	callr	create_edge
	jruc	fix_palette_lights
fix_palette_lights_off
	mmtm	sp,a0,a1,a8
	clr	a0
	jruc	fpl8
fix_palette_lights
	mmtm	sp,a0,a1,a8
	move	@period,a14,W
	cmpi	4,a14
	jrnz	fpl_rg
	movk	ADJPAYOT,a0
	calla	GET_ADJ
	jrnz	fpl_rg			;not sudden death
	movk	3,a0
	move	@scored_by,a14,W
	jrnz	fpl8			;on sudden death goal, both lights
fpl_rg	clr	a0
	move	@scored_by,a14,W
	jrz	fpl1
	movk	1,a0
fpl1	move	@minutes,a14,L		;minutes and tenseconds
	jrnz	fpl8
	move	@seconds,a14,L		;seconds and tenths
	jrnz	fpl8
	addk	2,a0
fpl8	sll	5,a0

	move	@side_brightness,a14,W
	sll	5,a14
	addi	allcrplst,a14
	move	*a14,a14,L
	add	a14,a0
;	addi	crplst,a0

	move	*a0,a0,L
	move	a0,a1
	move	@ledge_object,a8,L
	calla	CHANGE_PAL
	move	a1,a0
	move	@redge_object,a8,L
	calla	CHANGE_PAL
	mmfm	sp,a0,a1,a8
	rets

allcrplst
	.long	crplst
	.long	cpalst
	.long	cpblst
	.long	cpclst

crplst	.long	ALLBORD5
	.long	ALLBORD2
	.long	ALLBORD4
	.long	ALLBORD3

cpalst
	.long	BFLASHa5
	.long	BFLASHa2
	.long	BFLASHa4
	.long	BFLASHa3
cpblst
	.long	BFLASHb5
	.long	BFLASHb2
	.long	BFLASHb4
	.long	BFLASHb3
cpclst
	.long	BFLASHc5
	.long	BFLASHc2
	.long	BFLASHc4
	.long	BFLASHc3

create_goals
	movi	lgoalF_init,b0			;MAKE FRONT PART OF LEFT GOAL
	calla	EASYMAKE
	move	a8,@lgoalF_object,L
	MOVE	A8,A2
	movi	lgoalR_init,b0			;MAKE REAR PART OF LEFT GOAL
	calla	EASYMAKE
	move	a8,@lgoalR_object,L
	MOVE	A2,*A8(OFRONT_OBJ),L
;	MOVI	[4,10],A14
;	MOVE	A14,*A8(OFRONT_OFFSET),L
	movi	rgoalF_init,b0			;MAKE FRONT PART OF RIGHT GOAL
	calla	EASYMAKE
	move	a8,@rgoalF_object,L
	MOVE	A8,A2
	movi	rgoalR_init,b0			;MAKE REAR PART OF RIGHT GOAL
	calla	EASYMAKE
	move	a8,@rgoalR_object,L
	MOVE	A2,*A8(OFRONT_OBJ),L
;	MOVI	[4,-10],A14
;	MOVE	A14,*A8(OFRONT_OFFSET),L
	rets

lgoalF_init
	.long	goal5a
;	.word	DMAWNZ,M_NOSCALE|M_NOVEL
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_GOAL
	.long	-02AD0000H,0,01220000H

lgoalR_init
	.long	goal5b
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_RGOAL
	.long	[0,0],[0,0],01800000H

rgoalF_init
	.long	goal5a
;	.word	DMAWNZ|DMAHFL,M_NOSCALE|M_NOVEL
	.word	DMAWNZ|DMAHFL,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_GOAL
	.long	02AD0000H,0,01220000H

rgoalR_init
	.long	goal5b
	.word	DMAWNZ|DMAHFL,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_RGOAL
	.long	[0,0],[0,0],01800000H

create_edge
	movi	ledge_init,b0
	calla	EASYMAKE
	move	a8,@ledge_object,L
	movi	ledge2_init,b0
	calla	EASYMAKE
	move	a8,@ledge2_object,L
	calla	init_board_script
	movi	redge_init,b0
	calla	EASYMAKE
	move	a8,@redge_object,L
	movi	redge2_init,b0
	calla	EASYMAKE
	move	a8,@redge2_object,L
	calla	init_board_script
	movi	DSIDEB28,a14
	move	a14,@edge_28_piece,L
	clr	a2
	move	a2,@back_wall_script,L
	move	a2,@edge_28_script,L
	movk	17,a3
cbk1	movi	board_init_list,a9
cbw	move	*a9+,a0,L
	jrz	cbk1
	move	a0,b0
	calla	EASYMAKE
	move	*a9+,a0,L
	jrz	cbwnp
	move	*a0,a0,L
	jrz	cbwnp
	calla	CHANGE_PAL
cbwnp	movi	OID_BACKWALL,a0
	move	a0,*a8(OID),W
	movi	-5,a0
	move	a0,*a8(OYPOS),W
	movi	680+2350,a0,W
	move	a0,*a8(OZPOS),W
	move	a2,*a8(OXPOS),W
	calla	INSERT_SCREEN_OBJ_noani
	dsjs	a3,cbw
	rets

board_init_list
	.long	b17init,0
	.long	b16init,0
	.long	b15init,0
	.long	b14init,0
	.long	b13init,0
	.long	b12init,0
	.long	b11init,teampal2
	.long	b10init,teampal2
	.long	b9init,teampal2
	.long	b8init,teampal1
	.long	b7init,teampal1
	.long	b6init,teampal1
	.long	b5init,0
	.long	b4init,0
	.long	b3init,0
	.long	b2init,0
	.long	b1init,0
	.long	0

b1init	.long	CSECS01
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b2init	.long	CSECS02
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b3init	.long	CSECS03
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b4init	.long	CSECS04
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b5init	.long	CSECS05
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b6init	.long	CSECS06c
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b7init	.long	CSECS07c
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b8init	.long	CSECS08c
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b9init	.long	CSECS09c
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b10init	.long	CSECS010c
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b11init	.long	CSECS011c
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b12init	.long	CSECS12
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b13init	.long	CSECS13
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b14init	.long	CSECS14
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b15init	.long	CSECS15
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b16init	.long	CSECS16
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0
b17init	.long	CSECS17
	.word	DMAWNZ,M_NOSCALE|M_NOVEL|M_SCRNOBJ,0

;-was here

ledge_init
	.long	DSIDEB28
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT|M_NOVEL
	.word	OID_EDGE
	.long	[-798+radius-6,0],[0,0],[2350+679,0]

redge_init
	.long	DSIDEB28
	.word	DMAWNZ|DMAHFL,M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_EDGE
	.long	[798-radius+6,0],[0,0],[2350+679,0]

ledge2_init
	.long	PLEXIB01
	.word	DMAWNZ,M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_EDGE
	.long	[-798+radius,0],[0,0],[0,0]

redge2_init
	.long	PLEXIB01
	.word	DMAWNZ|DMAHFL,M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_EDGE
	.long	[798-radius,0],[0,0],[0,0]

set_world_point
	move	@PUCK_MODE,a0,W
	cmpi	PUM_FACE,a0			;face off?
	jrnz	rwps_u
	clr	a1
	jruc	rwfx			;freeze world during face off
rwps_u	move	@PUCK_CONTROL,a0,W
	jrnz	rwpsp
	move	@PUCK_MODE,a14,W
	cmpi	PUM_PASS,a14
	jrz	rpuh1
	cmpi	PUM_TPASS,a14
	jrnz	rwpsk
rpuh1	move	@PUCK_INTENDED,a0,W
	jrz	rwpsk
;
	GBLOCK	a0,a6
	move	*a6(POF_OBJECT),a8,L
	move	*a8(OXPOS),a1,W
	move	@PUCK_OBJECT,a3,L
	move	*a3(OXPOS),a2,W
	move	a2,a14
	sub	a1,a14
	abs	a14
	cmpi	50,a14
	jrhi	rwpsk
	move	*a3(ODT_XDEST),a2,L
	addi	08000h,a2
	sra	16,a2
	sub	a1,a2		;puck x - player x
	move	*a3(OXVEL),a14,L
	jrn	sgrt1
	neg	a2
sgrt1	move	a2,a2
	jrn	rwpsp
;
rwpsk	move	@PUCK_OBJECT,a8,L
	move	@puck_op,a0,W
	jrz	rwps6
awm5	jruc	rwm5
rwpsk1	clr	a0		;a0 = 0; no team
	jruc	rwps6
rwpsp	cmpi	4,a0
	jrz	rwpsk
	cmpi	8,a0
	jrz	rwpsk1
	GBLOCK	a0,a6
	move	*a6(POF_OBJECT),a8,L
	dec	a0
	srl	2,a0
	sll	1,a0
	dec	a0		;a0 = -1,1 - team
rwm5	move	a0,@puck_op,W
	move	*a8(OZPOS),a14,W
	srl	2,a14		;new osctab
	sll	5,a14


;here we check to see where other humans are
; no humans behind us - use zscale_100_100_table
; humans behind us
;  we are drone - use zscale_200_200_table
;  we are human - use zscale_160_130_table
	movi	zscale_100_100_table,a1		;a1 is our scale table to add to
	callr	is_human_behind_puck		;returns a6 as puck player (if one, cc if none)
	jrnc	aaa_a1
	movi	zscale_200_200_table,a1		;200_200
	move	*a6(POF_FLAGS),a2,W
	btst	B_PF_HUMAN,a2
	jrz	aaa_a1
	movi	zscale_160_130_table,a1

aaa_a1	add	a1,a14
;	addi	zscale_160_130_table,a14

	move	*a14,a14,W
	sll	15,a14

;USE THIS TO REVERSE SCROLL!
;	.if	DEBUG
;	neg	a14
;	.endif

	move	a0,a0
	jrn	rwps7
	neg	a14
rwps7	move	a14,a0		;a0 = desired world point offset
rwps6	move	@PUCK_MODE,a14,W
	cmpi	PUM_FACEOFF,a14
	jrz	go_quick
	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrnz	go_quick_onscreen
gqabort	move	*a8(OXVEL),a3,L	;a3 = desired end velocity
	move	@WORLDX,a1,L
	move	a1,a5		;save our worldx for later
	move	*a8(OXVAL),a2,L
	move	@last_wp_oxval,a14,L
	move	a2,@last_wp_oxval,L
	sub	a2,a14
	neg	a14
	move	a14,b0		;check our vel with delta
	move	a3,b1
	abs	b0
	abs	b1
	cmp	b0,b1
	jrls	grgo1
	move	a14,a3		;use our delta instead of our vel (we bumped into somebody)
grgo1	sub	a2,a1		;a1 = current world offset point
	cmp	a1,a0
	jrlt	glft		;br = going to left
grght	move	a3,a4
	jrp	grh1
	clr	a4
	jruc	grh11
grh1	nop
grh11	sll	2,a4
	cmpi	[575,0],a5
	jrlt	grh12
	addi	[100,0],a4	;if we are all the way to right, then let our world point offset freely move to right
grh12	addi	[12,0],a4
	add	a4,a1
	cmp	a0,a1
	jrle	grh2		;br = we haven't passed our world point offset destination yet
	move	a0,a1
grh2	jruc	glp		;a1 = resulting world point offset
glft	move	a3,a4
	jrn	glf1
	clr	a4
	jruc	glf11
glf1	nop
glf11	sll	2,a4
	cmpi	[-575,0],a5
	jrgt	glf12
	subi	[100,0],a4	;if we all the way to left, then let our world point offset freely move to left
glf12	subi	[12,0],a4
	add	a4,a1
	cmp	a0,a1
	jrge	glp		;br = we haven't passed our world point offset destination yet
	move	a0,a1
glp	add	a2,a1		;add x value to world point offset = scroll to here
	sub	a5,a1		;a1 = distance we are from world point
	sra	3,a1
	add	a3,a1		;a1 = our new scroll x unless we are too far
rwfx	move	@WORLDX,a0,L
	add	a1,a0
	cmpi	[585,0],a0
	jrle	rwx2
	movi	[585,0],a0
	jruc	rwx4
rwx2	cmpi	[-585,0],a0
	jrge	rwx1
	movi	[-585,0],a0
rwx4	move	a0,@WORLDX,L
	clr	a1
rwx1	move	@WORLDX,a0,L
	subi	[585,0],a0
	neg	a0
	sra	3,a0
	move	a1,a1
	jrz	ppxx2
	jrp	ppxx1
	cmp	a0,a1
	jrle	ppxx2
	move	a0,a1
	jruc	ppxx2
ppxx1	neg	a0
	cmp	a0,a1
	jrge	ppxx2
	move	a0,a1
ppxx2	move	a1,@SCROLLX,L
	rets
go_quick_onscreen
	move	*a8(ODAGX),a1,W
	cmpi	-40,a1
	jrlt	gwoos
	cmpi	440,a1
	jrlt	gqabort
gwoos	move	@WORLDX,a0,L
	move	*a8(OXVAL),a1,L
	sub	a0,a1

	jrn	gqo1
	addi	[200,0],a1
	jruc	gqo2
gqo1	subi	[200,0],a1
gqo2	jruc	gqr4
go_quick
	move	@WORLDX,a0,L
	move	*a8(OXVAL),a1,L
	sub	a0,a1

gqr4	sra	3,a1
	cmpi	[25,0],a1
	jrle	gqrs
	movi	[25,0],a1
	jruc	gqr3
gqrs	cmpi	[-25,0],a1
	jrge	gqr3
	movi	[-25,0],a1
gqr3	move	a1,@SCROLLX,L
	rets

is_human_behind_puck		;don't use a1, a14
	move	@PUCK_CONTROL,a2,W
	jrnz	ckha
	move	@PUCK_LAST_CONTROL,a2,W
	jrnz	ckha
	move	@last_control_scroll,a2,W
	jrz	ckhynn		;we skip all if none
ckha	move	a2,@last_control_scroll,W
	GBLOCK	a2,a6
	move	*a6(POF_OBJECT),a7,L
	move	*a7(OXVAL),a7,L
	cmpi	4,a2
	jrls	ckhz
	neg	a7
ckhz	movk	1,a3
	clrc
	callr	ckhp
	callr	ckhp
	movk	5,a3
	callr	ckhp
ckhp	jrc	ckhy9
	cmp	a3,a2
	jrz	ckhyn
	GBLOCK	a3,a4
	move	*a4(POF_FLAGS),a5,W
	btst	B_PF_HUMAN,a5
	jrz	ckhyn
	move	*a4(POF_OBJECT),a5,L
	move	*a5(OXVAL),a5,L
	cmpi	4,a2
	jrls	ckhx
	neg	a5
ckhx	cmp	a7,a5
	jrlt	ckhy
ckhyn	inc	a3
ckhynn	clrc
	rets
ckhy	setc
ckhy9	rets

update_shifted_images
	MOVE	@WORLDX+010H,A0,W
	MOVE	A0,A14
	ABS	A0
	CMPI	0178H,A0
	JRLT	ggol2				;BR=DON'T UPDATE
	MOVE	A14,A14
	JRNN	USI_RIGHT			;UPDATE RIGHT SIDE

	movi	goal_x_table,a10
	CALLR	IMGS_FROM_X
	move	@hold_net_anim,a14,W
	jrnz	usi1p
	move	@lgoalF_object,a8,L		;CHANGE LEFT GOAL FRONT
	callr	ggol
usi1p	MOVE	A5,A1				;CHANGE TO REAR
	move	@lgoalR_object,a8,L		;CHANGE LEFT GOAL REAR
;	MOVE	A2,*A8(OFRONT_OFFSET),L
	callr	ggol

	movi	edge_x_table,a10
	callr	img_from_xx
	move	@ledge_object,a8,L
	callr	ggol
	move	@ledge2_object,a8,L
	jruc	bbordgo

USI_RIGHT
	movi	goal_x_table,a10
	CALLR	IMGS_FROM_X
	move	@hold_net_anim,a14,W
	jrnz	usi2p
	move	@rgoalF_object,a8,L		;CHANGE RIGHT GOAL FRONT
	callr	ggol
usi2p	MOVE	A5,A1				;CHANGE TO REAR
	move	@rgoalR_object,a8,L		;CHANGE RIGHT GOAL REAR
;	NEGX	A2
;	MOVE	A2,*A8(OFRONT_OFFSET),L
	callr	ggol

	movi	edge_x_table,a10
	callr	img_from_xx
	move	@redge_object,a8,L
	callr	ggol
	move	@redge2_object,a8,L
bbordgo	rets

ggol	move	*a8(OIMG),a3,L
	cmp	a1,a3
	jrz	ggol2
	move	*a8(OCTRL),a4,W
	jauc	maybe_ani
	jauc	ANI
ggol2	rets

IMGS_FROM_X
ISFX_1	move	*a10+,a1,L			;FRONT IMAGE
	jrz	ISFX_9
	MOVE	*A10+,A5,L			;REAR IMAGE
	move	*a10+,a3,W			;WORLD X (UPPER WORD)
;	MOVE	*A10+,A2,L			;OFFSET
	cmp	a3,a0
	jrls	ISFX_2				;BR=NOT THERE YET
	jruc	ISFX_1
ISFX_2	rets
ISFX_9	LOCKUP
	rets

img_from_xx
	move	a0,a14
	subi	376,a14
	jrn	ifxx9
	srl	3,a14
	sll	5,a14
	add	a10,a14
	move	*a14+,a1,L
	jrz	ifxx9
	move	@edge_28_piece,a1,L
ifxx9	rets

goal_x_table
	LLW	goal5a,goal5b,518
	LLW	goal4a,goal4b,534
	LLW	goal3a,goal3b,550
	LLW	goal2a,goal2b,566
	LLW	goal1a,goal1b,999
	.long	0

edge_x_table
	.long	DS01		;up to 386
	.long	DS02		;up to 394
	.long	DS03		;up to 387
	.long	DS04		;up to 395
	.long	DS05		;up to 402
	.long	DS07		;up to 410
	.long	DS07		;up to 418
	.long	DS08		;up to 426
	.long	DS10		;up to 434
	.long	DS10		;up to 442
 	.long	DSIDEB14	;up to 450
	.long	DSIDEB14	;up to 458
	.long	DSIDEB14	;up to 466
	.long	DSIDEB14	;up to 474
	.long	DSIDEB16	;up to 482
	.long	DSIDEB16	;up to 490
	.long	DSIDEB18	;up to 498
	.long	DSIDEB18	;up to 506
	.long	DSIDEB18	;up to 514		;was just 19
	.long	DSIDEB20	;up to 522
	.long	DSIDEB22	;up to 530
	.long	DSIDEB22	;up to 538
	.long	DSIDEB24	;up to 546
	.long	DSIDEB24	;up to 554
	.long	DSIDEB25	;up to 562
	.long	DSIDEB27	;up to 570
	.long	DSIDEB27	;up to 578
	.long	0		;up to 586
	.long	0		;up to 594
	.long	0		;up to 602
	.long	0		;up to 610
	.long	0		;up to 618
	.long	0		;up to 626
	.long	0		;up to 634
	.long	0		;up to 642
	.long	0		;up to 650
	.long	0		;up to 658
	.long	0		;up to 666
	.long	0		;up to 674
	.long	0		;up to 682
	.long	0		;up to 690
	.long	0		;up to 698
	.long	0		;up to 706
	.long	0		;up to 714
	.long	0		;up to 722
	.long	0		;up to 730
	.long	0		;up to 738

MY_WIPEOUT
	clr	a0
	move	a0,@SCROLLX,L
	move	a0,@SCROLLY,L
	move	a0,@rink_on,W
	calla	WIPEOUT
	movim	SCRNST_FULL,@SCRNTL,L
	movk	1,a0
	move	a0,@GAMERASE,W		;AUTO-ERASE FULL
	move	a0,@DISPLAYON,W
	subk	2,a0
	move	a0,@track_0_volume,W	;send volume codes
	move	a0,@track_1_volume,W	;next time through
	move	a0,@track_2_volume,W
	move	a0,@track_3_volume,W
	rets

my_wipeout_novideo_noprocess
	clr	a0
	move	a0,@SCROLLX,L
	move	a0,@SCROLLY,L
	calla	WIPEOUT_NOVIDEO_NOPROCESS
	subk	2,a0
	move	a0,@track_0_volume,W	;send volume codes
	move	a0,@track_1_volume,W	;next time through
	move	a0,@track_2_volume,W
	move	a0,@track_3_volume,W
	calla	kill_all_animations
	rets

MY_WIPEOUT_NOVIDEO
	clr	a0
	move	a0,@SCROLLX,L
	move	a0,@SCROLLY,L
	calla	WIPEOUT_NOVIDEO
	movim	SCRNST_FULL,@SCRNTL,L
	movk	1,a0
	move	a0,@GAMERASE,W		;AUTO-ERASE FULL
	move	a0,@DISPLAYON,W
	subk	2,a0
	move	a0,@track_0_volume,W	;send volume codes
	move	a0,@track_1_volume,W	;next time through
	move	a0,@track_2_volume,W
	move	a0,@track_3_volume,W
	calla	kill_all_animations
	rets

GAME_BUTTON_WAIT
	MOVE	@period,A1,W
	CALLA	get_period_players		;GET LAST PERIOD PLAYERS
	MOVE	A0,A1
	JRUC	BW_GO
button_wait

	.if	self_play

	RETP

	.endif

	CLR	A1				;IGNORE LAST PERIOD PLAYERS
BW_GO
	callr	brd
bw1	not	a9
	move	a9,a11		;a11 is not of old switch
	callr	brd
	and	a9,a11
	jrnz	bwx
	PUSHP	A1
	SLEEP	1
	PULLPQ	A1
	dsjs	a8,bw1
bwx	RETP

brd	move	@GAME_STATE,a0,W
	cmpi	INEPILOG,a0
	jrnz	brd2
	move	@LAST_PLAYER_BITS,a0,W	;read last player bits if in epilog (game over stats)
	jruc	brd3
brd2	move	@PLAYER_BITS,a0,W	;grab a new player bits each sleep
	OR	A1,A0
brd3	sll	5,a0

	MOVI	bw_tab,A2
	KITN	4
	JREQ	BW_ADD_TABLE			;BR=4 PLAYER KIT
	MOVI	bw_tab_2P,A2			;2 PLAYER KIT
BW_ADD_TABLE
	ADD	A2,A0

	move	*a0,a10,L
	move	@SWITCH,a9,L
	not	a9
	and	a10,a9		;just get the players we are looking for
	rets

bw_tab	.long	000000000h	;0
	.long	000000070h	;1
	.long	000007000h	;2
	.long	000007070h	;1+2
	.long	000700000h	;3
	.long	000700070h	;1+3
	.long	000707000h	;2+3
	.long	000707070h	;1+2+3
	.long	070000000h	;4
	.long	070000070h	;1+4
	.long	070007000h	;2+4
	.long	070007070h	;1+2+4
	.long	070700000h	;3+4
	.long	070700070h	;1+3+4
	.long	070707000h	;2+3+4
	.long	070707070h	;1+2+3+4

bw_tab_2P
	.long	000000000h	;0
	.long	000000070h	;1
	.long	000000000h	;2
	.long	000000070h	;1+2
	.long	000000000h	;3
	.long	000000070h	;1+3
	.long	000000000h	;2+3
	.long	000000070h	;1+2+3
	.long	000007000h	;4
	.long	000007070h	;1+4
	.long	000007000h	;2+4
	.long	000007070h	;1+2+4
	.long	000007000h	;3+4
	.long	000007070h	;1+3+4
	.long	000007000h	;2+3+4
	.long	000007070h	;1+2+3+4

button_s_wait
	.if	self_play
	RETP
	.endif
	callr	rdps
sbw1	not	a9
	move	a9,a11
	callr	rdps
	and	a9,a11
	jrnz	spx
	SLEEP	1
	dsjs	a8,sbw1
spx	RETP

**************************************************************************
*								         *
* get_button_s_mask							 *
*								         *
**************************************************************************
get_button_s_mask
rdps	move	@GAME_STATE,a0,W
	cmpi	INEPILOG,a0
	jrnz	srd2
	move	@LAST_PLAYER_BITS,a0,W	;read last player bits if in epilog (game over stats)
	jruc	srd3
srd2	move	@PLAYER_BITS,a0,W	;grab a new player bits each sleep
srd3	sll	5,a0
	addi	bw_tab,a0
	KITN	4
	jrz	srd4
	addi	bw_tab_2P-bw_tab,a0
srd4	move	*a0,a10,L
	move	@SWITCH,a9,L
	not	a9
	and	a10,a9
	move	@COINS,a14,L
	not	a14
	andi	0624h,a14
	move	a14,a0
	andi	000000f0fh,a14
	or	a14,a9		;throw some start button info into unused bits
	andi	0000000f0h,a0
	sll	12,a0
	or	a0,a9		;throw the other start button info into unused bits
	rets


**************************************************************************
*								         *
* get_period_players							 *
* 	input	a1 = period						 *
* 	output	a0 = bits for who plays (does not set player_bits)	 *
*								         *
**************************************************************************
get_period_players
	mmtm	sp,a1,a2,a3,a4,a5,a6,a7,a9
	dec	a1
	jrnn	upp_3
	clr	a1
upp_3	clr	a2
	movi	upp_dt1,a4
upp_2	move	*a4+,a3,W
	jrz	upp_4
	GBLOCK	a3,a6
	movb	*a6(POF_PERIODS_PAID),a14
	btst	a1,a14
	jrz	upp_2
	sll	4,a3
	addi	upp_dat-16,a3
	move	*a3,a3,W
	or	a3,a2
	jruc	upp_2
upp_4	move	a2,a0
	mmfm	sp,a1,a2,a3,a4,a5,a6,a7,a9
	rets

upp_dt1	.word	1,2,5,6,0
upp_dat	.word	1,2,2,2,4,8,8,8


**************************************************************************
*								         *
* update_period_players							 *
* 	input	a1 = period						 *
* 	output	PLAYER_BITS = set for period				 *
*								         *
**************************************************************************
update_period_players
	mmtm	sp,a0
	callr	get_period_players
	move	a0,@PLAYER_BITS,W
	callr	fix_curplyrs
	mmfm	sp,a0
	rets

**************************************************************************
*								         *
* can_we_add_period_player						 *
* 	input	a0 = player						 *
* 		a1 = period						 *
* 	output	c  = yes we can add period for player			 *
* 		nc = no, we can't add period				 *
*								         *
**************************************************************************
can_we_add_period_player
	mmtm	sp,a1,a6
	dec	a1
	jrnn	cwa2
	clr	a1
cwa2	cmpi	7,a1
	jrls	cwa3
	movk	7,a1
cwa3	GBLOCK	a0,a6
	movb	*a6(POF_PERIODS_PAID),a14
cwa1	btst	a1,a14
	jrz	cway
	inc	a1
	cmpi	3,a1
	jrlo	cwa1
	clrc
	mmfm	sp,a1,a6
	rets
cway	setc
	mmfm	sp,a1,a6
	rets

**************************************************************************
*								         *
* add_period_player							 *
* 	input	a0 = player						 *
* 		a1 = period						 *
*								         *
**************************************************************************
add_period_player
	mmtm	sp,a1,a2,a6
	dec	a1
	jrnn	apf2
	clr	a1
apf2	GBLOCK	a0,a6
	movb	*a6(POF_PERIODS_PAID),a14
apf1	btst	a1,a14
	jrz	apfy
	inc	a1
	cmpi	3,a1
	jrlo	apf1
	mmfm	sp,a1,a2,a6
	rets
apfy	mmtm	sp,a0
	movi	AUD_PL_PERIODS,a0
	calla	AUD1
	mmfm	sp,a0
	movk	1,a2
	sll	a1,a2
	or	a2,a14
	movb	a14,*a6(POF_PERIODS_PAID)
	mmfm	sp,a1,a2,a6
	rets

**************************************************************************
*								         *
* does_player_play							 *
* 	input	a0 = player						 *
* 		a1 = period						 *
* 	output	c  = yes, he does play					 *
*								         *
**************************************************************************
does_player_play
	mmtm	sp,a1,a2,a6
	dec	a1
	GBLOCK	a0,a6
	movb	*a6(POF_PERIODS_PAID),a14
	btst	a1,a14
	jrnz	dp1y
	clrc
	mmfm	sp,a1,a2,a6
	rets
dp1y	setc
	mmfm	sp,a1,a2,a6
	rets

**************************************************************************
*								         *
* do_we_continue_start							 *
* 	input	a0 = player						 *
* 		a1 = period						 *
* 	output	c  = continue						 *
* 		nc = start						 *
*								         *
**************************************************************************
do_we_continue_start
	mmtm	sp,a0,a1
	callr	does_player_play
	jrc	dwe9
	dec	a1
	jrn	dwe9n
	jrz	dwe9n
	callr	does_player_play
	jruc	dwe9
dwe9n	clrc
dwe9	mmfm	sp,a0,a1
	rets

**************************************************************************
*								         *
* can_we_start_player							 *
* 	input	a0 = player						 *
* 		a1 = period						 *
* 	output	c  = yes we can start					 *
* 		 is playing, or free play, ingame, inintro, inattract	 *
* 		nc = no, we can't for one of these reasons		 *
*								         *
**************************************************************************
can_we_start_player
	move	@GAME_STATE,a14
	SRL	3,A14				;SHIFT OUT SUB STATE
	SLL	3,A14
	cmpi	INGAME,a14
	jrz	cws_y
	cmpi	ININTRO,a14
	jrz	cws_y
;	cmpi	ININTRO_INITQ,a14
;	jrz	cws_y
;	cmpi	ININTRO_INITENT,a14
;	jrz	cws_y
;	cmpi	ININTRO_TEAMSEL,a14
;	jrz	cws_y
	cmpi	INAMODE,a14
	jrz	cws_y
	cmpi	INBUYIN,a14
	jrz	cws_y
	mmtm	sp,a0,a1
	calla	CHECKFREE
	mmfm	sp,a0,a1
	jrnz	cws_y
	callr	does_player_play
	jrc	cws_y
	move	@minutes,a14,W
	cmpi	4,a1
	jrhs	cwsp1		;overtime
	cmpi	2,a14
	jrlo	cws_n
	jruc	cws_y
cwsp1	move	@minutes,a14,W
	jrnz	cws_y
	move	@tenseconds,a14,W
	cmpi	3,a14		;last 30 seconds of overtime
	jrlo	cws_n
cws_y	setc
	rets
cws_n	clrc
	rets

CHECK_FULL_ON_START
	MMTM	SP,A0,A1
	MOVE	@GAME_STATE,A14,W
	SRL	3,A14
	SUBK	ININTRO >> 3,A14
	JRNZ	CFOS_NO				;BR=NOT INTRO

	MOVI    ADJCSTRT,A0
	CALLA   GET_ADJ
	MOVE	A0,A1

	MOVI    ADJFULLGAME,A0
	CALLA   GET_ADJ

	CMP	A1,A0
	JRNE	CFOS_NO				;BR=NO FULL GAME PURCHASE

	MMFM	SP,A0,A1
	SETC
	RETS
CFOS_NO
	MMFM	SP,A0,A1
	CLRC
	RETS

CHECK_FULL_ON_CONT
	MMTM	SP,A0,A1,A2,A3,A4,A6
	MOVE	@GAME_STATE,A14,W
	SRL	3,A14
	SUBK	ININTRO >> 3,A14
	JRNZ	CFOC_NO				;BR=NOT INTRO

	GBLOCK	A0,A6

	MOVI    ADJFULLGAME,A0
	CALLA   GET_ADJ
	MOVE	A0,A1

	MOVI    ADJCSTRT,A0
	CALLA   GET_ADJ
	MOVE	A0,A2

	CMP	A2,A1
	JRLT	CFOC_NO				;BR=FULL GAME TOO LOW

	MOVI    ADJCCONT,A0
	CALLA   GET_ADJ
	MOVE	A0,A3

	SLL	1,A0				;2 CONTINUES
	ADD	A2,A0				;PLUS 1 START

	CMP	A0,A1
	JRGT	CFOC_NO				;BR=FULL GAME TOO HIGH

	SUB	A2,A1				;TAKE AWAY START CREDITS

	MOVB	*A6(POF_PERIODS_PAID),A4
	BTST	1,A4
	JRZ	CFOC_CHECK			;BR=THIS IS THE FIRST CONTINUE

	SUB	A3,A1				;TAKE AWAY A CONTINUE CREDITS
CFOC_CHECK
	CMP	A1,A3
	JRLT	CFOC_NO				;BR=FULL GAME OKAY ON NEXT CONT

	CALLA	CRED_P
	CMP	A0,A1
	JRGT	CFOC_NO				;BR=NOT ENOUGH CREDITS

	CALLA	P_FULL_GAME_BALANCE

	MOVE	A4,A14
	MMFM	SP,A0,A1,A2,A3,A4,A6

	PUSH	A14
	callr	add_period_player		;1ST CONTINUE (2ND PERIOD)
	PULLQ	A14

	BTST	1,A14
	JRNZ	CFOC_YES			;BR=FULL GAME ON 2ND CONTINUE

	callr	add_period_player		;2ND CONTINUE (3RD PERIOD)
CFOC_YES
	SETC
	RETS
CFOC_NO
	MMFM	SP,A0,A1,A2,A3,A4,A6
	CLRC
	RETS

**************************************************************************
*								         *
* do_we_have_continue_credits						 *
* 	input	a0 = player						 *
* 	output	c  = yes, we have continue credits			 *
* 		nc = no, we don't					 *
*								         *
**************************************************************************
do_we_have_continue_credits
	calla	CR_CONTP
	jrhs	dwccy
	clrc
	rets
dwccy	setc
	rets

**************************************************************************
*								         *
* take_away_continue_credits						 *
* 	input	a0 = player						 *
*								         *
**************************************************************************
take_away_continue_credits
	jauc	P_CONT

**************************************************************************
*								         *
* do_we_have_start_credits						 *
* 	input	a0 = player						 *
* 	output	c  = yes, we have start credits				 *
* 		nc = no, we don't					 *
*								         *
**************************************************************************
do_we_have_start_credits
	calla	CR_STRTP
	jrhs	dwscy
	clrc
	rets
dwscy	setc
	rets

**************************************************************************
*								         *
* take_away_start_credits						 *
* 	input	a0 = player						 *
*								         *
**************************************************************************
take_away_start_credits
	jauc	P_START

**************************************************************************
*								         *
* do_start_button							 *
* 	input	a0 = player						 *
* 		a1 = period						 *
* 	output	c  = successfully started				 *
* 		nc = failed for various resaons				 *
*								         *
**************************************************************************
auto_restart
	callr	can_we_add_period_player
	jrnc	fsb9n
	callr	add_period_player
	callr	update_period_players
	setc
	rets
fsb9n	callr	update_period_players
	clrc
	rets

;	callr	can_we_add_period_player
;	jrc	fsb1				;yes, we can
;	jruc	fsb9n
;fsb1	callr	do_we_continue_start
;	jrnc	fsb2				;we need a start(not continue)
;	callr	add_period_player
;fsb5	jruc	fsb9y
;fsb2	callr	add_period_player
;fsb8	jruc	fsb9y
;fsb9n	callr	update_period_players
;	clrc
;	rets
;fsb9y	callr	update_period_players
;	setc
;	rets

do_start_button
	MOVE	*A13(PROCID),A14,W
	sll	16,a14
	srl	16,a14
	CMPI	PID_RESTART_WINNER,A14
	JREQ	auto_restart			;BR=WINNER RESTART
	callr	can_we_add_period_player
	jrc	dsb1				;yes, we can
;	filled up sound
	jruc	dsb9n
dsb1	callr	do_we_continue_start
	jrnc	dsb2				;we need a start(not continue)

	CALLR	CHECK_FULL_ON_CONT
	JRC	dsb9y				;BR=FULL GAME PURCHASED ON CONT

	callr	do_we_have_continue_credits
	jrnc	dsb3				;we don't have enough to continue
	callr	can_we_start_player
	jrnc	dsb4				;we can't start player now
	callr	take_away_continue_credits
	callr	add_period_player
dsb5	jruc	dsb9y
dsb4	;do please wait effect
	GBLOCK	a0,a14
	movk	7,a2
	movb	a2,*a14(POF_TOP_MODE)
	movk	1,a2
	move	a2,@force_buyin,W
	jruc	dsb9n
dsb3	;not enough credits effect
	jruc	dsb9n
dsb2
	callr	do_we_have_start_credits
	jrnc	dsb6				;we don't have start credits
	callr	can_we_start_player
	jrnc	dsb7				;we can't start player now
	callr	take_away_start_credits
	callr	add_period_player
	mmtm	sp,a0
	movi	AUD_PL_STARTS,a0
	calla	AUD1
	mmfm	sp,a0
	CALLR	CHECK_FULL_ON_START
	jrnc	dsb8				;no, he hasn't bought a full game yet
	callr	add_period_player
	callr	add_period_player
dsb8	jruc	dsb9y
dsb7	;do please wait effect
	GBLOCK	a0,a14
	movk	7,a2
	movb	a2,*a14(POF_TOP_MODE)
	movk	1,a2
	move	a2,@force_buyin,W
	jruc	dsb9n
dsb6	;not enough credits effect
dsb9n	callr	update_period_players
	clrc
	rets
dsb9y	callr	update_period_players

	MOVK	1,A14
	MOVE	A14,@NEWCRED,W			;FLAG "NEW" CREDIT MESSAGE

	MOVE	@GAME_STATE,A14,W
	CMPI	ININTRO_TG,A14
	JRNE	DSB9Y_DONE
	CALLA	PERIOD_PAID_SOUND
DSB9Y_DONE
	setc
	rets

; button pushed
;  can we add period player
;   n - filled up sound - end
;   y - do_we_continue/start
;     c - do we have credits to continue
;       y - can we start player(already playing or free play, or game, intro, amode)
;         y - take away continue credits
;           - add period player
;           - do add period sound
;           - does this add a whole game (adjustment)
;             y - add enough periods to full game
;               - do full game effect
;             n - don't add any extra
;         n - do please wait effect/sound
;       n - not enough credits sound
;     s - do we have credits to start
;       y - can we start player(already playing or free play)
;         y - take away start credits
;           - add period player
;           - do start player sound
;           - does this add a whole game (adjustment)
;             y - add enough periods to full game
;               - do full game effect
;             n - don't add any extra
;         n - do please wait effect/sound
;       n - not enough credits sound

**************************************************************************
*								         *
* START_HELP_WINDOWS - CREATE HELP WINDOW PROCS FOR ALL HUMAN PLAYERS	 *
* 									 *
* PASS:									 *
* NUTIN'								 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************

START_HELP_WINDOWS
	MMTM	SP,A0,A1,A2,A9

	MOVE	@PLAYER_BITS,A2,W
	CLR	A9	
SHW_LUPE
	BTST	A9,A2
	JRZ	SHW_NEXT				;BR=PLAYER NOT ACTIVE	

	CALLA	a9_to_a0
	MOVE	*A0(POF_LOCKED_CHAR),A14,W
	JRNZ	SHW_NEXT				;BR=SPECIAL CHARACTER
	MOVE	*A0(POF_CMOS),A14,W
	JRNN	SHW_NEXT				;BR=EXISTING CMOS RECORD

	CREATE	PID_HELP_WINDOW,HELP_WINDOW_PROC

	INCM	@HELP_WINDOW_COUNT,W			;ANOTHER WINDOW ADDED
SHW_NEXT
	INC	A9
	CMPI	4,A9
	JRNE	SHW_LUPE				;BR=MORE PLAYERS

	MMFM	SP,A0,A1,A2,A9
	RETS

**************************************************************************
*								         *
* HELP_WINDOW_PROC - DO THE HELP THING					 *
* 									 *
* PASS:									 *
* A9 = PLAYER NUMBER - 1						 *
*								         *
**************************************************************************

OPSWMASK	EQU	ODATA			;UHL PLAYER SWITCH MASK
OPLASTSW	EQU	ODATA+020H		;UHL LAST SWITCH
OPTIME		EQU	ODATA+040H		;UHW TIME OUT TIME

HELP_WINDOW_PROC
	JSRP	FADE_WAIT

	CALLA	a9_to_a0
	MOVE	A0,@RAMTEMP1,L
	MOVE	A9,@RAMTEMP2,L

	MOVE	A9,B0
	SLL	5,B0
	ADDI	P_HELP_WINDOW_TABLE,B0
	MOVE	*B0,B0,L
	CALLA	MULTIMAKE

	KITN	4
	JREQ	HWP_MAKE_MASK			;BR=4 PLAYER KIT
	MOVE	A9,A9
	JRZ	HWP_MAKE_MASK			;BR=PLAYER 1
	MOVK	1,A9				;PLAYER 2
HWP_MAKE_MASK
	MOVI	M_SW_S|M_SW_P|M_SW_T,A14
	SLL	3,A9
	SLL	A9,A14
	MOVE	A14,*A8(OPSWMASK),L

	MOVE	@SWITCH,A0,L
	NOT	A0
	AND	A14,A0
	MOVE	A0,*A8(OPLASTSW),L

	DIE

P_HELP_WINDOW_TABLE
	.LONG	P1_HELP_WINDOW_INIT,P2_HELP_WINDOW_INIT
	.LONG	P3_HELP_WINDOW_INIT,P4_HELP_WINDOW_INIT


NAME_YXOFF	EQU	[41,0]
ARRW_YXOFF	EQU	[85,-30]
HEAD_YXOFF	EQU	[100,23]

P1_HELP_WINDOW_INIT
	.byte	9, 0, 0, 6	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GRYBLOCKP	;IMGPAL
;	.long	INSTRBKP	;IMGPAL
	.long	HELPBK2P	;IMGPAL
	.long	GFONT10CP	;IMGPAL
	.long	LSTNME1P	;IMGPAL
	.long	arrp_pal	;IMGPAL
	.long	hp_chelio	;IMGPAL
	.word	OID_JUNK, OM_POS|OM_INSERT	;OID, GLOBAL_OPTIONS
	.long	[50,0],[100,0],-100
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	INSTRUC1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, OM_ANIM
	.LONG	INSTRCT_ANIM
	LWWWW	PLAYERN, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_CFUNC
	.long	[7,24+1]
	.LONG	C_SET_NUM_AND_PAL
	.LONG	FONT101
	.LONG	PRPTXT3P
	LWWWW	INSTRBX, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_CFUNC
	.LONG	C_CHANGE_PAL
	.LONG	PRPFRMP
	LWWWW	INSTRBK, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 1, 0
	LWWWW	PLAYERN, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_CFUNC
	.long	[0,1]
	.LONG	C_CHANGE_PAL
	.LONG	PRPTXT3P

	LWWWW	CHELIOS1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_ANIM|OM_CFUNC
	.long	NAME_YXOFF
	.LONG	TIMEOUT_ANIM	
	.LONG	C_FIX_NAME
	LWWWW	PURPLEN, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, OM_PRVANIM
	LWWWW	arrow1r, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_PRVANIM
	.long	ARRW_YXOFF
	LWWWW	F_CHELIO, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_CFUNC|OM_PRVANIM
	.long	HEAD_YXOFF
	.LONG	C_FIX_HEAD

P2_HELP_WINDOW_INIT
	.byte	9, 0, 0, 6	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GRYBLOCKP	;IMGPAL
;	.long	INSTRBKP	;IMGPAL
	.long	HELPBK2P	;IMGPAL
	.long	GFONT10CP	;IMGPAL
	.long	LSTNME1P	;IMGPAL
	.long	arrp_pal	;IMGPAL
	.long	hp_chelio	;IMGPAL
	.word	OID_JUNK, OM_POS|OM_INSERT	;OID, GLOBAL_OPTIONS
	.long	[150,0],[126,0],-100
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	INSTRUC1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, OM_ANIM
	.LONG	INSTRCT_ANIM
	LWWWW	PLAYERN, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_CFUNC
	.long	[7,24]
	.LONG	C_SET_NUM_AND_PAL
	.LONG	FONT102
	.LONG	BLUTXT3P
	LWWWW	INSTRBX, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_CFUNC
	.LONG	C_CHANGE_PAL
	.LONG	BLUFRMP
	LWWWW	INSTRBK, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 1, 0
	LWWWW	PLAYERN, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_CFUNC
	.LONG	C_CHANGE_PAL
	.LONG	BLUTXT3P

	LWWWW	CHELIOS1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_ANIM|OM_CFUNC
	.long	NAME_YXOFF
	.LONG	TIMEOUT_ANIM	
	.LONG	C_FIX_NAME
	LWWWW	BLUEN, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, OM_PRVANIM
	LWWWW	arrow2r, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_PRVANIM
	.long	ARRW_YXOFF
	LWWWW	F_CHELIO, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_CFUNC|OM_PRVANIM
	.long	HEAD_YXOFF
	.LONG	C_FIX_HEAD

P3_HELP_WINDOW_INIT
	.byte	9, 0, 0, 6	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GRYBLOCKP	;IMGPAL
;	.long	INSTRBKP	;IMGPAL
	.long	HELPBK2P	;IMGPAL
	.long	GFONT10CP	;IMGPAL
	.long	LSTNME1P	;IMGPAL
	.long	arrp_pal	;IMGPAL
	.long	hp_chelio	;IMGPAL
	.word	OID_JUNK, OM_POS|OM_INSERT	;OID, GLOBAL_OPTIONS
	.long	[250,0],[126,0],-100
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	INSTRUC1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, OM_ANIM
	.LONG	INSTRCT_ANIM
	LWWWW	PLAYERN, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_CFUNC
	.long	[7,24]
	.LONG	C_SET_NUM_AND_PAL
	.LONG	FONT103
	.LONG	GLDTXT1P
	LWWWW	INSTRBX, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_CFUNC
	.LONG	C_CHANGE_PAL
	.LONG	GLDFRMP
	LWWWW	INSTRBK, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 1, 0
	LWWWW	PLAYERN, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_CFUNC
	.LONG	C_CHANGE_PAL
	.LONG	GLDTXT1P

	LWWWW	CHELIOS1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_ANIM|OM_CFUNC
	.long	NAME_YXOFF
	.LONG	TIMEOUT_ANIM	
	.LONG	C_FIX_NAME
	LWWWW	YELLOWN, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, OM_PRVANIM
	LWWWW	arrow3r, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_PRVANIM
	.long	ARRW_YXOFF
	LWWWW	F_CHELIO, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_CFUNC|OM_PRVANIM
	.long	HEAD_YXOFF
	.LONG	C_FIX_HEAD

P4_HELP_WINDOW_INIT
	.byte	9, 0, 0, 6	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GRYBLOCKP	;IMGPAL
;	.long	INSTRBKP	;IMGPAL
	.long	HELPBK2P	;IMGPAL
	.long	GFONT10CP	;IMGPAL
	.long	LSTNME1P	;IMGPAL
	.long	arrp_pal	;IMGPAL
	.long	hp_chelio	;IMGPAL
	.word	OID_JUNK, OM_POS|OM_INSERT	;OID, GLOBAL_OPTIONS
	.long	[350,0],[100,0],-100
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	INSTRUC1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, OM_ANIM
	.LONG	INSTRCT_ANIM
	LWWWW	PLAYERN, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_CFUNC
	.long	[7,24]
	.LONG	C_SET_NUM_AND_PAL
	.LONG	FONT104
	.LONG	GRNTXT3P
	LWWWW	INSTRBX, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_CFUNC
	.LONG	C_CHANGE_PAL
	.LONG	GRNFRMP
	LWWWW	INSTRBK, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 1, 0
	LWWWW	PLAYERN, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_CFUNC
	.LONG	C_CHANGE_PAL
	.LONG	GRNTXT3P

	LWWWW	CHELIOS1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_ANIM|OM_CFUNC
	.long	NAME_YXOFF
	.LONG	TIMEOUT_ANIM	
	.LONG	C_FIX_NAME
	LWWWW	GREENN, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, OM_PRVANIM
	LWWWW	arrow4r, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_CFUNC|OM_PRVANIM
	.long	ARRW_YXOFF
	.LONG	C_2P_KIT
	LWWWW	F_CHELIO, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, OM_OPARTS|OM_CFUNC|OM_PRVANIM
	.long	HEAD_YXOFF
	.LONG	C_FIX_HEAD

C_2P_KIT
	KITN	4
	JREQ	C2PK_DONE			;BR=4 PLAYER KIT
	PUSH	A8
	MOVE	A0,A8
	MOVI	arrow2r,A1
	MOVI	DMAWNZ,A4
	CALLA	ANI
	PULLQ	A8
C2PK_DONE
	RETS

C_FIX_NAME
	PUSH	A8
	MOVE	A0,A8

	MOVE	@RAMTEMP1,A14,L
	MOVE	*A14(POF_CHARACTER),A14,W
	SLL	5,A14
	ADDI	player_data,A14
	MOVE	*A14,A14,L
	MOVE	*A14(TP_PLYRNAME_IMG),A1,L
	MOVI	DMAWNZ,A4
	CALLA	ANI

	PULLQ	A8
	RETS

C_FIX_HEAD
	PUSH	A8
	MOVE	A0,A8

	move	@RAMTEMP1,a14,L
	move	*a14(POF_CHARACTER),a14,W
	sll	5,a14
	addi	player_data,a14
	move	*a14,a14,L
	move	*a14(TP_HELMET_OFF),a14,L
	jrz	fzbp
	movi	[138h,100h],a14
	move	a14,*a8(OSCALE),L
fzbp
	MOVE	@RAMTEMP1,A14,L
	MOVE	*A14(POF_HEAD_TABLE),A14,L
	MOVE	*A14,A1,L
	MOVI	DMAWNZ,A4
	CALLA	ANI

	MOVE	@RAMTEMP2,A0,L
	SLL	12,A0
	ADDI	player_1_headpal_alt,A0	
	CALLA	CHANGE_PAL

	PULLQ	A8
	RETS

C_SET_NUM_AND_PAL
	PUSH	A8
	MOVE	A0,A8

	MOVE	*B0+,B14,L			;GET IMAGE
	KITN	4
	JREQ	CSNAP_GO			;BR=4 PLAYER KIT
	CMPI	FONT104,B14
	JRNE	CSNAP_GO			;BR=PLAYER 1
	MOVI	FONT102,B14			;PLAYER 2
CSNAP_GO
	MOVE	B14,A1
	MOVI	DMAWNZ,A4
	CALLA	ANI
	PULLQ	A8
	JAUC	C_CHANGE_PAL

INSTRCT_ANIM
	LW	1,5 ;30
	LWLW	1,AFUNC|1,A_SET_OPTIME+1,180-5 ;180-30
	LWL	1,AFUNC|1,A_CHECK_SWITCH

	LW	1,5 ;15
	LWLW	INSTRUC2,AFUNC|1,A_SET_OPTIME+1,180-5 ;180-15
	LWL	1,AFUNC|1,A_CHECK_SWITCH

	LW	1,5 ;15
	LWLW	INSTRUC3,AFUNC|1,A_SET_OPTIME+1,180-5 ;180-15
	LWL	1,AFUNC|1,A_CHECK_SWITCH

	LWL	1,AFUNC|1,A_KILL_WINDOW
	

TIMEOUT_ANIM
	LWL	1,AFUNC|1,A_CHECK_HEAD_WINDOW


**************************************************************************
*								         *
* A_CHECK_HEAD_WINDOW							 *
*								         *
**************************************************************************

A_CHECK_HEAD_WINDOW
	MOVE	*A8(OPART1),A0,L
	MOVE	*A0(OIMG),A14,L
	CMPI	INSTRUC1,A14
	JANE	DELETE_OBJ			;BR=PAGE CHANGED
	
	MOVE	*A8(ANIMFRM),A14,L		;STAY ON FRAME
	SUBI	020H+010H+020H,A14
	MOVE	A14,*A8(ANIMFRM),L

	RETS

**************************************************************************
*								         *
* A_KILL_WINDOW								 *
*								         *
**************************************************************************

A_KILL_WINDOW	
	DECM	@HELP_WINDOW_COUNT,W			;ANOTHER WINDOW REMOVED
	CALLA	DELETE_OBJ
	RETS

**************************************************************************
*								         *
* A_SET_OPTIME								 *
*								         *
**************************************************************************

A_SET_OPTIME
	CALLA	GETAFARG_WORD
	MOVE	A0,*A8(OPTIME),W
	RETS

**************************************************************************
*								         *
* A_CHECK_SWITCH							 *
*								         *
**************************************************************************

A_CHECK_SWITCH
	MOVE	*A8(OPSWMASK),A0,L
	MOVE	@SWITCH,A1,L
	NOT	A1
	AND	A0,A1
	JAZ	ACS_DEC				;BR=NO SWITCH

	MOVE	*A8(OPLASTSW),A2,L		
	XOR	A1,A2
	JAZ	ACS_DEC				;BR=SWITCH(ES) STUCK

	MOVE	A1,*A8(OPLASTSW),L		;SAVE LAST

	RETS
ACS_DEC
	MOVE	*A8(OPTIME),A14,W
	DEC	A14
	MOVE	A14,*A8(OPTIME),W
	JRZ	ACS_DONE			;BR=TIME OUT!

	MOVE	A1,*A8(OPLASTSW),L		;SAVE LAST

	MOVE	*A8(ANIMFRM),A14,L		;STAY ON FRAME
	SUBI	020H+010H+020H,A14
	MOVE	A14,*A8(ANIMFRM),L
ACS_DONE
	RETS

BFLASHa2:
   .word   254
   .word   00000h,07fffh,07fdeh,07fbdh,07f9ch,07b7bh,0775ah,06f18h
   .word   06af7h,066d6h,05e94h,06a91h,0396bh,0354ah,03129h,01c84h
   .word   01021h,07e39h,07e7eh,07d08h,07c00h,07e74h,07dd6h,07f99h
   .word   07f9ah,07f78h,07d86h,07ed5h,07cc6h,07dadh,07d46h,07e51h
   .word   07d49h,07e5ah,07f77h,07f58h,07ef3h,07f38h,07d27h,07defh
   .word   079d7h,07b45h,07b46h,07af1h,07b59h,07b16h,07ab2h,079ach
   .word   078a5h,078c6h,078e7h,07b5ah,07674h,07595h,075f8h,07738h
   .word   07691h,076d5h,07672h,07548h,07529h,07215h,0726dh,07270h
   .word   071cdh,07000h,070a5h,070e7h,0716bh,06c44h,06e8fh,06ef6h
   .word   06e92h,06dabh,06e10h,06a75h,06ab3h,06a4fh,06a71h,06a73h
   .word   0662dh,0660eh,06212h,05e0ch,05e0dh,05e2fh,05c20h,05c41h
   .word   05c62h,05d29h,06ed3h,058c7h,05a11h,05a51h,05988h,05a0fh
   .word   058a2h,05906h,0596bh,059ceh,059efh,055aeh,05569h,055cdh
   .word   05506h,05420h,054a5h,05508h,05109h,06a4ch,05026h,0662fh
   .word   0516eh,062afh,051abh,06acfh,059aeh,04800h,04509h,04449h
   .word   044e5h,04529h,0668dh,04085h,040a6h,04105h,04148h,04042h
   .word   040e7h,0414ah,0418ch,03ce9h,03c00h,03885h,03929h,0394ah
   .word   03443h,03509h,03528h,034a5h,030c4h,03000h,03084h,030e7h
   .word   028c6h,01c63h,01842h,07c00h,07d29h,01362h,042b3h,03e4fh
   .word   05650h,04e30h,07e40h,00c60h,00c1fh,0145fh,024beh,077beh
   .word   0355dh,06f7dh,0773ch,0419ch,0565ch,06b5ch,049bbh,05f1bh
   .word   066bah,04ddah,0417ah,0733ah,06279h,062f9h,05af9h,05677h
   .word   05ed7h,05ad7h,056d7h,04216h,06ad5h,05a96h,055d5h,05e75h
   .word   05655h,06af5h,05a95h,05a74h,045d3h,03573h,03df3h,05a13h
   .word   06273h,04a53h,051d2h,05212h,05612h,06e31h,04a52h,02a32h
   .word   04d71h,045d1h,03991h,06271h,02171h,04a11h,02591h,05e31h
   .word   05650h,0314fh,0250fh,05a4eh,03d6eh,059ceh,041aeh,049eeh
   .word   014ceh,0210eh,0256eh,024adh,0210dh,0316dh,059edh,01c6ch
   .word   0142bh,0106bh,049abh,02d4bh,0312ah,020cah,0250ah,0292ah
   .word   01488h,020c7h,01846h,01ca6h,01864h,07b6eh,07759h,05230h
   .word   07edfh,07b3bh,06676h,038ebh,03029h,0635ah,06f5ah,05a94h
   .word   05eb3h,04a52h,03e31h,05691h,02508h,020c6h

BFLASHa3:
   .word   254
   .word   00000h,07fffh,07fdeh,07fbdh,07f9ch,07b7bh,0775ah,06f18h
   .word   06af7h,066d6h,05e94h,06a91h,0396bh,0354ah,03129h,01c84h
   .word   01021h,07e39h,07e7eh,07108h,07c00h,07e74h,07dd6h,07f99h
   .word   07f9ah,07f78h,07d86h,07ed5h,07cc6h,07dadh,07d46h,07e51h
   .word   07d49h,07e5ah,07f77h,07f58h,07ef3h,07f38h,07d27h,07defh
   .word   079d7h,07b45h,07b46h,07af1h,07b59h,07b16h,07ab2h,079ach
   .word   078a5h,078c6h,078e7h,07b5ah,07674h,07595h,075f8h,07738h
   .word   07691h,076d5h,07672h,07548h,07529h,07215h,0726dh,07270h
   .word   071cdh,07000h,070a5h,070e7h,0716bh,06c44h,06e8fh,06ef6h
   .word   06e92h,06dabh,06e10h,06a75h,06ab3h,06a4fh,06a71h,06a73h
   .word   0662dh,0660eh,06212h,05e0ch,05e0dh,05e2fh,05c20h,05c41h
   .word   05c62h,05d29h,06ed3h,058c7h,05a11h,05a51h,05988h,05a0fh
   .word   058a2h,05906h,0596bh,059ceh,059efh,055aeh,05569h,055cdh
   .word   05506h,05420h,054a5h,05508h,05109h,06a4ch,05026h,0662fh
   .word   0516eh,062afh,051abh,06acfh,059aeh,04800h,04509h,04449h
   .word   044e5h,04529h,0668dh,04085h,040a6h,04105h,04148h,04042h
   .word   040e7h,0414ah,0418ch,03ce9h,03c00h,03885h,03929h,0394ah
   .word   03443h,03509h,03528h,034a5h,030c4h,03000h,03084h,030e7h
   .word   028c6h,01c63h,01842h,07cc0h,07d49h,01362h,042b3h,03e4fh
   .word   05650h,04e30h,07e20h,02be0h,00c1fh,0145fh,024beh,077beh
   .word   0355dh,06f7dh,0773ch,0419ch,0565ch,06b5ch,049bbh,05f1bh
   .word   066bah,04ddah,0417ah,0733ah,06279h,062f9h,05af9h,05677h
   .word   05ed7h,05ad7h,056d7h,04216h,06ad5h,05a96h,055d5h,05e75h
   .word   05655h,06af5h,05a95h,05a74h,045d3h,03573h,03df3h,05a13h
   .word   06273h,04a53h,051d2h,05212h,05612h,06e31h,04a52h,02a32h
   .word   04d71h,045d1h,03991h,06271h,02171h,04a11h,02591h,05e31h
   .word   05650h,0314fh,0250fh,05a4eh,03d6eh,059ceh,041aeh,049eeh
   .word   014ceh,0210eh,0256eh,024adh,0210dh,0316dh,059edh,01c6ch
   .word   0142bh,0106bh,049abh,02d4bh,0312ah,020cah,0250ah,0292ah
   .word   01488h,020c7h,01846h,01ca6h,01864h,07b6eh,07759h,05230h
   .word   07edfh,07b3bh,06676h,038ebh,03029h,0635ah,06f5ah,05a94h
   .word   05eb3h,04a52h,03e31h,05691h,02508h,020c6h

BFLASHa4:
   .word   254
   .word   00000h,07fffh,07fdeh,07fbdh,07f9ch,07b7bh,0775ah,06f18h
   .word   06af7h,066d6h,05e94h,06a91h,0396bh,0354ah,03129h,01c84h
   .word   01021h,07e39h,07e7eh,05108h,07c00h,07e74h,07dd6h,07f99h
   .word   07f9ah,07f78h,07d86h,07ed5h,07cc6h,07dadh,07d46h,07e51h
   .word   07d49h,07e5ah,07f77h,07f58h,07ef3h,07f38h,07d27h,07defh
   .word   079d7h,07b45h,07b46h,07af1h,07b59h,07b16h,07ab2h,079ach
   .word   078a5h,078c6h,078e7h,07b5ah,07674h,07595h,075f8h,07738h
   .word   07691h,076d5h,07672h,07548h,07529h,07215h,0726dh,07270h
   .word   071cdh,07000h,070a5h,070e7h,0716bh,06c44h,06e8fh,06ef6h
   .word   06e92h,06dabh,06e10h,06a75h,06ab3h,06a4fh,06a71h,06a73h
   .word   0662dh,0660eh,06212h,05e0ch,05e0dh,05e2fh,05c20h,05c41h
   .word   05c62h,05d29h,06ed3h,058c7h,05a11h,05a51h,05988h,05a0fh
   .word   058a2h,05906h,0596bh,059ceh,059efh,055aeh,05569h,055cdh
   .word   05506h,05420h,054a5h,05508h,05109h,06a4ch,05026h,0662fh
   .word   0516eh,062afh,051abh,06acfh,059aeh,04800h,04509h,04449h
   .word   044e5h,04529h,0668dh,04085h,040a6h,04105h,04148h,04042h
   .word   040e7h,0414ah,0418ch,03ce9h,03c00h,03885h,03929h,0394ah
   .word   03443h,03509h,03528h,034a5h,030c4h,03000h,03084h,030e7h
   .word   028c6h,01c63h,01842h,02800h,03929h,01362h,042b3h,03e4fh
   .word   05650h,04e30h,03800h,02be0h,00c1fh,0145fh,024beh,077beh
   .word   0355dh,06f7dh,0773ch,0419ch,0565ch,06b5ch,049bbh,05f1bh
   .word   066bah,04ddah,0417ah,0733ah,06279h,062f9h,05af9h,05677h
   .word   05ed7h,05ad7h,056d7h,04216h,06ad5h,05a96h,055d5h,05e75h
   .word   05655h,06af5h,05a95h,05a74h,045d3h,03573h,03df3h,05a13h
   .word   06273h,04a53h,051d2h,05212h,05612h,06e31h,04a52h,02a32h
   .word   04d71h,045d1h,03991h,06271h,02171h,04a11h,02591h,05e31h
   .word   05650h,0314fh,0250fh,05a4eh,03d6eh,059ceh,041aeh,049eeh
   .word   014ceh,0210eh,0256eh,024adh,0210dh,0316dh,059edh,01c6ch
   .word   0142bh,0106bh,049abh,02d4bh,0312ah,020cah,0250ah,0292ah
   .word   01488h,020c7h,01846h,01ca6h,01864h,07b6eh,07759h,05230h
   .word   07edfh,07b3bh,06676h,038ebh,03029h,0635ah,06f5ah,05a94h
   .word   05eb3h,04a52h,03e31h,05691h,02508h,020c6h

BFLASHa5:
   .word   254
   .word   00000h,07fffh,07fdeh,07fbdh,07f9ch,07b7bh,0775ah,06f18h
   .word   06af7h,066d6h,05e94h,06a91h,0396bh,0354ah,03129h,01c84h
   .word   01021h,07e39h,07e7eh,05108h,07c00h,07e74h,07dd6h,07f99h
   .word   07f9ah,07f78h,07d86h,07ed5h,07cc6h,07dadh,07d46h,07e51h
   .word   07d49h,07e5ah,07f77h,07f58h,07ef3h,07f38h,07d27h,07defh
   .word   079d7h,07b45h,07b46h,07af1h,07b59h,07b16h,07ab2h,079ach
   .word   078a5h,078c6h,078e7h,07b5ah,07674h,07595h,075f8h,07738h
   .word   07691h,076d5h,07672h,07548h,07529h,07215h,0726dh,07270h
   .word   071cdh,07000h,070a5h,070e7h,0716bh,06c44h,06e8fh,06ef6h
   .word   06e92h,06dabh,06e10h,06a75h,06ab3h,06a4fh,06a71h,06a73h
   .word   0662dh,0660eh,06212h,05e0ch,05e0dh,05e2fh,05c20h,05c41h
   .word   05c62h,05d29h,06ed3h,058c7h,05a11h,05a51h,05988h,05a0fh
   .word   058a2h,05906h,0596bh,059ceh,059efh,055aeh,05569h,055cdh
   .word   05506h,05420h,054a5h,05508h,05109h,06a4ch,05026h,0662fh
   .word   0516eh,062afh,051abh,06acfh,059aeh,04800h,04509h,04449h
   .word   044e5h,04529h,0668dh,04085h,040a6h,04105h,04148h,04042h
   .word   040e7h,0414ah,0418ch,03ce9h,03c00h,03885h,03929h,0394ah
   .word   03443h,03509h,03528h,034a5h,030c4h,03000h,03084h,030e7h
   .word   028c6h,01c63h,01842h,02800h,03929h,01362h,042b3h,03e4fh
   .word   05650h,04e30h,03800h,00c60h,00c1fh,0145fh,024beh,077beh
   .word   0355dh,06f7dh,0773ch,0419ch,0565ch,06b5ch,049bbh,05f1bh
   .word   066bah,04ddah,0417ah,0733ah,06279h,062f9h,05af9h,05677h
   .word   05ed7h,05ad7h,056d7h,04216h,06ad5h,05a96h,055d5h,05e75h
   .word   05655h,06af5h,05a95h,05a74h,045d3h,03573h,03df3h,05a13h
   .word   06273h,04a53h,051d2h,05212h,05612h,06e31h,04a52h,02a32h
   .word   04d71h,045d1h,03991h,06271h,02171h,04a11h,02591h,05e31h
   .word   05650h,0314fh,0250fh,05a4eh,03d6eh,059ceh,041aeh,049eeh
   .word   014ceh,0210eh,0256eh,024adh,0210dh,0316dh,059edh,01c6ch
   .word   0142bh,0106bh,049abh,02d4bh,0312ah,020cah,0250ah,0292ah
   .word   01488h,020c7h,01846h,01ca6h,01864h,07b6eh,07759h,05230h
   .word   07edfh,07b3bh,06676h,038ebh,03029h,0635ah,06f5ah,05a94h
   .word   05eb3h,04a52h,03e31h,05691h,02508h,020c6h

BFLASHb2:
   .word   254
   .word   00000h,07fffh,07fdeh,07fbdh,07f9ch,07b7bh,0775ah,07f98h
   .word   06af7h,07b36h,07f14h,07f11h,0498bh,0354ah,03129h,01c84h
   .word   01021h,07e39h,07e7eh,07d08h,07c00h,07e74h,07dd6h,07f99h
   .word   07f9ah,07f78h,07d86h,07ed5h,07cc6h,07dadh,07d46h,07e51h
   .word   07d49h,07e5ah,07f77h,07f58h,07ef3h,07f38h,07d27h,07defh
   .word   079d7h,07b45h,07b46h,07af1h,07b59h,07b16h,07ab2h,079ach
   .word   078a5h,078c6h,078e7h,07b5ah,07674h,07595h,075f8h,07738h
   .word   07691h,076d5h,07672h,07548h,07529h,07215h,0726dh,07270h
   .word   071cdh,07000h,070a5h,070e7h,0716bh,06c44h,06e8fh,06ef6h
   .word   06e92h,06dabh,06e10h,06a75h,06ab3h,06a4fh,06a71h,06a73h
   .word   0662dh,0660eh,06212h,05e0ch,05e0dh,05e2fh,05c20h,05c41h
   .word   05c62h,05d29h,06ed3h,058c7h,05a11h,05a51h,05988h,05a0fh
   .word   058a2h,05906h,0596bh,059ceh,059efh,055aeh,05569h,055cdh
   .word   05506h,05420h,054a5h,05508h,05109h,06e4ch,05026h,07eafh
   .word   0516eh,076cfh,051abh,0776fh,076aeh,04800h,04509h,04449h
   .word   044e5h,04529h,0668dh,04085h,040a6h,04105h,04148h,04042h
   .word   040e7h,0554ah,04dcch,03ce9h,03c00h,03885h,03929h,0394ah
   .word   03443h,03509h,03528h,034a5h,030c4h,03000h,03084h,030e7h
   .word   028c6h,01c63h,01842h,07c00h,07d29h,01362h,042b3h,03e4fh
   .word   07250h,06a50h,07d00h,00c60h,00c1fh,0145fh,024beh,077beh
   .word   0355dh,06f7dh,0773ch,0419ch,0565ch,06b5ch,049bbh,05f1bh
   .word   066bah,04ddah,0417ah,0733ah,06279h,07719h,06f39h,05677h
   .word   07b77h,07777h,06af7h,04216h,07315h,07ef6h,055d5h,05e75h
   .word   05655h,07b35h,07f15h,05a74h,045d3h,03573h,06a93h,06e53h
   .word   07ef3h,04a53h,051d2h,05212h,05a12h,07ad1h,07ab2h,02a32h
   .word   04d71h,045d1h,03991h,072d1h,02171h,04a11h,02591h,07ab1h
   .word   05650h,0314fh,0250fh,076ceh,03d6eh,06eceh,041aeh,0664eh
   .word   014ceh,0210eh,0256eh,024adh,0210dh,039cdh,07e6dh,01c6ch
   .word   0142bh,0106bh,05e0bh,02d4bh,0312ah,020cah,0250ah,0292ah
   .word   01488h,020c7h,01846h,01ca6h,01864h,07b6eh,07759h,05230h
   .word   07edfh,07b3bh,06676h,038ebh,03029h,0635ah,06f5ah,076f4h
   .word   07b33h,07712h,03e31h,07ed1h,02508h,020c6h

BFLASHb3:
   .word   254
   .word   00000h,07fffh,07fdeh,07fbdh,07f9ch,07b7bh,0775ah,07f98h
   .word   06af7h,07b36h,07f14h,07f11h,0498bh,0354ah,03129h,01c84h
   .word   01021h,07e39h,07e7eh,07d08h,07c00h,07e74h,07dd6h,07f99h
   .word   07f9ah,07f78h,07d86h,07ed5h,07cc6h,07dadh,07d46h,07e51h
   .word   07d49h,07e5ah,07f77h,07f58h,07ef3h,07f38h,07d27h,07defh
   .word   079d7h,07b45h,07b46h,07af1h,07b59h,07b16h,07ab2h,079ach
   .word   078a5h,078c6h,078e7h,07b5ah,07674h,07595h,075f8h,07738h
   .word   07691h,076d5h,07672h,07548h,07529h,07215h,0726dh,07270h
   .word   071cdh,07000h,070a5h,070e7h,0716bh,06c44h,06e8fh,06ef6h
   .word   06e92h,06dabh,06e10h,06a75h,06ab3h,06a4fh,06a71h,06a73h
   .word   0662dh,0660eh,06212h,05e0ch,05e0dh,05e2fh,05c20h,05c41h
   .word   05c62h,05d29h,06ed3h,058c7h,05a11h,05a51h,05988h,05a0fh
   .word   058a2h,05906h,0596bh,059ceh,059efh,055aeh,05569h,055cdh
   .word   05506h,05420h,054a5h,05508h,05109h,06e4ch,05026h,07eafh
   .word   0516eh,076cfh,051abh,0776fh,076aeh,04800h,04509h,04449h
   .word   044e5h,04529h,0668dh,04085h,040a6h,04105h,04148h,04042h
   .word   040e7h,0554ah,04dcch,03ce9h,03c00h,03885h,03929h,0394ah
   .word   03443h,03509h,03528h,034a5h,030c4h,03000h,03084h,030e7h
   .word   028c6h,01c63h,01842h,07c00h,07d29h,01362h,042b3h,03e4fh
   .word   07250h,06a50h,07d00h,00fe0h,00c1fh,0145fh,024beh,077beh
   .word   0355dh,06f7dh,0773ch,0419ch,0565ch,06b5ch,049bbh,05f1bh
   .word   066bah,04ddah,0417ah,0733ah,06279h,07719h,06f39h,05677h
   .word   07b77h,07777h,06af7h,04216h,07315h,07ef6h,055d5h,05e75h
   .word   05655h,07b35h,07f15h,05a74h,045d3h,03573h,06a93h,06e53h
   .word   07ef3h,04a53h,051d2h,05212h,05a12h,07ad1h,07ab2h,02a32h
   .word   04d71h,045d1h,03991h,072d1h,02171h,04a11h,02591h,07ab1h
   .word   05650h,0314fh,0250fh,076ceh,03d6eh,06eceh,041aeh,0664eh
   .word   014ceh,0210eh,0256eh,024adh,0210dh,039cdh,07e6dh,01c6ch
   .word   0142bh,0106bh,05e0bh,02d4bh,0312ah,020cah,0250ah,0292ah
   .word   01488h,020c7h,01846h,01ca6h,01864h,07b6eh,07759h,05230h
   .word   07edfh,07b3bh,06676h,038ebh,03029h,0635ah,06f5ah,076f4h
   .word   07b33h,07712h,03e31h,07ed1h,02508h,020c6h

BFLASHb4:
   .word   254
   .word   00000h,07fffh,07fdeh,07fbdh,07f9ch,07b7bh,0775ah,07f98h
   .word   06af7h,07b36h,07f14h,07f11h,0498bh,0354ah,03129h,01c84h
   .word   01021h,07e39h,07e7eh,05108h,07c00h,07e74h,07dd6h,07f99h
   .word   07f9ah,07f78h,07d86h,07ed5h,07cc6h,07dadh,07d46h,07e51h
   .word   07d49h,07e5ah,07f77h,07f58h,07ef3h,07f38h,07d27h,07defh
   .word   079d7h,07b45h,07b46h,07af1h,07b59h,07b16h,07ab2h,079ach
   .word   078a5h,078c6h,078e7h,07b5ah,07674h,07595h,075f8h,07738h
   .word   07691h,076d5h,07672h,07548h,07529h,07215h,0726dh,07270h
   .word   071cdh,07000h,070a5h,070e7h,0716bh,06c44h,06e8fh,06ef6h
   .word   06e92h,06dabh,06e10h,06a75h,06ab3h,06a4fh,06a71h,06a73h
   .word   0662dh,0660eh,06212h,05e0ch,05e0dh,05e2fh,05c20h,05c41h
   .word   05c62h,05d29h,06ed3h,058c7h,05a11h,05a51h,05988h,05a0fh
   .word   058a2h,05906h,0596bh,059ceh,059efh,055aeh,05569h,055cdh
   .word   05506h,05420h,054a5h,05508h,05109h,06e4ch,05026h,07eafh
   .word   0516eh,076cfh,051abh,0776fh,076aeh,04800h,04509h,04449h
   .word   044e5h,04529h,0668dh,04085h,040a6h,04105h,04148h,04042h
   .word   040e7h,0554ah,04dcch,03ce9h,03c00h,03885h,03929h,0394ah
   .word   03443h,03509h,03528h,034a5h,030c4h,03000h,03084h,030e7h
   .word   028c6h,01c63h,01842h,02800h,03929h,01362h,042b3h,03e4fh
   .word   07250h,06a50h,03800h,00fe0h,00c1fh,0145fh,024beh,077beh
   .word   0355dh,06f7dh,0773ch,0419ch,0565ch,06b5ch,049bbh,05f1bh
   .word   066bah,04ddah,0417ah,0733ah,06279h,07719h,06f39h,05677h
   .word   07b77h,07777h,06af7h,04216h,07315h,07ef6h,055d5h,05e75h
   .word   05655h,07b35h,07f15h,05a74h,045d3h,03573h,06a93h,06e53h
   .word   07ef3h,04a53h,051d2h,05212h,05a12h,07ad1h,07ab2h,02a32h
   .word   04d71h,045d1h,03991h,072d1h,02171h,04a11h,02591h,07ab1h
   .word   05650h,0314fh,0250fh,076ceh,03d6eh,06eceh,041aeh,0664eh
   .word   014ceh,0210eh,0256eh,024adh,0210dh,039cdh,07e6dh,01c6ch
   .word   0142bh,0106bh,05e0bh,02d4bh,0312ah,020cah,0250ah,0292ah
   .word   01488h,020c7h,01846h,01ca6h,01864h,07b6eh,07759h,05230h
   .word   07edfh,07b3bh,06676h,038ebh,03029h,0635ah,06f5ah,076f4h
   .word   07b33h,07712h,03e31h,07ed1h,02508h,020c6h

BFLASHb5:
   .word   254
   .word   00000h,07fffh,07fdeh,07fbdh,07f9ch,07b7bh,0775ah,07f98h
   .word   06af7h,07b36h,07f14h,07f11h,0498bh,0354ah,03129h,01c84h
   .word   01021h,07e39h,07e7eh,05108h,07c00h,07e74h,07dd6h,07f99h
   .word   07f9ah,07f78h,07d86h,07ed5h,07cc6h,07dadh,07d46h,07e51h
   .word   07d49h,07e5ah,07f77h,07f58h,07ef3h,07f38h,07d27h,07defh
   .word   079d7h,07b45h,07b46h,07af1h,07b59h,07b16h,07ab2h,079ach
   .word   078a5h,078c6h,078e7h,07b5ah,07674h,07595h,075f8h,07738h
   .word   07691h,076d5h,07672h,07548h,07529h,07215h,0726dh,07270h
   .word   071cdh,07000h,070a5h,070e7h,0716bh,06c44h,06e8fh,06ef6h
   .word   06e92h,06dabh,06e10h,06a75h,06ab3h,06a4fh,06a71h,06a73h
   .word   0662dh,0660eh,06212h,05e0ch,05e0dh,05e2fh,05c20h,05c41h
   .word   05c62h,05d29h,06ed3h,058c7h,05a11h,05a51h,05988h,05a0fh
   .word   058a2h,05906h,0596bh,059ceh,059efh,055aeh,05569h,055cdh
   .word   05506h,05420h,054a5h,05508h,05109h,06e4ch,05026h,07eafh
   .word   0516eh,076cfh,051abh,0776fh,076aeh,04800h,04509h,04449h
   .word   044e5h,04529h,0668dh,04085h,040a6h,04105h,04148h,04042h
   .word   040e7h,0554ah,04dcch,03ce9h,03c00h,03885h,03929h,0394ah
   .word   03443h,03509h,03528h,034a5h,030c4h,03000h,03084h,030e7h
   .word   028c6h,01c63h,01842h,02800h,03929h,01362h,042b3h,03e4fh
   .word   07250h,06a50h,03800h,00c60h,00c1fh,0145fh,024beh,077beh
   .word   0355dh,06f7dh,0773ch,0419ch,0565ch,06b5ch,049bbh,05f1bh
   .word   066bah,04ddah,0417ah,0733ah,06279h,07719h,06f39h,05677h
   .word   07b77h,07777h,06af7h,04216h,07315h,07ef6h,055d5h,05e75h
   .word   05655h,07b35h,07f15h,05a74h,045d3h,03573h,06a93h,06e53h
   .word   07ef3h,04a53h,051d2h,05212h,05a12h,07ad1h,07ab2h,02a32h
   .word   04d71h,045d1h,03991h,072d1h,02171h,04a11h,02591h,07ab1h
   .word   05650h,0314fh,0250fh,076ceh,03d6eh,06eceh,041aeh,0664eh
   .word   014ceh,0210eh,0256eh,024adh,0210dh,039cdh,07e6dh,01c6ch
   .word   0142bh,0106bh,05e0bh,02d4bh,0312ah,020cah,0250ah,0292ah
   .word   01488h,020c7h,01846h,01ca6h,01864h,07b6eh,07759h,05230h
   .word   07edfh,07b3bh,06676h,038ebh,03029h,0635ah,06f5ah,076f4h
   .word   07b33h,07712h,03e31h,07ed1h,02508h,020c6h

BFLASHc2:
   .word   254
   .word   00000h,07fffh,07fffh,07fdeh,07fbdh,07f9ch,07b7bh,07fb9h
   .word   06f18h,07f57h,07f77h,07fb6h,04dach,0396bh,0354ah,020a5h
   .word   01442h,07e5ah,07e9fh,07d29h,07c21h,07e95h,07df7h,07fbah
   .word   07fbbh,07f99h,07da7h,07ef6h,07ce7h,07dceh,07d67h,07e72h
   .word   07d8ah,07e7bh,07f98h,07f79h,07f14h,07f59h,07d48h,07e10h
   .word   07df8h,07f66h,07f67h,07f12h,07f7ah,07f37h,07ed3h,07dcdh
   .word   07cc6h,07ce7h,07d08h,07f7bh,07a95h,079b6h,07a19h,07b59h
   .word   07ab2h,07af6h,07a93h,07969h,0794ah,07636h,0768eh,07691h
   .word   075eeh,07421h,074c6h,07508h,0758ch,07065h,072b0h,07317h
   .word   072b3h,071cch,07231h,06e96h,06ed4h,06e70h,07732h,06e94h
   .word   06a4eh,06a2fh,06633h,0622dh,0622eh,076d0h,06041h,06062h
   .word   06083h,0614ah,07b78h,05ce8h,06e73h,05e72h,05da9h,05e30h
   .word   05cc3h,05d27h,06aafh,06a91h,05e10h,059cfh,0598ah,059eeh
   .word   05927h,05841h,058c6h,05929h,0552ah,07af0h,05447h,07ed0h
   .word   0558fh,07af0h,055cch,07b90h,07acfh,04c21h,0492ah,0486ah
   .word   04906h,0494ah,06aaeh,044a6h,044c7h,04526h,04569h,04463h
   .word   04508h,05e0ch,0660dh,0410ah,04021h,03ca6h,03d4ah,03d6bh
   .word   03864h,0392ah,03949h,038c6h,034e5h,03421h,034a5h,03508h
   .word   02ce7h,02084h,01c63h,07d40h,07d4ah,01783h,046d4h,04270h
   .word   07f54h,07f37h,07e60h,01081h,0103fh,0187fh,028dfh,07bdfh
   .word   0397eh,0739eh,07b5dh,045bdh,05a7dh,0739eh,04ddch,0633ch
   .word   06adbh,051fbh,0459bh,0775bh,0669ah,07b7ch,0777bh,05a98h
   .word   07f98h,07b98h,07b9bh,04637h,07fbah,07fbah,059f6h,06296h
   .word   05a76h,07f79h,07f99h,05e95h,049f4h,03994h,06eb4h,07b75h
   .word   07f97h,04e74h,055f3h,05633h,05e33h,07fb8h,07f34h,02e53h
   .word   05192h,049f2h,03db2h,07f54h,02592h,04e32h,029b2h,07f33h
   .word   06b16h,03570h,02930h,07fb3h,0418fh,07b30h,045cfh,076cfh
   .word   018efh,0252fh,0298fh,028ceh,0252eh,03deeh,07ef2h,0208dh
   .word   0184ch,0148ch,0728eh,0316ch,0354bh,024ebh,0292bh,02d4bh
   .word   018a9h,024e8h,01c67h,020c7h,01c85h,07f8fh,07b7ah,05651h
   .word   07effh,07f5ch,06a97h,03d0ch,0344ah,0677bh,0737bh,07b7ah
   .word   07f78h,07b33h,04252h,07f16h,02929h,024e7h

BFLASHc3:
   .word   254
   .word   00000h,07fffh,07fffh,07fdeh,07fbdh,07f9ch,07b7bh,07fb9h
   .word   06f18h,07f57h,07f77h,07fb6h,04dach,0396bh,0354ah,020a5h
   .word   01442h,07e5ah,07e9fh,07d29h,07c21h,07e95h,07df7h,07fbah
   .word   07fbbh,07f99h,07da7h,07ef6h,07ce7h,07dceh,07d67h,07e72h
   .word   07d8ah,07e7bh,07f98h,07f79h,07f14h,07f59h,07d48h,07e10h
   .word   07df8h,07f66h,07f67h,07f12h,07f7ah,07f37h,07ed3h,07dcdh
   .word   07cc6h,07ce7h,07d08h,07f7bh,07a95h,079b6h,07a19h,07b59h
   .word   07ab2h,07af6h,07a93h,07969h,0794ah,07636h,0768eh,07691h
   .word   075eeh,07421h,074c6h,07508h,0758ch,07065h,072b0h,07317h
   .word   072b3h,071cch,07231h,06e96h,06ed4h,06e70h,07732h,06e94h
   .word   06a4eh,06a2fh,06633h,0622dh,0622eh,076d0h,06041h,06062h
   .word   06083h,0614ah,07b78h,05ce8h,06e73h,05e72h,05da9h,05e30h
   .word   05cc3h,05d27h,06aafh,06a91h,05e10h,059cfh,0598ah,059eeh
   .word   05927h,05841h,058c6h,05929h,0552ah,07af0h,05447h,07ed0h
   .word   0558fh,07af0h,055cch,07b90h,07acfh,04c21h,0492ah,0486ah
   .word   04906h,0494ah,06aaeh,044a6h,044c7h,04526h,04569h,04463h
   .word   04508h,05e0ch,0660dh,0410ah,04021h,03ca6h,03d4ah,03d6bh
   .word   03864h,0392ah,03949h,038c6h,034e5h,03421h,034a5h,03508h
   .word   02ce7h,02084h,01c63h,07d40h,07d4ah,01783h,046d4h,04270h
   .word   07f54h,07f37h,07e60h,013e1h,0103fh,0187fh,028dfh,07bdfh
   .word   0397eh,0739eh,07b5dh,045bdh,05a7dh,0739eh,04ddch,0633ch
   .word   06adbh,051fbh,0459bh,0775bh,0669ah,07b7ch,0777bh,05a98h
   .word   07f98h,07b98h,07b9bh,04637h,07fbah,07fbah,059f6h,06296h
   .word   05a76h,07f79h,07f99h,05e95h,049f4h,03994h,06eb4h,07b75h
   .word   07f97h,04e74h,055f3h,05633h,05e33h,07fb8h,07f34h,02e53h
   .word   05192h,049f2h,03db2h,07f54h,02592h,04e32h,029b2h,07f33h
   .word   06b16h,03570h,02930h,07fb3h,0418fh,07b30h,045cfh,076cfh
   .word   018efh,0252fh,0298fh,028ceh,0252eh,03deeh,07ef2h,0208dh
   .word   0184ch,0148ch,0728eh,0316ch,0354bh,024ebh,0292bh,02d4bh
   .word   018a9h,024e8h,01c67h,020c7h,01c85h,07f8fh,07b7ah,05651h
   .word   07effh,07f5ch,06a97h,03d0ch,0344ah,0677bh,0737bh,07b7ah
   .word   07f78h,07b33h,04252h,07f16h,02929h,024e7h

BFLASHc4:
   .word   254
   .word   00000h,07fffh,07fffh,07fdeh,07fbdh,07f9ch,07b7bh,07fb9h
   .word   06f18h,07f57h,07f77h,07fb6h,04dach,0396bh,0354ah,020a5h
   .word   01442h,07e5ah,07e9fh,05529h,07c21h,07e95h,07df7h,07fbah
   .word   07fbbh,07f99h,07da7h,07ef6h,07ce7h,07dceh,07d67h,07e72h
   .word   07d8ah,07e7bh,07f98h,07f79h,07f14h,07f59h,07d48h,07e10h
   .word   07df8h,07f66h,07f67h,07f12h,07f7ah,07f37h,07ed3h,07dcdh
   .word   07cc6h,07ce7h,07d08h,07f7bh,07a95h,079b6h,07a19h,07b59h
   .word   07ab2h,07af6h,07a93h,07969h,0794ah,07636h,0768eh,07691h
   .word   075eeh,07421h,074c6h,07508h,0758ch,07065h,072b0h,07317h
   .word   072b3h,071cch,07231h,06e96h,06ed4h,06e70h,07732h,06e94h
   .word   06a4eh,06a2fh,06633h,0622dh,0622eh,076d0h,06041h,06062h
   .word   06083h,0614ah,07b78h,05ce8h,06e73h,05e72h,05da9h,05e30h
   .word   05cc3h,05d27h,06aafh,06a91h,05e10h,059cfh,0598ah,059eeh
   .word   05927h,05841h,058c6h,05929h,0552ah,07af0h,05447h,07ed0h
   .word   0558fh,07af0h,055cch,07b90h,07acfh,04c21h,0492ah,0486ah
   .word   04906h,0494ah,06aaeh,044a6h,044c7h,04526h,04569h,04463h
   .word   04508h,05e0ch,0660dh,0410ah,04021h,03ca6h,03d4ah,03d6bh
   .word   03864h,0392ah,03949h,038c6h,034e5h,03421h,034a5h,03508h
   .word   02ce7h,02084h,01c63h,02c21h,03d4ah,01783h,046d4h,04270h
   .word   07f54h,07f37h,03c21h,013e1h,0103fh,0187fh,028dfh,07bdfh
   .word   0397eh,0739eh,07b5dh,045bdh,05a7dh,0739eh,04ddch,0633ch
   .word   06adbh,051fbh,0459bh,0775bh,0669ah,07b7ch,0777bh,05a98h
   .word   07f98h,07b98h,07b9bh,04637h,07fbah,07fbah,059f6h,06296h
   .word   05a76h,07f79h,07f99h,05e95h,049f4h,03994h,06eb4h,07b75h
   .word   07f97h,04e74h,055f3h,05633h,05e33h,07fb8h,07f34h,02e53h
   .word   05192h,049f2h,03db2h,07f54h,02592h,04e32h,029b2h,07f33h
   .word   06b16h,03570h,02930h,07fb3h,0418fh,07b30h,045cfh,076cfh
   .word   018efh,0252fh,0298fh,028ceh,0252eh,03deeh,07ef2h,0208dh
   .word   0184ch,0148ch,0728eh,0316ch,0354bh,024ebh,0292bh,02d4bh
   .word   018a9h,024e8h,01c67h,020c7h,01c85h,07f8fh,07b7ah,05651h
   .word   07effh,07f5ch,06a97h,03d0ch,0344ah,0677bh,0737bh,07b7ah
   .word   07f78h,07b33h,04252h,07f16h,02929h,024e7h

BFLASHc5:
   .word   254
   .word   00000h,07fffh,07fffh,07fdeh,07fbdh,07f9ch,07b7bh,07fb9h
   .word   06f18h,07f57h,07f77h,07fb6h,04dach,0396bh,0354ah,020a5h
   .word   01442h,07e5ah,07e9fh,05529h,07c21h,07e95h,07df7h,07fbah
   .word   07fbbh,07f99h,07da7h,07ef6h,07ce7h,07dceh,07d67h,07e72h
   .word   07d8ah,07e7bh,07f98h,07f79h,07f14h,07f59h,07d48h,07e10h
   .word   07df8h,07f66h,07f67h,07f12h,07f7ah,07f37h,07ed3h,07dcdh
   .word   07cc6h,07ce7h,07d08h,07f7bh,07a95h,079b6h,07a19h,07b59h
   .word   07ab2h,07af6h,07a93h,07969h,0794ah,07636h,0768eh,07691h
   .word   075eeh,07421h,074c6h,07508h,0758ch,07065h,072b0h,07317h
   .word   072b3h,071cch,07231h,06e96h,06ed4h,06e70h,07732h,06e94h
   .word   06a4eh,06a2fh,06633h,0622dh,0622eh,076d0h,06041h,06062h
   .word   06083h,0614ah,07b78h,05ce8h,06e73h,05e72h,05da9h,05e30h
   .word   05cc3h,05d27h,06aafh,06a91h,05e10h,059cfh,0598ah,059eeh
   .word   05927h,05841h,058c6h,05929h,0552ah,07af0h,05447h,07ed0h
   .word   0558fh,07af0h,055cch,07b90h,07acfh,04c21h,0492ah,0486ah
   .word   04906h,0494ah,06aaeh,044a6h,044c7h,04526h,04569h,04463h
   .word   04508h,05e0ch,0660dh,0410ah,04021h,03ca6h,03d4ah,03d6bh
   .word   03864h,0392ah,03949h,038c6h,034e5h,03421h,034a5h,03508h
   .word   02ce7h,02084h,01c63h,02c21h,03d4ah,01783h,046d4h,04270h
   .word   07f54h,07f37h,03c21h,01081h,0103fh,0187fh,028dfh,07bdfh
   .word   0397eh,0739eh,07b5dh,045bdh,05a7dh,0739eh,04ddch,0633ch
   .word   06adbh,051fbh,0459bh,0775bh,0669ah,07b7ch,0777bh,05a98h
   .word   07f98h,07b98h,07b9bh,04637h,07fbah,07fbah,059f6h,06296h
   .word   05a76h,07f79h,07f99h,05e95h,049f4h,03994h,06eb4h,07b75h
   .word   07f97h,04e74h,055f3h,05633h,05e33h,07fb8h,07f34h,02e53h
   .word   05192h,049f2h,03db2h,07f54h,02592h,04e32h,029b2h,07f33h
   .word   06b16h,03570h,02930h,07fb3h,0418fh,07b30h,045cfh,076cfh
   .word   018efh,0252fh,0298fh,028ceh,0252eh,03deeh,07ef2h,0208dh
   .word   0184ch,0148ch,0728eh,0316ch,0354bh,024ebh,0292bh,02d4bh
   .word   018a9h,024e8h,01c67h,020c7h,01c85h,07f8fh,07b7ah,05651h
   .word   07effh,07f5ch,06a97h,03d0ch,0344ah,0677bh,0737bh,07b7ah
   .word   07f78h,07b33h,04252h,07f16h,02929h,024e7h

ALLBORD2:
   .word   254
   .word   00000h,07fffh,07bdeh,077bdh,0739ch,06f7bh,06b5ah,06318h
   .word   05ef7h,05ad6h,05294h,04631h,02d6bh,0294ah,02529h,01084h
   .word   00421h,07e39h,07e7eh,07d6dh,07c00h,07a74h,079d6h,07b99h
   .word   07b9ah,07b78h,07986h,07ad5h,078c6h,079adh,07546h,07651h
   .word   07549h,0725ah,07377h,07358h,072f3h,07338h,07127h,071efh
   .word   06dd7h,06f45h,06f46h,06ef1h,06f59h,06f16h,06eb2h,06dach
   .word   06ca5h,06cc6h,06ce7h,06f5ah,06a74h,06995h,069f8h,06b38h
   .word   06a91h,06ad5h,06a72h,06948h,06929h,06615h,0666dh,06670h
   .word   065cdh,06400h,064a5h,064e7h,0656bh,06044h,0628fh,062f6h
   .word   06292h,061abh,06210h,05e75h,05eb3h,05e4fh,05e71h,05e73h
   .word   05a2dh,05a0eh,05612h,0520ch,0520dh,0522fh,05020h,05041h
   .word   05062h,05129h,05273h,04cc7h,04e11h,04e51h,04d88h,04e0fh
   .word   04ca2h,04d06h,04d6bh,04dceh,04defh,049aeh,04969h,049cdh
   .word   04906h,04820h,048a5h,04908h,04509h,0456ch,04426h,045cfh
   .word   0456eh,0460fh,045abh,041efh,03d8eh,03c00h,03909h,03849h
   .word   038e5h,03929h,039adh,03485h,034a6h,03505h,03548h,03442h
   .word   034e7h,0354ah,0358ch,030e9h,03000h,02c85h,02d29h,02d4ah
   .word   02843h,02909h,02928h,028a5h,024c4h,02400h,02484h,024e7h
   .word   01cc6h,01063h,00c42h,07c00h,07c6ah,00762h,036b3h,0324fh
   .word   03e30h,04230h,07dc2h,00060h,0001fh,0085fh,018beh,06bbeh
   .word   0295dh,0637dh,06b3ch,0359ch,04a5ch,05f5ch,03dbbh,0531bh
   .word   05abah,041dah,0357ah,0673ah,05679h,056f9h,04ef9h,04a77h
   .word   052d7h,042b7h,04ad7h,03616h,03e76h,04296h,049d5h,05275h
   .word   04a55h,04e95h,04275h,04e74h,039d3h,02973h,02dd3h,03613h
   .word   03633h,03e53h,045d2h,04612h,025b2h,03a32h,03632h,01e32h
   .word   04171h,039d1h,02d91h,031d1h,01571h,03e11h,01991h,03611h
   .word   02dd0h,0254fh,0190fh,035cfh,0316eh,0318eh,035aeh,0296eh
   .word   008ceh,0150eh,0196eh,018adh,0150dh,0256dh,02d8dh,0106ch
   .word   0082bh,0046bh,0254bh,0214bh,0252ah,014cah,0190ah,01d2ah
   .word   00888h,014c7h,00c46h,010a6h,00c64h,06f6eh,06b59h,04630h
   .word   07edfh,06f3bh,05a76h,02cebh,02429h,0575ah,0635ah,04e94h
   .word   04673h,03e52h,03231h,04231h,01908h,014c6h

ALLBORD3:
   .word   254
   .word   00000h,07fffh,07bdeh,077bdh,0739ch,06f7bh,06b5ah,06318h
   .word   05ef7h,05ad6h,05294h,04631h,02d6bh,0294ah,02529h,01084h
   .word   00421h,07e39h,07e7eh,07d6dh,07c00h,07a74h,079d6h,07b99h
   .word   07b9ah,07b78h,07986h,07ad5h,078c6h,079adh,07546h,07651h
   .word   07549h,0725ah,07377h,07358h,072f3h,07338h,07127h,071efh
   .word   06dd7h,06f45h,06f46h,06ef1h,06f59h,06f16h,06eb2h,06dach
   .word   06ca5h,06cc6h,06ce7h,06f5ah,06a74h,06995h,069f8h,06b38h
   .word   06a91h,06ad5h,06a72h,06948h,06929h,06615h,0666dh,06670h
   .word   065cdh,06400h,064a5h,064e7h,0656bh,06044h,0628fh,062f6h
   .word   06292h,061abh,06210h,05e75h,05eb3h,05e4fh,05e71h,05e73h
   .word   05a2dh,05a0eh,05612h,0520ch,0520dh,0522fh,05020h,05041h
   .word   05062h,05129h,05273h,04cc7h,04e11h,04e51h,04d88h,04e0fh
   .word   04ca2h,04d06h,04d6bh,04dceh,04defh,049aeh,04969h,049cdh
   .word   04906h,04820h,048a5h,04908h,04509h,0456ch,04426h,045cfh
   .word   0456eh,0460fh,045abh,041efh,03d8eh,03c00h,03909h,03849h
   .word   038e5h,03929h,039adh,03485h,034a6h,03505h,03548h,03442h
   .word   034e7h,0354ah,0358ch,030e9h,03000h,02c85h,02d29h,02d4ah
   .word   02843h,02909h,02928h,028a5h,024c4h,02400h,02484h,024e7h
   .word   01cc6h,01063h,00c42h,07c00h,07c6ah,00762h,036b3h,0324fh
   .word   03e30h,04230h,07dc2h,003e0h,0001fh,0085fh,018beh,06bbeh
   .word   0295dh,0637dh,06b3ch,0359ch,04a5ch,05f5ch,03dbbh,0531bh
   .word   05abah,041dah,0357ah,0673ah,05679h,056f9h,04ef9h,04a77h
   .word   052d7h,042b7h,04ad7h,03616h,03e76h,04296h,049d5h,05275h
   .word   04a55h,04e95h,04275h,04e74h,039d3h,02973h,02dd3h,03613h
   .word   03633h,03e53h,045d2h,04612h,025b2h,03a32h,03632h,01e32h
   .word   04171h,039d1h,02d91h,031d1h,01571h,03e11h,01991h,03611h
   .word   02dd0h,0254fh,0190fh,035cfh,0316eh,0318eh,035aeh,0296eh
   .word   008ceh,0150eh,0196eh,018adh,0150dh,0256dh,02d8dh,0106ch
   .word   0082bh,0046bh,0254bh,0214bh,0252ah,014cah,0190ah,01d2ah
   .word   00888h,014c7h,00c46h,010a6h,00c64h,06f6eh,06b59h,04630h
   .word   07edfh,06f3bh,05a76h,02cebh,02429h,0575ah,0635ah,04e94h
   .word   04673h,03e52h,03231h,04231h,01908h,014c6h

ALLBORD4:
   .word   254
   .word   00000h,07fffh,07bdeh,077bdh,0739ch,06f7bh,06b5ah,06318h
   .word   05ef7h,05ad6h,05294h,04631h,02d6bh,0294ah,02529h,01084h
   .word   00421h,07e39h,07e7eh,04508h,07c00h,07a74h,079d6h,07b99h
   .word   07b9ah,07b78h,07986h,07ad5h,078c6h,079adh,07546h,07651h
   .word   07549h,0725ah,07377h,07358h,072f3h,07338h,07127h,071efh
   .word   06dd7h,06f45h,06f46h,06ef1h,06f59h,06f16h,06eb2h,06dach
   .word   06ca5h,06cc6h,06ce7h,06f5ah,06a74h,06995h,069f8h,06b38h
   .word   06a91h,06ad5h,06a72h,06948h,06929h,06615h,0666dh,06670h
   .word   065cdh,06400h,064a5h,064e7h,0656bh,06044h,0628fh,062f6h
   .word   06292h,061abh,06210h,05e75h,05eb3h,05e4fh,05e71h,05e73h
   .word   05a2dh,05a0eh,05612h,0520ch,0520dh,0522fh,05020h,05041h
   .word   05062h,05129h,05273h,04cc7h,04e11h,04e51h,04d88h,04e0fh
   .word   04ca2h,04d06h,04d6bh,04dceh,04defh,049aeh,04969h,049cdh
   .word   04906h,04820h,048a5h,04908h,04509h,0456ch,04426h,045cfh
   .word   0456eh,0460fh,045abh,041efh,03d8eh,03c00h,03909h,03849h
   .word   038e5h,03929h,039adh,03485h,034a6h,03505h,03548h,03442h
   .word   034e7h,0354ah,0358ch,030e9h,03000h,02c85h,02d29h,02d4ah
   .word   02843h,02909h,02928h,028a5h,024c4h,02400h,02484h,024e7h
   .word   01cc6h,01063h,00c42h,01c00h,02d29h,00762h,036b3h,0324fh
   .word   03e30h,04230h,02c00h,003e0h,0001fh,0085fh,018beh,06bbeh
   .word   0295dh,0637dh,06b3ch,0359ch,04a5ch,05f5ch,03dbbh,0531bh
   .word   05abah,041dah,0357ah,0673ah,05679h,056f9h,04ef9h,04a77h
   .word   052d7h,042b7h,04ad7h,03616h,03e76h,04296h,049d5h,05275h
   .word   04a55h,04e95h,04275h,04e74h,039d3h,02973h,02dd3h,03613h
   .word   03633h,03e53h,045d2h,04612h,025b2h,03a32h,03632h,01e32h
   .word   04171h,039d1h,02d91h,031d1h,01571h,03e11h,01991h,03611h
   .word   02dd0h,0254fh,0190fh,035cfh,0316eh,0318eh,035aeh,0296eh
   .word   008ceh,0150eh,0196eh,018adh,0150dh,0256dh,02d8dh,0106ch
   .word   0082bh,0046bh,0254bh,0214bh,0252ah,014cah,0190ah,01d2ah
   .word   00888h,014c7h,00c46h,010a6h,00c64h,06f6eh,06b59h,04630h
   .word   07edfh,06f3bh,05a76h,02cebh,02429h,0575ah,0635ah,04e94h
   .word   04673h,03e52h,03231h,04231h,01908h,014c6h

	.end
