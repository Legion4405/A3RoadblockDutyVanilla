/*
    File: fn_clearProcessed.sqf
    Description: Clears processed civilians and vehicles, scores them via RB_Terminal using RB_fnc_isCivilianIllegal, and shows results globally.
*/

// === Clear processing lock immediately
missionNamespace setVariable ["rb_processingInProgress", false, true];

// === Init batch container (if needed)
if (isNil "RB_CivBatch") then { RB_CivBatch = [] };

private _checkpointPos = getMarkerPos "RB_Checkpoint";

// === Clear civilians marked as processed
private _civs = allUnits select {
    _x getVariable ["rb_isProcessed", false] &&
    {alive _x}
};

{
    private _veh = _x getVariable ["rb_vehicle", objNull];
    private _entered = false;

    if (!isNull _veh && {_veh getVariable ["rb_vehicleProcessed", false]} && {alive _veh}) then {
        _x assignAsCargo _veh;
        [_x] allowGetIn true;
        _x moveInCargo _veh;
        _entered = true;

    } else {
        private _nearbyVehs = nearestObjects [_x, ["Car"], 10] select {
            _x getVariable ["rb_vehicleProcessed", false]
        };

        if (!(_nearbyVehs isEqualTo [])) then {
            private _nearby = _nearbyVehs select 0;
            _x assignAsCargo _nearby;
            [_x] allowGetIn true;
            _x moveInCargo _nearby;
            _entered = true;
        };
    };

    if (!_entered) then {
        private _dest = getMarkerPos "RB_ExitPoint";
        if (_dest isEqualTo [0,0,0]) exitWith {
            diag_log "[RB] ERROR: Marker 'RB_ExitPoint' not found.";
        };

        _x enableAI "MOVE";
        _x stop false;
        doStop _x;

        _x setSpeedMode "LIMITED";
        _x setBehaviour "SAFE";
        _x doMove _dest;

        RB_CivBatch pushBack _x;
    };
} forEach _civs;

// === Monitor and score civilian batch
[] spawn {
    private _exit = getMarkerPos "RB_ExitPoint";
    if (_exit isEqualTo [0,0,0]) exitWith {};

    while {true} do {
        sleep 1;
        private _arrived = RB_CivBatch select {
            alive _x && (_x distance2D _exit < 10)
        };

        if (_arrived isEqualTo []) then { continue };

        {
            RB_CivBatch = RB_CivBatch - [_x];
        } forEach _arrived;

        private _deltaTotal = 0;
        private _resultList = [];

        {
            private _wasIllegal = [_x] call RB_fnc_isCivilianIllegal;
            private _delta = if (_wasIllegal) then { -10 } else { 5 };
            _deltaTotal = _deltaTotal + _delta;
            _resultList pushBack (format ["%1: %2 (via walk-out)", name _x, if (_delta > 0) then {"✅ +5"} else {"❌ -10"}]);

            deleteVehicle _x;
        } forEach _arrived;

        private _score = RB_Terminal getVariable ["rb_score", 0];
        private _newScore = _score + _deltaTotal;
        RB_Terminal setVariable ["rb_score", _newScore, true];

        private _color = if (_deltaTotal >= 0) then { "#00ff00" } else { "#ff0000" };
        private _resultText = format [
            "<t size='1.25' font='PuristaBold' color='%1'>Civilians Released</t><br/>%2<br/><br/><t size='1' font='PuristaMedium' color='#cccccc'>Total Score: %3</t>",
            _color,
            (_resultList joinString "<br/>"),
            _newScore
        ];
        [_resultText, 15] remoteExec ["ace_common_fnc_displayTextStructured", 0];
    };
};

// === Handle processed vehicles
private _vehList = vehicles select {
    _x getVariable ["rb_isCivilianVehicle", false] &&
    _x getVariable ["rb_vehicleProcessed", false] &&
    {alive _x}
};

