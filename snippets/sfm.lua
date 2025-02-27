SFM_Data = {
    aerodynamics = {            -- Cx = Cx_0 + Cy^2*B2 +Cy^4*B4                       more lift = more drag, B2 and B4 for exponential drag increase with lift
        Cy0         = 0.0,      -- zero AoA lift coefficient                          higher value = more lift at zero AoA
        Mzalfa      = 6.2,      -- pitch agility coefficient                          higher value = more agile in pitch
        Mzalfadt    = 0.7,      -- pitch agility damping coefficient                  higher value = more stable in pitch
        kjx         = 4.5,      -- inertia parameter x-axis (roll)                    higher value = more inertia, rolls more slowly
        kjz         = 0.00125,  -- inertia parameter z-axis (yaw)                     higher value = more inertia, yaws more slowly
        Czbe        = -0.016,   -- yaw stability coefficient (z-axis)                 negative value = counteracting force to yaw is generated
        cx_gear     = 0.07,     -- drag coefficient for landing gear                  higher value = more drag when gear deployed
        cx_flap     = 0.08,     -- drag coefficient for flaps                         higher value = more drag when flaps deployed
        cy_flap     = 0.21,     -- lift coefficient for flaps                         higher value = more lift when flaps deployed
        cx_brk      = 0.12,     -- drag coefficient for speedbrakes/spoilers          higher value = more drag when speedbrakes/spoilers deployed
        -- M        mach number                                            line from table below is picked according to current aircraft mach speed (interpolated)
        -- Cx0      general airplane drag coefficient                      higher value = more drag
        -- Cya      normal (lift) force coefficient per degree of AoA      higher value = more lift at AoA increase, lower value = maintain higher g-loads
        -- B2       lift-induced drag coefficient                          higher value = more drag at higher lift
        -- B4       higher-order lift-induced drag coefficient             higher value = more drag at higher lift (rapid increase at high lift) 
        -- Omxmax   maximum roll rate                                      higher value = more agile in roll
        -- Aldop    maximum AoA before departure                           higher value = more AoA before aircraft departs controlled flight or stalls
        -- Cymax    maximum lift coefficient                               limits current Cy
        table_data = {
        --    M       Cx0        Cya      B      B4        Omxmax      Aldop       Cymax
            { 0.00,   0.0220,    0.087,   0.149,  0.00,       0.5,     22.91,      1.40 },
            { 0.15,   0.0220,    0.087,   0.149,  0.00,       1.0,     22.91,      1.40 },
            { 0.30,   0.0160,    0.061,   0.149,  0.00,       4.5,     22.91,      1.30 },
            { 0.40,   0.0160,    0.060,   0.149,  0.00,       6.5,     22.91,      1.22 },
            { 0.48,   0.0160,    0.060,   0.149,  0.00,       7.5,     22.91,      1.05 },
            { 0.50,   0.0160,    0.060,   0.149,  0.00,       8.0,     22.34,      1.00 },
            { 0.55,   0.0160,    0.060,   0.149,  0.00,       8.0,     20.91,      0.96 },
            { 0.60,   0.0160,    0.060,   0.149,  0.00,       8.1,     18.33,      0.91 },
            { 0.65,   0.0175,    0.061,   0.149,  0.00,       8.2,     22.63,      0.89 },
            { 0.70,   0.0190,    0.062,   0.149,  0.00,       8.3,     25.21,      0.88 },
            { 0.80,   0.0200,    0.066,   0.149,  0.00,       8.3,     23.60,      0.86 },
            { 0.85,   0.0215,    0.070,   0.149,  0.00,       8.1,     21.77,      0.80 },
            { 0.88,   0.0245,    0.078,   0.169,  0.00,       7.8,     19.00,      0.76 },
            { 0.9,    0.0310,    0.079,   0.179,  0.00,       7.6,     18.33,      0.76 },
            { 0.95,   0.0335,    0.075,   0.280,  0.00,       7.6,     13.18,      0.76 },
            { 1.0,    0.0350,    0.073,   0.352,  0.00,       7.6,     10.30,      0.76 },
            { 1.1,    0.0370,    0.065,   0.460,  0.00,       7.6,     10.10,      0.76 },
        }
    },
    engine = {
        type = 4,                    -- E_TURBOJET=0, E_TURBOJET_AB=1, E_PISTON=2, E_TURBOPROP=3, E_TURBOFAN=4, E_TURBOSHAFT=5
        name = "Merlin",             -- engine name
        Nmg = 67.5,                  -- RPM at idle
        Nominal_RPM = 14710.0,       --
        Nominal_Fan_RPM = 8215.0,    --
        Startup_Prework = 10.0,      --
        Startup_Duration = 35.0,     --
        Shutdown_Duration = 19.0,    --
        MinRUD = 0,                  -- Min state of the throttle
        MaxRUD = 1,                  -- Max state of the throttle
        MaksRUD = 0.85,              -- Military power state of the throttle
        ForsRUD = 0.91,              -- Afterburner state of the throttle
        hMaxEng = 19,                -- Max altitude for safe engine operation in km
        dcx_eng = 0.0144,            -- Engine drag coefficient
        cemax = 1.24,                -- Used for AI routines to check flight time
        cefor = 2.56,                -- Used for AI routines to check flight time
        dpdh_m = 6200,               -- Altitude coefficient for max thrust
        dpdh_f = 13000,              -- Altitude coefficient for AB thrust
        -- M      mach number
        -- Pmax   thrust at mil power (N)
        -- Pfor   thrust at AB (N)
        table_data = {
        --    M,   Pmax,   Pfor
            { 0.0, 125000, 191000 },
            { 0.2, 130225, 191712 },
            { 0.4, 141225, 193319 },
            { 0.6, 155225, 196819 },
            { 0.7, 162225, 201678 },
            { 0.8, 160225, 207454 },
            { 0.9, 152225, 222555 },
            { 1.0, 145225, 245222 },
            { 1.1, 132225, 255225 },
            { 1.2, 118225, 260225 },
            { 1.3, 105225, 262225 },
            { 1.4, 82255, 265225 },
            { 1.6, 52255, 267552 },
            { 1.8, 31225, 245225 },
            { 2.2, 23558, 132225 },
            { 2.5, 23005, 79225 },
            { 3.9, 23005, 25225 },
        },
        -- Propeller (mostly guessed)
        Startup_RPMs = {             -- mapping for startup time to RPM?
            { 0.0, 0 },
            { 1.0, 60 },
            { 8.0, 60 },
            { 8.6, 880 },
            { 13.0, 601 },
        },
        Startup_Ignition_Time = 6.3, -- time required for engine ignition
        k_adiab_1 = 0.0325,          -- adiabatic coefficient?
        k_adiab_2 = 0.042,           -- adiabatic coefficient?
        MAX_Manifold_P_1 = 150000,   -- maximum manifold pressure at different stages?
        MAX_Manifold_P_2 = 163560,   --
        MAX_Manifold_P_3 = 225500,   --
        k_after_cool = 0.001,        -- some cooling coefficient? (post combustion?)
        Displ = 27,                  -- displacement (l)
        k_Eps = 6,                   --
        Stroke = 0.152,              -- piston stroke (m)
        V_pist_0 = 12,               -- number of pistons
        Nu_0 = 1.2,                  --
        Nu_1 = 0.9,                  --
        Nu_2 = 0.001,                --
        N_indic_0 = 1023040,         --
        N_fr_0 = 0.072,              -- some friction coefficient?
        N_fr_1 = 0.02,               --
        Init_Mom = 220,              -- initial moment of inertia/torque?
        D_prop = 3.66,               -- diameter of propeller (m)
        MOI_prop = 65,               -- moment of inertia of propeller?
        k_gearbox = 2.381,           -- gearbox ratio
        P_oil = 495438,              -- oil pressure
        k_boost = 3,                 -- boost coefficient (super charger?)
        k_cfug = 0.003,              --
        k_oil = 0.00004,             -- oil flow/viscosity coefficient?
        k_piston = 3000,             --
        k_reg = 0.003,               --
        k_vel = 0.017,               -- velocity related coefficient (drag?)
        prop_pitch_min = 26.0,       -- prop pitch min, degrees
        prop_pitch_max = 82.0,       -- prop pitch max, degrees
        prop_pitch_feather = 90.0,   -- prop pitch feather position, degrees if feather < prop_pitch_max no feathering available
        prop_blades_count = 3,       -- propeller blades count
        prop_direction = 1,          -- 1 or -1 (clockwise or counter-clockwise)
        prop_locations = {           -- propeller locations
            { 0.0, 0.0, -2.0 },
            { 2.363, 0.104, -2.491 }, { math.pi, 0.0, 0.0 },
            { 2.363, 0.104, 2.491 }, { math.pi, 0.0, 0.0 },
        },
    }
}
