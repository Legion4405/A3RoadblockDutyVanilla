// For starterloadout, copy/export ACE Arsenal, and make sure it's unwrapped properly. Two [[ at the start of the arrays, and ends with []; (The final one is a patch, so if you save a patch, the last [] will have a string inside.
RB_StarterLoadout_RHS_USA = [["rhs_weap_m4_carryhandle","","","",["rhs_mag_30Rnd_556x45_M855A1_Stanag",30],[],""],[],["ACE_VMM3","","","",[],[],""],["rhs_uniform_acu_oefcp",[["ACE_EarPlugs",1],["ACE_CableTie",10],["ACE_elasticBandage",10],["ACE_packingBandage",10],["ACE_morphine",2],["ACE_epinephrine",2],["ACE_salineIV_500",2],["ACE_splint",2],["ACE_tourniquet",2],["ACE_MapTools",1],["ACE_bloodIV_250",1]]],["V_TacVest_khk",[["ACE_Sunflower_Seeds",1],["ACE_personalAidKit",1],["ACE_bloodIV_250",1],["ACE_bloodIV_500",1],["HandGrenade",2,1],["SmokeShell",1,1],["SmokeShellGreen",1,1],["rhs_mag_30Rnd_556x45_M855A1_Stanag",3,30],["rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2,30]]],[],"rhsusf_patrolcap_ocp","",["Binocular","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","ACE_NVGoggles_WP"]],[];
RB_Ambient_Rotary_RHS_USA = ["RHS_AH64D", "RHS_CH_47F_10", "RHS_UH60M_d", "RHS_UH60M_ESSS_d", "RHS_UH60M_ESSS2_d", "RHS_UH60M_MEV2_d"];
RB_Ambient_Fixed_RHS_USA  = ["RHS_A10", "RHS_C130J", "rhsusf_f22"];

// You can add as many categories as you like, it should work. Vehicles, and Turrets have VEHICLE and TURRET in their arrays, the script reads this and spawns the turrets/vehicles properly. Anything else will be unlockled in the arsenal.
// "Ammo" is the sub-category in Logistic Menu, then ["DisplayName", ["Item1", "Item2", "Etc.."], Point Cost],
// === Gear Upgrade Arrays ===
private _gearUpgrade1 = ["rhs_uniform_cu_ocp", "rhsusf_spcs_ocp_grenadier", "rhsusf_spcs_ocp_machinegunner", "rhsusf_spcs_ocp_medic", "rhsusf_spcs_ocp", "rhsusf_spcs_ocp_rifleman_alt", "rhsusf_spcs_ocp_rifleman", "rhsusf_spcs_ocp_saw", "rhsusf_spcs_ocp_sniper", "rhsusf_spcs_ocp_squadleader", "rhsusf_spcs_ocp_teamleader_alt", "rhsusf_spcs_ocp_teamleader", "rhsusf_falconii_mc", "rhsusf_ach_helmet_ocp","rhsusf_ach_helmet_ocp_alt", "rhsusf_ach_helmet_ESS_ocp", "rhsusf_ach_helmet_ESS_ocp_alt","rhsusf_ach_helmet_headset_ocp", "rhsusf_ach_helmet_headset_ocp_alt","rhsusf_ach_helmet_headset_ess_ocp","rhsusf_ach_helmet_headset_ess_ocp_alt", "rhsusf_ach_helmet_camo_ocp", "rhsusf_ach_helmet_ocp_norotos", "ACE_NVG_Gen4_WP", "ACE_Vector"];
private _gearUpgrade2 = _gearUpgrade1 + ["rhsusf_iotv_ocp_Grenadier", "rhsusf_iotv_ocp_Medic", "rhsusf_iotv_ocp", "rhsusf_iotv_ocp_Repair", "rhsusf_iotv_ocp_Rifleman", "rhsusf_iotv_ocp_SAW", "rhsusf_iotv_ocp_Squadleader", "rhsusf_iotv_ocp_Teamleader", "rhsusf_opscore_mc_cover", "rhsusf_opscore_mc_cover_pelt", "rhsusf_opscore_mc_cover_pelt_nsw", "rhsusf_opscore_mc_cover_pelt_cam","rhsusf_opscore_mc", "rhsusf_opscore_mc_pelt","rhsusf_opscore_mc_pelt_nsw", "rhsusf_assault_eagleaiii_ocp", "ACE_NVG_Wide_WP", "ACE_MX2A"];

// === Logistics Options Horizontal Layout ===
RB_LogisticsOptions_RHS_USA = [
    [ "Ammo", [
        ["6.5mm 100rnd Mags", ["100Rnd_65x39_caseless_black_mag", "100Rnd_65x39_caseless_mag", "ACE_100Rnd_65x39_caseless_mag_Tracer_Dim", "100Rnd_65x39_caseless_black_mag_tracer", "100Rnd_65x39_caseless_mag_Tracer"], 30],
        ["7.62mm 20rnd Mags", ["20Rnd_762x51_Mag", "ACE_20Rnd_762x51_Mag_Tracer_Dim", "ACE_20Rnd_762x51_M118LR_Mag", "ACE_20Rnd_762x51_M993_AP_Mag", "ACE_20Rnd_762x51_Mk316_Mod_0_Mag", "ACE_20Rnd_762x51_Mk319_Mod_0_Mag", "ACE_20Rnd_762x51_Mag_SD", "ACE_20Rnd_762x51_Mag_Tracer"], 15]
    ] ],
    [ "Carbines", [
        ["M4A1 Kit", ["rhs_weap_m4a1_carryhandle", "rhs_mag_30Rnd_556x45_M855A1_PMAG", "rhs_mag_30Rnd_556x45_M855A1_PMAG_Tracer_Red", "rhs_mag_30Rnd_556x45_Mk262_PMAG", "rhs_mag_30Rnd_556x45_Mk318_PMAG"], 10],
        ["M4A1 M203 Kit", ["rhs_weap_m4a1_carryhandle_m203", "rhs_mag_30Rnd_556x45_M855A1_PMAG", "rhs_mag_30Rnd_556x45_M855A1_PMAG_Tracer_Red", "rhs_mag_30Rnd_556x45_Mk262_PMAG", "rhs_mag_30Rnd_556x45_Mk318_PMAG", "rhs_mag_M397_HET", "ACE_40mm_Pike", "rhs_mag_M397_HET", "rhs_mag_M433_HEDP", "rhs_mag_M441_HE", "ACE_HuntIR_M203", "rhs_mag_m576", "rhs_mag_M583A1_white", "rhs_mag_M585_white_cluster", "rhs_mag_m661_green", "rhs_mag_m662_red", "rhs_mag_M663_green_cluster", "rhs_mag_M664_red_cluster", "rhs_mag_m713_Red", "rhs_mag_m714_White", "rhs_mag_m715_Green", "rhs_mag_m716_yellow"], 20],
        ["M4A1 PIP Kit", ["rhs_weap_m4a1", "rhs_weap_m4a1_d", "rhs_mag_30Rnd_556x45_M855A1_PMAG", "rhs_mag_30Rnd_556x45_M855A1_PMAG_Tracer_Red", "rhs_mag_30Rnd_556x45_Mk262_PMAG", "rhs_mag_30Rnd_556x45_Mk318_PMAG"], 15],
        ["M4A1 PIP M320 Kit", ["rhs_weap_m4a1_m320", "rhs_mag_30Rnd_556x45_M855A1_PMAG", "rhs_mag_30Rnd_556x45_M855A1_PMAG_Tracer_Red", "rhs_mag_30Rnd_556x45_Mk262_PMAG", "rhs_mag_30Rnd_556x45_Mk318_PMAG", "rhs_mag_M397_HET", "ACE_40mm_Pike", "rhs_mag_M397_HET", "rhs_mag_M433_HEDP", "rhs_mag_M441_HE", "ACE_HuntIR_M203", "rhs_mag_m576", "rhs_mag_M583A1_white", "rhs_mag_M585_white_cluster", "rhs_mag_m661_green", "rhs_mag_m662_red", "rhs_mag_M663_green_cluster", "rhs_mag_M664_red_cluster", "rhs_mag_m713_Red", "rhs_mag_m714_White", "rhs_mag_m715_Green", "rhs_mag_m716_yellow"], 25]
    ] ],
    [ "Machineguns", [
        ["M249 Kit", ["rhs_weap_m249_pip", "rhs_weap_m249_pip_L_para", "rhs_weap_m249_light_L", "rhs_weap_m249_pip_L", "rhs_weap_m249_pip_ris", "rhs_weap_m249_light_S", "rhs_weap_m249_pip_S_para", "rhs_weap_m249_pip_S", "rhsusf_100Rnd_556x45_soft_pouch_coyote", "rhsusf_100Rnd_556x45_mixed_soft_pouch_coyote", "rhsusf_100Rnd_556x45_M995_soft_pouch_coyote", "rhsusf_acc_saw_bipod", "rhsusf_acc_grip4", "rhsusf_acc_grip4_bipod", "rhsusf_acc_saw_lw_bipod"], 25],
        ["M240 Kit", ["rhs_weap_m240B", "rhs_weap_m240G", "rhsusf_50Rnd_762x51_m61_ap", "rhsusf_50Rnd_762x51_m62_tracer", "rhsusf_50Rnd_762x51", "rhsusf_50Rnd_762x51_m80a1epr"], 35]

    ] ],
    [ "Rifles", [
        ["M14 EBR-RI Kit", ["rhs_weap_m14ebrri", "rhsusf_acc_harris_bipod", "rhsusf_acc_LEUPOLDMK4", "ACE_10Rnd_762x51_M118LR_Mag", "ACE_10Rnd_762x51_M993_AP_Mag", "ACE_10Rnd_762x51_Mk316_Mod_0_Mag", "ACE_10Rnd_762x51_Mk319_Mod_0_Mag", "ACE_10Rnd_762x51_Mag_Tracer", "ACE_10Rnd_762x51_Mag_SD"], 25],
        ["Mk 11 Mod 0 Kit", ["rhs_weap_sr25", "rhs_weap_sr25_ec", "ACE_10Rnd_762x51_M118LR_Mag", "ACE_10Rnd_762x51_M993_AP_Mag", "ACE_10Rnd_762x51_Mk316_Mod_0_Mag", "ACE_10Rnd_762x51_Mk319_Mod_0_Mag", "ACE_10Rnd_762x51_Mag_Tracer", "ACE_10Rnd_762x51_Mag_SD"], 25],
        ["M24 SWS Kit", ["rhs_weap_m24sws", "rhs_weap_m24sws_d", "rhs_weap_m24sws_wd", "rhsusf_acc_harris_swivel", "rhsusf_5Rnd_762x51_m118_special_Mag", "rhsusf_5Rnd_762x51_m62_Mag", "rhsusf_5Rnd_762x51_m993_Mag", "rhsusf_acc_LEUPOLDMK4", "rhsusf_acc_LEUPOLDMK4_d", "rhsusf_acc_LEUPOLDMK4_wd"], 25],
        ["M2010 ESR Kit", ["rhs_weap_XM2010", "rhs_weap_XM2010_wd", "rhs_weap_XM2010_d", "rhs_weap_XM2010_sa", "rhsusf_acc_M8541", "rhsusf_acc_M8541_d", "rhsusf_acc_M8541_wd", "rhsusf_acc_LEUPOLDMK4", "rhsusf_acc_LEUPOLDMK4_d", "rhsusf_acc_LEUPOLDMK4_wd"], 25]

    ] ],
    [ "Launchers", [
        ["M32 MGL Kit", ["rhs_weap_m32", "rhsusf_mag_6Rnd_M397_HET", "rhsusf_mag_6Rnd_M433_HEDP", "rhsusf_mag_6Rnd_M441_HE", "rhsusf_mag_6Rnd_m4009", "rhsusf_mag_6Rnd_M576_Buckshot", "rhsusf_mag_6Rnd_M583A1_white", "rhsusf_mag_6Rnd_m661_green", "rhsusf_mag_6Rnd_m662_red", "rhsusf_mag_6Rnd_M713_red", "rhsusf_mag_6Rnd_M714_white", "rhsusf_mag_6Rnd_M715_green", "rhsusf_mag_6Rnd_M716_yellow"], 25],
        ["M72A7 LAW Kit", ["rhs_weap_m72a7"], 10],
        ["M136 Kit", ["rhs_weap_M136", "rhs_weap_M136_hedp", "rhs_weap_M136_hp"], 20],
        ["M3 MAAWS Kit", ["rhs_weap_maaws", "rhs_optic_maaws", "rhs_mag_maaws_HE", "rhs_mag_maaws_HEDP", "rhs_mag_maaws_HEAT"], 30]
    ] ],
    [ "Gear", [
        ["Gear Upgrade #1", _gearUpgrade1, 40],
        ["Gear Upgrade #2", _gearUpgrade2, 65]
    ] ],
    [ "Attachments", [
        ["Bipod Kit", ["rhsusf_acc_grip2", "rhsusf_acc_grip2_tan", "rhsusf_acc_grip2_wd", "rhsusf_acc_grip1", "rhsusf_acc_harris_bipod", "rhsusf_acc_kac_grip", "rhsusf_acc_rvg_blk", "rhsusf_acc_rvg_de", "rhsusf_acc_tdstubby_blk", "rhsusf_acc_tdstubby_tan", "rhsusf_acc_grip3", "rhsusf_acc_grip3_tan"], 10],
        ["Rail Attachment Kit", ["ACE_DBAL_A3_Green", "ACE_DBAL_A3_Red", "acc_pointer_IR", "ACE_SPIR", "rhsusf_acc_anpeq15side", "rhsusf_acc_anpeq15_top", "rhsusf_acc_anpeq15_wmx", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_anpeq15_bk_top", "rhsusf_acc_anpeq15", "rhsusf_acc_anpeq15_bk", "rhsusf_acc_anpeq15A", "rhsusf_acc_anpeq16a", "rhsusf_acc_anpeq16a_top", "rhsusf_acc_M952V", "rhsusf_acc_wmx", "rhsusf_acc_wmx_bk"], 15],
        ["Suppressor Kit", ["rhsusf_acc_nt4_black", "rhsusf_acc_nt4_tan", "rhsusf_acc_rotex5_grey", "rhsusf_acc_rotex5_tan", "rhsusf_acc_SR25S", "rhsusf_acc_m24_silencer_black", "rhsusf_acc_m24_silencer_d", "rhsusf_acc_m24_silencer_wd", "rhsusf_acc_aac_scarh_silencer", "rhsusf_acc_M2010S", "rhsusf_acc_M2010S_d", "rhsusf_acc_M2010S_sa", "rhsusf_acc_M2010S_wd"], 75],
        ["CQB Scope Kit", ["rhsusf_acc_EOTECH", "rhsusf_acc_M2A1", "rhsusf_acc_eotech_552", "rhsusf_acc_eotech_552_d", "rhsusf_acc_eotech_552_wd", "rhsusf_acc_compm4", "rhsusf_acc_RX01_NoFilter", "rhsusf_acc_RX01", "rhsusf_acc_RX01_NoFilter_tan", "rhsusf_acc_RX01_tan", "rhsusf_acc_T1_high", "rhsusf_acc_eotech_xps3"],  25],
        ["Rifle Scope Kit", ["rhsusf_acc_g33_T1", "rhsusf_acc_g33_xps3", "rhsusf_acc_ELCAN", "rhsusf_acc_ELCAN_ard", "rhsusf_acc_ACOG", "rhsusf_acc_ACOG2", "rhsusf_acc_ACOG3", "rhsusf_acc_su230", "rhsusf_acc_su230_c", "rhsusf_acc_su230_mrds", "rhsusf_acc_su230_mrds_c", "rhsusf_acc_su230a", "rhsusf_acc_su230a_c", "rhsusf_acc_su230a_mrds", "rhsusf_acc_su230a_mrds_c", "rhsusf_acc_ACOG_MDO"], 50],
        ["Sniper Scope Kit", ["rhsusf_acc_M8541", "rhsusf_acc_M8541_d", "rhsusf_acc_M8541_mrds", "rhsusf_acc_M8541_wd", "rhsusf_acc_premier_low", "rhsusf_acc_premier_anpvs27", "rhsusf_acc_premier", "rhsusf_acc_premier_mrds", "rhsusf_acc_LEUPOLDMK4_2", "rhsusf_acc_LEUPOLDMK4_2_d", "rhsusf_acc_LEUPOLDMK4_2_mrds", "rhsusf_acc_nxs_3515x50_md", "rhsusf_acc_nxs_3515x50f1_h58", "rhsusf_acc_nxs_3515x50f1_md", "rhsusf_acc_nxs_3515x50f1_h58_sun", "rhsusf_acc_nxs_3515x50f1_md_sun", "rhsusf_acc_nxs_5522x56_md", "rhsusf_acc_nxs_5522x56_md_sun", "rhsusf_acc_LEUPOLDMK4", "rhsusf_acc_LEUPOLDMK4_2", "rhsusf_acc_LEUPOLDMK4_d", "rhsusf_acc_LEUPOLDMK4_wd", "rhsusf_acc_LEUPOLDMK4_2_d", "rhsusf_acc_LEUPOLDMK4_2_mrds"], 75],
        ["Special Scopes Kit", ["optic_Nightstalker", "optic_NVS", "optic_tws", "optic_tws_mg"], 250]
    ] ],
    [ "Turrets", [
        ["M2HB (Low)", ["TURRET", "RHS_M2StaticMG_MiniTripod_D"], 10],
        ["M2HB (Raised)", ["TURRET", "RHS_M2StaticMG_D"], 10],
        ["M2 HMG .50 (Low)", ["TURRET", "B_G_HMG_02_F"], 15],
        ["M2 HMG .50 (Raised)", ["TURRET", "B_G_HMG_02_high_F"], 15],
        ["Mk 19 (Low)", ["TURRET", "RHS_MK19_TriPod_D"], 20],
        ["M41A1 TOW", ["TURRET", "RHS_TOW_TriPod_D"], 30],
        ["M47 Super Dragon", ["TURRET", "ace_dragon_staticAssembled"], 25],
        ["Mk.6 Mortar", ["TURRET", "B_Mortar_01_F"], 50]
    ] ]
];