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

RB_EnemyInfantryPool_SOGPF_VC = [
"vn_o_men_vc_local_14", "vn_o_men_vc_local_28", "vn_o_men_vc_local_07", "vn_o_men_vc_local_25", "vn_o_men_vc_local_16", 
"vn_o_men_vc_local_21", "vn_o_men_vc_local_11", "vn_o_men_vc_local_32", "vn_o_men_vc_local_10", "vn_o_men_vc_local_24", 
"vn_o_men_vc_local_08", "vn_o_men_vc_local_02", "vn_o_men_vc_local_20", "vn_o_men_vc_local_22", "vn_o_men_vc_local_01", 
"vn_o_men_vc_local_06", "vn_o_men_vc_local_04", "vn_o_men_vc_local_03", "vn_o_men_vc_local_17", "vn_o_men_vc_local_05", 
"vn_o_men_vc_local_19", "vn_o_men_vc_local_30", "vn_o_men_vc_local_18", "vn_o_men_vc_local_13", "vn_o_men_vc_local_09", 
"vn_o_men_vc_local_26", "vn_o_men_vc_local_27", "vn_o_men_vc_local_23", "vn_o_men_vc_local_12"
];

RB_EnemyInfantryPool_3CB_TI = ["UK3CB_TKM_O_AA", 
"UK3CB_TKM_O_AT", "UK3CB_TKM_O_AR", "UK3CB_TKM_O_DEM", "UK3CB_TKM_O_IED", "UK3CB_TKM_O_ENG", "UK3CB_TKM_O_GL", 
"UK3CB_TKM_O_LAT", "UK3CB_TKM_O_LMG", "UK3CB_TKM_O_MK", "UK3CB_TKM_O_MD", "UK3CB_TKM_O_RIF_1", "UK3CB_TKM_O_RIF_2", 
"UK3CB_TKM_O_TL", "UK3CB_TKM_O_WAR", "UK3CB_TKM_O_MG", "UK3CB_TKM_O_MG_ASST", "UK3CB_TKM_O_RIF_3", "UK3CB_TKM_O_SL", 
"UK3CB_TKM_O_SNI", "UK3CB_TKM_O_SPOT"];

RB_EnemyInfantryPool_3CB_MEI = [
"UK3CB_MEI_O_AA", "UK3CB_MEI_O_AT", "UK3CB_MEI_O_AR_01", "UK3CB_MEI_O_AR_02", "UK3CB_MEI_O_DEM", "UK3CB_MEI_O_ENG", "UK3CB_MEI_O_GL", 
"UK3CB_MEI_O_IED", "UK3CB_MEI_O_LAT", "UK3CB_MEI_O_MK", "UK3CB_MEI_O_MD", "UK3CB_MEI_O_LMG", "UK3CB_MEI_O_MG_ASST", "UK3CB_MEI_O_SPOT", 
"UK3CB_MEI_O_TL", "UK3CB_MEI_O_WAR", "UK3CB_MEI_O_RIF_6", "UK3CB_MEI_O_RIF_5", "UK3CB_MEI_O_RIF_10", "UK3CB_MEI_O_SL", "UK3CB_MEI_O_RIF_11", 
"UK3CB_MEI_O_RIF_12", "UK3CB_MEI_O_SNI"
];

RB_EnemyInfantryPool_3CB_MEE = [
    "UK3CB_MEE_O_AA", "UK3CB_MEE_O_AT", "UK3CB_MEE_O_DEM", "UK3CB_MEE_O_ENG", "UK3CB_MEE_O_GL", "UK3CB_MEE_O_IED", 
"UK3CB_MEE_O_LAT", "UK3CB_MEE_O_RIF_3", "UK3CB_MEE_O_RIF_2", "UK3CB_MEE_O_LMG", "UK3CB_MEE_O_RIF_1", "UK3CB_MEE_O_SNI", 
"UK3CB_MEE_O_MG", "UK3CB_MEE_O_MG_ASST", "UK3CB_MEE_O_MK", "UK3CB_MEE_O_SPOT", "UK3CB_MEE_O_MD", "UK3CB_MEE_O_SL", "UK3CB_MEE_O_TL"
];

