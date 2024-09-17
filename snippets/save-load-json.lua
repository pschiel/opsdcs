--- saves a table to a json file
--- @param filename string @filename
--- @param data table @table to save
--- @return boolean @status: true if successful, false on error
function saveData(filename, data)
    local file, err = io.open(filename, "w+")
    if err then return false end
    file:write(net.lua2json(data))
    file:close()
    return true
end

--- loads data from a json file
--- @param filename string @filename
--- @return table|boolean @data loaded from file, false on error
function loadData(filename)
    local file, err = io.open(filename, "r")
    if err then return false end
    local json = file:read("*a")
    file:close()
    return net.json2lua(json)
end

-- save example
local data = {
    name = "John",
    age = 30,
    what = { "ever", "blah" }
}
saveData(lfs.writedir() .. "test.json", data)

-- load example
local data = loadData(lfs.writedir() .. "test.json")
