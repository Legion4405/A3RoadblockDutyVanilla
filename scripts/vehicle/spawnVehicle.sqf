// scripts\spawnVehicle.sqf
private _pos = player modelToWorld [3, 0, 0];
private _vehicle = [_pos] call RB_fnc_spawnCivilianVehicle;
[_vehicle] call RB_fnc_addVehicleActions;
