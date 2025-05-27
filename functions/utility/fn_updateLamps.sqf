/*
    File: fn_updateLamps.sqf
    Description: Updates all lamp states based on RB_GeneratorState
*/
params ["_state"];

private _lampNames = [
    "RB_Lamp_1", "RB_Lamp_2", "RB_Lamp_3", "RB_Lamp_4",
    "RB_Lamp_5", "RB_Lamp_6", "RB_Lamp_7", "RB_Lamp_8"
];

{
    private _lamp = missionNamespace getVariable [_x, objNull];
    if (isNull _lamp) then {
        private _evaluated = call compile _x;
        if (!isNull _evaluated) then {
            missionNamespace setVariable [_x, _evaluated];
            _lamp = _evaluated;
        };
    };
    if (!isNull _lamp) then {
        _lamp switchLight (if (_state) then {"ON"} else {"OFF"});
    };
} forEach _lampNames;
