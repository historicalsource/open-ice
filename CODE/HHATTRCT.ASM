 	.MLIB	"HHMACS.LIB"
	.FILE	"HHATTRCT.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"HHAUDN.H"
	.INCLUDE	"IMGTBL.GLO"
	.INCLUDE	"HHATTRCT.TBL"
	.INCLUDE	"HHATT2.TBL"
	.include	"hhatt3.tbl"
	.include	"HHATT4.TBL"
	.include	"HHATT5.TBL"
	.include	"ARCH.TBL"
	.include	"SPARK.TBL"
	.INCLUDE	"BIGFOLEY.TBL"
	.include	"COOLEST.TBL"
	.include	"hhattrct.e"
	.include	"hhproc.g"
	.include	"hhd.g"
	.include	"hhram.g"
	.include	"hhsnd.g"
	.include	"hhutil.g"
	.include	"hhgame.g"
	.include	"hhpuck.g"
	.include	"hhselect.g"
	.include	"hhtimer.g"
	.include	"hhspeech.g"
	.include	"hhhigher.g"
	.include	"hhplayer.g"
	.include	"hh.g"
	.include	"hhmath.g"
	.include	"hhfade.g"
	.include	"hhmisc.g"
	.include	"hhpick.g"
	.include	"hhcoin.g"
	.include	"hhc.g"
	.include	"hhpall.g"
	.include	"hhstable.g"
	.include	"hhtext.g"
	.include	"hhcx.g"
	.include	"hhcmos.g"
	.include	"hhdtst.g"
	.include	"hhcontr2.g"
	.include	"hhafunc.g"
	.include	"hhscr_fn.g"
	.include	"hhpup.g"

; end of include files

	.TEXT
	.EVEN

	.bss	in_at_game,16		;we are playing attract mode
	.BSS	CREDIT_PAGE_JUMPS,16	;UHW NUMBER OF JUMPS LEFT
	.bss	amode_starting_point,16
	.bss	string_build_area,8*40

	.bss	sound_store_t1,16
	.bss	sound_store_c1,16
	.bss	sound_store_c2,16
	.bss	sound_store_fp,16

SHOW_GIRLS	EQU	0

	.if	SHOW_GIRLS
	.BSS	LAST_GIRL,16
	.endif

**************************************************************************
*								         *
* ATTRACT_MODE								 *
*								         *
**************************************************************************

JSLF	.macro	rt,tm
	JSRP	:rt:
	SLEEP	:tm:
	JSRP	atfadeall
	.endm

;JSSL	.macro	rt,tm
;	JSRP	:rt:
;	SLEEP	:tm:
;	.endm


ATT_MODE_COUNT		EQU	PDATA			;UHW LOOP COUNT

ATT_MODE_LIST_SUBR	EQU	PDATA+020H		;UHL LIST SUBROUTINE


ATT_MODE_TOPTEN
	jruc	atmt10


ATTRACT_MODE
	.if	self_play
	P_FORK	SW_34
	.ref	SW_34
	.endif

	CLR	A14
	MOVE	A14,*A13(ATT_MODE_COUNT),W
	SOUNDOFF
	CALLA	READ_DIP
	ANDI	DPATTSNDS,a0		; attract sounds ?
	JRNZ	atmsa
	SOUNDON
atmsa	move	@amode_starting_point,a0,W
	jrz	atms		;0 - normal atmode
	cmpi	1,a0
	jrz	atmt10		;1 - top ten
	jruc	atmtc		;2,3 - credits

atms
	.if	0 ;ATTRACT MODE TEST

	JSRP	do_attract_game
	JRUC	atms

;	JSLF	attract_hintpage,500
;	JRUC	atms

	.endif

;	JSLF	game_over_all_26,4


	.if	SHOW_GIRLS ;ATTRACT MODE TEST

	JSRP	maybe_high_scores
	JSLF	TOPTEN_TEAM_LIST,300

	CLR	A14
	MOVE	A14,@LAST_GIRL,W

	JSLF	attract_hintpage,500
	JSLF	attract_hintpage,500
	JSLF	attract_hintpage,500
	JSLF	attract_hintpage,500
	JSLF	attract_hintpage,500
	JSLF	attract_hintpage,500
	jsrp	game_over_all_26
	JRUC	atms

;	JSLF	attract_hintpage,300
;	JSLF	PATS_PAGE,180
;	JRUC	atms

;	JSLF	game_over_all_26,4
;	JSRP	do_attract_game
;	JRUC	atms

;	JSRP	maybe_high_scores
;	JSLF	TOPTEN_TEAM_LIST,300
;	JRUC	atms
	.endif

	JSLF	AAMA_ADVISORY_PAGE,120
	JSLF	attract_mode_nhl,240
	JSLF	attract_mode_nhlpa,240
	JSLF	attract_mode_archive,240
atms2	JSLF	TITLE_PAGE,300
	JSRP	do_attract_game
	JSLF	coolest_game,240
atmtc	JSRP	credits_stuff
atmt10	JSRP	maybe_high_scores
	JSLF	TOPTEN_TEAM_LIST,300
	JSLF	PATS_PAGE,180
	JSLF	EXCLUSIVE_PAGE,180
	JSLF	attract_hintpage,500

	MOVE	*A13(ATT_MODE_COUNT),A14,W
	INC	A14
	MOVE	A14,*A13(ATT_MODE_COUNT),W
	btst	0,a14
	jrz	atms2
	cmpi	4,a14
	jrls	atms
	SOUNDOFF
	jruc	atms

maybe_high_scores
	MOVK	ADJHSON,A0
	CALLA	GET_ADJ				;CHECK FOR DISPLAY
	jrz	atmt				;BR=NOPE
	JSLF	MOST_GAMES_LIST,300
	JSLF	MOST_POINTS_LIST,300
	JSLF	BEST_PCTG_LIST,300

	.if	SHOW_GIRLS
	.else
	MOVE	@stanley_data,A14,W
	JRZ	atmt				;BR=NOBODY
	.endif

	JSLF	STANLEY_CHAMPS_LIST,300
atmt	RETP

do_attract_game
	callr	start_attract_game
	SLEEP	2000
	jauc	stop_attract_game	;retp

credits_stuff
	callr	CREDIT_JUMP_CHECK
	JSRP 	CREDIT_SCREEN
	jauc	atfadeall	;retp from here

**************************************************************************
*								         *
* CREDIT_JUMP_CHECK - CHECK IF WE SHOULD RESTUFF CREDIT PAGE JUMPS	 *
* 									 *
* PASS:									 *
* NUTIN'								 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************

CREDIT_JUMP_CHECK
	MOVE	@WAVEIRQS,A14,L
	CMPI	60*60*3,A14
	JRLT	CJC_DONE			;BR=3 MINUTES NOT UP

	CLR	A1				;RESET CREDIT PAGE JUMPS
	MOVE	A1,@WAVEIRQS,L
	MOVK	3,A1
	MOVE	A1,@CREDIT_PAGE_JUMPS,W
CJC_DONE
	RETS

**************************************************************************
*								         *
* EXCLUSIVE_PAGE - DISPLAY "SPORTS EXCLUSIVE" PAGE			 *
* 									 *
* PASS:									 *
* NUTIN'								 *
*								         *
**************************************************************************

EXCLUSIVE_PAGE
	calla	MY_WIPEOUT

	BLACKON

;	MOVI	METAL_ICE_INIT,B0
;	CALLA	MULTIMAKE
;
;	MOVK	5,A0
;	CALLA	RAND0
;	SLL	6,A0
;	ADDI	EX_PALS_TABLE,A0
;	MOVE	*A0+,A2,L
;	MOVE	*A0,A0,L
;	CALLA	CHANGE_PAL_MULTI

	MOVI	EXCLUSIVE_INIT,B0
	CALLA	MULTIMAKE

;	MOVE	A2,A0
;	CALLA	CHANGE_PAL

	BLACKOFF

	CLR	A0
	CALLA	FADEIN				;FADE DOWN ALL PALETTES
	JSRP	FADE_WAIT

	RETP

EXCLUSIVE_INIT
	.byte	4, 0, 0, 1	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	SPRTEXP		;IMGPAL
	.word	OID_JUNK, OM_POS|OM_INSERT	;OID, GLOBAL_OPTIONS
	.long	[0,0],[0,0],0
	LWWWW	EXCLUSIVE_UL, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	EXCLUSIVE_UR, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	EXCLUSIVE_LL, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	EXCLUSIVE_LR, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0

attract_hintpage
	calla	MY_WIPEOUT
	BLACKON
	JSRP	build_random_hint
	BLACKOFF
	clr	a0
	calla	FADEIN				;FADE DOWN ALL PALETTES
	jauc	FADE_WAIT

**************************************************************************
*								         *
* build_random_hint							 *
*								         *
**************************************************************************
build_random_hint
	movi	ORGTXT1P,a0
	calla	GETFPAL
	movi	REDTXT4P,a0
	calla	GETFPAL
	movi	BLUTXT3P,a0
	calla	GETFPAL
	movi	HINT_PAGE_INIT,b0
	calla	MULTIMAKE

;	movi	file_init,b0
;	calla	EASYMAKE
;	movi	file_1_anim,a1
;	calla	STRT_ANIM
;	movi	hint_text_mess_title,a8
;	JSRP	LM_PRINTF

	.if	SHOW_GIRLS
	MOVE	@LAST_GIRL,A0,W
	MOVE	A0,A14
	INC	A14
	MOVE	A14,@LAST_GIRL,W
	.else
	movk	6,a0
	calla	RAND0
	.endif

	sll	5,a0
	addi	hint_list,a0
	move	*a0,a0,L
	jump	a0

hint_list
	.long	hint_1
	.long	hint_2
	.long	hint_3
	.long	hint_4
	.long	hint_5
	.long	hint_6

hint_1
	MOVI	SADIE_WHISTLE_INIT,B0
	CALLA	EASYMAKE
	movi	hint_text_mess_1_1,a8
	JSRP	LM_PRINTF
	movi	hint_text_mess_1_2,a8
	jauc	LM_PRINTF
hint_2
;	MOVI	HALEY_CLIPBOARD_INIT,B0
	MOVI	SADIE_POOLCUE_INIT,B0
	CALLA	EASYMAKE
	movi	hint_text_mess_2_1,a8
	JSRP	LM_PRINTF
	movi	hint_text_mess_2_2,a8
	jauc	LM_PRINTF
hint_3
	MOVI	HALEY_TIMER_INIT,B0
	MOVI	512,A0
	CALLA	RANDPER
	JRC	H3_GIRL
	MOVI	HALEY_DANCE_INIT,B0
H3_GIRL
	CALLA	EASYMAKE
	movi	hint_text_mess_3_1,a8
	JSRP	LM_PRINTF
	movi	hint_text_mess_3_2,a8
	jauc	LM_PRINTF
hint_4
;	MOVI	HALEY_CLIPBOARD_INIT,B0
	MOVI	SADIE_TAPESTICK_INIT,B0
	CALLA	EASYMAKE
	movi	hint_text_mess_4_1,a8
	JSRP	LM_PRINTF
	movi	hint_text_mess_4_2,a8
	jauc	LM_PRINTF
hint_5
;	MOVI	HALEY_TIMER_INIT,B0
	MOVI	HALEY_NONO_INIT,B0
	CALLA	EASYMAKE
	movi	hint_text_mess_5_1,a8
	JSRP	LM_PRINTF
	movi	hint_text_mess_5_2,a8
	jauc	LM_PRINTF
hint_6
;	MOVI	HALEY_CLIPBOARD_INIT,B0
	MOVI	HALEY_PUNCH_INIT,B0
	MOVI	512,A0
	CALLA	RANDPER
	JRC	H6_GIRL
	MOVI	SADIE_DANCE_INIT,B0
H6_GIRL
	CALLA	EASYMAKE
	movi	hint_text_mess_6_1,a8
	JSRP	LM_PRINTF
	movi	hint_text_mess_6_2,a8
	JSRP	LM_PRINTF
	movi	hint_text_mess_6_3,a8
	jauc	LM_PRINTF

;hint_text_mess_title
;	MESS_MAC2 H18TFONT,1,0,200,20,HFPAL+0101h,STRCNCONV,OID_TEXT
;	.string	"OPEN ICE COACHING TIPS",0
;	.even

hint_text_mess_1_1
	MESS_MAC2 H18TFONT,1,0,240,65,HFPAL,STRCNCONV,OID_TEXT
	.string	"GO UPSTAIRS",0
	.even
hint_text_mess_1_2
	MESS_MAC2 H18TFONT,1,22,240,100,HFPAL+0202h,STRCNCONV,OID_TEXT
	.string	"LIFT THE PUCK BY\nPULLING JOYSTICK\nAWAY FROM THE GOAL\nBEFORE LETTING GO\nA SHOT.",0
	.even

hint_text_mess_2_1
	MESS_MAC2 H18TFONT,1,0,240,60,HFPAL,STRCNCONV,OID_TEXT
	.string	"CHOOSE YOUR SHOTS",0
	.even
hint_text_mess_2_2
	MESS_MAC2 H18TFONT,1,22,240,91,HFPAL+0202h,STRCNCONV,OID_TEXT
	.string	"PRESS SHOOT BUTTON\nFOR WRIST SHOTS\nAND BACKHAND SHOTS.\nCOMBINE WITH TURBO\nFOR SLAP SHOTS AND\nOTHER SPECIALTY\nSHOTS.",0
	.even

