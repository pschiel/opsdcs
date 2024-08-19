-- Goldeneye - Reconnaissance script

if Goldeneye then return end -- do not load twice

Goldeneye = {
    -- config
    options = {
        debug = true,
        updateTimeDelta = 1,
    },
    aircraftTypes = {
        "F-16C_50",
        "F-5E-3",
        "UH-1H",
    },
    sensorTypes = {
        "GoPro",
    },

    -- internal vars
    basedir = GoldeneyeBasedir or "",
    aircraft = {},
    sensors = {},
    players = {},
    objects = {},
    sceneryObjects = {},
    nObjects = 0,
    eventNamesById = nil,
    camViewActive = false,
}

-- debug log helper
function Goldeneye:log(msg, duration)
    if self.options.debug then
        trigger.action.outText("[Goldeneye] " .. msg, duration or 10)
    end
end

-- load script (from inside mission or from file system)
function Goldeneye:loadScript(filename)
    self:log("loading " .. filename)
    if self.basedir == "" then
        net.dostring_in("mission", "a_do_script_file('" .. filename .. "')")
    else
        net.dostring_in("mission", "a_do_script('dofile([[" .. self.basedir .. filename .. "]])')")
    end
end

-- start script
function Goldeneye:start()
    self:log("start")
    for _, aircraftType in ipairs(self.aircraftTypes) do
        self:loadScript("aircraft/goldeneye-aircraft-" .. aircraftType .. ".lua")
    end
    for _, sensorType in ipairs(self.sensorTypes) do
        self:loadScript("sensors/goldeneye-sensor-" .. sensorType .. ".lua")
    end
    self:loadScript("data/goldeneye-scenery-objects.lua")
    world.addEventHandler(self)
    -- SP
    local player = world.getPlayer()
    if player then
        self:addPlayer(player)
    end
end

-- event handler
function Goldeneye:onEvent(event)
    if self.eventNamesById == nil then
        self.eventNamesById = {}
        for key, value in pairs(world.event) do
            self.eventNamesById[value] = key
        end
    end
    self:log("event: " .. self.eventNamesById[event.id])

    if event.id == world.event.S_EVENT_BIRTH then
        if event.initiator:getCategory() == Object.Category.UNIT then
            self:addPlayer(event.initiator)
        end
    elseif event.id == world.event.S_EVENT_DEAD then
    elseif event.id == world.event.S_EVENT_TAKEOFF then
    elseif event.id == world.event.S_EVENT_LAND then
    elseif event.id == world.event.S_EVENT_ENGINE_STARTUP then
    elseif event.id == world.event.S_EVENT_ENGINE_SHUTDOWN then
    end
end

-- update loop
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
    timer.scheduleFunction(self.update, self, timer.getTime() + self.options.updateTimeDelta)
end

------------------------------------------------------------------------------

-- add player or client unit
function Goldeneye:addPlayer(unit)
    local group = unit:getGroup()
    self:log(string.format("add player: %s (%d), group %s (%d)", unit:getName(), unit:getID(), group:getName(), group:getID(), 10))
    self.players[unit:getID()] = unit
    self:enableSensorPayloadMenu(unit)
end

-- enable sensor payload menu
function Goldeneye:enableSensorPayloadMenu(unit)
    local group = unit:getGroup()
    local groupID = group:getID()
    self:log("enable sensor payload menu for group " .. groupID .. ", unit type: " .. unit:getTypeName(), 10)
    local mainmenu = missionCommands.addSubMenuForGroup(groupID, "Goldeneye", nil)
    missionCommands.addCommandForGroup(groupID, "Camera view", mainmenu, Goldeneye.camView, self)
    missionCommands.addCommandForGroup(groupID, "Camera reset", mainmenu, Goldeneye.camReset, self)
    missionCommands.addCommandForGroup(groupID, "Start update", mainmenu, Goldeneye.update, self)
    missionCommands.addCommandForGroup(groupID, "Save objects", mainmenu, Goldeneye.saveObjects, self)
    missionCommands.addCommandForGroup(groupID, "Load objects", mainmenu, Goldeneye.loadObjects, self)
end

------------------------------------------------------------------------------

-- cam view
function Goldeneye:camView()
    self:log("Camera view F2 local")
    local code = "Export.LoSetCommand(1708)"
    net.dostring_in("gui", code)
    -- need set position in another frame
    timer.scheduleFunction(self.camViewPosition, self, timer.getTime() + 0.01)
end

-- reset cam view to cockpit
function Goldeneye:camReset()
    local code = "Export.LoSetCommand(7);Export.LoSetCommand(36)"
    net.dostring_in("gui", code)
    self.camViewActive = false
end

-- cam view set position
function Goldeneye:camViewPosition()
    self:log("Camera view")
    local pos = world.getPlayer():getPosition()
    -- @todo get from sensor data
    local sensordata = self.aircraft["UH-1H"].payloads["1 Cam"][1]
    local fov = 30
    self:applyTranslation(pos.p, pos.x, sensordata.position.x)
    self:applyTranslation(pos.p, pos.z, sensordata.position.z)
    self:applyTranslation(pos.p, pos.y, sensordata.position.y)
    local yaw, pitch, roll = self:getEulerAngles(pos)
    local o = self:getOrientation(roll + sensordata.orientation.roll, pitch + sensordata.orientation.pitch, yaw + sensordata.orientation.yaw)
    local code = "Export.LoSetCameraPosition({"
        .. "p = {x=" .. pos.p.x .. ",y=" .. pos.p.y .. ",z=" .. pos.p.z .. "},"
        .. "x = {x=" .. o.x.x .. ",y=" .. o.x.y .. ",z=" .. o.x.z .. "},"
        .. "y = {x=" .. o.y.x .. ",y=" .. o.y.y .. ",z=" .. o.y.z .. "},"
        .. "z = {x=" .. o.z.x .. ",y=" .. o.z.y .. ",z=" .. o.z.z .. "}"
        .. "});DCS.setCurrentFOV(" .. fov .. ")"
    net.dostring_in("gui", code)
    self.camViewActive = true
    self:camViewLoop()
