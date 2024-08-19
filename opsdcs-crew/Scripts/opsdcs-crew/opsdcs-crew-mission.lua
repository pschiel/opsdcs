--- OpsdcsCrew - Virtual Crew (mission script)

-- if OpsdcsCrew then return end -- do not load twice (mission+hook)
OpsdcsCrew = {
    options = {
        timeDelta = 0.1,            -- seconds between updates
        showChecklist = true,       -- show interactive checklist
        pilotVoice = true,          -- plays pilot voice sounds @todo
        autoAdvance = 2,            -- auto advance to next state if all checked within this time (0 to disable)
        headNodAdvance = 0,         -- advance when nodding up>down within this time @todo
        commandAdvance = 0,         -- advance on user command @todo
        autoStartProcedures = true, -- autostart procedures when condition is met @todo
        showHighlights = true,      -- shows highlights for next check
        debug = true,               -- debug setting
    },

    typeName = nil,       -- player unit type
    groupId = nil,        -- player group id
    menu = {},            -- stores f10 menu items
    params = {},          -- current params
    args = {},            -- current args
    indications = {},     -- current indications
    state = nil,          -- current state
    firstUnchecked = nil, -- current first unchecked item
    numHighlights = 0,    -- current number of highlights
    zones = {},           -- opsdcs-crew zones
    isRunning = false,    -- when procedure is running
    basedir = OpsdcsCrewBasedir or "",
    argsDebugMaxId = 4000,
    sndPlayUntil = nil,
    supportedTypes = { "CH-47Fbl1", "F-16C_50", "OH58D", "SA342L", "UH-1H" }, -- supported types (@todo: autocheck, variants)
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

    self:loadPluginData()
    self:log("opsdcs-crew start: " .. self.typeName .. " (" .. (self.basedir == "" and "mission" or "hook") .. ")")
    self:setupWaitForUserFlags()
    self:showMainMenu()
end

-- loads/resets plugin data and states
function OpsdcsCrew:loadPluginData()
    -- inject script (relative to mission or full path via hook and/or basedir)
    local filename = self.basedir .. "aircraft/opsdcs-crew-" .. self.typeName .. ".lua"
    if self.basedir == "" then
        net.dostring_in("mission", "a_do_script_file('" .. filename .. "')")
    else
        net.dostring_in("mission", "a_do_script('dofile([[" .. filename .. "]])')")
    end
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
    if self.options.debug then
        trigger.action.outText("[opsdcs-crew] " .. msg, 5)
    end
end

--- plays sound (from inside miz, or absolute path when using basedir)
--- @param string filename
--- @param number duration
function OpsdcsCrew:playSound(filename, duration)
    if self.basedir == "" then
        trigger.action.outSound(filename)
    else
        local code = "require('sound').playSound('" .. self.basedir .. filename .. "')"
        net.dostring_in("gui", code)
    end
    self.sndPlayUntil = timer.getTime() + (duration or 1)
    self.sndLastPlayed = timer.getTime()
end

-- plays sound from text/seat/soundpack (sounds/typename/seat/soundpack/state/text.ogg)
function OpsdcsCrew:playSoundFromText(text, duration, seat)
    seat = seat or "cp"
    local filename = "sounds/" .. self.typeName .. "/" .. seat .. "/" .. self[self.typeName].soundpack[seat] .. "/" .. self.state .. "/"
    filename = filename .. text:gsub("[/>:]", "-") .. ".ogg"
    self:playSound(filename, duration)
end

--- sets up user input (space and backspace)
function OpsdcsCrew:setupWaitForUserFlags()
    local code = "a_clear_flag('pressedSpace');a_clear_flag('pressedBS');c_start_wait_for_user('pressedSpace','pressedBS')"
    net.dostring_in("mission", code)
end

--- returns all cockpit params @todo refactor usage
function OpsdcsCrew:getCockpitParams()
    local list = net.dostring_in("export", "return list_cockpit_params()")
    local params = {}
    for line in list:gmatch("[^\n]+") do
        local key, value = line:match("([^:]+):(.+)")
        if key and value then
            value = value:match("^%s*(.-)%s*$")
            if tonumber(value) then
                params[key] = tonumber(value)
            else
                params[key] = value:match('^"(.*)"$') or value
            end
        end
    end
    return params
end

--- returns cockpit args @todo refactor usage
--- @param number maxId @maximum argument id (if nil, get named arguments from aircraft definition)
--- @param table idList @optional list of argument ids to get
function OpsdcsCrew:getCockpitArgs(maxId, idList)
    if self[self.typeName].argsById == nil then
        self[self.typeName].argsById = {}
        for k, v in pairs(self[self.typeName].args) do
            self[self.typeName].argsById[v] = k
        end
    end
    local code
    local keys = {}
    if maxId == nil and idList == nil then
        code = "local d=GetDevice(0);return ''"
        for k, v in pairs(self[self.typeName].args) do
            code = code .. "..tostring(d:get_argument_value(" .. v .. "))..';'"
            table.insert(keys, k)
        end
    elseif maxId then
        code = "local d,r=GetDevice(0),'';for i=1," .. maxId .. " do r=r..d:get_argument_value(i)..';' end;return r"
    elseif idList then
        code = "local d,r=GetDevice(0),'';for _,i in ipairs({" .. table.concat(idList, ",") .. "}) do r=r..d:get_argument_value(i)..';' end;return r"
    end
    local csv = net.dostring_in("export", code)
    local args = {}
    local i = 1
    for value in csv:gmatch("([^;]+)") do
        if maxId == nil and idList == nil then
            args[keys[i]] = tonumber(value)
        elseif maxId then
            args[i] = tonumber(value)
        elseif idList then
            args[idList[i]] = tonumber(value)
        end
        i = i + 1
    end
    return args
end

--- returns indications from specified devices @todo refactor usage
--- @param number maxId @maximum device id (if nil, get only devices from aircraft definition)
function OpsdcsCrew:getIndications(maxId)
    local code = "return ''"
    if maxId == nil then
        for device_id, _ in pairs(self[self.typeName].indications) do
            code = code .. "..'##" .. device_id .. "##\\n'..list_indication(" .. device_id .. ")"
        end
    else
        for device_id = maxId, maxId do
            code = code .. "..'##" .. device_id .. "##\\n'..list_indication(" .. device_id .. ")"
        end
    end
    local lfsv = net.dostring_in("export", code)
    local indications = {}
    local device_id, key, content = nil, nil, ""
    for line in lfsv:gmatch("[^\n]+") do
        if line:match("^##(%d+)##$") then
            device_id = tonumber(line:match("^##(%d+)##$"))
            indications[device_id] = {}
        elseif line == "-----------------------------------------" then
            if key then
                indications[device_id][key] = content:sub(1, -2)
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
        indications[device_id][key] = content:sub(1, -2)
    end
    return indications
end

--- converts ranges string to list
--- @param string str @ranges string (e.g. "1-3 5 7-12 18 33")
function OpsdcsCrew:rangesToList(str)
    local ids = {}
    for range in str:gmatch("%S+") do
        local from, to = range:match("(%d+)-(%d+)")
        if not (from and to) then
            table.insert(ids, tonumber(range))
        else
            for j = tonumber(from), tonumber(to) do
                table.insert(ids, j)
            end
        end
    end
    return ids
end

--- diy condition construct
--- @param table cond
--- @return boolean @condition true/false
--- @return table @args for highlights
function OpsdcsCrew:evaluateCond(cond)
    local delta = 0.001
    local i, result, highlights = 1, true, {}
    local check = {
        skip = { 0, function() return true end },
        arg_eq = { 2, function(a, b) return math.abs(self.args[a] - b) < delta end },
        arg_neq = { 2, function(a, b) return math.abs(self.args[a] - b) >= delta end },
        arg_gt = { 2, function(a, b) return self.args[a] > b end },
        arg_lt = { 2, function(a, b) return self.args[a] < b end },
        arg_between = { 3, function(a, b, c) return self.args[a] >= b and self.args[a] <= c end },
        param_eq = { 2, function(a, b) return self.params[a] == b end },
        param_neq = { 2, function(a, b) return self.params[a] ~= b end },
        param_gt = { 2, function(a, b) return self.params[a] > b end },
        param_lt = { 2, function(a, b) return self.params[a] < b end },
        param_between = { 3, function(a, b, c) return self.params[a] >= b and self.params[a] <= c end },
        ind_eq = { 3, function(a, b, c) return self.indications[a][b] == c end },
        ind_neq = { 3, function(a, b, c) return self.indications[a][b] ~= c end },
        ind_gt = { 3, function(a, b, c)
            local x = tonumber(self.indications[a][b])
            if x == nil then return false end
            return x > c
        end },
        ind_lt = { 3, function(a, b, c)
            local x = tonumber(self.indications[a][b])
            if x == nil then return false end
            return x < c
        end },
        ind_between = { 4, function(a, b, c, d)
            local x = tonumber(self.indications[a][b])
            if x == nil then return false end
            return x >= c and x <= d
        end },
        any_ind_eq = { 2, function(a, b)
            for _, v in pairs(self.indications[a]) do
                if v == b then return true end
            end
            return false
        end },
        no_ind_eq = { 2, function(a, b)
            for _, v in pairs(self.indications[a]) do
                if v == b then return false end
            end
            return true
        end },
        arg_range_between = { 3, function(a, b, c)
            local ids = self:rangesToList(a)
            local args = self:getCockpitArgs(nil, ids)
            for _, v in pairs(args) do
                if v < b or v > c then return false end
            end
            return true
        end }
    }
    while i <= #cond do
        local op = cond[i]
        if op == "arg_eq" or op == "arg_neq" or op == "arg_gt" or op == "arg_lt" or op == "arg_between" then table.insert(highlights, cond[i + 1]) end
        if check[op] then
            if check[op][1] == 0 then
                result = result and check[op][2]()
            elseif check[op][1] == 1 then
                result = result and check[op][2](cond[i + 1])
            elseif check[op][1] == 2 then
                result = result and check[op][2](cond[i + 1], cond[i + 2])
            elseif check[op][1] == 3 then
                result = result and check[op][2](cond[i + 1], cond[i + 2], cond[i + 3])
            else
                result = result and check[op][2](cond[i + 1], cond[i + 2], cond[i + 3], cond[i + 4])
            end
            i = i + check[op][1] + 1
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

    local timeDelta = self.options.timeDelta
    if self.sndPlayUntil and timer.getTime() > self.sndPlayUntil then
        self.sndPlayUntil = nil
    end

    self.params = self:getCockpitParams()
    self.args = self:getCockpitArgs()
    self.indications = self:getIndications()
    local state = self[self.typeName].states[self.state]
    local lines = { state.text }
    local allCondsAreTrue = true
    local previousWasTrue = true
    local foundUnchecked = nil

    -- play state sound
    if state.sndPlayed == nil and state.snd ~= nil then
        self:playSoundFromText(state.text, state.snd, state.seat)
        state.sndPlayed = true
    end

    -- check conditions
    for i, condition in ipairs(state.conditions or {}) do
        local condIsTrue, highlights = self:evaluateCond(condition.cond)

        -- needPrevious=true - previous check must be true first
        if condition.needPrevious then condIsTrue = condIsTrue and previousWasTrue end

        -- needAllPrevious=true - all previous checks must be true first @todo
        if state.needAllPrevious or condition.needAllPrevious then condIsTrue = condIsTrue and allCondsAreTrue end

        -- duration=3 - check if condition was true for 3 seconds
        condition.trueSince = condIsTrue and (condition.trueSince or timer.getTime()) or nil
        if condition.duration then
            condIsTrue = condition.trueSince ~= nil and timer.getTime() - condition.trueSince >= condition.duration
        end

        -- onlyOnce=true - condition must be true only once (no uncheck once checked)
        if condition.onlyOnce then
            condition.wasTrueOnce = condition.wasTrueOnce or condIsTrue
            condIsTrue = condition.wasTrueOnce
        end

        -- condition sound finished playing
        if condition.sndPlayUntil and timer.getTime() > condition.sndPlayUntil then
            condition.sndPlayed = true
        end

        -- condition sound not played yet - mark false
        if condition.snd and condition.sndPlayed == nil then
            condIsTrue = false
            -- play when nothing else playing and all other checked so far
            if condition.sndPlayUntil == nil and self.sndPlayUntil == nil and allCondsAreTrue then
                self:playSoundFromText(condition.text, condition.snd, condition.seat)
                condition.sndPlayUntil = timer.getTime() + condition.snd
            end
        end

        -- play check if not played yet and everything checked until here
        if condIsTrue and condition.check and allCondsAreTrue and condition.checkPlayed == nil and self.sndPlayUntil == nil then
            local n = math.random(1, 8)
            self:playSound("sounds/" .. self.typeName .. "/plt/" .. self[self.typeName].soundpack.plt .. "/check" .. n .. ".ogg", 1)
            condition.checkPlayed = true
        end

        -- long pause, repeat
        if not condIsTrue and condition.snd and self.sndLastPlayed and timer.getTime() - self.sndLastPlayed > 30 then
            condition.sndPlayed, condition.sndPlayUntil = nil, nil
            local n = math.random(1, 5)
            self:playSound("sounds/" .. self.typeName .. "/cp/" .. self[self.typeName].soundpack.cp .. "/wait" .. n .. ".ogg", 2)
        end

        -- condition true: create checked item, clear highlights
        if condIsTrue then
            if not condition.hide then
                table.insert(lines, "[X]  " .. condition.text)
            end
            if self.firstUnchecked == i then
                self.firstUnchecked = nil
                self:clearHighlights()
            end
        end

        -- condition false: create unchecked item, show highlights when first unchecked changed
        if not condIsTrue then
            if not condition.hide then
                table.insert(lines, "[  ]  " .. condition.text)
            end
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
    local code = "return (c_flag_is_true('pressedSpace') and '1' or '0') .. (c_flag_is_true('pressedBS') and '1' or '0')"
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
        -- if self.sndPlayUntil then
        --     text = text .. "\nself sndPlayUntil: " .. (self.sndPlayUntil - timer.getTime())
        -- else
        --     text = text .. "\nself sndPlayUntil: nil"
        -- end
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
        code = code .. "a_cockpit_highlight(" .. id .. ', "' .. arg .. '", 0, "");'
        id = id + 1
    end
    net.dostring_in("mission", code)
    self.numHighlights = id - 1
end

--- clears highlights
function OpsdcsCrew:clearHighlights()
    local code = ""
    for id = 1, self.numHighlights do
        code = code .. "a_cockpit_remove_highlight(" .. id .. ");"
    end
    net.dostring_in("mission", code)
end


--- shows f10 menu entries (one per procedure)
function OpsdcsCrew:showMainMenu()
    self:clearMenu()
    for _, procedure in ipairs(self[self.typeName].procedures) do
        self.menu[procedure.name] = missionCommands.addCommandForGroup(self.groupId, procedure.name, nil, OpsdcsCrew.onProcedure, self, procedure)
    end
    self.menu["whats_this"] = missionCommands.addCommandForGroup(self.groupId, "Cockpit Tutor", nil, OpsdcsCrew.onWhatsThis, self)
    if self.options.debug then
        self.menu["args_debug"] = missionCommands.addCommandForGroup(self.groupId, "Toggle Arguments Debug", nil, OpsdcsCrew.onArgsDebug, self)
    end
end

--- toggles cockpit argument debug display
function OpsdcsCrew:onArgsDebug()
    if self.isRunningArgsDebug then
        self.isRunningArgsDebug = false
    else
        self.isRunningArgsDebug = true
        self.argsDebugLastArgs = self:getCockpitArgs(self.argsDebugMaxId)
        timer.scheduleFunction(self.argsDebugLoop, self, timer.getTime() + 0.5)
    end
end

--- cockpit argument debug display loop
function OpsdcsCrew:argsDebugLoop()
    local maxDelta = 0.1
    if not self.isRunningArgsDebug then return end
    local currentArgs = self:getCockpitArgs(self.argsDebugMaxId)
    for i = 1, self.argsDebugMaxId do
        local last, current = self.argsDebugLastArgs[i], currentArgs[i]
        self.argsDebugLastArgs[i] = current
        if math.abs(tonumber(last) - tonumber(current)) > maxDelta and self[self.typeName].excludeDebugArgs[i] == nil then
            local argName = i
            if self[self.typeName].argsById[i] then
                argName = self[self.typeName].argsById[i]
            end
            trigger.action.outText("arg " .. argName .. " changed: " .. last .. " -> " .. current, 10)
        end
    end
    timer.scheduleFunction(self.argsDebugLoop, self, timer.getTime() + 0.1)
end

--- toggles whats this
function OpsdcsCrew:onWhatsThis()
    if self.isRunningWhatsThis then
        self.isRunningWhatsThis = false
    else
        self.isRunningWhatsThis = true
        self.whatsThisLastArgs = self:getCockpitArgs()
        timer.scheduleFunction(self.whatsThisLoop, self, timer.getTime() + 0.5)
    end
end

--- plays sounds on defined cockpit argument changes
function OpsdcsCrew:whatsThisLoop()
    local maxDelta = 0.1
    if not self.isRunningWhatsThis then return end
    local currentArgs = self:getCockpitArgs()
    for i, _ in pairs(self[self.typeName].args) do
        local last, current = self.whatsThisLastArgs[i], currentArgs[i]
        self.whatsThisLastArgs[i] = current
        if math.abs(tonumber(last) - tonumber(current)) > maxDelta then
            local filename = "sounds/" .. self.typeName .. "/cockpit-tutor/" .. i .. ".ogg"
            trigger.action.outText("playing sound: " .. filename, 10)
            self:playSound(filename)
            -- delay
            timer.scheduleFunction(self.whatsThisLoop, self, timer.getTime() + 3)
            return
        end
    end
    timer.scheduleFunction(self.whatsThisLoop, self, timer.getTime() + 0.1)
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
function OpsdcsCrew:onProcedure(procedure)
    self:clearHighlights()
    self:clearMenu()
    self:loadPluginData()
    self.menu["abort-" .. procedure.name] = missionCommands.addCommandForGroup(self.groupId, "Abort " .. procedure.name, nil, OpsdcsCrew.onAbort, self)
    self.state = procedure.start_state
    self.isRunning = true
    self.sndLastPlayed = nil
    self:update()
end

--- f10 menu abort
function OpsdcsCrew:onAbort()
    self:stop()
    self:showMainMenu()
end

OpsdcsCrew:start()
