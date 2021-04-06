*	NULPTR	reg,addr, field size
*	If the register is pointing to a long 0 then
*	jump to addr
NULPTR	.macro	reg,addr,fs
	MOVE	*:reg:,a14,:fs:
	JRZ	:addr:
	.endm

