/*
    File: spawnEnemyAttack.sqf
    Description: Spawns a group of enemies at a random spawn marker and sends them to attack the checkpoint.
*/

if (!isServer) exitWith {};

private _spawnMarkers = [
    "RB_EnemySpawn_1", "RB_EnemySpawn_2", "RB_EnemySpawn_3",
    "RB_EnemySpawn_4", "RB_EnemySpawn_5", "RB_EnemySpawn_6"
];
private _marker = selectRandom _spawnMarkers;
private _pos = getMarkerPos _marker;
private _checkpoint = getMarkerPos "RB_Checkpoint";

if (_pos isEqualTo [0,0,0]) exitWith {
    diag_log format ["[RB] Invalid enemy spawn marker: %1", _marker];
};

private _enemyTypes = missionNamespace getVariable ["RB_EnemyInfantryPool", ["O_Soldier_F"]];
private _playerCount = count allPlayers;
private _groupSize = (2 + floor random 3) + (2 * _playerCount); // 3–5 base + 2 per player

private _grp = createGroup east;
for "_i" from 1 to _groupSize do {
    private _unitClass = selectRandom _enemyTypes;
    _grp createUnit [_unitClass, _pos, [], 5, "FORM"];
};

_grp setBehaviour "COMBAT";
_grp setCombatMode "RED";

{
    _x doMove _checkpoint;
} forEach units _grp;
