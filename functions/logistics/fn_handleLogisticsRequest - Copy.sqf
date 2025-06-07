/*
    File: fn_handleLogisticsRequest.sqf
    Description: Handles logistics crate, vehicle, and turret deliveries with structured feedback and cost handling.
*/

params ["_player", "_args"];
private _index = _args param [0];
private _categoryName = _args param [1];

private _categories = missionNamespace getVariable ["RB_LogisticsOptions", []];
private _categoryData = _categories select { (_x select 0) isEqualTo _categoryName };
if (_categoryData isEqualTo []) exitWith {
    private _msg = format [
        "<t color='#ff0000'><t size='1.2'><t align='center'>❌ Category '%1' not found.</t></t>",
        _categoryName
    ];
    [_msg, 10] remoteExec ["ace_common_fnc_displayTextStructured", _player, false];
};

private _options = _categoryData#0#1;
if (_index >= count _options) exitWith {
    private _msg = "<t color='#ff0000'><t size='1.2'><t align='center'>❌ Invalid logistics request index.</t></t>";
    [_msg, 10] remoteExec ["ace_common_fnc_displayTextStructured", _player, false];
};

private _data      = _options select _index;
private _label     = _data select 0;
private _crateType = _data select 1;
private _contents  = _data select 2;
private _cost      = _data select 3;

private _start   = getMarkerPos "RB_LogisticsStart";
private _end     = getMarkerPos "RB_LogisticsEnd";
private _drop    = getMarkerPos "RB_LogisticsDrop";
private _dirPos  = getMarkerPos "RB_LogisticsStartDir";

// === Prevent overlapping deliveries
if (missionNamespace getVariable ["RB_LogisticsActive", false]) exitWith {
    private _msg = "<t color='#ffff00'><t size='1.2'>⚠️ A delivery is already in progress. Please wait.</t>";
    [_msg, 10] remoteExec ["ace_common_fnc_displayTextStructured", _player, false];
};

// === Validate markers
if (_start isEqualTo [0,0,0] || _end isEqualTo [0,0,0] || _drop isEqualTo [0,0,0]) exitWith {
    systemChat "⚠️ Logistics markers not properly set.";
};

// === Check and deduct score
private _score = RB_Terminal getVariable ["rb_score", 0];
if (_score < _cost) exitWith {
    private _msg = format [
        "<t color='#ff9900'><t size='1.2'><t align='center'>⚠️ Not enough points. %1 required.</t></t>",
        _cost
    ];
    [_msg, 10] remoteExec ["ace_common_fnc_displayTextStructured", _player, false];
};

missionNamespace setVariable ["RB_LogisticsActive", true, true];
RB_Terminal setVariable ["rb_score", _score - _cost, true];

private _msg = format [
    "<t color='#99ccff'><t size='1.2'><t align='center'>📦 Delivery '%1' requested. En route!</t></t>",
    _label
];
[_msg, 10] remoteExec ["ace_common_fnc_displayTextStructured", _player, false];

