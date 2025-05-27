params ["_cost"];
if (!isServer) exitWith {};

// fetch current score
private _score    = RB_Terminal getVariable ["rb_score", 0];

// subtract cost (allow negatives)
private _newScore = _score - _cost;

// write it back
RB_Terminal setVariable ["rb_score", _newScore, true];
