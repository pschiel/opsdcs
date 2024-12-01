-- WIP some basic scripting loop

local function distance2D(unit1, unit2)
    local p1 = unit1:getPoint()
    local p2 = unit2:getPoint()
    return math.sqrt((p1.x-p2.x)*(p1.x-p2.x) + (p1.z-p2.z)*(p1.z-p2.z))
end

local function distance3D(unit1, unit2)
    local p1 = unit1:getPoint()
    local p2 = unit2:getPoint()
    return math.sqrt((p1.x-p2.x)*(p1.x-p2.x) + (p1.z-p2.z)*(p1.z-p2.z) + (p1.y-p2.y)*(p1.y-p2.y))
end

local function enableROE(unit)
    local c = unit:getController()
    c:setOption(AI.Option.Ground.id.ALARM_STATE, AI.Option.Ground.val.ALARM_STATE.RED)
    c:setOption(AI.Option.Ground.id.ROE, AI.Option.Ground.val.ROE.OPEN_FIRE)
end

local function getUnits(side, match)
    local units = {}
    for _, groups in ipairs(coalition.getGroups(side)) do
        for _, unit in ipairs(groups:getUnits()) do
            if unit:getName():match(match) then
                table.insert(units, unit)
            end
        end
    end
    return units
end


local function loop()
    local blueGroundUnits = getUnits(coalition.side.BLUE, "Ground-.*")
    trigger.action.outText("Blue units: " .. #blueUnits, 5)
    timer.scheduleFunction(loop, nil, timer.getTime() + 1)
end

timer.scheduleFunction(loop, nil, timer.getTime() + 1)
