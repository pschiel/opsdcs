local function deg2rad(degrees)
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
            local pos = Export.LoGeoCoordinatesToLoCoordinates(static.position[1], static.position[2])
            if static.unitId == nil then
                if OpsdcsApi.staticObjectsByName[static.name] then
                    static.unitId = OpsdcsApi.staticObjectsByName[static.name].unitId
                else
                    OpsdcsApi.maxUnitId = OpsdcsApi.maxUnitId + 1
                    static.unitId = OpsdcsApi.maxUnitId
                end
            end
            local staticObject = {
                name = static.name,
                type = static.type,
                x = pos.x,
                y = pos.z,
                shape_name = static.shapeName,
                category = static.category,
                dead = static.dead or nil,
                rate = static.rate or nil,
                groupId = static.groupId or nil,
                unitId = static.unitId or nil,
                heading = static.heading and deg2rad(static.heading) or nil,
                linkOffset = static.linkOffset or nil,
                linkUnit = static.linkUnit or nil,
                offsets = static.offsets or nil,
                mass = static.mass or nil,
                canCargo = static.canCargo or nil,
                livery_id = static.livery_id or nil,
            }
            local luaCode = "a_do_script([[coalition.addStaticObject(" .. static.country .. "," .. OpsdcsApi:serializeTable(staticObject) .. ")]])";
            net.dostring_in("mission", luaCode)
            OpsdcsApi.staticObjectsByName[staticObject.name] = staticObject
            table.insert(staticObjects, staticObject)
        end
    end
    return OpsdcsApi:response200(statiffObjects)
end
