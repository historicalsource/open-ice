 	.MLIB	"HHMACS.LIB"
	.FILE	"HH.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"hh.e"
	.include	"hhram.g"
	.include	"hhd.g"
	.include	"hhcmos.g"
	.include	"hhproc.g"
	.include	"hhmenu.g"
	.include	"hhutil.g"
	.include	"hhcoin.g"
	.include	"hhdutl.g"
	.include	"hhsnd.g"
	.include	"hhdtst.g"
	.include	"hhpall.g"
	.include	"hhmisc.g"
	.include	"hhc.g"
	.include	"hha.g"
	.include	"hhattrct.g"

; end of include files
	.if XUNIT=1
	.ref	code_start, code_end, code_dest
	.ref	vector_start, vector_end, vector_dest
	.endif

	.IF DEBUG
	.ref	CPUCHK1,CPUCHK2,CPUCHK3,CPUCHK4,CPUCHK5
	.ref	CLIPTIM,SCALETIM,VELTIM,PROCTIM
	.ENDIF

	.BSS	EXECLED,16
	.BSS	IRQLED,16
	.BSS	DIPSW,16	;RAM FAKE FOR NON-EXISTANT DIP SWITCHES
	.BSS	SWITCH_ESCAPE,16 ;SWITCH ESCAPE FLAG USED BY SLEEP_SWITCHX
	.BSS	SWITCH_SPOKEN,16 ;SWITCH SPEAK FLAG
	.BSS	DMASKIPBOG,16	;Flag to skip BOG calculator for one frame

	.TEXT

	.EVEN

**************************************************************************
*								         *
* 	POWERUP								 *
* 									 *
* 	This section of code is Loaded and Executed from the Image	 *
* 	ROM area.  Not only will it handle power-on diagnostics,	 *
* 	but it will also copy the program into RAM space.		 *
* 									 *
* 	The 020 will have to be initialized properly and once		 *
* 	the copying is done, the DMA must get priority over the		 *
* 	image ROM.							 *
*								         *
**************************************************************************
	.if XUNIT=1
	.sect	"COLDSTRT"
	.endif
POWERUP
	DINT
	SETF	16,1,0			;WORD SIGN EXTEND
	SETF	32,1,1			;LONG WORD
	CLR	A14
	MOVE	A14,@DMAGOREG,L
	MOVE	A14,@DMAGOREG,L		;DMA off for sure
	MOVI	INITDATA,B0
	MOVI	IDATALEN,B7
	.if	XUNIT=1
	MOVI	VESYNC,B2
	BLMOVE	1,1			;TRANSFER I/O REGS
	movi	DPYSTRT0,a14
	move	a14,@DPYST,L		;Make sure we're viewing the right one
	.else
	movi	HESYNC,b2
	srl	5,b7
_io_reg_move
	move	*b0+,*b2+,L
	dsjs	b7,_io_reg_move
;	movi	0fffch,a14
	movi	0ch,a14
	move	a14,@DPYSTRT,W
	.endif
	MOVI	STCKST,SP,L
*
* Manual sound board reset.  Yes, you will get the dongs.
*
	.if	XUNIT=1
	MOVI	SYSC_COLD|(SND_RESET<<8),A0
	MOVE	A0,@SYSCTRL0,L		;Setup system control and
	SRL	8,A0
	MOVE	A0,@SYSCTRL1,L		;Tug the sound board reset line
	MOVI	SYSC_COLD,A0
	SRL	8,A0
	MOVE	A0,@SYSCTRL1,L		;Release the reset line
	.else
	movi	SYSCINIT,a0
	move	a0,@SYSCTRL,W
	movi	030h,a0
	move	a0,@COINS,W
	movi	6000,a0
	dsjs	a0,$
	movi	020h,a0
	move	a0,@COINS,W
	.endif
*
*Go do the Power On CPU test, make sure it doesn't touch the INT_REG.
*
****	JAUC	POWERTST		;DO THE PATENTED POWER UP TEST
POWERRET
	FCALL	INITCOLR,B5		; FIX UP THE COLORS
	FCALL	DSCRCLR,B6		; MAKE SURE OF SCREEN
	MOVI	MESS_LOAD,A0
	FCALL	STRINGCENTER,B6		; GET WIDTH OF STRING
	ADDI	[30,0],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	.if	XUNIT=1
*
*	Load code here
*
	MOVI	vector_start,B0
	MOVI	vector_dest,B2
	MOVI	vector_end,B7
	SUB	B0,B7
	BLMOVE	1,1			;TRANSFER VECTORS

	MOVI	code_start,B0
	MOVI	code_dest,B2
	MOVI	code_end,B7
	SUB	B0,B7
	BLMOVE	1,1			;TRANSFER CODE, ZZZZZZ

	MOVI	SYSCINIT,A0		;Make it so we can work, girl
	MOVE	A0,@SYSCOPY		;KEEP A COPY IN RAM
	MOVE	A0,@SYSCTRL0,L
	srl	8,a0
	MOVE	A0,@SYSCTRL1,L
	.else
	movi	SYSCINIT,a0
	move	a0,@SYSCOPY
	move	a0,@SYSCTRL,W
	.endif

*CHECK FOR A WATCH DOG SITUATION
	MOVE	@INT_REG,A0,L		;XUNIT CHECK IF WATCHDOG WAS REAL
	BTST	B_WDOG,A0		;BIT SHOULD BE LOW IF DOG FIRED
	JRNZ	NEWSETUP		;BR = VALID RESET, NOT WATCHDOG
	AUDIT	AUDDOGGY		;CLICK A WATCH DOG RESET
	MOVK	2,A14
	getpc	B14			;Show where we are
	CALLA	DUMP_IT
NEWSETUP
	JAUC	WARMSET			;And start the machine

MESS_LOAD
	.STRING	"LOADING PROGRAM...",0
	.EVEN
*
*End of COLD_START section
*

	.TEXT
*
*NOW THAT THE POWER ON TESTS ARE DONE, WE CAN INITIALIZE AGAIN, FOR REAL!
SETUP
WARMSET
	DINT
	SETF	16,1,0	;WORD SIGN EXTEND
	SETF	32,1,1	;LONG WORD

	.if	XUNIT=0
	movi	VMUX_INIT,a0
	move	a0,@VMUX_CONTROL,W
	.endif

	MOVI	STCKST,SP,L
	CALLR	CLSCRACH		;CLEAR SCRATCHPAD
	MOVI	SYSCINIT,A0		;
	MOVE	A0,@SYSCOPY		; GET EVERYBODY HAPPY

	.if	XUNIT=1
	MOVE	A0,@SYSCTRL0,L		; XUNIT
	srl	8,a0			; XUNIT
	move	a0,@SYSCTRL1,L		; XUNIT
	.else
	move	a0,@SYSCTRL,W
	.endif

	CALLR	DIPINIT
	JAUC	POWERCMOS		;VERIFY CMOS AND PRINT OPENING MESSAGE
PCMOSRET
	CALLR	MAIN_INIT	;DO NORMAL INITIALIZATIONS
	CALLA	TIMEINIT	;WHY MUST WE DO THIS?

	EINT			;ENABLE INTERRUPTS AND WE'RE OFF
	DISPON			;ENABLE THE DISPLAY SYSTEM

	CALLA	CKDIAG		;ARE ANY OF THE DIAG SWITCHES CLOSED?
	JRZ	MAIN_GO		;BR = NO
	CREATE	PID_DIAG,DIAG	;FIRE OFF THE DIAG PROCESS
	JRUC	EXEC_LP		;AND THEN DISPATCH IT.
MAIN_GO
	CLR	A0
	MOVE	A0,@COINFLAG,W	; NOT ON COIN PAGE YET
	CALLA	ATSTRT		;START ATTRACT MODE

**************************************************************************
*								         *
* 		START OF EXECUTIVE LOOP					 *
*								         *
**************************************************************************
EXEC_LP
	CALLA	PRCDSP		;DISPATCH PROCESSES
	MOVE	A13,A13		;DID PROCESS EXECUTE CORRECTLY?
	JRZ	EXEC_POK	;BR = YES
	LOCKUP			;REPORT THE SITUATION
