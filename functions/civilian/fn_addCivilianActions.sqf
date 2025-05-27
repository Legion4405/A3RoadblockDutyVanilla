// functions\civilian\fn_addCivilianActions.sqf
params ["_civ"];

if (!(_civ isKindOf "CAManBase")) exitWith {
    diag_log format ["[RB] ERROR: RB_fnc_addCivilianActions was called on non-unit: %1 (type: %2)", _civ, typeOf _civ];
};

if (_civ getVariable ["rb_hasActions", false]) exitWith {};
_civ setVariable ["rb_hasActions", true];

// === Submenu
private _submenu = [
    "RB_Civ_Interactions",
    "Civilian Interactions",
    "",
    {},  // code on action
    { true }  // condition
] call ace_interact_menu_fnc_createAction;

[_civ, 0, ["ACE_MainActions"], _submenu] call ace_interact_menu_fnc_addActionToObject;

// === Check ID
private _actionCheckID = [
    "RB_Civ_CheckID",
    "Check ID",
    "ui\icons\icon_idcheck.paa",
    {
        params ["_target", "_player"];
        [_target] call RB_fnc_checkCivilianID;
    },
    { alive _target }
] call ace_interact_menu_fnc_createAction;

// === Search Civilian
private _actionSearch = [
    "RB_Civ_Search",
    "Search Civilian",
    "ui\icons\icon_search.paa",
    {
        params ["_target", "_player"];
        [_target] call RB_fnc_searchCivilian;
    },
    {
        alive _target && { isNull objectParent _target }
    }
] call ace_interact_menu_fnc_createAction;

// === Mark as Processed
private _actionRelease = [
    "RB_Civ_Release",
    "Mark as Processed",
    "ui\icons\icon_civprocessed.paa",  // Placeholder icon
    {
        params ["_target", "_player"];
        _target setVariable ["rb_isProcessed", true, true];

        // Allow AI to move again
        unassignVehicle _target;
        [_target] allowGetIn false;
        _target enableAI "MOVE";
        _target stop false;
        doStop _target;

        private _dest = getMarkerPos "RB_ProcessPoint";
        if (_dest isEqualTo [0,0,0]) exitWith {
            diag_log "[RB] ERROR: Marker 'RB_ProcessPoint' does not exist.";
        };

        _target setSpeedMode "LIMITED";
        _target setBehaviour "CARELESS";
        _target doMove _dest;

        systemChat format ["Civilian %1 marked as processed.", name _target];
    },
    {
        alive _target && { isNull objectParent _target }
    }
] call ace_interact_menu_fnc_createAction;

// === Add all to submenu
[_civ, 0, ["ACE_MainActions", "RB_Civ_Interactions"], _actionCheckID] call ace_interact_menu_fnc_addActionToObject;
[_civ, 0, ["ACE_MainActions", "RB_Civ_Interactions"], _actionSearch] call ace_interact_menu_fnc_addActionToObject;
[_civ, 0, ["ACE_MainActions", "RB_Civ_Interactions"], _actionRelease] call ace_interact_menu_fnc_addActionToObject;
