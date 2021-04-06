 	.MLIB	"HHMACS.LIB"
	.FILE	"HHATTRCT.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*
	.INCLUDE	"HH.INC"
	.INCLUDE	"HHSTRING.H"
	.INCLUDE	"IMGTBL.GLO"
	.include	"logos.tbl"
	.include	"dummy2.tbl"
	.include	"hhattrct.e"
	.include	"hhproc.g"
	.include	"hhd.g"
	.include	"hhram.g"
	.include	"hhsnd.g"

; end of include files

	.TEXT
	.EVEN

ATTRACT_MODE
	SLEEP	10
	calla	set_attract_tune
	movi	0110111101111011b,a0
	move	a0,@IRQSKYE,W

am_1	movi	bx_list,a10
am_2	move	*a10+,a14,L
	jrz	am_1
	move	a14,b0
	calla	EASYMAKE
	SLEEP	7
	calla	DELETE_OBJ
	jruc	am_2

bx_list
;	.long	colorbar_init
	.long	BREW_init
	.long	BUFF_init
	.long	CAL_init
	.long	DETROIT_init
	.long	DEVILS_init
	.long	DUCKS_init
	.long	HAWKS_init
	.long	ISLANDE_init
	.long	JETS_init
	.long	NHLPA_init
	.long	OILER_init
	.long	OTTOWA_init
	.long	PANTHER_init
	.long	PENGUIN_init
	.long	PHILI_init
	.long	RANGER_init
	.long	STARS_init
	.long	STLOU_init
	.long	WHALER_init
	.long	canucks_init
	.long	tampa_init
	.long	nordiq_init
	.long	canada_init
	.long	sharks_init
	.long	toronto_init
	.long	kings_init
	.long	capital_init
;	.long	nhl_init
	.long	0

colorbar_init
	.long	COLORTST_vda
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[30,0],[27,0],[0,0]

BREW_init
	.long	BREW
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]

BUFF_init
	.long	BUFF
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
CAL_init
	.long	CAL
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
DETROIT_init
	.long	DETROIT
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
DEVILS_init
	.long	DEVILS
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
DUCKS_init
	.long	DUCKS
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
HAWKS_init
	.long	HAWKS
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
ISLANDE_init
	.long	ISLANDE
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
JETS_init
	.long	JETS
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
NHLPA_init
	.long	NHLPA
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
OILER_init
	.long	OILER
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
OTTOWA_init
	.long	OTTOWA
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
PANTHER_init
	.long	PANTHER
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
PENGUIN_init
	.long	PENGUIN
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
PHILI_init
	.long	PHILI
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
RANGER_init
	.long	RANGER
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
STARS_init
	.long	STARS
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
STLOU_init
	.long	STLOU
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
WHALER_init
	.long	WHALER
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
canucks_init
	.long	canucks
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
tampa_init
	.long	tampa
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
nordiq_init
	.long	nordiq
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
canada_init
	.long	canada
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
sharks_init
	.long	sharks
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
toronto_init
	.long	toronto
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
kings_init
	.long	kings
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
capital_init
	.long	capital
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]

nhl_init
	.long	nhl
	.word	DMAWNZ,M_SCRNOBJ|M_MANSCALE
	.word	OM_OID|OM_POS|OM_INSERT
	.word	OID_LOGO
	.long	[200,0],[127,0],[0,0]