EXEC_POK
*
*UNSTACK THE VALID SWITCH CLOSURES AND ACTIVATE PROCESSES
*
	MOVI	ACTIVE,A13,L
	MOVE	@SWSTACK,A3,L
EXEC_UNSTKLP
	CMPI	SWSTST,A3,L	;STACK AT START?
	JREQ	EXEC_UNSTKX	;YES, EXIT
	MOVE	@FREE,A0,L
	JRZ	EXEC_UNSTKX	;NO PROCESSES LEFT, TRY NEXT TIME AROUND
	MOVE	*A3+,A0,W	;GET ENTRY
	MOVE	A3,@SWSTACK,L	;UPDATE STACK
	MOVE	A0,A2
	ADD	A0,A2
	ADD	A0,A2		;MULT BY 3
	SLL	4,A2		;ADJUST FOR WORD SIZE (16)
	ADDI	SWTAB,A2
	MOVE	*A2+,A1		;GET PID
	MOVE	*A2+,A7,L	;GET STARTING ADDR
	JREQ	EXEC_UNSTKLP	;NULL ENTRY
	MOVE	@PAUSE_GAME,A0,W	;IS THE GAME IN PAUSE MODE?
	JRZ	EXEC_SWITCH_CREATE	;BR = NO, CONTINUE AS NORMAL
	MOVE	A1,A0			;ANY DESTRUCTIBLE PROCESSES WILL
	ZEXT	A0			;BE PAUSED BY THIS FLAG
	SRL	13,A0
	JRZ	EXEC_UNSTKLP
EXEC_SWITCH_CREATE
	CALLA	GETPRC
	JRUC	EXEC_UNSTKLP
EXEC_UNSTKX
	CALLA	RANDOM		;RESEED THE RANDOM NUMBER GENERATOR

	calla	sound_exec

	MOVE	@EXECLED,A0,W
	INC	A0
	MOVE	A0,@EXECLED,W
	CMPI	5,A0
	JRLT	EXEC_LP		;BR = NOT TIME TO BLINK THE EXEC LED

	CLR	A0
	MOVE	A0,@EXECLED,W

	PUSHST
	DINT
*
*DO SOME SYSCTRL STUFF WHILE INTERRUPTS ARE OFF
*
	MOVE	@SYSCOPY,A0	;BLINK L.E.D. TO ACK OPERATION

	.if	XUNIT=1
	XORI	LED_ON<<8,A0 	; XUNIT
	MOVE	A0,@SYSCOPY	; XUNIT
	srl	8,a0		; XUNIT
	MOVE	A0,@SYSCTRL1,L	; XUNIT
	.else
	xori	LED_ON,a0
	move	a0,@SYSCOPY
	move	a0,@SYSCTRL,W
	.endif

	POPST

	CALLR	StCpuLft
	JRUC	EXEC_LP


**************************************************************************
*								         *
* 			END OF EXECUTIVE LOOP				 *
*								         *
**************************************************************************

**************************************************************************
*								         *
* StCpuLft - ROUTINE TO CALCULATE CPU TIME LEFT				 *
*								         *
**************************************************************************
StCpuLft
	move	@TIMER,A0,W
	jrz	NoBog
	movi	EOSINT,a1
	clr	A1
	jruc	GotTime
NoBog	movi	EOSINT,A1
	move	@VCOUNT,A0
;MJL
	jrn	StCpuLft_aBoRt
;MJL END
	sub	A0,A1
	JRN	StCpuLft_aBoRt	;BR = Something is strange with the value

	.if	bog_line
	move	a0,@bog_cpu
	.endif

	movi	1000*10000H/EOSINT,A0
	mpyu	A0,A1
	srl	16,A1
GotTime	move	A1,@CPULEFT,W
	MOVE	@CPULOW,A0,W
	CMP	A0,A1
	JRGE	NO_NEWLOW
	MOVE	A1,@CPULOW,W
NO_NEWLOW
	MOVE	@CPUHI,A0,W
	CMP	A0,A1
	JRLE	NO_NEWHI
	MOVE	A1,@CPUHI,W
NO_NEWHI
	srl	3,A1
	move	@CPUAVG,A0,W
	move	A0,A2
	srl	3,A2
	sub	A2,A0
	add	A0,A1
	move	A1,@CPUAVG,W
StCpuLft_aBoRt
	rets


**************************************************************************
*								         *
* MAIN_INIT - CUMBERSOME SYSTEM INITIALIZATION STUFF, USED TO BRING	 *
* 		UP THE SYSTEM COLD.					 *
* 	    RAM MUST BE O.K., STACK POINTER VALID AND FIELDS SET.	 *
* RETURNS								 *
* 	A13 = PROCESS ACTIVE LIST					 *
*								         *
**************************************************************************
MAIN_INIT
	PUSH	A0
	MOVI	INAMODE,A0
	MOVE	A0,@GAME_STATE,W
	MOVI	0FFFFH,A0
	MOVE	A0,@SOUND_COPY,W	;INITIALIZE THE SOUND PORT COPY
	CALLR	INITIO			;INITIALIZE THE I/O REGS
	CALLR	INIT_DMACONFIG		;INITIALIZE DMACONFIG REGISTER
*SET UP TI PIXEL PROCESSING REGS
	CALLA	SETPPROC
*INIT COLOR RAM
	CLR	A0
	MOVE	A0,@DMAGOREG,L		; XUNIT
	MOVE	A0,@DMAGOREG,L	  	; XUNIT  OFF DMA
	MOVE	A0,@CMAPSEL		;CLEAR COLOR MAP SELECT
	MOVE	A0,@IRQLED
	MOVE	A0,@EXECLED
*CLEAR THE SCREEN
	CALLA	SCRCLR
*INITIALIZE RANDOM SEED
	MOVI	81261A8CH,A0
	MOVE	A0,@RAND,L
*ENABLE DISPLAY INTERRUPT
	MOVI  	DIE|X2E,A0
	MOVE  	A0,@INTENB		;enable display interrupts

*Initialize the System interrupt register
	MOVIM	LINT2_INTS,@INT_REG,L

*INITIALIZE SWITCH STACK
	MOVI	SWSTST,A0
	MOVE	A0,@SWSTACK,L
*INITIALIZE SYSTEM CONTROL REGISTER
	MOVI	SYSCINIT,A0
	MOVE	A0,@SYSCOPY		;KEEP A COPY IN RAM
 
	.if	XUNIT=1
	MOVE	A0,@SYSCTRL0,L		; XUNIT
	srl	8,a0			; XUNIT
	MOVE	A0,@SYSCTRL1,L		; XUNIT
	.else
	move	a0,@SYSCTRL,W
	.endif

*INITIALIZE DIP SWITCH OPTIONS
	CALLR	DIPINIT
*INITIALIZE PROCESS AND DISPLAY LISTS AND START THE SYSTEM
	CALLA	PINIT 		;INIT PROCESS LIST
	CALLA	OINIT		;DO THIS FIRST FOR THE DMA'S SAKE
	CALLA	MYOINIT		;INITIALIZE THE OBJECT LIST
	CALLA	CLEAR_PAGE2	;Clear video bit map page 2
	CALLA	CLEAR_PAGE3	;Clear video bit map page 3
*RESET THE SOUND BOARD - Must be called after the process system is init'd
;	CALLA	SNDRES
	CALLA	QSNDRST

	PULL	A0
	RETS

**************************************************************************
*								         *
* INIT_DMACONFIG - INITIALIZE THE DMACONFIG				 *
*								         *
* CALL DIS UPON POWER UP						 *
*								         *
**************************************************************************
INIT_DMACONFIG
	MOVIM	DMACF4,@DMACONFIG,L	;ADJUST WINDOW RIGHT/LEFT BORDER
	movi	[511,0],a14
	move	a14,@DMAWINDOW,L
	MOVI	DMAWIN|DMACF4,A14
	MOVE	A14,@DMACFIGCOPY,L
	MOVE	A14,@DMACONFIG,L 	;LEAVE CONFIG'D FOR TOP/BOT ADJUSTMENT
	RETS

