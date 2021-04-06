 	.MLIB	"HHMACS.LIB"
	.FILE	"HHSTABL2.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GET THE SYSTEM STUFF
*

	.INCLUDE	"HH.INC"
	.INCLUDE	"IMGTBL.GLO"
	.INCLUDE	"hhstabl2.tbl"
	.INCLUDE	"hhstab22.tbl"
	.INCLUDE	"SKILES.TBL"
	.include	"NEWHD.TBL"
	.include	"hhstabl2.e"
	.include	"hhtables.g"
	.include	"hhstabl3.g"
	.include	"hhstabl4.g"
	.include	"hhstabl5.g"
	.include	"hhcontrl.g"

; end of include files

hm_ccm		.equ	0
hm_cooper	.equ	1
hm_jofa1	.equ	2
hm_jofa2	.equ	3
hm_goalies	.equ	4

player_data
	.long	mark_messier
	.long	mark_messier
	.long	petr_nedved
	.long	john_maclean
	.long	stephane_richer
	.long	joe_juneau
	.long	peter_bondra
	.long	eric_lindros
	.long	rod_brindamour
	.long	kirk_muller
	.long	steve_thomas
	.long	gord_murphy
	.long	scott_mellanby
	.long	brian_bradley
	.long	petr_klima
	.long	jaromir_jagr
	.long	luc_robitaille
	.long	joe_sakic
	.long	wendel_clark
	.long	pat_lafontaine
	.long	alexander_mogilny
	.long	vincent_damphousse
	.long	mark_recchi
	.long	ray_bourque
	.long	cam_neely
	.long	andrew_cassels
	.long	geoff_sanderson
	.long	alexandre_daigle
	.long	alexei_yashin
	.long	sergei_fedorov
	.long	steve_yzerman
	.long	doug_gilmour
	.long	dave_andreychuk
	.long	brett_hull
	.long	brendan_shanahan
	.long	bernie_nicholls
	.long	chris_chelios
	.long	teemu_selanne
	.long	keith_tkachuk
	.long	mike_modano
	.long	kevin_hatcher
	.long	pavel_bure
	.long	trevor_linden
	.long	theoren_fleury
	.long	robert_reichel
	.long	sandis_ozolinsh
	.long	ulf_dahlen
	.long	wayne_gretzky
	.long	jari_kurri
	.long	paul_kariya
	.long	tom_kurvers
	.long	igor_kravchuk
	.long	shayne_corson
	.long	mike_richter
	.long	martin_brodeur
	.long	jim_carey
	.long	ron_hextall
	.long	jamie_mclennan
	.long	john_vanbiesbrouck
	.long	darren_puppa
	.long	ken_wregget
	.long	stephane_fiset
	.long	dominik_hasek
	.long	patrick_roy
	.long	blaine_lacher
	.long	sean_burke
	.long	don_beaupre
	.long	mike_vernon
	.long	felix_potvin
	.long	curtis_joseph
	.long	ed_belfour
	.long	tim_chevaldae
	.long	andy_moog
	.long	kirk_mclean
	.long	trevor_kidd
	.long	arturs_irbe
	.long	kelly_hrudey
	.long	guy_hebert
	.long	bill_ranford
	.long	jeremy_roenick

	.long	bob_corkum
	.long	adam_oates
	.long	derek_plante
	.long	phil_housley
	.long	denis_savard
	.long	dave_gagner
	.long	paul_coffey
	.long	dino_ciccarelli
	.long	doug_weight
	.long	jason_arnott
	.long	jesse_belanger
	.long	rick_tocchet
	.long	pierre_turgeon
	.long	claude_lemieux
	.long	scott_stevens
	.long	ray_ferraro
	.long	brian_leetch
	.long	radek_bonk
	.long	mikael_renberg
	.long	eric_desjardins
	.long	mario_lemieux
	.long	owen_nolan
	.long	sergei_makarov
	.long	esa_tikkanen
	.long	roman_hamrlik
	.long	mats_sundin
	.long	sylvain_cote
	.long	alexei_zhamnov
	.long	dale_hawerchuk

	.long	doug_bodger
	.long	derek_king
	.long	joe_nieuwendyk

	.long	martin_martinez
	.long	jack_haeger
	.long	bill_dabelstein
	.long	josh_tsui
	.long	mark_penacho
	.long	maryann_rohn
	.long	carlos_pesina
	.long	jim_tianis
	.long	mike_waldron
	.long	mike_vinikour
	.long	warren_davis
	.long	ed_boon
	.long	john_tobias
	.long	steve_beran
	.long	pat_cox
	.long	jim_gentile
	.long	sal_divita
	.long	nik_ehrlich
	.long	eddie_ferrier
	.long	eugene_geer
	.long	tony_goskie
	.long	jennifer_hedrick
	.long	jon_hey
	.long	mike_lynch
	.long	dave_michicich
	.long	john_carlton
	.long	brian_eddie
	.long	mark_loffredo
	.long	cary_mednick
	.long	eugene_jarvis
	.long	mike_ossian
	.long	joan_faux
	.long	luis_mangubot
	.long	jason_skiles
	.long	al_lasko
	.long	jim_rohn
	.long	ray_gay
	.long	george_petro
	.long	ted_barber
	.long	dave_zab
	.long	christa_woss
	.long	paul_dussault
	.long	jack_h_haeger
	.long	jennifer_fedesna
	.long	bridgitte_fedesna
	.long	mark_turmell
	.long	art_tianis
	.long	jim_greene
	.long	sheridan_oursler
	.long	ed_keenan
	.long	matt_booty
	.long	matt_davis
	.long	steve_correll
	.long	john_lowes
	.long	glenn_shipp
	.long	tony_metke
	.long	ray_macika
	.long	ken_williams
	.long	jake_simpson
	.long	john_newcomer
	.long	xion_cooper
	.long	chris_bobrowski
	.long	andy_lycke
	.long	ted_valvanis
	.long	ross_shaffer
	.long	jon_casey

	.long	kevin_stevens
	.long	zarley_zalapski
	.long	craig_janney
	.long	gordie_howe
	.long	matt_cooney
	.long	kevin_daley
	.long	sidney_strong
	.long	pat_foley
	.long	rebecca_scott
	.long	heather_beach
	.long	goalie_haeger
	.long	goalie_hedrick
	.long	jay_cohen
	.long	jeff_johnson
	.long	jeff_peters
	.long	dan_thompson
	.long	evil_haeger
	.long	tommy_soderstrom
	.long	chris_osgood
	.long	grant_fuhr
	.long	0


;	.byte	" "," "," ",month,day,0,0,0
;	.long	head_table,unused
;	.long	shot_table,scale_table
;	.word	mass,0
;	.byte	speed,stopping,cornering,shooting
;	.byte	,passing,faceoff,puck handling,checking
;	.long	NAME IMAGE, MUG SHOT IMAGE + HFLIP FLAG
;	.word	helmet_type

mark_messier
	.byte	'M'-'A','D'-'A','M'-'A',01,18,0,0,0
	.long	messier_heads,0
	.long	regular_shot_table,zscale_104_102_table
	.word	100,0
	.byte	8,3,3,4,5,5,3,4
	.long	MESSIER1,M_MESSIER
	.word	hm_cooper
petr_nedved
	.byte	'P'-'A',26,'N'-'A',12,09,0,0,0
	.long	nedved_heads,0
	.long	regular_shot_table,zscale_98_104_table
	.word	100,0
	.byte	5,3,4,2,4,5,4,2
	.long	NEDVED1,M_NEDVED
	.word	hm_ccm
john_maclean
	.byte	'J'-'A',26,'M'-'A',11,20,0,0,0
	.long	maclean_heads,0
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	1,1,2,5,3,4,3,5
	.long	MACLEAN1,M_MACLEAN+1
	.word	hm_jofa2
stephane_richer
	.byte	'S'-'A',26,'R'-'A',06,07,0,0,0
	.long	richer_heads,0
	.long	regular_shot_table,zscale_100_102_table
	.word	100,0
	.byte	7,4,4,5,4,3,3,4
	.long	RICHER1,M_RICHER+1
	.word	hm_ccm
joe_juneau
	.byte	'J'-'A',26,'J'-'A',01,05,0,0,0
	.long	juneau_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	7,4,4,2,3,4,2,2
	.long	JUNEAU1,M_JUNEAU
	.word	hm_ccm
peter_bondra
	.byte	'P'-'A',26,'B'-'A',02,07,0,0,0
	.long	bondra_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	7,3,3,4,3,2,3,1
	.long	BONDRA,M_BONDRA
	.word	hm_ccm
eric_lindros
	.byte	'E'-'A','B'-'A','L'-'A',02,28,0,0,0
	.long	lindros_heads,0
	.long	regular_shot_table,zscale_108_106_table
	.word	100,0
	.byte	5,3,3,4,4,5,3,5
	.long	LINDROS1,M_LINDROS+1
	.word	hm_ccm
rod_brindamour
	.byte	'R'-'A','J'-'A','B'-'A',08,09,0,0,0
	.long	brindamour_heads,0
	.long	regular_shot_table,zscale_100_102_table
	.word	100,0
	.byte	8,3,3,3,4,3,4,4
	.long	BRINDAM1,M_BRINDAM
	.word	hm_ccm
kirk_muller
	.byte	'K'-'A',26,'M'-'A',02,08,0,0,0
	.long	muller_heads,0
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	3,5,5,1,3,3,3,4
	.long	MULLER1,M_MULLER
	.word	hm_ccm
steve_thomas
	.byte	'S'-'A','A'-'A','T'-'A',07,15,0,0,0
	.long	thomas_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	9,3,2,4,3,1,5,5
	.long	THOMAS1,M_THOMAS+1
	.word	hm_ccm
gord_murphy
	.byte	'G'-'A','J'-'A','M'-'A',03,23,0,0,0
	.long	murphy_heads,0
	.long	regular_shot_table,zscale_98_102_table
	.word	100,0
	.byte	7,5,5,2,2,1,2,1
	.long	MURPHY1,M_MURPHY+1
	.word	hm_ccm
scott_mellanby
	.byte	'S'-'A','E'-'A','M'-'A',06,11,0,0,0
	.long	mellanby_heads,0
	.long	regular_shot_table,zscale_104_102_table
	.word	100,0
	.byte	1,1,2,3,3,4,4,5
	.long	MELLANBY,M_MELLANBY+1
	.word	hm_ccm
