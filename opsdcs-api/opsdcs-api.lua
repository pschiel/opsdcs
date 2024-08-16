-- opsdcs-api - simple and lightweight JSON API for DCS

OpsdcsApi = { host = "0.0.0.0", port = DCS ~= nil and 31481 or 31482, logging = true }

-- log helper
function OpsdcsApi:log(message)
    if self.logging then log.info("[opsdcs-api] " .. message) end
end

-- starts server
function OpsdcsApi:startServer()
    local socket = require("socket")
    self:log("starting server")
    self.server = assert(socket.bind(self.host, self.port))
    self.server:settimeout(0)
    self.targetCamera = nil
    self.defaultTargetCameraLerp = 0.05
    self.defaultCameraCommands = { 158, 36 }
    self.staticObjects = {}
    self.hasSimulationStarted = false
    self.hasSimulationPaused = true
    self.isMissionLoading = false
    self.missionServerDeltaTime = 0.01
    self.missionServerScheduleId = nil
end

-- stops server
function OpsdcsApi:stopServer()
    self:log("stopping server")
    if self.server then
        self.server:close()
        self.server = nil
    end
end

-- simulation start (main menu)
function OpsdcsApi:onSimulationStart()
    self:log("onSimulationStart")
    self.staticObjects = {}
    self.hasSimulationStarted = true
    if DCS == nil then
        timer.scheduleFunction(self.onSimulationFrame, self, timer.getTime() + self.missionServerDeltaTime)
    end
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
    if self.server == nil or self.isMissionLoading then return end
    local client = self.server:accept()
    if client then
        client:settimeout(60)
        local request, err = client:receive()
        if not err then
            local method, path, slug, queryString = request:match("^(%w+)%s(/[^/%?]+)/?([^%?]*)%??(.*)%sHTTP/%d%.%d$")
            local headers = self:getHeaders(client)
            local data = self:getBodyData(client, headers)
            if slug == "" then slug = nil end
            local query = {}
            queryString = queryString or ""
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
                elseif method == "GET" and path == "/camera-position" then
                    code, result = self:getCameraPosition()
                elseif method == "POST" and path == "/camera-position" then
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
                elseif method == "GET" and path == "/coords" then
                    code, result = self:getCoords(query)
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
    self:handleCamera()
    if DCS == nil then
        timer.scheduleFunction(self.onSimulationFrame, self, timer.getTime() + self.missionServerDeltaTime)
    end
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

-- url decode
function OpsdcsApi:urlDecode(str)
    str = string.gsub(str, "%%(%x%x)", function(hex)
        return string.char(tonumber(hex, 16))
    end)
    return str
end

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

-- loads file content
function OpsdcsApi:getFileContent(path)
    local file, err = io.open( path, "r" )
    if err then return err end
    local content = file:read("*a")
    file:close()
    return content
end

-- saves file content
function OpsdcsApi:saveFileContent(path, content)
    local file, err = io.open( path, "w+" )
    if err then return err end
    file:write(content)
    file:close()
    return
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

-- coord to degrees, minutes, seconds
function OpsdcsApi:toDMS(coord)
    local deg = math.floor(coord)
    local min = math.floor((coord - deg) * 60)
    local sec = ((coord - deg) * 60 - min) * 60
    return deg, min, sec
end

-- coord to degrees, decimal minutes
function OpsdcsApi:toDM(coord)
    local deg = math.floor(coord)
    local min = ((coord - deg) * 60)
    return deg, min
end

-- coord format LL: N 41°36'00"
function OpsdcsApi:formatLL(coord, isLat)
    local direction = (coord >= 0) and (isLat and "N" or "E") or (isLat and "S" or "W")
    coord = math.abs(coord)
    local degrees, minutes, seconds = self:toDMS(coord)
    return string.format("%s %02d°%02d'%02d\"", direction, degrees, minutes, math.floor(seconds))
end

-- coord format PLL: N 41°36'00.67"
function OpsdcsApi:formatPLL(coord, isLat)
    local direction = (coord >= 0) and (isLat and "N" or "E") or (isLat and "S" or "W")
    coord = math.abs(coord)
    local degrees, minutes, seconds = self:toDMS(coord)
    return string.format("%s %02d°%02d'%05.2f\"", direction, degrees, minutes, seconds)
end

