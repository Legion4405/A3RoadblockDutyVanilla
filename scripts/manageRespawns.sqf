/*
    File: scripts/system/manageRespawns.sqf
    Description: Adjusts respawn tickets every 2 seconds based on team score and respawn cost.
    If respawn cost is zero, grants unlimited tickets.
*/

if (!isServer) exitWith {};

// Wait for the terminal & parameters to be loaded
waitUntil {
    !isNil "RB_Terminal" &&
    (["RB_RespawnCost", -1] call BIS_fnc_getParamValue) isNotEqualTo -1
};

// Cache the true cost parameter once
private _respawnCost = ["RB_RespawnCost", 10] call BIS_fnc_getParamValue;

while { true } do {
    sleep 2;
    private _score = RB_Terminal getVariable ["rb_score", 0];

    private _desiredTickets = 0; // Always initialize!
    if (_respawnCost == 0) then {
        _desiredTickets = -1; // unlimited
    } else {
        // Extra safety
        if (_respawnCost > 0) then {
            _desiredTickets = floor (_score / _respawnCost);
        };
    };

    private _currentTickets = [west] call BIS_fnc_respawnTickets;
    if (_desiredTickets != _currentTickets) then {
        [west, _desiredTickets - _currentTickets] call BIS_fnc_respawnTickets;
    };
};
