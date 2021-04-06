;**************************************************************************
;*									  *
;* 	                 MASTER EQUATE FILE				  *
;*									  *
;**************************************************************************

ZWRAP		.EQU	[2350,0]

radius	.set	120


**************************************************************************
*								         *
* TEAM_DATA TABLE EQUATES						 *
*								         *
**************************************************************************

;	.long	logo1,logo2_init
;	.long	 member_1_list,member_2_list
;	.long	 away_uniform_pal,away_uniform_goalie_pal
;	.long	 home_uniform_pal,home_uniform_goalie_pal
;	.long	 home_p1_turbo_pal,home_p2_turbo_pal
;	.long	 home_p3_turbo_pal,home_p4_turbo_pal
;	.long	 away_p1_turbo_pal,away_p2_turbo_pal
;	.long	 away_p3_turbo_pal,away_p4_turbo_pal
;	.long	 long_name_init
;	.long	 goalie_list
;	.LONG	 TEAM NAME IMAGE, TEAM LOGO IMAGE
;	.word	 home_helmet_palette_offset,away_helmet_palette_offset
;	.word	  goalie_helmet_palette_offset
;	.LONG	 CITY NAME IMAGE, CITY NAME STRING
;	.LONG	 TEAM NICKNAME
;	.word	 video clip primary pal, video clip secondary pal
;	.long	 away_bench_palette,home_bench_palette

TD_ALTTEAMLOGO	equ	0020h			;UHL
TD_MEMBER1_LIST	EQU	0040H			;UHL
TD_MEMBER2_LIST	EQU	0060H			;UHL

TD_GOALIE_APAL	EQU	00A0H			;UHL
TD_GOALIE_HPAL	EQU	00E0H			;UHL

TD_GOALIE_LIST	EQU	0220H			;UHL	
TD_TEAMNAME_IMG	EQU	0240H			;UHL	
TD_TEAMLOGO_IMG	EQU	0260H			;UHL
TD_HOME_HELMET	equ	0280h			;UHW
TD_AWAY_HELMET	equ	0290h			;UHW
TD_GOALIE_HELMET equ	02A0h			;UHW
;TD_NOT_USED	EQU	02B0H			;UHW
TD_CITY_IMG	EQU	02C0H			;UHL
TD_CITY_STR	EQU	02E0H			;UHL
TD_BIG_GHELM_PAL EQU	0300H			;UHL
TD_NICKNAME_STR	EQU	0320H			;UHL
TD_VCLIP_1	equ	0340H			;UHW
TD_VCLIP_2	equ	0350H			;UHW
TD_BENCHP_AWAY	equ	0360H			;UHL
TD_BENCHP_HOME	equ	0380H			;UHL
TD_ALT_NAME	equ	03a0H			;UHL

**************************************************************************
*								         *
* TEAM PLAYER ENTRY EQUATES						 *
*								         *
**************************************************************************

;	.byte	" "," "," ",month,day,0,0,0
;	.long	head_table,unused
;	.long	shot_table,scale_table
;	.word	mass,0
;	.byte	speed,stopping,cornering,shooting
;	.byte	,passing,dumping,puck handling,checking
;	.long	NAME IMAGE, MUG SHOT IMAGE + HFLIP FLAG
;	.word	helmet_type

TP_HEAD_TABLE	EQU	0040H			;UHL
TP_HELMET_OFF	EQU	0060h		;uhl - set if no helmet is used (no palette)
TP_SECRET_CHAR	EQU	TP_HELMET_OFF
TP_SPEED	equ	00e0h
TP_STOP		equ	00e8h
TP_CORNER	equ	00f0h
TP_SHOOT	equ	00f8h
TP_PASS		equ	0100h
TP_FACEOFF	equ	0108h
TP_HANDLE	equ	0110h
TP_CHECK	equ	0118h
TP_PLYRNAME_IMG	EQU	0120H			;UHL
TP_PLYRMUG_IMG	EQU	0140H			;UHL
TP_HELMET_TYPE	equ	0160h			;UHW

**************************************************************************
*								         *
* SWITCH EQUATES							 *
*								         *
**************************************************************************

M_SW_U	EQU	1		;JOYSTICK UP
M_SW_D	EQU	2		;JOYSTICK DOWN
M_SW_L	EQU	4		;JOYSTICK LEFT
M_SW_R	EQU	8		;JOYSTICK RIGHT
M_SW_S	EQU	16		;SHOOT
M_SW_P	EQU	32		;PASS
M_SW_T	EQU	64		;TURBO
M_SW_ALL	EQU	07FH	;ALL PLAYER SWITCHES

B_SW_U	EQU	0		;JOYSTICK UP
B_SW_D	EQU	1		;JOYSTICK DOWN
B_SW_L	EQU	2		;JOYSTICK LEFT
B_SW_R	EQU	3		;JOYSTICK RIGHT
B_SW_S	EQU	4		;SHOOT
B_SW_P	EQU	5		;PASS
B_SW_T	EQU	6		;TURBO

**************************************************************************
*								         *
* GENERAL SCREEN EQUATES						 *
*								         *
**************************************************************************

P1_X_CENTER	EQU	60
P2_X_CENTER	EQU	160
P3_X_CENTER	EQU	260
P4_X_CENTER	EQU	350

P1_2P_X_CENTER	EQU	60
P2_2P_X_CENTER	EQU	350

**************************************************************************
*								         *
* GENERAL RINK EQUATES							 *
*								         *
**************************************************************************

;LEFT IS LEFT
;RIGHT IS RIGHT
;TOP IS FAR
;BOTTOM IS CLOSE

TOP_SIDEBOARD_Z	EQU	[679,0]		;02A70000H
BOT_SIDEBOARD_Z	EQU	0

LEFT_ENDBOARD_X	EQU	[-798,0]	;-031E0000H
RGHT_ENDBOARD_X	EQU     [798,0]		; 031E0000H

CENTER_X	EQU	0
CENTER_Z	EQU	[339,32768]	;01538000H

LEFT_BLUELINE_X	EQU	[-233,0]	;-0E90000H
RGHT_BLUELINE_X	EQU	[233,0]		; 0E90000H

LEFT_GOALLINE_X	EQU	[-688,0]	;-02B00000H
RGHT_GOALLINE_X	EQU     [688,0]		; 02B00000H

GOAL_DEPTH_X	EQU	[42,0]		;02A0000H

TOP_GOALPOST_Z	EQU	[393,0]		;01890000H
BOT_GOALPOST_Z	EQU	[286,0]		;011E0000H

GOAL_RADIUS	EQU	(TOP_GOALPOST_Z-BOT_GOALPOST_Z)/2 ;0358000H
CREASE_RADIUS	EQU	GOAL_RADIUS+01FF000H		  ;0557000H

TOP_CREASE_Z	EQU	CENTER_Z+CREASE_RADIUS
BOT_CREASE_Z	EQU	CENTER_Z-CREASE_RADIUS

**************************************************************************
*								         *
* GENERAL GOAL EQUATES							 *
*								         *
**************************************************************************

OFRONT_OBJ	EQU	ODATA		;UHL FRONT GOAL OBJECT
;OFRONT_OFFSET	EQU	ODATA+020H	;UHL [Y,X] OFFSET FROM UPPER LEFT
;					;    OF FRONT TO UPPER LEFT OF REAR 	


**************************************************************************
*								         *
* GENERAL PUCK EQUATES							 *
*								         *
**************************************************************************

ROUGH_PUCK_MAX	.set	[35,0]		;THIS IS REALLY ROUGH! [32,0] ACTUAL
					; MAX SHOT SPEED + MAX PLAYER SPEED

NORM_GRAVITY	.EQU	[0,3000h]	;if we change this,
					; change y position routines to match

SHOT_GRAVITY	.EQU	[0,2a00h]	;if we change this,
					; change y position routines to match

MAX_SAVE_PUCK_SPEED	EQU	[8,08000h]	;[9,0] ;[15,0]	;MAX PUCK SPEED OFF A SAVE

**************************************************************************
*								         *
* GENERAL PLAYER EQUATES						 *
*								         *
**************************************************************************

STAND_COLLRANGE		EQU	30
GSTAND_COLLRANGE	EQU	40


**************************************************************************
*								         *
* GENERAL GOALIE EQUATES						 *
*								         *
**************************************************************************

;GOALIE POSITION AT GOAL LINE

POSITION_RADIUS	EQU	GOAL_RADIUS+01E8000H

GOALIE_XOFF	EQU	01D0000H ;0D0000H

LEFT_GOALIE_AT_GOAL	EQU	LEFT_GOALLINE_X+GOALIE_XOFF
RGHT_GOALIE_AT_GOAL	EQU	RGHT_GOALLINE_X-GOALIE_XOFF

GSLOW_PUCK	EQU	[16,0]	;[2,0]

FREEZE_TIME	EQU	60	;MAXIMUM TIME PUCK CAN BE HELD UNTIL FROZEN

MAX_SAVE_TTIME	EQU	120

MAX_GAIN_POSSY	EQU	-040000H	;MAXIMUM GAIN POSSESSION Y HEIGHT

MAX_FREEZES	EQU	3		;ALLOWED FREEZES PER PERIOD

FREEZE_PROB	EQU	102 ;10%	;FREEZE PROBABILITY AFTER ALLOWED

;GFLAGS BITS

