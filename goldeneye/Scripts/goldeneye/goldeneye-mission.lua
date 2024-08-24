-- Goldeneye - Reconnaissance script

if Goldeneye then return end -- do not load twice

Goldeneye = {
    options = {
        debug = true,    --- @type boolean @debug mode, set true for ingame debug messages
        timeDelta = 1.0, --- @type number @time delta in seconds for main update loop
    },

    --- @type string[] @available aircraft types
    aircraftTypes = {
        "F-16C_50",
        "F-5E-3",
        "UH-1H",
    },

    --- @type string[] @available sensor types
    sensorTypes = {
        "Testsensor",
        "Omera-33",
        "Omera-40",
        "CA-200-LOROP",
        "Presto-Pod",
    },

    basedir = GoldeneyeBasedir or "", --- @type string @path to Scripts/goldeneye
    aircraft = {},                    --- @type table<string,Aircraft> @aircraft by type
    sensors = {},                     --- @type table<string,Sensor> @sensors by type
    players = {},                     --- @type table<number,Unit> @players by id
    groups = {},                      --- @type table<number,GroupInfo> @group infos by id
    scannedObjects = {},              --- @type table<number,Object> @scanned objects by id
    sceneryObjectWhitelist = {},      --- @type table<string,string> @scenery object whitelist
    nObjects = 0,                     --- @type number @total number of scanned objects
    camViewActive = false,            --- @type boolean @true while camera view active
    mainmenu = "Goldeneye",           --- @type string @main menu name
    eventHandlerId = "Goldeneye",     --- @type string @event handler id
    isRunning = false,                --- @type boolean @true while running
    isSinglePlayer = false,           --- @type boolean @true in singleplayer mode
}

------------------------------------------------------------------------------

--- @class GroupInfo
--- @field players Unit[] @list of player units in this group (multicrew)
--- @field menuitems string[] @list of active menu items for this group

--- @class Sensor
--- @field name string @sensor type name
--- @field horizFOV number @horizontal FOV in degrees
--- @field maxDistance number @maximum search distance in meters

--- @class Aircraft
--- @field payloads table<string,SensorMount[]> @list of sensor payloads

--- @class SensorMount
--- @field sensor string @sensor type name
--- @field position vec3 @relative position to aircraft
--- @field orientation vec3 @relative orientation to aircraft

------------------------------------------------------------------------------

--- debug log helper
--- @param msg string @message
--- @param duration number @duration
function Goldeneye:log(msg, duration)
    if self.options.debug then
        trigger.action.outText("[Goldeneye] " .. msg, duration or 10)
    end
end

--- load script (from inside mission or from file system)
--- @param filename string @filename relative to basedir
function Goldeneye:loadScript(filename)
    self:log("loading " .. filename)
    if self.basedir == "" then
        net.dostring_in("mission", "a_do_script_file('" .. filename .. "')")
    else
        net.dostring_in("mission", "a_do_script('dofile([[" .. self.basedir .. filename .. "]])')")
    end
end

------------------------------------------------------------------------------

--- start script
function Goldeneye:start()
    self:log("start")
    for _, aircraftType in ipairs(self.aircraftTypes) do
        self:loadScript("aircraft/" .. aircraftType .. ".lua")
    end
    for _, sensorType in ipairs(self.sensorTypes) do
        self:loadScript("sensors/" .. sensorType .. ".lua")
    end
    self:loadScript("data/scenery-object-whitelist.lua")

    world.addEventHandler(self)

    local player = world.getPlayer()
    if player then
        self:log("singleplayer mode")
        self.isSinglePlayer = true
        self:addPlayer(player)
    else
        self:log("multiplayer mode")
    end

    self.isRunning = true
    self:log("started")
    --self:update() @TODO after rewriting main loop
end

--- stop script
function Goldeneye:stop()
    self:log("stop")
    for index, handler in world.eventHandlers do
        if handler.eventHandlerId == self.eventHandlerId then
            world.eventHandlers[index] = nil
        end
    end
    missionCommands.removeItem(self.mainmenu)
    self.isRunning = false
    self:log("stopped")
