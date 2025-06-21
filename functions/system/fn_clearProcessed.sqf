/*
    File: fn_clearProcessed.sqf
    Description: Releases processed civilians and vehicles, gives/takes points for correct or wrong releases, batches notifications with detailed reasons.
*/
if (!isServer) exitWith {};

missionNamespace setVariable ["rb_processingInProgress", false, true];

if (isNil "RB_CivBatch") then { RB_CivBatch = [] };

private _scoringMap = missionNamespace getVariable ["RB_ScoringTableMap", createHashMap];

// === Gather all processed, not yet cleared civilians
private _civs = allUnits select {
    _x getVariable ["rb_isProcessed", false] &&
    {!(_x getVariable ["rb_alreadyCleared", false])} &&
    {alive _x}
};

// === Find processed, not yet cleared civilian vehicles
private _vehList = vehicles select {
    _x getVariable ["rb_isCivilianVehicle", false] &&
    _x getVariable ["rb_vehicleProcessed", false] &&
    {!(_x getVariable ["rb_alreadyCleared", false])} &&
    {alive _x}
};

private _veh = if (count _vehList > 0) then { _vehList select 0 } else { objNull };

// === If vehicle exists but no civs, process vehicle immediately
if (!isNull _veh && {count _civs == 0}) exitWith {
    _veh setVariable ["rb_alreadyCleared", true, true];
    private _vehResult  = [_veh] call RB_fnc_judgeVehicle;
    private _vehDelta   = _vehResult select 2;
    private _vehStatus  = _vehResult select 3;
    private _vehReasons = _vehResult select 1;

    private _score   = RB_Terminal getVariable ["rb_score", 0];
    private _newScore = _score + _vehDelta;
    RB_Terminal setVariable ["rb_score", _newScore, true];

    private _vehReasonStr = if (_vehReasons isNotEqualTo []) then {
        "• " + (_vehReasons joinString "<br/>• ")
    } else { "" };

    private _color = if (_vehDelta > 0) then {"#00ff00"} else {"#ff0000"};
    private _resultText = format [
        "<t size='1.25' font='PuristaBold' color='%1'>Vehicle Released</t><br/>%2<br/><t color='#aaaaaa'>%3</t><br/><br/><t size='1' font='PuristaMedium' color='#cccccc'>Total Score: %4</t>",
        _color,
        _vehStatus,
        _vehReasonStr,
        _newScore
    ];
    [_resultText, 15] remoteExec ["ace_common_fnc_displayTextStructured", 0];
    deleteVehicle _veh;
};

