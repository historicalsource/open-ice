 	.MLIB	"HHMACS.LIB"
	.FILE	"HHFIX.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhfix.e"
	.include	"hhcmos.g"
	.include	"hhgame.g"
	.include	"hhpick.g"
	.include	"hhproc.g"
	.include	"hhplayer.g"

; end of include files

	.bss	cdronemod,16

	.TEXT
	.EVEN

;game over, no winner
; cdronemod = 0
;game over, 1p
; if >= 6 pts, cdronemod +=3
; if >= 5 pts, cdronemod +=2
; cdronemod +=1
;game over, 2p, same team
; if >= 6 pts, cdronemod +=3
; if >= 5 pts, cdronemod +=2
; cdronemod +=1
;game over, 2p, different team
; cdronemod = 2
;game over, 3p
; cdronemod = 2
;game over, 4p
; cdronemod = 2

check_restart_gameover
	callr	do_we_restart_winners
	jrnc	crgo_9
	callr	update_cdronemod
	callr	restart_winners
	CREATE	PID_RESTART_WINNER,strtgr
	jauc	SUCIDE
crgo_9	clr	a0
	move	a0,@cdronemod,W
	jauc	GO_MESS

update_cdronemod
	callr	get_mode_challenge
	cmpi	2,a0
	jrnz	ucd_99
	move	@period,a1,W
	callr	count_period_players
	cmpi	1,a1
	jrz	inc_cdronemod
	cmpi	2,a1
	jrnz	ucd_9
	move	@period,a1,W
	calla	get_period_players
	cmpi	0011b,a1
	jrz	inc_cdronemod
	cmpi	1100b,a1
	jrz	inc_cdronemod
ucd_9	movk	2,a0
	move	a0,@cdronemod,W
ucd_99	rets
inc_cdronemod
	move	@team1_score,a0,W
	move	@team2_score,a1,W
	sub	a0,a1
	abs	a1
	move	@cdronemod,a0,W
	addk	4,a0
	cmpi	5,a1	;5 or more
	jrlo	icd9
	addk	2,a0
	cmpi	6,a1	;6 or more
	jrlo	icd9
	addk	2,a0
icd9	move	a0,@cdronemod,W
	rets

strtgr	calla	start_game_force_new_initials
	jauc	SUCIDE

do_we_restart_winners
	callr	get_mode_challenge
	sll	5,a0
	addi	dwrw_l,a0
	move	*a0,a0,L
	jump	a0

dwrw_l	.long	dwrm_off	;mode is off, we don't restart anyone
	.long	dwrm_4pf	;mode is for 4 players full game
	.long	dwrm_apg	;mode is on for game over, all winners
	.long	dwrm_w2t	;mode is on for human vs. human

dwrm_off			;mode is off
	clrc
	rets
dwrm_4pf			;mode is on 4 players full game
	callr	is_score_tied
	jrc	d4pf_n
	jruc	is_4_full
d4pf_n	clrc
	rets
dwrm_apg			;mode is on for game over, all winners
	jruc	is_human_winner
dwrm_w2t
	callr	is_human_winner
	jrnc	dw2t9n
	callr	is_human_loser
dw2t9n	rets

restart_winners
	callr	get_mode_challenge
	sll	5,a0
	addi	rws_l,a0
	move	*a0,a0,L
	jump	a0

rws_l	.long	rws_off		;mode is off, we don't restart anyone
	.long	rws_4pf		;mode is for 4 players full game
	.long	rws_apg		;mode is on for game over, all winners
	.long	rws_apg		;mode is on for human vs human

rws_off				;mode is off (we never get here)
	rets
rws_4pf				;mode is for 4 players full game
	callr	get_winning_team	;1 or 2
	callr	translate_team_to_players
	callr	start_fullgame_a0
	jruc	start_fullgame_a1
rws_apg				;mode is on for game over, all winners
	callr	get_winning_team
	callr	translate_team_to_players
	callr	start_ppaid_a0
	jruc	start_ppaid_a1

get_winning_team
	move	@team1_score,a2,W
	move	@team2_score,a3,W
	movk	1,a0
	sub	a3,a2
	jrp	gwt9
	movk	2,a0
gwt9	rets

translate_team_to_players
	dec	a0
	sll	1,a0
	move	a0,a3		;a3 is bit to test
	sll	1,a0
	inc	a0
	move	a0,a1
	inc	a1
	callr	is_a3_selector
	jrc	tttp_1
	SWAP	a0,a1
tttp_1	rets

is_a3_selector		;takes 0123
	movb	@TEAM_SELECT_BITS,a14
	btst	a3,a0
	jrnz	ia3y
ia3n	clrc
	rets
ia3y	setc
	rets

start_fullgame_a0
	mmtm	sp,a0,a1
	move	a0,a8
	CREATE	PID_RESTART_WINNER,fill_up_ot
	CREATE	PID_RESTART_WINNER,RESTART_WINNER_PROC
	CREATE	PID_RESTART_WINNER,RESTART_WINNER_PROC
	CREATE	PID_RESTART_WINNER,RESTART_WINNER_PROC
	movk	3,a1
	movi	AUD_FREEP,a0
	calla	AUD
	mmfm	sp,a0,a1
	rets
	
