RB_StarterLoadout_APEX_NATO = [["arifle_MXC_khk_F","","","optic_Aco",["30Rnd_65x39_caseless_khaki_mag",30],[],""],[],["ACE_VMM3","","","",[],[],""],["U_B_T_Soldier_F",[["ACE_EarPlugs",1],["ACE_CableTie",10],["ACE_elasticBandage",10],["ACE_packingBandage",10],["ACE_morphine",2],["ACE_epinephrine",2],["ACE_salineIV_500",2],["ACE_splint",2],["ACE_tourniquet",2],["ACE_MapTools",1]]],["V_TacVest_oli",[["ACE_Sunflower_Seeds",1],["ACE_personalAidKit",1],["HandGrenade",2,1],["SmokeShell",1,1],["SmokeShellGreen",1,1],["30Rnd_65x39_caseless_khaki_mag",3,30],["30Rnd_65x39_caseless_khaki_mag_Tracer",2,30]]],[],"H_MilCap_tna_F","",["Binocular","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","ACE_NVG_Gen2"]],[];
RB_Ambient_Rotary_APEX_NATO = ["B_Heli_Light_01_F", "B_Heli_Transport_03_F", "B_Heli_Attack_01_dynamicLoadout_F", "B_Heli_Transport_01_F", "B_CTRG_Heli_Transport_01_tropic_F"];
RB_Ambient_Fixed_APEX_NATO  = ["B_Plane_CAS_01_dynamicLoadout_F", "B_Plane_Fighter_01_F", "B_T_VTOL_01_infantry_F"];

private _gearUpgrade1 = ["V_PlateCarrier1_rgr","V_PlateCarrier1_tna_F", "B_AssaultPack_tna_F", "U_B_T_Soldier_AR_F", "U_B_T_Soldier_SL_F","V_PlateCarrier2_tna_F","H_HelmetB_Light_tna_F", "H_HelmetB_light_black", "H_HelmetB_light_desert", "H_HelmetB_light_grass", "H_HelmetB_light_sand", "B_AssaultPack_cbr", "B_AssaultPack_rgr", "B_AssaultPack_khk", "ACE_NVGoggles_INDEP_WP", "ACE_Vector"];
private _gearUpgrade2 = _gearUpgrade1 + ["V_PlateCarrier2_rgr", "H_HelmetB", "H_HelmetB_snakeskin", "H_HelmetB_tna_F", "H_HelmetB_camo", "H_HelmetB_desert", "B_Carryall_oli", "H_HelmetB_sand", "B_TacticalPack_oli", "B_TacticalPack_blk", "B_TacticalPack_oli", "ACE_NVG_Gen4_Green_WP", "ACE_MX2A"];
private _gearUpgrade3 = _gearUpgrade2 + ["V_PlateCarrierGL_rgr", "B_Bergen_tna_F", "H_HelmetB_Enh_tna_F", "V_PlateCarrierGL_mtp", "V_PlateCarrierSpec_rgr", "V_PlateCarrierSpec_mtp", "H_HelmetSpecB", "H_HelmetSpecB_blk", "H_HelmetSpecB_paint2", "H_HelmetSpecB_paint1", "H_HelmetSpecB_sand", "H_HelmetSpecB_snakeskin", "ACE_NVG_Wide_Green_WP"];

