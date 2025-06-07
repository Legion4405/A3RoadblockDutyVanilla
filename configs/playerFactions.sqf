// For starterloadout, copy/export ACE Arsenal, and make sure it's unwrapped properly. Two [[ at the start of the arrays, and ends with []; (The final one is a patch, so if you save a patch, the last [] will have a string inside.
RB_StarterLoadout_NATO = [["arifle_MXC_F","","","optic_Aco",["30Rnd_65x39_caseless_mag",30],[],""],[],["ACE_VMM3","","","",[],[],""],["U_B_CombatUniform_mcam",[["ACE_EarPlugs",1],["ACE_CableTie",10],["ACE_elasticBandage",10],["ACE_packingBandage",10],["ACE_morphine",2],["ACE_epinephrine",2],["ACE_salineIV_500",2],["ACE_splint",2],["ACE_tourniquet",2],["ACE_MapTools",1]]],["V_TacVest_khk",[["ACE_Sunflower_Seeds",1],["30Rnd_65x39_caseless_mag",4,30],["30Rnd_65x39_caseless_mag_Tracer",2,30],["HandGrenade",2,1],["SmokeShell",1,1],["SmokeShellGreen",1,1]]],[],"H_MilCap_mcamo","",["Binocular","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","ACE_NVGoggles_WP"]],[];
RB_Ambient_Rotary_NATO = ["B_Heli_Light_01_F", "B_Heli_Attack_01_F"];
RB_Ambient_Fixed_NATO  = ["B_Plane_CAS_01_dynamicLoadout_F", "B_Plane_Fighter_01_F"];

