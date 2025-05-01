-- creates waypoints for a carrier to navigate to a target point

-- current carrier position
local ship = Unit.getByName("Naval-1-1")
local p_ship = ship:getPoint()

-- target point 
local target = trigger.misc.getZone("wp1")
local p_target = target.point

--- returns water depth at a given point
--- @param point vec3 @point to check depth at
--- @return number @seabed depth in m
local function getDepthAt(point)
    local height, depth = land.getSurfaceHeightWithSeabed({ x = point.x, y = point.z })
    return depth
end

mid = 0
local function addMark(point)
    mid = mid + 1
    trigger.action.markToAll(mid, "wp" .. mid , { x = point.x, z = point.z })
end

addMark(p_ship)
addMark(p_target)

-- @TODO
