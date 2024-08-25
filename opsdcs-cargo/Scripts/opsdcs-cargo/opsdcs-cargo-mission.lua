--- opsdcs-cargo (mission script)

--if OpsdcsCargo then return end

OpsdcsCargo = {
    options = {
        debug = true,        --- @type boolean @debug mode, set true for ingame debug messages
        timeDelta = 0.1,     --- @type number @seconds between updates
        litresPerSec = 1000, --- @type number @litres per second
    },

    --- @type table<string,table> @static name to unit properties (unit type, static shape_name, category)
    staticToUnit = {
        ["oc_aaa_m1_37mm"] = { "M1_37mm" },
        ["oc_aaa_8_8cm_flak36"] = { "flak36" },
        ["oc_aaa_8_8cm_flak37"] = { "flak37" },
        ["oc_aaa_8_8cm_flak41"] = { "flak41" },
        ["oc_aaa_8_8cm_flak18"] = { "flak18" },
        ["oc_aaa_bofors_40mm"] = { "bofors40" },
        ["oc_aaa_fire_can_son_9"] = { "SON_9" },
        ["oc_aaa_flak38_20mm"] = { "flak30" },
        ["oc_aaa_flakvierling38_quad_20mm"] = { "flak38" },
        ["oc_aaa_kdo_g_40"] = { "KDO_Mod40" },
        ["oc_aaa_ks_19_100mm"] = { "KS-19" },
        ["oc_aaa_m45_quadmount_hb_12_7mm"] = { "M45_Quadmount" },
        ["oc_aaa_qf_3_7"] = { "QF_37_AA" },
        ["oc_aaa_s_60_57mm"] = { "S-60_Type59_Artillery" },
        ["oc_aaa_zu23_ural4320"] = { "Ural-375 ZU-23" },
        ["oc_allies_rangefinder_drt"] = { "Allies_Director" },
        ["oc_apc_m2a1_halftrack"] = { "M2A1_halftrack" },
        ["oc_apc_sd_kfz251_halftrack"] = { "Sd_Kfz_251" },
        ["oc_ch_usa_arleigh_burke_iia"] = { "USS_Arleigh_Burke_IIa" },
        ["oc_atg_hmmwv"] = { "M1045 HMMWV TOW" },
        ["oc_ch_ukr_brdm_2l1_arv"] = { "CH_BRDM2L1" },
        ["oc_ch_swe_bv_410_atv"] = { "BV410" },
        ["oc_car_daimler_armored"] = { "Daimler_AC" },
        ["oc_ch_ger_eagle_iv_mrap"] = { "CH_EagleIV" },
        ["oc_fh_lefh18_105mm"] = { "LeFH_18-40-105" },
        ["oc_fh_m2a1_105mm"] = { "M2A1-105" },
        ["oc_fh_pak40_75mm"] = { "Pak40" },
        ["oc_hq_7_ln"] = { "HQ-7_LN_P" },
        ["oc_hq_7_self_propelled_ln"] = { "HQ-7_LN_SP" },
        ["oc_hq_7_self_propelled_str"] = { "HQ-7_STR_SP" },
        ["oc_ch_ukr_kozak_5_apc"] = { "CH_Kozak5" },
        ["oc_ch_ukr_kraz_spartan_apc"] = { "CH_KrAZSpartan" },
        ["oc_ch_usa_m777"] = { "CH_M777LTH_M795" },
        ["oc_ch_usa_m777_excalibur"] = { "CH_M777LTH_MTVR_M982" },
        ["oc_maschinensatz_33_gen"] = { "Maschinensatz_33" },
        ["oc_mlrs_hl_b8m1_80mm"] = { "HL_B8M1" },
        ["oc_mlrs_lc_b8m1_80mm"] = { "tt_B8M1" },
        ["oc_mortar_2b11_120mm"] = { "2B11 mortar" },
        ["oc_ch_usa_oshkosh_latv_m2"] = { "CH_OshkoshLATV_M2" },
        ["oc_ch_usa_oshkosh_latv_mk19"] = { "CH_OshkoshLATV_MK19" },
        ["oc_ch_usa_oshkosh_matv_mrap_m2"] = { "CH_OshkoshMATV_M2" },
        ["oc_ch_usa_oshkosh_matv_mrap_mk19"] = { "CH_OshkoshMATV_MK19" },
        ["oc_ch_swe_rbs_90_stationary_sam_ln"] = { "RBS-90" },
        ["oc_sam_avenger_stinger"] = { "M1097 Avenger" },
        ["oc_sam_chaparral_m48"] = { "M48 Chaparral" },
        ["oc_sam_hawk_cwar_an_mpq_55"] = { "Hawk cwar" },
        ["oc_sam_hawk_ln_m192"] = { "Hawk ln" },
        ["oc_sam_hawk_platoon_command_post_pcp"] = { "Hawk pcp" },
        ["oc_sam_hawk_sr_an_mpq_50"] = { "Hawk sr" },
        ["oc_sam_hawk_tr_an_mpq_46"] = { "Hawk tr" },
        ["oc_sam_nasams_c2"] = { "NASAMS_Command_Post" },
        ["oc_sam_nasams_ln_aim_120b"] = { "NASAMS_LN_B" },
        ["oc_sam_nasams_ln_aim_120c"] = { "NASAMS_LN_C" },
        ["oc_sam_nasams_sr_mpq64f1"] = { "NASAMS_Radar_MPQ64F1" },
        ["oc_sam_patriot_c2_icc"] = { "Patriot cp" },
        ["oc_sam_patriot_ecs"] = { "Patriot ECS" },
        ["oc_sam_rapier_blindfire_tr"] = { "rapier_fsa_blindfire_radar" },
        ["oc_sam_rapier_ln"] = { "rapier_fsa_launcher" },
        ["oc_sam_rapier_tracker"] = { "rapier_fsa_optical_tracker_unit" },
        ["oc_sam_sa_2_s_75_guideline_ln"] = { "S_75M_Volhov" },
        ["oc_sam_sa_2_s_75_rd_75_amazonka_rf"] = { "RD_75" },
        ["oc_sam_sa_9_strela_1_gaskin_tel"] = { "Strela-1 9P31" },
        ["oc_scout_bdrm2"] = { "BRDM2" },
        ["oc_scout_cobra"] = { "Cobra" },
        ["oc_scout_hl_dshk"] = { "HL_DSHK" },
        ["oc_scout_hl_kord"] = { "HL_KORD" },
        ["oc_scout_hmmwv"] = { "M1043" },
        ["oc_scout_lc_dshk"] = { "tt_DSHK" },
        ["oc_scout_lc_kord"] = { "tt_KORD" },
        ["oc_scout_m8_greyhound_ac"] = { "M8_Greyhound" },
        ["oc_scout_puma_ac"] = { "Sd_Kfz_234_2_Puma" },
        ["oc_ch_ger_skyshield_c_ram_gun"] = { "CH_Skyshield_Gun" },
        ["oc_sl_flakscheinwerfer_37"] = { "Flakscheinwerfer_37" },
        ["oc_spaaa_hl_with_zu23"] = { "HL_ZU-23" },
        ["oc_spaaa_lc_with_zu23"] = { "tt_ZU-23" },
        ["oc_sph_sd_kfz124_wespe_105mm"] = { "Wespe124" },
        ["oc_spm_2s9_nona_120mm_m"] = { "SAU 2-C9" },
        ["oc_ch_rus_tigr_m"] = { "CH_TigrM" },
        ["oc_tk_tetrarch"] = { "Tetrarch" },
        ["oc_tractor_m4_high_speed"] = { "M4_Tractor" },
        ["oc_ch_swe_volvo_740_ifv"] = { "Volvo740" },
        ["oc_ch_ger_wiesel_1a4_awc"] = { "CH_Wiesel1A4" },
        ["oc_ch_ger_wiesel_2_ozelot_vshorad"] = { "CH_Wiesel2Ozelot" },
        ["oc_bambi_bucket"] = { nil, "bambi_bucket", "Cargos" },
        ["oc_fueltank_cargo"] = { nil, "fueltank_cargo", "Cargos" },
    },

    basedir = OpsdcsCargoBasedir or "", --- @type string @path to Scripts/opsdcs-cargo
    isRunning = false,                  --- @type boolean @true while running
    trackedStatics = {},
}

