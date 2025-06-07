/*
    File: runEnemyVehicleSpawner.sqf
    Description: Spawns enemy vehicles at intervals, crews them from RB_EnemyInfantryPool,
                 and sends them to a random ground-level point in a 50–150 m ring around RB_HoldPoint.
*/

if (!isServer) exitWith {};

private _intensity = ["RB_EnemyVehicleFrequency", 1] call BIS_fnc_getParamValue;
private _delayRange = switch (_intensity) do {
    case 0: { [900, 1200] };  // Low: 15–20 min
    case 1: { [480, 600] };   // Medium: 8–10 min
    case 2: { [240, 360] };   // High: 4–6 min
    case 3: { [120, 240] };   // Very High: 2–4 min
    default { [480, 600] };
};

while { true } do {
    // Sleep random interval between min and max delay
    private _minDelay = _delayRange select 0;
    private _maxDelay = _delayRange select 1;
    sleep (_minDelay + random (_maxDelay - _minDelay));

    // Only spawn if players online and roadblock open
    if (({ isPlayer _x } count allPlayers) == 0) then { sleep 10; continue; };
    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then { sleep 10; continue; };

    // Get vehicle and infantry pools (with defaults)
    private _vehPool = missionNamespace getVariable ["RB_EnemyVehiclePool", ["O_MRAP_02_hmg_F"]];
    private _infPool = missionNamespace getVariable ["RB_EnemyInfantryPool", ["O_Soldier_F"]];

    // Select vehicle and get spawn/dir/hold markers
    private _vehClass  = selectRandom _vehPool;
    private _spawnPos  = getMarkerPos "RB_VehSpawn";
    private _facingPos = getMarkerPos "RB_VehSpawnDir";
    private _holdPos   = getMarkerPos "RB_HoldPoint";

    // Validate markers
    if (
        _spawnPos  isEqualTo [0,0,0] ||
        _facingPos isEqualTo [0,0,0] ||
        _holdPos   isEqualTo [0,0,0]
    ) then {
        diag_log "[RB] ERROR: One or more vehicle spawn/dir/hold markers missing!";
        sleep 10; continue;
    };

    // Spawn & orient vehicle
    private _veh = createVehicle [_vehClass, _spawnPos, [], 0, "NONE"];
    if (isNull _veh) then {
        diag_log format ["[RB] ERROR: Failed to create vehicle class '%1'", _vehClass];
        sleep 10; continue;
    };
    _veh setDir (_spawnPos getDir _facingPos);
    [_veh] remoteExec ["RB_fnc_addVehicleSalvageActions", 0, true];

    // Create an east-side group to crew the vehicle
    private _crewGroup = createGroup east;

    // Get total seats in vehicle
    private _seatRoles  = fullCrew [_veh, "", true];
    private _totalSeats = count _seatRoles;
    private _hasDriver  = (_totalSeats > 0);
    private _hasGunner  = (_totalSeats > 1);

    // Spawn & seat driver
    if (_hasDriver) then {
        private _driverClass = selectRandom _infPool;
        private _driver = _crewGroup createUnit [_driverClass, _spawnPos, [], 0, "NONE"];
        if (!isNull _driver) then { _driver moveInDriver _veh; };
    };

    // Spawn & seat gunner
    if (_hasGunner) then {
        private _gunnerClass = selectRandom _infPool;
        private _gunner = _crewGroup createUnit [_gunnerClass, _spawnPos, [], 0, "NONE"];
        if (!isNull _gunner) then { _gunner moveInGunner _veh; };
    };

    // Calculate remaining passengers
    private _filled = 0;
    if (_hasDriver) then { _filled = _filled + 1; };
    if (_hasGunner) then { _filled = _filled + 1; };
    private _numPassengers = _totalSeats - _filled;
    if (_numPassengers < 0) then { _numPassengers = 0; };

    // Spawn passengers
    for "_i" from 1 to _numPassengers do {
        private _passClass = selectRandom _infPool;
        private _unit = _crewGroup createUnit [_passClass, _spawnPos, [], 0, "NONE"];
        if (!isNull _unit) then { _unit moveInAny _veh; };
    };

    // Set group behavior
    sleep 0.5;
    _crewGroup setBehaviour "COMBAT";
    _crewGroup setSpeedMode "NORMAL";
    _crewGroup addVehicle _veh;

    // === Random annulus (ring) waypoint 50–150m from hold point ===
    private _radiusMin = 50;    // Minimum distance from center
    private _radiusMax = 150;   // Maximum distance from center
    private _angle = random 360;
    private _distance = _radiusMin + random (_radiusMax - _radiusMin);

    private _x = (_holdPos select 0) + (_distance * cos _angle);
    private _y = (_holdPos select 1) + (_distance * sin _angle);
    private _z = getTerrainHeightASL [_x, _y];
    private _targetPos = [_x, _y, _z];

    // (Optional) Debug marker for diagnostics
    private _debugName = format ["RB_WP_%1", diag_tickTime];
    createMarkerLocal [_debugName, _targetPos];
    _debugName setMarkerType "mil_dot";
    _debugName setMarkerColor "ColorRed";
    _debugName setMarkerText "Enemy WP";

    // Add the waypoint
    private _wp = _crewGroup addWaypoint [_targetPos, 0];
    _wp setWaypointType "UNLOAD";
    _wp setWaypointBehaviour "COMBAT";
    _wp setWaypointSpeed "NORMAL";
    _wp setWaypointCompletionRadius 50;
    _wp setWaypointPosition [[_x, _y, 0], 0];


    // Log for debugging
    diag_log format [
        "[RB] Spawned %1 with %2 crew (driver=%3, gunner=%4, passengers=%5) → waypoint %6",
        _vehClass,
        count (crew _veh),
        _hasDriver,
        _hasGunner,
        _numPassengers,
        _targetPos
    ];
};
