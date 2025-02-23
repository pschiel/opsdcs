# Mini How-to: Plugins

## TOC
- [Introduction](#introduction)
- [1) entry.lua](#1-entrylua)
- [2) Cockpit scripts](#2-cockpit-scripts)
- [3) Flight model](#3-flight-model)
- [4) Radio menu](#4-radio-menu)
- [5) Sounders](#5-sounders)


## Introduction

This describes the structure of the LUA part of a plugin. It includes various object definitions, device and clickable logic, FM setup and more.

When using models (shapes), the EDM format is required.
See [Mini How-to: EDM](mini-howto-edm.md) how to create a basic one in Blender, including the needed elements to make things work in DCS.

For rocket scientists who need an external flight model (EFM), see [Mini How-to: EFM](mini-howto-efm.md) about the basic concepts. 


## 1) entry.lua

`entry.lua` is the entry point for plugins, executed once on DCS startup.

Purpose:
- declare the plugin (`declare_plugin`)
- adds units, weapons and sensors (`add_surface_unit`, `add_aircraft`, `declare_weapon`, `declare_sensor`)
- make resources available (`mount_vfs_*`)
- make aircrafts flyable by linking cockpit/fm/radio scripts (`make_flyable`)
- add plugin systems that load on top of other plugins (`add_plugin_systems`)

LUA environment stubs: [plugin-stubs.lua](stubs/plugin-stubs.lua)

Example: [entry.lua](../examples/Mods/aircraft/ac-minimal/entry.lua)


## 1.1) add_surface_unit

statics, ground units, navy, add_launcher

## 1.2) add_aircraft

## 1.3) declare_weapon

shells, gun mounts, bombs, air to air, cluster desc, rockets, missiles, torpedoes

## 1.4) declare_sensor

## 1.5) declare_loadout

## 1.6) add_plugin_systems


## 2) Cockpit scripts

When using `make_flyable`, several scripts from the cockpit scripts path (2nd argument) are executed each time when the cockpit gets loaded, in the following order.

## 2.1) device_init.lua

`device_init.lua` is the entry point for the cockpit scripts.

Purpose:
- mount models and textures related to the cockpit/avionics (`mount_vfs_*`)
- define the `MainPanel` device (id 0)
- define the `creators` array of devices
- define the `indicators` array of indicators
- define a few other attributes

LUA environment stubs: [device-stubs.lua](stubs/device-stubs.lua)

Example: [device_init.lua](../examples/Mods/aircraft/ac-minimal/Cockpit/Scripts/device_init.lua)

## 2.2) MainPanel

## 2.3) Devices

## 2.4) Indicators

## 2.5) sounds_init.lua

## 2.6) clickabledata.lua


## 3) Flight model


## 4) Radio menu


## 5) Sounders
