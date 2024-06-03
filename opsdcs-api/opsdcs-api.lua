-- OpsdcsApi - simple and lightweight JSON API for DCS

-- debug
-- pcall(function()
--     package.cpath = package.cpath .. ';C:/Users/ops/.vscode/extensions/tangzx.emmylua-0.6.18/debugger/emmy/windows/x64/?.dll'
--     local dbg = require('emmy_core')
--     dbg.tcpConnect('localhost', 9966)
-- end)

OpsdcsApi = {}

-- create socket once sim is started
function OpsdcsApi:onSimulationStart()
    log.info("[opsdcs-api] onSimulationStart")
    local socket = require("socket")
    self.server = assert(socket.bind("127.0.0.1", 31481))
    self.server:settimeout(0)
    self.gserver = assert(socket.bind("127.0.0.1", 31480))  -- just for dwe support
    self.gserver:settimeout(0)
    self.targetCamera = nil  -- camera position for lerping
    self.staticObjects = {}  -- stores dynamically created static objects
end

-- close sockets
function OpsdcsApi:onSimulationStop()
    log.info("[opsdcs-api] onSimulationStop")
    if self.server then
        self.server:close()
        self.server = nil
    end
    if self.gserver then
        self.gserver:close()
        self.gserver = nil
    end
end

-- simulation paused
function OpsdcsApi:onSimulationPause()
    log.info("[opsdcs-api] onSimulationPause")
end

-- simulation resumed
function OpsdcsApi:onSimulationResume()
    log.info("[opsdcs-api] onSimulationResume")
end

-- runs every frame
function OpsdcsApi:onSimulationFrame()
    for _, server in ipairs({self.server, self.gserver}) do
        if server then
            local client = server:accept()
            if client then
                client:settimeout(60)
                local request, err = client:receive()
                if not err then
                    local method, path, slug, queryString = request:match("^(%w+)%s(/[^%?]+)([^%?]*)%??(.*)%sHTTP/%d%.%d$")
                    local headers = self:getHeaders(client)
                    local data = self:getBodyData(client, headers)
                    if slug == "" then slug = nil end
                    local query = {}
                    for key, value in queryString:gmatch("([^&=?]+)=([^&=?]+)") do
                        query[key] = value
                    end
                    if method == "OPTIONS" then
                        client:send(self:responseOptions())
                    else
                        local code, result = nil, nil
                        if method == "GET" and path == "/health" then
                            code, result = self:getHealth()
                        elseif method == "GET" and path == "/mission-data" then
                            code, result = self:getMissionData()
                        elseif method == "POST" and path == "/lua" then
                            code, result = self:postLua(data)
                        elseif method == "GET" and path == "/static-objects" then
                            code, result = self:getStaticObjects()
                        elseif method == "POST" and path == "/static-objects" then
                            code, result = self:postStaticObjects(data)
                        elseif method == "POST" and path == "/delete-static-objects" then
                            code, result = self:postDeleteStaticObjects(data)
                        elseif method == "DELETE" and path == "/clear-all" then
                            code, result = self:deleteAllStaticObjects()
                        elseif method == "POST" and path == "/set-camera-position" then
                            code, result = self:postSetCameraPosition(data)
                        elseif method == "GET" and path == "/export-world-objects" then
                            code, result = self:getExportWorldObjects()
                        elseif method == "GET" and path == "/db-countries" then
                            code, result = self:getDbCountries()
                        elseif method == "GET" and path == "/db-countries-by-name" then
                            code, result = self:getDbCountriesByName()
                        elseif method == "GET" and path == "/db-units" then
                            code, result = self:getDbUnits()
                        elseif method == "GET" and path == "/db-weapons" then
                            code, result = self:getDbWeapons()
                        elseif method == "GET" and path == "/db-callnames" then
                            code, result = self:getDbCallnames()
                        elseif method == "GET" and path == "/db-sensors" then
                            code, result = self:getDbSensors()
                        elseif method == "GET" and path == "/db-pods" then
                            code, result = self:getDbPods()
                        elseif method == "GET" and path == "/db-years" then
                            code, result = self:getDbYears()
                        elseif method == "GET" and path == "/db-years-launchers" then
                            code, result = self:getDbYearsLaunchers()
                        elseif method == "GET" and path == "/db-farp-objects" then
                            code, result = self:getDbFarpObjects()
                        elseif method == "GET" and path == "/db-objects" then
                            code, result = self:getDbObjects()
                        elseif method == "GET" and path == "/db-theatres" then
                            code, result = self:getDbTheatres()
                        elseif method == "GET" and path == "/db-terrains" then
                            code, result = self:getDbTerrains()
                        end
                        if code == 200 then
                            client:send(self:response200(result))
                        else
                            client:send(self:response404())
                        end
                    end
                end
                client:close()
            end
        end
    end
    self:handleCamera()
