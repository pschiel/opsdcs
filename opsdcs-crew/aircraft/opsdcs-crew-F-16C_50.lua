-- todo: args+params, autochocks, radio menus, voices + voice checklist logic

OpsdcsCrew["F-16C_50"] = {
    procedures = {
        ["coldstart"] = {
            text = "Cold Start",
            cond = {},
            start_state = "coldstart-radio-check",
        },
        ["shutdown"] = {
            text = "Engine Shutdown",
            cond = {},
            start_state = "shutdown-start",
        },
        ["hotpit"] = {
            text = "Hot Pit",
            condition = function(self) return true end,
            start_state = "hotpit1",
        }
    },
    states = {
        ["coldstart-setup-radio"] = {
            text = "Cold Start - Before Engine Start",
            -- auto chocks here
            conditions = {
                { text = "Set up lights (ANTI COLL, rest as needed)", cond = { } },
                { text = "MAIN PWR to BATT", cond = { } },
                { text = "Check FLCS RLY light on", cond = { } },
                { text = "Set FCLS PWR TEST switch to TEST and hold", cond = { } },
                { text = "Check lights: FLCS PMG, MAIN GEN, STBY, TO FLCS", cond = { } },
                { text = "Verify FLCS PWR A, B, C, D are on", cond = { } },
                { text = "Release FCLS PWR TEST switch", cond = { } },
                { text = "C&I to BACKUP", cond = { } },
                { text = "BACKUP UHF to BOTH", cond = { } },
                { text = "HOT MIC switch to HOT MIC", cond = { } },
            },
            next_state = "coldstart-check-systems-off",
        },
        ["coldstart-check-systems-off"] = {
            text = "Cold Start - Systems Power Off Check",
            conditions = {
                { text = "MAIN PWR to OFF", cond = { } },
                { text = "EPU to OFF", cond = { } },
                { text = "ENG FEED to NORM", cond = { } },
                { text = "IFF MASTER to OFF", cond = { } },
                { text = "ECM panel all OFF", cond = { } },
                { text = "CMDS panel all OFF", cond = { } },
                { text = "MASTER ARM to OFF", cond = { } },
                { text = "LASER ARM to OFF", cond = { } },
                { text = "SNSR PWR panel all OFF", cond = { } },
                { text = "AVIONICS panel all OFF", cond = { } },
                { text = "Oxygen SUPPLY to PBG", cond = { } },
            },
            next_state = "coldstart-throttle-parking-brake-check",
        },
        ["coldstart-throttle-parking-brake-check"] = {
            text = "Cold Start - Throttle and Parking Brake Check",
            conditions = {
                { text = "MAIN PWR to BATT", cond = { } },
                { text = "Set parking brake to UP", cond = { } },
                { text = "Canopy handle down", cond = { } },
                { text = "Move throttle full foward", cond = { } },
                { text = "Check for parking brake disengaging", cond = { } },
                { text = "Move throttle back to cutoff", cond = { } },
                { text = "Set parking brake to UP", cond = { } },
                { text = "Canopy handle up", cond = { } },
                { text = "MAIN PWR to MAIN PWR", cond = { } },
                { text = "Close canopy", cond = { } },
                { text = "Canopy handle down", cond = { } },
            },
            next_state = "coldstart-overview",
        },
        ["coldstart-overview"] = {
            text = "Cold Start - Overview\n\n[F10 menu or SPACE to continue]",
            -- actions? clearmenu? menu? hasmenu? (or just all?)
            conditions = {
                { text = "Radio Check", cond = { "state_done", "coldstart-radio-check" } },
                { text = "Engine Start", cond = { "state_done", "coldstart-engine-start" } },
                { text = "EPU test", cond = { "state_done", "coldstart-epu-test" } },
                { text = "SEC check", cond = { "state_done", "coldstart-sec-check" } },
                { text = "BIT test", cond = { "state_done", "coldstart-bit-test" } },
                { text = "Trim check", cond = { "state_done", "coldstart-trim-check" } },
                { text = "Big movements", cond = { "state_done", "coldstart-big-movements" } },
                { text = "Brake check", cond = { "state_done", "coldstart-brake-check" } },
                { text = "Clear off", cond = { "state_done", "coldstart-clear-off" } },
            },
            next_state = "coldstart-complete",
        },
        ["coldstart-radio-check"] = {
            text = "Cold Start - Radio Check",
            actions = {
                -- just the timing, make compatible with manual radio
                { voice = "player", sound = "chief do you hear me", duration = 2.0 },
                { voice = "chief", sound = "loud and clear sir how me", delay = 4.0, duration = 2.0 },
                { voice = "player", sound = "loud and clear", delay = 8.0, duration = 1.0, variants = 2 },
            },
            conditions = {
                --{ text = "Perform radio check", duration = 8.0 },
                --{ text = "Confirm radio check", duration = 9.0 },
            },
            next_state = "coldstart-overview",
        },
        ["coldstart-engine-start"] = {
            text = "Cold Start - Engine Start",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-epu-test"] = {
            text = "Cold Start - EPU Test",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-sec-check"] = {
            text = "Cold Start - SEC Check",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-bit-test"] = {
            text = "Cold Start - BIT Test",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-trim-check"] = {
            text = "Cold Start - Trim Check",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-big-movements"] = {
            text = "Cold Start - Big Movements",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-brake-check"] = {
            text = "Cold Start - Brake Check",
            conditions = {},
            next_state = "coldstart-overview",
        },
        ["coldstart-clear-off"] = {
            text = "Cold Start - Clear Off",
            conditions = {},
            next_state = "coldstart-complete",
        },
        ["coldstart-complete"] = {
            text = "Cold Start - Complete",
            conditions = {},
        },

        ["shutdown-start"] = {
            text = "todo",
            conditions = {},
        },
        
        ["hotpit1"] = {
            text = "todo",
            conditions = {},
        },
    },
    args = {
        ["PTR-ANARC164-FREQMODE-416"] = 416, -- backup uhf mode
        ["PTR-ANARC164-FUNCTION-417"] = 417, -- backup uhf function
        ["PTR-AUDIO1-LVR-COMM1-430"] = 430, -- uhf pwr
        ["PTR-AUDIO1-LVR-COMM2-431"] = 431, -- vhf pwr
        ["PTR-AUDIO1-TMB-COMM1-434"] = 434, -- uhf mode
        ["PTR-AUDIO1-TMB-COMM2-435"] = 435, -- vhf mode
        ["PTR-AUDIO2-LVR-INTERCOM-440"] = 440, -- intercom
        ["PTR-AUDIO2-TMB-MODE-443"] = 443, -- hotmic
        ["PTR-ENGSTART-TMB-JETFUEL-447"] = 447, -- jfs
        ["PTR-ELEC-TMB-MPWR-510"] = 510, -- main pwr
        ["PTR-ELEC-BTN-CRES-511"] = 511, -- elec reset
        ["PTR-TESTCP-BTN-FIRE-575"]	= 575, -- fire+oheat test
        ["PTR-TESTCP-TMB-PROBE-578"] = 578, -- probe heat
        ["PTR-TESTCP-TMB-EPU-579"] = 579, -- epu test
        ["PTR-TESTCP-TMB-TEST-585"] = 585, -- flcs test
        ["PTR-ANTICE-TMB-ENG-710"] = 710, -- anti ice
    },
    params = {
        "BASE_SENSOR_RADALT",
        "BASE_SENSOR_CANOPY_POS",
        "BASE_SENSOR_CANOPY_STATE",
        "BASE_SENSOR_FUEL_TOTAL",
        "BASE_SENSOR_FLAPS_POS",
        "BASE_SENSOR_FLAPS_RETRACTED",
        "BASE_SENSOR_LEFT_ENGINE_RPM",
        "BASE_SENSOR_RUDDER_POS",
        "ExternalFM:HumanInfo:Lail",
        "ExternalFM:HumanInfo:Rail",
        "ExternalFM:HumanInfo:Lstab",
        "ExternalFM:HumanInfo:Rstab",
        "ExternalFM:HumanInfo:Rud",
    },
    indications = {
        [1] = {}
    },
    commands = {},
}

