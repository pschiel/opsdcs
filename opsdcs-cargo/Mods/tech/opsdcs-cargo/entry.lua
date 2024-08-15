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

loadfile(current_mod_path .. "/Database/CH_Arleigh_Burke_IIa.lua")()
loadfile(current_mod_path .. "/Database/CH_EagleIV.lua")()
loadfile(current_mod_path .. "/Database/CH_M777.lua")()
loadfile(current_mod_path .. "/Database/CH_OshkoshLATV_M2.lua")()
loadfile(current_mod_path .. "/Database/CH_Wiesel1A4.lua")()
loadfile(current_mod_path .. "/Database/OH58D.lua")()

plugin_done()