hint_text_mess_3_1
	MESS_MAC2 H18TFONT,1,0,240,65,HFPAL,STRCNCONV,OID_TEXT
	.string	"ONE TIMER",0
	.even
hint_text_mess_3_2
	MESS_MAC2 H18TFONT,1,22,240,100,HFPAL+0202h,STRCNCONV,OID_TEXT
	.string	"PERFORM A ONE TIMER\nBY HOLDING SHOOT\nBUTTON DOWN WHILE\nRECEIVING A PASS.",0
	.even

hint_text_mess_4_1
	MESS_MAC2 H18TFONT,1,0,240,65,HFPAL,STRCNCONV,OID_TEXT
	.string	"DEKING",0
	.even
hint_text_mess_4_2
	MESS_MAC2 H18TFONT,1,22,240,100,HFPAL+0202h,STRCNCONV,OID_TEXT
	.string	"CHANGE DIRECTION\nOFTEN WHILE SKATING\nIN ON GOAL TO FAKE\nOUT THE GOALTENDER",0
	.even

hint_text_mess_5_1
	MESS_MAC2 H18TFONT,1,0,240,65,HFPAL,STRCNCONV,OID_TEXT
	.string	"PASSING",0
	.even
hint_text_mess_5_2
	MESS_MAC2 H18TFONT,1,22,240,100,HFPAL+0202h,STRCNCONV,OID_TEXT
	.string	"TRY TO SET UP PLAYS\nWITH A WELL TIMED\nPASS.\n\nDON'T HOG THE PUCK!",0
	.even

hint_text_mess_6_1
	MESS_MAC2 H18TFONT,1,0,240,55,HFPAL,STRCNCONV,OID_TEXT
	.string	"GET HOT",0
	.even
hint_text_mess_6_2
	MESS_MAC2 H18TFONT,1,22,240,88,HFPAL+0202h,STRCNCONV,OID_TEXT
	.string	"EVERY CHECK, STEAL,\nASSIST, AND GOAL\nFILLS YOUR HOT-METER.",0
	.even
hint_text_mess_6_3
	MESS_MAC2 H18TFONT,1,22,240,162,HFPAL+0202h,STRCNCONV,OID_TEXT
	.string	"SCORING WITH A FULL\nHOT-METER WILL PUT\nYOU ON FIRE WITH\nUNLIMITED TURBO!",0
	.even

HINT_PAGE_INIT
	.byte	9, 0, 0, 6	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	TOPICE02P	;IMGPAL
	.long	COILOGO1P	;IMGPAL
	.long	COACHP		;IMGPAL
	.long	CSTICK1P	;IMGPAL
	.long	CPLAY1P		;IMGPAL
	.long	CLPWHST1P	;IMGPAL
	.word	OID_JUNK, OM_POS|OM_INSERT	;OID, GLOBAL_OPTIONS
	.long	[0,0],[0,0],0
	LWWWW	TOPICEA, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	TOPICEB2, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	TOPICEC, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	TOPICED2, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	CSTICK1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -3, 0
	LWWWW	COILOGO1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -2, 0
	LWWWW	COACH, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, 0
	LWWWW	CPLAY1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -2, 0
	LWWWW	CLPWHST1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, 0

;file_init
;	.long	HAFI1F01
;	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
;	.word	OM_OID|OM_POS|OM_INSERT
;	.word	OID_JUNK
;	.long	[55,0],[252,0],[-32700,0]

;file_1_anim
;	LW	HAFI1F01,8
;	LW	HAFI1F02,5
;	LW	HAFI1F03,5
;	LW	HAFI1F04,7
;	LW	HAFI1F03,5
;	LW	HAFI1F02,5
;	.long	0

;HALEY_CLIPBOARD_INIT
;	.long	HCLIPF01
;	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
;	.word	OM_OID|OM_POS|OM_ANIM|OM_INSERT
;	.word	OID_JUNK
;	.long	HALEY_CLIPBOARD_ANIM
;	.long	[55,0],[252,0],TEXTZVAL-10

HALEY_TIMER_INIT
	.long	HTIME01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_ANIM|OM_INSERT
	.word	OID_JUNK
	.long	HALEY_TIMER_ANIM
	.long	[55,0],[252,0],TEXTZVAL-10

SADIE_WHISTLE_INIT
	.long	SWHST01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_ANIM|OM_INSERT
	.word	OID_JUNK
	.long	SADIE_WHISTLE_ANIM
	.long	[55,0],[252,0],TEXTZVAL-10

SADIE_POOLCUE_INIT
	.long	SASP1F01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_ANIM|OM_INSERT
	.word	OID_JUNK
	.long	SADIE_POOLCUE_ANIM
	.long	[60,0],[272,0],TEXTZVAL-10

SADIE_TAPESTICK_INIT
	.long	STAPE01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_ANIM|OM_INSERT
	.word	OID_JUNK
	.long	SADIE_TAPESTICK_ANIM
	.long	[55,0],[252,0],TEXTZVAL-10

HALEY_NONO_INIT
	.long	HNONOF01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_ANIM|OM_INSERT
	.word	OID_JUNK
	.long	HALEY_NONO_ANIM
	.long	[55,0],[252,0],TEXTZVAL-10

HALEY_PUNCH_INIT
	.long	HABO1F01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_ANIM|OM_INSERT
	.word	OID_JUNK
	.long	HALEY_PUNCH_ANIM
	.long	[55,0],[252,0],TEXTZVAL-10

HALEY_PUNCH_ANIM
	LW	HABO1F01,5
	LW	HABO1F02,5
	LW	HABO1F03,5
	LW	HABO1F04,5
	LW	HABO1F05,5
	LW	HABO1F06,5
	LW	HABO1F07,5
	LW	HABO1F08,5
	LW	HABO1F09,5
	LW	HABO1F10,5
	LW	HABO1F11,5
	LW	HABO1F12,5
	LW	HABO1F13,5
	LW	HABO1F14,5
	LW	HABO1F15,5
	LW	HABO1F16,5
	LW	HABO1F17,5
	.long	0

HALEY_NONO_ANIM
	LW	HNONOF01,6
	LW	HNONOF02,6
	LW	HNONOF03,6
	LW	HNONOF04,6
	LW	HNONOF05,6
	LW	HNONOF04,6
	LW	HNONOF03,6
	LW	HNONOF02,6
	.long	0

SADIE_TAPESTICK_ANIM
	LW	STAPE01,5
	LW	STAPE02,5
	LW	STAPE03,5
	LW	STAPE04,5
	LW	STAPE05,5
	LW	STAPE06,5
	LW	STAPE07,5
	LW	STAPE08,5
	LW	STAPE09,5
	LW	STAPE10,5
	LW	STAPE11,5
	LW	STAPE12,5
	LW	STAPE13,5
	LW	STAPE14,5
	LW	STAPE15,5
	.long	0

SADIE_POOLCUE_ANIM
	LW	SASP1F01,7
	LW	SASP1F02,7
	LW	SASP1F03,7
	LW	SASP1F02,7
	.long	0

;HALEY_CLIPBOARD_ANIM
;	LWLWW	HCLIPF01,1|AFUNC,A_RAND_ANIMSLP+2,60,90
;	LW	1,0
;	LW	HCLIPF02,5
;	LW	HCLIPF03,5
;	LW	HCLIPF04,5
;	LW	HCLIPF05,5
;	LW	HCLIPF06,5
;	LW	HCLIPF08,5
;	LWLWW	HCLIPF09,120|AFUNC,A_RAND_ANIMSLP+2,60,120
;	LW	1,0
;	LW	HCLIPF08,5
;	LW	HCLIPF07,5
;	LW	HCLIPF06,5
;	LW	HCLIPF05,5
;	LW	HCLIPF04,5
;	LW	HCLIPF03,5
;	LW	HCLIPF02,5
;	.long	0

HALEY_TIMER_ANIM
	LW	HTIME01,60
	LW	HTIME02,5
	LW	HTIME03,5
	LW	HTIME04,5
	LW	HTIME05,5
	LW	HTIME06,5
	LW	HTIME07,5
	LW	HTIME08,5
	LW	HTIME09,5
	LW	HTIME10,5
	LW	HTIME11,5
	LWL	HTIME12,1|AFUNC,PULL_ANIM

SADIE_WHISTLE_ANIM
	LW	SWHST01,15
	LW	SWHST02,5
	LW	SWHST03,5
	LW	SWHST04,5
	LW	SWHST05,5
	LW	SWHST06,5
	LW	SWHST07,5
	LW	SWHST08,5
	LW	SWHST09,5
	LW	SWHST10,5
	LW	SWHST11,5
	LW	SWHST12,5
	LW	SWHST13,5
	LW	SWHST14,5
	LWL	SWHST15,1|AFUNC,PULL_ANIM

**************************************************************************
*								         *
* PATS_PAGE								 *
*								         *
**************************************************************************

PATS_PAGE

	.if	0

	calla	MY_WIPEOUT

	BLACKON

	MOVI	BLUTXT3P,A0
	CALLA	GETFPAL
	MOVI	REDTXT4P,A0
	CALLA	GETFPAL
	
	MOVI	TOPICE_INIT,B0
	CALLA	MULTIMAKE

	MOVI	PAT_INIT,B0
	CALLA	EASYMAKE

	MOVI	PAT_MESS,A8
	JSRP	LM_PRINTF

	BLACKOFF

	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	CLR	A0
	CALLA	FADEINF			;FADE UP ALL PALETTES
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS

	MOVI	REDTXT4P,A8
	MOVK	20,A9
	MOVK	4,A10
	MOVK	5,A11
	CREATE	PID_COLOR,CYCLE16

	RETP

PAT_INIT
	.long	BGFOLEY1
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_JUNK
	.long	[110,0],[254,0],-10

PAT_MESS
	MESS_MAC2 H18TFONT,-1,0,274,50,HFPAL,STRCNCONV,OID_TEXT
	.string	"FEATURING\nNHL ANNOUNCER\n\p\dPAT FOLEY",0
	.LONG	REDTXT4P	
	.LONG	H18FONT
	.even

	.else

	calla	MY_WIPEOUT

	BLACKON

	MOVI	BLUTXT3P,A0
	CALLA	GETFPAL
	MOVI	REDTXT4P,A0
	CALLA	GETFPAL
	MOVI	ORGTXT1P,A0
	CALLA	GETFPAL
	
	MOVI	TITLE_PAGE_INIT,B0
	CALLA	MULTIMAKE

	MOVI	PAT_INIT,B0
	CALLA	EASYMAKE

	MOVI	PAT_MESS,A8
	JSRP	LM_PRINTF

	BLACKOFF

	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	CLR	A0
	CALLA	FADEINF			;FADE UP ALL PALETTES
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS

	MOVI	REDTXT4P,A8
	MOVK	20,A9
	MOVK	4,A10
	MOVK	5,A11
	CREATE	PID_COLOR,CYCLE16

	CREATE	PID_IND,FEATURE_PROC

	RETP

**************************************************************************
*								         *
* FEATURE_PROC								 *
*								         *
**************************************************************************

FEATURE_PROC
	MOVI	FEATURING_MESS,A8
	JSRP	LM_PRINTF

	SLEEP	20

	CALLA	CLRTEXT
	
	SLEEP	20
	
	JRUC	FEATURE_PROC

PAT_INIT
	.long	BGFOLEY1
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_JUNK
	.long	[50,0],[254,0],-10

FEATURING_MESS
	MESS_MAC2 H18TFONT,-1,0,380,25,HFPAL+0202H,STRRNCONV,OID_TEXT
	.string	"FEATURING !",0
	.even

PAT_MESS
	MESS_MAC2 H11WFONT,-1,0,130,200,HFPAL,STRCNCONV,OID_JUNK
;	.string	"FEATURING !\n\fNHL ANNOUNCER\n\f\p\dPAT FOLEY",0
	.string	"\n\fNHL ANNOUNCER\n\f\p\dPAT FOLEY",0
;	.LONG	[-2,0]
;	.LONG	[-4,0]
	.LONG	[-1,0]
	.LONG	[-5,0]
	.LONG	REDTXT4P	
	.LONG	H18FONT
	.even

;PAT_MESS
;	MESS_MAC2 H11WFONT,-1,0,20,235,HFPAL,STRLNCONV,OID_TEXT
;	.string	"FEATURING NHL ANNOUNCER \pPAT FOLEY",0
;	.LONG	REDTXT4P	
;	.even

	.endif

TOPICE_INIT
	.byte	4, 0, 0, 1	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	TOPICE02P	;IMGPAL
	.word	OID_SELECT_1, OM_POS|OM_INSERT	;OID, GLOBAL_OPTIONS
	.long	[0,0],[0,0],0
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	TOPICEA, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	TOPICEB, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	TOPICEC, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	TOPICED, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0

**************************************************************************
*								         *
* TOPTEN_SETUP								 *
*								         *
**************************************************************************

TOPTEN_SETUP
	calla	MY_WIPEOUT

	BLACKON

	MOVI	ORGTXT1P,A0
	CALLA	GETFPAL
	MOVI	REDTXT4P,A0
	CALLA	GETFPAL
	MOVI	BLUTXT3P,A0
	CALLA	GETFPAL

	MOVI	TOPTEN_PAGE_INIT,B0
	CALLA	MULTIMAKE

	RETS

