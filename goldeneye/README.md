# Goldeneye v2

Reconnaissance script

Based on [Goldeneye](https://github.com/VF29Voodoo/Goldeneye-DCS-Recon-Script)
and [Recon v2](https://github.com/Yink059/DCS-Scripts/blob/main/recon_v2.lua)


## Installation (mission only)

Puts everything into a mission file, runs without additional hook.

Camera features (handheld, screenshot) will not be available in MP.

1. Copy folders [aircraft](aircraft) and [cameras](cameras) into your mission MIZ file.

2. Add a mission start trigger with action `DO_SCRIPT_FILE` and select the [goldeneye-mission.lua](goldeneye-mission.lua) script.


## Installation (hook)

The hook will auto-inject the script into any mission loaded, so you don't have to edit any mission at all.

Mission name patterns for auto-injecting can be defined inside the hook script.

1. Copy the entire [goldeneye](.) folder into `Saved Games/DCS/Scripts`.

2. Move [goldeneye-loader.lua](goldeneye-loader.lua) into `Saved Games/DCS/Scripts/Hooks`.

*Note: Sounds and images will still have to be copied into the MIZ, otherwise they are not available to clients. (WIP)*


## For development/testing (mission only)

Change mission start trigger to action `DO_SCRIPT` with following text (adjust path):

`dofile([[C:/Users/ops/Saved Games/DCS/Scripts/goldeneye/goldeneye-mission.lua]])`

This enables quick changes to the script that will be active on mission restart (otherwise you need to update the file in the mission editor).
