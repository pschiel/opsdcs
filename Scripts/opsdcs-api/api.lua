OpsdcsApi = {}
dofile(lfs.writedir() .. "Scripts/opsdcs-api/camera.lua")

function OpsdcsApi:onSimulationStart()
    local socket = require("socket")
    self.server = assert(socket.bind("127.0.0.1", 31481))
    self.server:settimeout(0)
    self.gserver = assert(socket.bind("127.0.0.1", 31480)) -- just for dwe
    self.gserver:settimeout(0)
    self.targetCamera = nil
    self.staticObjectsByName = {}
end

function OpsdcsApi:onSimulationStop()
    if self.server then
        self.server:close()
        self.server = nil
    end
    if self.gserver then
        self.gserver:close()
        self.gserver = nil
    end
end

function OpsdcsApi:onSimulationFrame()
    for _, server in ipairs({self.server, self.gserver}) do
        if server then
            local client = server:accept()
            if client then
                client:settimeout(60)
                local request, err = client:receive()
                if not err then
                    local method, path, id = request:match("^(%w+)%s(/%S-)/?(%d*)%sHTTP/%d%.%d$")
                    local headers = self:getHeaders(client)
                    local body = self:getBody(client, headers)
                    if id == "" then id = nil end
                    if method == "OPTIONS" then
                        client:send(self:responseOptions())
                    else
                        local filename = lfs.writedir() .. "Scripts/opsdcs-api/endpoints/"
                            .. string.lower(method) .. "-" .. string.sub(path, 2) .. ".lua"
                        if lfs.attributes(filename) then
                            local handleRequest = dofile(filename)
                            if handleRequest then
                                local response = handleRequest(body, id)
                                client:send(response)
                            else
                                client:send(self:response404())
                            end
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

function OpsdcsApi:serializeTable(t)
    if type(t) ~= "table" then
        return tostring(t)
    end
    local str = "{"
    for k, v in pairs(t) do
        local key = type(k) == "string" and string.format("%q", k) or tostring(k)
        local value = type(v) == "table" and self:serializeTable(v) or string.format("%q", v)
        str = str .. "[" .. key .. "]=" .. value .. ","
    end
    return str .. "}"
end

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

function OpsdcsApi:getBody(client, headers)
    local body = nil
    if headers["content-length"] then
        local contentLength = tonumber(headers["content-length"])
        if contentLength > 0 then
            body, err = client:receive(contentLength)
            if err then body = nil end
        end
    end
    return body
end

function OpsdcsApi:responseOptions()
    local response = "HTTP/1.1 204 No Content\r\n"
        .. "Access-Control-Allow-Origin: *\r\n"
        .. "Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS\r\n"
        .. "Access-Control-Allow-Headers: Content-Type\r\n"
        .. "Access-Control-Max-Age: 86400\r\n\r\n"
    return response
end

function OpsdcsApi:response200(data)
    local response = "HTTP/1.1 200 OK\r\n"
        .. "Content-Type: application/json\r\n"
        .. "Access-Control-Allow-Origin: *\r\n"
        .. "Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS\r\n"
        .. "Access-Control-Allow-Headers: Content-Type\r\n\r\n"
    if data then
        response = response .. net.lua2json(data)
    end
    return response
end

function OpsdcsApi:response404()
    local response = "HTTP/1.1 404 Not Found\r\n"
        .. "Content-Type: text/plain\r\n"
        .. "Access-Control-Allow-Origin: *\r\n"
        .. "Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS\r\n"
        .. "Access-Control-Allow-Headers: Content-Type\r\n\r\n"
        .. "404 Not Found"
    return response
end

DCS.setUserCallbacks({
    onSimulationStart = function() OpsdcsApi:onSimulationStart() end,
    onSimulationStop = function() OpsdcsApi:onSimulationStop() end,
    onSimulationFrame = function() OpsdcsApi:onSimulationFrame() end	
})
