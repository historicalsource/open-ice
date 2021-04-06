	.MLIB	"HHMACS.LIB"
	.FILE	"HHCX.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

	.INCLUDE	"HH.INC"		;Game equates
	.INCLUDE	"hhstring.h"
	.include	"hhcmos.g"
	.include	"hhcx.e"
	.include	"hhutil.g"
	.include	"hhmisc.g"
	.include	"hhgame.g"
	.include	"hhplayer.g"
	.include	"hhselect.g"
	.include	"hhpick.g"
	.include	"hhtext.g"
	.include	"hhram.g"

; end of include files

	.TEXT

	.bss	read_data_temp,8*32
	.bss	match_b_initial1,16
	.bss	match_b_initial2,16
	.bss	match_b_initial3,16
	.bss	match_b_month,16
	.bss	match_b_day,16
	.bss	b_initial1,16		;5
	.bss	b_initial2,16		;5
	.bss	b_initial3,16		;5
	.bss	b_month,16		;4
	.bss	b_day,16		;5

	.bss	b_teamsbeat,32		;32
	.bss	b_nextteam,16		;5
	.bss	b_wins,16		;11
	.bss	b_losses,16		;11

	.bss	b_ties,16		;8
	.bss	b_lastteam1,16		;5	;who we were
	.bss	b_lastteam2,16		;5	;who we played against
	.bss	b_teammate_initial1,16	;5

	.bss	b_teammate_initial2,16	;5
	.bss	b_teammate_initial3,16	;5
	.bss	b_opp1_initial1,16	;5
	.bss	b_opp1_initial2,16	;5
	.bss	b_opp1_initial3,16	;5

	.bss	b_opp2_initial1,16	;5
	.bss	b_opp2_initial2,16	;5
	.bss	b_opp2_initial3,16	;5
	.bss	b_last_score1,16	;6	;what we scored

	.bss	b_last_score2,16	;6	;what they scored
	.bss	b_dronemod,16		;4	;+/- 7 for drone mod
	.bss	b_game_count_last,32	;18	;game count when last played
	.bss	b_checksum,16		;8	;post bitted checksum
	.bss	b_streak,16		;8	;winning streak

	.bss	b_end,0

	.bss	b_fightwins,16		;
	.bss	b_fightlosses,16

	.bss	b_rank,16		;computed rank (only valid from cx_player_in)

	;saved copies
	.bss	s_last_score1,16	;6	;what we scored
	.bss	s_last_score2,16	;6	;what they scored

NUMBER_CRECS	.set	480		;480 cmos records (15K)
NUMBER_TRECS	.set	10		;10 high score records

	.bss	listwlt,16*4*NUMBER_CRECS	;keep our win/loss/ties/allbeat in easy to get at ram
	.bss	toprecords,16*4*NUMBER_TRECS	;records of cmos#/win/loss/tie
	.bss	end_toprecords,0
	.bss	mostrecords,16*4*NUMBER_TRECS	;records of cmos#/win/loss/tie
	.bss	end_mostrecords,0
	.bss	pctrecords,16*4*NUMBER_TRECS	;records of cmos#/win/loss/tie
	.bss	end_pctrecords,0

	.bss	stcrecords,16*4*NUMBER_TRECS	;records of cmos#/win/loss/tie
	.bss	end_stcrecords,0


	.bss	stanley_data,16*5*3
	.bss	stanley_checksum,16

CM_GAME_NUMBER	.set	CM_MISC		;4 bytes, 2 checksum bytes

STANLEYSIZE	.set	4*16
STANLEYNUM	.set	10

cx_powerup
	movi	AUDITORG,a0
	movi	HSR_C,a0
	movi	ADJUSTORG,a0
	callr	check_all_records	;fills up listwlt
	callr	cx_build_toprecords
	callr	check_stanley
	rets

add_stanley		;assume b_data is correct
;	mmtm	sp,a0
	callr	check_stanley
	callr	bump_down_stanley
;	mmfm	sp,a0
;	calla	get_cmos_record_a
	movi	stanley_data,a1
	move	@b_initial1,a14,W
	cmpi	26,a14
	jrnz	as_reg
	move	@b_initial2,a14,W
	cmpi	26,a14
	jrnz	as_reg
	move	@b_initial2,a14,W
	cmpi	26,a14
	jrnz	as_reg
	movi	'I',a14			;stick bill's name in for all spaces
	move	a14,*a1+,W		;and he will shorten time for
	movi	'C',a14			;camera flashes
	move	a14,*a1+,W
	movi	'E',a14
	move	a14,*a1+,W
	jruc	as_con
as_reg	move	@b_initial1,a14,W
	calla	PENACHO_TO_ASCII
	move	a14,*a1+,W
	move	@b_initial2,a14,W
	calla	PENACHO_TO_ASCII
	move	a14,*a1+,W
	move	@b_initial3,a14,W
	calla	PENACHO_TO_ASCII
	move	a14,*a1+,W
as_con	move	@b_month,a0,W
	move	a0,*a1+,W
	move	@b_day,a0,W
	move	a0,*a1+,W
	jruc	write_stanley

bump_down_stanley
	movi	stanley_data+10*16,a1
	movi	stanley_data+15*16,a0
	movk	10,a14
bds1	move	-*a1,-*a0,W
	dsjs	a14,bds1
	rets

check_stanley
	callr	read_stanley
	movi	stanley_data,a1
	movk	3,a2	;3 sets of initials
cstc2	movk	3,a3	;3 characters per set
cstc1	move	*a1+,a0,W
	jrz	cstc9		;done, we have a zero
	cmpi	' ',a0
	jrlo	cs9e
	cmpi	'Z',a0
	jrhi	cs9e
	dsjs	a3,cstc1
	move	*a1+,a0,W
	jrn	cs9e
	cmpi	12,a0
	jrgt	cs9e
	move	*a1+,a0,W
	jrn	cs9e
	cmpi	31,a0
	jrgt	cs9e
	dsjs	a2,cstc2
cstc9	rets
cs9e	;
	;
init_stanley
	mmtm	sp,a0,a1,a2,a3,a7
	callr	is
	mmfm	sp,a0,a1,a2,a3,a7
	rets

read_stanley
	movi	CM_STANLEY,a7
	movi	stanley_data,a2
	movk	15,a1
	clr	a3
rst1	calla	RC_WORDI
	move	a0,*a2+,W
	add	a0,a3
	dsjs	a1,rst1
	addi	12356,a3
	calla	RC_WORDI
	sll	16,a3
	srl	16,a3
	sll	16,a0
	srl	16,a0
	cmp	a0,a3
	jrz	rst9
is	movi	CM_STANLEY,a7
	movi	stanley_data,a2
	movk	15,a1
	clr	a0
	clr	a3
rst2	move	a0,*a2+,W
	calla	WC_WORDI
	add	a0,a3
	dsjs	a1,rst2
	addi	12356,a3
	sll	16,a3
	srl	16,a3
	move	a3,a0
	calla	WC_WORDI
rst9	rets

write_stanley
	movi	CM_STANLEY,a7
	movi	stanley_data,a2
	movk	15,a1
	clr	a3
