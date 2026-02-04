/*
    File: runEnemyVehicleSpawner.sqf
    Description: Modular enemy vehicle spawner loop.
    Logic extracted to RB_fnc_spawnEnemyVehicle.
*/

if (!isServer) exitWith {};

private _intensity = ["RB_EnemyVehicleFrequency", 1] call BIS_fnc_getParamValue;
private _delayRange = switch (_intensity) do {
    case 0: { [600, 1140] };
    case 1: { [840, 1140] };
    case 2: { [600, 840] };
    case 3: { [420, 720] };
    default { [840, 900] };
};

while { true } do {
    private _minDelay = _delayRange select 0;
    private _maxDelay = _delayRange select 1;
    sleep (_minDelay + random (_maxDelay - _minDelay));
    
    if (({ isPlayer _x } count allPlayers) == 0) then { sleep 10; continue; };
    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then { sleep 10; continue; };

    // Call the spawn function
    [] call RB_fnc_spawnEnemyVehicle;
};