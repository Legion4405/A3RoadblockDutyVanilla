/*
    File: fn_handleLogisticsRequest.sqf
    Description: Handles logistics crate, vehicle, and turret deliveries with structured feedback and cost handling.
*/

params ["_player", "_args"];
private _index = _args param [0];
private _categoryName = _args param [1];

private _categories = missionNamespace getVariable ["RB_LogisticsOptions", []];
private _categoryData = _categories select { (_x select 0) isEqualTo _categoryName };
if (_categoryData isEqualTo []) exitWith {};

private _options = _categoryData#0#1;
if (_index >= count _options) exitWith {};

private _data      = _options select _index;
private _label     = _data select 0;
private _contents  = _data select 1;
private _cost      = _data select (count _data - 1); // Last element is always cost

private _start   = getMarkerPos "RB_LogisticsStart";
private _end     = getMarkerPos "RB_LogisticsEnd";
private _drop    = getMarkerPos "RB_LogisticsEnd";
private _dirPos  = getMarkerPos "RB_LogisticsStartDir";

// === Prevent spam: 15s cooldown
private _lastTime = missionNamespace getVariable ["RB_LogisticsLastTime", 0];
private _waitLeft = ceil ((_lastTime + 15) - time) max 0;
if (_waitLeft > 0) exitWith {
    private _msg = format ["<t color='#ffff00' size='1.2'>Please wait %1 seconds before making another logistics request.</t>", _waitLeft];
    [_msg, 3] remoteExec ["ace_common_fnc_displayTextStructured", _player, false];
};

// === Check and deduct score
private _score = RB_Terminal getVariable ["rb_score", 0];
if (_score < _cost) exitWith {
    private _msg = format ["<t color='#ff9900' size='1.2' align='center'>Not enough points. %1 required.</t>", _cost];
    [_msg, 3] remoteExec ["ace_common_fnc_displayTextStructured", _player, false];
};

missionNamespace setVariable ["RB_LogisticsLastTime", time, true];
missionNamespace setVariable ["RB_LogisticsActive", true, true];
RB_Terminal setVariable ["rb_score", _score - _cost, true];

private _msg = format ["<t color='#99ccff' size='1.2' align='center'>Delivery '%1' requested. En route!</t>", _label];
[_msg, 3] remoteExec ["ace_common_fnc_displayTextStructured", _player, false];

// === Determine delivery type
private _isVehicle = (_categoryName == "Vehicles");
private _isTurret  = (_categoryName == "Turrets");
private _isSquad   = (_categoryName == "Reinforcements");

