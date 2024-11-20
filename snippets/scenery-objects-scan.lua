--- scans scenery object types around a point
--- @param point vec3 @center point
--- @param radius number @radius
function scanSceneryObjectTypes(point, radius)
    local types = {}
    local volume = {
        id = world.VolumeType.SPHERE,
        params = {
            point = point,
            radius = radius
        }
    }
    local onFoundObject = function(object)
        if not types[object:getTypeName()] then
            types[object:getTypeName()] = true
            trigger.action.outText("found scenery object type: " .. object:getTypeName(), 30)
        end
        return true
    end
    world.searchObjects(Object.Category.SCENERY, volume, onFoundObject)
end

-- example: find object types near player unit (50m)
scanSceneryObjectTypes(Unit.getByName("Rotary-1-1"):getPoint(), 50)
