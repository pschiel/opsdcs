OpsdcsCrew["UH-1H"] = {
    options = {
        showHighlights = false,
        playSounds = false,
    },
    procedures = {
        {
            name = "Cold Start",
            start_state = "coldstart-before-engine-start",
        },
    },
    states = {
        -- Cold Start
        ["coldstart-before-engine-start"] = {
            text = "Before Engine Start",
            needAllPrevious = true,
            conditions = {
                { text = "DC circuit breakers IN, except armament/special equip", cond = { "skip" } }, -- why except?
                { text = "ANTI-COLL to ON, DOME LT as required", cond = { "arg_eq", "ANTI-COLL-PTR", 1 } },
                { text = "AC Voltmeter to AC PHASE", cond = { "arg_eq", "PHASE-SWITCHER-PTR", 0.1 } },
                { text = "AC INVTR switch to OFF", cond = { "arg_eq", "INVTR-SWITCHER-PTR", 0 } },
                { text = "DC MAIN GEN switch to ON, cover down", cond = { "arg_eq", "MAIN-GEN-SWITCHER-PTR", -1, "arg_eq", "MAIN-GEN-SWITCHER-COVER-PTR", 0 } },
                { text = "DC VM selector to ESS BUS", cond = { "arg_eq", "VM-SWITCHER-PTR", 0.3 } },
                { text = "DC NON-ESS BUS switch to NORMAL", cond = { "arg_eq", "NON-ESS-BUS-SWITCHERr-PTR", 0 } },
                { text = "DC STARTER GEN switch to START", cond = { "arg_eq", "STARTER-GEN-SWITCHERr-PTR", 1 } },
                { text = "DC BAT switch ON", cond = { "arg_eq", "BAT-SWITCHER-PTR", 0 } },
                { text = "Set LOW RPM to OFF", cond = { "arg_eq", "LOW-RPM-PTR", 0  } },
                { text = "Test FIRE warning indicator light", cond = { "arg_eq", "FIRE-DETECTOR-PTR", 1 }, onlyOnce = true },
                { text = "Caution panel lights TEST, check lights", cond = { "arg_eq", "RESET-TEST-SWITCH-PTR", -1 }, onlyOnce = true },
                { text = "Caution panel lights RESET", cond = { "arg_eq", "RESET-TEST-SWITCH-PTR", 1 }, onlyOnce = true },
                { text = "Check external stores jettison handle safe tied", cond = { "skip" } }, --??
                { text = "Check ARM/STBY/SAFE switch is SAFE", cond = { "arg_eq", "ARMED-SWITCH-PTR", -1 } },
                { text = "Check JETTISON switch down and covered", cond = {"arg_eq", "JETT-COVER-PTR", 0, "arg_eq", "JETT-SWITCH-PTR", 0 } },
                { text = "GOV switch to AUTO", cond = { "arg_eq", "GOV-PTR", 1 } },
                { text = "DE-ICE switch to OFF", cond = { "arg_eq", "DE-ICE-PTR", 0 } },
                { text = "MAIN FUEL switch to ON", cond = { "arg_eq", "FUEL-PTR", 1 } },
                { text = "All other FUEL switches to OFF", cond = { "skip" } },
            },
            next_state = "coldstart-flight-controls-check",
        },
        ["coldstart-flight-controls-check"] = {
            text = "Flight Controls Check",
            conditions = {
                { text = "HYD CONT switch to ON", cond = { "arg_eq", "HYD-CONT-PTR", 1 } },
                { text = "FORCE TRIM switch to ON", cond = { "arg_eq", "FORCE-TRIM-PTR", 1 }, needAllPrevious = true },
                { text = "CHIP DET switch to BOTH", cond = { "arg_eq", "CHIP-DET-PTR", 0 }, needAllPrevious = true },
                { text = "Move cyclic full forward", cond = { "arg_lt", "PITCH", -0.9 }, onlyOnce = true },
                { text = "Move cyclic full left", cond = { "arg_lt", "ROLL", -0.65 }, onlyOnce = true },
                { text = "Move cylic full back", cond = { "arg_gt", "PITCH", 0.9 }, onlyOnce = true },
                { text = "Move cyclic full right", cond = { "arg_gt", "ROLL", 0.65 }, onlyOnce = true },
                { text = "Move pedals full left", cond = { "arg_lt", "RUDDER", -0.8 }, onlyOnce = true },
                { text = "Move pedals full right", cond = { "arg_gt", "RUDDER", 0.8 }, onlyOnce = true },
                { text = "Move collective full up", cond = { "arg_gt", "COLLECTIVE", 0.9 }, onlyOnce = true },
                { text = "Move collective full down", cond = { "arg_lt", "COLLECTIVE", 0.05 }, needAllPrevious = true },
                { text = "Center cyclic and pedals", cond = { "arg_between", "ROLL", -0.05, 0.05, "arg_between", "PITCH", -0.05, 0.05, "arg_between", "RUDDER", -0.05, 0.05 }, needAllPrevious = true },
            },
            next_state = "coldstart-starting-engine",
        },
        ["coldstart-starting-engine"] = {
            text = "Engine Start",
            needAllPrevious = true,
            conditions = {
                { text = "Roll throttle to FULL OPEN", cond = { "arg_eq", "THROTTLE-1-PTR", -1 }, onlyOnce = true },
                { text = "Roll throttle back to IDLE STOP", cond = { "arg_eq", "THROTTLE-1-PTR", 0 }, onlyOnce = true },
                { text = "Hold START switch, wait for N1 reaching 15%", cond = { "arg_gt", "GasProduceTachRPM", 0.135 }, onlyOnce = true },
                { text = "Check main rotor is turning", cond = { "param_gt", "BASE_SENSOR_PROPELLER_RPM", 0 } },
                { text = "Wait for N1 reaching 40%", cond = { "arg_gt", "GasProduceTachRPM", 0.36 } },
                { text = "Release START switch", cond = { "skip" } }, -- no arg?
                { text = "Wait for N1 reaching >60%", cond = { "arg_gt", "GasProduceTachRPM", 0.56 } },
                { text = "INVTR switch to MAIN ON", cond = { "arg_eq", "INVTR-SWITCHER-PTR", -1 } },
                { text = "STARTER GEN switch to STBY GEN", cond = { "arg_eq", "STARTER-GEN-SWITCHERr-PTR", 0 } },
                { text = "Advance throttle slowly to FULL", cond = { "arg_eq", "THROTTLE-1-PTR", -1 } },
                { text = "Check FUEL PRESS 5-35 PSI", cond = { "arg_between", "FuelPress", 5/50, 35/50 } },
                { text = "Check ENGINE OIL >60 PSI and temp 0-100 C", cond = { "arg_gt", "EngOilPress", 0.6, "arg_between", "EngOilTemp", 0.38, 0.71 } },
                { text = "Check TRANS OIL 40-70 PSI and temp 0-100 C", cond = { "arg_between", "TransmOilPress", 0.4, 0.7, "arg_between", "TransmOilTemp", 0.38, 0.71 } },
                { text = "Check EXH TEMP 400-610 C", cond = { "arg_between", "ExhaustTemp", 0.4, 0.6 } },
                { text = "Check AC voltage 112-118 V", cond = { "arg_between", "AC_voltage", 112/150, 118/150 } },
                { text = "Check DC voltage 27-28.5 V", cond = { "arg_between", "DC_voltage", 27/30, 28.5/30 } },
                { text = "Check RPM warning reset at 6100-6300 RPM", cond = { "arg_gt", "EngineTach", 6100/7200, "arg_eq", "LOW-RPM-PTR", 1 } },
                { text = "Wait for RPM reach 6600", cond = { "arg_gt", "EngineTach", 6600/7200 } },
            },
            next_state = "coldstart-setup-avionics",
        },
        ["coldstart-setup-avionics"] = {
            text = "Setup Avionics",
            conditions = {
                { text = "Set baro altimeter to field elevation", cond = { "skip" } }, -- BASE_SENSOR_BAROALT = terrain height
                { text = "Sync gyro compass to magnetic heading", cond = { "skip" } },
                { text = "Radar altimeter power to ON", cond = { "arg_eq", "RADAR-ALT-PTR", 1 } },
                { text = "Radar altimeter LO and HIGH as required", cond = { "skip" } },
                { text = "IFF MASTER to NORM", cond = { "arg_eq", "MASTER-CONTROL-PTR", 0.3 } },
                { text = "IFF MODE 4 to ON", cond = { "arg_eq", "MODE-4-SWITCH-PTR", 1 } },
                { text = "Set NAV COMM as required", cond = { "skip" } },
                { text = "Set VHF COMM PWR to ON", cond = { "arg_eq", "MHZ-SELECTOR-PTR", 1 } },
                { text = "Set FM COMM Mode to T/R", cond = { "arg_eq", "MODE-SWITCH-PTR", 0.1  } },
                { text = "Set ADF Mode as required ", cond = { "skip" } },
                { text = "Set UHF Mode to T/R", cond = { "arg_between", "FUNCTION-SELECT-SWITCH-PTR", 0.1, 0.2 } },
            },
            next_state = "coldstart-complete"
        },
        ["coldstart-complete"] = {
            text = "Cold start complete",
        },
    },
    args = {
        ["MHZ-SELECTOR-PTR"]  = 5,
        ["KHZ-SELECTOR-PTR"] = 9,
        ["FUNCTION-SELECT-SWITCH-PTR"] = 17,
        ["MODE-SWITCH-PTR"] = 35,
        ["TUNE-CONTROL-PTR"] = 39,
        ["BFO-SWITCH-PTR"] = 41,
        ["GAIN-CONTROL-PTR"] = 44,
        ["WHOLE-MHZ-SELECTOR-KNOB-PTR"]  = 52,
        ["FRACTIONAL-MHZ-SELECTOR-KNOB-KNOB-PTR"] = 53,
        ["VOLUME-OFF-INCR-CONTROL-PTR"]  = 57,
        ["CODE-PTR"]= 58,
        ["MASTER-CONTROL-PTR"] = 59,
        ["MODE-4-SWITCH-PTR"]= 67,
        ["LOW-RPM-PTR"] = 80,
        ["FUEL-PTR"] = 81,
        ["DE-ICE-PTR"] = 84,
        ["GOV-PTR"] = 85,
        ["CHIP-DET-PTR"] = 86,
        ["FORCE-TRIM-PTR"] = 89,
        ["HYD-CONT-PTR"] = 90,
        ["RESET-TEST-SWITCH-PTR"] = 111,
        ["EngOilPress"] = 113,
        ["EngOilTemp"] = 114,
        ["TransmOilPress"] = 115,
        ["TransmOilTemp"] = 116,
        ["IAS_Front"] = 117,
        ["IAS_Roof"] = 118,
        ["GasProduceTachRPM"] = 119,
        ["GasProduceTachRPM_Units"] = 120,
        ["ExhaustTemp"] = 121,
        ["EngineTach"] = 122,
        ["TorquePress"] = 124,
        ["FuelPress"] = 126,
        ["CAGING-KNOB-ROTATION-PTR"] = 140,
        ["PILOT-ATT-PITCH-ADJ-KNOB-PTR"] = 144,
        ["PILOT-ATT-ROLL-ADJ-KNOB-PTR"] = 145,
        ["DC_voltage"] = 149,
        ["AC_voltage"] = 150,
        ["CDI-OBS-PTR"] = 155,
        ["HDG-SYNC-PTR"] = 161,
        ["HDG-SET-PTR"] = 163,
        ["ADF-VOR-PTR"] = 164,
        ["PILOT-ALT-SET-KNOB-PTR"] = 181,
        ["RUDDER"] = 184,
        ["PITCH"] = 186,
        ["ROLL"] = 187,
        ["COLLECTIVE"] = 200,
        ["ENGINE-BTN-1-PTR"] = 206,
        ["PHASE-SWITCHER-PTR"] = 214,
        ["INVTR-SWITCHER-PTR"] = 215,
        ["MAIN-GEN-SWITCHER-PTR"] = 216,
        ["MAIN-GEN-SWITCHER-COVER-PTR"] = 217,
        ["VM-SWITCHER-PTR"] = 218,
        ["BAT-SWITCHER-PTR"] = 219,
        ["STARTER-GEN-SWITCHERr-PTR"] = 220,
        ["NON-ESS-BUS-SWITCHERr-PTR"] = 221,
        ["ANTI-COLL-PTR"] = 225,
        ["FUEL-GAUGE-PTR"] = 240,
        ["DG-SLAVE-PTR"] = 241,
        ["THROTTLE-1-PTR"] = 250,
        ["ARMED-SWITCH-PTR"] = 252,
        ["LRGUN-SWITCH-PTR"] = 253,
        ["762-SWITCH-PTR"] = 256,
        ["RKT-PAIR-PTR"] = 257,
        ["RKT-RESET-PTR"] = 258,
        ["JETT-COVER-PTR"] = 259,
        ["JETT-SWITCH-PTR"] = 260,
        ["FIRE-DETECTOR-PTR"] = 278,
        ["PITCH-LO-ALT-PTR"] = 445,
        ["PITCH-HI-ALT-PTR"] = 446,
        ["RADAR-ALT-PTR"] = 449,
        ["CHAFF-ARM-SWITCH-PTR"] = 456,
        ["PGRM-SWITCH-PTR"] = 459,
        ["FLARE-DISP-PTR"] = 464,
    },
    excludeDebugArgs = {
        [129] = true,
        [132] = true,
        [133] = true,
        [185] = true,
        [190] = true,
        [191] = true,
        [207] = true,
        [243] = true,
        [244] = true,
        [246] = true,
        [247] = true,
        [264] = true,
        [265] = true,
    },
    params = {
    },
    indications = {
        [1] = {
        },
        [2] = {
        },
        [3] = {
        }
    },
    commands = {},
}

