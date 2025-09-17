/*
    File: fn_ambientTraffic.sqf
    Description: Spawns ambient civilian vehicles from RB_CivilianVehiclePool along marker routes.
*/

if (!isServer) exitWith {};
sleep 5;
// === Intensity parameter and spawn interval table
private _intensity = ["RB_AmbientTrafficIntensity", 2] call BIS_fnc_getParamValue;
if (_intensity == 0) exitWith {
    systemChat "[RB] Ambient traffic disabled by mission parameter.";
    return;
};
private _spawnDelayRanges = [
    [999, 999],   // Disabled
    [600, 720],    // Low
    [360, 480],     // Medium
    [180, 360],     // High
    [60, 180]      // Very High
];
private _delayRange = _spawnDelayRanges select _intensity;

// === Build route list using sentinel marker check
private _routes = [];
private _i = 1;
while {true} do {
    private _startName = format ["RB_AmbientVehicleStart_%1", _i];
    private _endName   = format ["RB_AmbientVehicleEnd_%1", _i];
    private _dirName   = format ["RB_AmbientVehicleStartDir_%1", _i];

    if (getMarkerPos _startName isEqualTo [0,0,0]) exitWith {};
    if (getMarkerPos _endName   isEqualTo [0,0,0]) exitWith {};

    private _startPos = getMarkerPos _startName;
    private _endPos   = getMarkerPos _endName;
    private _dir      = if (getMarkerPos _dirName isEqualTo [0,0,0]) then {0} else {markerDir _dirName};

    _routes pushBack [_startPos, _endPos, _dir];
    _i = _i + 1;
};

if (_routes isEqualTo []) exitWith {
    systemChat "[RB] No ambient traffic routes found! Please add RB_AmbientVehicleStart_X and RB_AmbientVehicleEnd_X markers.";
    return;
};

// === For each route, spawn a traffic loop
{
    [_x, _delayRange] spawn {
        params ["_route", "_delay"];
        _route params ["_startPos", "_endPos", "_spawnDir"];

        while { true } do {
            // Pick random civilian vehicle/driver class
            private _vehClass = selectRandom (missionNamespace getVariable ["RB_CivilianVehiclePool", ["C_Offroad_01_F"]]);
            private _civClass = selectRandom (missionNamespace getVariable ["RB_ActiveCivilianPool", ["C_man_1"]]);

            // Create vehicle
            private _veh = createVehicle [_vehClass, _startPos, [], 0, "NONE"];
            _veh setDir _spawnDir;
            _veh setVehicleLock "UNLOCKED";
            _veh allowDamage false;

            // Create driver as group/unit for reliable vehicle AI
            private _grp = createGroup civilian;
            private _driver = _grp createUnit [_civClass, _startPos, [], 0, "NONE"];
            _driver moveInDriver _veh;
            _driver setVariable ["rb_isCivilian", true, true];
            _driver disableAI "TARGET";
            _driver disableAI "AUTOTARGET";
            _driver setBehaviour "CARELESS";
            _grp setBehaviour "CARELESS";

            // Assign waypoint
            private _wp = _grp addWaypoint [_endPos, 0];
            _wp setWaypointType "MOVE";
            _wp setWaypointBehaviour "CARELESS";
            _wp setWaypointSpeed "LIMITED";

            // Watchdog for timeout, death, or arrival
            private _startTime = time;
            waitUntil {
                sleep 5;
                !alive _veh || !alive _driver || (_veh distance _endPos < 20) || (time - _startTime > 240)
            };
            deleteVehicle _veh;
            deleteVehicle _driver;
            deleteGroup _grp;

            // Respawn cooldown (varies per intensity)
            private _waitTime = (_delay select 0) + random ((_delay select 1) - (_delay select 0));
            sleep _waitTime;
        };
    };
} forEach _routes;
