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
	.include	"hhhigher.e"
	.include	"hhplayer.g"
	.include	"hhmath.g"
	.include	"hhproc.g"
	.include	"hhscript.g"
	.include	"hhcontrl.g"
	.include	"hhgame.g"
	.include	"hhpuck.g"
	.include	"hhutil.g"
	.include	"hhshow.g"
	.include	"hhtimer.g"
	.include	"hhd.g"

; end of include files


**************************************************************************
*								         *
* faceoff								 *
*								         *
**************************************************************************
faceoff
	C_O_R	PID_FACEOFF,faceoff_process
	rets
faceoff_process
	clr	a14
	move	a14,@PUCK_CONTROL,W
	move	a14,@PUCK_LAST_CONTROL,W
	movi	100,a14
	move	a14,@PUCK_MODE,W	;now set puck mode to face off
	movi	face_off_points,a4
	callr	move_players_to_points
	JSRP	wait_for_all_control
	calla	turn_all_arrows_long
	movi	face_off_2_points,a4
	callr	free_skate_players_to_points
	JSRP	wait_for_all_control
	SLEEP	50
	callr	pick_faceoff_winner
	callr	set_faceoff_puck_state
	calla	start_timer
	movi	100,a0
	calla	show_timer_t
	SLEEP	14
	callr	give_back_all_control
	jauc	SUCIDE

pick_faceoff_winner
	movk	2,a0		;team 1
	calla	RANDU
	move	a0,a1
	rets
set_faceoff_puck_state
	sll	8,a1
	addi	faceoff_state_table-256,a1
	move	*a1+,a0,L
	calla	get_player_block
	movk	8,a4
	movb	a4,*a6(POF_IGNORE_PUCK)
	move	*a1+,a0,L
	calla	get_player_block
	movb	a4,*a6(POF_IGNORE_PUCK)
	move	*a1+,a0,L
	move	a0,@world_mt_point,W
	move	*a1+,a0,L
	move	*a1,a1,L
	move	@PUCK_OBJECT,a8,L
	calla	set_obj_to_rect
	movk	1,a0
	move	a0,@PUCK_MODE,W
	jauc	puck_slide_sound

faceoff_state_table
	.long	2,5,160,[-10,0],[3,0],0,0,0
	.long	5,2,-160,[10,0],[3,0],0,0,0

face_off_points
	.word	1,-140,400,2
	.word	2,-150,339,3
	.word	5,150,339,7
	.word	6,140,400,8

	.if	nskaters=3
	.word	3,-140,280,4
	.word	7,140,280,6
	.endif

	.word	0

face_off_2_points
	.word	2,-80,339,3
	.word	5,80,339,7
	.word	0

**************************************************************************
*								         *
* move_players_to_points						 *
* 	input	a4 = list of player/points				 *
*								         *
**************************************************************************
move_players_to_points
mtps_2	move	*a4+,a0,W
	jrz	mtps_9
	move	*a4+,a2,W
	sll	16,a2
	move	*a4+,a3,W
	sll	16,a3
	move	*a4+,a1,W
	callr	move_player_to_point
	jruc	mtps_2
mtps_9	rets

**************************************************************************
*								         *
* free_skate_players_to_points						 *
* 	input	a4 = list of player/points				 *
*								         *
**************************************************************************
free_skate_players_to_points
fsps_2	move	*a4+,a0,W
	jrz	fsps_9
	move	*a4+,a2,W
	sll	16,a2
	move	*a4+,a3,W
	sll	16,a3
	move	*a4+,a1,W
	callr	free_skate_player_to_point
	jruc	fsps_2
fsps_9	rets

**************************************************************************
*								         *
* wait_for_all_control							 *
* 	waits for all control to end (by process id, not flags)		 *
*    USE JSRP								 *
*								         *
**************************************************************************
wfa_1	SLEEP	1
wait_for_all_control
	movi	PID_MOVE_TO,a0
	calla	EXISTP_ALL
	jrnz	wfa_1
	RETP

**************************************************************************
*								         *
* give_back_all_control							 *
* 	gives control back to every player, start play			 *
*								         *
**************************************************************************
give_back_all_control
	movk	8,a0
gba_1
	.if	nskaters=3
	.else
	cmpi	3,a0
	jrz	ghy_1
	cmpi	7,a0
	jrnz	ghy_2