end

-- mission begin/end
function OpsdcsApi:onMissionLoadBegin()
    log.info("[opsdcs-api] onMissionLoadBegin")
end
function OpsdcsApi:onMissionLoadEnd(x)
    log.info("[opsdcs-api] onMissionLoadEnd")
end

-- server callbacks
function OpsdcsApi:onPlayerConnect(id)
    log.info("[opsdcs-api] onPlayerConnect: " .. tostring(id))
end
function OpsdcsApi:onPlayerDisconnect(id)
    log.info("[opsdcs-api] onPlayerDisconnect: " .. tostring(id))
end
function OpsdcsApi:onPlayerStart(id)
    log.info("[opsdcs-api] onPlayerStart: " .. tostring(id))
end
function OpsdcsApi:onPlayerStop(id)
    log.info("[opsdcs-api] onPlayerStop: " .. tostring(id))
end
function OpsdcsApi:onPlayerChangeSlot(id)
    log.info("[opsdcs-api] onPlayerChangeSlot: " .. tostring(id))
end
function OpsdcsApi:onPlayerTryConnect(addr, ucid, name, id)
    log.info("[opsdcs-api] onPlayerTryConnect: " .. tostring(addr) .. "/" .. tostring(ucid) .. "/" .. tostring(name) .. "/" .. tostring(id))
    return true
end
function OpsdcsApi:onPlayerTrySendChat(id, message, all)
    log.info("[opsdcs-api] onPlayerTrySendChat: " .. tostring(id) .. "/" .. tostring(message) .. "/" .. tostring(all))
    return message
end
function OpsdcsApi:onPlayerTryChangeSlot(id, side, slot)
    log.info("[opsdcs-api] onPlayerTryChangeSlot: " .. tostring(id) .. "/" .. tostring(side) .. "/" .. tostring(slot))
    return true
end

------------------------------------------------------------------------------

-- handles camera movement
function OpsdcsApi:handleCamera()
    if self.targetCamera then
        local camera = Export.LoGetCameraPosition()
        if not self:cameraEquals(camera, self.targetCamera, 0.01) then
            Export.LoSetCameraPosition(self:lerpCamera(camera, self.targetCamera, 0.05))
        else
            self.targetCamera = nil
        end
    end
end

-- lerp between camera positions
function OpsdcsApi:lerpCamera(cam1, cam2, t)
    for _, vec in ipairs({"x", "y", "z", "p"}) do
        for _, coord in ipairs({"x", "y", "z"}) do
            cam1[vec][coord] = cam1[vec][coord] + (cam2[vec][coord] - cam1[vec][coord]) * t
        end
    end
    return cam1
end

-- compare camera positions
function OpsdcsApi:cameraEquals(cam1, cam2, precision)
    for _, vec in ipairs({"x", "y", "z", "p"}) do
        for _, coord in ipairs({"x", "y", "z"}) do
            if math.abs(cam1[vec][coord] - cam2[vec][coord]) >= precision then
                return false
            end
        end
    end
    return true
end

-- yet another serialize helper
function OpsdcsApi:serializeTable(t)
    if type(t) ~= "table" then
        return tostring(t)
    end
    local str = "{"
    for k, v in pairs(t) do
        local key = type(k) == "string" and string.format("%q", k) or tostring(k)
        local value
        if type(v) == "table" then
            value = self:serializeTable(v)
        elseif type(v) == "string" then
            value = string.format("%q", v)
        else
            value = tostring(v)
        end
        str = str .. "[" .. key .. "]=" .. value .. ","
    end
    return str .. "}"
end

-- reads http headers
function OpsdcsApi:getHeaders(client)
    local headers = {}
    while true do
        local line, err = client:receive()
        if err or line == "" then break end
        local key, value = line:match("^(.-):%s*(.*)$")
        if key and value then
            headers[key:lower()] = value
        end
    end
    return headers
end

-- reads http body, returns json
function OpsdcsApi:getBodyData(client, headers)
    local body = nil
    if headers["content-length"] then
        local contentLength = tonumber(headers["content-length"])
        if contentLength > 0 then
            local json, err = client:receive(contentLength)
            if not err then
                local success, data = pcall(net.json2lua, json)
                if success then
                    body = data
                end
            end
        end
    end
    return body
end

-- default http headers
function OpsdcsApi:defaultHeaders()
    return "Access-Control-Allow-Origin: *\r\n"
        .. "Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS\r\n"
        .. "Access-Control-Allow-Headers: Content-Type\r\n"
end

-- options response
function OpsdcsApi:responseOptions()
    return "HTTP/1.1 204 No Content\r\n"
        .. "Access-Control-Max-Age: 86400\r\n"
        .. self:defaultHeaders() .. "\r\n"
