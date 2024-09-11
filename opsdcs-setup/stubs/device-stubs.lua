---------------------------------------------------------------------------
--- DEVICE ENV
--- used by device_init/sounds_init/clickabledata, mainpanel_init, devices
---------------------------------------------------------------------------

--- @type lfs
lfs = {}

--- @type io
io = {}

--- @type os
os = {}

--- when set to true in device init, close lua state after initialization
need_to_be_closed = true

------------------------------------------------------------------------------
--- functions
------------------------------------------------------------------------------

--- Returns a device
--- @param id number
--- @return Device
function GetDevice(id) end

--- Returns the current device
--- @return Device
function GetSelf() end

--- Makes a font
--- @param font_data table @{used_DXUnicodeFontData = "font_dejavu_lgc_sans_22"}
--- @param rgba table @{0, 255, 0, 255}
--- @return table
function MakeFont(font_data, rgba) end

--- Makes a material
--- @param texture_path string @material name, path to texture (dds, tga)
--- @param rgba table @{0, 255, 0, 255}
--- @return table
function MakeMaterial(texture_path, rgba) end

--- ??
function SetGlobalCommand() end

--- ??
function UTF8_strlen() end

--- ??
function UTF8_substring() end

--- Creates a sound
--- @param sdef string @refers to sdef file, and sdef file content refers to sound file, see DCSWorld/Sounds/sdef/_example.sdef
--- @return table
function create_sound(sdef) end

--- Creates a sound host
--- @param name string
--- @param type string @"2D", "3D", "HEADPHONES"
--- @param x number
--- @param y number
--- @param z number
--- @return table
function create_sound_host(name, type, x, y, z) end

--- Triggers command with value. Similar to Device:performClickableAction() but doesn't move the switch
--- @param device_id number @or nil
--- @param command number
--- @param value number
function dispatch_action(device_id, command, value) end

--- ??
function do_mission_file() end

--- Finds viewport by name
--- @param name string
--- @return table
function find_viewport(name) end

--- Converts lat/lon to local coordinates
--- @param lat number
--- @param lon number
--- @return vec3
function geo_to_lo_coords(lat, lon) end

--- Returns UI main view
--- @return number, number, number, number, number @start_x, start_y, main_w, main_h, gui_scale
function get_UIMainView() end

--- Returns all viewports
--- @return table
function get_Viewports() end

--- Returns time of day in seconds (including fractional seconds)
--- @return number
function get_absolute_model_time() end

--- Returns aircraft draw argument value
--- @param arg number
--- @return number
function get_aircraft_draw_argument_value(arg) end

--- Returns aircraft mission data
--- @param key string @e.g. "Radio"
--- @return table
function get_aircraft_mission_data(key) end

--- Returns aircraft property
--- @param name string
--- @return any
function get_aircraft_property(name) end

--- Returns aircraft property or nil
--- @param name string
--- @return any
function get_aircraft_property_or_nil(name) end

--- Returns aircraft type
--- @return string
function get_aircraft_type() end

--- Returns sensor base data
--- @return BaseData
function get_base_data() return end

--- Returns clickable element reference
--- @param point_name string @see point name in clickabledata.lua, index of elements
--- @return table @functions: set_hint, update, hide
function get_clickable_element_reference(point_name) end

--- Returns cockpit draw argument value
--- @param arg number
--- @return number
function get_cockpit_draw_argument_value(arg) end

--- Returns path for plugin
--- @param name string @plugin name
--- @return string
function get_dcs_plugin_path(name) end

--- ??
function get_input_devices() end

--- Returns mission route
--- @return table @route (table of wps)
function get_mission_route() end

--- Returns time in seconds since mission launched
--- @return number
function get_model_time() end

--- Returns multi-monitor preset name
--- @return string
function get_multimonitor_preset_name() end

--- ??
function get_non_sim_random_evenly() end

--- Returns option value
--- @param option string @option name "difficulty.hideStick"
--- @param env string @"local"
--- @return any
function get_option_value(option, env) end

--- This is used to set a param handle, best described as a global variable. It is useful for setting animations in mainpanel.lua, getting information into indicators, and getting information between an EFM and lua if you have an EFM.
--- @param param string
--- @return ParamHandle
function get_param_handle(param) end

--- ??
function get_player_crew_index() end

--- ??
function get_plugin_option() end

--- Returns plugin option value
--- @param plugin string @plugin name
--- @param option string @option name
--- @param env string @"local"
function get_plugin_option_value(plugin, option, env) end

