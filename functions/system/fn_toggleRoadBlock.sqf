/*
    File: fn_toggleRoadblock.sqf
    Usage: [true] remoteExec ["RB_fnc_toggleRoadblock", 2]; // Close
           [false] remoteExec ["RB_fnc_toggleRoadblock", 2]; // Open
           [] remoteExec ["RB_fnc_toggleRoadblock", 2]; // Toggle
*/

params [["_closed", nil]];
if (!isServer) exitWith {};

private _cur = missionNamespace getVariable ["RB_RoadblockClosed", false];
private _new = if (!isNil "_closed") then { _closed } else { !_cur };
missionNamespace setVariable ["RB_RoadblockClosed", _new, true];

private _msg   = if (_new) then { "🚧 Roadblock Closed." } else { "✅ Roadblock Opened." };
private _title = "Roadblock Status";
// Optional: Use a custom icon, or "" for none
private _icon  = ""; // e.g. "a3\ui_f\data\map\markers\military\flag_ca.paa"
private _dur   = 6;

// Show notification to all players
[_msg, _title, _icon, _dur] remoteExec ["CBA_fnc_notify", 0];

// Optional: Server log
diag_log format ["[RB] Roadblock state changed to %1", if (_new) then {"CLOSED"} else {"OPEN"}];
