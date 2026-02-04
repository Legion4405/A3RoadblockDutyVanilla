// File: functions\utility\fn_getStarterLoadout.sqf
// Usage: [] call RB_fnc_getStarterLoadout
// Note: RB_RawStarterLoadout is broadcast by the server in fn_initializeFactions.sqf

if (isNil "RB_RawStarterLoadout") then {
    // Wait up to 15 seconds for server to broadcast loadout
    private _timeout = time + 15;
    waitUntil { (!isNil "RB_RawStarterLoadout") || (time > _timeout) };
};

private _loadout = [];

if (isNil "RB_RawStarterLoadout") then {
    diag_log "[RB] ERROR: RB_RawStarterLoadout not received from server. Using fallback.";
    _loadout = [
        ["arifle_MX_F","","","",["30Rnd_65x39_caseless_mag",30],[],""],
        [],
        ["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],
        ["U_B_CombatUniform_mcam",[["FirstAidKit",1],["30Rnd_65x39_caseless_mag",2],["Chemlight_green",1]]],
        ["V_PlateCarrier1_rgr",[["30Rnd_65x39_caseless_mag",6],["16Rnd_9x21_Mag",2],["SmokeShell",1],["HandGrenade",2]]],
        [],
        "H_HelmetB",
        "",
        [],
        ["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]
    ];
} else {
    _loadout = +RB_RawStarterLoadout;
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
        
        if (isNil "_contents") then { _contents = []; };
        
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
    if (!isNil "_uniform" && {_uniform isNotEqualTo []}) then {
        _uniform = [_uniform, _aceMedItems] call _fnc_sanitizeContainer;
        // Add FirstAidKits to Uniform if it exists
        if (_uniform isNotEqualTo []) then {
            (_uniform select 1) pushBack ["FirstAidKit", 3];
        };
        _loadout set [3, _uniform];
    };

    // 2. Vest
    private _vest = _loadout select 4;
    if (!isNil "_vest" && {_vest isNotEqualTo []}) then {
        _vest = [_vest, _aceMedItems] call _fnc_sanitizeContainer;
        _loadout set [4, _vest];
    };

    // 3. Backpack
    private _backpack = _loadout select 5;
    if (!isNil "_backpack" && {_backpack isNotEqualTo []}) then {
        _backpack = [_backpack, _aceMedItems] call _fnc_sanitizeContainer;
        _loadout set [5, _backpack];
    };
};

_loadout