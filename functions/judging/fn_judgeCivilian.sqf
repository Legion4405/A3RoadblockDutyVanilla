/*
    RB_fnc_judgeCivilian
    params ["_civ"];
    Returns: [arrestable(bool), [reasons (display)], scoreDelta, statusText]
*/
params ["_civ"];
private _scoringTable = missionNamespace getVariable ["RB_ScoringTable", []];
private _scoringMap   = missionNamespace getVariable ["RB_ScoringTableMap", createHashMap];

// --- Helper to get display reason string by key
private _getReasonText = {
    params ["_key"];
    private _entry = _scoringTable select { _x#0 == _key };
    if (count _entry > 0) then { (_entry select 0)#2 } else { _key };
};

// Vehicle context
private _vehicle = _civ getVariable ["rb_vehicle", objNull];
private _hadBomb       = false;
private _bombDefused   = false;
private _vehContraband = [];
private _wasDriver     = false;

if (!isNull _vehicle) then {
    _hadBomb       = _vehicle getVariable ["rb_hasBomb", false];
    _bombDefused   = _vehicle getVariable ["rb_bombDefused", false];
    _vehContraband = _vehicle getVariable ["veh_contraband", []];
    _wasDriver     = (driver _vehicle == _civ);
} else {
    // Use persistent context
    _hadBomb       = _civ getVariable ["rb_vehicleBombHad", false];
    _bombDefused   = _civ getVariable ["rb_vehicleBombDefused", false];
    _vehContraband = _civ getVariable ["rb_vehicleContraband", []];
    _wasDriver     = _civ getVariable ["rb_vehicleWasDriver", false];
};
if (isNil "_vehContraband") then { _vehContraband = []; };

// Scoring logic
private _reasons     = [];
private _arrestable  = false;
private _scoreDelta  = 0;
private _statusText  = "";

// --- 1: Bomb (arrestable for *any* bomb, even defused)
if (_hadBomb) then {
    _arrestable = true;
    if (!_bombDefused) then {
        _reasons pushBack (["vehicle_bomb"] call _getReasonText);
        _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["vehicle_bomb", 25]);
    } else {
        _reasons pushBack (["vehicle_bomb_defused"] call _getReasonText);
        _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["vehicle_bomb_defused", -10]);
    };
};

// --- 2: Vehicle contraband (driver only)
if (_wasDriver && (_vehContraband isNotEqualTo [])) then {
    _arrestable = true;
    _reasons pushBack (["vehicle_contraband"] call _getReasonText);
    _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["vehicle_contraband", 10]);
};

// --- 3: Personal contraband
private _contraband = _civ getVariable ["rb_contraband", []];
if (_contraband isNotEqualTo []) then {
    _arrestable = true;
    _reasons pushBack (["personal_contraband"] call _getReasonText);
    _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["personal_contraband", 10]);
};

// --- 4: Banned origin
private _identity = _civ getVariable ["civ_identity", ["Unknown", "Unknown", "Unknown", "UNKNOWN"]];
private _origin = _identity param [1, "Unknown"];
private _bannedTowns = missionNamespace getVariable ["RB_BannedTowns", []];
if (_origin in _bannedTowns) then {
    _arrestable = true;
    _reasons pushBack (["banned_origin"] call _getReasonText);
    _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["banned_origin", 8]);
};

// --- 5: Innocent fallback
if (_reasons isEqualTo []) then {
    _scoreDelta = _scoringMap getOrDefault ["arrest_innocent", -5];
    _statusText = "✔️ Innocent Civilian";
    _arrestable = false;
} else {
    _statusText = "❌ Arrested: " + (_reasons joinString ", ");
    _arrestable = true;
};

[_arrestable, _reasons, _scoreDelta, _statusText]
