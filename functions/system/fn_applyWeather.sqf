// File: functions\system\fn_applyWeather.sqf
params ["_overcast", "_rain", "_fog", "_lightning", "_windX", "_windY", "_transitionTime"];
_transitionTime setOvercast _overcast;
_transitionTime setRain _rain;
_transitionTime setFog _fog;
_transitionTime setLightnings _lightning;
setWind [_windX, _windY];
skipTime 0; // Force immediate update for visuals
