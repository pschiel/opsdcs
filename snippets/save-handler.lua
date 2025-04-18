-- run this on mission start

-- persistence handler example
-- return any data that's JSON serializable
local function myscriptHandler()
    return {
        bla = "blub"
    }
end

-- register a persistence handler
-- data will get saved in the mission under "persistence/myscript.json"
world.setPersistenceHandler("myscript", myscriptHandler)

-- load persistence data from "persistence/myscript.json"
local data = world.getPersistenceData("myscript")
