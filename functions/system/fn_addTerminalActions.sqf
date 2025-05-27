/*
    File: fn_addTerminalActions.sqf
    Description: Adds ACE interaction options to the terminal. MP + JIP Safe Version
*/

params ["_object"];
if (isNull _object) exitWith {};

// Only run once per client
if (_object getVariable ["rb_hasActions", false]) exitWith {};
_object setVariable ["rb_hasActions", true, true]; // sync across clients

// Wait until client has interface (JIP safety)
if (!hasInterface) exitWith {};

// === Central function to safely register an action
private _addAction = {
    params ["_obj", "_path", "_action"];
    [_obj, 0, _path, _action] call ace_interact_menu_fnc_addActionToObject;
};

// === Show Score
private _scoreAction = [
    "RB_Terminal_ShowScore", "Check Score", "ui\icons\icon_score.paa",
    {
        params ["_target", "_player"];
        private _score = RB_Terminal getVariable ["rb_score", 0];
        private _color = if (_score > 0) then {"#00ff00"} else { if (_score < 0) then {"#ff0000"} else {"#ffffff"} };
        private _text = format [
            "<t size='1.5' font='PuristaBold' align='center' color='#ffffff'>Checkpoint Interface</t><br/><br/>" +
            "<t size='1.15' font='PuristaBold' color='#ffffff'>📊 Current Score:</t> " +
            "<t size='1.4' font='PuristaBold' color='%1'>%2</t><br/><br/>" +
            "<t size='1.1' font='PuristaMedium' color='#ffffff'>Scoring Rules:</t><br/>" +
            "<t size='1.05' font='PuristaLight' color='#dddddd'>" +
            "• +5  — Valid arrest<br/>" +
            "• +5  — Valid impound<br/>" +
            "• -5  — Wrongful arrest<br/>" +
            "• -5  — Invalid impound<br/><br/>" +
            "Ensure identities, contraband, registration, and plate data match up. Every mistake impacts your team's standing.</t>",
            _color, _score
        ];
        [_text, 9] call ace_common_fnc_displayTextStructured;
    },
    { true }
] call ace_interact_menu_fnc_createAction;
[_object, ["ACE_MainActions"], _scoreAction] call _addAction;

// === Menu Definitions
private _menus = [
    ["RB_Terminal_Management", "Roadblock Management"],
    ["RB_Terminal_Logistics", "Logistics"],
    ["RB_Terminal_Admin", "Admin Tools"],
    ["RB_Terminal_SaveCategory", "Save System"]
];

{
    private _menuID = _x select 0;
    private _menuLabel = _x select 1;
    private _menu = [
        _menuID,
        _menuLabel,
        "",
        {},
        { true }
    ] call ace_interact_menu_fnc_createAction;

    [_object, ["ACE_MainActions"], _menu] call _addAction;
} forEach _menus;

// === Save Progress Placeholder
private _actionSaveProgress = [
    "RB_Terminal_SaveProgress",
    "Save Progress",
    "ui\icons\icon_save.paa",
    { hint "💾 Save feature coming soon!"; },
    { true }
] call ace_interact_menu_fnc_createAction;
[_object, ["ACE_MainActions", "RB_Terminal_SaveCategory"], _actionSaveProgress] call _addAction;

// === Logistics Menu (Dynamic)
{
    private _category     = _x select 0;
    private _optionsArray = _x select 1;

    private _categoryID = format ["RB_Logistics_%1", _category];
    private _categoryMenu = [
        _categoryID,
        _category,
        "",
        {},
        { true }
    ] call ace_interact_menu_fnc_createAction;

    [_object, ["ACE_MainActions", "RB_Terminal_Logistics"], _categoryMenu] call _addAction;

    {
        private _index = _forEachIndex;
        private _label     = _x select 0;
        private _cost      = _x select 3;

        private _action = [
            format ["RB_Log_Request_%1_%2", _category, _index],
            format ["Request: %1 (%2 pts)", _label, _cost],
            "ui\icons\icon_logi.paa",
            {
                params ["_target", "_player"];
                [_player, _this select 2] spawn RB_fnc_handleLogisticsRequest;
            },
            { true },
            {},
            [_forEachIndex, _category]
        ] call ace_interact_menu_fnc_createAction;

        [_object, ["ACE_MainActions", "RB_Terminal_Logistics", _categoryID], _action] call _addAction;

    } forEach _optionsArray;
} forEach (missionNamespace getVariable ["RB_LogisticsOptions", []]);

[_object] call RB_fnc_addAdminActions;
[_object] call RB_fnc_addManagementActions;


// ✅ Make sure you remoteExec this function in init.sqf like so:
// [_terminal] remoteExec ["RB_fnc_addTerminalActions", 0, true];
