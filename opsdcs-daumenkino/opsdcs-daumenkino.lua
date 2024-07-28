-- Daumenkino Videoplayer
--
-- DCS doesn't let us play videos, but we can show images real fast.
--
-- Preparing the video:
-- 1) Save your recording in seperate video and audo track, e.g. "blah.mp4" and "blah.ogg"
-- 2) Download ffmpeg (https://www.ffmpeg.org/download.html)
-- 3) Convert video into seperate images at desired framerate and size:
--    ffmpeg.exe -i blah.mp4 -vf "fps=12,scale=1920:-1" blah_%04d.jpg
--    (note: further compression, resize etc might be needed to reduce overall size)
--
-- Using in mission:
-- 1) Open the miz
-- 2) Create a "sounds" folder inside and copy the "blah.ogg" into it
-- 3) Create a "images" folder inside and copy all images "blah_0001.jpg", ... into it
-- 4) Load this script at mission start (DO_SCRIPT)
-- 5) To play it, use a DO_SCRIPT and call the daumenkino function:
--    Daumenkino:play("blah", 520, 12, true, "cutscene_done")
--    (this will play 520 frames at 12fps, using active pause, and setting the flag "cutscene_done" at the end)

Daumenkino = {}

--- Plays a video via Daumenkino tech
--- @param name string prefix of image filenames and audio file
--- @param frames number total number of frames (images)
--- @param fps number frames per second
--- @param pause boolean if true, sets active pause during playback
--- @param flagname string name of ME flag that will be set to true on playback end
function Daumenkino:play(name, frames, fps, pause, flagname)
    self.name, self.frames, self.fps, self.pause, self.flagname = name, frames, fps, pause, flagname
    self.currentFrame = 1
    self:loop()
end

--- Playback loop
function Daumenkino:loop()
    local modelTimeNextFrame = timer.getTime() + 1 / self.fps
    -- first frame: play audio and pause
    if self.currentFrame == 1 then
        trigger.action.outSound("sounds/" .. self.name .. ".ogg")
        if self.pause then net.dostring_in("mission", "a_set_command(816)") end
    end
    -- display current frame
    local filename = self.name .. "_" .. string.format("%04d", self.currentFrame) .. ".jpg"
    net.dostring_in("mission", 'a_out_picture("images/' .. filename .. '", 1, false, 0, "1", "1", 100, "1")')
    self.currentFrame = self.currentFrame + 1
    -- after last frame: clear picture and u npause
    if self.currentFrame > self.frames then
        net.dostring_in("mission", "a_out_picture_stop()")
        if self.pause then net.dostring_in("mission", "a_set_command(816)") end
        if self.flagname then trigger.action.setUserFlag(self.flagname, true) end
        return
    end
    timer.scheduleFunction(self.loop, self, modelTimeNextFrame)
end
