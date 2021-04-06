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
	.bss	last_track_used,16
	.bss	current_tune,16
	.bss	puck_ice_track,16
	.bss	puck_bounce_track,16
	.bss	ice_skate_track,16
	.bss	xxxxxxx,16
	.bss	raw_sound_data,16*300
	.bss	raw_sound_loc,32

	.BSS	SOUND_RX,16

	.TEXT

HIGHEST_TRACK	.equ	3

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

sound_table
	.word	0064h,53,0110h	;s_board_crash_10
	.word	0067h,51,0110h	;s_board_crash_4
	.word	006ah,53,0110h	;s_board_crash_5
	.word	006dh,40,0110h	;s_board_crash_8
	.word	0070h,48,0110h	;s_board_crash_9
	.word	0073h,96,0110h	;s_board_crash_j1	;unusable
	.word	0076h,19,0110h	;s_skates_upended
	.word	0079h,17,0110h	;s_goalie_mitt_1
	.word	007ch,26,0110h	;s_goalie_mitt_2
	.word	007fh,16,0110h	;s_goalie_mitt_5
	.word	0082h,14,0110h	;s_goalie_mitt_7
	.word	0085h,28,0110h	;s_goalie_pad_1
	.word	0088h,37,0110h	;s_goalie_pad_2
	.word	008bh,60,0110h	;s_goalie_skate_1	;possible corner
	.word	008eh,41,0110h	;s_goalie_skate_2
	.word	0091h,52,0110h	;s_goalie_skate_3
	.word	0094h,58,0110h	;s_goalie_skate_4
	.word	0097h,50,0110h	;s_goalie_skate_5
	.word	009ah,42,0110h	;s_goalie_skate_6
	.word	009dh,31,0110h	;s_goalie_stick_1
	.word	00a0h,6,0110h	;s_goalie_stick_2
	.word	00a3h,15,0110h	;s_goalie_stick_3	;good stick sound
	.word	00a6h,33,0110h	;s_goalie_stick_4	;good stick sound
	.word	00a9h,40,0110h	;s_hard_skate_stop_1
	.word	00ach,33,0110h	;s_hard_skate_stop_2
	.word	00afh,43,0110h	;s_hard_skate_stop_3
	.word	00b2h,43,0110h	;s_hard_skate_stop_4
	.word	00b5h,26,0110h	;s_hard_skate_stop_5
	.word	00b8h,20,0110h	;s_ice_crunch_1
	.word	00bbh,28,0110h	;s_ice_crunch_2
	.word	00beh,38,0110h	;s_loud_board_1
	.word	00c1h,30,0110h	;s_loud_board_2
	.word	00c4h,33,0110h	;s_loud_board_3
	.word	00c7h,54,0110h	;s_long_skate_1
	.word	00cah,67,0110h	;s_long_skate_2
	.word	00cdh,89,0110h	;s_long_skate_3
	.word	00d0h,60,0110h	;s_long_skate_4
	.word	00d3h,64,0110h	;s_long_skate_5
	.word	00d6h,65,0110h	;s_long_skate_6
	.word	00d9h,91,0110h	;s_long_skate_7
	.word	00dch,56,0110h	;s_puck_to_board_score_1	;unusable
	.word	00dfh,23,0110h	;s_puck_drop_1
	.word	00e2h,15,0110h	;s_puck_drop_2
	.word	00e5h,10,0110h	;s_puck_drop_3
	.word	00e8h,20,0110h	;s_puck_to_goalie_mask_1
	.word	00ebh,20,0110h	;s_puck_hit_board_1
	.word	00eeh,21,0110h	;s_puck_hit_board_2
	.word	00f1h,26,0110h	;s_puck_hit_board_3
	.word	00f4h,8,0110h	;s_puck_drop_in_net
	.word	00f7h,15,0110h	;s_puck_in_net_1
	.word	00fah,13,0110h	;s_puck_in_net_2
	.word	00fdh,18,0110h	;s_puck_in_net_3	;possible net sound
	.word	0100h,23,0110h	;s_puck_in_net_4	;possible puck on ice sound
	.word	0103h,18,0110h	;s_puck_in_net_5	;possible puck on ground in corner of net
	.word	0106h,32,0110h	;s_puck_in_net_6	;start of sound is net sound
	.word	0109h,33,0110h	;s_plastic_impact_1
	.word	010ch,26,0110h	;s_plastic_impact_2
	.word	010fh,21,0110h	;s_plastic_board_hit_1
	.word	0112h,55,0110h	;s_plastic_board_hit_2
	.word	0115h,27,0110h	;s_puck_to_metal_0
	.word	0118h,36,0110h	;s_puck_to_metal_1
	.word	011bh,12,0110h	;s_puck_to_metal_2
	.word	011eh,32,0110h	;s_puck_pass_1
	.word	0121h,35,0110h	;s_puck_pass_2
	.word	0124h,40,0110h	;s_puck_pass_3
	.word	0127h,31,0110h	;s_puck_pass_4
	.word	012ah,57,0110h	;s_puck_pass_5
	.word	012dh,58,0110h	;s_puck_ricochet_1
	.word	0130h,46,0110h	;s_puck_ricochet_2
	.word	0133h,56,0110h	;s_puck_ricochet_3
	.word	0136h,58,0110h	;s_puck_slide_2
	.word	0139h,51,010eh	;s_puck_slide_3
	.word	013ch,36,0110h	;s_puck_slide_4
	.word	013fh,50,010eh	;s_puck_slide_6
	.word	0142h,28,0110h	;s_skate_1
	.word	0145h,44,0110h	;s_skate_2
	.word	0148h,27,0110h	;s_skate_3
	.word	014bh,15,0110h	;s_skate_4
	.word	014eh,42,0110h	;s_skate_5
	.word	0151h,46,0110h	;s_skate_6
	.word	0154h,30,0110h	;s_skate_7
	.word	0157h,20,0110h	;s_skate_8
	.word	015ah,24,0110h	;s_skate_9
	.word	015dh,28,0110h	;s_skate_10
	.word	0160h,26,0110h	;s_skate_11
	.word	0163h,24,0110h	;s_skate_12
	.word	0166h,22,0110h	;s_skate_13
	.word	0169h,19,0110h	;s_skate_14
	.word	016ch,21,0110h	;s_skate_15
	.word	016fh,14,0110h	;s_skate_16
	.word	0172h,49,0110h	;s_skate_17
	.word	0175h,17,0110h	;s_skate_18
	.word	0178h,20,0110h	;s_skate_19
	.word	017bh,19,0110h	;s_skate_20
	.word	017eh,10,0110h	;s_skate_21
	.word	0181h,15,0110h	;s_skate_22
	.word	0184h,27,0110h	;s_skate_23
	.word	0187h,23,0110h	;s_skate_24
	.word	018ah,23,0110h	;s_skate_25
	.word	018dh,19,0110h	;s_skate_26
	.word	0190h,61,0110h	;s_skate_27	unusable	same as 1b7
	.word	0193h,25,0110h	;s_skate_28
	.word	0196h,43,0110h	;s_skate_29
	.word	0199h,41,0110h	;s_skate_30
	.word	019ch,44,0110h	;s_skate_31
	.word	019fh,49,0110h	;s_skate_32
	.word	01a2h,38,0110h	;s_skate_33
	.word	01a5h,23,0110h	;s_skate_34
	.word	01a8h,43,0110h	;s_skate_35
	.word	01abh,15,0110h	;s_skate_36
	.word	01aeh,33,0110h	;s_skate_37
	.word	01b1h,38,0110h	;s_skate_up_foreground
	.word	01b4h,49,0110h	;s_run_on_skates_1	unusable
	.word	01b7h,61,0110h	;s_run_on_skates_2	unusable
	.word	01bah,41,0110h	;s_slapshot_1
	.word	01bdh,22,0110h	;s_slapshot_2
	.word	01c0h,44,0110h	;s_slapshot_3
	.word	01c3h,36,0110h	;s_slapshot_4
	.word	01c6h,31,0110h	;s_slapshot_6
	.word	01c9h,35,0110h	;s_slapshot_7
	.word	01cch,34,0110h	;s_stick_sound_1
	.word	01cfh,34,0110h	;s_stick_to_pad_1
	.word	01d2h,61,0110h	;s_stick_bounce_1
	.word	01d5h,45,0110h	;s_stick_slide_1
	.word	01d8h,32,0110h	;s_skate_stop_or_turn_1
	.word	01dbh,25,0110h	;s_skate_stop_or_turn_2
	.word	01deh,32,0110h	;s_skate_stop_or_turn_3
	.word	01e1h,38,0110h	;s_skate_stop_or_turn_4
	.word	01e4h,40,0110h	;s_skate_stop_or_turn_5	same as above
	.word	01e7h,49,0110h	;s_skate_stop_or_turn_6
	.word	020dh,118,0110h	;s_long puck slide 5
	.word	0212h,157,0110h	;s_long puck slide 6
	.word	0217h,123,0110h	;s_long puck slide 7


