/*
    File: fn_ambientCallToPrayer.sqf
    Desc: Plays a 3D "call to prayer" at a mosque, repeats on a random interval.
          Single emitter (no stacking). MP-safe via remoteExecCall.

    Params:
      0: STRING  - marker name (default "RB_Mosque")
      1: STRING  - CfgSounds class (default "RB_Adhan_Call")
      2: NUMBER  - min delay seconds (default 600 = 10 min)
      3: NUMBER  - max delay seconds (default 1800 = 30 min)
      4: NUMBER  - height AGL in meters to place emitter (default 20)
      5: BOOL    - use playSound3D instead of say3D (default false)
      6: NUMBER  - playSound3D distance (default 5000)  [PS3D only]
      7: NUMBER  - playSound3D volume (default 3)       [PS3D only, linear]
      8: NUMBER  - say3D maxDistance (default 12000)    [say3D only]
      9: NUMBER  - say3D pitch (default 1)              [say3D only]
     10: NUMBER  - say3D isSpeech (default 2)           [0/false=sound, 1/true=speech, 2=sound no interior muffling]
     11: NUMBER  - say3D offset (default 0)
     12: BOOL    - say3D simulateSpeedOfSound (default false)
     13: BOOL    - startAfterDelay (default true)       [wait random delay before first play]
*/

if (!isServer) exitWith {};

params [
    ["_markerName", "RB_Mosque"],
    ["_soundClass", "RB_Adhan_Call"],
    ["_minDelay", 800],
    ["_maxDelay", 2000],
    ["_heightAGL", 20],
    ["_usePS3D", false],
    ["_ps3dDistance", 1700],
    ["_ps3dVolume", 3],
    ["_say3dDistance", 1700],
    ["_say3dPitch", 1],
    ["_say3dIsSpeech", 2],
    ["_say3dOffset", 0],
    ["_say3dSpeedOfSound", false],
    ["_startAfterDelay", true]
];

// Resolve mosque position
private _posATL = getMarkerPos _markerName;
if (_posATL isEqualTo [0,0,0]) exitWith {
    systemChat format ["[RB] CallToPrayer: marker '%1' not found.", _markerName];
};

// Place emitter once (global, no stacking)
private _key = format ["RB_Adhan_Emitter_%1", _markerName];
private _emitter = missionNamespace getVariable [_key, objNull];

if (isNull _emitter) then {
    _emitter = createVehicle ["Land_HelipadEmpty_F", _posATL, [], 0, "NONE"];
    _emitter enableSimulationGlobal false;
    _emitter allowDamage false;

    private _atl = getPosATL _emitter;
    _emitter setPosATL [_atl select 0, _atl select 1, (_atl select 2) + _heightAGL];

    missionNamespace setVariable [_key, _emitter, true];
};

// Pull path once for PS3D
private _soundPath = getArray (missionConfigFile >> "CfgSounds" >> _soundClass >> "sound") param [0, ""];

// Helpers
private _playSay3D = {
    params [
        ["_obj", objNull, [objNull]],
        ["_soundClass", "", [""]],
        ["_maxDistance", 12000],
        ["_pitch", 1],
        ["_isSpeech", 2],
        ["_offset", 0],
        ["_simulateSpeedOfSound", false]
    ];
    if (isNull _obj || {_soundClass isEqualTo ""}) exitWith {};
    [_obj, [_soundClass, _maxDistance, _pitch, _isSpeech, _offset, _simulateSpeedOfSound]]
        remoteExecCall ["say3D", 0];
};

private _playPS3D = {
    params ["_obj", "_path", "_vol", "_dist"];
    if (isNull _obj || {_path isEqualTo ""}) exitWith {};
    private _posASL = getPosASL _obj;
    // [path, object, isInside, posASL, volume, pitch, distance]
    [ _path, objNull, false, _posASL, _vol, 1, _dist ] remoteExecCall ["playSound3D", 0];
};

private _ensureEmitter = {
    if (isNull _emitter) then {
        _emitter = createVehicle ["Land_HelipadEmpty_F", _posATL, [], 0, "NONE"];
        _emitter enableSimulationGlobal false;
        _emitter allowDamage false;
        private _atl = getPosATL _emitter;
        _emitter setPosATL [_atl select 0, _atl select 1, (_atl select 2) + _heightAGL];
        missionNamespace setVariable [_key, _emitter, true];
    };
};

private _playOnce = {
    call _ensureEmitter;
    if (_usePS3D) then {
        [_emitter, _soundPath, _ps3dVolume, _ps3dDistance] call _playPS3D;
    } else {
        [_emitter, _soundClass, _say3dDistance, _say3dPitch, _say3dIsSpeech, _say3dOffset, _say3dSpeedOfSound] call _playSay3D;
    };
};

// Wait before the very first play (if requested)
if (_startAfterDelay) then {
    private _first = _minDelay + random (_maxDelay - _minDelay);
    sleep _first;
};

// First play
call _playOnce;

// Repeat forever
while {true} do {
    private _delay = _minDelay + random (_maxDelay - _minDelay);
    sleep _delay;
    call _playOnce;
};
