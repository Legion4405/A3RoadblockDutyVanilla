/*
    File: fn_addPersistenceActions.sqf
    Description: Adds "Persistence" actions with Slot 1–3 structure including Save, Load, and Reset under Admin Tools.
*/

params ["_object"];
if (isNull _object) exitWith {};

// Helper to add ACE actions
private _addAction = {
    params ["_obj", "_path", "_action"];
    [_obj, 0, _path, _action] call ace_interact_menu_fnc_addActionToObject;
};

// Only visible to logged-in admin or Zeus
private _isAdmin = (serverCommandAvailable "#kick") || {!isNull (getAssignedCuratorLogic player)};
if (!_isAdmin) exitWith {};

// === Add “Persistence” Main Menu under Admin Tools ===
private _persistMenu = [
    "RB_Admin_Persistence",
    "Persistence",
    "ui\icons\icon_save.paa",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;

[_object, ["ACE_MainActions", "RB_Terminal_Admin"], _persistMenu] call _addAction;

// === Slot Submenus and Actions ===
for "_i" from 1 to 3 do {
    private _slotID   = format ["RB_Admin_Slot_%1", _i];
    private _slotLabel = format ["Slot %1", _i];

    // Add submenu for Slot
    private _slotMenu = [
        _slotID,
        _slotLabel,
        "",
        {},
        { true }
    ] call ace_interact_menu_fnc_createAction;

    [_object, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Persistence"], _slotMenu] call _addAction;

    // === Save Action ===
    private _saveAct = [
        format ["RB_Admin_Save_%1", _i],
        format ["Save Slot %1", _i],
        "ui\icons\icon_save.paa",
        {
            params ["_target", "_player", "_params"];
            private _slot = _params select 0;
            [_slot] remoteExecCall ["RB_fnc_saveProgress", 0, false];
        },
        { true },
        {},
        [_i]
    ] call ace_interact_menu_fnc_createAction;

    [_object, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Persistence", _slotID], _saveAct] call _addAction;

    // === Load Action (only if data exists) ===
    private _loadAct = [
        format ["RB_Admin_Load_%1", _i],
        format ["Load Slot %1", _i],
        "",
        {
            params ["_target", "_player", "_params"];
            private _slot = _params select 0;
            [_slot] remoteExecCall ["RB_fnc_loadProgress", 0, false];
        },
        {
            // Enable only when slot has something saved
            params ["_target", "_player", "_params"];
            private _slot = _params select 0;
            private _varName = format ["RB_SaveSlot%1", _slot];
            !isNil { profileNamespace getVariable _varName } &&
            { count (profileNamespace getVariable [_varName, []]) > 0 }
        },
        {},
        [_i]
    ] call ace_interact_menu_fnc_createAction;

    [_object, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Persistence", _slotID], _loadAct] call _addAction;

    // === Reset Submenu under Slot ===
    private _resetMenuID = format ["RB_Admin_ResetMenu_%1", _i];
    private _resetMenu = [
        _resetMenuID,
        "Reset",
        "",
        {},
        { true }
    ] call ace_interact_menu_fnc_createAction;

    [_object, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Persistence", _slotID], _resetMenu] call _addAction;

    // === Confirm Reset Action ===
    private _resetAction = [
        format ["RB_Admin_Reset_%1", _i],
        "Confirm Reset",
        "",
        {
            params ["_target", "_player", "_params"];
            private _slot = _params select 0;
            private _varName = format ["RB_SaveSlot%1", _slot];

            // For namespaces, setVariable uses 2 args. Remove the slot (nil) or clear to [].
            // Using nil removes it so the Load button will disable via the condition above.
            profileNamespace setVariable [_varName, nil];
            saveProfileNamespace;

            // Optional feedback:
            // systemChat format ["RB: Cleared persistence Slot %1.", _slot];
        },
        { true },
        {},
        [_i]
    ] call ace_interact_menu_fnc_createAction;

    [_object, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Persistence", _slotID, _resetMenuID], _resetAction] call _addAction;
};
