// functions/system/fn_initializeFactions.sqf
params ["_param_LogiFaction", "_param_CivPoolIndex", "_param_VehPoolIndex", "_param_EnemyInfIndex", "_param_EnemyVehIndex", "_param_Air"];

// === HELPER: PROBE & VALIDATE ===
private _fnc_validate = {
    params ["_index", "_map", "_fallbackIndex", "_type", "_name"];
    
    // Get the data for the selected index
    private _data = _map getOrDefault [_index, []];
    if (_data isEqualTo []) exitWith { _index }; // Should not happen if map is complete

    private _probeClass = "";
    private _isValid = true;

    // Determine what to probe based on structure
    switch (_type) do {
        case "Logistics": {
            // Data: [Options, TruckClass, Extra, Loadout]
            // Probe: TruckClass (Index 1)
            if (count _data > 1) then { _probeClass = _data select 1; };
        };
        case "SimpleArray": {
            // Data: ["Class1", "Class2"...]
            // Probe: First element
            if (count _data > 0) then { _probeClass = _data select 0; };
        };
        case "Air": {
            // Data: [[Rotary...], [Fixed...]]
            // Probe: First rotary or first fixed
            private _rot = _data select 0;
            private _fix = _data select 1;
            if (count _rot > 0) then { _probeClass = _rot select 0; }
            else { if (count _fix > 0) then { _probeClass = _fix select 0; }; };
        };
    };

    // Perform Check
    if (_probeClass != "") then {
        if (!isClass (configFile >> "CfgVehicles" >> _probeClass)) then {
            _isValid = false;
            private _msg = format ["[RB] WARNING: Mod content '%1' missing for %2 (Index %3). Reverting to default.", _probeClass, _name, _index];
            diag_log _msg;
            if (hasInterface) then { systemChat _msg; };
        };
    };

    if (_isValid) then { _index } else { _fallbackIndex };
};


// 1. CONFIGURE LOGISTICS
private _logisticsMap = createHashMapFromArray [
    [0, [RB_LogisticsOptions_Custom, "B_Truck_01_box_F", RB_ArsenalExtra_Custom, RB_StarterLoadout_Custom]],
    [1, [RB_LogisticsOptions_Vanilla_NATO, "B_Truck_01_box_F", [], RB_StarterLoadout_NATO]],
    [2, [RB_LogisticsOptions_APEX_NATO, "B_T_Truck_01_box_F", [], RB_StarterLoadout_APEX_NATO]],
    [3, [RB_LogisticsOptions_Contact_NATO, "B_Truck_01_box_F", [], RB_StarterLoadout_Contact_NATO]],
    [4, [RB_LogisticsOptions_Contact_LDF, "I_E_Truck_02_F", [], RB_StarterLoadout_Contact_LDF]],
    [5, [RB_LogisticsOptions_APEX_Gendarmerie, "B_GEN_Van_02_transport_F", [], RB_StarterLoadout_APEX_Gendarmerie]],
    [6, [RB_LogisticsOptions_CDLC_UNA, "B_UN_Truck_01_box_lxWS", [], RB_StarterLoadout_CDLC_UNA]],
    [7, [RB_LogisticsOptions_RHS_USA, "rhsusf_M1078A1P2_B_D_CP_fmtv_usarmy", [], RB_StarterLoadout_RHS_USA]],
    [8, [RB_LogisticsOptions_3CB_BAF, "UK3CB_BAF_MAN_HX58_Transport_Green_MTP", [], RB_StarterLoadout_3CB_BAF]],
    [9, [RB_LogisticsOptions_SOGPF_US, "vn_b_wheeled_m54_02", [], RB_StarterLoadout_SOGPF_US]],
    [10, [RB_LogisticsOptions_EF_MJTF, "EF_B_Truck_01_box_MJTF_Des", RB_ArsenalExtra_EF_MJTF, RB_StarterLoadout_EF_MJTF]],
    [11, [RB_LogisticsOptions_GM, "gm_ge_army_kat1_451_reammo", RB_ArsenalExtra_GM, RB_StarterLoadout_GM]]
];

private _activeLogiIndex = [_param_LogiFaction, _logisticsMap, 1, "Logistics", "Player Faction"] call _fnc_validate;
RB_LogisticsFaction = _activeLogiIndex;

private _logiData = _logisticsMap getOrDefault [_activeLogiIndex, _logisticsMap get 1];
RB_LogisticsOptions = +(_logiData select 0);
RB_LogisticsVehicleClass = _logiData select 1;
RB_FactionExtraItems = _logiData param [2, []];
RB_RawStarterLoadout = +(_logiData select 3);