-- canopy=closed,			param,	BASE_SENSOR_CANOPY_POS,		   0,   0,	0
-- canopy=open,			param, 	BASE_SENSOR_CANOPY_POS,		0.01, 100,	1

-- left_ail=down,			param,	ExternalFM:HumanInfo:Lail,	 -30,  15,  0
-- left_ail=up,			param,	ExternalFM:HumanInfo:Lail,	  16,  30,  1

-- BASE_SENSOR_RADALT:1.821011
-- ACCELERATION_X_W:0.000000
-- ACCELERATION_Y_W:0.000000
-- ACCELERATION_Z_W:0.000000
-- BASE_SENSOR_ALTIMETER_ATMO_PRESSURE_HG:760.002100
-- BASE_SENSOR_AOA:0.061993
-- BASE_SENSOR_AOS:0.015456
-- BASE_SENSOR_BAROALT:466.321499
-- BASE_SENSOR_CANOPY_POS:0.000000
-- BASE_SENSOR_CANOPY_STATE:0.000000
-- BASE_SENSOR_FLAPS_POS:1.000000
-- BASE_SENSOR_FLAPS_RETRACTED:0.000000
-- BASE_SENSOR_FUEL_TOTAL:5492.941406
-- BASE_SENSOR_GEAR_HANDLE:0.000000
-- BASE_SENSOR_HEADING:3.918744
-- BASE_SENSOR_HELI_COLLECTIVE:0.000000
-- BASE_SENSOR_HELI_CORRECTION:0.000000
-- BASE_SENSOR_HORIZONTAL_ACCEL:0.007640
-- BASE_SENSOR_IAS:16.106104
-- BASE_SENSOR_LATERAL_ACCEL:-0.000190
-- BASE_SENSOR_LEFT_ENGINE_FAN_RPM:0.378845
-- BASE_SENSOR_LEFT_ENGINE_FUEL_CONSUPMTION:0.142837
-- BASE_SENSOR_LEFT_ENGINE_RPM:0.658414
-- BASE_SENSOR_LEFT_ENGINE_TEMP_BEFORE_TURBINE:0.000000
-- BASE_SENSOR_LEFT_GEAR_DOWN:1.000000
-- BASE_SENSOR_LEFT_GEAR_UP:0.000000
-- BASE_SENSOR_LEFT_THROTTLE_POS:0.000000
-- BASE_SENSOR_LEFT_THROTTLE_RAW_CONTROL:0.000000
-- BASE_SENSOR_MACH:0.048664
-- BASE_SENSOR_MAG_HEADING:2.247791
-- BASE_SENSOR_NOSE_GEAR_DOWN:1.000000
-- BASE_SENSOR_NOSE_GEAR_UP:0.000000
-- BASE_SENSOR_PITCH:0.007641
-- BASE_SENSOR_PITCH_RATE:-0.000000
-- BASE_SENSOR_PROPELLER_PITCH:0.000000
-- BASE_SENSOR_PROPELLER_RPM:0.000000
-- BASE_SENSOR_PROPELLER_TILT:0.000000
-- BASE_SENSOR_RELATIVE_TORQUE:0.000000
-- BASE_SENSOR_RIGHT_ENGINE_FAN_RPM:0.000000
-- BASE_SENSOR_RIGHT_ENGINE_FUEL_CONSUMPTION:0.000000
-- BASE_SENSOR_RIGHT_ENGINE_RPM:0.000000
-- BASE_SENSOR_RIGHT_ENGINE_TEMP_BEFORE_TURBINE:0.000000
-- BASE_SENSOR_RIGHT_GEAR_DOWN:1.000000
-- BASE_SENSOR_RIGHT_GEAR_UP:0.000000
-- BASE_SENSOR_RIGHT_THROTTLE_POS:0.000000
-- BASE_SENSOR_RIGHT_THROTTLE_RAW_CONTROL:0.000000
-- BASE_SENSOR_ROLL:0.000000
-- BASE_SENSOR_ROLL_RATE:-0.000024
-- BASE_SENSOR_RUDDER_NORMED:0.000000
-- BASE_SENSOR_RUDDER_POS:0.000000
-- BASE_SENSOR_SPEED_BRAKE_POS:0.000000
-- BASE_SENSOR_STICK_PITCH_NORMED:0.000000
-- BASE_SENSOR_STICK_PITCH_POS:0.000000
-- BASE_SENSOR_STICK_ROLL_NORMED:0.000000
-- BASE_SENSOR_STICK_ROLL_POS:0.000000
-- BASE_SENSOR_TAS:16.472368
-- BASE_SENSOR_VERTICAL_ACCEL:0.999973
-- BASE_SENSOR_VERTICAL_SPEED:-0.000005
-- BASE_SENSOR_WOW_LEFT_GEAR:1.000000
-- BASE_SENSOR_WOW_NOSE_GEAR:1.000000
-- BASE_SENSOR_WOW_RIGHT_GEAR:1.000000
-- BASE_SENSOR_YAW_RATE:-0.000006
-- COMM1_FREQ:305.000000
-- COMM2_FREQ:127.000000
-- ChaffFlare_ChaffBurstCount:0.000000
-- ChaffFlare_ChaffBurstInterval:0.000000
-- ChaffFlare_ChaffSalvoCount:0.000000
-- ChaffFlare_ChaffSalvoInterval:0.000000
-- ChaffFlare_FlareBurstCount:0.000000
-- ChaffFlare_FlareBurstInterval:0.000000
-- EHSI_INDICATOR_INDEX:13.000000
-- EJECTION_BLOCKED_0:0.000000
-- EJECTION_BLOCKED_1:0.000000
-- EJECTION_INITIATED_0:-1.000000
-- EJECTION_INITIATED_1:0.000000
-- ExternalFM:HumanInfo:Alt:1529.926147
-- ExternalFM:HumanInfo:AoA:3.551931
-- ExternalFM:HumanInfo:AoA_U:0.000000
-- ExternalFM:HumanInfo:AoS:0.885550
-- ExternalFM:HumanInfo:BAlt:0.000000
-- ExternalFM:HumanInfo:Br:0.000000
-- ExternalFM:HumanInfo:CAS:10.044564
-- ExternalFM:HumanInfo:CG_X_inch:0.000000
-- ExternalFM:HumanInfo:CG_X_m:0.000000
-- ExternalFM:HumanInfo:CG_X_mm:0.000000
-- ExternalFM:HumanInfo:CenteringX:-1160.240723
-- ExternalFM:HumanInfo:CenteringY:-205.315521
-- ExternalFM:HumanInfo:CenteringZ:6.912330
-- ExternalFM:HumanInfo:CgX_Relative:0.000000
-- ExternalFM:HumanInfo:Collective:0.000000
-- ExternalFM:HumanInfo:DI:233.035355
-- ExternalFM:HumanInfo:DT:0.000000
-- ExternalFM:HumanInfo:DT_C:0.000000
-- ExternalFM:HumanInfo:DT_L:1122.610107
-- ExternalFM:HumanInfo:DT_R:1122.610107
-- ExternalFM:HumanInfo:EAS:10.036272
-- ExternalFM:HumanInfo:EGT:0.000000
-- ExternalFM:HumanInfo:EGT_L:0.000000
-- ExternalFM:HumanInfo:EGT_R:0.000000
-- ExternalFM:HumanInfo:EngN2:0.000000
-- ExternalFM:HumanInfo:EngRPM:0.658414
-- ExternalFM:HumanInfo:FAT:7.368910
-- ExternalFM:HumanInfo:FT:217.724335
-- ExternalFM:HumanInfo:FUT:0.000000
-- ExternalFM:HumanInfo:FinFx:0.000000
-- ExternalFM:HumanInfo:FinFy:0.000000
-- ExternalFM:HumanInfo:FinFz:0.000000
-- ExternalFM:HumanInfo:FuselageFx:0.000000
-- ExternalFM:HumanInfo:FuselageFy:0.000000
-- ExternalFM:HumanInfo:FuselageFz:0.000000
-- ExternalFM:HumanInfo:Fx:-175.421173
-- ExternalFM:HumanInfo:Fy:0.000000
-- ExternalFM:HumanInfo:IAS:0.000000
-- ExternalFM:HumanInfo:I_TS:0.000000
-- ExternalFM:HumanInfo:IndAS:0.000000
-- ExternalFM:HumanInfo:K:0.000000
-- ExternalFM:HumanInfo:KCAS:19.525070
-- ExternalFM:HumanInfo:KEAS:19.508953
-- ExternalFM:HumanInfo:KIAS:0.000000
-- ExternalFM:HumanInfo:KTAS:19.841246
-- ExternalFM:HumanInfo:Lail:20.000000
-- ExternalFM:HumanInfo:Lstab:0.000052
-- ExternalFM:HumanInfo:M:0.030465
-- ExternalFM:HumanInfo:MainRotPitch:0.000000
-- ExternalFM:HumanInfo:Mind:0.000002
-- ExternalFM:HumanInfo:Mx:0.000000
-- ExternalFM:HumanInfo:Mx_a:-87.558357
-- ExternalFM:HumanInfo:My:0.000000
-- ExternalFM:HumanInfo:My_a:-71.061295
-- ExternalFM:HumanInfo:Mz:0.000000
-- ExternalFM:HumanInfo:Mz_a:-359.989410
-- ExternalFM:HumanInfo:N1_L:0.000000
-- ExternalFM:HumanInfo:N1_R:0.000000
-- ExternalFM:HumanInfo:N2_L:0.000000
-- ExternalFM:HumanInfo:N2_R:0.000000
-- ExternalFM:HumanInfo:NF_L:0.000000
-- ExternalFM:HumanInfo:NF_R:0.000000
-- ExternalFM:HumanInfo:Pl:3019.231689
-- ExternalFM:HumanInfo:PlateP:0.000000
-- ExternalFM:HumanInfo:PlateR:0.000000
-- ExternalFM:HumanInfo:Pr:0.000000
-- ExternalFM:HumanInfo:Ps:-0.000018
-- ExternalFM:HumanInfo:RAlt:0.000000
-- ExternalFM:HumanInfo:RT:217.724335
-- ExternalFM:HumanInfo:Rail:19.999683
-- ExternalFM:HumanInfo:RotorRPM:0.000000
-- ExternalFM:HumanInfo:Rstab:0.000000
-- ExternalFM:HumanInfo:Rud:0.002144
-- ExternalFM:HumanInfo:SFC:0.000000
-- ExternalFM:HumanInfo:S_IS:0.000000
-- ExternalFM:HumanInfo:S_M:0.000000
-- ExternalFM:HumanInfo:S_TS:0.000000
-- ExternalFM:HumanInfo:StickP:0.000000
-- ExternalFM:HumanInfo:StickR:0.000000
-- ExternalFM:HumanInfo:TAS:10.207218
-- ExternalFM:HumanInfo:TGT_L:0.000000
-- ExternalFM:HumanInfo:TGT_R:0.000000
-- ExternalFM:HumanInfo:TailRotF:0.000000
-- ExternalFM:HumanInfo:TailRotPitch:0.000000
-- ExternalFM:HumanInfo:Torq:0.000000
-- ExternalFM:HumanInfo:Torq_L:0.000000
-- ExternalFM:HumanInfo:Torq_R:0.000000
-- ExternalFM:HumanInfo:Vx:0.000000
-- ExternalFM:HumanInfo:Vx_l:10.207218
-- ExternalFM:HumanInfo:Vx_w:0.000031
-- ExternalFM:HumanInfo:Vy:0.000153
-- ExternalFM:HumanInfo:Vy_l:-0.633587
-- ExternalFM:HumanInfo:Vy_w:-0.000006
-- ExternalFM:HumanInfo:Vz:0.000000
-- ExternalFM:HumanInfo:Vz_l:0.158076
-- ExternalFM:HumanInfo:Vz_w:0.000044
-- ExternalFM:HumanInfo:X:29.933353
-- ExternalFM:HumanInfo:dPsi:-0.000385
-- ExternalFM:HumanInfo:dPsiC:-0.001394
-- ExternalFM:HumanInfo:dTR:0.000000
-- ExternalFM:HumanInfo:mass:17726.720703
-- ExternalFM:HumanInfo:mass_lb:39080.683594
-- ExternalFM:HumanInfo:nx:0.007640
-- ExternalFM:HumanInfo:nxV:-0.054326
-- ExternalFM:HumanInfo:ny:0.999973
-- ExternalFM:HumanInfo:nz:-0.000004
-- ExternalFM:HumanInfo:pitch:0.437779
-- ExternalFM:HumanInfo:roll:0.000000
-- ExternalFM:HumanInfo:wx:-0.001394
-- ExternalFM:HumanInfo:wy:-0.000375
-- ExternalFM:HumanInfo:wz:-0.000012
-- ExternalFM:HumanInfo:x:-1.160241
-- ExternalFM:HumanInfo:y:-0.205316
-- ExternalFM:HumanInfo:z:0.006912
-- HMD_AA_Aim120_AF_Pole_PostLaunch:0.000000
-- HMD_AA_Aim120_AF_Pole_PreLaunch:0.000000
-- HMD_AA_Aim120_AF_isActive:0.000000
-- HMD_AA_Aim120_isSelect:0.000000
-- HMD_F16_IN_DIAMOND_SYM_POSITION_X:0.000000
-- HMD_F16_IN_DIAMOND_SYM_POSITION_Y:0.000000
-- HMD_F16_IN_DIAMOND_SYM_SHOW:0.000000
-- HMD_F16_IN_MARKPOINT_CUE_POS_X:0.000000
-- HMD_F16_IN_MARKPOINT_CUE_POS_Y:0.000000
-- HMD_F16_IN_MARKPOINT_CUE_SHOW:0.000000
-- HMD_F16_IN_MARKPOINT_SLAVE_TO_CROSS:0.000000
-- HMD_F16_IN_MAV_MLE_RANGE_CARET:0.000000
-- HMD_F16_IN_MAV_MLE_RMAX:0.000000
-- HMD_F16_IN_MAV_MLE_RMIN:0.000000
-- HMD_F16_IN_MAV_MLE_SHOW:0.000000
-- HMD_F16_IN_MAV_MLE_TGT_RANGE:0.000000
-- HMD_F16_IN_MAV_RETICLE_HANDOFF:0.000000
-- HMD_F16_IN_MAV_RETICLE_SHOW:0.000000
-- HMD_F16_IN_MAV_RETICLE_X:0.000000
-- HMD_F16_IN_MAV_RETICLE_Y:0.000000
-- HMD_F16_IN_OA1_POS_X:0.000000
-- HMD_F16_IN_OA1_POS_Y:0.000000
-- HMD_F16_IN_OA1_SHOW:0.000000
-- HMD_F16_IN_OA2_POS_X:0.000000
-- HMD_F16_IN_OA2_POS_Y:0.000000
-- HMD_F16_IN_OA2_SHOW:0.000000
-- HMD_F16_IN_PDLT_ALTITUDE:0.000000
-- HMD_F16_IN_PDLT_POS_X:0.000000
-- HMD_F16_IN_PDLT_POS_Y:0.000000
-- HMD_F16_IN_PDLT_SHOW:0.000000
-- HMD_F16_IN_PUP_POSITION_X:0.000000
-- HMD_F16_IN_PUP_POSITION_Y:0.000000
-- HMD_F16_IN_PUP_SHOW:0.000000
-- HMD_F16_IN_RWR_PRIOR_SYMBOL:0.000000
-- HMD_F16_IN_VIS_TDBOX_SLAVE_TO_CROSS:0.000000
-- HMD_F16_IN_WINDOW15_HOME_BINGO_FLASH:0.000000
-- HMD_F16_IN_WINDOW38_MKPTNUMBER:0.000000
-- HMD_F16_IN_WINDOW38_SHOW:0.000000
-- HMD_F18_IN_AG_JDAM_TXA_DEDG:0.000000
-- HMD_IN_AA_ASE_STATUS:0.000000
-- HMD_IN_AA_Aim120LosFixed:0.000000
-- HMD_IN_AA_Aim120LosPos_X:0.000000
-- HMD_IN_AA_Aim120LosPos_Y:0.000000
-- HMD_IN_AA_Aim9DiamondFlash:0.000000
-- HMD_IN_AA_Aim9Locked:0.000000
-- HMD_IN_AA_Aim9Uncaged:0.000000
-- HMD_IN_AA_MSL_RAERO:0.000000
-- HMD_IN_AA_MSL_RAERO_CUE_SHOW:0.000000
-- HMD_IN_AA_MSL_RMAX:0.000000
-- HMD_IN_AA_MSL_RMIN:0.000000
-- HMD_IN_AA_MSL_RNE:0.000000
-- HMD_IN_AA_RDR_ACM_FOV_KIND:0.000000
-- HMD_IN_AA_RDR_DT2_POS_X:0.000000
-- HMD_IN_AA_RDR_DT2_POS_Y:0.000000
-- HMD_IN_AA_RDR_DT2_SHOW:0.000000
-- HMD_IN_AA_RDR_TD_BOX_KIND:0.000000
-- HMD_IN_AA_RDR_TD_BOX_POS_X:0.000000
-- HMD_IN_AA_RDR_TD_BOX_POS_Y:0.000000
-- HMD_IN_AA_RDR_TRACKED_TARGET_HAFU:0.000000
-- HMD_IN_AA_RDR_TWS_L_S_HAFU:0.000000
-- HMD_IN_AA_RETICLE_RMAX:0.000000
-- HMD_IN_AA_SELECTED_WEAPON_VIS:0.000000
-- HMD_IN_AA_SHOOT_CUE_FLASH:0.000000
-- HMD_IN_AA_SHOOT_CUE_KIND:0.000000
-- HMD_IN_AA_TARGET_ASPECT_CUE_ROT:0.000000
-- HMD_IN_AA_TARGET_ASPECT_CUE_SHOW:0.000000
-- HMD_IN_AA_TARGET_RANGE:0.000000
-- HMD_IN_AA_TARGET_RANGE_FLOOD_STATUS:0.000000
-- HMD_IN_AA_TARGET_RANGE_RATE:0.000000
-- HMD_IN_AA_TARGET_RANGE_RATE_SHOW:0.000000
-- HMD_IN_AA_TARGET_VALID:0.000000
-- HMD_IN_AA_TD_ALTITUDE:0.000000
-- HMD_IN_AA_TGT_RNG:0.000000
-- HMD_IN_AA_WEAPON_TYPE_X_OVER_SHOW:0.000000
-- HMD_IN_AC_ATTITUDE_VALID:0.000000
-- HMD_IN_AC_PITCH:0.000000
-- HMD_IN_AC_ROLL:0.000000
-- HMD_IN_AC_YAW:0.000000
-- HMD_IN_AG_BOMB_AUTO_TTG:0.000000
-- HMD_IN_AG_BOMB_CCIP_POSTDESIGNATED:0.000000
-- HMD_IN_AG_DESIGNATED_WAYPOINT_STATUS:0.000000
-- HMD_IN_AG_DESIGNATED_WAYPOINT_TYPE:0.000000
-- HMD_IN_AG_DESIGNATED_WAYPOINT_X:0.000000
-- HMD_IN_AG_DESIGNATED_WAYPOINT_Y:0.000000
-- HMD_IN_AG_JDAM_NOT_READY:0.000000
-- HMD_IN_AG_MISSION_DATA_TOO:0.000000
-- HMD_IN_AG_SEL_WEAPON_TYPE:0.000000
-- HMD_IN_AG_TDC_TO_HMD:0.000000
-- HMD_IN_AIM120_SEEKER_SHOW:0.000000
-- HMD_IN_AIM7_SEEKER_SHOW:0.000000
-- HMD_IN_AIM9_SEEKER_STATUS:0.000000
-- HMD_IN_AIRSPEED:0.000000
-- HMD_IN_ALIGNMENT_IN_PROCESS:0.000000
-- HMD_IN_ALIGNMENT_RESULT_R:0.000000
-- HMD_IN_ALIGNMENT_RESULT_X:0.000000
-- HMD_IN_ALIGNMENT_RESULT_Y:0.000000
-- HMD_IN_ALIGNMENT_STATUS:0.000000
-- HMD_IN_ALTITUDE:0.000000
-- HMD_IN_ALTITUDE_LABEL:0.000000
-- HMD_IN_ALTITUDE_WARNING:0.000000
-- HMD_IN_AOA:0.000000
-- HMD_IN_ARM_STATUS:0.000000
-- HMD_IN_AUTOSTARTALIGNMENT:0.000000
-- HMD_IN_AUTO_CKPT_BLANKING:0.000000
-- HMD_IN_AUTO_HUD_BLANKING:0.000000
-- HMD_IN_BIT_REQUEST:3.000000
-- HMD_IN_BREAKAWAY_X_AA:0.000000
-- HMD_IN_BREAKAWAY_X_AG:0.000000
-- HMD_IN_BRIGHTNESS:0.000000
-- HMD_IN_CURR_REJ_LEVEL:0.000000
-- HMD_IN_DISP_POWER:0.000000
-- HMD_IN_DL_AZIMUTH_1:0.000000
-- HMD_IN_DL_AZIMUTH_2:0.000000
-- HMD_IN_DL_AZIMUTH_3:0.000000
-- HMD_IN_DL_AZIMUTH_4:0.000000
-- HMD_IN_DL_AZIMUTH_5:0.000000
-- HMD_IN_DL_AZIMUTH_6:0.000000
-- HMD_IN_DL_AZIMUTH_7:0.000000
-- HMD_IN_DL_ELEVATION_1:0.000000
-- HMD_IN_DL_ELEVATION_2:0.000000
-- HMD_IN_DL_ELEVATION_3:0.000000
-- HMD_IN_DL_ELEVATION_4:0.000000
-- HMD_IN_DL_ELEVATION_5:0.000000
-- HMD_IN_DL_ELEVATION_6:0.000000
-- HMD_IN_DL_ELEVATION_7:0.000000
-- HMD_IN_DL_GROUP_1:0.000000
-- HMD_IN_DL_GROUP_2:0.000000
-- HMD_IN_DL_GROUP_3:0.000000
-- HMD_IN_DL_GROUP_4:0.000000
-- HMD_IN_DL_GROUP_5:0.000000
-- HMD_IN_DL_GROUP_6:0.000000
-- HMD_IN_DL_GROUP_7:0.000000
-- HMD_IN_DL_JAMMER_1:0.000000
-- HMD_IN_DL_JAMMER_2:0.000000
-- HMD_IN_DL_JAMMER_3:0.000000
-- HMD_IN_DL_JAMMER_4:0.000000
-- HMD_IN_DL_JAMMER_5:0.000000
-- HMD_IN_DL_JAMMER_6:0.000000
-- HMD_IN_DL_JAMMER_7:0.000000
-- HMD_IN_DL_OFFBOARD_HAFU_1:0.000000
-- HMD_IN_DL_OFFBOARD_HAFU_2:0.000000
-- HMD_IN_DL_OFFBOARD_HAFU_3:0.000000
-- HMD_IN_DL_OFFBOARD_HAFU_4:0.000000
-- HMD_IN_DL_OFFBOARD_HAFU_5:0.000000
-- HMD_IN_DL_OFFBOARD_HAFU_6:0.000000
-- HMD_IN_DL_OFFBOARD_HAFU_7:0.000000
-- HMD_IN_DL_ONBOARD_HAFU_1:0.000000
-- HMD_IN_DL_ONBOARD_HAFU_2:0.000000
-- HMD_IN_DL_ONBOARD_HAFU_3:0.000000
-- HMD_IN_DL_ONBOARD_HAFU_4:0.000000
-- HMD_IN_DL_ONBOARD_HAFU_5:0.000000
-- HMD_IN_DL_ONBOARD_HAFU_6:0.000000
-- HMD_IN_DL_ONBOARD_HAFU_7:0.000000
-- HMD_IN_DL_RANGE_1:0.000000
-- HMD_IN_DL_RANGE_2:0.000000
-- HMD_IN_DL_RANGE_3:0.000000
-- HMD_IN_DL_RANGE_4:0.000000
-- HMD_IN_DL_RANGE_5:0.000000
-- HMD_IN_DL_RANGE_6:0.000000
-- HMD_IN_DL_RANGE_7:0.000000
-- HMD_IN_DL_SHOW:0.000000
-- HMD_IN_DL_TN_1:0.000000
-- HMD_IN_DL_TN_2:0.000000
-- HMD_IN_DL_TN_3:0.000000
-- HMD_IN_DL_TN_4:0.000000
-- HMD_IN_DL_TN_5:0.000000
-- HMD_IN_DL_TN_6:0.000000
-- HMD_IN_DL_TN_7:0.000000
-- HMD_IN_EU_POWER:0.000000
-- HMD_IN_EYE_OPTION:2.000000
-- HMD_IN_FCR_AA_AIM120_ACT:0.000000
-- HMD_IN_FCR_AA_AIM120_ACT_RANGE:0.000000
-- HMD_IN_FCR_AA_AIM9_TOF:0.000000
-- HMD_IN_FCR_AA_CLOSURE_RATE:0.000000
-- HMD_IN_FCR_AA_MSL_ACT0:0.000000
-- HMD_IN_FCR_AA_MSL_RAERO:0.000000
-- HMD_IN_FCR_AA_MSL_RMAX:0.000000
-- HMD_IN_FCR_AA_MSL_RMIN:0.000000
-- HMD_IN_FCR_AA_MSL_RNE:0.000000
-- HMD_IN_FCR_AA_MSL_TOF0:0.000000
-- HMD_IN_FCR_AA_MSL_TTG:0.000000
-- HMD_IN_FCR_AA_TGT_RNG:0.000000
-- HMD_IN_FCR_RANGE_SCALE:0.000000
-- HMD_IN_FCR_RANGE_SCALE_SHOW:0.000000
-- HMD_IN_FCR_SHOW_DLZ:0.000000
-- HMD_IN_FINE_ALIGNMENT_R:0.000000
-- HMD_IN_FINE_ALIGNMENT_X:0.000000
-- HMD_IN_FINE_ALIGNMENT_Y:0.000000
-- HMD_IN_FLIR_TIME_TO_LASE:0.000000
-- HMD_IN_FORMAT:0.000000
-- HMD_IN_HARM_SP_PB_MODE:0.000000
-- HMD_IN_HARM_SP_PB_SHOW:0.000000
-- HMD_IN_HARM_SP_PB_X:0.000000
-- HMD_IN_HDG_SCALE_HEADING:0.000000
-- HMD_IN_MACH:0.000000
-- HMD_IN_MANUAL_BLANKING:0.000000
-- HMD_IN_MAX_NORM_ACCELERATION:0.000000
-- HMD_IN_NORM_ACCELERATION:0.000000
-- HMD_IN_NO_RAD:0.000000
-- HMD_IN_RDR_ANTENNA_POSITION_AZIMUTH:0.000000
-- HMD_IN_RDR_ANTENNA_POSITION_ELEVATION:0.000000
-- HMD_IN_RDR_ANTENNA_POSITION_ON_LIMIT:0.000000
-- HMD_IN_RDR_WEAPON_COUNT:0.000000
-- HMD_IN_REQUIRED_GRD_SPEED_CARET:0.000000
-- HMD_IN_REQUIRED_GRD_SPEED_SHOW:0.000000
-- HMD_IN_RWR_SHOW_NUM:0.000000
-- HMD_IN_RWR_THREAT_AZIMUTH_1:0.000000
-- HMD_IN_RWR_THREAT_AZIMUTH_2:0.000000
-- HMD_IN_RWR_THREAT_AZIMUTH_3:0.000000
-- HMD_IN_RWR_THREAT_AZIMUTH_4:0.000000
-- HMD_IN_RWR_THREAT_AZIMUTH_5:0.000000
-- HMD_IN_RWR_THREAT_AZIMUTH_6:0.000000
-- HMD_IN_RWR_THREAT_LEVEL_1:0.000000
-- HMD_IN_RWR_THREAT_LEVEL_2:0.000000
-- HMD_IN_RWR_THREAT_LEVEL_3:0.000000
-- HMD_IN_RWR_THREAT_LEVEL_4:0.000000
-- HMD_IN_RWR_THREAT_LEVEL_5:0.000000
-- HMD_IN_RWR_THREAT_LEVEL_6:0.000000
-- HMD_IN_RWR_THREAT_SYMBOL_1_1:0.000000
-- HMD_IN_RWR_THREAT_SYMBOL_1_2:0.000000
-- HMD_IN_RWR_THREAT_SYMBOL_1_3:0.000000
-- HMD_IN_RWR_THREAT_SYMBOL_1_4:0.000000
-- HMD_IN_RWR_THREAT_SYMBOL_1_5:0.000000
-- HMD_IN_RWR_THREAT_SYMBOL_1_6:0.000000
-- HMD_IN_RWR_THREAT_SYMBOL_2_1:0.000000
-- HMD_IN_RWR_THREAT_SYMBOL_2_2:0.000000
-- HMD_IN_RWR_THREAT_SYMBOL_2_3:0.000000
-- HMD_IN_RWR_THREAT_SYMBOL_2_4:0.000000
-- HMD_IN_RWR_THREAT_SYMBOL_2_5:0.000000
-- HMD_IN_RWR_THREAT_SYMBOL_2_6:0.000000
-- HMD_IN_RWR_THREAT_VALID_1:0.000000
-- HMD_IN_RWR_THREAT_VALID_2:0.000000
-- HMD_IN_RWR_THREAT_VALID_3:0.000000
-- HMD_IN_RWR_THREAT_VALID_4:0.000000
-- HMD_IN_RWR_THREAT_VALID_5:0.000000
-- HMD_IN_RWR_THREAT_VALID_6:0.000000
-- HMD_IN_SELECTED_WEAPON_CODE:0.000000
-- HMD_IN_SELECTED_WEAPON_COUNT:0.000000
-- HMD_IN_SIDEWINDER_SEEKER_X:0.000000
-- HMD_IN_SIDEWINDER_SEEKER_Y:0.000000
-- HMD_IN_SIDEWINDER_TRACKING:0.000000
-- HMD_IN_SLANT_RANGE:0.000000
-- HMD_IN_SLANT_RANGE_LITERA:0.000000
-- HMD_IN_SLANT_RANGE_SHOW:0.000000
-- HMD_IN_SLANT_RANGE_SHOW_NM:0.000000
-- HMD_IN_START_ALIGMENT:0.000000
-- HMD_IN_START_FINE_ALIGNMENT:0.000000
-- HMD_IN_STPT_SYM_TYPE:0.000000
-- HMD_IN_STPT_VALID:0.000000
-- HMD_IN_STP_NUM:0.000000
-- HMD_IN_STP_RANGE:0.000000
-- HMD_IN_SUB_MODE:0.000000
-- HMD_IN_TGT_BEARING:0.000000
-- HMD_IN_TGT_IS_SELECTED:0.000000
-- HMD_IN_TGT_RANGE:0.000000
-- HMD_IN_TOF_WINDOW_DISPLAY:0.000000
-- HMD_IN_UPLOOK_RETICLE_ENABLED:0.000000
-- HMD_IN_VERTICAL_VELOCITY:0.000000
-- HMD_IN_VERTICAL_VELOCITY_SHOW:0.000000
-- HMD_IN_WINDOW11_WARN:0.000000
-- HMD_IN_WINDOW12_FUEL_ADVISORY:0.000000
-- HMD_IN_WINDOW15_BULLSEYE_BEARING:0.000000
-- HMD_IN_WINDOW15_BULLSEYE_RANGE:0.000000
-- HMD_IN_WINDOW15_BULLSEYE_STATE:0.000000
-- HMD_IN_WINDOW15_HOME_BINGO:0.000000
-- HMD_IN_WINDOW15_TYPE:0.000000
-- HMD_IN_WINDOW_2_DISPLAY:0.000000
-- HMD_IN_WINDOW_2_FLASHING:0.000000
-- HMD_IN_WINDOW_3_DISPLAY:0.000000
-- HMD_IN_WINDOW_3_DISPLAY_X:0.000000
-- HMD_IN_WINDOW_3_MAN_VALUE:0.000000
-- HMD_IN_WINDOW_4_DISPLAY:0.000000
-- HMD_IN_WINDOW_5_DISPLAY:0.000000
-- HMD_IN_WINDOW_6_DISPLAY:0.000000
-- HMD_IN_WINDOW_6_FLASHING:0.000000
-- HMD_IN_WINDOW_6_SELECTED_SEQUENCE_NUMBER:0.000000
-- HMD_IN_WINDOW_7_DISPLAY:0.000000
-- HMD_IN_WINDOW_8_MARKPOINT_ACTIVE_STATE:0.000000
-- HMD_IN_WINDOW_8_MARKPOINT_CURRENT_NUMBER:0.000000
-- HMD_IN_WINDOW_8_TACAN_RANGE:0.000000
-- HMD_IN_WINDOW_8_TACAN_RANGE_ENABLE:0.000000
-- HMD_IN_WINDOW_8_TACAN_STATION_IDENTIFICATION:0.000000
-- HMD_IN_WINDOW_8_TACAN_STATION_IDENTIFICATION_ENABLE:0.000000
-- HMD_IN_WINDOW_8_TACAN_STEERING_SELECT:0.000000
-- HMD_IN_WINDOW_8_TARGET_DESIGNATED:0.000000
-- HMD_IN_WINDOW_8_TARGET_DESIGNATED_RANGE:0.000000
-- HMD_IN_WINDOW_8_WAYPOINT_OR_OAP:0.000000
-- HMD_IN_WINDOW_8_WAYPOINT_RANGE:0.000000
-- HMD_IN_WINDOW_8_WAYPOINT_STEERING_SELECT:0.000000
-- HMD_IN_WINDOW_8_WAYPOINT_SYMBOL:0.000000
-- HMD_IN_WINDOW_8_WYPT_DATA_WAYPOINT_SELECTED_NUMBER:0.000000
-- HMD_OUT_BIT_IN_TEST:0.000000
-- HMD_OUT_DAC_ELEVATION_BODY:-0.409507
-- HMD_OUT_DAC_HEADING_BODY:0.040267
-- HMD_OUT_DAC_SLAVING_ON:1.000000
-- HMD_OUT_HDU_ROLL:0.000000
-- HMD_OUT_IBIT_OK:1.000000
-- HMD_OUT_LOS_ELEVATION_BODY:-0.409507
-- HMD_OUT_LOS_ELEVATION_EARTH:0.000000
-- HMD_OUT_LOS_HEADING_BODY:0.040267
-- HMD_OUT_LOS_HEADING_EARTH:0.000000
-- HMD_OUT_LOS_IS_ACTIVE:1.000000
-- HMD_OUT_SET_NO_GO:0.000000
-- HMD_OUT_SIDEWINDER_SEEKER_X:0.040267
-- HMD_OUT_SIDEWINDER_SEEKER_Y:-0.409507
-- HMD_OUT_STATE:6.000000
-- HMD_STR_DL_UNIT_TYPE_STR_1:0.000000
-- HMD_STR_DL_UNIT_TYPE_STR_2:0.000000
-- HMD_STR_DL_UNIT_TYPE_STR_3:0.000000
-- HMD_STR_DL_UNIT_TYPE_STR_4:0.000000
-- HMD_STR_DL_UNIT_TYPE_STR_5:0.000000
-- HMD_STR_DL_UNIT_TYPE_STR_6:0.000000
-- HMD_STR_DL_UNIT_TYPE_STR_7:0.000000
-- HMD_STR_IN_REJECT_STATUS:0.000000
-- LaserCode:0.000000
-- MAV_FOV:\"OFF\"
-- MAV_STATUS:0.000000
-- MAV_VIDEO:\"OFF\"
-- MDG_init_DEFAULT_LEVEL:15.000000
-- MDG_init_specifics:\"./Mods/aircraft/F-16C/Cockpit/Scripts/HMD/indicator/HMD_specifics.lua\"
-- MFD_Font_Name:\"font_stroke_RMFD\"
-- MFD_LEFT_INDICATOR_INDEX:4.000000
-- MFD_Material_Name:\"RMFD_MATERIAL\"
-- MFD_RIGHT_INDICATOR_INDEX:5.000000
-- MFD_init_DEFAULT_LEVEL:6.000000
-- SEAT:0.000000
-- WINDSHIELD_WIPER_0:0.000000
-- WINDSHIELD_WIPER_1:0.000000
-- Weapon_HighCapRate:0.000000
-- Weapon_LowCapRate:0.000000
-- debug_1:0.000000
-- debug_2:0.000000
-- debug_3:0.000000
-- debug_alt:0.000000
-- debug_aoa:0.000000
-- debug_cgx:0.000000
-- debug_ias:0.000000
-- debug_ins_hdg:0.000000
-- debug_ins_x:0.000000
-- debug_ins_z:0.000000
-- debug_pos_x:0.000000
-- debug_pos_z:0.000000
-- debug_sep:0.000000
-- debug_tas:0.000000

