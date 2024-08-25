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
        ["AAA_M1_37mm_cargo"] = { "M1_37mm" },
        ["aaa_8_8cm_flak36_cargo"] = { "flak36" },
        ["aaa_8_8cm_flak37_cargo"] = { "flak37" },
        ["aaa_8_8cm_flak41_cargo"] = { "flak41" },
        ["aaa_8_8cm_flak_18_cargo"] = { "flak18" },
        ["aaa_bofors_40mm_cargo"] = { "bofors40" },
        ["aaa_fire_can_son_9_cargo"] = { "SON_9" },
        ["aaa_flak38_20mm_cargo"] = { "flak30" },
        ["aaa_flakvierling38_quad_20mm_cargo"] = { "flak38" },
        ["aaa_kdo.g.40_cargo"] = { "KDO_Mod40" },
        ["aaa_ks_19_100mm_cargo"] = { "KS-19" },
        ["aaa_m45_quadmount_hb_12.7mm_cargo"] = { "M45_Quadmount" },
        ["aaa_qf_3_7_cargo"] = { "QF_37_AA" },
        ["aaa_s_60_57mm_cargo"] = { "S-60_Type59_Artillery" },
        ["aaa_zu23_ural4320_cargo"] = { "Ural-375 ZU-23" },
        ["ah_1w_cargo"] = { "AH-1W" },
        ["allies_rangefinder_drt_cargo"] = { "Allies_Director" },
        ["apc_m2a1_halftrack_cargo"] = { "M2A1_halftrack" },
        ["apc_sd_kfz251_halftrack_cargo"] = { "Sd_Kfz_251" },
        ["arleigh_burke_iia_cargo"] = { "USS_Arleigh_Burke_IIa" },
        ["atg_hmmwv_cargo"] = { "M1045 HMMWV TOW" },
        ["brdm_2l1_arv_cargo"] = { "CH_BRDM2L1" },
        ["bv_410_atv_cargo"] = { "BV410" },
        ["car_daimler_armored_cargo"] = { "Daimler_AC" },
        ["eagle_iv_mrap_cargo"] = { "CH_EagleIV" },
        ["fh_lefh18_105mm_cargo"] = { "LeFH_18-40-105" },
        ["fh_m2a1_105mm_cargo"] = { "M2A1-105" },
        ["fh_pak40_75mm_cargo"] = { "Pak40" },
        ["hkp_15b_luh_cargo"] = { "HKP15B" },
        ["hq_7_ln_cargo"] = { "HQ-7_LN_P" },
        ["hq_7_self_propelled_ln_cargo"] = { "HQ-7_LN_SP" },
        ["hq_7_self_propelled_str_cargo"] = { "HQ-7_STR_SP" },
        ["ka_52_cargo"] = { "CH_Ka52" },
        ["kozak_5_apc_cargo"] = { "CH_Kozak5" },
        ["kraz_spartan_apc_cargo"] = { "CH_KrAZSpartan" },
        ["m777_cargo"] = { "CH_M777LTH_M795" },
        ["m777_excalibur_cargo"] = { "CH_M777LTH_MTVR_M982" },
        ["maschinensatz_33_gen_cargo"] = { "Maschinensatz_33" },
        ["mlrs_hl_b8m1_80mm_cargo"] = { "HL_B8M1" },
        ["mlrs_lc_b8m1_80mm_cargo"] = { "tt_B8M1" },
        ["mortar_2b11_120mm_cargo"] = { "2B11 mortar" },
        ["oh58d_cargo"] = { "OH58D" },
        ["oshkosh_latv_m2_cargo"] = { "CH_OshkoshLATV_M2" },
        ["oshkosh_latv_mk19_cargo"] = { "CH_OshkoshLATV_MK19" },
        ["oshkosh_matv_mrap_m2_cargo"] = { "CH_OshkoshMATV_M2" },
        ["oshkosh_matv_mrap_mk19_cargo"] = { "CH_OshkoshMATV_MK19" },
        ["rbs_90_stationary_sam_ln_cargo"] = { "RBS-90" },
        ["sa342l_cargo"] = { "SA342L" },
        ["sa342m_cargo"] = { "SA342M" },
        ["sa342minigun_cargo"] = { "SA342Minigun" },
        ["sa342mistral_cargo"] = { "SA342Mistral" },
        ["sam_avenger_stinger_cargo"] = { "M1097 Avenger" },
        ["sam_chaparral_m48_cargo"] = { "M48 Chaparral" },
        ["sam_hawk_cwar_an_mpq_55_cargo"] = { "Hawk cwar" },
        ["sam_hawk_ln_m192_cargo"] = { "Hawk ln" },
        ["sam_hawk_platoon_command_post_pcp_cargo"] = { "Hawk pcp" },
        ["sam_hawk_sr_an_mpq_50_cargo"] = { "Hawk sr" },
        ["sam_hawk_tr_an_mpq_46_cargo"] = { "Hawk tr" },
        ["sam_nasams_c2_cargo"] = { "NASAMS_Command_Post" },
        ["sam_nasams_ln_aim_120b_cargo"] = { "NASAMS_LN_B" },
        ["sam_nasams_ln_aim_120c_cargo"] = { "NASAMS_LN_C" },
        ["sam_nasams_sr_mpq64f1_cargo"] = { "NASAMS_Radar_MPQ64F1" },
        ["sam_patriot_c2_icc_cargo"] = { "Patriot cp" },
        ["sam_patriot_ecs_cargo"] = { "Patriot ECS" },
        ["sam_rapier_blindfire_tr_cargo"] = { "rapier_fsa_blindfire_radar" },
        ["sam_rapier_ln_cargo"] = { "rapier_fsa_launcher" },
        ["sam_rapier_tracker_cargo"] = { "rapier_fsa_optical_tracker_unit" },
        ["sam_sa_2_s_75_guideline_ln_cargo"] = { "S_75M_Volhov" },
        ["sam_sa_2_s_75_rd_75_amazonka_rf_cargo"] = { "RD_75" },
        ["sam_sa_9_strela_1_gaskin_tel_cargo"] = { "Strela-1 9P31" },
        ["scout_bdrm2_cargo"] = { "BRDM2" },
        ["scout_cobra_cargo"] = { "Cobra" },
        ["scout_hl_dshk_cargo"] = { "HL_DSHK" },
        ["scout_hl_kord_cargo"] = { "HL_KORD" },
        ["scout_hmmwv_cargo"] = { "M1043" },
        ["scout_lc_dshk_cargo"] = { "tt_DSHK" },
        ["scout_lc_kord_cargo"] = { "tt_KORD" },
        ["scout_m8_greyhound_ac_cargo"] = { "M8_Greyhound" },
        ["scout_puma_ac_cargo"] = { "Sd_Kfz_234_2_Puma" },
        ["skyshield_c_ram_gun_cargo"] = { "CH_Skyshield_Gun" },
        ["sl_flakscheinwerfer_37_cargo"] = { "Flakscheinwerfer_37" },
        ["spaaa_hl_with_zu23_cargo"] = { "HL_ZU-23" },
        ["spaaa_lc_with_zu23_cargo"] = { "tt_ZU-23" },
        ["sph_sd_kfz124_wespe_105mm_cargo"] = { "Wespe124" },
        ["spm_2s9_nona_120mm_m_cargo"] = { "SAU 2-C9" },
        ["tigr_m_cargo"] = { "CH_TigrM" },
        ["tk_tetrarch_cargo"] = { "Tetrarch" },
        ["tractor_m4_high_speed_cargo"] = { "M4_Tractor" },
        ["uh_1h_cargo"] = { "UH-1H" },
        ["volvo_740_ifv_cargo"] = { "Volvo740" },
        ["wiesel_1a4_awc_cargo"] = { "CH_Wiesel1A4" },
        ["wiesel_2_ozelot_vshorad_cargo"] = { "CH_Wiesel2Ozelot" },
        ["bambi_bucket"] = { nil, "bambi_bucket", "Cargos" },
        ["fueltank_cargo"] = { nil, "fueltank_cargo", "Cargos" },
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
        ["units"] ={
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
            local agl = pos.p.y - land.getHeight({ x = pos.p.x, y = pos.p.z })
            local v_y = s:getVelocity().y
            msg = msg .. string.format(" AGL=%.1f, v_y=%.5f, hdg:%.2f (%s)", agl, v_y, heading, self.trackedStatics[name].type)
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

    --trigger.action.outText(msg, 1, true)

    timer.scheduleFunction(self.update, self, timer.getTime() + timeDelta)
end

OpsdcsCargo:start()
