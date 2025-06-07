class RB {
    class Civilian {
        file = "functions\civilian";
        class checkCivilianID {};
        class assignIdentityAndContraband {};
        class addCivilianActions {};
        class searchCivilian {};
        class evaluateDetainedCivilian {};
        class spawnCivilianVehicle {};
        class isCivilianIllegal {};
        class debugIllegalReason {};
        class tryTurnHostile {};
        class processCivilian {};
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
    };
    class Logistics {
        file = "functions\logistics";
        class handleLogisticsRequest {};
        class addCrateActions {};
    };
    class Combat {
        file = "functions\combat";
        class spawnEnemyAttack {};
    };
    class Utility {
        file = "functions\utility";
        class addGeneratorActions {};
        class updateLamps {};
        class getStarterLoadout {};
        class moveVehicleSmooth {};
    };
    class Persistence {
        file = "functions\persistence";
        class loadProgress {};
        class saveProgress {};
    };
};
