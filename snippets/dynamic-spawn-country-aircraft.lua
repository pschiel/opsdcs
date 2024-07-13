-- gets available coalitions for all units found in country db
coalitionsByUnit = {}
for id, country in pairs(country.by_idx) do
    local coalitionId = coalition.getCountryCoalition(id)
    for _, heli in ipairs(country.Units.Helicopters.Helicopter) do
        coalitionsByUnit[heli.Name] = coalitionsByUnit[heli.Name] or {}
        coalitionsByUnit[heli.Name][tostring(coalitionId)] = true
    end
    for _, plane in ipairs(country.Units.Planes.Plane) do
        coalitionsByUnit[plane.Name] = coalitionsByUnit[plane.Name] or {}
        coalitionsByUnit[plane.Name][tostring(coalitionId)] = true
    end
end

-- sets stock to 0 for all units not allowed at the airbase, restocks to 100 for allowed units
function restockAllWarehouses()
    for _, airbase in ipairs(world.getAirbases()) do
        if airbase:getCoalition() > 0 then
            for unit, allowedCoalitions in pairs(coalitionsByUnit) do
                if allowedCoalitions[tostring(airbase:getCoalition())] then
                    airbase:getWarehouse():setItem(unit, 100) -- change to whatever
                else
                    airbase:getWarehouse():setItem(unit, 0)
                end
            end
        end
    end
end

-- sets stock to 0 for all airbases belonging to a coalition
function clearWarehousesForCoalition(coalitionId)
    for _, airbase in ipairs(world.getAirbases()) do
        if airbase:getCoalition() == coalitionId then
            for unit, _ in pairs(airbase:getWarehouse():getInventory().aircraft) do
                airbase:getWarehouse():setItem(unit, 0)
            end
        end
    end
end

-- in mission start trigger, and on base capture event
restockAllWarehouses()

-- removes all aircraft for red airbases
-- clearWarehousesForCoalition(coalition.side.RED)
