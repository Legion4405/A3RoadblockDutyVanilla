/*
    RB_fnc_moveVehicleSmooth
    Smoothly moves a vehicle to a destination in MP. 
    Handles cleanup of momentum and AI to prevent 'overshoot and warp'.
    [_vehicle, _dest] call RB_fnc_moveVehicleSmooth;
*/
params ["_veh", "_dest"];
if (isNull _veh || !alive _veh) exitWith {};

// Ensure we are running where the vehicle is local (usually server)
if (!local _veh) exitWith {
    _this remoteExec ["RB_fnc_moveVehicleSmooth", _veh];
};

private _startPos = getPosATL _veh;
private _distance = _startPos distance _dest;
if (_distance < 0.1) exitWith {};

// Preparation: Stop the vehicle and disable AI movement
_veh setVelocity [0,0,0];
private _driver = driver _veh;
if (!isNull _driver) then {
    _driver disableAI "MOVE";
    _driver disableAI "PATH";
};

// Orientation
private _dir = _startPos getDir _dest;
_veh setDir _dir;

private _speed = 4.5; // Meters per second
private _duration = _distance / _speed;
private _startTime = time;

// Move Loop
while {time < (_startTime + _duration)} do {
    private _progress = (time - _startTime) / _duration;
    if (_progress > 1) then { _progress = 1; };
    
    // Linear Interpolation of position
    private _currentPos = _startPos vectorAdd ((_dest vectorDiff _startPos) vectorMultiply _progress);
    
    // Use setVelocityTransformation for the smoothest possible sync in MP
    _veh setVelocityTransformation [
        ATLToASL _currentPos, ATLToASL _currentPos,
        [0,0,0], [0,0,0],
        vectorDir _veh, vectorDir _veh,
        vectorUp _veh, vectorUp _veh,
        _progress
    ];
    
    sleep 0.01; // High frequency for smoothness
    if (!alive _veh) exitWith {};
};

// Final snap to destination to ensure precision
_veh setPosATL _dest;
_veh setVelocity [0,0,0];

// Cleanup: Close gate
private _gate = missionNamespace getVariable ["RB_Gate_1", objNull];
if (!isNull _gate) then {
    sleep 0.5;
    _gate animate ["Door_1_rot", 0];
};
