---
title: Change Log - Los Sueños Stories
date: 2025-08-12 00:00:00 +0000
categories: [Change Logs]
tags: [mapping, patch, changelog, change log, los suenos stories, lss]
description: Modding related changes and fixes for Los Sueños Stories update.
author: RareKiwi
pin: true
hidden: false
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

### LSS Update: Soft References

Mesh and class variable properties were widely changed from hard referenced to soft referenced. This means those properties are not loaded automatically when the class or blueprint is loaded. 
This is great for load times and memory usage, but does mean a few of the template blueprints broke, as well as a few data class types which you may have made custom versions of.

- Door Spawners: Fix required
  - Door Data Tables; 
  - Door Static Mesh
  - Chunk Meshes
  - Door Handle Meshes  
- AISpawn_Managed: Working, but fix required for editor preview character 
  - Body + Head Mesh
  - Class Refs in Weapon Loadouts
- SpawnIncap_v2
  - Same as AI Spawn
  
### Moved Destructibles

Almost all destructibles such as breakable glass, bottles, vehicles etc have been moved to `\Content\ReadyOrNot\Level\Destructibles\`  
The framework includes a breakable glass child bp in the old location with a notification so you can replace it or move it.

### Frame Work Update: More Native Classes & Deprecation

Many of the door related blueprints construction scripts have been added to the base C++ classes so that they can now be used natively like VOID would. While you don't have to migrate an existing map to them, the old classes have been moved to an extra `"Deprecated.zip"` within the download, now that they are redundant. 

Old Door Spawners are still a valid method once fixed, however the related world data blueprints will have doubled up billboard components and in some cases may need a few fixes to disable the doubled up C++ logic. Only old cover point blueprints need a non cosmetic fix. See [here](#cover-point-fix--world-data-blueprint-visual-fixes) for a fix video.

Advantages; 

 - Easy to update template.
 - Mappers don't need to fix blueprints with game updates.
 - Mappers don't need to make their own copy of blueprints to avoid conflicts.
 - Tools can point to native C++ classes so they don't also need to be copied by mappers.

Blueprints moved to Deprecated.zip

- BP_CoverGen & BP_CoverGen_Saver
   - Use BP_CoverGen_Framework instead.
- BP_Door_Spawner_v2 & BP_Door_Spawner_V3
   - Use Door instead.
- BP_LightBlocker
   - Use BP_LightBlocker_Framework instead.
- Everything in World Data folder
   - Use base classes/cooked game blueprints instead.

Changed Blueprints;

- BP_AISpawn_Managed (AISpawn): 
  - Editor Billboard and arrow added via class construction script. 
  - Actor tag "Managed" added via class construction script if missing. 
  - BP has seed added for matching preview head/body.
- EUW_Tool_WorldDataHelper_Framework 
  - Moved to /Mods/Tools along with /Assets
  - Refactored to use native C++ classes.
- BP_CoverGen_Framework
  - Uses native class for save game. No blueprint references.
- BP_CoverLandmarkProxy_Closet_Child
  - Other landmarks can use cooked game classes now.
  - This still has begin play code for the interaction prompt etc 
- BP_CoverPoint_Single_Framework
  - A single coverpoint with location lock off and an automatic rail setup.
- BP_LightBlocker_Framework
  - Refactored to use native C++ doors, NOT spawners.

#### Conversion
If you would like to convert an existing map anyway, there is a WIP tool;  EUW_Tool_OldWD_Convert  

This is for Doors, Stackup Actors, Threats and Rooms and is based on actor location.  
For doors, only the type and world data properties are set. Doors need to be assigned to "Attached Actors" on portals.
Look At Points are not converted.  
Even if you don't have world data, you should be able to use this also for BP_Door_Spawner_V2 to set the door type in bulk.

See [video guide](#wip-euw_tool_oldwd_convert-conversion-tool-usage) for usage.

### Difficulties

With the LSS update the AILevelData.ini was refactored into three Difficulty.ini  
What is interesting for us mappers, is that custom difficulties can also be created, included with your map pak and loaded with your map, without map or mods conflicting. Users/other modders can also create patch difficulty paks specifically for your map if they want to tweak the experience.

This means, optionaly, you can not use the BP_SpawnManager_v3 anymore and instead use the game's native spawn Min and Max configs as well as spawn groups. This also lets you configure the number of bomb actors so you don't need a BP_BombSpawner either.

Any configs like timing for bombs, AS timers, Stress, Roamers, Locked Door %, Trap Count etc are fully customizable.

 > The new custom Cook button automates the copying of the \Config\Difficulties folder to your cooked content.
 {: .prompt-tip }

There is an example level; 
 - `RoN_DifficultyExampleMap`{: .filepath}  
and  
 - `/Config/Difficulties/CustomMapDifficulty_RoN_Difficulty_Standard.ini`{: .filepath}  
as an example.  [Check out the guide](/posts/mapping_CustomDifficulty) for custom levels.

### Quality of Life C++ class tweaks and additions.

Many other Ready or Not classes have had editor only billboard components added to them for easier selection and id. Brushes and boxes have unique line colors where possible and construction scripts have been added for some classes like the landmarks so that child BP's are not needed to vizulize their setups.  
On the editor toolbar there is a new custom Cook button next to platforms, which automates temporarily disabling ShareShaderCode, Cooking and copying difficulty configs.

Also up there are shortcuts for the map build functions as well as some folder shortcuts you can customize.  
Additionally because of the change to soft references, cooking should succeed on the first run, due to the class with a broken mat/ref (I think one of the weapons) no longer being loaded.

## Mapping Fix Guides

### Door Spawners

 > If you have an existing map and intend to fix old blueprint copies, be sure to extract "Deprecated.zip".  
 {: .prompt-warning }

Old copies of BP_Door_Spawner_v2 and BP_Door_Spawner_v3 will be broken in game and need to be fixed for existing maps.  
For BP_Door_Spawner_v2, in Windows Explorer you can copy the fixed version (from /content/mods/template/blueprints/ to your existing map copy and overwrite it (with the editor closed).  

Old copies of BP_Door_Spawner_v3 will need to be fixed manually due to other copied assets referencing it, and it referencing others.  
See the video below for how to copy the fixes from the template blueprint to your old one.  

{%
  include embed/youtube.html
  id='PDRFSXcCcXY'
  autoplay=false
  loop=true
  muted=true
%}

### AI Spawn

Old copies BP_AISpawn_Managed will still function in game but old copies' character preview won't work. You can just copy the fixed version from the template to your existing map folder in windows if it's not been modified.

{%
  include embed/youtube.html
  id='MULk5kmqoDk'
  autoplay=false
  loop=true
  muted=true
%}

### Cover Point Fix + World Data Blueprint visual fixes

Existing cover points need a construction script edit to fix their location. Old cover point single bps also need a class default change.  
See the video for guidance.  

Old World data BPs will still work, but have doubled debug visulizers.  
See the video on how to optionally fix them.  

{%
  include embed/youtube.html
  id='bxTk2iPj-yw'
  autoplay=false
  loop=true
  muted=true
%}

### WIP EUW_Tool_OldWD_Convert conversion Tool Usage

Not really recommended unless you want to redo some stuff. Not all properties are going to be copied. 
Door type and world data values are only set for example.  

 > Custom door data tables still need to use a child BP to fix a hardcoded bug. See `BP_Door_Framework`.

{%
  include embed/youtube.html
  id='YA7y_dw_RLE'
  autoplay=false
  loop=true
  muted=true
%}

# Other Modding changes

 - /Config/AILevelData.ini was refactored into three Difficulties.ini in /Config/Difficulties/
 - /VO voice line folder was moved into the game paks as /Content/VO_PC/
 - Mod Spawn Actor Data asset class was added to load mod blueprint actors on map loads.
 - Widespread changes to classes changing media assets and classes from hard to soft references.