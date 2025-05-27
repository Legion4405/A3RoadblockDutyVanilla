/*
    File: runEnemyVehicleSpawner.sqf
    Description: Spawns enemy vehicles at intervals, crews them from RB_EnemyInfantryPool, and unloads at HoldPoint.
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
    private _delay = (_delayRange#0) + random (_delayRange#1 - _delayRange#0);
    sleep _delay;
    
    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then {
        continue;
    };

    private _vehPool = missionNamespace getVariable ["RB_EnemyVehiclePool", ["O_MRAP_02_hmg_F"]];
    private _infPool = missionNamespace getVariable ["RB_EnemyInfantryPool", ["O_Soldier_F"]];

    private _vehClass = selectRandom _vehPool;
    private _spawnPos = getMarkerPos "RB_VehSpawn";
    private _facingPos = getMarkerPos "RB_VehSpawnDir";
    private _holdPos = getMarkerPos "RB_HoldPoint";

    if (_spawnPos isEqualTo [0,0,0] || _facingPos isEqualTo [0,0,0] || _holdPos isEqualTo [0,0,0]) then {
        diag_log "[RB] ERROR: Enemy vehicle spawn markers not set correctly.";
        continue;
    };

    private _dir = _spawnPos getDir _facingPos;
    private _veh = createVehicle [_vehClass, _spawnPos, [], 0, "NONE"];
    _veh setDir _dir;

    private _crewGroup = createGroup east;

    // Ensure gunner and driver slots are filled, then fill rest of crew
    private _roles = fullCrew [_veh, "", true];
    {
        private _unitClass = selectRandom _infPool;
        private _unit = _crewGroup createUnit [_unitClass, _spawnPos, [], 0, "NONE"];
        _unit moveInAny _veh;
    } forEach _roles;

    // Safety fallback: ensure at least driver and gunner are assigned
    if (isNull driver _veh) then {
        private _driver = _crewGroup createUnit [selectRandom _infPool, _spawnPos, [], 0, "NONE"];
        _driver moveInDriver _veh;
    };
    if (isNull gunner _veh) then {
        private _gunner = _crewGroup createUnit [selectRandom _infPool, _spawnPos, [], 0, "NONE"];
        _gunner moveInGunner _veh;
    };

    _crewGroup setBehaviour "COMBAT";
    _crewGroup setSpeedMode "NORMAL";
    _crewGroup addVehicle _veh;

    // === Move to hold point and unload
    private _wp = _crewGroup addWaypoint [_holdPos, 0];
    _wp setWaypointType "UNLOAD";
    _wp setWaypointBehaviour "COMBAT";
    _wp setWaypointSpeed "NORMAL";
    _wp setWaypointCompletionRadius 10;

    diag_log format ["[RB] Spawned enemy vehicle %1 with crew from pool (%2 units)", _vehClass, count crew _veh];
};