**************************************************************************
*                                                                        *
* DIPINIT - INITIALIZE OPTIONS VIA DIP SWITCH SETTINGS			 *
*                                                                        *
**************************************************************************
DIPINIT
	MMTM	SP,A0,A1
	CALLA	READ_DIP		;LOAD UP THE CURRENT DIP SWITCH BITS
	MOVE	A0,A1	   		;STORE FOR MULTIPLE USES
	ANDI	DPPLAYERS,A0		;AQUIRE THE NUMBER OF PLAYERS
	SRL	9,A0
	ADDI	PLNUM,A0
	MOVB	*A0,A0
	MOVE	A0,@NPLAYERS,W
	MMFM	SP,A0,A1
	RETS

PLNUM	.BYTE	2,1,0,0
	.EVEN

**************************************************************************
*                                                                        *
* ATSTRT - START THE ATTRACT MODE PROCESS				 *
*                                                                        *
**************************************************************************
ATSTRT
	MMTM	SP,A0,A1,A7
	MOVI	INAMODE,A1
	MOVE	A1,@GAME_STATE,W
	MOVIM	SCRNST_FULL,@SCRNTL,L
	MOVKM	1,@GAMERASE,W		;AUTO-ERASE FULL
	MMFM	SP,A0,A1,A7
	C_A_K	PID_ATTRACT_MODE,ATTRACT_MODE
DUMRETS
DUMCOL
	RETS

**************************************************************************
*								         *
* WIPEOUT - WIPES THE SYSTEM CLEAR OF ALL OTHER PROCESSES, OBJECTS	 *
* 	  AND COORDINATES.						 *
* 	  IT RETURNS WITH THE DISPLAY SYSTEM AND AUTO-ERASE SHUT OFF,	 *
* 	  COLOR RAM CLEARED, AND THE BIT MAP WIPED CLEAN.		 *
* 	  THIS IS NICE TO USE WHEN SWITCHING BETWEEN STUFF.		 *
* NOTE: TRASHES A14							 *
*								         *
**************************************************************************
WIPEOUT
	MMTM	SP,A0,A1,A7
        CLR     A0
	MOVE	A0,@PAGE,W
	MOVE	A0,@COINFLAG,W		;NOT ON COIN PAGE YET
	MOVE	A0,@PAUSE_GAME,W	;TURN OFF GAME PAUSE
	MOVE	A0,@NOPGFLIP,W		;ALLOW PAGE FLIPPING
	MOVE	A0,@SWITCH_SPOKEN,W	;SWITCH SPEAK FLAG
	CALLR	KILL_DESTRUCTIBLES
	CLR	A0
	MOVE	A0,@GAMERASE,W
	CLR	A0
	MOVE	A0,@DISPLAYON,W		;TURN THE DISPLAY PROCESSOR OFF
	CALLA	CLRDMAQ			;RESET THE Q
	CALLA	DMAWAIT			;WAIT ON DMA TO FINISH
	PUSHST
	DINT
	CALLA	CLRSWPRC
	CALLA	MYOINIT			;RE-INIT THE OBJECT LIST
	CALLR	SYSINITL
	MOVE	@INTPEND,A1,W		;CLEAR INTERRUPT PENDING
	ANDNI	DIE,A1
	MOVE	A1,@INTPEND,W
	POPST
	CALLA	CLR_SCRN		;WIPE OUT THE BIT MAP
	CALLA	IAUTOE			;INITIALIZE THE AUTO ERASE AREA
	CLR	A0
	MOVE	A0,@IRQSKYE,W		;CLR THE AUTO-ERASE COLOR
	MOVE	@SUPRESS_PAGE_FLIP,A14,W
	JRNZ	WO_NO_PF

	.if	XUNIT=1
	MOVI	DPYSTRT0,A0
	MOVE	A0,@DPYST,L		;XUNIT RESET DISPLAY START POINT
	.else
;	movi	0fffch,a0
	movi	0ch,a0
	move	a0,@DPYSTRT,W
	.endif

WO_NO_PF
	MMFM	SP,A0,A1,A7
	RETS

**************************************************************************
*								         *
* KILL_DESTRUCTIBLES - KILL ALL OF THE DESTRUCTIBLE PROCESSES CURRENTLY	 *
* 		     ACTIVE.						 *
*								         *
**************************************************************************
KILL_DESTRUCTIBLES
	MMTM	SP,A0,A1,A7
	CLR	A0
	MOVI	M_INDESTRUCT,A1
	CALLA	KILALL			;KILL ALL BUT THE INDESTRUCTIBLES
	CALLA	COLOR_START		;RE-START THE COLOR PROCESSES
	MMFM	SP,A0,A1,A7
	RETS

FREEZE_SW .EQU	8
FREEZE_DIP .EQU 9
**************************************************************************
*								         *
* FREEZE_ABSOLUTE - PROCESS TO FREEZE THE GAME ACTION WHEN THE FREEZE BU *
* 	 GOES FROM OFF TO ON. GAME RESUMES WHEN THE BUTTON IS RELEASED.	 *
*								         *
**************************************************************************
FREEZE_ABSOLUTE
	MOVE	@GAME_STATE,A0
	CMPI	INDIAG,A0
	JREQ	FREEZE_DIE		;NO FREEZE SHIT DURING DIAGNOSTICS
	MOVE	@GAMERASE,A8,W
	MOVK	1,A0
	MOVE	A0,@GAMERASE,W
	DISPOFF
	CALLA	DMAQWAIT		;BLOW OUT THE QUEUE'D IMAGES
	PUSHST
	DINT
FREEZE_LP
	MOVE	@COINS,A0,W		;GET THE COIN DOOR SWITCHES
	BTST	FREEZE_SW,A0
	JREQ	FREEZE_LP		;LOOP 'TIL BUTTON COMES UP
	MOVE	@DIPSWITCH,A0,W
	BTST	FREEZE_DIP,A0
	JREQ	FREEZE_LP
	POPST
	MOVE	A8,@GAMERASE,W
	DISPON
FREEZE_DIE
	DIE

**************************************************************************
*                                                                        *
* CLRSWPRC - MAKE ALL SWITCH TRIGGERED PROCESSES DUMDIE ENTRIES		 *
* NOTE: CALL WHEN INTERRUPTS ARE TURNED OFF				 *
*                                                                        *
**************************************************************************
CLRSWPRC
	MMTM	SP,A0,A1,A3
	MOVI	63,A1		;USE SWTAB ENTRY 40 FOR DUMDIE PROC
	MOVE	@SWSTACK,A3,L
CLRSTKL	CMPI	SWSTST,A3,L	;STACK AT START?
	JREQ	CLRSTKX		;YES, EXIT
	MOVE	*A3+,A0,W
	CMPI	63,A0
	JRLS	CLRSTKL		;THIS ENTRY IS A REAL SWITCH
	MOVE	A1,*A3(-10H),W	;STORE THE DUMDIE CALL
	JRUC	CLRSTKL
CLRSTKX
	MMFM	SP,A0,A1,A3
	RETS

**************************************************************************
*								         *
* 	CLSCRACH							 *
* 									 *
* 	Clear all of scratch pad RAM.					 *
* 									 *
* 	NOTE: A0,A1,A2 and A3 are trashed.				 *
* 	      This is very destructive. Make sure you setup 		 *
* 		all relevant variables after calling this.		 *
*								         *
**************************************************************************
CLSCRACH
	PULL	A3
*CLEAR SCRATCHPAD RAM
	CLR	A0
	MOVI	SCRATCH,A1,L
	MOVI	(SCRATCH_END-SCRATCH)/32,A2,L  	;CLEAR LONGS
SCTLP	MOVE	A0,*A1+,L
	DSJS	A2,SCTLP
	JUMP	A3

**************************************************************************
*                                                                        *
* SYSTEM ROUTINES AND PROCESSES						 *
*                                                                        *
**************************************************************************
*GAME RAM INITIALIZATION
GRAMINIT
	MMTM	SP,A0,A1,A2
	MOVI	GRAMSTRT,A1
	MOVI	GRAMEND,A2
	JRUC	RAMINIT
