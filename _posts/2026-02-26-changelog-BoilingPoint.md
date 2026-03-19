---
title: Upgrading your Map for Boiling Point
date: 2026-03-19 00:00:00 +0000
categories: [Map Modding]
tags: [maps, essential, patch, changelog, boiling point]
description: How to upgrade your Map to be compatible with Boiling Point
author: Delta|https://www.nexusmods.com/readyornot/mods/3072/
---

<style>
.embed-video {
  width: 100%;
  height: 100%;
  margin-bottom: 1rem;
  aspect-ratio: 16 / 9;

  @extend %rounded;

  &.file {
    display: block;
    width: auto;
    height: auto;
    max-width: 100%;
    max-height: 100%;
    margin: auto;
    margin-bottom: 0;
  }

  @extend %img-caption;
}
</style>

# Mapping Changes

## Overview

If you haven't read the previous Update changelog click here: [Change Log - Los Sueños Stories](/posts/changelog-LosSuenosStories){:target="_blank"}

Luckily not many changes are required for compatibility with the latest update. Here are the major things:

* ***The lighting bug that was present in the LSS Update has been resolved.***
  * The bug would result in some cooked assets not using static lightmaps and would glow in brightly lit scenes. 
  * Baked lighting now works IN GAME 
    * Some assets may still appear brightly lit in Editor, but will look correct when loaded in game.
    * Just double check how the map looks in game after building your lighting.

* ***There is now dedicated buttons to help automate the Paking process!*** 
  * The Automatic Mod Paker allows you with a single click of a button to cook, copy, pak and launch the game from the editor!
  * This saves a lot of time and will help us iterate faster.
  * This was previously Quick Cook created by *RareKiwi*, but now fully integrated into the framework.
  * [FULL GUIDE HERE: Automatic Mod Packing](/posts/mapping_gettingstartedue5#automatic-mod-packing-amp){:target="_blank"}

* ***World Gen can now be completely generated within the game and imported into your map with a click of a button.*** 
  * You no longer need to manually set up the world gen! 
  * The World Data Helper tool can also edit the imported World Gen to further customize things like stack up and clear points.
  * [FULL GUIDE HERE: Setting up Auto World Data Generation](/posts/mapping_autoworldgen){:target="_blank"}

* ***We are moving away from Blueprint versions of the `Door`, and using the game's native actors instead.*** 
  * You can also use the native `AISpawn` actor, but are fine to use the BP version as it has the ability to display the AI Mesh to spawn.
  * You will need to update your map to use the `Door` actor (found in the *Place Actors* window) for proper compatibility with World Gen.    
    * Doors will need completely fresh actors placed down - **DO NOT** Replace them using the editor.

> Using *"Right-Click > Replace Selected Actors with"* actually introduces a pretty tedious bug with Doors. It does not clean up the Door BP correctly and results in issues with World Gen and SWAT commands. In the worst case, it will require you to completely redo any edits made to custom Clear Points you make.
> 
> **YOU HAVE BEEN WARNED!**
{: .prompt-danger }

* ***Door Actors now block the Nav-Mesh where they are placed***
  * This is an intentional change. Previously the Nav-Mesh would ignore door actors/BPs in the Editor, and pathing would connect underneath the doors
  * There is a blocking component on Doors now which is required to make each Room's Nav-Mesh an 'Island' for World Generation to work correctly.

* ***Night-Vision now needs to have 2 overrides ticked within the MLD to make sure they are usuable***
  * If you have made significant changes to the Exposure values for your map, the Post Processing for NVGs will look muted/washed out (especially on darker maps) as the NVGs no longer override the Exposure values by default.
  * Within the Mod Level Datatable, make sure that `Override Min EV100` and `Override Max EV100` are enabled under *Data >  NVG Post Process Override*.

* ***You can now open Official VOID Maps as sub-levels***
  * To open the maps, make a New Empty Level and add the game's sublevels as the map's additional sublevels
    * _Art and _Lighting sublevels are always safe to open and what you want most the time.
    * _Core and _BarricadedSuspects can mostly be opened, but these are more likely to cause crashes. So just a heads up.
    * You will not be able to save or edit these maps as they are cooked.

## Map Audio Changes

* ***FMOD Events now require you to load (and unload) corresponding FMOD Banks from the Level that they are originally used in.***
  * We have created a Blueprint that sorts this out automatically called `BP_FMODEventBankLoader` *(Content > Mods > Template > Blueprints)* 
    * All you need to do is drag it into your level and it will sort out the loading and unloading for you!
  * This change was an internal VOID change to optimize memory.

* Music Timelines are still assigned in the Level BP, but SHOULD NOT be placed in the level. 
  * Doing so creates 2 instances of the Music and can give buggy behaviour.
* As always, make sure you always **DISABLE** `Auto-Activate` when placing FMOD Events in your level.

## Documentation Changes
* New guide for implementing Auto World Generation
* Getting Started Guide has been updated to reflect changes over the past couple of updates and to clarify some problem steps people were having
  * Also included steps for using the Automatic Mod Packing (AMP) plugin
* Getting Startred with Audio has been updated to reflect the new changes with loading/unloading Banks
  * Also fixed up some missing links
* Mod Level Data guide has been updated to be a little more readible
  * Also now has sections on spawn points

## Known Issues and Bugs 

* Breakable glass will not shatter/break from Flashbangs/Throwables if a Blocking Volume is in front or covering it but will still go through glass.
  * This is an RoN bug, not a framework bug.