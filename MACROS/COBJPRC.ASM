*	COBJPRC	label,id,ra10pass
*	Will call OBJPRC with setup label, ID, and parameter in A10
COBJPRC	.macro	label,id,ra10
	movi	:label:,a7
	movi	:id:,a1
	movi	:ra10:,a10
	calla	OBJPRC
	.endm

