 	.MLIB	"HHMACS.LIB"
	.FILE	"HHTV.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

**************************************************************************
*								         *
* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		 *
* 		       ALL RIGHTS RESERVED.				 *
*								         *
**************************************************************************

*	GET THE SYSTEM STUFF
	.INCLUDE	"HH.INC"
	.include	"hhtv.e"
	.include	"hhsnd.g"

; end of include files


	.TEXT

*
*HOOK CALLED WHENEVER TODDVIEW GAINS CONTROL OF THE PROCESSOR
TVBP
	MMTM	SP,A1,A14

	MOVE	@INTPEND,A14,W		;Clear any pending X2E AND DISPLAY INTS
****	ANDNI	X2E,A14
	ANDNI	DIE,A14			;**** VERY IMPORTANT **** HOPEFULLY!
	MOVE	A14,@INTPEND,W


	CALLA	DEBUG_SNDRST
	MMFM	SP,A1,A14
	RETS

*
*HOOK CALLED BEFORE TODDVIEW GIVES CONTROL BACK TO THE PROGRAM
TVBPX
	MMTM	SP,A1,A14

	MOVE	@INTPEND,A14,W		;Clear any pending X2E AND DISPLAY INTS
****	ANDNI	X2E,A14
	ANDNI	DIE,A14			;**** VERY IMPORTANT **** HOPEFULLY!
	MOVE	A14,@INTPEND,W

	MMFM	SP,A1,A14
	RETS

**************************************************************************
*								         *
* ROMTRAP - VECTOR FOR ROM TRAP INTERRUPT				 *
*								         *
**************************************************************************
ROMTRAP
	.IF DEBUG
	JRUC	$
	.ENDIF
	RETI

TVPATCH:
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
TVPATCHX:

