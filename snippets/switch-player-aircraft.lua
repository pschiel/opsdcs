local function switchAircraft()
    local id = Unit.getByName("p2"):getID()
    net.dostring_in("gui", "DCS.setPlayerUnit(" .. id .. ")")
end

missionCommands.addCommand("switch aircraft",  nil, switchAircraft)
