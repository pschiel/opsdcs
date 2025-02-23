-- LuaImGui example hook
-- @see https://github.com/08jne01/dcs-lua-imgui
-- (needs small patch so initial window sizes work)
-- 
-- Installation:
-- 1. Copy this file to Scripts/Hooks folder
-- 2. Copy LuaImGui folder to Scripts folder

_G.lua_imgui_dll_path = lfs.writedir() .. "Scripts/LuaImGui/" -- path to LuaImGui.dll
_G.lua_imgui_lua_path = lfs.writedir() .. "Scripts/LuaImGui/" -- path to LuaImGui.lua
_G.imgui_disabled = false                                     -- set to true to disable ImGui
dofile(lua_imgui_lua_path .. "ImGui.lua")

---------------------------------------------------------------------------

_G.MyImGui = {
    isRunning = false,
    eventHandlerInjected = false,
    buffers = {},
}

--- Setup ImGui menu
function MyImGui:setup()
    ImGui.AddItem("Aircraft", "Self Data", function() self:selfData() end, 500, 600)
    ImGui.AddItem("Aircraft", "DB Data", function() self:aircraftData() end, 700, 600)
    ImGui.AddItem("Aircraft", "Engine Info", function() self:engineInfo() end, 500, 400)
    ImGui.AddItem("Aircraft", "MCP State", function() self:mcpState() end, 500, 400)
    ImGui.AddItem("Aircraft", "Mech Info", function() self:mechInfo() end, 500, 600)
    ImGui.AddItem("Aircraft", "Payload Info", function() self:payloadInfo() end, 500, 400)
    ImGui.AddItem("Cockpit", "Cockpit Params", function() self:cockpitParams() end, 800, 600)
    ImGui.AddItem("Cockpit", "Cockpit Arguments", function() self:cockpitArguments() end, 800, 600)
    ImGui.AddItem("Cockpit", "Argument Detector", function() self:argumentDetector(0.05, 5) end, 800, 600)
    ImGui.AddItem("Cockpit", "Clickable Elements", function() self:clickableElements() end, 500, 600)
    ImGui.AddItem("Mission", "World Objects", function() self:worldObjects() end, 1400, 600)
    ImGui.AddItem("Mission", "Flags", function() self:missionFlags() end, 400, 700)
    ImGui.AddItem("Mission", "Mission Table", function() self:missionTable() end, 700, 600)
    ImGui.AddItem("Mission", "Events", function() self:missionEvents() end, 400, 80)
    ImGui.AddItem("Telemetry", "AoA", function() self:telemetryAoA() end, 515, 340)
    ImGui.AddItem("Telemetry", "Pitch", function() self:telemetryPitch() end, 515, 340)
    ImGui.AddItem("Telemetry", "Bank", function() self:telemetryBank() end, 515, 340)
    ImGui.AddItem("Telemetry", "Heading", function() self:telemetryYaw() end, 515, 340)
    ImGui.AddItem("Telemetry", "Side Slip Angle", function() self:telemetrySideSlipAngle() end, 515, 340)
    ImGui.AddItem("Telemetry", "Velocity X", function() self:telemetryVelocityX() end, 515, 340)
    ImGui.AddItem("Telemetry", "Velocity Y", function() self:telemetryVelocityY() end, 515, 340)
    ImGui.AddItem("Telemetry", "Velocity Z", function() self:telemetryVelocityZ() end, 515, 340)
    ImGui.AddItem("Telemetry", "Vertical Velocity", function() self:telemetryVerticalVelocity() end, 515, 340)
    ImGui.AddItem("Telemetry", "TAS", function() self:telemetryVelocityTAS() end, 515, 340)
    ImGui.AddItem("Telemetry", "IAS", function() self:telemetryVelocityIAS() end, 515, 340)
    ImGui.AddItem("Telemetry", "Mach", function() self:telemetryVelocityMach() end, 515, 340)
    ImGui.AddItem("Telemetry", "Acceleration X", function() self:telemetryAccelerationX() end, 515, 340)
    ImGui.AddItem("Telemetry", "Acceleration Y", function() self:telemetryAccelerationY() end, 515, 340)
    ImGui.AddItem("Telemetry", "Acceleration Z", function() self:telemetryAccelerationZ() end, 515, 340)
    ImGui.AddItem("Telemetry", "Angular Velocity X", function() self:telemetryAngularVelocityX() end, 515, 340)
    ImGui.AddItem("Telemetry", "Angular Velocity Y", function() self:telemetryAngularVelocityY() end, 515, 340)
    ImGui.AddItem("Telemetry", "Angular Velocity Z", function() self:telemetryAngularVelocityZ() end, 515, 340)
    ImGui.AddItem("Telemetry", "Wind Velocity X", function() self:telemetryWindVelocityX() end, 515, 340)
    ImGui.AddItem("Telemetry", "Wind Velocity Y", function() self:telemetryWindVelocityY() end, 515, 340)
    ImGui.AddItem("Telemetry", "Wind Velocity Z", function() self:telemetryWindVelocityZ() end, 515, 340)
