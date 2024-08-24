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

mount_vfs_model_path("Bazar/World/Shapes")
mount_vfs_model_path(current_mod_path .. "/Shapes")
mount_vfs_texture_path(current_mod_path .. "/Textures")

dofile(current_mod_path .. "/add_cargo.lua")

---------------------------------------------------------------------------

-- DCS Core
dofile(current_mod_path .. "/Database/Airdefense/AAA_8.8cm_Flak_18.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_8.8cm_Flak_36.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_8.8cm_Flak_37.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_8.8cm_Flak_41.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_Bofors_40mm.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_Fire_Can_SON_9.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_Flak_38_20mm.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_Flak_Vierling_38_Quad_20mm.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_Kdo.G.40.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_KS_19_100mm.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_M1_37mm.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_M45_Quadmount_HB_12.7mm.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_QF_3.7.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_S_60_57mm.lua")
dofile(current_mod_path .. "/Database/Airdefense/AAA_ZU_23_on_Ural_4320.lua")
dofile(current_mod_path .. "/Database/Airdefense/Allies_Rangefinder_DRT.lua")
dofile(current_mod_path .. "/Database/Airdefense/HQ_7_LN.lua")
dofile(current_mod_path .. "/Database/Airdefense/HQ_7_Self_Propelled_LN.lua")
dofile(current_mod_path .. "/Database/Airdefense/HQ_7_Self_Propelled_STR.lua")
dofile(current_mod_path .. "/Database/Airdefense/Maschinensatz_33_Gen.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_Avenger_Stinger.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_Chaparral_M48.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_Hawk_CWAR_AN_MPQ_55.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_Hawk_LN_M192.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_Hawk_Platoon_Command_Post_PCP.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_Hawk_SR_AN_MPQ_50.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_Hawk_TR_AN_MPQ_46.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_NASAMS_C2.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_NASAMS_LN_AIM_120B.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_NASAMS_LN_AIM_120C.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_NASAMS_SR_MPQ64F1.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_Patriot_C2_ICC.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_Patriot_ECS.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_Rapier_Blindfire_TR.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_Rapier_LN.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_Rapier_Tracker.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_SA_2_S_75_Guideline_LN.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_SA_2_S_75_RD_75_Amazonka_RF.lua")
dofile(current_mod_path .. "/Database/Airdefense/SAM_SA_9_Strela_1_Gaskin_TEL.lua")
dofile(current_mod_path .. "/Database/Airdefense/SL_Flakscheinwerfer_37.lua")
dofile(current_mod_path .. "/Database/Airdefense/SPAAA_HL_with_ZU_23.lua")
dofile(current_mod_path .. "/Database/Airdefense/SPAAA_LC_with_ZU_23.lua")
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
dofile(current_mod_path .. "/Database/Helicopter/AH-1W.lua")
dofile(current_mod_path .. "/Database/Helicopter/SA342L.lua")
dofile(current_mod_path .. "/Database/Helicopter/SA342M.lua")
dofile(current_mod_path .. "/Database/Helicopter/SA342Minigun.lua")
dofile(current_mod_path .. "/Database/Helicopter/SA342Mistral.lua")
dofile(current_mod_path .. "/Database/Helicopter/UH-1H.lua")

---------------------------------------------------------------------------

-- [CH GER]
dofile(current_mod_path .. "/Database/Airdefense/CH_Skyshield_C_RAM_Gun.lua")
dofile(current_mod_path .. "/Database/Airdefense/CH_Wiesel_2_Ozelot_VSHORAD.lua")
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
dofile(current_mod_path .. "/Database/Helicopter/CH_Ka_52.lua")

---------------------------------------------------------------------------

-- [CH SWE]
dofile(current_mod_path .. "/Database/Airdefense/CH_RBS_90_Stationary_SAM_LN.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Bv_410_ATV.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Volvo_740_IFV.lua")
dofile(current_mod_path .. "/Database/Helicopter/CH_HKP_15B_LUH.lua")

---------------------------------------------------------------------------

-- [CH UKR]
dofile(current_mod_path .. "/Database/Armored/CH_BRDM_2L1_ARV.lua")
dofile(current_mod_path .. "/Database/Armored/CH_Kozak_5_APC.lua")
dofile(current_mod_path .. "/Database/Armored/CH_KrAZ_SPARTAN_APC.lua")

---------------------------------------------------------------------------

plugin_done()
