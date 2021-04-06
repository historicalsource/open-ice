	.MLIB	"HHMACS.LIB"
	.FILE	"HHSPEECH.ASM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

	.INCLUDE	"HH.INC"		;Game equates
	.include	"hhspech2.e"

; end of include files

nmb_tab	.long	sp_s0
	.long	sp_s1
	.long	sp_s2
	.long	sp_s3
	.long	sp_s4
	.long	sp_s5
	.long	sp_s6
	.long	sp_s7
	.long	sp_s8
	.long	sp_s9
	.long	sp_s10
	.long	sp_s11
	.long	sp_s12
	.long	sp_s13
	.long	sp_s14
	.long	sp_s15
	.long	sp_s16
	.long	sp_s17
	.long	sp_s18
	.long	sp_s19
	.long	sp_s20

sp_s0	.word	00ac9h,-28+5,0		;Nothing
sp_s1	.word	00ab5h,-27+5,0		;One
sp_s2	.word	00ab6h,-27+5,0		;Two
sp_s3	.word	00ab7h,-28+5,0		;Three
sp_s4	.word	00ab8h,-28+5,0		;Four
sp_s5	.word	00ab9h,-33+5,0		;Five
sp_s6	.word	00abah,-28+5,0		;Six
sp_s7	.word	00abbh,-28+5,0		;Seven
sp_s8	.word	00abch,-22+5,0		;Eight
sp_s9	.word	00abdh,-32+5,0		;Nine
sp_s10	.word	00abeh,-31+5,0		;Ten
sp_s11	.word	00abfh,-35+5,0		;Eleven
sp_s12	.word	00ac0h,-32+5,0		;Twelve
sp_s13	.word	00ac1h,-44+5,0		;Thirteen
sp_s14	.word	00ac2h,-47+5,0		;Fourteen
sp_s15	.word	00ac3h,-46+5,0		;Fifteen
sp_s16	.word	00ac4h,-53+5,0		;Sixteen
sp_s17	.word	00ac5h,-51+5,0		;Seventeen
sp_s18	.word	00ac6h,-43+5,0		;Eighteen
sp_s19	.word	00ac7h,-48+5,0		;Nineteen
sp_s20	.word	00ac8h,-29+5,0		;Twenty

nm_tab	.long	sp_none
	.long	sp_messier
	.long	sp_nedved
	.long	sp_maclean
	.long	sp_richer
	.long	sp_juneau
	.long	sp_bondra
	.long	sp_lindros
	.long	sp_brindamour
	.long	sp_muller
	.long	sp_thomas
	.long	sp_murphy
	.long	sp_mellanby
	.long	sp_bradley
	.long	sp_klima
	.long	sp_jagr
	.long	sp_robitaille
	.long	sp_sakic
	.long	sp_clark
	.long	sp_lafontaine
	.long	sp_mogilny
	.long	sp_damphousse
	.long	sp_recchi
	.long	sp_bourque
	.long	sp_neely
	.long	sp_cassels
	.long	sp_sanderson
	.long	sp_daigle
	.long	sp_yashin
	.long	sp_fedorov
	.long	sp_yzerman
	.long	sp_gilmour
	.long	sp_andreychuk
	.long	sp_hull
	.long	sp_shanahan
	.long	sp_nicholls
	.long	sp_chelios
	.long	sp_selanne
	.long	sp_tkachuk
	.long	sp_modano
	.long	sp_hatcher
	.long	sp_bure
	.long	sp_linden
	.long	sp_fleury
	.long	sp_reichel
	.long	sp_ozolinsh
	.long	sp_dahlen
	.long	sp_gretzky
	.long	sp_kurri
	.long	sp_kariya
	.long	sp_kurvers
	.long	sp_kravchuk
	.long	sp_corson
	.long	sp_richter
	.long	sp_brodeur
	.long	sp_carey
	.long	sp_hextall
	.long	sp_mclennan
	.long	sp_vanbiesbrouck
	.long	sp_puppa
	.long	sp_wregget
	.long	sp_fiset
	.long	sp_hasek
	.long	sp_roy
	.long	sp_lacher
	.long	sp_burke
	.long	sp_beaupre
	.long	sp_vernon
	.long	sp_potvin
	.long	sp_joseph
	.long	sp_belfour
	.long	sp_chevaldae
	.long	sp_moog
	.long	sp_mclean
	.long	sp_kidd
	.long	sp_irbe
	.long	sp_hrudey
	.long	sp_hebert
	.long	sp_ranford
	.long	sp_roenick
	.long	sp_corkum
	.long	sp_oates
	.long	sp_plante
	.long	sp_housley
	.long	sp_savard
	.long	sp_gagner
	.long	sp_coffey
	.long	sp_ciccarelli
	.long	sp_weight
	.long	sp_arnott
	.long	sp_belanger
	.long	sp_tocchet
	.long	sp_turgeon
	.long	sp_clemieux
	.long	sp_stevens
	.long	sp_ferraro
	.long	sp_leetch
	.long	sp_bonk
	.long	sp_renberg
	.long	sp_desjardins
	.long	sp_mlemieux
	.long	sp_nolan
	.long	sp_makarov
	.long	sp_tikkanen
	.long	sp_hamrlik
	.long	sp_sundin
	.long	sp_cote
	.long	sp_zhamnov
	.long	sp_hawerchuk
	.long	sp_bodger
	.long	sp_king
	.long	sp_nieuwendyk
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_casey
	.long	sp_kstevens
	.long	sp_zalapski
	.long	sp_janney
	.long	sp_howe
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_soderstrom
	.long	sp_osgood
	.long	sp_fuhr
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none

nmt_tab	.long	sp_none
	.long	sp_to_messier
	.long	sp_to_nedved
	.long	sp_to_maclean
	.long	sp_to_richer
	.long	sp_to_juneau
	.long	sp_to_bondra
	.long	sp_to_lindros
	.long	sp_to_brindamour
	.long	sp_to_muller
	.long	sp_to_thomas
	.long	sp_to_murphy
	.long	sp_to_mellanby
	.long	sp_to_bradley
	.long	sp_to_klima
	.long	sp_to_jagr
	.long	sp_to_robitaille
	.long	sp_to_sakic
	.long	sp_to_clark
	.long	sp_to_lafontaine
	.long	sp_to_mogilny
	.long	sp_to_damphousse
	.long	sp_to_recchi
	.long	sp_to_bourque
	.long	sp_to_neely
	.long	sp_to_cassels
	.long	sp_to_sanderson
	.long	sp_to_daigle
	.long	sp_to_yashin
	.long	sp_to_fedorov
	.long	sp_to_yzerman
	.long	sp_to_gilmour
	.long	sp_to_andreychuk
	.long	sp_to_hull
	.long	sp_to_shanahan
	.long	sp_to_nicholls
	.long	sp_to_chelios
	.long	sp_to_selanne
	.long	sp_to_tkachuk
	.long	sp_to_modano
	.long	sp_to_hatcher
	.long	sp_to_bure
	.long	sp_to_linden
	.long	sp_to_fleury
	.long	sp_to_reichel
	.long	sp_to_ozolinsh
	.long	sp_to_dahlen
	.long	sp_to_gretzky
	.long	sp_to_kurri
	.long	sp_to_kariya
	.long	sp_to_kurvers
	.long	sp_to_kravchuk
	.long	sp_to_corson
	.long	sp_by_richter
	.long	sp_by_brodeur
	.long	sp_by_carey
	.long	sp_by_hextall
	.long	sp_by_mclennan
	.long	sp_by_vanbiesbrouck
	.long	sp_by_puppa
	.long	sp_by_wregget
	.long	sp_by_fiset
	.long	sp_by_hasek
	.long	sp_by_roy
	.long	sp_by_lacher
	.long	sp_by_burke
	.long	sp_by_beaupre
	.long	sp_by_vernon
	.long	sp_by_potvin
	.long	sp_by_joseph
	.long	sp_by_belfour
	.long	sp_by_chevaldae
	.long	sp_by_moog
	.long	sp_by_mclean
	.long	sp_by_kidd
	.long	sp_by_irbe
	.long	sp_by_hrudey
	.long	sp_by_hebert
	.long	sp_by_ranford
	.long	sp_to_roenick
	.long	sp_to_corkum
	.long	sp_to_oates
	.long	sp_to_plante
	.long	sp_to_housley
	.long	sp_to_savard
	.long	sp_to_gagner
	.long	sp_to_coffey
	.long	sp_to_ciccarelli
	.long	sp_to_weight
	.long	sp_to_arnott
	.long	sp_to_belanger
	.long	sp_to_tocchet
	.long	sp_to_turgeon
	.long	sp_to_clemieux
	.long	sp_to_stevens
	.long	sp_to_ferraro
	.long	sp_to_leetch
	.long	sp_to_bonk
	.long	sp_to_renberg
	.long	sp_to_desjardins
	.long	sp_to_mlemieux
	.long	sp_to_nolan
	.long	sp_to_makarov
	.long	sp_to_tikkanen
	.long	sp_to_hamrlik
	.long	sp_to_sundin
	.long	sp_to_cote
	.long	sp_to_zhamnov
	.long	sp_to_hawerchuk
	.long	sp_to_bodger
	.long	sp_to_king
	.long	sp_to_nieuwendyk
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_by_casey
	.long	sp_to_kstevens
	.long	sp_to_zalapski
	.long	sp_to_janney
	.long	sp_to_howe
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_by_soderstrom
	.long	sp_by_osgood
	.long	sp_by_fuhr
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none

fnm_tab		;full
	.long	sp_none
	.long	sp_mark_messier
	.long	sp_petr_nedved
	.long	sp_john_maclean
	.long	sp_stephane_richer
	.long	sp_joe_juneau
	.long	sp_peter_bondra
	.long	sp_eric_lindros
	.long	sp_rod_brindamour
	.long	sp_kirk_muller
	.long	sp_steve_thomas
	.long	sp_gord_murphy
	.long	sp_scott_mellanby
	.long	sp_brian_bradley
	.long	sp_petr_klima
	.long	sp_jaromir_jagr
	.long	sp_luc_robitaille
	.long	sp_joe_sakic
	.long	sp_wendel_clark
	.long	sp_pat_lafontaine
	.long	sp_alexander_mogilny
	.long	sp_vincent_damphousse
	.long	sp_mark_recchi
	.long	sp_ray_bourque
	.long	sp_cam_neely
	.long	sp_andrew_cassels
	.long	sp_geoff_sanderson
	.long	sp_alexandre_daigle
	.long	sp_alexei_yashin
	.long	sp_sergei_fedorov
	.long	sp_steve_yzerman
	.long	sp_doug_gilmour
	.long	sp_dave_andreychuk
	.long	sp_brett_hull
	.long	sp_brendan_shanahan
	.long	sp_bernie_nicholls
	.long	sp_chris_chelios
	.long	sp_teemu_selanne
	.long	sp_keith_tkachuk
	.long	sp_mike_modano
	.long	sp_kevin_hatcher
	.long	sp_pavel_bure
	.long	sp_trevor_linden
	.long	sp_theoren_fleury
	.long	sp_robert_reichel
	.long	sp_sandis_ozolinsh
	.long	sp_ulf_dahlen
	.long	sp_wayne_gretzky
	.long	sp_jari_kurri
	.long	sp_paul_kariya
	.long	sp_tom_kurvers
	.long	sp_igor_kravchuk
	.long	sp_shayne_corson
	.long	sp_mike_richter
	.long	sp_martin_brodeur
	.long	sp_jim_carey
	.long	sp_ron_hextall
	.long	sp_jamie_mclennan
	.long	sp_john_vanbiesbrouck
	.long	sp_darren_puppa
	.long	sp_ken_wregget
	.long	sp_stephane_fiset
	.long	sp_dominik_hasek
	.long	sp_patrick_roy
	.long	sp_blaine_lacher
	.long	sp_sean_burke
	.long	sp_don_beaupre
	.long	sp_mike_vernon
	.long	sp_felix_potvin
	.long	sp_curtis_joseph
	.long	sp_ed_belfour
	.long	sp_tim_chevaldae
	.long	sp_andy_moog
	.long	sp_kirk_mclean
	.long	sp_trevor_kidd
	.long	sp_arturs_irbe
	.long	sp_kelly_hrudey
	.long	sp_guy_hebert
	.long	sp_bill_ranford
	.long	sp_jeremy_roenick
	.long	sp_bob_corkum
	.long	sp_adam_oates
	.long	sp_derek_plante
	.long	sp_phil_housley
	.long	sp_denis_savard
	.long	sp_dave_gagner
	.long	sp_paul_coffey
	.long	sp_dino_ciccarelli
	.long	sp_doug_weight
	.long	sp_jason_arnott
	.long	sp_jesse_belanger
	.long	sp_rick_tocchet
	.long	sp_pierre_turgeon
	.long	sp_claude_lemieux
	.long	sp_scott_stevens
	.long	sp_ray_ferraro
	.long	sp_brian_leetch
	.long	sp_radek_bonk
	.long	sp_mikael_renberg
	.long	sp_eric_desjardins
	.long	sp_mario_lemieux
	.long	sp_owen_nolan
	.long	sp_sergei_makarov
	.long	sp_esa_tikkanen
	.long	sp_roman_hamrlik
	.long	sp_mats_sundin
	.long	sp_sylvain_cote
	.long	sp_alexei_zhamnov
	.long	sp_dale_hawerchuk
	.long	sp_doug_bodger
	.long	sp_derek_king
	.long	sp_joe_nieuwendyk
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_jon_casey
	.long	sp_kevin_stevens
	.long	sp_zarley_zalapski
	.long	sp_craig_janney
	.long	sp_gordie_howe
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_tommy_soderstrom
	.long	sp_chris_osgood
	.long	sp_grant_fuhr
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none

