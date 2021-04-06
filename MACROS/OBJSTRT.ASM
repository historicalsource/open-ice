*	OBJSTRT frame,blipimg
*	An object is stuffed with the proper frame and blip image
*	Coordinates are updated, velocity is cleared
*		>A0,A14 trashed
OBJSTRT	.macro	frame,blipimg
	MOVI	:frame:,a1		; use specified frame
	MOVE	a8,a0
	CALLA	FPSTFOBJ		; find pallette, stuff object
	CALLA	InitCoor		; initialize coors from a9 [y:x]
	MOVI	:blipimg:,A14
	MOVE	a14,*a8(OBLIPIMG),L
	CALLA	ClrVel			; Clear velocities
	MOVI	ShipZ*>10000,A14	; Z Coordinate - Assume Ship
	MOVE	a14,*a8(OZVAL),L
	.endm

