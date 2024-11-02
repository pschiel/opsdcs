OpsdcsCrew["OH-6A"] = {
    options = {
        showHighlights = true,
        playSounds = false,
    },
    procedures = {
        {
            name = "Cold Start",
            start_state = "coldstart",
        },
    },
    states = {
        -- Cold Start
        ["coldstart"] = {
            text = "Coldstart",
            conditions = {
            -- Set battery switch to BATT
            -- Push FUEL VALVE to OPEN
            -- Press Governor down for 7 sec
            -- Press Starter Button
            -- wait for N1 12-15%
            },
            next_state = "coldstart-complete",
        },
        ["coldstart-complete"] = {
            text = "Cold start complete",
        },
    },
    args = {
    },
    excludeDebugArgs = {
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
