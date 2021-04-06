 	.MLIB	"HHMACS.LIB"
	.FILE	"HHCONTROL.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhhigher.e"
	.include	"hhplayer.g"
	.include	"hhmath.g"
	.include	"hhproc.g"
	.include	"hhcontrl.g"
	.include	"hhgame.g"
	.include	"hhpuck.g"
	.include	"hhutil.g"
	.include	"hhshow.g"
	.include	"hhtimer.g"
	.include	"hhd.g"
	.include	"hhmisc.g"
	.include	"hh.g"
	.include	"hhselect.g"
	.include	"hhrscr.g"
	.include	"hhspeech.g"
	.include	"hhc.g"
	.include	"hhpall.g"
	.include	"hhscr_ms.g"
	.include	"hhscr_sk.g"
	.include	"hhram.g"
	.include	"hhfade.g"
	.include	"hhcontr2.g"
	.include	"hhtext.g"
	.include	"hhtg.g"
	.include	"hhscore.g"
	.include	"hhpup.g"
	.include	"hhcx.g"

; end of include files

	.bss	faceoff_x,16
	.bss	faceoff_z,16
	.bss	faceoff_1,32
	.bss	faceoff_2,32

	.bss	taps_ok,16
	.bss	tap_count1,16
	.bss	tap_count2,16

	.bss	ref_object,32
	.bss	ref_shadow,32
	.bss	faceoff_time,32		;time last drop of puck (drone signals)
	.bss	faceoff_type,16

	.bss	fangle_drone1,16
	.bss	fangle_drone5,16

**************************************************************************
*								         *
* PUCK_FROZEN - PUCK FROZEN BY A GOALIE					 *
* 									 *
* PASS:									 *
* A6 = GOALIE BLOCK							 *
* A8 = GOALIE OBJECT							 *
* 									 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************
PUCK_FROZEN
	MMTM	SP,A6,A8
	move	@minutes,a14,W
	jrnz	pf_11
	move	@tenseconds,a14,W
	jrnz	pf_11
	move	@seconds,a14
	jrz	pf_909			;no faceoff with less than 1 second
pf_11	calla	check_freeze_smotherpass
	calla	stop_timer
	movi	522,a0
	movb	*a6(POF_NUMBER),a14
	cmpi	4,a14
	jrnz	pf_1
	neg	a0
pf_1	movi	164,a1
	move	*a6(POF_OBJECT),a8,L
	MOVE	*A8(ODT_GZPOSPOSS+010h),A14,W	;Z POSITION AT TIME OF POSSESSION
	cmpi	339,a14
	jrle	pf_2
	movi	515,a1
pf_2	calla	spx_zone_faceoff
	calla	zone_faceoff_show

	MMTM	SP,A0,A1,A9
	MOVE	A6,A9
	CREATE	PID_GCARD_FREEZE,SHOW_GCARDS_FREEZE_PROC
	MMFM	SP,A0,A1,A9

	CALLR	faceoff
	calla	store_players_tired
pf_909	MMFM	SP,A6,A8
	RETS


**************************************************************************
*								         *
* faceoff								 *
* 	input	a0 = xpos of faceoff					 *
* 		a1 = zpos of faceoff					 *
*								         *
**************************************************************************
period_faceoff
	movk	1,a14
	jruc	frtr1
faceoff
	clr	a14
frtr1	move	a14,@faceoff_type,W
	clr	a14
	move	a14,@show_puck_on_fire,W
	movi	PUM_FACEOFF,a14
	move	a14,@PUCK_MODE,W	;now set puck mode to face off
	calla	clear_all_signals
	calla	reset_all_pulled_goalies
	move	a0,@faceoff_x,W
	move	a1,@faceoff_z,W
	calla	reset_puck_position
	calla	new_puck_control
;	calla	turn_puck_on
	C_O_R	PID_FACEOFF,faceoff_process
	movk	2,a14
	GBLOCK	a14,a14
	move	*a14(POF_FLAGS),a0,W
	ori	M_PF_REV_FACE,a0
	move	a0,*a14(POF_FLAGS),W
	move	@hot_goals,a14,W
	cmpi	3,a14
	jrlo	nhclr
	calla	clear_hot
nhclr	jauc	fix_palette_lights_off


faceoff_process
	movk	1,a0
	move	a0,@no_control,W
	SLEEP	1		;just long enough to let freeze process stop us
	clr	a14
	move	a14,@no_control,W
	callr	create_ref
	clr	a14
	move	a14,@taps_ok,W
	move	a14,@PUCK_CONTROL,W
	move	a14,@PUCK_LAST_CONTROL,W
	move	a14,@puck_op,W
	move	a14,@show_puck_on_fire,W
	movk	2,a14
	GBLOCK	a14,a14
	move	*a14(POF_DRONE_LEVEL),a4,W
	move	*a14(POF_S_FACE),a14,L
	move	*a14,a14,W
	cmpi	9,a4
	jrlt	fodr1
	sll	1,a14
	cmpi	10,a4
	jrlt	fodr1
	sll	1,a14
	cmpi	11,a4
	jrlt	fodr1
	sll	1,a14
	cmpi	12,a4
	jrlt	fodr1
	sll	1,a14
