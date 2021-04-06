	.MLIB	"HHMACS.LIB"
	.FILE	"HHCONTR2.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"HHCONTR2.TBL"
	.include	"hhcontr2.e"
	.include	"hhd.g"
	.include	"hhmisc.g"
	.include	"hhproc.g"
	.include	"hhc.g"
	.include	"hhpuck.g"
	.include	"hhram.g"
	.include	"hhpall.g"
	.include	"hhgame.g"
	.include	"hhplayer.g"
	.include	"hhndrone.g"
	.include	"hhcontrl.g"
	.include	"hhutil.g"
	.include	"hhscr_ch.g"
	.include	"hhscr_sk.g"
	.include	"hhmath.g"
	.include	"hhtimer.g"
	.include	"hhscore.g"
	.include	"hhtext.g"
	.include	"hhcmos.g"
	.include	"hhstabl2.g"
	.include	"hhscr_fn.g"
	.include	"hhpick.g"
	.include	"hhfade.g"
	.include	"hhselect.g"
	.include	"hhsnd.g"
	.include	"hhshow.g"
	.include	"hhafunc.g"
	.include	"hhpup.g"
	.include	"hhscrchf.g"

; end of include files

	.TEXT
	.EVEN

	.bss	global_shot_percentage,16
	.bss	global_drone_cstate,16
	.bss	puck_ctrl_object,32
	.bss	time_score_left,32	;easier
	.bss	time_score_right,32	;easier
	.bss	puck_control_new,16	;puck has recently changed, flash top
	.bss	hot_player,16
	.bss	hot_cycle_rate,16
	.BSS	HELP_PNUM,16
	.bss	just_now_on_fire,16
	.bss	hot_goals,16
		
compute_shot_tip
	mmtm	sp,a0,a1,a2,a8,a9,a10,a11
	movi	modify_pct_tip,a11
	jruc	csr_1
compute_shot_onetime
	mmtm	sp,a0,a1,a2,a8,a9,a10,a11
	movi	modify_pct_onetime,a11
	jruc	csr_1
compute_shot_regular
	mmtm	sp,a0,a1,a2,a8,a9,a10,a11
	movi	modify_pct_regular,a11
csr_1	move	*a6(POF_OBJECT),a8,L
	callr	get_location_pct
	callr	modify_pct_pressure
	callr	modify_pct_deking

	callr	modify_pct_time_scores

	callr	modify_pct_drones
	call	a11			;modify based on shot type
	cmpi	1024,a10
	jrls	csr2a2
	movi	1024,a10
	jruc	csr_2
csr2a2	move	a10,a10
	jrnn	csr_2
	clr	a10
csr_2	move	a10,@global_shot_percentage,W
	mmfm	sp,a0,a1,a2,a8,a9,a10,a11
	rets

modify_pct_tip			;we boost tips more, because they are much slower
	move	a10,a14
	srl	1,a14
	add	a14,a10
	rets
modify_pct_onetime
	move	a10,a14
	srl	2,a14
	add	a14,a10
	rets

modify_pct_regular
	rets

get_location_pct
	move	*a6(POF_S_STAB),a9,L		;shot table
	movb	*a6(POF_NUMBER),a1
	move	*a8(OXVAL),a0,L
	addi	[0,8000h],a0
	sra	16,a0
	dec	a1
	sra	2,a1
	jrz	cs_1
	neg	a0
cs_1	move	a0,a0
	jrn	cs_far		;behind center line
	cmpi	233,a0
	jrlt	cs_neut		;behind blue line
	clr	a2
	cmpi	688,a0
	jrgt	cs_dt1
	movk	1,a2
	cmpi	600,a0
	jrgt	cs_dt1
	movk	2,a2
	cmpi	522,a0
	jrgt	cs_dt1
	movk	3,a2
	cmpi	370,a0
	jrgt	cs_dt1
	movk	4,a2
cs_dt1	sll	7,a2
	add	a2,a9
	move	*a8(OZPOS),a1,W
	jrnn	cs_dt3
	clr	a0
cs_dt3	cmpi	679,a0
	jrlt	cs_dt2
	movi	679,a0
cs_dt2	movi	85,a0
	divs	a0,a1
	sll	4,a1
	add	a1,a9
	move	*a9,a10,W		;a10 is our starting % for location
	rets
cs_far	move	*a9(290h),a10,W		;behind center line
	rets
cs_neut	move	*a9(280h),a10,W		;behind blue line
	rets

modify_pct_pressure
	movb	*a6(POF_NUMBER),a1
	dec	a1
	srl	2,a1
	neg	a1
	inc	a1
	move	a1,a2
	move	a1,a3
	sll	2,a3
	inc	a3
	sll	6,a1
	addi	POF_D_1P,a1,W
	add	a6,a1
	move	*a1+,a0,W
	move	*a1+,a14,W
	cmp	a0,a14
	jrhs	mpp1
	move	a14,a0
mpp1	move	a3,a2
	addk	3,a2
	GBLOCK	a2,a2
	move	*a2(POF_FLAGS),a2,W
	btst	B_PF_GOALIE,a2
	jrnz	mpp2
	addk	16,a1
	move	*a1+,a14,W
	cmp	a0,a14
	jrhs	mpp2
	move	a14,a0
mpp2	cmpi	60,a0
	jrls	mpp_a		;real close
	cmpi	140,a0
	jrls	mpp_b		;fairly close
	cmpi	200,a0
	jrls	mpp_c		;somewhat open
	jruc	mpp_d		;open
mpp_a	srl	1,a10
	jruc	mpp_d
mpp_b	move	a10,a14
	srl	2,a14
	sub	a14,a10
	jruc	mpp_d
mpp_c	move	a10,a14
	srl	3,a14
	sub	a14,a10
mpp_d	move	*a8(OXVAL),a2,L
	cmpi	4,a3
	jrhs	mpp21
	neg	a2
