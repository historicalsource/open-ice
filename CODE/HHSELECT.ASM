 	.MLIB	"HHMACS.LIB"
	.FILE	"HHSELECT.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*

	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhselect.e"
	.include	"hhproc.g"
	.include	"hhd.g"
	.include	"hhpall.g"
	.include	"hhutil.g"
	.include	"hhplayer.g"
	.include	"hhgame.g"
	.include	"hhgscr.g"
	.include	"hhmisc.g"
	.include	"hhram.g"
	.include	"hhc.g"
;	.include	"hhstable.g"
	.ref	team_data
	.ref	helmet_type_plist
	.include	"hhcontrl.g"
	.include	"hhtables.g"
	.include	"hhcx.g"
	.include	"hhgctrl.g"
	.include	"hhstabl2.g"
	.include	"hhpick.g"
	.include	"hhscr_fn.g"
	.include	"hhscr_ms.g"
	.include	"hhscr_sk.g"
	.include	"hhcontr2.g"
	.include	"hhtext.g"
	.include	"hhpup.g"
	.include	"hhcmos.g"

; end of include files

	.bss	player_1_turbopal,16*256	;just don't use a 256 color palette
	.bss	player_2_turbopal,16*256	;with these (our size pushes us over)
	.bss	player_3_turbopal,16*256
	.bss	player_4_turbopal,16*256

	.bss	player_1_headpal,16*256		;we can be non 1256
	.bss	player_2_headpal,16*256		;and get here
	.bss	player_3_headpal,16*256
	.bss	player_4_headpal,16*256
	.bss	player_5_headpal,16*256
	.bss	player_6_headpal,16*256
	.bss	player_7_headpal,16*256
	.bss	player_8_headpal,16*256

	.bss	player_1_trailpal,16*256		;we can be non 1256
	.bss	player_2_trailpal,16*256		;and get here
	.bss	player_3_trailpal,16*256
	.bss	player_4_trailpal,16*256
	.bss	player_5_trailpal,16*256
	.bss	player_6_trailpal,16*256
	.bss	player_7_trailpal,16*256
	.bss	player_8_trailpal,16*256

	.bss	player_1_redpal,16*256		;we can be non 1256
	.bss	player_2_redpal,16*256		;and get here
	.bss	player_3_redpal,16*256
	.bss	player_4_redpal,16*256
	.bss	player_5_redpal,16*256
	.bss	player_6_redpal,16*256
	.bss	player_7_redpal,16*256
	.bss	player_8_redpal,16*256

	.bss	player_1_headpal_alt,16*256
	.bss	player_2_headpal_alt,16*256
	.bss	player_5_headpal_alt,16*256
	.bss	player_6_headpal_alt,16*256

	.bss	team_1_vidpal,32	;keep 
	.bss	team_2_vidpal,32	;together

	.TEXT
	.EVEN

atest	movk	1,a0
at12	callr	get_bargraph_data
	inc	a0
	jruc	at12

**************************************************************************
*								         *
* get_bargraph_data							 *
* 	input	a0 = character number					 *
* 	output	a2 = character data (bytewise CPHS)			 *
* 		 S = character's skate rating (1-10)			 *
* 		     (speed+stop+corner) / 2				 *
* 		 H = character's shoot rating (1-10)			 *
* 		     (3 x shoot + handle) / 2				 *
* 		 P = character's pass  rating (1-10)			 *
* 		     (3 x pass + handle) / 2				 *
* 		 C = character's check rating (1-10)			 *
* 		     (3 x check + faceoff) / 2				 *
*								         *
**************************************************************************
get_bargraph_data
	mmtm	sp,a1,a3,a4,a5
	move	a0,a5
	sll	5,a5
	addi	player_data,a5
	move	*a5,a5,L
	movb	*a5(TP_SPEED),a1
	movb	*a5(TP_STOP),a14
	add	a14,a1
	movb	*a5(TP_CORNER),a14
	add	a14,a1
	sra	1,a1
	movb	*a5(TP_SHOOT),a2
	move	a2,a14
	add	a14,a2
	add	a14,a2
	movb	*a5(TP_HANDLE),a14
	add	a14,a2
	sra	1,a2
	movb	*a5(TP_PASS),a3
	move	a3,a14
	add	a14,a3
	add	a14,a3
	movb	*a5(TP_HANDLE),a14
	add	a14,a3
	sra	1,a3
	movb	*a5(TP_CHECK),a4
	move	a4,a14
	add	a14,a4
	add	a14,a4
	movb	*a5(TP_FACEOFF),a14
	add	a14,a4
	sra	1,a4
	sll	24,a1
	srl	24,a1
	sll	24,a2
	srl	16,a2
	sll	24,a3
	srl	8,a3
	sll	24,a4
	add	a1,a2
	add	a3,a2
	add	a4,a2
	mmfm	sp,a1,a3,a4,a5
	rets

set_bench_palettes
	move	@team1,a3,W
	MOD_COL	a3			;modify a3 based if colorado
	sll	10,a3
	addi	team_data,a3
	movi	TD_BENCHP_AWAY,a4
	move	@team1_home,a14,W
	jrz	sbp2
	movi	TD_BENCHP_HOME,a4
sbp2	add	a4,a3
	move	*a3,a14,L
	move	a14,@teampal1,L
	move	@team2,a3,W
	MOD_COL	a3			;modify a3 based if colorado
	sll	10,a3
	addi	team_data,a3
	movi	TD_BENCHP_AWAY,a4
	move	@team2_home,a14,W
	jrz	sbp3
	movi	TD_BENCHP_HOME,a4
sbp3	add	a4,a3
	move	*a3,a14,L
	move	a14,@teampal2,L
	rets

set_video_palettes
	rets
