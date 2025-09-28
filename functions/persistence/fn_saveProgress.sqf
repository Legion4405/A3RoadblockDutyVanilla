/*
  Saves mission state to profileNamespace under a per-map key.
  Host-only. No legacy tags stored in the payload.
*/

if (!isServer) exitWith {};

params ["_slot"];
if (isNil "_slot") exitWith { systemChat "Save failed: No slot specified."; };

private _slotNum = _slot;
if (_slot isEqualType []) then { if ((count _slot) > 0) then { _slotNum = _slot select 0; }; };

// map key
private _arr = toArray (toLower worldName);
private _out = [];
{ private _c=_x; if ((_c>=48&&_c<=57)||(_c>=97&&_c<=122)) then {_out pushBack _c} else {_out pushBack 95}; } forEach _arr;
private _mapKey     = toString _out;
private _varNameNew = format ["RB_%1_SaveSlot%2", _mapKey, _slotNum];

// score
private _score = 0;
private _term = missionNamespace getVariable ["RB_Terminal", objNull];
if (!isNull _term) then { _score = _term getVariable ["rb_score", 0]; };

// loadouts
private _loadouts = [];
{ if (alive _x && isPlayer _x) then { _loadouts pushBack [_forEachIndex, getUnitLoadout _x]; }; } forEach playableUnits;

// persistent vehicles/turrets
private _seen = [];
private _logiObjects = (vehicles + allMissionObjects "StaticWeapon") select {
  private _id = str _x;
  (!(_id in _seen)) && { _seen pushBack _id; _x getVariable ["rb_isPersistentLogi", false] }
};
private _logiData = [];
private _objectSummaries = [];
{
  private _obj=_x; private _class=typeOf _obj; private _pos=getPosATL _obj; private _dir=getDir _obj;
  private _kind = if (_obj isKindOf "StaticWeapon") then {"turret"} else {"vehicle"};
  _logiData pushBack [_class, _pos, _dir, _kind];
  _objectSummaries pushBack format ["%1 at %2 (%3)", _class, str _pos, _kind];
} forEach _logiObjects;

// unlocks + faction
if (isNil "RB_ArsenalUnlocks") then { RB_ArsenalUnlocks = []; };
private _logiFaction = if (isNil "RB_LogisticsFaction") then { "" } else { RB_LogisticsFaction };

// payload (no legacy tags stored)
private _saveData = [
  ["score",               _score],
  ["loadouts",            _loadouts],
  ["logiObjects",         _logiData],
  ["arsenalUnlocks",      RB_ArsenalUnlocks],
  ["RB_LogisticsFaction", _logiFaction]
];

profileNamespace setVariable [_varNameNew, _saveData];
saveProfileNamespace;

// summary
private _lines = [
  format ["Saved (map '%1', slot %2)", _mapKey, _slotNum],
  format ["• Score: %1", _score],
  format ["• Loadouts: %1", count _loadouts],
  format ["• Vehicles/turrets: %1 objects", count _logiData],
  format ["• Arsenal unlocks: %1 items", count RB_ArsenalUnlocks],
  format ["• Logistics Faction: %1", _logiFaction]
];
_lines append _objectSummaries;
hint (_lines joinString "\n");
