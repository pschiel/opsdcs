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

mount_vfs_model_path(current_mod_path .. "/Shapes")
mount_vfs_texture_path(current_mod_path .. "/Textures")

dofile(current_mod_path .. "/add_cargo.lua")

---------------------------------------------------------------------------

dofile(current_mod_path .. "/Database/Armored/APC_M2A1_Halftrack.lua")
dofile(current_mod_path .. "/Database/Armored/APC_Sd.Kfz.251_Halftrack.lua")
dofile(current_mod_path .. "/Database/Armored/ATG_HMMWV.lua")
dofile(current_mod_path .. "/Database/Armored/Car_Daimler_Armored.lua")
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
dofile(current_mod_path .. "/Database/Artillery/FH_LeFH18_105mm.lua")
dofile(current_mod_path .. "/Database/Artillery/FH_M2A1_105mm.lua")
dofile(current_mod_path .. "/Database/Artillery/FH_Pak_40_75mm.lua")
dofile(current_mod_path .. "/Database/Artillery/MLRS_HL_with_B8M1_80mm.lua")
dofile(current_mod_path .. "/Database/Artillery/MLRS_LC_with_B8M1_80mm.lua")
dofile(current_mod_path .. "/Database/Artillery/Mortar_2B11_120mm.lua")
dofile(current_mod_path .. "/Database/Artillery/SPH_Sd.Kfz.124_Wespe_105mm.lua")
dofile(current_mod_path .. "/Database/Artillery/SPM_2S9_Nona_120mm_M.lua")
dofile(current_mod_path .. "/Database/Cargo/Bambi_Bucket.lua")
dofile(current_mod_path .. "/Database/Destroyer/CH_Arleigh_Burke_IIa.lua")
dofile(current_mod_path .. "/Database/Helicopter/OH58D.lua")

---------------------------------------------------------------------------

-- [CH GER]
dofile(current_mod_path .. "/Database/Armored/CH_EagleIV_MRAP.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Wiesel_1A4_AWC.lua")

---------------------------------------------------------------------------

-- [CH USA]
dofile(current_mod_path .. "/Database/Armored/CH_Oshkosh_LATV_M2.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Oshkosh_LATV_MK19.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Oshkosh_MATV_MRAP_M2.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Oshkosh_MATV_MRAP_MK19.lua")
dofile(current_mod_path .. "/Database/Artillery/CH_M777_LTH_M795.lua")
dofile(current_mod_path .. "/Database/Artillery/CH_M777_LTH_M982_Excalibur.lua")

---------------------------------------------------------------------------

-- [CH RUS]
dofile(current_mod_path .. "/Database/Armored/CH_TigrM.lua")

---------------------------------------------------------------------------

-- [CH SWE]
dofile(current_mod_path .. "/Database/Armored/CH_Bv_410_ATV.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Volvo_740_IFV.lua")

---------------------------------------------------------------------------

-- [CH UKR]
dofile(current_mod_path .. "/Database/Armored/CH_BRDM_2L1_ARV.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Kozak_5_APC.lua")
dofile(current_mod_path .. "/Database/Armored/CH_KrAZ_SPARTAN_APC.lua")

---------------------------------------------------------------------------

-- [CH TRK]

---------------------------------------------------------------------------


plugin_done()
