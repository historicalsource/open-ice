 	.MLIB	"HHMACS.LIB"
	.FILE	"HHTIMER.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"clock.tbl"
	.include	"hhtimer.e"
	.include	"hhd.g"
	.include	"hhproc.g"
	.include	"hhram.g"
	.include	"hhgame.g"
	.include	"hhselect.g"
	.include	"hhc.g"

; end of include files

	.bss	minutes,16
	.bss	tenseconds,16
	.bss	seconds,16
	.bss	tenths,16
	.bss	timer_ok,16		;ok to decrement timer
	.bss	timer_on,16		;timer is on the screen
	.bss	score_on,16

start_timer			;starts timer counting down
	movk	1,a0
	move	a0,@timer_ok,W
	jruc	stuff_timer

stop_timer
	clr	a0
	move	a0,@timer_ok,W
	jruc	stuff_timer

show_timer_ts			;show timer and score for a0 ticks
	movi	90,a14
	move	a14,@score_on,W

show_timer_t			;shows timer for at least a0 ticks (unless always on)
	move	@timer_on,a14,W
	jrn	stt_9
	move	a0,@timer_on,W
stt_9	jruc	stuff_timer	;turn it on

game_timer
gt_0	move	@WAVEIRQS,a10,L
	callr	gnt_1
gt_1	move	@score_on,a0,W
	jrz	st_1
	dec	a0
	jrn	st_1
	move	a0,@score_on,W
	jrnz	st_1
	callr	stuff_timer
st_1	move	@timer_on,a0,W		;>0 = on for t
	jrz	gt_2			; 0 = off
	dec	a0			;<0 = on always
	jrn	gt_2
	move	a0,@timer_on,W
	jrnz	gt_2
	callr	stuff_timer
gt_2	SLEEP	2
	move	@timer_ok,a14,W
	jrz	gt_0
	move	@WAVEIRQS,a0,L
	cmp	a10,a0
	jrlt	gt_1
	callr	gnt_2
	callr	set_for_always_on	;turn it on allways if < 1 minute
	callr	dec_timer
	jac	period_over
	callr	stuff_timer
	jruc	gt_1

gnt_1	movi	timer_count_list,a11
gnt_2	move	*a11+,a14,W
	jrz	gnt_1
	add	a14,a10
	rets

timer_count_list		;ticks for every tenth second
	.word	6,5,5,5,5,0

dec_timer
	move	@tenths,a14,W
	dec	a14
	jrnn	dt_mt
	move	@tenseconds,a2,W
	move	@seconds,a0,W
	move	@minutes,a1,W
	add	a1,a0
	add	a2,a0
	jrz	dt_99		;period over
	movk	9,a14
	move	a14,@tenths,W
	move	@seconds,a14,W
	dec	a14
	jrnn	dt_ms
	movk	9,a14
	move	a14,@seconds,W
	move	@tenseconds,a14,W
	dec	a14
	jrnn	dt_mts
	movk	5,a14
	move	a14,@tenseconds
	move	@minutes,a14,W
	dec	a14
	move	a14,@minutes,W
	clrc
	rets
dt_mts	move	a14,@tenseconds,W
	clrc
	rets
dt_ms	move	a14,@seconds,W
	clrc
	rets
dt_mt	move	a14,@tenths,W
	clrc
	rets
dt_99	setc
	rets

set_for_always_on
	move	@timer_on,a14,W
	jrn	sfao_9
	move	@minutes,a14,W
	jrnz	sfao_9
	movi	-1,a14
	move	a14,@timer_on,W
sfao_9	rets

stuff_timer
	move	@score_on,a14,W
	jrnz	son
	movi	OID_SCORE_1,a0
	movi	MASK_OID_TIMER_SCORE,a1
	calla	KILOBJ				;kill all the score objects
	jruc	dnt
son	movi	OID_SCORE_1,a0			;are we on screen?
	movi	MASK_OID_TIMER_SCORE,a1
	calla	EXISTOBJ
	jrnz	dnt				;we are already on screen, assume no change
	movi	score_area_init,b0
	calla	EASYMAKE
	move	@team1,a2,W
	movi	score_team_1_init,b0
	callr	cteam
	move	@team2,a2,W
	movi	score_team_2_init,b0
	callr	cteam
	move	@team1_score,a2,W
	movi	score_pos_1_init,b0
	movi	score_pos_2_init,a3
	callr	cnum
	move	@team2_score,a2,W
	movi	score_pos_3_init,b0
	movi	score_pos_4_init,a3
	callr	cnum
	movi	bottom_of_score_init,b0
	calla	EASYMAKE
	move	@period,a0
	move	@GAME_STATE,a14,W
	cmpi	INPLAY,a14
	jrz	te1
	addk	3,a0
te1	sll	5,a0
	addi	period_image_list-32,a0
	move	*a0,a1,L
	move	*a8(OCTRL),a4,W
	ori	DMAGO,a4
	calla	ANI
	jruc	dnt			;now do timer

period_image_list
	.long	perone
	.long	pertwo
	.long	perthree
	.long	endof1
	.long	endof2
	.long	endof3

cnum	cmpi	99,a2
	jrls	cn3
	movi	99,a2
