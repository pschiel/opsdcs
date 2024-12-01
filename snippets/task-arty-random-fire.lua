-- makes an arty fire at random targets, while ignoring certain others (via setting invisible)

local targetMatch = "Whatever-.*"
local artyName = "Arty-1-1"
local msgDuration = 20
local fireInterval = 10
local targets = {}

local function getTargetsAndSetOthersInvisible()
    -- all groups
    local groups = coalition.getGroups(coalition.side.RED)
    for _, group in pairs(groups) do
        if not group:isExist() then break end
        -- all units of group
        local units = group:getUnits()
        for _, unit in pairs(units) do
            if not unit:isExist() then break end
            local name = unit:getName()
            -- must match
            if name:match(targetMatch) then
                -- add to targets
                trigger.action.outText("adding target: " .. name, msgDuration)
                table.insert(targets, unit)
            else
                -- else set invisible
                trigger.action.outText("setting invisible: " .. name, msgDuration)
                local command = {
                    id = "SetInvisible",
                    params = { value = true }
                }
                unit:getController():setCommand(command)
            end
        end
    end
end

local function loopArtyFire()
    local arty = Unit.getByName(artyName)
    if not arty:isExist() then return end
    -- get random target
    local idx = math.random(#targets)
    local randomTarget = targets[idx]
    if not randomTarget:isExist() then
        -- remove from target list
        trigger.action.outText("unit idx dead: " .. tostring(idx), msgDuration)
        table.remove(targets, idx)
        return
    end
    local pos = randomTarget:getPoint()
    trigger.action.outText("firing at: " .. randomTarget:getName(), msgDuration)
    -- fire at point
    local task = {
        id = "FireAtPoint",
        params = { x = pos.x, y = pos.z }
    }
    arty:getController():setTask(task)
    timer.scheduleFunction(loopArtyFire, {}, timer.getTime() + fireInterval)
end

getTargetsAndSetOthersInvisible()
loopArtyFire()
