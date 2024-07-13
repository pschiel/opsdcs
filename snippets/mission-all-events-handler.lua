-- generic debug output for all events
allEventsHandler = {
    onEvent = function(self, event)
        if self.eventNamesById == nil then
            self.eventNamesById = {}
            for key, value in pairs(world.event) do
                self.eventNamesById[value] = key
            end
        end
        local ini = event.initiator and event.initiator:getName() or "-"
        trigger.action.outText("event: " .. self.eventNamesById[event.id] .. " ini: " .. ini, 5)
    end
}
world.addEventHandler(allEventsHandler)