-- coord format LLDM: N 41°36.008'
function OpsdcsApi:formatLLDM(coord, isLat)
    local direction = (coord >= 0) and (isLat and "N" or "E") or (isLat and "S" or "W")
    coord = math.abs(coord)
    local degrees, minutesFloat = self:toDM(coord)
    return string.format("%s %02d°%06.3f'", direction, degrees, minutesFloat)
end

-- parse LL format, return degrees
function OpsdcsApi:parseLL(input)
    local direction, degrees, minutes, seconds = input:match("([NSWE])%s*(%d+)°%s*(%d+)'%s*(%d+%.?%d*)\"?")
    if not direction then
        return tonumber(input)
    end
    local coord = tonumber(degrees) + tonumber(minutes) / 60 + tonumber(seconds) / 3600
    if direction == "S" or direction == "W" then
        coord = -coord
    end
    return coord
end

-- parse LLDM format, return degrees
function OpsdcsApi:parseLLDM(input)
    local direction, degrees, minutes = input:match("([NSWE])%s*(%d+)°%s*(%d+%.?%d*)'")
    if not direction then
        return tonumber(input)
    end
    local coord = tonumber(degrees) + tonumber(minutes) / 60
    if direction == "S" or direction == "W" then
        coord = -coord
    end
    return coord
end

-- parse any LL coordinate format, return degrees
function OpsdcsApi:parseCoordinate(input)
    input = self:urlDecode(input)
    input = input:gsub("%s+", "")
    if input:match("°.*'") then
        if input:match("%d+%.?%d*\"?") then
            return self:parseLL(input)
        elseif input:match("%d+%.?%d*'") then
            return self:parseLLDM(input)
        end
    else
        return tonumber(input)
    end
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
        if data.env == "mse" then
            -- mission scripting engine (no result)
            local escapedCode = data.code:gsub("\\", "\\\\"):gsub("'", "\\'")
            result = net.dostring_in("mission", "return a_do_script('" .. escapedCode .. "')")
        elseif data.env == "mission" or data.env == "gui" or data.env == "export" then
            -- any other env
            result = net.dostring_in(data.env, data.code)
        end
    else
        -- default (gui)
        result = loadstring(data.code)()
    end
    return 200, result
end

-- get camera position
function OpsdcsApi:getCameraPosition()
    local result = Export.LoGetCameraPosition()
    result.fov = DCS.getCurrentFOV()
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
        self.targetCameraLerp = data.lerp or self.defaultTargetCameraLerp
        data.commands = data.commands or self.defaultCameraCommands
    end
    if data.commands then
        for _, command in ipairs(data.commands) do
            Export.LoSetCommand(command)
        end
    end
    if data.fov then
        DCS.setCurrentFOV(tonumber(data.fov))
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
    local luaCode = ""
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
        luaCode = luaCode .. "coalition.addStaticObject(" .. static.country .. "," .. self:serializeTable(staticObject) .. ");"
        self.staticObjects[staticObject.name] = staticObject
        table.insert(result, staticObject)
    end
    if luaCode ~= "" then
        luaCode = "a_do_script([[" .. luaCode .. "]])"
        net.dostring_in("mission", luaCode)
    end
    return 200, result
end

