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
    shortName = plugin_id,                             -- short name
    fileMenuName = _(plugin_id),                       -- localized file menu name
    update_id = "AC-MINIMAL",                          -- id used for updater
    developerName = "ops",                             -- your name
    version = "1.0.0",                                 -- version of plugin (often __DCS_VERSION__)
    state = "installed",                               -- "installed", "sale"
    info = _("minimal flyable aircraft mod"),          -- localized description
    binaries = {},                                     -- binary DLLs
    InputProfiles = {                                  -- input profiles
        ["AC Minimal"] = current_mod_path .. "/Input", -- ["profile name"] = "/path/to/profile"
    },
    Skins = {                                          -- skins (background)
        { name = _(plugin_id), dir = "Skins" },        -- name = "localized name", dir = "relative path"
    },
    Missions = {                                       -- missions
        { name = _(plugin_id), dir = "Missions" },     -- name = "localized name", dir = "relative path"
    },
    LogBook = {                                        -- log book
        { name = _(plugin_id), type = plugin_id },     -- { name = "localized name", type = "aircraft type" }
    },
    Options = {                                        -- options
        {
            name = _(plugin_id),                       -- localized name
            nameId = plugin_id,                        -- option name id (referenced by user_options in FM config)
            dir = "Options",                           -- relative path
            CLSID = "{AC-MINIMAL-OPTIONS}"             -- clsid
        }                                              --
    },
    preload_resources = {                              -- preload resources
        textures = {},
        models = {},
        fonts = {},
        explotions = {},
    }
}

-- start plugin declaration
declare_plugin(plugin_id, props)

-- mount the "Shapes" folder into model VFS
mount_vfs_model_path(current_mod_path .. "/Shapes")

-- mount the "Liveries" folder into liveries VFS
-- at least aircraft_id/default/description.lua is required for default livery
mount_vfs_liveries_path(current_mod_path .. "/Liveries")

-- add an (NPC) aircraft (contains shape/SFM/engine/crew/pylon/etc setup, stuff that AI needs)
local aircraft_id, aircraft_data = dofile(current_mod_path .. "/ac-minimal.lua")
add_aircraft(aircraft_data)

-- add view settings (cockpit position etc) and snap views to the aircraft
local views = dofile(current_mod_path .. "/views.lua")
make_view_settings(aircraft_id, views.ViewSettings, views.SnapViews)

-- make the aircraft flyable for a player
-- needs path to the cockpit scripts, FM data, and path to radio menu script
-- FM config exposes global variable (for usage via ed_fm_configure)
dofile(current_mod_path .. "/fm.lua")
make_flyable(aircraft_id, current_mod_path .. "/Cockpit/", MyFM, current_mod_path .. "/comm.lua")

-- finalize plugin declaration
plugin_done()
