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
	.include	"edge.tbl"
	.include	"hhboards.tbl"
	.include	"dummy.tbl"
	.include	"HHGAME.TBL"
	.include	"hhgame.e"
	.include	"hhram.g"
	.include	"hhpuck.g"
	.include	"hhproc.g"
	.include	"hhmisc.g"
	.include	"hhd.g"
	.include	"hhmath.g"
	.include	"hhc.g"
	.include	"hhscore.g"
	.include	"hh.g"
	.include	"hhhigher.g"
	.include	"hhselect.g"
	.include	"hhplayer.g"
	.include	"hhtext.g"
	.include	"hhutil.g"
	.include	"hhfade.g"
	.include	"hhsnd.g"
	.include	"hhtimer.g"

; end of include files

	.bss	team1,16		;team 1 0-25
	.bss	team2,16		;team 2 0-25
	.bss	team1_visitor,16
	.bss	team2_visitor,16
	.bss   	team1_score,16
	.bss	team2_score,16

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

;attract mode		inamode
;initial entry		inintro
;tonights matchup	inintro
;period one		inplay
;period over		ingame
;intermission		ingame
;buy in			ingame
;period two		inplay
;period over		ingame
;intermission		ingame
;buy in			ingame
;period three		inplay
; intermission		ingame
; buy in		ingame
; period overtime	inplay
;  period over		ingame
;game over		ingameov

player_start
	move	@GAME_STATE,a3,W
	movi	player_start_table,a1
ps_l	move	*a1,a2,W
	jrz	ps_9
	cmp	a2,a3
	jrz	ps_g
	addi	48,a1
	jruc	ps_l
ps_9	LOCKUP
ps_g	move	*a1(16),a2,L
	jump	a2

player_start_table
	WL	INGAME,pcheck_game
	WL	ININTRO,pcheck_intro
	WL	INPLAY,pcheck_play
	WL	INAMODE,pcheck_amode
	WL	INDIAG,pcheck_diag
	WL	INGAMEOV,pcheck_gameov
	WL	INEPILOG,pcheck_epilog
	.word	0

**************************************************************************
*								         *
* pcheck_intro - CHECK IF PLAYER MAY START DURING INTRO	GAME MODE	 *
* 									 *
* PASS:									 *
* A0 = PLAYER NUMBER							 *
* 									 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************

pcheck_intro
	callr	check_for_player
	JRC	PCI_DONE

	callr	start_player

;IF 2 PLAYER
;	CREATE	PID_IND,SELECT_TEAM_PROC
;ELSE
;	CREATE	PID_IND,SELECT_TEAM_PROC

PCI_DONE
	jauc	SUCIDE

pcheck_game
pcheck_play
	callr	check_for_player
	jrc	pcp_ig
	callr	start_player
pcp_ig	jauc	SUCIDE

pcheck_amode
	mmtm	sp,a0
	callr	start_game	;this better set a different mode
	mmfm	sp,a0
	jruc	player_start	;because goes back to the top

pcheck_diag
pcheck_gameov
pcheck_epilog
	jauc	SUCIDE

start_player
	PUSH	a0
	sll	4,a0
	addi	sp1_tof-16,a0
	move	*a0,a0,W
	movk	1,a1
	sll	a0,a1
	move	@PLAYER_BITS,a2
	or	a1,a2
	move	a2,@PLAYER_BITS
	PULLQ	a0
	callr	fix_curplyrs
	rets
sp1_tof	.word	0,1,1,1,2,3,3,3

start_game
	movi	ININTRO,a14
	move	a14,@GAME_STATE,W
	clr	a0
	move	a0,@team1_score,W
	move	a0,@team2_score,W
	move	a0,@period,W
	C_A_K	PID_SEQUENCE,game_start_sequence
	rets

game_start_sequence
	calla	attract_tune_end
	JSRP	initial_entry
	JSRP	tonights_matchup
	movk	1,a0
	move	a0,@period,W
	callr	period_start
	jauc	SUCIDE

restart_game_mode
	movi	INPLAY,a0
	move	a0,@GAME_STATE,W
	calla	create_puck
	calla	create_players
	calla	create_rink
	C_A_KP	PID_RINK_WATCH,rink_watch
	C_A_KP	PID_PUCK_WATCH,puck_watch
	C_A_K	PID_PLAYER_WATCH,player_watch
	C_A_KP	PID_GAME_TIMER,game_timer
	jruc	fix_curplyrs