if (!isNull _veh) then {
    _veh setVariable ["rb_alreadyCleared", true, true];

    private _remainingCivs = +_civs;
    private _crew = crew _veh;
    private _driver = driver _veh;

    // === Assign driver if needed
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
            private _group = group _driverCiv;
            _group addVehicle _veh;
        } else {
            diag_log "[RB] ERROR: No driver available for processed vehicle!";
        }
    } else {
        (group _driver) addVehicle _veh;
    };

    // Assign remaining as passengers
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

    // === Give vehicle waypoint to exit
    if (!isNull _driver) then {
        private _dest = getMarkerPos "RB_ExitPoint";
        if (_dest isEqualTo [0,0,0]) exitWith { diag_log "[RB] ERROR: Marker 'RB_ExitPoint' not found."; };
        private _vehGroup = group _driver;
        if (isNull _vehGroup || {_vehGroup == grpNull}) then {
            _vehGroup = createGroup civilian;
            [_driver] joinSilent _vehGroup;
        };
        for "_i" from (count waypoints _vehGroup - 1) to 1 step -1 do {
            deleteWaypoint [_vehGroup, _i];
        };
        private _wp = _vehGroup addWaypoint [_dest, 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointBehaviour "CARELESS";
        _wp setWaypointSpeed "LIMITED";
        _wp setWaypointCompletionRadius 10;
        _vehGroup setCurrentWaypoint _wp;
        _veh setVariable ["rb_sentToExit", true, true];
    }
} else {
    // === On-foot civs: walk to exit
    private _dest = getMarkerPos "RB_ExitPoint";
    if (_dest isEqualTo [0,0,0]) exitWith { diag_log "[RB] ERROR: Marker 'RB_ExitPoint' not found."; };
    private _civGroup = createGroup civilian;
    {
        _x setVariable ["rb_alreadyCleared", true, true];
        [_x] joinSilent _civGroup;
        _x enableAI "MOVE";
        _x setBehaviour "SAFE";
        _x setSpeedMode "LIMITED";
        RB_CivBatch pushBackUnique _x;
    } forEach _civs;
    for "_i" from (count waypoints _civGroup - 1) to 1 step -1 do {
        deleteWaypoint [_civGroup, _i];
    };
    private _wp = _civGroup addWaypoint [_dest, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointBehaviour "CARELESS";
    _wp setWaypointSpeed "LIMITED";
    _wp setWaypointCompletionRadius 8;
    _civGroup setCurrentWaypoint _wp;
};

// === Monitor for arrival at RB_ExitPoint
[] spawn {
    private _exit = getMarkerPos "RB_ExitPoint";
    if (_exit isEqualTo [0,0,0]) exitWith {};

    while {true} do {
        sleep 2;

        // === Arrived on-foot civs
        private _arrivedCivs = RB_CivBatch select {
            alive _x &&
            (_x distance2D _exit < 10) &&
            {!(_x getVariable ["rb_scoreGiven", false])} &&
            ((vehicle _x == _x) || { !(vehicle _x getVariable ["rb_sentToExit", false]) })
        };

        // === Arrived vehicles
        private _vehList = vehicles select {
            _x getVariable ["rb_sentToExit", false] &&
            (_x distance2D _exit < 10) &&
            {alive _x}
        };

        // === Score vehicles and their crew as batch
        private _scoringMap = missionNamespace getVariable ["RB_ScoringTableMap", createHashMap];

        {
            private _veh = _x;
            if (!alive _veh) then { continue };
            private _crew = crew _veh;
            private _vehResult  = [_veh] call RB_fnc_judgeVehicle;
            private _vehDelta   = _vehResult select 2;
            private _vehStatus  = _vehResult select 3;
            private _vehReasons = _vehResult select 1;
            private _deltaTotal = _vehDelta;

            // Compose vehicle reason string
            private _vehReasonStr = if (_vehReasons isNotEqualTo []) then {
                "• " + (_vehReasons joinString "<br/>• ")
            } else { "" };

            private _resultList = [
                format ["<b>🚗 Vehicle:</b> %1<br/><t color='#aaaaaa'>%2</t>", _vehStatus, _vehReasonStr]
            ];

            // Now per crew
            {
                if (!alive _x) exitWith {};
                private _releaseResult = [_x] call RB_fnc_judgeCivilian;
                private _arrestable = _releaseResult select 0;
                private _civReasons = _releaseResult select 1;
                private _scoreDelta = if (_arrestable) then {
                    _scoringMap getOrDefault ["wrong_release", -8]
                } else {
                    _scoringMap getOrDefault ["correct_release", 3]
                };
                _deltaTotal = _deltaTotal + _scoreDelta;
                _x setVariable ["rb_scoreGiven", true, true];

                private _civReasonStr = if (_civReasons isNotEqualTo []) then {
                    "• " + (_civReasons joinString "<br/>• ")
                } else { "None" };

                _resultList pushBack format [
                    "%1: %2<br/><t color='#aaaaaa'>%3</t>",
                    name _x,
                    if (_scoreDelta > 0) then {"✅ +3 (Innocent Released)"} else {"❌ -8 (Wrongful Release)"},
                    _civReasonStr
                ];

                deleteVehicle _x;
                RB_CivBatch = RB_CivBatch - [_x];
            } forEach _crew;

            private _score = RB_Terminal getVariable ["rb_score", 0];
            private _newScore = _score + _deltaTotal;
            RB_Terminal setVariable ["rb_score", _newScore, true];

            private _color = if (_deltaTotal >= 0) then { "#00ff00" } else { "#ff0000" };
            private _resultText = format [
                "<t size='1.25' font='PuristaBold' color='%1'>Vehicle Released</t><br/>%2<br/><br/><t size='1' font='PuristaMedium' color='#cccccc'>Total Score: %3</t>",
                _color,
                (_resultList joinString "<br/><br/>"),
                _newScore
            ];
            [_resultText, 15] remoteExec ["ace_common_fnc_displayTextStructured", 0];
            deleteVehicle _veh;
        } forEach _vehList;

        // === Score and delete foot civs
        {
            RB_CivBatch = RB_CivBatch - [_x];
            private _releaseResult = [_x] call RB_fnc_judgeCivilian;
            private _arrestable = _releaseResult select 0;
            private _civReasons = _releaseResult select 1;
            private _scoreDelta = if (_arrestable) then {
                _scoringMap getOrDefault ["wrong_release", -8]
            } else {
                _scoringMap getOrDefault ["correct_release", 3]
            };
            _x setVariable ["rb_scoreGiven", true, true];

            private _score = RB_Terminal getVariable ["rb_score", 0];
            RB_Terminal setVariable ["rb_score", _score + _scoreDelta, true];

            private _civReasonStr = if (_civReasons isNotEqualTo []) then {
                "• " + (_civReasons joinString "<br/>• ")
            } else { "None" };

            private _resultText = format [
                "<t size='1.25' font='PuristaBold' color='%1'>Civilian Released</t><br/>%2: %3<br/><t color='#aaaaaa'>%4</t><br/><br/><t size='1' font='PuristaMedium' color='#cccccc'>Total Score: %5</t>",
                if (_scoreDelta > 0) then {"#00ff00"} else {"#ff0000"},
                name _x,
                if (_scoreDelta > 0) then {"✅ +3 (Innocent Released)"} else {"❌ -8 (Wrongful Release)"},
                _civReasonStr,
                _score + _scoreDelta
            ];
            [_resultText, 12] remoteExec ["ace_common_fnc_displayTextStructured", 0];

            deleteVehicle _x;
        } forEach _arrivedCivs;
    };
};
