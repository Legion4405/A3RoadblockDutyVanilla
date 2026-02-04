/*
    File: fn_judgeVehicle.sqf
    Params: [_vehicle, _isImpound (bool)]
    Returns: [illegal(bool), [reasons (display)], scoreDelta, statusText]
*/
params ["_vehicle", ["_isImpound", false]];
private _scoringMap = missionNamespace getVariable ["RB_ScoringTableMap", createHashMap];

private _reasons    = [];
private _illegal    = false;
private _scoreDelta = 0;
private _statusText = "";

// Bomb logic: active or defused
private _hadBomb      = _vehicle getVariable ["rb_hadBomb", false];
private _hasBomb      = _vehicle getVariable ["rb_hasBomb", false];
private _bombDefused  = _vehicle getVariable ["rb_bombDefused", false];

// --- 1. Active bomb
if (_hasBomb) then {
    _illegal = true;
    // Penalty is same for Release (Wrongful Release) or Impound (Correct Impound), logic below handles sign
    _reasons pushBack "Vehicle Bomb";
};

// --- 2. Defused bomb
if (_hadBomb && _bombDefused) then {
    _illegal = true;
    _reasons pushBack "Vehicle Bomb (Defused)";
};

// --- 3. Contraband
private _contraband = _vehicle getVariable ["veh_contraband", []];
if (_contraband isNotEqualTo []) then {
    _illegal = true;
    _reasons pushBack "Vehicle Contraband";
};

// --- 4. Registration mismatches
private _plateMismatch = _vehicle getVariable ["cached_veh_plateMismatch", false];
private _nameMismatch  = _vehicle getVariable ["cached_veh_regNameMismatch", false];
private _idMismatch    = _vehicle getVariable ["cached_veh_regIDMismatch", false];
private _noOwner       = (_vehicle getVariable ["cached_veh_regOwner", ""] == "Unknown");

if (_plateMismatch) then {
    _illegal = true;
    _reasons pushBack "License Plate Mismatch";
};
if (_nameMismatch) then {
    _illegal = true;
    _reasons pushBack "Registration Name Mismatch";
};
if (_idMismatch) then {
    _illegal = true;
    _reasons pushBack "Registration ID Mismatch";
};
if (_noOwner) then {
    _illegal = true;
    _reasons pushBack "No Registered Owner";
};

// ==========================================
// SCORING LOGIC (Impound vs Release)
// ==========================================

if (_isImpound) then {
    // === IMPOUND EVENT ===
    if (_illegal) then {
        // Correct Impound
        // Special case: Active Bomb not defused
        if (_hasBomb && !_bombDefused) then {
             _scoreDelta = _scoringMap getOrDefault ["impound_bomb_notdefused", -15];
             _reasons pushBack "Bomb NOT defused";
        } else {
             // Sum up standard penalties as rewards
             // If multiple reasons, we just give a flat "Correct Impound" score or sum them?
             // config.sqf has specific scores.
             
             // Bomb Defused Reward
             if (_hadBomb && _bombDefused) then {
                 _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["vehicle_bomb_defused", 5]);
             };
             
             // Contraband Reward
             if (_contraband isNotEqualTo []) then {
                 _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["vehicle_contraband", 10]);
             };
             
             // Mismatch Reward
             if (_plateMismatch) then { _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["plate_mismatch", 5]); };
             if (_nameMismatch) then { _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["registration_mismatch", 5]); };
             if (_idMismatch) then { _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["registration_mismatch", 5]); };
             if (_noOwner) then { _scoreDelta = _scoreDelta + (_scoringMap getOrDefault ["registration_mismatch", 5]); };
        };
        
        _statusText = format ["Impounded: %1", _reasons joinString ", "];
    } else {
        // Wrongful Impound (Clean Vehicle)
        _scoreDelta = _scoringMap getOrDefault ["wrong_impound", -15];
        _statusText = "Wrongful Impound (Clean Vehicle)";
    };

} else {
    // === RELEASE EVENT (Check for missed violations) ===
    if (_illegal) then {
        // Wrongful Release (Missed violations)
        _scoreDelta = _scoringMap getOrDefault ["wrong_vehicle_release", -10];
        _statusText = format ["Wrongful Release: %1", _reasons joinString ", "];
    } else {
        // Correct Release (Clean Vehicle)
        _scoreDelta = _scoringMap getOrDefault ["correct_vehicle_release", 5];
        _statusText = "Vehicle Released (Clean)";
    };
};

[_illegal, _reasons, _scoreDelta, _statusText]
