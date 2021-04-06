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
	.include	"TOPSCORE.TBL"
	.include	"hhmath.g"
	.include	"hhproc.g"
	.include	"hhplayer.g"
	.include	"hhpuck.g"
	.include	"hhgame.g"
	.include	"hhmisc.g"
	.include	"hhscript.g"
	.include	"hhcontrl.e"
	.include	"hhutil.g"
	.include	"hhram.g"
	.include	"hh.g"
	.include	"hhd.g"
	.include	"hhpall.g"
	.include	"hhselect.g"
	.include	"hhc.g"
	.include	"hhshow.g"
	.include	"hhdrone.g"

; end of include files

	.TEXT
	.EVEN

control_goalie
cg0	move	a10,a0
	calla	get_player_block
	move	*a6(POF_OBJECT),a8,L
	callr	move_goalie
	callr	face_goalie
	calla	do_drone_logic
;	callr	set_goalie_script
	calla	place_puck_with_player
	calla	fix_players_shadow
	callr	dec_ig_puck
	SLEEP	1
	jruc	cg0

move_goalie
;	MOVE	*A8(OZVEL),A1,L
;	JRZ	MG_START
;
;	MOVE	*A8(OZVAL),A2,L
;	CMPI	01200000H,A2
;	JRGT	MG_CHECK_TOP
;	MOVI	010000H,A14
;	MOVE	A14,*A8(OZVEL),L
;	RETS
;MG_CHECK_TOP
;	CMPI	01800000H,A2
;	JRLT	MG_DONE
;MG_START
;	MOVI	-010000H,A14
;	MOVE	A14,*A8(OZVEL),L
;MG_DONE

	CLR	A1
	MOVE	*A8(OZVAL),A4,L
	MOVE	@PUCK_OBJECT,A7,L
	MOVE	*A7(OZVAL),A5,L
	SUB	A4,A5
	JRZ	MG_SAVE_ZVEL
	JRNN	MG_CHECK_TOP
	MOVI	011F0001H,A14		;[287,0] + 1
	CMP	A14,A4
	JRLE	MG_ADJUST		;BR=OUTSIDE OF GOAL
	JRUC	MG_GO
MG_CHECK_TOP
	MOVI	018DFFFFH,A14		;[387,0] - 1
	CMP	A14,A4
	JRGE	MG_ADJUST		;BR=OUTSIDE OF GOAL
MG_GO
	MOVI	040000H,A14
	MOVE	A5,A1
	ABS	A5
	CMP	A14,A5
	JRLE	MG_SAVE_ZVEL
	MOVE	A1,A1
	JRNN	MG_MAX_ZVEL
	NEG	A14
MG_MAX_ZVEL
	MOVE	A14,A1
MG_SAVE_ZVEL
	MOVE	A1,*A8(OZVEL),L

	RETS
MG_ADJUST
	MOVE	A14,*A8(OZVAL),L
	MOVE	A1,*A8(OZVEL),L
	RETS

face_goalie
	movk	3,a0
	move	*a8(OXPOS),a1,W
	jrn	fgh1
	movk	7,a0
fgh1	movb	a0,*a6(POF_DIRECTION)
	rets
set_goalie_script
	move	*a6(POF_MODE),a0,W
	sll	5,a0
	addi	spgll-100*32,a0
	move	*a0,a0,L
	jump	a0
spgll	.long	set_gstand_script

control_player	;a10 = player number
cp0	move	a10,a0
	calla	get_player_block
	calla	get_offense_mode
	cmpi	1,a1
	jrz	cpdf
	clr	a14		;speed boost
	clr	a2		;skid boost
	move	@PUCK_CONTROL,a1,W
	cmp	a1,a0
	jrnz	cpnd
	move	*a6(POF_S_SPED),a14,L
	move	*a14(PS_SP_CONTROL_PENALTY),a14,L
	neg	a14
	jruc	cpnd
cpdf	move	*a6(POF_S_STOP),a2,L
	movb	*a2(PS_ST_DEFENSE_SKID),a2
	move	*a6(POF_S_SPED),a14,L
	move	*a14(PS_SP_DEFENSE_BOOST),a14,L
cpnd	movb	a2,*a6(POF_SKID_BOOST)
	move	a14,*a6(POF_SPEED_BOOST),L
	move	*a6(POF_OBJECT),a8,L
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HIGHER,a14
	jrnz	control_player_higher	;must have flags in a14
	btst	B_PF_HUMAN,a14
	jrz	control_player_drone
	callr	delete_cpuarrow_if
	callr	read_joystick
	callr	update_turbo
	callr	update_arrow
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	control_player_nc			;br=no control
	move	@GAME_STATE,a14,W
	cmpi	INPLAY,a14			;if period is over, no control
	jrnz	control_player_ncnt
	callr	move_player
	callr	face_player
	callr	set_player_script
	calla	place_puck_with_player
	calla	fix_players_shadow
	calla	fix_players_arrow
	callr	dec_ig_puck
	SLEEP	1
	jruc	cp0

delete_cpuarrow_if
	move	*a6(POF_ARROW_CPU),a7,L
	jrz	nocpu3
	movi	3000,a0
	move	a0,*a7(OXPOS),W		;put it off the screen
	move	*a7(OCTRL),a0,W
	ori	DMAGO,a0		;turn it on
	move	a0,*a7(OCTRL),W
	PUSH	a8
	move	a7,a8
	calla	DELETE_OBJ		;kill it
	PULLQ	a8
	clr	a0
	move	a0,*a6(POF_ARROW_CPU),L	;don't do it again
nocpu3	rets

control_player_ncnt
	callr	update_turbo_up
	clr	a0
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OZVEL),L
	move	a0,*a8(ODT_VEL),L
	calla	set_stand_script
	;fall through
control_player_nc			;it is a human player, but a script has control
	clr	a14
	movb	a14,*a6(POF_STAND_STILL)
	calla	place_puck_with_player
	calla	fix_players_shadow
	calla	fix_players_arrow
	callr	dec_ig_puck
	SLEEP	1
	jruc	cp0

control_player_drone
	callr	update_arrow
	callr	update_turbo_drone
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	cpd_nc
	calla	do_drone_logic
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	cpd_nc
	callr	set_player_script
	jruc	cpd_1
cpd_nc	clr	a14
	movb	a14,*a6(POF_STAND_STILL)
cpd_1	calla	place_puck_with_player
	calla	fix_players_shadow
	calla	fix_players_arrow
	callr	dec_ig_puck
	SLEEP	1
	jruc	cp0

control_player_higher
	btst	B_PF_HUMAN,a14
	jrnz	cph_1
	callr	update_turbo_drone
	jruc	cph_2
cph_1	callr	update_turbo_up
	callr	delete_cpuarrow_if
cph_2	callr	update_arrow
	calla	place_puck_with_player
	calla	fix_players_shadow
	calla	fix_players_arrow
	callr	dec_ig_puck
	SLEEP	1
	jruc	cp0

dec_ig_puck
	movb	*a6(POF_IGNORE_PUCK),a14
	jrz	dip_9
	dec	a14
	movb	a14,*a6(POF_IGNORE_PUCK)
dip_9	rets

move_player
	move	*a6(POF_OBJECT),a8,L	;object in a8
	movb	*a6(POF_M_JOY),a0
	jrnz	mp1				;if we are not centered, do our conversion
	dec	a0				;else a0 is -1
	jruc	mp2
