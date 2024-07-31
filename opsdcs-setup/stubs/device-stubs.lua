---------------------------------------------------------------------------
--- DEVICE ENV
--- used by device_init.lua, devices, clickabledata.lua
---------------------------------------------------------------------------

--- @type table
package = {}

--- @param module string
function require(module) end

------------------------------------------------------------------------------
--- Device functions
------------------------------------------------------------------------------

--- Returns base data
--- @return BaseData
function get_base_data() return end

--- @class BaseData
--- @description device base data
--- @field getAngleOfAttack fun():number Gets the current angle of attack
--- @field getAngleOfSlide fun():number Gets the current angle of slide
--- ...
