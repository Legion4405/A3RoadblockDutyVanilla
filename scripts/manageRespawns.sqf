/*
    File: scripts/system/manageRespawns.sqf
    Description: Adjusts respawn tickets every 2 seconds based on team score and respawn cost.
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

    // Get current score and calculate how many tickets you should have
    private _score          = RB_Terminal getVariable ["rb_score", 0];
    private _desiredTickets = floor (_score / _respawnCost);

    // Fetch how many tickets we actually have
    private _currentTickets = [west] call BIS_fnc_respawnTickets;

    // Compute the difference and apply it
    private _delta = _desiredTickets - _currentTickets;
    if (_delta != 0) then {
        [west, _delta] call BIS_fnc_respawnTickets;
    };
};
