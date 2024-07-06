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
    nObjects = 0,
    eventNamesById = nil,
}

-- debug log helper
function Goldeneye:log(msg, duration)
    if self.options.debug then
        trigger.action.outText("[debug] " .. msg, duration or 2)
    end
end

-- load script (from inside mission or from file system)
function Goldeneye:loadScript(filename)
    self:log("loading " .. filename)
    if self.basedir == "" then
        net.dostring_in('mission', 'a_do_script_file("' .. filename .. '")')
    else
        net.dostring_in('mission', 'a_do_script("dofile([[' .. self.basedir .. filename .. ']])")')
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
    missionCommands.addCommandForGroup(groupID, "Camera view", nil, Goldeneye.camView, self)
    missionCommands.addCommandForGroup(groupID, "Camera reset", nil, Goldeneye.camReset, self)
    missionCommands.addCommandForGroup(groupID, "Start update", nil, Goldeneye.update, self)
    missionCommands.addCommandForGroup(groupID, "Save objects", nil, Goldeneye.saveObjects, self)
    missionCommands.addCommandForGroup(groupID, "Load objects", nil, Goldeneye.loadObjects, self)
end

------------------------------------------------------------------------------

-- cam view
function Goldeneye:camView()
    self:log("Camera view")
    local pos = world.getPlayer():getPosition()
    self:applyRotation(pos.x, pos.y, 0)
    local dist = -1
    pos.p.x = pos.p.x - dist * pos.x.x
    pos.p.y = pos.p.y - dist * pos.x.y
    pos.p.z = pos.p.z - dist * pos.x.z
    local code = "Export.LoSetCommand(1708);Export.LoSetCameraPosition({"
        .. "p = {x=" .. pos.p.x .. ",y=" .. pos.p.y .. ",z=" .. pos.p.z .. "},"
        .. "x = {x=" .. pos.x.x .. ",y=" .. pos.x.y .. ",z=" .. pos.x.z .. "},"
        .. "y = {x=" .. pos.y.x .. ",y=" .. pos.y.y .. ",z=" .. pos.y.z .. "},"
        .. "z = {x=" .. pos.z.x .. ",y=" .. pos.z.y .. ",z=" .. pos.z.z .. "}"
        .. "});DCS.setCurrentFOV(40)"
    net.dostring_in("gui", code)
end

-- reset cam
function Goldeneye:camReset()
    local code = "Export.LoSetCommand(7);Export.LoSetCommand(36)"
    net.dostring_in("gui", code)
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
    local missionName = net.dostring_in("server","return DCS.getMissionName()")
    local path = lfs.writedir() .. "goldeneye-sensordata-" .. missionName .. ".json"
    local file, err = io.open( path, "w+" )
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
    local missionName = net.dostring_in("server","return DCS.getMissionName()")
    local path = lfs.writedir() .. "goldeneye-sensordata-" .. missionName .. ".json"
    local file, err = io.open( path, "r" )
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

Goldeneye:start()