B_FREEZE	EQU	0	;DON'T MOVE
B_TMOVE		EQU	1	;MOVE TO POSITION WITH TURBO
B_SAVEMADE	EQU	2	;SAVE SUCCESSFUL
B_MISSSAVE	EQU	3	;MISS ON THIS SAVE
B_FETCHING	EQU	4	;FETCHING THE PUCK
B_GLOVESIDE	EQU	5	;PUCK SAVED ON GLOVE SIDE
B_PUCKCHECK	EQU	6	;PUCK CHECKS GOALIE
B_GOHOME	EQU	7	;GOING HOME WITH THE PUCK
B_RSMOTH	EQU	8	;REVERSE SMOTHER

M_FREEZE	EQU	1
M_TMOVE		EQU	2
M_SAVEMADE	EQU	4
M_MISSSAVE	EQU	8
M_FETCHING	EQU	16
M_GLOVESIDE	EQU	32
M_PUCKCHECK	EQU	64
M_GOHOME	EQU	128
M_RSMOTH	EQU	256

;PUCK_GOALIE_CHECK PROCESS DATA EQUATES

PGTIMPACT	EQU	PDATA		;UHL TIME TIL IMPACT POSITION FOR 3(7)
PGXIMPACT	EQU	PDATA+020H	;UHL TIME TIL IMPACT POSITION FOR 3(7)
PGZIMPACT	EQU	PDATA+040H	;UHL Z IMPACT POSITION FOR ANGLE 3(7)
PGDIMPACT	EQU	PDATA+060H	;UHL DISTANCE TO IMPACT POSITION FOR 3(7)

;GOALIE_SPEECH INDEXES

GS_REBOUND	EQU	0 ;		;PUCK REBOUNDS OFF GOALIE (NOT FROM A SAVE!)
GS_SMOTHERED	EQU	1 ;ACTIVE	;SUCCESSFUL SMOTHER
GS_POKECHECK	EQU	2 ;ACTIVE	;SUCCESSFUL POKE CHECK
GS_CROSSCHECK	EQU	3 ;		;SUCCESSFUL CROSS CHECK
GS_FRUSTRATED	EQU	4 ;	 	;GOALIE IS FRUSTRATED
GS_PASSED	EQU	5 ;ACTIVE	;PASS REQUESTED BY PLAYER
GS_FROZEN	EQU	6 ;ACTIVE	;GOALIE FROZE PUCK

;ALL ACTIVE
GS_SAVE		EQU	7		;ALL PURPOSE SAVE CALL
GS_BUTTERFLY	EQU	8
GS_PADSTACK	EQU	9
GS_STICK	EQU	10
GS_GLOVE	EQU	11
GS_BLOCKER	EQU	12
GS_STOMACH	EQU	13		;INTO THE GUT
GS_SKATE	EQU	14

GS_GAINS_POSS	EQU	15		;GOALIE GAINS POSSESSION

**************************************************************************

XD0000	.set	[000,00000h]
XD0005	.set	[000,08000h]
XD0009	.set	[000,0e666h]
XD0010	.set	[001,00000h]
XD0011	.set	[001,0199ah]
XD0012	.set	[001,03333h]
XD0014	.set	[001,06666h]
XD0015	.set	[001,08000h]
XD0017	.set	[001,0b333h]
XD0018	.set	[001,0cccdh]
XD0019	.set	[001,0e666h]
XD0020	.set	[002,00000h]
XD0021	.set	[002,0199ah]
XD0022	.set	[002,03333h]
XD0023	.set	[002,04ccdh]
XD0024	.set	[002,06666h]
XD0025	.set	[002,08000h]
XD0027	.set	[002,0b333h]
XD0029	.set	[002,0e666h]
XD0030	.set	[003,00000h]
XD0031	.set	[003,0199ah]
XD0033	.set	[003,04ccdh]
XD0035	.set	[003,08000h]
XD0036	.set	[003,0999ah]
XD0038	.set	[003,0cccdh]
XD0039	.set	[003,0e666h]
XD0040	.set	[004,00000h]
XD0041	.set	[004,0199ah]
XD0042	.set	[004,03333h]
XD0043	.set	[004,04ccdh]
XD0044	.set	[004,06666h]
XD0045	.set	[004,08000h]
XD0047	.set	[004,0b333h]
XD0048	.set	[004,0cccdh]
XD0050	.set	[005,00000h]
XD0052	.set	[005,03333h]
XD0053	.set	[005,04ccdh]
XD0054	.set	[005,06666h]
XD0055	.set	[005,08000h]
XD0056	.set	[005,0999ah]
XD0057	.set	[005,0b333h]
XD0058	.set	[005,0cccdh]
XD0060	.set	[006,00000h]
XD0063	.set	[006,04ccdh]
XD0066	.set	[006,0999ah]
XD0069	.set	[006,0e666h]
XD0070	.set	[007,00000h]
XD0073	.set	[007,04ccdh]
XD0075	.set	[007,08000h]
XD0077	.set	[007,0b333h]
XD0080	.set	[008,00000h]
XD0090	.set	[009,00000h]
XD0100	.set	[010,00000h]
XD0110	.set	[011,00000h]
XD0120	.set	[012,00000h]
XD0130	.set	[013,00000h]
XD0140	.set	[014,00000h]
XD0150	.set	[015,00000h]
XD0200	.set	[020,00000h]
XD0225	.set	[022,08000h]
XD0250	.set	[025,00000h]
XD0300	.set	[030,00000h]
XD0350	.set	[035,00000h]
XD0400	.set	[040,00000h]	;40 degrees is our crossover point
XD0450	.set	[045,00000h]
XD0500	.set	[050,00000h]
XD0540	.set	[054,00000h]
XD0570	.set	[057,00000h]	;57 degrees is our crossover point
XD0600	.set	[060,00000h]
XD0675	.set	[067,08000h]
XD0700	.set	[070,00000h]
XD0750	.set	[075,00000h]
XD0800	.set	[080,00000h]	;80 degrees is our crossover point
XD0900	.set	[090,00000h]
XD1000	.set	[100,00000h]
XD1100	.set	[110,00000h]
XD1125	.set	[112,08000h]
XD1350	.set	[135,00000h]
XD1575	.set	[157,08000h]
XD1600	.set	[160,00000h]
XD1800	.set	[180,00000h]
XD2025	.set	[202,08000h]
XD2250	.set	[225,00000h]
XD2475	.set	[247,08000h]
XD2500	.set	[250,00000h]
XD2600	.set	[260,00000h]
XD2700	.set	[270,00000h]
XD2925	.set	[292,08000h]
XD3150	.set	[315,00000h]
XD3375	.set	[337,08000h]
XD3500	.set	[350,00000h]
XD3600	.set	[360,00000h]
XD3825	.set	[382,08000h]
XD4050	.set	[405,00000h]
XD7200	.set	[720,00000h]

*ODATA EQUATES

;EVERYTHING
ODT_DIR		.equ	ODATA		;UHL direction object is moving (s15:16 radians)
ODT_VEL		.equ	ODATA+020H	;UHL velocity magnitude of object (s15:16)
ODT_REALXVEL	.equ	ODATA+040H	;SHL x velocity before onscreen quick takes over
ODT_EVEND	.EQU	ODATA+060H	;END OF EVERYTHING

;PLAYER	GLOBAL
ODT_DVEL	.equ	ODT_EVEND	;UHL angular velocity of object (s15:16 radians/tick)
ODT_PBK		.equ	ODT_EVEND+020H	;UHL player block address
ODT_TIGHT	.equ	ODT_EVEND+040H	;UHW tight UDLR
ODT_SAVEVEL	.equ	ODT_EVEND+050H	;UHL save old velocity during 'rubber band' push
ODT_SAVEDIR	.equ	ODT_EVEND+070H	;UHL direction saved for script use
ODT_GDIR	.equ	ODT_EVEND+090H	;UHL goal direction to move to - temporary
ODT_TURBO	.equ	ODT_EVEND+0B0H	;UHW non zero for non turbo - temporary
ODT_FOCIOFF0	.EQU	ODT_EVEND+0C0H	;UHL FOCI [Z,X] WORLD OFFSET FROM ANIMP
ODT_FOCIOFF1	.EQU	ODT_EVEND+0E0H	;UHL FOCI [Z,X] WORLD OFFSET FROM ANIMP
ODT_FHEIGHT	.equ	ODT_EVEND+0100h	;UHW height of player for puck checks)
ODT_LOOPC	.equ	ODT_EVEND+0110h	;UHW loop counter used in some animation scripts
ODT_PLEND	.equ	ODT_EVEND+0120H	;END OF PLAYER

;GOALIE	GLOBAL
ODT_GFLAGS	.EQU	ODT_PLEND	;UHW GOALIE FLAGS
ODT_GSAVETIME	.EQU	ODT_PLEND+010H	;UHW TIME TO START SAVE ANIMATION
ODT_GSAVE	.EQU	ODT_PLEND+020H	;UHL SAVE ROUTINE
ODT_GZIMPACT	.EQU	ODT_PLEND+040H	;UHL Z IMPACT POSITION
ODT_GXIMPACT	.EQU	ODT_PLEND+060H	;UHL X IMPACT POSITION
ODT_GLASTSIRQ	.EQU	ODT_PLEND+080H	;UHL IRQ TIME OF LAST SAVE
ODT_GTSAVES	.EQU	ODT_PLEND+0A0H	;UHW TOTAL SAVES, WITHIN MAX_TSAVE_TIME
ODT_GPOSSIRQ	.EQU	ODT_PLEND+0B0H	;UHL IRQ TIME OF POSSESSION
ODT_GZPOSPOSS	.EQU	ODT_PLEND+0D0H	;UHL Z POSITION AT TIME OF POSSESSION
ODT_GCOMPTIME	.EQU	ODT_PLEND+0F0H	;UHL TIME OF LAST SAVE COMPUTATION
ODT_GFREEZES	.EQU	ODT_PLEND+0110H	;UHB TOTAL GOALIE FREEZES THIS PERIOD
;ODT_GUNUSED	.EQU	ODT_PLEND+0110H	;UHB UNUSED
ODT_GEND	.EQU	ODT_PLEND+0120H	;END OF GOALIE

