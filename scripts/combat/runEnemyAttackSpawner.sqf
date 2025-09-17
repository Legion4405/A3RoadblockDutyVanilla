/*
    File: runEnemyAttackSpawner.sqf
    Description: Spawns enemy attacks at random intervals based on mission parameter.
*/

if (!isServer) exitWith {};

private _intensity = ["RB_EnemyAttackIntensity", 1] call BIS_fnc_getParamValue;

private _delayRange = switch (_intensity) do {
    case 0: { [600, 1140] };
    case 1: { [840, 900] };
    case 2: { [600, 840] };
    case 3: { [420, 720] };
    default { [840, 900] };
};

while { true } do {
    private _delay = (_delayRange#0) + random (_delayRange#1 - _delayRange#0);
    sleep _delay;
    if (({isPlayer _x} count allPlayers) == 0) then { continue; };
     if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then {
        continue;
    };   

    [] call RB_fnc_spawnEnemyAttack;
};
