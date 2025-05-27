// functions\civilian\fn_debugIllegalReason.sqf
params ["_civ"];

if (isNull _civ || {!alive _civ}) exitWith {
    hint "Civilian is null or dead.";
};

// === Gather variables
private _personal = _civ getVariable ["civ_contraband", []];
private _vehicle = _civ getVariable ["rb_vehicle", objNull];
private _vehContraband = [];

if (!isNull _vehicle) then {
    _vehContraband = _vehicle getVariable ["veh_contraband", []];
} else {
    _vehContraband = _civ getVariable ["cached_veh_contraband", []];
};

private _identity = _civ getVariable ["civ_identity", ["Unknown", "Unknown", "Unknown", "UNKNOWN"]];
private _origin = _identity param [1, "Unknown"];
private _bannedOrigins = missionNamespace getVariable ["RB_BannedOrigins", []];
private _isFromBannedOrigin = _bannedOrigins find _origin > -1;

// Cached registration violations
private _plateMismatch   = _civ getVariable ["cached_veh_plateMismatch", false];
private _regNameMismatch = _civ getVariable ["cached_veh_regNameMismatch", false];
private _regIDMismatch   = _civ getVariable ["cached_veh_regIDMismatch", false];

// === Build list of reasons
private _reasons = [];

if (_personal isNotEqualTo []) then {
    _reasons pushBack "Has contraband";
};
if (_vehContraband isNotEqualTo []) then {
    _reasons pushBack "Vehicle has contraband";
};
if (_isFromBannedOrigin) then {
    _reasons pushBack format ["From banned origin: %1", _origin];
};
if (_plateMismatch) then {
    _reasons pushBack "License plate mismatch";
};
if (_regNameMismatch) then {
    _reasons pushBack "Registration name mismatch";
};
if (_regIDMismatch) then {
    _reasons pushBack "Registration ID mismatch";
};

if (_reasons isEqualTo []) then {
    hint "Civilian is clean.";
} else {
    hint format ["Illegal Reason(s):\n%1", _reasons joinString "\n"];
};
