--- opsdcs-cargo (mission script)

OpsdcsCargo = {
    options = {
        timeDelta = 1.0, -- seconds between updates
        debug = true, -- debug setting
    },
    basedir = OpsdcsCargoBasedir or "",
    isRunning = false,
}

--- starts script
function OpsdcsCargo:start()
    self:log("opsdcs-cargo start")
    self:update()
end

--- stops script
function OpsdcsCargo:stop()
    self:log("opsdcs-cargo stop")
    self.isRunning = false
end

--- ingame debug log helper
--- @param string msg
function OpsdcsCargo:log(msg)
    if self.options.debug then
        trigger.action.outText(msg, 5)
    end
end

--- update loop
function OpsdcsCargo:update()
    if not self.isRunning then return end
    local timeDelta = self.options.timeDelta

    -- @todo

    timer.scheduleFunction(self.update, self, timer.getTime() + timeDelta)
end

OpsdcsCargo:start()
