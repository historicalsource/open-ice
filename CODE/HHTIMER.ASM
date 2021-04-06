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
	.include	"HHRPAL.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"clock.tbl"
	.include	"hhtimer.e"
	.include	"hhd.g"
	.include	"hhproc.g"
	.include	"hhram.g"
	.include	"hhgame.g"
	.include	"hhselect.g"
	.include	"hhc.g"
	.include	"hhpall.g"
	.include	"hhscore.g"
	.include	"hhstable.g"
	.include	"hhshow.g"
	.include	"hhcmos.g"
	.include	"hhmisc.g"
	.include	"hhcontr2.g"
	.include	"hhpup.g"
	.include	"hhspeech.g"

; end of include files

BIGBLOX	.equ	40
BIGBLOY	.equ	170

SMALBLX	.equ	30
SMALBLY	.equ	205

	.bss	minutes,16
	.bss	tenseconds,16
	.bss	seconds,16
	.bss	tenths,16
	.bss	timer_ok,16		;ok to decrement timer
	.bss	timer_on,16		;timer is on the screen
	.bss	rinkpallist,32
	.bss	score_appearing,16	;score is appearing (temp for create score)
	.bss	timer_on_at,32		;turn our timer on again at this time
	.bss	last_u_second,16
	.bss	last_u_tenth,16
	.bss	timer_table,32

init_timer_dma
	movi	scbox1,a2
	movi	itd_table,a0
	movk	2,a3
	callr	stf_g1			;outside box
	move	@team1,a1,W
	callr	stfg213			;team 1
	move	@team2,a1,W
	callr	stfg213			;team 2
	move	@period,a1,W
	sll	5,a1
	addi	pr_list-32,a1
	move	*a1,a1,L
	callr	stfg21			;period #
	callr	st_fill_timer

clean_fill_scores
	mmtm	sp,a0,a1,a2,a3,a4
	callr	st_fill_scores
	mmfm	sp,a0,a1,a2,a3,a4
	rets

st_fill_scores
	movi	itd_t1,a0
	movi	sct1s1,a2
	move	@team1_score,a4,W
	callr	sscr
	movi	itd_t2,a0
	move	@team2_score,a4,W
sscr	cmpi	10,a4
	jrlo	sscr1
	addi	64,a0

ssca2	clr	a1
ssca3	subk	10,a4
	inc	a1
	cmpi	10,a4
	jrhs	ssca3
	sll	5,a1
	addi	ssc,a1
	move	*a1,a1,L
	callr	stfg21
	sll	5,a4
	addi	ssc,a4
	move	*a4,a1,L
	jruc	stfg21
sscr1	sll	5,a4
	addi	ssc,a4
	move	*a4,a1,L
	callr	stfg21
	jruc	stfg21

ssc	.long	FLSC00
	.long	FLSC01
	.long	FLSC02
	.long	FLSC03
	.long	FLSC04
	.long	FLSC05
	.long	FLSC06
	.long	FLSC07
	.long	FLSC08
	.long	FLSC09

clean_fill_timer
	mmtm	sp,a0,a1,a2,a3,a4
	callr	st_fill_timer
	mmfm	sp,a0,a1,a2,a3,a4
	rets

st_fill_timer
	move	@seconds,@last_u_second,W
	move	@tenths,@last_u_tenth,W
	movi	scmintens,a2
	move	@minutes,a1,W
	jrz	stf_nm
	movi	itd_min,a0
	callr	mdig
	movk	1,a3
	callr	stf_g1
	move	@tenseconds,a1,W
	callr	mdig
	move	@seconds,a1,W
	jruc	mdig
stf_nm	movi	itd_nomin,a0
	move	@tenseconds,a1,W
	callr	mdig
	move	@seconds,a1,W
	callr	mdig
	movk	1,a3
	callr	stf_g1
	move	@tenths,a1,W
	jruc	mdig

	.long	FL1STA		;just for safety
pr_list	.long	FL1STA
	.long	FL2NDA
	.long	FL3RDA
	.long	FLOTA

stfg213	sll	10,a1
	addi	team_data,a1
	move	*a1,a1,L
stfg21	movk	1,a3
	jruc	stf_g2
