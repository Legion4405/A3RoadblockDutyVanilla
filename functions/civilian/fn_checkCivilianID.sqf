// functions\civilian\fn_checkCivilianID.sqf
params ["_civ"];

// === Retrieve stored identity data
private _idData = _civ getVariable ["civ_identity", ["Unknown", "Unknown", "Unknown", "ID-0000000"]];
private _name     = _idData#0;
private _origin   = _idData#1;
private _dob      = _idData#2;
private _idNumber = _idData#3;

// === Build display text (no warning text)
private _text = format [
    "<t size='1.3' font='PuristaBold' align='center' color='#ffffff'>╔══════════════════════╗<br/>" +
    "║      CIVILIAN ID     ║<br/>" +
    "╠══════════════════════╣</t><br/><br/>" +
    "<t size='1' font='PuristaMedium' color='#ffffff'>" +
    "Name:   <t color='#00ffff'>%1</t><br/>" +
    "Origin: <t color='#00ffff'>%2</t><br/>" +
    "DOB:    <t color='#00ffff'>%3</t><br/>" +
    "ID#:    <t color='#00ffff'>%4</t><br/><br/></t>" +
    "<t size='1.2' font='PuristaBold' align='center' color='#ffffff'>╚══════════════════════╝</t>",
    _name,
    _origin,
    _dob,
    _idNumber
];

// === Show to checking player only
[_text, 7] call RB_fnc_showNotification;