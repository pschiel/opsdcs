local function switchAircraft()
    Group.getByName("g2"):activate()
    net.dostring_in("gui", "DCS.setPlayerUnit(" .. Unit.getByName("p2"):getID() .. ")")
end

missionCommands.addCommand("switch aircraft",  nil, switchAircraft)

net.dostring_in("gui", [[
    local hook = {
        onSimulationPause = function()
            DCS.setPause(false)
            hook.onSimulationPause = nil
        end
    }
    DCS.setUserCallbacks(hook)
]])