fodr1	move	a14,@tap_count1,W
	movk	5,a14
	GBLOCK	a14,a14
	move	*a14(POF_DRONE_LEVEL),a4,W
	move	*a14(POF_S_FACE),a14,L
	move	*a14,a14,W
	cmpi	9,a4
	jrlt	fodr2
	sll	1,a14
	cmpi	10,a4
	jrlt	fodr2
	sll	1,a14
	cmpi	11,a4
	jrlt	fodr2
	sll	1,a14
	cmpi	12,a4
	jrlt	fodr2
	sll	1,a14
fodr2	move	a14,@tap_count2,W
	calla	new_puck_control
	movi	face_off_points,a4
	move	@faceoff_z,a14,W
	cmpi	400,a14
	jrlt	rfo1
	movi	other_face_off_points,a4
rfo1	callr	move_players_to_points_ng
	JSRP	wait_for_all_control
	clr	a14			;safety
	move	a14,@no_control,W	;safety
	calla	turn_all_arrows_long
	movi	face_off_2_points,a4
	move	@faceoff_z,a14,W
	cmpi	400,a14
	jrlt	rfo134
	movi	other_face_off_2_points,a4
rfo134	callr	free_skate_players_to_points_ng
	JSRP	wait_for_stopped_ref
	clr	a14			;safety
	move	a14,@no_control,W	;safety
	callr	start_ref_faceoff
	JSRP	wait_for_all_control
	clr	a14			;safety
	move	a14,@no_control,W	;safety
;	calla	spx_faceoff_start
;	movk	1,a14
;	move	a14,@taps_ok,W
;	movi	50,a10
;revf	callr	revsub
;	SLEEP	1
;	dsjs	a10,revf

	MOVE	@GAME_STATE,A14,W
	CMPI	INAMODE,A14
	JREQ	FP_DROP				;BR=IN ATTRACT MODE

	MOVE	@SHOW_START_SHIT,A14,W
	JRZ	FP_DROP				;BR=DON'T DO IT

	CLR	A14
	MOVE	A14,@SHOW_START_SHIT,W	;DON'T EVER LET THIS HAPPEN AGAIN

	clr	a14			;safety
	move	a14,@no_control,W	;safety

	MOVK	8,A14
	MOVE	A14,@SLIDE_OFF_COUNT,W		;START GRAPHICS SLIDIN'

FP_SLIDE_WAIT
	SLEEP	1
	MOVE	@SLIDE_OFF_COUNT,A14,W
	JRNZ	FP_SLIDE_WAIT			;BR=SLIDIN' GRAPHICS NOT DONE

	JSRP	SHOW_GCARDS_INTRO

	.if	NO_HELP_WINDOWS
	.else

	CALLA	START_HELP_WINDOWS
	MOVE	@HELP_WINDOW_COUNT,A14,W
	JRZ	FP_CHECK_CUP_GAME		;BR=NO WINDOWS

	CALLA	COPY_HEAD_PALS

	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	MOVI	HELP_PAL_LIST,A0
	calla	FADE_FULL2HALFf
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS

	CALLA	ALLOCATE_ALT_HEAD_PALS

FP_HELP_WINDOW_WAIT
	SLEEP	1
	MOVE	@HELP_WINDOW_COUNT,A14,W
	JRNZ	FP_HELP_WINDOW_WAIT		;BR=NO WINDOWS

	CALLA	DEALLOCATE_ALT_HEAD_PALS

	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	MOVI	HELP_PAL_LIST,A0
	calla	FADE_HALF2FULLf
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS

	.endif

FP_CHECK_CUP_GAME
	MOVI	PLAYER_1_BLOCK,A6
	MOVE	@team2,A1,W
	CALLR	CHECK_STANCUP_GAME
	JRZ	FP_CUP_GAME

	MOVI	PLAYER_2_BLOCK,A6
	MOVE	@team2,A1,W
	CALLR	CHECK_STANCUP_GAME
	JRZ	FP_CUP_GAME

	MOVI	PLAYER_5_BLOCK,A6
	MOVE	@team1,A1,W
	CALLR	CHECK_STANCUP_GAME
	JRZ	FP_CUP_GAME

	MOVI	PLAYER_6_BLOCK,A6
	MOVE	@team1,A1,W
	CALLR	CHECK_STANCUP_GAME
	JRNZ	FP_POWERUPS

FP_CUP_GAME
	MOVI	PID_POWERUP,A0
	CALLA	KILLPROC_ALL

	MOVI	ORGTXT1P,A0
	CALLA	GETFPAL
	move	a0,a9

	MOVK	3,A8
FP_STANCUP_LUPE
;	PUSH	A8
	mmtm	sp,a8,a9
	MOVI	STANLEY_CUP_MESS,A8
	JSRP	LM_PRINTF
;	PULLQ	A8
	mmfm	sp,a8,a9

	SLEEP	20

	CALLA	CLRTEXT

	SLEEP	10

	DSJ	A8,FP_STANCUP_LUPE	

;	MOVI	ORGTXT1P,A0
;	CALLA	DELETE_PAL		;DELETE OLD
	move	a9,a0
	calla	FREEPAL

FP_POWERUPS
	CALLA	REPORT_POWERUPS
	CREATE	PID_IND,START_1ST_SMALL_TIMER	;START SMALL TIMER SOON