end

--- Shows ImGui menu bar and enables refreshing
function MyImGui:start()
    self.isRunning = true
    ImGui.MenuBar(true)
end

--- Hides ImGui menu bar and disables refreshing
function MyImGui:stop()
    self.isRunning = false
    self.eventHandlerInjected = false
    ImGui.MenuBar(false)
    ImGui:Refresh()
end

--- Refreshes ImGui
function MyImGui:update()
    if not self.isRunning then return end
    ImGui:Refresh()
end

--- Displays a table as a tree
--- @param t table @table to display
--- @param indent number @space indentation for non-table keys so it looks nice
--- @param maxDepth number @max depth for recursion
--- @param currentDepth number @current depth for recursion
--- @param visited table @visited tables (to avoid infinite recursion)
function MyImGui:treeTable(t, indent, maxDepth, currentDepth, visited)
    if not t then return end
    currentDepth = currentDepth or 1
    indent = indent or 3
    if maxDepth and currentDepth > maxDepth then return end
    visited = visited or {}
    if visited[t] then
        ImGui:Text(string.rep(" ", indent) .. "... (already displayed)")
        return
    end
    visited[t] = true
    local tableKeys = {}
    local otherKeys = {}
    for k, v in pairs(t) do
        if not (type(k) == "string" and k:sub(1, 2) == "__") then
            if type(v) == "table" then
                table.insert(tableKeys, k)
            else
                table.insert(otherKeys, k)
            end
        end
    end
    table.sort(tableKeys, function(a, b) return tostring(a) < tostring(b) end)
    table.sort(otherKeys, function(a, b) return tostring(a) < tostring(b) end)
    for _, k in ipairs(tableKeys) do
        local v = t[k]
        ImGui:Tree(tostring(k), function()
            self:treeTable(v, indent, maxDepth, currentDepth + 1, visited)
        end)
    end
    for _, k in ipairs(otherKeys) do
        local v = t[k]
        ImGui:Text(string.rep(" ", indent) .. tostring(k) .. " = " .. tostring(v))
    end
end

---------------------------------------------------------------------------
--- Aircraft
---------------------------------------------------------------------------

--- Displays self data
function MyImGui:selfData()
    self:treeTable(Export.LoGetSelfData())
end

--- Displays clickable elements
function MyImGui:clickableElements()
    self:treeTable(Export.GetClickableElements())
end

--- Displays aircraft data
function MyImGui:aircraftData()
    local selfData = Export.LoGetSelfData()
    if not selfData.Name then return end
    self:treeTable(me_db.unit_by_type[selfData.Name])
end

--- Displays engine info
function MyImGui:engineInfo()
    self:treeTable(Export.LoGetEngineInfo())
end

--- Displays MCP state
function MyImGui:mcpState()
    self:treeTable(Export.LoGetMCPState())
end

--- Displays mech info
function MyImGui:mechInfo()
    self:treeTable(Export.LoGetMechInfo())
end

--- Displays payload info
function MyImGui:payloadInfo()
    self:treeTable(Export.LoGetPayloadInfo())