stf_g1	move	*a0+,a1,L
stf_g2	move	*a1(ISAG),*a2(0),L
	addk	32,a2
	move	*a0+,*a2+,L
	move	*a1(ISIZE),*a2(0),L
	addk	32,a2
	dsjs	a3,stf_g1
	rets

mdig	sll	5,a1
	addi	mdt_tab,a1
	move	*a1,a1,L
	jruc	stfg21

mdt_tab	.long	FL00
	.long	FL01
	.long	FL02
	.long	FL03
	.long	FL04
	.long	FL05
	.long	FL06
	.long	FL07
	.long	FL08
	.long	FL09


itd_table
	.long	FLOATERC,[205,30]
	.long	FLOATERD,[205,30]
	.long	[207,32]
	.long	[216,32]
	.long	[227,33]

itd_min
	.long	[228,62]
	.long	FLCOL,[229-1,67]
	.long	[228,69]
	.long	[228,74]
itd_nomin
	.long	[228,62]
	.long	[228,67]
	.long	FLPER,[232-3,72]
	.long	[228,74]

itd_t1	.long	[207,-10]	;61
	.long	[207,72]
	.long	[207,63]	;61
	.long	[207,72]
itd_t2	.long	[216,-10]	;61
	.long	[216,72]
	.long	[216,63]	;61
	.long	[216,72]

start_timer			;starts timer counting down
	callr	clean_fill_timer
	movk	1,a0
	move	a0,@timer_ok,W
	jruc	stuff_timer

flash_team_who_scored
	C_A_K	PID_SCORES_FLASH,flash_who_scored
	rets

flash_who_scored
fws_3	SLEEP	5
	movi	OID_BIG_SCORE_FLASHER1,a0
	callr	fws_off
	movi	OID_BIG_SCORE_FLASHER2,a0
	callr	fws_off
	SLEEP	5
	movi	OID_BIG_SCORE_FLASHER1,a0
	callr	fws_on
	movi	OID_BIG_SCORE_FLASHER2,a0
	callr	fws_on
	jruc	fws_3

fws_off	calla	EXIST_OBJ_ALL
	jrz	fws_89
	move	*a8(OCTRL),a14,W
	andni	(DMAWNZ-DMAGO),a14
	move	a14,*a8(OCTRL),W
fws_89	rets
fws_on	calla	EXIST_OBJ_ALL
	jrz	fws_79
	move	*a8(OCTRL),a14,W
	ori	DMAWNZ,a14
	move	a14,*a8(OCTRL),W
fws_79	rets

;	movi	fws_t1,a9
;	move	@team_scored,a0,W
;	cmpi	1,a0
;	jrz	fws_2
;	movi	fws_t2,a9
;	cmpi	2,a0
;	jrnz	fws_9
;fws_2	movi	SCCITYP,a1
;	callr	fws_xo
;	SLEEP	5
;	movi	KCITYP,a1
;	callr	fws_xo
;	SLEEP	5
;	jruc	fws_2
;fws_9	jauc	SUCIDE
;fws_xo	move	a9,a10
;fws_xo1	move	*a10+,a0,W
;	jrz	fws_xo2
;	calla	EXIST_OBJ_ALL
;	jrz	fws_xo1
;	move	a1,a0
;	calla	CHANGE_PAL
;	jruc	fws_xo1
;fws_xo2	rets
;
;
;fws_t1	.word	OID_BIG_SCORE_T1
;	.word	OID_BIG_SCORE_T1_S1
;	.word	OID_BIG_SCORE_T1_S2
;	.word	0
;
;fws_t2	.word	OID_BIG_SCORE_T2
;	.word	OID_BIG_SCORE_T2_S1
;	.word	OID_BIG_SCORE_T2_S2
;	.word	0

remove_big_score

;	movi	PID_BIG_SCORE,a0
;	calla	KILLPROC_ALL
;	movi	OID_BIG_SCORE_BAR,a0
;	movi	MASK_OID_NEW_TIMER,a1
;	calla	KILOBJ
;	clr	a14
;	move	a14,@timer_on,W
;	movk	1,a14
;	move	a14,@small_timer_on,W
;	movi	PID_SCORES_FLASH,a0
;	calla	KILLPROC_ALL
;	jauc	SUCIDE

	clr	a0
	move	a0,@score_appearing,W
	movi	[8,0],a10
