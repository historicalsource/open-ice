 	.MLIB	"HHMACS.LIB"
	.FILE	"HHPLAYER.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*

	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhplayer.e"
	.include	"hhproc.g"
	.include	"hhram.g"
	.include	"hhmisc.g"
	.include	"hhd.g"
	.include	"hhpuck.g"
	.include	"hhcontrl.g"
	.include	"hhpall.g"
	.include	"hhtables.g"
	.include	"hhscript.g"
	.include	"hhutil.g"
	.include	"hhc.g"
	.include	"hhmath.g"
	.include	"hhgame.g"

; end of include files

	.bss	PLAYER_1_BLOCK,64*32	;player 1
	.bss	PLAYER_2_BLOCK,64*32	;player 2
	.bss	PLAYER_3_BLOCK,64*32	;drone, team 1
	.bss	PLAYER_4_BLOCK,64*32	;goalie/drone, team 1
	.bss	PLAYER_5_BLOCK,64*32	;player 3
	.bss	PLAYER_6_BLOCK,64*32	;player 4
	.bss	PLAYER_7_BLOCK,64*32	;drone, team 2
	.bss	PLAYER_8_BLOCK,64*32	;goalie/drone, team 2

PLAYER_BLOCK_SIZE .equ	2048	;PLAYER_2_BLOCK-PLAYER_1_BLOCK
PLAYER_BLOCK_BSIZE .equ	11	;shift 11 bits to get block #

	.bss	pass_our_blue_status,16
	.bss	xxxx,16		;fill space to 32 bits
	.bss	pass_receiver_1_number,16
	.bss	pass_receiver_1_status,16
	.bss	pass_receiver_1_angle,32
	.bss	pass_receiver_1_object,32
	.bss	pass_receiver_2_number,16
	.bss	pass_receiver_2_status,16
	.bss	pass_receiver_2_angle,32
	.bss	pass_receiver_2_object,32
	.bss	pass_receiver_3_number,16
	.bss	pass_receiver_3_status,16
	.bss	pass_receiver_3_angle,32
	.bss	pass_receiver_3_object,32
	.TEXT
	.EVEN

**************************************************************************
*								         *
* get_player_block							 *
*  input  a0 = player # (1-8)						 *
*  output a6 = base of player block					 *
*								         *
**************************************************************************
get_player_block
	cmpi	3,a0
	jrz	qp51
	cmpi	7,a0
	jrnz	qp52
qp51	nop
qp52

	move	a0,a6
	sll	PLAYER_BLOCK_BSIZE,a6
	addi	PLAYER_1_BLOCK-PLAYER_BLOCK_SIZE,a6
	rets

get_player_block_a5
	cmpi	3,a0
	jrz	gp51
	cmpi	7,a0
	jrnz	gp52
gp51	nop
gp52
	move	a0,a5
	sll	PLAYER_BLOCK_BSIZE,a5
	addi	PLAYER_1_BLOCK-PLAYER_BLOCK_SIZE,a5
	rets

get_player_block_a7
	cmpi	3,a0
	jrz	ap51
	cmpi	7,a0
	jrnz	ap52
ap51	nop
ap52

	move	a0,a7
	sll	PLAYER_BLOCK_BSIZE,a7
	addi	PLAYER_1_BLOCK-PLAYER_BLOCK_SIZE,a7
	rets

turn_all_arrows_long
	movk	7,a0
toap2	cmpi	4,a0
	jrnz	toap1
	dec	a0
toap1
	.if	nskaters=3
	.else
	cmpi	3,a0
	jrz	toapx
	cmpi	7,a0
	jrnz	toapnx
toapx	dec	a0
toapnx
	.endif

	callr	turn_on_a0_arrow_long
	dsjs	a0,toap2
	rets
turn_on_players_arrow
	move	*a6(POF_ARROW_TIME),a1,W
	cmpi	150,a1
	jrhs	topa1
	movi	150,a1
	move	a1,*a6(POF_ARROW_TIME),W
topa1	rets
turn_on_a0_arrow_long
	mmtm	sp,a6
	calla	get_player_block
	movi	320,a1
	jruc	tora2
turn_on_a0_arrow
turn_on_receivers_arrow
	mmtm	sp,a6
	calla	get_player_block
	move	*a6(POF_ARROW_TIME),a1,W
	cmpi	150,a1
	jrhs	tora1
	movi	150,a1