**************************************************************************
*								         *
* TOPTEN_FADEIN								 *
*								         *
**************************************************************************

TOPTEN_FADEIN
	BLACKOFF

	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	CLR	A0
	CALLA	FADEINF			;FADE UP ALL PALETTES
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS

	MOVI	REDTXT4P,A8
	MOVK	20,A9
	MOVK	4,A10
	MOVK	5,A11
	CREATE	PID_COLOR,CYCLE16

	RETP

**************************************************************************
*								         *
* MOST_POINTS_LIST							 *
* 									 *
* PASS:									 *
* NUTIN'								 *
*								         *
**************************************************************************

MOST_POINTS_LIST

	CALLR	TOPTEN_SETUP

	MOVI	MOSTPTS_INIT,B0
	CALLA	EASYMAKE

	MOVI	MOSTPTS_HEADER_MESS,A8
	JSRP	LM_PRINTF

	MOVI	HALEY_JUGGLE_INIT,B0
	CALLA	EASYMAKE

;	MOVI	HALEY_INIT,B0
;	MOVI	HALEY_1_ANIM,A9
;
;	MOVI	512,A0
;	CALLA	RANDPER
;	JRC	MPL_GIRLIE			;BR=OTHER ONE
;
;	MOVI	SADIE_INIT,B0
;	MOVI	SADIE_1_ANIM,A9
;
;MPL_GIRLIE
;	CALLA	EASYMAKE
;	MOVE	A9,A1
;	CALLA	STRT_ANIM

	MOVI	CALC_POINTS,A14
	MOVE	A14,*A13(ATT_MODE_LIST_SUBR),L

	MOVI	toprecords,A10
	CALLR	LIST_PLAYERS

	JSRP	TOPTEN_FADEIN

	RETP

CALC_POINTS
	MOVE	@b_wins,A4,W
	SLL	1,A4
	MOVE	@b_ties,A14,W
	ADD	A14,A4				;POINTS
	RETS

MOSTPTS_INIT
	.long	MOSTPTS1
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_SELECT_2
	.long	[0,0],[0,0],-2

MOSTPTS_HEADER_MESS
	MESS_MAC2 H11WFONT,-1,0,197,36,HFPAL,STRLNCONV,OID_TEXT
	.STRING	"WIN\fLOSS\fTIE\fPTS",0
	.LONG	[0,10]
	.LONG	[0,11]
	.LONG	[0,18]
	.EVEN

**************************************************************************
*								         *
* MOST_GAMES_LIST							 *
* 									 *
* PASS:									 *
* NUTIN'								 *
*								         *
**************************************************************************

MOST_GAMES_LIST

	CALLR	TOPTEN_SETUP

	MOVI	MOSTPTS_INIT,B0
	CALLA	EASYMAKE
	MOVI	MOSTGAM1,A1
	MOVI	DMAWNZ,A4
	CALLA	ANI

	MOVI	MOSTGAMES_HEADER_MESS,A8
	JSRP	LM_PRINTF

;	MOVI	SADIE_SHEETH_INIT,B0
	MOVI	SADIE_DANCE_INIT,B0
	CALLA	EASYMAKE
;	MOVI	60,A14
;	MOVB	A14,*A8(ANISLP)

	MOVI	CALC_GAMES,A14
	MOVE	A14,*A13(ATT_MODE_LIST_SUBR),L

	MOVI	mostrecords,A10
	CALLR	LIST_PLAYERS

	JSRP	TOPTEN_FADEIN

	RETP

CALC_GAMES
	MOVE	@b_wins,A4,W
	MOVE	@b_losses,A14,W
	ADD	A14,A4				;POINTS
	MOVE	@b_ties,A14,W
	ADD	A14,A4				;POINTS
	RETS

MOSTGAMES_HEADER_MESS
	MESS_MAC2 H11WFONT,-1,0,197,36,HFPAL,STRLNCONV,OID_TEXT
	.STRING	"WIN\fLOSS\fTIE\fTOTAL",0
	.LONG	[0,10]
	.LONG	[0,11]
	.LONG	[0,7]
	.EVEN

**************************************************************************
*								         *
* BEST_PCTG_LIST							 *
* 									 *
* PASS:									 *
* NUTIN'								 *
*								         *
**************************************************************************

BEST_PCTG_LIST

	CALLR	TOPTEN_SETUP

	MOVI	MOSTPTS_INIT,B0
	CALLA	EASYMAKE
	MOVI	BESTWIN,A1
	MOVI	DMAWNZ,A4
	CALLA	ANI

	MOVI	BESTPCTG_HEADER_MESS,A8
	JSRP	LM_PRINTF

;	MOVI	HALEY_FILE_INIT,B0
;	CALLA	EASYMAKE

;	MOVI	SADIE_GOALIE_INIT,B0
;	CALLA	EASYMAKE

	MOVI	HALEY_INIT,B0
	MOVI	HALEY_1_ANIM,A9

;	MOVI	922,A0
;	CALLA	RANDPER
;	JRC	MPL_GIRLIE			;BR=OTHER ONE
;
;	MOVI	SADIE_INIT,B0
;	MOVI	SADIE_1_ANIM,A9

MPL_GIRLIE
	CALLA	EASYMAKE
	MOVE	A9,A1
	CALLA	STRT_ANIM

	MOVI	CALC_PCTG,A14
	MOVE	A14,*A13(ATT_MODE_LIST_SUBR),L

	MOVI	pctrecords,A10
	CALLR	LIST_PLAYERS

	JSRP	TOPTEN_FADEIN

	RETP

CALC_PCTG
	MMTM	SP,A2,A6,A7
	MOVI	BESTPCTG_100_STRING,A8		;POINTER TO STRING

	MOVE	@b_wins,A2,W
	MOVE	A2,A6
	SLL	1,A6
	MOVE	@b_losses,A14,W
	ADD	A14,A2
	MOVE	@b_ties,A14,W
	ADD	A14,A2
	ADD	A14,A6				;POINTS

	SLL	1,A2
	CMP	A2,A6
	JREQ	CP_DONE

	MOVI	BESTPCTG_STRING,A8

	MOVE	A6,A7
	MOVI	10000,A14
	MPYU	A14,A7
	DIVU	A2,A7
	ADDK	5,A7				;ROUND UP
	MOVI	10,A14
	DIVU	A14,A7

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
	MOVE	A7,A4
CP_DONE
	MMFM	SP,A2,A6,A7
	RETS

BESTPCTG_100_STRING
	.STRING	"\f1.000",0
	.LONG	[0,5]
	.EVEN

BESTPCTG_STRING
	.STRING	"\f.%u%u%u",0
	.LONG	[0,5]
	.LONG	RAMTEMP1
	.LONG	RAMTEMP2
	.LONG	RAMTEMP3
	.EVEN

BESTPCTG_HEADER_MESS
	MESS_MAC2 H11WFONT,-1,0,197,36,HFPAL,STRLNCONV,OID_TEXT
	.STRING	"WIN\fLOSS\fTIE\fPCTG",0
	.LONG	[0,10]
	.LONG	[0,11]
	.LONG	[0,18]
	.EVEN

**************************************************************************
*								         *
* STANLEY_CHAMPS_LIST							 *
* 									 *
* PASS:									 *
* NUTIN'								 *
*								         *
**************************************************************************

STANLEY_CHAMPS_LIST
	CALLR	TOPTEN_SETUP

	MOVI	OID_SELECT_3,A0
	CALLA	KILOBJ_ALL

	MOVI	VBAR_CLEAN_INIT,B0
	CALLA	EASYMAKE

	MOVI	MOSTPTS_INIT,B0
	CALLA	EASYMAKE
	MOVI	STANLY01,A1
	MOVI	DMAWNZ,A4
	CALLA	ANI

	MOVI	REGISTER_INIT,B0
	CALLA	EASYMAKE

	MOVI	GIRLS_CUP_INIT,B0
	CALLA	EASYMAKE

	MOVI	CHAMPS_NUMSIGNS_MESS,A8
	CALLA	LM_SETUP
	MOVI	0800080H,B5
	JSRP	PRINTF

	MOVI	CHAMPS_NUMS_MESS,A8
	JSRP	LM_PRINTF

	MOVI	CHAMPS_INITS_MESS,A8
	JSRP	LM_PRINTF

	JSRP	TOPTEN_FADEIN

	RETP

VBAR_CLEAN_INIT
	.long	TOPBAR02
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_SELECT_3
	.long	[0,0],[0,0],-1

REGISTER_INIT
;	.long	FONT17CRCLR
	.long	CIRCLER
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_SELECT_2
	.long	[220,0],[0,0],-3


CHAMPS_X	EQU	150
CHAMPS_Y	EQU	44

CHAMPS_NUMSIGNS_MESS
	MESS_MAC2 H18FONT,-1,0,CHAMPS_X,CHAMPS_Y,HFPAL+0101H,STRLNCONV_SCALE,OID_TEXT
	.STRING	"#\p\f#\f#",0
	.LONG	BLUTXT3P
	.LONG	[37,-19]
	.LONG	[38,-14]
	.EVEN

CHAMPS_NUMS_MESS
	MESS_MAC2 H50FONT,-1,0,CHAMPS_X+45,CHAMPS_Y,HFPAL+0101H,STRCNCONV,OID_TEXT
	.STRING	"1\n\p2\n3",0
	.LONG	BLUTXT3P
	.EVEN


CHAMPS_INITS_MESS
	MESS_MAC2 H50FONT,-1,0,CHAMPS_X+155,CHAMPS_Y,HFPAL+0101H,STRCNCONV,OID_TEXT
	.STRING	"%c%c%c\n\p%c%c%c\n%c%c%c\n",0
	.LONG	stanley_data
	.LONG	stanley_data+010H
	.LONG	stanley_data+020H
	.LONG	BLUTXT3P
	.LONG	stanley_data+050H
	.LONG	stanley_data+060H
	.LONG	stanley_data+070H
	.LONG	stanley_data+0A0H
	.LONG	stanley_data+0B0H
	.LONG	stanley_data+0C0H
	.EVEN



**************************************************************************
*								         *
* LIST_PLAYERS								 *
* 									 *
* PASS:									 *
*								         *
**************************************************************************

LIST_PLAYERS
	MOVK	1,A8
	MOVI	[49,122],A9

LP_LUPE
	MOVE	*A10,A0,W
	JRN	LP_DONE				;BR=END OF LIST

	MMTM	A12,A8,A10
	MOVE	A8,@RAMTEMP1,W			;RANK
	MOVI	HFPAL+0202H,A5			;[COLOR,PALETTE]

	MMTM	A12,A0,A9
	CMPI	1,A8
	JRNE	LP_PRINT_RANK			;BR=NOT FIRST
	SUBK	3,A9				;CENTER "1"
	SUBI	0101H,A5
LP_PRINT_RANK
	MOVI	OID_TEXT,B1			;[SOUND,OID]
	CLR	A0				;NO SLEEP TIL
	MOVI	STRRNCONV,A1			;ROUTINE
;	MOVI	TOPTEN_VALUE_STRING,A8		;POINTER TO STRING
	MOVI	TOPTEN_NUMBER_STRING,A8		;POINTER TO STRING
	MOVI	[0,0],A10			;[Y,X] SPACING
	MOVI	H18FONT,A11			;FONT
	JSRP	PRINTF
	MMFM	A12,A0,A9

	CALLA	get_cmos_record_a

	MOVE	@b_initial1,A14,W		;TRANSLATE YOUR INITIALS
	CALLA	PENACHO_TO_ASCII
	MOVE	A14,@b_initial1,W
	MOVE	@b_initial2,A14,W
	CALLA	PENACHO_TO_ASCII
	MOVE	A14,@b_initial2,W
	MOVE	@b_initial3,A14,W
	CALLA	PENACHO_TO_ASCII
	MOVE	A14,@b_initial3,W

	PUSHP	A9
	CLR	A0
	MOVI	STRCNCONV,A1			;ROUTINE
	MOVI	TOPTEN_INITIAL_STRING,A8	;POINTER TO STRING
	ADDI	[0,36],A9
	MOVI	[0,-1],A10			;[Y,X] SPACING
	JSRP	PRINTF

	MOVI	b_wins,A2
	MOVK	4,A3

	MOVE	*A12,A9,L
	ADDI	[0,92],A9

LP_VALUES_LUPE
	MOVI	TOPTEN_VALUE_STRING,A8		;POINTER TO STRING
	MOVE	*A2+,A4,W
	CMPI	1,A3
	JRNE	LP_VALUE_GO			;BR=NOT LAST

	MOVE	*A13(ATT_MODE_LIST_SUBR),A14,L
	JRZ	LP_NEXT				;BR=NO LAST ITEM
	CALL	A14

LP_VALUE_GO
	CMPI	1000,A4
	JRLT	LP_SET_VALUE			;BR=LESS THAN MAXIMUM
	MOVI	999,A4
LP_SET_VALUE
	MOVE	A4,@RAMTEMP1,W

	MMTM	A12,A2,A3,A9
	JSRP	PRINTF
	MMFM	A12,A2,A3,A9