rbi2	movi	OID_BIG_SCORE_BAR,a0
	calla	EXIST_OBJ_ALL
	jrz	rbi9
	move	*a8(OYVAL),a14,L
	cmpi	[BIGBLOY+100,0],a14
	jrge	rbi1
	move	a10,a5
	clr	a4
	callr	propagate_vels
	SLEEP	2
	addi	[1,0],a10
	jruc	rbi2

;	clr	a0
;	move	a0,@score_appearing,W
;	movi	[-16,0],a10
;rbi2	movi	OID_BIG_SCORE_BAR,a0
;	calla	EXIST_OBJ_ALL
;	jrz	rbi9
;	move	*a8(OXVAL),a14,L
;	cmpi	[-400,0],a14
;	jrle	rbi1
;	move	a10,a4
;	clr	a5
;	callr	propagate_vels
;	SLEEP	2
;	subi	[1,0],a10
;	jruc	rbi2

rbi1	clr	a4
	clr	a5
	callr	propagate_vels
	clr	a14
	move	a14,@timer_on,W
	movk	1,a14
	move	a14,@small_timer_on,W
rbi9	movi	PID_SCORES_FLASH,a0
	calla	KILLPROC_ALL
	jauc	SUCIDE

bbix1	SLEEP	2
bring_big_in
bbi2	movi	OID_BIG_SCORE_BAR,a0
	calla	EXIST_OBJ_ALL
	jrz	bbi9
	move	@scored_by,a14,W
	jrnz	bbix1
	move	*a8(OYVAL),a14,L
	cmpi	[BIGBLOY,0],a14
	jrle	bbi1
	movi	[BIGBLOY-22,0],a0
	sub	a14,a0
	sra	4,a0
	move	a0,a5
	clr	a4

;	move	*a8(OXVAL),a14,L
;	cmpi	[BIGBLOX,0],a14
;	jrge	bbi1
;	movi	[BIGBLOX+22,0],a0
;	sub	a14,a0
;	sra	4,a0
;	move	a0,a4
;	clr	a5

	callr	propagate_vels
	SLEEP	2
	jruc	bbi2
bbi1	clr	a4
	clr	a5

	move	a5,*a8(OYVEL),L
	movi	[BIGBLOY,0],a14
	move	a14,*a8(OYVAL),L

;	move	a4,*a8(OXVEL),L
;	movi	[BIGBLOX,0],a14
;	move	a14,*a8(OXVAL),L
	callr	clean_fill_timer
	callr	stuff_timer
bbi9	jauc	SUCIDE

propagate_vels
	move	a4,*a8(OXVEL),L
	move	a5,*a8(OYVEL),L
	movi	bigb_oil,a11
pvv1	move	*a11+,a0,W
	jrz	pvv9
	calla	EXIST_OBJ_ALL
	jrz	pvv1
	move	a4,*a8(OXVEL),L
	move	a5,*a8(OYVEL),L
	jruc	pvv1
pvv9	rets

bigb_oil
	.word	OID_BIG_SCORE_LOGO
	.word	OID_BIG_SCORE_JITTER1
	.word	OID_BIG_SCORE_JITTER2
	.word	OID_BIG_SCORE_T1
	.word	OID_BIG_SCORE_T2
	.word	OID_BIG_SCORE_T1_S1
	.word	OID_BIG_SCORE_T1_S2
	.word	OID_BIG_SCORE_T2_S1
	.word	OID_BIG_SCORE_T2_S2
	.word	OID_BIG_SCORE_TM_1
	.word	OID_BIG_SCORE_TM_2
	.word	OID_BIG_SCORE_TM_3
	.word	OID_BIG_SCORE_TM_4
	.word	OID_BIG_SCORE_PER
	.word	OID_BIG_SCORE_ANIMATION
	.word	OID_BIG_SCORE_FLASHER1
	.word	OID_BIG_SCORE_FLASHER2
;	.word	OID_BIG_SCORE_NHL
;	.word	OID_BIG_SCORE_NHLPA
	.word	0

stop_timer
	callr	clean_fill_timer
	mmtm	sp,a0,a6
	clr	a0
	move	a0,@timer_ok,W
	callr	stuff_timer
	mmfm	sp,a0,a6
	rets

