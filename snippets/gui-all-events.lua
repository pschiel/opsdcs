gui_all_events = {
    onEvent = function(self, event)
        if self.eventNamesById == nil then
            self.eventNamesById = {}
            for key, value in pairs(world.event) do
                self.eventNamesById[value] = key
            end
        end
        net.dostring_in("mission", 'a_out_text_delay("event: ' .. self.eventNamesById[event.id] .. '", 5)')
    end,
    isRunning = false,
    toggle = function(self)
        if self.isRunning then
            world.removeEventHandler(self)
        else
            world.addEventHandler(self)
        end
        self.isRunning = not self.isRunning
    end
}
gui_all_events:toggle()