brian_bradley
	.byte	'B'-'A',26,'B'-'A',01,21,0,0,0
	.long	bradley_heads,0
	.long	regular_shot_table,zscale_98_98_table
	.word	100,0
	.byte	5,3,3,3,4,4,4,1
	.long	BRADLEY1,M_BRADLEY
	.word	hm_ccm
petr_klima
	.byte	'P'-'A',26,'K'-'A',12,23,0,0,0
	.long	klima_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	7,4,3,4,3,2,2,1
	.long	KLIMA1,M_KLIMA+1
	.word	hm_ccm
jaromir_jagr
	.byte	'J'-'A',26,'J'-'A',02,15,0,0,0
	.long	jagr_heads,0
	.long	regular_shot_table,zscale_104_102_table
	.word	100,0
	.byte	7,5,5,4,1,2,3,1
	.long	JAGR,M_JAGR
	.word	hm_jofa2
luc_robitaille
	.byte	'L'-'A',26,'R'-'A',02,17,0,0,0
	.long	robitaille_heads,0
	.long	regular_shot_table,zscale_98_102_table
	.word	100,0
	.byte	5,3,3,5,4,3,5,3
	.long	ROBITAI1,M_ROBITAI
	.word	hm_ccm
joe_sakic
	.byte	'J'-'A','S'-'A','S'-'A',07,07,0,0,0
	.long	sakic_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	3,2,2,3,5,4,5,4
	.long	SAKIC1,M_SAKIC
	.word	hm_ccm
wendel_clark
	.byte	'W'-'A','L'-'A','C'-'A',10,25,0,0,0
	.long	clark_heads,0
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	7,2,1,3,1,3,1,5
	.long	CLARK1,M_CLARK
	.word	hm_ccm
pat_lafontaine
	.byte	'P'-'A','M'-'A','L'-'A',02,22,0,0,0
	.long	lafontaine_heads,0
	.long	regular_shot_table,zscale_98_98_table
	.word	100,0
	.byte	10,5,5,2,3,5,3,1
	.long	LAFONTN1,M_LAFONTN
	.word	hm_ccm
alexander_mogilny
	.byte	'A'-'A',26,'M'-'A',02,18,0,0,0
	.long	mogilny_heads,0
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	10,3,3,3,1,2,4,3
	.long	MOGILNY1,M_MOGILNY
	.word	hm_ccm
vincent_damphousse
	.byte	'V'-'A','F'-'A','D'-'A',12,17,0,0,0
	.long	damphousse_heads,0
	.long	regular_shot_table,zscale_98_102_table
	.word	100,0
	.byte	2,5,5,4,3,4,1,1
	.long	DAMPHOU1,M_DAMPHOUS
	.word	hm_jofa2
mark_recchi
	.byte	'M'-'A','L'-'A','R'-'A',02,01,0,0,0
	.long	recchi_heads,0
	.long	regular_shot_table,zscale_100_96_table
	.word	100,0
	.byte	7,4,4,4,3,3,3,1
	.long	RECCHI,M_RECCHI
	.word	hm_ccm
ray_bourque
	.byte	'R'-'A','J'-'A','B'-'A',12,28,0,0,0
	.long	bourque_heads,0
	.long	regular_shot_table,zscale_108_100_table
	.word	100,0
	.byte	5,3,3,2,5,3,4,4
	.long	BOURQUE1,M_BOURQUE+1
	.word	hm_ccm
cam_neely
	.byte	'C'-'A','M'-'A','N'-'A',06,06,0,0,0
	.long	neely_heads,0
	.long	regular_shot_table,zscale_104_102_table
	.word	100,0
	.byte	5,2,2,5,4,3,3,5
	.long	NEELY1,M_NEELY+1
	.word	hm_ccm
andrew_cassels
	.byte	'A'-'A','W'-'A','C'-'A',07,23,0,0,0
	.long	cassels_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	5,3,3,1,5,5,3,3
	.long	CASSELS1,M_CASSELS+1
	.word	hm_ccm
geoff_sanderson
	.byte	'G'-'A','M'-'A','S'-'A',02,01,0,0,0
	.long	sanderson_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	9,5,4,4,3,1,4,1
	.long	SANDRSN1,M_SANDRSN+1
	.word	hm_ccm
alexandre_daigle
	.byte	'A'-'A','L'-'A','D'-'A',02,07,0,0,0
	.long	daigle_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	9,3,3,3,2,4,4,5
	.long	DAIGLE1,M_DAIGLE+1
	.word	hm_jofa2
alexei_yashin
;	.byte	'A'-'A','V'-'A','Y'-'A',11,05,0,0,0
	.byte	120,'V'-'A','Y'-'A',11,05,0,0,0
	.long	yashin_heads,0
	.long	regular_shot_table,zscale_98_102_table
	.word	100,0
	.byte	3,3,3,4,3,3,4,4
	.long	YASHIN1,M_YASHIN+1
	.word	hm_ccm
sergei_fedorov
	.byte	'S'-'A','V'-'A','F'-'A',12,13,0,0,0
	.long	fedorov_heads,0
	.long	regular_shot_table,zscale_98_102_table
	.word	100,0
	.byte	10,5,5,4,3,1,3,1
	.long	FEDOROV1,M_FEDOROV
	.word	hm_ccm
steve_yzerman
	.byte	'S'-'A','G'-'A','Y'-'A',05,09,0,0,0
	.long	yzerman_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	9,5,5,3,3,1,2,2
	.long	YZERMAN1,M_YZERMAN
	.word	hm_ccm
doug_gilmour
	.byte	'D'-'A','R'-'A','G'-'A',06,25,0,0,0
	.long	gilmour_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	5,4,4,1,5,5,5,3
	.long	GILMOUR1,M_GILMOR
	.word	hm_ccm
dave_andreychuk
	.byte	'D'-'A','J'-'A','A'-'A',09,29,0,0,0
	.long	andreychuk_heads,0
	.long	regular_shot_table,zscale_106_104_table
	.word	100,0
	.byte	5,4,4,4,3,5,5,4
	.long	ANDREYCH1,M_ANDREYCH
	.word	hm_ccm
brett_hull
	.byte	'B'-'A',26,'H'-'A',08,09,0,0,0
	.long	hull_heads,0
	.long	regular_shot_table,zscale_104_98_table
	.word	100,0
	.byte	5,3,3,4,5,2,3,2
	.long	HULL1,M_HULL
	.word	hm_ccm
brendan_shanahan
	.byte	'B'-'A','F'-'A','S'-'A',01,23,0,0,0
	.long	shanahan_heads,0
	.long	regular_shot_table,zscale_104_104_table
	.word	100,0
	.byte	1,4,4,4,4,3,3,4
	.long	SHANAHN1,M_SHANHN+1
	.word	hm_ccm
bernie_nicholls
	.byte	'B'-'A','I'-'A','N'-'A',02,24,0,0,0
	.long	nicholls_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	1,4,4,4,5,3,5,3
	.long	NICHOLLS1,M_NICHOLLS
	.word	hm_ccm
chris_chelios
	.byte	'C'-'A','K'-'A','C'-'A',01,25,0,0,0
	.long	chelios_heads,0
	.long	regular_shot_table,zscale_98_102_table
	.word	100,0
	.byte	9,4,4,4,3,2,2,3
	.long	CHELIOS1,M_CHELIOS
	.word	hm_ccm
teemu_selanne
	.byte	'T'-'A',26,'S'-'A',07,03,0,0,0
	.long	selanne_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	10,5,5,4,3,2,2,1
	.long	SELANNE1,M_SELANN+1
	.word	hm_ccm
keith_tkachuk
	.byte	'K'-'A','M'-'A','T'-'A',03,28,0,0,0
	.long	tkachuk_heads,0
	.long	regular_shot_table,zscale_106_104_table
	.word	100,0
	.byte	7,2,3,4,3,2,4,5
	.long	TKACHUK1,M_TKACHK+1
	.word	hm_ccm
mike_modano
	.byte	'M'-'A','T'-'A','M'-'A',06,07,0,0,0
	.long	modano_heads,0
	.long	regular_shot_table,zscale_98_104_table
	.word	100,0
	.byte	7,4,4,4,4,4,3,1
	.long	MODANO1,M_MODANO
	.word	hm_ccm
kevin_hatcher
	.byte	'K'-'A','J'-'A','H'-'A',09,09,0,0,0
	.long	hatcher_heads,0
	.long	regular_shot_table,zscale_108_104_table
	.word	100,0
	.byte	7,2,2,2,3,2,5,3
	.long	HATCHER1,M_HATCHER
	.word	hm_ccm
pavel_bure
	.byte	'P'-'A','V'-'A','B'-'A',03,31,0,0,0
	.long	bure_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	10,5,5,4,1,1,1,2
	.long	BURE1,M_BURE+1
	.word	hm_ccm
trevor_linden
	.byte	'T'-'A','J'-'A','L'-'A',04,11,0,0,0
	.long	linden_heads,0
	.long	regular_shot_table,zscale_100_104_table
	.word	100,0
	.byte	3,3,3,3,5,3,4,3
	.long	LINDEN,M_LINDEN
	.word	hm_ccm

robert_reichel	;here to fix lock problem

theoren_fleury
	.byte	'T'-'A','W'-'A','F'-'A',06,29,0,0,0
	.long	fleury_heads,0
	.long	regular_shot_table,zscale_98_96_table
	.word	100,0
	.byte	9,5,5,3,1,4,1,2
	.long	FLEURY1,M_FLEURY
	.word	hm_jofa2
;robert_reichel		;move above to fix lock problem
;	.byte	100,100,100,5,4,0,0,0
;	.long	reichel_heads,0
;	.long	regular_shot_table,zscale_98_98_table
;	.word	100,0
;	.byte	6,4,5,4,3,3,4,2
;	.long	REICHEL1,M_REICHEL
;	.word	hm_ccm
sandis_ozolinsh
	.byte	'S'-'A',26,'O'-'A',08,03,0,0,0
	.long	ozolinsh_heads,0
	.long	regular_shot_table,zscale_98_102_table
	.word	100,0
	.byte	9,3,1,5,3,3,3,4
	.long	OZOLNSH1,M_OZOLINS+1
	.word	hm_ccm
ulf_dahlen
	.byte	'U'-'A','R'-'A','D'-'A',01,12,0,0,0
	.long	dahlen_heads,0
	.long	regular_shot_table,zscale_98_102_table
	.word	100,0
	.byte	3,3,3,4,3,4,5,4
	.long	DAHLEN1,M_DAHLEN+1
	.word	hm_jofa2