RB_EnemyInfantryPool_3CB_MDF = [
"UK3CB_MDF_O_AA", "UK3CB_MDF_O_AT", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_GL", "UK3CB_MDF_O_HMG", 
"UK3CB_MDF_O_LAT", "UK3CB_MDF_O_MG", "UK3CB_MDF_O_MG_ASST", "UK3CB_MDF_O_MK", "UK3CB_MDF_O_RIF_1", 
"UK3CB_MDF_O_SL", "UK3CB_MDF_O_TL", "UK3CB_MDF_O_DEM", "UK3CB_MDF_O_ENG", "UK3CB_MDF_O_HMG_ASST", 
"UK3CB_MDF_O_JNR_OFF", "UK3CB_MDF_O_SNI", "UK3CB_MDF_O_SPOT", "UK3CB_MDF_O_MD"
];

RB_EnemyInfantryPool_3CB_LSM = [
"UK3CB_LSM_O_AA", "UK3CB_LSM_O_AT", "UK3CB_LSM_O_AT_ASST", "UK3CB_LSM_O_AR", "UK3CB_LSM_O_LAT", "UK3CB_LSM_O_OFF", "UK3CB_LSM_O_DEM", "UK3CB_LSM_O_ENG", 
"UK3CB_LSM_O_GL", "UK3CB_LSM_O_MG", "UK3CB_LSM_O_MG_ASST", "UK3CB_LSM_O_RIF_1", "UK3CB_LSM_O_RIF_4", "UK3CB_LSM_O_TL", "UK3CB_LSM_O_MK", "UK3CB_LSM_O_MD", 
"UK3CB_LSM_O_RIF_3", "UK3CB_LSM_O_RIF_5", "UK3CB_LSM_O_SNI"
];

RB_EnemyInfantryPool_3CB_LNM = [
"UK3CB_LNM_O_AA", "UK3CB_LNM_O_AT", "UK3CB_LNM_O_AT_ASST", "UK3CB_LNM_O_AR", "UK3CB_LNM_O_OFF", "UK3CB_LNM_O_TL", 
"UK3CB_LNM_O_DEM", "UK3CB_LNM_O_ENG", "UK3CB_LNM_O_GL", "UK3CB_LNM_O_LAT", "UK3CB_LNM_O_LMG", "UK3CB_LNM_O_MG", "UK3CB_LNM_O_SEN_4", "UK3CB_LNM_O_MG_ASST", "UK3CB_LNM_O_SEN_2", "UK3CB_LNM_O_SNI", "UK3CB_LNM_O_RIF_1", "UK3CB_LNM_O_SEN_3", "UK3CB_LNM_O_RIF_2"
];

RB_EnemyInfantryPool_3CB_FIA = [
"UK3CB_FIA_O_AA", "UK3CB_FIA_O_AA_1", "UK3CB_FIA_O_AA_ASST", "UK3CB_FIA_O_AA_ASST_1", "UK3CB_FIA_O_DEM", "UK3CB_FIA_O_ENG", "UK3CB_FIA_O_GL", "UK3CB_FIA_O_AT", "UK3CB_FIA_O_AT_1", "UK3CB_FIA_O_GL_1", "UK3CB_FIA_O_HMG", 
"UK3CB_FIA_O_JNR_OFF", "UK3CB_FIA_O_LAT", "UK3CB_FIA_O_RIF_2", "UK3CB_FIA_O_HMG_ASST", "UK3CB_FIA_O_MG_1", "UK3CB_FIA_O_MG", "UK3CB_FIA_O_MG_ASST", "UK3CB_FIA_O_MK_1", "UK3CB_FIA_O_MD", "UK3CB_FIA_O_RIF_1", 
"UK3CB_FIA_O_RIF_8", "UK3CB_FIA_O_RIF_4", "UK3CB_FIA_O_RIF_7", "UK3CB_FIA_O_RIF_6", "UK3CB_FIA_O_SL", "UK3CB_FIA_O_SNI", "UK3CB_FIA_O_TL", "UK3CB_FIA_O_SPOT"
];

RB_EnemyInfantryPool_3CB_ADM = [
"UK3CB_ADM_O_AA", "UK3CB_ADM_O_AT", "UK3CB_ADM_O_AR", "UK3CB_ADM_O_DEM", "UK3CB_ADM_O_IED", "UK3CB_ADM_O_ENG", "UK3CB_ADM_O_GL", "UK3CB_ADM_O_LAT", 
"UK3CB_ADM_O_LMG", "UK3CB_ADM_O_MG", "UK3CB_ADM_O_MG_ASST", "UK3CB_ADM_O_RIF_3", "UK3CB_ADM_O_RIF_2", "UK3CB_ADM_O_SL", "UK3CB_ADM_O_SNI", "UK3CB_ADM_O_SPOT", "UK3CB_ADM_O_TL", "UK3CB_ADM_O_WAR"
];

