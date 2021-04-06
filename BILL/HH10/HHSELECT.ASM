 	.MLIB	"HHMACS.LIB"
	.FILE	"HHSELECT.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*

	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.INCLUDE	"HEADS.TBL"
	.INCLUDE	"PNAMES.TBL"
	.INCLUDE	"SCREEN.TBL"
	.include	"hhselect.e"
	.include	"hhcontrl.g"
	.include	"hhproc.g"
	.include	"hhscript.g"
	.include	"hhtables.g"
	.include	"hhd.g"
	.include	"hhpall.g"
	.include	"hhutil.g"
	.include	"hhplayer.g"
	.include	"hhgame.g"

; end of include files

	.TEXT
	.EVEN


create_players		;creates all players in the game
	movi	team_whalers,a0
	move	a0,@team1,W
	movi	team_senators,a0
	move	a0,@team2,W
	movi	player_list,a4
cpy1	move	*a4+,a0,W
	jrz	cpy9
	move	*a4+,a1,W
	move	*a4+,a2,W
	move	*a4+,a3,W
	callr	create_player
	jruc	cpy1
cpy9	jauc	fix_curplyrs	;fix players, and sets control

player_list
	.if	nskaters=3

	.word	1,skater_harper,team_mighty_ducks,0
	.word	2,skater_mcdaniel,team_mighty_ducks,0
	.word	3,skater_ewing,team_mighty_ducks,0
	.word	4,0,team_mighty_ducks,0
	.word	5,skater_stockton,team_bruins,1
	.word	6,skater_shiek,team_bruins,1
	.word	7,skater_malone,team_bruins,1
	.word	8,0,team_bruins,1
	.word	0

	.else

	.word	1,skater_harper,team_mighty_ducks,0
	.word	2,skater_mcdaniel,team_mighty_ducks,0
	.word	4,0,team_mighty_ducks,0
	.word	5,skater_stockton,team_bruins,1
	.word	6,skater_shiek,team_bruins,1
	.word	8,0,team_bruins,1
	.word	0

	.endif

**************************************************************************
*								         *
* create_player								 *
* 	input	a0  = number of player to create (1-8)			 *
* 		a1  = player # (individual)				 *
* 		a2  = team # (palette)					 *
* 		a3  = 0 - home, 1 - away				 *
*								         *
**************************************************************************
create_player
	mmtm	sp,a0,a1,a2,a3,a6,a7,a8,a9,a10,a11		;since we seldom do this
	calla	get_player_block
	movb	a0,*a6(POF_NUMBER)
	move	a1,*a6(POF_CHARACTER),W
	move	a2,*a6(POF_TEAM),W
	move	a3,*a6(POF_VISITOR),W
	move	a0,a11
	sll	8,a11
	addi	cp_table-256,a11
	move	*a11+,a10,L
	call	a10
	mmfm	sp,a0,a1,a2,a3,a6,a7,a8,a9,a10,a11
	rets

cp_table
	.long	regular_player,PID_PLAYER_1,player1_init,player1_shadow_init,arrow_1_init,0,0,0
	.long	regular_player,PID_PLAYER_2,player2_init,player2_shadow_init,arrow_2_init,0,0,0
	.long	regular_player,PID_PLAYER_3,player3_init,player3_shadow_init,arrow_2_init,0,0,0
	.long	goalie_player,PID_PLAYER_4,player4_init,player4_shadow_init,0,0,0,0
	.long	regular_player,PID_PLAYER_5,player5_init,player5_shadow_init,arrow_3_init,0,0,0
	.long	regular_player,PID_PLAYER_6,player6_init,player6_shadow_init,arrow_4_init,0,0,0
	.long	regular_player,PID_PLAYER_7,player7_init,player7_shadow_init,arrow_4_init,0,0,0
	.long	goalie_player,PID_PLAYER_8,player8_init,player8_shadow_init,0,0,0,0


goalie_player		;need to update goalie
	movk	1,a0
	movb	a0,*a6(POF_DIRECTION)
	movi	M_PF_CONTROL|M_PF_GOALIE,a0
	move	a0,*a6(POF_FLAGS),L
	move	*a11+,a1,L
	movb	*a6(POF_NUMBER),a10
	movi	control_goalie,a7
	calla	KILL_AND_GETPPRC
	move	*a11+,a14,L
	move	a14,b0
	calla	EASYMAKE
	move	a8,*a6(POF_OBJECT),L
	move	a6,*a8(ODT_PBK),L
	move	*a11+,a14,L
	move	a14,b0
	calla	EASYMAKE
	move	a8,*a6(POF_SHADOW),L
