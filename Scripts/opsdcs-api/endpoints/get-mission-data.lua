return function()
    local response = DCS.getCurrentMission()
    return OpsdcsApi:response200(response)
end