end

-- displays camera position offset and angles
function Goldeneye:camViewLoop()
    if not self.camViewActive then return end
    local code = "return net.lua2json(Export.LoGetCameraPosition())"
    local pos = net.json2lua(net.dostring_in("gui", code))
    local heading, pitch, roll = self:getEulerAngles(pos)
    local ppos = world.getPlayer():getPosition()
    local pheading, ppitch, proll = self:getEulerAngles(ppos)

    -- Calculate the displacement vector in world space
    local dx_world, dy_world, dz_world = pos.p.x - ppos.p.x, pos.p.y - ppos.p.y, pos.p.z - ppos.p.z

    -- Project world displacement onto player's local axes
    local dx = dx_world * ppos.x.x + dy_world * ppos.x.y + dz_world * ppos.x.z -- Forward/Backward
    local dy = dx_world * ppos.y.x + dy_world * ppos.y.y + dz_world * ppos.y.z -- Up/Down
    local dz = dx_world * ppos.z.x + dy_world * ppos.z.y + dz_world * ppos.z.z -- Right/Left

    local dheading, dpitch, droll = heading - pheading, pitch - ppitch, roll - proll

    local fov = net.dostring_in("gui", "return DCS.getCurrentFOV()")
    local msg = string.format("\n\nOffset:\nx: %.5f\ny: %.5f\nz: %.5f\nyaw: %.3f\npitch: %.3f\nroll: %.3f\nfov: %d", dx, dy, dz, dheading, dpitch, droll, fov)
    trigger.action.outText(msg, 10, true)

    timer.scheduleFunction(self.camViewLoop, self, timer.getTime() + 0.1)
end

------------------------------------------------------------------------------

-- Function to calculate heading, pitch, and roll from DCS position
function Goldeneye:getEulerAngles(p)
    local heading = math.atan2(p.x.z, p.x.x)
    if heading < 0 then heading = heading + 2 * math.pi end
    local pitch = math.asin(p.x.y)
    local roll = math.atan2(p.y.z, p.y.y)
    return math.deg(heading), math.deg(pitch), math.deg(roll)
end

-- returns orientation matrix from roll, pitch and heading
function Goldeneye:getOrientation(roll, pitch, heading)
    local h, p, r = math.rad(heading), math.rad(pitch), math.rad(roll)
    local o = { x = { x = 1, y = 0, z = 0 }, y = { x = 0, y = 1, z = 0 }, z = { x = 0, y = 0, z = 1 } }
    self:applyRotation(o.x, o.z, h)
    self:applyRotation(o.x, o.y, p)
    self:applyRotation(o.z, o.y, r)
    return o
end

-- rotates two vectors around their axes by the given angle
function Goldeneye:applyRotation(a, b, angle)
    local cos_angle, sin_angle = math.cos(angle), math.sin(angle)
    local ax, ay, az, bx, by, bz = a.x, a.y, a.z, b.x, b.y, b.z
    a.x, a.y, a.z = cos_angle * ax + sin_angle * bx, cos_angle * ay + sin_angle * by, cos_angle * az + sin_angle * bz
    b.x, b.y, b.z = cos_angle * bx - sin_angle * ax, cos_angle * by - sin_angle * ay, cos_angle * bz - sin_angle * az
end

-- translates a point along a vector by the given distance
function Goldeneye:applyTranslation(p, a, dist)
    p.x = p.x + dist * a.x
    p.y = p.y + dist * a.y
    p.z = p.z + dist * a.z
end

-- search objects
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
        if self.objects[id] == nil then
            self:log(string.format("[new object] category: %d, id: %d, type: %s, name: %s", category, id, object:getTypeName(), object:getName()))
            self.objects[id] = {
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

-- persist objects
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
        objects = self.objects,
        nObjects = self.nObjects,
    }
    file:write(net.lua2json(data))
    file:close()
    self:log("saved " .. self.nObjects .. " objects")
end

-- load objects
function Goldeneye:loadObjects()
    self:log("loading sensor data")
    local missionName = net.dostring_in("server", "return DCS.getMissionName()")
    local path = lfs.writedir() .. "goldeneye-sensordata-" .. missionName .. ".json"
    local file, err = io.open(path, "r")
    if err then return err end
    local json = file:read("*a")
    file:close()
    local data = net.json2lua(json)
    self.objects = data.objects
    self.nObjects = data.nObjects
    self:log("loaded " .. self.nObjects .. " objects from mission " .. data.missionName .. "(" .. data.theatre .. ")")
    for _, object in pairs(self.objects) do
        trigger.action.smoke(object.point, trigger.smokeColor.Red)
    end
end

------------------------------------------------------------------------------

-- debug scenery objects scan
function Goldeneye:scanSceneryObjects()

end

------------------------------------------------------------------------------

Goldeneye:start()