show_at_least_timer
	move	@timer_on,a14,W
	cmp	a14,a0
	jrhs	show_timer
	move	a14,a0
	;
show_timer			;show timer for a0 ticks
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	mmtm	sp,a0
	movi	PID_BIG_SCORE,a0
	calla	EXISTP_ALL
	mmfm	sp,a0		;get our a0, save cc
	jrnz	st_nw		;we are moving timer, restart
	move	@timer_on,a14,W
	jrz	st_nw
	clr	a1
	move	a1,@score_appearing,W
	jruc	gst_1
st_nw	movk	1,a1
	move	a1,@score_appearing,W
	mmtm	sp,a0
	C_A_KP	PID_SCORE_MOVE,bring_big_in
	movi	PID_BIG_SCORE,a0
	calla	KILLPROC_ALL
	movi	OID_BIG_SCORE_BAR,a0
	movi	MASK_OID_NEW_TIMER,a1
	calla	KILOBJ
	mmfm	sp,a0
gst_1	move	a0,@timer_on,W
	clr	a0
	move	a0,@small_timer_on,W
gst_2	callr	stuff_timer
	callr	clean_fill_timer
st_9	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

appear_score
	jauc	SUCIDE

create_if_score_big_box
	movi	OID_BIG_SCORE_BAR,a0
	movi	cisbb_tab2,a7
	calla	EXIST_OBJ_ALL
	jrnz	cisbb_1
	movi	cisbb_tab,a7
	clr	a11
	callr	make_timer_obj_tbl_i
cisbb_1	move	a8,a11
	callr	make_timer_obj_tbl_i
	callr	make_timer_obj_tbl_i
	callr	make_timer_obj_tbl_i
	move	@team_scored,a14,W
	cmpi	1,a14
	jrz	cicv1
	addi	256,a7		;skip down 2
cicv1	callr	make_timer_obj_tbl_i
	move	*a8(OCTRL),a14,W
	andni	(DMAWNZ-DMAGO),a14
	move	a14,*a8(OCTRL),W
	callr	make_timer_obj_tbl_i
	move	*a8(OCTRL),a14,W
	andni	(DMAWNZ-DMAGO),a14
	move	a14,*a8(OCTRL),W
	rets

cisbb_tab
	LWLWWW	SCORBAR9,OID_BIG_SCORE_BAR,SCOREBAR,BIGBLOX,BIGBLOY+100,-20000
cisbb_tab2
	LWLWWW	OPICESM4,OID_BIG_SCORE_LOGO,OPICESM4P,12,13,-20001
	LWLWWW	JITTER1,OID_BIG_SCORE_JITTER1,JITTERP,0,0,-19998
	LWLWWW	JITTER2,OID_BIG_SCORE_JITTER2,JITTERP,0,0,-19998

	LWLWWW	SCRFLSH1,OID_BIG_SCORE_FLASHER1,JITTERP,61,13,-19999
	LWLWWW	SCRFLSH2,OID_BIG_SCORE_FLASHER2,JITTERP,61,13,-19999
	LWLWWW	SCRFLSH1,OID_BIG_SCORE_FLASHER1,JITTERP,61,37,-19999
	LWLWWW	SCRFLSH2,OID_BIG_SCORE_FLASHER2,JITTERP,61,37,-19999

;	LWLWWW	NHLSM,OID_BIG_SCORE_NHL,NHLSMP,-8,-4,-20001
;	LWLWWW	NHLPASM,OID_BIG_SCORE_NHLPA,NHLPASMP,293,40,-20001

create_if_score_big_team1
	mmtm	sp,a0
;;	movi	OID_BIG_SCORE_T1,a0
;;	calla	EXISTOBJ_ALL
;;	jrnz	cistb19
	move	@team1,a2,W
	movi	cistb1_tab,a7
	jruc	cistb21
create_if_score_big_team2
	mmtm	sp,a0
;;	movi	OID_BIG_SCORE_T2,a0
;;	calla	EXISTOBJ_ALL
;;	jrnz	cistb19
	move	@team2,a2,W
	movi	cistb2_tab,a7
cistb21	sll	10,a2
	addi	team_data+512,a2
	move	*a2,a1,L	;image from team table
	callr	make_timer_obj_tbl