end

-- 200 response
function OpsdcsApi:response200(data)
    return "HTTP/1.1 200 OK\r\n"
        .. "Content-Type: application/json\r\n"
        .. self:defaultHeaders() .. "\r\n"
        .. (data and net.lua2json(data) or "")
end

-- 404 response
function OpsdcsApi:response404()
    return "HTTP/1.1 404 Not Found\r\n"
        .. "Content-Type: text/plain\r\n"
        .. self:defaultHeaders() .. "\r\n"
        .. "404 Not Found"
end

-- rotates two vectors around their axes by the given angle
function OpsdcsApi:applyRotation(a, b, angle)
    local cos_angle, sin_angle = math.cos(angle), math.sin(angle)
    local ax, ay, az, bx, by, bz = a.x, a.y, a.z, b.x, b.y, b.z
    a.x, a.y, a.z = cos_angle * ax + sin_angle * bx, cos_angle * ay + sin_angle * by, cos_angle * az + sin_angle * bz
    b.x, b.y, b.z = cos_angle * bx - sin_angle * ax, cos_angle * by - sin_angle * ay, cos_angle * bz - sin_angle * az
end

-- returns orientation matrix from roll, pitch and heading
function OpsdcsApi:getOrientation(roll, pitch, heading)
    local h, p, r = math.rad(heading), math.rad(pitch), math.rad(roll)
    local o = {x = {x = 1, y = 0, z = 0}, y = {x = 0, y = 1, z = 0}, z = {x = 0, y = 0, z = 1}}
    self:applyRotation(o.x, o.z, h)
    self:applyRotation(o.x, o.y, p)
    self:applyRotation(o.z, o.y, r)
    return o
end

-- degrees to radians
function OpsdcsApi:deg2rad(degrees)
    if degrees < 0 then
        degrees = degrees + 360
    end
    return degrees * (math.pi / 180)
end

------------------------------------------------------------------------------

-- health check
function OpsdcsApi:getHealth()
    local result = {
        missionServerRunning = true,
        missionRunning = DCS.getCurrentMission() ~= nil,
    }
    return 200, result
end

-- returns mission data
function OpsdcsApi:getMissionData()
    local result = DCS.getCurrentMission()
    return 200, result
end

-- returns dynamically created static objects
function OpsdcsApi:getStaticObjects()
    local result = self.staticObjects
    return 200, result
end

-- runs lua code
function OpsdcsApi:postLua(data)
    local result = nil
    if data.env then
        result = net.dostring_in(data.env, data.code)
    else
        result = loadstring(data.code)()
    end
    return 200, result
end

-- sets camera position
function OpsdcsApi:postSetCameraPosition(data)
    if data.position then
        local x, z = terrain.convertLatLonToMeters(data.position[2], data.position[1])
        local y = data.position[3]
        if data.agl then
            y = y + terrain.GetHeight(x, z)
        end
        local orientation = self:getOrientation(data.roll, data.pitch, data.heading)
        self.targetCamera = {
            x = orientation.x,
            y = orientation.y,
            z = orientation.z,
            p = { x = x, y = y, z = z }
        }
        data.commands = data.commands or { 158, 36 }
    end
    if data.commands then
        for _, command in ipairs(data.commands) do
            Export.LoSetCommand(command)
        end
    end
    return 200
end

-- creates static objects
function OpsdcsApi:postStaticObjects(data)
    local result = {}
    for _, static in ipairs(data) do
        local pos = Export.LoGeoCoordinatesToLoCoordinates(static.position[1], static.position[2])
        local staticObject = {
            name = static.name,
            type = static.type,
            x = pos.x,
            y = pos.z,
            shape_name = static.shapeName,
            category = static.category,
            dead = static.dead or nil,
            rate = static.rate or nil,
            groupId = static.groupId or nil,
            unitId = static.unitId or nil,
            heading = static.heading and self:deg2rad(static.heading) or 0,
            linkOffset = static.linkOffset or nil,
            linkUnit = static.linkUnit or nil,
            offsets = static.offsets or nil,
            mass = static.mass or nil,
            canCargo = static.canCargo or nil,
            livery_id = static.livery_id or nil,
        }
        local luaCode = "a_do_script([[coalition.addStaticObject(" .. static.country .. "," .. self:serializeTable(staticObject) .. ")]])";
        net.dostring_in("mission", luaCode)
        self.staticObjects[staticObject.name] = staticObject
        table.insert(result, staticObject)
    end
    return 200, result
end

-- deletes static objects
function OpsdcsApi:postDeleteStaticObjects(data)
    for _, name in ipairs(data) do
        local luaCode = [[a_do_script('StaticObject.getByName("]] .. name .. [["):destroy()')]]
        net.dostring_in("mission", luaCode)
        self.staticObjects[name] = nil
    end
    return 200
