local lastKnown = {}

local replaceTypes = {
    ["m777_cargo"] = "CH_M777LTH_M795",
    ["oshkosh_latv_m2_cargo"] = "CH_OshkoshLATV_M2",
    ["eagle_iv_mrap_cargo"] = "CH_EagleIV",
    ["wiesel_1a4_awc_cargo"] = "CH_Wiesel1A4",
}

local function spawn(id)
    local type = replaceTypes[lastKnown[id].type]
    local groupData = {
        ["visible"] = false,
        ["taskSelected"] = true,
        ["route"] = {},
        ["tasks"] = {},
        ["hidden"] = false,
        ["units"] ={
            [1] = {
                ["type"] = type,
                ["unitId"] = id,
                ["skill"] = AI.Skill.EXCELLENT,
                ["y"] = lastKnown[id].y,
                ["x"] = lastKnown[id].x,
                ["name"] = "g" .. id,
                ["alt"] = 0,
                ["speed"] = 0,
                ["alt_type"] = AI.Task.AltitudeType.RADIO,
                ["heading"] = 140 * (math.pi / 180)
            },
        },
        ["name"] = "g" .. id,
        ["start_time"] = 0,
        ["task"] = "Nothing",
        ["groupId"] = id,
    }
    coalition.addGroup(country.id.USA, Group.Category.GROUND, groupData)
end

local function convertCargo()
    --trigger.action.outText("checking cargo", 10, true)
    for i = 2, 13 do
        local s = StaticObject.getByName("c" .. i)
        if s ~= nil then
            lastKnown[i] = {
                ["type"] = s:getTypeName(),
                ["y"] = s:getPoint().z,
                ["x"] = s:getPoint().x,
            }
            local p = s:getPoint()
            local agl = p.y - land.getHeight({x = p.x, y = p.z})
            local v_y = s:getVelocity().y
            if agl < 0 then
                trigger.action.outText("c" .. i .. " agl<0, respawn " .. lastKnown[i].type, 10, false)
                spawn(i)
                s:destroy()
            else
                --trigger.action.outText("c" .. i .. " agl: " .. agl .. ", v_y: " .. v_y, 10, false)
            end
        else
            local g = Group.getByName("g" .. i)
            local u = Unit.getByName("g" .. i)
            if g ~= nil and u ~= nil then
                --trigger.action.outText("g" .. i .. " alive, type: " .. u:getTypeName(), 10, false)
            else
                --trigger.action.outText("c/g" .. i .. " GONE", 10, false)
            end
        end
    end
    timer.scheduleFunction(convertCargo, nil, timer.getTime() + 2)
end

timer.scheduleFunction(convertCargo, nil, timer.getTime() + 1)
