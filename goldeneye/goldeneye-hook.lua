-- Goldeneye Hook

GoldeneyeBasedir = GoldeneyeBasedir or lfs.writedir() .. "Scripts/goldeneye/"

GoldeneyeHook = {
    logging = true,
    autoInjectMissionPatterns = {
        "^myMission$", -- exact match "myMission"
        "^recon", -- starts with "recon"
        "recon$", -- ends with "recon"
        "recon.*mission", -- contains "recon" followed by anthing, then "mission"
        --".*", -- all missions
        "cargocow"
    }
}

-- log helper
function GoldeneyeHook:log(message)
    if self.logging then log.info("[goldeneye] " .. message) end
end

-- mission loaded
function GoldeneyeHook:onMissionLoadEnd(a, b, c)
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
function GoldeneyeHook:injectScript()
    local code = 'a_do_script("'
        .. 'GoldeneyeBasedir=[[' .. GoldeneyeBasedir .. ']];'
        .. 'dofile(GoldeneyeBasedir..[[goldeneye-mission.lua]])'
        .. '")'
    net.dostring_in('mission', code)
end

------------------------------------------------------------------------------

DCS.setUserCallbacks({
    onMissionLoadEnd = function(a, b, c) GoldeneyeHook:onMissionLoadEnd(a, b, c) end,
})

GoldeneyeHook:log("loaded, basedir: " .. GoldeneyeBasedir)