// === Logistics Options Horizontal Layout ===
RB_LogisticsOptions_APEX_NATO = [
    [ "Ammo", [
        ["5.56mm 150rnd Mags", ["150Rnd_556x45_Drum_Green_Mag_F", "150Rnd_556x45_Drum_Mag_F", "150Rnd_556x45_Drum_Sand_Mag_F", "150Rnd_556x45_Drum_Green_Mag_Tracer_F", "150Rnd_556x45_Drum_Mag_Tracer_F","150Rnd_556x45_Drum_Sand_Mag_Tracer_F"], 30],
        ["6.5mm 100rnd Mags", ["100Rnd_65x39_caseless_black_mag", "100Rnd_65x39_caseless_khaki_mag", "100Rnd_65x39_caseless_black_mag_tracer", "100Rnd_65x39_caseless_khaki_mag_tracer"], 30],
        ["7.62mm 20rnd Mags", ["20Rnd_762x51_Mag", "ACE_20Rnd_762x51_Mag_Tracer_Dim", "ACE_20Rnd_762x51_M118LR_Mag", "ACE_20Rnd_762x51_M993_AP_Mag", "ACE_20Rnd_762x51_Mk316_Mod_0_Mag", "ACE_20Rnd_762x51_Mk319_Mod_0_Mag", "ACE_20Rnd_762x51_Mag_SD", "ACE_20Rnd_762x51_Mag_Tracer"], 15]
    ] ],
    [ "Weapons", [
        ["MX Rifle Kit", ["arifle_MX_khk_F"], 20],
        ["MX GL Rifle Kit", ["arifle_MX_GL_khk_F", "1Rnd_HE_Grenade_shell", "ACE_40mm_Pike", "UGL_FlareGreen_F", "UGL_FlareRed_F", "UGL_FlareWhite_F", "ACE_HuntIR_M203", "1Rnd_SmokeBlue_Grenade_shell", "1Rnd_SmokeGreen_Grenade_shell", "1Rnd_SmokeOrange_Grenade_shell", "1Rnd_SmokePurple_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeYellow_Grenade_shell"], 20],
        ["MX LSW Rifle Kit", ["arifle_MX_SW_khk_F", "bipod_01_F_khk"], 20],
        ["MXM Rifle Kit", ["arifle_MXM_khk_F", "bipod_01_F_khk"], 20],
        ["FN Minimi LMG Kit", ["LMG_03_F", "200Rnd_556x45_Box_Tracer_Red_F"], 20],
        ["LWMMG MMG Kit", ["MMG_02_black_F", "130Rnd_338_Mag", "bipod_01_F_blk"], 20],
        ["Mk14 Mod 1 EBR Kit", ["srifle_EBR_F", "ACE_10Rnd_762x51_M118LR_Mag", "ACE_10Rnd_762x51_M993_AP_Mag", "ACE_10Rnd_762x51_Mk316_Mod_0_Mag", "ACE_10Rnd_762x51_Mk319_Mod_0_Mag", "ACE_10Rnd_762x51_Mag_Tracer", "ACE_10Rnd_762x51_Mag_SD"], 20],
        ["Noreen ULR DMR Kit", ["srifle_DMR_02_F","srifle_DMR_02_camo_F","bipod_01_F_blk","bipod_01_F_khk", "ACE_10Rnd_762x67_Berger_Hybrid_OTM_Mag", "ACE_10Rnd_762x67_Mk248_Mod_0_Mag", "ACE_10Rnd_762x67_Mk248_Mod_1_Mag", "10Rnd_338_Mag", "ACE_10Rnd_338_300gr_HPBT_Mag", "ACE_10Rnd_338_API526_Mag"], 20],
        ["M200 Intervention Kit", ["srifle_LRR_tna_F", "7Rnd_408_Mag", "ACE_7Rnd_408_305gr_Mag"], 20],
        ["GM6 Lynx Kit", ["srifle_GM6_F", "5Rnd_127x108_APDS_Mag", "5Rnd_127x108_Mag", "ACE_5Rnd_127x99_Mag", "ACE_5Rnd_127x99_AMAX_Mag", "ACE_5Rnd_127x99_API_Mag"], 20]
    ] ],
    [ "CTRG Weapons", [
        ['HK416A5 11" Kit', ["arifle_SPAR_01_blk_F", "arifle_SPAR_01_khk_F", "arifle_SPAR_01_snd_F", "30Rnd_556x45_Stanag_Tracer_Red", "30Rnd_556x45_Stanag_Sand_Tracer_Red", "ACE_30Rnd_556x45_Stanag_M995_AP_mag", "ACE_30Rnd_556x45_Stanag_Mk262_mag", "ACE_30Rnd_556x45_Stanag_Mk318_mag", "ACE_30Rnd_556x45_Stanag_Tracer_Dim"], 20],
        ['HK416A5 11" GL Kit', ["arifle_SPAR_01_GL_blk_F", "arifle_SPAR_01_GL_khk_F", "arifle_SPAR_01_GL_snd_F", "30Rnd_556x45_Stanag_Tracer_Red", "30Rnd_556x45_Stanag_Sand_Tracer_Red", "ACE_30Rnd_556x45_Stanag_M995_AP_mag", "ACE_30Rnd_556x45_Stanag_Mk262_mag", "ACE_30Rnd_556x45_Stanag_Mk318_mag", "ACE_30Rnd_556x45_Stanag_Tracer_Dim", "1Rnd_HE_Grenade_shell", "ACE_40mm_Pike", "UGL_FlareGreen_F", "UGL_FlareRed_F", "UGL_FlareWhite_F", "ACE_HuntIR_M203", "1Rnd_SmokeBlue_Grenade_shell", "1Rnd_SmokeGreen_Grenade_shell", "1Rnd_SmokeOrange_Grenade_shell", "1Rnd_SmokePurple_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeYellow_Grenade_shell"], 20],
        ['HK416A5 14.5" Kit', ["arifle_SPAR_02_blk_F", "arifle_SPAR_02_khk_F", "arifle_SPAR_02_snd_F","bipod_01_F_khk","bipod_01_F_blk","bipod_01_F_snd", "30Rnd_556x45_Stanag_Tracer_Red", "30Rnd_556x45_Stanag_Sand_Tracer_Red", "ACE_30Rnd_556x45_Stanag_M995_AP_mag", "ACE_30Rnd_556x45_Stanag_Mk262_mag", "ACE_30Rnd_556x45_Stanag_Mk318_mag", "ACE_30Rnd_556x45_Stanag_Tracer_Dim"], 20],
        ['HK417A2 20" Kit', ["arifle_SPAR_03_blk_F", "arifle_SPAR_03_khk_F", "arifle_SPAR_03_snd_F","bipod_01_F_khk","bipod_01_F_blk","bipod_01_F_snd", "ACE_10Rnd_762x51_Mag_Tracer_Dim", "ACE_10Rnd_762x51_M118LR_Mag", "ACE_10Rnd_762x51_M993_AP_Mag", "ACE_10Rnd_762x51_Mk316_Mod_0_Mag", "ACE_10Rnd_762x51_Mk319_Mod_0_Mag", "ACE_10Rnd_762x51_Mag_SD","ACE_10Rnd_762x51_Mag_Tracer"], 20],
        ["FN Minimi SPW Kit", ["LMG_03_F","200Rnd_556x45_Box_Tracer_Red_F"], 20]
    ] ],
    [ "Launchers", [
        ["NLAW Kit", ["launch_NLAW_F"], 10],
        ["MAAWS Mk4 Mod 0 Kit", ["launch_MRAWS_green_rail_F", "launch_MRAWS_olive_rail_F", "MRAWS_HE_F", "MRAWS_HEAT55_F", "MRAWS_HEAT_F"], 20],
        ["MAAWS Mk4 Mod 1 Kit", ["launch_MRAWS_green_F", "launch_MRAWS_olive_F", "MRAWS_HE_F", "MRAWS_HEAT55_F", "MRAWS_HEAT_F"], 30]
    ] ],
    [ "Gear", [
        ["Gear Upgrade #1", _gearUpgrade1, 20],
        ["Gear Upgrade #2", _gearUpgrade2, 40],
        ["Gear Upgrade #3", _gearUpgrade3, 60]
    ] ],
    [ "Attachments", [
        ["Bipod Kit", ["bipod_01_F_blk", "bipod_01_F_khk"], 10],
        ["Rail Attachment Kit", ["ACE_DBAL_A3_Green", "ACE_DBAL_A3_Red", "acc_pointer_IR", "ACE_SPIR"], 15],
        ["Suppressor Kit", ["muzzle_snds_B", "muzzle_snds_L", "muzzle_snds_M", "muzzle_snds_338_sand"], 75],
        ["CQB Scope Kit", ["optic_Yorris", "optic_Aco", "optic_Aco_smg", "optic_Holosight_blk_F", "optic_Holosight_smg_blk_F"], 25],
        ["Rifle Scope Kit", ["optic_MRCO", "optic_Hamr", "ACE_optic_MRCO_2D", "ACE_optic_Hamr_2D", "optic_Arco_blk_F", "optic_ERCO_blk_F", "optic_Hamr", "ACE_optic_Hamr_2D", "optic_Hamr_sand_lxWS", "optic_Hamr_snake_lxWS", "optic_ERCO_blk_F", "optic_ERCO_snd_F"], 50],
        ["Sniper Scope Kit", ["optic_DMS", "optic_SOS", "optic_LRPS", "ACE_optic_SOS_2D", "ACE_optic_LRPS_2D", "optic_KHS_blk", "optic_AMS", "optic_AMS_snd"], 75],
        ["Special Scopes Kit", ["optic_Nightstalker", "optic_NVS", "optic_tws", "optic_tws_mg"], 250]
    ] ],
    [ "Vehicles", [
        ["Quadbike", ["VEHICLE", "B_Quadbike_01_F"], 5],
        ["Polaris DAGOR", ["VEHICLE", "B_LSV_01_unarmed_F"], 10],
        ["Polaris DAGOR Mini Spike AT", ["VEHICLE", "B_LSV_01_AT_F"], 10],
        ["Polaris DAGOR XM312", ["VEHICLE", "B_LSV_01_armed_F"], 10],
        ["Hunter MRAP", ["VEHICLE", "B_MRAP_01_F"], 15],
        ["Hunter MRAP HMG", ["VEHICLE", "B_MRAP_01_hmg_F"], 25],
        ["Hunter MRAP GMG", ["VEHICLE", "B_MRAP_01_gmg_F"], 40]
    ] ],
    [ "Turrets", [
        ["M2 HMG .50 (Low)", ["TURRET", "B_G_HMG_02_F"], 15],
        ["M2 HMG .50 (Raised)", ["TURRET", "B_G_HMG_02_high_F"], 15],
        ["XM312 (Low)", ["TURRET", "B_HMG_01_F"], 20],
        ["XM312 (High)", ["TURRET", "B_HMG_01_high_F"], 20],
        ["XM307 (Low)", ["TURRET", "B_GMG_01_F"], 30],
        ["XM307 (High)", ["TURRET", "B_GMG_01_high_F"], 30],
        ["M47 Super Dragon", ["TURRET", "ace_dragon_staticAssembled"], 25],
        ["Mk.6 Mortar", ["TURRET", "B_Mortar_01_F"], 50]
    ] ]
];