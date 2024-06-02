local me = nil

declare_plugin('examplePlugin',
{
	installed = true,
	dirName = current_mod_path,
    -- binaries = {'examplePlugin.dll'}

	displayName = 'examplePlugin',
	shortName = 'examplePlugin',
    fileMenuName = 'examplePlugin',

	version = '1.0.0',
	state = 'installed',
	developerName = 'ops',
	info = 'examplePlugin',

    Skins = {
        {
            name = 'examplePlugin',
            dir = 'Theme',
        }
    },

    Options = {
        {
            name = 'examplePlugin',
            nameId = 'examplePlugin',
            dir = 'Options',
            CLSID = '{examplePlugin}'
        }
    },

	callbacksME = {
		addMenu = {
			[1] = {
				mainMenu = 'generator',
				newMenu = 'henlo',
				pos = 8,
				callback = 'hellofunc',
			}
		},
		init = function(meAPI, dirName)
			me = meAPI -- available functions see me_managerModulesME.lua
		end,
		hellofunc = function() end
	},
	mainMenuME = true,
})

mount_vfs_model_path(current_mod_path .. ' /Shapes')
mount_vfs_texture_path(current_mod_path .. '/Textures')
mount_vfs_liveries_path(current_mod_path .. '/Liveries')
-- Sounds directory gets automatically mounted

plugin_done()
