return function()
    for name, _ in pairs(OpsdcsApi.staticObjectsByName) do
        local luaCode = [[a_do_script('StaticObject.getByName("]] .. name .. [["):destroy()')]]
        net.dostring_in("mission", luaCode)
        OpsdcsApi.staticObjectsByName[name] = nil
    end
    return 200
end