// === Determine delivery vehicle class
private _vehClass = "B_Truck_01_box_F"; // Default
if ((count _contents == 2) && { (_contents#0) isEqualTo "VEHICLE" }) then {
    _vehClass = _contents#1;
};

// === Spawn truck + AI
private _truck = createVehicle [_vehClass, _start, [], 0, "NONE"];

if (!(_dirPos isEqualTo [0,0,0])) then {
    _truck setDir (_start getDir _dirPos);
};

private _grp = createGroup west;
private _driver = _grp createUnit ["B_Soldier_F", _start, [], 0, "NONE"];
_driver moveInDriver _truck;
_grp addVehicle _truck;
_grp selectLeader _driver;

_driver setBehaviour "SAFE";
_driver setCombatMode "BLUE";

_truck setVariable ["rb_logisticsDriver", _driver];
_truck setVariable ["rb_logisticsLabel", _label];
_truck setVariable ["rb_logisticsCost", _cost];

_truck setDestination [_end, "LEADER PLANNED", true];
_driver doMove _end;

// === Monitor delivery
[_truck, _drop, _crateType, _contents, _label] spawn {
    params ["_truck", "_drop", "_crateType", "_contents", "_label"];
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

    private _driver = _truck getVariable ["rb_logisticsDriver", objNull];
    private _cost   = _truck getVariable ["rb_logisticsCost", 0];

    if (_delivered) then {
        if (!isNull _driver) then { deleteVehicle _driver };
        
        private _isVehicle = (count _contents == 2) && { (_contents#0) isEqualTo "VEHICLE" };
        private _isTurret  = (count _contents == 2) && { (_contents#0) isEqualTo "TURRET" };

        if (_isVehicle) then {
            // Truck is the delivery — leave it on map
            private _msg = format [
                "<t color='#00ff00'><t size='1.2'><t align='center'>✅ Vehicle '%1' delivered.</t></t>",
                _label
            ];
            [_msg, 5] remoteExec ["ace_common_fnc_displayTextStructured", 0];

            _truck setVariable ["rb_isPersistentLogi", true, true];

            private _now = diag_tickTime;  // or use serverTime if you want
            private _type = typeOf _truck;
            private _rand = floor random 1e6;
            private _uniqueID = format ["%1_%2_%3", _type, round _now, _rand];

            _truck setVariable ["rb_persistenceID", _uniqueID, true];
            [_truck] call RB_fnc_addVehicleSalvageActions;

        }
        else {
            deleteVehicle _truck;

            if (_isTurret) then {
                private _turretClass = _contents#1;
                private _obj = createVehicle [_turretClass, _drop, [], 0, "NONE"];
                _obj setDir random 360;
                _obj setVariable ["rb_isPersistentLogi", true, true];

                private _now = diag_tickTime;  // or use serverTime if you want
                private _type = typeOf _obj;
                private _rand = floor random 1e6;
                private _uniqueID = format ["%1_%2_%3", _type, round _now, _rand];

                _obj setVariable ["rb_persistenceID", _uniqueID, true];



                private _msg = format [
                    "<t color='#00ff00'><t size='1.2'><t align='center'>✅ Turret '%1' delivered.</t></t>",
                    _label
                ];
                [_msg, 5] remoteExec ["ace_common_fnc_displayTextStructured", 0];
            }
            else {
                // Crate delivery
                private _crate = createVehicle [_crateType, _drop, [], 0, "NONE"];
                clearWeaponCargoGlobal _crate;
                clearMagazineCargoGlobal _crate;
                clearItemCargoGlobal _crate;
                clearBackpackCargoGlobal _crate;
                _crate setVariable ["rb_isPersistentLogi", true, true];

                private _now = diag_tickTime;  // or use serverTime if you want
                private _type = typeOf _crate;
                private _rand = floor random 1e6;
                private _uniqueID = format ["%1_%2_%3", _type, round _now, _rand];

                _crate setVariable ["rb_persistenceID", _uniqueID, true];



                {
    private _class = _x select 0;
    private _count = _x select 1;

    if (isClass (configFile >> "CfgMagazines" >> _class)) then {
        _crate addMagazineCargoGlobal [_class, _count];

    } else {
        if (isClass (configFile >> "CfgWeapons" >> _class)) then {
            private _itemType = getNumber (configFile >> "CfgWeapons" >> _class >> "type");

            if (_itemType in [1, 2, 4]) then {
                _crate addWeaponCargoGlobal [_class, _count];
            } else {
                _crate addItemCargoGlobal [_class, _count];
            };

            if ((count _x) > 2 && { typeName (_x select 2) == "ARRAY" }) then {
                private _attachments = _x select 2;
                {
                    private _attClass = _x select 0;
                    private _attCount = _x select 1;
                    _crate addItemCargoGlobal [_attClass, _attCount * _count];
                } forEach _attachments;
            };

        } else {
            if (isClass (configFile >> "CfgVehicles" >> _class)) then {
                private _vClass = getText (configFile >> "CfgVehicles" >> _class >> "vehicleClass");
                if (_vClass == "Backpacks") then {
                    _crate addBackpackCargoGlobal [_class, _count];
                } else {
                    _crate addItemCargoGlobal [_class, _count];
                };
            } else {
                _crate addItemCargoGlobal [_class, _count];
            };
        };
    };
} forEach _contents;





                [_crate] remoteExec ["RB_fnc_addCrateActions", 0, _crate];

                private _msg = format [
                    "<t color='#00ff00'><t size='1.2'><t align='center'>✅ Supply Crate '%1' delivered.</t></t>",
                    _label
                ];
                [_msg, 5] remoteExec ["ace_common_fnc_displayTextStructured", 0];
            };
        };
    } else {
        if (!isNull _driver) then { deleteVehicle _driver };
        if (!isNull _truck) then { deleteVehicle _truck };

        private _score = RB_Terminal getVariable ["rb_score", 0];
        RB_Terminal setVariable ["rb_score", _score + _cost, true];

        private _msg = format [
            "<t color='#ff0000'><t size='1.2'><t align='center'>❌ Delivery '%1' failed. Points refunded.</t></t>",
            _label
        ];
        [_msg, 10] remoteExec ["ace_common_fnc_displayTextStructured", 0];
    };

    missionNamespace setVariable ["RB_LogisticsActive", false, true];
};
