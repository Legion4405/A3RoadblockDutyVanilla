/*
    RB_fnc_updateFugitiveDiary
    params: [_fugitiveName]
    Clears previous fugitive diary subject and adds new entry.
*/
params ["_fugitiveName"];

// Remove old subject/entries first (if it exists)
player removeDiarySubject "RB_Fugitive";
hint "A new fugitive is wanted.";

// Create subject and entry fresh
player createDiarySubject ["RB_Fugitive", "Most Wanted"];
player createDiaryRecord [
    "RB_Fugitive",
    [
        "Fugitive Alert",
        format [
            "Be on the lookout for:<br/><br/><t size='1.3' color='#ff2222'>%1</t><br/><br/>If found, arrest immediately!",
            _fugitiveName
        ]
    ]
];
sleep 10;
hint "";