	.MLIB	"HHMACS.LIB"
	.FILE	"HHSPEECH.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

	.INCLUDE	"HH.INC"		;Game equates
	.include	"hhspeech.e"
	.include	"hhsnd.g"
	.include	"hhutil.g"
	.include	"hhplayer.g"
	.include	"hhmisc.g"
	.include	"hhpuck.g"
	.include	"hhram.g"
	.include	"hhproc.g"
	.include	"hhscore.g"
	.include	"hhgame.g"
	.include	"hhscr_sk.g"
	.include	"hhtimer.g"
	.include	"hhgscr2.g"
	.include	"hhcmos.g"
	.include	"hhcontr2.g"
	.include	"hhspech2.g"
	.include	"hhattrct.g"
	.include	"hhpup.g"
	.include	"hhcontr3.g"
	.include	"hhhigher.g"

; end of include files

	.bss	last_name_spoken,16
	.bss	last_name_time,32
	.bss	center_spoken,16
	.bss	shot_type,16
	.bss	shot_call,16		;1,2,3 - where to make shot sound call
	.bss	last_shot_time,32	;time we called last shooting
	.bss	last_shot_player,16	;last player to shoot
	.bss	spfaceoff_address,32	;call this string at faceoff
	.bss	spfaceoff_call,16	;where to make faceoff call
	.bss	line_crossed,16
	.bss	line_crossed_time,32
	.bss	score_call_log,16	;hold last score call endlog
	.bss	last_dne,32
	.bss	goalie_phrase_time,32	;time of last goalie call
	.bss	goalie_phrase_num,16	;player base (1 or 0, uses puck position)
	.bss	estimated_speech_end,32

spx_theres_the_octopus
	calla	get_speech_time_remaining
	cmpi	20,a0
	jrhs	sttto9
	movi	spz_theres_the_octopus,a10
	jruc	handle_speech_string
sttto9	rets

spz_theres_the_octopus
	.word	00afdh,-65,0	;There's the octopus

spx_spagetti
	calla	get_speech_time_remaining
	cmpi	20,a0
	jrhs	spgt9
	movi	spz_spagetti,a10
	jruc	handle_speech_string
spgt9	rets

spz_spagetti
	.word	009c5h,-69		;He-s back on his feet
	.word	009c6h,-73,0		;but with spaghetti legs
	
spx_gordie_picked
	calla	get_speech_time_remaining
	cmpi	20,a0
	jrhs	stgpp9
	movi	spz_mr_hockey,a10
	jruc	handle_speech_string
stgpp9	rets

spz_mr_hockey
	.word	00dbch,-59,0		;Mr. Hockey (g.howe)

spx_what_a_beauty
	calla	get_speech_time_remaining
	cmpi	20,a0
	jrhs	stbea9
	movi	spz_what_a_beauty,a10
	jruc	handle_speech_string
stbea9	rets

spz_what_a_beauty
	.word	00b0ah,-57,0		;What a Beauty

spx_avalanche
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	sp_avalanche,a10
	callr	handle_speech_string
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

spx_change_in_lineup
	calla	get_speech_time_remaining
	cmpi	3,a0
	jrhs	stcil9
	movi	spz_change_in_lineup,a10
	callr	handle_speech_string
stcil9	rets

spz_change_in_lineup
	.word	00ab4h,-85,0		;A Change in the line-up

spx_stanley_1
	movi	spz_stan1,a10
	move	@sound_store_t1,a1,W
	move	@sound_store_fp,a2,W
	move	@sound_store_c2,a14,W
	jrn	handle_speech_string
	movi	spz_stan2,a10
	jruc	handle_speech_string

spz_stan1
	.word	-65
	.word	00aeah,-79		;Listen to the crowd
	.word	00af7h,-117		;This is the greatest game I've ever seen
	.word	-150
	.word	00ab2h,-65		;Congratulations
	.word	-10
	WL	1,city_team_name_tab
	.word	00aa6h,-74,0		;_ Win the Stanley Cup

spz_stan2
	.word	-65
	.word	00aeah,-79		;Listen to the crowd
	.word	00af7h,-117		;This is the greatest game I've ever seen
	.word	-150
	.word	00ab2h,-71		;Congratulations
	.word	-10
	WL	1,city_team_name_tab
	.word	00aa6h,-74,0		;_ Win the Stanley Cup

sz_pllist
	.long	z1p
	.long	z1p
	.long	z2p
	.long	z2p
	.long	z2p
	.long	z3p
	.long	z4p
	.long	z4p
	.long	z4p
	.long	z4p

z1p	.word	00aaah,-46,0		;Player One	1
z2p	.word	00aabh,-43,0		;Player Two	2
z3p	.word	00aach,-50,0		;Player Three	5
z4p	.word	00aadh,-47,0		;Player Four	6

spx_speech_test
	movk	1,a1
	movk	2,a2
	calla	spx_tonights_matchup
	jauc	SUCIDE

spx_ten_seconds
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	calla	get_speech_time_remaining
	cmpi	80,a0
	jrhs	stsnd9
	movi	spz_ten_seconds,a10
	callr	handle_speech_string
stsnd9	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

spx_one_minute
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	calla	get_speech_time_remaining
	cmpi	150,a0
	jrhs	stmnd9
	movi	spz_one_minute,a10
	callr	handle_speech_string
stmnd9	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

spz_one_minute
	.word	00ae2h,-54,0		;One minute left #1
spz_ten_seconds
	.word	00ae6h,-50,0		;Ten seconds

spx_tonights_matchup
	mmtm	sp,a8,a9,a10,a11
	movi	sz_stanley_cup,a10
	callr	is_this_cup
	jrc	stmd
	move	@team1,a1,W
	move	@team2,a2,W
	movi	szwtsmt,a10	;same team
	cmp	a1,a2
	jrz	stmd
	callr	is_a1a2_ny
	jrc	stny
	movi	szwtlng,a10	;longtime
	callr	is_a1a2_lt
	jrc	stmd
	movi	szwtgrt,a10	;great
	callr	is_a1a2_gt
	jrc	stmd
	movi	szwtwht,a10	;what a matchup
	callr	is_a1a2_wt
	jrc	stmd
	movi	szwtreg,a10	;nothing special
	jruc	stmd
stny	movi	szwtnyl,a10	;longtime
	callr	is_a1a2_lt
	jrc	stmd
	movi	szwtnyg,a10	;great
	callr	is_a1a2_gt
	jrc	stmd
	movi	szwtnyw,a10	;what a matchup
	callr	is_a1a2_wt
	jrc	stmd
	movi	szwtnyr,a10	;nothing special
stmd	callr	handle_speech_string
	mmfm	sp,a8,a9,a10,a11
	rets

is_this_cup
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	PLAYER_1_BLOCK,a6
	move	@team2,a1,W
	calla	CHECK_STANCUP_GAME
	jrz	itc_y
	movi	PLAYER_2_BLOCK,a6
	move	@team2,a1,W
	calla	CHECK_STANCUP_GAME
	jrz	itc_y
	movi	PLAYER_5_BLOCK,a6
	move	@team1,a1,W
	calla	CHECK_STANCUP_GAME
	jrz	itc_y
	movi	PLAYER_6_BLOCK,a6
	move	@team1,a1,W
	calla	CHECK_STANCUP_GAME
	jrz	itc_y
itc_n	clrc
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets
itc_y	setc
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

sz_stanley_cup
	.word	00b0ch,-110		;A capacity crowd on hand
	.word	00b10h,-98,0		; Get ready for the Stanley Cup

is_a1a2_ny
	cmpi	team_rangers,a1
	jrz	iny_y
	cmpi	team_islanders,a1
	jrz	iny_y
	cmpi	team_rangers,a2
	jrz	iny_y
	cmpi	team_islanders,a2
	jrz	iny_y
iny_n	clrc
	rets
iny_y	setc
	rets

is_a1a2_lt
	mmtm	sp,a1,a2,a3,a4,a5
	movi	longtime_list,a3
	callr	a1a2_match_l	;returns what we need
	mmfm	sp,a1,a2,a3,a4,a5
	rets

is_a1a2_gt
	mmtm	sp,a1,a2,a3,a4,a5
	movi	great_list,a3
	callr	a1a2_match_l	;returns what we need
	mmfm	sp,a1,a2,a3,a4,a5
	rets

is_a1a2_wt
	mmtm	sp,a1,a2,a3,a4,a5
	movi	what_list,a3
	callr	a1a2_match_l	;returns what we need
	mmfm	sp,a1,a2,a3,a4,a5
	rets

a1a2_match_l
	callr	a2ml
	jrc	a2ml9
	SWAP	a1,a2
a2ml	move	a3,a4
a2mll	move	*a4+,a5,W
	jrz	a2mln
	move	*a4+,a14,W
	cmp	a1,a5
	jrnz	a2mll
	cmp	a2,a14
	jrnz	a2mll
a2mly	setc
	rets
a2mln	clrc
a2ml9	rets

longtime_list
	.word	team_bruins,team_rangers
	.word	team_bruins,team_blackhawks
	.word	team_whalers,team_rangers
	.word	team_canadiens,team_maple_leafs
	.word	team_canadiens,team_rangers
	.word	team_penguins,team_flyers
	.word	team_islanders,team_rangers
	.word	team_blackhawks,team_red_wings
	.word	team_blackhawks,team_blues
	.word	team_red_wings,team_maple_leafs
	.word	team_sabres,team_flyers
	.word	0

great_list
	.word	team_islanders,team_devils
	.word	team_rangers,team_devils
	.word	team_canadiens,team_flames
	.word	team_flyers,team_capitals
	.word	team_lightning,team_panthers
	.word	team_islanders,team_oilers
	.word	team_mighty_ducks,team_kings
	.word	team_sharks,team_kings
	.word	team_oilers,team_flames
	.word	0

what_list
	.word	team_blackhawks,team_stars
	.word	team_devils,team_red_wings
	.word	team_red_wings,team_sharks
	.word	team_canadiens,team_kings
	.word	team_avalanche,team_rangers
	.word	team_bruins,team_flyers
	.word	team_canucks,team_rangers
	.word	team_capitals,team_penguins
	.word	team_bruins,team_devils
	.word	team_flyers,team_devils
	.word	team_maple_leafs,team_canucks
	.word	team_flames,team_sharks
	.word	team_canadiens,team_avalanche
	.word	team_jets,team_oilers
	.word	team_jets,team_flames
	.word	0

szwtreg	.word	10,1
	.long	sztnrm

szwtlng	.word	10,8
	.long	sztlng,sztlng,sztlng,sztgrt,sztgrt,sztwht,sztnrm,sztnrm

szwtgrt	.word	10,4
	.long	sztgrt,sztgrt,sztwht,sztnrm

szwtwht	.word	10,3
	.long	sztwht,sztwht,sztnrm

szwtsmt
szwtnyr	.word	10,1
	.long	sztnyn

szwtnyl	.word	10,8
	.long	sztnyl,sztnyl,sztnyl,sztnyg,sztnyg,sztnyw,sztnyn,sztnyn

szwtnyg	.word	10,4
	.long	sztnyg,sztnyg,sztnyw,sztnyn

szwtnyw	.word	10,3
	.long	sztwht,sztwht,sztnrm

sztnrm	.word	10,13
	.long	szwt05,szwt07,szwt08
	.long	szwt09,szwt10
	.long	szwt42,szwt43,szwt44,szwt45,szwt61,szwt62,szwt63,szwt64

sztlng	.word	10,12
	.long	szwt17,szwt18,szwt19,szwt20
	.long	szwt52,szwt53,szwt54,szwt55
	.long	szwt71,szwt72,szwt73,szwt74

sztgrt	.word	10,8
	.long	szwt22,szwt23,szwt24,szwt25
	.long	szwt57,szwt58,szwt59,szwt60

sztwht	.word	10,12
	.long	szwt12,szwt13,szwt14,szwt15,szwt47,szwt48
	.long	szwt49,szwt50,szwt66,szwt67,szwt68,szwt69

sztnyn	.word	10,11
	.long	szwt05,szwt08,szwt09,szwt10
	.long	szwt43,szwt44,szwt45,szwt61,szwt62,szwt63,szwt64

sztnyl	.word	10,9
	.long	szwt18,szwt19,szwt20,szwt53,szwt54
	.long	szwt55,szwt72,szwt73,szwt74

sztnyg	.word	10,6
	.long	szwt23,szwt24,szwt25,szwt58,szwt59
	.long	szwt60

sztnyw	.word	10,9
	.long	szwt13,szwt14,szwt15,szwt48,szwt49,szwt50,szwt67,szwt68
	.long	szwt69

szwt05	WLW	9,sxtmc5,0				;the city team versus the city team
szwt07	WLWLW	9,sxtma1, 9,sxtmc2,0			;welcome to tonights matchup city versus city
szwt08	WLWLW	9,sxtma1, 9,sxtmc3,0			;welcome to tonights matchup the team versus the team
szwt09	WLWLW	9,sxtma1, 9,sxtmc4,0			;welcome to tonights matchup team versus team
szwt10	WLWLW	9,sxtma1, 9,sxtmc5,0			;welcome to tonights matchup the city team versus the city team
szwt12	WLWLWLW	9,sxtma1, 9,sxtmc2, 9,sxtmd2,0		;welcome to tonights matchup city versus city and what a matchup it is
szwt13	WLWLWLW	9,sxtma1, 9,sxtmc3, 9,sxtmd2,0		;welcome to tonights matchup the team versus the team and what a matchup it is
szwt14	WLWLWLW	9,sxtma1, 9,sxtmc4, 9,sxtmd2,0		;welcome to tonights matchup team versus team and what a matchup it is
szwt15	WLWLWLW	9,sxtma1, 9,sxtmc5, 9,sxtmd2,0		;welcome to tonights matchup the city team versus the city team and what a matchup it is
szwt17	WLWLWLW	9,sxtma1, 9,sxtmb1, 9,sxtmc2,0		;welcome to tonights matchup two longtime rivals city versus city
szwt18	WLWLWLW	9,sxtma1, 9,sxtmb1, 9,sxtmc3,0		;welcome to tonights matchup two longtime rivals the team versus the team
szwt19	WLWLWLW	9,sxtma1, 9,sxtmb1, 9,sxtmc4,0		;welcome to tonights matchup two longtime rivals team versus team
szwt20	WLWLWLW	9,sxtma1, 9,sxtmb1, 9,sxtmc5,0		;welcome to tonights matchup two longtime rivals the city team versus the city team
szwt22	WLWLWLW	9,sxtma1, 9,sxtmb4, 9,sxtmc2,0		;welcome to tonights matchup It's a great rivalry between these two teams city versus city
szwt23	WLWLWLW	9,sxtma1, 9,sxtmb4, 9,sxtmc3,0		;welcome to tonights matchup It's a great rivalry between these two teams the team versus the te
szwt24	WLWLWLW	9,sxtma1, 9,sxtmb4, 9,sxtmc4,0		;welcome to tonights matchup It's a great rivalry between these two teams team versus team
szwt25	WLWLWLW	9,sxtma1, 9,sxtmb4, 9,sxtmc5,0		;welcome to tonights matchup It's a great rivalry between these two teams the city team versus t

