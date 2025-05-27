
RB_SpawnerHandle = [] execVM "scripts\runCheckpointSpawner.sqf";
    [] execVM "scripts\initContraband.sqf";
    [] execVM "scripts\combat\runEnemyAttackSpawner.sqf";
    [] execVM "scripts\combat\runEnemyVehicleSpawner.sqf";
    [] execVM "scripts\effects\ambientMortars.sqf";
    [] execVM "scripts\manageRespawns.sqf";
    [] execVM "scripts\system\garbageCleanup.sqf"; 
