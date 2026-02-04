// File: scripts\system\initTutorial.sqf
// Adds the 'How to Play' tutorial diary category for players.

if !(player diarySubjectExists "RB_Roadblock_Tutorial") then {
    player createDiarySubject ["RB_Roadblock_Tutorial", "How to Play"];
};

player createDiaryRecord["RB_Roadblock_Tutorial", ["Arrestable Offenses",
 "A lawful arrest or impound requires evidence of a violation. Arresting innocent civilians will result in heavy point penalties.
 <br/><br/>
 <font color='#ff0000' size='14'>Valid Reasons for Arrest/Impound:</font>
 <br/><br/>
• <font color='#00ffff'>Deception:</font> Lying about origin/destination or contextually impossible stories (e.g. Beach trip in a storm).<br/>
• <font color='#00ffff'>Travel Permits:</font> Missing permit, Expired date, or Route Mismatch.<br/>
• <font color='#00ffff'>Identification:</font> Most Wanted Fugitive or Banned Home Town.<br/>
• <font color='#00ffff'>Paperwork:</font> ID Number or License Plate Mismatch.<br/>
• <font color='#00ffff'>Contraband:</font> Illegal items found on person or in vehicle.<br/>
• <font color='#00ffff'>Explosives:</font> Presence of a Vehicle Bomb (Defuse first!).<br/>
• <font color='#00ffff'>Hostility:</font> Neutralizing suspects who open fire on the checkpoint.
 "]];

player createDiaryRecord["RB_Roadblock_Tutorial", ["Deduction & Verification",
 "The checkpoint is more than just a paperwork check. You must use logic to catch smart criminals.
 <br/><br/>
<font color='#ccff00' size='14'>1. The Spoken Story</font><br/>
Question the driver and passengers. Their stories should be consistent. Listen for 'Slip-ups' where a nervous suspect accidentally mentions a banned town before correcting themselves.
<br/><br/>
<font color='#ccff00' size='14'>2. Context Awareness</font><br/>
Does their purpose make sense?
<br/>• Is it 2 AM and they claim to be going to the beach?
<br/>• Is it pouring rain and they are 'sightseeing'?
<br/>• Are they in a sports car but claim to be 'delivering heavy machinery'?
<br/>If the context is impossible, they are lying.
<br/><br/>
<font color='#ccff00' size='14'>3. Physical Evidence</font><br/>
A true story is backed by physical items.
<br/>• <font color='#00ffff'>Delivery:</font> Check for cargo, toolkits, or supply crates in the trunk.
<br/>• <font color='#00ffff'>Medical:</font> Check for first aid kits or medical gear.
<br/>• <font color='#00ffff'>Beach/Shopping:</font> Check for food, water, or accessories.
<br/>If a driver claims to be on a delivery but the vehicle is empty, it is a lie.
 "]];

player createDiaryRecord["RB_Roadblock_Tutorial", ["Processing a Civilian",
 "Every civilian passing through must be processed. Use the ACE Interaction menu for the following:
 <br/><br/>
• <font color='#00ffff'>Question Subject:</font><br/>
Asks the civilian for their Origin, Destination, and Purpose. Compare this to their documents!<br/><br/>

• <font color='#00ffff'>Check Identification:</font><br/> 
Shows the name, DOB, and Home Town. Check if the Home Town is on the 'Restricted Areas' list (Marker on map).<br/><br/>

• <font color='#00ffff'>Check Travel Permit:</font><br/> 
Shows authorized route and expiry date. Compare the date to the 'Current Date' marker in the top-left of your map.<br/><br/>

• <font color='#00ffff'>Search Civilian:</font><br/> 
Conduct a pat-down for contraband or evidence items.<br/><br/>

• <font color='#00ffff'>Mark as Processed:</font><br/>
If the civilian is clear, mark them as processed. They will wait for the roadblock to be cleared via the terminal.
 "]];

player createDiaryRecord["RB_Roadblock_Tutorial", ["Processing a Vehicle",
 "To start processing, a vehicle must be waiting at the gate. Use 'Start Processing' at the terminal to begin.
 <br/><br/>
• <font color='#00ffff'>Question Driver:</font><br/>
Talk to the driver while they are still inside. Quickest way to spot a contradiction.<br/><br/>

• <font color='#00ffff'>Check Registration:</font><br/> 
Shows the registered owner, ID, and plate. Mismatches are grounds for impound.<br/><br/>

• <font color='#00ffff'>Search Vehicle:</font><br/> 
Inspect the inventory. Look for contraband or evidence that supports their story.<br/><br/>

• <font color='#00ffff'>Defuse Bomb:</font><br/> 
Use a mine detector to check for IEDs. Only defuse if a bomb is present, or you will be penalized for 'False Alarm'.<br/><br/>

• <font color='#00ffff'>Impound Vehicle:</font><br/> 
Visible once all occupants are out. Use for vehicles with registration issues, contraband, or bombs.<br/><br/> 

• <font color='#00ffff'>Mark as Processed:</font><br/> 
If the vehicle is clean, mark it for release.
 "]];
 
player createDiaryRecord["RB_Roadblock_Tutorial", ["The Terminal",
 "The central hub for roadblock operations.
 <br/><br/>
• <font color='#00ffff'>Check Score:</font> Monitor your operational points. Total score determines success or failure.<br/><br/>
• <font color='#00ffff'>Roadblock Management:</font> Open the gate, clear processed traffic, or close the roadblock to pause civilian/insurgent spawning.<br/><br/>
• <font color='#00ffff'>Logistics:</font> Spend points to unlock new weapons, gear, attachments, and static emplacements.<br/><br/>
• <font color='#00ffff'>Admin Tools:</font> Change mission specs, time, weather, and manage the three Save Slots.
 "]];