fnnm_tab		;full names or nicknames
	.long	sp_none
	.long	sp_mark_messier
	.long	sp_petr_nedved
	.long	sp_john_maclean
	.long	sp_stephane_richer
	.long	sp_joe_juneau
	.long	sp_peter_bondra
	.long	sp_eric_lindros
	.long	sp_rod_brindamour
	.long	sp_kirk_muller
	.long	sp_steve_thomas
	.long	sp_gord_murphy
	.long	sp_scott_mellanby
	.long	sp_brian_bradley
	.long	sp_petr_klima
	.long	sp_nickname_jagr
	.long	sp_nickname_robitaille
	.long	sp_joe_sakic
	.long	sp_wendel_clark
	.long	sp_pat_lafontaine
	.long	sp_alexander_mogilny
	.long	sp_vincent_damphousse
	.long	sp_mark_recchi
	.long	sp_ray_bourque
	.long	sp_cam_neely
	.long	sp_andrew_cassels
	.long	sp_geoff_sanderson
	.long	sp_alexandre_daigle
	.long	sp_alexei_yashin
	.long	sp_sergei_fedorov
	.long	sp_steve_yzerman
	.long	sp_nickname_gilmour
	.long	sp_dave_andreychuk
	.long	sp_nickname_hull
	.long	sp_brendan_shanahan
	.long	sp_bernie_nicholls
	.long	sp_chris_chelios
	.long	sp_nickname_selanne
	.long	sp_keith_tkachuk
	.long	sp_mike_modano
	.long	sp_kevin_hatcher
	.long	sp_nickname_bure
	.long	sp_trevor_linden
	.long	sp_theoren_fleury
	.long	sp_robert_reichel
	.long	sp_sandis_ozolinsh
	.long	sp_ulf_dahlen
	.long	sp_nickname_gretzky
	.long	sp_jari_kurri
	.long	sp_paul_kariya
	.long	sp_tom_kurvers
	.long	sp_igor_kravchuk
	.long	sp_shayne_corson
	.long	sp_mike_richter
	.long	sp_martin_brodeur
	.long	sp_nickname_carey
	.long	sp_ron_hextall
	.long	sp_jamie_mclennan
	.long	sp_nickname_vanbiesbrouck
	.long	sp_darren_puppa
	.long	sp_ken_wregget
	.long	sp_stephane_fiset
	.long	sp_nickname_hasek
	.long	sp_patrick_roy
	.long	sp_nickname_lacher
	.long	sp_sean_burke
	.long	sp_don_beaupre
	.long	sp_mike_vernon
	.long	sp_nickname_potvin
	.long	sp_nickname_joseph
	.long	sp_nickname_belfour
	.long	sp_tim_chevaldae
	.long	sp_andy_moog
	.long	sp_kirk_mclean
	.long	sp_trevor_kidd
	.long	sp_arturs_irbe
	.long	sp_kelly_hrudey
	.long	sp_guy_hebert
	.long	sp_bill_ranford
	.long	sp_nickname_roenick
	.long	sp_bob_corkum
	.long	sp_adam_oates
	.long	sp_derek_plante
	.long	sp_phil_housley
	.long	sp_nickname_savard
	.long	sp_dave_gagner
	.long	sp_paul_coffey
	.long	sp_dino_ciccarelli
	.long	sp_doug_weight
	.long	sp_jason_arnott
	.long	sp_jesse_belanger
	.long	sp_rick_tocchet
	.long	sp_pierre_turgeon
	.long	sp_claude_lemieux
	.long	sp_scott_stevens
	.long	sp_ray_ferraro
	.long	sp_brian_leetch
	.long	sp_radek_bonk
	.long	sp_mikael_renberg
	.long	sp_eric_desjardins
	.long	sp_nickname_mlemieux
	.long	sp_owen_nolan
	.long	sp_sergei_makarov
	.long	sp_esa_tikkanen
	.long	sp_roman_hamrlik
	.long	sp_mats_sundin
	.long	sp_sylvain_cote
	.long	sp_alexei_zhamnov
	.long	sp_dale_hawerchuk
	.long	sp_doug_bodger
	.long	sp_derek_king
	.long	sp_joe_nieuwendyk
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_jon_casey
	.long	sp_kevin_stevens
	.long	sp_zarley_zalapski
	.long	sp_craig_janney
	.long	sp_nickname_howe
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_tommy_soderstrom
	.long	sp_chris_osgood
	.long	sp_grant_fuhr
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none

sp_mark_messier
	.word	00beah,-21		;mark (messier)
	.word	00be6h,-65,0		;messier 1
sp_messier
	.word	10,2
	.long	saa1,saa3
saa1	.word	00be6h,-65,0		;messier 1
saa3	.word	00be9h,-42,0		;messier 4
sp_to_messier
	.word	10,2
	.long	sab1,sab3
sab1	.word	01469h,-79,0		;to messier 1
sab3	.word	0146ch,-56,0		;to messier 4

sp_petr_nedved
	.word	00bech,-23		;petr (nedved)
	.word	00bebh,-52,0		;nedved 1
sp_nedved
	.word	10,2
	.long	sac1,sac3
sac1	.word	00bebh,-52,0		;nedved 1
sac3	.word	00beeh,-29,0		;nedved 3
sp_to_nedved
	.word	10,2
	.long	sad1,sad3
sad1	.word	0146dh,-67,0		;to nedved 1
sad3	.word	0146fh,-43,0		;to nedved 3

sp_john_maclean
	.word	00bf6h,-23		;john (maclean)
	.word	00bf5h,-57,0		;maclean 2
sp_maclean
	.word	10,2
	.long	sae2,sae3
sae2	.word	00bf5h,-57,0		;maclean 2
sae3	.word	00bf7h,-41,0		;maclean 3
sp_to_maclean
	.word	10,2
	.long	saf2,saf3
saf2	.word	01471h,-71,0		;to maclean 2
saf3	.word	01472h,-55,0		;to maclean 3

sp_stephane_richer
	.word	00bfah,-36		;stephane (richer)
	.word	00bfbh,-45,0		;richer 3
sp_richer
	.word	10,2
	.long	sag1,sag3
sag1	.word	00bf8h,-42,0		;richer 1
sag3	.word	00bfbh,-45,0		;richer 3
sp_to_richer
	.word	10,2
	.long	sah1,sah3
sah1	.word	01473h,-56,0		;to richer 1
sah3	.word	01475h,-59,0		;to richer 3

sp_joe_juneau
	.word	00c50h,-35		;joe (sakic)
	.word	00c04h,-50,0		;juneau 3
sp_juneau
	.word	10,2
	.long	sai1,sai3
sai1	.word	00c01h,-38,0		;juneau 1
sai3	.word	00c04h,-50,0		;juneau 3
sp_to_juneau
	.word	10,2
	.long	saj1,saj3
saj1	.word	01476h,-52,0		;to juneau 1
saj3	.word	01478h,-64,0		;to juneau 3

sp_peter_bondra
	.word	00c06h,-39		;peter (bondra)
	.word	00c07h,-44,0		;bonrda 2
sp_bondra
	.word	10,2
	.long	sak1,sak2
sak1	.word	00c05h,-56,0		;bondra 1
sak2	.word	00c07h,-44,0		;bonrda 2
sp_to_bondra
	.word	10,2
	.long	sal1,sal2
sal1	.word	01479h,-71,0		;to bondra 1
sal2	.word	0147ah,-59,0		;to bonrda 2

sp_eric_lindros
	.word	10,2
	.long	sam1,sam2
sam1	.word	00c0ch,-28		;eric (lindros)
	.word	00c0bh,-46+2,0		;lindros 3
sam2	.word	00c0ch,-28		;eric (lindros)
	.word	00c0dh,-46+2,0		;lindros 4
sp_lindros
	.word	10,3
	.long	san1,san2,san3
san1	.word	00c09h,-57+2,0		;lindros 1
san2	.word	00c0bh,-46+2,0		;lindros 3
san3	.word	00c0dh,-46+2,0		;lindros 4
sp_to_lindros
	.word	10,3
	.long	sao1,sao2,sao3
sao1	.word	0147ch,-71+2,0		;to lindros 1
sao2	.word	0147eh,-60+2,0		;to lindros 3
sao3	.word	0147fh,-60+2,0		;to lindros 4

sp_rod_brindamour
	.word	00c10h,-40		;rod (brindamour)
	.word	00c0fh,-56,0		;brindamour 2
sp_brindamour
	.word	10,2
	.long	sap1,sap2
sap1	.word	00c0eh,-43,0		;brindamour 1
sap2	.word	00c0fh,-56,0		;brindamour 2
sp_to_brindamour
	.word	10,2
	.long	saq1,saq2
saq1	.word	01480h,-57,0		;to brindamour 1
saq2	.word	01481h,-70,0		;to brindamour 2

sp_kirk_muller
	.word	00c17h,-29		;kirk (muller)
	.word	00c19h,-45,0		;muller 3
sp_muller
	.word	10,2
	.long	sar2,sar3
sar2	.word	00c18h,-46,0		;muller 2
sar3	.word	00c19h,-45,0		;muller 3
sp_to_muller
	.word	10,2
	.long	sas2,sas3
sas2	.word	01484h,-60,0		;to muller 2
sas3	.word	01485h,-59,0		;to muller 3

sp_steve_thomas
	.word	00c1ch,-38		;steve (thomas)
	.word	00c1dh,-43+2,0		;thomas 3
sp_thomas
	.word	10,2
	.long	sat1,sat3
sat1	.word	00c1ah,-36+2,0		;thomas 1
sat3	.word	00c1dh,-43+2,0		;thomas 3
sp_to_thomas
	.word	10,2
	.long	sau1,sau3
sau1	.word	01486h,-50+2,0		;to thomas 1
sau3	.word	01488h,-57+2,0		;to thomas 3

sp_gord_murphy
	.word	00c26h,-38		;gord (gmurphy) 
	.word	00c25h,-61,0		;gmurphy 2
sp_murphy
	.word	10,2
	.long	sav1,sav2
sav1	.word	00c24h,-55,0		;gmurphy 1
sav2	.word	00c25h,-61,0		;gmurphy 2
sp_to_murphy
	.word	10,2
	.long	saw1,saw2
saw1	.word	01489h,-69,0		;to gmurphy 1
saw2	.word	0148ah,-75,0		;to gmurphy 2

sp_scott_mellanby
	.word	00c29h,-29		;scott (mellanby)
	.word	00c28h,-44,0		;mellanby 1
sp_mellanby
	.word	10,2
	.long	sax1,sax3
sax1	.word	00c28h,-44,0		;mellanby 1
sax3	.word	00c2bh,-62,0		;mellanby 3
sp_to_mellanby
	.word	10,2
	.long	say1,say3
say1	.word	0148ch,-59,0		;to mellanby 1
say3	.word	0148eh,-77,0		;to mellanby 3

sp_brian_bradley
	.word	00c34h,-39		;brian (bradley)
	.word	00c35h,-55,0		;bradley 3
sp_bradley
	.word	10,2
	.long	saz1,saz3
saz1	.word	00c32h,-59,0		;bradley 1
saz3	.word	00c35h,-55,0		;bradley 3
sp_to_bradley
	.word	10,2
	.long	sba1,sba3
sba1	.word	0148fh,-73,0		;to bradley 1
sba3	.word	01491h,-69,0		;to bradley 3

sp_petr_klima
	.word	00c38h,-39		;peter (klima)
	.word	00c37h,-44,0		;klima 2
sp_klima
	.word	10,2
	.long	sbb1,sbb2
sbb1	.word	00c36h,-44,0		;klima 1
sbb2	.word	00c37h,-44,0		;klima 2
sp_to_klima
	.word	10,2
	.long	sbc1,sbc2
sbc1	.word	01492h,-59,0		;to klima 1
sbc2	.word	01493h,-58,0		;to klima 2

sp_jaromir_jagr
	.word	00c3fh,-43		;jaromir (jagr)
	.word	00c41h,-43,0		;jagr 2
sp_jagr
	.word	10,2
	.long	sbd2,sbd3
sbd2	.word	00c41h,-43,0		;jagr 2
sbd3	.word	00c42h,-51,0		;jagr 3
sp_nickname_jagr
	.word	10,3
	.long	sp_jaromir_jagr
	.long	sp_jaromir_jagr
	.long	sp_nny
sp_nny	.word	00c40h,-94		;the human highlight film
	.word	00c3fh,-43		;jaromir (jagr)
	.word	00c41h,-43,0		;jagr 2
sp_to_jagr
	.word	10,2
	.long	sbe2,sbe3
sbe2	.word	01496h,-57,0		;to jagr 2
sbe3	.word	01497h,-65,0		;to jagr 3

sp_luc_robitaille
	.word	00c45h,-31		;luc (robataille)
	.word	00c46h,-61,0		;robataille 3
sp_robitaille
	.word	10,2
	.long	sbf1,sbf3
sbf1	.word	00c43h,-63,0		;robataille 1
sbf3	.word	00c46h,-61,0		;robataille 3
sp_nickname_robitaille
	.word	10,3
	.long	sp_luc_robitaille
	.long	sp_luc_robitaille
	.long	sp_nnl
sp_nnl	.word	00c47h,-39		;lucky ( robataille)
	.word	00c45h,-31		;luc (robataille)
	.word	00c46h,-61,0		;robataille 3
