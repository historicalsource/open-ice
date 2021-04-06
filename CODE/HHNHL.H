team_bruins		.set	1		;00000000000000000000000001
team_sabres		.set	2		;00000000000000000000000010
team_whalers		.set	3		;00000000000000000000000100
team_canadiens		.set	4		;00000000000000000000001000
team_senators		.set	5		;00000000000000000000010000
team_penguins		.set	6		;00000000000000000000100000
team_avalanche		.set	7		;00000000000000000001000000
team_panthers		.set	8		;00000000000000000010000000
team_devils		.set	9		;00000000000000000100000000
team_islanders		.set	10		;00000000000000001000000000
team_rangers		.set	11		;00000000000000010000000000
team_flyers		.set	12		;00000000000000100000000000
team_lightning		.set	13		;00000000000001000000000000
team_capitals		.set	14		;00000000000010000000000000
team_blackhawks		.set	15		;00000000000100000000000000
team_stars		.set	16		;00000000001000000000000000
team_red_wings		.set	17		;00000000010000000000000000
team_blues		.set	18		;00000000100000000000000000
team_maple_leafs	.set	19		;00000001000000000000000000
team_jets		.set	20		;00000010000000000000000000
team_mighty_ducks	.set	21		;00000100000000000000000000
team_flames		.set	22		;00001000000000000000000000
team_oilers		.set	23		;00010000000000000000000000
team_kings		.set	24		;00100000000000000000000000
team_sharks		.set	25		;01000000000000000000000000
team_canucks		.set	26		;10000000000000000000000000

team_special_01		.set	27
team_special_02		.set	28
team_special_03		.set	29
team_special_04		.set	30
team_special_05		.set	31
team_special_06		.set	32
team_special_07		.set	33
team_special_08		.set	34
team_special_09		.set	35
team_special_10		.set	36
team_special_11		.set	37
team_special_12		.set	38
team_special_13		.set	39
team_special_14		.set	40
team_special_15		.set	41
team_special_16		.set	42
team_special_17		.set	43
team_special_18		.set	44
team_special_19		.set	45
team_special_20		.set	46
team_special_21		.set	47
team_special_22		.set	48
team_special_23		.set	49
team_special_24		.set	50
team_special_25		.set	51
team_special_26		.set	52
team_special_27		.set	53
team_special_28		.set	54
team_special_29		.set	55
team_special_30		.set	56
team_special_31		.set	57
team_special_32		.set	58
team_special_33		.set	59
team_special_34		.set	60
team_special_35		.set	61
team_special_36		.set	62
team_special_37		.set	63
team_special_38		.set	64
team_special_39		.set	65
team_special_40		.set	66
team_special_41		.set	67
team_special_42		.set	68
team_special_43		.set	69
team_special_44		.set	70
team_special_45		.set	71
team_special_46		.set	72
team_special_47		.set	73
team_special_48		.set	74
team_special_49		.set	75
team_special_50		.set	76
team_special_51		.set	77
team_special_52		.set	78
team_special_53		.set	79
team_special_54		.set	80
team_special_55		.set	81
team_special_56		.set	82
team_special_57		.set	83
team_special_58		.set	84
team_special_59		.set	85
team_special_60		.set	86
team_special_61		.set	87
team_special_62		.set	88
team_special_63		.set	89
team_special_64		.set	90
team_special_65		.set	91

first_special_team	.equ	team_special_01
last_special_team	.equ	team_special_65
num_special_teams	.equ	(team_special_65 - team_special_01 +1)

