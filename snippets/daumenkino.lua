-- create jpgs with: ffmpeg.exe -i video.mp4 -r 25 frame_%04d.jpg
-- save sound seperately to ogg

local timeDelta = 1/25
local f = 1
local maxF = 520

local function schedule()
    local pathprefix = "D:/Recordings/render/opsdcs/r2gif/jpg/frame_"
    local path = pathprefix .. string.format("%04d", f) .. ".jpg"
    net.dostring_in('mission', 'a_out_picture("' .. path .. '", 1, false, 0, "1", "1", 100, "1")')
    f = f + 1
    if f > maxF then
        net.dostring_in('mission', 'a_out_picture_stop()')
        return
    end
    timer.scheduleFunction(schedule, nil, timer.getTime() + timeDelta)
end

local function cutscene()
    trigger.action.outSound('sounds/video.ogg', 0)
    timer.scheduleFunction(schedule, nil, timer.getTime() + timeDelta)
end

missionCommands.addCommand('cutscene', nil, cutscene)