sp_to_robitaille
	.word	10,2
	.long	sbg1,sbg3
sbg1	.word	01498h,-77,0		;to robataille 1
sbg3	.word	0149ah,-75,0		;to robataille 3

sp_joe_sakic
	.word	00c50h,-35		;joe (sakic)
	.word	00c4fh,-44,0		;sakic 3
sp_sakic
	.word	10,2
	.long	sbh2,sbh3
sbh2	.word	00c4fh,-44,0		;sakic 3
sbh3	.word	00c51h,-47,0		;sakic 4
sp_to_sakic
	.word	10,2
	.long	sbi2,sbi3
sbi2	.word	0149dh,-58,0		;to sakic 3
sbi3	.word	0149eh,-61,0		;to sakic 4

sp_wendel_clark
	.word	00c53h,-37		;wendel (clark)
	.word	00c54h,-35,0		;clark 2
sp_clark
	.word	10,2
	.long	sbj1,sbj2
sbj1	.word	00c52h,-38,0		;clark 1
sbj2	.word	00c54h,-35,0		;clark 2
sp_to_clark
	.word	10,2
	.long	sbk1,sbk2
sbk1	.word	0149fh,-53,0		;to clark 1
sbk2	.word	014a0h,-49,0		;to clark 2

sp_pat_lafontaine
	.word	00c5ch,-27		;pat (lafontaine)
	.word	00c5dh,-72,0		;lafontaine 2
sp_lafontaine
	.word	10,2
	.long	sbl2,sbl3
sbl2	.word	00c5dh,-72,0		;lafontaine 2
sbl3	.word	00c5eh,-74,0		;lafontaine 3
sp_to_lafontaine
	.word	10,2
	.long	sbm2,sbm3
sbm2	.word	014a3h,-86,0		;to lafontaine 2
sbm3	.word	014a4h,-89,0		;to lafontaine 3

sp_alexander_mogilny
	.word	00c61h,-63		;alexander (mogilny)
	.word	00c60h,-68,0		;mogilny 2
sp_mogilny
	.word	10,2
	.long	sbn1,sbn2
sbn1	.word	00c5fh,-62,0		;mogilny 1
sbn2	.word	00c60h,-68,0		;mogilny 2
sp_to_mogilny
	.word	10,2
	.long	sbo1,sbo2
sbo1	.word	014a5h,-77,0		;to mogilny 1
sbo2	.word	014a6h,-82,0		;to mogilny 2

sp_vincent_damphousse
	.word	00c6ch,-43		;vincent (damphousse)
	.word	00c6bh,-53+2,0		;damphousse 3
sp_damphousse
	.word	10,2
	.long	sbp1,sbp3
sbp1	.word	00c69h,-42+2,0		;damphousse 1
sbp3	.word	00c6bh,-53+2,0		;damphousse 3
sp_to_damphousse
	.word	10,2
	.long	sbq1,sbq3
sbq1	.word	014a8h,-56+2,0		;to damphousse 1
sbq3	.word	014aah,-67+2,0		;to damphousse 3

sp_mark_recchi
	.word	00c70h,-36		;mark (recchi)
	.word	00c6fh,-48,0		;recchi 3
sp_recchi
	.word	10,2
	.long	sbr1,sbr3
sbr1	.word	00c6dh,-54,0		;recchi 1
sbr3	.word	00c6fh,-48,0		;recchi 3
sp_to_recchi
	.word	10,2
	.long	sbs1,sbs3
sbs1	.word	014abh,-68,0		;to recchi 1
sbs3	.word	014adh,-62,0		;to recchi 3

sp_ray_bourque
	.word	00c7dh,-38		;raymond (bourque)
	.word	00c7eh,-38,0		;bourque 3
sp_bourque
	.word	10,2
	.long	sbt2,sbt3
sbt2	.word	00c7ch,-36,0		;bourque 2
sbt3	.word	00c7eh,-38,0		;bourque 3
sp_to_bourque
	.word	10,2
	.long	sbu2,sbu3
sbu2	.word	014b2h,-51,0		;to bourque 2
sbu3	.word	014b3h,-52,0		;to bourque 3

sp_cam_neely
	.word	00c78h,-41		;cam (neely)
	.word	00c79h,-49,0		;neely 2
sp_neely
	.word	10,2
	.long	sbv1,sbv2
sbv1	.word	00c77h,-48,0		;neely 1
sbv2	.word	00c79h,-49,0		;neely 2
sp_to_neely
	.word	10,2
	.long	sbw1,sbw2
sbw1	.word	014aeh,-62,0		;to neely 1
sbw2	.word	014afh,-63,0		;to neely 2

sp_andrew_cassels
	.word	00c88h,-38		;andrew (cassels)
	.word	00c89h,-48+2,0		;cassels 1
sp_cassels
	.word	10,2
sbx	.long	sbx1,sbx2
sbx1	.word	00c89h,-48+2,0		;cassels 1
sbx2	.word	00c8bh,-49+2,0		;cassels 3
sp_to_cassels
	.word	10,2
	.long	sby1,sby2
sby1	.word	014b7h,-62+2,0		;to cassels 1
sby2	.word	014b9h,-63+2,0		;to cassels 3

sp_geoff_sanderson
	.word	00c85h,-27		;geoff (sanderson)
	.word	00c86h,-59,0		;sanderson 2
sp_sanderson
	.word	10,2
	.long	sbz2,sbz3
sbz2	.word	00c86h,-59,0		;sanderson 2
sbz3	.word	00c87h,-57,0		;sanderson 3
sp_to_sanderson
	.word	10,2
	.long	sca2,sca3
sca2	.word	014b5h,-74,0		;to sanderson 2
sca3	.word	014b6h,-71,0		;to sanderson 3

sp_alexandre_daigle
	.word	00c98h,-61		;alexandre (daigle)
	.word	00c97h,-43,0		;daigle 3
sp_daigle
	.word	10,2
	.long	scb2,scb3
scb2	.word	00c96h,-43,0		;daigle 2
scb3	.word	00c97h,-43,0		;daigle 3
sp_to_daigle
	.word	10,2
	.long	scc2,scc3
scc2	.word	014beh,-57,0		;to daigle 2
scc3	.word	014bfh,-57,0		;to daigle 3

sp_alexei_yashin
	.word	00c93h,-34		;alexei (yashin)
	.word	00c92h,-54,0		;yashin 2
sp_yashin
	.word	10,2
	.long	scd2,scd3
scd2	.word	00c92h,-54,0		;yashin 2
scd3	.word	00c94h,-48,0		;yashin 3
sp_to_yashin
	.word	10,2
	.long	sce2,sce3
sce2	.word	014bbh,-68,0		;to yashin 2
sce3	.word	014bch,-62,0		;to yashin 3

sp_sergei_fedorov
	.word	00bb9h,-43		;sergei (federov)
	.word	00bbah,-48,0		;federov 2
sp_fedorov
	.word	10,2
	.long	scf1,scf2
scf1	.word	00bb8h,-40,0		;federov 1
scf2	.word	00bbah,-48,0		;federov 2
sp_to_fedorov
	.word	10,2
	.long	scg1,scg2
scg1	.word	01450h,-54,0		;to federov 1
scg2	.word	01451h,-62,0		;to federov 2

sp_steve_yzerman
	.word	00bbeh,-50		;steve (yzerman)
	.word	00bbfh,-63,0		;yzerman 3
sp_yzerman
	.word	10,2
	.long	sch1,sch3
sch1	.word	00bbch,-39,0		;yzerman 1
sch3	.word	00bbfh,-63,0		;yzerman 3
sp_to_yzerman
	.word	10,2
	.long	sci1,sci3
sci1	.word	01453h,-53,0		;to yzerman 1
sci3	.word	01455h,-77,0		;to yzerman 3

sp_doug_gilmour
	.word	00ca1h,-32		;doug (gilmore)
	.word	00ca2h,-58,0		;gilmore 3
sp_gilmour
	.word	10,2
	.long	scj2,scj3
scj2	.word	00ca2h,-58,0		;gilmore 3
scj3	.word	00ca3h,-62,0		;gilmore 4
sp_nickname_gilmour
	.word	10,3
	.long	sp_doug_gilmour
	.long	sp_doug_gilmour
	.long	sp_nnd
sp_nnd	.word	00c9eh,-52		;the killer (gilmore)
	.word	00ca1h,-32		;doug (gilmore)
	.word	00ca2h,-58,0		;gilmore 3
sp_to_gilmour
	.word	10,2
	.long	sck2,sck3
sck2	.word	014c2h,-72,0		;to gilmore 3
sck3	.word	014c3h,-77,0		;to gilmore 4

sp_dave_andreychuk
	.word	00ca5h,-29		;dave (andreychuk)
	.word	00ca6h,-52,0		;andreychuk 2
sp_andreychuk
	.word	10,2
	.long	scl1,scl2
scl1	.word	00ca4h,-64,0		;andreychuk 1
scl2	.word	00ca6h,-52,0		;andreychuk 2
sp_to_andreychuk
	.word	10,2
	.long	scm1,scm2
scm1	.word	014c4h,-79,0		;to andreychuk 1
scm2	.word	014c5h,-66,0		;to andreychuk 2

sp_brett_hull
	.word	00cb2h,-29		;brett (hull)
	.word	00cb3h,-38,0		;hull 2
sp_hull
	.word	10,2
	.long	scn1,scn3
scn1	.word	00cafh,-53,0		;hull 1
scn3	.word	00cb3h,-38,0		;hull 3
sp_nickname_hull
	.word	10,3
	.long	sp_brett_hull
	.long	sp_brett_hull
	.long	sp_nnb
sp_nnb	.word	00cb2h,-29		;brett (hull)
	.word	00cb3h,-38		;hull 2
	.word	00cb1h,-74,0		;the golden brett (hull)
sp_to_hull
	.word	10,2
	.long	sco1,sco3
sco1	.word	014c8h,-67,0		;to hull 1
sco3	.word	014cah,-52,0		;to hull 3

sp_brendan_shanahan
	.word	00cb4h,-34		;brendan (shanahan)
	.word	00cb5h,-64,0		;shanahan 1
sp_shanahan
	.word	10,2
	.long	scp1,scp3
scp1	.word	00cb5h,-64,0		;shanahan 1
scp3	.word	00cb7h,-59,0		;shanahan 3
sp_to_shanahan
	.word	10,2
	.long	scq1,scq3
scq1	.word	014cbh,-79,0		;to shanahan 1
scq3	.word	014cdh,-73,0		;to shanahan 3

sp_bernie_nicholls
	.word	00be3h,-30		;bernie (nicholls)
	.word	00be4h,-57+2,0		;nicholls 2
sp_nicholls
	.word	10,2
	.long	scr1,scr2
scr1	.word	00be2h,-47+2,0		;nicholls 1
scr2	.word	00be4h,-57+2,0		;nicholls 2
sp_to_nicholls
	.word	10,2
	.long	scs1,scs2
scs1	.word	01466h,-61+2,0		;to nicholls 1
scs2	.word	01467h,-72+2,0		;to nicholls 2

sp_chris_chelios
	.word	00bd2h,-37		;chris (chelios)
	.word	00bd3h,-46+2,0		;chelios 2
sp_chelios
	.word	10,2
	.long	sct1,sct2
sct1	.word	00bd1h,-51+2,0		;chelios 1
sct2	.word	00bd3h,-46+2,0		;chelios 2
sp_to_chelios
	.word	10,2
	.long	scu1,scu2
scu1	.word	0145eh,-65+2,0		;to chelios 1
scu2	.word	0145fh,-60+2,0		;to chelios 2

sp_teemu_selanne
	.word	00cc0h,-36		;teemu (selanne)
	.word	00cc2h,-56,0		;selanne 3
sp_selanne
	.word	10,2
	.long	scv1,scv2
scv1	.word	00cbfh,-54,0		;selanne 1
scv2	.word	00cc2h,-56,0		;selanne 3
sp_nickname_selanne
	.word	10,3
	.long	sp_teemu_selanne
	.long	sp_teemu_selanne
	.long	sp_nnt
sp_nnt	.word	00cbeh,-76		;the finnish flash (selanne)
	.word	00cc0h,-36		;teemu (selanne)
	.word	00cc2h,-56,0		;selanne 3
sp_to_selanne
	.word	10,2
	.long	scw1,scw2
scw1	.word	014ceh,-68,0		;to selanne 1
scw2	.word	014d0h,-70,0		;to selanne 3

sp_keith_tkachuk
	.word	00cc3h,-28		;keith (tkachuk)
	.word	00cc4h,-52,0		;tkachuk 1
sp_tkachuk
	.word	10,2
	.long	scx1,scx3
scx1	.word	00cc4h,-52,0		;tkachuk 1
scx3	.word	00cc6h,-48,0		;tkachuk 3
sp_to_tkachuk
	.word	10,2
	.long	scy1,scy3
scy1	.word	014d1h,-67,0		;to tkachuk 1
scy3	.word	014d3h,-62,0		;to tkachuk 3

sp_mike_modano
	.word	00ccdh,-25		;mike (modano)
	.word	00cceh,-58,0		;modano 2
sp_modano
	.word	10,2
	.long	scz2,scz3
scz2	.word	00cceh,-58,0		;modano 2
scz3	.word	00ccfh,-65,0		;modano 3
sp_to_modano
	.word	10,2
	.long	sda2,sda3
sda2	.word	014d5h,-72,0		;to modano 2
sda3	.word	014d6h,-79,0		;to modano 3

