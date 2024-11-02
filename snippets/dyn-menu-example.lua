local function example(groupId)
    trigger.action.outTextForGroup(groupId, "blabla command, sent to group id: " .. groupId, 5)
end

local eventHandler = {
    onEvent = function(self, event)
        if event.id == world.event.S_EVENT_BIRTH then
            local groupId = event.initiator:getGroup():getID()
            missionCommands.addCommandForGroup(groupId, "blabla command", nil, example, groupId)
        end
    end
}
world.addEventHandler(eventHandler)
