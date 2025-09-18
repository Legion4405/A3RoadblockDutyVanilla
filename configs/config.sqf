// === Civilian Hostility Settings ===
RB_HostileChance = 0.1;  // 1.0 = 100%, lower for real missions
//RB_HostileChance = 0.075;  // 1.0 = 100%, lower for real missions

// === Weapon Loadouts for Hostile Civilians
RB_HostileWeapons = [
    ["hgun_Pistol_01_F", ["10Rnd_9x21_Mag", 3]]
];

RB_ScoringTable = [
    ["vehicle_bomb",         5, "Vehicle Bomb"],
    ["defuse_bomb",          5, "Defused Bomb"],
    ["defuse_no_bomb",      -10, "Checked for Bomb (None Found)"],
    ["vehicle_bomb_defused", 5, "Vehicle Bomb (Defused)"],
    ["impound_bomb_notdefused", -15, "Impounded Vehicle (Bomb Not Defused)"],
    ["impound_bomb_defused",  5, "Impounded Vehicle (Bomb Defused)"],
    ["vehicle_contraband",   5, "Vehicle Contraband"],
    ["personal_contraband",  5, "Personal Contraband"],
    ["banned_origin",         5, "Banned Origin"],
    ["forged_id",            5, "Forged ID"],
    ["hostile",              10, "Hostile Civilian"],
    ["wrong_arrest",        -15, "Wrongful Arrest"],
    ["wrong_impound",       -15, "Wrongful Impound"],
    ["innocent_civilian_killed", -25, "Innocent Civilian Killed"],
    ["enemy_killed",          2, "Enemy Killed"],
    ["plate_mismatch",       -5, "License Plate Mismatch"],
    ["correct_release",       5, "Correct Release"],
    ["wrong_release",        -15, "Wrongful Release"],
    ["correct_vehicle_release", 5, "Correct Vehicle Release"],
    ["vehicle_release", 5, "Correct Vehicle Release"],
    ["wrong_vehicle_release", -10, "Wrongful Vehicle Release"],
    ["registration_mismatch",  5, "Registration Mismatch"],
    ["fugitive_arrested",    10, "Fugitive Arrested"],
    ["fugitive_released",   -20, "Fugitive Released"]
];

RB_ScoringTableMap = createHashMapFromArray RB_ScoringTable;
publicVariable "RB_ScoringTableMap";


RB_ArsenalAlwaysAvailable = [
    "ACE_EarPlugs", "ACE_elasticBandage", "ACE_tourniquet", "ACE_MapTools", "ACE_CableTie",
    "ACE_rope3", "ACE_EHP", "ACE_fieldDressing", "ACE_packingBandage", "ACE_quikclot",
    "ACE_bloodIV", "ACE_bloodIV_250", "ACE_bloodIV_500", "ACE_bodyBag", "ACE_epinephrine",
    "ACE_morphine", "ACE_painkillers", "ACE_personalAidKit", "ACE_plasmaIV", "ACE_plasmaIV_250",
    "ACE_plasmaIV_500", "ACE_salineIV", "ACE_salineIV_250", "ACE_salineIV_500", "ACE_splint",
    "ACE_surgicalKit", "ACE_suture", "ACE_Can_Franta", "ACE_Can_RedGull", "ACE_Can_Spirit",
    "ACE_Canteen", "ACE_Humanitarian_Ration", "ACE_MRE_BeefStew", "ACE_MRE_ChickenTikkaMasala", "ACE_MRE_ChickenHerbDumplings",
    "ACE_MRE_CreamChickenSoup", "ACE_MRE_CreamTomatoSoup", "ACE_MRE_LambCurry", "ACE_MRE_MeatballsPasta", "ACE_MRE_SteakVegetables",
    "ACE_Sunflower_Seeds", "ACE_WaterBottle", "ACE_EntrenchingTool", "ACE_Fortify", "ACE_Flashlight_MX991",
    "ACE_Flashlight_XL50", "acex_intelitems_notepad", "ACE_PlottingBoard", "ACE_SpottingScope", "ACE_Tripod",
    "ToolKit", "ACE_wirecutter"
];

private _allFacewearClassnames = "true" configClasses (configFile >> "CfgGlasses") apply { configName _x };
RB_ArsenalAlwaysAvailable = RB_ArsenalAlwaysAvailable + _allFacewearClassnames;
publicVariable "RB_ArsenalAlwaysAvailable";