sp_kevin_hatcher
	.word	00cd1h,-31		;derian (hatcher)
	.word	00cd2h,-51,0		;hatcher 1
sp_hatcher
	.word	10,2
	.long	sdb1,sdb3
sdb1	.word	00cd2h,-51,0		;hatcher 1
sdb3	.word	00cd4h,-54,0		;hatcher 3
sp_to_hatcher
	.word	10,2
	.long	sdc1,sdc3
sdc1	.word	014d8h,-66,0		;to hatcher 1
sdc3	.word	014dah,-69,0		;to hatcher 3

sp_pavel_bure
	.word	00cdah,-33		;pavel (bure)
	.word	00cdbh,-50,0		;bure 1
sp_bure
	.word	10,2
	.long	sdd1,sdd2
sdd1	.word	00cdbh,-50,0		;bure 1
sdd2	.word	00cdch,-47,0		;bure 2
sp_nickname_bure
	.word	10,3
	.long	sp_pavel_bure
	.long	sp_pavel_bure
	.long	sp_nnp
sp_nnp	.word	00cddh,-59		;the russian rocket (bure)
	.word	00cdah,-33		;pavel (bure)
	.word	00cdbh,-50,0		;bure 1
sp_to_bure
	.word	10,2
	.long	sde1,sde2
sde1	.word	014dbh,-64,0		;to bure 1
sde2	.word	014dch,-61,0		;to bure 2

sp_trevor_linden
	.word	00cdfh,-36		;trevor (linden)
	.word	00ce0h,-52,0		;linden 1
sp_linden
	.word	10,2
	.long	sdf1,sdf2
sdf1	.word	00ce0h,-52,0		;linden 1
sdf2	.word	00ce1h,-50,0		;linden 2
sp_to_linden
	.word	10,2
	.long	sdg1,sdg2
sdg1	.word	014deh,-67,0		;to linden 1
sdg2	.word	014dfh,-64,0		;to linden 2

sp_theoren_fleury
	.word	00ce8h,-36		;theoren (fleury)
	.word	00ce9h,-50,0		;fleury 1
sp_fleury
	.word	10,2
	.long	sdh1,sdh2
sdh1	.word	00ce9h,-50,0		;fleury 1
sdh2	.word	00ceah,-47,0		;fleury 2
sp_to_fleury
	.word	10,2
	.long	sdi1,sdi2
sdi1	.word	014e1h,-64,0		;to fleury 1
sdi2	.word	014e2h,-61,0		;to fleury 2

sp_reichel
sp_to_reichel
sp_robert_reichel

sp_sandis_ozolinsh
	.word	00cf7h,-40		;sandis (ozolinsh)
	.word	00cf8h,-55+2,0		;ozolinsh 2
sp_ozolinsh
	.word	10,2
	.long	sdl2,sdl3
sdl2	.word	00cf8h,-55+2,0		;ozolinsh 2
sdl3	.word	00cf9h,-54+2,0		;ozolinsh 3
sp_to_ozolinsh
	.word	10,2
	.long	sdm2,sdm3
sdm2	.word	014e8h,-69+2,0		;to ozolinsh 2
sdm3	.word	014e9h,-69+2,0		;to ozolinsh 3

sp_ulf_dahlen
	.word	00cfch,-32		;ulf (dahlen)
	.word	00cfdh,-49,0		;dahlen 3
sp_dahlen
	.word	10,2
	.long	sdn2,sdn3
sdn2	.word	00cfbh,-52,0		;dahlen 2
sdn3	.word	00cfdh,-49,0		;dahlen 3
sp_to_dahlen
	.word	10,2
	.long	sdo2,sdo3
sdo2	.word	014ebh,-67,0		;to dahlen 2
sdo3	.word	014ech,-63,0		;to dahlen 3

sp_wayne_gretzky
	.word	00d06h,-38		;wayne (gretzky)
	.word	00d07h,-55,0		;gretzky 3
sp_gretzky
	.word	10,2
	.long	sdp1,sdp3
sdp1	.word	00d03h,-49,0		;gretzky 1
sdp3	.word	00d07h,-55,0		;gretzky 3
sp_nickname_gretzky
	.word	10,3
	.long	sp_wayne_gretzky
	.long	sp_wayne_gretzky
	.long	sp_nnw
sp_nnw	.word	10,2
	.long	sp_nnw1,sp_nnw2
sp_nnw1	.word	00d05h,-54		;the great one (gretzky)
	.word	00d06h,-38		;wayne (gretzky)
	.word	00d07h,-55,0		;gretzky 3
sp_nnw2	.word	00d08h,-67,0		;the great gretzky (gretzky)
sp_to_gretzky
	.word	10,2
	.long	sdq1,sdq3
sdq1	.word	014edh,-63,0		;to gretzky 1
sdq3	.word	014efh,-69,0		;to gretzky 3

sp_jari_kurri
	.word	00d0bh,-38		;jari (kurri)
	.word	00d0ch,-50,0		;kurri 2
sp_kurri
	.word	10,2
	.long	sdr2,sdr3
sdr2	.word	00d0ch,-50,0		;kurri 2
sdr3	.word	00d0dh,-46,0		;kurri 3
sp_to_kurri
	.word	10,2
	.long	sds2,sds3
sds2	.word	014f2h,-64,0		;to kurri 2
sds3	.word	014f3h,-60,0		;to kurri 3

sp_paul_kariya
	.word	00d15h,-36		;paul (kariya)
	.word	00d16h,-57,0		;kariya 3
sp_kariya
	.word	10,2
	.long	sdt2,sdt3
sdt2	.word	00d14h,-55,0		;kariya 2
sdt3	.word	00d16h,-57,0		;kariya 3
sp_to_kariya
	.word	10,2
	.long	sdu2,sdu3
sdu2	.word	014f5h,-69,0		;to kariya 2
sdu3	.word	014f6h,-71,0		;to kariya 3

sp_tom_kurvers
	.word	00d17h,-34		;tom (kurvers)
	.word	00d18h,-51+2,0		;kurvers 1
sp_kurvers
	.word	10,2
	.long	sdv1,sdv2
sdv1	.word	00d18h,-51+2,0		;kurvers 1
sdv2	.word	00d19h,-49+2,0		;kurvers 2
sp_to_kurvers
	.word	10,2
	.long	sdw1,sdw2
sdw1	.word	014f7h,-65+2,0		;to kurvers 1
sdw2	.word	014f8h,-64+2,0		;to kurvers 2

sp_igor_kravchuk
	.word	00d21h,-34		;igor (kravchuk)
	.word	00d22h,-53,0		;kravchuk 2
sp_kravchuk
	.word	10,2
	.long	sdx2,sdx3
sdx2	.word	00d22h,-53,0		;kravchuk 2
sdx3	.word	00d23h,-50,0		;kravchuk 3
sp_to_kravchuk
	.word	10,2
	.long	sdy2,sdy3
sdy2	.word	014fbh,-67,0		;to kravchuk 2
sdy3	.word	014fch,-64,0		;to kravchuk 3

sp_shayne_corson
	.word	00d24h,-37		;shayne (corson)
	.word	00d25h,-54,0		;corson 1
sp_corson
	.word	10,2
	.long	sdz1,sdz2
sdz1	.word	00d25h,-54,0		;corson 1
sdz2	.word	00d26h,-46,0		;corson 2
sp_to_corson
	.word	10,2
	.long	sea1,sea2
sea1	.word	014fdh,-69,0		;to corson 1
sea2	.word	014feh,-60,0		;to corson 2

sp_mike_richter
	.word	00bf0h,-26		;mike (richter)
	.word	00befh,-58,0		;richter 1
sp_richter
	.word	10,3
	.long	seb1,seb3,seb4
seb1	.word	00befh,-58,0		;richter 1
seb3	.word	00bf2h,-59,0		;richter 3
seb4	.word	00bf3h,-33,0		;richter 4
sp_by_richter
	.word	10,3
	.long	sec1,sec3,sec4
sec1	.word	010d5h,-70,0		;BY richter 1
sec3	.word	010d7h,-71,0		;BY richter 3
sec4	.word	010d8h,-45,0		;BY richter 4

sp_martin_brodeur
	.word	00bfch,-49		;martin (brodeur)
	.word	00bfdh,-60,0		;brodeur 1
sp_brodeur
	.word	10,3
	.long	sed1,sed3,sed4
sed1	.word	00bfdh,-60,0		;brodeur 1
sed3	.word	00bffh,-64,0		;brodeur 3
sed4	.word	00c00h,-37,0		;brodeur 4
sp_by_brodeur
	.word	10,3
	.long	see1,see3,see4
see1	.word	010d9h,-72,0		;BY brodeur 1
see3	.word	010dbh,-77,0		;BY brodeur 3
see4	.word	010dch,-49,0		;BY brodeur 4

sp_jim_carey
	.word	00d33h,-41		;jim (carey)
	.word	00d2eh,-56,0		;carey 1
sp_carey
	.word	10,2
	.long	sef1,sef2
sef1	.word	00d2eh,-56,0		;carey 1
sef2	.word	00d2fh,-36,0		;carey 2
sp_nickname_carey
	.word	10,3
	.long	sp_carey
	.long	sp_carey
	.long	sp_nnj
sp_nnj	.word	10,2
	.long	sp_nnj1,sp_nnj2
sp_nnj1	.word	00d31h,-74,0		;the net detective
sp_nnj2	.word	00d32h,-53,0		;the mask
sp_by_carey
	.word	10,4
	.long	seg1,seg2,seg4,seg5
seg1	.word	010ddh,-69,0		;BY carey 1
seg2	.word	010deh,-48,0		;BY carey 2
seg4	.word	010e0h,-87,0		;BY the net detective
seg5	.word	010e1h,-65,0		;BY the mask

sp_ron_hextall
	.word	00c14h,-29		;ron (hextall)
	.word	00c15h,-54,0		;hextall 3
sp_hextall
	.word	10,3
	.long	seh1,seh2,seh3
seh1	.word	00c12h,-44,0		;hextall 1
seh2	.word	00c13h,-46,0		;hextall 2
seh3	.word	00c15h,-54,0		;hextall 3
sp_by_hextall
	.word	10,3
	.long	sei1,sei2,sei3
sei1	.word	010e2h,-56,0		;BY hextall 1
sei2	.word	010e3h,-59,0		;BY hextall 2
sei3	.word	010e4h,-66,0		;BY hextall 3

sp_jamie_mclennan
	.word	00c1fh,-25		;jamie (mclennan)
	.word	00c20h,-56,0		;mclennan 2
sp_mclennan
	.word	10,2
	.long	sej2,sej3
sej2	.word	00c20h,-56,0		;mclennan 2
sej3	.word	00c22h,-63,0		;mclennan 4
sp_by_mclennan
	.word	10,2
	.long	sek2,sek3
sek2	.word	010e6h,-68,0		;BY mclennan 2
sek3	.word	010e8h,-75,0		;BY mclennan 4

sp_john_vanbiesbrouck
	.word	00c2eh,-27		;john (vanb.)
	.word	00c2fh,-61,0		;vanbiesbrouck 2
sp_vanbiesbrouck
	.word	10,2
	.long	sel2,sel3
sel2	.word	00c2fh,-61,0		;vanbiesbrouck 2
sel3	.word	00c30h,-70,0		;vanbiesbrouck 3
sp_nickname_vanbiesbrouck
	.word	10,3
	.long	sp_vanbiesbrouck
	.long	sp_vanbiesbrouck
	.long	sp_nnv
sp_nnv	.word	00c31h,-61,0		;the beezer
sp_by_vanbiesbrouck
	.word	10,3
	.long	sem2,sem3,sem4
sem2	.word	010ebh,-73,0		;BY vanbiesbrouck 2
sem3	.word	010ech,-82,0		;BY vanbiesbrouck 3
sem4	.word	010edh,-73,0		;BY the beezer

sp_darren_puppa
	.word	00c3ch,-32		;daren (puppa)
	.word	00c3dh,-58,0		;puppa 3
sp_puppa
	.word	10,2
	.long	sen1,sen3
sen1	.word	00c3ah,-46,0		;puppa 1
sen3	.word	00c3dh,-58,0		;puppa 3
sp_by_puppa
	.word	10,2
	.long	seo1,seo3
seo1	.word	010eeh,-59,0		;BY puppa 1
seo3	.word	010f0h,-70,0		;BY puppa 3

sp_ken_wregget
	.word	00c4bh,-36		;ken (wregget)
	.word	00c49h,-43,0		;wregget 2
sp_wregget
	.word	10,2
	.long	sep2,sep3
sep2	.word	00c49h,-43,0		;wregget 2
sep3	.word	00c4ah,-34,0		;wregget 3
sp_by_wregget
	.word	10,2
	.long	seq2,seq3
seq2	.word	010f2h,-56,0		;BY wregget 2
seq3	.word	010f3h,-46,0		;BY wregget 3

sp_stephane_fiset
	.word	00c59h,-46		;stephane (fiset)
	.word	00c58h,-60,0		;fiset 3
sp_fiset
	.word	10,2
	.long	ser2,ser3
ser2	.word	00c57h,-50,0		;fiset 2
ser3	.word	00c58h,-60,0		;fiset 3
sp_by_fiset
	.word	10,2
	.long	ses2,ses3
ses2	.word	010f6h,-62,0		;BY fiset 2
ses3	.word	010f7h,-72,0		;BY fiset 3

sp_dominik_hasek
	.word	00c65h,-25		;dominick (hasek)
	.word	00c63h,-52,0		;hasek 1