RAMINIT	CLR	A0
RAMLOOP	MOVE	A0,*A1+,W	;16 BITS AT A TIME, NO EXTRANEOUS CLEARS
	CMP	A2,A1		;DONE?
	JRLO	RAMLOOP		;NO!
	MMFM	SP,A0,A1,A2
	RETS

**************************************************************************
*                                                                        *
* SYSINITL - INITIALIZE LOW BYTE OF SYSTEM CONTROL REGISTER		 *
*                                                                        *
**************************************************************************
SYSINITL
	PUSH	A0
	MOVI	SYSCINIT,A0
	MOVE	A0,@SYSCOPY		;RE-INITIALIZE SYSTEM CONTROL REG

	.if	XUNIT=1
	MOVE	A0,@SYSCTRL0,L		; XUNIT
	srl	8,a0			; XUNIT
	MOVE	A0,@SYSCTRL1,L		; XUNIT
	MOVI	700H,A0	     		
	MOVE	A0,@SECCHIP,L		; WHAT TO DO BOUT THIS ???XUNIT???
	MOVE	A0,@SECCHIP,L
	.else
	move	a0,@SYSCTRL,W
	.endif

	PULL	A0
	RETS

**************************************************************************
*								         *
* IAUTOE - ROUTINE TO INITIALIZE THE TWO AUTO-ERASE LINES TO THEIR	 *
* 		DEFAULT COLOR.						 *
*								         *
**************************************************************************
IAUTOE
	PUSH	A0
	movi	ERASECOL,A0		;color 63, pal 0
	move	A0,@NewAECol
	dec	A0
	move	A0,@OldAECol
	PULLQ	A0
	rets

**************************************************************************
*								         *
* SRT_CLR - ROUTINE TO CLEAR SCREEN BEFORE NEXT PLOT			 *
* NOTE: TRASHES MANY A AND B FILE REGISTERS				 *
* 	DON'T EXPLICITLY USE B11 - B13 UNLESS DMA INTERRUPT IS OFF.	 *
*								         *
**************************************************************************
SRT_CLR
*	color to clear to stored in Lines 510 and 511
	MOVE	@SKIPDISP,A0,W
	JRNZ	SRT_CLRX

	MOVE	@NOAUTOE,A0,W
	JRNE	SRT_CLRX		;DON'T ERASE

	movi	255,B2			;GET AUTO ERASE LINE
	MOVE	@GAMERASE,B9,W		;GET THE CURRENT AUTO-ERASE SCHEME
	JREQ	SRT_CLRX		;BR = AUTO-ERASE IS OFF

	SLL	6,B9
	ADDI	GAMERASE_TAB,B9
	MOVE	*B9+,B8,L		;GET THE SIZE
	MOVE	*B9,B7,L		;GET THE SIZE

	callr	SRT_CORE
SRT_CLRX
	rets
*
*	B2 = VLINE where erase color is found
*	B8 = START VLINE
*	B7 = [num_lines : 1]
*
SRT_CORE
	sll	12,b8		;convert start line to linear
	move	@CONVDP,A12,W
	movk	012H,B9
	move	B9,@CONVDP		;Move to CONVDP io register

* Set SRT=1.  This converts pixel accesses to VRAM SR transfer cycles.

	MOVE	@DPYCTL,B10,W		;Copy display control reg.
	move	B10,A13			; save in A file
	ANDNI	SRE+ENV,B10	     	;Turn off screen refresh
	ORI	CST,B10		     	; XUNIT Enable SR transfers
	MOVI	(4096*MICRO_SECOND)/4,A0	;MAX WAIT FOR 400X256 DMA
SrtDmaWt	
	MOVE	@DMAGOREG,A14,L		;DMA STILL BUSY?
	JRNN	SRT_DMA_READY		;BR = NO, READY
	DSJS	A0,SrtDmaWt

	CLR	A14
	MOVE	A14,@DMAGOREG,L
	MOVE	A14,@DMAGOREG,L		;DMA off for sure

	CALLA	CLRDMAQ

SRT_DMA_READY

*
*WARNING! KEEP INTERRUPTS OFF UNTIL AFTER THE FILL INSTRUCTION
*	ASYNCHRONOUS BREAKS MAY CAUSE DMA INTERRUPT TO OCCUR
*	DURING FILL INSTRUCTION TRASHING THE B REGISTERS THAT
*	DETERMINE FILL RESTART AFTER INTERRUPT.
*	WHEN DEBUGGING THIS CAUSES SPURIOUS ILLEGAL OPCODES AND TRASHING
*	OF CODE SPACE.
*
	PUSHST
	DINT
	MOVE	B10,@DPYCTL,0 		;Load new display control
	movi	SCRN_PTCH*2,B3	 	;Get Screen Pitch

* Load frame buffer for 1st line into VRAM shift registers.
	CLR	B4		     	;Origin at start of memory
	sll	13,b2 		; change line number into address

	.if	XUNIT=1
	MOVK	1,A14
	MOVE	A14,@SECCHIP,L	;Hack for Steve and his bogus VRAMs
	.endif

	PIXT	*B2,B2		;Load VRAM shift registers

* Transfer contents of VRAM shift registers to rest of frame buffer.
	move	@PAGEADDR,B4,L
	clr	B2
	movx	b2,b4		; clear out X
	SRL	4,B4		; convert from XY to linear
	ADD	B8,B4
	MMTM	SP,B11,B12,B13
	FILL	 XY				;200 SR-to-memory transfers
	MMFM	SP,B11,B12,B13
	POPST
*END OF INTERRUPT DISABLE

* Restore previous contents of registers.
	move	A12,@CONVDP,W
   	MOVE 	A13,@DPYCTL,W		;Copy display control reg.
	rets

**************************************************************************
*								         *
* 			TABLE OF SCREEN ERASE PARAMS			 *
* 	ENTRY:								 *
*       .LONG   OFFSET TO START ERASE CLEAR     			 *
* 	.LONG	LENGTH OF ERASE DOMAIN					 *
*								         *
**************************************************************************
ERA_ENT .macro	TOP,BOTTOM
	.LONG	:TOP:*1000h
	.LONG	[((:BOTTOM:)-(:TOP:)+1)>>1,1]
	.endm

GAMERASE_TAB
	ERA_ENT	SCRTOP,SCRBOT
	ERA_ENT	SCRTOP,SCRBOT

**************************************************************************

*CALLED AT VERTICAL BLANK WHEN IT IS KNOWN THAT THE DMA IS FINISHED.
* IT WILL SWAP THE PLOT AND VIEWED PAGES, REPLACES SwapPgA AND SwapPgB.
SWAP_PAGES
	MOVE	@SUPRESS_PAGE_FLIP,A0,W	;Totally blow off all page changing?
	JRNZ	SWAP_PageAX	  	;BR = Yes

	MOVE	@NOPGFLIP,A0,W
	JRZ	SWAP_ME

	.if	XUNIT=1
*NO PAGE FLIPPING, JUST STICK IT ON PAGE 0
	clr	A0		;PLOT ON PAGE 0 now
	movi	PAGE0ADR,A1
	movi	DPYSTRT0,A2	;DISPLAY PAGE 0 now
       	JRUC	SWAP_SetPgAd

SWAP_ME
	MOVE	@SKIPDISP,A0,W
	jrnz	SWAP_PageAX

	;**** PAGE 1 starts on the 256th line of the video ram
	movk	1,A0		;Assume Page 1
	movi	PAGE1ADR,A1
	movi	DPYSTRT0,A2	;DISPLAY PAGE 0

	move	@PAGE,A14,W
	jrz	SWAP_SetPgAd

	;**** PAGE 0 starts on the 0th line of the video ram
	clr	A0		;PLOT ON PAGE 0 now
	movi	PAGE0ADR,A1
	movi	DPYSTRT1,A2	;DISPLAY PAGE 1 now

SWAP_SetPgAd
	move	A1,@PAGEADDR,L
	move	A0,@PAGE,W
;XUNIT	move	a2,@DPYADR		;Override DPYSTRT
	move	a2,@DPYST,L 	; XUNIT Stuff our new DPYST to be cool
	MOVE	A2,@DPYNX,L	; XUNIT Override DPYST and take effect immeadiately

	.else

