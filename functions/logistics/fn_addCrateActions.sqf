/*
    File: fn_addCrateActions.sqf
    Description: Adds ACE interaction to destroy logistics crate.
*/

params ["_crate"];

if (isNull _crate) exitWith {};
if (_crate getVariable ["rb_hasActions", false]) exitWith {};
_crate setVariable ["rb_hasActions", true];

// === Destroy Crate Action
private _action = [
    "RB_DestroyCrate",
    "Destroy Crate",
    "ui\\icons\\icon_impound.paa",
    {
        params ["_target", "_player"];
        deleteVehicle _target;

        private _msg = "<t color='#ff3333'><t size='1.2'><t align='center'>🗑️ Crate destroyed.</t></t>";
        [_msg, 8] remoteExec ["ace_common_fnc_displayTextStructured", 0];
    },
    { true }
] call ace_interact_menu_fnc_createAction;

[_crate, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
