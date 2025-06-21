/*
    File: ambientMortars.sqf
    Description: Periodically spawns a temporary AI-manned mortar that fires 2–5 scattered HE shells at a random point near the checkpoint.
                 At night, there is a 50% chance the mortar instead fires flares, with reduced spread (0–125m).
*/

if (!isServer) exitWith {};

private _enabled = ["RB_EnableMortars", 0] call BIS_fnc_getParamValue;
if (_enabled == 0) exitWith {
    diag_log "[RB] Ambient mortar strikes are disabled by mission parameter.";
};

private _checkpoint = getMarkerPos "RB_Checkpoint";
private _mortarSite = getMarkerPos "RB_MortarSite";

while { true } do {
// === Delay between mortar events (5-15 min)
    private _delay = 300 + random 900;
    sleep _delay;

    if (({isPlayer _x} count allPlayers) == 0) then { continue; };
    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then { continue; };

    private _isNight = (sunOrMoon < 0.2); // 0 = night, 1 = day
    private _fireFlares = false;
    private _ammoType = "8Rnd_82mm_Mo_shells";
    private _radiusMin = 50;
    private _radiusMax = 225;
    private _roundCount = 2 + floor random 4; // 2–5 rounds

    // === Nighttime flare logic ===
    if (_isNight && {random 1 < 0.5}) then { // 50% chance at night
        _fireFlares = true;
        _ammoType = "8Rnd_82mm_Mo_Flare_white"; // Use "ACE_82mm_Flare" for ACE flares if desired
        _radiusMin = 0;
        _radiusMax = 125;
        _roundCount = 3 + floor random 5; // 2–4 flares
        diag_log "[RB] Mortar fires flares at night!";
    };

    // === Determine target center (still random, but not used for flares, kept for legacy logic)
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
    _gunner doWatch _checkpoint;

    // === Chance to trigger enemy attack (only for HE strikes)
    if (!_fireFlares) then {
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
    };

    // === Fire rounds (HE or flares)
    for "_i" from 1 to _roundCount do {
        private _angle = random 360;
        private _distance = _radiusMin + random (_radiusMax - _radiusMin);
        private _offset = [_distance * cos _angle, _distance * sin _angle, 0];
        private _target = _checkpoint vectorAdd _offset;
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
