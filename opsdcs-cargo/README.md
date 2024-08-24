# opsdcs-cargo

Cargo mod to sling them all.

Features:
- Cargo static equivalents for armored, air defense, artillery and more (up to ~10 tons)
- Slingload capability for all statics
- Converts statics to units when dropped
- Convert nearby units to cargo statics via F10
- Simulates bambi bucket water filling for fire fighting (no zones needed, autodetects water)
- Simulates fire fighting (creates fires in named zones, extinguish with bambi bucket)

## Installation

Copy `Mods` and `Scripts` folders into `Saved Games/DCS`.

Copy `Data` folder into DCS installation folder.

## Credits

Bambi bucket taken from https://forum.dcs.world/topic/103564-addon-tents-watchtower-uh-1-cargo/

## TODO

- better collision shapes
- better cargo csv data
- disable ingame voice

## List of cargo statics

    AIR DEFENSE
    Name                                 Weight   Shape
    ----------------------------------------------------------------
aaa 8.8cm flak 18 4000
aaa 8.8cm flak 36 4500
aaa 8.8cm flak 37 5000
aaa 8.8cm flak 41 6000
aaa bofors 40mm 2300
aaa fire can son-9 6500
aaa flak 38 20mm 1000
aaa flak-vierling 38 quad 20mm 1500
aaa kdo.g.40 1800
aaa ks-19 100mm 9200
aaa m1 37mm 2500
aaa m45 quadmount hb 12.7mm 1100
aaa qf 3.7" 8000
aaa s-60 57mm 4700
aaa zu-23 on ural-4320 9200
allies rangefinder (DRT) 4500
hq-7 ln 9000
hq-7 self-propelled ln 9000
hq-7 self-propelled str 9000
maschinensaty 33 gen 3000
sam avenger (stinger) 4200
sam chaparral m48 10500
sam hawk cwar an/mpq-55 2200
sam hawk ln m192 9000
sam hawk platoon command post pcp 3000
sam hawk sr an/mpg-50 5000
sam hawk tr an/mpq-46 6500
sam nasams c2 5000
sam nasams ln aim-120b 5000
sam nasams ln aim-120c 5000
sam nasams sr mpq64f1 4500
sam patriot c2 icc 7500
sam patriot ecs 7500
sam rapier blindfire tr 5000
sam rapier ln 2000
sam rapier tracker 1500
sam sa-2 s-75 guideline LN 7000
sam sa-2 s-75 rd-75 amazonka rf 8000
sam sa-9 strela 1 gaskin TEL 7500
SL flakscheinwerfer 37 8000
SPAAA HL with ZU-23 6000
SPAAA LC with zu-23 4500

[CH GER] skyshield c-ram 4600
[CH GER] wiesel 2 ozelot vshorad 4780
[CH SWE] rbs 90 stationary lam ln vshorad 100

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
AH-1W 7000
OH-6A 2000
SA342L 2000
SA342M 2000
SA342Minigun 2000
SA342Mistral 2000
UH-1H 4500
[CH RUS] Ka-52 AH 7700
[CH SWE] HKP 15B LUHuh  4000

    PLANES
    Name                                 Weight   Shape
    ----------------------------------------------------------------
[CH TRK] TB2 UCAV 400
