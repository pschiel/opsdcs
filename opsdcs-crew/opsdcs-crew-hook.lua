-- OpsdcsCrew - Virtual Crew (hook)

OpsdcsCrewBasedir = OpsdcsCrewBasedir or lfs.writedir() .. "Scripts/opsdcs-crew/"

OpsdcsCrewHook = {
    logging = true,
    autoInjectMissionPatterns = {
        ".*",
    }
}

-- log helper
function OpsdcsCrewHook:log(message)
    if self.logging then log.info("[opsdcs-crew] " .. message) end
end

-- mission loaded
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

-- inject mission script
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
