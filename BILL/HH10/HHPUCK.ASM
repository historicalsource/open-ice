  	.MLIB	"HHMACS.LIB"
	.FILE	"HHPUCK.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hhpuck.e"
	.include	"hhd.g"
	.include	"hhmisc.g"
	.include	"hhproc.g"
	.include	"hhutil.g"
	.include	"hhcontrl.g"
	.include	"hhplayer.g"
	.include	"hhmath.g"
	.include	"hhc.g"
	.include	"hha.g"
	.include	"hhpall.g"
	.include	"hhscript.g"
	.include	"hhscore.g"
	.include	"hhram.g"
	.include	"hhshow.g"

; end of include files


	.bss	PUCK_OBJECT,32		;object of puck
	.bss	PUCK_SHADOW,32		;object of puck shadow
	.bss	PUCK_CONTROL,16		;player controlling puck (0=no player)
	.bss	PUCK_LAST_CONTROL,16	;player who last controlled puck (for passing, shooting)
	.bss	PUCK_INTENDED,16	;player puck is intended for
	.bss	NO_PUCK_SLOW,16
	.bss	PUCK_OPEN_CONTROL_TIME,16
	.bss	PUCK_OPEN_LAST_TIME,16
	.bss	PUCK_MODE,16		;only valid if puck_control = 0
	;  0 - open puck
	;  1 - puck at face off, always get control
	; 10 - pass
	; 11 - turbo pass
	; 12 - regular shot
	; 13 - slap shot
	; 14 - one timer
	; 15 - dump into zone
	; 99 - puck has scored a goal, no one can touch it till face off
	;100 - face off, can't control yet
	;101 - end of period, can't control
	.bss	PUCK_MODE_2,16		;only valid if puck_control = 0 and on ground
	; 0 - puck flat on ground
	; 1 - puck flopping on ground
	; 2 - puck rolling
	.bss	PUCK_M2_TIME,16		;time at current state (1,2) of PUCK_MODE_2
	.bss	xxxxxx,16
	.bss	trigger_puck_sound,16
	.bss	puck_allowed_state,16
	.bss	last_puck_xz,32

	.TEXT
	.EVEN

**************************************************************************
*								         *
* puck_watch								 *
* 	this is the process that watches the puck, and when a player	 *
* 	does not control it, watches for player interaction and rink	 *
* 	collisions							 *
* 	 maybe make this an irq event					 *
*								         *
**************************************************************************
puck_watch
pw_0	move	@PUCK_OBJECT,a8,L
	move	@PUCK_CONTROL,a0,W
	jrz	pw_free			;puck is free
	callr	puck_shadow_off
	callr	set_puck_script
	SLEEP	1
	jruc	pw_0
pw_free	move	@PUCK_OPEN_LAST_TIME,a4,W
	jrz	pw_f3
	dec	a4
	move	a4,@PUCK_OPEN_LAST_TIME,W
	jrnz	pw_f3
	clr	a4
	move	a4,@PUCK_INTENDED,W
	move	a4,@PUCK_LAST_CONTROL,W
	move	@PUCK_MODE,a14,W
	cmpi	99,a14
	jrhs	pw_f3			;if we can't control it, we still can't
	move	a4,@PUCK_MODE,W
pw_f3	move	@PUCK_OPEN_CONTROL_TIME,a4,W
	jrz	pwf33
	dec	a4
	move	a4,@PUCK_OPEN_CONTROL_TIME,W
pwf33	callr	puck_rink_check
	move	@NO_PUCK_SLOW,a4,W
	jrz	pwf_1
	dec	a4
	move	a4,@NO_PUCK_SLOW,W
	jruc	pwf_2
pwf_1	move	@PUCK_OBJECT,a8,L
	move	*a8(OYVAL),a4,L
	jrn	pwf_2
	callr	slow_puck_down
pwf_2	callr	puck_player_check
;	CALLR	PUCK_GOALIE_CHECK
	SLEEP	1
	jruc	pw_0

**************************************************************************
*								         *
* PUCK_GOALIE_CHECK - CHECK FOR GOALIE COLLISION WITH PUCK		 *
* 									 *
* PASS:									 *
* NUTIN'								 *
* RETURN:								 *
* NUTIN'								 *
*								         *
**************************************************************************

PUCK_GOALIE_CHECK
	MOVE	@PUCK_MODE,A0,W
	CMPI	99,A0
	JRGE	PGC_DONE		;BR=DON'T CHECK

	MOVI	PLAYER_4_BLOCK,A6

	CALLR	FIND_D_PCENTER_TO_PUCK
;	CALLR	find_distance_player_to_puck

	.if	XUNIT=1
	CMPK	30,A1
	.else
	CMPI	30,A1
	.endif
	JRGT	PGC_CHECK_8	

	MOVE	@PUCK_OBJECT,A8,L
	MOVE	*A8(OZPOS),A1,W
	SLL	16,A1
	MOVE	*A8(OXPOS),A0,W
	MOVY	A1,A0

	CLR	A2
	JRUC	r_stick_or_nostick_bounce
PGC_CHECK_8
	MOVI	PLAYER_8_BLOCK,A6

	CALLR	FIND_D_PCENTER_TO_PUCK
;	CALLR	find_distance_player_to_puck

	.if	XUNIT=1
	CMPK	30,A1
	.else
	CMPI	30,A1
	.endif
	JRGT	PGC_DONE	

	MOVE	@PUCK_OBJECT,A8,L
	MOVE	*A8(OZPOS),A1,W
	SLL	16,A1
	MOVE	*A8(OXPOS),A0,W
	MOVY	A1,A0

	MOVI	XD1800,A2
	JRUC	r_stick_or_nostick_bounce
PGC_DONE
	RETS
		



puck_player_check
	move	@PUCK_MODE,a0,W
	cmpi	99,a0			;are we in just scored goal mode?
	jrhs	papc_9			;br= yes, noone can touch it
	callr	check_puck_intended_player
	move	@PUCK_CONTROL,a0,W
	jrnz	papc_9
	jruc	check_puck_any_player
papc_9	rets

check_puck_intended_player
	move	@PUCK_INTENDED,a0,W
	jrz	cpip_9
	calla	get_player_block
	movb	*a6(POF_IGNORE_PUCK),a14
	jrnz	cpip_9
	callr	find_distance_player_to_puck
	move	*a6(POF_S_HAND),a14,L
	move	*a14(PS_HN_INT_CONTROL),a14,L
	jruc	puck_control_in
check_puck_any_player
	callr	find_closest_player_to_puck
	move	a3,a0
	jrn	cpip_9
	calla	get_player_block
	move	@PUCK_INTENDED,a5,W
	cmp	a3,a5
	jrz	cpip_9
	movb	*a6(POF_IGNORE_PUCK),a14
	jrnz	cpip_9
	move	@PUCK_OPEN_CONTROL_TIME,a0,W
	jrz	cpapaok			;if control time is 0, we don't care about last control
	move	@PUCK_LAST_CONTROL,a0,W
	cmp	a0,a3
	jrz	cpip_9