sp_hasek
	.word	10,3
	.long	set1,set2,set3
set1	.word	00c63h,-52,0		;hasek 1
set2	.word	00c66h,-44,0		;hasek 2
set3	.word	00c67h,-60,0		;hasek 3
sp_nickname_hasek
	.word	10,3
	.long	sp_hasek
	.long	sp_hasek
	.long	sp_nnk
sp_nnk	.word	00c64h,-62,0		;the dominator (hasek)
sp_by_hasek
	.word	10,4
	.long	seu1,seu2,seu3,seu4
seu1	.word	010f9h,-64,0		;BY hasek 1
seu2	.word	010fah,-74,0		;BY the dominator (hasek)
seu3	.word	010fbh,-56,0		;BY hasek 2
seu4	.word	010fch,-72,0		;BY hasek 3

sp_patrick_roy
	.word	00c73h,-31		;patrick (roy)
	.word	00c76h,-58,0		;roy 5
sp_roy
	.word	10,2
	.long	sev2,sev4
sev2	.word	00c74h,-49,0		;roy 3
sev4	.word	00c76h,-58,0		;roy 5
sp_by_roy
	.word	10,2
	.long	sew2,sew4
sew2	.word	01100h,-61,0		;BY roy 3
sew4	.word	01102h,-70,0		;BY roy 5

sp_blaine_lacher
	.word	00c81h,-38		;blaine (lacher)
	.word	00c82h,-41,0		;lacher 3
sp_lacher
	.word	10,2
	.long	sex2,sex3
sex2	.word	00c82h,-41,0		;lacher 3
sex3	.word	00c83h,-41,0		;lacher 4
sp_nickname_lacher
	.word	10,3
	.long	sp_lacher
	.long	sp_lacher
	.long	sp_nna
sp_nna	.word	00d34h,-100,0		;The *lach*-ness monster
sp_by_lacher
	.word	10,3
	.long	sey2,sey3,sey4
sey2	.word	01105h,-54,0		;BY lacher 3
sey3	.word	01106h,-53,0		;BY lacher 4
sey4	.word	01107h,-112,0		;BY The *lach*-ness monster

sp_sean_burke
	.word	00c8dh,-36		;sean (burke)
	.word	00c90h,-39,0		;burke 4
sp_burke
	.word	10,2
	.long	sez2,sez3
sez2	.word	00c8fh,-31,0		;burke 3
sez3	.word	00c90h,-39,0		;burke 4
sp_by_burke
	.word	10,2
	.long	sfa2,sfa3
sfa2	.word	0110ah,-43,0		;BY burke 3
sfa3	.word	0110bh,-51,0		;BY burke 4

sp_don_beaupre
	.word	00c9bh,-38		;don (beaupre)
	.word	00c9ah,-57,0		;beaupre 2
sp_beaupre
	.word	10,2
	.long	sfb1,sfb2
sfb1	.word	00c99h,-62,0		;beaupre 1
sfb2	.word	00c9ah,-57,0		;beaupre 2
sp_by_beaupre
	.word	10,2
	.long	sfc1,sfc2
sfc1	.word	0110ch,-74,0		;BY beaupre 1
sfc2	.word	0110dh,-69,0		;BY beaupre 2

sp_mike_vernon
	.word	00bc5h,-35		;mike (vernon)
	.word	00bc6h,-43,0		;vernon 2
sp_vernon
	.word	10,3
	.long	sfd1,sfd2,sfd4
sfd1	.word	00bc4h,-53,0		;vernon 1
sfd2	.word	00bc6h,-43,0		;vernon 2
sfd4	.word	00bc9h,-44,0		;vernon 5
sp_by_vernon
	.word	10,3
	.long	sfe1,sfe2,sfe4
sfe1	.word	010cch,-65,0		;BY vernon 1
sfe2	.word	010cdh,-55,0		;BY vernon 2
sfe4	.word	010d0h,-56,0		;BY vernon 5

sp_felix_potvin
	.word	10,2
	.long	sfea1,sfea2
sfea1	.word	00cabh,-28		;felix (potvin)
	.word	00caeh,-51,0		;potvin 4
sfea2	.word	00cabh,-28		;felix (potvin)
	.word	00cach,-34		;the cat (potvin)
	.word	00caeh,-51,0		;potvin 4
sp_potvin
	.word	10,2
	.long	sff2,sff3
sff2	.word	00caah,-50,0		;potvin 2
sff3	.word	00caeh,-51,0		;potvin 4
sp_nickname_potvin
	.word	10,3
	.long	sp_potvin
	.long	sp_potvin
	.long	sp_nnf
sp_nnf	.word	00cach,-34,0		;the cat (potvin)
sp_by_potvin
	.word	10,3
	.long	sfg2,sfg3,sfg4
sfg2	.word	01111h,-62,0		;BY potvin 2
sfg3	.word	01112h,-46,0		;BY the cat (potvin)
sfg4	.word	01114h,-63,0		;BY potvin 4

sp_curtis_joseph
	.word	00cb9h,-29		;curtis (joseph)
	.word	00cb8h,-49,0		;joseph 1
sp_joseph
	.word	10,2
	.long	sfh1,sfh3
sfh1	.word	00cb8h,-49,0		;joseph 1
sfh3	.word	00cbdh,-60,0		;joseph 4
sp_nickname_joseph
	.word	10,3
	.long	sp_joseph
	.long	sp_joseph
	.long	sp_nnu
sp_nnu	.word	00cbbh,-72,0		;cu-jo (joseph)
sp_by_joseph
	.word	10,3
	.long	sfi1,sfi3,sfi4
sfi1	.word	01115h,-61,0		;BY joseph 1
sfi3	.word	01117h,-84,0		;BY cu-jo (joseph)
sfi4	.word	01119h,-72,0		;BY joseph 4

sp_ed_belfour
	.word	00bdfh,-32		;ed (belfour)
	.word	00be0h,-52,0		;belfour 4
sp_belfour
	.word	10,3
	.long	sfj1,sfj2,sfj5
sfj1	.word	007d1h,-43,0		;Belfour !
sfj2	.word	00bdbh,-61,0		;belfour 1
sfj5	.word	00be0h,-52,0		;belfour 4
sp_nickname_belfour
	.word	10,3
	.long	sp_belfour
	.long	sp_belfour
	.long	sp_nnr
sp_nnr	.word	00bdeh,-60,0		;eddie the eagle (belfour)
sp_by_belfour
	.word	10,3
	.long	sfk1,sfk2,sfk3
sfk1	.word	010d1h,-84,0		;BY belfour 3
sfk2	.word	010d2h,-72,0		;BY eddie the eagle (belfour)
sfk3	.word	010d3h,-64,0		;BY belfour 4

sp_tim_chevaldae
	.word	00cc9h,-34		;tim (cheveldae)
	.word	00ccbh,-70,0		;cheveldae 4
sp_chevaldae
	.word	10,2
	.long	sfl2,sfl3
sfl2	.word	00ccah,-59,0		;cheveldae 3
sfl3	.word	00ccbh,-70,0		;cheveldae 4
sp_by_chevaldae
	.word	10,2
	.long	sfm2,sfm3
sfm2	.word	0111ch,-71,0		;BY cheveldae 3
sfm3	.word	0111dh,-82,0		;BY cheveldae 4

sp_andy_moog
	.word	00cd6h,-41		;andy (moog)
	.word	00cd9h,-52,0		;moog 4
sp_moog
	.word	10,2
	.long	sfn1,sfn3
sfn1	.word	00cd7h,-46,0		;moog 2
sfn3	.word	00cd9h,-52,0		;moog 4
sp_by_moog
	.word	10,2
	.long	sfo1,sfo3
sfo1	.word	0111fh,-58,0		;BY moog 2
sfo3	.word	01121h,-64,0		;BY moog 4

sp_kirk_mclean
	.word	00ce4h,-25		;kirk (mclean)
	.word	00ce5h,-60,0		;mclean 2
sp_mclean
	.word	10,2
	.long	sfp2,sfp3
sfp2	.word	00ce5h,-60,0		;mclean 2
sfp3	.word	00ce6h,-64,0		;mclean 3
sp_by_mclean
	.word	10,2
	.long	sfq2,sfq3
sfq2	.word	01123h,-72,0		;BY mclean 2
sfq3	.word	01124h,-76,0		;BY mclean 3

sp_trevor_kidd
	.word	10,2
	.long	sfr1,sfr2
sfr1	.word	00cf1h,-32		;trevor 1 (kidd)
	.word	00cf2h,-44,0		;kidd 2
sfr2	.word	00cf3h,-33		;trevor 2 (kidd)
	.word	00cf4h,-40,0		;kidd 3
sp_kidd
	.word	10,2
	.long	sfs2,sfs3
sfs2	.word	00cf2h,-44,0		;kidd 2
sfs3	.word	00cf4h,-40,0		;kidd 3
sp_by_kidd
	.word	10,2
	.long	sft2,sft3
sft2	.word	01127h,-56,0		;BY kidd 2
sft3	.word	01128h,-52,0		;BY kidd 3

sp_arturs_irbe
	.word	00d01h,-42		;arturs (irbe)
	.word	00d02h,-61,0		;irbe 4
sp_irbe
	.word	10,3
	.long	sfu1,sfu2,sfu4
sfu1	.word	00cfeh,-49,0		;irbe 1
sfu2	.word	00cffh,-49,0		;irbe 2
sfu4	.word	00d02h,-61,0		;irbe 4
sp_by_irbe
	.word	10,3
	.long	sfv1,sfv2,sfv4
sfv1	.word	0112ah,-61,0		;BY irbe 1
sfv2	.word	0112bh,-61,0		;BY irbe 2
sfv4	.word	0112dh,-73,0		;BY irbe 4

sp_kelly_hrudey
	.word	00d0fh,-34		;kelly (hrudey)
	.word	00d10h,-48,0		;hrudey 2
sp_hrudey
	.word	10,3
	.long	sfw1,sfw2,sfw3
sfw1	.word	00d0eh,-40,0		;hrudey 1
sfw2	.word	00d10h,-48,0		;hrudey 2
sfw3	.word	00d11h,-53,0		;hrudey 3
sp_by_hrudey
	.word	10,3
	.long	sfx1,sfx2,sfx3
sfx1	.word	0112eh,-52,0		;BY hrudey 1
sfx2	.word	0112fh,-60,0		;BY hrudey 2
sfx3	.word	01130h,-65,0		;BY hrudey 3

sp_guy_hebert
	.word	00d1dh,-32		;guy (hebert)
	.word	00d1eh,-49,0		;hebert 3
sp_hebert
	.word	10,3
	.long	sfy1,sfy2,sfy3
sfy1	.word	00d1bh,-64,0		;hebert 1
sfy2	.word	00d1ch,-52,0		;hebert 2
sfy3	.word	00d1eh,-49,0		;hebert 3
sp_by_hebert
	.word	10,3
	.long	sfz1,sfz2,sfz3
sfz1	.word	01132h,-76,0		;BY hebert 1
sfz2	.word	01133h,-64,0		;BY hebert 2
sfz3	.word	01134h,-61,0		;BY hebert 3

sp_bill_ranford
	.word	00d29h,-25		;bill (ranford)
	.word	00d2ah,-55,0		;ranford 2
sp_ranford
	.word	10,3
	.long	sga1,sga2,sga4
sga1	.word	00d28h,-47,0		;ranford 1
sga2	.word	00d2ah,-55,0		;ranford 2
sga4	.word	00d2dh,-60,0		;ranford 5
sp_by_ranford
	.word	10,3
	.long	sgb1,sgb2,sgb4
sgb1	.word	01136h,-59,0		;BY ranford 1
sgb2	.word	01137h,-67,0		;BY ranford 2
sgb4	.word	0113ah,-72,0		;BY ranford 5

sp_jeremy_roenick
	.word	00bceh,-37		;jeremy (roenick)
	.word	00bcfh,-47,0		;roenick 4
sp_roenick
	.word	10,2
	.long	sgc1,sgc3
sgc1	.word	00bcbh,-40,0		;roenick 2
sgc3	.word	00bcfh,-47,0		;roenick 4
sp_nickname_roenick
	.word	10,3
	.long	sp_jeremy_roenick
	.long	sp_jeremy_roenick
	.long	sp_nnq
sp_nnq	.word	00bcdh,-41		;j. r. (roenick)
	.word	00bceh,-37		;jeremy (roenick)
	.word	00bcfh,-47,0		;roenick 4
sp_to_roenick
	.word	10,2
	.long	sgd1,sgd3
sgd1	.word	0145ah,-54,0		;to roenick 2
sgd3	.word	0145ch,-61,0		;to roenick 4

sp_bob_corkum
	.word	00d4bh,-35		;bob (corkum)
	.word	00d4ch,-43,0		;corkum 2
sp_corkum
	.word	10,2
	.long	sge1,sge2
sge1	.word	00d4ah,-54,0		;corkum 1
sge2	.word	00d4ch,-43,0		;corkum 2
sp_to_corkum
	.word	10,2
	.long	sgf1,sgf2
sgf1	.word	0150fh,-69,0		;to corkum 1
sgf2	.word	01510h,-57,0		;to corkum 2

sp_adam_oates
	.word	00d43h,-39		;adam (oates)
	.word	00d44h,-46,0		;oates 2
sp_oates
	.word	10,2
	.long	sgg1,sgg2
sgg1	.word	00d42h,-46,0		;oates 1
sgg2	.word	00d44h,-46,0		;oates 2
sp_to_oates
	.word	10,2
	.long	sgh1,sgh2