start_fullgame_a1
	mmtm	sp,a0,a1
	move	a1,a8
	CREATE	PID_RESTART_WINNER,fill_up_ot
	CREATE	PID_RESTART_WINNER,RESTART_WINNER_PROC
	CREATE	PID_RESTART_WINNER,RESTART_WINNER_PROC
	CREATE	PID_RESTART_WINNER,RESTART_WINNER_PROC
	movk	3,a1
	movi	AUD_FREEP,a0
	calla	AUD
	mmfm	sp,a0,a1
	rets

start_ppaid_a0
	callr	get_periods_paid_a0
	move	a4,a4
	jrz	spp0_9
spp0_1	move	a0,a8
	mmtm	sp,a0,a1
	CREATE	PID_RESTART_WINNER,RESTART_WINNER_PROC
	movi	AUD_FREEP,a0
	calla	AUD1
	mmfm	sp,a0,a1
	dsjs	a4,spp0_1
spp0_9	rets

start_ppaid_a1
	callr	get_periods_paid_a1
	move	a4,a4
	jrz	spp1_9
spp1_1	move	a1,a8
	mmtm	sp,a0,a1
	CREATE	PID_RESTART_WINNER,RESTART_WINNER_PROC
	movi	AUD_FREEP,a0
	calla	AUD1
	mmfm	sp,a0,a1
	dsjs	a4,spp1_1
spp1_9	rets

get_periods_paid_a0
	GBLOCK	a0,a6
	jruc	gppa
get_periods_paid_a1
	GBLOCK	a1,a6
gppa	movb	*a6(POF_PERIODS_PAID),a14
	clr	a4
	move	@period,a5,W
	jrz	gppb
	dec	a5
gppb	btst	a5,a14
	jrz	gppa9		;none if not played last period
gppc3	movk	4,a8
gppa2	btst	0,a14
	jrz	gppa1
	inc	a4
gppa1	srl	1,a14
	dsjs	a8,gppa2
gppa9	rets

**************************************************************************
*								         *
* RESTART_WINNER_PROC							 *
* 									 *
* PASS:									 *
* A8 = PLAYER NUMBER (1, 2, 5, OR 6)					 *
*								         *
**************************************************************************
RESTART_WINNER_PROC
	MOVE	A8,A0
	JAUC	player_start

**************************************************************************
*								         *
* get_mode_challenge							 *
* 	output	a0 = 0 - no challenge mode				 *
* 		     1 - challenge mode on for 4 player full game	 *
* 		     2 - challenge mode on for any player game		 *
* 		     3 - challenge mode on for human vs. human		 *
*								         *
**************************************************************************
get_mode_challenge	;just read adjustment
	movk	ADJCHALMODE,a0
	jauc	GET_ADJ

is_score_tied
	move	@team1_score,a2,W
	move	@team2_score,a3,W
	cmp	a2,a3
	jrnz	ist_n
ist_y	setc
	rets
ist_n	clrc
	rets

is_4_full
	move	@period,a1,W	;get period # (3 or 4, if overtime)
i4f_1	calla	get_period_players
	cmpi	01111b,a0
	jrnz	i4f_n
	dsjs	a1,i4f_1
	setc
	rets
i4f_n	clrc
	rets

is_human_loser
	callr	is_score_tied
	jrc	ihl_n
	movk	2,a3
	move	@team1_score,a2,W
	move	@team2_score,a14,W
	sub	a14,a2		;a2 is difference from p1 view
	jrp	ihl1
	neg	a2
	clr	a3
ihl1	callr	is_player_human_lp
	jrc	ihl_y
	inc	a3
	callr	is_player_human_lp
	jrc	ihl_y
ihl_n	clrc
	rets
ihl_y	setc
	rets

is_human_winner
	callr	is_score_tied
	jrc	ihw_n		;score is tied, so no winner
	clr	a3
	move	@team1_score,a2,W
	move	@team2_score,a14,W
	sub	a14,a2		;a2 is difference from p1 view
	jrp	ihw1
	neg	a2
	movk	2,a3
ihw1	callr	is_player_human_lp
	jrc	ihw_my
	inc	a3
	callr	is_player_human_lp
	jrc	ihw_my
ihw_n	clrc
	rets
ihw_my	move	@period,a1,W
	callr	count_period_players
	cmpi	1,a1
	jrz	ck_3p		;check for 3 pt victory on 1p
	cmpi	3,a1
	jrhs	ihw_y		;3 or more players, we win
	cmpi	0011b,a0
	jrz	ck_3p		;3 pt victory, 2p on 1 team
	cmpi	1100b,a0
	jrnz	ihw_y		;no 3pt victory needed, on different teams
ck_3p	cmpi	3,a2		;3 or more point victory
	jrlo	ihw_n		;for 1p game required to continue
ihw_y	setc
	rets

count_period_players		;return a1 = count, a0 = players
	calla	get_period_players
	clr	a1
	btst	0,a0
	jrz	cpp1
	inc	a1
cpp1	btst	1,a0
	jrz	cpp2
	inc	a1
cpp2	btst	2,a0
	jrz	cpp3
	inc	a1
cpp3	btst	3,a0
	jrz	cpp4
	inc	a1
cpp4	rets

is_player_human_lp
	move	@period,a1,W
	calla	get_period_players
	btst	a3,a0
	jrz	iph_n
iph_y	setc
	rets
iph_n	clrc
	rets
