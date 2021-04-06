 	.MLIB	"HHMACS.LIB"
	.FILE	"HHSCRIPT.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.INCLUDE	"PLAYER.TBL"
	.INCLUDE	"hhscript.tbl"
	.include	"hhscript.e"
	.include	"hhd.g"
	.include	"hhpuck.g"
	.include	"hhplayer.g"
	.include	"hhcontrl.g"
	.include	"hhc.g"
	.include	"hhshow.g"

; end of include files

	.TEXT
	.EVEN

**************************************************************************
*								         *
* for player objects, OIMG looks like this				 *
* 	.word	control,xsize,ysize					 *
* 	.long	sag							 *
* 	.word	anix,aniy						 *
* 	.long	pal							 *
* 	.word	puckx,pucky						 *
* 	.word	headx,heady,headz					 *
* 	.word	head#							 *
*								         *
**************************************************************************


start_head_script
	movi	anim_head,a1
	jruc	start_anim_if_not

anim_head
	LWL	1,AFunc|1,a_head_animate
	.long	0

a_head_animate
	rets
	move	*a8(OPART1),a7,L	;a7 is object of body
ahaop	move	*a7(OSCALE),a6,L
;	cmpi	BOGUS_SCL,a6
;	jrz	aha_9
	move	*a7(ODT_PBK),a6,L	;a6 is player block
	move	*a7(OIMG),a10,L		;a10 is image data
	move	*a10(050h),a14,W	;animation point of image (x)
	move	*a10(0b0h),a3,W		;animation point of head (x)
	sub	a14,a3			;a3 is x animation point
	move	*a7(OSCTAB),a0,L
	move	*a0,a1,W		;a1 is x scale at full image (base world scale for body)
	sll	8,a3
	divs	a1,a3
	move	a3,a2			;a2 = scaled x animation point
	move	*a10(060h),a14,W	;animation point of image (y)
	move	*a10(0c0h),a3,W		;animation point of head (y)
	sub	a14,a3			;a3 is y animation point
	move	*a7(OZPOS),a1,W		;index into table from z
	sll	5,a1
	add	a0,a1
	move	*a1(010h),a1,W		;a1 = y scale at z image (y coordinates do not scale on their own)
	sll	8,a3
	divs	a1,a3			;a3 = scaled y animation point
	move	*a7(OXPOS),a0,W
	move	*a7(OYPOS),a1,W
	move	*a7(OCTRL),a4,W		;new octrl = octrl from head
	btst	B_FLIPH,a4
	jrz	aha_1
	neg	a2
aha_1	btst	B_FLIPV,a4
	jrz	aha_2
	neg	a3
aha_2	add	a2,a0
	add	a3,a1
	move	a0,*a8(OXPOS),W		;store x
	move	a1,*a8(OYPOS),W		;store y
	move	*a7(OZVAL),a0,L
	move	*a10(0d0h),a14,W	;z offset
;	add	a14,a0
	sub	a14,a0			;right now, because bball is backwards
	move	a0,*a8(OZVAL),L
	move	*a10(0e0h),a0,W		;head #
	sll	5,a0
	move	*a6(POF_HEAD_TABLE),a14,L
	add	a0,a14
	move	*a14,a1,L		;new image pointer
	movi	BOGUS_SCL,a14
	move	a14,*a8(OSCALE),L
	move	*a7(OXVEL),*a8(OXVEL),L
	move	*a7(OYVEL),*a8(OYVEL),L
	move	*a7(OZVEL),*a8(OZVEL),L
	jauc	ANI
aha_9	rets

start_anim_if_not
	mmtm	sp,a0
	move	*a8(AnimScr),a0,L
	cmp	a1,a0
	jrz	sain_9
	calla	STRT_ANIM
sain_9	mmfm	sp,a0
	rets

set_face_off_script
	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	addi	sfos_tab-32,a0
	move	*a0,a1,L
	jruc	start_anim_if_not

sfos_tab
	.long	anim_face_off_3
	.long	anim_face_off_3
	.long	anim_face_off_3
	.long	anim_face_off_3
	.long	anim_face_off_7
	.long	anim_face_off_7
	.long	anim_face_off_7
	.long	anim_face_off_7

set_free_skate_script
	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	addi	sfss_tab-32,a0
	move	*a0,a1,L
	jruc	start_anim_if_not

sfss_tab
	.long	anim_free_skate_1
	.long	anim_free_skate_2
	.long	anim_free_skate_3
	.long	anim_free_skate_4
	.long	anim_free_skate_5
	.long	anim_free_skate_6
	.long	anim_free_skate_7
	.long	anim_free_skate_8

set_gstand_script
	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	addi	sgss_tab-32,a0
	move	*a0,a1,L
	jruc	start_anim_if_not

sgss_tab
	.long	anim_gstand_3
	.long	anim_gstand_3
	.long	anim_gstand_3
	.long	anim_gstand_3
	.long	anim_gstand_7
	.long	anim_gstand_7
	.long	anim_gstand_7
	.long	anim_gstand_7

set_stand_script
	calla	give_player_control
	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	addi	sss_tab-32,a0
	move	*a0,a1,L
	jruc	start_anim_if_not

