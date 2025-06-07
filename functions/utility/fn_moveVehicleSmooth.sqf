/*
    RB_fnc_moveVehicleSmooth
    Smoothly moves a vehicle to a destination in MP. Always run this where vehicle is local (server!).
    [_vehicle, _dest] call RB_fnc_moveVehicleSmooth;
*/
params ["_veh", "_dest"];
if (isNull _veh) exitWith {};

private _speed = 5;
private _tick = 0.03;

private _from = getPosATL _veh;
private _angle = _from getDir _dest;
_veh setDir _angle;

private _distance = _veh distance _dest;
if (_distance < 1) exitWith {};

private _steps = floor (_distance / (_speed * _tick));
if (_steps < 1) then { _steps = 1; };
private _stepVec = [
    ((_dest select 0) - (_from select 0)) / _steps,
    ((_dest select 1) - (_from select 1)) / _steps,
    0
];

// Smoother: Only run this where vehicle is local (preferably server)
for "_i" from 1 to _steps do {
    _veh setPosATL ((getPosATL _veh) vectorAdd _stepVec);
    sleep _tick;
};
_veh setPosATL _dest;

// Example: close gate after move
private _gate = missionNamespace getVariable ["RB_Gate_1", objNull];
if (!isNull _gate) then {
    sleep 1;
    _gate animate ["Door_1_rot", 0];
};
