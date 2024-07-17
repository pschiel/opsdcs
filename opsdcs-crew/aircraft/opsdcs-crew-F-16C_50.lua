OpsdcsCrew["F-16C_50"] = {
    procedures = {
        ["coldstart"] = {
            text = "Cold Start",
            cond = {},
            start_state = "coldstart-radio-check",
        },
        ["shutdown"] = {
            text = "Engine Shutdown",
            cond = {},
            start_state = "shutdown-start",
        },
        ["hotpit"] = {
            text = "Hot Pit",
            condition = function(self) return true end,
            start_state = "hotpit1",
        }
    },
    states = {
        ["coldstart-setup-radio"] = {
            text = "Cold Start - Before Engine Start",
            -- auto chocks here
            conditions = {
                { text = "Set up lights (ANTI COLL, rest as needed)", cond = { } },
                { text = "MAIN PWR to BATT", cond = { } },
                { text = "Check FLCS RLY light on", cond = { } },
                { text = "Set FCLS PWR TEST switch to TEST and hold", cond = { } },
                { text = "Check lights: FLCS PMG, MAIN GEN, STBY, TO FLCS", cond = { } },
                { text = "Verify FLCS PWR A, B, C, D are on", cond = { } },
                { text = "Release FCLS PWR TEST switch", cond = { } },
                { text = "C&I to BACKUP", cond = { } },
                { text = "BACKUP UHF to BOTH", cond = { } },
                { text = "HOT MIC switch to HOT MIC", cond = { } },
            },
            next_state = "coldstart-check-systems-off",
        },
        ["coldstart-check-systems-off"] = {
            text = "Cold Start - Systems Power Off Check",
            conditions = {
                { text = "MAIN PWR to OFF", cond = { } },
                { text = "EPU to OFF", cond = { } },
                { text = "ENG FEED to NORM", cond = { } },
                { text = "IFF MASTER to OFF", cond = { } },
                { text = "ECM panel all OFF", cond = { } },
                { text = "CMDS panel all OFF", cond = { } },
                { text = "MASTER ARM to OFF", cond = { } },
                { text = "LASER ARM to OFF", cond = { } },
                { text = "SNSR PWR panel all OFF", cond = { } },
                { text = "AVIONICS panel all OFF", cond = { } },
                { text = "Oxygen SUPPLY to PBG", cond = { } },
            },
            next_state = "coldstart-throttle-parking-brake-check",
        },
        ["coldstart-throttle-parking-brake-check"] = {
            text = "Cold Start - Throttle and Parking Brake Check",
            conditions = {
                { text = "MAIN PWR to BATT", cond = { } },
                { text = "Set parking brake to UP", cond = { } },
                { text = "Canopy handle down", cond = { } },
                { text = "Move throttle full foward", cond = { } },
                { text = "Check for parking brake disengaging", cond = { } },
                { text = "Move throttle back to cutoff", cond = { } },
                { text = "Set parking brake to UP", cond = { } },
                { text = "Canopy handle up", cond = { } },
                { text = "MAIN PWR to MAIN PWR", cond = { } },
                { text = "Close canopy", cond = { } },
                { text = "Canopy handle down", cond = { } },
            },
            next_state = "coldstart-overview",
        },
        ["coldstart-overview"] = {
            text = "Cold Start - Overview\n\n[F10 menu or SPACE to continue]",
            -- actions? clearmenu? menu? hasmenu? (or just all?)
            conditions = {
                { text = "Radio Check", cond = { "state_done", "coldstart-radio-check" } },
                { text = "Engine Start", cond = { "state_done", "coldstart-engine-start" } },
                { text = "EPU test", cond = { "state_done", "coldstart-epu-test" } },
                { text = "SEC check", cond = { "state_done", "coldstart-sec-check" } },
                { text = "BIT test", cond = { "state_done", "coldstart-bit-test" } },
                { text = "Trim check", cond = { "state_done", "coldstart-trim-check" } },
                { text = "Big movements", cond = { "state_done", "coldstart-big-movements" } },
                { text = "Brake check", cond = { "state_done", "coldstart-brake-check" } },
                { text = "Clear off", cond = { "state_done", "coldstart-clear-off" } },
            },
            next_state = "coldstart-complete",
        },
        ["coldstart-radio-check"] = {
            text = "Cold Start - Radio Check",
            actions = {
                -- just the timing, make compatible with manual radio
                { voice = "player", sound = "chief do you hear me", duration = 2.0 },
                { voice = "chief", sound = "loud and clear sir how me", delay = 4.0, duration = 2.0 },
                { voice = "player", sound = "loud and clear", delay = 8.0, duration = 1.0, variants = 2 },
            },
            conditions = {
                --{ text = "Perform radio check", duration = 8.0 },
                --{ text = "Confirm radio check", duration = 9.0 },
            },
            next_state = "coldstart-overview",
        },
        ["coldstart-engine-start"] = {
            text = "Cold Start - Engine Start",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-epu-test"] = {
            text = "Cold Start - EPU Test",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-sec-check"] = {
            text = "Cold Start - SEC Check",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-bit-test"] = {
            text = "Cold Start - BIT Test",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-trim-check"] = {
            text = "Cold Start - Trim Check",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-big-movements"] = {
            text = "Cold Start - Big Movements",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-brake-check"] = {
            text = "Cold Start - Brake Check",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-clear-off"] = {
            text = "Cold Start - Clear Off",
            conditions = {},
            next_state = "coldstart-complete",
        },
        ["coldstart-complete"] = {
            text = "Cold Start - Complete",
            conditions = {},
        },

        ["shutdown-start"] = {
            text = "todo",
            conditions = {},
        },
        
        ["hotpit1"] = {
            text = "todo",
            conditions = {},
        },
    },
    args = {
        ["PTR-ANARC164-FREQMODE-416"] = 416, -- backup uhf mode
        ["PTR-ANARC164-FUNCTION-417"] = 417, -- backup uhf function
        ["PTR-AUDIO1-LVR-COMM1-430"] = 430, -- uhf pwr
        ["PTR-AUDIO1-LVR-COMM2-431"] = 431, -- vhf pwr
        ["PTR-AUDIO1-TMB-COMM1-434"] = 434, -- uhf mode
        ["PTR-AUDIO1-TMB-COMM2-435"] = 435, -- vhf mode
        ["PTR-AUDIO2-LVR-INTERCOM-440"] = 440, -- intercom
        ["PTR-AUDIO2-TMB-MODE-443"] = 443, -- hotmic
        ["PTR-ENGSTART-TMB-JETFUEL-447"] = 447, -- jfs
        ["PTR-ELEC-TMB-MPWR-510"] = 510, -- main pwr
        ["PTR-ELEC-BTN-CRES-511"] = 511, -- elec reset
        ["PTR-TESTCP-BTN-FIRE-575"]	= 575, -- fire+oheat test
        ["PTR-TESTCP-TMB-PROBE-578"] = 578, -- probe heat
        ["PTR-TESTCP-TMB-EPU-579"] = 579, -- epu test
        ["PTR-TESTCP-TMB-TEST-585"] = 585, -- flcs test
        ["PTR-ANTICE-TMB-ENG-710"] = 710, -- anti ice
    },
    params = {
        "BASE_SENSOR_RADALT",
        "BASE_SENSOR_CANOPY_POS",
        "BASE_SENSOR_CANOPY_STATE",
        "BASE_SENSOR_FUEL_TOTAL",
        "BASE_SENSOR_FLAPS_POS",
        "BASE_SENSOR_FLAPS_RETRACTED",
        "BASE_SENSOR_LEFT_ENGINE_RPM",
        "BASE_SENSOR_RUDDER_POS",
        "ExternalFM:HumanInfo:Lail",
        "ExternalFM:HumanInfo:Rail",
        "ExternalFM:HumanInfo:Lstab",
        "ExternalFM:HumanInfo:Rstab",
        "ExternalFM:HumanInfo:Rud",
    },
    indications = {
        [1] = {}
    },
    commands = {},
}