;	move	@team1,a3,W
;	sll	10,a3
;	addi	team_data,a3
;	move	@team2,a4,W
;	sll	10,a4
;	addi	team_data,a4
;	move	*a3(TD_VCLIP_1),a1,W
;	move	*a4(TD_VCLIP_1),a2,W
;	cmp	a1,a2
;	jrnz	svp7			;a1 and a2 are it
;	move	*a3(TD_VCLIP_2),a14,W
;	cmp	a14,a2
;	jrnz	svp_141			;a14 and a2 are it
;	move	*a4(TD_VCLIP_2),a0,W
;	cmp	a1,a0
;	jrnz	svp_02			;a1 and a0 are it
;	cmp	a14,a0
;	jrnz	svp_140		;a14 and a0 are it
;	jruc	svp7			;a1 and a2 are it, we will live with match
;svp_141	move	a14,a1
;	jruc	svp7
;svp_02	move	a0,a2
;	jruc	svp7
;svp_140	move	a14,a1
;	move	a0,a2
;svp7	sll	5,a1
;	sll	5,a2
;	addi	vclip_pal_list,a1
;	addi	vclip_pal_list,a2
;	move	*a1,a1,L
;	move	*a2,a2,L
;	move	a1,@team_1_vidpal,L
;	move	a2,@team_2_vidpal,L
;	rets
;
;vclip_pal_list
;	.long	VIDEOSP
;	.long	VIDEOGRNP
;	.long	VIDEOTRQP
;	.long	VIDEOYELP
;	.long	VIDEOBLUP
;	.long	VIDEOREDP
;	.long	VIDEOBRNP
;	.long	VIDEOORGP
;

**************************************************************************
*								         *
* COPY_HEAD_PALS - COPY CONTENTS OF PLAYER 1, 2, 5, AND 6 HEAD PALETTES	 *
*                  TO THEIR ALTERNATE RAM PALETTES			 *
* 									 *
* PASS:									 *
* NUTIN'								 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************

COPY_HEAD_PALS
	MMTM	SP,A0,A1

	MOVI	player_1_headpal,A0
	MOVI	player_1_headpal_alt,A1
	MOVI	16*256*2/32,A14
CHP_LUPE12
	MOVE	*A0+,*A1+,L
	DSJS	A14,CHP_LUPE12

	MOVI	player_5_headpal,A0
	MOVI	player_5_headpal_alt,A1
	MOVI	16*256*2/32,A14
CHP_LUPE56
	MOVE	*A0+,*A1+,L
	DSJS	A14,CHP_LUPE56

	MMFM	SP,A0,A1
	RETS

**************************************************************************
*								         *
* ALLOCATE_ALT_HEAD_PALS						 *
* 									 *
* PASS:									 *
* NUTIN'								 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************

ALLOCATE_ALT_HEAD_PALS
	PUSH	A0
	MOVI	player_1_headpal_alt,A0
	CALLA	GETFPAL
	MOVI	player_2_headpal_alt,A0
	CALLA	GETFPAL
	MOVI	player_5_headpal_alt,A0
	CALLA	GETFPAL
	MOVI	player_6_headpal_alt,A0
	CALLA	GETFPAL
	PULLQ	A0
	RETS
	
**************************************************************************
*								         *
* DEALLOCATE_ALT_HEAD_PALS						 *
* 									 *
* PASS:									 *
* NUTIN'								 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************

DEALLOCATE_ALT_HEAD_PALS
	PUSH	A0
	MOVI	player_1_headpal_alt,A0
	CALLA	FINDPAL
	CALLA	FREEPAL
	MOVI	player_2_headpal_alt,A0
	CALLA	FINDPAL
	CALLA	FREEPAL
	MOVI	player_5_headpal_alt,A0
	CALLA	FINDPAL
	CALLA	FREEPAL
	MOVI	player_6_headpal_alt,A0
	CALLA	FINDPAL
	CALLA	FREEPAL
	PULLQ	A0
	RETS

**************************************************************************
*								         *
* find_special_character						 *
* 	input	match_b_* = initial/birthday data to match		 *
* 	output	a0 = -1 - no special character matched			 *
* 		a0 > 0  = special POF_CHARACTER matched			 *
*								         *
**************************************************************************
find_special_character
	mmtm	sp,a1,a2,a3,a4,a5,a6,a7
	MOVK	ADJTOURMODE,A0
	CALLA	GET_ADJ				;SET TOURNAMENT MODE
	jrnz	fsc_n9
	movi	player_data+32,a6
	clr	a0
	movi	match_b_initial1,a14
	move	*a14+,a1,W
	move	*a14+,a2,W
	move	*a14+,a3,W
	move	*a14+,a4,W
	move	*a14+,a5,W
fsc_5	move	*a6+,a7,L
	jrz	fsc_n9
	inc	a0
	movb	*a7,a14
	cmp	a14,a1
	jrnz	fsc_5
	addk	8,a7
	movb	*a7,a14
	cmp	a14,a2
	jrnz	fsc_5
	addk	8,a7
	movb	*a7,a14
	cmp	a14,a3
	jrnz	fsc_5
	addk	8,a7
	movb	*a7,a14
	cmp	a14,a4
	jrnz	fsc_5
	addk	8,a7
	movb	*a7,a14
	cmp	a14,a5
	jrnz	fsc_5

	mmtm	sp,a0
	movi	AUD_SECRET_CHAR,a0
	calla	AUD1
	mmfm	sp,a0

	mmfm	sp,a1,a2,a3,a4,a5,a6,a7
	rets
fsc_n9	clr	a0
	dec	a0
	mmfm	sp,a1,a2,a3,a4,a5,a6,a7
	rets

create_players		;creates all players in the game
	callr	create_teams
	movi	panim_list1,a1

	movk	8,a4
	movk	1,a0
cppo3	cmpi	3,a0
	jrz	cppo2
	cmpi	7,a0
	jrz	cppo2
	GBLOCK	a0,a6
	move	*a6(POF_OBJECT),a8,L
	move	a8,*a1+,L
cppo2	inc	a0
	dsjs	a4,cppo3
	clr	a0
	move	a0,*a1+,L
	movi	panim_list2,a0
	move	a0,*a1+,L
	movk	8,a4
	movk	8,a0
appo3	cmpi	3,a0
	jrz	appo2
	cmpi	7,a0
	jrz	appo2
	GBLOCK	a0,a6
	move	*a6(POF_OBJECT),a8,L
	move	a8,*a1+,L