s_mark_messier		.set	  1
s_petr_nedved		.set	  2
s_john_maclean		.set	  3
s_stephane_richer	.set	  4
s_joe_juneau		.set	  5
s_peter_bondra		.set	  6
s_eric_lindros		.set	  7
s_rod_brindamour	.set	  8
s_kirk_muller		.set	  9
s_steve_thomas		.set	 10
s_gord_murphy		.set	 11
s_scott_mellanby	.set	 12
s_brian_bradley		.set	 13
s_petr_klima		.set	 14
s_jaromir_jagr		.set	 15
s_luc_robitaille	.set	 16
s_joe_sakic		.set	 17
s_wendel_clark		.set	 18
s_pat_lafontaine	.set	 19
s_alexander_mogilny	.set	 20
s_vincent_damphousse	.set	 21
s_mark_recchi		.set	 22
s_ray_bourque		.set	 23
s_cam_neely		.set	 24
s_andrew_cassels	.set	 25
s_geoff_sanderson	.set	 26
s_alexandre_daigle	.set	 27
s_alexei_yashin		.set	 28
s_sergei_fedorov	.set	 29
s_steve_yzerman		.set	 30
s_doug_gilmour		.set	 31
s_dave_andreychuk	.set	 32
s_brett_hull		.set	 33
s_brendan_shanahan	.set	 34
s_bernie_nicholls	.set	 35
s_chris_chelios		.set	 36
s_teemu_selanne		.set	 37
s_keith_tkachuk		.set	 38
s_mike_modano		.set	 39
s_kevin_hatcher		.set	 40
s_pavel_bure		.set	 41
s_trevor_linden		.set	 42
s_theoren_fleury	.set	 43
s_robert_reichel	.set	 44
s_sandis_ozolinsh	.set	 45
s_ulf_dahlen		.set	 46
s_wayne_gretzky		.set	 47
s_jari_kurri		.set	 48
s_paul_kariya		.set	 49
s_tom_kurvers		.set	 50
s_igor_kravchuk		.set	 51
s_shayne_corson		.set	 52
s_mike_richter		.set	 53
s_martin_brodeur	.set	 54
s_jim_carey		.set	 55
s_ron_hextall		.set	 56
s_jamie_mclennan	.set	 57
s_john_vanbiesbrouck	.set	 58
s_darren_puppa		.set	 59
s_ken_wregget		.set	 60
s_stephane_fiset	.set	 61
s_dominik_hasek		.set	 62
s_patrick_roy		.set	 63
s_blaine_lacher		.set	 64
s_sean_burke		.set	 65
s_don_beaupre		.set	 66
s_mike_vernon		.set	 67
s_felix_potvin		.set	 68
s_curtis_joseph		.set	 69
s_ed_belfour		.set	 70
s_tim_chevaldae		.set	 71
s_andy_moog		.set	 72
s_kirk_mclean		.set	 73
s_trevor_kidd		.set	 74
s_arturs_irbe		.set	 75
s_kelly_hrudey		.set	 76
s_guy_hebert		.set	 77
s_bill_ranford		.set	 78
s_jeremy_roenick	.set	 79
s_bob_corkum		.set	 80
s_adam_oates		.set	 81
s_derek_plante		.set	 82
s_phil_housley		.set	 83
s_denis_savard		.set	 84
s_dave_gagner		.set	 85
s_paul_coffey		.set	 86
s_dino_ciccarelli	.set	 87
s_doug_weight		.set	 88
s_jason_arnott		.set	 89
s_jesse_belanger	.set	 90
s_rick_tocchet		.set	 91
s_pierre_turgeon	.set	 92
s_claude_lemieux	.set	 93
s_scott_stevens		.set	 94
s_ray_ferraro		.set	 95
s_brian_leetch		.set	 96
s_radek_bonk		.set	 97
s_mikael_renberg	.set	 98
s_eric_desjardins	.set	 99
s_mario_lemieux		.set	100
s_owen_nolan		.set	101
s_sergei_makarov	.set	102
s_esa_tikkanen		.set	103
s_roman_hamrlik		.set	104
s_mats_sundin		.set	105
s_sylvain_cote		.set	106
s_alexei_zhamnov	.set	107
s_dale_hawerchuk	.set	108

s_doug_bodger		.set	109
s_derek_king		.set	110
s_joe_nieuwendyk	.set	111

s_martin_martinez	.set	112
s_jack_haeger		.set	113
s_bill_dabelstein	.set	114
s_josh_tsui		.set	115
s_mark_penacho		.set	116
s_maryann_rohn		.set	117
s_carlos_pesina		.set	118
s_jim_tianis		.set	119
s_mike_waldron		.set	120
s_mike_vinikour		.set	121
s_warren_davis		.set	122
s_ed_boon		.set	123
s_john_tobias		.set	124
s_steve_beran		.set	125
s_pat_cox		.set	126
s_jim_gentile		.set	127
s_sal_divita		.set	128
s_nik_ehrlik		.set	129
s_eddie_ferrier		.set	130
s_eugene_geer		.set	131
s_tony_goskie		.set	132
s_jennifer_hedrick	.set	133
s_jon_hey		.set	134
s_mike_lynch		.set	135
s_dave_michicich	.set	136
s_john_carlton		.set	137
s_brian_eddie		.set	138
s_mark_loffredo		.set	139
s_cary_mednick		.set	140
s_eugene_jarvis		.set	141
s_mike_ossian		.set	142
s_joan_faux		.set	143
s_luis_mangubat		.set	144
s_jason_skiles		.set	145
s_al_lasko		.set	146
s_jim_rohn		.set	147
s_ray_gay		.set	148
;s_george_petro		.set	149
s_ted_barber		.set	150
s_dave_zabodoul		.set	151
s_christa_woss		.set	152
s_paul_dussault		.set	153
s_jack_h_haeger		.set	154
s_jennifer_fedesna	.set	155
s_bridgitte_fedesna	.set	156
s_mark_turmell		.set	157
s_art_tianis		.set	158
s_jim_greene		.set	159
s_sheridan_oursler	.set	160
s_ed_keenan		.set	161
s_matt_booty		.set	162
s_matt_davis		.set	163
s_steve_correll		.set	164
s_john_lowes		.set	165
s_glenn_shipp		.set	166
s_tony_metke		.set	167
s_ray_macika		.set	168
s_ken_williams		.set	169
s_jake_simpson		.set	170
s_john_newcomer		.set	171
s_xion_cooper		.set	172
s_chris_bobrowski	.set	173
s_andy_lycke		.set	174
s_ted_valvanis		.set	175
s_ross_shaffer		.set	176
s_jon_casey		.set	177
s_kevin_stevens		.set	178
s_zarley_zalapski	.set	179
s_craig_janney		.set	180
s_gordie_howe		.set	181
s_matt_cooney		.set	182
s_kevin_daley		.set	183
s_sidney_strong		.set	184
s_pat_foley		.set	185
s_rebecca_scott		.set	186
s_heather_beach		.set	187
s_goalie_haeger		.set	188
s_goalie_hedrick	.set	189
s_jay_cohen		.set	190
s_jeff_johnson		.set	191
s_jeff_peters		.set	192
s_dan_thompson		.set	193
s_evil_haeger		.set	194
s_tommy_soderstrom	.set	195
s_chris_osgood		.set	196
s_grant_fuhr		.set	197
