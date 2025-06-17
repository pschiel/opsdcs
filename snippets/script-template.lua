-- object oriented script example, with update loop and reload

-- options
MyThing = {
    delta_time = 2.0, -- dt for update loop
    is_running = false, -- is true while running
    debug = true, -- show debug output
    reload_path = [[E:\Work\dcs\opsdcs\snippets\script-template.lua]], -- script path for development reload
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

-- reload script for development, send "MyThing:reload()" to LUA runner
function MyThing:reload()
    self:stop()
    dofile(self.reload_path)
end

MyThing:start()
