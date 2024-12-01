-- luadoc style recursive enumeration (WIP)

local function enumerate(tbl, name, maxLvl, lvl)
    if lvl == nil then lvl = 1 end
    local r = "--- @class " .. name .. "\n"
    local subtables = {}
    for k, v in pairs(tbl) do
        r = r .. "--- @field " .. k
        if type(v) == "function" then
            r = r .. " fun()"
        elseif type(v) == "table" then
            r = r .. " table"
            table.insert(subtables, k)
        else
            r = r .. " " .. type(v)
        end
        r = r .. "\n"
    end
    r = r .. "\n"
    if lvl >= maxLvl then
        return r
    end
    for _, k in ipairs(subtables) do
        if k ~= "_G" and k:sub(1, 2) ~= "__" then
            r = r .. enumerate(tbl[k], name .. "." .. k, maxLvl, lvl + 1)
        end
    end
    return r
end

return enumerate(_G, "_G", 2)
