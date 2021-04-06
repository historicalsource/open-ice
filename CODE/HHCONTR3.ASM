	.MLIB	"HHMACS.LIB"
	.FILE	"HHCONTR3.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhboards.tbl"
	.include	"edge.tbl"
	.include	"hhcontr3.e"
	.include	"hhutil.g"
	.include	"hhd.g"
	.include	"hhpuck.g"
	.include	"hhgame.g"
	.include	"hhscore.g"
	.include	"hhshow.g"
	.include	"hhram.g"
	.include	"hhproc.g"

; end of include files

	.TEXT
	.EVEN

	.bss	glass_hit,16
	.bss	glass_break,16
	.bss	glass_break_now,16

**************************************************************************
*								         *
* screen_shake								 *
*								         *
**************************************************************************
screen_shake
	C_O_R	PID_SHAKE,scrnshk
	rets
scrnshk	move	@WORLDY+010h,a8,W
	movi	shscl,a9
sce1	move	*a9+,a0,W
	jrz	sce9
	add	a8,a0
	calla	game_set_worldy
	SLEEP	2
	move	a8,a0
	calla	game_set_worldy
	SLEEP	2
	jruc	sce1
sce9	jauc	SUCIDE

shscl	.word	-5,-5,0

**************************************************************************
*								         *
* shoot_board_animate							 *
*								         *
**************************************************************************
shoot_board_animate
	mmtm	sp,a0,a1,a8
	movi	300,a0
	calla	RANDPER
	jrnc	sban9
	movi	board_stand_up_script,a1
	callr	smart_start_board_anim
sban9	mmfm	sp,a0,a1,a8
	rets

**************************************************************************
*								         *
* score_board_animate							 *
*								         *
**************************************************************************
score_board_animate
	movk	3,a0
	calla	RAND0
	sll	5,a0
	addi	sbarlt,a0
	move	*a0,a1,L
	callr	smart_start_board_anim
	rets
sbarlt	.long	board_stand_and_clap_script
	.long	board_clap_script
	.long	board_stand_and_turn_wave_script

**************************************************************************
*								         *
* check_into_boards		;no break - a6=player doing check	 *
*								         *
**************************************************************************
check_into_boards		;no break - a6=player doing check
	callr	can_we_break_glass
	jrc	cib_break
	callr	get_board_side
	movb	*a6(POF_NUMBER),a1
	dec	a1
	sra	2,a1
	cmp	a0,a1
	jrz	cb_bad		;we are pissed about check
cb_good	movi	board_hit_good_script,a1
	jruc	smart_start_board_anim
cb_bad	movi	board_hit_bad_script,a1
	jruc	smart_start_board_anim

cib_break
	movi	board_glass_break_inner,a1
	callr	smart_start_glass_anim
	calla	break_glass_sound
	rets

init_board_script
	movi	board_stand_script,a1
	jauc	STRT_ANIM

animate_boards		;a0 = [z,x] of impact
	mmtm	sp,a1,a2,a3,a7,a8
	movi	abl_list,a7
	callr	abc_go
	mmfm	sp,a1,a2,a3,a7,a8
	rets

abc_go	movi	[1,1],a14
abc_1	mmfm	a7,a1,a2,a3
	add	a14,a2
	move	a3,a3
	jrz	abl_85
	cmpxy	a3,a0
	jryle	abc_1
	jrxle	abc_1
	cmpxy	a2,a0
	jrygt	abc_1
	jrxgt	abc_1
	jump	a1
abl_85	rets		;no hit

abl_list
	.long	[-300,-2000],[120,-625],bounce_ll_corner
	.long	[-300,625],[120,2000],bounce_lr_corner
	.long	[115,-2000],[630,-700],edge_bounce
	.long	[115,700],[630,2000],edge_bounce
	.long	0,0,0

bounce_ll_corner
	move	@ledge2_object,a8,L
	jruc	check_into_boards
bounce_lr_corner
	move	@redge2_object,a8,L
	jruc	check_into_boards

get_board_side
	clr	a0
	move	@PUCK_OBJECT,a14,L
	move	*a14(OXPOS),a14,W
	jrn	gbs9
	movk	1,a0
