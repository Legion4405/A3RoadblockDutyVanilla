/*
    File: TurnHostile.sqf
    Description: Converts a civilian into a hostile OPFOR attacker if judgeCivilianArrest finds them arrestable.
                 Reloads weapon, prevents vehicle re-entry, and attacks nearest player.
*/

params ["_civ"];

// Only convert true civilians!
if (side group _civ != civilian) exitWith {};

// Use judgeCivilian for data-driven decision
private _result = [_civ] call RB_fnc_judgeCivilian;
private _arrestable = _result param [0, false];

// Only allow turning hostile if this civilian would be considered "arrestable"
if (!_arrestable) exitWith {};

// Hostile chance check (from config or missionNamespace)
private _chance = missionNamespace getVariable ["RB_HostileChance", 0.1];
if (random 1 > _chance) exitWith {};

// Disallow vehicle re-entry
unassignVehicle _civ;
_civ setVariable ["rb_preventReentry", true, true];
_civ setVariable ["rb_vehicle", nil, true];

// Move civilian to OPFOR
private _grp = createGroup east;
[_civ] joinSilent _grp;
_civ setVariable ["rb_isHostile", true, true];

// Voice line
private _phrases = [
    "Covering!", "Engaging!", "Opening fire!", "Taking fire!", "Contact!", "Suppressing!"
];
private _voiceLine = selectRandom _phrases;
[_civ, _voiceLine] remoteExec ["BIS_fnc_sayMessage", 0];

// Choose weapon set
if (isNil "RB_HostileWeapons") then {
    diag_log "[RB] WARNING: RB_HostileWeapons undefined, using fallback.";
    RB_HostileWeapons = [["hgun_Pistol_01_F", ["10Rnd_9x21_Mag", 3]]];
};
private _weaponSet = selectRandom RB_HostileWeapons;
private _weapon = _weaponSet#0;
private _mags   = _weaponSet#1;
private _magType = _mags#0;
private _magCount = _mags#1;

removeAllWeapons _civ;
removeAllItems _civ;

_civ addMagazine _magType;
_civ addWeapon _weapon;
private _muzzles = getArray (configFile >> "CfgWeapons" >> _weapon >> "muzzles");
private _muzzle = if (_muzzles isEqualTo [] || {_muzzles isEqualTo ["this"]}) then {"this"} else {_muzzles select 0};
_civ selectWeapon _weapon;
_civ loadMagazine [_muzzle, _magType];

for "_i" from 2 to _magCount do {
    _civ addMagazine _magType;
};

// Restore full movement and make aggressive
_civ enableAI "MOVE";
_civ stop false;
doStop _civ;
_civ setUnitPos "UP";
_civ setCombatMode "RED";
_civ setBehaviour "COMBAT";

// Attack nearest player if found, otherwise patrol randomly
if (count allPlayers > 0) then {
    private _nearest = [allPlayers, _civ] call BIS_fnc_nearestPosition;
    _grp addWaypoint [getPosATL _nearest, 0];
    [_grp, 1] setWaypointType "MOVE";
    [_grp, 1] setWaypointBehaviour "COMBAT";
    [_grp, 1] setWaypointCombatMode "RED";
    [_grp, 1] setWaypointSpeed "FULL";
    [_grp, 1] setWaypointCompletionRadius 10;
    _civ doTarget _nearest;
    _civ doFire _nearest;
} else {
    private _randPos = _civ getPos [15 + random 25, random 360];
    _grp addWaypoint [_randPos, 0];
    [_grp, 1] setWaypointType "MOVE";
    [_grp, 1] setWaypointBehaviour "COMBAT";
    [_grp, 1] setWaypointCompletionRadius 10;
};

diag_log format ["[RB] Civilian %1 has turned hostile with %2", name _civ, _weapon];
