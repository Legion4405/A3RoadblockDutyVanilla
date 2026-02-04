// For starterloadout, copy/export ACE Arsenal, and make sure it's unwrapped properly. Two [[ at the start of the arrays, and ends with []; (The final one is a patch, so if you save a patch, the last [] will have a string inside.
RB_StarterLoadout_Custom = [["arifle_MXC_F","","","optic_Aco",["30Rnd_65x39_caseless_mag",30],[],""],[],["ACE_VMM3","","","",[],[],""],["U_B_CombatUniform_mcam",[["ACE_EarPlugs",1],["ACE_CableTie",10],["ACE_elasticBandage",10],["ACE_packingBandage",10],["ACE_morphine",2],["ACE_epinephrine",2],["ACE_salineIV_500",2],["ACE_splint",2],["ACE_tourniquet",2],["ACE_MapTools",1]]],["V_TacVest_khk",[["ACE_Sunflower_Seeds",1],["30Rnd_65x39_caseless_mag",4,30],["30Rnd_65x39_caseless_mag_Tracer",2,30],["HandGrenade",2,1],["SmokeShell",1,1],["SmokeShellGreen",1,1]]],[],"H_MilCap_mcamo","",["Binocular","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","ACE_NVGoggles_WP"]],[];
RB_Ambient_Rotary_Custom = [
    "B_Heli_Light_01_F", // Example, expand as needed
    "B_Heli_Transport_01_F"
];
RB_Ambient_Fixed_Custom = [
    "B_Plane_CAS_01_F",
    "B_Plane_Fighter_01_F"
];

// You can add as many categories as you like, it should work. Vehicles, and Turrets have VEHICLE and TURRET in their arrays, the script reads this and spawns the turrets/vehicles properly. Anything else will be unlockled in the arsenal.
// "Ammo" is the sub-category in Logistic Menu, then ["DisplayName", ["Item1", "Item2", "Etc.."], Point Cost],
RB_LogisticsOptions_Custom = [
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
            ["FN Minimi Kit", ["LMG_03_F","optic_Aco","ACE_DBAL_A3_Green","200Rnd_556x45_Box_Tracer_Red_F"], 55]
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

// === Enemy Infantry Pools ===
RB_EnemyInfantryPool_Custom = [
    "O_G_Soldier_F", "O_G_Soldier_AR_F", "O_G_Soldier_LAT_F", "O_G_medic_F", "O_G_engineer_F",
    "O_G_Soldier_SL_F", "O_G_Soldier_TL_F", "O_G_Sharpshooter_F", "O_G_Soldier_GL_F", "O_G_Soldier_lite_F",
    "O_G_Soldier_exp_F"
];

// === Enemy Vehicle Pools ===
RB_EnemyVehiclePool_Custom = [
    "O_G_Offroad_01_F",
    "O_G_Offroad_01_armed_F",
    "O_G_Offroad_01_AT_F"
];

// === Civilian Class Pools ===
RB_CivilianPool_Custom = [
"C_man_p_beggar_F", 
"C_man_1", 
"C_Man_casual_1_F", 
"C_Man_casual_2_F", 
"C_Man_casual_3_F", 
"C_Man_casual_4_v2_F", 
"C_Man_casual_5_v2_F", 
"C_Man_casual_6_v2_F", 
"C_Man_casual_7_F", 
"C_Man_casual_8_F", 
"C_Man_casual_9_F", 
"C_Man_formal_1_F", 
"C_Man_formal_2_F", 
"C_Man_formal_3_F", 
"C_Man_formal_4_F", 
"C_Man_smart_casual_1_F", 
"C_Man_smart_casual_2_F", 
"C_man_sport_3_F", 
"C_Man_casual_4_F", 
"C_Man_casual_5_F", 
"C_Man_casual_6_F", 
"C_man_polo_1_F", 
"C_man_polo_2_F", 
"C_man_polo_3_F", 
"C_man_polo_4_F", 
"C_man_polo_5_F", 
"C_man_polo_6_F", 
"C_man_1_2_F", 
"C_man_1_3_F", 
"C_Man_Fisherman_01_F", 
"C_man_p_fugitive_F", 
"C_man_p_shorts_1_F", 
"C_man_hunter_1_F", 
"C_man_shorts_2_F", 
"C_man_shorts_3_F", 
"C_man_shorts_4_F", 
"C_Man_UtilityWorker_01_F"
];

// === Civilian Vehicle Pools ===
RB_CivilianVehiclePool_Custom = [
    "C_Offroad_01_F", "C_Hatchback_01_F", "C_Hatchback_01_sport_F", "C_Offroad_02_unarmed_F",
    "C_Truck_02_transport_F", "C_Truck_02_covered_F", "C_Van_01_transport_F", "C_Van_02_vehicle_F", "C_SUV_01_F"
];

RB_ArsenalExtra_Custom = [];