wayne_gretzky
	.byte	'W'-'A',26,'G'-'A',01,26,0,0,0
	.long	gretzky_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	7,4,3,4,4,3,5,1
	.long	GRETZKY1,M_GRETZKY+1
	.word	hm_jofa1
jari_kurri
	.byte	'J'-'A','P'-'A','K'-'A',05,18,0,0,0
	.long	kurri_heads,0
	.long	regular_shot_table,zscale_98_102_table
	.word	100,0
	.byte	7,4,4,4,4,2,5,3
	.long	KURRI1,M_KURRI+1
	.word	hm_jofa2
paul_kariya
	.byte	'P'-'A','T'-'A','K'-'A',10,16,0,0,0
	.long	kariya_heads,0
	.long	regular_shot_table,zscale_98_98_table
	.word	100,0
	.byte	7,5,5,3,5,2,4,1
	.long	KARIYA1,M_KARIYA
	.word	hm_ccm
tom_kurvers
	.byte	'T'-'A','J'-'A','K'-'A',09,14,0,0,0
	.long	kurvers_heads,0
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	5,3,3,3,3,3,3,3
	.long	KURVERS1,M_KURVERS
	.word	hm_ccm
igor_kravchuk
	.byte	'I'-'A','A'-'A','K'-'A',09,13,0,0,0
	.long	kravchuk_heads,0
	.long	regular_shot_table,zscale_100_102_table
	.word	100,0
	.byte	6,5,5,2,3,2,3,3
	.long	KRAVCHK1,M_KRAVCHK
	.word	hm_ccm
shayne_corson
	.byte	'S'-'A','P'-'A','C'-'A',08,13,0,0,0
	.long	corson_heads,0
	.long	regular_shot_table,zscale_100_100_table		;base for goalie
	.word	100,0
	.byte	3,3,2,2,4,4,5,4
	.long	CORSON1,M_CORSON
	.word	hm_ccm
mike_richter
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	RICHTER1,M_RICHTER
	.word	hm_goalies
martin_brodeur
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	BRODEUR,M_BRODEUR
	.word	hm_goalies
jim_carey
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	CAREY1,M_CAREY
	.word	hm_goalies
ron_hextall
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	HEXTALL1,M_HEXTALL
	.word	hm_goalies
jamie_mclennan
	.byte	100,100,100,1,1,0,0,0
	.long	GD_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	MCLENNAN1,M_MCLENNAN
	.word	hm_goalies
john_vanbiesbrouck
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	VANBIES1,M_VANBIES
	.word	hm_goalies
darren_puppa
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	PUPPA1,M_PUPPA
	.word	hm_goalies
ken_wregget
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	WREGGET,M_WREGGET
	.word	hm_goalies
stephane_fiset
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	FISET1,M_FISET
	.word	hm_goalies
dominik_hasek
	.byte	100,100,100,1,1,0,0,0
	.long	GC_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	HASEK1,M_HASEK
	.word	hm_goalies
patrick_roy
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	ROY,M_ROY
	.word	hm_goalies
blaine_lacher
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	LACHER1,M_LACHER
	.word	hm_goalies
sean_burke
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	BURKE1,M_BURKE
	.word	hm_goalies
don_beaupre
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	BEAUPRE1,M_BEAUPRE
	.word	hm_goalies
mike_vernon
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	VERNON1,M_VERNON
	.word	hm_goalies
felix_potvin
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	POTVIN1,M_POTVIN
	.word	hm_goalies
curtis_joseph
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	JOSEPH1,M_JOSEPH
	.word	hm_goalies
ed_belfour
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	BELFOUR1,M_BELFOUR
	.word	hm_goalies
tim_chevaldae
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	CHEVELDA1,M_CHEVELDAE
	.word	hm_goalies
andy_moog
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	MOOG1,M_MOOG
	.word	hm_goalies
kirk_mclean
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	MCLEAN,M_MCLEAN
	.word	hm_goalies
trevor_kidd
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	KIDD1,M_KIDD
	.word	hm_goalies
arturs_irbe
	.byte	100,100,100,1,1,0,0,0
	.long	GG_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	IRBE1,M_IRBE
	.word	hm_goalies
kelly_hrudey
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	HRUDEY1,M_HRUDEY
	.word	hm_goalies
guy_hebert
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	HEBERT1,M_HEBERT
	.word	hm_goalies
bill_ranford
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	RANFORD1,M_RANFORD
	.word	hm_goalies
jeremy_roenick
	.byte	'J'-'A','S'-'A','R'-'A',01,17,0,0,0
	.long	roenick_heads,0
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	9,4,5,4,3,3,3,4
	.long	ROENICK1,M_ROENICK
	.word	hm_ccm
bob_corkum
	.byte	'B'-'A','F'-'A','C'-'A',12,18,0,0,0
	.long	corkum_heads,0
	.long	regular_shot_table,zscale_104_102_table
	.word	100,0
	.byte	5,3,3,3,5,4,2,5
	.long	CORKUM1,M_CORKUM+1
	.word	hm_ccm
adam_oates
	.byte	'A'-'A','R'-'A','O'-'A',08,27,0,0,0
	.long	oates_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	3,2,2,2,5,5,5,3
	.long	OATES1,M_OATES
	.word	hm_ccm
derek_plante
	.byte	'D'-'A','J'-'A','P'-'A',01,17,0,0,0
	.long	plante_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	7,5,5,4,5,1,2,1
	.long	PLANTE1,M_PLANTE
	.word	hm_ccm
phil_housley
	.byte	'P'-'A','F'-'A','H'-'A',03,09,0,0,0
	.long	housley_heads,0
	.long	regular_shot_table,zscale_98_98_table
	.word	100,0
	.byte	9,5,5,3,2,2,5,1
	.long	HOUSLEY1,M_HOUSLEY
	.word	hm_jofa2
denis_savard
	.byte	'D'-'A',26,'S'-'A',02,04,0,0,0
	.long	savard_heads,0
	.long	regular_shot_table,zscale_98_98_table
	.word	100,0
	.byte	7,5,5,2,3,3,5,1
	.long	SAVARD1,M_SAVARD+1
	.word	hm_jofa2
dave_gagner
	.byte	'D'-'A','R'-'A','G'-'A',12,11,0,0,0
	.long	gagner_heads,0
	.long	regular_shot_table,zscale_98_98_table
	.word	100,0
	.byte	5,5,4,3,3,3,4,3
	.long	GAGNER1,M_GAGNER
	.word	hm_jofa2
paul_coffey
	.byte	'P'-'A','D'-'A','C'-'A',06,01,0,0,0
	.long	coffey_heads,0
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	7,5,5,2,5,2,5,2
	.long	COFFEY1,M_COFFEY+1
	.word	hm_ccm
dino_ciccarelli
	.byte	'D'-'A',26,'C'-'A',02,08,0,0,0
	.long	ciccarelli_heads,0
	.long	regular_shot_table,zscale_98_98_table
	.word	100,0
	.byte	1,5,1,4,5,3,4,5
	.long	CICCARE1,M_CICCARE+1
	.word	hm_ccm
doug_weight
	.byte	'D'-'A','D'-'A','W'-'A',01,21,0,0,0
	.long	weight_heads,0
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	5,4,4,4,5,4,3,4
	.long	WEIGHT1,M_WEIGHT+1
	.word	hm_ccm
jason_arnott
	.byte	'J'-'A','W'-'A','A'-'A',10,11,0,0,0
	.long	arnott_heads,0
	.long	regular_shot_table,zscale_98_104_table
	.word	100,0
	.byte	5,4,4,4,4,2,5,5
	.long	ARNOTT2,M_ARNOTT+1
	.word	hm_ccm
jesse_belanger
	.byte	'J'-'A','D'-'A','B'-'A',06,15,0,0,0
	.long	belanger_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	7,5,4,4,4,3,3,2
	.long	BELANGE1,M_BELANGE+1
	.word	hm_ccm
rick_tocchet
	.byte	'R'-'A',26,'T'-'A',04,09,0,0,0
	.long	tocchet_heads,0
	.long	regular_shot_table,zscale_104_100_table
	.word	100,0
	.byte	7,2,1,4,3,3,5,5
	.long	TOCCHET1,M_TOCCHET+1
	.word	hm_ccm
pierre_turgeon
	.byte	'P'-'A',26,'T'-'A',08,29,0,0,0
	.long	turgeon_heads,0
	.long	regular_shot_table,zscale_104_102_table
	.word	100,0
	.byte	6,5,5,5,4,2,3,2
;	.long	TURGEON1,M_TURGEOS+1
	.long	TURGEON1,M_TURGEON+1
	.word	hm_ccm
claude_lemieux
	.byte	'C'-'A','P'-'A','L'-'A',07,16,0,0,0
	.long	clemieux_heads,0
	.long	regular_shot_table,zscale_108_102_table
	.word	100,0
	.byte	8,1,1,5,3,4,5,4
	.long	LEMIEUX1,M_LEMIEUXC
	.word	hm_jofa2
scott_stevens
	.byte	'S'-'A',26,'S'-'A',04,01,0,0,0
	.long	stevens_heads,0
	.long	regular_shot_table,zscale_106_102_table
	.word	100,0
	.byte	5,5,5,3,4,2,4,5
	.long	STEVENS1,M_STEVENS
	.word	hm_ccm
ray_ferraro
	.byte	'R'-'A','V'-'A','F'-'A',08,23,0,0,0
	.long	ferraro_heads,0
	.long	regular_shot_table,zscale_98_98_table
	.word	100,0
	.byte	2,4,3,4,4,3,5,3
	.long	FERRARO1,M_FERARRO
	.word	hm_ccm
brian_leetch
	.byte	'B'-'A','J'-'A','L'-'A',03,03,0,0,0
	.long	leetch_heads,0
	.long	regular_shot_table,zscale_100_100_table
	.word	100,0
	.byte	7,5,3,3,5,1,3,2
	.long	LEETCH1,M_LEETCH+1
	.word	hm_ccm
radek_bonk
	.byte	'R'-'A',26,'B'-'A',01,09,0,0,0
	.long	bonk_heads,0
	.long	regular_shot_table,zscale_104_104_table
	.word	100,0
	.byte	3,4,4,4,5,4,5,4
	.long	BONK1,M_BONK
	.word	hm_ccm
mikael_renberg
	.byte	'M'-'A','B'-'A','R'-'A',05,05,0,0,0
	.long	renberg_heads,0
	.long	regular_shot_table,zscale_108_102_table
	.word	100,0
	.byte	5,4,4,4,3,2,4,4
	.long	RENBERG1,M_RENBERG+1
	.word	hm_ccm
