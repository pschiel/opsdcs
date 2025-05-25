-- opsdcs-crew - Virtual Crew (hook)
--
-- Auto-injects mission script into running missions.

--- basedir, where mission scripts are located (can be customized in dev loader)
OpsdcsCrewBasedir = OpsdcsCrewBasedir or (lfs.writedir():gsub("\\", "/") .. "Scripts/opsdcs-crew/")

--- options
OpsdcsCrewHook = {
    logging = true,
    --- mission name patterns for auto-injection
    --- see http://lua-users.org/wiki/PatternsTutorial
    autoInjectMissionPatterns = {
        ".*",
    }
}

--- log helper, writes to dcs.log
--- @param message string
function OpsdcsCrewHook:log(message, ...)
    if self.logging then
        log.info("[opsdcs-crew] " .. string.format(message, ...))
    end
end

--- mission load end callback, injects script into mission
function OpsdcsCrewHook:onMissionLoadEnd()
    local missionName = DCS.getMissionName()
    self:log("onMissionLoadEnd: %s", missionName)
    for _, pattern in ipairs(self.autoInjectMissionPatterns) do
        if string.match(missionName, pattern) then
            self:injectScript()
            break
        end
    end
end

--- inject script into MSE via mission env and a_do_script
function OpsdcsCrewHook:injectScript()
    self:log("Injecting opsdcs-crew-mission.lua into mission")
    local code = "a_do_script('"
        .. "OpsdcsCrewBasedir=[[" .. OpsdcsCrewBasedir .. "]];OpsdcsCrewInject=true;"
        .. "dofile(OpsdcsCrewBasedir..[[opsdcs-crew-mission.lua]])"
        .. "')"
    net.dostring_in("mission", code)
end

------------------------------------------------------------------------------

DCS.setUserCallbacks({
    onMissionLoadEnd = function() OpsdcsCrewHook:onMissionLoadEnd() end,
})

OpsdcsCrewHook:log("loaded, basedir: " .. OpsdcsCrewBasedir)
