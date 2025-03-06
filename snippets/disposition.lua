local a = Unit.getByName("Aerial-1-1")
local u = Unit.getByName("Ground-2-1")

local p1 = a:getPoint()
local p2 = u:getPoint()

local r = Disposition.DriftRoute(p1, p2, coalition.side.BLUE)
trigger.action.outText("Route has " .. #r .. " points", 5)
for i, point in pairs(r) do
    trigger.action.outText("Point " .. i .. ": " .. point.x .. ", " .. point.z, 5)
    trigger.action.markToAll(i, "point" .. i , { x = point.x, y = point.z })
end
