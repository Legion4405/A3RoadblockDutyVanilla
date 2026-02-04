/*
    File: fn_monitorArrival.sqf
    Description: Monitors a traffic entity (foot or vehicle) as it moves to the checkpoint.
    Handles arrival radius, bomb timers, lights off, and idle cleanup.
*/

params ["_entity", "_grp", "_dest", "_timeout", "_cleanupSeconds"];

if (!isServer) exitWith {};

[_entity, _grp, _dest, _timeout, _cleanupSeconds] spawn {
    params ["_entity", "_grp", "_dest", "_timeout", "_cleanupSeconds"];
    private _arrived = false;
    
    // 1. Wait for Arrival
    for "_i" from 1 to _timeout do {
        sleep 1;
        if (isNull _entity) exitWith {};
        if (_entity distance2D _dest < 15) exitWith { _arrived = true; };
        if (!alive _entity && {!(_entity getVariable ["rb_isBombWreck", false])}) exitWith {};
    };
    
    // 2. Handle Failure
    if (isNull _entity || {(!_arrived || !alive _entity) && !(_entity getVariable ["rb_isBombWreck", false])}) then {
        if (!isNull _entity) then {
            if ((missionNamespace getVariable ["RB_CurrentEntity", objNull]) isEqualTo _entity) then {
                missionNamespace setVariable ["RB_CurrentEntity", nil, true];
            };
            private _civs = _entity getVariable ["rb_linkedCivilians", []];
            { deleteVehicle _x } forEach (crew _entity);
            { deleteVehicle _x } forEach _civs;
            deleteVehicle _entity;
        };
    } else {
        // 3. Arrival Logic
        if (alive _entity || _entity getVariable ["rb_isBombWreck", false]) then {
            _entity setVariable ["readyForProcessing", true, true];
            
            if (_entity isKindOf "LandVehicle") then { 
                _entity engineOn false;
                _entity setPilotLight false; 
                _entity setCollisionLight false;
                _entity action ["lightOff", _entity];
                
                // One-time damage to lights to force them off
                private _hitPoints = getAllHitPointsDamage _entity;
                if (_hitPoints isNotEqualTo []) then {
                    private _names = _hitPoints select 0;
                    {
                        if ((toLower _x) find "light" > -1) then {
                            _entity setHitPointDamage [_x, 1.0];
                        };
                    } forEach _names;
                };
            };
            
            // === BOMB TIMER LOGIC ===
            if (alive _entity && _entity isKindOf "LandVehicle" && {_entity getVariable ["rb_hasBomb", false]}) then {
                [_entity] spawn {
                    params ["_veh"];
                    
                    waitUntil {
                        sleep 1;
                        (!alive _veh) || 
                        (_veh getVariable ["rb_processingStarted", false]) ||
                        (_veh getVariable ["rb_bombDefused", false])
                    };
                    
                    if (!alive _veh || (_veh getVariable ["rb_bombDefused", false])) exitWith {};

                    private _blowTime = time + 60;
                    
                    waitUntil {
                        sleep 1;
                        if (!alive _veh) exitWith {true}; 
                        if (_veh getVariable ["rb_bombDefused", false]) exitWith {true}; 
                        if (!(_veh getVariable ["rb_hasBomb", false])) exitWith {true}; 
                        
                        time > _blowTime
                    };

                    if (alive _veh && !(_veh getVariable ["rb_bombDefused", false]) && (_veh getVariable ["rb_hasBomb", false])) then {
                         _veh setVariable ["rb_isBombWreck", true, true];
                         "Bo_GBU12_LGB" createVehicle (getPos _veh);
                         _veh setDamage 1;

                         private _score = RB_Terminal getVariable ["rb_score", 0];
                         RB_Terminal setVariable ["rb_score", _score - 50, true];
                         ["<t color='#ff0000' size='1.5'>Vehicle Detonated! -50 Points</t>", 5] remoteExec ["ace_common_fnc_displayTextStructured", 0];

                         private _action = [
                            "RB_ClearWreck", "Clear Wreckage", "ui\icons\icon_clearpro.paa",
                            {
                                params ["_target", "_player"];
                                if ((missionNamespace getVariable ["RB_CurrentEntity", objNull]) isEqualTo _target) then {
                                      missionNamespace setVariable ["RB_CurrentEntity", nil, true];
                                };
                                deleteVehicle _target;
                                ["<t color='#00ff00'>Wreckage Cleared</t>", 3] remoteExec ["ace_common_fnc_displayTextStructured", 0];
                            }, { true } 
                         ] call ace_interact_menu_fnc_createAction;
                         
                         [_veh, 0, ["ACE_MainActions"], _action] remoteExec ["ace_interact_menu_fnc_addActionToObject", 0, true];
                    };
                };
            };

            // 4. Idle Cleanup Watchdog
            [_entity, _cleanupSeconds] spawn {
                params ["_ent", "_time"];
                sleep _time;
                if (isNull _ent) exitWith {};
                if (missionNamespace getVariable ["rb_processingInProgress", false]) exitWith {};
                
                if ((missionNamespace getVariable ["RB_CurrentEntity", objNull]) isEqualTo _ent) then {
                    if (_ent getVariable ["rb_isBombWreck", false]) exitWith {};

                    if (!(_ent getVariable ["rb_isProcessed", false]) && !(_ent getVariable ["rb_sentToExit", false])) then {
                        private _civs = _ent getVariable ["rb_linkedCivilians", []];
                        { deleteVehicle _x } forEach (crew _ent);
                        { deleteVehicle _x } forEach _civs;
                        deleteVehicle _ent;
                        missionNamespace setVariable ["RB_CurrentEntity", nil, true];
                        diag_log "[RB] Traffic Entity expired (Idle).";
                    };
                };
            };
        };
    };
    
    // 5. Waypoint Cleanup
    if (!isNull _grp) then {
        for "_i" from count waypoints _grp - 1 to 0 step -1 do { deleteWaypoint [_grp, _i]; };
    };
};
