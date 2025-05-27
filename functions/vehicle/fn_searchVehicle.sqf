// RB_fnc_searchVehicle
// Searches the vehicle's internal inventory only — not passengers or driver

params ["_vehicle"];

if (isNull _vehicle || {!alive _vehicle}) exitWith {
    hint "Vehicle is not valid.";
};

// === Retrieve stored inventory and contraband
private _inventory = _vehicle getVariable ["veh_inventory", []];
private _contraband = _vehicle getVariable ["veh_contraband", []];

// === Combine and deduplicate
private _items = _inventory + _contraband;
_items = _items arrayIntersect _items; // Remove duplicates

// === Build output text
private _msg = "";

if (_items isEqualTo []) then {
    _msg = "<t color='#00ff00'>No items found in vehicle.</t>";
} else {
    _msg = "<t size='1.3' font='PuristaBold' color='#ffffff'>Vehicle Contents:</t><br/><br/>";
    _msg = _msg + (_items apply { format ["• %1", _x] } joinString "<br/>");
};

// === Display to player
[_msg, 8] call ace_common_fnc_displayTextStructured;
