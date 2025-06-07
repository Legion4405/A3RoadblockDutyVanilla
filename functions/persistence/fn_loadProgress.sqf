/*
    File: fn_loadProgress.sqf
    Description: Loads mission state (score, loadouts, logistics assets, arsenal unlocks, logistics faction) from profileNamespace.
*/

// ── ENSURE: Only the server runs this function ──
if (!isServer) exitWith {};

// ── ENSURE: RB_ArsenalUnlocks always exists (so "count" won't error) ──
if (isNil "RB_ArsenalUnlocks") then {
    RB_ArsenalUnlocks = [];
    publicVariable "RB_ArsenalUnlocks";
};

params ["_slot"];
if (isNil "_slot") exitWith {
    systemChat "❌ Load failed: No slot specified.";
    hint "❌ No slot specified.";
};

private _slotNum = if (_slot isEqualType []) then { _slot select 0 } else { _slot };
private _varName = format ["RB_SaveSlot%1", _slotNum];
private _data    = profileNamespace getVariable [_varName, []];

if (_data isEqualTo []) exitWith {
    systemChat format ["❌ No save data found in slot %1.", _slotNum];
    hint format ["❌ No save data found in slot %1.", _slotNum];
};

// === Extract data from the array of ["key", value] pairs
private _score          = (_data select { _x#0 == "score" })#0#1;
private _loadouts       = (_data select { _x#0 == "loadouts" })#0#1;
private _logiData       = (_data select { _x#0 == "logiObjects" })#0#1;
private _arsenalUnlocks = (_data select { _x#0 == "arsenalUnlocks" })#0#1;
if ((typeName _arsenalUnlocks) != "ARRAY") then { _arsenalUnlocks = []; };

// ── NOW assign to the global, overriding the default or previous value ──
RB_ArsenalUnlocks = _arsenalUnlocks;
publicVariable "RB_ArsenalUnlocks";  // broadcast the newly loaded arsenal list

// === Extract & broadcast RB_LogisticsFaction
private _savedFactionEntry = _data select { _x#0 == "RB_LogisticsFaction" };
private _logiFaction = if (count _savedFactionEntry > 0) then { _savedFactionEntry#0#1 } else { 0 };
RB_LogisticsFaction = _logiFaction;
publicVariable "RB_LogisticsFaction";

// === Restore score
RB_Terminal setVariable ["rb_score", _score, true];
publicVariable "RB_Terminal";

// === Restore loadouts for each playable unit
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

// === Delete old persistent vehicles/turrets
private _cleanup = (vehicles + allMissionObjects "StaticWeapon") select {
    _x getVariable ["rb_isPersistentLogi", false]
};
{ deleteVehicle _x } forEach _cleanup;

// === Respawn vehicles/turrets
{
    private _class = _x#0;
    private _pos   = _x#1;
    private _dir   = _x#2;
    private _kind  = _x#3;

    if (_class isEqualType []) then {
        if (count _class > 0) then { _class = _class select 0; } else { continue; };
    };
    if !(_class isEqualType "") then { continue; };
    _class = toArray _class select { _x != 34 }; 
    _class = toString _class;
    if (_class == "" || {!isClass (configFile >> "CfgVehicles" >> _class)}) then { continue; };

    private _obj = createVehicle [_class, [0, 0, 0], [], 0, "NONE"];
    _obj setDir _dir;
    _obj setPosATL _pos;
    clearWeaponCargoGlobal _obj;
    clearMagazineCargoGlobal _obj;
    clearItemCargoGlobal _obj;
    clearBackpackCargoGlobal _obj;
    _obj setVariable ["rb_isPersistentLogi", true, true];
} forEach _logiData;

// === Restore ACE Arsenal unlocks (JIP‐safe)
[] spawn {
    waitUntil { !isNull (missionNamespace getVariable ["RB_Arsenal", objNull]) };
    private _box = missionNamespace getVariable ["RB_Arsenal", objNull];
    [_box, RB_ArsenalUnlocks, true] remoteExec ["ace_arsenal_fnc_addVirtualItems", 0, true];
};

// === Summary hint (safe now that RB_ArsenalUnlocks is defined)
private _lines = [
    format ["📥 Loaded from slot %1", _slotNum],
    format ["• Score: %1", _score],
    format ["• Loadouts restored: %1", count _loadouts],
    format ["• Vehicles/turrets: %1", count _logiData],
    format ["• Arsenal unlocks: %1 items", count RB_ArsenalUnlocks],
    format ["• Logistics Faction: %1", _logiFaction]
];
hint (_lines joinString "\n");
systemChat format ["✅ Progress loaded from slot %1.", _slotNum];
