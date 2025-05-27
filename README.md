* **Dynamic Checkpoint Spawner**

  * Adjustable “intensity” (low → very high) sets randomized spawn delays
  * Spawns either foot civilians or civilian-driven vehicles at designated markers
  * Pools of vehicle and civilian classes configurable via missionNamespace variables
  * Foot/vehicle behave “careless” and move to your hold point, then sit ready for processing

* **Processing Workflow**

  * ➔ **RB\_CurrentEntity** locks each spawned unit/vehicle as the “active” target
  * Action “Start Processing” (ACE menu) moves infantry through a gate or animates vehicles in
  * Checks registries/contraband/plates/names/IDs and flags any violations
  * Marks each entity “processed” to stop timeouts, honks, and auto-cleanup

* **Scoring & Feedback**

  * Per-team score tracked on missionNamespace (`rb_score`)
  * +5 for valid arrest/impound, –5 for wrongful arrest/invalid impound
  * ACE action “Check Score” brings up a structured HTML text box with current tally and rules

* **ACE Terminal UI**

  * Root categories: **Roadblock Management**, **Logistics**, **Admin Tools**, **Save System**
  * Management submenu with “Start Processing” (conditioned on ready state, enemy-filter)
  * Logistics submenu dynamically populated from `RB_LogisticsOptions` (requests spawn items)
  * Admin submenu extras (plus your new **Close Roadblock** / **Open Roadblock** toggles)
  * Save Category placeholder for future persistence

* **Roadblock Open/Close Toggle**

  * `RB_RoadblockClosed` flag pauses/resumes all spawns in the checkpoint spawner loop
  * ACE actions show only “Close Roadblock” or “Open Roadblock” as appropriate
  * Server‐only logic + `publicVariableClient` ensures clients (and JIPers) stay in sync

* **JIP- & MP-Safety**

  * All important flags (`RB_CurrentEntity`, `rb_processingInProgress`, `RB_SpawnerRunning`, `RB_RoadblockClosed`) broadcast via `publicVariableClient`
  * Spawner always run on server only (via `execVM`), clients never spawn locally
  * `remoteExecCall …,0,true` / `…,1,true` / `…,2,true` used appropriately to give ACE menus to all players

* **Entity Timeouts & Horns**

  * Vehicles honk at 60 s and 90 s if not processed, then auto-delete at 120 s
  * Foot civilians time out after 90 s if they fail to reach the checkpoint
  * Deletions clear `RB_CurrentEntity` so spawner can retry

* **Post-mission Cleanup**

  * Server-only “garbage cleanup” script loops every X seconds to:

    * Delete all dead bodies (`allDeadMen`)
    * Purge wrecked, crewless vehicles (`vehicles` with >50 % damage & no crew)
    * Remove dropped weapons (`allMissionObjects "WeaponHolder"`)
