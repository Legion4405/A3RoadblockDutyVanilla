/*
    File: fn_isCivilianIllegal.sqf
    Description: Returns [bool, reason string] — true if illegal, with explanation.
*/

params ["_civ"];

// === 1. On-person contraband
private _contraband = _civ getVariable ["civ_contraband", []];
if (_contraband isNotEqualTo []) exitWith {
    [true, "Contraband"]
};

// === 2. Banned origin
private _id = _civ getVariable ["civ_identity", ["Unknown", "Unknown", "Unknown", "UNKNOWN"]];
private _origin = _id#1;
if (!isNil "RB_BannedTowns" && { _origin in RB_BannedTowns }) exitWith {
    [true, format ["Banned Origin (%1)", _origin]]
};

// === 3. Directly stored vehicle violation flags (e.g., inherited from assigned vehicle)
if (_civ getVariable ["cached_veh_contraband", []] isNotEqualTo []) exitWith {
    [true, "Contraband in Vehicle"]
};
if (_civ getVariable ["cached_veh_plateMismatch", false]) exitWith {
    [true, "Plate Mismatch"]
};
if (_civ getVariable ["cached_veh_regNameMismatch", false]) exitWith {
    [true, "Registration Name Mismatch"]
};
if (_civ getVariable ["cached_veh_regIDMismatch", false]) exitWith {
    [true, "Registration ID Mismatch"]
};

// === 4. Explicit driver logic — contraband or bomb means driver is illegal
private _veh = _civ getVariable ["rb_vehicle", objNull];
if (!isNull _veh) then {
    private _isDriver = (driver _veh == _civ);
    private _vehContraband = _veh getVariable ["cached_veh_contraband", []];
    private _vehBomb = _veh getVariable ["veh_hasBomb", false];

    if (_isDriver && { _vehContraband isNotEqualTo [] }) exitWith {
        [true, "Driver of Vehicle with Contraband"]
    };

    if (_isDriver && { _vehBomb }) exitWith {
        [true, "Driver of Vehicle with Bomb"]
    };

    if (_vehContraband isNotEqualTo []) exitWith {
        [true, "Vehicle Contraband"]
    };
    if (_veh getVariable ["cached_veh_plateMismatch", false]) exitWith {
        [true, "Vehicle Plate Mismatch"]
    };
    if (_veh getVariable ["cached_veh_regNameMismatch", false]) exitWith {
        [true, "Vehicle Registration Name Mismatch"]
    };
    if (_veh getVariable ["cached_veh_regIDMismatch", false]) exitWith {
        [true, "Vehicle Registration ID Mismatch"]
    };
};

[false, ""]