;PUCK
ODT_PSPOT	.equ	ODT_EVEND	;UHW puck object, adjustment for players rink location
ODT_PHOT	.equ	ODT_EVEND+010H	;UHW puck object, adjustment for players hot/cold
ODT_POPEN	.equ	ODT_EVEND+020H	;UHW puck object, adjustment for players openness when shooting
ODT_PTYPE	.equ	ODT_EVEND+030H	;UHW puck object, adjustment for type of shot player made
ODT_XDEST	.equ	ODT_EVEND+040H	;SHL x destination of pass
ODT_ZDEST	.equ	ODT_EVEND+060H	;SHL z destination of pass
ODT_PFLAGS	.EQU	ODT_EVEND+080H	;UHW PUCK FLAGS
ODT_XSTRT	.equ	ODT_EVEND+090H	;SHL x start of pass
ODT_ZSTRT	.equ	ODT_EVEND+0b0H	;SHL z start of pass
ODT_PFTIME	.equ	ODT_EVEND+0e0H	;UHW loops at current frame for flat puck
ODT_PEND	.EQU	ODT_EVEND+0f0H	;END OF PUCK

;ICE SPRAY
ODT_POBJ	.equ	ODT_EVEND	;UHL player object
ODT_PANIMSCR	.equ	ODT_EVEND+020h	;UHL work for player on this script only

;MISC FOR PLAYER ANIMATION INDIVIDUAL USE
ODT_TEMP1	.equ	ODT_GEND	;UHL
ODT_TEMP2	.equ	ODT_GEND+020h	;UHL
ODT_SC_OVERRIDE	.equ	ODT_GEND+040h	;UHL scale to override scale table
ODT_SC_XSCALE	.equ	ODT_GEND+060h	;UHW scale of overrided imaged @Z=0 (multiplier * scaletable@z=0) (for head placement only)
ODT_MEND	.equ	ODT_GEND+070h	;end of misc

ODT_END		.EQU	ODATA+0340H	;AIN'T NO MORE AFTER DIS (ODATAX)

	.if	(ODT_END < ODT_EVEND)|(ODT_END < ODT_PLEND)|(ODT_END < ODT_GEND)|(ODT_END < ODT_PEND)|(ODT_END < ODT_MEND)
	ODATA BLOWN!
	.endif

**************************************************************************
*								         *
* PUCK EQUATES								 *
*								         *
**************************************************************************

;PUCK_MODE, only valid if puck_control = 0

PUM_OPEN	EQU	0	;open puck
PUM_FACE	EQU	1	;puck at face off, always get control
PUM_PASS	EQU	10	;pass
PUM_TPASS	EQU	11	;turbo pass
PUM_SHOT	EQU	12	;regular shot
PUM_SSHOT	EQU	13	;slap shot
PUM_ONETIME	EQU	14	;one timer
PUM_DUMP	EQU	15	;dump into zone
PUM_SCORE	EQU	99	;puck has scored a goal, no one can touch it till face off
PUM_FACEOFF	EQU	100	;face off, can't control yet
PUM_ENDPER	EQU	101	;end of period, can't control

;PUCK FLAGS

M_INFRONT	EQU	1	;PLACE PUCK IN FRONT OF PLAYER
M_INBACK	EQU	2	;PLACE PUCK IN BACK OF PLAYER

B_INFRONT	EQU	0
B_INBACK	EQU	1

**************************************************************************
*								         *
* PLAYER BLOCK EQUATES							 *
*								         *
**************************************************************************

PLAYER_BLOCK_BSIZE .equ	12			;shift 12 bits to get block #
PLAYER_BLOCK_SIZE  .equ	4096			;= PLAYER_2_BLOCK-PLAYER_1_BLOCK

********************************
*			       *
* PLAYER PHYSICAL DATA	       *
*			       *
********************************
POF_NUMBER		.equ	0000h	;UHB 1-8
;
POF_IMAGE_TABLE		.equ	0020h	;UHL table for players images
POF_HEAD_TABLE		.equ	0040h	;UHL table to player head/helmet data
POF_CMOS		.equ	0060h	;UHW CMOS entry number for player
POF_CHARACTER		.equ	0070h	;UHW which player this is (person)
POF_TEAM		.equ	0080h	;UHW which team this is
POF_HOME		.equ	0090h	;UHW 0 - home, 1 - visitor
POF_MASS		.equ	00a0h	;UHW player mass
POF_INITIAL1		.equ	00b0h	;UHB 0-25 A-Z, 26 = ' '
POF_INITIAL2		.equ	00b8h	;UHB 0-25 A-Z, 26 = ' '
POF_INITIAL3		.equ	00c0h	;UHB 0-25 A-Z, 26 = ' '
POF_BMONTH		.equ	00c8h	;UHB 1-12
POF_BDAY		.equ	00d0h	;UHB 1-31
********************************
*			       *
* PLAYER ABILITY DATA	       *
*			       *
********************************
POF_S_SPED		.equ	00e0h	;UHL table pointer - player speed data
POF_S_STOP		.equ	0100h	;UHL table pointer - player stopping data
POF_S_CORN		.equ	0120h	;UHL table pointer - player cornering data
POF_S_SHOT		.equ	0140h	;UHL table pointer - player shooting data
POF_S_PASS		.equ	0160h	;UHL table pointer - player passing data
POF_S_FACE		.equ	0180h	;UHL table pointer - player dumping data
POF_S_HAND		.equ	01a0h	;UHL table pointer - player handling data
POF_S_CHEK		.equ	01c0h	;UHL table pointer - player check data
POF_S_STAB		.equ	01e0h	;UHL table pointer - player shot table
********************************
*			       *
* PLAYER STATES		       *
*			       *
********************************
POF_FLAGS		.equ	0200h	;UHW - see below
POF_MODE		.equ	0210h	;UHW what player is doing (not valid during higher control)
POF_RELEASE_TIME	.equ	0220h	;UHL waveirqs of estimated shot release time
**************************************************************************
*								         *
* PLAYER PALETTES							 *
*								         *
**************************************************************************
POF_NORMALPAL		.equ	0240h	;UHL non turbo player palette
POF_TURBOPAL		.equ	0260h	;UHL turbo player palette
********************************
*			       *
* PLAYER RELATED OBJECTS       *
*			       *
********************************
POF_OBJECT		.equ	0280h	;UHL players object
POF_SHADOW		.equ	02a0h	;UHL players shadow object
POF_GOALIE_OBJECT	.equ	02c0h	;UHL object of teams goalie
POF_ARROW		.equ	02e0h	;UHL object of players arrow
POF_TURBO_BOX		.equ	0300h	;UHL turbo box object (or press start/insert coin)
POF_TURBO_BAR		.equ	0320h	;UHL turbo bar object (or to control)
POF_TURBO_NAME		.equ	0340h	;UHL turbo name object (both modes)
POF_ARROW_CPU		.equ	0360h	;UHL if player is not human, object for his cpu title
********************************
*			       *
* PLAYER JOYSTICK DATA	       *
*			       *
********************************
POF_BUTTONS		.equ	0380h	;UHW buttons of player
POF_DIRECTION		.equ	0390h	;UHB last facing direction of player
POF_JOY			.equ	0398h	;UHB joystick direction (1-8)
POF_I_JOY		.equ	03a0h	;UHB ignore this joystick direction
POF_M_JOY		.equ	03a8h	;UHB modified joystick direction (1-8)
POF_CORNER_TEMP		.equ	03b0h	;UHB last corner check for diagonal removal
POF_PPMOD		.equ	03c0h	;UHW puck point might be too close to wall, use close script
POF_BDIRECTION		.equ	03d0h	;UHB buffered direction (takes effect on script change)
POF_LAST_DIRECTION	.equ	03d8h	;UHB last POF_DIRECTION (for backwards/forwards thing)
POF_FAKE_DIRECTION	.equ	03e0h	;UHW fake direction for drone use at faceoff
********************************
*			       *
* MISC PLAYER DATA	       *
*			       *
********************************
POF_SHOT_FAKE		.equ	0400h	;UHL time of last shot start (waveirqs)
POF_SHOT_START		.equ	0420h	;UHL started shooting at this time (for fake test and dump puck tests)
POF_SPEED_GL		.equ	0440h	;UHL used to see if we are speeding up or slowing down
POF_PASS_START		.equ	0460h	;UHL started passing at this time (for dump puck tests)
POF_SHOOT_CURRENT	.equ	0480h	;UHL current shoot speed (for calculations and reference)
POF_SPEED_BOOST		.equ	04a0h	;SHL stuffed at control start, is 0 or defense boost, or negative puck against
POF_TURBO_AMOUNT	.equ	04c0h	;SHL turbo amount s15:16
POF_SHOT_RELEASE	.equ	04e0h	;UHL call this on a release of shoot, during a shoot
POF_SHOT_PASS		.equ	0500h	;UHL call this on a pass during a shoot
POF_LAST_BOARD_CVEL	.equ	0520h	;UHL last velocity of board crash
POF_PASS_RELEASE	.equ	0540h	;UHL call this on a release of shoot, during a shoot
POF_ARROW_TIME		.equ	0560h	;UHW time left to show arrow
POF_TURBO_DELAY		.equ	0570h	;SHW delay till we bring turbo up
POF_TURBO_MODE		.equ	0580h	;SHW turbo is on when <> 0
POF_STAND_STILL		.equ	0590h	;UHB player is standing still # ticks
POF_IGNORE_PUCK		.equ	0598h	;UHB ignore puck till this is zero
POF_ARROW_HYST		.equ	05a0h	;UHB player arrow hysteresis
POF_TOP_MODE		.equ	05a8h	;UHB current state of top
POF_SKID_BOOST		.equ	05b0h	;UHB current skid boost
POF_TURBO_OB		.equ	05c0h	;UHW turbo is off button pushed, countdown code
POF_HAS_CHECKED		.equ	05d0h	;UHW player has checked this script
POF_TIRED		.equ	05e0h	;UHW last tired count (turbo left before faceoff)
POF_QS_OK		.equ	05f0h	;UHW ok to do quick start (+ = direction ok, 0 = ok all, -1 = nok)
********************************
*			       *
* PLAYER DISTANCE DATA	       *
*			       *
********************************
POF_D_1P		.equ	0600h	;UHW distance to player 1
POF_D_2P		.equ	0610h	;UHW distance to player 2
POF_D_3P		.equ	0620h	;UHW distance to player 3
POF_D_4P		.equ	0630h	;UHW distance to player 4
POF_D_5P		.equ	0640h	;UHW distance to player 5
POF_D_6P		.equ	0650h	;UHW distance to player 6
POF_D_7P		.equ	0660h	;UHW distance to player 7
POF_D_8P		.equ	0670h	;UHW distance to player 8
POF_D_PUCK		.equ	0680h	;UHW distance to puck (only valid if free puck, or opposing team)
POF_D_COLL		.EQU	0690H	;UHW COLLISION DISTANCE
POF_D_LASTPUCK0		.EQU	06A0H	;UHW LAST DISTANCE TO PUCK
POF_D_LASTPUCK1		.EQU	06B0H	;UHW LAST DISTANCE TO PUCK

