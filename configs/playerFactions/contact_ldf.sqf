// For starterloadout, copy/export ACE Arsenal, and make sure it's unwrapped properly. Two [[ at the start of the arrays, and ends with []; (The final one is a patch, so if you save a patch, the last [] will have a string inside.
RB_StarterLoadout_Contact_LDF = [["SMG_03C_black","","","",["50Rnd_570x28_SMG_03",50],[],""],[],["ACE_VMM3","","","",[],[],""],["U_I_E_Uniform_01_F",[["ACE_EarPlugs",1],["ACE_CableTie",10],["ACE_elasticBandage",10],["ACE_packingBandage",10],["ACE_morphine",2],["ACE_epinephrine",2],["ACE_salineIV_500",2],["ACE_splint",2],["ACE_tourniquet",2],["ACE_MapTools",1],["ACE_bloodIV_250",1]]],["V_TacVest_oli",[["ACE_Sunflower_Seeds",1],["ACE_personalAidKit",1],["ACE_bloodIV_250",1],["ACE_bloodIV_500",1],["HandGrenade",2,1],["SmokeShell",1,1],["SmokeShellGreen",1,1],["50Rnd_570x28_SMG_03",4,50]]],[],"H_MilCap_eaf","",["Binocular","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","ACE_NVGoggles_INDEP_WP"]],[];
RB_Ambient_Rotary_Contact_LDF = ["I_E_Heli_light_03_dynamicLoadout_F", "B_Heli_Light_01_F"];
RB_Ambient_Fixed_Contact_LDF  = ["I_Plane_Fighter_04_F", "I_Plane_Fighter_03_dynamicLoadout_F"];

// You can add as many categories as you like, it should work. Vehicles, and Turrets have VEHICLE and TURRET in their arrays, the script reads this and spawns the turrets/vehicles properly. Anything else will be unlockled in the arsenal.
// "Ammo" is the sub-category in Logistic Menu, then ["DisplayName", ["Item1", "Item2", "Etc.."], Point Cost],
// === Gear Upgrade Arrays ===
private _gearUpgrade1 = ["V_PlateCarrier1_wdl", "U_I_E_Uniform_01_officer_F", "U_I_E_Uniform_01_shortsleeve_F", "U_I_E_Uniform_01_sweater_F", "U_I_E_Uniform_01_tanktop_F", "U_I_L_Uniform_01_deserter_F", "V_CarrierRigKBT_01_light_Olive_F", "V_CarrierRigKBT_01_light_EAF_F", "H_HelmetHBK_headset_F", "H_HelmetHBK_F", "B_AssaultPack_rgr", "B_AssaultPack_khk", "B_AssaultPack_eaf_F", "ACE_NVG_Gen4_Green_WP", "ACE_Vector"];
private _gearUpgrade2 = _gearUpgrade1 + ["V_CarrierRigKBT_01_heavy_EAF_F", "V_CarrierRigKBT_01_heavy_Olive_F", "H_HelmetHBK_chops_F", "H_HelmetHBK_ear_F", "B_Carryall_eaf_F", "B_Carryall_green_F", "B_Carryall_oli", "B_Kitbag_rgr", "B_Kitbag_sgg", "ACE_NVG_Wide_WP", "ACE_MX2A"];


