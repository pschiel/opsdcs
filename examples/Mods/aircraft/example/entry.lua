---------------------------------------------------------------------------
--- Example aircraft mod
---
--- see plugins-stubs.lua for available functions
---------------------------------------------------------------------------

local self_ID = 'example-aircraftmod'
local binaries = {}
local useSFM = true

declare_plugin(self_ID, {
	installed = true,
	dirName = current_mod_path,
	displayName = _(self_ID),
	shortName = _(self_ID),
    fileMenuName = _(self_ID),
	version = '1.0.0',
	state = 'installed',
    developerName = 'ops',
	info = _('example aircraftmod lorem ipsum'),
    encyclopedia_path = current_mod_path .. '/Encyclopedia',
    binaries = binaries,
    Skins = {
        {
            name = _(self_ID),
            dir = 'Skins/1'
        }
    },
    Missions = {
        {
            name = _(self_ID),
            dir = 'Missions'
        }
    },
    LogBook = {
        {
            name = _(self_ID),
            type = self_ID
        }
    },
    InputProfiles = {
        [self_ID] = current_mod_path .. '/Input'
    },
    Options = {
        {
            name = _(self_ID),
            nameId = self_ID,
            dir = 'Options',
            CLSID = '{' .. self_ID .. '-options}'
        }
    }
})

-- resource paths
mount_vfs_model_path(current_mod_path .. "/Shapes")
mount_vfs_model_path(current_mod_path .. "/Cockpit/Shapes")
mount_vfs_texture_path(current_mod_path .. "/Textures")
mount_vfs_texture_path(current_mod_path .. "/Cockpit/Textures")
mount_vfs_texture_path(current_mod_path .. "/Skins/1/ME")
mount_vfs_liveries_path(current_mod_path .. "/Liveries")
mount_vfs_sound_path(current_mod_path .. "/Sounds")
mount_vfs_animations_path(current_mod_path .. "/Animations")

-- aircraft data
dofile(current_mod_path .. "/" .. self_ID .. ".lua")

-- views
dofile(current_mod_path .. "/views.lua")
make_view_settings(self_ID, ViewSettings, SnapViews)

-- FM
local FM = nil
if not useSFM then
    dofile(current_mod_path .. "/suspension.lua")
    FM = {
        [1] = self_ID,
        [2] = "DLLName",
        center_of_mass = { 0, 0, 0 },
        moment_of_inertia = { 100, 1000, 1234, 100 },
        suspension = suspension
    }
end

-- make flyable
-- cockpit_path scripts load order
--  1) device_init.lua
--  2) mainpanel_init.lua
--- 3) all devices
--- 4) sounds_init.lua (in device_init env)
--- 5) clickabledata.lua (in device_init env env)
make_flyable(self_ID, current_mod_path .. '/Cockpit/Scripts/', FM, current_mod_path .. "/comm.lua")

plugin_done()
