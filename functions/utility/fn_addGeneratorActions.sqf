/*
    File: fn_addGeneratorActions.sqf
    Description: Adds ACE interaction to RB_Generator to toggle its state and nearby lamps.
*/

if (!hasInterface) exitWith {};

private _generator = missionNamespace getVariable ["RB_Generator", objNull];
if (isNull _generator) exitWith {
    diag_log "[RB] Generator object 'RB_Generator' not found.";
};

if (_generator getVariable ["rb_hasActions", false]) exitWith {};
_generator setVariable ["rb_hasActions", true];

// === Create ACE action
private _action = [
    "RB_Generator_Toggle",
    "Toggle Generator",
    "",
    {
        params ["_target", "_player"];

        // Flip generator state
        if (isNil "RB_GeneratorState") then { RB_GeneratorState = true; };
        RB_GeneratorState = !RB_GeneratorState;
        publicVariable "RB_GeneratorState";

        // Broadcast lamp toggle to all clients
        [RB_GeneratorState] remoteExec ["RB_fnc_updateLamps", 0];

        hint format ["Generator is now %1", if (RB_GeneratorState) then {"ON"} else {"OFF"}];
    },
    { true }
] call ace_interact_menu_fnc_createAction;

[_generator, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
