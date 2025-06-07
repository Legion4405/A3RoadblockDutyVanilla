// scripts\initContraband.sqf
RB_ContrabandItems = [
    "Unregistered Firearm",
    "Box of Morphine Auto-Injectors",
    "Encrypted USB Drive",
    "Cocaine Packet",
    "Satellite Phone",
    "Military Field Map",
    "Unmarked Explosives",
    "Surveillance Photos",
    "Forged ID Document",
    "Unlabeled Chemical Vial",
    "Blood-Stained Rucksack",
    "Radio Jammer",
    "Illegal Drone Parts",
    "Bag of Dried Cannabis",
    "Marked Money Stack",
    "Counterfeit Passports",
    "Stolen Military Uniform",
    "Covert Listening Device",
    "Black Notebook",
    "Fake License Plates",
    "Antique Pistol",
    "Box of Detonators",
    "Flash Drive with Sensitive Data",
    "Unlicensed Medical Kit",
    "Stolen Vehicle Registration",
    "Satellite Imagery Printout",
    "Chemical Weapon Sample",
    "Ammo Crate Manifest",
    "Unregistered RF Scanner",
    "Smuggled Jewelry"
];

RB_NonContrabandItems = [
    "Wallet", "Wristwatch", "Photo of Family", "Phone Charger", "Keys",
    "Small Water Bottle", "Cigarettes", "Matchbook", "Notebook", "Pens",
    "Shopping Receipt", "Bus Ticket", "Train Pass", "Religious Pendant",
    "Letter", "Coins", "Business Card", "Lighter", "Chewing Gum",
    "Book: Farming Almanac", "Book: Local History", "Work Gloves", "Flashlight",
    "Snack Bar", "Pack of Tissues", "Bottle Cap", "Piece of String",
    "Map of Region", "Sunglasses", "Scarf", "Passport (Valid)",
    "Reading Glasses", "Dust Mask", "Medical Prescription", "Toothbrush",
    "Plastic Fork", "Notepad", "Scrap of Paper", "Old Bill", "Souvenir Magnet",
    "Empty Cigarette Pack", "Chalk", "Piece of Soap", "Hairbrush",
    "Bus Route Pamphlet", "Crushed Soda Can", "Penknife (Legal)", "Notebook with Scribbles",
    "Plastic Spoon", "Empty Snack Wrapper", "Magazine: Home Living",
    "Pocket Calendar", "Bottle of Water", "Bandages", "Pen Refill", "USB Cable",
    "Phone Case", "Lint Roller", "Eyeglass Case", "Mini Tool Kit",
    "Deck of Cards", "Notebook: Grocery List", "Battery Pack", "Fabric Swatch",
    "Hair Tie", "Nail Clipper", "Coin Purse", "Hand Mirror", "Bottle of Hand Sanitizer",
    "Shoelaces", "Commuter Badge", "Keychain with Flashlight", "Train Schedule",
    "Torn Piece of Newspaper", "Local Discount Card", "Used Movie Ticket",
    "Plastic Water Cup", "Face Mask", "Tin of Mints", "Eraser"
];

// Broadcast to all clients, including JIP
RB_ActiveContraband = +RB_ContrabandItems;
publicVariable "RB_ActiveContraband";