game_over
	calla	kill_all_sound
	movi	INGAMEOV,a0
	move	a0,@GAME_STATE,W
	callr	MY_WIPEOUT
	clr	a0
	move	a0,@timer_on,W
	move	a0,@PLAYER_BITS,W
	callr	fix_curplyrs
	movi	gameover_init,b0
	calla	EASYMAKE
	SLEEP	60
	callr	MY_WIPEOUT
	calla	ATSTRT
	jauc	SUCIDE

gameover_init
	.long	gameover
	.word	DMAWNZ,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_DUMMYPAGE
	.long	[100,0],[60,0],0

initial_entry
	movi	ININTRO,a14
	move	a14,@GAME_STATE,W
	callr	MY_WIPEOUT

	RETP

	MOVK	15,A14
	MOVE	A14,@IRQSKYE,W

	MOVI	ENTER_INITIALS_MESS,A8
	JSRP	LM_PRINTF

	SLEEP	30
	callr	MY_WIPEOUT

	MOVK	15,A14
	MOVE	A14,@IRQSKYE,W

	MOVI	TOPBOX_INIT,B0
	CALLA	EASYMAKE

	MOVI	TOPBOX_SHADOW_INIT,B0
	CALLA	EASYMAKE

	MOVI	0101H,A14
	MOVE	A14,*A8(OCONST),W

	MOVI	TEAMS_INIT,B0
	CALLA	MULTIMAKE

	CLR	A10

IE_TEST_RESTART
	MOVE	A8,A9

	ADDI	0101H,A10
	ANDI	0303H,A10
	
IE_TEST_NEXT
	MOVE	*A9(OCTRL),A14,W
;	XORI	DMAWNZ,A14
	ORI	DMACZ,A14
	MOVE	A14,*A9(OCTRL),W

	MOVE	A10,*A9(OCONST),W

	SLEEP	10

	MOVE	*A9(OCTRL),A14,W
	XORI	DMACZ,A14
	ORI	DMAWNZ,A14
	MOVE	A14,*A9(OCTRL),W

	MOVE	*A9(OPARTS),A9,L
	JRNZ	IE_TEST_NEXT

	JRUC	IE_TEST_RESTART

IE_WAIT
	SLEEP	1
	JRUC	IE_WAIT

	RETP

ENTER_INITIALS_MESS
	MESS_MAC RD15FONT,3,200,80,COLOR_PWHITE,STRCNCO,0
	.STRING	"ENTER INITIALS FOR\nRECORD KEEPING?\n\nYES\nNO",0
	.EVEN

TOPBOX_PAL
	.word	2
	.word	0, 15 << 10 + 15 << 5 + 15

TOPBOX
	.word   00H,340,90
	.long   0F8000000H
	.word   0,0
	.long   TOPBOX_PAL

TOPBOX_INIT
	.long	TOPBOX
	.word	DMACAL,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_JUNK
	.long	[30,0],[40,0],0

TOPBOX_SHADOW_INIT
	.long	TOPBOX
	.word	DMACAL,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_JUNK
	.long	[33,0],[43,0],1

;entry_init
;	.long	ientry
;	.word	DMAWNZ,M_SCRNOBJ
;	.word	OM_OID|OM_POS|OM_INSERT
;	.word	OID_DUMMYPAGE
;	.long	[100,0],[60,0],0
;
;entry1_init
;	.long	scbotlf
;	.word	DMAWNZ,M_SCRNOBJ
;	.word	OM_OID|OM_POS|OM_INSERT
;	.word	OID_DUMMYPAGE
;	.long	[200,0],[127,0],0
;
;entry2_init
;	.long	scbotrt
;	.word	DMAWNZ,M_SCRNOBJ
;	.word	OM_OID|OM_POS|OM_INSERT
;	.word	OID_DUMMYPAGE
;	.long	[200,0],[127,0],0
;
;entry3_init
;	.long	sctoplf
;	.word	DMAWNZ,M_SCRNOBJ
;	.word	OM_OID|OM_POS|OM_INSERT
;	.word	OID_DUMMYPAGE
;	.long	[200,0],[127,0],0
;
;entry4_init
;	.long	sctoprt
;	.word	DMAWNZ,M_SCRNOBJ
;	.word	OM_OID|OM_POS|OM_INSERT
;	.word	OID_DUMMYPAGE
;	.long	[200,0],[127,0],0

