/*
    File: fn_updateMapDate.sqf
    Description: Updates a map marker with the current mission date in DD/MM/YYYY format.
    Triggered when the player opens the map.
*/

if (!hasInterface) exitWith {};

private _markerName = "RB_MapDateMarker";
// Lowered Y coordinate by 200m from worldSize to move it down from the absolute edge
private _pos = [100, worldSize - 200, 0];

// Create marker if it doesn't exist
if (getMarkerColor _markerName == "") then {
    createMarkerLocal [_markerName, _pos];
    _markerName setMarkerShapeLocal "ICON";
    _markerName setMarkerTypeLocal "mil_dot";
};

// Update color and text (ColorBlack will make the text black)
_markerName setMarkerColorLocal "ColorBlack";

// Format Date DD/MM/YYYY
private _d = date;
private _dateStr = format ["%1/%2/%3", _d select 2, _d select 1, _d select 0];

_markerName setMarkerTextLocal format [" Current Date: %1", _dateStr];