ghy_1	dec	a0
ghy_2
	.endif

	callr	release_higher_control
	dsjs	a0,gba_1
	rets

**************************************************************************
*								         *
* move_player_to_point							 *
* 	input	a0 = player						 *
* 		a1 = direction to face when over			 *
* 		a2 = x position						 *
* 		a3 = z position						 *
*								         *
**************************************************************************
move_player_to_point
	move	a0,a9
	move	a2,a10
	move	a3,a11
	move	a1,a8
	CREATEP	PID_MOVE_TO,mptp_1
	rets
mptp_1	movi	set_run_script,a1
	movi	set_stand_script,a2
	JSRP	move_player_to_point_process
	jauc	SUCIDE

**************************************************************************
*								         *
* free_skate_player_to_point						 *
* 	input	a0 = player						 *
* 		a1 = direction to face when over			 *
* 		a2 = x position						 *
* 		a3 = z position						 *
*								         *
**************************************************************************
free_skate_player_to_point
	move	a0,a9
	move	a2,a10
	move	a3,a11
	move	a1,a8
	CREATEP	PID_MOVE_TO,fstp_1
	rets
fstp_1	movi	set_free_skate_script,a1
	movi	set_stand_script,a2
	JSRP	move_player_to_point_pnw
	jauc	SUCIDE

**************************************************************************
*								         *
* move_player_to_point_process						 *
* 	input	a9 = player						 *
* 		a10 = x position					 *
* 		a11 = z position					 *
* 		a8 = direction to face when done			 *
* 		a1 = routine to call to set move script			 *
* 		a2 = routine to call to set stand script		 *
*   USE JSRP								 *
*								         *
**************************************************************************
move_player_to_point_pnw 	;assumes we have control
	move	a9,a0
	PUSHP	a2		;stand script
	PUSHP	a8		;direction to face
	PUSHP	a1		;move routine to set script
	calla	get_player_block
	jruc	mptp_3
move_player_to_point_process
	move	a9,a0
	PUSHP	a2		;stand script
	PUSHP	a8		;direction to face
	PUSHP	a1		;move routine to set script
	JSRP	get_higher_control
mptp_3	clr	a14
	movb	a14,*a6(POF_I_JOY)	;clear out joystick ignore
	move	*a6(POF_OBJECT),a8,L
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	move	a10,a0
	move	a11,a1
	calla	find_dirdis_to_point
	sra	16,a1
	jrp	mk
	nop
mk	move	a1,a9		;save distance
	lmo	a1,a1
	sll	5,a1
	addi	mptp_v,a1
	move	*a1,a2,L
	jrz	mptp_8
	move	a2,a14
	sra	1,a14
	move	a14,*a6(POF_SPEED_GL),L
	movk	25,a3			;move to
	move	*a8(OFLAGS),a14,W
	btst	B_OFSCRN,a14
	jrnz	ak48
	move	*a8(ODT_VEL),a1,L
	cmpi	[16,0],a1
	jrls	ak49
	move	a2,a1
	jruc	ak47
ak49	calla	move_to_speed_x
	jruc	ak47
ak48	movi	[18,0],a1
ak47	calla	set_obj_to_polar
	cmpi	5,a9			;if we are closer than 5 pixels
	jrls	skipfc			;do not face us
	mmtm	sp,a11
	calla	face_travel
	mmfm	sp,a11
	move	*a12,a14,L	;get move routine from process stack
	call	a14		;set move script
	jruc	skipfc
skipfc	move	a6,a9
	SLEEP	1
	move	a9,a6
	jruc	mptp_3
mptp_8	clr	a1
	addk	32,a12		;remove move routine from stack
	PULLP	a0		;get face direction
	movb	a0,*a6(POF_DIRECTION)
	calla	dir_to_radians
	calla	set_obj_to_polar
	PULLP	a14
	call	a14		;set stand script
	RETP

