;**************************************************************************
;*									  *
;* 	                 MASTER EQUATE FILE				  *
;*									  *
;**************************************************************************
radius	.set	120

XD0005	.set	0023ch
XD0010	.set	00478h
XD0015	.set	006b4h
XD0020	.set	008f0h
XD0030	.set	00d67h
XD0040	.set	011dfh
XD0050	.set	01657h
XD0060	.set	01acfh
XD0070	.set	01f47h
XD0080	.set	023bfh
XD0090	.set	02836h
XD0100	.set	02caeh
XD0110	.set	03126h
XD0120	.set	0359eh
XD0130	.set	03a16h
XD0140	.set	03e8dh
XD0150	.set	04305h
XD0200	.set	0595ch
XD0225	.set	06488h
XD0250	.set	06fb3h
XD0300	.set	0860bh
XD0400	.set	0b2b9h		;40 degrees is our crossover point
XD0450	.set	0c910h
XD0500	.set	0df67h
XD0570	.set	0feaeh		;57 degrees is our crossover point
XD0675	.set	12d98h
XD0800	.set	16572h		;80 degrees is our crossover point
XD0900	.set	19220h
XD1125	.set	1f6a8h
XD1350	.set	25b30h
XD1575	.set	2bfb7h
XD1800	.set	3243fh
XD2025	.set	388c7h
XD2250	.set	3ed4fh
XD2475	.set	451d7h
XD2700	.set	4b65fh
XD2925	.set	51ae7h
XD3150	.set	57f6fh
XD3375	.set	5e3f7h
XD3600	.set	6487fh
XD3825	.set	6ad07h
XD4050	.set	7118Fh

*ODATA EQUATES
ODT_DIR		.equ	ODATA		;UHL direction object is moving (s15:16 radians)
ODT_VEL		.equ	ODATA+020H	;UHL velocity magnitude of object (s15:16)
ODT_DVEL	.equ	ODATA+040H	;UHL angular velocity of object (s15:16 radians/tick)
ODT_PBK		.equ	ODATA+060H	;UHL player block address
ODT_GDIR	.equ	ODATA+080H	;UHL goal direction to move to - temporary
ODT_TURBO	.equ	ODATA+0a0H	;UHW non zero for non turbo - temporary