RB_FakeNames = [
    // Mediterranean/Middle Eastern
    "Nikolas Vrettos", "Emre Kamal", "Samuel Bakari", "Unverified",
    "Yannis Kostas", "Mahmoud El Sayed", "Omar Farouk", "Dimitris Petrou",
    "Fatima Al-Mansouri", "Alexis Papadakis", "Ahmed Mostafa", "Anna Petrova",
    "Maria Georgiou", "Hassan Ali", "Salim Barakat", "Elena Marinos",
    "Georgios Kyriakou", "Ali Doumbia", "Rami Nasser", "Kostas Papageorgiou",
    "Layla Hassan", "Eleni Papadopoulou", "Sofia Karam", "Karim Idrissi",
    "Ioannis Nikolaidis", "Leila Ben Youssef", "Yusuf Kaya", "Vasilis Karas",
    "Ousmane Sarr", "Christos Zervas", "Maya Khalil", "Petros Markos",
    "Aisha Ghedira", "Huseyin Demir", "Nikos Skouras", "Mustapha Khaled",
    "Marina Pappas", "Amina Diop", "Ahmed Jalloh", "Nour Bouzid",
    "Anna-Maria Louka", "Isaac Mensah", "Khaled Al Rashid", "Leonidas Stavros",
    "Sarah Abadi", "Ebrahim Azizi", "Konstantinos Dimas", "Eleni Roussou",
    "Mohamed Sylla", "Yara Haddad", "Stefanos Antoniou",

    // Western European (25)
    "James Whitaker", "Charles Lambert", "Maxime Dubois",
    "Lucas Schmidt", "William Clark", "George Evans",
    "Benjamin Hall", "Oliver Wilson", "Thomas Hughes",
    "Liam Murphy", "Sebastian Richter", "Julian Weber",
    "Alexander Fischer", "Henry Walker",

    // Eastern European (25)
    "Ivan Petrov", "Andrei Sokolov", "Marek Novak", "Karlo Horvat", "Aleksander Ivanov",
    "Mateusz Kowalski", "Zoltan Szabo", "Nicolae Popescu", "Bojan Jankovic", "Milan Draganov",
    "Pavel Volkov", "Nikolai Mikhailov", "Radek Blazek", "Dmitri Ivanov", "Viktor Orlov",
    "Emil Markovic", "Stefan Dragomir", "Oleg Sidorov", "Jovan Petrovic", "Tomasz Nowak",
    "Márton Varga", "Kristian Iliev", "Roman Kuznetsov", "Lukasz Wisniewski", "István Bodnar",

    // African (20)
    "Kwame Boateng", "Amadou N'Diaye", "Joseph Okoro", "Fode Bamba", "Samuel Abebe",
    "Chinedu Nwosu", "Thabo Mokoena", "Ibrahim Keita", "Oumar Traore", "Daniel Kamau",
    "Emmanuel Mba", "Siphiwe Dlamini", "Amadou Diallo", "Boubacar Cisse", "Tinashe Chirwa",
    "Kofi Mensah", "Haruna Bello", "Paul Mugisha", "Abdoulaye Diallo", "Bheki Ncube",

    // Asian (20)
    "Li Wei", "Akio Tanaka", "Arjun Singh", "Ahmad Amin", "Nguyen Van Nam",
    "Ming Chen", "Ravi Patel", "Kim Min-Jun", "Minh Lam", "Hiroshi Yamamoto",
    "Akash Sharma", "Yu Wang", "Minjae Park", "Nuruddin Huda", "Thanh Le",
    "Satoshi Sato", "Quang Nguyen", "Sunil Raj", "Duc Tran", "Yusuke Nakamura",


    "Agent No-Name",      "John Doe",       "Jane Roe",        "Mystery Man",      "Smith Smithson",
    "Sergeant Banana",    "Doctor Mysterio","Alexei the Fifth","Privateer X",      "Unregistered",
    "Ghost Driver",       "Max Powers",     "April O’Neil",    "Jimmy Two-Times",  "Lisa Simpson",
    "J. Random Citizen",  "Anonymous User", "Inspector Gadget","Sneaky Pete",      "Captain Obvious",
    "Vladimir Putin",     "Chad Thunder",   "Random Encounter","Placeholder",      "MissingNo.",
    "Erik the Red",       "Juan Solo",      "Qwerty Uiop",     "Null Pointer",     "Indiana Jones",
    "Peter Griffin",      "Sasha Fierce",   "Test Subject 42", "Frank N. Stein",   "Sam Sung",
    "Moe Lester",         "Ben Dover",      "Al Dente",        "Phil McCraken",    "Yuri Gagarin",
    "Rando Calrissian",   "Not A Spy",      "Joe Mama",        "Bobson Dugnutt",   "Donkey Kong",
    "Sergeant Pepper",    "Borat Sagdiyev", "Hal 9000",        "Arthur Dent",      "Blaze McCool"
];