mp1	calla	dir_to_radians		;direction to move in a0
mp2	move	*a6(POF_BUTTONS),a1
	andni	2,a1			;a1 = 0 if no turbo, non zero if turbo
move_player_dir
	move	*a6(POF_S_CORN),a7,L
	move	a0,*a8(ODT_GDIR),L
	move	a1,*a8(ODT_TURBO),W
	move	a0,a0
	jrn	stop_player
	move	*a8(ODT_VEL),a0,L
	move	*a6(POF_S_STOP),a1,L
	move	*a1(PS_ST_RSTOP_THRESH),a1,L
	cmp	a1,a0
	jrls	move_player_exactly
	move	*a8(ODT_DIR),a1,L
	move	*a8(ODT_GDIR),a0,L
	sub	a1,a0
	THETA_H	a0
	move	a0,a2
	jrz	move_player_exactly
	abs	a0
	move	*a7(PS_CR_SKID),a1,L
	cmp	a1,a0
	jrhi	skid_to_reverse_player

	mmtm	sp,a0,a1,a2,a3,a4
	move	*a7(PS_CR_TURN_TABLE_D),a9,L
	movb	*a6(POF_NUMBER),a0
	calla	get_offense_mode
	cmpi	1,a1
	jrz	tt_d
	move	*a7(PS_CR_TURN_TABLE),a9,L
	move	a1,a1
	jrz	tt_d
	move	*a8(OXPOS),a0,W		;get use
	move	*a8(OZPOS),a1,W
	move	@PUCK_OBJECT,a14,L
	move	*a14(OXPOS),a2,W		;get puck
	move	*a14(OZPOS),a3,W
	calla	find_dist_quick
	cmpi	100,a4
	jrhi	tt_d
	move	*a7(PS_CR_TURN_TABLE_C),a9,L
tt_d	mmfm	sp,a0,a1,a2,a3,a4

	move	a2,a2			;here a2 is the angular difference between where we are and where we want to be
	jrn	mp_neg
*************************************************
*						*
* 	for moving in positive direction	*
* 		if g < 90			*
* 		  theta_n a			*
* 		  if a > 180			*
* 		    false			*
* 		  if a > g			*
* 		    true			*
* 		   else				*
* 		    false			*
* 		if g < 180			*
* 		  theta_n a			*
* 		  if a > 270			*
* 		    false			*
* 		  if a > g			*
* 		    true			*
* 		   else				*
* 		    false			*
* 		else				*
* 		  if a > g			*
* 		    theta_n a			*
* 		    true			*
* 		  else				*
* 		    theta_n a			*
* 		    false			*
*						*
*************************************************
mpp1	move	*a9,a0,L
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
*************************************************
*						*
* 	for moving in negative direction	*
* 		if g < 90			*
* 		  theta_n a			*
* 		  if a > 270			*
* 		    true			*
* 		  if a < g			*
* 		    true			*
* 		   else				*
* 		    false			*
* 		if g > 180			*
* 		  theta_n a			*
* 		  if a < 90			*
* 		    true			*
* 		  if a < g			*
* 		    true			*
* 		   else				*
* 		    false			*
* 		else				*
* 		  if a < g			*
* 		    theta_n a			*
* 		    true			*
* 		  else				*
* 		    theta_n a			*
* 		    false			*
*						*
*************************************************
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

	move	*a6(POF_S_SPED),a7,L
	clr	a14
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
	calla	move_to_speed_x			;1 away move to
	move	*a8(ODT_DIR),a0,L
	jauc	set_obj_to_polar

skid_to_reverse_player
	move	*a6(POF_S_STOP),a7,L
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_OKDIR,a14
	move	a14,*a6(POF_FLAGS),W
	clr	a14
	movb	a14,*a6(POF_STAND_STILL)
	move	*a6(POF_MODE),a0,W
	jrz	rsk1
	cmpi	4,a0
	jrz	rsksh
	calla	slide_to_reverse_sound
rsk1	movk	4,a0
	move	a0,*a6(POF_MODE),W
rsksh	move	*a8(ODT_VEL),a1,L
	clr	a2
	movb	*a7(PS_ST_SKID_R_MT),a3
	move	*a8(ODT_TURBO),a14,W
	jrz	cpsake
	movb	*a7(PS_ST_TSKID_R_MT),a3
cpsake	movb	*a6(POF_SKID_BOOST),a14
	add	a14,a3
	calla	move_to_speed_x		;skid to a stop -reverse move to
	move	*a8(ODT_DIR),a0,L
	jauc	set_obj_to_polar

stop_player
	move	*a6(POF_S_STOP),a7,L
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_OKDIR,a14
	move	a14,*a6(POF_FLAGS),W
	move	*a8(ODT_VEL),a0,L
	jrz	mph_stopped
	clr	a14
	movb	a14,*a6(POF_STAND_STILL)
	move	*a6(POF_MODE),a0,W
	jrz	ask1
	cmpi	4,a0
	jrz	asksh
	calla	slide_to_stop_sound
ask1	movk	4,a0
	move	a0,*a6(POF_MODE),W
asksh	move	*a8(ODT_VEL),a1,L
	clr	a2
	movb	*a7(PS_ST_SKID_S_MT),a3
	move	*a8(ODT_TURBO),a14,W
	jrz	cpsate
	movb	*a7(PS_ST_TSKID_S_MT),a3
cpsate	movb	*a6(POF_SKID_BOOST),a14
	add	a14,a3
	calla	move_to_speed_x			;skid to a stop move to
	move	*a8(ODT_DIR),a0,L
	move	*a7(PS_ST_STOP_THRESH),a14,L
	cmp	a14,a1
	jrls	mph_stopped
	jauc	set_obj_to_polar

mph_stopped
	move	*a8(ODT_DIR),a0,L
	clr	a1			;mode is standing
	move	a1,*a6(POF_MODE),W
	jauc	set_obj_to_polar

face_player
	move	*a6(POF_MODE),a0,W
	jrz	face_standing		;br=standing
	cmpi	4,a0
	jrz	face_travel		;br=skidding, face direction of travel
	movb	*a6(POF_NUMBER),a0
	move	@PUCK_CONTROL,a1,W
	jrnz	fpic
	move	@PUCK_LAST_CONTROL,a1,W
	jrz	fp_none			;br= nobody has puck
fpic	cmp	a0,a1
	jrz	face_travel		;br= we have puck
	calla	get_offense_mode
	cmpi	1,a1
	jrz	face_to_puck
	jruc	face_travel		;br= we are offense, face travel
fp_none	jruc	face_travel

face_standing
	move	@PUCK_CONTROL,a1,W
	movb	*a6(POF_NUMBER),a0
	cmp	a0,a1
	jrz	fsta9		;we have puck, do no change in face
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
	callr	rotate_toward_puck
fsta9	rets

rotate_toward_puck
	move	@PUCK_CONTROL,a0,W
	jrz	rtpka
	PUSH	a6
	calla	get_player_block
	move	*a6(POF_OBJECT),a9,L
	PULLQ	a6
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
face_to_puck			;face the puck
	move	@PUCK_OBJECT,a9,L
	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
face_to_point			;face a point
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point_18
	move	a0,a14
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
	mmtm	sp,a0,a6
	move	a9,a0
	calla	get_player_block
	move	*a6(POF_OBJECT),a9,L
	mmfm	sp,a0,a6
	jruc	fpk1
face_puck
	move	@PUCK_OBJECT,a9,L
