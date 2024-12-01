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
    -- M        mach number                                            line from above table is picked according to current aircraft mach speed (interpolated)
    -- Cx0      general airplane drag coefficient                      higher value = more drag
    -- Cya      normal (lift) force coefficient per degree of AoA      higher value = more lift at AoA increase, lower value = maintain higher g-loads
    -- B2       lift-induced drag coefficient                          higher value = more drag at higher lift
    -- B4       higher-order lift-induced drag coefficient             higher value = more drag at higher lift (rapid increase at high lift) 
    -- Omxmax   maximum roll rate                                      higher value = more agile in roll
    -- Aldop    maximum AoA before departure                           higher value = more AoA before aircraft departs controlled flight or stalls
    -- Cymax    maximum lift coefficient                               limits current Cy
}
