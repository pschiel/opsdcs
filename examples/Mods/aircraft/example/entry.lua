declare_plugin('example-aircraftmod', {
	installed = true,
	dirName = current_mod_path,
	displayName = 'example-aircraftmod',
	shortName = 'example-aircraftmod',
    fileMenuName = 'example-aircraftmod',
	version = '1.0.0',
	state = 'installed',
    developerName = 'ops',
	info = 'example-aircraftmod',
    encyclopedia_path = current_mod_path .. '/Encyclopedia',
    binaries = {},
    Skins = {
        {
            name = 'example-aircraftmod',
            dir = 'Skins/1'
        }
    },
    Missions = {
        {
            name = 'example-aircraftmod',
            dir = 'Missions'
        }
    },
    LogBook = {
        {
            name = 'example-aircraftmod',
            type = 'example-aircraftmod'
        }
    },
    InputProfiles = {
        ['example-aircraftmod'] = current_mod_path .. '/Input'
    },
    Options = {
        {
            name = 'example-aircraftmod',
            nameId = 'example-aircraftmod',
            dir = 'Options',
            CLSID = '{example-aircraftmod-options}'
        }
    }
})

mount_vfs_model_path(current_mod_path .. "/Shapes")
mount_vfs_model_path(current_mod_path .. "/Cockpit/Shapes")
mount_vfs_texture_path(current_mod_path .. "/Textures")
mount_vfs_texture_path(current_mod_path .. "/Cockpit/Textures")
mount_vfs_texture_path(current_mod_path .. "/Skins/1/ME")	-- for simulator loading window
mount_vfs_liveries_path(current_mod_path .. "/Liveries")
mount_vfs_sound_path(current_mod_path .. "/Sounds")
mount_vfs_animations_path(current_mod_path .. "/Animations")

local FM = nil
make_flyable('example-aircraftmod', current_mod_path .. '/Cockpit/Scripts/', FM, current_mod_path .. "/Scripts/comm.lua")

local ViewSettings, SnapViews = {}, {}
make_view_settings('example-aircraftmod', ViewSettings, SnapViews)

plugin_done()
