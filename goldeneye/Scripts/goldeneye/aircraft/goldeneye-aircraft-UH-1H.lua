Goldeneye.aircraft["UH-1H"] = {
    payloads = {
        ["1 Cam"] = {
            {
                sensor = "GoPro",
                position = { x = -10, y = 0, z = -5 },
                orientation = { yaw = 0, pitch = 0, roll = 0 },
            },
        },
        ["2 Cams"] = {
            {
                sensor = "GoPro",
                position = { x = 0, y = 0, z = 0 },
                orientation = { yaw = 0, pitch = 0, roll = 0 },
            },
            {
                sensor = "GoPro",
                position = { x = 0, y = 0, z = 0 },
                orientation = { yaw = 180, pitch = 0, roll = 0 },
            },
        },
    },
}
