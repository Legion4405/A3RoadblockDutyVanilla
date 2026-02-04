/*
    File: fn_toggleDiagnostics.sqf
    Description: Toggles a server-side loop that updates map markers with mission diagnostics.
    Params: [_enable (bool)]
*/

params ["_enable"];
if (!isServer) exitWith {};

if (!_enable) then {
    if (!isNil "RB_DiagnosticsHandle") then {
        terminate RB_DiagnosticsHandle;
        RB_DiagnosticsHandle = nil;
    };
    { deleteMarker _x; } forEach ["RB_Diag_FPS", "RB_Diag_Civs", "RB_Diag_Enemies", "RB_Diag_Spawner"];
    ["<t color='#ff0000'>Diagnostics Disabled</t>", 3] remoteExec ["ace_common_fnc_displayTextStructured", 0];
} else {
    if (!isNil "RB_DiagnosticsHandle") exitWith {}; // Already running

    ["<t color='#00ff00'>Diagnostics Enabled (Check Map Bottom Left)</t>", 5] remoteExec ["ace_common_fnc_displayTextStructured", 0];

    RB_DiagnosticsHandle = [] spawn {
        // Init Markers
        private _markers = ["RB_Diag_FPS", "RB_Diag_Civs", "RB_Diag_Enemies", "RB_Diag_Spawner"];
        private _startPos = [1000, 1000]; 
        
        {
            if (getMarkerPos _x isEqualTo [0,0,0]) then {
                createMarker [_x, [(_startPos#0), (_startPos#1) - (_forEachIndex * 150)]];
                _x setMarkerType "mil_dot";
                _x setMarkerColor "ColorWhite";
            };
        } forEach _markers;

        while {true} do {
            // 1. Server FPS
            private _fps = diag_fps;
            "RB_Diag_FPS" setMarkerText format ["Server FPS: %1", round _fps];
            "RB_Diag_FPS" setMarkerColor (if (_fps > 40) then {"ColorGreen"} else {if (_fps > 20) then {"ColorYellow"} else {"ColorRed"}});

            // 2. Entity Counts
            private _civs = {side _x == civilian && alive _x} count allUnits;
            private _vehs = {alive _x && (_x isKindOf "LandVehicle")} count vehicles;
            "RB_Diag_Civs" setMarkerText format ["Civilians: %1 | Vehicles: %2", _civs, _vehs];

            // 3. Enemies
            private _enemies = {side _x == east && alive _x} count allUnits;
            "RB_Diag_Enemies" setMarkerText format ["Active Enemies: %1", _enemies];
            "RB_Diag_Enemies" setMarkerColor (if (_enemies == 0) then {"ColorGreen"} else {"ColorRed"});

            // 4. Spawner State
            private _spawnerState = if (missionNamespace getVariable ["RB_SpawnerRunning", false]) then {"RUNNING"} else {"IDLE"};
            private _cur = missionNamespace getVariable ["RB_CurrentEntity", objNull];
            private _curStatus = if (isNull _cur) then {"NONE"} else { if (alive _cur) then {"OCCUPIED"} else {"DEAD/WRECK"} };
            
            "RB_Diag_Spawner" setMarkerText format ["Traffic: %1 | Checkpoint: %2", _spawnerState, _curStatus];

            sleep 2;
        };
    };
};