appo2	dec	a0
	dsjs	a4,appo3
	clr	a0
	move	a0,*a1+,L
	movi	panim_list1,a0
	move	a0,*a1+,L
	movk	1,a0
	move	a0,@panim_ok,W
	movi	panim_list1,a0
	move	a0,@anipllist,L
	rets

**************************************************************************
*								         *
* create_teams								 *
* 	input	@team1 = team 1						 *
* 		@team2 = team 2						 *
*								         *
**************************************************************************
create_teams
	CALLA	fix_curplyrs
	callr	set_video_palettes
	callr	set_bench_palettes
	move	@team1,a2,W
	move	@team1_home,a3,W
	clr	a5
	MOVE	@TEAM1_SWAP,A6,W
	callr	create_team
	move	@team2,a2,W
	move	@team2_home,a3,W
	movk	1,a5
	MOVE	@TEAM2_SWAP,A6,W
	callr	create_team
;	jauc	fix_curplyrs
	RETS

**************************************************************************
*								         *
* create_team								 *
* 	input	a2 = team_#						 *
* 		a3 = 0 - home, 1 - away					 *
* 		a5 = 0 - left side, 1 - right side			 *
* 		A6 = PLAYER SWAP INDEX					 *
*								         *
**************************************************************************
create_team
	mmtm	sp,a0,a1,a4,A7
	move	a2,a0
	calla	get_teams_goalie
	mmtm	sp,a0
	move	a2,a4
	sll	10,a4
	addi	team_data,a4
	move	*a4(64),a4,L		;PLAYER LIST TABLE

	MOVE	A4,A0
	CLR	A7			;ZERO NUMBER PLAYERS ON TEAM
CT_PLAYER_COUNT
	MOVE	*A0+,A14,W
	JRZ	CT_GET_SWAP_TABLE	;BR=END OF PLAYER LIST
	INC	A7			;ONE MORE PLAYER
	JRUC	CT_PLAYER_COUNT
CT_GET_SWAP_TABLE
	SUBK	2,A7			;OFFSET MINIMUM NUMBER OF PLAYERS (2)
	.if	DEBUG
	LOCKON	N
	.endif
	SLL	5,A7
	ADDI	SWAP_TABLES_TABLE,A7,L
	MOVE	*A7,A7,L		;GET SWAP TABLE
	ADDK	010H,A7			;SKIP NUMBER OF COMBOS
	SLL	5,A6
	ADD	A6,A7

	move	a5,a0
	sll	2,a0
	inc	a0			;first player on team
;	move	*a4+,a1,W		;player number

	MOVE	*A7+,A14,W		;GET PLAYER 1(5) PLAYER LIST OFFSET
	MOVE	A4,A6
	ADD	A14,A6
	MOVE	*A6,A1,W		;player number

	callr	create_player
	inc	a0
;	move	*a4+,a1,W

	MOVE	*A7+,A14,W		;GET PLAYER 2(6) PLAYER LIST OFFSET
	ADD	A14,A4
	MOVE	*A4,A1,W		;player number

	callr	create_player
	addk	2,a0
	mmfm	sp,a1
	callr	create_player
	mmfm	sp,a0,a1,a4,A7
	rets

**************************************************************************
*								         *
* create_player								 *
* 	input	a0  = number of player to create (1-8)			 *
* 		a1  = player # (individual)				 *
* 		a2  = team # (palette)					 *
* 		a3  = 1 - home, 0 - away				 *
*								         *
**************************************************************************
create_player
	mmtm	sp,a0,a1,a2,a3,a4,a6,a7,a8,a9,a10,a11		;since we seldom do this
	GBLOCK	a0,a6
	movb	a0,*a6(POF_NUMBER)

	MOVE	*A6(POF_LOCKED_CHAR),A14,W
	JRZ	CP_SET_CHAR				;BR=NO SPECIAL CHARACTER
	MOVE	A14,A1
CP_SET_CHAR
	move	a1,*a6(POF_CHARACTER),W
	move	a2,*a6(POF_TEAM),W
	move	a3,*a6(POF_HOME),W
	move	a0,a11
	sll	8,a11
	addi	cp_table-256,a11
	move	*a11+,a10,L
	call	a10

	.if	BILL & 1
	.ref	ARROW_INIT
	PUSH	A8
	MOVI	ARROW_INIT,B0
	CALLA	EASYMAKE
	MOVE	A8,A0
	PULLQ	A8
	MOVE	*A8(OPART1),A8,L
	MOVE	A8,*A0(ODATA),L
	.endif

	calla	create_mini_bar
	mmfm	sp,a0,a1,a2,a3,a4,a6,a7,a8,a9,a10,a11
	rets

cp_table
	.long	regular_player,PID_PLAYER_1,player1_init,player1_shadow_init,arrow_1_init,0,0,0
	.long	regular_player,PID_PLAYER_2,player2_init,player2_shadow_init,arrow_2_init,0,0,0
	.long	regular_player,PID_PLAYER_3,player3_init,player3_shadow_init,arrow_2_init,0,0,0
	.long	goalie_player,PID_PLAYER_4,player4_init,player4_shadow_init,0,0,0,0
	.long	regular_player,PID_PLAYER_5,player5_init,player5_shadow_init,arrow_3_init,0,0,0
	.long	regular_player,PID_PLAYER_6,player6_init,player6_shadow_init,arrow_4_init,0,0,0
	.long	regular_player,PID_PLAYER_7,player7_init,player7_shadow_init,arrow_4_init,0,0,0
	.long	goalie_player,PID_PLAYER_8,player8_init,player8_shadow_init,0,0,0,0

cp2p_table
	.long	regular_player,PID_PLAYER_1,player1_init,player1_shadow_init,arrow_1_init,0,0,0
	.long	regular_player,PID_PLAYER_2,player2_init,player2_shadow_init,arrow_3alt_init,0,0,0
	.long	regular_player,PID_PLAYER_3,player3_init,player3_shadow_init,arrow_3alt_init,0,0,0
	.long	goalie_player,PID_PLAYER_4,player4_init,player4_shadow_init,0,0,0,0
	.long	regular_player,PID_PLAYER_5,player5_init,player5_shadow_init,arrow_4alt_init,0,0,0
	.long	regular_player,PID_PLAYER_6,player6_init,player6_shadow_init,arrow_2alt_init,0,0,0
	.long	regular_player,PID_PLAYER_7,player7_init,player7_shadow_init,arrow_4alt_init,0,0,0
	.long	goalie_player,PID_PLAYER_8,player8_init,player8_shadow_init,0,0,0,0

