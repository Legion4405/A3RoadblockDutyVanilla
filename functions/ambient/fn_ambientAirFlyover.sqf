/*
    File: fn_ambientAirFlyover.sqf
    Description: Optimized random rotary or fixed-wing flyovers.
    Uses better group management and efficient cleanup.
*/

if (!isServer) exitWith {};

// === 1. CONFIGURATION ===
// Wait for global config to be defined
waitUntil { !isNil "RB_AirFlyoverTimers" };

private _timers = missionNamespace getVariable ["RB_AirFlyoverTimers", [[600, 1200], [300, 600], [120, 300], [60, 120]]];
private _intensity = ["RB_AmbientAirIntensity", 1] call BIS_fnc_getParamValue;
_intensity = (0 max _intensity) min ((count _timers) - 1);

private _range = _timers select _intensity;
private _minDelay = _range select 0;
private _maxDelay = _range select 1;

private _roadblock = getMarkerPos "RB_Checkpoint";
if (_roadblock isEqualTo [0,0,0]) exitWith { diag_log "[RB] ERROR: Marker 'RB_Checkpoint' not found for flyovers."; };

// === 2. MAIN LOOP ===
while {true} do {
    private _delay = _minDelay + random (_maxDelay - _minDelay);
    sleep _delay;

    if (({isPlayer _x} count allPlayers) == 0) then { continue };
    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then { continue };

    private _rotary = missionNamespace getVariable ["RB_Ambient_Rotary_Selected", []];
    private _fixed  = missionNamespace getVariable ["RB_Ambient_Fixed_Selected", []];
    
    private _canHeli  = (count _rotary > 0);
    private _canPlane = (count _fixed  > 0);
    if (!_canHeli && !_canPlane) then { sleep 10; continue; };

    // Selection
    private _isHeli = if (_canHeli && _canPlane) then { random 1 < 0.65 } else { _canHeli };
    private _pool = if (_isHeli) then { _rotary } else { _fixed };
    if (count _pool == 0) then { continue };
    
    private _class = selectRandom _pool;
    private _count = if (random 1 < 0.4) then { 2 } else { 1 };

    // Trajectory Math
    private _dir = random 360;
    private _spawnDist = 6000; // Reduced slightly for better perf
    private _exitDist  = 6000;
    
    private _spawnPos = _roadblock getPos [_spawnDist, _dir];
    private _exitPos  = _roadblock getPos [_exitDist, _dir + 180];
    
    private _height = if (_isHeli) then { 100 + random 50 } else { 400 + random 200 };
    _spawnPos set [2, _height];
    _exitPos set [2, _height];

    // Single Group for both if pair
    private _grp = createGroup [civilian, true];
    _grp setBehaviour "CARELESS";
    _grp setCombatMode "BLUE";

    for "_i" from 1 to _count do {
        private _offset = if (_i == 1) then { [0,0,0] } else { [50, 50, 0] };
        private _sPos = _spawnPos vectorAdd _offset;
        
        private _veh = createVehicle [_class, _sPos, [], 0, "FLY"];
        _veh setPosASL (ATLToASL _sPos);
        _veh setDir (_sPos getDir _exitPos);
        _veh setVelocityModelSpace [0, 100, 0]; // Initial kick
        
        _veh setCaptive true;
        _veh engineOn true;
        _veh flyInHeight _height;
        
        // Use engine command for crew spawning (faster/optimized)
        createVehicleCrew _veh;
        (crew _veh) joinSilent _grp;
        
        // Individual Cleanup Watchdog (more efficient than group-wide in some cases)
        [_veh, _exitPos] spawn {
            params ["_v", "_dest"];
            private _killTime = time + 600;
            waitUntil {
                sleep 5;
                !alive _v || {(_v distance2D _dest) < 1000} || {time > _killTime}
            };
            if (!isNull _v) then {
                private _c = crew _v;
                deleteVehicle _v;
                { deleteVehicle _x } forEach _c;
            };
        };
    };

    // Waypoints
    private _wp = _grp addWaypoint [_exitPos, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointSpeed "FULL";
    _wp setWaypointCompletionRadius 500;

    diag_log format ["[RB] Ambient Flyover: %1x %2", _count, _class];
};