TEAMS_INIT
	.byte	 26, 0, 0, 2	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	easternp	;IMGPAL
	.long	westernp	;IMGPAL
	.word	OID_JUNK, OM_POS|OM_INSERT	;OID, GLOBAL_OPTIONS
	.long	[220,0],[128,0],-1
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS 

	LWWWW	boston, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	buffalo, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	hartford, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	montreal, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	ottowa, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	pittsburgh, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	quebec, DMAWNZ, M_SCRNOBJ, 0, 0

	LWWWW	florida, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	newjersey, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	nyislander, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	nyranger, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	philadelphia, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	tampabay, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	washington, DMAWNZ, M_SCRNOBJ, 0, 0

	LWWWW	chicago, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	dallas, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	detroit, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	stlouis, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	toronto, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	winnipeg, DMAWNZ, M_SCRNOBJ, 0, 0

	LWWWW	anaheim, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	calgary, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	edmonton, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	losangeles, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	sanjose, DMAWNZ, M_SCRNOBJ, 0, 0
	LWWWW	vancouver, DMAWNZ, M_SCRNOBJ, 0, 0


tonights_matchup
	callr	MY_WIPEOUT
	movi	match_init,b0
	calla	EASYMAKE
	SLEEP	20
	RETP

match_init
	.long	tmatch
	.word	DMAWNZ,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_DUMMYPAGE
	.long	[100,0],[60,0],0

period_start
	calla	set_background_tune
	callr	MY_WIPEOUT
	callr	restart_game_mode
	calla	init_timer_value
	clr	a0
	move	a0,@timer_on,W
	move	a0,@score_on,W
	movi	400,a0			;take us through to face off
	calla	show_timer_t		;show timer for a while
	jauc	faceoff

period_over
	calla	kill_all_sound
	movi	PID_SEQUENCE,a14
	move	a14,*a13(PROCID),W	;set our id
	movi	INGAME,a0,W
	move	a0,@GAME_STATE,W
	calla	stop_timer
	clr	a0
	move	a0,@timer_on,W		;so when we turn it on next, is not <0
	movi	200,a0
	calla	show_timer_ts		;show timer for 3 seconds
	movi	101,a0
	move	a0,@PUCK_MODE,W		;puck is in period over mode
	move	@PUCK_OBJECT,a8,L
	move	*a8(ODT_VEL),a1,L
	sra	3,a0
	move	*a8(ODT_DIR),a0,L
	calla	set_obj_to_polar

	movi	nolist,a0
	calla	FADE_FULL2HALF
	SLEEP	100
	jruc	intermission

nolist	.long	T2FIXED
	.long	TEXTPAL
	.long	0

intermission
	callr	MY_WIPEOUT
	move	@period,a0,W
	cmpi	3,a0
	jaz	game_over
	movi	intermission_init,b0
	calla	EASYMAKE
	SLEEP	20
	jruc	buy_in

intermission_init
	.long	intrmson
	.word	DMAWNZ,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_DUMMYPAGE
	.long	[100,0],[60,0],0

buy_in
	callr	MY_WIPEOUT
	movi	buyin_init,b0
	calla	EASYMAKE
	SLEEP	20
	move	@period,a0,W
	inc	a0
	move	a0,@period,W
	callr	period_start
	jauc	SUCIDE

buyin_init
	.long	buyin
	.word	DMAWNZ,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_DUMMYPAGE
	.long	[100,0],[60,0],0

player_watch
pwc_0	movi	pwmst,a10
	callr	pw_msh
	callr	pw_mph
	SLEEP	1
	jruc	pwc_0

pw_msh
	.if	nskaters=3
	movk	15+13,a5
	.else
	movk	15,a5
	.endif

pwms4	mmfm	a10,a9,a8,a7,a6
	move	*a9,a9,L	;object
	move	*a8,a8,L	;object
	move	*a8(OXPOS),a2,W
	move	*a8(OZPOS),a3,W
	move	*a9(OXPOS),a0,W
	move	*a9(OZPOS),a1,W

;	calla	find_dist_quick	;find quick, slightly incorrect distance

**************************************************************************
;find_dist_quick
**************************************************************************
	sub	a2,a0
	abs	a0
	sub	a3,a1
	abs	a1
	cmp	a1,a0
	jrls	pw_fdq1
