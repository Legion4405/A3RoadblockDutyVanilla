/*
    File: fn_clearProcessed.sqf
    Description: Batches all processed civilians into a processed vehicle, assigns a driver if needed, sends them to RB_ExitPoint, and scores everyone together in one message upon arrival. Civilians on foot are only scored if not in a processed vehicle. No double scoring!
*/
if (!isServer) exitWith {};

missionNamespace setVariable ["rb_processingInProgress", false, true];

if (isNil "RB_CivBatch") then { RB_CivBatch = [] };

// === Gather all processed, not yet cleared civilians
private _civs = allUnits select {
    _x getVariable ["rb_isProcessed", false] &&
    {!(_x getVariable ["rb_alreadyCleared", false])} &&
    {alive _x}
};

// === See if there is any processed vehicle available
private _vehList = vehicles select {
    _x getVariable ["rb_isCivilianVehicle", false] &&
    _x getVariable ["rb_vehicleProcessed", false] &&
    {!(_x getVariable ["rb_alreadyCleared", false])} &&
    {alive _x}
};

private _veh = if (count _vehList > 0) then { _vehList select 0 } else { objNull };
// If there is a processed vehicle but NO civilians to assign, process and score the vehicle immediately
if (!isNull _veh && {count _civs == 0}) exitWith {
    _veh setVariable ["rb_alreadyCleared", true, true];

    // --- Score the vehicle itself
    private _vehResult = [_veh] call RB_fnc_isCivilianIllegal;
    private _isVehIllegal = _vehResult select 0;
    private _vehReason = _vehResult select 1;
    private _vehBomb = _veh getVariable ["veh_hasBomb", false];
    private _vehDelta = if (_isVehIllegal || _vehBomb) then { -10 } else { 5 };

    private _score = RB_Terminal getVariable ["rb_score", 0];
    private _newScore = _score + _vehDelta;
    RB_Terminal setVariable ["rb_score", _newScore, true];

    private _resultText = format [
        "<t size='1.25' font='PuristaBold' color='%1'>Vehicle Processed</t><br/>%2<br/><br/><t size='1' font='PuristaMedium' color='#cccccc'>Total Score: %3</t>",
        if (_vehDelta > 0) then {"#00ff00"} else {"#ff0000"},
        if (_vehBomb) then { "❌ -10 (Undiscovered bomb)" } else {
            if (_isVehIllegal) then { format ["❌ -10 (%1)", _vehReason] } else { "✅ +5 (Clean vehicle)" }
        },
        _newScore
    ];
    [_resultText, 15] remoteExec ["ace_common_fnc_displayTextStructured", 0];

    deleteVehicle _veh;
};


