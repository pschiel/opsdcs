-- opsdcs-cargo (hook)
--
-- Auto-injects mission script into running missions.

OpsdcsCargoBasedir = OpsdcsCargoBasedir or (lfs.writedir():gsub("\\", "/") .. "Scripts/opsdcs-cargo/")

OpsdcsCargoHook = {
    logging = true,
    autoInjectMissionPatterns = {
        -- see http://lua-users.org/wiki/PatternsTutorial
        ".*",
    }
}

--- log helper, writes to dcs.log
--- @param message string
function OpsdcsCargoHook:log(message)
    if self.logging then log.info("[opsdcs-cargo] " .. message) end
end

--- mission load end callback, injects script into mission
function OpsdcsCargoHook:onMissionLoadEnd()
    local missionName = DCS.getMissionName()
    self:log("onMissionLoadEnd: " .. missionName)
    for _, pattern in ipairs(self.autoInjectMissionPatterns) do
        if string.match(missionName, pattern) then
            self:log("Injecting script into mission: " .. missionName)
            self:injectScript()
            break
        end
    end
end

--- inject mission script into MSE
function OpsdcsCargoHook:injectScript()
    local code = 'a_do_script("'
        .. 'OpsdcsCargoBasedir=[[' .. OpsdcsCargoBasedir .. ']];OpsdcsCargoInject=true;'
        .. 'dofile(OpsdcsCargoBasedir..[[opsdcs-cargo-mission.lua]])'
        .. '")'
    net.dostring_in('mission', code)
end

------------------------------------------------------------------------------

DCS.setUserCallbacks({
    onMissionLoadEnd = function() OpsdcsCargoHook:onMissionLoadEnd() end,
})

OpsdcsCargoHook:log("loaded, basedir: " .. OpsdcsCargoBasedir)
