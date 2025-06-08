// scripts\vehicle\spawnCivilianVehicle.sqf
params ["_position"];

// === Choose vehicle type from active pool
private _vehiclePool = missionNamespace getVariable ["RB_ActiveVehiclePool", ["C_Offroad_01_F"]];
private _vehType = selectRandom _vehiclePool;

// === Create vehicle
private _vehicle = createVehicle [_vehType, _position, [], 0, "NONE"];
_vehicle setVariable ["rb_isCivilianVehicle", true, true];

// === Determine crew count (1 driver + 0–2 passengers)
private _crewCount = 1 + floor random 3;
private _crew = [];

// === Create civilians
for "_i" from 0 to (_crewCount - 1) do {
    private _classPool = missionNamespace getVariable ["RB_ActiveCivilianPool", ["C_man_1"]];
    private _class = selectRandom _classPool;

    private _grp = createGroup civilian;
    private _civ = _grp createUnit [_class, _position, [], 0, "NONE"];
    _civ setVariable ["rb_isCivilian", true, true];
    _civ setVariable ["rb_vehicle", _vehicle, true];

    _crew pushBack _civ;
};

// === Move civilians into vehicle (driver first)
(_crew#0) moveInDriver _vehicle;
for "_i" from 1 to ((count _crew) - 1) do {
    (_crew#_i) moveInAny _vehicle;
    (_crew#_i) setBehaviour "CARELESS";
};

// === Assign identity and ACE actions
{
    if (isNil {_x getVariable "civ_identity"}) then {
        [_x] call RB_fnc_assignIdentityAndContraband;
    };
    [_x] remoteExecCall ["RB_fnc_addCivilianActions", 0, _x];
} forEach _crew;

private _illegalPool = missionNamespace getVariable ["RB_ActiveContraband", []];
private _legalPool   = missionNamespace getVariable ["RB_NonContrabandItems", []];
private _vehItems = [];

// === Legal items (0–5)
private _numLegalItems = floor random 6;
for "_i" from 1 to _numLegalItems do {
    _vehItems pushBackUnique (selectRandom _legalPool);
};

// === 15% chance of contraband
if (random 1 < 0.15) then {
    for "_i" from 1 to (1 + floor random 2) do {
        _vehItems pushBackUnique (selectRandom _illegalPool);
    };
};
_vehicle setVariable ["veh_contraband", _vehItems, true];

// === Registration setup
private _driver = _crew#0;
private _identity = _driver getVariable ["civ_identity", ["Unknown", "Unknown", "Unknown", "UNKNOWN"]];
private _realName = _identity#0;
private _realID   = _identity#3;

private _regName = _realName;
private _regID   = _realID;

// === 15% chance of mismatch
if (random 1 < 0.15) then {
    if (selectRandom ["name", "id"] == "name") then {
        _regName = selectRandom ["Nikolas Vrettos", "Emre Kamal", "Samuel Bakari", "Unverified"];
    } else {
        _regID = ([_realID select [0,2], "-", str (floor random [1000000,9999999,1])] joinString "");
    };
};

// === Plate
private _realPlate = format ["RB-%1", floor (random 900000 + 100000)];
_vehicle setPlateNumber _realPlate;

private _regPlate = if (random 1 < 0.15) then {
    format ["RB-%1", floor (random 900000 + 100000)];
} else {
    _realPlate;
};

// === Store registration and violations
_vehicle setVariable ["veh_registration", [_regName, _regID, _regPlate], true];

private _plateMismatch = (toUpper _regPlate != toUpper _realPlate);
private _nameMismatch  = (toUpper _regName != toUpper _realName);
private _idMismatch    = (_regID != _realID);
private _hasContraband = (_vehItems select { _x in _illegalPool }) isNotEqualTo [];

_vehicle setVariable ["cached_veh_contraband", _vehItems select { _x in _illegalPool }, true];
_vehicle setVariable ["cached_veh_plateMismatch", _plateMismatch, true];
_vehicle setVariable ["cached_veh_regNameMismatch", _nameMismatch, true];
_vehicle setVariable ["cached_veh_regIDMismatch", _idMismatch, true];
_vehicle setVariable ["cached_veh_regOwner", str _realName, true];


// === Mark civilians as illegal if violations exist
private _flagged = _plateMismatch || _nameMismatch || _idMismatch || _hasContraband;
if (_flagged) then {
    {
        _x setVariable ["civ_isIllegal", true, true];
    } forEach _crew;
};

// === Cache crew list
_vehicle setVariable ["rb_vehicleCrew", _crew, true];

// === Bomb (10% chance)
if (random 1 < 0.1) then {
    private _bomb = createVehicle ["DemoCharge_F", getPos _vehicle, [], 0, "NONE"];
    _bomb attachTo [_vehicle, [0, 0, 0]];
    _bomb hideObjectGlobal true;
    _bomb setObjectScale 0;
    _bomb enableSimulationGlobal false;
    _bomb allowDamage false;

    _vehicle setVariable ["veh_hasBomb", true, true];
};

_vehicle