cpapaok	move	a3,a0		;player to a0
	move	*a6(POF_S_HAND),a7,L
	move	*a7(PS_HN_OFF_CONTROL),a7,L
	calla	get_offense_mode
	move	a1,a1
	jrz	cpap_3
	move	*a6(POF_S_HAND),a7,L
	move	*a7(PS_HN_DEF_CONTROL),a7,L
cpap_3	move	a7,a14
puck_control_in
	move	@PUCK_OBJECT,a8,L
	call	a14
	sll	5,a0
	addi	cpip_l,a0
	move	*a0,a0,L
	jump	a0
cpip_l	.long	cpip_ignore
	.long	cpip_missed
	.long	cpip_rebound
	.long	cpip_control

cpip_ignore
	rets
cpip_missed
	movb	a2,*a6(POF_IGNORE_PUCK)
	rets
cpip_rebound
	movb	a2,*a6(POF_IGNORE_PUCK)
	clr	a0
	move	a0,@PUCK_INTENDED,W
	move	a0,@PUCK_LAST_CONTROL,W
	jruc	put_puck_in_other_direction
cpip_control
	movb	*a6(POF_NUMBER),a0
	move	a0,@PUCK_CONTROL,W
	movi	150,a0
	move	a0,*a6(POF_ARROW_TIME),W
	clr	a0
	move	a0,@PUCK_INTENDED,W
	move	a0,@PUCK_LAST_CONTROL,W
	jruc	new_puck_control		;new player has control
cpip_9	rets

new_puck_control		;new player has control
	calla	clear_all_signals
	move	@PUCK_CONTROL,a0,W
	calla	get_player_block
	move	*a6(POF_BUTTONS),a1,W
	btst	0,a1			;is shoot button in
	jrz	npc_9			;br=no
	movi	onetime_ok_mlist,a3
	calla	check_mode_ok
	jrnc	npc_9
	move	@PUCK_MODE,a3		;we now allow one timers from any mode
	cmpi	10,a3
	jrz	npct
	cmpi	11,a3
	jrnz	npc_9
npct	movk	14,a1
	move	a1,@PUCK_MODE,W
	sll	5,a0			;fork off shoot switch process
	addi	npcl-32,a0
	move	*a0,a7,L
	movi	PID_IND,a1
	jauc	GETPRC
npc_9	clr	a0
	move	a0,@PUCK_MODE,W		;clear out mode, so we can scroll
	rets
onetime_ok_mlist
	.word	0,1,4,-1

npcl	.long	SW_4
	.long	SW_12
	.long	SW_12
	.long	SW_12
	.long	SW_20
	.long	SW_28
	.long	SW_28
	.long	SW_28

find_closest_player_to_puck
	movi	[32767,0],a4
	clr	a3
	dec	a3		;if a3 < 0 on end, noone is close
	movk	8,a0
fcp_1
	.if	nskaters=3
	.else

	cmpi	7,a0
	jrz	fcp1x
	cmpi	3,a0
	jrnz	fcp1xx
fcp1x	dec	a0
fcp1xx

	.endif

	mmtm	sp,a0,a3,a4
	callr	find_dsquared_player_to_puck
	mmfm	sp,a0,a3,a4
	movb	*a6(POF_IGNORE_PUCK),a14
	jrnz	fcp_2
	cmp	a4,a1
	jrhs	fcp_2
	move	a1,a5		;we have a close player, check if moving toward or away
	mmtm	sp,a0,a3,a4,a5
	callr	find_dsquared_to_next_puck
	mmfm	sp,a0,a3,a4,a5
	cmp	a5,a1
	jrhi	fcp_2		;br= puck is moving away from player, it doesn't count
	move	a0,a3		;player is in a3
	move	a5,a4		;new min distance in a4
fcp_2	dsjs	a0,fcp_1
	move	a4,a1
	calla	SQROOT
	move	a1,a4
	rets


**************************************************************************
*								         *
* FIND_D_PCENTER_TO_PUCK - FIND DISTANCE FROM CENTER OF PLAYER TO PUCK	 *
* 									 *
* PASS:									 *
* A6 = PLAYER DATA BLOCK						 *
* 									 *
* RETURN:								 *
* A1 = DISTANCE								 *
*								         *
**************************************************************************

FIND_D_PCENTER_TO_PUCK
	MOVE	*A6(POF_OBJECT),A8,L
	MOVE	*A8(OXVAL),A0,L
	MOVE	*A8(OZVAL),A1,L
	JRUC	FDP0
	
find_distance_to_next_puck	;figures where puck will be next frame
	calla	get_players_puck_point
	move	*a8(OXVEL),a14,L
	add	a14,a0			;add velocities to player puck point
	move	*a8(OZVEL),a14,L
	add	a14,a1
	move	@PUCK_OBJECT,a9,L
	move	*a9(OXVAL),a2,L
	move	*a9(OZVAL),a3,L
	move	*a9(OXVEL),a14,L	;add velocities to puck
	add	a14,a2			; and compute from there
	move	*a9(OZVEL),a14,L
	add	a14,a3
	jruc	fdp1
find_distance_player_to_puck		;must return a1 and a4
	calla	get_players_puck_point
FDP0
	move	@PUCK_OBJECT,a9,L
	move	*a9(OXVAL),a2,L
	move	*a9(OZVAL),a3,L
fdp1	move	a0,a5
	sub	a2,a5
	abs	a5
	move	a1,a4
	sub	a3,a4
	abs	a4
	add	a4,a5
	cmpi	[300,0],a5
	jrgt	fdp_8		;too far to bother with
	calla	find_dis_to_point_whole
	move	a4,a1
	rets
fdp_8	movi	[32767,0],a1
	rets

find_dsquared_to_next_puck	;figures where puck will be next frame
	calla	get_player_block
	move	*a6(POF_OBJECT),a8,L
	move	a7,a7
	jrz	fdpp
	move	*a8(OXVAL),a0,L
	move	*a8(OZVAL),a1,L
	jruc	fdpx
fdpp	calla	get_players_puck_point
fdpx	move	*a8(OXVEL),a14,L
	add	a14,a0			;add velocities to player puck point
	move	*a8(OZVEL),a14,L
	add	a14,a1
	move	@PUCK_OBJECT,a9,L
	move	*a9(OXVAL),a2,L
	move	*a9(OZVAL),a3,L
	move	*a9(OXVEL),a14,L	;add velocities to puck
	add	a14,a2			; and compute from there
	move	*a9(OZVEL),a14,L
	add	a14,a3
	calla	find_dsquared_to_point_whole
	move	a4,a1
	rets