tora2	move	a1,*a6(POF_ARROW_TIME),W
tora1	mmfm	sp,a6
	rets
fix_players_arrow
	movb	*a6(POF_NUMBER),a11
	sll	7,a11
	addi	fpalst-128,a11
	move	*a6(POF_OBJECT),a9,L
	move	*a6(POF_ARROW),a8,L
	move	*a6(POF_ARROW_CPU),a7,L
	move	*a9(OFLAGS),a4,W
	btst	B_OFSCRN,a4
	jrnz	fpa_dos
	movb	*a6(POF_ARROW_HYST),a1			;only go to onscreen mode, if hysteresis is ok
	jrz	fpa_dab

	move	*a8(ODAGX),a14,W
	cmpi	375,a14
	jrgt	fdb_1
	move	*a8(OSIZEX),a0,W
	add	a0,a14
	cmpi	25,a14
	jrlt	fdb_1
	movk	1,a1
fdb_1	dec	a1				;turn arrow hysteresis off if we get too far on screen
	movb	a1,*a6(POF_ARROW_HYST)
	jruc	fpa_ds1
fpa_dab	move	*a6(POF_ARROW_TIME),a1,W
	jrz	fpa_off
	andni	M_SCRNOBJ,a4
	ori	M_NOSCALE,a4
	move	a4,*a8(OFLAGS),W
	move	*a8(OCTRL),a4,W
	ori	DMAWNZ,a4
	move	*a11,a1,L
	calla	ANI
	move	*a9(OXVAL),*a8(OXVAL),L
	move	*a9(OZVAL),a0,L
	move	a0,*a8(OZVAL),L
	sra	20,a0
	sll	4,a0
	addi	zbtab,a0
	move	*a0,a0,W
	sll	16,a0
	move	*a9(OYVAL),a2,L
	sub	a0,a2
	move	a2,*a8(OYVAL),L
	move	*a9(OXVEL),*a8(OXVEL),L
	move	*a9(OZVEL),*a8(OZVEL),L
	move	*a9(OYVEL),*a8(OYVEL),L
	move	*a6(POF_FLAGS),a0,W
	btst	B_PF_HUMAN,a0
	jrz	cpuarrowon
	jruc	nocpu1
cpuarrowoff
	move	a7,a7
	jrz	nocpu1
	move	*a7(OCTRL),a0,W
	andni	DMAGO,a0
	move	a0,*a7(OCTRL),W
nocpu1	rets
cpuarrowon
	move	a7,a7
	jrz	nocpu2
	move	*a7(OCTRL),a0,W
	ori	DMAGO,a0
	move	a0,*a7(OCTRL),W
	move	*a8(OXVAL),*a7(OXVAL),L
	move	*a8(OZVAL),a0,L
	subi	[3,0],a0
	move	a0,*a7(OZVAL),L
	move	*a8(OYVAL),a0,L
	sra	1,a0
	move	a0,*a7(OYVAL),L
	move	*a8(OXVEL),*a7(OXVEL),L
	move	*a8(OZVEL),*a7(OZVEL),L
	move	*a8(OYVEL),*a7(OYVEL),L
nocpu2	rets
fpa_off	callr	cpuarrowoff
	move	*a8(OCTRL),a4,W
	andni	DMAGO,a4
	move	a4,*a8(OCTRL),W
	clr	a0
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OZVEL),L
	rets
fpa_dos	movk	32,a14				;hysteresis of 1/2 second to arrow
	movb	a14,*a6(POF_ARROW_HYST)
fpa_ds1	callr	cpuarrowoff
	movi	150,a4
	move	a4,*a6(POF_ARROW_TIME),W
	move	*a8(OFLAGS),a4,W
	ori	M_SCRNOBJ,a4
	move	a4,*a8(OFLAGS),W
	move	@WORLDX+010h,a1,W
	move	*a9(OXPOS),a0,W
	sub	a1,a0
	jrp	fpp_dos
fpl_dos	neg	a0
	subi	200,a0
	sra	5,a0
	sll	4,a0
	addi	xp_ofst,a0
	move	*a0,a0,W
	addk	4,a0
	move	*a8(OCTRL),a4,W
	ori	DMAWNZ,a4
	move	*a11(32),a1,L
	jruc	fpp1
