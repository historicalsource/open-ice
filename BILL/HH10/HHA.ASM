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

; end of include files

	.TEXT
	.EVEN

SW_4				;P1 A
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	1,a0
	jauc	shoot_puck_sw
SW_5				;P1 B
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	1,a0
	jauc	pass_puck_sw
SW_6				;P1 C
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	jauc	SUCIDE
SW_7				;P1 D
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	jauc	SUCIDE
SW_12				;P2 A
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	2,a0
	jauc	shoot_puck_sw
SW_13				;P2 B
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	2,a0
	jauc	pass_puck_sw
SW_14				;P2 C
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	jauc	SUCIDE
SW_15				;P2 D
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	jauc	SUCIDE
SW_20				;P3 A
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	5,a0
	jauc	shoot_puck_sw
SW_21				;P3 B
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	5,a0
	jauc	pass_puck_sw
SW_22				;P3 C
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	jauc	SUCIDE
SW_23				;P3 D
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	jauc	SUCIDE
SW_28				;P4 A
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	6,a0
	jauc	shoot_puck_sw
SW_29				;P4 B
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	6,a0
	jauc	pass_puck_sw
SW_30				;P4 C
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	jauc	SUCIDE
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
	movk	2,a0
	jauc	player_start
SW_41				;P3 START
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	5,a0
	jauc	player_start
SW_42				;P4 START
	move	@GAME_STATE,b0
	cmpi	INDIAG,b0
	jrz	NO_SWITCH
	movk	6,a0
	jauc	player_start

NO_SWITCH
	jauc	SUCIDE