fpk1	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
face_point			;face a point
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point_18
	movb	a0,*a6(POF_DIRECTION)
	rets
face_puck_player_24
	move	@PUCK_CONTROL,a9,W
	jrz	face_puck_24
	mmtm	sp,a0,a6
	move	a9,a0
	calla	get_player_block
	move	*a6(POF_OBJECT),a9,L
	mmfm	sp,a0,a6
	jruc	fp241
face_puck_24
	move	@PUCK_OBJECT,a9,L
fp241	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
face_point_24
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	clr	a14
	sub	a0,a2
	jrn	fp1
	inc	a14
fp1	sub	a1,a3
	jrn	fp2
	addk	2,a14
fp2	sll	4,a14
	addi	fptab24,a14
	move	*a14,a14,W
	movb	a14,*a6(POF_DIRECTION)
	rets
fptab24	.word	2,8,4,6

set_player_script		;sets script based on our mode
	move	*a6(POF_MODE),a0,W
	sll	5,a0
	addi	spsll,a0
	move	*a0,a0,L
	jump	a0
no_spsc	rets
spsll	.long	set_stand_script
	.long	set_run_script
	.long	set_run_script
	.long	set_run_script
	.long	set_skid_script
	.long	set_steal_script
	.long	set_push_script
	.long	set_fall_script

pass_puck_sw
 	calla	check_for_player
	jrnc	pp_9
	move	@GAME_STATE,a14,W
	cmpi	INPLAY,a14
	jrnz	pp_9
	calla	get_player_block
	move	*a6(POF_MODE),a14,W	;if shooting, ok
	cmpi	3,a14			;if shooting, ok
	jrnz	ppkw
	move	*a6(POF_FLAGS),a14,W
	andi	M_PF_HIGHER|M_PF_HIGHER_W,a14
	jrnz	pp_9
	jruc	ppka
ppkw	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	pp_9
	andi	M_PF_HIGHER|M_PF_HIGHER_W,a14
	jrnz	pp_9
ppka	move	@WAVEIRQS,a1,L
	move	*a6(POF_SHOT_START),a14,L
	sub	a1,a14
	abs	a14
	cmpi	2,a14
	jrls	pass_and_shoot		;do pass and shoot same time
	move	a1,*a6(POF_PASS_START),L
	move	a0,a8
	movb	*a6(POF_NUMBER),a0
	sll	8,a0
	addi	PIDOF_PASS,a0
	move	a0,*a13(PROCID),W	;set our id
	SLEEP	3			;we delay here now, so we can double hit
	move	a8,a0
	sll	8,a0
	addi	PIDOF_PASS_SHOOT,a0
	calla	EXISTP_ALL
	jrnz	pp_9
	move	a8,a0
	calla	get_player_block
pass_puck
	move	*a6(POF_OBJECT),a8,L
	move	@PUCK_CONTROL,a1,W
	cmp	a0,a1
	jrnz	pp_np
	movi	pass_ok_mlist,a3
	calla	check_mode_ok
	jrnc	pp_9
	move	*a6(POF_MODE),a3,W
	cmpi	3,a3
	jrnz	ppe
	move	*a6(POF_SHOT_PASS),a14,L
	jump	a14
ppe	calla	turn_on_players_arrow
	calla	get_pass_receiver
	calla	turn_on_receivers_arrow
	move	a0,@PUCK_INTENDED,W
	move	@PUCK_CONTROL,@PUCK_LAST_CONTROL,W
	clr	a1
	move	a1,@PUCK_CONTROL,W
	move	*a6(POF_TURBO_MODE),a14,W
	jrz	ppnt
	callr	pp_turbo
	jruc	pp_9
ppnt	callr	pp_no_turbo
pp_9	jauc	SUCIDE
pp_turbo
	move	*a6(POF_S_PASS),a9,L
	movk	11,a1
	move	a1,@PUCK_MODE,W
	move	*a9(PS_PS_PASS_TURBO),a7,L
	move	*a9(PS_PS_TPASS_CHANGE),a14,L
	move	a14,b6
	move	*a6(POF_S_SHOT),a10,L
	move	*a10(PS_SH_MAX_YVEL),a10,L
	calla	send_puck_to_player
	move	*a9(PS_PS_TPASS_GTHRESH),a0,W
	cmp	a0,a10
	jrlo	pptb9				;not in air
	move	*a9(PS_PS_TPASS_MTHRESH),a0,W
	cmp	a0,a10
	jrhs	pptair
	movk	2,a0
	calla	RAND0
	jrz	pptb9				;not in air (50%)
pptair	movi	[-3,0],a0
	move	@PUCK_OBJECT,a8,L
	move	a0,*a8(OYVEL),L
	calla	give_puck_gravity
pptb9	jauc	slap_shot_sound

pp_no_turbo
	move	*a6(POF_S_PASS),a9,L
	movk	10,a1
	move	a1,@PUCK_MODE,W
	move	*a9(PS_PS_PASS_SPEED),a7,L
	move	*a9(PS_PS_PASS_CHANGE),a14,L
	move	a14,b6
	move	*a6(POF_S_SHOT),a10,L
	move	*a10(PS_SH_MAX_YVEL),a10,L
	calla	send_puck_to_player
	move	*a9(PS_PS_PASS_GTHRESH),a0,W
	cmp	a0,a10
	jrlo	ppnb9				;not in air
	move	*a9(PS_PS_PASS_MTHRESH),a0,W
	cmp	a0,a10
	jrhs	ppnair
	movk	2,a0
	calla	RAND0
	jrz	ppnb9				;not in air (50%)
ppnair	movi	[-3,0],a0
	move	@PUCK_OBJECT,a8,L
	move	a0,*a8(OYVEL),L
	calla	give_puck_gravity
ppnb9	jauc	wrist_shot_sound

;;;	a0 = player, a1 = puck control, a8 = player object, a6 = block
pp_np
pp_swat	move	*a6(POF_TURBO_MODE),a14,W	;pass without puck
	jrnz	pp_tnp
	dec	a1
	jrn	pp_s2
	dec	a0
	srl	2,a1
	srl	2,a0
	cmp	a0,a1
	jrnz	pp_s2
	callr	signal_to_pass
	jruc	ppx9
pp_s2	move	*a6(POF_OBJECT),a8,L
	move	*a6(POF_FLAGS),a0,W
	andni	M_PF_CONTROL,a0
	move	a0,*a6(POF_FLAGS),W
	movk	5,a0
	move	a0,*a6(POF_MODE),W
	move	*a8(ODT_VEL),a0,L
	sra	1,a0
	move	a0,*a8(ODT_VEL),L	;velocity
	move	*a8(OXVEL),a0,L
	sra	1,a0
	move	a0,*a8(OXVEL),L
	move	*a8(OZVEL),a0,L
	sra	1,a0
	move	a0,*a8(OZVEL),L
	calla	set_player_script
ppx9	jauc	SUCIDE

pp_tnp
pp_push	move	*a6(POF_OBJECT),a8,L
	move	*a6(POF_FLAGS),a0,W
	andni	M_PF_CONTROL,a0
	move	a0,*a6(POF_FLAGS),W
	movk	6,a0
	move	a0,*a6(POF_MODE),W
	movb	*a6(POF_M_JOY),a0
	jrz	pppg1
	movb	a0,*a6(POF_DIRECTION)
pppg1	move	*a8(ODT_VEL),a0,L
	sra	1,a0
	move	a0,*a8(ODT_VEL),L	;velocity