--- ??
function get_random_evenly() end

--- ??
function get_random_orderly() end

--- Returns terrain related data
--- @param file string @"beacons", "beaconsFile", "Airdromes", "name", "TAD_vfs_archives", "TAD_chart_map_set_file", "edterrainVersion", "KNEEBOARD"
--- @return table @terrain related data (display_name, radio={})
function get_terrain_related_data(file) end

--- Returns cockpit parameters
--- @return table
function list_cockpit_params() end

--- Returns list indication
--- @param device_id number
--- @return string @indication text
function list_indication(device_id) end

--- Converts local coordinates to lat/lon
--- @param pos vec3
--- @return number, number @lat, lon
function lo_to_geo_coords(pos) end

--- Loads mission (?) file
--- @param file string @filepath
--- @return function @chunk
function load_mission_file(file) end

--- Calls update() function within device with given time step
--- @param time_step number
function make_default_activity(time_step) end

--- Mounts a model path.
--- @param path string The path.
function mount_vfs_model_path(path) return end

--- Mounts a path to a mountpoint
--- @param mount_point string @e.g. "/textures/tad/"
--- @param data table @see get_terrain_related_data()
function mount_vfs_path_to_mount_point(mount_point, data) end

--- Mounts a texture archives path.
--- @param path string The directory path.
function mount_vfs_texture_archives(path) end

--- Mounts a texture path.
--- @param path string The path.
function mount_vfs_texture_path(path) return end

--- Prints a message on screen ingame
--- @param text string
function print_message_to_user(text) end

--- Saves mission (?) file
--- @param file string @filepath
--- @param content string @content
function save_to_mission(file, content) end

--- Sets aircraft draw argument value
--- @param argument number
--- @param value number
function set_aircraft_draw_argument_value(argument, value) end

--- ??
function set_crew_member_seat_adjustment() end

--- Shows param list
function show_param_handles_list() end

--- ??
function switch_labels_off() end

--- Checks if track file is reading
--- @return boolean
function track_is_reading() end

--- Checks if track file is writing
--- @return boolean
function track_is_writing() end

------------------------------------------------------------------------------
--- Cockpit actions
------------------------------------------------------------------------------

function a_cockpit_highlight(id, name, size, plugin) end
function a_cockpit_highlight_indication(id, indicator, name, size, plugin) end
function a_cockpit_highlight_position(id, x, y, z, dimX, dimY, dimZ) end
function a_cockpit_lock_player_seat(number) end
function a_cockpit_param_save_as(source, destination) end
function a_cockpit_perform_clickable_action(device, command, value, plugin) end
function a_cockpit_pop_actor() end
function a_cockpit_push_actor(number) end
function a_cockpit_remove_highlight(id) end
function a_cockpit_unlock_player_seat() end
function a_start_listen_command(command, flag, count, min, max, device) end
function a_start_listen_event(event, flag) end

------------------------------------------------------------------------------
--- Cockpit conditions
------------------------------------------------------------------------------

function c_argument_in_range(argument, min, max, plugin) end
function c_cockpit_highlight_visible(id) end
function c_cockpit_param_equal_to(param, value) end
function c_cockpit_param_in_range(param, min, max) end
function c_cockpit_param_is_equal_to_another(param1, param2) end
function c_indication_txt_equal_to(id, name, value) end
function c_start_wait_for_user(flagCont, flagBack) end
function c_stop_wait_for_user() end

------------------------------------------------------------------------------
--- Device class
------------------------------------------------------------------------------

--- @class Device
--- @description functions for devices (some devices have additional functions)
--- @field get_argument_value fun(self:Device, argument)
--- @field get_light_reference fun(self:Device)
--- @field listen_command fun(self:Device, command)
--- @field listen_event fun(self:Device, event) @"setup_HMS", "setup_NVG", "DisableTurboGear", "EnableTurboGear", "GroundPowerOn", "GroundPowerOff", "repair", "WeaponRearmFirstStep", "WeaponRearmComplete", "OnNewNetHelicopter", "initChaffFlarePayload", "switch_datalink", "OnNewNetPlane", "LinkNOPtoNet"
--- @field performClickableAction fun(self:Device, command, value) @used to perform clickable actions
--- @field set_argument_value fun(self:Device, argument, value)
--- @field update_arguments fun(self:Device)
--- weapon system
--- @field drop_chaff fun()
--- @field drop_flare fun()
--- @field emergency_jettison fun()
--- @field emergency_jettison_rack fun()
--- @field get_ECM_status fun()
--- @field get_chaff_count fun()
--- @field get_flare_count fun()
--- @field get_station_info fun()
--- @field get_target_range fun()
--- @field get_target_span fun()
--- @field launch_station fun(self:Device, station:number) @launch station (weapon system device)
--- @field select_station fun(self:Device, station:number) @select station (weapon system device)
--- @field set_ECM_status fun()
--- @field set_target_range fun()
--- @field set_target_span fun()

