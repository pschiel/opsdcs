OpsdcsCrew["SpitfireLFMkIX"] = {
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
