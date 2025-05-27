// functions\civilian\fn_evaluateDetainedCivilian.sqf
params ["_civ"];

// Skip if already processed
if (_civ getVariable ["rb_processed", false]) exitWith {};

// Mark as processed
_civ setVariable ["rb_processed", true, true];

// Retrieve info
private _contraband   = _civ getVariable ["civ_contraband", []];
private _origin       = (_civ getVariable ["civ_identity", ["", "", "", ""]])#1;
private _bannedTowns  = missionNamespace getVariable ["RB_BannedTowns", []];

private _isIllegal = false;

// Evaluate legality
if (!(_contraband isEqualTo [])) then {
    _isIllegal = true;
};
if (_origin in _bannedTowns) then {
    _isIllegal = true;
};

// Scoring
RB_Score = missionNamespace getVariable ["RB_Score", 0];
if (_isIllegal) then {
    RB_Score = RB_Score + 10;
    hint format ["+10: Correctly detained %1", name _civ];
} else {
    RB_Score = RB_Score - 5;
    hint format ["-5: Wrongful detainment of %1", name _civ];
};
missionNamespace setVariable ["RB_Score", RB_Score, true];

// Despawn
deleteVehicle _civ;
