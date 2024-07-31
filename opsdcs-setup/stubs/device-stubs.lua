---------------------------------------------------------------------------
--- DEVICE ENV
--- used by device_init.lua, devices, clickabledata.lua
---------------------------------------------------------------------------

--- @type table
package = {}

--- @param module string
function require(module) end

--- @type lfs
lfs = {}

--- @type io
io = {}

--- @type os
os = {}

------------------------------------------------------------------------------
--- functions
------------------------------------------------------------------------------

function CreateAlternateChannels() end

--- Returns a device
--- @param id number
--- @return Device
function GetDevice(id) end

function GetRadioChannels() end

--- Returns the current device
--- @return Device
function GetSelf() end

function LinearTodB() end
function MakeFont() end
function MakeMaterial() end
function SetGlobalCommand() end
function UTF8_strlen() end
function UTF8_substring() end

function create_sound() end
function create_sound_host() end
function dispatch_action() end
function do_mission_file() end
function find_viewport() end
function geo_to_lo_coords() end
function get_UIMainView() end
function get_Viewports() end
function get_absolute_model_time() end
function get_aircraft_draw_argument_value() end
function get_aircraft_mission_data() end
function get_aircraft_property() end
function get_aircraft_property_or_nil() end
function get_aircraft_type() end

--- Returns sensor base data
--- @return BaseData
function get_base_data() return end

function get_clickable_element_reference() end
function get_cockpit_draw_argument_value() end
function get_dcs_plugin_path() end
function get_input_devices() end
function get_mission_route() end
function get_model_time() end
function get_multimonitor_preset_name() end
function get_non_sim_random_evenly() end
function get_option_value() end

--- Returns param handle
--- @param param string
--- @return ParamHandle
function get_param_handle(param) end

function get_player_crew_index() end
function get_plugin_option() end
function get_plugin_option_value() end
function get_random_evenly() end
function get_random_orderly() end
function get_terrain_related_data() end
function list_cockpit_params() end
function list_indication() end
function lo_to_geo_coords() end
function load_mission_file() end
function mount_vfs_model_path() end
function mount_vfs_path_to_mount_point() end
function mount_vfs_texture_archives() end
function mount_vfs_texture_path() end
function print_message_to_user() end
function save_to_mission() end
function set_aircraft_draw_argument_value(argument, value) end
function set_crew_member_seat_adjustment() end
function show_param_handles_list() end
function switch_labels_off() end
function track_is_reading() end
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

function c_argument_in_range(argument,  min, max, plugin) end
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
--- @field SetCommand fun(self:Device, command, value)
--- @field get_argument_value fun(self:Device, argument)
--- @field get_light_reference fun(self:Device)
--- @field listen_command fun(self:Device, command)
--- @field performClickableAction fun(self:Device, command, value)
--- @field set_argument_value fun(self:Device, argument, value)
--- @field update_arguments fun(self:Device)

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