end

-- deletes all static objects
function OpsdcsApi:deleteAllStaticObjects()
    for name, _ in pairs(self.staticObjects) do
        local luaCode = [[a_do_script('StaticObject.getByName("]] .. name .. [["):destroy()')]]
        net.dostring_in("mission", luaCode)
        self.staticObjects[name] = nil
    end
    return 200
end

-- returns Export world objects
function OpsdcsApi:getExportWorldObjects()
    local result = Export.LoGetWorldObjects()
    return 200, result
end

-- returns db.Countries
function OpsdcsApi:getDbCountries()
    local result = db.Countries
    return 200, result
end

-- returns db.CountriesByName
function OpsdcsApi:getDbCountriesByName()
    local result = db.CountriesByName
    return 200, result
end

-- returns db.Units
function OpsdcsApi:getDbUnits()
    local result = db.Units
    return 200, result
end

-- returns db.Weapons
function OpsdcsApi:getDbWeapons()
    local result = db.Weapons
    return 200, result
end

-- returns db.Callnames
function OpsdcsApi:getDbCallnames()
    local result = db.Callnames
    return 200, result
end

-- returns db.Sensors.Sensor
function OpsdcsApi:getDbSensors()
    local result = db.Sensors.Sensor
    return 200, result
end

-- returns db.Pods.Pod
function OpsdcsApi:getDbPods()
    local result = db.Pods.Pod
    return 200, result
end

-- returns _G.dbYears
function OpsdcsApi:getDbYears()
    local result = _G.dbYears
    return 200, result
end

-- returns _G.dbYearsLaunchers
function OpsdcsApi:getDbYearsLaunchers()
    local result = _G.dbYearsLaunchers
    return 200, result
end

-- returns _G.FARP_data.FARP_objects
function OpsdcsApi:getDbFarpObjects()
    local result = _G.FARP_data.FARP_objects
    return 200, result
end

-- returns _G.Objects
function OpsdcsApi:getDbObjects()
    local result = _G.Objects
    return 200, result
end

-- returns _G.theatresByName
function OpsdcsApi:getDbTheatres()
    local result = _G.theatresByName
    return 200, result
end

-- returns terrain data from lua files
function OpsdcsApi:getDbTerrains()
    local terrains = { "Caucasus", "Falklands", "Kola", "MarianaIslands", "Nevada", "Normandy", "PersianGulf", "Sinai", "Syria", "TheChannel" }
    local result = {}
    for _, terrain in ipairs(terrains) do
        local hasBeacons, beacons = pcall(function() loadfile("./Mods/terrains/" .. terrain .. "/beacons.lua")() return beacons end)
        local hasRadio, radio = pcall(function() loadfile("./Mods/terrains/" .. terrain .. "/radio.lua")() return radio end)
        local hasTowns, towns = pcall(function() loadfile("./Mods/terrains/" .. terrain .. "/map/towns.lua")() return towns end)
        result[terrain] = { beacons = hasBeacons and beacons or nil, radio = hasRadio and radio or nil, towns = hasTowns and towns or nil }
    end
    return 200, result
end

------------------------------------------------------------------------------

DCS.setUserCallbacks({
    onSimulationStart = function(...) OpsdcsApi:onSimulationStart(...) end,
    onSimulationStop = function(...) OpsdcsApi:onSimulationStop(...) end,
    onSimulationFrame = function(...) OpsdcsApi:onSimulationFrame(...) end,
    onSimulationPause = function(...) OpsdcsApi:onSimulationPause(...) end,
    onSimulationResume = function(...) OpsdcsApi:onSimulationResume(...) end,
    onMissionLoadBegin = function(...) OpsdcsApi:onMissionLoadBegin(...) end,
    onMissionLoadEnd = function(...) OpsdcsApi:onMissionLoadEnd(...) end,
    onPlayerConnect = function(...) OpsdcsApi:onPlayerConnect(...) end,
    onPlayerDisconnect = function(...) OpsdcsApi:onPlayerDisconnect(...) end,
    onPlayerStart = function(...) OpsdcsApi:onPlayerStart(...) end,
    onPlayerStop = function(...) OpsdcsApi:onPlayerStop(...) end,
    onPlayerChangeSlot = function(...) OpsdcsApi:onPlayerChangeSlot(...) end,
    onPlayerTryConnect = function(...) OpsdcsApi:onPlayerTryConnect(...) end,
    onPlayerTrySendChat = function(...) OpsdcsApi:onPlayerTrySendChat(...) end,
    onPlayerTryChangeSlot = function(...) OpsdcsApi:onPlayerTryChangeSlot(...) end,      
})

log.info("[opsdcs-api] loaded")
