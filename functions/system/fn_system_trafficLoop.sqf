/*
    File: fn_system_trafficLoop.sqf
    Description: Continuously spawns roadblock entities (civilian or vehicle) at intervals.
    Single-Entity mode. Includes Persistent Wreck logic and Dynamic Waypoints.
*/

if (!isServer) exitWith {};

// === Configuration & Constants ===
private _cleanupTimeoutMinutes = ["RB_CleanupTimeout", 4] call BIS_fnc_getParamValue;
private _cleanupTimeoutSeconds = (_cleanupTimeoutMinutes max 1) * 60;
private _intensity = ["RB_Intensity", 1] call BIS_fnc_getParamValue;

// Wait for config to load
if (isNil "RB_TrafficSpawnTimers") then {
    private _timeout = time + 5;
    waitUntil { (!isNil "RB_TrafficSpawnTimers") || (time > _timeout) };
};

private _timers = missionNamespace getVariable ["RB_TrafficSpawnTimers", [
    [360, 120], [240, 60], [180, 30], [90, 5] 
]]; 

if (_intensity < 0) then { _intensity = 1; };
if (_intensity >= count _timers) then { _intensity = (count _timers) - 1; };

private _timerData = _timers select _intensity;
private _baseDelay = _timerData select 0;
private _randomVar = _timerData select 1;

// === Cache Markers ===
private _holdPos = getMarkerPos "RB_HoldPoint";
if (_holdPos isEqualTo [0,0,0]) exitWith { diag_log "[RB] FATAL: Marker 'RB_HoldPoint' missing."; };

private _footSpawnPos = getMarkerPos "RB_FootSpawn";
private _vehSpawnPairs = [];
for "_i" from 1 to 8 do {
    private _s = getMarkerPos format ["RB_VehSpawn_%1", _i];
    private _d = getMarkerPos format ["RB_VehSpawnDir_%1", _i];
    if (!(_s isEqualTo [0,0,0]) && !(_d isEqualTo [0,0,0])) then {
        _vehSpawnPairs pushBack [_s, _d];
    };
};

// Cache Route Waypoints (RB_VehWP_1, RB_VehWP_2, ...)
private _routeWaypoints = [];
private _i = 1;
while {true} do {
    private _mkr = format ["RB_VehWP_%1", _i];
    if (getMarkerPos _mkr isEqualTo [0,0,0]) exitWith {};
    _routeWaypoints pushBack _mkr;
    _i = _i + 1;
};

// === Main Loop ===
while {true} do {
    sleep (_baseDelay + random _randomVar);

    if (({isPlayer _x} count allPlayers) == 0) then { continue };
    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then { continue };

    private _existing = missionNamespace getVariable ["RB_CurrentEntity", objNull];
    if (!isNull _existing) then {
        if (!alive _existing) then {
            if (_existing getVariable ["rb_isBombWreck", false]) then {
                continue;
            } else {
                missionNamespace setVariable ["RB_CurrentEntity", nil, true];
            };
        } else {
            continue; 
        };
    };

    if (missionNamespace getVariable ["RB_SpawnerRunning", false]) then { continue; };
    missionNamespace setVariable ["RB_SpawnerRunning", true, true];

    private _civChance = missionNamespace getVariable ["RB_CivilianChance", 0.0];
    private _isFoot = (random 1 < _civChance);
    if (_isFoot && {_footSpawnPos isEqualTo [0,0,0]}) then { _isFoot = false; };
    
    private _spawnedEntity = objNull;
    private _spawnedGroup = grpNull;

    if (_isFoot) then {
        private _civPool = missionNamespace getVariable ["RB_ActiveCivilianPool", ["C_man_1"]];
        _spawnedGroup = createGroup civilian;
        _spawnedEntity = _spawnedGroup createUnit [selectRandom _civPool, _footSpawnPos, [], 0, "NONE"];
        _spawnedEntity setVariable ["rb_isCivilian", true, true];
        [_spawnedEntity] call RB_fnc_assignIdentityAndContraband;
        _spawnedEntity setBehaviour "CARELESS";
        _spawnedEntity setSpeedMode "LIMITED";
        
        private _wp = _spawnedGroup addWaypoint [_holdPos, 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointCompletionRadius 10;
    } else {
        if (_vehSpawnPairs isNotEqualTo []) then {
            private _pair = selectRandom _vehSpawnPairs;
            private _spawnPos = _pair select 0;
            if (count (nearestObjects [_spawnPos, ["LandVehicle","Air","Ship","Thing"], 7]) == 0) then {
                _spawnedEntity = [_spawnPos] call RB_fnc_spawnCivilianVehicle;
                if (!isNull _spawnedEntity) then {
                    _spawnedEntity setDir (_spawnPos getDir (_pair select 1));
                    private _driver = driver _spawnedEntity;
                    if (isNull _driver) then {
                        { deleteVehicle _x } forEach (crew _spawnedEntity);
                        deleteVehicle _spawnedEntity;
                        _spawnedEntity = objNull;
                    } else {
                        _spawnedGroup = group _driver;
                        { [_x] joinSilent _spawnedGroup } forEach (crew _spawnedEntity);
                        _spawnedEntity setVariable ["rb_linkedCivilians", crew _spawnedEntity, true];
                        
                        _driver setBehaviour "CARELESS";
                        _driver setSpeedMode "LIMITED";
                        _driver forceFollowRoad true;
                        
                        _spawnedGroup addVehicle _spawnedEntity;
                        
                        // Add intermediate waypoints
                        {
                            private _wpInter = _spawnedGroup addWaypoint [getMarkerPos _x, 0];
                            _wpInter setWaypointType "MOVE";
                            _wpInter setWaypointCompletionRadius 10;
                        } forEach _routeWaypoints;

                        private _wp = _spawnedGroup addWaypoint [_holdPos, 0];
                        _wp setWaypointType "MOVE";
                        _wp setWaypointCompletionRadius 10;
                    };
                };
            };
        };
    };

    if (!isNull _spawnedEntity) then {
        missionNamespace setVariable ["RB_CurrentEntity", _spawnedEntity, true];
        // Use the new public function
        [_spawnedEntity, _spawnedGroup, _holdPos, 360, _cleanupTimeoutSeconds] call RB_fnc_monitorArrival;
    };

    missionNamespace setVariable ["RB_SpawnerRunning", false, true];
};
