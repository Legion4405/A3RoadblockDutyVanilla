/*
    File: fn_judgeVehicle.sqf
    Params: [_vehicle]
    Returns: [illegal(bool), [reasons (display)], scoreDelta, statusText]
*/
params ["_vehicle"];
private _scoringTable = missionNamespace getVariable ["RB_ScoringTable", []];
private _scoringMap   = missionNamespace getVariable ["RB_ScoringTableMap", createHashMap];

// --- Helper to get display reason string by key
private _getReasonText = {
    params ["_key"];
    private _entry = _scoringTable select { _x#0 == _key };
    if (count _entry > 0) then { (_entry select 0)#2 } else { _key };
};

private _reasons    = [];
private _illegal    = false;
private _scoreDelta = 0;
private _statusText = "";

// Bomb logic: active or defused
private _hadBomb      = _vehicle getVariable ["rb_hadBomb", false];         // This variable must be set ONCE a bomb is present, never unset!
private _hasBomb      = _vehicle getVariable ["rb_hasBomb", false];         // True if bomb is still in vehicle
private _bombDefused  = _vehicle getVariable ["rb_bombDefused", false];     // True if bomb has been defused

// --- 1. Active bomb = penalty
if (_hasBomb) then {
    _illegal = true;
    _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["vehicle_bomb", 25]);
    _reasons pushBack (["vehicle_bomb"] call _getReasonText);
};

// --- 2. If the vehicle ever had a bomb, but it's now defused
if (_hadBomb && _bombDefused) then {
    _illegal = true;
    _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["vehicle_bomb_defused", -10]);
    _reasons pushBack (["vehicle_bomb_defused"] call _getReasonText);
};

// --- 3. Contraband
private _contraband = _vehicle getVariable ["veh_contraband", []];
private _hasContraband = (_contraband isNotEqualTo []);
if (_hasContraband) then {
    _illegal = true;
    _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["vehicle_contraband", 10]);
    _reasons pushBack (["vehicle_contraband"] call _getReasonText);
};

// --- 4. Registration mismatches
private _plateMismatch = _vehicle getVariable ["cached_veh_plateMismatch", false];
private _nameMismatch  = _vehicle getVariable ["cached_veh_regNameMismatch", false];
private _idMismatch    = _vehicle getVariable ["cached_veh_regIDMismatch", false];
private _noOwner       = (_vehicle getVariable ["cached_veh_regOwner", ""] == "Unknown");

if (_plateMismatch) then {
    _illegal = true;
    _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["plate_mismatch", 5]);
    _reasons pushBack (["plate_mismatch"] call _getReasonText);
};
if (_nameMismatch) then {
    _illegal = true;
    _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["registration_mismatch", 5]);
    _reasons pushBack (["registration_mismatch"] call _getReasonText + " (Name)");
};
if (_idMismatch) then {
    _illegal = true;
    _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["registration_mismatch", 5]);
    _reasons pushBack (["registration_mismatch"] call _getReasonText + " (ID)");
};
if (_noOwner) then {
    _illegal = true;
    _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["registration_mismatch", 5]);
    _reasons pushBack (["registration_mismatch"] call _getReasonText + " (No Registered Owner)");
};

// --- Final status text
if (_illegal) then {
    _statusText = format ["❌ Illegal (%1)", _reasons joinString ", "];
} else {
    _scoreDelta = _scoringMap getOrDefault ["vehicle_release", 3];
    _statusText = "✅ Released (Clean Vehicle)";
};

[_illegal, _reasons, _scoreDelta, _statusText]