LP_NEXT
	ADDI	[0,47],A9

	DSJ	A3,LP_VALUES_LUPE
	PULLPQ	A9

	MMFM	A12,A8,A10
	ADDI	[20,0],A9			;NEXT ROW
	ADDI	040H,A10			;NEXT RECORD

	INC	A8
	CMPI	11,A8
	JRLT	LP_LUPE				;BR=STILL MORE TO COME

LP_DONE
	RETS

TOPTEN_PAGE_INIT
	.byte	7, 0, 0, 3	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	TOPICE02P	;IMGPAL
	.long	HORBAR01P	;IMGPAL
	.long	TOPBAR01P	;IMGPAL
	.word	OID_SELECT_1, OM_POS|OM_INSERT	;OID, GLOBAL_OPTIONS
	.long	[0,0],[0,0],0
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	TOPICEA, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	TOPICEB, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	TOPICEC, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	TOPICED, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	HORBAR01, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, 0
	LWWWW	HORBAR02, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, 0
	LWWWW	TOPBAR01, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, OM_OID
	.WORD	OID_SELECT_3

TOPTEN_INITIAL_STRING
	.STRING	"%c%c%c",0
	.LONG	b_initial1
	.LONG	b_initial2
	.LONG	b_initial3
	.EVEN

TOPTEN_VALUE_STRING
	.STRING	"%u",0
	.LONG	RAMTEMP1
	.EVEN

HALEY_INIT
	.long	HAD16F01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_JUNK
	.long	[55,0],[252,0],TEXTZVAL-10

HALEY_DANCE_INIT
	.long	HAD16F01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_ANIM|OM_POS|OM_INSERT
	.word	OID_JUNK
	.long	HALEY_1_ANIM
	.long	[55+5,0],[252,0],TEXTZVAL-10

HALEY_1_ANIM
	LW	HAD16F01,5
	LW	HAD16F02,5
	LW	HAD16F03,5
	LW	HAD16F04,5
	LW	HAD16F05,5
	LW	HAD16F06,5
	LW	HAD16F05,5
	LW	HAD16F04,5
	LW	HAD16F03,5
	LW	HAD16F02,5
	.long	0

;SADIE_INIT
;	.long	SAD15F01
;	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
;	.word	OM_OID|OM_POS|OM_INSERT
;	.word	OID_JUNK
;	.long	[53,0],[252,0],TEXTZVAL-10

;SADIE_1_ANIM
;	LW	SAD15F01,5
;	LW	SAD15F02,5
;	LW	SAD15F03,5
;	LW	SAD15F04,5
;	LW	SAD15F05,5
;	.long	0

**************************************************************************
*								         *
* TOPTEN_TEAM_LIST - DISPLAY TOP TEN TEAMS				 *
* 									 *
* PASS:									 *
* NUTIN'								 *
*								         *
**************************************************************************

FIRST_TEAM_YX	EQU	[44,142] ;[49,122]
NEXT_TEAM_YINC	EQU	[20,0]


TOPTEN_TEAM_LIST
	calla	MY_WIPEOUT

	BLACKON

	MOVI	ORGTXT1P,A0
	CALLA	GETFPAL
	MOVI	REDTXT4P,A0
	CALLA	GETFPAL

	MOVI	TOPTEN_PAGE_INIT,B0
	CALLA	MULTIMAKE

	MOVI	MOSTPTS_INIT,B0
	CALLA	EASYMAKE
	MOVI	MOSTPOP1,A1
	MOVI	DMAWNZ,A4
	CALLA	ANI

;	MOVI	HALEY_NUMBER1_INIT,B0
;	MOVI	HALEY_NUMBER1_ANIM,A9
;
;	MOVI	512,A0
;	CALLA	RANDPER
;	JRC	TTTL_GIRLIE			;BR=OTHER ONE

	MOVI	SADIE_NUMBER1_INIT,B0
	MOVI	SADIE_NUMBER1_ANIM,A9

TTTL_GIRLIE
	CALLA	EASYMAKE
	MOVE	A9,A1
	CALLA	STRT_ANIM

	MOVK	1,A3
	MOVI	07FFFFFFFH,A11			;LAST HIGHEST
	MOVI	FIRST_TEAM_YX,A9

TTTL_FIND_NEXT_HIGHEST
	CLR	A10
	DEC	A10				;CURRENT HIGHEST

	MOVI	TEAM_SEARCH_LIST,A2
TTTL_FNH_LUPE
	MOVE	*A2+,A0,W
	JRZ	TTTL_PRINT_NEXT_HIGHEST		;BR=LIST DONE
	CALLA	GET_AUD

	CMP	A11,A1
	JRGE	TTTL_FNH_LUPE			;BR=LAST HIGHEST
	CMP	A10,A1
	JRLT	TTTL_FNH_LUPE			;BR=NOT HIGH ENOUGH
	MOVE	A1,A10
	JRUC	TTTL_FNH_LUPE

TTTL_PRINT_NEXT_HIGHEST
	MOVI	TEAM_SEARCH_LIST,A2
TTTL_PNH_LUPE
	MOVE	*A2+,A0,W
	JRZ	TTTL_PNH_L_DONE			;BR=LIST DONE
	CALLA	GET_AUD

	CMP	A10,A1
	JRNE	TTTL_PNH_LUPE			;BR=NOT THIS TEAM

	MMTM	SP,A2,A3,A9,A10,A11

	MOVE	A3,@RAMTEMP1,W

	SUBI	AUD_BRUINS-1,A0
	SLL	10,A0
	ADDI	team_data,A0
	MOVE	*A0(TD_CITY_STR),A8,L

	MMTM	SP,A8,A9
	MOVI	OID_TEXT,B1			;[SOUND,OID]
	CLR	A0				;NO SLEEP TIL
	MOVI	STRRNCONV,A1			;ROUTINE
	MOVI	HFPAL,A5			;[COLOR,PALETTE]
	CMPI	1,A3
	JRNE	TTTL_PNH_PAL_SET		;BR=NOT #1
	MOVI	HFPAL+0101H,A5			;[COLOR,PALETTE]
	SUBK	3,A9				;CENTER "1"
TTTL_PNH_PAL_SET
	MOVI	TOPTEN_NUMBER_STRING,A8		;POINTER TO STRING
	MOVI	[0,0],A10			;[Y,X] SPACING
	MOVI	H18FONT,A11			;FONT
	JSRP	PRINTF
	MMFM	SP,A8,A9

	ADDI	[0,10],A9

	MOVI	OID_TEXT,B1			;[SOUND,OID]
	CLR	A0				;NO SLEEP TIL
	MOVI	STRLNCONV,A1			;ROUTINE
	MOVI	[0,1],A10			;[Y,X] SPACING
	MOVI	H18FONT,A11			;FONT
	JSRP	PRINTF
	MMFM	SP,A2,A3,A9,A10,A11

	CMPI	10,A3
	JRGE	TTTL_FADEIN			;BR=DONE!

	INC	A3
	ADDI	NEXT_TEAM_YINC,A9		;NEXT ROW
	JRUC	TTTL_PNH_LUPE

TTTL_PNH_L_DONE
	MOVE	A10,A11				;NEW LAST HIGHEST
	JRUC	TTTL_FIND_NEXT_HIGHEST

TTTL_FADEIN
	BLACKOFF

	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	CLR	A0
	CALLA	FADEINF				;FADE IN ALL PALETTES
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS

	MOVI	REDTXT4P,A8
	MOVK	20,A9
	MOVK	4,A10
	MOVK	5,A11
	CREATE	PID_COLOR,CYCLE16

	RETP

;HALEY_NUMBER1_INIT
;	.long	HANU1F01
;	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
;	.word	OM_OID|OM_POS|OM_INSERT
;	.word	OID_JUNK
;;	.long	[70,0],[252,0],TEXTZVAL-10
;	.long	[65,0],[252,0],TEXTZVAL-10

SADIE_NUMBER1_INIT
	.long	SNUM01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_JUNK
	.long	[55,0],[252,0],TEXTZVAL-10

HALEY_JUGGLE_INIT
	.long	HAPU2F01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_ANIM|OM_POS|OM_INSERT
	.word	OID_JUNK
	.long	HALEY_JUGGLE_ANIM	
	.long	[55,0],[252,0],TEXTZVAL-10

;SADIE_SHEETH_INIT
;	.long	SASH1F01
;	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
;	.word	OM_OID|OM_ANIM|OM_POS|OM_INSERT
;	.word	OID_JUNK
;	.long	SADIE_SHEETH_ANIM	
;	.long	[55,0],[252,0],TEXTZVAL-10

SADIE_DANCE_INIT
	.long	SADAN01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_ANIM|OM_POS|OM_INSERT
	.word	OID_JUNK
	.long	SADIE_DANCE_ANIM	
	.long	[55,0],[252-21,0],TEXTZVAL-10

;SADIE_GOALIE_INIT
;	.long	SABG1F01
;	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
;	.word	OM_OID|OM_ANIM|OM_POS|OM_INSERT
;	.word	OID_JUNK
;	.long	SADIE_GOALIE_ANIM	
;	.long	[55,0],[252,0],TEXTZVAL-10

GIRLS_CUP_INIT
	.long	STANCUP1
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_ANIM|OM_POS|OM_INSERT
	.word	OID_JUNK
	.long	GIRLS_CUP_ANIM
	.long	[70,0],[252,0],TEXTZVAL-10

;HALEY_FILE_INIT
;	.long	HAFI1F01
;	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
;	.word	OM_OID|OM_ANIM|OM_POS|OM_INSERT
;	.word	OID_JUNK
;	.LONG	file_1_anim
;	.long	[35,0],[252,0],TEXTZVAL-10

GIRLS_CUP_ANIM
	LW	STANCUP1,90
	LW	STANCUP2,5
	LWL	STANCUP3,1|AFUNC,PULL_ANIM

;SADIE_GOALIE_ANIM
;	LW	SABG1F01,5
;	LW	SABG1F02,5
;	LW	SABG1F03,5
;	LW	SABG1F04,5
;	LW	SABG1F05,5
;	LW	SABG1F04,5
;	LW	SABG1F03,5
;	LW	SABG1F02,5
;	.long	0

;SADIE_SHEETH_ANIM
;	LW	SASH1F02,5
;	LW	SASH1F03,5
;	LW	SASH1F04,5
;	LW	SASH1F05,5
;	LW	SASH1F06,5
;	LW	SASH1F07,5
;	LW	SASH1F08,5
;;	LW	SASH1F09,45
;	LWL	SASH1F09,1|AFUNC,PULL_ANIM
;
;;	LW	SASH1F08,5
;;	LW	SASH1F07,5
;;	LW	SASH1F06,5
;;	LW	SASH1F05,5
;;	LW	SASH1F04,5
;;	LW	SASH1F03,5
;;	LW	SASH1F02,5
;;	LW	SASH1F01,60
;;	.long	0

SADIE_DANCE_ANIM
	LW	SADAN01,5
	LW	SADAN02,5
	LW	SADAN03,5
	LW	SADAN04,5
	LW	SADAN05,5
	LW	SADAN06,5
	LW	SADAN07,5
	LW	SADAN08,5
	LW	SADAN09,5
	.long	0

HALEY_JUGGLE_ANIM
	LW	HAPU2F01,5
	LW	HAPU2F02,5
	LW	HAPU2F03,5
	LW	HAPU2F04,5
	LW	HAPU2F05,5
	LW	HAPU2F06,5
	LW	HAPU2F07,5
	LW	HAPU2F08,5
	LW	HAPU2F09,5
	.long	0

SADIE_NUMBER1_ANIM
	LW	SNUM01,6
	LW	SNUM02,6
	LW	SNUM03,8
	LW	SNUM02,6
	.long	0

;HALEY_NUMBER1_ANIM
;	LW	HANU1F01,5
;	LW	HANU1F02,5
;	LW	HANU1F03,5
;	LW	HANU1F04,5
;	LW	HANU1F05,5
;	LW	HANU1F04,5
;	LW	HANU1F03,5
;	LW	HANU1F02,5
;	.long	0

TOPTEN_NUMBER_STRING
	.STRING	"#%u",0
;	.STRING	"%u",0
	.LONG	RAMTEMP1
	.EVEN


TEAM_SEARCH_LIST
	.WORD	AUD_DEVILS		;1
	.WORD	AUD_RED_WINGS		;2
	.WORD	AUD_FLYERS		;3
	.WORD	AUD_BLACKHAWKS		;4
	.WORD	AUD_PENGUINS		;5
	.WORD	AUD_CANUCKS		;6
	.WORD	AUD_RANGERS		;7
	.WORD	AUD_SHARKS		;8
	.WORD	AUD_FLAMES		;9
	.WORD	AUD_STARS		;10
;
	.WORD	AUD_AVALANCHE		;11, 2
	.WORD	AUD_BLUES		;12, 4
	.WORD	AUD_BRUINS		;13, 6
	.WORD	AUD_CAPITALS		;14, 10
	.WORD	AUD_SABRES		;15, 11
	.WORD	AUD_MAPLE_LEAFS		;16, 12
	.WORD	AUD_PANTHERS		;17, 15
	.WORD	AUD_WHALERS		;18, 16
	.WORD	AUD_CANADIENS		;19, 17
	.WORD	AUD_KINGS		;20
	.WORD	AUD_JETS		;21
	.WORD	AUD_OILERS		;22
	.WORD	AUD_LIGHTNING		;23
	.WORD	AUD_MIGHTY_DUCKS	;24
	.WORD	AUD_ISLANDERS		;25
	.WORD	AUD_SENATORS		;26
	.WORD	0

