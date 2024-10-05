-- plugin entry point
--
-- this file is loaded once during DCS startup
-- for available functions in the environment used, see plugin-stubs.lua

-- the plugin ID, used by declare_plugin(), and in first argument in FM for make_flyable (FM[1])
local plugin_id = "ac-minimal by ops"

--- @type PluginProperties
local props = {
    installed = true,                                  -- if false that will be place holder, or advertising
    dirName = current_mod_path,                        -- path to plugin directory
    displayName = _(plugin_id),                        -- localized display name
    fileMenuName = _(plugin_id),                       -- localized file menu name
    developerName = "ops",                             -- your name
    version = "1.0.0",                                 -- version of plugin
    state = "installed",                               -- "installed", "sale"
    info = _("minimal flyable aircraft mod"),          -- localized description
    InputProfiles = {                                  -- list of input profiles
        ["AC Minimal"] = current_mod_path .. "/Input", -- ["profile name"] = "/path/to/profile"
    }
}

-- start plugin declaration
declare_plugin(plugin_id, props)

-- mount the "Shapes" folder into model VFS
-- this makes the *.lods and *.edm files inside available anywhere
mount_vfs_model_path(current_mod_path .. "/Shapes")

-- mount the "Liveries" folder into liveries VFS
-- at least aircraft_id/default/description.lua is required for default livery
mount_vfs_liveries_path(current_mod_path .. "/Liveries")

-- add an (NPC) aircraft (contains shape/SFM/engine/crew/plyon/etc setup, stuff that AI needs)
local aircraft_id, aircraft_data = dofile(current_mod_path .. "/ac-minimal.lua")
add_aircraft(aircraft_data)

-- add view settings (cockpit position etc) and snap views to the aircraft
local views = dofile(current_mod_path .. "/views.lua")
make_view_settings(aircraft_id, views.ViewSettings, views.SnapViews)

-- make the aircraft flyable for a player
-- needs path to the cockpit scripts, FM data, and path to radio menu script
local fm = dofile(current_mod_path .. "/fm.lua")
make_flyable(aircraft_id, current_mod_path .. "/Cockpit/", fm, current_mod_path .. "/comm.lua")

-- finalize plugin declaration
plugin_done()