ws1	move	*a2+,a0,W
	calla	WC_WORDI
	add	a0,a3
	dsjs	a1,ws1
	addi	12356,a3
	sll	16,a3
	srl	16,a3
	move	a3,a0
	calla	WC_WORDI
	rets


cx_build_toprecords
	movi	toprecords,b2
	movi	end_toprecords-(16*4),b3
	movi	is_a03_higher_than_a8x,b0
	callr	build_10_list

	movi	mostrecords,b2
	movi	end_mostrecords-(16*4),b3
	movi	is_a03_most_higher_than_a8x,b0
	callr	build_10_list

	movi	pctrecords,b2
	movi	end_pctrecords-(16*4),b3
	movi	is_a03_pct_higher_than_a8x,b0
	callr	build_10_list

	rets

build_10_list
	move	b2,a2
	callr	clear_10_list
	movi	listwlt,a10	;a10 is pointer into listwlt
	clr	a11		;a11 is cmos# of above pointer
cbt4	move	*a10,a1,W	;a1 is wins
	move	*a10(16),a2,W	;a2 is losses
	move	*a10(32),a3,W	;a3 is ties
	move	a1,a0
	sll	1,a0
	add	a3,a0		;a0 is points
	move	b3,a8		; end record in list of 10
	call	b0		; check routine
	jrnc	cbt5
	movi	NUMBER_TRECS,a9
	move	b2,a8		; beginning of list
cbt3	call	b0		; check routine
	jrnc	cbt2		;check next record lower
	callr	move_from_a8x_down
	callr	insert_a03_at_a8x
	jruc	cbt5
cbt2	addi	16*4,a8
	dsjs	a9,cbt3		;check all the way down the list
cbt5	addi	16*4,a10
	inc	a11
	cmpi	NUMBER_CRECS,a11
	jrnz	cbt4
	rets

is_a03_pct_higher_than_a8x
	mmtm	sp,a9
	callr	a03xx
	mmfm	sp,a9
	rets
a03xx	move	a1,a7
	add	a2,a7
	add	a3,a7		;a7  = records games (a0 = our points)
	jrz	a03p_n		; we have no games in list, we are lower
	jrn	a03p_n
	cmpi	10,a7
	jrlt	a03p_n
	move	*a8(16),a4,W	;win
	move	*a8(32),a5,W	;loss
	move	*a8(48),a6,W	;tie
	move	a4,a14
	add	a5,a14
	add	a6,a14		;a14 = our games
	jrz	a03p_y		; we have no games, we are higher
	move	a4,a9
	sll	1,a9
	add	a6,a9		;a9  = our points
	sll	16,a9		;points shifted 16
	sll	1,a14		;games *2
	divu	a14,a9		;a9 = pct
	mmtm	sp,a0
	sll	16,a0		;points shifted 16
	sll	1,a7		;games *2
	SWAP	a0,a7
	divu	a0,a7
	SWAP	a0,a7		;a0 = pct
	cmp	a0,a9
	mmfm	sp,a0
	jrgt	a03p_n
	jrlt	a03p_y
	jruc	is_a03_higher_than_a8x		;just use points for ties
a03p_y	setc
	rets
a03p_n	clrc
	rets

;fuck up checksum here
	rets
	rets
	rets
	rets
	movi	100,a0
	movi	100,a0
	movi	100,a0
	movi	100,a0
	.string	"sans sans",0
	.even

is_a03_most_higher_than_a8x
	move	*a8(16),a4,W	;win
	move	*a8(32),a5,W	;loss
	move	*a8(48),a6,W	;tie
	move	a4,a14
	add	a5,a14
	add	a6,a14		;a14 = our games
	move	a1,a7
	add	a2,a7
	add	a3,a7		;records games
	cmp	a14,a7
	jrgt	a03m_y		;more games
	jrlt	a03m_n
	cmp	a4,a1
	jrgt	a03m_y		;more wins
	jrlt	a03m_n
	cmp	a6,a3
	jrgt	a03m_y		;more ties
a03m_n	clrc
	rets
a03m_y	setc
	rets


is_a03_higher_than_a8x
	move	*a8(16),a4,W	;win
	move	*a8(32),a5,W	;loss
	move	*a8(48),a6,W	;tie
	move	a4,a14
	sll	1,a14
	add	a6,a14
	cmp	a14,a0
	jrgt	a03_y		;more points
	jrlt	a03_n
	cmp	a4,a1
	jrgt	a03_y		;more wins
	jrlt	a03_n
	cmp	a5,a2
	jrlt	a03_y		;less losses
a03_n	clrc
	rets
a03_y	setc
	rets

move_from_a8x_down
	move	b3,a4
mfa1	cmp	a4,a8
	jrz	mfa9		;we are on last record, done
	subi	(16*4),a4
	move	*a4(0),*a4(16*4),L
	move	*a4(32),*a4(32+(16*4)),L
	jruc	mfa1
mfa9	rets

insert_a03_at_a8x
	move	a11,*a8,W
	move	a1,*a8(16),W
	move	a2,*a8(32),W
	move	a3,*a8(48),W
	rets

clear_10_list
	movk	NUMBER_TRECS,a1
	clr	a0
	move	a0,a3
	dec	a0
cbt1	move	a0,*a2+,W
	move	a3,*a2+,L
	move	a3,*a2+,W
	move	a0,@WDOG_BONE,W		;watchdog
	dsjs	a1,cbt1
	rets




cx_game_start
	callr	cx_inc_game_number
	clr	a14
	subk	2,a14		;-2 - no initials
	move	a14,@PLAYER_1_BLOCK+POF_CMOS,W
	move	a14,@PLAYER_2_BLOCK+POF_CMOS,W
	move	a14,@PLAYER_5_BLOCK+POF_CMOS,W
	move	a14,@PLAYER_6_BLOCK+POF_CMOS,W
	movk	27,a14		;? - for no initials entered
	movb	a14,@PLAYER_1_BLOCK+POF_INITIAL1
	movb	a14,@PLAYER_1_BLOCK+POF_INITIAL2
	movb	a14,@PLAYER_1_BLOCK+POF_INITIAL3
	movb	a14,@PLAYER_2_BLOCK+POF_INITIAL1
	movb	a14,@PLAYER_2_BLOCK+POF_INITIAL2
	movb	a14,@PLAYER_2_BLOCK+POF_INITIAL3
	movb	a14,@PLAYER_5_BLOCK+POF_INITIAL1
	movb	a14,@PLAYER_5_BLOCK+POF_INITIAL2
	movb	a14,@PLAYER_5_BLOCK+POF_INITIAL3
	movb	a14,@PLAYER_6_BLOCK+POF_INITIAL1
	movb	a14,@PLAYER_6_BLOCK+POF_INITIAL2
	movb	a14,@PLAYER_6_BLOCK+POF_INITIAL3
	rets

cx_player_in	;a0 = block
	mmtm	sp,a0,a1,A2,A3,A4,a6,a7,a8,A10
	move	a0,a6
	callr	pbl_to_mb_
	calla	find_special_character
	MOVE	A0,A0
	JRN	CPI_CHECK				;BR=NO SPECIAL CHARACTER
	MOVE	A0,*A6(POF_CHARACTER),W
	MOVE	A0,*A6(POF_LOCKED_CHAR),W
