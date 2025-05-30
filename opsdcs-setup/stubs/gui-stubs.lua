------------------------------------------------------------------------------
--- GUI ENV
--- used by scripts in Scripts/Hooks and net.dostring_in("gui", ..)
--- see also: DCS World\API\DCS_ControlAPI.md
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
--- @field HMD_isActive fun()
--- @field LMSGetRemainingTimeBeforeZoneShrink fun()
--- @field LMSRestart fun()
--- @field LMSSetWaitForMinimalPlayers fun()
--- @field MACSavePSData fun()
--- @field RCD_selectMenuItem fun()
--- @field S_EVENT_AI_ABORT_MISSION number @38
--- @field S_EVENT_BASE_CAPTURED number @10
--- @field S_EVENT_BDA number @37
--- @field S_EVENT_BIRTH number @15
--- @field S_EVENT_CRASH number @5
--- @field S_EVENT_DAYNIGHT number @39
--- @field S_EVENT_DEAD number @8
--- @field S_EVENT_DETAILED_FAILURE number @17
--- @field S_EVENT_DISCARD_CHAIR_AFTER_EJECTION number @33
--- @field S_EVENT_EJECTION number @6
--- @field S_EVENT_EMERGENCY_LANDING number @43
--- @field S_EVENT_ENGINE_SHUTDOWN number @19
--- @field S_EVENT_ENGINE_STARTUP number @18
--- @field S_EVENT_FLIGHT_TIME number @40
--- @field S_EVENT_HIT number @2
--- @field S_EVENT_HUMAN_AIRCRAFT_REPAIR_FINISH number @60
--- @field S_EVENT_HUMAN_AIRCRAFT_REPAIR_START number @59
--- @field S_EVENT_HUMAN_FAILURE number @16
--- @field S_EVENT_INVALID number @0
--- @field S_EVENT_KILL number @28
--- @field S_EVENT_LAND number @4
--- @field S_EVENT_LANDING_AFTER_EJECTION number @31
--- @field S_EVENT_LANDING_QUALITY_MARK number @36
--- @field S_EVENT_MAC_EXTRA_SCORE number @51
--- @field S_EVENT_MAC_LMS_RESTART number @56
--- @field S_EVENT_MARK_ADDED number @25
--- @field S_EVENT_MARK_CHANGE number @26
--- @field S_EVENT_MARK_REMOVED number @27
--- @field S_EVENT_MAX number @61
--- @field S_EVENT_MISSION_END number @12
--- @field S_EVENT_MISSION_RESTART number @52
--- @field S_EVENT_MISSION_START number @11
--- @field S_EVENT_MISSION_WINNER number @53
--- @field S_EVENT_PARATROOPER_LENDING number @32
--- @field S_EVENT_PILOT_DEAD number @9
--- @field S_EVENT_PLAYER_CAPTURE_AIRFIELD number @42
--- @field S_EVENT_PLAYER_COMMENT number @22
--- @field S_EVENT_PLAYER_ENTER_UNIT number @20
--- @field S_EVENT_PLAYER_LEAVE_UNIT number @21
--- @field S_EVENT_PLAYER_SELF_KILL_PILOT number @41
--- @field S_EVENT_REFUELING number @7
--- @field S_EVENT_REFUELING_STOP number @14
--- @field S_EVENT_RUNWAY_TAKEOFF number @54
--- @field S_EVENT_RUNWAY_TOUCH number @55
--- @field S_EVENT_SCORE number @29
--- @field S_EVENT_SHOOTING_END number @24
--- @field S_EVENT_SHOOTING_START number @23
--- @field S_EVENT_SHOT number @1
--- @field S_EVENT_SIMULATION_FREEZE number @57
--- @field S_EVENT_SIMULATION_START number @46
--- @field S_EVENT_SIMULATION_UNFREEZE number @58
--- @field S_EVENT_TAKEOFF number @3
--- @field S_EVENT_TOOK_CONTROL number @13
--- @field S_EVENT_TRIGGER_ZONE number @35
--- @field S_EVENT_UNIT_CREATE_TASK number @44
--- @field S_EVENT_UNIT_DELETE_TASK number @45
--- @field S_EVENT_UNIT_LOST number @30
--- @field S_EVENT_UNIT_TASK_COMPLETE number @49
--- @field S_EVENT_UNIT_TASK_STAGE number @50
--- @field S_EVENT_WEAPON_ADD number @34
--- @field S_EVENT_WEAPON_DROP number @48
--- @field S_EVENT_WEAPON_REARM number @47
--- @field UIDeclutterOnOff fun()
--- @field UIRequestOverlayWidgetPosition fun()
--- @field UNIT_CALLSIGN number @9
--- @field UNIT_CATEGORY number @5
--- @field UNIT_COALITION number @11
--- @field UNIT_COUNTRY_ID number @12
--- @field UNIT_GROUPCATEGORY number @8
--- @field UNIT_GROUPNAME number @7
--- @field UNIT_GROUP_MISSION_ID number @6
--- @field UNIT_HIDDEN number @10
--- @field UNIT_INVISIBLE_MAP_ICON number @16
--- @field UNIT_MISSION_ID number @2
--- @field UNIT_NAME number @3
--- @field UNIT_PLAYER_NAME number @14
--- @field UNIT_ROLE number @15
--- @field UNIT_RUNTIME_ID number @1
--- @field UNIT_TASK number @13
--- @field UNIT_TYPE number @4
--- @field activateGroup fun()
--- @field activateSteamOverlayToStore fun()
--- @field add_dyn_group fun()
--- @field checkMultiplayerSpawnConflict fun(takeOffType, id, unitId, type)
--- @field conquestCoalitionsScore fun()
--- @field create_client_aircraft fun()
--- @field dModeFinish number @6
--- @field dModeInit number @0
--- @field dModePostStart number @3
--- @field dModeStart number @2
--- @field dModeStop number @5
--- @field dModeUser number @1
--- @field dModeWork number @4
--- @field dispatchAnalogAction fun()
--- @field dispatchDigitalAction fun()
--- @field enter_with_dyngroup fun()
--- @field exitProcess fun() @Commands to close the DCS application.
--- @field exportToMiz fun(filename:string) @Exports the current mission to a .miz file.
--- @field getATCradiosData fun()
--- @field getAchievementsUiInfo fun()
--- @field getAirTankerID fun()
--- @field getAircraftAmountInAirportWarehouse fun(type, id, isAirdrome)
--- @field getAirdromesCoalition fun()
--- @field getAirdromesState fun()
--- @field getAvailableCoalitions fun():table @Returns a list of coalitions with client slots available.
--- @field getAvailableSlots fun(coaId:number|string):table @Returns a table of slots available to a given coalition. array of {unitId, type, role, callsign, groupName, country}. the returned unitID is actually a slotID, which for multi-seat units is 'unitID_seatID'
--- @field getConfigValue fun(cfg_path_string) @Reads a value from config state.
--- @field getConquestAirbaseState fun()
--- @field getCurrentFOV fun()
--- @field getCurrentMission fun():table @Returns the table of the mission as stored in the mission file.
--- @field getDefaultFOV fun()
--- @field getDynamicSpawnSettings fun(id, isAirdrome)
--- @field getFarpsAndCarriersMissionData fun()
--- @field getGameDuration fun()
--- @field getGamePattern fun()
--- @field getGeneratedParams fun()
--- @field getHumanUnitInputName fun()
--- @field getInputNameByUnitType fun()
--- @field getInputProfiles fun()
--- @field getInstalledTheatres fun()
--- @field getLogHistory fun(from) @Returns last log messages starting from a given index. logHistory, logIndex = DCS.getLogHistory(logIndex)
--- @field getMainPilot fun()
--- @field getManualPath fun():string
--- @field getMaxFPS fun()
--- @field getMissionDescription fun():string
--- @field getMissionFilename fun():string @Returns the file name of the current mission file.
--- @field getMissionLoaded fun()
--- @field getMissionName fun():string @Returns the name of the current mission.
--- @field getMissionOptions fun():table @Returns the table of options for the current mission.
--- @field getMissionResourcesDialogData fun()
--- @field getMissionResult fun(side:string):number @Returns the current result for a given coalition as defined by mission goals.
--- @field getMissionTheatre fun()
--- @field getModelNameByShapeTableIndex fun()
--- @field getModelTime fun():number @Returns the DCS simulation time in seconds since the game started.
--- @field getMoonAzimuthElevationPhase fun()
--- @field getObjectLiveriesNames fun()
--- @field getPause fun():boolean @Returns the pause state of the server. True if paused, false otherwise.
--- @field getPilotAchievements fun()
--- @field getPilotStatistics fun()
--- @field getPilotsSummaryStatistics fun()
--- @field getPlayerBriefing fun():string
--- @field getPlayerCoalition fun():string
--- @field getPlayerUnit fun():string
--- @field getPlayerUnitType fun():string
--- @field getRealTime fun():number @Returns the current time in a mission relative to the DCS start time.
--- @field getServerStartTime fun()
--- @field getServerStartTimeRemain fun()
--- @field getSimulatorMode fun()
--- @field getSunAzimuthElevation fun(lat, long, year, month, day, hour):number, number
--- @field getTaintedCategories fun()
--- @field getTaintedFiles fun()
--- @field getTheatreID fun()
--- @field getUnitProperty fun(unitId:number, propertyId:string):string @Returns the specified property for the given unit. (see UNIT_ properties above)
--- @field getUnitType fun(missionId:number):string @Returns the type of the unit identified by missionId. a shortcut for DCS.getUnitProperty(missionId, DCS.UNIT_TYPE)
--- @field getUnitTypeAttribute fun(typeId:string, attribute:string):string, number, table Returns the attribute of the specified type for the specified unit type. Returns a value from Database: Objects[typeId][attr]. e.g: DCS.getUnitTypeAttribute("Ural", "DisplayName")
--- @field getUserOptions fun()
--- @field hasMultipleSlots fun():boolean
--- @field isHumanSeatAvailable fun()
--- @field isMetricSystem fun()
--- @field isMultiplayer fun():boolean @Returns whether the game is in multiplayer mode.
--- @field isRoleAvailable fun()
--- @field isServer fun():boolean @Returns whether the game is running as a server or in single-player mode.
--- @field isSlotFlyable fun()
--- @field isSteamVersion fun()
--- @field isSupercarrierRoleAvailable fun()
--- @field isTrackPlaying fun():boolean
--- @field lockAllKeyboardInput fun()
--- @field lockAllMouseInput fun()
--- @field lockKeyboardInput fun()
--- @field lockMouseInput fun()
--- @field makeScreenShot fun(filename:string)
--- @field onShowDialog fun()
--- @field onShowStatusBar fun()
--- @field onUserLogin fun()
--- @field openHomePage fun()
--- @field preloadCockpit fun()
--- @field refreshPilotStatistics fun()
--- @field reloadOptions fun()
--- @field reloadUserScripts fun()
--- @field restartMission fun()
--- @field saveMissionTo fun(filename:string, saveMission:function, pathOrigMiz:filename) @saves mission to filename (saveMission gets called with miz object for modifications)
--- @field selfKillPilot fun()
--- @field sendRCD_Callback fun()
--- @field setBoardNumResourcesDialogData fun()
--- @field setCameraToAirdrome fun()
--- @field setCurrentFOV fun(fov:number)
--- @field setDebriefingShow fun()
--- @field setDefaultFOV fun()
--- @field setLiveryNameResourcesDialogData fun()
--- @field setMainPilot fun()
--- @field setMaxFPS fun()
--- @field setMissionResourcesDialogData fun()
--- @field setNeedRestartApplication fun()
--- @field setPause fun(paused:boolean) @Pauses or resumes the simulation. Server-side only.
--- @field setPlayerCoalition fun(coalition_id:number)
--- @field setPlayerUnit fun(misId:number)
--- @field setScreenShotExt fun()
--- @field setUserCallbacks fun(hook:Hook) @Adds functions to be run for specified GameGUI events.
--- @field setViewPause fun(toggle:boolean)
--- @field setViewRearm fun()
--- @field setViewRearmAnimationTime fun()
--- @field setViewRearmPositionType fun()
--- @field spawnPlayer fun()
--- @field stopMission fun() @Commands to stop the mission.
--- @field takeTrackControl fun()
--- @field toggleDTC fun(unitType:string|nil, onOff:boolean, unknown:boolean)
--- @field unlockKeyboardInput fun()
--- @field unlockMouseInput fun()
--- @field unsetViewRearm fun()
--- @field updaterOperation fun()
--- @field writeDebriefing fun(str) @Writes a custom string to the debriefing file
--- @type DCS
DCS = {}

