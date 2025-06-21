// Adding your own infantry parameter is possible, ensure the following steps
// Add a new array below, such as RB_EnemyInfantryPool_MyGroup = ["O_G_Soldier_F"];
// Then go to the init.sqf and find the label     // --- Enemy Infantry Pools --- or     // --- Enemy Vehicle Pools ---
// Add a new switch case to the list below the highest number case, and above default. Such as case 55: { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_MyGroup }; (Make sure the numbers are in order from low to high, and do not skip any.)
// Then go to description.ext, and find class RB_EnemyFaction or class RB_EnemyVehiclePool {
// Under values[] = {0, 1, ...etc}; add the number you assigned to your switch case in the init.sqf
// Under texts[] = {"Vanilla FIA Insurgents", "....etc..}; add the name you want in your parameters.
// Your own faction should now appear, alternatively you can use the RB_EnemyInfantryPool_Custom, and RB_EnemyVehiclePool_Custom add your own in there, and set them by parameters.


// === Enemy Infantry Pools ===
RB_EnemyInfantryPool_Vanilla_FIA = [
    "O_G_Soldier_F", "O_G_Soldier_AR_F", "O_G_Soldier_LAT_F", "O_G_medic_F", "O_G_engineer_F",
    "O_G_Soldier_SL_F", "O_G_Soldier_TL_F", "O_G_Sharpshooter_F", "O_G_Soldier_GL_F", "O_G_Soldier_lite_F",
    "O_G_Soldier_exp_F"
];

RB_EnemyInfantryPool_Vanilla_Looters = [
    "I_L_Criminal_SG_F", "I_L_Criminal_SMG_F", "I_L_Hunter_F", "I_L_Looter_Rifle_F", "I_L_Looter_Pistol_F",
    "I_L_Looter_SG_F", "I_L_Looter_SMG_F"
];


RB_EnemyInfantryPool_Vanilla_SyndikatBandits = [
    "I_C_Soldier_Bandit_7_F", "I_C_Soldier_Bandit_3_F", "I_C_Soldier_Bandit_2_F", "I_C_Soldier_Bandit_5_F", "I_C_Soldier_Bandit_6_F",
    "I_C_Soldier_Bandit_1_F", "I_C_Soldier_Bandit_8_F", "I_C_Soldier_Bandit_4_F"
];


RB_EnemyInfantryPool_Vanilla_SyndikatParaMilitary = [
    "I_C_Soldier_Para_7_F", "I_C_Soldier_Para_2_F", "I_C_Soldier_Para_3_F", "I_C_Soldier_Para_4_F", "I_C_Soldier_Para_6_F", "I_C_Soldier_Para_8_F", "I_C_Soldier_Para_1_F", "I_C_Soldier_Para_5_F"
];


RB_EnemyInfantryPool_Vanilla_CSAT = [
    "O_Soldier_A_F", "O_Soldier_AAR_F", "O_support_AMG_F", "O_support_AMort_F", "O_Soldier_AHAT_F",
    "O_engineer_F", "O_Soldier_AAA_F", "O_Soldier_AAT_F", "O_Soldier_AR_F", "O_medic_F",
    "O_support_MG_F", "O_support_Mort_F", "O_HeavyGunner_F", "O_soldier_M_F", "O_Soldier_AA_F",
    "O_Soldier_AT_F", "O_officer_F", "O_soldier_PG_F", "O_soldier_repair_F", "O_Soldier_F",
    "O_Sharpshooter_F", "O_Soldier_SL_F", "O_soldier_exp_F", "O_Soldier_GL_F", "O_soldier_UAV_06_F",
    "O_support_GMG_F", "O_soldier_mine_F", "O_Soldier_HAT_F", "O_Soldier_TL_F", "O_soldier_UAV_F",
    "O_Soldier_LAT_F"
];