;	move	*a8(OXVEL),a0,L
;	sra	1,a0
;	move	a0,*a8(OXVEL),L
;	move	*a8(OZVEL),a0,L
;	sra	1,a0
;	move	a0,*a8(OZVEL),L
	calla	set_player_script
pptx9	jauc	SUCIDE

pass_ok_mlist
	.word	0,1,3,4,-1

shoot_puck_sw
	calla	check_for_player
	jrnc	sp_9			;if not playing game, exit
	move	@GAME_STATE,a14,W
	cmpi	INPLAY,a14
	jrnz	sp_9
	calla	get_player_block
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrz	sp_9
	andi	M_PF_HIGHER|M_PF_HIGHER_W,a14
	jrnz	sp_9
	move	@WAVEIRQS,a1,L
	move	*a6(POF_PASS_START),a14,L
	sub	a1,a14
	abs	a14
	cmpi	2,a14
	jrls	pass_and_shoot		;do pass and shoot same time
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
	jrz	spnt
	callr	sp_turbo
      	jruc	sp_9
spnt	callr	sp_no_turbo
sp_9	jauc	SUCIDE
sp_shnp	move	*a6(POF_TURBO_MODE),a14,W
	jrnz	sp_sh9
	callr	signal_to_shoot
sp_sh9	jauc	SUCIDE
sp_turbo
	callr	take_player_control
	callr	stuff_shot_start_time
	calla	set_turbo_shoot_script
	callr	stuff_turbo_shoot_address
	callr	start_turbo_shoot_watch
	jruc	set_shoot_mode
sp_no_turbo
	callr	take_player_control
	callr	stuff_shot_start_time
	calla	set_shoot_script
	callr	stuff_shoot_address
	callr	start_shoot_watch
	jruc	set_shoot_mode
stuff_shot_start_time
	move	@WAVEIRQS,a14,L
	move	a14,*a6(POF_SHOT_START),L
	rets

shoot_release
	move	@WAVEIRQS,a1,L
	move	*a6(POF_SHOT_FAKE),a14,L
	sub	a1,a14
	neg	a14
	cmpi	30,a14
	jrls	srd
	move	*a6(POF_SHOT_START),a14,L
	sub	a14,a1
	cmpi	5,a1
	jrls	sre
srd	callr	shoot_script_done
	jauc	SUCIDE
sre	move	a14,*a6(POF_SHOT_FAKE),L
	callr	do_end_of_shoot_stuff
	jauc	SUCIDE

shoot_script_done
	callr	do_end_of_shoot_stuff
	clr	a1
	move	a1,@PUCK_INTENDED,W
	move	@PUCK_CONTROL,@PUCK_LAST_CONTROL,W
	move	a1,@PUCK_CONTROL,W
	movi	40,a1			;after 2/3 second,
	move	a1,@PUCK_OPEN_CONTROL_TIME,W	;let us pick it up again
	move	a1,@PUCK_OPEN_LAST_TIME,W	;let us pick it up again
	move	*a6(POF_SHOOT_CURRENT),a7,L
	callr	get_shot_point_nt
	move	*a6(POF_S_SHOT),a14,L
	move	*a14(PS_SH_SHOT_CHANGE),a14,L
	move	a14,b6
	move	*a6(POF_S_SHOT),a10,L
	move	*a10(PS_SH_MAX_YVEL),a10,L
	calla	wrist_shot_sound
	jauc	send_puck_to_point_xyz

do_end_of_shoot_stuff
	movb	*a6(POF_NUMBER),a0
	sll	8,a0
	addi	PIDOF_WATCH_SHOOT,a0
	calla	KILLPROC_ALL				;kill switch watch process
	callr	give_player_control
	clr	a0
	move	a0,*a6(POF_MODE),W
	rets

turbo_shoot_release
	move	@WAVEIRQS,a1,L
	move	*a6(POF_SHOT_FAKE),a14,L
	sub	a1,a14
	neg	a14
	cmpi	30,a14
	jrls	tsrd
	move	*a6(POF_SHOT_START),a14,L
	sub	a14,a1
	cmpi	5,a1
	jrls	tsre
tsrd	callr	turbo_shoot_script_done
	jauc	SUCIDE
tsre	move	a14,*a6(POF_SHOT_FAKE),L
	callr	do_end_of_shoot_stuff
	jauc	SUCIDE

turbo_shoot_script_done
	callr	do_end_of_shoot_stuff
	clr	a1
	move	a1,@PUCK_INTENDED,W
	move	@PUCK_CONTROL,@PUCK_LAST_CONTROL,W
	move	a1,@PUCK_CONTROL
	movi	40,a1			;after 2/3 second,
	move	a1,@PUCK_OPEN_CONTROL_TIME,W	;let us pick it up again
	move	a1,@PUCK_OPEN_LAST_TIME,W	;let us pick it up again
	move	*a6(POF_SHOOT_CURRENT),a7,L
	callr	get_shot_point_t
	move	*a6(POF_S_SHOT),a14,L
	move	*a14(PS_SH_TSHOT_CHANGE),a14,L
	move	a14,b6
	move	*a6(POF_S_SHOT),a10,L
	move	*a10(PS_SH_MAX_YVEL),a10,L
	calla	slap_shot_sound
	jauc	send_puck_to_point_xyz

sp_ot	movk	14,a1			;one timer
	move	a1,@PUCK_MODE,W
	clr	a1
	move	a1,@PUCK_INTENDED,W
	move	@PUCK_CONTROL,@PUCK_LAST_CONTROL,W
	move	a1,@PUCK_CONTROL,W
	movi	40,a1			;1/2 second after we were supposed to catch it
	move	a1,@PUCK_OPEN_CONTROL_TIME,W	;let us pick it up again
	move	a1,@PUCK_OPEN_LAST_TIME,W	;let us pick it up again
	move	*a6(POF_S_SHOT),a7,L
	move	*a7(PS_SH_SHOOT_SPEED),a7,L
	move	*a6(POF_TURBO_MODE),a14,W
	jrz	sptc
	move	*a6(POF_S_SHOT),a7,L
	move	*a7(PS_SH_SHOOT_TURBO),a7,L
sptc	callr	get_shot_point_ot
	move	*a6(POF_S_SHOT),a14,L
	move	*a14(PS_SH_SHOT_CHANGE),a14,L
	move	a14,b6
	move	*a6(POF_S_SHOT),a10,L
	move	*a10(PS_SH_MAX_YVEL),a10,L
	calla	send_puck_to_point_xyz
	jauc	SUCIDE

stuff_turbo_shoot_address
	movi	turbo_shoot_release,a14
	move	a14,*a6(POF_SHOT_RELEASE),L
	movi	pass_from_shoot,a14
	move	a14,*a6(POF_SHOT_PASS),L
	rets
stuff_shoot_address
	movi	shoot_release,a14
	move	a14,*a6(POF_SHOT_RELEASE),L
	movi	pass_from_shoot,a14
	move	a14,*a6(POF_SHOT_PASS),L
	rets

pass_from_shoot
	callr	do_end_of_shoot_stuff
	movb	*a6(POF_NUMBER),a0
	jruc	pass_puck

set_shoot_mode
	movk	3,a14
	move	a14,*a6(POF_MODE),W
	rets

