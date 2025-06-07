// File: functions\utility\fn_getStarterLoadout.sqf
// Usage: [optionalFactionIndex] call RB_fnc_getStarterLoadout
params [["_faction", ["RB_LogisticsFaction", 0] call BIS_fnc_getParamValue]];
waitUntil { !isNil "paramsArray" };

switch (_faction) do {
    case 0: { RB_StarterLoadout_Custom };
    case 1: { RB_StarterLoadout_NATO };
    case 2: { RB_StarterLoadout_APEX_Gendarmerie };
    case 3: { RB_StarterLoadout_CDLC_UNA };
    default { RB_StarterLoadout_NATO };
};