cn3	move	a2,a5
	movk	10,a0
	divu	a0,a5
	move	a5,a6
	jrz	cn2
	calla	EASYMAKE
	sll	5,a6
	addi	sc_nlst,a6
	move	*a6,a1,L
	callr	ct2
cn2	move	a3,b0
	calla	EASYMAKE
	movk	10,a0
	mpys	a0,a5
	sub	a5,a2
	sll	5,a2
	addi	sc_nlst,a2
	jruc	ct1

sc_nlst	.long	sczero
	.long	scone
	.long	sctwo
	.long	scthree
	.long	sc4
	.long	scfive
	.long	scsix
	.long	scsev
	.long	sceght
	.long	scnine

cteam	calla	EASYMAKE
	sll	8,a2
	addi	team_data,a2
ct1	move	*a2,a1,L
ct2	move	*a8(OCTRL),a4,W
	ori	DMAGO,a4
	jauc	ANI

dnt	move	@timer_on,a14,W
	jrnz	rst
	movi	OID_TIMER_1,a0
	movi	MASK_OID_TIMER_SCORE,a1
	calla	KILOBJ				;kill all the score objects
	jruc	stend
rst	movi	OID_TIMER_1,a0
	movi	MASK_OID_TIMER_SCORE,a1
	calla	KILOBJ				;kill all the score objects
	move	@minutes,a2,W
	jrz	rslm
	movi	timer_1_init,b0
	callr	digst
	movi	timer_2_init,b0
	calla	EASYMAKE
	move	@tenseconds,a2,W
	movi	timer_3_init,b0
	callr	digst
	move	@seconds,a2,W
	movi	timer_4_init,b0
	callr	digst
	movi	timer_5_init,b0
	calla	EASYMAKE
	jruc	stend
rslm	move	@tenseconds,a2,W
	movi	timer_1m_init,b0
	callr	digst
	move	@seconds,a2,W
	movi	timer_2m_init,b0
	callr	digst
	movi	timer_3m_init,b0
	calla	EASYMAKE
	move	@tenths,a2,W
	movi	timer_4m_init,b0
	callr	digst
	movi	timer_5_init,b0
	calla	EASYMAKE
stend	rets

digst	calla	EASYMAKE
	sll	5,a2
	addi	st_nlst,a2
	move	*a2,a1,L
	move	*a8(OCTRL),a4,L
	ori	DMAGO,a4
	jauc	ANI

st_nlst	.long	zero
	.long	one
	.long	two
	.long	three
	.long	four
	.long	five
	.long	six
	.long	seven
	.long	eight
	.long	nine

init_timer_value
	movk	3,a14
	move	a14,@minutes,W
	clr	a14
	move	a14,@tenseconds
	move	a14,@seconds,W
	move	a14,@tenths,W
	rets

timer_1_init
	.long	three
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_TIMER_1
	.long	[300,0],[230,0],[-10000,0]
timer_2_init
	.long	col
	.word	DMAWNZ,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_TIMER_2
	.long	[311,0],[231,0],[-10000,0]
timer_3_init
	.long	zero
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_TIMER_3
	.long	[317,0],[230,0],[-10000,0]
timer_4_init
	.long	zero
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_TIMER_4
	.long	[328,0],[230,0],[-10000,0]
timer_1m_init
	.long	five
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_TIMER_1
	.long	[300,0],[230,0],[-10000,0]
timer_2m_init
	.long	nine
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_TIMER_2
	.long	[311,0],[230,0],[-10000,0]
timer_3m_init
	.long	per
	.word	DMAWNZ,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_TIMER_3
	.long	[322,0],[231,0],[-10000,0]
timer_4m_init
	.long	zero
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_TIMER_4
	.long	[328,0],[230,0],[-10000,0]
timer_5_init
	.long	clock
	.word	DMAWNZ,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_TIMER_5
	.long	[296,0]
	.long	[238,0]
	.long	[-9999,0]

score_area_init
	.long	gmlogo
	.word	DMAWNZ,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_SCORE_1
	.long	[18h,0]
	.long	[83h,0]
	.long	[-9998,0]

score_team_1_init
	.long	sczero		;replace with team name
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_SCORE_2
	.long	[112,0]
	.long	[180,0]
	.long	[-10000,0]
score_team_2_init
	.long	sczero		;replace with team name
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_SCORE_3
	.long	[112,0]
	.long	[200,0]
	.long	[-10000,0]
score_pos_1_init
	.long	sczero
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_SCORE_4
	.long	[293,0]
	.long	[180,0]
	.long	[-10000,0]
score_pos_2_init
	.long	sczero
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_SCORE_5
	.long	[310,0]
	.long	[180,0]
	.long	[-10000,0]
score_pos_3_init
	.long	sczero
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_SCORE_6
	.long	[293,0]
	.long	[200,0]
	.long	[-10000,0]
score_pos_4_init
	.long	sczero
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_SCORE_7
	.long	[310,0]
	.long	[200,0]
	.long	[-10000,0]

bottom_of_score_init
	.long	perone
	.word	DMAWNZ-DMAGO,M_SCRNOBJ
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_SCORE_8
	.long	[220,0]
	.long	[229,0]
	.long	[-10000,0]

;	.long	SCORE1
;	.word	DMAWNZ,M_SCRNOBJ
;	.word	OM_OID|OM_POS
;	.word	OID_SCORE
;	.long	[90,0],[50,0],[-18000,0]
