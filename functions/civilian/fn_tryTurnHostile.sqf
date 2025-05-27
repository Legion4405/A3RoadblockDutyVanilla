params ["_civ"];

// === Already hostile? Skip
if (side group _civ != civilian) exitWith {};

// === Retrieve civilian identity data
private _contraband = _civ getVariable ["civ_contraband", []];
private _identity   = _civ getVariable ["civ_identity", ["Unknown", "Unknown", "Unknown", "UNKNOWN"]];
private _origin     = _identity param [1, "Unknown"];

// === Require contraband or banned origin
if (_contraband isEqualTo [] && {isNil "RB_BannedTowns" || {!(_origin in RB_BannedTowns)}}) exitWith {};

// === Chance to turn hostile (default 100% for testing)
private _chance = missionNamespace getVariable ["RB_HostileChance", 0.05];
if (random 1 > _chance) exitWith {};

// === Create hostile group and reassign
private _grp = createGroup east;
[_civ] joinSilent _grp;

_civ setVariable ["rb_isHostile", true, true];

// === Shout using voice line
private _phrases = [
    "Covering!", "Engaging!", "Opening fire!", "Taking fire!", "Contact!", "Suppressing!"
];
private _voiceLine = selectRandom _phrases;
[_civ, _voiceLine] remoteExec ["BIS_fnc_sayMessage", 0];

// === Select hostile weapon
if (isNil "RB_HostileWeapons") then {
    diag_log "[RB] WARNING: RB_HostileWeapons undefined, using fallback.";
    RB_HostileWeapons = [["hgun_Pistol_01_F", ["10Rnd_9x21_Mag", 3]]];
};
private _weaponSet = selectRandom RB_HostileWeapons;
private _weapon = _weaponSet#0;
private _mags   = _weaponSet#1;
private _magType = _mags#0;
private _magCount = _mags#1;

// === Arm the civilian
removeAllWeapons _civ;
removeAllItems _civ;
_civ addWeapon _weapon;
for "_i" from 1 to _magCount do {
    _civ addMagazine _magType;
};
_civ selectWeapon _weapon;

// === Set combat behavior
_civ setCombatMode "RED";
_civ setBehaviour "COMBAT";

// === Engage nearest players
{
    if (side _x == west && alive _x) then {
        _civ doTarget _x;
        _civ doFire _x;
    };
} forEach allPlayers;

// === Log
diag_log format ["[RB] Civilian %1 has turned hostile with %2", name _civ, _weapon];
hint format ["⚠️ %1 has drawn a weapon!", name _civ];
