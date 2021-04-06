	.MLIB	"HHMACS.LIB"
	.FILE	"HHSTABLE.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*

	.INCLUDE	"HH.INC"
	.include	"HHPPALS.H"
	.include	"HHHPALS.H"
	.include	"HHBPALS.H"
	.INCLUDE	"IMGTBL.GLO"
	.INCLUDE	"HHSELECT.TBL"
	.INCLUDE	"HHSELCT2.TBL"
	.INCLUDE	"ALTLOGOS.TBL"
	.INCLUDE	"SCREEN.TBL"
	.include	"flashes.tbl"
	.include	"hhstable.e"
	.include	"hhtables.g"
	.include	"hhcontrl.g"
		
; end of include files

;	.long	logo1,alt team logo image (anaheim)
;	.long	 member_1_list,member_2_list
;	.long	 away_uniform_pal,away_uniform_goalie_pal
;	.long	 home_uniform_pal,home_uniform_goalie_pal
;	.long	 home_p1_turbo_pal,home_p2_turbo_pal
;	.long	 home_p3_turbo_pal,home_p4_turbo_pal
;	.long	 away_p1_turbo_pal,away_p2_turbo_pal
;	.long	 away_p3_turbo_pal,away_p4_turbo_pal
;	.long	 long_name_init
;	.long	 goalie_list
;	.LONG	 TEAM NAME IMAGE, TEAM LOGO IMAGE
;	.word	 home_helmet_palette_offset,away_helmet_palette_offset
;	.word	 goalie_helmet_palette_offset,0
;	.LONG	 CITY NAME IMAGE, CITY NAME STRING, BIG GOALIE HELMET PALETTE
;	.LONG	 TEAM NICKNAME
;	.word	 video clip primary pal, video clip secondary pal
;	.long	 away_bench_palette,home_bench_palette

new_colorado_team
	.long	QUE,0
	.long	 colorado_list,colorado2_list
	.long	 AVALa1,GAVALAa1
	.long	 AVALh1,GAVALAh1
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 QUEBEC
	.long	 colorado_glist
	.long	 NORDIQIT,COLORAD1		;QUEBEC1
	.word	 0,7,26,0
	.long	 QUEBECIT,COLO_STR,BCOLOmsk1,COLO_NICK_STR
	.word	 4,5
	.long	 BAVALa2,BAVALh2,AVALANC2,0,0


