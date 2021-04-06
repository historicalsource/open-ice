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
	.include	"player.tbl"
	.include	"newnums.tbl"
	.include	"hhplayer.e"
	.include	"hhproc.g"
	.include	"hhram.g"
	.include	"hhmisc.g"
	.include	"hhd.g"
	.include	"hhpuck.g"
	.include	"hhcontrl.g"
	.include	"hhpall.g"
	.include	"hhtables.g"
	.include	"hhutil.g"
	.include	"hhc.g"
	.include	"hhmath.g"
	.include	"hhgame.g"
	.include	"hhcontr2.g"
	.include	"hhtext.g"

; end of include files

	.bss	PLAYER_1_BLOCK,PLAYER_BLOCK_SIZE	;player 1
	.bss	PLAYER_2_BLOCK,PLAYER_BLOCK_SIZE	;player 2
	.bss	PLAYER_3_BLOCK,PLAYER_BLOCK_SIZE	;drone, team 1
	.bss	PLAYER_4_BLOCK,PLAYER_BLOCK_SIZE	;goalie/drone, team 1
	.bss	PLAYER_5_BLOCK,PLAYER_BLOCK_SIZE	;player 3
	.bss	PLAYER_6_BLOCK,PLAYER_BLOCK_SIZE	;player 4
	.bss	PLAYER_7_BLOCK,PLAYER_BLOCK_SIZE	;drone, team 2
	.bss	PLAYER_8_BLOCK,PLAYER_BLOCK_SIZE	;goalie/drone, team 2

	.bss	pass_our_blue_status,16
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

turn_all_arrows_long
	movk	8,a0
toap2	cmpi	3,a0
	jrz	toapx
	cmpi	7,a0
	jrnz	toapnx
toapx	dec	a0
toapnx	GBLOCK	a0,a14
	move	*a14(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	toapl
	callr	turn_on_a0_arrow_long
toapl	dsjs	a0,toap2
	rets

turn_on_players_arrow
	move	*a6(POF_ARROW_TIME),a1,W
	cmpi	50,a1		;150
	jrhs	topa1
	movi	50,a1		;150
	move	a1,*a6(POF_ARROW_TIME),W
topa1	rets
turn_on_a0_arrow_long
	mmtm	sp,a6
	GBLOCK	a0,a6
	movi	50,a1		;320
	jruc	tora2
turn_on_a0_arrow
turn_on_receivers_arrow
	mmtm	sp,a6
	GBLOCK	a0,a6
	move	*a6(POF_ARROW_TIME),a1,W
	cmpi	50,a1		;150
	jrhs	tora1
	movi	50,a1		;150
tora2	move	a1,*a6(POF_ARROW_TIME),W
tora1	mmfm	sp,a6
	rets

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

fpalst2p
	.long	arrow1t,arrow1l,arrow1r,0
	.long	arrow3t,arrow3l,arrow3r,0
	.long	arrow3t,arrow3l,arrow3r,0
	.long	arrow3t,arrow3l,arrow3r,0
	.long	arrow4t,arrow4l,arrow4r,0
	.long	arrow2t,arrow2l,arrow2r,0
	.long	arrow4t,arrow4l,arrow4r,0
	.long	arrow4t,arrow4l,arrow4r,0

fix_players_arrow
do_players_arrow
	move	*a6(POF_OBJECT),a9,L
	move	*a6(POF_ARROW),a8,L
	move	@GAME_STATE,a14,W
	cmpi	INAMODE,a14
	jrz	aof
	move	*a6(POF_ARROW_CPU),a7,L
	jrz	ncpca
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrnz	notcpua
     	callr	cpu_arrow_on			;if cpuarrow present (cpu player), turn off arrow, turn on cpu)
	jruc	ncpca
notcpua	callr	cpu_human_arrow
ncpca	movb	*a6(POF_NUMBER),a11
	sll	7,a11
	KITN	4
	jrz	dora4
	addi	fpalst2p-128,a11
	jruc	dorax
