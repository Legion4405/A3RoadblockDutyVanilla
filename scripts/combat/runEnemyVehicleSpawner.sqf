/*
    File: runEnemyVehicleSpawner.sqf
    Description: Modular enemy vehicle spawner with disguised enemy vehicles.
    Uses dynamic spawn/dir marker pairs (RB_VehSpawn_# and RB_VehSpawnDir_#).
*/

if (!isServer) exitWith {};

private _intensity = ["RB_EnemyVehicleFrequency", 1] call BIS_fnc_getParamValue;
private _delayRange = switch (_intensity) do {
    case 0: { [600, 960] };
    case 1: { [480, 900] };
    case 2: { [360, 600] };
    case 3: { [240, 480] };
    default { [480, 900] };
};

// === Main loop
while { true } do {
    private _minDelay = _delayRange select 0;
    private _maxDelay = _delayRange select 1;
    sleep (_minDelay + random (_maxDelay - _minDelay));
    if (({ isPlayer _x } count allPlayers) == 0) then { sleep 10; continue; };
    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then { sleep 10; continue; };

    // === Gather all valid spawn/dir marker pairs
    private _maxSpawns = 8;
    private _spawnPairs = [];
    for "_i" from 1 to _maxSpawns do {
        private _spawnName = format ["RB_VehSpawn_%1", _i];
        private _dirName   = format ["RB_VehSpawnDir_%1", _i];
        private _spawnPos = getMarkerPos _spawnName;
        private _dirPos   = getMarkerPos _dirName;
        if (!(_spawnPos isEqualTo [0,0,0]) && !(_dirPos isEqualTo [0,0,0])) then {
            _spawnPairs pushBack [_spawnPos, _dirPos];
        };
    };
    if (_spawnPairs isEqualTo []) exitWith {
        diag_log "[RB] ERROR: No valid vehicle spawn pairs found! Check your markers.";
        sleep 30;
        continue;
    };
    private _pair     = selectRandom _spawnPairs;
    private _spawnPos = _pair#0;
    private _dirPos   = _pair#1;

    private _holdPos  = getMarkerPos "RB_HoldPoint";
    if (_holdPos isEqualTo [0,0,0]) exitWith {
        diag_log "[RB] ERROR: RB_HoldPoint marker missing!";
        sleep 30;
        continue;
    };

    // === VARIANT SELECTION ===
    // 0 = standard enemy vehicle; 1 = disguised enemy in civilian vehicle
    private _variant = if ((random 1) < 0.125) then { 1 } else { 0 };  // 30% for disguised variant

    switch (_variant) do {
        case 0: {   // --- Standard enemy vehicle (original)
            private _vehPool = missionNamespace getVariable ["RB_EnemyVehiclePool", ["O_MRAP_02_hmg_F"]];
            private _infPool = missionNamespace getVariable ["RB_EnemyInfantryPool", ["O_Soldier_F"]];
            private _vehClass  = selectRandom _vehPool;

            private _veh = createVehicle [_vehClass, _spawnPos, [], 0, "NONE"];
            if (isNull _veh) then {
                diag_log format ["[RB] ERROR: Failed to create vehicle class '%1'", _vehClass];
                sleep 10; continue;
            };
            _veh setDir (_spawnPos getDir _dirPos);
            [_veh] remoteExec ["RB_fnc_addVehicleSalvageActions", 0, true];

            private _crewGroup = createGroup east;
            private _seatRoles  = fullCrew [_veh, "", true];
            private _totalSeats = count _seatRoles;
            private _hasDriver  = (_totalSeats > 0);
            private _hasGunner  = (_totalSeats > 1);

            if (_hasDriver) then {
                private _driverClass = selectRandom _infPool;
                private _driver = _crewGroup createUnit [_driverClass, _spawnPos, [], 0, "NONE"];
                if (!isNull _driver) then { _driver moveInDriver _veh; };
            };
            if (_hasGunner) then {
                private _gunnerClass = selectRandom _infPool;
                private _gunner = _crewGroup createUnit [_gunnerClass, _spawnPos, [], 0, "NONE"];
                if (!isNull _gunner) then { _gunner moveInGunner _veh; };
            };
            private _filled = 0;
            if (_hasDriver) then { _filled = _filled + 1; };
            if (_hasGunner) then { _filled = _filled + 1; };
            private _numPassengers = _totalSeats - _filled;
            if (_numPassengers < 0) then { _numPassengers = 0; };

            for "_i" from 1 to _numPassengers do {
                private _passClass = selectRandom _infPool;
                private _unit = _crewGroup createUnit [_passClass, _spawnPos, [], 0, "NONE"];
                if (!isNull _unit) then { _unit moveInAny _veh; };
            };

            sleep 0.5;
            _crewGroup setBehaviour "COMBAT";
            _crewGroup setSpeedMode "NORMAL";
            _crewGroup addVehicle _veh;

            // --- Random annulus waypoint
            private _radiusMin = 50;
            private _radiusMax = 150;
            private _angle = random 360;
            private _distance = _radiusMin + random (_radiusMax - _radiusMin);

            private _x = (_holdPos select 0) + (_distance * cos _angle);
            private _y = (_holdPos select 1) + (_distance * sin _angle);
            private _z = getTerrainHeightASL [_x, _y];
            private _targetPos = [_x, _y, _z];

            private _wp = _crewGroup addWaypoint [_targetPos, 0];
            _wp setWaypointType "UNLOAD";
            _wp setWaypointBehaviour "COMBAT";
            _wp setWaypointSpeed "NORMAL";
            _wp setWaypointCompletionRadius 50;
            _wp setWaypointPosition [[_x, _y, 0], 0];

            diag_log format [
                "[RB] [VARIANT 0] Spawned %1 with %2 crew (driver=%3, gunner=%4, passengers=%5) → waypoint %6",
                _vehClass, count (crew _veh), _hasDriver, _hasGunner, _numPassengers, _targetPos
            ];
        };

        case 1: {   // --- Disguised enemy in civilian vehicle (special logic)
            private _civVehPool = missionNamespace getVariable ["RB_CivilianVehiclePool", ["C_Offroad_01_F"]];
            private _infPool    = missionNamespace getVariable ["RB_EnemyInfantryPool", ["O_Soldier_F"]];
            private _vehClass   = selectRandom _civVehPool;

            private _veh = createVehicle [_vehClass, _spawnPos, [], 0, "NONE"];
            if (isNull _veh) then {
                diag_log format ["[RB] ERROR: Failed to create civilian vehicle class '%1'", _vehClass];
                sleep 10; continue;
            };
            _veh setDir (_spawnPos getDir _dirPos);
            [_veh] remoteExec ["RB_fnc_addVehicleSalvageActions", 0, true];

            private _crewGroup = createGroup east;
            private _seatRoles  = fullCrew [_veh, "", true];
            private _totalSeats = count _seatRoles;
            private _maxCrew = 6;
            private _crewToFill = _totalSeats min _maxCrew; // cap to 6

            private _hasDriver = (_crewToFill > 0);

            // Spawn & seat driver
            if (_hasDriver) then {
                private _driverClass = selectRandom _infPool;
                private _driver = _crewGroup createUnit [_driverClass, _spawnPos, [], 0, "NONE"];
                if (!isNull _driver) then { _driver moveInDriver _veh; };
            };
            // Remaining seats as passengers (no gunner logic for civs)
            private _filled = 0;
            if (_hasDriver) then { _filled = _filled + 1; };
            private _numPassengers = _crewToFill - _filled;
            if (_numPassengers < 0) then { _numPassengers = 0; };

            for "_i" from 1 to _numPassengers do {
                private _passClass = selectRandom _infPool;
                private _unit = _crewGroup createUnit [_passClass, _spawnPos, [], 0, "NONE"];
                if (!isNull _unit) then { _unit moveInAny _veh; };
            };

            sleep 0.5;
            _crewGroup setBehaviour "SAFE";
            _crewGroup setSpeedMode "LIMITED";
            _crewGroup addVehicle _veh;

            // --- Direct waypoint to RB_HoldPoint, speed LIMITED, radius 40
            private _wp = _crewGroup addWaypoint [_holdPos, 0];
            _wp setWaypointType "GETOUT";  // Failsafe
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
            _wp setWaypointCompletionRadius 75;
            _wp setWaypointPosition [_holdPos, 0];

            diag_log format [
                '[RB] [VARIANT 1] Spawned disguised civ vehicle %1 with %2 enemy crew (driver=%3, passengers=%4, capped at 6) → waypoint %5',
                _vehClass, count (crew _veh), _hasDriver, _numPassengers, _holdPos
            ];
        };
    };
};
