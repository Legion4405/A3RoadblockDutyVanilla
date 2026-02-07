/*
    Assigns identity, possible fugitive status, contraband, and misc items to a civilian.
    Call: [_civ] call RB_fnc_assignIdentityAndContraband;
*/
params ["_civ"];

// === FUGITIVE ASSIGNMENT (Step 2)
private _fugitiveName   = missionNamespace getVariable ["RB_CurrentFugitive", "UNKNOWN"];
private _fugitiveActive = missionNamespace getVariable ["RB_FugitiveActive", false];
private _isFugitive = false;

private _name = name _civ;

// Only assign fugitive if not already active, name valid, and chance triggers
if (!_fugitiveActive && _fugitiveName != "UNKNOWN" && {random 1 < 0.1}) then {
    _name = _fugitiveName;
    _civ setName _fugitiveName;                   // <-- This sets the engine's visible name (over the head, in interactions, etc.)
    missionNamespace setVariable ["RB_FugitiveActive", true, true];
    _civ setVariable ["rb_isFugitive", true, true];
    _isFugitive = true;
} else {
    _civ setVariable ["rb_isFugitive", false, true];
};


// === Standard civilian data assignment
sleep 0.1;
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

// Assign final identity (uses _name, which could be the fugitive)
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

// === STORY GENERATION (Phase 1)
private _isIllegal = (_isFugitive || count _contraband > 0 || _originName in (missionNamespace getVariable ["RB_BannedTowns", []]));

// Gather towns - Always needed for Permit generation below
private _allTownLocations = nearestLocations [getPos _civ, ["NameCityCapital", "NameCity", "NameVillage"], 10000];
private _allTownNames = _allTownLocations apply { text _x };
private _bannedTowns = missionNamespace getVariable ["RB_BannedTowns", []];
private _safeTowns = _allTownNames - _bannedTowns;
if (_safeTowns isEqualTo []) then { _safeTowns = ["Le Port"]; }; 

// Check if we can inherit a story from the vehicle
private _vehicle = _civ getVariable ["rb_vehicle", objNull];
private _masterStory = if (!isNull _vehicle) then { _vehicle getVariable ["rb_master_story", []] } else { [] };

private _purpose = "";
private _claimedOrigin = "";
private _claimedDestination = "";
private _isLying = false;
private _realTripOrigin = "";
private _realTripDestination = "";

if (_masterStory isNotEqualTo []) then {
    // Inherit from vehicle
    _masterStory params ["_mClaimedOrigin", "_mClaimedDest", "_mPurpose", "_mIsLying", "_mRealOrigin", "_mRealDest"];
    _purpose = _mPurpose;
    _claimedOrigin = _mClaimedOrigin;
    _claimedDestination = _mClaimedDest;
    _isLying = _mIsLying;
    _realTripOrigin = _mRealOrigin;
    _realTripDestination = _mRealDest;
} else {
    // Generate New Story
    private _purposes = missionNamespace getVariable ["RB_StoryPurposes", ["Visiting Family", "Work"]];

    // === CONTEXT ANALYSIS
    private _vehType = if (!isNull _vehicle) then { toLower (typeOf _vehicle) } else { "" };

    private _isNight = (daytime < 5 || daytime > 20);
    private _isRain  = (rain > 0.2 || overcast > 0.7);

    // Simplified Commercial Check (Optional, mainly for fluff now)
    private _isCommercial = (
        (_vehType find "truck" > -1) || 
        (_vehType find "van" > -1) || 
        (_vehType find "box" > -1)
    );

    // Filter Purposes based on Context (for Innocent / Smart Liars)
    private _validPurposes = +_purposes; // Copy all purposes (Delivery/Medical included for everyone now)

    // Only filter logically impossible things for INNOCENTS
    if (_isNight) then { _validPurposes = _validPurposes - ["Going to the Beach", "Tourism", "Shopping"]; };
    if (_isRain) then { _validPurposes = _validPurposes - ["Going to the Beach", "Tourism"]; };
    
    // Safety fallback
    if (_validPurposes isEqualTo []) then { _validPurposes = ["Visiting Family", "Heading Home"]; };

    // Selection Logic
    if (_isIllegal) then {
        // Increased chance to Lie about Purpose (Context Mismatch)
        if (random 1 < 0.7) then {
            private _badPurposes = _purposes - _validPurposes;
            // If no "bad" purposes exist (e.g. daytime), pick random to potentially mismatch evidence
            _purpose = if (_badPurposes isNotEqualTo []) then { selectRandom _badPurposes } else { selectRandom _purposes };
            _isLying = true;
        } else {
            _purpose = selectRandom _validPurposes;
        };
    } else {
        _purpose = selectRandom _validPurposes;
    };

    if (_purpose in ["Heading Home", "Returning from Work"]) then {
        _realTripDestination = _originName;
        private _possibleOrigins = _allTownNames - [_originName];
        if (_possibleOrigins isEqualTo []) then { _possibleOrigins = ["Unknown"]; };
        _realTripOrigin = selectRandom _possibleOrigins;
    } else {
        _realTripOrigin = _originName;
        private _possibleDests = _safeTowns - [_originName];
        if (_possibleDests isEqualTo []) then { _possibleDests = ["Le Port"]; };
        _realTripDestination = selectRandom _possibleDests;
    };

    _claimedOrigin = _realTripOrigin;
    _claimedDestination = _realTripDestination;

    if (_isIllegal) then {
        if ((_realTripOrigin in _bannedTowns) && {random 1 < 0.8}) then { _claimedOrigin = selectRandom _safeTowns; _isLying = true; };
        if ((_realTripDestination in _bannedTowns) && {random 1 < 0.8}) then { _claimedDestination = selectRandom _safeTowns; _isLying = true; };
        if (!_isLying && {random 1 < 0.3}) then { _claimedOrigin = selectRandom _safeTowns; _isLying = true; };
    };

    // Cache on vehicle if present
    if (!isNull _vehicle) then {
        _vehicle setVariable ["rb_master_story", [_claimedOrigin, _claimedDestination, _purpose, _isLying, _realTripOrigin, _realTripDestination], true];
    };
};

