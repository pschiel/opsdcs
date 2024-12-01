enableModules = {}

for k,v in pairs(plugins) do
    if v.state == "installed" then
        enableModules[v.id] = v.applied
    end
end

aircraftFlyableInPlugins = {}
aircraftsFlyableByPluginId = {}
pluginsById = {}
for k,module_ in pairs(plugins) do
    if module_.applied then
        for type,unit_setting in pairs(module_.various_unit_settings) do
            if unit_setting and unit_setting.HumanCockpit == true then 
                aircraftFlyableInPlugins[type] = aircraftFlyableInPlugins[type] or {}
                aircraftFlyableInPlugins[type] = module_.id
                aircraftsFlyableByPluginId[module_.id] = aircraftsFlyableByPluginId[module_.id] or {}
                table.insert(aircraftsFlyableByPluginId[module_.id],type)
            end
        end
        pluginsById[module_.id] = module_
    end
end

return aircraftFlyableInPlugins