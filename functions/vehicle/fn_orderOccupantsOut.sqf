// File: RB_fnc_orderOccupantsOut.sqf
params ["_vehicle"];
{
    if (alive _x && vehicle _x == _vehicle) then {
        unassignVehicle _x;
        moveOut _x;
        _x setVariable ["rb_preventReentry", true, true];
        _x setVariable ["rb_vehicle", nil, true];
        // Optional: Clear existing waypoints, e.g. _x doFollow objNull;
        _x disableAI "MOVE";
        _x stop true;
        doStop _x;
    };
} forEach crew _vehicle;