szwt42	WLWLW	9,sxtma3, 9,sxtmc2,0			;tonights matchup city versus city
szwt43	WLWLW	9,sxtma3, 9,sxtmc3,0			;tonights matchup the team versus the team
szwt44	WLWLW	9,sxtma3, 9,sxtmc4,0			;tonights matchup team versus team
szwt45	WLWLW	9,sxtma3, 9,sxtmc5,0			;tonights matchup the city team versus the city team
szwt47	WLWLWLW	9,sxtma3, 9,sxtmc2, 9,sxtmd2,0		;tonights matchup city versus city and what a matchup it is
szwt48	WLWLWLW	9,sxtma3, 9,sxtmc3, 9,sxtmd2,0		;tonights matchup the team versus the team and what a matchup it is
szwt49	WLWLWLW	9,sxtma3, 9,sxtmc4, 9,sxtmd2,0		;tonights matchup team versus team and what a matchup it is
szwt50	WLWLWLW	9,sxtma3, 9,sxtmc5, 9,sxtmd2,0		;tonights matchup the city team versus the city team and what a matchup it is
szwt52	WLWLWLW	9,sxtma3, 9,sxtmb1, 9,sxtmc2,0		;tonights matchup two longtime rivals city versus city
szwt53	WLWLWLW	9,sxtma3, 9,sxtmb1, 9,sxtmc3,0		;tonights matchup two longtime rivals the team versus the team
szwt54	WLWLWLW	9,sxtma3, 9,sxtmb1, 9,sxtmc4,0		;tonights matchup two longtime rivals team versus team
szwt55	WLWLWLW	9,sxtma3, 9,sxtmb1, 9,sxtmc5,0		;tonights matchup two longtime rivals the city team versus the city team
szwt57	WLWLWLW	9,sxtma3, 9,sxtmb4, 9,sxtmc2,0		;tonights matchup It's a great rivalry between these two teams city versus city
szwt58	WLWLWLW	9,sxtma3, 9,sxtmb4, 9,sxtmc3,0		;tonights matchup It's a great rivalry between these two teams the team versus the team
szwt59	WLWLWLW	9,sxtma3, 9,sxtmb4, 9,sxtmc4,0		;tonights matchup It's a great rivalry between these two teams team versus team
szwt60	WLWLWLW	9,sxtma3, 9,sxtmb4, 9,sxtmc5,0		;tonights matchup It's a great rivalry between these two teams the city team versus the city tea
szwt61	WLWLW	9,sxtma4, 9,sxtmb2,0			;Midway presents NHL Open Ice
szwt62	WLWLW	9,sxtma4, 9,sxtmb3,0			;Midway presents National Hockey League Open Ice
szwt63	WLWLW	9,sxtma5, 9,sxtmb2,0			;Welcome to NHL Open Ice
szwt64	WLWLW	9,sxtma5, 9,sxtmb3,0			;Welcome to National Hockey League Open Ice
szwt66	WLWLW	9,sxtma6, 9,sxtmc2,0			;What a matchup city versus city
szwt67	WLWLW	9,sxtma6, 9,sxtmc3,0			;What a matchup the team versus the team
szwt68	WLWLW	9,sxtma6, 9,sxtmc4,0			;What a matchup team versus team
szwt69	WLWLW	9,sxtma6, 9,sxtmc5,0			;What a matchup the city team versus the city team
szwt71	WLWLWLW	9,sxtma6, 9,sxtmb1, 9,sxtmc2,0		;What a matchup two longtime rivals city versus city
szwt72	WLWLWLW	9,sxtma6, 9,sxtmb1, 9,sxtmc3,0		;What a matchup two longtime rivals the team versus the team
szwt73	WLWLWLW	9,sxtma6, 9,sxtmb1, 9,sxtmc4,0		;What a matchup two longtime rivals team versus team
szwt74	WLWLWLW	9,sxtma6, 9,sxtmb1, 9,sxtmc5,0		;What a matchup two longtime rivals the city team versus the city team

sxtma1	.word	00a9eh,-90,0		;welcome to tonights matchup

sxtma2	.word	00b08h,-94,0		;welcome to tonights game

sxtma3	.word	00a9dh,-49,0		;tonights matchup

sxtma4	.word	00b07h,-69,0		;Midway presents

sxtma5	.word	00b04h,-51,0		;Welcome to

sxtma6	.word	10,2			;What a matchup
	.long	sxtma61,sxtma62
sxtma61	.word	00aa0h,-58,0
sxtma62	.word	007f8h,-61,0

sxtmb1	.word	009bfh,-106,0		;two longtime rivals

sxtmb2	.word	00b06h,-95,0		;NHL Open Ice

sxtmb3	.word	00b05h,-117,0		;National Hockey League Open Ice

sxtmd1					;It's a great rivalry between these two teams
sxtmb4	.word	00ab3h,-85,0

sxtmc2	WL	1,city_name_tab		;city versus city
	WL	9,sxvers
	WLW	2,city_name_tab,0

sxtmc3	WL	1,the_team_name_tab	;the team versus the team
	WL	9,sxvers
	WLW	2,the_team_name_tab,0

sxtmc4	WL	1,team_name_tab		;team versus team
	WL	9,sxvers
	WLW	2,team_name_tab,0

sxtmc5	WL	1,city_team_name_tab	;the city team versus the city team
	WL	9,sxvers
	WLW	2,city_team_name_tab,0

sxtmd2	.word	00a9fh,-100,0		;and what a matchup it is

sxvers	.word	00a9ah,-26,0

spx_pass_1
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	clr	a7
	move	a7,@center_spoken,W
	GBLOCK	a0,a10
	move	*a6(POF_OBJECT),a8,L		;sender object
	move	@PUCK_OBJECT,a9,L
	movb	*a6(POF_NUMBER),a11
	movk	1,a7			;start with long allowed
	calla	get_speech_time_remaining
	cmpi	2,a0
	jrls	aspp_e		;empty
	cmpi	8,a0
	jrhs	aspnfb
aspp_s	clr	a7		;bit 0 = 0, short durations only
aspp_e	move	*a8(OXPOS),a14,W
	move	*a9(ODT_XDEST+010h),a0,W
	dec	a11
	sra	2,a11
	jrz	asp1
	neg	a14
	neg	a0
asp1	move	*a9(ODT_ZDEST+010h),a14,W
	cmpi	200,a14
	jrlt	aspnfb		;not centering
	cmpi	480,a14
	jrgt	aspnfb
	cmpi	250,a0		;near blueline
	jrlt	aspnfb
	cmpi	680,a0		;near goalline
	jrgt	aspnfb
	sll	5,a7
	addi	sp_pass1_top_level_table,a7
	move	*a7,a10,L
	callr	handle_speech_string
	movk	1,a7
	move	a7,@center_spoken,W
aspnfb	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

sp_pass1_top_level_table	;L
	.long	sp_pass1_2	;0
	.long	sp_pass1_3	;1

sp_pass1_2
	.word	10,4
	.long	spc11
	.long	spc12
	.long	spc14
	.long	spc15
spc11	.word	0095dh,-51,0	;He looks to center
spc12	.word	00957h,-56,0	;He puts it in front
spc14	.word	00869h,-54,0	;_ Centered one
spc15	.word	0095eh,-67,0	;He-s looking to center
sp_pass1_3
	.word	10,5
	.long	spc11
	.long	spc12
	.long	spc14
	.long	spc15
	.long	spc16
spc16	.word	00868h,-37,0	;He centered it ! 2


spx_pass_2
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11

	;abort here if we don't have name to call

	callr	name_check_a0
	jrz	spp_f
	move	@center_spoken,a7,W
	jrnz	spp_f
	GBLOCK	a0,a10

	move	*a6(POF_OBJECT),a8,L		;sender object
	move	@PUCK_OBJECT,a9,L
	move	*a6(POF_CHARACTER),a1,W		;sender character
	movb	*a6(POF_NUMBER),a11
	move	*a10(POF_CHARACTER),a2,W	;receiver
	move	@last_name_spoken,a14,W
	cmp	a2,a14
	jrnz	sp_nss
	move	@last_name_time,a14,L
	move	@WAVEIRQS,a3,L
	sub	a14,a3
	cmpi	400,a3
	jrls	spp_f		;no name repeat 6 seconds (use unsigned compare to catch negs from previous game)
sp_nss	move	*a6(POF_TEAM),a3,W		;team
	clr	a5				;male sender
	clr	a6				;male receiver
	movk	1,a7			;start with long allowed

;	calla	get_speech_time_remaining
;	cmpi	2,a0
;	jrls	spp_e		;empty
;	cmpi	8,a0
;	jrhs	spp_f
	calla	get_speech_time_remaining
	move	a0,a0
	jrnz	spp_f
	move	@estimated_speech_end,a0,L
	move	@WAVEIRQS,a14,L
	sub	a0,a14
	cmpi	120,a14
	jrls	spp_f

spp_s	clr	a7		;bit 0 = 0, short durations only
spp_e	move	*a9(ODT_ZSTRT+010h),a14,W
	move	*a8(OZPOS),a0,W
	sub	a14,a0
	abs	a0
	cmpi	300,a0
	jrlt	spp_nac
	ori	010b,a7		;bit 1 = 1, across ice z
	cmpi	600,a0
	jrlt	spp_nac
	ori	0100b,a7	;bit 2 = 1, rink wide
spp_nac	move	*a9(ODT_XSTRT+010h),a14,W
	move	*a8(OXPOS),a0,W
	dec	a11
	sra	2,a11
	jrz	sp1
	neg	a14
	neg	a0
sp1	sub	a0,a14
	cmpi	-100,a14
	jrgt	spnf
	ori	01000b,a7	;bit 3 = 1, forward
	jruc	spnfb
spnf	cmpi	100,a14
	jrlt	spnfb
	ori	010000b,a7	;bit 4 = 1, backward
spnfb	sll	5,a7
	addi	sp_pass2_top_level_table,a7
	move	*a7,a10,L
	callr	handle_speech_string
spp_f	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

sp_pass2_top_level_table	;BFWAL
	.long	sp_pass_0	;00000
	.long	sp_pass_1	;00001
	.long	sp_pass_2	;00010
	.long	sp_pass_3	;00011
	.long	sp_pass_4	;00100
	.long	sp_pass_5	;00101
	.long	sp_pass_6	;00110
	.long	sp_pass_7	;00111
	.long	sp_pass_8	;01000
	.long	sp_pass_9	;01001
	.long	sp_pass_10	;01010
	.long	sp_pass_11	;01011
	.long	sp_pass_12	;01100
	.long	sp_pass_13	;01101
	.long	sp_pass_14	;01110
	.long	sp_pass_15	;01111
	.long	sp_pass_16	;10000
	.long	sp_pass_17	;10001
	.long	sp_pass_18	;10010
	.long	sp_pass_19	;10011
	.long	sp_pass_20	;10100
	.long	sp_pass_21	;10101
	.long	sp_pass_22	;10110
	.long	sp_pass_23	;10111

sp_pass_0				;00000 nothing unusual
	.word	10,1
	.long	sp_normal

sp_pass_1				;00001 nothing unusual - long
	.word	10,1
	.long	sp_normal_long

sp_pass_2				;00010 across rink
	.word	10,4
	.long	sp_normal
	.long	sp_across
	.long	sp_across
	.long	sp_across

sp_pass_3				;00011 across rink - long
	.word	10,4
	.long	sp_normal_long
	.long	sp_across_long
	.long	sp_across_long
	.long	sp_across_long

sp_pass_4				;00100 rink wide
sp_pass_6				;00110 across rink - rink wide
	.word	10,8
	.long	sp_normal
	.long	sp_across
	.long	sp_across
	.long	sp_across
	.long	sp_across
	.long	sp_rink_wide
	.long	sp_rink_wide
	.long	sp_rink_wide

sp_pass_5				;00101 rink wide - long
sp_pass_7				;00111 across rink - rink wide - long
	.word	10,8
	.long	sp_normal_long
	.long	sp_across_long
	.long	sp_across_long
	.long	sp_across_long
	.long	sp_across_long
	.long	sp_rink_wide_long
	.long	sp_rink_wide_long
	.long	sp_rink_wide_long

sp_pass_8				;01000 forward
	.word	10,4
	.long	sp_normal
	.long	sp_ahead
	.long	sp_ahead
	.long	sp_ahead

sp_pass_9				;01001 forward - long
	.word	10,4
	.long	sp_normal_long
	.long	sp_ahead_long
	.long	sp_ahead_long
	.long	sp_ahead_long

sp_pass_10				;01010 forward - across rink
	.word	10,8
	.long	sp_normal
	.long	sp_ahead
	.long	sp_ahead
	.long	sp_ahead
	.long	sp_across
	.long	sp_across
	.long	sp_across
	.long	sp_across

sp_pass_11				;01011 forward - across rink - long
	.word	10,8
	.long	sp_normal_long
	.long	sp_ahead_long
	.long	sp_ahead_long
	.long	sp_ahead_long
	.long	sp_across_long
	.long	sp_across_long
	.long	sp_across_long
	.long	sp_across_long

sp_pass_12				;01100 forward - rink wide
sp_pass_14				;01110 forward - across rink - rink wide
	.word	10,12
	.long	sp_normal
	.long	sp_ahead
	.long	sp_ahead
	.long	sp_ahead
	.long	sp_across
	.long	sp_across
	.long	sp_across
	.long	sp_across
	.long	sp_rink_wide
	.long	sp_rink_wide
	.long	sp_rink_wide
	.long	sp_rink_wide

