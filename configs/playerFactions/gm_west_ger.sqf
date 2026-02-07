
// 1. STARTER LOADOUT (ACE Arsenal Export)
RB_StarterLoadout_GM = [["gm_mp2a1_blk","","","",["gm_32Rnd_9x19mm_B_DM51_mp2_blk",32],[],""],[],["ACE_VMM3","","","",[],[],""],["gm_ge_pol_uniform_blouse_80_blk",[["ACE_EarPlugs",1],["ACE_CableTie",10],["ACE_elasticBandage",10],["ACE_packingBandage",10],["ACE_morphine",2],["ACE_epinephrine",2],["ACE_salineIV_500",2],["ACE_splint",2],["ACE_tourniquet",2],["ACE_MapTools",1]]],["gm_ge_pol_vest_80_wht",[["ACE_Sunflower_Seeds",1],["gm_handgrenade_frag_dm51a1",2,1],["gm_smokeshell_wht_dm25",1,1],["gm_smokeshell_grn_dm21",1,1],["gm_32Rnd_9x19mm_B_DM51_mp2_blk",7,32]]],[],"gm_gc_pol_headgear_cap_80_blu","",["gm_df7x40_blk","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","gm_gc_compass_f73","gm_watch_kosei_80_slv",""]],[];

// 2. AMBIENT ASSETS
RB_Ambient_Rotary_GM = ["gm_ge_army_ch53g", "gm_ge_army_ch53gs", "gm_ge_army_bo105p_pah1", "gm_ge_army_bo105m_vbh", "gm_ge_army_bo105p1m_vbh", "gm_ge_army_bo105p1m_vbh_swooper", "gm_gc_civ_mi2p", "gm_gc_civ_mi2sr", "gm_ge_adak_bo105m_vbh", "gm_ge_pol_bo105m_vbh", "gm_ge_bgs_bo105m_vbh", "gm_gc_airforce_mi2p", "gm_gc_airforce_mi2sr", "gm_gc_airforce_mi2t", "gm_gc_airforce_mi2urn", "gm_gc_airforce_mi2us", "gm_gc_bgs_mi2p", "gm_gc_bgs_mi2us"];
RB_Ambient_Fixed_GM  = ["gm_gc_civ_l410s_passenger", "gm_gc_civ_l410s_salon", "gm_ge_airforce_do28d2", "gm_ge_airforce_do28d2_medevac", "gm_gc_airforce_l410s_salon", "gm_gc_airforce_l410t"];