sss_tab
	.long	anim_stand_1
	.long	anim_stand_2
	.long	anim_stand_3
	.long	anim_stand_4
	.long	anim_stand_5
	.long	anim_stand_6
	.long	anim_stand_7
	.long	anim_stand_8

set_run_script
	calla	give_player_control
	move	*a6(POF_SPEED_GL),a14,L
	move	*a8(ODT_VEL),a0,L
	sub	a14,a0
	cmpi	[1,08000h],a0
	jrgt	set_coast_script	;if we are slowing down, use different script
srss1	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	addi	srs_tab-32,a0
	move	*a0,a1,L
	jruc	start_anim_if_not

srs_tab
	.long	anim_run_1
	.long	anim_run_2
	.long	anim_run_3
	.long	anim_run_4
	.long	anim_run_5
	.long	anim_run_6
	.long	anim_run_7
	.long	anim_run_8

set_skid_script
	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	addi	ssks_tab-32,a0
	move	*a0,a1,L
	jruc	start_anim_if_not

ssks_tab
	.long	anim_skid_1
	.long	anim_skid_2
	.long	anim_skid_3
	.long	anim_skid_4
	.long	anim_skid_5
	.long	anim_skid_6
	.long	anim_skid_7
	.long	anim_skid_8


set_steal_script
	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	addi	ssls_tab-32,a0
	move	*a0,a1,L
	jruc	start_anim_if_not

ssls_tab
	.long	anim_steal_1
	.long	anim_steal_2
	.long	anim_steal_3
	.long	anim_steal_4
	.long	anim_steal_5
	.long	anim_steal_6
	.long	anim_steal_7
	.long	anim_steal_8

set_fall_script
	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	addi	ssfs_tab-32,a0
	move	*a0,a1,L
	jruc	start_anim_if_not

ssfs_tab
	.long	anim_fall_2
	.long	anim_fall_8
	.long	anim_fall_8
	.long	anim_fall_6
	.long	anim_fall_6
	.long	anim_fall_4
	.long	anim_fall_4
	.long	anim_fall_2

set_push_script
	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	addi	ssps_tab-32,a0
	move	*a0,a1,L
	jruc	start_anim_if_not

ssps_tab
	.long	anim_push_1
	.long	anim_push_2
	.long	anim_push_3
	.long	anim_push_4
	.long	anim_push_5
	.long	anim_push_6
	.long	anim_push_7
	.long	anim_push_8

set_shoot_script
	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	addi	sshs_tab-32,a0
	move	*a0,a1,L
	jruc	start_anim_if_not

sshs_tab
	.long	anim_shoot_1
	.long	anim_shoot_2
	.long	anim_shoot_3
	.long	anim_shoot_4
	.long	anim_shoot_5
	.long	anim_shoot_6
	.long	anim_shoot_7
	.long	anim_shoot_8

set_turbo_shoot_script
	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	addi	ssths_tab-32,a0
	move	*a0,a1,L
	jruc	start_anim_if_not

ssths_tab
	.long	anim_tshoot_1
	.long	anim_tshoot_2
	.long	anim_tshoot_3
	.long	anim_tshoot_4
	.long	anim_tshoot_5
	.long	anim_tshoot_6
	.long	anim_tshoot_7
	.long	anim_tshoot_8

set_coast_script
	movb	*a6(POF_DIRECTION),a0
	sll	5,a0
	addi	scs_tab-32,a0
	move	*a0,a1,L
	jruc	start_anim_if_not

scs_tab
	.long	anim_coast_1
	.long	anim_coast_2
	.long	anim_coast_3
	.long	anim_coast_4
	.long	anim_coast_5
	.long	anim_coast_6
	.long	anim_coast_7
	.long	anim_coast_8

anim_face_off_3
	LWW	SKSCLE02,AFlip|8,0
	LW	SKSCLE02,8
	.long	0
anim_face_off_7
	LWW	SKSCLE02,AFlip|8,M_FLIPH
	LW	SKSCLE02,8
	.long	0

anim_free_skate_1
	LW	SKSCLE02,8
	.long	0
anim_free_skate_2
	LWW	SKSCLE02,AFlip|8,0
	.long	0
anim_free_skate_3
	LWW	SKSCLE02,AFlip|8,0
	.long	0
anim_free_skate_4
	LWW	SKSCLE02,AFlip|8,0
	.long	0
anim_free_skate_5
	LW	SKSCLE02,8
	.long	0
anim_free_skate_6
	LWW	SKSCLE02,AFlip|8,M_FLIPH
	.long	0
anim_free_skate_7
	LWW	SKSCLE02,AFlip|8,M_FLIPH
	.long	0
anim_free_skate_8
	LWW	SKSCLE02,AFlip|8,M_FLIPH
	.long	0

anim_gstand_3
	LWW	SKSCLE02,AFlip|6,0
	.long	0

anim_gstand_7
	LWW	SKSCLE02,AFlip|6,M_FLIPH
	.long	0

anim_skid_1
	LW	SKSCLE02,10
	.long	0
anim_skid_2
	LWW	SKSCLE02,AFlip|10,0
	.long	0