*NO PAGE FLIPPING, JUST STICK IT ON PAGE 0
	clr	A0		;PLOT ON PAGE 0 now
	movi	PAGE0ADR,a1
;	movi	0fffch,a2
	movi	0ch,a2
       	JRUC	SWAP_SetPgAd

SWAP_ME
	MOVE	@SKIPDISP,A0,W
	jrnz	SWAP_PageAX

	;**** PAGE 1 starts on the 256th line of the video ram
	movk	1,A0		;Assume Page 1
	movi	PAGE1ADR,a1
;	movi	0fffch,a2	;Display page 0
	movi	0ch,a2	;Display page 0

	move	@PAGE,A14,W
	jrz	SWAP_SetPgAd

	;**** PAGE 0 starts on the 0th line of the video ram
	clr	A0		;PLOT ON PAGE 0 now
	movi	PAGE0ADR,a1
;	movi	0f01ch,a2	;Display Page 1
	movi	0f02ch,a2	;Display Page 1

SWAP_SetPgAd
	move	A1,@PAGEADDR,L
	move	A0,@PAGE,W
	move	a2,@DPYADR,W		;Override DPYSTRT
	move	a2,@DPYSTRT,W

	.endif

SWAP_PageAX
	rets

**************************************************************************

**************************************************************************
*                                                                        *
* DIRQ - DISPLAY IRQ, USES THE VALUE STORED @DPYINT TO DETERMINE	 *
*        WHICH INTERRUPT WE HAVE RECEIVED.				 *
*                                                                        *
**************************************************************************
DIRQ
	.if	XUNIT=1
	MMTM	SP,A0,A1
	.else
	MMTM	SP,A0,A1,a2,a3
	.endif

	SETF	1,0,0
	CLR	A1
	MOVE	A1,@INTPEND+DIP	;CLEAR STUPID INTERRUPT PENDING
	MOVE	A1,@INTENB+DIP	;DISABLE DISPLAY INTERRUPT
*REMOVED OLD WAY OF CLEARING THOSE BITS
	SETF	16,1,0		;WORD SIGN EXTEND

	EINT			;ENABLE OTHER INTERRUPTS

	.IF NOTFINAL
	MOVE	*SP(20H+40H),A0,L
	MOVE	A0,@INTADDR,L
	.ENDIF

	.IF DEBUG
	GETPC	A1
	MOVE	*A1,A0,W
	SRL	2,A0
	SLL	2,A0
	CMPI	0F0H,A0
	JREQ	$
	.ENDIF

	move	@DPYINT,A0,W
	cmpi	EOSINT,A0	;is this DIRQ or DIRQ2?
	jrne	DIRQ2
	MOVE	@DIAG_DFLAG,A0,W	;SPECIAL DIRQ FOR GSP DIAGS?
	JRNZ	DIAG_DIRQ		;BR = YES

**************************************************************************
*								         *
*  	END OF SCREEN INTERRUPT. DISPLAY PROCESSING, SWITCHES, COINS	 *
* 	COLORS, ETC.							 *
*								         *
**************************************************************************
	.if	XUNIT=0
	move	@DPYCTL,a3,W		;>Shift register read to restart DMA
	movi	06810h,a0
	move	a0,@DPYCTL,W
	movi	(510*01000h),a2		;*Autoerase lines
	pixt	*a2,a2			;Mem to shift reg xfer
	move	a3,@DPYCTL,W		;Restore
	.endif

	.if	XUNIT=1
	MMTM	SP,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14
	MMTM	SP,B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B14
	.else
	MMTM	SP,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14
	MMTM	SP,B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B14
	.endif

*CODE TO HANDLE OVERLOAD SITUATIONS WHICH
*WILL RESULT IN A FRAME RATE REDUCTION
	MOVE	B13,B0
	CMP	B12,B0		;IS THE DMA Q EMPTY?
	JRLE	DIRQ_CKMP	;BR = Yes
;MJL TEST
	JRUC	DIRQ_CKMP
;MJL END

*
*DMA appears to be overloaded here. Use this hook to do some stuff
*	during DEBUG mode only.
*
	MOVKM	1,@DMASKIPBOG,W		;Skip the bog check next time

	.if	XUNIT=1
	MOVE	@INTENB,A1,W
	BTST	B_X1E,A1
	JRZ	DIRQ_OVERLOAD		;BR = DMA not running
	.endif

	MOVI	(4096*MICRO_SECOND)/4,A1	;MAX WAIT FOR 400X256 DMA
DIRQ_DQWAIT
	CMP	B13,B0		;DMA Q CHANGE?
	JRNE	DIRQ_OVERLOAD  	;BR = YES, WE'RE OK
	DSJS	A1,DIRQ_DQWAIT

	LOCKUP			;DMA Q IS FROZEN?

	CLR	A14
	MOVE	A14,@DMAGOREG,L
	MOVE	A14,@DMAGOREG,L		;DMA off for sure

	CALLA	CLRDMAQ
	JRUC	DIRQ_OVERLOAD
DIRQ_CKMP
	MOVE	@DMASKIPBOG,A14,W	;Should we skip the DMA bog checker?
	JREQ	DIRQ_CKMP2		;BR = No
	CLR	A14
	MOVE	A14,@DMASKIPBOG,W	;We use this stuff to skip the bog
	NOT	A14			;calculator because of massive DMA
	MOVE	A14,@DMATMP,W		;overload.
DIRQ_CKMP2
	MOVE	@TIMER,A1,W	;Are the processes done?
	JRZ	DIRQ_OK		;BR = Yes
*
*CPU appears to be overloaded here.
*
	MOVE	@WAVEIRQS,A14,L
	BTST	0,A14
	JRZ	DIRQ_OK

**************************************************************************
* COMMENT THE FOLLOWING JUMP TO SEE THE EFFECT OF CPU BOG ON THE DISPLAY.*
;	JRUC	DIRQ_OK
**************************************************************************

*Any overload will get you here.
DIRQ_OVERLOAD
;	CALLA	VELADD		;Always do the Velocity add
; don't veladd anymore (MDP)
	JRUC	DIRQ_60HZ	;Skip the display processor for some headroom

*
*No overload detected here. Do things normally
*
DIRQ_OK
	CALLR	SWAP_PAGES
	callr	SRT_CLR

*
*UPDATE NORMAL CYCLING COLOR RAM
	MOVI	COLRTEMP+COLROFFST,A0	;GET NEW COLORS

	.if	XUNIT=1
	MOVI	CYCOLORS+(COLROFFST*2),A1	;GET ADDRESS OF CYCLE COLORS
	.else
	MOVI	CYCOLORS+COLROFFST,A1		;GET ADDRESS OF CYCLE COLORS
	.endif

	MOVK	COLRCNT,A6
COLORUP	MOVE	*A0+,a14

	.if	XUNIT=1
	move	a14,*A1+,L 
	.else
	move	a14,*a1+,W
	.endif

	DSJS	A6,COLORUP
	MOVE	@IRQSKYE,@ERASELOC,W	;MOVE IN THE CORRECT COLOR
	CALLA	PALTRANS		;XFER NEW PALETTES IF NECESSARY
	INCM	@WAVEDISPS,W	;CLICK THE WAVE DISPLAY PROC CALLS
	CALLA	DISPLAY		;GOT TO MAKE THE DONUTS

*
*Everything from here to the end of the IRQ code must
*	be executed every tick.
*
DIRQ_60HZ
	move	@DMATMP,a1		;Let's see where the DMA ended
	jrn	not_qued		;BR = Do not do a timing check now
	MOVE	@DMASKIPBOG,A14		;Is this an overload read?
	JRZ	DIRQ_DMA_NORM		;BR = No
	clr	a0			;Force no time left
	jruc	DIRQ_DMA_COMPUTE
DIRQ_DMA_NORM
	movi	EOSINT,A0
	sub	A1,A0
	JRN	not_qued		;BR = Something is strange with the value
