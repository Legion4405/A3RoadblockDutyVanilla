// File: init.sqf
// ============================================
//                 INIT.SQF
//  Handles configuration, parameters, 
//  save/load, and shared globals.
// ============================================

// 1. Compile all config files
call compile preprocessFileLineNumbers "configs\config.sqf";
call compile preprocessFileLineNumbers "configs\enemyFactions.sqf";

call compile preprocessFileLineNumbers "configs\playerFactions\apex_gerndarmerie.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\apex_nato.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\vanilla_nato.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\contact_nato.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\contact_ldf.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\ws_una.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\rhs_usa.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\3cb_british.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\sogpf_us.sqf";

call compile preprocessFileLineNumbers "configs\civilianFactions.sqf";
call compile preprocessFileLineNumbers "configs\customFactions.sqf";

east setFriend [resistance, 1];
resistance setFriend [east, 1];

// 2. If SERVER, read parameters, apply configs, and handle persistence
if (isServer) then {
    // Wait until missionParams are available
    waitUntil { !isNil "paramsArray" };

    // Execute persistent scripts that do not depend on parameters
    [] execVM "scripts\effects\runDynamicWeather.sqf";
    [] execVM "scripts\checkAllDead.sqf";

    // === READ MISSION PARAMETERS ===
    private _param_LogiFaction   = ["RB_LogisticsFaction", 0] call BIS_fnc_getParamValue;
    private _param_CivPoolIndex  = ["RB_CivilianPool", 0] call BIS_fnc_getParamValue;
    private _param_VehPoolIndex  = ["RB_CivilianVehiclePool", 0] call BIS_fnc_getParamValue;
    private _param_EnemyInfIndex = ["RB_EnemyFaction", 0] call BIS_fnc_getParamValue;
    private _param_EnemyVehIndex = ["RB_EnemyVehiclePool", 0] call BIS_fnc_getParamValue;
    private _param_RespawnCost   = ["RB_RespawnCost", 10] call BIS_fnc_getParamValue;

    // 2.1. HANDLE PERSISTENCE (LOAD) IMMEDIATELY
    private _loadSlot = ["RB_LoadSaveSlot", 0] call BIS_fnc_getParamValue;
    if (_loadSlot > 0) then {
        // Call the loadProgress function on the server
        [_loadSlot] call RB_fnc_loadProgress;

        // ─── After RB_fnc_loadProgress runs, it sets:
        //      RB_LogisticsFaction, RB_ArsenalUnlocks, RB_Terminal->rb_score, etc.
        //    We must broadcast these to clients.
        //    (fn_loadProgress itself already does publicVariable "RB_LogisticsFaction").
        //    But just in case any other globals need sharing, broadcast them now:
        publicVariable "RB_LoadSaveSlot";
        // *Note:* fn_loadProgress already does `publicVariable "RB_ArsenalUnlocks"` when spawning unlocks,
        // and we also need to ensure RB_ArsenalUnlocks is public after load. If not, do it explicitly here:
        publicVariable "RB_ArsenalUnlocks";
        // If you also want clients to see the saved score immediately:
        private _savedScore = RB_Terminal getVariable ["rb_score", 0];
        RB_Terminal setVariable ["rb_score", _savedScore, true];
        publicVariable "RB_Terminal";

    } else {
        // No load slot selected → fresh mission. Use default param value for LogisticsFaction.
        RB_LogisticsFaction = _param_LogiFaction;
        publicVariable "RB_LogisticsFaction";
        systemChat "Starting mission with fresh state.";
    };

    // 2.2. CONFIGURE LOGISTICS BASED ON (NOW-loaded) RB_LogisticsFaction
    //     By this point either we loaded RB_LogisticsFaction from profile,
    //     or we just assigned the param default above.

    private _activeLogiIndex = RB_LogisticsFaction;
    switch (_activeLogiIndex) do {
        case 0: { 
            RB_LogisticsOptions       = +RB_LogisticsOptions_Custom;
            RB_LogisticsVehicleClass  = "B_Truck_01_box_F";
        };
        case 1: {
            RB_LogisticsOptions       = +RB_LogisticsOptions_Vanilla_NATO;
            RB_LogisticsVehicleClass  = "B_Truck_01_box_F";
        };
        case 2: {
            RB_LogisticsOptions       = +RB_LogisticsOptions_APEX_NATO;
            RB_LogisticsVehicleClass  = "B_T_Truck_01_box_F";
        };
        case 3: {
            RB_LogisticsOptions       = +RB_LogisticsOptions_Contact_NATO;
            RB_LogisticsVehicleClass  = "B_Truck_01_box_F";
        };
        case 4: {
            RB_LogisticsOptions       = +RB_LogisticsOptions_Contact_LDF;
            RB_LogisticsVehicleClass  = "I_E_Truck_02_F";
        };
        case 5: {
            RB_LogisticsOptions       = +RB_LogisticsOptions_APEX_Gendarmerie;
            RB_LogisticsVehicleClass  = "B_GEN_Van_02_transport_F";
        };
        case 6: {
            RB_LogisticsOptions       = +RB_LogisticsOptions_CDLC_UNA;
            RB_LogisticsVehicleClass  = "B_UN_Truck_01_box_lxWS";
        };
        case 7: {
            RB_LogisticsOptions       = +RB_LogisticsOptions_RHS_USA;
            RB_LogisticsVehicleClass  = "rhsusf_M1078A1P2_B_D_CP_fmtv_usarmy";
        };
        case 8: {
            RB_LogisticsOptions       = +RB_LogisticsOptions_3CB_BAF;
            RB_LogisticsVehicleClass  = "UK3CB_BAF_MAN_HX58_Transport_Green_MTP";
        };
        case 9: {
            RB_LogisticsOptions       = +RB_LogisticsOptions_SOGPF_US;
            RB_LogisticsVehicleClass  = "vn_b_wheeled_m54_02";
        };
        default {
            RB_LogisticsOptions       = +RB_LogisticsOptions_Vanilla_NATO;
            RB_LogisticsVehicleClass  = "B_Truck_01_box_F";
        };
    };
    publicVariable "RB_LogisticsOptions";
    publicVariable "RB_LogisticsVehicleClass";

    // 2.3. CONFIGURE CIVILIAN POOL
    switch (_param_CivPoolIndex) do {
        case 0:  { RB_ActiveCivilianPool = +RB_CivilianPool_Custom; };
        case 1:  { RB_ActiveCivilianPool = +RB_CivilianPool_Vanilla; };
        case 2:  { RB_ActiveCivilianPool = +RB_CivilianPool_Vanilla_African; };
        case 3:  { RB_ActiveCivilianPool = +RB_CivilianPool_Vanilla_Asian; };
        case 4:  { RB_ActiveCivilianPool = +RB_CivilianPool_Vanilla_EasternEuro; };
        case 5:  { RB_ActiveCivilianPool = +RB_CivilianPool_Vanilla_Tanoan; };
        case 6:  { RB_ActiveCivilianPool = +RB_CivilianPool_Vanilla_Mixed; };
        case 7:  { RB_ActiveCivilianPool = +RB_CivilianPool_CDLC_SefrouRamal; };
        case 8:  { RB_ActiveCivilianPool = +RB_CivilianPool_3CB_Africa; };
        case 9:  { RB_ActiveCivilianPool = +RB_CivilianPool_3CB_Chernarus; };
        case 10: { RB_ActiveCivilianPool = +RB_CivilianPool_3CB_ME; };
        case 11: { RB_ActiveCivilianPool = +RB_CivilianPool_SOGPF; };
        default { RB_ActiveCivilianPool = +RB_CivilianPool_Vanilla; };
    };
    publicVariable "RB_ActiveCivilianPool";

    // 2.4. CONFIGURE CIVILIAN VEHICLE POOL
    switch (_param_VehPoolIndex) do {
        case 0: { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_Custom; };
        case 1: { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_Vanilla; };
        case 2: { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_3CB; };
        case 3: { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_CUP_West; };
        case 4: { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_CUP_MiddleEast; };
        case 5: { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_RDS_West; };
        case 6: { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_SOGPF; };
        default { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_Vanilla; };
    };
    RB_ActiveVehiclePool = RB_CivilianVehiclePool;
    publicVariable "RB_ActiveVehiclePool";

    // 2.5. CONFIGURE ENEMY INFANTRY POOL
    switch (_param_EnemyInfIndex) do {
        case 0:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_Custom; };
        case 1:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_Vanilla_FIA; };
        case 2:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_Vanilla_Looters; };
        case 3:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_Vanilla_SyndikatBandits; };
        case 4:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_Vanilla_SyndikatParaMilitary; };
        case 5:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_Vanilla_CSAT; };
        case 6:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_Vanilla_Spetsnaz; };
        case 7:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_CDLC_WSTura; };
        case 8:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_CDLC_WSSFIA; };
        case 9:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_RHSGREF_CHDKZ; };
        case 10:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_RHSGREF_NAPA; };
        case 11:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_SOGPF_VC; };
        case 12:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_3CB_TI; };
        case 13:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_3CB_MEI; };
        case 14:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_3CB_MEE; };
        case 15:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_3CB_MDF; };
        case 16:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_3CB_LSM; };
        case 17:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_3CB_LNM; };
        case 18:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_3CB_FIA; };
        case 19:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_3CB_ADM; };
        case 20:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_3CB_ADE; };
        case 21:  { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_3CB_ADCM; };
        default { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_Vanilla_FIA; };
    };
    publicVariable "RB_EnemyInfantryPool";

    // 2.6. CONFIGURE ENEMY VEHICLE POOL
    switch (_param_EnemyVehIndex) do {
        case 0:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_Custom; };
        case 1:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_Vanilla; };
        case 2:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_WS; };
        case 3:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_CUP_TM; };
        case 4:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_CUP_CMORS; };
        case 5:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_SOGPF_VC; };
        case 6:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_RHSGREF_CHDKZ; };
        case 7:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_RHSGREF_NAPA; };
        case 8:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_3CB_TI; };
        case 9:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_3CB_MEI; };
        case 10:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_3CB_MEE; };
        case 11:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_3CB_MDF; };
        case 12:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_3CB_LSM; };
        case 13:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_3CB_LNM; };
        case 14:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_3CB_FIA; };
        case 15:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_3CB_ADM; };
        case 16:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_3CB_ADE; };
        case 17:  { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_3CB_ADCM; };
        default { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_Vanilla; };
    };
    publicVariable "RB_EnemyVehiclePool";

    // 2.7. CONFIGURE AMBIENT AIR
    private _param_Air = ["RB_AmbientAir", 1] call BIS_fnc_getParamValue;
    switch (_param_Air) do {
        case 0: {
            // Ambient air disabled
            RB_Ambient_Rotary_Selected = [];
            RB_Ambient_Fixed_Selected  = [];
        };
        case 1: {
            // Custom ambient
            RB_Ambient_Rotary_Selected = +RB_Ambient_Rotary_Custom;
            RB_Ambient_Fixed_Selected  = +RB_Ambient_Fixed_Custom;
        };
        case 2: {
            // NATO ambient
            RB_Ambient_Rotary_Selected = +RB_Ambient_Rotary_NATO;
            RB_Ambient_Fixed_Selected  = +RB_Ambient_Fixed_NATO;
        };
        case 3: {
            // NATO ambient
            RB_Ambient_Rotary_Selected = +RB_Ambient_Rotary_APEX_NATO;
            RB_Ambient_Fixed_Selected  = +RB_Ambient_Fixed_APEX_NATO;
        };
        case 4: {
            // Gendarmerie ambient
            RB_Ambient_Rotary_Selected = +RB_Ambient_Rotary_Gendarmerie;
            RB_Ambient_Fixed_Selected  = +RB_Ambient_Fixed_Gendarmerie;
        };
        case 5: {
            // UNA ambient
            RB_Ambient_Rotary_Selected = +RB_Ambient_Rotary_UNA;
            RB_Ambient_Fixed_Selected  = +RB_Ambient_Fixed_UNA;
        };
        case 6: {
            // US Army ambient
            RB_Ambient_Rotary_Selected = +RB_Ambient_Rotary_RHS_USA;
            RB_Ambient_Fixed_Selected  = +RB_Ambient_Fixed_RHS_USA;
        };
        case 7: {
            // 3CB BAFambient
            RB_Ambient_Rotary_Selected = +RB_Ambient_Rotary_3CB_BAF;
            RB_Ambient_Fixed_Selected  = +RB_Ambient_Fixed_3CB_BAF;
        };
        case 8: {
            // 3CB BAFambient
            RB_Ambient_Rotary_Selected = +RB_Ambient_Rotary_SOGPF_US;
            RB_Ambient_Fixed_Selected  = +RB_Ambient_Fixed_SOGPF_US;
        };
        default {
            RB_Ambient_Rotary_Selected = +RB_Ambient_Rotary_Custom;
            RB_Ambient_Fixed_Selected  = +RB_Ambient_Fixed_Custom;
        };
    };
    publicVariable "RB_Ambient_Rotary_Selected";
    publicVariable "RB_Ambient_Fixed_Selected";

    // 2.8. SHARE RESPAWN COST
    missionNamespace setVariable ["RB_RespawnCost", _param_RespawnCost, true];
    publicVariable "RB_RespawnCost";
};

