-- @see https://github.com/08jne01/dcs-lua-imgui

-- @todo refactor :]

--if true then return end

_G.lua_imgui_path = lfs.writedir() .. "Scripts/LuaImGui/"
_G.imgui_disabled = false
dofile(lua_imgui_path .. "ImGui.lua")

---------------------------------------------------------------

local ImGuiRunning = false

function recursiveImGuiTree(t, depth, seen)
    if t == nil then
        return "nil"
    end

    seen = seen or {}

    if seen[t] ~= nil then
        return tostring(t)
    end

    seen[t] = true

    depth = depth or 0

    if depth > 100 then
        return "..."
    end

    local strings = {}
    for i, v in pairs(t) do
        if type(v) == "table" then
            ImGui:Tree(i, function()
                recursiveImGuiTree(v, depth + 1, seen)
            end)
        elseif type(v) == "string" then
            table.insert(strings, i .. string.format(" = \"%s\"", v))
        else
            table.insert(strings, tostring(i) .. " = " .. tostring(v))
        end
    end
    ImGui:Text(table.concat(strings, ",\n"))
end

function ImGuiSetup()
    ImGui.AddItem("World", "Objects", function()
        ImGui:Text("Objects")
        local units = {}
        table.insert(units, {
            "ID",
            "Coalition",
            "Name",
            "UnitName",
            "x",
            "z",
            "Alt",
            "Task",
        })
        for id, unit in pairs(Export.LoGetWorldObjects()) do
            local obj = Export.LoGetObjectById(id)
            table.insert(units, {
                id,
                unit.CoalitionID,
                unit.Name,
                unit.UnitName,
                unit.PositionAsMatrix.p.x,
                unit.PositionAsMatrix.p.z,
                unit.PositionAsMatrix.p.y,
                obj.getController and tostring(obj:getController():hasTask())
            })
        end
        ImGui:Table(units)
    end)
    local points = 500
    local time_data = {}
    local aoa_data = {}
    local vel_data_x = {}
    local vel_data_y = {}
    local vel_data_z = {}
    local heading_data = {}
    local dheading_data = {}
    local tas_data = {}
    local ias_data = {}
    local now = Export.LoGetModelTime()
    local ntime = 50
    for i = 1, ntime do
        time_data[i] = now
    end
    for i = 1, points do
        aoa_data[i] = 0
        vel_data_x[i] = 0
        vel_data_y[i] = 0
        vel_data_z[i] = 0
        heading_data[i] = 361
        dheading_data[i] = 0
        tas_data[i] = 0
        ias_data[i] = 0
    end
    local h_lines_aoa = { 15.0, -15.0 }
    local h_lines_vel = { 0.0, 2.0 }
    local h_lines_dheading = { 0.0, 40.0 }
    local h_lines_vvel = { 0.0, 600.0 }
    ImGui.AddItem("Telemetry", "Stuff", function()
        local dx = 1.0
        local now = Export.LoGetModelTime()
        table.remove(time_data, 1)
        table.insert(time_data, now)
        local aoa = Export.LoGetAngleOfAttack()
        table.remove(aoa_data, 1)
        table.insert(aoa_data, aoa)
        ImGui:Tree("AoA", function()
            ImGui:Plot("AoA", "frame", "AoA", points, function()
                ImGui:PlotHLines("max", h_lines_aoa)
                ImGui:PlotLine("AoA", dx, aoa_data)
            end)
        end)
        local vel = Export.LoGetAngularVelocity()
        table.remove(vel_data_x, 1)
        table.remove(vel_data_y, 1)
        table.remove(vel_data_z, 1)
        table.insert(vel_data_x, vel.x)
        table.insert(vel_data_y, vel.y)
        table.insert(vel_data_z, vel.z)
        ImGui:Tree("Angular Velocity", function()
            ImGui:Plot("Angular Velocity", "frame", "Angular Velocity", points, function()
                ImGui:PlotHLines("max", h_lines_vel)
                ImGui:PlotLine("X", dx, vel_data_x)
                ImGui:PlotLine("Y", dx, vel_data_y)
                ImGui:PlotLine("Z", dx, vel_data_z)
            end)
        end)
        local data = Export.LoGetSelfData()
        local heading = data.Heading * 180 / math.pi
        if heading < 0 then
            heading = heading + 360
        end
        table.remove(heading_data, 1)
        table.insert(heading_data, heading)
        local dt = now - time_data[1]
        local dheadingt = 0
        if heading_data[points - ntime] ~= 361 then
            local dheading = heading - heading_data[points - ntime]
            if dheading > 180 then
                dheading = dheading - 360
            elseif dheading < -180 then
                dheading = dheading + 360
            end
            dheadingt = math.abs(dheading) / dt
        end
        table.remove(dheading_data, 1)
        table.insert(dheading_data, dheadingt)
        ImGui:Tree("Turn Rate deg/s", function()
            ImGui:Plot("Turn Rate deg/s", "frame", "Turn Rate deg/s", points, function()
                ImGui:PlotHLines("max", h_lines_dheading)
                ImGui:PlotLine("Turn Rate deg/s", dx, dheading_data)
            end)
        end)
        local tas = Export.LoGetTrueAirSpeed() * 1.94384
        table.remove(tas_data, 1)
        table.insert(tas_data, tas)
        ImGui:Tree("TAS", function()
            ImGui:Plot("TAS", "frame", "TAS", points, function()
                ImGui:PlotHLines("max", h_lines_vvel)
                ImGui:PlotLine("knots", dx, tas_data)
            end)
        end)
        local ias = Export.LoGetIndicatedAirSpeed() * 1.94384
        table.remove(ias_data, 1)
        table.insert(ias_data, ias)
        ImGui:Tree("IAS", function()
            ImGui:Plot("IAS", "frame", "TAS", points, function()
                ImGui:PlotHLines("max", h_lines_vvel)
                ImGui:PlotLine("knots", dx, ias_data)
            end)
        end)
    end)
    bla = false
    ImGui.AddItem("Mission", "Flags", function()
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
        local t = {}
        table.insert(t, { "Flag", "Value" })
        for flag, value in pairs(flags) do
            table.insert(t, { flag, value })
        end
        ImGui:Table(t)
    end)
end

local f = 0
function ImGuiUpdate()
    if not ImGuiRunning then return end
    f = f + 1
    --if f % 5 == 0 then
    ImGui:Refresh()
    --end

end

function ImGuiShow()
    ImGuiRunning = true
    ImGui.MenuBar(true)
end

function ImGuiHide()
    ImGuiRunning = false
    ImGui.MenuBar(false)
    ImGui:Refresh()
end

DCS.setUserCallbacks({
    onSimulationStart = ImGuiShow,
    onSimulationStop = ImGuiHide,
    onSimulationFrame = ImGuiUpdate
})

ImGuiSetup()
