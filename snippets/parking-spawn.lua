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
                    ["speed"] = 0,
                    ["task"] = {
                        ["id"] = "ComboTask",
                        ["params"] = {
                            ["tasks"] = {},
                        },
                    },
                    ["type"] = AI.Task.WaypointType.TAKEOFF_PARKING,
                    ["ETA"] = 0,
                    ["ETA_locked"] = true,
                    ["y"] = parking.vTerminalPos.z,
                    ["x"] = parking.vTerminalPos.x,
                    ["speed_locked"] = true,
                    ["formation_template"] = "",
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
                ["onboard_num"] = "001",
                ["callsign"] = "101",
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
