// File: init.sqf
// ============================================ 
//                 INIT.SQF
//  Handles configuration, parameters, 
//  save/load, and shared globals.
// ============================================ 

// 1. Compile all config files
call compile preprocessFileLineNumbers "configs\config.sqf";
call compile preprocessFileLineNumbers "configs\enemyFactions.sqf";

call compile preprocessFileLineNumbers "configs\playerFactions\apex_gerndarmerie.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\apex_nato.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\vanilla_nato.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\contact_nato.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\contact_ldf.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\ws_una.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\rhs_usa.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\3cb_british.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\sogpf_us.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\ef_mjtf.sqf";
call compile preprocessFileLineNumbers "configs\playerFactions\gm_west_ger.sqf";

call compile preprocessFileLineNumbers "configs\civilianFactions.sqf";
call compile preprocessFileLineNumbers "configs\customFactions.sqf";
call compile preprocessFileLineNumbers "configs\ambientAirClasses.sqf";

east setFriend [resistance, 1];
resistance setFriend [east, 1];

// 2. SERVER INITIALIZATION
if (isServer) then {
    [] call RB_fnc_initializeMission;
};

// 3. CLIENT BLOCK: WAIT FOR GLOBALS (RB_ArsenalUnlocks + RB_LogisticsFaction) AND APPLY LOADOUT
if (hasInterface) then {
    // 3.1. Wait for server to broadcast RB_ArsenalUnlocks
    waitUntil { !isNil "RB_ArsenalUnlocks" };

    // 3.2. Wait for server to broadcast RB_LogisticsFaction
    waitUntil { !isNil "RB_LogisticsFaction" };

    // 3.3. Wait for starter loadouts to be defined
    waitUntil { !isNil "RB_StarterLoadout_NATO" };

    // 3.4. Now RB_LogisticsFaction is guaranteed to be the saved (or default) index
    private _faction      = RB_LogisticsFaction;
    private _starterLoadout = [_faction] call RB_fnc_getStarterLoadout;
    if (alive player) then {
        player setUnitLoadout _starterLoadout;
        private _friendlyAI = allUnits select {
            (side _x) == west && {!isPlayer _x} && {alive _x}
        };
         {
            _x setUnitLoadout _starterLoadout;
            _x addEventHandler ["Respawn", {
            params ["_newUnit", "_corpse"];
                waitUntil{!isNil "_newUnit"};
                private _fIdx = RB_LogisticsFaction;
                private _ld   = [_fIdx] call RB_fnc_getStarterLoadout;
                _newUnit setUnitLoadout _ld;
            }];
        } forEach _friendlyAI;
    };
};

// 4. CLIENT: APPLY ARSENAL UNLOCKS TO THE ACE BOX (JIP-safe)
if (hasInterface) then {
    [] spawn {
        waitUntil {
            !isNull (missionNamespace getVariable ["RB_Arsenal", objNull]) &&
            {!isNil "RB_ArsenalUnlocks" && { count RB_ArsenalUnlocks > 0 }}
        };

        private _fullUnlocks = RB_ArsenalAlwaysAvailable + RB_ArsenalUnlocks;
        // Deduplicate
        _fullUnlocks = _fullUnlocks arrayIntersect _fullUnlocks;

        private _box = missionNamespace getVariable ["RB_Arsenal", objNull];
        if (!isNull _box) then {
            [_box, _fullUnlocks, true] remoteExec ["ace_arsenal_fnc_addVirtualItems", 0, true];
        };
    };
};

// 5. Set up ACE actions & event handlers
[] spawn {
    waitUntil { !isNull RB_Terminal };
    [ RB_Terminal ] remoteExec ["RB_fnc_addTerminalActions", 0, true];
};

[] spawn {
    waitUntil { !isNull (missionNamespace getVariable ["RB_Generator", objNull]) };
    [] call RB_fnc_addGeneratorActions;
};

addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer"];
    if (!isNull _unit && { _unit isKindOf "CAManBase" } && { isPlayer _killer }) then {
        [_unit, _killer] call RB_fnc_onCivilianKilled;
    };
}];