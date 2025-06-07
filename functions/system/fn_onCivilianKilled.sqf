/*
    File: fn_onCivilianKilled.sqf
    Description: Handles scoring when a civilian or enemy is killed.
*/

params ["_unit", "_killer"];

// === Validate input
if (isNull _unit || {isNull _killer}) exitWith {};
if (!isPlayer _killer) exitWith {};
if (isPlayer _unit) exitWith {}; // Ignore team kills

private _wasCivilian = _unit getVariable ["rb_isCivilian", false];
private _isEnemy     = (side group _unit == east);

// === Civilian kill check
if (_wasCivilian) then {
    // Skip disguised enemies
    if (_unit getVariable ["rb_isEnemyDisguised", false]) then { 
        // Do not continue to OPFOR handling either
    } else {
        private _isHostile = _unit getVariable ["rb_isHostile", false];
        private _scoreDelta = if (_isHostile) then { 5 } else { -10 };

        private _score = RB_Terminal getVariable ["rb_score", 0];
        private _newScore = _score + _scoreDelta;
        RB_Terminal setVariable ["rb_score", _newScore, true];

        private _color = if (_scoreDelta >= 0) then {"#00ff00"} else {"#ff0000"};
        private _msg = format [
            "<t size='1.25' font='PuristaBold' color='%1'>Civilian Killed</t><br/>%2: %3<br/><br/><t size='1' font='PuristaMedium' color='#cccccc'>Total Score: %4</t>",
            _color,
            name _unit,
            if (_scoreDelta > 0) then {"✅ +5 (Hostile)"} else {"❌ -10 (Innocent)"},
            _newScore
        ];
        [_msg, 4] remoteExec ["ace_common_fnc_displayTextStructured", 0];
    };
};

// === Enemy (OPFOR) kill reward
if (!_wasCivilian && _isEnemy) then {
    private _score = RB_Terminal getVariable ["rb_score", 0];
    RB_Terminal setVariable ["rb_score", _score + 1, true];
};
