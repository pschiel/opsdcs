--- removes scenery objects around a point
--- @param point vec3 @center point
--- @param radius number @radius
--- @param match string @type name to match (e.g. "KAMAZ-FIRE")
function removeSceneryObjects(point, radius, match)
    local volume = {
        id = world.VolumeType.SPHERE,
        params = {
            point = point,
            radius = radius
        }
    }
    local onFoundObject = function(object)
        if object:getTypeName() == match then
            trigger.action.outText(
                string.format("removing %s at x %.2f / y %.2f / z %.2f",
                object:getTypeName(),
                object:getPoint().x,
                object:getPoint().y,
                object:getPoint().z
            ), 10)
            object:destroy()
        end
        return true
    end
    world.searchObjects(Object.Category.SCENERY, volume, onFoundObject)
end

-- example: remove all "KAMAZ-FIRE" trucks around Tbilisi-Lochini airbase (1000m)
removeSceneryObjects(Airbase.getByName("Tbilisi-Lochini"):getPoint(), 1000, "KAMAZ-FIRE")