;	.WORD	AUD_MIGHTY_DUCKS	;A
;	.WORD	AUD_BRUINS		;BO
;	.WORD	AUD_SABRES		;BU
;	.WORD	AUD_AVALANCHE		;C
;	.WORD	AUD_OILERS		;E
;	.WORD	AUD_PANTHERS		;F
;	.WORD	AUD_WHALERS		;H
;	.WORD	AUD_KINGS		;L
;	.WORD	AUD_CANADIENS		;M
;	.WORD	AUD_ISLANDERS		;N
;	.WORD	AUD_SENATORS		;O
;	.WORD	AUD_BLUES		;S
;	.WORD	AUD_LIGHTNING		;TA
;	.WORD	AUD_MAPLE_LEAFS		;TO
;	.WORD	AUD_CAPITALS		;WA
;	.WORD	AUD_JETS		;WI


**************************************************************************
*								         *
* AAMA_ADVISORY_PAGE							 *
*								         *
**************************************************************************

AAMA_ADVISORY_PAGE
	calla	MY_WIPEOUT

	MOVI	FONTGRYP,A0
	CALLA	GETFPAL
	MOVI	GRNTXT5P,A0
	CALLA	GETFPAL

	BLACKON

	MOVI	AAMA_PA_MESS,A8
	JSRP	LM_PRINTF

	MOVI	SUITABLE_MESS,A8
	JSRP	LM_PRINTF

	BLACKOFF

	CLR	A0
	CALLA	FADEIN				;FADE DOWN ALL PALETTES
	JSRP	FADE_WAIT

	RETP

AAMA_PA_MESS
	MESS_MAC2 H18TFONT,-1,0,199,100,HFPAL,STRCNCONV,OID_TEXT
	.string	"AAMA PARENTAL ADVISORY",0
	.even

SUITABLE_MESS
	MESS_MAC2 H18TFONT,-1,0,199,140,HFPAL+0101H,STRCNCONV,OID_TEXT
	.string	"SUITABLE FOR ALL AGES",0
	.even

**************************************************************************
*								         *
* TITLE_PAGE								 *
*								         *
**************************************************************************

TITLE_PAGE
	calla	MY_WIPEOUT

;	CREATE	PID_LAMP,LAMP_DEMO_PROC

	BLACKON

	MOVI	TITLE_PAGE_INIT,B0
	CALLA	MULTIMAKE

	BLACKOFF

	CLR	A0
	CALLA	FADEIN				;FADE DOWN ALL PALETTES
	JSRP	FADE_WAIT

	RETP

TITLE_PAGE_INIT
	.byte	4, 0, 0, 1	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	TSLOGOP		;IMGPAL
	.word	OID_JUNK, OM_POS|OM_INSERT	;OID, GLOBAL_OPTIONS
	.long	[0,0],[0,0],0
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	TITLOGO1, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, 0
	LWWWW	TITLOGO2, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, 0
	LWWWW	TITLOGO3, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, 0
	LWWWW	TITLOGO4, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, -1, 0

**************************************************************************
*								         *
* atfadeall								 *
*								         *
**************************************************************************

atfadeall
	MOVI	PID_COLOR,A0			;KILL JOIN IN CYCLES
	CALLA	KILLPROC_ALL
	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	CLR	A0
	CALLA	FADEOUT				;FADE DOWN ALL PALETTES
	MOVK	16,A9
	CREATE	PID_SKY,SKYDOWN			;FADE DOWN "SKY" COLOR
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS
	calla	MYOINIT			;RE-INIT THE OBJECT LIST
	calla	CLR_SCRN		;WIPE OUT THE BIT MAP
	RETP

atfadeup
	clr	a0
	move	a0,@BLACKOUT,W
	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	CLR	A0
	CALLA	FADEIN
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS
	RETP

;**************************************************************************
;*								         *
;* LAMP_DEMO_PROC							 *
;*								         *
;**************************************************************************
;
;LAMP_DEMO_PROC
;LDP_LUPE1
;	CALLA	LAMPS_ON
;;	SLEEP	7
;	SLEEP	8
;
;	CALLA	LAMPS_OFF
;;	SLEEP	7
;	SLEEP	8
;;	DSJ	A8,LDP_LUPE1
;
;	JRUC	LAMP_DEMO_PROC

**************************************************************************
*								         *
* attract_mode_nhl							 *
*								         *
**************************************************************************
attract_mode_nhl
	callr	lgocom1
	movi	atnhl1_init,b0
	calla	EASYMAKE
	movi	atnhl2_init,b0
	calla	EASYMAKE
	JSRP	atfadeup
	RETP

atnhl1_init
	.long	NHLLIC1
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ATTRACT_LOGOS
	.long	[200,0],[90,0],0

atnhl2_init
	.long	NHLDSC1
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ATTRACT_LOGOS
	.long	[200,0],[210,0],0

**************************************************************************
*								         *
* attract_mode_nhlpa							 *
*								         *
**************************************************************************
attract_mode_nhlpa
	callr	lgocom1
	movi	atnhlpa1_init,b0
	calla	EASYMAKE
	movi	atnhlpa2_init,b0
	calla	EASYMAKE
	movi	atnhlpa3_init,b0
	calla	EASYMAKE
	JSRP	atfadeup
	RETP

atnhlpa1_init
	.long	NHLPADSC1
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ATTRACT_LOGOS
	.long	[200,0],[220,0],0

atnhlpa2_init
	.long	NHLPADSC2
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ATTRACT_LOGOS
	.long	[200,0],[18,0],0

atnhlpa3_init
	.long	NHLPALGO
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ATTRACT_LOGOS
	.long	[200,0],[115,0],0

**************************************************************************
*								         *
* attract_mode_archive							 *
*								         *
**************************************************************************
attract_mode_archive
	callr	lgocom1
	movi	archive_init,b0
	calla	EASYMAKE
	movi	archive2_init,b0
	calla	EASYMAKE
	JSRP	atfadeup
	RETP

archive_init		
	.long	alt_ARCHIVE
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ATTRACT_LOGOS
	.long	[200,0],[120,0],0

alt_ARCHIVE:
	.word   04780H,132,10
	.long   065ce655H
	.word   66,9
	.long   DISCLAIMP

archive2_init		
	.long	HOLDING
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ATTRACT_LOGOS
	.long	[200,0],[120,0],0

**************************************************************************
*								         *
* coolest_game								 *
*								         *
**************************************************************************
coolest_game
	callr	lgocom1
	movi	coolest_init,b0
	calla	EASYMAKE
	JSRP	atfadeup
	RETP

coolest_init
	.long	COOLEST
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ATTRACT_LOGOS
	.long	[200,0],[120,0],0

lgocom2	calla	WIPEOUT			; LATER, DUDES!
	PAGEON
	movk	1,a14
	move	a14,@GAMERASE,W		;DO IT!
	DISPON
	clr	a0
	move	a0,@IRQSKYE,W
	movk	1,a0
	move	a0,@BLACKOUT,W
	rets

lgocom1	callr	attract_page_common
	movk	1,a0
	move	a0,@BLACKOUT,W
	rets

**************************************************************************
*								         *
* attract_mode_logos							 *
*								         *
**************************************************************************
start_attract_game
	calla	clear_all_player_blocks
	clr	a0
	move	a0,@hot_player,W
	move	a0,@TEAM1_SWAP,W
	move	a0,@TEAM2_SWAP,W
	move	a0,@hold_net_anim,W
	calla	set_background_tune
	calla	MY_WIPEOUT
	movk	1,a0
	move	a0,@in_at_game,W

	CALLA	RESET_POWERUP_FLAGS

	MOVK	ADJTOURMODE,A0
	CALLA	GET_ADJ				;SET TOURNAMENT MODE
	NEG	A0
	MOVE	A0,@TOURN_MODE,W

	movi	FLOATRCP,a0		;palette for small score box
	calla	GETFPAL
	movi	CITYP,a0		;palette for small score box stuff
	calla	GETFPAL

	CREATE	PID_ORGAN,ORGAN_PROC
	CREATE	PID_CROWD_NOISE,CROWD_NOISE_PROC
	calla	init_speech_buffer
	clr	a0
	move	a0,@team1_score,W
	move	a0,@team2_score,W
	move	a0,@period,W
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
	movk	26,a0
	calla	RANDU
	move	a0,@team1,W
	move	a0,a1
	movk	26,a0
	calla	RANDU
	cmp	a0,a1
	jrnz	plns
	movk	26,a0
	calla	RANDU		;if both teams are the same, try one more time (less often)
plns	move	a0,@team2,W
	clr	a0
	move	a0,@team2_home,W
	inc	a0
	move	a0,@team1_home,W
	movk	1,a1
	move	a1,@period
	clr	a0
	move	a0,@PLAYER_BITS,W
	calla	fix_curplyrs
	movi	-124,a0
	move	a0,@WORLDY+010h,W
	clr	a0
	move	a0,@WORLDX,L
	calla	create_puck
	C_A_KP	PID_WATCH,all_watch		;must create watch before players, so it runs after players
	calla 	create_players			;players are now cleaned up in watch process
	calla	create_rink
	C_A_KP	PID_GAME_TIMER,game_timer

	MOVI	[15,201],A9			;SCREEN [Y,X] POSITION
	MOVI	[1000,0],A10			;Z POSITION
	C_A_KP	PID_CREDIT,DISPLAY_CREDIT_PROC

	calla	init_timer_value
	clr	a0
	move	a0,@timer_on,W
	movi	400,a0			;take us through to face off
	calla	show_timer		;show timer for a while
	clr	a0		;faceoff at 0,339
	movi	339,a1
	calla	spx_period_faceoff
	calla	faceoff
	jauc	store_players_tired

stop_attract_game
	callr	stop_attract_game_quick
	SLEEP	70

	MOVI	PID_COLOR,A0			;KILL JOIN IN CYCLES
	CALLA	KILLPROC_ALL
	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	movi	nolist,a0
	CALLA	FADEOUTF			;FADE DOWN ALL PALETTES
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS

	clr	a14
	move	a14,@small_timer_on,W

	calla	WIPEOUT
	movim	SCRNST_FULL,@SCRNTL,L
	movk	1,a0
	move	a0,@GAMERASE,W		;AUTO-ERASE FULL
	move	a0,@DISPLAYON,W
	RETP
stop_attract_game_quick
	calla	kill_all_sound
stop_attract_game_quick_SNDOK		;DON'T KILL SOUND ENTRY POINT
	movk	1,a14
	move	a14,@killtrails,W	;kill all existing puck trails
;	calla	kill_all_sound
;	MOVI	air_horn_blast,A4
;	CALLA	do_sound
	calla	replace_all_turbo_palettes
	calla	stop_timer
	callr	stop_all_objects
	clr	a0
	move	a0,@timer_on,W		;so when we turn it on next, is not <0
	movi	101,a0
	move	a0,@PUCK_MODE,W		;puck is in period over mode
	clr	a0
	move	a0,@SCROLLX,L
	move	a0,@in_at_game,W
	calla	kill_all_animations
	jauc	KILL_DESTRUCTIBLES

stop_all_objects
	clr	a1
	MOVI	FGLIST,A0
	move	a0,a4
	jruc	sao_2
sao_1	move	a1,*a0(OYACCEL),W
	move	a1,*a0(OXVEL),L
	move	a1,*a0(OYVEL),L
	move	a1,*a0(OZVEL),L
sao_2	move	*a0,a0,L
	cmp	a0,a4
	jrnz	sao_1
	rets

attract_page_common
	CALLA	WIPEOUT			; LATER, DUDES!
	PAGEON
	MOVK	1,A14
	MOVE	A14,@GAMERASE,W		;DO IT!
	DISPON
	calla	init_speech_buffer
	clr	a0
	move	a0,@IRQSKYE,W
	rets

**************************************************************************
*								         *
* congratulations_page							 *
* 	input	all_beaten_bits = players that beat this game		 *
*								         *
**************************************************************************
congratulations_page
	clr	a1
	dec	a1
	clr	a2
	dec	a2
	clr	a4
	dec	a4
	callr	cpga
	move	a1,a1
	jrn	cp_nok
	move	a4,a0
	jrp	cp_ok
	jruc	cp_nok
cp_ok	JSRP	game_over_all_26
	JSRP	atfadeall
cp_nok	RETP
cpga	move	@all_beaten_bits,a0,W
	movk	1,a3
	callr	cpg1
	movk	5,a3
cpg1	callr	cpg2
	inc	a3
cpg2	move	a3,a14
	dec	a14
	btst	a14,a0
	jrz	cpg29
	GBLOCK	a3,a14
	move	*a14(POF_TEAM),a4,W
	movb	*a14(POF_NUMBER),a6
	move	*a14(POF_CMOS),a14,W
	jrn	cpg29
	move	a1,a1
	jrnn	cpg24
	move	a14,a1
	move	a6,a5
	jruc	cpg29
cpg24	move	a2,a2
	jrnn	cpg29
	move	a14,a2
cpg29	rets

