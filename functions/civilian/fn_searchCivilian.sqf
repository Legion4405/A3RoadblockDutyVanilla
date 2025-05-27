params ["_civ"];

// Retrieve civilian items
private _contraband = _civ getVariable ["civ_contraband", []];
private _misc       = _civ getVariable ["civ_miscItems", []];

// Combine and deduplicate
private _items = _misc + _contraband;
_items = _items arrayIntersect _items; // Remove duplicates

// Build display text
private _text = if (_items isEqualTo []) then {
    "<t size='1.2' font='PuristaBold' color='#ffffff'>No items found.</t>"
} else {
    "<t size='1.2' font='PuristaBold'>Civilian Possessions:</t><br/>" +
    (_items apply { format ["<t color='#ffffff'>• %1</t>", _x] } joinString "<br/>")
};

// Show structured text
[_text, 10] call ace_common_fnc_displayTextStructured;

// Attempt to turn hostile if illegal items are present
[_civ] call RB_fnc_tryTurnHostile;
