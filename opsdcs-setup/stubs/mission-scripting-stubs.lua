------------------------------------------------------------------------------
--- MISSION SCRIPTING ENV
--- used by DO SCRIPT in ME and a_do_script() in mission env
------------------------------------------------------------------------------

--- @type log
log = {}

------------------------------------------------------------------------------
--- Utility classes
------------------------------------------------------------------------------

--- @class vec2
--- @field x number @distance north-south
--- @field y number @distance east-west

--- @class vec3
--- @field x number @distance north-south
--- @field y number @distance above height 0
--- @field z number @distance east-west

--- @class Position3
--- @field p vec3 @position
--- @field x vec3 @forward direction vector
--- @field y vec3 @upward direction vector
--- @field z vec3 @right direction vector

--- @class Box3
--- @field min vec3
--- @field max vec3

--- @class TriggerZone
--- @field point vec3
--- @field radius number

--- @class MGRS
--- @field UTMZone string
--- @field MGRSDigraph string
--- @field Easting number
--- @field Northing number

------------------------------------------------------------------------------
--- env
------------------------------------------------------------------------------

--- @class env
--- @description env contains basic logging functions useful for debugging scripting commands. The input text is automatically added to dcs.log in your saved games folder
--- @field info fun(log:string, showMessageBox:boolean) @Prints the passed string to the dcs.log with a prefix of 'info'. The optional variable defines whether or not a message box will pop up when the logging occurs
--- @field warning fun(log:string, showMessageBox:boolean) @Prints the passed string to the dcs.log with a prefix of 'warning'. The optional variable defines whether or not a message box will pop up when the logging occurs.
--- @field error fun(log:string, showMessageBox:boolean) @Prints the passed string to the dcs.log with a prefix of 'error'. The optional variable defines whether or not a message box will pop up when the logging occurs.
--- @field setErrorMessageBoxEnabled fun(toggle:boolean) @Sets the value for whether or not an error message box will be displayed if a lua error occurs. By default the error message box will appear.
--- @field getValueDictByKey fun(value:string):string @Returns a string associated with the passed dictionary key value. If the key is not found within the miz the function will return the string that was passed.
--- @field mission env.mission @The mission file is a lua table present within a .miz file that is accessible to the scripting engine via the table env.mission. This table is almost the entirety of the contents of a given mission.
--- @field warehouses env.warehouses @The warehouses file is a lua table present within a .miz file that is accessible to the scripting engine.
--- @type env
env = {}

--- @class env.mission
--- @description helper class for env.mission table
--- @field coalition table @Contains all coalition specific data including bullseye, nav_points, and all units.
--- @field coalitions table @Contains a list of country ids that belong to a given coalition.
--- @field currentKey number @Value used by the editor to know what index the dictkey and reskeys are on.
--- @field date table @The date the mission takes place at with Year, Month, and Day entries.
--- @field descriptionText string @Mission briefing defined under the "Situation" page on the briefing panel.
--- @field descriptionBlueTask string @Blue coalition task defined on the briefing panel.
--- @field descriptionNeutralsTask string @Neutral coalition task defined on the briefing panel.
--- @field descriptionRedTask string @Red coalition task defined on the briefing panel.
--- @field drawings env.mission.drawings @able containing information on any drawing placed in the editor.
--- @field failures table @Only valid for single player missions. Lists failure parameters for whichever aircraft is set to player. If none are set to player it still populates.
--- @field forcedOptions table @Options that are forced by the mission and their corresponding settings.
--- @field groundControl table @Data on the number of Combined Arms slots and their respective coalitions is found here.
--- @field map table @Last position of the map view the user was looking at when the mission was saved.
--- @field maxDictId number @Internal value used to keep track of what the next unit and group id to use is.
--- @field pictureFileNameN table @Neutral coalition briefing images.
--- @field pictureFileNameB table @Blue coalition briefing images.
--- @field pictureFileNameR table @Red coalition briefing images.
--- @field requiredModules table @Table of mod names whose units are present within the mission.
--- @field result table @Conditions and actions defined by mission goals in the editor to decide if a mission is "won".
--- @field start_time number @Time in seconds since midnight for the date set when the mission starts.
--- @field sortie string @Name of the mission as defined in the briefing panel.
--- @field theatre string @Name of the map the mission takes place on.
--- @field triggers env.mission.triggers @Contains table of trigger zones.
--- @field trig env.mission.trig @Table containing every single trigger (actions, conditions, events, flag, func).
--- @field trigrules trigrule[] @Another table containing data on triggers (actions, predicate, eventlist, rules).
--- @field version number @Value used by the mission editor to know roughly which iteration of the editor the mission was saved in. Used for compatibility warning messages if you open a newer mission in an older editor.
--- @field weather table @Table with weather data.
--- @type env.mission
env.mission = {}

--- @class env.mission.drawings
---
--- @type env.mission.drawings
env.mission.drawings = {}

--- @class env.mission.triggers
--- @description contains table of trigger zones
--- @field zones zone[] @Table of trigger zones indexed numerically.
--- @type env.mission.triggers
env.mission.triggers = {}

--- @class zone
--- @description helper class for mission trigger zone
--- @field color table
--- @field heading number
--- @field hidden boolean
--- @field name string
--- @field properties table
--- @field radius number
--- @field type number
--- @field x number
--- @field y number
--- @field zoneId number
--- @type zone[]
env.mission.triggers.zones = {}

--- @class env.mission.trig
--- @description contains triggers
--- @field actions table @actions lua, alphanumeric indexed
--- @field conditions table @conditions lua, alphanumeric indexed
--- @field custom table
--- @field customStartup table
--- @field events table
--- @field flag table @flags
--- @field func table @condition/action lua functions, alphanumeric indexed
--- @field funcStartup table @startup condition/action lua functions, alphanumeric indexed
--- @type env.mission.trig
env.mission.trig = {}

--- @class trigrule
--- @description mission trigrule
--- @field actions table @action objects, alphanumeric indexed
--- @field comment string
--- @field eventlist string
--- @field predicate string @trigger, triggerOnce, triggerContinious, triggerStart, triggerFront
--- @field rules table @rule objects, alphanumeric indexed
--- @type trigrule[]
env.mission.trigrules = {}

--- @class env.warehouses
--- @description env.warehouses table
--- @field airports warehousesAirport[] @array of airports
--- @field warehouses warehousesWarehouse[] @array of warehouses
--- @type env.warehouses
env.warehouses = {}

--- @class warehousesAirport
--- @description mission airports
--- @field aircrafts table
--- @field coalition table
--- @field diesel table
--- @field gasoline table
--- @field jet_fuel table
--- @field methanol_mixture table
--- @field OperatingLevel_Air number
--- @field OperatingLevel_Eqp number
--- @field OperatingLevel_Fuel number
--- @field periodicity number
--- @field size number
--- @field speed number
--- @field suppliers table
--- @field unlimitedAircrafts boolean
--- @field unlimitedFuel boolean
--- @field unlimitedMunitions boolean
--- @field weapons table
--- @type warehousesAirport[]
env.warehouses.airports = {}

--- @class warehousesWarehouse
--- @description mission warehouses
--- @todo
--- @type warehousesWarehouse[]
env.warehouses.warehouses = {}

------------------------------------------------------------------------------
--- timer
------------------------------------------------------------------------------

--- @class timer
--- @descriptionThe timer singleton has two important uses. 1. Return the mission time. 2. To schedule functions.
--- @field getAbsTime fun():number @Returns the game world time in seconds since the mission started. If the value is above 86400, it represents the next day after the mission started.
--- @field getPause fun()
--- @field getTime fun():number @Returns the model time in seconds to three decimal places since the mission has started. Time pauses with the game.
--- @field getTime0 fun():number @Returns the mission start time in seconds. Useful for calculating elapsed time with timer.getAbsTime().
--- @field removeFunction fun(functionId:number) @Removes a scheduled function by its functionId, preventing it from executing.
--- @field scheduleFunction fun(functionToCall:function, functionArgs:any, modelTime:number):number @Schedules a function to run at a specified future model time. Returns a functionId.
--- @field setFunctionTime fun(functionId:number, modelTime:number) @Reschedules an already scheduled function to run at a different model time.
--- @type timer
timer = {}

------------------------------------------------------------------------------
--- land
------------------------------------------------------------------------------

--- @class land
--- @description The land singleton contains functions used to get information about the terrain geometry of a given map. Functions include getting data on the type and height of terrain at a specific points and raytracing functions.
--- @field findPathOnRoads fun(roadType:string, xCoord:number, yCoord:number, destX:number, destY:number):table @Returns a path as a table of vec2 points from a start to a destination along specified road type.
--- @field getClosestPointOnRoads fun(roadType:string, xCoord:number, yCoord:number):number, number @Returns the closest road coordinate (x, y) from a given point based on specified road type ('roads' or 'railroads').
--- @field getHeight fun(point:vec2):number @Returns the distance from sea level (y-axis) at a given vec2 point.
--- @field getIP fun(origin:vec3, direction:vec3, distance:number):vec3 @Returns an intercept point where a ray from origin in the specified direction for a given distance intersects with terrain.
--- @field getSurfaceHeightWithSeabed fun(point:vec2):number, number @Returns both the surface height and the seabed depth at a point.
--- @field getSurfaceType fun(point:vec2):number @Returns an enumerator indicating the surface type at a given vec2 point. (returns land.SurfaceType)
--- @field isVisible fun(origin:vec3, destination:vec3):boolean @Determines if a line from origin to destination intersects terrain, used for line of sight.
--- @field profile fun(start:vec3, end:vec3):table @Returns a profile of the land between two points as a table of vec3 vectors.
--- @type land
land = {}

--- @class land.SurfaceType
--- @description surface types
--- @field LAND number @Land (1)
--- @field SHALLOW_WATER number @Shallow Water (2)
--- @field WATER number @Water (3)
--- @field ROAD number @Road (4)
--- @field RUNWAY number @Runway (5)
--- @type land.SurfaceType
land.SurfaceType = {}

------------------------------------------------------------------------------
--- atmosphere
------------------------------------------------------------------------------

--- @class atmosphere
--- @description atmosphere is a singleton whose functions return atmospheric data about the mission. Currently limited only to wind data.
--- @field getTemperatureAndPressure fun(point:vec3):number, number @Returns the temperature (Kelvins) and pressure (Pascals) at a given 3D point.
--- @field getWind fun(point:vec3):vec3 @Returns a velocity vector of the wind at a specified 3D point.
--- @field getWindWithTurbulence fun(point:vec3):vec3 @Returns a velocity vector of the wind at a specified 3D point, including effects of turbulence.
--- @type atmosphere
atmosphere = {}

------------------------------------------------------------------------------
--- world
------------------------------------------------------------------------------

