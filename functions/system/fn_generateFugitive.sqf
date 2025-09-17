/*
    File: fn_generateFugitive.sqf
    Description: Picks a new fugitive name from RB_FakeNames and updates diary for all players.
*/

private _allNames = missionNamespace getVariable ["RB_FakeNames", []];
private _usedNames = missionNamespace getVariable ["RB_UsedFugitiveNames", []];

// Only pick from names not yet used this session
private _availableNames = _allNames - _usedNames;

// Fallback: if all names used, reset and allow repeats
if (_availableNames isEqualTo []) then {
    _availableNames = _allNames;
    _usedNames = [];
};

private _fugitiveName = if (_availableNames isEqualTo []) then { "UNKNOWN" } else { selectRandom _availableNames };

// Persist for JIP and for tracking
missionNamespace setVariable ["RB_CurrentFugitive", _fugitiveName, true];
missionNamespace setVariable ["RB_FugitiveActive", false, true];

// Track used names
_usedNames pushBackUnique _fugitiveName;
missionNamespace setVariable ["RB_UsedFugitiveNames", _usedNames, true];

// Update diary entry for all clients (MP/JIP safe)
[_fugitiveName] remoteExec ["RB_fnc_updateFugitiveDiary", 0, true];

// Optional debug log
diag_log format ["[RB] New fugitive generated: %1", _fugitiveName];

true // Script success