anim_skid_3
	LWW	SKSCLE02,AFlip|10,0
	.long	0
anim_skid_4
	LWW	SKSCLE02,AFlip|10,0
	.long	0
anim_skid_5
	LW	SKSCLE02,10
	.long	0
anim_skid_6
	LWW	SKSCLE02,AFlip|10,M_FLIPH
	.long	0
anim_skid_7
	LWW	SKSCLE02,AFlip|10,M_FLIPH
	.long	0
anim_skid_8
	LWW	SKSCLE02,AFlip|10,M_FLIPH
	.long	0

anim_stand_1
	LW	SKSCLE02,3
	.long	0
anim_stand_2
	LWW	SKSCLE02,AFlip|3,0
	.long	0
anim_stand_3
	LWW	SKSCLE02,AFlip|3,0
	.long	0
anim_stand_4
	LWW	SKSCLE02,AFlip|3,0
	.long	0
anim_stand_5
	LW	SKSCLE02,3
	.long	0
anim_stand_6
	LWW	SKSCLE02,AFlip|3,M_FLIPH
	.long	0
anim_stand_7
	LWW	SKSCLE02,AFlip|3,M_FLIPH
	.long	0
anim_stand_8
	LWW	SKSCLE02,AFlip|3,M_FLIPH
	.long	0

anim_run_1
	LW	SKSCLE02,3
	LW	SKSCLE03,3
	LW	SKSCLE04,3
	LW	SKSCLE05,3
	LW	SKSCLE06,3
	LW	SKSCLE07,3
	LW	SKSCLE08,3
	LW	SKSCLE09,3
	LW	SKSCLE10,3
	LW	SKSCLE11,3
	.long	0


anim_run_2
	LWW	SKSCLE02,AFlip|3,0
	LW	SKSCLE03,3
	LW	SKSCLE04,3
	LW	SKSCLE05,3
	LW	SKSCLE06,3
	LW	SKSCLE07,3
	LW	SKSCLE08,3
	LW	SKSCLE09,3
	LW	SKSCLE10,3
	LW	SKSCLE11,3
	.long	0
anim_run_3
	LWW	SKSCLE02,AFlip|3,0
	LW	SKSCLE03,3
	LW	SKSCLE04,3
	LW	SKSCLE05,3
	LW	SKSCLE06,3
	LW	SKSCLE07,3
	LW	SKSCLE08,3
	LW	SKSCLE09,3
	LW	SKSCLE10,3
	LW	SKSCLE11,3
	.long	0

anim_run_4
	LWW	SKSCLE02,AFlip|3,0
	LW	SKSCLE03,3
	LW	SKSCLE04,3
	LW	SKSCLE05,3
	LW	SKSCLE06,3
	LW	SKSCLE07,3
	LW	SKSCLE08,3
	LW	SKSCLE09,3
	LW	SKSCLE10,3
	LW	SKSCLE11,3
	.long	0
anim_run_5
	LW	SKSCLE02,3
	LW	SKSCLE03,3
	LW	SKSCLE04,3
	LW	SKSCLE05,3
	LW	SKSCLE06,3
	LW	SKSCLE07,3
	LW	SKSCLE08,3
	LW	SKSCLE09,3
	LW	SKSCLE10,3
	LW	SKSCLE11,3
	.long	0
anim_run_6
	LWW	SKSCLE02,AFlip|3,M_FLIPH
	LW	SKSCLE03,3
	LW	SKSCLE04,3
	LW	SKSCLE05,3
	LW	SKSCLE06,3
	LW	SKSCLE07,3
	LW	SKSCLE08,3
	LW	SKSCLE09,3
	LW	SKSCLE10,3
	LW	SKSCLE11,3
	.long	0
anim_run_7
	LWW	SKSCLE02,AFlip|3,M_FLIPH
	LW	SKSCLE03,3
	LW	SKSCLE04,3
	LW	SKSCLE05,3
	LW	SKSCLE06,3
	LW	SKSCLE07,3
	LW	SKSCLE08,3
	LW	SKSCLE09,3
	LW	SKSCLE10,3
	LW	SKSCLE11,3
	.long	0

anim_run_8
	LWW	SKSCLE02,AFlip|3,M_FLIPH
	LW	SKSCLE03,3
	LW	SKSCLE04,3
	LW	SKSCLE05,3
	LW	SKSCLE06,3
	LW	SKSCLE07,3
	LW	SKSCLE08,3
	LW	SKSCLE09,3
	LW	SKSCLE10,3
	LW	SKSCLE11,3
	.long	0

anim_shoot_1
	LW	SKSCLE02,8
	LWL	1,AFunc|4,a_shoot_done
	.long	0
anim_shoot_2
	LWW	SKSCLE02,AFlip|8,0
	LWL	1,AFunc|4,a_shoot_done
	.long	0
anim_shoot_3
	LWW	SKSCLE02,AFlip|8,0
	LWL	1,AFunc|4,a_shoot_done
	.long	0
anim_shoot_4
	LWW	SKSCLE02,AFlip|8,0
	LWL	1,AFunc|4,a_shoot_done
	.long	0
anim_shoot_5
	LW	SKSCLE02,8
	LWL	1,AFunc|4,a_shoot_done
	.long	0
