-- @see https://github.com/08jne01/dcs-lua-imgui

_G.lua_imgui_path = lfs.writedir() .. "Scripts/LuaImGui/?.dll"
_G.imgui_disabled = false
dofile(lfs.writedir() .. "Scripts/LuaImGui/ImGui.lua")

---------------------------------------------------------------

local ImGuiRunning = false

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
end

function ImGuiUpdate()
    if not ImGuiRunning then return end
    ImGui:Refresh()
end

function ImGuiShow()
    ImGuiRunning = true
    ImGui:MenuBar(true)
end

function ImGuiHide()
    ImGuiRunning = false
    ImGui:MenuBar(false)
    ImGui:Refresh()
end

DCS.setUserCallbacks({
    onSimulationStart = ImGuiShow,
    onSimulationStop = ImGuiHide,
    onSimulationFrame = ImGuiUpdate
})

ImGuiSetup()