sp_pass_13				;01101 forward - rink wide - long
sp_pass_15				;01111 forward - across rink - rink wide - long
	.word	10,12
	.long	sp_normal_long
	.long	sp_ahead_long
	.long	sp_ahead_long
	.long	sp_ahead_long
	.long	sp_across_long
	.long	sp_across_long
	.long	sp_across_long
	.long	sp_across_long
	.long	sp_rink_wide_long
	.long	sp_rink_wide_long
	.long	sp_rink_wide_long
	.long	sp_rink_wide_long

sp_pass_16				;10000 backward
	.word	10,4
	.long	sp_normal
	.long	sp_backward
	.long	sp_backward
	.long	sp_backward
sp_pass_17				;10001 backward- long
	.word	10,4
	.long	sp_normal_long
	.long	sp_backward_long
	.long	sp_backward_long
	.long	sp_backward_long

sp_pass_18				;10010 backward- across rink
	.word	10,7
	.long	sp_normal
	.long	sp_backward
	.long	sp_backward
	.long	sp_backward
	.long	sp_across
	.long	sp_across
	.long	sp_across

sp_pass_19				;10011 backward- across rink - long
	.word	10,7
	.long	sp_normal_long
	.long	sp_backward_long
	.long	sp_backward_long
	.long	sp_backward_long
	.long	sp_across_long
	.long	sp_across_long
	.long	sp_across_long

sp_pass_20				;10100 backward- rink wide
sp_pass_22				;10110 backward- across rink - rink wide
	.word	10,10
	.long	sp_normal
	.long	sp_backward
	.long	sp_backward
	.long	sp_backward
	.long	sp_across
	.long	sp_across
	.long	sp_across
	.long	sp_rink_wide
	.long	sp_rink_wide
	.long	sp_rink_wide

sp_pass_21				;10101 backward- rink wide - long
sp_pass_23				;10111 backward- across rink - rink wide - long
	.word	10,10
	.long	sp_normal
	.long	sp_backward_long
	.long	sp_backward_long
	.long	sp_backward_long
	.long	sp_across_long
	.long	sp_across_long
	.long	sp_across_long
	.long	sp_rink_wide_long
	.long	sp_rink_wide_long
	.long	sp_rink_wide_long

sp_normal
	.word	10,3
	.long	spp01
	.long	spp01
	.long	spp02
spp01	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0
spp02	.word	0091fh,-20	;Passed tuh _
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0

sp_normal_long
	.word	10,7
	.long	spp01
	.long	spp02
	.long	spp11
	.long	spp12
	.long	spp13
	.long	spp14
	.long	spp15
spp11	.word	0920h,-14	;Passed to _
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0
spp12	.word	11		;embed a1 as name
	WL	1,nm_tab
	.word	094bh,-50,0	;_ Takes the pass
spp13	.word	091eh,-45	;And the puck: passed to _
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0
spp14	.word	092dh,-24	;_ Feeding _ 1
	.word	11		;embed a1 as name
	WLW	1,nm_tab,0
spp15	.word	092eh,-26	;_ Feeding _ 2
	.word	11		;embed a1 as name
	WLW	1,nm_tab,0

sp_across
	.word	10,2
	.long	spp21
	.long	spp22
spp21	.word	0911h,-17	;Over to _
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0
spp22	.word	0959h,-17	;Over to _
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0

sp_across_long
	.word	10,4
	.long	spp21
	.long	spp22
	.long	spp31
	.long	spp32
spp31	.word	0911h,-17	;Over to _ 2
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0
spp32	.word	095ah,-19	;Across to _
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0

sp_rink_wide
sp_rink_wide_long
	.word	0943h,-66,0	;Rink-wide pass

sp_ahead
	.word	0958h,-10	;Up to _
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0


sp_ahead_long
	.word	10,2
	.long	spp91
	.long	spp92
spp91	.word	0912h,-18	;Into _
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0
spp92	.word	94ch,-27	;Up ahead to _
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0

sp_backward
	.word	10,1
	.long	spp161
spp161	.word	091ah,-8	;Back to _ 2
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0

sp_backward_long
	.word	10,4
	.long	spp161
	.long	spp171
	.long	spp172
	.long	spp173
spp171	.word	07f9h,-14	;Back to _ 1
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0
spp172	.word	091ah,-14	;Back to _ 1
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0
spp173	.word	091ch,-39	;He dropped it back to _
	.word	11		;embed a1 as name
	WLW	1,nmt_tab,0

**************************************************************************
*								         *
* spx_shot1 - on wind up					         *
* spx_shot2 - on letting shot go					 *
* 	input	a6 = player block doing shoot				 *
* 		a2 = type of shot					 *
* 		 0 - wrist shot						 *
* 		 1 - slap shot						 *
* 		 2 - backhand						 *
* 		 3 - turbo backhand					 *
* 		 4 - spin around					 *
* 		 5 - trick shot						 *
*								         *
**************************************************************************
spx_shot1
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	move	a2,@shot_type,W
	movk	2,a0
	calla	RANDU
	move	a0,@shot_call,W
	cmpi	1,a0
	jrnz	spsh9
	move	*a6(POF_OBJECT),a8,L		;sender object
	move	*a6(POF_CHARACTER),a1,W		;sender character
	movb	*a6(POF_NUMBER),a11
	move	@last_shot_time,a14,L
	move	@WAVEIRQS,a3,L
	sub	a14,a3
	cmpi	90,a3
	jrls	spsh9		;1.5 seconds no repeat shot call (use unsigned to catch negatives from previous game)
	move	*a6(POF_TEAM),a3,W		;team
	calla	get_speech_time_remaining
	cmpi	2,a0
	jrhi	spsh9
spsh_e	clr	a0
	move	a0,@shot_call,W		;we will make call, clear out pend
	move	*a8(OXPOS),a0,W
	move	*a8(OXVEL),a14,L
	dec	a11
	srl	2,a11
	jrz	sxs_1
	neg	a0
	neg	a14
sxs_1	move	a14,a11
	move	*a8(OZPOS),a3,W
	callr	get_location_number
	sll	5,a4
	addi	ssh1l,a4
	move	*a4,a4,L
	call	a4
	move	@WAVEIRQS,@last_shot_time,L
	movb	*a6(POF_NUMBER),a0
	move	a0,@last_shot_player
spsh9	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

ssh1l	.long	ssh1_reg
	.long	ssh1_crease
	.long	ssh1_far
	.long	ssh1_rebound
	.long	ssh1_breakaway
	.long	ssh1_deke
	.long	ssh1_point
	.long	ssh1_ring
	.long	ssh1_slot
	.long	ssh1_center
	.long	ssh1_blue

ssh1_reg
	subi	688,a0
	neg	a0
	cmpi	200,a0
	jrlt	sx_vf		;very fast
	cmpi	350,a0
	jrlt	sx_fs		;fast
	cmpi	500,a0
	jrlt	sx_n		;near
	cmpi	700,a0
	jrgt	sx_f		;far
sx_m	movi	spx1_medium,a10
	jruc	spxsg
sx_vf	movi	spx1_very_fast,a10
	jruc	spxsg
sx_fs	movi	spx1_fast,a10
	jruc	spxsg
sx_n	movi	spx1_near,a10
	jruc	spxsg
sx_f	movi	spx1_far,a10
spxsg	jruc	handle_speech_string_sc

spx1_very_fast
	.word	10,1
	.long	sx1_1_1
spx1_fast
	.word	10,3
	.long	sx1_1_1,sx1_2_1,sx1_2_2
spx1_near
	.word	10,5
	.long	sx1_1_1,sx1_2_1,sx1_2_2,sx1_3_1,sx1_3_2
spx1_medium
	.word	10,4
	.long	sx1_3_1,sx1_3_2,sxtype,sxtype
spx1_far
	.word	10,4
	.long	sx1_3_1,sx1_3_2,sxtype,sxtype,sx1_5_1

sx1_1_1	.word	007dbh,-21,0		; _ Shooting 
sx1_2_1	.word	008a4h,-27,0		; _ Shooting
sx1_2_2	.word	008b2h,-30,0		; _ Shooting
sx1_3_1	.word	008d4h,-41,0		; _ Winds up
sx1_3_2	.word	008c7h,-43,0		; Heres the shot

sxtype	WL	2,sxttab
	.word	0
sxttab	.long	sxtwr
	.long	sxtsl
	.long	sxtbk
	.long	sxtbk
	.long	sxtsl
	.long	sxtsp
	.long	sxtsp		;safety
	.long	sxtsp		;extra
	.long	sxtsp		;after
	.long	sxtsp		;end of
	.long	sxtsp		;table

sxtwr	.word	10,2
	.long	sx1_401,sx1_402
sx1_401	.word	008bbh,-49,0		; _ With a wristshot
sx1_402	.word	008bdh,-58,0		; A wristshot

sxtsl	.word	10,3
	.long	sx1_411,sx1_412,sx1_413
sx1_411	.word	008b9h,-63,0		; Slapshot
sx1_412	.word	008b8h,-69,0		; _ with the slapshot
sx1_413	.word	008bah,-69,0		; _ The slapshot

sxtbk	.word	10,2
	.long	sx1_421,sx1_422
sx1_421	.word	008f8h,-58,0		; The backhander
sx1_422	.word	008dah,-68,0		; Heres a backhander

sxtsp	.word	10,1
	.long	sx1_431
sx1_431	.word	00901h,-67,0		; Supershot

sx1_5_1	.word	008f0h,-58,0		;Here-s a long shot


ssh1_crease
	move	@last_shot_time,a1,L
	move	@WAVEIRQS,a14,L
	sub	a1,a14
	cmpi	200,a14
	jrls	ssh1_reg	;minimum time between shot call and crease call 3+ seconds
	movi	spcrs,a10
	jruc	handle_speech_string_sc
spcrs	.word	10,5
	.long	spcrs1,spcrs2,spcrs3,spcrs4,spcrs5
spcrs1	.word	007d9h,-43,0		; _ To the net: shooting
spcrs2	.word	00806h,-54,0		; _ Going to the net 2
spcrs3	.word	00847h,-61,0		; _ Into the crease
spcrs4	.word	00807h,-61,0		; He cuts to the net 2
spcrs5	.word	00807h,-61,0		; He cuts to the net

ssh1_far
	move	@minutes,a14,L		;minutes and tenseconds
	jrz	ssh1_reg		;do normal call if no time left (not so bad)
	movi	spfar,a10
	jruc	handle_speech_string_sc
spfar	.word	10,6
	.long	spfar1,spfar2,spfar3,spfar4,spfar5,spfar6
spfar1	.word	00904h,-53,0		; Ugly shot
spfar2	.word	008f0h,-68,0		; Here-s a long shot
spfar3	.word	008ffh,-74,0		; An impossible shot
spfar4	.word	00903h,-76,0		; Terrible shot
spfar5	.word	00906h,-65,0		; What was he thinking ?
spfar6	.word	00908h,-61,0		; Oh man (disgusted)

ssh1_rebound
;	movi	800,a0
;	calla	RANDPER
;	jrnc	ssh1_reg
	move	@last_shot_player,a14,W
	movb	*a6(POF_NUMBER),a0
	cmp	a0,a14
	jrnz	ssh1_reg
	movi	spreb,a10
	jruc	handle_speech_string_sc
spreb	.word	008edh,-72,0		; _ Again with the shot 2

ssh1_breakaway
	movi	900,a0		;most of our percentaging was done already
	calla	RANDPER
	jrnc	ssh1_reg
	movi	sp_brk,a10
	jruc	handle_speech_string_sc
sp_brk	.word	10,6
	.long	spbrk1,spbrk2,spbrk3,spbrk4,spbrk5,spbrk6
spbrk1	.word	0087fh,-48,0		; _ On the attack
spbrk2	.word	00828h,-52,0		; _ Out in front
spbrk3	.word	0082ch,-61,0		; Breakaway !
spbrk4	.word	00849h,-62,0		; _ All alone 1
spbrk5	.word	00848h,-71,0		; He-s all alone
spbrk6	.word	0082dh,-85,0		; He-s got a breakaway 2

ssh1_deke
	movi	spdek,a10		;random is done in get_location_number
	jruc	handle_speech_string_sc
spdek	.word	10,2
	.long	spdek1,spdek2
spdek1	.word	0086fh,-51,0		; He dekes !
spdek2	.word	00870h,-50,0		; _ Stickhandling !

ssh1_point
	movi	500,a0
	calla	RANDPER
	jrnc	ssh1_reg
	movi	sppnt,a10
	jruc	handle_speech_string_sc
sppnt	.word	0081dh,-46,0		; _ At the point

ssh1_ring
	movi	500,a0
	calla	RANDPER
	jrnc	ssh1_reg
	movi	sprng,a10
	jruc	handle_speech_string_sc
sprng	.word	0089dh,-69,0		; _ From the top of the ring 

ssh1_slot
	movi	500,a0
	calla	RANDPER
	jrnc	ssh1_reg
	movi	spslt,a10
	jruc	handle_speech_string_sc
spslt	.word	10,1
	.long	spslt1
spslt1	.word	0089ah,-67,0		; _ Shooting from the slot

ssh1_center
	movi	300,a0
	calla	RANDPER
	jrnc	ssh1_reg
	clr	a0
	move	a0,@line_crossed,W
	movi	spcnt,a10
	jruc	handle_speech_string_sc
spcnt	.word	00816h,-60,0		; He-s at center ice

ssh1_blue
	cmpi	230,a0
	jrlt	ssh1_reg		;we crossed blue, but wrong way
	movi	300,a0
	calla	RANDPER
	jrnc	ssh1_reg
	clr	a0
	move	a0,@line_crossed,W
	movi	spbll,a10
	jruc	handle_speech_string_sc
spbll	.word	10,4
	.long	spbll1,spbll2,spbll3,spbll4
spbll1	.word	00819h,-57,0		; _ At the blue line
spbll2	.word	0086ch,-63,0		; Over the blue line
spbll3	.word	00817h,-67,0		; He-s at the blue line
spbll4	.word	00861h,-86,0		; _ Across the line

spx_shot2
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	move	@shot_call,a2,W
	jrz	spx29
	move	@shot_type,a2,W
	move	*a6(POF_OBJECT),a8,L		;sender object
	move	*a6(POF_CHARACTER),a1,W		;sender character
	movb	*a6(POF_NUMBER),a11
	move	@last_shot_time,a14,L
	move	@WAVEIRQS,a3,L
	sub	a14,a3
	cmpi	90,a3
	jrls	spx29		;don't repeat the last shot called for at least 1.5 seconds
	move	*a6(POF_TEAM),a3,W		;team
	calla	get_speech_time_remaining
	cmpi	4,a0
	jrhi	spx29
