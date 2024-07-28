--- Daumenkino Videoplayer

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