-- deletes static objects
function OpsdcsApi:deleteStaticObjects(slug, data)
    local result = {}
    local luaCode = ""
    if slug == "all" then
        for name, _ in pairs(self.staticObjects) do
            luaCode = luaCode .. 'local s=StaticObject.getByName("' .. name .. '");if s then s:destroy() end;'
            self.staticObjects[name] = nil
        end
    else
        for _, name in ipairs(data) do
            if self.staticObjects[name] then
                luaCode = luaCode .. 'local s=StaticObject.getByName("' .. name .. '");if s then s:destroy() end;'
                self.staticObjects[name] = nil
            else
                table.insert(result, "static object not found: " .. name)
            end
        end
    end
    if luaCode ~= "" then
        luaCode = "a_do_script([[" .. luaCode .. "]])"
        net.dostring_in("mission", luaCode)
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
    local terrains = {
        -- fixme: bounds are not accurate
        ["Afghanistan"] = { bounds = { 29.1380386, 60.3788263, 39.0009356, 74.7805963 } },
        ["Caucasus"] = { bounds = { 40.3895774, 27.5420023, 47.6790855, 43.7848066 } },
        ["Kola"] = { bounds = { 64.2500055, 8.9591349, 71.8464196, 42.1817912 } },
        ["MarianaIslands"] = { bounds = { 10.8794944, 137.7591797, 21.6984876, 149.213188 } },
        ["Nevada"] = { bounds = { 34.3483316, -119.985425, 39.7982463, -112.1130805 } },
        ["Normandy"] = { bounds = { 48.209369, -1.9236945, 51.395154, 2.676616 } },
        ["PersianGulf"] = { bounds = { 22.5840866, 47.1226709, 32.8089894, 60.3479854 } },
        ["Sinai"] = { bounds = { 26.2339014, 28.8214748, 32.4262997, 36.2080106 } },
        ["SouthAtlantic"] = { bounds = { -56.3646796, -77.4595916, -47.6054687, -52.4547088 } },
        ["Syria"] = { bounds = { 31.9365414, 30.2493664, 37.6623492, 41.1213013 } },
        ["TheChannel"] = { bounds = { 49.6773349, -0.08918, 51.5572647, 3.4399315 } } 
    }
    for terrain, _ in pairs(terrains) do
        local hasBeacons, beacons = pcall(function() loadfile("./Mods/terrains/" .. terrain .. "/beacons.lua")() return beacons end)
        local hasRadio, radio = pcall(function() loadfile("./Mods/terrains/" .. terrain .. "/radio.lua")() return radio end)
        local hasTowns, towns = pcall(function() loadfile("./Mods/terrains/" .. terrain .. "/map/towns.lua")() return towns end)
        if hasBeacons then terrains[terrain].beacons = beacons end
        if hasRadio then terrains[terrain].radio = radio end
        if hasTowns then terrains[terrain].towns = towns end
    end
    return 200, terrains
end

-- converts any coordinate format
function OpsdcsApi:getCoords(query)
    local Terrain = require("terrain")
    local x, z, result = nil, nil, {}
    if query.x and query.z then
        x, z =tonumber(query.x), tonumber(query.z)
    elseif query.lat and query.lon then
        local lat, lon = self:parseCoordinate(query.lat), self:parseCoordinate(query.lon)
        x, z = Terrain.convertLatLonToMeters(lat, lon)
    elseif query.mgrs then
        x, z = Terrain.convertMGRStoMeters(self:urlDecode(query.mgrs))
    end
    if x and z then
        result.CCS = { x = x, z = z }
        local lat, lon = Terrain.convertMetersToLatLon(x, z)
        result.LL = { lat = self:formatLL(lat, true), lon = self:formatLL(lon, false) }
        result.PLL = { lat = self:formatPLL(lat, true), lon = self:formatPLL(lon, false) }
        result.LLDM = { lat = self:formatLLDM(lat, true), lon = self:formatLLDM(lon, false) }
        result.MGRS = Terrain.GetMGRScoordinates(x, z)
        local alt, seabed = Terrain.GetSurfaceHeightWithSeabed(x, z)
        result.height = { alt = alt, seabed = seabed }
    end
    return 200, result
end

------------------------------------------------------------------------------

if DCS ~= nil then
    DCS.setUserCallbacks({
        onSimulationStart = function() OpsdcsApi:onSimulationStart() end,
        onSimulationStop = function() OpsdcsApi:onSimulationStop() end,
        onSimulationFrame = function() OpsdcsApi:onSimulationFrame() end,
        onSimulationPause = function() OpsdcsApi:onSimulationPause() end,
        onSimulationResume = function() OpsdcsApi:onSimulationResume() end,
        onMissionLoadBegin = function() OpsdcsApi:onMissionLoadBegin() end,
        onMissionLoadEnd = function() OpsdcsApi:onMissionLoadEnd() end,
        -- n/i
        onPlayerConnect = function(id) end,
        onPlayerDisconnect = function(id) end,
        onPlayerStart = function(id) end,
        onPlayerStop = function(id) end,
        onPlayerChangeSlot = function(id) end,
        onPlayerTryConnect = function(addr, ucid, name, id) end,
        onPlayerTrySendChat = function(id, message, all) end,
        onPlayerTryChangeSlot = function(id, side, slot) end,
        onGameEvent = function(eventName) end,
        onShowBriefing = function() end,
        onShowGameMenu = function() end,
        onTriggerMessage = function(message, duration, clearView) end,
        onRadioMessage = function(message, duration) end,
        onChatMessage = function (message, id) end,
        onShowRadioMenu = function(id) end,
        onNetConnect = function(id) end,
        onNetDisconnect = function() end,
        onNetMissionChanged = function(missionName) end,

        onActivatePlane = function(unitType) end,
        onATCClientStatusUpdated = function() end,
    })
end

if DCS ~= nil then
    OpsdcsApi:startServer()
end