start_turbo_shoot_watch
	move	*a6(POF_S_SHOT),a9,L
	move	*a9(PS_SH_SHOOT0_TURBO),a1,L
	move	*a9(PS_SH_SHOOT_TURBO),a10,L
	movb	*a9(PS_SH_SHOOTT_MT),a9
	jruc	ssw_5
start_shoot_watch
	move	*a6(POF_S_SHOT),a9,L
	move	*a9(PS_SH_SHOOT0_SPEED),a1,L
	move	*a9(PS_SH_SHOOT_SPEED),a10,L
	movb	*a9(PS_SH_SHOOT_MT),a9
ssw_5	move	a1,*a6(POF_SHOOT_CURRENT),L
	movb	*a6(POF_NUMBER),a1
	sll	8,a1
	addi	PIDOF_WATCH_SHOOT,a1
	movi	ssw_1,a7
	move	a6,a11
	jauc	KILL_AND_GETPPRC

ssw_0	SLEEP	1
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

shoot_ok_mlist
	.word	0,1,4,-1

pass_and_shoot
	move	*a6(POF_S_DUMP),a9,L
	callr	do_end_of_shoot_stuff
	movb	*a6(POF_NUMBER),a0
	move	@PUCK_CONTROL,a14,W
	cmp	a0,a14
	jrnz	pas_np
	sll	8,a0
	addi	PIDOF_PASS_SHOOT,a0
	move	a0,*a13(PROCID),W
	addi	PIDOF_PASS-PIDOF_PASS_SHOOT,a0
	calla	KILLPROC_ALL
	move	a6,a8
	SLEEP	1
	move	a8,a6
	clr	a0
	move	@PUCK_CONTROL,@PUCK_LAST_CONTROL,W
	move	a0,@PUCK_CONTROL,W
	movb	*a6(POF_M_JOY),a0
	jrnz	inacar
	movb	*a6(POF_DIRECTION),a0
inacar	calla	dir_to_radians
	move	*a9(PS_DP_DUMP_SPEED),a1,L
	move	*a9(PS_DP_DUMP_CHANGE),a2,L
	movi	[-3,08000],a3				;-2.5
	move	*a6(POF_TURBO_MODE),a14,W
	jrz	pas_1
	move	*a9(PS_DP_DUMP_TURBO),a1,L
	move	*a9(PS_DP_TDUMP_CHANGE),a2,L
	movi	[-3,0],a3
	calla	slap_shot_sound
	jruc	pas_11
pas_1	calla	wrist_shot_sound
pas_11	move	@PUCK_OBJECT,a8,L
	move	a3,*a8(OYVEL),L
	call	a2
	calla	set_obj_to_polar
	calla	give_puck_gravity
	movi	30,a0
	move	a0,@PUCK_OPEN_CONTROL_TIME,W
	move	a0,@PUCK_OPEN_LAST_TIME,W
	movk	8,a0
	move	a0,*a6(POF_MODE),W
	movk	15,a0
	move	a0,@PUCK_MODE,W
pas_np	jauc	SUCIDE

give_player_control
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_CONTROL,a14
	move	a14,*a6(POF_FLAGS),W
	rets
take_player_control
	move	*a6(POF_FLAGS),a14,W
	andni	M_PF_CONTROL,a14
	move	a14,*a6(POF_FLAGS),W
	rets

**************************************************************************
*								         *
* get_shot_point							 *
* 	input	a0 = player						 *
* 	output	a0 = x							 *
* 		a1 = z							 *
* 		a2 = y							 *
*								         *
**************************************************************************
get_shot_point_nt	;non turbo shot
get_shot_point_t	;turbo shot
get_shot_point_ot	;one timer shot
	move	*a6(POF_FLAGS),a0,W
;	btst	B_PF_HUMAN,a0
;	jrz	gsp_drone
	movb	*a6(POF_NUMBER),a0
	sll	5,a0
	addi	spxl-32,a0
	move	*a0,a0,L
	movb	*a6(POF_JOY),a14
	sll	7,a14
	add	a0,a14
	move	*a14+,a0,L
	move	*a14+,a1,L
	move	*a14,a2,L
	rets
gsp_drone
	clr	a0
	clr	a1
	clr	a2
	rets

spxl	.long	team_1_postab
	.long	team_1_postab
	.long	team_1_postab
	.long	team_1_postab
	.long	team_2_postab
	.long	team_2_postab
	.long	team_2_postab
	.long	team_2_postab

lowy	.equ	0
midy	.equ	[0,0]
highy	.equ	[-40,0]
lowz	.equ	[329,0]
midz	.equ	[339,08000h]
highz	.equ	[350,0]
x_team1	.equ	[688,0]
x_team2	.equ	[-688,0]

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
	movi	XD0060,a14		;+/- 5 degrees
	move	a2,a2
	jrnz	acsp_1
	movi	XD0030,a14
acsp_1	sub	a14,a0
	add	a14,a1
	calla	RANGERND
	move	a0,a0
	jrnn	acp1
	addi	XD3600,a0
acp1	move	b6,a1
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
	move	a0,a0
	jrnn	cp1
	addi	XD3600,a0
cp1	move	b6,a1
	rets

change_tshot
change_dump
	callr	are_we_edging
	jrc	change_edge
	move	a1,b6		;we can trash this
	move	a0,a1
	movi	XD0080,a14		;+/- 5 degrees
	move	a2,a2
	jrnz	cttd_1
	movi	XD0040,a14
cttd_1	sub	a14,a0
	add	a14,a1
	calla	RANGERND
	move	a0,a0
	jrnn	tcp1
	addi	XD3600,a0
tcp1	move	b6,a1
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
	move	a0,a0
	jrnn	tdp1
	addi	XD3600,a0
tdp1	move	b6,a1
	rets

change_edge
	move	a1,b6		;we can trash this
	move	a0,a1
	movi	XD0030,a14		;+/- 5 degrees
	sub	a14,a0
	add	a14,a1
	calla	RANGERND
	move	a0,a0
	jrnn	edp1
	addi	XD3600,a0
edp1	move	b6,a1
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
awe_npo	move	*a8(OXPOS),a14,L
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

off_control
def_control
	cmpi	50,a4
	jrhs	ctrl_0
	move	@PUCK_MODE,a14,W
	cmpi	1,a14			;face off?
	jrz	ctrl_3			;then we always control
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
	cmpi	15,a3
	jrhs	dc_air
	movi	defense_dist_table,a5
	jruc	table_from_distance
dc_air	movi	defense_dist_air_table,a5
	jruc	table_from_distance

table_from_distance		;a5 = table, a1 = puck speed, a0 = closest distance
tfd1	move	*a5,a2,W
	cmp	a2,a0
	jrls	tfd2
	addi	48,a5
	jruc	tfd1
tfd2	move	*a5(16),a5,L
	;fall through
control_from_speed_table	;a5 = table, a1 = puck speed
	movi	100,a0
	calla	RAND0
cfst1	move	*a5,a2,W
	cmp	a2,a1
	jrls	cfst2
	addi	48,a5
	jruc	cfst1
cfst2	move	*a5(16),a2,W
	cmp	a2,a0
	jrlo	ctrl_1
	move	*a5(32),a2,W
	cmp	a2,a0
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
ctrl_3	movk	3,a0				;3 = we control it
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
	WL	10,defense_speed_1_table
	WL	32767,defense_speed_2_table
defense_dist_air_table
	WL	10,defense_air_1_table
	WL	32767,defense_air_2_table

;	.word	speed,%1,%2	;3 is by default
intended_speed_c_table
	.word	32767,0,0
