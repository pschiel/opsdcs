return function()
    local response = {
        missionServerRunning = true,
        missionRunning = DCS.getCurrentMission() ~= nil,
    }
    return OpsdcsApi:response200(response)
end
