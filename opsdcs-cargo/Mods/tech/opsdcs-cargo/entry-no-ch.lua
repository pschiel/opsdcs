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

dofile(current_mod_path .. "/Airdefense/oc_aaa_8_8cm_flak_18.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_8_8cm_flak36.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_8_8cm_flak37.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_8_8cm_flak41.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_bofors_40mm.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_fire_can_son_9.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_flak38_20mm.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_flakvierling38_quad_20mm.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_kdo_g_40.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_ks_19_100mm.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_m1_37mm.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_m45_quadmount_hb_12_7mm.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_qf_3_7.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_s_60_57mm.lua")
dofile(current_mod_path .. "/Airdefense/oc_aaa_zu23_ural4320.lua")
dofile(current_mod_path .. "/Airdefense/oc_allies_rangefinder_drt.lua")
dofile(current_mod_path .. "/Airdefense/oc_hq_7_ln.lua")
dofile(current_mod_path .. "/Airdefense/oc_hq_7_self_propelled_ln.lua")
dofile(current_mod_path .. "/Airdefense/oc_hq_7_self_propelled_str.lua")
dofile(current_mod_path .. "/Airdefense/oc_maschinensatz_33_gen.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_avenger_stinger.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_chaparral_m48.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_hawk_cwar_an_mpq_55.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_hawk_ln_m192.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_hawk_platoon_command_post_pcp.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_hawk_sr_an_mpq_50.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_hawk_tr_an_mpq_46.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_nasams_c2.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_nasams_ln_aim_120b.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_nasams_ln_aim_120c.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_nasams_sr_mpq64f1.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_patriot_c2_icc.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_patriot_ecs.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_rapier_blindfire_tr.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_rapier_ln.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_rapier_tracker.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_sa_2_s_75_guideline_ln.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_sa_2_s_75_rd_75_amazonka_rf.lua")
dofile(current_mod_path .. "/Airdefense/oc_sam_sa_9_strela_1_gaskin_tel.lua")
dofile(current_mod_path .. "/Airdefense/oc_sl_flakscheinwerfer_37.lua")
dofile(current_mod_path .. "/Airdefense/oc_spaaa_hl_with_zu23.lua")
dofile(current_mod_path .. "/Airdefense/oc_spaaa_lc_with_zu23.lua")
dofile(current_mod_path .. "/Armored/oc_apc_m2a1_halftrack.lua")
dofile(current_mod_path .. "/Armored/oc_apc_sd_kfz251_halftrack.lua")
dofile(current_mod_path .. "/Armored/oc_atg_hmmwv.lua")
dofile(current_mod_path .. "/Armored/oc_car_daimler_armored.lua")
dofile(current_mod_path .. "/Armored/oc_cout_lc_dshk.lua")
dofile(current_mod_path .. "/Armored/oc_scout_bdrm2.lua")
dofile(current_mod_path .. "/Armored/oc_scout_cobra.lua")
dofile(current_mod_path .. "/Armored/oc_scout_hl_dshk.lua")
dofile(current_mod_path .. "/Armored/oc_scout_hl_kord.lua")
dofile(current_mod_path .. "/Armored/oc_scout_hmmwv.lua")
dofile(current_mod_path .. "/Armored/oc_scout_lc_kord.lua")
dofile(current_mod_path .. "/Armored/oc_scout_m8_greyhound_ac.lua")
dofile(current_mod_path .. "/Armored/oc_scout_puma_ac.lua")
dofile(current_mod_path .. "/Armored/oc_tk_tetrarch.lua")
dofile(current_mod_path .. "/Armored/oc_tractor_m4_high_speed.lua")
dofile(current_mod_path .. "/Artillery/oc_fh_lefh18_105mm.lua")
dofile(current_mod_path .. "/Artillery/oc_fh_m2a1_105mm.lua")
dofile(current_mod_path .. "/Artillery/oc_fh_pak40_75mm.lua")
dofile(current_mod_path .. "/Artillery/oc_mlrs_hl_b8m1_80mm.lua")
dofile(current_mod_path .. "/Artillery/oc_mlrs_lc_b8m1_80mm.lua")
dofile(current_mod_path .. "/Artillery/oc_mortar_2b11_120mm.lua")
dofile(current_mod_path .. "/Artillery/oc_sph_sd_kfz124_wespe_105mm.lua")
dofile(current_mod_path .. "/Artillery/oc_spm_2s9_nona_120mm_m.lua")
dofile(current_mod_path .. "/Cargo/oc_bambi_bucket.lua")

----------------------------------

plugin_done()