;	movi	100,a0
	CLR	A0				;TRICKY HUH.
	move	a0,*a6(POF_MODE),W
	movi	ron_harper,a9
	move	*a6(POF_OBJECT),a8,L
	callr	read_player_data
	rets

regular_player
	clr	a0
	movb	a0,*a6(POF_TOP_MODE)
	move	a0,*a6(POF_TURBO_BOX),L
	move	a0,*a6(POF_TURBO_BAR),L
	move	a0,*a6(POF_TURBO_NAME),L
	movb	a0,*a6(POF_BUTTONS)		;clear out buttons (in case we are a drone)
	movk	5,a0
	movb	a0,*a6(POF_DIRECTION)
	movi	M_PF_CONTROL,a0
	move	a0,*a6(POF_FLAGS),L
	move	*a11+,a1,L
	movb	*a6(POF_NUMBER),a10
	movi	control_player,a7
	calla	KILL_AND_GETPPRC
	move	*a11+,a14,L
	move	a14,b0
	calla	EASYMAKE
	move	a8,*a6(POF_OBJECT),L
	move	a6,*a8(ODT_PBK),L
	move	*a11+,a14,L
	move	a14,b0
	calla	EASYMAKE
	move	a8,*a6(POF_SHADOW),L
ttbo	movi	[49,0],a0
	move	a0,*a6(POF_TURBO_AMOUNT),L
	move	*a11+,a14,L
	move	a14,b0
	calla	EASYMAKE
	move	a8,*a6(POF_ARROW),L
	movi	100,a0
	move	a0,*a6(POF_ARROW_TIME),W
	movi	cpu_init,b0
	calla	EASYMAKE
	move	*a8(OCTRL),a0,W
	andni	DMAGO,a0
	move	a0,*a8(OCTRL),W
	calla	INSERT_OBJ
	move	a8,*a6(POF_ARROW_CPU),L
	movi	head_init,b0
	calla	EASYMAKE
	move	*a6(POF_OBJECT),a9,L
	move	a9,*a9(OPART1),L		;
	move	a9,*a8(OPART1),L		; make the head part 2 of multiparter
	move	a8,*a9(OPARTS),L		;
	calla	start_head_script
	move	*a6(POF_OBJECT),a8,L
	move	*a6(POF_TEAM),a9,W
	sll	8,a9
	addi	team_data,a9
	move	*a9(080h),a0,L			;home pal
	move	*a6(POF_VISITOR),a14,W
	jrz	pih_1
	move	*a9(0c0h),a0,L			;visitor pal
pih_1	calla	CHANGE_PAL			;change uniform palette, based on team
	move	*a6(POF_CHARACTER),a9,W
	sll	5,a9
	addi	player_data,a9
	move	*a9,a9,L			;a9 points to players data

read_player_data
	addi	64,a9				;initials and birthday
	move	*a9+,a0,L			;head table
	move	a0,*a6(POF_HEAD_TABLE),L
	move	*a9+,a0,L			;head palette
	move	*a8(OPARTS),a8,L
	jrz	nohead
	calla	CHANGE_PAL
nohead	move	*a6(POF_OBJECT),a8,L
	move	*a9+,a0,L			;shot table
	move	a0,*a6(POF_S_STAB),L
	move	*a9+,a0,L			;scale table
	move	a0,*a8(OSCTAB),L
	move	*a9+,a0,W			;mass
	move	a0,*a6(POF_MASS),W
	addk	16,a9				;empty word
	movi	player_speed_data,a1
	callr	rpdb				;speed data
	move	a0,*a6(POF_S_SPED),L
	movi	player_stop_data,a1
	callr	rpdb				;stopping data
	move	a0,*a6(POF_S_STOP),L
	movi	player_corner_data,a1
	callr	rpdb				;cornering data
	move	a0,*a6(POF_S_CORN),L
	movi	player_shoot_data,a1
	callr	rpdb				;shooting data
	move	a0,*a6(POF_S_SHOT),L
	movi	player_pass_data,a1
	callr	rpdb				;passing data
	move	a0,*a6(POF_S_PASS),L
	movi	player_dump_data,a1
	callr	rpdb				;dumping data
	move	a0,*a6(POF_S_DUMP),L
	movi	player_handle_data,a1
	callr	rpdb				;puck handing data
	move	a0,*a6(POF_S_HAND),L
	addk	8,a9				;empty byte
	move	a9,*a6(POF_IMAGE_TABLE),L	;image table
	rets
