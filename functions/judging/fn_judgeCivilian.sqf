/*
    File: fn_judgeCivilian.sqf
    Params: [_civ]
    Returns: [arrestable(bool), [reasons (display)], scoreDelta, statusText]
*/

params ["_civ"];
private _scoringMap = missionNamespace getVariable ["RB_ScoringTableMap", createHashMap];

// Helper to get display text from the scoring map (using keys)
// Ideally we would look up the 3rd element "Display Name" from the array table, 
// but for speed we will assume the key is sufficient or we can improve this later.
// For now, let's rely on validation providing reasons, or map lookup.

private _validation = [_civ] call RB_fnc_validateCivilian;
private _isIllegal  = _validation get "isIllegal";
private _violations = _validation get "violations";
private _isFugitive = _validation get "isFugitive";

private _reasonsDisplay = _validation get "reasons";
private _scoreDelta = 0;
private _statusText = "";
private _arrestable = _isIllegal;

if (_isIllegal) then {
    // Sum up scores for all violations
    {
        private _key = _x;
        // Default to 0 if key missing, to avoid script errors, but ideally all keys exist
        private _pts = _scoringMap getOrDefault [_key, 0]; 
        
        if (_pts == 0) then {
            diag_log format ["[RB] WARNING: Scoring key '%1' not found in RB_ScoringTableMap or value is 0.", _key];
        };
        
        _scoreDelta = _scoreDelta + _pts;
        
    } forEach _violations;

    // Generate new fugitive if we caught one
    if (_isFugitive) then {
        [] call RB_fnc_generateFugitive;
    };

    _statusText = "Arrested: " + (_reasonsDisplay joinString ", ");
    
} else {
    // Innocent Civilian Arrested
    _scoreDelta = _scoringMap getOrDefault ["arrest_innocent", -5];
    _statusText = "Innocent Civilian";
    _reasonsDisplay = ["Innocent"];
};

[_arrestable, _reasonsDisplay, _scoreDelta, _statusText]
