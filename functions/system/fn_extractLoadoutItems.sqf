/*
    File: fn_extractLoadoutItems.sqf
    Purpose: Given a loadout array, returns a flat array of all unique classnames for ACE arsenal unlock.
    Params: [unit loadout array]
    Returns: array of unique item classnames
*/

params ["_loadout"];
private _items = [];

// Weapons: [primary, secondary, handgun]
{
    if (_x isEqualType []) then {
        private _weapon = if (count _x > 0) then { _x select 0 } else { "" };
        if (_weapon != "") then { _items pushBackUnique _weapon };

        // Optic, pointer, muzzle, etc.
        for "_i" from 2 to 3 do {
            private _att = if (count _x > _i) then { _x select _i } else { "" };
            if (_att != "") then { _items pushBackUnique _att };
        };

        // Magazine (sometimes missing)
        if (count _x > 4 && {(_x select 4) isEqualType [] && {count (_x select 4) > 0}}) then {
            private _mag = (_x select 4) select 0;
            if (_mag != "") then { _items pushBackUnique _mag };
        };
    };
} forEach (_loadout select [0,3]); // [primary, secondary, handgun]

// Uniform, vest, backpack
{
    private _container = _x;
    if (_container isEqualType [] && {count _container > 0}) then {
        private _class = _container select 0;
        if (_class != "") then { _items pushBackUnique _class };
        if (count _container > 1) then {
            // Items inside
            {
                private _item = _x select 0;
                if (_item != "") then { _items pushBackUnique _item };
            } forEach (_container select 1);
        };
    };
} forEach [_loadout select 3, _loadout select 4, _loadout select 5];

// Headgear, goggles
{ if (_x != "") then { _items pushBackUnique _x }; } forEach [_loadout select 6, _loadout select 7];

// Binoculars
if ((_loadout select 8) isEqualType [] && {count (_loadout select 8) > 0}) then {
    private _class = (_loadout select 8) select 0;
    if (_class != "") then { _items pushBackUnique _class };
};

// Assigned items (Map, GPS, Radio, Compass, Watch, NVG, etc.)
if (count _loadout > 9) then {
    { if (_x != "") then { _items pushBackUnique _x }; } forEach (_loadout select 9);
};

_items