end

--- event handler
--- @param event Event @event
function Goldeneye:onEvent(event)
    if event.id == world.event.S_EVENT_BIRTH then
        if event.initiator:getCategory() == Object.Category.UNIT then
            self:addPlayer(event.initiator)
        end
        -- elseif event.id == world.event.S_EVENT_DEAD then
        -- elseif event.id == world.event.S_EVENT_TAKEOFF then
        -- elseif event.id == world.event.S_EVENT_LAND then
        -- elseif event.id == world.event.S_EVENT_ENGINE_STARTUP then
        -- elseif event.id == world.event.S_EVENT_ENGINE_SHUTDOWN then
    else
        self:genericOnEvent(event)
    end
end

--- generic debug event handler
--- @param event Event @event
function Goldeneye:genericOnEvent(event)
    if self.eventNamesById == nil then
        self.eventNamesById = {}
        for key, value in pairs(world.event) do
            self.eventNamesById[value] = key
        end
    end
    self:log("event: " .. self.eventNamesById[event.id])
end

--- main update loop for recording @TODO
function Goldeneye:update()
    if not world.getPlayer() then
        return
    end
    local sensor = {
        position = world.getPlayer():getPosition(),
        maxDistance = 1000,
        horizFOV = 40,
        vertFOV = 30,
    }
    self:applyRotation(sensor.position.x, sensor.position.y, 0)
    self:searchObjects(sensor)
    timer.scheduleFunction(self.update, self, timer.getTime() + self.options.timeDelta)
end

------------------------------------------------------------------------------

--- add player or client unit
--- @param unit Unit @unit
function Goldeneye:addPlayer(unit)
    local unitId = unit:getID()
    local group = unit:getGroup()
    local groupId = group:getID()
    self:log(string.format("add player: %s (%d), group %s (%d)", unit:getName(), unitId, group:getName(), groupId))

    if not self:isReconAllowed(unit) then return end

    if self.players[unitId] then
        self:log("player already exists")
        return
    end
    self.players[unit:getID()] = unit

    if self.groups[groupId] == nil then
        self.groups[groupId] = { players = {}, menuitems = {} }
        missionCommands.addSubMenuForGroup(groupId, self.mainmenu, nil)
        self:log(string.format("main menu created for group %d", groupId))
    else
        self:log("group id already registered")
    end
    table.insert(self.groups[groupId].players, unit)

    self:refreshMenu(groupId)
end

--- checks if player unit is allowed to do recon
--- @param unit Unit @player unit
--- @return boolean @true if allowed
function Goldeneye:isReconAllowed(unit)
    local unitId = unit:getID()
    local unitType = unit:getTypeName()
    self:log(string.format("player id %d, aircraft type: %s", unitId, unitType))
    -- @TODO check unit type, name, weapons/ammo etc
    return true
end

function Goldeneye:isSelectPayloadAllowed(groupId)
    -- @TODO check if player is landed and near airbase
    return true
end

--- refresh menu entries for a group
--- @param groupId number @group id
function Goldeneye:refreshMenu(groupId)
    for _, item in ipairs(self.groups[groupId].menuitems) do
        missionCommands.removeItemForGroup(groupId, item)
    end
    self.groups[groupId].menuitems = {}

    if self:isSelectPayloadAllowed(groupId) then
        local item = missionCommands.addSubMenuForGroup(groupId, "Select payload", { self.mainmenu })
        table.insert(self.groups[groupId].menuitems, item)
    end

    if self.options.debug then
        local item1 = missionCommands.addCommandForGroup(groupId, "Toggle Camera", { self.mainmenu }, self.camViewToggle, self)
        table.insert(self.groups[groupId].menuitems, item1)
        local item2 = missionCommands.addCommandForGroup(groupId, "Debug Spawn", { self.mainmenu }, self.debugSpawn, self)
        table.insert(self.groups[groupId].menuitems, item2)
        local item3 = missionCommands.addCommandForGroup(groupId, "Save Objects", { self.mainmenu }, self.saveObjects, self)
        table.insert(self.groups[groupId].menuitems, item3)
        local item4 = missionCommands.addCommandForGroup(groupId, "Load Objects", { self.mainmenu }, self.loadObjects, self)
        table.insert(self.groups[groupId].menuitems, item4)
        local item5 = missionCommands.addCommandForGroup(groupId, "Scan Scenery", { self.mainmenu }, self.scanSceneryObjects, self)
        table.insert(self.groups[groupId].menuitems, item5)
    end
