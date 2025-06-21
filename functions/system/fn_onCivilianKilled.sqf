/*
    File: fn_onCivilianKilled.sqf
    Description: Handles scoring when a civilian or enemy is killed using RB_ScoringTableMap.
*/

params ["_unit", "_killer"];

// === Validate input
if (isNull _unit || {isNull _killer}) exitWith {};
if (!isPlayer _killer) exitWith {};
if (isPlayer _unit) exitWith {}; // Ignore team kills

private _wasCivilian = _unit getVariable ["rb_isCivilian", false];
private _isEnemy     = (side group _unit == east);

private _scoreMap = missionNamespace getVariable ["RB_ScoringTableMap", createHashMap];

// === Civilian kill check
if (_wasCivilian) then {
    // Skip disguised enemies (no scoring, no penalty)
    if (_unit getVariable ["rb_isEnemyDisguised", false]) exitWith {};

    private _isHostile = _unit getVariable ["rb_isHostile", false];
    private _scoreKey = if (_isHostile) then {"hostile"} else {"innocent_civilian_killed"};
    private _scoreDelta = _scoreMap getOrDefault [_scoreKey, 0];
    private _desc = _scoreMap getOrDefault [_scoreKey, "Civilian Killed"];

    private _score = RB_Terminal getVariable ["rb_score", 0];
    private _newScore = _score + _scoreDelta;
    RB_Terminal setVariable ["rb_score", _newScore, true];

    private _color = if (_scoreDelta >= 0) then {"#00ff00"} else {"#ff0000"};
    private _msg = format [
        "<t size='1.25' font='PuristaBold' color='%1'>Civilian Killed</t><br/>%2: %3<br/><br/><t size='1' font='PuristaMedium' color='#cccccc'>Total Score: %4</t>",
        _color,
        name _unit,
        format ["%1 (%2%3)", _desc, if (_scoreDelta >= 0) then {"+"} else {""}, str _scoreDelta],
        _newScore
    ];
    [_msg, 4] remoteExec ["ace_common_fnc_displayTextStructured", 0];
};

// === Enemy (OPFOR) kill reward
if (!_wasCivilian && _isEnemy) then {
    private _scoreKey = "enemy_killed";
    private _scoreDelta = _scoreMap getOrDefault [_scoreKey, 0];
    private _desc = _scoreMap getOrDefault [_scoreKey, "Enemy Killed"];

    private _score = RB_Terminal getVariable ["rb_score", 0];
    private _newScore = _score + _scoreDelta;
    RB_Terminal setVariable ["rb_score", _newScore, true];

    // Optional: show notification (uncomment if you want a popup)
    /*
    private _color = if (_scoreDelta >= 0) then {"#00ff00"} else {"#ff0000"};
    private _msg = format [
        "<t size='1.25' font='PuristaBold' color='%1'>Enemy Killed</t><br/>%2<br/><br/><t size='1' font='PuristaMedium' color='#cccccc'>Total Score: %3</t>",
        _color,
        format ["%1 (%2%3)", _desc, if (_scoreDelta >= 0) then {"+"} else {""}, str _scoreDelta],
        _newScore
    ];
    [_msg, 2] remoteExec ["ace_common_fnc_displayTextStructured", 0];
    */
};