eric_desjardins
	.byte	'E'-'A',26,'D'-'A',06,14,0,0,0
	.long	desjardins_heads,0
	.long	regular_shot_table,zscale_100_102_table
	.word	100,0
	.byte	7,4,4,3,3,2,4,4
	.long	DESJARD1,M_DESJARD
	.word	hm_ccm
mario_lemieux
	.byte	'M'-'A',26,'L'-'A',10,05,0,0,0
	.long	mlemieux_heads,0
	.long	regular_shot_table,zscale_100_104_table
	.word	100,0
	.byte	7,3,4,4,4,4,3,3
	.long	LEMIEUX1,M_MLEMIEU
	.word	hm_jofa2

sergei_makarov	;here to fix lock problem

owen_nolan
	.byte	'O'-'A',26,'N'-'A',09,22,0,0,0
	.long	nolan_heads,0
	.long	regular_shot_table,zscale_98_102_table
	.word	100,0
	.byte	7,3,4,5,1,2,1,2
	.long	NOLAN1,M_NOLAN
	.word	hm_ccm
;sergei_makarov
;	.byte	'S'-'A',26,'M'-'A',06,19,0,0,0
;	.long	makarov_heads,0
;	.long	regular_shot_table,zscale_98_100_table
;	.word	100,0
;	.byte	5,4,5,3,5,3,5,2
;	.long	MAKAROV1,M_MAKARO+1
;	.word	hm_ccm
esa_tikkanen
	.byte	'E'-'A','K'-'A','T'-'A',01,25,0,0,0
	.long	tikkanen_heads,0
	.long	regular_shot_table,zscale_100_102_table
	.word	100,0
	.byte	7,3,3,4,3,3,3,5
	.long	TIKKANE1,M_TIKKAN+1
	.word	hm_jofa1
roman_hamrlik
	.byte	'R'-'A',26,'H'-'A',04,12,0,0,0
	.long	hamrlik_heads,0
	.long	regular_shot_table,zscale_98_102_table
	.word	100,0
	.byte	7,4,4,3,4,2,3,3
	.long	HAMRLIK1,M_HAMRLIK+1
	.word	hm_ccm
mats_sundin
	.byte	'M'-'A',26,'S'-'A',02,13,0,0,0
	.long	sundin_heads,0
	.long	regular_shot_table,zscale_104_104_table
	.word	100,0
	.byte	7,3,2,5,3,4,2,4
	.long	SUNDIN1,M_SUNDIN+1
	.word	hm_ccm
sylvain_cote
	.byte	'S'-'A',26,'C'-'A',01,19,0,0,0
	.long	cote_heads,0
	.long	regular_shot_table,zscale_104_98_table
	.word	100,0
	.byte	5,5,5,3,4,2,5,4
	.long	COTE1,M_COTE
	.word	hm_ccm
alexei_zhamnov
	.byte	'A'-'A',26,'Z'-'A',10,01,0,0,0
	.long	zhamnov_heads,0
	.long	regular_shot_table,zscale_98_102_table
	.word	100,0
	.byte	7,3,4,3,5,4,4,2
	.long	ZHAMNOV1,M_ZHAMNOV
	.word	hm_ccm
dale_hawerchuk
	.byte	'D'-'A',26,'H'-'A',04,04,0,0,0
	.long	hawerchuk_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	5,5,5,3,5,5,3,2
	.long	HAWERCH1,M_HAWERCH
	.word	hm_ccm

doug_bodger
	.byte	'D'-'A','G'-'A','B'-'A',06,18,0,0,0
	.long	bodger_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	7,5,3,3,4,1,5,2
	.long	BODGER1,M_BODGER
	.word	hm_ccm
derek_king
	.byte	'D'-'A',26,'K'-'A',02,11,0,0,0
	.long	king_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	3,3,2,4,5,3,5,3
	.long	KING1,M_KING
	.word	hm_ccm
joe_nieuwendyk
	.byte	'J'-'A',26,'N'-'A',09,10,0,0,0
	.long	nieuwendyk_heads,0
	.long	regular_shot_table,zscale_98_100_table
	.word	100,0
	.byte	7,3,2,3,3,5,5,2
	.long	NIEUWEN1,M_NIEUWEN
	.word	hm_cooper

martin_martinez
	.byte	'M'-'A','A'-'A','M'-'A',08,07,0,0,0
	.long	martinez_heads,1
	.long	regular_shot_table,zscale_102_96_table
	.word	100,0
	.byte	5,5,3,4,4,3,4,5
	.long	MARTINE1,MARMM01
	.word	hm_ccm
jack_haeger
	.byte	'J'-'A','E'-'A','H'-'A',07,13,0,0,0
	.long	haeger_heads,1
	.long	regular_shot_table,zscale_100_98_table
	.word	100,0
	.byte	7,3,3,1,4,1,3,5
	.long	HAEGER1,HAEMJ01
	.word	hm_ccm
bill_dabelstein
	.byte	'D'-'A','O'-'A','Z'-'A',12,31,0,0,0
	.long	dabelstein_heads,1
	.long	regular_shot_table,zscale_96_106_table
	.word	100,0
	.byte	10,5,1,3,3,5,4,1
	.long	DABELST1,DABMB01
	.word	hm_ccm
josh_tsui
	.byte	'C'-'A','E'-'A','T'-'A',11,28,0,0,0
	.long	tsui_heads,1
	.long	regular_shot_table,zscale_98_96_table
	.word	100,0
	.byte	9,5,5,5,3,3,3,1
	.long	TSUI1,TSUMJ01
	.word	hm_ccm
mark_penacho
	.byte	'M'-'A','D'-'A','P'-'A',01,13,0,0,0
	.long	penacho_heads,1
	.long	regular_shot_table,zscale_100_98_table
	.word	100,0
	.byte	9,3,3,3,5,4,4,3
	.long	PENACHO1,PENMM01
	.word	hm_ccm
maryann_rohn
	.byte	'M'-'A','A'-'A','C'-'A',07,07,0,0,0
	.long	rohnm_heads,1
	.long	regular_shot_table,zscale_96_96_table
	.word	100,0
	.byte	6,3,3,5,1,3,3,4
	.long	ROHN1,ROHMM01
	.word	hm_ccm
carlos_pesina
	.byte	'C'-'A','C'-'A','P'-'A',11,15,0,0,0
	.long	pesina_heads,1
	.long	regular_shot_table,zscale_102_102_table
	.word	100,100
	.byte	7,3,1,3,1,3,3,5
	.long	PESINA1,PESMC01
	.word	hm_ccm
jim_tianis
	.byte	'D'-'A','J'-'A','T'-'A',10,20,0,0,0
	.long	jtianis_heads,1
	.long	regular_shot_table,zscale_102_100_table
	.word	100,100
	.byte	7,4,2,3,5,1,4,3
	.long	TIANIS1,TIAMJ01
	.word	hm_ccm
mike_waldron
	.byte	'M'-'A','J'-'A','W'-'A',01,09,0,0,0
	.long	waldron_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	9,4,4,3,2,3,4,5
	.long	WALDRON1,WLDMM01
	.word	hm_ccm
mike_vinikour
	.byte	'M'-'A','X'-'A','V'-'A',10,14,0,0,0
	.long	vinikour_heads,1
	.long	regular_shot_table,zscale_98_100_table
	.word	100,100
	.byte	9,5,5,3,5,1,5,3
	.long	VINIKOU1,VINMM01
	.word	hm_ccm
warren_davis
	.byte	'W'-'A','B'-'A','D'-'A',08,17,0,0,0
	.long	wdavis_heads,1
	.long	regular_shot_table,zscale_100_102_table
	.word	100,100
	.byte	5,3,3,4,4,3,3,2
	.long	DAVIS1,DAVMW01
	.word	hm_ccm
ed_boon
	.byte	'E'-'A','J'-'A','B'-'A',02,22,0,0,0
	.long	boon_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	5,3,3,4,1,4,5,5
	.long	BOON1,BOOME01
	.word	hm_ccm
john_tobias
	.byte	'T'-'A','O'-'A','B'-'A',08,24,0,0,0
	.long	tobias_heads,1
	.long	regular_shot_table,zscale_98_96_table
	.word	100,100
	.byte	8,1,5,5,1,1,4,5
	.long	TOBIAS1,TOBMJ01
	.word	hm_ccm
steve_beran
	.byte	'S'-'A','A'-'A','B'-'A',08,29,0,0,0
	.long	beran_heads,1
	.long	regular_shot_table,zscale_98_100_table
	.word	100,100
	.byte	2,1,1,5,5,5,5,5
	.long	BERAN,BARMS01
	.word	hm_ccm
pat_cox
	.byte	'P'-'A','G'-'A','C'-'A',04,11,0,0,0
	.long	cox_heads,1
	.long	regular_shot_table,zscale_98_104_table
	.word	100,100
	.byte	5,5,2,2,5,4,1,3
	.long	COX,COXMP01
	.word	hm_ccm
jim_gentile
	.byte	'J'-'A','P'-'A','G'-'A',01,23,0,0,0
	.long	gentile_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	6,4,1,5,2,4,3,2
	.long	GENTILE1,GENMJ01
	.word	hm_ccm
sal_divita
	.byte	'S'-'A','A'-'A','L'-'A',02,01,0,0,0
	.long	divita_heads,1
	.long	regular_shot_table,zscale_102_97_table
	.word	100,100
	.byte	5,3,3,2,5,3,3,3
	.long	DIVITA,DEVMS01
	.word	hm_ccm
nik_ehrlich
	.byte	'N'-'A','I'-'A','K'-'A',11,17,0,0,0
	.long	ehrlich_heads,1
	.long	regular_shot_table,zscale_98_100_table
	.word	100,100
	.byte	7,5,1,1,4,2,4,3
	.long	EHRLICH1,ERLMN01
	.word	hm_ccm
eddie_ferrier
	.byte	'E'-'A','F'-'A',26,06,10,0,0,0
	.long	ferrier_heads,1
	.long	regular_shot_table,zscale_100_96_table
	.word	100,100
	.byte	9,5,5,3,5,1,5,3
	.long	FERRIER,FERME01
	.word	hm_ccm
eugene_geer
	.byte	'O'-'A','E'-'A','G'-'A',11,05,0,0,0
	.long	geer_heads,1
	.long	regular_shot_table,zscale_104_100_table
	.word	100,100
	.byte	4,1,1,5,4,4,4,5
	.long	GEER1,GEEME01
	.word	hm_ccm