// 3. SERVER/CLIENT—INITIALIZE & SHARE THE ARSENAL UNLOCK ARRAY
if (isServer) then {
    // If we just loaded a save, RB_ArsenalUnlocks already got set & publicVariable’d in fn_loadProgress.
    // Otherwise, begin with an empty array and broadcast it:
    if (isNil "RB_ArsenalUnlocks") then {
        RB_ArsenalUnlocks = [];
        publicVariable "RB_ArsenalUnlocks";
    };
};

// 4. CLIENT BLOCK: WAIT FOR GLOBALS (RB_ArsenalUnlocks + RB_LogisticsFaction) AND APPLY LOADOUT
if (hasInterface) then {
    // 4.1. Wait for server to broadcast RB_ArsenalUnlocks
    waitUntil { !isNil "RB_ArsenalUnlocks" };

    // 4.2. Wait for server to broadcast RB_LogisticsFaction
    waitUntil { !isNil "RB_LogisticsFaction" };

    // 4.3. Wait for starter loadouts to be defined
    waitUntil { !isNil "RB_StarterLoadout_NATO" };

    // 4.4. Now RB_LogisticsFaction is guaranteed to be the saved (or default) index
    private _faction      = RB_LogisticsFaction;
    private _starterLoadout = [_faction] call RB_fnc_getStarterLoadout;
    if (alive player) then {
        player setUnitLoadout _starterLoadout;
        private _friendlyAI        = allUnits select {
            (side _x) == west && {!isPlayer _x} && {alive _x}
        };
         {
            _x setUnitLoadout _starterLoadout;
            _x addEventHandler ["Respawn", {
            params ["_newUnit", "_corpse"];
                waitUntil{!isNil "_newUnit"};
                private _fIdx = RB_LogisticsFaction;
                private _ld   = [_fIdx] call RB_fnc_getStarterLoadout;
                _newUnit setUnitLoadout _ld;
            }];
        } forEach _friendlyAI;
    };
};

