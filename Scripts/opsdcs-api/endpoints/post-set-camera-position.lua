local function applyRotation(a, b, angle)
    local ax, ay, az, bx, by, bz = a.x, a.y, a.z, b.x, b.y, b.z
    a.x = math.cos(angle) * ax + math.sin(angle) * bx
    a.y = math.cos(angle) * ay + math.sin(angle) * by
    a.z = math.cos(angle) * az + math.sin(angle) * bz
    b.x = math.cos(angle) * bx - math.sin(angle) * ax
    b.y = math.cos(angle) * by - math.sin(angle) * ay
    b.z = math.cos(angle) * bz - math.sin(angle) * az
end

local function getOrientation(roll, pitch, heading)
    local h = math.rad(heading)
    local p = math.rad(pitch)
    local r = math.rad(roll)
    local o = {x = {x = 1, y = 0, z = 0}, y = {x = 0, y = 1, z = 0}, z = {x = 0, y = 0, z = 1}}
    applyRotation(o.x, o.z, h)
    applyRotation(o.x, o.y, p)
    applyRotation(o.z, o.y, r)
    return o
end

return function(body)
    local success, result = pcall(net.json2lua, body)
    if success then
        local x, z = terrain.convertLatLonToMeters(result.position[2], result.position[1])
        local y = result.position[3]
        if result.agl then
            y = y + terrain.GetHeight(x, z)
        end
        local orientation = getOrientation(result.roll, result.pitch, result.heading)
        Export.LoSetCommand(158) -- freecam
        Export.LoSetCommand(36) -- center
        OpsdcsApi.targetCamera = {
            x = orientation.x,
            y = orientation.y,
            z = orientation.z,
            p = {x = x, y = y, z = z}
        }
    end
    return OpsdcsApi:response200()
end
