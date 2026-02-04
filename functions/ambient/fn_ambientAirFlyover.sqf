/*
    File: fn_ambientAirFlyover.sqf
    Description: Spawns random rotary or fixed-wing flyovers at intervals.
    Refactored for reliability and configurability.
*/

if (!isServer) exitWith {};

// === 1. WAIT FOR CONFIG & POOLS ===
if (isNil "RB_AirFlyoverTimers") then {
    private _timeout = time + 10;
    waitUntil { (!isNil "RB_AirFlyoverTimers") || (time > _timeout) };
};

while {
    private _r = missionNamespace getVariable ["RB_Ambient_Rotary_Selected", []];
    private _f = missionNamespace getVariable ["RB_Ambient_Fixed_Selected", []];
    !((_r isEqualType []) && (_f isEqualType []) && (count _r + count _f > 0))
} do {
    sleep 5;
};

private _rotary = missionNamespace getVariable ["RB_Ambient_Rotary_Selected", []];
private _fixed  = missionNamespace getVariable ["RB_Ambient_Fixed_Selected", []];

// Get roadblock position
private _roadblock = getMarkerPos "RB_Checkpoint";
if (_roadblock isEqualTo [0,0,0]) exitWith { diag_log "[RB] ERROR: Marker 'RB_Checkpoint' not found for flyovers."; };

// === 2. SETUP TIMERS ===
private _timers = missionNamespace getVariable ["RB_AirFlyoverTimers", [
    [900, 1800], [600, 1200], [300, 600], [120, 300]
]];
private _intensity = ["RB_AmbientAirIntensity", 1] call BIS_fnc_getParamValue;
if (_intensity < 0) then { _intensity = 1; };
if (_intensity >= count _timers) then { _intensity = (count _timers) - 1; };

private _range = _timers select _intensity;
private _minDelay = _range select 0;
private _maxDelay = _range select 1;

// === 3. HELPER: AGL to ASL ===
private _fnc_aglToASL = {
    params ["_xy", "_agl"];
    [(_xy select 0), (_xy select 1), (getTerrainHeightASL _xy + _agl)]
};

// === 4. MAIN LOOP ===
while {true} do {
    private _delay = _minDelay + random (_maxDelay - _minDelay);
    sleep _delay;

    if (({isPlayer _x} count allPlayers) == 0) then { continue };
    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then { continue };

    // Select Pool
    private _canHeli  = (count _rotary > 0);
    private _canPlane = (count _fixed  > 0);
    private _pool = [];
    private _isHeli = false;

    if (_canHeli && _canPlane) then {
        _isHeli = (random 1 < 0.65);
        _pool = if (_isHeli) then {_rotary} else {_fixed};
    } else {
        if (_canHeli) then { _isHeli = true; _pool = _rotary; };
        if (_canPlane) then { _isHeli = false; _pool = _fixed; };
    };

    if (count _pool == 0) then { continue; };
    private _class = selectRandom _pool;

    // Decide Count (Single or Pair)
    private _pairChance = 0.4;
    private _count = if (random 1 < _pairChance) then {2} else {1};

    // Shared path calculations
    private _spawnDist = 8000;
    private _exitDist  = 8000;
    private _dir = random 360;
    private _flybyDir  = _dir + (random 60 - 30);
    private _flybyDist = 3000 + random 2000;

    private _spawnXY = [(_roadblock select 0) + _spawnDist * cos _dir, (_roadblock select 1) + _spawnDist * sin _dir];
    private _flybyXY = [(_roadblock select 0) + _flybyDist * cos _flybyDir, (_roadblock select 1) + _flybyDist * sin _flybyDir];
    private _exitXY  = [(_roadblock select 0) + _exitDist * cos (_dir + 180), (_roadblock select 1) + _exitDist * sin (_dir + 180)];

    private _spawnAGL = if (_isHeli) then { 80 + random 60 } else { 400 + random 300 };
    private _flybyAGL = if (_isHeli) then { 60 + random 40 } else { 300 + random 200 };
    private _exitAGL  = _spawnAGL;

    // Formation Offsets
    private _formationOffset = [25 + random 15, 25 + random 15, 0];

    // Spawn Aircraft
    for "_i" from 0 to (_count - 1) do {
        private _offset = if (_i == 0) then { [0,0,0] } else { _formationOffset };
        private _sPos = [_spawnXY vectorAdd _offset, _spawnAGL] call _fnc_aglToASL;
        private _fPos = [_flybyXY vectorAdd _offset, _flybyAGL] call _fnc_aglToASL;
        private _ePos = [_exitXY vectorAdd _offset, _exitAGL] call _fnc_aglToASL;

        private _grp = createGroup [civilian, true];
        private _veh = createVehicle [_class, ASLToATL _sPos, [], 0, "FLY"];
        
        if (!isNull _veh) then {
            _veh setPosASL _sPos;
            _veh setDir (_sPos getDir _fPos);
            _veh setVelocityModelSpace [80 + random 40, 0, 0];
            _veh setCaptive true;
            _veh engineOn true;
            _veh flyInHeight _flybyAGL;

            private _crewClass = getText (configFile >> "CfgVehicles" >> _class >> "crew");
            if (_crewClass == "") then { _crewClass = "C_man_pilot_F"; };
            private _pilot = _grp createUnit [_crewClass, [0,0,0], [], 0, "NONE"];
            _pilot moveInDriver _veh;

            _grp setBehaviour "CARELESS";
            _grp setCombatMode "BLUE";

            private _wp1 = _grp addWaypoint [ASLToATL _fPos, 0];
            _wp1 setWaypointType "MOVE";
            _wp1 setWaypointSpeed "FULL";
            
            private _wp2 = _grp addWaypoint [ASLToATL _ePos, 0];
            _wp2 setWaypointType "MOVE";
            _wp2 setWaypointCompletionRadius 500;

            // Monitor and cleanup
            [_veh, _grp, _pilot, _exitXY, time + 600] spawn {
                params ["_v", "_g", "_p", "_dest", "_timeout"];
                waitUntil {
                    sleep 5;
                    !alive _v || !alive _p || (_v distance2D _dest < 1500) || (time > _timeout)
                };
                if (!isNull _v) then { deleteVehicle _v; };
                if (!isNull _p) then { deleteVehicle _p; };
                if (!isNull _g) then { deleteGroup _g; };
            };
        };
    };
    
    diag_log format ["[RB] Ambient Flyover spawned: %1 x %2", _count, _class];
};