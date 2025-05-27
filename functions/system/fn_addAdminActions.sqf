/*
    File: fn_addAdminActions.sqf
    Description: Adds admin-only ACE actions for time, weather, and civilian chance
*/

private _obj = _this select 0;

// Helper function
private _addAction = {
    params ["_obj", "_path", "_action"];
    [_obj, 0, _path, _action] call ace_interact_menu_fnc_addActionToObject;
};

// Check admin status
private _isAdmin = (serverCommandAvailable "#kick") || {!isNull (getAssignedCuratorLogic player)};
if (!_isAdmin) exitWith {};

// === Time Scale Submenu
private _timeScaleMenu = [
    "RB_Admin_TimeScale",
    "Time Acceleration",
    "",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin"], _timeScaleMenu] call _addAction;

{
    private _mult = _x;
    private _label = format ["Set Time Scale: %1x", _mult];

    private _action = [
        format ["RB_Admin_TimeScale_%1", _mult],
        _label,
        "",
        {
            params ["_target", "_player", "_args"];
            [_args#0] remoteExec ["RB_fnc_setTimeMultiplier", 2];
            hint format ["⏱️ Time acceleration set to: %1x", _args#0];
        },
        { true },
        {},
        [_mult]
    ] call ace_interact_menu_fnc_createAction;

    [_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_TimeScale"], _action] call _addAction;
} forEach [1, 4, 12, 24];

// === Time of Day Presets
private _setTimeMenu = [
    "RB_Admin_SetTime",
    "Set Time of Day",
    "",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin"], _setTimeMenu] call _addAction;

{
    private _hour = _x;
    private _label = format ["Set Time: %1:00", _hour];

    private _action = [
        format ["RB_Admin_SetHour_%1", _hour],
        _label,
        "",
        {
            params ["_target", "_player", "_args"];
            [_args#0] remoteExec ["RB_fnc_setTimeOfDay", 2];
            hint format ["🕒 Time set to %1:00", _args#0];
        },
        { true },
        {},
        [_hour]
    ] call ace_interact_menu_fnc_createAction;

    [_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_SetTime"], _action] call _addAction;
} forEach [0, 4, 8, 12, 16, 20];

// === Weather Presets
private _weatherMenu = [
    "RB_Admin_Weather",
    "Weather Presets",
    "",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin"], _weatherMenu] call _addAction;

{
    private _preset = _x;
    private _action = [
        format ["RB_Admin_Weather_%1", _preset],
        _preset,
        "",
        {
            params ["_target", "_player", "_args"];
            [_args#0] remoteExec ["RB_fnc_setWeatherPreset", 2];
            hint format ["☁️ Weather changed to: %1", _args#0];
        },
        { true },
        {},
        [_preset]
    ] call ace_interact_menu_fnc_createAction;

    [_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Weather"], _action] call _addAction;
} forEach ["Clear", "Cloudy", "Foggy", "Rain", "Storm"];

// === Civilian Foot Chance
private _civChanceMenu = [
    "RB_Admin_CivChance",
    "Civilian on Foot Chance",
    "",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Admin"], _civChanceMenu] call _addAction;

for "_i" from 0 to 10 do {
    private _val = _i / 10;
    private _action = [
        format ["RB_Admin_CivChance_%1", _val],
        format ["Set Chance: %1", _val],
        "",
        {
            params ["_target", "_player", "_args"];
            missionNamespace setVariable ["RB_CivilianChance", _args#0, true];
            hint format ["🚶 Civilian spawn chance set to: %1", _args#0];
        },
        { true },
        {},
        [_val]
    ] call ace_interact_menu_fnc_createAction;

    [_obj, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_CivChance"], _action] call _addAction;
};

// === Reset Checkpoint
private _reset = [
    "RB_Admin_ResetCheckpoint",
    "Reset Checkpoint",
    "ui\icons\icon_search.paa",
    {
        [] spawn {
            systemChat "🔄 Resetting checkpoint...";
            diag_log "[RB] Starting checkpoint reset";

            missionNamespace setVariable ["RB_CurrentEntity", nil, true];
            missionNamespace setVariable ["rb_processingInProgress", false, true];
            missionNamespace setVariable ["RB_SpawnerRunning", false, true];

            if (!isNil "RB_SpawnerHandle") then {
                terminate RB_SpawnerHandle;
                RB_SpawnerHandle = nil;
                systemChat "⚠️ Terminated old spawner thread.";
                diag_log "[RB] Terminated old RB_SpawnerHandle thread";
            };

            {
                if (_x getVariable ["rb_isCivilian", false]) then {
                    deleteVehicle _x;
                };
            } forEach allUnits;

            {
                if (_x getVariable ["rb_isCivilianVehicle", false]) then {
                    {
                        if (_x getVariable ["rb_isCivilian", false]) then {
                            deleteVehicle _x;
                        };
                    } forEach crew _x;

                    private _bombs = nearestObjects [_x, ["DemoCharge_F"], 5];
                    {
                        if ((attachedTo _x) == _x) then {
                            deleteVehicle _x;
                        };
                    } forEach _bombs;

                    deleteVehicle _x;
                };
            } forEach vehicles;

            systemChat "⏳ Cleanup complete. Restarting spawner in 2 seconds...";
            diag_log "[RB] Cleanup complete. Delaying before spawner restart.";

            sleep 2;

            missionNamespace setVariable ["RB_CurrentEntity", nil, true];
            missionNamespace setVariable ["rb_processingInProgress", false, true];
            missionNamespace setVariable ["RB_SpawnerRunning", false, true];

            RB_SpawnerHandle = [] execVM "scripts\runCheckpointSpawner.sqf";
            systemChat "✅ Checkpoint reset complete. Spawner restarted.";
            diag_log "[RB] Spawner restarted successfully via reset terminal.";
        };
    },
    { true }
] call ace_interact_menu_fnc_createAction;

[_obj, ["ACE_MainActions", "RB_Terminal_Admin"], _reset] call _addAction;