tony_goskie
	.byte	'T'-'A','W'-'A','G'-'A',12,07,0,0,0
	.long	goskie_heads,1
	.long	regular_shot_table,zscale_102_102_table
	.word	100,100
	.byte	5,4,3,3,5,4,1,3
	.long	GOSKIE1,GOSMT01
	.word	hm_ccm
jennifer_hedrick
	.byte	'J'-'A','J'-'A','H'-'A',05,03,0,0,0
	.long	hedrick_heads,1
	.long	regular_shot_table,zscale_96_96_table
	.word	100,100
	.byte	9,5,5,1,1,1,1,2
	.long	HEDRICK1,HEDMJ01
	.word	hm_ccm
jon_hey
	.byte	'J'-'A','W'-'A','H'-'A',09,20,0,0,0
	.long	hey_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	4,1,1,5,1,1,2,5
	.long	HEY1,HEYMJ01
	.word	hm_ccm
mike_lynch
	.byte	'M'-'A','J'-'A','L'-'A',02,28,0,0,0
	.long	lynch_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	6,2,3,3,4,5,3,3
	.long	LYNCH1,LYNMM01
	.word	hm_ccm
dave_michicich
	.byte	'D'-'A','L'-'A','M'-'A',08,06,0,0,0
	.long	michicich_heads,1
	.long	regular_shot_table,zscale_102_102_table
	.word	100,100
	.byte	5,2,2,2,5,3,5,4
	.long	MICHICI1,MICMD01
	.word	hm_ccm
john_carlton
	.byte	'J'-'A','M'-'A','C'-'A',08,05,0,0,0
	.long	carlton_heads,1
	.long	regular_shot_table,zscale_98_96_table
	.word	100,100
	.byte	9,4,4,4,4,4,4,4
	.long	CARLTON1,CARMJ01
	.word	hm_ccm
brian_eddie
	.byte	'B'-'A','R'-'A','E'-'A',04,20,0,0,0
	.long	eddie_heads,1
	.long	regular_shot_table,zscale_98_98_table
	.word	100,100
	.byte	5,1,1,3,5,5,3,5
	.long	EDDY1,EDDMB01
	.word	hm_ccm
mark_loffredo
	.byte	'M'-'A','L'-'A',26,05,25,0,0,0
	.long	loffredo_heads,1
	.long	regular_shot_table,zscale_104_98_table
	.word	100,100
	.byte	4,3,4,5,3,4,2,5
	.long	LOFFRED1,LOFMM01
	.word	hm_ccm
cary_mednick
	.byte	'C'-'A','M'-'A','M'-'A',07,02,0,0,0
	.long	mednick_heads,1
	.long	regular_shot_table,zscale_98_98_table
	.word	100,100
	.byte	3,2,3,4,5,1,5,4
	.long	MEDNICK1,MEDMK01
	.word	hm_ccm
eugene_jarvis
	.byte	'E'-'A','P'-'A','J'-'A',01,27,0,0,0
	.long	jarvis_heads,1
	.long	regular_shot_table,zscale_98_102_table
	.word	100,100
	.byte	7,1,3,4,3,2,3,3
	.long	JARVIS1,JARME01
	.word	hm_ccm
mike_ossian
	.byte	'O'-'A','T'-'A','T'-'A',01,11,0,0,0
	.long	ossian_heads,1
	.long	regular_shot_table,zscale_98_96_table
	.word	100,100
	.byte	5,3,3,4,3,4,1,4
	.long	OSSIAN1,OCEMM01
	.word	hm_ccm
joan_faux
	.byte	'J'-'A','B'-'A','F'-'A',07,17,0,0,0
	.long	faux_heads,1
	.long	regular_shot_table,zscale_96_96_table
	.word	100,100
	.byte	2,3,3,5,1,4,3,1
	.long	FAUX1,FAUMJ01
	.word	hm_ccm
luis_mangubot
	.byte	'L'-'A','M'-'A',26,04,18,0,0,0
	.long	mangubot_heads,1
	.long	regular_shot_table,zscale_98_96_table
	.word	100,100
	.byte	6,5,2,2,4,3,1,4
	.long	MANGUBOT,MANML01
	.word	hm_ccm
jason_skiles
	.byte	'J'-'A','M'-'A','S'-'A',07,29,0,0,0
	.long	skiles_heads,1
	.long	regular_shot_table,zscale_102_100_table
	.word	100,100
	.byte	10,5,1,2,5,3,4,1
	.long	SKILES1,SKILESX
	.word	hm_ccm
al_lasko
	.byte	'A'-'A','L'-'A',26,08,31,0,0,0
	.long	lasko_heads,1
	.long	regular_shot_table,zscale_90_94_table
	.word	100,100
	.byte	9,4,5,3,3,2,1,1
	.long	LASKO1,LASMA01
	.word	hm_ccm
jim_rohn
	.byte	'J'-'A','R'-'A',26,05,22,0,0,0
	.long	jrohn_heads,1
	.long	regular_shot_table,zscale_102_97_table
	.word	100,100
	.byte	3,4,2,5,2,3,4,2
	.long	ROHN1,ROHMJ01
	.word	hm_ccm

george_petro	;move to avoid lock problem

ray_gay
	.byte	'R'-'A','M'-'A','G'-'A',08,11,0,0,0
	.long	gay_heads,1
	.long	regular_shot_table,zscale_98_96_table
	.word	100,100
	.byte	8,1,5,2,3,2,4,5
	.long	GAY1,GAYMR01
	.word	hm_ccm
;george_petro		;move to avoid player lock problem
;	.byte	'G'-'A','N'-'A','P'-'A',10,08,0,0,0
;	.long	petro_heads,1
;	.long	regular_shot_table,zscale_98_98_table
;	.word	100,100
;	.byte	3,5,1,4,1,5,5,2
;	.long	PETRO1,PETMG01
;	.word	hm_ccm
ted_barber
	.byte	'B'-'A','A'-'A','R'-'A',12,05,0,0,0
	.long	barber_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	2,1,1,4,5,3,3,5
	.long	BARBER1,BARMT01
	.word	hm_ccm
dave_zab
	.byte	'Z'-'A','A'-'A','B'-'A',05,28,0,0,0
	.long	zab_heads,1
	.long	regular_shot_table,zscale_98_98_table
	.word	100,100
	.byte	7,1,3,2,4,3,2,5
	.long	ZABLOUD1,ZBDMD01
	.word	hm_ccm
christa_woss
	.byte	'C'-'A','L'-'A','W'-'A',07,09,0,0,0
	.long	woss_heads,1
	.long	regular_shot_table,zscale_96_96_table
	.word	100,100
	.byte	3,4,5,2,5,3,1,1
	.long	WOSS1,WOSMC01
	.word	hm_ccm
paul_dussault
	.byte	'P'-'A','G'-'A','D'-'A',12,17,0,0,0
	.long	dussault_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	6,5,3,3,5,3,3,2
	.long	DUSSAUL1,PDSMA01
	.word	hm_ccm
jack_h_haeger
	.byte	'J'-'A','A'-'A','H'-'A',01,06,0,0,1
	.long	jhhaeger_heads,1
	.long	regular_shot_table,zscale_80_68_table
	.word	100,100
	.byte	9,2,4,2,3,2,3,1
	.long	HAEGER1,HAEMJH01
	.word	hm_ccm
jennifer_fedesna
	.byte	'J'-'A','K'-'A','F'-'A',02,25,0,0,1
	.long	jfedesna_heads,1
	.long	regular_shot_table,zscale_84_77_table
	.word	100,100
	.byte	10,5,5,1,5,1,2,1
	.long	FEDESNA1,FDNMJ01
	.word	hm_ccm
bridgitte_fedesna
	.byte	'B'-'A','M'-'A','F'-'A',05,09,0,0,0
	.long	bfedesna_heads,1
	.long	regular_shot_table,zscale_96_96_table
	.word	100,100
	.byte	4,5,1,3,2,4,5,4
	.long	FEDESNA1,FEDMB01
	.word	hm_ccm
mark_turmell
	.byte	'M'-'A','J'-'A','T'-'A',03,22,0,0,0
	.long	turmell_heads,1
	.long	regular_shot_table,zscale_100_106_table
	.word	100,100
	.byte	7,1,2,2,5,4,5,4
	.long	TURMELL1,TURMM01
	.word	hm_ccm
art_tianis
	.byte	'A'-'A','J'-'A','T'-'A',10,23,0,0,0
	.long	atianis_heads,1
	.long	regular_shot_table,zscale_104_100_table
	.word	100,100
	.byte	4,3,2,5,5,2,4,5
	.long	TIANIS1,TIAMA01
	.word	hm_ccm
jim_greene
	.byte	'J'-'A','D'-'A','G'-'A',05,31,0,0,0
	.long	greene_heads,1
	.long	regular_shot_table,zscale_102_102_table
	.word	100,100
	.byte	3,4,4,2,3,1,4,3
	.long	GREENE1,GRBMJ01
	.word	hm_ccm
sheridan_oursler
	.byte	'S'-'A','N'-'A','O'-'A',01,03,0,0,0
	.long	oursler_heads,1
	.long	regular_shot_table,zscale_104_100_table
	.word	100,100
	.byte	7,3,2,4,3,5,3,5
	.long	OURSLER,OURMS01
	.word	hm_ccm
ed_keenan
	.byte	'E'-'A','J'-'A','K'-'A',04,10,0,0,0
	.long	keenan_heads,1
	.long	regular_shot_table,zscale_102_100_table
	.word	100,100
	.byte	5,3,4,3,2,3,5,2
	.long	KEENAN,KEEME01
	.word	hm_ccm
matt_booty
	.byte	'M'-'A','V'-'A','B'-'A',04,18,0,0,0
	.long	booty_heads,1
	.long	regular_shot_table,zscale_100_104_table
	.word	100,100
	.byte	6,3,2,4,4,3,4,2
	.long	BOOTY,BOOMM01
	.word	hm_ccm
matt_davis
	.byte	'M'-'A','J'-'A','D'-'A',08,19,0,0,0
	.long	mdavis_heads,1
	.long	regular_shot_table,zscale_98_102_table
	.word	100,100
	.byte	10,4,4,5,2,4,4,5
	.long	DAVIS1,DAVMM01
	.word	hm_ccm
