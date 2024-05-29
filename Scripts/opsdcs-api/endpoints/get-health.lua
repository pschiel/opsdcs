return function()
    return OpsdcsApi:response200({
        missionServerRunning = true,
        missionRunning = DCS.getCurrentMission() ~= nil,
    })
end