DIRQ_DMA_COMPUTE
	movi	1000*10000H/EOSINT,A1
	mpyu	A0,A1
	srl	16,A1	  		;DMA time left is on a scale of
	move	a1,@DMALFT		;0 to 1000 for this frame.
	srl	3,A1
	move	@DMAAVG,A0,W
	move	A0,A2
	srl	3,A2
	sub	A2,A0
	add	A0,A1
	move	A1,@DMAAVG,W		;Average value to make it useful

not_qued
	CLR	A14
	NOT	A14
	move	a14,@DMATMP
	MOVE	@TIMER,A1		;HIT PROCESS TIMER
	INC	A1
	MOVE	A1,@TIMER
	.IF DEBUG
	.ELSE
	CMPI	200,A1
	JRLO	NO_IRQDOG		;NOTHING IS HUNG
	DINT
	JRUC	$			;HANG AND LET THE DOG BITE.
NO_IRQDOG
	.ENDIF
	CALLA	COININT		;HANDLE SOME COINS!
	CALLR	SWSCAN		;SCAN SWITCHES TO TRIGGER PROCS.
	MOVE	@PAUSE_GAME,A14,W
	JRNZ	IRQ_SKIP_WI	;NO TIMING DURING GLOBAL PAUSE MODE
	INCM	@WAVEIRQS,L	;CLICK THE WAVE DIRQ COUNT
IRQ_SKIP_WI
	DINT
	SETF	1,0,0
	MOVK	1,A0
	MOVE	A0,@INTENB+DIP	;ENABLE DISPLAY INTERRUPT
	SETF	16,1,0
	MOVE	@IRQLED,A0,W
	INC	A0
	MOVE	A0,@IRQLED,W
	CMPI	8,A0
	JRLT	DIRQX
*
*DO EVERYTHING FROM HERE TO DIRQX EVERY 8 TICKS
*
	CLR	A0
	MOVE	A0,@IRQLED,W

	MOVE	@SYSCOPY,A0
	.if	XUNIT=1
	XORI	LED_ON<<8,A0
	MOVE	A0,@SYSCOPY	; XUNIT
	srl	8,a0	 	; XUNIT
	MOVE	A0,@SYSCTRL1,L	; XUNIT
	.else
	xori	LED_ON,a0
	move	a0,@SYSCOPY
	move	a0,@SYSCTRL,W
	.endif

	MOVE	a0,@WDOG_BONE 	; XUNIT THROW ROVER A BONE
DIRQX	.IF NOTFINAL
	move	@INTADDR,@LASTINT,L
	clr	A0
	move	A0,@INTADDR,L
	.ENDIF

*
*CHECK IF AUTO-ERASE COLORS HAVE CHANGED, IF SO
*CREATE A NEW INTERRUPT TO STORE DATA
*
	move	@NewAECol,A0,L
	move	@OldAECol,A1,L
	cmp	A0,A1
	jrz	SkAEInt

SetAEInt
	movi	DIRQ2INT,A0	;STUFF DPYINT FOR DIRQ2 (CHANGE AUTOERASE COL)
	move	A0,@DPYINT,W
SkAEInt
	MMFM	SP,B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B14
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14

	RETI

**************************************************************************
*								         *
* SPECIAL DISPLAY INTERRUPT FOR DIAGNOSTIC TEST THAT DO ALL DRAWING	 *
* WITH THE DMA(i.e. SWITCH TEST, DIPSWITCH TEST, etc.)			 *
* FEEDS WATCHDOG AND INCS TIMER						 *
*								         *
**************************************************************************
DIAG_DIRQ
	MOVE	A0,@WDOG_BONE	; XUNIT THROW ROVER A BONE
	MOVE	@TIMER,A0	;HIT PROCESS TIMER
	INC	A0
	MOVE	A0,@TIMER
	DINT
	SETF	1,0,0
	MOVK	1,A0
	MOVE	A0,@INTENB+DIP	;ENABLE DISPLAY INTERRUPT
	.if	XUNIT=1
	mmfm	SP,A0,A1
	.else
	mmfm	SP,A0,A1,a2,a3
	.endif
	RETI

**************************************************************************
*								         *
* DIRQ2 - USED TO CHANGE THE COLOR OF THE AUTO-ERASE LINES. IF THE DMA	 *
* 	IS NOT CURRENTLY BUSY. IF IT IS, WE'LL TRY NEXT SCREEN.		 *
*								         *
**************************************************************************
DIRQ2	movi	EOSINT,A0	;STUFF DPYINT FOR NEXT INTERRUPT
	move	A0,@DPYINT,W
	cmp	B12,B13		;Is Q Non-Empty?
	jrgt	DIRQ2X
	MOVE	@DMAGOREG,A0,L	; XUNIT DMA BUSY?
	JRN	DIRQ2X

	;*** SET UP DMA TRANSFER TO RESTUFF AUTOERASE COLOR ***
	move	@NewAECol,A1,W
	move	@OldAECol,A0,W
	cmp	A0,A1
	jreq	SkSetAE
	move	A1,@OldAECol,W
	;*** STUFF CORRECT COLOR IN AUTOERASE LINES ***
	movi	DMAREGS,A1
	MOVI	01FF01FEH,A0
	MOVE	A0,*A1,L	;WINDOW BOTTOM - TOP
	MOVI	01000100H,A0
	MOVE	A0,-*A1,L	;Y-SCALE:X-SCALE
	move	@OldAECol,A0
	sll	16,a0
	MOVE	A0,-*A1,L	;CONST:PALETTE
	movi	[2,SCRWIDTH],A0
	MOVE	A0,-*A1,L	;VSIZE:HSIZE
	movi	[510,CENTER_XSHIFT],A0

	move	A0,-*A1,L	;DESTINATION Y:X
	movi	IROM,A0		; XUNIT
	MOVE	A0,-*A1,L	;IMAGE SAG
	movi	DMACAL<<16,A0
	MOVE	A0,-*A1,L		;STUFF THE CONTROL:OFFSET
SkSetAE

DIRQ2X
	DINT
	SETF	1,0,0
	MOVK	1,A0
	MOVE	A0,@INTENB+DIP	;ENABLE DISPLAY INTERRUPT
	.if	XUNIT=1
	mmfm	SP,A0,A1
	.else
	mmfm	SP,A0,A1,a2,a3
	.endif
	RETI
*
*SWITCHES SCANNED HERE WILL ACTIVATE THE PROCESSES IN THE SWITCH PROCESS
*TABLE.
*BASHES A0,A1,A2 & A3 SO BEWARE!
SWSCAN
	move	@SWITCH,a0	; XUNIT ST
	move	@SWITCH2,a14
	sll	16,a14
	movy	a14,a0		; XUNIT END
	MOVE	@SWTEMP1,A1,L	;PREVIOUS STATE T=N-1
	MOVE	@SWTEMP2,A2,L	;PREVIOUS PREVIOUS T=N-2
	MOVE	A1,@SWTEMP2,L	;NEW PREVIOUS PREVIOUS
	MOVE	A0,@SWTEMP1,L	;NEW PREVIOUS
	AND	A1,A2
	ANDN	A0,A2		;LOOK FOR 110
	JREQ	SWITCH2_CHECK	;NO SWITCHES
	MOVE	@SWSTACK,A3,L	;SWITCH ACTIVATION STACK
SWSCLP				;FIND BIT SET
	CMPI	SWSTMN,A3	;SWITCH STACK OVERFLOW?
	JREQ	SWSCX1		;YEP, QUIT
	LMO	A2,A0		;1'S COMP LEFTMOST BIT
	RL	A0,A2		;GET RID OF BIT
	SLL	1,A2
	MOVK	31,A1		;CALC TRUE BIT #
	SUB	A0,A1
	MOVE	A1,-*A3		;PUSH SWITCH NUMBER ON STACK (0-15)
	RL	A1,A2		;RESTORE SWITCH WORD WITHOUT BIT
	JRNE	SWSCLP
SWSCX1
	MOVE	A3,@SWSTACK,L	;RESTORE SWITCH STACK
