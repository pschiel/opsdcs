-- FM config for make_flyable  

MyFM = {
    -- plugin id with the FM
    -- preloading in entry.lua possibly needed, e.g.: rules = { ["F-15C"] = { required = true } }
    [1] = "F-15C",

    -- name of the FM DLL
    -- if nil is passed, then SFM is used
    [2] = "F15",

    -- provides (old?) FC avionics, "true" sets the ID via unit ID from db,
    -- for manual IDs see Scripts\Aircrafts\_Common\CustomHuman.lua
    -- mainpanel needs attributes = { "support_for_cws" }
    old = 6,

    -- path to this config, gets passed to ed_fm_configure()
    -- if a FM DLL uses this, make sure the exposed global variable fits (e.g. "AH64D")
    config_path = current_mod_path .. "fm.lua",

    -- unclear, found in F-4E and F14
    Type = 0,

    -- nameId from Options
    user_options = "ac-minimal",

    -- center of mass relative to mesh origin
    center_of_mass = { 0, 0, 0 },

    -- empty weight inertia properties (kg/m^2)
    -- Ixx = roll, Izz = yaw, Iyy = pitch, Ixy = roll-pitch coupling, can be negative
    moment_of_inertia = { 0, 0, 0, 0 },

    -- set to false to enable hypoxia effects etc
    disable_built_in_oxygen_system = true,

    -- minor view shake amplitude
    minor_shake_ampl = 0.21,

    -- major view shake amplitude
	major_shake_ampl = 0.5,

    -- debug line
	debugLine = "{M}:%1.3f {KCAS}:%4.1f {KEAS}:%4.1f {KTAS}:%4.1f {IAS}:%4.1f "
        .. "{AoA}:%2.1f {ny}:%2.1f {nx}:%1.2f {AoS}:%2.1f {mass}:%2.1f "
        .. "{Fy}:%2.1f {Fx}:%2.1f {wx}:%.1f {wy}:%.1f {wz}:%.1f {Vy}:%2.1f {dPsi}:%2.1f",
    
    -- suspension setup
    suspension = dofile(current_mod_path .. "suspension.lua"),
}