// 3. GEAR PRESETS
private _gear1 = ["gm_ge_army_uniform_soldier_80_oli", "gm_ge_army_uniform_soldier_gloves_80_ols", "gm_ge_army_uniform_soldier_80_ols", "gm_ge_army_uniform_soldier_parka_80_oli", "gm_ge_army_uniform_soldier_parka_80_ols", "gm_dk_headgear_m52_oli", "gm_dk_headgear_m52_net_oli", "gm_ge_bgs_headgear_m35_53_blk", "gm_ge_bgs_headgear_m35_53_net_blk", "gm_ge_headgear_m62", "gm_ge_headgear_m62_net", "gm_ferod51_oli", "gm_fero51_oli", "gm_ferod16_oli","gm_gc_bgs_vest_80_border_str", "gm_ge_bgs_vest_80_rifleman","gm_ge_army_vest_80_demolition","gm_ge_army_vest_80_leader","gm_gc_army_vest_80_leader_str","gm_ge_army_vest_80_leader_smg","gm_ge_army_vest_80_machinegunner","gm_gc_army_vest_80_lmg_str","gm_dk_army_vest_54_machinegunner","gm_ge_army_vest_80_medic","gm_ge_army_vest_80_rifleman","gm_gc_army_vest_80_rifleman_str","gm_dk_army_vest_54_rifleman","gm_ge_army_vest_80_rifleman_smg","gm_gc_army_vest_80_at_str","B_AssaultPack_khk"];
private _gear2 = _gear1 + ["gm_xx_uniform_soldier_bdu_80_oli", "gm_xx_uniform_soldier_bdu_80_wdl", "gm_xx_uniform_soldier_bdu_nogloves_80_oli", "gm_xx_uniform_soldier_bdu_rolled_80_oli", "gm_xx_uniform_soldier_bdu_rolled_80_wdl", "gm_xx_uniform_soldier_bdu_nogloves_80_wdl", "gm_ge_bgs_uniform_soldier_80_smp", "gm_ge_headgear_m62_cover_wdl", "gm_ge_vest_sov_armor_80_blk", "gm_ge_vest_sov_armor_80_oli", "gm_ge_vest_sov_armor_80_wdl", "B_FieldPack_khk", "B_FieldPack_oli", "gm_lp7_oli"];
private _gear3 = _gear2 + ["gm_ge_uniform_soldier_90_flk", "gm_ge_uniform_soldier_90_trp", "gm_ge_uniform_soldier_rolled_90_flk", "gm_ge_uniform_soldier_rolled_90_trp", "gm_ge_uniform_soldier_tshirt_90_flk", "gm_ge_uniform_soldier_tshirt_90_trp", "gm_ge_uniform_soldier_tshirt_90_oli", "gm_ge_vest_armor_90_flk", "gm_ge_vest_armor_90_demolition_flk", "gm_ge_vest_armor_90_leader_flk", "gm_ge_vest_armor_90_machinegunner_flk", "gm_ge_vest_armor_90_medic_flk", "gm_ge_vest_armor_90_officer_flk", "gm_ge_vest_armor_90_rifleman_flk", "gm_ge_army_vest_type18_dpm", "gm_ge_bgs_vest_type18_blk", "gm_ge_bgs_vest_type18_grn", "gm_ge_army_backpack_90_flk", "gm_ge_army_backpack_90_trp", "gm_ge_army_backpack_90_blk", "gm_ge_army_backpack_90_oli", "gm_ge_army_backpack_80_oli", "gm_ge_headgear_m92_flk", "gm_ge_headgear_m92_trp", "gm_ge_headgear_m92_cover_blk", "gm_ge_headgear_m92_glasses_flk", "gm_ge_headgear_m92_glasses_trp", "gm_ge_headgear_m92_cover_glasses_blk", "gm_ge_headgear_m92_cover_glasses_oli","gm_ge_headgear_m92_cover_oli"];