end

------------------------------------------------------------------------------

--- spawns debug statics in a grid around the player
--- @param grid_size number @distance between two statics in meters
--- @param rows number @number of rows
--- @param cols number @number of columns
function Goldeneye:debugSpawn(grid_size, rows, cols)
    grid_size = grid_size or 100
    rows = rows or 100
    cols = cols or 100
    local pos = world.getPlayer():getPoint()
    local start_x = pos.x - (rows * grid_size) / 2
    local start_y = pos.z - (cols * grid_size) / 2
    for i = 1, rows do
        for j = 1, cols do
            local staticId = 5000 + i * cols + j
            local staticObj = {
                ["heading"] = 0,
                ["shape_name"] = "Comp_cone", -- H-tyre_W, H-tyre_B, Comp_cone
                ["type"] = "Airshow_Cone",    -- White_Tyre, Black_Tyre, Airshow_Cone
                ["name"] = "debugstatic-" .. staticId,
                ["category"] = "Fortifications",
                ["x"] = start_x + i * grid_size,
                ["y"] = start_y + j * grid_size,
                ["unitId"] = 5000 + i,
                ["groupId"] = 5000 + i,
            }
            coalition.addStaticObject(country.id.USA, staticObj)
        end
    end
end

------------------------------------------------------------------------------

--- cam view toggle
function Goldeneye:camViewToggle()
    if self.camViewActive then
        self:camReset()
        return
    end
    local code = "Export.LoSetCommand(1708)"
    net.dostring_in("gui", code)
    -- need set position in another frame
    timer.scheduleFunction(self.camViewPosition, self, timer.getTime() + 0.01)
end

--- resets cam view to cockpit
function Goldeneye:camReset()
    local code = "Export.LoSetCommand(7);Export.LoSetCommand(36)"
    net.dostring_in("gui", code)
    self.camViewActive = false
end

--- sets cam view position
function Goldeneye:camViewPosition()
    self:log("Camera view")

    -- @todo replace with currently selected cam
    local payload = self.aircraft["UH-1H"].payloads["Testpayload"]
    local sensorMount = payload[1]
    local sensor = self.sensors[sensorMount.sensor]

    local dx, dy, dz = sensorMount.position.x, sensorMount.position.y, sensorMount.position.z
    local dyaw, dpitch, droll = sensorMount.orientation.yaw, sensorMount.orientation.pitch, sensorMount.orientation.roll

    -- copy player position
    local A = world.getPlayer():getPosition()
    local B = {
        p = { x = A.p.x, y = A.p.y, z = A.p.z },
        x = { x = A.x.x, y = A.x.y, z = A.x.z },
        y = { x = A.y.x, y = A.y.y, z = A.y.z },
        z = { x = A.z.x, y = A.z.y, z = A.z.z },
    }

    -- apply dx/dy/dz translation along A x/y/z vectors
    B.p.x = B.p.x + dz * B.z.x + dy * B.y.x + dx * B.x.x
    B.p.y = B.p.y + dz * B.z.y + dy * B.y.y + dx * B.x.y
    B.p.z = B.p.z + dz * B.z.z + dy * B.y.z + dx * B.x.z

    -- apply dyaw/dpitch/droll rotation offsets
    self:applyRotation(B.x, B.z, math.rad(dyaw))
    self:applyRotation(B.x, B.y, math.rad(dpitch))
    self:applyRotation(B.z, B.y, math.rad(droll))

    local code = "Export.LoSetCameraPosition({"
        .. "p = {x=" .. B.p.x .. ",y=" .. B.p.y .. ",z=" .. B.p.z .. "},"
        .. "x = {x=" .. B.x.x .. ",y=" .. B.x.y .. ",z=" .. B.x.z .. "},"
        .. "y = {x=" .. B.y.x .. ",y=" .. B.y.y .. ",z=" .. B.y.z .. "},"
        .. "z = {x=" .. B.z.x .. ",y=" .. B.z.y .. ",z=" .. B.z.z .. "}"
        .. "});DCS.setCurrentFOV(" .. sensor.horizFOV .. ")"
    net.dostring_in("gui", code)
    if not self.camViewActive then
        self.camViewActive = true
        self:camViewLoop()
    end
