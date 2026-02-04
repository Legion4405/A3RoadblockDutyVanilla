/*
    File: runDynamicWeather.sqf
    Description: Continuously changes weather over time with smooth transitions.
    Refactored to rely on Arma 3 engine sync for weather, broadcasting only Wind (which is local).
*/

if (!isServer) exitWith {};

while { true } do {
    // === Randomized target weather state
    private _targetOvercast   = random 1;                  // 0 (clear) to 1 (storm)
    private _targetRain       = if (_targetOvercast > 0.3) then { random (_targetOvercast min 0.8) } else { 0 };
    
    // --- Light, rare fog: Only 20% of cycles have any fog, and it's always light
    private _targetFog = if (random 1 > 0.8) then { [random 0.15, 0.03, 80 + random 40] } else { [0, 0.03, 120] };

    private _targetLightning  = if (_targetRain > 0.6) then { random 1 } else { 0 };
    private _windX            = random 1;
    private _windY            = random 1;

    private _transitionTime = 600 + random 300; // 10–15 min

    // === Apply Global Effects on Server (Engine syncs these) ===
    _transitionTime setOvercast _targetOvercast;
    _transitionTime setRain _targetRain;
    _transitionTime setFog _targetFog;
    _transitionTime setLightnings _targetLightning;

    // === Broadcast Wind (Wind is Local) ===
    // We force wind sync via remoteExec. JIP queue ensures joiners get the latest wind.
    [[_windX, _windY], { setWind _this; }] remoteExec ["call", 0, true];

    diag_log format [
        "[RB] New weather cycle: Overcast=%.2f Rain=%.2f Fog=%.2f Lightning=%.2f Wind=[%.2f, %.2f]",
        _targetOvercast, _targetRain, _targetFog#0, _targetLightning, _windX, _windY
    ];

    sleep _transitionTime;
};