// You can add as many categories as you like, it should work. Vehicles, and Turrets have VEHICLE and TURRET in their arrays, the script reads this and spawns the turrets/vehicles properly. Anything else will be unlockled in the arsenal.
// "Ammo" is the sub-category in Logistic Menu, then ["DisplayName", ["Item1", "Item2", "Etc.."], Point Cost],
RB_LogisticsOptions_Vanilla_NATO = [
    [
        "Ammo",
        [
            ["Basic Ammo Kit", ["30Rnd_556x45_Stanag","HandGrenade"], 10],
            ["Heavy Weapons Kit", ["launch_NLAW_F","Titan_AA"], 30]
        ]
    ],
    [
        "Weapons",
        [
            ["MX Rifle Kit", ["arifle_MX_F","optic_Aco","ACE_DBAL_A3_Green","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_black_mag_Tracer"], 20],
            ["MX 3GL Kit", ["arifle_MX_F","optic_Aco","ACE_DBAL_A3_Green","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_black_mag_Tracer","3Rnd_HE_Grenade_shell"], 30],
            ["MXM Kit", ["arifle_MXM_F","optic_AMS_snd","ACE_DBAL_A3_Green","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_black_mag_Tracer"], 40],
            ["MX LSW Kit", ["arifle_MX_SW_F","optic_Aco","ACE_DBAL_A3_Green","100Rnd_65x39_caseless_mag","100Rnd_65x39_caseless_mag_Tracer"], 45],
            ["Stoner 99 Kit", ["LMG_Mk200_F","optic_Aco","ACE_DBAL_A3_Green","200Rnd_65x39_cased_Box","200Rnd_65x39_cased_Box_Tracer_Red"], 55],
            ["FN Minimi Kit", ["LMG_03_F","optic_Aco","ACE_DBAL_A3_Green","200Rnd_556x45_Box_Tracer_Red_F", "arifle_SLR_V_lxWS"], 55],
            ["Galil ARM Kit", ["arifle_Galat_lxWS", "30Rnd_762x39_Mag_Tracer_Green_F"], 5]
        ]
    ],
    [
        "Gear",
        [
            ["Gear Upgrade #1", ["V_PlateCarrier1_rgr","H_HelmetB_light_black","H_HelmetB_light_desert","H_HelmetB_light_grass","H_HelmetB_light_sand","U_B_CombatUniform_mcam_tshirt","B_AssaultPack_cbr","B_AssaultPack_rgr","B_AssaultPack_khk","ACE_NVG_Gen4_WP","ACE_Vector"], 75],
            ["Gear Upgrade #2", ["V_PlateCarrier2_rgr","H_HelmetB","H_HelmetB_snakeskin","H_HelmetB_camo","H_HelmetB_desert","H_HelmetB_sand","B_TacticalPack_mcamo","B_TacticalPack_blk","B_TacticalPack_oli","ACE_NVG_Wide_WP","ACE_MX2A"], 125]
        ]
    ],
    [
        "Supplies",
        [
            ["Storage Kit", ["30Rnd_65x39_caseless_mag"], 0],
            ["Medical Supplies", ["ACE_fieldDressing","ACE_elasticBandage","ACE_packingBandage","ACE_quikclot","ACE_bodyBag","ACE_epinephrine","ACE_morphine","Medikit","ACE_painkillers","ACE_personalAidKit","ACE_salineIV","ACE_salineIV_250","ACE_salineIV_500","ACE_splint","ACE_surgicalKit","ACE_suture","ACE_tourniquet"], 15]
        ]
    ],
    [
        "Vehicles",
        [
            ["Hunter MRAP", ["VEHICLE","B_MRAP_01_F"], 20],
            ["Quadbike", ["VEHICLE","B_Quadbike_01_F"], 5],
            ["HEMTT Transport", ["VEHICLE","B_Truck_01_transport_F"], 35]
        ]
    ],
    [
        "Turrets",
        [
            ["HMG Turret", ["TURRET","B_HMG_01_F"], 15],
            ["GMG Turret", ["TURRET","B_GMG_01_F"], 18],
            ["AT Turret",  ["TURRET","B_static_AT_F"], 25]
        ]
    ]
];
// CSAT (Opfor) Example
RB_StarterLoadout_CDLC_UNA = [["arifle_Galat_worn_lxWS","","saber_light_lxWS","",["30Rnd_762x39_Mag_worn_lxWS",30],[],""],[],["ACE_VMM3","","","",[],[],""],["U_lxWS_UN_Camo2",[["ACE_CableTie",10],["ACE_EarPlugs",1],["ACE_elasticBandage",10],["ACE_packingBandage",5],["ACE_salineIV_500",1],["ACE_salineIV_250",1],["ACE_splint",2],["ACE_tourniquet",2],["ACE_personalAidKit",1],["ACE_morphine",2],["ACE_epinephrine",2]]],["V_lxWS_UN_Vest_Lite_F",[["ACE_Humanitarian_Ration",1],["ACE_MapTools",1],["ACE_Flashlight_MX991",1],["SmokeShell",2,1],["SmokeShellGreen",1,1],["HandGrenade",2,1],["acex_intelitems_notepad",1,1],["SmokeShellRed",1,1],["ACE_HandFlare_White",2,1],["ACE_HandFlare_Green",1,1],["30Rnd_762x39_Mag_worn_lxWS",5,30]]],[],"lxWS_H_Beret_Colonel","",["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]],[["ace_arsenal_insignia","UN_lxWS"]];


RB_Ambient_Rotary_UNA = ["B_UN_Heli_Transport_02_lxWS"];
RB_Ambient_Fixed_UNA  = ["B_Plane_CAS_01_dynamicLoadout_F", "B_Plane_Fighter_01_F"];

RB_LogisticsOptions_CDLC_UNA = [
    [
        "Ammo",
        [
            ["Galil 75rnd Drum Mags", ["75Rnd_762x39_Mag_F","75Rnd_762x39_Mag_Tracer_F"], 40],
            ["FN FAL 50.00 30rnd Mags", ["30Rnd_762x51_slr_lxWS","30Rnd_762x51_slr_desert_lxWS", "30Rnd_762x51_slr_desert_tracer_green_lxWS", "30Rnd_762x51_slr_tracer_green_lxWS"], 25],
            ["AA-12 8rnd HE Mag", ["8Rnd_12Gauge_AA40_HE_lxWS"], 10],
            ["AA-12 20rnd Mags", ["20Rnd_12Gauge_AA40_HE_lxWS","20Rnd_12Gauge_AA40_Pellets_lxWS", "20Rnd_12Gauge_AA40_Slug_lxWS", "20Rnd_12Gauge_AA40_Smoke_lxWS", "8Rnd_12Gauge_AA40_HE_lxWS"], 20],
            ["Mk14 Mod 1 EBR 20rnd Mags", ["20Rnd_762x51_Mag_blk_lxWS","ACE_20Rnd_762x51_Mag_Tracer", "20Rnd_762x51_Mag_snake_lxWS"], 10],
            ["XMS 75rnd Mags", ["75Rnd_556x45_Stanag_red_lxWS"], 20]
        ]
    ],
    [
        "Weapons",
        [
            ["Galil ARM Kit", ["arifle_Galat_lxWS", "30Rnd_762x39_Mag_Tracer_Green_F"], 5],
            ["Vector R4 Kit", ["arifle_Velko_lxWS", "35Rnd_556x45_Velko_tracer_green_lxWS"], 10],
            ["Vector R5 Carbine Kit", ["arifle_VelkoR5_lxWS", "35Rnd_556x45_Velko_tracer_green_lxWS"], 10],
            ["FN FAL 50.00 Kit", ["arifle_SLR_V_lxWS", "arifle_SLR_D_lxWS", "arifle_SLR_lxWS", "arifle_SLR_Para_lxWS", "20Rnd_762x51_slr_desert_lxWS", "20Rnd_762x51_slr_lxWS", "20Rnd_762x51_slr_tracer_green_lxWS", "20Rnd_762x51_slr_desert_tracer_green_lxWS"], 20],
            ["FN FAL 50.00 GL Kit", ["arifle_SLR_V_GL_lxWS", "arifle_SLR_GL_lxWS", "1Rnd_40mm_HE_lxWS", "1Rnd_50mm_Smoke_lxWS", "1Rnd_58mm_AT_lxWS"], 20],
            ["XMS Kit", ["arifle_XMS_lxWS", "arifle_XMS_Gray_lxWS", "arifle_XMS_Sand_lxWS", "arifle_XMS_M_lxWS", "arifle_XMS_M_Gray_lxWS", "arifle_XMS_M_Sand_lxWS", "ACE_30Rnd_556x45_Stanag_Mk262_mag", "30Rnd_556x45_Stanag_Tracer_Red", "30Rnd_556x45_Stanag_Sand_Tracer_Red"], 20],
            ["Vector R5 Carbine GL Kit", ["arifle_VelkoR5_GL_lxWS", "35Rnd_556x45_Velko_tracer_green_lxWS", "1Rnd_Pellet_Grenade_shell_lxWS", "1Rnd_HE_Grenade_shell","ACE_40mm_Pike","ACE_40mm_Flare_white","ACE_40mm_Flare_green","ACE_40mm_Flare_red","ACE_40mm_Flare_ir", "1Rnd_SmokeBlue_Grenade_shell", "1Rnd_SmokeGreen_Grenade_shell", "1Rnd_SmokeOrange_Grenade_shell", "1Rnd_SmokePurple_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeYellow_Grenade_shell", "ACE_HuntIR_M203"], 35],
            ["XMS GL Kit", ["arifle_XMS_GL_lxWS", "arifle_XMS_GL_Gray_lxWS", "arifle_XMS_GL_Sand_lxWS", "1Rnd_Pellet_Grenade_shell_lxWS", "1Rnd_HE_Grenade_shell","ACE_40mm_Pike","ACE_40mm_Flare_white","ACE_40mm_Flare_green","ACE_40mm_Flare_red","ACE_40mm_Flare_ir", "1Rnd_SmokeBlue_Grenade_shell", "1Rnd_SmokeGreen_Grenade_shell", "1Rnd_SmokeOrange_Grenade_shell", "1Rnd_SmokePurple_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeYellow_Grenade_shell", "ACE_HuntIR_M203", "ACE_30Rnd_556x45_Stanag_Mk262_mag", "30Rnd_556x45_Stanag_Tracer_Red", "30Rnd_556x45_Stanag_Sand_Tracer_Red"], 35],
            ["Stoner 99 LMG Kit", ["LMG_Mk200_F", "200Rnd_65x39_cased_Box", "ACE_200Rnd_65x39_cased_Box_Tracer_Dim", "200Rnd_65x39_cased_Box_Tracer_Red"], 40],
            ["Vektor SS-77 MMG Kit", ["LMG_S77_lxWS", "LMG_S77_Desert_lxWS", "LMG_S77_Compact_lxWS", "LMG_S77_Compact_Snakeskin_lxWS", "100Rnd_762x51_S77_Red_Tracer_lxWS"], 50],
            ["AA-12 Kit", ["sgun_aa40_lxWS", "8Rnd_12Gauge_AA40_Pellets_lxWS", "8Rnd_12Gauge_AA40_Slug_lxWS", "8Rnd_12Gauge_AA40_Smoke_lxWS", "100Rnd_762x51_S77_Red_Tracer_lxWS"], 50],
            ["Mk14 Mod 1 EBR Kit", ["srifle_EBR_blk_lxWS", "srifle_EBR_snake_lxWS", "10Rnd_Mk14_762x51_Mag_blk_lxWS", "10Rnd_Mk14_762x51_Mag_snake_lxWS", "ACE_10Rnd_762x51_Mag_Tracer"], 50]
        ]
    ],
    [
        "Gear",
        [
            ["Gear Upgrade #1", ["lxWS_H_ssh40_un","U_lxWS_UN_Camo3","ACE_Vector", "ACE_microDAGR", "B_AssaultPack_cbr","B_AssaultPack_desert_lxWS"], 75],
            ["Gear Upgrade #2", ["V_lxWS_UN_Vest_F","lxWS_H_PASGT_goggles_UN_F","lxWS_H_PASGT_basic_UN_F","B_Kitbag_desert_lxWS","B_Carryall_desert_lxWS","ACE_NVG_Wide","ACE_NVG_Wide_WP","ACE_MX2A","ItemMotionSensor_lxWS","ACE_NVG_Wide_WP","ACE_MX2A", "MineDetector"], 175]
        ]
    ],
    [
        "Attachments",
        [
            ["Bipod Kit", ["bipod_01_F_blk", "bipod_01_F_khk", "bipod_01_F_snd"], 10],
            ["Rail Attachment Kit", ["ACE_DBAL_A3_Green", "ACE_DBAL_A3_Red", "acc_pointer_IR_sand_lxWS", "acc_pointer_IR", "saber_light_ir_lxWS", "ACE_SPIR"], 15],
            ["Supressor Kit", ["muzzle_snds_M", "suppressor_l_camo_lxWS", "muzzle_snds_m_snd_F", "suppressor_l_lxWS", "suppressor_l_sand_lxWS", "suppressor_l_snake_lxWS", "muzzle_snds_B", "muzzle_snds_B_snd_F", "suppressor_h_lxWS", "suppressor_h_sand_lxWS", "muzzle_snds_12Gauge_lxWS", "suppressor_m_sand_lxWS", "suppressor_m_lxWS"], 75],
            ["CQB Scope Kit", ["optic_r1_high_lxWS", "optic_r1_high_black_sand_lxWS", "optic_r1_high_sand_lxWS", "optic_r1_low_lxWS", "optic_r1_low_sand_lxWS","optic_Aco", "optic_ACO_camo_lxWS", "optic_Holosight_blk_F", "optic_Holosight_snake_lxWS", "optic_Holosight"], 25],
            ["Rifle Scope Kit", ["ACE_optic_Arco_2D", "optic_Arco_blk_F", "optic_Arco", "optic_Arco_AK_blk_F", "optic_MRCO", "ACE_optic_MRCO_2D","optic_Hamr", "ACE_optic_Hamr_2D", "optic_Hamr_sand_lxWS", "optic_Hamr_snake_lxWS", "optic_ERCO_blk_F", "optic_ERCO_snd_F"], 50],
            ["Sniper Scope Kit", ["optic_DMS", "optic_DMS_snake_lxWS", "optic_KHS_tan", "optic_KHS_blk", "optic_SOS", "ACE_optic_SOS_2D", "ACE_optic_LRPS_2D", "optic_LRPS", "optic_AMS", "optic_AMS_snd"], 75],
            ["Special Scopes Kit", ["optic_Nightstalker", "optic_NVS", "optic_tws", "optic_tws_mg", "optic_r1_low_sand_lxWS"], 250]
        ]
    ],
    [
        "Vehicles",
        [
            ["M-ATV", ["VEHICLE","B_UN_MRAP_01_lxWS"], 30],
            ["Offroad Truck", ["B_UN_Offroad_lxWS","B_UN_MRAP_01_lxWS"], 15],
            ["Offroad Truck Uparmored", ["VEHICLE","B_UN_Offroad_Armor_lxWS"], 20],
            ["Otokar ARMA (HMG)", ["VEHICLE","B_UNA_APC_Wheeled_02_hmg_lxWS"], 100],
            ["Bader IFV (Command)", ["VEHICLE","B_UN_APC_Wheeled_01_command_lxWS"], 150]
        ]
    ],
    [
        "Turrets",
        [
            ["M2 HMG .50 (Low)", ["TURRET","B_Tura_HMG_02_lxWS"], 15],
            ["M2 HMG .50 (Raised)", ["TURRET","B_Tura_HMG_02_high_lxWS"], 15],
            ["M47 Super Dragon", ["TURRET","ace_dragon_staticAssembled"], 25],
            ["Mk.6 Mortar",  ["TURRET","B_Tura_Mortar_lxWS"], 50],
            ["ZU-23-2",  ["TURRET","B_Tura_ZU23_lxWS"], 75]
        ]
    ]
];
// Vanilla Gendarmerie
RB_StarterLoadout_APEX_Gendarmerie = [["SMG_05_F","","acc_flashlight","",["30Rnd_9x21_Mag_SMG_02",30],[],""],[],["ACE_VMM3","","","",[],[],""],["U_B_GEN_Soldier_F",[["ACE_CableTie",10],["ACE_EarPlugs",1],["ACE_elasticBandage",10],["ACE_packingBandage",5],["ACE_salineIV_500",1],["ACE_salineIV_250",1],["ACE_splint",2],["ACE_tourniquet",2],["ACE_personalAidKit",1],["ACE_morphine",2],["ACE_epinephrine",2]]],["V_TacVest_blk_POLICE",[["ACE_Humanitarian_Ration",1],["ACE_MapTools",1],["ACE_Flashlight_MX991",1],["SmokeShell",2,1],["SmokeShellGreen",1,1],["HandGrenade",2,1],["acex_intelitems_notepad",1,1],["SmokeShellRed",1,1],["ACE_HandFlare_White",2,1],["ACE_HandFlare_Green",1,1],["30Rnd_9x21_Mag_SMG_02",3,30],["30Rnd_9x21_Mag_SMG_02_Tracer_Red",1,30]]],[],"H_Beret_gen_F","",["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]],[];

RB_Ambient_Rotary_Gendarmerie = ["B_Heli_Light_01_F", "B_Heli_Transport_03_F", "B_Heli_Attack_01_dynamicLoadout_F", "B_Heli_Transport_01_F"];
RB_Ambient_Fixed_Gendarmerie = ["B_Plane_CAS_01_dynamicLoadout_F"];

RB_LogisticsOptions_APEX_Gendarmerie = [
    [
        "Ammo",
        [
            ["HK 416A5 150rnd Drum Mags", ["150Rnd_556x45_Drum_Mag_F","150Rnd_556x45_Drum_Mag_Tracer_F"], 40],
            ["HK 417A2 20nd Mags", ["ACE_20Rnd_762x51_M118LR_Mag", "ACE_20Rnd_762x51_M993_AP_Mag", "ACE_20Rnd_762x51_Mag_Tracer", "ACE_20Rnd_762x51_Mk316_Mod_0_Mag"], 40]
        ]
    ],
    [
        "Weapons",
        [
            ["Scorpion EVO 3 A1 Kit", ["SMG_02_F", "30Rnd_9x21_Mag_SMG_02", "30Rnd_9x21_Mag_SMG_02_Tracer_Red"], 5],
            ['HK416A5 11" Kit', ["arifle_SPAR_01_blk_F", "ACE_30Rnd_556x45_Stanag_Mk262_mag", "ACE_30Rnd_556x45_Stanag_M995_AP_mag", "30Rnd_556x45_Stanag_Tracer_Red"], 20],
            ['HK416A5 14.5" Kit', ["arifle_SPAR_02_blk_F", "ACE_30Rnd_556x45_Stanag_Mk262_mag", "ACE_30Rnd_556x45_Stanag_M995_AP_mag", "30Rnd_556x45_Stanag_Tracer_Red"], 25],
            ['HK416A5 11" GL Kit', ["arifle_SPAR_01_GL_blk_F", "ACE_30Rnd_556x45_Stanag_Mk262_mag", "ACE_30Rnd_556x45_Stanag_M995_AP_mag","30Rnd_556x45_Stanag_Tracer_Red", "1Rnd_Pellet_Grenade_shell_lxWS", "1Rnd_HE_Grenade_shell","ACE_40mm_Pike","ACE_40mm_Flare_white","ACE_40mm_Flare_green","ACE_40mm_Flare_red","ACE_40mm_Flare_ir", "1Rnd_SmokeBlue_Grenade_shell", "1Rnd_SmokeGreen_Grenade_shell", "1Rnd_SmokeOrange_Grenade_shell", "1Rnd_SmokePurple_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeYellow_Grenade_shell", "ACE_HuntIR_M203"], 35],
            ["FN Minimi SPW Kit", ["LMG_03_F", "200Rnd_556x45_Box_Tracer_Red_F"], 40],
            ["LWMMG Kit", ["MMG_02_black_F", "130Rnd_338_Mag"], 50],
            ['HK417A2 20" Kit', ["arifle_SPAR_03_blk_F", "ACE_10Rnd_762x51_M118LR_Mag", "ACE_10Rnd_762x51_M993_AP_Mag", "ACE_10Rnd_762x51_Mag_Tracer", "ACE_10Rnd_762x51_Mk316_Mod_0_Mag"], 50],
            ['SIG 556 Kit', ["srifle_DMR_03_F", "ACE_10Rnd_762x51_M118LR_Mag", "ACE_10Rnd_762x51_M993_AP_Mag", "ACE_10Rnd_762x51_Mag_Tracer", "ACE_10Rnd_762x51_Mk316_Mod_0_Mag"], 50]
        ]
    ],
    [
        "Gear",
        [
            ["Gear Upgrade #1", ["U_B_GEN_Commander_F","V_PlateCarrier1_blk","ACE_Vector", "ACE_microDAGR", "B_AssaultPack_blk","B_FieldPack_blk","H_PASGT_basic_black_F"], 75],
            ["Gear Upgrade #2", ["V_PlateCarrier2_blk","H_HelmetSpecB_blk","H_HelmetB_black","B_Carryall_blk","B_TacticalPack_blk","ACE_NVG_Wide","ACE_NVG_Wide_WP","ACE_MX2A","ACE_NVG_Wide_WP","ACE_MX2A", "MineDetector"], 175]
        ]
    ],
    [
        "Attachments",
        [
            ["Bipod Kit", ["bipod_01_F_blk"], 10],
            ["Rail Attachment Kit", ["ACE_DBAL_A3_Green", "ACE_DBAL_A3_Red", "acc_pointer_IR", "ACE_SPIR"], 15],
            ["Supressor Kit", ["muzzle_snds_B", "muzzle_snds_L", "muzzle_snds_M"], 75],
            ["CQB Scope Kit", ["optic_Yorris", "optic_Aco", "optic_Aco_smg", "optic_Holosight_blk_F", "optic_Holosight_smg_blk_F"], 25],
            ["Rifle Scope Kit", ["optic_MRCO", "optic_Hamr", "ACE_optic_MRCO_2D", "ACE_optic_Hamr_2D", "optic_Arco_blk_F", "optic_ERCO_blk_F","optic_Hamr", "ACE_optic_Hamr_2D", "optic_Hamr_sand_lxWS", "optic_Hamr_snake_lxWS", "optic_ERCO_blk_F", "optic_ERCO_snd_F"], 50],
            ["Sniper Scope Kit", ["optic_DMS", "optic_SOS", "optic_LRPS", "ACE_optic_SOS_2D", "ACE_optic_LRPS_2D", "optic_KHS_blk", "optic_AMS"], 75],
            ["Special Scopes Kit", ["optic_Nightstalker", "optic_NVS", "optic_tws", "optic_tws_mg"], 250]
        ]
    ],
    [
        "Vehicles",
        [
            ["Police Pickup Truck", ["VEHICLE","B_GEN_Offroad_01_gen_F"], 30],
            ["Police Pickup Truck Covered", ["VEHICLE","B_GEN_Offroad_01_covered_F"], 35],
            ["Police Van", ["VEHICLE","B_GEN_Van_02_transport_F"], 15]
        ]
    ],
    [
        "Turrets",
        [
            ["M2 HMG .50 (Low)", ["TURRET","B_G_HMG_02_F"], 15],
            ["M2 HMG .50 (Raised)", ["TURRET","B_G_HMG_02_high_F"], 15],
            ["M47 Super Dragon", ["TURRET","ace_dragon_staticAssembled"], 25],
            ["Mk.6 Mortar",  ["TURRET","B_Mortar_01_F"], 50]
        ]
    ]
];