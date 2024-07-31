-- Flag debugger

Flagdebug = {
    timeDelta = 1.0, -- loop interval
}

--- creates menu item to toggle flag debugger
function Flagdebug:start()
    self.isRunning = false
    self.menuPath = missionCommands.addCommand("Toggle Flag Debugger", nil, self.toggle, self)
end

--- removes menu item, stops loop
function Flagdebug:stop()
    self.isRunning = false
    missionCommands.removeItem(self.menuPath)
end

--- toggles the flag debugger on/off
function Flagdebug:toggle()
    self.isRunning = not self.isRunning
    if self.isRunning then self:loop() end
end

--- loop
function Flagdebug:loop()
    if not self.isRunning then return end
    trigger.action.outText(self:output(), 1, true)
    timer.scheduleFunction(self.loop, self, timer.getTime() + self.timeDelta)
end

--- generates flag debug output
function Flagdebug:output()
    local flags = {}
    for _, trigrule in ipairs(env.mission.trigrules) do
        if trigrule.actions then
            for _, action in pairs(trigrule.actions) do
                if action.flag then
                    flags[action.flag] = true
                end
            end
        end
        if trigrule.rules then
            for _, rule in ipairs(trigrule.rules) do
                if rule.flag then
                    flags[rule.flag] = true
                end
            end
        end
    end
    local output = "Flags:"
    for flag, _ in pairs(flags) do
        output = output .. "\n" .. flag .. " = " .. trigger.misc.getUserFlag(flag)
    end
    return output
end

Flagdebug:start()
