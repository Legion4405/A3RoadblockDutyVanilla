/*
    File: scripts/system/manageRespawns.sqf
    Description: Every 2s, fetches the mission-param respawn cost, reads current score,
                 and adjusts BLUFOR’s respawn tickets to exactly floor(score/cost).
*/

if (!isServer) exitWith {};

// wait for parameters to be loaded
waitUntil { !(["RB_RespawnCost", 0] call BIS_fnc_getParamValue isEqualTo 0 ) };

// fetch it once (won’t change at runtime)
private _respawnCost = ["RB_RespawnCost", 10] call BIS_fnc_getParamValue;

while { true } do {
    sleep 2;

    private _score          = RB_Terminal getVariable ["rb_score", 0];
    private _desiredTickets = floor (_score / _respawnCost);
    private _currentTickets = [west] call BIS_fnc_respawnTickets;

    private _delta = _desiredTickets - _currentTickets;
    if (_delta != 0) then {
        [west, _delta] call BIS_fnc_respawnTickets;
    };
};
