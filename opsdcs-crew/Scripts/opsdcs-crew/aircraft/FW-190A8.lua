-- todo: yes

OpsdcsCrew["FW-190A8"] = {
    procedures = {
        ["coldstart"] = {
            text = "Cold Start",
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
