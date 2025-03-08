-- weapon tracking script
--
-- usage:
--  put script in mission start trigger
--  add zones to check in zones table
--  when weapon is in zone, flags get set e.g. "weapon_in_zone1"

-- holds all weapons that are currently being tracked (by id)
local weapons = {}

-- zones to check
local zones = { "zone1", "zone2" }

-- time step in seconds for update loop
local dt = 0.1

-- for debugging
local dbg = true

-- event handler that listens for weapon shots
local eventsHandler = {
    onEvent = function(self, event)
        if event.id == world.event.S_EVENT_SHOT then
            local weapon = event.weapon
            if dbg then trigger.action.outText("start tracking weapon " .. weapon.id_, 5) end
            weapons[weapon.id_] = weapon
        end
    end
}
world.addEventHandler(eventsHandler)

-- distance check (3d distance, not like zone trigger)
local function checkDistance(pos1, pos2, radius)
    local dx, dy, dz = pos1.x - pos2.x, pos1.y - pos2.y, pos1.z - pos2.z
    return dx * dx + dy * dy + dz * dz < radius * radius
end

-- update loop
local function loop()
    -- check all weapons currently being tracked
    for id, weapon in pairs(weapons) do
        if weapon:isExist() then
            -- check all zones
            for _, zoneName in ipairs(zones) do
                local zone = trigger.misc.getZone(zoneName)
                if zone and checkDistance(weapon:getPoint(), zone.point, zone.radius) then
                    trigger.action.setUserFlag("weapon_in_" .. zoneName, 1)
                end
            end
        else
            -- weapon gone, stop tracking
            if dbg then trigger.action.outText("stop tracking weapon " ..id, 5) end
            weapons[id] = nil
        end
    end
    timer.scheduleFunction(loop, nil, timer.getTime() + dt)
end

timer.scheduleFunction(loop, nil, timer.getTime() + dt)