end

--- displays camera position offset and angles
function Goldeneye:camViewLoop()
    if not self.camViewActive then return end

    local code = "return net.lua2json(Export.LoGetCameraPosition())"
    local B = net.json2lua(net.dostring_in("gui", code))
    local A = world.getPlayer():getPosition()

    -- get world space distances and project onto player local axes
    local wdx, wdy, wdz = B.p.x - A.p.x, B.p.y - A.p.y, B.p.z - A.p.z
    local dx = wdx * A.x.x + wdy * A.x.y + wdz * A.x.z
    local dy = wdx * A.y.x + wdy * A.y.y + wdz * A.y.z
    local dz = wdx * A.z.x + wdy * A.z.y + wdz * A.z.z

    -- calculate relative rotation in degrees
    local dyaw = -math.deg(math.atan2(A.x.z, A.x.x) - math.atan2(B.x.z, B.x.x))
    local dpitch = -math.deg(math.asin(A.x.y) - math.asin(B.x.y))
    local droll = -math.deg(math.atan2(A.z.y, A.y.y) - math.atan2(B.z.y, B.y.y))

    local cyaw, cpitch, croll = self:rotationMatrixToEuler(B)
    local pyaw, ppitch, proll = self:rotationMatrixToEuler(A)
    local fov = net.dostring_in("gui", "return DCS.getCurrentFOV()")
    local msg = string.format("PLAYER\nx: %.6f\ny: %.6f\nz: %.6f\nyaw: %.6f\npitch: %.6f\nroll: %.6f\n\n", A.p.x, A.p.y, A.p.z, pyaw, ppitch, proll)
    msg = msg .. string.format("CAMERA\nx: %.6f\ny: %.6f\nz: %.6f\nyaw: %.6f\npitch: %.6f\nroll: %.6f\nfov: %.1f\n\n", B.p.x, B.p.y, B.p.z, cyaw, cpitch, croll, fov)
    msg = msg .. string.format("DELTA\nx: %.6f\ny: %.6f\nz: %.6f\nyaw: %.6f\npitch: %.6f\nroll: %.6f", dx, dy, dz, dyaw, dpitch, droll)
    trigger.action.outText(msg, 10, true)

    timer.scheduleFunction(self.camViewLoop, self, timer.getTime() + 0.1)
end

------------------------------------------------------------------------------

--- converts position rotation matrix to euler angles
--- @param p table @position
--- @return number, number, number @yaw, pitch, roll
function Goldeneye:rotationMatrixToEuler(p)
    local pitch = math.atan2(p.x.y, math.sqrt(p.x.z * p.x.z + p.x.x * p.x.x))
    local yaw = math.atan2(p.x.z, p.x.x)
    if yaw < 0 then yaw = yaw + 2 * math.pi end
    local roll = math.atan2(-p.z.y, p.y.y)
    return math.deg(yaw), math.deg(pitch), math.deg(roll)
end

