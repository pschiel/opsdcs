local views = {

    ViewSettings = {
        Cockpit = {
            {
                CockpitLocalPoint = { 6.21, 1.204, 0 },
                CameraViewAngleLimits = { 20, 140 },
                CameraAngleRestriction = { false, 90, 0.5 },
                CameraAngleLimits = { 200, -80, 110 },
                EyePoint = { 0.05, 0, 0 },
                ShoulderSize = 0.2,
                Allow360rotation = false,
                limits_6DOF = {
                    x = { -1, 1 },
                    y = { -1, 1 },
                    z = { -1, 1 },
                    roll = 90
                },
            },
        },
        Chase = {
            LocalPoint = { 2.51, 3.604, 0 },
            AnglesDefault = { 180, -8 },
        },
        Arcade = {
            LocalPoint = { -13.79, 6.204, 0 },
            AnglesDefault = { 0, -8 },
        },
    },

    SnapViews = {
        [1] = {
            [1] = {
                viewAngle = 70.611748,
                hAngle = -1.240272,
                vAngle = -33.850250,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            [2] = {
                viewAngle = 32.704346,
                hAngle = 25.696522,
                vAngle = -34.778103,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            [3] = {
                viewAngle = 32.704346,
                hAngle = 0.000000,
                vAngle = -47.845268,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            [4] = {
                viewAngle = 36.106045,
                hAngle = -28.878576,
                vAngle = -36.780628,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            [5] = {
                viewAngle = 88.727844,
                hAngle = 128.508865,
                vAngle = 13.131046,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            [6] = {
                viewAngle = 41.928593,
                hAngle = 0.000000,
                vAngle = -4.630446,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            [7] = {
                viewAngle = 88.727844,
                hAngle = -128.508865,
                vAngle = 13.131046,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            [8] = {
                viewAngle = 88.727844,
                hAngle = 81.648369,
                vAngle = -9.500000,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            [9] = {
                viewAngle = 88.727844,
                hAngle = 0.000000,
                vAngle = 34.180634,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            [10] = {
                viewAngle = 88.727844,
                hAngle = -80.997551,
                vAngle = -9.500000,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            -- look at left  mirror
            [11] = {
                viewAngle = 56.032040,
                hAngle = 14.803060,
                vAngle = 3.332499,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            -- look at right mirror
            [12] = {
                viewAngle = 56.032040,
                hAngle = -14.414484,
                vAngle = 3.332499,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            -- default view
            [13] = {
                viewAngle = 88.727844,
                hAngle = 0.000000,
                vAngle = -9.678451,
                x_trans = 0.264295,
                y_trans = -0.064373,
                z_trans = 0.000000,
                rollAngle = 0.000000,
            },
            -- HMD view
            [14] = {
                x_trans = 0.200,
                y_trans = -0.064,
                z_trans = 0.000,
            },
        }
    }
}

return views