// 4. LOGISTICS OPTIONS
RB_LogisticsOptions_GM = [
    [ "Reinforcements", [
        // Format: [Label, [Units], TransportVehicle, Cost]
        ["MP", ["gm_ge_army_militarypolice_p1_parka_80_ols"], "gm_ge_army_k125", 15],
        ["Rifleman", ["gm_ge_army_rifleman_g3a3_parka_80_ols"], "gm_ge_army_k125", 30],
        ["Sentry (2)", ["gm_ge_army_rifleman_g3a3_parka_80_ols", "gm_ge_army_grenadier_g3a3_parka_80_ols"], "gm_ge_army_typ1200_cargo", 50],
        ["Fire Team (4)",   ["gm_ge_army_squadleader_g3a3_p2a1_parka_80_ols", "gm_ge_army_machinegunner_mg3_parka_80_ols", "gm_ge_army_grenadier_g3a3_parka_80_ols", "gm_ge_army_antitank_g3a3_pzf84_parka_80_ols"], "gm_ge_army_typ253_mp", 75],
        ["Squad (10)",       ["gm_ge_army_squadleader_g3a3_p2a1_parka_80_ols", "gm_ge_army_medic_g3a3_parka_80_ols","gm_ge_army_squadleader_g3a3_p2a1_parka_80_ols", "gm_ge_army_machinegunner_mg3_parka_80_ols", "gm_ge_army_grenadier_g3a3_parka_80_ols", "gm_ge_army_antitank_g3a3_pzf84_parka_80_ols","gm_ge_army_squadleader_g3a3_p2a1_parka_80_ols", "gm_ge_army_machinegunner_mg3_parka_80_ols", "gm_ge_army_grenadier_hk69a1_parka_80_ols", "gm_ge_army_marksman_g3a3_parka_80_ols"], "gm_ge_army_u1300l_cargo", 200]
    ] ],
    [ "Ammo", [
        ["9mm MP5 Upgrade Kit", ["gm_30Rnd_9x19mm_AP_DM91_mp5_blk", "gm_30Rnd_9x19mm_AP_DM91_mp5a3_blk", "gm_60Rnd_9x19mm_AP_DM91_mp5a3_blk", "gm_60Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_60Rnd_9x19mm_B_DM51_mp5a3_blk","gm_60Rnd_9x19mm_BSD_DM81_mp5a3_blk"], 30],
        ["G-Series 5.56 40rnd Kit", ["gm_40Rnd_556x45mm_B_DM11_hk33_blk", "gm_40Rnd_556x45mm_B_T_DM21_hk33_blk"], 30],
        ["G-Series 5.56 60rnd Kit", ["gm_60Rnd_556x45mm_B_DM11_hk33_blk", "gm_60Rnd_556x45mm_B_T_DM21_hk33_blk"], 40],
        ["G3 Rifle Grenade", ["gm_1rnd_67mm_heat_dm22a1_g3"], 30]
    ] ],
    [ "Weapons", [
        ["SG5 SMG Kit", ["gm_mp5a2_blk","gm_mp5a3_blk", "gm_mp5a3_surefire_blk","gm_mp5a4_blk","gm_mp5a5_blk","gm_mp5n_blk","gm_mp5n_surefire_blk", "gm_30Rnd_9x19mm_B_DM51_mp5_blk"], 15],
        ["SG5 Suppressed SMG Kit", ["gm_mp5nsd1_blk","gm_mp5nsd2_blk", "gm_mp5sd2_blk","gm_mp5sd3_blk","gm_mp5sd5_blk","gm_mp5sd6_blk","gm_30Rnd_9x19mm_BSD_DM81_mp5a3_blk", "gm_30Rnd_9x19mm_BSD_DM81_mp5_blk"], 50],
        ["G53 Kit", ["gm_hk53a2_blk", "gm_hk53a3_blk", "gm_30Rnd_556x45mm_B_DM11_hk33_blk", "gm_30Rnd_556x45mm_B_T_DM21_hk33_blk"], 25],
        ["SG 550 Series Kit", ["gm_sg542_oli", "gm_sg542_blk", "gm_sg542_ris_oli", "gm_sg542_ris_blk", "gm_sg550_oli", "gm_sg550_blk", "gm_sg550_ris_oli","gm_sg550_ris_blk", "gm_sg551_oli", "gm_sg551_blk", "gm_sg551_ris_oli", "gm_sg551_ris_blk", "gm_30Rnd_556x45mm_B_DM11_sg550_brn", "gm_30Rnd_556x45mm_B_T_DM21_sg550_brn"], 25],
        ["G3 Rifle Kit", ["gm_g3a3_blk", "gm_g3a3_oli", "gm_g3a3a0_blk", "gm_g3a3a0_oli", "gm_g3a3a1_ris_blk", "gm_g3a3a1_ris_oli", "gm_g3a4_blk", "gm_g3a4_oli", "gm_g3a4a0_blk", "gm_g3a4a0_oli", "gm_g3a4a1_ris_blk", "gm_g3a4a1_ris_oli", "gm_g3ka4_blk", "gm_g3ka4_oli", "gm_g3ka4a1_ris_blk", "gm_20Rnd_762x51mm_AP_DM151_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_DM41_g3_blk","gm_20Rnd_762x51mm_B_T_DM21_g3_blk","gm_20Rnd_762x51mm_B_T_DM21A1_g3_blk","gm_20Rnd_762x51mm_B_T_DM21A2_g3_blk"], 50],
        ["M16 Rifle Kit", ["gm_m16a1_blk", "gm_m16a2_blk", "gm_c7a1_oli", "gm_c7a1_blk", "gm_30Rnd_556x45mm_B_M193_stanag_gry", "gm_30Rnd_556x45mm_B_M855_stanag_gry", "gm_30Rnd_556x45mm_B_T_M196_stanag_gry","gm_30Rnd_556x45mm_B_T_M856_stanag_gry", "gm_c79a1_blk", "gm_c79a1_oli"], 50],
        ["G8 LMG Kit", ["gm_g8a1_blk", "gm_g8a2_blk", "gm_40Rnd_762x51mm_AP_DM151_g3_blk", "gm_40Rnd_762x51mm_B_DM111_g3_blk", "gm_40Rnd_762x51mm_B_DM41_g3_blk", "gm_40Rnd_762x51mm_B_T_DM21_g3_blk", "gm_40Rnd_762x51mm_B_T_DM21A1_g3_blk","gm_40Rnd_762x51mm_B_T_DM21A2_g3_blk"], 75],
        ["MG3 MMG Kit", ["gm_mg3_blk", "gm_120Rnd_762x51mm_B_T_DM21_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A2_mg3_grn"], 120],
        ["PSG1 Kit", ["gm_psg1_blk", "gm_msg90_blk", "gm_msg90a1_blk", "gm_zf6x42_psg1_stanag_blk", "gm_g3sg1_blk", "gm_g3sg1_oli", "gm_10Rnd_762x51mm_AP_DM151_g3_blk", "gm_10Rnd_762x51mm_B_DM111_g3_blk", "gm_10Rnd_762x51mm_B_DM41_g3_blk", "gm_10Rnd_762x51mm_B_T_DM21_g3_blk", "gm_10Rnd_762x51mm_B_T_DM21A1_g3_blk","gm_10Rnd_762x51mm_B_T_DM21A2_g3_blk"], 150],
        ["G36 Rifle Kit", ["gm_g36a1_blk", "gm_g36e_blk", "gm_30Rnd_556x45mm_B_DM11_g36_blk", "gm_30Rnd_556x45mm_B_T_DM21_g36_blk"], 40],
        ["G11 Rifle Kit", ["gm_g11k2_blk", "gm_g11k2_ris_blk", "gm_feroz51_ris_oli", "gm_g11_lps_prism11mm_blk", "gm_g11_mps_prism11mm_blk", "gm_50Rnd_473x33mm_B_DM11_g11_blk","gm_50Rnd_473x33mm_B_T_DM21_g11_blk"], 100],
        ["GraPI 40mm GL", ["gm_hk69a1_blk", "gm_1rnd_40x46mm_illum_dm16", "gm_1rnd_40x46mm_hedp_dm21", "gm_1rnd_40x46mm_smoke_dm35", "gm_1rnd_40x46mm_he_dm91"], 50],
        ["Golden G3A3A0", ["gm_g3a3a0_gold", "gm_20Rnd_762x51mm_B_T_DM21_g3_gold"], 1500]
    ] ],
    [ "Launchers", [
        ["M72A3 LAW Kit", ["gm_m72a3_oli", "gm_1Rnd_66mm_heat_m72a3"], 30],
        ["PzF44-2 Kit", ["gm_pzf44_2_oli", "gm_1Rnd_44x537mm_heat_dm32_pzf44_2", "MRAWS_HE_F", "MRAWS_HEAT55_F", "MRAWS_HEAT_F"], 50],
        ["PzF84 Kit", ["gm_pzf84_oli", "gm_1Rnd_84x245mm_heat_t_DM12_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM12a1_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM22_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM32_carlgustaf", "gm_1Rnd_84x245mm_ILLUM_DM16_carlgustaf"], 75],
        ["PzF3 Kit", ["gm_pzf3_blk", "gm_1Rnd_60mm_heat_dm12_pzf3", "gm_1Rnd_60mm_heat_dm22_pzf3", "gm_1Rnd_60mm_heat_dm32_pzf3"], 100]
    ] ],
    [ "Gear", [
        ["Gear Upgrade #1", _gear1, 40],
        ["Gear Upgrade #2", _gear2, 65],
        ["Gear Upgrade #3", _gear3, 90]
    ] ],
    [ "Attachments", [
        ["Bipod Kit", ["gm_g3_bipod_blk", "bipod_01_F_blk", "gm_g8_bipod_blk", "gm_msg90_bipod_blk"], 10],
        ["Rail Attachment Kit", ["ACE_DBAL_A3_Green", "ACE_DBAL_A3_Red", "acc_pointer_IR", "ACE_SPIR"], 15],
        ["Suppressor Kit", ["gm_suppressor_m10_9mm_blk", "gm_suppressor_atec150_556mm_blk","gm_suppressor_atec150_556mm_long_blk", "gm_suppressor_atec150_762mm_blk", "gm_suppressor_atec150_762mm_long_blk"], 50],
        ["CQB Scope Kit", ["gm_rv_ris_blk", "gm_rv_stanagClaw_blk", "gm_rv_stanagClaw_oli", "gm_zpp_stanagClaw_blk", "gm_streamlight_sl20_stanagClaw_blk", "gm_streamlight_sl20_stanagClaw_brn", "gm_lsminiv_ir_stanagClaw_blk", "gm_lsminiv_red_stanagClaw_blk", "gm_ls1500_ir_stanagClaw_blk", "gm_ls1500_red_stanagClaw_blk", "gm_ls45_ir_stanagClaw_blk", "gm_ls45_red_stanagClaw_blk","gm_maglite_3d_stanagClaw_blk", "gm_streamlight_sl20_ris_blk", "gm_streamlight_sl20_ris_brn", "gm_lsminiv_ir_ris_blk", "gm_lsminiv_red_ris_blk", "gm_ls1500_ir_ris_blk", "gm_ls1500_red_ris_blk", "gm_ls45_ir_ris_blk", "gm_ls45_red_ris_blk", "gm_maglite_3d_ris_blk"], 25],
        ["Rifle Scope Kit", ["gm_blits_stanagClaw_blk","gm_blits_stanagClaw_oli", "gm_colt4x20_stanagClaw_blk", "gm_c79a1_blk", "gm_c79a1_oli", "gm_blits_ris_blk", "gm_feroz24_ris_blk", "gm_feroz24_stanagClaw_blk", "gm_feroz24_stanagClaw_oli", "ACE_optic_Hamr_2D", "optic_Hamr_sand_lxWS", "optic_Hamr_snake_lxWS", "optic_ERCO_blk_F", "optic_ERCO_snd_F"], 50],
        ["Sniper Scope Kit", ["gm_diavari_da_stanagClaw_blk", "gm_diavari_da_stanagClaw_oli", "gm_zf10x42_stanagClaw_blk", "gm_zf10x42_stanagClaw_oli"], 75],
        ["Special Scopes Kit", ["gm_feroz51_stanagClaw_oli"], 75]
    ] ],
        [ "Explosives", [
        ["Mines Kit", ["gm_mine_ap_dm31","ClaymoreDirectionalMine_Remote_Mag", "SLAMDirectionalMine_Wire_Mag", "APERSTripMine_Wire_Mag", "ACE_FlareTripMine_Mag","ACE_FlareTripMine_Mag_Green", "ACE_FlareTripMine_Mag_Red","APERSMine_Range_Mag","ACE_APERSMine_ToePopper_Mag","APERSMineDispenser_Mag"], 100]
    ] ],
    [ "Turrets", [
        ["Searchlight", ["TURRET", "gm_gc_bgs_searchlight_01"], 10],
        ["MG3 AA Tripod", ["TURRET", "gm_ge_army_mg3_aatripod"], 15],
        ["LATGM", ["TURRET", "gm_ge_army_milan_launcher_tripod"], 25],
        ["Mk.6 Mortar", ["TURRET", "gm_ge_army_m120"], 50]
    ] ]
];

