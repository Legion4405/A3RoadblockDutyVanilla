/*
  File: fn_resetSaveSlot.sqf
  Desc: Clears the per-map save slot; optionally clears legacy too.
  Params:
    0: NUMBER slot
    1: BOOL   also clear legacy key (default false)
*/

if (!isServer) exitWith {};

params ["_slot", ["_alsoLegacy", false]];

// Robust slot number
private _slotNum = _slot;
if (_slot isEqualType [] && {count _slot > 0}) then { _slotNum = _slot select 0; };

// Build safe per-map key (a–z, 0–9, '_')
private _arr = toArray (toLower worldName);
private _out = [];
{
    private _c = _x;
    if ( (_c >= 48 && _c <= 57) || (_c >= 97 && _c <= 122) ) then { _out pushBack _c } else { _out pushBack 95 };
} forEach _arr;
private _mapKey = toString _out;

// Keys
private _varNew = format ["RB_%1_SaveSlot%2", _mapKey, _slotNum];
private _varOld = format ["RB_SaveSlot%1", _slotNum];

// Clear
profileNamespace setVariable [_varNew, nil];
if (_alsoLegacy) then { profileNamespace setVariable [_varOld, nil]; };
saveProfileNamespace;

// Message
private _scopeTxt = if (_alsoLegacy) then {"per-map + legacy"} else {"per-map only"};
systemChat format ["[RB] Reset %1 for map '%2' (slot %3).", _scopeTxt, _mapKey, _slotNum];