**************************************************************************
*								         *
* DRONE LOGIC DATA							 *
*								         *
**************************************************************************
POF_DRONE1		.equ	0700h	;UHW drone point data
POF_DRONE2		.equ	0710h	;UHW drone point data
POF_DRONEC		.equ	0720h	;UHW drone - set on a collision with rink or player
POF_DRONE_PX		.equ	0730h	;UHW drone point goto position (after random adjust)
POF_DRONE_PZ		.equ	0740h	;UHW drone point goto position (after random adjust)
POF_DRONECT		.equ	0750h	;UHW drone count of hits since last change
POF_DRONEPST		.equ	0760h	;UHW drone # steps before we pass or shoot
POF_DRONE_OM		.equ	0770H	;UHW drone offensive mode (0 = normal get open, 1 = breakaway)
**************************************************************************
*								         *
* PLAYER STAT DATA							 *
*								         *
**************************************************************************
POF_SHOTS_P1		.equ	0780h	;UHB shots on goal - period 1
POF_SHOTS_P2		.equ	0788h	;UHB shots on goal - period 2
POF_SHOTS_P3		.equ	0790h	;UHB shots on goal - period 3
POF_SHOTS_PO		.equ	0798h	;UHB shots on goal - overtime
POF_GOALS_P1		.equ	07a0h	;UHB goals scored - period 1
POF_GOALS_P2		.equ	07a8h	;UHB goals scored - period 2
POF_GOALS_P3		.equ	07b0h	;UHB goals scored - period 3
POF_GOALS_PO		.equ	07b8h	;UHB goals scored - overtime
POF_ASSISTS_P1		.equ	07c0h	;UHB assists on goals - period 1
POF_ASSISTS_P2		.equ	07c8h	;UHB assists on goals - period 2
POF_ASSISTS_P3		.equ	07d0h	;UHB assists on goals - period 3
POF_ASSISTS_PO		.equ	07d8h	;UHB assists on goals - overtime
POF_PASSES_P1		.equ	07e0h	;UHB passes - period 1
POF_PASSES_P2		.equ	07e8h	;UHB passes - period 2
POF_PASSES_P3		.equ	07f0h	;UHB passes - period 3
POF_PASSES_PO		.equ	07f8h	;UHB passes - overtime
POF_STEALS_P1		.equ	0800h	;UHB steals - period 1
POF_STEALS_P2		.equ	0808h	;UHB steals - period 2
POF_STEALS_P3		.equ	0810h	;UHB steals - period 3
POF_STEALS_PO		.equ	0818h	;UHB steals - overtime
POF_CHECKS_P1		.equ	0820h	;UHB checks - period 1
POF_CHECKS_P2		.equ	0828h	;UHB checks - period 2
POF_CHECKS_P3		.equ	0830h	;UHB checks - period 3
POF_CHECKS_PO		.equ	0838h	;UHB checks - overtime
POF_SAVES		.EQU	0840H	;UHW SAVES - GOALIE ONLY
**************************************************************************
*								         *
* PLAYER GAME DATA							 *
*								         *
**************************************************************************
POF_PERIODS_PAID	.equ	0900H	;UHB periods paid for (bits 0-3)
**************************************************************************
*								         *
* PLAYER MORE MISC DATA							 *
*								         *
**************************************************************************
POF_LAST_GINTENSITY	.equ	0940h	;UHW last intensity of goalie phrase
POF_LAST_GSAVE		.equ	0950h	;UHL last time of goalie save phrase
;POF_CELEBRATION		.equ	0970h	;UHL celebration script pointer
POF_LEAN_GOAL		.equ	0980h	;SHW last lean
POF_LEAN		.equ	0990h	;SHW -2,-1 - lean to left, 1,2 to right
POF_LEAN_TIME		.equ	09A0h	;UHL waveirqs of lean change
POF_NOFACE		.equ	09C0h	;UHW bits indicate directions we are not allowed to face
POF_DRONE_BUTTONS	.equ	09d0h	;UHW drone button states (for one timer)
POF_DRONE_NETTIME	.equ	09e0h	;UHW used by drone to time guys behind net (written by opponent)
POF_SKATE_RATE_T	.equ	09f0h	;UHW 0-regular skating, 1-fast skating, 2-1 hand fast skating
POF_SKATE_RATE_D	.equ	0a00h	;UHB direction for valid skate_rate restrictions
POF_SKATE_RATE_G	.equ	0a08h	;UHB goal skate_rate_t
POF_TRAIL_PAL		.equ	0a10h	;UHL palette used for trails
POF_DEKE_TIME		.equ	0a30h	;UHL time of last deke count inc
POF_DEKE_COUNT		.equ	0a50h	;UHW deke count value
POF_SAFETY_WARNING	.equ	0a60h	;UHW safety warning on shot
POF_DRONE_OP_STATE	.equ	0a70h	;UHW drone is going through 'o' or 'p' match points
POF_DRONE_OP_TIME	.equ	0a90h	;UHL drone 'o'/'p' switch time
POF_DRONE_MEANNESS	.equ	0ab0h	;UHW count for drone meanness level
POF_DRONE_MEANSTATE	.equ	0ac0h	;UHW drone mean state
POF_DRONE_OUTSIDE	.equ	0ad0h	;UHW drone is from outside if non zero
POF_DRONE_PATTERN	.equ	0ae0h	;UHW pattern # of drone
POF_DRONE_PADDR		.equ	0af0h	;UHL address into current pattern
POF_DRONE_CTIME		.equ	0b10h	;UHL time drone threw check
POF_DRONE_STIME		.equ	0b30h	;UHL time drone shot puck
POF_HOT_OBJECT		.equ	0b50h	;UHL object for player's hot object
POF_HOT_VALUE		.equ	0b70h	;UHW player's hot build up value
POF_HOT_PAL		.equ	0b80h	;UHL palette of hot object
POF_SHOT_ATTEMPTS	.EQU	0BA0H	;UHW NUMBER OF ATTEMPTS SINCE LAST GOAL
POF_DSP_TIME		.equ	0bb0h	;UHL time player deked/split
POF_DSP_TYPE		.equ	0bd0h	;UHW 1 = deke, -1 = split, 0 undecided, 2 = not available
POF_DRONE_LEVEL		.equ	0be0h	;UHW 0-10 drone difficulty level (if drone)
POF_HOT_VALUE_D		.equ	0bf0h	;UHW displayed hot value
POF_FREEZE_BITS		.equ	0c00h	;UHW bits of freeze game messages we have shown player
POF_FREEZE_OFFTIME	.equ	0c10h	;UHW time player is off screen
POF_CELEBRATION		.equ	0c20h	;UHL celebration script pointer
POF_LOCKED_CHAR		.EQU	0C40H	;UHW LOCKED CHARACTER
POF_PUP_FLAGS		.equ	0C50H	;UHW POWERUP FLAGS
POF_DRONE_NO_CHECK	.equ	0c60h	;UHL drone cannot check until after this time
POF_REDPAL		.equ	0c80h	;UHL palette used for trails (red)
POF_TTIME		.equ	0c90h	;UHL time drone button pushed (elbow)
**************************************************************************
*								         *
* PLAYER CHECK DATA							 *
*								         *
**************************************************************************
POF_CHECK_LAST		.equ	0d00h	;UHL time of last checked
POF_CHECK_COUNT		.equ	0d20h	;UHW count of checks close together
POF_HIT_BOARDS		.equ	0d30h	;UHW body checks - hit boards
POF_CONTROL_OBJECT	.equ	0d40h	;UHL pointer to controlling object
POF_CONTROL_SCRIPT	.equ	0d60h	;UHL controlling objects script (we abort if no match)
POF_CONTROLLED		.equ	0d80h	;UHL pointer to object we are controlling
POF_CONTROLLED_SCRIPT	.equ	0da0h	;UHL controlled objects script (we abort if no match)
POF_CWALL_TIME		.equ	0dc0h	;UHW time locked to wall
POF_HIT_BOARDS_A	.equ	0dd0h	;UHW angle we bounced off boards
POF_ATTACH_X		.equ	0de0h	;UHW x offset to attached player
POF_ATTACH_Z		.equ	0df0h	;UHW z offset to attached player
POF_ATTACH_Y		.equ	0e00h	;UHW y offset to attached player
POF_GET_UP_COUNT	.equ	0e10h	;UHW current get up count of fallen player
POF_GET_UP_GOAL		.equ	0e20h	;UHW get up count goal of fallen player
POF_ATTACH_VDIR		.equ	0e30h	;UHL attach velocity dir
POF_ATTACH_VVEL		.equ	0e50h	;UHL attach velocity
POF_ATTACH_ABORT	.equ	0e70h	;UHW abort count for attach
POF_ATTACH_F		.equ	0e80h	;UHW 0 if facing wall, non zero else
;POF_END		.EQU	01000H

