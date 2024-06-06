-- OpsdcsApi - simple and lightweight JSON API for DCS

-- debug
-- pcall(function() package.cpath = package.cpath .. ";C:/Users/ops/.vscode/extensions/tangzx.emmylua-0.6.18/debugger/emmy/windows/x64/?.dll"; local dbg = require("emmy_core"); dbg.tcpConnect("localhost", 9966) end)

OpsdcsApi = { host = "127.0.0.1", port = 31481, logging = true }

-- log helper
function OpsdcsApi:log(message, ...)
    if self.logging then log.info("[opsdcs-api] " .. string.format(message, ...)) end
end

-- starts server
function OpsdcsApi:startServer()
    local socket = require("socket")
    self:log("starting server")
    self.server = assert(socket.bind(self.host, self.port))
    self.server:settimeout(0)
    self.targetCamera = nil
    self.staticObjects = {}
    self.hasSimulationStarted = false
    self.hasSimulationPaused = true
    self.isMissionLoading = false
    self.gserver = assert(socket.bind(self.host, 31480)); self.gserver:settimeout(0)  -- for dwe
end

-- stops server
function OpsdcsApi:stopServer()
    self:log("stopping server")
    if self.server then
        self.server:close()
        self.server = nil
    end
    if self.gserver then self.gserver:close() self.gserver = nil end  -- for dwe
end

-- simulation start (main menu)
function OpsdcsApi:onSimulationStart()
    self:log("onSimulationStart")
    self.staticObjects = {}
    self.hasSimulationStarted = true
end

-- simulation stopped
function OpsdcsApi:onSimulationStop()
    self:log("onSimulationStop")
    self.hasSimulationStarted = false
    self.hasSimulationPaused = true
end

-- simulation paused
function OpsdcsApi:onSimulationPause()
    self:log("onSimulationPause")
    self.hasSimulationPaused = true
end

-- simulation resumed
function OpsdcsApi:onSimulationResume()
    self:log("onSimulationResume")
    self.hasSimulationPaused = false
end

-- runs every frame (starting in main menu)
function OpsdcsApi:onSimulationFrame()
    if self.isMissionLoading then return end  -- do nothing during loading
    for _, server in ipairs({self.server, self.gserver}) do if server then  -- for dwe
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
                    elseif method == "GET" and path == "/current-mission" then
                        code, result = self:getCurrentMission()
                    elseif method == "POST" and path == "/lua" then
                        code, result = self:postLua(data)
                    elseif method == "GET" and path == "/static-objects" then
                        code, result = self:getStaticObjects(slug)
                    elseif method == "POST" and path == "/static-objects" then
                        code, result = self:postStaticObjects(data)
                    elseif method == "DELETE" and path == "/static-objects" then
                        code, result = self:deleteStaticObjects(slug, data)
                    elseif method == "POST" and path == "/groups" then
                        code, result = self:postGroups(data)
                    elseif method == "POST" and path == "/set-camera-position" then
                        code, result = self:postSetCameraPosition(data)
                    elseif method == "GET" and path == "/export-world-objects" then
                        code, result = self:getExportWorldObjects()
                    elseif method == "GET" and path == "/export-self-data" then
                        code, result = self:getExportSelfData()
                    elseif method == "GET" and path == "/player-unit" then
                        code, result = self:getPlayerUnit()
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
                    elseif method == "POST" and path == "/start-mission-server" then  -- for dwe
                        code, result = 200, {}
                    elseif method == "GET" and path == "/mission-data" then  -- for dwe
                        code, result = self:getCurrentMission()
                    elseif method == "DELETE" and path == "/clear-all" then  -- for dwe
                        code, result = self:deleteStaticObjects("all")
                    elseif method == "GET" and path == "/position-player" then  -- for dwe
                        code, result = self:getExportSelfData()
                    elseif method == "GET" and path == "/player-id" then  -- for dwe
                        code, result = self:getPlayerUnit()
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
    end end  -- for dwe
    self:handleCamera()
end

-- mission load begin/end
function OpsdcsApi:onMissionLoadBegin()
    self:log("onMissionLoadBegin")
    self.isMissionLoading = true
end
function OpsdcsApi:onMissionLoadEnd()
    self:log("onMissionLoadEnd")
    self.isMissionLoading = false
end

------------------------------------------------------------------------------
-- helper functions
------------------------------------------------------------------------------

-- handles camera movement
function OpsdcsApi:handleCamera()
    if self.targetCamera then
        local camera = Export.LoGetCameraPosition()
        if not self:cameraEquals(camera, self.targetCamera, 0.01) then
            Export.LoSetCameraPosition(self:lerpCamera(camera, self.targetCamera, self.targetCameraLerp))
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
-- endpoints
------------------------------------------------------------------------------

-- health check
function OpsdcsApi:getHealth()
    local result = {
        hasSimulationStarted = self.hasSimulationStarted,
        hasSimulationPaused = self.hasSimulationPaused,
        isServer = DCS.isServer(),
        isMultiplayer = DCS.isMultiplayer(),
        isTrackPlaying = DCS.isTrackPlaying()
    }
    result.missionServerRunning = true  -- for dwe
    result.missionRunning = self.hasSimulationStarted  -- for dwe
    return 200, result
end

