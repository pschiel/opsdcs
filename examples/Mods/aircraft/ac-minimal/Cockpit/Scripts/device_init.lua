-- ccMainPanel
-- device id 0. used to set cockpit parameters, create gauges, needed for clickables
-- when defined, sounds_init.lua and clickabledata.lua get loaded
MainPanel = { "ccMainPanel", LockOn_Options.script_path .. "mainpanel_init.lua" }

-- creators[DEVICE_ID] = {
--   "NAME_OF_CONTROLLER_CLASS",
--   <"CONTROLLER_SCRIPT_FILE",>
--   <{devices.LINKED_DEVICE1, devices.LINKED_DEVICE2, ...},>
--   <"INPUT_COMMANDS_SCRIPT_FILE",>
--   <{{"NAME_OF_INDICATOR_CLASS", "INDICATOR_SCRIPT_FILE"}, ...}>
-- }
creators = {
    [1] = { "avLuaDevice", LockOn_Options.script_path .. "device1.lua" },
}

-- indicators[INDICATOR_ID] = {
--   "NAME_OF_INDICATOR_CLASS",
--   "INDICATOR_SCRIPT_FILE",
--   <devices.PARENT_DEVICE>,
--   <{"CONNECTOR1", "CONNECTOR2", "CONNECTOR3"}, -- initial geometry anchor, triple of connector names
--   <{
--      sx_l = 0,   -- center position correction in meters (forward, backward)
--      sy_l = 0,   -- center position correction in meters (up, down)
--      sz_l = 0.3, -- center position correction in meters (left, right)
--      sh   = 0,   -- half height correction
-- 	    sw   = 0,   -- half width correction
-- 	    rz_l = 0,   -- rotation corrections
-- 	    rx_l = 0,
-- 	    ry_l = 0
--   }>
-- }
indicators = {
    [1] = { "ccIndicator", LockOn_Options.script_path .. "indicator1.lua" },
    [2] = { "ccIndicator", LockOn_Options.script_path .. "indicator2.lua" },
}

-- geometry layout. unclear, everyone seems to set this to {}
layoutGeometry = {}

-- unclear. was true in the Chinook
UseDBGInfo = false

-- mount textures collections related to the cockpit module and avionics
mount_vfs_texture_archives(LockOn_Options.script_path .. "../Textures/Cockpit_CH-47F_Textures")
mount_vfs_model_path(LockOn_Options.script_path .. "../Shape")

-- local terrain_data = get_terrain_related_data("TAD_vfs_archives")
-- if terrain_data then
	-- mount_vfs_path_to_mount_point("/textures/tad/",terrain_data)
-- end

-- "support_for_cws" is required for FC avionics. no other attributes known.
attributes = {
	"support_for_cws",
}

--kneeboard_implementation = "ccKneeboard"
--dofile(LockOn_Options.common_script_path .. "KNEEBOARD/declare_kneeboard_device.lua")