steve_correll
	.byte	'R'-'A','S'-'A','C'-'A',09,16,0,0,0
	.long	correll_heads,1
	.long	regular_shot_table,zscale_98_96_table
	.word	100,100
	.byte	1,5,4,2,4,4,2,2
	.long	CORRELL1,CORMS01
	.word	hm_ccm
john_lowes
	.byte	'J'-'A','M'-'A','L'-'A',11,04,0,0,0
	.long	lowes_heads,1
	.long	regular_shot_table,zscale_98_100_table
	.word	100,100
	.byte	7,2,4,1,2,4,2,5
	.long	LOWES1,LOWMJ01
	.word	hm_ccm
glenn_shipp
	.byte	'G'-'A','W'-'A','S'-'A',06,11,0,0,0
	.long	shipp_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	6,4,1,2,4,5,1,3
	.long	SHIPP1,SHIMG01
	.word	hm_ccm
tony_metke
	.byte	'A'-'A','R'-'A','M'-'A',07,19,0,0,0
	.long	metke_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	1,4,2,3,4,2,4,2
	.long	METKE1,METMT01
	.word	hm_ccm
ray_macika
	.byte	'R'-'A','E'-'A','M'-'A',03,26,0,0,0
	.long	macika_heads,1
	.long	regular_shot_table,zscale_98_102_table
	.word	100,100
	.byte	7,4,4,3,2,2,4,1
	.long	MACIKA1,MECMR01
	.word	hm_ccm
ken_williams
	.byte	'W'-'A','K'-'A','W'-'A',05,30,0,0,0
	.long	williams_heads,1
	.long	regular_shot_table,zscale_100_102_table
	.word	100,100
	.byte	2,1,1,4,1,2,1,5
	.long	WILLIAM1,WILMK01
	.word	hm_ccm
jake_simpson
	.byte	'J'-'A','M'-'A','S'-'A',02,22,0,0,0
	.long	simpson_heads,1
	.long	regular_shot_table,zscale_98_100_table
	.word	100,100
	.byte	7,1,5,2,5,1,2,2
	.long	SIMPSON1,SIMMJ01
	.word	hm_ccm
john_newcomer
	.byte	'J'-'A','R'-'A','N'-'A',06,18,0,0,0
	.long	newcomer_heads,1
	.long	regular_shot_table,zscale_104_106_table
	.word	100,100
	.byte	4,1,3,5,2,4,2,5
	.long	NEWCOME1,NEWMJ01
	.word	hm_ccm
xion_cooper
	.byte	'X'-'A','C'-'A',26,08,09,0,0,0
	.long	cooper_heads,1
	.long	regular_shot_table,zscale_100_98_table
	.word	100,100
	.byte	2,5,2,4,1,3,3,2
	.long	COOPER1,COOMS01
	.word	hm_ccm
chris_bobrowski
	.byte	'M'-'A','E'-'A',26,05,12,0,0,0
	.long	bobrowski_heads,1
	.long	regular_shot_table,zscale_100_98_table
	.word	100,100
	.byte	8,1,3,3,2,4,2,3
	.long	BOBROWS1,BOBMC01
	.word	hm_ccm
andy_lycke
	.byte	'A'-'A','L'-'A',26,11,23,0,0,0
	.long	lycke_heads,1
	.long	regular_shot_table,zscale_100_98_table
	.word	100,100
	.byte	7,4,2,5,3,1,3,2
	.long	LYCKE1,LICMA01
	.word	hm_ccm
ted_valvanis
	.byte	'T'-'A','V'-'A',26,10,03,0,0,0
	.long	valvanis_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	6,3,3,2,2,5,4,1
	.long	VALAVA01,VALTD01
	.word	hm_ccm
ross_shaffer
	.byte	'F'-'A','R'-'A','S'-'A',04,13,0,0,0
	.long	shaffer_heads,1
	.long	regular_shot_table,zscale_100_102_table
	.word	100,100
	.byte	2,2,2,4,4,1,4,1
	.long	SHAFFER1,SHAMR01
	.word	hm_ccm
jon_casey
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	CASEY,M_CASEY
	.word	hm_goalies

kevin_stevens
	.byte	'K'-'A','M'-'A','S'-'A',04,15,0,0,0
	.long	kstevens_heads,0
	.long	regular_shot_table,zscale_100_104_table
	.word	100,100
	.byte	5,2,3,4,2,3,3,5
	.long	STEVENS1,M_STEVENK
	.word	hm_ccm
zarley_zalapski
	.byte	'Z'-'A','B'-'A','Z'-'A',04,22,0,0,0
	.long	zalapski_heads,0
	.long	regular_shot_table,zscale_100_104_table
	.word	100,100
	.byte	7,4,4,3,2,2,3,3
	.long	ZALAPSKI1,M_ZALAPSK
	.word	hm_ccm
craig_janney
	.byte	'C'-'A',26,'J'-'A',09,26,0,0,0
	.long	janney_heads,0
	.long	regular_shot_table,zscale_100_102_table
	.word	100,100
	.byte	3,4,4,4,5,4,2,2
	.long	JANNEY1,M_JANNEY
	.word	hm_ccm
gordie_howe
	.byte	'G'-'A',26,'H'-'A',03,31,0,0,0
	.long	howe_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	10,5,5,5,5,5,5,5
	.long	HOWE1,HOWMG01
	.word	hm_ccm
matt_cooney
	.byte	'M'-'A','J'-'A','C'-'A',06,06,0,0,0
	.long	cooney_heads,1
	.long	regular_shot_table,zscale_90_90_table
	.word	100,100
	.byte	8,3,3,5,3,4,4,5
	.long	COONEY1,MATM101
	.word	hm_ccm
kevin_daley
	.byte	'J'-'A',26,'R'-'A',09,15,0,0,0
	.long	daley_heads,1
	.long	regular_shot_table,zscale_90_90_table
	.word	100,100
	.byte	8,3,3,5,3,4,4,5
	.long	DALEY1,KEVM101
	.word	hm_ccm
sidney_strong
	.byte	'S'-'A','I'-'A','D'-'A',02,12,0,0,0
	.long	strong_heads,1
	.long	regular_shot_table,zscale_98_102_table
	.word	100,100
	.byte	10,4,4,3,3,3,2,2
	.long	STRONG1,SIDM101
	.word	hm_ccm
pat_foley
	.byte	'P'-'A','J'-'A','F'-'A',12,23,0,0,0
	.long	foley_heads,1
	.long	regular_shot_table,zscale_98_102_table
	.word	100,100
	.byte	7,4,4,5,2,2,5,3
	.long	FOLEY1,PATM101
	.word	hm_ccm
rebecca_scott
	.byte	'R'-'A','S'-'A',26,09,27,0,0,0
	.long	scott_heads,1
	.long	regular_shot_table,zscale_96_96_table
	.word	100,100
	.byte	6,3,5,3,3,3,3,3
	.long	SCOTT1,SCOMR01
	.word	hm_ccm
heather_beach
	.byte	'H'-'A','A'-'A','B'-'A',03,24,0,0,0
	.long	beach_heads,1
	.long	regular_shot_table,zscale_96_96_table
	.word	100,100
	.byte	6,3,5,3,3,3,3,3
	.long	BEACH1,BEAMH01
	.word	hm_ccm
goalie_haeger
	.byte	100,100,100,1,1,0,0,0
	.long	eviljack_heads,1
	.long	regular_shot_table,zscale_119_119_table
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	HAEGER1,EVILM01
	.word	hm_ccm
goalie_hedrick
	.byte	100,100,100,1,1,0,0,0
	.long	hedrick_heads,1
	.long	regular_shot_table,zscale_119_119_table
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	HEDRICK1,HEDMJ01
	.word	hm_ccm
jay_cohen
	.byte	'J'-'A','N'-'A','C'-'A',06,04,0,0,0
	.long	cohen_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	4,2,4,4,5,2,4,2
	.long	COHEN1,JNCMA01
	.word	hm_ccm
jeff_johnson
	.byte	'J'-'A','B'-'A','J'-'A',11,04,0,0,0
	.long	johnson_heads,1
	.long	regular_shot_table,zscale_100_102_table
	.word	100,100
	.byte	3,2,1,3,5,1,3,2
	.long	JOHNSON1,JOHMJ01
	.word	hm_ccm
jeff_peters
	.byte	'J'-'A','T'-'A','P'-'A',12,15,0,0,0
	.long	peters_heads,1
	.long	regular_shot_table,zscale_100_100_table
	.word	100,100
	.byte	7,1,2,4,2,1,2,4
	.long	PETERS1,PETMJ01
	.word	hm_ccm
dan_thompson
	.byte	'D'-'A','J'-'A','T'-'A',06,04,0,0,0
	.long	thompson_heads,1
	.long	regular_shot_table,zscale_100_102_table
	.word	100,100
	.byte	3,2,4,1,4,5,1,5
	.long	THOMPSO1,THOMD01
	.word	hm_ccm
evil_haeger
	.byte	'J'-'A','H'-'A',26,07,13,0,0,0
	.long	eviljack_heads,1
	.long	regular_shot_table,zscale_100_98_table
	.word	100,0
	.byte	2,2,4,4,4,2,4,2
	.long	HAEGER1,EVILM01
	.word	hm_ccm

tommy_soderstrom
	.byte	100,100,100,1,1,0,0,0
	.long	GC_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	SODERSTROM1,M_SODERST
	.word	hm_goalies

chris_osgood
	.byte	100,100,100,1,1,0,0,0
	.long	GD_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	OSGOOD1,M_OSGOOD
	.word	hm_goalies
grant_fuhr
	.byte	100,100,100,1,1,0,0,0
	.long	GH_heads,0
	.long	regular_shot_table,zscale_119_119_table		;base for goalie
	.word	100,0
	.byte	11,6,3,3,3,1,6,3
	.long	FUHR,M_FUHR
	.word	hm_goalies

old_shot_table
	.word	 0, 0, 0, 0, 0, 0, 0, 0	;behind net
	.word	 0, 0, 0, 0, 0, 0, 0, 0	;right in front of net
	.word	 0, 0, 0, 0, 0, 0, 0, 0	;in close half of face off circle
	.word	 0, 0, 0, 0, 0, 0, 0, 0	;in far half of face off circle
	.word	 0, 0, 0, 0, 0, 0, 0, 0	;behind face off circle, in front of blue line

	.word	 0, 0			;behind blue line, behind center ice
	.word	 0, 0, 0		;forehand, backhand, turbo modifiers
	.word	 0, 0, 0		;sideways, backwards, pressure