------------------------------------------------------------------------------

--- debug log helper
--- @param msg string @message
--- @param duration number @duration
function OpsdcsCargo:log(msg, duration)
    if self.options.debug then
        trigger.action.outText("[opsdcs-cargo] " .. msg, duration or 10)
    end
end

--- starts script
function OpsdcsCargo:start()
    self:log("start")
    for i = 2, 14 do
        local name = "c" .. tostring(i)
        self.trackedStatics[name] = {
            id = i,
            type = StaticObject.getByName(name):getTypeName(),
            shape_name = StaticObject.getByName(name):getDesc(),
            category = StaticObject.getByName(name):getCategory(),
            y = 0,
            x = 0,
            heading = 0,
            state = "init",
        }
        self:log("tracking " .. name .. " type: " .. self.trackedStatics[name].type)
    end
    self.isRunning = true
    self:update()
end

--- stops script
function OpsdcsCargo:stop()
    self:log("stop")
    self.isRunning = false
end

--- converts tracked static to unit
--- @param name string @object name
function OpsdcsCargo:convertStaticToUnit(name)
    local s = self.trackedStatics[name]
    local type = self.staticToUnit[s.type][1]
    if type == nil then
        return self:respawnStatic(name)
    end
    self:log("convert " .. name .. " to unit " .. type)
    local groupData = {
        ["visible"] = false,
        ["taskSelected"] = false,
        ["route"] = {},
        ["tasks"] = {},
        ["hidden"] = false,
        ["units"] = {
            [1] = {
                ["name"] = name,
                ["type"] = type,
                ["unitId"] = s.id,
                ["skill"] = AI.Skill.EXCELLENT,
                ["x"] = s.x,
                ["y"] = s.y,
                ["alt"] = 0,
                ["speed"] = 0,
                ["alt_type"] = AI.Task.AltitudeType.RADIO,
                ["heading"] = s.heading
            },
        },
        ["name"] = name,
        ["start_time"] = 0,
        ["task"] = "Nothing",
        ["groupId"] = s.id,
    }
    coalition.addGroup(country.id.USA, Group.Category.GROUND, groupData)