dora4	addi	fpalst-128,a11		;a11 points to our arrow list
dorax	move	*a9(OFLAGS),a4,W
	btst	B_OFSCRN,a4
	jrnz	place_arrow_off_screen_player	;if he is off the screen, then he always has off screen arrow
	movb	*a6(POF_ARROW_HYST),a1
	jrz	place_arrow_on_screen_player	;he is on screen, no hysteresis
	dec	a1
	movb	a1,*a6(POF_ARROW_HYST)
	move	*a9(ODAGX),a14,W
	move	*a9(OSIZEX),a0,W
	move	*a9(OCTRL),a1,W
	btst	B_FLIPH,a1
	jrz	nfl1
	sub	a0,a14			;adjust for flip to make dag left edge
nfl1	cmpi	375,a14
	jrgt	place_arrow_off_on_screen_player ;he is on screen, but we are near edge, with hysteresis
	add	a0,a14
	cmpi	25,a14
	jrge	place_arrow_on_screen_player	;he is near center of screen, put on screen
	jruc	place_arrow_off_on_screen_player ;he is on screen, but we are near edge, with hysteresis

place_arrow_off_screen_player	;(a8 placed with a9)
	movi	255,a14				;hysteresis of 1/2 second to arrow
	movb	a14,*a6(POF_ARROW_HYST)
place_arrow_off_on_screen_player ;(a8 placed with a9) (when near edge, but still on screen)
	movi	150,a4			;he is off screen, set his time for when he gets back on
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
	move	*a11(32),a1,L
	jruc	fpp1
fpp_dos	subi	200,a0
	sra	5,a0
	sll	4,a0
	addi	xp_ofst,a0
	move	*a0,a0,W
	subi	360,a0
	neg	a0
	move	*a11(64),a1,L
fpp1	move	*a8(OCTRL),a4,W
	ori	DMAWNZ,a4
    	calla	maybe_ani
	move	a0,*a8(OXPOS),W
	move	*a9(OZVAL),a1,L
	movi	[-40,0],a2
	calla	find_screen_from_world
	move	a1,*a8(OYVAL),L
	clr	a1
	move	a1,*a8(OXVEL),L
	move	a1,*a8(OYVEL),L
	move	a1,*a8(OZVEL),L
	move	*a6(POF_FREEZE_OFFTIME),a14,W
	inc	a14
	move	a14,*a6(POF_FREEZE_OFFTIME),W
	cmpi	140,a14
	jrnz	fppt9
	mmtm	sp,a2,a9,a10
	calla	check_freeze_offscreen
	mmfm	sp,a2,a9,a10
fppt9	rets

place_arrow_on_screen_player	;(a8 placed with a9)
;;;	move	*a6(POF_ARROW_CPU),a7,L
;;;	jrnz	aof			;don't put arrows on screen for cpu players
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	aof			;don't put arrows on screen for cpu players

	move	*a6(POF_ARROW_TIME),a14,W
	jrz	aof
	dec	a14
	move	a14,*a6(POF_ARROW_TIME),W
	clr	a14			;clear out our hysteresis
	movb	a14,*a6(POF_ARROW_HYST)
	move	a14,*a6(POF_FREEZE_OFFTIME),W
	move	*a8(OFLAGS),a4,W
	andni	M_SCRNOBJ,a4
	move	a4,*a8(OFLAGS),W
	movi	DMAWNZ,a4
	movb	*a6(POF_NUMBER),a1
	move	@PUCK_CONTROL,a14,W
	cmp	a14,a1
	jrnz	pcosp
	move	@puck_control_blink,a14,W
	jrz	pcosp
	dec	a14
	move	a14,@puck_control_blink
	sra	2,a14
	jrc	pcosp
	movi	DMACNZ,a4
pcosp	move	*a11,a1,L
	calla	maybe_ani
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
	rets
aof	movi	DMAGO,a0
	move	a0,*a8(OCTRL),W
aof9	rets

