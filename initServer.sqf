
RB_SpawnerHandle = [] execVM "scripts\runCheckpointSpawner.sqf";
    [] execVM "scripts\combat\runEnemyAttackSpawner.sqf";
    [] execVM "scripts\combat\runEnemyVehicleSpawner.sqf";
    [] execVM "scripts\effects\ambientMortars.sqf";
    [] execVM "scripts\manageRespawns.sqf";
    [] execVM "scripts\system\garbageCleanup.sqf"; 
    [] execVM "scripts\initContraband.sqf";
    [] execVM "functions\ambient\fn_ambientAirFlyover.sqf";
    [] execVM "functions\ambient\fn_ambientTraffic.sqf";

// Handle banned towns and respawn logic 
[] spawn {
    [] call RB_fnc_updateBannedTowns; // Updates RB_BannedTowns variable
    [
        missionNamespace getVariable ["RB_BannedTowns", []]
    ] remoteExec ["RB_fnc_updateBannedTownsDiary", 0, true];

    while {true} do {
        sleep 1800;
        [] call RB_fnc_updateBannedTowns;
        [
            missionNamespace getVariable ["RB_BannedTowns", []]
        ] remoteExec ["RB_fnc_updateBannedTownsDiary", 0, true];
    };
};

setTimeMultiplier 4;

