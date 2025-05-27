params ["_civ"];

// Retrieve civilian items
private _contraband = _civ getVariable ["civ_contraband", []];
private _misc       = _civ getVariable ["civ_miscItems", []];

// Build display lines
private _lines = [];

{
    _lines pushBack format ["<t color='#ffffff'>• %1</t>", _x];
} forEach _misc;

{
    _lines pushBack format ["<t color='#ff4444'>• %1 (ILLEGAL)</t>", _x];
} forEach _contraband;

private _text = if (_lines isEqualTo []) then {
    "<t size='1.2' font='PuristaBold' color='#ffffff'>No items found.</t>"
} else {
    "<t size='1.2' font='PuristaBold'>Civilian Possessions:</t><br/>" + (_lines joinString "<br/>")
};

// Show structured text
[_text, 10] call ace_common_fnc_displayTextStructured;

// Attempt to turn hostile if illegal items are present
[_civ] call RB_fnc_tryTurnHostile;
