/*
    File: fn_system_enemyAttackLoop.sqf
    Description: Spawns enemy attacks at intervals. Refactored for performance.
*/

if (!isServer) exitWith {};

// === 1. WAIT FOR CONFIG ===
if (isNil "RB_EnemyAttackTimers") then {
    private _timeout = time + 10;
    waitUntil { (!isNil "RB_EnemyAttackTimers") || (time > _timeout) };
};

// === 2. CACHE SPAWN MARKERS ===
// Identify all RB_EnemySpawn_X markers once
private _spawnPoints = [];
private _i = 1;
while {true} do {
    private _mkr = format ["RB_EnemySpawn_%1", _i];
    if (getMarkerPos _mkr isEqualTo [0,0,0]) exitWith {};
    _spawnPoints pushBack _mkr;
    _i = _i + 1;
};

// Fallback if none found
if (_spawnPoints isEqualTo []) then {
    diag_log "[RB] WARNING: No 'RB_EnemySpawn_X' markers found. Enemy attacks disabled.";
};

missionNamespace setVariable ["RB_CachedEnemySpawns", _spawnPoints, true];

// === 3. SETUP TIMERS ===
private _timers = missionNamespace getVariable ["RB_EnemyAttackTimers", [
    [900, 1800], [600, 1200], [480, 720], [300, 480]
]];

private _intensity = ["RB_EnemyAttackIntensity", 1] call BIS_fnc_getParamValue;
if (_intensity < 0) then { _intensity = 1; };
if (_intensity >= count _timers) then { _intensity = (count _timers) - 1; };

private _range = _timers select _intensity;
private _minDelay = _range select 0;
private _maxDelay = _range select 1;

// === 4. MAIN LOOP ===
while {true} do {
    // Variable delay
    private _delay = _minDelay + random (_maxDelay - _minDelay);
    sleep _delay;

    if (({isPlayer _x} count allPlayers) == 0) then { continue };
    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then { continue };
    
    // Check if spawns exist
    if ((count _spawnPoints) == 0) then { continue; };

    [] call RB_fnc_spawnEnemyAttack;
};