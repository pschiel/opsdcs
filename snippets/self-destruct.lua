-- put in mission start trigger

local function selfdestruct(unit)
    trigger.action.explosion(unit:getPoint(), 100)
end

local eventHandler = {
    onEvent = function(self, event)
        if event.id == world.event.S_EVENT_BIRTH then
            local groupId = event.initiator:getGroup():getID()
            missionCommands.addCommandForGroup(groupId, "Self-destruct", nil, selfdestruct, event.initiator)
        end
    end
}
world.addEventHandler(eventHandler)

missionCommands.addCommand(