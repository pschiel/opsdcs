--- OpsdcsCrew - Virtual Crew (mission script)

-- if OpsdcsCrew then return end -- do not load twice (mission+hook)

OpsdcsCrew = {
    options = {
        timeDelta = 0.1, -- seconds between updates
        showChecklist = true, -- show interactive checklist
        pilotVoice = true, -- plays pilot voice sounds @todo
        autoAdvance = 2, -- auto advance to next state if all checked within this time (0 to disable)
        headNodAdvance = 0, -- advance when nodding up>down within this time @todo
        commandAdvance = 0, -- advance on user command @todo
        autoStartProcedures = true, -- autostart procedures when condition is met @todo
        showHighlights = true, -- shows highlights for next check
    },
    debug = true, -- debug setting
    typeName = nil, -- player unit type
    groupId = nil, -- player group id
    menu = {}, -- stores f10 menu items
    params = {}, -- current params
    args = {}, -- current args
    indications = {}, -- current indications
    state = nil, -- current state
    firstUnchecked = nil, -- current first unchecked item
    numHighlights = 0, -- current number of highlights
    zones = {}, -- opsdcs-crew zones
    isRunning = false, -- when procedure is running
    basedir = OpsdcsCrewBasedir or "", -- gets set by hook
    supportedTypes = { "CH-47F", "F-16C_50", "OH58D", "UH-1H" }, -- supported types (todo: autocheck)
    argsDebugMaxId = 4000,
}

--- tries to load the plugin for the player unit type
function OpsdcsCrew:start()
    if world.getPlayer() == nil then return end
    self.groupId = world.getPlayer():getGroup():getID()
    self.typeName = world.getPlayer():getTypeName()

    -- check if player unit type is supported
    local isSupported = false
    for _, typeName in ipairs(self.supportedTypes) do
        isSupported = isSupported or self.typeName == typeName
    end
    if not isSupported then return end

    -- inject script (relative to mission or full path via hook and/or basedir)
    local filename = self.basedir .. "aircraft/opsdcs-crew-" .. self.typeName .. ".lua"
    if self.basedir == "" then
        net.dostring_in('mission', 'a_do_script_file("' .. filename .. '")')
    else
        net.dostring_in('mission', 'a_do_script("dofile([[' .. filename .. ']])")')
    end
    self:log("opsdcs-crew start: " .. self.typeName .. " (" .. (self.basedir == "" and "mission" or "hook") .. ")")
    self:setupWaitForUserFlags()
    self:showMainMenu()
end

--- stops script
function OpsdcsCrew:stop()
    self:log("opsdcs-crew stop")
    self.isRunning = false
    self:clearHighlights()
    self:clearMenu()
end

--- ingame debug log helper
--- @param string msg
function OpsdcsCrew:log(msg)
    if self.debug then
        trigger.action.outText(msg, 5)
    end
end

--- sets up user input (space and backspace)
function OpsdcsCrew:setupWaitForUserFlags()
    local code = 'a_clear_flag("pressedSpace");a_clear_flag("pressedBS");c_start_wait_for_user("pressedSpace", "pressedBS")'
    net.dostring_in("mission", code)
end

--- returns all cockpit params
function OpsdcsCrew:getCockpitParams()
    local list = net.dostring_in("export", "return list_cockpit_params()")
    local params = {}
    for line in list:gmatch("[^\n]+") do
        local key, value = line:match("([^:]+):(.+)")
        if key and value then
            value = value:match('^%s*(.-)%s*$')
            if tonumber(value) then
                params[key] = tonumber(value)
            else
                params[key] = value:match('^"(.*)"$') or value
            end
        end
    end
    return params
end

--- returns cockpit args
--- @param number maxId @maximum argument id (if nil, get named arguments from aircraft definition)
function OpsdcsCrew:getCockpitArgs(maxId)
    local code
    local keys = {}
    if maxId == nil then
        code = 'local d=GetDevice(0);return ""'
        for k, v in pairs(self[self.typeName].args) do
            code = code .. '..tostring(d:get_argument_value(' .. v .. '))..";"'
            table.insert(keys, k)
        end
    else
        code = 'local d,r=GetDevice(0),"";for i=1,' .. maxId .. ' do r=r..d:get_argument_value(i)..";" end;return r'
    end
    local csv = net.dostring_in('export', code)
    local args = {}
    local i = 1
    for value in csv:gmatch("([^;]+)") do
        if maxId == nil then
            args[keys[i]] = tonumber(value)
        else
            args[i] = tonumber(value)
        end
        i = i + 1
    end
    return args
end