spsh2_e	clr	a0
	move	a0,@shot_call,W		;we will make call, clear out pend
	move	*a8(OXPOS),a0,W
	move	*a8(OXVEL),a14,L
	dec	a11
	srl	2,a11
	jrz	sxs_2
	neg	a0
	neg	a14
sxs_2	move	a14,a11
	move	*a8(OZPOS),a3,W
	callr	get_location_number
	sll	5,a4
	addi	ssh2l,a4
	move	*a4,a4,L
	call	a4
	move	@WAVEIRQS,@last_shot_time,L
	movb	*a6(POF_NUMBER),a0
spx29	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

ssh2l	.long	ssh2_reg
	.long	ssh2_crease
	.long	ssh2_far
	.long	ssh2_rebound
	.long	ssh2_breakaway
	.long	ssh2_deke
	.long	ssh2_point
	.long	ssh2_ring
	.long	ssh2_slot
	.long	ssh2_center
	.long	ssh2_blue

ssh2_reg
	subi	688,a0
	neg	a0
	cmpi	250,a0
	jrlt	sx2_vf		;very fast
	cmpi	400,a0
	jrlt	sx2_fs		;fast
	cmpi	550,a0
	jrlt	sx2_n		;near
	cmpi	750,a0
	jrgt	sx2_f		;far
sx2_m	movi	spx2_medium,a10
	jruc	spx2g
sx2_vf	movi	spx2_very_fast,a10
	jruc	spx2g
sx2_fs	movi	spx2_fast,a10
	jruc	spx2g
sx2_n	movi	spx2_near,a10
	jruc	spx2g
sx2_f	movi	spx2_far,a10
spx2g	jruc	handle_speech_string_sc

spx2_very_fast
	.word	10,3
	.long	sx1_1_1,sx2_1_2,sx2_1_3
sx2_1_2	.word	00fa1h,-19,0		; He shoots (A)
sx2_1_3	.word	00fa7h,-20,0		; He shoots (D)

spx2_fast
	.word	10,7
	.long	sx1_1_1,sx2_1_2,sx2_1_3,sx1_2_1,sx1_2_2,sx2_2_1,sx2_2_2
sx2_2_1	.word	0089ch,-30,0		; He shoots
sx2_2_2	.word	0089ch,-30,0		; He shoots

spx2_near
	.word	10,15
	.long	sx1_1_1,sx1_2_1,sx1_2_2,sx2_1_2,sx2_1_3,sx2_2_1,sx2_2_2
	.long	sx2_3_1,sx2_3_2,sx2_3_3,sx2_3m,sx2_3m,sx2_3m,sx2_3m,sx2_3m

sx2_3_1	.word	0089eh,-39,0		; _ Shoots one
sx2_3_2	.word	008c7h,-43,0		; Heres the shot
sx2_3_3	.word	0084fh,-45,0		; Great Shot _

sx2_3m	WL	2,sx23l
	.word	0
sx23l	.long	sx2_3_3
	.long	sx23o
	.long	sx2_3_3
	.long	sx23o
	.long	sx23o
	.long	sx23o
	.long	sx23o	;extra
	.long	sx23o
	.long	sx23o
	.long	sx23o
	.long	sx23o

sx23o	.word	10,2
	.long	sx2_3m1,sx2_3m2
sx2_3m1	.word	008cdh,-37,0		; A rocket
sx2_3m2	.word	008d2h,-39,0		; A blast

spx2_medium
	.word	10,6
	.long	sx2_3_1,sx2_3_2,sx2_3_3,satype,satype,satype

satype	WL	2,salist
	.word	0
salist	.long	sa2mw
	.long	sa2ms
	.long	sa2mb
	.long	sa2mb
	.long	sa2mr
	.long	sa2mx
	.long	sa2mx
	.long	sa2mx
	.long	sa2mx
	.long	sa2mx
	.long	sa2mx

sa2mw	.word	10,2
	.long	sx2mg,sx2mw
sa2ms	.word	10,3
	.long	sx2mg,sx2msr,s2msrx
sa2mb	.word	10,2
	.long	sx2mg,sx2mb
sa2mr	.word	10,3
	.long	sx2mg,sx2msr,s2msrx
sa2mx	.word	10,8
	.long	sx2mg,sx2msr,s2msrx,sx2mx1,sx2mx1,sx2mx1,sx2mx1,sx2mx1

sx2mg	.word	10,2
	.long	sx2mg1,sx2mg2
sx2mg1	.word	008e7h,-64		; Good shot by _
	WWLW	11,1,nm_tab,0
sx2mg2	.word	0090ch,-65,0		; He pulled the trigger

sx2mw	.word	10,3
	.long	sx2mw1,sx2mw2,sx2mw3
sx2mw1	.word	008bbh,-49,0		; _ With a wristshot
sx2mw2	.word	008bdh,-58,0		; A wristshot
sx2mw3	.word	008bch,-78,0		; _ Lets go a wristshot

sx2mb	.word	10,2
	.long	sx2mb1,sx2mb2
sx2mb1	.word	008f8h,-58,0		; The backhander
sx2mb2	.word	008dah,-68,0		; Heres a backhander

sx2msr	.word	10,5
	.long	sx2msr1,sx2msr2,sx2msr3,sx2msr4,sx2msr5
sx2msr1	.word	008ceh,-51,0		; _ With a rocket
sx2msr2	.word	008b6h,-56,0		; What a shot
sx2msr3	.word	008b9h,-63,0		; Slapshot
sx2msr4	.word	008b8h,-69,0		; _ with the slapshot
sx2msr5	.word	008bah,-69,0		; _ The slapshot

s2msrx	.word	10,7
	.long	s2msrx2,s2msrx3,s2msrx4,s2msrx5,s2msrx6,s2msrx7,s2msrx8
s2msrx2	.word	008afh,-55,0		; What a shot
s2msrx3	.word	008a3h,-57,0		; He fired it
s2msrx4	.word	0090eh,-58,0		; _ Fires 
s2msrx5	.word	0090ah,-65,0		; He-s firing bullets
s2msrx6	.word	008f1h,-79,0		; Wow what a shot
s2msrx7	.word	008f7h,-86,0		; Oh what a powerful shot
s2msrx8	.word	008dbh,-102,0		; He got great wood on that one

sx2mx1	.word	00901h,-67,0		; Supershot

spx2_far
	.word	10,2
	.long	sx2f1,sx2f2
sx2f1	.word	00908h,-61,0		; Oh man (disgusted)
sx2f2	.word	00906h,-65,0		; What was he thinking ?

ssh2_crease
	move	@last_shot_time,a1,L
	move	@WAVEIRQS,a14,L
	sub	a1,a14
	cmpi	200,a14
	jrls	ssh2_reg	;minimum time between shot call and crease call 3+ seconds
	movi	sp2crs,a10
	jruc	handle_speech_string_sc
sp2crs	.word	10,5
	.long	sp2crs1,sp2crs2,sp2crs3,sp2crs4,sp2crs5
sp2crs1	.word	007d9h,-43,0		; _ To the net: shooting
sp2crs2	.word	00806h,-54,0		; _ Going to the net 2
sp2crs3	.word	00847h,-61,0		; _ Into the crease
sp2crs4	.word	00807h,-61,0		; He cuts to the net 2
sp2crs5	.word	00807h,-61,0		; He cuts to the net 2

ssh2_far
	move	@minutes,a14,L		;minutes and tenseconds
	jrz	ssh2_reg		;do normal call if no time left (not so bad)
	movi	sp2far,a10
	jruc	handle_speech_string_sc
sp2far	.word	10,6
	.long	sp2far1,sp2far2,sp2far3,sp2far4,sp2far5,sp2far6
sp2far1	.word	00904h,-53,0		; Ugly shot
sp2far2	.word	008f0h,-68,0		; Here-s a long shot
sp2far3	.word	008ffh,-74,0		; An impossible shot
sp2far4	.word	00903h,-76,0		; Terrible shot
sp2far5	.word	00906h,-65,0		; What was he thinking ?
sp2far6	.word	00908h,-61,0		; Oh man (disgusted)

ssh2_rebound
	movi	800,a0
	calla	RANDPER
	jrnc	ssh2_reg
	move	@last_shot_player,a14,W
	movb	*a6(POF_NUMBER),a0
	cmp	a0,a14
	jrnz	ssh2_reg
	movi	sp2reb,a10
	jruc	handle_speech_string_sc
sp2reb	.word	008edh,-72,0		; _ Again with the shot 2

ssh2_breakaway
	movi	200,a0
	calla	RANDPER
	jrnc	ssh2_reg
	movi	sp2brk,a10
	jruc	handle_speech_string_sc
sp2brk	.word	10,8
	.long	sp2brk1,sp2brk2,sp2brk3,sp2brk4,sp2brk5,sp2brk6,sp2brk7,sp2brk8
sp2brk1	.word	0080dh,-62,0		; He skates in 2
sp2brk2	.word	00877h,-67,0		; _ With a drive
sp2brk3	.word	0087fh,-48,0		; _ On the attack
sp2brk4	.word	00828h,-52,0		; _ Out in front
sp2brk5	.word	0082ch,-61,0		; Breakaway !
sp2brk6	.word	00849h,-62,0		; _ All alone 1
sp2brk7	.word	00848h,-71,0		; He-s all alone
sp2brk8	.word	0082dh,-85,0		; He-s got a breakaway 2

ssh2_deke
	movi	sp2dek,a10
	jruc	handle_speech_string_sc
sp2dek	.word	10,2
	.long	sp2dek1,sp2dek2
sp2dek1	.word	0086fh,-51,0		; He dekes !
sp2dek2	.word	00870h,-50,0		; _ Stickhandling !

ssh2_point
	movi	500,a0
	calla	RANDPER
	jrnc	ssh2_reg
	movi	sp2pnt,a10
	jruc	handle_speech_string_sc
sp2pnt	.word	0081dh,-46,0		; _ At the point

ssh2_ring
	movi	500,a0
	calla	RANDPER
	jrnc	ssh2_reg
	movi	sp2rng,a10
	jruc	handle_speech_string_sc
sp2rng	.word	0089dh,-69,0		; _ From the top of the ring 

ssh2_slot
	movi	500,a0
	calla	RANDPER
	jrnc	ssh2_reg
	movi	sp2slt,a10
	jruc	handle_speech_string_sc
sp2slt	.word	10,1
	.long	sp2slt1
sp2slt1	.word	0089ah,-67,0		; _ Shooting from the slot

ssh2_center
	movi	300,a0
	calla	RANDPER
	jrnc	ssh2_reg
	clr	a0
	move	a0,@line_crossed,W
	movi	sp2cnt,a10
	jruc	handle_speech_string_sc
sp2cnt	.word	00816h,-60,0		; He-s at center ice

ssh2_blue
	cmpi	230,a0
	jrlt	ssh2_reg		;we crossed blue, but wrong way
	movi	300,a0
	calla	RANDPER
	jrnc	ssh2_reg
	clr	a0
	move	a0,@line_crossed,W
	movi	sp2bll,a10
	jruc	handle_speech_string_sc
sp2bll	.word	10,4
	.long	sp2bll1,sp2bll2,sp2bll3,sp2bll4
sp2bll1	.word	00819h,-57,0		; _ At the blue line
sp2bll2	.word	0086ch,-63,0		; Over the blue line
sp2bll3	.word	00817h,-67,0		; He-s at the blue line
sp2bll4	.word	00861h,-86,0		; _ Across the line

**************************************************************************
*								         *
* get_location_number							 *
* 	input	a6 = block						 *
* 		a0 = xpos						 *
* 		a3 = zpos						 *
* 		a11= xvel						 *
* 	output	a4 =  0 - nothing special				 *
* 		      1 - in crease					 *
* 		      2 - too far away					 *
* 		      3 - after a rebound				 *
* 		      4 - on a breakaway				 *
* 		      5 - deking					 *
* 		      6 - at the point					 *
* 		      7 - top of the ring				 *
* 		      8 - in the slot					 *
* 		      9 - at center ice					 *
* 		     10 - at the blue line				 *
*								         *
**************************************************************************
get_location_number
	movk	1,a4
	cmpi	440,a3
	jrgt	gln2
	cmpi	236,a3
	jrlt	gln2
	cmpi	688,a0
	jrgt	gln2
	cmpi	585,a0
	jrge	glnx		;in the crease