RB_EnemyInfantryPool_Vanilla_Spetsnaz = [
    "O_R_Soldier_AR_F", "O_R_medic_F", "O_R_soldier_exp_F", "O_R_Soldier_GL_F", "O_R_Soldier_LAT_F",
    "O_R_Patrol_Soldier_AR2_F", "O_R_Patrol_Soldier_AR_F", "O_R_Patrol_Soldier_M2_F", "O_R_Patrol_Soldier_LAT_F", "O_R_Patrol_Soldier_M_F",
    "O_R_Patrol_Soldier_TL_F", "O_R_JTAC_F", "O_R_Patrol_Soldier_Medic", "O_R_Patrol_Soldier_Engineer_F", "O_R_soldier_M_F",
    "O_R_Patrol_Soldier_A_F"
];

RB_EnemyInfantryPool_CDLC_WSTura = [
"O_Tura_defector_lxWS", 
"O_Tura_deserter_lxWS", 
"O_Tura_enforcer_lxWS", 
"O_Tura_hireling_lxWS", 
"O_Tura_HeavyGunner_lxWS", 
"O_Tura_medic2_lxWS", 
"O_Tura_watcher_lxWS", 
"O_Tura_thug_lxWS", 
"O_Tura_soldier_UAV_lxWS"
];
RB_EnemyInfantryPool_CDLC_WSSFIA = [
"O_SFIA_Soldier_AAA_lxWS", 
"O_SFIA_Soldier_AAT_lxWS", 
"O_SFIA_Soldier_AR_lxWS", 
"O_SFIA_medic_lxWS", 
"O_SFIA_crew_lxWS", 
"O_SFIA_exp_lxWS", 
"O_SFIA_Soldier_GL_lxWS", 
"O_SFIA_HeavyGunner_lxWS", 
"O_SFIA_soldier_aa_lxWS", 
"O_SFIA_sharpshooter_lxWS", 
"O_SFIA_Soldier_TL_lxWS", 
"O_SFIA_soldier_at_lxWS", 
"O_SFIA_repair_lxWS", 
"O_SFIA_soldier_lxWS", 
"O_SFIA_soldier_lite_lxWS"
];
RB_EnemyInfantryPool_RHSGREF_CHDKZ = [
"rhsgref_ins_grenadier_rpg", 
"rhsgref_ins_arifleman_rpk", 
"rhsgref_ins_machinegunner", 
"rhsgref_ins_medic", 
"rhsgref_ins_militiaman_mosin", 
"rhsgref_ins_rifleman", 
"rhsgref_ins_rifleman_akm", 
"rhsgref_ins_rifleman_aks74", 
"rhsgref_ins_rifleman_aksu", 
"rhsgref_ins_grenadier", 
"rhsgref_ins_rifleman_RPG26", 
"rhsgref_ins_engineer", 
"rhsgref_ins_spotter", 
"rhsgref_ins_sniper"
];
RB_EnemyInfantryPool_RHSGREF_NAPA = [
"rhsgref_nat_grenadier_rpg", 
"rhsgref_nat_commander", 
"rhsgref_nat_hunter", 
"rhsgref_nat_machinegunner", 
"rhsgref_nat_machinegunner_mg42", 
"rhsgref_nat_medic", 
"rhsgref_nat_rifleman_akms", 
"rhsgref_nat_rifleman_aks74", 
"rhsgref_nat_militiaman_kar98k", 
"rhsgref_nat_grenadier", 
"rhsgref_nat_rifleman_mp44", 
"rhsgref_nat_rifleman_vz58"
];

// === Enemy Vehicle Pools ===
RB_EnemyVehiclePool_Vanilla = [
    "O_G_Offroad_01_F",
    "O_G_Offroad_01_armed_F",
    "O_G_Offroad_01_AT_F"
];

RB_EnemyVehiclePool_WS = [
"O_SFIA_Offroad_lxWS", 
"O_SFIA_Offroad_AT_lxWS", 
"O_SFIA_Offroad_armed_lxWS", 
"O_Tura_Offroad_armor_lxWS", 
"O_Tura_Offroad_armor_AT_lxWS", 
"O_Tura_Offroad_armor_armed_lxWS"
];


RB_EnemyVehiclePool_CUP = [
    "UK3CB_TKM_O_UAZ_MG",
    "UK3CB_TKM_O_Hilux_Dshkm"
];

RB_EnemyVehiclePool_3CB = [
    "UK3CB_TKM_O_UAZ_MG",
    "UK3CB_TKM_O_Hilux_Dshkm"
];

