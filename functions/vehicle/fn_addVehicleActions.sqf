/*
    File: fn_addVehicleActions.sqf
    Description: Adds ACE interaction menu for civilian vehicles. MP + JIP Safe.
*/

params ["_vehicle"];
if (!hasInterface) exitWith {};
if (isNull _vehicle) exitWith {};
waitUntil {
    !isNull _vehicle &&
    { _vehicle in vehicles } &&
    { _vehicle isKindOf "LandVehicle" }
};
if (_vehicle getVariable ["rb_hasActions", false]) exitWith {};

// === Submenu
private _submenu = [
    "RB_Veh_Interactions",
    "Vehicle Interactions",
    "",
    {}, { true }
] call ace_interact_menu_fnc_createAction;
[_vehicle, 0, ["ACE_MainActions"], _submenu] call ace_interact_menu_fnc_addActionToObject;

// === Action: Check Registration
private _actionReg = [
    "RB_Veh_CheckReg",
    "Check Registration",
    "ui\icons\icon_idcheck.paa",
    {
        params ["_target"];
        private _reg = _target getVariable ["veh_registration", ["Unknown", "UNKNOWN", "XXXXXXX"]];
        private _msg = format [
            "<t size='1.4' font='PuristaBold' align='center'>Vehicle Registration</t><br/><br/>" +
            "Owner: <t color='#00ffff'>%1</t><br/>ID#: <t color='#00ffff'>%2</t><br/>Plate: <t color='#00ffff'>%3</t>",
            _reg#0, _reg#1, _reg#2
        ];
        [_msg, 7] call ace_common_fnc_displayTextStructured;
    },
    { alive _target }
] call ace_interact_menu_fnc_createAction;

// === Action: Check License Plate
private _actionPlate = [
    "RB_Veh_CheckPlate",
    "Check License Plate",
    "ui\icons\icon_plate.paa",
    {
        params ["_target"];
        private _plate = getPlateNumber _target; // Get the real license plate
        private _msg = format [
            "<t size='1.4' font='PuristaBold' align='center'>License Plate</t><br/><br/>" +
            "Plate Number: <t color='#00ffff'>%1</t>",
            _plate
        ];
        [_msg, 3] call ace_common_fnc_displayTextStructured;
    },
    { alive _target }
] call ace_interact_menu_fnc_createAction;


// === Action: Search Vehicle
private _actionSearch = [
    "RB_Veh_Search",
    "Search Vehicle",
    "ui\icons\icon_searchveh.paa",
    {
        params ["_target"];
        [_target] call RB_fnc_searchVehicle;
    },
    { alive _target }
] call ace_interact_menu_fnc_createAction;

// === Action: Impound Vehicle (Full, with Bomb/Defuse/Scoring)
private _actionImpound = [
    "RB_Veh_Impound",
    "Impound Vehicle",
    "ui\icons\icon_impound.paa",
    {
        params ["_target"];

        private _scoringMap = missionNamespace getVariable ["RB_ScoringTableMap", createHashMap];

        // Remove bomb object if present (always clean up)
        {
            if ((attachedTo _x) isEqualTo _target) then {
                deleteVehicle _x;
            };
        } forEach (nearestObjects [_target, ["DemoCharge_F"], 5]);

        private _hasBomb      = _target getVariable ["rb_hasBomb", false];
        private _hadBomb      = _target getVariable ["rb_hadBomb", false];
        private _bombDefused  = _target getVariable ["rb_bombDefused", false];

        private _scoreChange = 0;
        private _reasonLines = [];
        private _color = "#ff0000";

        if (_hasBomb && !_bombDefused) then {
            _scoreChange = _scoringMap getOrDefault ["impound_bomb_notdefused", -25];
            _reasonLines pushBack "❌ Bomb NOT defused before impounding";
            _color = "#ff0000";
        } else {
            private _violations = [];
            if (_target getVariable ["cached_veh_plateMismatch", false]) then { _violations pushBack "Plate Mismatch"; };
            if (_target getVariable ["cached_veh_regNameMismatch", false]) then { _violations pushBack "Name Mismatch"; };
            if (_target getVariable ["cached_veh_regIDMismatch", false]) then { _violations pushBack "ID Mismatch"; };
            if ((_target getVariable ["cached_veh_contraband", []]) isNotEqualTo []) then { _violations pushBack "Contraband"; };
            if ((_target getVariable ["cached_veh_regOwner", "Unknown"]) == "Unknown") then { _violations pushBack "No Registered Owner"; };
            
            if (_bombDefused || _hadBomb) then {
                _scoreChange = _scoringMap getOrDefault ["impound_bomb_defused", 20];
                _reasonLines pushBack "Defused bomb and impounded";
                _color = "#00ff00";
            } else {
                if (_violations isNotEqualTo []) then {
                    _scoreChange = 5;
                    _reasonLines pushBack format ["Impounded for: %1", _violations joinString ", "];
                    _color = "#00ff00";
                } else {
                    _scoreChange = -5;
                    _reasonLines pushBack "❌ No violations found";
                    _color = "#ff0000";
                };
            };
        };

        private _score = RB_Terminal getVariable ["rb_score", 0];
        private _newScore = _score + _scoreChange;

        private _reasonText = if (_reasonLines isNotEqualTo []) then {
            ("<br/>• " + (_reasonLines joinString "<br/>• "))
        } else {
            "None"
        };

        private _result = format [
            "<t size='1.25' font='PuristaBold' color='%1'>Vehicle Impounded</t><br/>" +
            "<t color='#ffffff'>Reason(s):</t> %2<br/>" +
            "Score Change: <t size='1.15' font='PuristaBold' color='%1'>%3</t><br/><br/>" +
            "<t size='1' color='#cccccc'>New Total Score: %4</t>",
            _color,
            _reasonText,
            if (_scoreChange > 0) then { "+" + str _scoreChange } else { str _scoreChange },
            _newScore
        ];
        [_result, 12] remoteExec ["ace_common_fnc_displayTextStructured", 0];

        deleteVehicle _target;
    },
    { alive _target && { crew _target isEqualTo [] } }
] call ace_interact_menu_fnc_createAction;


