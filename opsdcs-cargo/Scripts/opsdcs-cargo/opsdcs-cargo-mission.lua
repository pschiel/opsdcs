--- opsdcs-cargo (mission script)

--if OpsdcsCargo then return end

OpsdcsCargo = {
    options = {
        debug = true,        --- @type boolean @debug mode, set true for ingame debug messages
        timeDelta = 0.1,     --- @type number @seconds between updates
        litresPerSec = 1000, --- @type number @litres per second
    },

    --- @type table<string,table> @static name to unit properties
    staticToUnit = {
        -- dcs core / artillery
        l118 = {},
        -- opsdcs-cargo / armored
        apc_m2a1_halftrack_cargo = {},
        apc_sd_kfz251_halftrack_cargo = {},
        atg_hmmwv_cargo = {},
        car_daimler_armored_cargo = {},
        scout_bdrm2_cargo = {},
        scout_cobra_cargo = {},
        scout_hl_dshk_cargo = {},
        scout_hl_kord_cargo = {},
        scout_hmmwv_cargo = {},
        scout_lc_dshk_cargo = {},
        scout_lc_kord_cargo = {},
        scout_m8_greyhound_ac_cargo = {},
        scout_puma_ac_cargo = {},
        tk_tetrarch_cargo = {},
        tractor_m4_high_speed_cargo = {},
        -- opsdcs-cargo / artillery
        fh_lefh18_105mm_cargo = {},
        fh_m2a1_105mm_cargo = {},
        fh_pak40_75mm_cargo = {},
        mortar_2b11_120mm_cargo = {},
        mlrs_hl_b8m1_80mm_cargo = {},
        mlrs_lc_b8m1_80mm_cargo = {},
        sph_sd_kfz124_wespe_105mm_cargo = {},
        spm_2s9_nona_120mm_m_cargo = {},
        -- opsdcs-cargo [CH USA] / armored
        oshkosh_latv_m2_cargo = {},
        oshkosh_latv_mk19_cargo = {},
        oshkosh_matv_mrap_m2_cargo = {},
        oshkosh_matv_mrap_mk19_cargo = {},
        -- opsdcs-cargo [CH USA] / artillery
        m777_cargo = {},
        m777_excalibur_cargo = {},
        -- opsdcs-cargo [CH GER] / armored
        eagle_iv_mrap_cargo = {},
        wiesel_1a4_awc_cargo = {},

    },

    basedir = OpsdcsCargoBasedir or "", --- @type string @path to Scripts/opsdcs-cargo
    isRunning = false,                  --- @type boolean @true while running
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
    self.isRunning = true
    self:update()
end

--- stops script
function OpsdcsCargo:stop()
    self:log("stop")
    self.isRunning = false
end

water = 0
--- update loop
function OpsdcsCargo:update()
    if not self.isRunning then return end
    local timeDelta = self.options.timeDelta

    --local s = Unit.getByName("p1")
    local s = StaticObject.getByName("b2")
    if s ~= nil then
        local p = s:getPoint()
        local alt = land.getHeight({ x = p.x, y = p.z })
        local agl = p.y - alt
        local stype = land.getSurfaceType({ x = p.x, y = p.z })
        local vel = s:getVelocity()
        local velMag = math.sqrt(vel.x * vel.x + vel.y * vel.y + vel.z * vel.z)
        local msg
        if stype == 3 then
            msg = "Water: YES"
        else
            msg = "Water: NO"
        end
        msg = msg .. string.format(" (%d)", stype)
        msg = msg .. string.format("\nAGL: %.1f", agl)
        if agl < 10 then
            msg = msg .. " [OK]"
        else
            msg = msg .. " [High]"
        end
        msg = msg .. string.format("\nVelocity: %.1f", velMag)
        if velMag < 10 then
            msg = msg .. " [OK]"
        else
            msg = msg .. " [High]"
        end

        if stype == 3 and agl < 10 and velMag < 10 then
            water = water + timeDelta * self.options.litresPerSec
            if water > 9000 then water = 9000 end
        end

        msg = msg .. string.format("\n\nl/sec: %d\nFilled: %d l", self.options.litresPerSec, water)
        trigger.action.outText(msg, 10, true)
    end

    -- @todo

    timer.scheduleFunction(self.update, self, timer.getTime() + timeDelta)
end

OpsdcsCargo:start()
