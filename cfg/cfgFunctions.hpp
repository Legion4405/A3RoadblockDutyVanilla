class RB {
    class Civilian {
        file = "functions\civilian";
        class validateCivilian {};
        class checkCivilianID {};
        class assignIdentityAndContraband {};
        class addCivilianActions {};
        class searchCivilian {};
        class spawnCivilianVehicle {};
        class isCivilianIllegal {};
        class debugIllegalReason {};
        class tryTurnHostile {};
        class processCivilian {};
        class interrogateCivilian {};
    };
    class Vehicles {
        file = "functions\vehicle";
        class searchVehicle {};
        class addVehicleActions {};
        class addVehicleSalvageActions {};
        class orderOccupantsOut {};
    };
    class System {
        file = "functions\system";
        class initializeMission {};
        class initializeFactions {};
        class system_trafficLoop {};
        class system_enemyAttackLoop {};
        class addTerminalActions {};
        class clearProcessed {};
        class onCivilianKilled {};
        class onPlayerRespawn {};
        class updateBannedTowns {};
        class setTimeMultiplier {};
        class setTimeOfDay {};
        class setWeatherPreset {};
        class addAdminActions {};
        class addManagementActions {};
        class addPersistenceActions {};
        class deductRespawnCost {};
        class extractLoadoutItems {};
        class updateBannedTownsDiary {};
        class toggleRoadBlock {};
        class applyWeather {};
        class generateFugitive {};
        class updateFugitiveDiary {};
        class debugForceSpawn {};
        class monitorArrival {};
        class toggleDiagnostics {};
    };
    class Logistics {
        file = "functions\logistics";
        class handleLogisticsRequest {};
        class addCrateActions {};
    };
    class Combat {
        file = "functions\combat";
        class spawnEnemyAttack {};
        class spawnEnemyVehicle {};
        class spawnMortarBarrage {};
    };
    class Utility {
        file = "functions\utility";
        class showNotification {};
        class addGeneratorActions {};
        class updateLamps {};
        class getStarterLoadout {};
        class moveVehicleSmooth {};
        class addFortifyRemoveAction {};
        class updateMapDate {};
    };
    class Persistence {
        file = "functions\persistence";
        class loadProgress {};
        class saveProgress {};
        class resetSaveSlot {};
    };
    class Judging {
        file = "functions\judging";
        class judgeCivilian {};
        class judgeVehicle {};
        class processZoneTrigger {};
    };
};
