/*
    File: fn_addTerminalActions.sqf
    Description: Adds ACE interaction options to the terminal.
*/

params ["_object"];
if (isNull _object) exitWith {};
if (_object getVariable ["rb_hasActions", false]) exitWith {};
_object setVariable ["rb_hasActions", true];

// === Show Score
private _scoreAction = [
    "RB_Terminal_ShowScore",
    "Check Score",
    "ui\icons\icon_score.paa",
    {
        params ["_target", "_player"];
        private _score = RB_Terminal getVariable ["rb_score", 0];
        private _color = if (_score > 0) then {"#00ff00"} else { if (_score < 0) then {"#ff0000"} else {"#ffffff"} };

        private _text = format [
            "<t size='1.5' font='PuristaBold' align='center' color='#ffffff'>Checkpoint Interface</t><br/><br/>" +
            "<t size='1.15' font='PuristaBold' color='#ffffff'>📊 Current Score:</t> " +
            "<t size='1.4' font='PuristaBold' color='%1'>%2</t><br/><br/>" +
            "<t size='1.1' font='PuristaMedium' color='#ffffff'>Scoring Rules:</t><br/>" +
            "<t size='1.05' font='PuristaLight' color='#dddddd'>" +
            "• +5  — Valid arrest<br/>" +
            "• +5  — Valid impound<br/>" +
            "• -5  — Wrongful arrest<br/>" +
            "• -5  — Invalid impound<br/><br/>" +
            "Ensure identities, contraband, registration, and plate data match up. Every mistake impacts your team's standing.</t>",
            _color, _score
        ];

        [_text, 9] call ace_common_fnc_displayTextStructured;
    },
    { true }
] call ace_interact_menu_fnc_createAction;