find_dsquared_player_to_puck		;must return a1 and a4
	calla	get_player_block
	move	*a6(POF_OBJECT),a8,L
	move	@PUCK_OBJECT,a9,L
	move	*a9(OXVAL),a2,L
	move	*a9(OZVAL),a3,L
	move	*a8(OXVAL),a0,L
	move	*a8(OZVAL),a1,L
	move	a0,a5
	sub	a2,a5
	abs	a5
	move	a1,a4
	sub	a3,a4
	abs	a4
	add	a4,a5
	cmpi	[300,0],a5
	jrgt	fds_8		;too far to bother with
	calla	find_dsquared_to_point_whole
	move	a4,a5
	calla	get_players_puck_point_o
	calla	find_dsquared_to_point_whole
	clr	a7		;indicate puck point
	cmp	a5,a4
	jrls	fds2
	move	a5,a4
	inc	a7		;indicate player point
fds2	move	a4,a1
	rets
fds_8	movi	[32767,0],a1
	rets

**************************************************************************
*								         *
* create_puck: create puck object and insert on list			 *
*              zero's velocities and position				 *
*              returns a8 = PUCK_OBJECT = puck object			 *
*								         *
**************************************************************************
create_puck
	movi	puck_init,b0
	calla	EASYMAKE
	move	a0,a8
	move	a8,@PUCK_OBJECT,L
	movi	puck_shadow_init,b0
	calla	EASYMAKE
	move	a0,@PUCK_SHADOW,L
	move	a0,a8
	movi	pkshd,a0
	calla	CHANGE_PAL
	move	@PUCK_OBJECT,a8,L
	jruc	reset_puck_position

puck_init
	.long	puck1
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PUCK
	.long	[0,0],[0,0],[339,08000h]		;x,y,z

puck_shadow_init
	.long	puck1
	.word	DMAWNZ,0
	.word	OM_OID|OM_INSERT
	.word	OID_PUCK_SHADOW

reset_puck_position
	callr	turn_puck_off
	clr	a14
	move	a14,*a8(OYACCEL),W
	move	a14,*a8(OYVEL),L
	move	a14,*a8(OYVAL),L
	move	a14,*a8(OXVEL),L
	move	a14,*a8(OXVAL),L
	move	a14,*a8(OZVEL),L
	move	a14,*a8(ODT_VEL),L
	move	a14,*a8(ODT_DIR),L
	move	a14,@PUCK_CONTROL,W
	move	a14,@PUCK_LAST_CONTROL,W
	move	a14,@NO_PUCK_SLOW,W
	move	a14,@PUCK_OPEN_CONTROL_TIME,W
	move	a14,@PUCK_OPEN_LAST_TIME,W
	move	a14,@PUCK_MODE_2,W
	move	a14,@PUCK_M2_TIME,W
	movi	[339,08000h],a14
	move	a14,*a8(OZVAL),L
	move	a14,@last_puck_xz,L	;
	clr	a14			;	store z:x into last puck
	move	a14,@last_puck_xz,W	;
	move	a14,@puck_allowed_state,W
	;
turn_puck_on
	move	@PUCK_OBJECT,a8,L
	move	*a8(OCTRL),a14,W
	ori	DMAGO,a14
	move	a14,*a8(OCTRL),W
	rets

turn_puck_off
	move	@PUCK_SHADOW,a8,L
	move	*a8(OCTRL),a14,W
	andni	DMAGO,a14
	move	a14,*a8(OCTRL),W
	move	@PUCK_OBJECT,a8,L
	move	*a8(OCTRL),a14,W
	andni	DMAGO,a14
	move	a14,*a8(OCTRL),W
	rets
**************************************************************************
*								         *
* NOTE: all puck angles are in the range 0 - 2pi			 *
*								         *
**************************************************************************

**************************************************************************
*								         *
* send_puck_to_player							 *
* 	input	a0 = player number to send to				 *
* 		a7 = velocity to send to puck				 *
* 	 unused	a10= maximum velocity given to puck (from player block)	 *
* 		b6 = routine to modify angle (error)			 *
* 	 we iterate three times through a formula to get direction	 *
* 	 based on how destination player is moving			 *
* 	 to come up with a reasonably close approximation of		 *
* 	 where we want to send the puck to. then we adjust our speed	 *
* 	 to get where we want to go anyway				 *
* 	output	a10 = distance to player				 *
*								         *
**************************************************************************
send_puck_to_player
	calla	get_players_puck_point
	move	a0,b1
	move	a1,a11
	move	@PUCK_OBJECT,a9,L
	move	*a9(OXVAL),a2,L
	move	*a9(OZVAL),a3,L
	movk	3,b0
lloi	callr	find_time_to_get_to_point
	move	b1,a0
	move	a11,a1
	move	*a8(OXVEL),a5,L
	mpys	a4,a5
	add	a5,a0
	move	*a8(OZVEL),a5,L
	mpys	a4,a5
	add	a5,a1
	dsjs	b0,lloi
	move	a4,a5
	srl	1,a5			;let the puck travel 3/4 the distance
	move	a4,a7
	srl	2,a7
	add	a7,a5
	move	a5,@NO_PUCK_SLOW,W	;to the player uninhibited
	move	a4,a7
	addk	30,a7			;1/2 second after we were supposed to catch it
	move	a7,@PUCK_OPEN_CONTROL_TIME,W	;make it anybody's puck
	move	a7,@PUCK_OPEN_LAST_TIME,W	;make it anybody's puck
	srl	16,a2
	movy	a3,a2		;puck position
	srl	16,a0
	move	a0,a3
	movy	a1,a3
	calla	SLINEVEL
	move	a1,a0
	move	a2,a1
	move	a9,a8
	calla	rect_to_polar
	call	b6		;modify angle
	calla	set_obj_to_polar
	jauc	puck_slide_sound

