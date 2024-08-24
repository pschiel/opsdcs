-- rotates two vectors a and b around their shared perpendicular axis by the specified angle
function applyRotation(a, b, angle)
    local cos_angle, sin_angle = math.cos(angle), math.sin(angle)
    local ax, ay, az, bx, by, bz = a.x, a.y, a.z, b.x, b.y, b.z
    a.x, a.y, a.z = cos_angle * ax + sin_angle * bx, cos_angle * ay + sin_angle * by, cos_angle * az + sin_angle * bz
    b.x, b.y, b.z = cos_angle * bx - sin_angle * ax, cos_angle * by - sin_angle * ay, cos_angle * bz - sin_angle * az
end

local results = {}

------------------------------------------------------------------------------------
-- Given: A = { p, x, y, z }
--  p is the position
--  x/y/z are forward/up/right orientation vectors

-- Translate point A by dx/dy/dz along its x/y/z vectors,
-- then rotate it by dyaw/dpitch/droll

function translateAndRotate(A, dx, dy, dz, dyaw, dpitch, droll)
    local B = {
        p = { x = A.p.x, y = A.p.y, z = A.p.z },
        x = { x = A.x.x, y = A.x.y, z = A.x.z },
        y = { x = A.y.x, y = A.y.y, z = A.y.z },
        z = { x = A.z.x, y = A.z.y, z = A.z.z },
    }

    -- apply dx/dy/dz translation along A x/y/z vectors
    B.p.x = B.p.x + dz * B.z.x + dy * B.y.x + dx * B.x.x
    B.p.y = B.p.y + dz * B.z.y + dy * B.y.y + dx * B.x.y
    B.p.z = B.p.z + dz * B.z.z + dy * B.y.z + dx * B.x.z

    -- apply dyaw/dpitch/droll rotation offsets
    applyRotation(B.x, B.z, math.rad(dyaw))
    applyRotation(B.x, B.y, math.rad(dpitch))
    applyRotation(B.z, B.y, math.rad(droll))

    return B
end

local A = {
    p = { x = -318108.83039674, y = 19.572104370004, z = 635801.55908286 },
    x = { x = 0.86122214794159, y = 0.036058124154806, z = 0.50694799423218 },
    y = { x = -0.031391944736242, y = 0.99934947490692, z = -0.017751786857843 },
    z = { x = -0.50725829601288, y = -0.0006258524954319, z = 0.86179387569427 }
}
local expected = {
    p = { x = -318116.06376304, y = 39.900899534828, z = 635832.12734334 },
    x = { x = 0.23245367852197, y = -0.47797699095517, z = 0.8470556861546 },
    y = { x = 0.886999151857, y = 0.46145887228713, z = 0.016977078561446 },
    z = { x = -0.39899600639595, y = 0.7473912351042, z = 0.53123302074844 }
}
local actual = translateAndRotate(A, 10, 20, 30, 45, -30, 60)
return { expected = expected, actual = actual }

------------------------------------------------------------------------------------
-- Given: A = { p, x, y, z }
-- Given: B = { p, x, y, z }

-- Calculate the relative position of B from A in dx/dy/dz
-- and the relative rotation of B from A in dyaw/dpitch/droll

function relativePositionAndRotation(A, B)
    -- get world space distances and project onto player local axes
    local wdx, wdy, wdz = B.p.x - A.p.x, B.p.y - A.p.y, B.p.z - A.p.z
    local dx = wdx * A.x.x + wdy * A.x.y + wdz * A.x.z
    local dy = wdx * A.y.x + wdy * A.y.y + wdz * A.y.z
    local dz = wdx * A.z.x + wdy * A.z.y + wdz * A.z.z

    -- calculate relative rotation in degrees
    local dyaw = -math.deg(math.atan2(A.x.z, A.x.x) - math.atan2(B.x.z, B.x.x))
    local dpitch = -math.deg(math.asin(A.x.y) - math.asin(B.x.y))
    local droll = -math.deg(math.atan2(A.z.y, A.y.y) - math.atan2(B.z.y, B.y.y))
    
    return { dx, dy, dz, dyaw, dpitch, droll }
end

local A = {
    p = { x = -318108.83039674, y = 19.572104370004, z = 635801.55908286 },
    x = { x = 0.86122214794159, y = 0.036058124154806, z = 0.50694799423218 },
    y = { x = -0.031391944736242, y = 0.99934947490692, z = -0.017751786857843 },
    z = { x = -0.50725829601288, y = -0.0006258524954319, z = 0.86179387569427 }
}
local B  = {
    p = { x = -318116.06376304, y = 39.900899534828, z = 635832.12734334 },
    x = { x = 0.23245367852197, y = -0.47797699095517, z = 0.8470556861546 },
    y = { x = 0.886999151857, y = 0.46145887228713, z = 0.016977078561446 },
    z = { x = -0.39899600639595, y = 0.7473912351042, z = 0.53123302074844 }
}
local expected = { 10, 20, 30, 45, -30, 60 }
local actual = relativePositionAndRotation(A, B)
return { expected = expected, actual = actual }