cistb19	mmfm	sp,a0
	rets

cistb1_tab
	WLWWW	OID_BIG_SCORE_T1,KCITYP,64,17,-20001
cistb2_tab
	WLWWW	OID_BIG_SCORE_T2,KCITYP,64,41,-20001

create_if_score_big_team1_score
	move	@team1_score,a1,W
	movi	cbsp1_tab,a7
	jruc	sb_put
create_if_score_big_team2_score
	move	@team2_score,a1,W
	movi	cbsp2_tab,a7
sb_put	cmpi	99,a1
	jrls	sbp1
	movi	99,a1
sbp1	mmtm	sp,a0
	clr	a0
	movk	10,a14
	divu	a14,a0		;a0 = first digit, a1 = 2nd
	mmtm	sp,a0
	move	a1,a0
	callr	sbnud
	mmfm	sp,a0
	move	a0,a0
	jrz	sbn9
	callr	sbnud
sbn9	mmfm	sp,a0
	rets
sbnud	movi	score_b_tab,a2
	move	a0,a5
	sll	5,a5
	add	a2,a5
	move	*a5,a1,L
	jruc	make_timer_obj_tbl

cbsp1_tab
	WLWWW	OID_BIG_SCORE_T1_S2,SCORESP,232-8+8+2,17,-20001
	WLWWW	OID_BIG_SCORE_T1_S1,SCORESP,218+3,17,-20001

cbsp2_tab
	WLWWW	OID_BIG_SCORE_T2_S2,SCORESP,232-8+8+2,41,-20001
	WLWWW	OID_BIG_SCORE_T2_S1,SCORESP,218+3,41,-20001

score_b_tab
	.long	SCOR0
	.long	SCOR1
	.long	SCOR2
	.long	SCOR3
	.long	SCOR4
	.long	SCOR5
	.long	SCOR6
	.long	SCOR7
	.long	SCOR8
	.long	SCOR9

create_if_score_big_timer
	mmtm	sp,a0
	move	@minutes,a0,W
	jrz	cbsr1
	movi	sb_min_tab,a7
	callr	tb_dig
	callr	make_timer_obj_tbl_i
	move	@tenseconds,a0,W
	callr	tb_dig
	move	@seconds,a0,W
	jruc	cbsr9
cbsr1	movi	sb_nmin_tab,a7
	move	@tenseconds,a0,W
	callr	tb_dig
	move	@seconds,a0,W
	callr	tb_dig
	callr	make_timer_obj_tbl_i
	move	@tenths,a0,W
cbsr9	callr	tb_dig
cbsr99	mmfm	sp,a0
	rets

tb_dig	movi	score_bt_tab,a2
	move	a0,a5
	sll	5,a5
	add	a2,a5
	move	*a5,a1,L
	jruc	make_timer_obj_tbl

sb_min_tab
	WLWWW	OID_BIG_SCORE_TM_1,LEDSP,210,63,-20001
	LWLWWW	LEDCOL,OID_BIG_SCORE_TM_2,LEDSP,221,65,-20001
	WLWWW	OID_BIG_SCORE_TM_3,LEDSP,225,63,-20001
	WLWWW	OID_BIG_SCORE_TM_4,LEDSP,236,63,-20001

sb_nmin_tab
	WLWWW	OID_BIG_SCORE_TM_1,LEDSP,210,63,-20001
	WLWWW	OID_BIG_SCORE_TM_2,LEDSP,221,63,-20001
	LWLWWW	LEDPER,OID_BIG_SCORE_TM_3,LEDSP,232,71,-20001
	WLWWW	OID_BIG_SCORE_TM_4,LEDSP,236,63,-20001

score_bt_tab
	.long	LED00
	.long	LED01
	.long	LED02
	.long	LED03
	.long	LED04
	.long	LED05
	.long	LED06
	.long	LED07
	.long	LED08
	.long	LED09


create_if_score_big_period
	movi	cbsp_tab,a7
	move	@period,a0
	sll	5,a0
	addi	period_bimage_list-32,a0
	move	*a0,a1,L
	jruc	make_timer_obj_tbl

cbsp_tab
	WLWWW	OID_BIG_SCORE_PER,PERIODP,161,61,-20001

period_bimage_list
	.long	FIRST
	.long	SECOND
	.long	THIRD
	.long	OT

