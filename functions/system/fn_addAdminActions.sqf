/*
    File: fn_addAdminActions.sqf
    Description: Adds organized admin-only ACE actions.
*/

private _obj = _this select 0;
if (!hasInterface) exitWith {};
private _addAction = {
    params ["_obj", "_path", "_action"];
    [_obj, 0, _path, _action] call ace_interact_menu_fnc_addActionToObject;
};

// Check admin status
private _isAdmin = (!isMultiplayer) || (serverCommandAvailable "#kick") || {!isNull (getAssignedCuratorLogic player)};
if (!_isAdmin) exitWith {};


// ============================================================================================
// 1. WORLD CONTROL (Time, Weather)
// ============================================================================================
private _worldMenu = ["RB_Admin_World", "World Control", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin"], _worldMenu] call _addAction;

// --- Time Scale
private _timeScaleMenu = ["RB_Admin_TimeScale", "Time Acceleration", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_World"], _timeScaleMenu] call _addAction;
{
    private _mult = _x;
    private _action = [
        format ["RB_Admin_TimeScale_%1", _mult], format ["Set Scale: %1x", _mult], "",
        { params ["_t", "_p", "_a"]; [_a#0] remoteExec ["RB_fnc_setTimeMultiplier", 2]; hint format ["⏱ Scale: %1x", _a#0]; },
        { true }, {}, [_mult]
    ] call ace_interact_menu_fnc_createAction;
    [_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_World", "RB_Admin_TimeScale"], _action] call _addAction;
} forEach [1, 4, 12, 24];

// --- Set Time
private _setTimeMenu = ["RB_Admin_SetTime", "Set Time of Day", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_World"], _setTimeMenu] call _addAction;
{
    private _hour = _x;
    private _action = [
        format ["RB_Admin_SetHour_%1", _hour], format ["Set Time: %1:00", _hour], "",
        { params ["_t", "_p", "_a"]; [_a#0] remoteExec ["RB_fnc_setTimeOfDay", 2]; hint format ["Time: %1:00", _a#0]; },
        { true }, {}, [_hour]
    ] call ace_interact_menu_fnc_createAction;
    [_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_World", "RB_Admin_SetTime"], _action] call _addAction;
} forEach [0, 4, 8, 12, 16, 20];

// --- Weather
private _weatherMenu = ["RB_Admin_Weather", "Weather Presets", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_World"], _weatherMenu] call _addAction;
{
    private _preset = _x;
    private _action = [
        format ["RB_Admin_Weather_%1", _preset], _preset, "",
        { params ["_t", "_p", "_a"]; [_a#0] remoteExec ["RB_fnc_setWeatherPreset", 2]; hint format ["Weather: %1", _a#0]; },
        { true }, {}, [_preset]
    ] call ace_interact_menu_fnc_createAction;
    [_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_World", "RB_Admin_Weather"], _action] call _addAction;
} forEach ["Clear", "Cloudy", "Foggy", "Rain", "Storm"];


// ============================================================================================
// 2. MISSION CONTROL (Events, Spawning, Reset)
// ============================================================================================
private _missionMenu = ["RB_Admin_Mission", "Mission Control", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin"], _missionMenu] call _addAction;

// --- Trigger Events
private _eventsMenu = ["RB_Admin_Events", "Trigger Events", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Mission"], _eventsMenu] call _addAction;

private _evtAttack = ["RB_Evt_Attack", "Trigger Enemy Attack", "", { [] remoteExec ["RB_fnc_spawnEnemyAttack", 2]; hint "Attack Triggered"; }, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Mission", "RB_Admin_Events"], _evtAttack] call _addAction;

private _evtVeh = ["RB_Evt_Veh", "Trigger Enemy Vehicle", "", { [] remoteExec ["RB_fnc_spawnEnemyVehicle", 2]; hint "Vehicle Attack Triggered"; }, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Mission", "RB_Admin_Events"], _evtVeh] call _addAction;

private _evtMortar = ["RB_Evt_Mortar", "Trigger Mortar", "", { [true] remoteExec ["RB_fnc_spawnMortarBarrage", 2]; hint "Mortar Triggered"; }, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Mission", "RB_Admin_Events"], _evtMortar] call _addAction;

// --- Force Spawn
private _forceSpawnMenu = ["RB_Admin_ForceSpawn", "Force Spawn", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Mission"], _forceSpawnMenu] call _addAction;

private _forceVeh = [
    "RB_Admin_ForceVeh", "Force Spawn: Civilian Vehicle", "ui\icons\icon_plate.paa",
    { [true] remoteExec ["RB_fnc_debugForceSpawn", 2]; },
    { isNull (missionNamespace getVariable ["RB_CurrentEntity", objNull]) }
] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Mission", "RB_Admin_ForceSpawn"], _forceVeh] call _addAction;

// --- Civ Chance
private _civChanceMenu = ["RB_Admin_CivChance", "Civilian Foot Chance", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Mission"], _civChanceMenu] call _addAction;
for "_i" from 0 to 10 do {
    private _val = _i / 10;
    private _action = [
        format ["RB_Admin_CivChance_%1", _val], format ["Chance: %1", _val], "",
        { params ["_t", "_p", "_a"]; missionNamespace setVariable ["RB_CivilianChance", _a#0, true]; hint format ["Chance set to: %1", _a#0]; },
        { true }, {}, [_val]
    ] call ace_interact_menu_fnc_createAction;
    [_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Mission", "RB_Admin_CivChance"], _action] call _addAction;
};

// --- Reset Checkpoint (Uses existing logic, kept inline for safety)
private _reset = [
    "RB_Admin_ResetCheckpoint", "Reset Checkpoint", "ui\icons\icon_search.paa",
    {
        [] spawn {
            systemChat "Resetting checkpoint...";
            missionNamespace setVariable ["RB_CurrentEntity", nil, true];
            missionNamespace setVariable ["rb_processingInProgress", false, true];
            missionNamespace setVariable ["RB_SpawnerRunning", false, true];
            if (!isNil "RB_SpawnerHandle") then { terminate RB_SpawnerHandle; RB_SpawnerHandle = nil; };
            { if (_x getVariable ["rb_isCivilian", false]) then { deleteVehicle _x; }; } forEach allUnits;
            { if (_x getVariable ["rb_isCivilianVehicle", false]) then { { deleteVehicle _x } forEach crew _x; deleteVehicle _x; }; } forEach vehicles;
            sleep 2;
            missionNamespace setVariable ["RB_CurrentEntity", nil, true];
            RB_SpawnerHandle = [] spawn RB_fnc_system_trafficLoop;
            systemChat "Checkpoint reset complete.";
        };
    }, { true }
] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Mission"], _reset] call _addAction;


// ============================================================================================
// 3. PLAYER & LOGISTICS (Heal, Points, Arsenal)
// ============================================================================================
private _playerMenu = ["RB_Admin_Players", "Player and Logistics", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin"], _playerMenu] call _addAction;

private _cheatHeal = ["RB_Cheat_Heal", "Heal All (BLUFOR)", "", {
    { if (side _x == west && alive _x) then { [_x] remoteExec ["ace_medical_treatment_fnc_fullHealLocal", _x]; }; } forEach allUnits;
    hint "All BLUFOR units healed.";
}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Players"], _cheatHeal] call _addAction;

private _cheatArsenal = ["RB_Cheat_Arsenal", "Unlock Configured Items", "", {
    private _box = missionNamespace getVariable ["RB_Arsenal", objNull];
    if (!isNull _box) then {
        private _unlocks = [];
        _unlocks append (missionNamespace getVariable ["RB_ArsenalAlwaysAvailable", []]);
        _unlocks append (missionNamespace getVariable ["RB_FactionExtraItems", []]);
        private _options = missionNamespace getVariable ["RB_LogisticsOptions", []];
        {
            if !((_x select 0) in ["Vehicles", "Turrets", "Reinforcements"]) then {
                { _unlocks append (_x select 1); } forEach (_x select 1);
            };
        } forEach _options;
        _unlocks = _unlocks arrayIntersect _unlocks;
        [_box, _unlocks, true] remoteExec ["ace_arsenal_fnc_addVirtualItems", 0, true];
        hint "All faction items unlocked.";
    };
}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Players"], _cheatArsenal] call _addAction;

// --- Points
private _pointsMenu = ["RB_Admin_Points", "Manage Points", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Players"], _pointsMenu] call _addAction;

private _menuAdd = ["RB_Pts_MenuAdd", "Add Points", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Players", "RB_Admin_Points"], _menuAdd] call _addAction;
{
    private _amt = _x;
    private _action = [
        format ["RB_Pts_Add_%1", _amt], format ["+%1 Points", _amt], "",
        { params ["_t", "_p", "_a"]; private _term = missionNamespace getVariable ["RB_Terminal", objNull]; _term setVariable ["rb_score", (_term getVariable ["rb_score", 0]) + (_a#0), true]; hint format ["Added %1 points.", _a#0]; },
        {true}, {}, [_amt]
    ] call ace_interact_menu_fnc_createAction;
    [_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Players", "RB_Admin_Points", "RB_Pts_MenuAdd"], _action] call _addAction;
} forEach [10, 25, 50, 100];

private _menuSub = ["RB_Pts_MenuSub", "Deduct Points", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Players", "RB_Admin_Points"], _menuSub] call _addAction;
{
    private _amt = _x;
    private _action = [
        format ["RB_Pts_Sub_%1", _amt], format ["-%1 Points", _amt], "",
        { params ["_t", "_p", "_a"]; private _term = missionNamespace getVariable ["RB_Terminal", objNull]; _term setVariable ["rb_score", (_term getVariable ["rb_score", 0]) - (_a#0), true]; hint format ["Deducted %1 points.", _a#0]; },
        {true}, {}, [_amt]
    ] call ace_interact_menu_fnc_createAction;
    [_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Players", "RB_Admin_Points", "RB_Pts_MenuSub"], _action] call _addAction;
} forEach [10, 25, 50, 100];

private _actionReset = [
    "RB_Pts_Reset", "Reset Score to 0", "",
    { (missionNamespace getVariable ["RB_Terminal", objNull]) setVariable ["rb_score", 0, true]; hint "Score reset."; }, {true}
] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Players", "RB_Admin_Points"], _actionReset] call _addAction;


// ============================================================================================
// 4. DIAGNOSTICS
// ============================================================================================
private _diagMenu = ["RB_Admin_Diag", "Diagnostics", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin"], _diagMenu] call _addAction;

private _diagOn = [
    "RB_Diag_On", "Enable Map Markers", "ui\icons\icon_search.paa",
    { [true] remoteExec ["RB_fnc_toggleDiagnostics", 2]; },
    { isNil "RB_DiagnosticsHandle" }
] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Diag"], _diagOn] call _addAction;

private _diagOff = [
    "RB_Diag_Off", "Disable Map Markers", "ui\icons\icon_clearpro.paa",
    { [false] remoteExec ["RB_fnc_toggleDiagnostics", 2]; },
    { !isNil "RB_DiagnosticsHandle" }
] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Diag"], _diagOff] call _addAction;