FP_DROP
	MOVI	PID_POWERUP,A0
	CALLA	KILLPROC_ALL

	mmtm	sp,a0
	movi	360,a0
	calla	RAND0
	move	a0,@PLAYER_1_BLOCK+POF_FAKE_DIRECTION,W
   	movi	360,a0
	calla	RAND0
	move	a0,@PLAYER_6_BLOCK+POF_FAKE_DIRECTION,W
	mmfm	sp,a0
	calla	spx_faceoff_start
	movk	1,a14
	move	a14,@taps_ok,W
	movi	60,a10
	move	@faceoff_type,a14,W
	jrnz	revf
	movi	50,a10
revf	callr	revsub
	SLEEP	1
	dsjs	a10,revf
	clr	a14			;safety
	move	a14,@no_control,W	;safety

	callr	start_ref_drop
	callr	pick_faceoff_winner
	calla	spx_faceoff_taken
	callr	set_faceoff_take_scripts
	move	a1,a10
	SLEEP	3
	move	a10,a1
	callr	set_faceoff_puck_state
	calla	start_timer

	move	@timer_on,a0,W
	jrz	stru1
	movk	15,a0
	calla	show_timer
stru1
;;	movi	100,a0
;	movi	15,a0
;	calla	show_timer

	SLEEP	14

	callr	get_rid_of_ref
	callr	give_back_all_control
	clr	a14
	move	a14,@taps_ok,W
	jauc	SUCIDE

wait_for_stopped_ref
	move	@ref_object,a8,L
wfsr1	move	*a8(OXVEL),a0,L
	jrz	wfsr9
	SLEEP	1
	jruc	wfsr1
wfsr9	RETP

**************************************************************************
*								         *
* CHECK_STANCUP_GAME							 *
* 									 *
* PASS:									 *
* A1 = OPPOSING TEAM							 *
* A6 = PLAYER BLOCK							 *
* 									 *
* RETURN:								 *
* Z SET IF THIS IS THE STANLEY CUP GAME, ELSE Z CLR			 *
*								         *
**************************************************************************

CHECK_STANCUP_GAME
	MOVE	*A6(POF_CMOS),A0,W
	JRN	CSG_DONE			;BR=NO RECORD (NZ)
	CALLA	get_cmos_record_a

	MOVE	@b_teamsbeat,A0,L
	MOVK	25,A2				;LAST NHL TEAM
	CLR	A3				;RESET TOTAL DEFEATS
	CLR	A4
	DEC	A4				;INVALID STANLEY CUP TEAM
CSG_LUPE
	BTST	A2,A0
	JRZ	CSG_NEXT			;BR=DIDN'T BEAT THIS TEAM
	INC	A3				;BEAT 'EM!
	JRUC	CSG_NEXT2
CSG_NEXT
	MOVE	A2,A4				;LAST UNBEATEN TEAM
	INC	A4
CSG_NEXT2
	DEC	A2
	JRNN	CSG_LUPE			;BR=MORE TEAMS TO CHECK

	SUBK	25,A3
	JRNZ	CSG_DONE			;BR=NOT LAST TEAM (NZ)

	CMP	A1,A4
	;Z IF STANLEY CUP GAME, ELSE NZ

CSG_DONE
	RETS

STANLEY_CUP_MESS
	MESS_MAC2 H50FONT,-2,0,199,65,HFPAL,STRCNCONV,OID_TEXT
	.STRING	"\pSTANLEY\nCUP] GAME !",0
	.LONG	ORGTXT1P	
	.EVEN
	
**************************************************************************
*								         *
* START_1ST_SMALL_TIMER - FLAG SMALL TIMER TO BE DISPLAYED AFTER FACEOFF *
* 									 *
* PASS:									 *
* NUTIN'								 *
*								         *
**************************************************************************

START_1ST_SMALL_TIMER
	SLEEP	91
	movk	1,a0
	move	a0,@small_timer_on,W
	DIE

HELP_PAL_LIST
	.long   FREEBOXP
	.long	PRPTRBOP,BLUTRBOP,YLWTRBOP,GRNTRBOP
	.long	LSTNME1P,NAMEBARP
	.long	SCOREBAR,JITTERP,CITYP,SCORESP,PERIODP,LEDSP	;,SCCITYP
	.long	T2FIXED,TEXTPAL
	.long	player_1_turbopal,player_2_turbopal
	.long	player_3_turbopal,player_4_turbopal
	.LONG	arrp_pal,arrb_pal,arry_pal,arrg_pal
	.long	0

revsub	movk	1,a0
	movk	2,a7
	callr	ttx1
	movk	6,a0
	movk	5,a7