create_if_score_big_animation
	movi	OID_BIG_SCORE_ANIMATION,a0
	calla	EXIST_OBJ_ALL
	jrnz	ciba1
	movi	cbaal_l,a7
	calla	make_timer_obj_tbl_i
	jauc	start_clip_running_us
ciba1	movi	cbaal2l,a7
	move	*a7+,a4,W
	move	*a7+,a5,W
	move	*a7+,a6,W
	sll	16,a4
	sll	16,a5
	sll	16,a6
	jruc	mtna

cbaal_l	LWL	SCOR0,OID_BIG_SCORE_ANIMATION,VIDEOSP		;use dummy frame
cbaal2l	.word	249,11,-19999


**************************************************************************
*								         *
* make_timer_obj_tbl_i							 *
* 	input	a7 = table to obj, oid,palette, ox,oy,oz		 *
*								         *
**************************************************************************
make_timer_obj_tbl_i
	move	*a7+,a1,L
	jruc	make_timer_obj_tbl
**************************************************************************
*								         *
* make_timer_obj_tbl							 *
* 	input	a7 = table to oid,palette,ox,oy,oz			 *
* 		a1 = image						 *
* 		a11= object to align with (if non zero) 		 *
*								         *
**************************************************************************
make_timer_obj_tbl
	move	*a7+,a0,W
	move	*a7+,a3,L
	move	*a7+,a4,W
	move	*a7+,a5,W
	move	*a7+,a6,W
	sll	16,a4
	sll	16,a5
	sll	16,a6
	;
**************************************************************************
*								         *
* make_timer_object							 *
* 	input	a0 = OID						 *
* 		a1 = image						 *
* 		a3 = palette						 *
* 		a4 = OXVAL						 *
* 		a5 = OYVAL						 *
* 		a6 = OZVAL						 *
* 		a11= object to align with (if non zero) 		 *
*								         *
**************************************************************************
make_timer_object
	mmtm	sp,a0,a4
	callr	find_or_create_object
	move	a11,a11
	jrz	mto2
	move	*a11(OXVAL),a14,L
	add	a14,a4
	move	*a11(OYVAL),a14,L
	add	a14,a5
	move	*a11(OXVEL),*a8(OXVEL),L
	move	*a11(OYVEL),*a8(OYVEL),L
	move	*a11(OZVEL),*a8(OZVEL),L
mto2	move	a4,*a8(OXVAL),L
	move	a5,*a8(OYVAL),L
	movy	a4,a0
	srl	16,a0
	movy	a5,a0		;for scrnobj_to_pos below
	mmtm	sp,a1
	calla	set_scrnobj_to_pos
	mmfm	sp,a1
	move	*a8(OCTRL),a4
	calla	ANI
	calla	set_scrnobj_to_pos
	mmfm	sp,a0,a4
	rets

mtna	mmtm	sp,a0,a1
	move	*a11(OXVAL),a14,L
	add	a14,a4
	move	*a11(OYVAL),a14,L
	add	a14,a5
	move	*a11(OXVEL),*a8(OXVEL),L
	move	*a11(OYVEL),*a8(OYVEL),L
	move	*a11(OZVEL),*a8(OZVEL),L
	move	a4,*a8(OXVAL),L
	move	a5,*a8(OYVAL),L
	movy	a4,a0
	srl	16,a0
	movy	a5,a0		;for scrnobj_to_pos below
	calla	set_scrnobj_to_pos
	mmfm	sp,a0,a1
	rets

**************************************************************************
*								         *
* find_or_create_object							 *
* 	input	a0 = OID						 *
* 		a3 = palette to stuff (only on new object)		 *
* 		a6 = z value to stuff object with (to presort)		 *
* 	output	a8 = object						 *
* 		c  = object created					 *
* 		nc = object already created				 *
*								         *
**************************************************************************
find_or_create_object
	mmtm	sp,a0,a1
	calla	EXIST_OBJ_ALL
	jrnz	foc_9
	movi	foc_init,b0
	mmtm	sp,a0
	calla	EASYMAKE
	mmfm	sp,a0
	move	a0,a1
	move	a0,*a8(OID),W	;we change this way, because we haven't listed
	move	a3,a0
	calla	CHANGE_PAL
	move	a6,*a8(OZVAL),L
	calla	INSERT_OBJ
	mmfm	sp,a0,a1
	setc
	rets