rpdb	movb	*a9,a0
	dec	a0
	addk	8,a9
	sll	5,a0
	add	a1,a0
	move	*a0,a0,L
	rets

head_init
	.long	mcdanl1
;	.word	DMAWNZ,M_NOPARTANI
	.word	DMAGO,M_NOPARTANI
	.word	OM_OID|OM_INSERT|OM_SCTAB
	.word	OID_HEAD
	.long	zscale_70_70_table

player1_init
	.long	w5stand
	.word	DMAWNZ,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_1
	.long	[-75,0],0,[10,0]

player1_shadow_init
	.long	shadow1
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_1_SHAD

player2_init
	.long	w5stand
	.word	DMAWNZ,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_2
	.long	[-25,0],0,[10,0]

player2_shadow_init
	.long	shadow1
	.word	DMAWNZ|DMAVFL,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_2_SHAD

player3_init
	.long	w5stand
	.word	DMAWNZ,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_3
	.long	[-100,0],0,[300,0]

player3_shadow_init
	.long	shadow1
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_3_SHAD

player4_init
	.long	GOALTES1c
	.word	DMAWNZ|DMAHFL,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_4
	.long	[-675,0],0,[320,0]

player4_shadow_init
	.long	shadow1
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_4_SHAD

player5_init
	.long	w5stand
	.word	DMAWNZ|DMAHFL,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_5
	.long	[25,0],0,[10,0]

player5_shadow_init
	.long	shadow1
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_5_SHAD

player6_init
	.long	w5stand
	.word	DMAWNZ|DMAHFL,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_6
	.long	[75,0],0,[10,0]

player6_shadow_init
	.long	shadow1
	.word	DMAWNZ|DMAVFL,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_6_SHAD

player7_init
	.long	w5stand
	.word	DMAWNZ|DMAHFL,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_7
	.long	[100,0],0,[300,0]

player7_shadow_init
	.long	shadow1
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_7_SHAD

player8_init
	.long	GOALTES1
	.word	DMAWNZ,0
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_PLAYER_8
	.long	[675,0],0,[320,0]

player8_shadow_init
	.long	shadow1
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_INSERT
	.word	OID_PLAYER_8_SHAD

arrow_1_init
	.long	arrow1t
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ARROW
	.long	[0,0],[0,0],[0,0]

arrow_2_init
	.long	arrow2t
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ARROW
	.long	[0,0],[0,0],[0,0]

arrow_3_init
	.long	arrow3t
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ARROW
	.long	[0,0],[0,0],[0,0]

arrow_4_init
	.long	arrow4t
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_ARROW
	.long	[0,0],[0,0],[0,0]

cpu_init
	.long	cpu
	.word	DMAWNZ,M_NOSCALE
	.word	OM_OID
	.word	OID_CPU

;	.long	logo1,logo2_init
;	.long	 member_1_list,member_2_list
;	.long	 home_uniform_pal,home_uniform_shad_pal
;	.long	 away_uniform_pal,away_uniform_shad_pal
team_data
	.long	anaheim,0
	.long	 0,0
	.long	 SKSCLE1xB,SKSCLE1xB
;	.long	 Stocktonp,Stocktonp
	.long	 KMalonep,KMalonep
	.long	boston,0
	.long	 0,0
	.long	 Colemanp,Colemanp
;	.long	 Petrovicp,Petrovicp
	.long	 SKSCLE1x,SKSCLE1x
	.long	buffalo,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	calgary,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	chicago,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	dallas,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	detroit,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	edmonton,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	florida,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	hartford,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	losangls,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	montreal,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	newjersey,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	nyisland,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	nyranger,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	ottowa,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	philadelp,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	pittsbur,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	quebec,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	sanjose,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	stlouis,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	tampabay,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	toronto,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	vancouver,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	washington,0
	.long	 0,0
	.long	 0,0
	.long	 0,0
	.long	winnipeg,0
	.long	 0,0
	.long	 0,0
	.long	 0,0