gbs9	rets

can_we_break_glass
;	setc
;	rets
	move	*a6(POF_OBJECT),a14,L
	move	*a14(OXPOS),a14,W
	abs	a14
	cmpi	700,a14
	jrhi	cwbgn
	move	@glass_break,a14,W
	jrnz	cwbgn
	move	@glass_hit,a14,W
	inc	a14
	move	a14,@glass_hit,W
	cmpi	2,a14
	jrls	cwbgn
;	move	@period,a14,W
;	cmpi	3,a14
;	jrnz	cwbgn
	movi	750,a0
	calla	RANDPER
	jrnc	cwbgn
cwbgy	movk	1,a14
	move	a14,@glass_break,W
	move	a14,@glass_break_now,W
	setc
	rets
cwbgn	clr	a14
	move	a14,@glass_break_now,W
	clrc
	rets

smart_start_glass_anim
	move	@ledge2_object,a8,L
	move	@PUCK_OBJECT,a14,L
	move	*a14(OXPOS),a14,W
	jrn	start_board_anim
	move	@redge2_object,a8,L
ssg1	jauc	STRT_ANIM

smart_start_board_anim
	move	@ledge2_object,a8,L
	move	@PUCK_OBJECT,a14,L
	move	*a14(OXPOS),a14,W
	jrn	start_board_anim
	move	@redge2_object,a8,L
start_board_anim
	move	*a8(ANIMSCR),a14,L
	cmpi	board_stand_script,a14
	jrnz	sba9
	jauc	STRT_ANIM
sba9	rets

a_clear_wc
	movk	20,a14
	move	a14,*a8(ODT_TEMP1),W
	rets

a_wait_score_wc
	move	@has_scored,a14,W
	jrnz	kwg1
	move	*a8(ODT_TEMP1),a14,W
	dec	a14
	move	a14,*a8(ODT_TEMP1),W
	jrz	aws5			;no score after timeout
	move	*a8(ANIMARG),a0,L
	move	*a0+,a14,L
	move	*a8(ANIMSCR),a1,L
	cmp	a1,a14
	jrnz	aws9		;we are changed
	move	*a0+,a14,L
	move	a14,*a8(ANIMFRM),L
	jruc	aws9
kwg1	move	*a8(ANIMARG),a0,L
	move	*a0+,a14,L
	move	*a8(ANIMSCR),a1,L
	cmp	a1,a14
	jrnz	aws9		;we are changed
	move	*a0(020h),a14,L
	move	a14,*a8(ANIMFRM),L	;branch to here on score
	jruc	aws9
aws5	move	*a8(ANIMARG),a0,L
	move	*a0+,a14,L
	move	*a8(ANIMSCR),a1,L
	cmp	a1,a14
	jrnz	aws9		;we are changed
	move	*a0(040h),a1,L
	movi	500,a0
	calla	RANDPER
	jrnc	aws9
	move	a1,*a8(ANIMFRM),L
aws9	rets

board_stand_up_script
ast0	LW	PLEXIB01,6
	LW	PLEXIB02,4
	LWL	1,AFUNC|1,a_clear_wc
	LW	PLEXIB03,1
ast1	LWLLLL	1,AFUNC|1,a_wait_score_wc+8,ast0,ast1,ast2,ast3
	LW	PLEXIB02,6
	LW	PLEXIB01,6
	LWL	1,AFUNC|1,board_end_if+2,bsus1
bsus1	.long	0
ast2	LW	PLEXIA06,4		;on score go here
	LW	PLEXIA07,4
	LW	PLEXIA08,4
	LW	PLEXIA05,4
	LW	PLEXIA06,4
	LW	PLEXIA07,4
	LW	PLEXIA08,4
	LW	PLEXIA05,4
	LW	PLEXIA06,4
	LW	PLEXIA07,4
	LW	PLEXIA08,4
	LW	PLEXIA05,4
	LW	PLEXIA06,4
	LW	PLEXIA07,4
	LW	PLEXIA08,4
	LW	PLEXIA05,4
	LW	PLEXIA06,4
	LW	PLEXIA07,4
	LW	PLEXIA08,4
	LW	PLEXIA05,4
	LW	PLEXIA06,4
	LW	PLEXIA07,4
	LW	PLEXIA08,4
	LW	PLEXIA05,4
	LW	PLEXIA04,4
	LW	PLEXIA03,4
	LW	PLEXIA02,4
	LWL	1,AFUNC|1,board_end_if+2,awst29