RB_EnemyVehiclePool_SOG = [
    "vn_o_Truck_01_mg_01",
    "vn_o_wheeled_btr40_mg_01"
];

RB_EnemyVehiclePool_RHSGREF_CHDKZ = [
"rhsgref_ins_gaz66", 
"rhsgref_ins_gaz66o", 
"rhsgref_ins_gaz66_zu23", 
"rhsgref_ins_kraz255b1_cargo_open", 
"rhsgref_ins_ural", 
"rhsgref_ins_ural_open", 
"rhsgref_ins_ural_Zu23", 
"rhsgref_ins_zil131", 
"rhsgref_ins_zil131_flatbed", 
"rhsgref_ins_zil131_open", 
"rhsgref_BRDM2_ins", 
"rhsgref_BRDM2_HQ_ins", 
"rhsgref_BRDM2_ATGM_ins", 
"rhsgref_ins_uaz_open", 
"rhsgref_ins_uaz_spg9", 
"rhsgref_ins_btr60", 
"rhsgref_ins_uaz", 
"rhsgref_ins_uaz_ags", 
"rhsgref_ins_uaz_dshkm", 
"rhsgref_ins_btr70"
];
// Adding your own infantry parameter is possible, ensure the following steps
// Add a new array below, such as RB_EnemyInfantryPool_MyGroup = ["O_G_Soldier_F"];
// Then go to the init.sqf and find the label     // --- Enemy Infantry Pools --- or     // --- Enemy Vehicle Pools ---
// Add a new switch case to the list below the highest number case, and above default. Such as case 55: { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_MyGroup }; (Make sure the numbers are in order from low to high, and do not skip any.)
// Then go to description.ext, and find class RB_EnemyFaction or class RB_EnemyVehiclePool {
// Under values[] = {0, 1, ...etc}; add the number you assigned to your switch case in the init.sqf
// Under texts[] = {"Vanilla FIA Insurgents", "....etc..}; add the name you want in your parameters.
// Your own faction should now appear, alternatively you can use the RB_EnemyInfantryPool_Custom, and RB_EnemyVehiclePool_Custom add your own in there, and set them by parameters.


// === Enemy Infantry Pools ===
RB_EnemyInfantryPool_Vanilla_FIA = [
    "O_G_Soldier_F", "O_G_Soldier_AR_F", "O_G_Soldier_LAT_F", "O_G_medic_F", "O_G_engineer_F",
    "O_G_Soldier_SL_F", "O_G_Soldier_TL_F", "O_G_Sharpshooter_F", "O_G_Soldier_GL_F", "O_G_Soldier_lite_F",
    "O_G_Soldier_exp_F"
];

RB_EnemyInfantryPool_Vanilla_Looters = [
    "I_L_Criminal_SG_F", "I_L_Criminal_SMG_F", "I_L_Hunter_F", "I_L_Looter_Rifle_F", "I_L_Looter_Pistol_F",
    "I_L_Looter_SG_F", "I_L_Looter_SMG_F"
];


RB_EnemyInfantryPool_Vanilla_SyndikatBandits = [
    "I_C_Soldier_Bandit_7_F", "I_C_Soldier_Bandit_3_F", "I_C_Soldier_Bandit_2_F", "I_C_Soldier_Bandit_5_F", "I_C_Soldier_Bandit_6_F",
    "I_C_Soldier_Bandit_1_F", "I_C_Soldier_Bandit_8_F", "I_C_Soldier_Bandit_4_F"
];


RB_EnemyInfantryPool_Vanilla_SyndikatParaMilitary = [
    "I_C_Soldier_Para_7_F", "I_C_Soldier_Para_2_F", "I_C_Soldier_Para_3_F", "I_C_Soldier_Para_4_F", "I_C_Soldier_Para_6_F", "I_C_Soldier_Para_8_F", "I_C_Soldier_Para_1_F", "I_C_Soldier_Para_5_F"
];