;	.word	5,0,0		;puck speed 5 or less, always 3
;	.word	6,0,1		;puck speed 5-6, slight #1, slight #2
;	.word	7,0,1
;	.word	8,0,2
;	.word	9,0,2
;	.word	10,1,4
;	.word	11,1,4
;	.word	12,1,5
;	.word	13,2,6
;	.word	14,2,7
;	.word	32767,3,8	;faster puck goes bigger 1,2
intended_speed_1_table
	.word	32767,0,0
;	.word	5,0,0		;puck speed 5 or less, always 3
;	.word	6,1,2		;puck speed 5-6, slight #1, slight #2
;	.word	7,1,3
;	.word	8,1,4
;	.word	9,1,5
;	.word	10,1,5
;	.word	11,1,7
;	.word	12,2,8
;	.word	13,3,9
;	.word	14,4,10
;	.word	32767,4,11	;faster puck goes bigger 1,2
intended_speed_2_table
	.word	32767,0,0
;	.word	5,0,0
;	.word	6,2,3
;	.word	7,2,4
;	.word	8,2,5
;	.word	9,2,6
;	.word	10,2,7
;	.word	11,3,8
;	.word	12,4,9
;	.word	13,5,10
;	.word	14,6,11
;	.word	32767,6,13

intended_air_c_table
	.word	32767,0,0
;	.word	5,3,7
;	.word	6,4,10
;	.word	7,5,13
;	.word	8,6,16
;	.word	9,7,18
;	.word	10,8,21
;	.word	11,8,23
;	.word	12,9,26
;	.word	13,12,27
;	.word	14,16,28
;	.word	32767,17,30
intended_air_1_table
	.word	32767,0,0
;	.word	5,5,10
;	.word	6,6,13
;	.word	7,7,16
;	.word	8,8,19
;	.word	9,9,22
;	.word	10,11,25
;	.word	11,13,28
;	.word	12,16,31
;	.word	13,19,35
;	.word	14,25,37
;	.word	32767,30,41
intended_air_2_table
	.word	32767,0,0
;	.word	5,6,12
;	.word	6,7,15
;	.word	7,8,18
;	.word	8,9,21
;	.word	9,10,24
;	.word	10,12,27
;	.word	11,14,30
;	.word	12,17,33
;	.word	13,20,37
;	.word	14,26,39
;	.word	32767,31,43

defense_speed_1_table
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
defense_speed_2_table
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

defense_air_1_table
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
defense_air_2_table
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

regular_shot_table
;so far, this table is empty, but can be used to determine type of shots

update_arrow
	move	*a6(POF_ARROW_TIME),a1,W
	jrz	ua_9
	dec	a1
	move	a1,*a6(POF_ARROW_TIME),W
ua_9	rets

update_turbo_drone
	mmtm	sp,a8
	movb	*a6(POF_NUMBER),a0
	sll	4,a0
	addi	utd_okl,a0
	move	*a0,a0,W
	jrz	utd_9
	movb	*a6(POF_TOP_MODE),a0
	callr	get_correct_drone_top
	movb	*a6(POF_TOP_MODE),a1	;get this again (we lost it)
	cmp	a0,a1
	jrz	utd_9
	movb	a0,*a6(POF_TOP_MODE)
	callr	deltop
	movb	*a6(POF_TOP_MODE),a0			;create objects
	sll	5,a0
	addi	utd_ml,a0
	move	*a0,a0,L
	call	a0
utd_9	mmfm	sp,a8
	rets

utd_ml	.long	notop		;nothing
	.long	notop		;we should not be here, non drone
	.long	pstart		;press start
	.long	icoin		;insert coin
	.long	tcontrl		;to control
	.long	pwait		;please wait

utd_okl	.word	0,1,1,0,0,1,1,0,0

notop	jruc	deltop

pstart	movb	*a6(POF_NUMBER),a3
	sll	10,a3
	addi	turbo_stuff_list-1024+3*128,a3
	movi	press_start_init,b0
	calla	EASYMAKE
	callr	stbb1
	move	a8,*a6(POF_TURBO_BOX),L
	rets

icoin	movb	*a6(POF_NUMBER),a3
	sll	10,a3
	addi	turbo_stuff_list-1024+4*128,a3
	movi	insert_coin_init,b0
	calla	EASYMAKE
	callr	stbb1
	move	a8,*a6(POF_TURBO_BOX),L
	rets

tcontrl	movb	*a6(POF_NUMBER),a3
	sll	10,a3
	addi	turbo_stuff_list-1024+5*128,a3
	movi	to_control_init,b0
	calla	EASYMAKE
	callr	stbb1
	move	a8,*a6(POF_TURBO_BOX),L
	addi	128,a3			;skip over to name init stuff
	movi	turbo_name_init,b0
	calla	EASYMAKE
	move	*a6(POF_IMAGE_TABLE),a0,L
	move	*a0,a1,L
	move	*a8(OCTRL),a4,W
	calla	ANI
	callr	stbb1
	move	a8,*a6(POF_TURBO_NAME),L
	rets

pwait	movb	*a6(POF_NUMBER),a3
	sll	10,a3
	addi	turbo_stuff_list-1024+6*128,a3
	movi	please_wait_init,b0
	calla	EASYMAKE
	callr	stbb1
	move	a8,*a6(POF_TURBO_BOX),L
	rets

get_correct_drone_top
	move	@WAVEIRQS,a1,W		;get lower half of longword
	movk	2,a0
	btst	6,a1			;top display changes every second (64 ticks)
	jrnz	gcdt9
	movk	4,a0
gcdt9	rets

set_turbo_bars
	movb	*a6(POF_TOP_MODE),a0
	jrz	stb_c			;nothing on top, create bars
	cmpi	1,a0
	jrz	stb_9
	callr	deltop
stb_c	movb	*a6(POF_NUMBER),a3
	sll	10,a3
	addi	turbo_stuff_list-1024,a3
	movi	turbo_box_init,b0
	calla	EASYMAKE
	callr	stbb1
	move	a8,*a6(POF_TURBO_BOX),L
	movi	turbo_bar_init,b0
	calla	EASYMAKE
	movi	COLOR_RED,a0
	move	a0,*a8(OCONST),W
	move	a8,*a6(POF_TURBO_BAR),L
	callr	stbb1
	movi	turbo_name_init,b0
	calla	EASYMAKE
	move	*a6(POF_IMAGE_TABLE),a0,L
	move	*a0,a1,L
	move	*a8(OCTRL),a4,W
	calla	ANI
	callr	stbb1
	move	a8,*a6(POF_TURBO_NAME),L
	movk	1,a0
	movb	a0,*a6(POF_TOP_MODE)
stb_9	rets

stbb1	move	*a3+,a0,L
	move	a0,*a8(OID),W
	move	*a3+,a0,L
	move	a0,*a8(OXVAL),L
	move	*a3+,a0,L
	move	a0,*a8(OYVAL),L
	move	*a3+,a0,L
	move	a0,*a8(OZVAL),L
	jauc	INSERT_OBJ

deltop	clr	a0
	move	*a6(POF_TURBO_BOX),a8,L
	jrz	dt1
	calla	DELETE_OBJ
	move	a0,*a6(POF_TURBO_BOX),L
dt1	move	*a6(POF_TURBO_BAR),a8,L
	jrz	dt2
	calla	DELETE_OBJ
	move	a0,*a6(POF_TURBO_BAR),L