cpu_arrow_on	;a7 = cpuarrow
	move	*a9(OXVAL),*a7(OXVAL),L
	move	*a9(OZVAL),a0,L
	subi	[3,0],a0
	move	a0,*a7(OZVAL),L
	sra	20,a0
	sll	4,a0
	addi	zbtab+48,a0
	move	*a0,a0,W
	sll	15,a0
	move	a0,a1
	sra	2,a1
	add	a1,a0
	neg	a0
	move	a0,*a7(OYVAL),L
	move	*a9(OXVEL),*a7(OXVEL),L
	move	*a9(OZVEL),*a7(OZVEL),L
	rets

cpu_human_arrow
	movb	*a6(POF_NUMBER),a0
	move	a0,a14
	sll	5,a14
	addi	caolll,a14
	move	@PUCK_CONTROL,a1,W
	cmp	a0,a1
	jrnz	cpa112
	addi	caopll-caolll,a14
cpa112	move	*a14,a14,L
	move	a14,*a7(OIMG),L
	move	*a14(ISIZE),a0,L
	move	a0,*a7(OSIZE),L
	move	a0,*a7(OUSIZE),L
	move	*a14(ISAG),*a7(OSAG),L
	move	*a14(IANIOFF),*a7(OANIOFF),L

	move	*a9(OXVAL),*a7(OXVAL),L
	move	*a9(OZVAL),a0,L
	subi	[3,0],a0
	move	a0,*a7(OZVAL),L
	sra	20,a0
	sll	4,a0
	addi	zbtab+48,a0
	move	*a0,a0,W
	sll	15,a0
	move	a0,a1
	sra	2,a1
	add	a1,a0
	neg	a0
	move	a0,*a7(OYVAL),L
	move	*a9(OXVEL),*a7(OXVEL),L
	move	*a9(OZVEL),*a7(OZVEL),L
	rets

;caolll	.long	FONT100,FONT101,FONT102,FONT103,FONT104
;	.long	FONT105,FONT106,FONT107,FONT108,FONT109
;	.long	FONT100,FONT100,FONT100

caolll	.long	FONT100,FONT101,FONT102,FONT100,FONT100
	.long	FONT103,FONT104,FONT100,FONT100,FONT100
	.long	FONT100,FONT100,FONT100

caopll	.long	FONT100,P01,P02,FONT100,FONT100
	.long	P03,P04,FONT100,FONT100,FONT100
	.long	FONT100,FONT100,FONT100



**************************************************************************
*								         *
* move_player_to_puckpoint						 *
* 	input	a0 = x pos of puckpoint					 *
* 		a1 = z pos of puckpoint					 *
* 		a8 = object						 *
* 	output	puts object at a position, so that's its puckpoint	 *
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
	move	*a8(OXVAL),a4,L
	sub	a2,a4
	abs	a4
	srl	16,a4
	cmpi	1,a4
	jrls	mptp1
	move	a2,*a8(OXVAL),L
mptp1	move	*a8(OZVAL),a4,L
	sub	a3,a4
	abs	a4
	srl	16,a4
	cmpi	1,a4
	jrls	mptp2
	move	a3,*a8(OZVAL),L
mptp2	clr	a4
	move	a4,*a8(OYVAL),L
	rets

**************************************************************************
*								         *
* get_players_puck_point						 *
* get_players_puck_point_b						 *
* get_players_puck_point_o						 *
* 									 *
* PASS:									 *
* VARIOUS								 *
* RETURN:								 *
* A0 = X POSITION							 *
* A1 = Z POSITION							 *
*								         *
**************************************************************************
get_players_destination_point	;takes a6 = us
	PUSH	a6
	callr	get_players_puck_point
	PULLQ	a6
	rets
get_players_puck_point
	GBLOCK	a0,a6
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
	srl	2,a4		;new osctab
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
	move	*a7(IANIOFF),a1,L		;uanioff
	callr	scale_anioff
	subxy	a1,a5			;go back to top
	move	*a7(ICPUCK),a1,L		;extra animation point (puck position)
	callr	scale_anioff
	addxy	a1,a5			;back to puck position [y,x]
	move	a5,a1			;to y
	move	a5,a0
	sll	16,a0			;to x
	calla	find_world_from_screen
;	inc	a0		;half	;shift right 1 pixel to account for all our truncates
	mmfm	sp,a2,a3,a4,a5,a7,a11
	rets