player_data
	.long	ron_harper
	.long	x_mcdaniel
	.long	ewing
	.long	stock
	.long	shiek
	.long	kmalone

player_speed_data
	.long	pspeed_data_1
	.long	pspeed_data_2
player_stop_data
	.long	pstop_data_1
player_corner_data
	.long	pcorner_data_1
player_shoot_data
	.long	pshoot_data_1
player_pass_data
	.long	ppass_data_1
player_dump_data
	.long	pdump_data_1
player_handle_data
	.long	phandle_data_1

pspeed_data_1
	.long	[4,0],[6,0],[7,0]		;speed_0,speed_1,speed_2
	.long	[3,0],[5,0e000h]		;speed_0_thresh,speed_thresh
	.long	[5,0],[9,0],[10,0]		;turbo_0,turbo_1,turbo_2
	.long	[3,0],[8,0e000h]		;turbo_0_thresh,turbo_thresh
	.long	[1,0],[0,03000h]		;defense_boost,puck control penalty
	.byte	12,16,2				;same_0_mt,same_l_mt,same_h_mt
	.byte	0				;nothing
	.word	8920,13380			;turbo_down,turbo_up
pspeed_data_2
	.long	[8,0],[12,0],[14,0]		;speed_0,speed_1,speed_2
	.long	[6,0],[11,0]			;speed_0_thresh,speed_thresh
	.long	[10,0],[18,0],[20,0]		;turbo_0,turbo_1,turbo_2
	.long	[6,0],[17,0]			;turbo_0_thresh,turbo_thresh
	.long	[2,0],[0,06000h]		;defense_boost,puck control penalty
	.byte	12,16,2				;same_0_mt,same_l_mt,same_h_mt
	.byte	0				;nothing
	.word	8920,13380			;turbo_down,turbo_up

pstop_data_1
	.long	[0,08000h],[1,0]		;stop_thresh,rstop_thresh
	.byte	16,16,32,16			;skid_r_mt,skid_s_mt,tskid_r_mt,tskid_s_mt
	.byte	10				;defense_skid_mt_boost
	.byte	0				;nothing
pcorner_data_1
	.long	XD0900
	.long	turn_table_1
	.long	turn_table_d
	.long	turn_table_c

turn_table_1
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0010,XD0010
	.long	XD0200,XD0010,XD0020
	.long	XD0300,XD0010,XD0030
	.long	XD0400,XD0010,XD0040
	.long	XD0500,XD0010,XD0050
	.long	XD3600,XD0010,XD0060

turn_table_d
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0010,XD0020
	.long	XD0200,XD0015,XD0030
	.long	XD0300,XD0015,XD0040
	.long	XD0400,XD0015,XD0050
	.long	XD0500,XD0015,XD0060
	.long	XD3600,XD0015,XD0070

turn_table_c
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0010,XD0020
	.long	XD0200,XD0015,XD0040
	.long	XD0300,XD0020,XD0060
	.long	XD0400,XD0020,XD0080
	.long	XD0500,XD0020,XD0100
	.long	XD3600,XD0020,XD0120

pshoot_data_1
	.long	[13,0],[15,0],[13,0],[19,0]	;shoot0_speed,shoot_speed,shoot0_turbo,shoot_turbo
	.long	[5,0]				;max_y
	.byte	18,18				;shoot_mt,shoot_turbo_mt
	.long	change_shot,change_tshot	;shot_change,tshot_change
ppass_data_1
	.long	[13,0],[17,0]			;pass_speed,pass_turbo
	.word	300,700,250,600			;pass_gthresh,pass_mthresh,tpass_gthresh,tpass_mthresh
	.long	change_pass,change_tpass	;pass_change,tpass_change
pdump_data_1
	.long	[13,0],[19,0]			;dump_speed,dump_turbo
	.long	change_dump,change_tdump	;dump_change,tdump_change
phandle_data_1
	.long	int_control,off_control		;int_control,off_control
	.long	def_control			;def_control


