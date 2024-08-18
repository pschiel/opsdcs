plugin_name = "ac-minimal by ops"
obj_name = "ac-minimal"

declare_plugin(plugin_name, {
    installed = true,
    dirName = current_mod_path,
    displayName = _(plugin_name),
    fileMenuName = _(plugin_name),
    developerName = _("ops"),
    version = "1.0.0",
    state = "installed",
    info = _("minimal flyable aircraft mod"),
    InputProfiles =	{
        [obj_name] = current_mod_path .. "/Input"
    }
})

mount_vfs_model_path(current_mod_path .. "/Shapes")
mount_vfs_liveries_path(current_mod_path .. "/Liveries")

dofile(current_mod_path .. "/add_aircraft.lua")
dofile(current_mod_path .. "/views.lua")

make_flyable(obj_name, current_mod_path .. "/Cockpit/", { "F-15C", "F15", old = 6 }, current_mod_path .. "/comm.lua")
make_view_settings(obj_name, ViewSettings, SnapViews)

plugin_done()