kill_all_sound
	mmtm	sp,a0,a4
	clr	a0
	callr	set_tune_a0
	mmfm	sp,a0,a4
	rets

set_attract_tune
	movk	8,a0
	jruc	set_tune_a0

attract_tune_end
	movk	9,a0
	jruc	set_tune_a0

set_background_tune
	mmtm	sp,a0,a4
	movk	3,a0
	callr	set_tune_a0
	mmfm	sp,a0,a4
	rets

set_tune_a0
	move	@current_tune,a14,W
	cmp	a0,a14
	jrz	st9
	move	a0,@current_tune,W
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
*								         *
**************************************************************************
ds_1	mmtm	sp,a0,a1,a2,a3,a5,a6,a7,a8,a9,a10
	jruc	ds_2
do_sound
	mmtm	sp,a0,a1,a2,a3,a5,a6,a7,a8,a9,a10
	movi	255,a10		;full volume
ds_2	sll	4,a4
	move	a4,a5
	sll	1,a5
	add	a4,a5
	addi	sound_table,a5
	move	*a5+,a4,W	;sound
	move	*a5+,a9,W	;time
	move	*a5+,a8,W	;priority
	callr	do_sound_at_priority
	mmfm	sp,a0,a1,a2,a3,a5,a6,a7,a8,a9,a10
	rets

