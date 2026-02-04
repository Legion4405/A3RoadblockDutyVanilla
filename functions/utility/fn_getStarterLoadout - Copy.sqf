// File: functions\utility\fn_getStarterLoadout.sqf
// Usage: [optionalFactionIndex] call RB_fnc_getStarterLoadout
params [["_faction", ["RB_LogisticsFaction", 0] call BIS_fnc_getParamValue]];
waitUntil { !isNil "paramsArray" };

private _loadout = switch (_faction) do {
    case 0: { RB_StarterLoadout_Custom };
    case 1: { RB_StarterLoadout_NATO };
    case 2: { RB_StarterLoadout_APEX_NATO };
    case 3: { RB_StarterLoadout_Contact_NATO };
    case 4: { RB_StarterLoadout_Contact_LDF };
    case 5: { RB_StarterLoadout_APEX_Gendarmerie };
    case 6: { RB_StarterLoadout_CDLC_UNA };
    case 7: { RB_StarterLoadout_RHS_USA };
    case 8: { RB_StarterLoadout_3CB_BAF };
    case 9: { RB_StarterLoadout_SOGPF_US };
    case 10: { RB_StarterLoadout_MJTF };
    default { RB_StarterLoadout_NATO };
};

// === ACE Medical Check ===
// If ACE Medical is NOT loaded, we strip ACE medical items and add standard FirstAidKits.
if (!isClass (configFile >> "CfgPatches" >> "ace_medical")) then {
    
    // List of items to remove (Global defined in config.sqf)
    private _aceMedItems = missionNamespace getVariable ["RB_AceMedicalItems", []];

    // Helper to sanitize a container array: ["Class", [[Item, Count], ...]]
    private _fnc_sanitizeContainer = {
        params ["_containerData", "_blacklist"];
        if (_containerData isEqualTo []) exitWith { [] };
        
        private _className = _containerData select 0;
        private _contents  = _containerData select 1;
        private _newContents = [];
        
        {
            _x params ["_item", "_count"];
            if !(_item in _blacklist) then {
                _newContents pushBack _x;
            };
        } forEach _contents;
        
        [_className, _newContents]
    };

    // 1. Uniform
    private _uniform = _loadout select 3;
    _uniform = [_uniform, _aceMedItems] call _fnc_sanitizeContainer;
    // Add FirstAidKits to Uniform if it exists
    if (_uniform isNotEqualTo []) then {
        (_uniform select 1) pushBack ["FirstAidKit", 3];
    };
    _loadout set [3, _uniform];

    // 2. Vest
    private _vest = _loadout select 4;
    _vest = [_vest, _aceMedItems] call _fnc_sanitizeContainer;
    _loadout set [4, _vest];

    // 3. Backpack
    private _backpack = _loadout select 5;
    _backpack = [_backpack, _aceMedItems] call _fnc_sanitizeContainer;
    _loadout set [5, _backpack];
};

_loadout