end

---------------------------------------------------------------------------
--- Cockpit
---------------------------------------------------------------------------

--- Displays cockpit params
function MyImGui:cockpitParams()
    local cockpitParams = net.dostring_in("export", "return list_cockpit_params()")
    if not cockpitParams then return end
    local params = {}
    local keys = {}
    for line in cockpitParams:gmatch("[^\n]+") do
        local key, value = line:match("^(.*):(.*)$")
        if key and value then
            if tonumber(value) then
                params[key] = tonumber(value)
            else
                params[key] = value:match('^"(.*)"$') or value
            end
            table.insert(keys, key)
        end
    end
    table.sort(keys)
    local sortedParams = { { "Param", "Value" } }
    for i, k in ipairs(keys) do
        sortedParams[i] = { k, params[k] }
    end
    ImGui:Table(sortedParams)
end

--- Displays cockpit arguments (1-1000, with info from GetClickableElements)
function MyImGui:cockpitArguments()
    if Export.GetDevice(0) == nil then return end
    local clickableElements = Export.GetClickableElements()
    if not clickableElements then return end
    local rows = {}
    table.insert(rows, { "Element", "Arg", "Hint", "Value" })
    local clickableMapping = {}
    for element, data in pairs(clickableElements) do
        if data.arg and type(data.arg) == "table" then
            for _, arg in ipairs(data.arg) do
                clickableMapping[arg] = { element = element, hint = data.hint or "" }
            end
        end
    end
    for arg = 1, 1000 do
        local info = clickableMapping[arg] or { element = "", hint = "" }
        local value = Export.GetDevice(0):get_argument_value(arg)
        table.insert(rows, { info.element, arg, info.hint, value })
    end
    ImGui:Table(rows)
end

--- Detects cockpit arguments by change
--- @param maxDelta number @max delta for change detection (default 0.05)
--- @param duration number @duration for change display (default 5)
function MyImGui:argumentDetector(maxDelta, duration)
    if Export.GetDevice(0) == nil then return end
    local clickableElements = Export.GetClickableElements()
    if not clickableElements then return end
    maxDelta = maxDelta or 0.05
    duration = duration or 5
    local currentTime = os.clock()
    local rows = {}
    table.insert(rows, { "Element", "Arg", "Hint", "Value" })
    local clickableMapping = {}
    for element, data in pairs(clickableElements) do
        if data.arg and type(data.arg) == "table" then
            for _, arg in ipairs(data.arg) do
                clickableMapping[arg] = { element = element, hint = data.hint or "" }
            end
        end
    end
    for arg = 1, 1000 do
        local info = clickableMapping[arg] or { element = "", hint = "" }
        local value = Export.GetDevice(0):get_argument_value(arg)
        table.insert(rows, { info.element, arg, info.hint, value })
    end
    if not self.lastArguments then
        self.lastArguments = rows
        self.lastArgTime = currentTime
        self.argumentChanges = {}
        return
    end
    self.argumentChanges = self.argumentChanges or {}
    for i = 2, #rows do
        local currentRow = rows[i]
        local previousRow = self.lastArguments[i]
        local arg = currentRow[2]
        local currentValue = currentRow[4]
        local previousValue = previousRow and previousRow[4] or currentValue
        if math.abs(currentValue - previousValue) > maxDelta then
            self.argumentChanges[arg] = {
                element = currentRow[1],
                arg = arg,
                hint = currentRow[3],
                value = currentValue,
                previous = previousValue,
                timestamp = currentTime
            }
        end
    end
    for arg, event in pairs(self.argumentChanges) do
        if currentTime - event.timestamp > duration then
            self.argumentChanges[arg] = nil
        end
    end
    local changes = {}
    for _, event in pairs(self.argumentChanges) do
        table.insert(changes, event)
    end
    table.sort(changes, function(a, b) return a.arg < b.arg end)
    local outputRows = {}
    table.insert(outputRows, { "Element", "Arg", "Hint", "Value", "Previous" })
    for _, event in ipairs(changes) do
        table.insert(outputRows, { event.element, event.arg, event.hint, event.value, event.previous })
    end
    self.lastArguments = rows
    self.lastArgTime = currentTime
    ImGui:Text(string.format("Showing changes with min difference of %.2f", maxDelta))
    ImGui:Table(outputRows)