// === Determine delivery vehicle class
private _vehClass = missionNamespace getVariable ["RB_LogisticsVehicleClass", "B_Truck_01_box_F"];
if (_isVehicle) then { _vehClass = _contents#1; };
if (_isSquad)   then { _vehClass = _data select 2; };

// === Spawn truck + AI
private _truck = createVehicle [_vehClass, _start, [], 0, "NONE"];
if (!(_dirPos isEqualTo [0,0,0])) then { _truck setDir (_start getDir _dirPos); };

clearWeaponCargoGlobal _truck;
clearMagazineCargoGlobal _truck;
clearItemCargoGlobal _truck;
clearBackpackCargoGlobal _truck;

private _grp = createGroup west;
private _driver = _grp createUnit ["B_Soldier_F", _start, [], 0, "NONE"];
_driver moveInDriver _truck;
_grp addVehicle _truck;
_driver setBehaviour "CARELESS";
_driver setCombatMode "BLUE";
_grp setSpeedMode "LIMITED";

{ deleteWaypoint [_grp, _forEachIndex]; } forEach waypoints _grp;
private _wp = _grp addWaypoint [_end, 0];
_wp setWaypointType "MOVE";
_wp setWaypointSpeed "LIMITED";
_wp setWaypointCompletionRadius 8;
_grp setCurrentWaypoint _wp;

_truck setVariable ["rb_logisticsDriver", _driver];
_truck setVariable ["rb_logisticsLabel", _label];
_truck setVariable ["rb_logisticsCost", _cost];

// === Monitor delivery
[_truck, _drop, _contents, _label, _isVehicle, _isTurret, _isSquad, _player, _cost] spawn {
    params ["_truck", "_drop", "_contents", "_label", "_isVehicle", "_isTurret", "_isSquad", "_requester", "_cost"];
    private _timeout = time + 300;
    private _delivered = false;

    waitUntil {
        sleep 1;
        if (!isNull _truck && {_truck distance2D _drop < 17}) then {
            _delivered = true;
            true
        } else {
            !alive _truck || {isNull _truck} || {time > _timeout}
        }
    };

    if (_delivered) then {
        private _driver = _truck getVariable ["rb_logisticsDriver", objNull];
        if (!isNull _driver) then { deleteVehicle _driver };
        
        if (_isVehicle) then {
            // Leave vehicle on map
            private _msg = format ["<t color='#00ff00' size='1.2' align='center'>Vehicle '%1' delivered.</t>", _label];
            [_msg, 3] remoteExec ["ace_common_fnc_displayTextStructured", 0];
            _truck setVariable ["rb_isPersistentLogi", true, true];
            private _uniqueID = format ["%1_%2_%3", typeOf _truck, round diag_tickTime, floor random 1e6];
            _truck setVariable ["rb_persistenceID", _uniqueID, true];
            [_truck] remoteExec ["RB_fnc_addVehicleSalvageActions", 0, true];
            _truck engineOn false;
            
            // Optimization: Track in global array
            if (isNil "RB_LogisticsObjects") then { RB_LogisticsObjects = []; };
            RB_LogisticsObjects pushBack _truck;
        }
        else {
            deleteVehicle _truck;

            if (_isSquad) then {
                [
                    [_contents, _drop, _label, _requester],
                    {
                        params ["_unitClasses", "_drop", "_label", "_requester"];
                        if (isNull _requester && !isNil "p_1") then { _requester = p_1; };

                        private _grp = createGroup [west, true];
                        {
                            private _unit = _grp createUnit [_x, _drop, [], 3, "NONE"];
                            _unit setVariable ["rb_isPersistentLogi", true, true]; 
                        } forEach _unitClasses;

                        _grp selectLeader (units _grp select 0);
                        _grp setGroupIdGlobal [format ["%1", _label]];

                        if (!isNull _requester) then {
                            _grp setGroupOwner (owner _requester);
                            
                            [
                                [_grp],
                                {
                                    params ["_newGrp"];
                                    
                                    // FORCE Engine Recognition
                                    if (!isNil "RB_HC_Module" && { !isNull RB_HC_Module }) then {
                                        player setVariable ["BIS_HC_scope", RB_HC_Module];
                                    };

                                    // Simplified Logic (Matching example_init.sqf and user modifications)
                                    player hcSetGroup [_newGrp];

                                    ["<t color='#00ff00'>High Command: Squad Assigned</t>", 5] call ace_common_fnc_displayTextStructured;
                                }
                            ] remoteExec ["BIS_fnc_call", _requester];
                        };
                    }
                ] remoteExec ["BIS_fnc_call", 2];

                private _msg = format ["<t color='#00ff00' size='1.2' align='center'>Reinforcements '%1' arrived.</t>", _label];
                [_msg, 3] remoteExec ["ace_common_fnc_displayTextStructured", 0];
            }
            else {
                if (_isTurret) then {
                    private _obj = createVehicle [_contents#1, _drop, [], 0, "NONE"];
                    _obj setDir random 360;
                    _obj setVariable ["rb_isPersistentLogi", true, true];
                    private _uniqueID = format ["%1_%2_%3", typeOf _obj, round diag_tickTime, floor random 1e6];
                    _obj setVariable ["rb_persistenceID", _uniqueID, true];
                    [_obj] remoteExec ["RB_fnc_addVehicleSalvageActions", 0, true];
                    
                    // Optimization: Track in global array
                    if (isNil "RB_LogisticsObjects") then { RB_LogisticsObjects = []; };
                    RB_LogisticsObjects pushBack _obj;

                    private _msg = format ["<t color='#00ff00'><t size='1.2'><t align='center'>Turret '%1' delivered.</t></t>", _label];
                    [_msg, 3] remoteExec ["ace_common_fnc_displayTextStructured", 0];
                }
                else {
                    // Arsenal Unlock
                    private _arsenalBox = missionNamespace getVariable ["RB_Arsenal", objNull];
                    if (!isNull _arsenalBox) then {
                        { if !(_x in RB_ArsenalUnlocks) then { RB_ArsenalUnlocks pushBack _x; }; } forEach _contents;
                        [_arsenalBox, RB_ArsenalUnlocks, true] remoteExec ["ace_arsenal_fnc_addVirtualItems", 0, true];
                        private _msg = format ["<t color='#00ff00'><t size='1.2'><t align='center'> %1 unlocked in arsenal!</t></t>", _label];
                        [_msg, 3] remoteExec ["ace_common_fnc_displayTextStructured", 0];
                    };
                };
            };
        };
    } else {
        if (!isNull _truck) then { deleteVehicle _truck };
        private _score = RB_Terminal getVariable ["rb_score", 0];
        RB_Terminal setVariable ["rb_score", _score + _cost, true];
        private _msg = format ["<t color='#ff0000' size='1.2' align='center'>Delivery '%1' failed. Points refunded.</t>", _label];
        [_msg, 3] remoteExec ["ace_common_fnc_displayTextStructured", 0];
    };
    missionNamespace setVariable ["RB_LogisticsActive", false, true];
};