;POF_TOP_MODE
;	0 - nothing on top
;	1 - name/turbo bar
;	2 - press start
;	3 - insert coin(s)
;	4 - to control/player
;	5 - please wait

;POF_MODE

;PLAYER MODES

PM_STAND	EQU	0	;standing
PM_SKATE	EQU	1	;skating
PM_PASS		EQU	2	;passing
PM_SHOOT	EQU	3	;shooting
PM_SKID		EQU	4	;skidding to stop (for reverse or stop)
PM_STEAL	EQU	5	;steal puck
PM_CROSSCHECK	EQU	6	;pushing
PM_SHAKE	EQU	7	;get shaken up
PM_DUMP		EQU	8	;dumping
;PM_STANCE	EQU	9	;IN GOALIE STANCE
PM_FALL		EQU	10	;fall to stomach/back
;PM_DEFLECT	EQU	11	;GOALIE DEFLECTING
;PM_SAVE	EQU	12	;GOALIE SAVE
PM_ONETIME	EQU	13	;player is one timing
PM_HIGHSTICK	EQU	14	;player is highsticking
PM_SLASH	EQU	15	;player is slashing
PM_SWING	EQU	16	;player is flagrantly swinging
PM_HIP		EQU	17	;player is hip checking (or other backwards check)
PM_BLOCK	EQU	18	;player is blocking a shot (somehow)

;GOALIE MODES

PM_GSTAND	EQU	0	;GOALIE STANDING
PM_GSKATE	EQU	1	;GOALIE SKATING
PM_GPASS	EQU	2	;GOALIE PASSING
;PM_GSHOOT	EQU	3	;shooting
PM_GSKID	EQU	4	;skidding to stop (for reverse or stop)
;PM_GSTEAL	EQU	5	;steal puck
PM_GCROSSCHECK	EQU	6	;GOALIE CROSS CHECKING
;PM_GSHAKE	EQU	7	;get shaken up
;PM_GDUMP	EQU	8	;dumping
;PM_GSTANCE	EQU	9	;GOALIE IN STANCE
;PM_GFALL	EQU	10	;fall to stomach/back
PM_GDEFLECT	EQU	11	;GOALIE DEFLECTING PUCK
PM_GSAVE	EQU	12	;GOALIE SAVING PUCK
;PM_GONETIME	EQU	13	;player is one timing
PM_GSMOTHER	EQU	14	;GOALIE SMOTHERING PUCK
PM_GHOLDING	EQU	15	;GOALIE HOLDING PUCK
PM_GGOAL	EQU	16	;GOALIE AFTER GOAL
PM_GCROUCH	EQU	17	;CROUCH AT FACEOFF
PM_GHUGPOST	EQU	18	;HUG POST
PM_GSIDESHUFF	EQU	19	;SIDE SHUFFLE
PM_GCHECKED	EQU	20	;RECEIVING A CHECK


;POF_BUTTONS
;	bit 0 - shoot
;	    1 - pass
;	    2 - turbo

*POF_FLAGS EQUATES
B_PF_HUMAN	.equ	0	;player is human
B_PF_CONTROL	.equ	1	;player has control over his man
B_PF_GOALIE	.equ	2	;PLAYER BLOCK IS GOALIE
B_PF_OKDIR	.equ	3	;ok to set player direction exactly
B_PF_HIGHER	.equ	4	;a higher power has control of player (after score, etc)
B_PF_HIGHER_W	.equ	5	;a higher power is waiting to take control
B_PF_SIG_SHOOT	.equ	6	;player is signalling shoot
B_PF_SIG_PASS	.equ	7	;player is signalling pass
B_PF_BPASS	.equ	8	;pass is of bounce type
B_PF_CONTROLM	.equ	9	;player under ~PF_CONTROL has control of movement
B_PF_CONTROLB	.equ	10	;player under ~PF_CONTROL has control of buttons (pass, shoot)
B_PF_REV_FACE	.equ	11	;player is doing a reverse grab faceoff
B_PF_CELEBRATE	.equ	12	;celebration script has player
B_PF_OTD	.equ	13	;player has one timed already on this script
B_PF_TRAILS	.equ	14	;player trails follow player

M_PF_HUMAN	.equ	0000000000000001b
M_PF_CONTROL	.equ	0000000000000010b
M_PF_GOALIE	.equ	0000000000000100b
M_PF_OKDIR	.equ	0000000000001000b
M_PF_HIGHER	.equ	0000000000010000b
M_PF_HIGHER_W	.equ	0000000000100000b
M_PF_SIG_SHOOT	.equ	0000000001000000b
M_PF_SIG_PASS	.equ	0000000010000000b
M_PF_BPASS	.equ	0000000100000000b
M_PF_CONTROLM	.equ	0000001000000000b
M_PF_CONTROLB	.equ	0000010000000000b
M_PF_REV_FACE	.equ	0000100000000000b
M_PF_CELEBRATE	.equ	0001000000000000b
M_PF_OTD	.equ	0010000000000000b
M_PF_TRAILS	.equ	0100000000000000b


B_PUP_BIGHEAD	.EQU	0	;BIG HEAD, JUST LIKE THAT EDHALL SONG
B_PUP_HUGEHEAD	.EQU	1
B_PUP_TINYHEAD	.EQU	2
B_PUP_FATHEAD	.EQU	3
B_PUP_NORMHEAD	.EQU	4

B_PUP_FORCEFAT	.EQU	5	;FORCE TINY HEAD
B_PUP_SPEED	.EQU	6	;INCREASE SPEED
B_PUP_SHOOT	.EQU	7	;         SHOOTING
B_PUP_PASS 	.EQU	8	;         PASSING
B_PUP_CHECK	.EQU	9	;         CHECKING
B_PUP_PUCK 	.EQU	10	;         PUCK HANDLING
B_PUP_TURBO	.EQU	11	;FAST TURBO RECOVERY

M_PUP_BIGHEAD  	.EQU	00001H
M_PUP_HUGEHEAD 	.EQU	00002H
M_PUP_TINYHEAD 	.EQU	00004H
M_PUP_FATHEAD 	.EQU	00008H
M_PUP_NORMHEAD 	.EQU	00010H

M_PUP_FORCEFAT	.EQU	00020H
M_PUP_SPEED	.EQU	00040H
M_PUP_SHOOT	.EQU	00080H
M_PUP_PASS 	.EQU	00100H
M_PUP_CHECK	.EQU	00200H
M_PUP_PUCK 	.EQU	00400H
M_PUP_TURBO	.EQU	00800H

M_PUP_HEADS	.EQU	M_PUP_BIGHEAD|M_PUP_HUGEHEAD|M_PUP_TINYHEAD|M_PUP_FATHEAD|M_PUP_NORMHEAD

M_PUP_ATTR	.EQU	M_PUP_SPEED|M_PUP_SHOOT|M_PUP_PASS|M_PUP_CHECK|M_PUP_PUCK|M_PUP_TURBO


***************
*	      *
* POF_S_SPED  *
*	      *
***************
PS_SP_SPEED_0			.equ	0000h	;UHL speed to start moving
PS_SP_SPEED_1			.equ	0020h	;UHL player speed 1
PS_SP_SPEED_2			.equ	0040h	;UHL player speed 2
PS_SP_S0_THRESH			.equ	0060h	;UHL threshhold to switch from speed 0 to speed 1
PS_SP_SPEED_THRESH		.equ	0080h	;UHL threshold to switch speeds from speed_1 to speed_2
PS_SP_TURBO_0			.equ	00A0h	;UHL turbo speed to start moving
PS_SP_TURBO_1			.equ	00C0h	;UHL player turbo speed 1
PS_SP_TURBO_2			.equ	00E0h	;UHL player turbo speed 2
PS_SP_T0_THRESH			.equ	0100h	;UHL threshhold to switch from turbo 0 to turbo 1
PS_SP_TURBO_THRESH		.equ	0120h	;UHL threshold to switch speeds from turbo_1 to turbo_2
PS_SP_DEFENSE_BOOST		.equ	0140h	;UHL add to speeds when on defense
PS_SP_CONTROL_PENALTY		.equ	0160h	;UHL penalty for when player has puck (is subtracted)
PS_SP_SAME_0_MT			.equ	0180h	;UHB same direction starting speed move to
PS_SP_SAME_L_MT			.equ	0188h	;UHB same direction low speed move to
PS_SP_SAME_H_MT			.equ	0190h	;UHB same direction high speed move to
;
PS_SP_TURBO_DOWN		.equ	01A0h	;UHW to add going down
PS_SP_TURBO_UP			.equ	01B0h	;UHW to add going up

