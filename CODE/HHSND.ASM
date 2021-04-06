	.MLIB	"HHMACS.LIB"
	.FILE	"HHSND.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

**************************************************************************
*								         *
* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		 *
* 		       ALL RIGHTS RESERVED.				 *
*								         *
**************************************************************************

	.INCLUDE	"HH.INC"		;Game equates
	.include	"hhsnd.e"
	.include	"hhproc.g"
	.include	"hhram.g"
	.include	"hhcmos.g"
	.include	"hhd.g"
	.include	"hhdutl.g"
	.include	"hhmisc.g"
	.include	"hhuart.g"
	.include	"hhutil.g"
	.include	"hhgame.g"
	.include	"hhcontr2.g"

; end of include files

**************************************************************************
*								         *
* INCTR	inc register, wrapping around tracks				 *
*								         *
**************************************************************************
INCTR	.macro	REG
	inc	:REG:
	cmpi	HIGHEST_TRACK,:REG:
	jrls	it1?
	movk	1,:REG:
it1?
	.endm

	.bss	track_0_pri,16
	.bss	track_0_time,16
	.bss	track_0_last,16
	.bss	track_0_volume,16
	.bss	track_1_pri,16
	.bss	track_1_time,16
	.bss	track_1_last,16
	.bss	track_1_volume,16
	.bss	track_2_pri,16
	.bss	track_2_time,16
	.bss	track_2_last,16
	.bss	track_2_volume,16
	.bss	track_3_pri,16
	.bss	track_3_time,16
	.bss	track_3_last,16
	.bss	track_3_volume,16
	.bss	track_4_pri,16
	.bss	track_4_time,16
	.bss	track_4_last,16
	.bss	track_4_volume,16
	.bss	track_5_pri,16
	.bss	track_5_time,16
	.bss	track_5_last,16
	.bss	track_5_volume,16
	.bss	last_track_used,16
	.bss	current_tune,16
	.bss	puck_ice_track,16
	.bss	puck_bounce_track,16
	.bss	ice_skate_track,16
	.bss	organ_track,16
	.bss	crowd_track,16
	.bss	tune_address_1,32
	.bss	tune_address_2,32
	.bss	tune_address_3,32
	.bss	tune_address_4,32
	.bss	tune_address_5,32

	.bss	speech_buffer,16*40
	.bss	speech_buffer_end,0
	.bss	speech_buffer_head,32
	.bss	speech_buffer_tail,32
	.bss	speech_buffer_time,16
	.bss	SOUND_RX,16
	.bss	raw_sound_buffer,16*1000
	.bss	raw_sound_pointer,32


	.TEXT

NUMBER_OF_SOUND_ROMS	EQU	4

HIGHEST_TRACK	.equ	4	;reserve 5 for pat foley

FULL_VOLUME	.EQU	00FFH	;This would be full volume

FACTORY_VOLUME	.EQU	3FH	;This is the factory volume level.  It will
				;be set at powerup, for poweron tests.  As

				;soon as CMOS is validated, the volume will
				;be set according to the value stored.  If
				;CMOS is, for some reason, invalid then this
				;will be the default level.

FACTORY_MINVOL	.EQU	1FH	;This is the lowest volume allowed. It is
				;factory adjustable.
MIN_VOLUME	.EQU	0	;Minimum allowable volume level
MAX_VOLUME	.EQU	255	;Maximum allowable volume level

**************************************************************************
*								         *
* SOUND ENTRY FORMAT							 *
* 									 *
* 	.WORD	SOUND CALL INDEX, TIME, PRIORITY			 *
*								         *
* TIME     = DURATION IN 16msec INTERVALS				 *
* 									 *
* PRIORITY = 0000 000I PPPP PPPP					 *
*            THE P FIELD IS THE ACTUAL PRIORITY.			 *
* 	     THE I BIT ALLOWS INTERRUPTION WITH SOUNDS OF EQUAL		 *
*	     PRIORITY.						         *
*								         *
**************************************************************************

