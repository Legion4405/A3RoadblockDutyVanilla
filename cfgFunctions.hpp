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
    };
    class Vehicles {
        file = "functions\vehicle";
        class searchVehicle {};
        class addVehicleActions {};
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
        class deductRespawnCost {};
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
    };
};
