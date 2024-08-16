---------------------------------------------------------------------------
--- opsdcs-cargo
---
--- Cargo statics for slingload
---------------------------------------------------------------------------

local self_ID = "opsdcs-cargo"

declare_plugin(self_ID, {
    installed = true,
    dirName = current_mod_path,
    displayName = _(self_ID),
    shortName = _(self_ID),
    fileMenuName = _(self_ID),
    version = "1.0.0",
    state = "installed",
    developerName = "ops",
    info = _("opsdcs-cargo statics for slingload"),
})

loadfile(current_mod_path .. "/add_cargo.lua")()

loadfile(current_mod_path .. "/Database/Armored/CH_EagleIV_MRAP.lua")()
loadfile(current_mod_path .. "/Database/Armored/CH_Oshkosh_LATV_M2.lua")()
loadfile(current_mod_path .. "/Database/Armored/CH_Oshkosh_LATV_MK19.lua")()
loadfile(current_mod_path .. "/Database/Armored/CH_Oshkosh_MATV_MRAP_M2.lua")()
loadfile(current_mod_path .. "/Database/Armored/CH_Oshkosh_MATV_MRAP_MK19.lua")()
loadfile(current_mod_path .. "/Database/Armored/CH_Wiesel_1A4_AWC.lua")()
loadfile(current_mod_path .. "/Database/Artillery/CH_M777_LTH_M795lua.lua")()
loadfile(current_mod_path .. "/Database/Artillery/CH_M777_LTH_M982_Excalibur.lua")()
loadfile(current_mod_path .. "/Database/Destroyer/CH_Arleigh_Burke_IIa.lua")()
loadfile(current_mod_path .. "/Database/Helicopter/OH58D.lua")()

plugin_done()
