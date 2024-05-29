local function getHeading(unit)
    local pos = unit:getPosition()
    local headingRadians = math.atan2(pos.x.z, pos.x.x)
    if headingRadians < 0 then
        headingRadians = headingRadians + 2 * math.pi
    end
    return headingRadians * 180 / math.pi
end

local function getHeadingRadians(degrees)
    if degrees < 0 then
        degrees = degrees + 360
    end
    return degrees * (math.pi / 180)
end

return function(body)
    local success, result = pcall(net.json2lua, body)
    local staticObjects = {}
    if success then
        for _, static in ipairs(result) do
            local linkUnit = nil
            local offsets = nil
            if static.linkUnitName then
                linkUnit = Unit.getByName(static.linkUnitName)
                if linkUnit then
                    offsets = {
                        x = static.position[1] - linkUnit:getPoint().x,
                        y = static.position[2] - linkUnit:getPoint().z,
                        angle = heading - getHeadingRadians(getHeading(linkUnit))
                    }
                end
            end
            local heading = getHeadingRadians(static.heading)
            -- doesnt seem to work yet
            local pos = Export.LoGeoCoordinatesToLoCoordinates(static.position[2], static.position[1])
            local staticObject = {
                heading = heading,
                type = static.type,
                name = static.name,
                category = static.category,
                shape_name = static.shapeName,
                x = pos.x,
                y = pos.z,
                alt = static.position[3],
                alt_type = "BARO",
                linkUnit = linkUnit and linkUnit:getID(),
                offsets = offsets
            }
            local luaCode = "a_do_script([[coalition.addStaticObject(" .. static.country .. "," .. OpsdcsApi:serializeTable(staticObject) .. ")]])";
            net.dostring_in("mission", luaCode)
            table.insert(staticObjects, staticObject)
        end
    end
    return OpsdcsApi:response200(staticObjects)
end
