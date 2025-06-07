// File: initPlayerLocal.sqf
// Runs for every client, including JIP, after mission start

// --- 1. Wait for arsenal unlocks to be set by the server
waitUntil { !isNil "RB_ArsenalUnlocks" };

// --- 2. Wait for contraband pool to be set by the server and show diary
waitUntil { !isNil "RB_ActiveContraband" };
private _list = RB_ActiveContraband joinString "<br/>• ";
private _text = format [
    "<t size='1.2' font='PuristaBold'>The following items are considered illegal:</t><br/><br/>• %1",
    _list
];
player createDiarySubject ["RB_Roadblock", "Roadblock Duty"];
player createDiaryRecord ["RB_Roadblock", ["Banned Contraband", _text]];

[] spawn {
    waitUntil { !isNull (missionNamespace getVariable ["RB_PuppyDog", objNull]) };
    private _dog = missionNamespace getVariable ["RB_PuppyDog", objNull];
    [_dog] call RB_fnc_addPuppyActions;
};
