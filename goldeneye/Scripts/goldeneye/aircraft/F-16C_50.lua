Goldeneye.aircraft["F-16C_50"] = {
    allowedAmmoTypes = {
        ["weapons.shells.M61_20_PGU27"] = true,
        ["weapons.shells.M61_20_PGU28"] = true,
        ["weapons.bombs.BDU_33"] = true,
        ["weapons.missiles.AIM_120C"] = true,
        ["AIM_9X"] = true,
        ["weapons.bombs.Mk_82"] = true,
    },
    payloads = {
        {
            name = "Testsensor / Omera-33",
            mounts = {
                {
                    sensor = "Testsensor",
                    position = { x = 0, y = 0, z = 0 },
                    orientation = { yaw = 130, pitch = 45, roll = 0 },
                },
                {
                    sensor = "Omera-33",
                    position = { x = 0, y = 0, z = 0 },
                    orientation = { yaw = 0, pitch = 0, roll = 0 },
                },
            }
        },
        {
            name = "Omera-40",
            mounts = {
                {
                    sensor = "Omera-40",
                    position = { x = 0, y = 0, z = 0 },
                    orientation = { yaw = 0, pitch = 0, roll = 0 },
                },
            }
        },
        {
            name = "CA-200-LOROP",
            mounts = {
                {
                    sensor = "CA-200-LOROP",
                    position = { x = 0, y = 0, z = 0 },
                    orientation = { yaw = 0, pitch = 0, roll = 0 },
                },
            }
        },
        {
            name = "Presto-Pod",
            mounts = {
                {
                    sensor = "Presto-Pod",
                    position = { x = 0, y = 0, z = 0 },
                    orientation = { yaw = 0, pitch = 0, roll = 0 },
                },
            }
        },
    },
}