// === Logistics Menu
private _logisticsMenu = [
    "RB_Terminal_Logistics",
    "Logistics",
    "",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;

[_object, 0, ["ACE_MainActions"], _scoreAction] call ace_interact_menu_fnc_addActionToObject;
[_object, 0, ["ACE_MainActions"], _logisticsMenu] call ace_interact_menu_fnc_addActionToObject;

{
    private _category     = _x select 0;
    private _optionsArray = _x select 1;

    private _categoryID = format ["RB_Logistics_%1", _category];
    private _categoryMenu = [
        _categoryID,
        _category,
        "",
        {},
        { true }
    ] call ace_interact_menu_fnc_createAction;

    [_object, 0, ["ACE_MainActions", "RB_Terminal_Logistics"], _categoryMenu] call ace_interact_menu_fnc_addActionToObject;

    {
        private _index = _forEachIndex;
        private _label     = _x select 0;
        private _cost      = _x select 3;

        private _action = [
            format ["RB_Log_Request_%1_%2", _category, _index],
            format ["Request: %1 (%2 pts)", _label, _cost],
            "ui\icons\icon_logi.paa",
            {
                params ["_target", "_player"];
                [_player, _this select 2] spawn RB_fnc_handleLogisticsRequest;
            },
            { true },
            {},
            [_forEachIndex, _category]
        ] call ace_interact_menu_fnc_createAction;

        [_object, 0, ["ACE_MainActions", "RB_Terminal_Logistics", _categoryID], _action] call ace_interact_menu_fnc_addActionToObject;

    } forEach _optionsArray;
} forEach (missionNamespace getVariable ["RB_LogisticsOptions", []]);

// === Management Submenu
private _manageMenu = [
    "RB_Terminal_Management",
    "Roadblock Management",
    "",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions"], _manageMenu] call ace_interact_menu_fnc_addActionToObject;

// === Clear Processed
private _actionClear = [
    "RB_Terminal_ClearProcessed",
    "Clear Processed",
    "ui\icons\icon_clearpro.paa",
    {
        [] spawn RB_fnc_clearProcessed;
    },
    { true }
] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions", "RB_Terminal_Management"], _actionClear] call ace_interact_menu_fnc_addActionToObject;

// === Start Processing
private _actionStart = [
    "RB_Terminal_StartProcessing",
    "Start Processing",
    "ui\icons\icon_startpro.paa",
    {
        private _entity = missionNamespace getVariable ["RB_CurrentEntity", objNull];
        if (isNull _entity) exitWith { hint "❌ No entity is waiting."; };
        if (!(_entity getVariable ["readyForProcessing", false])) exitWith { hint "❌ Entity not ready for processing."; };
        if (side group _entity == east) exitWith { hint "⚠️ Cannot process enemies."; };

        private _checkpointPos = getMarkerPos "RB_Checkpoint";

        if (_entity isKindOf "Man") then {
            private _grp = group _entity;
            if (isNull _grp || {_grp == grpNull}) then {
                _grp = createGroup civilian;
                [_entity] joinSilent _grp;
            };
            private _wp = _grp addWaypoint [_checkpointPos, 0];
            _grp setCurrentWaypoint _wp;
        } else {
            // === Vehicle Processing ===
            private _gate = missionNamespace getVariable ["RB_Gate_1", objNull];
            if (!isNull _gate) then {
                _gate animate ["Door_1_rot", 1]; // Open gate
            };

            [_entity, getMarkerPos "RB_Checkpoint"] spawn {
                private _veh = _this select 0;
                private _dest = _this select 1;

                private _speed = 5; // meters per second
                private _tick = 0.05;

                // Calculate direction angle (heading) from vehicle to destination
                private _from = getPosATL _veh;
                private _dirVec = _dest vectorDiff _from;

                private _angle = (_from getDir _dest); // Accurate world direction
                _veh setDir _angle;

                // Movement logic
                private _distance = _veh distance _dest;
                if (_distance < 1) exitWith {}; // Already there

                private _steps = floor (_distance / (_speed * _tick));
                private _stepVec = [
                    ((_dest select 0) - (_from select 0)) / _steps,
                    ((_dest select 1) - (_from select 1)) / _steps,
                    0
                ];


                for "_i" from 1 to _steps do {
                    _veh setPosATL ((getPosATL _veh) vectorAdd _stepVec);
                    sleep _tick;
                };

                _veh setPosATL _dest; // Final snap to position

                // Close gate after arrival
                private _gate = missionNamespace getVariable ["RB_Gate_1", objNull];
                if (!isNull _gate) then {
                    sleep 1;
                    _gate animate ["Door_1_rot", 0];
                };
            };



        };

        _entity setVariable ["rb_isProcessed", true, true];
        _entity setVariable ["rb_interactionEnabled", true, true];
        _entity setVariable ["readyForProcessing", false, true]; // optional

        // 🛠️ Re-add ACE actions now that interaction is enabled
        if (!(_entity getVariable ["rb_hasActions", false])) then {
            [_entity] call RB_fnc_addVehicleActions;
        };

        missionNamespace setVariable ["rb_processingInProgress", true, true];
        missionNamespace setVariable ["RB_CurrentEntity", nil, true];
        missionNamespace setVariable ["RB_SpawnerRunning", false, true];

        [] execVM "scripts\runCheckpointSpawner.sqf";
        systemChat "✅ Processing started. Entity now under review.";
    },
    {
        private _e = missionNamespace getVariable ["RB_CurrentEntity", objNull];
        if (isNull _e) exitWith { false };
        if (_e getVariable ["readyForProcessing", false] isEqualTo false) exitWith { false };
        !(missionNamespace getVariable ["rb_processingInProgress", false]) &&
        { side group _e != east }
    }
] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions", "RB_Terminal_Management"], _actionStart] call ace_interact_menu_fnc_addActionToObject;

// === Add top-level category for Save Progress
private _saveCategory = [
    "RB_Terminal_SaveCategory",
    "Save System",
    "",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;

[_object, 0, ["ACE_MainActions"], _saveCategory] call ace_interact_menu_fnc_addActionToObject;

// === Add Save Progress action under that category
private _actionSaveProgress = [
    "RB_Terminal_SaveProgress",
    "Save Progress",
    "ui\icons\icon_save.paa",
    {
        hint "💾 Save feature coming soon!";
    },
    { true }
] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions", "RB_Terminal_SaveCategory"], _actionSaveProgress] call ace_interact_menu_fnc_addActionToObject;

// === Admin Tools Submenu (visible only to admin/host/zeus)
private _isAdmin = (serverCommandAvailable "#kick") || {!isNull (getAssignedCuratorLogic player)};
if (_isAdmin) then {
    private _adminMenu = [
        "RB_Terminal_Admin",
        "Admin Tools",
        "",
        {},
        { true }
    ] call ace_interact_menu_fnc_createAction;
    [_object, 0, ["ACE_MainActions"], _adminMenu] call ace_interact_menu_fnc_addActionToObject;

    // === Reset Checkpoint
private _reset = [
    "RB_Admin_ResetCheckpoint",
    "Reset Checkpoint",
    "ui\icons\icon_search.paa",
    {
        [] spawn {
            systemChat "🔄 Resetting checkpoint...";
            diag_log "[RB] Starting checkpoint reset";

            // === Clear all state flags immediately
            missionNamespace setVariable ["RB_CurrentEntity", nil, true];
            missionNamespace setVariable ["rb_processingInProgress", false, true];
            missionNamespace setVariable ["RB_SpawnerRunning", false, true];

            // === Terminate existing spawner thread (if any)
            if (!isNil "RB_SpawnerHandle") then {
                terminate RB_SpawnerHandle;
                RB_SpawnerHandle = nil;
                systemChat "⚠️ Terminated old spawner thread.";
                diag_log "[RB] Terminated old RB_SpawnerHandle thread";
            };

            // === Delete all foot civilians
            {
                if (_x getVariable ["rb_isCivilian", false]) then {
                    deleteVehicle _x;
                };
            } forEach allUnits;

            // === Delete civilian vehicles, crew, and any attached bombs
            {
                if (_x getVariable ["rb_isCivilianVehicle", false]) then {
                    {
                        if (_x getVariable ["rb_isCivilian", false]) then {
                            deleteVehicle _x;
                        };
                    } forEach crew _x;

                    // Remove attached explosives
                    private _bombs = nearestObjects [_x, ["DemoCharge_F"], 5];
                    {
                        private _bomb = _x;
                        if ((attachedTo _bomb) == _x) then {
                            deleteVehicle _bomb;
                        };
                    } forEach _bombs;

                    deleteVehicle _x;
                };
            } forEach vehicles;

            systemChat "⏳ Cleanup complete. Restarting spawner in 2 seconds...";
            diag_log "[RB] Cleanup complete. Delaying before spawner restart.";

            sleep 2;

            // === Final cleanup of flags before reinitializing
            missionNamespace setVariable ["RB_CurrentEntity", nil, true];
            missionNamespace setVariable ["rb_processingInProgress", false, true];
            missionNamespace setVariable ["RB_SpawnerRunning", false, true];

            // === Restart spawner thread and track its handle
            RB_SpawnerHandle = [] execVM "scripts\runCheckpointSpawner.sqf";
            systemChat "✅ Checkpoint reset complete. Spawner restarted.";
            diag_log "[RB] Spawner restarted successfully via reset terminal.";
        };
    },
    { true }
] call ace_interact_menu_fnc_createAction;


[_object, 0, ["ACE_MainActions", "RB_Terminal_Admin"], _reset] call ace_interact_menu_fnc_addActionToObject;
// === Time Scale Submenu
private _timeScaleMenu = [
    "RB_Admin_TimeScale",
    "Time Acceleration",
    "",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions", "RB_Terminal_Admin"], _timeScaleMenu] call ace_interact_menu_fnc_addActionToObject;

// === Add selectable time multipliers
{
    private _mult = _x;
    private _label = format ["Set Time Scale: %1x", _mult];

    private _action = [
        format ["RB_Admin_TimeScale_%1", _mult],
        _label,
        "",
        {
            params ["_target", "_player", "_args"];
            private _val = _args#0;
            [_val] remoteExec ["RB_fnc_setTimeMultiplier", 2];
            hint format ["⏱️ Time acceleration set to: %1x", _val];
        },
        { true },
        {},
        [_mult]
    ] call ace_interact_menu_fnc_createAction;

    [_object, 0, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_TimeScale"], _action] call ace_interact_menu_fnc_addActionToObject;
} forEach [1, 4, 12, 24];

// === Set Time of Day Submenu
private _setTimeMenu = [
    "RB_Admin_SetTime",
    "Set Time of Day",
    "",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions", "RB_Terminal_Admin"], _setTimeMenu] call ace_interact_menu_fnc_addActionToObject;

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

    [_object, 0, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_SetTime"], _action] call ace_interact_menu_fnc_addActionToObject;
} forEach [0, 4, 8, 12, 16, 20];

// === Weather Presets Submenu
private _weatherMenu = [
    "RB_Admin_Weather",
    "Weather Presets",
    "",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions", "RB_Terminal_Admin"], _weatherMenu] call ace_interact_menu_fnc_addActionToObject;

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

    [_object, 0, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Weather"], _action] call ace_interact_menu_fnc_addActionToObject;
} forEach ["Clear", "Cloudy", "Foggy", "Rain", "Storm"];


    // === Civilian Chance Submenu
    private _civChanceMenu = [
        "RB_Admin_CivChance",
        "Civilian on Foot Chance",
        "",
        {},
        { true }
    ] call ace_interact_menu_fnc_createAction;
    [_object, 0, ["ACE_MainActions", "RB_Terminal_Admin"], _civChanceMenu] call ace_interact_menu_fnc_addActionToObject;

    for "_i" from 0 to 10 do {
        private _val = _i / 10;
        private _action = [
            format ["RB_Admin_CivChance_%1", _val],
            format ["Set Chance: %1", _val],
            "",
            {
                params ["_target", "_player", "_args"];
                private _val = _args#0;
                missionNamespace setVariable ["RB_CivilianChance", _val, true];
                hint format ["🚶 Civilian spawn chance set to: %1", _val];
            },
            { true },
            {},
            [_val]
        ] call ace_interact_menu_fnc_createAction;
        [_object, 0, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_CivChance"], _action] call ace_interact_menu_fnc_addActionToObject;
    };
};