pw_fdq0	srl	1,a1
	move	a1,a4
	add	a0,a4
	jruc	pw_fdq_done
;	rets
pw_fdq1	srl	1,a0
	move	a0,a4
	add	a1,a4
pw_fdq_done
;	rets
**************************************************************************

	move	a4,*a7,W	;store in distance block
	move	a4,*a6,W	;store in distance block
	dsjs	a5,pwms4
pwsxx	rets

pwmst	.long	PLAYER_1_BLOCK+POF_OBJECT,PLAYER_2_BLOCK+POF_OBJECT,PLAYER_2_BLOCK+POF_D_1P,PLAYER_1_BLOCK+POF_D_2P
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

	.if	nskaters=3

	.long	PLAYER_1_BLOCK+POF_OBJECT,PLAYER_7_BLOCK+POF_OBJECT,PLAYER_7_BLOCK+POF_D_1P,PLAYER_1_BLOCK+POF_D_7P

	.long	PLAYER_2_BLOCK+POF_OBJECT,PLAYER_7_BLOCK+POF_OBJECT,PLAYER_7_BLOCK+POF_D_2P,PLAYER_2_BLOCK+POF_D_7P

	.long	PLAYER_3_BLOCK+POF_OBJECT,PLAYER_1_BLOCK+POF_OBJECT,PLAYER_1_BLOCK+POF_D_3P,PLAYER_3_BLOCK+POF_D_1P
	.long	PLAYER_3_BLOCK+POF_OBJECT,PLAYER_2_BLOCK+POF_OBJECT,PLAYER_2_BLOCK+POF_D_3P,PLAYER_3_BLOCK+POF_D_2P
	.long	PLAYER_3_BLOCK+POF_OBJECT,PLAYER_4_BLOCK+POF_OBJECT,PLAYER_4_BLOCK+POF_D_3P,PLAYER_3_BLOCK+POF_D_4P
	.long	PLAYER_3_BLOCK+POF_OBJECT,PLAYER_5_BLOCK+POF_OBJECT,PLAYER_5_BLOCK+POF_D_3P,PLAYER_3_BLOCK+POF_D_5P
	.long	PLAYER_3_BLOCK+POF_OBJECT,PLAYER_6_BLOCK+POF_OBJECT,PLAYER_6_BLOCK+POF_D_3P,PLAYER_3_BLOCK+POF_D_6P
	.long	PLAYER_3_BLOCK+POF_OBJECT,PLAYER_7_BLOCK+POF_OBJECT,PLAYER_7_BLOCK+POF_D_3P,PLAYER_3_BLOCK+POF_D_7P
	.long	PLAYER_3_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_D_3P,PLAYER_3_BLOCK+POF_D_8P

	.long	PLAYER_4_BLOCK+POF_OBJECT,PLAYER_7_BLOCK+POF_OBJECT,PLAYER_7_BLOCK+POF_D_4P,PLAYER_4_BLOCK+POF_D_7P

	.long	PLAYER_5_BLOCK+POF_OBJECT,PLAYER_7_BLOCK+POF_OBJECT,PLAYER_7_BLOCK+POF_D_5P,PLAYER_5_BLOCK+POF_D_7P

	.long	PLAYER_6_BLOCK+POF_OBJECT,PLAYER_7_BLOCK+POF_OBJECT,PLAYER_7_BLOCK+POF_D_6P,PLAYER_6_BLOCK+POF_D_7P

	.long	PLAYER_7_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_OBJECT,PLAYER_8_BLOCK+POF_D_7P,PLAYER_7_BLOCK+POF_D_8P

	.endif

pw_mph	MOVK	8-1,A0
	movi	30,a9		;was 27 (and squared)
	movi	PLAYER_8_BLOCK,a7
	movi	PLAYER_BLOCK_SIZE,a10
	MOVI	POF_D_7P,A11
pwol
	.if	nskaters=3
	.else
	cmpi	3-1,a0
	jrz	pw_btol
	CMPI	7-1,A0
	JREQ	pw_btol				;BR=PLAYER 7 DOESN'T EXIST					
	.endif

	MOVE	A0,A1
	move	a7,a6
	add	a11,a6
