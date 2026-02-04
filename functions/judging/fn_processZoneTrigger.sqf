// functions/judging/fn_processZoneTrigger.sqf
params ["_list"];

{
    if (isNull _x || {!alive _x}) then { continue; };
    
    // Only process if not already processed
    if !(_x getVariable ["rb_isProcessed", false]) then {
        _x setVariable ["rb_isProcessed", true, true];
        
        private _scoreDelta = 0;
        private _statusText = "";
        private _reasons = [];
        private _name = "";

        // === 1. JUDGE UNIT ===
        if (_x isKindOf "Man") then {
            _name = name _x;
            private _result = [_x] call RB_fnc_judgeCivilian;
            // result: [arrestable, reasons, delta, text]
            _reasons    = _result select 1;
            _scoreDelta = _result select 2;
            _statusText = _result select 3;
            
        } else {
            if (_x isKindOf "LandVehicle") then {
                _name = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
                // Calling judgeVehicle with _isImpound = false (Release)
                private _result = [_x, false] call RB_fnc_judgeVehicle; 
                // result: [illegal, reasons, delta, text]
                _reasons    = _result select 1;
                _scoreDelta = _result select 2;
                _statusText = _result select 3;
            };
        };

        // === 2. APPLY SCORE ===
        if (_scoreDelta != 0 || (count _reasons > 0)) then {
            private _currentScore = RB_Terminal getVariable ["rb_score", 0];
            private _newScore     = _currentScore + _scoreDelta;
            RB_Terminal setVariable ["rb_score", _newScore, true];

            private _color      = if (_scoreDelta >= 0) then {"#00ff00"} else {"#ff0000"};
            private _reasonText = if (count _reasons > 0) then {
                ("<br/>• " + (_reasons joinString "<br/>• "))
            } else {
                "Standard Procedure"
            };

            private _msg = format [
                "<t size='1.25' font='PuristaBold' color='%1'>%2</t><br/>" +
                "<t color='#ffffff'>Target:</t> %3<br/>" +
                "<t color='#ffffff'>Score:</t> <t color='%1'>%4</t><br/>" +
                "<t color='#ffffff'>Details:</t> %5<br/><br/>" +
                "<t size='1' color='#cccccc'>Total: %6</t>",
                _color,
                _statusText,
                _name,
                if (_scoreDelta > 0) then { format["+%1", _scoreDelta] } else { str _scoreDelta },
                _reasonText,
                _newScore
            ];

            [_msg, 6] remoteExec ["RB_fnc_showNotification", 0];
        };

        // === 3. CLEANUP ===
        if (_x isKindOf "LandVehicle") then {
             { deleteVehicle _x } forEach (crew _x);
        };
        deleteVehicle _x;
    };
} forEach _list;