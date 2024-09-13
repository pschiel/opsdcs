-- zone colors

--- returns detailed zone data
--- @param zoneName string @name of zone
--- @return table @zone data (zoneId, name, verticies, ...)
function getZoneData(zoneName)
    for _, zone in ipairs(env.mission.triggers.zones) do
        if zone.name == zoneName then
            return zone
        end
    end
end

--- draws a rectangle from a quad zone (quad background fill seems bugged)
--- @param zoneName string @name of zone
function drawRectFromQuadZone(zoneName)
    local zoneData = getZoneData(zoneName)
    trigger.action.rectToAll(
        -1,
        1000 + zoneData.zoneId, -- add some offset
        { x = zoneData.verticies[4].x, z = zoneData.verticies[4].y, y = 100 },
        { x = zoneData.verticies[2].x, z = zoneData.verticies[2].y, y = 100 },
        { 0, 0, 0, 0 },
        { 0, 0, 0, 0 },
        2 -- dashed line
    )
end

--- changes border and fill color of a zone rectangle
--- @param zoneName string @name of zone
--- @param color table @color { r, g, b, a }
--- @param fillColor table @fill color { r, g, b, a }
function setZoneColors(zoneName, color, fillColor)
    local zoneData = getZoneData(zoneName)
    trigger.action.setMarkupColor(1000 + zoneData.zoneId, color)
    trigger.action.setMarkupColorFill(1000 + zoneData.zoneId, fillColor)
end

-- draw zones
drawRectFromQuadZone("z1")
drawRectFromQuadZone("z2")

-- set/change border and fill colors
setZoneColors("z1", { 0, 0, 1, 1 }, { 0, 0, 1, 0.2 })
setZoneColors("z2", { 1, 0, 0, 1 }, { 1, 0, 0, 0.2 })