pwil
	.if	nskaters=3
	.else
	cmpi	3,a1
	jrz	pw_btl
	CMPI	7,A1
	JREQ	pw_btl				;BR=PLAYER 7 DOESN'T EXIST					
	.endif

	move	*a6,a14,W
	cmp	a9,a14
	jrls	pw_sp				;BR=COLLISION
pw_btl	subk	16,a6
	dsjs	a1,pwil
pw_btol	sub	a10,a7
	SUBK	16,A11
	dsjs	a0,pwol
	rets

pw_sp
	mmtm	sp,a0,a1,A2,A3,A4,A5,a6,A8,a9,A10,A11
	MOVE	A9,A2				;SAVE THE DISTANCE
	move	*a7(POF_OBJECT),a9,L
	move	a1,a0
	calla	get_player_block
	move	*a6(POF_OBJECT),a8,L
	MOVE	A8,A10
	move	*a9(OFLAGS),a5,W		;if player is off screen, no check
	move	*a8(OFLAGS),a14,W		;if player is off screen, no check
	or	a14,a5
	btst	B_OFSCRN,a5
	jrnz	pw8
	move	*a7(POF_FLAGS),a5,W
	move	*a6(POF_FLAGS),a14,W
	MOVE	A5,A11
	or	a14,A11
	btst	B_PF_HIGHER,a5
	jrnz	pw8

	MOVI	-9,A11

	BTST	B_PF_GOALIE,A5
	JRNZ	PW_SP_GO			;BR=MAX REPULSION IF GOALIE

	move	*a7(POF_TEAM),a7,W
	move	*a6(POF_TEAM),a6,W
	XOR	A7,A6
	JRNZ	PW_SP_GO
	MOVI	-10,A11
PW_SP_GO
	MOVE	A14,A6				;POF_FLAGS FOR OBJECT IN A8
	MOVE	A5,A7				;POF_FLAGS FOR OBJECT IN A9

	MOVE	*A8(OXVAL),A3,L
	MOVE	*A9(OXVAL),A4,L
	SUB	A4,A3
	MPYS	A2,A3

	MOVE	*A8(OXVEL),A0,L	
	MOVE	*A9(OXVEL),A5,L
	MOVE	A5,A14
	SUB	A0,A14
	ABS	A14
	SRA	16,A14
	JRZ	PW_SP_NO_XVEL
	MPYS	A14,A3	
PW_SP_NO_XVEL
	SRA	A11,A3

	ADD	A3,A0
	CLR	B1
	BTST	B_PF_GOALIE,A6
	JRNZ	PW_GOALIE_X8			;BR=DA GOALIE
	MOVE	A0,B1				;NEW XVEL FOR A8
;	MOVE	*A8(OZVEL),A1,L	
;	CALLA	set_obj_to_rect
PW_GOALIE_X8

	MOVE	A9,A8
	MOVE	A5,A0
	SUB	A3,A0
	CLR	B2
	BTST	B_PF_GOALIE,A7
	JRNZ	PW_GOALIE_X9			;BR=DA GOALIE
	MOVE	A0,B2				;NEW XVEL FOR A9
;	MOVE	*A8(OZVEL),A1,L	
;	CALLA	set_obj_to_rect
PW_GOALIE_X9

	MOVE	A10,A8

	MOVE	*A8(OZVAL),A3,L
	MOVE	*A9(OZVAL),A4,L
	SUB	A4,A3
	MPYS	A2,A3

	MOVE	*A8(OZVEL),A1,L	
	MOVE	*A9(OZVEL),A5,L	
	MOVE	A5,A14
	SUB	A1,A14
	ABS	A14
	SRA	16,A14	
	JRZ	PW_SP_NO_ZVEL
	MPYS	A14,A3
PW_SP_NO_ZVEL	
	SRA	A11,A3

;	MOVE	*A8(OXVEL),A0,L	
	MOVE	B1,A0
	ADD	A3,A1
	BTST	B_PF_GOALIE,A6
	JRNZ	PW_GOALIE_Z8			;BR=DA GOALIE
	CALLA	set_obj_to_rect
PW_GOALIE_Z8

	MOVE	A9,A8
;	MOVE	*A8(OXVEL),A0,L	
	MOVE	B2,A0
	MOVE	A5,A1
	SUB	A3,A1
	BTST	B_PF_GOALIE,A7
	JRNZ	PW_GOALIE_Z9			;BR=DA GOALIE
	CALLA	set_obj_to_rect
PW_GOALIE_Z9