ttx1	GBLOCK	a0,a6
	move	*a6(POF_OBJECT),a8,L
	move	*a6(POF_FAKE_DIRECTION),a0,W
	sll	16,a0
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrnz	ttx2nd
	GBLOCK	a7,a7
	move	*a7(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	ttx2d
	movb	*a7(POF_JOY),a0
	jruc	ttx2rd
ttx2nd	movb	*a6(POF_JOY),a0
ttx2rd	move	a0,a0
	jrz	tttx		;we stay still, we don't move
	subk	4,a0
	jrp	ttx2
	addk	8,a0
ttx2	calla	dir_to_degrees	;get our joystick angle, a0
ttx2d	move	a0,a9
	move	a0,a4
	callr	fa555		;get our current angle, a0
	sub	a0,a4
	THETA_H	a4		;a4 is +/- 180 of difference
	movi	XD0023,a5
	move	a4,a4
	jrp	ttx3
	neg	a5
ttx3	abs	a4		;a5 is our maximum change
	cmpi	XD0023,a4
	jrhs	tlk1
	move	a9,a0
	jruc	tttl1
tlk1	add	a5,a0		;a0 is our new angle
tttl1	movb	*a6(POF_NUMBER),a14
	dec	a14
	srl	2,a14
	jrnz	ttteam2
ttteam1	THETA_H	a0
	cmpi	XD0750,a0
	jrle	tx1_1
	movi	XD0750,a0
	jruc	adone
tx1_1	cmpi	-XD0800,a0
	jrge	adone
	movi	-XD0800,a0
	jruc	adone
ttteam2	THETA_N	a0
	cmpi	XD1000,a0
	jrhs	tx2_1
	movi	XD1000,a0
	jruc	adone
tx2_1	cmpi	XD2600,a0
	jrls	adone
	movi	XD2600,a0
adone	movi	[150,0],a1
	calla	polar_to_rect
	move	@faceoff_x,a14,W
	sll	16,a14
	sub	a14,a0
	neg	a0
	move	@faceoff_z,a14,W
	sll	16,a14
	sub	a14,a1
	neg	a1
	move	a0,*a8(OXVAL),L
	move	a1,*a8(OZVAL),L
	mmtm	sp,a0,a1,a7,a9
	move	*a6(POF_ARROW_CPU),a7,L
	jrz	abgta
	move	*a6(POF_OBJECT),a9,L
	calla	cpu_arrow_on
abgta	mmfm	sp,a0,a1,a7,a9
tttx	rets

fa555	move	*a8(OXVAL),a0,L
	move	*a8(OZVAL),a1,L
	move	@faceoff_x,a14,W
	sll	16,a14
	sub	a14,a0
	neg	a0
	move	@faceoff_z,a14,W
	sll	16,a14
	sub	a14,a1
	neg	a1
	calla	rect_to_dir
	move	a0,a3
	calla	dir_to_18
	movb	a0,*a6(POF_DIRECTION)
	clr	a0
	movb	a0,*a6(POF_BDIRECTION)
	calla	set_faceoff_ready_script
	move	a3,a0
	rets

pick_faceoff_winner
	move	@tap_count1,a0,W
	move	@tap_count2,a1,W
	add	a1,a0
	calla	RANDU
	cmp	a1,a0
	jrls	pfw_2
	jruc	pfw_1
pfw_1	movk	1,a0
	jruc	pfwx
pfw_2	movk	2,a0
pfwx	move	a0,a1
	mmtm	sp,a1
	move	a0,a14
	sll	5,a14
	addi	faceoff_1-32,a14
	move	*a14,a1,L
	inc	a1
	move	a1,*a14,L
	mmfm	sp,a1
	rets

set_faceoff_take_scripts	;don't change a0,a1
	mmtm	sp,a0,a1
	sll	6,a0
	addi	set_fts-64,a0
	move	a0,a11
	movk	2,a0
	callr	sftr1
	movk	5,a0
	callr	sftr1
	mmfm	sp,a0,a1
	rets
sftr1	move	*a11+,a1,L
	GBLOCK	a0,a6
	move	*a6(POF_OBJECT),a8,L
	calla	take_player_control
	jump	a1		;set our script

set_fts	.long	set_faceoff_take_for_2
	.long	set_faceoff_take_for_5

	.long	set_faceoff_take_for_2
	.long	set_faceoff_take_for_5

set_faceoff_take_for_2
	movk	1,a7
	jruc	sfr1
set_faceoff_take_for_5
	movk	6,a7
sfr1	GBLOCK	a7,a7
	move	*a7(POF_FLAGS),a14,W
	btst	B_PF_REV_FACE,a14
	jrnz	sfrr1
	move	*a7(POF_OBJECT),a7,L
	move	*a7(OZPOS),a7,W
	move	*a8(OZPOS),a14,W
	sub	a14,a7
	cmpi	125,a7
	jagt	set_faceoff_take_up_script
	cmpi	76,a7
	jagt	set_face_take_up_back_script
	cmpi	-80,a7
	jagt	set_faceoff_take_back_script
	jauc	set_faceoff_take_down_script
sfrr1	jauc	set_rev_face_take_back_script

set_faceoff_puck_state
	sll	7,a1
	addi	faceoff_state_table-128,a1
	movk	8,a4
	movk	3,a5
cb4l	move	*a1+,a0,W
	GBLOCK	a0,a6
	movb	a4,*a6(POF_IGNORE_PUCK)
	dsjs	a5,cb4l
	move	*a1+,a0,W
	move	a0,@world_mt_point,W
	movi	DUMRETS,b6		;don't modify
	move	*a1+,a0,W
	movi	[11,0],a7
	calla	send_puck_to_player
	movk	1,a0
	move	a0,@PUCK_MODE,W
	move	@WAVEIRQS,@faceoff_time,L
	jauc	puck_slide_sound

faceoff_state_table
	.word	2,5,6,160,1,0,0,0
	.word	1,2,5,-160,6,0,0,0

face_off_points
	.word	1,-150,71,2
	.word	2,-150,0,3
	.word	5,150,0,7
	.word	6,150,71,8
	.word	4,-150,-69,4
	.word	8,150,-69,6
	.word	0

other_face_off_points			;when face off is on far side of ice
	.word	1,-150,-69,4
	.word	2,-150,0,3
	.word	5,150,0,7
	.word	6,150,-69,6
	.word	4,-150,71,2
	.word	8,150,71,8
	.word	0

face_off_2_points
	.word	2,-60,0,-3
	.word	5,60,0,-7
	.word	1,-140,61,-2
	.word	6,140,61,-8
	.word	4,-140,-59,-4
	.word	8,140,-59,-6
	.word	0

other_face_off_2_points
	.word	2,-60,0,-3
	.word	5,60,0,-7
	.word	1,-140,-59,-4
	.word	6,140,-59,-6
	.word	4,-140,61,-2
	.word	8,140,61,-8
	.word	0

inc_tap
	cmpi	2,a0
	jrz	it1
	cmpi	5,a0
	jrz	it1
	movk	2,a1
	cmpi	5,a0
	jrlo	it3
	movk	5,a1
it3	GBLOCK	a1,a14
	move	*a14(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrnz	it9		;the player we want is a human, ignore this guy
	move	a1,a14
	jruc	it2
it1	move	a0,a14
it2	dec	a14
	srl	2,a14
	sll	4,a14
	addi	tap_count1,a14
	move	*a14,a1,W
	inc	a1
	move	a1,*a14,W
it9	rets

faceoff_tap
	move	@taps_ok,a14
	jrz	ft999
	calla	take_player_control
	jauc	set_faceoff_tap_script
ft999	rets

**************************************************************************
*								         *
* move_players_to_points						 *
* 	input	a4 = list of player/points				 *
*								         *
**************************************************************************
move_players_to_points
mtps_2	move	*a4+,a0,W
	jrz	mtps_9
	move	*a4+,a2,W
	move	@faceoff_x,a14
	add	a14,a2
	sll	16,a2
	move	*a4+,a3,W
	move	@faceoff_z,a14
	add	a14,a3
	sll	16,a3
	move	*a4+,a1,W
	callr	move_player_to_point
	jruc	mtps_2
mtps_9	rets

move_players_to_points_ng		;skips any player that is a goalie
mtng_2	move	*a4+,a0,W
	jrz	mtps_9
	move	*a4+,a2,W
	move	@faceoff_x,a14
	add	a14,a2
	sll	16,a2
	move	*a4+,a3,W
	move	@faceoff_z,a14
	add	a14,a3
	sll	16,a3
	move	*a4+,a1,W
	GBLOCK	a0,a14
	move	*a14(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	mtng_2			;skip if he is a goalie
	callr	move_player_to_point
	jruc	mtng_2


**************************************************************************
*								         *
* free_skate_players_to_points						 *
* 	input	a4 = list of player/points				 *
*								         *
**************************************************************************
free_skate_players_to_points
fsps_2	move	*a4+,a0,W
	jrz	fsps_9
	move	*a4+,a2,W
	move	@faceoff_x,a14
	add	a14,a2
	sll	16,a2
	move	*a4+,a3,W
	move	@faceoff_z,a14
	add	a14,a3
	sll	16,a3
	move	*a4+,a1,W
	callr	free_skate_player_to_point
	jruc	fsps_2
fsps_9	rets

free_skate_players_to_points_ng
fasps_2	move	*a4+,a0,W
	jrz	fasps_9
	move	*a4+,a2,W
	move	@faceoff_x,a14
	add	a14,a2
	sll	16,a2
	move	*a4+,a3,W
	move	@faceoff_z,a14
	add	a14,a3
	sll	16,a3
	move	*a4+,a1,W
	GBLOCK	a0,a14
	move	*a14(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	fasps_2			;skip if he is a goalie
	callr	free_skate_player_to_point
	jruc	fasps_2
fasps_9	rets

**************************************************************************
*								         *
* wait_for_all_control							 *
* 	waits for all control to end (by process id, not flags)		 *
*    USE JSRP								 *
*								         *
**************************************************************************
wfa_1	SLEEP	1
wait_for_all_control
	movi	PID_MOVE_TO,a0
	calla	EXISTP_ALL
	jrnz	wfa_1
	RETP

**************************************************************************
*								         *
* give_back_all_control							 *
* 	gives control back to every player, start play			 *
*								         *
**************************************************************************
give_back_all_control
	movk	8,a0
gba_1	cmpi	3,a0
	jrz	ghy_1
	cmpi	7,a0
	jrnz	ghy_2
ghy_1	dec	a0
ghy_2	callr	release_higher_control
	dsjs	a0,gba_1
	rets

**************************************************************************
*								         *
* move_player_to_point							 *
* 	input	a0 = player						 *
* 		a1 = direction to face when over (- means at start also) *
* 		a2 = x position						 *
* 		a3 = z position						 *
*								         *
**************************************************************************
move_player_to_point
	move	a0,a9
	move	a2,a10
	move	a3,a11
	move	a1,a8
	CREATEP	PID_MOVE_TO,mptp_1
	rets
mptp_1	movi	set_relaxed_fast_skate_script+1,a1
	movi	set_relaxed_stand_script,a2
	JSRP	move_player_to_point_process
	jauc	SUCIDE

**************************************************************************
*								         *
* free_skate_player_to_point						 *
* 	input	a0 = player						 *
* 		a1 = direction to face when over (- means at start also) *
* 		a2 = x position						 *
* 		a3 = z position						 *
*								         *
**************************************************************************
free_skate_player_to_point
	move	a0,a9
	move	a2,a10
	move	a3,a11
	move	a1,a8
	cmpi	2,a0
	CREATEP	PID_MOVE_TO,fstp_1
	rets
fstp_1	cmpi	2,a9
	jrnz	fstp2
	GBLOCK	a9,a6
fstp2	movi	set_go_into_faceoff_script,a1
	movi	DUMRETS,a2
	JSRP	move_player_to_point_pnw
	jauc	SUCIDE

**************************************************************************
*								         *
* move_player_to_point_process						 *
* 	input	a9 = player						 *
* 		a10 = x position					 *
* 		a11 = z position					 *
* 		a8 = direction to face when done (- means at start)	 *
* 		a1 = routine to call set move script (+1 means do always *
* 		a2 = routine to call to set stand script		 *
*   USE JSRP								 *
*								         *
**************************************************************************
move_player_to_point_pnw 	;assumes we have control
	move	a9,a0
	PUSHP	a2		;stand script
	PUSHP	a8		;direction to face
	PUSHP	a1		;move routine to set script
	GBLOCK	a0,a6
	jruc	mptp_31
move_player_to_point_process
	move	a9,a0
	PUSHP	a2		;stand script
	PUSHP	a8		;direction to face
	PUSHP	a1		;move routine to set script
	JSRP	get_higher_control
mptp_31	clr	a14
	movb	a14,*a6(POF_SKATE_RATE_G)
	calla	clear_srt
	move	*a6(POF_OBJECT),a8,L
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	move	a10,a0
	move	a11,a1
	calla	find_dir_to_point
	mmtm	sp,a11
	calla	dir_to_18
	mmfm	sp,a11

	move	*a12(020h),a14,L	;get direction
	jrnn	mpti1
	abs	a14
	move	a14,a0
mpti1	movb	a0,*a6(POF_DIRECTION)
	clr	a14
	move	a14,*a6(POF_BDIRECTION)

	move	*a12,a14,L	;get move routine from process stack
	srl	1,a14
	sll	1,a14
	call	a14		;set move script
mptp_3	move	*a12,a14,L	;get move routine from process stack
	srl	1,a14
	jrnc	mpj_31
	sll	1,a14
	call	a14		;set move script
mpj_31	clr	a14
	movb	a14,*a6(POF_I_JOY)	;clear out joystick ignore
	movb	a14,*a6(POF_JOY)
	move	*a6(POF_OBJECT),a8,L
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	move	a10,a0
	move	a11,a1
	calla	find_dirdis_to_point
	move	a1,a9		;save distance
	sra	16,a1
	lmo	a1,a1
	sll	5,a1
	addi	mptp_v,a1
	move	*a1,a2,L
	jrz	mptp_8
	move	a2,a14
	sra	1,a14
	move	a14,*a6(POF_SPEED_GL),L
	movk	25,a3			;move to
	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrnz	ak48
	move	*a8(ODT_VEL),a1,L
	cmpi	[16,0],a1
	jrls	ak49
	move	a2,a1
	jruc	ak47
ak49	calla	move_to_speed_x
	jruc	ak47
ak48	movi	[18,0],a1
ak47	cmp	a9,a1
	jrls	ak472
	move	a9,a1			;don't let us go faster than our distance
ak472	calla	set_obj_to_polar
	calla	close_area_check
skipfc	move	a6,a9
	SLEEP	1
	move	a9,a6
	jruc	mptp_3
mptp_8	clr	a1
	addk	32,a12		;remove move routine from stack
	PULLP	a0		;get face direction
	abs	a0
	movb	a0,*a6(POF_DIRECTION)
	clr	a14
	movb	a14,*a6(POF_BDIRECTION)
	calla	dir_to_degrees
	calla	set_obj_to_polar
	calla	close_area_check
	PULLP	a14
	call	a14		;set stand script
	RETP

mptp_v	.long	0		;lmo = 31	80000000-ffffffff, 0
	.long	[22,0]		;lmo = 30	40000000-7fffffff
	.long	[22,0]		;lmo = 29	20000000-3fffffff
	.long	[22,0]		;lmo = 28	10000000-1fffffff
	.long	[22,0]		;lmo = 27	08000000-0fffffff
	.long	[22,0]		;lmo = 26	04000000-07ffffff
	.long	[22,0]		;lmo = 25	02000000-03ffffff
	.long	[22,0]		;lmo = 24	01000000-01ffffff
	.long	[22,0]		;lmo = 23	00800000-00ffffff
	.long	[22,0]		;lmo = 22	00400000-007fffff
	.long	[22,0]		;lmo = 21	00200000-003fffff
	.long	[22,0]		;lmo = 20	00100000-001fffff
	.long	[22,0]		;lmo = 19	00080000-000fffff
	.long	[22,0]		;lmo = 18	00040000-0007ffff
	.long	[22,0]		;lmo = 17	00020000-0003ffff
	.long	[21,0]		;lmo = 16	00010000-0001ffff
	.long	[21,0]		;lmo = 15	00008000-0000ffff
	.long	[20,0]		;lmo = 14	00004000-00007fff
	.long	[20,0]		;lmo = 13	00002000-00003fff
	.long	[19,0]		;lmo = 12	00001000-00001fff
	.long	[18,0]		;lmo = 11	00000800-00000fff
	.long	[17,0]		;lmo = 10	00000400-000007ff
	.long	[16,0]		;lmo = 9	00000200-000003ff
	.long	[12,0]		;lmo = 8	00000100-000001ff
	.long	[9,0]		;lmo = 7	00000080-000000ff
	.long	[5,0]		;lmo = 6	00000040-0000007f
	.long	[3,0]		;lmo = 5	00000020-0000003f
	.long	[1,0f001h]	;lmo = 4	00000010-0000001f
	.long	[0,0f001h]	;lmo = 3	00000008-0000000f
	.long	[0,0c001h]	;lmo = 2	00000004-00000007
	.long	[0,08001h]	;lmo = 1	00000002-00000003
	.long	[0,06001h]	;lmo = 0	00000001-00000001

**************************************************************************
*								         *
* get_higher_control							 *
* 	input	a0 = player number					 *
*   USE JSRP								 *
*								         *
**************************************************************************
get_higher_control
ghc_1	callr	get_higher_status
	move	a1,a1
	jrz	ghc_8
	cmpi	1,a1
	jrz	ghc_2
	move	a0,a9
	SLEEP	1
	move	a9,a0
	jruc	ghc_1
ghc_2	callr	take_higher_wait
ghc_3	SLEEP	1
	move	a9,a0
	GBLOCK	a0,a6
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HIGHER,a14
	jrnz	ghc_3
ghc_8	callr	take_higher_control
	PUSHP	a10
	PUSHP	a11
ghc_84	movi	40,a10
	move	*a6(POF_OBJECT),a14,L
	move	*a14(ANIMSCR),a11,L
ghc_85	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrnz	ghc_9
	dec	a10
	jrn	ghc_9
	SLEEP	1
	move	a9,a0
	GBLOCK	a0,a6
	move	*a6(POF_OBJECT),a14,L
	move	*a14(ANIMSCR),a14,L
	cmp	a11,a14
	jrnz	ghc_84		;as long as script is changing, we will wait
	jruc	ghc_85
ghc_9	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_CONTROL,a14
	move	a14,*a6(POF_FLAGS),W
	clr	a14
	movb	a14,*a6(POF_BDIRECTION)
	move	*a6(POF_OBJECT),a10,L
	move	a14,*a10(OYACCEL),W
	move	a14,*a10(OYVEL),L
	move	a14,*a10(OYVAL),L
	PULLP	a11
	PULLP	a10
	RETP

**************************************************************************
*								         *
* release_higher_control						 *
* 	input	a0 = player number					 *
*								         *
**************************************************************************
release_higher_control
	GBLOCK	a0,a6
	move	*a6(POF_FLAGS),a14,W
	andni	M_PF_HIGHER|M_PF_HIGHER_W,a14
	ori	M_PF_CONTROL,a14
	move	a14,*a6(POF_FLAGS),W
	rets

**************************************************************************
*								         *
* get_higher_status							 *
* 	input	a0 = player number					 *
* 	output	a1 = 0 - no one has control				 *
* 		     1 - someone has control now			 *
* 		     2 - someone has control, and someone is waiting	 *
* 		a6 = player block					 *
*								         *
**************************************************************************
get_higher_status
	GBLOCK	a0,a6
	move	*a6(POF_FLAGS),a14,W
	clr	a1
	btst	B_PF_HIGHER,a14
	jrz	ghs_7
	movk	1,a1
ghs_7	btst	B_PF_HIGHER_W,a14
	jrz	ghs_9
	movk	2,a1
ghs_9	rets

**************************************************************************
*								         *
* take_higher_control							 *
* 	input	a6 = player block					 *
*								         *
**************************************************************************
take_higher_control
	move	*a6(POF_FLAGS),a14,W
	andni	M_PF_HIGHER_W,a14
	ori	M_PF_HIGHER,a14
	move	a14,*a6(POF_FLAGS),W
	rets

**************************************************************************
*								         *
* take_higher_wait							 *
* 	input	a6 = player_block					 *
*								         *
**************************************************************************
take_higher_wait
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_HIGHER_W,a14
	move	a14,*a6(POF_FLAGS),W
	rets

create_ref
	callr	kill_ref
	movi	ref_shadow_init,b0
	calla	EASYMAKE
	move	a8,@ref_shadow,L
	movi	ref_init,b0
	calla	EASYMAKE
	movi	ref_palette,a0
	calla	CHANGE_PAL
	move	a8,@ref_object,L
	move	@faceoff_x,a0,W
	jrz	cr_iu1
	sra	2,a0
cr_iu1	move	a0,*a8(OXPOS),W
	movk	4,a0
	move	a0,*a8(OYPOS),W
	move	@faceoff_z,a0,W
	move	a0,*a8(OZPOS),W
	calla	INSERT_OBJ
	clr	a14
	cmpi	300,a0
	jrlt	cci1
	movk	1,a14
	cmpi	360,a0
	jrlt	cci1
	movk	2,a14
cci1	move	a14,@ref_size
	move	@faceoff_x,a0,W
	jrnz	cci2
	callr	start_ref_look
	jruc	clean_up_ref
cci2	callr	bring_ref_on
	jruc	clean_up_ref

start_ref_look
	move	@ref_object,a8,L
	jauc	set_ref_look_script

start_ref_stand
	move	@ref_object,a8,L
	jauc	set_ref_stand_script

start_ref_faceoff
	move	@ref_object,a8,L
	jauc	set_ref_setup_script

start_ref_drop
	calla	turn_puck_on
	move	@ref_object,a8,L
	jauc	set_ref_drop_script

bring_ref_on
	C_A_K	PID_REF,move_ref_on
	movi	set_ref_skate_right_norm_script,a1
	move	@ref_object,a8,L
	move	*a8(OXPOS),a14,W
	jrp	bro_ok
	movi	set_ref_skate_left_norm_script,a1
bro_ok	jump	a1

mro_1	callr	clean_up_ref
	SLEEP	1
move_ref_on
	move	@ref_object,a8,L
	move	*a8(OXPOS),a0,W
	move	@faceoff_x,a1,W
	move	a1,a2
	sub	a0,a2
	abs	a2
	cmpi	2,a2
	jrlt	mro_9k
	cmp	a1,a0
	jrhi	mrotl		;moving to left
mrotr	movi	[5,0],a3
	cmpi	127,a2
	jrhi	mtr2
	cmpi	110,a2
	jrlo	mtr21
	calla	set_ref_stop_left_right_script
mtr21	cmpi	80,a2
	jrhi	mtr2
	addi	80,a2
	sll	11,a2
	move	a2,a3
mtr2	move	a3,*a8(OXVEL),L
	jruc	mro_1
mrotl	movi	[-5,0],a3
	cmpi	127,a2
	jrhi	mtl2
	cmpi	110,a2
	jrlo	mtl21
	calla	set_ref_stop_left_right_script
mtl21	cmpi	80,a2
	jrhi	mtl2
	addi	80,a2
	sll	11,a2
	neg	a2
	move	a2,a3
mtl2	move	a3,*a8(OXVEL),L
	jruc	mro_1
mro_9k	clr	a3
	move	a3,*a8(OXVEL),L
	move	@faceoff_x,a1,W
	move	a1,*a8(OXPOS),W
	callr	clean_up_ref
	jauc	SUCIDE

get_rid_of_ref
	C_A_K	PID_REF,move_ref_off
	rets
move_ref_off
	move	@ref_object,a8,L
	move	*a8(OXPOS),a14,W
	cmpi	200,a14
	jrgt	mrol
	cmpi	-200,a14
	jrlt	mror
	move	@PUCK_OBJECT,a14,L
	move	*a14(OXPOS),a14,W
	jrp	mrol
mror	calla	set_ref_skate_right_script
	jruc	mrb5
mrol	calla	set_ref_skate_left_script
;	movi	[5,0],a0
;	move	a0,*a8(OZVEL),L
mrb5	callr	clean_up_ref
	SLEEP	3
	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrnz	mrb2
	move	*a8(OZPOS),a0,W
	cmpi	660,a0
	jrls	mrb5
	clr	a0
	move	a0,*a8(OZVEL),L
	callr	clean_up_ref
	calla	set_ref_bump_script
mrb6	SLEEP	5
	callr	clean_up_ref
	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrz	mrb6
mrb2	clr	a0
	move	a0,@ref_object,L
	move	a0,@ref_shadow,L
	callr	kill_ref
	jauc	SUCIDE

kill_ref
	movi	PID_REF,a0
	calla	KILLPROC_ALL
	movi	OID_REF,a0
	calla	KILOBJ_ALL
	movi	OID_REF_SHAD,a0
	jauc	KILOBJ_ALL

ref_init
	.long	shadow3
;	.long	RFO51F03
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID
	.word	OID_REF

ref_shadow_init
	.long	shadow3
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_REF_SHAD

ref_palette
   .word   44
   .word   00000h,07fffh,077deh,06f9ch,0675ah,05f18h,052b5h,04652h
   .word   031adh,0296bh,02529h,02508h,02508h,024c8h,020a8h,01c88h
   .word   07e01h,07d80h,074a0h,06880h,06080h,05c60h,05860h,05400h
   .word   04c00h,04800h,03c00h,03000h,02400h,07fbdh,07f7ah,07f9ah
   .word   07f37h,07ef5h,0728fh,06a4eh,055cdh,04daah,0496ah,03d49h
   .word   03d28h,02cc5h,02486h,01c88h

clean_up_ref
	mmtm	sp,a11
	move	@ref_object,a9,L
	move	@ref_shadow,a8,L
	movi	[4700,0],a11
	calla	shad_do
	mmfm	sp,a11
	move	@ref_object,a8,L
	rets
