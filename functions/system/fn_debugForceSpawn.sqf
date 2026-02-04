/*
    File: fn_debugForceSpawn.sqf
    Description: Force-spawns a traffic entity (vehicle or foot) for debugging.
    Params: [_isVehicle (bool)]
*/

if (!isServer) exitWith {};
params [["_isVehicle", true]];

private _existing = missionNamespace getVariable ["RB_CurrentEntity", objNull];
if (!isNull _existing && {alive _existing}) exitWith {
    diag_log "[RB] Debug Spawn failed: Entity already exists.";
};

// Markers
private _holdPos = getMarkerPos "RB_HoldPoint";
private _footPos = getMarkerPos "RB_FootSpawn";
private _cleanupSeconds = (["RB_CleanupTimeout", 4] call BIS_fnc_getParamValue) * 60;

// Waypoints (Re-scan for debug safety)
private _routeWaypoints = [];
private _i = 1;
while {true} do {
    private _mkr = format ["RB_VehWP_%1", _i];
    if (getMarkerPos _mkr isEqualTo [0,0,0]) exitWith {};
    _routeWaypoints pushBack _mkr;
    _i = _i + 1;
};

private _spawnedEntity = objNull;
private _spawnedGroup = grpNull;

if (_isVehicle) then {
    // Find a spawn
    private _spawnPos = [0,0,0];
    private _spawnDir = 0;
    
    for "_j" from 1 to 8 do {
        private _s = getMarkerPos format ["RB_VehSpawn_%1", _j];
        if (!(_s isEqualTo [0,0,0])) exitWith { 
            _spawnPos = _s; 
            private _dPos = getMarkerPos format ["RB_VehSpawnDir_%1", _j];
            _spawnDir = _spawnPos getDir _dPos;
        };
    };
    if (_spawnPos isEqualTo [0,0,0]) then { _spawnPos = getMarkerPos "RB_VehSpawn"; };

    _spawnedEntity = [_spawnPos] call RB_fnc_spawnCivilianVehicle;
    if (!isNull _spawnedEntity) then {
        _spawnedEntity setDir _spawnDir;
        private _driver = driver _spawnedEntity;
        _spawnedGroup = group _driver;
        _driver forceFollowRoad true;
        _driver setBehaviour "CARELESS";
        _driver setSpeedMode "LIMITED";

        {
            private _wpInter = _spawnedGroup addWaypoint [getMarkerPos _x, 0];
            _wpInter setWaypointType "MOVE";
            _wpInter setWaypointCompletionRadius 10;
        } forEach _routeWaypoints;

        private _wp = _spawnedGroup addWaypoint [_holdPos, 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointCompletionRadius 10;
    };
} else {
    // Foot spawn
    private _civPool = missionNamespace getVariable ["RB_ActiveCivilianPool", ["C_man_1"]];
    _spawnedGroup = createGroup civilian;
    _spawnedEntity = _spawnedGroup createUnit [selectRandom _civPool, _footPos, [], 0, "NONE"];
    _spawnedEntity setVariable ["rb_isCivilian", true, true];
    [_spawnedEntity] call RB_fnc_assignIdentityAndContraband;
    
    private _wp = _spawnedGroup addWaypoint [_holdPos, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointCompletionRadius 10;
};

if (!isNull _spawnedEntity) then {
    missionNamespace setVariable ["RB_CurrentEntity", _spawnedEntity, true];
    // Use public function
    [_spawnedEntity, _spawnedGroup, _holdPos, 360, _cleanupSeconds] call RB_fnc_monitorArrival; 
};

true