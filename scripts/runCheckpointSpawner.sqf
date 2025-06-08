/*
    File: fn_runCheckpointSpawner.sqf
    Description: Continuously spawns checkpoint entities (civilian or vehicle) at intervals based on intensity level.
*/
private _cleanupTimeoutMinutes = ["RB_CleanupTimeout", 4] call BIS_fnc_getParamValue;
private _cleanupTimeoutSeconds = _cleanupTimeoutMinutes * 60;

private _intensity = ["RB_Intensity", 1] call BIS_fnc_getParamValue;

while { true } do {
    private _delay = switch (_intensity) do {
        case 0: { 180 + random 120 }; // Low: 180–300 sec (3–5 min)
        case 1: { 90 + random 60 };   // Medium: 90–150 sec (1.5–2.5 min)
        case 2: { 45 + random 30 };   // High: 45–75 sec
        case 3: { 5 + random 5 };     // Very High: 5–10 sec
        default { 120 };
    };

    sleep _delay;

    //Check if any players are online, making it MP Persistence safe
    if (({isPlayer _x} count allPlayers) == 0) then { continue; };
    
    // if closed, just loop again without spawning
    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then {
        continue;
    };

    if (!isNil { missionNamespace getVariable "RB_CurrentEntity" }) then { continue };
    if (missionNamespace getVariable ["RB_SpawnerRunning", false]) then { continue };

    missionNamespace setVariable ["RB_SpawnerRunning", true, true];

    private _civilianChance = missionNamespace getVariable ["RB_CivilianChance", 0.0];
    private _timeoutSeconds = 90;
    private _holdPos = getMarkerPos "RB_HoldPoint";

    if (_holdPos isEqualTo [0,0,0]) exitWith {
        diag_log "[RB] ERROR: Marker 'RB_HoldPoint' not found.";
    };

    private _typeRoll = random 1;

    if (_typeRoll < _civilianChance) then {
        // === Foot civilian
        private _spawn = getMarkerPos "RB_FootSpawn";
        private _civPool = missionNamespace getVariable ["RB_ActiveCivilianPool", ["C_man_1"]];
        private _class = selectRandom _civPool;
        private _grp = createGroup civilian;
        private _civ = _grp createUnit [_class, _spawn, [], 0, "NONE"];
        _civ setVariable ["rb_isCivilian", true, true];

        [_civ] call RB_fnc_assignIdentityAndContraband;
        if ([_civ] call RB_fnc_isCivilianIllegal) then {
            _civ setVariable ["rb_illegal", true, true];
        };
        //[_civ] remoteExecCall ["RB_fnc_addCivilianActions", 0, _civ];

        _civ setBehaviour "CARELESS";
        _civ setCombatMode "BLUE";
        _civ setSpeedMode "LIMITED";
        _civ doMove _holdPos;

        missionNamespace setVariable ["RB_CurrentEntity", _civ, true];

        [_civ, _holdPos, _timeoutSeconds] spawn {
            params ["_entity", "_dest", "_timeout"];
            private _arrived = false;

            for "_i" from 1 to _timeout do {
                sleep 1;
                if (isNull _entity) exitWith {};
                if (_entity distance2D _dest < 10) exitWith { _arrived = true };
                if (!alive _entity) exitWith {};
            };

            if (!isNull _entity && {!_arrived || !alive _entity}) then {
                deleteVehicle _entity;
                missionNamespace setVariable ["RB_CurrentEntity", nil, true];
                diag_log "[RB] Civilian failed to arrive. Retrying.";
            } else {
                _entity setVariable ["readyForProcessing", true, true];
            };
        };
    } else {
        // === Civilian vehicle
    private _spawn = getMarkerPos "RB_VehSpawn";
    private _vehPool = missionNamespace getVariable ["RB_ActiveVehiclePool", ["C_Offroad_01_F"]];
    private _vehClass = selectRandom _vehPool;

    // Spawn the vehicle and civilians (let your spawn function handle passengers, or do it here)
    private _veh = [_spawn, _vehClass] call RB_fnc_spawnCivilianVehicle;
    _veh setDir (_spawn getDir (getMarkerPos "RB_VehSpawnDir"));

    private _crew = crew _veh;
    private _linkedCivilians = +_crew; // Start with those in vehicle

    // If you spawn additional passengers separately, add them to this array:
    // _linkedCivilians append _extraCiviliansArray;

    // Store linked civilians on the vehicle
    _veh setVariable ["rb_linkedCivilians", _linkedCivilians, true];

    private _driver = driver _veh;

    if (isNull _driver) then {
        { if (alive _x) then { deleteVehicle _x }; } forEach (crew _veh);
        { if (alive _x) then { deleteVehicle _x }; } forEach (_veh getVariable ["rb_linkedCivilians", []]);
        deleteVehicle _veh;

        missionNamespace setVariable ["RB_CurrentEntity", nil, true];
        missionNamespace setVariable ["RB_SpawnerRunning", false, true];
        diag_log "[RB] Vehicle spawned without a driver — cleaned up.";
        continue;
    };

    _driver setBehaviour "CARELESS";
    _driver setSpeedMode "LIMITED";
    _driver doMove _holdPos;

    missionNamespace setVariable ["RB_CurrentEntity", _veh, true];

    // Timeout/arrival logic with proper cleanup
    [_veh, _holdPos, _timeoutSeconds] spawn {
        params ["_entity", "_dest", "_timeout"];
        private _arrived = false;

        for "_i" from 1 to _timeout do {
            sleep 1;
            if (isNull _entity) exitWith {};
            if (_entity distance2D _dest < 10) exitWith { _arrived = true };
            if (!alive _entity) exitWith {};
        };

        if (isNull _entity || {!_arrived || !alive _entity}) then {
            // Clean up all crew and linked civilians (even if not in car)
            private _civs = _entity getVariable ["rb_linkedCivilians", []];
            { if (alive _x) then { deleteVehicle _x }; } forEach (crew _entity);
            { if (alive _x) then { deleteVehicle _x }; } forEach _civs;
            deleteVehicle _entity;

            missionNamespace setVariable ["RB_CurrentEntity", nil, true];
            diag_log "[RB] Vehicle failed to arrive. Retrying.";
        } else {
            _entity setVariable ["readyForProcessing", true, true];

            // Honk after 90 if not processed
            [_entity] spawn {
                params ["_veh"];
                sleep 90;
                if (!isNull _veh && {!(_veh getVariable ["rb_isProcessed", false])}) then {
                    private _driver = driver _veh;
                    if (!isNull _driver) then {
                        private _hornWep = currentWeapon _veh;
                        _driver forceWeaponFire [_hornWep, _hornWep];
                        sleep 3;
                        _driver forceWeaponFire [_hornWep, _hornWep];
                    };
                };
            };
            // Honk after 180 if not processed
            [_entity] spawn {
                params ["_veh"];
                sleep 180;
                if (!isNull _veh && {!(_veh getVariable ["rb_isProcessed", false])}) then {
                    private _driver = driver _veh;
                    if (!isNull _driver) then {
                        private _hornWep = currentWeapon _veh;
                        _driver forceWeaponFire [_hornWep, _hornWep];
                        sleep 3;
                        _driver forceWeaponFire [_hornWep, _hornWep];
                        sleep 3;
                        _driver forceWeaponFire [_hornWep, _hornWep];
                    };
                };
            };

            // Cleanup after 180 idle
            [_entity] spawn {
                params ["_veh"];
                sleep 240;
                if (!isNull _veh && {!(_veh getVariable ["rb_isProcessed", false])}) then {
                    // Clean up all crew and linked civilians (even if not in car)
                    private _civs = _veh getVariable ["rb_linkedCivilians", []];
                    { if (alive _x) then { deleteVehicle _x }; } forEach (crew _veh);
                    { if (alive _x) then { deleteVehicle _x }; } forEach _civs;
                    deleteVehicle _veh;

                    missionNamespace setVariable ["RB_CurrentEntity", nil, true];
                    diag_log "[RB] Vehicle expired at HoldPoint after 2 min. Retrying.";
                };
            };
        };
    };
    };
    missionNamespace setVariable ["RB_SpawnerRunning", false, true];
};