anim_shoot_6
	LWW	SKSCLE02,AFlip|8,M_FLIPH
	LWL	1,AFunc|4,a_shoot_done
	.long	0
anim_shoot_7
	LWW	SKSCLE02,AFlip|8,M_FLIPH
	LWL	1,AFunc|4,a_shoot_done
	.long	0
anim_shoot_8
	LWW	SKSCLE02,AFlip|8,M_FLIPH
	LWL	1,AFunc|4,a_shoot_done
	.long	0

a_shoot_done
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	shoot_script_done

anim_tshoot_1
	LW	SKSCLE02,20
	LWL	1,AFunc|4,a_tshoot_done
	.long	0
anim_tshoot_2
	LWW	SKSCLE02,AFlip|20,0
	LWL	1,AFunc|4,a_tshoot_done
	.long	0
anim_tshoot_3
	LWW	SKSCLE02,AFlip|20,0
	LWL	1,AFunc|4,a_tshoot_done
	.long	0
anim_tshoot_4
	LWW	SKSCLE02,AFlip|20,0
	LWL	1,AFunc|4,a_tshoot_done
	.long	0
anim_tshoot_5
	LW	SKSCLE02,20
	LWL	1,AFunc|4,a_tshoot_done
	.long	0
anim_tshoot_6
	LWW	SKSCLE02,AFlip|20,M_FLIPH
	LWL	1,AFunc|4,a_tshoot_done
	.long	0
anim_tshoot_7
	LWW	SKSCLE02,AFlip|20,M_FLIPH
	LWL	1,AFunc|4,a_tshoot_done
	.long	0
anim_tshoot_8
	LWW	SKSCLE02,AFlip|20,M_FLIPH
	LWL	1,AFunc|4,a_tshoot_done
	.long	0

a_tshoot_done
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	jauc	turbo_shoot_script_done

anim_fall_2
	LWW	GH930A01,AFlip|2,0
	LW	GH930A02,2
	LW	GH930A03,2
	LW	GH930A04,2
	LW	GH930A05,2
	LW	GH930A06,2
	LW	GH930A07,2
	LW	GH930A08,2
	LWL	GH930A09,AFunc|2,a_fall_stopv
	LW	GH930A10,2
	LW	GH930A11,2
	LW	GH930A12,2
	LW	GH930A13,2
	LW	GH930A14,2
	LW	GH930A15,2
	LW	GH930A16,2
	LW	GH930A17,2
	LW	GH930A18,2
	LWL	1,AFunc|4,a_fall_done
	.long	0

anim_fall_4
	LWW	GH930A01,AFlip|2,0
	LW	GH930A02,2
	LW	GH930A03,2
	LW	GH930A04,2
	LW	GH930A05,2
	LW	GH930A06,2
	LW	GH930A07,2
	LW	GH930A08,2
	LWL	GH930A09,AFunc|2,a_fall_stopv
	LW	GH930A10,2
	LW	GH930A11,2
	LW	GH930A12,2
	LW	GH930A13,2
	LW	GH930A14,2
	LW	GH930A15,2
	LW	GH930A16,2
	LW	GH930A17,2
	LW	GH930A18,2
	LWL	1,AFunc|4,a_fall_done
	.long	0

anim_fall_6
	LWW	GH930A01,AFlip|2,M_FLIPH
	LW	GH930A02,2
	LW	GH930A03,2
	LW	GH930A04,2
	LW	GH930A05,2
	LW	GH930A06,2
	LW	GH930A07,2
	LW	GH930A08,2
	LWL	GH930A09,AFunc|2,a_fall_stopv
	LW	GH930A10,2
	LW	GH930A11,2
	LW	GH930A12,2
	LW	GH930A13,2
	LW	GH930A14,2
	LW	GH930A15,2
	LW	GH930A16,2
	LW	GH930A17,2
	LW	GH930A18,2
	LWL	1,AFunc|4,a_fall_done
	.long	0

anim_fall_8
	LWW	GH930A01,AFlip|2,M_FLIPH
	LW	GH930A02,2
	LW	GH930A03,2
	LW	GH930A04,2
	LW	GH930A05,2
	LW	GH930A06,2
	LW	GH930A07,2
	LW	GH930A08,2
	LWL	GH930A09,AFunc|2,a_fall_stopv
	LW	GH930A10,2
	LW	GH930A11,2
	LW	GH930A12,2
	LW	GH930A13,2
	LW	GH930A14,2
	LW	GH930A15,2
	LW	GH930A16,2
	LW	GH930A17,2
	LW	GH930A18,2
	LWL	1,AFunc|4,a_fall_done
	.long	0

a_fall_stopv
	clr	a0
	move	a0,*a8(ODT_VEL),L	;vector velocity
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OZVEL),L
	rets

a_fall_done
	move	*a8(ODT_PBK),a6,L	;get player block
	clr	a0
	move	a0,*a6(POF_MODE),L
	jauc	give_player_control

anim_steal_1
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	1,AFunc|3,a_steal_done
	.long	0

anim_steal_2
	LWWL	SKSCLE02,AFlip|AFunc|3,0,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	1,AFunc|3,a_steal_done
	.long	0