;	MMTM	SP,A2,A3,A8
;	MOVE	*A9(ODT_DIR),A0,L
;	MOVE	*A9(ODT_VEL),A1,L
;	CALLA	polar_to_rect
;	MOVE	A0,A2
;	MOVE	A1,A3
;	MOVE	*A8(ODT_DIR),A0,L
;	MOVE	*A8(ODT_VEL),A1,L
;	CALLA	polar_to_rect
;	SWAP	A0,A2
;	SWAP	A1,A3
;	CALLA	set_obj_to_rect
;	MOVE	A9,A8
;	SWAP	A0,A2
;	SWAP	A1,A3
;	CALLA	set_obj_to_rect
;	MMFM	SP,A2,A3,A8


pw8	MMFM	sp,a0,a1,A2,A3,A4,A5,a6,A8,a9,A10,A11
	jruc	pw_btl

;pw_sp	mmtm	sp,a0,a1,a6,a9
;	move	*a7(POF_OBJECT),a9,L
;	move	a1,a0
;;	addk	4,a0
;	calla	get_player_block
;	move	*a6(POF_OBJECT),a8,L
;	move	*a9(OFLAGS),a5,W		;if player is off screen, no check
;	move	*a8(OFLAGS),a14,W		;if player is off screen, no check
;	or	a14,a5
;	btst	B_OFSCRN,a5
;	jrnz	pw8
;	move	*a7(POF_FLAGS),a5,W
;	move	*a6(POF_FLAGS),a14,W
;	or	a14,a5
;	btst	B_PF_HIGHER,a5
;	jrnz	pw8
;	move	*a8(OXVAL),a2,L
;	move	*a8(OZVAL),a3,L
;	move	*a9(OXVAL),a0,L
;	move	*a9(OZVAL),a1,L
;	move	*a8(ODT_VEL),a6,L
;	move	*a9(ODT_VEL),a14,L
;	cmp	a6,a14
;	jrlo	pwa8f
;	SWAP	a8,a9
;	SWAP	a0,a2
;	SWAP	a1,a3
;pwa8f	calla	find_dir_to_point_182
;	sll	6,a0
;	addi	fdptab-64,a0
;	move	*a0,a1,L
;	move	*a0(20h),a0,L
;	sub	a1,a2
;	sub	a0,a3
;	move	a2,*a8(OXVAL),L
;	move	a3,*a8(OZVAL),L
;	clr	a0
;	move	a0,*a8(ODT_VEL),L
;pw8	mmfm	sp,a0,a1,a6,a9
;	jruc	pw_btl
;
;fdptab	.long	[1,08000h],[5,0]
;	.long	[13,0],[13,0]	;unused
;	.long	[5,0],[-2,08000h]
;	.long	[13,0],[-13,0]	;unused
;	.long	[-2,08000h],[-5,0]
;	.long	[-13,0],[-13,0]	;unused
;	.long	[-5,0],[1,08000h]
;	.long	[-13,0],[13,0]	;unused

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
	rets

dpl_lst	.long	PLAYER_6_BLOCK
	.long	PLAYER_5_BLOCK
	.long	PLAYER_2_BLOCK
	.long	PLAYER_1_BLOCK


check_for_player
	PUSH	a0
	move	@PLAYER_BITS,a1,W
	sll	4,a0
	addi	sp2_tof-16,a0
	move	*a0,a0,W
	btst	a0,a1
	jrz	cfp_0
	PULLQ	a0
	setc
	rets
cfp_0	PULLQ	a0
	clrc
	rets

sp2_tof	.word	0,1,1,1,2,3,3,3

create_rink
	clr	a0
	move	a0,@world_mt_point,W
	move	a0,@WORLDX,L
	movk	1,a0
	move	a0,@rink_on
	calla	create_goals
	jruc	create_edge

create_goals
	movi	lgoalF_init,b0			;MAKE FRONT PART OF LEFT GOAL
	calla	EASYMAKE
	move	a8,@lgoalF_object,L
	movi	lgoalR_init,b0			;MAKE REAR PART OF LEFT GOAL
	calla	EASYMAKE
	move	a8,@lgoalR_object,L
	movi	rgoalF_init,b0			;MAKE FRONT PART OF RIGHT GOAL
	calla	EASYMAKE
	move	a8,@rgoalF_object,L
	movi	rgoalR_init,b0			;MAKE REAR PART OF RIGHT GOAL
	calla	EASYMAKE
	move	a8,@rgoalR_object,L
	rets

