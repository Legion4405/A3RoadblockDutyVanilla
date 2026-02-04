/*
    File: fn_interrogateCivilian.sqf
    Description: Handles the interrogation of a civilian using subtitles with high variety.
    Authors: Gemini CLI
*/
params ["_civ"];

if (!alive _civ) exitWith { ["The subject is dead.", 5] call RB_fnc_showNotification; };

private _story = _civ getVariable ["rb_civ_story", ["Unknown", "Unknown", "Unknown", false, "Unknown", "Unknown"]];

// Handle backward compatibility or missing data
if (count _story < 6) then {
    _story resize 6;
    _story set [4, _story select 0]; // Default real to claimed
    _story set [5, _story select 1];
};

_story params ["_origin", "_destination", "_purpose", "_isLying", "_realOrigin", "_realDestination"];

// Define dialogue templates based on purpose
private _templates = [];

switch (_purpose) do {
    case "Visiting Family": {
        _templates = [
            "I'm heading to %2 to see my mother. Coming from %1.",
            "Just visiting some relatives in %2. I live in %1.",
            "My brother is sick in %2, I need to check on him. Driving from %1.",
            "Family reunion in %2. Should be fun. Coming from %1.",
            "Taking my kids to their grandparents in %2. We're from %1.",
            "Going to %2 for a family dinner. I'll return to %1 tonight.",
            "My cousin in %2 is having a baby! Rushing there from %1.",
            "Just a quick visit to my parents in %2. I started in %1.",
            "My sister in %2 needs help with moving. I'm from %1.",
            "Visiting my uncle in %2. Leaving %1 for the weekend.",
            "It's my dad's birthday in %2. Driving up from %1.",
            "Checking on my grandmother in %2. Coming from %1.",
            "I have family in %2 I haven't seen in years. I live in %1.",
            "My wife's parents live in %2. We're driving from %1.",
            "Just dropping off some supplies for my aunt in %2. From %1.",
            "My nephew has a school play in %2. Coming from %1.",
            "Going to %2 to pay respects to a late relative. From %1.",
            "Visiting the in-laws in %2. Pray for me. Coming from %1.",
            "My daughter is studying in %2. Visiting her from %1.",
            "Family emergency in %2. I have to get there from %1."
        ];
    };
    case "Commuting to Work": {
        _templates = [
            "Heading to work in %2. I live in %1.",
            "Shift starts in an hour in %2. Commuting from %1.",
            "Just going to the office in %2. Coming from %1.",
            "I work at the factory in %2. Driving from %1.",
            "Daily commute. %1 to %2.",
            "Got a meeting in %2. Coming from %1.",
            "I'm late for work in %2! Let me through. From %1.",
            "Works at the docks in %2. Live in %1.",
            "Just another day at the grind in %2. Coming from %1.",
            "Heading to my shop in %2. I commute from %1.",
            "I'm a teacher in %2. Driving from %1.",
            "Construction job in %2. Coming from %1.",
            "I drive from %1 to %2 every day for work.",
            "Working double shift in %2 today. From %1.",
            "Just trying to get to work in %2. From %1.",
            "My boss in %2 will kill me if I'm late. Coming from %1.",
            "I work security in %2. Heading there from %1.",
            "On my way to the plant in %2. From %1.",
            "Commuting to %2. Traffic from %1 was terrible.",
            "Work, work, work. Heading to %2 from %1."
        ];
    };
    case "Returning from Work": {
        _templates = [
            "Just finished my shift. Heading home to %2 from %1.",
            "Long day at work in %1. Going home to %2.",
            "Finally off the clock. Driving to %2 from %1.",
            "Heading back to %2 after work in %1.",
            "I'm tired, just want to get home to %2. Coming from %1.",
            "Done for the day. Returning to %2 from %1.",
            "Work in %1 was brutal. Going home to %2.",
            "Just clocked out in %1. Heading to %2.",
            "Returning to %2. Work in %1 ran late.",
            "Going home to %2. My job in %1 is exhausting.",
            "Finished the night shift in %1. Going to sleep in %2.",
            "Heading back to the family in %2. Work in %1 is done.",
            "Closing up shop in %1. Going home to %2.",
            "Done with the delivery in %1. Returning to base in %2.",
            "Just got off work in %1. Heading to %2.",
            "My shift in %1 just ended. Going home to %2.",
            "Going back to %2. Worked all day in %1.",
            "Returning to my apartment in %2 from work in %1.",
            "Heading home to %2. Long drive from %1.",
            "Work's over. Going from %1 to %2."
        ];
    };
    case "Heading Home": {
        _templates = [
            "Just going home to %2. Coming from %1.",
            "Heading back to my house in %2. Left %1 an hour ago.",
            "Returning to %2. Was just visiting %1.",
            "Going home. %2. Coming from %1.",
            "On my way back to %2. Was in %1.",
            "Just want to get home to %2. Driving from %1.",
            "Heading to my place in %2 from %1.",
            "Going back to %2. Stayed in %1 for a bit.",
            "Returning to %2. Business in %1 is done.",
            "Driving home to %2 from %1.",
            "Back to the wife in %2. Coming from %1.",
            "Heading home to %2. Was seeing friends in %1.",
            "Going to my flat in %2. Left %1 just now.",
            "Returning to %2. Trip to %1 was short.",
            "Just going home. %2. From %1.",
            "Heading back to %2. %1 was nice.",
            "On the way home to %2 from %1.",
            "Driving back to %2. Finished up in %1.",
            "Going home to %2. Long trip from %1.",
            "Returning to %2. Had to run an errand in %1."
        ];
    };
    case "Delivery": {
        _templates = [
            "Delivering supplies to %2. Loaded up in %1.",
            "Got a package for %2. Coming from %1.",
            "Transporting goods from %1 to %2.",
            "Just a delivery run to %2. From %1.",
            "Taking this cargo to %2. Picked it up in %1.",
            "Courier job. %1 to %2.",
            "Delivering food to %2. Kitchen is in %1.",
            "Parts delivery for a garage in %2. From %1.",
            "Hauling this to %2 from %1.",
            "Making a drop-off in %2. Coming from %1.",
            "Urgent delivery to %2. Left %1 in a hurry.",
            "Just moving some stuff to %2 from %1.",
            "Supply run. %1 to %2.",
            "Delivering medicine to %2. From %1.",
            "Logistics run. Heading to %2 from %1.",
            "Taking these crates to %2. Origin is %1.",
            "Delivery for a shop in %2. Coming from %1.",
            "Just a driver. Going %1 to %2.",
            "Transporting equipment to %2 from %1.",
            "Regular route. %1 to %2."
        ];
    };
    case "Medical Appointment": {
        _templates = [
            "Going to the clinic in %2. Coming from %1.",
            "Doctor's appointment in %2. Driving from %1.",
            "My back is killing me, seeing a specialist in %2. From %1.",
            "Check-up in %2. Live in %1.",
            "Taking my wife to the doctor in %2. We're from %1.",
            "Need to pick up prescription in %2. From %1.",
            "Medical emergency, kind of. Going to %2 from %1.",
            "Dentist appointment in %2. Hate it. From %1.",
            "Eye exam in %2. Driving from %1.",
            "Therapy session in %2. Coming from %1.",
            "Hospital visit in %2. From %1.",
            "Getting a check-up in %2. Live in %1.",
            "Surgery consultation in %2. From %1.",
            "Going to the vet in %2. From %1.",
            "My doctor is in %2. I live in %1.",
            "Health issues. Going to %2 from %1.",
            "Just a medical thing in %2. Coming from %1.",
            "Need to see a nurse in %2. From %1.",
            "Clinic visit. %1 to %2.",
            "Heading to the hospital in %2 from %1."
        ];
    };
    case "Shopping": {
        _templates = [
            "Going shopping in %2. Stores in %1 are empty.",
            "Buying groceries in %2. Coming from %1.",
            "Need some parts from %2. Driving from %1.",
            "Market day in %2. From %1.",
            "Just grabbing some food in %2. Live in %1.",
            "Shopping trip to %2. From %1.",
            "Buying clothes in %2. %1 has nothing good.",
            "Going to the hardware store in %2. From %1.",
            "Need supplies from %2. Coming from %1.",
            "Just shopping. %1 to %2.",
            "Heading to the market in %2 from %1.",
            "Buying a gift in %2. From %1.",
            "Grocery run to %2. Live in %1.",
            "Shopping for the week in %2. From %1.",
            "Need to buy tools in %2. From %1.",
            "Going to the mall in %2. From %1.",
            "Market run. %1 to %2.",
            "Just buying some things in %2. From %1.",
            "Shopping for furniture in %2. From %1.",
            "Heading to the shops in %2 from %1."
        ];
    };
    case "Tourism": {
        _templates = [
            "Just looking around %2. Staying in %1.",
            "Sightseeing in %2. Coming from %1.",
            "Tourist. Going from %1 to %2.",
            "Checking out the landmarks in %2. From %1.",
            "On vacation. Heading to %2 from %1.",
            "Visiting %2 for the views. From %1.",
            "Just touring the island. %1 to %2.",
            "Taking photos in %2. Coming from %1.",
            "Exploring %2. We're staying in %1.",
            "Nice day for a drive to %2. From %1.",
            "Just visiting. Going to %2 from %1.",
            "Holiday trip. %1 to %2.",
            "Looking at the ruins in %2. From %1.",
            "Driving around. %1 to %2.",
            "Tourist stuff. Heading to %2 from %1.",
            "Just travel. %1 to %2.",
            "Visiting the sights in %2. From %1.",
            "On holiday. Going to %2 from %1.",
            "Touring %2 today. Left %1 this morning.",
            "Just a visitor. %1 to %2."
        ];
    };
    case "Going to the Beach": {
        _templates = [
            "Heading to the beach in %2. From %1.",
            "Surf's up in %2. Driving from %1.",
            "Going for a swim in %2. Live in %1.",
            "Beach day! Going to %2 from %1.",
            "Taking the kids to the beach in %2. From %1.",
            "Just relaxing by the water in %2. Coming from %1.",
            "Sunbathing in %2 today. From %1.",
            "Fishing trip near %2. Coming from %1.",
            "Picnic on the beach in %2. From %1.",
            "Going to the coast in %2. From %1.",
            "Beach trip. %1 to %2.",
            "Swimming in %2. From %1.",
            "Spending the day at the beach in %2. From %1.",
            "Ocean view in %2. Driving from %1.",
            "Going to cool off in %2. From %1.",
            "Beach party in %2. From %1.",
            "Just the beach. %1 to %2.",
            "Seaside trip to %2. From %1.",
            "Heading to the shore in %2 from %1.",
            "Going for a dip in %2. From %1."
        ];
    };
    case "Meeting Friends": {
        _templates = [
            "Meeting some buddies in %2. Coming from %1.",
            "Going to see friends in %2. From %1.",
            "Hanging out with friends in %2. Driving from %1.",
            "Dinner with friends in %2. Live in %1.",
            "Party at a friend's place in %2. From %1.",
            "Catching up with a mate in %2. From %1.",
            "Just seeing some people in %2. From %1.",
            "Meeting a girl in %2. Coming from %1.",
            "Drinks with friends in %2. From %1.",
            "Social call in %2. From %1.",
            "Meeting the guys in %2. From %1.",
            "Friend's birthday in %2. From %1.",
            "Just hanging out. %1 to %2.",
            "Visiting a friend in %2. From %1.",
            "Meeting up in %2. From %1.",
            "Seeing some old friends in %2. From %1.",
            "Going to a bar in %2 with friends. From %1.",
            "Friend needs help in %2. From %1.",
            "Meeting people. %1 to %2.",
            "Just a social visit to %2 from %1."
        ];
    };
    default {
        _templates = [
            "I am traveling from %1 to %2. Purpose is %3.",
            "Coming from %1, heading to %2 for %3.",
            "I'm on my way to %2 from %1. Just %3."
        ];
    };
};

