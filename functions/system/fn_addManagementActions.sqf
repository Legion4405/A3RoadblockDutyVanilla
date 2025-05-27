/*
    File: fn_addManagementActions.sqf
    Description: Roadblock management interactions (Start Processing, Clear Processed)
*/
params ["_object"];
if (isNull _object) exitWith {};


private _obj = _this select 0;

// Helper
private _addAction = {
    params ["_obj", "_path", "_action"];
    [_obj, 0, _path, _action] call ace_interact_menu_fnc_addActionToObject;
};

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
[_obj, ["ACE_MainActions", "RB_Terminal_Management"], _actionClear] call _addAction;

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

            [_entity, _checkpointPos] spawn {
                params ["_veh", "_dest"];
                private _speed = 5;
                private _tick = 0.05;

                private _from = getPosATL _veh;
                private _angle = _from getDir _dest;
                _veh setDir _angle;

                private _distance = _veh distance _dest;
                if (_distance < 1) exitWith {};
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

                _veh setPosATL _dest;

                private _gate = missionNamespace getVariable ["RB_Gate_1", objNull];
                if (!isNull _gate) then {
                    sleep 1;
                    _gate animate ["Door_1_rot", 0];
                };
            };
        };
        _entity setVariable ["rb_interactionEnabled", true, true];
        _entity setVariable ["readyForProcessing", false, true];
        _entity setVariable ["rb_isProcessed", true, true];

        // === Debug: Show illegal conditions
        private _contraband     = _entity getVariable ["cached_veh_contraband", []];
        private _plateMismatch  = _entity getVariable ["cached_veh_plateMismatch", false];
        private _nameMismatch   = _entity getVariable ["cached_veh_regNameMismatch", false];
        private _idMismatch     = _entity getVariable ["cached_veh_regIDMismatch", false];
        private _regOwner       = _entity getVariable ["cached_veh_regOwner", "Unknown"];

        private _violationsList = [];
        if (_contraband isNotEqualTo []) then { _violationsList pushBack "Contraband"; };
        if (_plateMismatch)  then { _violationsList pushBack "Plate Mismatch"; };
        if (_nameMismatch)   then { _violationsList pushBack "Name Mismatch"; };
        if (_idMismatch)     then { _violationsList pushBack "ID Mismatch"; };
        if (_regOwner == "Unknown") then { _violationsList pushBack "No Registered Owner"; };

        private _violationsText = if (_violationsList isEqualTo []) then {"None"} else {_violationsList joinString ", "};
        //hint format ["🚨 Vehicle Illegal Reasons:\n%1", _violationsText];

        [_entity] remoteExecCall ["RB_fnc_addVehicleActions", 0, _entity];





        missionNamespace setVariable ["rb_processingInProgress", true, true];
        missionNamespace setVariable ["RB_CurrentEntity", nil, true];
        missionNamespace setVariable ["RB_SpawnerRunning", false, true];


        // runCheckpointSpawner.sqf on the SERVER only
        [] remoteExec ["runCheckpointSpawner.sqf", 2];
    },
    {
        private _e = missionNamespace getVariable ["RB_CurrentEntity", objNull];
        if (isNull _e) exitWith { false };
        if (_e getVariable ["readyForProcessing", false] isEqualTo false) exitWith { false };
        !(missionNamespace getVariable ["rb_processingInProgress", false]) && { side group _e != east }
    }
] call ace_interact_menu_fnc_createAction;
[_obj, ["ACE_MainActions", "RB_Terminal_Management"], _actionStart] call _addAction;

// === Close Roadblock ===
private _closeRB = [
    "RB_Terminal_CloseRoadblock",            // action ID
    "Close Roadblock",                       // label
    "ui\icons\icon_abort.paa",               // icon (pick whatever)
    {
        // only server should flip the flag & pause spawner
        if (isServer) then {
            missionNamespace setVariable ["RB_RoadblockClosed", true, true];
            publicVariable "RB_RoadblockClosed";
        };
        "Roadblock Closed." call CBA_fnc_notify;
    },
    {
        // show this when not yet closed
        !(missionNamespace getVariable ["RB_RoadblockClosed", false])
    }
] call ace_interact_menu_fnc_createAction;
[_object, ["ACE_MainActions","RB_Terminal_Management"], _closeRB] call _addAction;

// === Open Roadblock ===
private _openRB = [
    "RB_Terminal_OpenRoadblock",
    "Open Roadblock",
    "ui\icons\icon_ok.paa",
    {
        if (isServer) then {
            missionNamespace setVariable ["RB_RoadblockClosed", false, true];
            publicVariable "RB_RoadblockClosed";
        };
        "Roadblock Opened." call CBA_fnc_notify;
    },
    {
        // show this only when currently closed
        missionNamespace getVariable ["RB_RoadblockClosed", false]
    }
] call ace_interact_menu_fnc_createAction;
[_object, ["ACE_MainActions","RB_Terminal_Management"], _openRB] call _addAction;