end

---------------------------------------------------------------------------
--- Mission
---------------------------------------------------------------------------

--- Displays a table of mission flags and their values
--- Flags are searched in trigrules and rules (e.g. anything defined in the ME)
function MyImGui:missionFlags()
    local code = [[
        local flags = {}
        for _, trigrule in ipairs(env.mission.trigrules) do
            if trigrule.actions then
                for _, action in pairs(trigrule.actions) do
                    if action.flag then
                        flags[action.flag] = true
                    end
                end
            end
            if trigrule.rules then
                for _, rule in ipairs(trigrule.rules) do
                    if rule.flag then
                        flags[rule.flag] = true
                    end
                end
            end
        end
        local output = "{"
        for flag, _ in pairs(flags) do
            output = output .. '"' .. flag ..'":' .. tostring(trigger.misc.getUserFlag(flag)) .. ","
        end
        if #output > 1 then
            output = string.sub(output, 1, -2)
        end
        output = output .. "}"
        return output
    ]]
    local flags = net.json2lua(net.dostring_in("server", code))
    local keys = {}
    for flag in pairs(flags) do
        table.insert(keys, flag)
    end
    table.sort(keys)
    local t = {}
    table.insert(t, { "Flag", "Value" })
    for _, flag in ipairs(keys) do
        table.insert(t, { flag, flags[flag] })
    end
    ImGui:Table(t)
end

function MyImGui:missionEvents()
    local code = [[
        local allEventsHandler = {
            onEvent = function(self, event)
                if self.eventNamesById == nil then
                    self.eventNamesById = {}
                    for key, value in pairs(world.event) do
                        self.eventNamesById[value] = key
                    end
                end
                local iniName
                if event.initiator == nil then
                    iniName = "nil"
                else
                    if event.initiator.getName then
                        iniName = event.initiator:getName()
                    else
                        iniName = "unknown"
                    end
                end
                local msg = string.format("Event: %s (%s)", self.eventNamesById[event.id], iniName)
                trigger.action.outText(msg, 5)
            end
        }
        world.addEventHandler(allEventsHandler)
    ]]
    if not self.eventHandlerInjected then
        net.dostring_in("mission", "a_do_script[[ " .. code .. " ]]")
        self.eventHandlerInjected = true
    end
    ImGui:Text("All events are now displayed in the game chat.\nYou can close this window.")
end

--- Displays the mission table
function MyImGui:missionTable()
    local mission = DCS.getCurrentMission()
    self:treeTable(mission.mission)
end