------------------------------------------------------------------------------
--- Param handle
------------------------------------------------------------------------------

--- @class ParamHandle
--- @field get fun(self:ParamHandle):number
--- @field set fun(self:ParamHandle, value:number)

------------------------------------------------------------------------------
--- Base data
------------------------------------------------------------------------------

--- @class BaseData
--- @description device base data
--- @field getAngleOfAttack fun():number Gets the current angle of attack
--- @field getAngleOfSlide fun():number Gets the current angle of slide
--- @field getBarometricAltitude fun()
--- @field getCanopyPos fun()
--- @field getCanopyState fun()
--- @field getEngineLeftFuelConsumption fun()
--- @field getEngineLeftRPM fun()
--- @field getEngineLeftTemperatureBeforeTurbine fun()
--- @field getEngineRightFuelConsumption fun()
--- @field getEngineRightRPM fun()
--- @field getEngineRightTemperatureBeforeTurbine fun()
--- @field getFlapsPos fun()
--- @field getFlapsRetracted fun()
--- @field getHeading fun()
--- @field getHelicopterCollective fun()
--- @field getHelicopterCorrection fun()
--- @field getHorizontalAcceleration fun()
--- @field getIndicatedAirSpeed fun()
--- @field getLandingGearHandlePos fun()
--- @field getLateralAcceleration fun()
--- @field getLeftMainLandingGearDown fun()
--- @field getLeftMainLandingGearUp fun()
--- @field getMachNumber fun()
--- @field getMagneticHeading fun()
--- @field getNoseLandingGearDown fun()
--- @field getNoseLandingGearUp fun()
--- @field getPitch fun()
--- @field getRadarAltitude fun()
--- @field getRateOfPitch fun()
--- @field getRateOfRoll fun()
--- @field getRateOfYaw fun()
--- @field getRightMainLandingGearDown fun()
--- @field getRightMainLandingGearUp fun()
--- @field getRoll fun()
--- @field getRudderPosition fun()
--- @field getSelfAirspeed fun()
--- @field getSelfCoordinates fun()
--- @field getSelfVelocity fun()
--- @field getSpeedBrakePos fun()
--- @field getStickPitchPosition fun()
--- @field getStickRollPosition fun()
--- @field getThrottleLeftPosition fun()
--- @field getThrottleRightPosition fun()
--- @field getTotalFuelWeight fun()
--- @field getTrueAirSpeed fun()
--- @field getVerticalAcceleration fun()
--- @field getVerticalVelocity fun()
--- @field getWOW_LeftMainLandingGear fun()
--- @field getWOW_NoseLandingGear fun()
--- @field getWOW_RightMainLandingGear fun()

------------------------------------------------------------------------------
--- Callbacks
------------------------------------------------------------------------------

--- function called by DCS on cockpit event (Device event, listen_event)
--- @param command number
--- @param value table
function CockpitEvent(command, value) end

--- function called by DCS when a command is triggered
function SetCommand(command, value) end

--- function called by DCS when damage is triggered (not working)
function SetDamage(command, value) end

--- function called by DCS when a failure is triggered (not working)
function SetFailure(command, value) end

--- function called by DCS post initialize
function post_initialize() end

--- update function (used with make_default_activity)
function update() end

------------------------------------------------------------------------------
--- Graphic elements
------------------------------------------------------------------------------

--- Adds an element
--- @param element Element
function Add(element) end

--- Creates a graphic element
--- @param type ElementType @element type
--- @return Element
function CreateElement(type) end