sgh1	.word	01509h,-60,0		;to oates 1
sgh2	.word	0150ah,-60,0		;to oates 2

sp_derek_plante
	.word	00d59h,-28		;derek 2 (plante)
	.word	00d58h,-40,0		;plante 3
sp_plante
	.word	10,2
	.long	sgi2,sgi3
sgi2	.word	00d57h,-38,0		;plante 2
sgi3	.word	00d58h,-40,0		;plante 3
sp_to_plante
	.word	10,2
	.long	sgj2,sgj3
sgj2	.word	01519h,-52,0		;to plante 2
sgj3	.word	0151ah,-54,0		;to plante 3

sp_phil_housley
	.word	00d75h,-34		;phil (housley)
	.word	00d74h,-51,0		;housley 2
sp_housley
	.word	10,2
	.long	sgk1,sgk2
sgk1	.word	00d73h,-54,0		;housley 1
sgk2	.word	00d74h,-51,0		;housley 2
sp_to_housley
	.word	10,2
	.long	sgl1,sgl2
sgl1	.word	0152dh,-69,0		;to housley 1
sgl2	.word	0152eh,-66,0		;to housley 2

sp_denis_savard
	.word	00d5ch,-24		;dennis (savard)
	.word	00d5bh,-41,0		;savard 1
sp_savard
	.word	10,2
	.long	sgm1,sgm3
sgm1	.word	00d5bh,-41,0		;savard 1
sgm3	.word	00d5eh,-63,0		;savard 3
sp_nickname_savard
	.word	10,3
	.long	sp_denis_savard
	.long	sp_denis_savard
	.long	sp_nnz
sp_nnz	.word	00d5ah,-80,0		;savour faire (d. savard)
sp_to_savard
	.word	10,2
	.long	sgn1,sgn3
sgn1	.word	0151bh,-55,0		;to savard 1
sgn3	.word	0151dh,-77,0		;to savard 3

sp_dave_gagner
	.word	00d62h,-34		;dave (gagner)
	.word	00d61h,-51,0		;gagner 3
sp_gagner
	.word	10,2
	.long	sgo2,sgo3
sgo2	.word	00d60h,-49,0		;gagner 2
sgo3	.word	00d61h,-51,0		;gagner 3
sp_to_gagner
	.word	10,2
	.long	sgp2,sgp3
sgp2	.word	0151fh,-64,0		;to gagner 2
sgp3	.word	01520h,-66,0		;to gagner 3

sp_paul_coffey
	.word	00bc1h,-42		;paul (coffey)
	.word	00bc2h,-46,0		;coffey 2
sp_coffey
	.word	10,2
	.long	sgq2,sgq3
sgq2	.word	00bc2h,-46,0		;coffey 2
sgq3	.word	00bc3h,-55,0		;coffey 3
sp_to_coffey
	.word	10,2
	.long	sgr2,sgr3
sgr2	.word	01457h,-60,0		;to coffey 2
sgr3	.word	01458h,-69,0		;to coffey 3

sp_dino_ciccarelli
	.word	00d53h,-30		;dino (ciccarelli)
	.word	00d54h,-57,0		;ciccarelli 2
sp_ciccarelli
	.word	10,2
	.long	sgs1,sgs2
sgs1	.word	00d52h,-69,0		;ciccarelli 1
sgs2	.word	00d54h,-57,0		;ciccarelli 2
sp_to_ciccarelli
	.word	10,2
	.long	sgt1,sgt2
sgt1	.word	01515h,-84,0		;to ciccarelli 1
sgt2	.word	01516h,-71,0		;to ciccarelli 2

sp_doug_weight
	.word	00ca1h,-32		;doug (gilmore)
	.word	00da0h,-32,0		;weight 2
sp_weight
	.word	10,2
	.long	sgu1,sgu2
sgu1	.word	00da0h,-32,0		;weight 2
sgu2	.word	00da1h,-24,0		;weight 3
sp_to_weight
	.word	10,2
	.long	sgv1,sgv2
sgv1	.word	0154ch,-46,0		;to weight 2
sgv2	.word	0154dh,-38,0		;to weight 3

sp_jason_arnott
	.word	00d77h,-41		;jason (arnott)
	.word	00d78h,-42,0		;arnott 1
sp_arnott
	.word	10,2
	.long	sgw1,sgw2
sgw1	.word	00d78h,-42,0		;arnott 1
sgw2	.word	00d79h,-31,0		;arnott 3
sp_to_arnott
	.word	10,2
	.long	sgx1,sgx2
sgx1	.word	01530h,-56,0		;to arnott 1
sgx2	.word	01531h,-45,0		;to arnott 3

sp_jesse_belanger
	.word	00d51h,-36		;jesse 2 (belanger)
	.word	00d50h,-55,0		;belanger 3
sp_belanger
	.word	10,2
	.long	sgy2,sgy3
sgy2	.word	00d4fh,-61,0		;belanger 2
sgy3	.word	00d50h,-55,0		;belanger 3
sp_to_belanger
	.word	10,2
	.long	sgz2,sgz3
sgz2	.word	01513h,-76,0		;to belanger 2
sgz3	.word	01514h,-69,0		;to belanger 3

sp_rick_tocchet
	.word	00d94h,-26		;rick (tocchet)
	.word	00d95h,-42,0		;tocchet 2
sp_tocchet
	.word	10,2
	.long	sha1,sha2
sha1	.word	00d93h,-45,0		;tocchet 1
sha2	.word	00d95h,-42,0		;tocchet 2
sp_to_tocchet
	.word	10,2
	.long	shb1,shb2
shb1	.word	01543h,-59,0		;to tocchet 1
shb2	.word	01544h,-56,0		;to tocchet 2

sp_pierre_turgeon
	.word	00d3bh,-33		;pierre (turgeon)
	.word	00d3ch,-41,0		;p. turgeon 3
sp_turgeon
	.word	10,2
	.long	shc2,shc3
shc2	.word	00d3ah,-44,0		;p. turgeon 2
shc3	.word	00d3ch,-41,0		;p. turgeon 3
sp_to_turgeon
	.word	10,2
	.long	shd2,shd3
shd2	.word	01504h,-59,0		;to p. turgeon 2
shd3	.word	01505h,-55,0		;to p. turgeon 3

sp_mario_lemieux
	.word	00d7eh,-36		;mario (lemieux)
	.word	00d80h,-50,0		;m. lemieux 2
sp_claude_lemieux
	.word	00d7fh,-27		;claude (lemieux)
	.word	00d80h,-50,0		;m. lemieux 2
sp_clemieux
sp_mlemieux
	.word	10,2
	.long	she2,she3
she2	.word	00d80h,-50,0		;m. lemieux 2
she3	.word	00d81h,-53,0		;m. lemieux 3
sp_nickname_mlemieux
	.word	10,3
	.long	sp_mario_lemieux
	.long	sp_mario_lemieux
	.long	sp_nnx
sp_nnx	.word	00d7bh,-62,0		;le magnifique (mario lemieux)
sp_to_mlemieux
sp_to_clemieux
	.word	10,2
	.long	shf2,shf3
shf2	.word	01534h,-64,0		;to m. lemieux 2
shf3	.word	01535h,-67,0		;to m. lemieux 3

sp_kevin_stevens
	.word	00cd1h,-31		;derian (hatcher)
	.word	00da4h,-39+2,0		;stevens 2
sp_scott_stevens
	.word	00da5h,-35		;scott (stevens)
	.word	00da6h,-43+2,0		;stevens 3
sp_kstevens
sp_stevens
	.word	10,2
	.long	shg2,shg3
shg2	.word	00da4h,-39+2,0		;stevens 2
shg3	.word	00da6h,-43+2,0		;stevens 3
sp_to_kstevens
sp_to_stevens
	.word	10,2
	.long	shh2,shh3
shh2	.word	01550h,-54+2,0		;to stevens 2
shh3	.word	01551h,-58+2,0		;to stevens 3

sp_ray_ferraro
	.word	00d69h,-28		;ray 2 (ferraro)
	.word	00d6ah,-56,0		;ferraro 4
sp_ferraro
	.word	10,2
	.long	shi2,shi3
shi2	.word	00d68h,-50,0		;ferraro 2
shi3	.word	00d6ah,-56,0		;ferraro 4
sp_to_ferraro
	.word	10,2
	.long	shj2,shj3
shj2	.word	01525h,-64,0		;to ferraro 2
shj3	.word	01526h,-70,0		;to ferraro 4

sp_brian_leetch
	.word	00d35h,-31		;brian (leetch) 
	.word	00d36h,-30,0		;leetch 1
sp_leetch
	.word	10,2
	.long	shk1,shk2
shk1	.word	00d36h,-30,0		;leetch 1
shk2	.word	00d37h,-23,0		;leetch 2
sp_to_leetch
	.word	10,2
	.long	shl1,shl2
shl1	.word	01500h,-44,0		;to leetch 1
shl2	.word	01501h,-37,0		;to leetch 2

sp_radek_bonk
	.word	00d8dh,-34		;radek 2 (bonk)
	.word	00d8eh,-32,0		;bonk 3
sp_bonk
	.word	10,2
	.long	shm2,shm3
shm2	.word	00d8ch,-33,0		;bonk 2
shm3	.word	00d8eh,-32,0		;bonk 3
sp_to_bonk
	.word	10,2
	.long	shn2,shn3
shn2	.word	0153eh,-48,0		;to bonk 2
shn3	.word	0153fh,-46,0		;to bonk 3

sp_mikael_renberg
	.word	00d92h,-28		;michael (renberg)
	.word	00d91h,-48,0		;renberg 3
sp_renberg
	.word	10,2
	.long	sho2,sho3
sho2	.word	00d90h,-44,0		;renberg 2
sho3	.word	00d91h,-48,0		;renberg 3
sp_to_renberg
	.word	10,2
	.long	shp2,shp3
shp2	.word	01541h,-59,0		;to renberg 2
shp3	.word	01542h,-62,0		;to renberg 3

sp_eric_desjardins
	.word	00d64h,-27		;eric (desjardin)
	.word	00d65h,-57,0		;desjardin 2
sp_desjardins
	.word	10,2
	.long	shq1,shq2
shq1	.word	00d63h,-54,0		;desjardin 1
shq2	.word	00d65h,-57,0		;desjardin 2
sp_to_desjardins
	.word	10,2
	.long	shr1,shr2
shr1	.word	01521h,-68,0		;to desjardin 1
shr2	.word	01522h,-72,0		;to desjardin 2

sp_owen_nolan
	.word	00d88h,-36		;owen 2 (nolan)
	.word	00d89h,-44,0		;nolan 3
sp_nolan
	.word	10,2
	.long	shs2,shs3
shs2	.word	00d89h,-44,0		;nolan 3
shs3	.word	00d8ah,-58,0		;nolan 4
sp_to_nolan
	.word	10,2
	.long	sht2,sht3
sht2	.word	0153bh,-59,0		;to nolan 3
sht3	.word	0153ch,-72,0		;to nolan 4

sp_sergei_makarov
	.word	00bb9h,-43		;sergei (federov)
	.word	00d9dh,-53,0		;makarov 2
sp_makarov
	.word	10,2
	.long	shu2,shu3
shu2	.word	00d9dh,-53,0		;makarov 2
shu3	.word	00d9eh,-56,0		;makarov 3
sp_to_makarov
	.word	10,2
	.long	shv2,shv3
shv2	.word	0154ah,-67,0		;to makarov 2
shv3	.word	0154bh,-70,0		;to makarov 3

sp_esa_tikkanen
	.word	00d99h,-34		;esa (tikkanen)
	.word	00d9ah,-51,0		;tikkanen 3
sp_tikkanen
	.word	10,2
	.long	shw2,shw3
shw2	.word	00d98h,-40,0		;tikkanen 2
shw3	.word	00d9ah,-51,0		;tikkanen 3
sp_to_tikkanen
	.word	10,2
	.long	shx2,shx3
shx2	.word	01547h,-54,0		;to tikkanen 2
shx3	.word	01548h,-65,0		;to tikkanen 3

sp_roman_hamrlik
	.word	00d6ch,-36		;roman (hamerlick)
	.word	00d6bh,-52,0		;hamerlick 2
sp_hamrlik
	.word	00d6bh,-52,0		;hamerlick 2
sp_to_hamrlik
	.word	01527h,-67,0		;to hamerlick 2

sp_mats_sundin
	.word	00d84h,-22		;matts (sundin)
	.word	00d85h,-62,0		;sundin 3
sp_sundin
	.word	10,2
	.long	sia2,sia3
sia2	.word	00d83h,-66,0		;sundin 2
sia3	.word	00d85h,-62,0		;sundin 3
sp_to_sundin
	.word	10,2
	.long	sib2,sib3
sib2	.word	01537h,-80,0		;to sundin 2
sib3	.word	01538h,-77,0		;to sundin 3

sp_sylvain_cote
	.word	00d3eh,-37		;sylvain (cote or turgeon) 
	.word	00d3fh,-45,0		;cote 1
sp_cote
	.word	10,2
	.long	sic1,sic3
sic1	.word	00d3fh,-45,0		;cote 1
sic3	.word	00d41h,-43,0		;cote 3
sp_to_cote
	.word	10,2
	.long	sid1,sid3
sid1	.word	01506h,-59,0		;to cote 1
sid3	.word	01508h,-57,0		;to cote 3