fpp_dos	subi	200,a0
	sra	5,a0
	sll	4,a0
	addi	xp_ofst,a0
	move	*a0,a0,W
	subi	360,a0
	move	*a8(OCTRL),a4,W
	ori	DMAWNZ,a4
	move	*a11(64),a1,L
	neg	a0
fpp1	calla	ANI
	move	a0,*a8(OXPOS),W
	move	*a9(OZVAL),a1,L
	movi	[-40,0],a2
	calla	find_screen_from_world
	move	a1,*a8(OYVAL),L
	clr	a1
	move	a1,*a8(OXVEL),L
	move	a1,*a8(OYVEL),L
	move	a1,*a8(OZVEL),L
	jauc	set_scrnobj_to_pos

	.word	26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26
xp_ofst	.word	26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8
	.word	7,6,5,4,3,2,1,0
	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	.word	84,84,84,84,84,84,84,84,84
zbtab	.word	84,83,82,81,80,79,79,78,77,76,75,74,74,73,72,72
	.word	71,70,69,69,68,68,67,66,66,65,65,64,63,63,62,62
	.word	61,61,60,60,59,59,58,58,57,57,56
	.word	56,56,56,56,56,56,56,56,56

fpalst	.long	arrow1t,arrow1l,arrow1r,0
	.long	arrow2t,arrow2l,arrow2r,0
	.long	arrow2t,arrow2l,arrow2r,0
	.long	arrow2t,arrow2l,arrow2r,0
	.long	arrow3t,arrow3l,arrow3r,0
	.long	arrow4t,arrow4l,arrow4r,0
	.long	arrow4t,arrow4l,arrow4r,0
	.long	arrow4t,arrow4l,arrow4r,0

fix_players_shadow			;we can put this into animation scripts
	move	*a6(POF_OBJECT),a9,L
	move	*a6(POF_SHADOW),a8,L
	move	*a9(OXVAL),*a8(OXVAL),L
	move	*a9(OYVAL),*a8(OYVAL),L
	move	*a9(OZVAL),a4,L
	move	a4,a14
	addi	[4600,0],a4
	move	a4,*a8(OZVAL),L
	move	*a9(OXVEL),*a8(OXVEL),L
	move	*a9(OZVEL),*a8(OZVEL),L
fpr_1	sra	20,a14
	sll	5,a14
	addi	z_shad_table,a14
	move	*a14,a1,L
	move	*a8(OIMG),a14,L
	cmp	a14,a1
	jrz	fps_09
	move	*a8(OCTRL),a4,W
	jauc	ANI
fps_09	rets

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

**************************************************************************
*								         *
* find_player_object		UNUSED					 *
* 	input  a0 = player number					 *
* 	output a8 = player object (z set if not found)			 *
*								         *
**************************************************************************
find_player_object
	mmtm	sp,a0,a1,a2
	sll	4,a0
	addi	fpol-16,a0
	move	*a0,a14,W
	move	a14,a2
	calla	GETSUPP_FROM_OID
	move	a14,a0
	clr	a1
	dec	a1
	calla	FINDOID
	jrz	fpo9
	move	a0,a8
fpo9	mmfm	sp,a0,a1,a2
	rets

fpol	.word	OID_PLAYER_1
	.word	OID_PLAYER_2
	.word	OID_PLAYER_3
	.word	OID_PLAYER_4
	.word	OID_PLAYER_5
	.word	OID_PLAYER_6
	.word	OID_PLAYER_7
	.word	OID_PLAYER_8

**************************************************************************
*								         *
* move_player_to_puckpoint						 *
* 	input	a0 = x pos of puckpoint					 *
* 		a1 = z pos of puckpoint					 *
* 		a8 = object						 *
* 	output	puts object at a position, so that it's puckpoint	 *
* 		is at x and z (y=0)					 *
*								         *
**************************************************************************
move_player_to_puckpoint
	move	a0,a2
	move	a1,a3
	callr	get_players_puck_point_o		;we have object already
	move	*a8(OXVAL),a4,L
	move	*a8(OZVAL),a5,L
	sub	a4,a0
	sub	a5,a1
	sub	a0,a2
	sub	a1,a3
	move	a2,*a8(OXVAL),L
	move	a3,*a8(OZVAL),L
	clr	a4
	move	a4,*a8(OYVAL),L
	rets

