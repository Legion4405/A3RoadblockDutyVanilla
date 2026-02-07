// functions/system/fn_initializeMission.sqf
// ============================================
//                 INITIALIZE MISSION
//  Handles core mission setup, parameters,
//  and persistence loading.
// ============================================

if (!isServer) exitWith {};

// Wait until missionParams are available
waitUntil { !isNil "paramsArray" };

// 1. EXECUTE PERSISTENT SCRIPTS (Param-independent)
[] execVM "scripts\effects\runDynamicWeather.sqf";
[] execVM "scripts\checkAllDead.sqf";

// 2. READ MISSION PARAMETERS
private _param_LogiFaction   = ["RB_LogisticsFaction", 0] call BIS_fnc_getParamValue;
private _param_CivPoolIndex  = ["RB_CivilianPool", 0] call BIS_fnc_getParamValue;
private _param_VehPoolIndex  = ["RB_CivilianVehiclePool", 0] call BIS_fnc_getParamValue;
private _param_EnemyInfIndex = ["RB_EnemyFaction", 0] call BIS_fnc_getParamValue;
private _param_EnemyVehIndex = ["RB_EnemyVehiclePool", 0] call BIS_fnc_getParamValue;
private _param_RespawnCost   = ["RB_RespawnCost", 10] call BIS_fnc_getParamValue;
private _param_Air           = ["RB_AmbientAir", 1] call BIS_fnc_getParamValue;
private _loadSlot            = ["RB_LoadSaveSlot", 0] call BIS_fnc_getParamValue;
private _restorePools        = ["RB_RestoreSavedPools", 1] call BIS_fnc_getParamValue;

// Store indices globally so they can be saved
RB_SavedCivPoolIndex  = _param_CivPoolIndex;
RB_SavedVehPoolIndex  = _param_VehPoolIndex;
RB_SavedEnemyInfIndex = _param_EnemyInfIndex;
RB_SavedEnemyVehIndex = _param_EnemyVehIndex;
RB_SavedAirIndex      = _param_Air;

// 3. SETUP HIGH COMMAND MODULE
// Check for existing editor-placed module first to avoid conflicts
private _existingHC = allMissionObjects "HighCommand";
if (count _existingHC > 0) then {
    RB_HC_Module = _existingHC select 0;
    // Ensure it has the fix preventing engine crashes
    if (isNil {RB_HC_Module getVariable "wpover_click"}) then {
        RB_HC_Module setVariable ["wpover_click", [], true];
    };
    publicVariable "RB_HC_Module";
} else {
    // Spawn one if none exists
    if (isNil "RB_HC_Module") then {
        private _logicGroup = createGroup sideLogic;
        RB_HC_Module = _logicGroup createUnit ["HighCommand", [0,0,0], [], 0, "NONE"];
        RB_HC_Module setVariable ["BIS_fnc_initModules_disableAutoActivation", false];
        RB_HC_Module setVariable ["wpover_click", [], true];
        publicVariable "RB_HC_Module";
    };
};

