/*
    File: runDynamicWeather.sqf
    Description: Continuously changes weather over time with smooth transitions.
*/

if (!isServer) exitWith {};

while { true } do {
    // === Randomized target weather state
    private _targetOvercast   = random 1;                  // 0 (clear) to 1 (storm)
    private _targetRain       = if (_targetOvercast > 0.3) then { random (_targetOvercast min 0.8) } else { 0 };
    private _targetFog        = [random 0.4, 0.05, 50 + random 50];  // density, decay, base height
    private _targetLightning  = if (_targetRain > 0.6) then { random 1 } else { 0 };
    private _windX            = random 1;
    private _windY            = random 1;

    private _transitionTime = 600 + random 300; // 10–15 min

    // === Apply smooth weather transition
    _transitionTime setOvercast _targetOvercast;
    _transitionTime setRain _targetRain;
    _transitionTime setFog _targetFog;
    _transitionTime setLightnings _targetLightning;
    setWind [_windX, _windY];

    // Force transition application
    skipTime 0;

    diag_log format ["[RB] New weather cycle: Overcast=%.2f Rain=%.2f Fog=%.2f Lightning=%.2f Wind=[%.2f, %.2f]",
        _targetOvercast, _targetRain, _targetFog#0, _targetLightning, _windX, _windY
    ];

    // Wait until this cycle finishes before picking new weather
    sleep _transitionTime;
};