RB_EnemyInfantryPool_Vanilla_CSAT = [
    "O_Soldier_A_F", "O_Soldier_AAR_F", "O_support_AMG_F", "O_support_AMort_F", "O_Soldier_AHAT_F",
    "O_engineer_F", "O_Soldier_AAA_F", "O_Soldier_AAT_F", "O_Soldier_AR_F", "O_medic_F",
    "O_support_MG_F", "O_support_Mort_F", "O_HeavyGunner_F", "O_soldier_M_F", "O_Soldier_AA_F",
    "O_Soldier_AT_F", "O_officer_F", "O_soldier_PG_F", "O_soldier_repair_F", "O_Soldier_F",
    "O_Sharpshooter_F", "O_Soldier_SL_F", "O_soldier_exp_F", "O_Soldier_GL_F", "O_soldier_UAV_06_F",
    "O_support_GMG_F", "O_soldier_mine_F", "O_Soldier_HAT_F", "O_Soldier_TL_F", "O_soldier_UAV_F",
    "O_Soldier_LAT_F"
];
RB_EnemyInfantryPool_Vanilla_AAF = [
"I_Soldier_A_F", "I_Soldier_AAR_F", "I_Soldier_AR_F", "I_medic_F", "I_engineer_F", "I_Soldier_exp_F", 
"I_Soldier_GL_F", "I_soldier_F", "I_Soldier_LAT_F", "I_Soldier_LAT2_F", "I_Soldier_lite_F", "I_Soldier_SL_F", 
"I_Soldier_TL_F", "I_Soldier_M_F", "I_soldier_mine_F", "I_Soldier_AT_F", "I_Soldier_AA_F"
];

RB_EnemyInfantryPool_Contact_LDF = [
"I_Soldier_A_F", "I_Soldier_AAR_F", "I_Soldier_AR_F", "I_medic_F", "I_engineer_F", "I_Soldier_exp_F", 
"I_Soldier_GL_F", "I_soldier_F", "I_Soldier_LAT_F", "I_Soldier_LAT2_F", "I_Soldier_lite_F", "I_Soldier_SL_F", 
"I_Soldier_TL_F", "I_Soldier_M_F", "I_soldier_mine_F", "I_Soldier_AT_F", "I_Soldier_AA_F"
];

RB_EnemyInfantryPool_Contact_Spetsnaz = [
    "O_R_Soldier_AR_F", "O_R_medic_F", "O_R_soldier_exp_F", "O_R_Soldier_GL_F", "O_R_Soldier_LAT_F",
    "O_R_Patrol_Soldier_AR2_F", "O_R_Patrol_Soldier_AR_F", "O_R_Patrol_Soldier_M2_F", "O_R_Patrol_Soldier_LAT_F", "O_R_Patrol_Soldier_M_F",
    "O_R_Patrol_Soldier_TL_F", "O_R_JTAC_F", "O_R_Patrol_Soldier_Medic", "O_R_Patrol_Soldier_Engineer_F", "O_R_soldier_M_F",
    "O_R_Patrol_Soldier_A_F"
];
RB_EnemyInfantryPool_CDLC_WSTura = [
"O_Tura_defector_lxWS", "O_Tura_deserter_lxWS", "O_Tura_enforcer_lxWS", "O_Tura_hireling_lxWS", "O_Tura_HeavyGunner_lxWS", 
"O_Tura_medic2_lxWS", "O_Tura_watcher_lxWS", "O_Tura_thug_lxWS", "O_Tura_soldier_UAV_lxWS"
];

RB_EnemyInfantryPool_CDLC_WSSFIA = [
"O_SFIA_Soldier_AAA_lxWS", "O_SFIA_Soldier_AAT_lxWS", "O_SFIA_Soldier_AR_lxWS", "O_SFIA_medic_lxWS", "O_SFIA_crew_lxWS", "O_SFIA_exp_lxWS", "O_SFIA_Soldier_GL_lxWS", 
"O_SFIA_HeavyGunner_lxWS", "O_SFIA_soldier_aa_lxWS", "O_SFIA_sharpshooter_lxWS", "O_SFIA_Soldier_TL_lxWS", "O_SFIA_soldier_at_lxWS", "O_SFIA_repair_lxWS", "O_SFIA_soldier_lxWS", 
"O_SFIA_soldier_lite_lxWS"
];