dt2	move	*a6(POF_TURBO_NAME),a8,L
	jrz	dt3
	calla	DELETE_OBJ
	move	a0,*a6(POF_TURBO_NAME),L
dt3	rets

turbo_stuff_list
	.long	OID_TURBO_1,[24,0],[11,0],[1000,0]		;box
	.long	 OID_TURBOBAR_1,[28,0],[23,0],[1001,0]		;bar
	.long	 OID_TURBONAME_1,[30,0],[0,0],[999,0]		;name
	.long	 OID_TURBO_1,[37,0],[8,0],[999,0]		;press start
	.long	 OID_TURBO_1,[30,0],[8,0],[999,0]		;insert coin
	.long	 OID_TURBO_1,[30,0],[3,0],[999,0]		;to control
	.long	 OID_TURBO_1,[30,0],[8,0],[999,0]		;please wait
	.long	 OID_TURBONAME_1,[30,0],[13,0],[999,0]				;name for to control
	.long	OID_TURBO_2,[124,0],[11,0],[1000,0]		;box
	.long	 OID_TURBOBAR_2,[128,0],[23,0],[1001,0]		;bar
	.long	 OID_TURBONAME_2,[130,0],[0,0],[999,0]		;name
	.long	 OID_TURBO_2,[137,0],[8,0],[999,0]		;press start
	.long	 OID_TURBO_2,[130,0],[8,0],[999,0]		;insert coin
	.long	 OID_TURBO_2,[130,0],[3,0],[999,0]		;to control
	.long	 OID_TURBO_2,[130,0],[8,0],[999,0]		;please wait
	.long	 OID_TURBONAME_2,[130,0],[13,0],[999,0]				;name for to control
	.long	0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	OID_TURBO_5,[224,0],[11,0],[1000,0]		;box
	.long	 OID_TURBOBAR_5,[228,0],[23,0],[1001,0]		;bar
	.long	 OID_TURBONAME_5,[230,0],[0,0],[999,0]		;name
	.long	 OID_TURBO_5,[237,0],[8,0],[999,0]		;press start
	.long	 OID_TURBO_5,[230,0],[8,0],[999,0]		;insert coin
	.long	 OID_TURBO_5,[230,0],[3,0],[999,0]		;to control
	.long	 OID_TURBO_5,[230,0],[8,0],[999,0]		;please wait
	.long	 OID_TURBONAME_5,[230,0],[13,0],[999,0]				;name for to control
	.long	OID_TURBO_6,[324,0],[11,0],[1000,0]		;box
	.long	 OID_TURBOBAR_6,[328,0],[23,0],[1001,0]		;bar
	.long	 OID_TURBONAME_6,[330,0],[0,0],[999,0]		;name
	.long	 OID_TURBO_6,[337,0],[8,0],[999,0]		;press start
	.long	 OID_TURBO_6,[330,0],[8,0],[999,0]		;insert coin
	.long	 OID_TURBO_6,[330,0],[3,0],[999,0]		;to control
	.long	 OID_TURBO_6,[330,0],[8,0],[999,0]		;please wait
	.long	 OID_TURBONAME_6,[330,0],[13,0],[999,0]				;name for to control

turbo_box_init
	.long	turbo
	.word	DMAWNZ,M_SCRNOBJ
	.word	0

turbo_bar_init
	.long	turbbar
	.word	DMACAL,M_SCRNOBJ
	.word	0
turbbar
	.word	01000H,49,3
	.long   0f8000000H
	.word	0,0
	.long	TEXTPAL

turbo_name_init
	.long	EWING
	.word	DMAWNZ,M_SCRNOBJ
	.word	0

press_start_init
	.long	starto
	.word	DMAWNZ,M_SCRNOBJ
	.word	0

insert_coin_init
	.long	inserto
	.word	DMAWNZ,M_SCRNOBJ
	.word	0

please_wait_init
	.long	please
	.word	DMAWNZ,M_SCRNOBJ
	.word	0

to_control_init
	.long	tocontrol
	.word	DMAWNZ,M_SCRNOBJ
	.word	0

update_turbo_up
	mmtm	sp,a8,a9
	move	*a6(POF_S_SPED),a9,L
	callr	set_turbo_bars
	jruc	ut_up
update_turbo
	mmtm	sp,a8,a9
	move	*a6(POF_S_SPED),a9,L
	callr	set_turbo_bars
	move	*a6(POF_BUTTONS),a0,W
	btst	2,a0
	jrz	ut_up			;br= button is up
ut_down	move	*a6(POF_TURBO_AMOUNT),a0,L
	move	*a9(PS_SP_TURBO_DOWN),a14,W
	sll	16,a14
	srl	16,a14
	sub	a14,a0
	jrnn	ut_d1
	clr	a0			;at bottom of turbo
ut_d1	clr	a1
	move	a0,*a6(POF_TURBO_AMOUNT),L
	move	a0,a0
	jrz	ut_m
	inc	a1			;turbo is on
ut_m	move	a1,*a6(POF_TURBO_MODE),W
	movi	35,a0			;delay it from going up 35 ticks
	move	a0,*a6(POF_TURBO_DELAY),W
	jruc	ut_8
ut_up	clr	a0
	move	a0,*a6(POF_TURBO_MODE),W
	move	*a6(POF_TURBO_DELAY),a0,W
	jrz	ut_u1
	dec	a0
	move	a0,*a6(POF_TURBO_DELAY),W
	jruc	ut_8
ut_u1	move	*a6(POF_TURBO_AMOUNT),a0,L
	move	*a9(PS_SP_TURBO_UP),a14,W
	sll	16,a14
	srl	16,a14
	add	a14,a0
	cmpi	[49,0],a0		;70 is width of bar
	jrls	utu2
	movi	[49,0],a0
utu2	move	a0,*a6(POF_TURBO_AMOUNT),L
ut_8	move	*a6(POF_TURBO_AMOUNT+010h),a0,W
	move	*a6(POF_TURBO_BAR),a7,L
	cmpi	2,a0
	jrhi	ut88
	move	*a7(OCTRL),a1,W	;update our object based on turbo amount
	andni	DMAGO,a1
	jruc	ut89
ut88	move	*a7(OCTRL),a1,W
	ori	DMAGO,a1
ut89	move	a1,*a7(OCTRL),W
	move	*a7(OUSIZEX),a1,W
	cmp	a1,a0
	jrz	ut9
	jrgt	ut8u
	dec	a1
	jruc	ut8a
ut8u	inc	a1
ut8a	move	a1,*a7(OUSIZEX),W
ut9	mmfm	sp,a8,a9
	rets

clear_all_signals
	mmtm	sp,a0,a1
	movk	8,a0
	movi	PLAYER_1_BLOCK+POF_FLAGS,a1
casl	move	*a1,a14,W
	andni	(M_PF_SIG_SHOOT|M_PF_SIG_PASS),a14
	move	a14,*a1,W
	addi	PLAYER_BLOCK_SIZE,a1
	dsjs	a0,casl
	mmfm	sp,a0,a1
	rets

signal_to_pass
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_SIG_PASS,a14
	move	a14,*a6(POF_FLAGS),W
	rets

signal_to_shoot
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_SIG_SHOOT,a14
	move	a14,*a6(POF_FLAGS),W
	rets

read_joystick
	mmtm	sp,a0,a1,a2,a3
	move	a0,a14
	sll	6,a14
	addi	joystick_shift_table-64,a14
	move	*a14+,a1,L		;get stick address to read
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

