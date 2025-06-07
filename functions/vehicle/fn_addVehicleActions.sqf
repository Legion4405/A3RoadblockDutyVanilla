/*
    File: fn_addVehicleActions.sqf
    Description: Adds ACE interaction menu for civilian vehicles. MP + JIP Safe.
*/

params ["_vehicle"];
if (!hasInterface) exitWith {};
if (!(_vehicle isKindOf "LandVehicle")) exitWith {};
if (_vehicle getVariable ["rb_hasActions", false]) exitWith {};

_vehicle setVariable ["rb_hasActions", true, true];

// (continue with ACE action setup)


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
        private _reg = _target getVariable ["veh_registration", ["Unknown", "UNKNOWN", "XXXXXXX"]];
        private _msg = format [
            "<t size='1.4' font='PuristaBold' align='center'>License Plate</t><br/><br/>" +
            "Plate Number: <t color='#00ffff'>%1</t>",
            _reg#2
        ];
        [_msg, 6] call ace_common_fnc_displayTextStructured;
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

// === Action: Impound Vehicle
private _actionImpound = [
    "RB_Veh_Impound",
    "Impound Vehicle",
    "ui\icons\icon_impound.paa",
    {
        params ["_target"];

        private _violations = [];

        // Plate, name, and ID mismatch violations
        if (_target getVariable ["cached_veh_plateMismatch", false]) then {
            _violations pushBack "Plate Mismatch";
        };
        if (_target getVariable ["cached_veh_regNameMismatch", false]) then {
            _violations pushBack "Name Mismatch";
        };
        if (_target getVariable ["cached_veh_regIDMismatch", false]) then {
            _violations pushBack "ID Mismatch";
        };

        // Contraband check
        if ((_target getVariable ["cached_veh_contraband", []]) isNotEqualTo []) then {
            _violations pushBack "Contraband";
        };

        // Owner check
        if ((_target getVariable ["cached_veh_regOwner", "Unknown"]) == "Unknown") then {
            _violations pushBack "No Registered Owner";
        };

        private _scoreChange = if (_violations isNotEqualTo []) then { 5 } else { -5 };
        private _color = if (_scoreChange > 0) then { "#00ff00" } else { "#ff0000" };

        private _score = RB_Terminal getVariable ["rb_score", 0];
        private _newScore = _score + _scoreChange;
        RB_Terminal setVariable ["rb_score", _newScore, true];

        private _result = format [
            "<t size='1.25' font='PuristaBold' color='%1'>Vehicle Impounded</t><br/>" +
            "<t color='#ffffff'>Violations: %2</t><br/>" +
            "Score Change: <t size='1.15' font='PuristaBold' color='%1'>%3</t><br/><br/>" +
            "<t size='1' color='#cccccc'>New Total Score: %4</t>",
            _color,
            if (_violations isEqualTo []) then { "None" } else { _violations joinString ", " },
            if (_scoreChange > 0) then { "+5" } else { "-5" },
            _newScore
        ];

        [_result, 10] remoteExec ["ace_common_fnc_displayTextStructured", 0];
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
            systemChat "❌ Processing markers missing.";
        };

        private _safePos = ASLToATL [_markerPos#0, _markerPos#1, getTerrainHeightASL _markerPos];
        _target setPosATL _safePos;
        _target setDir (_safePos getDir _dirPos);

        _target setVariable ["rb_vehicleProcessed", true, true];
        systemChat format ["✅ %1 sent to processing point.", typeOf _target];
    },
    { alive _target && { _target getVariable ["rb_isCivilianVehicle", false] } && { count crew _target == 0 } }
] call ace_interact_menu_fnc_createAction;

// === Action: Defuse Bomb
private _actionDefuse = [
    "RB_Veh_DefuseBomb",
    "Defuse Bomb",
    "ui\icons\icon_defuse.paa",
    {
        params ["_target"];
        private _hasBomb = _target getVariable ["veh_hasBomb", false];
        private _success = false;

        if (_hasBomb) then {
            {
                if ((attachedTo _x) == _target) exitWith {
                    deleteVehicle _x;
                    _success = true;
                };
            } forEach nearestObjects [_target, ["DemoCharge_F"], 5];
        };

        private _delta = if (_success) then { 10 } else { -5 };
        private _color = if (_delta > 0) then { "#00ff00" } else { "#ff0000" };
        private _score = RB_Terminal getVariable ["rb_score", 0];
        RB_Terminal setVariable ["rb_score", _score + _delta, true];

        private _result = if (_success) then {
            "<t size='1.25' font='PuristaBold' color='%1'>Bomb Defused</t><br/>" +
            "Score Change: <t size='1.15' font='PuristaBold' color='%1'>+10</t><br/><br/>" +
            "<t size='1' color='#cccccc'>New Total Score: %2</t>"
        } else {
            "<t size='1.25' font='PuristaBold' color='%1'>No Bomb Found</t><br/>" +
            "Score Change: <t size='1.15' font='PuristaBold' color='%1'>-5</t><br/><br/>" +
            "<t size='1' color='#cccccc'>New Total Score: %2</t>"
        };

        format [_result, _color, _score + _delta] remoteExec ["ace_common_fnc_displayTextStructured", 0];
        _target setVariable ["rb_bombDefuseAttempted", true, true];
        if (_success) then { _target setVariable ["veh_hasBomb", false, true]; };
    },
    {
        alive _target &&
        { _target getVariable ["rb_isCivilianVehicle", false] } &&
        { !(_target getVariable ["rb_bombDefuseAttempted", false]) }
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
