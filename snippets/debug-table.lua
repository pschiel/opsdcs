-- table debugger (outdated... better use lua-imgui now)

Tabledebug = {
    timeDelta = 0.1, -- loop interval
}

--- generates table debug output
function Tabledebug:output()
    local output = ""
    local objs = { "Static UH-1H cargo-2-1", "Static L118 Light Artillery-2" }
    for _, name in ipairs(objs) do
        local s = StaticObject.getByName(name)
        output = output .. name .. ":\n"
        output = output .. self:getRecursiveTableOutput({
            point = s:getPoint(),
            velocity = s:getVelocity(),
            agl = s:getPoint().y - land.getHeight({x = s:getPoint().x, y = s:getPoint().z}),
        })
        output = output .. "------\n"
    end
    return output
end

--- generates recursive table debug output
function Tabledebug:getRecursiveTableOutput(tbl, prefix)
    prefix = prefix or ""
    local output = ""
    for key, value in pairs(tbl) do
        if type(value) == "table" then
            output = output .. self:getRecursiveTableOutput(value, prefix .. key .. ".")
        else
            output = output .. prefix .. key .. " = " .. tostring(value) .. "\n"
        end
    end
    return output
end

--- creates menu item to toggle table debugger
function Tabledebug:start()
    self.isRunning = false
    self.menuPath = missionCommands.addCommand("Toggle Table Debugger", nil, self.toggle, self)
end

--- removes menu item, stops loop
function Tabledebug:stop()
    self.isRunning = false
    missionCommands.removeItem(self.menuPath)
end

--- toggles the table debugger on/off
function Tabledebug:toggle()
    self.isRunning = not self.isRunning
    if self.isRunning then self:loop() end
end

--- loop
function Tabledebug:loop()
    if not self.isRunning then return end
    trigger.action.outText(self:output(), 1, true)
    timer.scheduleFunction(self.loop, self, timer.getTime() + self.timeDelta)
end

Tabledebug:start()
Tabledebug:toggle()