cp_extra_drone_table
	.long	regular_player,PID_PLAYER_4,player4p_init,player4p_shadow_init,arrow_3_init,0,0,0
	.long	regular_player,PID_PLAYER_8,player8p_init,player8p_shadow_init,arrow_3_init,0,0,0

cp_back_to_goalie_table
	.long	goalie_player,PID_PLAYER_4,player4_init,player4_shadow_init,0,0,0,0
	.long	goalie_player,PID_PLAYER_8,player8_init,player8_shadow_init,0,0,0,0

goalie_to_drone		;a0 = 4 or 8 for player number
	clr	a2
	GBLOCK	a0,a6
	move	*a6(POF_OBJECT),a8,L	;goalie object
	mmtm	sp,a8
	calla	DELETE_OBJ
	move	a2,*a6(POF_OBJECT),L
	move	*a6(POF_SHADOW),a8,L
	calla	DELETE_OBJ
	move	a2,*a6(POF_SHADOW),L
	move	*a6(POF_ARROW),a8,L
	jrz	gtd1
	calla	DELETE_OBJ
	move	a2,*a6(POF_ARROW),L
gtd1	move	*a6(POF_ARROW_CPU),a8,L
	jrz	gtd2
	calla	DELETE_OBJ
	move	a2,*a6(POF_ARROW_CPU),L
gtd2	movb	*a6(POF_NUMBER),a11
	sll	6,a11
	addi	cp_extra_drone_table-256,a11
	movi	s_mark_messier,a0
	move	a0,*a6(POF_CHARACTER),W
	move	*a11+,a10,L
	call	a10
	move	*a6(POF_OBJECT),a8,L
	mmfm	sp,a9
	movk	16,a0
	movi	panim_list1,a1
ppl3	move	*a1,a14,L
	cmp	a14,a9
	jrnz	ppl2
	move	a8,*a1,L
ppl2	addk	32,a1
	dsjs	a0,ppl3
	rets

reset_all_pulled_goalies
	mmtm	sp,a0,a1,a2,a6,a10,a11
	movk	4,a0
	move	@PLAYER_4_BLOCK+POF_FLAGS,a14,W
	btst	B_PF_GOALIE,a14
	jrnz	rap1
	callr	drone_to_goalie
rap1	movk	8,a0
	move	@PLAYER_8_BLOCK+POF_FLAGS,a14,W
	btst	B_PF_GOALIE,a14
	jrnz	rap2
	callr	drone_to_goalie
rap2	mmfm	sp,a0,a1,a2,a6,a10,a11
	rets

drone_to_goalie		;a0 = 4 or 8 for player number
	clr	a2
	GBLOCK	a0,a6
	move	*a6(POF_OBJECT),a8,L	;goalie object
	mmtm	sp,a8
	calla	DELETE_OBJ
	move	a2,*a6(POF_OBJECT),L
	move	*a6(POF_SHADOW),a8,L
	calla	DELETE_OBJ
	move	a2,*a6(POF_SHADOW),L
	move	*a6(POF_ARROW),a8,L
	jrz	dtg1
	calla	DELETE_OBJ
	move	a2,*a6(POF_ARROW),L
dtg1	move	*a6(POF_ARROW_CPU),a8,L
	jrz	dtg2
	calla	DELETE_OBJ
	move	a2,*a6(POF_ARROW_CPU),L
dtg2	movb	*a6(POF_NUMBER),a11
	sll	6,a11
	addi	cp_back_to_goalie_table-256,a11
	move	*a6(POF_TEAM),a0,W
	callr	get_teams_goalie
	move	a0,*a6(POF_CHARACTER),W
	move	*a11+,a10,L
	call	a10
	move	*a6(POF_OBJECT),a8,L
	mmfm	sp,a9
	movk	16,a0
	movi	panim_list1,a1
plp3	move	*a1,a14,L
	cmp	a14,a9
	jrnz	plp2
	move	a8,*a1,L
plp2	addk	32,a1
	dsjs	a0,plp3
	rets

**************************************************************************
*								         *
* get_teams_goalie							 *
* 	input	a0 = team number (1-26)					 *
* 	output	a0 = character number for goalie			 *
*								         *
**************************************************************************
get_teams_goalie
	sll	10,a0
	addi	team_data,a0
	move	*a0(0220h),a0,L
	move	*a0,a0,W
	rets

goalie_player
	movk	1,a0
	movb	a0,*a6(POF_DIRECTION)

	MOVI	M_PF_CONTROL|M_PF_GOALIE,A0
	MOVE	A0,*A6(POF_FLAGS),L

	move	*a11+,A2,L
	move	*a11+,a14,L
	move	a14,b0
	calla	EASYMAKE
	movi	AA53F03,a1
	move	*a8(OCTRL),a4,W
	calla	ANI
	CALLA	CLR_ODATA
	move	a8,*a6(POF_OBJECT),L
	move	a6,*a8(ODT_PBK),L
	MOVI	M_PUCKCHECK,A14
	MOVE	A14,*A8(ODT_GFLAGS),W		;SET PUCK CHECKING ON
	MOVI	GSTAND_COLLRANGE,A14
	MOVE	A14,*A6(POF_D_COLL),W		;SET STANDING COLLISION
	clr	a0
	movb	a0,*a6(POF_BDIRECTION)
	MOVE	A2,A1
	movb	*a6(POF_NUMBER),a10
	movi	control_goalie,a7
	calla	KILL_AND_GETPPRC
	MOVE	*A6(POF_TEAM),A1,W
	cmpi	26,a1
	jrls	nonrt1
	callr	find_a1_real_team
nonrt1	MOD_COL	a1			;modify a1 based if colorado
	SLL	10,A1
	ADDI	team_data,A1
	MOVE	*A1(0A0H),A0,L			;visitor PAL
	MOVE	*A6(POF_HOME),A14,W
	JRZ	GP_PAL
	MOVE	*A1(0E0H),A0,L			;home PAL
