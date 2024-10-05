local fm = {
    [1] = "F-15C", -- plugin id with fm
    [2] = "F15", -- name of dll
    old = 6,
    config_path = current_mod_path .. "fm.lua", -- path to self, but why?
    user_options = "ac-minimal", -- nameId from Options
    center_of_mass = {0, 0, 0},
    moment_of_inertia = {0, 0, 0, 0},
    disable_built_in_oxygen_system	= true,
    minor_shake_ampl = 0.21,
	major_shake_ampl = 0.5,
	debugLine = "{M}:%1.3f {KCAS}:%4.1f {KEAS}:%4.1f {KTAS}:%4.1f {IAS}:%4.1f {AoA}:%2.1f {ny}:%2.1f {nx}:%1.2f {AoS}:%2.1f {mass}:%2.1f {Fy}:%2.1f {Fx}:%2.1f {wx}:%.1f {wy}:%.1f {wz}:%.1f {Vy}:%2.1f {dPsi}:%2.1f",
    suspension = dofile(current_mod_path .. "suspension.lua"),
}

return fm
