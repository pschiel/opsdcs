---------------------------------------------------------------------------
--- PLUGIN state
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--- Declaring plugin
---------------------------------------------------------------------------

--- Declares a plugin and loads it into EDGE.
--- @param name string @The name of the plugin.
--- @param props PluginProperties @Plugin properties
function declare_plugin(name, props) return end

--- Sets a flag informing the engine of a finished plugin declaration.
function plugin_done() return end

---------------------------------------------------------------------------
--- Adding stuff
---------------------------------------------------------------------------

--- Adds an aircraft
--- @param data table
function add_aircraft(data) return end

--- Adds a launcher
--- @param ws table
--- @param data table
--- @return table @launcher
function add_launcher(ws, data) return end

--- ??
function add_navpoint() return end

--- ??
function add_plugin_systems() return end

--- Adds a surface unit
--- @param data table
function add_surface_unit(data) return end

--- ??
function add_unit_to_country() return end

--- ??
function declare_callbackME() return end

--- ??
function declare_gun_mount() return end

--- ??
function declare_loadout() return end

--- ??
function declare_sensor() return end

--- ??
function declare_service_life() return end

--- ??
function declare_weapon() return end

--- Makes a flyable object.
--- @param obj_name string @The name of the object.
--- @param cockpit_path string @The path to the cockpit script (optional).
--- @param fm table @optional flight model. optional_fm = { mod_of_fm_origin, dll_with_fm }
--- @param comm_path string @The path to the comm.lua script.
function make_flyable(obj_name, cockpit_path, fm, comm_path) return end

--- ??
function make_payload_rules_list() return end

--- ??
function make_view_settings() return end

---------------------------------------------------------------------------
--- Engine, FM
---------------------------------------------------------------------------

--- ??
function predefined_engine() return end

--- ??
function predefined_fm() return end

--- ??
function specialize_engine_parameters() return end

--- ??
function specialize_fm_parameters() return end

---------------------------------------------------------------------------
--- Resource paths
---------------------------------------------------------------------------

--- Loads a filepath to use for plugin animations with VFS.
--- @param path string The file path.
function mount_vfs_animations_path(path) return end

--- Loads a filepath to use for flyable plugin liveries with VFS.
--- @param path string The file path.
function mount_vfs_liveries_path(path) return end

--- Mounts a filepath to use for plugin EDM files with VFS.
--- @param path string The file path.
function mount_vfs_model_path(path) return end

--- Loads a filepath to use for plugin sounds with VFS.
--- @param path string The file path.
function mount_vfs_sound_path(path) return end

--- Mounts a filepath to use for plugin textures with VFS.
--- @param path string The file path.
function mount_vfs_texture_path(path) return end

---------------------------------------------------------------------------
--- Effects
---------------------------------------------------------------------------

--- ??
function fire_effect() return end

--- ??
function gatling_effect() return end

--- ??
function smoke_effect() return end

---------------------------------------------------------------------------
--- Warheads
---------------------------------------------------------------------------

--- ??
function antiship_penetrating_warhead() return end

--- ??
function cumulative_warhead() return end

--- ??
function directional_a2a_warhead() return end

--- ??
function enhanced_a2a_warhead() return end

--- ??
function penetrating_warhead() return end

--- ??
function predefined_warhead() return end

--- ??
function simple_aa_warhead() return end

--- ??
function simple_warhead() return end

---------------------------------------------------------------------------
--- ??
---------------------------------------------------------------------------

--- ??
function aircraft_task() return end

--- ??
function cluster_desc() return end

--- ??
function combine_cluster() return end

--- ??
function createSuspension() return end

--- ??
function get_bomb_munition() return end

--- ??
function get_predefined_aircraft_gunpod() return end

--- ??
function gun_mount() return end

--- ??
function lock_player_interaction() return end

--- ??
function makeAirplaneCanopyGeometry() return end

--- ??
function makeHelicopterCanopyGeometry() return end

--- ??
function make_aircraft_carrier_capable() return end

--- ??
function make_default_mech_animation() return end

--- ??
function predefined_fuze() return end

--- ??
function pylon() return end

--- ??
function set_manual_path() return end

--- ??
function specialize_fuze_parameters() return end

--- ??
function turn_on_waypoint_panel() return end

--- ??
function unlock_player_interaction() return end

--- ??
function verbose_to_dmg_properties() return end

--- ??
function verbose_to_failures_table() return end

---------------------------------------------------------------------------
--- GUI functions
---------------------------------------------------------------------------

--- ??
function Get_Combined_GUISettings_Preset() return end

--- ??
function Get_Fuze_GUISettings_Preset() return end

--- ??
function Get_LGU_GUISettings_Preset() return end

--- ??
function Get_RFGU_GUISettings_Preset() return end

---------------------------------------------------------------------------
--- Plugin properties
---------------------------------------------------------------------------

--- @class PluginProperties
--- @description Plugin properties
--- @field installed boolean @Can the player can interact with the plugin? (e.g. settings, mission editor)
--- @field dirName string @The name of the directory containing the plugin.
--- @field displayName string @The name of the plugin shown within UI elements. (exc. module viewer)
--- @field fileMenuName string @The name of the file containing the flyable declaration.
--- @field update_id string @The ID to check for in DCS updates.
--- @field state string @String representing plugin accessibility state. (“installed” or “uninstalled”)
--- @field info string @The description of the plugin, shown in the main menu.
--- @field encyclopedia_path string @File path pointing towards an Encyclopedia folder containing Plane/plugin_name.txt.
--- @field binaries table<string> @Strings representing names of binary executable files (.dll) to inject.
--- @field Skins PluginSkinsTable @Defines the path and representation of UI elements.
--- @field Missions PluginMissionsTable @Defines the path and UI representation for flyable missions.
--- @field LogBook PluginLogBookTable @Defines the path and UI representation for the pilot logbook.
--- @field InputProfiles PluginInputProfilesTable @Defines the path and UI representation for input profile bindings.
--- @field Options PluginOptionsTable @Option properties

--- @class PluginSkinsTable
--- @description Skins table
--- @field name string @The name of the plugin to show within most UI.
--- @field dir string @The folder path of elements used.

--- @class PluginMissionsTable
--- @description Missions table
--- @field name string @The name of the plugin to show within most UI.
--- @field dir string @The folder path of mission files used.
--- @field CLSID string @Customisable string text showing a class ID, e.g. {CLSID...CLSID}.

--- @class PluginLogBookTable
--- @description LogBook table
--- @field name string @The name of the plugin to show within most UI.
--- @field type string @The plugin type.

--- @class PluginInputProfilesTable

--- @class PluginOptionsTable
--- @description Option properties
--- @field name string @The name of the plugin to show within most UI.
--- @field nameId string @The ID of the plugin used for options.
--- @field dir string @The folder path of option settings used.
--- @field CLSID string @Class ID (any string)