regular_shot_table	;easier
	.word	 60, 70, 80, 90, 90, 80, 70, 60
	.word	250,350,450,580,580,450,350,250
	.word	350,450,550,580,580,550,450,350
	.word	325,325,375,425,425,375,325,325
	.word	300,300,300,350,350,300,300,300

	.word	70,0		;150,20
	.word	0,-40,40
	.word	0,-50,-20

player_speed_data
	.long	pspeed_data_1_11
	.long	pspeed_data_2_10
	.long	pspeed_data_3_21
	.long	pspeed_data_4_20
	.long	pspeed_data_5_31
	.long	pspeed_data_6_30
	.long	pspeed_data_7_41
	.long	pspeed_data_8_40
	.long	pspeed_data_9_51
	.long	pspeed_data10_50
	.LONG	PSPEED_GOALIE_DATA
player_stop_data
	.long	pstop_data_1
	.long	pstop_data_2
	.long	pstop_data_3
	.long	pstop_data_4
	.long	pstop_data_5
	.LONG	PSTOP_GOALIE_DATA
player_corner_data
	.long	pcorner_data_1
	.long	pcorner_data_2
	.long	pcorner_data_3
	.long	pcorner_data_4
	.long	pcorner_data_5
player_shoot_data
	.long	pshoot_data_1
	.long	pshoot_data_2
	.long	pshoot_data_3
	.long	pshoot_data_4
	.long	pshoot_data_5
player_pass_data
	.long	ppass_data_1
	.long	ppass_data_2
	.long	ppass_data_3
	.long	ppass_data_4
	.long	ppass_data_5
;player_dump_data
;	.long	pdump_data_1
player_face_data
	.long	pface_data_1
	.long	pface_data_2
	.long	pface_data_3
	.long	pface_data_4
	.long	pface_data_5
player_handle_data
	.long	phandle_data_1
	.long	phandle_data_2
	.long	phandle_data_3
	.long	phandle_data_4
	.long	phandle_data_5
	.LONG	PHANDLE_GOALIE_DATA
player_check_data
	.long	pcheck_data_1
	.long	pcheck_data_2
	.long	pcheck_data_3
	.long	pcheck_data_4
	.long	pcheck_data_5

pspeed_data_1_11
pspeed_data_3_21
	.long	[4,00000h],[5,0F000h],[6,0D000h]	;speed_0,speed_1,speed_2
	.long	[2,0b000h],[5,09000h]		;speed_0_thresh,speed_thresh
	.long	[4,0E000h],[8,0C000h],[9,0B000h]		;turbo_0,turbo_1,turbo_2
	.long	[2,0d000h],[8,03000h]		;turbo_0_thresh,turbo_thresh
	.long	[1,06800h],[0,01000h]		;defense_boost,puck control penalty
	.byte	12+2,16,2				;same_0_mt,same_l_mt,same_h_mt
	.byte	0				;nothing
	.word	12925,19387			;turbo_down,turbo_up
pspeed_data_2_10
pspeed_data_4_20
	.long	[4,00000h],[5,0F000h],[6,0D000h]	;speed_0,speed_1,speed_2
	.long	[2,0b000h],[5,09000h]		;speed_0_thresh,speed_thresh
	.long	[4,0E000h],[8,0C000h],[9,0B000h]		;turbo_0,turbo_1,turbo_2
	.long	[2,0d000h],[8,03000h]		;turbo_0_thresh,turbo_thresh
	.long	[1,06800h],[0,00800h]		;defense_boost,puck control penalty
	.byte	12+2,16,2				;same_0_mt,same_l_mt,same_h_mt
	.byte	0				;nothing
	.word	12925,19387			;turbo_down,turbo_up

pspeed_data_5_31
	.long	[4,02000h],[6,02000h],[7,00000h]	;speed_0,speed_1,speed_2
	.long	[2,0E000h],[5,0E000h]		;speed_0_thresh,speed_thresh
	.long	[5,00000h],[9,00000h],[10,00000h]		;turbo_0,turbo_1,turbo_2
	.long	[3,00000h],[8,0E000h]		;turbo_0_thresh,turbo_thresh
	.long	[1,06000h],[0,02000h]		;defense_boost,puck control penalty
	.byte	12+2,16,2				;same_0_mt,same_l_mt,same_h_mt
	.byte	0				;nothing
	.word	12925,19387			;turbo_down,turbo_up
pspeed_data_6_30
	.long	[4,02000h],[6,02000h],[7,00000h]	;speed_0,speed_1,speed_2
	.long	[2,0E000h],[5,0E000h]		;speed_0_thresh,speed_thresh
	.long	[5,00000h],[9,00000h],[10,00000h]		;turbo_0,turbo_1,turbo_2
	.long	[3,00000h],[8,0E000h]		;turbo_0_thresh,turbo_thresh
	.long	[1,06000h],[0,01000h]		;defense_boost,puck control penalty
	.byte	12+2,16,2				;same_0_mt,same_l_mt,same_h_mt
	.byte	0				;nothing
	.word	12925,19387			;turbo_down,turbo_up

pspeed_data_7_41
	.long	[4,05000h],[6,07000h],[7,06000h]	;speed_0,speed_1,speed_2
	.long	[3,00000h],[6,03000h]		;speed_0_thresh,speed_thresh
	.long	[5,04000h],[9,07000h],[10,08000h]		;turbo_0,turbo_1,turbo_2
	.long	[3,02000h],[9,05000h]		;turbo_0_thresh,turbo_thresh
	.long	[1,06000h],[0,02000h]		;defense_boost,puck control penalty
	.byte	12+2,16,2				;same_0_mt,same_l_mt,same_h_mt
	.byte	0				;nothing
	.word	12925,19387			;turbo_down,turbo_up
pspeed_data_8_40
	.long	[4,05000h],[6,07000h],[7,06000h]	;speed_0,speed_1,speed_2
	.long	[3,00000h],[6,03000h]		;speed_0_thresh,speed_thresh
	.long	[5,04000h],[9,07000h],[10,08000h]		;turbo_0,turbo_1,turbo_2
	.long	[3,02000h],[9,05000h]		;turbo_0_thresh,turbo_thresh
	.long	[1,06000h],[0,01000h]		;defense_boost,puck control penalty
	.byte	12+2,16,2				;same_0_mt,same_l_mt,same_h_mt
	.byte	0				;nothing
	.word	12925,19387			;turbo_down,turbo_up

pspeed_data_9_51
	.long	[4,09000h],[6,0C000h],[7,0B000h]	;speed_0,speed_1,speed_2
	.long	[3,03000h],[6,07000h]		;speed_0_thresh,speed_thresh
	.long	[5,08000h],[9,0E000h],[11,00000h]		;turbo_0,turbo_1,turbo_2
	.long	[3,05000h],[9,0C000h]		;turbo_0_thresh,turbo_thresh
	.long	[1,06000h],[0,03000h]		;defense_boost,puck control penalty
	.byte	12+2,16,2				;same_0_mt,same_l_mt,same_h_mt
	.byte	0				;nothing
	.word	12925,19387			;turbo_down,turbo_up
pspeed_data10_50
	.long	[4,09000h],[6,0C000h],[7,0B000h]	;speed_0,speed_1,speed_2
	.long	[3,03000h],[6,07000h]		;speed_0_thresh,speed_thresh
	.long	[5,08000h],[9,0E000h],[11,00000h]		;turbo_0,turbo_1,turbo_2
	.long	[3,05000h],[9,0C000h]		;turbo_0_thresh,turbo_thresh
	.long	[1,06000h],[0,01800h]		;defense_boost,puck control penalty
	.byte	12+2,16,2				;same_0_mt,same_l_mt,same_h_mt
	.byte	0				;nothing
	.word	12925,19387			;turbo_down,turbo_up

pspeed_data_powered		;power up speed
	.long	[5,09000h],[6,0C000h],[7,0B000h]	;speed_0,speed_1,speed_2
	.long	[3,03000h],[6,07000h]		;speed_0_thresh,speed_thresh
	.long	[7,00000h],[9,0E000h],[11,00000h]		;turbo_0,turbo_1,turbo_2
	.long	[3,05000h],[9,0C000h]		;turbo_0_thresh,turbo_thresh
	.long	[1,06000h],[0,01800h]		;defense_boost,puck control penalty
	.byte	13+2,17,3				;same_0_mt,same_l_mt,same_h_mt
	.byte	0				;nothing
	.word	12925,19387			;turbo_down,turbo_up

PSPEED_GOALIE_DATA
;	.long	[4,0],[6,0],[7,0]		;speed_0,speed_1,speed_2
;	.long	[3,0],[5,0e000h]		;speed_0_thresh,speed_thresh
;	.long	[9,0],[9,0],[10,0]		;turbo_0,turbo_1,turbo_2
;	.long	[3,0],[8,0e000h]		;turbo_0_thresh,turbo_thresh
;	.long	[1,0],[0,03000h]		;defense_boost,puck control penalty
;	.byte	12,16,2				;same_0_mt,same_l_mt,same_h_mt
;	.byte	0				;nothing
;	.word	12925,19387			;turbo_down,turbo_up

	.long	[11,0],[11,0],[11,0]		;speed_0,speed_1,speed_2
	.long	[9,0],[10,0]			;speed_0_thresh,speed_thresh
	.long	[13,0],[11,0],[11,0]		;turbo_0,turbo_1,turbo_2
	.long	[9,08000H],[10,08000H]		;turbo_0_thresh,turbo_thresh
	.long	[0,0],[0,0]			;defense_boost,puck control penalty
	.byte	12,13,1				;same_0_mt,same_l_mt,same_h_mt
	.byte	0				;nothing
	.word	12925,19387			;turbo_down,turbo_up

pstop_data_1
	.long	[0,08000h],[1,0]		;stop_thresh,rstop_thresh
	.byte	22,22,36,22			;skid_r_mt,skid_s_mt,tskid_r_mt,tskid_s_mt
	.byte	13				;defense_skid_mt_boost
	.byte	0				;nothing
pstop_data_2
	.long	[0,08000h],[1,0]		;stop_thresh,rstop_thresh
	.byte	24,24,38,24			;skid_r_mt,skid_s_mt,tskid_r_mt,tskid_s_mt
	.byte	14				;defense_skid_mt_boost
	.byte	0				;nothing
pstop_data_3
	.long	[0,08000h],[1,0]		;stop_thresh,rstop_thresh
	.byte	25,25,40,25			;skid_r_mt,skid_s_mt,tskid_r_mt,tskid_s_mt
	.byte	15				;defense_skid_mt_boost
	.byte	0				;nothing
