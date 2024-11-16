-- @see https://github.com/08jne01/dcs-lua-imgui

_G.lua_imgui_path = lfs.writedir() .. "Scripts/LuaImGui/?.dll"
_G.imgui_disabled = false
dofile(lfs.writedir() .. "Scripts/LuaImGui/ImGui.lua")

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
        if type(v) == 'table' then
            ImGui:Tree(i, function ()
                recursiveImGuiTree(v, depth + 1, seen)             
            end)
        elseif type(v) == 'string' then
            table.insert(strings, i..string.format(" = \"%s\"", v))
        else
            table.insert(strings, i.." = "..tostring(v))
        end
    end
    ImGui:Text(table.concat(strings, ',\n'))
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
            "y",
            "z",
        })
        for id, unit in pairs(Export.LoGetWorldObjects()) do
            table.insert(units, {
                id,
                unit.Coalition,
                unit.Name,
                unit.UnitName,
                unit.PositionAsMatrix.p.x,
                unit.PositionAsMatrix.p.y,
                unit.PositionAsMatrix.p.z,
            })
        end
        ImGui:Table(units)
    end)
    ImgGui.AddItem("DB", "Units", function()
        recursiveImGuiTree(db.Units)
    end)
end

function ImGuiUpdate()
    if not ImGuiRunning then return end
    ImGui:Refresh()
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
