-- usage: lua generate-headers.lua Keys Commands < /path/to/command_defs.lua > command_defs.h
--        lua generate-headers.lua devices Devices < /path/to/devices.lua > devices.h

if #arg < 1 then
    print("usage: lua generate-headers.lua [LUA_VAR] [HEADER_ENUM] < [LUA_FILE] > [HEADER_FILE]")
    os.exit(1)
end

local var = arg[1]

-- read input from stdin
local input = ""
while true do
    local line = io.read("*line")
    
    if not line then break end
    input = input .. line .. "\n"
end

-- execute lua
local chunk, err = loadstring(input)
if chunk then
    chunk()
else
    print("error loading lua code:", err)
end

-- output header
print("#pragma once")
print("enum " .. var)
print("{")

-- output sorted table
if _G[var] then
    local items = {}
    for k, v in pairs(_G[var]) do
        table.insert(items, {k = string.upper(var .. "_" .. k), v = v})
    end
    table.sort(items, function(a, b) return a.v < b.v end)
    for _, item in ipairs(items) do
        print(item.k .. " = " .. item.v .. ",")
    end
end
print("};")