foc_9	mmfm	sp,a0,a1
	clrc
	rets

foc_init
	.long	SCOR0		;we don't use this anyway
	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE
	.word	0

game_timer
	movk	ADJTMRSPD,a0
	calla	GET_ADJ
	sll	5,a0
	addi	tcl_lst,a0
	move	*a0,a0,L
	move	a0,@timer_table,L

gt_0	move	@WAVEIRQS,a10,L
	callr	gnt_1
gt_1	move	@timer_on,a0,W		;>0 = on for t
	jrz	gt_2			; 0 = off
	dec	a0			;<0 = on always
	move	a0,@timer_on,W
	jrnz	gt_2
	C_O_RP	PID_SCORE_MOVE,remove_big_score
	movk	10,a0
	move	a0,@timer_on,W		;safety until we remove score (and set it ourselves)
	callr	stuff_timer
gt_2	SLEEP	2
	move	@timer_ok,a14,W
	jrz	gt_0
	move	@WAVEIRQS,a0,L
	cmp	a10,a0
	jrlt	gt_1
	callr	gnt_2

	.if	BILL | 0
	.else
	callr	dec_timer
	jac	period_over
	.endif

	move	@minutes,a14,W
	jrnz	st_sec			;if minutes non zero, stuff every second change
st_tnt	move	@tenths,a0,W
	move	@last_u_tenth,a14,W
	cmp	a0,a14
	jrnz	ststuff
	jruc	gt_1
st_sec	move	@seconds,a0,W
	move	@last_u_second,a14,W
	cmp	a0,a14
	jrz	gt_1
ststuff	callr	clean_fill_timer
	callr	stuff_timer
	jruc	gt_1

gnt_1	move	@timer_table,a11,L
gnt_2	move	*a11+,a14,W
	jrz	gnt_1
	add	a14,a10
	rets

timer_count_list		;ticks for every tenth second
;	.word	5,4,4,4,4,0

;	.word	4,3,3,0
	.word	4,3,3,4,3,3,3
	.word	0

tcl_lst	.long	tcl1,tcl2,tcl3,tcl4,tcl5
	.long	tcl5,tcl5,tcl5,tcl5,tcl5

;tcl1	.word	3,0					;3
;tcl2	.word	3,3,3,3,3,3,3,3,2,0			;2.89
;tcl3	.word	3,3,3,2,0				;2.75
;tcl4	.word	3,3,2,3,2,0				;2.6
;tcl5	.word	3,2,2,3,2,3,2,3,2,3,2,0			;2.45

tcl1	.word	3,3,3,3,3,4,0						;3.17
tcl2	.word	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,0	;2.96
tcl3	.word	3,3,3,2,0						;2.75
tcl4	.word	3,3,2,3,2,3,2,3,2,3,2,3,2,0				;2.54
tcl5	.word	3,2,2,0							;2.34

dec_timer
	move	@tenths,a14,W
	dec	a14
	jrnn	dt_mt
	move	@tenseconds,a2,W
	move	@seconds,a0,W
	move	@minutes,a1,W
	add	a1,a0
	add	a2,a0
	jrz	dt_99		;period over	(now this is just a failsafe if we zero out time)
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
	jrnz	dt_san
	mmtm	sp,a14
	calla	spx_one_minute
	mmfm	sp,a14
dt_san	cmpi	1,a14
	jrnz	dtmtn1m
	calla	check_for_all_turbos
dtmtn1m	callr	every_second
	clrc
	rets
dt_mts	move	a14,@tenseconds,W
	move	a14,a14
	jrnz	dtmtnz
	move	@minutes,a14,W
	jrnz	dtmtnz
	calla	spx_ten_seconds
dtmtnz	callr	every_second
	clrc
	rets
dt_ms	move	a14,@seconds,W
	mmtm	sp,a14
	callr	every_second
	mmfm	sp,a14
	move	a14,a14
	jrz	every_three_seconds
	cmpi	3,a14
	jrz	every_three_seconds
	cmpi	7,a14
	jrz	every_three_seconds
	clrc
	rets