GP_PAL
	MOVE	A0,*A6(POF_NORMALPAL),L
	CALLA	CHANGE_PAL			;CHANGE UNIFORM PALETTE, BASED ON TEAM

	MOVE	*A6(POF_PUP_FLAGS),A2,W
	MOVE	@DIPSWITCH,A14,W
	BTST	11,A14
	JRNZ	GP_GET_HEAD_SCALE_TABLE		;BR=NORMAL

	MOVE	A2,A14
	ANDI	M_PUP_HEADS,A14
	JRNZ	GP_GET_HEAD_SCALE_TABLE		;BR=HEAD SET
	ORI	M_PUP_BIGHEAD,A2		;FORCE BIGHEAD
	MOVE	A2,*A6(POF_PUP_FLAGS),W

GP_GET_HEAD_SCALE_TABLE
	ANDI	M_PUP_HEADS,A2
	JRZ	GP_ADD_TABLE			;BR=NO POWERUP
	LMO	A2,A2
	SUBK	32,A2
	ABS	A2
	SLL	5,A2
GP_ADD_TABLE
	ADDI	HEAD_SCALES_TABLE,A2
	move	*a6(POF_CHARACTER),a14,W
	sll	5,a14
	addi	player_data,a14
	move	*a14,a14,L
	move	*a14(TP_HELMET_OFF),a14,L
	jrz	fgzb1
	MOVI	HEAD_ASPECT_SCALES_TABLE,A2
fgzb1	MOVE	*A2,A2,L
	movi	head_init,b0
	calla	EASYMAKE
	MOVE	A2,*A8(OSCTAB),L
	move	*a6(POF_OBJECT),a9,L
	move	a9,*a9(OPART1),L		;
	move	a9,*a8(OPART1),L		; make the head part 2 of multiparter
	move	a8,*a9(OPARTS),L		;
	calla	start_head_script
	callr	goalie_head_scale_fix
	move	*a11+,a14,L
	move	a14,b0
	calla	EASYMAKE
	move	a8,*a6(POF_SHADOW),L
	CLR	A0				;STAND
	move	a0,*a6(POF_ARROW),L
	move	a0,*a6(POF_ARROW_CPU),L
	move	a0,*a6(POF_MODE),W
	move	*a6(POF_TEAM),a0,W
	move	*a6(POF_CHARACTER),a9,W
	sll	5,a9
	addi	player_data,a9
	move	*a9,a9,L
	move	*a6(POF_OBJECT),a8,L
	callr	read_player_data
;	callr	fix_trail_palette
	jruc	fix_head_palette

goalie_head_scale_fix
irbe_head_fix
	move	*a6(POF_CHARACTER),a0,W
	cmpi	s_arturs_irbe,a0
	jrnz	ihf9
	move	*a8(OSCTAB),a14,L
	cmpi	zscale_50_50_table,a14
	jrnz	ihf9
	movi	zscale_55_55_table,a14
	move	a14,*a8(OSCTAB),L
ihf9	rets


regular_player
	clr	a0
	movb	a0,*a6(POF_TOP_MODE)
	move	a0,*a6(POF_TURBO_BOX),L
	move	a0,*a6(POF_TURBO_BAR),L
	move	a0,*a6(POF_TURBO_NAME),L
	move	a0,*a6(POF_BUTTONS),W		;clear out buttons (in case we are a drone)
	move	a0,*a6(POF_DRONE1),W		;clear out drone logic
	movb	a0,*a6(POF_BDIRECTION)
	move	a0,*a6(POF_TIRED),W
	movk	5,a0
	movb	a0,*a6(POF_DIRECTION)
	MOVE	*A6(POF_FLAGS),A0,L
	ANDI	M_PF_HUMAN,A0			;RESET ALL OTHER BITS
	ORI	M_PF_CONTROL,A0
	MOVE	A0,*A6(POF_FLAGS),L
	move	*a11+,a1,L
	movb	*a6(POF_NUMBER),a10
	movi	control_player,a7
	calla	KILL_AND_GETPPRC
	move	*a11+,a14,L
	move	a14,b0
	calla	EASYMAKE
	movi	AA53F03,a1
	move	*a8(OCTRL),a4,W
	calla	ANI
	CALLA	CLR_ODATA
	move	a8,*a6(POF_OBJECT),L
	move	a6,*a8(ODT_PBK),L
	MOVK	STAND_COLLRANGE,A14
	MOVE	A14,*A6(POF_D_COLL),W		;SET STANDING COLLISION
	move	*a11+,a14,L
	move	a14,b0
	calla	EASYMAKE
	move	a8,*a6(POF_SHADOW),L
ttbo	movi	[71,0],a0
	move	a0,*a6(POF_TURBO_AMOUNT),L
	move	*a11+,a14,L
	move	a14,b0
	calla	EASYMAKE
	movi	0e0eh,a14
	move	a14,*a8(OCONST),W
	move	a8,*a6(POF_ARROW),L
	movi	100,a0
	move	a0,*a6(POF_ARROW_TIME),W
	clr	a8
	move	@GAME_STATE,a14,W
	cmpi	INAMODE,a14
	jrz	ttboj1
	move	@BABY_SIZE,a14,W
	jrnz	ttboj1
	move	*a6(POF_CHARACTER),a14,W
	cmpi	s_jack_h_haeger,a14
	jrz	ttboj1
	cmpi	s_jennifer_fedesna,a14
	jrz	ttboj1
	movi	cpu_init,b0
	calla	EASYMAKE
	calla	INSERT_OBJ
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	ttboj1
	movi	GFONT10CP,a0
	calla	CHANGE_PAL
ttboj1	move	a8,*a6(POF_ARROW_CPU),L
	MOVI	HEAD_SCALES_TABLE,A2
	move	*a6(POF_CHARACTER),a14,W
	sll	5,a14
	addi	player_data,a14
	move	*a14,a14,L
	move	*a14(TP_HELMET_OFF),a14,L
	jrz	fzb1
	MOVI	HEAD_ASPECT_SCALES_TABLE,A2
