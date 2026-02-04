params ["_vehicle"];

{
    if (alive _x && vehicle _x == _vehicle) then {
        // === Persist vehicle legality state to civilian BEFORE separation!
        _x setVariable ["rb_vehicleBombHad",      _vehicle getVariable ["rb_hadBomb", false], true];
        _x setVariable ["rb_vehicleBombDefused",  _vehicle getVariable ["rb_bombDefused", false], true];
        _x setVariable ["rb_vehicleContraband",   _vehicle getVariable ["veh_contraband", []], true];
        _x setVariable ["rb_vehicleWasDriver",    (driver _vehicle == _x), true];

        unassignVehicle _x;
        moveOut _x;
        _x setVariable ["rb_preventReentry", true, true];
        _x setVariable ["rb_vehicle", nil, true];
        _x disableAI "MOVE";
        _x stop true;
        doStop _x;

        // --- Remove from current group (isolate into its own group on the same side)
        if (local _x) then {
            [_x] joinSilent (createGroup [side _x, true]);
        } else {
            // run the same code where the unit is local, without defining a new function
            [
                {
                    params ["_u"];
                    [_u] joinSilent (createGroup [side _u, true]);
                },
                [_x]
            ] remoteExecCall ["BIS_fnc_call", _x];
        };

        // If you truly want them group-less instead:
        // if (local _x) then { [_x] joinSilent grpNull } else { [{params ["_u"]; [_u] joinSilent grpNull}, [_x]] remoteExecCall ["BIS_fnc_call", _x]; };
    };
} forEach crew _vehicle;