***************
*	      *
* POF_S_STOP  *
*	      *
***************
PS_ST_STOP_THRESH		.equ	0000h	;UHL player will stop when going this slow
PS_ST_RSTOP_THRESH		.equ	0020h	;UHL player will stop when reverse going this slow
PS_ST_SKID_R_MT			.equ	0040h	;UHB skid reverse move to
PS_ST_SKID_S_MT			.equ	0048h	;UHB skid stop move to
PS_ST_TSKID_R_MT		.equ	0050h	;UHB turbo skid reverse move to
PS_ST_TSKID_S_MT		.equ	0058h	;UHB turbo skid stop move to
PS_ST_DEFENSE_SKID		.equ	0060h	;UHB add to skid mt if defense
;

***************
*	      *
* POF_S_CORN  *
*	      *
***************
PS_CR_SKID			.equ	0000h	;UHL if we want to change by > this, skid to stop
PS_CR_TURN_TABLE		.equ	0020h
PS_CR_TURN_TABLE_D		.equ	0040h
PS_CR_TURN_TABLE_C		.equ	0060h
***************
*	      *
* POF_S_SHOT  *
*	      *
***************
PS_SH_SHOOT0_SPEED		.equ	0000h	;UHL initial speed used to shoot at goal
PS_SH_SHOOT_SPEED		.equ	0020h	;UHL final speed used to shoot at goal
PS_SH_SHOOT0_TURBO		.equ	0040h	;UHL initial turbo speed used to shoot at goal
PS_SH_SHOOT_TURBO		.equ	0060h	;UHL final turbo speed used to shoot at goal
PS_SH_MAX_YVEL			.equ	0080h	;UHL maximum y velocity player can give to puck (negative of yvel)
PS_SH_SHOOT_MT			.equ	00A0h	;UHB move to amount on shoot speed
PS_SH_SHOOTT_MT			.equ	00A8h	;UHB move to amount on shoot speed turbo
PS_SH_SHOT_CHANGE		.equ	00B0h	;UHL called to change shot angle
PS_SH_TSHOT_CHANGE		.equ	00D0h	;UHL called to change turbo shot angle

***************
*	      *
* POF_S_PASS  *
*	      *
***************
PS_PS_PASS_SPEED		.equ	0000h	;UHL speed used to pass to other player
PS_PS_PASS_TURBO		.equ	0020h	;UHL turbo speed used to pass to other player
PS_PS_PASS_GTHRESH		.equ	0040h	;UHW passes below this distance stay on ice
PS_PS_PASS_MTHRESH		.equ	0050h	;UHW passes below this distance sometimes stay on ice
PS_PS_TPASS_GTHRESH		.equ	0060h	;UHW turbo passes below this distance stay on ice
PS_PS_TPASS_MTHRESH		.equ	0070h	;UHW turbo passes below this distance sometimes stay on ice
PS_PS_PASS_CHANGE		.equ	0080h	;UHL called to change pass angle
PS_PS_TPASS_CHANGE		.equ	00A0h	;UHL called to change turbo shot angle

***************
*	      *
* POF_S_DUMP  *
*	      *
***************
;PS_DP_DUMP_SPEED		.equ	0000h	;UHL speed used to dump puck
;PS_DP_DUMP_TURBO		.equ	0020h	;UHL turbo speed used to dump
;PS_DP_DUMP_CHANGE		.equ	0040h	;UHL called to change dump shot angle
;PS_DP_TDUMP_CHANGE		.equ	0060h	;UHL called to change turbo dump shot angle

***************
*	      *
* POF_S_HAND  *
*	      *
***************
PS_HN_INT_CONTROL		.equ	0000h	;UHL called to see if we control after an intended pass
PS_HN_OFF_CONTROL		.equ	0020h	;UHL called to see if we control after an offensive stop
PS_HN_DEF_CONTROL		.equ	0040h	;UHL called to see if we control after a defensive stop

***************
*	      *
* POF_S_CHEK  *
*	      *
***************
;following are indexed, and NOT referenced by equate
PS_CK_NO_LOSS		.equ	0000h	;UHL turbo removed for throwing check
PS_CK_SOME_LOSS		.equ	0020h	;UHL turbo removed for checking somebody 
PS_CK_DOWN_LOSS		.equ	0040h	;UHL extra turbo removed for checking down person
PS_CK_SKILL		.equ	0060h	;UHW checking 1-5 skill level

**************************************************************************
*								         *
* CMOS PLAYER EQUATES							 *
*								         *
**************************************************************************
;CMX_INITIAL1	.equ	0	;5
;CMX_INITIAL2	.equ	5	;5
;CMX_INITIAL3	.equ	10	;5
;CMX_BIRTHDAY	.equ	15	;9
;CMX_TEAMSBEAT	.equ	24	;32
;CMX_NEXTTEAM	.equ	56	;5
;CMX_WINS	.equ	61	;11
;CMX_LOSSES	.equ	71	;10
;CMX_TIES	.equ	81	;8
;CMX_FIGHTWINS	.equ	89	;9
;CMX_FIGHTLOSSES	.equ	98	;9
;CMX_LASTTEAM	.equ	107	;5
;CMX_LASTRIVAL	.equ	112	;5
;CMX_LASTSCORE1	.equ	117	;6
;CMX_LASTSCORE2	.equ	123	;6
;CMX_LASTVISITOR	.equ	129	;1
;CMX_N		.equ	130	;x
;CMX_CHECKSUM	.equ	248	;8
;CMX_END		.equ	256	

;**************************************************************************
;*									  *
;* OBJECT I.D. EQUATES							  *
;* 	       15		   0					  *
;* OID FORMAT -- SSSS SIII IIII IIII	new				  *
;* 	S = SUPPLEMENTAL LIST #						  *
;* 	I = IDENTIFIER(SUB-TYPE)					  *
;* 									  *
;* xxxx x000 0000 0000 (OID) xxxx=bit positions of supp field		  *
;*									  *
;**************************************************************************
;If # of bits changed, fix size of ram table SUPPLSTS
SR_SUPP	.set	11	;knock off bottom bits

*
*GENERIC OBJECT SUPPLEMENTAL I.D. EQUATES
*
SUPP_0	.EQU	0
SUPP_1	.EQU	00800H		;players
SUPP_2	.EQU	01000H		;players shadows
SUPP_3	.EQU	01800H		;back wall
SUPP_4	.EQU	02000H		;alt wnz/wnone (halves of dims) (midway logo)
SUPP_5	.EQU	02800H		;player scored by box
SUPP_6	.EQU	03000H		;REAR GOAL PARTS
SUPP_7	.EQU	03800H
SUPP_8	.EQU	04000H
SUPP_9	.EQU	04800H
SUPP_10	.EQU	05000H
SUPP_11	.EQU	05800H
SUPP_12	.EQU	06000H
SUPP_13	.EQU	06800H
SUPP_14	.EQU	07000H
SUPP_15	.EQU	07800H

*
*POWERUP PROCESS AND OBJECT IDENTIFIER EQUATES
*

OID_PLAYER_1		EQU	SUPP_1+00110H
OID_PLAYER_2		EQU	SUPP_1+00120H
OID_PLAYER_3		EQU	SUPP_1+00130H
OID_PLAYER_4		EQU	SUPP_1+00140H
OID_PLAYER_5		EQU	SUPP_1+00150H
OID_PLAYER_6		EQU	SUPP_1+00160H
OID_PLAYER_7		EQU	SUPP_1+00170H
OID_PLAYER_8		EQU	SUPP_1+00180H
OID_PLAYER_1_SHAD	EQU	SUPP_2+00111H
OID_PLAYER_2_SHAD	EQU	SUPP_2+00121H
OID_PLAYER_3_SHAD	EQU	SUPP_2+00131H
OID_PLAYER_4_SHAD	EQU	SUPP_2+00141H
OID_PLAYER_5_SHAD	EQU	SUPP_2+00151H
OID_PLAYER_6_SHAD	EQU	SUPP_2+00161H
OID_PLAYER_7_SHAD	EQU	SUPP_2+00171H
OID_PLAYER_8_SHAD	EQU	SUPP_2+00181H
OID_REF_SHAD		EQU	SUPP_2+001f0H

OID_PUCK		EQU	0200h
OID_HEAD		EQU	0201h
OID_PUCK_SHADOW		EQU	0202h
OID_GOAL		EQU	0203H		;goal objects
OID_BACKWALL		EQU	SUPP_3+0204H	;back wall images
OID_EDGE		EQU	0205H		;edge rink pieces
OID_BIGPUCK		EQU	0206H
OID_PUCK_TRAIL		EQU	0207H
OID_SCORED_BY		EQU	SUPP_5+0208H	;scored_by box (picture, goals...)
OID_RGOAL		EQU	SUPP_6+0209H	;REAR goal objects
OID_PIPE		EQU	020AH		;PIPE FRAGMENT
OID_FLASH		EQU	020BH		;camera flash