anim_steal_3
	LWWL	SKSCLE02,AFlip|AFunc|3,0,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	1,AFunc|3,a_steal_done
	.long	0

anim_steal_4
	LWWL	SKSCLE02,AFlip|AFunc|3,0,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	1,AFunc|3,a_steal_done
	.long	0

anim_steal_5
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|4,a_steal_check
	LWL	SKSCLE02,AFunc|4,a_steal_check
	LWL	SKSCLE02,AFunc|4,a_steal_check
	LWL	1,AFunc|4,a_steal_done
	.long	0

anim_steal_6
	LWWL	SKSCLE02,AFlip|AFunc|3,M_FLIPH,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	1,AFunc|3,a_steal_done
	.long	0

anim_steal_7
	LWWL	SKSCLE02,AFlip|AFunc|3,M_FLIPH,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	1,AFunc|3,a_steal_done
	.long	0

anim_steal_8
	LWWL	SKSCLE02,AFlip|AFunc|3,M_FLIPH,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	SKSCLE02,AFunc|3,a_steal_check
	LWL	1,AFunc|3,a_steal_done
	.long	0

a_steal_done
	move	*a8(ODT_PBK),a6,L	;get player block
	clr	a0
	move	a0,*a6(POF_MODE),L
	jauc	give_player_control

a_steal_check
	move	a8,a9		;save us
	move	*a9(ODT_PBK),a5,L
	move	@PUCK_CONTROL,a1,W
	jrz	asc_9
	movb	*a5(POF_NUMBER),a3
	cmp	a3,a1
	jrz	asc_9
	movi	push_range_list,a3
	callr	check_bounds_direction
	jrnc	asc_9
	move	@PUCK_CONTROL,a0,W
	jrz	astc_1
	calla	turn_on_a0_arrow
astc_1	movb	*a5(POF_NUMBER),a0
	move	a0,@PUCK_CONTROL,W
	calla	turn_on_a0_arrow
	calla	new_puck_control
asc_9	move	a9,a8
	rets

anim_push_1
	LW	HT320A01,3
	LW	HT320A02,2
	LW	HT320A03,2
	LWL	1,AFunc|3,a_push_check
	LW	HT320A04,6
	LW	HT320A05,2
	LW	HT320A06,2
	LW	HT320A07,2
	LW	HT320A08,2
	LW	HT320A09,1
	LWL	HT320A10,AFunc|1,a_push_done
	.long	0

anim_push_2
	LWW	HT320A01,AFlip|3,0
	LW	HT320A02,2
	LW	HT320A03,2
	LWL	1,AFunc|3,a_push_check
	LW	HT320A04,6
	LW	HT320A05,2
	LW	HT320A06,2
	LW	HT320A07,2
	LW	HT320A08,2
	LW	HT320A09,1
	LWL	HT320A10,AFunc|1,a_push_done
	.long	0

anim_push_3
	LWW	HT320A01,AFlip|3,0
	LW	HT320A02,2
	LW	HT320A03,2
	LWL	1,AFunc|3,a_push_check
	LW	HT320A04,6
	LW	HT320A05,2
	LW	HT320A06,2
	LW	HT320A07,2
	LW	HT320A08,2
	LW	HT320A09,1
	LWL	HT320A10,AFunc|1,a_push_done
	.long	0

anim_push_4
	LWW	HT320A01,AFlip|3,0
	LW	HT320A02,2
	LW	HT320A03,2
	LWL	1,AFunc|3,a_push_check
	LW	HT320A04,6
	LW	HT320A05,2
	LW	HT320A06,2
	LW	HT320A07,2
	LW	HT320A08,2
	LW	HT320A09,1
	LWL	HT320A10,AFunc|1,a_push_done
	.long	0

anim_push_5
	LW	HT320A01,3
	LW	HT320A02,2
	LW	HT320A03,2
	LWL	1,AFunc|3,a_push_check
	LW	HT320A04,6
	LW	HT320A05,2
	LW	HT320A06,2
	LW	HT320A07,2
	LW	HT320A08,2
	LW	HT320A09,1
	LWL	HT320A10,AFunc|1,a_push_done
	.long	0

anim_push_6
	LWW	HT320A01,AFlip|3,M_FLIPH
	LW	HT320A02,2
	LW	HT320A03,2
	LWL	1,AFunc|3,a_push_check
	LW	HT320A04,6
	LW	HT320A05,2
	LW	HT320A06,2
	LW	HT320A07,2
	LW	HT320A08,2
	LW	HT320A09,1
	LWL	HT320A10,AFunc|1,a_push_done
	.long	0

anim_push_7
	LWW	HT320A01,AFlip|3,M_FLIPH
	LW	HT320A02,2
	LW	HT320A03,2
	LWL	1,AFunc|3,a_push_check
	LW	HT320A04,6
	LW	HT320A05,2
	LW	HT320A06,2
	LW	HT320A07,2
	LW	HT320A08,2
	LW	HT320A09,1
	LWL	HT320A10,AFunc|1,a_push_done
	.long	0