// === Action: Order Occupants Out
private _actionOrderOut = [
    "RB_Veh_OrderOut",
    "Order Out",
    "ui\icons\icon_orderout.paa",
    {
        params ["_target"];
        [_target] remoteExec ["RB_fnc_orderOccupantsOut", 2]; // Server only
    },
    { alive _target && { crew _target isNotEqualTo [] } }
] call ace_interact_menu_fnc_createAction;

// === Action: Mark as Processed
private _actionProcess = [
    "RB_Veh_MarkProcessed",
    "Mark as Processed",
    "ui\icons\icon_vehprocessed.paa",
    {
        params ["_target"];
        private _markerPos = getMarkerPos "RB_VehProcessPoint";
        private _dirPos = getMarkerPos "RB_VehProcessPointDir";
        if (_markerPos isEqualTo [0,0,0] || _dirPos isEqualTo [0,0,0]) exitWith {
            systemChat "Processing markers missing.";
        };

        private _safePos = ASLToATL [_markerPos#0, _markerPos#1, getTerrainHeightASL _markerPos];
        _target setPosATL _safePos;
        _target setDir (_safePos getDir _dirPos);

        _target setVariable ["rb_vehicleProcessed", true, true];
        // systemChat format ["%1 sent to processing point.", typeOf _target];
    },
    { alive _target && { _target getVariable ["rb_isCivilianVehicle", false] } && { count crew _target == 0 } }
] call ace_interact_menu_fnc_createAction;

// === Action: Defuse Bomb (Centralized Scoring, new system)
private _actionDefuse = [
    "RB_Veh_DefuseBomb",
    "Defuse Bomb",
    "ui\icons\icon_defuse.paa",
    {
        params ["_target", "_player"];
        private _scoringMap = missionNamespace getVariable ["RB_ScoringTableMap", createHashMap];

        if (_target getVariable ["rb_bombDefused", false]) exitWith {
            ["This vehicle has already been checked for bombs."] remoteExec ["hint", _player];
        };

        private _hadBomb = _target getVariable ["rb_hasBomb", false];
        private _bombRemoved = false;
        private _reasonLines = [];

        if (_hadBomb) then {
            {
                if ((attachedTo _x) == _target) exitWith {
                    deleteVehicle _x;
                    _bombRemoved = true;
                };
            } forEach (nearestObjects [_target, ["DemoCharge_F"], 5]);
        };

        if (_bombRemoved) then {
            _target setVariable ["rb_hasBomb", false, true];
            _target setVariable ["rb_hadBomb", true, true];
        };
        _target setVariable ["rb_bombDefused", true, true];

        private _delta = if (_bombRemoved)
            then { _scoringMap getOrDefault ["defuse_bomb", 20] }
            else { _scoringMap getOrDefault ["defuse_no_bomb", -10] };

        if (_bombRemoved) then {
            _reasonLines pushBack "Bomb successfully defused";
        } else {
            _reasonLines pushBack "No bomb found in vehicle";
        };

        private _score = RB_Terminal getVariable ["rb_score", 0];
        private _newScore = _score + _delta;

        private _reasonText = if (_reasonLines isNotEqualTo []) then {
            ("<br/>• " + (_reasonLines joinString "<br/>• "))
        } else {
            "None"
        };

        private _result = format [
            "<t size='1.25' font='PuristaBold' color='%1'>Defuse Bomb</t><br/>" +
            "<t color='#ffffff'>Reason(s):</t> %2<br/>" +
            "Score Change: <t size='1.15' font='PuristaBold' color='%1'>%3</t><br/><br/>" +
            "<t size='1' color='#cccccc'>New Total Score: %4</t>",
            if (_delta > 0) then { "#00ff00" } else { "#ff0000" },
            _reasonText,
            if (_delta > 0) then { "+" + str _delta } else { str _delta },
            _newScore
        ];

        [_result, 12] remoteExec ["ace_common_fnc_displayTextStructured", 0];
    },
    {
        alive _target
        && { _target getVariable ["rb_isCivilianVehicle", false] }
        && { !(_target getVariable ["rb_bombDefused", false]) }
    }
] call ace_interact_menu_fnc_createAction;


// === Register Actions
{
    [_vehicle, 0, ["ACE_MainActions", "RB_Veh_Interactions"], _x] call ace_interact_menu_fnc_addActionToObject;
} forEach [
    _actionReg,
    _actionPlate,
    _actionSearch,
    _actionImpound,
    _actionOrderOut,
    _actionProcess,
    _actionDefuse
];
