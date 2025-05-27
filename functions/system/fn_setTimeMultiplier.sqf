/*
    File: fn_setTimeMultiplier.sqf
    Description: Sets the global time acceleration multiplier.
*/
params ["_multiplier"];

if (!isServer) exitWith {};
setTimeMultiplier _multiplier;

diag_log format ["[RB] Time multiplier set to %1x", _multiplier];
