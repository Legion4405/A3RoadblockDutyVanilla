RB_StarterLoadout_APEX_Gendarmerie = [["SMG_05_F","","acc_flashlight","",["30Rnd_9x21_Mag_SMG_02",30],[],""],[],["ACE_VMM3","","","",[],[],""],["U_B_GEN_Soldier_F",[["ACE_CableTie",10],["ACE_EarPlugs",1],["ACE_elasticBandage",10],["ACE_packingBandage",5],["ACE_salineIV_500",1],["ACE_salineIV_250",1],["ACE_splint",2],["ACE_tourniquet",2],["ACE_personalAidKit",1],["ACE_morphine",2],["ACE_epinephrine",2]]],["V_TacVest_blk_POLICE",[["ACE_Humanitarian_Ration",1],["ACE_MapTools",1],["ACE_Flashlight_MX991",1],["SmokeShell",2,1],["SmokeShellGreen",1,1],["HandGrenade",2,1],["acex_intelitems_notepad",1,1],["SmokeShellRed",1,1],["ACE_HandFlare_White",2,1],["ACE_HandFlare_Green",1,1],["30Rnd_9x21_Mag_SMG_02",3,30],["30Rnd_9x21_Mag_SMG_02_Tracer_Red",1,30]]],[],"H_Beret_gen_F","",["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]],[];
RB_Ambient_Rotary_Gendarmerie = ["B_Heli_Light_01_F", "B_Heli_Transport_03_F", "B_Heli_Attack_01_dynamicLoadout_F", "B_Heli_Transport_01_F"];
RB_Ambient_Fixed_Gendarmerie = ["B_Plane_CAS_01_dynamicLoadout_F"];

RB_LogisticsOptions_APEX_Gendarmerie = [
    [ "Reinforcements", [
        // Format: [Label, [Units], TransportVehicle, Cost]
        ["Gendarme", ["B_GEN_Soldier_F"], "B_GEN_Offroad_01_gen_F", 15],
        ["Sentry (2)", ["B_GEN_Soldier_F", "B_GEN_Soldier_F"], "B_GEN_Offroad_01_gen_F", 50],
        ["Fire Team (4)",   ["B_GEN_Commander_F", "B_GEN_Soldier_F", "B_GEN_Soldier_F", "B_GEN_Soldier_F"], "B_GEN_Van_02_transport_F", 75],
        ["Squad (10)",       ["B_Captain_Dwarden_F", "B_GEN_Commander_F", "B_GEN_Soldier_F", "B_GEN_Soldier_F", "B_GEN_Soldier_F", "B_GEN_Commander_F","B_GEN_Soldier_F", "B_GEN_Soldier_F", "B_GEN_Soldier_F", "B_GEN_Soldier_F"], "B_GEN_Van_02_transport_F", 200]
    ] ],
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
            ["Gear Upgrade #1", ["U_B_GEN_Commander_F","V_PlateCarrier1_blk","ACE_Vector", "ACE_microDAGR", "B_AssaultPack_blk","B_FieldPack_blk","H_PASGT_basic_black_F"], 40],
            ["Gear Upgrade #2", ["V_PlateCarrier2_blk","H_HelmetSpecB_blk","H_HelmetB_black","B_Carryall_blk","B_TacticalPack_blk","ACE_NVG_Wide","ACE_NVG_Wide_WP","ACE_MX2A","ACE_NVG_Wide_WP","ACE_MX2A"], 65]
        ]
    ],
    [
        "Attachments",
        [
            ["Bipod Kit", ["bipod_01_F_blk"], 10],
            ["Rail Attachment Kit", ["ACE_DBAL_A3_Green", "ACE_DBAL_A3_Red", "acc_pointer_IR", "ACE_SPIR"], 15],
            ["Suppressor Kit", ["muzzle_snds_B", "muzzle_snds_L", "muzzle_snds_M"], 50],
            ["CQB Scope Kit", ["optic_Yorris", "optic_Aco", "optic_Aco_smg", "optic_Holosight_blk_F", "optic_Holosight_smg_blk_F"], 25],
            ["Rifle Scope Kit", ["optic_MRCO", "optic_Hamr", "ACE_optic_MRCO_2D", "ACE_optic_Hamr_2D", "optic_Arco_blk_F", "optic_ERCO_blk_F","optic_Hamr", "ACE_optic_Hamr_2D", "optic_Hamr_sand_lxWS", "optic_Hamr_snake_lxWS", "optic_ERCO_blk_F", "optic_ERCO_snd_F"], 50],
            ["Sniper Scope Kit", ["optic_DMS", "optic_SOS", "optic_LRPS", "ACE_optic_SOS_2D", "ACE_optic_LRPS_2D", "optic_KHS_blk", "optic_AMS"], 75],
            ["Special Scopes Kit", ["optic_Nightstalker", "optic_NVS", "optic_tws", "optic_tws_mg"], 250]
        ]
    ],
    [
        "Expolsives",
        [
            ["Mines Kit", ["ClaymoreDirectionalMine_Remote_Mag", "SLAMDirectionalMine_Wire_Mag", "APERSTripMine_Wire_Mag", "ACE_FlareTripMine_Mag","ACE_FlareTripMine_Mag_Green", "ACE_FlareTripMine_Mag_Red","APERSMine_Range_Mag","ACE_APERSMine_ToePopper_Mag","APERSMineDispenser_Mag"], 100]
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