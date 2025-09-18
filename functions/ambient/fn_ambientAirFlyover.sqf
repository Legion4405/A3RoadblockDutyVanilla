/*
    File: fn_ambientAirFlyover.sqf
    Description: Spawns random rotary or fixed-wing flyovers every 5–20 minutes using pools set up in initServer.sqf.
    Has a 25% chance to spawn a close “pair” formation—each aircraft and its pilot/group is individually cleaned up on exit, death, or timeout.
*/

if (!isServer) exitWith {};

// Wait for pools to exist and be arrays
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

// --- Helper: Convert a 2D XY and desired AGL into an ASL 3D position ---
private _aglToASL = {
    params ["_xy", "_agl"];
    private _aslZ = getTerrainHeightASL _xy + _agl;
    [_xy select 0, _xy select 1, _aslZ]
};

// Main loop
while {true} do {
    private _delay = 120 + (random 900); // 2–15 min
    sleep _delay;

    // Validate pools again
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

    // --- Pair chance (kept at 40% like your last version) ---
    private _count = if (random 1 < 0.4) then {2} else {1};

    // === Calculate shared flight path once ===
    private _spawnDist = 10000;
    private _exitDist  = 10000;
    private _dir = random 360;

    // Formation offsets (relative to leader, XY only)
    private _formationAngle  = random 360;
    private _formationDist   = 15 + random 10;
    private _formationOffset = [
        _formationDist * cos _formationAngle,
        _formationDist * sin _formationAngle,
        0
    ];

    private _flybyDir  = _dir + (random 60 - 30); // scatter up to ±30°
    private _flybyDist = 3000 + random 3000;      // 3–6 km

    // Leader 2D route points (XY only)
    private _spawnXY_lead = [
        (_roadblock select 0) + _spawnDist * cos _dir,
        (_roadblock select 1) + _spawnDist * sin _dir
    ];
    private _flybyXY_lead = [
        (_roadblock select 0) + _flybyDist * cos _flybyDir,
        (_roadblock select 1) + _flybyDist * sin _flybyDir
    ];
    private _exitDir = _dir + 180;
    private _exitXY_lead = [
        (_roadblock select 0) + _exitDist * cos _exitDir,
        (_roadblock select 1) + _exitDist * sin _exitDir
    ];

    // Wingman 2D route (offset in XY)
    private _spawnXY_wing = [_spawnXY_lead select 0, _spawnXY_lead select 1, 0] vectorAdd _formationOffset;
    private _flybyXY_wing = [_flybyXY_lead select 0, _flybyXY_lead select 1, 0] vectorAdd _formationOffset;
    private _exitXY_wing  = [_exitXY_lead select 0,  _exitXY_lead select 1,  0] vectorAdd _formationOffset;

    // Desired AGL altitudes
    private _spawnAGL = if (_isHeli) then { 80 + random 60 } else { 400 + random 350 };
    private _flybyAGL = if (_isHeli) then { 70 + random 50 } else { 350 + random 200 };
    private _exitAGL  = if (_isHeli) then { 80 + random 60 } else { 400 + random 350 };

    // Convert AGL -> ASL for actual placement/reference
    private _spawnASL_lead = [_spawnXY_lead, _spawnAGL] call _aglToASL;
    private _flybyASL_lead = [_flybyXY_lead, _flybyAGL] call _aglToASL;
    private _exitASL_lead  = [_exitXY_lead,  _exitAGL]  call _aglToASL;

    private _spawnASL_wing = [[_spawnXY_wing select 0, _spawnXY_wing select 1], _spawnAGL] call _aglToASL;
    private _flybyASL_wing = [[_flybyXY_wing select 0, _flybyXY_wing select 1], _flybyAGL] call _aglToASL;
    private _exitASL_wing  = [[_exitXY_wing select 0,  _exitXY_wing select 1],  _exitAGL]  call _aglToASL;

    // Now spawn each aircraft with matching routes, collect for group cleanup
    private _aircraft = [];
    private _groups   = [];
    private _pilots   = [];
    private _exitXYs  = [];   // store XY for 2D exit check

    for "_i" from 0 to (_count - 1) do {
        private _isLeader = (_i == 0);

        private _spawnASL = if (_isLeader) then {_spawnASL_lead} else {_spawnASL_wing};
        private _flybyASL = if (_isLeader) then {_flybyASL_lead} else {_flybyASL_wing};
        private _exitASL  = if (_isLeader) then {_exitASL_lead}  else {_exitASL_wing};

        private _exitXY   = if (_isLeader) then {_exitXY_lead} else {[_exitXY_wing select 0, _exitXY_wing select 1]};

        private _side = civilian;
        private _grp  = createGroup _side;

        // Create near ground; correct to exact ASL right after
        private _veh  = createVehicle [_class, ASLToATL _spawnASL, [], 0, "FLY"];
        if (isNull _veh) exitWith { systemChat format ["[RB] Failed to spawn vehicle class: %1", _class]; };

        _veh setPosASL _spawnASL;

        private _heading = [_spawnASL, AGLToASL _roadblock] call BIS_fnc_dirTo;
        _veh setDir _heading;

        _veh setVelocityModelSpace [80 + random 20, 0, 0];
        _veh setCaptive true;
        _veh engineOn true;

        private _desiredAGL = if (_isHeli) then {70 + random 40} else {350 + random 200};
        _veh flyInHeight _desiredAGL;

        // Crew
        private _crewClass = getText (configFile >> "CfgVehicles" >> _class >> "crew");
        if (_crewClass == "") then { _crewClass = "C_man_pilot_F"; }; // Civilian pilot fallback
        private _crewman = _grp createUnit [_crewClass, ASLToATL _spawnASL, [], 0, "NONE"];
        _crewman moveInDriver _veh;

        _grp setBehaviour "CARELESS";
        { _x setBehaviour "CARELESS" } forEach (units _grp);
        _veh setBehaviour "CARELESS";

        // Waypoints
        private _wp1 = _grp addWaypoint [ASLToATL _flybyASL, 0];
        _wp1 setWaypointType "MOVE";
        _wp1 setWaypointSpeed "FULL";
        _wp1 setWaypointBehaviour "CARELESS";

        private _wp2 = _grp addWaypoint [ASLToATL _exitASL, 1];
        _wp2 setWaypointType "MOVE";
        _wp2 setWaypointSpeed "FULL";
        _wp2 setWaypointBehaviour "CARELESS";

        // Collect for group despawn
        _aircraft pushBack _veh;
        _groups   pushBack _grp;
        _pilots   pushBack _crewman;
        _exitXYs  pushBack _exitXY;
    };

    // Monitor each aircraft (fix: clean 2D distance; removed bad line)
    for "_j" from 0 to ((count _aircraft) - 1) do {
        private _veh    = _aircraft select _j;
        private _grp    = _groups select _j;
        private _pilot  = _pilots select _j;
        private _exitXY = _exitXYs select _j;
        private _timeout = time + 360;

        [_veh, _grp, _pilot, _exitXY, _timeout] spawn {
            params ["_veh", "_grp", "_pilot", "_exitXY", "_timeout"];
            waitUntil {
                sleep 2;
                (!alive _veh)
                || (!alive _pilot)
                || ((getPos _veh) distance2D _exitXY < 1500)
                || (time > _timeout)
            };
            if (!isNull _veh) then { deleteVehicle _veh; };
            if (!isNull _grp) then { deleteGroup _grp; };
            if (!isNull _pilot) then { deleteVehicle _pilot; };
        };
    };
};
