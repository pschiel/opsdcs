------------------------------------------------------------------------------
--- EXPORT ENV
--- used by Export.lua scripts and net.dostring_in("export", ..)
------------------------------------------------------------------------------

--- @type table
package = {}

--- @param module string
function require(module) end

--- @type lfs
lfs = {}

--- @type io
io = {}

--- @type os
os = {}

------------------------------------------------------------------------------
--- Export functions
------------------------------------------------------------------------------

--- @class Export
--- @description Export functions (available in Export.lua)
--- @field GetClickableElements fun():table @Gets clickable elements (Misc)
--- @field GetDevice fun(id:number):table @Gets device (Misc)
--- @field GetIndicator fun(id:number):table @Gets indicator (Misc)
--- @field LoGeoCoordinatesToLoCoordinates fun(longitude_degrees:number, latitude_degrees:number):Vec3 @geo to ll (Always)
--- @field LoGetADIPitchBankYaw fun():number, number, number @Gets ADI pitch, bank and yaw (Ownship)
--- @field LoGetAccelerationUnits fun():table @Gets acceleration units (Ownship)
--- @field LoGetAircraftDrawArgumentValue fun()
--- @field LoGetAltitude fun(x:number, z:number):number @Gets altitude (Always)
--- @field LoGetAltitudeAboveGroundLevel fun():number @Gets altitude above ground level (Ownship)
--- @field LoGetAltitudeAboveSeaLevel fun():number @Gets altitude above sea level (Ownship)
--- @field LoGetAngleOfAttack fun():number @Gets angle of attack (Ownship)
--- @field LoGetAngleOfSideSlip fun()
--- @field LoGetAngularVelocity fun():Vec3 @Get angular velocity (Ownship)
--- @field LoGetBasicAtmospherePressure fun():number @Gets basic atmosphere pressure (Ownship)
--- @field LoGetCameraPosition fun():Position3 @Gets camera position (Ownship)
--- @field LoGetControlPanel_HSI fun():table @Gets control panel HSI (Ownship)
--- @field LoGetEngineInfo fun():table @Gets engine info (Ownship)
--- @field LoGetF15_TWS_Contacts fun()
--- @field LoGetFMData fun()
--- @field LoGetGlideDeviation fun():number @Gets glide deviation (Ownship)
--- @field LoGetHeightWithObjects fun()
--- @field LoGetHelicopterFMData fun():table @Heli FM data (Ownship)
--- @field LoGetInAir fun()
--- @field LoGetIndicatedAirSpeed fun():number @Gets indicated air speed (Ownship)
--- @field LoGetLockedTargetInformation fun():table @Gets locked target information (Sensor)
--- @field LoGetMCPState fun():table @Gets MCP state (Ownship)
--- @field LoGetMachNumber fun():number @Gets Mach number (Ownship)
--- @field LoGetMagneticYaw fun():number @Gets magnetic yaw (Ownship)
--- @field LoGetMechInfo fun():table @Mechanization info (Ownship)
--- @field LoGetMissionStartTime fun():number @Returns mission start time (Always)
--- @field LoGetModelTime fun():number @Returns current model time (Always)
--- @field LoGetNameByType fun(level1:number, level2:number, level3:number, level4:number):string @Weapon Control System (Always)
--- @field LoGetNavigationInfo fun():table @Gets navigation info (Ownship)
--- @field LoGetObjectById fun(id:number):table @Gets object by id (Object)
--- @field LoGetPayloadInfo fun():table @Return weapon stations (Ownship)
--- @field LoGetPilotName fun():string @Gets pilot name (Always)
--- @field LoGetPlayerPlaneId fun():number @Gets player plane ID (Ownship)
--- @field LoGetPlayerUnitId fun()
--- @field LoGetRadarAltimeter fun()
--- @field LoGetRadioBeaconsStatus fun():table @Beacons lock (Ownship)
--- @field LoGetRoute fun():table @Gets route info (Ownship)
--- @field LoGetSelfData fun():table @Gets self data (Ownship)
--- @field LoGetShakeAmplitude fun()
--- @field LoGetSideDeviation fun():number @Gets side deviation (Ownship)
--- @field LoGetSightingSystemInfo fun():table @Sight system info (Sensor)
--- @field LoGetSlipBallPosition fun():number @Gets slip ball position (Ownship)
--- @field LoGetSnares fun():table @Get chaff/flare info (Ownship)
--- @field LoGetTWSInfo fun():table @Get TWS info (Sensor)
--- @field LoGetTargetInformation fun():table @Gets target information (Sensor)
--- @field LoGetTrueAirSpeed fun():number @Gets true air speed (Ownship)
--- @field LoGetVectorVelocity fun():Vec3 @Get vector velocity (Ownship)
--- @field LoGetVectorWindVelocity fun():Vec3 @Get wind velocity (Ownship)
--- @field LoGetVersionInfo fun():string @Gets version info (Always)
--- @field LoGetVerticalVelocity fun():number @Gets vertical velocity (Ownship)
--- @field LoGetWindAtPoint fun()
--- @field LoGetWingInfo fun():table @Get wingmen info (Ownship)
--- @field LoGetWingTargets fun():table @Get wing targets (Sensor)
--- @field LoGetWorldObjects fun(type:string):table @Gets world objects (Object)
--- @field LoIsObjectExportAllowed fun()
--- @field LoIsOwnshipExportAllowed fun()
--- @field LoIsSensorExportAllowed fun()
--- @field LoLoCoordinatesToGeoCoordinates fun(x:number, z:number):number, number @ll to geo (Always)
--- @field LoSetCameraPosition fun(pos:Position3) @Set camera position (Ownship)
--- @field LoSetCommand fun(command:number, value:number) @Set command (Ownship)
--- @field LoSimulationOnActivePause fun()
--- @field LoSimulationOnPause fun()
--- @field LuaExportActivityNextEvent fun(t:any):any @Put your event code here and increase return value for the next event. if return value == t then the activity will be terminated
--- @field LuaExportAfterNextFrame fun() @Works just after every simulation frame.
--- @field LuaExportBeforeNextFrame fun() @Works just before every simulation frame.
--- @field LuaExportStart fun() @Works once just before mission start.
--- @field LuaExportStop fun() @Works once just after mission stop.