lgoalF_init
	.long	glbk6
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_GOAL
	.long	[-730,0],[0,0],[287,0]

lgoalR_init
	.long	glft6
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_GOAL
	.long	[-730,0],[0,0],[398,0]

rgoalF_init
	.long	glbk6
	.word	DMAWNZ|DMAHFL,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_GOAL
	.long	[730,0],[0,0],[287,0]

rgoalR_init
	.long	glft6
	.word	DMAWNZ|DMAHFL,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_GOAL
	.long	[730,0],[0,0],[398,0]

create_edge
	movi	ledge_init,b0
	calla	EASYMAKE
	move	a8,@ledge_object,L
	movi	ledge2_init,b0
	calla	EASYMAKE
	move	a8,@ledge2_object,L
	movi	redge_init,b0
	calla	EASYMAKE
	move	a8,@redge_object,L
	movi	redge2_init,b0
	calla	EASYMAKE
	move	a8,@redge2_object,L

	movi	-682,a2			;679.5
	movk	16,a3
cbw	movi	binit,b0
	calla	EASYMAKE
	clr	a0
	move	a0,*a8(OYPOS),W
	movi	680+2300,a0,W
	move	a0,*a8(OZPOS),W
	move	a2,*a8(OXPOS),W
	calla	INSERT_OBJ
	addi	85,a2
	dsjs	a3,cbw
	rets


binit	.long	board
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_BACKWALL
	.long	[0,0],[0,0],[680,0]

ledge_init
	.long	BK3402
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_EDGE
	.long	[-798+radius,0],[0,0],[2300+679,0]

redge_init
	.long	BK3402
	.word	DMAWNZ|DMAHFL,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_EDGE
	.long	[798-radius,0],[0,0],[2300+679,0]

ledge2_init
	.long	BK3403
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_EDGE
	.long	[-798+radius,0],[0,0],[0,0]

redge2_init
	.long	BK3403
	.word	DMAWNZ|DMAHFL,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_EDGE
	.long	[798-radius,0],[0,0],[0,0]

rink_watch
	movi	-124,a0
	move	a0,@WORLDY+010h,W
rw_0	callr	set_world_point
	callr	update_shifted_images
	SLEEP	1
	jruc	rw_0

set_world_point
	move	@PUCK_MODE,a0,W
	cmpi	1,a0			;face off?
	jrnz	rwps_u
	clr	a0
	jruc	sxcx			;freeze world during face off
rwps_u	move	@PUCK_OBJECT,a8,L
	movi	160,a1
	move	@PUCK_CONTROL,a0,W
	jrz	rw_tr
	calla	get_player_block
	move	*a6(POF_OBJECT),a8,L
	jruc	rw_t1
rw_tr	move	@PUCK_LAST_CONTROL,a0,W
rw_t1	move	a0,a0
	jrz	rw_z0
	move	*a8(OXVEL+010h),a14,W
	cmpi	2,a0
	jrls	rw_zp
	neg	a1
	move	a14,a14
	jrn	rw_o
	jrz	rw_o
	addi	33,a1
	jruc	rw_o
rw_zp	move	a14,a14
	jrnn	rw_o
	subi	33,a1
	jruc	rw_o
rw_z0	clr	a1
rw_o	move	a1,a2
	move	@world_mt_point,a1,W
	move	a1,a14
	movk	16,a3
	calla	move_to_speed_x
	cmp	a1,a14
	jrnz	rw_oa			;we are moving closer, so just keep going
	move	a2,a1			;we are stuck  just away from our destination, pick destination
rw_oa	move	a1,@world_mt_point,W
	move	*a8(OXPOS),a0,W
	add	a1,a0
	cmpi	585,a0
	jrlt	rw_a
	movi	585,a0
rw_a	cmpi	-585,a0
	jrgt	rw_b
	movi	-585,a0
rw_b
sc_to	;a0 = desired
	move	@WORLDX+010H,a1,W
	sub	a1,a0
	move	a0,a1
	sll	13,a0
	sll	11,a1
	add	a1,a0
	sll	1,a1
	add	a1,a0
	jrn	sxc1
	cmpi	[35,0],a0
	jrle	sxcx
	movi	[35,0],a0
	jruc	sxcx