get_players_puck_point_rz	;ref
	mmtm	sp,a3,a4,a5,a7,a11
	move	*a8(OXVAL),a0,L
	move	*a8(OYVAL),a2,L
	move	*a8(OZVAL),a1,L
	calla	find_screen_from_world	;get our current point
	srl	16,a0
	move	a0,a5
	movy	a1,a5			;make a5 [y,x]
	move	*a8(OZPOS),a4,W
	srl	2,a4		;new osctab
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
	move	*a7(IANIOFF),a14,L		;uanioff
	move	*a7(ICPUCK),a1,L		;extra animation point (puck position)
	subxy	a14,a1
	addxy	a1,a5			;back to puck position [y,x]
	move	a5,a1			;to y
	move	a5,a0
	sll	16,a0			;to x
	move	*a8(OZVAL),a2,L
	calla	find_world_from_screen_z
	mmfm	sp,a3,a4,a5,a7,a11
	rets

get_players_puck_point_bz
	move	*a6(POF_OBJECT),a8,L
get_players_puck_point_oz
	mmtm	sp,a3,a4,a5,a7,a11
	move	*a8(OXVAL),a0,L
	move	*a8(OYVAL),a2,L
	move	*a8(OZVAL),a1,L
	calla	find_screen_from_world	;get our current point
	srl	16,a0
	move	a0,a5
	movy	a1,a5			;make a5 [y,x]
	move	*a8(OZPOS),a4,W
	srl	2,a4		;new osctab
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
	move	*a7(IANIOFF),a1,L		;uanioff
	callr	scale_anioff
	subxy	a1,a5			;go back to top
	move	*a7(ICPUCK),a1,L		;extra animation point (puck position)
	callr	scale_anioff
	addxy	a1,a5			;back to puck position [y,x]
	move	a5,a1			;to y
	move	a5,a0
	sll	16,a0			;to x
	move	*a8(OZVAL),a2,L
	calla	find_world_from_screen_z
	mmfm	sp,a3,a4,a5,a7,a11
	rets

**************************************************************************
*								         *
* get_supplied_offset_point						 *
* 	just like get_puck_point_o					 *
* 	except takes animation offset as an input			 *
* 	input	a1 = animation point offset [y,x] 			 *
* 	  (assumes y will be 0)						 *
*								         *
**************************************************************************
get_supplied_offset_point
	mmtm	sp,a2,a3,a4,a5,a7,a11
	mmtm	sp,a1			;push our point
	move	*a8(OXVAL),a0,L
	move	*a8(OYVAL),a2,L
	move	*a8(OZVAL),a1,L
	calla	find_screen_from_world	;get our current point
	srl	16,a0
	move	a0,a5
	movy	a1,a5			;make a5 [y,x]
	move	*a8(OZPOS),a4,W
	srl	2,a4		;new osctab
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
	move	*a7(IANIOFF),a1,L		;uanioff
	callr	scale_anioff
	subxy	a1,a5			;go back to top
	mmfm	sp,a1			;get our point back
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
ppwp_1	move	a1,a11
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
	mmtm	sp,a1,a2,a6,a8,a10
	GBLOCK	a0,a6
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	gpr_g
	callr	get_eligible_players_list
	callr	find_angles_to_players
	callr	find_blue_line_status
	callr	remove_ineligible_and_pick
	mmfm	sp,a1,a2,a6,a8,a10
	rets
gpr_g	callr	get_eligible_players_list
	callr	find_angles_to_players
	callr	find_blue_line_status
	callr	favor_players_not_behind
	callr	remove_ineligible_and_pick
	mmfm	sp,a1,a2,a6,a8,a10
	rets

favor_players_not_behind
	movi	pass_receiver_1_number,a3
	movi	pass_receiver_1_angle,a4
	movi	pass_receiver_1_object,a5
	callr	fpnb1
	movi	pass_receiver_2_number,a3
	movi	pass_receiver_2_angle,a4
	movi	pass_receiver_2_object,a5
	callr	fpnb1
	movi	pass_receiver_3_number,a3
	movi	pass_receiver_3_angle,a4
	movi	pass_receiver_3_object,a5