// 4. HANDLE PERSISTENCE
if (_loadSlot > 0) then {
    // Load progress (Sets RB_LogisticsFaction, RB_ArsenalUnlocks, etc.)
    [_loadSlot] call RB_fnc_loadProgress;

    // Optional: Overwrite parameters with saved pool indices
    if (_restorePools == 1) then {
        if (missionNamespace getVariable ["RB_SavedCivPoolIndex", -1] != -1) then { _param_CivPoolIndex = RB_SavedCivPoolIndex; };
        if (missionNamespace getVariable ["RB_SavedVehPoolIndex", -1] != -1) then { _param_VehPoolIndex = RB_SavedVehPoolIndex; };
        if (missionNamespace getVariable ["RB_SavedEnemyInfIndex", -1] != -1) then { _param_EnemyInfIndex = RB_SavedEnemyInfIndex; };
        if (missionNamespace getVariable ["RB_SavedEnemyVehIndex", -1] != -1) then { _param_EnemyVehIndex = RB_SavedEnemyVehIndex; };
        if (missionNamespace getVariable ["RB_SavedAirIndex", -1] != -1) then { _param_Air = RB_SavedAirIndex; };
        diag_log "[RB] Persistence: Faction pools restored from save.";
    } else {
        diag_log "[RB] Persistence: Restoration of pools disabled. Using mission parameters.";
    };
    
    // Broadcast saved globals
    publicVariable "RB_LoadSaveSlot";
    publicVariable "RB_ArsenalUnlocks";
    
    // Broadcast saved score
    private _savedScore = RB_Terminal getVariable ["rb_score", 0];
    RB_Terminal setVariable ["rb_score", _savedScore, true];
    publicVariable "RB_Terminal";

    // Update _param_LogiFaction with the loaded value to ensure consistency below
    _param_LogiFaction = RB_LogisticsFaction;

} else {
    // Fresh mission
    RB_LogisticsFaction = _param_LogiFaction;
    publicVariable "RB_LogisticsFaction";
    systemChat "Starting mission with fresh state.";
};

// Update global tracking variables for the current session (for future saving)
RB_SavedCivPoolIndex  = _param_CivPoolIndex;
RB_SavedVehPoolIndex  = _param_VehPoolIndex;
RB_SavedEnemyInfIndex = _param_EnemyInfIndex;
RB_SavedEnemyVehIndex = _param_EnemyVehIndex;
RB_SavedAirIndex      = _param_Air;

// 5. INITIALIZE FACTIONS
[_param_LogiFaction, _param_CivPoolIndex, _param_VehPoolIndex, _param_EnemyInfIndex, _param_EnemyVehIndex, _param_Air] call RB_fnc_initializeFactions;

// 6. SHARE RESPAWN COST
missionNamespace setVariable ["RB_RespawnCost", _param_RespawnCost, true];
publicVariable "RB_RespawnCost";

// 7. CALCULATE & SHARE ARSENAL ITEMS
if (isNil "RB_ArsenalUnlocks") then {
    RB_ArsenalUnlocks = [];
};

// Wait for loadouts
waitUntil { !isNil "RB_StarterLoadout_NATO" };

private _starterLoadout = [RB_LogisticsFaction] call RB_fnc_getStarterLoadout;
RB_ArsenalUnlocks = RB_ArsenalUnlocks + ([_starterLoadout] call RB_fnc_extractLoadoutItems);

// Append Faction-Specific Extras
if (!isNil "RB_FactionExtraItems") then {
    RB_ArsenalUnlocks append RB_FactionExtraItems;
};

// Deduplicate
RB_ArsenalUnlocks = RB_ArsenalUnlocks arrayIntersect RB_ArsenalUnlocks;

// Sanitize Arsenal if ACE Medical is missing
if (!isClass (configFile >> "CfgPatches" >> "ace_medical")) then {
    private _medItems = missionNamespace getVariable ["RB_AceMedicalItems", []];
    RB_ArsenalUnlocks = RB_ArsenalUnlocks - _medItems;
};

publicVariable "RB_ArsenalUnlocks";

// 8. SETUP FORTIFY PERSISTENCE
if (isNil "RB_PersistentFortifications") then { RB_PersistentFortifications = []; };
if (isNil "RB_LogisticsObjects") then { RB_LogisticsObjects = []; }; // Optimize persistence

// Track ACE Fortify Objects
["acex_fortify_objectPlaced", {
    params ["_unit", "_side", "_object"];
    _object setVariable ["rb_isPersistentLogi", true, true];
    RB_PersistentFortifications pushBack _object;
}] call CBA_fnc_addEventHandler;

// 9. FINAL SERVER STATE
if (isNil "RB_GeneratorState") then {
    RB_GeneratorState = true;
    publicVariable "RB_GeneratorState";
};

true
