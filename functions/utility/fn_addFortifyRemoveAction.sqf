/*
    File: fn_addFortifyRemoveAction.sqf
    Description: Adds a "Remove Object" action to restored fortifications to simulate ACE Fortify behavior.
*/
params ["_object"];

if (isNull _object) exitWith {};

private _action = [
    "RB_Fortify_Remove",
    "Remove Object",
    "", // No specific icon, default interaction
    {
        params ["_target", "_player"];
        
        // Animation
        _player playActionNow "Medic";
        
        [
            4, // Duration
            [_target],
            {
                params ["_args"];
                deleteVehicle (_args select 0);
                hint "Object removed.";
            },
            {
                params ["_args"];
                hint "Removal cancelled.";
            },
            "Removing Object..."
        ] call ace_common_fnc_progressBar;
    },
    { true } // Always allowed if you can interact
] call ace_interact_menu_fnc_createAction;

[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
