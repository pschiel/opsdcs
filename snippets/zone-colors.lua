-- zone color script

--- returns detailed zone data
--- @param zoneName string @name of the zone
--- @return table @zone data (name, zoneId, verticies, ...)
function getZoneData(zoneName)
    for _, zone in ipairs(env.mission.triggers.zones) do
        if zone.name == zoneName then
            return zone
        end
    end
end

--- draws a quad shape around a zone
--- @param zoneName string @name of the zone
function drawQuadFromZone(zoneName, lineType)
    local zoneData = getZoneData(zoneName)
    lineType = lineType or 2 -- default: dashed
    trigger.action.quadToAll(
        -1,
        1000 + zoneData.zoneId, -- mark id = zone id plus some offset
        { x = zoneData.verticies[4].x, z = zoneData.verticies[4].y, y = 0 },
        { x = zoneData.verticies[3].x, z = zoneData.verticies[3].y, y = 0 },
        { x = zoneData.verticies[2].x, z = zoneData.verticies[2].y, y = 0 },
        { x = zoneData.verticies[1].x, z = zoneData.verticies[1].y, y = 0 },
        { 0, 0, 0, 0 }, -- invisible initially
        { 0, 0, 0, 0 },
        lineType
    )
end

--- changes border and fill color of a zone
--- @param zoneName string @name of the zone
--- @param color table @color { r, g, b, a }
--- @param fillColor table @fill color { r, g, b, a }
function setZoneColors(zoneName, color, fillColor)
    local zoneData = getZoneData(zoneName)
    trigger.action.setMarkupColor(1000 + zoneData.zoneId, color)
    trigger.action.setMarkupColorFill(1000 + zoneData.zoneId, fillColor)
end

-- draw zones
drawQuadFromZone("z1")
drawQuadFromZone("z2")

-- set/change border and fill colors
setZoneColors("z1", { 0, 0, 1, 1 }, { 0, 0, 1, 0.2 })
setZoneColors("z2", { 1, 0, 0, 1 }, { 1, 0, 0, 0.2 })

-- for testing: f10 command to kill unit "u1"
missionCommands.addCommand("poof", nil, function() trigger.action.explosion(Unit.getByName("u1"):getPoint(), 100) end)
