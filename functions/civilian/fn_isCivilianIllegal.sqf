params ["_civ"];

private _contraband = _civ getVariable ["civ_contraband", []];
if (_contraband isNotEqualTo []) exitWith { true };

private _id = _civ getVariable ["civ_identity", ["Unknown", "Unknown", "Unknown", "UNKNOWN"]];
private _origin = _id#1;
if (!isNil "RB_BannedTowns" && { _origin in RB_BannedTowns }) exitWith { true };

// Check direct vehicle violation flags
if (
    _civ getVariable ["cached_veh_contraband", []] isNotEqualTo [] ||
    _civ getVariable ["cached_veh_plateMismatch", false] ||
    _civ getVariable ["cached_veh_regNameMismatch", false] ||
    _civ getVariable ["cached_veh_regIDMismatch", false]
) exitWith { true };

// Fallback: check the vehicle they were in
private _veh = _civ getVariable ["rb_vehicle", objNull];
if (!isNull _veh) then {
    if (
        _veh getVariable ["cached_veh_contraband", []] isNotEqualTo [] ||
        _veh getVariable ["cached_veh_plateMismatch", false] ||
        _veh getVariable ["cached_veh_regNameMismatch", false] ||
        _veh getVariable ["cached_veh_regIDMismatch", false]
    ) exitWith { true };
};

false