awst29	.long	0
ast3	LW	PLEXIA05,4		;50% of no score go here
	LW	PLEXIA04,4
	LW	PLEXIA03,4
	LW	PLEXIA02,4
	LW	PLEXIE01,4
	LW	PLEXIE02,4
	LW	PLEXIE03,4
	LW	PLEXIE04,4
	LW	PLEXIE05,4
	LW	PLEXIE06,4
	LW	PLEXIE07,4
	LW	PLEXIE08,4
	LW	PLEXIE09,4
	LWL	1,AFUNC|1,board_end_if+2,awst39
awst39	.long	0

board_stand_and_clap_script
	LW	PLEXIA02,4
	LW	PLEXIA03,4
	LW	PLEXIA04,4
	LW	PLEXIA05,4
	LW	PLEXIA06,4
	LW	PLEXIA07,4
	LW	PLEXIA08,4
	LW	PLEXIA05,4
	LW	PLEXIA06,4
	LW	PLEXIA07,4
	LW	PLEXIA08,4
	LW	PLEXIA05,4
	LW	PLEXIA06,4
	LW	PLEXIA07,4
	LW	PLEXIA08,4
	LW	PLEXIA05,4
	LW	PLEXIA06,4
	LW	PLEXIA07,4
	LW	PLEXIA08,4
	LW	PLEXIA05,4
	LW	PLEXIA06,4
	LW	PLEXIA07,4
	LW	PLEXIA08,4
	LW	PLEXIA05,4
	LW	PLEXIA06,4
	LW	PLEXIA07,4
	LW	PLEXIA08,4
	LW	PLEXIA05,4
	LW	PLEXIA05,4
	LW	PLEXIA04,4
	LW	PLEXIA03,4
	LW	PLEXIA02,4
	LWL	1,AFUNC|1,board_end_if+2,bsace
bsace	.long	0

board_clap_script
	LW	PLEXIC01,4
	LW	PLEXIC02,4
	LW	PLEXIC03,4
	LW	PLEXIC01,4
	LW	PLEXIC02,4
	LW	PLEXIC03,4
	LW	PLEXIC01,4
	LW	PLEXIC02,4
	LW	PLEXIC03,4
	LW	PLEXIC01,4
	LW	PLEXIC02,4
	LW	PLEXIC03,4
	LW	PLEXIC01,4
	LW	PLEXIC02,4
	LW	PLEXIC03,4
	LW	PLEXIC01,4
	LW	PLEXIC02,4
	LW	PLEXIC03,4
	LW	PLEXIC01,4
	LW	PLEXIC02,4
	LW	PLEXIC03,4
	LW	PLEXIC01,4
	LW	PLEXIC02,4
	LW	PLEXIC03,4
	LWL	1,AFUNC|1,board_end_if+2,bcas_e
bcas_e	.long	0

board_stand_and_turn_wave_script
	LW	PLEXIA02,4
	LW	PLEXID01i1,4
	LW	PLEXID01i2,4
	LW	PLEXID01,4
	LW	PLEXID02,4
	LW	PLEXID03,4
	LW	PLEXID04,4
	LW	PLEXID05,4
	LW	PLEXID06,4
	LW	PLEXID01,4
	LW	PLEXID02,4
	LW	PLEXID03,4
	LW	PLEXID04,4
	LW	PLEXID05,4
	LW	PLEXID06,4
	LW	PLEXID01,4
	LW	PLEXID02,4
	LW	PLEXID03,4
	LW	PLEXID04,4
	LW	PLEXID05,4
	LW	PLEXID06,4
	LW	PLEXID01,4
	LW	PLEXID02,4
	LW	PLEXID03,4
	LW	PLEXID04,4
	LW	PLEXID05,4
	LW	PLEXID06,4
	LW	PLEXIA02,4
	LW	PLEXID01,4
	LWL	1,AFUNC|1,board_end_if+2,bstwt