*
SWITCH2_CHECK
	move	@COINS,a0
	move	@DIPSWITCH,a14
	sll	16,a14
	movy	a14,a0		; XUNIT END
	MOVE	@SW2TEMP1,A1,L	;PREVIOUS STATE T=N-1
	MOVE	@SW2TEMP2,A2,L	;PREVIOUS PREVIOUS T=N-2
	MOVE	A1,@SW2TEMP2,L	;NEW PREVIOUS PREVIOUS
	MOVE	A0,@SW2TEMP1,L	;NEW PREVIOUS
	AND	A1,A2
	ANDN	A0,A2		;LOOK FOR 110
	JREQ	SWSCX		;NO SWITCHES
	MOVE	@SWSTACK,A3,L	;SWITCH ACTIVATION STACK
SW2SCLP				;FIND BIT SET
	CMPI	SWSTMN,A3	;SWITCH STACK OVERFLOW?
	JREQ	SW2SCX1		;YEP, QUIT
	LMO	A2,A0		;1'S COMP LEFTMOST BIT
	RL	A0,A2		;GET RID OF BIT
	SLL	1,A2
	MOVI	63,A1
	SUB	A0,A1
	MOVE	A1,-*A3		;PUSH SWITCH NUMBER ON STACK (0-15)
	RL	A1,A2		;RESTORE SWITCH WORD WITHOUT BIT
	JRNE	SW2SCLP
SW2SCX1
	MOVE	A3,@SWSTACK,L	;RESTORE SWITCH STACK
SWSCX
	RETS

**************************************************************************
*                                                                        *
* INITIO - INITIALIZE THE GSP I/O REGISTERS				 *
*                                                                        *
**************************************************************************
INITIO
	MMTM	SP,B0,B2,B7
	MOVI	INITDATA,B0
	MOVI	IDATALEN,B7

	.if XUNIT=1
	MOVI	VESYNC,B2
	BLMOVE	1,1				;TRANSFER I/O REGS
	movi	DPYSTRT0,a14	; XUNIT
	move	a14,@DPYST,L	; XUNIT
	.else
	movi	HESYNC,b2
	srl	5,b7
_ior_move
	move	*b0+,*b2+,L
	dsjs	b7,_ior_move
;	movi	0fffch,a14
	movi	0ch,a14
	move	a14,@DPYSTRT,W
	.endif

	MMFM	SP,B0,B2,B7
	RETS

*
*DUMMY FOR THE SWITCHES
DUMDIE	JAUC	SUCIDE		;NOTHING PROCESS

**************************************************************************
*                                                                        *
* BADTRAP - COME HERE WHEN A TRAP IS HIT THAT IS NOT DEFINED AND LOG IT. *
*                                                                        *
**************************************************************************
BADTRAP
	MOVI	1,A14
	move	*SP(20h),B14,L	;Send the return address, we know its bad
	CALLA	DUMP_IT
	AUDIT	AUDBADTRAP	;CLICK A SOFTWARE TRAP
	DINT
	JRUC	$	;LET THE WATCH DOG CATCH US

**************************************************************************
*								         *
* 	Switch process activation table					 *
* 	Used in conjunction with the IRQ switch scanner.		 *
* 									 *
* 	     .WORD  PROCESS ID						 *
* 	     .LONG  STARTING ADDR					 *
*								         *
**************************************************************************
SWTAB
*
*Players 1 and 2 start here, read at location SWITCH
*
	WL	0,0			;SW  0 -- (JAMMA P1 Up)
	WL	0,0			;SW  1 -- (JAMMA P1 Down)
	WL	0,0			;SW  2 -- (JAMMA P1 Left)
	WL	0,0			;SW  3 -- (JAMMA P1 Right)
	WL	PID_IND,SW_4		;SW  4 -- (JAMMA P1 A)
	WL	PID_IND,SW_5		;SW  5 -- (JAMMA P1 B)
	WL	PID_IND,SW_6		;SW  6 -- (JAMMA P1 C)
    	WL	PID_IND,SW_7		;SW  7 -- (JAMMA P1 D)
  	WL	0,0			;SW  8 -- (JAMMA P2 Up)
	WL	0,0			;SW  9 -- (JAMMA P2 Down)
	WL	0,0			;SW 10 -- (JAMMA P2 Left)
	WL	0,0			;SW 11 -- (JAMMA P2 Right)
	WL	PID_IND,SW_12		;SW 12 -- (JAMMA P2 A)
	WL	PID_IND,SW_13		;SW 13 -- (JAMMA P2 B)
    	WL	PID_IND,SW_14		;SW 14 -- (JAMMA P2 C)
    	WL	PID_IND,SW_15		;SW 15 -- (JAMMA P2 D)
*
*Players 3 and 4 start here, read at location SWITCH2
*
	WL	0,0			;SW 16 -- (JAMMA P3 Up)
	WL	0,0			;SW 17 -- (JAMMA P3 Down)
	WL	0,0			;SW 18 -- (JAMMA P3 Left)
	WL	0,0			;SW 19 -- (JAMMA P3 Right)
	WL	PID_IND,SW_20		;SW 20 -- (JAMMA P3 A)
	WL	PID_IND,SW_21		;SW 21 -- (JAMMA P3 B)
    	WL	PID_IND,SW_22		;SW 22 -- (JAMMA P3 C)
    	WL	PID_IND,SW_23		;SW 23 -- (JAMMA P3 D)
    	WL	0,0			;SW 24 -- (JAMMA P4 Up)
    	WL	0,0			;SW 25 -- (JAMMA P4 Down)
    	WL	0,0			;SW 26 -- (JAMMA P4 Left)
    	WL	0,0			;SW 27 -- (JAMMA P4 Right)
    	WL	PID_IND,SW_28		;SW 28 -- (JAMMA P4 A)
    	WL	PID_IND,SW_29		;SW 29 -- (JAMMA P4 B)
    	WL	PID_IND,SW_30		;SW 30 -- (JAMMA P4 C)
    	WL	PID_IND,SW_31		;SW 31 -- (JAMMA P4 D)
*
*Coins and misc start here, read at location COINS
*
    	WL	PID_LC,LCOIN		;SW 32 -- Left Coin
    	WL	PID_RC,RCOIN		;SW 33 -- Right Coin
	WL	PID_IND,SW_34		;SW 34 -- Player 1 Start
    	WL	PID_SLAM,SLAM		;SW 35 -- SLAM!
    	WL	PID_DIAG,DIAG		;SW 36 -- Diagnostics
	WL	PID_IND,SW_37		;SW 37 -- Player 2 Start
    	WL	PID_LC,SCOIN		;SW 38 -- Service Credit
    	WL	PID_CC,CCOIN		;SW 39 -- Center Coin
	WL	PID_XC,XCOIN		;SW 40 -- Fourth Coin
	WL	PID_IND,SW_41		;SW 41 -- Player 3 Start
    	WL	PID_IND,SW_42		;SW 42 -- Player 4 Start
	WL	PID_VOLUME,SWITCH_VOLUME_UP   ;SW 43 -- Volume Up
	WL	PID_VOLUME,SWITCH_VOLUME_DOWN ;SW 44 -- Volume Down
	WL	0,0			;SW 45 -- UNUSED
    	WL	PID_INDW,FREEZE_ABSOLUTE ;SW 46 -- Freeze Switch
	WL	0,0			;SW 47 -- Bill acceptor
*
*DIP switches start here, read at location DIPSWITCH
*
    	WL	0,0			;SW 48 -- SWITCH 48	UJ2-8
    	WL	0,0			;SW 49 -- SWITCH 49	UJ2-7
    	WL	0,0			;SW 50 -- SWITCH 50	UJ2-6
    	WL	0,0			;SW 51 -- SWITCH 51	UJ2-5
    	WL	0,0			;SW 52 -- SWITCH 52	UJ2-4
    	WL	0,0			;SW 53 -- SWITCH 53	UJ2-3
    	WL	0,0			;SW 54 -- SWITCH 54	UJ2-2
    	WL	0,0			;SW 55 -- SWITCH 55	UJ2-1
    	WL	0,0			;SW 56 -- SWITCH 56	UJ1-8
    	WL	0,0			;SW 57 -- SWITCH 57	UJ1-7
    	WL	0,0			;SW 58 -- SWITCH 58	UJ1-6
    	WL	0,0			;SW 59 -- SWITCH 59	UJ1-5
    	WL	0,0			;SW 60 -- SWITCH 60	UJ1-4
    	WL	0,0			;SW 61 -- SWITCH 61	UJ1-3
    	WL	PID_INDW,FREEZE_ABSOLUTE ;SW 62 -- VIDEO FREEZE	UJ1-2
    	WL	PID_DIAG,DIAG		;SW 63 -- TEST SWITCH	UJ1-1

