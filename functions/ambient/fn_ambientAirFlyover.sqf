/*
    File: fn_ambientAirFlyover.sqf
    Description: Spawns random rotary or fixed-wing flyovers every 5-20 minutes using pools set up in initServer.sqf.
    Has a 25% chance to spawn a close “pair” formation.
*/

if (!isServer) exitWith {};

//systemChat "[RB] Ambient Air Flyover script started. Waiting for air pools...";

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
    private _delay = 60 + (random 600); // 5-20 min
    //systemChat format ["[RB] Next flyover in %1 seconds.", round _delay];
    sleep _delay;

    // Check if pools are still valid
    private _canHeli  = (count _rotary > 0);
    private _canPlane = (count _fixed  > 0);
    if (!_canHeli && !_canPlane) exitWith { systemChat "[RB] Both pools empty during runtime, script stopping."; };

    // Type selection (robust for SQF scoping!)
    private _isHeli = false;
    private _pool = [];
    if (_canHeli && _canPlane) then {
        _isHeli = random 1 < 0.5;
        _pool   = if (_isHeli) then {_rotary} else {_fixed};
    } else {
        _isHeli = _canHeli;
        _pool   = if (_isHeli) then {_rotary} else {_fixed};
    };

    if (count _pool == 0) then { systemChat "[RB] No valid class in selected pool, skipping."; continue; };

    private _class = selectRandom _pool;
    if (isNil "_class" || {_class == ""}) then { systemChat "[RB] Pool contained no valid class, skipping."; continue; };

    // --- 25% chance for a pair/formation ---
    private _count = if (random 1 < 0.25) then {2} else {1};
    //systemChat format ["[RB] Spawning %1 %2: %3", _count, if (_isHeli) then {"helicopter(s)"} else {"jet(s)"}, _class];

    // Random formation offset (for 2nd plane, 15-25 meters, random angle relative to leader)
    private _formationAngle = random 360;
    private _formationDist  = 15 + random 10; // 15–25m
    private _formationOffset = [
        _formationDist * cos _formationAngle,
        _formationDist * sin _formationAngle,
        0
    ]; // Used only for wingman

    for "_i" from 0 to (_count - 1) do {
        // 0 for leader, offset for wingman
        private _thisOffset = if (_i == 0) then {[0,0,0]} else {_formationOffset};

        // === Calculate spawn/waypoint positions (all 10km out, all 3-6km flyby, all with offset)
        private _spawnDist = 10000;
        private _exitDist  = 10000;
        private _dir = random 360;

        private _spawnPos = [
            (_roadblock select 0) + _spawnDist * cos _dir + (_thisOffset select 0),
            (_roadblock select 1) + _spawnDist * sin _dir + (_thisOffset select 1),
            0
        ];

        // Waypoint 1: 3000–6000m from checkpoint, random scatter, same offset
        private _flybyDir   = _dir + (random 60 - 30); // scatter up to 30deg
        private _flybyDist  = 3000 + random 3000;      // 3km–6km
        private _flybyPos   = [
            (_roadblock select 0) + _flybyDist * cos _flybyDir + (_thisOffset select 0),
            (_roadblock select 1) + _flybyDist * sin _flybyDir + (_thisOffset select 1),
            0
        ];

        // Waypoint 2: exit, far side of map, same offset
        private _exitDir = _dir + 180;
        private _exitPos = [
            (_roadblock select 0) + _exitDist * cos _exitDir + (_thisOffset select 0),
            (_roadblock select 1) + _exitDist * sin _exitDir + (_thisOffset select 1),
            0
        ];

        // Altitudes
        private _spawnAlt = if (_isHeli) then { 80 + random 60 } else { 400 + random 350 };
        private _flybyAlt = if (_isHeli) then { 70 + random 50 } else { 350 + random 200 };
        private _exitAlt  = if (_isHeli) then { 80 + random 60 } else { 400 + random 350 };

        // Set Z/ASL for each
        _spawnPos set [2, _spawnAlt];
        _flybyPos set [2, _flybyAlt];
        _exitPos  set [2, _exitAlt];

        // === Spawn aircraft as civilian, set heading toward checkpoint
        private _side = civilian;
        private _grp  = createGroup _side;
        private _veh  = createVehicle [_class, _spawnPos, [], 0, "FLY"];
        if (isNull _veh) exitWith { systemChat format ["[RB] Failed to spawn vehicle class: %1", _class]; };

        _veh setPosASL _spawnPos;
        // Set vehicle rotation toward checkpoint
        private _heading = [_spawnPos, _roadblock] call BIS_fnc_dirTo;
        _veh setDir _heading;

        _veh setVelocityModelSpace [80 + random 20, 0, 0];
        _veh setCaptive true;
        _veh engineOn true;
        private _desiredHeight = if (_isHeli) then {70 + random 40} else {350 + random 200};
        _veh flyInHeight _desiredHeight;

        // Crew (only pilot needed)
        private _crewClass = getText (configFile >> "CfgVehicles" >> _class >> "crew");
        if (_crewClass == "") then { _crewClass = "C_man_pilot_F"; }; // Civilian pilot fallback
        private _crewman = _grp createUnit [_crewClass, _spawnPos, [], 0, "NONE"];
        _crewman moveInDriver _veh;

        // Set group/crew/vehicle behaviour to CARELESS
        _grp setBehaviour "CARELESS";
        { _x setBehaviour "CARELESS" } forEach (units _grp);
        _veh setBehaviour "CARELESS";

        // Add waypoints: flyby (3–6km), then exit, both with offset
        private _wp1 = _grp addWaypoint [_flybyPos, 0];
        _wp1 setWaypointType "MOVE";
        _wp1 setWaypointSpeed "FULL";
        _wp1 setWaypointBehaviour "CARELESS";

        private _wp2 = _grp addWaypoint [_exitPos, 1];
        _wp2 setWaypointType "MOVE";
        _wp2 setWaypointSpeed "FULL";
        _wp2 setWaypointBehaviour "CARELESS";

        // Delete after reaching exit WP, or after 6 minutes, or if vehicle dies
        [_veh, _grp, _crewman, _exitPos] spawn {
            params ["_v", "_g", "_p", "_exit"];
            private _timeout = time + 360;
            waitUntil {
                sleep 3;
                (!alive _v) || (!alive _p) || ((getPosASL _v) distance _exit < 250) || (time > _timeout)
            };
            if (!isNull _v) then { deleteVehicle _v; };
            if (!isNull _g) then { deleteGroup _g; };
            if (!isNull _p) then { deleteVehicle _p; };
        };
    };
};