RB_EnemyInfantryPool_3CB_ADE = [
"UK3CB_ADE_O_AA", "UK3CB_ADE_O_AT_ASST", "UK3CB_ADE_O_AR", "UK3CB_ADE_O_DEM", "UK3CB_ADE_O_ENG", "UK3CB_ADE_O_GL", "UK3CB_ADE_O_IED", "UK3CB_ADE_O_LAT", "UK3CB_ADE_O_LMG", "UK3CB_ADE_O_MG", "UK3CB_ADE_O_MG_ASST", "UK3CB_ADE_O_MK", "UK3CB_ADE_O_TL", 
"UK3CB_ADE_O_WAR", "UK3CB_ADE_O_AT", "UK3CB_ADE_O_RIF_3", "UK3CB_ADE_O_RIF_2", "UK3CB_ADE_O_SL", "UK3CB_ADE_O_SNI"
];

RB_EnemyInfantryPool_3CB_ADCM = [
"UK3CB_ADG_O_AT_ISL", "UK3CB_ADG_O_AT_ASST_ISL", "UK3CB_ADG_O_AR_ISL", "UK3CB_ADG_O_DEM_ISL", "UK3CB_ADG_O_GL_ISL", "UK3CB_ADG_O_MG_ISL", "UK3CB_ADG_O_ENG_ISL", "UK3CB_ADG_O_LMG_ISL", "UK3CB_ADG_O_MG_ASST_ISL", "UK3CB_ADG_O_SL_ISL", "UK3CB_ADG_O_TL_ISL", "UK3CB_ADG_O_AT_ASST", "UK3CB_ADG_O_MK_ISL", "UK3CB_ADG_O_MD_ISL", "UK3CB_ADG_O_RIF_2_ISL", 
"UK3CB_ADG_O_AT", "UK3CB_ADG_O_LMG", "UK3CB_ADG_O_MG", "UK3CB_ADG_O_MK", "UK3CB_ADG_O_MD", "UK3CB_ADG_O_SL", "UK3CB_ADG_O_AR", "UK3CB_ADG_O_DEM", "UK3CB_ADG_O_MG_ASST", "UK3CB_ADG_O_RIF_2", "UK3CB_ADG_O_TL"
];

// === Enemy Vehicle Pools ===
RB_EnemyVehiclePool_Vanilla = [
    "O_G_Offroad_01_F",
    "O_G_Offroad_01_armed_F",
    "O_G_Offroad_01_AT_F"
];

RB_EnemyVehiclePool_WS = [
"O_SFIA_Offroad_lxWS", "O_SFIA_Offroad_AT_lxWS", "O_SFIA_Offroad_armed_lxWS", 
"O_Tura_Offroad_armor_lxWS", "O_Tura_Offroad_armor_AT_lxWS", "O_Tura_Offroad_armor_armed_lxWS"
];


RB_EnemyVehiclePool_CUP_TM = [
"CUP_O_Hilux_AGS30_TK_INS", "CUP_O_Hilux_BMP1_TK_INS", "CUP_O_Hilux_btr60_TK_INS", "CUP_O_Hilux_DSHKM_TK_INS", 
"CUP_O_Hilux_M2_TK_INS", "CUP_O_Hilux_MLRS_TK_INS", "CUP_O_Hilux_UB32_TK_INS", "CUP_O_Hilux_zu23_TK_INS", 
"CUP_O_Hilux_armored_BMP1_TK_INS", "CUP_O_Hilux_armored_MLRS_TK_INS", "CUP_O_Hilux_metis_TK_INS", "CUP_O_Hilux_armored_AGS30_TK_INS", 
"CUP_O_Hilux_armored_BTR60_TK_INS", "CUP_O_Hilux_podnos_TK_INS", "CUP_O_Hilux_armored_M2_TK_INS", "CUP_O_Hilux_armored_metis_TK_INS", 
"CUP_O_Hilux_armored_podnos_TK_INS", "CUP_O_Hilux_armored_SPG9_TK_INS", "CUP_O_Hilux_armored_UB32_TK_INS", "CUP_O_Hilux_armored_zu23_TK_INS", 
"CUP_O_LR_SPG9_TKM", "CUP_O_Hilux_armored_unarmed_TK_INS"
];

