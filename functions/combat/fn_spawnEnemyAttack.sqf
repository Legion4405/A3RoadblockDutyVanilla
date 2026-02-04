/*
    File: fn_spawnEnemyAttack.sqf
    Description: Spawns a group of enemies at a random spawn marker and sends them to attack the checkpoint.
                 Uses cached markers for performance.
*/

if (!isServer) exitWith {};

// === 1. SELECT SPAWN MARKER ===
private _allSpawns = missionNamespace getVariable ["RB_CachedEnemySpawns", []];
if (_allSpawns isEqualTo []) exitWith { diag_log "[RB] No enemy spawn markers cached."; };

private _validSpawns = [];
{
    private _pos = getMarkerPos _x;
    // Only use if no players are within 250m
    if ({_x distance2D _pos < 250} count allPlayers == 0) then {
        _validSpawns pushBack _x;
    };
} forEach _allSpawns;

if (_validSpawns isEqualTo []) exitWith { diag_log "[RB] Enemy attack skipped: All spawns are too close to players."; };

private _spawnMarker = selectRandom _validSpawns;
private _spawnPos    = getMarkerPos _spawnMarker;

// === 2. SETUP ATTACK ===
private _checkpoint = getMarkerPos "RB_Checkpoint";
if (_checkpoint isEqualTo [0,0,0]) exitWith { diag_log "[RB] RB_Checkpoint marker missing."; };

private _enemyTypes = missionNamespace getVariable ["RB_EnemyInfantryPool", ["O_Soldier_F"]];
private _playerCount = count allPlayers;
// Dynamic scaling: 3 base + 2 per player
private _groupSize = 3 + (2 * _playerCount); 

// Chance for small infiltrator team (20%)
private _isInfiltration = (random 1 < 0.20);
if (_isInfiltration) then { _groupSize = 4; }; // Fixed size for spec ops

private _grp = createGroup [east, true];

// === 3. SPAWN UNITS ===
for "_i" from 1 to _groupSize do {
    private _type = selectRandom _enemyTypes;
    private _unit = _grp createUnit [_type, _spawnPos, [], 5, "NONE"];
    
    _unit setSkill (if (_isInfiltration) then {0.7} else {0.4});
};

// === 4. ORDERS ===
if (_isInfiltration) then {
    // Stealth approach
    _grp setBehaviour "STEALTH";
    _grp setCombatMode "GREEN"; // Hold fire until compromised
    _grp setSpeedMode "NORMAL";

    diag_log format ["[RB] SpecOps Infiltration (%1 units) from %2", count (units _grp), _spawnMarker];

    // Approach WP
    private _wp1 = _grp addWaypoint [_checkpoint, 50];
    _wp1 setWaypointType "MOVE";
    _wp1 setWaypointBehaviour "STEALTH";
    _wp1 setWaypointCompletionRadius 30;
    
    // Attack WP
    private _wp2 = _grp addWaypoint [_checkpoint, 0];
    _wp2 setWaypointType "SAD";
    _wp2 setWaypointBehaviour "COMBAT";
    _wp2 setWaypointCombatMode "RED";
    
} else {
    // Full assault
    _grp setBehaviour "COMBAT";
    _grp setCombatMode "RED";
    _grp setSpeedMode "FULL";

    diag_log format ["[RB] Main Assault (%1 units) from %2", count (units _grp), _spawnMarker];

    private _wp = _grp addWaypoint [_checkpoint, 0];
    _wp setWaypointType "SAD";
    _wp setWaypointBehaviour "COMBAT";
    _wp setWaypointCombatMode "RED";
};

// Cleanup garbage eventually (via separate garbage collector script usually, or add to a list)
// For now, reliance on "AllDead" cleanup or engine GC.