;mdp yescmosrecord
;	JRUC	cpi_9
;mdp yescmosrecord
CPI_CHECK
	callr	check_for_record
	move	a0,*a6(POF_CMOS),W
	move	a0,a0
	jrn	cpi_9
	callr	get_cmos_record_a
	callr	cx_find_rank
cpi_9	mmfm	sp,a0,a1,A2,A3,A4,a6,a7,a8,A10
	rets

cx_game_over		;after full game, not premature
	clr	a1
	move	a1,@all_beaten_bits,W
	callr	cx_get_game_number
	move	a1,a11		;save us in a11
	movk	1,a0
	callr	cxgo_pl		;do game over for player
	movk	2,a0
	callr	cxgo_pl
	movk	5,a0
	callr	cxgo_pl
	movk	6,a0
	callr	cxgo_pl
	callr	cx_build_toprecords
	;..
	rets
cxgo_pl	GBLOCK	a0,a6
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	cxgp_9

;mdp yescmosrecord
;	MOVE	*A6(POF_LOCKED_CHAR),A14,W
;	JRNZ	cxgp_9				;BR=SPECIAL CHARACTER
;mdp yescmosrecord

	move	*a6(POF_CMOS),a0,W
	cmpi	-2,a0
	jrz	cxgp_9			;no initials
	cmpi	-1,a0
	jrnz	cxg_up		;update record
	callr	pbl_to_b_
	callr	pbl_to_mb_
	callr	get_free_cmos_record
	move	a0,*a6(POF_CMOS),W
	callr	prep_new_record_a6
	jruc	cxg_up1
cxg_up	callr	get_cmos_record_a
cxg_up1	move	@b_last_score1,@s_last_score1,L		;save both score1 and score2
	callr	did_we_win_u_scores
	jrp	co_win
	jrn	co_ls
co_tie	callr	update_ties
	jruc	co_dwlt
co_win	callr	update_teamsbeat
	callr	update_nextteam
	callr	update_wins
	callr	update_droneup
	jruc	co_dwlt
co_ls	callr	update_losses
	callr	update_dronedown
co_dwlt	callr	update_teammate
	callr	update_opponents
	move	a11,@b_game_count_last
	move	*a6(POF_CMOS),a0,W
	callr	store_cmos_record_a
cxgp_9	rets

cx_find_rank	;taken from b_??data
	move	*a6(POF_CMOS),a1,W
	movi	toprecords,a2

	movk	1,a0
	movk	NUMBER_TRECS,a3

fki_a1	move	*a2,a14,W
	cmp	a14,a1
	jrz	fki_aa
	inc	a0
	addi	(16*4),a2
	dsjs	a3,fki_a1

	move	@b_wins,a1,W
	sll	1,a1
	move	@b_ties,a14,W
	add	a14,a1		;a1 is our points
	movi	NUMBER_CRECS,a2
	movk	1,a0		;a0 is our potential rank
	movi	listwlt,a3
fki2	move	*a3+,a4,W	;wins
	sll	1,a4
	addk	16,a3		;get us to ties
	move	*a3+,a14,W
	addk	16,a3		;get us to start
	add	a14,a4		;a4 is record points
	cmp	a4,a1
	jrge	fki1
	inc	a0		;our rank is down one
fki1	dsjs	a2,fki2
fki_aa	move	a0,@b_rank,W
	rets

pbl_to_b_
	move	a6,a7
	addi	POF_INITIAL1,a7
	movi	b_initial1,a8
	movk	5,a1
cf1	movb	*a7,a14		;copy initials, birthday
	addk	8,a7
	move	a14,*a8+,W
	dsjs	a1,cf1
	rets

pbl_to_mb_
	move	a6,a7
	addi	POF_INITIAL1,a7
	movi	match_b_initial1,a8
	movk	5,a1
mcf1	movb	*a7,a14		;copy initials, birthday
	addk	8,a7
	move	a14,*a8+,W
	dsjs	a1,mcf1
	rets

did_we_win_u_scores
	move	@team1_score,a0,W
	move	@PLAYER_1_BLOCK+POF_TEAM,a2,W
	move	@team2_score,a1,W
	move	@PLAYER_5_BLOCK+POF_TEAM,a3,W
	movb	*a6(POF_NUMBER),a14
	dec	a14
	srl	2,a14
	jrz	dww1
	SWAP	a0,a1
	SWAP	a2,a3
dww1	move	a0,@b_last_score1,W
	move	a2,a14
	cmpi	26,a14
	jrls	dw1i1
	movk	27,a14
dw1i1	move	a14,@b_lastteam1,W
	move	a1,@b_last_score2,W
	move	a3,a14
	cmpi	26,a14
	jrls	dw1i2
	movk	27,a14
dw1i2	move	a14,@b_lastteam2,W
	sub	a1,a0
	rets

update_teamsbeat
	movb	*a6(POF_NUMBER),a14
	dec	a14
	srl	2,a14
	neg	a14
	inc	a14		;0/1 of other team
	sll	2,a14
	inc	a14		;1/5 of other team
	GBLOCK	a14,a14
	move	*a14(POF_TEAM),a14,W
	cmpi	26,a14
	jrhi	utb_nnk
	dec	a14
	movk	1,a0
	sll	a14,a0
	move	@b_teamsbeat,a14,L
	move	a14,a1
	or	a0,a14
	move	a14,@b_teamsbeat,L
	cmp	a1,a14		;are we beating a new team
	jrz	utb_nn		;not a new team beat
	cmpi	03ffffffh,a14	;26 teams
	jrnz	utb_nn
	movi	AUD_ALL_BEATEN,a0
	calla	AUD1
	movb	*a6(POF_NUMBER),a14
	dec	a14
	movk	1,a0
	sll	a14,a0
	move	@all_beaten_bits,a14,W
	or	a0,a14
	move	a14,@all_beaten_bits,W
	move	*a6(POF_CMOS),a0
	callr	add_stanley
utb_nn	clrc
	rets
utb_nnk	setc
	rets

**************************************************************************
*								         *
* pick_beginning_nextteam						 *
*								         *
**************************************************************************
pick_beginning_nextteam
	clr	a0
	clr	a1
	jruc	uyaa
pick_alt_nextteam	;if we can't use the team we pick, florida is good
	movi	team_panthers,a0
	move	a0,@b_nextteam,W
	rets
update_nextteam
	move	@b_nextteam,a0,W
	move	@b_teamsbeat,a1,L
	cmpi	03ffffffh,a1
	jrz	ubt000
	dec	a0
	btst	a0,a1
	jrz	unt_9
uyaa	movi	tb_list,a5
uy1	move	*a5+,a2,L
	jrz	unt_ab		;we have beaten them all
	callr	untsb
	jrnc	uy1
	jruc	unt_8		;a0 is our team
unt_ab	clr	a0
	dec	a0		;-1 is our team, we beat them all
unt_8	sll	27,a0
	srl	27,a0
	move	a0,@b_nextteam,W
unt_9	rets
ubt000	clr	a0
	move	a0,@b_nextteam,W
	rets

