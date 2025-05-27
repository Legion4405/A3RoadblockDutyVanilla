/*
    File: fn_setWeatherPreset.sqf
    Description: Applies a predefined weather preset and syncs it across clients.
*/
params ["_preset"];

if (!isServer) exitWith {};

switch (_preset) do {
    case "Clear": {
        0 setOvercast 0;
        0 setRain 0;
        0 setFog [0, 0, 0];
        0 setLightnings 0;
    };
    case "Cloudy": {
        0 setOvercast 0.5;
        0 setRain 0;
        0 setFog [0.05, 0.1, 50];
        0 setLightnings 0;
    };
    case "Foggy": {
        0 setOvercast 0.2;
        0 setRain 0;
        0 setFog [0.5, 0.3, 25];
        0 setLightnings 0;
    };
    case "Storm": {
        0 setOvercast 1;
        0 setRain 1;
        0 setFog [0.2, 0.2, 30];
        0 setLightnings 1;
    };
    case "Rain": {
        0 setOvercast 0.8;
        0 setRain 0.6;
        0 setFog [0.1, 0.1, 40];
        0 setLightnings 0;
    };
};

forceWeatherChange;
skipTime 0;

diag_log format ["[RB] Weather preset '%1' applied", _preset];
