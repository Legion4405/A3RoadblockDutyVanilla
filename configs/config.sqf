// === Civilian Hostility Settings ===
RB_HostileChance = 0.1;  // 1.0 = 100%, lower for real missions

// === Weapon Loadouts for Hostile Civilians
RB_HostileWeapons = [
    // Secondaries (Common)
    ["hgun_Pistol_01_F", ["10Rnd_9x21_Mag", 4]],
    ["hgun_Rook40_F", ["16Rnd_9x21_Mag", 4]],
    ["hgun_P07_F", ["16Rnd_9x21_Mag", 4]],
    
    // Primaries (Dangerous)
    ["SMG_01_F", ["30Rnd_45ACP_Mag_SMG_01", 4]],      // Vermin
    ["SMG_02_F", ["30Rnd_9x21_Mag_SMG_02", 4]],      // Scorpion
    ["SMG_05_F", ["30Rnd_9x21_Mag_SMG_02", 4]],      // Protector
    ["arifle_AKS_F", ["30Rnd_545x39_Mag_F", 4]],     // AKS-74U
    ["arifle_AKM_F", ["30Rnd_762x39_Mag_F", 4]]     // AKM
];

RB_ScoringTable = [
    // Key                          Points   Display Name
    ["vehicle_bomb",                10,      "Vehicle Bomb"],
    ["vehicle_bomb_defused",        5,       "Vehicle Bomb (Defused)"],
    ["impound_bomb_notdefused",     -15,     "Impounded Bomb (Not Defused)"], 
    
    ["vehicle_contraband",          5,      "Vehicle Contraband"],
    ["personal_contraband",         5,      "Personal Contraband"],
    
    ["banned_origin",               8,       "Banned Origin"],
    ["forged_id",                   5,      "Forged ID"],
    ["missing_permit",              8,       "Missing Travel Permit"],
    ["permit_mismatch",             5,      "Travel Permit Mismatch"],
    ["permit_expired",              5,       "Expired Travel Permit"],
    ["lying",                       5,      "Lying to Authority"],
    
    ["hostile",                     15,      "Neutralized Hostile"],
    
    ["plate_mismatch",              5,       "License Plate Mismatch"],
    ["registration_mismatch",       5,       "Registration Mismatch"],
    
    ["fugitive_arrested",           25,      "Fugitive Arrested"], // Big reward!
    ["fugitive_released",           -50,     "Fugitive Released"],
    
    // Penalties / Actions
    ["arrest_innocent",             -15,     "Wrongful Arrest"],
    ["wrong_impound",               -25,     "Wrongful Impound"],
    ["innocent_civilian_killed",    -50,     "Civilian Casualty"],
    
    ["correct_release",             5,       "Correct Release"], // Small bonus for doing job
    ["wrong_release",               -15,     "Wrongful Release (Civilian)"],
    ["correct_vehicle_release",     5,       "Correct Vehicle Release"],
    ["wrong_vehicle_release",       -20,     "Wrongful Release (Vehicle)"]
];

RB_ScoringTableMap = createHashMapFromArray RB_ScoringTable;
publicVariable "RB_ScoringTableMap";


RB_ArsenalAlwaysAvailable = [
    "ACE_EarPlugs", "ACE_MapTools", "ACE_CableTie", "ACE_rope3", 
    "ACE_Can_Franta", "ACE_Can_RedGull", "ACE_Can_Spirit",
    "ACE_Canteen", "ACE_Humanitarian_Ration", "ACE_MRE_BeefStew", "ACE_MRE_ChickenTikkaMasala", "ACE_MRE_ChickenHerbDumplings",
    "ACE_MRE_CreamChickenSoup", "ACE_MRE_CreamTomatoSoup", "ACE_MRE_LambCurry", "ACE_MRE_MeatballsPasta", "ACE_MRE_SteakVegetables",
    "ACE_Sunflower_Seeds", "ACE_WaterBottle", "ACE_EntrenchingTool", "ACE_Fortify", "ACE_Flashlight_MX991",
    "ACE_Flashlight_XL50", "acex_intelitems_notepad", "ACE_PlottingBoard", "ACE_SpottingScope", "ACE_Tripod",
    "ToolKit", "ACE_wirecutter"
];

// Global list of ACE Medical Items for sanitization
RB_AceMedicalItems = [
    "ACE_atropine", "ACE_elasticBandage", "ACE_tourniquet", "ACE_EHP", "ACE_fieldDressing", "ACE_packingBandage", "ACE_quikclot",
    "ACE_bloodIV", "ACE_bloodIV_250", "ACE_bloodIV_500", "ACE_bodyBag", "ACE_epinephrine", "ACE_adenosine",
    "ACE_morphine", "ACE_painkillers", "ACE_personalAidKit", "ACE_plasmaIV", "ACE_plasmaIV_250",
    "ACE_plasmaIV_500", "ACE_salineIV", "ACE_salineIV_250", "ACE_salineIV_500", "ACE_splint",
    "ACE_surgicalKit", "ACE_suture"
];

