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

dofile(current_mod_path .. "/add_cargo.lua")

dofile(current_mod_path .. "/Database/Armored/APC_M2A1_Halftrack.lua")
dofile(current_mod_path .. "/Database/Armored/APC_Sd.Kfz.251_Halftrack.lua")
dofile(current_mod_path .. "/Database/Armored/ATG_HMMWV.lua")
dofile(current_mod_path .. "/Database/Armored/Car_Daimler_Armored.lua")
dofile(current_mod_path .. "/Database/Armored/CH_EagleIV_MRAP.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Oshkosh_LATV_M2.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Oshkosh_LATV_MK19.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Oshkosh_MATV_MRAP_M2.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Oshkosh_MATV_MRAP_MK19.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Wiesel_1A4_AWC.lua")
dofile(current_mod_path .. "/Database/Armored/Scout_BDRM-2.lua")
dofile(current_mod_path .. "/Database/Armored/Scout_Cobra.lua")
dofile(current_mod_path .. "/Database/Armored/Scout_HL_with_DSHK_12.7mm.lua")
dofile(current_mod_path .. "/Database/Armored/Scout_HL_with_KORD_12.7mm.lua")
dofile(current_mod_path .. "/Database/Armored/Scout_HMMWV.lua")
dofile(current_mod_path .. "/Database/Armored/Scout_LC_with_DSHK_12.7mm.lua")
dofile(current_mod_path .. "/Database/Armored/Scout_LC_with_KORD_12.7mm.lua")
dofile(current_mod_path .. "/Database/Armored/Scout_M8_Greyhound_AC.lua")
dofile(current_mod_path .. "/Database/Armored/Scout_Puma_AC.lua")
dofile(current_mod_path .. "/Database/Armored/Tk_Tetrarch.lua")
dofile(current_mod_path .. "/Database/Armored/Tractor_M4_High_Speed.lua")

dofile(current_mod_path .. "/Database/Artillery/CH_M777_LTH_M795.lua")
dofile(current_mod_path .. "/Database/Artillery/CH_M777_LTH_M982_Excalibur.lua")
dofile(current_mod_path .. "/Database/Artillery/FH_LeFH18_105mm.lua")
dofile(current_mod_path .. "/Database/Artillery/FH_M2A1_105mm.lua")
dofile(current_mod_path .. "/Database/Artillery/FH_Pak_40_75mm.lua")
dofile(current_mod_path .. "/Database/Artillery/MLRS_HL_with_B8M1_80mm.lua")
dofile(current_mod_path .. "/Database/Artillery/MLRS_LC_with_B8M1_80mm.lua")
dofile(current_mod_path .. "/Database/Artillery/Mortar_2B11_120mm.lua")
dofile(current_mod_path .. "/Database/Artillery/SPH_Sd.Kfz.124_Wespe_105mm.lua")
dofile(current_mod_path .. "/Database/Artillery/SPM_2S9_Nona_120mm_M.lua")

dofile(current_mod_path .. "/Database/Destroyer/CH_Arleigh_Burke_IIa.lua")

dofile(current_mod_path .. "/Database/Helicopter/OH58D.lua")

dofile(current_mod_path .. "/Database/Infantry/M92_Personnel_Crouch_Worker.lua")
dofile(current_mod_path .. "/Database/Infantry/M92_Personnel_Directives.lua")
dofile(current_mod_path .. "/Database/Infantry/M92_Personnel_Salute.lua")
dofile(current_mod_path .. "/Database/Infantry/Paratrooper_AKS-74.lua")
dofile(current_mod_path .. "/Database/Infantry/Paratrooper_RPG-16.lua")

plugin_done()