**************************************************************************
*								         *
* PLAYER BLOCK EQUATES							 *
*								         *
**************************************************************************
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
POF_VISITOR		.equ	0090h	;UHW 0 - home, 1 - visitor
POF_MASS		.equ	00a0h	;UHW player mass
********************************
*			       *
* PLAYER ABILITY DATA	       *
*			       *
********************************
POF_S_SPED		.equ	0100h	;UHL table pointer - player speed data
POF_S_STOP		.equ	0120h	;UHL table pointer - player stopping data
POF_S_CORN		.equ	0140h	;UHL table pointer - player cornering data
POF_S_SHOT		.equ	0160h	;UHL table pointer - player shooting data
POF_S_PASS		.equ	0180h	;UHL table pointer - player passing data
POF_S_DUMP		.equ	01a0h	;UHL table pointer - player dumping data
POF_S_HAND		.equ	01c0h	;UHL table pointer - player handling data
POF_S_STAB		.equ	01e0h	;UHL table pointer - player shot table
********************************
*			       *
* PLAYER STATES		       *
*			       *
********************************
POF_FLAGS		.equ	0280h	;UHW - see below
POF_MODE		.equ	0290h	;UHW what player is doing (not valid during higher control)
********************************
*			       *
* PLAYER RELATED OBJECTS       *
*			       *
********************************
POF_OBJECT		.equ	0300h	;UHL players object
POF_SHADOW		.equ	0320h	;UHL players shadow object
POF_GOALIE_OBJECT	.equ	0340h	;UHL object of teams goalie
POF_ARROW		.equ	0360h	;UHL object of players arrow
POF_TURBO_BOX		.equ	0380h	;UHL turbo box object (or press start/insert coin)
POF_TURBO_BAR		.equ	03a0h	;UHL turbo bar object (or to control)
POF_TURBO_NAME		.equ	03c0h	;UHL turbo name object (both modes)
POF_ARROW_CPU		.equ	03e0h	;UHL if player is not human, object for his cpu title
********************************
*			       *
* PLAYER JOYSTICK DATA	       *
*			       *
********************************
POF_BUTTONS		.equ	0400h	;UHW buttons of player
POF_DIRECTION		.equ	0410h	;UHB last facing direction of player
POF_JOY			.equ	0418h	;UHB joystick direction (1-8)
POF_I_JOY		.equ	0420h	;UHB ignore this joystick direction
POF_M_JOY		.equ	0428h	;UHB modified joystick direction (1-8)
POF_CORNER_TEMP		.equ	0430h	;UHB last corner check for diagonal removal
********************************
*			       *
* MISC PLAYER DATA	       *
*			       *
********************************
POF_SHOT_FAKE		.equ	0500h	;UHL time of last shot start (waveirqs)
POF_SHOT_START		.equ	0520h	;UHL started shooting at this time (for fake test and dump puck tests)
POF_SPEED_GL		.equ	0540h	;UHL used to see if we are speeding up or slowing down
POF_PASS_START		.equ	0560h	;UHL started passing at this time (for dump puck tests)
POF_SHOOT_CURRENT	.equ	0580h	;UHL current shoot speed (for calculations and reference)
POF_SPEED_BOOST		.equ	05a0h	;SHL stuffed at control start, is 0 or defense boost, or negative puck against
POF_TURBO_AMOUNT	.equ	05c0h	;SHL turbo amount s15:16
POF_SHOT_RELEASE	.equ	05e0h	;UHL call this on a release of shoot, during a shoot
POF_SHOT_PASS		.equ	0600h	;UHL call this on a pass during a shoot
POF_LAST_BOARD_CVEL	.equ	0620h	;UHL last velocity of board crash
POF_ARROW_TIME		.equ	0640h	;UHW time left to show arrow
;POF_STRAIGHT_TIME	.equ	0650h	;UHW time spent going in a straight line
POF_TURBO_DELAY		.equ	0660h	;SHW delay till we bring turbo up
POF_TURBO_MODE		.equ	0670h	;SHW turbo is on when <> 0
POF_STAND_STILL		.equ	0680h	;UHB player is standing still # ticks
POF_IGNORE_PUCK		.equ	0688h	;UHB ignore puck till this is zero
POF_ARROW_HYST		.equ	0690h	;UHB player arrow hysteresis
POF_TOP_MODE		.equ	0698h	;UHB current state of top
POF_SKID_BOOST		.equ	06a0h	;UHB current skid boost
********************************
*			       *
* PLAYER DISTANCE DATA	       *
*			       *
********************************
POF_D_1P		.equ	0700h	;UHW distance to player 1
POF_D_2P		.equ	0710h	;UHW distance to player 2
POF_D_3P		.equ	0720h	;UHW distance to player 3
POF_D_4P		.equ	0730h	;UHW distance to player 4
POF_D_5P		.equ	0740h	;UHW distance to player 5
POF_D_6P		.equ	0750h	;UHW distance to player 6
POF_D_7P		.equ	0760h	;UHW distance to player 7
POF_D_8P		.equ	0770h	;UHW distance to player 8


;POF_TOP_MODE
;	0 - nothing on top
;	1 - name/turbo bar
;	2 - press start
;	3 - insert coin(s)
;	4 - to control/player
;	5 - please wait

;POF_MODE
;	0  - standing
;	1  - skating
;	2  - passing
;	3  - shooting
;	4  - skidding to stop (for reverse or stop)
;	5  - swatting at puck
;	6  - pushing
;	7  - falling
;	8  - player directed, non destination shot (dump)
;	100 - goalie standing

;POF_BUTTONS		.equ	01a0h	;UHW buttons of player
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

M_PF_HUMAN	.equ	0000000000000001b
M_PF_CONTROL	.equ	0000000000000010b
M_PF_GOALIE	.equ	0000000000000100b
M_PF_OKDIR	.equ	0000000000001000b
M_PF_HIGHER	.equ	0000000000010000b
M_PF_HIGHER_W	.equ	0000000000100000b
M_PF_SIG_SHOOT	.equ	0000000001000000b
M_PF_SIG_PASS	.equ	0000000010000000b

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
PS_DP_DUMP_SPEED		.equ	0000h	;UHL speed used to dump puck
PS_DP_DUMP_TURBO		.equ	0020h	;UHL turbo speed used to dump
PS_DP_DUMP_CHANGE		.equ	0040h	;UHL called to change dump shot angle
PS_DP_TDUMP_CHANGE		.equ	0060h	;UHL called to change turbo dump shot angle

***************
*	      *
* POF_S_HAND  *
*	      *
***************
PS_HN_INT_CONTROL		.equ	0000h	;UHL called to see if we control after an intended pass
PS_HN_OFF_CONTROL		.equ	0020h	;UHL called to see if we control after an offensive stop
PS_HN_DEF_CONTROL		.equ	0040h	;UHL called to see if we control after a defensive stop

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
SUPP_3	.EQU	01800H
SUPP_4	.EQU	02000H
SUPP_5	.EQU	02800H
SUPP_6	.EQU	03000H
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