anim_push_8
	LWW	HT320A01,AFlip|3,M_FLIPH
	LW	HT320A02,2
	LW	HT320A03,2
	LWL	1,AFunc|3,a_push_check
	LW	HT320A04,6
	LW	HT320A05,2
	LW	HT320A06,2
	LW	HT320A07,2
	LW	HT320A08,2
	LW	HT320A09,1
	LWL	HT320A10,AFunc|1,a_push_done
	.long	0

a_push_done
	move	*a8(ODT_PBK),a6,L	;get player block
	clr	a0
	move	a0,*a6(POF_MODE),L
	jauc	give_player_control

a_push_check
	move	*a8(ODT_PBK),a6,L	;get player block
	movb	*a6(POF_NUMBER),a0
	dec	a0
	move	a0,a11
	move	a0,a14
	sll	4,a0
	sll	5,a11
	sll	6,a14
	add	a11,a0
	add	a14,a0			;112 * (player - 1)
	move	@PUCK_CONTROL,a11,W
	move	a11,a14
	move	a11,a10
	sll	7,a11
	sll	8,a14
	sll	9,a10
	add	a14,a11
	add	a10,a11			; 896 * puck_control
	add	a0,a11			;112 pl + 896 puck
	addi	push_order_list,a11	;a11 is address of check order list

	.if	nskaters=3
	movk	7,b1
	.else
	movk	5,b1
	.endif

crpp1	move	*a11+,a1,W
	callr	check_push_player
	jrc	crpp_9
	dsjs	b1,crpp1
crpp_9	rets

check_push_player
	mmtm	sp,a6,a8
	move	a6,a5
	move	a8,a9
	movi	push_range_list,a3
	callr	check_bounds_direction	;a1
	jrnc	cpp_9
	move	a1,a0
	calla	get_player_block

	MOVE	*A6(POF_FLAGS),A14,W
	BTST	B_PF_GOALIE,A14
	JRNZ	cpp_9				;BR=DON'T PUSH GOALIE RIGHT NOW

	move	*a6(POF_OBJECT),a8,L
	move	*a6(POF_MODE),a0,W
	cmpi	100,a0
	jrhs	popp_g
	movb	*a5(POF_DIRECTION),a2
;	move	a2,a14
;	subk	4,a14
;	jrp	popp
;	addk	8,a14
popp	movb	a2,*a6(POF_DIRECTION)
	sll	5,a2
	addi	diropr-32,a2
	move	*a2,a14,W
	sll	16,a14
	move	a14,*a8(OZVEL),L
	move	*a2(16),a14,W
	sll	16,a14
	move	a14,*a8(OXVEL),L
	calla	take_player_control
	movk	7,a0
	move	a0,*a6(POF_MODE),W
	calla	set_player_script
popp_g	movb	*a6(POF_NUMBER),a0
	calla	turn_on_a0_arrow
	move	@PUCK_CONTROL,a1,W
	cmp	a0,a1
	jrz	cpp_has
	mmfm	sp,a6,a8
	setc
	rets
cpp_9	mmfm	sp,a6,a8
	clrc
	rets
cpp_has	movb	*a5(POF_NUMBER),a0
	move	a0,@PUCK_CONTROL,W
	calla	turn_on_a0_arrow
	calla	new_puck_control
	mmfm	sp,a6,a8
	setc
	rets

diropr	.word	-6,0
	.word	-4,4
	.word	0,6
	.word	4,4
	.word	6,0
	.word	4,-4
	.word	0,-6
	.word	-4,-4

check_bounds_direction		;loads a6 with players block, a8 with
	mmtm	sp,a2,a4
	movb	*a5(POF_DIRECTION),a2
	sll	6,a2
	add	a3,a2
	subi	64,a2
	move	*a2,a3,L		;lower limit
	move	*a2(32),a2,L		;upper limit
	move	*a9(OXPOS),a4,W
	move	*a9(OZVAL),a14,L
	movy	a14,a4
	addxy	a4,a3			;lower limit
	addxy	a4,a2			;upper limit
	movi	[1,1],a14
	subxy	a14,a2			;because xy checks are helped by this
	move	a1,a0
	calla	get_player_block
	move	*a6(POF_OBJECT),a8,L
	move	*a8(OXPOS),a4,W
	move	*a8(OZVAL),a14,L
	movy	a14,a4
	cmpxy	a3,a4
	jrxle	cpp_8
	jryle	cpp_8
	cmpxy	a2,a4
	jrxgt	cpp_8
	jrygt	cpp_8
	setc
	mmfm	sp,a2,a4
	rets
cpp_8	clrc
	mmfm	sp,a2,a4
	rets

push_range_list
	.long	[-60,-50],[10,50]
	.long	[-45,-10],[10,45]
	.long	[-50,-10],[50,60]
	.long	[-10,-10],[45,45]
	.long	[-10,-50],[60,50]
	.long	[-10,-45],[45,10]
	.long	[-50,-60],[50,10]
	.long	[-45,-45],[10,10]

