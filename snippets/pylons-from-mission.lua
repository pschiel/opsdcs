--- Returns pylon CLSIDs from mission file
--- @param unitName string @unit name (not player name)
--- @return table @table with CLSIDs
function getPylonsFromMission(unitName)
    for _, coalition in pairs(env.mission.coalition) do
        if coalition.country then
            for _, country in ipairs(coalition.country) do
                if country.plane and country.plane.group then
                    for _, group in ipairs(country.plane.group) do
                        for _, unit in ipairs(group.units) do
                            if unit.name == unitName then
                                local clsids = {}
                                if unit.payload and unit.payload.pylons then
                                    for _, pylon in pairs(unit.payload.pylons) do
                                        for _, clsid in pairs(pylon) do
                                            clsids[clsid] = true
                                        end
                                    end
                                end
                                return clsids
                            end
                        end
                    end
                end
            end
        end
    end
end
