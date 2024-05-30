return function()
    local result = {}
    for _, static in pairs(OpsdcsApi.staticObjectsByName) do
        result[tostring(static.unitId)] = static
    end
    return 200, result
end
