// Initialize Player Local
if (!hasInterface) exitWith {};

// Wait for HC Module and Initialize Commander
[] spawn {
    waitUntil { !isNil "RB_HC_Module" && { !isNull RB_HC_Module } };
    
    // Check if player is marked as commander
    if (player getVariable ["RB_IsCommander", false]) then {
        // Sync player to the HC module
        [RB_HC_Module, [player]] remoteExecCall ["synchronizeObjectsAdd", 2];
        
        // Force local scope immediately
        player setVariable ["BIS_HC_scope", RB_HC_Module];
        
        systemChat "High Command Interface Initialized.";
    };
};

// File: initPlayerLocal.sqf
// Runs for every client, including JIP, after mission start
[] execVM "scripts\system\initTutorial.sqf";
[] execVM "scripts\system\initBriefing.sqf";


// --- 1. Wait for arsenal unlocks to be set by the server
waitUntil { !isNil "RB_ArsenalUnlocks" };

// --- 2. Wait for contraband pool to be set by the server and show diary
waitUntil { !isNil "RB_ActiveContraband" };
private _list = RB_ActiveContraband joinString "<br/>• ";
private _text = format [
    "<t size='1.2' font='PuristaBold'>The following items are considered illegal:</t><br/><br/>• %1",
    _list
];
player createDiarySubject ["RB_Roadblock_Contraband", "Banned Contraband"];
player createDiaryRecord ["RB_Roadblock_Contraband", ["Banned Contraband", _text]];

// --- 3. Update Map Date Marker
addMissionEventHandler ["Map", {
    params ["_mapIsOpened", "_mapIsForced"];
    if (_mapIsOpened) then {
        [] call RB_fnc_updateMapDate;
    };
}];

// Initialize it once at start too
[] spawn {
    sleep 5;
    [] call RB_fnc_updateMapDate;
};
