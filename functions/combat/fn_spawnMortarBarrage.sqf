/*
    File: fn_spawnMortarBarrage.sqf
    Description: Spawns a temporary mortar that fires a barrage at the checkpoint.
    Params: [_forceFlares (bool, optional)]
*/

if (!isServer) exitWith {};
params [["_forceFlares", false]];

private _checkpoint = getMarkerPos "RB_Checkpoint";
private _mortarSite = getMarkerPos "RB_MortarSite";

if (_checkpoint isEqualTo [0,0,0] || _mortarSite isEqualTo [0,0,0]) exitWith {
    diag_log "[RB] Error: Mortar markers missing.";
};

private _isNight = (sunOrMoon < 0.2); 
private _fireFlares = _forceFlares;
private _ammoType = "8Rnd_82mm_Mo_shells";
private _radiusMin = 50;
private _radiusMax = 225;
private _roundCount = 2 + floor random 4; // 2–5 rounds

// Auto-determine flares if not forced
if (!_forceFlares && _isNight && {random 1 < 0.5}) then {
    _fireFlares = true;
};

if (_fireFlares) then {
    _ammoType = "8Rnd_82mm_Mo_Flare_white"; 
    _radiusMin = 0;
    _radiusMax = 125;
    _roundCount = 3 + floor random 5;
    diag_log "[RB] Mortar firing flares.";
};

// Spawn mortar and gunner
private _mortar = createVehicle ["B_Mortar_01_F", _mortarSite, [], 0, "NONE"];
_mortar setDir (_mortarSite getDir _checkpoint);
_mortar setVehicleAmmo 1;
_mortar disableAI "MOVE";

private _grp = createGroup east;
private _gunner = _grp createUnit ["O_Soldier_F", _mortarSite, [], 0, "NONE"];
_gunner moveInGunner _mortar;
_gunner setBehaviour "COMBAT";
_gunner setCombatMode "RED";
_gunner doWatch _checkpoint;

// Enemy Attack Trigger (Only if HE)
if (!_fireFlares) then {
    private _attackChance = ["RB_EnemyAttackChance", 50] call BIS_fnc_getParamValue;
    if (random 100 < _attackChance) then {
        diag_log "[RB] Mortar strike triggered follow-up enemy attack!";
        [] spawn RB_fnc_spawnEnemyAttack;
    };
};

// Fire Sequence
[_mortar, _gunner, _checkpoint, _ammoType, _roundCount, _radiusMin, _radiusMax] spawn {
    params ["_mortar", "_gunner", "_checkpoint", "_ammoType", "_roundCount", "_radiusMin", "_radiusMax"];
    
    for "_i" from 1 to _roundCount do {
        if (!alive _mortar || !alive _gunner) exitWith {};
        private _angle = random 360;
        private _distance = _radiusMin + random (_radiusMax - _radiusMin);
        private _offset = [_distance * cos _angle, _distance * sin _angle, 0];
        private _target = _checkpoint vectorAdd _offset;
        
        _mortar doArtilleryFire [_target, _ammoType, 1];
        sleep (2 + random 1.5);
    };

    // Cleanup
    sleep 10;
    if (!isNull _mortar) then { deleteVehicle _mortar };
    if (!isNull _gunner) then { deleteVehicle _gunner };
};
