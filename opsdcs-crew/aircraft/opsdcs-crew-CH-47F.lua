-- todo: add all stuff from manual, add voices + voice checklist logic

OpsdcsCrew["CH-47F"] = {
    procedures = {
        ["coldstart"] = {
            text = "Cold Start",
            start_state = "coldstart-before-apu-start",
        },
        ["taxi"] = {
            text = "Taxi",
            start_state = "taxi-before-taxi",
        },
        ["takeoff"] = {
            text = "Takeoff",
            start_state = "takeoff-before-takeoff",
        },
        ["landing"] = {
            text = "Landing",
            start_state = "landing-before-landing",
        },
        ["shutdown"] = {
            text = "Shutdown",
            start_state = "shutdown-after-landing-check",
        },
    },
    states = {
        -- Cold Start
        ["coldstart-before-apu-start"] = {
            text = "Coldstart - Before APU Start",
            conditions = {
                -- 
            },
            next_state = "coldstart-apu-start",
        },
        ["coldstart-apu-start"] = {
            text = "Before APU Start",
            conditions = {
                { text = "BATT to ON", cond = { "arg_eq", "?", 1 } }, -- CP
                -- CP TROOP WARN – ALARM & JUMP LT switches – As required; to warn that APU is about to start.
                -- Fireguard – Posted
                -- CP UTIL PRES Light – Verify on.
                { text = "APU to RUN, hold 5sec", cond = { "arg_eq", "?", 0 }, duration = 5, onlyOnce = true }, -- CP
                { text = "APU to START, hold 2sec", cond = { "arg_eq", "?", -1 } , duration = 5, onlyOnce = true }, -- CP
                { text = "Release APU to RUN", cond = { "arg_eq", "?", 0 } }, -- CP
                -- CP APU RDY Light – Verify on.
                -- CP UTIL PRES Light – Verify off within 30 seconds after APU RDY light illuminates.
                { text = "GEN APU to ON", cond = { "arg_eq", "?", 0 } }, -- CP
                -- PLT/CP WCA page – Verify the following: (N/I)
                --   #1 RECT OFF & l#2 RECT OFF messages – Verify not active.
                --   UTIL HYD PRES LO message – Verify not active within 30 seconds of APU RDY light illuminating
                --   APU ON advisory message – Verify active.
            },
            next_state = "coldstart-after-apu-start",
        },
        ["coldstart-after-apu-start"] = {
            text = "After APU Start",
            conditions = {
                { text = "Turn displays on", cond = { "ind_eq", "?", "?", "ind_eq", "?", "?", "ind_eq", "?", "?", "ind_eq", "?", "?" } }, -- PLT+CP
                { text = "Select INST page (NG)", cond = { "ind_eq", "?", "?" } }, -- WAGS version
                -- PLT+CP MFD 1 – VSD/FUEL (Half), MFD 2 – POWERTRAIN (Full), MFD 3 – POWERTRAIN (Full), MFD 4 – VSD/HSDH (Half), MFD 5 – WCA (Full)
                -- CP PWR XFER 1 & PWR XFER 2 switches – ON.
                -- CP WCA - Verify #1 HYD FLT CONTRl & #2 HYD FLT CONTRl messages are not active within 30 seconds. (N/I)
                -- PLT/CP LAMPS TEST button – Press and hold; check the following lights illuminate:
                --   GREENl & lREDl JUMP LT indicator lights (Overhead Switch Panel)
                --   UTIL PRES & APU RDY lights (Overhead Switch Panel)
                --   FIRE 1 PULL & FIRE 2 PULL Handle lights (Instrument Panel)
                --   CPLR light (Canted Console)
                --   FM1 VHF & VHF FM1 lights (Center Console)
                --   ARM light (Center Console)
                --   ICS, VOX, HOT MIC, & CALL lights (Control Audio Panels)
                -- PLT/CP LAMPS TEST button – Release; check the lights extinguish.
                -- PLT+CP Avionics and aircraft systems – Initialize and configure as appropriate for mission
            },
            next_state = "coldstart-before-engine-start",
        },
        ["coldstart-before-engine-start"] = {
            text = "Before Engine Start",
            conditions = {
                { text = "FADEC B/U PWR to ON", cond = { "arg_eq", "?", 0 } }, -- CP
                -- CP WCA page – Verify the following: (N/I)
                --   ENG1 FAIL & ENG1 FAIL messages are not active.
                --   ENG1 FADEC & ENG2 FADEC messages are not active.
                --   REV1 FAIL & REV2 FAIL messages are not active.
                { text = "Move ENG COND LEFT to GROUND", cond = { "arg_eq", "?", 0 } }, -- CP
                { text = "Move ENG COND RIGHT to GROUND", cond = { "arg_eq", "?", 0 } }, -- CP
                -- FE DECU fault code – Verify 88 is displayed.
                -- CP ENG COND levers – STOP.
                -- PLT Ignition Lock switch – ON. (N/I)
            },
            next_state = "coldstart-engine-start",
        },
        ["coldstart-engine-start"] = {
            text = "Engine Start",
            conditions = {
                -- FE Area around helicopter – Clear.
                -- PLT/CP Searchlights – As required.
                { text = "FUEL MAIN LEFT AFT to ON", cond = { "arg_eq", "?", 0 } }, -- CP
                { text = "FUEL MAIN LEFT FWD to ON", cond = { "arg_eq", "?", 0 } }, -- CP
                -- CP WCA – Verify ENG1 FUEL PRESS LO message is not active. (N/I)
                { text = "XFEED switch to OPEN", cond = { "arg_eq", "?", 0 } }, -- CP
                -- CP WCA – Verify ENG2 FUEL PRESS LO message is not active. (N/I)
                --   NOTE: Motor or start the second engine within 3 minutes of starting the first engine to avoid
                --   excessive wear on the NP bearings and seal. During normal operations, Engine 1 is started first, followed by Engine 2.
                { text = "Move ENG COND LEFT to GROUND", cond = { "arg_eq", "?", 0 } },
                { text = "FADEC ENG START to 1 and hold", cond = { "arg_eq", "?", 0 }, onlyOnce = true },
                { text = "Wait for NG1 > 12%", cond = { "arg_eq", "?", 12 } },
                { text = "Release FADEC ENG START", cond = { "arg_eq", "?", 0 } },
                { text = "Wait for NG1 > 55%", cond = { "arg_eq", "?", 55 } },
                { text = "FUEL MAIN RIGHT AFT to ON", cond = { "arg_eq", "?", 0 } },
                { text = "FUEL MAIN RIGHT FWD to ON", cond = { "arg_eq", "?", 0 }},
                { text = "Move ENG COND RIGHT to GROUND", cond = { "arg_eq", "?", 0 } },
                { text = "FADEC ENG START to 2 and hold", cond = { "arg_eq", "?", 0 }, onlyOnce = true },
                { text = "Wait for NG2 > 12%", cond = { "arg_eq", "?", 12 } },
                { text = "Release FADEC ENG START", cond = { "arg_eq", "?", 0 } },
                { text = "Wait for NG2 > 55%", cond = { "arg_eq", "?", 55 } },
                { text = "move ENG COND LEFT to FLIGHT", cond = { "arg_eq", "?", 0 } },
                { text = "move ENG COND RIGHT to FLIGHT", cond = { "arg_eq", "?", 0 } },
                { text = "Wait for NP1, NP2, NR green 100%", cond = { "arg_eq", "?", 100, "arg_eq", "?", 100, "arg_eq", "?", 100 } },
                { text = "GEN 1 to ON", cond = { "arg_eq", "?", 0 } },
                { text = "GEN 2 to ON", cond = { "arg_eq", "?", 0 } },
                { text = "GEN APU to OFF", cond = { "arg_eq", "?", 0 } },
                { text = "APU to OFF", cond = { "arg_eq", "?", 0 } },
            },
            next_state = "coldstart-fuel-pumps-crossfeed-check",
        },
        ["coldstart-fuel-pumps-crossfeed-check"] = {
            text = "Fuel Pumps Crossfeed Check",
            conditions = {
            },
            next_state = "coldstart-fadec-reversionary-system-check",
        },
        ["coldstart-fadec-reversionary-system-check"] = {
            text = "FADEC Reversionary System Check",
            conditions = {
            },
            next_state = "coldstart-complete",
        },
        ["coldstart-complete"] = {
            text = "Cold start complete",
        },

        -- Taxi
        ["taxi-before-taxi"] = {
            text = "Before Taxi",
        },
        ["taxi-ground-taxi"] = {
            text = "Taxi",
        },

        -- Takeoff
        ["takeoff-before-takeoff"] = {
            text = "Before Takeoff",
        },

        ["landing-before-landing"] = {
            text = "Before Landing",
        },

        -- Shutdown
        ["shutdown-after-landing-check"] = {
            text = "After Landing Check",
        },
        ["shutdown-aircraft-shutdown"] = {
            text = "Aircraft Shutdown",
        },
        ["shutdown-complete"] = {
            text = "Shutdown complete",
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
