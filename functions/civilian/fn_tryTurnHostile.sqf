/*
    File: TurnHostile.sqf
    Description: Converts a civilian into a hostile (OPFOR) attacker if illegal.
                 Ensures re-enabled movement, fully loaded weapon, and issues a waypoint to attack nearest player.
                 Also prevents vehicle re-entry.
*/

params ["_civ"];

// === Already hostile? Skip
if (side group _civ != civilian) exitWith {};

// === Retrieve civilian identity data
private _contraband = _civ getVariable ["civ_contraband", []];
private _identity   = _civ getVariable ["civ_identity", ["Unknown", "Unknown", "Unknown", "UNKNOWN"]];
private _origin     = _identity param [1, "Unknown"];

// === Require contraband or banned origin
if (_contraband isEqualTo [] && {isNil "RB_BannedTowns" || {!(_origin in RB_BannedTowns)}}) exitWith {};

// === Chance to turn hostile (default 5% unless overridden)
private _chance = missionNamespace getVariable ["RB_HostileChance", 0.05];
if (random 1 > _chance) exitWith {};

// === Prevent vehicle re-entry (safety if they were a driver or passenger)
unassignVehicle _civ;
_civ setVariable ["rb_preventReentry", true, true];
_civ setVariable ["rb_vehicle", nil, true];

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

// === Arm the civilian and ensure weapon is loaded with a full mag
removeAllWeapons _civ;
removeAllItems _civ;


// Add one full mag for the weapon and load it immediately
_civ addMagazine _magType;
_civ addWeapon _weapon;
private _muzzles = getArray (configFile >> "CfgWeapons" >> _weapon >> "muzzles");
private _muzzle = if (_muzzles isEqualTo [] || {_muzzles isEqualTo ["this"]}) then {"this"} else {_muzzles select 0};
_civ selectWeapon _weapon;
_civ loadMagazine [_muzzle, _magType];

// Add remaining spare magazines
for "_i" from 2 to _magCount do {
    _civ addMagazine _magType;
};

// === Make sure AI movement/stop disables are reset
_civ enableAI "MOVE";
_civ stop false;
doStop _civ;
_civ setUnitPos "UP";
_civ setCombatMode "RED";
_civ setBehaviour "COMBAT";

// === Use waypoints to attack nearest player, not just doMove
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
    // No players? Just wander a bit
    private _randPos = _civ getPos [15 + random 25, random 360];
    _grp addWaypoint [_randPos, 0];
    [_grp, 1] setWaypointType "MOVE";
    [_grp, 1] setWaypointBehaviour "COMBAT";
    [_grp, 1] setWaypointCompletionRadius 10;
};

// === Log
diag_log format ["[RB] Civilian %1 has turned hostile with %2", name _civ, _weapon];