-- returns current mission data
function OpsdcsApi:getCurrentMission()
    local result = DCS.getCurrentMission() or {}
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
        self.targetCameraLerp = data.lerp or 0.05
        data.commands = data.commands or { 158, 36 }
    end
    if data.commands then
        for _, command in ipairs(data.commands) do
            Export.LoSetCommand(command)
        end
    end
    return 200
end

-- returns dynamically created static objects
function OpsdcsApi:getStaticObjects(id)
    local result = {}
    if id == nil then
        result = self.staticObjects
    else
        for _, static in pairs(self.staticObjects) do
            if static.unitId == id then
                result = static
                break
            end
        end
    end
    return 200, result
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
function OpsdcsApi:deleteStaticObjects(slug, data)
    local result = {}
    if slug == "all" then
        for name, _ in pairs(self.staticObjects) do
            local luaCode = [[a_do_script('StaticObject.getByName("]] .. name .. [["):destroy()')]]
            net.dostring_in("mission", luaCode)
            self.staticObjects[name] = nil
        end
    else
        for _, name in ipairs(data) do
            if self.staticObjects[name] then
                local luaCode = [[a_do_script('StaticObject.getByName("]] .. name .. [["):destroy()')]]
                net.dostring_in("mission", luaCode)
                self.staticObjects[name] = nil
            else
                table.insert(result, "static object not found: " .. name)
            end
        end
    end
    return 200, result
end

-- creates groups
function OpsdcsApi:postGroups(data)
    local result = {}
    for _, group in ipairs(data) do
        -- @todo
    end
    return 200, result
end

-- returns Export world objects
function OpsdcsApi:getExportWorldObjects()
    local result = Export.LoGetWorldObjects()
    return 200, result
end

-- returns player data
function OpsdcsApi:getExportSelfData()
    local result = Export.LoGetSelfData()
    return 200, result
end

-- returns player unit
function OpsdcsApi:getPlayerUnit()
    local result = DCS.getPlayerUnit()
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

-- returns dbYears
function OpsdcsApi:getDbYears()
    local result = dbYears
    return 200, result
end

-- returns dbYearsLaunchers
function OpsdcsApi:getDbYearsLaunchers()
    local result = dbYearsLaunchers
    return 200, result
end

-- returns FARP_data.FARP_objects
function OpsdcsApi:getDbFarpObjects()
    local result = FARP_data.FARP_objects
    return 200, result
end

-- returns Objects
function OpsdcsApi:getDbObjects()
    local result = Objects
    return 200, result
end

-- returns theatresByName
function OpsdcsApi:getDbTheatres()
    local result = theatresByName
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
    onSimulationStart = function() OpsdcsApi:onSimulationStart() end,
    onSimulationStop = function() OpsdcsApi:onSimulationStop() end,
    onSimulationFrame = function() OpsdcsApi:onSimulationFrame() end,
    onSimulationPause = function() OpsdcsApi:onSimulationPause() end,
    onSimulationResume = function() OpsdcsApi:onSimulationResume() end,
    onMissionLoadBegin = function() OpsdcsApi:onMissionLoadBegin() end,
    onMissionLoadEnd = function() OpsdcsApi:onMissionLoadEnd() end,
    -- n/i
    onPlayerConnect = function(id) OpsdcsApi:log("onPlayerConnect: %d", id) end,
    onPlayerDisconnect = function(id) OpsdcsApi:log("onPlayerDisconnect: %d", id) end,
    onPlayerStart = function(id) OpsdcsApi:log("onPlayerStart: %d", id) end,
    onPlayerStop = function(id) OpsdcsApi:log("onPlayerStop: %d", id) end,
    onPlayerChangeSlot = function(id) OpsdcsApi:log("onPlayerChangeSlot: %d", id) end,
    onPlayerTryConnect = function(addr, ucid, name, id) OpsdcsApi:log("onPlayerTryConnect: %s %s %s %d", addr, ucid, name, id) end,
    onPlayerTrySendChat = function(id, message, all) OpsdcsApi:log("onPlayerTrySendChat: %d %s %s", id, message, all) end,
    onPlayerTryChangeSlot = function(id, side, slot) OpsdcsApi:log("onPlayerTryChangeSlot: %d %d %d", id, side, slot) end,
    onGameEvent = function(eventName) OpsdcsApi:log("onGameEvent: %s", eventName) end,
    onShowBriefing = function() OpsdcsApi:log("onShowBriefing") end,
    onShowGameMenu = function() OpsdcsApi:log("onShowGameMenu") end,
    onTriggerMessage = function(message, duration, clearView) OpsdcsApi:log("onTriggerMessage: %s %.2f %s", message, duration, clearView) end,
    onRadioMessage = function(message, duration) OpsdcsApi:log("onRadioMessage: %s %.2f", message, duration) end,
    onChatMessage = function (message, id) OpsdcsApi:log("onChatMessage: %s %d", message, id) end,
    onShowRadioMenu = function(id) OpsdcsApi:log("onShowRadioMenu: %d", id) end,
    onNetConnect = function(id) OpsdcsApi:log("onNetConnect: %d", id) end,
    onNetDisconnect = function() OpsdcsApi:log("onNetDisconnect") end,
    onNetMissionChanged = function(missionName) OpsdcsApi:log("onNetMissionChanged: %s", missionName) end,
})

OpsdcsApi:startServer()
