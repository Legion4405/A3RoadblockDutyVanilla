[] spawn {
    waitUntil { !isNil "paramsArray" };
    // in your server init (init.sqf), before any spawner runs:
    missionNamespace setVariable ["RB_RoadblockClosed", false, true];
    publicVariable "RB_RoadblockClosed";

    // Load configuration
    call compile preprocessFileLineNumbers "scripts\config.sqf";

    waitUntil { !isNull player };

    if (isNil { player getVariable "rb_score" }) then {
        player setVariable ["rb_score", 0, true];
    };

    sleep 0.5;

    // Retrieve parameters using BIS_fnc_getParamValue
    private _idPoolIndex   = ["RB_IdentityPool", 0] call BIS_fnc_getParamValue;
    private _civPoolIndex  = ["RB_CivilianPool", 0] call BIS_fnc_getParamValue;
    private _vehPoolIndex  = ["RB_CivilianVehiclePool", 0] call BIS_fnc_getParamValue;
    private _enemyInfIndex = ["RB_EnemyFaction", 0] call BIS_fnc_getParamValue;
    private _enemyVehIndex = ["RB_EnemyVehiclePool", 0] call BIS_fnc_getParamValue;
    private _respawnCost   = ["RB_RespawnCost", 10] call BIS_fnc_getParamValue;

    // Assign pools based on parameters
    switch (_idPoolIndex) do {
        case 0: { RB_ActiveIdentityPool = +RB_IdentityPool_Greek };
        case 1: { RB_ActiveIdentityPool = +RB_IdentityPool_African };
        case 2: { RB_ActiveIdentityPool = +RB_IdentityPool_European };
        default { RB_ActiveIdentityPool = +RB_IdentityPool_Greek };
    };
    publicVariable "RB_ActiveIdentityPool";

    switch (_civPoolIndex) do {
        case 0: { RB_ActiveCivilianPool = +RB_CivilianPool_Vanilla };
        case 1: { RB_ActiveCivilianPool = +RB_CivilianPool_CUP };
        case 2: { RB_ActiveCivilianPool = +RB_CivilianPool_3CB };
        case 3: { RB_ActiveCivilianPool = +RB_CivilianPool_SOG };
    };
    publicVariable "RB_ActiveCivilianPool";

    switch (_vehPoolIndex) do {
        case 0: { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_Vanilla };
        case 1: { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_CUP };
        case 2: { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_3CB };
        case 3: { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_SOG };
        case 4: { RB_CivilianVehiclePool = +RB_CivilianVehiclePool_RDS_West };
    };
    RB_ActiveVehiclePool = RB_CivilianVehiclePool;
    publicVariable "RB_ActiveVehiclePool";

    switch (_enemyInfIndex) do {
        case 0: { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_Vanilla };
        case 1: { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_CUP };
        case 2: { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_3CB };
        case 3: { RB_EnemyInfantryPool = +RB_EnemyInfantryPool_SOG };
    };
    publicVariable "RB_EnemyInfantryPool";

    switch (_enemyVehIndex) do {
        case 0: { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_Vanilla };
        case 1: { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_CUP };
        case 2: { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_3CB };
        case 3: { RB_EnemyVehiclePool = +RB_EnemyVehiclePool_SOG };
    };
    publicVariable "RB_EnemyVehiclePool";

    missionNamespace setVariable ["RB_RespawnCost", _respawnCost, true];
    publicVariable "RB_RespawnCost";

    diag_log format ["[RB] Pools: ID=%1, CIV=%2, VEH=%3, ENEMY_INF=%4, ENEMY_VEH=%5",
        _idPoolIndex, _civPoolIndex, _vehPoolIndex, _enemyInfIndex, _enemyVehIndex];

    // Execute additional scripts

    //[] execVM "scripts\civilian\spawnCivilian.sqf";
    //[] execVM "scripts\vehicle\spawnVehicle.sqf";
    [] execVM "scripts\checkAllDead.sqf";
    [] execVM "functions\utility\fn_addGeneratorActions.sqf";
    [] execVM "scripts\effects\runDynamicWeather.sqf";




    waitUntil { !isNil "RB_CivilianPool_Vanilla" };
};

// Initialize generator state on server
if (isServer) then {
    if (isNil "RB_GeneratorState") then {
        RB_GeneratorState = true;
        publicVariable "RB_GeneratorState";
    };
};

// Initial banned town selection
[] spawn {
    [] call RB_fnc_updateBannedTowns;

    while { true } do {
        sleep 1800; // 30 minutes 1800
        [] call RB_fnc_updateBannedTowns;
    };
};


// Add ACE actions on clients
[] spawn {
    waitUntil { !isNull (missionNamespace getVariable ["RB_Generator", objNull]) };
    [] call RB_fnc_addGeneratorActions;
};


addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer"];

    if (!isNull _unit && {_unit isKindOf "CAManBase"} && {isPlayer _killer}) then {
        [_unit, _killer] call RB_fnc_onCivilianKilled;
    };
}];

if (isServer) then {
    [] spawn {
        // 1) wait for the editor-placed object
        waitUntil { !isNull RB_Terminal };

        // 2) now broadcast the call to the clients (and flag it jippable)
        //[ RB_Terminal ] remoteExec ["RB_fnc_addTerminalActions", 0, true];
        [ RB_Terminal ] remoteExecCall ["RB_fnc_addTerminalActions", 0, true];
    };
};





