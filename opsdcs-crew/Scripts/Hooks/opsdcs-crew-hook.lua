-- OpsdcsCrew - Virtual Crew (hook)
--
-- Auto-injects mission script into running missions.

OpsdcsCrewBasedir = OpsdcsCrewBasedir or (lfs.writedir():gsub("\\", "/") .. "Scripts/opsdcs-crew/")

OpsdcsCrewHook = {
    logging = true,
    autoInjectMissionPatterns = {
        -- see http://lua-users.org/wiki/PatternsTutorial
        ".*",
    }
}

--- log helper, writes to dcs.log
--- @param message string
function OpsdcsCrewHook:log(message)
    if self.logging then log.info("[opsdcs-crew] " .. message) end
end

--- mission load end callback, injects script into mission
function OpsdcsCrewHook:onMissionLoadEnd()
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
function OpsdcsCrewHook:injectScript()
    local code = 'a_do_script("'
        .. 'OpsdcsCrewBasedir=[[' .. OpsdcsCrewBasedir .. ']];OpsdcsCrewInject=true;'
        .. 'dofile(OpsdcsCrewBasedir..[[opsdcs-crew-mission.lua]])'
        .. '")'
    net.dostring_in('mission', code)
end

------------------------------------------------------------------------------

DCS.setUserCallbacks({
    onMissionLoadEnd = function() OpsdcsCrewHook:onMissionLoadEnd() end,
})

OpsdcsCrewHook:log("loaded, basedir: " .. OpsdcsCrewBasedir)