**************************************************************************
*								         *
* game_over_all_26 - all 26 teams beat					 *
* 	input	a0 = team number					 *
* 		a1 = cmos record of player				 *
* 		a2 = -1 no 2nd player					 *
* 		   = cmos record of 2nd. player				 *
* 		a5 = first player #					 *
*								         *
**************************************************************************
game_over_all_26
;	movi	1111b,a0
;	move	a0,@LAST_PLAYER_BITS,W
;	movi	INEPILOG,a0
;	move	a0,@GAME_STATE,W
;	movk	15,a0
;	movk	1,a1
;;	movk	2,a2
;	movi	-1,a2
;	movk	1,a5

	move	a0,@sound_store_t1,W
	move	a1,@sound_store_c1,W
	move	a2,@sound_store_c2,W
	move	a5,@sound_store_fp,W
	move	a0,*a13(PDATA),L
	move	a1,*a13(PDATA+020h),L
	move	a2,*a13(PDATA+040h),L
	callr	lgocom2
	C_A_K	PID_CONGRATS_SND,con_sd1
	MOVI	GFONT10CP,A0
	calla	GETFPAL
	movi	gostct,a2
goan2	move	*a2+,a14,L
	jrz	goan1
	move	a14,b0
	calla	EASYMAKE
	move	*a2+,a1,L
	jrz	goan3
	calla	STRT_ANIM
goan3	move	*a2+,a7,L
	jrz	goan2
	calla	PROCESS_FORK
	jruc	goan2
goan1	JSRP	atfadeup
	SLEEP	275
	move	*a13(PDATA+020h),a0,L
	movi	[132,200],a9
	callr	gogol
	JSRP	PRINTF
	move	*a13(PDATA+040h),a0,L
	jrn	do21hv
	movi	[158,200],a9
	callr	gogol
	JSRP	PRINTF
do21hv	movk	10,a9
do21	callr	do_sp
	SLEEP	4
	callr	do_sp
	SLEEP	18
	dsjs	a9,do21
	JSRP	atfadeall
	callr	lgocom2
	;
	C_A_K	PID_CONGRATS_SND,con_sd2
	P_FORK	watch_supp7
	movi	ORGTXT1P,a0
	calla	GETFPAL
	movi	REDTXT3P,a0
	calla	GETFPAL
	movi	stanley_cup_back_init,b0
	calla	MULTIMAKE
	movi	stanley_cup_girls_init,b0
	calla	EASYMAKE
	P_FORK	atfproc
	movi	stanley_cup_anim,a1
	calla	STRT_ANIM
	movi	stc_text_01,a11		;beginning
	JSRP	goupdc
	movi	stc_text_01_1,a11		;beginning
	JSRP	goupd
	move	*a13(PDATA),a0,L
	movi	stctms-32,a11		;full text with team up to initials
	sll	5,a0
	add	a0,a11
	move	*a11,a11,L
	JSRP	goupd
	movi	stc_text_02,a11		;more text
	JSRP	goupd
	move	*a13(PDATA+020h),a1,L
	move	*a13(PDATA+040h),a2,L
	movi	string_build_area,a5
	move	a1,a0
	calla	get_cmos_record_a
	move	@b_initial1,a14,W
	callr	cpin
	move	@b_initial2,a14,W
	callr	cpin
	move	@b_initial3,a14,W
	callr	cpin
	move	a2,a2
	jrn	fhoo
	movi	stc_text_03_2,a4
	callr	cpst
	move	a2,a0
	calla	get_cmos_record_a
	move	@b_initial1,a14,W
	callr	cpin
	move	@b_initial2,a14,W
	callr	cpin
	move	@b_initial3,a14,W
	callr	cpin
fhoo	clr	a0
	movb	a0,*a5
	addk	8,a5
	dec	a0
	movb	a0,*a5
	movi	string_build_area,a11	;initials
	JSRP	goupdc
	movi	stc_text_04,a11		;last text
	JSRP	goupd
	JSRP	wait_text_up
	JSRP	atfadeall
	callr	lgocom1
	;
	P_FORK	watch_supp7
	movi	REDTXT3P,a0
	calla	GETFPAL
	movi	ORGTXT1P,a0
	calla	GETFPAL
	MOVI	GLDTXT5P,A0
	calla	GETFPAL
	movi	stanley_cup_back_init,b0
	calla	MULTIMAKE
	P_FORK	atfpr2c

	movi	stc_over,a11		;more text
	JSRP	goupdx

	JSRP	wait_text_up
	JSRP	atfadeall
	callr	lgocom1

	RETP

atfpr2c	JSRP	atfadeup
	MOVI	REDTXT3P,A8
	MOVK	20,A9
	MOVK	4,A10
	MOVK	5,A11
	CREATE	PID_COLOR,CYCLE16
	MOVI	ORGTXT1P,A8
	MOVK	20,A9
	MOVK	4,A10
	MOVK	5,A11
	CREATE	PID_COLOR,CYCLE16
;	MOVI	GLDTXT5P,A8
;	MOVK	20,A9
;	MOVK	4,A10
;	MOVK	5,A11
;	CREATE	PID_COLOR,CYCLE16
	jauc	SUCIDE

atfproc	JSRP	atfadeup
	MOVI	REDTXT3P,A8
	MOVK	20,A9
	MOVK	4,A10
	MOVK	5,A11
	CREATE	PID_COLOR,CYCLE16
	MOVI	ORGTXT1P,A8
	MOVK	20,A9
	MOVK	4,A10
	MOVK	5,A11
	CREATE	PID_COLOR,CYCLE16
	jauc	SUCIDE

gogol	callr	a0_to_string
	clr	a14
	movb	a14,*a5
	movi	string_build_area,a8
	movi	HFPAL,a5
	movk	8,a0
	movi	STRCNCO,a1
	movi	OID_GIRLTEXT,b1
	movi	[1,1],a10
	movi	H18TFONT,a11
	rets

do_sp	movi	spark_init,b0
	calla	EASYMAKE
	movk	5,a0
	calla	RAND0
	sll	5,a0
	addi	spktab,a0
	move	*a0,a0,L
	move	a0,*a8(OXPOS),W
	sra	16,a0
	move	a0,*a8(OYPOS),W
	movi	-100,a0
	move	a0,*a8(OZPOS),W
	calla	INSERT_SCREEN_OBJ
	movi	spark_script,a1
	jauc	STRT_ANIM

cpin	calla	PENACHO_TO_ASCII
	movb	a14,*a5
	addk	8,a5
	rets

cpst	setf	8,0,0			;for byte moves
cps1	move	*a4+,a14,0
	jrz	cps2
	move	a14,*a5+,0
	jruc	cps1
cps2	setf	16,1,0
	rets

goupd	movb	*a11,a14
	jrn	gud9
	JSRP	wait_til_onok
	callr	stk_str
gu1d	addk	8,a11
	movb	*a11,a14
	jrnz	gu1d
	addk	8,a11
	jruc	goupd
gud9	RETP

goupdx	move	a11,a14
	srl	4,a11
	sll	4,a11
	cmp	a11,a14
	jrz	gut1
	addi	010h,a11
gut1	movb	*a11,a14
	jrn	gudx9
	JSRP	wait_til_onok
	move	*a11+,a14,W
	add	a14,a9
	callr	stk_ctr
gu1dx	addk	8,a11
	movb	*a11,a14
	jrnz	gu1dx
	addk	8,a11
	jruc	goupdx
gudx9	RETP

goupdc	movb	*a11,a14
	jrn	gudc9
	JSRP	wait_til_onok
	callr	stk_strc
gu1dc	addk	8,a11
	movb	*a11,a14
	jrnz	gu1dc
	addk	8,a11
	jruc	goupdc
gudc9	RETP

wto1	SLEEP	2
wait_til_onok
	clr	a9
	move	@SUPPLSTS+7*20h,a8,L
	jrz	wto6
wto2	move	*a8(OYPOS),a14,W
	move	*a8(OSIZEY),a0
	add	a14,a0
;	cmp	a9,a0
;	jrle	wto4
	move	a0,a9
;wto4	move	*a8(OSLINK),a8,L
;	jrnz	wto2
wto6	cmpi	250,a9
	jrge	wto1
	addi	6,a9
	RETP

stk_strc		;different color
	mmtm	sp,a11
	move	a11,a8
	sll	16,a9
	addi	280,a9
	movi	HFPAL+0101h,a5
	jruc	stks1

stk_ctr	mmtm	sp,a11		;center of whole screen
	move	*a11+,a5,W
	move	a11,a8
	sll	16,a9
	addi	200,a9
	jruc	stks1

stk_str	mmtm	sp,a11
	move	a11,a8
	sll	16,a9
	addi	280,a9
	movi	HFPAL,a5
stks1	clr	a0
	movi	STRCNCO,a1
	movi	OID_GIRLTEXT,b1
	clr	a10		;no spacing
	movi	H18TFONT,a11
	PUSHST
	DINT
	JSRP	PRINTF
;	callr	run_through_vels
	POPST
	callr	run_through_vels
	mmfm	sp,a11
	rets

wait_text_up
wtu1	callr	find_lowest_supp7
	cmpi	50,a0
	jrlt	wtu2
	SLEEP	5
	jruc	wtu1
wtu2	RETP

find_lowest_supp7
	movi	-1,a0
	move	@SUPPLSTS+7*20h,a8,L
	jrz	fls9
fls10	move	*a8(OYPOS),a14,W
	cmp	a0,a14
	jrle	fls11
	move	a14,a0
fls11	move	*a8(OSLINK),a8,L
	jrnz	fls10
fls9	rets

run_through_vels
	calla	get_button_s_mask
	move	a9,a0
	jrnz	goa22
	movi	-0c000h,a0
	jruc	goa22a
goa22	movi	-50000h,a0
goa22a	move	@SUPPLSTS+7*20h,a8,L
	jrz	goa93
goa_2	move	*a8(OYVEL),a14,L
	cmp	a14,a0
	jrz	goa93		;once we hit our desired vel, we have gone far
	move	a0,*a8(OYVEL),L	;enough through list
	move	*a8(OSLINK),a8,L
	jrnz	goa_2
goa93	rets

watch_supp7
ws7_1	move	@SUPPLSTS+7*20h,a8,L
	jrz	ws7_5
	calla	get_button_s_mask
	move	a9,a0
	jrnz	aoa22
	movi	-0c000h,a0
	jruc	ws7_2
aoa22	movi	-50000h,a0
ws7_2	move	a0,*a8(OYVEL),L
	move	*a8(OYPOS),a1,W
	move	*a8(OSLINK),a9,L
	cmpi	-40,a1
	jrgt	ws7_3
	calla	DELETE_OBJ
ws7_3	move	a9,a8
	jrnz	ws7_2
ws7_5	SLEEP	5
	jruc	ws7_1

spktab	.word	215,11
	.word	165,15
	.word	185,99
	.word	227,190
	.word	174,227

spark_init
	.long	SPARK01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID
	.word	OID_BIGGIRLS

spark_script
	LW	SPARK01,1
	LW	SPARK02,1
	LW	SPARK03,1
	LW	SPARK04,1
	LW	SPARK05,1
	LW	SPARK04,1
	LW	SPARK03,1
	LW	SPARK02,1
	LWL	1,AFUNC|1,a_delete_obj

a0_to_string
	movi	string_build_area,a5
	calla	get_cmos_record_a
	move	@b_initial1,a14,W
	callr	cpin
	move	@b_initial2,a14,W
	callr	cpin
	move	@b_initial3,a14,W
	jruc	cpin

gostct	.long	a26_1_lchr_init,b26_lc_script,0
	.long	a26_1_rchr_init,b26_rc_script,0
	.long	a26_1_h_init,b26_h_script,slide_hl
	.long	a26_1_s_init,b26_s_script,slide_sd
	.long	a26_1_stc_init,0,slide_sc
	.long	a26_1_stt_init,0,slide_st
	.long	0

slide_hl
	SLEEP	20
shl0	move	*a8(OXVAL),a0,L
	move	*a8(OANIOFFX),a14,W
	sll	16,a14
	add	a14,a0
	cmpi	[84,0],a0
	jrge	shl9
	subi	[104,0],a0
	sra	4,a0
	neg	a0
	cmpi	[2,0],a0
	jrlt	shl2
	movi	[2,0],a0
shl2	sll	1,a0
	move	a0,*a8(OXVEL),L
	SLEEP	2
	jruc	shl0
shl9	clr	a0
	move	a0,*a8(OXVEL),L
	jauc	SUCIDE

slide_sd
	SLEEP	20
ssd0	move	*a8(OXVAL),a0,L
	move	*a8(OANIOFFX),a14,W
	sll	16,a14
	add	a14,a0
	cmpi	[310,0],a0
	jrle	ssd9
	subi	[290,0],a0
	sra	4,a0
	neg	a0
	cmpi	[-2,0],a0
	jrgt	ssd2
	movi	[-2,0],a0
ssd2	sll	1,a0
	move	a0,*a8(OXVEL),L
	SLEEP	2
	jruc	ssd0
ssd9	clr	a0
	move	a0,*a8(OXVEL),L
	jauc	SUCIDE

slide_sc
	SLEEP	150
	movi	s_scoring_horn,a4
	calla	do_sound
sssc1	move	*a8(OYVAL),a0,L
	move	*a8(OANIOFFY),a14,W
	sll	16,a14
	add	a14,a0
	cmpi	[245,0],a0
	jrle	sssc8
	subi	[225,0],a0
	sra	5,a0
	neg	a0
	cmpi	-018000h,a0
	jrgt	sssc2
	movi	-018000h,a0
