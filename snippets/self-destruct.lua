-- put in mission start trigger

local function selfdestruct(unit)
    trigger.action.explosion(unit:getPoint(), 100)
end

local function nearbyexplode(unit, power)
    local point = unit:getPoint()
    local dist = 10
    point.x = point.x - dist -- few m north
    power = power and power or 1
    trigger.action.explosion(point, power)
    trigger.action.outText("explosion " .. dist .. "m north, power " .. power, 5)
end

local function setinvincible(unit, onoff)
    local command = {
        id = "SetImmortal",
        params = { value = onoff }
    }
    unit:getGroup():getController():setCommand(command)
    trigger.action.outText("set immortal to " .. tostring(onoff), 5)
end

local eventHandler = {
    onEvent = function(self, event)
        if event.id == world.event.S_EVENT_BIRTH then
            local groupId = event.initiator:getGroup():getID()
            missionCommands.addCommandForGroup(groupId, "Immortal ON", nil, setinvincible, event.initiator, true)
            missionCommands.addCommandForGroup(groupId, "Immortal OFF", nil, setinvincible, event.initiator, false)
            missionCommands.addCommandForGroup(groupId, "Self-destruct", nil, selfdestruct, event.initiator)
            missionCommands.addCommandForGroup(groupId, "Nearby explosion 1", nil, nearbyexplode, event.initiator, 1)
            missionCommands.addCommandForGroup(groupId, "Nearby explosion 2", nil, nearbyexplode, event.initiator, 2)
            missionCommands.addCommandForGroup(groupId, "Nearby explosion 5", nil, nearbyexplode, event.initiator, 5)
            missionCommands.addCommandForGroup(groupId, "Nearby explosion 10", nil, nearbyexplode, event.initiator, 10)
            missionCommands.addCommandForGroup(groupId, "Nearby explosion 20", nil, nearbyexplode, event.initiator, 20)
        end
    end
}
world.addEventHandler(eventHandler)