-- ADF_FREQ:0.000000
-- BASE_SENSOR_ALTIMETER_ATMO_PRESSURE_HG:757.944141
-- BASE_SENSOR_AOA:0.038049
-- BASE_SENSOR_AOS:-0.000045
-- BASE_SENSOR_BAROALT:22.568833
-- BASE_SENSOR_CANOPY_POS:0.900000
-- BASE_SENSOR_CANOPY_STATE:1.000000
-- BASE_SENSOR_FLAPS_POS:0.000000
-- BASE_SENSOR_FLAPS_RETRACTED:1.000000
-- BASE_SENSOR_FUEL_TOTAL:629.000000
-- BASE_SENSOR_GEAR_HANDLE:0.000000
-- BASE_SENSOR_HEADING:5.846033
-- BASE_SENSOR_HELI_COLLECTIVE:0.000000
-- BASE_SENSOR_HELI_CORRECTION:0.000000
-- BASE_SENSOR_HORIZONTAL_ACCEL:0.038037
-- BASE_SENSOR_IAS:0.000002
-- BASE_SENSOR_LATERAL_ACCEL:0.001174
-- BASE_SENSOR_LEFT_ENGINE_FAN_RPM:0.000000
-- BASE_SENSOR_LEFT_ENGINE_FUEL_CONSUPMTION:0.000000
-- BASE_SENSOR_LEFT_ENGINE_RPM:0.000000
-- BASE_SENSOR_LEFT_ENGINE_TEMP_BEFORE_TURBINE:20.003303
-- BASE_SENSOR_LEFT_GEAR_DOWN:0.000000
-- BASE_SENSOR_LEFT_GEAR_UP:1.000000
-- BASE_SENSOR_LEFT_THROTTLE_POS:-1.000000
-- BASE_SENSOR_LEFT_THROTTLE_RAW_CONTROL:-1.000000
-- BASE_SENSOR_MACH:0.000000
-- BASE_SENSOR_MAG_HEADING:0.318989
-- BASE_SENSOR_NOSE_GEAR_DOWN:0.000000
-- BASE_SENSOR_NOSE_GEAR_UP:1.000000
-- BASE_SENSOR_PITCH:0.038049
-- BASE_SENSOR_PITCH_RATE:0.000000
-- BASE_SENSOR_PROPELLER_PITCH:0.470588
-- BASE_SENSOR_PROPELLER_RPM:0.000000
-- BASE_SENSOR_PROPELLER_TILT:0.000000
-- BASE_SENSOR_RADALT:1.558803
-- BASE_SENSOR_RELATIVE_TORQUE:-0.010345
-- BASE_SENSOR_RIGHT_ENGINE_FAN_RPM:0.000000
-- BASE_SENSOR_RIGHT_ENGINE_FUEL_CONSUMPTION:0.000000
-- BASE_SENSOR_RIGHT_ENGINE_RPM:0.000000
-- BASE_SENSOR_RIGHT_ENGINE_TEMP_BEFORE_TURBINE:0.000000
-- BASE_SENSOR_RIGHT_GEAR_DOWN:0.000000
-- BASE_SENSOR_RIGHT_GEAR_UP:1.000000
-- BASE_SENSOR_RIGHT_THROTTLE_POS:-1.000000
-- BASE_SENSOR_RIGHT_THROTTLE_RAW_CONTROL:-1.000000
-- BASE_SENSOR_ROLL:-0.001196
-- BASE_SENSOR_ROLL_RATE:-0.000001
-- BASE_SENSOR_RUDDER_NORMED:0.000000
-- BASE_SENSOR_RUDDER_POS:-0.000000
-- BASE_SENSOR_SPEED_BRAKE_POS:0.000000
-- BASE_SENSOR_STICK_PITCH_NORMED:0.000000
-- BASE_SENSOR_STICK_PITCH_POS:-0.000000
-- BASE_SENSOR_STICK_ROLL_NORMED:0.000000
-- BASE_SENSOR_STICK_ROLL_POS:-0.000000
-- BASE_SENSOR_TAS:0.000002
-- BASE_SENSOR_VERTICAL_ACCEL:0.999277
-- BASE_SENSOR_VERTICAL_SPEED:0.000002
-- BASE_SENSOR_WOW_LEFT_GEAR:0.000000
-- BASE_SENSOR_WOW_NOSE_GEAR:0.000000
-- BASE_SENSOR_WOW_RIGHT_GEAR:0.000000
-- BASE_SENSOR_YAW_RATE:0.000000
-- CDU_PAGE:0.000000
-- COMM1_FREQ:0.000000
-- CROSSTALKTEST:0.000000
-- EJECTION_BLOCKED_0:0.000000
-- EJECTION_BLOCKED_1:0.000000
-- EJECTION_BLOCKED_2:0.000000
-- EJECTION_BLOCKED_3:0.000000
-- EJECTION_BLOCKED_4:0.000000
-- EJECTION_BLOCKED_5:0.000000
-- EJECTION_INITIATED_0:-1.000000
-- EJECTION_INITIATED_1:-1.000000
-- EJECTION_INITIATED_2:-1.000000
-- EJECTION_INITIATED_3:-1.000000
-- EJECTION_INITIATED_4:0.000000
-- EJECTION_INITIATED_5:0.000000
-- MFD_NUM:0.000000
-- MFD_init_DEFAULT_LEVEL:0.000000
-- SEAT:0.000000
-- SFD1_INDICATOR_INDEX:0.000000
-- SFD2_INDICATOR_INDEX:0.000000
-- UHF_FREQ:251.000000
-- VHF_AM_FREQ:116.000000
-- VHF_FM_FREQ:30.000000