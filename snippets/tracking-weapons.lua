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

local function trackWeapons()
    for id, weapon in pairs(weapons) do
        if weapon:isExist() then
            local pos = weapon:getPoint()
            trigger.action.outText("tracking weapon " .. id .. " at " .. pos.x .. ", " .. pos.y .. ", " .. pos.z, 5)
        else
            trigger.action.outText("stop tracking weapon " ..id, 5)
            weapons[id] = nil
        end
    end
    timer.scheduleFunction(trackWeapons, nil, timer.getTime() + 0.1)
end

timer.scheduleFunction(trackWeapons, nil, timer.getTime() + 0.1)