bstwt	.long	0

board_hit_good_script
	LW	SLAM1,5
	LW	SLAM2,5
	LW	SLAM3,5
	LW	SLAM4,2
	LW	PLXSLAM5,3
	LW	SLAM6,2
	LW	SLAM7,3
	LW	SLAM8,2
	LW	SLAM7,1
	LW	SLAM6,2
	LW	PLEXIC01,4
	LW	PLEXIC02,4
	LW	PLEXIC03,4
	LW	PLEXIC01,4
	LW	PLEXIC02,4
	LW	PLEXIC03,4
	LW	PLEXIC01,4
	LW	PLEXIC02,4
	LW	PLEXIC03,4
	LW	PLEXIC01,4
	LW	PLEXIC02,4
	LW	PLEXIC03,4
	LWL	1,AFUNC|1,board_end_if+2,bhg_e
bhg_e	.long	0

board_hit_bad_script
	LW	SLAM1,5
	LW	SLAM2,5
	LW	SLAM3,5
	LW	SLAM4,2
	LW	PLXSLAM5,3
	LW	SLAM6,2
	LW	SLAM7,3
	LW	SLAM8,2
	LW	SLAM7,1
	LW	SLAM6,2
	LW	PLEXIE01,4
	LW	PLEXIE02,4
	LW	PLEXIE03,4
	LW	PLEXIE04,4
	LW	PLEXIE05,4
	LW	PLEXIE06,4
	LW	PLEXIE07,4
	LW	PLEXIE08,4
	LW	PLEXIE09,4
	LWL	1,AFUNC|1,board_end_if+2,bhbs
bhbs	.long	0

board_glass_break_inner
bgbo0	LW	SLAMXR1,4
	LW	SLAMXR2,4
	LW	SLAMXR3,4
	LW	SLAMXR4,4
	LW	SLAMXR5,4
	LW	SLAMXR6,4
	LW	SLAMXR7,4
	LW	SLAMXR8,4
	LW	SLAMXR7,4
	LW	SLAMXR6,4
bgbo1	LWL	1,AFUNC|1,board_wait_offscreen+4,bgbo0,bgbo1
	LWL	1,AFUNC|1,board_end_if+2,bgbo2	;should wait until off screen
bgbo2	.long	0

board_wait_offscreen
	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrnz	bwo9
	move	*a8(ANIMARG),a1,L
	move	*a1+,a9,L
	move	*a8(ANIMSCR),a14,L
	cmp	a9,a14
	jrnz	bwo9
	move	*a1+,a14,L
	move	a14,*a8(ANIMFRM),L
bwo9	rets

board_end_if
	move	*a8(ANIMARG),a1,L
	move	*a1,a9,L
	move	*a8(ANIMFRM),a14,L
	cmp	a9,a14
	jrnz	bef1
	movi	board_stand_script,a1
	move	a1,*a8(ANIMFRM),L
	move	a1,*a8(ANIMSCR),L
bef1	rets

board_stand_script
	LW	PLEXIB01,4
	LW	PLEXIB02,5
	LW	PLEXIB03,7
	LW	PLEXIB02,3
	.long	0

edge_bounce
	move	@back_wall_script,a14,L
	jrnz	ebnc9
	movi	edbsc,a14
	move	a14,@edge_28_script,L
ebnc9	rets

edbsc	.long	DSIDEB28c,DSIDEB28c,DSIDEB28c
	.long	DSIDEB28d,DSIDEB28d
	.long	DSIDEB28,DSIDEB28
	.long	DSIDEB28f,DSIDEB28f
	.long	DSIDEB28g
	.long	DSIDEB28f,DSIDEB28f
	.long	DSIDEB28,DSIDEB28
	.long	DSIDEB28e,DSIDEB28e
	.long	DSIDEB28d,DSIDEB28d
	.long	DSIDEB28e,DSIDEB28e
	.long	DSIDEB28
	.long	DSIDEB28f,DSIDEB28f
	.long	DSIDEB28
	.long	DSIDEB28e
	.long	DSIDEB28
	.long	DSIDEB28f
	.long	DSIDEB28
	.long	0