if (isClass (configFile >> "CfgPatches" >> "ace_medical")) then {
    RB_ArsenalAlwaysAvailable append RB_AceMedicalItems;
};

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
    "Marton Varga", "Kristian Iliev", "Roman Kuznetsov", "Lukasz Wisniewski", "Istvan Bodnar",

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
    "Ghost Driver",       "Max Powers",     "April O'Neil",    "Jimmy Two-Times",  "Lisa Simpson",
    "J. Random Citizen",  "Anonymous User", "Inspector Gadget","Sneaky Pete",      "Captain Obvious",
    "Vladimir Putin",     "Chad Thunder",   "Random Encounter", "MissingNo.",
    "Erik the Red",       "Juan Solo",      "Qwerty Uiop",     "Null Pointer",     "Indiana Jones",
    "Peter Griffin",      "Sasha Fierce",   "Test Subject 42", "Frank N. Stein",   "Sam Sung",
    "Moe Lester",         "Ben Dover",      "Al Dente",        "Phil McCraken",    "Yuri Gagarin",
    "Rando Calrissian",   "Not A Spy",      "Joe Mama",        "Bobson Dugnutt",   "Donkey Kong",
    "Sergeant Pepper",    "Borat Sagdiyev", "Hal 9000",        "Arthur Dent",      "Blaze McCool"
];

// === Traffic Spawn Timers ===
// Maps RB_Intensity param (0-3) to [Base Delay, Random Variance]
RB_TrafficSpawnTimers = [
    [360, 120], // Low
    [180, 60],  // Medium
    [180, 30],  // High
    [60, 5]     // Very High
];

RB_StoryPurposes = [
    "Visiting Family",
    "Commuting to Work",
    "Delivery",
    "Medical Appointment",
    "Shopping",
    "Tourism",
    "Going to the Beach",
    "Heading Home",
    "Meeting Friends",
    "Returning from Work"
];

// === Enemy Attack Timers ===
// Maps RB_EnemyAttackIntensity param (0-3) to [Min Delay, Max Delay]
RB_EnemyAttackTimers = [
    [900, 1800], // Low (15-30m)
    [600, 1200], // Medium (10-20m)
    [480, 720],  // High (8-12m)
    [300, 480]   // Very High (5-8m)
];

// === Ambient Air Flyover Timers ===
// Maps RB_AmbientAirIntensity param (0-3) to [Min Delay, Max Delay]
RB_AirFlyoverTimers = [
    [600, 1200], // Low (10-20m)
    [300, 600],  // Medium (5-10m)
    [120, 300],  // High (2-5m)
    [60, 120]    // Very High (1-2m)
];

// === Ambient Traffic Timers ===
// Maps RB_AmbientTrafficIntensity param (0-4) to [Min Delay, Max Delay]
RB_AmbientTrafficTimers = [
    [999, 999],   // Disabled
    [360, 600],   // Low
    [120, 360],   // Medium
    [90, 120],   // High
    [30, 60]      // Very High
];

// === Evidence Items for Story Verification (Virtual Items) ===
RB_EvidenceItems = createHashMapFromArray [
    ["Delivery", [
        "Pallet of Building Materials", "Crates of Electronic Parts", "Box of Automotive Spares", 
        "Stacks of Industrial Pipes", "Rolls of Heavy-Duty Cable", "Crates of Fresh Produce", 
        "Barrels of Industrial Lubricant", "Shipment of Hand Tools", "Furniture Delivery (Sofa/Table)",
        "Construction Hardware", "Plumbing Supplies", "Electrical Components"
    ]], 
    ["Medical Appointment", [
        "Personal First Aid Kit", "Prescription Medication Box", "Hospital Appointment Letter", 
        "X-Ray Envelopes", "Bag of Medical Samples", "Insulin Cooler Bag", "Orthopedic Brace"
    ]],
    ["Shopping", [
        "Bags of Groceries", "New Clothing Boxes", "Kitchenware Set", 
        "Large Sack of Flour", "Crate of Bottled Water", "Assorted Household Goods",
        "Garden Tools", "Small Electronics Box"
    ]],
    ["Going to the Beach", [
        "Beach Towels and Umbrella", "Cooler Box with Drinks", "Fishing Rods and Bait", 
        "Inflatable Water Toys", "Bag of Snorkeling Gear", "Picnic Basket", "Surfboard"
    ]],
    ["Tourism", [
        "Professional Camera Case", "Island Travel Guidebook", "Souvenir Bags", 
        "Binoculars Case", "Framed Map of Malden", "Camping Gear Stash"
    ]],
    ["Visiting Family", [
        "Gift Wrapped Boxes", "Large Suitcase", "Bag of Home-Cooked Food", 
        "Children's Toys", "Family Photo Album", "Bunch of Flowers"
    ]]
];
publicVariable "RB_EvidenceItems";
