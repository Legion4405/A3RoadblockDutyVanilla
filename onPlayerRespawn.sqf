// this runs _locally_ on the machine that just respawned
params ["_unit"];
// fetch the cost
private _cost = ["RB_RespawnCost", 10] call BIS_fnc_getParamValue;
// ask server to deduct it
[_cost] remoteExecCall ["RB_fnc_deductRespawnCost", 2];\
hint "Deducting pointies";
