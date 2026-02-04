// functions/utility/fn_showNotification.sqf
params ["_text", ["_duration", 5], ["_sound", ""]];

if (!hasInterface) exitWith {};

if (_sound != "") then {
    playSound _sound;
};

// Use ACE styled text if available, otherwise systemChat
if (isClass(configFile >> "CfgPatches" >> "ace_common")) then {
    [_text, _duration] call ace_common_fnc_displayTextStructured;
} else {
    systemChat _text;
};