--- @class world
--- @description The world singleton contains functions centered around two different but extremely useful functions. 1. Events and event handlers are all governed within world. 2. A number of functions to get information about the game world.
--- @field addEventHandler fun(handler:EventHandler) @Adds a function as an event handler that executes when a simulator event occurs.
--- @field getAirbases fun(coalitionId:number|nil):table @Returns a table of airbase objects for a specified coalition or all airbases if no coalition is specified. (coalition.side)
--- @field getMarkPanels fun():table @Returns a table of mark panels and shapes drawn within the mission.
--- @field getPersistenceData fun(name:string) @Read persistence data identified by name. Returns Lua-value stored in this miz/sav by a given name or nil if no value found.
--- @field getPlayer fun():Unit @Returns a table representing the single unit object in the game set as "Player".
--- @field onEvent fun(event:table) @Calls all world event handlers onEvent() with given event
--- @field removeEventHandler fun(handler:EventHandler) @Removes the specified event handler from handling events.
--- @field removeJunk fun(searchVolume:table):number @Searches a defined area to remove craters, wreckage, and debris within the volume, excluding scenery objects. (world.VolumeType)
--- @field searchObjects fun(category:table|number, searchVolume:table, handler:function, data:any):table @Searches a defined volume for specified objects and can execute a function on each found object. (Object.Category, world.VolumeType)
--- @field setPersistenceHandler fun(name:string, handler:function) @Registers a handler for generating persistent data when saving simulation state.
--- @field weather world.weather
--- @type world
world = {}

--- @class world.event
--- @description event types
--- @field S_EVENT_INVALID number @Invalid (0)
--- @field S_EVENT_SHOT number @Shot (1)
--- @field S_EVENT_HIT number @Hit (2)
--- @field S_EVENT_TAKEOFF number @Takeoff (3)
--- @field S_EVENT_LAND number @Land (4)
--- @field S_EVENT_CRASH number @Crash (5)
--- @field S_EVENT_EJECTION number @Ejection (6)
--- @field S_EVENT_REFUELING number @Refueling (7)
--- @field S_EVENT_DEAD number @Dead (8)
--- @field S_EVENT_PILOT_DEAD number @Pilot Dead (9)
--- @field S_EVENT_BASE_CAPTURED number @Base Captured (10)
--- @field S_EVENT_MISSION_START number @Mission Start (11)
--- @field S_EVENT_MISSION_END number @Mission End (12)
--- @field S_EVENT_TOOK_CONTROL number @Took Control (13)
--- @field S_EVENT_REFUELING_STOP number @Refueling Stop (14)
--- @field S_EVENT_BIRTH number @Birth (15) - works
--- @field S_EVENT_HUMAN_FAILURE number @Human Failure (16)
--- @field S_EVENT_DETAILED_FAILURE number @Detailed Failure (17)
--- @field S_EVENT_ENGINE_STARTUP number @Engine Startup (18)
--- @field S_EVENT_ENGINE_SHUTDOWN number @Engine Shutdown (19)
--- @field S_EVENT_PLAYER_ENTER_UNIT number @Player Enter Unit (20)
--- @field S_EVENT_PLAYER_LEAVE_UNIT number @Player Leave Unit (21) - works
--- @field S_EVENT_PLAYER_COMMENT number @Player Comment (22)
--- @field S_EVENT_SHOOTING_START number @Shooting Start (23)
--- @field S_EVENT_SHOOTING_END number @Shooting End (24)
--- @field S_EVENT_MARK_ADDED number @Mark Added (25)
--- @field S_EVENT_MARK_CHANGE number @Mark Change (26)
--- @field S_EVENT_MARK_REMOVED number @Mark Removed (27)
--- @field S_EVENT_KILL number @Kill (28)
--- @field S_EVENT_SCORE number @Score (29)
--- @field S_EVENT_UNIT_LOST number @Unit Lost (30)
--- @field S_EVENT_LANDING_AFTER_EJECTION number @Landing After Ejection (31)
--- @field S_EVENT_PARATROOPER_LENDING number @Paratrooper Lending (32)
--- @field S_EVENT_DISCARD_CHAIR_AFTER_EJECTION number @Discard Chair After Ejection (33)
--- @field S_EVENT_WEAPON_ADD number @Weapon Add (34) - works NOT
--- @field S_EVENT_TRIGGER_ZONE number @Trigger Zone (35) - works NOT
--- @field S_EVENT_LANDING_QUALITY_MARK number @Landing Quality Mark (36)
--- @field S_EVENT_BDA number @BDA (37)
--- @field S_EVENT_AI_ABORT_MISSION number @AI Abort Mission (38)
--- @field S_EVENT_DAYNIGHT number @Day/Night (39)
--- @field S_EVENT_FLIGHT_TIME number @Flight Time (40)
--- @field S_EVENT_PLAYER_SELF_KILL_PILOT number @Player Self Kill Pilot (41)
--- @field S_EVENT_PLAYER_CAPTURE_AIRFIELD number @Player Capture Airfield (42)
--- @field S_EVENT_EMERGENCY_LANDING number @Emergency Landing (43)
--- @field S_EVENT_UNIT_CREATE_TASK number @Unit Create Task (44) - works NOT
--- @field S_EVENT_UNIT_DELETE_TASK number @Unit Delete Task (45) - works NOT
--- @field S_EVENT_SIMULATION_START number @Simulation Start (46)
--- @field S_EVENT_WEAPON_REARM number @Weapon Rearm (47) - works NOT in server
--- @field S_EVENT_WEAPON_DROP number @Weapon Drop (48)
--- @field S_EVENT_UNIT_TASK_COMPLETE number @Unit Task Complete (49) - works NOT
--- @field S_EVENT_UNIT_TASK_STAGE number @Unit Task Stage (50) - works NOT
--- @field S_EVENT_MAC_EXTRA_SCORE number @MAC Extra Score (51)
--- @field S_EVENT_MISSION_RESTART number @Mission Restart (52)
--- @field S_EVENT_MISSION_WINNER number @Mission Winner (53)
--- @field S_EVENT_RUNWAY_TAKEOFF number @Runway Takeoff (54)
--- @field S_EVENT_RUNWAY_TOUCH number @Runway Touch (55)
--- @field S_EVENT_MAC_LMS_RESTART number @MAC LMS Restart (56)
--- @field S_EVENT_SIMULATION_FREEZE number @Simulation Freeze (57) - works
--- @field S_EVENT_SIMULATION_UNFREEZE number @Simulation Unfreeze (58) - works
--- @field S_EVENT_HUMAN_AIRCRAFT_REPAIR_START number @Human Aircraft Repair Start (59)
--- @field S_EVENT_HUMAN_AIRCRAFT_REPAIR_FINISH number @Human Aircraft Repair Finish (60)
--- @field S_EVENT_MAX number @Max (61)
--- @type world.event
world.event = {}

--- @class world.weather
--- @field getFogThickness fun():number @Get the current fog thickness in meters. Returns zero if fog is not present.
--- @field getFogVisibilityDistance fun():number @Get the current maximum visibility distance in meters. Returns zero if fog is not present.
--- @field setFogAnimation fun(...) @Sets fog animation keys. Time is set in seconds and relative to the current simulation time, where time=0 is the current moment. Time must be increasing. Previous animation is always discarded despite the data being correct.
--- @field setFogThickness fun(thickness:number) @Instantly sets fog thickness in meters. The current fog animation is always discarded. Set zero to disable the fog. Actual limits: [100; 5000]
--- @field setFogVisibilityDistance fun(visibility:number) @Instantly sets the maximum visibility distance of fog at sea level when looking at the horizon. In meters. The current fog animation is always discarded. Set zero to disable the fog. Actual limits: [100, 100;000]

--- @class world.BirthPlace
--- @description birth places
--- @field wsBirthPlace_Air number @Air (1)
--- @field wsBirthPlace_Ship number @Ship (3)
--- @field wsBirthPlace_RunWay number @Runway (4)
--- @field wsBirthPlace_Park number @Park (5)
--- @field wsBirthPlace_Heliport_Hot number @Heliport Hot (9)
--- @field wsBirthPlace_Heliport_Cold number @Heliport Cold (10)
--- @field wsBirthPlace_Ship_Cold number @Ship Cold (11)
--- @field wsBirthPlace_Ship_Hot number @Ship Hot (12)
--- @type world.BirthPlace
world.BirthPlace = {}

--- @class world.VolumeType
--- @description volume types
--- @field SEGMENT number @Segment (0)
--- @field BOX number @Box (1)
--- @field SPHERE number @Sphere (2)
--- @field PYRAMID number @Pyramid (3)
--- @type world.VolumeType
world.VolumeType = {}

------------------------------------------------------------------------------
--- coalition
------------------------------------------------------------------------------

--- @class coalition
--- @description The coalition singleton contains functions that gets information on the all of the units within the mission. It also has two of the most powerful functions that are capable of spawning groups and static objects into the mission.
--- @field addGroup fun(countryId:number, groupCategory:number, groupData:table):Group @Adds a group of the specified category for the specified country using provided group data. (country.id, Group.Category)
--- @field addRefPoint fun(coalitionId:number, refPoint:table) @Adds a reference point for the specified coalition, used by JTACs. (coalition.side)
--- @field addStaticObject fun(countryId:number, groupData:table):StaticObject @Dynamically spawns a static object for the specified country based on the provided group data. (country.id)
--- @field add_dyn_group fun()
--- @field checkChooseCargo fun(unitId:number):boolean
--- @field checkDescent fun()
--- @field getAirbases fun(coalitionId:number|nil):table @Returns a table of airbase objects for the specified coalition or all airbases if no coalition is specified. (coalition.side)
--- @field getAllDescents fun(unitId:number, foo:boolean)
--- @field getCountryCoalition fun(countryId:number):number @Returns the coalition ID that a specified country belongs to. (country.id)
--- @field getDescentsOnBoard fun()
--- @field getGroups fun(coalitionId:number, groupCategory:number|nil):table @Returns a table of group objects within the specified coalition and optionally filtered by group category. (coalition.side)
--- @field getMainRefPoint fun(coalitionId:number):vec3 @Returns the position of the main reference point ("bullseye") for the specified coalition. (coalition.side)
--- @field getPlayers fun(coalitionId:number):table @Returns a table of unit objects currently occupied by players within the specified coalition. (coalition.side)
--- @field getRefPoints fun(coalitionId:number):table @Returns a table of reference points defined for the specified coalition, used by JTACs. (coalition.side)
--- @field getServiceProviders fun(coalitionId:number, service:number):table @Returns a table of unit objects that provide a specified service (ATC, AWACS, TANKER, FAC) within the specified coalition. (coalition.side, coalition.service)
--- @field getStaticObjects fun(coalitionId:number):table @Returns a table of static objects within the specified coalition. (coalition.side)
--- @field remove_dyn_group fun()
--- @type coalition
coalition = {}

--- @class coalition.side
--- @description coalition sides
--- @field NEUTRAL number @Neutral (0)
--- @field RED number @Red (1)
--- @field BLUE number @Blue (2)
--- @field ALL number @All (-1)
--- @type coalition.side
coalition.side = {}

