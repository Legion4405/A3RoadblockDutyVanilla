/*
    File: checkAllDead.sqf
    Description: Ends mission if all players are dead and not enough score is available for respawn.
*/

// Wait until at least one player is alive (first spawn complete)
waitUntil {
    time > 10 && { count (allPlayers select { alive _x }) > 0 }
};

// Begin monitoring after initial spawn
while { true } do {
    sleep 5;

    private _respawnCost = missionNamespace getVariable ["RB_RespawnCost", 10];
    private _score = RB_Terminal getVariable ["rb_score", 0];

    private _alivePlayers = allPlayers select { alive _x };
    private _numAlive = count _alivePlayers;

    if (_numAlive == 0 && { _score < _respawnCost }) then {
        ["end1", false] call BIS_fnc_endMission;
        break;
    };
};
