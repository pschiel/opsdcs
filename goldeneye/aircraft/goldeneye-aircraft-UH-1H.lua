Goldeneye.aircraft["UH-1H"] = {
    payloads = {
        ["1 GoPro taped on HUD"] = {
            {
                sensor = "GoPro",
                position = { x =  0, y =  0, z =  0 },
                orientation = { yaw = 0, pitch = 0, roll = 0 },
            },
        },
        ["2 GoPros fwd/back"] = {
            {
                sensor = "GoPro",
                position = { x =  0, y =  0, z =  0 },
                orientation = { yaw = 0, pitch = 0, roll = 0 },
            },
            {
                sensor = "GoPro",
                position = { x =  0, y =  0, z =  0 },
                orientation = { yaw = 180, pitch = 0, roll = 0 },
            },
        },
        ["1 GoPro taped on helmet"] = {
            {
                sensor = "GoPro",
                position = { x =  0, y =  0, z =  0 },
                handheld = true,
            },
        },
        ["GoPro with 20 FOV"] = {
            {
                sensor = "GoPro",
                position = { x =  0, y =  0, z =  0 },
                orientation = { yaw = 0, pitch = 0, roll = 0 },
                horizFOV = 20,
                vertFOV = 15,
            },
        },
    },
}