if (!isNull _veh) then {
    _veh setVariable ["rb_alreadyCleared", true, true];

    // === Assign driver FIRST
    private _remainingCivs = +_civs;
    private _crew = crew _veh;
    private _driver = driver _veh;

    if (isNull _driver) then {
        private _driverCiv = if (count _remainingCivs > 0) then { _remainingCivs select 0 } else { objNull };
        if (!isNull _driverCiv) then {
            _driverCiv setVariable ["rb_alreadyCleared", true, true];
            unassignVehicle _driverCiv;
            _driverCiv assignAsDriver _veh;
            [_driverCiv] allowGetIn true;
            if (local _driverCiv) then {
                _driverCiv moveInDriver _veh;
            } else {
                [_driverCiv, _veh] remoteExecCall ["moveInDriver", _driverCiv];
            };
            RB_CivBatch pushBackUnique _driverCiv;
            _driver = _driverCiv;
            _remainingCivs deleteAt 0;
            // Make the vehicle belong to the driver's group
            private _group = group _driverCiv;
            _group addVehicle _veh;
        } else {
            diag_log "[RB] ERROR: No driver available for processed vehicle!";
        }
    } else {
        // Ensure vehicle ownership is set regardless
        (group _driver) addVehicle _veh;
    };

    // === Assign remaining processed civs as passengers/cargo
    {
        _x setVariable ["rb_alreadyCleared", true, true];
        unassignVehicle _x;
        _x assignAsCargo _veh;
        [_x] allowGetIn true;
        if (local _x) then {
            _x moveInCargo _veh;
        } else {
            [_x, _veh] remoteExecCall ["moveInCargo", _x];
        };
        _x disableAI "MOVE";
        RB_CivBatch pushBackUnique _x;
    } forEach _remainingCivs;
// === Ensure the vehicle actually drives to the exit using waypoints
if (!isNull _driver) then {
    private _dest = getMarkerPos "RB_ExitPoint";
    if (_dest isEqualTo [0,0,0]) exitWith { diag_log "[RB] ERROR: Marker 'RB_ExitPoint' not found."; };

    // Fetch or create the group
    private _vehGroup = group _driver;
    if (isNull _vehGroup || {_vehGroup == grpNull}) then {
        _vehGroup = createGroup civilian;
        [_driver] joinSilent _vehGroup;
    };

    // Remove old waypoints
    for "_i" from (count waypoints _vehGroup - 1) to 1 step -1 do {
        deleteWaypoint [_vehGroup, _i];
    };

    // Add waypoint to exit point
    private _wp = _vehGroup addWaypoint [_dest, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
    _wp setWaypointCompletionRadius 10;
    _vehGroup setCurrentWaypoint _wp;

    // Extra: Sync facing to exit if needed
    _veh setVariable ["rb_sentToExit", true, true];
};


} else {
    // === No vehicle: Civs walk to exit point using group waypoints (MP/JIP safe)
    private _dest = getMarkerPos "RB_ExitPoint";
    if (_dest isEqualTo [0,0,0]) exitWith { diag_log "[RB] ERROR: Marker 'RB_ExitPoint' not found."; };

    // To ensure all civs walk as a group, put them in one group (civilian side)
    private _civGroup = createGroup civilian;
    {
        _x setVariable ["rb_alreadyCleared", true, true];
        [_x] joinSilent _civGroup;
        _x enableAI "MOVE";
        _x setBehaviour "SAFE";
        _x setSpeedMode "LIMITED";
        RB_CivBatch pushBackUnique _x;
    } forEach _civs;

    // Remove old waypoints (if any)
    for "_i" from (count waypoints _civGroup - 1) to 1 step -1 do {
        deleteWaypoint [_civGroup, _i];
    };

    // Add one MOVE waypoint to exit
    private _wp = _civGroup addWaypoint [_dest, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
    _wp setWaypointCompletionRadius 8;
    _civGroup setCurrentWaypoint _wp;
};



// === Monitor for arrival at RB_ExitPoint (for both foot civs and vehicles/crew)
[] spawn {
    private _exit = getMarkerPos "RB_ExitPoint";
    if (_exit isEqualTo [0,0,0]) exitWith {};

    while {true} do {
        sleep 2;

        // === On-foot civilians who are NOT inside a processed vehicle
        private _arrivedCivs = RB_CivBatch select {
            alive _x &&
            (_x distance2D _exit < 10) &&
            {!(_x getVariable ["rb_scoreGiven", false])} &&
            // Only process if NOT inside a processed vehicle
            ((vehicle _x == _x) || { !(vehicle _x getVariable ["rb_sentToExit", false]) })
        };

        // === Vehicles with sentToExit flag, that arrived
        private _vehList = vehicles select {
            _x getVariable ["rb_sentToExit", false] &&
            (_x distance2D _exit < 10) &&
            {alive _x}
        };

        // === Batch and score all vehicle occupants and the vehicle in one notification
        {
            private _veh = _x;
            if (!alive _veh) then { continue };

            private _crew = crew _veh;
            private _deltaTotal = 0;
            private _resultList = [];

            // --- Score all crew and add to batch message
            {
                if (!alive _x) exitWith {};
                private _illegalResult = [_x] call RB_fnc_isCivilianIllegal;
                private _wasIllegal = _illegalResult select 0;
                private _reason = _illegalResult select 1;
                private _delta = if (_wasIllegal) then { -10 } else { 5 };
                _deltaTotal = _deltaTotal + _delta;
                _x setVariable ["rb_scoreGiven", true, true];

                _resultList pushBack format [
                    "%1: %2%3",
                    name _x,
                    if (_delta > 0) then {"✅ +5"} else {"❌ -10"},
                    if (_wasIllegal) then { format ["<br/><t color='#aaaaaa'>Reason: %1</t>", _reason] } else {""}
                ];

                deleteVehicle _x;
                RB_CivBatch = RB_CivBatch - [_x];
            } forEach _crew;

            // --- Score the vehicle itself
            private _vehResult = [_veh] call RB_fnc_isCivilianIllegal;
            private _isVehIllegal = _vehResult select 0;
            private _vehReason = _vehResult select 1;
            private _vehBomb = _veh getVariable ["veh_hasBomb", false];
            private _vehDelta = if (_isVehIllegal || _vehBomb) then { -10 } else { 5 };
            _deltaTotal = _deltaTotal + _vehDelta;

            _resultList pushBack (format ["🚗 Vehicle: %1", if (_vehBomb) then { "❌ -10 (Undiscovered bomb)" } else {
                if (_isVehIllegal) then { format ["❌ -10 (%1)", _vehReason] } else { "✅ +5 (Clean vehicle)" }
            }]);

            // --- Compose and show single notification for whole vehicle batch
            if (_deltaTotal != 0 || count _resultList > 0) then {
                private _score = RB_Terminal getVariable ["rb_score", 0];
                private _newScore = _score + _deltaTotal;
                RB_Terminal setVariable ["rb_score", _newScore, true];

                private _color = if (_deltaTotal >= 0) then { "#00ff00" } else { "#ff0000" };
                private _resultText = format [
                    "<t size='1.25' font='PuristaBold' color='%1'>Vehicle Processed</t><br/>%2<br/><br/><t size='1' font='PuristaMedium' color='#cccccc'>Total Score: %3</t>",
                    _color,
                    (_resultList joinString "<br/><br/>"),
                    _newScore
                ];
                [_resultText, 15] remoteExec ["ace_common_fnc_displayTextStructured", 0];
            };

            deleteVehicle _veh;
        } forEach _vehList;

        // === Score and delete foot civs (one at a time, like before)
        {
            RB_CivBatch = RB_CivBatch - [_x];
            private _illegalResult = [_x] call RB_fnc_isCivilianIllegal;
            private _wasIllegal = _illegalResult select 0;
            private _reason = _illegalResult select 1;
            private _delta = if (_wasIllegal) then { -10 } else { 5 };
            _x setVariable ["rb_scoreGiven", true, true];

            private _score = RB_Terminal getVariable ["rb_score", 0];
            RB_Terminal setVariable ["rb_score", _score + _delta, true];

            private _resultText = format [
                "<t size='1.25' font='PuristaBold' color='%1'>Civilian Released</t><br/>%2: %3%4<br/><br/><t size='1' font='PuristaMedium' color='#cccccc'>Total Score: %5</t>",
                if (_delta > 0) then {"#00ff00"} else {"#ff0000"},
                name _x,
                if (_delta > 0) then {"✅ +5"} else {"❌ -10"},
                if (_wasIllegal) then { format ["<br/><t color='#aaaaaa'>Reason: %1</t>", _reason] } else {""},
                _score + _delta
            ];
            [_resultText, 12] remoteExec ["ace_common_fnc_displayTextStructured", 0];

            deleteVehicle _x;
        } forEach _arrivedCivs;
    };
};
