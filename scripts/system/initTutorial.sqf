player createDiarySubject ["RB_Roadblock_Tutorial", "How to Play"];

  player createDiaryRecord["RB_Roadblock_Tutorial", ["Arrestable Offenses",
 "Different kinds of violations may require different actions to resolve.
 <br/><br/>

• Vehicle/Driver ID, ID Number, or License Plate Mismatch:<br/>
Impound of the vehicle.<br/><br/>

• Vehicle Contraband:<br/>
Impound of the vehicle.<br/>
Driver Arrest.<br/><br/>

• Vehicle Bomb:<br/>
Impound of the vehicle.<br/>
Passengers Arrest.<br/>
Driver Arrest.<br/><br/>

• Banned Origin:<br/>
Arrest.<br/><br/>

• Contraband on Person:<br/>
Arrest.<br/><br/>


 "]];

  player createDiaryRecord["RB_Roadblock_Tutorial", ["Processing a Civilian",
 "Just like vehicles, each and every civilian should get processed also. Failing to do so properly, will result in points deduction.
 <br/><br/>
If any reason has been found to arrest a civilian, they should be taken into the building, through the first door on the right. You can do this by using zipcuffs, and escorting them through the ACE interactions.<br/><br/>

• Check Identification:<br/> 
Shows you the name, date of birth, place of origin, and ID Number of the civilian.<br/><br/>

• Search Civilian:<br/> 
Shows you the items the civilian carries on their person.<br/><br/>

• Mark as Processed:
If a civilian is deemed to have no violations, you can mark them as processed, which will pass it through inspection, and wait for the 'Clear Processed' through the terminal for it to be sent on their way.
 "]];

  player createDiaryRecord["RB_Roadblock_Tutorial", ["Processing a Vehicle",
 "Every vehicle that passes through the roadblock will have to get thoroughly checked, to avoid being penalized.
 <br/><br/>
 To start the processing of vehicles, a vehicle has to wait in front of the roadblock. This gives the 'Start Processing' option at the terminal.<br/>
 Selecting this option, will open the boomgate, and the vehicle enters the roadblock. From this point on, you gain access to the 'Vehicle Interactions'<br/><br/>

• Check Registration:<br/> 
Shows you the person the vehicle is registered to, the ID of the person the vehicle is registered to, and the license plate the vehicle is registered with.<br/><br/>

• Check License:<br/> 
 Some mods and vehicles do not have a license plate shown on the model, this shows the license plate that the vehicle has, not registered with.<br/><br/>

• Search Vehicle:<br/> 
Shows the contents of the vehicle, up to you to discern whether they are legal or illegal!<br/><br/>

• Order Out:<br/> 
 Forces all occupants of the vehicle to exit the vehicle.<br/><br/>

• Defuse Bomb:<br/> 
Players can use the mine detector issued to them to check vehicles for explosive devices. If they use the 'Defuse' option whilst there is no bomb in the vehicle, they will receive a points deduction.<br/><br/>

 • Impound Vehicle:<br/> 
Will become visible after all civilians have been ordered out. If a vehicle has registration, license plate issues, or contraband. Impounding the vehicle will result in a positive score.<br/>
Be aware, if a vehicle has a bomb inside, and gets impounded, there will be a points deduction if the bomb has not been defused prior.<br/><br/> 

• Mark as Processed:<br/> 
If a vehicle is deemed to have no violations, you can mark it as processed, which will pass it through inspection, and wait for the 'Clear Processed' through the terminal for it to be sent on it's way.
 "]];
 
player createDiaryRecord["RB_Roadblock_Tutorial", ["The Terminal",
 "With the terminal you can control the roadblock, here's what you can do with it.
 <br/><br/>
• Check Score: <br/>
Allows you to check the score, every action will either add or deduct points to the global total.
  <br/><br/>
• Roadblock Management: <br/>
Within here you can allow vehicles to come into the roadblock, or leave when finished processing. Also, this sub-menu allows you to close the roadblock pausing spawning of enemies, and civilians wanting to access the checkpoint.
Do note: 'Clear Roadblock' has to be used, before being able to 'Start Processing' again.
 <br/><br/>
• Logistics: <br/>
Allows you to spend points in exchange for better gear, weapons, or attachments.
 <br/><br/>
• Admin Tools: <br/>
Allows the admin/host to change the time, speed, weather, reset the checkpoint, and most importantly, pick one of three save slots to save progress with.
 "]];