OID_TURBO_1		EQU	0301H		;turbo images (score display)
OID_TURBO_2		EQU	0302H		;turbo images (score display)
OID_TURBO_5		EQU	0305H		;turbo images (score display)
OID_TURBO_6		EQU	0306H		;turbo images (score display)
OID_TURBOBAR_1		EQU	0311H		;turbo bar image (score display)
OID_TURBOBAR_2		EQU	0312H		;turbo bar image (score display)
OID_TURBOBAR_5		EQU	0315H		;turbo bar image (score display)
OID_TURBOBAR_6		EQU	0316H		;turbo bar image (score display)
OID_TURBONAME_1		EQU	0321H		;turbo images (turbo name)
OID_TURBONAME_2		EQU	0322H		;turbo images (turbo name)
OID_TURBONAME_5		EQU	0325H		;turbo images (turbo name)
OID_TURBONAME_6		EQU	0326H		;turbo images (turbo name)
OID_TURBOSBAR_1		EQU	0331H		;small turbo bar
OID_TURBOSBAR_2		EQU	0332H		;small turbo bar
OID_TURBOSBAR_5		EQU	0335H		;small turbo bar
OID_TURBOSBAR_6		EQU	0336H		;small turbo bar

OID_LOGO		EQU	0400H		;attract mode logos
OID_DUMMYPAGE		EQU	0401H		;dummy page filler objects
OID_BIGGIRLS		EQU	0402H		;big girl images and stanley cup stuff
OID_GIRLTEXT		EQU	SUPP_7+0403H	;text for big girls (26 teams beat)

OID_TEXT		EQU	0480H		;"OBJECT LIST" TEXT
OID_CREDIT		EQU	0488H		;CREDIT MESSAGE TEXT
OID_PROMPT		EQU	0489H		;"READY FOR" MESSAGE
OID_PROMPT2		EQU	048AH		;"PRESS START" MESSAGE
OID_CUSTOM		EQU	048BH		;CUSTOM MESSAGE, COINAGE, MAX CRED, ETC.
OID_REQUIRED		EQU	048CH		;CREDITS REQUIRED MESSAGE
OID_TIMER		EQU	048DH		;TIMER DIGIT

OID_SELECT_1		EQU	0490H		;SELECT GRAPHICS LEVEL 1
OID_SELECT_2		EQU	0491H		;SELECT GRAPHICS LEVEL 2
OID_SELECT_3		EQU	0492H		;SELECT GRAPHICS LEVEL 3

OID_STAT_1		EQU	SUPP_9+04A0H	;INTERMISSION STAT
OID_STAT_2		EQU	SUPP_10+04A0H	;INTERMISSION STAT
OID_STAT_3		EQU	SUPP_11+04A0H	;INTERMISSION STAT
OID_STAT_4		EQU	SUPP_12+04A0H	;INTERMISSION STAT
OID_STAT_5		EQU	SUPP_13+04A0H	;INTERMISSION STAT
OID_STAT_6		EQU	SUPP_14+04A0H	;INTERMISSION STAT
OID_STAT_7		EQU	SUPP_15+04A0H	;INTERMISSION STAT

OID_ARROW		EQU	0500H		;arrow objects
OID_CPU			EQU	0501H		;cpu label objects
OID_REF			EQU	0502H		;referee object oid
OID_FROZEN_MESSAGE	EQU	0503H		;message box when game is frozen
OID_PUCK_PTR		EQU	0504H		;POINT TO STOPPED PUCK OBJECTS
OID_GCARD		EQU	0505H		;GOALIE CARD OBJECT

MASK_OID_NEW_TIMER	EQU	07F0H
;OID_NEW_SCORE_BOX_1	EQU	SUPP_4+0600H
;OID_NEW_SCORE_BOX_2	EQU	SUPP_4+0601H
;OID_NEW_SCORE_T1	EQU	0602H
;OID_NEW_SCORE_T2	EQU	0603H		;SHUT UP
;OID_NEW_SCORE_T1_S1	EQU	0604H
;OID_NEW_SCORE_T1_S2	EQU	0605H
;OID_NEW_SCORE_T2_S1	EQU	0606H
;OID_NEW_SCORE_T2_S2	EQU	0607H
;OID_NEW_SCORE_TM_1	EQU	0608H		;minutes    /  tenseconds
;OID_NEW_SCORE_TM_2	EQU	0609H		;colon      /  seconds
;OID_NEW_SCORE_TM_3	EQU	060AH		;tenseconds /  decimal
;OID_NEW_SCORE_TM_4	EQU	060BH		;seconds    /  tenths
;OID_NEW_SCORE_PER	EQU	060CH
;OID_NEW_SCORE_MID1	EQU	SUPP_4+060DH		;midway part 1
;OID_NEW_SCORE_MID2	EQU	SUPP_4+060EH		;midway part 1

OID_BIG_SCORE_BAR	EQU	0610H
OID_BIG_SCORE_ANIMATION	EQU	0611H
;OID_BIG_SCORE_NHL	EQU	0612H
OID_BIG_SCORE_FLASHER1	EQU	0612H
OID_BIG_SCORE_JITTER1	EQU	SUPP_4+0611H
OID_BIG_SCORE_JITTER2	EQU	SUPP_4+0612H
;OID_BIG_SCORE_NHLPA	EQU	0613H
OID_BIG_SCORE_FLASHER2	EQU	0613H
OID_BIG_SCORE_T1	EQU	0614H
OID_BIG_SCORE_T2	EQU	0615H		;SHUT UP
OID_BIG_SCORE_T1_S1	EQU	0616H
OID_BIG_SCORE_T1_S2	EQU	0617H
OID_BIG_SCORE_T2_S1	EQU	0618H
OID_BIG_SCORE_T2_S2	EQU	0619H
OID_BIG_SCORE_TM_1	EQU	061AH		;minutes    /  tenseconds
OID_BIG_SCORE_TM_2	EQU	061BH		;colon      /  seconds
OID_BIG_SCORE_TM_3	EQU	061CH		;tenseconds /  decimal
OID_BIG_SCORE_TM_4	EQU	061DH		;seconds    /  tenths
OID_BIG_SCORE_PER	EQU	061EH
OID_BIG_SCORE_LOGO	EQU	061FH

OID_ATTRACT_LOGOS	EQU	0700H		;attract mode logos

OID_PLAYER_TRAILS	EQU	0701H
OID_PLAYER_SPRAY	EQU	0702H

OID_JUNK		EQU	07FFH		;SHIT THAT CLUTTERS THE PLAYFIELD

;**************************************************************************
;*									  *
;* PROCESS I.D. EQUATES							  *
;*      	       15                  0				  *
;* PID FORMAT --	NIII IIII IIII IIII				  *
;* 	N = NON-DESTRUCTIBLE						  *
;* 	O = RESERVED FOR PROCESSES ASSOCIATED WITH OBJECTS OF LIKE I.D.s  *
;* 	I = PROC. SPECIFIC I.D.						  *
;*									  *
;**************************************************************************
M_INDESTRUCT		EQU	08000H		;MASK FOR NON-DESTRUCTIBLE BIT
B_INDESTRUCT		EQU	15

PID_IND			EQU	0000CH		;INDEPENDENT PROCESS
PID_INDW		EQU	0200CH		;WAVE END WILL NOT KILL IND. PROCESS

PID_COLOR		EQU	02CC0H		;COLOR CYCLE PROCESSES
PID_BOXCOLOR		EQU	02CC1H		;COLOR CYCLE PROCESSES (for scored by boxes)
PID_TIMECOLOR		EQU	02CC2H		;timer float cycle process
PID_POWCOLOR		EQU	02CC3H		;GENERAL POWER-UP COLOR CYCLE
PID_PFADE		EQU	02D00H		;FADER PROCESSES ( LOW BYTE = PAL )
PID_SKY			EQU	02E00H		;SKY FADER PROCESS
PID_WHITEFADE		EQU	02E01H		;fade screen from white at period start

PID_LC			EQU	08F00H	;08F00H	;LEFT COIN      
PID_CC			EQU	08F01H	;08F20H	;CENTER COIN    
PID_RC			EQU	08F02H	;08F40H	;RIGHT COIN     
PID_XC			EQU	08F03H	;08F60H	;FOURTH COIN SLOT
PID_SLAM		EQU	08F04H	;08F80H	;SLAM TILT PROCESS
PID_COINCTR		EQU	08F05H	;08FA0H	;COIN COUNTER PROCESS
PID_DIAG		EQU	08F06H	;08100H	;DIAGNOSTICS PROCESS
PID_VOLUME		EQU	08F07H		;Volume adjust process
;PID_VOLUME_DISP	EQU	08F08H		;Volume display page deleter process
PID_VOLRESET		EQU	08F09H		;Delayed volume set process

;PID_ILAMP		EQU	08F0AH		;INDESTRUCTIBLE LAMP PROCESS
;PID_LAMP		EQU	00F0AH		;LAMP PROCESS

PID_PLAYER_1		EQU	00100H		;base for player
PID_PLAYER_2		EQU	00200H		; specific processes
PID_PLAYER_3		EQU	00300H		;
PID_PLAYER_4		EQU	00400H		;
PID_PLAYER_5		EQU	00500H		;
PID_PLAYER_6		EQU	00600H		;
PID_PLAYER_7		EQU	00700H		;
PID_PLAYER_8		EQU	00800H		;