fzb1
	MOVE	*A6(POF_PUP_FLAGS),A3,W

	MOVI	M_PUP_TINYHEAD,A4
	MOVE	@BABY_SIZE,A14,W
	JRNZ	RP_CHECK_HEAD			;BR=BABY SIZE POWERUP

	MOVE	@DIPSWITCH,A14,W
	BTST	11,A14
	JRNZ	RP_GET_HEAD_SCALE_TABLE		;BR=NORMAL
	MOVI	M_PUP_BIGHEAD,A4		;FORCE BIGHEAD

RP_CHECK_HEAD
	MOVE	A3,A14
	ANDI	M_PUP_HEADS,A14
	JRNZ	RP_GET_HEAD_SCALE_TABLE		;BR=HEAD SET
	OR	A4,A3				;SET HEAD
	MOVE	A3,*A6(POF_PUP_FLAGS),W

RP_GET_HEAD_SCALE_TABLE
	ANDI	M_PUP_HEADS,A3
	JRZ	RP_ADD_TABLE			;BR=NO POWERUP
	LMO	A3,A3
	SUBK	32,A3
	ABS	A3
	SLL	5,A3
RP_ADD_TABLE
	ADD	A3,A2
	MOVE	*A2,A2,L

	movi	head_init,b0
	calla	EASYMAKE

	MOVE	A2,*A8(OSCTAB),L

	move	*a6(POF_OBJECT),a9,L
	move	a9,*a9(OPART1),L		;
	move	a9,*a8(OPART1),L		; make the head part 2 of multiparter
	move	a8,*a9(OPARTS),L		;
	calla	start_head_script
	move	*a6(POF_OBJECT),a8,L
	move	*a6(POF_TEAM),a9,W
	cmpi	26,a9
	jrls	nospt			;not a team # > 26
	callr	find_a9_real_team	;returns a new a9 or and old one
nospt	MOD_COL	a9			;modify a9 based if colorado
	sll	10,a9
	addi	team_data,a9
	movb	*a6(POF_NUMBER),a2
	sll	3,a2
	addi	numconl,a2
	movb	*a2,a2
	jrn	nonp1234		;he isn't
	move	a2,a4
	sll	7,a4		;palette address offset from data offset
	addi	player_1_turbopal,a4
	add	a9,a2
	move	*a9(080h),a0,L		;visitor regular pal
	move	*a2(0100h),a1,L		;visitor turbo pal
	move	*a6(POF_HOME),a14,W
	jrz	pih_1
	move	*a9(0c0h),a0,L		;home regular pal
	move	*a2(0180h),a1,L		;home turbo pal
pih_1	move	a0,*a6(POF_NORMALPAL),L
	move	a0,a3
	calla	GETFPAL
;move colors from a3 (normal pal), and a1 (turbo pal reference) into area a4 (turbo pal)
	move	a3,a0
	move	a4,a9
	movi	28,a14		;palsize and 0-26 from normal pal
	callr	movepal_a0_to_a4
	movk	8,a14		;27-34 from turbo pal
	callr	movepal_a1_to_a4
	movi	73,a14		;35-107 from normal pal
	callr	movepal_a0_to_a4
	movk	20,a14		;108-127 from turbo pal
	callr	movepal_a1_to_a4
	move	a9,*a6(POF_TURBOPAL),L
	move	a9,a0
	calla	GETFPAL
	move	a3,a0
	calla	CHANGE_PAL			;change uniform palette, based on team
	move	*a6(POF_CHARACTER),a9,W
	sll	5,a9
	addi	player_data,a9
	move	*a9,a9,L			;a9 points to players data
	callr	read_player_data
	callr	fix_trail_palettes
	jruc	fix_head_palette

**************************************************************************
*								         *
* find_a9_real_team							 *
* 	input	a9 = team # (> 26)					 *
* 		a6 = player block					 *
* 	output	a9 = input a9 (if no team <= 26 found)			 *
* 		   = a9 of player's 'real' team				 *
*								         *
**************************************************************************
find_a2_real_team
	mmtm	sp,a9
	move	a2,a9
	callr	find_a9_real_team
	move	a9,a2
	mmfm	sp,a9
	rets
find_a1_real_team
	mmtm	sp,a9
	move	a1,a9
	callr	find_a9_real_team
	move	a9,a1
	mmfm	sp,a9
	rets
find_a9_real_team
	mmtm	sp,a0,a2,a3
	move	*a6(POF_CHARACTER),a3,W
	movk	26,a0
frt1	callr	isplt
	jrc	frt8
	dsjs	a0,frt1
	mmfm	sp,a0,a2,a3
	rets
frt8	move	a0,a9
	mmfm	sp,a0,a2,a3
	rets
