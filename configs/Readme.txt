Roadblock duty is designed to be as modular as possible, and easy to edit for mission makers, like yourself!
Thank you for taking the interest in further editing my mission, hopefully we can get done what you're looking for.

The following files hold the configuration that are changeable by the mission parameters, the names should speak for themselves.
civilianFactions.sqf
enemyFactions.sqf
playerFactions.sqf

Dependent on how well versed you are in SQF and Arma 3, I would suggest not touching those, unless you'd like to make changed to the existing set-up.

However, if you would like to add your own enemies, civilians, and player factions and assets, we'll have to look into customFactions.sqf
This file holds the arrays for all three facets, and if you change the mission parameters for these to Custom, it will load from this file.

If you want to set the mission parameters default to custom, open description.ext, and under the class Params, change the following default = #; to 0.

RB_LogisticsFaction 	(Sets the players starting gear, as well as the logistics options)
RB_CivilianPool		(Sets the civilian classes that get spawned)
RB_CivilianVehiclePool	(Sets the civilian vehicle classes that get spawned)
RB_EnemyFaction		(Sets the enemy class that get spawned)
RB_EnemyVehiclePool	(Sets the enemy vehicle classes that get spawned)

For the class RB_AmbientAir set the default to 1, instead of 0, as 0 is disabled.

RB_LogisticsOptions_Custom sets all the logistics options. You can add your own categories to it as well, but by default they are;
Ammo,
Weapons,
Gear, 
Supplies,
Vehicles,
Turrets.

Just make sure you follow the same formatting.
Do note, Vehicles and Turrets have coded additional functions to spawn the vehicles, and turrets. In the array they have ["Displayname], ["VEHICLE or TURRET", "CLASSNAME"], cost],

If you wish to add a Heavy Vehicle category, make sure to follow the same formatting, as well as for Turrets.
Any other category will just unlock the indicated classnames in the Arsenal.

Good luck!