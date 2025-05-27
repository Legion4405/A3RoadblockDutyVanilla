// scripts\spawnVehicle.sqf

private _pos = player modelToWorld [3, 0, 0];
private _vehicle = [_pos] call RB_fnc_spawnCivilianVehicle;

// Add ACE interactions to the vehicle
[_vehicle] call RB_fnc_addVehicleActions;

// Add ACE interactions to each civilian inside
{
    [_x] call RB_fnc_addCivilianActions;
} forEach crew _vehicle;
