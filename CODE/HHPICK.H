**************************************************************************
*								         *
* SYMBOLS BETWEEN HHPICK.ASM AND HHPICK2.ASM				 *
*								         *
**************************************************************************

	.GLOBAL	SWAP_SOUND
	.GLOBAL	ARROW_PTR_INIT
	.GLOBAL	SETUP_PLAYERS
	.GLOBAL	BLUE_MUG_BGND_OBJ
	.GLOBAL	PICK_SOUND
	.GLOBAL	ARROW_IMG_TABLE
	.GLOBAL	RED_MUG_BGND_OBJ
	.GLOBAL	MUG_BGND_FLASH_ANIM
	.GLOBAL	UP_UPDATE_PLAYERS
	.GLOBAL	TEAM_SELECT_LEFT_POS_TABLE
	.GLOBAL	SELECT_TIMER_PROC
	.GLOBAL	SELECT_FLASHES
	.GLOBAL	LOCKED_CHAR_BITS
	.GLOBAL	TEAM_SELECT_PRETIMEOUT
	.GLOBAL	TEAM_SELECT_RGHT_POS_TABLE
	.GLOBAL	INITIAL_GRAPHICS_1
	.GLOBAL	INITIAL_GRAPHICS_2

**************************************************************************
*								         *
* EQUATES FOR HHPICK.ASM AND HHPICK2.ASM				 *
*								         *
**************************************************************************

INFOBOX_Y	EQU	111 ;105 ;126
INFOBOX_XL	EQU	13  ;12  ;12
INFOBOX_XR	EQU	208 ;209 ;207

RANK_YPOS	EQU	10

DIGIT_ON_TIME	EQU	50
DIGIT_OFF_TIME	EQU	25

SELECT_FLASHES	EQU	5			;NUMBER OF FLASHES

TEAM_SELECT_PRETIMEOUT	EQU	20

PSWAP		EQU	PDATA+0140H		;UHL SWAP INDEX COUNT
