-- generic debug output for all events
allEventsHandler = {
    onEvent = function(self, event)
        if self.eventNamesById == nil then
            self.eventNamesById = {}
            for key, value in pairs(world.event) do
                self.eventNamesById[value] = key
            end
        end
        local iniName
        if event.initiator == nil then
            iniName = "nil"
        else
            if event.initiator.getName then
                iniName = event.initiator:getName()
            else
                iniName = "unknown"
            end
        end
        trigger.action.outText("event: " .. self.eventNamesById[event.id] .. " ini: " .. iniName, 5)
    end
}
world.addEventHandler(allEventsHandler)