RB_EnemyVehiclePool_CUP_CMORS = [
"CUP_O_Datsun_PK", "CUP_O_Datsun_PK_Random", "CUP_O_Datsun_4seat", "CUP_O_Tigr_233014_PK_CHDKZ", 
"CUP_O_Hilux_AGS30_CHDKZ", "CUP_O_Hilux_metis_CHDKZ", "CUP_O_Hilux_podnos_CHDKZ", "CUP_O_UAZ_AGS30_CHDKZ", 
"CUP_O_UAZ_MG_CHDKZ", "CUP_O_UAZ_METIS_CHDKZ", "CUP_O_UAZ_Open_CHDKZ", "CUP_O_Hilux_DSHKM_CHDKZ", "CUP_O_UAZ_SPG9_CHDKZ"
];

RB_EnemyVehiclePool_SOGPF_VC = [
"vn_o_wheeled_btr40_mg_02_vcmf", "vn_o_wheeled_btr40_mg_01_vcmf", "vn_o_wheeled_btr40_mg_04_vcmf", "vn_o_wheeled_btr40_mg_06_vcmf", 
"vn_o_wheeled_btr40_mg_05_vcmf", "vn_o_wheeled_btr40_mg_03_vcmf", "vn_o_wheeled_btr40_01_vcmf", "vn_o_car_04_mg_01", 
"vn_o_wheeled_z157_mg_01_vcmf", "vn_o_wheeled_z157_mg_02_vcmf"
];

RB_EnemyVehiclePool_RHSGREF_CHDKZ = [
"rhsgref_ins_gaz66", "rhsgref_ins_gaz66o", "rhsgref_ins_gaz66_zu23", "rhsgref_ins_kraz255b1_cargo_open", 
"rhsgref_ins_ural", "rhsgref_ins_ural_open", "rhsgref_ins_ural_Zu23", "rhsgref_ins_zil131", 
"rhsgref_ins_zil131_flatbed", "rhsgref_ins_zil131_open", "rhsgref_BRDM2_ins", "rhsgref_BRDM2_HQ_ins", 
"rhsgref_BRDM2_ATGM_ins", "rhsgref_ins_uaz_open", "rhsgref_ins_uaz_spg9", "rhsgref_ins_btr60", 
"rhsgref_ins_uaz", "rhsgref_ins_uaz_ags", "rhsgref_ins_uaz_dshkm", "rhsgref_ins_btr70"
];
RB_EnemyVehiclePool_RHSGREF_NAPA = [
"rhsgref_nat_van", "rhsgref_nat_btr70", "rhsgref_nat_uaz", "rhsgref_nat_uaz_ags", 
"rhsgref_nat_uaz_dshkm", "rhsgref_nat_uaz_open", "rhsgref_nat_uaz_spg9", "rhsgref_nat_ural", 
"rhsgref_nat_ural_open", "rhsgref_nat_ural_work", "rhsgref_nat_ural_work_open", "rhsgref_nat_ural_Zu23"
];

RB_EnemyVehiclePool_3CB_TI = [
"UK3CB_TKM_O_Datsun_Open", "UK3CB_TKM_O_Datsun_Pkm", "UK3CB_TKM_O_Hilux_GMG", "UK3CB_TKM_O_Hilux_Rocket_Arty", 
"UK3CB_TKM_O_Hilux_Dshkm", "UK3CB_TKM_O_Hilux_M2", "UK3CB_TKM_O_Hilux_Mortar", "UK3CB_TKM_O_Hilux_Open", 
"UK3CB_TKM_O_Hilux_Pkm", "UK3CB_TKM_O_Hilux_Rocket", "UK3CB_TKM_O_Hilux_Spg9", "UK3CB_TKM_O_Hilux_Zu23_Front", 
"UK3CB_TKM_O_Hilux_Zu23", "UK3CB_TKM_O_LR_Closed", "UK3CB_TKM_O_LR_AGS30", "UK3CB_TKM_O_LR_SPG9", 
"UK3CB_TKM_O_LR_SF_AGS30", "UK3CB_TKM_O_Pickup_M2", "UK3CB_TKM_O_UAZ_AGS30", "UK3CB_TKM_O_UAZ_Dshkm", 
"UK3CB_TKM_O_UAZ_Open", "UK3CB_TKM_O_LR_M2", "UK3CB_TKM_O_UAZ_Closed", "UK3CB_TKM_O_UAZ_SPG9"
];

