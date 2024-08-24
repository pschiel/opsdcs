-- "BASE_SENSOR_RIGHT_GEAR_DOWN",
-- "BASE_SENSOR_RIGHT_GEAR_UP",
-- "BASE_SENSOR_LEFT_GEAR_DOWN",
-- "BASE_SENSOR_LEFT_GEAR_UP",
-- "BASE_SENSOR_WOW_LEFT_GEAR",
-- "BASE_SENSOR_WOW_NOSE_GEAR",
-- "BASE_SENSOR_WOW_RIGHT_GEAR",
-- BASE_SENSOR_RADALT

local function twowheel()

    

    timer.scheduleFunction(twowheel, 0, timer.getTime() + 0.1)
end

timer.scheduleFunction(twowheel, 0, timer.getTime() + 0.1)