PID_PLAYER_1_MESS	EQU	00105H		;PLAYER MESSAGES
PID_PLAYER_2_MESS	EQU	00205H		;
PID_PLAYER_5_MESS	EQU	00505H		;
PID_PLAYER_6_MESS	EQU	00605H		;

PID_WATCH		EQU	00900H
PID_GAME_TIMER		EQU	00903H		;game timer decrement
PID_PUCK_SOUND		EQU	00904H		;delay to let puck stuff happen before sound
PID_NEW_SCORE		EQU	00905H		;timer is coming/going
PID_BIG_SCORE		EQU	00906H		;big timer is coming/going
PID_SCORE_MOVE		EQU	00907H
PID_CREDIT		EQU	00908H		;DISPLAY CREDIT PROCESS
PID_DISPLAY_CREDIT	EQU	08908H		;GAME DISPLAY CREDIT PROCESS
PID_TIMER		EQU	00909H		;TIMER PROCESS
PID_INITIAL_SEL		EQU	0090AH		;INITIAL SELECT PROCESS
PID_TEAM_SEL		EQU	0090BH		;TEAM SELECT PROCESS
PID_SUB_SEL		EQU	0090CH		;SUBSTITUTION SELECT PROCESS
PID_POWERUP		EQU	0090DH		;POWERUP PROCESS
PID_GCARD		EQU	0090EH		;GOALIE CARD PROCESS
PID_GCARD_FREEZE	EQU	0090FH		;GOALIE CARD FREEZE PROCESS
PID_SIDE_BRIGHT		EQU	00910H		;side brightness dimmer process

PID_GOAL_CYCLE		EQU	00a00H		;process that handles sequence from goal to face off
PID_MOVE_TO		EQU	00a01H		;for moving 1 player to a point (higher control)
PID_SCORE_DISPLAY	EQU	00a02H		;puts up and takes down scores
PID_SEQUENCE		EQU	00a03H		;handles sequence from initial entry to start of period 1
PID_PLW			EQU	00a04H		;debug mode - player coords
PID_PLW2		EQU	00a05H		;position recorder
PID_PGC			EQU	00a06H		;pull goalie timeout switch count process
PID_CANNED_SCORE	EQU	00a07H		;canned puck/net interaction sequence
PID_SCORED_BY		EQU	00a08H		;scored by window up/down process
PID_STEAL_RESOLVE	EQU	00a09H		;to isolate us from surroundings and do steal speech call
PID_CELEBRATIONS	EQU	00a0aH		;move process for main celebration animation
PID_CELEBRATION_P	EQU	00a0bH		;move processes for celebration animations
PID_SCORES_FLASH	EQU	00a0cH		;flash the teams score who score
PID_RESTART_WINNER	EQU	08A0DH		;RESTART GAME FOR WINNERS
;PID_RESTART_WINNER	EQU	00A0DH		;RESTART GAME FOR WINNERS
PID_HOT_CYCLE		EQU	00a0eH
PID_BOARD_ADEL		EQU	00a0fH		;used to delete board animations
PID_GOAL_SLIDE		EQU	00A10H		;GOAL SLIDING BACK

PID_FACEOFF		EQU	00b00H		;process that handles faceoffs
PID_REF			EQU	00b01H		;ref controll process
PID_HELP_WINDOW		EQU	00B02H		;HELP WINDOW THINGY
PID_PUCK_PTR		EQU	00B03H		;POINT TO STOPPED PUCK
PID_PUCK_INSURE		EQU	00b04h		;insure puck is earthbound
PID_TRY_GPOST		EQU	00b05h		;try to do off the goalpost speech

PID_ATTRACT_MODE	EQU	01000H		;attract mode process
PID_ORGAN		EQU	01001H		;background organ process
PID_CROWD_NOISE		EQU	01002H		;background crowd noise process
PID_CROWD_REACT_NOISE	EQU	01002H		;background crowd noise process

PID_OCTOPUS_BUTTON	EQU	01010H		;timing process for octopus buttons
PID_FROZEN_MESSAGE	EQU	09011H		;process dealing with game frozen
PID_FROZEN_TURBOCHECK	EQU	01012H		;process that one at a time, check to see if people turbo
PID_FROZEN_PFADE	EQU	0AD00H		;FROZEN FADER PROCESSES
PID_CONGRATS_SND	EQU	01013H		;sound/music sequencer for all 26 beaten
PID_SHAKE		EQU	01014h		;screen shake process

;offsets from player base for player processes
PIDOF_WATCH_SHOOT	EQU	00001H		;watch for shoot button open
PIDOF_WATCH_PASS	EQU	00002H		;watch for pass button open
PIDOF_PASS_SHOOT	EQU	00003H		;pass and shoot process id
PIDOF_PASS_HOLDW	EQU	00004H		;pass 
PIDOF_MESS		EQU	00005H		;player messages
PIDOF_CELEBRATE		EQU	00006H		;player celebrations/get pissed

;frozen message equates
PFRZ_OFFSCREEN		EQU	1		;you are off the screen too long
PFRZ_SHOOTFAR		EQU	2		;you are shooting from too far away
PFRZ_SHOOTPASS		EQU	3		;you are never shooting or passing
PFRZ_DRONE_SHOOTPASS	EQU	4		;you never tell your drone to shoot or pass
PFRZ_TURBO		EQU	5		;you never use turbo
PFRZ_SMOTHERPASS	EQU	6		;you let the goalie smother
;
PFRAZ_TURBOED		EQU	10		;flag used in freeze bits to indicate we have turboed
M_PFRAZ_TURBOED		EQU	0000010000000000b

;**************************************************************************
;*									  *
;* 		PALETTE ALLOCATOR EQUATES				  *
;*									  *
;**************************************************************************

*PALETTE ALLOCATION RAM
*FOR EACH COLOR PALETTE:
*PALETTE ID 32 BITS, PALETTE COUNT 16 BITS, PALETTE TIME 16 BITS.
*IF PALCNT>0 PALETTE IS ALLOCATED.
*IF (PALCNT=0) & (CURTIME-PALTIME >= 1) THEN PALETTE IS FREE
*
NUMPAL		.SET	128	;NUMBER OF DYNAMICS ALLOCATED PALETTES
NMFPAL		.SET	128	;NUMBER OF FOREGROUND PALETTES

*PALETTE ENTRY DATA STRUCTURE
PALID		.SET	0		;PALETTE I.D.				(32)
PALCNT		.SET	020H		;PALETTE ALLOCATION COUNT		(16)
PALTIME		.SET	030H		;TIME WHEN PAL WAS DELETED
PALRSIZ		.SET	040H		;SIZE OF PALETTE ALLOCATION RAM
;mdp*
;mdp*PALETTE TRANSFER RAM DATA STRUCTURE
;mdpPLDCNT	.SET	0	;COLOR COUNT					(16)
;mdpPALSRC	.SET	010H  	;SOURCE ADDRESS OF PALETTE COLOR DATA 		(32)
;mdpPALDEST	.SET	030H	;DESTINATION PALETTE|START COLOR		(16)
;mdpPTRSIZ	.SET	040H	;SIZE OF EACH CELL
;mdpNUMPTR	.SET	32	;NUMBER OF TRANSFERS ALLOWED
;mdp
;mdp*PALETTE MODE STUFF

M_FADE_WHITE			EQU	1
M_DONT_FADE_RED			EQU	2
M_DONT_FADE_GREEN		EQU	4
M_DONT_FADE_BLUE		EQU	8

B_FADE_WHITE			EQU	0
B_DONT_FADE_RED			EQU	1
B_DONT_FADE_GREEN		EQU	2
B_DONT_FADE_BLUE		EQU	3

*FIXED COLOR CYCLE EQUATES
*
	.if	XUNIT=1
CYCOLORS	.EQU	COLRAM+(300H*2)	;CYCLABLE COLORS LAST LINE OF 1st PALETTE
	.else
CYCOLORS	.EQU	COLRAM+(300H)		;CYCLABLE COLORS LAST LINE OF 1st PALETTE
	.endif
COLROFFST	.EQU	090H  		;OFFSET TO START COLORS
COLRCNT		.EQU	6	     	;TOTAL NUMBER OF COLORS TO CYCLE

;mdp;PCYCLEPAL	.EQU	0H		;PLAYER CYCLERS
;mdp;PCOLROFFST	.EQU	300H+090H	;OFFSET TO 1st PLAYER CYCLER
;mdp;PCOLRCNT	.EQU	2		;NUMBER OF PLAYER CYCLERS

*
*GAME STATE CONSTANTS
INGAME		.EQU	10H
ININTRO		.EQU	18H
ININTRO_INITQ	.EQU	ININTRO+0001B
ININTRO_INITENT	.EQU	ININTRO+0010B
ININTRO_TEAMSEL	.EQU	ININTRO+0011B
ININTRO_TG	.EQU	ININTRO+0100B
INPLAY		.EQU	20H
INAMODE		.EQU	30H
INDIAG		.EQU	40H
INGAMEOV 	.EQU	50H
INEPILOG	.EQU	60H
INSTAT		.EQU	70H
INSUBST		.EQU	80H
INBUYIN		.EQU	90H

*
*DISPLAY FLAGS FOR FORE/BACKGROUND OBJECTS
;mdpM_SPAWNP EQU	80H		;SPAWN A PROCESS WITH THIS OBJECT IN A8
;mdpB_SPAWNP EQU	7