RB_EnemyVehiclePool_3CB_MEI = [
"UK3CB_MEI_O_Datsun_Civ_Open", "UK3CB_MEI_O_Datsun_Open", "UK3CB_MEI_O_Hilux_GMG", "UK3CB_MEI_O_Hilux_BMP", 
"UK3CB_MEI_O_Hilux_BTR", "UK3CB_MEI_O_Hilux_Dshkm", "UK3CB_MEI_O_Hilux_Vulcan_Front", "UK3CB_MEI_O_Hilux_M2", 
"UK3CB_MEI_O_Hilux_Metis", "UK3CB_MEI_O_Hilux_Mortar", "UK3CB_MEI_O_Hilux_Open", "UK3CB_MEI_O_Hilux_Rocket", 
"UK3CB_MEI_O_Hilux_Zu23_Front", "UK3CB_MEI_O_LR_Closed", "UK3CB_MEI_O_Offroad", "UK3CB_MEI_O_Offroad_M2", 
"UK3CB_MEI_O_Datsun_Pkm", "UK3CB_MEI_O_Hilux_Rocket_Arty", "UK3CB_MEI_O_Hilux_Zu23", "UK3CB_MEI_O_LR_AGS30", 
"UK3CB_MEI_O_LR_Open", "UK3CB_MEI_O_LR_SPG9", "UK3CB_MEI_O_Pickup", "UK3CB_MEI_O_Pickup_DSHKM", "UK3CB_MEI_O_Pickup_M2"
];

RB_EnemyVehiclePool_3CB_MEE = [
"UK3CB_MEE_O_BRDM2", "UK3CB_MEE_O_BRDM2_HQ", "UK3CB_MEE_O_Datsun_Open", "UK3CB_MEE_O_Datsun_Pkm", 
"UK3CB_MEE_O_Hilux_GMG", "UK3CB_MEE_O_Hilux_Rocket_Arty", "UK3CB_MEE_O_Hilux_BMP", "UK3CB_MEE_O_Hilux_Dshkm", 
"UK3CB_MEE_O_Hilux_Vulcan_Front", "UK3CB_MEE_O_Hilux_Mortar", "UK3CB_MEE_O_Hilux_Open", "UK3CB_MEE_O_Hilux_Pkm", 
"UK3CB_MEE_O_LR_AGS30", "UK3CB_MEE_O_LR_M2", "UK3CB_MEE_O_LR_Open", "UK3CB_MEE_O_M1025_MK19", 
"UK3CB_MEE_O_M1025_M2", "UK3CB_MEE_O_M1025_TOW", "UK3CB_MEE_O_Offroad_AT", "UK3CB_MEE_O_Pickup_Rocket_Arty", 
"UK3CB_MEE_O_Pickup_DSHKM", "UK3CB_MEE_O_Pickup_Metis", "UK3CB_MEE_O_Hilux_BTR", "UK3CB_MEE_O_Hilux_M2", 
"UK3CB_MEE_O_Hilux_Metis", "UK3CB_MEE_O_Hilux_Spg9", "UK3CB_MEE_O_LR_Closed", "UK3CB_MEE_O_M1025_Unarmed", 
"UK3CB_MEE_O_M998_4DR", "UK3CB_MEE_O_Offroad_M2", "UK3CB_MEE_O_Pickup_GMG", "UK3CB_MEE_O_Pickup_Rocket", 
"UK3CB_MEE_O_Pickup_M2", "UK3CB_MEE_O_Pickup_SPG9", "UK3CB_MEE_O_Pickup_ZU23_Front", "UK3CB_MEE_O_Pickup_ZU23"
];

