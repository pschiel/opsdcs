OpsdcsCrew["Ka-50_3"] = {
    options = {
        showHighlights = true,
        playSounds = false,
    },
    procedures = {
        {
            name = "Cold Start",
            start_state = "coldstart-before-startup",
        },
    },
    states = {
        -- Cold Start
        ["coldstart-before-startup"] = {
            text = "Before Startup",
            needAllPrevious = true,
            conditions = {
                -- close service hatches lctrl+w
                -- SYSTEM ACTIVATION AND CHECKS
                { text = "Set BAT1 and BAT2 to ON and covers DOWN", cond = { "arg_eq", "ENERG-AKK1-PTR", 1, "arg_eq", "ENERG-AKK2-PTR", 1, "arg_eq", "ENERG-COVER-AKK1-PTR", 0, "arg_eq", "ENERG-COVER-AKK2-PTR", 0 } },
                { text = "Set INV to AUTO", cond = { "arg_eq", "CONVERTER-PTR", 0.2 } },
                { text = "Set INT.COM to ON", cond = { "arg_eq", "COMM-PWR-AVSK-PTR", 1 } },
                -- chucks: entire radio panel, fuel qty
                { text = "(GPU) Set SPU-9 RADIO selector to GRND CREW", cond = { "arg_eq", "RADIO-RATE-PTR", 0.33 } },
                { text = "(GPU) Connect Ground Power", cond = { "skip" } },
                { text = "(GPU) Set EXT DC and EXT AC to ON", cond = { "arg_eq", "ENERG-AER-RIT-PTR", 1, "arg_eq", "RAMP-POWER-PTR", 1 } },
                { text = "Set EKRAN HUD TRANS PWR to OPER and cover DOWN", cond = { "arg_eq", "P-CONTR-VMG-HYDRO-PTR", 0, "arg_eq", "P-CONTR-VMG-HYDRO-COVER-PTR", 0 } },
                { text = "Check EKRAN FAILURE warning is OFF", cond = { "arg_eq", "P-CONTR-VMG-HYDRO-PTR", 0 }, duration = 2 },
                { text = "Press MWL, then hold MWL to initiate EKRAN SELFTEST", cond = { "arg_eq", "CSO-PTR", 0.3, "ind_match", 3, "txt_2", "SELFTEST" }, onlyOnce = true },
                { text = "Wait for test passed and EKRAN READY", cond = { "ind_match", 4, "txt_1", "READY" } },
                -- Test VMU voice
                { text = "Hold VL/ADV LAMP TEST and check all lights", cond = { "arg_eq", "CONTROL-ALARM-PTR", 1 }, onlyOnce = true },
                -- ?? Hold ENGINE EGT TEST STOP and check for > 800 C
                { text = "Set COCKPIT LIGHTING (ADI, HSI, PANEL) as required", cond = { "skip" } },
                { text = "Set ANTI-COL BEACON and BLADE TIP LIGHTS to ON", cond = { "arg_eq", "FLASHER-PTR", 1, "arg_eq", "CONTUR-LIGHT-PTR", 1 } },
                { text = "Set FORM, NAV and LAND LIGHTS as required", cond = { "skip" } },

                -- ABRIS ACTIVATION AND PNK PREP
                { text = "Set PVI-800 mode selector to OPER", cond = { "arg_eq", "PVI-SWITCH-PTR", 0.3 } },
                { text = "Enable INU NORM or INU PREC if required", cond = { "skip" } },
                { text = "Set INU and INU HEAT to ON", cond = { "arg_eq", "IKV-PTR", 1, "arg_eq", "HEAT_IKV-PTR", 1 } },
                { text = "Set PVI-800 NAV power to ON", cond = { "arg_eq", "PNK-PTR", 1 } },
                { text = "Set SAI power to ON", cond = { "arg_eq", "RES-AG-PTR", 1 } },
                { text = "Press MWL to turn off the warning", cond = { "skip" } },

                { text = "Set ABRIS power switch to ON", cond = { "arg_eq", "ABRIS-POWER_PTR", 1 } },
                { text = "Set K-041 power to ON", cond = { "arg_eq", "K-041-PTR", 1 } },
                -- HMS to on, adjust HMS-BRT

                -- FIRE EXTINGUISH TEST
                -- oper-off-test to test
                -- warn switch on
                -- test to I GR, check 5 lights, mwl+fire on
                -- test to neutral, warning off and on
                -- test to II GR, check 5 lights
                -- test to neutral, warning off and on
                -- test to III GR, check 4 lights
                -- test to neutral, warning off and on
                -- oper-off-test to oper
                -- tanks to auto
                -- Set EJECT-SEAT-SYS switches to UP and cover DOWN
                -- ?W-SYS ON?

                -- APU STARTUP
                -- request startup
                -- Close cockpit
                -- Open APU shut-off valve
                -- Turn on fwd and aft fuel tank boost pumps, check lights
                -- Select engine start-up mode START
                -- select engine/apu to apu
                -- press START 2sec 
                -- check apu on light, egt 600-720 C, apu oil p. norm green light on Р МАСЛА ВСУ

                -- MAIN ENGINES STARTUP
                -- disengage rotor brake BRAKE OFF
                -- 1) FUEL SHUTOFF LEFT open, amber LH VLV CLOSED off
                -- EEG LH governor and EEG RH to ON
                -- engine start-up to START
                -- select LH ENG on engine/apu switch
                -- press START 2sec
                -- wait GG RPM 20%, open left cutoff lever to OPEN
                -- wait for oil pressure AGB OIL PRESS green light on
                --  egt increase, rotors move at GG RPM 25%
                --  hydraulic fluid pressure increase (aux panel)
                --  at GG 60-65% RPM, START VLV light go off
                -- wait for GG RPM stabilize >60%

                -- MAIN ENGINES STARTUP 2
                -- 2) FUEL SHUTOFF RIGHT open, amber RH VLV CLOSED off
                -- select RH ENG on engine/apu switch
                -- press START
                -- wait engine RPM 20%, open right cutoff lever to OPEN
                --  egt increase
                --  hydraulic fluid pressure increase (aux panel)
                --  at GG 60-65% RPM, START VLV light go off
                -- Check ROTOR RPM 95-100%
                -- set engine start-up to CENTRAL
                -- STOP APU
                -- close APU shut-off valve, cover DOWN, APU ON / VLV OPEN / OIL P.NORM off
                -- wait for oil temp engine min 30 C, main gearbox min -15 C

                -- PRE FLIGHT TESTS
                -- collective down
                -- throttle to AUTO when engines warmed up
                -- RPM check 86-87%
                -- eng anti ice to anti-ice, EGT 60 C, GG RPM 2%, lights
                -- turn off anti ice, lights go off (or leave ON)
                -- check dust protectors: lights, egt inc 30 C, RPM inc. 0.5%
                -- check rotors anti ice system AIS, HEATING SYSTEM BIT BUTTON, 10sec ICE go ON
                -- ROTOR ANTI–ICE to ICE, check light
                -- ROTOR ANTI–ICE off, check light (or leave ON)

                -- EEG GG TEST to GAS GEN
                -- throttle to MAX
                -- increase pitch, RMP drop to 86-87%, LH/RH POWER SET LIM go ON
                -- EEG GG TEST down, close cover, LIMIT lights off
                
                -- ...
                -- rotor rpm readjustment check
                -- test cyclic, pitch, yaw, 1/3 of range, check HYD PRESS min 65 kgf/sm2

                -- FINAL CHECKS
                -- AC SYS GEN RH and LH to ON
                -- EXT DC and AC to OFF
                -- shut off GPU

                -- overhead: no warnings
                -- ekran: no warnings
                -- radar alt dangerous alt set 10
                -- radar alt TEST hold until arrow stop. check lit when needle pass alt, sound check
                -- radar alt as required
                -- HSI DH/DTA AUTO MAN as required
                -- AP bank,pitch,hdg to ON
                -- SAI uncage
                -- adi, hsi, heat
                -- center weapons/shkval/hud
                -- left radio
                -- fuel qty test
                -- PVI800 to COM
                -- DL power to ON
                -- PVI800 dl number to 1

                -- ODS ??

                -- COURSE CORRECT (accelerated or normal INU) - 3min

                -- ADF CHECK AND ADJUST
                -- ADF CHAN to departure airport channel
                -- NDB to INNER
                -- COMPASS - ANT to ANT, check inner NDB morse code
                -- COMPASS - ANT to COMPASS, check bearing to radio beacon needle to inner NDB
                -- NDB to OUTER
                -- COMPASS to ANT, check outer NDB morse code
                -- COMPASS to COMPASS, check bearing to radio beacon needle to outer NDB
                -- NDB to AUT
                -- ADF CHAN by flight plan

                -- DEFENSE SYSTEM
                -- IFF to UP
                -- UV-26 to OPER
                -- QUANT-NUM to NUM
                -- NUM SEQ to number of sequences
                -- SALVO to number ot flares in seq
                -- INTERVAL set delay between sequences
                -- QUANT-NUM to QUANT
                -- SIDE as required
                -- ABRIS to ODS page ODS NOT RDY, MWS NOT RDY, ODS STBY
                -- ABRIS to NAV page
                -- ODS ON switch to ON if required

                -- LASER WARN PREP
                -- L-140 to OPER
                -- press RESET
                -- press L-140 TEST, check laser bearing and hemisphere lit, check MWL and LASER flash
                -- press RESET

                -- INDICATION SYSTEM PREP
                -- checks: HUD NO READY (overhead) after ~3min?, red flags on gauges off, IT-23 TV display on
                -- inu check: К and Г disappear, after 3min, hud symbol, KC, АГ
                -- adjust HUD BRT, TV-BRT, TV-CONT


                -- { text = "", cond = { "arg_eq", "", 0 } },
                -- { text = "", cond = { "arg_eq", "", 0 } },
                -- { text = "", cond = { "arg_eq", "", 0 } },
                -- { text = "", cond = { "arg_eq", "", 0 } },
                -- { text = "", cond = { "arg_eq", "", 0 } },
                -- { text = "", cond = { "arg_eq", "", 0 } },
                -- { text = "", cond = { "arg_eq", "", 0 } },
                -- { text = "", cond = { "arg_eq", "", 0 } },
                -- { text = "", cond = { "arg_eq", "", 0 } },
                -- { text = "", cond = { "arg_eq", "", 0 } },
                -- { text = "", cond = { "arg_eq", "", 0 } },
            },
            next_state = "coldstart-complete",
        },
        ["coldstart-complete"] = {
            text = "Cold start complete",
        },
    },
    args = {
        ["CSO-PTR"] = 44,
        ["CONTROL-ALARM-PTR"] = 45,
        ["MAIN-ROTOR-PTR"] = 46,
        ["BKO-PTR"] = 49,
        ["GEAR-PTR"] = 65,
        ["AVAR-GEAR-PTR"] = 66,
        ["AVAR-GEAR-COVER-PTR"] = 67,
        ["Roll"] = 71,
        ["Pitch"] = 74,
        ["LampMainTransmission"] = 84,
        ["Collective"] = 104,
        ["ABRIS-POWER_PTR"] = 130,
        ["PNK-PTR"] = 222,
        ["FLASHER-PTR"] = 228,
        ["RES-AG-PTR"] = 230,
        ["LampDCGroundPower"] = 261,
        ["ENERG-AER-RIT-PTR"] = 262,
        ["ENERG-COVER-AER-RIT-PTR"] = 263,
        ["ENERG-AKK1-PTR"] = 264,
        ["ENERG-COVER-AKK1-PTR"] = 265,
        ["Rudder"] = 266,
        ["RAMP-POWER-PTR"] = 267,
        ["GEN-LEFT-PTR"] = 268,
        ["GEN-RIGHT-PTR"] = 269,
        ["CONVERTER-PTR"] = 270,
        ["FUEL-PUMP-FRONT-PTR"] = 271,
        ["FUEL-PUMP-BACK-PTR"] = 272,
        ["FUEL-PUMP-INNER-PTR"] = 273,
        ["FUEL-PUMP-OUTER-PTR"] = 274,
        ["FUEL-METER-PTR"] = 275,
        ["PAV-CRANE-ENGINE-LEFT-PTR"] = 276,
        ["PAV-CRANE-COVER-ENGINE-LEFT-PTR"] = 277,
        ["PAV-CRANE-ENGINE-RIGHT-PTR"] = 278,
        ["PAV-CRANE-COVER-ENGINE-RIGHT-PTR"] = 279,
        ["PAV-CRANE-VSU-PTR"] = 280,
        ["PAV-CRANE-COVER-VSU-PTR"] = 281,
        ["PAV-CRANE-CYKLIZATION-PTR"] = 282,
        ["PAV-CRANE-COVER-CYKLIZATION-PTR"] = 283,
        ["COMM-PWR-AVSK-PTR"] = 284,
        ["COMM-PWR-UKV-1-PTR"] = 285,
        ["COMM-PWR-UKV-2-PTR"] = 286,
        ["COMM-PWR-TLK-PTR"] = 287,
        ["COMM-PWR-UKV-TLK-PTR"] = 288,
        ["COMM-PWR-SA-TLF-PTR"] = 289,
        ["CONTUR-LIGHT-PTR"] = 296,
        ["PVI-SWITCH-PTR"] = 324,
        ["RADIO-RATE-PTR"] = 428,
        ["K-041-PTR"] = 433,
        ["P-CONTR-VMG-HYDRO-PTR"] = 452,
        ["P-CONTR-VMG-HYDRO-COVER-PTR"] = 453,
        ["IKV-PTR"] = 487,
        ["HEAT_IKV-PTR"] = 488,
        ["LeftDoor"] = 533,
        ["ENERG-AKK2-PTR"] = 543,
        ["ENERG-COVER-AKK2-PTR"] = 544,
        ["SUO-PTR"] = 547,
        ["SUO-COVER-PTR"] = 548,
        ["RightEngineThrottle"] = 557,
        ["CollectiveRPM"] = 558,
        ["CollectiveDescent"] = 560,
        ["G--PTR"] = 572,
        ["LeftEngineThrottle"] = 578,
        ["ThrottleCover"] = 579,
        ["LampACGroundPower"] = 586,
        ["CONTROL-OIL-PTR"] = 616,
        ["LAMP-PTR"] = 1001,
        ["MasterWarning"] = 1015,
        ["M_DOOR_1"] = 1020,
    },
    excludeDebugArgs = {
        70, -- clock seconds
    },
    params = {
    },
    indications = {
        [1] = {
        },
        [2] = {
        },
        [3] = {
        },
        [4] = {
            "txt_2", -- ekran warning
        },
    },
    commands = {},
}