sp_alexei_zhamnov
	.word	00d46h,-44		;alexei	(zhamnov)
	.word	00d47h,-60,0		;zhamnov 1
sp_zhamnov
	.word	10,2
	.long	sie1,sie2
sie1	.word	00d47h,-60,0		;zhamnov 1
sie2	.word	00d48h,-49,0		;zhamnov 2
sp_to_zhamnov
	.word	10,2
	.long	sif1,sif2
sif1	.word	0150ch,-74,0		;to zhamnov 1
sif2	.word	0150dh,-64,0		;to zhamnov 2

sp_dale_hawerchuk
	.word	00d71h,-38		;dale (hawerchuck)
	.word	00d70h,-51,0		;hawerchuck 2
sp_hawerchuk
	.word	10,2
	.long	sig2,sig3
sig2	.word	00d70h,-51,0		;hawerchuck 2
sig3	.word	00d72h,-52,0		;hawerchuck 3
sp_to_hawerchuk
	.word	10,2
	.long	sih2,sih3
sih2	.word	0152bh,-65,0		;to hawerchuck 2
sih3	.word	0152ch,-67,0		;to hawerchuck 3


sp_doug_bodger
	.word	00ca1h,-28		;doug (gilmore/weight/bodger)
sp_bodger
	.word	10,2
	.long	sii2,sii3
sii2	.word	00dabh,-54,0		;bodger 2
sii3	.word	00dach,-41,0		;bodger 4
sp_to_bodger
	.word	10,2
	.long	sij2,sij3
sij2	.word	01556h,-69,0		;bodger 2
sij3	.word	01557h,-55,0		;bodger 4

sp_derek_king
	.word	00d59h,-25		;derek (plante/king)
sp_king
	.word	10,2
	.long	sik2,sik3
sik2	.word	00da8h,-34,0		;king 2
sik3	.word	00da9h,-41,0		;king 3
sp_to_king
	.word	10,2
	.long	sil2,sil3
sil2	.word	01553h,-49,0		;king 2
sil3	.word	01554h,-56,0		;king 3

sp_joe_nieuwendyk
	.word	00c50h,-35		;joe (sakic/juneau/bodger)
sp_nieuwendyk
	.word	10,2
	.long	sim2,sim3
sim2	.word	00daeh,-49,0		;nieuwendyk 2
sim3	.word	00dafh,-59,0		;nieuwendyk 4
sp_to_nieuwendyk
	.word	10,2
	.long	sin2,sin3
sin2	.word	01559h,-64,0		;nieuwendyk 2
sin3	.word	0155ah,-73,0		;nieuwendyk 4

sp_jon_casey
	.word	10,2
	.long	sio1,sio2
sio1	.word	00db5h,-39		;jon (casey)
sio2	.word	00db4h,-44,0		;casey 3

sp_casey
	.word	10,3
	.long	sip1,sip2,sip3
sip1	.word	00db3h,-49,0		;casey 2
sip2	.word	00db4h,-44,0		;casey 3
sip3	.word	00db6h,-62,0		;casey 4

sp_by_casey
	.word	10,3
	.long	siq1,siq2,siq3
siq1	.word	0113bh,-61,0		;BY casey 2
siq2	.word	0113ch,-56,0		;BY casey 3
siq3	.word	0113dh,-74,0		;BY casey 4

sp_to_janney
	.word	10,2
	.long	tjann1,tjann2
tjann1	.word	0155dh,-52,0		;to janney 1
tjann2	.word	0155eh,-47,0		;to janney 2

sp_craig_janney
	.word	00db9h,-22		;craig (janney)
	.word	00db8h,-38,0		;janney 2
sp_janney
	.word	10,2
	.long	jann1,jann2
jann1	.word	00db7h,-43,0		;janney 1
jann2	.word	00db8h,-38,0		;janney 2

sp_zarley_zalapski
	.word	00db0h,-35		;zarley (zalapski)
sp_zalapski
	.word	10,2
	.long	zlap1,zlap2
zlap1	.word	00db1h,-59,0		;zalapski 1
zlap2	.word	00db2h,-57,0		;zalapski 3

sp_to_zalapski
	.word	10,2
	.long	tzlap1,tzlap2
tzlap1	.word	0155bh,-68,0		;to zalapski 1
tzlap2	.word	0155ch,-66,0		;to zalapski 3

sp_to_howe
	.word	0155fh,-48,0		;to howe 1

sp_nickname_howe
	.word	10,2
	.long	sp_gordie_howe
	.long	sp_nnhw

sp_nnhw	.word	10,2
	.long	nnhw1,nnhw2
nnhw1	.word	00dbch,-59,0		;Mr. Hockey (g.howe)
nnhw2	.word	00dbch,-59		;Mr. Hockey (g.howe)
sp_gordie_howe
	.word	00dbah,-29		;gordy (howe)
sp_howe
	.word	00dbbh,-39,0		;howe 1

sp_soderstrom
	.word	00dbeh,-59,0		;soderstrom 1

sp_by_soderstrom
	.word	0113eh,-71,0		;BY soderstrom 1

sp_tommy_soderstrom
	.word	00dbdh,-32		;tommy (soders.)
	.word	00dbeh,-59,0		;soderstrom 1

sp_osgood
	.word	10,2
	.long	osgd1,osgd2
osgd1	.word	00dc0h,-46,0		;osgood 1
osgd2	.word	00dc2h,-46,0		;osgood 3

sp_by_osgood
	.word	10,2
	.long	osgd3,osgd4
osgd3	.word	01140h,-59,0		;BY osgood 1
osgd4	.word	01142h,-58,0		;BY osgood 3

sp_chris_osgood
	.word	00bd2h,-37		;chris (chelios)
	.word	10,2
	.long	osgd5,osgd6
osgd5	.word	00dc0h,-46,0		;osgood 1
osgd6	.word	00dc2h,-46,0		;osgood 3

sp_fuhr
	.word	10,2
	.long	fuhr1,fuhr2
fuhr1	.word	00dc4h,-41,0		;fuhr 1
fuhr2	.word	00dc5h,-48,0		;fuhr 2

sp_by_fuhr
	.word	10,2
	.long	fuhr3,fuhr4
fuhr3	.word	01143h,-53,0		;BY fuhr 1
fuhr4	.word	01144h,-60,0		;BY fuhr 2

sp_grant_fuhr
	.word	00dc3h,-33		;grant (fuhr)
	.word	00dc4h,-41,0		;fuhr 1

city_name_tab
	.long	sp_boston
	.long	sp_boston
	.long	sp_buffalo
	.long	sp_hartford
	.long	sp_montreal
	.long	sp_ottawa
	.long	sp_pittsburgh
	.long	sp_colorado
	.long	sp_florida
	.long	sp_new_jersey
	.long	sp_new_yorkr
	.long	sp_new_yorki
	.long	sp_philadelphia
	.long	sp_tampa_bay
	.long	sp_washington
	.long	sp_chicago
	.long	sp_dallas
	.long	sp_detroit
	.long	sp_st_louis
	.long	sp_toronto
	.long	sp_winnipeg
	.long	sp_anaheim
	.long	sp_calgary
	.long	sp_edmonton
	.long	sp_los_angeles
	.long	sp_san_jose
	.long	sp_vancouver
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none

sp_boston	.word	01034h,-35+2,0
sp_buffalo	.word	01025h,-30+2,0
sp_hartford	.word	01038h,-41+2,0
sp_montreal	.word	0102dh,-44+2,0
sp_ottawa	.word	0103eh,-35+2,0
sp_pittsburgh	.word	01021h,-27+2,0
sp_colorado	.word	01029h,-48+2,0
sp_florida	.word	01019h,-41+2,0
sp_new_jersey	.word	01009h,-35+2,0
sp_new_yorkr	.word	01005h,-28+2,0
sp_new_yorki	.word	01015h,-28+2,0
sp_philadelphia	.word	01011h,-38+2,0
sp_tampa_bay	.word	0101dh,-41+2,0
sp_washington	.word	0100dh,-31+2,0
sp_chicago	.word	01052h,-46+2,0
sp_dallas	.word	0105ch,-25+2,0
sp_detroit	.word	01042h,-37+2,0
sp_st_louis	.word	0104eh,-30+4,0
sp_toronto	.word	01048h,-46+2,0
sp_winnipeg	.word	01058h,-45+2,0
sp_anaheim	.word	01070h,-40+2,0
sp_calgary	.word	01064h,-36+2,0
sp_edmonton	.word	01076h,-44+2,0
sp_los_angeles	.word	0106ch,-44+4,0
sp_san_jose	.word	01068h,-50+2,0
sp_vancouver	.word	01060h,-34+2,0

team_name_tab
	.long	sp_bruins
	.long	sp_bruins
	.long	sp_sabres
	.long	sp_whalers
	.long	sp_canadiens
	.long	sp_senators
	.long	sp_penguins
	.long	sp_colorado
	.long	sp_panthers
	.long	sp_devils
	.long	sp_islanders
	.long	sp_rangers
	.long	sp_flyers
	.long	sp_lightning
	.long	sp_capitals
	.long	sp_blackhawks
	.long	sp_stars
	.long	sp_red_wings
	.long	sp_blues
	.long	sp_maple_leafs
	.long	sp_jets
	.long	sp_mighty_ducks
	.long	sp_flames
	.long	sp_oilers
	.long	sp_kings
	.long	sp_sharks
	.long	sp_canucks
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none

sp_bruins	.word	01036h,-30+4,0
sp_sabres	.word	01027h,-33+4,0
sp_whalers	.word	0103ah,-43+4,0
sp_canadiens	.word	0102fh,-47+4,0
sp_les_habitant	.word	01030h,-63+4,0	;Les Habitants

sp_senators	.word	01040h,-41+4,0
sp_penguins	.word	01023h,-36+4,0
sp_avalanche	.word	0102bh,-54+2,0
sp_panthers	.word	0101bh,-49+4,0
sp_devils	.word	0100bh,-36+4,0
sp_islanders	.word	01017h,-49+4,0
sp_rangers	.word	01007h,-46+4,0
sp_flyers	.word	01013h,-43+4,0
sp_lightning	.word	0101fh,-31+2,0
sp_capitals	.word	0100fh,-41+4,0
sp_blackhawks	.word	01054h,-46+4,0
sp_stars	.word	0105eh,-50+4,0
sp_red_wings	.word	01044h,-50+4,0
sp_blues	.word	01050h,-40+4,0
sp_maple_leafs	.word	0104ah,-45+4,0
sp_jets		.word	0105ah,-31+4,0
sp_mighty_ducks	.word	01072h,-38,0
sp_flames	.word	01066h,-40+4,0
sp_oilers	.word	01078h,-44+4,0
sp_kings	.word	0106eh,-32+4,0
sp_sharks	.word	0106ah,-33+4,0
sp_canucks	.word	01062h,-31+4,0

the_team_name_tab
	.long	sp_the_bruins
	.long	sp_the_bruins
	.long	sp_the_sabres
	.long	sp_the_whalers
	.long	sp_the_canadiens
	.long	sp_the_senators
	.long	sp_the_penguins
	.long	sp_colorado
	.long	sp_the_panthers
	.long	sp_the_devils
	.long	sp_the_islanders
	.long	sp_the_rangers
	.long	sp_the_flyers
	.long	sp_the_lightning
	.long	sp_the_capitals
	.long	sp_the_blackhawks
	.long	sp_the_stars
	.long	sp_the_red_wings
	.long	sp_the_blues
	.long	sp_the_maple_leafs
	.long	sp_the_jets
	.long	sp_the_mighty_ducks
	.long	sp_the_flames
	.long	sp_the_oilers
	.long	sp_the_kings
	.long	sp_the_sharks
	.long	sp_the_canucks
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none

sp_the_bruins		.word	01035h,-43+4,0
sp_the_sabres		.word	01026h,-46+4,0
sp_the_whalers		.word	01039h,-56+4,0
sp_the_canadiens	.word	0102eh,-60+4,0
sp_the_senators		.word	0103fh,-54+4,0
sp_the_penguins		.word	01022h,-49+4,0
sp_the_avalanche	.word	0102ah,-61+2,0
sp_the_panthers		.word	0101ah,-62+4,0
sp_the_devils		.word	0100ah,-49+4,0
sp_the_islanders	.word	01016h,-59+4,0
sp_the_rangers		.word	01006h,-59+4,0
sp_the_flyers		.word	01012h,-56+4,0
sp_the_lightning	.word	0101eh,-44+2,0
sp_the_capitals		.word	0100eh,-54+4,0
sp_the_blackhawks	.word	01053h,-59+4,0
sp_the_stars		.word	0105dh,-63+4,0
sp_the_red_wings	.word	01043h,-63+4,0
sp_the_blues		.word	0104fh,-53+4,0
sp_the_maple_leafs	.word	01049h,-58+4,0
sp_the_jets		.word	01059h,-43+4,0
sp_the_mighty_ducks	.word	01071h,-51,0
sp_the_flames		.word	01065h,-53+4,0
sp_the_oilers		.word	01077h,-52+4,0
sp_the_kings		.word	0106dh,-45+4,0
sp_the_sharks		.word	01069h,-46+4,0
sp_the_canucks		.word	01061h,-44+4,0