private _text = format [selectRandom _templates, _origin, _destination, _purpose];

// === SLIP-UP LOGIC ===
// If they are lying, occasionally make them slip up by saying the REAL location then correcting.
if (_isLying && {random 1 < 0.4}) then {
    // Determine which part they are lying about
    private _lieOrigin = (_origin != _realOrigin);
    private _lieDest   = (_destination != _realDestination);
    
    // Prioritize slip-ups
    if (_lieOrigin && {random 1 < 0.5}) then {
        _text = format ["I'm coming from %1... I mean, %2! Heading to %3.", _realOrigin, _origin, _destination];
    } else {
        if (_lieDest) then {
            _text = format ["I'm going to %1... uh, I mean %2. Coming from %3.", _realDestination, _destination, _origin];
        };
    };
};

// === STUTTER LOGIC ===
// If they are lying, add some nervous stuttering to the text
if (_isLying && {random 1 < 0.4}) then {
    private _words = _text splitString " ";
    private _stutteredText = [];
    {
        // 15% chance to stutter on words longer than 3 characters
        if (count _x > 3 && {random 1 < 0.15}) then {
            private _char = _x select [0, 1];
            _stutteredText pushBack (format ["%1... %1... %2", _char, toLower _char, _x]);
        } else {
            _stutteredText pushBack _x;
        };
    } forEach _words;
    _text = _stutteredText joinString " ";
};

// Use BIS_fnc_showSubtitle for the "John Doe: Message" style
[name _civ, _text] spawn BIS_fnc_showSubtitle;
