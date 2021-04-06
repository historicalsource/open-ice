 	.MLIB	"HHMACS.LIB"
	.FILE	"HHCONTROL.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhcontrl.tbl"
	.include	"hhmath.g"
	.include	"hhproc.g"
	.include	"hhplayer.g"
	.include	"hhpuck.g"
	.include	"hhgame.g"
	.include	"hhmisc.g"
	.include	"hhcontrl.e"
	.include	"hhutil.g"
	.include	"hhram.g"
	.include	"hh.g"
	.include	"hhd.g"
	.include	"hhselect.g"
	.include	"hhc.g"
	.include	"hhshow.g"
	.include	"hhgdrone.g"
	.include	"hhgscr.g"
	.include	"hhgscr2.g"
	.include	"hhhigher.g"
	.include	"hhspeech.g"
	.include	"hhcontr2.g"
	.include	"hhscr_sh.g"
	.include	"hhscr_ch.g"
	.include	"hhscr_sk.g"
	.include	"hhscr_ms.g"
	.include	"hhndrone.g"
	.include	"hhtimer.g"
	.include	"hhpup.g"
	.include	"hhcontr3.g"
	.include	"hhscrchf.g"
	.include	"hhstabl2.g"

; end of include files

	.TEXT
	.EVEN

	.bss	no_control,16		;we can't control anyone (do not use ever again)
	.bss	global_control_slow,32

	.bss	whack_goalie_count,16

control_player	;a10 = player number
cp0	move	a10,a0				;we still need it in a0 and a10
	GBLOCK	a0,a6
	calla	get_offense_mode
	cmpi	1,a1
	jrz	cpdf
	clr	a14		;speed boost
	clr	a2		;skid boost
	move	@PUCK_CONTROL,a1,W
	cmp	a1,a10
	jrnz	cpnd

	move	*a6(POF_PUP_FLAGS),a14,W
	btst	B_PUP_SPEED,a14
	jrz	nopups
	movi	pspeed_data_powered,a14
	jruc	yspups			;power up speed
nopups	move	*a6(POF_S_SPED),a14,L
yspups	move	*a14(PS_SP_CONTROL_PENALTY),a14,L
	.if	NO_PUCK_HOG
	.else
	move	@global_control_slow,a8,L	;zero, unless we are hogging the puck
	add	a8,a14
	.endif
	neg	a14
	jruc	cpnd
cpdf	move	*a6(POF_S_STOP),a2,L
	movb	*a2(PS_ST_DEFENSE_SKID),a2

	move	*a6(POF_PUP_FLAGS),a14,W
	btst	B_PUP_SPEED,a14
	jrz	nop1ps
	movi	pspeed_data_powered,a14
	jruc	ysp1ps			;power up speed
nop1ps	move	*a6(POF_S_SPED),a14,L
ysp1ps	move	*a14(PS_SP_DEFENSE_BOOST),a14,L
cpnd	movb	a2,*a6(POF_SKID_BOOST)
	move	a14,*a6(POF_SPEED_BOOST),L
	move	*a6(POF_OBJECT),a8,L
	move	@no_control,a14,W
	jrnz	control_player_higher	;do not ever do this again
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HIGHER,a14
	jrnz	control_player_higher	;must have flags in a14
	btst	B_PF_HUMAN,a14
	jrz	control_player_drone

;	callr	delete_cpuarrow_if	;can be very slow
	clr	a14
	move	a14,*a6(POF_DRONE_BUTTONS),W	;wipe out any drone signals

	callr	read_joystick
	calla	update_turbo		;can be slow
;	move	*a6(POF_FLAGS),a14,W
;	btst	B_PF_CONTROL,a14
;	jrz	skpotc
	calla	one_timer_check
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrnz	ccp1
skpotc	btst	B_PF_CONTROLM,a14
	jrz	control_player_nc			;br=no control
ccp1	move	@GAME_STATE,a14,W
	cmpi	INPLAY,a14			;if period is over, no control
	jrnz	control_player_ncnt
	callr	are_we_intended
	jrc	cpnolog
	callr	move_player
	callr	face_player
	jruc	cpsps
cpnolog	mmtm	sp,a10
	callr	line_up_for_pass
	mmfm	sp,a10
cpsps	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrnz	ccp2
	btst	B_PF_CONTROLB,a14
	jrz	end_of_player
ccp2	callr	set_player_script
end_of_player
	calla	fix_players_arrow	;can be slow
	calla	fix_players_trail
	callr	fix_player_below
	SLEEP	1
	jruc	cp0

fix_player_below		;safety on below ice
	move	*a6(POF_OBJECT),a8,L
	move	*a8(OYPOS),a14,W
	cmpi	10,a14
	jrlt	fpb9
	clr	a14
	move	a14,*a8(OYACCEL),W
	move	a14,*a8(OYVEL),L
	move	a14,*a8(OYVAL),L
fpb9	rets

clean_up_players
	move	@PUCK_CONTROL,a0,W	;first place puck
	jrz	ppwp_9
	GBLOCK	a0,a6
	move	*a6(POF_MODE),a0,W
	cmpi	PM_ONETIME,a0
	jrz	ppwp_9			;if we are onetiming, we don't place puck

	move	@PUCK_OBJECT,a9,L
	MOVE	*A9(ODT_PFLAGS),A14,W
	btst	B_INBACK,a14
	jrnz	putbhd
	BTST	B_INFRONT,A14
	JRZ	CUP_NORM			;BR=DON'T FORCE PUCK IN FRONT
	calla	get_players_puck_point_bz
	subi	200,a1
	JRUC	CUP_SETPOS
putbhd	calla	get_players_puck_point_bz
	addi	200,a1
	JRUC	CUP_SETPOS
CUP_NORM
	calla	get_players_puck_point_b
	clr	a2
CUP_SETPOS
	calla	put_point_in_rink
	callr	fix_front_back_goal

	move	a2,*a9(OYVAL),L
	move	a0,*a9(OXVAL),L		;store to pucks position
	move	a1,*a9(OZVAL),L
	move	*a8(OXVEL),*a9(OXVEL),L	;copy velocities to puck
	move	*a8(OXVEL),*a9(ODT_REALXVEL),L
	move	*a8(OYVEL),*a9(OYVEL),L	;to minimize puck drift between updates
	move	*a8(OZVEL),*a9(OZVEL),L
	move	*a8(ODT_DIR),*a9(ODT_DIR),L
	move	*a8(ODT_VEL),*a9(ODT_VEL),L
ppwp_9	movi	plblcklst,a10		;fix all players shadows
	movi	[4700,0],a11
fpr2	move	*a10+,a6,L
	jrz	fps_09
	movb	*a6(POF_IGNORE_PUCK),a14	;dec the ignore puck count
	jrz	dip_9
	dec	a14
	movb	a14,*a6(POF_IGNORE_PUCK)
dip_9
	move	*a6(POF_OBJECT),a9,L
	move	*a6(POF_SHADOW),a8,L
	callr	shad_do
	jruc	fpr2
fps_09	rets

fix_front_back_goal	;a8 = player
			;a0, a1 = puck point
	move	*a8(OZVAL),a3,L
	cmpi	TOP_GOALPOST_Z+[50,0],a3
	jrgt	ffbg8
	cmpi	BOT_GOALPOST_Z-[50,0],a3
	jrlt	ffbg8
	move	*a8(OXVAL),a4,L
	move	a4,a14
	abs	a14
	cmpi	RGHT_GOALLINE_X-[120,0],a14
	jrlt	ffbg8
	move	a0,a5	;now check more closely
	abs	a5
	cmpi	RGHT_GOALLINE_X,a14
	jrgt	ffb_pr
	cmpi	RGHT_GOALLINE_X,a5
	jrlt	ffbg8		;we are inside of goal line, nothing
	callr	ffbgcgl		;check across goal line
	jruc	ffbg8
ffb_pr	cmpi	RGHT_GOALLINE_X+GOAL_DEPTH_X,a14
	jrlt	ffb_in
	cmpi	RGHT_GOALLINE_X+GOAL_DEPTH_X,a5
	jrgt	ffbg8		;we are outside of goal line+depth, nothing
	callr	ffbgcdp		;check across goal line depth
	jruc	ffbg8
ffb_in
ffbg8	rets

ffbgcdp	mmtm	sp,a0,a1,a2
	abs	a0
	sra	16,a0
	movy	a1,a0		;puck
	move	a14,a1
	sra	16,a1
	movy	a3,a1		;player
	movi	(RGHT_GOALLINE_X+GOAL_DEPTH_X)>>16,a2
	calla	get_z_from_x_midpoint
	sra	16,a2
	cmpi	(TOP_GOALPOST_Z>>16)+5,a2
	jrgt	ffbd_8
	cmpi	(BOT_GOALPOST_Z>>16)-5,a2
	jrlt	ffbd_8
	mmfm	sp,a0,a1,a2
	move	a3,a1
	movi	RGHT_GOALLINE_X+GOAL_DEPTH_X,a0
	move	a4,a4
	jrnn	ffbd2
	neg	a0
ffbd2	clr	a2
	setc
	rets
ffbd_8	mmfm	sp,a0,a1,a2
	clrc
	rets

ffbgcgl	mmtm	sp,a0,a1,a2
	abs	a0
	sra	16,a0
	movy	a1,a0		;puck
	move	a14,a1
	sra	16,a1
	movy	a3,a1		;player
	movi	RGHT_GOALLINE_X>>16,a2
	calla	get_z_from_x_midpoint
	sra	16,a2
	cmpi	(TOP_GOALPOST_Z>>16)+5,a2
	jrgt	ffbg_8
	cmpi	(BOT_GOALPOST_Z>>16)-5,a2
	jrlt	ffbg_8
	mmfm	sp,a0,a1,a2
	move	a3,a1
	movi	RGHT_GOALLINE_X,a0
	move	a4,a4
	jrnn	ffbg2
	neg	a0
ffbg2	clr	a2
	setc
	rets
ffbg_8	mmfm	sp,a0,a1,a2
	clrc
	rets

**************************************************************************
*								         *
* shad_do								 *
*								         *
**************************************************************************
shad_do	move	*a9(OXVAL),*a8(OXVAL),L
	clr	a14
	move	a14,*a8(OYVAL),L
;	move	*a9(OYVAL),*a8(OYVAL),L
	move	*a9(OZVAL),a4,L
	move	a4,a14
	add	a11,a4		;4700,0
	move	a4,*a8(OZVAL),L
	move	*a9(OXVEL),*a8(OXVEL),L
	move	*a9(OZVEL),*a8(OZVEL),L
	sra	20,a14

	.if	DEBUG
	CMPI	-5,A14
	LOCKON	LT
	CMPI	54,A14
	LOCKON	GT
	.endif

	sll	5,a14
	addi	z_shad_table,a14
	move	*a14,a1,L
	move	*a8(OIMG),a14,L
	cmp	a14,a1
	jrz	fpfpr2
	move	*a8(OCTRL),a4,W
	jauc	ANI
fpfpr2	rets


plblcklst
	.long	PLAYER_1_BLOCK
	.long	PLAYER_2_BLOCK
	.long	PLAYER_4_BLOCK
	.long	PLAYER_5_BLOCK
	.long	PLAYER_6_BLOCK
	.long	PLAYER_8_BLOCK
	.long	0

	.long	shadow3		;-80
	.long	shadow3		;-64
	.long	shadow3		;-48
	.long	shadow3		;-32
	.long	shadow3		;-16
z_shad_table
	.long	shadow3		;0
	.long	shadow3		;16
	.long	shadow3		;32
	.long	shadow3		;48
	.long	shadow4		;64
	.long	shadow4		;80
	.long	shadow4		;96
	.long	shadow4		;112
	.long	shadow4		;128
	.long	shadow5		;144
	.long	shadow5		;160
	.long	shadow5		;176
	.long	shadow5		;192
	.long	shadow6		;208
	.long	shadow6		;224
	.long	shadow6		;240
	.long	shadow6		;256
	.long	shadow6		;272
	.long	shadow7		;288
	.long	shadow7		;304
	.long	shadow7		;320
	.long	shadow7		;336
	.long	shadow8		;352
	.long	shadow8		;368
	.long	shadow8		;384
	.long	shadow8		;400
	.long	shadow8		;416
	.long	shadow9		;432
	.long	shadow9		;448
	.long	shadow9		;464
	.long	shadow9		;480
	.long	shadow10	;496
	.long	shadow10	;512
	.long	shadow10	;528
	.long	shadow10	;544
	.long	shadow10	;560
	.long	shadow11	;576
	.long	shadow11	;592
	.long	shadow11	;608
	.long	shadow11	;624
	.long	shadow12	;640
	.long	shadow12	;656
	.long	shadow12	;672
	.long	shadow12	;688
	.long	shadow12	;704
	.long	shadow12	;720
	.long	shadow12	;736
	.long	shadow12	;752
	.long	shadow12	;768
	.long	shadow12	;784
	.long	shadow12	;800
	.long	shadow12	;716
	.long	shadow12	;732
	.long	shadow12	;748
	.long	shadow12	;764

;delete_cpuarrow_if
;	move	*a6(POF_ARROW_CPU),a7,L
;	jrz	nocpu3
;	move	@BABY_SIZE,a14,W
;	jrz	nocpu3
;	movi	3000,a14
;	move	a14,*a7(OXPOS),W		;put it off the screen
;	move	*a7(OCTRL),a14,W
;	ori	DMAGO,a14		;turn it on
;	move	a14,*a7(OCTRL),W
;	PUSH	a8
;	move	a7,a8
;	calla	DELETE_OBJ		;kill it
;	PULLQ	a8
;	clr	a14
;	move	a14,*a6(POF_ARROW_CPU),L	;don't do it again
;	move	a14,*a6(POF_DRONE_BUTTONS),W	;wipe out any drone signals
;nocpu3	rets

;;;delete_cpuarrow_if
;;;	move	*a6(POF_ARROW_CPU),a7,L
;;;	jrz	nocpu3
;;;	movi	3000,a0
;;;	move	a0,*a7(OXPOS),W		;put it off the screen
;;;	move	*a7(OCTRL),a0,W
;;;	ori	DMAGO,a0		;turn it on
;;;	move	a0,*a7(OCTRL),W
;;;	PUSH	a8
;;;	move	a7,a8
;;;	calla	DELETE_OBJ		;kill it
;;;	PULLQ	a8
;;;	clr	a0
;;;	move	a0,*a6(POF_ARROW_CPU),L	;don't do it again
;;;	move	a0,*a6(POF_DRONE_BUTTONS),W	;wipe out any drone signals
;;;nocpu3	rets

control_player_ncnt
	calla	update_turbo_up		;can be slow
	clr	a0
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OZVEL),L
	move	a0,*a8(ODT_VEL),L
	calla	set_stand_script
	;fall through
control_player_nc			;it is a human player, but a script has control
	clr	a14
	movb	a14,*a6(POF_STAND_STILL)
	jruc	end_of_player
control_player_drone
	calla	update_turbo_drone
	calla	one_timer_check
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	cpd_nc
	calla	do_drone_logic		;does the line up for pass for us
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	cpd_nc
	callr	are_we_intended
	jrc	cpd_1
	callr	face_player
	callr	set_player_script
	jruc	cpd_1
cpd_nc	clr	a14
	movb	a14,*a6(POF_STAND_STILL)
cpd_1	callr	drone_rink_check
	jruc	end_of_player

control_player_higher
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrnz	cph_1
	calla	update_turbo_drone	;can be slow
	jruc	cph_2
cph_1	calla	update_turbo_up		;can be slow
;;;	callr	delete_cpuarrow_if	;can be slow
	move	*a6(POF_NUMBER),a0
	callr	read_joystick_short
cph_2	callr	drone_rink_check
	jruc	end_of_player

move_player
	move	*a6(POF_OBJECT),a8,L	;object in a8
	movb	*a6(POF_M_JOY),a0
	jrnz	mp1				;if we are not centered, do our conversion
	dec	a0				;else a0 is -1
	jruc	mp2
mp1	calla	dir_to_degrees		;direction to move in a0
mp2	move	*a6(POF_TURBO_MODE),a1,W
move_player_dir
;	callr	are_we_intended
	move	a1,*a8(ODT_TURBO),W
	move	a1,a1
	jrz	mskr8			;skate rate 0
	movk	1,a1
mskr8	movb	a1,*a6(POF_SKATE_RATE_G)
	move	a0,a0
	jrn	stop_player			;our joystick is centered
	move	a0,*a8(ODT_GDIR),L
	move	*a6(POF_S_STOP),a1,L
	move	*a1(PS_ST_RSTOP_THRESH),a14,L
	move	*a8(ODT_VEL),a0,L
	cmp	a14,a0
	jrls	move_player_exactly		;we are below our reverse stop threshold
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	mskdd
	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrnz	move_player_exactly		;we are human, we are offscreen, we stop on a dime