wall_goal
	move	@team_scored,a14,W
	cmpi	1,a14
	jrz	wgt1
	movi	wgcbt2b,a14
	move	a14,@back_wall_script,L
	clr	a14
	move	a14,@edge_28_script,L
	rets
wgt1	movi	wgcbt1b,a14
	move	a14,@back_wall_script,L
	clr	a14
	move	a14,@edge_28_script,L
	rets

update_walls
	move	@WAVEIRQS,a14,W
	sll	31,a14			;1/2
	jrnz	bbs9
	move	@back_wall_script,a3,L
	jrz	bbsc28
	move	*a3+,a2,L
	jrz	bbsd9
	move	a3,@back_wall_script,L
	move	*a2+,a14,L
	move	a14,@edge_28_piece,L
	move	@SUPPLSTS+3*020h,a1,L
	jrz	bbs9
bbs1	move	*a2+,a14,L
	move	a14,*a1(OIMG),L
	move	*a14(ISAG),a14,L
	move	a14,*a1(OSAG),L
	move	*a1(OSLINK),a1,L
	jrnz	bbs1
bbs9	rets
bbsd9	clr	a14
	move	a14,@back_wall_script,L
	rets
bbsc28	move	@edge_28_script,a3,L
	jrz	bbs9
	move	*a3+,a2,L
	jrz	bbs289
	move	a3,@edge_28_script,L
	move	a2,@edge_28_piece,L
	rets
bbs289	clr	a14
	move	a14,@edge_28_script,L
	rets

wgcbt0	.long	bbacc,bbacc
	.long	bbbcc,bbbcc
	.long	bbacc,bbacc
	.long	bbbcc,bbbcc,bbbcc
	.long	bbacc,bbacc,bbacc
	.long	bbbcc,bbbcc,bbbcc
	.long	bbacc,bbacc,bbacc,bbacc
	.long	bbbcc,bbbcc
	.long	bbacc,bbacc
	.long	bbbcc,bbbcc,bbbcc
	.long	bbacc,bbacc,bbacc
	.long	bbbcc,bbbcc,bbbcc
	.long	bbacc,bbacc,bbacc,bbacc
	.long	bbbcc,bbbcc
	.long	bbacc,bbacc
	.long	bbbcc,bbbcc,bbbcc
	.long	bbacc,bbacc,bbacc
	.long	bbbcc,bbbcc,bbbcc
	.long	bbbcc,bbbcc
	.long	bbacc,bbacc
	.long	bbbcc,bbbcc,bbbcc
	.long	bbacc,bbacc,bbacc
	.long	bbbcc,bbbcc,bbbcc
	.long	bbacc
	.long	bbacc
	.long	0


wgcbt1	.long	bbaec,bbaec
	.long	bbbfc,bbbfc
	.long	bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec,bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec,bbaec,bbaec,bbaec
	.long	bbbfc,bbbfc
	.long	bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec,bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec,bbaec,bbaec,bbaec
	.long	bbbfc,bbbfc
	.long	bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec,bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbbfc,bbbfc
	.long	bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec,bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec
	.long	bbacc
	.long	0

wgcbt1b	.long	bbaec,bbaec
	.long	bbbfc,bbbfc
	.long	bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec,bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec,bbaec,bbaec,bbaec
	.long	bbbfc,bbbfc
	.long	bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec,bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec,bbaec,bbaec,bbaec
	.long	bbbfc,bbbfc
	.long	bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec,bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbbfc,bbbfc
	.long	bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbaec,bbaec,bbaec
	.long	bbbfc,bbbfc,bbbfc
	.long	bbbfc,bbbfh
	.long	bbaeh,bbaeh
	.long	bbbfi,bbbfi,bbbfi
	.long	bbaej,bbaej,bbaej
	.long	bbbfj,bbbfj,bbbfj
	.long	bbaej
	.long	bbacc
	.long	0

