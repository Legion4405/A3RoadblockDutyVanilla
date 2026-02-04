/*
    File: fn_addPersistenceActions.sqf
    Description: Adds "Persistence" actions with Slot 1–3 structure under Admin Tools.
                 Only Save and Reset are exposed. Loading is handled by mission parameters.
*/

params ["_object"];
if (isNull _object) exitWith {};

// Helper to add ACE actions
private _addAction = {
    params ["_obj", "_path", "_action"];
    [_obj, 0, _path, _action] call ace_interact_menu_fnc_addActionToObject;
};

// Only visible to logged-in admin or Zeus, or in Singleplayer
private _isAdmin = (serverCommandAvailable "#kick") || {!isNull (getAssignedCuratorLogic player)} || (!isMultiplayer);
if (!_isAdmin) exitWith {};

// === “Persistence” Main Menu under Admin Tools ===
private _persistMenu = [
    "RB_Admin_Persistence",
    "Persistence",
    "ui\icons\icon_save.paa",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;

[_object, ["ACE_MainActions", "RB_Terminal_Admin"], _persistMenu] call _addAction;

// === Slot Submenus and Actions (Save + Reset only) ===
for "_i" from 1 to 3 do {
    private _slotID    = format ["RB_Admin_Slot_%1", _i];
    private _slotLabel = format ["Slot %1", _i];

    // Slot submenu
    private _slotMenu = [
        _slotID,
        _slotLabel,
        "",
        {},
        { true }
    ] call ace_interact_menu_fnc_createAction;

    [_object, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Persistence"], _slotMenu] call _addAction;

    // --- Save (server) ---
    private _saveAct = [
        format ["RB_Admin_Save_%1", _i],
        format ["Save Slot %1", _i],
        "ui\icons\icon_save.paa",
        {
            params ["_target", "_player", "_params"];
            private _slot = _params select 0;
            [_slot] remoteExecCall ["RB_fnc_saveProgress", 2]; // server executes save
        },
        { true },
        {},
        [_i]
    ] call ace_interact_menu_fnc_createAction;

    [_object, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Persistence", _slotID], _saveAct] call _addAction;

    // --- Reset submenu ---
    private _resetMenuID = format ["RB_Admin_ResetMenu_%1", _i];
    private _resetMenu = [
        _resetMenuID,
        "Reset",
        "",
        {},
        { true }
    ] call ace_interact_menu_fnc_createAction;

    [_object, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Persistence", _slotID], _resetMenu] call _addAction;

    // --- Confirm Reset (server). Keeps legacy by default but BLOCKS auto-import for this map. ---
    private _resetAction = [
        format ["RB_Admin_Reset_%1", _i],
        "Confirm Reset",
        "",
        {
            params ["_target", "_player", "_params"];
            private _slot = _params select 0;
            // Args: slot, alsoClearLegacy=false, blockFutureAutoImport=true
            [_slot, false, true] remoteExecCall ["RB_fnc_resetSaveSlot", 2];
        },
        { true },
        {},
        [_i]
    ] call ace_interact_menu_fnc_createAction;

    [_object, ["ACE_MainActions", "RB_Terminal_Admin", "RB_Admin_Persistence", _slotID, _resetMenuID], _resetAction] call _addAction;
};