**************************************************************************
*								         *
* place_puck_with_player						 *
* 	input  a6 = player block					 *
* 	  what we need to go through					 *
* 		get players x,y,and z position (probably 0 y)		 *
* 		convert position to screen coords (we can't use odag)	 *
* 		compute his scale					 *
* 		scale his animation point (adjust for flip)		 *
* 		go back from position to top left			 *
* 		scale his extra animation point	(adjust for flip)	 *
* 		go down to puck x,y position				 *
* 		convert screen xy to world xz				 *
* 		put puck there						 *
* 		copy players velocities to pucks			 *
*								         *
**************************************************************************
place_puck_with_player
	move	@PUCK_CONTROL,a1,W
	jrz	ppwp_9
	movb	*a6(POF_NUMBER),a0
	cmp	a0,a1
	jrnz	ppwp_9
	callr	get_players_puck_point_b
	move	@PUCK_OBJECT,a9,L
	move	a0,*a9(OXVAL),L		;store to pucks position
	move	a1,*a9(OZVAL),L
	clr	a2
	move	a2,*a9(OYVAL),L
	move	*a8(OXVEL),*a9(OXVEL),L	;copy velocities to puck
	move	*a8(OYVEL),*a9(OYVEL),L	;to minimize puck drift between updates
	move	*a8(OZVEL),*a9(OZVEL),L
ppwp_9	rets

get_players_puck_point
	calla	get_player_block
get_players_puck_point_b
	move	*a6(POF_OBJECT),a8,L
get_players_puck_point_o
	mmtm	sp,a2,a3,a4,a5,a7,a11
	move	*a8(OXVAL),a0,L
	move	*a8(OYVAL),a2,L
	move	*a8(OZVAL),a1,L
	calla	find_screen_from_world	;get our current point
	srl	16,a0
	move	a0,a5
	movy	a1,a5			;make a5 [y,x]
	move	*a8(OZPOS),a4,W
	sll	5,a4
	move	*a8(OSCTAB),a14,L	;get scale table for player
	add	a4,a14
	move	*a14,a14,L
	move	a14,a3
	srl	16,a3
	sll	4,a3
	addi	invscale_table,a3
	move	*a3,a2,W	;y
	sll	16,a14
	srl	12,a14
	addi	invscale_table,a14
	move	*a14,a3,W	;x
	move	*a8(OCTRL),a14,W
	move	*a8(OIMG),a7,L		;we need to look in image directly
	move	*a7(050h),a1,L		;uanioff
	callr	scale_anioff
	subxy	a1,a5			;go back to top
	move	*a7(090h),a1,L		;extra animation point (puck position)
	callr	scale_anioff
	addxy	a1,a5			;back to puck position [y,x]
	move	a5,a1			;to y
	move	a5,a0
	sll	16,a0			;to x
	calla	find_world_from_screen
	mmfm	sp,a2,a3,a4,a5,a7,a11
	rets

**************************************************************************
*								         *
* scale_anioff								 *
* 	input	a14 = octrl						 *
* 		a1  = uanioff						 *
* 		a2,a3 = scales						 *
* 	output	a1  = scaled anioff					 *
*								         *
**************************************************************************
scale_anioff				;this is adapted straight from
	setf	12,1,1			;scale_mama
	btst	B_FLIPH,a14
	jrz	ppwp_1
	movx	a1,a4
	sext	a4
	neg	a4
	movx	a4,a1
ppwp_1	btst	B_FLIPV,a14
	jrz	ppwp_2
	move	a1,a4
	neg	a4
	movy	a4,a1
ppwp_2	move	a1,a11
	sext	a11
	mpys	a3,a11
	sra	8,a11
	sra	16,a1
	mpys	a2,a1
	sll	8,a1
	movx	a11,a1		;a1 is scaled anioff
	setf	32,0,1		; restore FS1	 !!!
	rets

**************************************************************************
*								         *
* get_pass_receiver							 *
* 	input	a0 = player number					 *
* 	output	a0 = player to pass to					 *
* 									 *
* 	if all teammates on same side of blue line			 *
* 	   pass to joystick player direction				 *
* 	if some teammates on same side of blue line			 *
* 	   if joystick points to a player on same side of blue line	 *
* 	      pass to joystick player direction				 *
* 	   if joystick is reasonably close to player on same side of lin *
* 	      pass to that player					 *
* 	   else								 *
* 	      pass to joystick player					 *
* 	if none on same side of blue line				 *
* 	   pass to joystick player direction				 *
* 	or, pass to player if they are pressing pass			 *
*								         *
**************************************************************************
get_pass_receiver
	mmtm	sp,a1,a2,a6,a10
	callr	get_eligible_players_list
	callr	find_angles_to_players
	callr	find_blue_line_status
	callr	remove_ineligible_and_pick
	mmfm	sp,a1,a2,a6,a10
	rets

get_eligible_players_list
	move	a0,a10
	sll	6,a10
	addi	p_angle_no_goalie_tab-64,a10
	move	*a10+,a14,W
	move	a14,@pass_receiver_1_number
	move	*a10+,a14,W
	move	a14,@pass_receiver_2_number
	move	*a10+,a14,W
	move	a14,@pass_receiver_3_number
	rets

find_angles_to_players
	movi	pass_receiver_1_number,a3
	movi	pass_receiver_1_angle,a4
	movi	pass_receiver_1_object,a5
	callr	fafg1
	movi	pass_receiver_2_number,a3
	movi	pass_receiver_2_angle,a4
	movi	pass_receiver_2_object,a5
	callr	fafg1
	movi	pass_receiver_3_number,a3
	movi	pass_receiver_3_angle,a4
	movi	pass_receiver_3_object,a5
fafg1	move	*a3,a1,W
	jrz	fafg2
	callr	find_angle_from_joystick
	move	a2,*a4,L
	move	a9,*a5,L
fafg2	rets


find_blue_line_status
	movb	*a6(POF_NUMBER),a14
	move	@PUCK_OBJECT,a3,L
	movi	pass_our_blue_status,a4
	move	*a3(OXPOS),a0,W
	callr	frba
	movi	pass_receiver_1_number,a3
	movi	pass_receiver_1_status,a4
	callr	fbrpp
	movi	pass_receiver_2_number,a3
	movi	pass_receiver_2_status,a4
	callr	fbrpp
	movi	pass_receiver_3_number,a3
	movi	pass_receiver_3_status,a4
fbrpp	move	*a3,a0,W
	jrz	frbl9
	mmtm	sp,a6,a8
	callr	get_players_puck_point
	mmfm	sp,a6,a8
	sra	16,a0
	move	*a3,a14,W
	jrz	frbl9
frba	dec	a14
	srl	2,a14
	jrnz	fbl48
fbl14	clr	a1
	cmpi	5,a0
	jrle	frbl5
	movk	1,a1
	cmpi	233,a0
	jrle	frbl5
	movk	2,a1
	jruc	frbl5
fbl48	clr	a1
	cmpi	-5,a0
	jrge	frbl5
	movk	1,a1
	cmpi	-233,a0
	jrge	frbl5
	movk	2,a1
frbl5	move	a1,*a4
frbl9	rets

remove_ineligible_and_pick
	move	@pass_receiver_1_status,a0,W
	move	@pass_receiver_2_number,a1,W
	jrz	rip_os
	move	@pass_receiver_2_status,a1,W
	cmp	a0,a1
	jrnz	rip_ns				;not all teammates are on 1 side of blue line
	move	@pass_receiver_3_number,a2,W
	jrz	rip_os				;all teammates are on 1 side, now see if we are
	move	@pass_receiver_3_status,a2,W
	cmp	a0,a2
	jrnz	rip_ns				;not all teammates are on 1 side of blue line
rip_os	move	@pass_our_blue_status,a2,W
	cmp	a2,a0
	jrz	rip_p				;all teammates on our side, pick 1
rip_aos	callr	add_to_angle_if_away_from_blue	;all are teammates on other side
	jruc	rip_p				;pick a player
rip_ns	callr	add_to_angle_if_not_blue	;not all on blue, just add to angles that are
rip_p	callr	subtract_from_angle_if_pressed
	move	@pass_receiver_1_number,a0,W
	move	@pass_receiver_1_angle,a1,L
	move	@pass_receiver_2_number,a14,W
	jrz	rpp2
	move	@pass_receiver_2_angle,a2,L
	cmp	a1,a2
	jrhs	rpp1
	move	@pass_receiver_2_number,a0,W
	move	a2,a1
rpp1	move	@pass_receiver_3_number,a14,W
	jrz	rpp2
	move	@pass_receiver_3_angle,a2,L
	cmp	a1,a2
	jrhs	rpp2
	move	a14,a0
rpp2	rets
add_to_angle_if_away_from_blue
	move	@pass_receiver_1_object,a8,L
	callr	fabc
	move	@pass_receiver_1_angle,a1,L
	add	a0,a1
	move	a1,@pass_receiver_1_angle,L
	move	@pass_receiver_2_number,a0,W
	jrz	ata9
	move	@pass_receiver_2_object,a8,L
	callr	fabc
	move	@pass_receiver_2_angle,a1,L
	add	a0,a1
	move	a1,@pass_receiver_2_angle,L
	move	@pass_receiver_3_number,a0,W
	jrz	ata9
	move	@pass_receiver_3_object,a8,L
	callr	fabc
	move	@pass_receiver_3_angle,a1,L
	add	a0,a1
	move	a1,@pass_receiver_3_angle,L
ata9	rets
fabc	clr	a0
	move	*a8(OXPOS),a1,W
	abs	a1
	subi	233,a1
	abs	a1
	cmpi	40,a1
	jrls	fbc1
	movi	XD0300,a0		;30 degree penalty for not near line
fbc1	rets

add_to_angle_if_not_blue
	move	@pass_our_blue_status,a2,W
	move	@pass_receiver_1_status,a1,W
	callr	faab
	move	@pass_receiver_1_angle,a1,L
	add	a0,a1
	move	a1,@pass_receiver_1_angle,L
	move	@pass_receiver_2_number,a1,W
	jrz	atai1
	move	@pass_receiver_2_status,a1,W
	callr	faab
	move	@pass_receiver_2_angle,a1,L
	add	a0,a1
	move	a1,@pass_receiver_2_angle,L
	move	@pass_receiver_3_number,a1,W
	jrz	atai1
	move	@pass_receiver_3_status,a1,W
	callr	faab
	move	@pass_receiver_3_angle,a1,L
	add	a0,a1
	move	a1,@pass_receiver_3_angle,L
atai1	rets
faab	clr	a0
	cmp	a1,a2
	jrz	fabb
	movi	XD0300,a0
fabb	rets

subtract_from_angle_if_pressed
	movi	pass_receiver_1_number,a0
	movi	pass_receiver_1_angle,a2
	callr	sfa1
	movi	pass_receiver_2_number,a0
	movi	pass_receiver_2_angle,a2
	callr	sfa1
	movi	pass_receiver_3_number,a0
	movi	pass_receiver_3_angle,a2
sfa1	move	*a0,a0,W
	jrz	sfa8
	calla	get_player_block
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_SIG_PASS,a14
	jrz	sfa8
	move	*a2,a0,L
	subi	XD3600,a0
	jrnn	sfa2
	clr	a0
sfa2	move	a0,*a2,L
sfa8	rets

**************************************************************************
*								         *
* find_player_to_angle							 *
*      finds player closest to joystick angle				 *
* 	input	a10 = address of player check list (3 long)		 *
* 		a6  = player block					 *
* 		a8  = player object					 *
* 	output	a4  = player closest to joystick angle			 *
* 		a3  = angle difference to joystick			 *
*								         *
**************************************************************************
find_player_to_angle
	movk	3,a11
	clr	a4
	movi	[32767,0],a3		;initial, BIG angle
gpr2	move	*a10+,a1
	jrz	gpr3
	callr	find_angle_from_joystick
	cmp	a3,a2			;are we higher than saved
	jrhs	gpr3			;yes, don't save it
	move	a1,a4			;save player #
	move	a2,a3			;save angle
gpr3	dsjs	a11,gpr2
	rets


p_angle_no_goalie_tab			;used when goalie is goalie
	.if	nskaters=3

	.word	2,3,0,0
	.word	1,3,0,0
	.word	1,2,0,0
	.word	1,2,3,0
	.word	6,7,0,0
	.word	5,7,0,0
	.word	5,6,0,0
	.word	5,6,7,0

	.else

	.word	2,0,0,0
	.word	1,0,0,0
	.word	1,2,0,0
	.word	1,2,0,0
	.word	6,0,0,0
	.word	5,0,0,0
	.word	5,6,0,0
	.word	5,6,0,0

	.endif

p_angle_goalie_tab			;used when goalie is fourth player
	.if	nskaters=3

	.word	2,3,4,0
	.word	1,3,4,0
	.word	1,2,4,0
	.word	1,2,3,0
	.word	6,7,8,0
	.word	5,7,8,0
	.word	5,6,8,0
	.word	5,6,7,0

	.else

	.word	2,4,0,0
	.word	1,4,0,0
	.word	1,1,1,0
	.word	1,2,0,0
	.word	6,8,0,0
	.word	5,8,0,0
	.word	1,1,1,0
	.word	5,6,0,0

	.endif


**************************************************************************
*								         *
* find_angle_from_joystick						 *
* 	input	a6 = player block					 *
* 		a8 = object						 *
* 		a1 = player to check					 *
* 	output	a2 = difference in angle from direction (abs radians)	 *
* 		a9 = player to check's object				 *
*								         *
**************************************************************************
find_angle_from_joystick
	mmtm	sp,a0,a1,a3,a5,a7
	move	*a6(POF_FLAGS),a0,W
	btst	B_PF_HUMAN,a0
	jrz	fdfc			;we are a drone
	movb	*a6(POF_JOY),a0
	jrnz	fdf1
fdfc	movb	*a6(POF_DIRECTION),a0
fdf1	calla	dir_to_radians		;a0 is radians of our stick
	move	a0,a7			;save ourself to a7
	move	a1,a0
	calla	get_player_block_a5
	move	*a5(POF_OBJECT),a9,L
	move	*a9(OXVAL),a0,L		;our test player
	move	*a9(OZVAL),a1,L
	move	*a8(OXVAL),a2,L		;ourself
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point
	sub	a7,a0			;difference in angles
	abs	a0			;now it is positive
	cmpi	XD1800,a0
	jrls	fdf2			;if 0-180, we are done
	subi	XD3600,a0			;if 180-360, make it angle - 360
	neg	a0
fdf2	move	a0,a2
	mmfm	sp,a0,a1,a3,a5,a7
	rets

**************************************************************************
*								         *
* get_offense_mode							 *
* 	input	a0 = player number					 *
* 	output	a1 = 0 - offense					 *
* 		   = 1 - defense					 *
* 		   = 2 - neither					 *
*								         *
**************************************************************************
get_offense_mode
	mmtm	sp,a0
	move	@PUCK_CONTROL,a1,W
	jrnz	awo_a
	move	@PUCK_LAST_CONTROL,a1,W
	jrz	awo_2
awo_a	callr	are_a0a1_same_team
	jrz	awo_0
awo_1	movk	1,a1
	mmfm	sp,a0
	rets
awo_0	clr	a1
	mmfm	sp,a0
	rets
awo_2	movk	2,a1
	mmfm	sp,a0
	rets

are_a0a1_same_team
	dec	a0
	srl	2,a0
	dec	a1
	srl	2,a1
	cmp	a0,a1
	rets
reset_players_turbo
	movi	[49,0],a2
	clr	a3
	movk	8,a0
rpt1
	.if	nskaters=3
	.else
	cmpi	3,a0
	jrz	rui_1
	cmpi	7,a0
	jrnz	rui_2
rui_1	dec	a0
rui_2
	.endif

	calla	get_player_block
	move	a3,*a6(POF_TURBO_DELAY),W
	move	a2,*a6(POF_TURBO_AMOUNT),L
	dsjs	a0,rpt1
	rets

**************************************************************************
*								         *
* check_mode_ok								 *
* 	input	a3 = address of table for mode checks			 *
* 		a6 = player block					 *
* 	output	c  = mode is ok						 *
* 		nc = mode is not ok					 *
*								         *
**************************************************************************
check_mode_ok
	mmtm	sp,a0,a3
	move	*a6(POF_MODE),a14,W
cm1	move	*a3+,a0,W
	jrn	cm8
	cmp	a14,a0
	jrnz	cm1
	setc
	mmfm	sp,a0,a3
	rets
cm8	clrc
	mmfm	sp,a0,a3
	rets