mptp_v	.long	0		;lmo = 31	80000000-ffffffff, 0
	.long	[14,0]		;lmo = 30	40000000-7fffffff
	.long	[14,0]		;lmo = 29	20000000-3fffffff
	.long	[14,0]		;lmo = 28	10000000-1fffffff
	.long	[14,0]		;lmo = 27	08000000-0fffffff
	.long	[14,0]		;lmo = 26	04000000-07ffffff
	.long	[14,0]		;lmo = 25	02000000-03ffffff
	.long	[14,0]		;lmo = 24	01000000-01ffffff
	.long	[14,0]		;lmo = 23	00800000-00ffffff
	.long	[14,0]		;lmo = 22	00400000-007fffff
	.long	[14,0]		;lmo = 21	00200000-003fffff
	.long	[14,0]		;lmo = 20	00100000-001fffff
	.long	[14,0]		;lmo = 19	00080000-000fffff
	.long	[14,0]		;lmo = 18	00040000-0007ffff
	.long	[14,0]		;lmo = 17	00020000-0003ffff
	.long	[14,0]		;lmo = 16	00010000-0001ffff
	.long	[14,0]		;lmo = 15	00008000-0000ffff
	.long	[14,0]		;lmo = 14	00004000-00007fff
	.long	[14,0]		;lmo = 13	00002000-00003fff
	.long	[14,0]		;lmo = 12	00001000-00001fff
	.long	[14,0]		;lmo = 11	00000800-00000fff
	.long	[13,0]		;lmo = 10	00000400-000007ff
	.long	[11,0]		;lmo = 9	00000200-000003ff
	.long	[8,0]		;lmo = 8	00000100-000001ff
	.long	[6,0]		;lmo = 7	00000080-000000ff
	.long	[4,0]		;lmo = 6	00000040-0000007f
	.long	[3,0]		;lmo = 5	00000020-0000003f
	.long	[1,0f001h]	;lmo = 4	00000010-0000001f
	.long	[0,0f001h]	;lmo = 3	00000008-0000000f
	.long	[0,0c001h]	;lmo = 2	00000004-00000007
	.long	[0,08001h]	;lmo = 1	00000002-00000003
	.long	[0,06001h]	;lmo = 0	00000001-00000001

**************************************************************************
*								         *
* get_higher_control							 *
* 	input	a0 = player number					 *
*   USE JSRP								 *
*								         *
**************************************************************************
get_higher_control
ghc_1	callr	get_higher_status
	move	a1,a1
	jrz	ghc_8
	cmpi	1,a1
	jrz	ghc_2
	move	a0,a9
	SLEEP	1
	move	a9,a0
	jruc	ghc_1
ghc_2	callr	take_higher_wait
ghc_3	SLEEP	1
	move	a9,a0
	calla	get_player_block
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HIGHER,a14
	jrnz	ghc_3
ghc_8	callr	take_higher_control
ghc_85	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrnz	ghc_9
	SLEEP	1
	move	a9,a0
	calla	get_player_block
	jruc	ghc_85
ghc_9	RETP

**************************************************************************
*								         *
* release_higher_control						 *
* 	input	a0 = player number					 *
*								         *
**************************************************************************
release_higher_control
	calla	get_player_block
	move	*a6(POF_FLAGS),a14,W
	andni	M_PF_HIGHER|M_PF_HIGHER_W,a14
	move	a14,*a6(POF_FLAGS),W
	rets

**************************************************************************
*								         *
* get_higher_status							 *
* 	input	a0 = player number					 *
* 	output	a1 = 0 - no one has control				 *
* 		     1 - someone has control now			 *
* 		     2 - someone has control, and someone is waiting	 *
* 		a6 = player block					 *
*								         *
**************************************************************************
get_higher_status
	calla	get_player_block
	move	*a6(POF_FLAGS),a14,W
	clr	a1
	btst	B_PF_HIGHER,a14
	jrz	ghs_7
	movk	1,a1
ghs_7	btst	B_PF_HIGHER_W,a14
	jrz	ghs_9
	movk	2,a1
ghs_9	rets

**************************************************************************
*								         *
* take_higher_control							 *
* 	input	a6 = player block					 *
*								         *
**************************************************************************
take_higher_control
	move	*a6(POF_FLAGS),a14,W
	andni	M_PF_HIGHER_W,a14
	ori	M_PF_HIGHER,a14
	move	a14,*a6(POF_FLAGS),W
	rets

**************************************************************************
*								         *
* take_higher_wait							 *
* 	input	a6 = player_block					 *
*								         *
**************************************************************************
take_higher_wait
	move	*a6(POF_FLAGS),a14,W
	ori	M_PF_HIGHER_W,a14
	move	a14,*a6(POF_FLAGS),W
	rets
