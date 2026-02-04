/*
    File: fn_validateCivilian.sqf
    Description:
        Comprehensive check of a civilian's legality.
        Returns a HashMap with details on violations, arrestability, and scoring keys.
    
    Returns:
        HashMap containing:
        - "isIllegal" (Bool): True if any violation found.
        - "violations" (Array of Strings): List of scoring keys (e.g., ["vehicle_contraband", "plate_mismatch"]).
        - "reasons" (Array of Strings): Human-readable reasons.
        - "isFugitive" (Bool): True if fugitive.
*/

params ["_civ"];

private _violations = [];
private _reasons = [];
private _isIllegal = false;

// === 1. FUGITIVE CHECK (Name Match = Guilty)
private _identity   = _civ getVariable ["civ_identity", ["Unknown", "Unknown", "Unknown", "UNKNOWN"]];
private _name       = _identity param [0, "Unknown"];
private _wantedName = missionNamespace getVariable ["RB_CurrentFugitive", ""];

// We treat them as a fugitive if their identity name matches the wanted name
private _isFugitive = (_wantedName != "" && { _name == _wantedName });

if (_isFugitive) then {
    _violations pushBack "fugitive_arrested";
    _reasons pushBack "Fugitive (Most Wanted)";
    _isIllegal = true;
};

// === 2. BANNED ORIGIN
private _origin = _identity param [1, "Unknown"];
private _bannedTowns = missionNamespace getVariable ["RB_BannedTowns", []];
if (_origin in _bannedTowns) then {
    _violations pushBack "banned_origin";
    _reasons pushBack (format ["Banned Origin (%1)", _origin]);
    _isIllegal = true;
};

// === 3. PERSONAL CONTRABAND
private _contraband = _civ getVariable ["civ_contraband", []];
if (_contraband isEqualTo []) then { 
    // Fallback to older variable name if any
    _contraband = _civ getVariable ["rb_contraband", []];
};
if (_contraband isNotEqualTo []) then {
    _violations pushBack "personal_contraband";
    _reasons pushBack "Personal Contraband";
    _isIllegal = true;
};

// === 3.5 LYING (Verbal Deception)
private _story = _civ getVariable ["rb_civ_story", []];
private _isLying = if (count _story >= 4) then { _story select 3 } else { false };

if (_isLying) then {
    _violations pushBack "lying";
    _reasons pushBack "Lying to Authority";
    _isIllegal = true;
};

// === 3.6 TRAVEL PERMIT CHECKS
private _permit = _civ getVariable ["rb_travel_permit", []];
private _storyData = _civ getVariable ["rb_civ_story", ["Unknown", "Unknown"]];
_storyData params ["_storyOrigin", "_storyDest"];

if (_permit isEqualTo []) then {
    _violations pushBack "missing_permit";
    _reasons pushBack "Missing Travel Permit";
    _isIllegal = true;
} else {
    _permit params ["_permOrigin", "_permDest", "_permDateStr", "_permExpiryVal"];
    
    // Check Expiry
    if (dateToNumber date > _permExpiryVal) then {
        _violations pushBack "permit_expired";
        _reasons pushBack "Expired Travel Permit";
        _isIllegal = true;
    };
    
    // Check Route Mismatch
    // If permit is not ALL, it must match the claimed story
    private _originMatch = (_permOrigin == "ALL" || _permOrigin == _storyOrigin);
    private _destMatch   = (_permDest == "ALL" || _permDest == _storyDest);
    
    if (!_originMatch || !_destMatch) then {
        _violations pushBack "permit_mismatch";
        _reasons pushBack "Permit Route Mismatch";
        _isIllegal = true;
    };
};

// === 4. VEHICLE CHECKS (Driver Responsibility)
private _vehicle = _civ getVariable ["rb_vehicle", objNull];

// If not currently in vehicle, check persistent variables (for post-exit judgment)
private _hadBomb = false;
private _bombDefused = false;
private _vehContraband = [];
private _wasDriver = false;

if (!isNull _vehicle) then {
    _wasDriver = (driver _vehicle == _civ);
    _hadBomb = _vehicle getVariable ["rb_hasBomb", false]; 
    if (!_hadBomb) then { _hadBomb = _vehicle getVariable ["veh_hasBomb", false]; };
    
    _bombDefused = _vehicle getVariable ["rb_bombDefused", false];
    _vehContraband = _vehicle getVariable ["veh_contraband", []];
    if (_vehContraband isEqualTo []) then { _vehContraband = _vehicle getVariable ["cached_veh_contraband", []]; };
} else {
    // Use persistent context (set when they get out)
    _wasDriver = _civ getVariable ["rb_vehicleWasDriver", false];
    _hadBomb = _civ getVariable ["rb_vehicleBombHad", false];
    _bombDefused = _civ getVariable ["rb_vehicleBombDefused", false];
    _vehContraband = _civ getVariable ["rb_vehicleContraband", []];
};

// --- Bomb Check (Applies to ALL occupants) ---
if (_hadBomb) then {
    if (_bombDefused) then {
        _violations pushBack "vehicle_bomb_defused";
        _reasons pushBack "Vehicle Bomb (Defused)";
    } else {
        _violations pushBack "vehicle_bomb";
        _reasons pushBack "Vehicle Bomb";
    };
    _isIllegal = true;
};

// --- Driver Only Checks ---
if (_wasDriver) then {
    
    // Vehicle Contraband
    if (_vehContraband isNotEqualTo []) then {
        _violations pushBack "vehicle_contraband";
        _reasons pushBack "Vehicle Contraband";
        _isIllegal = true;
    };

    // Paperwork Mismatches
    // We check the VEHICLE object if present, or CIV cache if vehicle is gone/null
    private _checkSource = if (!isNull _vehicle) then { _vehicle } else { _civ };
    
    // Plate
    if (_checkSource getVariable ["cached_veh_plateMismatch", false]) then {
        _violations pushBack "plate_mismatch";
        _reasons pushBack "Plate Mismatch";
        _isIllegal = true;
    };
    
    // Registration Name
    if (_checkSource getVariable ["cached_veh_regNameMismatch", false]) then {
        _violations pushBack "registration_mismatch";
        _reasons pushBack "Registration Name Mismatch";
        _isIllegal = true;
    };
    
    // Registration ID
    if (_checkSource getVariable ["cached_veh_regIDMismatch", false]) then {
        _violations pushBack "registration_mismatch"; // Reusing key
        _reasons pushBack "Registration ID Mismatch";
        _isIllegal = true;
    };
};

private _result = createHashMap;
_result set ["isIllegal", _isIllegal];
_result set ["violations", _violations];
_result set ["reasons", _reasons];
_result set ["isFugitive", _isFugitive];

_result