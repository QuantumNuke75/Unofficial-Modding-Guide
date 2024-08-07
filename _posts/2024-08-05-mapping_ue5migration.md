---
title: UE4 to UE5 Map Migration Guide
date: 2024-08-5 00:00:00 +0000
categories: [Map Modding]
tags: [maps]
description: An in-depth guide on migrating your map from UE4 to UE5
author: Delta|https://www.nexusmods.com/readyornot/mods/3072/
pin: true
---
# UE4 to UE5 Map Migration Guide

## 1. UE5 Template 
Download and Install Unreal Engine **5.3.2**: [https://www.unrealengine.com/en-US/download](https://www.unrealengine.com/en-US/download)
Download the following new UE5 Template and extract to your preferred location: [Download](Download)

## 2. UE4 Map Preparation
Nearly all of the previous work you have done can be ported over with exception of any Blueprints from the old Template. 

The following should be replaced (or deleted) with placeholder engine meshes so you can easily replace them after the migration:
- Landscapes (**DELETE!** You will need to remake these in UE5, but using a heightmap from your old Landscape can save you some time)
- BP_Doors_Reap
- BP_AISpawns_Reap
- BP_BreakableGlass_C
- FMOD Events
- RosterScenarioSpawner (Delete)
- WorldDataGenerator (Delete and no longer needed)
- BP_SpawnManager (Delete)
- BP_CoverGen (Delete)

`Ready Or Not Audio Volumes`, `Portal Volumes`, `Room Volumes`, `CoverGenOverride Volumes` can remain as they are still the same actors. If they do not work convert them to a BlockingVolume (Under Actors tab in Details) temporarily to convert back after migration.
`Sound_ParameterTransition_V2_BP_C` Blueprint can remain but it is likely you will need to reassign everything.

> You did organize your map already into nice folders in the Outliner right????
{: .prompt-tip }

## 3. FModel Setup
We no longer are using UModel anymore as it is no longer supported for UE5.

Download FModel: [https://fmodel.app/](https://fmodel.app/)
Download Mappings file: [Mapping File](https://unofficial-modding-guide.com/posts/ue4ss_and_mappings/#mappings-download)

1. If first time using, click the arrows for `ADD UNDETECTED GAME` and select `C:\SteamLibrary\steamapps\common\Ready Or Not\ReadyOrNot` as your directory AND press the `+` button.
2. Select the UE Version to be `GAME_UE5_3` and press OK
3. Go to Settings and under *General > Advanced*, Enable `Local Mapping File` and set the `Mapping File Path` to the downloaded Mappings file. (This will allow you to view the cooked content in FModel)
    * OPTIONAL: In *Settings > Models > Mesh Format*, change it to `glTF 2.0 (binary)` so you can export static meshes
    * Take note of your Export Directory

>You will need around 100GB free for the next part, we will be extracting the game's cooked assets so they will show up in your map, and unfortunately require a lot of space.
{: .prompt-warning }

4. On the Archives Tab, select all the .paks from the game and click Load.
5. On the Folders Tab, navigate to the `Content` folder and right-click and select `Export Folder's Packages Raw Data (.uasset)`. This will save all the cooked content from the game and might take some time.

Once complete move onto the next step

## 4. Copy Cooked Content to your Project

1. Close the new UE5 Template before continuing.
2. Navigate to where FModel exported the cooked assets and copy the `Content` folder (or drag if storage space is limited) to your Project's Content Folder.
    * This INCLUDES the shadercaches.
3. **DO NOT overwrite any files if prompted!** Just skip these files. If you overwrite them, you will need to start again from scratch with a new Project.

All the game's assets should be available in the project now, including working Materials, Decals and Particle Effects!

### Optional: Importing FMOD Events

If you wish to hear the QSM or ambient sounds follow these steps, there are placeholders if you do not wish to make your project folder any bigger:
1. Navigate to `C:\SteamLibrary\steamapps\common\Ready Or Not\ReadyOrNot\Content\FMOD` and copy the `Desktop` folder.
2. Navigate to your projects `...Content\FMOD` folder and paste the `Desktop` folder here.

## 5. Migrating your UE4 map to the new UE5 Project

1. Make sure the UE5 Template is closed before continuing.
2. In your UE4 Project, right click on your Level and select *Asset Actions > Migrate*
3. **DESELECT** everything first. We do not want to copy ANY of the old Blueprints or Cooked Content
4. Navigate to your `Mods > YourUsername` section (where your Map *SHOULD* be located) and **ONLY SELECT** these files (or any Files YOU created and want to carry over). Hit OK.
    * You do not need to copy over any previous contents from `Mods > Reap`
5. In the new Window, select the location of the `Content` folder of the UE5 Project and proceed.
6. Once complete open up your map in the UE5 Project and inspect the result.

> If you Level wont open or crashes the Editor, I would recommend taking a more manual process to migrating the map. Following up to step 5, instead create a new Level and manually Copy-Paste assets between Editors. **DO NOT** copy anything RoN Specific this time. Make sure not to have any Landscapes either.
{: .prompt-tip }

## 6. Fixing Issues and missing Assets

### Fixing Inverted Collision from Migration

> There is a serious bug that occurs when migrating from 4.27 to 5.3, any custom Static Meshes you bring into the project will have their collisions Inverted. Thankfully VOID also encountered this and helped with the solution (major thanks to killowatt & RareKiwi for this)
{: .prompt-warning }

To fix this:
1. Select all Static Meshes that you migrated in the content browser.
    * Easiest way to do this is just select your mod username directory and filter for Static Meshes 
    * If you turn on `Player Collision` view mode, you will see all the normals on the collisions of your assets are flipped if placed in a level
3. With the meshes selected right-click and select *Scripted Actor Actions > Collision Fix Up*.
    * This will iterate through the meshes and correct their collision.
4. Verify they are correct in `Player Collision` view mode.

Alternatively, you can do the same steps on selected actors within a Scene by right-clicking them and selecting *Scripted Actor Actions > Collision Fix Up*

### Reassigning NULL Static Meshes

If you have followed the steps up to this point, the map should be mostly still intact. Most of the cooked assets from UE4 have remained in the same location in UE5, but now you can also view their materials!

There is mostly likely going to be a few hundred missing cooked assets due to files being moved by VOID with the update. To identify what is missing, click *Build > Check Map*.

All missing assets should say "Static mesh actor has NULL StaticMesh property". Provided you haven't renamed any files it should be pretty straight-forward to find the same named asset in the Content Browser and replace them in the scene. Unfortunately there is not an easy/fast way to do this, so brew a cuppa and get to work.

> If you do Step 5 before Step 4, **ALL** of the references to previous cooked contents might return NULL, instead of just a few. Just to be safe, make sure the cooked content is in the project before Migrating or Copying
{: .prompt-tip }

### New Basic Map Requirements and Changes

> Do not click `Build All`, currently doing so will lock the Editor in "Building Texture Streaming" and will require you close it via Task Manager. You unfortunately have to Build Geometry, Paths and Lighting separately now.
{: .prompt-warning }

Things mostly remain the same, however the following changes to workflow are needed to make sure that the map runs correctly:
* Set the Level Blueprint Parent Class type to `Ready or Not Level Script` 
    * Not doing so will result in things not working properly, specifically objectives, spawns and QSM/FMOD
* **DO NOT** set `ItemData` datatable in the `Item Data` field of the Blueprint Class
    * If included, cooking will fail - there is a dummy `ItemData` in the project that shouldn't cause this. But better safe than sorry.
    * **REMEMBER TO REMOVE IT** after you have migrated from UE4 - it may still be assigned.
* Add a `RosterScenarioSpawner` actor
    * Without it the map will crash on Level load
* `BP_SpawnManager_V3` is required now (located in `Mods > Template > Blueprints`)
    * Without it no AISpawns will not work
* Make sure that all `BP_AISpawns_Managed` have "*Managed*" assigned to their *Details > Actor > Tags* 
    * Without it no AI will spawn even with the Spawn Manager
    * This may happen if you *Right Click > Replace Selected Actors* with on placeholder actors after the migration.
* Add a `BP_CoverGen` actor
    * Without it AI won't really move or do anything when engaged in fights
* Multple PlayerSpawns are no long spawn the SWAT AI on them; they will all spawn on your PlayerSpawn. You only need 1 PlayerSpawn per actual Spawn Point (set in ModLevelData Table).
* QSM Changes - *Documentation Soon™*


## 7. New Cook & Pak Method

Cook and Paking remains the same process as before but there are 2 important things that have changed.

### Updated .bat Pak file
You NEED to use the new updated .bat with the UE5.3 files (do not just edit your existing one):
[More Info](https://unofficial-modding-guide.com/posts/batchfiles/)

```batch
@setlocal ENABLEDELAYEDEXPANSION
@if "%~1"=="" goto skip
@setlocal enableextensions
@pushd %~1
(for /R %%f in (*) do @set "filePath=%%f" & set "relativePath=!filePath:%~1=!" & @echo "%%f" "../../../ReadyOrNot!relativePath!")>"%~dp0/filelist.txt"
@pushd %~dp0
::-compresslevel=4 for Normal, -compresslevel=-4 for uncompressed hyperfast paking
.\UnrealPak.exe "%~1.pak" -create=filelist.txt -compress -compressionformats=Oodle -compressmethod=Kraken -compresslevel=4
@popd
@pause
:skip
```

### Delete Global ShaderArchives
Cooking a map now produces Shadercaches, there is an extra step needed for cooking to prevent them from being cooked but still provide the necessary ones for your materials and .uassets:
1. Before you cook, go to *Edit > Project Settings > Packaging*, and disable `Share Material Shader Code` - **BUT DO NOT RESTART THE EDITOR!**
2. Cook your map as usual.
3. When cook is complete, re-enabled `Share Material Shader Code`.

> **The above method should be used if you are sharing/distributing your final map .pak. If you include shadercaches that aren't just your own materials than we might run into conflicts.**
{: .prompt-warning }

*For faster development however* - you can just cook and copy the `Content` folder as usual without always needing to disable/enable `Share Material Shader Code`. HOWEVER if you include files named similar to `ShaderArchive-Global-PCD3D_SM5-PCD3D_SM5` then Ready Or Not will crash on launch. So before you Pak your map, make sure you delete the all the ones named `ShaderArchive-Global...` (you can leave the others) from the Content folder. If you delete the other ones some of your custom materials may not render properly in-game. 

**JUST REMEMBER TO DO THE COOK METHOD MENTIONED FIRST FOR DISTRIBUTION!**


## Cool stuff in the New Template!!!!11!!1!!11
* In `Mods > Template > Levels` there are 2 Maps:
    * **RoN_Template** is a barebones map that is the absolute bare minimum to get a level working. 
    * **RoN_ExampleMap** showcases how to build a map. It has information on the Spawn Manager, Objectives, QSM and working with the FMOD, along with some other interesting bits of information
    * In general the layout of information and Blueprints we actually use is a lot cleaner now.

* We now have the ***Actor Palette Plugin*** enabled. This allows you to open up a level under *Tools > Actor Palette*. Doing so allows you to drag and drop Assets from the window into you map with ease! [Very cool~](https://www.youtube.com/watch?v=ym6kLi0EYQs)
    * There are a bunch of maps in `Mods > Template > Levels > ActorPalette` that you can load to test
    * Warning: These maps require a LOT of memory as they are loading essentially all the usable props from cooked assets. I would not open `Palette_MASTER` unless you have a strong PC.
 
* We can now create custom doors from our own DoorData DataTables (and there are tools to help copy over Door and AI rows from cooked assets courtesy of RareKiwi).

## Known Bugs

* Double doors do not seem to work as double doors after the first load of the game, this seems to be an issue with the World Generation that is out of our hands for now.
* When saving or opening a Level, the editor will ask you save changes to `BP_Makarov_2Handed_AnimData` and `BP_Tec9_AnimData`, you can ignore these. Saving wont break the project if you do. 

## Credits and Thanks

Kingly credits need to go to **RareKiwi** for his dedication to updating the project and previous Blueprints. It is no small thing to say that without him, we would not have the new Template.

Additional Credits to KITT, StenTheAwesome, Delta, Reap, The Real Sourc3 and to the beautiful VOID Interactive Devs (killowatt, Zack, QuantumNuke and Hunter).