--- Displays a table of world objects
function MyImGui:worldObjects()
    local units = {}
    local units_by_level = { {}, {}, {}, {}, {}, {} }
    local humans = {}
    local ai = {}
    local header = {
        "ID",
        "Coalition",
        "Type",
        "UnitName",
        "GroupName",
        "Flags",
        "x",
        "z",
        "y",
        "Pitch",
        "Bank",
        "Heading",
        "Lat",
        "Long",
        "Alt",
    }
    local coa_by_id = {
        [0] = "Neutral",
        [1] = "Red",
        [2] = "Blue",
    }
    table.insert(units, header)
    table.insert(humans, header)
    table.insert(ai, header)
    table.insert(units_by_level[1], header)
    table.insert(units_by_level[2], header)
    table.insert(units_by_level[3], header)
    table.insert(units_by_level[4], header)
    table.insert(units_by_level[5], header)
    table.insert(units_by_level[6], header)
    for id, unit in pairs(Export.LoGetWorldObjects()) do
        local flags = ""
        if unit.Flags.AI_ON then flags = flags .. "A" else flags = flags .. " " end
        if unit.Flags.Human then flags = flags .. "H" else flags = flags .. " "  end
        if unit.Flags.IRJamming then flags = flags .. "I" else flags = flags .. " "  end
        if unit.Flags.Jamming then flags = flags .. "J" else flags = flags .. " "  end
        if unit.Flags.RadarActive then flags = flags .. "R" else flags = flags .. " "  end
        local row = {
            id,
            coa_by_id[unit.CoalitionID],
            unit.Name,
            unit.UnitName,
            unit.GroupName,
            flags,
            string.format("%8.0f", unit.PositionAsMatrix.p.x),
            string.format("%8.0f", unit.PositionAsMatrix.p.z),
            string.format("%8.0f", unit.PositionAsMatrix.p.y),
            string.format("%3.0f", math.deg(unit.Pitch)),
            string.format("%3.0f", math.deg(unit.Bank)),
            string.format("%3.0f", math.deg(unit.Heading) % 360),
            string.format("%3.5f", unit.LatLongAlt.Lat),
            string.format("%3.5f", unit.LatLongAlt.Long),
            string.format("%6.0f", unit.LatLongAlt.Alt),
        }
        table.insert(units, row)
        local lv1 = unit.Type.level1
        table.insert(units_by_level[lv1], row)
        if unit.Flags.Human then
            table.insert(humans, row)
        else
            table.insert(ai, row)
        end
    end
    local function sortTable(t)
        if #t > 1 then
            local header = t[1]
            table.remove(t, 1)
            table.sort(t, function(a, b)
                if a[2] ~= b[2] then
                    return a[2] < b[2]
                elseif a[3] ~= b[3] then
                    return a[3] < b[3]
                elseif a[4] ~= b[4] then
                    return a[4] < b[4]
                end
                return false
            end)
            table.insert(t, 1, header)
        end
    end
    sortTable(units)
    sortTable(humans)
    sortTable(ai)
    for i = 1, 6 do
        sortTable(units_by_level[i])
    end
    ImGui:TabBar("Objects", function()
        ImGui:TabItem("All Objects", function() ImGui:Table(units) end)
        ImGui:TabItem("Humans", function() ImGui:Table(humans) end)
        ImGui:TabItem("AI", function() ImGui:Table(ai) end)
        ImGui:TabItem("Air", function() ImGui:Table(units_by_level[1]) end)
        ImGui:TabItem("Ground", function() ImGui:Table(units_by_level[2]) end)
        ImGui:TabItem("Navy", function() ImGui:Table(units_by_level[3]) end)
        ImGui:TabItem("Weapons", function() ImGui:Table(units_by_level[4]) end)
        ImGui:TabItem("Statics", function() ImGui:Table(units_by_level[5]) end)
        ImGui:TabItem("Destroyed", function() ImGui:Table(units_by_level[6]) end)
    end)
end

---------------------------------------------------------------------------
--- Telemetry
---------------------------------------------------------------------------

function MyImGui:telemetryAoA()
    self:telemetry("AoA", 500, -10, 20, function()
        return Export.LoGetAngleOfAttack()
    end)
end

function MyImGui:telemetryPitch()
    self:telemetry("Pitch", 500, -90, 90, function()
        local pitch, _, _ = Export.LoGetADIPitchBankYaw()
        return math.deg(pitch)
    end)
end

function MyImGui:telemetryBank()
    self:telemetry("Bank", 500, -180, 180, function()
        local _, bank, _ = Export.LoGetADIPitchBankYaw()
        return math.deg(bank)
    end)
end

function MyImGui:telemetryYaw()
    self:telemetry("Heading", 500, 0, 360, function()
        local _, _, yaw = Export.LoGetADIPitchBankYaw()
        return math.deg(yaw)
    end)
end

function MyImGui:telemetrySideSlipAngle()
    self:telemetry("Side Slip Angle", 500, -20, 20, function()
        return Export.LoGetAngleOfSideSlip()
    end)
end

function MyImGui:telemetryVelocityX()
    self:telemetry("Velocity X", 500, -1000, 1000, function()
        return Export.LoGetVectorVelocity().x
    end)
end

