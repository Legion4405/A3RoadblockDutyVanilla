/*
    File: fn_loadProgress.sqf
    Description: Loads mission state (score, loadouts, logistics assets, arsenal unlocks, logistics faction) from profileNamespace.
*/

if (!isServer) exitWith {};

// Ensure RB_ArsenalUnlocks always exists
if (isNil "RB_ArsenalUnlocks") then {
    RB_ArsenalUnlocks = [];
    publicVariable "RB_ArsenalUnlocks";
};

params ["_slot"];
if (isNil "_slot") exitWith {
    systemChat "Load failed: No slot specified.";
    hint "No slot specified.";
};

private _slotNum = if (_slot isEqualType []) then { _slot select 0 } else { _slot };

// --- Helper: mission param fallback for logistics faction.
// Change the param name here if your param key differs.
private _paramLogiFaction = ["RB_LogisticsFaction", 0] call BIS_fnc_getParamValue;

// --- Helper: safe getter from ["key", value] array
private _kvGet = {
    params ["_data", "_key", "_default"];
    private _m = _data select { _x#0 == _key };
    if ((count _m) > 0) then { _m#0#1 } else { _default };
};

private _varName = format ["RB_SaveSlot%1", _slotNum];
private _data    = profileNamespace getVariable [_varName, []];

// ===== EMPTY SLOT → initialize from params & defaults =====
if (_data isEqualTo []) exitWith {
    // Fresh state
    private _score = 0;
    RB_ArsenalUnlocks = [];
    publicVariable "RB_ArsenalUnlocks";

    // Faction from mission parameter
    RB_LogisticsFaction = _paramLogiFaction;
    publicVariable "RB_LogisticsFaction";

    // No persistent assets to restore
    private _lines = [
        format ["Initialized fresh state (slot %1 was empty)", _slotNum],
        format ["• Score: %1", _score],
        "• Loadouts restored: 0",
        "• Vehicles/turrets: 0",
        "• Arsenal unlocks: 0 items",
        format ["• Logistics Faction (from params): %1", RB_LogisticsFaction]
    ];
    hint (_lines joinString "\n");
    systemChat format ["No save found in slot %1. Initialized from mission parameters.", _slotNum];

    // (Optional) also broadcast score holder object if you rely on it elsewhere
    if (!isNull (missionNamespace getVariable ["RB_Terminal", objNull])) then {
        RB_Terminal setVariable ["rb_score", _score, true];
        publicVariable "RB_Terminal";
    };
};

// ===== NON-EMPTY SLOT → load pieces safely =====
private _score          = [_data, "score", 0] call _kvGet;
private _loadouts       = [_data, "loadouts", []] call _kvGet;
private _logiData       = [_data, "logiObjects", []] call _kvGet;
private _arsenalUnlocks = [_data, "arsenalUnlocks", []] call _kvGet;
if ((typeName _arsenalUnlocks) != "ARRAY") then { _arsenalUnlocks = []; };

// Now assign & broadcast
RB_ArsenalUnlocks = _arsenalUnlocks;
publicVariable "RB_ArsenalUnlocks";

// Logistics Faction (fallback to param if absent in save)
private _logiFaction = [_data, "RB_LogisticsFaction", _paramLogiFaction] call _kvGet;
RB_LogisticsFaction = _logiFaction;
publicVariable "RB_LogisticsFaction";

// Restore score holder
if (!isNull (missionNamespace getVariable ["RB_Terminal", objNull])) then {
    RB_Terminal setVariable ["rb_score", _score, true];
    publicVariable "RB_Terminal";
};

// Restore loadouts by slot index (JIP-safe enough for saved units)
{
    private _index   = _x#0;
    private _loadout = _x#1;
    if (_index isEqualType 0 && { _index < count playableUnits }) then {
        private _unit = playableUnits select _index;
        if (!isNull _unit && { alive _unit }) then {
            _unit setUnitLoadout _loadout;
        };
    };
} forEach _loadouts;

// Clean previous persistent objects
private _cleanup = (vehicles + allMissionObjects "StaticWeapon") select {
    _x getVariable ["rb_isPersistentLogi", false]
};
{ deleteVehicle _x } forEach _cleanup;

// Respawn persistent vehicles/turrets
{
    private _class = _x#0;
    private _pos   = _x#1;
    private _dir   = _x#2;
    private _kind  = _x#3;

    // Cope with accidental array/quoted class names
    if (_class isEqualType []) then {
        if (count _class > 0) then { _class = _class select 0; } else { continue; };
    };
    if !(_class isEqualType "") then { continue; };

    // Strip stray double quotes if present
    _class = toArray _class select { _x != 34 };
    _class = toString _class;

    if (_class == "" || {!isClass (configFile >> "CfgVehicles" >> _class)}) then { continue; };

    private _obj = createVehicle [_class, [0,0,0], [], 0, "NONE"];
    _obj setDir _dir;
    _obj setPosATL _pos;

    clearWeaponCargoGlobal   _obj;
    clearMagazineCargoGlobal _obj;
    clearItemCargoGlobal     _obj;
    clearBackpackCargoGlobal _obj;

    _obj setVariable ["rb_isPersistentLogi", true, true];
} forEach _logiData;

// Restore ACE Arsenal unlocks (JIP-safe)
[] spawn {
    waitUntil { !isNull (missionNamespace getVariable ["RB_Arsenal", objNull]) };
    private _box = missionNamespace getVariable ["RB_Arsenal", objNull];
    [_box, RB_ArsenalUnlocks, true] remoteExec ["ace_arsenal_fnc_addVirtualItems", 0, true];
};

// Summary
private _lines = [
    format ["Loaded from slot %1", _slotNum],
    format ["• Score: %1", _score],
    format ["• Loadouts restored: %1", count _loadouts],
    format ["• Vehicles/turrets: %1", count _logiData],
    format ["• Arsenal unlocks: %1 items", count RB_ArsenalUnlocks],
    format ["• Logistics Faction: %1", RB_LogisticsFaction]
];
hint (_lines joinString "\n");
systemChat format ["Progress loaded from slot %1.", _slotNum];
