/*
    File: fn_ambientAirFlyover.sqf
    Description: Spawns random rotary or fixed-wing flyovers every 5–20 minutes using pools set up in initServer.sqf.
    Has a 25% chance to spawn a close “pair” formation—each aircraft and its pilot/group is individually cleaned up on exit, death, or timeout.
*/

if (!isServer) exitWith {};

// Wait for pools to be present and arrays
waitUntil {
    private _rotary = missionNamespace getVariable ["RB_Ambient_Rotary_Selected", objNull];
    private _fixed  = missionNamespace getVariable ["RB_Ambient_Fixed_Selected", objNull];
    (_rotary isEqualType []) && (_fixed isEqualType [])
};

private _rotary = missionNamespace getVariable ["RB_Ambient_Rotary_Selected", []];
private _fixed  = missionNamespace getVariable ["RB_Ambient_Fixed_Selected", []];

if ((count _rotary == 0) && (count _fixed == 0)) exitWith { systemChat "[RB] No ambient air pools available. Exiting."; };

// Get roadblock position (marker must exist!)
private _roadblock = getMarkerPos "RB_Checkpoint";
if (_roadblock isEqualTo [0,0,0]) exitWith { systemChat "[RB] Marker 'RB_Checkpoint' not found!"; };

// Main loop
while {true} do {
    private _delay = 120 + (random 900); // 2-15 min
    sleep _delay;

    // Check if pools are still valid
    private _canHeli  = (count _rotary > 0);
    private _canPlane = (count _fixed  > 0);
    if (!_canHeli && !_canPlane) exitWith { systemChat "[RB] Both pools empty during runtime, script stopping."; };

    // Type selection
    private _isHeli = false;
    private _pool = [];
    if (_canHeli && _canPlane) then {
        _isHeli = random 1 < 0.65;
        _pool   = if (_isHeli) then {_rotary} else {_fixed};
    } else {
        _isHeli = _canHeli;
        _pool   = if (_isHeli) then {_rotary} else {_fixed};
    };

    if (count _pool == 0) then { systemChat "[RB] No valid class in selected pool, skipping."; continue; };

    private _class = selectRandom _pool;
    if (isNil "_class" || {_class == ""}) then { systemChat "[RB] Pool contained no valid class, skipping."; continue; };

    // --- 25% chance for a pair/formation ---
    private _count = if (random 1 < 0.4) then {2} else {1};

    // === Calculate shared flight path once ===
    private _spawnDist = 10000;
    private _exitDist  = 10000;
    private _dir = random 360;

    // Formation offsets (relative to leader)
    private _formationAngle = random 360;
    private _formationDist  = 15 + random 10;
    private _formationOffset = [
        _formationDist * cos _formationAngle,
        _formationDist * sin _formationAngle,
        0
    ];

    private _flybyDir   = _dir + (random 60 - 30); // scatter up to 30deg
    private _flybyDist  = 3000 + random 3000;      // 3km–6km

    // Leader's route
    private _spawnPos_lead = [
        (_roadblock select 0) + _spawnDist * cos _dir,
        (_roadblock select 1) + _spawnDist * sin _dir,
        0
    ];
    private _flybyPos_lead = [
        (_roadblock select 0) + _flybyDist * cos _flybyDir,
        (_roadblock select 1) + _flybyDist * sin _flybyDir,
        0
    ];
    private _exitDir = _dir + 180;
    private _exitPos_lead = [
        (_roadblock select 0) + _exitDist * cos _exitDir,
        (_roadblock select 1) + _exitDist * sin _exitDir,
        0
    ];

    // Wingman's route (same heading, offset applied throughout)
    private _spawnPos_wing = _spawnPos_lead vectorAdd _formationOffset;
    private _flybyPos_wing = _flybyPos_lead vectorAdd _formationOffset;
    private _exitPos_wing  = _exitPos_lead vectorAdd _formationOffset;

    // Altitudes
    private _spawnAlt = if (_isHeli) then { 80 + random 60 } else { 400 + random 350 };
    private _flybyAlt = if (_isHeli) then { 70 + random 50 } else { 350 + random 200 };
    private _exitAlt  = if (_isHeli) then { 80 + random 60 } else { 400 + random 350 };

    _spawnPos_lead set [2, _spawnAlt];   _flybyPos_lead set [2, _flybyAlt];   _exitPos_lead set [2, _exitAlt];
    _spawnPos_wing set [2, _spawnAlt];   _flybyPos_wing set [2, _flybyAlt];   _exitPos_wing set [2, _exitAlt];

    // Now spawn each aircraft with matching routes, collect for group cleanup
    private _aircraft = [];
    private _groups   = [];
    private _pilots   = [];
    private _exitPoss = [];

    for "_i" from 0 to (_count - 1) do {
        private _isLeader = (_i == 0);
        private _spawnPos = if (_isLeader) then {_spawnPos_lead} else {_spawnPos_wing};
        private _flybyPos = if (_isLeader) then {_flybyPos_lead} else {_flybyPos_wing};
        private _exitPos  = if (_isLeader) then {_exitPos_lead}  else {_exitPos_wing};

        private _side = civilian;
        private _grp  = createGroup _side;
        private _veh  = createVehicle [_class, _spawnPos, [], 0, "FLY"];
        if (isNull _veh) exitWith { systemChat format ["[RB] Failed to spawn vehicle class: %1", _class]; };

        _veh setPosASL _spawnPos;
        private _heading = [_spawnPos, _roadblock] call BIS_fnc_dirTo;
        _veh setDir _heading;
        _veh setVelocityModelSpace [80 + random 20, 0, 0];
        _veh setCaptive true;
        _veh engineOn true;
        private _desiredHeight = if (_isHeli) then {70 + random 40} else {350 + random 200};
        _veh flyInHeight _desiredHeight;

        // Crew
        private _crewClass = getText (configFile >> "CfgVehicles" >> _class >> "crew");
        if (_crewClass == "") then { _crewClass = "C_man_pilot_F"; }; // Civilian pilot fallback
        private _crewman = _grp createUnit [_crewClass, _spawnPos, [], 0, "NONE"];
        _crewman moveInDriver _veh;

        _grp setBehaviour "CARELESS";
        { _x setBehaviour "CARELESS" } forEach (units _grp);
        _veh setBehaviour "CARELESS";

        // Add waypoints—identical except for the offset
        private _wp1 = _grp addWaypoint [_flybyPos, 0];
        _wp1 setWaypointType "MOVE";
        _wp1 setWaypointSpeed "FULL";
        _wp1 setWaypointBehaviour "CARELESS";

        private _wp2 = _grp addWaypoint [_exitPos, 1];
        _wp2 setWaypointType "MOVE";
        _wp2 setWaypointSpeed "FULL";
        _wp2 setWaypointBehaviour "CARELESS";

        // Collect for group despawn
        _aircraft pushBack _veh;
        _groups   pushBack _grp;
        _pilots   pushBack _crewman;
        _exitPoss pushBack _exitPos;
    };

    // For each aircraft, monitor both flyby and exit waypoint positions
    for "_j" from 0 to ((count _aircraft) - 1) do {
        private _veh     = _aircraft select _j;
        private _grp     = _groups select _j;
        private _pilot   = _pilots select _j;
        private _exitPos = _exitPoss select _j;
        private _timeout = time + 360;

        [_veh, _grp, _pilot, _exitPos, _timeout] spawn {
            params ["_veh", "_grp", "_pilot", "_exitPos", "_timeout"];
            waitUntil {
                sleep 2;
                (!alive _veh)
                || (!alive _pilot)
                || ((getPosASL _veh) distance _exitPos < 1500)
                || (time > _timeout)
            };
            if (!isNull _veh) then { deleteVehicle _veh; };
            if (!isNull _grp) then { deleteGroup _grp; };
            if (!isNull _pilot) then { deleteVehicle _pilot; };
        };
    };


};