sxc1	cmpi	[-35,0],a0
	jrgt	sxcx
	movi	[-35,0],a0
sxcx	move	a0,@SCROLLX,L
	rets

update_shifted_images
	move	@WORLDX+010H,a0
	abs	a0
	movi	goal_x_table,a10
	CALLR	IMGS_FROM_X			
	move	@lgoalF_object,a8,L		;CHANGE LEFT GOAL FRONT
	callr	ggol
	move	@rgoalF_object,a8,L		;CHANGE RIGHT GOAL FRONT
	callr	ggol
	MOVE	A5,A1				;CHANGE TO REAR
	move	@lgoalR_object,a8,L		;CHANGE LEFT GOAL REAR
	callr	ggol
	move	@rgoalR_object,a8,L		;CHANGE RIGHT GOAL REAR			
	callr	ggol
	movi	edge_x_table,a10
	callr	img_from_xx
	move	@ledge_object,a8,L
	callr	ggol
	move	@redge_object,a8,L
	callr	ggol
	move	a2,a1
	move	@ledge2_object,a8,L
	callr	ggol
	move	@redge2_object,a8,L
ggol	move	*a8(OIMG),a3,L
	cmp	a1,a3
	jrz	ggol2
	move	*a8(OCTRL),a4,W
	jauc	ANI
ggol2	rets

IMGS_FROM_X
ISFX_1	move	*a10+,a1,L			;FRONT IMAGE
	jrz	ISFX_9
	MOVE	*A10+,A5,L			;REAR IMAGE
	move	*a10+,a3,W			;WORLD X (UPPER WORD)
	cmp	a3,a0
	jrls	ISFX_2				;BR=NOT THERE YET
	jruc	ISFX_1
ISFX_2	rets
ISFX_9	LOCKUP

img_from_x
gtp_1	move	*a10+,a1,L
	jrz	gtp_9
	move	*a10+,a3,W
	cmp	a3,a0
	jrls	gtp_2
	jruc	gtp_1
gtp_2	rets
gtp_9	LOCKUP

img_from_xx
gtxp_1	move	*a10+,a1,L
	jrz	gtxp_9
	move	*a10+,a2,L
	move	*a10+,a3,W
	cmp	a3,a0
	jrls	gtxp_2
	jruc	gtxp_1
gtxp_2	rets
gtxp_9	LOCKUP

goal_x_table
	LLW	glbk6,glft6,518
	LLW	glbk4,glft4,534
	LLW	glbk3,glft3,550
	LLW	glbk2,glft2,566
	LLW	glbk1,glft1,999
	.long	0

;	LLW	goal31,goal31,518
;	LLW	goal33,goal33,534
;	LLW	goal34,goal34,550
;	LLW	goal35,goal35,566
;	LLW	goal36,goal36,999

edge_x_table
;	LW	B190,307
;	LW	C195,315
;	LW	E200,323
;	LW	C205,331
;	LW	E210,339
;	LW	C215,347
;	LW	E220,355
;	LW	C225,363
;	LW	E230,371
;	LW	C235,379
	LLW	BK240,BK3003,387
	LLW	BK245,BK3003,395
	LLW	BK250,BK3003,402
	LLW	BK255,BK3003,410
	LLW	BK260,BK3003,418
	LLW	BK265,BK3003,426
	LLW	BK270,BK3003,434
	LLW	BK275,BK3003,442
	LLW	BK280,BK3003,450
	LLW	BK285,BK3003,458
	LLW	BK290,BK3003,466
	LLW	BK295,BK3003,474
	LLW	BK3002,BK3003,482
	LLW	BK3052,BK3053,490
	LLW	BK3102,BK3103,498
	LLW	BK3152,BK3153,506
	LLW	BK3202,BK3203,514
	LLW	BK3252,BK3253,522
	LLW	BK3302,BK3303,530
	LLW	BK3352,BK3353,538
	LLW	BK3402,BK3403,546
	LLW	BK3452,BK3453,554
	LLW	BK3502,BK3503,562
	LLW	BK3552,BK3553,570
	LLW	BK3602,BK3603,578
	LLW	BK3652,BK3653,586
	LLW	BK3702,BK3703,594
	LLW	BK3752,BK3753,602
;	LW	BK380,610
;	LW	BK385,618
;	LW	BK390,999
	LLW	BK3752,BK3753,999
	.long	0



MY_WIPEOUT
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