--- returns indications from specified devices
--- @param number maxId @maximum device id (if nil, get only devices from aircraft definition)
function OpsdcsCrew:getIndications(maxId)
    local code
    if maxId == nil then
        code = 'return ""'
        for device_id, _ in pairs(self[self.typeName].indications) do
            code = code .. '..list_indication(' .. device_id .. ')'
        end
    else
        for device_id = 1, maxId do
            code = code .. '..list_indication(' .. device_id .. ')'
        end
    end
    local lfsv = net.dostring_in('export', code)
    local indications = {}
    local key, content = nil, ""
    for line in lfsv:gmatch("[^\n]+") do
        if line == "-----------------------------------------" then
            if key then
                indications[key] = content:sub(1, -2)
            end
            key, content = nil, ""
        elseif not key then
            key = line
        else
            if line ~= "}" then
                content = content .. line .. "\n"
            end
        end
    end
    if key then
        indications[key] = content:sub(1, -2)
    end
    return indications
end

--- diy condition construct
--- @param table cond
function OpsdcsCrew:evaluateCond(cond)
    local i, result, highlights = 1, true, {}
    local check = {
        arg_eq = function(a, b) return self.args[a] == b end,
        arg_neq = function(a, b) return self.args[a] ~= b end,
        arg_gt = function(a, b) return self.args[a] > b end,
        arg_lt = function(a, b) return self.args[a] < b end,
        arg_between = function(a, b, c) return self.args[a] >= b and self.args[a] <= c end,
        param_eq = function(a, b) return self.params[a] == b end,
        param_neq = function(a, b) return self.params[a] ~= b end,
        param_gt = function(a, b) return self.params[a] > b end,
        param_lt = function(a, b) return self.params[a] < b end,
        param_between = function(a, b, c) return self.params[a] >= b and self.params[a] <= c end,
        ind_eq = function(a, b) return self.indications[a] == b end,
        ind_neq = function(a, b) return self.indications[a] ~= b end,
        ind_gt = function(a, b) return tonumber(self.indications[a]) > b end,
        ind_lt = function(a, b) return tonumber(self.indications[a]) < b end,
        ind_between = function(a, b, c) return tonumber(self.indications[a]) >= b and tonumber(self.indications[a]) <= c end,
    }
    while i <= #cond do
        local op = cond[i]
        if op:sub(1, 4) == "arg_" then table.insert(highlights, cond[i + 1]) end
        if check[op] then
            if op:find("between") then
                result = result and check[op](cond[i + 1], cond[i + 2], cond[i + 3])
                i = i + 4
            else
                result = result and check[op](cond[i + 1], cond[i + 2])
                i = i + 3
            end
        else
            self:log("Unknown condition: " .. op)
            i = i + 1
        end
    end
    return result, highlights
end