------------------------------------------------------------------------------
--- Hook callbacks
------------------------------------------------------------------------------

--- @class Hook
--- @description helper class for hook callbacks
--- @field onMissionLoadBegin fun() @Occurs when a server begins loading a mission. 
--- @field onMissionLoadProgress fun(progress:string, message:string) @While a mission is loading this callback will contain information about the loading progress. 
--- @field onMissionLoadEnd fun() @Occurs when a server finishes loading a mission. 
--- @field onSimulationStart fun() @Occurs when loading is finished and the mission is fully initialized. On an install with rendering it is effectively when you enter the "3d world" of the game and the mission is ready to be unpaused.
--- @field onSimulationStop fun() @Occurs when exiting the simulation. Effectively is when the user goes from the 3d game world the the UI.
--- @field onSimulationFrame fun() @Occurs constantly as the simulation is running. This function runs extremely fast, several hundred times a second. It is highly recommended to put in checks to limit how often code can run from this function.
--- @field onSimulationPause fun() @Occurs when the mission is paused.
--- @field onSimulationResume fun() @Occurs when the mission is resumed.
--- @field onGameEvent fun()
--- @field onNetConnect fun()
--- @field onNetDisconnect fun()
--- @field onNetMissionChanged fun()
--- @field onPlayerConnect fun(id:number) @Occurs when a player connects to a server. Passed id value is a simple unique identifier that is used with network functions to get other information about that player or actions like kicking them from the server.
--- @field onPlayerDisconnect fun(id:number) @Occurs when a player disconnects from a server.
--- @field onPlayerStart fun(id:number) @Occurs when a player has fully loaded into the simulation and can select a slot.
--- @field onPlayerStop fun(id:number) @Occurs just before onPlayerDisconnect if the user chose to leave the server.
--- @field onPlayerChangeSlot fun(id:number) @Occurs when a player successfully moves into a new slot. This will not be called for example if they try to RIO for a player and the pilot rejects the request.
--- @field onPlayerTryConnect fun(addr:string, ucid:string, name:string, playerId:number) @Occurs when a player initially attempts to connect to the server. Can be used to force allow or deny access. Passed values are the users ip address, unique DCS identifier, their name, and the id that the player would have if they connected. Return value 1: true=allow, false=reject, value 2: message
--- @field onPlayerTrySendChat fun(playerId:number, message:string, all:boolean) @Occurs when a player attempts to send a chat message. Return value: filtered message
--- @field onPlayerTryChangeSlot fun(playerId:number, side:number, slot:string) @Occurs when a player attempts to change slots. Return value: true=allow, false=reject
--- @field onTriggerMessage fun(message:string, duration:number)
--- @field onRadioMessage fun(message:string, duration:number)
--- @field onRadioCommand fun(command_message)
--- @field onShowMainInterface fun()
--- @field onShowIntermission fun()
--- @field onShowGameMenu fun()?
--- @field onShowBriefing fun()
--- @field onShowChatAll fun()
--- @field onShowChatTeam fun()
--- @field onShowScores fun()
--- @field onShowResources fun()
--- @field onShowGameInfo fun(a_text, a_duration)
--- @field onShowMessage fun(text, type)  
--- @field onShowChatPanel fun()
--- @field onHideChatPanel fun()
--- @field onServerRegistrationFail fun(code)
--- @field onShowRadioMenu fun(size)
--- @field onWebServerRequest fun() @handler for web server requests (default port 8088)