RB_ArsenalExtra_GM = [
"gm_gc_army_headgear_cap_80_gry", "gm_gc_pol_headgear_cap_80_blu", "gm_ge_pol_headgear_cap_80_grn", "gm_ge_pol_headgear_cap_80_wht", "gm_ge_headgear_beret_red_militarypolice", "gm_ge_bgs_headgear_beret_grn",
"gm_ls45_red_uziclaw_blk", "gm_ls45_ir_uziclaw_blk", "gm_hk512_wud", "gm_surefire_l60_wht_hoseclamp_blk", "gm_surefire_l60_red_hoseclamp_blk", "gm_surefire_l72_red_hoseclamp_blk", "gm_7rnd_12ga_hk512_pellet", "gm_7rnd_12ga_hk512_slug",
"gm_ge_pol_uniform_suit_80_grn", "gm_handgrenade_conc_dm51", "gm_handgrenade_conc_dm51a1", "gm_handgrenade_frag_dm41", "gm_handgrenade_frag_dm51", "gm_handgrenade_frag_dm51a1", "gm_smokeshell_grn_dm21", "gm_smokeshell_red_dm23", "gm_smokeshell_wht_dm25", "gm_smokeshell_yel_dm26","gm_smokeshell_org_dm32",
"gm_ge_facewear_m65"
];