RB_EnemyInfantryPool_RHSGREF_CHDKZ = [
"rhsgref_ins_grenadier_rpg", 
"rhsgref_ins_arifleman_rpk", 
"rhsgref_ins_machinegunner", 
"rhsgref_ins_medic", 
"rhsgref_ins_militiaman_mosin", 
"rhsgref_ins_rifleman", 
"rhsgref_ins_rifleman_akm", 
"rhsgref_ins_rifleman_aks74", 
"rhsgref_ins_rifleman_aksu", 
"rhsgref_ins_grenadier", 
"rhsgref_ins_rifleman_RPG26", 
"rhsgref_ins_engineer", 
"rhsgref_ins_spotter", 
"rhsgref_ins_sniper"
];
RB_EnemyInfantryPool_RHSGREF_NAPA = [
"rhsgref_nat_grenadier_rpg", 
"rhsgref_nat_commander", 
"rhsgref_nat_hunter", 
"rhsgref_nat_machinegunner", 
"rhsgref_nat_machinegunner_mg42", 
"rhsgref_nat_medic", 
"rhsgref_nat_rifleman_akms", 
"rhsgref_nat_rifleman_aks74", 
"rhsgref_nat_militiaman_kar98k", 
"rhsgref_nat_grenadier", 
"rhsgref_nat_rifleman_mp44", 
"rhsgref_nat_rifleman_vz58"
];

// === Enemy Vehicle Pools ===
RB_EnemyVehiclePool_Vanilla = [
    "O_G_Offroad_01_F",
    "O_G_Offroad_01_armed_F",
    "O_G_Offroad_01_AT_F"
];

RB_EnemyVehiclePool_WS = [
"O_SFIA_Offroad_lxWS", 
"O_SFIA_Offroad_AT_lxWS", 
"O_SFIA_Offroad_armed_lxWS", 
"O_Tura_Offroad_armor_lxWS", 
"O_Tura_Offroad_armor_AT_lxWS", 
"O_Tura_Offroad_armor_armed_lxWS"
];


RB_EnemyVehiclePool_CUP = [
    "UK3CB_TKM_O_UAZ_MG",
    "UK3CB_TKM_O_Hilux_Dshkm"
];

RB_EnemyVehiclePool_3CB = [
    "UK3CB_TKM_O_UAZ_MG",
    "UK3CB_TKM_O_Hilux_Dshkm"
];

RB_EnemyVehiclePool_SOG = [
    "vn_o_Truck_01_mg_01",
    "vn_o_wheeled_btr40_mg_01"
];

RB_EnemyVehiclePool_RHSGREF_CHDKZ = [
"rhsgref_ins_gaz66", 
"rhsgref_ins_gaz66o", 
"rhsgref_ins_gaz66_zu23", 
"rhsgref_ins_kraz255b1_cargo_open", 
"rhsgref_ins_ural", 
"rhsgref_ins_ural_open", 
"rhsgref_ins_ural_Zu23", 
"rhsgref_ins_zil131", 
"rhsgref_ins_zil131_flatbed", 
"rhsgref_ins_zil131_open", 
"rhsgref_BRDM2_ins", 
"rhsgref_BRDM2_HQ_ins", 
"rhsgref_BRDM2_ATGM_ins", 
"rhsgref_ins_uaz_open", 
"rhsgref_ins_uaz_spg9", 
"rhsgref_ins_btr60", 
"rhsgref_ins_uaz", 
"rhsgref_ins_uaz_ags", 
"rhsgref_ins_uaz_dshkm", 
"rhsgref_ins_btr70"
];

RB_EnemyVehiclePool_RHSGREF_NAPA = [
"rhsgref_nat_van", 
"rhsgref_nat_btr70", 
"rhsgref_nat_uaz", 
"rhsgref_nat_uaz_ags", 
"rhsgref_nat_uaz_dshkm", 
"rhsgref_nat_uaz_open", 
"rhsgref_nat_uaz_spg9", 
"rhsgref_nat_ural", 
"rhsgref_nat_ural_open", 
"rhsgref_nat_ural_work", 
"rhsgref_nat_ural_work_open", 
"rhsgref_nat_ural_Zu23"
];