RB_EnemyVehiclePool_3CB_MDF = [
"UK3CB_MDF_O_MB4WD_Unarmed", "UK3CB_MDF_O_MB4WD_AT", "UK3CB_MDF_O_MB4WD_LMG", "UK3CB_MDF_O_M1025_MK19", 
"UK3CB_MDF_O_M1025_M2", "UK3CB_MDF_O_M1025_TOW", "UK3CB_MDF_O_M1151_GPK_M240", "UK3CB_MDF_O_M1151_OGPK_M240", 
"UK3CB_MDF_O_M1151_OGPK_MK19", "UK3CB_MDF_O_M998_4DR", "UK3CB_MDF_O_Offroad_HMG", "UK3CB_MDF_O_LSV_01_Light", 
"UK3CB_MDF_O_LSV_01", "UK3CB_MDF_O_LSV_02", "UK3CB_MDF_O_LSV_02_Armed", "UK3CB_MDF_O_LSV_02_AT", 
"UK3CB_MDF_O_M1151_GPK_M2", "UK3CB_MDF_O_M1151_GPK_MK19", "UK3CB_MDF_O_M1151_OGPK_M2", "UK3CB_MDF_O_SF_RIF_1"
];

RB_EnemyVehiclePool_3CB_LSM = [
"UK3CB_LSM_O_BRDM2", "UK3CB_LSM_O_BRDM2_ATGM", "UK3CB_LSM_O_BRDM2_HQ", "UK3CB_LSM_O_Datsun_Pkm", 
"UK3CB_LSM_O_Hilux_GMG", "UK3CB_LSM_O_Hilux_Rocket_Arty", "UK3CB_LSM_O_Hilux_Closed", "UK3CB_LSM_O_Hilux_Dshkm", 
"UK3CB_LSM_O_Hilux_M2", "UK3CB_LSM_O_Hilux_Metis", "UK3CB_LSM_O_Hilux_Open", "UK3CB_LSM_O_Hilux_Mortar", 
"UK3CB_LSM_O_Hilux_Zu23_Front", "UK3CB_LSM_O_Hilux_Zu23", "UK3CB_LSM_O_LR_M2", "UK3CB_LSM_O_Offroad_AT", 
"UK3CB_LSM_O_Pickup_Rocket_Arty", "UK3CB_LSM_O_Pickup_Metis", "UK3CB_LSM_O_Pickup_SPG9", "UK3CB_LSM_O_UAZ_AGS30"
];

RB_EnemyVehiclePool_3CB_LNM = [
"UK3CB_LNM_O_BRDM2", "UK3CB_LNM_O_BRDM2_ATGM", "UK3CB_LNM_O_Hilux_GMG", "UK3CB_LNM_O_Hilux_Rocket_Arty", 
"UK3CB_LNM_O_Hilux_Dshkm", "UK3CB_LNM_O_Hilux_Metis", "UK3CB_LNM_O_Hilux_Spg9", "UK3CB_LNM_O_LR_AGS30", 
"UK3CB_LNM_O_LR_SPG9", "UK3CB_LNM_O_Offroad_M2", "UK3CB_LNM_O_Pickup_ZU23_Front", "UK3CB_LNM_O_Pickup_ZU23", 
"UK3CB_LNM_O_UAZ_AGS30", "UK3CB_LNM_O_UAZ_MG", "UK3CB_LNM_O_UAZ_SPG9", "UK3CB_LNM_O_BRDM2_HQ", 
"UK3CB_LNM_O_Datsun_Pkm", "UK3CB_LNM_O_Hilux_M2", "UK3CB_LNM_O_Hilux_Mortar", "UK3CB_LNM_O_Hilux_Pkm", 
"UK3CB_LNM_O_Hilux_Zu23_Front", "UK3CB_LNM_O_Hilux_Zu23", "UK3CB_LNM_O_LR_M2", "UK3CB_LNM_O_LR_SF_M2", 
"UK3CB_LNM_O_Pickup_M2"
];

RB_EnemyVehiclePool_3CB_FIA = [
"UK3CB_FIA_O_Datsun_Pkm", "UK3CB_FIA_O_Hilux_GMG", "UK3CB_FIA_O_Hilux_Rocket_Arty", "UK3CB_FIA_O_Hilux_Dshkm", 
"UK3CB_FIA_O_Hilux_M2", "UK3CB_FIA_O_Hilux_Metis", "UK3CB_FIA_O_Hilux_Mortar", "UK3CB_FIA_O_Hilux_Pkm", 
"UK3CB_FIA_O_Hilux_Spg9", "UK3CB_FIA_O_Hilux_TOW", "UK3CB_FIA_O_Hilux_Zu23_Front", "UK3CB_FIA_O_MB4WD_AT", 
"UK3CB_FIA_O_MB4WD_LMG", "UK3CB_FIA_O_Hilux_Zu23", "UK3CB_FIA_O_LR_AGS30", "UK3CB_FIA_O_LR_M2", 
"UK3CB_FIA_O_Offroad_AT", "UK3CB_FIA_O_LR_SPG9", "UK3CB_FIA_O_Pickup_DSHKM", "UK3CB_FIA_O_Pickup_TOW", 
"UK3CB_FIA_O_Offroad_M2"
];

