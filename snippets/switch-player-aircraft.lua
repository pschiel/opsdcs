--- Switches SP player to a unit (can be in late activation)
--- @param unitName string @unit name
--- @param unpause boolean @if set to true, automatic unpause on briefing screen
local function switchAircraft(unitName, unpause)
    net.dostring_in("gui", "DCS.setPlayerUnit(" .. Unit.getByName(unitName):getID() .. ")")
    if unpause then
        net.dostring_in("gui", [[
            local once = false
            local hook = {
                onSimulationPause = function()
                    if once then return end
                    DCS.setPause(false)
                    once = true
                end
            }
            DCS.setUserCallbacks(hook)
        ]])
    end
end

missionCommands.addCommand("switch to unit p1",  nil, switchAircraft, "p1", true)
missionCommands.addCommand("switch to unit p2",  nil, switchAircraft, "p2", true)
missionCommands.addCommand("switch to unit p3",  nil, switchAircraft, "p3", false) -- with pause
missionCommands.addCommand("switch to unit p4",  nil, switchAircraft, "p4", true)
