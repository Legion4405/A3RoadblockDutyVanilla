// scripts\vehicle\fn_spawnCivilianVehicle.sqf
// Spawns a civilian vehicle, fully restores all registration and bomb/contraband logic.
// NO judgment or scoring in this script!

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
private _grp = createGroup civilian;
_grp addVehicle _vehicle;

for "_i" from 0 to (_crewCount - 1) do {
    private _classPool = missionNamespace getVariable ["RB_ActiveCivilianPool", ["C_man_1"]];
    private _class = selectRandom _classPool;

    private _civ = _grp createUnit [_class, _position, [], 0, "NONE"];
    _civ setVariable ["rb_isCivilian", true, true];
    _civ setVariable ["rb_vehicle", _vehicle, true];

    // === Assign identity and contraband here (safe for all future checks!)
    if (isNil {_civ getVariable "civ_identity"}) then {
        [_civ] call RB_fnc_assignIdentityAndContraband;
    };

    // === ACE actions (JIP safe)
    [_civ] remoteExecCall ["RB_fnc_addCivilianActions", 0, _civ];

    _crew pushBack _civ;
};

// === Move civilians into vehicle (driver first)
(_crew#0) moveInDriver _vehicle;
_vehicle setVariable ["rb_initialDriver", _crew#0, true];

for "_i" from 1 to ((count _crew) - 1) do {
    (_crew#_i) moveInAny _vehicle;
    (_crew#_i) setBehaviour "CARELESS";
};

_vehicle enableAI "MOVE";
_vehicle enableAI "PATH";
_vehicle enableAI "ALL";
{ _x enableAI "MOVE"; _x enableAI "ALL"; } forEach crew _vehicle;

sleep 0.25;  // Give time for AI to initialize

_grp addVehicle _vehicle; // Re-assign just in case (harmless if already assigned)


// === Vehicle contraband/items
private _illegalPool = missionNamespace getVariable ["RB_ActiveContraband", []];
private _legalPool   = missionNamespace getVariable ["RB_NonContrabandItems", []];
private _vehItems = [];

// Legal items
private _numLegalItems = floor random 6;
for "_i" from 1 to _numLegalItems do {
    _vehItems pushBackUnique (selectRandom _legalPool);
};

// Contraband items (15% chance)
if (random 1 < 0.15) then {
    for "_i" from 1 to (1 + floor random 2) do {
        _vehItems pushBackUnique (selectRandom _illegalPool);
    };
};

// Save variables
_vehicle setVariable ["veh_items", _vehItems, true];
_vehicle setVariable ["veh_contraband", _vehItems select { _x in _illegalPool }, true];


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
        _regName = selectRandom RB_FakeNames;
    } else {
        private _prefix = (_realID select [0,2]);
        _regID = _prefix + "-";
        for "_i" from 1 to 7 do { _regID = _regID + str (floor (random 10)); };
    };
};

// Get world name and uppercase it
private _worldNameRaw = toUpper worldName;                // "MALDEN", "S'AHATRA", etc.

// Strip 'GM_' prefix if present (for GM maps like Weferlingen)
if (_worldNameRaw select [0, 3] == "GM_") then { _worldNameRaw = _worldNameRaw select [3]; };

// Convert to array of chars and filter only A-Z
private _worldNameArray = toArray _worldNameRaw;
private _worldNameFilteredArray = _worldNameArray select { _x in toArray "ABCDEFGHIJKLMNOPQRSTUVWXYZ" };

// Get first two letters and convert back to string
private _prefix = toString (_worldNameFilteredArray select [0, 2]);

// === Plate assignment
private _isGM = ((typeOf _vehicle) select [0, 3] == "gm_");
private _realPlate = "";

if (_isGM) then {
    // GM Specific Format: "WE 12-34" (Max space compliance)
    _realPlate = format ["%1 %2-%3", _prefix, floor (random 90 + 10), floor (random 90 + 10)];
} else {
    // Standard Format: "XX-123456"
    _realPlate = format ["%1-%2", _prefix, floor (random 900000 + 100000)];
};

_vehicle setPlateNumber _realPlate;

// --- Global Mobilization Attribute Sync
if (_isGM && {!isNil "gm_core_vehicles_fnc_vehicleMarkingsUpdateAttributes"}) then {
    [_vehicle, _realPlate, 0, 1] call gm_core_vehicles_fnc_vehicleMarkingsUpdateAttributes;
};

private _regPlate = if (random 1 < 0.15) then {
    if (_isGM) then {
        format ["%1 %2-%3", _prefix, floor (random 90 + 10), floor (random 90 + 10)]
    } else {
        format ["%1-%2", _prefix, floor (random 900000 + 100000)]
    };
} else {
    _realPlate;
};



// === Store registration and violations (no scoring here)
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

// === Do NOT set any scoring or 'civ_isIllegal' or similar flags here! All judgment is done elsewhere.

// === Cache crew list for later checks
_vehicle setVariable ["rb_vehicleCrew", _crew, true];

// === Bomb (5% chance, disables on clear as before)
if (random 1 < 0.05) then {
    private _bomb = createVehicle ["DemoCharge_F", getPos _vehicle, [], 0, "NONE"];
    _bomb attachTo [_vehicle, [0, 0, 0]];
    _bomb hideObjectGlobal true;
    _bomb setObjectScale 0;
    _bomb enableSimulationGlobal false;
    _bomb allowDamage false;

    _vehicle setVariable ["rb_hasBomb", true, true];
    _vehicle setVariable ["rb_hadBomb", true, true];
    _vehicle setVariable ["rb_bombDefused", false, true];
} else {
    _vehicle setVariable ["rb_hasBomb", false, true];
    _vehicle setVariable ["rb_bombDefused", false, true];
};

// === Pre-Cache Vehicle Data on Civilians (Safety against early vehicle deletion)
{
    private _civ = _x;
    _civ setVariable ["rb_vehicle", _vehicle, true]; // Ensure link is set
    _civ setVariable ["rb_vehicleBombHad", _vehicle getVariable ["rb_hadBomb", false], true];
    _civ setVariable ["rb_vehicleBombDefused", _vehicle getVariable ["rb_bombDefused", false], true];
    _civ setVariable ["rb_vehicleContraband", _vehicle getVariable ["veh_contraband", []], true];
    _civ setVariable ["rb_vehicleWasDriver", (driver _vehicle == _civ), true];
} forEach _crew;

_vehicle