_civ setVariable ["rb_civ_story", [_claimedOrigin, _claimedDestination, _purpose, _isLying, _realTripOrigin, _realTripDestination], true];

// === TRAVEL PERMIT GENERATION
private _hasPermit = true;
private _permOrigin = _claimedOrigin;
private _permDest   = _claimedDestination;

// Date Math: Get current timestamp (0..1)
private _nowVal = dateToNumber date;
private _dayStep = 1 / 365; // Approx value of one day in number format
private _expiryVal = _nowVal + (_dayStep * (1 + random 30)); // Default valid (1-30 days future)

if (_isIllegal) then {
    private _permitAction = selectRandomWeighted [
        "valid", 0.3,    // Matches Story (Forged or Real)
        "missing", 0.3,  // No Permit
        "mismatch", 0.3, // Contradicts Story
        "expired", 0.1   // Expired
    ];

    switch (_permitAction) do {
        case "missing": { _hasPermit = false; };
        case "mismatch": {
            if (random 1 < 0.5) then {
                _permOrigin = _realTripOrigin; // Matches Real (Banned) Origin
                _permDest   = _realTripDestination;
            } else {
                _permOrigin = selectRandom _safeTowns;
                _permDest   = selectRandom _safeTowns;
            };
        };
        case "expired": {
            _expiryVal = _nowVal - (_dayStep * (1 + random 20)); // Past
        };
    };
} else {
    // Innocent: Small chance of negligence
    if (random 1 < 0.05) then {
        if (random 1 < 0.5) then { _hasPermit = false; } 
        else { _expiryVal = _nowVal - (_dayStep * (1 + random 20)); };
    };
};

if (_hasPermit) then {
    // 10% Chance of "All Region Pass"
    if (random 1 < 0.1) then {
        _permOrigin = "ALL";
        _permDest   = "ALL";
    };
    
    private _expiryDate = numberToDate [date select 0, _expiryVal];
    // Format Date String DD/MM/YYYY
    private _dateStr = format ["%1/%2/%3", _expiryDate#2, _expiryDate#1, _expiryDate#0];
    
    _civ setVariable ["rb_travel_permit", [_permOrigin, _permDest, _dateStr, _expiryVal], true];
} else {
    _civ setVariable ["rb_travel_permit", [], true];
};

// === EVIDENCE ASSIGNMENT
// If they are NOT lying, they must have the physical proof of their story.
// If they ARE lying, they will have random junk or nothing at all.
if (!_isLying) then {
    private _evidenceMap = missionNamespace getVariable ["RB_EvidenceItems", createHashMap];
    private _requiredItems = _evidenceMap getOrDefault [_purpose, []];
    
    if (_requiredItems isNotEqualTo []) then {
        // Give them 1-3 descriptive items
        private _count = 1 + (floor random 3);
        private _selected = [];
        for "_i" from 1 to _count do { _selected pushBackUnique (selectRandom _requiredItems); };
        
        if (!isNull _vehicle) then {
            private _vehItems = _vehicle getVariable ["veh_items", []];
            _vehItems append _selected;
            _vehicle setVariable ["veh_items", _vehItems, true];
        } else {
            private _civItems = _civ getVariable ["rb_miscItems", []];
            _civItems append _selected;
            _civ setVariable ["rb_miscItems", _civItems, true];
        };
    };
} else {
    // Liar: Give them "Junk" items that don't help their story
    private _junk = [
        "Empty Food Wrappers", "Crinkled Maps", "Old Newspaper", "Spare Tire (Worn)", 
        "Rusty Tool", "Empty Soda Cans", "Tattered Blanket", "Broken Flashlight"
    ];
    if (random 1 < 0.5) then {
        private _count = 1 + (floor random 2);
        private _selected = [];
        for "_i" from 1 to _count do { _selected pushBackUnique (selectRandom _junk); };
        
        if (!isNull _vehicle) then {
            private _vehItems = _vehicle getVariable ["veh_items", []];
            _vehItems append _selected;
            _vehicle setVariable ["veh_items", _vehItems, true];
        } else {
            private _civItems = _civ getVariable ["rb_miscItems", []];
            _civItems append _selected;
            _civ setVariable ["rb_miscItems", _civItems, true];
        };
    };
};
