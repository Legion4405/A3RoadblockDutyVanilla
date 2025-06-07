/*
    File: fn_saveProgress.sqf
    Description: Saves mission state (score, loadouts, logistics assets, arsenal unlocks, logistics faction) to profileNamespace.
*/

params ["_slot"];
if (isNil "_slot") exitWith {
    systemChat "❌ Save failed: No slot specified.";
};

private _slotNum = if (_slot isEqualType []) then { _slot select 0 } else { _slot };
private _varName = format ["RB_SaveSlot%1", _slotNum];

// === Gather score
private _score = RB_Terminal getVariable ["rb_score", 0];

// === Save loadouts
private _loadouts = [];
{
    private _index = _forEachIndex;
    if (alive _x && isPlayer _x) then {
        _loadouts pushBack [_index, getUnitLoadout _x];
    };
} forEach playableUnits;

// === Save persistent vehicles and turrets
private _seen = [];
private _logiObjects = (vehicles + allMissionObjects "StaticWeapon") select {
    private _id = str _x;
    (!(_id in _seen)) && {
        _seen pushBack _id;
        _x getVariable ["rb_isPersistentLogi", false]
    }
};

private _logiData = [];
private _objectSummaries = [];

{
    private _obj   = _x;
    private _class = typeOf _obj;
    private _pos   = getPosATL _obj;
    private _dir   = getDir _obj;
    private _kind  = if (_obj isKindOf "StaticWeapon") then {"turret"} else {"vehicle"};

    _logiData pushBack [_class, _pos, _dir, _kind];
    _objectSummaries pushBack format ["%1 at %2 (%3)", _class, str(_pos), _kind];
} forEach _logiObjects;

// === Arsenal unlocks (from global array, always array of strings)
if (isNil "RB_ArsenalUnlocks") then { RB_ArsenalUnlocks = []; };

// === Save the logistics faction
// If the global RB_LogisticsFaction is nil, you may want a default (e.g. "")
private _logiFaction = if (isNil "RB_LogisticsFaction") then { "" } else { RB_LogisticsFaction };

// === Build the save array
private _saveData = [
    ["score",           _score],
    ["loadouts",        _loadouts],
    ["logiObjects",     _logiData],
    ["arsenalUnlocks",  RB_ArsenalUnlocks],
    ["RB_LogisticsFaction", _logiFaction]
];

// === Write into profileNamespace and persist to disk
profileNamespace setVariable [_varName, _saveData];
saveProfileNamespace;

// === Display summary
private _lines = [
    format ["💾 Saved to slot %1", _slotNum],
    format ["• Score: %1", _score],
    format ["• Loadouts: %1", count _loadouts],
    format ["• Vehicles/turrets: %1 objects", count _logiData],
    format ["• Arsenal unlocks: %1 items", count RB_ArsenalUnlocks],
    format ["• Logistics Faction: %1", _logiFaction]
];

_lines append _objectSummaries;
hint (_lines joinString "\n");
