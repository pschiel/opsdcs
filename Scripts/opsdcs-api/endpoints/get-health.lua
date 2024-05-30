return function()
    local result = {
        missionServerRunning = true,
        missionRunning = DCS.getCurrentMission() ~= nil,
    }
    return 200, result
end
