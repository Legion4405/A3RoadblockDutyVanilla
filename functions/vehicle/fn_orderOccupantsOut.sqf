params ["_vehicle"];
{
    if (alive _x && vehicle _x == _vehicle) then {
        // === Persist vehicle legality state to civilian BEFORE separation!
        _x setVariable ["rb_vehicleBombHad",   _vehicle getVariable ["rb_hasBomb", false], true];
        _x setVariable ["rb_vehicleBombDefused", _vehicle getVariable ["rb_bombDefused", false], true];
        _x setVariable ["rb_vehicleContraband", _vehicle getVariable ["veh_contraband", []], true];
        _x setVariable ["rb_vehicleWasDriver", (driver _vehicle == _x), true];
        // (Add any other vehicle legality data you want to persist)

        unassignVehicle _x;
        moveOut _x;
        _x setVariable ["rb_preventReentry", true, true];
        _x setVariable ["rb_vehicle", nil, true];
        _x disableAI "MOVE";
        _x stop true;
        doStop _x;
    };
} forEach crew _vehicle;