fpnb1	move	*a3,a1,W
	jrz	fpnb3
	move	*a5,a5,L
	move	*a5(OXVAL),a14,L
	cmpi	4,a1
	jrls	fpnb2
	neg	a14
fpnb2	cmpi	[-600,0],a14
	jrgt	fpnb3
	move	*a4,a14,L
	addi	XD7200,a14
	move	a14,*a4,L
fpnb3	rets

get_eligible_players_list
	move	a0,a10
	movi	p_angle_no_pfour_tab-64,a14
	move	a0,a10
	dec	a10
	srl	2,a10
	inc	a10
	sll	2,a10		;a10 is now our teams goalie/extra drone
	GBLOCK	a10,a10
	move	*a10(POF_FLAGS),a10,W
	btst	B_PF_GOALIE,a10
	jrnz	gepl1		;our goalie is a goalie
	movi	p_angle_pfour_tab-64,a14	;our goalie is really extra drone
gepl1	move	a0,a10
	sll	6,a10
	add	a14,a10
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
	move	a2,a2
	jrnz	fa4
	movk	1,a2			;don't let our angle be exactly zero
fa4	move	a2,*a4,L
	move	a9,*a5,L
fafg2	rets

find_blue_line_status
	movb	*a6(POF_NUMBER),a14
	move	@PUCK_OBJECT,a3,L
	movi	pass_our_blue_status,a4

	move	*a3(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
	move	*a3(OXPOS),a0,W		;half

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
	addi	[0,08000h],a0		;half
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
	GBLOCK	a0,a6
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

p_angle_no_pfour_tab			;used when goalie is goalie
	.word	2,0,0,0
	.word	1,0,0,0
	.word	1,2,0,0
	.word	1,2,0,0
	.word	6,0,0,0
	.word	5,0,0,0
	.word	5,6,0,0
	.word	5,6,0,0

p_angle_pfour_tab				;used when goalie is fourth player
	.word	2,4,0,0
	.word	1,4,0,0
	.word	1,1,1,0
	.word	1,2,0,0
	.word	6,8,0,0
	.word	5,8,0,0
	.word	1,1,1,0
	.word	5,6,0,0

**************************************************************************
*								         *
* find_angle_from_joystick						 *
* 	input	a6 = player block					 *
* 		a8 = object						 *
* 		a1 = player to check					 *
* 	output	a2 = difference in angle from direction (abs degrees)	 *
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
fdf1	calla	dir_to_degrees		;a0 is degrees of our stick
	move	a0,a7			;save ourself to a7
	GBLOCK	a1,a5
	move	*a5(POF_OBJECT),a9,L
	move	*a9(OXVAL),a0,L		;our test player
	move	*a9(OZVAL),a1,L
	move	*a8(OXVAL),a2,L		;ourself
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point
	sub	a7,a0			;difference in angles
	THETA_H	a0
	abs	a0
	move	a0,a2
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
awo_a	dec	a0		;are a0 and a1 same team
	srl	2,a0
	dec	a1
	srl	2,a1
	cmp	a0,a1
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

reset_players_turbo
	movi	[71,0],a2
	clr	a3
	movk	8,a0
rpt1	cmpi	3,a0
	jrz	rui_1
	cmpi	7,a0
	jrnz	rui_2
rui_1	dec	a0
rui_2	GBLOCK	a0,a6
	move	a3,*a6(POF_TURBO_DELAY),W
	move	a2,*a6(POF_TURBO_AMOUNT),L
	dsjs	a0,rpt1
	rets

store_players_tired
	movk	8,a0
spt1	cmpi	3,a0
	jrz	sui_1
	cmpi	7,a0
	jrnz	sui_2
sui_1	dec	a0
sui_2	GBLOCK	a0,a6
	move	*a6(POF_TURBO_AMOUNT),a14
	movk	1,a2
	cmpi	35,a14
	jrls	sui3
	clr	a2
sui3	move	a2,*a6(POF_TIRED),L
	dsj	a0,spt1
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
