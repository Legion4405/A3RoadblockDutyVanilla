/*
    File: fn_isCivilianIllegal.sqf
    Description: Backward-compatible wrapper for RB_fnc_validateCivilian.
    Returns: [bool, reason string, isLegitArrest]
*/

params ["_civ"];

private _validation = [_civ] call RB_fnc_validateCivilian;
private _isIllegal = _validation get "isIllegal";
private _reasons = _validation get "reasons";

if (_isIllegal) then {
    // Return first reason found
    private _firstReason = if (count _reasons > 0) then { _reasons select 0 } else { "Unknown Violation" };
    [true, _firstReason, true]
} else {
    [false, "", false]
};