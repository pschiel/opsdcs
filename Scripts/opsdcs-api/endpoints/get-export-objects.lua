return function()
    local response = Export.LoGetWorldObjects()
    return OpsdcsApi:response200(response)
end