isplt	move	a0,a1
	sll	10,a1
	addi	team_data,a1
	move	*a1(TD_MEMBER1_LIST),a2,L		;team list (we don't check extended)
	callr	sra2
	jrc	sray
	move	*a1(TD_MEMBER2_LIST),a2,L		;team list (we don't check extended)
	callr	sra2
	jrc	sray
	move	*a1(TD_GOALIE_LIST),a2,L
sra2	move	*a2+,a14,W
	jrz	sran
	cmp	a14,a3
	jrnz	sra2
sray	setc
	rets
sran	clrc
	rets

movepal_a0_to_a4
ampl3	move	*a0+,*a4+,W
	addk	16,a1
	dsjs	a14,ampl3
	rets

movepal_a1_to_a4
ampl4	move	*a1+,*a4+,W
	addk	16,a0
	dsjs	a14,ampl4
	rets

fix_trail_palettes
	movb	*a6(POF_NUMBER),a4
	dec	a4
	sll	12,a4
	addi	player_1_trailpal,a4		;a4 is our destination palette
	move	a4,a11
	addi	player_1_redpal-player_1_trailpal,a11
	move	a4,*a6(POF_TRAIL_PAL),L
	move	a11,*a6(POF_REDPAL),L
	move	*a6(POF_NORMALPAL),a1,L
	move	*a1+,a14,W
	move	a14,*a4+,W
	move	a14,*a11+,W
	movi	128,a5
	movk	3,a2
ftpft1	move	*a1+,a7,W
	move	a7,a9
	move	a7,a10
	sll	27,a7
	srl	27,a7		;b
	sll	22,a9
	srl	27,a9		;g
	sll	17,a10
	srl	27,a10		;r
	subk	31,a7
	sra	2,a7
	addk	31,a7
	subk	31,a9
	sra	1,a9
	addk	31,a9
	subk	31,a10
	sra	1,a10
	addk	31,a10
	sll	5,a9
	sll	10,a10
	add	a9,a7
	add	a10,a7
	move	a7,*a4+,W
	srl	10,a7
	sll	10,a7
	move	a7,*a11+,W
	dsj	a5,ftpft1
	move	*a6(POF_REDPAL),a0,L
	calla	GETFPAL
	move	*a6(POF_TRAIL_PAL),a0,L
	jauc	GETFPAL

fix_head_palette
	mmtm	sp,a0,a1,a2,a4,a9
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	fhp_goalie
g_no_h	move	*a6(POF_CHARACTER),a0,W
	sll	5,a0
	addi	player_data,a0
	move	*a0,a0,L
	move	*a0(TP_HELMET_TYPE),a0,W
	sll	5,a0
	addi	helmet_type_plist,a0
	move	*a0,a0,L
	move	*a6(POF_TEAM),a2,W
	cmpi	26,a2
	jrls	fhpha
	callr	find_a2_real_team
fhpha	MOD_COL	a2			;modify a2 based if colorado
	sll	10,a2
	addi	team_data,a2
	move	*a2(TD_HOME_HELMET),a1,W
	move	*a6(POF_HOME),a14,W
	jrnz	fhp1
	move	*a2(TD_AWAY_HELMET),a1,W
fhp1	sll	5,a1
	add	a1,a0
	move	*a6(POF_HEAD_TABLE),a1,L	;head table
	move	*a1,a1,L			;first head img
	move	*a1(ICMAP),a1,L			;a1 is palette of head image
	move	*a1,a2,W			;palette size

	move	*a6(POF_CHARACTER),a14,W
	sll	5,a14
	addi	player_data,a14
	move	*a14,a14,L
	move	*a14(TP_HELMET_OFF),a14,L
	jrz	fhp20
	move	a1,a0
	jruc	fhp21
fhp20	move	*a0,a0,L		;a0 is our helmet palette
fhp21	movb	*a6(POF_NUMBER),a4
	dec	a4
	sll	12,a4
	addi	player_1_headpal,a4		;a4 is our destination palette
	move	a4,a9
	movk	1,a14
	callr	movepal_a1_to_a4	;move our size (from face)
	movi	32,a14
	callr	movepal_a0_to_a4	;move 32 palette entries (helmet)
	move	a2,a14
	subk	32,a14
	jrz	notmore
	jrn	notmore
	callr	movepal_a1_to_a4	;move the rest of our palette (face)
notmore	move	a9,a0
	move	*a6(POF_OBJECT),a8,L
	move	*a8(OPARTS),a8,L	;get us from anywhere to our head
	calla	CHANGE_PAL		;now give us a new palette
	mmfm	sp,a0,a1,a2,a4,a9
	rets

fhp_goalie
	move	*a6(POF_CHARACTER),a0,W
	sll	5,a0
	addi	player_data,a0
	move	*a0,a0,L
	move	*a0(TP_HELMET_OFF),a14,W
	jrnz	g_no_h
	move	*a0(TP_HELMET_TYPE),a0,W
	sll	5,a0
	addi	helmet_type_plist,a0
	move	*a0,a0,L
	move	*a6(POF_TEAM),a2,W
	cmpi	26,a2
	jrls	fhphb
	callr	find_a2_real_team
fhphb	MOD_COL	a2			;modify a2 based if colorado
	sll	10,a2
	addi	team_data,a2
	move	*a2(TD_GOALIE_HELMET),a1,W
	sll	5,a1
	add	a1,a0
	move	*a0,a0,L
	move	*a6(POF_OBJECT),a8,L
	move	*a8(OPARTS),a8,L	;get us from anywhere to our head
	calla	CHANGE_PAL
	mmfm	sp,a0,a1,a2,a4,a9
	rets

nonp1234
	move	*a9(080h),a0,L		;visitor regular pal
	move	*a6(POF_HOME),a14,W
	jrz	piph_1
	move	*a9(0c0h),a0,L		;home regular pal
piph_1	move	a0,*a6(POF_NORMALPAL),L
	move	a0,a3
	calla	GETFPAL
	move	a3,a0
	calla	CHANGE_PAL			;change uniform palette, based on team
	move	*a6(POF_CHARACTER),a9,W
	sll	5,a9
	addi	player_data,a9
	move	*a9,a9,L			;a9 points to players data
	;

read_player_data
	addi	64,a9				;initials and birthday
	move	*a9+,a0,L			;head table
	subi	64,a0
	move	a0,*a6(POF_HEAD_TABLE),L
	move	*a9+,a0,L			;head palette
nohead	move	*a6(POF_OBJECT),a8,L
	move	*a9+,a0,L			;shot table
	move	a0,*a6(POF_S_STAB),L
	move	*a9+,a0,L			;scale table
	move	@BABY_SIZE,a14,W
	jrz	makeok				;not baby size
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	makeok				;goalies not baby size
	movi	zscale_70_60_table,a0		;baby size
makeok	move	a0,*a8(OSCTAB),L
	move	*a9+,a0,W			;mass
	move	a0,*a6(POF_MASS),W
	addk	16,a9				;empty word
	movi	player_speed_data,a1
	callr	rpdb				;speed data
	move	a0,*a6(POF_S_SPED),L
	movi	player_stop_data,a1
	callr	rpdb				;stopping data
	move	a0,*a6(POF_S_STOP),L
	movi	player_corner_data,a1
	callr	rpdb				;cornering data
	move	a0,*a6(POF_S_CORN),L
	movi	player_shoot_data,a1
	callr	rpdb				;shooting data
	move	a0,*a6(POF_S_SHOT),L
	movi	player_pass_data,a1
	callr	rpdb				;passing data
	move	a0,*a6(POF_S_PASS),L
	movi	player_face_data,a1
	callr	rpdb				;dumping data
	move	a0,*a6(POF_S_FACE),L
	movi	player_handle_data,a1
	callr	rpdb				;puck handing data
	move	a0,*a6(POF_S_HAND),L
	movi	player_check_data,a1
	callr	rpdb
	move	a0,*a6(POF_S_CHEK),L
	move	a9,*a6(POF_IMAGE_TABLE),L	;image table
	movi	nul_script,a1
	jauc	start_panim_if_not
rpdb	movb	*a9,a0
	dec	a0
	addk	8,a9
	sll	5,a0
	add	a1,a0
	move	*a0,a0,L
	rets

numconl	.byte	-1
	.byte	0,32
	.byte	-1,-1
	.byte	64,96
	.byte	-1
	.byte	-1

	.even

replace_all_turbo_palettes
	movk	1,a1
	callr	ratp1
	movk	5,a1
ratp1	callr	ratp2
ratp2	GBLOCK	a1,a6
	move	*a6(POF_NORMALPAL),a0,L
	move	a0,*a6(POF_TURBOPAL),L
	move	*a6(POF_OBJECT),a8,L
	calla	CHANGE_PAL
	inc	a1
	rets

HEAD_SCALES_TABLE
	.long	zscale_50_50_table
	.long	zscale_100_100_table
	.long	zscale_130_130_table
	.long	zscale_43_43_table
	.long	zscale_150_55_table
	.long	zscale_50_50_table

HEAD_ASPECT_SCALES_TABLE
	.long	zscale_65_53_table
	.long	zscale_130_107_table
	.long	zscale_160_130_table
	.long	zscale_52_43_table
	.long	zscale_150_55_table
	.long	zscale_65_53_table

head_init
	.long	shadow3			;dummy image for initialization only
	.word	DMAGO,M_NOPARTANI
	.word	OM_OID|OM_INSERT
	.word	OID_HEAD

;head_init
;	.long	shadow3			;dummy image for initialization only
;;	.word	DMAWNZ,M_NOPARTANI
;	.word	DMAGO,M_NOPARTANI
;	.word	OM_OID|OM_INSERT|OM_SCTAB
;	.word	OID_HEAD
;	.long	zscale_50_50_table
;;	.long	zscale_100_100_table
;
;aspect_head_init
;	.long	shadow3			;dummy image for initialization only
;;	.word	DMAWNZ,M_NOPARTANI
;	.word	DMAGO,M_NOPARTANI
;	.word	OM_OID|OM_INSERT|OM_SCTAB
;	.word	OID_HEAD
;	.long	zscale_61_50_table
;;	.long	zscale_100_100_table
;
;aspect_BIG_HEAD_INIT
;	.long	shadow3			;dummy image for initialization only
;;	.word	DMAWNZ,M_NOPARTANI
;	.word	DMAGO,M_NOPARTANI
;	.word	OM_OID|OM_INSERT|OM_SCTAB
;	.word	OID_HEAD
;	.long	zscale_122_100_table

player1_init
	.long	shadow3			;dummy image for initialization only
	.word	DMAWNZ,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_1
	.long	[-350,0],0,[339,0]

player1_shadow_init
	.long	shadow3
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_1_SHAD

player2_init
	.long	shadow3			;dummy image for initialization only
	.word	DMAWNZ,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_2
	.long	[-350,0],0,[339,0]

player2_shadow_init
	.long	shadow3
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_2_SHAD

player3_init
	.long	shadow3			;dummy image for initialization only
	.word	DMAWNZ,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_3
	.long	[-100,0],0,[300,0]

player3_shadow_init
	.long	shadow3
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_3_SHAD

player4_init
	.long	shadow3			;dummy image for initialization only
	.word	DMAWNZ,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_4
	.long	LEFT_GOALIE_AT_GOAL,0,CENTER_Z

player4_shadow_init
	.long	shadow3
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_4_SHAD

player4p_init
	.long	shadow3			;dummy image for initialization only
	.word	DMAWNZ,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_4
	.long	0,0,TOP_SIDEBOARD_Z

player4p_shadow_init
	.long	shadow3
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_4_SHAD

player5_init
	.long	shadow3			;dummy image for initialization only
	.word	DMAWNZ|DMAHFL,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_5
	.long	[350,0],0,[339,0]

player5_shadow_init
	.long	shadow3
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_5_SHAD

player6_init
	.long	shadow3			;dummy image for initialization only
	.word	DMAWNZ|DMAHFL,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_6
	.long	[350,0],0,[339,0]

player6_shadow_init
	.long	shadow3
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_6_SHAD

player7_init
	.long	shadow3			;dummy image for initialization only
	.word	DMAWNZ|DMAHFL,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_7
	.long	[100,0],0,[300,0]

player7_shadow_init
	.long	shadow3
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_7_SHAD

player8_init
	.long	shadow3			;dummy image for initialization only
	.word	DMAWNZ,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_8
	.long	RGHT_GOALIE_AT_GOAL,0,CENTER_Z

player8_shadow_init
	.long	shadow3
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_8_SHAD

player8p_init
	.long	shadow3			;dummy image for initialization only
	.word	DMAWNZ,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_8
	.long	0,0,TOP_SIDEBOARD_Z

player8p_shadow_init
	.long	shadow3
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_8_SHAD

arrow_1_init
	.long	arrow1t
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ARROW
	.long	[0,0],[0,0],[0,0]

arrow_2_init
	.long	arrow2t
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ARROW
	.long	[0,0],[0,0],[0,0]

arrow_3_init
	.long	arrow3t
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ARROW
	.long	[0,0],[0,0],[0,0]

arrow_4_init
	.long	arrow4t
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ARROW
	.long	[0,0],[0,0],[0,0]


arrow_2alt_init
	.long	arrow2t
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ARROW
	.long	[0,0],[0,0],[0,0]

arrow_3alt_init
	.long	arrow3t
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ARROW
	.long	[0,0],[0,0],[0,0]

arrow_4alt_init
	.long	arrow4t
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ARROW
	.long	[0,0],[0,0],[0,0]


cpu_init
	.long	cpu
;	.long	dummmy
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID
	.word	OID_CPU

dummmy	.word   04000H,8,10
	.long   077212e5H
	.word   0,0
	.long   GFONT10CP