**************************************************************************
*								         *
* do_sound_at_priority							 *
* 	input	a4 = raw sound code					 *
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
	jrls	ds_go
	dsjs	a2,dsap2
	clrc
	rets
ds_go	btst	8,a8		;check equal
	jrz	dsg1
	dec	a3
dsg1	move	a3,a1
	callr	set_track_priority
	move	a9,a1
	callr	set_track_time
	move	a10,a1
	callr	set_track_volume
	add	a0,a4		;add offset to raw code
	dec	a4		;our base is track 1, not 0
	callr	SEND_RAW_SOUND
	move	a4,a1
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
co3	move	a0,a4				;return our track in a4
	setc
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
	callr	SEND_URAW_SOUND
	move	a1,a4
	not	a4
	sll	8,a4
	add	a1,a4
	not	a4
	sll	16,a4
	srl	16,a4
	jruc	SEND_URAW_SOUND

sound_exec
	move	@track_1_time,a14,W
	jrz	se_2
	dec	a14
	move	a14,@track_1_time,W
se_2	move	@track_2_time,a14,W
	jrz	se_3
	dec	a14
	move	a14,@track_2_time,W
se_3	move	@track_3_time,a14,W
	jrz	se_4
	dec	a14
	move	a14,@track_3_time,W
se_4	rets



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

SNDSND
SEND_RAW_SOUND
	move	@raw_sound_loc,a14,L
	move	a4,*a14+,W
	cmpi	raw_sound_loc,a14
	jrnz	bsf
	movi	raw_sound_data,a14
bsf	move	a14,@raw_sound_loc,L

SEND_URAW_SOUND
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
	move	a4,a4			; is it a null call (negative)?
	jrn	sendx
	move	a4,a0
	sll	32-16,a4
	srl	32-8,a4			; a3 = high byte
*
* send high byte
*
	addi	0ff00h|soundbit,a4	; send high byte.
	move	a4,@SOUND		; hit sound (low)
	movk	2,a2
	dsj	a2,$			; time for signal to get through
 	callr	poll_sirq
*
* send low byte
*
	sll	32-8,a0
	srl	32-8,a0			; a3 = low byte
	addi	0ff00h|soundbit,a0	; send low
	move	a0,@SOUND		; hit sound (low)
	movk	2,a2
	dsj	a2,$			; time for signal to get through
	callr	poll_sirq
sendx
	mmfm	sp,a0,a1,a2,a3,a4
	.endif
	rets

	.if	XUNIT=0
*****************************************************************************
* Poll sound IRQ.  When IRQ goes high, sound board is ready for next call.
* Do timeout so sound board can't screw things up.
*

poll_sirq
	movi	390/3,a3		; 180 micros max firq delay on snd board
poll3
	movb	@SOUNDIRQ+B_SIRQ-7,a1
	jrn	poll9			; done?
	dsj	a3,poll3
poll9
	rets
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
	jruc	$
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

	movi	raw_sound_data,a0
	move	a0,@raw_sound_loc,L

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
	movi	SNDRSTBIT|32,a0
	move	a0,@COIN_COUNTERS
	movi	6000,a0		;wait for it to catch
	dsjs	a0,$
	movi	32,a0
	move	a0,@COIN_COUNTERS
	pullq	a0		; Restore the reggies
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
	MSECWT	250000			;Wait for the freaky sound reset
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
	mmtm	sp,a4
	clr	a4
	callr	SNDSND
	mmfm	sp,a4
	.endif
	RETS

**************************************************************************
*								         *
* 		Software volume control code				 *
*								         *
**************************************************************************

MASTER_VOLUME_CODE	.EQU	055AAH	;Code for setting the master volume
VOLUP_SWITCH		.EQU	11	;Switch # of volume up
VOLDN_SWITCH		.EQU	12	;Switch # of volume down

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
	SLL	8,A1
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
	MOVK	1,A8			;Increment
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
	MOVI	-1,A8			;Decrement
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
