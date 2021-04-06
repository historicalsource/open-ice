	.MLIB	"HHMACS.LIB"
	.FILE	"HHDRONE.ASM"
	.WIDTH	132
	.OPTION B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*

	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhpuck.g"
	.include	"hhmath.g"
	.include	"hhcontrl.g"
	.include	"hhplayer.g"
	.include	"hhtimer.g"
	.include	"hhgame.g"
	.include	"hhram.g"
	.include	"hhndrone.e"
	.include	"hh.g"
	.include	"hhutil.g"
	.include	"hhcx.g"
	.include	"hhcontr2.g"
	.include	"hhcmos.g"
	.include	"hhfix.g"

; end of include files

	.bss	drone_level_t1,16
	.bss	drone_level_t2,16
	.bss	drone_temp_1,32

	;  0 - extremely easy - never if with human teammate
	;.	only check if behind by 4
	;.	reduce all probabilities to checks
	;.	only get mean if behind by 5
	;.	reduce all probabilities to meanness
	;v	low percentage to all shots	- done in hhcontr2
	;.	delay on chasing all pucks
	;.	take farther distance when following man
	;  1 - very easy
	;.	reduce all probabilities to checks
	;.	only get mean if behind by 3
	;.	reduce all probabilities to meanness
	;x	percentage shots based on score
	;.	delay on chasing all pucks
	;.	take farther distance when following man
	;  2 - easy
	;.	reduce all probabilities to checks
	;.	reduce all probabilities to meanness
	;x	percentage shots based on score
	;.	delay on chasing all pucks
	;.	take farther distance when following man
	;  3 - moderate
	;.	reduce all probabilities to meanness
	;x	percentage shots based on score
	;.	take farther distance when following man
	;  4 - mid moderate
	;.	reduce all probabilities to meanness
	;  5 - normal - minimum human teammate against all drone team
	;  6 - slightly difficult
	;v	increase percentage to all shots- done in hhcontr2
	;  7 - moderately difficult
	;v	increase percentage to all shots- done in hhcontr2
	;.	chase down all pucks
	;  8 - difficult
	;.	increase probabilities to meanness
	;v	increase percentage to all shots- done in hhcontr2
	;.	chase down all pucks
	;  9 - very difficult
	;.	increase probabilities to checks
	;.	increase probabilities to meanness
	;v	increase percentage to all shots- done in hhcontr2
	;.	chase down all pucks
	; 10 - extremely difficult
	;.	increase probabilities to checks more
	;.	increase probabilities to meanness more
	;v	increase percentage to all shots
	;.	chase down all pucks
	;.	tighten distance when following man