mskdd	move	*a8(ODT_DIR),a1,L
	move	*a8(ODT_GDIR),a0,L
	sub	a1,a0
	THETA_H	a0
	move	a0,a2				;save our angular distance in a2
	jrz	move_player_exactly		;we are moving in our goal direction, so keep it up
	move	*a6(POF_S_CORN),a7,L
	abs	a0
	move	*a7(PS_CR_SKID),a1,L
	cmp	a1,a0
	jrhi	skid_to_reverse_player		;we are turning by too great an angle, skid to stop(reverse) first
	move	*a7(PS_CR_TURN_TABLE_D),a9,L	;defense table
	movb	*a6(POF_NUMBER),a0
	calla	get_offense_mode
	cmpi	1,a1
	jrz	tt_d				;if we are defense, we are done
	move	*a7(PS_CR_TURN_TABLE),a9,L
	move	a1,a1
	jrz	tt_d				;if we are offense, we are done
	mmtm	sp,a0,a1,a2,a3,a4
	move	*a8(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
	move	*a8(OZPOS),a1,W
	move	@PUCK_OBJECT,a14,L
	move	*a14(OXVAL),a2,L
	addi	[0,08000h],a2
	sra	16,a2
	move	*a14(OZPOS),a3,W
	calla	find_dist_quick
	cmpi	100,a4
	mmfm	sp,a0,a1,a2,a3,a4
	jrhi	tt_d				;if open, and we are far, use offense table
	move	*a7(PS_CR_TURN_TABLE_C),a9,L	;use close open table
tt_d	move	a2,a2			;here a2 is the angular difference between where we are and where we want to be
	jrn	mp_neg			;we are turning negative

mpp1	move	*a9,a0,L		;we are turning positive
	cmp	a0,a2
	jrls	mpp2
	addi	96,a9
	jruc	mpp1
mpp2	move	*a8(ODT_DIR),a4,L	;ang direction
	move	*a8(ODT_DVEL),a0,L	;ang vel.
	move	*a8(ODT_GDIR),a5,L	;goal direction
	move	*a9(020h),a1,L		;ang. acc
	move	*a9(040h),a3,L		;max ang. vel
	add	a1,a0		;vel = old vel + acc
	cmp	a3,a0		;if > max
	jrls	mpp3
	move	a3,a0		;then it is max
mpp3	move	a0,*a8(ODT_DVEL),L	;new ang vel.
	add	a0,a4			;new angular direction
;now check if we passed our destination, careful of wraparound at 360
	cmpi	XD0900,a5		;if goal < 90
	jrhi	mpp4
	THETA_N	a4			;normalize new direction
	cmpi	XD1800,a4		;if angle > 180
	jrhi	mpp10			; then we haven't passed it up
	cmp	a5,a4			;if > our destination
	jrhi	mpp9			; then we did pass it up
	jruc	mpp10			; else we haven't
mpp4	cmpi	XD1800,a5		;if goal < 180
	jrhi	mpp5
	THETA_N	a4			;normalize new direction
	cmpi	XD2700,a4		;if angle > 270
	jrhi	mpp10			; then we haven't passed it up
mpp5	cmp	a5,a4			;if > our destination
	jrhi	mpp9			; then we did pass it up
	jruc	mpp10			; else we haven't

mp_neg	neg	a2		;make it positive
mpn1	move	*a9,a0,L
	cmp	a0,a2
	jrls	mpn2
	addi	96,a9
	jruc	mpn1
mpn2	neg	a2		;make it negative again
	move	*a8(ODT_DIR),a4,L	;ang direction
	move	*a8(ODT_DVEL),a0,L	;ang vel.
	move	*a8(ODT_GDIR),a5,L	;goal direction
	move	*a9(020h),a1,L		;ang. acc
	move	*a9(040h),a3,L		;max ang. vel
	neg	a3
	sub	a1,a0		;vel = old vel - acc
	cmp	a3,a0		;if || > |max|
	jrge	mpn3
	move	a3,a0		;then it is max
mpn3	move	a0,*a8(ODT_DVEL),L	;new ang vel.
	add	a0,a4			;new angular direction
;now check if we passed our destination, careful of wraparound at 360
	cmpi	XD0900,a5		;if goal < 90
	jrhi	mpn4
	THETA_N	a4			;normalize new direction
	cmpi	XD2700,a4		;if angle > 270
	jrhi	mpp9			; then we passed it up
	cmp	a5,a4			;if < our destination
	jrlo	mpp9			; then we did pass it up
	jruc	mpp10			; else we haven't
mpn4	cmpi	XD1800,a5		;if goal < 180
	jrlo	mpn5
	THETA_N	a4			;normalize new direction
	cmpi	XD0900,a4		;if angle < 90
	jrlo	mpp9			; then we passed it up
mpn5	cmp	a5,a4			;if < our destination
	jrlo	mpp9			; then we did pass it up
	jruc	mpp10			; else we haven't

move_player_exactly
	move	*a8(ODT_GDIR),a5,L
mpp9	move	a5,a4			;goal = new direction
	clr	a0
	move	a0,*a8(ODT_DVEL),L	;zero out angular velocity
mpp10	THETA_N	a4
	move	a4,*a8(ODT_DIR),L		;new direction
	move	*a6(POF_PUP_FLAGS),a7,W
	btst	B_PUP_SPEED,a7
	jrz	nop2ps
	movi	pspeed_data_powered,a7
	jruc	ysp2ps			;power up speed
nop2ps	move	*a6(POF_S_SPED),a7,L
ysp2ps	clr	a14
	movb	a14,*a6(POF_STAND_STILL)
	movk	1,a0
	move	a0,*a6(POF_MODE),W
	move	*a8(ODT_VEL),a1,L
	move	*a8(ODT_TURBO),a14,W		;we check object, not player
	jrnz	sa_t
sa_nt	move	*a7(PS_SP_S0_THRESH),a14,L
	cmp	a14,a1
	jrhs	as_nf0
	move	*a7(PS_SP_SPEED_0),a2,L	;based on our speed
	movb	*a7(PS_SP_SAME_0_MT),a3
	jruc	saae
as_nf0	move	*a7(PS_SP_SPEED_THRESH),a14,L
	cmp	a14,a1
	jrhs	as_nfst			;see which acceleration curve we use
	move	*a7(PS_SP_SPEED_1),a2,L	;based on our speed
	movb	*a7(PS_SP_SAME_L_MT),a3
	jruc	saae
as_nfst	move	*a7(PS_SP_SPEED_2),a2,L
	movb	*a7(PS_SP_SAME_H_MT),a3
	jruc	saae
sa_t	move	*a7(PS_SP_T0_THRESH),a14,L
	cmp	a14,a1
	jrhs	as_f0
	move	*a7(PS_SP_TURBO_0),a2,L	;based on our speed
	movb	*a7(PS_SP_SAME_0_MT),a3
	jruc	saae
as_f0	move	*a7(PS_SP_TURBO_THRESH),a14,L
	cmp	a14,a1
	jrhs	sa_fast			;see which acceleration curve we use
	move	*a7(PS_SP_TURBO_1),a2,L	;based on our speed
	movb	*a7(PS_SP_SAME_L_MT),a3
	jruc	saae
sa_fast	move	*a7(PS_SP_TURBO_2),a2,L
	movb	*a7(PS_SP_SAME_H_MT),a3
saae	move	*a6(POF_SPEED_BOOST),a14,L
	add	a14,a2
	move	a2,*a6(POF_SPEED_GL),L	;so we can see if we are speeding or slowing
	callr	move_to_s_no_r		;move to speed if we don't receive
	move	*a8(ODT_DIR),a0,L
	jauc	set_obj_to_polar_p

skid_to_reverse_player
	clr	a14
	move	a14,*a6(POF_QS_OK),W	;ok to go to quick start
	move	*a6(POF_S_STOP),a7,L
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_OKDIR,a14
	move	a14,*a6(POF_FLAGS),W
	clr	a14
	movb	a14,*a6(POF_STAND_STILL)
	move	*a6(POF_MODE),a0,W
	jrz	rsk1
	cmpi	PM_SKID,a0
	jrz	rsksh
	calla	slide_to_reverse_sound
rsk1	move	*a6(POF_NOFACE),a0,W
	cmpi	111011100b,a0
	jrz	rsksh
	movk	PM_SKID,a0
	move	a0,*a6(POF_MODE),W
rsksh	move	*a8(ODT_VEL),a1,L
	clr	a2
	movb	*a7(PS_ST_SKID_R_MT),a3
	move	*a8(ODT_TURBO),a14,W
	jrz	cpsake
	movb	*a7(PS_ST_TSKID_R_MT),a3
cpsake	movb	*a6(POF_SKID_BOOST),a14
	add	a14,a3
	callr	move_to_s_no_r		;move to speed if we don't receive
	move	*a8(ODT_DIR),a0,L
	jauc	set_obj_to_polar

stop_player
	clr	a14
	move	a14,*a6(POF_QS_OK),W	;ok to go to quick start
	move	*a8(ODT_DIR),*a8(ODT_GDIR),L	;our direction is our goal direction (helps pick skid script)
	move	*a6(POF_S_STOP),a7,L
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_OKDIR,a14
	move	a14,*a6(POF_FLAGS),W
	move	*a8(ODT_VEL),a1,L
	jrz	mph_stopped
	clr	a14
	movb	a14,*a6(POF_STAND_STILL)
	move	*a6(POF_MODE),a0,W
	jrz	ask1
	cmpi	PM_SKID,a0
	jrz	asksh
	move	*a6(POF_PUP_FLAGS),a14,W
	btst	B_PUP_SPEED,a14
	jrz	nop3ps
	movi	pspeed_data_powered,a14
	jruc	ysp3ps			;power up speed
nop3ps	move	*a6(POF_S_SPED),a14,L
ysp3ps	move	*a14(PS_SP_SPEED_0),a14,L
	cmp	a14,a1
	jrls	asksh1
	calla	slide_to_stop_sound
ask1	move	*a6(POF_NOFACE),a0,W
	cmpi	111011100b,a0
	jrz	asksh
	movk	PM_SKID,a0
	move	a0,*a6(POF_MODE),W
asksh	move	*a8(ODT_VEL),a1,L
asksh1	clr	a2
	movb	*a7(PS_ST_SKID_S_MT),a3
	move	*a8(ODT_TURBO),a14,W
	jrz	cpsate
	movb	*a7(PS_ST_TSKID_S_MT),a3
cpsate	movb	*a6(POF_SKID_BOOST),a14
	add	a14,a3
	callr	move_to_s_no_r		;move to speed if we don't receive
	move	*a8(ODT_DIR),a0,L
	move	*a7(PS_ST_STOP_THRESH),a14,L
	cmp	a14,a1
	jrls	mph_stopped
	jauc	set_obj_to_polar

move_to_s_no_r		;move to speed if we don't receive
	callr	are_we_intended
	jrc	msr1
	jauc	move_to_speed_x
msr1	rets

are_we_intended
	mmtm	sp,a0,a7
	move	@not_free_receiver,a14,W
	jrz	sna2
	move	@PUCK_CONTROL,a14,W
	jrnz	sna2			;somebody has puck, ok
	move	@PUCK_MODE,a14,W
	cmpi	PUM_PASS,a14
	jrz	s2			;passes our pass mode test
	cmpi	PUM_TPASS,a14
	jrnz	sna2			;doesn't pass our pass mode test
s2	move	@PUCK_INTENDED,a14,W
	movb	*a6(POF_NUMBER),a7
	cmp	a7,a14
	jrnz	sna2
	move	@bhit_dest_time,a14,L
	jrnz	nsna
	move	@PUCK_OBJECT,a7,L
	move	*a7(ODT_XDEST),a14,L
	move	*a7(OXVAL),a0,L
	sub	a0,a14
	sra	31,a14		;get just sign of dest - val
	move	*a7(OXVEL),a0,L
	sra	31,a0
	cmp	a0,a14
	jrnz	saana
	move	*a7(ODT_ZDEST),a14,L
	move	*a7(OZVAL),a0,L
	sub	a0,a14
	sra	31,a14		;get just sign of dest - val
	move	*a7(OZVEL),a0,L
	sra	31,a0
	cmp	a0,a14
	jrnz	saana
nsna	setc
	mmfm	sp,a0,a7
	rets
saana	clr	a0
	move	a0,@not_free_receiver,W
sna2	clrc
	mmfm	sp,a0,a7
	rets

mph_stopped
	clr	a0
	move	a0,*a6(POF_QS_OK),W	;ok to go to quick start
	move	a0,*a6(POF_MODE),W
	movb	*a6(POF_DIRECTION),a0
	calla	dir_to_degrees		;grab direction so bdirection works
	clr	a1
	jauc	set_obj_to_polar

face_player
	movb	*a6(POF_DIRECTION),*a6(POF_LAST_DIRECTION)
	move	*a6(POF_MODE),a0,W
	jrz	face_standing		;br=standing
	move	*a6(POF_NOFACE),a1,W
	jrnz	face_safe_travel
	movb	*a6(POF_NUMBER),a0
	move	@PUCK_CONTROL,a1,W
	jrnz	fpic
	move	@PUCK_LAST_CONTROL,a1,W
	jrz	fp_none			;br= nobody has puck
fpic	cmp	a0,a1
	jrz	face_travel		;br= we have puck
	calla	get_offense_mode
	cmpi	1,a1
	jrz	face_to_defense
fp_none	jruc	face_travel

face_standing
	move	*a6(POF_NOFACE),a1,W
	jrnz	face_safe_standing
	movb	*a6(POF_NUMBER),a0
	calla	get_offense_mode
	move	a1,a1
	jrz	fsta9		;we are offense, do not change face
	movb	*a6(POF_STAND_STILL),a14
	inc	a14
	cmpi	256,a14
	jrls	fsta4
	movi	252,a14		;so we can change face every 4 ticks
fsta4	movb	a14,*a6(POF_STAND_STILL)
	cmpi	32,a14
	jrls	fsta9
	move	a14,a0
	srl	2,a0
	sll	2,a0
	cmp	a14,a0
	jrnz	fsta9
	move	*a6(POF_OBJECT),a8,L	;just in case
	jruc	rotate_toward_puck
fsta9	rets

face_safe_travel
	move	*a8(ODT_DIR),a0,L
	calla	dir_to_18
	btst	a0,a1
	jrz	fst_8
	movk	1,a0
	move	*a8(OZVEL),a14,L
	jrz	fst_z0
	jrn	fst_8
	movk	5,a0
	jruc	fst_8
fst_z0	rets

fst_8	movb	a0,*a6(POF_DIRECTION)
	rets

face_safe_standing
	movb	*a6(POF_DIRECTION),a0
	btst	a0,a1
	jrz	fsss9
	movk	1,a0
	movb	a0,*a6(POF_DIRECTION)
fsss9	rets

rotate_toward_puck
	move	@PUCK_CONTROL,a0,W
	jrz	rtpka
	GBLOCK	a0,a9
	move	*a9(POF_OBJECT),a9,L
	jruc	rtpkb
rtpka	move	@PUCK_OBJECT,a9,L
rtpkb	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point_18
	movb	*a6(POF_DIRECTION),a1
	cmp	a0,a1
	jrz	rtpk_9
	sub	a1,a0
	jrp	rtpk1
	addk	8,a0
rtpk1	cmpi	4,a0
	jrls	rtps
	subk	1,a1
	jruc	rteoe
rtps	addk	1,a1
rteoe	jrp	rteoa
	addk	8,a1
rteoa	cmpi	8,a1
	jrls	rtei
	subk	8,a1
rtei	movb	a1,*a6(POF_DIRECTION)
rtpk_9	rets

face_travel			;face the direction we are traveling
	move	*a8(ODT_VEL),a0,L
	jrz	ftn
	move	*a8(ODT_DIR),a0,L
	calla	dir_to_18
	movb	a0,*a6(POF_DIRECTION)
ftn	rets

face_to_goal			;face goal of defensive team
	movi	[339,0800h],a1
	movi	[670,0],a0
	move	@PUCK_CONTROL,a2,W
	jrnz	fgt1
	move	@PUCK_LAST_CONTROL,a2,W
fgt1	cmpi	2,a2
	jrls	face_to_point
	neg	a0
	jruc	face_to_point

face_to_defense
	move	@PUCK_CONTROL,a9,W
	jrz	ftp3_x
	move	a10,a0		;player number
	dec	a0
	srl	2,a0
	move	a0,a11		;save team
	xori	1,a0
	sll	2,a0
	inc	a0		;first enemy
	GBLOCK	a0,a7
	move	*a7(POF_OBJECT),a7,L
	move	*a7(OXPOS),a7,W
	inc	a0
	GBLOCK	a0,a9
	move	*a9(POF_OBJECT),a9,L
	move	*a9(OXPOS),a9,W
	addk	2,a0
	GBLOCK	a0,a0
	move	*a0(POF_OBJECT),a0,L
	move	*a0(OXPOS),a0,W
	move	*a8(OXPOS),a14,W
	move	a11,a11
	jrz	ftdd1
	neg	a14
	neg	a0
	neg	a9
	neg	a7
ftdd1	cmp	a0,a14
	jrgt	ftp3_x
	cmp	a9,a14
	jrgt	ftp3_x
	cmp	a7,a14
	jrgt	ftp3_x
	move	*a6(POF_FLAGS),a0,W
	andni	M_PF_OKDIR,a0
	move	a0,*a6(POF_FLAGS),W
	movk	3,a14
	move	a11,a11
	jrz	face_to_direction
	movk	7,a14
	jruc	face_to_direction
ftp3_x	jruc	face_travel

face_to_puck			;face the puck
	move	@PUCK_CONTROL,a9,W
	jrz	ftp_x
	GBLOCK	a9,a9
	move	*a9(POF_OBJECT),a9,L
	jruc	ftp_xy
ftp_x	move	@PUCK_OBJECT,a9,L
ftp_xy	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
face_to_point			;face a point
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point_18
	move	a0,a14
	;
face_to_direction		;given a direction to face
	move	*a8(ODT_VEL),a0,L
	jrz	ftd_a14
	move	*a6(POF_FLAGS),a0,W
	btst	B_PF_OKDIR,a0
	jrnz	ftd_a14
	move	*a8(ODT_DIR),a0,L
	calla	dir_to_18
	sub	a0,a14
	jrnn	ftd1
	addk	8,a14
ftd1	cmpi	3,a14
	jrlo	ftd_a0
	cmpi	5,a14
	jrhi	ftd_a0
	subk	4,a0
	jrp	ftd_a0
	addk	8,a0
ftd_a0	movb	a0,*a6(POF_DIRECTION)
	rets
ftd_a14	movb	a14,*a6(POF_DIRECTION)
	move	*a6(POF_FLAGS),a14,W
	andni	M_PF_OKDIR,a14
	move	a14,*a6(POF_FLAGS),W
	rets

face_puck_player
	move	@PUCK_CONTROL,a9,W
	jrz	face_puck
	GBLOCK	a9,a9
	move	*a9(POF_OBJECT),a9,L
	jruc	fpk1
face_puck
	move	@PUCK_OBJECT,a9,L
fpk1	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point_18
	movb	a0,*a6(POF_DIRECTION)
	rets

set_player_script_a79
	mmtm	sp,a6,a8
	move	a7,a6
	move	a9,a8
	callr	set_player_script
	mmfm	sp,a6,a8
	rets
set_player_script		;sets script based on our mode
;	movi	debug_script,a1
;	jauc	start_panim_if_not

;	jauc	set_test_script

	move	*a6(POF_MODE),a0,W
	sll	5,a0
	addi	spsll,a0
	move	*a0,a0,L
	jump	a0

no_spsc	rets
spsll	.long	set_stand_script
	.long	set_run_script
	.long	set_pass_script
	.long	set_wrist_shot_script
	.long	set_skid_script
	.long	set_steal_script
	.long	set_push_script
	.long	set_shake_script
	.long	set_dump_script
	.long	set_stand_script
	.long	set_fall_script
	.long	set_stand_script
	.long	set_stand_script
	.long	set_onetime_script
	.long	set_high_stick_script
	.long	set_slash_script
	.long	set_swing_script
	.long	set_hip_check_script
	.long	set_down_block_script

pass_puck_sw
 	calla	check_for_player
	jrnc	pp_9
	move	@GAME_STATE,a14,W
	cmpi	INPLAY,a14
	jrnz	pp_9
	GBLOCK	a0,a6
	callr	inc_get_up
	move	@taps_ok,a14,W
	jrz	ppsg1
	calla	inc_tap
ppsg1 	move	*a6(POF_MODE),a14,W	;if shooting, ok
	cmpi	3,a14			;if shooting, ok
	jrnz	ppkw
	move	*a6(POF_FLAGS),a14,W
	jruc	ppka
ppkw	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	pp_no_control
ppka	andi	M_PF_HIGHER|M_PF_HIGHER_W,a14
	jrnz	pp_higher
	move	@WAVEIRQS,a1,L
	move	*a6(POF_SHOT_START),a14,L
	sub	a1,a14
	abs	a14
	cmpi	3,a14
	jrls	pass_and_shoot		;do pass and shoot same time
	move	@PUCK_CONTROL,a1,W
	cmp	a0,a1
	jrnz	pp_np
	move	*a6(POF_MODE),a14,W	;if shooting, ok
	cmpi	3,a14
	jrnz	ppk2
	move	*a6(POF_SHOT_PASS),a14,L
	jump	a14
ppk2	move	*a6(POF_OBJECT),a8,L
	move	@PUCK_MODE,a1,W
	movi	pass_ok_mlist,a3
	calla	check_mode_ok
	jrnc	pp_9

;;-----
;	movb	*a6(POF_NUMBER),a1
;	sll	8,a1
;	addi	PIDOF_WATCH_PASS,a1
;	movi	new_pass_watch,a7
;	move	a6,a11
;	calla	KILL_AND_GETPPRC
;	jauc	SUCIDE
;
;new_pass_watch
;npw_0	SLEEP	1
;	move	*a11(POF_BUTTONS),a0,W
;	btst	1,a0
;	jrnz	npw_0
;
;	move	a11,a6
;	move	*a6(POF_OBJECT),a8,L
;;-----

	move	*a6(POF_TURBO_MODE),a1,W
pass_puck_process
	callr	pass_puck
pp_9	jauc	SUCIDE
pp_no_control
	callr	signal_to_pass
	jauc	SUCIDE

pass_puck_quick_process
	move	@WAVEIRQS,a14,L
	move	a14,*a6(POF_PASS_START),L
	move	*a6(POF_FLAGS),a14,W
	andni	M_PF_BPASS,a14
	move	a14,*a6(POF_FLAGS),W
	movi	set_pass_early_script,a10
	movi	pass_button_release,a11		;this will set the same script
	callr	ppinhp
	jauc	SUCIDE

pass_puck
	move	@WAVEIRQS,a14,L
	move	a14,*a6(POF_PASS_START),L
	move	*a6(POF_FLAGS),a14,W
	andni	M_PF_BPASS,a14
	move	a14,*a6(POF_FLAGS),W
	callr	get_pass_stuff
		;a10 = script set address
		;a11 = button release address
ppinhp	move	a11,*a6(POF_PASS_RELEASE),L
	call	a10			;set script
	callr	set_pass_mode
	callr	take_player_control
	movb	*a6(POF_NUMBER),a1
	sll	8,a1
	addi	PIDOF_WATCH_PASS,a1
	movi	pass_watch,a7
	move	a6,a11
	jauc	KILL_AND_GETPPRC

pass_ok_mlist
	.word	0,1,3,4,-1

;	a0 = player, a1 = puck control, a8 = player object, a6 = block
pp_np	clr	a14
	move	a14,*a6(POF_HAS_CHECKED),W
	callr	do_we_hack_goalie
	jrc	hack_at_goalie
	move	*a6(POF_TURBO_MODE),a14,W	;pass without puck
	jrnz	pp_tnp
	move	@UNLIM_CHECK,a14,W
	jrz	pp_swat
	move	*a6(POF_BUTTONS),a14,W
	btst	2,a14		;turbo
	jrnz	pp_tnp		;unlimited check, does not require more than button

pp_swat	dec	a1
;	jrn	pp_s2
	jrn	ppx9
	dec	a0
	srl	2,a1
	srl	2,a0
	cmp	a0,a1
	jrnz	pp_s2
	callr	signal_to_pass
	jruc	ppx9
pp_s2	move	*a6(POF_OBJECT),a8,L
	callr	take_player_control

	movb	*a6(POF_DIRECTION),a0
	calla	are_we_backwards
	jrc	ppnp_back
	movk	5,a0
	move	a0,*a6(POF_MODE),W
	calla	set_player_script
ppx9	jauc	SUCIDE
ppnp_back
	calla	set_backward_sweep_check_script
	jauc	SUCIDE

pp_tnp
pp_push	move	*a6(POF_OBJECT),a8,L
	calla	are_we_intended
	jrnc	sp_ps2			;also check is below (for drone/non drone)
	clr	a14
	movb	a14,*a6(POF_BDIRECTION)
sp_ps2	movb	*a6(POF_M_JOY),a0
	jrz	pppg1
	move	a0,a2
	movb	*a6(POF_BDIRECTION),a0
	jrnz	ppcf1
	movb	*a6(POF_DIRECTION),a0
ppcf1	calla	are_we_backwards
	jrnc	pppg2
	addk	4,a2
	cmpi	8,a2
	jrls	pppg2
	subk	8,a2
pppg2	movb	a2,*a6(POF_DIRECTION)
pppg1	callr	skater_push
	jauc	SUCIDE

skater_push
	calla	are_we_intended
	jrnc	sp_ps1			;also check is above (for drone/non drone)
	clr	a14
	movb	a14,*a6(POF_BDIRECTION)
sp_ps1	clr	a14
	move	a14,*a6(POF_HAS_CHECKED),W
	move	*a6(POF_OBJECT),a8,L
	callr	take_player_control
	clr	a0
	calla	take_turbo
	jauc	do_check


;	movb	*a6(POF_DIRECTION),a0
;	move	*a8(ODT_VEL),a14,L
;	cmpi	[6,0],a14
;	jrls	ppop2
;	calla	are_we_backwards
;	jrc	backwards_check
;ppop2	move	@PUCK_CONTROL,a14,W
;	jrz	spdr
;	movb	*a6(POF_NUMBER),a0
;	EQTEAM	a0,a14
;	jrz	spdr			;if puck carrier is same team, no slash
;	move	@PUCK_CONTROL,a0,W
;	GBLOCK	a0,a7
;	movb	*a7(POF_DIRECTION),a1
;	movb	*a6(POF_DIRECTION),a2
;	cmp	a1,a2
;	jrnz	spdr			;if puck carrier is not going same direction as us, no slash
;	move	*a7(POF_OBJECT),a9,L
;	move	*a9(OXVAL),a0,L
;	addi	[0,08000h],a0
;	sra	16,a0
;	move	*a9(OZPOS),a1,W
;	move	*a8(OXVAL),a2,L
;	addi	[0,08000h],a2
;	sra	16,a2
;	move	*a8(OZPOS),a3,W
;	calla	find_dist_quick
;	cmpi	110,a4
;	jrhi	spdr
;	move	*a8(ODT_VEL),a0,L
;	cmpi	[3,0],a0
;	jrls	spdr
;	move	*a9(ODT_VEL),a0,L
;	cmpi	[3,0],a0
;	jrls	spdr
;	move	*a9(OXVAL),a0,L
;	move	*a9(OZVAL),a1,L
;	move	*a8(OXVAL),a2,L
;	move	*a8(OZVAL),a3,L
;	calla	find_dir_to_point_18
;	movb	*a7(POF_DIRECTION),a1
;	cmp	a0,a1
;	jrnz	spdr
;	movk	PM_SLASH,a1
;	jruc	spd1
;spdr	movk	PM_CROSSCHECK,a1
;	move	*a6(POF_TURBO_AMOUNT+010h),a0
;	cmpi	53,a0
;	jrls	spd1
;	movb	*a6(POF_DIRECTION),a1
;	cmpi	1,a1
;	jrz	spdr2
;	cmpi	5,a1
;	jrz	spdr2
;	movi	400,a0
;	calla	RANDPER
;	jrnc	spdr2
;	movk	PM_SWING,a1		;400/1024 chance of blatant swing
;	jruc	spd1
;spdr2	movk	PM_HIGHSTICK,a1
;spd1	move	a1,*a6(POF_MODE),W
;	jauc	set_player_script

backwards_check
	movk	PM_HIP,a0
	move	a0,*a6(POF_MODE),W
	calla	get_push_block		;returns a11
	move	*a11+,a0,W
	callr	can_we_hip
	jrc	set_hdv
	move	*a11+,a0,W
	callr	can_we_hip
	jrc	set_hdv
	move	*a11+,a0,W
	callr	can_we_hip
	jrc	set_hdv
set_hip_check_script
set_hdn	movi	339,a14
	move	*a8(OZPOS),a1,W
	subi	679,a1
	neg	a1
	jruc	stf1
set_hdv	GBLOCK	a0,a7
	move	*a7(POF_OBJECT),a7,L
	move	*a7(OZPOS),a14,W
	move	*a8(OZPOS),a1,W
stf1	cmp	a14,a1
	jrgt	shdown
shup	jauc	set_hip_check_up_script
shdown	jauc	set_hip_check_down_script

can_we_hip
	move	a0,a14
	sll	4,a14
	addi	POF_D_1P-16,a14
	add	a6,a14
	move	*a14,a14,W
	cmpi	120,a14
	jrhi	cwen
	setc
	rets
cwen	clrc
	rets

get_pass_stuff
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	gps_goalie
	mmtm	sp,a0,a1,a9
	movb	*a6(POF_NUMBER),a0
	calla	get_pass_receiver
	GBLOCK	a0,a9
	move	*a9(POF_OBJECT),a9,L
	move	*a8(OXPOS),a0,W
	move	*a9(OXPOS),a1,W
	sub	a0,a1		;x difference
	abs	a1
	move	*a8(OZPOS),a0,W
	move	*a9(OZPOS),a14,W
	sub	a14,a0
	abs	a0		;z difference
	cmp	a0,a1
	jrhs	gps_lr		;left or right is direction
gps_ud	move	*a8(OZPOS),a0,W
	move	*a9(OZPOS),a14,W
	cmp	a0,a14
	jrgt	gps_up
gps_dn	movi	pass_down_b_release,a11
	movi	set_pass_down_script,a10
	mmfm	sp,a0,a1,a9
	rets
gps_up	movi	pass_up_b_release,a11
	movi	set_pass_up_script,a10
	mmfm	sp,a0,a1,a9
	rets
gps_lr	move	*a8(OXPOS),a0,W
	move	*a9(OXPOS),a14,W
	cmp	a0,a14
	jrgt	gps_rt
gps_lf	movb	*a6(POF_DIRECTION),a14
	cmpi	3,a14
	jrnz	gpslf1
	move	*a8(OZPOS),a0,W
	move	*a9(OZPOS),a14,W
	sub	a14,a0
	abs	a0		;z difference
	cmpi	50,a0
	jrhs	gpslf1
	move	*a8(ODT_VEL+010h),a14,W
	cmpi	4,a14
	jrls	gpslf1
	movi	pass_left_thru_release,a11
	movi	set_pass_left_thru_script,a10
	mmfm	sp,a0,a1,a9
	rets
gpslf1	movi	pass_left_b_release,a11
	movi	set_pass_left_script,a10
	mmfm	sp,a0,a1,a9
	rets
gps_rt	movb	*a6(POF_DIRECTION),a14
	cmpi	7,a14
	jrnz	gpsrt1
	move	*a8(OZPOS),a0,W
	move	*a9(OZPOS),a14,W
	sub	a14,a0
	abs	a0		;z difference
	cmpi	50,a0
	jrhs	gpsrt1
	move	*a8(ODT_VEL+010h),a14,W
	cmpi	4,a14
	jrls	gpsrt1
	movi	pass_right_thru_release,a11
	movi	set_pass_right_thru_script,a10
	mmfm	sp,a0,a1,a9
	rets
gpsrt1	movi	pass_right_b_release,a11
	movi	set_pass_right_script,a10
	mmfm	sp,a0,a1,a9
	rets

set_pass_mode
	PUSH	a0
	movk	PM_PASS,a0
	move	a0,*a6(POF_MODE),W
	PULLQ	a0
	rets

gps_goalie
	movi	DUMRETS,a10
	movi	DUMDIE,a11
	MOVE	*A6(POF_MODE),A14,W
	CMPI	PM_GSMOTHER,A14
	JREQ	GPS_G_DONE			;BR=WE'RE SMOTHERING THE PUCK
	MOVI	SET_GPASS_SCRIPT,A10
	CMPI	PM_GHOLDING,A14
	JRNE	GPS_G_DONE			;BR=WE'RE HOLDING THE PUCK
	MOVI	SET_GDROPPASS_SCRIPT,A10
GPS_G_DONE
	rets

pass_left_thru_release
	callr	pbr_c1
	jrnz	pd9
	calla	set_pass_left_thru_early_script
	jruc	pd9
pass_right_thru_release
	callr	pbr_c1
	jrnz	pd9
	calla	set_pass_right_thru_early_script
	jruc	pd9
pass_down_b_release
	callr	pbr_c1
	jrnz	pd9
	calla	set_pass_down_early_script
	jruc	pd9
pass_up_b_release
	callr	pbr_c1
	jrnz	pd9
	calla	set_pass_up_early_script
	jruc	pd9
pass_left_b_release
	callr	pbr_c1
	jrnz	pd9
	calla	set_pass_left_early_script
	jruc	pd9
pass_right_b_release
	callr	pbr_c1
	jrnz	pd9
	calla	set_pass_right_early_script
pd9	jauc	SUCIDE


pbr_c1	movb	*a6(POF_NUMBER),a0
	move	@PUCK_CONTROL,a14,W
	cmp	a0,a14
	rets

pass_button_release
	movb	*a6(POF_NUMBER),a0
	calla	set_pass_early_script
	jauc	SUCIDE

pass_watch
ppw_0	SLEEP	1
	move	*a11(POF_BUTTONS),a0,W
	btst	1,a0
	jrnz	ppw_0
	move	*a11(POF_PASS_RELEASE),a0,L
	move	a11,a6
	move	*a6(POF_OBJECT),a8,L
	jump	a0

pass_script_done_1
	move	*a8(ODT_PBK),a6,L
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_CONTROLM,a14
	move	a14,*a6(POF_FLAGS),W
	movk	PUM_PASS,a14
;	jruc	ppsd1
;turbo_pass_script_done_1
;	movk	PUM_TPASS,a14
ppsd1	move	@PUCK_CONTROL,a1,W
	cmp	a0,a1
	jrnz	pscr_abort
	calla	set_safe_puck_mode_a14
	callr	record_pass_a6
	calla	turn_on_players_arrow
	calla	get_pass_receiver
	mmtm	sp,a0
	calla	turn_on_receivers_arrow
	move	a0,@PUCK_INTENDED,W
	move	@PUCK_CONTROL,@PUCK_LAST_CONTROL,W
	clr	a1
	move	a1,@PUCK_CONTROL,W
	calla	new_puck_control
	move	*a6(POF_S_PASS),a9,L		;pup pass change here
	move	*a6(POF_PUP_FLAGS),a14,W
	btst	B_PUP_PASS,a14
	jrz	npupps1
	movi	pass_data_powered,a9
npupps1	move	*a9(PS_PS_PASS_TURBO),a7,L
	move	*a9(PS_PS_TPASS_CHANGE),a14,L
	move	a14,b6
	move	*a6(POF_S_SHOT),a10,L
	move	*a10(PS_SH_MAX_YVEL),a10,L	;no change needed for pup shot
	calla	put_puck_outside_netp
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_BPASS,a14
	jrz	rplk
	andni	M_PF_BPASS,a14
	move	a14,*a6(POF_FLAGS),W
	callr	clean_up_my_signals
	calla	send_puck_to_player_boards
	jruc	nplk
rplk	callr	clean_up_my_signals
	calla	send_puck_to_player		;does not take on current vel.
nplk	mmfm	sp,a0
	calla	spx_pass_1
	move	*a6(POF_S_PASS),a9,L		;no change needed for pup pass
	move	*a9(PS_PS_TPASS_GTHRESH),a0,W
	cmp	a0,a10
	jrlo	pptb9				;not in air
	move	*a9(PS_PS_TPASS_MTHRESH),a0,W
	cmp	a0,a10
	jrhs	pptair
	movk	2,a0
	calla	RAND0
	jrz	pptb9				;not in air (50%)
pptair	movi	[-2,0000h],a0
	move	@PUCK_OBJECT,a8,L
	move	a0,*a8(OYVEL),L
	calla	give_puck_shot_gravity
pptb9	jauc	slap_shot_sound
pscr_abort
	jruc	do_end_of_shoot_stuff

**************************************************************************
*								         *
* pass_script_done_zero							 *
* 	output	a0 = intended receiver					 *
* 		a2 = x velocity to give to puck				 *
* 		a3 = z velocity to give to puck				 *
* 		a4 = distance puck will travel				 *
* 		a10= unknown, but keep unaltered			 *
* 		b6 = routine to call to change angle			 *
*								         *
**************************************************************************
pass_script_done_zero
	move	*a8(ODT_PBK),a6,L
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_CONTROLM,a14
	move	a14,*a6(POF_FLAGS),W
	move	@PUCK_CONTROL,a1,W
	cmp	a0,a1
	jrnz	p0scr_abort
	calla	get_pass_receiver
	mmtm	sp,a0
	move	*a6(POF_S_PASS),a9,L		;pup pass change here
	move	*a6(POF_PUP_FLAGS),a14,W
	btst	B_PUP_PASS,a14
	jrz	npupps2
	movi	pass_data_powered,a9
npupps2	move	*a9(PS_PS_PASS_TURBO),a7,L
	move	*a9(PS_PS_TPASS_CHANGE),a14,L
	move	a14,b6
	move	*a6(POF_S_SHOT),a10,L		;no change needed for pup shot
	move	*a10(PS_SH_MAX_YVEL),a10,L
	callr	clean_up_my_signals
	calla	send_puck_to_player_part1		;does not take on current vel.
	mmfm	sp,a0
	setc
	rets

p0scr_abort
	callr	do_end_of_shoot_stuff
	clrc
	rets

pass_script_done_zero_one
	movk	PUM_PASS,a14
	calla	set_safe_puck_mode_a14
	callr	record_pass_a6
	mmtm	sp,a0,a2,a3,a4,a10
	calla	turn_on_receivers_arrow
	move	a0,@PUCK_INTENDED,W
	move	@PUCK_CONTROL,@PUCK_LAST_CONTROL,W
	clr	a1
	move	a1,@PUCK_CONTROL,W
	calla	new_puck_control
	mmfm	sp,a0,a2,a3,a4,a10
	calla	send_puck_to_player_part2		;does not take on current vel.
	calla	spx_pass_1
	move	*a6(POF_S_PASS),a9,L		;no change needed for pup pass
	move	*a9(PS_PS_TPASS_GTHRESH),a0,W
	cmp	a0,a10
	jrlo	pptb9				;not in air
	move	*a9(PS_PS_TPASS_MTHRESH),a0,W
	cmp	a0,a10
	jrhs	p1ptair
	movk	2,a0
	calla	RAND0
	jrz	p1ptb9				;not in air (50%)
p1ptair	movi	[-2,0000h],a0
	move	@PUCK_OBJECT,a8,L
	move	a0,*a8(OYVEL),L
	calla	give_puck_shot_gravity
p1ptb9	jauc	slap_shot_sound

shoot_puck_sw
	calla	check_for_player
	jrnc	sp_9			;if not playing game, exit
	move	@GAME_STATE,a14,W
	cmpi	INPLAY,a14
	jrnz	sp_9
	GBLOCK	a0,a6
	callr	inc_get_up
	move	@taps_ok,a14,W
	jrz	spsg1
	calla	inc_tap
spsg1	move	*a6(POF_MODE),a14,W	;if shooting, ok
	cmpi	2,a14
	jrnz	spkw
	move	*a6(POF_FLAGS),a14,W
	jruc	spka
spkw	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	sp_no_control
spka	andi	M_PF_HIGHER|M_PF_HIGHER_W,a14
	jrnz	sp_higher

	move	*a6(POF_MODE),a14
	cmpi	PM_PASS,a14
	jrz	pass_and_shoot
;	move	@WAVEIRQS,a1,L
;	move	*a6(POF_PASS_START),a14,L
;	sub	a1,a14
;	abs	a14
;	cmpi	3,a14
;	jrls	pass_and_shoot		;do pass and shoot same time

	move	@PUCK_CONTROL,a1,W
	cmp	a0,a1
	jrnz	sp_shnp			;br= has no puck
	move	*a6(POF_OBJECT),a8,L
	move	@PUCK_MODE,a1,W
	cmpi	14,a1			;one timer?
	jrz	sp_ot			;br=yes, it is a one timer
	movi	shoot_ok_mlist,a3
	calla	check_mode_ok
	jrnc	sp_9
	move	*a6(POF_TURBO_MODE),a14,W
shoot_puck_process
	callr	shoot_puck
sp_9	jauc	SUCIDE
sp_no_control
	callr	signal_to_shoot
	jauc	SUCIDE

pp_higher
sp_higher
	movb	*a6(POF_NUMBER),a0
	cmpi	2,a0
	jrz	sppp2
	cmpi	5,a0
	jrz	sppp2
	movk	2,a1
	cmpi	5,a0
	jrlo	sptpa
	movk	5,a1
sptpa	GBLOCK	a1,a14
	move	*a14(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	janz	SUCIDE
	GBLOCK	a1,a6
sppp2	move	@PUCK_MODE,a14
	cmpi	PUM_FACEOFF,a14
	janz	SUCIDE
	move	*a6(POF_OBJECT),a8,L
	calla	faceoff_tap
	jauc	SUCIDE

inc_get_up
	move	*a6(POF_GET_UP_COUNT),a14,W
	addk	8,a14
	move	a14,*a6(POF_GET_UP_COUNT),W
	rets

shoot_puck
	move	*a8(OXPOS),a0,W
	movb	*a6(POF_NUMBER),a14
	cmpi	4,a14
	jrls	spkl
	neg	a0
spkl	cmpi	-233,a0
	jrgt	spko
	move	@minutes,a14,W
	jrz	spko
	calla	quick_freeze_check
	jrnc	spko
	move	*a6(POF_FREEZE_BITS),a14,W
	btst	PFRZ_SHOOTFAR,a14
	jrnz	spko
	calla	check_freeze_shootfar
	rets
spko	calla	shoot_board_animate
	move	@WAVEIRQS,a14,L
	move	a14,*a6(POF_SHOT_START),L
	movk	PM_SHOOT,a0
	move	a0,*a6(POF_MODE),W
	callr	get_quick_shot_point
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point_18
	movb	a0,*a6(POF_DIRECTION)
	movb	a0,*a6(POF_BDIRECTION)
	callr	get_shoot_stuff
		;a10 = script set address
		;a11 = button release address
		;a9 = pass from shoot address
	move	a9,*a6(POF_SHOT_PASS),L
	move	a11,*a6(POF_SHOT_RELEASE),L
	callr	take_player_control
	call	a10
	movb	*a6(POF_NUMBER),a1
	sll	8,a1
	addi	PIDOF_WATCH_SHOOT,a1
	movi	shot_watch,a7
	move	a6,a11
	jauc	KILL_AND_GETPPRC

shoot_ok_mlist
	.word	0,1,4,-1

sp_shnp
;	for josh
;	move	*a6(POF_TURBO_MODE),a14,W
;	jrnz	sp_tnp
	callr	do_we_hack_goalie
	jrc	hack_at_goalie
	dec	a1
	jrn	sp_tnp
	dec	a0
	srl	2,a1
	srl	2,a0
	cmp	a0,a1
	jrnz	sp_tnp
	callr	signal_to_shoot
sp_tnp	movb	*a6(POF_NUMBER),a0
	calla	get_offense_mode
	cmpi	1,a1
	jrnz	sptnp9
	move	*a6(POF_OBJECT),a8,L
	move	*a8(OXPOS),a14,W
	dec	a0
	srl	2,a0
	jrz	sptnh
	neg	a14
sptnh	cmpi	-235,a14
	jrgt	sdb_1kn			;1 knee in non defensive zone
	movk	PM_BLOCK,a0
	move	a0,*a6(POF_MODE),W
	callr	take_player_control
	clr	a0
	movb	a0,*a6(POF_BDIRECTION)
	callr	face_puck
;	calla	set_down_block_script
	calla	set_down_knees_script
	move	*a8(ODT_DIR),a0,L
	move	*a8(ODT_VEL),a1,L
	sra	1,a1
	calla	set_obj_to_polar
sptnp9	jauc	SUCIDE
sdb_1kn	movk	PM_BLOCK,a0
	move	a0,*a6(POF_MODE),W
	callr	take_player_control
	clr	a0
	movb	a0,*a6(POF_BDIRECTION)
	callr	face_puck
	calla	set_down_block_script
	move	*a8(ODT_DIR),a0,L
	move	*a8(ODT_VEL),a1,L
	sra	1,a1
	calla	set_obj_to_polar
	jauc	SUCIDE


get_shoot_stuff
	movk	11,a0
	calla	predict_obj
	move	a0,a2
	move	a1,a3
	callr	get_quick_shifted_shot_point
	calla	find_dir_to_point_18
	move	a0,a10			;a10 can hold us for now

	movi	pass_from_shoot,a9
	movi	wrist_shot_button_release,a11
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	gss_goalie
	btst	B_PF_HUMAN,a14
	jrz	gss_drone
	move	*a6(POF_TURBO_MODE),a14,W
	jrnz	gss_trb
	cmpi	1,a10
	jrz	gss_wd			;wrist shot down
	cmpi	5,a10
	jrz	gss_wu			;backhand shot up
	movi	set_wrist_shot_script,a10
	rets
gss_drone
gss_trb	move	*a6(POF_HOT_VALUE),a14,W
	cmpi	18,a14
	jrz	gs_gbgb
	cmpi	1,a10
	jrz	gss_sd			;slap shot down
	cmpi	5,a10
	jrz	gss_su			;turbo backhand shot up
	movi	turbo_shoot_button_release,a11
	movi	set_turbo_shoot_script,a10
gss_nt	rets
gss_goalie
	rets


gs_gbgb	movi	set_bscaleshoot_script,a10	;for just about on fire, grow big
	rets

gss_wd	movi	set_wrist_shot_down_script,a10
	rets
gss_wu	movi	set_backhand_shot_up_script,a10
	rets
gss_sd	movi	turbo_shoot_button_release,a11
	movi	set_slap_shot_down_script,a10
	rets
gss_su	movi	turbo_shoot_button_release,a11
	movi	set_turbo_back_shot_up_script,a10
	rets

do_we_hack_goalie
	mmtm	sp,a1
	move	@PUCK_CONTROL,a14,W
	cmpi	4,a14
	jrz	dwhg2
	cmpi	8,a14
	jrnz	dwhgn
dwhg2	movb	*a6(POF_NUMBER),a1
	dec	a1
	dec	a14
	sra	2,a14
	sra	2,a1
	cmp	a1,a14
	jrz	dwhgn
	inc	a14
	sll	2,a14
	GBLOCK	a14,a1
	move	*a1(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrz	dwhgn
	move	*a1(POF_MODE),a14,W
	cmpi	PM_GSMOTHER,a14
	jrnz	dwhgn
	movb	*a6(POF_NUMBER),a14
	sll	4,a14
	addi	POF_D_1P-16,a14
	add	a1,a14
	move	*a14,a14,W		;distance
	cmpi	100,a14
	jrhs	dwhgn
dwhgy	mmfm	sp,a1
	setc
	rets
dwhgn	mmfm	sp,a1
	clrc
	rets

hack_at_goalie
	move	@PUCK_CONTROL,a14,W
	move	*a6(POF_OBJECT),a8,L
	GBLOCK	a14,a14
	move	*a14(POF_OBJECT),a14,L
	move	*a14(OXVAL),a0,L
	move	*a14(OZVAL),a1,L
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point_18
	movb	a0,*a6(POF_DIRECTION)
	movk	PM_STEAL,a14
	move	a14,*a6(POF_MODE),W
	calla	take_player_control
	calla	set_whack_goalie_script
	jauc	SUCIDE

shot_watch
	move	*a11(POF_S_SHOT),a9,L		;pup shot change here
	move	*a11(POF_PUP_FLAGS),a14,W
	btst	B_PUP_SHOOT,a14
	jrz	npsh5
	movi	shoot_data_powered,a9
npsh5	move	*a9(PS_SH_SHOOT0_SPEED),a1,L
	move	*a9(PS_SH_SHOOT_SPEED),a10,L
	movb	*a9(PS_SH_SHOOT_MT),a9
	move	*a11(POF_TURBO_MODE),a14,W
	jrz	sswa
	move	*a11(POF_S_SHOT),a9,L		;pup shot change here
	move	*a11(POF_PUP_FLAGS),a14,W
	btst	B_PUP_SHOOT,a14
	jrz	npsh4
	movi	shoot_data_powered,a9
npsh4	move	*a9(PS_SH_SHOOT0_TURBO),a1,L
	move	*a9(PS_SH_SHOOT_TURBO),a10,L
	movb	*a9(PS_SH_SHOOTT_MT),a9
sswa	move	a1,*a11(POF_SHOOT_CURRENT),L
ssw_0	SLEEP	1
	movb	*a11(POF_NUMBER),a14
	move	@PUCK_CONTROL,a0,W
	cmp	a14,a0
	jrnz	sssw9
	move	*a11(POF_SHOOT_CURRENT),a1,L
	move	a10,a2
	move	a9,a3
	calla	move_to_speed_x
	move	a1,*a11(POF_SHOOT_CURRENT),L
ssw_1	move	*a11(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	ssw_0
	move	*a11(POF_BUTTONS),a0,W
	btst	0,a0
	jrnz	ssw_0
	move	*a11(POF_SHOT_RELEASE),a0,L
	move	a11,a6
	move	*a6(POF_OBJECT),a8,L
	jump	a0
sssw9	jauc	SUCIDE

turbo_shoot_button_release
;;;;	move	@WAVEIRQS,a1,L
;;;;	move	*a6(POF_SHOT_FAKE),a14,L
;;;;	sub	a1,a14
;;;;	neg	a14
;;;;	cmpi	30,a14
;;;;	jrls	tsrd
;;;;	move	*a6(POF_SHOT_START),a14,L
;;;;	sub	a14,a1
;;;;	cmpi	5,a1
;;;;	jrls	tsre
tsrd	calla	set_turbo_shoot_early_script
	jauc	SUCIDE
tsre	move	a14,*a6(POF_SHOT_FAKE),L
	callr	do_end_of_shoot_stuff
	jauc	SUCIDE

wrist_shot_button_release
;;;;	move	@WAVEIRQS,a1,L
;;;;	move	*a6(POF_SHOT_FAKE),a14,L
;;;;	sub	a1,a14
;;;;	neg	a14
;;;;	cmpi	30,a14
;;;;	jrls	wsrd
;;;;	move	*a6(POF_SHOT_START),a14,L
;;;;	sub	a14,a1
;;;;	cmpi	5,a1
;;;;	jrls	wsre
wsrd	jauc	SUCIDE
wsre	move	a14,*a6(POF_SHOT_FAKE),L
	callr	do_end_of_shoot_stuff
	jauc	SUCIDE

shoot_button_release
;;;;	move	@WAVEIRQS,a1,L
;;;;	move	*a6(POF_SHOT_FAKE),a14,L
;;;;	sub	a1,a14
;;;;	neg	a14
;;;;	cmpi	30,a14
;;;;	jrls	srd
;;;;	move	*a6(POF_SHOT_START),a14,L
;;;;	sub	a14,a1
;;;;	cmpi	5,a1
;;;;	jrls	sre
;;;;	jauc	set_swing_script
srd	calla	set_shoot_early_script
	jauc	SUCIDE
sre	move	a14,*a6(POF_SHOT_FAKE),L
	callr	do_end_of_shoot_stuff
no_shoot_release
	jauc	SUCIDE

onetime_script_done_fff1
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_OTD,a14
	jrnz	otsd1
	move	@PUCK_CONTROL,a1,W
	movb	*a6(POF_NUMBER),a0
	cmp	a0,a1
	jrnz	otsd1
	callr	does_player_abort_ot
	jrc	shsr_abort
	move	*a8(ODT_DIR),*a8(ODT_SAVEDIR),L
	move	*a8(ODT_VEL),*a8(ODT_SAVEVEL),L
	callr	otd_subb
	callr	get_shot_point_ot
	move	*a6(POF_S_SHOT),a14,L			;no change needed for pup shot
	move	*a14(PS_SH_SHOT_CHANGE),a14,L
	move	a14,b6
	move	*a6(POF_S_SHOT),a10,L			;no change needed for pup shot
	move	*a10(PS_SH_MAX_YVEL),a10,L
	calla	wrist_shot_sound
	calla	record_shot_a6
	calla	put_puck_outside_netp
	calla	compute_shot_tip
	clr	a2
	callr	flame_shoot_check
	move	*a6(POF_S_SHOT),a7,L		;pup shot change here
	move	*a7(PS_SH_SHOOT_SPEED),a7,L
	jauc	send_puck_to_point_xyz_asamev

onetime_script_done_ff1
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_OTD,a14
	jrnz	otsd1
	move	@PUCK_CONTROL,a1,W
	movb	*a6(POF_NUMBER),a0
	cmp	a0,a1
	jrnz	otsd1
	callr	does_player_abort_ot
	jrc	shsr_abort
	callr	otd_subaa
	move	@PUCK_CONTROL,a1,W
	movb	*a6(POF_NUMBER),a0
	cmp	a0,a1
	jrnz	otsd1
	cmpi	60,a4
	jrgt	otsd1
	callr	otd_subb
	callr	get_shot_point_ot
	move	*a6(POF_S_SHOT),a14,L			;no change needed for pup shot
	move	*a14(PS_SH_SHOT_CHANGE),a14,L
	move	a14,b6
	move	*a6(POF_S_SHOT),a10,L			;no change needed for pup shot
	move	*a10(PS_SH_MAX_YVEL),a10,L
	calla	wrist_shot_sound
	calla	record_shot_a6
	calla	put_puck_outside_netp
	calla	compute_shot_tip
	clr	a2
	callr	flame_shoot_check
	move	*a6(POF_S_SHOT),a7,L		;pup shot change here
	move	*a7(PS_SH_SHOOT_SPEED),a7,L
	jauc	send_puck_to_point_xyz_asamev

onetime_script_done_1
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_OTD,a14
	jrnz	otsd1
	move	@PUCK_CONTROL,a1,W
	movb	*a6(POF_NUMBER),a0
	cmp	a0,a1
	jrnz	otsd1

;  for marty
	callr	does_player_abort_ot
	jrc	shsr_abort

	callr	otd_subaa
	move	@PUCK_CONTROL,a1,W
	movb	*a6(POF_NUMBER),a0
	cmp	a0,a1
	jrnz	otsd1
	cmpi	66,a4			;60
	jrgt	otsd1
	callr	otd_subb
	move	*a6(POF_S_SHOT),a7,L		;pup shot change here
	move	*a6(POF_PUP_FLAGS),a14,W
	btst	B_PUP_SHOOT,a14
	jrz	npsh3
	movi	shoot_data_powered,a7
npsh3	move	*a7(PS_SH_SHOOT_SPEED),a7,L
;	move	*a6(POF_SHOOT_CURRENT),a7,L
	callr	get_shot_point_ot
	move	*a6(POF_S_SHOT),a14,L			;no change needed for pup shot
	move	*a14(PS_SH_SHOT_CHANGE),a14,L
	move	a14,b6
	move	*a6(POF_S_SHOT),a10,L			;no change needed for pup shot
	move	*a10(PS_SH_MAX_YVEL),a10,L
	calla	wrist_shot_sound
	calla	record_shot_a6
	calla	put_puck_outside_netp
	calla	compute_shot_onetime
	callr	flame_shoot_check
	jauc	send_puck_to_point_xyz_v
otsd1	rets

does_player_abort_ot
	mmtm	sp,a0
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	dspan
	move	*a6(POF_BUTTONS),a14,W
	btst	0,a14
	jrnz	dspan	;he is holding down
	movb	*a6(POF_NUMBER),a0
	move	@PUCK_CONTROL,a1,W
	cmp	a0,a1
	jrnz	dspan		;he doesn't have it, no abort
	calla	get_players_puck_point_o
	addi	[0,08000h],a0		;half
	sra	16,a0
	sra	16,a1
	move	@PUCK_OBJECT,a9,L
	move	*a9(OXVAL),a2,L
	addi	[0,08000h],a2
	sra	16,a2
	move	*a9(OZPOS),a3,W
	calla	find_dist_quick
	cmpi	60,a4
	jrhi	dspan			;he is too far, no abort
	move	*a8(OXPOS),a14,W
	movb	*a6(POF_NUMBER),a0
	dec	a0
	srl	2,a0
	jrz	dpa1
	neg	a14
dpa1	cmpi	233,a14
	jrle	dspay	;he is in defensive zone, allow abort
dspan	clrc
	mmfm	sp,a0
	rets
dspay	setc
	mmfm	sp,a0
	rets

otd_subaa
	jruc	otsa
otd_suba
	callr	otsa
	cmpi	60,a4
	jrgt	shsr_abort
	rets
otsa	move	@PUCK_CONTROL,a1,W
	cmp	a0,a1
	jrnz	shsr_abort
	calla	get_players_puck_point_o
	addi	[0,08000h],a0		;half
	sra	16,a0
	sra	16,a1
	move	@PUCK_OBJECT,a9,L

	move	*a9(OXVAL),a2,L
	addi	[0,08000h],a2
	sra	16,a2
;	move	*a9(OXPOS),a2,W		;half

	move	*a9(OZPOS),a3,W
	calla	find_dist_quick
	rets

shoot_script_done_1
	movk	PUM_SHOT,a14
	jruc	pppd1
turbo_shoot_script_done_1
	movk	PUM_SSHOT,a14
pppd1	move	@PUCK_CONTROL,a1,W
	cmp	a0,a1
	jrnz	shsr_abort

	MOVE	*A6(POF_SHOT_ATTEMPTS),A1,W
	INC	A1
	MOVE	A1,*A6(POF_SHOT_ATTEMPTS),W
	MOVE	A1,@SHOT_ATTEMPTS,W
	MOVE	@WAVEIRQS,@SHOTIRQ,L

	calla	set_safe_puck_mode_a14
	clr	a1
	move	a1,@PUCK_INTENDED,W
	move	@PUCK_CONTROL,@PUCK_LAST_CONTROL,W
	move	a1,@PUCK_CONTROL,W
	calla	new_puck_control
;	movi	-1,a1		;40	;after 2/3 second,
	movi	50,a1
	move	a1,@PUCK_OPEN_CONTROL_TIME,W	;let us pick it up again
	move	a1,@PUCK_OPEN_LAST_TIME,W	;let us pick it up again
	move	*a6(POF_SHOOT_CURRENT),a7,L
	callr	get_shot_point_nt
	move	*a6(POF_S_SHOT),a14,L		;no change needed for pup shot
	move	*a14(PS_SH_SHOT_CHANGE),a14,L
	move	a14,b6
	move	*a6(POF_S_SHOT),a10,L		;no change needed for pup shot
	move	*a10(PS_SH_MAX_YVEL),a10,L
	calla	wrist_shot_sound
	calla	spx_shot2
	calla	record_shot_a6
	calla	put_puck_outside_netp
	calla	compute_shot_regular
	;do not trash a0,a1,a7,a10 or b6
	move	*a6(POF_SAFETY_WARNING),a14,W
	jrz	dnttl
	move	a0,a14
	abs	a14
	subi	[20,0],a14	;40 easier
	move	a0,a0
	jrp	dntt2
	neg	a14
dntt2	move	a14,a0
	move	a7,a14
	sra	1,a14
	sub	a14,a7
	sra	1,a14
	sub	a14,a7
dnttl	callr	flame_shoot_check
	jauc	send_puck_to_point_xyz_v
shsr_abort
	jruc	do_end_of_shoot_stuff

otd_subb
	movk	PUM_SSHOT,a14
	calla	set_safe_puck_mode_a14
	clr	a1
	move	a1,@PUCK_INTENDED,W
	move	@PUCK_CONTROL,@PUCK_LAST_CONTROL,W
	move	a1,@PUCK_CONTROL,W
	calla	new_puck_control
	movi	50,a1
	move	a1,@PUCK_OPEN_CONTROL_TIME,W	;let us pick it up again
	move	a1,@PUCK_OPEN_LAST_TIME,W	;let us pick it up again
	movi	PM_SHOOT,a0		;take us out of one timer mode
	move	a0,*a6(POF_MODE),W
	movi	DUMDIE,a14
	move	a14,*a6(POF_SHOT_PASS),L
	move	*a8(ODT_SAVEDIR),a0,L
	move	*a8(ODT_SAVEVEL),a1,L
	jauc	set_obj_to_polar


A_SCRIPT_DONE
	MOVE	*A8(ODT_PBK),A6,L			;PLAYER BLOCK
	MOVB	*A6(POF_NUMBER),A0			;PLAYER NUMBER
	callr	give_player_control
	clr	a0
	move	a0,*a6(POF_MODE),W
	rets

onetime_script_done_2
	move	@PUCK_CONTROL,a1,W
	cmp	a1,a0
	jrnz	osd21
	clr	a1
	move	a1,@PUCK_CONTROL,W
	calla	new_puck_control
osd21
pass_script_done_2
;turbo_pass_script_done_2
turbo_shoot_script_done_2
shoot_script_done_2
do_end_of_shoot_stuff
	movb	*a6(POF_NUMBER),a0
	sll	8,a0
	addi	PIDOF_WATCH_SHOOT,a0
	calla	KILLPROC_ALL				;kill switch watch process
	movb	*a6(POF_NUMBER),a0
	sll	8,a0
	addi	PIDOF_WATCH_PASS,a0
	calla	KILLPROC_ALL				;kill switch watch process
non_shoot_script_done
	callr	give_player_control
	clr	a0
	move	a0,*a6(POF_MODE),W
	rets


sp_ot	movk	14,a1			;one timer
	calla	set_safe_puck_mode_a1
	clr	a1
	move	a1,@PUCK_INTENDED,W
	move	@PUCK_CONTROL,@PUCK_LAST_CONTROL,W
	move	a1,@PUCK_CONTROL,W
	calla	new_puck_control
	movi	50,a1
	move	a1,@PUCK_OPEN_CONTROL_TIME,W	;let us pick it up again
	move	a1,@PUCK_OPEN_LAST_TIME,W	;let us pick it up again
	move	*a6(POF_S_SHOT),a7,L		;pup shot change here
	move	*a6(POF_PUP_FLAGS),a14,W
	btst	B_PUP_SHOOT,a14
	jrz	npsh2
	movi	shoot_data_powered,a7
npsh2	move	*a7(PS_SH_SHOOT_SPEED),a7,L
	move	*a6(POF_TURBO_MODE),a14,W
	jrz	sptc
	move	*a6(POF_S_SHOT),a7,L		;pup shot change here
	move	*a6(POF_PUP_FLAGS),a14,W
	btst	B_PUP_SHOOT,a14
	jrz	npsh1
	movi	shoot_data_powered,a7
npsh1	move	*a7(PS_SH_SHOOT_TURBO),a7,L
sptc	callr	get_shot_point_ot
	move	*a6(POF_S_SHOT),a14,L		;no change needed for pup shot
	move	*a14(PS_SH_SHOT_CHANGE),a14,L
	move	a14,b6
	move	*a6(POF_S_SHOT),a10,L		;no change needed for pup shot
	move	*a10(PS_SH_MAX_YVEL),a10,L
	calla	record_shot_a6
	calla	put_puck_outside_netp
	calla	compute_shot_onetime
	callr	flame_shoot_check
	calla	send_puck_to_point_xyz_v
	jauc	SUCIDE

flame_shoot_check
	mmtm	sp,a0,a14
	move	@hot_player,a14
	movb	*a6(POF_NUMBER),a0
	cmp	a0,a14
	jrnz	fsccc9
	calla	flame_shoot_sound
fsccc9	mmfm	sp,a0,a14
	rets

record_shot_a6
	mmtm	sp,a0,a1,a4
;	movb	*a6(POF_NUMBER),a0
;	sll	5,a0
;	addi	total_shots_p1-32,a0
;	move	*a0,a14,L
;	inc	a14
;	move	a14,*a0,L
	movi	POF_SHOTS_P1-8,a1
	jruc	rca6
record_pass_a6
	mmtm	sp,a0,a1,a4
;	movb	*a6(POF_NUMBER),a0
;	sll	5,a0
;	addi	total_passes_p1-32,a0
;	move	*a0,a14,L
;	inc	a14
;	move	a14,*a0,L
	movi	POF_PASSES_P1-8,a1
	jruc	rca6
record_steal_a6
	mmtm	sp,a0,a1,a4
;	movb	*a6(POF_NUMBER),a0
;	sll	5,a0
;	addi	total_steals_p1-32,a0
;	move	*a0,a14,L
;	inc	a14
;	move	a14,*a0,L
	movi	POF_STEALS_P1-8,a1
	jruc	rca6
record_check_a6
	mmtm	sp,a0,a1,a4
;	movb	*a6(POF_NUMBER),a0
;	sll	5,a0
;	addi	total_checks_p1-32,a0
;	move	*a0,a14,L
;	inc	a14
;	move	a14,*a0,L
	movi	POF_CHECKS_P1-8,a1
rca6	move	@PUCK_MODE,a4,W
	cmpi	PUM_SCORE,a4
	jrhs	rca9
	move	@period,a4
	sll	3,a4
	add	a1,a4
	add	a6,a4	;a4 POF_SHOTS offset by period
	movb	*a4,a0
	inc	a0
	cmpi	255,a0
	jrz	rca9
	movb	a0,*a4
rca9	mmfm	sp,a0,a1,a4
	rets

pass_from_shoot
	callr	do_end_of_shoot_stuff
	movb	*a6(POF_NUMBER),a0
	move	*a6(POF_TURBO_MODE),a1,W
	move	*a6(POF_OBJECT),a8,L
	jruc	pass_puck_quick_process

pass_and_shoot
	jauc	SUCIDE

	move	*a6(POF_OBJECT),a8,L
	movb	*a6(POF_M_JOY),a0
	jrnz	inacar
	movb	*a6(POF_DIRECTION),a0
inacar
	.if	BILL
	calla	dir_to_degrees
	callr	dump_puck
	.else
	callr	bounce_pass
	.endif
	jauc	SUCIDE
bounce_pass
	clr	a0
	move	a0,*a6(POF_SHOT_START),L
	movb	*a6(POF_NUMBER),a0
	move	@PUCK_CONTROL,a14,W
	cmp	a0,a14
	jrnz	pas_bpx
	move	a14,*a6(POF_PASS_START),L
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_BPASS,a14
	move	a14,*a6(POF_FLAGS),W
	callr	get_pass_stuff
		;a10 = script set address
		;a11 = button release address
	move	a11,*a6(POF_PASS_RELEASE),L
	call	a10			;set script
	callr	set_pass_mode
	callr	take_player_control
;	movb	*a6(POF_NUMBER),a1
;	sll	8,a1
;	addi	PIDOF_WATCH_PASS,a1
;	movi	pass_watch,a7
;	move	a6,a11
;	jauc	KILL_AND_GETPPRC
pas_bpx	rets


dump_puck	;a0 = direction, a1 = turbo
	PUSH	a0

;	move	*a6(POF_S_DUMP),a9,L

	callr	do_end_of_shoot_stuff
	movb	*a6(POF_NUMBER),a0
	move	@PUCK_CONTROL,a14,W
	cmp	a0,a14
	jrnz	pas_npx
	sll	8,a0
	addi	PIDOF_PASS_SHOOT,a0
	move	a0,*a13(PROCID),W
	clr	a0
	move	@PUCK_CONTROL,@PUCK_LAST_CONTROL,W
	move	a0,@PUCK_CONTROL,W
	calla	new_puck_control
	PULLQ	a0

;	move	*a9(PS_DP_DUMP_SPEED),a1,L
;	move	*a9(PS_DP_DUMP_CHANGE),a2,L
	movi	[8,0],a1
	movi	change_dump,a2

	movi	[-3,08000],a3				;-2.5
	move	*a6(POF_TURBO_MODE),a14,W
	jrz	pas_1

;	move	*a9(PS_DP_DUMP_TURBO),a1,L
;	move	*a9(PS_DP_TDUMP_CHANGE),a2,L
	movi	[10,0],a1
	movi	change_tdump,a2


	movi	[-3,0],a3
	calla	slap_shot_sound
	jruc	pas_11
pas_1	calla	wrist_shot_sound
pas_11	move	@PUCK_OBJECT,a8,L
	move	a3,*a8(OYVEL),L
	call	a2
	calla	set_obj_to_polar_v
	calla	give_puck_shot_gravity
	movi	30,a0
	move	a0,@PUCK_OPEN_CONTROL_TIME,W
	move	a0,@PUCK_OPEN_LAST_TIME,W
	movk	8,a0
	move	a0,*a6(POF_MODE),W
	movk	15,a0
	calla	set_safe_puck_mode_a0
pas_np	rets
pas_npx	PULLQ	a0
	rets

give_player_control
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrnz	gpca
	mmtm	sp,a0
	move	@WAVEIRQS,a0,L
	addi	40,a0
	move	a0,*a6(POF_DRONE_NO_CHECK),L
	mmfm	sp,a0
gpca	ori	M_PF_CONTROL,a14
	andni	M_PF_CONTROLB|M_PF_CONTROLM|M_PF_TRAILS,a14
	move	a14,*a6(POF_FLAGS),W
	clr	a14
	move	a14,*a6(POF_CONTROL_OBJECT),L
	move	a14,*a6(POF_CONTROL_SCRIPT),L
	mmtm	sp,a8
	move	*a6(POF_OBJECT),a8,L
	move	a14,*a8(ODT_SC_OVERRIDE),L
	move	a14,*a8(ODT_SC_XSCALE),W
	move	a14,*a8(OYACCEL),W
	move	a14,*a8(OYVEL),L
	move	a14,*a8(OYVAL),L
	move	*a8(OPARTS),a8,L
	jrz	gpcb
	move	a14,*a8(ODT_SC_OVERRIDE),L		;head
gpcb	mmfm	sp,a8
	rets
take_player_control
	move	*a6(POF_FLAGS),a14,W
	andni	M_PF_CONTROL|M_PF_CONTROLB|M_PF_CONTROLM,a14
	move	a14,*a6(POF_FLAGS),W
	jruc	cmnx
take_player_control_a7
	move	*a7(POF_FLAGS),a14,W
	andni	M_PF_CONTROL|M_PF_CONTROLB|M_PF_CONTROLM,a14
	move	a14,*a7(POF_FLAGS),W
	jruc	cmnx
take_player_control_m		;allow movement, but not script
	move	*a6(POF_FLAGS),a14,W
	andni	M_PF_CONTROL|M_PF_CONTROLB,a14
	ori	M_PF_CONTROLM,a14
	move	a14,*a6(POF_FLAGS),W
cmnx	clr	a14
	move	a14,*a6(POF_CONTROL_OBJECT),L
	move	a14,*a6(POF_CONTROL_SCRIPT),L
	jauc	clear_srt

**************************************************************************
*								         *
* get_shot_point							 *
* 	input	a0 = player						 *
* 	output	a0 = x							 *
* 		a1 = z							 *
* 		a2 = y							 *
*								         *
**************************************************************************
get_quick_shifted_shot_point	;just used for facing
	movb	*a6(POF_NUMBER),a0
	dec	a0
	srl	2,a0
	sll	5,a0
	addi	gqssp,a0
	move	*a0,a0,L
	movi	midz,a1
	rets
gqssp	.long	x_team1s
	.long	x_team2s

get_quick_shot_point	;just used for facing
	movb	*a6(POF_NUMBER),a0
	dec	a0
	srl	2,a0
	sll	5,a0
	addi	gqsp,a0
	move	*a0,a0,L
	movi	midz,a1
	rets
gqsp	.long	x_team1
	.long	x_team2

get_shot_point_nt	;non turbo shot
get_shot_point_t	;turbo shot
get_shot_point_ot	;one timer shot
	mmtm	sp,a3
	move	*a6(POF_FLAGS),a0,W
	btst	B_PF_HUMAN,a0
	jrz	gsp_drone
	movb	*a6(POF_NUMBER),a0
	sll	5,a0
	addi	spxl-32,a0
	move	*a0,a0,L
	movb	*a6(POF_JOY),a3

	.if	BILL & 0
	MOVK	2,A3
	.endif

	sll	7,a3
	add	a0,a3
	move	*a3(64),a0,L	;start y

	.if	BILL ;DON'T WANT PUCK IN AIR
	.else
	move	a0,a1
	addi	[10,0],a0
	subi	[10,0],a1
	calla	RANGERND
	move	a0,a0
	jrn	gr81
	clr	a0
	.endif

gr81	move	a0,a2
	move	*a3+,a0,L
	move	*a3+,a1,L
;	move	*a3,a2,L
	mmfm	sp,a3
	rets
gsp_drone
	movi	[13,0],a0
	movi	[-3,0],a1
	calla	RANGERND
	move	a0,a0
	jrn	aw984
	clr	a0
aw984	move	a0,a2
	movb	*a6(POF_NUMBER),a0
	dec	a0
	srl	2,a0
	sll	5,a0
	addi	gpdr,a0
	move	*a0+,a0,L
	movi	midz,a1
	mmfm	sp,a3
	rets

gpdr	.long	x_team1,x_team2

spxl	.long	team_1_postab
	.long	team_1_postab
	.long	team_1_postab
	.long	team_1_postab
	.long	team_2_postab
	.long	team_2_postab
	.long	team_2_postab
	.long	team_2_postab

	.if	BILL

lowy	.equ	[0,0]
midy	.equ	[0,0]
highy	.equ	[-41,0]

;lowz	.equ	[320,0]
;midz	.equ	[339,08000h]
;highz	.equ	[359,0]

;lowz	.equ	[287,0]	;[311,0]
;midz	.equ	[339,08000h]
;highz	.equ	[392,0]	;[368,0]

lowz	.equ	[319,0]
midz	.equ	[339,08000h]
highz	.equ	[360,0]

	.else

lowy	.equ	[3,0]		;keep us more on the ground
midy	.equ	[3,0]
highy	.equ	[-30,0]			;[-5,0]

lowz	.equ	[319,0]
midz	.equ	[339,08000h]
highz	.equ	[360,0]
	.endif

x_team1	.equ	[687,0]
x_team2	.equ	[-687,0]

x_team1s .equ	[690-65,0]
x_team2s .equ	[-690+65,0]

team_1_postab
	.long	x_team1,midz,midy,0
	.long	x_team1,lowz,midy,0
	.long	x_team1,lowz,lowy,0
	.long	x_team1,midz,lowy,0
	.long	x_team1,highz,lowy,0
	.long	x_team1,highz,midy,0
	.long	x_team1,highz,highy,0
	.long	x_team1,midz,highy,0
	.long	x_team1,lowz,highy,0

team_2_postab
	.long	x_team2,midz,midy,0
	.long	x_team2,lowz,midy,0
	.long	x_team2,lowz,highy,0
	.long	x_team2,midz,highy,0
	.long	x_team2,highz,highy,0
	.long	x_team2,highz,midy,0
	.long	x_team2,highz,lowy,0
	.long	x_team2,midz,lowy,0
	.long	x_team2,lowz,lowy,0

**************************************************************************
*								         *
* change_shot								 *
* change_pass								 *
* change_tshot								 *
* change_tpass								 *
* 	input	a0 = direction						 *
* 		a1 = velocity						 *
* 		a2 = y velocity						 *
* 		a6 = player block					 *
* 	output	as above						 *
*								         *
**************************************************************************
change_shot
	callr	are_we_edging
	jrc	change_edge
	move	a1,b6		;we can trash this
	move	a0,a1
	movi	XD0080,a14		;+/- 5 degrees
	move	a2,a2
	jrnz	acsp_1
	movi	XD0040,a14
acsp_1	sub	a14,a0
	add	a14,a1
	calla	RANGERND
	THETA_N	a0
	move	b6,a1
	rets
change_tpass
change_pass
	rets
	callr	are_we_edging
	jrc	change_edge
	move	a1,b6		;we can trash this
	move	a0,a1
	movi	XD0020,a14		;+/- 5 degrees
	move	a2,a2
	jrnz	csp_1
	movi	XD0010,a14
csp_1	sub	a14,a0
	add	a14,a1
	calla	RANGERND
	THETA_N	a0
	move	b6,a1
	rets

change_tshot
change_dump
	callr	are_we_edging
	jrc	change_edge
	move	a1,b6		;we can trash this
	move	a0,a1
	movi	XD0110,a14		;+/- 5 degrees
	move	a2,a2
	jrnz	cttd_1
	movi	XD0060,a14
cttd_1	sub	a14,a0
	add	a14,a1
	calla	RANGERND
	THETA_N	a0
	move	b6,a1
	rets

change_tdump
	callr	are_we_edging
	jrc	change_edge
	move	a1,b6		;we can trash this
	move	a0,a1
	movi	XD0100,a14		;+/- 5 degrees
	sub	a14,a0
	add	a14,a1
	calla	RANGERND
	THETA_N	a0
	move	b6,a1
	rets

change_edge
	move	a1,b6		;we can trash this
	move	a0,a1
	movi	XD0030,a14		;+/- 5 degrees
	sub	a14,a0
	add	a14,a1
	calla	RANGERND
	THETA_N	a0
	move	b6,a1
	rets

are_we_edging			;cs = we are pushing the puck along an edge
	mmtm	sp,a8
	move	*a6(POF_OBJECT),a8,L
	move	*a8(OZPOS),a14,W
	cmpi	649,a14
	jrge	awe_p1
	cmpi	32,a14
	jrgt	awe_npo
awe_p1	cmpi	XD0040,a0
	jrls	awe_ys
	cmpi	XD3600-XD0040,a0
	jrhs	awe_ys
	cmpi	XD1800-XD0040,a0
	jrlo	awe_no
	cmpi	XD1800+XD0040,a0
	jrhi	awe_no
awe_ys	setc
	mmfm	sp,a8
	rets

awe_npo	move	*a8(OXVAL),a14,L
	addi	[0,08000h],a14
	sra	16,a14
;awe_npo	move	*a8(OXPOS),a14,W	;half

	cmpi	-768,a14
	jrle	awe_n2
	cmpi	768,a14
	jrlt	awe_no
awe_n2	cmpi	XD0900-XD0040,a0
	jrlo	awe_no
	cmpi	XD0900+XD0040,a0
	jrls	awe_ys
	cmpi	XD2700-XD0040,a0
	jrlo	awe_no
	cmpi	XD2700+XD0040,a0
	jrls	awe_ys
awe_no	clrc
	mmfm	sp,a8
	rets

**************************************************************************
*								         *
* int_control								 *
* off_control								 *
* def_control								 *
* 	how do we handle a player coming in contact with the puck	 *
* 	input	a4 = distance to puck					 *
* 		a6 = player block					 *
* 		a8 = puck_object					 *
* 	output	a0 = 0 - ignore puck, we are too far away		 *
* 		   = 1 - puck is unaffected, we miss it			 *
* 		   = 2 - puck is rebounded				 *
* 		   = 3 - puck is controlled				 *
* 		a1 = speed to rebound puck away if a0 = 2		 *
* 		a2 = ticks to ignore control if a0 = 1 or 2		 *
*								         *
**************************************************************************
int_control
	cmpi	50,a4
	jrhs	ctrl_0
	move	@PUCK_MODE,a14,W
	cmpi	1,a14			;face off?
	jrz	ctrl_3			;then we always control
	move	*a8(ODT_VEL+010h),a0,W
	cmpi	5,a0
	jrls	dc_c
	cmpi	35,a4
	jrhs	ctrl_0
dc_c	move	*a6(POF_OBJECT),a9,L
	calla	find_closest_distance
	move	*a8(ODT_VEL+010H),a1,W	;velocity (high word)
	move	*a8(OYPOS),a3,W
	neg	a3
	cmpi	15,a3
	jrhs	ic_air
	movi	intended_dist_table,a5
	jruc	table_from_distance
ic_air	movi	intended_dist_air_table,a5
	jruc	table_from_distance

off_control1
	move	@PUCK_MODE,a7
	cmpi	PUM_PASS,a7
	jrz	int_control
	cmpi	PUM_TPASS,a7
	jrz	int_control
def_control1
	movk	1,a7
	jruc	mrodt
off_control2
	move	@PUCK_MODE,a7
	cmpi	PUM_PASS,a7
	jrz	int_control
	cmpi	PUM_TPASS,a7
	jrz	int_control
def_control2
	movk	2,a7
	jruc	mrodt
off_control3
	move	@PUCK_MODE,a7
	cmpi	PUM_PASS,a7
	jrz	int_control
	cmpi	PUM_TPASS,a7
	jrz	int_control
def_control3
	movk	3,a7
	jruc	mrodt
off_control4
	move	@PUCK_MODE,a7
	cmpi	PUM_PASS,a7
	jrz	int_control
	cmpi	PUM_TPASS,a7
	jrz	int_control
def_control4
	movk	4,a7
	jruc	mrodt
off_control5
	move	@PUCK_MODE,a7
	cmpi	PUM_PASS,a7
	jrz	int_control
	cmpi	PUM_TPASS,a7
	jrz	int_control
def_control5
	movk	5,a7
mrodt	cmpi	50,a4
	jrhs	ctrl_0
	move	@PUCK_MODE,a14,W
	cmpi	PUM_FACE,a14			;face off?
	jrz	ctrl_3			;then we always control
	move	*a6(POF_MODE),a14,W
	cmpi	PM_BLOCK,a14
	jrz	ctrl_2			;blocking, always deflect
	cmpi	PM_SHOOT,a14
	jrz	ctrl_0
	move	*a8(ODT_VEL+010h),a0,W
	cmpi	5,a0
	jrls	dc_p			;if puck is stopped, within 50 else 35
	cmpi	35,a4
	jrhs	ctrl_0
dc_p	move	*a6(POF_OBJECT),a9,L
	calla	find_closest_distance
	move	*a8(ODT_VEL+010H),a1,W	;velocity
	move	*a8(OYPOS),a3,W
	neg	a3
	move	*a6(POF_OBJECT),a5,L
	move	*a5(OSIZEY),a5,W
	cmp	a5,a3
	jrhs	ctrl_0
	cmpi	15,a3
	jrhs	dc_air
	movi	defense_dist_table-32,a5
	sll	5,a7
	add	a7,a5
	move	*a5,a5,L
	jruc	table_from_distance
dc_air	movi	defense_dist_air_table-32,a5
	sll	5,a7
	add	a7,a5
	move	*a5,a5,L
	jruc	table_from_distance

**************************************************************************
*								         *
* GOFF_CONTROL								 *
* GDEF_CONTROL								 *
*								         *
**************************************************************************

GOFF_CONTROL
GDEF_CONTROL
	MOVE	*A6(POF_D_COLL),A14,W
	CMP	A14,A4 ;40 ;30
	JRHS	ctrl_0				;BR=OUTSIDE CHECK RANGE

	MOVE	@PUCK_INTENDED,A0,W
	JRZ	GDC_GO				;BR=NOT A PASS
	MOVB	*A6(POF_NUMBER),A1
	EQTEAM	A0,A1
	JRZ	ctrl_0				;BR=GOALIES'S TEAM PASSIN'
GDC_GO

	;CHECK FETCHING THE PUCK FLAG?

;	MOVE	*A6(POF_OBJECT),A5,L
;	MOVE	*A5(OXVAL),A0,L			;GOALIE POSITION
;	MOVE	*A5(OZVAL),A1,L
;	MOVE	*A8(OXVAL),A2,L			;PUCK POSITION
;	MOVE	*A8(OZVAL),A3,L
;
;	CALLA	find_dir_to_point		;DIRECTION FROM PUCK TO GOALIE
;
;	MOVE	*A8(ODT_DIR),A1,L		;PUCK DIRECTION
;	SUB	A0,A1
;	ABS	A1
;	CMPI	XD0900,A1
;	LOCKON	GT
;	JRGT	ctrl_0				;BR=NOT HEADING TOWARD GOALIE

	MOVE	*A6(POF_MODE),A14,W
	CMPI	PM_GCHECKED,A14
	JREQ	ctrl_0				;BR=GETTIN' CHECKED

	MOVE	*A6(POF_OBJECT),A5,L

	MOVE	*A5(ODT_GSAVETIME),A14,W
	JRNZ	ctrl_0				;BR=IN A SAVE

;	MOVE	*A5(ODT_GFLAGS),A14,W
;	BTST	B_MISSSAVE,A14
;	JRNZ	ctrl_0				;BR=MISSIN' PUCK

	MOVE	*A8(ODT_VEL+010H),A0,W
	CMP	A0,A4
;	JRGE	ctrl_0				;BR=NO INTERSECTION
	JRLE	GDC_P				;BR=POTENTIAL IMPACT

;	JRUC	ctrl_0

	MOVE	*A6(POF_D_PUCK),A0,W
	MOVE	*A6(POF_D_LASTPUCK0),A3,L
	MOVE	A3,A14
	SRA	16,A14
	CMP	A0,A14				;CHECK AGAINST PREVIOUS
	JRGE	ctrl_0				;BR=COMING CLOSER
	SEXT	A3,W
	CMP	A3,A14
	JRGT	ctrl_0				;BR=GOING AWAY

	move	*a8(OYPOS),a3,W
	neg	a3
	move	*a5(OSIZEY),a14,W
	cmp	a14,a3
	jrhs	ctrl_0				;BR=OVER YOUR HEAD (IGNORE)

	MOVE	*A8(OXVEL),A14,L
	MOVE	*A8(OXVAL),A0,L
	SUB	A14,A0
	MOVE	A0,*A8(OXVAL),L

	MOVE	*A8(OZVEL),A14,L
	MOVE	*A8(OZVAL),A0,L
	SUB	A14,A0
	MOVE	A0,*A8(OZVAL),L

	JRUC	GDC_2

GDC_P
;	move	*a6(POF_OBJECT),a9,L
;	calla	find_closest_distance
;	move	*a8(ODT_VEL+010H),a1,W	;velocity

	move	*a8(OYPOS),a3,W
	neg	a3
	move	*a5(OSIZEY),a14,W
	cmp	a14,a3
	jrhs	ctrl_0				;BR=OVER YOUR HEAD (IGNORE)

;	MOVK	GS_REBOUND,A0
;	CALLA	GOALIE_SPEECH

;	JRUC	ctrl_2				;REBOUND OTHERWISE

;	MOVE	*A8(OXVAL),A0,L
;	MOVE	*A8(OXVEL),A14,L
;	ADD	A14,A0
;	MOVE	A0,*A8(OXVAL),L
;
;	MOVE	*A8(OZVAL),A0,L
;	MOVE	*A8(OZVEL),A14,L
;	ADD	A14,A0
;	MOVE	A0,*A8(OZVAL),L
;
;	MOVE	*A8(OFLAGS),A14,W
;	ORI	M_FVELADD,A14
;	MOVE	A14,*A8(OFLAGS),W

GDC_2

;ctrl_2 WITH IGNORE TIME SHORTENED.

	movk	2,a0				;2 = we deflect it
	move	*a8(ODT_VEL),a1,L		;velocity
	JRZ	ctrl_0				;BR=NOT	MOVING
	sra	2,a1				; / 4
	movk	10,a2
	calla	puck_rebound_sound
	rets

;;	cmpi	15,a3
;;	jrhs	GCD_AIR
;	MOVI	GDEFENSE_DIST_TABLE,A5
;	jruc	table_from_distance
;;GDC_AIR
;;	MOVI	GDEFENSE_DIST_AIR_TABLE,A5
;;	jruc	table_from_distance

table_from_distance		;a5 = table, a1 = puck speed, a0 = closest distance
tfd1	move	*a5,a2,W
	cmp	a2,a0		;CHECK DISTANCE
	jrls	tfd2		;BR=FOUND SPEED TABLE
	addi	48,a5
	jruc	tfd1
tfd2	move	*a5(16),a5,L	;SPEED TABLE
	;fall through
control_from_speed_table	;a5 = table, a1 = puck speed
	movi	100,a0
	calla	RAND0		;GET RANDOM EVENT
cfst1	move	*a5,a2,W
	cmp	a2,a1		;CHECK SPEED
	jrls	cfst2		;BR=FOUND SPEED TABLE ENTRY
	addi	48,a5
	jruc	cfst1
cfst2	move	*a5(16),a2,W	;GET MISS (LOWER) LIMIT
	cmp	a2,a0		;CHECK IF MISS
	jrlo	ctrl_1
	move	*a5(32),a2,W	;GET REBOUND (UPPER) LIMIT
	cmp	a2,a0		;CHECK IF REBOUND
	jrlo	ctrl_2
	jruc	ctrl_3

ctrl_0	clr	a0				;0 = we are too far away, or other ignore condition
	rets
ctrl_1	movk	1,a0				;1 = we missed it
	movk	30,a2
	rets
ctrl_2	movk	2,a0				;2 = we deflect it
	move	*a8(ODT_VEL),a1,L		;velocity
	sra	2,a1				; / 4
	movk	30,a2
	calla	puck_rebound_sound
	rets
ctrl_3
	movb	*a6(POF_NUMBER),a0
	move	@PUCK_INTENDED,a14
	cmp	a0,a14
	jrnz	ct3x
	calla	spx_pass_2
	jruc	ct_4x
ct3x	calla	spx_intercept_control
ct_4x	movk	3,a0				;3 = we control it
	calla	puck_stop_sound
	rets

intended_dist_table
	WL	5,intended_speed_c_table
	WL	15,intended_speed_1_table
	WL	32767,intended_speed_2_table
intended_dist_air_table
	WL	5,intended_air_c_table
	WL	15,intended_air_1_table
	WL	32767,intended_air_2_table

defense_dist_table
	.long	defense1_dist_table
	.long	defense2_dist_table
	.long	defense3_dist_table
	.long	defense4_dist_table
	.long	defense5_dist_table
defense_dist_air_table
	.long	defense1_dist_air_table
	.long	defense2_dist_air_table
	.long	defense3_dist_air_table
	.long	defense4_dist_air_table
	.long	defense5_dist_air_table
defense1_dist_table
	WL	10,defense_speed1_1_table
	WL	32767,defense_speed1_2_table
defense1_dist_air_table
	WL	10,defense_air1_1_table
	WL	32767,defense_air1_2_table

defense2_dist_table
	WL	10,defense_speed2_1_table
	WL	32767,defense_speed2_2_table
defense2_dist_air_table
	WL	10,defense_air2_1_table
	WL	32767,defense_air2_2_table

defense3_dist_table
	WL	10,defense_speed3_1_table
	WL	32767,defense_speed3_2_table
defense3_dist_air_table
	WL	10,defense_air3_1_table
	WL	32767,defense_air3_2_table

defense4_dist_table
	WL	10,defense_speed4_1_table
	WL	32767,defense_speed4_2_table
defense4_dist_air_table
	WL	10,defense_air4_1_table
	WL	32767,defense_air4_2_table

defense5_dist_table
	WL	10,defense_speed5_1_table
	WL	32767,defense_speed5_2_table
defense5_dist_air_table
	WL	10,defense_air5_1_table
	WL	32767,defense_air5_2_table

;GDEFENSE_DIST_TABLE
;	WL	10,GDEFENSE_SPEED_1_TABLE
;	WL	32767,GDEFENSE_SPEED_2_TABLE
;GDEFENSE_DIST_AIR_TABLE
;	WL	10,GDEFENSE_AIR_1_TABLE
;	WL	32767,GDEFENSE_AIR_2_TABLE

;	.word	speed,%1,%2	;3 is by default
intended_speed_c_table
	.word	32767,0,0
intended_speed_1_table
	.word	32767,0,0
intended_speed_2_table
	.word	32767,0,0

intended_air_c_table
	.word	32767,0,0
intended_air_1_table
	.word	32767,0,0
intended_air_2_table
	.word	32767,0,0

defense_speed1_1_table
	.word	5,0,0
	.word	6,1,2
	.word	7,1,7
	.word	8,2,12
	.word	9,3,19
	.word	10,5,27
	.word	11,8,38
	.word	12,9,49
	.word	13,10,71
	.word	14,11,82
	.word	32767,12,93
defense_speed1_2_table
	.word	5,0,0
	.word	6,3,7
	.word	7,3,11
	.word	8,4,16
	.word	9,5,23
	.word	10,8,32
	.word	11,10,43
	.word	12,11,54
	.word	13,12,76
	.word	14,13,87
	.word	32767,14,98

defense_speed2_1_table
	.word	5,0,0
	.word	6,1,2
	.word	7,1,6
	.word	8,2,12
	.word	9,3,18
	.word	10,5,26
	.word	11,7,37
	.word	12,8,47
	.word	13,9,68
	.word	14,10,79
	.word	32767,12,89
defense_speed2_2_table
	.word	5,0,0
	.word	6,3,6
	.word	7,3,10
	.word	8,4,16
	.word	9,5,22
	.word	10,7,30
	.word	11,9,41
	.word	12,10,51
	.word	13,12,72
	.word	14,13,83
	.word	32767,14,93

defense_speed3_1_table
	.word	5,0,0
	.word	6,1,2
	.word	7,1,6
	.word	8,2,11
	.word	9,3,17
	.word	10,5,25
	.word	11,7,35
	.word	12,8,45
	.word	13,9,65
	.word	14,10,75
	.word	32767,11,85
defense_speed3_2_table
	.word	5,0,0
	.word	6,3,6
	.word	7,3,10
	.word	8,4,15
	.word	9,5,21
	.word	10,7,29
	.word	11,9,39
	.word	12,10,49
	.word	13,11,69
	.word	14,12,79
	.word	32767,13,89

defense_speed4_1_table
	.word	5,0,0
	.word	6,1,2
	.word	7,1,6
	.word	8,2,10
	.word	9,3,16
	.word	10,5,24
	.word	11,7,33
	.word	12,8,43
	.word	13,9,62
	.word	14,9,71
	.word	32767,10,81
defense_speed4_2_table
	.word	5,0,0
	.word	6,3,6
	.word	7,3,9
	.word	8,4,14
	.word	9,5,20
	.word	10,7,28
	.word	11,9,37
	.word	12,9,47
	.word	13,9,63
	.word	14,11,75
	.word	32767,12,85

defense_speed5_1_table
	.word	5,0,0
	.word	6,1,2
	.word	7,1,5
	.word	8,2,10
	.word	9,3,15
	.word	10,4,22
	.word	11,6,31
	.word	12,7,40
	.word	13,8,58
	.word	14,9,67
	.word	32767,10,76
defense_speed5_2_table
	.word	5,0,0
	.word	6,3,5
	.word	7,3,9
	.word	8,4,13
	.word	9,4,19
	.word	10,6,26
	.word	11,8,35
	.word	12,9,44
	.word	13,10,62
	.word	14,11,71
	.word	32767,12,80

;GDEFENSE_SPEED_1_TABLE
;	.word	5,0,100      ;0
;	.word	6,1,100      ;2
;	.word	7,1,100      ;6
;	.word	8,2,100      ;11
;	.word	9,3,100      ;17
;	.word	10,5,100     ;25
;	.word	11,7,100     ;35
;	.word	12,8,100     ;45
;	.word	13,9,100     ;65
;	.word	14,10,100    ;75
;	.word	32767,11,100 ;85
;GDEFENSE_SPEED_2_TABLE
;	.word	5,0,100	     ;0
;	.word	6,3,100      ;6
;	.word	7,3,100      ;10
;	.word	8,4,100      ;15
;	.word	9,5,100      ;21
;	.word	10,7,100     ;29
;	.word	11,9,100     ;39
;	.word	12,10,100    ;49
;	.word	13,11,100    ;69
;	.word	14,12,100    ;79
;	.word	32767,13,100 ;89

defense_air1_1_table
	.word	5,5,11
	.word	6,7,14
	.word	7,9,18
	.word	8,11,21
	.word	9,13,33
	.word	10,15,44
	.word	11,19,55
	.word	12,22,71
	.word	13,25,82
	.word	14,31,88
	.word	32767,44,93

defense_air1_2_table
	.word	5,8,15
	.word	6,9,19
	.word	7,11,22
	.word	8,13,25
	.word	9,15,37
	.word	10,18,48
	.word	11,21,59
	.word	12,24,76
	.word	13,27,87
	.word	14,33,92
	.word	32767,46,98

defense_air2_1_table
	.word	5,5,10
	.word	6,6,14
	.word	7,8,17
	.word	8,10,20
	.word	9,13,31
	.word	10,15,42
	.word	11,18,52
	.word	12,21,68
	.word	13,24,79
	.word	14,29,84
	.word	32767,42,89

defense_air2_2_table
	.word	5,7,15
	.word	6,8,18
	.word	7,10,21
	.word	8,13,24
	.word	9,15,36
	.word	10,17,46
	.word	11,20,57
	.word	12,23,72
	.word	13,26,83
	.word	14,31,88
	.word	32767,44,93

defense_air3_1_table
	.word	5,5,10
	.word	6,6,13
	.word	7,8,16
	.word	8,10,19
	.word	9,12,30
	.word	10,14,40
	.word	11,17,50
	.word	12,20,65
	.word	13,23,75
	.word	14,28,80
	.word	32767,40,85
defense_air3_2_table
	.word	5,7,14
	.word	6,8,17
	.word	7,10,20
	.word	8,12,23
	.word	9,14,34
	.word	10,16,44
	.word	11,19,54
	.word	12,22,69
	.word	13,25,79
	.word	14,30,84
	.word	32767,42,89

defense_air4_1_table
	.word	5,5,9
	.word	6,6,12
	.word	7,8,15
	.word	8,9,18
	.word	9,11,28
	.word	10,13,38
	.word	11,16,47
	.word	12,19,62
	.word	13,22,71
	.word	14,27,76
	.word	32767,38,81

defense_air4_2_table
	.word	5,7,13
	.word	6,8,16
	.word	7,9,19
	.word	8,11,22
	.word	9,13,32
	.word	10,15,42
	.word	11,18,51
	.word	12,21,66
	.word	13,24,75
	.word	14,28,80
	.word	32767,40,85

defense_air5_1_table
	.word	5,4,9
	.word	6,5,12
	.word	7,7,14
	.word	8,9,17
	.word	9,11,27
	.word	10,13,36
	.word	11,15,45
	.word	12,18,58
	.word	13,21,67
	.word	14,25,72
	.word	32767,36,76

defense_air5_2_table
	.word	5,6,13
	.word	6,7,15
	.word	7,9,18
	.word	8,11,21
	.word	9,13,31
	.word	10,14,40
	.word	11,17,49
	.word	12,20,62
	.word	13,22,71
	.word	14,27,76
	.word	32767,38,80

clean_up_my_signals	;(my team)
	mmtm	sp,a0,a1
	clr	a1
	movb	*a6(POF_NUMBER),a14
	dec	a14
	srl	2,a14
	sll	2,a14
	inc	a14
	GBLOCK	a14,a14
	move	*a14(POF_FLAGS),a0,W
	andni	M_PF_SIG_SHOOT|M_PF_SIG_PASS,a0
	move	a0,*a14(POF_FLAGS),W
	move	a1,*a14(POF_DRONE_BUTTONS),W
	move	*a14(PLAYER_BLOCK_SIZE+POF_FLAGS),a0,W
	andni	M_PF_SIG_SHOOT|M_PF_SIG_PASS,a0
	move	a0,*a14(PLAYER_BLOCK_SIZE+POF_FLAGS),W
	move	a1,*a14(PLAYER_BLOCK_SIZE+POF_DRONE_BUTTONS),W
	move	*a14((3*PLAYER_BLOCK_SIZE)+POF_FLAGS),a0,W
	andni	M_PF_SIG_SHOOT|M_PF_SIG_PASS,a0
	move	a0,*a14((3*PLAYER_BLOCK_SIZE)+POF_FLAGS),W
	move	a1,*a14((3*PLAYER_BLOCK_SIZE)+POF_DRONE_BUTTONS),W
	mmfm	sp,a0,a1
	rets

clear_all_signals
	mmtm	sp,a0,a1,a2
	movk	8,a0
	clr	a2
	movi	PLAYER_1_BLOCK,a1
casl	move	*a1(POF_FLAGS),a14,W
	andni	(M_PF_SIG_SHOOT|M_PF_SIG_PASS),a14
	move	a14,*a1(POF_FLAGS),W
	move	a2,*a1(POF_DRONE_BUTTONS),W
	addi	PLAYER_BLOCK_SIZE,a1
	dsjs	a0,casl
	mmfm	sp,a0,a1,a2
	rets

fix_all_signals
	mmtm	sp,a0,a1,a2,a6
	move	@WAVEIRQS,a1,L
	move	@faceoff_time,a14,L
	sub	a14,a1
	cmpi	40,a1
	jrls	fas99
	movk	1,a0
	callr	fas
	movk	2,a0
	callr	fas
	movk	5,a0
	callr	fas
	movk	6,a0
	callr	fas
fas99	mmfm	sp,a0,a1,a2,a6
	rets
fas	GBLOCK	a0,a6
	move	*a6(POF_FLAGS),a1,W
	move	*a6(POF_BUTTONS),a2,W
	btst	B_PF_HUMAN,a1
	jrz	fas3
	btst	0,a2
	jrz	fas3
	move	*a6(POF_TURBO_MODE),a2,W
	jrnz	fas3
	ori	M_PF_SIG_SHOOT,a1
	move	a1,*a6(POF_FLAGS),W
fas3	rets

signal_to_pass
	mmtm	sp,a1
	move	@WAVEIRQS,a1,L
	move	@faceoff_time,a14,L
	sub	a14,a1
	cmpi	28,a1
	jrls	stp_9
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_SIG_PASS,a14
	move	a14,*a6(POF_FLAGS),W
stp_9	mmfm	sp,a1
	rets

signal_to_shoot
	mmtm	sp,a1
	move	@WAVEIRQS,a1,L
	move	@faceoff_time,a14,L
	sub	a14,a1
	cmpi	40,a1
	jrls	sts_9
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_SIG_SHOOT,a14
	move	a14,*a6(POF_FLAGS),W
sts_9	mmfm	sp,a1
	rets

read_joystick
	mmtm	sp,a0,a1,a2,a3
	KITN	2
	jrnz	rjva_a
	move	a0,a14
	sll	6,a14
	addi	joystick_shift_table_2p-64,a14
	jruc	rjva_b
rjva_a	move	a0,a14
	sll	6,a14
	addi	joystick_shift_table-64,a14
rjva_b	move	*a14+,a1,L		;get stick address to read
	move	*a14,a14,W		;get shift amount
	move	*a1,a1,W
	move	a1,a2
	srl	4,a2
	srl	a14,a2
	not	a2
	sll	24,a2
	srl	24,a2
	move	a2,*a6(POF_BUTTONS),W	;buttons read
	srl	a14,a1
	sll	28,a1
	srl	24,a1
	addi	joystick_pos_table,a1
	move	*a1,a14,W		;convert bits to joystick direction
	movb	*a6(POF_I_JOY),a1	;remove our corner check if on
	cmp	a1,a14
	jrnz	rjjj
	clr	a14			;we are at corner, joystick is 0
	jruc	rjjk
rjjj	clr	a1
	movb	a1,*a6(POF_I_JOY)	;clear out corner check, we are not there
rjjk	movb	a14,*a6(POF_JOY)	;store raw stick direction
	callr	player_rink_check	;modify based on rink position	- TRASHES A3
	movb	a0,*a6(POF_M_JOY)	;store modified direction
	mmfm	sp,a0,a1,a2,a3
	rets

read_joystick_short
	mmtm	sp,a0,a1,a2,a3
	KITN	2
	jrnz	rjsa_a
	move	a0,a14
	sll	6,a14
	addi	joystick_shift_table_2p-64,a14
	jruc	rjsa_b
rjsa_a	move	a0,a14
	sll	6,a14
	addi	joystick_shift_table-64,a14
rjsa_b	move	*a14+,a1,L		;get stick address to read
	move	*a14,a14,W		;get shift amount
	move	*a1,a1,W
	move	a1,a2
	srl	4,a2
	srl	a14,a2
	not	a2
	sll	24,a2
	srl	24,a2
	move	a2,*a6(POF_BUTTONS),W	;buttons read
	srl	a14,a1
	sll	28,a1
	srl	24,a1
	addi	joystick_pos_table,a1
	move	*a1,a14,W		;convert bits to joystick direction
	movb	a14,*a6(POF_JOY)	;store raw stick direction
	movb	a14,*a6(POF_M_JOY)	;store modified direction
	mmfm	sp,a0,a1,a2,a3
	rets

read_just_buttons	;in on a9, out on a2
	move	a9,a14
	sll	6,a14
	addi	joystick_shift_table-64,a14
	move	*a14+,a2,L		;get stick address to read
	move	*a14,a14,W		;get shift amount
	move	*a2,a2,W
	srl	4,a2
	srl	a14,a2
	not	a2
	sll	24,a2
	srl	24,a2
	rets

joystick_shift_table
	.long	SWITCH,0
	.long	SWITCH,-8
	.long	0,0
	.long	0,0
	.long	SWITCH2,0
	.long	SWITCH2,-8
	.long	0,0
	.long	0,0

joystick_shift_table_2p
	.long	SWITCH,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	SWITCH,-8
	.long	0,0
	.long	0,0

joystick_pos_table
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	2
	.word	4
	.word	3
	.word	0
	.word	8
	.word	6
	.word	7
	.word	0
	.word	1
	.word	5
	.word	0

player_rink_check
	movb	*a6(POF_JOY),a0
	mmtm	sp,a0
	callr	drone_rink_check
	mmfm	sp,a14
	cmp	a0,a14
	jrz	prc_9
	move	a0,a0
	jrnz	prc_9

	move	*a8(OXVEL),a0,L
	move	*a8(OZVEL),a1,L
	sll	5,a14
	addi	prc_rrx,a14
	move	*a14,a14,L
	jump	a14
prc_9	rets

prc_rrx	.long	rrx0
	.long	rrx1
	.long	rrx2
	.long	rrx3
	.long	rrx4
	.long	rrx5
	.long	rrx6
	.long	rrx7
	.long	rrx8

rrx0	rets
rrx1	jruc	rznx
rrx2	callr	rxp
	jruc	rznx
rrx3	jruc	rxpx
rrx4	callr	rxp
	jruc	rzpx
rrx5	jruc	rzpx
rrx6	callr	rxn
	jruc	rzpx
rrx7	jruc	rxnx
rrx8	callr	rxn
	jruc	rznx

rxpx	callr	rxp
	jruc	rxzx
rxnx	callr	rxn
	jruc	rxzx
rzpx	callr	rzp
	jruc	rxzx
rznx	callr	rzn
rxzx	jauc	set_obj_to_rect

rxp	move	a0,a0
	jrz	rxp9
	jrn	rxp9
	clr	a0
rxp9	rets
rxn	move	a0,a0
	jrnn	rxn9
	clr	a0
rxn9	rets

rzp	move	a1,a1
	jrz	rzp9
	jrn	rzp9
	clr	a1
rzp9	rets
rzn	move	a1,a1
	jrnn	rzn9
	clr	a1
rzn9	rets

drone_rink_check
;	mmtm	sp,a0
;	calla	get_players_puck_point_o
;	mmtm	sp,a0,a1
;	srl	16,a0
;	move	a0,a14
;	movy	a1,a14
;	callr	pcl_fnd
;	mmfm	sp,a9,a11
;	mmfm	sp,a0
;	call	a1
;	mmtm	sp,a0
;	move	a9,a0
;	move	a11,a1
;	calla	move_player_to_puckpoint
;	mmfm	sp,a0

	move	*a8(OXVAL),a14,L
	addi	[0,08000h],a14
	sra	16,a14
;	move	*a8(OXPOS),a14,W	;half

	move	*a8(OZPOS),a1,W
	sll	16,a1
	movy	a1,a14			;a14 = [z,x] of puck
	callr	pcl_fnd
	move	*a8(OXVAL),a9,L
	move	*a8(OZVAL),a11,L
	call	a1			;go to address for further checks
	callr	blue_line_check		;keep player from going too far into zone
	callr	close_area_check
	move	a9,*a8(OXVAL),L
	move	a11,*a8(OZVAL),L
	rets

goalie_rink_check
	mmtm	sp,a0
	move	*a8(OXVAL),a14,L
	addi	[0,08000h],a14
	sra	16,a14
	move	*a8(OZPOS),a1,W
	sll	16,a1
	movy	a1,a14			;a14 = [z,x] of puck
	callr	pcl_gfd
	move	*a8(OXVAL),a9,L
	move	*a8(OZVAL),a11,L
	mmtm	sp,a9,a11
	call	a1			;go to address for further checks
	mmfm	sp,a0,a1
	cmp	a0,a9
	jrnz	grc_stp
	cmp	a1,a11
	jrnz	grc_stp
	mmfm	sp,a0
	rets
grc_stp	LOCKUP
	mmfm	sp,a0
	move	a9,*a8(OXVAL),L
	move	a11,*a8(OZVAL),L
	rets

close_area_check
	clr	a1
	move	*a8(OXVAL),a14,L
	addi	[0,08000h],a14
	sra	16,a14
	cmpi	705,a14
	jrlt	cac1
	ori	11100b,a1		;no face 2,3,4
	jruc	cac2
cac1	cmpi	-705,a14
	jrgt	cac2
	ori	111000000b,a1		;no face 6,7,8
cac2	move	*a8(OZPOS),a2,W
	cmpi	420,a2
	jrhs	cac3
	cmpi	258,a2
	jrls	cac3
	cmpi	730,a14
	jrgt	cac4
	cmpi	-730,a14
	jrge	cac3
cac4	ori	111011100b,a1
cac3	move	a1,*a6(POF_NOFACE),W

	clr	a1
	move	*a8(OZVAL),a3,L
	cmpi	TOP_GOALPOST_Z+[10,0],a3
	jrgt	dfbg8
	cmpi	BOT_GOALPOST_Z-[10,0],a3
	jrlt	dfbg8
	move	*a8(OXVAL),a4,L
	move	a4,a14
	abs	a14
	cmpi	02800000h,a14
	jrlt	dfbg8
	movk	3,a1		;right and left
dfbg8	move	a1,*a6(POF_PPMOD),W
	rets

;;	mmtm	sp,a0
;	movk	1,a4	;right
;	movk	2,a5	;left
;;	movk	4,a0	;up
;;	movk	8,a3	;down
;	clr	a1
;	move	*a8(OXVAL),a14,L
;	addi	[0,08000h],a14
;	sra	16,a14
;
;	cmpi	705,a14
;	jrlt	cac1
;	or	a4,a1
;cac1	cmpi	-705,a14
;	jrgt	cac2
;	or	a5,a1
;cac2	move	*a8(OZPOS),a14,W
;	cmpi	420,a14
;	jrhs	cac3
;	cmpi	258,a14
;	jrls	cac3
;	move	*a8(OXVAL),a14,L
;	addi	[0,08000h],a14
;	sra	16,a14
;
;	cmpi	730,a14
;	jrgt	cac4
;	cmpi	-730,a14
;	jrge	cac3
;cac4	or	a4,a1
;	or	a5,a1
;cac3	move	a1,*a6(POF_PPMOD),W
;;	mmfm	sp,a0
;	rets

blue_line_check
	move	*a8(OFLAGS),a14
	btst	B_OFSCRN,a14
	jrz	blc_9			;still on screen, ok
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CELEBRATE,a14
	jrnz	blc_9
	movb	*a6(POF_NUMBER),a1
	move	@PUCK_CONTROL,a14,W
	cmp	a14,a1
	jrz	blc_9			;if for some reason, we have puck, but are off screen
	callr	are_we_intended
	jrc	blc_9
	dec	a1
	srl	2,a1			;0 - team one, 1 - team 2
	sll	5,a1
	addi	blc_l,a1
	move	*a1,a1,L
	jump	a1
blc_9	rets
blc_l	.long	blc_team_1
	.long	blc_team_2

blc_team_1
	mmtm	sp,a0
	move	@PUCK_OBJECT,a0,L
	move	*a0(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
;	move	*a0(OXPOS),a0,W		;half

	cmpi	220,a0			;if the puck is over the blue line, we can go anywhere
	jrge	bt1_d
	move	a11,a2
	sra	16,a2
	calla	find_rworld_from_z
	addi	[60,0],a0
	cmpi	[235,0],a0
	jrgt	bt1_c
	movi	[235,0],a0
bt1_c	cmp	a0,a9
	jrle	bt1_d
	move	a0,a9
	mmfm	sp,a0
	jruc	remove_right
bt1_d	mmfm	sp,a0
	rets

blc_team_2
	mmtm	sp,a0
	move	@PUCK_OBJECT,a0,L
	move	*a0(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
;	move	*a0(OXPOS),a0,W		;half

	cmpi	-220,a0			;if the puck is over the blue line, we can go anywhere
	jrle	bt2_d
	move	a11,a2
	sra	16,a2
	calla	find_lworld_from_z
	subi	[60,0],a0
	cmpi	[-235,0],a0
	jrlt	bt2_c
	movi	[-235,0],a0
bt2_c	cmp	a0,a9
	jrge	bt2_d
	move	a0,a9
	mmfm	sp,a0
	jruc	remove_left
bt2_d	mmfm	sp,a0
	rets

pcl_gfd	movi	goalie_check_table,a4
	jruc	plc_1
pcl_fnd	movi	player_check_table,a4
plc_1	mmfm	a4,a1,a2,a3		;a3 = lowerleft, a2 = upperright, a1 = address
	move	a3,a3
	jrz	plc_err			;we hit end of table, something is wrong
	subi	[1,1],a3		;sub 1 pixel over so we check like xge, yge
	cmpxy	a3,a14
	jryle	plc_1			;br= outside lower
	jrxle	plc_1			;br= outside left
	cmpxy	a2,a14
	jrygt	plc_1			;br= outside top
	jrxgt	plc_1			;br= outside right
	rets
plc_err	LOCKUP				;we hit end of table without match

**************************************************************************
*								         *
* player_check_table							 *
* 	table in format .long	bottom_left,upper_right,routine		 *
*								         *
**************************************************************************
player_check_table
	.long	[283,-734],[398,-684+8],p_lgoal_check
	.long	[283,684-8],[398,734],p_rgoal_check
goalie_check_table
	.long	[10,-798+radius],[669,798-radius],p_no_coll
	.long	[-500,-798+radius],[20,798-radius],p_bottom_wall
	.long	[639,-798+radius],[8000,798-radius],p_top_wall
	.long	[radius,-788],[679-radius,788],p_no_coll
	.long	[radius,-8000],[679-radius,-730],p_left_wall
	.long	[radius,730],[679-radius,8000],p_right_wall
	.long	[radius-(radius*7071/10000),-8000],[229,-798+radius-(radius*7071/10000)],p_corner_lll
	.long	[-8000,-798+radius-(radius*7071/10000)-20],[radius-(radius*7071/10000)+20,-570],p_corner_llr
	.long	[-8000,-8000],[radius,-798+radius],p_corner_ll
	.long	[450,-8000],[679-radius+(radius*7071/10000),-798+radius-(radius*7071/10000)],p_corner_ull
	.long	[679-radius+(radius*7071/10000)-20,-798+radius-(radius*7071/10000)-20],[8000,-570],p_corner_ulr
	.long	[679-radius,-8000],[8000,-798+radius],p_corner_ul
	.long	[radius-(radius*7071/10000),798-radius+(radius*7071/10000)],[229,8000],p_corner_lrr
	.long	[-8000,570],[radius-(radius*7071/10000)+20,798-radius+(radius*7071/10000)+20],p_corner_lrl
	.long	[-8000,798-radius],[radius,8000],p_corner_lr
	.long	[450,798-radius+(radius*7071/10000)],[679-radius+(radius*7071/10000),8000],p_corner_urr
	.long	[679-radius+(radius*7071/10000)-20,570],[8000,798-radius+(radius*7071/10000)+20],p_corner_url
	.long	[679-radius,798-radius],[8000,8000],p_corner_ur
	.long	[-1000,-1000],[1000,1000],p_no_coll
	.long	0,0,0                                   ;end of table

p_no_coll
	clr	a14
	move	a14,*a6(POF_PPMOD),W		;no point collision
	movb	a14,*a6(POF_CORNER_TEMP)        ;remove corner check
	move	a14,*a6(POF_LAST_BOARD_CVEL),L
	mmtm	sp,a0,a1
	move	a9,a0
	move	a11,a1
	calla	put_point_in_rink
	move	a0,a9
	move	a1,a11
	mmfm	sp,a0,a1
	rets
p_bottom_wall
	cmpi    [7,0],a11
	jrge	pbw1
	movi	[7,0],a11                               ;keep player in rink
pbw1	calla	down_check_sound
	callr	drone_wall_coll_90
	jruc	remove_down
p_top_wall
	cmpi    [671,0],a11
	jrle	ptw1
	movi	[671,0],a11                             ;keep player in rink
ptw1	calla	up_check_sound
	callr	drone_wall_coll_270
	jruc	remove_up

p_lgoal_check
	move    *a8(OFLAGS),a4,W
	btst	B_OFSCRN,a4
	jrnz	plg9
	callr	drone_wall_coll
	move	a9,a4
	move	a4,a1
	subi	[-734,0],a4
	subi	[-684+8,0],a1
	abs	a4
	abs	a1
	move	a11,a2
	move	a2,a3
	subi	[283,0],a2
	subi	[398,0],a3
	abs	a2
	abs	a3
	callr	mina03
	addi	plgc,a14
	move	*a14,a14,L
	jump	a14
plg9	rets
plgc	.long   pm736
	.long	pm694
	.long	p293
	.long	p388

p_rgoal_check
	move    *a8(OFLAGS),a4,W
	btst	B_OFSCRN,a4
	jrnz	prg9
	callr	drone_wall_coll
	move	a9,a4
	move	a4,a1
	subi	[734,0],a4
	subi	[684-8,0],a1
	abs	a4
	abs	a1
	move	a11,a2
	move	a2,a3
	subi	[283,0],a2
	subi	[398,0],a3
	abs	a2
	abs	a3
	callr	mina03
	addi	prgc,a14
	move	*a14,a14,L
	jump	a14
prg9	rets
prgc	.long   p736
	.long	p694
	.long	p293
	.long	p388
pm736	movi	[-734,0],a9
	jruc	remove_right
pm694	movi	[-684+8,0],a9
	jruc	remove_left
p293	movi	[283,0],a11
	jruc	remove_up
p388	movi	[398,0],a11
	jruc	remove_down
p736	movi	[734,0],a9
	jruc	remove_left
p694	movi	[684-8,0],a9
	jruc	remove_right

mina03	mmtm    sp,a4           ;return # corresponding minimum of a1-a4
	clr	a14
	cmp	a1,a4
	jrls	pkl1
	movk	1,a14
	move	a1,a4
pkl1	cmp	a2,a4
	jrls	pkl2
	movk	2,a14
	move	a1,a4
pkl2	cmp	a3,a4
	jrls	pkl3
	movk	3,a14
pkl3	sll	5,a14
	mmfm	sp,a4
	rets

p_left_wall
	cmpi    [-790,0],a9
	jrgt	plw1
	movi	[-790,0],a9                             ;keep player in rink
plw1	calla	left_check_sound
	callr	drone_wall_coll_0
	jruc	remove_left
p_right_wall
	cmpi    [790,0],a9
	jrle	prw1
	movi	[790,0],a9                              ;keep player in rink
prw1	calla	right_check_sound
	callr	drone_wall_coll_180
	jruc	remove_right
p_corner_lll
	movi    [-798+radius,0],a0
	movi	[radius,0],a1
	callr	p_corner_check
	jrnc	p_lll_1
	callr	drone_wall_coll_45
	calla	ll_check_sound
	callr	ra_lll
p_lll_1	cmpi	6,a0		;this check fixes a corner bounce problem for direction
	jrz	p_left_wall
	rets
p_corner_llr
	movi    [-798+radius,0],a0
	movi	[radius,0],a1
	callr	p_corner_check
	jrnc	p_llr_1
	callr	drone_wall_coll_45
	calla	ll_check_sound
	callr	ra_llr
p_llr_1	cmpi	6,a0		;this check fixes a corner bounce problem for direction
	jrz	p_bottom_wall
	rets
p_corner_ll	                        ;failsafe for corner
	movi	[-798+radius,0],a0
	movi	[radius,0],a1
	callr	p_corner_check
	jrnc	pll9
	calla	ll_check_sound
	callr	drone_wall_coll_45
	callr	remove_down
	jruc	remove_left
pll9	rets
p_corner_ull
	movi    [-798+radius,0],a0
	movi	[679-radius,0],a1
	callr	p_corner_check
	jrnc	p_ull_1
	callr	drone_wall_coll_315
	calla	ul_check_sound
	callr	ra_ull
p_ull_1	cmpi	8,a0		;this check fixes a corner bounce problem for direction
	jrz	p_left_wall
	rets
p_corner_ulr
	movi    [-798+radius,0],a0
	movi	[679-radius,0],a1
	callr	p_corner_check
	jrnc	pultr
	callr	drone_wall_coll_315
	calla	ul_check_sound
	callr	ra_ulr
pultr	rets
p_corner_ul	                        ;failsafe for corner
	movi	[-798+radius,0],a0
	movi	[679-radius,0],a1
	callr	p_corner_check
	jrnc	pul9
	calla	ul_check_sound
	callr	drone_wall_coll_315
	callr	remove_up
	jruc	remove_left
pul9	rets
p_corner_lrr
	movi    [798-radius,0],a0
	movi	[radius,0],a1
	callr	p_corner_check
	jrnc	pulty
	callr	drone_wall_coll_135
	calla	lr_check_sound
	callr	ra_lrr
pulty	rets
p_corner_lrl
	movi    [798-radius,0],a0
	movi	[radius,0],a1
	callr	p_corner_check
	jrnc	p_lrl_1
	callr	drone_wall_coll_135
	calla	lr_check_sound
	callr	ra_lrl
p_lrl_1	cmpi	4,a0		;this check fixes a corner bounce problem for direction
	jrz	p_bottom_wall
	rets
p_corner_lr	                        ;failsafe for corner
	movi	[798-radius,0],a0
	movi	[radius,0],a1
	callr	p_corner_check
	jrnc	plr9
	calla	lr_check_sound
	callr	drone_wall_coll_135
	callr	remove_down
	jruc	remove_right
plr9	rets
p_corner_urr
	movi    [798-radius,0],a0
	movi	[679-radius,0],a1
	callr	p_corner_check
	jrnc	pmf
	callr	drone_wall_coll_225
	calla	ur_check_sound
	callr	ra_urr
pmf	rets
p_corner_url
	movi    [798-radius,0],a0
	movi	[679-radius,0],a1
	callr	p_corner_check
	jrnc	pmf1
	callr	drone_wall_coll_225
	calla	ur_check_sound
	callr	ra_url
pmf1	rets
p_corner_ur	                        ;failsafe for corner
	movi	[798-radius,0],a0
	movi	[679-radius,0],a1
	callr	p_corner_check
	jrnc	pur9
	calla	ur_check_sound
	callr	drone_wall_coll_225
	callr	remove_up
	jruc	remove_right
pur9	rets
p_corner_check
	move    a0,a4
	move	a1,a5
	move	a9,a2
	move	a11,a3
	calla	find_dsquared_to_point_whole_a1
	cmpi	(radius-8)*(radius-8-5),a1
	jrls	pcc_nfd
	move	a5,a1
	calla	find_dir_to_point
	movi	[radius-8,0],a1
	move	a0,a2
	calla	polar_to_rect
	sub	a0,a4
	sub	a1,a5
	move	a4,a9
	move	a5,a11
	movb	*a6(POF_JOY),a0
	setc
	rets
pcc_nfd	movb	*a6(POF_JOY),a0
	clrc
	rets

remove_left
	sll     4,a0
	addi	remove_left_table,a0
	move	*a0,a0,W
	rets
remove_left_table
	.word   0
	.word	1
	.word	2
	.word	3
	.word	4
	.word	5
	.word	5
	.word	0
	.word	1

ra_ull	movb    *a6(POF_CORNER_TEMP),a14
	cmpi	3,a14
	jrnz	rull1
	movk	6,a14
	movb	a14,*a6(POF_I_JOY)
	cmp	a14,a0
	jrz	ra_zero
rull1	movk	4,a14
	movb	a14,*a6(POF_CORNER_TEMP)
	sll	4,a0
	addi	ra_ull_table,a0
	move	*a0,a0,W
	rets
ra_ull_table
	.word   0
	.word	1
	.word	2
	.word	3
	.word	4
	.word	5
	.word	5
	.word	8
	.word	8

ra_ulr	movb    *a6(POF_CORNER_TEMP),a14
	cmpi	4,a14
	jrnz	rulr1
	movk	6,a14
	movb	a14,*a6(POF_I_JOY)
	cmp	a14,a0
	jrz	ra_zero
rulr1	movk	3,a14
	movb	a14,*a6(POF_CORNER_TEMP)
	sll	4,a0
	addi	ra_ulr_table,a0
	move	*a0,a0,W
	rets
ra_ulr_table
	.word   0
	.word	1
	.word	2
	.word	3
	.word	4
	.word	4
	.word	7
	.word	7
	.word	8

ra_url	movb    *a6(POF_CORNER_TEMP),a14
	cmpi	1,a14
	jrnz	rurl1
	movk	4,a14
	movb	a14,*a6(POF_I_JOY)
	cmp	a14,a0
	jrz	ra_zero
rurl1	movk	2,a14
	movb	a14,*a6(POF_CORNER_TEMP)
	sll	4,a0
	addi	ra_url_table,a0
	move	*a0,a0,W
	rets
ra_url_table
	.word   0
	.word	1
	.word	2
	.word	3
	.word	3
	.word	6
	.word	6
	.word	7
	.word	8

ra_urr	movb    *a6(POF_CORNER_TEMP),a14
	cmpi	2,a14
	jrnz	rurr1
	movk	4,a14
	movb	a14,*a6(POF_I_JOY)
	cmp	a14,a0
	jrz	ra_zero
rurr1	movk	1,a14
	movb	a14,*a6(POF_CORNER_TEMP)
	sll	4,a0
	addi	ra_urr_table,a0
	move	*a0,a0,W
	rets
ra_urr_table
	.word   0
	.word	1
	.word	2
	.word	2
	.word	5
	.word	5
	.word	6
	.word	7
	.word	8

ra_lll	movb    *a6(POF_CORNER_TEMP),a14
	cmpi	6,a14
	jrnz	rlll1
	movk	8,a14
	movb	a14,*a6(POF_I_JOY)
	cmp	a14,a0
	jrz	ra_zero
rlll1	movk	5,a14
	movb	a14,*a6(POF_CORNER_TEMP)
	sll	4,a0
	addi	ra_lll_table,a0
	move	*a0,a0,W
	rets
ra_lll_table
	.word   0
	.word	1
	.word	2
	.word	3
	.word	4
	.word	5
	.word	6
	.word	6
	.word	1

ra_zero	clr     a0
	rets

ra_llr	movb    *a6(POF_CORNER_TEMP),a14
	cmpi	5,a14
	jrnz	rllr1
	movk	8,a14
	movb	a14,*a6(POF_I_JOY)
	cmp	a14,a0
	jrz	ra_zero
rllr1	movk	6,a14
	movb	a14,*a6(POF_CORNER_TEMP)
	sll	4,a0
	addi	ra_llr_table,a0
	move	*a0,a0,W
	rets
ra_llr_table
	.word   0
	.word	2
	.word	2
	.word	3
	.word	4
	.word	5
	.word	6
	.word	7
	.word	7

ra_lrl	movb    *a6(POF_CORNER_TEMP),a14
	cmpi	8,a14
	jrnz	rlrl1
	movk	2,a14
	movb	a14,*a6(POF_I_JOY)
	cmp	a14,a0
	jrz	ra_zero
rlrl1	movk	7,a14
	movb	a14,*a6(POF_CORNER_TEMP)
	sll	4,a0
	addi	ra_lrl_table,a0
	move	*a0,a0,W
	rets
ra_lrl_table
	.word   0
	.word	8
	.word	3
	.word	3
	.word	4
	.word	5
	.word	6
	.word	7
	.word	8

ra_lrr	movb    *a6(POF_CORNER_TEMP),a14
	cmpi	7,a14
	jrnz	rlrr1
	movk	2,a14
	movb	a14,*a6(POF_I_JOY)
	cmp	a14,a0
	jrz	ra_zero
rlrr1	movk	8,a14
	movb	a14,*a6(POF_CORNER_TEMP)
	sll	4,a0
	addi	ra_lrr_table,a0
	move	*a0,a0,W
	rets
ra_lrr_table
	.word   0
	.word	1
	.word	1
	.word	4
	.word	4
	.word	5
	.word	6
	.word	7
	.word	8

remove_right
	sll     4,a0
	addi	remove_right_table,a0
	move	*a0,a0,W
	rets
remove_right_table
	.word   0
	.word	1
	.word	1
	.word	0
	.word	5
	.word	5
	.word	6
	.word	7
	.word	8

remove_up
	sll     4,a0
	addi	remove_up_table,a0
	move	*a0,a0,W
	rets
remove_up_table
	.word   0
	.word	1
	.word	2
	.word	3
	.word	3
	.word	0
	.word	7
	.word	7
	.word	8

remove_down
	sll     4,a0
	addi	remove_down_table,a0
	move	*a0,a0,W
	rets
remove_down_table
	.word   0
	.word	0
	.word	3
	.word	3
	.word	4
	.word	5
	.word	6
	.word	7
	.word	7

drone_wall_coll_0
	mmtm	sp,a0
	clr	a0
	jruc	dwc_c
drone_wall_coll_45
	mmtm	sp,a0
	movi	45,a0
	jruc	dwc_c
drone_wall_coll_90
	mmtm	sp,a0
	movi	90,a0
	jruc	dwc_c
drone_wall_coll_135
	mmtm	sp,a0
	movi	135,a0
	jruc	dwc_c
drone_wall_coll_180
	mmtm	sp,a0
	movi	180,a0
	jruc	dwc_c
drone_wall_coll_225
	mmtm	sp,a0
	movi	225,a0
	jruc	dwc_c
drone_wall_coll_270
	mmtm	sp,a0
	movi	270,a0
	jruc	dwc_c
drone_wall_coll_315
	mmtm	sp,a0
	movi	315,a0
	jruc	dwc_c
drone_wall_coll
	mmtm	sp,a0
	clr	a0
	dec	a0
dwc_c	move	a0,*a6(POF_HIT_BOARDS_A),W
	movk	1,a0
	move	a0,*a6(POF_DRONEC),W
	move	a0,*a6(POF_HIT_BOARDS),W
	mmfm	sp,a0
	rets

one_timer_check
	mmtm	sp,a0,a10
	move	@PUCK_CONTROL,a14,W
	jrnz	otc_86
	move	@PUCK_MODE,a14,W
	cmpi	PUM_PASS,a14
	jrz	otc_2
	cmpi	PUM_TPASS,a14
	jrnz	otc_8
otc_2	move	@PUCK_INTENDED,a14,W
	movb	*a6(POF_NUMBER),a0
	cmp	a0,a14
	jrnz	otc_8
	move	*a6(POF_BUTTONS),a0,W
	btst	0,a0
	jrnz	otcgg
	move	*a6(POF_DRONE_BUTTONS),a0,W
	btst	0,a0
	jrz	otc_8
otcgg	move	*a6(POF_MODE),a0,W
	cmpi	PM_STAND,a0
	jrz	otc_ok
	cmpi	PM_SKID,a0
	jrz	otc_ok
	cmpi	PM_SKATE,a0
	jrnz	otc_8
otc_ok	callr	subpp1
	cmpi	17,a4
	jrhi	otc_8
	movi	set_onetime_script,a10
	cmpi	14,a4
	jrhi	otc_f
	movi	set_faster_onetime_script,a10
	cmpi	11,a4
	jrhi	otc_8
	cmpi	8,a4
	jrhi	otc_f
	movi	set_a_fastest_onetime_script,a10
	cmpi	4,a4
	jrhi	otc_f
	movi	set_fastest_onetime_script,a10
	cmpi	3,a4
	jrhi	otc_fns
	jruc	otc_8

otc_fns	callr	subpp3
	calla	zero_a8_y
	calla	spx_one_timer		;do tip in
	clr	a14			;skip all direction settings (not enough time)
	movb	a14,*a6(POF_BDIRECTION)
	call	a10			;set correct onetime script
	mmfm	sp,a0,a10
	rets

otc_f	callr	subpp3
	calla	spx_one_timer
	movb	*a6(POF_NUMBER),a0
	callr	get_quick_shot_point
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point_18
	movb	a0,*a6(POF_DIRECTION)
	clr	a14
	movb	a14,*a6(POF_BDIRECTION)
	call	a10			;set correct onetime script
otc_8	mmfm	sp,a0,a10
	rets

otc_86	movb	*a6(POF_NUMBER),a0
	cmp	a0,a14
	jrnz	otc_8
	move	*a6(POF_MODE),a0
	cmpi	PM_ONETIME,a0
	jrnz	otc_8
	callr	subpp1
	callr	subpp2
	mmfm	sp,a0,a10
	rets

line_up_for_pass
	callr	subpp1
	cmpi	5,a4
	jrgt	subpp2
	rets

subpp3	move	*a8(ODT_VEL),*a8(ODT_SAVEVEL),L
	move	*a8(ODT_DIR),*a8(ODT_SAVEDIR),L
	callr	subpp2
	calla	take_player_control
	movk	PM_ONETIME,a0
	move	a0,*a6(POF_MODE),W
	rets

subpp1	move	@PUCK_OBJECT,a9,L
	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
	move	*a9(ODT_XDEST),a2,L
	move	*a9(ODT_ZDEST),a3,L
	move	*a9(ODT_VEL),a7,L
	jauc	find_time_to_get_to_point_okb

subpp2	calla	get_players_puck_point_o
	move	a0,a14
	sub	a2,a14
	abs	a14
	cmpi	[1,0],a14
	jrhs	sbpt1
	move	a2,a0
sbpt1	sra	16,a0
	move	a1,a14
	sub	a3,a14
	abs	a14
	cmpi	[1,0],a14
	jrhs	sbpt2
	move	a3,a1
sbpt2	sra	16,a2
	movx	a2,a3
	move	a0,a2
	movy	a1,a2
	calla	SLINEVEL
	move	a1,a0
	move	a2,a1
	move	a0,a2
	move	a1,a3
	calla	rect_to_polar
	move	*a8(ODT_DIR),a5,L
	move	a5,a14
	sub	a0,a14
	THETA_H	a14
	abs	a14
	cmpi	XD0030,a14
	jrhi	sbge2
	move	a5,a0
sbge2	move	*a6(POF_PUP_FLAGS),a9,W
	btst	B_PUP_SPEED,a9
	jrz	nop4ps
	movi	pspeed_data_powered,a9
	jruc	ysp4ps			;power up speed
nop4ps	move	*a6(POF_S_SPED),a9,L
ysp4ps	move	*a9(PS_SP_TURBO_2),a4,L		;keep us going at less than our maximum speed
	addi	[3,0],a4			;boost our max a little
	cmp	a4,a1
	jrls	spp5e
	move	a4,a1
	jauc	set_obj_to_polar
spp5e	move	a0,*a8(ODT_DIR),L	;we already have all the data
	move	a1,*a8(ODT_VEL),L
	move	a2,*a8(OXVEL),L
	move	a2,*a8(ODT_REALXVEL),L
	move	a3,*a8(OZVEL),L
	jruc	drone_rink_check	;keep us in the rink

;gdebug_script
;	LWL	GAA13F02,AFUNC|1,adf_f
;	LWL	GSJ64F05,AFUNC|1,adf_f
;	.long	0
;
;
;	.bss	clb,16
;
;
;adf_f
;	move	*a8(ODT_PBK),a6,L
;	movb	*a6(POF_NUMBER),a0
;	cmpi	8,a0
;	jrnz	adf_f9
;	move	@clb,a14,W
;	jrz	adf_f8
;	clr	a14
;	move	a14,@clb,W
;adf_f9	rets
;adf_f8	move	*a8(ANIMFRM),a14,L
;	subi	050h,a14
;	move	a14,*a8(ANIMFRM),L
;	rets

	.end