gln2	movk	2,a4
	move	a0,a0
	jrn	glnx		;bad shot, past center line
	movk	3,a4
	move	@last_shot_player,a5
	movb	*a6(POF_NUMBER),a14
	dec	a5
	dec	a14
	srl	2,a5
	srl	2,a14
	cmp	a5,a14
	jrnz	gln3		;last person to shoot was not this team
	move	@last_shot_time,a14,L
	move	@WAVEIRQS,a5,L
	sub	a14,a5
	cmpi	150,a5
	jrgt	gln3		;it's been to long since a shot to call this a rebound
	calla	last_puck_owner_a14
	GBLOCK	a14,a14
	move	*a14(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	glnx		;last owner was goalie, call it rebound
gln3	movk	4,a4
	movb	*a6(POF_NUMBER),a14
	dec	a14
	srl	2,a14
	move	a14,a7		;save for check below
	dec	a14
	abs	a14
	sll	2,a14
	inc	a14
	GBLOCK	a14,a5
	inc	a14
	GBLOCK	a14,a14
	move	*a5(POF_OBJECT),a5,L
	move	*a5(OXPOS),a5,W
	move	*a14(POF_OBJECT),a14,L
	move	*a14(OXPOS),a14,W
	move	a7,a7
	jrz	gln4
	neg	a5
	neg	a14
gln4	addi	200,a5
	addi	200,a14
	cmp	a5,a0
	jrlt	gln5		;not breakaway
	cmp	a14,a0
	jrlt	gln5		;not breakaway
	cmpi	[4,0],a11
	jrlt	gln5
	mmtm	sp,a0
	movi	500,a0
	calla	RANDPER
	mmfm	sp,a0
	jrc	glnx		;breakaway
gln5	movk	5,a4
	mmtm	sp,a0,a1,a2,a3
	calla	do_we_deke_split
	mmfm	sp,a0,a1,a2,a3
	jrz	gln51
	movi	200,a0
	calla	RANDPER
	jrc	glnx		;we deke or split, call it deke
gln51	movk	6,a4
	cmpi	240,a0
	jrlt	gln6		;too far out
	cmpi	300,a0
	jrgt	gln6		;too close
	cmpi	600,a3
	jrgt	glnx		;top point
	cmpi	79,a3
	jrlt	glnx		;bottom point
gln6	movk	7,a4
	cmpi	350,a0
	jrlt	gln7		;too far away for faceoff circle
	cmpi	400,a0
	jrgt	gln7		;too close for top of faceoff circle
	cmpi	615,a3
	jrgt	gln7		;too high
	cmpi	415,a3
	jrgt	glnx		;top of top z faceoff circle
	cmpi	264,a3
	jrgt	gln7
	cmpi	64,a3
	jrgt	glnx		;top of botton z faceoff circle
gln7	movk	8,a4		;slot
	cmpi	250,a0
	jrlt	gln8		;too far out
	cmpi	630,a0
	jrgt	gln8		;too close
	cmpi	250,a3
	jrlt	gln8
	cmpi	429,a3
	jrlt	glnx
gln8	movk	8,a4		;really 9-10, we add 1 or 2
	move	@line_crossed,a14,W
	jrz	gln9
	add	a14,a4		;no it is 9 or 10
	move	@line_crossed_time,a14,L
	move	@WAVEIRQS,a5,L
	sub	a14,a5
	cmpi	15,a5
	jrlt	glnx		;just crossed line
gln9	clr	a4		;nothing special
glnx	move	a4,@VIDCLIP_TYPE,W
	movb	*a6(POF_NUMBER),a14
	move	a14,@VIDCLIP_PLAYER,W
	move	@WAVEIRQS,@VIDCLIP_TIME,L
	cmpi	5,a4
	jrz	glnx5		;no mod on deke
	cmpi	8,a4
	jrz	glnx5		;no mod on slot
	move	@shot_type,a14,W
	cmpi	1,a14
	jrz	glnxm1		;slap shot
	cmpi	4,a14
	jrz	glnxm3
glnx5	rets
glnxm1	clr	a14
	dec	a14
	move	a14,@VIDCLIP_TYPE,W
	rets
glnxm3	clr	a14
	subk	3,a14
	move	a14,@VIDCLIP_TYPE,W
	rets

spx_intercept_bounce
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	spibgl
	callr	name_check_a6
	jrz	spib9
	calla	get_speech_time_remaining
	cmpi	5,a0
	jrhi	spib9
	move	@PUCK_INTENDED,a0,W
	movb	*a6(POF_NUMBER),a2
	dec	a0
	dec	a2
	sra	2,a0
	sra	2,a2
	cmp	a0,a2
	jrz	spib9		;it is intended for us or a teammate, done
	move	*a6(POF_CHARACTER),a1,W
	movi	spib_t,a10
	move	@PUCK_OBJECT,a14,L
	move	*a14(OYPOS),a14,W
	cmpi	-15,a14
	jrgt	spibg		;not in air
	movi	spibat,a10
spibg	callr	handle_speech_string
spib9	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets
spibgl	clr	a1
	callr	do_goalie_phrase
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

spib_t	.word	10,4
	.long	spbt1,spbt2,spbt3,spbt4
spibat	.word	10,4
	.long	spbt1,spbt2,spbt3,spbt4
spbt1	.word	00965h,-60,0		;The puck is loose
spbt2	WWL	11,1,nm_tab
	.word	00969h,-56,0		;_ gets a handle on it
spbt3	WWL	11,1,nm_tab
	.word	0096ah,-56,0		;_ gets his stick on it
spbt4	.word	00965h,-60,0		;The puck is loose

spx_intercept_control
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	callr	name_check_a6
	jrz	spic9
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	spic9
	calla	get_speech_time_remaining
	cmpi	4,a0
	jrhs	spic9
	move	*a6(POF_CHARACTER),a1,W
	movi	spin,a10
	move	@PUCK_OBJECT,a14,L
	move	*a14(OYPOS),a14,W
	cmpi	-15,a14
	jrgt	spicgg		;not in air, no call, just name
	movi	spicst,a10
spicgg	callr	handle_speech_string
spic9	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

spin	WWLW	11,1,nm_tab,0		;just his name
spicst	.word	0097bh,-70,0		;Picked out of the air

spx_missed_shot
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	move	@PUCK_OBJECT,a14,W
	move	*a14(OXPOS),a14,W
	abs	a14
	cmpi	700,a14
	jrls	spms9		;the shot wasn't 'wide' of we are in more than 100 from edge
	calla	get_speech_time_remaining
	cmpi	10,a0
	jrhi	spms9
	movi	smsct,a10
	move	@shot_call,a0,W
	jrz	smsgo		;do sound call for shot call made
	movi	smsnct,a10
smsgo	callr	handle_speech_string_sc
spms9	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

smsct	.word	10,2
	.long	smsct1,smsct2
smsct1	.word	0089fh,-67,0		;_ Just misses
smsct2	.word	008a2h,-56,0		;_ Just wide

smsnct	.word	10,2
	.long	smsnct1,smsnct2
smsnct1	.word	008a1h,-87,0		;_ Just fired it wide
smsnct2	.word	008a0h,-62,0		;_ Fired it wide

spx_one_timer
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	800,a0
	calla	RANDPER
	jrc	sptreg
	calla	get_speech_time_remaining
	cmpi	10,a0
	jrls	spxot8
	movk	1,a2
	move	a2,@shot_call,W
	jruc	spxot9
spxot8	clr	a2
	move	a2,@shot_call,W
	move	*a6(POF_CHARACTER),a1,W
	movi	spotr,a10
	callr	handle_speech_string_sc
spxot9	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

spotr	.word	10,3
	.long	spotr1,spotr2,spotr3
spotr1	.word	008f3h,-49,0		;_ One times it 2
spotr2	.word	008f5h,-62,0		;_ With a one-timer
spotr3	.word	00a04h,-59		;The one-timer by _
	WWLW	11,1,nm_tab,0

sptreg	movk	1,a2		;also is slap shot
	move	a2,@shot_call,W
	callr	spx_shot2
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

spx_faceoff_start
	mmtm	sp,a0,a2,a4,a10,a14
	move	@spfaceoff_address,a10,L
	jrz	spfsr9
	move	@PLAYER_2_BLOCK+POF_CHARACTER,a1,W	;left player
	move	@PLAYER_5_BLOCK+POF_CHARACTER,a2,W	;right player
	move	@team1,a3,W
	move	@team2,a5,W
	callr	handle_speech_string
	clr	a10
	move	a10,@spfaceoff_address,L
spfsr9	mmfm	sp,a0,a2,a4,a10,a14
	rets

spx_period_faceoff
	mmtm	sp,a0
	movk	2,a0
	calla	RANDU
	move	a0,@spfaceoff_call,W
	calla	get_speech_time_remaining
	cmpi	10,a0
	jrgt	spfg9
	move	@period,a0,W
	cmpi	1,a0
	jrz	spf_gs
	;here is where our new call will go
	movi	sppf,a0
	jruc	spfg8
spf_gs	movi	sppfg,a0
spfg8	move	a0,@spfaceoff_address,L
	clr	a0
	move	a0,@spfaceoff_call,W
spfg9	mmfm	sp,a0
	rets


sppf	.word	10,4
	.long	sppf1,sppf2,sppf3,spphti
spphti	.word	00b09h,-50,0		;Pat Foley: Hit the Ice
sppf1	.word	007e0h,-104,0		;And were ready for the faceoff
sppf2	.word	007e9h,-71,0		;Here-s the faceoff
sppf3	.word	007ech,-89,0		;Faceoff at center ice 1

sppfg	.word	10,4
	.long	sppf1,sppf2,sppf3,sppf4
sppf4	.word	007f7h,-99,0		;Here-s the opening faceoff
	
spx_goal_faceoff
	mmtm	sp,a0
	movk	2,a0
	calla	RANDU
	move	a0,@spfaceoff_call,W
	calla	get_speech_time_remaining
	cmpi	10,a0
	jrgt	spgf9
	movi	sppgf,a0
	move	a0,@spfaceoff_address,L
	clr	a0
	move	a0,@spfaceoff_call,W
spgf9	mmfm	sp,a0
	rets

sppgf	.word	10,7
	.long	sppgf1,sppgf1,sppgf2,sppgf2,sppgf3,sppgf4,sppgf4

sppgf1	.word	007e0h,-104,0		;And were ready for the faceoff
sppgf2	.word	007e9h,-71,0		;Here-s the faceoff
sppgf3	.word	007ech,-89,0		;Faceoff at center ice 1
sppgf4	.word	007ech,-89,0		;Faceoff at center ice 1


spx_zone_faceoff
	callr	spx_holds_on
	mmtm	sp,a0
	movk	5,a0			;so it is at drop 20% of the time
	calla	RANDU
	move	a0,@spfaceoff_call,W
	cmpi	1,a0
	jrnz	spzf9
	calla	get_speech_time_remaining
	cmpi	10,a0
	jrgt	spzf9
	movi	sppzf,a0
	move	a0,@spfaceoff_address,L
	clr	a0
	move	a0,@spfaceoff_call,W
spzf9	mmfm	sp,a0
	rets

sppzf	WL	1,nm_tab
	.word	007ebh,-25		;_ Against _
	WLW	2,nm_tab,0

spx_holds_on
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	move	@PLAYER_4_BLOCK+POF_CHARACTER,a1,W
	move	@PUCK_OBJECT,a14,L
	move	*a14(OXPOS),a14,W
	jrn	sho_ok
	move	@PLAYER_8_BLOCK+POF_CHARACTER,a1,W
sho_ok	calla	get_speech_time_remaining
	cmpi	30,a0
	jrhs	shonok
	movi	spz_hln,a10
	calla	handle_speech_string
shonok	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

spz_hln	.word	10,4
	.long	szhld1,szhld2,szhld3,szhld4
szhld1	WL	1,fnm_tab
	.word	00a34h,-60,0		;_ Freezes the puck
szhld2	.word	00a37h,-74,0		;He freezes the puck
szhld3	.word	00a68h,-75,0		;And he holds on
szhld4	.word	00b0bh,-72,0		;And the whistle blows (Pat Foley)

spx_period_over1
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	move	@period,a14,W
	cmpi	3,a14
	jrnz	spo_uu
	move	@team1_score,a0,W
	move	@team2_score,a14,W
	sub	a0,a14
	jrz	spo_over		;overtime
spo_uu	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets
spo_over
	movk	ADJPAYOT,a0
	calla	GET_ADJ
	jrnz	spo_ot
spo_sdo	movi	spz_sdt,a10
	callr	handle_speech_string
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets
spo_ot	movi	spz_ot,a10
	callr	handle_speech_string
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

spz_sdt	.word	00ae7h,-88,0		;sudden death overtime
spz_ot	.word	00ae8h,-94,0		;they send it into overtime


spx_period_over2
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	move	@period,a14,W
	cmpi	3,a14
	jrhs	spo9
	calla	get_speech_time_remaining
	cmpi	30,a0
	jrhs	spo9
	move	@SUPER_GOALIE,a14,W
	jrnz	spo_superg

	move	@team1_score,a0,W
	move	@team2_score,a1,W
	sub	a1,a0
	move	a0,a14
	abs	a14
	cmpi	3,a14
	jrls	sporg
	move	a0,a0
	jrn	spot2
spot1	movk	4,a1
	movk	8,a2		;other team
	jruc	spott
spot2	movk	8,a1
	movk	4,a2		;other team
spott	GBLOCK	a1,a6
	GBLOCK	a2,a7
	move	*a6(POF_TEAM),a2,W
	move	*a6(POF_CHARACTER),a1,W
	move	*a6(POF_SAVES),a0,W
	move	*a7(POF_SAVES),a14,W
	sub	a14,a0
	jrn	spnrg
	movi	spz_so_far_goalie,a10
	jruc	spo_go
spnrg	movi	spz_team_ahead_prd,a10
	jruc	spo_go
sporg	move	@period,a3,W
	movi	spz_po_reg,a10
spo_go	callr	handle_speech_string
spo9	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

spo_superg
	movi	spz_super_goalie,a10
	callr	handle_speech_string
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

spz_super_goalie
	.word	00a75h,-132,0		;What a goaltending show we've had here

spz_so_far_goalie
spz_team_ahead_prd
sz_tm	.word	-45
	.word	00b0dh,-76		;so far its been all
	WLW	2,random_team_city_version_tab,0

spz_po_reg
spz_ap_o
	.word	-45
	WLW	3,prt_t,0
prt_t	.long	spz_cap
	.long	spz_2p
	.long	spz_3p
	.long	spz_cap
	.long	spz_cap
	.long	spz_cap
	.long	spz_cap
	.long	spz_cap
	.long	spz_cap
	.long	spz_cap
	.long	spz_cap
	.long	spz_cap
spz_cap	.word	00b0ch,-110,0		;a capacity crowd on hand
spz_2p	.word	00b0eh,-100,0		;get ready for the 2nd period
spz_3p	.word	00b0fh,-95,0		;get ready for the 3rd period




spx_faceoff_taken
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	500,a0
	calla	RANDPER
	jrnc	spxft9
	move	@spfaceoff_call,a14,W
	jrz	spxft9
	move	@team1,a2,W
	move	@(PLAYER_2_BLOCK+POF_CHARACTER),a3,W
	cmpi	1,a0
	jrz	spft2
	move	@team2,a2,W
	move	@(PLAYER_5_BLOCK+POF_CHARACTER),a3,W
spft2	calla	get_speech_time_remaining
	cmpi	10,a0
	jrgt	spxft9
	movi	spfts,a10
	callr	handle_speech_string
spxft9	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets
spfts	.word	007f1h,-64,0		;Here-s the draw

spx_score
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	calla	get_speech_time_remaining
	cmpi	30,a0
	jrhi	sp_js		;too much time in cue, just do he scores (no he shoots)
	move	@shot_call,a14,W
	jrz	sp_js		;we already called the shot, just do he scores (no he shoots)
	clr	a14
	move	a14,@shot_call,W
	movi	sp_fs_ntab,a10
	callr	handle_speech_string
	jruc	sp_p2		;goto part 2
sp_js	movi	sp_js_ntab,a10
	callr	handle_speech_string
sp_p2	move	@scored_by,a1,W
	jrz	kexit
	GBLOCK	a1,a6
	move	*a6(POF_HOT_VALUE),a2,W
	movi	sp_smokin,a10
	cmpi	18,a2
	jrnz	spp2b		;he is not smokin'
	move	a1,a2
	dec	a2
	xori	1,a2
	inc	a2
	GBLOCK	a2,a7
	move	*a7(POF_HOT_VALUE),a2,W
	cmpi	18,a2
	jrnz	sp_dne		;he is smokin'
	movi	sp_tsmokin,a10
	jruc	sp_dne		;they're smokin'
spp2b	move	@hot_player,a2,W
	cmp	a1,a2
	jrnz	spp3b
	movi	sp_on_fire_now,a10
	move	@just_now_on_fire,a14,W
	jrnz	sp_dne		;he is now on fire
spp3b	movi	sp_hatrack,a10
	movb	*a6(POF_GOALS_P1),a0
	movb	*a6(POF_GOALS_P2),a14
	add	a14,a0
	movb	*a6(POF_GOALS_P3),a14
	add	a14,a0
	movb	*a6(POF_GOALS_PO),a14
	add	a14,a0
	move	a0,a4		;save us for later
	cmpi	9,a0
	jrz	sp_dne		;hat rack
	movi	sp_tied,a10
	move	@team1_score,a2,W
	move	@team2_score,a3,W
	cmp	a2,a3
	jrnz	spp4b
	movi	400,a0
	calla	RANDPER
	jrnc	spp4b		;60% of tied up goals don't get announced as a tie
	cmpi	20,a2
	jrhi	sp_dne		;tied up at more than 20
	movi	sp_tied_tied_score,a10
	jruc	sp_dne		;tied up at 20 or less
spp4b	movi	sp_hattrick,a10
	cmpi	3,a4
	jrz	sp_dne		;a hat trick
	movi	sp_on_fire,a10
	move	@hot_player,a2
	cmp	a1,a2
	jrz	sp_dne		;on fire goal
	move	@score_call_log,a2
	sll	5,a2
	addi	slog_caln,a2
	move	*a2,a2,L
	jump	a2		;jump to a call that will be different from the last one
slog_caln
	.long	score_all_calls
	.long	score_no_name
	.long	score_no_description
	.long	score_no_score
score_all_calls
	movk	3,a0
	movi	snn_sac,a2
	jruc	sacsac
score_no_name
	movi	snn_snn,a2
	jruc	sacsac2
score_no_description
	movi	snn_snd,a2
	jruc	sacsac2
score_no_score
	movi	snn_sns,a2
sacsac2	movk	2,a0
sacsac	calla	RAND0
	sll	5,a0
	add	a2,a0
	move	*a0,a0,L
	jump	a0
snn_sac	.long	snc_nme		;this small
	.long	snc_dsc		;table could be half sized
	.long	snc_scr		;by overlapping
snn_snn	.long	snc_dsc
	.long	snc_scr
snn_snd	.long	snc_nme
	.long	snc_scr
snn_sns	.long	snc_nme
	.long	snc_dsc

snc_nme	movk	1,a0
	move	a0,@score_call_log,W
	movi	snm_nme,a10
	jruc	sp_dne		;do name or nickname

snm_nme	WLW	1,fnnm_tab,0

snc_scr	movk	3,a0
	move	a0,@score_call_log,W
	move	@team1_score,a2,W
	move	@team2_score,a3,W
	move	a2,a4
	movi	sp_none,a10
	sub	a3,a4		;team 1 point of view
	jrz	sp_dne	;we get all the way to announce score, it is tied and we didn't announce it already, so do nothing
	cmpi	4,a1
	jrls	sscr1		;team1
	SWAP	a2,a3
	neg	a4		;a2,a3,a4 = our score data from our point of view
sscr1	movk	0111b,a5	;bits represent type of call we can make
	move	a4,a14
	abs	a14
	cmpi	5,a14
	jrhi	sscnb		;blow out, not giving up is ok
	andni	0100b,a5	; don't do blow out/giving up call
	jruc	sscdo		;we know that differential is ok
sscnb	cmpi	21,a14
	jrls	sscdo		;not too big to call difference
	andni	0001b,a5	; don't do score differential
sscdo	cmpi	21,a2
	jrhs	sscns		;too high for just scores
	cmpi	21,a3
	jrlo	sscdx		;scores are ok
sscns	andni	0010b,a5	; don't do score announcement
sscdx	sll	5,a5
	addi	sr_sctb,a5
	move	*a5,a5,L
	jump	a5

sr_sctb	.long	skr_none	;000	;we never get here
	.long	skr_scrd	;001	;score differential only
	.long	skr_scra	;010	;score announcement only
	.long	skr_scrda	;011	;score differential or announcement
	.long	skr_scrb	;100	;blow out/not giving up only
	.long	skr_scrbd	;101	;blow out or differential
	.long	skr_scrba	;110	;blow out or score announcement
	.long	skr_scrbad	;111	;call any announcement (under 21 points both teams, 6 point differential or more)

skr_none
	movi	sp_none,a10
	jruc	sp_dne

skr_scrd
	movi	sp_score_down,a10
	move	a4,a4
	jrn	sld_1		;we are down
	movi	sp_score_up,a10	;we are ahead 2 or more
	cmpi	1,a4
	jrnz	sld_1
	movi	sp_new_lead,a10	;we are ahead by 1
sld_1	jruc	sp_dne

skr_scra
	movi	sp_scores_up,a10
	move	a4,a4
	jrp	sla_1		;we are ahead
	movi	sp_scores_down,a10	;we are down
sla_1	jruc	sp_dne

skr_scrda
	movk	2,a0
	calla	RAND0
	jrz	skr_scra	;50% announce
	jruc	skr_scrd	;50% differential

skr_scrb
	movi	sp_blow_out,a10
	move	a4,a4
	jrp	slb_1			;we are blowing out
	movi	sp_not_giving,a10	;we are being blown out and we score
slb_1	jruc	sp_dne

skr_scrbd
	movk	2,a0
	calla	RAND0
	jrz	skr_scrb	;50% blowout
	jruc	skr_scrd	;50% differential

skr_scrba
	movk	2,a0
	calla	RAND0
	jrz	skr_scra	;50% announce
	jruc	skr_scrb	;50% blowout

skr_scrbad
	movk	3,a0
	calla	RAND0
	sll	5,a0
	addi	sbadl,a0
	move	*a0,a0,L
	jump	a0
sbadl	.long	skr_scra	;33% announce
	.long	skr_scrb	;33% blow out
	.long	skr_scrd	;33% differential

snc_dsc
	movi	sp_how,a10
	calla	get_very_last_player	;we trash our score, ok we don't need it anymore
	cmp	a1,a3
	jrnz	sp_dne		;we didn't shoot this in, do a how
	move	@PUCK_OBJECT,a7,L
	move	*a7(OYPOS),a14,W
	neg	a14
	cmpi	20,a14
	jrlt	swd_nt		;not a top shelf goal
	movi	sp_top_shelf_corner,a10
	move	*a7(OZPOS),a14,W
	cmpi	350,a14
	jrgt	sp_dne		;we are in the top corner
	cmpi	329,a14
	jrlt	sp_dne		;we are in the top corner
	movi	sp_top_shelf,a10
	jruc	sp_dne		;top shelf center of goal
swd_nt	movi	sp_5_hole,a10
	move	a1,a14
	dec	a14
	srl	2,a14
	xori	1,a14
	sll	2,a14
	addk	4,a14		;opposite goalie
	GBLOCK	a14,a14
	move	*a14(POF_OBJECT),a9,L
	move	*a9(ODT_GSAVE),a14,L
	cmpi	SET_GFULLBUTT_SCRIPT,a14
	jrnz	swd_n5		;not 5 hole
	move	*a7(OZPOS),a14,W
	cmpi	350,a14
	jrgt	swd_n5		;not 5 hole
	cmpi	329,a14
	jrgt	sp_dne		;5 hole
swd_n5	movi	sp_dsc_any,a10
	jruc	sp_dne

spx_score_game_over
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	move	@scored_by,a1,W
	jrz	kexit
	move	@team1_score,a2,W
	move	@team2_score,a3,W
	move	@team1_score_P2,a5,W
	move	@team2_score_P2,a14,W
	sub	a14,a5
	cmpi	4,a1
	jrls	kr1		;team1
	SWAP	a2,a3
	neg	a5		;a5 is our differential at the end of two
kr1	movk	1,a4		;our differential is 1
	movi	sp_otgw,a10	;game over
	move	a5,a5
	jrnn	sp_dne		;not a come from behind victory
	movi	sp_otgw_cb,a10
	jruc	sp_dne		;a come from behind victory

sp_dne	move	@team1,a6,W
	cmpi	4,a1
	jrls	spdk1
	move	@team2,a6,W
spdk1	move	a4,a5
	abs	a5
	move	a1,a1
	jrz	klor		;we were scored by noone, announce as noone
	GBLOCK	a1,a1
	move	*a1(POF_CHARACTER),a1,W
klor	move	a10,@last_dne,L
	callr	handle_speech_string
kexit	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

sp_fs_ntab
	.word	10,8
	.long	spfs1,spfs2,spfs3,spfs5,spfs6,spfs7,spfs8,spfs9
spfs1	.word	008abh,-85,0		;He shoots He scores 1
spfs2	.word	008ach,-123,0		;_ Shooting : he scores
spfs3	.word	008b0h,-100,0		;He shoots He scores 3
spfs5	.word	009ddh,-93,0		;He shoots, he scores (fast)
spfs6	.word	009e2h,-66,0		;They score
spfs7	.word	009e8h,-49,0		;Its in the net
spfs8	.word	009e2h,-66,0		;They score
spfs9	.word	009dah,-75,0		;The red light goes on


sp_js_ntab
	.word	10,8
	.long	spjs1,spjs2,spjs3,spjs4,spjs7,spjs9,spjs9a,spjsa
spjs1	.word	008b3h,-69,0		;He scores 1
spjs2	.word	008b3h,-69,0		;He scores 1
spjs3	.word	009f4h,-74,0		;He scores
spjs4	.word	00a1bh,-64,0		;He scores
spjs7	.word	00fa6h,-72,0		;He scores (C)
spjs9	.word	009e8h,-51,0		;Its in the net
spjs9a	.word	00a1bh,-64,0		;He scores
spjsa	.word	007d7h,-74,0		;He scores !

sp_smokin
	.word	10,2
	.long	spsmk1,spsmk2
spsmk1	.word	00907h,-45,0		;He-s heating up
spsmk2	.word	00af3h,-60,0		;He's smokin

sp_tsmokin
	.word	00af4h,-59,0		;They're smokin

sp_on_fire_now
	.word	00905h,-76,0		;He-s on fire

sp_hatrack
	.word	009e4h,-126,0		;So many hat tricks he needs a hat rack

sp_hattrick
	.word	009e3h,-58		;The hat trick for _
 	WLW	1,fnm_tab,0

sp_on_fire
	.word	10,2
	.long	sponf1,sponf2
sponf1	.word	00905h,-76,0		;He-s on fire
sponf2	.word	00975h,-70,0		;Toasty

sp_tied
	.word	10,8
	.long	sptd1,sptd2,sptd3,sptd4,sptd5,sptd6,sptd7,sptd10
sptd1	WL	1,fnm_tab
	.word	009e7h,-48,0		;_ Ties it up
sptd2	.word	009e7h,-48,0		;_ Ties it up
sptd3	WL	1,fnm_tab
	.word	009fah,-45,0		;Ties it up
sptd4	.word	009fah,-45,0		;Ties it up
sptd5	.word	00acdh,-72,0		;He ties the game
sptd6	.word	00aceh,-85,0		;He's tied the game
sptd7	.word	00ad6h,-54,0		;Tie Game
sptd10	.word	00ad9h,-64,0		;All tied up

sp_tied_tied_score
	.word	10,2
	.long	sp_tied,spttd
spttd	.word	10,3
	.long	spttd1,spttd2,spttd5
spttd1	.word	00acbh,-61		;Its tied at _
	WLW	3,nmb_tab,0
spttd2	.word	00ad6h,-54,0		;Tie Game
	WL	3,nmb_tab
	.word	00914h,-9		;To _ 2
	WLW	3,nmb_tab,0
spttd5	.word	00ad9h,-64,0		;All tied up
	WL	3,nmb_tab
	.word	00914h,-9		;To _ 2
	WLW	3,nmb_tab,0

sp_new_lead
	WL	6,random_team_version_tab
	.word	00ad4h,-51,0		;_ Take the lead #2
sp_score_down
	WL	6,random_team_version_tab
	.word	00adch,-46		;Down by _
	WLW	5,nmb_tab,0
sp_scores_down
	WL	6,random_team_version_tab
	.word	00ad5h,-31		;_ Trail
	WL	2,nmb_tab
	.word	00914h,-9		;To _ 2
	WLW	3,nmb_tab,0
sp_scores_up
	WL	6,random_team_version_tab
	WL	2,nmb_tab
	.word	00914h,-9		;To _ 2
	WLW	3,nmb_tab,0
sp_score_up
	WL	6,random_team_version_tab
	.word	00adbh,-45		;Up by _
	WLW	5,nmb_tab,0
sp_blow_out
	.word	10,4
	.long	sppbl1,sppbl3,sppbl4,sppbl5
sppbl1	.word	00afeh,-13,0		;Stick a Fork in 'em, they're done
sppbl3	.word	00a08h,-06,0		;What an offensive show
sppbl4	.word	009ffh,-59,0		;Oh My !
sppbl5	.word	00adeh,-69,0		;That's all she wrote
sp_not_giving
	WL	6,random_team_version_tab
	.word	00afbh,-54,0		;_ Aren't giving up

sp_top_shelf_corner
	.word	10,3
	.long	sptsc,spts,sp_dsc_any
sptsc	.word	10,2
	.long	sptsc1,sptsc2
sptsc1	.word	0084eh,-77,0		;Into the top corner
sptsc2	.word	00850h,-78,0		;Put it into the top corner

sp_top_shelf
	.word	10,3
	.long	spts,spts,sp_dsc_any
spts	.word	10,4
	.long	spts3,spts4,spts5,sp_dsa7
spts3	.word	00855h,-78,0		;Onto the top shelf
spts4	.word	00856h,-65,0		;Top shelf !
spts5	.word	0087dh,-87,0		;He went up top !
sp_dsa7	.word	00a13h,-77,0		;He dents the twine

sp_5_hole
	.word	10,3
	.long	sp_5h,sp_5h,sp_dsc_any
sp_5h	.word	10,6
	.long	sp5h1,sp5h2,sp5h5,sp5h6,sp5h7,sp5h8
sp5h1	.word	0084fh,-45		;Great Shot _
	.word	00a20h,-108,0		;He pumped it through the five-hole
sp5h2	.word	00a20h,-108,0		;He pumped it through the five-hole
sp5h5	.word	00a23h,-99,0		;He opened up the pearly gates
sp5h6	.word	00a95h,-84,0		;Right between the legs
sp5h7	.word	00a94h,-49,0		;Through the legs
sp5h8	.word	0084fh,-45		;Great Shot _
	.word	00a95h,-84,0		;Right between the legs

sp_how
	.word	10,2
	.long	sp_hh,sp_dsc_any
sp_hh	.word	00a1eh,-103,0		;Oh how did that one go in ?

sp_dsc_any
	.word	10,7
	.long	sp_dsa1,sp_dsa2,sp_dsa3,sp_dsa4,sp_dsa5,sp_dsa6,sp_dsa8
sp_dsa1	.word	0084fh,-45,0		;Great Shot _
sp_dsa2	WL	1,fnm_tab
	.word	00a05h,-60,0		;_ drives it home
sp_dsa3	.word	00a06h,-62,0		;He tucks it home
sp_dsa8
sp_dsa4	.word	00a0eh,-61		;A big goal by _
	WLW	1,fnm_tab,0
sp_dsa5	.word	00a0fh,-71,0		;A big goal
sp_dsa6	.word	00a11h,-103,0		;He puts the biscuit in the basket 2

sp_otgw	.word	10,2
	.long	sp_ogw1,sp_ogw2
sp_ogw1	WL	1,fnm_tab
	.word	00ad2h,-78,0		;Wins the Game
sp_ogw2	.word	00addh,-99		;a sudden-death goal
	.word	00ad2h,-78,0		;Wins the Game
sp_ogw3	WL	1,fnm_tab
	.word	009d7h,-86,0		;_ scores the game winner

sp_otgw_cb
	.word	10,2
	.long	sp_otw1,sp_otw2
sp_otw1	WL	1,fnm_tab
	.word	00ad2h,-78		;Wins the Game
	.word	00adfh,-67,0		;What a comeback
sp_otw2	.word	00addh,-99		;a sudden-death goal
	.word	00ad2h,-78		;Wins the Game
	.word	00adfh,-67,0		;What a comeback

spx_game_over
	mmtm	sp,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	move	@team1_score,a2,W
	move	@team2_score,a3,W
	move	@team1,a6,W
	move	@team1_score_P2,a5,W
	move	@team2_score_P2,a14,W
	sub	a14,a5
	movi	sp_tie,a10
	cmp	a3,a2
	jrz	sgot		;tie game
	jrgt	sgoa
	move	@team2,a6,W
	SWAP	a3,a2
	neg	a5
sgoa	movi	sp_win,a10
sgot	callr	handle_speech_string
	cmpi	20,a2
	jrgt	sgob		;we can't announce scores
	cmpi	20,a3
	jrgt	sgob		;we can't announce scores
	movi	sp_wscores,a10
	callr	handle_speech_string
sgob	move	a5,a5
	jrnn	sgoc		;not a comeback
	cmp	a2,a3
	jrz	sgoc		;a tie is not a comeback
	movi	sp_comeback,a10
	callr	handle_speech_string
sgoc	mmfm	sp,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

sp_tie	.word	00ad6h,-54,0		;Tie Game

;************************** add just win city call
sp_win	.word	10,2
	.long	spwn1,spwn2
spwn1	WL	6,city_team_name_tab
	.word	00aa2h,-31,0		;_ Win !
spwn2	WL	6,city_team_name_tab
	.word	00ad0h,-59,0		;Win the Game #4

sp_wscores
	WL	2,nmb_tab
	.word	00914h,-9		;To _ 2
	WLW	3,nmb_tab,0

sp_comeback
	.word	00adfh,-67,0		;What a comeback

spx_check_hit_glass_only
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	sp_glass,a10
	move	@glass_break_now,a14,W
	jrnz	schb1
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

spx_check_hit_boards
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	sp_bench,a10
	;do bench check
	movi	sp_glass,a10
	move	@glass_break_now,a14,W
	jrnz	schb1
	movi	sp_boards,a10
schb1	clr	a14
	move	a14,@glass_break_now,W
	jruc	check_common

sp_bench
;  2484 $09b4  5     80.4    92.2  Oh he put him right in the bench

sp_glass
	.word	10,2
	.long	spgls1,spgls2
spgls1	.word	0098ch,-90,0		;_ crashing through the glass
spgls2	.word	008f6h,-66,0		;He broke the glass

sp_boards
	.word	10,2
	.long	spz_any,spzbrds
spzbrds	.word	10,5
	.long	spbr1,spbr2,spbr3,spbr4,spbr5
spbr1	.word	009b3h,-77,0		;_ checked into the boards
spbr2	.word	00993h,-89,0		;_ slammed into the boards
spbr3	.word	00997h,-97,0		;_ hit hard into the boards
spbr4	.word	009b2h,-74,0		;_ checked into the glass
spbr5	.word	009b3h,-77,0		;_ checked into the boards

spx_check_hit_elbow	;a6 = hitter, a7 = hittee
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	sp_elbow,a10
	jruc	check_common

spx_check_hit_push1	;a6 = hitter, a7 = hittee
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	sp_push1,a10
	jruc	check_common

spx_check_hit_push2
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	sp_push2,a10
	jruc	check_common

spx_check_hit_slash
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	sp_slashed,a10
	jruc	check_common

spx_check_hit_high
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	sp_high_sticked,a10
	jruc	check_common

spx_check_hit_hip
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	sp_hipped,a10
	jruc	check_common

spx_check_hit_flying
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	movi	sp_flying,a10
	jruc	check_common

check_common
	calla	get_speech_time_remaining
	cmpi	3,a0
	jrhs	scp1_9
;	movi	sp_push1,a10

	move	*a6(POF_OBJECT),a8,L
	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrnz	scp1_9				;one guy is off screen, no speech
	move	*a7(POF_OBJECT),a9,L
	move	*a9(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrnz	scp1_9				;other guy is off screen, no speech
	move	@PUCK_CONTROL,a14,W
	jrz	scp1k				;puck is free, ok to call
	movb	*a6(POF_NUMBER),a2
	cmp	a2,a14
	jrz	scp1k				;we just got the puck, ok to call
	movb	*a7(POF_NUMBER),a2
	cmp	a2,a14
	jrz	scp1k				;he still has the puck, ok to call
	movi	250,a0
	calla	RANDPER
	jrnc	scp1_9
scp1k	move	*a6(POF_CHARACTER),a2,W
	move	*a7(POF_CHARACTER),a3,W
	callr	handle_speech_string
scp1_9	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

sp_elbow
	.word	10,1
	.long	spz_any

sp_push1
	.word	10,4
	.long	spz_any,spz_any,spz_any,spz_cross

sp_push2
	.word	10,4
	.long	spz_any,spz_any,spz_knocked,spz_cross

sp_slashed
	.word	10,4
	.long	spz_any,spz_any,spz_knocked,spz_slashed

sp_high_sticked
	.word	10,4
	.long	spz_any,spz_any,spz_knocked,spz_high

sp_hipped
	.word	10,4
	.long	spz_any,spz_any,spz_knocked,spz_hip

sp_flying
	.word	10,1
	.long	spz_any

spz_any	.word	10,18
	.long	spa1,spa2,spa3,spa4,spa5,spa6,spa7,spa8,spa9,spa10
	.long	spa11,spa12,spa13,spa15,spa16,spa17,spa18,spa19
spa1	.word	00981h,-67,0		;Brutal hit
spa2	.word	00980h,-108,0		;_ He really clocked him
spa3	.word	00981h,-67,0		;Brutal hit
spa4	.word	00982h,-92,0		;Oh brother that had to hurt
spa5	.word	00983h,-76,0		;He really corked him
spa6	.word	00984h,-71,0		;He unloaded on him
spa7	.word	00985h,-79,0		;A rude greeting
spa8	.word	00986h,-105,0		;Its getting rough out there
spa9	.word	00987h,-62,0		;What a mugging
spa10	.word	00988h,-79,0		;He-s hit hard
spa11	.word	0098bh,-90,0		;No penalty called
spa12	.word	0098dh,-54,0		;_ hit hard
spa13	.word	0098eh,-65,0		;_ checked hard
spa15	WL	3,nm_tab
	.word	009a7h,-73,0		;_ pays the price
spa16	.word	009a8h,-33,0		;Wham 
spa17	.word	009a9h,-37,0		;Bam 
spa18	.word	009aah,-46,0		;Slam 
spa19	.word	009afh,-59		;Clobbered by _
	WLW	2,nm_tab,0

spz_cross
	.word	10,2
	.long	spcr1,spcr2
spcr1	WL	2,nm_tab
	.word	009a1h,-61,0		;_ with a cross-check
spcr2	.word	009adh,-54,0		;_ cross-checked


spz_knocked
	.word	10,11
	.long	spkn1,spkn2,spkn3,spkn4,spkn5,spkn6,spkn7,spkn8,spkn9,spkn10,spkn11
spkn1	.word	00991h,-77,0		;_ taken out of the play
spkn2	.word	00992h,-55,0		;_ taken down
spkn3	.word	00995h,-56,0		;He leveled him
spkn4	.word	00996h,-40,0		;_ leveled !
spkn5	.word	0099ah,-68,0		;He-s unconscious
spkn6	.word	0099dh,-89,0		;Oh man what a hit
spkn7	.word	009ach,-72,0		;_ taken out of the play
spkn8	.word	009ach,-72,0		;_ taken out of the play
spkn9	.word	009b9h,-87,0		;Oh that should be a major
spkn10	.word	009c2h,-77,0		;He took him out
spkn11	.word	009c7h,-77,0		;That knocked the wind out of him

spz_hip
	WL	2,nm_tab
	.word	009a0h,-59,0		;_ with a hip-check

spz_slashed
	.word	00999h,-35,0		;_ tripped up

spz_high
	.word	10,2
	.long	sphg1,sphg2
sphg1	.word	0099fh,-74,0		;He goes flying
sphg2	WL	2,nm_tab
	.word	00994h,-80,0		;_ with the high stick


;misc
;  2462 $099e  5     50.2    57.6  He-s wrapped up
;  2501 $09c5  5     69.9    80.2  He-s back on his feet
;  2502 $09c6  5     73.2    84.0  but with spaghetti legs
;  2506 $09ca  5     87.1    99.8  Ya hate to see that happen



GOALIE_SPEECH
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	move	a0,a1
	jruc	gsgo
do_goalie_phrase
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
gsgo	move	@scored_by,a14,W
	jrnz	dgpr9
	calla	get_speech_time_remaining
	cmpi	25,a0
	jrhs	dgpr9
	move	@goalie_phrase_time,a14,L
	move	@WAVEIRQS,a0,L
	sub	a14,a0
	cmpi	180,a0
	jrls	dgpr9		;3 seconds between goalie calls
	sll	5,a1
	addi	gs_mapl,a1
	move	*a1,a1,L
	call	a1
dgpr9	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets
;big crowd cheer on big save

gs_mapl	.long	gsg_rebound
	.long	gsg_smothered
	.long	gsg_pokecheck	
	.long	gsg_crosscheck
	.long	gsg_frustrated
	.long	gsg_passed	
	.long	gsg_frozen	
	.long	gsg_save		
	.long	gsg_butterfly	
	.long	gsg_padstack	
	.long	gsg_stick	
	.long	gsg_glove	
	.long	gsg_blocker	
	.long	gsg_stomach	
	.long	gsg_skate	
	.long	gsg_none		;gained control
	.long	gsg_none
	.long	gsg_none
	.long	gsg_none
	.long	gsg_none
	.long	gsg_none
	.long	gsg_none
	.long	gsg_none
	.long	gsg_none

gsg_none
	rets

gsg_rebound
	movi	spg_rebound,a10
	jruc	sd_wc			;do a10, or close if close call
gsg_smothered
	rets
	movi	spg_smothered,a10
	jruc	sd_go			;do a10 goalie save call
gsg_pokecheck	
	movi	spg_pokecheck,a10
	jruc	sd_go
gsg_crosscheck
	rets				;already called in crosscheck routine
gsg_frustrated
	rets				;we don't know what to call
gsg_passed	
	rets				;already called
gsg_frozen	
	movi	spg_frozen,a10
	jruc	sd_go
gsg_save		
	movi	spg_save,a10
	jruc	sd_wc
gsg_butterfly	
	movi	spg_butterfly,a10
	jruc	sd_wc
gsg_padstack	
	movi	spg_padstack,a10
	jruc	sd_wc
gsg_stick	
	movi	spg_stick,a10
	jruc	sd_wc
gsg_glove	
	movi	spg_glove,a10
	jruc	sd_wc
gsg_blocker	
	movi	spg_blocker,a10
	jruc	sd_wc
gsg_stomach	
	movi	spg_stomach,a10
	jruc	sd_wc
gsg_skate	
	movi	spg_skate,a10
	;
sd_wc	move	@WAVEIRQS,a1,L
	move	@goalie_phrase_time,a2,L
	sub	a2,a1
	cmpi	180,a1		;3 seconds
	jrhs	sd_gob		;don't do again call (keep unsigned branch)
	move	@PUCK_OBJECT,a14,L
	move	*a14(OXPOS),a14,W
	sra	15,a14
	move	@goalie_phrase_num,a0,W
	cmp	a14,a0
	jrnz	sd_gob
	movi	300,a0
	calla	RANDPER
	jrnc	sd_gob
	movi	sp_close,a10
sd_gob	;do big save check


sd_go	move	@WAVEIRQS,@goalie_phrase_time,L
	move	@PUCK_OBJECT,a14,L
	move	*a14(OXPOS),a14,W
	sra	15,a14
	move	a14,@goalie_phrase_num,W
	move	@PLAYER_4_BLOCK+POF_CHARACTER,a1
	move	a14,a14
	jrnz	sdg2
	move	@PLAYER_8_BLOCK+POF_CHARACTER,a1
sdg2	jauc	handle_speech_string



spg_rebound
	.word	10,1
	.long	sp_gs_regular
spg_smothered
	.word	10,1
	.long	sp_smother
;	.long	sp_frozen
spg_pokecheck
	.word	10,1
	.long	sp_poke
spg_frozen
	.word	10,1
	.long	sp_frozen
spg_save
	.word	10,1
	.long	sp_gs_regular
spg_butterfly
	.word	10,11
	.long	sp_gs_regular
	.long	sp_gs_regular
	.long	sp_gs_regular
	.long	sp_gs_regular
	.long	sp_gs_regular
	.long	sp_deflect
	.long	sp_deflect
	.long	sp_deflect
	.long	sp_deflect
	.long	sp_deflect
	.long	sp_butterfly
spg_padstack
	.word	10,3
	.long	sp_gs_regular
	.long	sp_pad
	.long	sp_deflect
spg_stick
	.word	10,3
	.long	sp_gs_regular
	.long	sp_deflect
	.long	sp_stick_save
spg_glove
	.word	10,2
	.long	sp_gs_regular
	.long	sp_glove
spg_blocker
	.word	10,3
	.long	sp_gs_regular
	.long	sp_blocker
	.long	sp_deflect
spg_stomach
	.word	10,2
	.long	sp_gs_regular
	.long	sp_sting
spg_skate
	.word	10,3
	.long	sp_gs_regular
	.long	sp_deflect
	.long	sp_skate_save

sp_close
sp_gs_regular
	.word	10,20
	.long	sags1,sags2,sags3,sags4,sags5,sags6,sags7,sags8,sags9
	.long	sagsa,sagsb,sagsc,sagsd,sagse,sagsf,sagsg,sagsh
	.long	sagsi,sagsi,sagsi
sags1
sags3	.word	00a27h,-34,0		;Save !
sags2
sags4	.word	00a27h,-30		;Save !
	WLW	1,nmt_tab,0
sags5
sags7	.word	00a2bh,-42,0		;The save !
sags6
sags8	.word	00a2bh,-37		;The save !
	WLW	1,nmt_tab,0
sags9	.word	00a2dh,-66,0		;And a save
sagsa	.word	00a2dh,-58		;And a save
	WLW	1,nmt_tab,0
sagsb	.word	00a2eh,-67,0		;And a save #2
sagsc	.word	00a2eh,-59		;And a save #2
	WLW	1,nmt_tab,0
sagsd	.word	00a52h,-62,0		;He stopped him
sagse	.word	00a52h,-62,0		;He stopped him
sagsf	.word	00a53h,-69,0		;He stops him
sagsg	.word	00a78h,-59,0		;The save !
sagsh	.word	00a78h,-52		;The save !
	WLW	1,nmt_tab,0
sagsi	WLW	1,nm_tab,0		;just last name

sp_pad
	.word	10,10
	.long	sapd1,sapd2,sapd3,sapd4,sapd5,sapd6,sapd7,sapd8,sapd9,sapda
sapd1	WL	1,nm_tab
	.word	00a44h,-79,0		;_ Just got a leg on it
sapd2	.word	00a44h,-79,0		;_ Just got a leg on it
sapd3	.word	00a47h,-73,0		;He just got a leg on it #2
sapd4	.word	00a49h,-86,0		;He just got a pad on it
sapd6
sapd7
sapd5	.word	00a58h,-86,0		;He flashed out the pad
sapd8	.word	00a81h,-65,0		;He goes into the stack #2
sapd9	.word	00a81h,-65,0		;He goes into the stack #2
sapda	.word	00a82h,-70,0		;He stacks the pads

sp_glove
	.word	10,4
	.long	sagl1,sagl2,sagl3,sagl4
sagl1	.word	00a57h,-66,0		;Glove Save
sagl2	.word	00a57h,-60		;Glove Save
	WLW	1,nmt_tab,0
sagl3	WL	1,nm_tab
	.word	00a67h,-49,0		;Got a glove on it
sagl4	.word	00a67h,-49,0		;Got a glove on it

sp_butterfly
	.word	00a84h,-58,0		;_ with the Butterfly

sp_blocker
	.word	10,4
	.long	sabk1,sabk2,sabk3,sabk4
sabk1	.word	00a89h,-64,0		;Blocker Save !
sabk2	.word	00a89h,-61		;Blocker Save !
	WLW	1,nmt_tab,0
sabk3	.word	00a73h,-31,0		;Blocked !
sabk4	.word	00a73h,-31		;Blocked !
	WLW	1,nmt_tab,0

sp_deflect
	.word	10,5
	.long	sadf1,sadf2,sadf3,sadf4,sadf5
sadf4
sadf1	.word	008fch,-64,0		;De-flected
sadf5
sadf2	.word	008fch,-64		;De-flected
	WLW	1,nmt_tab,0
sadf3	WL	1,nm_tab
	.word	00a3dh,-51,0		;Dee-flects it
sadf6	WL	1,nm_tab
	.word	00a79h,-61,0		;_ Got a piece of it
sadf7	.word	00a62h,-49,0		;Rebound

sp_smother
;	.word	10,2
;	.long	sp_smt1,sp_smt2
;sp_smt1	.word	00a36h,-37,0		;He dives
;sp_smt2	.word	00a36h,-37,0		;He dives

sp_frozen
	.word	10,10
	.long	safz1,safz2,safz3,safz4,safz5,safz6,safz7,safz8,safz9,safza
safz1	.word	00a68h,-75,0		;And he holds on
safz2	WL	1,nm_tab
	.word	00a34h,-60,0		;_ Freezes the puck
safz3	.word	00a37h,-74,0		;He freezes the puck
safz4	.word	00a63h,-68,0		;He freezes it
safz7
safz5
safz8
safz6
safz9	.word	00a65h,-85,0		;And the puck is frozen #2
safza	.word	00a65h,-85		;And the puck is frozen #2
	WLW	1,nmt_tab,0

sp_skate_save
	.word	10,10
	.long	sakv1,sakv2,sakv3,sakv4,sakv5,sakv6,sakv7,sakv8,sakv9,sakva
sakv3	.word	00a3ah,-67,0		;Skate Save #2
sakv4	.word	00a3ah,-63		;Skate Save #2
	WLW	1,nmt_tab,0
sakv5	.word	00a3bh,-55		;Off the skate of _
	WLW	1,nm_tab,0
sakv1
sakv9
sakv6
sakv2
sakva
sakv7
sakv8
sakvb	.word	00a5ch,-82,0		;Kick Save and a beauty

sp_poke
	.word	10,2
	.long	sapk1,sapk2
sapk1	.word	00968h,-43,0		;_ pokes at it
sapk2	WL	1,nm_tab
	.word	00968h,-43,0		;_ pokes at it

sp_stick_save
	.word	10,4
	.long	satv1,satv2,satv3,satv4
satv1	WL	1,nm_tab
	.word	0096ah,-56,0		;_ gets his stick on it
satv2	.word	00a48h,-77,0		;He just got a stick on it
satv4	WL	1,nm_tab
	.word	00969h,-57,0		;_ gets a handle on it
satv3	.word	00a48h,-77,0		;He just got a stick on it

;sp_big
;	.word	10,17
;	.long	spbg1,spbg2,spbg3,spbg4,spbg5,spbg6,spbg7,spbg8,spbg9,spbga,spbgb,spbgc,spbgd,spbge,spbgf,spbgg,spbgh
;spbg1	.word	00a24h,-63,0		;What a Save #1
;spbg2	.word	00a25h,-50,0		;What a Save #2
;spbg3	.word	00a5dh,-58,0		;Big Save #1
;spbg4	.word	00a5eh,-57,0		;Big Save #2
;spbg5	.word	00a5fh,-68,0		;What a save #3
;spbg6	.word	00a4bh,-70,0		;Brilliant Goaltending
;spbg8	.word	00a4dh,-69,0		;Great Goaltending
;spbgb	.word	00a75h,-132,0		;What a goaltending show we've had here
;spbgc	.word	00a93h,-57,0		;He shut 'em down
;spbgd	.word	00a8ch,-111,0		;Oh an impossible save
;spbge	.word	00af5h,-61,0		;Great Save
;spbgf	.word	00a70h,-64,0		;Beautiful Save !
;spbgg	.word	00a71h,-50,0		;_ Robs him #1

;sp_stick_side
;	.word	00a6ch,-51,0		;Swept aside _ (byX)
;	.word	0085fh,-68,0		;Cleared away 
;	.word	00a43h,-89,0		;Deflected Wide


;sp_mask
;	.word	00a8ah,-55,0		;Off the mask
;	.word	00a8bh,-57,0		;He stoned him

;sp_shoulder

sp_sting
	.word	10,2
	.long	spsg1,spsg2
spsg1	.word	00a87h,-52,0		;That stung him !
	WL	1,nm_tab
spsg2	.word	00a88h,-53,0		;_Shaken up !

spx_steal
	move	*a6(POF_CHARACTER),a1
	move	@PUCK_CONTROL,a0,W
	jrz	spx_freed
	movi	spstlt,a10
	jruc	handle_speech_string
spx_freed
	movi	spfrdt,a10
	jruc	handle_speech_string

spstlt	.word	10,6
	.long	sftk1,sftk1,sftk1,sftk2,sftk3,sftk3
sftk1	.word	00970h,-53,0		;Stolen
sftk2	.word	00972h,-51,0		;He Jaked it
sftk3	.word	00973h,-61,0		;What a steal

spfrdt	.word	10,6
	.long	sfrd1,sfrd3,sfrd3,sfrd4,sfrd5,sfrd6
sfrd1	.word	00965h,-60,0		;The puck is loose
sfrd2	.word	00966h,-67,0		;He looses the puck
sfrd3	WL	1,nm_tab
	.word	00968h,-43,0		;_ pokes at it
sfrd4	.word	0096bh,-63,0		;The puck comes out
sfrd5	.word	0096ch,-58,0		;Knocked away
sfrd6	.word	00978h,-47,0		;He looses it

spx_off_goalpost
	calla	get_speech_time_remaining
	cmpi	10,a0
	jrgt	spogpt9
	move	@PUCK_MODE,a14,W
	cmpi	PUM_SCORE,a14
	jrhs	spogpt9
	movi	spgpl,a10
	jruc	handle_speech_string
spogpt9	rets
spgpl	.word	10,3
	.long	szgl1,szgl2,szgl3
szgl1	.word	008a9h,-77,0		;Off the goalpost
szgl2	.word	008c1h,-69,0		;He hit the goalpost
szgl3	.word	008c2h,-79,0		;He rattled it off the pipe

handle_speech_string_sc
	clr	a14
	move	a14,@shot_call,W
handle_speech_string
	mmtm	sp,a10
	move	@SOUNDSUP,a4,W
	jrnz	hss_9
hss_0	move	*a10+,a4,W
	jrz	hss_9
	jrn	hss_tm
	cmpi	20,a4
	jrhi	hss_snd
	sll	5,a4
	addi	hss_dt,a4
	move	*a4,a4,L
	call	a4
	jruc	hss_0
hss_9	calla	get_speech_time_remaining
	move	a0,a0
	jrz	hss99
	move	@WAVEIRQS,a14,L
	add	a0,a14
	move	a14,@estimated_speech_end,L
	cmpi	900,a0
	jrlt	hss99
	nop			;error here
	calla	init_speech_buffer
hss99	mmfm	sp,a10
	rets
hss_snd	calla	add_speech_sound
	jruc	hss_0
hss_tm	calla	add_speech_time
	jruc	hss_0
hss_dt	.long	hss_ie		;0  - we never get here
	.long	hss_t1		;1  - use a1 as table index to embed (L) (player (source))
	.long	hss_t2		;2  - use a2 as table index to embed (L) (player (destination))
	.long	hss_t3		;3  - use a3 as table index to embed (L) (team)
	.long	hss_sn		;4  - use a2 as last name called (call just before name)
	.long	hss_t5		;5  - use a5 as table index to embed (L) (he/she (source))
	.long	hss_t6		;6  - use a6 as table index to embed (L) (he/she (destination))
	.long	hss_ad		;7  - call address (move a10 past parameters) (L..)
	.long	hss_br		;8  - branch to long (L)
	.long	hss_eb		;9  - embed string (L)
	.long	hss_rb		;10 - randomly branch to 1 of W L's (WL[L..])
	.long	hss_s2		;11 - use a1 as last name called (call just before name)
	.long	hss_ie
	.long	hss_ie
	.long	hss_ie
	.long	hss_ie
	.long	hss_ie
	.long	hss_ie
	.long	hss_ie
	.long	hss_ie
	.long	hss_ie

hss_ie	LOCKUP
	rets
hss_t1	move	a1,a4
	jruc	hss_tb
hss_t2	move	a2,a4
	jruc	hss_tb
hss_t3	move	a3,a4
	jruc	hss_tb
hss_t5	move	a5,a4
	jruc	hss_tb
hss_t6	move	a6,a4
hss_tb	sll	5,a4
	move	*a10+,a14,L
	add	a4,a14
	mmtm	sp,a10
	move	*a14,a10,L
	callr	handle_speech_string
	mmfm	sp,a10
	rets
hss_s2	move	a1,@last_name_spoken,W
	jruc	ak47
hss_sn	move	a2,@last_name_spoken,W
ak47	calla	get_speech_time_remaining
	move	@WAVEIRQS,a14,L
	add	a0,a14
	move	a14,@last_name_time,L
	rets
hss_ad	move	*a10+,a14,L
	jump	a14
hss_br	move	*a10,a10,L
	rets
hss_eb	move	*a10+,a14,L
	mmtm	sp,a10
	move	a14,a10
	callr	handle_speech_string
	mmfm	sp,a10
	rets
hss_rb	move	*a10+,a0,W
	calla	RAND0
	sll	5,a0
	add	a0,a10
	move	*a10,a10,L
	rets



name_check_a0
	mmtm	sp,a0
	GBLOCK	a0,a14
	move	*a14(POF_CHARACTER),a0,W
	move	@last_name_spoken,a14,W
	cmp	a0,a14
	mmfm	sp,a0
	rets

name_check_a6
	mmtm	sp,a0
	move	*a6(POF_CHARACTER),a0,W
	move	@last_name_spoken,a14,W
	cmp	a0,a14
	mmfm	sp,a0
	rets