// === Logistics Options Horizontal Layout ===
RB_LogisticsOptions_Contact_LDF = [
    [ "Ammo", [
        ["5.56mm 150rnd Mags", ["150Rnd_556x45_Drum_Green_Mag_F", "150Rnd_556x45_Drum_Mag_F", "150Rnd_556x45_Drum_Sand_Mag_F", "150Rnd_556x45_Drum_Green_Mag_Tracer_F", "150Rnd_556x45_Drum_Mag_Tracer_F","150Rnd_556x45_Drum_Sand_Mag_Tracer_F"], 30],
        ["7.62mm 20rnd Mags", ["20Rnd_762x51_Mag", "ACE_20Rnd_762x51_Mag_Tracer_Dim", "ACE_20Rnd_762x51_M118LR_Mag", "ACE_20Rnd_762x51_M993_AP_Mag", "ACE_20Rnd_762x51_Mk316_Mod_0_Mag", "ACE_20Rnd_762x51_Mk319_Mod_0_Mag", "ACE_20Rnd_762x51_Mag_SD", "ACE_20Rnd_762x51_Mag_Tracer"], 15]
    ] ],
    [ "Weapons", [
        ["MSBS Grot Kit", ["arifle_MSBS65_F", "arifle_MSBS65_black_F", "arifle_MSBS65_camo_F", "30Rnd_65x39_caseless_msbs_mag", "30Rnd_65x39_caseless_msbs_mag_Tracer"], 15],
        ["MSBS Grot GL Kit", ["arifle_MSBS65_GL_F", "arifle_MSBS65_GL_black_F", "arifle_MSBS65_GL_camo_F", "1Rnd_HE_Grenade_shell", "ACE_40mm_Pike", "UGL_FlareGreen_F", "UGL_FlareRed_F", "UGL_FlareWhite_F", "ACE_HuntIR_M203", "1Rnd_SmokeBlue_Grenade_shell", "1Rnd_SmokeGreen_Grenade_shell", "1Rnd_SmokeOrange_Grenade_shell", "1Rnd_SmokePurple_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeYellow_Grenade_shell", "30Rnd_65x39_caseless_msbs_mag", "30Rnd_65x39_caseless_msbs_mag_Tracer"], 20],
        ["MSBS Grot MR Kit", ["arifle_MSBS65_Mark_F", "arifle_MSBS65_Mark_black_F", "arifle_MSBS65_Mark_camo_F", "bipod_01_F_blk", "30Rnd_65x39_caseless_msbs_mag", "30Rnd_65x39_caseless_msbs_mag_Tracer"], 20],
        ["MSBS Grot SG Kit", ["arifle_MSBS65_UBS_F", "arifle_MSBS65_UBS_black_F", "arifle_MSBS65_UBS_camo_F", "6Rnd_12Gauge_Pellets", "6Rnd_12Gauge_Slug", "30Rnd_65x39_caseless_msbs_mag", "30Rnd_65x39_caseless_msbs_mag_Tracer"], 20],
        ["Stoner 99 LMG Kit", ["LMG_Mk200_black_F", "200Rnd_65x39_cased_Box", "ACE_200Rnd_65x39_cased_Box_Tracer_Dim", "200Rnd_65x39_cased_Box_Tracer_Red", "bipod_01_F_blk"], 20],
        ["LWMMG MMG Kit", ["MMG_02_black_F", "130Rnd_338_Mag", "bipod_01_F_blk"], 20],
        ["Mk14 Mod 1 EBR Kit", ["srifle_EBR_F", "ACE_10Rnd_762x51_M118LR_Mag", "ACE_10Rnd_762x51_M993_AP_Mag", "ACE_10Rnd_762x51_Mk316_Mod_0_Mag", "ACE_10Rnd_762x51_Mk319_Mod_0_Mag", "ACE_10Rnd_762x51_Mag_Tracer", "ACE_10Rnd_762x51_Mag_SD"], 20],
        ["Noreen ULR DMR Kit", ["srifle_DMR_02_F", "ACE_10Rnd_762x67_Berger_Hybrid_OTM_Mag", "ACE_10Rnd_762x67_Mk248_Mod_0_Mag", "ACE_10Rnd_762x67_Mk248_Mod_1_Mag", "10Rnd_338_Mag", "ACE_10Rnd_338_300gr_HPBT_Mag", "ACE_10Rnd_338_API526_Mag", "bipod_01_F_blk"], 20],
        ["M200 Intervention Kit", ["srifle_LRR_F", "7Rnd_408_Mag", "ACE_7Rnd_408_305gr_Mag"], 20],
        ["GM6 Lynx Kit", ["srifle_GM6_F", "5Rnd_127x108_APDS_Mag", "5Rnd_127x108_Mag", "ACE_5Rnd_127x99_Mag", "ACE_5Rnd_127x99_AMAX_Mag", "ACE_5Rnd_127x99_API_Mag"], 20]
    ] ],
    [ "CTRG Weapons", [
        ['HK416A5 11" Kit', ["arifle_SPAR_01_blk_F", "arifle_SPAR_01_khk_F", "30Rnd_556x45_Stanag_Tracer_Red", "30Rnd_556x45_Stanag_Sand_Tracer_Red", "ACE_30Rnd_556x45_Stanag_M995_AP_mag", "ACE_30Rnd_556x45_Stanag_Mk262_mag", "ACE_30Rnd_556x45_Stanag_Mk318_mag", "ACE_30Rnd_556x45_Stanag_Tracer_Dim"], 20],
        ['HK416A5 11" GL Kit', ["arifle_SPAR_01_GL_blk_F", "arifle_SPAR_01_GL_khk_F", "30Rnd_556x45_Stanag_Tracer_Red", "30Rnd_556x45_Stanag_Sand_Tracer_Red", "ACE_30Rnd_556x45_Stanag_M995_AP_mag", "ACE_30Rnd_556x45_Stanag_Mk262_mag", "ACE_30Rnd_556x45_Stanag_Mk318_mag", "ACE_30Rnd_556x45_Stanag_Tracer_Dim", "1Rnd_HE_Grenade_shell", "ACE_40mm_Pike", "UGL_FlareGreen_F", "UGL_FlareRed_F", "UGL_FlareWhite_F", "ACE_HuntIR_M203", "1Rnd_SmokeBlue_Grenade_shell", "1Rnd_SmokeGreen_Grenade_shell", "1Rnd_SmokeOrange_Grenade_shell", "1Rnd_SmokePurple_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeYellow_Grenade_shell"], 20],
        ['HK416A5 14.5" Kit', ["arifle_SPAR_02_blk_F", "arifle_SPAR_02_khk_F","bipod_01_F_khk","bipod_01_F_blk","bipod_01_F_khk", "30Rnd_556x45_Stanag_Tracer_Red", "30Rnd_556x45_Stanag_Sand_Tracer_Red", "ACE_30Rnd_556x45_Stanag_M995_AP_mag", "ACE_30Rnd_556x45_Stanag_Mk262_mag", "ACE_30Rnd_556x45_Stanag_Mk318_mag", "ACE_30Rnd_556x45_Stanag_Tracer_Dim"], 20],
        ['HK417A2 20" Kit', ["arifle_SPAR_03_blk_F", "arifle_SPAR_03_khk_F","bipod_01_F_khk","bipod_01_F_blk","bipod_01_F_khk", "ACE_10Rnd_762x51_Mag_Tracer_Dim", "ACE_10Rnd_762x51_M118LR_Mag", "ACE_10Rnd_762x51_M993_AP_Mag", "ACE_10Rnd_762x51_Mk316_Mod_0_Mag", "ACE_10Rnd_762x51_Mk319_Mod_0_Mag", "ACE_10Rnd_762x51_Mag_SD","ACE_10Rnd_762x51_Mag_Tracer"], 20],
        ["FN Minimi SPW Kit", ["LMG_03_F","200Rnd_556x45_Box_Tracer_Red_F"], 20]
    ] ],
    [ "Launchers", [
        ["NLAW Kit", ["launch_NLAW_F"], 10],
        ["MAAWS Mk4 Mod 0 Kit", ["launch_MRAWS_green_rail_F", "launch_MRAWS_sand_rail_F", "MRAWS_HE_F", "MRAWS_HEAT55_F", "MRAWS_HEAT_F"], 20],
        ["MAAWS Mk4 Mod 1 Kit", ["launch_MRAWS_green_F", "launch_MRAWS_sand_F", "MRAWS_HE_F", "MRAWS_HEAT55_F", "MRAWS_HEAT_F"], 30]
    ] ],
    [ "Gear", [
        ["Gear Upgrade #1", _gearUpgrade1, 40],
        ["Gear Upgrade #2", _gearUpgrade2, 65]
    ] ],
    [ "Attachments", [
        ["Bipod Kit", ["bipod_01_F_blk", "bipod_01_F_khk"], 10],
        ["Rail Attachment Kit", ["ACE_DBAL_A3_Green", "ACE_DBAL_A3_Red", "acc_pointer_IR", "ACE_SPIR"], 15],
        ["Suppressor Kit", ["muzzle_snds_B", "muzzle_snds_L", "muzzle_snds_M", "muzzle_snds_338_black", "muzzle_snds_338_green"], 50],
        ["CQB Scope Kit", ["optic_Yorris", "optic_Aco", "optic_Aco_smg", "optic_Holosight_blk_F", "optic_Holosight_smg_blk_F", "optic_ico_01_f", "optic_ico_01_black_f", "optic_ico_01_camo_f"], 25],
        ["Rifle Scope Kit", ["optic_MRCO", "optic_Hamr", "ACE_optic_MRCO_2D", "ACE_optic_Hamr_2D", "optic_Arco_blk_F", "optic_ERCO_blk_F", "optic_Hamr", "ACE_optic_Hamr_2D", "optic_Arco_lush_F", "optic_Hamr_snake_lxWS", "optic_ERCO_blk_F", "optic_ERCO_snd_F"], 50],
        ["Sniper Scope Kit", ["optic_DMS", "optic_SOS", "optic_LRPS", "ACE_optic_SOS_2D", "ACE_optic_LRPS_2D", "optic_KHS_blk", "optic_AMS", "optic_AMS_snd"], 75],
        ["Special Scopes Kit", ["optic_Nightstalker", "optic_NVS", "optic_tws", "optic_tws_mg"], 250]
    ] ],
    [ "Turrets", [
        ["M2 HMG .50 (Low)", ["TURRET", "B_G_HMG_02_F"], 15],
        ["M2 HMG .50 (Raised)", ["TURRET", "B_G_HMG_02_high_F"], 15],
        ["M2 HMG Scoped .50 (Low)", ["TURRET", "I_E_HMG_02_F"], 20],
        ["M2 HMG Scoped .50 (Raised)", ["TURRET", "I_E_HMG_02_high_F"], 20],
        ["XM312 (Low)", ["TURRET", "B_HMG_01_F"], 20],
        ["XM312 (High)", ["TURRET", "B_HMG_01_high_F"], 20],
        ["XM307 (Low)", ["TURRET", "B_GMG_01_F"], 30],
        ["XM307 (High)", ["TURRET", "B_GMG_01_high_F"], 30],
        ["M47 Super Dragon", ["TURRET", "ace_dragon_staticAssembled"], 25],
        ["Mini-Spike Launcher", ["TURRET", "I_E_Static_AT_F"], 25],
        ["Mk.6 Mortar", ["TURRET", "B_Mortar_01_F"], 50]
    ] ]
];