**************************************************************************
*								         *
* send_puck_to_point_xyz						 *
* 	send puck to point x,z (with y velocity				 *
* 	gives puck up velocity and gravity if necessary			 *
*      input	a0 = x							 *
* 		a1 = z							 *
* 		a2 = y							 *
* 		a7 = velocity to give to puck				 *
* 		a10= maximum velocity given to puck (from player block)	 *
* 		b6 = routine to modify angle (error)			 *
*								         *
**************************************************************************

send_puck_to_point_xyz
	move	a2,b2
	move	@PUCK_OBJECT,a9,L
	move	*a9(OXVAL),a2,L
	move	*a9(OZVAL),a3,L
	calla	find_dirdis_to_point
	move	a1,b1
	move	a7,a1
	move	a9,a8
	move	a1,b3
	call	b6			;call routine to modify direction
	move	a1,b3		;save velocity
	calla	set_obj_to_polar
	move	b2,b2		;test y position
	jrnn	sptp9
	callr	give_puck_gravity
	move	b1,a3		;distance
	move	b3,a1		;velocity
	move	b2,a2		;yp position
	calla	get_correct_y_velocity
	neg	a10
	cmp	a10,a3
	jrge	sptp6
	move	a10,a3
sptp6	move	a3,*a8(OYVEL),L
sptp9	jauc	puck_slide_sound

**************************************************************************
*								         *
* put_puck_in_other_direction						 *
* 	for when someone contacts puck, but does not control it		 *
* 	it will bounce in somewhat the opposite direction from		 *
* 	the way it is heading						 *
* 	input	a8 = puck object					 *
* 		a1 = speed to bounce puck away at			 *
* 	trashes	b1,a0,a1						 *
*								         *
**************************************************************************
put_puck_in_other_direction
	move	a1,b1
	move	*a8(ODT_DIR),a0,L
	addi	XD1800,a0
	move	a0,a1
	addi	XD0250,a1
	subi	XD0250,a0
	calla	RANGERND
	move	b1,a1
	calla	set_obj_to_polar
	move	*a8(OYVEL),a0,L
	move	a0,a1
	addi	[1,08000h],a0
	subi	[1,08000h],a1
	calla	RANGERND
	move	a0,*a8(OYVEL),L
	callr	give_puck_gravity
	jauc	puck_slide_sound

**************************************************************************
*								         *
* find_time_to_get_to_point						 *
* 	input	a0 = point 2 x						 *
* 		a1 = point 2 z						 *
* 		a2 = point 1 x						 *
* 		a3 = point 1 z						 *
* 		a7 = velocity of puck					 *
* 	output	a4 = time to get there					 *
* 		a10 = distance to point					 *
*								         *
**************************************************************************
find_time_to_get_to_point
	calla	find_dis_to_point_whole
	move	a4,a10
	clr	a5
	divu	a7,a4
	srl	16,a4
	rets

**************************************************************************
*								         *
* bounce_puck								 *
* bounce_puck_corner							 *
* 	bounces puck off of a wall at angle a2				 *
* input a2= angle to bounce puck off					 *
*       a8= puck object							 *
*  in puck object ODATA= puck angle, ODATA+020H= puck velocity		 *
* trashes a bunch of registers						 *
*								         *
**************************************************************************
gbounce_puck_corner
	move	a8,a6				;set a6 to non-zero
	jruc	gbp1
gbounce_puck
	clr	a6
gbp1	mmtm	sp,a9
	move	*a8(ODT_DIR),a1,L			;get angle
	callr	compute_bounce_angle
	jrnc	bp9				;br= no collision, done
	move	a3,a5				;save for sign bit for later
	abs	a3				;make it 0-90 degrees
	subi	XD0900,a3
	neg	a3				;now it is delta from parallel to surface
	calla	puck_goal_sound
	jruc	bp21

bounce_puck_corner
	move	a8,a6				;set a6 to non-zero
	jruc	bp1
bounce_puck
	clr	a6
bp1	mmtm	sp,a9
	move	*a8(ODT_DIR),a1,L			;get angle
	callr	compute_bounce_angle
	jrnc	bp9				;br= no collision, done
	move	a3,a5				;save for sign bit for later
	abs	a3				;make it 0-90 degrees
	subi	XD0900,a3
	neg	a3				;now it is delta from parallel to surface
	move	a6,a6
	jrz	bp_19
	calla	puck_board_corner_sound
	jruc	bp21
bp_19	calla	puck_board_sound
bp21	move	a3,a9				;save it for use later
	callr	compute_velocity_change
	callr	compute_angle_change
	mpys	a3,a0				;multiply angle change by angle
	sll	16,a0
	srl	16,a1
	movx	a1,a0
	subi	XD0900,a0			;change it back to angle from normal
	move	a5,a5				;check sign of original angle
	jrn	bp2				;br= original was negative so minus is ok
	neg	a0				;correct if original was positive
bp2	add	a2,a0				;add it to normal to surface
	THETA_N	a0
	move	a0,*a8(ODT_DIR),L			;store in angle
	move	a0,a2				;save for polar to rect conversion
	move	*a8(ODT_VEL),a2,L			;get velocity
	move	a2,a5
	mpys	a4,a2				;multiply velocity change by velocity
	sll	16,a2
	srl	16,a3
	movx	a3,a2
	sub	a2,a5			;a5 is how much we lost
	move	a2,*a8(ODT_VEL),L			;store in velocity
	move	*a8(OYPOS),a14,W		;get y of puck
	jrnn	xx1				;br= puck on ground
	abs	a9				;make difference absolute
	cmpi	XD0150,a9			;if angle to wall is < 15 degrees
	jrls	xx1				;then we don't add a random amount.
	move	a0,a1			;puck in air, give it
	movi	XD0150,a14		;+/- 15 degrees
	sub	a14,a0
	add	a14,a1
	calla	RANGERND
	move	a0,a0
	jrnn	xx1
	addi	XD3600,a0
xx1	move	a2,a1				;now move vel to correct reg for ptor
	calla	polar_to_rect
	move	a0,*a8(OXVEL),L
	move	a1,*a8(OZVEL),L
	move	*a8(OYVEL),a0,L
	jrnz	bp9
	clr	a1
	neg	a5
	sra	2,a5
	move	a5,a0
	calla	RANGERND
	cmpi	-4000h,a0
	jrhs	bp9
	move	a0,*a8(OYVEL),L
	callr	give_puck_gravity
bp9	mmfm	sp,a9
	rets

compute_velocity_change
	move	a3,a0				;get angle to correct reg
	calla	GETCOS				;velocity change is
	sra	1,a0				; ((cos(angle))/2 + .5)^2
	move	*a8(OYPOS),a1,W		;check if puck is in air
	jrnn	cvc_1			;br= puck on ground
	subi	[0,00800h],a0		;if puck in air, make it + 15/32 instead of 1/2
cvc_1	addi	[0,08000h],a0
	move	a0,a1
	calla	SQUARE
	move	a1,a4
	rets

compute_angle_change
	move	a6,a6
	jrnz	cac_c				;br=puck in corner
	cmpi	XD0400,a3
	jrlt	caclo
	move	a3,a0
	calla	GETSIN				;for angles > 40
	move	a0,a1				; amount sin^2
	calla	SQUARE
	move	a1,a0
	rets
cac_c	cmpi	XD0570,a3
	jrlt	caclo
	move	a3,a0
	calla	GETCOS				;for angles > 57
	neg	a0				; amount is 1-cos
	addi	[1,0],a0
	rets
caclo	move	a3,a0
	calla	GETSIN
	move	a0,a1
	calla	SQUARE_ROOT			;for angles < 57 (or 40)
	sra	1,a1				; amount (sin^.5)/2
	move	a1,a0
	rets

**************************************************************************
*								         *
* compute_bounce_angle: computes the angle of reflection of the puck	 *
* 			 bouncing off of a surface			 *
* 	input:	a1 = puck angle						 *
* 		a2 = normal to surface					 *
* 	output: CC = no collision					 *
* 		  a3 = garbage						 *
* 		CS = collision						 *
* 		  a3 = amount to add to a2 to get reflection angle	 *
*								         *
**************************************************************************
compute_bounce_angle
	THETA_N	a1
	move	a2,a3
	sub	a1,a3
	addi	XD1800,a3
	THETA_N	a3
	cmpi	XD0900,a3
	jrlt	cba_ok
	cmpi	XD2700,a3
	jrle	cba_nok
	subi	XD3600,a3
cba_ok	setc
	rets
cba_nok	clrc
	rets

slow_puck_down
	move	@PUCK_OBJECT,a8,L
	move	*a8(ODT_VEL),a0,L		;velocity
	lmo	a0,a1
	sll	4,a1
	addi	spd_friction,a1
	move	*a1,a2,W
	jrz	spd_stop
	sll	16,a2
	srl	16,a2
	mpys	a2,a0
	sll	16,a0
	srl	16,a1
	movx	a1,a0
	move	a0,*a8(ODT_VEL),L
	move	*a8(OXVEL),a0,L		;velocity
	mpys	a2,a0
	sll	16,a0
	srl	16,a1
	movx	a1,a0
	move	a0,*a8(OXVEL),L
	move	*a8(OZVEL),a0,L		;velocity
	mpys	a2,a0
	sll	16,a0
	srl	16,a1
	movx	a1,a0
	move	a0,*a8(OZVEL),L
	rets

spd_friction
	.word	0		;lmo = 31	80000000-ffffffff, 0
	.word	0ff80h		;lmo = 30	40000000-7fffffff
	.word	0ff80h		;lmo = 29	20000000-3fffffff
	.word	0ff74h		;lmo = 28	10000000-1fffffff
	.word	0ff70h		;lmo = 27	08000000-0fffffff
	.word	0ff6ch		;lmo = 26	04000000-07ffffff
	.word	0ff60h		;lmo = 25	02000000-03ffffff
	.word	0ff50h		;lmo = 24	01000000-01ffffff
	.word	0ff28h		;lmo = 23	00800000-00ffffff
	.word	0ff10h		;lmo = 22	00400000-007fffff
	.word	0fef8h		;lmo = 21	00200000-003fffff
	.word	0fee0h		;lmo = 20	00100000-001fffff
	.word	0fe70h		;lmo = 19	00080000-000fffff
	.word	0fe00h		;lmo = 18	00040000-0007ffff
	.word	0fce0h		;lmo = 17	00020000-0003ffff
	.word	0fa78h		;lmo = 16	00010000-0001ffff
	.word	0fa68h		;lmo = 15	00008000-0000ffff
	.word	0fa68h		;lmo = 14	00004000-00007fff
	.word	0    		;lmo = 13	00002000-00003fff
	.word	0    		;lmo = 12	00001000-00001fff
	.word	0    		;lmo = 11	00000800-00000fff
	.word	0    		;lmo = 10	00000400-000007ff
	.word	0    		;lmo = 9	00000200-000003ff
	.word	0    		;lmo = 8	00000100-000001ff
	.word	0    		;lmo = 7	00000080-000000ff
	.word	0    		;lmo = 6	00000040-0000007f
	.word	0    		;lmo = 5	00000020-0000003f
	.word	0    		;lmo = 4	00000010-0000001f
	.word	0    		;lmo = 3	00000008-0000000f
	.word	0    		;lmo = 2	00000004-00000007
	.word	0    		;lmo = 1	00000002-00000003
	.word	0    		;lmo = 0	00000000-00000001

spd_stop
	clr	a1
	move	a1,@PUCK_MODE_2,W
	move	@PUCK_MODE,a14,W
	cmpi	99,a14
	jrhs	sptr			;if we can't control it, we still can't
	move	a1,@PUCK_MODE,W
sptr	jauc	set_obj_to_polar

**************************************************************************
*								         *
* puck_rink_check							 *
* 	this is a mechanism for checking puck collisions with		 *
* 	the physical properties of the rink. (ie walls and goal areas)	 *
* 	it runs through a table of check values, forking into the	 *
* 	corresponding routine for further analysis.  This is to speed	 *
* 	up the majority of checks, where no collision occurs		 *
*								         *
**************************************************************************
puck_rink_check
	move	@PUCK_OBJECT,a8,L
	move	*a8(OYVAL),a14,L		;no get pos
	jrz	prcx1
	jrn	prc22			;br= we are above ground, don't worry
	move	*a8(OYVEL),a0,L
	jrz	prc22			;br= we are not going down yet, don't worry
	jrn	prc22			;br= we are going up, don't worry about it
	callr	puck_hits_ground
	jruc	prc22
prcx1	callr	puck_on_ground
prc22 	callr	set_puck_script
	callr	set_puck_shadow
	move	@trigger_puck_sound,a14,W
	jrz	prc_ns
	clr	a14
	move	a14,@trigger_puck_sound,W
	calla	puck_slide_sound
prc_ns

	move	*a8(OXPOS),a0,W
	move	*a8(OZPOS),a1,W
	sll	16,a1
	movy	a1,a0			;a0 = [z,x] of puck
	movi	rink_check_table,a6
prc_1	mmfm	a6,a1,a2,a3		;a3 = lowerleft, a2 = upperright, a1 = address
	addi	[1,1],a2		;sub 1 pixel over so we check like xge, yge
	move	a3,a3
	jrz	prc_err			;we hit end of table, something is wrong
	cmpxy	a3,a0
	jryle	prc_1			;br= outside lower
	jrxle	prc_1			;br= outside left
	cmpxy	a2,a0
	jrygt	prc_1			;br= outside top
	jrxgt	prc_1			;br= outside right
	jump	a1			;go to address for further checks

prc_err	LOCKUP			;we hit end of table without match

puck_on_ground
	move	@PUCK_MODE_2,a0,W
	jrz	pog_9
	move	@PUCK_M2_TIME,a14,W
	inc	a14
	move	a14,@PUCK_M2_TIME,W
	cmpi	30,a14
	jrls	pog_9
	clr	a14
	move	a14,@PUCK_MODE_2,W
pog_9	rets

puck_hits_ground
	move	*a8(OYVEL),a1,L
	calla	puck_drop_sound
	cmpi	[1,0],a1
	jrls	phg1
	calla	RANDOM
	sll	30,a0
	srl	25,a0
	addi	phglist,a0
	move	*a0,a0,L
	jump	a0
phglist	.long	phg1
	.long	phg2
	.long	phg3
	.long	phg4
phg2	sra	1,a1
	neg	a1
	move	a1,*a8(OYVEL),L
	rets
phg3	move	a1,a14
	sra	2,a1
	sra	3,a14
	add	a14,a1
	neg	a1
	move	a1,*a8(OYVEL),L
	rets
phg4	sra	2,a1
	neg	a1
	move	a1,*a8(OYVEL),L
	rets
phg1	cmpi	[3,0],a1
	jrhs	phg2			;if it is really fast, it must bounce
	movk	1,a0
	move	a0,@PUCK_MODE_2
	clr	a0
	move	a0,@PUCK_M2_TIME,W
	move	a0,*a8(OYACCEL),W	;clear out all y
	move	a0,*a8(OYVEL),L
	move	a0,*a8(OYVAL),L
	rets

give_puck_gravity	;a8 = puck
	movi	[0,3000h],a14		;if we change this, change y position routines to match
	move	a14,*a8(OYACCEL),W
	rets

set_puck_script
	clr	a0
	move	@PUCK_CONTROL,a1,W
	jrnz	sps8
	movk	1,a0
	move	@PUCK_OBJECT,a8,L
	move	*a8(OYPOS),a1,W
	jrnz	sps8
	move	@PUCK_MODE_2,a0,W
sps8	sll	5,a0
	addi	spssl,a0
	move	*a0,a0,L
	jump	a0
spssl	.long	set_flat_puck_script
	.long	set_flop_puck_script
	.long	set_roll_puck_script

set_flat_puck_script
	movi	anim_flat_puck,a1
	jauc	start_anim_if_not
set_flop_puck_script
	movi	anim_flop_puck,a1
	jauc	start_anim_if_not
set_roll_puck_script
	movi	anim_roll_puck,a1
	jauc	start_anim_if_not

anim_flat_puck
	LW	puck1,25
	.long	0
anim_flop_puck
	LW	puck1a,3
	LW	puck1c,3
	LW	puck1b,3
	LW	puck1d,3
	.long	0
anim_roll_puck
	LW	puck1,25
	.long	0

set_puck_shadow
	move	*a8(OYVAL),a0,L
	jrn	puck_shadow_on
puck_shadow_off
	move	@PUCK_SHADOW,a0,L
	move	*a0(OCTRL),a14,W
	andni	DMAGO,a14
	move	a14,*a0(OCTRL),W
	clr	a14
	move	a14,*a0(OXVEL),L
	move	a14,*a0(OZVEL),L
	clr	a14
	move	a14,*a0(OYACCEL),W
	move	a14,*a0(OYVEL),L
	rets
puck_shadow_on
	move	@PUCK_SHADOW,a0,L
	move	*a0(OCTRL),a14,W
	ori	DMAWNZ,a14
	move	a14,*a0(OCTRL),W
	move	*a8(OXVAL),*a0(OXVAL),L
	move	*a8(OZVAL),a14,L
	inc	a14
	move	a14,*a0(OZVAL),L
	move	*a8(OXVEL),*a0(OXVEL),L
	move	*a8(OZVEL),*a0(OZVEL),L
	clr	a14
	move	a14,*a0(OYACCEL),W
	move	a14,*a0(OYVEL),L
	move	a14,*a0(OYVAL),L
	rets

**************************************************************************
*								         *
* r_stick_and_bounce							 *
* 	input	a8 = puck object					 *
* 		a2 = angle to bounce off				 *
* 		a0 = z:x of puck					 *
*								         *
**************************************************************************
r_stick_or_nostick_bounce
	move	*a8(ODT_DIR),a14,L
	sub	a2,a14
	abs	a14
	THETA_N	a14
	cmpi	XD0800,a14
	jrls	r_stick_and_bounce
	cmpi	(XD3600-XD0800),a14
	jrlo	r_nostick_and_bounce
r_stick_and_bounce
	move	*a8(OFLAGS),a14,W	;
	ori	M_FVELADD,a14		; makes puck stick one veladd
	move	a14,*a8(OFLAGS),W	;
r_nostick_and_bounce
	move	a0,*a8(OXPOS),W
	sra	16,a0
	move	a0,*a8(OZPOS),W
	jruc	bounce_puck

r_no_coll
	move	*a8(OXPOS),a0,W
	move	a0,@last_puck_xz,W
	move	*a8(OZPOS),a0,W
	move	a0,@last_puck_xz+16,W
	clr	a0
	move	a0,@puck_allowed_state,W
	move	a0,@last_corner_vel,L
	rets

r_horizontal_wall
	move	*a8(OXPOS),a1,W
	move	*a8(OZPOS),a0,W
	cmpi	677,a0
	jrle	rhw_b
	movi	[677,0],a0
	movx	a1,a0
	movi	XD2700,a2
	jruc	r_stick_or_nostick_bounce
rhw_b	cmpi	2,a0
	jrge	rhw_9
	movi	[2,0],a0
	movx	a1,a0
	movi	XD0900,a2
	jruc	r_stick_or_nostick_bounce
rhw_9	rets

pcr_tab	.long	XD1800
	.long	0
	.long	XD2700
	.long	XD0900

pco_tab	.long	0
	.long	XD1800
	.long	XD0900
	.long	XD2700

**************************************************************************
*								         *
* r_lgoal_check								 *
* r_rgoal_check these routines check our point and our anticipated	 *
* 	      point for intersection with goal				 *
*								         *
**************************************************************************
r_lgoal_check
	callr	get_in_out
	sll	5,a4
	addi	rlj_tab,a4
	move	*a4,a4,L
	jump	a4
rlj_tab	.long	l_safety_outside
	.long	l_bounce_inside
	.long	l_bounce_outside
	.long	l_safety_inside

l_safety_inside
	rets
l_safety_outside			;puck is outside goal, do a safety check.
	rets
l_bounce_inside
	clr	a3
	movy	a1,a3		;a3 = point 2 z
	movx	a1,a2
	sll	16,a2		;a2 = point 2 x
	cmpi	[-730,0],a2
	jrlo	lbi_clw			;check intersection on left wall
	cmpi	[-688,0],a2
	jrhi	lbi_crw			;check intersection on right wall
	cmpi	[339,0],a3
	jrhi	lbi_ct			;check top curve
	jruc	lbi_cb			;check bottom curve
lbi_clw	movi	-730,a2
	callr	get_z_from_x_midpoint
	cmpi	[376,0],a2
	jrhi	lbi_ct		;intersection is on top curve
	cmpi	[303,0],a2
	jrlo	lbi_cb		;intersection is on bottom curve
	clr	a2
	jruc	goal_bounce_wall_inside
lbi_crw	movi	-688,a2
	callr	get_z_from_x_midpoint
	cmpi	[392,0],a2
	jrhi	lbi_ct		;intersection is on top curve
	cmpi	[287,0],a2
	jrlo	lbi_cb		;intersection is on bottom curve
	clr	a14
	move	a14,@puck_allowed_state,W
	rets			;puck is exiting at opening, ok
lbi_ct	movi	[376,0],a7
	jruc	lbicbt
lbi_cb	movi	[303,0],a7
lbicbt	movx	a1,a2		;we use point 2, we might want point 1
	sll	16,a2
	clr	a3
	movy	a1,a3
	movi	[-706,0],a0
	move	a7,a1
	jruc	goal_bounce_corner_end_inside

l_bounce_outside
	clr	a3
	movy	a0,a3		;a3 = point 1 z
	movx	a0,a2
	sll	16,a2		;a2 = point 1 x
	cmpi	[-730,0],a2
	jrlo	lbo_clw			;check intersection on left wall
	cmpi	[-688,0],a2
	jrhi	lbo_crw			;check intersection on right wall
	cmpi	[339,0],a3
	jrhi	lbo_ct			;check top curve
	jruc	lbo_cb			;check bottom curve
lbo_clw	movi	-730,a2
	callr	get_z_from_x_midpoint
	cmpi	[376,0],a2
	jrhi	lbo_ct		;intersection is on top curve
	cmpi	[303,0],a2
	jrlo	lbo_cb		;intersection is on bottom curve
	movi	XD1800,a2
	jruc	goal_bounce_wall_outside
lbo_crw	movi	-688,a2
	callr	get_z_from_x_midpoint
	cmpi	[392,0],a2
	jrhi	lbo_ct		;intersection is on top curve
	cmpi	[287,0],a2
	jrlo	lbo_cb		;intersection is on bottom curve
	move	@PUCK_CONTROL,a0,W
	jrnz	lbo_999
	move	@GAME_STATE,a14,W
	cmpi	INPLAY,a14
	jaz	score_right_team ;puck is entering at opening, score
lbo_999	rets			;no goal, period over
lbo_ct	movi	[376,0],a3
	jruc	lbocbt
lbo_cb	movi	[303,0],a3

lbocbt	movx	a1,a0		;we use point 2, we might want point 1
	sll	16,a0
	srl	16,a1
	sll	16,a1
	movi	[-706,0],a2
	jruc	goal_bounce_corner_end_outside

r_rgoal_check
	callr	get_in_out
	sll	5,a4
	addi	rrj_tab,a4
	move	*a4,a4,L
	jump	a4
rrj_tab	.long	r_safety_outside
	.long	r_bounce_inside
	.long	r_bounce_outside
	.long	r_safety_inside

r_safety_inside
	rets
r_safety_outside			;puck is outside goal, do a safety check.
	rets
r_bounce_inside
	clr	a3
	movy	a1,a3		;a3 = point 2 z
	movx	a1,a2
	sll	16,a2		;a2 = point 2 x
	cmpi	[730,0],a2
	jrhi	rbi_crw			;check intersection on left wall
	cmpi	[688,0],a2
	jrlo	rbi_clw			;check intersection on right wall
	cmpi	[339,0],a3
	jrhi	rbi_ct			;check top curve
	jruc	rbi_cb			;check bottom curve
rbi_crw	movi	730,a2
	callr	get_z_from_x_midpoint
	cmpi	[376,0],a2
	jrhi	rbi_ct		;intersection is on top curve
	cmpi	[303,0],a2
	jrlo	rbi_cb		;intersection is on bottom curve
	movi	XD1800,a2
	jruc	goal_bounce_wall_inside
rbi_clw	movi	688,a2
	callr	get_z_from_x_midpoint
	cmpi	[392,0],a2
	jrhi	rbi_ct		;intersection is on top curve
	cmpi	[287,0],a2
	jrlo	rbi_cb		;intersection is on bottom curve
	clr	a14
	move	a14,@puck_allowed_state,W
	rets			;puck is exiting at opening, ok
rbi_ct	movi	[376,0],a7
	jruc	rbicbt
rbi_cb	movi	[303,0],a7
rbicbt	movx	a1,a2		;we use point 2, we might want point 1
	sll	16,a2
	clr	a3
	movy	a1,a3
	movi	[706,0],a0
	move	a7,a1
	jruc	goal_bounce_corner_end_inside

r_bounce_outside
	clr	a3
	movy	a0,a3		;a3 = point 1 z
	movx	a0,a2
	sll	16,a2		;a2 = point 1 x
	cmpi	[730,0],a2
	jrhi	rbo_crw			;check intersection on left wall
	cmpi	[688,0],a2
	jrlo	rbo_clw			;check intersection on right wall
	cmpi	[339,0],a3
	jrhi	rbo_ct			;check top curve
	jruc	rbo_cb			;check bottom curve
rbo_crw	movi	730,a2
	callr	get_z_from_x_midpoint
	cmpi	[376,0],a2
	jrhi	rbo_ct		;intersection is on top curve
	cmpi	[303,0],a2
	jrlo	rbo_cb		;intersection is on bottom curve
	clr	a2
	jruc	goal_bounce_wall_outside
rbo_clw	movi	688,a2
	callr	get_z_from_x_midpoint
	cmpi	[392,0],a2
	jrhi	rbo_ct		;intersection is on top curve
	cmpi	[287,0],a2
	jrlo	rbo_cb		;intersection is on bottom curve
	move	@PUCK_CONTROL,a0,W
	jrnz	rbo_999
	move	@GAME_STATE,a14,W
	cmpi	INPLAY,a14
	jaz	score_left_team ;puck is entering at opening, score
rbo_999	rets			;no goal, period over
rbo_ct	movi	[376,0],a3
	jruc	rbocbt
rbo_cb	movi	[303,0],a3
rbocbt	movx	a1,a0		;we use point 2, we might want point 1
	sll	16,a0
	srl	16,a1
	sll	16,a1
	movi	[706,0],a2
	;
goal_bounce_corner_end_outside
	move	*a8(OYPOS),a14,W
	jrn	gbce0
	calla	find_dir_to_point
	move	a0,a2
	jruc	gbounce_puck_corner
goal_bounce_corner_end_inside
gbce0	calla	find_dir_to_point
	move	a0,a2
	callr	gbounce_puck_corner
gbce2	move	*a8(ODT_VEL),a1,L
	cmpi	[2,0000h],a1
	jrls	gbce1
	movi	[2,0000h],a1
	move	*a8(ODT_DIR),a0,L
	jauc	set_obj_to_polar
gbce1	rets

goal_bounce_wall_outside
	move	*a8(OYPOS),a14,W
	jrn	gbw0
	jruc	gbounce_puck
goal_bounce_wall_inside
gbw0	callr	gbounce_puck
	jruc	gbce2

**************************************************************************
*								         *
* get_in_out								 *
* 	input  a8 = object						 *
* 	output a0 = zx of point 1					 *
* 	       a1 = zx of point 2					 *
* 	       a4 = 00 - is outside, will be outside			 *
* 	            01 - is inside, will be outside			 *
* 	            10 - is outside, will be inside			 *
* 	            11 - is inside, will be inside			 *
*								         *
**************************************************************************
get_in_out
	move	*a8(OXPOS),a2,W
	move	*a8(OZPOS),a14,W
	sll	16,a14
	movy	a14,a2
	clr	a4
	callr	are_we_inside_goal
	jrnc	gio2
	inc	a4
gio2	move	@puck_allowed_state,a3,W
	cmp	a4,a3
	jrnz	gio_d
	move	*a8(OXVAL),a2,L
	move	*a8(OXVEL),a14,L
	add	a14,a2
	move	*a8(OZVAL),a4,L
	move	*a8(OZVEL),a14,L
	add	a4,a14
	srl	16,a2
	movy	a14,a2
	clr	a4
	callr	are_we_inside_goal
	jrnc	gio_d
	inc	a4
gio_d	move	a2,a1
	sll	1,a4
	add	a3,a4
	move	@last_puck_xz,a0,L
	rets

**************************************************************************
*								         *
* get_z_from_x_midpoint							 *
* 	input	a0 = z:x of first point					 *
* 		a1 = z:x of second point				 *
* 		a2 = x between a0 and a1				 *
* 	output	a2 = z:x of line intersecting a0-a1 and x = a2		 *
*								         *
**************************************************************************
get_z_from_x_midpoint
	mmtm	sp,a0,a1,a3,a4
	move	a0,a3
	move	a2,a14
	move	a1,a4
	sll	16,a3
	sll	16,a4
	sll	16,a2
	sub	a3,a4	;pt2 - pt 1
	sub	a3,a2	;xn - pt 1
	sra	16,a2
	clr	a3
	divs	a4,a2	;a2 = (x - pt1) / (pt2 - pt1)
	srl	16,a0
	sll	16,a0
	srl	16,a1
	sll	16,a1
	sub	a0,a1
	mpys	a1,a2
	sll	16,a2
	add	a0,a2
	movx	a14,a2
	mmfm	sp,a0,a1,a3,a4
	rets

**************************************************************************
*								         *
* get_x_from_z_midpoint							 *
* 	input	a0 = z:x of first point					 *
* 		a1 = z:x of second point				 *
* 		a2 = x between a0 and a1				 *
* 	output	a2 = z:x of line intersecting a0-a1 and x = a2		 *
*								         *
**************************************************************************
get_x_from_z_midpoint
	mmtm	sp,a0,a1,a3,a4
	move	a0,a3
	move	a1,a4
	srl	16,a3
	sll	16,a3
	srl	16,a4
	sll	16,a4
	sll	16,a2
	move	a2,a14
	sub	a3,a4	;pt2 - pt 1
	sub	a3,a2	;zn - pt 1
	sra	16,a2
	clr	a3
	divs	a4,a2	;a2 = (x - pt1) / (pt2 - pt1)
	sll	16,a0
	sll	16,a1
	sub	a0,a1
	mpys	a1,a2
	sll	16,a2
	add	a0,a2
	srl	16,a2
	movy	a14,a2
	mmfm	sp,a0,a1,a3,a4
	rets

are_we_inside_goal	;a2 = z:x pos
	mmtm	sp,a0,a1,a2,a3,a4
	clr	a3
	movy	a2,a3
	abs	a3
	sll	16,a2
	abs	a2		;a2 = x, a3 = z
	cmpi	[730,0],a2
	jrhi	awig_outside
	cmpi	[688,0],a2
	jrlo	awig_outside
	cmpi	[400,0],a3
	jrhi	awig_outside
	cmpi	[279,0],a3
	jrlo	awig_outside
	cmpi	[376,0],a3
	jrhi	awg_tt		;test top
	cmpi	[303,0],a3
	jrhs	awig_inside
awg_tb	movi	[303,0],a1
	jruc	awg_ttb
awg_tt	movi	[376,0],a1
awg_ttb	movi	[706,0],a0
	calla	find_dsquared_to_point_whole
	cmpi	576,a4		;24 * 24
	jrls	awig_inside
awig_outside
	clrc
	mmfm	sp,a0,a1,a2,a3,a4
	rets
awig_inside
	setc
	mmfm	sp,a0,a1,a2,a3,a4
	rets

r_vertical_wall
	move	*a8(OZPOS),a1,W
	sll	16,a1
	move	*a8(OXPOS),a0,W
	jrn	rvwl
	cmpi	796,a0
	jrle	rvw_x
	movi	796,a0
	movy	a1,a0
	movi	XD1800,a2
	jruc	r_stick_or_nostick_bounce
rvwl	cmpi	-796,a0
	jrge	rvw_x
	movi	-796,a0
	movy	a1,a0
	clr	a2
	jruc	r_stick_or_nostick_bounce
rvw_x	rets

r_corner_check
	movi	[1,0],a4
	move	*a8(OXPOS),a0,W
	jrn	rcc_l
	move	*a8(OZPOS),a0,W
	cmpi	340,a0
	jrgt	rcc_ur
rcc_lr	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	movi	[798-radius,0],a0
	movi	[radius,0],a1
	jruc	rcc_fc
rcc_ur	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	movi	[798-radius,0],a0
	movi	[679-radius,0],a1
	jruc	rcc_fc
rcc_l	move	*a8(OZPOS),a0,W
	cmpi	340,a0
	jrgt	rcc_ul
rcc_ll	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	movi	[-798+radius,0],a0
	movi	[radius,0],a1
	jruc	rcc_fc
rcc_ul	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	movi	[-798+radius,0],a0
	movi	[679-radius,0],a1
rcc_fc	move	a0,a4
	move	a1,a5
	calla	find_dsquared_to_point_whole_a1
	cmpi	(radius-4)*(radius-4),a1		;is it closer than radius-4
	jrlo	rcc_nfd
	move	a5,a1
	calla	find_dir_to_point
	movi	[radius-4,0],a1
	move	a0,a2
	calla	polar_to_rect
	sub	a0,a4
	sub	a1,a5
	move	a4,*a8(OXVAL),L
	move	a5,*a8(OZVAL),L
	jruc	bounce_puck_corner
rcc_nfd	rets

**************************************************************************
*								         *
* rink_check_table							 *
* 	table in format .long	bottom_left,upper_right,routine		 *
*								         *
**************************************************************************
rink_check_table
	.long	[245,-774],[430,-645],r_lgoal_check
	.long	[245,645],[430,774],r_rgoal_check
	.long	[10,-798+radius],[669,798-radius],r_no_coll
	.long	[-50,-798+radius],[800,798-radius],r_horizontal_wall
	.long	[72,-682],[608,682],r_no_coll
	.long	[radius,-788],[679-radius,788],r_no_coll
	.long	[radius,-900],[679-radius,900],r_vertical_wall
	.long	[-50,-900],[800,900],r_corner_check
	.long	0,0,0					;end of table