wgcbt2	.long	bbace,bbace
	.long	bbbcf,bbbcf
	.long	bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace,bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace,bbace,bbace,bbace
	.long	bbbcf,bbbcf
	.long	bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace,bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace,bbace,bbace,bbace
	.long	bbbcf,bbbcf
	.long	bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace,bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbbcf,bbbcf
	.long	bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace,bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace
	.long	bbacc
	.long	0

wgcbt2b	.long	bbace,bbace
	.long	bbbcf,bbbcf
	.long	bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace,bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace,bbace,bbace,bbace
	.long	bbbcf,bbbcf
	.long	bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace,bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace,bbace,bbace,bbace
	.long	bbbcf,bbbcf
	.long	bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace,bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbbcf,bbbcf
	.long	bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbace,bbace,bbace
	.long	bbbcf,bbbcf,bbbcf
	.long	bbbcf,bbbhf
	.long	bbahe,bbahe
	.long	bbbif,bbbif,bbbif
	.long	bbaje,bbaje,bbaje
	.long	bbbjf,bbbjf,bbbjf
	.long	bbaje
	.long	bbacc
	.long	0

bbacc	.long	DSIDEB28
	.long	CSECS01,CSECS02,CSECS03,CSECS04,CSECS05
	.long	CSECS06c,CSECS07c,CSECS08c
	.long	CSECS09c,CSECS010c,CSECS011c
	.long	CSECS12,CSECS13,CSECS14,CSECS15,CSECS16,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17,CSECS17,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17

bbbcc	.long	DSIDEB28b
	.long	CSECS01b,CSECS02b,CSECS03b,CSECS04b,CSECS05b
	.long	CSECS06c,CSECS07c,CSECS08c
	.long	CSECS09c,CSECS010c,CSECS011c
	.long	CSECS12b,CSECS13b,CSECS14b,CSECS15b,CSECS16b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b

bbaec	.long	DSIDEB28
	.long	CSECS01,CSECS02,CSECS03,CSECS04,CSECS05
	.long	CSECS06e,CSECS07e,CSECS08e
	.long	CSECS09c,CSECS010c,CSECS011c
	.long	CSECS12,CSECS13,CSECS14,CSECS15,CSECS16,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17,CSECS17,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17

bbbfc	.long	DSIDEB28b
	.long	CSECS01b,CSECS02b,CSECS03b,CSECS04b,CSECS05b
	.long	CSECS06f,CSECS07f,CSECS08f
	.long	CSECS09c,CSECS010c,CSECS011c
	.long	CSECS12b,CSECS13b,CSECS14b,CSECS15b,CSECS16b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b

bbace	.long	DSIDEB28
	.long	CSECS01,CSECS02,CSECS03,CSECS04,CSECS05
	.long	CSECS06c,CSECS07c,CSECS08c
	.long	CSECS09e,CSECS010e,CSECS011e
	.long	CSECS12,CSECS13,CSECS14,CSECS15,CSECS16,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17,CSECS17,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17

bbbcf	.long	DSIDEB28b
	.long	CSECS01b,CSECS02b,CSECS03b,CSECS04b,CSECS05b
	.long	CSECS06c,CSECS07c,CSECS08c
	.long	CSECS09f,CSECS10f,CSECS11f
	.long	CSECS12b,CSECS13b,CSECS14b,CSECS15b,CSECS16b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b

bbaeh	.long	DSIDEB28
	.long	CSECS01,CSECS02,CSECS03,CSECS04,CSECS05
	.long	CSECS06e,CSECS07e,CSECS08e
	.long	CSECS09h,CSECS10h,CSECS11h
	.long	CSECS12,CSECS13,CSECS14,CSECS15,CSECS16,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17,CSECS17,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17