// 5. SERVER: CALCULATE & SHARE ARSENAL ITEMS (based on chosen LogisticsFaction)
if (isServer) then {
    // Wait until starter loadouts exist
    waitUntil { !isNil "RB_StarterLoadout_NATO" };

    // Use the (now-loaded) RB_LogisticsFaction index
    private _faction        = RB_LogisticsFaction;
    private _starterLoadout = [_faction] call RB_fnc_getStarterLoadout;

    // Extract items from that loadout
    RB_ArsenalUnlocks = [_starterLoadout] call RB_fnc_extractLoadoutItems;
    publicVariable "RB_ArsenalUnlocks";
};

// 6. CLIENT: APPLY ARSENAL UNLOCKS TO THE ACE BOX (JIP-safe)
if (hasInterface) then {
    [] spawn {
        waitUntil {
            !isNull (missionNamespace getVariable ["RB_Arsenal", objNull]) &&
            {!isNil "RB_ArsenalUnlocks" && { count RB_ArsenalUnlocks > 0 }}
        };

        private _fullUnlocks = RB_ArsenalAlwaysAvailable + RB_ArsenalUnlocks;
        // Deduplicate
        _fullUnlocks = _fullUnlocks arrayIntersect _fullUnlocks;

        private _box = missionNamespace getVariable ["RB_Arsenal", objNull];
        if (!isNull _box) then {
            [_box, _fullUnlocks, true] remoteExec ["ace_arsenal_fnc_addVirtualItems", 0, true];
        };
    };
};

// 7. SERVER: FINAL INITIALIZATION (generator state, save slot broadcast, etc.)
if (isServer) then {
    if (isNil "RB_GeneratorState") then {
        RB_GeneratorState = true;
        publicVariable "RB_GeneratorState";
    };

    // If we have a “Load Save Slot” param, it was already handled in step 2.
    // Clients already know which slot was chosen via publicVariable "RB_LoadSaveSlot".
    // If you want to allow saving later, just call RB_fnc_saveProgress(slot) from your terminal.
};

// 8. Set up ACE actions & event handlers
[] spawn {
    waitUntil { !isNull RB_Terminal };
    [ RB_Terminal ] remoteExec ["RB_fnc_addTerminalActions", 0, true];
};

[] spawn {
    waitUntil { !isNull (missionNamespace getVariable ["RB_Generator", objNull]) };
    [] call RB_fnc_addGeneratorActions;
};

addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer"];
    if (!isNull _unit && { _unit isKindOf "CAManBase" } && { isPlayer _killer }) then {
        [_unit, _killer] call RB_fnc_onCivilianKilled;
    };
}];
