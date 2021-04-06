**************************************************************************
*								         *
* LOCKDIR locks if register isn't 1-8					 *
*								         *
**************************************************************************
LOCKDIR	.macro	rg
	move	:rg:,:rg:
	jrz	lcd?
	cmpi	8,:rg:
	jrls	nlcd?
lcd?	CALLA	DUMPPRINT
nlcd?
	.endm