untsb	move	a1,a14
	move	*a2+,a3,L
	and	a3,a14
	cmp	a14,a3
	jrz	untp	;we have beaten all teams in this slot
	move	*a2+,a0,W
	move	a0,a4	;a4 is our count
	calla	RAND0
	sll	4,a0
	add	a0,a2	;a2 is our starting location to check
unt1	move	*a2+,a0,W
	move	a0,a14
	dec	a14
	btst	a14,a1
	jrz	untf	;we found a team
	dsjs	a4,unt1
	LOCKUP
untf	setc		;a0 is our team
	rets
untp	clrc		;no team found on our list
	rets

tb_list	.long	tnlist1,tnlist2,tnlist3,tnlist4
	.long	tnlist5,tnlist6,tnlist7,0

tnlist1	.long	000000100000001001000010000b
	.word	4
	.word	team_lightning
	.word	team_mighty_ducks
	.word	team_islanders
	.word	team_senators

	.word	team_lightning
	.word	team_mighty_ducks
	.word	team_islanders

tnlist2	.long	000110010000000000010001100b
	.word	6
	.word	team_panthers
	.word	team_whalers
	.word	team_canadiens
	.word	team_kings
	.word	team_jets
	.word	team_oilers

	.word	team_panthers
	.word	team_whalers
	.word	team_canadiens
	.word	team_kings
	.word	team_jets



tnlist3	.long	001001001001010000001000011b
	.word	8
	.word	team_stars
	.word	team_flames
	.word	team_sharks
	.word	team_maple_leafs
	.word	team_avalanche
	.word	team_sabres
	.word	team_capitals
	.word	team_bruins

	.word	team_stars
	.word	team_flames
	.word	team_sharks
	.word	team_maple_leafs
	.word	team_avalanche
	.word	team_sabres
	.word	team_capitals

tnlist4	.long	010000000100000010000100000b
	.word	4
	.word	team_penguins
	.word	team_rangers
	.word	team_canucks
	.word	team_blues

	.word	team_penguins
	.word	team_rangers
	.word	team_canucks

tnlist5	.long	000000000000100100000000000b
	.word	2
	.word	team_flyers
	.word	team_blackhawks

	.word	team_flyers

tnlist6	.long	000000000010000000000000000b
	.word	1
	.word	team_red_wings

tnlist7	.long	000000000000000000100000000b
	.word	1
	.word	team_devils

update_wins
	move	@b_streak,a14,W
	inc	a14
	move	a14,@b_streak,W		;we let all hell break loose on 256 wins (not really)
	move	@b_wins,a14,W
	inc	a14
	cmpi	0800h,a14
	jrhs	uw1
	move	a14,@b_wins,W
uw1	rets

update_droneup
	move	@b_dronemod,a0,W
	jrn	dup2
	move	@b_losses,a2,W
	move	@b_wins,a14,W
	add	a14,a2
	move	@b_ties,a14,W
	add	a14,a2
	cmpi	3,a2
	jrhs	droneup_slower
	move	@team1_score,a2,W
	move	@team2_score,a14,W
	sub	a2,a14
	abs	a14
	cmpi	2,a14
	jrls	dupc
	inc	a0
	cmpi	5,a14
	jrls	dupc
	inc	a0
dupc	cmpi	10,a0
	jrhi	dup1
	move	a0,@b_dronemod,W
dup1	rets
dup2	clr	a0
	move	a0,@b_dronemod,W
	rets

droneup_slower
	move	@team1_score,a2,W
	move	@team2_score,a14,W
	sub	a2,a14
	abs	a14
	cmpi	6,a14
	jrhs	duxc1		;we won by 6 or more, increase level

	move	@b_streak,a14,W
	jrz	duxc0
	cmpi	10,a14
	jrhs	duxc1		;every win after 10 goes up a level
	cmpi	5,a14
	jrnz	duxc0		;if it is not 5 wins, don't go up (go up on 5,10,11...)
;	cmpi	2,a14
;	jrls	duxc0		;we won by 2 or less, stay same
;	move	@s_last_score1,a14,W
;	move	@s_last_score2,a2,W
;	cmp	a2,a14
;	jrls	duxc0		;we won our first win in a row by 3-4 points, stay same
duxc1	inc	a0
duxc0	cmpi	10,a0
	jrls	duxv
	movk	10,a0
duxv	move	a0,@b_dronemod,W
	rets

update_dronedown
	move	@b_dronemod,a0,W
	jrz	ddn2
	dec	a0
	jrz	ddn1
	move	@team1_score,a2,W
	move	@team2_score,a14,W
	sub	a14,a2
	abs	a2
	cmpi	5,a2
	jrls	ddn1
	dec	a0		;go down 2 if we lose by a lot
ddn1	move	a0,@b_dronemod,W
ddn2	rets

update_ties
	move	@b_ties,a14,W
	inc	a14
	cmpi	0100h,a14
	jrhs	ut1
	move	a14,@b_ties,W
ut1	rets

update_losses
	clr	a14
	move	a14,@b_streak,W
	move	@b_losses,a14,W
	inc	a14
	cmpi	0800h,a14
	jrhs	ul1
	move	a14,@b_losses,W
ul1	rets

update_teammate
	movi	b_teammate_initial1,a2
	movb	*a6(POF_NUMBER),a0
	dec	a0
	xori	1,a0
	inc	a0		;teammate
	jruc	uptpers

update_opponents
	movb	*a6(POF_NUMBER),a0
	dec	a0
	srl	2,a0
	neg	a0
	inc	a0		;0/1 of other team
	sll	2,a0
	inc	a0		;1/5 of other team
	mmtm	sp,a0
	callr	uptpers
	mmfm	sp,a0
	inc	a0
	;

