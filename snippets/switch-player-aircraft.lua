local function switchAircraft()
    Group.getByName("g2"):activate()
    net.dostring_in("gui", "DCS.setPlayerUnit(" .. Unit.getByName("p2") .. ")")
end

missionCommands.addCommand("switch aircraft",  nil, switchAircraft)
