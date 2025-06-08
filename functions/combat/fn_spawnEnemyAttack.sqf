/*
    File: spawnEnemyAttack.sqf
    Description: Spawns a group of enemies at a random spawn marker and sends them to attack the checkpoint using waypoints.
                 Occasionally spawns a small 'infiltrator' group instead of the main attack group.
*/

if (!isServer) exitWith {};

// === Find all available enemy spawn markers
private _spawnMarkers = [];
private _i = 1;
while {true} do {
    private _markerName = format ["RB_EnemySpawn_%1", _i];
    if (getMarkerPos _markerName isEqualTo [0,0,0]) exitWith {};
    _spawnMarkers pushBack _markerName;
    _i = _i + 1;
};
if (_spawnMarkers isEqualTo []) exitWith { diag_log "[RB] No enemy spawn markers found!"; };

private _checkpoint = getMarkerPos "RB_Checkpoint";
if (_checkpoint isEqualTo [0,0,0]) exitWith { diag_log "[RB] RB_Checkpoint marker not found!"; };

private _enemyTypes = missionNamespace getVariable ["RB_EnemyInfantryPool", ["O_Soldier_F"]];
private _playerCount = count allPlayers;
private _groupSize = (2 + floor random 3) + (2 * _playerCount); // 3–5 base + 2 per player

// === Decide attack type: Infiltrator or Main Group (e.g., 25% chance infiltrator)
private _attackType = if (random 1 < 0.15) then {"infiltrator"} else {"main"};

if (_attackType == "main") then {
    // Main Attack Group
    private _mainMarker = selectRandom _spawnMarkers;
    private _mainPos = getMarkerPos _mainMarker;

    private _grp = createGroup east;
    for "_i" from 1 to _groupSize do {
        private _unitClass = selectRandom _enemyTypes;
        _grp createUnit [_unitClass, _mainPos, [], 5, "FORM"];
    };

    _grp setBehaviour "COMBAT";
    _grp setCombatMode "RED";

    // Main group waypoint
    private _wp = _grp addWaypoint [_checkpoint, 0];
    _wp setWaypointType "SAD";         // Seek and destroy
    _wp setWaypointBehaviour "COMBAT";
    _wp setWaypointCombatMode "RED";
    _wp setWaypointCompletionRadius 20; // Normal value

    diag_log format [
        "[RB] Main enemy attack spawned: %1 units at %2.",
        _groupSize, _mainMarker
    ];

} else {
    // Infiltrator Group
    private _infMarker = selectRandom _spawnMarkers;
    private _infPos = getMarkerPos _infMarker;
    private _infilGrp = createGroup east;
    for "_j" from 1 to 4 do {
        private _unitClass = selectRandom _enemyTypes;
        private _unit = _infilGrp createUnit [_unitClass, _infPos, [], 5, "FORM"];
        _unit setSkill 0.7;
    };

    _infilGrp setBehaviourStrong "STEALTH"; // Do not fire unless fired upon

    // First waypoint: approach in stealth/yellow
    private _infWp1 = _infilGrp addWaypoint [_checkpoint, 0];
    _infWp1 setWaypointType "MOVE";
    _infWp1 setWaypointBehaviour "STEALTH";
    _infWp1 setWaypointCombatMode "WHITE";
    _infWp1 setWaypointCompletionRadius 50;

    // Second waypoint: open fire after reaching checkpoint
    private _infWp2 = _infilGrp addWaypoint [_checkpoint, 0];
    _infWp2 setWaypointType "SAD";
    _infWp2 setWaypointBehaviour "COMBAT";
    _infWp2 setWaypointCombatMode "RED";
    _infWp2 setWaypointCompletionRadius 30;

    // When the group completes waypoint 1, change to RED combat mode
    _infWp1 setWaypointStatements [
        "group this setCombatMode 'RED';",
        ""
    ];


    diag_log format [
        "[RB] Infiltrator group spawned at %1.",
        _infMarker
    ];
};
