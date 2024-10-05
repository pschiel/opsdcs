--syria
local cy = 904215 -- vaziani
local cx = -319621
local n = 500 -- total number of units
local r = 20 -- radius

local aircraft = {
    [1] = {
        type = "Soldier M4",
        country = country.id.USA,
        category = Group.Category.GROUND,
        payload = {
            -- ["pylons"] = {
            --     [1] = { ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" },
            --     [3] = { ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" },
            --     [4] = { ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" },
            --     [5] = { ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" },
            --     [6] = { ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" },
            --     [7] = { ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" },
            --     [8] = { ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" },
            --     [9] = { ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" },
            --     [11] = { ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" },       
            -- },
            -- ["fuel"] = 6103,
            -- ["flare"] = 60,
            -- ["chaff"] = 120,
            -- ["gun"] = 100,
        }
    },
    [2] = {
        type = "Soldier M4",
        country = country.id.RUSSIA,
        category = Group.Category.GROUND,
        payload = {
            -- ["pylons"] = {
            --     [1] = { ["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}" },
            --     [2] = { ["CLSID"] = "LAU-115_2*LAU-127_AIM-120C" },
            --     [3] = { ["CLSID"] = "LAU-115_2*LAU-127_AIM-120C" },
            --     [4] = { ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" },
            --     [5] = { ["CLSID"] = "{FPU_8A_FUEL_TANK}" },
            --     [6] = { ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" },
            --     [7] = { ["CLSID"] = "LAU-115_2*LAU-127_AIM-120C" },
            --     [8] = { ["CLSID"] = "LAU-115_2*LAU-127_AIM-120C" },
            --     [9] = { ["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}" },
            -- },
            -- ["fuel"] = 4900,
            -- ["flare"] = 60,
            -- ["ammo_type"] = 1,
            -- ["chaff"] = 60,
            -- ["gun"] = 100,
        }
    }
}


trigger.action.outText("units: "..tostring(n)..", radius: "..r, 60)
for i=1,n do
    local x = cx + math.random(-r, r)
    local y = cy + math.random(-r, r)
    local idx = i % 2 + 1
    if idx == 2 then
        --y = y + 20000
    end
    local groupData = {
        ["modulation"] = 0,
        ["tasks"] = {},
        ["uncontrollable"] = false,
        ["task"] = "Ground Nothing",
        ["uncontrolled"] = true,
        ["taskSelected"] = true,
        ["route"] = {
            -- ["spans"] = {
            --     [1] = {
            --         [1] = {
            --             ["y"] = y,
            --             ["x"] = x,
            --         },
            --         [2] = {
            --             ["y"] = y,
            --             ["x"] = x+5000,
            --         },
            --     },
            --     [2] = {
            --         [1] = {
            --             ["y"] = y,
            --             ["x"] = x+5000,
            --         },
            --         [2] = {
            --             ["y"] = y,
            --             ["x"] = x+10000,
            --         },
            --     },
            -- },
            ["points"] = {
                -- [1] = {
                --     ["alt"] = 500,
                --     ["action"] = "Off Road", -- turning point
                --     ["alt_type"] = "BARO",
                --     ["speed"] = 150,
                --     ["task"] = {
                --         ["id"] = "ComboTask",
                --         ["params"] = {
                --             ["tasks"] = {
                --                 -- [1] = {
                --                 --     ["enabled"] = true,
                --                 --     ["key"] = "CAP",
                --                 --     ["id"] = "EngageTargets",
                --                 --     ["number"] = 1,
                --                 --     ["auto"] = true,
                --                 --     ["params"] = {
                --                 --         ["targetTypes"] = {
                --                 --             [1] = "Air",
                --                 --         },
                --                 --         ["priority"] = 0,
                --                 --     },
                --                 -- }
                --             }
                --         }
                --     },
                --     ["type"] = "Turning Point",
                --     ["ETA"] = 0,
                --     ["ETA_locked"] = true,
                --     ["y"] = y,
                --     ["x"] = x,
                --     ["speed_locked"] = true,
                --     ["formation_template"] = "",
                --     ["speed_locked"] = true,
                --     ["formation_template"] = "",
                -- },
                -- [2] = {
                --     ["alt"] = 500,
                --     ["action"] = "Off Road", -- turning point
                --     ["alt_type"] = "BARO",
                --     ["speed"] = 15,
                --     ["task"] = {
                --         ["id"] = "ComboTask",
                --         ["params"] = {
                --             ["tasks"] = {
                --                 -- [1] = {
                --                 --     ["enabled"] = true,
                --                 --     ["key"] = "CAP",
                --                 --     ["id"] = "EngageTargets",
                --                 --     ["number"] = 1,
                --                 --     ["auto"] = true,
                --                 --     ["params"] = {
                --                 --         ["targetTypes"] = {
                --                 --             [1] = "Air",
                --                 --         },
                --                 --         ["priority"] = 0,
                --                 --     },
                --                 -- }
                --             }
                --         }
                --     },
                --     ["type"] = "Turning Point",
                --     ["ETA"] = 0,
                --     ["ETA_locked"] = true,
                --     ["y"] = y,
                --     ["x"] = x+5000,
                --     ["speed_locked"] = true,
                --     ["formation_template"] = "",
                --     ["speed_locked"] = true,
                --     ["formation_template"] = "",
                -- },
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
                ["speed"] = 15,
                ["type"] = aircraft[idx].type,
                ["unitId"] = 2000+i,
                ["psi"] = 0,
                ["onboard_num"] = "010",
                ["y"] = y,
                ["x"] = x,
                ["name"] = "dp" .. tostring(i),
                ["payload"] = aircraft[idx].payload,
                ["heading"] = 0,
                ["callsign"] = {
                    [1] = 1,
                    [2] = 1,
                    ["name"] = "Enfield11",
                    [3] = 1,
                },
            },
        },
        ["y"] = y,
        ["x"] = x,
        ["name"] = "dg" .. tostring(i),
        ["communication"] = false,
        ["start_time"] = 0,
        ["frequency"] = 251,
    }
    trigger.action.outText("adding " .. tostring(i), 5)
    coalition.addGroup(aircraft[idx].country, aircraft[idx].category, groupData)
    local con = Group.getByName("dg" .. tostring(i)):getController()
    con:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.WEAPON_FREE)
end
