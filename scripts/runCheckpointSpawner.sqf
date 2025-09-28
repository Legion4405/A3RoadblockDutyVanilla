/*
    File: fn_runCheckpointSpawner.sqf
    Description: Continuously spawns checkpoint entities (civilian or vehicle) at intervals based on intensity and parameters. Only spawns and sets up data—no scoring here.
*/

private _cleanupTimeoutMinutes = ["RB_CleanupTimeout", 4] call BIS_fnc_getParamValue;
private _cleanupTimeoutSeconds = _cleanupTimeoutMinutes * 60;
private _intensity = ["RB_Intensity", 1] call BIS_fnc_getParamValue;

while {true} do {
    // === Determine spawn delay based on intensity
    private _delay = switch (_intensity) do {
        case 0: { 360 + random 120 };
        case 1: { 240 + random 60 };
        case 2: { 180 + random 30 };
        case 3: { 90 + random 5 };
        default { 210 };
    };
    sleep _delay;

    // Only spawn if players are online and roadblock is open
    if (({isPlayer _x} count allPlayers) == 0) then {continue};
    if (missionNamespace getVariable ["RB_RoadblockClosed", false]) then {continue};
    if (!isNil { missionNamespace getVariable "RB_CurrentEntity" }) then {continue};
    if (missionNamespace getVariable ["RB_SpawnerRunning", false]) then {continue};

    missionNamespace setVariable ["RB_SpawnerRunning", true, true];

    private _civilianChance = missionNamespace getVariable ["RB_CivilianChance", 0.0];
    private _timeoutSeconds = 360;
    private _holdPos = getMarkerPos "RB_HoldPoint";

    if (_holdPos isEqualTo [0,0,0]) exitWith {
        diag_log "[RB] ERROR: Marker 'RB_HoldPoint' not found.";
    };

    private _typeRoll = random 1;

    if (_typeRoll < _civilianChance) then {
        // === Spawn foot civilian
        private _spawn = getMarkerPos "RB_FootSpawn";
        private _civPool = missionNamespace getVariable ["RB_ActiveCivilianPool", ["C_man_1"]];
        private _class = selectRandom _civPool;
        private _grp = createGroup civilian;
        private _civ = _grp createUnit [_class, _spawn, [], 0, "NONE"];
        _civ setVariable ["rb_isCivilian", true, true];
        [_civ] call RB_fnc_assignIdentityAndContraband;

        _civ setBehaviour "CARELESS";
        _civ setCombatMode "BLUE";
        _civ setSpeedMode "LIMITED";

        // Use waypoints for movement to RB_HoldPoint
        {
            deleteWaypoint [_grp, _forEachIndex];
        } forEach waypoints _grp;

        private _wp = _grp addWaypoint [_holdPos, 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
        _wp setWaypointCompletionRadius 10;
        _grp setCurrentWaypoint _wp;

        missionNamespace setVariable ["RB_CurrentEntity", _civ, true];

        [_civ, _holdPos, _timeoutSeconds, _grp] spawn {
            params ["_entity", "_dest", "_timeout", "_grp"];
            private _arrived = false;
            for "_i" from 1 to _timeout do {
                sleep 1;
                if (isNull _entity) exitWith {};
                if (_entity distance2D _dest < 10) exitWith {_arrived = true};
                if (!alive _entity) exitWith {};
            };
            if (!isNull _entity && {!_arrived || !alive _entity}) then {
                deleteVehicle _entity;
                missionNamespace setVariable ["RB_CurrentEntity", nil, true];
                diag_log "[RB] Civilian failed to arrive. Retrying.";
            } else {
                _entity setVariable ["readyForProcessing", true, true];
            };
            {deleteWaypoint [_grp, _forEachIndex]} forEach waypoints _grp;
        };
    } else {
        // === MULTI-SPAWNPOINT SUPPORT: Find all RB_VehSpawn_X/Dir_X pairs ===
        private _maxSpawns = 8; // Set a max to avoid infinite loop if badly named
        private _spawnPairs = [];
        for "_i" from 1 to _maxSpawns do {
            private _spawnName = format ["RB_VehSpawn_%1", _i];
            private _dirName   = format ["RB_VehSpawnDir_%1", _i];
            private _spawnPos = getMarkerPos _spawnName;
            private _dirPos   = getMarkerPos _dirName;
            if (!(_spawnPos isEqualTo [0,0,0]) && !(_dirPos isEqualTo [0,0,0])) then {
                _spawnPairs pushBack [_spawnPos, _dirPos];
            };
        };
        // Fallback for classic marker names
        if (_spawnPairs isEqualTo []) then {
            private _spawnPos = getMarkerPos "RB_VehSpawn";
            private _dirPos   = getMarkerPos "RB_VehSpawnDir";
            if (!(_spawnPos isEqualTo [0,0,0]) && !(_dirPos isEqualTo [0,0,0])) then {
                _spawnPairs pushBack [_spawnPos, _dirPos];
            };
        };
        if (_spawnPairs isEqualTo []) exitWith {
            diag_log "[RB] ERROR: No vehicle spawn pairs found!";
            missionNamespace setVariable ["RB_SpawnerRunning", false, true];
            continue;
        };
        private _selectedPair = selectRandom _spawnPairs;
        private _spawn = _selectedPair#0;
        private _dir   = _selectedPair#1;

        // Spawn vehicle as before
        private _vehPool = missionNamespace getVariable ["RB_ActiveVehiclePool", ["C_Offroad_01_F"]];
        private _vehClass = selectRandom _vehPool;
        private _veh = [_spawn] call RB_fnc_spawnCivilianVehicle;
        _veh setDir (_spawn getDir _dir);


        private _crew = crew _veh;
        private _linkedCivilians = +_crew;

        _veh setVariable ["rb_linkedCivilians", _linkedCivilians, true];

        private _driver = driver _veh;
        if (isNull _driver) then {
            // Clean up all possible passengers, even if not in car
            {if (alive _x) then {deleteVehicle _x}} forEach (crew _veh);
            {if (alive _x) then {deleteVehicle _x}} forEach (_veh getVariable ["rb_linkedCivilians", []]);
            deleteVehicle _veh;

            missionNamespace setVariable ["RB_CurrentEntity", nil, true];
            missionNamespace setVariable ["RB_SpawnerRunning", false, true];
            diag_log "[RB] Vehicle spawned without a driver — cleaned up.";
            continue;
        };

        _driver setBehaviour "CARELESS";
        _driver setSpeedMode "LIMITED";

        // Create a temporary group if needed
        private _vehGrp = group _driver;
        if (isNull _vehGrp || {_vehGrp == grpNull}) then {
            _vehGrp = createGroup civilian;
            [_driver] joinSilent _vehGrp;
            [_crew] joinSilent _vehGrp;
            [veh] addVehicle _vehGrp;
        };

        // Remove existing waypoints
        { deleteWaypoint [_vehGrp, _forEachIndex] } forEach waypoints _vehGrp;
        sleep 0.25;
        _vehGrp addVehicle _veh;
        sleep 2;
        // Add waypoint to RB_HoldPoint
        private _wp = _vehGrp addWaypoint [_holdPos, 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointBehaviour "CARELESS";
        _wp setWaypointSpeed "LIMITED";
        _wp setWaypointCompletionRadius 10;
        _vehGrp setCurrentWaypoint _wp;

        missionNamespace setVariable ["RB_CurrentEntity", _veh, true];

        // Timeout/arrival logic with proper cleanup
        [_veh, _holdPos, _timeoutSeconds, _vehGrp] spawn {
            params ["_entity", "_dest", "_timeout", "_vehGrp"];
            private _arrived = false;
            for "_i" from 1 to _timeout do {
                sleep 1;
                if (isNull _entity) exitWith {};
                if (_entity distance2D _dest < 10) exitWith {_arrived = true};
                if (!alive _entity) exitWith {};
            };

            if (isNull _entity || {!_arrived || !alive _entity}) then {
                private _civs = _entity getVariable ["rb_linkedCivilians", []];
                {if (alive _x) then {deleteVehicle _x}} forEach (crew _entity);
                {if (alive _x) then {deleteVehicle _x}} forEach _civs;
                deleteVehicle _entity;
                missionNamespace setVariable ["RB_CurrentEntity", nil, true];
                diag_log "[RB] Vehicle failed to arrive. Retrying.";
            } else {
                _entity setVariable ["readyForProcessing", true, true];

                // Honk after 90s/180s if not processed (flavor only)
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
                // Cleanup after 240 idle
                [_entity] spawn {
                    params ["_veh"];
                    sleep 360;
                    if (!isNull _veh && {!(_veh getVariable ["rb_isProcessed", false])}) then {
                        private _civs = _veh getVariable ["rb_linkedCivilians", []];
                        {if (alive _x) then {deleteVehicle _x}} forEach (crew _veh);
                        {if (alive _x) then {deleteVehicle _x}} forEach _civs;
                        deleteVehicle _veh;
                        missionNamespace setVariable ["RB_CurrentEntity", nil, true];
                        diag_log "[RB] Vehicle expired at HoldPoint after 4 min. Retrying.";
                    };
                };
            };
            {deleteWaypoint [_vehGrp, _forEachIndex]} forEach waypoints _vehGrp;
        };
    };
    missionNamespace setVariable ["RB_SpawnerRunning", false, true];
};
