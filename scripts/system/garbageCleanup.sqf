/*
  File: fn_garbageCleanup.sqf
  Description: Periodically deletes dead bodies, vehicle wrecks, and dropped weapons,
               but skips persistent logistics assets.
*/

params ["_interval"];
if (isNil "_interval") then { _interval = 600; };

while { true } do {
    sleep _interval;

    // 1) Dead bodies
    {
        deleteVehicle _x;
    } forEach allDeadMen;

    // 2) Vehicle wrecks (crewless & >50% damage, and not persistent logi)
    private _vehArr = vehicles;
    private _vehCount = count _vehArr;
    for "_i" from 0 to (_vehCount - 1) do {
        private _veh = _vehArr select _i;
        if (
            (damage _veh > 0.5) &&
            {count (crew _veh select { alive _x }) == 0} &&
            {!(_veh getVariable ["rb_isPersistentLogi", false])}
        ) then {
            deleteVehicle _veh;
        };
    };

    // 3) Dropped weapons on the ground
    private _weapons = allMissionObjects "WeaponHolder";
    private _wCnt = count _weapons;
    for "_j" from 0 to (_wCnt - 1) do {
        deleteVehicle (_weapons select _j);
    };
};
