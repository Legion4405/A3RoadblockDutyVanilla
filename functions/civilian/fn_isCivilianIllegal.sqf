/*
    File: fn_isCivilianIllegal.sqf
    Description: Returns [bool, reason string, isLegitArrest] — true if illegal, reason, and whether it's a legit arrest (for scoring).
*/

params ["_civ"];

// On-person contraband (legit arrest)
private _contraband = _civ getVariable ["civ_contraband", []];
if (_contraband isNotEqualTo []) exitWith {
    [true, "Contraband", true]
};

// Banned origin (NOT a legit arrest—player should not arrest for this alone)
private _id = _civ getVariable ["civ_identity", ["Unknown", "Unknown", "Unknown", "UNKNOWN"]];
private _origin = _id#1;
if (!isNil "RB_BannedTowns" && { _origin in RB_BannedTowns }) exitWith {
    [true, format ["Banned Origin (%1)", _origin], false]
};

// Directly stored vehicle violation flags (player should arrest for these; legit)
if (_civ getVariable ["cached_veh_contraband", []] isNotEqualTo []) exitWith {
    [true, "Contraband in Vehicle", true]
};
if (_civ getVariable ["cached_veh_plateMismatch", false]) exitWith {
    [true, "Plate Mismatch", true]
};
if (_civ getVariable ["cached_veh_regNameMismatch", false]) exitWith {
    [true, "Registration Name Mismatch", true]
};
if (_civ getVariable ["cached_veh_regIDMismatch", false]) exitWith {
    [true, "Registration ID Mismatch", true]
};

// Driver logic — if driver of vehicle with contraband or bomb: legit arrest
private _veh = _civ getVariable ["rb_vehicle", objNull];
if (!isNull _veh) then {
    private _isDriver = (driver _veh == _civ);
    private _vehContraband = _veh getVariable ["cached_veh_contraband", []];
    private _vehBomb = _veh getVariable ["veh_hasBomb", false];

    if (_isDriver && { _vehContraband isNotEqualTo [] }) exitWith {
        [true, "Driver of Vehicle with Contraband", true]
    };

    if (_isDriver && { _vehBomb }) exitWith {
        [true, "Driver of Vehicle with Bomb", true]
    };

    // Passengers: legit arrest if vehicle is illegal
    if (_vehContraband isNotEqualTo []) exitWith {
        [true, "Vehicle Contraband", true]
    };
    if (_veh getVariable ["cached_veh_plateMismatch", false]) exitWith {
        [true, "Vehicle Plate Mismatch", true]
    };
    if (_veh getVariable ["cached_veh_regNameMismatch", false]) exitWith {
        [true, "Vehicle Registration Name Mismatch", true]
    };
    if (_veh getVariable ["cached_veh_regIDMismatch", false]) exitWith {
        [true, "Vehicle Registration ID Mismatch", true]
    };
};

[false, "", false]
