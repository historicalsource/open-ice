	.FILE "imgtbl.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

NAMEBAR1:
	.word   06000H,88,16
	.long   00H
	.word   0,0
	.long   NAMEBARP
GRNTRBO1:
	.word   02000H,72,6
	.long   02100H
	.word   0,0
	.long   GRYTRBOP
CYCLEBX1:
	.word   03000H,17,15
	.long   02460H
	.word   0,0
	.long   CYCLEBXP
puck1:
	.word   02000H,8,6
	.long   0275dH
	.word   3,2
	.long   pkpl
puck1a:
	.word   02000H,8,6
	.long   027bdH
	.word   3,2
	.long   pkpl
puck1b:
	.word   02000H,8,6
	.long   0281dH
	.word   3,2
	.long   pkpl
puck1c:
	.word   01000H,8,6
	.long   0287dH
	.word   3,2
	.long   pkpl
puck1d:
	.word   02000H,8,6
	.long   028adH
	.word   3,2
	.long   pkshd
puck2a:
	.word   03000H,8,6
	.long   0290dH
	.word   3,2
	.long   xxp
puck2b:
	.word   03000H,8,6
	.long   0299dH
	.word   3,2
	.long   xxp3
puck2c:
	.word   03000H,8,6
	.long   02a2dH
	.word   3,2
	.long   xxp4
puck2d:
	.word   03000H,8,6
	.long   02abdH
	.word   3,2
	.long   xxp5
puck2e:
	.word   03000H,8,6
	.long   02b4dH
	.word   3,2
	.long   xxp2
puck2f:
	.word   03000H,8,6
	.long   02bddH
	.word   3,2
	.long   xxp
puck2g:
	.word   03000H,8,6
	.long   02c6dH
	.word   3,2
	.long   xxp
shadow1:
	.word   01000H,60,10
	.long   02cfdH
	.word   29,4
	.long   shad_p
shadow2:
	.word   01000H,56,8
	.long   02f55H
	.word   27,3
	.long   shad_p
shadow3:
	.word   01000H,52,8
	.long   03115H
	.word   25,3
	.long   shad_p
shadow4:
	.word   01000H,50,8
	.long   032b5H
	.word   24,3
	.long   shad_p
shadow5:
	.word   01000H,48,8
	.long   03445H
	.word   23,3
	.long   shad_p
shadow6:
	.word   01000H,46,8
	.long   035c5H
	.word   22,3
	.long   shad_p
shadow7:
	.word   01000H,44,7
	.long   03735H
	.word   21,2
	.long   shad_p
shadow8:
	.word   01000H,45,6
	.long   03869H
	.word   22,2
	.long   shad_p
shadow9:
	.word   01000H,41,6
	.long   03977H
	.word   18,2
	.long   shad_p
shadow10:
	.word   01000H,39,6
	.long   03a6dH
	.word   19,2
	.long   shad_p
shadow11:
	.word   01000H,37,6
	.long   03b57H
	.word   20,2
	.long   shad_p
shadow12:
	.word   01000H,33,6
	.long   03c35H
	.word   20,2
	.long   shad_p
shadow13:
	.word   01000H,30,6
	.long   03cfbH
	.word   15,2
	.long   shad_p
shadow14:
	.word   01000H,28,6
	.long   03dafH
	.word   14,2
	.long   shad_p
shadow15:
	.word   01000H,26,6
	.long   03e57H
	.word   13,2
	.long   shad_p
shadow16:
	.word   01000H,24,6
	.long   03ef3H
	.word   11,2
	.long   shad_p
shadow17:
	.word   01000H,22,6
	.long   03f83H
	.word   10,2
	.long   shad_p
shadow18:
	.word   01000H,20,6
	.long   04007H
	.word   9,2
	.long   shad_p
PLYRBOX:
	.word   05000H,88,95
	.long   0407fH
	.word   0,0
	.long   PLYRBXP
PCKTRI01:
	.word   04000H,17,17
	.long   0e3c7H
	.word   0,0
	.long   TRI
G01:
	.word   01000H,6,9
	.long   0e84bH
	.word   -2,0
	.long   GNUMS
G02:
	.word   01000H,10,9
	.long   0e881H
	.word   0,0
	.long   GNUMS
G03:
	.word   01000H,10,9
	.long   0e8dbH
	.word   0,0
	.long   GNUMS
G04:
	.word   01000H,10,9
	.long   0e935H
	.word   0,0
	.long   GNUMS
G05:
	.word   01000H,10,9
	.long   0e98fH
	.word   0,0
	.long   GNUMS
G06:
	.word   01000H,10,9
	.long   0e9e9H
	.word   0,0
	.long   GNUMS
G07:
	.word   01000H,10,9
	.long   0ea43H
	.word   0,0
	.long   GNUMS
G08:
	.word   01000H,10,9
	.long   0ea9dH
	.word   0,0
	.long   GNUMS
G09:
	.word   01000H,10,9
	.long   0eaf7H
	.word   0,0
	.long   GNUMS
G00:
	.word   01000H,10,9
	.long   0eb51H
	.word   0,0
	.long   GNUMS
PPLAYER:
	.word   02000H,11,60
	.long   0ebabH
	.word   0,0
	.long   PLAYERP
GOALTND:
	.word   02000H,20,61
	.long   0f0d3H
	.word   5,0
	.long   PLAYERP
PLYRBCK:
	.word   05000H,71,65
	.long   0fa5bH
	.word   0,0
	.long   PLYRBCKP
GOALS:
	.word   01000H,44,9
	.long   01547eH
	.word   0,0
	.long   POSITP
CYCLEGL3:
	.word   04000H,25,17
	.long   01560aH
	.word   0,0
	.long   CYCLEGLP3
BLACKHIT:
	.word   04000H,118,10
	.long   0100ceaH
	.word   59,0
	.long   TEAMITL1P
BLCKHWK2:
	.word   07000H,67,59
	.long   0101f5aH
	.word   32,28
	.long   BLCKHWK2P
M_CHELIOS:
	.word   00H,71,61
	.long   0108b71H
	.word   33,59
	.long   CHELIOS1P
M_ROENICK:
	.word   00H,78,60
	.long   01112c9H
	.word   38,58
	.long   ROENICK1P
CHELIOS1:
	.word   02000H,52,8
	.long   011a509H
	.word   25,3
	.long   LSTNME1P
ROENICK1:
	.word   02000H,52,8
	.long   011a849H
	.word   25,3
	.long   LSTNME1P