* VIDEO CONTROL REGISTERS INITIAL VALUES
	.if XUNIT=1
	.sect	"COLDSTRT"

INITDATA
	.WORD   0003H*2			;>C0000000 -- vesync
	.WORD	0002BH			;>C0000010 -- hesync
	.WORD   ENDVBLNK		;>C0000020 -- VEBLNK
	.WORD	00065H			;>C0000030 -- heblnk
	.WORD   0100H+(ENDVBLNK-2)	;>C0000040 -- VSBLNK
	.WORD	001f5H			;>C0000050 -- hsblnk
	.WORD   0120H			;>C0000060 -- vtotal
	.WORD	001f9H			;>C0000070 -- htotal

	.WORD   0D007H			;>C0000080 -- DPYCTL
	.WORD	0			;>C0000090 -- dpystrt
	.WORD	EOSINT			;>C00000A0 -- dpyint * INITIALLY HALF SCREEN
	.WORD	INI_CTRL		;>C00000B0 -- control
	.WORD	04h  			;>C00000C0 -- hstdata
	.WORD	00h			;>C00000D0 -- hstadrl
	.WORD	00h			;>C00000E0 -- hstadrh
	.WORD	00h			;>C00000F0 -- hstctll
	.WORD	00h			;>C0000100 -- hstctlh
	.WORD	00h			;>C0000110 -- intenbl
	.WORD	00h			;>C0000120 -- intpend
	.WORD	00h			;>C0000130 -- convsp
	.WORD	CONV_PTCH		;>C0000140 -- convdp
	.WORD	PXSIZE			;>C0000150 -- psize
	.WORD	00h			;>C0000160 -- pmaskl
	.WORD	00h			;>C0000170 -- pmaskh
	.WORD	00h			;>C0000180 -- CONVMP
	.WORD	INI_CTRL		;>C0000190 -- CONTROL
	.WORD	01108h			;>C00001A0 -- CONFIG

	.WORD	00h			;>C00001B0 -- DPYTAP
	.WORD	04h			;>C00001C0 -- VCOUNT
	.WORD	00h			;>C00001D0 -- HCOUNT
	.WORD	00h			;>C00001E0 -- DPYADR
	.WORD	00h			;>C00001F0 -- REFADR
		
	.WORD	00h			;>C0000200 -- REG200
	.WORD	00h			;>C0000210 -- REG210
	.WORD	00h			;>C0000220 -- REG220
	.WORD	00h			;>C0000230 -- REG230
	.WORD	1000h			;>C0000240 -- DINC
	.WORD	00h			;>C0000250 -- REG250
	.WORD	00h			;>C0000260 -- REG260
		
	.WORD	01D5h			;>C0000270 -- HESERR

	.else

INITDATA
	.word	02bh		;>C0000000 -- HESYNC
	.word	065h	;HEBLNKINIT	;>C0000010 -- HEBLNK
	.word	01f5h		;>C0000020 -- HSBLNK
	.word	01f9h		;>C0000030 -- HTOTAL
	.word	3		;>C0000040 -- VESYNC
	.word	20		;>C0000050 -- VEBLNK
	.word	274		;>C0000060 -- VSBLNK	;254 lines
	.word	288		;>C0000070 -- VTOTAL
	.word	0f010h		;>C0000080 -- DPYCTL	ENV|NIL|DXV|SRE|>10
;	.word	0fffch		;>C0000090 -- DPYSTRT
	.word	0000ch		;>C0000090 -- DPYSTRT
	.word	EOSINT		;>C00000A0 -- DPYINT 
	.word	2ch		;>C00000B0 -- CONTROL
	.word	0		;>C00000C0 -- HSTDATA
	.word	0		;>C00000D0 -- HSTADRL
	.word	0		;>C00000E0 -- HSTADRH
	.word	0		;>C00000F0 -- HSTCTLL
	.word	0		;>C0000100 -- HSTCTLH
	.word	0		;>C0000110 -- INTENBL
	.word	0		;>C0000120 -- INTPEND
	.word	0		;>C0000130 -- CONVSP
	.word	0		;>C0000140 -- CONVDP
	.word	PXSIZE		;>C0000150 -- PSIZE
	.word	0		;>C0000160 -- PMASK
	.word	0		;>C0000170 -- RESERVED
	.word	0		;>C0000180 -- RESERVED
	.word	0		;>C0000190 -- RESERVED
	.word	0		;>C00001A0 -- RESERVED
	.word	28		;>C00001B0 -- DPYTAP

	.endif


IDATALEN	EQU	$-INITDATA	;Bit length of I/O init table

*
*INITIALIZE ALL 32 TRAP VECTORS
*
	.SECT	"VECTORS"

	.if	XUNIT=1
;	.LONG	BADTRAP		;TRAP 31
;	.LONG	BADTRAP		;TRAP 30	ILLOP --- Illegal Opcode
;	.LONG	BADTRAP		;TRAP 29
;	.LONG	BADTRAP		;TRAP 28
;	.LONG	BADTRAP		;TRAP 27
;	.LONG	BADTRAP		;TRAP 26
;	.LONG	BADTRAP		;TRAP 25
;	.LONG	BADTRAP		;TRAP 24
;	.LONG	BADTRAP		;TRAP 23
;	.LONG	BADTRAP		;TRAP 22
;	.LONG	BADTRAP		;TRAP 21
;	.LONG	BADTRAP		;TRAP 20
;	.LONG	BADTRAP		;TRAP 19
;	.LONG	BADTRAP		;TRAP 18
;	.LONG	BADTRAP		;TRAP 17
;	.LONG	BADTRAP		;TRAP 16
	.else
	.LONG	BADTRAP		;TRAP 31
	.LONG	BADTRAP		;TRAP 30	ILLOP --- Illegal Opcode
	.LONG	BADTRAP		;TRAP 29
	.LONG	BADTRAP		;TRAP 28
	.LONG	BADTRAP		;TRAP 27
	.LONG	BADTRAP		;TRAP 26
	.LONG	BADTRAP		;TRAP 25
	.LONG	BADTRAP		;TRAP 24
	.LONG	BADTRAP		;TRAP 23
	.LONG	BADTRAP		;TRAP 22
	.LONG	BADTRAP		;TRAP 21
	.LONG	BADTRAP		;TRAP 20
	.LONG	BADTRAP		;TRAP 19
	.LONG	BADTRAP		;TRAP 18
	.LONG	BADTRAP		;TRAP 17
	.LONG	BADTRAP		;TRAP 16
	.endif

	.LONG	BADTRAP		;TRAP 15
	.LONG	BADTRAP		;TRAP 14
	.LONG	BADTRAP		;TRAP 13
	.LONG	BADTRAP		;TRAP 12
	.LONG	BADTRAP		;TRAP 11	WV --- Window Violation
	.LONG	DIRQ		;TRAP 10	DI --- Display Interrupt
	.LONG	BADTRAP		;TRAP 9		HI --- Host Interrupt
	.LONG	BADTRAP		;TRAP 8		NMI -- NonMaskable Interrupt
	.LONG	BADTRAP		;TRAP 7
	.LONG	BADTRAP		;TRAP 6
	.LONG	BADTRAP		;TRAP 5
	.LONG	BADTRAP		;TRAP 4
	.LONG	BADTRAP		;TRAP 3
	.LONG	LINT2_SERVICE	;TRAP 2		INT2 --- External Interrupt 2
	.LONG	DMAINT		;TRAP 1		INT1 --- External Interrupt 1
	.LONG	POWERUP		;TRAP 0		Reset
