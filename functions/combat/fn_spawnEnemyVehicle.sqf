/*
    File: fn_spawnEnemyVehicle.sqf
    Description: Spawns a single enemy vehicle attack (either standard or disguised).
    Returns: The vehicle object (or objNull on failure).
*/

if (!isServer) exitWith { objNull };

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
    diag_log "[RB] ERROR: No valid vehicle spawn pairs found for enemy attack.";
    objNull
};

private _pair     = selectRandom _spawnPairs;
private _spawnPos = _pair#0;
private _dirPos   = _pair#1;

private _holdPos  = getMarkerPos "RB_HoldPoint";
if (_holdPos isEqualTo [0,0,0]) exitWith {
    diag_log "[RB] ERROR: RB_HoldPoint marker missing!";
    objNull
};

// === VARIANT SELECTION ===
// 0 = standard enemy vehicle; 1 = disguised enemy in civilian vehicle
private _variant = if ((random 1) < 0.22) then { 1 } else { 0 };

private _spawnedVeh = objNull;

switch (_variant) do {
    case 0: {   // --- Standard enemy vehicle
        private _vehPool = missionNamespace getVariable ["RB_EnemyVehiclePool", ["O_MRAP_02_hmg_F"]];
        private _infPool = missionNamespace getVariable ["RB_EnemyInfantryPool", ["O_Soldier_F"]];
        private _vehClass  = selectRandom _vehPool;

        _spawnedVeh = createVehicle [_vehClass, _spawnPos, [], 0, "NONE"];
        if (isNull _spawnedVeh) exitWith { diag_log format ["[RB] ERROR: Failed to create vehicle class '%1'", _vehClass]; };
        
        _spawnedVeh setDir (_spawnPos getDir _dirPos);
        [_spawnedVeh] remoteExec ["RB_fnc_addVehicleSalvageActions", 0, true];

        private _crewGroup = createGroup east;
        sleep 0.5;
        _crewGroup addVehicle _spawnedVeh;
        
        private _seatRoles  = fullCrew [_spawnedVeh, "", true];
        private _totalSeats = count _seatRoles;
        private _hasDriver  = (_totalSeats > 0);
        private _hasGunner  = (_totalSeats > 1);

        if (_hasDriver) then {
            private _driverClass = selectRandom _infPool;
            private _driver = _crewGroup createUnit [_driverClass, _spawnPos, [], 0, "NONE"];
            if (!isNull _driver) then { _driver moveInDriver _spawnedVeh; };
        };
        if (_hasGunner) then {
            private _gunnerClass = selectRandom _infPool;
            private _gunner = _crewGroup createUnit [_gunnerClass, _spawnPos, [], 0, "NONE"];
            if (!isNull _gunner) then { _gunner moveInGunner _spawnedVeh; };
        };
        
        private _filled = 0;
        if (_hasDriver) then { _filled = _filled + 1; };
        if (_hasGunner) then { _filled = _filled + 1; };
        private _numPassengers = _totalSeats - _filled;
        if (_numPassengers < 0) then { _numPassengers = 0; };

        for "_i" from 1 to _numPassengers do {
            private _passClass = selectRandom _infPool;
            private _unit = _crewGroup createUnit [_passClass, _spawnPos, [], 0, "NONE"];
            if (!isNull _unit) then { _unit moveInAny _spawnedVeh; };
        };

        _spawnedVeh enableAI "MOVE"; _spawnedVeh enableAI "PATH"; _spawnedVeh enableAI "ALL";
        { _x enableAI "MOVE"; _x enableAI "ALL"; } forEach crew _spawnedVeh;

        sleep 0.5;
        _crewGroup setBehaviour "COMBAT";
        _crewGroup setSpeedMode "NORMAL";
        _crewGroup addVehicle _spawnedVeh;

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

        diag_log format ["[RB] Spawned Enemy Vehicle: %1 -> %2", _vehClass, _targetPos];
    };

    case 1: {   // --- Disguised enemy in civilian vehicle
        private _civVehPool = missionNamespace getVariable ["RB_CivilianVehiclePool", ["C_Offroad_01_F"]];
        private _infPool    = missionNamespace getVariable ["RB_EnemyInfantryPool", ["O_Soldier_F"]];
        private _vehClass   = selectRandom _civVehPool;

        _spawnedVeh = createVehicle [_vehClass, _spawnPos, [], 0, "NONE"];
        if (isNull _spawnedVeh) exitWith { diag_log format ["[RB] ERROR: Failed to create civ vehicle class '%1'", _vehClass]; };
        
        _spawnedVeh setDir (_spawnPos getDir _dirPos);
        [_spawnedVeh] remoteExec ["RB_fnc_addVehicleSalvageActions", 0, true];

        private _crewGroup = createGroup east;
        private _seatRoles  = fullCrew [_spawnedVeh, "", true];
        private _totalSeats = count _seatRoles;
        private _maxCrew = 6;
        private _crewToFill = _totalSeats min _maxCrew; 

        private _hasDriver = (_crewToFill > 0);

        if (_hasDriver) then {
            private _driverClass = selectRandom _infPool;
            private _driver = _crewGroup createUnit [_driverClass, _spawnPos, [], 0, "NONE"];
            if (!isNull _driver) then { _driver moveInDriver _spawnedVeh; };
        };
        
        private _filled = 0;
        if (_hasDriver) then { _filled = _filled + 1; };
        private _numPassengers = _crewToFill - _filled;
        if (_numPassengers < 0) then { _numPassengers = 0; };

        for "_i" from 1 to _numPassengers do {
            private _passClass = selectRandom _infPool;
            private _unit = _crewGroup createUnit [_passClass, _spawnPos, [], 0, "NONE"];
            if (!isNull _unit) then { _unit moveInAny _spawnedVeh; };
        };

        _spawnedVeh enableAI "MOVE"; _spawnedVeh enableAI "PATH"; _spawnedVeh enableAI "ALL";
        { _x enableAI "MOVE"; _x enableAI "ALL"; } forEach crew _spawnedVeh;

        sleep 0.5;
        _crewGroup setBehaviour "SAFE";
        _crewGroup setSpeedMode "LIMITED";
        _crewGroup addVehicle _spawnedVeh;
        { [_x] joinSilent _crewGroup; } forEach crew _spawnedVeh;
        
        sleep 0.25;
        // Direct waypoint
        private _wp = _crewGroup addWaypoint [_holdPos, 0];
        _wp setWaypointType "GETOUT";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
        _wp setWaypointCompletionRadius 75;
        _wp setWaypointPosition [_holdPos, 0];

        diag_log format ["[RB] Spawned Disguised Enemy: %1 -> %2", _vehClass, _holdPos];
    };
};

_spawnedVeh
