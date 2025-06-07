/*
    File: runEnemyAttackSpawner.sqf
    Description: Spawns enemy attacks at random intervals based on mission parameter.
*/

if (!isServer) exitWith {};

private _intensity = ["RB_EnemyAttackIntensity", 1] call BIS_fnc_getParamValue;

private _delayRange = switch (_intensity) do {
    case 0: { [600, 900] };   // Low: 10–15 min
    case 1: { [300, 480] };   // Medium: 5–8 min
    case 2: { [120, 240] };   // High: 2–4 min
    case 3: { [60, 120] };    // Very High: 1–2 min
    default { [300, 480] };
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