sound_table
	.word	0064h,53,0110h	;s_board_crash_10
	.word	0069h,51,0110h	;s_board_crash_4
	.word	006eh,53,0110h	;s_board_crash_5
	.word	0073h,40,0110h	;s_board_crash_8
	.word	0078h,48,0110h	;s_board_crash_9
	.word	0546h,96,0110h	;s_board_crash_j1	;removed ;unusable
	.word	0546h,19,0110h	;s_skates_upended	;removed 
	.word	0546h,17,0110h	;s_goalie_mitt_1	;removed 
	.word	0546h,26,0110h	;s_goalie_mitt_2	;removed 
	.word	0091h,16,0110h	;s_goalie_mitt_5
	.word	0096H,15,0110h	;s_goalie_mitt_7
	.word	009BH,28,0110h	;s_goalie_pad_1
	.word	00A0H,38,0110h	;s_goalie_pad_2
	.word	0546h,60,0110h	;s_goalie_skate_1	;removed ;possible corner
	.word	0546h,41,0110h	;s_goalie_skate_2	;removed 
	.word	0546h,52,0110h	;s_goalie_skate_3	;removed 
	.word	0546h,58,0110h	;s_goalie_skate_4	;removed 
	.word	0546h,50,0110h	;s_goalie_skate_5	;removed 
	.word	0546h,42,0110h	;s_goalie_skate_6	;removed 
	.word	00c3h,32,0110h	;s_goalie_stick_1
	.word	0546h, 6,0110h	;s_goalie_stick_2	;removed 
	.word	00CDH,16,0110h	;s_goalie_stick_3
	.word	00d2h,34,0110h	;s_goalie_stick_4	;good stick sound
	.word	0546h,40,0110h	;s_hard_skate_stop_1	;removed 
	.word	00dch,33,0110h	;s_hard_skate_stop_2
	.word	00e1h,43,0110h	;s_hard_skate_stop_3
	.word	0546h,43,0110h	;s_hard_skate_stop_4	;removed 
	.word	00ebh,26,0110h	;s_hard_skate_stop_5
	.word	0546h,20,0110h	;s_ice_crunch_1		;removed 
	.word	00f5h,28,0110h	;s_ice_crunch_2
	.word	00fah,38,0110h	;s_loud_board_1
	.word	00ffh,30,0110h	;s_loud_board_2
	.word	0104h,33,0110h	;s_loud_board_3
	.word	0546h,54,0110h	;s_long_skate_1		;removed 
	.word	0546h,67,0110h	;s_long_skate_2		;removed 
	.word	0546h,89,0110h	;s_long_skate_3		;removed 
	.word	0546h,60,0110h	;s_long_skate_4		;removed 
	.word	0546h,64,0110h	;s_long_skate_5		;removed 
	.word	0546h,65,0110h	;s_long_skate_6		;removed 
	.word	0546h,91,0110h	;s_long_skate_7		;removed 
	.word	0546h,56,0110h	;s_puck_to_board_score_1;removed 	;unusable
	.word	0131h,23,0110h	;s_puck_drop_1
	.word	0136h,15,0110h	;s_puck_drop_2
	.word	013bh,10,0110h	;s_puck_drop_3
	.word	0140H,21,0110h	;s_puck_to_goalie_mask_1
	.word	0145h,20,0110h	;s_puck_hit_board_1
	.word	014ah,21,0110h	;s_puck_hit_board_2
	.word	014fh,26,0110h	;s_puck_hit_board_3
	.word	0154h, 8,0110h	;s_puck_drop_in_net
	.word	0546h,15,0110h	;s_puck_in_net_1	;removed 
	.word	0546h,13,0110h	;s_puck_in_net_2	;removed 
	.word	0546h,18,0110h	;s_puck_in_net_3	;removed ;possible net sound
	.word	0546h,23,0110h	;s_puck_in_net_4	;removed ;possible puck on ice sound
	.word	0546h,18,0110h	;s_puck_in_net_5	;removed ;possible puck on ground in corner of net
	.word	0172h,32,0110h	;s_puck_in_net_6	;start of sound is net sound
	.word	0177h,33,0110h	;s_plastic_impact_1
	.word	017ch,26,0110h	;s_plastic_impact_2
	.word	0181h,21,0110h	;s_plastic_board_hit_1
	.word	0186h,55,0110h	;s_plastic_board_hit_2
	.word	018bh,27,0110h	;s_puck_to_metal_0
	.word	0190h,36,0110h	;s_puck_to_metal_1
	.word	0195h,12,0110h	;s_puck_to_metal_2
	.word	0546h,32,0110h	;s_puck_pass_1		;removed 
	.word	0546h,35,0110h	;s_puck_pass_2		;removed 
	.word	0546h,40,0110h	;s_puck_pass_3		;removed 
	.word	0546h,31,0110h	;s_puck_pass_4		;removed 
	.word	0546h,57,0110h	;s_puck_pass_5		;removed 
	.word	0546h,58,0110h	;s_puck_ricochet_1	;removed 
	.word	0546h,46,0110h	;s_puck_ricochet_2	;removed 
	.word	01bdh,56,0110h	;s_puck_ricochet_3
	.word	0546h,58,0110h	;s_puck_slide_2		;removed 
	.word	0546h,51,010eh	;s_puck_slide_3		;removed 
	.word	0546h,36,0110h	;s_puck_slide_4		;removed 
	.word	0546h,50,010eh	;s_puck_slide_6		;removed 
	.word	0546h,28,0110h	;s_skate_1		;removed 
	.word	01dbh,44,0110h	;s_skate_2
	.word	0546h,27,0110h	;s_skate_3		;removed 
	.word	0546h,15,0110h	;s_skate_4		;removed 
	.word	0546h,42,0110h	;s_skate_5		;removed 
	.word	0546h,46,0110h	;s_skate_6		;removed 
	.word	0546h,30,0110h	;s_skate_7		;removed 
	.word	01f9h,20,0110h	;s_skate_8
	.word	01feh,24,0110h	;s_skate_9
	.word	0203h,28,0110h	;s_skate_10
	.word	0208h,26,0110h	;s_skate_11
	.word	0546h,24,0110h	;s_skate_12		;removed 
	.word	0546h,22,0110h	;s_skate_13		;removed 
	.word	0546h,19,0110h	;s_skate_14		;removed 
	.word	0546h,21,0110h	;s_skate_15		;removed 
	.word	0546h,14,0110h	;s_skate_16		;removed 
	.word	0546h,49,0110h	;s_skate_17		;removed 
	.word	022bh,17,0110h	;s_skate_18
	.word	0230h,20,0110h	;s_skate_19
	.word	0235h,19,0110h	;s_skate_20
	.word	023ah,10,0110h	;s_skate_21
	.word	023fh,15,0110h	;s_skate_22
	.word	0546h,27,0110h	;s_skate_23		;removed 
	.word	0249h,23,0110h	;s_skate_24
	.word	024eh,23,0110h	;s_skate_25
	.word	0253h,19,0110h	;s_skate_26
	.word	0546h,61,0110h	;s_skate_27	unusable;removed 	same as 1b7
	.word	0546h,25,0110h	;s_skate_28		;removed 
	.word	0262h,43,0110h	;s_skate_29
	.word	0546h,41,0110h	;s_skate_30		;removed 
	.word	0546h,44,0110h	;s_skate_31		;removed 
	.word	0546h,49,0110h	;s_skate_32		;removed 
	.word	0276h,38,0110h	;s_skate_33
	.word	0546h,23,0110h	;s_skate_34		;removed 
	.word	0280h,43,0110h	;s_skate_35
	.word	0285h,15,0110h	;s_skate_36
	.word	028ah,33,0110h	;s_skate_37
	.word	0546h,38,0110h	;s_skate_up_foreground	;removed 
	.word	0546h,49,0110h	;s_run_on_skates_1	;removed unusable
	.word	0546h,61,0110h	;s_run_on_skates_2	;removed unusable
	.word	029eh,41,0110h	;s_slapshot_1
	.word	0546h,22,0110h	;s_slapshot_2		;removed 
	.word	0546h,44,0110h	;s_slapshot_3		;removed 
	.word	0546h,36,0110h	;s_slapshot_4		;removed 
	.word	02b2h,31,0110h	;s_slapshot_6
	.word	02b7h,35,0110h	;s_slapshot_7
	.word	02bch,34,0110h	;s_stick_sound_1
	.word	0546h,34,0110h	;s_stick_to_pad_1	;removed 
	.word	0546h,61,0110h	;s_stick_bounce_1	;removed 
	.word	0546h,45,0110h	;s_stick_slide_1	;removed 
	.word	02d0h,32,0110h	;s_skate_stop_or_turn_1
	.word	0546h,25,0110h	;s_skate_stop_or_turn_2	;removed 
	.word	0546h,32,0110h	;s_skate_stop_or_turn_3	;removed 
	.word	02dfh,38,0110h	;s_skate_stop_or_turn_4
	.word	0546h,40,0110h	;s_skate_stop_or_turn_5	;removed same as above
	.word	0546h,49,0110h	;s_skate_stop_or_turn_6	;removed 
	.word	0546h,118,0110h	;s_long puck slide 5	;removed 
	.word	0311h,157,0110h	;s_long puck slide 6
	.word	0316h,123,0110h	;s_long puck slide 7

	.word	031bh,56,0110h	;score_net_1
	.word	0320h,56,0110h	;score_net_11 .
	.word	0325h,41,0110h	;score_net_10b
	.word	0546h,47,0110h	;body_crash_1		;removed 
	.word	0546h,38,0110h	;body_crash_2		;removed 
	.word	0546h,44,0110h	;body_crash_3		;removed 
	.word	0546h,48,0110h	;body_crash_5		;removed 
	.word	033eh,45,0110h	;body_fall_1
	.word	0343h,42,0110h	;body_fall_2
	.word	0348h,55,0110h	;body_fall_3
	.word	034dh,37,0110h	;body_fall_4
	.word	0352h,51,0110h	;body_fall_5
	.word	0546h,50,0110h	;body_fall_6		;removed 
	.word	035ch,49,0110h	;body_fall_7
	.word	0361h,67,0110h	;body_fall_8
	.word	0366h,40,0110h	;body_fall_9
	.word	036bh,38,0110h	;body_fall_11
	.word	0370h,49,0110h	;body_fall_12
	.word	0375h,45,0110h	;body_fall_13
	.word	0546h,52,0110h	;body_fall_14		;removed 
	.word	037fh,49,0110h	;body_fall_15 .
	.word	0384h,42,0110h	;body_slam_1
	.word	0389h,38,0110h	;body_slam_2  .
	.word	038eh,43,0110h	;body_slam_3
	.word	0393h,45,0110h	;body_slam_4
	.word	0398h,41,0110h	;body_slam_5
	.word	039dh,38,0110h	;body_slam_6
	.word	03a2h,25,0110h	;body_slam_7
	.word	03a7h,25,0110h	;body_slam_7b
	.word	03ach,38,0110h	;body_slam_8
	.word	03b1h,42,0110h	;body_slam_9  .
	.word	03b6h,44,0110h	;body_slam_10
	.word	0546h,31,0110h	;body_slam_11		;removed 
	.word	03c0h,60,0110h	;body_slam_vince7
	.word	03c5h,57,0110h	;body_slam_vince8
	.word	0546h,94,0110h	;Organ_dah-DAH-dah_F	;removed 
	.word	0546h,86,0110h	;Organ_dah-DAH-dah_FS	;removed 
	.word	0546h,92,0110h	;Organ_dah-DAH-dah_G	;removed 
	.word	0546h,162,0110h	;Organ_charge_C		;removed 
	.word	0546h,109,0110h	;Organ_line_G_		;removed 
	.word	0546h,108,0110h	;Organ_line_Ab		;removed 
	.word	0546h,105,0110h	;Organ_line_A_		;removed 
	.word	0546h,162,0110h	;Organ_charge_A		;removed 
	.word	0546h,163,0110h	;Organ_charge_Bb	;removed 
	.word	0546h,163,0110h	;Organ_charge_B		;removed 
	.word	0546h,20,0110h	;player_grunt_bill_10	;removed 
	.word	0546h,29,0110h	;player_grunt_bill_16	;removed 
	.word	0546h,14,0110h	;player_grunt_bill_18	;removed 
	.word	0546h,23,0110h	;player_grunt_bill_19	;removed 
	.word	0546h,18,0110h	;player_grunt_bill_21	;removed 
	.word	0546h,13,0110h	;player_grunt_bill_23	;removed 
	.word	0546h,21,0110h	;player_grunt_bill_24	;removed 
	.word	0546h,17,0110h	;player_grunt_bill_26	;removed 
	.word	0442h,21,0110h	;player_grunt_carlos_05
	.word	0447h,23,0110h	;player_grunt_carlos_10
	.word	044ch,23,0110h	;player_grunt_carlos_11
	.word	0451h,23,0110h	;player_grunt_carlos_12
	.word	0456h,19,0110h	;player_grunt_carlos_16
	.word	045bh,17,0110h	;player_grunt_carlos_21
	.word	0460h,33,0110h	;player_grunt_carlos_23
	.word	0465h,15,0110h	;player_grunt_carlos_25
	.word	046ah,14,0110h	;player_grunt_carlos_26
	.word	046fh,33,0110h	;player_grunt_carlos_29
	.word	0474h,24,0110h	;player_grunt_carlos_31
	.word	0479h,13,0110h	;player_grunt_carlos_32
	.word	047eh,18,0110h	;player_grunt_jackh_01
	.word	0483h,19,0110h	;player_grunt_jackh_03
	.word	0488h,33,0110h	;player_grunt_jackh_06
	.word	048dh,57,0110h	;player_grunt_jackh_08
	.word	0492h,31,0110h	;player_grunt_jackh_13
	.word	0497h,28,0110h	;player_grunt_jackh_17
	.word	049ch,23,0110h	;player_grunt_jackh_34
	.word	04a1h,8,0110h	;player_grunt_jackh_45
	.word	04a6h,26,0110h	;player_grunt_jackh_47
	.word	04abh,10,0110h	;player_grunt_markp_01
	.word	04b0h,9,0110h	;player_grunt_markp_02
	.word	04b5h,10,0110h	;player_grunt_markp_07
	.word	04bah,33,0110h	;player_grunt_marty_05
	.word	04bfh,40,0110h	;player_grunt_marty_07
	.word	04c4h,29,0110h	;player_grunt_marty_10
	.word	04c9h,31,0110h	;player_grunt_marty_11
	.word	04ceh,38,0110h	;player_grunt_marty_14
	.word	04d3h,31,0110h	;player_grunt_marty_15
	.word	04d8h,27,0110h	;player_grunt_marty_20
	.word	04ddh,29,0110h	;player_grunt_marty_33
	.word	04e2h,31,0110h	;player_grunt_marty_34
	.word	04e7h,45,0110h	;player_grunt_marty_40
	.word	04ech,30,0110h	;player_grunt_marty_45
	.word	04f1h,11,0110h	;player_grunt_marty_49
	.word	04f6h,22,0110h	;player_grunt_marty_51
	.word	04fbh,21,0110h	;player_grunt_marty_53
	.word	0500h,11,0110h	;player_grunt_marty_62
	.word	0505h,202,0128h	;crowd_noise_1 noise
	.word	050ah,224,0138h	;crowd_noise_2 low noise
	.word	050fh,135,0128h	;crowd_noise_3 applause with cheers
	.word	0514h,127,0128h	;crowd_noise_4 cheers
	.word	0519h,107,0128h	;crowd_noise_5 cheers
	.word	051eh,227,0128h	;crowd_noise_6 cheers with yelling
	.word	0523h,161,0138h	;crowd_noise_7 boos
	.word	0528h,69,0128h	;crowd_noise_8 ohhh (just missed)
	.word	052dh,101,0128h	;crowd_noise_9 awww
	.word	0532h,306,0128h	;crowd_noise_10	low noise
	.word	0537h,237,0128h	;crowd_noise_11 bunch of fuckin' girls
	.word	053ch,254,0128h	;crowd_noise_12	noise
	.word	0541h,178,0128h	;crowd_noise_13	noise
	.word	0546h,59,0080h	;air_horn_blast
	.word	03e8H,94,0120H	;Organ dah-DAH-dah in F
	.word	03edH,87,0120H	;Organ dah-DAH-dah in F#
	.word	03f2H,92,0120H	;Organ dah-DAH-dah in G
	.word	03f7H,162,0120H	;Organ charge in C
	.word	03fcH,109,0120H	;Organ line in G
	.word	0401H,109,0120H	;Organ line in Ab
	.word	0406H,106,0120H	;Organ line in A
	.word	040bH,163,0120H	;Organ charge in A
	.word	0410H,164,0120H	;Organ charge in Bb
	.word	0415H,164,0120H	;Organ charge in B

	.word	0505h,202,0138h	;crowd_noise_1 noise
	.word	050ah,224,0138h	;crowd_noise_2 low noise
	.word	050fh,135,0138h	;crowd_noise_3 applause with cheers
	.word	0514h,127,0138h	;crowd_noise_4 cheers
	.word	0519h,107,0138h	;crowd_noise_5 cheers
	.word	051eh,227,0138h	;crowd_noise_6 cheers with yelling
	.word	0523h,161,0138h	;crowd_noise_7 boos
	.word	0528h,69,0138h	;crowd_noise_8 ohhh (just missed)
	.word	052dh,101,0138h	;crowd_noise_9 awww
	.word	0532h,306,0138h	;crowd_noise_10	low noise
	.word	0537h,237,0138h	;crowd_noise_11 bunch of fuckin' girls
	.word	053ch,254,0138h	;crowd_noise_12	noise
	.word	0541h,178,0138h	;crowd_noise_13	noise
	WL	-1,tune_down_knees
	.WORD	0139CH,26,0180H	;CURSOR MOVE
	.WORD	013BCH,12,0181H ;CURSOR SELECT
	.WORD	013C0H,13,0181H ;CURSOR SWAP
	.WORD	013A4H, 5,0181H ;SIDE TOGGLE
	.WORD	013E4H,10,0190H ;TIMER TICK
	.WORD	000D2H,35,01F0H	;CREDIT
	.WORD	0032AH,47,01E0H ;PERIOD PAID
	.WORD	013B4H,44,01A1H ;FULL GAME
	.WORD	013D0H,21,0198H ;TOP TEN PLAYER
	.word	013f0h,30,0040h ;referee's whistle
	.word	013ech, 8,0140h ;time running out
	.word	013F4H,212,0128H ;CROWD 1,  HM Y
	.word	013F8H,243,0128H ;CROWD 2,  M  N ;REMOVED
	.word	013FCH,180,0128H ;CROWD 3,  ML Y
	.word	01400H,314,0128H ;CROWD 4,  HM Y
	.word	01404H,194,0138H ;CROWD 5,  H  Y
	.word	01408H,294,0128H ;CROWD 6,  HL N ;REMOVED
	.word	0140CH,269,0128H ;CROWD 7,  M  Y
	.word	01410H,170,0128H ;CROWD 8,  HL N ;REMOVED
	.word	01414H,264,0138H ;CROWD 9,  H  Y
	.word	01418H,157,0128H ;CROWD 10, ML Y
	.word	01438H,118,01F1H ;EXPLOSION 4
	.word	013D8H, 31,01F1H ;SLIDE SWISH 1
	.word	01380h,187,0081h ;  Scoring horn (#8)
	.WORD	013E8H, 11,01F0H ;PUCK POINT
	.WORD	01324H, 28,0100H ;STAT HILITE
	.WORD	01328H,  4,01D0H ;P1 POWERUP
	.WORD	0132CH,  4,01D0H ;P2 POWERUP
	.WORD	01330H,  4,01D0H ;P3 POWERUP
	.WORD	01334H,  4,01D0H ;P4 POWERUP
	.WORD	01338H, 66,01D0H ;POWERUP REPORT
	.WORD	0133CH, 25,0100H ;FLASHBULB
	.WORD	0142CH, 34,01F1H ;HELMETS STARTUP
	.WORD	01384H,136,01E0H ;NET IGNITE
	.word	0137ch, 90,  28h ;Glass Board Crash-Break
	.word	013d8h,	30,0111h ;whoosh sound 1
	.word	013dch,	41,0111h ;whoosh sound 2
	.word	013e0h,	41,0111h ;whoosh sound 3
	.word	01448h,113,0112h ;Big whoosh 2
	.word	01340H, 35,01E0H ;SPECIAL CHARACTER SELECTED
	.word	01378h,13,0110h	 ;Steal or Swipe 1 (miss)
	.word	0133ch,36,0110h	 ;steal made
	.word	0143CH,118,01E0H ;LOUD NET EXPLOSION 4

;tune_test_1
;	.word	10h		;priority
;	.word	03fdh,-69	;Organ dah-DAH-dah in F
;	.word	03fdh,-69	;Organ dah-DAH-dah in F
;	.word	03feh,-65	;Organ dah-DAH-dah in F#
;	.word	03feh,-65	;Organ dah-DAH-dah in F#
;	.word	03ffh,-61	;Organ dah-DAH-dah in G
;	.word	03ffh,-61	;Organ dah-DAH-dah in G
;	.word	03f7h,-162	;Organ charge 1 in C
;
;	.word	03e8h,-60	;Organ line 1 in G
;	.word	03e8h,-60	;Organ line 1 in G
;	.word	03eah,-60	;Organ line 1 in Ab
;	.word	03eah,-60	;Organ line 1 in Ab
;	.word	03ech,-60	;Organ line 1 in A
;	.word	03ech,-60	;Organ line 1 in A
;	.word	03edh,-120	;Organ charge 1 in A
;	.word	03efh,-120	;Organ charge 1 in Bb
;	.word	03f1h,-163	;Organ charge 1 in B
;	.word	0

tune_down_knees
	.word	10h
	.word	00b9h,-15
	.word	03a2h,25
	.word	0

kill_all_but_speech_tune
	mmtm	sp,a0,a4,a10,a11
	movk	4,a11
	clr	a0
	move	a0,@puck_ice_track,W
	move	a0,@puck_bounce_track,W
	move	a0,@ice_skate_track,W
	move	a0,@organ_track,W
	move	a0,@crowd_track,W
	movi	03deh+1,a10
	jruc	kas_1
kill_all_sound_but_speech
	mmtm	sp,a0,a4,a10,a11
	movk	5,a11
	jruc	kas_121
kill_all_sound
	mmtm	sp,a0,a4,a10,a11
	callr	empty_speech_buffer
	movk	6,a11
kas_121	clr	a0
	move	a0,@current_tune,W
	move	a0,@puck_ice_track,W
	move	a0,@puck_bounce_track,W
	move	a0,@ice_skate_track,W
	move	a0,@organ_track,W
	move	a0,@crowd_track,W
	movi	03deh,a10
kas_1	move	a10,a4
	callr	SEND_RAW_SOUND
	inc	a10
	dsjs	a11,kas_1
	mmfm	sp,a0,a4,a10,a11
	rets

set_intermission_tune
	movk	16,a0
	jruc	set_tune_a0_safe

END_INTERMISSION_TUNE
	movk	19,a0
	jruc	set_tune_a0_safe

set_game_over_tune
	movk	21,a0
	jruc	set_tune_a0_safe

set_select_tune
	MOVK	4,A0				;ESPN SHIT
	jruc	set_tune_a0_safe

set_background_tune
	mmtm	sp,a0,a4
	move	@hot_player,a14
	jrnz	sgtnr
	move	@period,a14,W
	cmpi	4,a14
	jrnz	sgtn
	movk	ADJPAYOT,a0
	calla	GET_ADJ				;CHECK FOR FULL OVERTIME
	jrnz	sgtn
	movk	22,a0
	jruc	sgta
sgtn	movk	1,a0
	jruc	sgta
sgtnr	movk	23,a0
sgta	callr	set_tune_a0_safe
	mmfm	sp,a0,a4
	rets

;	mmtm	sp,a0,a4
;	move	@period,a0,W
;	sll	4,a0
;	addi	sbt_l,a0
;	move	*a0,a0,W
;	callr	set_tune_a0
;	mmfm	sp,a0,a4
;	rets

sbt_l	.word	1	;0
	.word	1	;1st period
	.word	1	;2nd period
	.word	1	;3rd period
	.word	1	;overtime

set_tune_a0_safe
	move	@SOUNDSUP,a14,W
	jrnz	st9
	move	@current_tune,a14,W
	cmp	a0,a14
	jrz	st9
	mmtm	sp,a0
	movi	03d4h,a0
	calla	SEND_RAW_SOUND
	mmfm	sp,a0
	jruc	sty1
set_tune_a0
	move	@SOUNDSUP,a14,W
	jrnz	st9
	move	@current_tune,a14,W
	cmp	a0,a14
	jrz	st9
sty1	move	a0,@current_tune,W
	move	a0,a4
	jruc	SEND_RAW_SOUND
st9	rets

;00 kill sound on all tracks
;01 music : Buyin or Game over or ?
;02 music : Buyin or Game over or ? for fadeout
;03 music : background tune for now
;04 music : espn style tune loops
;05 music : espn style tune ends
;06 music : espn style tune ends fast
;07 music : espn style tune ends fastest
;08 music : attract mode drums (loops)
;09 music : attract mode drum ending
;10 music : a new tune (loops)
;11 music : new tune ending
;12 music : new tune short ending
;13 music : initials/select (variation on espn tune)
;14 music : initials/select loops w/ rhythm only
;15 music : initials/select rhythm only
;16 music : buyin horns w start
;17 music : buyin horns w start ENDS
;18 music : buyin ending only ENDS
;19 music : buyin drum ending only ENDS
;20 music : ESPN style tune ending
;21 music : WIN THE GAME / GAME OVER

**************************************************************************
*								         *
* do_sound_at_volume							 *
* 	input	a4 = sound offset #					 *
* 		a1 = volume to send at					 *
*								         *
**************************************************************************
do_sound_at_volume
	mmtm	sp,a10
	move	a1,a10
	cmpi	255,a10
	jrls	dsav1
	movi	255,a10
dsav1	callr	ds_1
	mmfm	sp,a10
	rets

**************************************************************************
*								         *
* do_sound								 *
* 	input	a4 = sound offset #					 *
* 	output	c  = sound was made					 *
* 		  a4 = track made on					 *
* 		nc = sound not made					 *
*								         *
**************************************************************************
ds_1	mmtm	sp,a0,a1,a2,a3,a5,a6,a7,a8,a9,a10
	jruc	ds_2
do_sound
	mmtm	sp,a0,a1,a2,a3,a5,a6,a7,a8,a9,a10
	movi	255,a10		;full volume
ds_2	MOVE	@SOUNDSUP,A14,W
	JRNZ	DS_ABORT				;BR=NO SOUNDS ALLOWED
	sll	4,a4
	move	a4,a5
	sll	1,a5
	add	a4,a5
	addi	sound_table,a5
	move	*a5+,a4,W	;sound
	jrn	ds_tn		;negative means tune
	move	*a5+,a9,W	;time
	move	*a5+,a8,W	;priority
	callr	do_sound_at_priority
	mmfm	sp,a0,a1,a2,a3,a5,a6,a7,a8,a9,a10
	rets
ds_tn	move	*a5+,a4,L	;get tune address
	move	*a4+,a8,W
	callr	do_sound_at_priority
	mmfm	sp,a0,a1,a2,a3,a5,a6,a7,a8,a9,a10
	rets
DS_ABORT
	clrc
	mmfm	sp,a0,a1,a2,a3,a5,a6,a7,a8,a9,a10
	rets


**************************************************************************
*								         *
* do_sound_at_priority							 *
* 	input	a4 = raw sound code (or tune address)			 *
* 		a8 = priority + bits					 *
* 		a9 = sound time						 *
* 		a10= volume						 *
* 	output	c  = sound was made					 *
* 		  a4 = track made on					 *
* 		nc = sound not made					 *
*								         *
**************************************************************************
do_sound_at_priority
	move	a8,a3
	sll	24,a3			;remove bits from priority, saving original
	srl	24,a3
	move	@last_track_used,a0,W
	movk	HIGHEST_TRACK,a2
dsap1	INCTR	a0			;next track
	callr	get_track_time		;first check for an empty track
	move	a1,a1
	jrz	ds_go
	dsjs	a2,dsap1
	movk	HIGHEST_TRACK,a2
dsap2	INCTR	a0
	callr	get_track_priority
	cmp	a3,a1
	jrlo	ds_go
	dsjs	a2,dsap2
	clrc
	rets
ds_go	btst	8,a8		;check equal
	jrz	dsg1
	dec	a3
dsg1		;a0 = track
		;a3 = priority
		;a4 = sound code to send (or tune address)
		;a9 = time
		;a10 = volume
	move	a4,a4
	jrnn	ds_reg		;regular sound call
ds_tune	move	a3,a1
	callr	set_track_priority
	move	a10,a1
	callr	set_track_volume
	callr	start_run_tune	;a4 = address, a0 = channel
	jruc	dsee
ds_reg	move	a3,a1
	callr	set_track_priority
	move	a9,a1
	callr	set_track_time
	move	a10,a1
	callr	set_track_volume
	add	a0,a4		;add offset to raw code
	dec	a4		;our base is track 1, not 0
	callr	SEND_RAW_SOUND
dsee	move	a4,a1
	callr	set_track_last
	move	a0,@last_track_used,W
	clr	a1
	move	@puck_ice_track,a4,W		;zero any special tracks
	cmp	a0,a4				;we may have stomped on
	jrnz	co1
	move	a1,@puck_ice_track,W
co1	move	@puck_bounce_track,a4,W
	cmp	a0,a4
	jrnz	co2
	move	a1,@puck_bounce_track,W
co2	move	@ice_skate_track,a4,W
	cmp	a0,a4
	jrnz	co3
	move	a1,@ice_skate_track,W
co3	move	@organ_track,a4,W
	cmp	a0,a4
	jrnz	co4
	move	a1,@organ_track,W
co4	move	@crowd_track,a4,W
	cmp	a0,a4
	jrnz	co5
	move	a1,@crowd_track,W
co5	move	a0,a4				;return our track in a4
	setc
	rets

start_run_tune	;a4 = tune address, a0 = track#
	move	a4,a5
	move	a0,a7
	move	a0,a1
	sll	6,a1
	addi	track_0_time,a1
	sll	5,a7
	addi	tune_address_1-32,a7
run_tune	;a5 = tune address, a0 = track#
rt_1	move	*a5+,a4,W
	jrz	rt_9
	jrn	rt_t		;negative is time
	add	a0,a4
	dec	a4
	callr	SEND_RAW_SOUND
	jruc	rt_1
rt_t	neg	a4
	move	a4,*a1,W	;set time
	move	a5,*a7,L
	rets
rt_9	clr	a4
	move	a4,*a1,W	;set time
	move	a4,*a7,L
	rets

**************************************************************************
*								         *
* get_track_priority							 *
* 	input	a0 = track						 *
* 	output	a1 = priority						 *
*								         *
**************************************************************************
get_track_priority
	move	a0,a1
	sll	6,a1
	addi	track_0_pri,a1
	move	*a1,a1,W
	rets

**************************************************************************
*								         *
* set_track_priority							 *
* 	input	a0 = track						 *
* 		a1 = priority						 *
*								         *
**************************************************************************
set_track_priority
	move	a0,a14
	sll	6,a14
	addi	track_0_pri,a14
	move	a1,*a14,W
	rets

**************************************************************************
*								         *
* get_track_time							 *
* 	input	a0 = track						 *
* 	output	a1 = time						 *
*								         *
**************************************************************************
get_track_time
	move	a0,a1
	sll	6,a1
	addi	track_0_time,a1
	move	*a1,a1,W
	rets

**************************************************************************
*								         *
* set_track_time							 *
* 	input	a0 = track						 *
* 		a1 = time						 *
*								         *
**************************************************************************
set_track_time
	move	a0,a14
	sll	6,a14
	addi	track_0_time,a14
	move	a1,*a14,W
	rets

**************************************************************************
*								         *
* set_track_last							 *
* 	input	a0 = track						 *
* 		a1 = code to store					 *
*								         *
**************************************************************************
set_track_last
	move	a0,a14
	sll	6,a14
	addi	track_0_last,a14
	move	a1,*a14,W
	rets

**************************************************************************
*								         *
* cancel_track_sound							 *
* 	input	a0 = track						 *
*								         *
**************************************************************************
cancel_track_sound
	mmtm	sp,a1
	clr	a1
	callr	set_track_volume
	callr	set_track_time
	mmfm	sp,a1
	rets

**************************************************************************
*								         *
* get_track_volume							 *
* 	input	a0 = track						 *
* 	output	a1 = volume						 *
*								         *
**************************************************************************
get_track_volume
	move	a0,a1
	sll	6,a1
	addi	track_0_volume,a1
	move	*a1,a1,W
	rets

**************************************************************************
*								         *
* set_track_volume							 *
* 	input	a0 = track						 *
* 		a1 = volume						 *
*								         *
**************************************************************************
set_track_volume
	mmtm	sp,a2,a4
	move	a1,a2
	callr	get_track_volume
	cmp	a1,a2
	jrz	stv_9
	move	a0,a14
	sll	6,a14
	addi	track_0_volume,a14
	move	a2,a1
	move	a1,*a14,W
	callr	send_track_volume
stv_9	mmfm	sp,a2,a4
	rets

**************************************************************************
*								         *
* send_track_volume							 *
* 	input	a0 = track						 *
* 	input	a1 = volume						 *
*								         *
**************************************************************************
send_track_volume
	move	a0,a4
	addi	055abh,a4		;add 1 so our zero offset is track 1 (0 is tune)
	callr	SEND_RAW_SOUND
	move	a1,a4
	not	a4
	sll	8,a4
	add	a1,a4
	not	a4
	sll	16,a4
	srl	16,a4
	jruc	SEND_RAW_SOUND

sound_exec
	movi	track_4_time,a1
	movi	HIGHEST_TRACK,a0
se_1	move	*a1,a14,W
	jrz	se_2
	dec	a14
	jrz	se_3
se_4	move	a14,*a1,W
se_2	subi	track_2_time-track_1_time,a1
	dsjs	a0,se_1
	rets
se_3	move	a0,a7
	sll	5,a7
	addi	tune_address_1-32,a7
	move	*a7,a5,L
	jrz	se_4
	callr	run_tune
	jruc	se_2

empty_speech_buffer
	PUSHST
	dint
	move	@speech_buffer_head,@speech_buffer_tail,L
	POPST
	rets

speech_irq
	move	@speech_buffer_time,a14,W
	jrz	se_01	;was empty
	dec	a14
	move	a14,@speech_buffer_time,W	;stuff it here in case we end on a call (no time)
	jrz	se_dsp
	move	a14,@speech_buffer_time,W
se_01	rets

se_dsp	callr	pull_speech_from_buffer
	jrnc	se_01
	move	a4,a4
	jrz	se_sbr
	jrn	se_dst
	callr	SEND_RAW_SOUND
	jruc	se_dsp
se_dst	neg	a4
	move	a4,@speech_buffer_time,W
	jruc	se_01
se_sbr	callr	pull_speech_from_buffer
	move	a4,a3
	callr	pull_speech_from_buffer
	sll	16,a4
	movx	a3,a4
	jump	a4


**************************************************************************
*								         *
* 	SEND_RAW_SOUND							 *
* 									 *
* 	Send a sound code to the sound board at the most basic level.	 *
* 									 *
* 	A4 = 16 bit sound code to send.					 *
* 									 *
* 	Note: Trashes A14						 *
*								         *
**************************************************************************
	.align

SEND_RAW_SOUND
	.if	XUNIT=1

	mmtm	sp,a0,a5
	rl	24,a4
	movi	UART,a0
	movi	20000,a5		;load time-out value
stxw	move	*a0(UART_IMR),a14,W	;read isr register from uart
	btst	0,a14			;is it ready to transmit?
	jrnz	stxf
	dsjs	a5,stxw			;click down another for timeout
stxf	move	a4,*a0(UART_THR),W	;send the high byte first
	movi	20000,a5		;load time-out value
stxw2	move	*a0(UART_IMR),a14,W	;read isr register from uart
	btst	0,a14			;is it ready to transmit?
	jrnz	stxs
	dsjs	a5,stxw2		;click down another for timeout
stxs	rl	8,a4
	move	a4,*a0(UART_THR),W	;then send the low byte
	mmfm	sp,a0,a5

	.else

	mmtm	sp,a0,a1,a2,a3,a4

	move	@raw_sound_pointer,a0,L
	cmpi	raw_sound_buffer,a0
	jrlo	sxrb
	cmpi	raw_sound_pointer,a0
	jrlo	sxrc
sxrb	movi	raw_sound_buffer,a0
sxrc	move	a4,*a0+,W
	move	a0,@raw_sound_pointer,L

	move	a4,a0
	sll	32-16,a4
	srl	32-8,a4			; a3 = high byte
 	callr	poll_sirq
	JRNN	sendx			;BR = SOUND BOARD BUSY TIME OUT
	move	a4,@SOUND,W		; hit sound (low)

	;DELAY WHEN TO READ IRQ? 20ns.

	sll	32-8,a0
	srl	32-8,a0			; a3 = low byte
	callr	poll_sirq
	move	a0,@SOUND,W		; hit sound (low)

sendx	mmfm	sp,a0,a1,a2,a3,a4

	.endif

	rets

	.if	XUNIT=0
*****************************************************************************
* Poll sound IRQ.  When IRQ goes high, sound board is ready for next call.
* Do timeout so sound board can't screw things up.
*

poll_sirq
; 	MOVI	108000000/(MACHINE_CYCLE*10),A3 ;108 MILLISECONDS TIL TIME OUT
	movk	10,a3
poll3	movb	@SOUNDIRQ+B_SIRQ-7,a1
	jrn	poll9			; done?
	dsj	a3,poll3
	SRA	1,A3			;TIME OUT -> CLEAR N FLAG
poll9	rets
	.endif

**************************************************************************
*								         *
* 	LINT2_SERVICE							 *
* 									 *
* 	Interrupt service for all of the user of LINT2.			 *
* 									 *
* 	As of 10/28/93 the only thing serviced is the sound UART.	 *
*								         *
**************************************************************************
LINT2_SERVICE
	.if	XUNIT=1
	MMTM	SP,A0,A1
	MOVE	@UART+UART_IMR,A0,W
	BTST	2,A0
	JRZ	L2_X			;BR = Not a receive interrupt
	MOVE	@UART+UART_THR,@SOUND_RX,W
L2_X	MMFM	SP,A0,A1
	.else

**************************************************************************
*								         *
* 	NOTE! THIS SHOULD AUDIT IN PRODUCTION CODE.			 *
*								         *
**************************************************************************

	.if	DEBUG

	MOVE	@SYSCTRL,A0,W
	XORI	CLR_WRROMINT,A0		;CLEAR WRITE TO ROM INTERRUPT
	MOVE	A0,@SYSCTRL,W
	ORI	CLR_WRROMINT,A0		;CLEAR WRITE TO ROM INTERRUPT
	MOVE	A0,@SYSCTRL,W

	JRUC	$

	.else

	PUSH	A0
	MOVE	@SYSCTRL,A0,W
	XORI	CLR_WRROMINT,A0		;CLEAR WRITE TO ROM INTERRUPT
	MOVE	A0,@SYSCTRL,W
	ORI	CLR_WRROMINT,A0		;CLEAR WRITE TO ROM INTERRUPT
	MOVE	A0,@SYSCTRL,W
	PULLQ	A0

	PUSH	B14
	MOVE	*SP(040H),B14,L	;Grab the return address for dump

	PUSH	A0
	AUDIT	AUD_WARNING
	PULLQ	A0

	PUSH	A14
	MOVK	3,A14
	CALLA	DUMP_IT
	PULLQ	A14

	PULLQ	B14

	.endif

	.endif

	RETI

**************************************************************************
*								         *
* 	SNDRES								 *
* 									 *
* 	Full sound board reset.  Checksum dings are reported.		 *
* 									 *
* 	Must be called with process system initialized or 		 *
* 	the board volume will not be set correctly and this		 *
* 	could be dangerous.						 *
* 									 *
* NOTE: TRASHES A14							 *
*								         *
**************************************************************************
SNDRES:
	.if	XUNIT=1
	MMTM	SP,A0,A1,A7,A8,A13

	GETST	A0
	DINT
	ORIM	SND_RESET<<8,@SYSCOPY,W	;Tug on sound board reset line
	SRL	8,A14
	MOVE	A14,@SYSCTRL1,W		;And really assert it here
	PUTST	A0
	MSECWT	10			;Wait for sound board to catch it
	GETST	A0
	DINT
	ANDNIM	SND_RESET<<8,@SYSCOPY,W	;Release the reset line
	SRL	8,A14
	MOVE	A14,@SYSCTRL1,W		;And really release it here
	PUTST	A0

;	MOVI	120,A8			;Delay this much before resetting
;	CREATE	PID_VOLRESET,PROC_RESET_VOLUME
;	CLRM	@VOLUME_SET,W		;Mark the volume as not being set

	CALLA	INITIALIZE_UART		;Initialize the UART
	MMFM	SP,A0,A1,A7,A8,A13

	.else

	push	a0		;Need an extra reggie
	movi	SNDRSTBIT|IORSTBIT,a0
	move	a0,@COIN_COUNTERS

	MSECWT	110		;Wait for sound board to catch it

	movi	IORSTBIT,a0
	move	a0,@COIN_COUNTERS
	pullq	a0		; Restore the reggies

	MOVI	NUMBER_OF_SOUND_ROMS*60,A8	;SOUND BOARD OK DELAY
	CREATE	PID_VOLRESET,PROC_RESET_VOLUME
	CLRM	@VOLUME_SET,W		;Mark the volume as not being set

	.endif
	rets

**************************************************************************
*                                                                        *
* QSNDRST - QUIET SOUND RESET, NO DIAGNOSTIC DONGERS			 *
*                                                                        *
**************************************************************************
QSNDRST
	MMTM	SP,A0,A3,A4,A5
	CALLR	SNDRES		;RESET THE BOARD
	MSECWT	50000		;The dong takes so long

	CLR	A4
	CALLR	SEND_RAW_SOUND

	MOVI	PID_VOLRESET,A0
	CALLA	KILLPROC_ALL
	MSECWT	50000			;WAIT FOR READY
	CALLR	SET_VOLUME

	MMFM	SP,A0,A3,A4,A5
	RETS

**************************************************************************
*								         *
* 	DEBUG_SNDRST							 *
* 									 *
* 	Routine to be used by Toddview only.  Just sends an		 *
* 	off code to the sound board.  It's best not to call		 *
* 	any normal game routines from here.  If you do, beware		 *
* 	when setting a breakpoint in those routines.			 *
*								         *
**************************************************************************
DEBUG_SNDRST
	.if	XUNIT=1
	MMTM	SP,A0,A4,A5
	CLR	A4
	MOVI	20000,A5		;Load time-out value
	MOVI	UART,A0
DS_Tx_WAIT
	MOVE	*A0(UART_IMR),A14,W	;Read ISR register from UART
	BTST	0,A14			;Is it ready to transmit?
	JRNZ	DS_Tx_BYTE1		;BR = Yes
	DSJS	A5,DS_Tx_WAIT		;Click down another for timeout
DS_Tx_BYTE1
	MOVE	A4,*A0(UART_THR),W	;Send the High byte first
	MOVI	20000,A5		;Reload time-out value
DS_Tx_WAIT2
	MOVE	*A0(UART_IMR),A14,W	;Read ISR register from UART
	BTST	0,A14			;Is it ready to transmit?
	JRNZ	DS_Tx_BYTE2		;BR = Yes
	DSJS	A5,DS_Tx_WAIT2
DS_Tx_BYTE2
	MOVE	A4,*A0(UART_THR),W	;Then send the Low byte
	MMFM	SP,A0,A4,A5
	.else

;	RETS				;USE TO DEBUG SEND_RAW_SOUND

	mmtm	sp,a4
	clr	a4
	callr	SEND_RAW_SOUND
	mmfm	sp,a4

	.endif
	RETS

**************************************************************************
*								         *
* 		Software volume control code				 *
*								         *
**************************************************************************

MASTER_VOLUME_CODE	.EQU	055AAH	;Code for setting the master volume
VOLDN_SWITCH		.EQU	11	;Switch # of volume down
VOLUP_SWITCH		.EQU	12	;Switch # of volume up

**************************************************************************
*								         *
* 	PROC_RESET_VOLUME						 *
* 									 *
* 		Process to set the volume after a 2 second delay.	 *
* 		This is used in conjunction with SNDRES so that		 *
* 		the dings may be heard. It would be wise not to		 *
* 		make a sound call that results in output until this	 *
* 		process has set the volume.				 *
* 									 *
* 	A8 = Sleep time before reset.					 *
*								         *
**************************************************************************
PROC_RESET_VOLUME
	SLEEPR	A8
	CALLR	SET_VOLUME
	DIE

**************************************************************************
*								         *
* 	SET_VOLUME							 *
* 									 *
* 	Set the sound board volume based on the value stored in		 *
* 	CMOS RAM.  If the value is corrupt, then the value		 *
* 	FACTORY_VOLUME is used.						 *
*								         *
**************************************************************************
SET_VOLUME
	MMTM	SP,A0,A1,A4
	ADJUST	ADJVOLUME		;Get the current volume
	MOVE	A0,A1
	ADJUST	ADJMINVOL		;Get the minimum volume allowed
	CMP	A0,A1			;Are we lower than the minimum?
	JRHS	SV_OK			;BR = No, we are O.K.
     	MOVE	A0,A1			;Otherwise, set minimum.
SV_OK
	MOVI	MASTER_VOLUME_CODE,A4
	CALLR	SEND_RAW_SOUND		;Yo! Master volume is on it's way.
	MOVE	A1,A4
	NOT	A1			;I have a complement for you
	SLL	8,A4
        sll     32-8,a1
        srl     32-8,a1
	ADD	A1,A4			;Put 'em together for the send

	CALLR	SEND_RAW_SOUND		;Behold the master!

	MOVKM	1,@VOLUME_SET,W		;The volume has been set

	MMFM	SP,A0,A1,A4
	RETS


**************************************************************************
*								         *
* 	SWITCH_VOLUME_UP						 *
* 									 *
* 	Switch triggered process to increase the sound board volume.	 *
*								         *
**************************************************************************
SWITCH_VOLUME_UP
	MOVE	@COINS,A14,W
	BTST	13,A14
	JAZ	SUCIDE			;BR=COIN DOOR INTERLOCK OPEN

	MOVK	1,A8			;Increment   WBD
	MOVK	VOLUP_SWITCH,A10
	JRUC	SWITCH_VOLUME_CONTROL

**************************************************************************
*								         *
* 	SWITCH_VOLUME_DOWN						 *
* 									 *
* 	Switch triggered process to decrease the sound board volume.	 *
*								         *
**************************************************************************
SWITCH_VOLUME_DOWN
	MOVE	@COINS,A14,W
	BTST	13,A14
	JAZ	SUCIDE			;BR=COIN DOOR INTERLOCK OPEN

	MOVI	-1,A8			;Decrement   WBD
	MOVK	VOLDN_SWITCH,A10

**************************************************************************
*								         *
* 	SWITCH_VOLUME_CONTROL						 *
* 									 *
* 	Process to adjust volume					 *
* 									 *
* 	A8 = Change value						 *
* 	A10 = Switch number to check					 *
*								         *
**************************************************************************
SWITCH_VOLUME_CONTROL
	MOVE	@GAME_STATE,A14,W
	CMPI	INDIAG,A14
	JAEQ	SUCIDE

	MOVI	PID_VOLUME,A0
	CALLA	EXISTP_ALL		;Does this thing already exist?
	JRNZ	SVC_RESET_AND_DIE	;BR = Yes, so bail on this one.

;	MOVI	PID_VOLUME_DISP,A0
;	CALLA	KILLPROC_ALL		;Kill display deleter
;
;	MOVKM	1,@SUPRESS_PAGE_FLIP,W	;Shut down all writes to DPYST
;	MOVIM	DPYSTRT3,@DPYST,L	;Rock on to the volume page

SVC_CLICK
	ADJUST	ADJMINVOL
	MOVE	A0,A4			;Grab the minimum volume allowed

	ADJUST	ADJVOLUME		;Get the current volume.
	ADD	A8,A0			;Adjust it the right way.

	CMP	A4,A0
	JRGE	SVC_CK_MAX		;BR = we are not a adjusted minimum

	MOVE	A4,A0	 		;Force minimum

SVC_CK_MAX
	CMPI	MAX_VOLUME,A0		;Are we too high? (Too high? Is this possible?)
	JRLE	SVC_NEW_VOL		;BR = No, take another hit

	MOVI	MAX_VOLUME,A0		;Cut that sucka off

SVC_NEW_VOL
	MOVE	A0,A1
	MOVI	ADJVOLUME,A0
	CALLA	PUT_ADJ			;Store the new volume in CMOS
	CALLA	F_ADC_S			;And checksum it.
	CALLR	SET_VOLUME		;And set it.

;	MOVE	@DISPLAYON,A7,W
;	CLR	A14
;	MOVE	A14,@DISPLAYON,W
;	CALLA	DMAQWAIT       		;WAIT ON DMA
;	CLR	A14
;	MOVE	A14,@CMAPSEL,W 		;SELECT COLOR MAP 0
;
;	MMTM	SP,B11,B12,B13		;Protect DMA Queue regs
;
;	calla	draw_volume_scale1
;
;	MMFM	SP,B11,B12,B13		;Restore DMA Queue regs
;
;	MOVE	A7,@DISPLAYON,W		;and let display system run

SVC_WAIT
	SLEEP	1
	MOVE	@COINS,A14,W
	BTST	A10,A14			;Still holding the volume switch?
	JRNZ	SVC_BAIL		;BR = No, then let's bail
	JRUC	SVC_CLICK		;Click the volume again
SVC_BAIL
;	MOVIM	PID_VOLUME_DISP,*A13(PROCID),W
;	SLEEP	25
;	CLRM	@SUPRESS_PAGE_FLIP,W	;Restore writes to DPYST
	DIE

SVC_RESET_AND_DIE

	SLEEP	5
	CLR	A0
	BSET	A10,A0
	ORM	A0,@SW2TEMP1,L
	ORM	A0,@SW2TEMP2,L		;Clear the debounce RAM to re-trigger
	DIE


**************************************************************************
*								         *
* init_speech_buffer							 *
* 	input	nothing							 *
* 	output	nothing							 *
*								         *
**************************************************************************
init_speech_buffer
	movi	speech_buffer,a14
	move	a14,@speech_buffer_head,L
	move	a14,@speech_buffer_tail,L
	clr	a14
	move	a14,@speech_buffer_time,W
	rets

**************************************************************************
*								         *
* add_speech_into_buffer						 *
* 	input	a4 = number to add into speech buffer			 *
* 	output	nothing							 *
*								         *
**************************************************************************
add_speech_into_buffer
	move	@speech_buffer_head,a14,L
	move	a4,*a14+,W
	cmpi	speech_buffer_end,a14
	jrnz	asib1
	movi	speech_buffer,a14
asib1	move	a14,@speech_buffer_head,L
	rets

**************************************************************************
*								         *
* pull_speech_from_buffer						 *
* 	input	nothing							 *
* 	output	c  = buffer was non-empty				 *
* 		 a4= code pulled from buffer				 *
* 		nc = buffer was empty, nothing pulled			 *
*								         *
**************************************************************************
pull_speech_from_buffer
	move	@speech_buffer_tail,a1,L
	move	@speech_buffer_head,a14,L
	cmp	a1,a14
	jrz	psb_n
	move	*a1+,a4,W
	cmpi	speech_buffer_end,a1
	jrnz	psb_2
	movi	speech_buffer,a1
psb_2	move	a1,@speech_buffer_tail,L
	setc
	rets
psb_n	clrc
	rets

**************************************************************************
*								         *
* is_speech_buffer_empty						 *
* 	input	nothing							 *
* 	output	z  = buffer empty					 *
* 		nz = buffer non empty					 *
*								         *
**************************************************************************
is_speech_buffer_empty
	move	@speech_buffer_tail,a1,L
	move	@speech_buffer_head,a14,L
	cmp	a1,a14
	rets

**************************************************************************
*								         *
* get_speech_time_remaining						 *
* 	input	nothing							 *
* 	output	a0 = time left in current sound and buffer		 *
*								         *
**************************************************************************
get_speech_time_remaining
	mmtm	sp,a1,a2
	clr	a0
	move	@speech_buffer_tail,a1,L
	move	@speech_buffer_head,a14,L
gtr2	cmp	a1,a14
	jrz	gtr_8
	move	*a1+,a2,W
	cmpi	speech_buffer_end,a1
	jrnz	gtr1
	movi	speech_buffer,a1
gtr1	move	a2,a2
	jrnn	gtr2
	sub	a2,a0
	jruc	gtr2
gtr_8	move	@speech_buffer_time,a14
	add	a14,a0
	mmfm	sp,a1,a2
	rets

**************************************************************************
*								         *
* add_speech_sound_or_time						 *
* 	input	a4 = sound(+) or time(-)				 *
* 	output	nothing							 *
*								         *
**************************************************************************
add_speech_sound_or_time
	move	a4,a4
	jrn	add_speech_time
	;
**************************************************************************
*								         *
* add_speech_sound							 *
* 	input	a4 = sound						 *
* 	output	nothing							 *
*								         *
**************************************************************************
add_speech_sound
	move	@speech_buffer_time,a14,W
	jrnz	add_speech_into_buffer
	jruc	SEND_RAW_SOUND

**************************************************************************
*								         *
* add_speech_time							 *
* 	input	a4 = -time						 *
* 	output	nothing							 *
*								         *
**************************************************************************
add_speech_time
	move	@speech_buffer_time,a14,W
	jrnz	add_speech_into_buffer
	neg	a4
	move	a4,@speech_buffer_time,W
	rets

