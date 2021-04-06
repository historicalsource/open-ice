* GBLOCK - get player block
*  USAGE - GLBOCK rega regb
*  get player rega block in regb - ie. GBLOCK a0,a6
GBLOCK	.macro	PA,PB
	.if	':PA:' != ':PB:'
	move	PA,PB
	.endif
;	.if	DEBUG
;	jrp	gg?
;	calla	DUMPPRINT
;gg?	cmpi	8,PA
;	jrls	gh?
;	calla	DUMPPRINT
;	.endif
gh?	sll	PLAYER_BLOCK_BSIZE,PB
	addi	PLAYER_1_BLOCK-PLAYER_BLOCK_SIZE,PB
	.endm

