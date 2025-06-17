-- options
MyThing = {
    delta_time = 2.0,
    is_running = false,
    debug = true,
    reload_path = [[E:\Work\dcs\opsdcs\snippets\script-template.lua]],
}

-- debug output
function MyThing:debug(message)
    if self.debug then
        trigger.action.outText("[MyThing] " .. message, 1)
    end
end

-- main update loop
function MyThing:update()
    if not self.is_running then return end
    self:debug("test...")
    -- ...
    timer.scheduleFunction(self.update, self, timer.getTime() + self.delta_time)
end

-- start script
function MyThing:start()
    self.is_running = true
    self:debug("started")
    self:update()
end

-- stop script
function MyThing:stop()
    self.is_running = false
    self:debug("stopped")
end

-- reload script (for development)
function MyThing:reload()
    self:stop()
    dofile(self.reload_path)
end

MyThing:start()
