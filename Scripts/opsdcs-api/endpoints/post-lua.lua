return function(data)
    local result = nil
    if data.env == OpsdcsApi.env then
        result = loadstring(data.code)()
    else
        result = net.dostring_in(data.env, data.code)
    end
    return 200, result
end