{
    private _crew = crew _x;
    private _veh = _x;

    if (_crew isEqualTo [] || {alive _x} count _crew == 0) then {
        private _vehIllegal = [_veh] call RB_fnc_isCivilianIllegal;
        private _vehBomb = _veh getVariable ["veh_hasBomb", false];
        private _vehDelta = if (_vehIllegal || _vehBomb) then { -10 } else { 5 };

        private _score = RB_Terminal getVariable ["rb_score", 0];
        private _newScore = _score + _vehDelta;
        RB_Terminal setVariable ["rb_score", _newScore, true];

        private _label = if (_vehBomb) then { "❌ -10 (Undiscovered bomb)" } else {
            if (_vehIllegal) then { "❌ -10 (Illegal vehicle)" } else { "✅ +5 (Clean vehicle)" };
        };

        private _color = if (_vehDelta >= 0) then { "#00ff00" } else { "#ff0000" };
        private _resultText = format [
            "<t size='1.25' font='PuristaBold' color='%1'>Vehicle Processed (No Occupants)</t><br/>🚗 Vehicle: %2<br/><br/><t size='1' font='PuristaMedium' color='#cccccc'>Total Score: %3</t>",
            _color,
            _label,
            _newScore
        ];
        [_resultText, 15] remoteExec ["ace_common_fnc_displayTextStructured", 0];

        deleteVehicle _veh;
        continue;
    };

    // === Standard crew processing path
    private _driver = driver _veh;

    private _vehGroup = group _driver;
    if (isNull _vehGroup || _vehGroup == grpNull) then {
        _vehGroup = createGroup civilian;
        if (!isNull _driver) then {
            [_driver] joinSilent _vehGroup;
        };
    };

    {
        if (_x != _driver) then {
            [_x] joinSilent _vehGroup;
        };
        unassignVehicle _x;
        [_x] allowGetIn true;
        _x assignAsCargo _veh;
        _x moveInCargo _veh;
    } forEach _crew;

    _vehGroup selectLeader _driver;
    _vehGroup addVehicle _veh;
    _veh setVariable ["rb_cleanupCrew", _crew, false];

    _veh spawn {
        params ["_veh"];
        private _timeout = time + 10;
        private _crew = _veh getVariable ["rb_cleanupCrew", []];

        waitUntil {
            sleep 0.5;
            private _inside = { alive _x && _x in _veh } count _crew;
            private _total = { alive _x } count _crew;
            _inside == _total || time > _timeout
        };

        private _driver = driver _veh;
        if (isNull _driver) exitWith {
            diag_log format ["[RB] ERROR: Vehicle %1 has no driver to issue move command.", _veh];
        };

        private _dest = getMarkerPos "RB_ExitPoint";
        if (_dest isEqualTo [0,0,0]) exitWith {
            diag_log "[RB] ERROR: Marker 'RB_ExitPoint' not found.";
        };

        _veh setDestination [_dest, "LEADER PLANNED", true];
        _driver doMove _dest;

        waitUntil {
            sleep 1;
            (_veh distance2D _dest < 10)
        };

        private _deltaTotal = 0;
        private _resultList = [];

        {
            private _wasIllegal = [_x] call RB_fnc_isCivilianIllegal;
            private _delta = if (_wasIllegal) then { -10 } else { 5 };
            _deltaTotal = _deltaTotal + _delta;
            _resultList pushBack (format ["%1: %2 (via vehicle exit)", name _x, if (_delta > 0) then {"✅ +5"} else {"❌ -10"}]);

            if (alive _x) then { deleteVehicle _x };
        } forEach _crew;

        private _vehIllegal = [_veh] call RB_fnc_isCivilianIllegal;
        private _vehBomb = _veh getVariable ["veh_hasBomb", false];
        private _vehDelta = if (_vehIllegal || _vehBomb) then { -10 } else { 5 };
        _deltaTotal = _deltaTotal + _vehDelta;
        _resultList pushBack (format ["🚗 Vehicle: %1", if (_vehBomb) then { "❌ -10 (Undiscovered bomb)" } else {
            if (_vehIllegal) then { "❌ -10 (Illegal vehicle)" } else { "✅ +5 (Clean vehicle)" }
        }]);

        private _score = RB_Terminal getVariable ["rb_score", 0];
        private _newScore = _score + _deltaTotal;
        RB_Terminal setVariable ["rb_score", _newScore, true];

        private _color = if (_deltaTotal >= 0) then { "#00ff00" } else { "#ff0000" };
        private _resultText = format [
            "<t size='1.25' font='PuristaBold' color='%1'>Vehicle Processed</t><br/>%2<br/><br/><t size='1' font='PuristaMedium' color='#cccccc'>Total Score: %3</t>",
            _color,
            (_resultList joinString "<br/>"),
            _newScore
        ];
        [_resultText, 15] remoteExec ["ace_common_fnc_displayTextStructured", 0];

        deleteVehicle _veh;
    };
} forEach _vehList;