sssc2	sll	1,a0
	move	a0,*a8(OYVEL),L
	SLEEP	2
	jruc	sssc1
sssc8	clr	a14
	move	a14,*a8(OYVEL),L
	calla	spx_stanley_1
	jauc	SUCIDE

slide_st
	SLEEP	250
slst1	move	*a8(OYVAL),a0,L
	move	*a8(OANIOFFY),a14,W
	sll	16,a14
	add	a14,a0
	cmpi	[61,0],a0
	jrge	slst9
	movi	[3,0],a0
	sll	1,a0
	move	a0,*a8(OYVEL),L
	SLEEP	1
	jruc	slst1
slst9	clr	a0
	move	a0,*a8(OYVEL),L
	movi	S_EXPLO_4,a4
	calla	do_sound
	movi	wytab,a9
sla21	move	*a9+,a0,W
	jrz	sla29
	move	*a8(OYPOS),a14,W
	add	a14,a0
	move	a0,*a8(OYPOS),W
	SLEEP	1
	jruc	sla21
sla29	jauc	SUCIDE

wytab	.word	7,-7,7,-7,7,-7,6,-6,6,-6,6,-6
	.word	5,-5,5,-5,5,-5,4,-4,4,-4,3,-3
	.word	3,-3,3,-3,2,-2,2,-2,2,-2,0

b26_lc_script
	LW	LCHEER01,4
	LW	LCHEER02,4
	LW	LCHEER03,4
	LW	LCHEER04,3
	.long	0
b26_rc_script
	LW	RCHEER01,4
	LW	RCHEER02,5
	LW	RCHEER03,4
	LW	RCHEER04,4
	.long	0

b26_h_script
	LW	HBIGG01,6
	LW	HBIGG02,7
	LW	HBIGG03,6
	LW	HBIGG04,7
	LW	HBIGG03,6
	LW	HBIGG02,7
	.long	0

b26_s_script
	LW	SBIGG01,6
	LW	SBIGG02,6
	LW	SBIGG03,6
	LW	SBIGG04,6
	LW	SBIGG03,5
	LW	SBIGG02,6
	.long	0

a26_1_lchr_init
	.long	LCHEER01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_BIGGIRLS
	.long	[0,0],[0,0],10

a26_1_rchr_init
	.long	RCHEER01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_BIGGIRLS
	.long	[225,0],[0,0],10

a26_1_h_init
	.long	HBIGG01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_BIGGIRLS
;	.long	[84,0],[244,0],0
	.long	[-150,0],[244,0],0

a26_1_s_init
	.long	SBIGG01
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_BIGGIRLS
;	.long	[310,0],[244,0],0
	.long	[550,0],[244,0],0

a26_1_stc_init
	.long	STANCUPX
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_BIGGIRLS
;	.long	[200,0],[280,0],-10
	.long	[197,0],[530,0],-10

a26_1_stt_init
	.long	STANTYPE
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_BIGGIRLS
	.long	[200,0],[35-100,0],-15

stanley_cup_girls_init
	.long	STANCUP1
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_BIGGIRLS
	.long	[95,0],[241,0],-10

stanley_cup_anim
	LW	STANCUP1,80
	LW	STANCUP2,5
	LW	STANCUP3,1
scal1	LWLL	1,AFUNC|127,a_branch+2,scal1

stanley_cup_back_init
	.byte	4, 0, 0, 1	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	TOPICE02P	;IMGPAL
	.word	OID_JUNK, OM_POS|OM_INSERT	;OID, GLOBAL_OPTIONS
	.long	[0,0],[0,0],0
	LWWWW	TOPICEA, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	TOPICEB, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	TOPICEC, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0
	LWWWW	TOPICED, DMAWNZ, M_SCRNOBJ|M_NOVEL|M_NOSCALE, 0, 0

stc_text_01	.string "                                         .",0
		.string "                                         .",0
		.string "                                         .",0
		.string "                                         .",0
		.string "                                         .",0
		.string	"CONGRATULATIONS",0
		.string "                                         .",0
		.string "                                         .",0
		.string "                                         .",0
		.byte	-1
		.even

stc_text_01_1	.string	"YOU HAVE",0
		.string	"DEFEATED ALL",0
		.string	"26 NHL TEAMS",0
		.string	"AND HAVE LED",0
		.byte	-1
		.even

stc_text_02	.string "                                         .",0
		.string "                                         .",0
		.string	"AS A MEMBER OF",0
		.string	"THE 1996",0
		.string	"CHAMPIONSHIP",0
		.string	"TEAM, YOU EARN",0
		.string	"THE RIGHT",0
		.string	"TO HAVE ",0
		.byte	-1
		.even

stc_text_03_2	.string	" - ",0
		.byte	-1
		.even

stc_text_04	.string	"ENGRAVED ON",0
		.string	"LORD STANLEY'S",0
		.string	"CUP], THE MOST",0
		.string	"PRESTIGIOUS",0
		.string	"TROPHY OF ALL",0
		.string	"PROFESSIONAL",0
		.string	"SPORTS.",0
		.string "                                         .",0
		.string "                                         .",0
		.string	"YOU WILL NOW",0
		.string	"HAVE TO",0
		.string	"DEFEND YOUR",0
		.string	"[STANLEY CUP][",0
		.string	"CHAMPIONSHIP",0
		.string	"TITLE AGAINST",0
		.string	"A BARRAGE OF",0
	    	.string	"NEW AND",0
		.string	"DIFFICULT",0
		.string	"MATCH UPS.",0
		.string "                                         .",0
		.string "                                         .",0
		.string	"YOU HAVE EARNED",0
		.string	"THIS AS A",0
		.string	"RESULT OF YOUR",0
		.string	"OUTSTANDING",0
		.string	"SKILL AND",0
		.string	"EXCELLENT",0
		.string	"TEAMWORK.",0
		.string "                                         .",0
		.string "                                         .",0
		.string	"THANK YOU FOR",0
		.string	"PLAYING",0
		.string	"OPEN ICE",0
		.byte	-1
		.even

stctms	.long	stc_tm_01,stc_tm_02,stc_tm_03,stc_tm_04,stc_tm_05
	.long	stc_tm_06,stc_tm_07,stc_tm_08,stc_tm_09,stc_tm_10
	.long	stc_tm_11,stc_tm_12,stc_tm_13,stc_tm_14,stc_tm_15
	.long	stc_tm_16,stc_tm_17,stc_tm_18,stc_tm_19,stc_tm_20
	.long	stc_tm_21,stc_tm_22,stc_tm_23,stc_tm_24,stc_tm_25
	.long	stc_tm_26

stc_tm_01	.string	"THE BOSTON",0
		.string	"BRUINS TO THEIR",0
		.string	"FIRST STANLEY",0
		.string	"CUP] VICTORY IN",0
		.string	"24 YEARS.",0
		.byte	-1
		.even

stc_tm_02	.string	"THE BUFFALO",0
		.string	"SABRES TO THEIR",0
		.string	"FIRST EVER",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY.",0
		.byte	-1
		.even

stc_tm_03	.string	"THE HARTFORD",0
		.string	"WHALERS TO",0
		.string	"THEIR FIRST",0
		.string	"EVER STANLEY",0
		.string	"CUP] VICTORY.",0
		.byte	-1
		.even

stc_tm_04	.string	"THE MONTREAL",0
		.string	"CANADIENS TO",0
		.string	"THEIR 25TH",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY.",0
		.byte	-1
		.even

stc_tm_05	.string	"THE OTTAWA",0
		.string	"SENATORS TO",0
		.string	"THEIR FIRST",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY OF THE",0
		.string	"MODERN ERA.",0
		.byte	-1
		.even

stc_tm_06	.string	"THE PITTSBURGH",0
		.string	"PENGUINS TO",0
		.string	"THEIR 3RD",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY.",0
		.byte	-1
		.even

stc_tm_07	.string	"THE COLORADO",0
		.string	"AVALANCHE TO A",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY THEIR",0
		.string	"FIRST SEASON",0
		.string	"IN COLORADO.",0
		.byte	-1
		.even

stc_tm_08	.string	"THE FLORIDA",0
		.string	"PANTHERS TO A",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY IN",0
		.string	"THEIR THIRD",0
		.string	"SEASON OF PLAY.",0
		.byte	-1
		.even

stc_tm_09	.string	"THE NEW JERSEY",0
		.string	"DEVILS TO AN",0
		.string	"AMAZING REPEAT",0
		.string	"PERFORMANCE OF",0
		.string	"LAST YEARS",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY.",0
		.byte	-1
		.even

stc_tm_10	.string	"THE NEW YORK",0
		.string	"ISLANDERS TO",0
		.string	"THEIR FIRST",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY IN",0
		.string	"13 YEARS.",0
		.byte	-1
		.even

stc_tm_11	.string	"THE NEW YORK",0
		.string	"RANGERS TO",0
		.string	"THEIR 5TH",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY.",0
		.byte	-1
		.even

stc_tm_12	.string	"THE",0
		.string	"PHILADELPHIA",0
		.string	"FLYERS TO",0
		.string	"THEIR FIRST",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY IN",0
		.string	"21 YEARS.",0
		.byte	-1
		.even

stc_tm_13	.string	"THE TAMPA BAY",0
		.string	"LIGHTNING TO A",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY IN",0
		.string	"THEIR FOURTH",0
		.string	"SEASON OF PLAY.",0
		.byte	-1
		.even

stc_tm_14	.string	"THE WASHINGTON",0
		.string	"CAPITALS TO",0
		.string	"THEIR FIRST",0
		.string	"EVER STANLEY",0
		.string	"CUP] VICTORY.",0
		.byte	-1
		.even

stc_tm_15	.string	"THE CHICAGO",0
		.string	"BLACKHAWKS TO",0
		.string	"THEIR FIRST",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY IN",0
		.string	"35 YEARS.",0
		.byte	-1
		.even

stc_tm_16	.string	"THE DALLAS",0
		.string	"STARS TO THEIR",0
		.string	"FIRST EVER",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY.",0
		.byte	-1
		.even

stc_tm_17	.string	"THE DETROIT",0
		.string	"RED WINGS TO",0
		.string	"THEIR FIRST",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY IN",0
		.string	"41 YEARS.",0
		.byte	-1
		.even

stc_tm_18	.string	"THE ST. LOUIS",0
		.string	"BLUES TO THEIR",0
		.string	"FIRST EVER",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY.",0
		.byte	-1
		.even

stc_tm_19	.string	"THE TORONTO",0
		.string	"MAPLE LEAFS TO",0
		.string	"THEIR 14TH",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY.",0
		.byte	-1
		.even

stc_tm_20	.string	"THE WINNIPEG",0
		.string	"JETS TO THEIR",0
		.string	"FIRST EVER",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY.",0
		.byte	-1
		.even

stc_tm_21	.string	"THE MIGHTY",0
		.string	"DUCKS OF",0
		.string	"ANAHEIM TO A",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY IN",0
		.string	"THEIR THIRD",0
		.string	"SEASON OF PLAY.",0
		.byte	-1
		.even

stc_tm_22	.string	"THE CALGARY",0
		.string	"FLAMES TO THEIR",0
		.string	"[2ND STANLEY CUP][",0
		.string	"VICTORY.",0
		.byte	-1
		.even

stc_tm_23	.string	"THE EDMONTON",0
		.string	"OILERS TO THEIR",0
		.string	"[6TH STANLEY CUP][",0
		.string	"VICTORY.",0
		.byte	-1
		.even

stc_tm_24	.string	"THE LOS ANGELES",0
		.string	"KINGS TO THEIR",0
		.string	"FIRST EVER",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY.",0
		.byte	-1
		.even

stc_tm_25	.string	"THE SAN JOSE",0
		.string	"SHARKS TO A",0
		.string	"[STANLEY CUP][",0
		.string	"VICTORY IN",0
		.string	"THEIR FIFTH",0
		.string	"SEASON OF PLAY.",0
		.byte	-1
		.even

stc_tm_26	.string	"THE VANCOUVER",0
		.string	"CANUCKS TO",0
		.string	"THEIR FIRST",0
		.string	"EVER STANLEY",0
		.string	"CUP] VICTORY.",0
		.byte	-1
		.even

con_sd2
	movk	22,a0
	calla	set_tune_a0_safe
	movi	s_whistle,a4
	calla	do_sound
	jauc	SUCIDE

;S_EXPLO_4		.EQU	284
;s_scoring_horn		.equ	286

con_sd1	clr	a0
	calla	set_tune_a0_safe
	P_FORK	crwdfl
	jauc	SUCIDE

crwdfl	movk	7,a0
	calla	RAND0
	sll	4,a0
	addi	crdtbs,a0
	move	*a0,a4,W
	calla	do_sound
	SLEEP	30
	jruc	crwdfl

crdtbs	.word	S_CROWD_1
	.word	S_CROWD_3
	.word	S_CROWD_4
	.word	S_CROWD_5
	.word	S_CROWD_7
	.word	S_CROWD_9
	.word	S_CROWD_10

