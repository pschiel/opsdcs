---------------------------------------------------------------------------
--- Example aircraft mod
---
--- see plugins-stubs.lua for available functions
---------------------------------------------------------------------------

local self_ID = 'example-aircraftmod'
local binaries = {}

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
    --encyclopedia_path = current_mod_path .. '/Encyclopedia',
    load_immediately = true,
    binaries = binaries,
    -- Skins = {
    --     {
    --         name = _(self_ID),
    --         dir = 'Skins/1'
    --     }
    -- },
    -- Missions = {
    --     {
    --         name = _(self_ID),
    --         dir = 'Missions'
    --     }
    -- },
    -- LogBook = {
    --     {
    --         name = _(self_ID),
    --         type = self_ID
    --     }
    -- },
    -- InputProfiles = {
    --     [self_ID] = current_mod_path .. '/Input'
    -- },
    -- Options = {
    --     {
    --         name = _(self_ID),
    --         nameId = self_ID,
    --         dir = 'Options',
    --         CLSID = '{' .. self_ID .. '-options}'
    --     }
    -- }
})

-- resource paths
-- mount_vfs_model_path(current_mod_path .. "/Shapes")
-- mount_vfs_model_path(current_mod_path .. "/Cockpit/Shapes")
-- mount_vfs_texture_path(current_mod_path .. "/Textures")
-- mount_vfs_texture_path(current_mod_path .. "/Cockpit/Textures")
-- mount_vfs_texture_path(current_mod_path .. "/Skins/1/ME")
-- mount_vfs_liveries_path(current_mod_path .. "/Liveries")
-- mount_vfs_sound_path(current_mod_path .. "/Sounds")
-- mount_vfs_animations_path(current_mod_path .. "/Animations")

-- aircraft data
dofile(current_mod_path .. "/" .. self_ID .. ".lua")

-- views
dofile(current_mod_path .. "/views.lua")
make_view_settings(self_ID, ViewSettings, SnapViews)

-- FM
local suspension = dofile(current_mod_path .. "/suspension.lua")
local FM = {
    -- modname and dll
    [1] = "F-15C", --self_ID, -- "F-15C"
    [2] = "F15", --"DLLName", -- "F15"
    user_options = self_ID,

    -- center of mass and inertia
    center_of_mass = { -0.172, -0.6, 0 },
	moment_of_inertia = { 38912, 254758, 223845, -705 }, -- Ix,Iy,Iz,Ixy

    -- suspension (gears)
    suspension = suspension,

    -- oxygen
    disable_built_in_oxygen_system	= true,

    -- view shake
    minor_shake_ampl = 0.21,
    major_shake_ampl = 0.5,

    -- debug
    debugLine = "{M}:%1.3f {KCAS}:%4.1f {KEAS}:%4.1f {KTAS}:%4.1f {IAS}:%4.1f {AoA}:%2.1f {ny}:%2.1f {nx}:%1.2f {AoS}:%2.1f {mass}:%2.1f {Fy}:%2.1f {Fx}:%2.1f {wx}:%.1f {wy}:%.1f {wz}:%.1f {Vy}:%2.1f {dPsi}:%2.1f",
}

-- make flyable
-- cockpit_path scripts load order
--  1) device_init.lua
--  2) mainpanel_init.lua
--- 3) all devices
--- 4) sounds_init.lua (in device_init env)
--- 5) clickabledata.lua (in device_init env env)
make_flyable(self_ID, current_mod_path .. '/Cockpit/Scripts/', FM, current_mod_path .. "/comm.lua")

plugin_done()
