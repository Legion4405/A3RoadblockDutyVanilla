// File: functions\utility\fn_getStarterLoadout.sqf
// Usage: [optionalFactionIndex] call RB_fnc_getStarterLoadout
params [["_faction", ["RB_LogisticsFaction", 0] call BIS_fnc_getParamValue]];
waitUntil { !isNil "paramsArray" };

switch (_faction) do {
    case 0: { RB_StarterLoadout_Custom };
    case 1: { RB_StarterLoadout_NATO };
    case 2: { RB_StarterLoadout_APEX_NATO };
    case 3: { RB_StarterLoadout_Contact_NATO };
    case 4: { RB_StarterLoadout_Contact_LDF };
    case 5: { RB_StarterLoadout_APEX_Gendarmerie };
    case 6: { RB_StarterLoadout_CDLC_UNA };
    case 7: { RB_StarterLoadout_RHS_USA };
    case 8: { RB_StarterLoadout_3CB_BAF };
    case 9: { RB_StarterLoadout_SOGPF_US };
    default { RB_StarterLoadout_NATO };
};