stc_over
	.word	0,HFPAL+0000h
	.string	"                                                                 .",0
	.word	0,HFPAL+0000h
	.string	"                                                                 .",0
	.word	0,HFPAL+0000h
	.string	"                                                                 .",0
	.word	0,HFPAL+0000h
	.string	"                                                                 .",0
	.word	0,HFPAL+0000h
	.string	"                                                                 .",0
	.word	0,HFPAL+0000h
	.string	"                                                                 .",0
	.word	0,HFPAL+0000h
	.string	"                                                                 .",0
	.word	0,HFPAL+0000h
	.string	"                                                                 .",0

	.word	0,HFPAL+0000h
	.string	"OPEN ICE DESIGN TEAM",0

	.word	16,HFPAL+0101h
	.string	"MARK PENACHO - SOFTWARE",0
	.word	0,HFPAL+0101h
	.string	"JACK HAEGER - GRAPHICS",0

	.word	16,HFPAL+0101h
	.string	"BILL DABELSTEIN - SOFTWARE",0
	.word	0,HFPAL+0101h
	.string	"JON HEY - SOUNDS AND MUSIC",0
	.word	0,HFPAL+0101h
	.string	"CARLOS PESINA - GRAPHICS",0
	.word	0,HFPAL+0101h
	.string	"MARTIN MARTINEZ - GRAPHICS",0

	.word	16,HFPAL+0101h
	.string	"JOSH TSUI -  GRAPHICS",0
	.word	0,HFPAL+0101h
	.string	"MARY ANN ROHN - GRAPHICS",0

	.word	19,HFPAL+0000h
	.string	"EXECUTIVE PRODUCERS:",0
	.word	0,HFPAL+0101h
	.string	"NEIL NICASTRO",0
	.word	0,HFPAL+0101h
	.string	"KEN FEDESNA",0
	.word	0,HFPAL+0101h
	.string	"PAUL DUSSAULT",0

	.word	19,HFPAL+0000h
	.string	"GRAPHIC SUPPORT",0
	.word	0,HFPAL+0101h
	.string	"NIK EHRLICH",0

	.word	19,HFPAL+0000h
	.string	"SOFTWARE SUPPORT",0
	.word	0,HFPAL+0101h
	.string	"WARREN DAVIS",0
	.word	0,HFPAL+0101h
	.string	"MIKE LYNCH",0

	.word	19,HFPAL+0000h
	.string	"CAST OF CHARACTERS",0
	.word	4,HFPAL+0101h
	.string	"SKATER",0
	.word	0,HFPAL+0202h
	.string	"MIKE WALDRON",0
	.word	4,HFPAL+0101h
	.string	"GOALTENDER",0
	.word	0,HFPAL+0202h
	.string	"JACK HAEGER",0
	.word	4,HFPAL+0101h
	.string	"REFEREE",0
	.word	0,HFPAL+0202h
	.string	"JAY COHEN",0
	.word	4,HFPAL+0101h
	.string	"OPEN ICE GIRLS",0
	.word	0,HFPAL+0202h
	.string	"REBECCA SCOTT",0
	.word	0,HFPAL+0202h
	.string	"HEATHER BEACH",0

	.word	19,HFPAL+0000h
	.string	"VOICE OF OPEN ICE",0
	.word	0,HFPAL+0101h
	.string	"PAT FOLEY",0

	.word	19,HFPAL+0000h
	.string	"ON LOCATION CAMERAMAN",0
	.word	0,HFPAL+0101h
	.string	"JIM TIANIS",0

	.word	19,HFPAL+0000h
	.string	"ON LOCATION FILM SUPPORT",0
	.word	0,HFPAL+0101h
	.string	"TONY LABROSSE",0
	.word	0,HFPAL+0101h
	.string	"KEN MORENO",0

	.word	19,HFPAL+0000h
	.string	"COSTUMING",0
	.word	0,HFPAL+0101h
	.string	"CYNTHIA MANIATES",0

	.word	19,HFPAL+0000h
	.string	"UNBEATABLE ICE MASTERS",0
	.word	0,HFPAL+0101h
	.string	"MIKE VINIKOUR",0
	.word	0,HFPAL+0101h
	.string	"EDDIE FERRIER",0

	.word	19,HFPAL+0000h
	.string	"CUSTOM GOALIE EQUIPMENT",0
	.word	0,HFPAL+0101h
	.string	"McMARTIN HOCKEY PROTECTION",0
	.word	0,HFPAL+0202h
	.string	"SCOTT MARTIN",0

	.word	19,HFPAL+0000h
	.string	"PRO GOALIE MASKS",0
	.word	0,HFPAL+0101h
	.string	"WARWICK CUSTOM MASK",0
	.word	0,HFPAL+0202h
	.string	"GARY WARWICK",0

	.word	19,HFPAL+0000h
	.string	"STATISTICAL CONSULTANT",0
	.word	0,HFPAL+0101h
	.string	"SHERRY ROSS",0

	.word	19,HFPAL+0000h
	.string	"HARDWARE DESIGN",0
	.word	0,HFPAL+0101h
	.string	"MARK LOFFREDO",0
	.word	0,HFPAL+0101h
	.string	"RAY MACIKA",0
	.word	0,HFPAL+0101h
	.string	"PAT COX",0
	.word	0,HFPAL+0101h
	.string	"CARY MEDNICK",0
	.word	0,HFPAL+0101h
	.string	"RAY GAY",0
	.word	0,HFPAL+0101h
	.string	"JOHN LOWES",0

	.word	19,HFPAL+0000h
	.string	"SENIOR HARDWARE TECHNICIANS",0
	.word	0,HFPAL+0101h
	.string	"SHERIDAN OURSLER",0
	.word	0,HFPAL+0101h
	.string	"AL LASKO",0
	.word	0,HFPAL+0101h
	.string	"JEFF PETERS",0

	.word	19,HFPAL+0000h
	.string	"CREATIVE MEDIA",0
	.word	0,HFPAL+0101h
	.string	"ART TIANIS",0
	.word	0,HFPAL+0101h
	.string	"JOAN FAUX",0
	.word	0,HFPAL+0101h
	.string	"ANDY LYCKE",0
	.word	0,HFPAL+0101h
	.string	"JIM GREENE",0
	.word	0,HFPAL+0101h
	.string	"CHRISTA WOSS",0

	.word	19,HFPAL+0000h
	.string	"SALES AND MARKETING",0
	.word	0,HFPAL+0101h
	.string	"JOE DILLON",0
	.word	0,HFPAL+0101h
	.string	"RACHEL DAVIES",0
	.word	0,HFPAL+0101h
	.string	"LENORE SAYERS",0
	.word	0,HFPAL+0101h
	.string	"MARK CHAN",0
	.word	0,HFPAL+0101h
	.string	"ROGER SHARPE",0

	.word	19,HFPAL+0000h
	.string	"SOUND BITES",0
	.word	6,HFPAL+0101h
	.string	"SKATERS",0
	.word	0,HFPAL+0202h
	.string	"CORY HEXTALL",0
	.word	0,HFPAL+0202h
	.string	"MIKE WALDRON",0
	.word	0,HFPAL+0202h
	.string	"TODD FINNER",0
	.word	0,HFPAL+0202h
	.string	"JEFF FEATHERSTONE",0
	.word	0,HFPAL+0202h
	.string	"JACK HAEGER",0
	.word	6,HFPAL+0101h
	.string	"GRUNTS AND GROANS",0
	.word	0,HFPAL+0202h
	.string	"MARTIN MARTINEZ",0
	.word	0,HFPAL+0202h
	.string	"CARLOS PESINA",0
	.word	0,HFPAL+0202h
	.string	"JACK HAEGER",0
	.word	0,HFPAL+0202h
	.string	"MARK PENACHO",0
	.word	0,HFPAL+0202h
	.string	"BILL DABELSTEIN",0
	.word	0,HFPAL+0202h
	.string	"VINCE PONTARELLI",0

	.word	19,HFPAL+0000h
	.string	"LOCATION SOUND RECORDINGS",0
	.word	0,HFPAL+0101h
	.string	"JON HEY",0
	.word	0,HFPAL+0101h
	.string	"CARLOS PESINA",0
	.word	0,HFPAL+0101h
	.string	"MARK PENACHO",0

	.word	19,HFPAL+0000h
	.string	"PAT FOLEY SPEECH EDITORS",0
	.word	0,HFPAL+0101h
	.string	"JON HEY",0
	.word	0,HFPAL+0101h
	.string	"PAUL HEITSCH",0

	.word	19,HFPAL+0000h
	.string	"MANUAL",0
	.word	0,HFPAL+0101h
	.string	"KAREN TRYBULA",0

	.word	19,HFPAL+0000h
	.string	"ADDITIONAL SUPPORT",0
	.word	12,HFPAL+0101h
	.string	"GUNZO'S SPORTS CENTER INC.",0
	.word	0,HFPAL+0202h
	.string	"HELEN, JAY, JIMMY GUNZO",0
	.word	0,HFPAL+0202h
	.string	"TERRY MITCHELL, CARL SHOUFER",0
	.word	0,HFPAL+0202h
	.string	"JOE GRANO, GREG LADLE",0
	.word	0,HFPAL+0202h
	.string	"COLLETTE PARZYGNAT",0

	.word	12,HFPAL+0101h
	.string	"LONDON SOURCE FOR SPORTS",0

	.word	12,HFPAL+0101h
	.string	"MCFETRIDGE SPORTS CENTER",0
	.word	0,HFPAL+0202h
	.string	"STEVE DEMITRO",0

	.word	12,HFPAL+0000h
	.string	"PHOTO SOURCES",0
	.word	0,HFPAL+0101h
	.string	"RAY GRABOWSKI",0
	.word	0,HFPAL+0101h
	.string	"BRUCE BENNETT STUDIOS",0

	.word	19,HFPAL+0000h
	.string	"SPECIAL THANKS",0
	.word	0,HFPAL+0101h
	.string	"JOHN CARLTON",0
	.word	0,HFPAL+0101h
	.string	"MATT DAVIS",0
	.word	0,HFPAL+0101h
	.string	"LOU ISBITZ",0
	.word	0,HFPAL+0101h
	.string	"ED BOON",0
	.word	0,HFPAL+0101h
	.string	"EUGENE JARVIS",0
	.word	0,HFPAL+0101h
	.string	"SAL DIVITA",0
	.word	0,HFPAL+0101h
	.string	"PEG HEY",0
	.word	0,HFPAL+0101h
	.string	"CAROL DE CROIX",0
	.word	0,HFPAL+0101h
	.string	"JASON SKILES",0
	.word	0,HFPAL+0101h
	.string	"JOHN VOGEL",0
	.word	0,HFPAL+0101h
	.string	"MARK TURMELL",0
	.word	0,HFPAL+0101h
	.string	"ED KEENAN",0
	.word	0,HFPAL+0101h
	.string	"MATT BOOTY",0
	.word	0,HFPAL+0101h
	.string	"GARY PENACHO",0
	.word	0,HFPAL+0101h
	.string	"JACK A HAEGER",0
	.word	0,HFPAL+0101h
	.string	"PAT MCMAHON",0
	.word	0,HFPAL+0101h
	.string	"PAUL BARKER",0
	.word	0,HFPAL+0101h
	.string	"BRIAN EDDY",0
	.word	0,HFPAL+0101h
	.string	"TED VALVANIS",0
	.word	0,HFPAL+0101h
	.string	"CHRIS BOBROWSKI",0
	.word	0,HFPAL+0101h
	.string	"MIKE OSSIAN",0
	.word	0,HFPAL+0101h
	.string	"BRIAN FOLEY",0
	.word	6,HFPAL+0101h
	.string	"THE NICE GUYS",0
	.word	0,HFPAL+0202h
	.string	"STEVE BERAN",0
	.word	0,HFPAL+0202h
	.string	"DAVE MICHICICH",0
	.word	0,HFPAL+0202h
	.string	"TONY GOSKIE",0
	.word	0,HFPAL+0202h
	.string	"JOHN TOBIAS",0
	.word	6,HFPAL+0101h
	.string	"SCOTT PARRISH",0
	.word	0,HFPAL+0101h
	.string	"LE COQ SPORTIF",0
	.word	0,HFPAL+0101h
	.string	"BILL BREAKOUT",0

	.word	19,HFPAL+0000h
	.string	"VERY SPECIAL THANKS",0

	.word	12,HFPAL+0101h
	.string	"NHLE",0
	.word	6,HFPAL+0202h
	.string	"ILENE KENT",0
	.word	0,HFPAL+0202h
	.string	"WARD GLASSMEYER",0
	.word	0,HFPAL+0202h
	.string	"LYNN AMATO",0
	.word	0,HFPAL+0202h
	.string	"CATHERINE O'BRIAN",0

	.word	12,HFPAL+0101h
	.string	"NHLPA",0
	.word	6,HFPAL+0202h
	.string	"TED SASKIN",0
	.word	0,HFPAL+0202h
	.string	"DOUG REID",0
	.word	0,HFPAL+0202h
	.string	"KAREN ROSS",0

	.word	12,HFPAL+0101h
	.string	"MR. AND MRS.",0
	.word	0,HFPAL+0101h
	.string	"GORDIE HOWE",0

	.word	20,HFPAL+0000h
	.string	"FILMED ON LOCATION",0
	.word	0,HFPAL+0000h
	.string	"AND AT",0
	.word	0,HFPAL+0000h
	.string	"MIDWAY STUDIOS",0

	.word	6,HFPAL+0101h
	.string	"NGBAS",0

	.byte	-1
	.even
 
