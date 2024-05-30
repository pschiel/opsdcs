local function applyRotation(a, b, angle)
    local cos_angle, sin_angle = math.cos(angle), math.sin(angle)
    local ax, ay, az, bx, by, bz = a.x, a.y, a.z, b.x, b.y, b.z
    a.x, a.y, a.z = cos_angle * ax + sin_angle * bx, cos_angle * ay + sin_angle * by, cos_angle * az + sin_angle * bz
    b.x, b.y, b.z = cos_angle * bx - sin_angle * ax, cos_angle * by - sin_angle * ay, cos_angle * bz - sin_angle * az
end

local function getOrientation(roll, pitch, heading)
    local h, p, r = math.rad(heading), math.rad(pitch), math.rad(roll)
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