--- @class coalition.service
--- @description coalition services
--- @field ATC number @ATC (0)
--- @field AWACS number @AWACS (1)
--- @field TANKER number @Tanker (2)
--- @field FAC number @FAC (3)
--- @type coalition.service
coalition.service = {}

------------------------------------------------------------------------------
--- trigger
------------------------------------------------------------------------------

--- @class trigger
--- @description The trigger singleton contains a number of functions that mimic actions and conditions found within the mission editor triggers.
--- @field action trigger.action @trigger actions
--- @field misc trigger.misc @some misc getters
--- @field smokeColor trigger.smokeColor @smoke colors
--- @field flareColor trigger.flareColor @flare colors
--- @type trigger
trigger = {}

--- @class trigger.smokeColor
--- @description smoke colors
--- @field Green number @Green (0)
--- @field Red number @Red (1)
--- @field White number @White (2)
--- @field Orange number @Orange (3)
--- @field Blue number @Blue (4)
--- @type trigger.smokeColor
trigger.smokeColor = {}

--- @class trigger.flareColor
--- @description flare colors
--- @field Green number @Green (0)
--- @field Red number @Red (1)
--- @field White number @White (2)
--- @field Yellow number @Yellow (3)
--- @type trigger.flareColor
trigger.flareColor = {}

--- @class trigger.action
--- @description trigger actions
--- @field activateGroup fun(Group:Group) @Activates the specified group if set up for "late activation."
--- @field addOtherCommand fun(name:string, userFlagName:string, userFlagValue:number) @Adds a command to the "F10 Other" radio menu to set flags within the mission.
--- @field addOtherCommandForCoalition fun(coalition:number, name:string, userFlagName:string, userFlagValue:string) @Adds a coalition-specific command to the "F10 Other" menu.
--- @field addOtherCommandForGroup fun(groupId:number, name:string, userFlagName:string, userFlagValue:string) @Adds a group-specific command to the "F10 Other" menu.
--- @field arrowToAll fun(coalition:number, id:number, startPoint:vec3, endPoint:vec3, color:table, fillColor:table, lineType:number, readOnly:boolean, message:string) @Creates an arrow on the F10 map. 0=no line, 1=solid, 2=dashed, 3=dotted, 4=dot dash, 5=long dash, 6=two dash
--- @field circleToAll fun(coalition:number, id:number, center:vec3, radius:number, color:table, fillColor:table, lineType:number, readOnly:boolean, message:string)
--- @field ctfColorTag fun(unitName:string, smokeColor:number) @Creates a smoke plume behind a specified aircraft. When passed 0 for smoke type the plume will be disabled. When triggering the on the same unit with a different color the plume will simply change color. (trigger.smokeColor)
--- @field deactivateGroup fun(Group:Group) @Deactivates the specified group.
--- @field effectSmokeBig fun(position:vec3, preset:number, density:number, name:string) @Creates a large smoke effect at a specified position with a specified preset (1-4=smoke/fire, 5-7=smoke), density (0-1), and name. (trigger.effectSmokePreset)
--- @field effectSmokeStop fun(name:string) @Stops a smoke effect with a specified name.
--- @field explosion fun(position:vec3, power:number) @Creates an explosion at a specified position with a specified power.
--- @field groupContinueMoving fun(Group:Group) @Orders the specified ground group to resume moving.
--- @field groupStopMoving fun(Group:Group) @Orders the specified ground group to stop moving.
--- @field illuminationBomb fun(position:vec3, power:number) @Creates an illumination bomb at a specified position with a specified power. (1-1000000)
--- @field lineToAll fun(coalition:number, id:number, startPoint:vec3, endPoint:vec3, color:table, lineType:number, readOnly:boolean, message:string) @Creates a line on the F10 map. 0=no line, 1=solid, 2=dashed, 3=dotted, 4=dot dash, 5=long dash, 6=two dash--- @field circleToAll fun(coalition:number, id:number, center:vec3, radius:number, color:table, fillColor:table, lineType:number, readOnly:boolean, message:string) Creates a circle on the F10 map.
--- @field markToAll fun(id:number, text:string, point:vec3, readOnly:boolean, message:string) @Adds a mark point to all on the F10 map.
--- @field markToCoalition fun(id:number, text:string, point:vec3, coalitionId:number, readOnly:boolean, message:string) @Adds a mark point to a coalition on the F10 map.
--- @field markToGroup fun(id:number, text:string, point:vec3, groupId:number, readOnly:boolean, message:string) @Adds a mark point to a group on the F10 map.
--- @field markupToAll fun(shapeId:number, coalition:number, id:number, point1:vec3, color:table, fillColor:table, lineType:number, readOnly:boolean, message:string) @Creates a defined shape on the F10 map. Additional points can be passed after "point1"
--- @field outSound fun(soundfile:string) @Plays a sound file to all players.
--- @field outSoundForCoalition fun(coalition:number, soundfile:string) @Plays a sound file to all players in the specified coalition.
--- @field outSoundForCountry fun(country:number, soundfile:string) @Plays a sound file to all players in the specified country.
--- @field outSoundForGroup fun(groupId:number, soundfile:string) @Plays a sound file to all players in the specified group.
--- @field outSoundForUnit fun(unitId:number, soundfile:string) @Plays a sound file to all players in the specified unit.
--- @field outText fun(text:string, displayTime:number, clearview?:boolean) @Displays text to all players for the specified time.
--- @field outTextForCoalition fun(coalition:number, text:string, displayTime:number, clearview:boolean) @Displays text to players in a specified coalition for a set time.
--- @field outTextForCountry fun(country:number, text:string, displayTime:number, clearview:boolean) @Displays text to players in a specified country for a set time.
--- @field outTextForGroup fun(groupId:number, text:string, displayTime:number, clearview:boolean) @Displays text to players in a specified group for a set time.
--- @field outTextForUnit fun(unitId:number, text:string, displayTime:number, clearview:boolean) @Displays text to players in a specified unit for a set time.
--- @field pushAITask fun(Group:Group, taskIndex:number) @Pushes the specified task index to the front of the tasking queue for the group.
--- @field quadToAll fun(coalition:number, id:number, point1:vec3, point2:vec3, point3:vec3, point4:vec3, color:table, fillColor:table, lineType:number, readOnly:boolean, message:string) @Creates a quadrilateral on the F10 map. 0=no line, 1=solid, 2=dashed, 3=dotted, 4=dot dash, 5=long dash, 6=two dash
--- @field radioTransmission fun(filename:string, point:vec3, modulation:number, loop:boolean, frequency:number, power:number, name:string) @Transmits an audio file from a specific point on a given frequency. (radio.modulation)
--- @field rectToAll fun(coalition:number, id:number, startPoint:vec3, endPoint:vec3, color:table, fillColor:table, lineType:number, readOnly:boolean, message:string) @Creates a rectangle on the F10 map. 0=no line, 1=solid, 2=dashed, 3=dotted, 4=dot dash, 5=long dash, 6=two dash
--- @field removeMark fun(id:number) @Removes a mark from the F10 map.
--- @field removeOtherCommand fun(name:string) @Removes the specified command from the "F10 Other" radio menu.
--- @field removeOtherCommandForCoalition fun(coalitionId:number, name:string) @Removes a coalition-specific command from the "F10 Other" menu.
--- @field removeOtherCommandForGroup fun(groupId:number, name:string) @Removes a group-specific command from the "F10 Other" menu.
--- @field setAITask fun(Group:Group, taskIndex:number) @Sets the specified task index as the only active task for the group.
--- @field setGroupAIOff fun(Group:Group) @Turns the group's AI off, only for ground and ship groups.
--- @field setGroupAIOn fun(Group:Group) @Turns the group's AI on, only for ground and ship groups.
--- @field setMarkupColor fun(id:number, color:table) @Updates the color of an existing mark.
--- @field setMarkupColorFill fun(id:number, colorFill:table) @Updates the fill color of an existing mark.
--- @field setMarkupFontSize fun(id:number, fontSize:number) @Updates the font size of text on an existing mark.
--- @field setMarkupPositionEnd fun(id:number, vec3:table) @Updates the endpoint of an existing line or shape mark.
--- @field setMarkupPositionStart fun(id:number, vec3:table) @Updates the start point of an existing line or shape mark.
--- @field setMarkupRadius fun(id:number, radius:number) @Updates the radius of an existing circular mark.
--- @field setMarkupText fun(id:number, text:string) @Updates the text of an existing mark.
--- @field setMarkupTypeLine fun(id:number, typeLine:number) @Updates the line type of an existing mark. 0=no line, 1=solid, 2=dashed, 3=dotted, 4=dot dash, 5=long dash, 6=two dash
--- @field setUnitInternalCargo fun(unitName:string, mass:number) @Sets the internal cargo mass for a specified unit.
--- @field setUserFlag fun(flag:string, value:number|boolean) @Sets the value of a user flag.
--- @field signalFlare fun(position:vec3, color:number, azimuth:number) @Creates a signal flare at a specified position with a specified color and azimuth. (trigger.flareColor)
--- @field smoke fun(position:vec3, color:number) @Creates a smoke plume at a specified position with a specified color. (trigger.smokeColor)
--- @field stopRadioTransmission fun(name:string) @Stops the named radio transmission.
--- @field textToAll fun(coalition:number, id:number, point:vec3, color:table, fillColor:table, fontSize:number, readOnly:boolean, text:string) @Creates text on the F10 map.
--- @type trigger.action
trigger.action = {}

--- @class trigger.misc
--- @description trigger misc
--- @field getUserFlag fun(flag:string):number @Returns the value of a user flag.
--- @field getZone fun(zoneName:string):TriggerZone @Returns a trigger zone table of a given name
--- @field addZone fun(zoneData:table):TriggerZone @Adds a trigger zone to the mission with the provided data.
--- @field addTrigger fun(trig:env.mission.trig|table):env.mission.trig @Adds a trigger to the mission.
--- @type trigger.misc
trigger.misc = {}

------------------------------------------------------------------------------
--- coord
------------------------------------------------------------------------------

--- @class coord
--- @description The coord singleton contains functions used to convert coordinates between the game's XYZ, Longitude and Latitude, and the MGRS coordinate systems.
--- @field LLtoLO fun(latitude:number, longitude:number, altitude:number):vec3 @Converts latitude, longitude, and altitude to game world coordinates (vec3).
--- @field LOtoLL fun(point:vec3):number, number, number @Converts game world coordinates (vec3) to latitude, longitude, and altitude.
--- @field LLtoMGRS fun(latitude:number, longitude:number):MGRS @Returns an MGRS table from the latitude and longitude coordinates provided. Note that in order to get the MGRS coordinate from a vec3 you must first use coord.LOtoLL on it.
--- @field MGRStoLL fun(mgrs:MGRS):number, number, number @Converts an MGRS table to latitude, longitude, and altitude.
--- @type coord
coord = {}

