return function()
    local response = {}
    for _, static in pairs(OpsdcsApi.staticObjectsByName) do
        response[tostring(static.unitId)] = static
    end
    return OpsdcsApi:response200(response)
end