RB_EnemyVehiclePool_3CB_ADM = [
"UK3CB_ADM_O_BRDM2", "UK3CB_ADM_O_BRDM2_ATGM", "UK3CB_ADM_O_BRDM2_HQ", "UK3CB_ADM_O_Datsun_Pkm", 
"UK3CB_ADM_O_Hilux_GMG", "UK3CB_ADM_O_Hilux_Rocket_Arty", "UK3CB_ADM_O_Hilux_Dshkm", "UK3CB_ADM_O_Hilux_M2", 
"UK3CB_ADM_O_Hilux_Mortar", "UK3CB_ADM_O_Hilux_Pkm", "UK3CB_ADM_O_Hilux_Zu23_Front", "UK3CB_ADM_O_Pickup_Rocket_Arty", 
"UK3CB_ADM_O_Pickup_DSHKM", "UK3CB_ADM_O_Hilux_Spg9", "UK3CB_ADM_O_Hilux_Zu23", "UK3CB_ADM_O_Pickup_ZU23", 
"UK3CB_ADM_O_LR_M2", "UK3CB_ADM_O_Offroad_M2", "UK3CB_ADM_O_Pickup_Rocket", "UK3CB_ADM_O_LR_SF_AGS30", 
"UK3CB_ADM_O_Pickup_GMG", "UK3CB_ADM_O_Pickup_ZU23_Front"
];

RB_EnemyVehiclePool_3CB_ADE = [
"UK3CB_ADE_O_BRDM2", "UK3CB_ADE_O_Datsun_Pkm", "UK3CB_ADE_O_BRDM2_HQ", "UK3CB_ADE_O_Hilux_GMG", 
"UK3CB_ADE_O_Hilux_Rocket_Arty", "UK3CB_ADE_O_Hilux_Dshkm", "UK3CB_ADE_O_Hilux_Vulcan_Front", "UK3CB_ADE_O_Hilux_M2", 
"UK3CB_ADE_O_Hilux_Pkm", "UK3CB_ADE_O_Hilux_Spg9", "UK3CB_ADE_O_Hilux_Rocket", "UK3CB_ADE_O_Pickup_Metis", 
"UK3CB_ADE_O_Pickup_ZU23_Front", "UK3CB_ADE_O_Hilux_Zu23_Front", "UK3CB_ADE_O_Hilux_Zu23", "UK3CB_ADE_O_LR_AGS30", 
"UK3CB_ADE_O_LR_M2", "UK3CB_ADE_O_LR_SPG9", "UK3CB_ADE_O_Pickup_GMG", "UK3CB_ADE_O_Offroad_M2", 
"UK3CB_ADE_O_Pickup_Rocket_Arty", "UK3CB_ADE_O_Pickup_Rocket", "UK3CB_ADE_O_Pickup_ZU23"
];

RB_EnemyVehiclePool_3CB_ADCM = [
"UK3CB_ADG_O_Datsun_Civ_Open_ISL", "UK3CB_ADG_O_Datsun_Civ_Closed_ISL", "UK3CB_ADG_O_Ikarus_ISL", "UK3CB_ADG_O_Hilux_Pkm_ISL", 
"UK3CB_ADG_O_Datsun_Pkm_ISL", "UK3CB_ADG_O_Hatchback_ISL", "UK3CB_ADG_O_Hilux_Dshkm_ISL", "UK3CB_ADG_O_LR_Closed_ISL", 
"UK3CB_ADG_O_Landcruiser_ISL", "UK3CB_ADG_O_Pickup_DSHKM_ISL", "UK3CB_ADG_O_S1203_ISL", "UK3CB_ADG_O_Lada_ISL", 
"UK3CB_ADG_O_Gaz24_ISL", "UK3CB_ADG_O_Hilux_Dshkm", "UK3CB_ADG_O_Hilux_Pkm", "UK3CB_ADG_O_Pickup_DSHKM", 
"UK3CB_ADG_O_Golf_ISL"
];
