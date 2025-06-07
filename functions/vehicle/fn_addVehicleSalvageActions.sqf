/*
    File: fn_addVehicleSalvageFunctions.sqf
    Description: Adds ACE salvage interaction to eligible vehicles. MP + JIP Safe
*/

params ["_vehicle"];
if (isNull _vehicle) exitWith {};
if (!hasInterface) exitWith {}; // Only run on clients

// Only add once per client
if (_vehicle getVariable ["rb_hasActions", false]) exitWith {};
_vehicle setVariable ["rb_hasActions", true, true]; // synced globally

// Check if vehicle is NOT in civilian pool
private _vehClass = typeOf _vehicle;
private _civilianPool = missionNamespace getVariable ["RB_CivilianVehiclePool", []];
if (_vehClass in _civilianPool) exitWith {};

// === Create 'Salvage' category
private _salvageCategory = [
    "RB_SalvageCategory",
    "Salvage",
    "",
    {},
    { true }
] call ace_interact_menu_fnc_createAction;

[_vehicle, 0, ["ACE_MainActions"], _salvageCategory] call ace_interact_menu_fnc_addActionToObject;

// === Salvage Action
private _salvageAction = [
    "RB_SalvageVehicle",
    "Salvage Vehicle",
    "\a3\ui_f\data\IGUI\Cfg\Actions\obsolete_ca.paa",
    {
        params ["_target", "_player"];

        deleteVehicle _target;

        private _oldScore = RB_Terminal getVariable ["rb_score", 0];
        RB_Terminal setVariable ["rb_score", _oldScore + 5, true];

        private _msg = "<t color='#00ff00'><t size='1.2'><t align='center'>✅ Vehicle salvaged. +5 points</t></t>";
        [_msg, 5] remoteExec ["ace_common_fnc_displayTextStructured", 0];
    },
    { true }
] call ace_interact_menu_fnc_createAction;

[_vehicle, 0, ["ACE_MainActions", "RB_SalvageCategory"], _salvageAction] call ace_interact_menu_fnc_addActionToObject;
