params ["_civ"];

// Assign identity
sleep 0.1;
private _name = name _civ;
private _origin = selectRandom nearestLocations [getPos _civ, ["NameCityCapital", "NameCity", "NameVillage"], 5000];
private _originName = if (!isNull _origin) then { text _origin } else { "Unknown" };
private _dob = selectRandom [
    "1986-01-22", "1992-07-14", "1990-04-05", "1988-11-30", "1995-06-17", "1983-03-02", "1991-12-10", "1996-08-25", "1978-10-12", "1980-02-28",
    "1993-09-07", "1984-12-15", "1987-05-23", "1994-04-19", "1990-01-09", "1975-11-03", "1997-06-30", "1979-08-18", "1981-03-21", "1985-07-11",
    "1992-12-27", "1989-09-13", "1977-10-05", "1998-02-06", "1999-04-14", "1974-06-09", "1993-11-20", "1982-08-03", "1990-05-30", "1986-10-01",
    "1995-03-25", "1991-07-17", "1972-12-08", "1976-09-22", "1988-06-16", "1994-05-07", "1973-04-27", "1985-02-13", "1996-01-19", "1997-08-12",
    "1998-10-29", "1980-03-10", "1979-05-04", "1993-01-26", "1982-07-31", "1999-12-03", "1971-11-14", "1990-09-08", "1987-06-06", "1984-03-15"
];
private _prefix = "ID";
private _idCode = _prefix + "-";
for "_i" from 1 to 7 do { _idCode = _idCode + str (floor (random 10)); };

_civ setVariable ["civ_identity", [_name, _originName, _dob, _idCode], true];

// === Contraband (default 30%)
private _contraband = [];
if (random 1 < 0.3) then { // 30% chance by default
    private _pool = missionNamespace getVariable ["RB_ActiveContraband", []];
    if (!(_pool isEqualTo [])) then {
        private _itemCount = 1 + floor (random 2); // 1–2 items
        for "_i" from 1 to _itemCount do {
            _contraband pushBackUnique (selectRandom _pool);
        };
    };
};
_civ setVariable ["rb_contraband", _contraband, true];

// === Misc items (3–5 from pool)
private _miscItems = [];
private _itemCount = 3 + floor (random 3);
private _miscPool = missionNamespace getVariable ["RB_NonContrabandItems", []];
if (!(_miscPool isEqualTo [])) then {
    for "_i" from 1 to _itemCount do {
        _miscItems pushBackUnique (selectRandom _miscPool);
    };
};
_civ setVariable ["rb_miscItems", _miscItems, true];
