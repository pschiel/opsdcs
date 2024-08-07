------------------------------------------------------------------------------
--- GUI ENV
--- used by scripts in Scripts/Hooks
------------------------------------------------------------------------------

--- @type table
package = {}

--- @param module string
function require(module) end

--- @type Export
Export = {}

--- @type db
db = {}

--- @type lfs
lfs = {}

--- @type io
io = {}

--- @type os
os = {}

--- @type net
net = {}

------------------------------------------------------------------------------
--- DCS Control API
------------------------------------------------------------------------------

--- @class DCS
--- @description DCS Control API
--- @field activateSteamOverlayToStore fun()
--- @field add_dyn_group fun()
--- @field checkMultiplayerSpawnConflict fun(takeOffType, id, unitId, type)
--- @field conquestCoalitionsScore fun()
--- @field create_client_aircraft fun()
--- @field dispatchAnalogAction fun()
--- @field dispatchDigitalAction fun()
--- @field enter_with_dyngroup fun()
--- @field exitProcess fun() Commands to close the DCS application.
--- @field getAchievementsUiInfo fun()
--- @field getAircraftAmountInAirportWarehouse fun(type, id, isAirdrome)
--- @field getAirTankerID fun()
--- @field getAirdromesCoalition fun()
--- @field getAirdromesState fun()
--- @field getATCradiosData fun()
--- @field getAvailableCoalitions fun():table Returns a list of coalitions with client slots available.
--- @field getAvailableSlots fun(coaId:number|string):table Returns a table of slots available to a given coalition.
--- @field getConfigValue fun()
--- @field getConquestAirbaseState fun()
--- @field getCurrentFOV fun()
--- @field getCurrentMission fun():table Returns the table of the mission as stored in the mission file.
--- @field getDefaultFOV fun()
--- @field getDynamicSpawnSettings fun(id, isAirdrome)
--- @field getFarpsAndCarriersMissionData fun()
--- @field getGameDuration fun()
--- @field getGamePattern fun()
--- @field getGeneratedParams fun()
--- @field getHumanUnitInputName fun()
--- @field getInputProfiles fun()
--- @field getInstalledTheatres fun()
--- @field getLogHistory fun()
--- @field getMacConquestStatData fun()
--- @field getMainPilot fun()
--- @field getManualPath fun():string
--- @field getMaxFPS fun()
--- @field getMissionDescription fun():string
--- @field getMissionFilename fun():string Returns the file name of the current mission file.
--- @field getMissionLoaded fun()
--- @field getMissionName fun():string Returns the name of the current mission.
--- @field getMissionOptions fun():table Returns the table of options for the current mission.
--- @field getMissionResourcesDialogData fun()
--- @field getMissionResult fun(side:string):number Returns the current result for a given coalition as defined by mission goals.
--- @field getMissionTheatre fun()
--- @field getModelNameByShapeTableIndex fun()
--- @field getModelTime fun():number Returns the DCS simulation time in seconds since the game started.
--- @field getMoonAzimuthElevationPhase fun()
--- @field getObjectLiveriesNames fun()
--- @field getPause fun():boolean Returns the pause state of the server. True if paused, false otherwise.
--- @field getPilotAchievements fun()
--- @field getPilotStatistics fun()
--- @field getPilotsSummaryStatistics fun()
--- @field getPlayerBriefing fun():string
--- @field getPlayerCoalition fun():string
--- @field getPlayerUnit fun():string
--- @field getPlayerUnitType fun():string
--- @field getRealTime fun():number Returns the current time in a mission relative to the DCS start time.
--- @field getServerStartTime fun()
--- @field getServerStartTimeRemain fun()
--- @field getSimulatorMode fun()
--- @field getSunAzimuthElevation fun(lat, long, year, month, day, hour):number, number
--- @field getTaintedCategories fun()
--- @field getTaintedFiles fun()
--- @field getTheatreID fun()
--- @field getUnitProperty fun(unitId:number, propertyId:string):string Returns the specified property for the given unit.
--- @field getUnitType fun(missionId:number):string Returns the type of the unit identified by missionId.
--- @field getUnitTypeAttribute fun(typeName:string, attribute:string):string, number, table Returns the attribute of the specified type for the specified unit type.
--- @field getUserOptions fun()
--- @field hasMultipleSlots fun():boolean
--- @field haveAircraftInAirportWarehouse fun()
--- @field isAuthorizedPluginId fun(plugin:string):boolean
--- @field isHumanSeatAvailable fun()
--- @field isMultiplayer fun():boolean Returns whether the game is in multiplayer mode.
--- @field isRoleAvailable fun()
--- @field isServer fun():boolean Returns whether the game is running as a server or in single-player mode.
--- @field isSlotFlyable fun()
--- @field isSteamVersion fun()
--- @field isTrackPlaying fun():boolean
--- @field lockAllKeyboardInput fun()
--- @field lockAllMouseInput fun()
--- @field lockKeyboardInput fun()
--- @field lockMouseInput fun()
--- @field makeScreenShot fun(filename:string)
--- @field onShowDialog fun()
--- @field onShowStatusBar fun()
--- @field onUserLogin fun()
--- @field preloadCockpit fun()
--- @field refreshPilotStatistics fun()
--- @field reloadOptions fun()
--- @field reloadUserScripts fun()
--- @field restartMission fun()
--- @field selfKillPilot fun()
--- @field sendRCD_Callback fun()
--- @field setBoardNumResourcesDialogData fun()
--- @field setCameraToAirdrome fun()
--- @field setCurrentFOV fun()
--- @field setDebriefingShow fun()
--- @field setDefaultFOV fun()
--- @field setKeyboardCapture fun(toggle:boolean)
--- @field setLiveryNameResourcesDialogData fun()
--- @field setMainPilot fun()
--- @field setMaxFPS fun()
--- @field setMissionResourcesDialogData fun()
--- @field setMouseCapture fun(toggle:boolean)
--- @field setNeedRestartApplication fun()
--- @field setPause fun(action:boolean) Pauses or resumes the simulation. Server-side only.
--- @field setPlayerCoalition fun(coalition_id:number)
--- @field setPlayerUnit fun(misId:number)
--- @field setScreenShotExt fun()
--- @field setUserCallbacks fun(hook:Hook) Adds functions to be run for specified GameGUI events.
--- @field setViewPause fun(toggle:boolean)
--- @field setViewRearm fun()
--- @field setViewRearmAnimationTime fun()
--- @field setViewRearmPositionType fun()
--- @field spawnPlayer fun()
--- @field stopMission fun() Commands to stop the mission.
--- @field takeTrackControl fun()
--- @field unlockKeyboardInput fun()
--- @field unlockMouseInput fun()
--- @field unsetViewRearm fun()
--- @field writeDebriefing fun()
--- @type DCS
DCS = {}

