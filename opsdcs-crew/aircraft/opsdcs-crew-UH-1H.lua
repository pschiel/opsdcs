-- todo: yes

OpsdcsCrew["UH-1H"] = {
    procedures = {
        ["coldstart"] = {
            text = "Cold Start",
            start_state = "coldstart",
        },
    },
    states = {
        -- Cold Start
        ["coldstart"] = {
            text = "Coldstart",
            conditions = {
            },
            next_state = "coldstart-complete",
        },
        ["coldstart-complete"] = {
            text = "Cold start complete",
        },
    },
    args = {
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

-- ADF_FREQ:0.000000\
-- BASE_SENSOR_ALTIMETER_ATMO_PRESSURE_HG:757.149375\
-- BASE_SENSOR_AOA:0.017331\
-- BASE_SENSOR_AOS:-0.000043\
-- BASE_SENSOR_BAROALT:31.515342\
-- BASE_SENSOR_CANOPY_POS:0.000000\
-- BASE_SENSOR_CANOPY_STATE:0.000000\
-- BASE_SENSOR_FLAPS_POS:0.000000\
-- BASE_SENSOR_FLAPS_RETRACTED:1.000000\
-- BASE_SENSOR_FUEL_TOTAL:629.349976\
-- BASE_SENSOR_GEAR_HANDLE:0.000000\
-- BASE_SENSOR_HEADING:1.629601\
-- BASE_SENSOR_HELI_COLLECTIVE:0.000000\
-- BASE_SENSOR_HELI_CORRECTION:0.000000\
-- BASE_SENSOR_HORIZONTAL_ACCEL:0.017304\
-- BASE_SENSOR_IAS:0.000035\
-- BASE_SENSOR_LATERAL_ACCEL:0.002502\
-- BASE_SENSOR_LEFT_ENGINE_FAN_RPM:1.000006\
-- BASE_SENSOR_LEFT_ENGINE_FUEL_CONSUPMTION:209.915415\
-- BASE_SENSOR_LEFT_ENGINE_RPM:0.875047\
-- BASE_SENSOR_LEFT_ENGINE_TEMP_BEFORE_TURBINE:450.382523\
-- BASE_SENSOR_LEFT_GEAR_DOWN:0.000000\
-- BASE_SENSOR_LEFT_GEAR_UP:1.000000\
-- BASE_SENSOR_LEFT_THROTTLE_POS:1.000000\
-- BASE_SENSOR_LEFT_THROTTLE_RAW_CONTROL:1.000000\
-- BASE_SENSOR_MACH:0.000000\
-- BASE_SENSOR_MAG_HEADING:4.538123\
-- BASE_SENSOR_NOSE_GEAR_DOWN:0.000000\
-- BASE_SENSOR_NOSE_GEAR_UP:1.000000\
-- BASE_SENSOR_PITCH:0.017332\
-- BASE_SENSOR_PITCH_RATE:0.000017\
-- BASE_SENSOR_PROPELLER_PITCH:0.470588\
-- BASE_SENSOR_PROPELLER_RPM:324.002102\
-- BASE_SENSOR_PROPELLER_TILT:0.000000\
-- BASE_SENSOR_RADALT:1.581047\
-- BASE_SENSOR_RELATIVE_TORQUE:0.359208\
-- BASE_SENSOR_RIGHT_ENGINE_FAN_RPM:0.000000\
-- BASE_SENSOR_RIGHT_ENGINE_FUEL_CONSUMPTION:0.000000\
-- BASE_SENSOR_RIGHT_ENGINE_RPM:0.000000\
-- BASE_SENSOR_RIGHT_ENGINE_TEMP_BEFORE_TURBINE:0.000000\
-- BASE_SENSOR_RIGHT_GEAR_DOWN:0.000000\
-- BASE_SENSOR_RIGHT_GEAR_UP:1.000000\
-- BASE_SENSOR_RIGHT_THROTTLE_POS:1.000000\
-- BASE_SENSOR_RIGHT_THROTTLE_RAW_CONTROL:1.000000\
-- BASE_SENSOR_ROLL:-0.002490\
-- BASE_SENSOR_ROLL_RATE:0.000001\
-- BASE_SENSOR_RUDDER_NORMED:0.000000\
-- BASE_SENSOR_RUDDER_POS:-0.000000\
-- BASE_SENSOR_SPEED_BRAKE_POS:0.000000\
-- BASE_SENSOR_STICK_PITCH_NORMED:0.000000\
-- BASE_SENSOR_STICK_PITCH_POS:-0.000000\
-- BASE_SENSOR_STICK_ROLL_NORMED:0.000000\
-- BASE_SENSOR_STICK_ROLL_POS:-0.000000\
-- BASE_SENSOR_TAS:0.000035\
-- BASE_SENSOR_VERTICAL_ACCEL:0.999916\
-- BASE_SENSOR_VERTICAL_SPEED:0.000022\
-- BASE_SENSOR_WOW_LEFT_GEAR:0.000000\
-- BASE_SENSOR_WOW_NOSE_GEAR:0.000000\
-- BASE_SENSOR_WOW_RIGHT_GEAR:0.000000\
-- BASE_SENSOR_YAW_RATE:0.000005\
-- EJECTION_BLOCKED_0:0.000000\
-- EJECTION_BLOCKED_1:0.000000\
-- EJECTION_BLOCKED_2:0.000000\
-- EJECTION_BLOCKED_3:0.000000\
-- EJECTION_INITIATED_0:-1.000000\
-- EJECTION_INITIATED_1:-1.000000\
-- EJECTION_INITIATED_2:-1.000000\
-- EJECTION_INITIATED_3:-1.000000\
-- SEAT:0.000000\
-- UHF_FREQ:251.000000\
-- VHF_AM_FREQ:116.000000\
-- VHF_FM_FREQ:30.000000\
-- WINDSHIELD_WIPER_0:0.000000\
-- WINDSHIELD_WIPER_1:0.000000\
-- Weapon_AutopilotMode:0.000000\
-- Weapon_AutopilotStatus:0.000000\
-- Weapon_IsFlexSightOn:0.000000\
-- Weapon_M60DweapStatus:0.000000\
-- Weapon_NumPairs:0.000000\
-- Weapon_OffSafeArmed:0.000000\
-- Weapon_PilotSightAngle:0.000000\
-- Weapon_SelectedWeapCount:0.000000\
-- Weapon_ShowWeapStatus:0.000000\
-- Weapon_WeapType:0.000000\

-- {
--     [1] = "",
--     [2] = "",
--     [3] = "",
--     [4] = "",
--     [5] = "-----------------------------------------\
-- fr\
-- \
-- children are {\
-- -----------------------------------------\
-- render_tv_in_HUD_only_view\
-- \
-- }\
-- -----------------------------------------\
-- Sight\
-- \
-- -----------------------------------------\
-- circle\
-- \
-- -----------------------------------------\
-- scale\
-- \
-- -----------------------------------------\
-- scale2\
-- \
-- ",
--     [6] = "-----------------------------------------\
-- base\
-- \
-- children are {\
-- -----------------------------------------\
-- txt_Status\
-- 		CREW STATUS:\
-- -----------------------------------------\
-- txt_Hints\
-- HEALTH	ROE	  AMMO BURST\
-- -----------------------------------------\
-- mem_base0\
-- \
-- children are {\
-- -----------------------------------------\
-- txt_mem0\
-- PILOT\
-- -----------------------------------------\
-- txt_status0\
-- PLAYER\
-- -----------------------------------------\
-- txt_ammo0\
--  -\
-- -----------------------------------------\
-- txt_burst0\
--   -\
-- }\
-- -----------------------------------------\
-- mem_base1\
-- \
-- children are {\
-- -----------------------------------------\
-- txt_mem1\
-- CO-PILOT\
-- -----------------------------------------\
-- txt_status1\
-- HOLD\
-- -----------------------------------------\
-- txt_ammo1\
--  -\
-- -----------------------------------------\
-- txt_burst1\
-- SHORT\
-- }\
-- }\
-- ",
--     [7] = "-----------------------------------------\
-- SheetTable_MainDummy\
-- \
-- children are {\
-- -----------------------------------------\
-- sheet_bar_mask\
-- \
-- children are {\
-- -----------------------------------------\
-- SheetTable_Channel1\
--  251.0\
-- -----------------------------------------\
-- SheetTable_Channel2\
--  264.0\
-- -----------------------------------------\
-- SheetTable_Channel3\
--  265.0\
-- -----------------------------------------\
-- SheetTable_Channel4\
--  256.0\
-- -----------------------------------------\
-- SheetTable_Channel5\
--  254.0\
-- -----------------------------------------\
-- SheetTable_Channel6\
--  250.0\
-- -----------------------------------------\
-- SheetTable_Channel7\
--  270.0\
-- -----------------------------------------\
-- SheetTable_Channel8\
--  257.0\
-- -----------------------------------------\
-- SheetTable_Channel9\
--  255.0\
-- -----------------------------------------\
-- SheetTable_Channel10\
--  262.0\
-- -----------------------------------------\
-- SheetTable_Channel11\
--  259.0\
-- -----------------------------------------\
-- SheetTable_Channel12\
--  268.0\
-- -----------------------------------------\
-- SheetTable_Channel13\
--  269.0\
-- -----------------------------------------\
-- SheetTable_Channel14\
--  260.0\
-- -----------------------------------------\
-- SheetTable_Channel15\
--  263.0\
-- -----------------------------------------\
-- SheetTable_Channel16\
--  261.0\
-- -----------------------------------------\
-- SheetTable_Channel17\
--  267.0\
-- -----------------------------------------\
-- SheetTable_Channel18\
--  251.0\
-- -----------------------------------------\
-- SheetTable_Channel19\
--  253.0\
-- -----------------------------------------\
-- SheetTable_Channel20\
--  266.0\
-- }\
-- }\
-- ",
--     [8] = "",
--     [9] = "-----------------------------------------\
-- #1#\
-- \
-- -----------------------------------------\
-- #1#\
-- \
-- -----------------------------------------\
-- txt_AutoPilot_txt\
-- AUTOPILOT MODE:\
-- -----------------------------------------\
-- txt_AutoPilot_mode\
-- LEVEL FLIGHT\
-- -----------------------------------------\
-- txt_AutoPilot\
-- OFF\
-- -----------------------------------------\
-- txt_AutoPilot_key\
-- LWIN+A\
-- -----------------------------------------\
-- txt_KEEP_AS_IS\
-- ATTITUDE HOLD\
-- -----------------------------------------\
-- txt_AutoPilot_KEEP_AS_IS_key\
-- LSHIFT+LALT+A\
-- -----------------------------------------\
-- txt_AutoPilot_H_AS_AB\
-- LEVEL FLIGHT\
-- -----------------------------------------\
-- txt_AutoPilot_H_AS_AB_key\
-- LCTRL+A\
-- -----------------------------------------\
-- txt_AutoPilot_TURN_IN\
-- ORBIT\
-- -----------------------------------------\
-- txt_AutoPilot_TURN_IN_key\
-- LALT+A\
-- -----------------------------------------\
-- txt_CARGO\
-- CARGO:\
-- -----------------------------------------\
-- txt_Hook\
-- CARGO HOOK COMBO\
-- -----------------------------------------\
-- txt_Hook_Key\
-- RC+RS+L\
-- -----------------------------------------\
-- txt_AutoUnhook\
-- CARGO AUTOUNHOOK COMBO\
-- -----------------------------------------\
-- txt_AutoUnhook_Key\
-- RC+RS+K\
-- -----------------------------------------\
-- txt_TacUnook\
-- UNHOOK COMBO\
-- -----------------------------------------\
-- txt_TacUnook_Key\
-- RC+RS+:\
-- -----------------------------------------\
-- txt_CargoIndicator\
-- CARGO INDICATOR COMBO\
-- -----------------------------------------\
-- txt_CargoIndicator_Key\
-- RC+RS+P\
-- -----------------------------------------\
-- txt_Cargo_Rope_Length\
-- ROPE LENGTH\
-- -----------------------------------------\
-- txt_Cargo_Rope_Length_Value\
-- 15 M\
-- -----------------------------------------\
-- txt_Cargo_Status\
-- CARGO IS NOT CHOSEN\
-- ",
--     [10] = "-----------------------------------------\
-- #1#\
-- \
-- ",