;extra levels
	; 11 - yes, it's hard
	;.	increase probabilities to checks even more
	;.	increase probabilities to meanness even more
	;v	increase percentage to all shots
	;.	chase down all pucks
	;.	tighten distance when following man even more
	; 12 - all we got
	;.	probabilty to check is damn near 100%
	;.	chances are, we are mean
	;v	percentage to all shots is even higher
	;.	all pucks get chased down
	;.	distance when following is very close (we are mean anyway, so it doesn't really matter)

maybe_set_drone_levels
	move	@GAME_STATE,a14,W
	cmpi	INAMODE,a14
	jrz	set_drone_levels
	move	@PLAYER_BITS,a14,W
	move	@PLAYERLBITS,a0,W
	cmp	a0,a14
	jrnz	set_drone_levels
	rets

set_drone_levels
	move	@GAME_STATE,a14,W
	cmpi	INAMODE,a14
	jrnz	sdle1
	movk	11,a0
	calla	RAND0
	move	a0,@drone_level_t1,W
	movk	11,a0
	calla	RAND0
	move	a0,@drone_level_t2,W
	jruc	sdr_9
sdle1	move	@PLAYER_BITS,@PLAYERLBITS,W
	movk	1,a0
	callr	get_our_human_stats
	move	a2,a10
	movk	5,a0
	callr	get_our_human_stats
	move	a2,a11
	move	@team1_score,a1,W
	move	@team2_score,a2,W
	move	a10,a10
	jrz	sd_t10h			;team 1 is all drone
	move	a11,a11
	jrz	sd_t20h			;team 2 is all drone
	cmpi	2,a10
	jrz	sd_t12h			;team 1 is both human
	cmpi	2,a11
	jrz	sd_1_vs_2		;team 1 is one human, team 2 is 2 humans
	jruc	sd_1_vs_1		;team 1 is one human, team 2 is 1 human
sd_t12h	cmpi	2,a11
	jrz	sd_2_vs_2		;team 1 is two humans, team 2 is two humans
	jruc	sd_2_vs_1		;team 1 is two humans, team 2 is one human
sd_t10h	cmpi	1,a11
	jrz	sd_0_vs_1		;team 1 is all drone, team 2 is one human
	jruc	sd_0_vs_2		;team 1 is all drone, team 2 is two humans
sd_t20h	cmpi	1,a10
	jrz	sd_1_vs_0		;team 1 is one human, team 2 is all drone
	jruc	sd_2_vs_0		;team 1 is two humans, team 2 is all drone

sd_2_vs_2	;2 vs 2
	movk	5,a0
	move	a0,@drone_level_t1,W
	move	a0,@drone_level_t2,W
	jruc	sdr_9
sd_1_vs_2	;1 vs 2
	move	a1,a3
	sub	a2,a3		;a3 is differential from t1 view
	callr	dl1v2
	move	a0,@drone_level_t1,W
	movk	5,a0
	move	a0,@drone_level_t2,W
	jruc	sdr_9
sd_2_vs_1
	movk	5,a0
	move	a0,@drone_level_t1,W
	move	a2,a3
	sub	a1,a3		;a3 is differential from t2 view
	callr	dl1v2
	move	a0,@drone_level_t2,W
	jruc	sdr_9
sd_1_vs_1
	move	a1,a3
	sub	a2,a3		;a3 is differential from t1 view
	callr	dl1v1
	move	a0,@drone_level_t1,W
	neg	a3		;a3 is differential from t2 view
	callr	dl1v1
	move	a0,@drone_level_t2,W
	jruc	sdr_9
sd_0_vs_1
	move	a1,a3
	sub	a2,a3		;a3 is differential from t1 view
	movk	5,a4		;check teams beat for players 5 and 6
	callr	dl0v1
	move	a0,@drone_level_t1,W
	neg	a3		;a3 is differential from t2 view
	callr	dl1v0
	move	a0,@drone_level_t2,W
	jruc	sdr_9
sd_1_vs_0
	move	a1,a3
	sub	a2,a3		;a3 is differential from t1 view
	callr	dl1v0
	move	a0,@drone_level_t1,W
	neg	a3		;a3 is differential from t2 view
	movk	1,a4		;check teams beat for players 1 and 2
	callr	dl0v1
	move	a0,@drone_level_t2,W
	jruc	sdr_9
sd_0_vs_2
	move	a1,a3
	sub	a2,a3		;a3 is differential from t1 view
	movk	5,a4		;check teams beat for players 5 and 6
	callr	dl0v2
	move	a0,@drone_level_t1,W
	neg	a3		;a3 is differential from t2 view
	movk	5,a0
	move	a0,@drone_level_t2,W
	jruc	sdr_9
sd_2_vs_0
	move	a1,a3
	sub	a2,a3		;a3 is differential from t1 view
	movk	5,a0
	move	a0,@drone_level_t1,W
	neg	a3		;a3 is differential from t2 view
	movk	1,a4		;check teams beat for players 1 and 2
	callr	dl0v2
	move	a0,@drone_level_t2,W
	;
sdr_9	move	@drone_level_t1,a1,W
	move	a1,@PLAYER_3_BLOCK+POF_DRONE_LEVEL,W
	move	a1,@PLAYER_4_BLOCK+POF_DRONE_LEVEL,W
	movk	1,a0
	callr	sr1a
	callr	sr1a
	move	@drone_level_t2,a1,W
	move	a1,@PLAYER_7_BLOCK+POF_DRONE_LEVEL,W
	move	a1,@PLAYER_8_BLOCK+POF_DRONE_LEVEL,W
	movk	5,a0
	callr	sr1a
sr1a	GBLOCK	a0,a14
	move	a1,a2
	move	*a14(POF_HOT_VALUE),a3,W
	cmpi	19,a3
	jrnz	sr2a
	cmpi	10,a2
	jrhs	sr2a
	inc	a2
sr2a	move	a2,*a14(POF_DRONE_LEVEL),W
	inc	a0
	rets

;coin boost drone level
; game over (no free)
;  coin_boost = 0
;  coin_d3p_boost = 0
; 1p wins
;  vs cpu
;   if large victory
;    coin_boost +=2
;   coin_boost +=1
;  vs 1p
;   coin_boost = no_change (hold level for back to 1p/2p play)
;  vs 2p
;   coin_boost = no_change (hold level for back to 1p/2p play)
;   coin_d3p_boost -=1 (if margin > 2);
; 2p wins
;  vs cpu
;   if large victory
;    coin_boost +=2
;   coin_boost +=1
;  vs 1p
;   coin_boost = no change (hold level for back to 1p/2p play)
;   coin_d3p_boost +=1 (if margin > 2);
;  vs 2p
;   coin_boost = no change (hold level for back to 1p/2p play)

dl0v1	;get drone level for all drone vs 1 human
	movi	drones_vs_one_player_table,a5
	jruc	do_tms_table	;do table for teams beat and game adjust

dl0v2	;get drone level for all drone vs 2 humans
	movi	drones_vs_two_players_table,a5
	jruc	do_tms_table	;do table for teams beat and game adjust

dl1v2	;get drpme level for 1 human vs 2 humans
	nop
	callr	dl1v1		;get 1 vs 1
	subk	3,a0
	jrnn	d12v9
	clr	a0		;don't let us (unlikely) go below zero
d12v9	rets

dl1v1	;get drone level for 1 human vs 1 human
	nop
dl1v0	;get drone level for 1 human vs all drone
	movk	5,a0	;5 if 5 or more ahead
	cmpi	4,a3
	jrgt	d1v09
	movk	6,a0	;6 if 4 ahead to 2 behind
	cmpi	-3,a3
	jrgt	d1v09
	movk	7,a0	;7 if 3 or more behind
d1v09	rets

do_tms_table
	movi	ADJDIFF,a0
	calla	GET_ADJ
	move	a0,a0
	jrp	dtm1
	movk	1,a0
dtm1	cmpi	9,a0
	jrls	dtm2
	movk	9,a0
dtm2	dec	a0		;32 below table for 1-9
	sll	5,a0
	add	a0,a5
	move	*a5,a5,L	;a5 is our group of tables
	callr	get_minimum_teams_beat
	sll	4,a8
	add	a8,a5
	move	*a5,a0,W	;a0 is our drone level, before +/- score correction
	movk	7,a5		;add 7 if behind 6
	cmpi	-5,a3
	jrlt	dtm3
	movk	4,a5		;add 4 if behind 3
	cmpi	-2,a3
	jrlt	dtm3
	clr	a5		;nothing if losing
	move	@period,a8,W	;a8 is our period (for period 3 check)
	cmpi	3,a8		;
	jrnz	dtm21
	movk	1,a5		;add 1 if losing and period is 3 (but not ot)
dtm21	move	a3,a3
	jrn	dtm3
	clr	a5		;nothing if ahead 2
	cmpi	3,a3
	jrlt	dtm3
	movi	-2,a5		;subtract 2 if ahead 4
	cmpi	5,a3
	jrlt	dtm3
	movi	-3,a5		;subtract 3 if ahead 5 or more
dtm3	add	a5,a0
	jrnn	dtm4
	clr	a0
dtm4	mmtm	sp,a0
	callr	get_dronemod
	mmfm	sp,a0
	add	a8,a0
	cmpi	10,a0
	jrls	dtm5
	movk	10,a0		;cap regular drones at 10
dtm5	move	@cdronemod,a14,W
	add	a14,a0
	cmpi	12,a0
	jrls	dtm6
	movk	12,a0		;cap coin modified drones at 12
dtm6	rets

get_minimum_teams_beat
	mmtm	sp,a3
	move	a4,a0
gmt1	clr	a8
	callr	gmsb
	inc	a0
	callr	gmsb
	mmfm	sp,a3
	rets
gmsb	GBLOCK	a0,a6
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	gh3		;drone
;mdp yescmosrecord
;	move	*a6(POF_LOCKED_CHAR),a14,W
;	jrnz	gh21h
;mdp yescmosrecord
	move	*a6(POF_CMOS),a14,W
	jrn	gh212		;no previous record or no initials
	mmtm	sp,a0
	move	a14,a0
	calla	get_cmos_record_a
	mmfm	sp,a0
	move	@b_teamsbeat,a14,L
	clr	a6
	movk	32,a3
gh1	sll	1,a14
	jrnc	gh2
	inc	a6
gh2	dsjs	a3,gh1
gh212a	cmp	a8,a6
	jrls	gh3
	move	a6,a8
gh3	rets

gh212	movk	6,a6		;if no record, pretend 6 teams beat
	jruc	gh212a
gh21h	movk	9,a6		;if locked character
	jruc	gh212a


get_dronemod
	move	a4,a0
	clr	a8
	callr	dmsb
	inc	a0
dmsb	GBLOCK	a0,a6
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	dms3		;drone
	move	*a6(POF_CMOS),a14,W
	jrn	dms3		;no previous record or no initials
	mmtm	sp,a0
	move	a14,a0
	calla	get_cmos_record_a
	mmfm	sp,a0
	move	@b_dronemod,a6,W
	cmp	a8,a6
	jrls	dms3
	move	a6,a8
dms3	rets

;				    1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2
;teams beat	0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6

drones_vs_one_player_table
	.long	dl1_01,dl1_02,dl1_03,dl1_04,dl1_05
	.long	dl1_06,dl1_07,dl1_08,dl1_09,dl1_10

dl1_01	.word	1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,5,5, 5,5,5,5,5,5,5,5,5,5
dl1_02	.word	1,1,1,1,1,2,2,2,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,4,5,6,6, 6,6,6,6,6,6,6,6,6,6
dl1_03	.word	1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,6,6, 6,6,6,6,6,6,6,6,6,6
dl1_04	.word	1,2,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,5,5,5,5,6,6,6,7, 7,7,7,7,7,7,7,7,7,7
dl1_05	.word	2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,4,4,5,5,5,5,5,6,6,6,7,7, 7,7,7,7,7,7,7,7,7,7
dl1_06	.word	2,2,2,2,3,3,3,3,4,4,4,4,4,4,4,5,5,5,5,5,5,5,6,6,7,7,8, 8,8,8,8,8,8,8,8,8,8
dl1_07	.word	2,2,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,6,6,7,8,9, 9,9,9,9,9,9,9,9,9,9
dl1_08	.word	2,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,6,6,6,7,8,9,10, 10,10,10,10,10,10,10,10,10,10
dl1_09	.word	3,3,4,4,4,4,4,4,5,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,8,9,10, 10,10,10,10,10,10,10,10,10,10
dl1_10	.word	3,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,7,7,7,7,8,8,8,9,9,10, 10,10,10,10,10,10,10,10,10,10

;				    1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2
;teams beat	0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6

drones_vs_two_players_table
	.long	dl2_01,dl2_02,dl2_03,dl2_04,dl2_05
	.long	dl2_06,dl2_07,dl2_08,dl2_09,dl2_10

dl2_01	.word	1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4, 4,4,4,4,4,4,4,4,4,4
dl2_02	.word	1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4, 4,4,4,4,4,4,4,4,4,4
dl2_03	.word	1,1,1,1,1,2,2,2,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,4,4,4,5, 5,5,5,5,5,5,5,5,5,5
dl2_04	.word	1,1,1,2,2,2,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,4,4,4,5,5,5, 5,5,5,5,5,5,5,5,5,5
dl2_05	.word	1,1,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5, 5,5,5,5,5,5,5,5,5,5
dl2_06	.word	1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,6, 6,6,6,6,6,6,6,6,6,6
dl2_07	.word	2,2,2,2,3,3,3,3,3,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6, 6,6,6,6,6,6,6,6,6,6
dl2_08	.word	2,2,2,3,3,3,3,3,4,4,4,4,4,4,4,5,5,5,5,5,5,5,6,6,6,7,7, 7,7,7,7,7,7,7,7,7,7
dl2_09	.word	2,2,2,3,3,3,3,4,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,7,7,8, 8,8,8,8,8,8,8,8,8,8
dl2_10	.word	2,2,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,7,7,7,8, 8,8,8,8,8,8,8,8,8,8

;chase pucks

get_our_score_diff
	move	@team1_score,a2,W
	move	@team2_score,a14,W
	sub	a14,a2
	movb	*a6(POF_NUMBER),a14
	cmpi	4,a14
	jrls	gosd9
	neg	a2
gosd9	rets

do_drone_logic
	mmtm	sp,a0,a10
	move	*a6(POF_DRONEC),a14,W
	jrz	ddl_iu
	clr	a14
	move	a14,*a6(POF_DRONEC),W
	move	*a6(POF_DRONECT),a14,W
	inc	a14
	move	a14,*a6(POF_DRONECT),W
ddl_iu	callr	ddl1
	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrnz	ddl_sim 		;skip mean increment if off screen
	move	*a6(POF_DRONE_MEANNESS),a0,W
	inc	a0
	move	a0,*a6(POF_DRONE_MEANNESS),W
ddl_sim move	*a6(POF_DRONE_MEANSTATE),a14,W
	jrnz	ddl9
	cmpi	200,a0
	jrls	ddl9
	move	@PUCK_CONTROL,a14,W
	jrz	ddl_nx
	move	@global_control_slow,a14,W
	jrnz	ddl_s3	;if we are slowing puck carrier down, drones can get mean

ddl_nx	callr	get_our_score_diff
	move	*a6(POF_DRONE_LEVEL),a0,W
	jrnz	ddl_s1
	cmpi	-5,a2		;drone level 0, behind by 5?
	jrgt	ddl9
ddl_s1	cmpi	1,a0
	jrnz	ddl_s2
	cmpi	-3,a2
	jrgt	ddl9		;drone level 1, behind by 3?
ddl_s2	cmpi	4,a0
	jrhi	ddl_s3
	movk	32,a0	;was 25 ;drone level 0-4, low meanness probability
	jruc	ddl_s4

ddl_s3	cmpi	8,a0
	jrlt	ddl_sr		;drone level 5-7, regular meanness
	cmpi	10,a0
	jrhs	ddl_m2		;drone level 10 or more, very mean
ddl_m1	movi	115,a0	;was 70 ;drone level 8,9 - mean
	jruc	ddl_s4
ddl_m2	movi	400,a14
	cmpi	10,a0
	jrz	dm2_d2
	movi	700,a14
	cmpi	11,a0
	jrz	dm2_d2
	movi	950,a14
dm2_d2	move	a14,a0
	jruc	ddl_s4

;	;movi	145,a0	;was 100;drone level 10, very mean
;	movi	400,a0	;sanssnas
;	jruc	ddl_s4
ddl_sr	movi	62,a0	;was 55
ddl_s4	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrz	ddl_rok 		;we are on screen, normal mean %
	sra	3,a0			;we are off screen mean % /8
ddl_rok calla	RANDPER
	jrnc	ddl9
	movk	1,a0
	move	a0,*a6(POF_DRONE_MEANSTATE),W
ddl9	mmfm	sp,a0,a10
	rets
ddl1	;callr	get_our_human_stats
	movb	*a6(POF_NUMBER),a0
	move	@PUCK_CONTROL,a1,W
	jrz	drone_nobodys_puck
	cmp	a0,a1
	jrz	drone_we_have_puck
	move	a0,a14
	dec	a14
	dec	a1
	sra	2,a14
	sra	2,a1
	cmp	a14,a1
	jrz	drone_team_has_puck
	jruc	drone_opponents_puck

drone_we_have_puck
	clr	a14
	move	a14,*a6(POF_DRONE_MEANNESS),W
	move	a14,*a6(POF_DRONE_MEANSTATE),W
	callr	are_we_signalled
	move	a1,a1
	jrz	dwh1
	cmpi	1,a1
	jrz	ndrone_pass_puck
	cmpi	2,a1
	jrz	ndrone_shoot_puck
dwh1	callr	get_time_left
	jrnc	ndrone_shoot_puck_most
	callr	get_our_zone
	cmpi	2,a1
	jrz	dw_az		;in attack zone
	callr	maybe_pick_pass
	callr	get_safe_teammates_alt_z
	jruc	move_forward_to_z
dw_az	callr	are_we_from_outside	;(or is pattern over)
	jrnc	dw_nos
	calla	maybe_pick_pass_shoot_os
	jruc	pick_or_run_pattern
dw_nos	calla	maybe_pick_pass_shoot
	jruc	drone_set_up_shot

drone_team_has_puck
	clr	a14
	move	a14,*a6(POF_DRONE_MEANNESS),W
	move	a14,*a6(POF_DRONE_MEANSTATE),W
	move	@PUCK_CONTROL,a1,W
	cmpi	4,a1
	jrz	drone_goalie_has_puck
	cmpi	8,a1
	jrz	drone_goalie_has_puck
	callr	get_our_zone
	cmpi	2,a1
	jrz	dth_az			;attack zone
	callr	get_safe_teammates_alt_z
	jruc	move_forward_to_z_kx
dth_az	callr	are_we_from_outside	;(or is pattern over)
	jrnc	dthnos
	jruc	pick_or_run_pattern
dthnos	callr	is_enemy_close_checkable
	jrc	check_enemy
	jruc	move_base_teammate

drone_goalie_has_puck
	callr	are_we_open
	jrnc	dg_no			;not open
	calla	get_our_human_stats
	jrnz	icc2
	callr	get_our_zone
	cmpi	2,a1
	jaz	signal_to_pass
icc1	callr	is_enemy_close_checkable
	jrc	check_enemy
	calla	get_our_human_stats
	jrnz	icc2
	callr	are_we_moving_forward
	jac	signal_to_pass
icc2	callr	get_safe_teammates_alt_z
	jruc	move_forward_to_z_kx
dg_no	callr	is_enemy_close_checkable
	jrc	check_enemy
	callr	get_our_zone
	cmpi	2,a1
	jrz	move_away_from_closest_enemy
	callr	get_safe_teammates_alt_z
	jruc	move_forward_to_z_kx

drone_nobodys_puck
	move	@PUCK_MODE,a1,W
	movi	dnpl1,a2
dnp_1	move	*a2+,a14,W
	jrn	dnp_open
	cmp	a14,a1
	jrnz	dnp_2
	move	*a2,a2,L
	jump	a2
dnp_2	addk	32,a2
	jruc	dnp_1

dnpl1	WL	PUM_OPEN,dnp_open
	WL	PUM_PASS,dnp_pass
	WL	PUM_TPASS,dnp_pass
	WL	PUM_SHOT,dnp_shot
	WL	PUM_SSHOT,dnp_shot
	WL	PUM_ONETIME,dnp_shot
	WL	PUM_DUMP,dnp_open
	WL	PUM_SCORE,dnp_to_center
	WL	PUM_ENDPER,dnp_to_center
	.word	-1

dnp_to_center
	clr	a0
	movi	339,a1
	movi	500,a4
	movi	DUMRETS,a5
	jruc	move_range_stop_face

dnp_stop
	jauc	stop_player

dnp_open
	callr	get_other_human_stats
	cmpi	1,a1			;any humans?
	jrhs	po_ah
	callr	are_enemies_closer_to_puck
	jrc	po_ec			;enemies are closer than us
	callr	are_we_closer_to_puck	;is our teammate closer?
	jrc	seek_out_puck		;go get the puck
	callr	is_enemy_close_checkable
	jrc	check_enemy
	callr	get_puck_otime
	jrnc	move_base_teammate
	jruc	seek_out_puck
po_ec	callr	is_enemy_close_checkable
	jrc	check_enemy
	callr	pick_our_man
	jruc	seek_out_our_man_d
po_ah	callr	are_we_closer_to_puck
	jrnc	nsa
	move	*a6(POF_DRONE_LEVEL),a14,W
	cmpi	2,a1
	jrls	nsa2		;drone level 0-2, delay on all puck chases
	jruc	seek_out_puck
nsa	callr	is_enemy_close_checkable
	jrc	check_enemy
nsa2	callr	get_puck_otime
	jrnc	move_base_teammate
	jruc	seek_out_puck

dnp_pass
	move	@PUCK_INTENDED,a1,W
	cmp	a1,a0
	jrz	dm_tous 	;it is passed to us
	move	a0,a14
	dec	a1
	srl	2,a1
	dec	a14
	srl	2,a14
	cmp	a1,a14
	jrz	dm_totm 	;it is passed to our teammate
dm_toen callr	is_enemy_close_checkable
	jrc	check_enemy
	callr	can_we_intercept_pass
	jrc	block_pass
	callr	pick_our_man
	jruc	seek_out_our_man_d
dm_tous callr	are_we_signalled
	cmpi	2,a1
	jrz	prepare_for_onetimer
	callr	are_we_in_shot_position 	;enable this on drone only team
	jrc	prepare_for_onetimer
	jruc	prepare_for_no_onetimer
dm_totm jruc	move_base_teammate

dnp_shot
	move	@PUCK_LAST_CONTROL,a1,W
	move	a0,a14
	dec	a14
	srl	2,a14
	dec	a1
	srl	2,a1
	cmp	a1,a14
	jrz	dnp_os		;our teams shot
	callr	can_we_intercept_shot
	jrc	intercept_shot
	callr	is_enemy_close_checkable
	jrc	check_enemy
	callr	are_we_near_our_goal
	jrc	position_for_rebound
	callr	pick_our_man
	jruc	seek_out_our_man_d
dnp_os	callr	is_enemy_close_checkable
	jrc	check_enemy
	jruc	position_for_rebound

drone_opponents_puck
	callr	pick_our_man
	move	@PUCK_CONTROL,a14
	cmp	a3,a14
	jrz	do_om			;our man has puck
	mmtm	sp,a3
	callr	is_enemy_close_checkable
	mmfm	sp,a14
	jrc	check_enemy
	move	a14,a3
	callr	get_our_mans_zone
	cmpi	2,a1
	jrz	dop_1			;our man is in attack zone
	callr	are_we_mean
	jrc	seek_out_our_man
	jruc	match_posdir_our_man
dop_1	callr	are_we_mean
	jrc	seek_out_our_man
	;callr	is_our_man_behind_net
	;jrc	seek_out_our_man_d
	callr	is_other_man_shooting
	jrnc	seek_out_our_man_d
	callr	can_we_get_in_way
	jrc	get_in_way
	jruc	position_for_rebound
do_om	mmtm	sp,a3
	callr	is_enemy_close_checkable
	mmfm	sp,a14
	jrc	check_enemy
	move	a14,a3
	callr	get_our_mans_zone
	cmpi	2,a1
	jrz	dop_2			;our man is in attack zone
	callr	is_enemy_on_screen
	jrnc	seek_out_our_man_d
	callr	are_we_mean
	jrc	seek_out_our_man
	jruc	match_posdir_our_man
dop_2	callr	are_we_mean
	jrc	seek_out_our_man
	callr	is_our_man_behind_net
	jrnc	dop_3
	callr	has_he_behind_awhile
	jrc	seek_out_our_man_d
	jruc	match_safe_position_of_our_man
	move	*a7(POF_MODE),a14,W
	cmpi	PM_PASS,a14
	jrc	dop_3			;he is passing
	cmpi	PM_SHOOT,a14
	jrc	dop_3			;he is shooting
	jruc	seek_out_our_man_d
dop_3	callr	can_we_get_in_way
	jrc	get_in_way
	jruc	seek_out_our_man_d

get_safe_teammates_alt_z
	callr	get_teammates_alt_z
	callr	does_z_approach_enemy
	jrc	pick_z_to_avoid_enemy
	rets
get_teammates_alt_z
	callr	get_teammates_z
get_alt_z
	move	a1,a2
	cmpi	339,a1
	jrls	ga1
	subi	339*2,a1
ga1	addi	339,a1		;a1 is our corresponding opposite z
	cmpi	30,a1
	jrgt	ga2
	movk	30,a1
ga2	cmpi	649,a1
	jrlt	ga3
	movi	649,a1
ga3	rets

pick_or_run_pattern
	callr	have_we_picked_pattern
	jrc	por2
	callr	pick_offensive_pattern
por2	jruc	run_offensive_pattern

are_enemies_closer_to_puck	;check for much closer
	move	a0,a14
	dec	a14
	srl	2,a14
	subk	1,a14
	abs	a14
	sll	2,a14
	inc	a14		;a14 is now 1st of other team
	GBLOCK	a14,a14
	move	*a14(POF_D_PUCK),a2,W
	move	*a14(PLAYER_BLOCK_SIZE+POF_D_PUCK),a4,W
	move	*a14((3*PLAYER_BLOCK_SIZE)+POF_FLAGS),a5,W
	btst	B_PF_GOALIE,a5
	jrz	aexc1
	movi	30000,a5
	jruc	aexc2
aexc1	move	*a14((3*PLAYER_BLOCK_SIZE)+POF_D_PUCK),a5,W
aexc2	move	*a6(POF_D_PUCK),a14,W
	addi	60,a2
	addi	60,a4
	addi	60,a5
	cmp	a2,a14
	jrhi	aecpy
	cmp	a4,a14
	jrhi	aecpy
	cmp	a5,a14
	jrhi	aecpy
	clrc
	rets
aecpy	setc
	rets

are_we_closer_to_puck
	move	a0,a14
	dec	a14
	srl	2,a14
	sll	2,a14
	inc	a14		;a14 is now 1st of our team
	GBLOCK	a14,a14
	move	*a14(POF_D_PUCK),a2,W
	move	*a14(PLAYER_BLOCK_SIZE+POF_D_PUCK),a4,W
	move	*a14((2*PLAYER_BLOCK_SIZE)+POF_FLAGS),a5,W
	btst	B_PF_GOALIE,a5
	jrz	bexc1
	movi	30000,a5
	jruc	bexc2
bexc1	move	*a14((2*PLAYER_BLOCK_SIZE)+POF_D_PUCK),a5,W
bexc2	move	*a6(POF_D_PUCK),a14,W
	addi	60,a2		;these adds
	addi	60,a4		;will ensure our check to ourselves
	addi	60,a5		;doesn't fuck us up
	cmp	a2,a14
	jrhi	becpy
	cmp	a4,a14
	jrhi	becpy
	cmp	a5,a14
	jrhi	becpy
	clrc
	rets
becpy	setc
	rets

are_we_moving_forward
	move	*a8(OXVEL),a2,L
	move	a0,a14
	dec	a14
	sra	2,a14
	jrz	awm1
	neg	a2
awm1	move	a2,a2
	jrp	awmy
	clrc
	rets
awmy	setc
	rets

is_enemy_close_checkable
	callr	are_we_close_to_enemy		;returns a3
	jrnc	ieccn
	callr	is_enemy_on_screen
	jrnc	ieccn
	callr	are_we_ready_to_check
	jrc	ieccy
ieccn	clrc		;redundant
	rets
ieccy	setc
	rets

is_enemy_on_screen
	GBLOCK	a3,a14
	move	*a14(POF_OBJECT),a14,L
	move	*a14(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrnz	ieos_n
	setc
	rets
ieos_n	clrc
	rets

are_we_close_to_enemy
	move	a0,a4
	dec	a4
	srl	2,a4
	neg	a4
	inc	a4
	move	a4,a7
	sll	2,a7
	inc	a7
	sll	6,a4
	addi	POF_D_1P,a4
	movk	2,a2
	movi	600,a5
	add	a6,a4
amnc	move	*a4+,a14,W
	cmp	a5,a14
	jrhs	choad
	move	a14,a5
	move	a7,a3
choad	inc	a7
	dsjs	a2,amnc
	inc	a7
	GBLOCK	a7,a7
	move	*a7(POF_FLAGS),a7
	btst	B_PF_GOALIE,a7
	jrnz	chod2
	addk	16,a4
	move	*a4+,a14,W
	cmp	a5,a14
	jrhs	chod2
	move	a14,a5
	move	a7,a3
chod2	cmpi	100,a5
	jrlt	awcy
	clrc
	rets
awcy	setc
	rets

get_our_mans_zone
	GBLOCK	a3,a14
	move	*a14(POF_OBJECT),a14,L
	move	*a14(OXVAL),a2,L
	neg	a2			;we check using us, we want it useing them
	jruc	goz_v
get_our_zone
	move	*a8(OXVAL),a2,L
	callr	goz_v
	cmpi	2,a1
	jrz	goz_z
	movk	1,a14
	move	a14,*a6(POF_DRONE_OUTSIDE),W
	clr	a14
	move	a14,*a6(POF_DRONE_PATTERN),W
goz_z	rets

goz_v	addi	08000h,a2
	sra	16,a2
	move	a0,a14
	dec	a14
	sra	2,a14
	jrz	goz1
	neg	a2
goz1	movk	2,a1
	cmpi	233,a2
	jrgt	goz_8
	movk	1,a1
	cmpi	-233,a2
	jrgt	goz_8
	clr	a1
goz_8	rets

check_enemy
	move	@WAVEIRQS,a14,L
	move	a14,*a6(POF_DRONE_CTIME),L
	GBLOCK	a3,a7
	move	*a7(POF_OBJECT),a9,L
	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point_18
	movb	a0,*a6(POF_DIRECTION)
	jauc	skater_push

get_teammates_z
	cmpi	4,a0
	jrz	gtz_g1
	cmpi	8,a0
	jrz	gtz_g2
	move	a0,a14
gtz_2	dec	a14
	xori	1,a14
	inc	a14
	GBLOCK	a14,a14
	move	*a14(POF_OBJECT),a14,L
	move	*a14(OZPOS),a1,W
	move	*a14(OXVAL),a14,L
	move	a14,@drone_temp_1,L
	rets
gtz_g1	movk	1,a14
	jruc	gtz_2
gtz_g2	movk	5,a14
	jruc	gtz_2

pick_our_man
	cmpi	4,a0
	jrz	pom_g
	cmpi	8,a0
	jrnz	pom_ng
pom_g	move	a0,a14
	subk	3,a14
	jruc	pom_a
pom_ng	move	a0,a14
pom_a	move	a14,a4
	dec	a14
	xori	1,a14
	inc	a14		;our teammate
	GBLOCK	a14,a14
	dec	a4
	srl	2,a4
	neg	a4
	inc	a4		;0/1 of other team
	move	a4,a5
	sll	6,a4
	addi	POF_D_1P,a4
	add	a14,a4		;a4 = start of distance blocks for our teammates enemy
	movk	1,a1
	move	*a4,a14,W
	move	*a4(10h),a2,W
	cmp	a14,a2
	jrlt	pom_1
	move	a14,a2
	movk	2,a1
pom_1	sll	2,a5
	addk	4,a5		;other teams goalie
	GBLOCK	a5,a5
	move	*a5(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	pom_2
	move	*a4(30h),a14,W
	cmp	a14,a2
	jrlt	pom_2
	movk	4,a1
pom_2	cmpi	4,a0
	jrhi	pom_3
	addk	4,a1		;other team
pom_3	move	a1,a3
	rets

are_we_near_our_goal
	move	*a8(OXVAL),a2,L
	addi	08000h,a2
	sra	16,a2
	cmpi	4,a0
	jrls	awng1
	neg	a2
awng1	cmpi	250,a2
	jrlt	awngn
	mmtm	sp,a0
	move	a2,a0
	move	*a8(OZPOS),a1,W
	movi	688,a2
	movi	339,a3
	calla	find_dist_quick
	mmfm	sp,a0
	cmpi	300,a4
	jrhs	awngn
	setc
	rets
awngn	clrc
	rets

are_we_open
	callr	are_we_close_to_enemy
	jrc	awon
	setc
	rets
awon	clrc
	rets

are_we_signalled
	clr	a1
	move	a0,a2
	dec	a2
	srl	2,a2
	sll	2,a2
	inc	a2
	callr	csig
	inc	a2
;	callr	csig
;	addk	2,a2
csig	cmp	a2,a0
	jrz	csg9
	cmpi	2,a1
	jrz	csg9
	GBLOCK	a2,a4
	move	*a4(POF_FLAGS),a14,W
	btst	B_PF_SIG_PASS,a14
	jrnz	cs_2
	btst	B_PF_SIG_SHOOT,a14
	jrnz	cs_3
	move	@PUCK_LAST_CONTROL,a14,W
	jrz	csg9
;	GBLOCK	a4,a4
	move	*a4(POF_BUTTONS),a14,W
	btst	0,a14
	jrnz	cs_3			;read button state for who just passed to us
csg9	rets
cs_2	movk	1,a1
	rets
cs_3	movk	2,a1
	rets

get_time_left
	move	@minutes,a14,W
	jrnz	gtl_y
	move	@tenseconds,a14,W
	jrnz	gtl_y
	move	@seconds,a14,W
	cmpi	3,a14
	jrhs	gtl_y
	clrc
	rets
gtl_y	setc
	rets

get_other_human_stats
	clr	a1
	move	a0,a14
	dec	a14
	srl	2,a14
	subk	1,a14
	abs	a14
	sll	2,a14
	inc	a14		;a14 is now 1st of other team
	GBLOCK	a14,a2
	move	*a2(POF_FLAGS),a4,W
	btst	B_PF_HUMAN,a4
	jrz	gohs1
	inc	a1
gohs1	inc	a14		;a14 is now 1st of other team
	GBLOCK	a14,a2
	move	*a2(POF_FLAGS),a4,W
	btst	B_PF_HUMAN,a4
	jrz	gohs2
	inc	a1
gohs2	rets

is_other_man_shooting
	move	@PUCK_CONTROL,a14,W
	GBLOCK	a14,a14
	move	*a14(POF_MODE),a14,W
	cmpi	PM_SHOOT,a14
	jrz	ioms_t
	clrc
	rets
ioms_t	setc
	rets

seek_out_puck			;level 1-4 slow, level 8-10 fast, level 4-7 fast in 2,3,ot
	mmtm	sp,a0
	move	@PUCK_OBJECT,a9,L
	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L

	callr	adjust_for_safe_move

	calla	find_dir_to_point
	clr	a1
	move	*a6(POF_DRONE_LEVEL),a14,W
	cmpi	4,a14
	jrls	alslo
	cmpi	8,a14
	jrhs	alsf
	move	@period,a14,W
	cmpi	1,a14
	jrz	alslo
alsf	movk	1,a1
alslo	calla	move_player_dir
	mmfm	sp,a0
	rets

seek_out_our_man_d
	mmtm	sp,a0,a3
	GBLOCK	a3,a7
	move	*a7(POF_OBJECT),a9,L
	move	*a9(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
	move	*a9(OZPOS),a1,W
	movi	160,a4
	movi	DUMRETS,a5
	callr	move_range_stop_face
	mmfm	sp,a0,a3
	rets

seek_out_our_man
	mmtm	sp,a0,a3
	GBLOCK	a3,a7
	move	*a7(POF_OBJECT),a9,L
	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	callr	adjust_for_safe_move
	calla	find_dir_to_point
	clr	a1
	calla	move_player_dir
	mmfm	sp,a0,a3
	rets

is_our_man_behind_net
	GBLOCK	a3,a7
	move	*a7(POF_OBJECT),a9,L
	move	*a9(OXVAL),a1,L
	addi	08000h,a1
	move	a3,a14
	dec	a14
	sra	2,a14
	jrnz	iomb1
	neg	a1
iomb1	cmpi	688,a1
	jrlt	iombn
iomby	move	*a7(POF_DRONE_NETTIME),a14,W
	inc	a14
	move	a14,*a7(POF_DRONE_NETTIME),W
	setc
	rets
iombn	clr	a14
	move	a14,*a7(POF_DRONE_NETTIME),W
	clrc
	rets

prepare_for_onetimer
	mmtm	sp,a0
	movk	1,a14
	move	a14,*a6(POF_DRONE_BUTTONS),W
	calla	line_up_for_pass
	mmfm	sp,a0
	rets

prepare_for_no_onetimer
	mmtm	sp,a0
	clr	a14
	move	a14,*a6(POF_DRONE_BUTTONS),W
	calla	line_up_for_pass
	mmfm	sp,a0
	rets

position_for_rebound
	mmtm	sp,a0
	move	@PUCK_LAST_CONTROL,a1,W
	movi	[688,0],a0
	dec	a1
	srl	2,a1
	jrz	pfr1
	neg	a0
pfr1	movi	[339,0],a1
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point
	clr	a1
	calla	move_player_dir
	mmfm	sp,a0
	rets

get_puck_otime
	calla	get_our_human_stats
	jrnz	gpo_y		;chase down if we have a teammate
	move	@GAME_STATE,a14,W
	cmpi	INAMODE,a14
	jrz	gpo_y		;chase down if attract mode
	move	@PUCK_CONTROL_START,a2,L
	move	@WAVEIRQS,a14,L
	sub	a2,a14
	move	*a6(POF_DRONE_LEVEL),a2,W
	cmpi	2,a2
	jrls	gpol		;drone level 0-2, delay on puck chases
	cmpi	7,a2
	jrlt	gpon		;drone level 3-6, regular delay
gpon	movi	2,a2		;drone level 7-10, chase down all
	jruc	gpoi
gpol	movi	400,a2
	jruc	gpoi
gpor	movi	100,a2		;regular time
gpoi	cmp	a2,a14
	jrls	gpo_n
gpo_y	setc
	rets
gpo_n	clrc
	rets

has_he_behind_awhile
	GBLOCK	a3,a7
	move	*a7(POF_DRONE_NETTIME),a14,W
	cmpi	300,a14
	jrls	hhbn
hhby	setc
	rets
hhbn	clrc
	rets

match_safe_position_of_our_man
match_posdir_our_man
	mmtm	sp,a0,a3
	GBLOCK	a3,a7
	move	*a7(POF_OBJECT),a9,L
	move	*a9(OXVAL),a0,L
	movi	[130,0],a1
	move	*a6(POF_DRONE_LEVEL),a14,W
	cmpi	3,a14
	jrhi	mpodx1
	movi	[220,0],a1	;drone level 0-3, greater distance
	jruc	mpodxx
mpodx1	cmpi	10,a14
;	jrnz	mpodxx
	jrlo	mpodxx
	movi	[100,0],a1	;drone level 10, tighten distance when following
	cmpi	11,a14
	jrlo	mpodxx
	movi	[65,0],a1	;level 11
	cmpi	12,a14
	jrlo	mpodxx
	movi	[20,0],a1	;level 12
mpodxx	cmpi	4,a3
	jrls	mpom1
	neg	a1
mpom1	add	a1,a0		;a0 is x desired
	move	*a9(OZVAL),a1,L ;a1 is z desired
	move	*a8(OXVAL),a2,L ;our x
	move	*a8(OZVAL),a3,L ;our z
	mmtm	sp,a0,a1
	calla	find_dist_quick
	mmfm	sp,a0,a1
	move	*a6(POF_DRONE_LEVEL),a14,W
	cmpi	3,a14
	jrhi	mpomu1
	cmpi	[70,0],a4
	jruc	mpomu2
mpomu1	cmpi	[45,0],a4
mpomu2	jrls	mpom_m
	calla	find_dir_to_point
	clr	a1
	move	*a6(POF_DRONE_LEVEL),a14,W
	cmpi	10,a14
	jrls	mjsd
	movk	1,a1		;drone 11 or 12 is always fast when far away
mjsd	calla	move_player_dir
	mmfm	sp,a0,a3
	rets
mpom_m	move	*a9(ODT_VEL),a0,L
	jrz	mpom_a
	move	*a9(ODT_DIR),a0,L
	clr	a1
	calla	move_player_dir
	mmfm	sp,a0,a3
	rets
mpom_a	calla	stop_player
	move	*a8(ODT_VEL),a0,L
	jrnz	mpoma9
	callr	face_37
mpoma9	mmfm	sp,a0,a3
	rets

move_forward_to_z_kx
	mmtm	sp,a0,a3
	move	@drone_temp_1,a14,L
	addi	[0,08000h],a14
	sra	16,a14
	movi	180,a3
	cmpi	4,a0
	jrls	mkxz1
	neg	a3
mkxz1	add	a14,a3
	move	a3,a0
	movi	25,a4
	movi	DUMRETS,a5
	callr	move_range_stop_face
	mmfm	sp,a0,a3
	rets

move_forward_to_z
	mmtm	sp,a0,a3
	movi	687,a3
	cmpi	4,a0
	jrls	mftz1
	neg	a3
mftz1	move	a3,a0

	movi	25,a4
	movi	DUMRETS,a5
	callr	move_range_stop_face
	mmfm	sp,a0,a3
	rets

move_base_teammate
	mmtm	sp,a0,a3
	cmpi	4,a0
	jrnz	mbt1
	movk	1,a0
	jruc	mbt3
mbt1	cmpi	8,a0
	jrnz	mbt3
	movk	4,a0
mbt3	dec	a0
	xori	1,a0
	inc	a0
	GBLOCK	a0,a5
	move	*a5(POF_OBJECT),a5,L
	move	*a5(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
	move	*a5(OZPOS),a1,W
	callr	get_dest_point
	movk	25,a4
	movi	face_37,a5
	callr	move_range_stop_face
	move	*a6(POF_DRONE_OP_TIME),a14,L
	move	@WAVEIRQS,a0,L
	sub	a14,a0
	cmpi	240,a0
	jrls	mbt99
	movi	10,a0
	calla	RANDPER
	jrnc	mbt99
	clr	a0
	move	*a6(POF_DRONE_OP_STATE),a14,W
	jrnz	mbt_67
	inc	a0
mbt_67	move	a0,*a6(POF_DRONE_OP_STATE),W
mbt99	mmfm	sp,a0,a3
	rets

face_37 movk	3,a0
	movb	*a6(POF_NUMBER),a14
	cmpi	4,a14
	jrls	f372
	movk	7,a0
f372	movb	a0,*a6(POF_DIRECTION)
	rets

;if we are behind front of net
; if destination is in front of net
;  if we are on same z side as destination
;   * move normally
;  if we are directly behind znet
;   * move to our x, z closest to our destination
;  if destination is directly in front of znet
;   * move to destination x, our z
;  else (destination is on opposite z)
;   * move to destination x, our z
; else (destination is behind front of net)
;  if we are on same z side as destination
;   * move normally
;  if we are directly behind znet
;   * move normally
;  if destination is directly behind znet
;   * move normally
;  else (destination is on opposize z from us)
;   * move to destination z, x behind center znet
;else (we are in front of net)
; if destination is behind front of net
;  if we are on same z side as destination
;   * move normally
;  if we are directly in front of znet
;   * move to our x, z closest to our destination
;  if destination is directly behind znet
;   * move to destination x, our z
;  else (destination is on opposite z)
;   * move to destination x, our z
; else (destination is front of net)
;  * move normally

adjust_for_safe_move
	callr	are_we_in_front_net
	jrc	nbhn1				;not behind net
	callr	is_destination_in_front_net
	jrnc	bhndhn				;were behind, destination behind
	callr	are_z_matching
	jrc	mnormal 			;we are on matching z, ok to move
	callr	are_we_znet
	jrc	move_our_x_close_z		;we are behind z of net
	jruc	move_dest_x_our_z		;destination is in front of z net, of opposite z
bhndhn	callr	are_z_matching
	jrc	mnormal
	callr	are_we_znet
	jrc	mnormal
	callr	is_dest_znet
	jrc	mnormal
	jruc	move_back_x_dest_z
nbhn1	callr	is_destination_in_front_net
	jrc	mnormal
	callr	are_z_matching
	jrc	mnormal
	callr	are_we_znet
	jrc	move_our_x_close_z
	jruc	move_dest_x_our_z		;destination is behind znet or opposite z

are_we_znet
	cmpi	[261,0],a3
	jrlt	awzn
	cmpi	[418,0],a3
	jrgt	awzn
	setc
	rets
awzn	clrc
	rets

is_dest_znet
	cmpi	[261,0],a1
	jrlt	idzn
	cmpi	[418,0],a1
	jrgt	idzn
	setc
	rets
idzn	clrc
	rets

are_z_matching
	cmpi	[261,0],a1
	jrlt	azml
	cmpi	[418,0],a1
	jrle	azmn
	cmpi	[418,0],a3
	jrgt	azmy
	jruc	azmn
azml	cmpi	[261,0],a3
	jrge	azmn
azmy	setc
	rets
azmn	clrc
	rets

are_we_in_front_net
	move	a2,a14
	jruc	idf1
is_destination_in_front_net
	move	a0,a14
idf1	abs	a14
	cmpi	[688,0],a14
	jrlt	idfy
	clrc
	rets
idfy	setc
	rets

move_our_x_close_z
	movi	[679,0],a14
	cmpi	[339,0],a1
	jrgt	tgt1
	clr	a14
tgt1	move	a14,a1
	move	a2,a0
	jruc	mnormal
move_dest_x_our_z
	move	a3,a1
	jruc	mnormal
move_back_x_dest_z
	movi	[750,0],a14
	move	a2,a2
	jrnn	mbx1
	neg	a14
mbx1	move	a14,a2
move_our_x_dest_z
	move	a2,a0
mnormal rets

**************************************************************************
*									 *
* move_range_stop_face							 *
*									 *
**************************************************************************
move_range_stop_face
	sll	16,a4
	sll	16,a0
	sll	16,a1
	move	*a8(OXVAL),a2,L
	addi	[0,08000h],a2
	move	*a8(OZVAL),a3,L
	callr	adjust_for_safe_move
	calla	find_dirdis_to_point
	cmp	a4,a1
	jrls	mrs_stp
	move	@hot_player,a2,W
	movb	*a6(POF_NUMBER),a14
	cmp	a2,a14
	jrz	msgaf		;he is on fire, always turbo
	move	*a6(POF_DRONE_LEVEL),a14,W
	cmpi	8,a14
	jrhs	msgaf		;level 8-10 always turbo
	sll	1,a4
	cmp	a4,a1
	jrls	mgs
	move	*a6(POF_DRONE_LEVEL),a1,W
	cmpi	1,a1
	jrls	mgs		;drone level 0-1, only go slow
msgaf	movk	1,a1
	jruc	mgs1
mgs	clr	a1
mgs1	calla	move_player_dir
	clrc
	rets
mrs_stp calla	stop_player
	move	*a8(ODT_VEL),a14,L
	jrnz	mrsf1
	call	a5
mrsf1	setc
	rets

move_away_from_closest_enemy
	mmtm	sp,a0
	GBLOCK	a3,a7
	move	*a7(POF_OBJECT),a9,L
	move	*a9(OXVAL),a2,L
	move	*a9(OZVAL),a3,L
	move	*a8(OXVAL),a0,L
	move	*a8(OZVAL),a1,L 	;we reverse our normal order
	calla	find_dir_to_point
	clr	a1
	calla	move_player_dir
	mmfm	sp,a0
	rets

does_z_approach_enemy
	mmtm	sp,a3,a7
	movb	*a6(POF_NUMBER),a3
	dec	a3
	srl	2,a3
	dec	a3
	neg	a3
	sll	2,a3
	inc	a3
	callr	dzae1
	jrc	dzae5
	inc	a3
	callr	dzae1
	jrc	dzae5
	inc	a3
	callr	dzae1
dzae5	mmfm	sp,a3,a7
	rets
dzae1	GBLOCK	a3,a7
	move	*a7(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	dzanc
	move	*a7(POF_OBJECT),a9,L
	move	*a9(OZPOS),a7,L
	sub	a1,a7
	abs	a7
	cmpi	60,a7
	jrls	dey
dzanc	clrc
	rets
dey	setc
	rets

pick_z_to_avoid_enemy
	move	a1,a7
	addi	100,a1
	callr	pzt
	jrnc	pzta9
	move	a7,a1
	subi	100,a1
	callr	pzt
	jrnc	pzta9
	move	a7,a1
	addi	200,a1
	callr	pzt
	jrnc	pzta9
	move	a7,a1
	subi	200,a1
	callr	pzt
	jrnz	pzta9
	move	a7,a1
pzta9	rets
pzt	cmpi	660,a1
	jrlt	pzt1
	movi	660,a1
	jruc	pzt3
pzt1	cmpi	20,a1
	jrgt	pzt3
	movk	20,a1
pzt3	jruc	does_z_approach_enemy

block_pass		;
get_in_way		;unimplemented
intercept_shot		;
	rets

are_we_from_outside
	move	*a6(POF_DRONE_OUTSIDE),a14,W
	jrz	awf_n
	move	@global_control_slow,a14,L
	jrnz	awf_n
awf_y	setc
	rets
awf_n	clrc
	rets

have_we_picked_pattern
	move	*a6(POF_DRONE_PATTERN),a14,W
	jrz	hwppn
hwppy	setc
	rets
hwppn	clrc
	rets

pick_offensive_pattern
	mmtm	sp,a0
	movk	10,a0
	calla	RANDU
	move	a0,*a6(POF_DRONE_PATTERN),W
	sll	5,a0
	addi	popl_a-32,a0
	move	*a0,a0,L
	move	a0,*a6(POF_DRONE_PADDR),L
	mmfm	sp,a0
	rets

popl_a	.long	pad_cut_to_right
	.long	pad_cut_to_left
	.long	pad_cut_wide_to_right
	.long	pad_cut_wide_to_left
	.long	pad_cut_across_right
	.long	pad_cut_across_left
	.long	pad_cut_around_right
	.long	pad_cut_around_left
	.long	pad_cut_spin_right
	.long	pad_cut_spin_left

pad_cut_to_right
	.word	377,164
	.word	522,286
	.word	522,393
	.word	500,494
	.word	600,579
	.word	780,479
	.word	780,229
	.word	530,99
	.word	380,279
	.word	0,0
pad_cut_to_left
	.word	377,515
	.word	522,393
	.word	522,286
	.word	500,185
	.word	600,100
	.word	780,200
	.word	780,450
	.word	530,580
	.word	380,400
	.word	0,0
pad_cut_wide_to_right
	.word	500,129
	.word	600,99
	.word	610,179
	.word	520,279
	.word	450,340
	.word	522,515
	.word	600,579
	.word	780,479
	.word	780,229
	.word	530,99
	.word	380,279
	.word	0,0
pad_cut_wide_to_left
	.word	500,550
	.word	600,580
	.word	610,500
	.word	520,400
	.word	450,339
	.word	522,164
	.word	600,100
	.word	780,200
	.word	780,450
	.word	530,580
	.word	380,400
	.word	0,0
pad_cut_across_right
	.word	500,164
	.word	430,264
	.word	500,364
	.word	430,464
	.word	500,564
	.word	0,0
pad_cut_across_left
	.word	500,515
	.word	430,415
	.word	500,315
	.word	430,215
	.word	500,115
	.word	0,0
pad_cut_around_right
	.word	500,229
	.word	580,129
	.word	700,164
	.word	760,515
	.word	522,639
	.word	377,639
	.word	0,0
pad_cut_around_left
	.word	500,450
	.word	580,550
	.word	700,515
	.word	760,164
	.word	522,40
	.word	377,40
	.word	0,0
pad_cut_spin_right
	.word	500,279
	.word	540,179
	.word	600,149
	.word	530,79
	.word	500,129
	.word	500,597
	.word	0,0
pad_cut_spin_left
	.word	500,400
	.word	540,500
	.word	600,530
	.word	530,600
	.word	500,550
	.word	500,82
	.word	0,0

run_offensive_pattern
	mmtm	sp,a0
	move	*a6(POF_DRONE_PADDR),a7,L
	move	*a7+,a14,W
	jrz	rop_9n
	cmpi	4,a0
	jrls	rop_1
	neg	a14
rop_1	move	a14,a0
	move	*a7+,a1,W
	move	*a6(POF_DRONECT),a14,W
	cmpi	10,a14
	jrhs	riop1
	movi	50,a4
	movi	DUMRETS,a5
	mmtm	sp,a7
	callr	move_range_stop_face
	mmfm	sp,a7
	jrnc	rop_9
riop1	move	a7,*a6(POF_DRONE_PADDR),L
	clr	a14
	move	a14,*a6(POF_DRONECT),W
rop_9	mmfm	sp,a0
	rets
rop_9n	clr	a14
	move	a14,*a6(POF_DRONE_PADDR),L
	move	a14,*a6(POF_DRONE_PATTERN),W
	move	a14,*a6(POF_DRONE_OUTSIDE),W
	mmfm	sp,a0
	rets

are_we_ready_to_check
	mmtm	sp,a0
	move	@PUCK_MODE,a14,W
	cmpi	PUM_FACEOFF,a14
	jrz	awtc_n
	move	*a6(POF_DRONE_LEVEL),a2,W
	jrnz	awrto1

	move	@PUCK_CONTROL,a14,W
	jrz	ddl_1nx
	move	@global_control_slow,a14,W
	jrnz	awrto1	;if we are slowing puck carrier down, drones can get mean
ddl_1nx callr	get_our_score_diff
	cmpi	-4,a2
	jrgt	awtc_n		;drone difficulty 0, not behind by 4, no check
awrto1	move	@WAVEIRQS,a0,L
	move	*a6(POF_DRONE_NO_CHECK),a14,L
	cmp	a0,a14
	jrhs	awtc_n		;do not check yet
	calla	are_we_mean
	jrc	awtcm
	move	*a6(POF_DRONE_CTIME),a2,L
	sub	a2,a0
	cmpi	120,a0
	jrls	awtc_n
	srl	2,a0
	move	*a6(POF_DRONE_LEVEL),a2,W
	cmpi	2,a2
	jrhi	awrto2		;drone level 0,1,2 - lower prob of check
	srl	2,a0
	jruc	awrtzg
awrto2	cmpi	9,a2
	jrlt	awrtzg
	sll	2,a0	;was 1	;level 9,10 drone - increase percentage
	cmpi	10,a2
	jrlt	awrtzg
	sll	2,a0		;level 10 drone, even more percentage
awrtzg	calla	RANDPER
	jrc	awtc_y
awtc_n	clrc
	mmfm	sp,a0
	rets
awtc_y	setc
	mmfm	sp,a0
	rets
awtcm	move	*a6(POF_DRONE_CTIME),a2,L
	move	@WAVEIRQS,a0,L
	sub	a2,a0

	movi	60,a14
	move	*a6(POF_DRONE_LEVEL),a2,W
	cmpi	11,a2
	jrlo	awcooo
	movi	30,a14		;half a second level 11
	cmpi	12,a2
	jrlo	awcooo
	movi	10,a14		;no time level 12
awcooo	cmp	a14,a0
;	cmpi	60,a0
	jrls	awtc_n
	srl	2,a0
	move	a0,a14
	srl	1,a14
	add	a14,a0
	calla	RANDPER
	jrc	awtc_y
	jruc	awtc_n

are_we_mean
	move	*a6(POF_DRONE_MEANSTATE),a14,W
	jrnz	awm_y
awm_n	clrc
	rets
awm_y	setc
	rets

are_we_in_shot_position
	mmtm	sp,a0
	move	*a8(OXVAL),a14,L
	cmpi	4,a0
	jrls	awisj
	neg	a14
awisj	cmpi	[750,0],a14
	jrgt	awisn
	cmpi	[223,0],a14
	jrlt	awisn
	calla	get_our_human_stats
	jrnz	awisn
	movi	140,a0
	calla	RANDPER 	;returns carry
	mmfm	sp,a0
	rets
awisn	clrc
	mmfm	sp,a0
	rets

can_we_get_in_way
can_we_intercept_pass
can_we_intercept_shot
	clrc
	rets

maybe_pick_pass
	mmtm	sp,a0
	move	a0,a1
	callr	get_pass_randper
	calla	RANDPER
	jrnc	mpq1
	move	a1,a0
	callr	is_teammate_much_behind
	jrc	mpq1
	callr	ndrone_pass_puck_most_safe
mpq1	mmfm	sp,a0
	rets
maybe_pick_pass_shoot_os
maybe_pick_pass_shoot
	mmtm	sp,a0
	move	a0,a1
	callr	get_pass_randper
	calla	RANDPER
	jrnc	mpps1
	move	a1,a0
	callr	is_teammate_much_behind
	jrc	mpps9
	callr	ndrone_pass_puck_most_safe
	jruc	mpps9
mpps1	callr	get_shoot_randper
	calla	RANDPER
	jrnc	mpps9
	callr	are_we_behind_net
	jrc	mpps9
	move	a1,a0
	callr	ndrone_shoot_puck_most_safe
mpps9	mmfm	sp,a0
	rets

are_we_behind_net
	mmtm	sp,a1
	move	*a8(OXVAL),a1,L
	addi	[0,08000h],a1
	movb	*a6(POF_NUMBER),a14
	dec	a14
	sra	2,a14
	jrz	awbh1
	neg	a1
awbh1	cmpi	[688,0],a1
	jrlt	awbhn
awbhy	setc
	mmfm	sp,a1
	rets
awbhn	clrc
	mmfm	sp,a1
	rets

get_shoot_randper
	move	*a6(POF_DRONE_LEVEL),a14,W
	cmpi	3,a14
	jrls	gsrl
	cmpi	7,a14
	jrls	gsrn
gsrh	movi	100,a0
	rets
gsrl	movi	48,a0
	rets
gsrn	movi	65,a0
	rets

get_pass_randper
	move	*a6(POF_DRONE_LEVEL),a14,W
	cmpi	8,a14
	jrls	gprpr
	callr	are_we_close_to_enemy
	jrnc	gprpr
	GBLOCK	a3,a14
	move	*a14(POF_MODE),a14,W
	cmpi	PM_STEAL,a14
	jrz	gprpy
	cmpi	PM_CROSSCHECK,a14
	jrz	gprpy
	cmpi	PM_HIGHSTICK,a14
	jrz	gprpy
	cmpi	PM_SLASH,a14
	jrz	gprpy
	cmpi	PM_SWING,a14
	jrz	gprpy
gprpr	movk	30,a0
	rets
gprpy	;movi	200,a0
	move	*a6(POF_DRONE_LEVEL),a14,W
	cmpi	10,a14
	jrls	ccgt
	movi	600,a0
	cmpi	11,a14
	jrls	ccgtx
	movi	800,a0
	jruc	ccgtx
ccgt	movi	400,a0	;sanssnas
ccgtx	rets

is_teammate_much_behind
	move	*a8(OXVAL),a4,L
	movb	*a6(POF_NUMBER),a14
	dec	a14
	xori	1,a14
	inc	a14
	GBLOCK	a14,a14
	move	*a14(POF_FLAGS),a5,W
	btst	B_PF_CONTROL,a5
	jrz	itmby9			;he is probably falling, don't pass to him
	move	*a14(POF_OBJECT),a14,L
	move	*a14(OXVAL),a5,L
	movb	*a6(POF_NUMBER),a14
	cmpi	4,a0
	jrls	itmb1
	neg	a4
	neg	a5
itmb1	cmpi	[233,0],a5
	jrgt	itmbn9
	addi	[140,0],a5
	cmp	a5,a4
	jrgt	itmby9
itmbn9	clrc
	rets
itmby9	setc
	rets

ndrone_pass_puck
ntpp1	movk	1,a1		;turbo on
	jauc	pass_puck
ndrone_shoot_puck
ntsp1	move	@WAVEIRQS,a14,L
	move	a14,*a6(POF_DRONE_STIME),L
	movk	1,a1		;turbo on
	jauc	shoot_puck
ndrone_shoot_puck_most_safe
	calla	get_our_human_stats
	jrnz	nspm9
ndrone_shoot_puck_most
	callr	puck_long_enough_s
	jrc	ntsp1
nspm9	rets
ndrone_pass_puck_most_safe
	calla	get_our_human_stats
	jrnz	nppm9
ndrone_pass_puck_most
	callr	puck_long_enough
	jrc	ntpp1
nppm9	rets

puck_long_enough_s
	mmtm	sp,a0
	move	@WAVEIRQS,a0,L
	move	*a6(POF_DRONE_STIME),a14,L
	sub	a14,a0
	cmpi	400,a0
	jrgt	hwh_y
	jruc	ple_1
	mmfm	sp,a0
	rets
puck_long_enough
	mmtm	sp,a0
ple_1	move	@WAVEIRQS,a0,L
	move	@PUCK_CONTROL_START,a14
	sub	a14,a0
	cmpi	20,a0
	jrlt	hwh_n
hwh_y	setc
	mmfm	sp,a0
	rets
hwh_n	clrc
	mmfm	sp,a0
	rets

**************************************************************************
*									 *
* get_dest_point							 *
*	input	a0 = teammate x 					 *
*		a1 = teammate z 					 *
*	output	a0 = new x						 *
*		a1 = new z						 *
*									 *
**************************************************************************
get_dest_point
	mmtm	sp,a9,a11
	move	a0,a0
	jrp	gdp_1		;positive x
	neg	a0
	cmpi	339,a1
	jrlt	gdp_2
	subi	679,a1		;negative x, high z
	neg	a1
	callr	gdp_a
	subi	679,a1
	neg	a1
	neg	a0
	jruc	gdp_9
gdp_2	callr	gdp_a		;negative x, low z
	neg	a0
	jruc	gdp_9
gdp_1	cmpi	339,a1
	jrlt	gdp_3
	subi	679,a1		;positive x, high z
	neg	a1
	callr	gdp_a
	subi	679,a1
	neg	a1
	jruc	gdp_9
gdp_3	callr	gdp_a		;positive_x, low z
gdp_9	mmfm	sp,a9,a11
	rets
gdp_a	move	a0,a11
	sll	16,a11
	cmpi	RGHT_GOALLINE_X>>16,a0
	jrgt	gdp_beh
	cmpi	522,a0
	jrgt	gdp_cls
gdp_far subi	RGHT_BLUELINE_X,a11
	movi	522-(RGHT_BLUELINE_X>>16),a9
	divs	a9,a11
	move	a11,a10
	move	a1,a11
	sll	16,a11
	movi	340,a9
	divs	a9,a11
	movi	ort_5,a9
	jruc	gdp_8
gdp_cls subi	[522,0],a11
	movi	(RGHT_GOALLINE_X>>16)-522,a9
	divs	a9,a11
	move	a11,a10
	move	a1,a11
	sll	16,a11
	movi	340,a9
	divs	a9,a11
	movi	ort_4,a9
	jruc	gdp_8
gdp_beh subi	RGHT_GOALLINE_X,a11
	movi	(RGHT_ENDBOARD_X-RGHT_GOALLINE_X)>>16,A9
	divs	a9,a11
	move	a11,a10
	move	a1,a11
	sll	16,a11
	cmpi	150,a1
	jrlt	gdp_bz1
	cmpi	220,a1
	jrlt	gdp_bz2
gdp_bz3 subi	[220,0],a11
	movi	340-220,a9
	divs	a9,a11
	movi	ort_3,a9
	jruc	gdp_8
gdp_bz2 subi	[150,0],a11
	movi	220-150,a9
	divs	a9,a11
	movi	ort_2,a9
	jruc	gdp_8
gdp_bz1 movi	150,a9
	divs	a9,a11
	movi	ort_1,a9
gdp_8	move	*a6(POF_DRONE_OP_STATE),a14,W
	jrz	get_pt_from_pct
	addi	OP_SIZE,a9
	jruc	get_pt_from_pct

OP_SIZE .set	128	;ort to prt size

ort_1	.word	430,319 	;x = goalline to endboard
	.word	430,359 	;z = bottom to 150
	.word	550,319
	.word	550,359
prt_1	.word	550,400 	;alternate set of points
	.word	350,400
	.word	550,660
	.word	350,660
ort_2	.word	390,500 	;x = goalline to endboard
	.word	390,250 	;z = 150 to 220
	.word	450,500
	.word	450,250
prt_2	.word	350,200 	;alternate set of points
	.word	600,200
	.word	350,600
	.word	600,600
ort_3	.word	390,250 	;x = goalline to endboard
	.word	470,100 	;z = 150 to 340
	.word	450,250
	.word	550,200
prt_3	.word	600,250 	;alternate set of points
	.word	600, 40
	.word	480,250
	.word	480, 40
prt_4	.word	550,360 	;alternate set of points
	.word	380,360
	.word	550,650
	.word	380,650
ort_4	.word	600,400 	;x = 522 to goalline
	.word	400,400 	;z = 0 to 340
	.word	650,440
	.word	500,520
ort_5	.word	630,420 	;x = blueline to 522
	.word	570,550 	;z = 0 to 340
	.word	430,300
	.word	380,500
prt_5	.word	550,360 	;alternate set of points
	.word	380,360
	.word	550,650
	.word	380,650

**************************************************************************
*									 *
* get_pt_from_pct							 *
*	input	a11 = pt0-pt1, pt2-pt3 %				 *
*		a10 = pt0-pt2, pt1-pt3 %				 *
*		a9 = table of pts					 *
*	output	a0 = new x						 *
*		a1 = new z						 *
*									 *
**************************************************************************
get_pt_from_pct
	mmtm	sp,a2,a3,a4,a5,a7,a9
	move	*a9+,a0,W
	move	*a9+,a2,W
	move	*a9+,a1,W
	move	*a9+,a3,W
	move	a11,a4
	callr	find_point_between
	mmtm	sp,a5,a7
	move	*a9+,a0,W
	move	*a9+,a2,W
	move	*a9+,a1,W
	move	*a9+,a3,W
	callr	find_point_between
	move	a5,a1
	move	a7,a3
	mmfm	sp,a0,a2
	move	a10,a4
	callr	find_point_between
	move	a5,a0
	move	a7,a1
	mmfm	sp,a2,a3,a4,a5,a7,a9
	rets

**************************************************************************
*									 *
* find_point_between							 *
*	input	a1 = x2 						 *
*		a3 = z2 						 *
*		a0 = x1 						 *
*		a2 = z1 						 *
*		a4 = s15:16 %						 *
*	output	a5 = new x						 *
*		a7 = new z						 *
*									 *
**************************************************************************
find_point_between
	mmtm	sp,a1,a3
	sub	a0,a1
	sub	a2,a3
	mpys	a4,a1
	sra	16,a1
	mpys	a4,a3
	sra	16,a3
	add	a0,a1
	add	a2,a3
	move	a1,a5
	move	a3,a7
	mmfm	sp,a1,a3
	rets

**************************************************************************
*									 *
* get_our_human_stats							 *
*	input	a0 = player number					 *
*	output	a2 = # humans on our team				 *
*		Z  = a2 state						 *
*									 *
**************************************************************************
get_our_human_stats
	move	a0,a14
	dec	a14
	srl	2,a14
	jrz	go_t1
go_t2	move	@PLAYER_BITS,a14,W
	srl	2,a14
	sll	4,a14
	addi	gnl,a14
	move	*a14,a2,W		;a2 is number of humans on our team
	rets
go_t1	move	@PLAYER_BITS,a14,W
	sll	30,a14
	srl	26,a14
	addi	gnl,a14
	move	*a14,a2,W		;a2 is number of humans on our team
	rets

gnl	.word	0,1,1,2

drone_set_up_shot
	move	*a6(POF_DRONEC),a0,W
	jrz	dss_4
	clr	a0
	move	a0,*a6(POF_DRONEC),W
	move	*a6(POF_DRONECT),a0,W
	inc	a0
	move	a0,*a6(POF_DRONECT),W
	cmpi	10,a0
	jrls	dss_4
	move	*a6(POF_DRONE1),a5,W
	move	a5,a7
	jruc	dssf

dss_4	move	*a8(OXVAL),a2,L
	addi	[0,08000h],a2
	sra	16,a2
	move	*a8(OZPOS),a3,W
dss1	move	*a6(POF_DRONE1),a0,W
	jrnz	dss2
	movk	9,a0
	move	a0,*a6(POF_DRONE2),W
	movk	8,a0
	move	a0,*a6(POF_DRONE1),W
	callr	grandp
	move	*a6(POF_DRONE1),a0,W
dss2	move	a0,a5
	move	a0,a7
	move	*a6(POF_DRONE_PX),a0,W
	move	*a6(POF_DRONE_PZ),a1,W
	callr	team_modify_xz
	calla	find_dist_quick
	cmpi	30,a4
	jrhi	dss_ny
dssf	clr	a0
	move	a0,*a6(POF_DRONEC),W
	move	a0,*a6(POF_DRONECT),W
	move	*a6(POF_DRONE_OM),a0,W
	jrz	dssf1
	dec	a0		;don't pass/shoot unless we have gone enough
	move	*a6(POF_DRONE1),a14,W
	cmpi	6,a14
	jrz	dssf0
	cmpi	8,a14		;if we hit points 6,8 or 12, we can always pass/shoot
	jrz	dssf0
	cmpi	12,a14
	jrnz	dssf2
dssf0	clr	a0
dssf2	move	a0,*a6(POF_DRONE_OM),W
dssf1	move	*a6(POF_DRONE2),a0,W
	sll	5,a0
	addi	trans_trans_table-32,a0
	move	*a0,a0,L
	sll	5,a5
	subk	32,a5
	add	a5,a0
	move	*a0,a0,L
	jrnz	ds_ne
	movk	16,a0
	calla	RANDU
	jruc	ds_n1a
ds_ne	move	a0,a5
	move	*a5+,a0,W
	calla	RAND0
ds_n1	sll	4,a0
	add	a5,a0
	move	*a0,a0,W
ds_n1a	move	a7,*a6(POF_DRONE2),W
	move	a0,*a6(POF_DRONE1),W
	callr	grandp
	jruc	dss1
dss_ny	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	move	*a6(POF_DRONE_PX),a0,W
	move	*a6(POF_DRONE_PZ),a1,W
	callr	team_modify_xz
	sll	16,a0
	sll	16,a1
	calla	find_dir_to_point
	clr	a1
	jauc	move_player_dir

grandp	sll	5,a0
	addi	trpos_list-32,a0
	move	*a0(16),a1,W
	move	*a0,a4,W
	movi	31,a0
	calla	RAND0
	subk	15,a0
	add	a0,a1
	movi	31,a0
	calla	RAND0
	subk	15,a0
	add	a4,a0
	move	a0,*a6(POF_DRONE_PX),W
	move	a1,*a6(POF_DRONE_PZ),W
	rets

trpos_list
	.word	522,597
	.word	377,597
	.word	688,515
	.word	377,515
	.word	764,427
	.word	605,427
	.word	764,339
	.word	620,339
	.word	470,339
	.word	377,339
	.word	764,251
	.word	605,251
	.word	688,164
	.word	377,164
	.word	522,82
	.word	377,82

trans_trans_table
	.long	one_trans_tab
	.long	two_trans_tab
	.long	three_trans_tab
	.long	four_trans_tab
	.long	five_trans_tab
	.long	six_trans_tab
	.long	seven_trans_tab
	.long	eight_trans_tab
	.long	nine_trans_tab
	.long	ten_trans_tab
	.long	eleven_trans_tab
	.long	twelve_trans_tab
	.long	thirteen_trans_tab
	.long	fourteen_trans_tab
	.long	fifteen_trans_tab
	.long	sixteen_trans_tab

one_trans_tab
	.long	0,t12,t13,t14,0,t16,0,0
	.long	t19,t110,0,0,0,0,0,0

t12	.word	2,4,10
t13	.word	2,5,6
t14	.word	2,9,10
t16	.word	4,5,8,9,10
t19	.word	5,8,12,14,15,16
t110	.word	3,12,14,15

two_trans_tab
	.long	t21,0,0,t24,0,t26,0,0
	.long	t29,t210,0,0,0,0,0,0

t21	.word	3,3,6,9
t24	.word	4,3,6,9,10
t26	.word	3,3,5,8
t29	.word	3,12,14,15
t210	.word	4,9,12,14,15

three_trans_tab
	.long	t31,0,0,t34,t35,t36,0,0
	.long	0,t310,0,0,0,0,0,0

t31	.word	3,2,4,10
t34	.word	2,2,10
t35	.word	1,7
t36	.word	5,2,4,8,9,10
t310	.word	1,14

four_trans_tab
	.long	t41,t42,t43,0,0,t46,0,0
	.long	t49,t410,0,0,0,0,0,0

t41	.word	1,3
t42	.word	1,1
t43	.word	1,5
t46	.word	3,3,5,8
t49	.word	5,8,12,14,15,16
t410	.word	4,9,12,14,15

five_trans_tab
	.long	0,0,t53,0,0,t56,t57,0
	.long	0,0,0,0,0,0,0,0

t53	.word	3,1,4,10
t56	.word	5,1,2,4,9,10
t57	.word	1,11

six_trans_tab
	.long	t61,t62,t63,t64,t65,0,0,t68
	.long	t69,t610,0,0,0,0,0,0

t61	.word	1,2
t62	.word	2,1,4
t63	.word	1,1
t64	.word	1,2
t65	.word	1,7
t68	.word	1,12
t69	.word	3,10,14,16
t610	.word	1,14

seven_trans_tab
	.long	0,0,0,0,t75,0,0,0
	.long	0,0,t711,0,0,0,0,0

t75	.word	2,3,6
t711	.word	1,12,13

eight_trans_tab
	.long	0,0,0,0,0,t86,0,0
	.long	t89,0,0,t812,0,0,0,0

t86	.word	4,1,2,3,4
t89	.word	5,2,4,10,14,16
t812	.word	4,13,14,15,16

nine_trans_tab
	.long	t91,t92,0,t94,0,t96,0,t98
	.long	0,t910,0,t912,0,t914,t915,t916

t91	.word	2,2,3
t92	.word	2,1,4
t94	.word	2,1,2
t96	.word	3,1,3,5
t98	.word	2,6,12
t910	.word	4,2,4,14,16
t912	.word	3,11,13,15
t914	.word	2,15,16
t915	.word	2,13,16
t916	.word	2,15,14

ten_trans_tab
	.long	t101,t102,t103,t104,0,t106,0,0
	.long	t109,0,0,t1012,0,t1014,t1015,0

t101	.word	2,2,3
t102	.word	1,1
t103	.word	1,5
t104	.word	3,1,2,3
t106	.word	3,1,3,5
t109	.word	5,1,6,8,12,15
t1012	.word	3,11,13,15
t1014	.word	3,13,15,16
t1015	.word	2,13,16

eleven_trans_tab
	.long	0,0,0,0,0,0,t117,0
	.long	0,0,0,t1112,t1113,0,0,0

t117	.word	1,5
t1112	.word	5,9,10,14,15,16
t1113	.word	3,10,14,15

twelve_trans_tab
	.long	0,0,0,0,0,0,0,t128
	.long	t129,t1210,t1211,0,t1213,t1214,t1215,t1216

t128	.word	1,6
t129	.word	3,2,4,10
t1210	.word	1,4
t1211	.word	1,7
t1213	.word	1,15
t1214	.word	1,16
t1215	.word	1,16
t1216	.word	2,14,15

thirteen_trans_tab
	.long	0,0,0,0,0,0,0,0
	.long	0,t1310,t1311,t1312,0,t1314,t1315,0

t1310	.word	1,4
t1311	.word	1,7
t1312	.word	5,8,9,10,14,16
t1314	.word	2,10,16
t1315	.word	3,10,14,16

fourteen_trans_tab
	.long	0,0,0,0,0,0,0,0
	.long	t149,t1410,0,t1412,t1413,0,t1415,t1416

t149	.word	5,1,2,4,6,8
t1410	.word	4,1,4,6,9
t1412	.word	3,8,11,13
t1413	.word	1,11
t1415	.word	1,13
t1416	.word	1,15

fifteen_trans_tab
	.long	0,0,0,0,0,0,0,0
	.long	t159,t1510,0,t1512,t1513,t1514,0,t1516

t159	.word	5,1,2,4,6,8
t1510	.word	3,1,4,6
t1512	.word	4,8,9,10,11
t1513	.word	2,11,12
t1514	.word	2,9,10
t1516	.word	2,10,14

sixteen_trans_tab
	.long	0,0,0,0,0,0,0,0
	.long	t169,t1610,0,t1612,0,t1614,t1615,0

t169	.word	3,1,4,6
t1610	.word	4,1,4,6,9
t1612	.word	3,8,11,13
t1614	.word	4,9,10,12,13
t1615	.word	3,9,12,13

**************************************************************************
*									 *
* team_modify_xz							 *
*	input	a0 = x							 *
*		a6 = player block					 *
*	output	a0 = x (same (player 1-4) or inverted (player 5-8))	 *
*									 *
**************************************************************************
team_modify_xz
	movb	*a6(POF_NUMBER),a14
	dec	a14
	srl	2,a14
	jrz	tmx
	neg	a0
tmx	rets

