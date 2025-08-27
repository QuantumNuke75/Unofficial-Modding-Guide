---
title: Mod Level Data
date: 2024-08-23 00:00:00 +0000
categories: [Map Modding]
tags: [maps, mod level data, brief, briefing, description, objective, entry points ]
description: Intermediate guide for levels' MLD and objectives.
author: RareKiwi
pin: false
---

# Overview

A Mod Level Data (**MLD**) is a data asset you can include in your pak to customize the following for level;
 - Show in mission Select true/false
 - Level Display Name, Nickname and Designation
 - Level Picture
 - Level Description
 - Mission Select Preview Map
 - Objectives
 - Entry Points
 - Briefing Images and Map Image
 - Briefing Biographies
 - Briefing Timeline  
  
 > By default, if you don't include a MLD for your level, the game will create one at run time based on the file name and display it in the levels list.  
 > That also includes the default Objectives; BringOrderToChaos and RescueAllCivilians.
 {: .prompt-info }
 
# Basic MLD Setup

## 1.) Creation

To create a MLD you can use two methods:

### A) Manual

1. In the content browser navigate to your level's content directory and optionally add a ModLevelData folder
2. Within your folder, press the `+ Add` button in the top left, and create a `Miscellaneous > Data Asset`
3. In the popup window, search for *mod level data* and chose the `Mod Level Data` class, then press **Select** to create it.
4. Naming isn't essential, however, usually you want to use: `MLD_YourLevelFileName`

### B) Scripted Asset Action

This is the same process as above, but is automated.

1. Optionally add a ModLevelData folder to your level directory.
2. Select your level/s and right-click it. Press `Scripted Asset Actions -> Create Mod Level Data`
3. For the first/only level selected; 
	 - In the file selector, chose a location in your level directory, like the folder you created in step 1.)
	 - Don't change the name.
4. For the first/only level selected; 
	 - In the popup window, search for *mod level data* and chose the `Mod Level Data` class, then press **Select** to create it.
5. Find your MLD in the chosen folder and save them.

 > This action will work with multiple levels selected  
 >  - Create data asset and set MLD file name automatically
 >  - Set `Level Name` automatically to level file name + `Friendly, Nickname and Designation`.
 >  - Set default `Objectives`
 {: .prompt-tip }
 
 > Folder path is based on first level options in step 2.)  
 {: .prompt-info }
 
## 2.) Configuration

1. Open your new Mod Level Data asset
2. Set the very, very top `Level Name` variable to the file name of your level.  

	 > There are some hard-coded forbidden names you must avoid such as `house` and any vanilla Ready Or Not map names.  
	 {: .prompt-danger }
 
3. Expand `Data` if not already and set values for `Friendly Level Name`, `Level Nickname` and `Level Designation`.  
	 These are the user-facing display names, so can differ from your file name. 
4. If missing; find the `Objectives` array and add `+` two entries.
	 - Set one to `BringOrderToChaos`
	 - Set the second to `RescueAllOfTheCivilians`  
	 
	 > By default, after creating a custom MLD for your level, these are missing, so your mission will auto complete if you do not add them now.  
	 {: .prompt-warning }
	 
## 3.) Cooking

By default when you specify your level to be included in the build (in Packagaing Settings) there is no reference chain to your Mod Level Data assets.  

Some basic solutions to this is to include the MLD contain folder in the extra directories to be cooked or by referencing it in your level blueprint.  

The Los Suenos Stories Framework update includes a simple blueprint actor you can also now use.

1. Open your level which is setup in the Project Settings to be cooked.
2. Go to /Content/Mods/Template/Blueprints/ (or your copy)
3. Place a `BP_ModLevelDataReferencer` in your level.
4. Add an entry to `Mod Level Datas` and use the picker to find and add the MLD you created earlier.
	 > If you have many MLD you want reference, you can select them all in the Content Browser, then drag them onto the `Mod Level Datas` property to quickly add them all.  
	 {: .prompt-tip }
 
That's it. There's now a reference chain to your MLD so it will be automatically included in your cook when your map is set to cook.

# Mission Select Image and Preview Level

TBD

# Entry points

TBD

# Objectives

TBD

# Using Vanilla Levels for Reference

Ready or Not's vanilla levels now use a similar data asset class to fulfil the same goals that the MLD does for modded levels.  
If there's something yout want to know that the guide doesn't cover you can often check out how it's done in vanilla levels.
However with UE5 you can no longer even open the read only cooked game assets.  

Instead you can use the EUW_Tool_ObjectViewer widget located in `/Content/Mods/Tools/`  
With this you can drag in any cooked game asset that doesn't crash when loaded (and isn't a data TABLE), and see what properties have been configured in a GUI format.

 > Although it will let you edit values, they will not be saved/saveable and often crash your editor so don't do that ;)
 {: .prompt-danger }
 
# Briefing Audio

Because the briefing audios are hard-coded to FMOD events there's no direct way to customize this for your level.
There is the old `/Content/Mods/Template/Blueprints/Audio/BP_BriefingAudioSpawner` which uses the Mod Sound event and FMOD programmer sounds to hackily play audio somewhat unreliably.

Guide/Rework of that TBD