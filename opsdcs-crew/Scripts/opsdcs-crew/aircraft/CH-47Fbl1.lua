OpsdcsCrew["CH-47Fbl1"] = {
    options = {
        showHighlights = false,
        playSounds = false,
    },
    soundpack = {
        plt = "default",
        cp = "default",
        fe = "default",
    },
    procedures = {
        {
            name = "Cold Start",
            start_state = "coldstart-apu-start",
        },
        {
            name = "Cold Start (Full)",
            start_state = "coldstart-before-apu-start",
        },
        {
            name = "Taxi",
            start_state = "taxi-before-taxi",
        },
        {
            name = "Takeoff",
            start_state = "takeoff-before-takeoff",
        },
        {
            name = "Landing",
            start_state = "landing-before-landing",
        },
        {
            name = "Shutdown",
            start_state = "shutdown-after-landing-check",
        },
    },
    states = {
        -- Cold Start
        ["coldstart-before-apu-start"] = {
            text = "Before APU Start (Interior/Overhead)",
            snd = 3,
            needAllPrevious = true,
            conditions = {
                { text = "Check Pedal positions matched", cond = { "skip" }, snd = 2, check = 1 }, -- PLT+CP
                { text = "Check PDP 1 all breakers IN", cond = { "arg_range_between", "17-35 37 40 42 45-54 57-66 70 73 75-77 87-88 90-99 103 106 108-109 114-129 133 134 136 139 147 148 149 157-163 165-170 172 175-176", 0.59, 0.61 }, snd = 3, check = 1 }, -- CP
                { text = "Check PDP 2 all breakers IN", cond = { "arg_range_between", "184-199 205 207 213-220 223-233 235 238 240 241 242 250-251 253-261 268 271 273 277-291 301 304 310-313 318-328 330-332 334 337 340-341", 0.59, 0.61 }, snd = 2.6, check =1 }, -- PLT
                { text = "Engine 1 Fan/Doors switches OFF", cond = { "arg_eq", "OCPS_ENG1_FAN", 0, "arg_eq", "OCPS_ENG1_DOOR", 0 }, snd = 2.7 }, -- PLT+CP
                { text = "Engine 2 Fan/Doors switches OFF", cond = { "arg_eq", "OCPS_ENG2_FAN", 0, "arg_eq", "OCPS_ENG2_DOOR", 0 }, check = 1 }, -- PLT+CP
                { text = "Set LTG, EXT LTG, CPLT LTG, PLT LTG, INTR LTG, HTG as required", cond = { "skip" }, snd = 2.5, check = 1 }, -- PLT+CP
                { text = "TROOP WARN switches OFF", cond = { "arg_eq", "OCTW_ALARM", 0, "arg_eq", "OCTW_LT", 0.1 }, snd = 1.6, check = 1 }, -- PLT+CP
                { text = "W/S WIPER knob OFF", cond = { "arg_eq", "OCTW_WIPER", 0.1 }, snd = 2, check = 1 }, --
                { text = "ELEC Power Panel switches OFF", cond = { "arg_eq", "OCEP_BATT", 0, "arg_eq", "OCEP_APU", 0, "arg_eq", "OCEP_GEN_1", 0.1, "arg_eq", "OCEP_GEN_2", 0.1, "arg_eq", "OCEP_GEN_APU", 0.1  }, snd = 2, check = 1 }, --
                { text = "XFEED to CLOSE", cond = { "arg_eq", "OCFC_XFEED", 0 }, snd = 1, check = 1 }, --
                { text = "REFUEL STA to OFF", cond = { "arg_eq", "OCFC_REFUEL", 0 }, snd = 2, check = 1 }, --
                { text = "FUEL PUMP switches OFF", cond = { "arg_eq", "OCFC_ENG1_AFTAUX", 0, "arg_eq", "OCFC_ENG1_MAIN1", 0, "arg_eq", "OCFC_ENG1_MAIN2", 0, "arg_eq", "OCFC_ENG1_FWDAUX", 0, "arg_eq", "OCFC_ENG2_AFTAUX", 0, "arg_eq", "OCFC_ENG2_MAIN1", 0, "arg_eq", "OCFC_ENG2_MAIN2", 0, "arg_eq", "OCFC_ENG2_FWDAUX", 0 }, snd = 1.5, check = 1 }, --
                { text = "ENG COND Levers to STOP", cond = { "arg_eq", "OCEC_ENG1", 0, "arg_eq", "OCEC_ENG2", 0, }, snd = 1.4, check = 1 }, --
                { text = "FADEC NR% knob to 100", cond = { "skip" }, snd = 4 }, --
                { text = "FADEC 1/2 PRI/REV switches to PRI", cond = { "arg_eq", "OCFC_MODE_1", 1, "arg_eq", "OCFC_MODE_2", 1 }, snd = 2.7, check = 1 }, --
                { text = "FADEC START and 1/2 INC/DEC switches centered", cond = { "arg_eq", "OCFC_ENG_START", 0, "arg_eq", "OCFC_NR_1", 0, "arg_eq", "OCFC_NR_2", 0 }, snd = 3.2, check = 1 }, --
                { text = "B/U PWR switch to OFF", cond = { "arg_eq", "OCFC_BU_PWR", 0 }, snd = 1.7, check = 1 }, --
                { text = "OSPD switch centered", cond = { "arg_eq", "OCFC_OSPD", 0 }, snd = 1.5, check = 1 }, --
                { text = "LOAD SHARE switch to TRQ", cond = { "arg_eq", "OCFC_LOAD", 1 }, snd = 1.8, check = 1 }, --
                { text = "ANTI ICE switches to OFF", cond = { "arg_eq", "OCAI_CPLT", 0, "arg_eq", "OCAI_CTR", 0, "arg_eq", "OCAI_PLT", 0, "arg_eq", "OCAI_PITOT", 0 }, snd = 2, check = 1 }, --
                { text = "HOIST Control switches and knob to OFF", cond = { "arg_eq", "OCCH_HOIST_MASTER", 0.1 }, snd = 2.3, check = 1 }, --
                { text = "CARGO HOOK MSTR to OFF", cond = { "arg_eq", "OCCH_HOOK_MASTER", 0.1 }, snd = 1.8, check = 1 }, --
                { text = "CARGO HOOK SEL as required", cond = { "arg_ne", "OCCH_HOOK_SELECTOR", -1 }, snd = 3.7 }, --
                { text = "CARGO HOOK EMERG to OFF and cover down", cond = { "arg_eq", "OCCH_EMER", 0, "arg_eq", "OCCH_EMER_COVER", 0 }, check = 1 }, --
                { text = "PWR XFER switches to OFF", cond = { "arg_eq", "OCHC_PTU_1", 0, "arg_eq", "OCHC_PTU_2", 0 }, snd = 2, check = 1 }, --
                { text = "FLT CONTR switch to BOTH", cond = { "arg_eq", "OCHC_FLT_CONTR", 0.1 }, snd = 2, check = 1 }, --
                { text = "PWR STEER switch ON and cover down", cond = { "arg_eq", "OCHC_PWR_STEER", 0, "arg_eq", "OCHC_PWR_STEER_COVER", 0 }, snd = 2.5, check = 1 }, --
                { text = "RAMP PWR switch to ON", cond = { "arg_eq", "OCHC_RAMP", 0.1 }, snd = 4 }, --
                { text = "RAMP EMER switch to HOLD and cover down", cond = { "arg_eq", "OCHC_RAMP_EMER", 0.1, "arg_eq", "OCHC_RAMP_EMER_COVER", 0 }, check = 1 }, --
            },
            next_state = "coldstart-before-apu-start-2",
        },
        ["coldstart-before-apu-start-2"] = {
            text = "Before APU Start (Instrument/Canted/Center)",
            snd = 5,
            conditions = {
                { text = "Check FIRE PULL handles IN", cond = { "arg_eq", "FIRE_PULL_L", 0, "arg_eq", "FIRE_PULL_R", 0 }, snd = 2.5, check = 1 }, --
                { text = "Set MFD Power to NORM or NVG", cond = { "arg_gt", "MFD_CL_PWR", 0, "arg_gt", "MFD_CR_PWR", 0, "arg_gt", "MFD_CTR_PWR", 0, "arg_gt", "MFD_PL_PWR", 0, "arg_gt", "MFD_PR_PWR", 0 }, snd = 2, check = 1  }, --
                { text = "Set Radar Altimeter as required", cond = { "arg_ne", "MAIN_RALT_DIMMER", -1 }, snd = 2, check = 1  }, --
                { text = "Set CDU 1/2 Brightness as required", cond = { "arg_ne", "CDU_1_DIMMER", -1, "arg_ne", "CDU_2_DIMMER", -1 }, snd = 3, check = 1 }, --
                { text = "AFCS Cyclic Trim switch to AUTO", cond = { "arg_eq", "AFCS_MODE", 1 }, snd = 2.3, check = 1 }, --
                { text = "AFCS SYSTEM SEL switch OFF", cond = { "arg_eq", "AFCS_SYSTEM", 0 }, snd = 2.2, check = 1 }, --
                { text = "Emergency MAN/NORM/GUARD to NORM", cond = { "arg_eq", "EAUX_RADIO_MODE", 0.1 }, snd = 2, check = 1 }, --
                { text = "Emergency EMER to OFF", cond = { "arg_eq", "EAUX_EMER", 0.1 }, snd = 2, check = 1 }, --
                { text = "Emergency ZERO to OFF", cond = { "arg_eq", "EAUX_ZERO", 0 }, snd = 1.5, check = 1 }, --
                { text = "CGI Test switch OFF", cond = { "arg_eq", "MISC_CGI_TEST", 0}, snd = 1.8, check = 1  }, --
                { text = "BKUP RAD SEL as required", cond = { "arg_ne", "MISC_BKUP_RAD", -1 }, snd = 2, check = 1 }, --
                { text = "JETTISON switch to OFF and cover down", cond = { "arg_eq", "ASE_JETT_COVER", 0, "arg_eq", "ASE_JETT", 0 }, snd = 2.5, check = 1 }, --
                { text = "ARM/SAFE switch to SAFE", cond = { "arg_eq", "ASE_ARM", 0 }, snd = 1.8, check = 1 }, --
                { text = "BYPASS/NORMAL switch to NORMAL", cond = { "arg_eq", "ASE_BYPASS1", 0 }, snd = 2.2, check = 1 }, --
                { text = "SWIVEL switch to LOCK", cond = { "arg_eq", "STEER_SWIVEL", 0 }, snd = 1.8, check = 1 }, --
                { text = "Check STEER knob is centered", cond = { "arg_eq", "STEER_KNOB", 0 }, snd = 2, check = 1 }, --
                { text = "Set Control Audio Panels as required", cond = { "skip" }, snd = 4.2, check = 1 }, --
                { text = "ARC-186 Mode Select to TR", cond = { "arg_eq", "ARC186_MODE", 0.1 }, snd = 3, check = 1 }, --
                { text = "ARC-186 frequency as required", cond = { "skip" }, snd = 4.5, check = 1 }, --
            },
            next_state = "coldstart-apu-start",
        },
        ["coldstart-apu-start"] = {
            text = "APU Start",
            snd = 6,
            needAllPrevious = true,
            conditions = {
                { text = "ANTI COL to BOTH FAA", cond = { "arg_gt", "OCLP_ANTICOL_MODE", 0.59 }, snd = 2.2, check = 1 }, -- CP
                { text = "BATT to ON", cond = { "arg_eq", "OCEP_BATT", 1 }, snd = 2.2, check = 1 }, -- CP
                { text = "TROOP WARN to ON", cond = { "arg_eq", "OCTW_ALARM", 1 }, onlyOnce = true, snd = 3.2 }, -- CP
                { text = "TROOP WARN to OFF", cond = { "arg_eq", "OCTW_ALARM", 0 }, snd = 4.5, check = 1 }, -- CP
                { text = "Check JUMP LT RED", cond = { "arg_eq", "OCTW_LT", 0.2 }, onlyOnce = true, snd = 3 }, -- CP
                { text = "Check JUMP LT GREEN", cond = { "arg_eq", "OCTW_LT", 0 }, onlyOnce = true, check = 1 }, -- CP
                { text = "JUMP LT to OFF", cond = { "arg_eq", "OCTW_LT", 0.1 }, onlyOnce = true, snd = 2, check = 1 }, -- CP
                { text = "Fireguard Posted", cond = { "skip" }, snd = 5, hide = true },
                { text = "Flight Engineer confirm Posted", cond = { "skip" }, snd = 3, seat = "plt", hide = true },
                { text = "Confirm Fireguard Posted", cond = { "skip" }, snd = 2, seat = "fe" },
                { text = "Check UTIL PRES Light ON", cond = { "skip" }, snd = 2, check = 1 }, -- CP
                { text = "APU to RUN, hold 5sec", cond = { "arg_eq", "OCEP_APU", 0.1 }, duration = 5, onlyOnce = true, snd = 3 }, -- CP
                { text = "APU to START, hold 2sec", cond = { "arg_eq", "OCEP_APU", 0.2 } , duration = 2, onlyOnce = true, snd = 3 }, -- CP
                { text = "Release APU to RUN", cond = { "arg_eq", "OCEP_APU", 0.1 }, snd = 2.5, check = 1 }, -- CP
                { text = "Check APU RDY Light ON", cond = { "skip" }, snd = 2, check = 1 },
                { text = "Check UTIL PRES Light OFF", cond = { "skip" }, snd = 2.3, check = 1 }, -- Verify off within 30 seconds after APU RDY light illuminates.
                { text = "GEN APU to ON", cond = { "arg_eq", "OCEP_GEN_APU", 0.2 }, snd = 2, check = 1 }, -- CP
                { text = "WCA APU ON active", cond = { "any_ind_eq", 8, "APU ON" } }, -- PLT/CP
                { text = "WCA APU ON active", cond = { "any_ind_eq", 8, "APU ON" }, snd = 1.7, hide = true },
                { text = "WCA #1/#2 RECT OFF not active", cond = { "no_ind_eq", 8, "#1 RECT OFF", "no_ind_eq", 8, "#2 RECT OFF" } }, -- PLT/CP
                { text = "WCA #1/#2 RECT OFF not active", cond = { "no_ind_eq", 8, "#1 RECT OFF", "no_ind_eq", 8, "#2 RECT OFF" }, snd = 2.5, hide = true },
                { text = "WCA UTIL HYD PRES LO not active", cond = { "no_ind_eq", 8, "UTIL HYD PRES LO" } }, -- PLT/CP within 30 seconds of APU RDY light illuminating
                { text = "WCA UTIL HYD PRES LO not active", cond = { "no_ind_eq", 8, "UTIL HYD PRES LO" }, snd = 2.5, hide = true },
                { text = "dummy", cond = { "skip" }, hide = true }
            },
            next_state = "coldstart-after-apu-start",
        },
        ["coldstart-after-apu-start"] = {
            text = "After APU Start",
            conditions = {
                { text = "Set MFD 1 (CP) to VSD/FUEL (Half)", cond = { "ind_eq", 6, "BezKeyLabel_18_Lbl_HALF_text", "HALF", "ind_eq", 6, "fuelPageTitle", "FUEL (LBS)" }, snd = 5.5 },
                { text = "Set MFD 2 (CP) to POWER TRAIN (Full)", cond = { "ind_eq", 7, "BezKeyLabel_18_Lbl_FULL_text", "FULL", "ind_eq", 7, "pwrTrainPageTitle", "POWER TRAIN" } },
                { text = "Set MFD 3 (PLT) to POWER TRAIN (Full)", cond = { "ind_eq", 9, "BezKeyLabel_18_Lbl_FULL_text", "FULL", "ind_eq", 9, "pwrTrainPageTitle", "POWER TRAIN" } },
                { text = "Set MFD 4 (PLT) to VSD/HSDH (Half)", cond = { "ind_eq", 10, "BezKeyLabel_18_Lbl_HALF_text", "HALF", "ind_eq", 10, "HSI_hdg_scale_center", "children are {" } },
                { text = "Set MFD 5 (CTR) to WCA (Full)", cond = { "ind_eq", 8, "BezKeyLabel_18_Lbl_FULL_text", "FULL", "ind_eq", 8, "ADVISORIES_title", "ADVISORY SUMMARY" }, check = 1 },
                { text = "PWR XFER 1 and PWR XFER 2 to ON", cond = { "arg_eq", "OCHC_PTU_1", 1, "arg_eq", "OCHC_PTU_2", 1 }, snd = 3.5, check = 1 }, -- CP
                { text = "WCA #1/#2 HYD FLT CONTR not active", cond = { "no_ind_eq", 8, "#1 HYD FLT CONTR", "no_ind_eq", 8, "#2 HYD FLT CONTR" }, snd = 3.5, check = 1 }, -- CP
                { text = "Hold LAMPS TEST and check lights ON", cond = { "arg_eq", "LAMPS_TEST", 1 }, duration = 1, onlyOnce = true, snd = 3.0, check = 1 }, -- PLT/CP
                { text = "Release LAMPS TEST and check lights OFF", cond = { "arg_eq", "LAMPS_TEST", 0 }, needPrevious = true, snd = 3.0, check = 1 }, -- PLT/CP
                { text = "Check Cyclic full forward", cond = { "arg_gt", "PITCH", 0.95 }, onlyOnce = true, snd = 7 },
                { text = "Check Cyclic full left", cond = { "arg_gt", "ROLL", 0.95 }, onlyOnce = true },
                { text = "Check Cyclic full back", cond = { "arg_lt", "PITCH", -0.95 }, onlyOnce = true },
                { text = "Check Cyclic full right", cond = { "arg_lt", "ROLL", -0.95 }, onlyOnce = true },
                { text = "Check Thrust Control Lever full up", cond = { "arg_gt", "COLLECTIVE", 0.95 }, onlyOnce = true },
                { text = "Check Thrust Control Lever full down", cond = { "arg_eq", "COLLECTIVE", 0 }, needPrevious = true, onlyOnce = true },
                { text = "Check Pedals full left", cond = { "arg_lt", "PEDALS", -0.95 }, onlyOnce = true },
                { text = "Check Pedals full right", cond = { "arg_gt", "PEDALS", 0.95 }, onlyOnce = true, check = 1 },
            },
            next_state = "coldstart-before-engine-start",
        },
        ["coldstart-before-engine-start"] = {
            text = "Before Engine Start",
            needAllPrevious = true,
            snd = 4,
            conditions = {
                { text = "FADEC B/U PWR to ON", cond = { "arg_eq", "OCFC_BU_PWR", 1 }, snd = 2, check = 1 }, -- CP
                { text = "WCA ENG1 FAIL and ENG2 FAIL not active", cond = { "no_ind_eq", 8, "ENG1 FAIL", "no_ind_eq", 8, "ENG2 FAIL" }, snd = 3.2, check = 1 },
                { text = "WCA ENG1 FADEC and ENG2 FADEC not active", cond = { "no_ind_eq", 8, "ENG1 FADEC", "no_ind_eq", 8, "ENG2 FADEC" }, snd = 3.2, check = 1 },
                { text = "WCA REV1 FAIL and REV2 FAIL not active", cond = { "no_ind_eq", 8, "REV1 FAIL", "no_ind_eq", 8, "REV2 FAIL" }, snd = 3.5, check = 1 },
                { text = "Move ENG1 COND to GROUND", cond = { "arg_between", "OCEC_ENG1", 0.45, 0.55 }, onlyOnce = true, snd = 2.5, check = 1 }, -- CP
                { text = "Move ENG2 COND to GROUND", cond = { "arg_between", "OCEC_ENG2", 0.45, 0.55 }, onlyOnce = true, snd = 2.5, check = 1 }, -- CP
                { text = "Check FE DECU fault code 88", cond = { "skip" }, snd = 2, hide = 1 },
                { text = "Request DECU fault code check", cond = { "skip" }, snd = 3, seat = "plt", hide = 1 }, -- FE
                { text = "Check FE DECU fault code 88", cond = { "skip" }, snd = 2, seat = "fe" }, -- FE
                { text = "Move ENG COND levers to STOP", cond = { "arg_eq", "OCEC_ENG1", 0, "arg_eq", "OCEC_ENG2", 0 }, snd = 2, check = 1 }, -- CP
                { text = "Ignition Lock switch to ON", cond = { "skip" }, snd = 2, check = 1 }, -- PLT
                { text = "Check FE Area clearance", cond = { "skip" }, snd = 4, hide = 1 },
                { text = "Check FE Area clearance", cond = { "skip" }, snd = 3, seat = "fe" },
                { text = "Set searchlights as required", cond = { "skip" }, snd = 2, check = 1 }, -- PLT/CP
            },
            next_state = "coldstart-engine-start",
        },
        ["coldstart-engine-start"] = {
            text = "Engine Start",
            needAllPrevious = true,
            snd = 5.5,
            conditions = {
                { text = "FUEL ENG1 MAIN AFT/FWD to ON", cond = { "arg_eq", "OCFC_ENG1_MAIN2", 1, "arg_eq", "OCFC_ENG1_MAIN1", 1 }, snd = 3.5, check = 1 }, -- CP
                { text = "WCA ENG1 FUEL PRESS LO not active", cond = { "no_ind_eq", 8, "ENG1 FUEL PRESS LO" }, snd = 3.2, check = 1 }, -- CP
                { text = "XFEED switch to OPEN", cond = { "arg_eq", "OCFC_XFEED", 1 }, snd = 1.2, check = 1 }, -- CP
                { text = "WCA ENG2 FUEL PRESS LO not active", cond = { "no_ind_eq", 8, "ENG2 FUEL PRESS LO" }, snd = 2.4, check = 1 }, -- CP
                { text = "Move ENG COND ENG1 to GROUND", cond = { "arg_between", "OCEC_ENG1", 0.45, 0.55 }, onlyOnce = true, snd = 3.5, check = 1 }, -- CP
                { text = "Hold ENG START 1 until NG1 > 12%", cond = { "arg_eq", "OCFC_ENG_START", -1, "param_gt", "BASE_SENSOR_LEFT_ENGINE_RPM", 0.12 }, onlyOnce = true, snd = 3.0 },
                { text = "Release ENG START 1", cond = { "arg_eq", "OCFC_ENG_START", 0 }, onlyOnce = true, snd = 1.8 },
                { text = "Wait for NG1 > 55%", cond = { "param_gt", "BASE_SENSOR_LEFT_ENGINE_RPM", 0.55 }, snd = 3.2, check = 1 },
                { text = "FUEL ENG2 MAIN AFT/FWD to ON", cond = { "arg_eq", "OCFC_ENG2_MAIN2", 1, "arg_eq", "OCFC_ENG2_MAIN1", 1 }, snd = 3.2, check = 1 },
                { text = "Move ENG COND ENG2 to GROUND", cond = { "arg_between", "OCEC_ENG2", 0.45, 0.55 }, onlyOnce = true, snd = 3, check = 1 },
                { text = "Hold ENG START 2 until NG2 > 12%", cond = { "arg_eq", "OCFC_ENG_START", 1, "param_gt", "BASE_SENSOR_RIGHT_ENGINE_RPM", 0.12 }, onlyOnce = true, snd = 1.7 },
                { text = "Release ENG START 2", cond = { "arg_eq", "OCFC_ENG_START", 0 }, snd = 1.3 },
                { text = "Wait for NG2 > 55%", cond = { "param_gt", "BASE_SENSOR_RIGHT_ENGINE_RPM", 0.55 }, snd = 2, check = 1 },
                { text = "Check POWER TRAIN all transmissions >= 7 PSI", cond = { "ind_gt", 9, "fwdXmsnPressTemper_pressValue", 6, "ind_gt", 9, "aftXmsnPressTemper_pressValue", 6, "ind_gt", 9, "leftXmsnPressTemper_pressValue", 6, "ind_gt", 9, "rightXmsnPressTemper_pressValue", 6, "ind_gt", 9, "combinerXmsnPressTemper_pressValue", 6 }, snd = 3.8, check = 1 },
                { text = "Move ENG COND levers to FLIGHT", cond = { "arg_gt", "OCEC_ENG1", 0.98, "arg_gt", "OCEC_ENG2", 0.98 }, onlyOnce = true, snd = 1.8, check = 1 },
                { text = "Wait for NP1/NP2 green, NR 100%", cond = { "ind_gt", 9, "txt_NP_valueLeftValid", 90, "ind_gt", 9, "txt_NP_valueRightValid", 90, "ind_gt", 9, "txt_NR_value", 98 }, snd = 5.5, check = 1 },
                { text = "GEN 1 to ON, wait 2 secs", cond = { "arg_eq", "OCEP_GEN_1", 0.2 }, duration = 2, snd = 2.5, check = 1 },
                { text = "GEN 2 to ON", cond = { "arg_eq", "OCEP_GEN_2", 0.2 }, snd = 1.2, check = 1 },
                { text = "GEN APU to OFF", cond = { "arg_eq", "OCEP_GEN_APU", 0.1 }, snd = 1.5, check = 1 },
                { text = "Retard ENG COND levers 5° to init DECU BIT", cond = { "arg_lt", "OCEC_ENG1", 0.96, "arg_lt", "OCEC_ENG2", 0.96 }, onlyOnce = true, snd = 3, check = 1 },
                { text = "Check FE DECU fault code 88", cond = { "skip" }, snd = 4, hide = 1 },
                { text = "Check FE DECU fault code 88", cond = { "skip" }, snd = 3, seat = "fe" }, -- FE
                { text = "Move ENG COND levers back to FLIGHT", cond = { "arg_gt", "OCEC_ENG1", 0.98, "arg_gt", "OCEC_ENG2", 0.98 }, snd = 2.2, check = 1 },
                { text = "PWR XFER 1 and PWR XFER 2 to OFF", cond = { "arg_eq", "OCHC_PTU_1", 0, "arg_eq", "OCHC_PTU_2", 0 }, snd = 2.7, check = 1 },
                { text = "APU to OFF", cond = { "arg_eq", "OCEP_APU", 0 }, snd = 1.3, check = 1 },
                { text = "Check Systems: NR, torque, engine, transmission, fuel, WCA", cond = { "skip" }, snd = 11 }, -- rightEngPressTemper_pressValue leftEngPressTemper_pressValue
                { text = "dummy", cond = { "skip" }, hide = 1 }
            },
            next_state = "coldstart-fuel-pumps-crossfeed-check",
        },
        ["coldstart-fuel-pumps-crossfeed-check"] = {
            text = "Fuel Pumps Crossfeed Check",
            needAllPrevious = true,
            snd = 3,
            conditions = {
                { text = "ALL FUEL PUMP switches OFF", cond = { "arg_eq", "OCFC_ENG1_MAIN1", 0, "arg_eq", "OCFC_ENG1_MAIN2", 0, "arg_eq", "OCFC_ENG2_MAIN1", 0, "arg_eq", "OCFC_ENG2_MAIN2", 0, "arg_eq", "OCFC_ENG1_FWDAUX", 0, "arg_eq", "OCFC_ENG2_FWDAUX", 0, "arg_eq", "OCFC_ENG1_AFTAUX", 0, "arg_eq", "OCFC_ENG2_AFTAUX", 0 }, onlyOnce = true, snd = 1.8, check = 1 },
                { text = "WCA ENG1 and ENG2 FUEL PRESS LO active", cond = { "any_ind_eq", 8, "ENG1 FUEL PRESS LO", "any_ind_eq", 8, "ENG2 FUEL PRESS LO" }, onlyOnce = true, snd = 3, check = 1 },
                { text = "FUEL ENG1 MAIN AFT to ON", cond = { "arg_eq", "OCFC_ENG1_MAIN2", 1 }, onlyOnce = true, snd = 2.5, check = 1 },
                { text = "WCA ENG1 and ENG2 FUEL PRESS LO not active", cond = { "no_ind_eq", 8, "ENG1 FUEL PRESS LO", "no_ind_eq", 8, "ENG2 FUEL PRESS LO" }, onlyOnce = true, snd = 3.8, check = 1 },
                { text = "FUEL ENG1 MAIN AFT to OFF", cond = { "arg_eq", "OCFC_ENG1_MAIN2", 0 }, onlyOnce = true, snd = 2.9 },
                { text = "FUEL ENG1 MAIN FWD to ON", cond = { "arg_eq", "OCFC_ENG1_MAIN1", 1 }, onlyOnce = true, check = 1 },
                { text = "WCA ENG1 and ENG2 FUEL PRESS LO not active", cond = { "no_ind_eq", 8, "ENG1 FUEL PRESS LO", "no_ind_eq", 8, "ENG2 FUEL PRESS LO" }, onlyOnce = true, snd = 3.8, check = 1 },
                { text = "FUEL ENG1 MAIN FWD to OFF", cond = { "arg_eq", "OCFC_ENG1_MAIN1", 0 }, onlyOnce = true, snd = 3.9 },
                { text = "FUEL ENG2 MAIN AFT to ON", cond = { "arg_eq", "OCFC_ENG2_MAIN2", 1 }, onlyOnce = true, check = 1 },
                { text = "WCA ENG1 and ENG2 FUEL PRESS LO not active", cond = { "no_ind_eq", 8, "ENG1 FUEL PRESS LO", "no_ind_eq", 8, "ENG2 FUEL PRESS LO" }, onlyOnce = true, snd = 3.8, check = 1 },
                { text = "FUEL ENG2 MAIN AFT to OFF", cond = { "arg_eq", "OCFC_ENG2_MAIN2", 0 }, onlyOnce = true, snd = 3.3 },
                { text = "FUEL ENG2 MAIN FWD to ON", cond = { "arg_eq", "OCFC_ENG2_MAIN1", 1 }, onlyOnce = true, check = 1 },
                { text = "WCA ENG1 and ENG2 FUEL PRESS LO not active", cond = { "no_ind_eq", 8, "ENG1 FUEL PRESS LO", "no_ind_eq", 8, "ENG2 FUEL PRESS LO" }, onlyOnce = true, snd = 3.8, check = 1 },
                { text = "XFEED switch to CLOSE", cond = { "arg_eq", "OCFC_XFEED", 0 }, onlyOnce = true, snd = 1.3, check = 1 },
                { text = "WCA ENG1 and ENG2 FUEL PRESS LO active", cond = { "any_ind_eq", 8, "ENG1 FUEL PRESS LO", "any_ind_eq", 8, "ENG2 FUEL PRESS LO" }, onlyOnce = true, snd = 3, check = 1 },
                { text = "ALL AUX PUMP switches ON", cond = { "arg_eq", "OCFC_ENG1_FWDAUX", 1, "arg_eq", "OCFC_ENG2_FWDAUX", 1, "arg_eq", "OCFC_ENG1_AFTAUX", 1, "arg_eq", "OCFC_ENG2_AFTAUX", 1 }, onlyOnce = true, snd = 2.9, check = 1 },
                { text = "WCA All AUX PRESS messages not active", cond = { "skip" }, onlyOnce = true, snd = 3, check = 1 },
                { text = "ALL FUEL PUMP switches ON", cond = { "arg_eq", "OCFC_ENG1_MAIN1", 1, "arg_eq", "OCFC_ENG1_MAIN2", 1, "arg_eq", "OCFC_ENG2_MAIN1", 1, "arg_eq", "OCFC_ENG2_MAIN2", 1 }, onlyOnce = true, snd = 2, check = 1 },
                { text = "XFEED switch to CLOSE", cond = { "arg_eq", "OCFC_XFEED", 0 }, onlyOnce = true, snd = 1.3, check = 1 },
                { text = "WCA ENG1 and ENG2 FUEL PRESS LO not active", cond = { "no_ind_eq", 8, "ENG1 FUEL PRESS LO", "no_ind_eq", 8, "ENG2 FUEL PRESS LO" }, onlyOnce = true, snd = 3.8, check = 1 },
                { text = "WCA All AUX PRESS messages not active", cond = { "skip" }, onlyOnce = true, snd = 3, check = 1 },
            },
            next_state = "coldstart-fadec-reversionary-system-check",
        },
        ["coldstart-fadec-reversionary-system-check"] = {
            text = "FADEC Reversionary System Check",
            needAllPrevious = true,
            snd = 13,
            conditions = {
                { text = "FADEC 1/2 PRI/REV switches to PRI", cond = { "skip" } }, --"arg_eq", "OCFC_MODE_1", 1, "arg_eq", "OCFC_MODE_2", 1 }, onlyOnce = true },
                { text = "FADEC NR% knob to 100", cond = { "skip" } }, --
                { text = "FADEC 1 PRI/REV to REV", cond = { "skip" } }, -- "arg_eq", "OCFC_MODE_1", 0 }, onlyOnce = true },
                { text = "WCA ENG1 FADEC active", cond = { "skip" } }, -- "skip" }, onlyOnce = true },
                { text = "FADEC 1 INC/DEC switch to DEC", cond = {  "skip" } }, --"arg_eq", "OCFC_NR_1", -1 }, onlyOnce = true },
                { text = "Check decrease in engine 1 NG and torque, increase in engine 2", cond = { "skip" } },
                { text = "FADEC 1 INC/DEC switch to INC", cond = { "skip" } }, -- "arg_eq", "OCFC_NR_1", 1 }, onlyOnce = true },
                { text = "Check increase in engine 1 NG and torque, decrease in engine 2", cond = { "skip" } },
                { text = "FADEC 1 PRI/REV to PRI", cond = { "skip" } }, -- "arg_eq", "OCFC_MODE_1", 1 } , onlyOnce = true},
                { text = "WCA ENG1 FADEC active", cond = { "skip" }, onlyOnce = true },
                { text = "FADEC 2 PRI/REV to REV", cond = { "skip" } }, -- "arg_eq", "OCFC_MODE_2", 0 }, onlyOnce = true },
                { text = "WCA ENG2 FADEC active", cond = { "skip" }, onlyOnce = true },
                { text = "FADEC 2 INC/DEC switch to DEC", cond = { "skip" } }, -- "arg_eq", "OCFC_NR_2", -1 }, onlyOnce = true },
                { text = "Check decrease in engine 1 NG and torque, increase in engine 2", cond = { "skip" } },
                { text = "FADEC 2 INC/DEC switch to INC", cond = {  "skip" } }, --"arg_eq", "OCFC_NR_2", 1 }, onlyOnce = true },
                { text = "Check increase in engine 1 NG and torque, decrease in engine 2", cond = { "skip" } },
                { text = "FADEC 2 PRI/REV to PRI", cond = { "skip" } }, -- "arg_eq", "OCFC_MODE_2", 1 } },
                { text = "WCA ENG2 FADEC not active", cond = { "skip" } },
            },
            next_state = "coldstart-complete",
        },
        ["coldstart-complete"] = {
            text = "Cold start complete",
        },

        -- Taxi
        ["taxi-before-taxi"] = {
            text = "Before Taxi",
            conditions = {
            { text = "Set MFDs 2+3 to POWER TRAIN", cond = { "ind_eq", 7, "pwrTrainPageTitle", "POWER TRAIN", "ind_eq", 9, "pwrTrainPageTitle", "POWER TRAIN" } },
            --     1. SWIVEL switch – As required.
            { text = "SWIVEL switch to LOCK", cond = { "arg_eq", "STEER_SWIVEL", 0 } }, --
            --     2. AFCS control panel – As required.
            --     3. Cyclic Trim indicators – Verify in GND positions.
            --     4. MFDs – Configure as necessary for taxi.
            --     5. Chocks – Remove and secure.
            --     6. Tail ramp and cabin door – As required.
            --     7. Crew, passengers, and mission equipment – Verify ready for taxi.
            --     8. HUD – Adjust as necessary.
            --     9. Parking brake – Release by applying wheel brake pressure; ensure Parking Brake handle is inward                
            }
        },
        ["taxi-ground-taxi"] = {
            text = "Taxi",
        },

        -- Takeoff
        ["takeoff-before-takeoff"] = {
            text = "Before Takeoff",
        },

        ["landing-before-landing"] = {
            text = "Before Landing",
        },

        -- Shutdown
        ["shutdown-after-landing-check"] = {
            text = "After Landing Check",
        },
        ["shutdown-aircraft-shutdown"] = {
            text = "Aircraft Shutdown",
        },
        ["shutdown-complete"] = {
            text = "Shutdown complete",
        },
    },
    args = {
        OCFC_ENG1_FWDAUX = 1,
        OCFC_ENG1_MAIN1 = 2,
        OCFC_ENG1_MAIN2 = 3,
        OCFC_ENG1_AFTAUX = 4,
        OCFC_ENG2_FWDAUX = 5,
        OCFC_ENG2_MAIN1 = 6,
        OCFC_ENG2_MAIN2 = 7,
        OCFC_ENG2_AFTAUX = 8,
        OCFC_REFUEL = 9,
        OCFC_XFEED = 10,
        OCHC_FLT_CONTR = 493,
        OCHC_PTU_1 = 494,
        OCHC_PTU_2 = 495,
        OCHC_PWR_STEER_COVER = 496,
        OCHC_PWR_STEER = 497,
        OCHC_RAMP = 498,
        OCHC_RAMP_EMER_COVER = 499,
        OCHC_RAMP_EMER = 500,
        OCPS_ENG1_FAN = 501,
        OCPS_ENG1_DOOR = 502,
        OCPS_ENG2_FAN = 503,
        OCPS_ENG2_DOOR = 504,
        OCLP_ANTICOL_MODE = 512,
        OCAI_CPLT = 527,
        OCAI_CTR = 528,
        OCAI_PLT = 529,
        OCAI_PITOT = 530,
        OCEC_ENG1 = 534,
        OCEC_ENG1_2 = 536,
        OCEC_ENG2 = 535,
        OCEC_ENG2_2 = 537,
        OCTW_LT = 541,
        OCTW_ALARM = 542,
        OCTW_HTR_TEMP = 543,
        OCTW_HTR_MODE = 544,
        OCTW_HTR_START = 545,
        OCCH_HOIST_MASTER = 551,
        OCCH_HOOK_MASTER = 552,
        OCCH_HOOK_SELECTOR = 553,
        OCCH_EMER_COVER = 554,
        OCCH_EMER = 555,
        OCEP_GEN_1 = 556,
        OCEP_GEN_2 = 557,
        OCEP_GEN_APU = 558,
        OCEP_BATT = 559,
        OCEP_APU = 560,
        OCEP_APU_2 = 561,
        OCFC_MODE_1 = 564,
        OCFC_MODE_2 = 565,
        OCFC_NR_1 = 566,
        OCFC_NR_2 = 567,
        OCFC_BU_PWR = 568,
        OCFC_OSPD = 569,
        OCFC_LOAD = 570,
        OCFC_ENG_START = 571,
        OCFC_NR = 572,
        AFCS_FLT_DIR = 574,
        AFCS_FWD = 576,
        AFCS_AFT = 577,
        AFCS_MODE = 578,
        AFCS_SYSTEM = 579,
        CDU_1_DIMMER = 580,
        CDU_2_DIMMER = 581,
        LAMPS_TEST = 582,
        EAUX_RADIO_MODE = 583,
        EAUX_IFF_IDENT = 584,
        EAUX_EMER = 585,
        EAUX_ZERO = 586,
        STEER_SWIVEL = 587,
        STEER_KNOB = 589,
        FIRE_PULL_L = 731,
        FIRE_PULL_R = 733,
        MAIN_RALT_DIMMER = 739,
        MAIN_PARKING_BRAKE = 741,
        PITCH = 744,
        ROLL = 745,
        PEDALS = 746,
        COLLECTIVE = 747,
        LBRAKE = 752,
        RBRAKE = 753,
        OCTW_WIPER = 756,
        MFD_CL_PWR = 794,
        MFD_CR_PWR = 830,
        MFD_CTR_PWR = 866,
        MFD_PL_PWR = 902,
        MFD_PR_PWR = 938,
        RAMP = 1190,
        ARC186_MODE = 1224,
        ASE_JETT_COVER = 1444,
        ASE_JETT = 1445,
        ASE_ARM = 1446,
        ASE_BYPASS1 = 1447,
        ASE_VOL = 1448,
        MISC_CGI_TEST = 1465,
        MISC_BKUP_RAD = 1466,
        MISC_ANT_SEL = 1467,
    },
    excludeDebugArgs = {
        [619] = true,
        [652] = true,
        [685] = true,
        [718] = true,
        [1042] = true,
        [1043] = true,
        [1046] = true,
        [1047] = true,
        [1094] = true,
        [1127] = true,
    },
    params = {
        "BASE_SENSOR_FUEL_TOTAL",
        "BASE_SENSOR_HORIZONTAL_ACCEL",
        "BASE_SENSOR_LATERAL_ACCEL",
        "BASE_SENSOR_LEFT_ENGINE_RPM",
        "BASE_SENSOR_LEFT_GEAR_DOWN",
        "BASE_SENSOR_LEFT_GEAR_UP",
        "BASE_SENSOR_MAG_HEADING",
        "BASE_SENSOR_NOSE_GEAR_DOWN",
        "BASE_SENSOR_NOSE_GEAR_UP",
        "BASE_SENSOR_PITCH_RATE",
        "BASE_SENSOR_PROPELLER_PITCH",
        "BASE_SENSOR_PROPELLER_RPM",
        "BASE_SENSOR_PROPELLER_TILT",
        "BASE_SENSOR_RADALT",
        "BASE_SENSOR_RIGHT_GEAR_DOWN",
        "BASE_SENSOR_RIGHT_GEAR_UP",
        "BASE_SENSOR_ROLL_RATE",
        "BASE_SENSOR_TAS",
        "BASE_SENSOR_VERTICAL_ACCEL",
        "BASE_SENSOR_VERTICAL_SPEED",
        "BASE_SENSOR_WOW_LEFT_GEAR",
        "BASE_SENSOR_WOW_NOSE_GEAR",
        "BASE_SENSOR_WOW_RIGHT_GEAR",
        "BASE_SENSOR_YAW_RATE",
    },
    indications = {
        [0] = { -- cdu left
        },
        [1] = { -- cdu right
        },
        [4] = { -- vpm1
        },
        [5] = { -- vpm2
        },
        [6] = { -- mfd cp l
        },
        [7] = { -- mfd cp r
        },
        [8] = { -- mfd center
        },
        [9] = { -- mfd p l
        },
        [10] = { -- mfd p r
        },
        [16] = { -- sfd1
        },
        [18] = { -- sfd2
        },
        [20] = { -- controls
        },
        [21] = { -- cargo
        },
        [22] = { -- chrono 11d
        },
        [23] = { -- decu1 2d digital electronic control units
        },
        [24] = { -- decu2 2d
        },
        [25] = { -- apr39 rwr
        },
    },
    commands = {},
}

-- apr39 rwr
-- aar57 cmws
-- ale47 icmds
-- apn209 radar altimeter
-- vpm1/2 video processing module