------------------------------------------------------------------------------
--- missionCommands
------------------------------------------------------------------------------

--- @class missionCommands
--- @description The missionCommands singleton allows for greater access and flexibility of use for the F10 Other radio menu. Added commands can contain sub-menus and directly call lua functions.
--- @field addCommand fun(name:string, path:table|nil, functionToRun:function, arg:any, ...:any):table @Adds a command to the "F10 Other" menu.
--- @field addCommandForCoalition fun(coalitionSide:number, name:string, path:table|nil, functionToRun:function, arg:any, ...:any):table @Adds a coalition-specific command to the F10 menu.
--- @field addCommandForGroup fun(groupId:number, name:string, path:table|nil, functionToRun:function, arg:any, ...:any):table @Adds a group-specific command to the F10 menu.
--- @field addSubMenu fun(name:string, path:table|nil):table @Creates a submenu in the F10 radio menu.
--- @field addSubMenuForCoalition fun(coalitionSide:number, name:string, path:table|nil):table @Creates a coalition-specific submenu in the F10 menu.
--- @field addSubMenuForGroup fun(groupId:number, name:string, path:table|nil):table @Creates a group-specific submenu in the F10 menu.
--- @field doAction fun()
--- @field removeItem fun(path:table|nil) @Removes an item or submenu from the F10 radio menu.
--- @field removeItemForCoalition fun(coalitionSide:number, path:table|nil) @Removes a coalition-specific item or submenu from the F10 menu.
--- @field removeItemForGroup fun(groupId:number, path:table|nil) @Removes a group-specific item or submenu from the F10 menu.
--- @type missionCommands
missionCommands = {}

------------------------------------------------------------------------------
--- VoiceChat
------------------------------------------------------------------------------

--- @class VoiceChat
--- @description The voice chat singleton is a means of creating customized voice chat rooms for players to interact with each other in multiplayer.
--- @field createRoom fun(roomName:string, side:number, roomType:number) @Creates a VoiceChat room for multiplayer interaction. (VoiceChat.Side, VoiceChat.RoomType)
--- @todo
--- @type VoiceChat
VoiceChat = {}

--- @class VoiceChat.Side
--- @description Enumerator for VoiceChat sides.
--- @field NEUTRAL number @Neutral (0)
--- @field RED number @Red (1)
--- @field BLUE number @Blue (2)
--- @field ALL number @All (3)
--- @type VoiceChat.Side
VoiceChat.Side = {}

--- @class VoiceChat.RoomType
--- @description Enumerator for VoiceChat room types.
--- @field PERSISTENT number @Persistent (0)
--- @field MULTICREW number @Multicrew (1)
--- @field MANAGEABLE number @Manageable (2)
--- @type VoiceChat.RoomType
VoiceChat.RoomType = {}

------------------------------------------------------------------------------
--- net
------------------------------------------------------------------------------

--- @class mission.net
--- @description The net singleton are a number of functions from the network API that work in the mission scripting environment. Notably for mission scripting purposes there is now a way to send chat, check if players are in Combined Arms slots, kick people from the server, and move players to certain slots.
--- @field CHAT_ALL number
--- @field CHAT_TEAM number
--- @field ERR_BAD_CALLSIGN number
--- @field ERR_BANNED number
--- @field ERR_CONNECT_FAILED number
--- @field ERR_DENIED_TRIAL_ONLY number
--- @field ERR_INVALID_ADDRESS number
--- @field ERR_INVALID_PASSWORD number
--- @field ERR_KICKED number
--- @field ERR_NOT_ALLOWED number
--- @field ERR_PROTOCOL_ERROR number
--- @field ERR_REFUSED number
--- @field ERR_SERVER_FULL number
--- @field ERR_TAINTED_CLIENT number
--- @field ERR_THATS_OKAY number
--- @field ERR_TIMEOUT number
--- @field ERR_WRONG_VERSION number
--- @field GAME_MODE_CONQUEST number
--- @field GAME_MODE_LAST_MAN_STANDING number
--- @field GAME_MODE_MISSION number
--- @field GAME_MODE_TEAM_DEATH_MATCH number
--- @field PS_CAR number
--- @field PS_CRASH number
--- @field PS_EJECT number
--- @field PS_EXTRA_ALLY_AAA number
--- @field PS_EXTRA_ALLY_FIGHTERS number
--- @field PS_EXTRA_ALLY_SAM number
--- @field PS_EXTRA_ALLY_TRANSPORTS number
--- @field PS_EXTRA_ALLY_TROOPS number
--- @field PS_EXTRA_ENEMY_AAA number
--- @field PS_EXTRA_ENEMY_FIGHTERS number
--- @field PS_EXTRA_ENEMY_SAM number
--- @field PS_EXTRA_ENEMY_TRANSPORTS number
--- @field PS_EXTRA_ENEMY_TROOPS number
--- @field PS_LAND number
--- @field PS_PING number
--- @field PS_PLANE number
--- @field PS_SCORE number
--- @field PS_SHIP number
--- @field RESUME_MANUAL number
--- @field RESUME_ON_LOAD number
--- @field RESUME_WITH_CLIENTS number
--- @field dostring_in fun(environment:string, code:string):string @Executes a Lua string in a specified Lua environment within the game. (config: main.cfg/autoexec.cfg state, mission: current mission, export: export.lua)
--- @field force_player_slot fun(playerID:number, sideId:number, slotId:number):boolean @Forces a player into a specified slot.
--- @field get_my_player_id fun():number @Returns the playerID of the local player; returns 1 for server.
--- @field get_name fun(playerID:number):string @Returns the name of a given player.
--- @field get_player_info fun(playerID:number, attribute:string|nil):table @Returns player attributes; specific attribute if provided.
--- @field get_player_list fun():table @Returns a list of players currently connected to the server.
--- @field get_server_host fun()
--- @field get_server_id fun():number @Returns the playerID of the server; currently always 1.
--- @field get_slot fun(playerID:number):number, number @Returns the sideId and slotId of a given player.
--- @field get_stat fun(playerID:number, statID:number):number @Returns a specific statistic from a given player.
--- @field is_loopback_address fun()
--- @field is_private_address fun()
--- @field json2lua fun(json:string):table @Converts a JSON string to a Lua value.
--- @field kick fun(playerId:number, message:string):boolean @Kicks a player from the server with an optional message.
--- @field log fun(message:string) @Writes an "INFO" entry to the DCS log file.
--- @field lua2json fun(lua:any):table @Converts a Lua value to a JSON string.
--- @field recv_chat fun() @Functionality unknown.
--- @field send_chat fun(message:string, all:boolean) @Sends a chat message to all players if true, or team otherwise.
--- @field send_chat_to fun(message:string, playerId:number, fromId:number|nil) @Sends a chat message to a specific player, optionally appearing from another player.
--- @field set_slot fun() @Functionality unknown.
--- @field trace fun() @Functionality unknown.
--- @type mission.net
net = {}

------------------------------------------------------------------------------
--- EventHandler
------------------------------------------------------------------------------

--- @class EventHandler
--- @description helper class for world.addEventHandler functions
--- @field onEvent fun(event:Event) @Function to be executed when an event occurs.

