// File: configs\playerFactions\vanilla_nato.sqf

// 1. STARTER LOADOUT (ACE Arsenal Export)
RB_StarterLoadout_NATO = [["arifle_MXC_F","","","optic_Aco",["30Rnd_65x39_caseless_mag",30],[],""],[],["ACE_VMM3","","","",[],[],""],["U_B_CombatUniform_mcam",[["ACE_EarPlugs",1],["ACE_CableTie",10],["ACE_elasticBandage",10],["ACE_packingBandage",10],["ACE_morphine",2],["ACE_epinephrine",2],["ACE_salineIV_500",2],["ACE_splint",2],["ACE_tourniquet",2],["ACE_MapTools",1]]],["V_TacVest_khk",[["ACE_Sunflower_Seeds",1],["30Rnd_65x39_caseless_mag",4,30],["30Rnd_65x39_caseless_mag_Tracer",2,30],["HandGrenade",2,1],["SmokeShell",1,1],["SmokeShellGreen",1,1]]],[],"H_MilCap_mcamo","",["Binocular","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","ACE_NVGoggles_WP"]],[];

// 2. AMBIENT ASSETS
RB_Ambient_Rotary_NATO = ["B_Heli_Light_01_F", "B_Heli_Transport_03_F", "B_Heli_Attack_01_dynamicLoadout_F", "B_Heli_Transport_01_F"];
RB_Ambient_Fixed_NATO  = ["B_Plane_CAS_01_dynamicLoadout_F", "B_Plane_Fighter_01_F"];

// 3. GEAR PRESETS
private _gear1 = ["V_PlateCarrier1_rgr", "U_B_CombatUniform_mcam_vest", "H_HelmetB_light_black", "H_HelmetB_light_desert", "H_HelmetB_light_grass", "H_HelmetB_light_sand", "U_B_CombatUniform_mcam_tshirt", "B_AssaultPack_cbr", "B_AssaultPack_rgr", "B_AssaultPack_khk", "ACE_NVG_Gen4_WP", "ACE_Vector"];
private _gear2 = _gear1 + ["V_PlateCarrier2_rgr", "H_HelmetB", "H_HelmetB_snakeskin", "H_HelmetB_camo", "H_HelmetB_desert", "H_HelmetB_sand", "B_TacticalPack_mcamo", "B_TacticalPack_blk", "B_TacticalPack_oli", "ACE_NVG_Wide_WP", "ACE_MX2A"];
private _gear3 = _gear2 + ["V_PlateCarrierGL_rgr", "V_PlateCarrierGL_mtp", "V_PlateCarrierSpec_rgr", "V_PlateCarrierSpec_mtp", "H_HelmetSpecB", "H_HelmetSpecB_blk", "H_HelmetSpecB_paint2", "H_HelmetSpecB_paint1", "H_HelmetSpecB_sand", "H_HelmetSpecB_snakeskin"];