bbaei	.long	DSIDEB28
	.long	CSECS01,CSECS02,CSECS03,CSECS04,CSECS05
	.long	CSECS06e,CSECS07e,CSECS08e
	.long	CSECS09i,CSECS10i,CSECS11i
	.long	CSECS12,CSECS13,CSECS14,CSECS15,CSECS16,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17,CSECS17,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17

bbaej	.long	DSIDEB28
	.long	CSECS01,CSECS02,CSECS03,CSECS04,CSECS05
	.long	CSECS06e,CSECS07e,CSECS08e
	.long	CSECS09j,CSECS10j,CSECS11j
	.long	CSECS12,CSECS13,CSECS14,CSECS15,CSECS16,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17,CSECS17,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17

bbbfh	.long	DSIDEB28b
	.long	CSECS01b,CSECS02b,CSECS03b,CSECS04b,CSECS05b
	.long	CSECS06f,CSECS07f,CSECS08f
	.long	CSECS09h,CSECS10h,CSECS11h
	.long	CSECS12b,CSECS13b,CSECS14b,CSECS15b,CSECS16b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b

bbbfi	.long	DSIDEB28b
	.long	CSECS01b,CSECS02b,CSECS03b,CSECS04b,CSECS05b
	.long	CSECS06f,CSECS07f,CSECS08f
	.long	CSECS09i,CSECS10i,CSECS11i
	.long	CSECS12b,CSECS13b,CSECS14b,CSECS15b,CSECS16b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b

bbbfj	.long	DSIDEB28b
	.long	CSECS01b,CSECS02b,CSECS03b,CSECS04b,CSECS05b
	.long	CSECS06f,CSECS07f,CSECS08f
	.long	CSECS09j,CSECS10j,CSECS11j
	.long	CSECS12b,CSECS13b,CSECS14b,CSECS15b,CSECS16b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b

bbahe	.long	DSIDEB28
	.long	CSECS01,CSECS02,CSECS03,CSECS04,CSECS05
	.long	CSECS06h,CSECS07h,CSECS08h
	.long	CSECS09e,CSECS010e,CSECS011e
	.long	CSECS12,CSECS13,CSECS14,CSECS15,CSECS16,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17,CSECS17,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17

bbaie	.long	DSIDEB28
	.long	CSECS01,CSECS02,CSECS03,CSECS04,CSECS05
	.long	CSECS06i,CSECS07i,CSECS08i
	.long	CSECS09e,CSECS010e,CSECS011e
	.long	CSECS12,CSECS13,CSECS14,CSECS15,CSECS16,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17,CSECS17,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17

bbaje	.long	DSIDEB28
	.long	CSECS01,CSECS02,CSECS03,CSECS04,CSECS05
	.long	CSECS06j,CSECS07j,CSECS08j
	.long	CSECS09e,CSECS010e,CSECS011e
	.long	CSECS12,CSECS13,CSECS14,CSECS15,CSECS16,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17,CSECS17,CSECS17
	.long	CSECS17,CSECS17,CSECS17,CSECS17

bbbhf	.long	DSIDEB28b
	.long	CSECS01b,CSECS02b,CSECS03b,CSECS04b,CSECS05b
	.long	CSECS06h,CSECS07h,CSECS08h
	.long	CSECS09f,CSECS10f,CSECS11f
	.long	CSECS12b,CSECS13b,CSECS14b,CSECS15b,CSECS16b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b

bbbif	.long	DSIDEB28b
	.long	CSECS01b,CSECS02b,CSECS03b,CSECS04b,CSECS05b
	.long	CSECS06i,CSECS07i,CSECS08i
	.long	CSECS09f,CSECS10f,CSECS11f
	.long	CSECS12b,CSECS13b,CSECS14b,CSECS15b,CSECS16b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b

bbbjf	.long	DSIDEB28b
	.long	CSECS01b,CSECS02b,CSECS03b,CSECS04b,CSECS05b
	.long	CSECS06j,CSECS07j,CSECS08j
	.long	CSECS09f,CSECS10f,CSECS11f
	.long	CSECS12b,CSECS13b,CSECS14b,CSECS15b,CSECS16b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b,CSECS17b
	.long	CSECS17b,CSECS17b,CSECS17b,CSECS17b
