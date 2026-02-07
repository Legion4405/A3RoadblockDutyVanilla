params ["_civilian"];

// Set processed flag globally
_civilian setVariable ["rb_isProcessed", true, true];

// Allow movement and unassign vehicle
unassignVehicle _civilian;
[_civilian] allowGetIn false;
_civilian enableAI "MOVE";
_civilian enableAI "PATH";
_civilian stop false;
doStop _civilian;

// Move to processing marker
private _dest = getMarkerPos "RB_ProcessPoint";
if (_dest isEqualTo [0,0,0]) exitWith {
    diag_log "[RB] ERROR: Marker 'RB_ProcessPoint' does not exist.";
};

_civilian setSpeedMode "LIMITED";
_civilian setBehaviour "CARELESS";
_civilian doMove _dest;

// systemChat format ["Civilian %1 marked as processed.", name _civilian];
