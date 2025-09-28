/*
  Loads persistent state (score, loadouts, logi assets, arsenal unlocks, logistics faction).
  Host-only. Uses per-map keys. If a legacy RB_SaveSlotN exists and the per-map slot is empty,
  it migrates it ONCE into the per-map slot and deletes the legacy key immediately.
*/

if (!isServer) exitWith {};

params ["_slot"];
if (isNil "_slot") exitWith { systemChat "Load failed: No slot specified."; hint "No slot specified."; };

private _slotNum = _slot;
if (_slot isEqualType []) then { if ((count _slot) > 0) then { _slotNum = _slot select 0; }; };

// safe map key (a–z, 0–9, _)
private _arr = toArray (toLower worldName);
private _out = [];
{ private _c = _x; if ((_c>=48 && _c<=57)||(_c>=97 && _c<=122)) then {_out pushBack _c} else {_out pushBack 95}; } forEach _arr;
private _mapKey = toString _out;

// ensure globals exist
if (isNil "RB_ArsenalUnlocks") then { RB_ArsenalUnlocks = []; publicVariable "RB_ArsenalUnlocks"; };

// param fallback
private _paramLogiFaction = ["RB_LogisticsFaction", 0] call BIS_fnc_getParamValue;

// kv helper
private _kvGet = {
  params ["_data","_key","_def"];
  private _m = _data select { _x#0 == _key };
  if (!(_m isEqualTo [])) then { _m#0#1 } else { _def };
};

// keys
private _varNew   = format ["RB_%1_SaveSlot%2", _mapKey, _slotNum];
private _varLegacy= format ["RB_SaveSlot%1", _slotNum];

// try per-map first
private _data = profileNamespace getVariable [_varNew, []];

// migrate once (and delete legacy immediately)
if (_data isEqualTo []) then {
  private _legacy = profileNamespace getVariable [_varLegacy, []];
  if !(_legacy isEqualTo []) then {
    _data = _legacy;
    profileNamespace setVariable [_varNew, _data];
    profileNamespace setVariable [_varLegacy, nil];   // delete legacy NOW
    saveProfileNamespace;
    systemChat format ["[RB] Migrated legacy Slot %1 to per-map key and removed legacy.", _slotNum];
  };
};

// empty after migration? init defaults
if (_data isEqualTo []) exitWith {
  private _score = 0;
  RB_ArsenalUnlocks = []; publicVariable "RB_ArsenalUnlocks";
  RB_LogisticsFaction = _paramLogiFaction; publicVariable "RB_LogisticsFaction";

  private _lines = [
    format ["No save for map '%1' (slot %2). Initialized defaults.", _mapKey, _slotNum],
    format ["• Score: %1", _score],
    "• Loadouts restored: 0",
    "• Vehicles/turrets: 0",
    "• Arsenal unlocks: 0 items",
    format ["• Logistics Faction (from params): %1", RB_LogisticsFaction]
  ];
  hint (_lines joinString "\n");
  private _term = missionNamespace getVariable ["RB_Terminal", objNull];
  if (!isNull _term) then { _term setVariable ["rb_score", _score, true]; publicVariable "RB_Terminal"; };
};

// ---- apply loaded state ----
private _score          = [_data, "score", 0] call _kvGet;
private _loadouts       = [_data, "loadouts", []] call _kvGet;
private _logiData       = [_data, "logiObjects", []] call _kvGet;
private _arsenalUnlocks = [_data, "arsenalUnlocks", []] call _kvGet;
if ((typeName _arsenalUnlocks) != "ARRAY") then { _arsenalUnlocks = []; };

RB_ArsenalUnlocks = _arsenalUnlocks; publicVariable "RB_ArsenalUnlocks";
RB_LogisticsFaction = [_data, "RB_LogisticsFaction", _paramLogiFaction] call _kvGet; publicVariable "RB_LogisticsFaction";

// score holder
private _term = missionNamespace getVariable ["RB_Terminal", objNull];
if (!isNull _term) then { _term setVariable ["rb_score", _score, true]; publicVariable "RB_Terminal"; };

// player loadouts
{
  private _idx = _x#0; private _ld = _x#1;
  if (_idx isEqualType 0 && { _idx < count playableUnits }) then {
    private _u = playableUnits select _idx;
    if (!isNull _u && { alive _u }) then { _u setUnitLoadout _ld; };
  };
} forEach _loadouts;

// wipe previous persistent and respawn saved
private _cleanup = (vehicles + allMissionObjects "StaticWeapon") select { _x getVariable ["rb_isPersistentLogi", false] };
{ deleteVehicle _x } forEach _cleanup;

{
  private _class=_x#0; private _pos=_x#1; private _dir=_x#2;
  if (_class isEqualType []) then { if (count _class>0) then {_class=_class select 0} else {continue}; };
  if !(_class isEqualType "") then { continue };
  _class = toString ((toArray _class) select { _x != 34 });
  if (_class=="" || {!isClass (configFile >> "CfgVehicles" >> _class)}) then { continue };
  private _obj = createVehicle [_class, [0,0,0], [], 0, "NONE"];
  _obj setDir _dir; _obj setPosATL _pos;
  clearWeaponCargoGlobal _obj; clearMagazineCargoGlobal _obj; clearItemCargoGlobal _obj; clearBackpackCargoGlobal _obj;
  _obj setVariable ["rb_isPersistentLogi", true, true];
} forEach _logiData;

// re-apply ACE arsenal
[] spawn {
  waitUntil { !isNull (missionNamespace getVariable ["RB_Arsenal", objNull]) };
  private _box = missionNamespace getVariable ["RB_Arsenal", objNull];
  [_box, RB_ArsenalUnlocks, true] remoteExec ["ace_arsenal_fnc_addVirtualItems", 0, true];
};

// summary
private _lines2 = [
  format ["Loaded (map '%1', slot %2)", _mapKey, _slotNum],
  format ["• Score: %1", _score],
  format ["• Loadouts restored: %1", count _loadouts],
  format ["• Vehicles/turrets: %1", count _logiData],
  format ["• Arsenal unlocks: %1 items", count RB_ArsenalUnlocks],
  format ["• Logistics Faction: %1", RB_LogisticsFaction]
];
hint (_lines2 joinString "\n");
