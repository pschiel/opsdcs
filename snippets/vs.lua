local cy = 904215
local cx = -319621
local n = 100
local r = 10000
trigger.action.outText("units: "..tostring(n)..", radius: "..r, 60)
for i=1,n do
    local x = cx + math.random(-r, r)
    local y = cy + math.random(-r, r)
    local groupData = {
        ["modulation"] = 0,
        ["tasks"] = {},
        ["uncontrollable"] = false,
        ["task"] = "CAP",
        ["uncontrolled"] = true,
        ["taskSelected"] = true,
        ["route"] = {
            ["points"] = {
                [1] = {
                    ["alt"] = 5000,
                    ["action"] = "Turning Point",
                    ["alt_type"] = "BARO",
                    ["speed"] = 150,
                    ["task"] = {
                        ["id"] = "ComboTask",
                        ["params"] = { ["tasks"] = {
                            [1] = 
                            {
                                ["enabled"] = true,
                                ["key"] = "CAP",
                                ["id"] = "EngageTargets",
                                ["number"] = 1,
                                ["auto"] = true,
                                ["params"] = 
                                {
                                    ["targetTypes"] = 
                                    {
                                        [1] = "Air",
                                    }, -- end of ["targetTypes"]
                                    ["priority"] = 0,
                                }, -- end of ["params"]
                            }
                        } }
                    },
                    ["type"] = "Turning Point",
                    ["ETA"] = 0,
                    ["ETA_locked"] = true,
                    ["y"] = y,
                    ["x"] = x,
                    ["speed_locked"] = true,
                    ["formation_template"] = "",
                    ["speed_locked"] = true,
                    ["formation_template"] = "",
                },
            },
        },
        ["groupId"] = 2000+i,
        ["hidden"] = false,
        ["units"] = {
            [1] = {
                ["alt"] = 5000,
                ["hardpoint_racks"] = true,
                ["alt_type"] = "BARO",
                ["livery_id"] = "default",
                ["skill"] = "Excellent",
                ["ropeLength"] = 15,
                ["speed"] = 150,
                -- ["AddPropAircraft"] = {
                --     ["SoloFlight"] = false,
                --     ["ExhaustScreen"] = true,
                --     ["GunnersAISkill"] = 90,
                --     ["NetCrewControlPriority"] = 0,
                --     ["EngineResource"] = 90,
                -- },
                ["type"] = (i % 2 == 0) and "F-15C" or "FA-18C_hornet", -- F-15C
                ["unitId"] = 3000+i,
                ["psi"] = 0,
                ["onboard_num"] = "010",
                ["y"] = y,
                ["x"] = x,
                ["name"] = "dp" .. tostring(i),
                ["payload"] = 
                (i % 2 == 0) and 
                {
                    ["pylons"] = {
                        [1] = 
                        {
                            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
                        }, -- end of [1]
                        [3] = 
                        {
                            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
                        }, -- end of [3]
                        [4] = 
                        {
                            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
                        }, -- end of [4]
                        [5] = 
                        {
                            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
                        }, -- end of [5]
                        [6] = 
                        {
                            ["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
                        }, -- end of [6]
                        [7] = 
                        {
                            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
                        }, -- end of [7]
                        [8] = 
                        {
                            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
                        }, -- end of [8]
                        [9] = 
                        {
                            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
                        }, -- end of [9]
                        [11] = 
                        {
                            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
                        }, -- end of [11]
                    },
                    ["fuel"] = 6103,
                    ["flare"] = 60,
                    ["chaff"] = 120,
                }
                or
                {
                    ["pylons"] = {
                        [1] = 
                        {
                            ["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
                        }, -- end of [1]
                        [2] = 
                        {
                            ["CLSID"] = "LAU-115_2*LAU-127_AIM-120C",
                        }, -- end of [2]
                        [3] = 
                        {
                            ["CLSID"] = "LAU-115_2*LAU-127_AIM-120C",
                        }, -- end of [3]
                        [4] = 
                        {
                            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
                        }, -- end of [4]
                        [5] = 
                        {
                            ["CLSID"] = "{FPU_8A_FUEL_TANK}",
                        }, -- end of [5]
                        [6] = 
                        {
                            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
                        }, -- end of [6]
                        [7] = 
                        {
                            ["CLSID"] = "LAU-115_2*LAU-127_AIM-120C",
                        }, -- end of [7]
                        [8] = 
                        {
                            ["CLSID"] = "LAU-115_2*LAU-127_AIM-120C",
                        }, -- end of [8]
                        [9] = 
                        {
                            ["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
                        }, -- end of [9]
                    },
                    ["fuel"] = 4900,
                    ["flare"] = 60,
                    ["ammo_type"] = 1,
                    ["chaff"] = 60,
                    ["gun"] = 100,
                },
                ["heading"] = 0,
                ["callsign"] = {
                    [1] = 1,
                    [2] = 1,
                    ["name"] = "Enfield11",
                    [3] = 1,
                },
            },
        }, -- end of ["units"]
        ["y"] = 903920.83213211,
        ["x"] = -319332.82868534,
        ["name"] = "dg" .. tostring(i),
        ["communication"] = false,
        ["start_time"] = 0,
        ["frequency"] = 251,
    }
    trigger.action.outText("adding " .. tostring(i), 5)
    _G.dat = groupData
    if i % 2 == 0 then
        coalition.addGroup(country.id.USA, Group.Category.AIRPLANE, groupData)
    else
        coalition.addGroup(country.id.RUSSIA, Group.Category.AIRPLANE, groupData)
    end
    local con = Group.getByName("dg" .. tostring(i)):getController()
    con:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.WEAPON_FREE)
end

-- generic debug output for all events
local blue_kills = 0
local red_kills = 0
allEventsHandler = {
    onEvent = function(self, event)
        if self.eventNamesById == nil then
            self.eventNamesById = {}
            for key, value in pairs(world.event) do
                self.eventNamesById[value] = key
            end
        end
        local ini = event.initiator and event.initiator:getName() or "-"
        if event.id == world.event.S_EVENT_UNIT_LOST then
            if event.initiator and event.initiator.getCoalition then
                local targetCoalition = event.initiator:getCoalition()
                if targetCoalition == coalition.side.BLUE then
                    red_kills = red_kills + 1
                elseif targetCoalition == coalition.side.RED then
                    blue_kills = blue_kills + 1
                end
                trigger.action.outText("blue kills: " .. tostring(blue_kills) .. ", red kills: " .. tostring(red_kills), 10, true)
            end
        else
            --trigger.action.outText("event: " .. self.eventNamesById[event.id] .. " ini: " .. ini, 5)
        end
    end
}
world.addEventHandler(allEventsHandler)
