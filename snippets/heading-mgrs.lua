local cooldowns = {}

local function deg2dir(deg)
    local directions = { "N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW" }
    local index = math.floor((deg + 11.25) / 22.5) % 16 + 1
    return directions[index]
end

local function showMGRSAndHeading(unitName)
    if cooldowns[unitName] and timer.getTime() < cooldowns[unitName] then return end
    cooldowns[unitName] = timer.getTime() + 30
    local unit = Unit.getByName(unitName)
    local pos = unit:getPosition()
    local mgrs = coord.LLtoMGRS(coord.LOtoLL(pos.p.x, pos.p.z))
    local heading = math.deg(math.atan2(pos.x.z, pos.x.x))
    local msg = string.format("MGRS: %s %s %d %d\nDirection: %s", mgrs.MGRSDigraph, mgrs.UTMZone, mgrs.Easting, mgrs.Northing, deg2dir(heading))
    trigger.action.outText(msg, 10)
end

world.addEventHandler({
    onEvent = function(self, event)
        if event.id == world.event.S_EVENT_BIRTH then
            local groupId = event.initiator:getGroup():getID()
            local unitName = event.initiator:getName()
            missionCommands.addCommandForGroup(groupId, "MGRS and Heading", nil, showMGRSAndHeading, unitName)
        end
    end
})
