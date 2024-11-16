--- Example UDP Export handler
---
--- reload this during runtime by running:
--- net.dostring_in("export", "dofile(lfs.writedir() .. 'Scripts/example-export/MyExample.lua')")
---
--- UDP test listener (Powershell):
--- $port = 34567; $udpClient = New-Object System.Net.Sockets.UdpClient $port; $endPoint = New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Any, 0); while ($true) { $data = $udpClient.Receive([ref]$endPoint); $message = [Text.Encoding]::UTF8.GetString($data); Write-Host "Received: $message" }

-- JSON helper from DCS files. works for basic stuff.
local JSON = loadfile("Scripts\\JSON.lua")()

-- LuaSocket
package.path = package.path .. ";.\\LuaSocket\\?.lua;"
package.cpath = package.cpath .. ";.\\LuaSocket\\?.dll;"
local socket = require("socket")

--- MyExample Export handler object
MyExample = {
    options = {
        address = "127.0.0.1",
        port = 34567,
        timeout = 0,
    },
    udpsocket = nil,
}

--- Helper function to write/send some data
--- @param data table @data to write/send
function MyExample:sendData(data)
    local jsonData = JSON:encode(data)
    if self.udpsocket then
        self.udpsocket:send(jsonData)
    end
end

--- Called before mission start
--- Make initializations of files or connections here
function MyExample:LuaExportStart()
    self.udpsocket = socket.try(socket.udp())
    socket.try(self.udpsocket:setpeername(self.options.address, self.options.port))
    socket.try(self.udpsocket:settimeout(self.options.timeout))
end

--- Called after mission stop
--- Close files or connections here
function MyExample:LuaExportStop()
    if self.udpsocket then
        socket.try(self.udpsocket:close())
        self.udpsocket = nil
    end
end

--- Called before every simulation frame
--- Used with e.g. LoSetCommand()
function MyExample:LuaExportBeforeNextFrame()
end

--- Called after every simulation frame
--- Used e.g. with LoGet functions, and writing or sending data somewhere
function MyExample:LuaExportAfterNextFrame()
    -- get some data
    local data = {
        vectorVelocity = LoGetVectorVelocity(),
        angularVelocity = LoGetAngularVelocity(),
    }
    self:sendData(data)
end

--- Called on player birth event
function MyExample:LuaExportOnHumanStart()
    self:sendData({ message = "Player spawned" })
end

--- Called on player death event
function MyExample:LuaExportOnHumanStop()
    self:sendData({ message = "Player died" })
end