;	.byte	" "," "," ",0,month,day,0,0
;	.long	head_table,head_palette
;	.long	shot_table,scale_table
;	.word	mass,0
;	.byte	speed,stopping,cornering,shooting
;	.byte	,passing,dumping,puck handling,0
;	.long	images

ron_harper
	.byte	"A","A","A",0,1,1,0,0
	.long	rharp_heads,HARPER_p
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	1,1,1,1,1,1,1,0
	.long	HARPER_R

x_mcdaniel
	.byte	"A","A","A",0,1,1,0,0
	.long	mcdaniel_heads,MCDANL_p
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	1,1,1,1,1,1,1,0
	.long	PERSON

ewing
	.byte	"A","A","A",0,1,1,0,0
	.long	ewing_heads,EWING_p
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	1,1,1,1,1,1,1,0
	.long	EWING

stock
	.byte	"A","A","A",0,1,1,0,0
	.long	stock_heads,STOCK_p
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	1,1,1,1,1,1,1,0
	.long	STOCKTON

shiek
	.byte	"A","A","A",0,1,1,0,0
	.long	shiek_heads,SHEIK_p
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	1,1,1,1,1,1,1,0
	.long	PERSON

kmalone
	.byte	"A","A","A",0,1,1,0,0
	.long	kmalone_heads,MALONE_p
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	1,1,1,1,1,1,1,0
	.long	MALONE_K

mcdaniel_heads
	.long	mcdanl1
	.long	mcdanl1
	.long	mcdanl2
	.long	mcdanl3
	.long	mcdanl4
	.long	mcdanl5
	.long	mcdanl6
	.long	mcdanl7
	.long	mcdanl8
	.long	mcdanl9
	.long	mcdanl10
	.long	mcdanl11
	.long	mcdanl12
	.long	mcdanl13
	.long	mcdanl14
	.long	mcdanl15
	.long	mcdanl16

ewing_heads
	.long	ewing1
	.long	ewing1
	.long	ewing2
	.long	ewing3
	.long	ewing4
	.long	ewing5
	.long	ewing6
	.long	ewing7
	.long	ewing8
	.long	ewing9
	.long	ewing10
	.long	ewing11
	.long	ewing12
	.long	ewing13
	.long	ewing14
	.long	ewing15
	.long	ewing16

lewis_heads
	.long	lewis1
	.long	lewis1
	.long	lewis2
	.long	lewis3
	.long	lewis4
	.long	lewis5
	.long	lewis6
	.long	lewis7
	.long	lewis8
	.long	lewis9
	.long	lewis10
	.long	lewis11
	.long	lewis12
	.long	lewis13
	.long	lewis14
	.long	lewis15
	.long	lewis16

stock_heads
	.long	stock1
	.long	stock1
	.long	stock2
	.long	stock3
	.long	stock4
	.long	stock5
	.long	stock6
	.long	stock7
	.long	stock8
	.long	stock9
	.long	stock10
	.long	stock11
	.long	stock12
	.long	stock13
	.long	stock14
	.long	stock15
	.long	stock16

shiek_heads
	.long	shiek1
	.long	shiek1
	.long	shiek2
	.long	shiek3
	.long	shiek4
	.long	shiek5
	.long	shiek6
	.long	shiek7
	.long	shiek8
	.long	shiek9
	.long	shiek10
	.long	shiek11
	.long	shiek12
	.long	shiek13
	.long	shiek14
	.long	shiek15
	.long	shiek16

rharp_heads
	.long	rharp1
	.long	rharp1
	.long	rharp2
	.long	rharp3
	.long	rharp4
	.long	rharp5
	.long	rharp6
	.long	rharp7
	.long	rharp8
	.long	rharp9
	.long	rharp10
	.long	rharp11
	.long	rharp12
	.long	rharp13
	.long	rharp14
	.long	rharp15
	.long	rharp16

kmalone_heads
	.long	kmalone1
	.long	kmalone1
	.long	kmalone2
	.long	kmalone3
	.long	kmalone4
	.long	kmalone5
	.long	kmalone6
	.long	kmalone7
	.long	kmalone8
	.long	kmalone9
	.long	kmalone10
	.long	kmalone11
	.long	kmalone12
	.long	kmalone13
	.long	kmalone14
	.long	kmalone15
	.long	kmalone16
