local weapons = {}

local eventsHandler = {
    onEvent = function(self, event)
        if event.id == world.event.S_EVENT_SHOT then
            local weapon = event.weapon
            trigger.action.outText("start tracking weapon " .. weapon.id_, 5)
            weapons[weapon.id_] = weapon
        end
    end
}
world.addEventHandler(eventsHandler)

local function getDistance(pos1, pos2)
    local dx, dy, dz = pos1.x - pos2.x, pos1.y - pos2.y, pos1.z - pos2.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function trackWeapons()
    for id, weapon in pairs(weapons) do
        if weapon:isExist() then
            local zone = trigger.misc.getZone("zone1")
            local distance = getDistance(weapon:getPoint(), zone.point)
            trigger.action.outText("distance to zone1: " .. distance, 5)
            if distance < zone.radius then
                trigger.action.outText("weapon " .. id .. " is in zone1", 5)
                trigger.action.setUserFlag("weapon_in_zone1", 1)
            end
        else
            trigger.action.outText("stop tracking weapon " ..id, 5)
            weapons[id] = nil
        end
    end
    timer.scheduleFunction(trackWeapons, nil, timer.getTime() + 0.1)
end

timer.scheduleFunction(trackWeapons, nil, timer.getTime() + 0.1)