OID_JUNK		EQU	0300H		;SHIT THAT CLUTTERS THE PLAYFIELD

OID_TEXT		EQU	0480H		;"OBJECT LIST" TEXT
OID_CREDIT		EQU	0488H		;CREDIT MESSAGE TEXT
OID_PROMPT		EQU	0489H		;"READY FOR" MESSAGE
OID_PROMPT2		EQU	048AH		;"PRESS START" MESSAGE
OID_CUSTOM		EQU	048BH		;CUSTOM MESSAGE, COINAGE, MAX CRED, ETC.
OID_REQUIRED		EQU	048CH		;CREDITS REQUIRED MESSAGE

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

OID_PUCK		EQU	0200h
OID_HEAD		EQU	0201h
OID_PUCK_SHADOW		EQU	0202h
OID_GOAL		EQU	0203H		;goal objects
OID_BACKWALL		EQU	0204H		;back wall images
OID_EDGE		EQU	0205H		;edge rink pieces

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

OID_LOGO		EQU	0400H		;attract mode logos
OID_DUMMYPAGE		EQU	0401H		;dummy page filler objects

OID_ARROW		EQU	0500H		;arrow objects
OID_CPU			EQU	0501H		;cpu label objects

MASK_OID_TIMER_SCORE	EQU	07F8H
OID_TIMER_1		EQU	0600H		;timer objects
OID_TIMER_2		EQU	0601H		;timer objects
OID_TIMER_3		EQU	0602H		;timer objects
OID_TIMER_4		EQU	0603H		;timer objects
OID_TIMER_5		EQU	0604H		;timer objects

OID_SCORE_1		EQU	0610H		;score objects
OID_SCORE_2		EQU	0611H		;score objects
OID_SCORE_3		EQU	0612H		;score objects
OID_SCORE_4		EQU	0613H		;score objects
OID_SCORE_5		EQU	0614H		;score objects
OID_SCORE_6		EQU	0615H		;score objects
OID_SCORE_7		EQU	0616H		;score objects
OID_SCORE_8		EQU	0617H		;score objects


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

PID_IND			EQU	0000CH		;INDEPENDENT PROCESS
PID_INDW		EQU	0200CH		;WAVE END WILL NOT KILL IND. PROCESS

PID_COLOR		EQU	02CC0H		;COLOR CYCLE PROCESSES
PID_PFADE		EQU	02D00H		;FADER PROCESSES ( LOW BYTE = PAL )

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

PID_PLAYER_1		EQU	00100H		;base for player
PID_PLAYER_2		EQU	00200H		; specific processes
PID_PLAYER_3		EQU	00300H		;
PID_PLAYER_4		EQU	00400H		;
PID_PLAYER_5		EQU	00500H		;
PID_PLAYER_6		EQU	00600H		;
PID_PLAYER_7		EQU	00700H		;
PID_PLAYER_8		EQU	00800H		;

PID_RINK_WATCH		EQU	00900H		;rink movement process
PID_PUCK_WATCH		EQU	00901H		;puck watching process
PID_PLAYER_WATCH	EQU	00902H		;keep players on the ice
PID_GAME_TIMER		EQU	00903H		;game timer decrement
PID_PUCK_SOUND		EQU	00904H		;delay to let puck stuff happen before sound

PID_GOAL_CYCLE		EQU	00a00H		;process that handles sequence from goal to face off
PID_MOVE_TO		EQU	00a01H		;for moving 1 player to a point (higher control)
PID_SCORE_DISPLAY	EQU	00a02H		;puts up and takes down scores
PID_SEQUENCE		EQU	00a03H		;handles sequence from initial entry to start of period 1

PID_FACEOFF		EQU	00b00H		;process that handles faceoffs
PID_ATTRACT_MODE	EQU	01000H		;attract mode process

;offsets from player base for player processes
PIDOF_WATCH_SHOOT	EQU	00001H		;watch for shoot button open
PIDOF_PASS		EQU	00002H		;pass process id (so pass and shoot can kill)
PIDOF_PASS_SHOOT	EQU	00003H		;pass and shoot process id

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
INPLAY		.EQU	20H
INAMODE		.EQU	30H
INDIAG		.EQU	40H
INGAMEOV 	.EQU	50H
INEPILOG	.EQU	60H
*
*DISPLAY FLAGS FOR FORE/BACKGROUND OBJECTS
;mdpM_SPAWNP EQU	80H		;SPAWN A PROCESS WITH THIS OBJECT IN A8
;mdpB_SPAWNP EQU	7
