 	.MLIB	"HHMACS.LIB"
	.FILE	"HHA.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hha.e"
	.include	"hhproc.g"
	.include	"hhd.g"
	.include	"hhmisc.g"
	.include	"hhplayer.g"
	.include	"hhram.g"
	.include	"hhcontrl.g"
	.include	"hhgame.g"
	.include	"hhpuck.g"
	.include	"hhpic.g"
	.include	"hhscr_ch.g"

; end of include files

	.TEXT
	.EVEN

SW_4				;P1 A
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	MOVE	@WAVEIRQS,@GTIMES1,L
	movk	1,a0
	jauc	shoot_puck_sw
SW_5				;P1 B
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	MOVE	@WAVEIRQS,@GTIMEP1,L
	movk	1,a0
	jauc	pass_puck_sw
SW_6				;P1 C
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	MOVE	@WAVEIRQS,@GTIMET1,L
	movk	1,a0
	jruc	set_tob
SW_7				;P1 D
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	jauc	SUCIDE

SW_12				;P2 A
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	KITN	2
	jrz	zzp2_a
	MOVE	@WAVEIRQS,@GTIMES2,L
	movk	2,a0
	jauc	shoot_puck_sw
SW_13				;P2 B
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	KITN	2
	jrz	zzp2_b
	MOVE	@WAVEIRQS,@GTIMEP2,L
	movk	2,a0
	jauc	pass_puck_sw
SW_14				;P2 C
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	KITN	2
	jrz	zzp2_c
	MOVE	@WAVEIRQS,@GTIMET2,L
	movk	2,a0
	jruc	set_tob
SW_15				;P2 D
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	jauc	SUCIDE

SW_20				;P3 A
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	KITN	2
	jrz	NO_SWITCH
	MOVE	@WAVEIRQS,@GTIMES5,L
	movk	5,a0
	jauc	shoot_puck_sw
SW_21				;P3 B
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	KITN	2
	jrz	NO_SWITCH
	MOVE	@WAVEIRQS,@GTIMEP5,L
	movk	5,a0
	jauc	pass_puck_sw
SW_22				;P3 C
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	KITN	2
	jrz	NO_SWITCH
	MOVE	@WAVEIRQS,@GTIMET5,L
	movk	5,a0
	jruc	set_tob
SW_23				;P3 D
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	jauc	SUCIDE

SW_28				;P4 A
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	KITN	2
	jrz	NO_SWITCH
zzp2_a	MOVE	@WAVEIRQS,@GTIMES6,L
	movk	6,a0
	jauc	shoot_puck_sw
SW_29				;P4 B
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	KITN	2
	jrz	NO_SWITCH
zzp2_b	MOVE	@WAVEIRQS,@GTIMEP6,L
	movk	6,a0
	jauc	pass_puck_sw
SW_30				;P4 C
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	KITN	2
	jrz	NO_SWITCH
zzp2_c	MOVE	@WAVEIRQS,@GTIMET6,L
	movk	6,a0
set_tob	calla	check_for_player
	janc	octopus_button
	GBLOCK	a0,a6
	move	*a6(POF_FLAGS),a0,W
	btst	B_PF_HIGHER,a0
	jrnz	sw30_9
	movk	16,a0
	move	a0,*a6(POF_TURBO_OB),W
	move	@WAVEIRQS,a0,W
	move	*a6(POF_TTIME),a14,L
	move	a0,*a6(POF_TTIME),L
	sub	a14,a0
	cmpi	20,a0
	jrhi	sw30_9
	move	@PUCK_CONTROL,a14,W
	movb	*a6(POF_NUMBER),a0
	cmp	a0,a14
	jrnz	sw30_9

	move	*a6(POF_OBJECT),a8,L
	move	@no_control,a14,W
	jrnz	sw30_9
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_HIGHER,a14
	jrnz	sw30_9
	btst	B_PF_HUMAN,a14
	jrz	sw30_9
	move	*a6(POF_FLAGS),a14,W
	btst	B_PF_CONTROL,a14
	jrnz	ccap1
	btst	B_PF_CONTROLM,a14
	jrz	sw30_9
ccap1	move	@GAME_STATE,a14,W
	cmpi	INPLAY,a14
	jrnz	sw30_9
	calla	take_player_control_m
	calla	set_elbow_script
sw30_9	jauc	SUCIDE

SW_31				;P4 D
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	jauc	SUCIDE
SW_34				;P1 START
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	1,a0
	jauc	player_start
SW_37				;P2 START
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	MOVK	2,A0
	KITN	4
	JAEQ	player_start			;BR=4 PLAYER KIT
	MOVK	6,A0				;2 PLAYER KIT
	jauc	player_start
SW_41				;P3 START
	KITN	4
	JRNE	NO_SWITCH			;BR=NOT A 4 PLAYER KIT
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	5,a0
	jauc	player_start

SW_42				;P4 START
	KITN	4
	JRNE	NO_SWITCH			;BR=NOT A 4 PLAYER KIT
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	6,a0
	jauc	player_start

NO_SWITCH
	jauc	SUCIDE