team_data
	.long	BOS,0			;boston is default on 0 (it's really 1)
	.long	 boston_list,boston_list
	.long	 BRUINSa,GBRUINSa
	.long	 BRUINSh,GBRUINSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 BOSTON
	.long	 boston_glist
	.long	 BRUINSIT,BOSTON1
	.word	 0,1,15,0
	.long	 BOSTONIT,BOST_STR,BBOSTmsk1,BOST_NICK_STR
	.word	 3,3
	.long	 BBRUINSa2,BBRUINSh2,0,0,0

	.long	BOS,0
	.long	 boston_list,boston2_list
	.long	 BRUINSa,GBRUINSa
	.long	 BRUINSh,GBRUINSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 BOSTON
	.long	 boston_glist
	.long	 BRUINSIT,BOSTON1
	.word	 0,1,15,0
	.long	 BOSTONIT,BOST_STR,BBOSTmsk1,BOST_NICK_STR
	.word	 3,3
	.long	 BBRUINSa2,BBRUINSh2,0,0,0
	.long	BUF,0
	.long	 buffalo_list,buffalo2_list
	.long	 SABERSa,GSABERSa
	.long	 SABERSh,GSABERSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 BUFFAL
	.long	 buffalo_glist
	.long	 SABRESIT,BUFFALO1
	.word	 0,5,17,0
	.long	 BUFFALOIT,BUFF_STR,BBUFFmsk1,BUFF_NICK_STR
	.word	 4,3
	.long	 BSABRSa2,BSABRSh2,0,0,0
	.long	HAR,0
	.long	 hartford_list,hartford2_list
	.long	 WHALEa,GWHALEa
	.long	 WHALEh,GWHALEh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 HRTFRD
	.long	 hartford_glist
	.long	 WHALERIT,HARTFOR1
	.word	 0,6,14,0
	.long	 HARTFORDIT,HART_STR,BHARTmsk1,HART_NICK_STR
	.word	 4,1
	.long	 BWHALEa2,BWHALEh2,0,0,0
	.long	MON,0
	.long	 montreal_list,montreal2_list
	.long	 PMONTa,GMONTa
	.long	 PMONTh,GMONTh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 MONTRL
	.long	 montreal_glist
	.long	 CANADIIT,MONTREA1
	.word	 0,5,16,0
	.long	 MONTREALIT,MONT_STR,BHABSmsk1,MONT_NICK_STR
	.word	 5,4
	.long	 BMONTa2,BMONTh2,0,0,0
	.long	OTT,0
	.long	 ottawa_list,ottawa2_list
	.long	 SENATRSa,GSENATa
	.long	 SENATRSh,GSENATh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 OTTAWA
	.long	 ottawa_glist
	.long	 SENATOIT,OTTAWA1
	.word	 0,1,13,0
	.long	 OTTAWAIT,OTTA_STR,BSENAmsk1,OTTA_NICK_STR
	.word	 6,5
	.long	 BOTTAa2,BOTTAh2,0,0,0
	.long	PIT,0
	.long	 pittsburgh_list,pittsburgh2_list
	.long	 PPITTa,GPITTa
	.long	 PPITTh,GPITTh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 PITBRG
	.long	 pittsburgh_glist
	.long	 PENGUIIT,PITSBRG1
	.word	 0,1,3,0
	.long	 PITTSBRGIT,PITT_STR,BPITTmsk1,PITT_NICK_STR
	.word	 3,3
	.long	 BPITTa2,BPITTh2,0,0,0
	.long	QUE,0
	.long	 colorado_list,colorado2_list
	.long	 NORDIQa,GNORDIQa
	.long	 NORDIQh,GNORDIQh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 QUEBEC
	.long	 colorado_glist
	.long	 NORDIQIT,COLORAD1		;QUEBEC1
	.word	 0,4,18,0			;alternate is 0,7
	.long	 QUEBECIT,COLO_STR,BCOLOmsk1,COLO_NICK_STR
	.word	 4,5
	.long	 BCOLORa2,BCOLORh2,0,0,0
	.long	FLO,0
	.long	 florida_list,florida2_list
	.long	 PANTHa,GPANTHa
	.long	 PANTHh,GPANTHh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 FLORID
	.long	 florida_glist
	.long	 PANTHEIT,FLORIDA1
	.word	 0,6,5,0
	.long	 FLORIDAIT,FLOR_STR,BFLORmsk1,FLOR_NICK_STR
	.word	 3,5
	.long	 BPANTHa2,BPANTHh2,0,0,0
	.long	NJR,0
	.long	 newjersey_list,newjersey2_list
	.long	 DEVILa,GNJDVLa
	.long	 DEVILh,GNJDVLh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 NEWJER
	.long	 newjersey_glist
	.long	 DEVILSIT,NEWJER1
	.word	 0,1,9,0
	.long	 NEWJERSIT,NJER_STR,BNJYmsk1,NJER_NICK_STR
	.word	 5,0
	.long	 BNJERZYa2,BNJERZYh2,0,0,0
	.long	NYI,0
	.long	 nyislanders_list,nyislanders2_list
	.long	 ISLANDRa,GISLANDRa
	.long	 ISLANDRh,GISLANDRh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 NYISLD
	.long	 nyislanders_glist
	.long	 ISLANDIT,NWYRKIS1
	.word	 0,5,6,0
	.long	 NEWYORKIT,NYIS_STR,BISLEmsk1,NYIS_NICK_STR
	.word	 5,0
	.long	 BISLESa2,BISLESh2,0,0,0
	.long	NYR,0
	.long	 nyrangers_list,nyrangers2_list
	.long	 RANGRa,GRANGRa
	.long	 RANGRh,GRANGRh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 NYRANG
	.long	 nyrangers_glist
	.long	 RANGERIT,NWYRKRA1
	.word	 0,5,10,0
	.long	 NEWYORKIT,NYRA_STR,BNYRmsk1,NYRA_NICK_STR
	.word	 4,5
	.long	 BRANGRa2,BRANGRh2,0,0,0
	.long	PHI,0
	.long	 philadelphia_list,philadelphia2_list
	.long	 FLYERSa,GFLYERSa
	.long	 FLYERSh,GFLYERSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 PHILAD
	.long	 philadelphia_glist
	.long	 FLYERSIT,PHILADE1
	.word	 0,1,7,0
	.long	 PHILADELIT,PHIL_STR,BFLYRmsk1,PHIL_NICK_STR
	.word	 7,7
	.long	 BFLYERSa2,BFLYERSh2,0,0,0
	.long	TAM,0
	.long	 tampabay_list,tampabay2_list
	.long	 LIGHTa,GLIGHTa
	.long	 LIGHTh,GLIGHTh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 TAMPAB
	.long	 tampabay_glist
	.long	 LIGHTNIT,TAMPA1
	.word	 0,1,4,0
	.long	 TAMPABAYIT,TBAY_STR,BTAMPmsk1,TBAY_NICK_STR
	.word	 4,0
	.long	 BLIGHTa2,BLIGHTh2,0,0,0
	.long	WAS,0
	.long	 washington_list,washington2_list
	.long	 NCAPSa,GWASH2a
	.long	 NCAPSh,GWASH2h
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 WASHTN
	.long	 washington_glist
	.long	 CAPITAIT,WASHING1
	.word	 0,7,8,0
	.long	 WASHINGTIT,WASH_STR,BWASHmsk1,WASH_NICK_STR
	.word	 4,6
	.long	 BCAPSa2,BCAPSh2,0,0,0
	.long	CHI,0
	.long	 chicago_list,chicago2_list
	.long	 phawka,GHAWKa
	.long	 PHAWKh,GHAWKh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 CHICAG
	.long	 chicago_glist
	.long	 BLACKHIT,BLCKHWK2
	.word	 0,1,0,0
	.long	 CHICAGOIT,CHIC_STR,BHAWKmsk1,CHIC_NICK_STR
	.word	 5,7
	.long	 BHAWKa2,BHAWKh2,0,0,0
	.long	DAL,0
	.long	 dallas_list,dallas2_list
	.long	 STARSa,GSTARSa
	.long	 STARSh,GSTARSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 DALLAS
	.long	 dallas_glist
	.long	 STARSIT,DALLAS1
	.word	 0,1,24,0
	.long	 DALLASIT,DALL_STR,BDALLmsk1,DALL_NICK_STR
	.word	 1,6
	.long	 BSTARSa2,BSTARSh2,0,0,0
	.long	DET,0
	.long	 detroit_list,detroit2_list
	.long	 PWINGa,GWINGa
	.long	 PWINGh,GWINGh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 DETROT
	.long	 detroit_glist
	.long	 REDWINIT,DETROIT1
	.word	 0,2,1,0
;	.word	 0,2,27,0
	.long	 DETROITIT,DETR_STR,BWNGSmsk1,DETR_NICK_STR
	.word	 5,0
	.long	 BDETROIa2,BDETROIh2,0,0,0
	.long	STL,0
	.long	 stlouis_list,stlouis2_list
	.long	 BLUESa,GBLUESa
	.long	 BLUESh,GBLUESh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 STLOUS
	.long	 stlouis_glist
	.long	 BLUESIT,STLOUIS1
	.word	 0,5,11,0
	.long	 STLOUISIT,STLO_STR,BSTLmsk1,STLO_NICK_STR
	.word	 4,7
	.long	 BSTLOUa2,BSTLOUh2,0,0,0
	.long	TOR,0
	.long	 toronto_list,toronto2_list
	.long	 LEAFSa,GLEAFSa
	.long	 LEAFSh,GLEAFSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 TORONT
	.long	 toronto_glist
	.long	 MAPLELIT,TORONTO1
	.word	 0,5,12,0
	.long	 TOR0NTOIT,TORO_STR,BTOROmsk1,TORO_NICK_STR
	.word	 4,4
	.long	 BTORONTa2,BTORONTh2,0,0,0
	.long	WNP,0
	.long	 winnipeg_list,winnipeg2_list
	.long	 JETSa,GJETSa
	.long	 JETSh,GJETSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 WINNIP
	.long	 winnipeg_glist
	.long	 JETSIT,WINNIPEG
	.word	 0,5,25,0
	.long	 WINNIPEGIT,WINN_STR,BJETSmsk1,WINN_NICK_STR
	.word	 5,4
	.long	 BWINNAa2,BWINNAh2,0,0,0
	.long	ANA,DUCKSLOGO2
	.long	 anaheim_list,anaheim2_list
	.long	 DUCKSa,GDUCKSa
	.long	 DUCKSh,GDUCKSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 ANAHEM
	.long	 anaheim_glist
	.long	 MIGHTYIT,ANAHEIM1
	.word	 0,3,20,0
	.long	 ANAHEIMIT,ANAH_STR,BDUCKmsk1,ANAH_NICK_STR
	.word	 2,1
	.long	 BANAHEIa2,BANAHEIh2,0,0,0
	.long	CAL,0
	.long	 calgary_list,calgary2_list
	.long	 FLAMESa,GFLAMESa
	.long	 FLAMESh,GFLAMESh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 CALGAR
	.long	 calgary_glist
	.long	 FLAMESIT,CALGARY1
	.word	 0,2,22,0
	.long	 CALGARYIT,CALG_STR,BCALGmsk1,CALG_NICK_STR
	.word	 5,3
	.long	 BCALGa2,BCALGh2,0,0,0
	.long	EDM,0
	.long	 edmonton_list,edmonton2_list
	.long	 OILERSa,GOILERSa
	.long	 OILERSh,GOILERSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 EDMONT
	.long	 edmonton_glist
	.long	 OILERSIT,EDMONTO1
	.word	 0,5,19,0
	.long	 EDMONTONIT,EDMO_STR,BOILmsk1,EDMO_NICK_STR
	.word	 4,7
	.long	 BEDMOa2,BEDMOh2,0,0,0
	.long	LOS,0
	.long	 losangeles_list,losangeles2_list
	.long	 KINGSa,GKINGSa
	.long	 KINGSh,GKINGSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 LOSANG
	.long	 losangeles_glist
	.long	 KINGSIT,KINGS3
	.word	 0,1,21,0
	.long	 LOSANGELIT,LANG_STR,BLOSAmsk1,LANG_NICK_STR
	.word	 0,0
	.long	 BLOSAa2,BLOSAh2,0,0,0
	.long	SAN,0
	.long	 sanjose_list,sanjose2_list
	.long	 SHARKSa,GSHARKSa
	.long	 SHARKSh,GSHARKSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SANJOS
	.long	 sanjose_glist
	.long	 SHARKSIT,SANJOSE1
	.word	 0,1,2,0
	.long	 SANJOSEIT,SJOS_STR,BSHRKmsk1,SJOS_NICK_STR
	.word	 2,0
	.long	 BSANJOa2,BSANJOh2,0,0,0
	.long	VAN,0
	.long	 vancouver_list,vancouver2_list
	.long	 CANUCKa,GCANUCKa
	.long	 CANUCKh,GCANUCKh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 VANCOV
	.long	 vancouver_glist
	.long	 CANUCKIT,VANCOU5
	.word	 0,1,23,0
	.long	 VANCOUVERIT,VANC_STR,BCANUmsk1,VANC_NICK_STR
	.word	 3,5
	.long	 BVANCa2,BVANCh2,0,0,0

	.long	SPCT,0
	.long	 special01_list,non_list
	.long	 ISLANDRa,GISLANDRa
	.long	 ISLANDRh,GISLANDRh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special01_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BISLESa2,BISLESh2,0,0,0
	.long	SPCT,0
	.long	 special02_list,non_list
	.long	 PWINGa,GWINGa
	.long	 PWINGh,GWINGh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special02_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BDETROIa2,BDETROIh2,0,0,0
	.long	SPCT,0
	.long	 special03_list,non_list
	.long	 WHALEa,GWHALEa
	.long	 WHALEh,GWHALEh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special03_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BWHALEa2,BWHALEh2,0,0,0
	.long	SPCT,0
	.long	 special04_list,non_list
	.long	 PPITTa,GPITTa
	.long	 PPITTh,GPITTh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special04_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BPITTa2,BPITTh2,0,0,0
	.long	SPCT,0
	.long	 special05_list,non_list
	.long	 BRUINSa,GBRUINSa
	.long	 BRUINSh,GBRUINSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special05_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BBRUINSa2,BBRUINSh2,0,0,0
	.long	SPCT,0
	.long	 special06_list,non_list
	.long	 LIGHTa,GLIGHTa
	.long	 LIGHTh,GLIGHTh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special06_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BLIGHTa2,BLIGHTh2,0,0,0
	.long	SPCT,0
	.long	 special07_list,non_list
	.long	 JETSa,GJETSa
	.long	 JETSh,GJETSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special07_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BWINNAa2,BWINNAh2,0,0,0
	.long	SPCT,0
	.long	 special08_list,non_list
	.long	 CANUCKa,GCANUCKa
	.long	 CANUCKh,GCANUCKh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special08_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BVANCa2,BVANCh2,0,0,0
	.long	SPCT,0
	.long	 special09_list,non_list
	.long	 OILERSa,GOILERSa
	.long	 OILERSh,GOILERSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special09_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BEDMOa2,BEDMOh2,0,0,0
	.long	SPCT,0
	.long	 special10_list,non_list
	.long	 SABERSa,GSABERSa
	.long	 SABERSh,GSABERSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special10_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BSABRSa2,BSABRSh2,0,0,0
	.long	SPCT,0
	.long	 special11_list,non_list
	.long	 DEVILa,GNJDVLa
	.long	 DEVILh,GNJDVLh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special11_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BNJERZYa2,BNJERZYh2,0,0,0
	.long	SPCT,0
	.long	 special12_list,non_list
	.long	 AVALa1,GAVALAa1
	.long	 AVALh1,GAVALAh1
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special12_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BCOLORa2,BCOLORh2,0,0,0
	.long	SPCT,0
	.long	 special13_list,non_list
	.long	 NCAPSa,GWASH2a
	.long	 NCAPSh,GWASH2h
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special13_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BCAPSa2,BCAPSh2,0,0,0
	.long	SPCT,0
	.long	 special14_list,non_list
	.long	 BLUESa,GBLUESa
	.long	 BLUESh,GBLUESh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special14_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BSTLOUa2,BSTLOUh2,0,0,0
	.long	SPCT,0
	.long	 special15_list,non_list
	.long	 LEAFSa,GLEAFSa
	.long	 LEAFSh,GLEAFSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special15_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BTORONTa2,BTORONTh2,0,0,0
	.long	SPCT,0
	.long	 special16_list,non_list
	.long	 KINGSa,GKINGSa
	.long	 KINGSh,GKINGSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special16_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BLOSAa2,BLOSAh2,0,0,0
	.long	SPCT,0
	.long	 special17_list,non_list
	.long	 FLAMESa,GFLAMESa
	.long	 FLAMESh,GFLAMESh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special17_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BCALGa2,BCALGh2,0,0,0
	.long	SPCT,0
	.long	 special18_list,non_list
	.long	 STARSa,GSTARSa
	.long	 STARSh,GSTARSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special18_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BSTARSa2,BSTARSh2,0,0,0
	.long	SPCT,0
	.long	 special19_list,non_list
	.long	 RANGRa,GRANGRa
	.long	 RANGRh,GRANGRh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special19_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BRANGRa2,BRANGRh2,0,0,0
	.long	SPCT,0
	.long	 special20_list,non_list
	.long	 PMONTa,GMONTa
	.long	 PMONTh,GMONTh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special20_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BMONTa2,BMONTh2,0,0,0
	.long	SPCT,0
	.long	 special21_list,non_list
	.long	 FLYERSa,GFLYERSa
	.long	 FLYERSh,GFLYERSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special21_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BFLYERSa2,BFLYERSh2,0,0,0
	.long	SPCT,0
	.long	 special22_list,non_list
	.long	 phawka,GHAWKa
	.long	 PHAWKh,GHAWKh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special22_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BHAWKa2,BHAWKh2,0,0,0
	.long	SPCT,0
	.long	 special23_list,non_list
	.long	 DUCKSa,GDUCKSa
	.long	 DUCKSh,GDUCKSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special23_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BANAHEIa2,BANAHEIh2,0,0,0
	.long	SPCT,0
	.long	 special24_list,non_list
	.long	 PANTHa,GPANTHa
	.long	 PANTHh,GPANTHh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special24_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BPANTHa2,BPANTHh2,0,0,0
	.long	SPCT,0
	.long	 special25_list,non_list
	.long	 SENATRSa,GSENATa
	.long	 SENATRSh,GSENATh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special25_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BOTTAa2,BOTTAh2,0,0,0
	.long	SPCT,0
	.long	 special26_list,non_list
	.long	 SHARKSa,GSHARKSa
	.long	 SHARKSh,GSHARKSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special26_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BSANJOa2,BSANJOh2,0,0,0
	.long	SPCT,0
	.long	 special27_list,non_list
	.long	 ISLANDRa,GISLANDRa
	.long	 ISLANDRh,GISLANDRh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special27_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BISLESa2,BISLESh2,0,0,0
	.long	SPCT,0
	.long	 special28_list,non_list
	.long	 PWINGa,GWINGa
	.long	 PWINGh,GWINGh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special28_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BDETROIa2,BDETROIh2,0,0,0
	.long	SPCT,0
	.long	 special29_list,non_list
	.long	 WHALEa,GWHALEa
	.long	 WHALEh,GWHALEh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special29_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BWHALEa2,BWHALEh2,0,0,0
	.long	SPCT,0
	.long	 special30_list,non_list
	.long	 PPITTa,GPITTa
	.long	 PPITTh,GPITTh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special30_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BPITTa2,BPITTh2,0,0,0
	.long	SPCT,0
	.long	 special31_list,non_list
	.long	 BRUINSa,GBRUINSa
	.long	 BRUINSh,GBRUINSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special31_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BBRUINSa2,BBRUINSh2,0,0,0
	.long	SPCT,0
	.long	 special32_list,non_list
	.long	 LIGHTa,GLIGHTa
	.long	 LIGHTh,GLIGHTh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special32_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BLIGHTa2,BLIGHTh2,0,0,0
	.long	SPCT,0
	.long	 special33_list,non_list
	.long	 JETSa,GJETSa
	.long	 JETSh,GJETSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special33_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BWINNAa2,BWINNAh2,0,0,0
	.long	SPCT,0
	.long	 special34_list,non_list
	.long	 CANUCKa,GCANUCKa
	.long	 CANUCKh,GCANUCKh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special34_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BVANCa2,BVANCh2,0,0,0
	.long	SPCT,0
	.long	 special35_list,non_list
	.long	 OILERSa,GOILERSa
	.long	 OILERSh,GOILERSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special35_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BEDMOa2,BEDMOh2,0,0,0
	.long	SPCT,0
	.long	 special36_list,non_list
	.long	 SABERSa,GSABERSa
	.long	 SABERSh,GSABERSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special36_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BSABRSa2,BSABRSh2,0,0,0
	.long	SPCT,0
	.long	 special37_list,non_list
	.long	 DEVILa,GNJDVLa
	.long	 DEVILh,GNJDVLh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special37_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BNJERZYa2,BNJERZYh2,0,0,0
	.long	SPCT,0
	.long	 special38_list,non_list
	.long	 AVALa1,GAVALAa1
	.long	 AVALh1,GAVALAh1
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special38_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BCOLORa2,BCOLORh2,0,0,0
	.long	SPCT,0
	.long	 special39_list,non_list
	.long	 NCAPSa,GWASH2a
	.long	 NCAPSh,GWASH2h
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special39_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BCAPSa2,BCAPSh2,0,0,0
	.long	SPCT,0
	.long	 special40_list,non_list
	.long	 BLUESa,GBLUESa
	.long	 BLUESh,GBLUESh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special40_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BSTLOUa2,BSTLOUh2,0,0,0
	.long	SPCT,0
	.long	 special41_list,non_list
	.long	 LEAFSa,GLEAFSa
	.long	 LEAFSh,GLEAFSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special41_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BTORONTa2,BTORONTh2,0,0,0
	.long	SPCT,0
	.long	 special42_list,non_list
	.long	 KINGSa,GKINGSa
	.long	 KINGSh,GKINGSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special42_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BLOSAa2,BLOSAh2,0,0,0
	.long	SPCT,0
	.long	 special43_list,non_list
	.long	 FLAMESa,GFLAMESa
	.long	 FLAMESh,GFLAMESh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special43_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BCALGa2,BCALGh2,0,0,0
	.long	SPCT,0
	.long	 special44_list,non_list
	.long	 STARSa,GSTARSa
	.long	 STARSh,GSTARSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special44_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BSTARSa2,BSTARSh2,0,0,0
	.long	SPCT,0
	.long	 special45_list,non_list
	.long	 RANGRa,GRANGRa
	.long	 RANGRh,GRANGRh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special45_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BRANGRa2,BRANGRh2,0,0,0
	.long	SPCT,0
	.long	 special46_list,non_list
	.long	 PMONTa,GMONTa
	.long	 PMONTh,GMONTh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special46_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BMONTa2,BMONTh2,0,0,0
	.long	SPCT,0
	.long	 special47_list,non_list
	.long	 FLYERSa,GFLYERSa
	.long	 FLYERSh,GFLYERSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special47_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BFLYERSa2,BFLYERSh2,0,0,0
	.long	SPCT,0
	.long	 special48_list,non_list
	.long	 phawka,GHAWKa
	.long	 PHAWKh,GHAWKh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special48_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BHAWKa2,BHAWKh2,0,0,0
	.long	SPCT,0
	.long	 special49_list,non_list
	.long	 DUCKSa,GDUCKSa
	.long	 DUCKSh,GDUCKSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special49_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BANAHEIa2,BANAHEIh2,0,0,0
	.long	SPCT,0
	.long	 special50_list,non_list
	.long	 PANTHa,GPANTHa
	.long	 PANTHh,GPANTHh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special50_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BPANTHa2,BPANTHh2,0,0,0
	.long	SPCT,0
	.long	 special51_list,non_list
	.long	 SENATRSa,GSENATa
	.long	 SENATRSh,GSENATh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special51_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BOTTAa2,BOTTAh2,0,0,0
	.long	SPCT,0
	.long	 special52_list,non_list
	.long	 SHARKSa,GSHARKSa
	.long	 SHARKSh,GSHARKSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special52_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BSANJOa2,BSANJOh2,0,0,0
	.long	SPCT,0
	.long	 special53_list,non_list
	.long	 ISLANDRa,GISLANDRa
	.long	 ISLANDRh,GISLANDRh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special53_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BISLESa2,BISLESh2,0,0,0
	.long	SPCT,0
	.long	 special54_list,non_list
	.long	 PWINGa,GWINGa
	.long	 PWINGh,GWINGh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special54_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BDETROIa2,BDETROIh2,0,0,0
	.long	SPCT,0
	.long	 special55_list,non_list
	.long	 WHALEa,GWHALEa
	.long	 WHALEh,GWHALEh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special55_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BWHALEa2,BWHALEh2,0,0,0
	.long	SPCT,0
	.long	 special56_list,non_list
	.long	 PPITTa,GPITTa
	.long	 PPITTh,GPITTh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special56_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BPITTa2,BPITTh2,0,0,0
	.long	SPCT,0
	.long	 special57_list,non_list
	.long	 BRUINSa,GBRUINSa
	.long	 BRUINSh,GBRUINSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special57_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BBRUINSa2,BBRUINSh2,0,0,0
	.long	SPCT,0
	.long	 special58_list,non_list
	.long	 LIGHTa,GLIGHTa
	.long	 LIGHTh,GLIGHTh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special58_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BLIGHTa2,BLIGHTh2,0,0,0
	.long	SPCT,0
	.long	 special59_list,non_list
	.long	 JETSa,GJETSa
	.long	 JETSh,GJETSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special59_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BWINNAa2,BWINNAh2,0,0,0
	.long	SPCT,0
	.long	 special60_list,non_list
	.long	 CANUCKa,GCANUCKa
	.long	 CANUCKh,GCANUCKh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special60_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BVANCa2,BVANCh2,0,0,0
	.long	SPCT,0
	.long	 special61_list,non_list
	.long	 OILERSa,GOILERSa
	.long	 OILERSh,GOILERSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special61_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BEDMOa2,BEDMOh2,0,0,0
	.long	SPCT,0
	.long	 special62_list,non_list
	.long	 SABERSa,GSABERSa
	.long	 SABERSh,GSABERSh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special62_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BSABRSa2,BSABRSh2,0,0,0
	.long	SPCT,0
	.long	 special63_list,non_list
	.long	 DEVILa,GNJDVLa
	.long	 DEVILh,GNJDVLh
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special63_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BNJERZYa2,BNJERZYh2,0,0,0
	.long	SPCT,0
	.long	 special64_list,non_list
	.long	 AVALa1,GAVALAa1
	.long	 AVALh1,GAVALAh1
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special64_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BCOLORa2,BCOLORh2,0,0,0
	.long	SPCT,0
	.long	 special65_list,non_list
	.long	 NCAPSa,GWASH2a
	.long	 NCAPSh,GWASH2h
	.long	 PMONTaP2,PMONTaB2
	.long	 PMONTaY2,PMONTaG2
	.long	 PMONThP2,PMONThB2
	.long	 PMONThY2,PMONThG2
	.long	 SPECIALTM
	.long	 special65_glist
	.long	 SPECIALIT,blankit
	.word	 0,1,23,0
	.long	 blankit,SPEC_STR,BFLYRmsk1,SPEC_STR
	.word	 0,0
	.long	 BCAPSa2,BCAPSh2,0,0,0

blankit	.word   04000H,4,4
	.long   06011cdcH
	.word   800,800
	.long   GFONT10CP

SPEC_STR
	.string	"SP TEAM",0
	.even

special01_list
	.word	s_brett_hull
	.word	s_brendan_shanahan
	.word	s_jeremy_roenick
	.word	s_chris_chelios
	.word	0
special01_glist
	.word	s_ed_belfour
	.word	0

special02_list
	.word	s_mario_lemieux
	.word	s_eric_lindros
	.word	s_luc_robitaille
	.word	s_rod_brindamour
	.word	0
special02_glist
	.word	s_ron_hextall
	.word	0

special03_list
	.word	s_wayne_gretzky
	.word	s_mark_messier
	.word	s_jari_kurri
	.word	0
special03_glist
	.word	s_bill_ranford
	.word	0

special04_list
	.word	s_paul_coffey
	.word	s_ray_bourque
	.word	s_chris_chelios
	.word	s_scott_stevens
	.word	0
special04_glist
	.word	s_martin_brodeur
	.word	0

special05_list
	.word	s_theoren_fleury
	.word	s_sergei_fedorov
	.word	s_pavel_bure
	.word	s_teemu_selanne
	.word	0
special05_glist
	.word	s_felix_potvin
	.word	0

special06_list
	.word	s_sergei_fedorov
	.word	s_pavel_bure
	.word	s_alexander_mogilny
;	.word	s_sergei_makarov
	.word	0
special06_glist
	.word	s_arturs_irbe
	.word	0

special07_list
	.word	s_joe_juneau
	.word	s_adam_oates
	.word	s_brett_hull
	.word	0
special07_glist
	.word	s_darren_puppa
	.word	0

special08_list
	.word	s_kirk_muller
	.word	s_eric_desjardins
	.word	s_claude_lemieux
	.word	0
special08_glist
	.word	s_patrick_roy
	.word	0

special09_list
	.word	s_petr_nedved
	.word	s_peter_bondra
	.word	s_petr_klima
	.word	0
special09_glist
	.word	s_mike_richter
	.word	0

special10_list
	.word	s_theoren_fleury
	.word	s_mark_recchi
	.word	0
special10_glist
;	.word	s_chris_osgood
	.word	s_mike_vernon
	.word	0

special11_list
	.word	s_eric_lindros
	.word	s_dave_andreychuk
	.word	s_brendan_shanahan
	.word	0
special11_glist
	.word	s_sean_burke
	.word	0

special12_list
	.word	s_jaromir_jagr
	.word	s_radek_bonk
	.word	s_ulf_dahlen
	.word	s_esa_tikkanen
	.word	0
special12_glist
	.word	s_blaine_lacher
	.word	0

special13_list
	.word	s_sandis_ozolinsh
	.word	s_igor_kravchuk
	.word	s_dino_ciccarelli
	.word	0
special13_glist
	.word	s_arturs_irbe
	.word	0

special14_list
	.word	s_mark_messier
	.word	s_claude_lemieux
	.word	s_ray_bourque
	.word	0
special14_glist
	.word	s_ron_hextall
	.word	0

special15_list
	.word	s_kirk_muller
	.word	s_wendel_clark
	.word	s_denis_savard
	.word	s_ray_ferraro
	.word	0
special15_glist
	.word	s_andy_moog
	.word	0

special16_list
	.word	s_claude_lemieux
	.word	s_joe_juneau
	.word	s_paul_kariya
	.word	s_wendel_clark
	.word	0
special16_glist
	.word	s_andy_moog
	.word	0

special17_list
	.word	s_rod_brindamour
	.word	s_mats_sundin
	.word	s_jaromir_jagr
	.word	s_bernie_nicholls
	.word	0
special17_glist
	.word	s_blaine_lacher
	.word	0

special18_list
	.word	s_denis_savard
	.word	s_ray_bourque
	.word	s_vincent_damphousse
	.word	0
special18_glist
	.word	s_ed_belfour
	.word	0

special19_list
	.word	s_jari_kurri
	.word	s_cam_neely
	.word	s_joe_sakic
	.word	0
special19_glist
	.word	s_arturs_irbe
	.word	0

special20_list
	.word	s_kirk_muller
	.word	s_petr_nedved
	.word	s_wayne_gretzky
	.word	0
special20_glist
	.word	s_andy_moog
	.word	0

special21_list
	.word	s_esa_tikkanen
	.word	s_chris_chelios
	.word	s_pavel_bure
	.word	0
special21_glist
	.word	s_dominik_hasek
	.word	0

special22_list
	.word	s_steve_yzerman
	.word	s_teemu_selanne
	.word	s_eric_lindros
	.word	0
special22_glist
	.word	s_jim_carey
	.word	0

special23_list
	.word	s_dale_hawerchuk
	.word	s_dino_ciccarelli
	.word	s_luc_robitaille
	.word	0
special23_glist
	.word	s_john_vanbiesbrouck
	.word	0

special24_list
	.word	s_pat_lafontaine
	.word	s_ray_ferraro
	.word	s_doug_gilmour
	.word	0
special24_glist
	.word	s_martin_brodeur
	.word	0

special25_list
	.word	s_scott_stevens
	.word	s_paul_coffey
	.word	s_dave_andreychuk
	.word	0
special25_glist
;	.word	s_chris_osgood
	.word	s_mike_vernon
	.word	0

special26_list
	.word	s_brian_leetch
	.word	s_brendan_shanahan
	.word	s_john_maclean
	.word	0
special26_glist
	.word	s_ron_hextall
	.word	0

special27_list
	.word	s_jeremy_roenick
	.word	s_mario_lemieux
	.word	s_mike_modano
	.word	0
special27_glist
	.word	s_patrick_roy
	.word	0

special28_list
	.word	s_theoren_fleury
;	.word	s_sergei_makarov
	.word	s_sergei_fedorov
	.word	0
special28_glist
	.word	s_mike_richter
	.word	0

special29_list
	.word	s_brett_hull
	.word	s_mark_messier
	.word	s_eric_desjardins
	.word	0
special29_glist
	.word	s_felix_potvin
	.word	0

special30_list
	.word	s_martin_martinez
	.word	s_jack_haeger
	.word	0
special30_glist
	.word	s_tim_chevaldae
	.word	0

special31_list
	.word	s_mark_penacho
	.word	s_carlos_pesina
	.word	0
special31_glist
	.word	s_ed_belfour
	.word	0

special32_list
	.word	s_mark_penacho
	.word	s_jon_hey
	.word	s_john_carlton
	.word	0
special32_glist
	.word	s_sean_burke
	.word	0

special33_list
	.word	s_josh_tsui
	.word	s_radek_bonk
	.word	s_jason_skiles
	.word	0
special33_glist
	.word	s_trevor_kidd
	.word	0

special34_list
	.word	s_carlos_pesina
	.word	s_martin_martinez
	.word	s_josh_tsui
	.word	s_maryann_rohn
	.word	0
special34_glist
	.word	s_goalie_haeger
	.word	0

special35_list
	.word	s_jim_tianis
	.word	s_mike_waldron
	.word	0
special35_glist
	.word	s_jim_carey
	.word	0

special36_list
	.word	s_mike_vinikour
	.word	s_eddie_ferrier
	.word	0
special36_glist
;	.word	s_chris_osgood
	.word	s_mike_vernon
	.word	0

special37_list
	.word	s_ed_boon
	.word	s_john_tobias
	.word	s_steve_beran
	.word	s_tony_goskie
	.word	s_dave_michicich
	.word	0
special37_glist
	.word	s_john_vanbiesbrouck
	.word	0

special38_list
	.word	s_sal_divita
	.word	s_eugene_geer
	.word	s_josh_tsui
	.word	s_mark_turmell
	.word	s_jennifer_hedrick
	.word	0
special38_glist
	.word	s_blaine_lacher
	.word	0

special39_list
	.word	s_sal_divita
	.word	s_luis_mangubat
	.word	s_chris_bobrowski
	.word	0
special39_glist
	.word	s_goalie_hedrick
	.word	0

special40_list
	.word	s_xion_cooper
	.word	s_ted_barber
	.word	s_eugene_jarvis
	.word	s_glenn_shipp
	.word	s_mark_loffredo
	.word	0
special40_glist
	.word	s_andy_moog
	.word	0

special41_list
	.word	s_eugene_jarvis
	.word	s_cary_mednick
	.word	s_doug_gilmour
	.word	0
special41_glist
	.word	s_andy_moog
	.word	0

special42_list
	.word	s_tony_goskie
	.word	s_jennifer_hedrick
	.word	s_chris_bobrowski
	.word	s_joan_faux
	.word	0
special42_glist
	.word	s_kelly_hrudey
	.word	0

special43_list
	.word	s_brian_eddie
	.word	s_mike_waldron
	.word	s_ken_williams
	.word	0
special43_glist
	.word	s_kirk_mclean
	.word	0

special44_list
	.word	s_jack_haeger
	.word	s_jack_h_haeger
	.word	0
special44_glist
	.word	s_arturs_irbe
	.word	0

special45_list
	.word	s_steve_correll
	.word	s_maryann_rohn
	.word	s_martin_martinez
	.word	0
special45_glist
	.word	s_guy_hebert
	.word	0

special46_list
	.word	s_ed_keenan
	.word	s_john_lowes
	.word	s_dino_ciccarelli
	.word	0
special46_glist
	.word	s_bill_ranford
	.word	0

special47_list
	.word	s_joan_faux
	.word	s_christa_woss
	.word	s_art_tianis
	.word	s_andy_lycke
	.word	s_jim_greene
	.word	0
special47_glist
;	.word	s_jon_casey
	.word	s_grant_fuhr
	.word	0

special48_list
	.word	s_maryann_rohn
	.word	s_jim_rohn
	.word	s_bill_dabelstein
	.word	s_matt_davis
	.word	0
special48_glist
	.word	s_tommy_soderstrom
;	.word	s_jamie_mclennan
	.word	0

special49_list
	.word	s_bill_dabelstein
	.word	s_matt_davis
	.word	0
special49_glist
	.word	s_martin_brodeur
	.word	0

special50_list
	.word	s_tony_metke
	.word	s_sheridan_oursler
	.word	0
special50_glist
	.word	s_mike_richter
	.word	0

special51_list
	.word	s_cary_mednick
	.word	s_pat_cox
	.word	s_john_lowes
	.word	s_ray_gay
	.word	0
special51_glist
	.word	s_ron_hextall
	.word	0

special52_list
	.word	s_al_lasko
	.word	s_sheridan_oursler
	.word	s_ken_williams
	.word	s_ross_shaffer
	.word	s_ted_valvanis
	.word	0
special52_glist
	.word	s_darren_puppa
	.word	0

special53_list
	.word	s_jon_hey
	.word	s_ed_keenan
	.word	s_matt_booty
	.word	s_jennifer_fedesna
	.word	s_bridgitte_fedesna
	.word	0
special53_glist
	.word	s_ken_wregget
	.word	0

special54_list
	.word	s_mike_lynch
	.word	s_warren_davis
	.word	s_john_carlton
	.word	0
special54_glist
	.word	s_stephane_fiset
	.word	0

special55_list
	.word	s_jim_gentile
	.word	s_nik_ehrlik
	.word	s_mike_ossian
	.word	s_jennifer_fedesna
	.word	0
special55_glist
	.word	s_dominik_hasek
	.word	0

special56_list
	.word	s_jake_simpson
	.word	s_john_newcomer
	.word	s_brian_eddie
	.word	s_dave_zabodoul
	.word	0
special56_glist
	.word	s_patrick_roy
	.word	0

special57_list
	.word	s_paul_dussault
	.word	s_jack_h_haeger
	.word	s_steve_correll
	.word	s_ray_macika
	.word	0
special57_glist
	.word	s_don_beaupre
	.word	0

special58_list
	.word	s_martin_martinez
	.word	s_carlos_pesina
	.word	s_ed_boon
	.word	s_john_tobias
	.word	0
special58_glist
	.word	s_felix_potvin
	.word	0

special59_list
	.word	s_jack_haeger
	.word	s_pavel_bure
	.word	s_teemu_selanne
	.word	0
special59_glist
	.word	s_felix_potvin
	.word	0

special60_list
	.word	s_jon_hey
	.word	s_theoren_fleury
	.word	s_cam_neely
	.word	0
special60_glist
	.word	s_jim_carey
	.word	0

special61_list
	.word	s_maryann_rohn
	.word	s_eric_lindros
	.word	s_eric_desjardins
	.word	0
special61_glist
	.word	s_don_beaupre
	.word	0

special62_list
	.word	s_josh_tsui
	.word	s_wayne_gretzky
	.word	s_claude_lemieux
	.word	0
special62_glist
	.word	s_tim_chevaldae
	.word	0

special63_list
	.word	s_martin_martinez
	.word	s_alexander_mogilny
	.word	s_mark_messier
	.word	0
special63_glist
	.word	s_ed_belfour
	.word	0

special64_list
	.word	s_carlos_pesina
	.word	s_chris_chelios
	.word	s_claude_lemieux
	.word	0
special64_glist
	.word	s_dominik_hasek
	.word	0

special65_list
	.word	s_mark_penacho
	.word	s_denis_savard
	.word	s_paul_coffey
	.word	0
special65_glist
	.word	s_patrick_roy
	.word	0


;alt lists for default uniforms

newjersey2_list
	.word	s_bill_dabelstein
	.word	0
edmonton2_list
	.word	s_curtis_joseph
	.word	0

detroit2_list
	.word	s_mike_vernon
	.word	0

boston2_list
buffalo2_list
hartford2_list
montreal2_list
ottawa2_list
pittsburgh2_list
colorado2_list
florida2_list
nyislanders2_list
nyrangers2_list
philadelphia2_list
tampabay2_list
washington2_list
chicago2_list
dallas2_list
stlouis2_list
toronto2_list
winnipeg2_list
anaheim2_list
calgary2_list
losangeles2_list
sanjose2_list
vancouver2_list

non_list
	.word	0

ALPHA_CITY_REMAP_TABLE
;	.WORD	1, 2, 9,11,15,17,18
; 	.WORD	8,12,13,14,16,21,23
;	.WORD	4, 5, 6,20,22,24
;	.WORD	0, 3, 7,10,19,25

	.WORD	1, 2,10,12,16,18, 5
	.WORD	9,13,14,15,17,21,24
	.WORD	4, 6, 7,20,22,25
	.WORD	0, 3, 8,11,19,23

ALPHA_CITY_TABLE
	.LONG	ANAH_STR,BOST_STR,BUFF_STR,CALG_STR,CHIC_STR,COLO_STR,DALL_STR
	.LONG	DETR_STR,EDMO_STR,FLOR_STR,HART_STR,LANG_STR,MONT_STR,NJER_STR
	.LONG	NYIS_STR,NYRA_STR,OTTA_STR,PHIL_STR,PITT_STR,SJOS_STR,STLO_STR
	.LONG	TBAY_STR,TORO_STR,VANC_STR,WASH_STR,WINN_STR

BOST_STR
	.STRING	"BOSTON",0
BUFF_STR
	.STRING "BUFFALO",0
HART_STR
	.STRING	"HARTFORD",0
MONT_STR
	.STRING	"MONTREAL",0
OTTA_STR
	.STRING "OTTAWA",0
PITT_STR
	.STRING	"PITTSBURGH",0
COLO_STR
	.STRING "COLORADO",0

FLOR_STR
	.STRING "FLORIDA",0
NJER_STR
	.STRING "NEW JERSEY",0
NYIS_STR
	.STRING "NY ISLANDERS",0
NYRA_STR
	.STRING	"NY RANGERS",0
PHIL_STR
	.STRING	"PHILADELPHIA",0
TBAY_STR
	.STRING "TAMPA BAY",0
WASH_STR
	.STRING "WASHINGTON",0

CHIC_STR
	.STRING	"CHICAGO",0
DALL_STR
	.STRING "DALLAS",0
DETR_STR
	.STRING	"DETROIT",0
STLO_STR
	.STRING	"ST. LOUIS",0
TORO_STR
	.STRING "TORONTO",0
WINN_STR
	.STRING	"WINNIPEG",0

ANAH_STR
	.STRING	"ANAHEIM",0
CALG_STR
	.STRING "CALGARY",0
EDMO_STR
	.STRING "EDMONTON",0
LANG_STR
	.STRING "LOS ANGELES",0
SJOS_STR
	.STRING "SAN JOSE",0
VANC_STR
	.STRING "VANCOUVER",0


BOST_NICK_STR
	.STRING	"BRUINS",0
BUFF_NICK_STR
	.STRING "SABRES",0
HART_NICK_STR
	.STRING	"WHALERS",0
MONT_NICK_STR
	.STRING	"CANADIENS",0
OTTA_NICK_STR
	.STRING "SENATORS",0
PITT_NICK_STR
	.STRING	"PENGUINS",0
COLO_NICK_STR
	.STRING "COLORADO",0

FLOR_NICK_STR
	.STRING "PANTHERS",0
NJER_NICK_STR
	.STRING "DEVILS",0
NYIS_NICK_STR
	.STRING "ISLANDERS",0
NYRA_NICK_STR
	.STRING	"RANGERS",0
PHIL_NICK_STR
	.STRING	"FLYERS",0
TBAY_NICK_STR
	.STRING "LIGHTNING",0
WASH_NICK_STR
	.STRING "CAPITALS",0

CHIC_NICK_STR
	.STRING	"BLACKHAWKS",0
DALL_NICK_STR
	.STRING "STARS",0
DETR_NICK_STR
	.STRING	"RED WINGS",0
STLO_NICK_STR
	.STRING	"BLUES",0
TORO_NICK_STR
	.STRING "MAPLE\nLEAFS",0
WINN_NICK_STR
	.STRING	"JETS",0

ANAH_NICK_STR
	.STRING	"MIGHTY\nDUCKS",0
CALG_NICK_STR
	.STRING "FLAMES",0
EDMO_NICK_STR
	.STRING "OILERS",0
LANG_NICK_STR
	.STRING "KINGS",0
SJOS_NICK_STR
	.STRING "SHARKS",0
VANC_NICK_STR
	.STRING "CANUCKS",0

;stuff to throw off lookers
	.string	"KANSAS CITY",0
	.string	"CLEVELAND",0
	.string	"OAKLAND",0
	.string	"QUEBEC",0
	.string	"MINNESOTA",0
	.string	"CALIFORNIA",0
	.string	"BROOKLYN",0
	.string	"HAMILTON",0

	.string	"EAGLES",0
	.string	"FALCONS",0
	.string	"PIRATES",0
	.string	"QUAKERS",0
	.string	"COUGARS",0
	.string	"WANDERERS",0
	.string	"GOLDEN SEALS",0
	.string	"MAROONS",0
	.string	"ARENAS",0
	.string	"SCOUTS",0
	.string	"AMERICANS",0
	.string	"BARONS",0
	.string	"BULLDOGS",0
	.string	"ROCKIES",0
	.string	"SEALS",0
	.string	"TIGERS",0
	.string	"ST. PATRICKS",0
	.string	"NORDIQUES",0
	.string	"NORTH STARS",0

	.string	"WHA MODE ACTIVE",0

	.string	"ALBERTA",0
	.string	"BALTIMORE",0
	.string	"BIRMINGHAM",0
	.string	"CINCINNATI",0
	.string	"DENVER",0
	.string	"HOUSTON",0
	.string	"INDIANAPOLIS",0
	.string	"JERSEY",0
	.string	"MICHIGAN",0
	.string	"NEW ENGLAND",0
	.string	"PHOENIX",0
	.string	"SAN DIEGO",0

	.string	"AEROS",0
	.string	"BLADES",0
	.string	"BLAZERS",0
	.string	"BULLS",0
	.string	"CIVICS",0
	.string	"COUGARS",0
	.string	"COWBOYS",0
	.string	"CRUSADERS",0
	.string	"FIGHTING SAINTS",0
	.string	"GOLDEN BLADES",0
	.string	"KNIGHTS",0
	.string	"MARINERS",0
	.string	"NATIONALS",0
	.string	"RACERS",0
	.string	"RAIDERS",0
	.string	"ROADRUNNERS",0
	.string	"SHARKS",0
	.string	"SPURS",0
	.string	"STAGS",0
	.string	"STINGERS",0
	.string	"TOROS",0

	.EVEN

helmet_type_plist
	.long	ccm_helmet_pals
	.long	cooper_helmet_pals
	.long	jofa1_helmet_pals
	.long	jofa2_helmet_pals
	.long	regular_goalie_helmet_pals

ccm_helmet_pals
	.long	CCMWHT5
	.long	CCMBLK1
	.long	CCMRED1
	.long	CCMPRP1
	.long	CCMLBL1
	.long	CCMDBL1
	.long	CCMDBL2
	.long	CCMDBL3

cooper_helmet_pals
	.long	COPWHT2
	.long	COPBLK1
	.long	COPRED1
	.long	COPURP1
	.long	CCMLBL1
	.long	COPDBL1
	.long	COPDBL2
	.long	COPDBL3

jofa1_helmet_pals
	.long	GJOFWH1
	.long	GJOFBK1
	.long	GJOFRD1
	.long	GJOFPR1
	.long	CCMLBL1
	.long	GJOFDB1
	.long	GJOFDB2
	.long	GJOFDB3

jofa2_helmet_pals
	.long	LJOFWH1
	.long	LJOFBK1
	.long	LJOFRD1
	.long	LJOFPR1
	.long	LJOFBL1
	.long	LJOFDB1
	.long	LJOFDB2
	.long	LJOFDB3

regular_goalie_helmet_pals
	.long	WARBELF1
	.long	VERNON1
	.long	IRBPAL1
	.long	WREGGET1
	.long	PUPPA1
	.long	BEEZER1
;	.long	McLENHM30
	.long	PSODERS1
	.long	HEXTALL1
	.long	CAREY2
	.long	BRODEUR1
	.long	RICHTER1
	.long	CUJO1
	.long	POTVIN1
	.long	BEAUPRE1
	.long	BURKE1
	.long	LACHER1
	.long	ROY1
	.long	HASEK1P
	.long	FISET1			;new AVALMSK1 for alt
	.long	RANFORD1
	.long	HEBERT1
	.long	HRUDEY1
	.long	KIDD1
	.long	McLEAN1
	.long	MOOG1
	.long	CHEVELDA1
	.long	AVALMSK1		;new for new colorado
	.long	POSGOOD

nyrangers_list
	.word	s_mark_messier
	.word	s_luc_robitaille
	.word	s_brian_leetch
	.word	s_ray_ferraro
	.word	0
nyrangers_glist
	.word	s_mike_richter
	.word	0
newjersey_list
	.word	s_john_maclean
	.word	s_stephane_richer
	.word	s_steve_thomas
	.word	s_scott_stevens
	.word	0
newjersey_glist
	.word	s_martin_brodeur
	.word	0
washington_list
	.word	s_joe_juneau
	.word	s_peter_bondra
	.word	s_sylvain_cote
	.word	0
washington_glist
	.word	s_jim_carey
	.word	0
philadelphia_list
	.word	s_eric_lindros
	.word	s_rod_brindamour
	.word	s_mikael_renberg
	.word	s_eric_desjardins
	.word	0
philadelphia_glist
	.word	s_ron_hextall
	.word	0
nyislanders_list
	.word	s_kirk_muller
	.word	s_wendel_clark
	.word	s_derek_king
	.word	0
nyislanders_glist
	.word	s_tommy_soderstrom
;	.word	s_jamie_mclennan
	.word	0
florida_list
	.word	s_gord_murphy
	.word	s_scott_mellanby
	.word	s_jesse_belanger
	.word	0
florida_glist
	.word	s_john_vanbiesbrouck
	.word	0
tampabay_list
	.word	s_brian_bradley
	.word	s_petr_klima
	.word	s_roman_hamrlik
	.word	0
tampabay_glist
	.word	s_darren_puppa
	.word	0
pittsburgh_list
	.word	s_mario_lemieux
	.word	s_jaromir_jagr
	.word	s_petr_nedved
	.word	0
pittsburgh_glist
	.word	s_ken_wregget
	.word	0
colorado_list
	.word	s_joe_sakic
	.word	s_claude_lemieux
	.word	s_owen_nolan
	.word	0
colorado_glist
	.word	s_stephane_fiset
	.word	0
buffalo_list
	.word	s_pat_lafontaine
	.word	s_derek_plante
	.word	s_doug_bodger
	.word	0
buffalo_glist
	.word	s_dominik_hasek
	.word	0
montreal_list
	.word	s_vincent_damphousse
	.word	s_mark_recchi
	.word	s_pierre_turgeon
	.word	0
montreal_glist
	.word	s_patrick_roy
	.word	0
boston_list
	.word	s_ray_bourque
	.word	s_cam_neely
	.word	s_adam_oates
	.word	s_kevin_stevens
	.word	0
boston_glist
	.word	s_blaine_lacher
	.word	0
hartford_list
	.word	s_brendan_shanahan
	.word	s_andrew_cassels
	.word	s_geoff_sanderson
	.word	0
hartford_glist
	.word	s_sean_burke
	.word	0
ottawa_list
	.word	s_alexandre_daigle
;	.word	s_alexei_yashin
	.word	s_radek_bonk
	.word	0
ottawa_glist
	.word	s_don_beaupre
	.word	0
detroit_list
	.word	s_sergei_fedorov
	.word	s_steve_yzerman
	.word	s_dino_ciccarelli
	.word	s_paul_coffey
	.word	0
detroit_glist
;	.word	s_chris_osgood
	.word	s_mike_vernon
	.word	0
toronto_list
	.word	s_doug_gilmour
	.word	s_dave_andreychuk
	.word	s_mats_sundin
	.word	0
toronto_glist
	.word	s_felix_potvin
	.word	0
stlouis_list
	.word	s_brett_hull
	.word	s_esa_tikkanen
	.word	s_shayne_corson
	.word	s_dale_hawerchuk
	.word	0
stlouis_glist
;	.word	s_jon_casey
	.word	s_grant_fuhr
	.word	0
chicago_list
	.word	s_jeremy_roenick
	.word	s_chris_chelios
	.word	s_bernie_nicholls
	.word	s_denis_savard
	.word	0
chicago_glist
	.word	s_ed_belfour
	.word	0
winnipeg_list
	.word	s_teemu_selanne
	.word	s_keith_tkachuk
	.word	s_alexei_zhamnov
	.word	0
winnipeg_glist
	.word	s_tim_chevaldae
	.word	0
dallas_list
	.word	s_mike_modano
	.word	s_kevin_hatcher
	.word	s_dave_gagner
	.word	0
dallas_glist
	.word	s_andy_moog
	.word	0
vancouver_list
	.word	s_pavel_bure
	.word	s_alexander_mogilny
	.word	s_trevor_linden
	.word	0
vancouver_glist
	.word	s_kirk_mclean
	.word	0
calgary_list
	.word	s_theoren_fleury
	.word	s_phil_housley
	.word	s_joe_nieuwendyk
	.word	s_zarley_zalapski
	.word	0
calgary_glist
	.word	s_trevor_kidd
	.word	0
sanjose_list
	.word	s_sandis_ozolinsh
	.word	s_craig_janney
	.word	s_ulf_dahlen
;	.word	s_sergei_makarov
	.word	0
sanjose_glist
	.word	s_arturs_irbe
	.word	0
losangeles_list
	.word	s_wayne_gretzky
	.word	s_jari_kurri
	.word	s_rick_tocchet
	.word	0
losangeles_glist
	.word	s_kelly_hrudey
	.word	0
anaheim_list
	.word	s_paul_kariya
	.word	s_tom_kurvers
	.word	s_bob_corkum
	.word	0
anaheim_glist
	.word	s_guy_hebert
	.word	0
edmonton_list
	.word	s_igor_kravchuk
	.word	s_doug_weight
	.word	s_jason_arnott
	.word	0
edmonton_glist
	.word	s_bill_ranford
;	.word	s_curtis_joseph
	.word	0
