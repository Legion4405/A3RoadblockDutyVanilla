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

// === Question Subject
private _actionQuestion = [
    "RB_Civ_Question",
    "Question Subject",
    "\A3\ui_f\data\igui\cfg\simpletasks\types\meet_ca.paa",
    {
        params ["_target", "_player"];
        [_target] call RB_fnc_interrogateCivilian;
    },
    { alive _target }
] call ace_interact_menu_fnc_createAction;

// === Check Travel Permit
private _actionCheckPermit = [
    "RB_Civ_CheckPermit",
    "Check Travel Permit",
    "\A3\ui_f\data\igui\cfg\simpletasks\types\documents_ca.paa",
    {
        params ["_target", "_player"];
        private _permit = _target getVariable ["rb_travel_permit", []];
        
        if (_permit isEqualTo []) then {
            ["Subject has no travel permit!", 4] call RB_fnc_showNotification;
        } else {
            _permit params ["_origin", "_dest", "_dateStr"];
            private _msg = format [
                "<t size='1.4' font='PuristaBold' align='center'>Travel Permit</t><br/><br/>" +
                "Authorized Origin: <t color='#00ffff'>%1</t><br/>" +
                "Authorized Dest: <t color='#00ffff'>%2</t><br/><br/>" +
                "Expires: <t color='#ffffff'>%3</t>",
                _origin, _dest, _dateStr
            ];
            [_msg, 6] call ace_common_fnc_displayTextStructured;
        };
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
    "ui\icons\icon_civprocessed.paa",
    {
        params ["_target", "_player"];
        [_target] remoteExec ["RB_fnc_processCivilian", 2];
    },
    {
        alive _target && { isNull objectParent _target }
    }
] call ace_interact_menu_fnc_createAction;


// === Add all to submenu
[_civ, 0, ["ACE_MainActions", "RB_Civ_Interactions"], _actionCheckID] call ace_interact_menu_fnc_addActionToObject;
[_civ, 0, ["ACE_MainActions", "RB_Civ_Interactions"], _actionCheckPermit] call ace_interact_menu_fnc_addActionToObject;
[_civ, 0, ["ACE_MainActions", "RB_Civ_Interactions"], _actionQuestion] call ace_interact_menu_fnc_addActionToObject;
[_civ, 0, ["ACE_MainActions", "RB_Civ_Interactions"], _actionSearch] call ace_interact_menu_fnc_addActionToObject;
[_civ, 0, ["ACE_MainActions", "RB_Civ_Interactions"], _actionRelease] call ace_interact_menu_fnc_addActionToObject;