dt_mt	move	a14,@tenths,W
	move	a14,a14
	jrnz	dt_mtc		;not a zero, so not over
	move	@minutes,a1,L	;minutes and tenseconds
	add	a1,a14
	move	@seconds,a1,W	;seconds
	add	a1,a14
	jrz	dt_99
dt_mtc	clrc
	rets
dt_99	setc
	rets

every_second
	move	@minutes,a14,W
	jrnz	dtnlt		;not last minute
	move	@tenseconds,a14,W
	jrnz	dtnlt		;not last ten
	mmtm	sp,a0,a1,a7,a8,a9,a10,a11
	movi	FLOATRCP,a8
	movk	3,a9
	movk	14,a10
	movk	1,a11
	CREATE	PID_TIMECOLOR,CYCLE16_1
	mmfm	sp,a0,a1,a7,a8,a9,a10,a11
dtlt	jauc	time_running_out_show
dtnlt	rets

every_three_seconds		;really every three and a third seconds

;every_five_seconds
	move	@rinkpallist,a14,L
	move	*a14+,a0,L
	move	a14,@rinkpallist,L
	callr	change_rink_pal
	clrc
	rets

stuff_timer
	mmtm	sp,a11
	move	@timer_on,a14,W
	jrnz	stxx_1

	movi	PID_BIG_SCORE,a0
	calla	KILLPROC_ALL
	movi	OID_BIG_SCORE_BAR,a0
	movi	MASK_OID_NEW_TIMER,a1
	calla	KILOBJ
stxx_9	mmfm	sp,a11
	rets
stxx_1	movi	PID_BIG_SCORE,a0
	calla	EXISTP_ALL
	jrnz	stxx_9			;we are in transit, do not update

	callr	create_if_score_big_box
	callr	create_if_score_big_team1
	callr	create_if_score_big_team2
	callr	create_if_score_big_team1_score
	callr	create_if_score_big_team2_score
	callr	create_if_score_big_timer
	callr	create_if_score_big_period
	callr	create_if_score_big_animation
	mmfm	sp,a11
	rets

init_timer_value
	move	@period,a14,W
	cmpi	4,a14
	jrnz	itv1

	MOVK	ADJPAYOT,A0
	CALLA	GET_ADJ				;CHECK FOR PAY OVERTIME
	JRNZ	itv1				;BR=FULL 3 MINUTE OVERTIME

	movk	1,a14
	jruc	itv2
itv1	movk	3,a14
itv2	move	a14,@minutes,W
	clr	a14
	move	a14,@tenseconds,W
	move	a14,@seconds,W
	move	a14,@tenths,W
	rets

change_rink_pal ;(a0 = 0-30)
	move	@period,a14,W
	cmpi	4,a14
	jrz	crp89
	move	@DARK_RINK,a14,W
	jrnz	crp89
	PUSH	a0
	move	@rinkpal,a0,W
	calla	FREEPAL
	PULLQ	a0
	calla	GETFPAL
	move	a0,@rinkpal,W
crp89	rets
		   
rpallist
	.long	npal_0
	.long	npal_2
	.long	npal_4
	.long	npal_6
	.long	npal_8
	.long	npal_10
	.long	npal_12
	.long	npal_14
	.long	npal_16
	.long	npal_18
	.long	npal_20
	.long	npal_22
	.long	npal_24
	.long	npal_26
	.long	npal_28
	.long	npal_30
	.long	npal_32
	.long	npal_34
	.long	npal_36
	.long	npal_38
	.long	npal_40
	.long	npal_42
	.long	npal_44
	.long	npal_46
	.long	npal_48
	.long	npal_50
	.long	npal_52
	.long	npal_55
	.long	npal_57
	.long	npal_59
	.long	npal_61
	.long	npal_63
	.long	npal_65
	.long	npal_67
	.long	npal_69
	.long	npal_71
	.long	npal_74
	.long	npal_76
	.long	npal_78
	.long	npal_80
	.long	npal_82
	.long	npal_84
	.long	npal_86
	.long	npal_88
	.long	npal_90
	.long	npal_92
	.long	npal_94
	.long	npal_96
	.long	npal_98
	.long	npal_100
	.long	npal_102
	.long	npal_104
	.long	npal_106
	.long	npal_109
	.long	npal_109

