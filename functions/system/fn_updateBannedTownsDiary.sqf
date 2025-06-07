// functions\utility\fn_updateBannedTownsDiary.sqf
params ["_bannedTowns"];
private _subjectID = "RB_Lockdown";
private _subjectName = "Lockdown Locations";
private _recordTitle = "Restricted Towns";

// Clear and recreate the subject to remove any old entries
player removeDiarySubject _subjectID;
player createDiarySubject [_subjectID, _subjectName];

// Build the diary text
private _bannedList = _bannedTowns joinString "<br/>• ";
private _text = format [
    "<t size='1.2' font='PuristaBold'>The following towns are currently restricted:</t><br/><br/>• %1",
    _bannedList
];

// Add the single updated record
player createDiaryRecord [_subjectID, [_recordTitle, _text]];