city_team_name_tab
	.long	sp_boston_bruins
	.long	sp_boston_bruins
	.long	sp_buffalo_sabres
	.long	sp_hartford_whalers
	.long	sp_montreal_canadiens
	.long	sp_ottawa_senators
	.long	sp_pittsburgh_penguins
	.long	sp_colorado_avalanche
	.long	sp_florida_panthers
	.long	sp_new_jersey_devils
	.long	sp_new_york_islanders
	.long	sp_new_york_rangers
	.long	sp_philadelphia_flyers
	.long	sp_tampa_bay_lightning
	.long	sp_washington_capitals
	.long	sp_chicago_blackhawks
	.long	sp_dallas_stars
	.long	sp_detroit_red_wings
	.long	sp_st_louis_blues
	.long	sp_toronto_maple_leafs
	.long	sp_winnipeg_jets
	.long	sp_mighty_ducks_of_anaheim
	.long	sp_calgary_flames
	.long	sp_edmonton_oilers
	.long	sp_los_angeles_kings
	.long	sp_san_jose_sharks
	.long	sp_vancouver_canucks
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none

sp_boston_bruins		.word	01033h,-76+4,0
sp_buffalo_sabres		.word	01024h,-74+4,0
sp_hartford_whalers		.word	01037h,-88+4,0
sp_montreal_canadiens		.word	0102ch,-101+4,0
sp_ottawa_senators		.word	0103dh,-76+4,0
sp_pittsburgh_penguins		.word	01020h,-76+4,0
sp_colorado_avalanche		.word	01028h,-115+2,0
sp_florida_panthers		.word	01018h,-87+4,0
sp_new_jersey_devils		.word	01008h,-83+4,0
sp_new_york_islanders		.word	01014h,-92+4,0
sp_new_york_rangers		.word	01004h,-87+4,0
sp_philadelphia_flyers		.word	01010h,-94+4,0
sp_tampa_bay_lightning		.word	0101ch,-86+4,0
sp_washington_capitals		.word	0100ch,-86+4,0
sp_chicago_blackhawks		.word	01051h,-99+4,0
sp_dallas_stars			.word	0105bh,-83+4,0
sp_detroit_red_wings		.word	01041h,-86+4,0
sp_st_louis_blues		.word	0104dh,-84+4,0
sp_toronto_maple_leafs		.word	01047h,-83+4,0
sp_winnipeg_jets		.word	01057h,-75+4,0
sp_mighty_ducks_of_anaheim	.word	0106fh,-100+4,0
sp_calgary_flames		.word	01063h,-81+4,0
sp_edmonton_oilers		.word	01075h,-85+4,0
sp_los_angeles_kings		.word	0106bh,-90+4,0
sp_san_jose_sharks		.word	01067h,-86+4,0
sp_vancouver_canucks		.word	0105fh,-79+4,0


random_team_version_tab
	.long	sp_rnd_boston_bruins
	.long	sp_rnd_boston_bruins
	.long	sp_rnd_buffalo_sabres
	.long	sp_rnd_hartford_whalers
	.long	sp_rnd_montreal_canadiens
	.long	sp_rnd_ottawa_senators
	.long	sp_rnd_pittsburgh_penguins
	.long	sp_rnd_colorado_avalanche
	.long	sp_rnd_florida_panthers
	.long	sp_rnd_new_jersey_devils
	.long	sp_rnd_new_york_islanders
	.long	sp_rnd_new_york_rangers
	.long	sp_rnd_philadelphia_flyers
	.long	sp_rnd_tampa_bay_lightning
	.long	sp_rnd_washington_capitals
	.long	sp_rnd_chicago_blackhawks
	.long	sp_rnd_dallas_stars
	.long	sp_rnd_detroit_red_wings
	.long	sp_rnd_st_louis_blues
	.long	sp_rnd_toronto_maple_leafs
	.long	sp_rnd_winnipeg_jets
	.long	sp_rnd_mighty_ducks_of_anaheim
	.long	sp_rnd_calgary_flames
	.long	sp_rnd_edmonton_oilers
	.long	sp_rnd_los_angeles_kings
	.long	sp_rnd_san_jose_sharks
	.long	sp_rnd_vancouver_canucks
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none

sp_rnd_boston_bruins
	.word	10,3
	.long	sp_boston_bruins,sp_bruins,sp_the_bruins
sp_rnd_buffalo_sabres
	.word	10,3
	.long	sp_buffalo_sabres,sp_sabres,sp_the_sabres
sp_rnd_hartford_whalers
	.word	10,3
	.long	sp_hartford_whalers,sp_whalers,sp_the_whalers
sp_rnd_montreal_canadiens
	.word	10,10
	.long	sp_montreal_canadiens,sp_canadiens,sp_the_canadiens
	.long	sp_montreal_canadiens,sp_canadiens,sp_the_canadiens
	.long	sp_montreal_canadiens,sp_canadiens,sp_the_canadiens
	.long	sp_les_habitant
sp_rnd_ottawa_senators
	.word	10,3
	.long	sp_ottawa_senators,sp_senators,sp_the_senators
sp_rnd_pittsburgh_penguins
	.word	10,3
	.long	sp_pittsburgh_penguins,sp_penguins,sp_the_penguins
sp_rnd_colorado_avalanche
;	.word	10,3
;	.long	sp_colorado_avalanche,sp_avalanche,sp_the_avalanche
	.word	10,2
	.long	sp_colorado_avalanche,sp_colorado
sp_rnd_florida_panthers
	.word	10,3
	.long	sp_florida_panthers,sp_panthers,sp_the_panthers
sp_rnd_new_jersey_devils
	.word	10,3
	.long	sp_new_jersey_devils,sp_devils,sp_the_devils
sp_rnd_new_york_islanders
	.word	10,3
	.long	sp_new_york_islanders,sp_islanders,sp_the_islanders
sp_rnd_new_york_rangers
	.word	10,3
	.long	sp_new_york_rangers,sp_rangers,sp_the_rangers
sp_rnd_philadelphia_flyers
	.word	10,3
	.long	sp_philadelphia_flyers,sp_flyers,sp_the_flyers
sp_rnd_tampa_bay_lightning
	.word	10,3
	.long	sp_tampa_bay_lightning,sp_lightning,sp_the_lightning
sp_rnd_washington_capitals
	.word	10,3
	.long	sp_washington_capitals,sp_capitals,sp_the_capitals
sp_rnd_chicago_blackhawks
	.word	10,3
	.long	sp_chicago_blackhawks,sp_blackhawks,sp_the_blackhawks
sp_rnd_dallas_stars
	.word	10,3
	.long	sp_dallas_stars,sp_stars,sp_the_stars
sp_rnd_detroit_red_wings
	.word	10,3
	.long	sp_detroit_red_wings,sp_red_wings,sp_the_red_wings
sp_rnd_st_louis_blues
	.word	10,3
	.long	sp_st_louis_blues,sp_blues,sp_the_blues
sp_rnd_toronto_maple_leafs
	.word	10,3
	.long	sp_toronto_maple_leafs,sp_maple_leafs,sp_the_maple_leafs
sp_rnd_winnipeg_jets
	.word	10,3
	.long	sp_winnipeg_jets,sp_jets,sp_the_jets
sp_rnd_mighty_ducks_of_anaheim
	.word	10,3
	.long	sp_anaheim,sp_mighty_ducks,sp_the_mighty_ducks
sp_rnd_calgary_flames
	.word	10,3
	.long	sp_calgary_flames,sp_flames,sp_the_flames
sp_rnd_edmonton_oilers
	.word	10,3
	.long	sp_edmonton_oilers,sp_oilers,sp_the_oilers
sp_rnd_los_angeles_kings
	.word	10,3
	.long	sp_los_angeles_kings,sp_kings,sp_the_kings
sp_rnd_san_jose_sharks
	.word	10,3
	.long	sp_san_jose_sharks,sp_sharks,sp_the_sharks
sp_rnd_vancouver_canucks
	.word	10,3
	.long	sp_vancouver_canucks,sp_canucks,sp_the_canucks

random_team_city_version_tab
	.long	sp_rnd_cboston_bruins
	.long	sp_rnd_cboston_bruins
	.long	sp_rnd_cbuffalo_sabres
	.long	sp_rnd_chartford_whalers
	.long	sp_rnd_cmontreal_canadiens
	.long	sp_rnd_cottawa_senators
	.long	sp_rnd_cpittsburgh_penguins
	.long	sp_rnd_ccolorado_avalanche
	.long	sp_rnd_cflorida_panthers
	.long	sp_rnd_cnew_jersey_devils
	.long	sp_rnd_cnew_york_islanders
	.long	sp_rnd_cnew_york_rangers
	.long	sp_rnd_cphiladelphia_flyers
	.long	sp_rnd_ctampa_bay_lightning
	.long	sp_rnd_cwashington_capitals
	.long	sp_rnd_cchicago_blackhawks
	.long	sp_rnd_cdallas_stars
	.long	sp_rnd_cdetroit_red_wings
	.long	sp_rnd_cst_louis_blues
	.long	sp_rnd_ctoronto_maple_leafs
	.long	sp_rnd_cwinnipeg_jets
	.long	sp_rnd_cmighty_ducks_of_anaheim
	.long	sp_rnd_ccalgary_flames
	.long	sp_rnd_cedmonton_oilers
	.long	sp_rnd_clos_angeles_kings
	.long	sp_rnd_csan_jose_sharks
	.long	sp_rnd_cvancouver_canucks
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none
	.long	sp_none

sp_rnd_cboston_bruins
	.word	10,4
	.long	sp_boston_bruins,sp_bruins,sp_the_bruins,sp_boston
sp_rnd_cbuffalo_sabres
	.word	10,4
	.long	sp_buffalo_sabres,sp_sabres,sp_the_sabres,sp_buffalo
sp_rnd_chartford_whalers
	.word	10,4
	.long	sp_hartford_whalers,sp_whalers,sp_the_whalers,sp_hartford
sp_rnd_cmontreal_canadiens
	.word	10,9
	.long	sp_montreal_canadiens,sp_canadiens,sp_the_canadiens,sp_montreal
	.long	sp_montreal_canadiens,sp_canadiens,sp_the_canadiens,sp_montreal
	.long	sp_les_habitant
sp_rnd_cottawa_senators
	.word	10,4
	.long	sp_ottawa_senators,sp_senators,sp_the_senators,sp_ottawa
sp_rnd_cpittsburgh_penguins
	.word	10,4
	.long	sp_pittsburgh_penguins,sp_penguins,sp_the_penguins,sp_pittsburgh
sp_rnd_ccolorado_avalanche
;	.word	10,4
;	.long	sp_colorado_avalanche,sp_avalanche,sp_the_avalanche,sp_colorado
	.word	10,2
	.long	sp_colorado_avalanche,sp_colorado
sp_rnd_cflorida_panthers
	.word	10,4
	.long	sp_florida_panthers,sp_panthers,sp_the_panthers,sp_florida
sp_rnd_cnew_jersey_devils
	.word	10,4
	.long	sp_new_jersey_devils,sp_devils,sp_the_devils,sp_new_jersey
sp_rnd_cnew_york_islanders
	.word	10,4
	.long	sp_new_york_islanders,sp_islanders,sp_the_islanders,sp_new_yorki
sp_rnd_cnew_york_rangers
	.word	10,4
	.long	sp_new_york_rangers,sp_rangers,sp_the_rangers,sp_new_yorkr
sp_rnd_cphiladelphia_flyers
	.word	10,4
	.long	sp_philadelphia_flyers,sp_flyers,sp_the_flyers,sp_philadelphia
sp_rnd_ctampa_bay_lightning
	.word	10,4
	.long	sp_tampa_bay_lightning,sp_lightning,sp_the_lightning,sp_tampa_bay
sp_rnd_cwashington_capitals
	.word	10,4
	.long	sp_washington_capitals,sp_capitals,sp_the_capitals,sp_washington
sp_rnd_cchicago_blackhawks
	.word	10,4
	.long	sp_chicago_blackhawks,sp_blackhawks,sp_the_blackhawks,sp_chicago
sp_rnd_cdallas_stars
	.word	10,4
	.long	sp_dallas_stars,sp_stars,sp_the_stars,sp_dallas
sp_rnd_cdetroit_red_wings
	.word	10,4
	.long	sp_detroit_red_wings,sp_red_wings,sp_the_red_wings,sp_detroit
sp_rnd_cst_louis_blues
	.word	10,4
	.long	sp_st_louis_blues,sp_blues,sp_the_blues,sp_st_louis
sp_rnd_ctoronto_maple_leafs
	.word	10,4
	.long	sp_toronto_maple_leafs,sp_maple_leafs,sp_the_maple_leafs,sp_toronto
sp_rnd_cwinnipeg_jets
	.word	10,4
	.long	sp_winnipeg_jets,sp_jets,sp_the_jets,sp_winnipeg
sp_rnd_cmighty_ducks_of_anaheim
	.word	10,4
	.long	sp_mighty_ducks_of_anaheim,sp_mighty_ducks,sp_the_mighty_ducks,sp_anaheim
sp_rnd_ccalgary_flames
	.word	10,4
	.long	sp_calgary_flames,sp_flames,sp_the_flames,sp_calgary
sp_rnd_cedmonton_oilers
	.word	10,4
	.long	sp_edmonton_oilers,sp_oilers,sp_the_oilers,sp_edmonton
sp_rnd_clos_angeles_kings
	.word	10,4
	.long	sp_los_angeles_kings,sp_kings,sp_the_kings,sp_los_angeles
sp_rnd_csan_jose_sharks
	.word	10,4
	.long	sp_san_jose_sharks,sp_sharks,sp_the_sharks,sp_san_jose
sp_rnd_cvancouver_canucks
	.word	10,4
	.long	sp_vancouver_canucks,sp_canucks,sp_the_canucks,sp_vancouver


sp_none
	.long	0

