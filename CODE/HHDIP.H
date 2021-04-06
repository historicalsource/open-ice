;**************************************************************************
;*									  *
;* 	                 DIPSWITCH EQUATE FILE				  *
;* 									  *
;* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		  *
;* 		       ALL RIGHTS RESERVED.				  *
;* 									  *
;**************************************************************************
;	DIP SWITCH

*
*  HOCKEY SWITCH ASSIGNMENT
*
*******************************************************
*
* SW1    Function
*
*   1    OFF=Dipswitch Coinage      ON = CMOS Coinage
*
* 2-4    COINAGE OPTIONS
*
* 5-6    COUNTRY OPTIONS
*
*   7    COUNTER/TOTALIZER
*
*   8    Unused
*
*******************************************************
*
* SW2    Function
*
*   1    OFF=No Bill Validator      ON = Bill Validator installed
*
*   2    OFF=Attract Mode Sounds    ON = No Attract Mode Sounds
*
*   3    OFF=Powerup Test ON        ON = Powerup Test Off
*
*   4    OFF=Normal Heads           ON = Big Heads
*
*   5    OFF=4 Players              ON = 2 Players
*
*   6    Unused
*
*   7    OFF=Normal Mode            ON = Video Freeze (undocumented)
*
*   8    OFF=Normal Mode            ON = Test Mode
*
*
*******************************************************

DPUSECMOS	EQU	0001H		;USE CMOS MASK

DPCOINAGE	EQU	00EH		;COINAGE MASK
SR_DPCOINAGE	EQU	1		;shift count to Right justify COINAGE bits

DPCOUNTRY	EQU	030H		;COUNTRY MASK
SR_DPCOUNTRY	EQU	4		;shift count to Right justify COUNTRY bits


DPCOUNTER	EQU	040H		;NUMBER OF COIN COUNTERS

DPVALIDATOR	EQU	 100h		;DOLLAR BILL VALIDATOR INSTALLED
DPATTSNDS   EQU    200h    ;Attract Mode Sounds on/off
DPPWRUP     EQU    400h    ;Powerup test on/off
DPHEADS     EQU    800h    ;type of heads (Normal/Big)
DPPLAYERS	EQU	1000H		;NUMBER OF HARDWARE PLAYERS 
SR_DPPLAYERS	EQU	12		;shift count to Right justify PLAYERS bits
DPUNUSED1	EQU	2000H		;UNUSED BIT 2
DPFREEZE	   EQU	4000H		;FREEZE SWITCH
DPTEST		EQU	8000H		;TEST SWITCH


;DPPOWER		EQU	64		;Tournament mode
;DPPOWER_B	EQU	6
