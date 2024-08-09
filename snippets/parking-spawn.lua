local function spawn(id, parking, abId)
    local groupData = {
        ["visible"] = false,
        ["taskSelected"] = true,
        ["route"] = {
            ["points"] = {
                [1] = {
                    ["alt"] = 18,
                    ["action"] = "From Parking Area",
                    ["alt_type"] = "BARO",
                    ["type"] = AI.Task.WaypointType.TAKEOFF_PARKING,
                    ["y"] = parking.vTerminalPos.z,
                    ["x"] = parking.vTerminalPos.x,
                    ["airdromeId"] = abId,
                },
            }
        },
        ["tasks"] = {},
        ["hidden"] = false,
        ["units"] ={
            [1] = {
                ["type"] = "Yak-40",
                ["unitId"] = 1,
                ["skill"] = "High",
                ["y"] = parking.vTerminalPos.z,
                ["x"] = parking.vTerminalPos.x,
                ["name"] = "Air Unit" .. id,
                ["alt"] = 18,
                ["speed"] = 0,
                ["alt_type"] = "BARO",
                ["coldAtStart"] = true,
                ["parking"] = 3,
                ["parking_id"] = parking.Term_Index,
            },
        },
        ["name"] = "Civilian Group " .. id,
        ["start_time"] = 0,
        ["task"] = "Nothing",
        ["coalition"] = "neutral",
        ["groupId"] = id,
    }
    coalition.addGroup(country.id.BELARUS, Group.Category.AIRPLANE, groupData)
end

local ab = Airbase.getByName("Kobuleti")
local parkings = ab:getParking()
for i = 1, #parkings do
    spawn(i, parkings[i], ab:getID())
end
