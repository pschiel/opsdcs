local grp = {
    ["dynSpawnTemplate"] = false,
    ["modulation"] = 0,
    ["tasks"] = {},
    ["radioSet"] = false,
    ["task"] = "AFAC",
    ["uncontrolled"] = false,
    ["route"] = {
        ["points"] = {
            [1] = {
                ["alt"] = 21,
                ["action"] = "From Parking Area",
                ["alt_type"] = "BARO",
                ["speed"] = 41.666666666667,
                ["task"] = {
                    ["id"] = "ComboTask",
                    ["params"] = {
                        ["tasks"] = {
                            [1] = {
                                ["enabled"] = true,
                                ["auto"] = true,
                                ["id"] = "FAC",
                                ["number"] = 1,
                                ["params"] = {},
                            },
                            [2] = {
                                ["enabled"] = true,
                                ["auto"] = true,
                                ["id"] = "WrappedAction",
                                ["number"] = 2,
                                ["params"] = {
                                    ["action"] = {
                                        ["id"] = "EPLRS",
                                        ["params"] = {
                                            ["value"] = true,
                                            ["groupId"] = 2,
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
                ["type"] = "TakeOffParking",
                ["ETA"] = 0,
                ["ETA_locked"] = true,
                ["y"] = 462640.625,
                ["x"] = -164072.8125,
                ["speed_locked"] = true,
                ["formation_template"] = "",
                ["airdromeId"] = 18,
            },
        },
    },
    ["groupId"] = 1,
    ["hidden"] = false,
    ["units"] = {
        [1] = {
            ["alt"] = 21,
            ["hardpoint_racks"] = true,
            ["alt_type"] = "BARO",
            ["livery_id"] = "default",
            ["skill"] = "Player",
            ["parking"] = 43,
            ["speed"] = 41.666666666667,
            ["AddPropAircraft"] = {
                ["importDrawings"] = true,
                ["MMS removal"] = false,
                ["Remove doors"] = true,
                ["NetCrewControlPriority"] = 0,
                ["Rifles"] = true,
                ["PDU"] = false,
                ["ALQ144"] = false,
                ["Rapid Deployment Gear"] = false,
                ["tacNet"] = 1,
            },
            ["type"] = "OH58D",
            ["Radio"] = {},
            ["unitId"] = 1,
            ["psi"] = 0,
            ["onboard_num"] = "015",
            ["parking_id"] = "36",
            ["x"] = -164072.8125,
            ["name"] = "OH-58D",
            ["payload"] = {
                ["pylons"] = {
                    [1] = {
                        ["CLSID"] = "{M260_A_M151_B_M257}",
                    },
                    [5] = {
                        ["CLSID"] = "{M260_M274}",
                    },
                },
                ["fuel"] = 333.69,
                ["flare"] = 30,
                ["chaff"] = 0,
                ["gun"] = 0,
            },
            ["y"] = 462640.625,
            ["heading"] = 0,
            ["callsign"] = {
                [1] = 1,
                [2] = 1,
                ["name"] = "Anvil11",
                [3] = 1,
            },
        },
    },
    ["y"] = 462640.625,
    ["x"] = -164072.8125,
    ["name"] = "OH-58D",
    ["communication"] = true,
    ["start_time"] = 0,
    ["uncontrollable"] = false,
    ["frequency"] = 116,
}

return coalition.addGroup(country.id.USA, Group.Category.HELICOPTER, grp)