--- update loop
function OpsdcsCrew:update()
    if not self.isRunning then return end

    self.params = self:getCockpitParams()
    self.args = self:getCockpitArgs()
    self.indications = self:getIndications()
    local state = self[self.typeName].states[self.state]
    local timeDelta = self.options.timeDelta
    local lines = { state.text }
    local allCondsAreTrue = true
    local previousWasTrue = true
    local foundUnchecked = nil

    -- check conditions
    for i, condition in ipairs(state.conditions or {}) do
        local condIsTrue, highlights = self:evaluateCond(condition.cond)

        -- needPrevious=true - previous check must be true first
        if condition.needPrevious then condIsTrue = condIsTrue and previousWasTrue end

        -- needAllPrevious=true - all previous checks must be true first
        if condition.needAllPrevious then condIsTrue = condIsTrue and allCondsAreTrue end

        -- duration=3 - check if condition was true for 3 seconds
        condition.trueSince = condIsTrue and (condition.trueSince or timer.getTime()) or nil
        if condition.duration then
            condIsTrue = condition.trueSince ~= nil and timer.getTime() - condition.trueSince >= condition.duration
        end

        -- onlyOnce=true - condition must be true only once
        if condition.onlyOnce then
            condition.wasTrueOnce = condition.wasTrueOnce or condIsTrue
            condIsTrue = condition.wasTrueOnce
        end

        -- condition true: create checked item, clear highlights
        if condIsTrue then
            table.insert(lines, "[X]  " .. condition.text)
            if self.firstUnchecked == i then
                self.firstUnchecked = nil
                self:clearHighlights()
            end
        end

        -- condition false: create unchecked item, show highlights
        if not condIsTrue then
            table.insert(lines, "[  ]  " .. condition.text)
            if not foundUnchecked then
                foundUnchecked = i
                if foundUnchecked ~= self.firstUnchecked then
                    self.firstUnchecked = foundUnchecked
                    if self.options.showHighlights then
                        self:showHighlights(condition.highlights or highlights)
                    end
                end
            end
        end

        -- needed for needPrevious and needAllPrevious
        allCondsAreTrue = allCondsAreTrue and condIsTrue
        previousWasTrue = condIsTrue
    end

    -- look for user input
    local code = 'return (c_flag_is_true("pressedSpace") and "1" or "0") .. (c_flag_is_true("pressedBS") and "1" or "0")'
    local keys = net.dostring_in("mission", code)
    if keys ~= "00" then self:setupWaitForUserFlags() end
    local pressedSpace, pressedBS = keys:sub(1, 1) == "1", keys:sub(2, 2) == "1"

    -- advance state when all conditions are true (auto or spacebar)
    state.allCondsAreTrueSince = allCondsAreTrue and (state.allCondsAreTrueSince or timer.getTime()) or nil
    if state.allCondsAreTrueSince and timer.getTime() - state.allCondsAreTrueSince >= self.options.autoAdvance then
        if self.options.autoAdvance > 0 then
            self:transition(state)
        else
            if pressedSpace or state.next_state == nil then
                self:transition(state)
            else
                table.insert(lines, "\n[Press SPACEBAR to continue]")
                timeDelta = 0.5
            end
        end
    end

    -- show text/checklist
    if self.options.showChecklist then
        local text = lines[1] .. (#lines > 1 and "\n\n" or "")
        text = text .. table.concat(lines, "\n", 2)
        trigger.action.outText(text, 3, true)
    end
        
    timer.scheduleFunction(self.update, self, timer.getTime() + timeDelta)
end

--- transition to state
--- @param string state
function OpsdcsCrew:transition(state)
    self.state = state.next_state
    self.firstUnchecked = nil
    if self.state == nil then
        self:stop()
        self:showMainMenu()
    end
end

--- shows highlights for next check
--- @param table highlights
function OpsdcsCrew:showHighlights(highlights)
    local code, id = "", 1
    for _, arg in ipairs(highlights) do
        code = code .. 'a_cockpit_highlight(' .. id .. ', "' .. arg .. '", 0, "");'
        id = id + 1
    end
    net.dostring_in("mission", code)
    self.numHighlights = id - 1
end

--- clears highlights
function OpsdcsCrew:clearHighlights()
    local code = ""
    for id = 1, self.numHighlights do
        code = code .. 'a_cockpit_remove_highlight(' .. id .. ');'
    end
    net.dostring_in("mission", code)
end

--- clears temporary state vars
function OpsdcsCrew:clearStateVars()
    for _, state in pairs(self[self.typeName].states) do
        state.allCondsAreTrueSince = nil
        if state.conditions ~= nil then
            for _, condition in pairs(state.conditions) do
                condition.trueSince = nil
                condition.wasTrueOnce = nil
            end
        end
    end
end

--- shows f10 menu entries (one per procedure)
function OpsdcsCrew:showMainMenu()
    self:clearMenu()
    for name, procedure in pairs(self[self.typeName].procedures) do
        self.menu[name] = missionCommands.addCommandForGroup(self.groupId, name, nil, OpsdcsCrew.onProcedure, self, name, procedure)
    end
    if self.debug then
        self.menu["args_debug"] = missionCommands.addCommandForGroup(self.groupId, "Toggle Arguments Debug", nil, OpsdcsCrew.onArgsDebug, self)
    end
end

--- toggles cockpit argument debug display
function OpsdcsCrew:onArgsDebug()
    self.isRunningArgsDebug = self.isRunningArgsDebug and false or true
    if not self.isRunningArgsDebug then return end
    self.allLastArgs = self:getCockpitArgs(self.argsDebugMaxId)
    timer.scheduleFunction(self.argsDebugLoop, self, timer.getTime() + 0.5)
end

--- cockpit argument debug display loop
function OpsdcsCrew:argsDebugLoop()
    local maxDelta = 0.1
    if not self.isRunningArgsDebug then return end
    self.allCurrentArgs = self:getCockpitArgs(self.argsDebugMaxId)
    for i = 1, self.argsDebugMaxId do
        local last, current = self.allLastArgs[i], self.allCurrentArgs[i]
        if math.abs(tonumber(last) - tonumber(current)) > maxDelta then
            trigger.action.outText("arg " .. i .. " changed: " .. last .. " -> " .. current, 10)
        end
        self.allLastArgs[i] = current
    end
    timer.scheduleFunction(self.argsDebugLoop, self, timer.getTime() + 0.5)
end

--- clears f10 menu
function OpsdcsCrew:clearMenu()
    for name, item in pairs(self.menu) do
        self.menu[name] = nil
        missionCommands.removeItemForGroup(self.groupId, item)
    end
end

--- f10 menu procedure
--- @param string name
--- @param table procedure
function OpsdcsCrew:onProcedure(name, procedure)
    self:clearHighlights()
    self:clearMenu()
    self:clearStateVars()
    self.menu["abort-" .. name] = missionCommands.addCommandForGroup(self.groupId, "Abort " .. procedure.text, nil, OpsdcsCrew.onAbort, self)
    self.state = self[self.typeName].procedures[name].start_state
    self.isRunning = true
    self:update()
end

--- f10 menu abort
function OpsdcsCrew:onAbort()
    self:stop()
    self:showMainMenu()
end

OpsdcsCrew:start()
