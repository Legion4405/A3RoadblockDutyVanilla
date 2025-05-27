/*
    File: fn_updateBannedTowns.sqf
    Description: Selects 3–5 random banned towns, updates map markers and player briefings.
*/

if (!isServer) exitWith {};

// === Step 1: 30-second warning
"Restricted zones will update in 10 seconds." call CBA_fnc_notify;

sleep 10;

// === Step 2: Gather all towns
private _allTowns = nearestLocations [
    [worldSize / 2, worldSize / 2, 0],
    ["NameCityCapital", "NameCity", "NameVillage"],
    worldSize
];

// === Step 3: Shuffle and select 3–5 random town names
private _townNames = _allTowns apply { text _x };
_townNames = _townNames call BIS_fnc_arrayShuffle;

private _count = 3 + floor random 3;
private _bannedTowns = _townNames select [0, _count];

missionNamespace setVariable ["RB_BannedTowns", _bannedTowns, true];
diag_log format ["[RB] Updated Banned Towns: %1", _bannedTowns];

// === Step 4: Remove old banned town markers only
{
    if ((count _x) >= 14 && { _x select [0,14] == "RB_BannedTown_" }) then {
        deleteMarker _x;
    };
} forEach allMapMarkers;


// === Step 5: Create new markers
{
    private _name = text _x;
    if (_name in _bannedTowns) then {
        private _markerName = format ["RB_BannedTown_%1", _forEachIndex];
        private _pos = position _x;
        private _size = size _x;
        private _finalSize = [_size#0 + 100, _size#1 + 100];

        private _marker = createMarker [_markerName, _pos];
        _marker setMarkerShape "ELLIPSE";
        _marker setMarkerType "";
        _marker setMarkerColor "ColorOrange";
        _marker setMarkerBrush "SolidBorder";
        _marker setMarkerSize _finalSize;
        _marker setMarkerText format ["⚠ Restricted Area: %1", _name];
    };
} forEach _allTowns;

// === Step 6: Update diary under a fresh subject "Lockdown Locations"
["RB_BannedTowns_UpdateDiary", {
    private _subjectID = "RB_Lockdown";
    private _subjectName = "Lockdown Locations";
    private _recordTitle = "Restricted Towns";

    // Clear and recreate the subject to remove any old entries
    player removeDiarySubject _subjectID;
    player createDiarySubject [_subjectID, _subjectName];

    // Build the diary text
    private _bannedList = (missionNamespace getVariable ["RB_BannedTowns", []]) joinString "<br/>• ";
    private _text = format [
        "<t size='1.2' font='PuristaBold'>The following towns are currently restricted:</t><br/><br/>• %1",
        _bannedList
    ];

    // Add the single updated record
    player createDiaryRecord [_subjectID, [_recordTitle, _text]];
}] remoteExec ["call", 0];