// 4. LOGISTICS OPTIONS
RB_LogisticsOptions_Vanilla_NATO = [
    [ "Reinforcements", [
        // Format: [Label, [Units], TransportVehicle, Cost]
        ["Rifleman (Unarmed)", ["B_Soldier_unarmed_F"], "B_MRAP_01_F", 15],
        ["Rifleman", ["B_Soldier_F"], "B_MRAP_01_F", 30],
        ["Sentry (2)", ["B_Soldier_TL_F", "B_Soldier_F"], "B_MRAP_01_F", 50],
        ["Fire Team (4)",   ["B_Soldier_TL_F", "B_Soldier_GL_F", "B_soldier_AR_F", "B_medic_F"], "B_MRAP_01_F", 75],
        ["Squad (10)",       ["B_Soldier_SL_F", "B_medic_F", "B_Soldier_TL_F", "B_Soldier_GL_F", "B_soldier_LAT2_F", "B_soldier_AR_F", "B_Soldier_TL_F", "B_Patrol_Soldier_MG_F", "B_Soldier_GL_F", "B_soldier_M_F"], "B_Truck_01_covered_F", 200]
    ] ],
    [ "Ammo", [
        ["5.56mm 150rnd Mags", ["150Rnd_556x45_Drum_Green_Mag_F", "150Rnd_556x45_Drum_Mag_F", "150Rnd_556x45_Drum_Sand_Mag_F", "150Rnd_556x45_Drum_Green_Mag_Tracer_F", "150Rnd_556x45_Drum_Mag_Tracer_F","150Rnd_556x45_Drum_Sand_Mag_Tracer_F"], 30],
        ["6.5mm 100rnd Mags", ["100Rnd_65x39_caseless_black_mag", "100Rnd_65x39_caseless_mag", "ACE_100Rnd_65x39_caseless_mag_Tracer_Dim", "100Rnd_65x39_caseless_black_mag_tracer", "100Rnd_65x39_caseless_mag_Tracer"], 30],
        ["7.62mm 20rnd Mags", ["20Rnd_762x51_Mag", "ACE_20Rnd_762x51_Mag_Tracer_Dim", "ACE_20Rnd_762x51_M118LR_Mag", "ACE_20Rnd_762x51_M993_AP_Mag", "ACE_20Rnd_762x51_Mk316_Mod_0_Mag", "ACE_20Rnd_762x51_Mk319_Mod_0_Mag", "ACE_20Rnd_762x51_Mag_SD", "ACE_20Rnd_762x51_Mag_Tracer"], 15]
    ] ],
    [ "Weapons", [
        ["MX Rifle Kit", ["arifle_MX_F"], 20],
        ["MX GL Rifle Kit", ["arifle_MX_GL_F", "1Rnd_HE_Grenade_shell", "ACE_40mm_Pike", "UGL_FlareGreen_F", "UGL_FlareRed_F", "UGL_FlareWhite_F", "ACE_HuntIR_M203", "1Rnd_SmokeBlue_Grenade_shell", "1Rnd_SmokeGreen_Grenade_shell", "1Rnd_SmokeOrange_Grenade_shell", "1Rnd_SmokePurple_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeYellow_Grenade_shell"], 45],
        ["MX LSW Rifle Kit", ["arifle_MX_SW_F"], 45],
        ["MXM Rifle Kit", ["arifle_MXM_F"], 50],
        ["Stoner 99 LMG Kit", ["LMG_Mk200_F", "200Rnd_65x39_cased_Box", "ACE_200Rnd_65x39_cased_Box_Tracer_Dim", "200Rnd_65x39_cased_Box_Tracer_Red"], 75],
        ["LWMMG MMG Kit", ["MMG_02_sand_F", "130Rnd_338_Mag"], 85],
        ["Mk14 Mod 1 EBR Kit", ["srifle_EBR_F", "ACE_10Rnd_762x51_M118LR_Mag", "ACE_10Rnd_762x51_M993_AP_Mag", "ACE_10Rnd_762x51_Mk316_Mod_0_Mag", "ACE_10Rnd_762x51_Mk319_Mod_0_Mag", "ACE_10Rnd_762x51_Mag_Tracer", "ACE_10Rnd_762x51_Mag_SD"], 100],
        ["Noreen ULR DMR Kit", ["srifle_DMR_02_sniper_F", "ACE_10Rnd_762x67_Berger_Hybrid_OTM_Mag", "ACE_10Rnd_762x67_Mk248_Mod_0_Mag", "ACE_10Rnd_762x67_Mk248_Mod_1_Mag", "10Rnd_338_Mag", "ACE_10Rnd_338_300gr_HPBT_Mag", "ACE_10Rnd_338_API526_Mag"], 125],
        ["M200 Intervention Kit", ["srifle_LRR_F", "7Rnd_408_Mag", "ACE_7Rnd_408_305gr_Mag"], 150],
        ["GM6 Lynx Kit", ["srifle_GM6_F", "5Rnd_127x108_APDS_Mag", "5Rnd_127x108_Mag", "ACE_5Rnd_127x99_Mag", "ACE_5Rnd_127x99_AMAX_Mag", "ACE_5Rnd_127x99_API_Mag"], 200]
    ] ],
    [ "Launchers", [
        ["NLAW Kit", ["launch_NLAW_F"], 30],
        ["MAAWS Mk4 Mod 0 Kit", ["launch_MRAWS_green_rail_F", "launch_MRAWS_olive_rail_F", "MRAWS_HE_F", "MRAWS_HEAT55_F", "MRAWS_HEAT_F"], 75],
        ["MAAWS Mk4 Mod 1 Kit", ["launch_MRAWS_green_F", "launch_MRAWS_olive_F", "MRAWS_HE_F", "MRAWS_HEAT55_F", "MRAWS_HEAT_F"], 100]
    ] ],
    [ "Gear", [
        ["Gear Upgrade #1", _gear1, 40],
        ["Gear Upgrade #2", _gear2, 65],
        ["Gear Upgrade #3", _gear3, 90]
    ] ],
    [ "Attachments", [
        ["Bipod Kit", ["bipod_01_F_blk", "bipod_01_F_snd"], 10],
        ["Rail Attachment Kit", ["ACE_DBAL_A3_Green", "ACE_DBAL_A3_Red", "acc_pointer_IR", "ACE_SPIR"], 15],
        ["Suppressor Kit", ["muzzle_snds_h","muzzle_snds_B", "muzzle_snds_L", "muzzle_snds_M", "muzzle_snds_338_sand"], 50],
        ["CQB Scope Kit", ["optic_Yorris", "optic_Aco", "optic_Aco_smg", "optic_Holosight_blk_F", "optic_Holosight_smg_blk_F"], 25],
        ["Rifle Scope Kit", ["optic_MRCO", "optic_Hamr", "ACE_optic_MRCO_2D", "ACE_optic_Hamr_2D", "optic_Arco_blk_F", "optic_ERCO_blk_F", "optic_Hamr", "ACE_optic_Hamr_2D", "optic_Hamr_sand_lxWS", "optic_Hamr_snake_lxWS", "optic_ERCO_blk_F", "optic_ERCO_snd_F"], 50],
        ["Sniper Scope Kit", ["optic_DMS", "optic_SOS", "optic_LRPS", "ACE_optic_SOS_2D", "ACE_optic_LRPS_2D", "optic_KHS_blk", "optic_AMS", "optic_AMS_snd"], 75],
        ["Special Scopes Kit", ["optic_Nightstalker", "optic_NVS", "optic_tws", "optic_tws_mg"], 250]
    ] ],
        [ "Explosives", [
        ["Mines Kit", ["ClaymoreDirectionalMine_Remote_Mag", "SLAMDirectionalMine_Wire_Mag", "APERSTripMine_Wire_Mag", "ACE_FlareTripMine_Mag","ACE_FlareTripMine_Mag_Green", "ACE_FlareTripMine_Mag_Red","APERSMine_Range_Mag","ACE_APERSMine_ToePopper_Mag","APERSMineDispenser_Mag"], 100]
    ] ],
    [ "Vehicles", [
        ["Quadbike", ["VEHICLE", "B_Quadbike_01_F"], 5],
        ["Polaris DAGOR", ["VEHICLE", "B_LSV_01_unarmed_F"], 10],
        ["Polaris DAGOR Mini Spike AT", ["VEHICLE", "B_LSV_01_AT_F"], 50],
        ["Polaris DAGOR XM312", ["VEHICLE", "B_LSV_01_armed_F"], 40],
        ["Hunter MRAP", ["VEHICLE", "B_MRAP_01_F"], 25],
        ["Hunter MRAP HMG", ["VEHICLE", "B_MRAP_01_hmg_F"], 75],
        ["Hunter MRAP GMG", ["VEHICLE", "B_MRAP_01_gmg_F"], 125]
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

RB_ArsenalExtra_NATO = [
];
