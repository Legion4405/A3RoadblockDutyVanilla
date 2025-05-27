params ["_civ"];

if (isNil "RB_ActiveIdentityPool" || {RB_ActiveIdentityPool isEqualTo []}) exitWith {
    diag_log "[RB] ERROR: Identity pool not set. Aborting identity assignment.";
};

// === Identity
private _chosenID = selectRandom RB_ActiveIdentityPool;
_civ setIdentity _chosenID;

sleep 0.1;
private _name = name _civ;

private _origin = selectRandom nearestLocations [getPos _civ, ["NameCityCapital", "NameCity", "NameVillage"], 5000];
private _originName = if (!isNull _origin) then { text _origin } else { "Unknown" };

private _dob = selectRandom [
    "1986-01-22", "1992-07-14", "1990-04-05", "1988-11-30",
    "1995-06-17", "1983-03-02", "1991-12-10", "1996-08-25"
];

private _prefix = "ID";
if (!isNil "RB_ActiveIdentityPool" && {count RB_ActiveIdentityPool > 0}) then {
    private _firstID = RB_ActiveIdentityPool select 0;
    if (_firstID find "RB_Civ_GR_" == 0) then { _prefix = "GR" };
    if (_firstID find "RB_Civ_AF_" == 0) then { _prefix = "AF" };
    if (_firstID find "RB_Civ_EU_" == 0) then { _prefix = "EU" };
};

private _idCode = _prefix + "-";
for "_i" from 1 to 7 do {
    _idCode = _idCode + str (floor (random 10));
};

// === Save identity info
_civ setVariable ["civ_identity", [_name, _originName, _dob, _idCode], true];

// === Contraband (30%)
private _contraband = [];
if (random 1 < 0.3) then {
    private _pool = missionNamespace getVariable ["RB_ActiveContraband", []];
    if (!(_pool isEqualTo [])) then {
        private _itemCount = floor random [1, 2.5, 3];
        for "_i" from 1 to _itemCount do {
            _contraband pushBackUnique (selectRandom _pool);
        };
    };
};
_civ setVariable ["civ_contraband", _contraband, true];

// === Misc items (3–5 from pool)
private _miscItems = [];
private _itemCount = 3 + floor (random 3);
private _miscPool = missionNamespace getVariable ["RB_NonContrabandItems", []];
if (!(_miscPool isEqualTo [])) then {
    for "_i" from 1 to _itemCount do {
        _miscItems pushBackUnique (selectRandom _miscPool);
    };
};
_civ setVariable ["civ_miscItems", _miscItems, true];
