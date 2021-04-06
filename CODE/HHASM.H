;**************************************************************************
;*									  *
;* 		SYSTEM "ASSEMBLY TIME" CONDITIONALS			  *
;*									  *
;**************************************************************************

BILL		EQU	0	;BILL'S ASSEMBLY SWITCH			
NOBODY		EQU	1	;NO ASSEMBLY SWITCH

	.if BILL+NOBODY != 1

	DIS AIN'T RIGHT!!!

	.endif

DEBUG		EQU	0	;THIS VERSION IS CURRENTLY UNDER CONSTRUCTION
;DEBUG		EQU	0	;ADD THIS BEFORE RELEASE!!!!!

WRITE_TO_ROM_INT	.EQU	1	;ENABLE
;WRITE_TO_ROM_INT	.EQU	0	;DISABLE

bog_line	equ	0	;if 1, draw bog lines

NO_HELP_WINDOWS	EQU	0	;DISABLE HELP WINDOWS ONLY FOR TESTING

SHOT_DATA	EQU	0	;DISABLE HELP WINDOWS ONLY FOR TESTING

NOTFINAL	EQU	1	;IF = 1, NOT PRODUCTION QUALITY PROGRAM
;NOTFINAL	EQU	0	;ADD THIS BEFORE RELEASE!!!!!

FORCEFREE	EQU	0	;1 = GAME HARDWIRED FREE
FULLPRICE	EQU	1	;1 = ALL THE PRICINGS ARE INCLUDED

NO_PUCK_HOG	EQU	0	;disable slow down of player who is hogging puck

XUNIT		equ	0

self_play	equ	0
freeze_ok	equ	1	;game can be frozen with game_frozen
new_speech	equ	1

	.if DEBUG = 0

;	.if bog_line+NO_HELP_WINDOWS+NO_PUCK_HOG+self_play != 0
	.if bog_line+self_play != 0

	SOMETHING'S WRONG!!!

	.endif

	.endif
