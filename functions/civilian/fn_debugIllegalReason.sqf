// functions\civilian\fn_debugIllegalReason.sqf
params ["_civ"];

if (isNull _civ || {!alive _civ}) exitWith {
    hint "Civilian is null or dead.";
};

// Use the central validation logic
private _validation = [_civ] call RB_fnc_validateCivilian;
private _isIllegal = _validation get "isIllegal";
private _reasons   = _validation get "reasons";

if (_isIllegal) then {
    hint format ["Illegal Reason(s):\n%1", _reasons joinString "\n"];
} else {
    hint "Civilian is clean.";
};