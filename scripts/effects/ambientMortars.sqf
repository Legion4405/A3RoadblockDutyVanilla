/*
    File: ambientMortars.sqf
    Description: Periodically spawns mortar barrages.
    Logic extracted to RB_fnc_spawnMortarBarrage.
*/

if (!isServer) exitWith {};

private _enabled = ["RB_EnableMortars", 0] call BIS_fnc_getParamValue;
if (_enabled == 0) exitWith {
    diag_log "[RB] Ambient mortar strikes are disabled by mission parameter.";
};

while { true } do {
    private _delay = 420 + random 900;
    sleep _delay;

    if (({isPlayer _x} count allPlayers) == 0) then { continue; };
    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then { continue; };

    [] call RB_fnc_spawnMortarBarrage;
};