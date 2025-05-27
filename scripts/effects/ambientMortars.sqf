/*
    File: ambientMortars.sqf
    Description: Periodically spawns a temporary AI-manned mortar that fires 2–5 scattered shells at a random point near the checkpoint.
*/

if (!isServer) exitWith {};

private _enabled = ["RB_EnableMortars", 0] call BIS_fnc_getParamValue;
if (_enabled == 0) exitWith {
    diag_log "[RB] Ambient mortar strikes are disabled by mission parameter.";
};

private _checkpoint = getMarkerPos "RB_Checkpoint";
private _mortarSite = getMarkerPos "RB_MortarSite";

while { true } do {
    // === Delay between mortar events (5–20 min)
    private _delay = 300 + random 900;
    sleep _delay;

    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then {
        continue;
    };

    private _roundCount = 2 + floor random 4; // 2 to 5 rounds
    private _ammoType = "8Rnd_82mm_Mo_shells";

    // === Determine target center
    private _radiusMin = 100;
    private _radiusMax = 300;
    private _angle = random 360;
    private _distance = _radiusMin + random (_radiusMax - _radiusMin);
    private _strikeOffset = [_distance * cos _angle, _distance * sin _angle, 0];
    private _strikeCenter = _checkpoint vectorAdd _strikeOffset;

    // === Spawn mortar and gunner
    private _mortar = createVehicle ["B_Mortar_01_F", _mortarSite, [], 0, "NONE"];
    _mortar setDir (_mortarSite getDir _strikeCenter);
    _mortar setVehicleAmmo 1;
    _mortar disableAI "MOVE";

    private _grp = createGroup east;
    private _gunner = _grp createUnit ["O_Soldier_F", _mortarSite, [], 0, "NONE"];
    _gunner moveInGunner _mortar;
    _gunner setBehaviour "COMBAT";
    _gunner setCombatMode "RED";
    _gunner doWatch _strikeCenter;

    // === Chance to trigger enemy attack
    private _attackChance = ["RB_EnemyAttackChance", 50] call BIS_fnc_getParamValue;
    private _roll = random 100;

    if (_roll < _attackChance) then {
        diag_log "[RB] Mortar strike triggered enemy attack!";
        [] spawn RB_fnc_spawnEnemyAttack;

        if (random 1 < 0.5) then {
            diag_log "[RB] A second enemy wave is joining the assault!";
            [] spawn RB_fnc_spawnEnemyAttack;
        };
    } else {
        diag_log "[RB] No enemy attack triggered.";
    };

    // === Fire rounds
    for "_i" from 1 to _roundCount do {
        private _spread = 15 + random 25;
        private _offset = [random [-_spread, 0, _spread], random [-_spread, 0, _spread], 0];
        private _target = _strikeCenter vectorAdd _offset;

        _mortar doArtilleryFire [_target, _ammoType, 1];
        sleep (2 + random 1.5);
    };

    // === Cleanup after 10 seconds
    [_mortar, _gunner] spawn {
        params ["_mortar", "_gunner"];
        sleep 10;

        if (!isNull _mortar) then { deleteVehicle _mortar };
        if (!isNull _gunner) then { deleteVehicle _gunner };
        diag_log "[RB] Mortar and crew deleted.";
    };
};