publicVariable "RB_LogisticsFaction";
publicVariable "RB_LogisticsOptions";
publicVariable "RB_LogisticsVehicleClass";
publicVariable "RB_FactionExtraItems";
publicVariable "RB_RawStarterLoadout";


// 2. CONFIGURE CIVILIAN POOL
private _civMap = createHashMapFromArray [
    [0, RB_CivilianPool_Custom],
    [1, RB_CivilianPool_Vanilla],
    [2, RB_CivilianPool_Vanilla_African],
    [3, RB_CivilianPool_Vanilla_Asian],
    [4, RB_CivilianPool_Vanilla_EasternEuro],
    [5, RB_CivilianPool_Vanilla_Tanoan],
    [6, RB_CivilianPool_Vanilla_Mixed],
    [7, RB_CivilianPool_CDLC_SefrouRamal],
    [8, RB_CivilianPool_3CB_Africa],
    [9, RB_CivilianPool_3CB_Chernarus],
    [10, RB_CivilianPool_3CB_ME],
    [11, RB_CivilianPool_SOGPF],
    [12, RB_CivilianPool_CUP_Chernarus],
    [13, RB_CivilianPool_CUP_Takistan],
    [14, RB_CivilianPool_GM]
];

_param_CivPoolIndex = [_param_CivPoolIndex, _civMap, 1, "SimpleArray", "Civilian Pool"] call _fnc_validate;
RB_ActiveCivilianPool = +(_civMap getOrDefault [_param_CivPoolIndex, RB_CivilianPool_Vanilla]);
publicVariable "RB_ActiveCivilianPool";


// 3. CONFIGURE CIVILIAN VEHICLE POOL
private _civVehMap = createHashMapFromArray [
    [0, RB_CivilianVehiclePool_Custom],
    [1, RB_CivilianVehiclePool_Vanilla],
    [2, RB_CivilianVehiclePool_3CB],
    [3, RB_CivilianVehiclePool_CUP_West],
    [4, RB_CivilianVehiclePool_CUP_MiddleEast],
    [5, RB_CivilianVehiclePool_RDS_West],
    [6, RB_CivilianVehiclePool_SOGPF],
    [7, RB_CivilianVehiclePool_GM]
];

_param_VehPoolIndex = [_param_VehPoolIndex, _civVehMap, 1, "SimpleArray", "Civilian Vehicle Pool"] call _fnc_validate;
RB_CivilianVehiclePool = +(_civVehMap getOrDefault [_param_VehPoolIndex, RB_CivilianVehiclePool_Vanilla]);
RB_ActiveVehiclePool = RB_CivilianVehiclePool;
publicVariable "RB_ActiveVehiclePool";


// 4. CONFIGURE ENEMY INFANTRY POOL
private _enemyInfMap = createHashMapFromArray [
    [0, RB_EnemyInfantryPool_Custom],
    [1, RB_EnemyInfantryPool_Vanilla_FIA],
    [2, RB_EnemyInfantryPool_Vanilla_Looters],
    [3, RB_EnemyInfantryPool_Vanilla_SyndikatBandits],
    [4, RB_EnemyInfantryPool_Vanilla_SyndikatParaMilitary],
    [5, RB_EnemyInfantryPool_Vanilla_CSAT],
    [6, RB_EnemyInfantryPool_Vanilla_Spetsnaz],
    [7, RB_EnemyInfantryPool_CDLC_WSTura],
    [8, RB_EnemyInfantryPool_CDLC_WSSFIA],
    [9, RB_EnemyInfantryPool_RHSGREF_CHDKZ],
    [10, RB_EnemyInfantryPool_RHSGREF_NAPA],
    [11, RB_EnemyInfantryPool_SOGPF_VC],
    [12, RB_EnemyInfantryPool_3CB_TI],
    [13, RB_EnemyInfantryPool_3CB_MEI],
    [14, RB_EnemyInfantryPool_3CB_MEE],
    [15, RB_EnemyInfantryPool_3CB_MDF],
    [16, RB_EnemyInfantryPool_3CB_LSM],
    [17, RB_EnemyInfantryPool_3CB_LNM],
    [18, RB_EnemyInfantryPool_3CB_FIA],
    [19, RB_EnemyInfantryPool_3CB_ADM],
    [20, RB_EnemyInfantryPool_3CB_ADE],
    [21, RB_EnemyInfantryPool_3CB_ADCM],
    [22, RB_EnemyInfantryPool_CUP_NPC],
    [23, RB_EnemyInfantryPool_CUP_TL],
    [24, RB_EnemyInfantryPool_CUP_ION],
    [25, RB_EnemyInfantryPool_CUP_TM],
    [26, RB_EnemyInfantryPool_CUP_TA],
    [27, RB_EnemyInfantryPool_CUP_TI],
    [28, RB_EnemyInfantryPool_CUP_CMORS],
    [29, RB_EnemyInfantryPool_GM_REV],
    [30, RB_EnemyInfantryPool_GM_EGER80],
    [31, RB_EnemyInfantryPool_GM_EGER90]
];