pstop_data_4
	.long	[0,08000h],[1,0]		;stop_thresh,rstop_thresh
	.byte	26,26,42,26			;skid_r_mt,skid_s_mt,tskid_r_mt,tskid_s_mt
	.byte	16				;defense_skid_mt_boost
	.byte	0				;nothing
pstop_data_5
	.long	[0,08000h],[1,0]		;stop_thresh,rstop_thresh
	.byte	28,28,44,28			;skid_r_mt,skid_s_mt,tskid_r_mt,tskid_s_mt
	.byte	17				;defense_skid_mt_boost
	.byte	0				;nothing

PSTOP_GOALIE_DATA
	.long	[1,0],[1,0]			;stop_thresh,rstop_thresh
	.byte	64,64,80,80			;skid_r_mt,skid_s_mt,tskid_r_mt,tskid_s_mt
	.byte	0				;defense_skid_mt_boost
	.byte	0				;nothing

pcorner_data_1
	.long	XD0900
	.long	turn_table_r1
	.long	turn_table_d1
	.long	turn_table_c3
pcorner_data_2
	.long	XD0900
	.long	turn_table_r2
	.long	turn_table_d2
	.long	turn_table_c3
pcorner_data_3
	.long	XD0900
	.long	turn_table_r3
	.long	turn_table_d3
	.long	turn_table_c3
pcorner_data_4
	.long	XD0900
	.long	turn_table_r4
	.long	turn_table_d4
	.long	turn_table_c3
pcorner_data_5
	.long	XD0900
	.long	turn_table_r5
	.long	turn_table_d5
	.long	turn_table_c3

turn_table_r1
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0010,XD0009
	.long	XD0200,XD0010,XD0018
	.long	XD0300,XD0010,XD0027
	.long	XD0400,XD0010,XD0036
	.long	XD0500,XD0010,XD0045
	.long	XD3600,XD0010,XD0054
turn_table_r2
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0010,XD0010
	.long	XD0200,XD0010,XD0019
	.long	XD0300,XD0010,XD0029
	.long	XD0400,XD0010,XD0038
	.long	XD0500,XD0010,XD0048
	.long	XD3600,XD0010,XD0057
turn_table_r3
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0010,XD0010
	.long	XD0200,XD0010,XD0020
	.long	XD0300,XD0010,XD0030
	.long	XD0400,XD0010,XD0040
	.long	XD0500,XD0010,XD0050
	.long	XD3600,XD0010,XD0060
turn_table_r4
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0010,XD0010
	.long	XD0200,XD0010,XD0021
	.long	XD0300,XD0010,XD0031
	.long	XD0400,XD0010,XD0042
	.long	XD0500,XD0010,XD0052
	.long	XD3600,XD0010,XD0063
turn_table_r5
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0010,XD0011
	.long	XD0200,XD0010,XD0022
	.long	XD0300,XD0010,XD0033
	.long	XD0400,XD0010,XD0044
	.long	XD0500,XD0010,XD0055
	.long	XD3600,XD0010,XD0066

turn_table_d1
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0014,XD0021
	.long	XD0200,XD0019,XD0030
	.long	XD0300,XD0019,XD0039
	.long	XD0400,XD0019,XD0048
	.long	XD0500,XD0019,XD0057
	.long	XD3600,XD0019,XD0066
turn_table_d2
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0014,XD0022
	.long	XD0200,XD0019,XD0031
	.long	XD0300,XD0019,XD0041
	.long	XD0400,XD0019,XD0050
	.long	XD0500,XD0019,XD0060
	.long	XD3600,XD0019,XD0070
turn_table_d3
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0014,XD0023
	.long	XD0200,XD0019,XD0033
	.long	XD0300,XD0019,XD0043
	.long	XD0400,XD0019,XD0053
	.long	XD0500,XD0019,XD0063
	.long	XD3600,XD0019,XD0073
turn_table_d4
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0014,XD0024
	.long	XD0200,XD0019,XD0035
	.long	XD0300,XD0019,XD0045
	.long	XD0400,XD0019,XD0056
	.long	XD0500,XD0019,XD0066
	.long	XD3600,XD0019,XD0077
turn_table_d5
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0014,XD0025
	.long	XD0200,XD0019,XD0036
	.long	XD0300,XD0019,XD0047
	.long	XD0400,XD0019,XD0058
	.long	XD0500,XD0019,XD0069
	.long	XD3600,XD0019,XD0080

turn_table_c3
;	.long	max angle difference,angle acceleration, max angle velocity

	.long	XD0100,XD0010,XD0020
	.long	XD0200,XD0015,XD0040
	.long	XD0300,XD0020,XD0060
	.long	XD0400,XD0020,XD0080
	.long	XD0500,XD0020,XD0100
	.long	XD3600,XD0020,XD0120

pshoot_data_1
	.long	[14,06000h],[16,03000h],[14,08000h],[20,04000h]	;shoot0_speed,shoot_speed,shoot0_turbo,shoot_turbo
	.long	[5,0]				;max_y
	.byte	48,48				;shoot_mt,shoot_turbo_mt
	.long	change_shot,change_tshot	;shot_change,tshot_change
pshoot_data_2
	.long	[15,03000h],[17,02000h],[15,06000h],[21,06000h]	;shoot0_speed,shoot_speed,shoot0_turbo,shoot_turbo
	.long	[5,0]				;max_y
	.byte	48,48				;shoot_mt,shoot_turbo_mt
	.long	change_shot,change_tshot	;shot_change,tshot_change
pshoot_data_3
	.long	[16,00000h],[18,00000h],[16,03000h],[22,08000h]	;shoot0_speed,shoot_speed,shoot0_turbo,shoot_turbo
	.long	[5,0]				;max_y
	.byte	48,48				;shoot_mt,shoot_turbo_mt
	.long	change_shot,change_tshot	;shot_change,tshot_change
pshoot_data_4
	.long	[16,0D000h],[18,0E000h],[16,0f000h],[23,0a000h]	;shoot0_speed,shoot_speed,shoot0_turbo,shoot_turbo
	.long	[5,0]				;max_y
	.byte	48,48				;shoot_mt,shoot_turbo_mt
	.long	change_shot,change_tshot	;shot_change,tshot_change
pshoot_data_5
	.long	[17,0A000h],[19,0D000h],[17,0D000h],[24,0c000h]	;shoot0_speed,shoot_speed,shoot0_turbo,shoot_turbo
	.long	[5,0]				;max_y
	.byte	48,48				;shoot_mt,shoot_turbo_mt
	.long	change_shot,change_tshot	;shot_change,tshot_change

shoot_data_powered
	.long	[20,00000h],[20,0D000h],[21,06000h],[24,0c000h]	;shoot0_speed,shoot_speed,shoot0_turbo,shoot_turbo
	.long	[5,0]				;max_y
	.byte	48,48				;shoot_mt,shoot_turbo_mt
	.long	change_shot,change_tshot	;shot_change,tshot_change


ppass_data_1
	.long	[11,01000h],[14,08000h]			;pass_speed,pass_turbo
	.word	300,700,250,600			;pass_gthresh,pass_mthresh,tpass_gthresh,tpass_mthresh
	.long	change_pass,change_tpass	;pass_change,tpass_change
ppass_data_2
	.long	[11,0c000h],[15,05000h]			;pass_speed,pass_turbo
	.word	300,700,250,600			;pass_gthresh,pass_mthresh,tpass_gthresh,tpass_mthresh
	.long	change_pass,change_tpass	;pass_change,tpass_change
ppass_data_3
	.long	[12,05000h],[16,02000h]			;pass_speed,pass_turbo
	.word	300,700,250,600			;pass_gthresh,pass_mthresh,tpass_gthresh,tpass_mthresh
	.long	change_pass,change_tpass	;pass_change,tpass_change
ppass_data_4
	.long	[12,0f000h],[16,0f000h]			;pass_speed,pass_turbo
	.word	300,700,250,600			;pass_gthresh,pass_mthresh,tpass_gthresh,tpass_mthresh
	.long	change_pass,change_tpass	;pass_change,tpass_change
ppass_data_5
	.long	[13,09000h],[17,0c000h]			;pass_speed,pass_turbo
	.word	300,700,250,600			;pass_gthresh,pass_mthresh,tpass_gthresh,tpass_mthresh
	.long	change_pass,change_tpass	;pass_change,tpass_change
pass_data_powered
	.long	[17,06000h],[18,0B000h]			;pass_speed,pass_turbo
	.word	300,700,250,600			;pass_gthresh,pass_mthresh,tpass_gthresh,tpass_mthresh
	.long	change_pass,change_tpass	;pass_change,tpass_change

;pdump_data_1
;	.long	[8,0],[10,0]			;dump_speed,dump_turbo
;	.long	change_dump,change_tdump	;dump_change,tdump_change

pface_data_1
	.word	1
pface_data_2
	.word	5
pface_data_3
	.word	7
pface_data_4
	.word	11
pface_data_5
	.word	15

phandle_data_1
	.long	int_control,off_control1	;int_control,off_control
	.long	def_control1			;def_control
phandle_data_2
	.long	int_control,off_control2	;int_control,off_control
	.long	def_control2			;def_control
phandle_data_3
	.long	int_control,off_control3	;int_control,off_control
	.long	def_control3			;def_control
phandle_data_4
	.long	int_control,off_control4	;int_control,off_control
	.long	def_control4			;def_control
phandle_data_5
	.long	int_control,off_control5	;int_control,off_control
	.long	def_control5			;def_control

PHANDLE_GOALIE_DATA
	.long	int_control,GOFF_CONTROL	;int_control,off_control
	.long	GDEF_CONTROL			;def_control

pcheck_data_1
	.long	[2,0],[5,0]			;check nobody loss, check somone loss
	.long	[4,0]				;check down guy loss
	.word	1
pcheck_data_2
	.long	[2,0],[5,0]			;check nobody loss, check somone loss
	.long	[4,0]				;check down guy loss
	.word	2
pcheck_data_3
	.long	[2,0],[5,0]			;check nobody loss, check somone loss
	.long	[4,0]				;check down guy loss
	.word	3
pcheck_data_4
	.long	[2,0],[5,0]			;check nobody loss, check somone loss
	.long	[4,0]				;check down guy loss
	.word	4
pcheck_data_5
	.long	[2,0],[5,0]			;check nobody loss, check somone loss
	.long	[4,0]				;check down guy loss
	.word	5