--- @class Element
--- @field name string @element name
--- @field parent_element string @parent element name
--- @field element_params string[] @list of shared element parameters
--- @field material string @material name
--- @field init_pos vec2 @initial position
--- @field init_rot vec3 @initial rotation (degrees)
--- @field width number @element width
--- @field h_clip_relation h_clip_relations @hardware clipping relations (pixel test/modify)
--- @field level number @element level (starting from 1)
--- @field collimated boolean @if true, element is collimated (HUD)
--- @field isvisible boolean @when false, not visible and rendered only to stencil buffer
--- @field z_enabled boolean
--- @field use_mipfilter boolean
--- @field additive_alpha boolean
--- @field change_opacity boolean
--- @field isdraw boolean
--- @field alignment ElementAlignment @alignment
--- @field primitivetype PrimitiveType @"triangles" or "lines"
--- @field vertices vec3[] @list of vertices
--- @field indices number[] @list of vertex indices (3 per triangle, 1 per point on line)
--- @field UseBackground boolean @if true, use background material
--- @field BackgroundMaterial string @background material name
--- @field value string @string value
--- @field stringdefs table @vertical_size, horizontal_size, horizontal_spacing, vertical_spacing
--- @field controllers ElementController[] @list of controllers
--- @field formats table @string format(s?), e.g. {"%s"} or {"%03.0f"}
--- @field tex_params table @center x, center y, scale x, scale y
--- @field blend_mode blend_mode @blend mode, from Scripts\Aircrafts\_Common\Cockpit\elements_defs.lua

--- @alias ElementType string
---| '"ceBoundingMeshBox"'
---| '"ceBoundingTexBox"'
---| '"ceCircle"'
---| '"ceHWLine"'
---| '"ceHWSector"'
---| '"ceHint"'
---| '"ceMeshPoly"'
---| '"ceSCircle"'
---| '"ceSMultiLine"'
---| '"ceSVarLenLine"'
---| '"ceSimple"'
---| '"ceSimpleLineObject"'
---| '"ceStringPoly"'
---| '"ceTMultiLine"'
---| '"ceTexPoly"'

--- @alias ElementAlignment string
---| '"LeftTop"'
---| '"CenterTop"'
---| '"RightTop"'
---| '"LeftCenter"'
---| '"CenterCenter"'
---| '"RightCenter"'
---| '"LeftBottom"'
---| '"CenterBottom"'
---| '"RightBottom"'

--- @alias PrimitiveType string
---| '"triangles"'
---| '"lines"'

--- @alias ElementControllerType string
---| '"opacity_using_parameter"'
---| '"text_using_parameter"'
---| '"parameter_in_range"'
---| '"move_left_right_using_parameter"'
---| '"move_up_down_using_parameter"'
---| '"rotate_using_parameter"'
---| '"screenspace_position"'

--- @class h_clip_relations
--- @field NULL number @0 - No clipping
--- @field COMPARE number @1 - Test of equality of element level value with the already existing level (set by previously rendered elements). If the level at the given pixel is the same as of the element, the pixel is drawn.
--- @field REWRITE_LEVEL number @2 - Rewrite the level at all pixels affected by the element render.
--- @field INCREASE_LEVEL number @3 - Increment the level (existing value + 1) at all pixels affected by the element render.
--- @field INCREASE_IF_LEVEL number @4 - Increment the level (existing value + 1) at all pixels affected by the element render, but only if the existing level at the pixel is the same as the level of the element.
--- @field DECREASE_LEVEL number @5 - Decrement the level (existing value - 1) at all pixels affected by the element render.
--- @field DECREASE_IF_LEVEL number @6 - Decrement the level (existing value - 1) at all pixels affected by the element render, but only ifthe existing level at the pixel is the same as the level of the element.
h_clip_relations = {}

--- @class blend_mode
--- @field IBM_NO_WRITECOLOR number @0 - element will be rendered only to stencil buffer
--- @field IBM_REGULAR number @1 - regular work with write mask set to RGBA
--- @field IBM_REGULAR_ADDITIVE_ALPHA number @2 - regular work with write mask set to RGBA , additive alpha for HUD
--- @field IBM_REGULAR_RGB_ONLY number @3 - regular work with write mask set to RGB (without alpha)
--- @field IBM_REGULAR_RGB_ONLY_ADDITIVE_ALPHA number @4 - regular work with write mask set to RGB (without alpha) , additive alpha for HUD
--- @field IBM_ONLY_ALPHA number @5 - write mask set only for alpha

--- @class ElementController
--- @field [1] ElementControllerType @controller type/name
--- @field [2] number @params index
--- @field [3] number? @formats index (text), min (range), x (move, position)
--- @field [4] number? @max (range), y (move, position)
