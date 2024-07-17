-- todo: add all stuff from manual, add voices + voice checklist logic

OpsdcsCrew["CH-47F"] = {
    procedures = {
        ["coldstart"] = {
            text = "Cold Start (Wags Video)",
            start_state = "coldstart-start-engines",
        },
    },
    states = {
        -- Cold Start
        ["coldstart"] = {
            text = "Coldstart - Power and Fuel",
            conditions = {
                { text = "BATT to ON", cond = { "arg_eq", "?", 1 } },
                { text = "APU to RUN, hold 5sec", cond = { "arg_eq", "?", 0 }, duration = 5, onlyOnce = true },
                { text = "APU to START, hold 2sec", cond = { "arg_eq", "?", -1 } , duration = 5, onlyOnce = true },
                { text = "Release APU to RUN", cond = { "arg_eq", "?", 0 } },
                { text = "GEN APU to ON", cond = { "arg_eq", "?", 0 } },
                { text = "Turn displays on", cond = { "ind_eq", "?", "?", "ind_eq", "?", "?", "ind_eq", "?", "?", "ind_eq", "?", "?" } },
                { text = "Select INST page (NG)", cond = { "ind_eq", "?", "?" } },
                { text = "FUEL MAIN LEFT AFT to ON", cond = { "arg_eq", "?", 0 } },
                { text = "FUEL MAIN LEFT FWD to ON", cond = { "arg_eq", "?", 0 } },
                { text = "FUEL FEED to OPEN", cond = { "arg_eq", "?", 0 } },
                { text = "FADEC B/U PWR to ON", cond = { "arg_eq", "?", 0 } },
                { text = "Move ENG CONTROL LEFT to GROUND", cond = { "arg_eq", "?", 0 } },
            },
            next_state = "coldstart-start-engine",
        },
        ["coldstart-start-engines"] = {
            text = "Coldstart - Start Engines",
            conditions = {
                { text = "FADEC ENG START to 1 and hold", cond = { "arg_eq", "?", 0 }, onlyOnce = true },
                { text = "Wait for NG1 > 12%", cond = { "arg_eq", "?", 12 } },
                { text = "Release FADEC ENG START", cond = { "arg_eq", "?", 0 } },
                { text = "Wait for NG1 > 55%", cond = { "arg_eq", "?", 55 } },
                { text = "FUEL MAIN RIGHT AFT to ON", cond = { "arg_eq", "?", 0 } },
                { text = "FUEL MAIN RIGHT FWD to ON", cond = { "arg_eq", "?", 0 }},
                { text = "Move ENG CONTROL RIGHT to GROUND", cond = { "arg_eq", "?", 0 } },
                { text = "FADEC ENG START to 2 and hold", cond = { "arg_eq", "?", 0 }, onlyOnce = true },
                { text = "Wait for NG2 > 12%", cond = { "arg_eq", "?", 12 } },
                { text = "Release FADEC ENG START", cond = { "arg_eq", "?", 0 } },
                { text = "Wait for NG2 > 55%", cond = { "arg_eq", "?", 55 } },
                { text = "move ENG CONTROL LEFT to FLIGHT", cond = { "arg_eq", "?", 0 } },
                { text = "move ENG CONTROL RIGHT to FLIGHT", cond = { "arg_eq", "?", 0 } },
                { text = "Wait for NP1, NP2, NR green 100%", cond = { "arg_eq", "?", 100, "arg_eq", "?", 100, "arg_eq", "?", 100 } },
                { text = "GEN 1 to ON", cond = { "arg_eq", "?", 0 } },
                { text = "GEN 2 to ON", cond = { "arg_eq", "?", 0 } },
                { text = "GEN APU to OFF", cond = { "arg_eq", "?", 0 } },
                { text = "APU to OFF", cond = { "arg_eq", "?", 0 } },
            },
            next_state = "coldstart-complete",
        },
        ["coldstart-complete"] = {
            text = "Cold start complete",
        },
    },
    args = {
    },
    params = {
    },
    indications = {
        [1] = {
        },
        [2] = {
        },
        [3] = {
        }
    },
    commands = {},
}