_param_EnemyInfIndex = [_param_EnemyInfIndex, _enemyInfMap, 1, "SimpleArray", "Enemy Faction"] call _fnc_validate;
RB_EnemyInfantryPool = +(_enemyInfMap getOrDefault [_param_EnemyInfIndex, RB_EnemyInfantryPool_Vanilla_FIA]);
publicVariable "RB_EnemyInfantryPool";


// 5. CONFIGURE ENEMY VEHICLE POOL
private _enemyVehMap = createHashMapFromArray [
    [0, RB_EnemyVehiclePool_Custom],
    [1, RB_EnemyVehiclePool_Vanilla],
    [2, RB_EnemyVehiclePool_WS],
    [3, RB_EnemyVehiclePool_CUP_TM],
    [4, RB_EnemyVehiclePool_CUP_CMORS],
    [5, RB_EnemyVehiclePool_SOGPF_VC],
    [6, RB_EnemyVehiclePool_RHSGREF_CHDKZ],
    [7, RB_EnemyVehiclePool_RHSGREF_NAPA],
    [8, RB_EnemyVehiclePool_3CB_TI],
    [9, RB_EnemyVehiclePool_3CB_MEI],
    [10, RB_EnemyVehiclePool_3CB_MEE],
    [11, RB_EnemyVehiclePool_3CB_MDF],
    [12, RB_EnemyVehiclePool_3CB_LSM],
    [13, RB_EnemyVehiclePool_3CB_LNM],
    [14, RB_EnemyVehiclePool_3CB_FIA],
    [15, RB_EnemyVehiclePool_3CB_ADM],
    [16, RB_EnemyVehiclePool_3CB_ADE],
    [17, RB_EnemyVehiclePool_3CB_ADCM],
    [18, RB_EnemyVehiclePool_GM_EGER],
    [19, RB_EnemyVehiclePool_GM_EGERAPC]
];

_param_EnemyVehIndex = [_param_EnemyVehIndex, _enemyVehMap, 1, "SimpleArray", "Enemy Vehicle Pool"] call _fnc_validate;
RB_EnemyVehiclePool = +(_enemyVehMap getOrDefault [_param_EnemyVehIndex, RB_EnemyVehiclePool_Vanilla]);
publicVariable "RB_EnemyVehiclePool";


// 6. CONFIGURE AMBIENT AIR
// Format: [RotaryArray, FixedArray]
private _ambientMap = createHashMapFromArray [
    [0, [[], []]],
    [1, [RB_Ambient_Rotary_Custom, RB_Ambient_Fixed_Custom]],
    [2, [RB_Ambient_Rotary_NATO, RB_Ambient_Fixed_NATO]],
    [3, [RB_Ambient_Rotary_APEX_NATO, RB_Ambient_Fixed_APEX_NATO]],
    [4, [RB_Ambient_Rotary_Gendarmerie, RB_Ambient_Fixed_Gendarmerie]],
    [5, [RB_Ambient_Rotary_UNA, RB_Ambient_Fixed_UNA]],
    [6, [RB_Ambient_Rotary_RHS_USA, RB_Ambient_Fixed_RHS_USA]],
    [7, [RB_Ambient_Rotary_3CB_BAF, RB_Ambient_Fixed_3CB_BAF]],
    [8, [RB_Ambient_Rotary_SOGPF_US, RB_Ambient_Fixed_SOGPF_US]],
    [9, [RB_Ambient_Rotary_MJTF, RB_Ambient_Fixed_MJTF]],
    [10, [RB_Ambient_Rotary_CUP_USArmy, RB_Ambient_Fixed_CUP_USArmy]],
    [11, [RB_Ambient_Rotary_CUP_USMC, RB_Ambient_Fixed_CUP_USMC]],
    [12, [RB_Ambient_Rotary_GM, RB_Ambient_Fixed_GM]]
];

_param_Air = [_param_Air, _ambientMap, 1, "Air", "Ambient Air"] call _fnc_validate;
private _ambientData = _ambientMap getOrDefault [_param_Air, [RB_Ambient_Rotary_Custom, RB_Ambient_Fixed_Custom]];
RB_Ambient_Rotary_Selected = +(_ambientData select 0);
RB_Ambient_Fixed_Selected  = +(_ambientData select 1);

publicVariable "RB_Ambient_Rotary_Selected";
publicVariable "RB_Ambient_Fixed_Selected";

true