uptpers	GBLOCK	a0,a1
	move	*a1(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	cccpu
	move	*a1(POF_CMOS),a14,W
	cmpi	-2,a14
	jrz	ccnone
	jruc	cci

ccnone	movi	27,a14
	move	a14,*a2+,W
	movi	27,a14
	move	a14,*a2+,W
	movi	27,a14
	move	a14,*a2+,W
	rets

cccpu	movi	'C'-'A',a14
	move	a14,*a2+,W
	movi	'P'-'A',a14
	move	a14,*a2+,W
	movi	'U'-'A',a14
	move	a14,*a2+,W
	rets

cci	movb	*a1(POF_INITIAL1),a14
	move	a14,*a2+,W
	movb	*a1(POF_INITIAL2),a14
	move	a14,*a2+,W
	movb	*a1(POF_INITIAL3),a14
	move	a14,*a2+,W
	rets

cx_test
;	callr	init_cmos_records
;	callr	check_all_records
	movi	cxt_table,a1
cxt_2	move	*a1,a14,W
	jrz	cxt_x
	movi	match_b_initial1,a2
	movk	3,a0
cxt_1	move	*a1+,a14,W
	cmpi	" ",a14
	jrnz	cxt21
	movi	26,a14
	jruc	cxt22
cxt21	subi	"A",a14
cxt22	move	a14,*a2+,W
	dsjs	a0,cxt_1
	movk	2,a0
cxt_3	move	*a1+,*a2+,W
	dsjs	a0,cxt_3
;	callr	find_match_record
	jruc	cxt_2
cxt_x	rets

cxt_table
	.word	"I","U","A",1,1
	.word	"J","V","A",1,1
	.word	"K","W","A",1,1
	.word	"L","X","A",1,1
	.word	0

cx_powerup_colorado
	calla	cx_get_game_number
	cmpi	701,a1
	jrhs	cx_ar			;we are already powered up
	movi	701,a1
	callr	cx_store_game_number
cx_ar	rets

cx_inc_game_number
	callr	cx_get_game_number
	inc	a1
	sll	14,a1
	srl	14,a1		;leave 18 bits
	jruc	cx_store_game_number

cx_get_game_number
	movi	CM_GAME_NUMBER,a7
	calla	RC_LONGI
	move	a0,a1
	cmpi	03ffffh,a1	;18 bits of game number
	jrhi	cxg_er		;too high, error
	callr	compute_csn
	calla	RC_WORDI
	cmp	a0,a2		;does our checksum match
	jrz	cxg9
cxg_er	clr	a1
	jruc	cx_store_game_number
cxg9	rets

cx_store_game_number
	move	a1,a0
	movi	CM_GAME_NUMBER,a7
	calla	WC_LONGI
	callr	compute_csn
	move	a2,a0
	jauc	WC_WORDI

compute_csn			;get what checksum should be for a1
	move	a1,a2
	move	a2,a0
	sll	16,a0
	srl	16,a0
	srl	16,a2
	add	a0,a2
	sll	16,a2
	srl	16,a2			;a1 is now 16 bits of high and low words added
	xori	1100110110100011b,a2	;this should be our checksum
	rets

**************************************************************************
*								         *
* init_cmos_records							 *
* 	input	none							 *
*								         *
**************************************************************************
init_cmos_records
	mmtm	sp,a0,a7,a9
	callr	init_stanley
	clr	a0
	move	a0,@b_initial1,W
	move	a0,@b_initial2,W
	move	a0,@b_initial3,W
	move	a0,@b_month,W
	move	a0,@b_day,W
	movk	10,a0		;skip first 10
icr_1	callr	store_cmos_record_a
	inc	a0
	cmpi	NUMBER_CRECS,a0
	jrlt	icr_1

	movi	default_table_start,a9
	clr	a0
icr_2	calla	get_cmos_record_address
	move	*a9+,a1,W
	move	a1,@match_b_initial1,W
	move	*a9+,a1,W
	move	a1,@match_b_initial2,W
	move	*a9+,a1,W
	move	a1,@match_b_initial3,W
	move	*a9+,a1,W
	move	a1,@match_b_month,W
	move	*a9+,a1,W
	move	a1,@match_b_day,W
	mmtm	sp,a7
	calla	prep_new_record
	mmfm	sp,a7
	move	*a9+,a14,W
	move	a14,@b_wins,W
	move	*a9+,a14,W
	move	a14,@b_losses,W
	move	*a9+,a14,W
	move	a14,@b_ties,W
	calla	store_cmos_record
	inc	a0
	cmpi	10,a0
	jrnz	icr_2
	mmfm	sp,a0,a7,a9
	rets

HSTDMAC	.macro	i1,i2,i3,mn,dt,wn,ls,tt
	.word	:i1:-'A',:i2:-'A',:i3:-'A'
	.word	mn,dt
	.word	wn,ls,tt
	.endm

default_table_start
	HSTDMAC	'T','W','G',  8, 3,11, 2, 4 
	HSTDMAC	'U','T','B',  1,13,10, 5, 2
	HSTDMAC	'C','R','L',  9, 3,10, 3, 1
	HSTDMAC	'S','A','N',  9, 5, 9, 8, 0
	HSTDMAC	'D','T','L', 12,25, 2, 2, 0
	HSTDMAC	'I','T','F',  1, 1, 3, 3, 9
	HSTDMAC	'F','A','N',  9,11, 4,10, 3
	HSTDMAC	'B','T','P',  7, 4, 4,10, 2
	HSTDMAC	'F','E','L',  5, 5, 3, 9, 3
	HSTDMAC	'C','H','R',  2, 1, 0, 3, 3

**************************************************************************
*								         *
* check_all_records							 *
* 	input	none							 *
*								         *
**************************************************************************
check_all_records
	clr	a0
	movi	listwlt,a9
car_1	callr	get_cmos_record_anc
	callr	is_record_legit
	jrc	car_ok
	callr	clear_record
	clr	a14
car_11	dec	a14
	move	a14,*a9+,W
	move	a14,*a9+,W
	move	a14,*a9+,W
	clr	a14
	move	a14,*a9+,W	;all beat=no
	jruc	car_xm
car_ok	move	@b_month,a14,W
	jrz	car_11
	move	@b_day,a14,W
	jrz	car_11
	move	@b_wins,a14,W
	move	a14,*a9+,W
	move	@b_losses,a14,W
	move	a14,*a9+,W
	move	@b_ties,a14,W
	move	a14,*a9+,W
	move	@b_teamsbeat,a14,W
	cmpi	03ffffffh,a14
	jrz	carhj
	clr	a14
carhj	move	a14,*a9+,W	;0 or all 1's for beaten
car_xm	inc	a0
	move	a0,@WDOG_BONE,W		;watchdog
	cmpi	NUMBER_CRECS,a0
	jrlt	car_1
	rets

**************************************************************************
*								         *
* find_match_record							 *
* 	input	match_* = initials and birthday to match		 *
* 	output	a0 = record number					 *
* 		(created if no match)					 *
*								         *
**************************************************************************
;find_match_record
;	mmtm	sp,a7
;	callr	check_for_record
;	move	a0,a0
;	jrnn	fmr_1
;	callr	get_free_cmos_record
;	callr	prep_new_record
;fmr_1	mmfm	sp,a7
;	rets

**************************************************************************
*								         *
* check_for_record							 *
* 	input	match_* = initials and birthday to match		 *
* 	output	a0 = record number					 *
* 		     -1 if no record					 *
*								         *
**************************************************************************
check_for_record
	mmtm	sp,a7
	clr	a0
cvmr_2	callr	does_record_match
	jrc	cvmr_1
	inc	a0
	cmpi	NUMBER_CRECS,a0
	jrlt	cvmr_2
	clr	a0
	dec	a0
cvmr_1	mmfm	sp,a7
	rets

**************************************************************************
*								         *
* prep_new_record							 *
* 	input	match_b_initial,... = initials and birthday		 *
* 		a7 = record address					 *
*								         *
**************************************************************************
prep_new_record_a6	;use a6 as player block who just played
	mmtm	sp,a0,a1
	callr	cbd4
	movb	*a6(POF_NUMBER),a0
	dec	a0
	srl	2,a0
	dec	a0
	abs	a0
	sll	2,a0
	inc	a0
	GBLOCK	a0,a0
	move	*a0(POF_TEAM),a0,W	;our first nextteam is one we lost to
	jruc	nprrq
prep_new_record
	mmtm	sp,a0,a1
	callr	cbd4
	movk	26,a0
	calla	RAND0
nprrq	move	a0,@b_nextteam,W
	clr	a0
	move	a0,@b_wins,W
	move	a0,@b_losses,W
	move	a0,@b_ties,W
	callr	cx_get_game_number
	move	a1,@b_game_count_last,L

;	movi	03fffeffh,a0
;	move	a0,@b_teamsbeat,L

	callr	store_cmos_record		;ok to not update tables, we are stored later
	mmfm	sp,a0,a1
	rets

cbd4	callr	clear_b_data
	movi	b_initial1,a0
	movi	match_b_initial1,a1
	movk	5,a14
pnr_3	move	*a1+,*a0+,W
	dsjs	a14,pnr_3
	clr	a0
	move	a0,@b_teamsbeat,L
	rets

clear_b_data
	clr	a0
	movi	b_initial1,a1
cbd1	move	a0,*a1+,W
	cmpi	b_end,a1
	jrlt	cbd1
	rets

**************************************************************************
*								         *
* clear_record								 *
* 	input	a0 = record #						 *
*								         *
**************************************************************************
clear_record
	mmtm	sp,a0,a7,a9
	calla	get_cmos_record_address
	clr	a0
	movk	32,a14
	movi	read_data_temp,a9
cr_st1	movb	a0,*a9
	addk	8,a9
	dsjs	a14,cr_st1
	callr	write_32
	mmfm	sp,a0,a7,a9
	rets

**************************************************************************
*								         *
* does_record_match							 *
* 	input	a0 = record number					 *
* 		match_* = initials and birthday				 *
* 	output	c  = match						 *
* 		nc = no match						 *
*								         *
**************************************************************************
does_record_match
	mmtm	sp,a0,a1,a2,a3,a7
	callr	get_cmos_record_address
	callr	get_cmos_initials_birthday
	movi	b_initial1,a0
	movi	match_b_initial1,a1
	movk	5,a14
drm_1	move	*a0+,a2,W
	move	*a1+,a3,W
	cmp	a2,a3
	jrnz	drm_n
	dsjs	a14,drm_1
	mmfm	sp,a0,a1,a2,a3,a7
	mmtm	sp,a0,a1,a2,a3,a7
	callr	get_cmos_record_anc
	callr	is_record_legit
	jrc	drm_y
	callr	clear_record
drm_n	mmfm	sp,a0,a1,a2,a3,a7
	clrc
	rets
drm_y	mmfm	sp,a0,a1,a2,a3,a7
	setc
	rets

**************************************************************************
*								         *
* is_record_legit							 *
* 	input	data stuffed in vars					 *
* 	output	c  = record is ok					 *
* 		nc = record is corrupted				 *
*								         *
**************************************************************************
is_record_legit
	mmtm	sp,a0
	move	@b_initial1,a0,W
	cmpi	27,a0
	jrhi	irl_n
	move	@b_initial2,a0,W
	cmpi	27,a0
	jrhi	irl_n
	move	@b_initial3,a0,W
	cmpi	27,a0
	jrhi	irl_n
	move	@b_month,a0,W
	jrnz	irl_tn
	move	@b_day,a0,W
	jrz	irl_y
	jruc	irl_n
irl_tn	cmpi	12,a0
	jrhi	irl_n
	move	@b_day,a0,W
	jrz	irl_n
	cmpi	31,a0
	jrhi	irl_n
irl_un	move	@b_teammate_initial1,a0,W
	cmpi	27,a0
	jrhi	irl_n
	move	@b_teammate_initial2,a0,W
	cmpi	27,a0
	jrhi	irl_n
	move	@b_teammate_initial3,a0,W
	cmpi	27,a0
	jrhi	irl_n
	move	@b_opp1_initial1,a0,W
	cmpi	27,a0
	jrhi	irl_n
	move	@b_opp1_initial2,a0,W
	cmpi	27,a0
	jrhi	irl_n
	move	@b_opp1_initial3,a0,W
	cmpi	27,a0
	jrhi	irl_n
	move	@b_opp2_initial1,a0,W
	cmpi	27,a0
	jrhi	irl_n
	move	@b_opp2_initial2,a0,W
	cmpi	27,a0
	jrhi	irl_n
	move	@b_opp2_initial3,a0,W
	cmpi	27,a0
	jrhi	irl_n
	callr	compute_bchecksum
	move	@b_checksum,a14,W
	cmp	a0,a14
	jrnz	irl_n
irl_y	setc
	mmfm	sp,a0
	rets
irl_n	clrc
	mmfm	sp,a0
	rets

**************************************************************************
*								         *
* get_cmos_record_address						 *
* 	input	a0 = record #						 *
* 	output	a7 = address						 *
*								         *
**************************************************************************
get_cmos_record_address
	move	a0,a7
	cmpi	NUMBER_CRECS,a7
	jrlo	gcra1
	LOCKUP
	movi	NUMBER_CRECS-1,a7
gcra1	sll	9,a7
	addi	CM_PLAYERSTART,a7
	rets

**************************************************************************
*								         *
* is_record_free							 *
* 	input	a7 = address						 *
* 	output	c  = free						 *
* 		nc = not free						 *
*								         *
**************************************************************************
is_record_free
	mmtm	sp,a0,a7
	callr	read_4
	setf	24,0,0
	move	@read_data_temp,a0,0
	setf	16,1,0
	jrz	irf_y
irf_n	clrc
	mmfm	sp,a0,a7
	rets
irf_y	setc
	mmfm	sp,a0,a7
	rets

**************************************************************************
*								         *
* get_cmos_total_games							 *
* 	input	a7 = address of record					 *
* 	output	a3 = total games played					 *
*								         *
**************************************************************************
get_cmos_total_games
	mmtm	sp,a0,a7,a9
	addi	7*C_BYTE_SIZE,a7		;skip 7 bytes
	callr	read_5
	movi	read_data_temp+5,a9		;and 5 bits to get to b_wins
	callr	grab_11
	move	a0,@b_wins,W
	callr	grab_11
	move	a0,@b_losses,W
	callr	grab_8
	move	a0,@b_ties,W
	move	@b_losses,a14,W
	add	a14,a0
	move	@b_wins,a14,W
	add	a14,a0
	move	a0,a3
	mmfm	sp,a0,a7,a9
	rets

**************************************************************************
*								         *
* get_cmos_initials_birthday						 *
* 	input	a7 = address of record					 *
* 	output	b_initial1,2,3 = initials				 *
* 		b_month, b_day...					 *
*								         *
**************************************************************************
get_cmos_initials_birthday
	mmtm	sp,a0,a7,a9
	callr	read_4
	movi	read_data_temp,a9
	callr	grab_5
	move	a0,@b_initial1,W
	callr	grab_5
	move	a0,@b_initial2,W
	callr	grab_5
	move	a0,@b_initial3,W
	callr	grab_4
	move	a0,@b_month,W
	callr	grab_5
	move	a0,@b_day,W
	mmfm	sp,a0,a7,a9
	rets

**************************************************************************
*								         *
* get_cmos_record_a							 *
* 	input	a0 = record #						 *
* 	output	all data stuffed					 *
*								         *
**************************************************************************
get_cmos_record_a
	callr	get_cmos_record_address
	callr	get_cmos_record
	callr	is_record_legit
	jrc	gcra8
	LOCKUP
	callr	clear_record
gcra8	rets

get_cmos_record_anc
	callr	get_cmos_record_address
	callr	get_cmos_record
	rets
get_cmos_record
	mmtm	sp,a0,a7,a9,A10
	callr	read_32
	movi	read_data_temp,a9
	callr	grab_5
	move	a0,@b_initial1,W
	callr	grab_5
	move	a0,@b_initial2,W
	callr	grab_5
	move	a0,@b_initial3,W
	callr	grab_4
	move	a0,@b_month,W
	callr	grab_5
	move	a0,@b_day,W
	callr	grab_32
	move	a0,@b_teamsbeat,L
	callr	grab_5
	move	a0,@b_nextteam,W
	callr	grab_11
	move	a0,@b_wins,W
	callr	grab_11
	move	a0,@b_losses,W
	callr	grab_8
	move	a0,@b_ties,W
	callr	grab_5
	move	a0,@b_lastteam1,W
	callr	grab_5
	move	a0,@b_lastteam2,W
	callr	grab_5
	move	a0,@b_teammate_initial1,W
	callr	grab_5
	move	a0,@b_teammate_initial2,W
	callr	grab_5
	move	a0,@b_teammate_initial3,W
	callr	grab_5
	move	a0,@b_opp1_initial1,W
	callr	grab_5
	move	a0,@b_opp1_initial2,W
	callr	grab_5
	move	a0,@b_opp1_initial3,W
	callr	grab_5
	move	a0,@b_opp2_initial1,W
	callr	grab_5
	move	a0,@b_opp2_initial2,W
	callr	grab_5
	move	a0,@b_opp2_initial3,W
	callr	grab_6
	move	a0,@b_last_score1,W
	callr	grab_6
	move	a0,@b_last_score2,W
	callr	grab_4
	move	a0,@b_dronemod,W
	callr	grab_18
	move	a0,@b_game_count_last,L
	callr	grab_8
	move	a0,@b_checksum,W
	callr	grab_8
	move	a0,@b_streak,W
	mmfm	sp,a0,a7,a9,A10
	rets

**************************************************************************
*								         *
* store_cmos_record							 *
* 	input	a7 = address of record					 *
* 		all data stuffed					 *
*								         *
**************************************************************************
store_cmos_record_a
	move	a0,a7
	sll	6,a7
	addi	listwlt,a7
	move	@b_wins,a14,W
	move	a14,*a7+,W
	move	@b_losses,a14,W
	move	a14,*a7+,W
	move	@b_ties,a14,W
	move	a14,*a7+,W		;store our record in easy to use ram
	move	@b_teamsbeat,a14,W
	cmpi	03ffffffh,a14
	jrz	cajeg
	clr	a14
cajeg	move	a14,*a7+,W	;0 or all 1's for beaten
	calla	get_cmos_record_address
	callr	store_cmos_record
	rets
store_cmos_record
	mmtm	sp,a0,a7,a9
	movi	read_data_temp,a9
	move	@b_initial1,a0,W
	callr	stab_5
	move	@b_initial2,a0,W
	callr	stab_5
	move	@b_initial3,a0,W
	callr	stab_5
	move	@b_month,a0,W
	callr	stab_4
	move	@b_day,a0,W
	callr	stab_5
	move	@b_teamsbeat,a0,L
	callr	stab_32
	move	@b_nextteam,a0,W
	callr	stab_5
	move	@b_wins,a0,W
	callr	stab_11
	move	@b_losses,a0,W
	callr	stab_11
	move	@b_ties,a0,W
	callr	stab_8
	move	@b_lastteam1,a0,W
	callr	stab_5
	move	@b_lastteam2,a0,W
	callr	stab_5
	move	@b_teammate_initial1,a0,W
	callr	stab_5
	move	@b_teammate_initial2,a0,W
	callr	stab_5
	move	@b_teammate_initial3,a0,W
	callr	stab_5
	move	@b_opp1_initial1,a0,W
	callr	stab_5
	move	@b_opp1_initial2,a0,W
	callr	stab_5
	move	@b_opp1_initial3,a0,W
	callr	stab_5
	move	@b_opp2_initial1,a0,W
	callr	stab_5
	move	@b_opp2_initial2,a0,W
	callr	stab_5
	move	@b_opp2_initial3,a0,W
	callr	stab_5
	move	@b_last_score1,a0,W
	callr	stab_6
	move	@b_last_score2,a0,W
	callr	stab_6
	move	@b_dronemod,a0,W
	callr	stab_4
	move	@b_game_count_last,a0,L
	callr	stab_18
	callr	compute_bchecksum
	callr	stab_8
	move	@b_streak,a0,W
	callr	stab_8
	callr	write_32
	mmfm	sp,a0,a7,a9
	rets

compute_bchecksum	;add summing of initials
	clr	a0
	move	@b_initial1,a14
	add	a14,a0
	move	@b_initial2,a14
	add	a14,a0
	move	@b_initial3,a14
	add	a14,a0
	move	@b_month,a14
	add	a14,a0
	move	@b_day,a14
	add	a14,a0
	movb	@b_teamsbeat,a14
	add	a14,a0
	movb	@b_teamsbeat+8,a14
	add	a14,a0
	movb	@b_teamsbeat+16,a14
	add	a14,a0
	movb	@b_teamsbeat+24,a14
	add	a14,a0
	movb	@b_nextteam,a14
	add	a14,a0
	movb	@b_wins,a14
	add	a14,a0
	movb	@b_wins+8,a14
	add	a14,a0
	movb	@b_losses,a14
	add	a14,a0
	movb	@b_losses+8,a14
	add	a14,a0
	movb	@b_ties,a14
	add	a14,a0
	movb	@b_lastteam1,a14
	add	a14,a0
	movb	@b_lastteam2,a14
	add	a14,a0
	movb	@b_teammate_initial1,a14
	add	a14,a0
	movb	@b_teammate_initial2,a14
	add	a14,a0
	movb	@b_teammate_initial3,a14
	add	a14,a0
	movb	@b_opp1_initial1,a14
	add	a14,a0
	movb	@b_opp1_initial2,a14
	add	a14,a0
	movb	@b_opp1_initial3,a14
	add	a14,a0
	movb	@b_opp2_initial1,a14
	add	a14,a0
	movb	@b_opp2_initial2,a14
	add	a14,a0
	movb	@b_opp2_initial3,a14
	add	a14,a0
	movb	@b_last_score1,a14
	add	a14,a0
	movb	@b_last_score2,a14
	add	a14,a0
	move	@b_dronemod,a14,W
	add	a14,a0
	movb	@b_game_count_last,a14
	add	a14,a0
	movb	@b_game_count_last+8,a14
	add	a14,a0
	movb	@b_game_count_last+16,a14
	add	a14,a0
	sll	24,a0
	srl	24,a0
	xori	10110110b,a0
	rets

**************************************************************************
*								         *
* free_up_cmos_record							 *
* 	input	nothing							 *
* 	output	a0 = record # freed					 *
* 		a7 = record address					 *
*								         *
**************************************************************************
free_up_cmos_record
	clr	b0
	clr	a3			;our minimum
	callr	cx_get_game_number
	clr	a4		;just for EXTREME safety
fucr1	move	b0,a0
	callr	get_cmos_record_address
	callr	get_cmos_pgame_number_a0
	callr	get_18_difference
	cmp	a3,a0
	jrlo	fucr2
	move	b0,a4
	move	a0,a3
fucr2	inc	b0
	cmpi	NUMBER_CRECS,b0
	jrlt	fucr1
	move	a4,a0
	jruc	get_cmos_record_address

get_18_difference
  ;a0 = 18 bit player last game
  ;a1 = 18 bit current game
	sub	a1,a0
	neg	a0
	jrp	g18d1
	addi	40000h,a0	;18 bits + 1
g18d1	rets

get_cmos_pgame_number_a0
	addi	19*C_BYTE_SIZE,a7
	callr	read_3
	movi	read_data_temp+6,a9
	jruc	grab_18

**************************************************************************
*								         *
* get_free_cmos_record							 *
* 	input	nothing							 *
* 	output	a0 = record free					 *
* 		a7 = record address					 *
*								         *
**************************************************************************
get_free_cmos_record
	clr	a0
gfc1	callr	get_cmos_record_address
	callr	is_record_free
	jrc	gfcr_8
	inc	a0
	cmpi	NUMBER_CRECS,a0
	jrlt	gfc1
	jruc	free_up_cmos_record
gfcr_8	rets


grab_1	setf	1,0,0		;grabs 1 bit from *a9
	move	*a9+,a0,0
	setf	16,1,0
	rets
grab_4	setf	4,0,0		;grabs 4 bits from *a9
	move	*a9+,a0,0
	setf	16,1,0
	rets
grab_5	setf	5,0,0		;grabs 5 bits from *a9
	move	*a9+,a0,0
	setf	16,1,0
	rets
grab_6	setf	6,0,0		;grabs 6 bits from *a9
	move	*a9+,a0,0
	setf	16,1,0
	rets
grab_8	setf	8,0,0		;grabs 8 bits from *a9
	move	*a9+,a0,0
	setf	16,1,0
	rets
grab_11	setf	11,0,0		;grabs 11 bits from *a9
	move	*a9+,a0,0
	setf	16,1,0
	rets
grab_18	setf	18,0,0		;grabs 18 bits from *a9
	move	*a9+,a0,0
	setf	16,1,0
	rets
grab_32	setf	32,0,0		;grabs 32 bits from *a9
	move	*a9+,a0,0
	setf	16,1,0
	rets

stab_1	setf	1,0,0		;stores 1 bit from *a9
	move	a0,*a9+,0
	setf	16,1,0
	rets
stab_4	setf	4,0,0		;stores 4 bits from *a9
	move	a0,*a9+,0
	setf	16,1,0
	rets
stab_5	setf	5,0,0		;stores 5 bits from *a9
	move	a0,*a9+,0
	setf	16,1,0
	rets
stab_6	setf	6,0,0		;stores 6 bits from *a9
	move	a0,*a9+,0
	setf	16,1,0
	rets
stab_8	setf	8,0,0		;stores 8 bits from *a9
	move	a0,*a9+,0
	setf	16,1,0
	rets
stab_11	setf	11,0,0		;stores 11 bits from *a9
	move	a0,*a9+,0
	setf	16,1,0
	rets
stab_18	setf	18,0,0		;stores 18 bits from *a9
	move	a0,*a9+,0
	setf	16,1,0
	rets
stab_32	setf	32,0,0		;stores 32 bits from *a9
	move	a0,*a9+,0
	setf	16,1,0
	rets

read_15	movk	15,a10
	jruc	read_a10
read_8	movk	8,a10
	jruc	read_a10
read_5	movk	5,a10		;reads 5 bytes from cmos *a7
	jruc	read_a10
read_4	movk	4,a10		;reads 4 bytes from cmos *a7
	jruc	read_a10
read_3	movk	3,a10		;reads 3 bytes from cmos *a7
	jruc	read_a10
read_32	movk	32,a10		;5
read_a10
	movi	read_data_temp,a9
r321	calla	RC_BYTEI
	movb	a0,*a9
	addk	8,a9
	dsjs	a10,r321
	rets

write_15
	movk	15,a10
	jruc	write_a10
write_32
	movk	32,a10		;5
write_a10
	movi	read_data_temp,a9
w321	movb	*a9,a0
	addk	8,a9
	calla	WC_BYTEI
	dsjs	a10,w321
	rets

print_cx_data
	clr	a0
	movi	[4,10],a2
pcd1	callr	ininh
	addi	[10,0],a2
	inc	a0
	cmpi	15,a0
	jrnz	pcd1
	rets

ininh	mmtm	sp,a0
	move	a0,@RAMTEMP3+16,W
	callr	get_cmos_record_a
	move	@b_initial1,a14,W
	calla	PENACHO_TO_ASCII
	move	a14,@RAMTEMP1,W
	move	@b_initial2,a14,W
	calla	PENACHO_TO_ASCII
	move	a14,@RAMTEMP1+16,W
	move	@b_initial3,a14,W
	calla	PENACHO_TO_ASCII
	move	a14,@RAMTEMP2,W
	mmtm	sp,a0,a2
	callr	cx_find_rank
	mmfm	sp,a0,a2

	calla	il_string_m
	 .long	stg1
	 MESS_MAC RD7FONT,1,0,0,COLOR_PWHITE,string_left_constant,OID_TEXT
	callr	str1

	calla	il_string_m
	 .long	stg2
	 MESS_MAC RD7FONT,1,33,0,COLOR_PWHITE,string_left_constant,OID_TEXT
	callr	str1

	calla	il_string_m
	 .long	stg3
	 MESS_MAC RD7FONT,1,80,0,COLOR_PWHITE,string_left_constant,OID_TEXT
	callr	str1

	calla	il_string_m
	 .long	stg4
	 MESS_MAC RD7FONT,1,135,0,COLOR_PWHITE,string_left_constant,OID_TEXT
	callr	str1

	calla	il_string_m
	 .long	stg5
	 MESS_MAC RD7FONT,1,190,0,COLOR_PWHITE,string_left_constant,OID_TEXT
	callr	str1

	calla	il_string_m
	 .long	stg7
	 MESS_MAC RD7FONT,1,220,0,COLOR_PWHITE,string_left_constant,OID_TEXT
	callr	str1
	mmfm	sp,a0
	rets

str1	addxy	a2,a9
	mmtm	sp,a2,a3,a4,a6,a7
	JSRP	PRINTF
	mmfm	sp,a2,a3,a4,a6,a7
	rets

stg1	.string	"%u",0
	.long	RAMTEMP3+16		;record #
stg2	.string	"%c%c%c",0
	.long	RAMTEMP1		;initial 1
	.long	RAMTEMP1+16		;initial 2
	.long	RAMTEMP2		;initial 3
stg3	.string	"%u-%u",0
	.long	b_month
	.long	b_day
stg4	.string	"%u-%u-%u",0
	.long	b_wins
	.long	b_losses
	.long	b_ties
stg5	.string	"%u",0
	.long	b_rank
;stg6	.string	"%08lX",0
;	.long	b_teamsbeat
stg7	.string	"%lu",0
	.long	b_game_count_last