function MyImGui:telemetryVelocityY()
    self:telemetry("Velocity Y", 500, -1000, 1000, function()
        return Export.LoGetVectorVelocity().y
    end)
end

function MyImGui:telemetryVelocityZ()
    self:telemetry("Velocity Z", 500, -1000, 1000, function()
        return Export.LoGetVectorVelocity().z
    end)
end

function MyImGui:telemetryVerticalVelocity()
    self:telemetry("Vertical Velocity", 500, -1000, 1000, function()
        return Export.LoGetVerticalVelocity()
    end)
end

function MyImGui:telemetryVelocityTAS()
    self:telemetry("Velocity TAS", 500, 0, 1000, function()
        return Export.LoGetTrueAirSpeed()
    end)
end

function MyImGui:telemetryVelocityIAS()
    self:telemetry("Velocity IAS", 500, 0, 1000, function()
        return Export.LoGetIndicatedAirSpeed()
    end)
end

function MyImGui:telemetryVelocityMach()
    self:telemetry("Velocity Mach", 500, 0, 3, function()
        return Export.LoGetMachNumber()
    end)
end

function MyImGui:telemetryAccelerationX()
    self:telemetry("Acceleration X", 500, -100, 100, function()
        return Export.LoGetAccelerationUnits().x
    end)
end

function MyImGui:telemetryAccelerationY()
    self:telemetry("Acceleration Y", 500, -100, 100, function()
        return Export.LoGetAccelerationUnits().y
    end)
end

function MyImGui:telemetryAccelerationZ()
    self:telemetry("Acceleration Z", 500, -100, 100, function()
        return Export.LoGetAccelerationUnits().z
    end)
end

function MyImGui:telemetryAngularVelocityX()
    self:telemetry("Angular Velocity X", 500, -100, 100, function()
        return Export.LoGetAngularVelocity().x
    end)
end

function MyImGui:telemetryAngularVelocityY()
    self:telemetry("Angular Velocity Y", 500, -100, 100, function()
        return Export.LoGetAngularVelocity().y
    end)
end

function MyImGui:telemetryAngularVelocityZ()
    self:telemetry("Angular Velocity Z", 500, -100, 100, function()
        return Export.LoGetAngularVelocity().z
    end)
end

function MyImGui:telemetryWindVelocityX()
    self:telemetry("Wind Velocity X", 500, -50, 50, function()
        return Export.LoGetVectorWindVelocity().x
    end)
end

function MyImGui:telemetryWindVelocityY()
    self:telemetry("Wind Velocity Y", 500, -50, 50, function()
        return Export.LoGetVectorWindVelocity().y
    end)
end

function MyImGui:telemetryWindVelocityZ()
    self:telemetry("Wind Velocity Z", 500, -50, 50, function()
        return Export.LoGetVectorWindVelocity().z
    end)
end

--- Telemetry helper for circular buffer
--- @param name string @name of the telemetry (menu item)
--- @param width number @width of the plot
--- @param min number @min value of the plot (for initial zooming)
--- @param max number @max value of the plot (for initial zooming)
--- @param getter function @function to get the next data point
function MyImGui:telemetry(name, width, min, max, getter)
    if not self.buffers[name] then
        self.buffers[name] = {}
        for i = 1, width do
            self.buffers[name][i] = 0
        end
    end
    table.remove(self.buffers[name], 1)
    local value = getter()
    table.insert(self.buffers[name], value)
    ImGui:Plot(name, "frame", name, width, function()
        ImGui:PlotHLines("", { min, max }) -- using these for initial vertical zoom
        ImGui:PlotLine(name, 1.0, self.buffers[name])
    end)
end

---------------------------------------------------------------------------

-- setup user callbacks: show ImGui on simulation start, hide on stop, update every frame
DCS.setUserCallbacks({
    onMissionLoadEnd = function() MyImGui:start() end,
    onSimulationStop = function() MyImGui:stop() end,
    onSimulationFrame = function() MyImGui:update() end,
})

-- setup menu and hide it initially
MyImGui:setup()
MyImGui:stop()
ImGui.Log("LuaImGui Example Hook Loaded")