--- @class Event
--- @description helper class for event handler parameter
--- @field id number @Event ID (world.event
--- @field initiator Unit @Unit that initiated the event
--- @field place Unit|nil @place
--- @field subPlace number|nil @sub place (world.BirthPlace)
--- @field target Unit @Unit that is the target of the event
--- @field time number @Time in seconds since the mission started
--- @field weapon Weapon|nil @Weapon object that is the cause of the event
--- @type Event

------------------------------------------------------------------------------
--- Object
------------------------------------------------------------------------------

--- @class Object
--- @description Represents an object with body, unique name, category and type.
--- @field Category Object.Category
--- @field Desc Object.Desc
--- @field destroy fun(self:Object|table) @Destroys the object, physically removing it from the game world without creating an event.
--- @field getAttributes fun()
--- @field getCategory fun(self:Object):Object.Category @Returns the category of the object as an enumerator.
--- @field getDesc fun(self:Object):Object.Desc @Returns a description table of the object, with entries depending on the object's category.
--- @field getName fun(self:Object):string @Returns the name of the object as defined in the mission editor or by dynamic spawning.
--- @field getPoint fun(self:Object):vec3 @Returns a vec3 table with x, y, and z coordinates of the object's position in 3D space.
--- @field getPosition fun(self:Object):Position3 @Returns a Position3 table with the object's current position and orientation in 3D space.
--- @field getTypeName fun(self:Object):string @Returns the type name of the object.
--- @field getVelocity fun(self:Object):vec3 @Returns a vec3 table of the object's velocity vectors.
--- @field hasAttribute fun(self:Object, attribute:string):boolean @Returns true if the object has the specified attribute.
--- @field inAir fun(self:Object):boolean @Returns true if the object is in the air.
--- @field isExist fun(self:Object):boolean @Returns true if the object currently exists in the mission.
--- @type Object
Object = {}

--- @class Object.Desc
--- @description All objects description tables contain these values. Every other value is dependent on the type of object it is; aircraft, building, ground unit, airbase, etc.
--- @field life number @initial life level
--- @field box Box3 @bounding box of collision geometry

--- @class Object.Category
--- @description Enumerator for object categories.
--- @field UNIT number @Unit (1)
--- @field WEAPON number @Weapon (2)
--- @field STATIC number @Static object (3)
--- @field BASE number @Base (4)
--- @field SCENERY number @Scenery object (5)
--- @field CARGO number @Cargo (6)
--- @type Object.Category
Object.Category = {}

------------------------------------------------------------------------------
--- SceneryObject
------------------------------------------------------------------------------

--- @class SceneryObject:Object
--- @description Represents all objects placed on the map. Bridges, buildings, etc.
--- @field getLife fun(self:SceneryObject):number @Returns the current "life" of the scenery object.
--- @field getDescByName fun(typename:string):Object.Desc @Return a description table of the specified Object type. Object does not need to be in the mission in order to query its data.
--- @type SceneryObject
SceneryObject = {}

------------------------------------------------------------------------------
--- CoalitionObject
------------------------------------------------------------------------------

--- @class CoalitionObject:Object
--- @description Represents all objects that may belong to a coalition: units, airbases, static objects, weapon.
--- @field getCoalition fun(self:CoalitionObject):number @Returns an enumerator that defines the coalition that the object currently belongs to. 0=neutral, 1=red, 2=blue
--- @field getCommunicator fun()
--- @field getCountry fun(self:CoalitionObject):number @eturns an enumerator that defines the country that the object currently belongs to.
--- @field getForcesName fun()
--- @type CoalitionObject
CoalitionObject = {}

------------------------------------------------------------------------------
--- Unit
------------------------------------------------------------------------------

--- @class Unit:CoalitionObject
--- @description Represents units: airplanes, helicopters, vehicles, ships and armed ground structures.
--- @field Category Unit.Category
--- @field Desc Unit.Desc
--- @field LoadOnBoard fun()
--- @field OldCarrierMenuShow fun()
--- @field OpticType Unit.OpticType
--- @field RadarType Unit.RadarType
--- @field RefuelingSystem Unit.RefuelingSystem
--- @field SensorType Unit.SensorType
--- @field UnloadCargo fun()
--- @field canShipLanding fun()
--- @field checkOpenRamp fun()
--- @field disembarking fun()
--- @field enableEmission fun(self:Unit, setting:boolean) @Sets radar emissions on or off.
--- @field getAirbase fun()
--- @field getAmmo fun(self:Unit):table @Returns a table of ammunition details.
--- @field getByName fun(name:string):Unit @Returns an instance of the calling class for the object of a specified name.
--- @field getCallsign fun(self:Unit):string @Returns the callsign of the unit.
--- @field getCargosOnBoard fun()
--- @field getCategoryEx fun(self:Unit):Unit.Category @Returns the category of the unit.
--- @field getController fun(self:Unit):Controller @Returns the controller of the unit.
--- @field getDescByName fun(typename:string):Unit.Desc @Return a description table of the specified Object type. Object does not need to be in the mission in order to query its data.
--- @field getDescentCapacity fun(self:Unit):number|nil @Returns the descent capacity, nil if not applicable.
--- @field getDescentOnBoard fun(self:Unit):number,number @Returns count, reserve
--- @field getDrawArgumentValue fun(self:Unit, arg:number):number @Returns the value of an animation argument.
--- @field getFuel fun(self:Unit):number @Returns the current fuel level as a percentage.
--- @field getFuelLowState fun()
--- @field getGroup fun(self:Unit):Group @Returns the group the unit belongs to.
--- @field getID fun(self:Unit):number @Returns the unique mission id of the unit.
--- @field getLife fun(self:Unit):number @Returns the current life of the unit.
--- @field getLife0 fun(self:Unit):number @Returns the initial life value of the unit.
--- @field getNearestCargos fun(self:Unit):table|nil @Returns a table of nearby cargos, nil if not a helicopter.
--- @field getNearestCargosForAircraft fun()
--- @field getNumber fun(self:Unit):number @Returns the unit's default index within its group.
--- @field getObjectID fun(self:Unit):number @Returns the runtime object ID of the unit.
--- @field getPlayerName fun(self:Unit):string|nil @Returns the player's name if controlled by a player, nil otherwise.
--- @field getRadar fun(self:Unit):boolean, Object @Returns operational status of radar and the object it is tracking.
--- @field getSeats fun()
--- @field getSensors fun(self:Unit):table @Returns a table of available sensors.
--- @field hasCarrier fun()
--- @field hasSensors fun(self:Unit, sensorType:number, subCategory:number):boolean @Returns true if the unit has the specified sensors.
--- @field isActive fun(self:Unit):boolean @Returns true if the unit is activated.
--- @field markDisembarkingTask fun()
--- @field openRamp fun()
--- @type Unit
Unit = {}

--- @class Unit.Desc:Object.Desc

--- @class Unit.Category
--- @description Enumerator for unit categories.
--- @field AIRPLANE number @Airplane (0)
--- @field HELICOPTER number @Helicopter (1)
--- @field GROUND_UNIT number @Ground unit (2)
--- @field SHIP number @Ship (3)
--- @field STRUCTURE number @Structure (4)
--- @type Unit.Category
Unit.Category = {}

--- @class Unit.RefuelingSystem
--- @description Enumerator for refueling systems.
--- @field BOOM_AND_RECEPTACLE number @Boom and receptacle (0)
--- @field PROBE_AND_DROGUE number @Probe and drogue (1)
--- @type Unit.RefuelingSystem
Unit.RefuelingSystem = {}

--- @class Unit.SensorType
--- @description Enumerator for sensor types.
--- @field OPTIC number @Optic (0)
--- @field RADAR number @Radar (1)
--- @field IRST number @IRST (2)
--- @field RWR number @RWR (3)
--- @type Unit.SensorType
Unit.SensorType = {}

--- @class Unit.OpticType
--- @description Enumerator for optic types.
--- @field TV number @TV (0)
--- @field LLTV number @LLTV (1)
--- @field IR number @IR (2)
--- @type Unit.OpticType
Unit.OpticType = {}

--- @class Unit.RadarType
--- @description Enumerator for radar types.
--- @field AS number @Air-to-surface (0)
--- @field SS number @Surface-to-surface (1)
--- @type Unit.RadarType
Unit.RadarType = {}

------------------------------------------------------------------------------
--- Airbase
------------------------------------------------------------------------------

--- @class Airbase:CoalitionObject
--- @description Represents airbases: airdromes, helipads and ships with flying decks or landing pads.
--- @field autoCapture fun(self:Airbase, setting:boolean) @Enables or disables the airbase auto capture mechanic.
--- @field autoCaptureIsOn fun(self:Airbase):boolean @Returns the current setting of the auto capture mechanic.
--- @field getByName fun(name:string):Airbase @Returns an instance of the calling class for the object of a specified name.
--- @field getCallsign fun(self:Airbase):string @Returns the callsign of the airbase.
--- @field getCategoryEx fun(self:Airbase):Airbase.Category @Returns the category of the airbase.
--- @field getDescByName fun(typename:string):Airbase.Desc @Return a description table of the specified Object type. Object does not need to be in the mission in order to query its data.
--- @field getDispatcherTowerPos fun()
--- @field getID fun(self:Airbase):number @Returns the unique mission ID of the airbase.
--- @field getNearest fun()
--- @field getParking fun(self:Airbase, available:boolean):table @Returns a table of parking data, optionally only available parking.
--- @field getRadioSilentMode fun(self:Airbase):boolean @Returns whether the ATC is in radio silent mode.
--- @field getRunways fun(self:Airbase):table @Returns a table with runway information.
--- @field getTechObjectPos fun(self:Airbase, objectType:number|string):table @Returns a table of vec3 positions for technical objects, typically only "Tower".
--- @field getUnit fun(self:Airbase, unitIndex:number):Unit|nil @Returns the unit or static object associated with the airbase at the specified index.
--- @field getWarehouse fun(self:Airbase):Warehouse @Returns the warehouse associated with the airbase.
--- @field getWorldID fun()
--- @field setCoalition fun(self:Airbase, coalition:number) @Sets the coalition of the airbase.
--- @field setRadioSilentMode fun(self:Airbase, silent:boolean) @Sets the ATC to radio silent mode.
--- @type Airbase
Airbase = {}

--- @class Airbase.Desc:Object.Desc
--- @description Airbase description table.
--- @field category Airbase.Category

--- @class Airbase.Category
--- @description Enumerator for airbase categories.
--- @field AIRDROME number @Airdrome (0)
--- @field HELIPAD number @Helipad (1)
--- @field SHIP number @Ship (2)
--- @type Airbase.Category
Airbase.Category = {}

------------------------------------------------------------------------------
--- Weapon
------------------------------------------------------------------------------

--- @class Weapon:CoalitionObject
--- @description Represents a weapon object: shell, rocket, missile and bomb
--- @field getCategoryEx fun(self:Weapon):Weapon.Category @Returns an enumerator of the category for the specific object.
--- @field getLauncher fun(self:Weapon):Unit|nil @Returns the unit that launched the weapon.
--- @field getTarget fun(self:Weapon):Object|nil @Returns the target object that the weapon is guiding to.
--- @type Weapon
Weapon = {}

--- @class Weapon.Warhead
--- @description Warhead description table.
--- @field type Weapon.WarheadType
--- @field caliber number|nil
--- @field explosiveMass number|nil @for HE and AP(+HE) warheads only
--- @field mass number|nil
--- @field shapedExplosiveArmorThickness number|nil @for shaped explosive warheads only
--- @field shapedExplosiveMass number|nil @for shaped explosive warheads only

--- @class Weapon.Desc:Object.Desc
--- @description Weapon description table.
--- @field category Weapon.Category
--- @field warhead.type Weapon.WarheadType
--- @field warhead.mass number @Mass

--- @class Weapon.DescMissile:Weapon.Desc
--- @description Missile description table.
--- @field guidance Weapon.GuidanceType
--- @field rangeMin number
--- @field rangeMaxAltMin number
--- @field rangeMaxAltMax number
--- @field altMin number
--- @field altMax number
--- @field Nmax number
--- @field fuseDist number

--- @class Weapon.DescRocket:Weapon.Desc
--- @description Rocket description table.
--- @field distMin number
--- @field distMax number

--- @class Weapon.DescBomb:Weapon.Desc
--- @description Bomb description table.
--- @field guidance Weapon.GuidanceType
--- @field altMin number
--- @field altMax number

--- @class Weapon.Category
--- @description Enumerator for weapon categories.
--- @field SHELL number @Shell (0)
--- @field MISSILE number @Missile (1)
--- @field ROCKET number @Rocket (2)
--- @field BOMB number @Bomb (3)
--- @type Weapon.Category
Weapon.Category = {}

--- @class Weapon.GuidanceType
--- @description Enumerator for weapon guidance types.
--- @field INS number @INS (1)
--- @field IR number @IR (2)
--- @field RADAR_ACTIVE number @Active Radar (3)
--- @field RADAR_SEMI_ACTIVE number @Semi-Active Radar (4)
--- @field RADAR_PASSIVE number @Passive Radar (5)
--- @field TV number @TV (6)
--- @field LASER number @LASER (7)
--- @field TELE number @TELE (8)
--- @type Weapon.GuidanceType
Weapon.GuidanceType = {}

--- @class Weapon.MissileCategory
--- @description Enumerator for missile categories.
--- @field AAM number @AAM (1)
--- @field SAM number @SAM (2)
--- @field BM number @BM (3)
--- @field ANTI_SHIP number @Anti-Ship (4)
--- @field CRUISE number @Cruise (5)
--- @field OTHER number @Other (6)
--- @type Weapon.MissileCategory
Weapon.MissileCategory = {}

--- @class Weapon.WarheadType
--- @description Enumerator for warhead types.
--- @field AP number @AP (0)
--- @field HE number @HE (1)
--- @field SHAPED_EXPLOSIVE number @Shaped Explosive (2)
--- @type Weapon.WarheadType
Weapon.WarheadType = {}

------------------------------------------------------------------------------
--- StaticObject
------------------------------------------------------------------------------

--- @class StaticObject:CoalitionObject
--- @description Represents static objects added in the Mission Editor or via scripting commands.
--- @field getByName fun(name:string):StaticObject @Returns an instance of the calling class for the object of a specified name.
--- @field getCargoDisplayName fun(self:StaticObject):string @Returns a string of a cargo objects mass
--- @field getCargoWeight fun(self:StaticObject):number @Returns the mass of a cargo object measured in kg.
--- @field getDescByName fun(typename:string):Object.Desc @Return a description table of the specified Object type. Object does not need to be in the mission in order to query its data.
--- @field getDrawArgumentValue fun(self:StaticObject, arg:number):number @Returns the current value for an animation argument on the external model of the given object.
--- @field getID fun(self:StaticObject):number @Returns a number which defines the unique mission id of a given object.
--- @field getLife fun(self:StaticObject):number @Returns the current life of a unit. Also referred to as hit points
--- @type StaticObject
StaticObject = {}

--- @class StaticObject.Category
--- @description Enumerator for static object categories.
--- @field VOID number @Void (0)
--- @field UNIT number @Unit (1)
--- @field WEAPON number @Weapon (2)
--- @field STATIC number @Static object (3)
--- @field BASE number @Base (4)
--- @field SCENERY number @Scenery object (5)
--- @field CARGO number @Cargo (6)
--- @type StaticObject.Category
StaticObject.Category = {}

------------------------------------------------------------------------------
--- Group
------------------------------------------------------------------------------

--- @class Group
--- @description Represents a group of units.
--- @field activate fun(self:Group) @Activates the group.
--- @field destroy fun(self:Group) @Destroys the group, physically removing it from the game world without creating an event.
--- @field embarking fun()
--- @field enableEmission fun(self:Group, setting:boolean) @Sets radar emissions on or off.
--- @field getByName fun(name:string):Group @Returns an instance of the calling class for the object of a specified name.
--- @field getCategory fun(self:Group):Group.Category @Returns the category of the group as an enumerator.
--- @field getCategoryEx fun()
--- @field getCoalition fun(self:Group):number @Returns an enumerator that defines the coalition that the group currently belongs to. 0=neutral, 1=red, 2=blue
--- @field getController fun(self:Group):Controller @Returns the controller of the group.
--- @field getID fun(self:Group):number @Returns the unique mission id of the group.
--- @field getInitialSize fun(self:Group):number @Returns the initial size of the group.
--- @field getName fun(self:Group):string @Returns the name of the group as defined in the mission editor or by dynamic spawning.
--- @field getSize fun(self:Group):number @Returns the current size of the group.
--- @field getUnit fun(self:Group, unitIndex:number):Unit|nil @Returns the unit at the specified index within the group.
--- @field getUnits fun(self:Group):table @Returns a table of all units in the group.
--- @field isExist fun(self:Group):boolean @Returns true if the group currently exists in the mission.
--- @field markGroup fun()
--- @type Group
Group = {}

--- @class Group.Category
--- @description Enumerator for group categories.
--- @field AIRPLANE number @Airplane (0)
--- @field HELICOPTER number @Helicopter (1)
--- @field GROUND number @Ground (2)
--- @field SHIP number @Ship (3)
--- @field TRAIN number @Train (4)
--- @type Group.Category
Group.Category = {}

------------------------------------------------------------------------------
--- Controller
------------------------------------------------------------------------------

--- @class Controller
--- @description Represents a controller of a unit or group.
--- @field getDetectedTargets fun(self:Controller, detectionType1:number, detectionType2:number, detectionType3:number,...):table @Returns a table of detected targets.
--- @field hasTask fun(self:Controller):boolean @Returns true if the controller has a task.
--- @field isTargetDetected fun(self:Controller, target:Object, detectionType1:number, detectionType2:number, detectionType3:number,...):table @Returns details if the target is detected.
--- @field knowTarget fun(self:Controller, object:Object, type:boolean, distance:boolean) @Forces the controller to become aware of a specified target.
--- @field popTask fun(self:Controller) @Removes the top task from the tasking queue.
--- @field pushTask fun(self:Controller, task:Task) @Pushes a task to the front of the tasking queue.
--- @field resetTask fun(self:Controller) @Resets the current task assigned to the controller.
--- @field setAltitude fun(self:Controller, altitude:number, keep:boolean, altType:string) @Sets the altitude for aircraft, with an option to maintain it at waypoints.
--- @field setCommand fun(self:Controller, command:Command) @Sets a command, an instant action with no impact on active tasks.
--- @field setOnOff fun(self:Controller, value:boolean) @Enables or disables the AI controller, not applicable to aircraft or helicopters.
--- @field setOption fun(self:Controller, optionId:number, optionValue:number) @Sets behavior options that affect all tasks performed by the controller.
--- @field setSpeed fun(self:Controller, speed:number, keep:boolean) @Sets the speed for the controlled group, with an option to maintain it at waypoints.
--- @field setTask fun(self:Controller, task:Task) @Sets a specified task to the units or groups associated with the controller.
--- @type Controller
Controller = {}

--- @class Controller.Detection
--- @description Enumerator for detection types.
--- @field VISUAL number @Visual (1)
--- @field OPTIC number @Optic (2)
--- @field RADAR number @Radar (4)
--- @field IRST number @IRST (8)
--- @field RWR number @RWR (16)
--- @field DLINK number @DLINK (32)
--- @type Controller.Detection
Controller.Detection = {}

------------------------------------------------------------------------------
--- Task
------------------------------------------------------------------------------

--- @class Task
--- @description Represents a task that can be assigned to a unit or group.
--- @field id string
--- @field params table

--- @class MissionTask:Task
--- @description Task Wrapper - the mission task is a collection of waypoints that are assigned to a group. When you create a group in the mission editor and place a route, you are created its mission task. For ground vehicles and ships the mission task is how you can more directly control where ground/ship forces are going.
--- @field params MissionTaskParams
--- @class MissionTaskParams
--- @field airborne boolean
--- @field route Route

--- @class ComboTask:Task
--- @description Task Wrapper - a list of tasks indexed numerically for when the task will be executed in accordance with the AI task queue rules. This is the task that the DCS mission editor will default to using for groups placed in the editor.
--- @field params Task[]

--- @class ControlledTask:Task
--- @description Task Wrapper - a controlled task is a task that has start and/or stop conditions that will be used as a condition to start or stop the task. Start conditions are executed only once when the task is reached in the task queue. If the conditions are not met the task will be skipped. Stop Conditions are executed at a high rate. Can be used with any task in DCS. Note that options and commands do *NOT* have stopConditions. These tasks are executed immediately and take "no time" to run.
--- @field params ControlledTaskParams
--- @class ControlledTaskParams
--- @field task Task
--- @field condition table
--- @field stopCondition table

--- @class WrappedAction:Task
--- @description Task Wrapper - functions as a wrapper for setting commands and options as a task within a mission, comboTask, or controlledTask.
--- @field params table

-- Main Tasks: AttackGroup, AttackUnit, Bombing, Strafing, CarpetBombing, AttackMapObject, BombingRunway, orbit, refueling, land, follow, followBigFormation, escort, Embarking, fireAtPoint, hold, FAC_AttackGroup, EmbarkToTransport, DisembarkFromTransport, CargoTransportation, goToWaypoint, groundEscort, RecoveryTanker

-- Enroute Tasks: engageTargets, engageTargetsInZone, engageGroup, engageUnit, awacs, tanker, ewr, FAC_engageGroup, FAC

------------------------------------------------------------------------------
--- Route
------------------------------------------------------------------------------

--- @class Route
--- @field points Waypoint[]

------------------------------------------------------------------------------
--- Waypoint
------------------------------------------------------------------------------

--- @class Waypoint
--- @description Each waypoint has a number of parameters that define how the group will handle the route.
--- @field x vec2 @required - x coordinate waypoint will be placed at
--- @field y vec2 @required - y coordinate waypoint will be placed at. If converted from Vec3 this is the z coordinate.
--- @field type AI.Task.WaypointType @required - Waypoint type.
--- @field speed number @required, speed in meters per second
--- @field action AI.Task.TurnMethod @required - Waypoint action type.
--- @field alt number @required - Altitude of waypoint. If converted from Vec3 this is the y coordinate. This item is required for Aircraft, but is optional for ground vehicles. As of 2.5.6 this value can be set to negative numbers. Specifically this will submerge submarines.
--- @field speed_locked boolean @optional - boolean value that will determine if units will attempt to travel at the specified speed
--- @field eta number @optional - Time-On-Target of the waypoint. Has effect only if ETA_locked is true. AI will adjust speed to reach TOT accordingly.
--- @field eta_locked boolean @optional - boolean value that will determine if AI will attempt to reach the waypoint at a specified time.
--- @field alt_type AI.Task.AltitudeType @optional - Altitude type; Radio or Barometric. Defaults to barometric. If specified the altitude of the waypoint can be defined as AGL or MSL. Only applies to aircraft.
--- @field task Task[] @optional - All tasks, enroute tasks, commands, and options are defined here.
--- @field helipadId number @optional - Used when the waypoint is associated with the a static object or a unit placed in the mission editor. Needs to be the unitId associated with the object.
--- @field linkUnit number @optional - Used when the waypoint is associated with the a static object or a unit placed in the mission editor. Value is identical to helipadId, but it is required.
--- @field airdromeId number @optional - Specifies the airbaseId the aircraft group will attempt to use. AI will only land if airbase is friendly. If not provided the AI will land at the nearest valid base to the coordinates.
--- @field timeReFuAr number @optional - If the waypoint type is a landReFuAr this value determines how long in minutes the unit will be stationary for.

------------------------------------------------------------------------------
--- Command
------------------------------------------------------------------------------

--- @class Command
--- @description Represents a command that can be assigned to a controller.

-- details on each command: script, setCallsign, setFrequency, setFrequencyForUnit, switchWaypoint, stopRoute, switchAction, setInvisible, setImmortal, setUnlimitedFuel, activateBeacon, deactivateBeacon, activateICLS, deactivateICLS, eplrs, start, transmitMessage, stopTransmission, smoke_on_off, ActivateLink4, deactivateLink4, activateACLS, deactivateACLS, LoadingShip

------------------------------------------------------------------------------
--- Spot
------------------------------------------------------------------------------

--- @class Spot
--- @description Represents a spot from laser or IR-pointer.
--- @field createInfraRed fun(source:Object, localRef:vec3, point:vec3):Spot @Creates an infrared ray visible with night vision. localRef is optional; use nil if not needed.
--- @field createLaser fun(source:Object, localRef:vec3, point:vec3, laserCode:number|nil):Spot @Creates a laser ray. localRef is optional; use nil if not needed. If laserCode is absent, defaults to an IR beam.
--- @field destroy fun(self:Object) @Destroys the object, removing it from the game world without an event. If used with a group, the entire group will be destroyed.
--- @field getCategory fun(self:Object):Spot.Category @Returns the category and sub-category of the object.
--- @field getCode fun(self:Spot):number @Returns the laser code used for laser designation. Default and max value is 1688.
--- @field getPoint fun(self:Object):vec3 @Returns the x, y, and z coordinates of the objects position in 3D space.
--- @field setCode fun(self:Spot, code:number) @Sets the laser code for laser designation. Default and max value is 1688.
--- @field setPoint fun(self:Spot, vec3:vec3) @Sets the destination point for the spot.
--- @type Spot
Spot = {}

--- @class Spot.Category
--- @description Enumerator for spot categories.
--- @field INFRA_RED number @Infra-red (0)
--- @field LASER number @LASER (1)
--- @type Spot.Category
Spot.Category = {}

------------------------------------------------------------------------------
--- Warehouse
------------------------------------------------------------------------------

--- @class Warehouse
--- @description The warehouse class gives control over warehouses that exist in airbase objects. These warehouses can limit the aircraft, munitions, and fuel available to coalition aircraft.
--- @field addItem fun(self:Warehouse, itemName:string|table, count:number) @Adds the specified amount of an item to the warehouse.
--- @field addLiquid fun(self:Warehouse, liquidType:number, count:number) @Adds the specified amount of a liquid to the warehouse.
--- @field getCargoAsWarehouse fun()
--- @field getInventory fun(self:Warehouse, itemName:string|table):table @Returns a full itemized list of the inventory, empty if category is set to unlimited.
--- @field getItemCount fun(self:Warehouse, itemName:string|table):number @Returns the count of the specified type of item in the warehouse.
--- @field getLiquidAmount fun(self:Warehouse, liquidType:number):number @Returns the amount of the specified liquid in the warehouse.
--- @field getOwner fun(self:Warehouse):Airbase @Returns the airbase associated with the warehouse.
--- @field getResourceMap fun()
--- @field removeItem fun(self:Warehouse, itemName:string|table, count:number) @Removes the specified amount of an item from the warehouse.
--- @field removeLiquid fun(self:Warehouse, liquidType:number, count:number) @Removes the specified amount of a liquid from the warehouse.
--- @field setItem fun(self:Warehouse, itemName:string|table, count:number) @Sets the specified amount of an item in the warehouse.
--- @field setLiquidAmount fun(self:Warehouse, liquidType:number, count:number) @Sets the specified amount of a liquid in the warehouse.
--- @type Warehouse
Warehouse = {}

------------------------------------------------------------------------------
--- country
------------------------------------------------------------------------------

--- @class country
--- @description The country singleton contains enumerators for all countries in DCS World. These can be used to set the country of a unit or group, or to check the country of an object.
--- @field id country.id @key country, value id
--- @field names table @key id, value country
--- @field by_country table @infos by country name
--- @field by_idx table @infos by idx
--- @type country
country = {}

--- @class country.id
--- @description Enumerator for country IDs.
--- @field RUSSIA number @Russia (0)
--- @field UKRAINE number @Ukraine (1)
--- @field USA number @USA (2)
--- @field TURKEY number @Turkey (3)
--- @field UK number @UK (4)
--- @field FRANCE number @France (5)
--- @field GERMANY number @Germany (6)
--- @field AGGRESSORS number @Aggressors (7)
--- @field CANADA number @Canada (8)
--- @field SPAIN number @Spain (9)
--- @field THE_NETHERLANDS number @The Netherlands (10)
--- @field BELGIUM number @Belgium (11)
--- @field NORWAY number @Norway (12)
--- @field DENMARK number @Denmark (13)
--- @field GREECE number @Greece (14)
--- @field ISRAEL number @Israel (15)
--- @field GEORGIA number @Georgia (16)
--- @field INSURGENTS number @Insurgents (17)
--- @field ABKHAZIA number @Abkhazia (18)
--- @field SOUTH_OSETIA number @South Ossetia (19)
--- @field ITALY number @Italy (20)
--- @field AUSTRALIA number @Australia (21)
--- @field SWITZERLAND number @Switzerland (22)
--- @field AUSTRIA number @Austria (23)
--- @field BELARUS number @Belarus (24)
--- @field BULGARIA number @Bulgaria (25)
--- @field CHEZH_REPUBLIC number @Czech Republic (26)
--- @field CHINA number @China (27)
--- @field CROATIA number @Croatia (28)
--- @field EGYPT number @Egypt (29)
--- @field FINLAND number @Finland (30)
--- @field GREECE number @Greece (31)
--- @field HUNGARY number @Hungary (32)
--- @field INDIA number @India (33)
--- @field IRAN number @Iran (34)
--- @field IRAQ number @Iraq (35)
--- @field JAPAN number @Japan (36)
--- @field KAZAKHSTAN number @Kazakhstan (37)
--- @field NORTH_KOREA number @North Korea (38)
--- @field PAKISTAN number @Pakistan (39)
--- @field POLAND number @Poland (40)
--- @field ROMANIA number @Romania (41)
--- @field SAUDI_ARABIA number @Saudi Arabia (42)
--- @field SERBIA number @Serbia (43)
--- @field SLOVAKIA number @Slovakia (44)
--- @field SOUTH_KOREA number @South Korea (45)
--- @field SWEDEN number @Sweden (46)
--- @field SYRIA number @Syria (47)
--- @field YEMEN number @Yemen (48)
--- @field VIETNAM number @Vietnam (49)
--- @field VENEZUELA number @Venezuela (50)
--- @field TUNISIA number @Tunisia (51)
--- @field THAILAND number @Thailand (52)
--- @field SUDAN number @Sudan (53)
--- @field PHILIPPINES number @Philippines (54)
--- @field MOROCCO number @Morocco (55)
--- @field MEXICO number @Mexico (56)
--- @field MALAYSIA number @Malaysia (57)
--- @field LIBYA number @Libya (58)
--- @field JORDAN number @Jordan (59)
--- @field INDONESIA number @Indonesia (60)
--- @field HONDURAS number @Honduras (61)
--- @field ETHIOPIA number @Ethiopia (62)
--- @field CHILE number @Chile (63)
--- @field BRAZIL number @Brazil (64)
--- @field BAHRAIN number @Bahrain (65)
--- @field THIRDREICH number @Third Reich (66)
--- @field YUGOSLAVIA number @Yugoslavia (67)
--- @field USSR number @USSR (68)
--- @field ITALIAN_SOCIAL_REPUBLIC number @Italian Social Republic (69)
--- @field ALGERIA number @Algeria (70)
--- @field KUWAIT number @Kuwait (71)
--- @field QATAR number @Qatar (72)
--- @field OMAN number @Oman (73)
--- @field UNITED_ARAB_EMIRATES number @United Arab Emirates (74)
--- @field SOUTH_AFRICA number @South Africa (75)
--- @field CUBA number @Cuba (76)
--- @field PORTUGAL number @Portugal (77)
--- @field GDR number @GDR (78)
--- @field LEBANON number @Lebanon (79)
--- @field CJTF_BLUE number @CJTF Blue (80)
--- @field CJTF_RED number @CJTF Red (81)
--- @field UN_PEACEKEEPERS number @UN Peacekeepers (82)
--- @field Argentina number @Argentina (83)
--- @field Cyprus number @Cyprus (84)
--- @field Slovenia number @Slovenia (85)
--- @field BOLIVIA number @Bolivia (86)
--- @field GHANA number @Ghana (87)
--- @field NIGERIA number @Nigeria (88)
--- @field PERU number @Peru (89)
--- @field ECUADOR number @Ecuador (90)
--- @type country.id
country.id = {}

------------------------------------------------------------------------------
--- AI
------------------------------------------------------------------------------

--- @class AI
--- @description The AI singleton contains enumerators for AI tasks and skills, as well as options for air, ground, and naval units.
--- @field Task AI.Task
--- @field Skill AI.Skill
--- @field Option AI.Option
--- @type AI
AI = {}

--- @class AI.Task
--- @description Enumerator for AI tasks.
--- @field AltitudeType AI.Task.AltitudeType
--- @field Designation AI.Task.Designation
--- @field OrbitPattern AI.Task.OrbitPattern
--- @field TurnMethod AI.Task.TurnMethod
--- @field VehicleFormation AI.Task.VehicleFormation
--- @field WaypointType AI.Task.WaypointType
--- @field WeaponExpend AI.Task.WeaponExpend
--- @type AI.Task
AI.Task = {}

--- @class AI.Task.AltitudeType
--- @description Enumerator for altitude types.
--- @field RADIO string @Radio ("RADIO")
--- @field BARO string @Barometric ("BARO")
--- @type AI.Task.AltitudeType
AI.Task.AltitudeType = {}

--- @class AI.Task.Designation
--- @description Enumerator for designations.
--- @field NO string @No ("No")
--- @field WP string @Waypoint ("WP")
--- @field IR_POINTER string @IR-Pointer ("IR-Pointer")
--- @field LASER string @Laser ("Laser")
--- @field AUTO string @Auto ("Auto")
--- @type AI.Task.Designation
AI.Task.Designation = {}

--- @class AI.Task.OrbitPattern
--- @description Enumerator for orbit patterns.
--- @field RACE_TRACK string @Race-Track ("Race-Track")
--- @field CIRCLE string @Circle ("Circle")
--- @type AI.Task.OrbitPattern
AI.Task.OrbitPattern = {}

--- @class AI.Task.TurnMethod
--- @description Enumerator for turn methods. @todo parking
--- @field FLY_OVER_POINT string @Fly Over Point ("Fly Over Point")
--- @field FIN_POINT string @Fin Point ("Fin Point")
--- @type AI.Task.TurnMethod
AI.Task.TurnMethod = {}

--- @class AI.Task.VehicleFormation
--- @description Enumerator for vehicle formations.
--- @field VEE string @Vee ("Vee")
--- @field ECHELON_RIGHT string @Echelon Right ("EchelonR")
--- @field OFF_ROAD string @Off Road ("Off Road")
--- @field RANK string @Rank ("Rank")
--- @field ECHELON_LEFT string @Echelon Left ("EchelonL")
--- @field ON_ROAD string @On Road ("On Road")
--- @field CONE string @Cone ("Cone")
--- @field DIAMOND string @Diamond ("Diamond")
--- @type AI.Task.VehicleFormation
AI.Task.VehicleFormation = {}

--- @class AI.Task.WaypointType
--- @description Enumerator for waypoint types.
--- @field TAKEOFF string @TakeOff ("TakeOff")
--- @field TAKEOFF_PARKING string @TakeOffParking ("TakeOffParking")
--- @field TURNING_POINT string @Turning Point ("Turning Point")
--- @field TAKEOFF_PARKING_HOT string @TakeOffParkingHot ("TakeOffParkingHot")
--- @field LAND string @Land ("Land")
--- @type AI.Task.WaypointType
AI.Task.WaypointType = {}

--- @class AI.Task.WeaponExpend
--- @description Enumerator for weapon expenditures.
--- @field QUARTER string @Quarter ("Quarter")
--- @field TWO string @Two ("Two")
--- @field ONE string @One ("One")
--- @field FOUR string @Four ("Four")
--- @field HALF string @Half ("Half")
--- @field ALL string @All ("All")
--- @type AI.Task.WeaponExpend
AI.Task.WeaponExpend = {}

--- @class AI.Skill
--- @description Enumerator for AI skills.
--- @field PLAYER string @Player ("PLAYER")
--- @field CLIENT string @Client ("CLIENT")
--- @field AVERAGE string @Average ("AVERAGE")
--- @field GOOD string @Good ("GOOD")
--- @field HIGH string @High ("HIGH")
--- @field EXCELLENT string @Excellent ("EXCELLENT")
--- @type AI.Skill
AI.Skill = {}

--- @class AI.Option
--- @description Enumerator for AI options.
--- @field Air AI.Option.Air
--- @field Ground AI.Option.Ground
--- @field Naval AI.Option.Naval
--- @type AI.Option
AI.Option = {}

--- @class AI.Option.Air
--- @description Enumerator for air unit options.
--- @field id AI.Option.Air.id
--- @field val AI.Option.Air.val
--- @type AI.Option.Air
AI.Option.Air = {}

--- @class AI.Option.Air.id
--- @description Enumerator for air unit option IDs.
--- @field ROE number @ROE (0)
--- @field REACTION_ON_THREAT number @Reaction on threat (1)
--- @field RADAR_USING number @Radar using (3)
--- @field FLARE_USING number @Flare using (4)
--- @field FORMATION number @Formation (5)
--- @field RTB_ON_BINGO number @RTB on bingo (6)
--- @field SILENCE number @Silence (7)
--- @field RTB_ON_OUT_OF_AMMO number @RTB on out of ammo (10)
--- @field ECM_USING number @ECM using (13)
--- @field PROHIBIT_AA number @Prohibit AA (14)
--- @field PROHIBIT_JETT number @Prohibit Jett (15)
--- @field PROHIBIT_AB number @Prohibit AB (16)
--- @field PROHIBIT_AG number @Prohibit AG (17)
--- @field MISSILE_ATTACK number @Missile attack (18)
--- @field PROHIBIT_WP_PASS_REPORT number @Prohibit WP pass report (19)
--- @field OPTION_RADIO_USAGE_CONTACT number @Option radio usage contact (21)
--- @field OPTION_RADIO_USAGE_ENGAGE number @Option radio usage engage (22)
--- @field OPTION_RADIO_USAGE_KILL number @Option radio usage kill (23)
--- @field JETT_TANKS_IF_EMPTY number @Jett tanks if empty (25)
--- @field FORCED_ATTACK number @Forced attack (26)
--- @field PREFER_VERTICAL number @Prefer vertical (32)
--- @type AI.Option.Air.id
AI.Option.Air.id = {}

--- @class AI.Option.Air.val
--- @description Enumerator for air unit option values.
--- @field ROE AI.Option.Air.val.ROE
--- @field REACTION_ON_THREAT AI.Option.Air.val.REACTION_ON_THREAT
--- @field RADAR_USING AI.Option.Air.val.RADAR_USING
--- @field FLARE_USING AI.Option.Air.val.FLARE_USING
--- @field ECM_USING AI.Option.Air.val.ECM_USING
--- @field MISSILE_ATTACK AI.Option.Air.val.MISSILE_ATTACK
--- @type AI.Option.Air.val
AI.Option.Air.val = {}

--- @class AI.Option.Air.val.ROE
--- @description Enumerator for rules of engagement.
--- @field WEAPON_FREE number @Weapon free (0)
--- @field OPEN_FIRE_WEAPON_FREE number @Open fire weapon free (1)
--- @field OPEN_FIRE number @Open fire (2)
--- @field RETURN_FIRE number @Return fire (3)
--- @field WEAPON_HOLD number @Weapon hold (4)
--- @type AI.Option.Air.val.ROE
AI.Option.Air.val.ROE = {}

--- @class AI.Option.Air.val.REACTION_ON_THREAT
--- @description Enumerator for reactions on threat.
--- @field NO_REACTION number @No reaction (0)
--- @field PASSIVE_DEFENCE number @Passive defence (1)
--- @field EVADE_FIRE number @Evade fire (2)
--- @field BYPASS_AND_ESCAPE number @Bypass and escape (3)
--- @field ALLOW_ABORT_MISSION number @Allow abort mission (4)
--- @field AAA_EVADE_FIRE number @AAA evade fire (5)
--- @type AI.Option.Air.val.REACTION_ON_THREAT
AI.Option.Air.val.REACTION_ON_THREAT = {}

--- @class AI.Option.Air.val.RADAR_USING
--- @description Enumerator for radar usage.
--- @field NEVER number @Never (0)
--- @field FOR_ATTACK_ONLY number @For attack only (1)
--- @field FOR_SEARCH_IF_REQUIRED number @For search if required (2)
--- @field FOR_CONTINUOUS_SEARCH number @For continuous search (3)
--- @type AI.Option.Air.val.RADAR_USING
AI.Option.Air.val.RADAR_USING = {}

--- @class AI.Option.Air.val.FLARE_USING
--- @description Enumerator for flare usage.
--- @field NEVER number @Never (0)
--- @field AGAINST_FIRED_MISSILE number @Against fired missile (1)
--- @field WHEN_FLYING_IN_SAM_WEZ number @When flying in SAM WEZ (2)
--- @field WHEN_FLYING_NEAR_ENEMIES number @When flying near enemies (3)
--- @type AI.Option.Air.val.FLARE_USING
AI.Option.Air.val.FLARE_USING = {}

--- @class AI.Option.Air.val.ECM_USING
--- @description Enumerator for ECM usage.
--- @field NEVER_USE number @Never use (0)
--- @field USE_IF_ONLY_LOCK_BY_RADAR number @Use if only lock by radar (1)
--- @field USE_IF_DETECTED_LOCK_BY_RADAR number @Use if detected lock by radar (2)
--- @field ALWAYS_USE number @Always use (3)
--- @type AI.Option.Air.val.ECM_USING
AI.Option.Air.val.ECM_USING = {}

--- @class AI.Option.Air.val.MISSILE_ATTACK
--- @description Enumerator for missile attack options.
--- @field MAX_RANGE number @Max range (0)
--- @field NEZ_RANGE number @NEZ range (1)
--- @field HALF_WAY_RMAX_NEZ number @Half way Rmax NEZ (2)
--- @field TARGET_THREAT_EST number @Target threat est (3)
--- @field RANDOM_RANGE number @Random range (4)
--- @type AI.Option.Air.val.MISSILE_ATTACK
AI.Option.Air.val.MISSILE_ATTACK = {}

--- @class AI.Option.Ground
--- @description Enumerator for ground unit options.
--- @field id AI.Option.Ground.id
--- @field val AI.Option.Ground.val
--- @type AI.Option.Ground
AI.Option.Ground = {}

--- @class AI.Option.Ground.id
--- @description Enumerator for ground unit option IDs.
--- @field ROE number @ROE (0)
--- @field FORMATION number @Formation (5)
--- @field DISPERSE_ON_ATTACK number @Disperse on attack (8)
--- @field ALARM_STATE number @Alarm state (9)
--- @field ENGAGE_AIR_WEAPONS number @Engage air weapons (20)
--- @field AC_ENGAGEMENT_RANGE_RESTRICTION number @AC engagement range restriction (24)
--- @field EVASION_OF_ARM number @Evasion of ARM (31)
--- @type AI.Option.Ground.id
AI.Option.Ground.id = {}

--- @class AI.Option.Ground.val
--- @description Enumerator for ground unit option values.
--- @field ALARM_STATE AI.Option.Ground.val.ALARM_STATE
--- @field ROE AI.Option.Ground.val.ROE
--- @type AI.Option.Ground.val
AI.Option.Ground.val = {}

--- @class AI.Option.Ground.val.ALARM_STATE
--- @description Enumerator for alarm states.
--- @field AUTO number @Auto (0)
--- @field GREEN number @Green (1)
--- @field RED number @Red (2)
--- @type AI.Option.Ground.val.ALARM_STATE
AI.Option.Ground.val.ALARM_STATE = {}

--- @class AI.Option.Ground.val.ROE
--- @description Enumerator for rules of engagement.
--- @field OPEN_FIRE number @Open fire (2)
--- @field RETURN_FIRE number @Return fire (3)
--- @field WEAPON_HOLD number @Weapon hold (4)
--- @type AI.Option.Ground.val.ROE
AI.Option.Ground.val.ROE = {}

--- @class AI.Option.Naval
--- @description Enumerator for naval unit options.
--- @field id AI.Option.Naval.id
--- @field val AI.Option.Naval.val
--- @type AI.Option.Naval
AI.Option.Naval = {}

--- @class AI.Option.Naval.id
--- @description Enumerator for naval unit option IDs.
--- @field ROE number @ROE (0)
--- @type AI.Option.Naval.id
AI.Option.Naval.id = {}

--- @class AI.Option.Naval.val
--- @description Enumerator for naval unit option values.
--- @field ROE AI.Option.Naval.val.ROE
--- @type AI.Option.Naval.val
AI.Option.Naval.val = {}

--- @class AI.Option.Naval.val.ROE
--- @description Enumerator for rules of engagement.
--- @field OPEN_FIRE number @Open fire (2)
--- @field RETURN_FIRE number @Return fire (3)
--- @field WEAPON_HOLD number @Weapon hold (4)
--- @type AI.Option.Naval.val.ROE
AI.Option.Naval.val.ROE = {}

------------------------------------------------------------------------------
--- radio
------------------------------------------------------------------------------

--- @class radio
--- @description The radio singleton contains enumerators for radio modulation types.
--- @field modulation radio.modulation
--- @type radio
radio = {}

--- @class radio.modulation
--- @description Enumerator for radio modulation types.
--- @field AM number @AM (0)
--- @field FM number @FM (1)
--- @type radio.modulation
radio.modulation = {}

------------------------------------------------------------------------------
--- Disposition
------------------------------------------------------------------------------

--- @class Disposition
--- @description position functions
--- @field DriftRoute fun(pos1:vec3, pos2:vec3, coalitionId:number):table @creates safe route avoiding e.g. SAMs
--- @field getElipsSideZones fun(numAreas:number, numPositions:number, perim:table, degrees:number, radiusRatio:number):table @returns zones around runway strips
--- @field getPointHeight fun(pos:vec3):number @returns terrain height
--- @field getPointWater fun(pos:vec3, a:number, b:number):boolean @checks for water (radius/depth?)
--- @field getRandom fun(isFloat:boolean, min:number, max:number):number @get a random number
--- @field getRandomIn fun()
--- @field getRandomSort fun(t:table):table @randomly shuffles table
--- @field getRouteAwayWater fun(thresholdPos:vec3, pos:vec3, radius:number, step:number):boolean @checks if a route or area between two positions crosses water, returning true if water is present.
--- @field getRunwayPerimetr fun(runway:table):table @returns runway perimeter (runway data from airbase:getRunways)
--- @field getSimpleZones fun(pos:vec3, radius:number, posRadius:number, numPositions:number, water:boolean) @find in an area clear positions with a radius for placing units
--- @field getThresholdFourZones fun(numPositions:number, perim:table):table @returns zones along runway edges (perim)
--- @field setMarkerPoint fun()
--- @type Disposition
Disposition = {}