end

--- respawns a static at its last known position
--- @param name string @object name
function OpsdcsCargo:respawnStatic(name)
    local s = self.trackedStatics[name]
    --self:log("respawn static " .. name)
    local staticObj = {
        ["name"] = name,
        ["type"] = s.type,
        ["shape_name"] = self.staticToUnit[s.type][2],
        ["category"] = self.staticToUnit[s.type][3],
        ["heading"] = s.heading,
        ["x"] = s.x,
        ["y"] = s.y,
        ["unitId"] = s.id,
        ["groupId"] = s.id,
    }
    coalition.addStaticObject(country.id.USA, staticObj)
end

--- update loop
function OpsdcsCargo:update()
    if not self.isRunning then return end
    local timeDelta = self.options.timeDelta
    --water = 0
    --local msg = ""
    --- FIRE BLAH TEST
    --local s = Unit.getByName("p1")
    -- local s = StaticObject.getByName("b2342")

    -- if s ~= nil then
    --     local p = s:getPoint()
    --     local alt = land.getHeight({ x = p.x, y = p.z })
    --     local agl = p.y - alt
    --     local stype = land.getSurfaceType({ x = p.x, y = p.z })
    --     local vel = s:getVelocity()
    --     local velMag = math.sqrt(vel.x * vel.x + vel.y * vel.y + vel.z * vel.z)

    --     if stype == 3 then
    --         msg = "Water: YES"
    --     else
    --         msg = "Water: NO"
    --     end
    --     msg = msg .. string.format(" (%d)", stype)
    --     msg = msg .. string.format("\nAGL: %.1f", agl)
    --     if agl < 10 then
    --         msg = msg .. " [OK]"
    --     else
    --         msg = msg .. " [High]"
    --     end
    --     msg = msg .. string.format("\nVelocity: %.1f", velMag)
    --     if velMag < 10 then
    --         msg = msg .. " [OK]"
    --     else
    --         msg = msg .. " [High]"
    --     end

    --     if stype == 3 and agl < 10 and velMag < 10 then
    --         water = water + timeDelta * self.options.litresPerSec
    --         if water > 9000 then water = 9000 end
    --     end

    --     msg = msg .. string.format("\n\nl/sec: %d\nFilled: %d l", self.options.litresPerSec, water)
    -- end
    local msg = ""
    for name, data in pairs(self.trackedStatics) do
        local s = StaticObject.getByName(name)
        msg = msg .. string.format("\n%s: state=%s", name, data.state)
        -- unforeseen lost in nirvana
        if s == nil then
            local u = Unit.getByName(name)
            if u == nil then
                msg = msg .. " [LOST]"
                if data.state == "transport" then
                    --self:log(name .. " was lost")
                    data.state = "dropped"
                    self:convertStaticToUnit(name)
                end
            else
                --self:log(name .. " was found")
                msg = msg .. " [ALIVE] (" .. u:getTypeName() .. ")"
            end
        else
            local pos = s:getPosition()
            local heading = math.atan2(pos.x.z, pos.x.x)
            -- save last known position in case of loss
            data.x = pos.p.x
            data.y = pos.p.z
            data.heading = heading
            local deg = math.deg(heading)
            local agl = pos.p.y - land.getHeight({ x = pos.p.x, y = pos.p.z })
            local v_y = s:getVelocity().y
            msg = msg .. string.format(" AGL=%.1f, v_y=%.5f, hdg:%.2f (%s)", agl, v_y, deg, self.trackedStatics[name].type)
            -- transport state: needs to be in air first
            if data.state == "init" and agl > 1 and v_y > 0 then
                --self:log(name .. " is in transport")
                data.state = "transport"
                -- dropped: when in transport and doesn't move anymore or glitched in ground
            elseif data.type == "fueltank_cargo" and data.state == "transport" and (v_y < -1 and agl < 1) then
                data.state = "dropped"
                trigger.action.explosion(s:getPosition().p, 100)
            elseif data.state == "transport" and (v_y == 0 or agl < 0) then
                --self:log(name .. " was dropped")
                data.state = "dropped"
                s:destroy()
                self:convertStaticToUnit(name)
                -- lost before going transport
            elseif data.state == "init" and agl < -20 then
                --self:log(name .. " was dropped")
                data.state = "dropped"
                s:destroy()
                self:respawnStatic(name)
            end
        end
    end

    trigger.action.outText(msg, 1, true)

    timer.scheduleFunction(self.update, self, timer.getTime() + timeDelta)
end

OpsdcsCargo:start()