------------------------------------------------------------------------------
--- Hook callbacks
------------------------------------------------------------------------------

--- @class Hook
--- @description helper class for hook callbacks
--- @field onMissionLoadBegin fun() Occurs when a server begins loading a mission. 
--- @field onMissionLoadProgress fun(progress:string, message:string) While a mission is loading this callback will contain information about the loading progress. 
--- @field onMissionLoadEnd fun() Occurs when a server finishes loading a mission. 
--- @field onSimulationStart fun() Occurs when loading is finished and the mission is fully initialized. On an install with rendering it is effectively when you enter the "3d world" of the game and the mission is ready to be unpaused.
--- @field onSimulationStop fun() Occurs when exiting the simulation. Effectively is when the user goes from the 3d game world the the UI.
--- @field onSimulationFrame fun() Occurs constantly as the simulation is running. This function runs extremely fast, several hundred times a second. It is highly recommended to put in checks to limit how often code can run from this function.
--- @field onSimulationPause fun() Occurs when the mission is paused.
--- @field onSimulationResume fun() Occurs when the mission is resumed.
--- @field onGameEvent fun()
--- @field onNetConnect fun()
--- @field onNetDisconnect fun()
--- @field onNetMissionChanged fun()
--- @field onPlayerConnect fun(id:number) Occurs when a player connects to a server. Passed id value is a simple unique identifier that is used with network functions to get other information about that player or actions like kicking them from the server.
--- @field onPlayerDisconnect fun(id:number) Occurs when a player disconnects from a server.
--- @field onPlayerStart fun(id:number) Occurs when a player has fully loaded into the simulation and can select a slot.
--- @field onPlayerStop fun(id:number) Occurs just before onPlayerDisconnect if the user chose to leave the server.
--- @field onPlayerChangeSlot fun(id:number) Occurs when a player successfully moves into a new slot. This will not be called for example if they try to RIO for a player and the pilot rejects the request.
--- @field onPlayerTryConnect fun(addr:string, ucid:string, name:string, playerId:number) Occurs when a player initially attempts to connect to the server. Can be used to force allow or deny access. Passed values are the users ip address, unique DCS identifier, their name, and the id that the player would have if they connected. Return value 1: true=allow, false=reject, value 2: message
--- @field onPlayerTrySendChat fun(playerId:number, message:string, all:boolean) Occurs when a player attempts to send a chat message. Return value: filtered message
--- @field onPlayerTryChangeSlot fun(playerId:number, side:number, slot:string) Occurs when a player attempts to change slots. Return value: true=allow, false=reject
