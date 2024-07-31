---------------------------------------------------------------------------
--- PLUGIN ENV
--- used by entry.lua in plugins
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
--- @param data AircraftData
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
--- @param fm table @optional flight model. optional_fm = { mod_of_fm_origin, dll_with_fm }. if nil, then SFM is used
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

---------------------------------------------------------------------------
--- Aircraft data
---------------------------------------------------------------------------

--- @class AircraftData
--- @description Aircraft data table
--- @field string Name
--- @field string DisplayName
--- @field string Picture
--- @field number Rate @rewardpoint in mp
--- @field string Shape
--- @field string WorldID
--- @field table ViewSettings
--- @field table Countries
--- @field boolean HumanCockpit
--- @field string HumanCockpitPath

--- @field table net_animation

--- @field table shape_table_data
--- @field table CanopyGeometry @from makeAirplaneCanopyGeometry()

--- @field string mapclasskey
--- @field tables attribute
--- @field table Categories

--- @field string sounderName

-- general characteristics
--- @field boolean singleInFlight
--- @field number length
--- @field number height
--- @field number wing_area
--- @field number wing_span
--- @field table wing_tip_pos
--- @field number RCS
--- @field boolean has_speedbrake
--- @field number stores_number
--- @field number tanker_type
--- @field boolean is_tanker
--- @field number refueling_points_count
--- @field table refueling_points
--- @field table crew_members
--- @field table mechanimations
--- @field string EmptyWeight
--- @field string MaxFuelWeight
--- @field string MaxHeight
--- @field string MaxSpeed
--- @field string MaxTakeOffWeight
--- @field string WingSpan

-- weight & fuel characteristics
--- @field number M_empty
--- @field number M_nominal
--- @field number M_max
--- @field number M_fuel_max
--- @field number H_max
--- @field number CAS_min
--- @field number average_fuel_consumption

-- AI flight parameters
--- @field number V_opt
--- @field number V_take_off
--- @field number V_land
--- @field number V_max_sea_level
--- @field number V_max_h
--- @field number Vy_max @maximal climb rate
--- @field number Mach_max
--- @field number Ny_min @minimal safe acceleration
--- @field number Ny_max @maximal safe acceleration
--- @field number Ny_max_e
--- @field number Ny_max_e
--- @field number AOA_take_off
--- @field number bank_angle_max
--- @field number flaps_maneuver
--- @field number range @operational range

-- suspension characteristics
--- @field boolean has_differential_stabilizer
--- @field number tand_gear_max
--- @field table nose_gear_pos
--- @field number nose_gear_wheel_diameter
--- @field table main_gear_pos
--- @field number main_gear_wheel_diameter

-- engine characteristics
--- @field boolean has_afteburner
--- @field number thrust_sum_max
--- @field number thrust_sum_ab
--- @field number engines_count
--- @field number IR_emission_coeff
--- @field number IR_emission_coeff_ab
--- @field table engines_nozzles

-- sensor characteristics
--- @field boolean radar_can_see_ground
--- @field number detection_range_max
--- @field table Sensors

-- radio characteristics
--- @field boolean TACAN
--- @field table HumanRadio
--- @field table panelRadio

-- ECM characteristics
--- @field table passivCounterm
--- @field table Countermeasures
--- @field table passivCounterm
--- @field table chaff_flare_dispenser

-- armament characteristics
--- @field table Pylons
--- @field table Tasks
--- @field table DefaultTask @from aircraft_task()

-- damage
--- @field table fires_pos
--- @field table Damage @from verbose_to_dmg_properties()
--- @field table DamageParts

-- flight model characteristics
--- @field table SFM_Data

-- extnernal lights
--- @field table lights_data

-- land & takeoff
--- @field table LandRWCategories
--- @field table TakeOffRWCategories

-- failures
--- @field table Failures

-- additional properties
--- @field table AddPropAircraft

-- guns
--- @field table Guns
--- @field number ammo_type_default
--- @field table ammo_type

---------------------------------------------------------------------------
--- Radio commands data (comm.lua)
---------------------------------------------------------------------------

--- @class data
--- @field VoIP boolean
--- @field base table
--- @field communicators table
--- @field curCommunicatorId number
--- @field customUnitProperties table @'AddPropAircraft' in the module entry description (lua) -> wsInitData.AddPropList (cpp) -> RadioCommandDialogsPanel.data.customUnitProperties (lua). table["PropertyName"] = {value = 0, str_value = ""}
--- @field highlighting boolean
--- @field initialized boolean
--- @field menuEmbarkToTransport table @Misson command menu
--- @field menuOther table @Misson command menu
--- @field menus table @menu
--- @field msgHandlers table @Message handlers converts messages into internal events and passes them into RadioCommandDialogsPanel.onEvent()
--- @field pComm table
--- @field pUnit table @Player unit
--- @field radioAutoTune boolean
--- @field recepientInfo boolean
--- @field rootItem table
--- @field showingOnlyPresentRecepients boolean
--- @field worldEventHandlers table @World event handles handle world events and passes them into RadioCommandDialogsPanel.onEvent()
--- @type data
data = {}
