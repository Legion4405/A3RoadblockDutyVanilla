// Create a new civilian group
private _grp = createGroup civilian;

// Define spawn position
private _position = getPos player;

// Select a civilian class from the active pool
private _civPool = missionNamespace getVariable ["RB_ActiveCivilianPool", ["C_man_1"]];
private _class = selectRandom _civPool;

// Create the civilian unit
private _civ = _grp createUnit [_class, _position, [], 0, "NONE"];
_civ setVariable ["rb_isCivilian", true, true];

// Assign randomized identity and contraband
[_civ] call RB_fnc_assignIdentityAndContraband;

// Flag as illegal if appropriate
if ([_civ] call RB_fnc_isCivilianIllegal) then {
    _civ setVariable ["rb_illegal", true, true];
};

// Add ACE interaction actions
[_civ] call RB_fnc_addCivilianActions;
