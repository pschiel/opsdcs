-- load "MyExample" global class
dofile(lfs.writedir() .. 'Scripts/example-export/MyExample.lua')

-- DCS will call these global callback functions on certain events
-- to add an own event handler, we need to chain call the original callback (see below)
local callbacks = {
    "LuaExportStart",
    "LuaExportBeforeNextFrame",
    "LuaExportOnHumanStart",
    "LuaExportOnHumanStop",
    "LuaExportAfterNextFrame",
    "LuaExportStop",
    --"LuaExportActivityNextEvent" -- this needs special handling due to return value
}

-- loop through all Export callbacks
for _, callback in ipairs(callbacks) do
    -- get current callback before overwriting, so we can chain call it
    local originalCallback = _G[callback]
    -- set new callback
    _G[callback] = function(...)
        -- call original callback first
        if originalCallback then
            originalCallback(...)
        end
        -- call our callback, if defined (with self as argument)
        if MyExample[callback] then
            MyExample[callback](MyExample, ...)
        end
    end
end