push_order_list
	.if	nskaters=3

	.word	5,6,7,8,2,3,4	;player 1 - nobody has puck
	.word	6,7,5,8,3,1,4	;player 2
	.word	7,5,6,8,1,2,4	;player 3
	.word	5,6,7,8,1,2,3	;player 4
	.word	1,2,3,4,6,7,8	;player 5
	.word	2,3,1,4,7,5,8	;player 6
	.word	3,1,2,4,5,6,8	;player 7
	.word	1,2,3,4,5,6,7	;player 8

	.word	5,6,7,8,2,3,4	;player 1 - player 1 has puck
	.word	6,7,5,8,3,1,4	;player 2
	.word	7,5,6,8,2,1,4	;player 3
	.word	5,6,7,8,2,3,1	;player 4
	.word	1,2,3,4,6,7,8	;player 5
	.word	1,2,3,4,7,5,8	;player 6
	.word	1,3,2,4,5,6,8	;player 7
	.word	1,2,3,4,5,6,7	;player 8

	.word	5,6,7,8,3,2,4	;player 1 - player 2 has puck
	.word	6,7,5,8,3,1,4	;player 2
	.word	7,5,6,8,1,2,4	;player 3
	.word	5,6,7,8,1,3,2	;player 4
	.word	2,1,3,4,6,7,8	;player 5
	.word	2,3,1,4,7,5,8	;player 6
	.word	2,3,1,4,5,6,8	;player 7
	.word	2,1,3,4,5,6,7	;player 8

	.word	5,6,7,8,2,3,4	;player 1 - player 3 has puck
	.word	6,7,5,8,1,3,4	;player 2
	.word	7,5,6,8,1,2,4	;player 3
	.word	5,6,7,8,1,2,3	;player 4
	.word	3,1,2,4,6,7,8	;player 5
	.word	3,2,1,4,7,5,8	;player 6
	.word	3,1,2,4,5,6,8	;player 7
	.word	3,1,2,4,5,6,7	;player 8

	.word	5,6,7,8,2,3,4	;player 1 - player 4 has puck
	.word	6,7,5,8,3,1,4	;player 2
	.word	7,5,6,8,1,2,4	;player 3
	.word	5,6,7,8,1,2,3	;player 4
	.word	4,1,2,3,6,7,8	;player 5
	.word	4,2,3,1,7,5,8	;player 6
	.word	4,3,1,2,5,6,8	;player 7
	.word	4,1,2,3,5,6,7	;player 8

	.word	5,6,7,8,2,3,4	;player 1 - player 5 has puck
	.word	5,6,7,8,3,1,4	;player 2
	.word	5,7,6,8,1,2,4	;player 3
	.word	5,6,7,8,1,2,3	;player 4
	.word	1,2,3,4,6,7,8	;player 5
	.word	2,3,1,4,7,5,8	;player 6
	.word	3,1,2,4,6,5,8	;player 7
	.word	1,2,3,4,6,7,5	;player 8

	.word	6,5,7,8,2,3,4	;player 1 - player 6 has puck
	.word	6,7,5,8,3,1,4	;player 2
	.word	6,7,5,8,1,2,4	;player 3
	.word	6,5,7,8,1,2,3	;player 4
	.word	1,2,3,4,7,6,8	;player 5
	.word	2,3,1,4,7,5,8	;player 6
	.word	3,1,2,4,5,6,8	;player 7
	.word	1,2,3,4,5,7,6	;player 8

	.word	7,5,6,8,2,3,4	;player 1 - player 7 has puck
	.word	7,6,5,8,3,1,4	;player 2
	.word	7,5,6,8,1,2,4	;player 3
	.word	7,5,6,8,1,2,3	;player 4
	.word	1,2,3,4,6,7,8	;player 5
	.word	2,3,1,4,5,7,8	;player 6
	.word	3,1,2,4,5,6,8	;player 7
	.word	1,2,3,4,5,6,7	;player 8

	.word	8,5,6,7,2,3,4	;player 1 - player 8 has puck
	.word	8,6,7,5,3,1,4	;player 2
	.word	8,7,5,6,1,2,4	;player 3
	.word	8,5,6,7,1,2,3	;player 4
	.word	1,2,3,4,6,7,8	;player 5
	.word	2,3,1,4,7,5,8	;player 6
	.word	3,1,2,4,5,6,8	;player 7
	.word	1,2,3,4,5,6,7	;player 8

	.else

	.word	5,6,8,2,4,0,0	;player 1 - nobody has puck
	.word	6,5,8,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	5,6,8,1,2,0,0	;player 4
	.word	1,2,4,6,8,0,0	;player 5
	.word	2,1,4,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	1,2,4,5,6,0,0	;player 8

	.word	5,6,8,2,4,0,0	;player 1 - player 1 has puck
	.word	6,5,8,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	5,6,8,2,1,0,0	;player 4
	.word	1,2,4,6,8,0,0	;player 5
	.word	1,2,4,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	1,2,4,5,6,0,0	;player 8

	.word	5,6,8,2,4,0,0	;player 1 - player 2 has puck
	.word	6,5,8,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	5,6,8,1,2,0,0	;player 4
	.word	2,1,4,6,8,0,0	;player 5
	.word	2,1,4,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	2,1,4,5,6,0,0	;player 8

	.word	1,1,1,1,1,0,0	;player 1 - player 3 has puck
	.word	1,1,1,1,1,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	1,1,1,1,1,0,0	;player 4
	.word	1,1,1,1,1,0,0	;player 5
	.word	1,1,1,1,1,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	1,1,1,1,1,0,0	;player 8

	.word	5,6,8,2,4,0,0	;player 1 - player 4 has puck
	.word	6,5,8,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	5,6,8,1,2,0,0	;player 4
	.word	4,1,2,6,8,0,0	;player 5
	.word	4,2,1,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	4,1,2,5,6,0,0	;player 8

	.word	5,6,8,2,4,0,0	;player 1 - player 5 has puck
	.word	5,6,8,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	5,6,8,1,2,0,0	;player 4
	.word	1,2,4,6,8,0,0	;player 5
	.word	2,1,4,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	1,2,4,6,5,0,0	;player 8

	.word	6,5,8,2,4,0,0	;player 1 - player 6 has puck
	.word	6,5,8,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	6,5,8,1,2,0,0	;player 4
	.word	1,2,4,6,8,0,0	;player 5
	.word	2,1,4,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	1,2,4,5,6,0,0	;player 8

	.word	1,1,1,1,1,0,0	;player 1 - player 7 has puck
	.word	1,1,1,1,1,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	1,1,1,1,1,0,0	;player 4
	.word	1,1,1,1,1,0,0	;player 5
	.word	1,1,1,1,1,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	1,1,1,1,1,0,0	;player 8

	.word	8,5,6,2,4,0,0	;player 1 - player 8 has puck
	.word	8,6,5,1,4,0,0	;player 2
	.word	1,1,1,1,1,0,0	;player 3
	.word	8,5,6,1,2,0,0	;player 4
	.word	1,2,4,6,8,0,0	;player 5
	.word	2,1,4,5,8,0,0	;player 6
	.word	1,1,1,1,1,0,0	;player 7
	.word	1,2,4,5,6,0,0	;player 8

	.endif

