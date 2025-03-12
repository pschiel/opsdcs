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
            local desc = weapon:getDesc()
            if dbg then trigger.action.outText("track " .. weapon.id_ .. " " .. desc.typeName , 5) end
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

-- get zone properties
local function getZone(name)
    for _, zone in pairs(env.mission.triggers.zones) do
        if zone.name == name then
            zone.props = {}
            for _, prop in pairs(zone.properties) do
                zone.props[prop.key] = prop.value
            end
            return zone
        end
    end
    return nil
end

-- update loop
local function loop()
    -- check all weapons currently being tracked
    for id, weapon in pairs(weapons) do
        if weapon:isExist() then
            -- check all zones
            for _, zoneName in ipairs(zones) do
                local zone = getZone(zoneName)
                local inZone = false
                if zone.type == 2 then
                    inZone = mist.pointInPolygon(weapon:getPoint(), zone.verticies, tonumber(zone.props.height))
                else
                    inZone = checkDistance(weapon:getPoint(), { x = zone.x, y = 0, z = zone.y }, zone.radius)
                end
                if inZone then
                    local desc = weapon:getDesc()
                    local weaponMatch = false
                    for key, value in pairs(zone.props) do
                        if key:sub(1, 5) == "check" and desc.typeName:sub(1, #value) == value then
                            weaponMatch = true
                            break
                        end
                    end
                    if weaponMatch then
                        trigger.action.outText(desc.typeName .. " in zone " .. zoneName, 5)
                        local launcher = weapon:getLauncher()
                        if launcher then
                            trigger.action.outText(desc.typeName .. " launched by " .. launcher:getName(), 5)
                            trigger.action.setUserFlag("weapon_in_" .. zoneName, 1)
                            weapons[id] = nil
                        end
                    end
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