set_team_adjusted_drone_joystick
	rets
	mmtm	sp,a0,a1,a2,a3
	move	a1,a1
;	jrz	sdj_1
	movb	*a6(POF_NUMBER),a0
	dec	a0
	srl	2,a0
	sll	6,a0
	addi	tjl_1-8,a0
	sll	3,a1
	add	a1,a0
	movb	*a0,a0
	movb	a0,*a6(POF_JOY)
	callr	player_rink_check
	movb	a0,*a6(POF_M_JOY)	;store modified direction
	mmfm	sp,a0,a1,a2,a3
	rets

tjl_1	.byte	1,2,3,4,5,6,7,8
	.byte	1,8,7,6,5,4,3,2

joystick_shift_table
	.long	SWITCH,0
	.long	SWITCH,-8
	.long	0,0
	.long	0,0
	.long	SWITCH2,0
	.long	SWITCH2,-8
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
drone_rink_check
	move	*a8(OXPOS),a14,W
	move	*a8(OZPOS),a1,W
	sll	16,a1
	movy	a1,a14			;a14 = [z,x] of puck
	callr	pcl_fnd
	move	*a8(OXVAL),a9,L
	move	*a8(OZVAL),a11,L
	call	a1			;go to address for further checks
	callr	blue_line_check		;keep player from going too far into zone
	move	a9,*a8(OXVAL),L
	move	a11,*a8(OZVAL),L
	rets

blue_line_check
	move	*a8(OFLAGS),a14
	btst	B_OFSCRN,a14
	jrz	blc_9			;still on screen, ok
	movb	*a6(POF_NUMBER),a1
	move	@PUCK_CONTROL,a14,W
	cmp	a14,a1
	jrz	blc_9			;if for some reason, we have puck, but are off screen
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
	move	*a0(OXPOS),a0,W
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
	move	*a0(OXPOS),a0,W
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
	.long	[283,-734],[398,-684],p_lgoal_check
	.long	[283,684],[398,734],p_rgoal_check
	.long	[10,-798+radius],[669,798-radius],p_no_coll
	.long	[-50,-798+radius],[20,798-radius],p_bottom_wall
	.long	[639,-798+radius],[800,798-radius],p_top_wall
	.long	[radius,-788],[679-radius,788],p_no_coll
	.long	[radius,-900],[679-radius,-730],p_left_wall
	.long	[radius,730],[679-radius,900],p_right_wall
	.long	[radius-(radius*7071/10000),-900],[229,-798+radius-(radius*7071/10000)],p_corner_lll
	.long	[-100,-798+radius-(radius*7071/10000)-20],[radius-(radius*7071/10000)+20,-570],p_corner_llr
	.long	[-100,-900],[radius,-798+radius],p_corner_ll
	.long	[450,-900],[679-radius+(radius*7071/10000),-798+radius-(radius*7071/10000)],p_corner_ull
	.long	[679-radius+(radius*7071/10000)-20,-798+radius-(radius*7071/10000)-20],[800,-570],p_corner_ulr
	.long	[679-radius,-900],[800,-798+radius],p_corner_ul
	.long	[radius-(radius*7071/10000),798-radius+(radius*7071/10000)],[229,900],p_corner_lrr
	.long	[-100,570],[radius-(radius*7071/10000)+20,798-radius+(radius*7071/10000)+20],p_corner_lrl
	.long	[-100,798-radius],[radius,900],p_corner_lr

	.long	[450,798-radius+(radius*7071/10000)],[679-radius+(radius*7071/10000),900],p_corner_urr
	.long	[679-radius+(radius*7071/10000)-20,570],[800,798-radius+(radius*7071/10000)+20],p_corner_url
	.long	[679-radius,798-radius],[800,900],p_corner_ur
	.long	[-1000,-1000],[1000,1000],p_no_coll
	.long	0,0,0                                   ;end of table

p_no_coll
	clr	a14
	movb	a14,*a6(POF_CORNER_TEMP)        ;remove corner check
	move	a14,*a6(POF_LAST_BOARD_CVEL),L
	rets
p_bottom_wall
	cmpi    [7,0],a11
	jrge	pbw1
	movi	[7,0],a11                               ;keep player in rink
pbw1	calla	down_check_sound
	jruc	remove_down
p_top_wall
	cmpi    [671,0],a11
	jrle	ptw1
	movi	[671,0],a11                             ;keep player in rink
ptw1	calla	up_check_sound
	jruc	remove_up

p_lgoal_check
	move    *a8(OFLAGS),a4,W
	btst	B_OFSCRN,a4
	jrnz	plg9
	move	a9,a4
	move	a4,a1
	subi	[-734,0],a4
	subi	[-684,0],a1
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
	move	a9,a4
	move	a4,a1
	subi	[734,0],a4
	subi	[684,0],a1
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
pm694	movi	[-684,0],a9
	jruc	remove_left
p293	movi	[283,0],a11
	jruc	remove_up
p388	movi	[398,0],a11
	jruc	remove_down
p736	movi	[734,0],a9
	jruc	remove_left
p694	movi	[684,0],a9
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
	jruc	remove_left
p_right_wall
	cmpi    [790,0],a9
	jrle	prw1
	movi	[790,0],a9                              ;keep player in rink
prw1	calla	right_check_sound
	jruc	remove_right
p_corner_lll
	movi    [-798+radius,0],a0
	movi	[radius,0],a1
	callr	p_corner_check
	jrnc	p_lll_1
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
	callr	remove_down
	jruc	remove_left
pll9	rets
p_corner_ull
	movi    [-798+radius,0],a0
	movi	[679-radius,0],a1
	callr	p_corner_check
	jrnc	p_ull_1
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
	calla	ul_check_sound
	callr	ra_ulr
pultr	rets
p_corner_ul	                        ;failsafe for corner
	movi	[-798+radius,0],a0
	movi	[679-radius,0],a1
	callr	p_corner_check
	jrnc	pul9
	calla	ul_check_sound
	callr	remove_up
	jruc	remove_left
pul9	rets
p_corner_lrr
	movi    [798-radius,0],a0
	movi	[radius,0],a1
	callr	p_corner_check
	jrnc	pulty
	calla	lr_check_sound
	callr	ra_lrr
pulty	rets
p_corner_lrl
	movi    [798-radius,0],a0
	movi	[radius,0],a1
	callr	p_corner_check
	jrnc	p_lrl_1
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
	callr	remove_down
	jruc	remove_right
plr9	rets
p_corner_urr
	movi    [798-radius,0],a0
	movi	[679-radius,0],a1
	callr	p_corner_check
	jrnc	pmf
	calla	ur_check_sound
	callr	ra_urr
pmf	rets
p_corner_url
	movi    [798-radius,0],a0
	movi	[679-radius,0],a1
	callr	p_corner_check
	jrnc	pmf1
	calla	ur_check_sound
	callr	ra_url
pmf1	rets
p_corner_ur	                        ;failsafe for corner
	movi	[798-radius,0],a0
	movi	[679-radius,0],a1
	callr	p_corner_check
	jrnc	pur9
	calla	ur_check_sound
	callr	remove_up
	jruc	remove_right
pur9	rets
p_corner_check
	move    a0,a4
	move	a1,a5
	move	a9,a2
	move	a11,a3
	calla	find_dsquared_to_point_whole_a1
	cmpi	(radius-8)*(radius-8),a1
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