mpp21	callr	mpp3
	cmp	a2,a0
	jrgt	mpp_9		;not_in_front
	callr	mpp3
	cmp	a2,a0
	jrgt	mpp_9		;not in front
	inc	a3
	GBLOCK	a3,a1
	move	*a1(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	mpp_e		;in front
	callr	mpp31
	cmp	a2,a0
	jrgt	mpp_9		;not in front
	jruc	mpp_e		;in front
mpp_e	move	a10,a14
	srl	2,a14
	add	a14,a10
mpp_9	rets

mpp3	GBLOCK	a3,a1
mpp31	move	*a1(POF_OBJECT),a0,L
	move	*a0(OXVAL),a0,L
	cmpi	4,a3
	jrhs	mpp4
	neg	a0
mpp4	inc	a3
	rets

modify_pct_deking
	move	*a6(POF_DEKE_TIME),a14,L
	move	@WAVEIRQS,a0,L
	sub	a14,a0
	cmpi	60,a0
	jrhs	mpdk9
	move	*a6(POF_DEKE_COUNT),a14,W
	jrz	mpdk9
	cmpi	3,a14
	jrls	mpdk1
	movk	3,a14
mpdk1	move	a10,a0
	sll	a14,a0
	srl	6,a0		;5
	add	a0,a10
mpdk9	rets

modify_pct_time_scores			;easier
modify_pct_scores
	move	@time_score_left,a1,L
	movb	*a6(POF_NUMBER),a0
	cmpi	4,a0
	jrls	mpcu1
	move	@time_score_right,a1,L
mpcu1	move	@WAVEIRQS,a14,L
	sub	a1,a14
	cmpi	1200,a14
	jrls	mpcu9


mpcuh	move	a10,a14
	srl	1,a14
	add	a14,a10
mpcu9
	move	@team1_score,a1,W
	movb	*a6(POF_NUMBER),a14
	cmpi	4,a14
	jrls	jkmm1
	move	@team2_score,a1,W
jkmm1	cmpi	10,a1
	jrhi	jkmmh
	cmpi	2,a1
	jrhi	jkmm2
	move	a10,a14
	sra	1,a14
	add	a14,a10
jkmm2	rets
jkmmh	move	*a6(POF_DRONE_LEVEL),a14,W
	cmpi	7,a14
	jrhs	jkhh9		;skip if drone level >= 7 (>=7 is always a non human team)
	move	a10,a14		;over 10 points
	sra	2,a14		; 25% less chance
	sub	a14,a10
jkhh9	rets

modify_pct_time
	callr	are_we_all_drone
	jrnc	mpt9
	move	@period,a14
	cmpi	4,a14
	jrz	mptotc
	move	@minutes,a14,W
	cmpi	2,a14
	jrls	mpt1
	move	@tenseconds,a14,W
	cmpi	5,a14
	jrz	mptls		;2:50 or more, less %
	jruc	mpt9
mpt1	move	a14,a14
	jrnz	mpt9
	move	@tenseconds,a14,W
	cmpi	2,a0
	jrls	mptls		;20 seconds left, less %
	jruc	mpt9
mptotc	move	a10,a14		;all of overtime, 12% less
	sra	3,a14
	sub	a14,a10
	rets
mptls	move	a10,a14
	sra	2,a14		;25% less
	sub	a14,a10
mpt9	rets

are_we_all_drone
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrnz	awhum
	movb	*a6(POF_NUMBER),a14
	dec	a14
	xori	1,a14
	inc	a14
	GBLOCK	a14,a14
	move	*a14(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	awdron		;all drone team
awhum	clrc
	rets
awdron	setc
	rets

modify_pct_drones
	callr	are_we_all_drone
	jrc	mpdron		;all drone team
	move	@hot_player,a1,W
	jrz	mpdron
	movb	*a6(POF_NUMBER),a14
	cmp	a1,a14
	jrnz	mpdron
	move	a10,a14
;	sra	2,a14
	add	a14,a10		;for hot human player % or teammate
	add	a14,a10		;for hot human player % or teammate
	add	a14,a10		;for hot human player % or teammate
mpdron	move	*a6(POF_DRONE_LEVEL),a14,W
	jrnz	mpcd1
	move	a10,a14
	sra	2,a14
	sub	a14,a10		;drone level 0, reduce probability of going in
	jruc	mpdr9
mpcd1	cmpi	5,a14		;drone level 1-5, reduce probability
	jrge	mpcd11
	move	a10,a14
	sra	3,a14
	sub	a14,a10
	jruc	mpdr9
mpcd11	cmpi	8,a14
	jrlt	mpdr9		;drone level 6-7, no probability change
	cmpi	11,a14
	jrlt	mpnet
	move	a10,a14		;drone level 11-12, more probability
	add	a14,a10
	add	a14,a10
	jruc	mpdr9
mpnet	move	a10,a14
	sra	2,a14
	add	a14,a10		;drone level 8-10, add to probability of going in
mpdr9	movb	*a6(POF_NUMBER),a14
	dec	a14
	srl	2,a14
	dec	a14
	abs	a14
	sll	2,a14
	inc	a14
	GBLOCK	a14,a14
	move	*a14(POF_DRONE_LEVEL),a14,W	;get drone level of other team
	cmpi	11,a14
	jrlt	mpnet2
	move	a10,a14
	sra	1,a14
	sub	a14,a10		;percentage is 50% less against 11 or 12 drone
	jruc	mpdr99
mpnet2	cmpi	7,a14
	jrlt	mpdr99
	move	a10,a14
	sra	3,a14
	sub	a14,a10		;percentage is 12.5% less against smart drone
mpdr99	rets

update_drone_msgs
	movk	1,a0		;lets assume player 1
	calla	do_we_have_start_credits
	jrc	udm_st
	movk	3,a0
ud2	move	a0,@global_drone_cstate,W
	rets
udm_st	movk	2,a0
	jruc	ud2

create_puck_control_indicator
	clr	a0
	move	a0,@last_control_pl
	movi	pcbox_init,b0
	calla	EASYMAKE
	jrz	cpci9
	move	a8,@puck_ctrl_object,L
	movi	puck_control_script,a1
	jauc	STRT_ANIM
cpci9	rets
	.bss	last_control_pl,16

set_puck_control_indicator
	move	@PUCK_CONTROL,a0,W
	move	@last_control_pl,a1,W
	cmp	a0,a1
	jrz	specspf		;check and do special flashing
	callr	remove_old_control
	callr	start_flash_control
	callr	move_big_puck
	move	@PUCK_CONTROL,@last_control_pl,W
	rets
specspf	move	@puck_control_new,a14,W
	jrz	spec9
	jruc	continue_flash_control
spec9	rets

continue_flash_control
	rets

remove_old_control
	move	a1,a2
	jrz	roc_9
	sll	5,a2
	addi	puck_box_oid_list-32,a2
	movi	NAMEBARP,a1
	move	*a2+,a0,W
	callr	cp_oi
	movi	LSTNME1P,a1
	move	*a2+,a0,W
	jruc	cp_oi
roc_9	rets

start_flash_control
	move	@PUCK_CONTROL,a2,W
	jrz	sfc_9
	sll	5,a2
	addi	puck_box_oid_list-32,a2
	movi	NAMEBAR2P,a1
	move	*a2+,a0,W
	callr	cp_oi
	movi	LSTNME2P,a1
	move	*a2+,a0,W
	jruc	cp_oi
sfc_9	rets

move_big_puck
	move	@PUCK_CONTROL,a0,W
	move	@puck_ctrl_object,a8,L
	move	a0,a0
	jrz	bp8
	move	@TOP_DISP_OFF,a14,W
	jrnz	bp8
	move	@hot_player,a14,W
	movi	puck_control_script,a1
;	cmp	a0,a14
;	jrnz	mbpnf
;	movi	puck_control_fire_script,a1
mbpnf	calla	STRT_ANIM
	GBLOCK	a0,a14
	move	*a14(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	bp8
	sll	4,a0
	addi	spcil,a0
	move	*a0,a0,W
bp7	movi	[14,0],a1
	movy	a1,a0
	jauc	set_scrnobj_to_pos
bp8	movi	-100,a0
	jruc	bp7

cp_oi	calla	EXIST_OBJ_ALL
	jrz	cpoi9
	move	a1,a0
	jauc	CHANGE_PAL
cpoi9	rets

spcil	.word	-100
	.word	13,103,-100,-100,298,388,-100,-100
puck_box_oid_list
	.word	OID_TURBO_1,OID_TURBONAME_1
	.word	OID_TURBO_2,OID_TURBONAME_2
	.word	0,0
	.word	0,0
	.word	OID_TURBO_5,OID_TURBONAME_5
	.word	OID_TURBO_6,OID_TURBONAME_6
	.word	0,0
	.word	0,0

pcbox_init
	.long	NMPUCK01
	.word	DMAWNZ,M_SCRNOBJ|M_NOVEL
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_BIGPUCK
	.long	[-100,0],[6,0],[999,0]		;x,y,z

puck_control_script
pcl1	LWL	NMPUCK01,AFUNC|1,a_set_pal_to_img
pcl2	LW	NMPUCK01,4
	LW	NMPUCK02,4
	LW	NMPUCK03,4
	LW	NMPUCK04,4
	LW	NMPUCK05,4
	LW	NMPUCK06,4
	LW	NMPUCK07,4
	LW	NMPUCK08,4
	LWL	NMPUCK09,AFUNC|4,a_safe_branch+4	;we only branch once
	.long	pcl1,pcl2
	.long	0

;puck_control_fire_script
;pcf1	LWL	PUCKFR01,AFUNC|1,a_set_pal_to_img
;pcf2	LW	PUCKFR01,4
;	LW	PUCKFR02,4
;	LW	PUCKFR03,4
;	LW	PUCKFR04,4
;	LW	PUCKFR05,4
;	LWL	PUCKFR06,AFUNC|4,a_safe_branch+4	;we only branch once
;	.long	pcf1,pcf2
;	.long	0

turbo_stuff_list
	.long	OID_TURBO_1,[6,0],[5,0],[1000,0]		;box
	.long	 OID_TURBOBAR_1,[22,0],[15,0],[999,0]		;bar
	.long	 OID_TURBONAME_1,[57,0],[10,0],[999,0]		;name
	.long	 OID_TURBONAME_1,[6+43,0],[10,0],[999,0]	;press start
	.long	 OID_TURBONAME_1,[6+43,0],[10,0],[999,0]	;insert coin
	.long	 OID_TURBO_1,[6,0],[5,0],[999,0]		;drone box
	.long	 OID_TURBONAME_1,[6+43,0],[10,0],[999,0]	;please wait
	.long	 OID_TURBONAME_1,[6+43,0],[10,0],[999,0]	;name for to control
	.long	 PRPTRBOP,0,0,0
	.long	 OID_TURBOBAR_1,[6,0],[15,0],[999,0]		;drone bar
	.long	 OID_TURBOSBAR_1,[57,0],[34,0],[998,0]		;small bar
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	OID_TURBO_2,[96,0],[5,0],[1000,0]		;box
	.long	 OID_TURBOBAR_2,[112,0],[15,0],[999,0]		;bar
	.long	 OID_TURBONAME_2,[146,0],[10,0],[999,0]		;name
	.long	 OID_TURBONAME_2,[96+43,0],[10,0],[999,0]	;press start
	.long	 OID_TURBONAME_2,[96+43,0],[10,0],[999,0]	;insert coin
	.long	 OID_TURBO_2,[96,0],[5,0],[999,0]		;drone box
	.long	 OID_TURBONAME_2,[96+43,0],[10,0],[999,0]	;please wait
	.long	 OID_TURBONAME_2,[96+43,0],[10,0],[999,0]	;name for to control
	.long	 BLUTRBOP,0,0,0
	.long	 OID_TURBOBAR_2,[96,0],[15,0],[999,0]		;drone bar
	.long	 OID_TURBOSBAR_2,[146,0],[34,0],[998,0]		;small bar
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.long	 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.long	 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.long	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.long	 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.long	 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.long	OID_TURBO_5,[304,0],[5,0],[1000,0]		;box
	.long	 OID_TURBOBAR_5,[288,0],[15,0],[999,0]		;bar
	.long	 OID_TURBONAME_5,[254,0],[10,0],[999,0]		;name
	.long	 OID_TURBONAME_5,[219+43,0],[10,0],[999,0]	;press start
	.long	 OID_TURBONAME_5,[219+43,0],[10,0],[999,0]	;insert coin
	.long	 OID_TURBO_5,[219,0],[5,0],[999,0]		;drone box
	.long	 OID_TURBONAME_5,[219+43,0],[10,0],[999,0]	;please wait
	.long	 OID_TURBONAME_5,[219+43,0],[10,0],[999,0]	;name for to control
	.long	 YLWTRBOP,0,0,0
	.long	 OID_TURBOBAR_5,[219,0],[15,0],[999,0]		;drone bar
	.long	 OID_TURBOSBAR_5,[254,0],[34,0],[998,0]		;small bar
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	OID_TURBO_6,[394,0],[5,0],[1000,0]		;box
	.long	 OID_TURBOBAR_6,[378,0],[15,0],[999,0]		;bar
	.long	 OID_TURBONAME_6,[344,0],[10,0],[999,0]		;name
	.long	 OID_TURBONAME_6,[308+43,0],[10,0],[999,0]	;press start
	.long	 OID_TURBONAME_6,[308+43,0],[10,0],[999,0]	;insert coin
	.long	 OID_TURBO_6,[308,0],[5,0],[999,0]		;drone box
	.long	 OID_TURBONAME_6,[308+43,0],[10,0],[999,0]	;please wait
	.long	 OID_TURBONAME_6,[308+43,0],[10,0],[999,0]	;name for to control
	.long	 GRNTRBOP,0,0,0
	.long	 OID_TURBOBAR_6,[308,0],[15,0],[999,0]		;drone bar
	.long	 OID_TURBOSBAR_6,[344,0],[34,0],[998,0]		;small bar
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0
	.long	 0,0,0,0

GRNTRBOP:
   .word   4
   .word   07c1fh,003e0h,002a0h,00180h

PRPTRBOP:
   .word   4
   .word   00000h,07c1fh,05415h,0300ch

YLWTRBOP:
   .word   4
   .word   00000h,07fe0h,056a0h,03180h

BLUTRBOP:
   .word   4
   .word   00000h,0001fh,00015h,0000ch

turbo_box_init
	.long	NAMEBAR1
	.word	DMAWNZ,M_SCRNOBJ|M_NOVEL
	.word	0

turbo_box_init2
	.long	NAMEBAR1
	.word	DMAWNZ|DMAHFL,M_SCRNOBJ|M_NOVEL
	.word	0

turbo_bar_init
	.long	GRNTRBO1
	.word	DMAWNZ|DMACLP,M_SCRNOBJ|M_NOVEL
	.word	0

turbo_bar_init2
	.long	GRNTRBO1
	.word	DMAWNZ|DMACLP|DMAHFL,M_SCRNOBJ|M_NOVEL
	.word	0

turbo_name_init
	.long	CHELIOS1
	.word	DMAWNZ,M_SCRNOBJ|M_NOVEL
	.word	0

small_turbo_init
	.long	THERMO1
	.word	DMAWNZ,M_SCRNOBJ|M_NOVEL|M_NOSCALE
	.word	0

small_turbo2_init
	.long	THERMO1
	.word	DMAWNZ|DMAHFL,M_SCRNOBJ|M_NOVEL|M_NOSCALE
	.word	0

press_start_init
	.long	PRSSTART
	.word	DMAWNZ,M_SCRNOBJ|M_NOVEL
	.word	0

insert_coin_init
	.long	INSERTCN
	.word	DMAWNZ,M_SCRNOBJ|M_NOVEL
	.word	0

please_wait_init
	.long	PLEASEWT
	.word	DMAWNZ,M_SCRNOBJ|M_NOVEL
	.word	0

turbo_drone_box_init
	.long	NAMEBUYIN
	.word	DMAWNZ|DMACLP,M_SCRNOBJ|M_NOVEL
	.word	0

turbo_drone_bar_init
	.long	GRNTRBOx
	.word	DMAWNZ,M_SCRNOBJ|M_NOVEL
	.word	0

to_control_init
	.long	TOCONTROL
	.word	DMAWNZ,M_SCRNOBJ|M_NOVEL
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
ut_down	move	@UNLIM_TURBO,a14,W
	jrnz	no_tdn
	movb	*a6(POF_NUMBER),a0
	move	@hot_player,a14,W
	cmp	a0,a14
	jrnz	utdnhp
no_tdn	move	*a6(POF_TURBO_AMOUNT),a0,L
	jruc	ut_d1
utdnhp	move	*a6(POF_TURBO_AMOUNT),a0,L
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
ut_m	move	a1,a0
	callr	set_turbo_state
	movi	35,a0			;delay it from going up 35 ticks
	move	a0,*a6(POF_TURBO_DELAY),W
	jruc	ut_8
ut_up	clr	a0
	callr	set_turbo_state
	move	*a6(POF_TURBO_DELAY),a0,W
	jrz	ut_u1
	dec	a0
	move	a0,*a6(POF_TURBO_DELAY),W
	jruc	ut_8
ut_u1	move	*a6(POF_TURBO_AMOUNT),a0,L
	move	*a9(PS_SP_TURBO_UP),a14,W
	sll	16,a14
	srl	16,a14
	move	*a6(POF_PUP_FLAGS),a7,W
	btst	B_PUP_TURBO,a7
	jrz	npupt
	sll	1,a14	;double speed
npupt	add	a14,a0
	cmpi	[71,0],a0		;70 is width of bar
	jrls	utu2
	movi	[71,0],a0
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
	movi	71,a1
	sub	a0,a1
	move	a1,a0
	move	*a7(OFSET),a1,W
	cmp	a1,a0
	jrz	ut9
	jrgt	ut8u
	dec	a1
	jruc	ut8a
ut8u	inc	a1
ut8a	move	a1,*a7(OFSET),W
ut9	callr	update_hot_bar
utb_99	mmfm	sp,a8,a9
	rets

update_hot_bar
	move	@WAVEIRQS,a14,W
	sll	30,a14
	srl	30,a14
	jrnz	uhb1k
	move	*a6(POF_HOT_VALUE),a0,W
	move	*a6(POF_HOT_VALUE_D),a14,W
	cmp	a0,a14
	jrz	uhb1k
	jrlt	uhb2k
	dec	a14
	jruc	uhb3k
uhb2k	inc	a14
uhb3k	move	a14,*a6(POF_HOT_VALUE_D),W
uhb1k	move	*a6(POF_HOT_VALUE),a0,W
	cmpi	19,a0
	jrz	hb99			;is hot, do nothing
	move	*a6(POF_HOT_VALUE_D),a0,W
	sll	5,a0
	addi	miniturb_lsts,a0
	move	*a0,a0,L
	move	*a6(POF_HOT_OBJECT),a8,L
	move	a0,a1		;save it
	move	*a8(OCTRL),a4,W
	jauc	maybe_ani
hb99	rets

check_on_fire
	clr	a0
	move	a0,@just_now_on_fire,W
	move	a0,@FIRE_GOAL,W
	move	@assist_by,a0,W
	move	@hot_player,a1,W
	jrnz	cof_gg2
	callr	inc_hot_assist
cof_gg2	move	@scored_by,a0,W
;	move	@hot_player,a1,W
	move	a1,a1
	jrnz	cof_5		;someone is on fire
	move	a0,a0
	jrz	cof_9		;nobody to make hot
	GBLOCK	a0,a6
	move	*a6(POF_HOT_VALUE),a14,W
	cmpi	18,a14
	jrnz	cof_i		;not ready
	mmtm	sp,a0,a7,a8,a9
	callr	become_hot
	movi	AUD_ON_FIRE,a0
	calla	AUD1
	movk	1,a0
	move	a0,@just_now_on_fire,W
	mmfm	sp,a0,a7,a8,a9
cof_9	rets
cof_i	jruc	inc_hot_score
cof_5	cmp	a0,a1
	jrz	cof_59a		;already hot
	move	@team_scored,a0,W
	jrz	cof_59		;no one we know scored?
	dec	a0
	dec	a1
	sra	2,a1
	cmp	a0,a1
	jrnz	kh1		;other team scored, kill hot
cof_59	rets
cof_59a	move	@hot_goals,a14,W
	inc	a14
	move	a14,@hot_goals,W	;faceoff will kill us, if 4
	rets
kh1	callr	clear_hot
	clr	a14
	move	a14,@hot_goals,W
	move	@scored_by,a0,W
	jrz	kh2
	callr	inc_hot_score
	callr	inc_hot_score
;	callr	inc_hot_score
kh2	rets

restart_hot
	move	@hot_player,a0,W
	jrz	his9
	GBLOCK	a0,a6
	jruc	bh1

become_hot	;a6 = player
	clr	a14
	move	a14,@hot_goals,W
	calla	on_off_fire_show
	movk	1,a0
	move	a0,@FIRE_GOAL,W
	move	@hot_player,a0,W
	jrz	bh1			;nobody hot, so skip the clear
	movb	*a6(POF_NUMBER),a8
	cmp	a8,a0
	jrz	his9			;already hot
	callr	clear_hot
bh1	movb	*a6(POF_NUMBER),a8
	move	a8,@hot_player,W
	calla	set_background_tune
	movi	hot_flash_anim,a1
	cmpi	4,a8
	jrhi	hi1
	movi	hot_flash1_anim,a1
hi1	move	*a6(POF_HOT_OBJECT),a8,L
	calla	STRT_ANIM
	movi	HOTNUM1,a0
	calla	CHANGE_PAL
	clr	a14
	move	a14,@PLAYER_1_BLOCK+POF_HOT_VALUE,W
	move	a14,@PLAYER_2_BLOCK+POF_HOT_VALUE,W
	move	a14,@PLAYER_5_BLOCK+POF_HOT_VALUE,W
	move	a14,@PLAYER_6_BLOCK+POF_HOT_VALUE,W
	movk	19,a14
	move	a14,*a6(POF_HOT_VALUE),W
	movi	[71,0],a14
	move	a14,*a6(POF_TURBO_AMOUNT),L
his9	rets


do_bsc	sll	2,a1
	move	a1,a0		;  4x minutes
	sll	1,a1
	add	a1,a0		;+ 8x minutes = 12x
	sll	1,a1
	add	a1,a0		;+16x minutes = 28x
	sll	1,a1
	add	a1,a0		;+32x minutes = 60x
	sll	1,a2
	add	a2,a0		;+ 2x tenseconds
	sll	2,a2
	add	a2,a0		;+ 8x tenseconds = 10x
	add	a3,a0		;+ 1x seconds
	rets

hotbar_periodstart
	callr	set_hotcycle_rate
	CREATE	PID_HOT_CYCLE,cycle_hot
	jruc	restart_hot
;	clr	a1
;	movk	1,a0
;	callr	htbp
;	callr	htbp
;	movk	5,a0
;	callr	htbp
;htbp	GBLOCK	a0,a6
;	move	*a6(POF_HOT_VALUE),a14,W
;	cmpi	10,a14
;	jrnz	htbp1
;	move	a1,*a6(POF_HOT_VALUE),W
;htbp1	inc	a0
;	rets


set_hotcycle_rate
	move	@PLAYER_1_BLOCK+POF_HOT_VALUE,a0,W
	move	@PLAYER_2_BLOCK+POF_HOT_VALUE,a14,W
	callr	shr1
	move	@PLAYER_5_BLOCK+POF_HOT_VALUE,a14,W
	callr	shr1
	move	@PLAYER_6_BLOCK+POF_HOT_VALUE,a14,W
	callr	shr1
	sll	4,a0
	addi	shr_del_list,a0
	move	*a0,a14,W
	move	a14,@hot_cycle_rate,W
	rets
shr1	cmp	a0,a14
	jrls	shr2
	move	a14,a0
shr2	rets
shr_del_list
	.word	30,30,30,30,29,28,26,25,24,22,21,20
	.word	18,17,16,14,13,12,04,31,31,31,31,31

clear_hot
	move	@hot_player,a0,W
	jrz	chan9
	clr	a14
	dec	a14
	move	a14,@FIRE_GOAL,W
	calla	on_off_fire_show
	clr	a14
	move	a14,@hot_player,W
	move	a14,@hot_goals,W
	move	a14,@show_puck_on_fire,W
	GBLOCK	a0,a0
	move	a14,*a0(POF_HOT_VALUE),W
	calla	set_background_tune
	move	*a0(POF_HOT_OBJECT),a8,L
	move	a8,a0
	calla	CKPULLANIM
	movi	NEWBARx3,a0
	calla	CHANGE_PAL
	movi	THERMO1,a1
	move	*a8(OCTRL),a4,W
	move	*a8(OXPOS),a14,W	;we use oxpos here to determine flip
	cmpi	200,a14
	jrgt	chr8
	ori	M_FLIPH,a4
chr8	jauc	maybe_ani
chan9	rets

chh_0	SLEEP	10
cycle_hot
	movi	NEWBARx3,a0
	calla	FINDPAL
	jrz	chh_0		;not found
	move	a0,a8
	move	a0,a5
	calla	INC_PALCNT
	ZEXT	A8
	SRL	8,A8
	SLL	8,A8
	move	a8,a9
	movk	4,a1			;# of palette entry
	or	a1,a8			; 'or' in palette address to palette entry
ccx1	movi	color_data1,a0		;6 words of color data
	callr	gopcc
	move	@hot_cycle_rate,a14,W
	cmpi	31,a14
	jrz	ccx2
	SLEEPR	a14
	movi	color_data2,a0
	callr	gopcc
	move	@hot_cycle_rate,a14,W
ccx2	SLEEPR	a14
	jruc	ccx1
gopcc	move	a8,a1
	movk	6,a2			;3 colors to stuff
	jauc	PALSET
gopcc2	move	a9,a1
	movk	3,a2			;3 colors to stuff
	jauc	PALSET

color_data1
   .word   07e60h,07d00h,05c00h,07e60h,07d00h,05c00h
color_data2
   .word   07ee0h,07e20h,07d20h,07ff5h,07fe0h,07ec0h

clear_all_hot
	callr	clear_hot
	clr	a14
	move	a14,@hot_player,W
	move	a14,@PLAYER_1_BLOCK+POF_HOT_VALUE,W
	move	a14,@PLAYER_2_BLOCK+POF_HOT_VALUE,W
	move	a14,@PLAYER_5_BLOCK+POF_HOT_VALUE,W
	move	a14,@PLAYER_6_BLOCK+POF_HOT_VALUE,W
	rets

**************************************************************************
*								         *
* inc_hot								 *
* 	a6 = player block						 *
* 	a7 = player hit							 *
*								         *
**************************************************************************
inc_hot_score
ihs4	callr	ihs2
ihs2	callr	inc_hot_assist
inc_hot_assist
	mmtm	sp,a0,a7,a8,a9
	move	@hot_player,a14,W
	jrnz	ichg99
	GBLOCK	a0,a6
	cmpi	4,a0
	jrz	ichg99
	cmpi	8,a0
	jrz	ichg99
	jruc	ichi

inc_hot_ifp_a7
	move	@PUCK_CONTROL,a14,W
	movb	*a7(POF_NUMBER),a0
	cmp	a0,a14
	jrnz	inc_hot_single
	;
inc_hot
	callr	inc_hot_single
inc_hot_single
	mmtm	sp,a0,a7,a8,a9
	move	@hot_player,a14,W
	jrnz	ichg99
	movb	*a6(POF_NUMBER),a0
	cmpi	4,a0
	jrz	ichg99
	cmpi	8,a0
	jrz	ichg99
	movb	*a7(POF_NUMBER),a14
	dec	a0
	dec	a14
	srl	2,a0
	srl	2,a14
	cmp	a0,a14
	jrz	ichg99
	move	*a7(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	ichg99
ichi	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	ichg99
;	btst	B_PF_HUMAN,a14
;	jrz	ichg99
	move	*a6(POF_HOT_VALUE),a14,W
	inc	a14
	cmpi	18,a14
	jrlt	ichg1
	jrgt	ichd
;	callr	become_hot	;instead, do ready to hot show
ichd	movk	18,a14
ichg1	move	a14,*a6(POF_HOT_VALUE),W
ichg99	callr	set_hotcycle_rate
	mmfm	sp,a0,a7,a8,a9
	rets

miniturb_lsts
	.long	THERMO1,THERMO1a,THERMO2,THERMO2a,THERMO3,THERMO3a
	.long	THERMO4,THERMO4a,THERMO5,THERMO5a,THERMO6,THERMO6a
	.long	THERMO7,THERMO7a,THERMO8,THERMO8a,THERMO9,THERMO9a
	.long	THERMO10

hot_flash_anim
	LWW	HOTFLSHr1,AFLIP|6,0
	LW	HOTFLSHr2,6
	LW	HOTFLSHr3,6
	LW	HOTFLSHr7,6
	LW	HOTFLSHr4,6
	LW	HOTFLSHr5,6
	LW	HOTFLSHr6,6
	LW	BIGHOT3,6
	.long	0

hot_flash1_anim
	LWW	HOTFLSHl1,AFLIP|6,0
	LW	HOTFLSHl2,6
	LW	HOTFLSHl3,6
	LW	HOTFLSHl7,6
	LW	HOTFLSHl4,6
	LW	HOTFLSHl5,6
	LW	HOTFLSHl6,6
	LW	BIGHOT3l,6
	.long	0

create_mini_bar
	movb	*a6(POF_NUMBER),a8
	cmpi	4,a8
	jrz	cmb_99
	cmpi	8,a8
	jrz	cmb_99
	move	a8,a3
	sll	11,a3
	addi	turbo_stuff_list-2048+10*128,a3
	move	*a3,a14,L
	jrz	cmb_99
	movi	small_turbo_init,b0
	cmpi	2,a8
	jrhi	doido
	movi	small_turbo2_init,b0
doido	calla	EASYMAKE
	callr	stbb1
	move	a8,*a6(POF_HOT_OBJECT),L
;	clr	a14
;	move	a14,*a6(POF_HOT_VALUE),W
cmb_99	rets

set_turbo_state
	move	*a6(POF_OBJECT),a8,L
	move	a0,a0
	jrz	sts_f
	clr	a14
	move	a14,*a6(POF_TURBO_OB),W
	move	*a6(POF_TURBO_MODE),a14,W
	jrnz	sts999
	move	a0,*a6(POF_TURBO_MODE),W
	clr	a0
	move	a0,*a6(POF_TURBO_OB),W
	move	@minutes,a14,W
	cmpi	2,a14
	jrnz	stn2
	move	*a6(POF_FREEZE_BITS),a14,W
	ori	M_PFRAZ_TURBOED,a14
	move	a14,*a6(POF_FREEZE_BITS),W
stn2	move	*a6(POF_TURBOPAL),a0,L
	jauc	CHANGE_PAL
sts_f	move	*a6(POF_TURBO_OB),a0,W
	jrz	stsof
	dec	a0
	move	a0,*a6(POF_TURBO_OB),W
	jrz	sts_0
	move	@WAVEIRQS,a0,W	;just get low bits
	sll	30,a0
	srl	31,a0
	jrz	sts_0
	move	*a6(POF_TURBOPAL),a0,L
	jauc	CHANGE_PAL
stsof	move	*a6(POF_TURBO_MODE),a14,W
	jrz	sts999
	move	a0,*a6(POF_TURBO_MODE),W
sts_0	move	*a6(POF_NORMALPAL),a0,L
	jauc	CHANGE_PAL
sts999	rets

set_turbo_bars
	movb	*a6(POF_TOP_MODE),a0
	jrz	stb_c			;nothing on top, create bars
	cmpi	1,a0
	jrz	stb_9
	callr	deltop
	move	*a6(POF_ARROW_CPU),a8,L
	jrz	stb_c
	movi	GFONT10CP,a0
	calla	CHANGE_PAL
stb_c	movb	*a6(POF_NUMBER),a3
	move	a3,a14
	sll	11,a3
	addi	turbo_stuff_list-2048,a3
	movi	turbo_box_init,b0
	dec	a14
	srl	2,a14
	jrz	stbc1
	movi	turbo_box_init2,b0
stbc1	calla	EASYMAKE
	callr	stbb1
	move	a8,*a6(POF_TURBO_BOX),L
	movi	turbo_bar_init,b0
	movb	*a6(POF_NUMBER),a14
	dec	a14
	srl	2,a14
	jrz	stw1
	movi	turbo_bar_init2,b0
stw1	calla	EASYMAKE
	move	*a3(7*128),a0,L
	calla	CHANGE_PAL
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

stbb1p	callr	stbb1
	movb	*a6(POF_NUMBER),a0
	move	@PUCK_CONTROL,a14,W
	cmp	a0,a14
	jrnz	stbbp9
	movi	LSTNME2P,a0
	jauc	CHANGE_PAL
stbbp9	rets
stbb1	move	*a3+,a0,L
	move	a0,*a8(OID),W
	move	*a3+,a0,L
	move	a0,a14
	srl	16,a14
	move	*a3+,a0,L

	mmtm	sp,a14
	move	@TOP_DISP_OFF,a14,W
	jrz	ndof
	subi	[100,0],a0
ndof	mmfm	sp,a14

	movx	a14,a0
	calla	set_scrnobj_to_pos_flips
	move	*a3+,a0,L
	move	a0,*a8(OZVAL),L
	jauc	INSERT_OBJ

deldronetop
	move	*a6(POF_TURBO_NAME),a8,L
	jrz	ddt3
	calla	DELETE_OBJ
	move	a0,*a6(POF_TURBO_NAME),L
ddt3	rets

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
	move	a1,a1
	jrnz	utd_td1
	callr	drone_box_bar
utd_td1	callr	deldronetop
	movb	*a6(POF_TOP_MODE),a0			;create objects
	sll	5,a0
	addi	utd_ml,a0
	move	*a0,a0,L
	call	a0
utd_9	callr	update_hot_bar
	mmfm	sp,a8
	rets

utd_ml	.long	notop		;nothing
	.long	set_turbo_bars	;real turbo bar (here only for attract mode)
	.long	pstart		;press start
	.long	icoin		;insert coin
	.long	tcontrl		;to control
	.long	pwait		;please wait

utd_okl	.word	0,1,1,0,0,1,1,0,0

notop	jruc	deltop

pstart	movb	*a6(POF_NUMBER),a3
	sll	11,a3
	addi	turbo_stuff_list-2048+3*128,a3
	movi	press_start_init,b0
	calla	EASYMAKE
	callr	stbb1p
	move	a8,*a6(POF_TURBO_NAME),L
	rets

icoin	movb	*a6(POF_NUMBER),a3
	sll	11,a3
	addi	turbo_stuff_list-2048+4*128,a3
	movi	insert_coin_init,b0
	calla	EASYMAKE
	callr	stbb1p
	move	a8,*a6(POF_TURBO_NAME),L
	rets

tcontrl	move	@GAME_STATE,a3,W
	movb	*a6(POF_NUMBER),a3
	sll	11,a3
	addi	turbo_stuff_list-2048+6*128,a3
	movi	turbo_name_init,b0
	calla	EASYMAKE
	move	*a6(POF_IMAGE_TABLE),a0,L
	move	*a0,a1,L
	move	*a8(OCTRL),a4,W
	calla	ANI
	callr	stbb1p
	move	a8,*a6(POF_TURBO_NAME),L
tcn9	rets

pwait	movb	*a6(POF_NUMBER),a3
	sll	11,a3
	addi	turbo_stuff_list-2048+6*128,a3
	movi	please_wait_init,b0
	calla	EASYMAKE
	callr	stbb1p
	move	a8,*a6(POF_TURBO_NAME),L
	rets

drone_box_bar
	mmtm	sp,a3
	movb	*a6(POF_NUMBER),a3
	sll	11,a3
	addi	turbo_stuff_list-2048+5*128,a3
	movi	turbo_drone_box_init,b0
	calla	EASYMAKE
	callr	stbb1
	movi	NAMEBARP,a0
	calla	CHANGE_PAL
	move	a8,*a6(POF_TURBO_BOX),L
	addi	3*128,a3
	movi	turbo_drone_bar_init,b0
	calla	EASYMAKE
	callr	stbb1
	move	a8,*a6(POF_TURBO_BAR),L
	subi	256,a3
	move	*a3+,a0,L
	calla	CHANGE_PAL
	mmfm	sp,a3
	rets

get_correct_drone_top
	move	@GAME_STATE,a1,W
	cmpi	7,a0
	jrz	gcd5
	cmpi	5,a0
	jrz	gcdt9			;if we are on please wait, leave us there
	KITN	4
	jrz	arcdt
	movb	*a6(POF_NUMBER),a14
	cmpi	1,a14
	jrz	arcdt
	cmpi	6,a14
	jrnz	gcd4			;on player != 1,6, 2 player game is just name
arcdt	move	@WAVEIRQS,a1,W		;get lower half of longword
	move	@global_drone_cstate,a0,W
	jrnz	gcdk
	movk	2,a0
gcdk	btst	6,a1			;top display changes every second (64 ticks)
	jrnz	gcdt9
gcd4	movk	4,a0
gcdt9	rets
gcd5	movk	5,a0
	rets

fix_players_trail
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_TRAILS,a14
	jrz	eopil

	move	*a6(POF_OBJECT),a8,L
	calla	GETOBJ
	jrz	eopil
	move	*a8(OXVAL),*a0(OXVAL),L
	move	*a8(OYVAL),*a0(OYVAL),L
	move	*a8(OZVAL),a14,L
	addi	500,a14
	move	a14,*a0(OZVAL),L
	move	*a8(OANIOFF),*a0(OANIOFF),L
	move	*a8(OFSET),*a0(OFSET),W
	move	*a8(OCTRL),*a0(OCTRL),W
	move	*a8(OSAG),*a0(OSAG),L
	move	*a8(ODAG),*a0(ODAG),L
	move	*a8(OUSIZE),*a0(OUSIZE),L
	move	*a8(OSIZE),*a0(OSIZE),L
	move	*a8(OCONST),*a0(OCONST),W
	move	*a8(OSCALE),*a0(OSCALE),L
	move	*a8(OIMG),*a0(OIMG),L
	move	*a8(OFLAGS),*a0(OFLAGS),W
	move	*a8(OUANIOFF),*a0(OUANIOFF),L
	move	*a8(OSCTAB),*a0(OSCTAB),L
	movi	OID_PLAYER_TRAILS,a14
	move	a14,*a0(OID),W
	move	a0,a8
	move	*a6(POF_TRAIL_PAL),a0,L
	calla	GETFPAL
	move	a0,*a8(OPAL),W
	move	a8,a0
	calla	INSOBJ
	movi	del_aft_scr,a1
	jauc	STRT_ANIM
eopil	rets

del_aft_scr
	LW	1,6
	LWL	1,1|AFUNC,DELETE_OBJ
	.long	0

do_check
	clr	a14
	move	a14,*a6(POF_HIT_BOARDS),W
	callr	are_we_skating_backwards
	jrnc	dc_1
	callr	are_we_fast_enough
	jrc	do_backwards_check
dc_1	callr	are_we_chasing_puck_player
	jrc	slash_check
;	callr	do_we_anticipate_a_hit
;	jrnc	dc_3
;	callr	are_we_near_boards
;	jrnc	dc_3
	callr	can_we_head_into_boards
	jrnc	dc_3
	callr	can_we_body_check
	jrc	body_check
dc_3	callr	do_we_high_stick
	jrc	high_stick
	jruc	cross_check

are_we_skating_backwards
	movb	*a6(POF_DIRECTION),a0
	jauc	are_we_backwards

are_we_fast_enough
	move	*a8(ODT_VEL),a14,L
	cmpi	[6,0],a14
	jrls	awfn
awfy	setc
	rets
awfn	clrc
	rets

are_we_chasing_puck_player
	move	@PUCK_CONTROL,a14,W
	jrz	spdr
	movb	*a6(POF_NUMBER),a0
	EQTEAM	a0,a14
	jrz	spdr			;if puck carrier is same team, no slash
	move	@PUCK_CONTROL,a0,W
	GBLOCK	a0,a7
	movb	*a7(POF_DIRECTION),a1
	movb	*a6(POF_DIRECTION),a2
	cmp	a1,a2
	jrnz	spdr			;if puck carrier is not going same direction as us, no slash
	move	*a7(POF_OBJECT),a9,L
	move	*a9(OXVAL),a0,L
	addi	[0,08000h],a0
	sra	16,a0
	move	*a9(OZPOS),a1,W
	move	*a8(OXVAL),a2,L
	addi	[0,08000h],a2
	sra	16,a2
	move	*a8(OZPOS),a3,W
	calla	find_dist_quick
	cmpi	110,a4
	jrhi	spdr
	move	*a8(ODT_VEL),a0,L
	cmpi	[3,0],a0
	jrls	spdr
	move	*a9(ODT_VEL),a0,L
	cmpi	[3,0],a0
	jrls	spdr
	move	*a9(OXVAL),a0,L
	move	*a9(OZVAL),a1,L
	move	*a8(OXVAL),a2,L
	move	*a8(OZVAL),a3,L
	calla	find_dir_to_point_18
	movb	*a7(POF_DIRECTION),a1
	cmp	a0,a1
	jrnz	spdr
	setc
	rets
spdr	clrc
	rets

;do_we_anticipate_a_hit
are_we_near_boards
can_we_body_check
	setc
	rets

can_we_head_into_boards
	mmtm	sp,a0,a1
	move	*a8(ODT_REALXVEL),a0,L
	move	a0,a14
	sra	2,a14
	add	a14,a0
	sll	4,a0
	move	*a8(OZVEL),a1,L
	move	a1,a14
	sra	2,a14
	add	a14,a1
	sll	4,a1		;within next 24 ticks
	move	*a8(OXVAL),a14,L
	add	a0,a14
	sra	1,a0
	add	a14,a0
	move	*a8(OZVAL),a14,L
	add	a1,a14
	sra	1,a1
	add	a14,a1		;predicted point
	cmpi	[-798,0],a0
	jrlt	cwhy
	cmpi	[798,0],a0
	jrgt	cwhy
	move	a1,a1
	jrn	cwhy
	cmpi	[679,0],a1
	jrgt	cwhy
	clrc
	mmfm	sp,a0,a1
	rets
cwhy	setc
	mmfm	sp,a0,a1
	rets

do_we_high_stick
	move	*a6(POF_TURBO_AMOUNT+010h),a0
	cmpi	53,a0
	jrls	dwhn
	setc
	rets
dwhn	clrc
	rets

do_backwards_check
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

slash_check
	move	*a8(ODT_REALXVEL),*a8(OXVEL),L
	movk	PM_SLASH,a1
	move	a1,*a6(POF_MODE),W
	jauc	set_player_script

body_check
	clr	a14
	movb	a14,*a6(POF_BDIRECTION)
	move	*a8(ODT_DIR),a0,L
	calla	dir_to_18
	movb	a0,*a6(POF_DIRECTION)
	jauc	set_body_check_script

high_stick
	movk	PM_HIGHSTICK,a1
	movi	400,a0
	calla	RANDPER
	jrnc	hs2
;	movk	PM_SWING,a1		;400/1024 chance of blatant swing
hs2	move	a1,*a6(POF_MODE),W
	jauc	set_player_script

cross_check
	movk	PM_CROSSCHECK,a1
	move	a1,*a6(POF_MODE),W
	jauc	set_player_script


	.if	NO_HELP_WINDOWS
;	.if	0

check_freeze_offscreen
check_freeze_shootfar
check_freeze_shootpass
check_freeze_drone_shootpass
check_freeze_turbo
check_freeze_smotherpass
annoy_player_shootpass
check_for_all_turbos
	rets

quick_freeze_check
quick_period_check
	clrc
	rets

	.else

check_freeze_offscreen
	movk	PFRZ_OFFSCREEN,a10
	jruc	cfrz_q

check_freeze_shootfar
	movk	PFRZ_SHOOTFAR,a10
	jruc	cfrz_q

annoy_player_shootpass
	mmtm	sp,a6,a9,a10
	GBLOCK	a0,a6
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_GOALIE,a14
	jrnz	apsd9
	btst	B_PF_HUMAN,a14
	jrz	apsdr
	callr	check_freeze_shootpass
	jruc	apsd9
apsdr	cmpi	4,a0
	jrz	apspl
	cmpi	8,a0
	jrz	apspl
	dec	a0
	xori	1,a0
	inc	a0
apspl	GBLOCK	a0,a6
	callr	check_freeze_drone_shootpass
apsd9	mmfm	sp,a6,a9,a10
	rets

check_freeze_shootpass
	movk	PFRZ_SHOOTPASS,a10
	jruc	cfrz_q
check_freeze_drone_shootpass
	movk	PFRZ_DRONE_SHOOTPASS,a10
	jruc	cfrz_q

check_for_all_turbos
	mmtm	sp,a0,a1,a7
	CREATE	PID_FROZEN_TURBOCHECK,cktrb
	mmfm	sp,a0,a1,a7
	rets
cktrb	movk	1,a0
	callr	ckrrt
	SLEEP	1
	movk	2,a0
	callr	ckrrt
	SLEEP	1
	movk	5,a0
	callr	ckrrt
	SLEEP	1
	movk	6,a0
	callr	ckrrt
	jauc	SUCIDE
ckrrt	GBLOCK	a0,a6
	move	*a6(POF_FREEZE_BITS),a14,W
	btst	PFRAZ_TURBOED,a14
	jrnz	ckrrt9
	callr	check_freeze_turbo
ckrrt9	rets

check_freeze_turbo
	movk	PFRZ_TURBO,a10
	jruc	cfrz_q

check_freeze_smotherpass
	callr	quick_period_check
	jrnc	cfrz9
	movb	*a6(POF_NUMBER),a9
	move	a9,a2
	dec	a2
	sra	2,a2
	sll	2,a2
	inc	a2
	GBLOCK	a2,a14
	move	*a14(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrnz	qfsmp1
	inc	a2
	GBLOCK	a2,a14
	move	*a14(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	cfrz9
qfsmp1	;
	movk	PFRZ_SMOTHERPASS,a10
	move	*a6(POF_FREEZE_BITS),a14,W
	btst	a10,a14
	jrnz	acfrz9
	movk	1,a2
	sll	a10,a2
	or	a2,a14
	move	a14,*a6(POF_FREEZE_BITS),W
	movb	*a6(POF_NUMBER),a9
	jruc	freeze_message_nt
acfrz9	rets

cfrz_q	callr	quick_freeze_check
	jrnc	cfrz9
cfrz	move	*a6(POF_FREEZE_BITS),a14,W
	btst	a10,a14
	jrnz	cfrz9
	movk	1,a2
	sll	a10,a2
	or	a2,a14
	move	a14,*a6(POF_FREEZE_BITS),W
	movb	*a6(POF_NUMBER),a9
	jruc	freeze_message
cfrz9	rets

quick_freeze_check
	move	*a6(POF_CMOS),a14,W
	jrnn	qfc_n
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	qfc_n
	move	@timer_ok,a14,W
	jrz	qfc_n
quick_period_check
	move	@period,a14,W
	cmpi	1,a14
	jrnz	qfc_n
qfc_y	setc
	rets
qfc_n	clrc
	rets

	.endif

**************************************************************************
*								         *
* freeze_message							 *
* 	input	a9  = player						 *
* 		a10 = freeze code					 *
*								         *
**************************************************************************
freeze_message_nt		;don't turn on or off small timer
	mmtm	sp,a0,a1,a7
	CREATE	PID_FROZEN_MESSAGE,frms_nt
	mmfm	sp,a0,a1,a7
	rets
freeze_message
	mmtm	sp,a0,a1,a7
	CREATE	PID_FROZEN_MESSAGE,frms
	mmfm	sp,a0,a1,a7
	rets

frms_nt	JSRP	frms_sb
	jauc	SUCIDE

frms	clr	a0
	move	a0,@small_timer_on
	JSRP	frms_sb
	move	@timer_on,a14,W
	jrnz	nolto
	movk	1,a0
	move	a0,@small_timer_on,W
nolto	jauc	SUCIDE

frms_sb	movk	1,a0
	move	a0,@game_frozen,W
	move	@PUCK_CONTROL,a0,W
	jrz	fruu1
	GBLOCK	a0,a6
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	fruu1		;puck carrier is drone
	move	*a6(POF_ARROW),a8,L
	jrz	fruu1
	movi	DMAWNZ,a4
	move	*a8(OIMG),a1,L
	calla	maybe_ani
fruu1	SLEEP	1
	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	MOVI	FROZE_HELP_PAL_LIST,A0
	calla	FROZE_FADE_FULL2HALF
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS
	sll	6,a10
	addi	freeze_type_list-64,a10
	move	*a10+,a14,L
	call	a14		;get location (in 2,3,4)
	move	*a10,a14,L
	call	a14		;create objects 
	JSRP	watch_button_delay_pa9
	movi	OID_FROZEN_MESSAGE,a0
	calla	KILOBJ_ALL
	MOVI	99,A14
	MOVE	A14,@MAX_PALXFERS,W
	MOVI	FROZE_HELP_PAL_LIST,A0
	calla	FROZE_FADE_HALF2FULL
	JSRP	FADE_WAIT
	CALLA	RESET_MAX_PALXFERS
	clr	a0
	move	a0,@game_frozen,W
	RETP

FROZE_HELP_PAL_LIST
	.long   FREEBOXP
	.LONG	arrp_pal,arrb_pal,arry_pal,arrg_pal
	.long	0

watch_button_delay_pa9
	cmpi	4,a9
	jrz	wbd_tm1
	cmpi	8,a9
	jrz	wbd_tm2
	calla	read_just_buttons
	move	a2,a10
	not	a10
	SLEEP	20
	movi	70,a11
wbdp1	calla	read_just_buttons
	and	a2,a10
	jrnz	wbd_8
	move	a2,a10
	not	a10
	SLEEP	1
	dsjs	a11,wbdp1
wbd_8	RETP

wbd_tm1	callr	read_t1_buttons
	move	a2,a10
	not	a10
	SLEEP	20
	movi	150,a11
wbd1p1	callr	read_t1_buttons
	and	a2,a10
	jrnz	wbd1_8
	move	a2,a10
	not	a10
	SLEEP	1
	dsjs	a11,wbd1p1
wbd1_8	RETP

wbd_tm2	callr	read_t2_buttons
	move	a2,a10
	not	a10
	SLEEP	20
	movi	150,a11
wbd2p1	callr	read_t2_buttons
	and	a2,a10
	jrnz	wbd2_8
	move	a2,a10
	not	a10
	SLEEP	1
	dsjs	a11,wbd2p1
wbd2_8	RETP

read_t1_buttons
	movk	1,a9
	callr	read_if_just_buttons
	sll	3,a2
	move	a2,a3
	movk	2,a9
	callr	read_if_just_buttons
	or	a3,a2
	rets

read_t2_buttons
	movk	5,a9
	callr	read_if_just_buttons
	sll	3,a2
	move	a2,a3
	movk	6,a9
	callr	read_if_just_buttons
	or	a3,a2
	rets

read_if_just_buttons
	clr	a2
	GBLOCK	a9,a14
	move	*a14(POF_FLAGS),a14,W
	btst	B_PF_HUMAN,a14
	jrz	rijb9
	calla	read_just_buttons
rijb9	rets

frblink_player
	GBLOCK	a9,a11
	move	*a11(POF_OBJECT),a8,L
frbl1	move	*a11(POF_TRAIL_PAL),a0,L
	calla	CHANGE_PAL
	SLEEP	4
	move	*a11(POF_NORMALPAL),a0,L
	calla	CHANGE_PAL
	SLEEP	4
	jruc	frbl1

freeze_type_list
	.long	get_edge_to_player,create_offscreen	;player is off screen
	.long	get_above_player,create_shootfar	;player is shooting from far away
	.long	get_above_player,create_shootpass	;player is not shooting or passing
	.long	get_above_player,create_drone_shootpass	;player is not telling his drone to do anything
	.long	get_above_player,create_turbo		;player is not using turbo
	.long	get_above_player,create_smotherpass	;player is letting goalie smother puck

get_edge_to_player
	GBLOCK	a9,a8
	move	*a8(POF_OBJECT),a8,L
	move	*a8(OXVAL),a5,L
	move	*a8(OZVAL),a3,L
	movi	[-40,0],a4
	cmpi	[339,0],a3
	jrhi	gety1
	movi	[-85,0],a4
gety1	subi	[2350,0],a3		;put us in front
	movi	[140,0],a2
	move	@WORLDX,a14,L
	cmp	a5,a14
	jrlt	getp1
	neg	a2
getp1	add	a14,a2
	rets

get_above_player
	GBLOCK	a9,a8
	move	*a8(POF_OBJECT),a8,L
	move	*a8(OXVAL),a2,L
	move	@WORLDX,a14,L
	sub	a2,a14
	abs	a14
	cmpi	[150,0],a14
	jrgt	get_edge_to_player
	move	*a8(OZVAL),a3,L
	move	a3,a14
	subi	[2350,0],a3		;put us in front
	move	*a8(OSIZEY),a4,W
	addi	40,a4		;9
	sll	16,a4
	neg	a4
;	cmpi	[290,0],a14
	cmpi	[300,0],a14	;try to keep us off bottom of screen
	jrlt	gap_1
	movi	[4,0],a4
gap_1	rets

create_offscreen
	movi	mh_offscreen_init,b0
	movi	mh_helpbox3_init,a5
	jruc	regpbox

create_shootfar
	movi	mh_shootfar_init,b0
	movi	mh_helpbox3_init,a5
	jruc	regpbox

create_shootpass
	movi	mh_shootpass_init,b0
	movi	mh_helpbox4_init,a5
	jruc	regpbox

create_drone_shootpass
	movi	mh_drone_shootpass_init,b0
	movi	mh_helpbox2_init,a5
	jruc	regpbox

create_turbo
	movi	mh_turbo_init,b0
	movi	mh_helpbox1_init,a5
regpbox
	MOVE	A9,@HELP_PNUM,W			;PLAYER NUMBER FOR C_FUNCS
	callr	rgtr
	cmpi	4,a9
	jrz	rskn
	cmpi	8,a9
	jrz	rskn
	movi	dum_num_init,b0
	calla	EASYMAKE
	movi	GFONT10CP,a0
	calla	CHANGE_PAL

	move	a9,A0
	sll	5,A0

	MOVI	num_tab-32,A1
	KITN	4
	JREQ	R_GET_NUM			;BR=4 PLAYER KIT
	MOVI	num_2P_tab-32,A1		;2 PLAYER KIT
R_GET_NUM
	ADD	A0,A1

	move	*a1,a1,L
	mmtm	sp,a4
	move	*a8(OCTRL),a4,W
	calla	ANI
	mmfm	sp,a4

	ADDI	HELP_TEXT_PAL_TABLE-32,A0
	MOVE	*A0,A0,L
	CALLA	CHANGE_PAL

;	addi	[31,0],a2
;	addi	[7,0],a4
	callr	rgtpl
;	subi	[31,0],a2
;	subi	[7,0],a4
rskn	move	a5,b0
	inc	a3
rgtr
;	calla	EASYMAKE

	MMTM	SP,A2,A3,A4
	CALLA	MULTIMAKE
	MMFM	SP,A2,A3,A4

rgtpl
;	move	a2,*a8(OXVAL),L
;	move	a3,*a8(OZVAL),L
;	move	a4,*a8(OYVAL),L

	MOVE	A8,A0
RGTPL_LUPE
	MOVE	A2,*A0(OXVAL),L
	MOVB	*A0(OZOFF),A14
	ADD	A3,A14
	MOVE	A14,*A0(OZVAL),L
	MOVE	A4,*A0(OYVAL),L
	MOVE	*A0(OPARTS),A0,L
	JRNZ	RGTPL_LUPE			;BR=ANOTHER PART

	jauc	INSERT_OBJ

**************************************************************************
*								         *
* C_CHANGE_PPAL - CHANGE TO PLAYER PALETTE CFUNC			 *
* 									 *
* REQUIRES								 *
* 	.LONG	PALETTE TABLE						 *
*								         *
**************************************************************************

C_CHANGE_PPAL
	PUSH	A8
	MOVE	A0,A8

	MOVE	*B0+,B14,L			;GET TABLE
	MOVE	B14,A14

	MOVE	@HELP_PNUM,A0,W
	DEC	A0
	SLL	5,A0				;TABLE OFFSET
	ADD	A14,A0
	MOVE	*A0,A0,L			;GET PALETTE

	CALLA	CHANGE_PAL

	PULLQ	A8
	RETS
	
num_tab	.long	HNUM1
	.long	HNUM2
	.long	HNUM2
	.long	HNUM2
	.long	HNUM3
	.long	HNUM4
	.long	HNUM4
	.long	HNUM4

num_2P_tab
	.long	HNUM1
	.long	HNUM2
	.long	HNUM2
	.long	HNUM2
	.long	HNUM2
	.long	HNUM2
	.long	HNUM2
	.long	HNUM2

HELP_TEXT_PAL_TABLE
	.LONG	PRPTXT3P
	.LONG	BLUTXT3P
	.LONG	BLUTXT3P
	.LONG	BLUTXT3P
	.LONG	GLDTXT1P
	.LONG	GRNTXT3P
	.LONG	GRNTXT3P
	.LONG	REDTXT3P

HELP_FRAME_PAL_TABLE
	.LONG	PRPFRMP
	.LONG	BLUFRMP
	.LONG	BLUFRMP
	.LONG	BLUFRMP
	.LONG	GLDFRMP
	.LONG	GRNFRMP
	.LONG	GRNFRMP
	.LONG	REDFRMP

create_smotherpass
	movi	mh_smotherpass_init,b0
	movi	mh_helpbox4_init,a5
	jruc	regpbox

;mh_helpbox1_init
;	.long	HELPBX1
;	.word	DMAWNZ,M_NOSCALE|M_NOVEL
;	.word	OM_OID
;	.word	OID_FROZEN_MESSAGE
;
;mh_helpbox2_init
;	.long	HELPBX2
;	.word	DMAWNZ,M_NOSCALE|M_NOVEL
;	.word	OM_OID
;	.word	OID_FROZEN_MESSAGE
;
;mh_helpbox3_init
;	.long	HELPBX3
;	.word	DMAWNZ,M_NOSCALE|M_NOVEL
;	.word	OM_OID
;	.word	OID_FROZEN_MESSAGE
;
;mh_helpbox4_init
;	.long	HELPBX4
;	.word	DMAWNZ,M_NOSCALE|M_NOVEL
;	.word	OM_OID
;	.word	OID_FROZEN_MESSAGE

mh_helpbox1_init
	.byte	2, 0, 0, 2	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GRYBLOCKP	;IMGPAL
	.long	HELPBK2P	;IMGPAL
	.word	OID_FROZEN_MESSAGE, 0	;OID, GLOBAL_OPTIONS
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	HELPBX1, DMAWNZ, M_NOSCALE|M_NOVEL, 0, OM_CFUNC
	.LONG	C_CHANGE_PPAL
	.LONG	HELP_FRAME_PAL_TABLE
	LWWWW	HELPBK1, DMAWNZ, M_NOSCALE|M_NOVEL, 1, 0

mh_helpbox2_init
	.byte	2, 0, 0, 2	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GRYBLOCKP	;IMGPAL
	.long	HELPBK2P	;IMGPAL
	.word	OID_FROZEN_MESSAGE, 0	;OID, GLOBAL_OPTIONS
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	HELPBX2, DMAWNZ, M_NOSCALE|M_NOVEL, 0, OM_CFUNC
	.LONG	C_CHANGE_PPAL
	.LONG	HELP_FRAME_PAL_TABLE
	LWWWW	HELPBK2, DMAWNZ, M_NOSCALE|M_NOVEL, 1, 0

mh_helpbox3_init
	.byte	2, 0, 0, 2	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GRYBLOCKP	;IMGPAL
	.long	HELPBK2P	;IMGPAL
	.word	OID_FROZEN_MESSAGE, 0	;OID, GLOBAL_OPTIONS
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	HELPBX3, DMAWNZ, M_NOSCALE|M_NOVEL, 0, OM_CFUNC
	.LONG	C_CHANGE_PPAL
	.LONG	HELP_FRAME_PAL_TABLE
	LWWWW	HELPBK3, DMAWNZ, M_NOSCALE|M_NOVEL, 1, 0

mh_helpbox4_init
	.byte	2, 0, 0, 2	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GRYBLOCKP	;IMGPAL
	.long	HELPBK2P	;IMGPAL
	.word	OID_FROZEN_MESSAGE, 0	;OID, GLOBAL_OPTIONS
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	HELPBX4, DMAWNZ, M_NOSCALE|M_NOVEL, 0, OM_CFUNC
	.LONG	C_CHANGE_PPAL
	.LONG	HELP_FRAME_PAL_TABLE
	LWWWW	HELPBK4, DMAWNZ, M_NOSCALE|M_NOVEL, 1, 0

;mh_offscreen_init
;	.long	HLPJOYS1
;	.word	DMAWNZ,M_NOSCALE|M_NOVEL
;	.word	OM_OID
;	.word	OID_FROZEN_MESSAGE
;
;mh_shootfar_init
;	.long	HLPSHOT1
;	.word	DMAWNZ,M_NOSCALE|M_NOVEL
;	.word	OM_OID
;	.word	OID_FROZEN_MESSAGE
;
;mh_shootpass_init
;	.long	HLPBUTN1
;	.word	DMAWNZ,M_NOSCALE|M_NOVEL
;	.word	OM_OID
;	.word	OID_FROZEN_MESSAGE
;
;mh_drone_shootpass_init
;	.long	HLPCPU1
;	.word	DMAWNZ,M_NOSCALE|M_NOVEL
;	.word	OM_OID
;	.word	OID_FROZEN_MESSAGE
;
;mh_turbo_init
;	.long	HLPTRBO1
;	.word	DMAWNZ,M_NOSCALE|M_NOVEL
;	.word	OM_OID
;	.word	OID_FROZEN_MESSAGE

mh_offscreen_init
	.byte	2, 0, 0, 2	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GFONT10CP	;IMGPAL
	.long	INSTRUCP	;IMGPAL
	.word	OID_FROZEN_MESSAGE, 0	;OID, GLOBAL_OPTIONS
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	PLAYERN, DMAWNZ, M_NOSCALE|M_NOVEL, 0, OM_CFUNC
	.LONG	C_CHANGE_PPAL
	.LONG	HELP_TEXT_PAL_TABLE
	LWWWW	HLPJOYS1, DMAWNZ, M_NOSCALE|M_NOVEL, 0, 0

mh_shootfar_init
	.byte	2, 0, 0, 2	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GFONT10CP	;IMGPAL
	.long	INSTRUCP	;IMGPAL
	.word	OID_FROZEN_MESSAGE, 0	;OID, GLOBAL_OPTIONS
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	PLAYERN, DMAWNZ, M_NOSCALE|M_NOVEL, 0, OM_CFUNC
	.LONG	C_CHANGE_PPAL
	.LONG	HELP_TEXT_PAL_TABLE
	LWWWW	HLPSHOT1, DMAWNZ, M_NOSCALE|M_NOVEL, 0, 0

mh_shootpass_init
	.byte	2, 0, 0, 2	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GFONT10CP	;IMGPAL
	.long	INSTRUCP	;IMGPAL
	.word	OID_FROZEN_MESSAGE, 0	;OID, GLOBAL_OPTIONS
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	PLAYERN, DMAWNZ, M_NOSCALE|M_NOVEL, 0, OM_CFUNC
	.LONG	C_CHANGE_PPAL
	.LONG	HELP_TEXT_PAL_TABLE
	LWWWW	HLPBUTN1, DMAWNZ, M_NOSCALE|M_NOVEL, 0, 0

mh_drone_shootpass_init
	.byte	2, 0, 0, 2	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GFONT10CP	;IMGPAL
	.long	INSTRUCP	;IMGPAL
	.word	OID_FROZEN_MESSAGE, 0	;OID, GLOBAL_OPTIONS
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	PLAYERN, DMAWNZ, M_NOSCALE|M_NOVEL, 0, OM_CFUNC
	.LONG	C_CHANGE_PPAL
	.LONG	HELP_TEXT_PAL_TABLE
	LWWWW	HLPCPU1, DMAWNZ, M_NOSCALE|M_NOVEL, 0, 0

mh_turbo_init
	.byte	2, 0, 0, 2	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	GFONT10CP	;IMGPAL
	.long	INSTRUCP	;IMGPAL
	.word	OID_FROZEN_MESSAGE, 0	;OID, GLOBAL_OPTIONS
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	PLAYERN, DMAWNZ, M_NOSCALE|M_NOVEL, 0, OM_CFUNC
	.LONG	C_CHANGE_PPAL
	.LONG	HELP_TEXT_PAL_TABLE
	LWWWW	HLPTRBO1, DMAWNZ, M_NOSCALE|M_NOVEL, 0, 0

dum_num_init
	.long	HLPGOAL1
	.word	DMAWNZ,M_NOSCALE|M_NOVEL
	.word	OM_OID
	.word	OID_FROZEN_MESSAGE

mh_smotherpass_init
	.byte	1, 0, 0, 1	;OBJCNT, PRCCNT, IMGPALCNT, PALCNT
	.long	INSTRUCP	;IMGPAL
	.word	OID_FROZEN_MESSAGE, 0	;OID, GLOBAL_OPTIONS
*        .long IMG
*        .word OCTRL, OFLAGS, OZOFF
*        .word OPTIONS

	LWWWW	HLPGOAL1, DMAWNZ, M_NOSCALE|M_NOVEL, 0, 0

**************************************************************************
*								         *
* PUCK_PTR_PROC - POINT TO STOPPED PUCK AFTER SOMETIME			 *
* 									 *
* PASS:									 *
* NUTIN'								 *
*								         *
**************************************************************************

PUCK_STOPPED_TIME	EQU	30 ;120		;MUST REMAIN STOPPED FOR THIS

PUCK_PTR_PROC
	MOVE	@PUCK_OBJECT,A9,L
PPP_WAIT
	SLEEP	10
	MOVE	*A9(ODT_VEL),A14,L
	JRNZ	PPP_WAIT			;BR=MOVIN' AROUND

	MOVE	@PUCK_CONTROL,A14,W
	JRNZ	PPP_WAIT			;BR=SOMEBODY GOTS IT

	MOVE	@PUCK_MODE,A14,W
	JRNZ	PPP_WAIT			;BR=NOT OPEN

	MOVE	@WAVEIRQS,A8,L
PPP_STOPPED_WAIT
	SLEEP	1
	MOVE	@PUCK_CONTROL,A14,W
	JRNZ	PPP_WAIT			;BR=SOMEBODY GOTS IT

	MOVE	@PUCK_MODE,A14,W
	JRNZ	PPP_WAIT			;BR=NOT OPEN

	MOVE	*A9(ODT_VEL),A14,L
	JRNZ	PPP_WAIT			;BR=STARTED MOVIN' AGAIN

	MOVE	@WAVEIRQS,A14,L
	SUB	A8,A14
	CMPI	PUCK_STOPPED_TIME,A14
	JRLT	PPP_STOPPED_WAIT		;BR=NOT LONG ENOUGH		

;	MOVE	*A9(ODAG),A3,L

	MOVE	*A9(OXVAL),A3,L

	MOVE	*A9(OZVAL),A2,L

	MOVE	@BIG_PUCK,A14,W
	JRZ	PPP_MAKE_BIGPUCK		;BR=NORMAL PUCK
	ADDI	040000H,A3

PPP_MAKE_BIGPUCK
	MOVI	BIGPUCK_PTR_INIT,B0
	CALLA	EASYMAKE
	JRZ	PPP_WAIT			;BR=NO FREE OBJECTS

;	MOVE	A3,A1
;	ADDI	[-52,4],A1
;	MOVE	@BIG_PUCK,A4,W
;	JRZ	PPP_SET_PTR			;BR=NORMAL PUCK
;	ADDK	4,A1
;PPP_SET_PTR
;	CALLA	SET_SCRNOBJ

	MOVI	-0380000H,A14
	MOVE	A14,*A8(OYVAL),L
	MOVE	A3,*A8(OXVAL),L
	MOVE	A2,*A8(OZVAL),L

	CALLA	INSERT_OBJ
	MOVE	A8,A10

	MOVI	PUCK_PTR_INIT,B0
	CALLA	EASYMAKE
	JRZ	PPP_PTR_DELETE			;BR=NO FREE OBJECTS

;	MOVE	A3,A1
;	ADDK	[0,4],A1
;	MOVE	A4,A4
;	JRZ	PPP_SET_PUCK			;BR=NORMAL PUCK
;	ADDK	4,A1
;PPP_SET_PUCK
	INC	A2
;	CALLA	SET_SCRNOBJ

	MOVI	-020000H,A14
	MOVE	A14,*A8(OYVAL),L
	MOVE	A3,*A8(OXVAL),L
	MOVE	A2,*A8(OZVAL),L

	CALLA	INSERT_OBJ

	MOVE	A8,*A10(OPART1),L
	MOVE	A8,*A8(OPART1),L
	MOVE	A10,*A8(OPARTS),L

PPP_PTR_WAIT
	SLEEP	1
	MOVE	@PUCK_CONTROL,A14,W
	JRNZ	PPP_PTR_DELETE			;BR=NOBODY GOTS IT

	MOVE	@PUCK_MODE,A14,W
	JRNZ	PPP_PTR_DELETE			;BR=NOT OPEN

	MOVE	*A9(ODT_VEL),A14,L
	JRZ	PPP_PTR_WAIT			;BR=NOT MOVIN'

PPP_PTR_DELETE
	CALLA	DELETE_OBJ

	JRUC	PPP_WAIT

PUCK_PTR_INIT
	.long	PUCKPNTR1
;	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	DMAWNZ,M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_ANIM
	.word	OID_PUCK_PTR
	.long	PUCK_PTR_ANIM

BIGPUCK_PTR_INIT
	.long	NMPUCK01
;	.word	DMAWNZ,M_SCRNOBJ|M_NOSCALE|M_NOVEL
	.word	DMAWNZ,M_NOSCALE|M_NOVEL
	.word	OM_OID|OM_ANIM
	.word	OID_PUCK_PTR
	.long	BIGPUCK_PTR_ANIM

PUCK_PTR_ANIM
;	LWL	1,10|AFUNC,OBJ_ON
;	LWL	1,10|AFUNC,OBJ_OFF

	LWLLLW	1,11|AFUNC,A_2FUNCS+5,OBJ_ON,A_DO_SOUND,S_PUCK_POINT
	LWL	1,11|AFUNC,OBJ_OFF
	.long	0

BIGPUCK_PTR_ANIM
	LW	NMPUCK01,4
	LW	NMPUCK02,4
	LW	NMPUCK03,4
	LW	NMPUCK04,4
	LW	NMPUCK05,4
	LW	NMPUCK06,4
	LW	NMPUCK07,4
	LW	NMPUCK08,4
	LW	NMPUCK09,4
	.long	0
