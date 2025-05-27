/*
    File: fn_setTimeOfDay.sqf
    Description: Sets the mission time to a specified hour and re-syncs weather.
*/
params ["_hour"];

if (!isServer) exitWith {};

// === Set new date with given hour
private _currentDate = date;
private _newDate = [_currentDate#0, _currentDate#1, _currentDate#2, _hour, 0];
setDate _newDate;

// === Reapply current weather to sync it for all clients
private _overcast  = overcast;
private _rain      = rain;
private _fog       = fogParams;
private _lightnings = lightnings;
private _wind      = wind;

0 setOvercast _overcast;
0 setRain _rain;
0 setFog _fog;
0 setLightnings _lightnings;

forceWeatherChange;


// Apply changes immediately and force sync
skipTime 0;
forceWeatherChange;

diag_log format ["[RB] Time of day set to %1:00 and weather re-synced", _hour];
