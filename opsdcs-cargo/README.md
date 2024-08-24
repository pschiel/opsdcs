# opsdcs-cargo

Cargo mod to sling them all.

## Features

- Cargo static equivalents for armored, air defense, artillery and more (up to ~10 tons)
- Slingload capability for all statics
- Converts statics to units when dropped (WIP)
- Convert nearby units to cargo statics via F10 (WIP)
- Simulates bambi bucket water filling for fire fighting (no zones needed, autodetects water)
- Simulates fire fighting (creates fires in named zones, extinguish with bambi bucket) (WIP)

## Installation

Copy `Mods` and `Scripts` folders into `Saved Games/DCS`.

Copy `Data` folder into DCS installation folder.

If you don't have the [CH Assets](https://www.currenthill.com/) installed, use the `entry-no-ch.lua` file instead of `entry.lua`.

## Credits

Bambi bucket model+textures taken from https://forum.dcs.world/topic/103564-addon-tents-watchtower-uh-1-cargo/

## TODO

- better collision shapes (currently bambi bucket collision edm is used for all missing)
- better cargo csv data (currently copied from oil barrel)

## List of cargo statics

    AIR DEFENSE
    Name                                       Weight   Shape
    --------------------------------------------------------------------
    AAA 8.8cm Flak 18                          4000     flak18
    AAA 8.8cm Flak 36                          4500     flak36
    AAA 8.8cm Flak 37                          5000     flak37
    AAA 8.8cm Flak 41                          6000     flak38
    AAA Bofors 40mm                            2300     bofors40
    AAA Fire Can SON-9                         6500     son-9
    AAA Flak 38 20mm                           1000     flak30
    AAA Flak-Vierling 38 Quad 20mm             1500     flak38
    AAA Kdo.G.40                               1800     KDO_Mod40
    AAA KS-19 100mm                            9200     KS-19
    AAA M1 37mm                                2500     M1_37mm
    AAA M45 Quadmount HB 12.7mm                1100     M45_Quadmount
    AAA QF 3.7                                 8000     QF_37_AA
    AAA S-60 57mm                              4700     S-60_Type59_Artillery
    AAA ZU-23 on Ural-4320                     9200     Ural_ZU-23
    Allies Rangefinder DRT                     4500     Bedford_MWD
    HQ-7 LN                                    9000     hq7_ln
    HQ-7 Self-Propelled LN                     9000     hq7_ln
    HQ-7 Self-Propelled STR                    9000     hq7_str
    Maschinensatz 33 Gen                       3000     Maschinensatz_33
    SAM Avenger Stinger                        4200     HMMWV_M973
    SAM Chaparral M48                         10500     M48
    SAM Hawk CWAR AN/MPQ-55                    2200     hawk-cwa
    SAM Hawk LN M192                           9000     hawk-pu
    SAM Hawk Platoon Command Post PCP          3000     hawk-cv
    SAM Hawk SR AN/MPQ-50                      5000     hawk-rls
    SAM Hawk TR AN/MPQ-46                      6500     hawk-upr
    SAM NASAMS C2                              5000     NASAMS_Command_Post
    SAM NASAMS LN AIM-120B                     5000     NASAMS_Missile_Launcher
    SAM NASAMS LN AIM-120C                     5000     NASAMS_Missile_Launcher
    SAM NASAMS SR MPQ64F1                      4500     NASAMS_Radar_MPQ64F1
    SAM Patriot C2 ICC                         7500     patriot-kp
    SAM Patriot ECS                            7500     patriot-ECS
    SAM Rapier Blindfire TR                    5000     rapier_fsa_blindfire_radar
    SAM Rapier LN                              2000     rapier_fsa_launcher
    SAM Rapier Tracker                         1500     rapier_fsa_optical_tracker_unit
    SAM SA-2 S-75 Guideline LN                 7000     S_75_Launcher
    SAM SA-2 S-75 RD-75 Amazonka RF            8000     RD_75
    SAM SA-9 Strela 1 Gaskin TEL               7500     9p31
    SL Flakscheinwerfer 37                     8000     flak37
    SPAAA HL with ZU-23                        6000     ttHL-zu23
    SPAAA LC with ZU-23                        4500     tt70-zu23
    [CH GER] Skyshield C-RAM Gun               4600     CH_Skyshield_Gun
    [CH GER] Wiesel 2 Ozelot VSHORAD           4780     Wiesel2_Ozelot
    [CH SWE] RBS 90 Stationary SAM LN           100     RBS-90-lod0


    ARMORED
    Name                                 Weight   Shape
    ----------------------------------------------------------------
    APC M2A1 Halftrack                   9300     M2A1_halftrack
    APC Sd.Kfz.251 Halftrack             7800     Sd_Kfz_251
    ATG HMMWV                            5000     HMMWV_M1045
    Car Daimler Armored                  7600     Daimler_AC
    Scout BDRM-2                         7000     brdm-2
    Scout Cobra                          4800     Otokar_Cobra
    Scout HL with DSHK 12.7mm            7500     ttHL-dshk
    Scout HL with KORD 12.7mm            7500     ttHL-kord
    Scout HMMWV                          4600     HMMWV_M1043
    Scout LC with DSHK 12.7mm            7500     tt70-dshk
    Scout LC with KORD 12.7mm            7500     tt70-kord
    Scout M8 Greyhound AC                7800     m8_greyhound
    Scout Puma AC                        8500     Sd_Kfz_234_2_Puma
    Tk Tetrarch                          7600     Tetrarch
    Tractor M4 High Speed                8500     M4_Tractor
    [CH GER] Eagle IV MRAP               8000     CH_EagleIV
    [CH GER] Wiesel 1A4 AWC              2800     Wiesel1A4
    [CH USA] Oshkosh L-ATV (M2)          6400     OshkoshLATV_M2
    [CH USA] Oshkosh L-ATV (Mk19)        6400     OshkoshLATV_MK19
    [CH USA] Oshkosh M-ATV MRAP (M2)    11000     OshkoshMATV_M2
    [CH USA] Oshkosh M-ATV MRAP (Mk19)  11000     OshkoshMATV_MK19
    [CH RUS] Tigr-M                      7000     TigrM
    [CH SWE] Bv 410 ATV                  8000     BV410-lod0
    [CH SWE] Volvo 740 IFV               3000     Volvo740-lod0
    [CH UKR] BRDM-2L1 ARV                7000     BRDM-2L1
    [CH UKR] Kozak-5 APC                 8000     Kozak5
    [CH UKR] KrAZ SPARTAN APC            8800     KrAZ_Spartan


    ARTILLERY
    Name                                Time   Min   Max   Weight   Turns   Shape
    -----------------------------------------------------------------------------------------
    FH LeFH/18 105mm                      9s     -   10k    1900    [x]     LeFH_18-40-105mm
    FH M2A1 105mm                         6s     -   11k    2200    [x]     M2A1-105mm
    FH Pak 40 75mm                        5s          3k    1500    [x]     Pak40
    L118 Light Artillery Gun 105mm        6s   500   17k    2100    [x]     l118_cargo
    MLRS HL with B8M1 80mm               32s     -    5k   11000    [x]     ttHL-B8M1
    MLRS LC with B8M1 80mm               32s     -    5k   11000    [x]     tt70-B8M1
    Mortar 2B11 120mm                     6s    30    7k     200    [x]     2B11
    SPM 2S9 Nona 120mm M                  9s    30    7k    9000    [x]     2-c9
    SPH Sd.Kfz.124 Wespe 105mm           22s     -   10k   11000    [x]     Wespe124
    [CH USA] M777 LTH M795                6s     -   23k    4100    [-]     M777
    [CH USA] M777 LTH M982 Exc           28s   20k   40k    4200    [-]     M777
    (turns = will turn to target when fire at point)


    HELICOPTER
    Name                                 Weight   Shape
    ----------------------------------------------------------------
    OH58D                                1600     OH58D
    AH-1W                                7000     AH-1W
    SA342L                               2000     SA342L
    SA342M                               2000     SA342M
    SA342Minigun                         2000     SA342minigun
    SA342Mistral                         2000     SA342mistral
    UH-1H                                4500     ab-212
    [CH RUS] Ka-52                       7700     CH_Ka-52
    [CH SWE] HKP 15B LUH                 4000     HKP15B