--- rotates two vectors a and b around their shared perpendicular axis by the specified angle
--- yaw:   applyRotation(x, z, angle) - rotates around y axis
--- pitch: applyRotation(x, y, angle) - rotates around z axis
--- roll:  applyRotation(y, z, angle) - rotates around x axis
--- @param a vec3 @first vector
--- @param b vec3 @second vector
--- @param angle number @angle in radians
function Goldeneye:applyRotation(a, b, angle)
    local cos_angle, sin_angle = math.cos(angle), math.sin(angle)
    local ax, ay, az, bx, by, bz = a.x, a.y, a.z, b.x, b.y, b.z
    a.x, a.y, a.z = cos_angle * ax + sin_angle * bx, cos_angle * ay + sin_angle * by, cos_angle * az + sin_angle * bz
    b.x, b.y, b.z = cos_angle * bx - sin_angle * ax, cos_angle * by - sin_angle * ay, cos_angle * bz - sin_angle * az
end

--- search objects @TODO replace hardcode
function Goldeneye:searchObjects(sensor)
    local volume = {
        id = world.VolumeType.PYRAMID,
        params = {
            pos = sensor.position,
            length = sensor.maxDistance,
            halfAngleHor = math.rad(sensor.horizFOV / 2),
            halfAngleVer = math.rad(sensor.vertFOV / 2)
        }
    }
    local onFoundObject = function(object, sensor)
        local category = object:getCategory()
        local id = (category == Object.Category.SCENERY) and object.id_ or object:getID()
        if self.scannedObjects[id] == nil then
            self:log(string.format("[new object] category: %d, id: %d, type: %s, name: %s", category, id, object:getTypeName(), object:getName()))
            self.scannedObjects[id] = {
                category = category,
                type = object:getTypeName(),
                name = object:getName(),
                point = object:getPoint(),
            }
            self.nObjects = self.nObjects + 1
            trigger.action.smoke(object:getPoint(), category == Object.Category.SCENERY and trigger.smokeColor.green or trigger.smokeColor.Red)
        end
        return true
    end
    world.searchObjects(Object.Category.UNIT, volume, onFoundObject, sensor)
    world.searchObjects(Object.Category.STATIC, volume, onFoundObject, sensor)
    world.searchObjects(Object.Category.SCENERY, volume, onFoundObject, sensor)
end

function Goldeneye:recordObject(object)

end

------------------------------------------------------------------------------

--- save objects
function Goldeneye:saveObjects()
    self:log("saving sensor data")
    local missionName = net.dostring_in("server", "return DCS.getMissionName()")
    local path = lfs.writedir() .. "goldeneye-sensordata-" .. missionName .. ".json"
    local file, err = io.open(path, "w+")
    if err then return err end
    local data = {
        missionName = missionName,
        theatre = env.mission.theatre,
        date = env.mission.date,
        start_time = env.mission.start_time,
        objects = self.scannedObjects,
        nObjects = self.nObjects,
    }
    file:write(net.lua2json(data))
    file:close()
    self:log("saved " .. self.nObjects .. " objects")
end

--- load objects
function Goldeneye:loadObjects()
    self:log("loading sensor data")
    local missionName = net.dostring_in("server", "return DCS.getMissionName()")
    local path = lfs.writedir() .. "goldeneye-sensordata-" .. missionName .. ".json"
    local file, err = io.open(path, "r")
    if err then return err end
    local json = file:read("*a")
    file:close()
    local data = net.json2lua(json)
    self.scannedObjects = data.objects
    self.nObjects = data.nObjects
    self:log("loaded " .. self.nObjects .. " objects from mission " .. data.missionName .. "(" .. data.theatre .. ")")
    for _, object in pairs(self.scannedObjects) do
        trigger.action.smoke(object.point, trigger.smokeColor.Red)
    end
end

------------------------------------------------------------------------------

--- debug scenery objects scan
function Goldeneye:scanSceneryObjects()
    -- @todo refactor, see scratchpad
end

------------------------------------------------------------------------------

Goldeneye:start()
