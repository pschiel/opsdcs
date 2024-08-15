---------------------------------------------------------------------------
--- Example tech mod
---
--- see plugins-stubs.lua for available functions
---------------------------------------------------------------------------

local self_ID = 'example-techmod'
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
    info = _('example techmod lorem ipsum'),
    encyclopedia_path = current_mod_path .. '/Encyclopedia',
    load_immediately = true,
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
mount_vfs_texture_path(current_mod_path .. "/Textures")
mount_vfs_liveries_path(current_mod_path .. "/Liveries")

-- ...

plugin_done()