anim_coast_1
	LW	SKSCLE02,6
	LW	SKSCLE03,6
	LW	SKSCLE04,6
	LW	SKSCLE05,6
	LW	SKSCLE06,6
	LW	SKSCLE07,6
	LW	SKSCLE08,6
	LW	SKSCLE09,6
	LW	SKSCLE10,6
	LW	SKSCLE11,6
	.long	0
anim_coast_2
	LWW	SKSCLE02,AFlip|6,0
	LW	SKSCLE03,6
	LW	SKSCLE04,6
	LW	SKSCLE05,6
	LW	SKSCLE06,6
	LW	SKSCLE07,6
	LW	SKSCLE08,6
	LW	SKSCLE09,6
	LW	SKSCLE10,6
	LW	SKSCLE11,6
	.long	0
anim_coast_3
	LWW	SKSCLE02,AFlip|6,0
	LW	SKSCLE03,6
	LW	SKSCLE04,6
	LW	SKSCLE05,6
	LW	SKSCLE06,6
	LW	SKSCLE07,6
	LW	SKSCLE08,6
	LW	SKSCLE09,6
	LW	SKSCLE10,6
	LW	SKSCLE11,6
	.long	0
anim_coast_4
	LWW	SKSCLE02,AFlip|6,0
	LW	SKSCLE03,6
	LW	SKSCLE04,6
	LW	SKSCLE05,6
	LW	SKSCLE06,6
	LW	SKSCLE07,6
	LW	SKSCLE08,6
	LW	SKSCLE09,6
	LW	SKSCLE10,6
	LW	SKSCLE11,6
	.long	0
anim_coast_5
	LW	SKSCLE02,6
	LW	SKSCLE03,6
	LW	SKSCLE04,6
	LW	SKSCLE05,6
	LW	SKSCLE06,6
	LW	SKSCLE07,6
	LW	SKSCLE08,6
	LW	SKSCLE09,6
	LW	SKSCLE10,6
	LW	SKSCLE11,6
	.long	0
anim_coast_6
	LWW	SKSCLE02,AFlip|6,M_FLIPH
	LW	SKSCLE03,6
	LW	SKSCLE04,6
	LW	SKSCLE05,6
	LW	SKSCLE06,6
	LW	SKSCLE07,6
	LW	SKSCLE08,6
	LW	SKSCLE09,6
	LW	SKSCLE10,6
	LW	SKSCLE11,6
	.long	0
anim_coast_7
	LWW	SKSCLE02,AFlip|6,M_FLIPH
	LW	SKSCLE03,6
	LW	SKSCLE04,6
	LW	SKSCLE05,6
	LW	SKSCLE06,6
	LW	SKSCLE07,6
	LW	SKSCLE08,6
	LW	SKSCLE09,6
	LW	SKSCLE10,6
	LW	SKSCLE11,6
	.long	0
anim_coast_8
	LWW	SKSCLE02,AFlip|6,M_FLIPH
	LW	SKSCLE03,6
	LW	SKSCLE04,6
	LW	SKSCLE05,6
	LW	SKSCLE06,6
	LW	SKSCLE07,6
	LW	SKSCLE08,6
	LW	SKSCLE09,6
	LW	SKSCLE10,6
	LW	SKSCLE11,6
	.long	0

