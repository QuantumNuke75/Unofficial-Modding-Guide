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

A Mod Level Data (**MLD**) is a data asset you can include in your pak to customize the following for a level;
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
 > That auto MLD also includes the default Objectives; BringOrderToChaos and RescueAllCivilians.
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
 
 > When run with multiple levels selected, the folder path is based on the first level's popup choice in step 2.)  
 {: .prompt-info }
 
## 2.) Configuration

1. Open your new Mod Level Data asset
2. Set the very, very top `Level Name` variable to the file name of your level.  

	 > There are some hard-coded forbidden names you must avoid such as `house` and any vanilla Ready Or Not map names.  
	 {: .prompt-danger }  
	 
	 ![Example Map MLD Name](/assets/modleveldata/mld_examplemap.png){: w="438" h="370" }
	 _Example Map MLD **"Level Name"** set to the level's file name_  
 
3. Expand `Data` if not already and set values for `Friendly Level Name`, `Level Nickname` and `Level Designation`.  
	 These are the user-facing display names, so can differ from your file name. 
4. If missing entries; find the `Objectives` array and add `+` two entries.
	 - Set one to `BringOrderToChaos`
	 - Set the second to `RescueAllOfTheCivilians`  
	 ![Example Map MLD Name](/assets/modleveldata/mld_examplemap_objectives.png){: w="435" h="85" }  
	 
	 > By default, after creating a custom MLD for your level, these are missing, so your mission will auto complete if you do not add them now.  
	 {: .prompt-warning }
	 
## 3.) Cooking

By default when you specify your level to be included in the build (in Packaging Settings) there is no reference chain to your Mod Level Data assets.  

Some basic solutions to this are to include the MLD containing folder in the extra directories to be cooked (project settings) or by referencing the MLD in your level blueprint.  

The Los Suenos Stories Framework update includes a simple blueprint actor that you can also now use.

1. Open your level which is set in the Project Settings to be cooked.
2. Go to /Content/Mods/Template/Blueprints/ (or your copy)
3. Place a `BP_ModLevelDataReferencer` in your level.
4. Add an entry to `Mod Level Datas` and then use the picker to find and add the MLD you created earlier.
	 > If you have many MLD that you want to reference, you can select them all in the Content Browser, then drag them onto the `Mod Level Datas` property to quickly add them all.  
	 {: .prompt-tip }
 
That's it! There's now a reference chain to your MLD so they will be automatically included in your cook when your map is set to cook.

# Mission Select Image and Preview Level

## Screen Shots

### Capture

We'll need an image for the MLD and for our mission selector level later. You can either take this in game or in editor.  
For in game; 
 * Use a mod like **"Console Unlocker - Camera Mod"** to free cam
 * Set your resolution to 16x9 if you have a ultra-widescreen.
 * Set any upscaling to off or native.
 * Set game resolution to >= 100%
 * Take your screenshot with steam ( F12 ), Print Screen key, Windows Snipping Tool ( Windows Key + Shift + S ) or even better;
 * If you have a console enabled (via UE4SS etc) you can run `highresshot 2`  
	 - This will output to `...\Ready Or Not\ReadyOrNot\Ready Or Not\Saved\Screenshots\`{: .filepath}
	 - The `2` means double your resolution so you can downscale the image with much better anti-aliasing.
	 
For in editor;
 1. Create a camera actor in your level.
 2. Ensure `Constrain Aspect Ratio` = `True` and `Aspect Ratio` is set to `1.777778` (16/9)
 3. In the top left of your 3D viewport, click the (usually named) `Perspective` drop menu and select your new camera.  
	 ![Perspective Button](/assets/modleveldata/viewport_views.png){: w="302" h="45" }
 4. Enable game view by pressing `G` and fullscreen (F11)
 5. Again in the top left of your 3D viewport, click the hamburger icon  ![Hamburger](/assets/modleveldata/viewport_hamburger.png){: w="23" h="24" }
	 - Click `High Resolution Screenshot...`
	 - Set `Screen Shot Multiplier` so it will create a 4k+ image based on your current resolution.
		 - 1080p would be 2.0+
		 - 1440P would be 1.5+
		 - 4k could use 1.2+ for better anti-aliasing.
 6. Pilot your camera into the desired location and click `Capture`
 7. Use the pop-up in the bottom right to open your project's screenshot folder or find it at `.\Saved\Screenshots\WindowsEditor\`{: .filepath}
 
### Process and Import
 
 1. In Photoshop or a free alternative, scale your image to 2048x2048 pixels. Save as a .png or .tga 24bit.
	 - File naming is optional but `T_UI_MissionSelect_YourLevelName` is a recommended format
 2. In UE5, in your level folder create a `/UI` folder
 3. Import your screenshot to this folder, via the content browser. ![Import](/assets/modleveldata/contentbrowser_import.png){: w="63" h="20" }
 4. Open your newly imported texture and set:
	 - `Texture Group` to `UI`
	 - `Mip Gen Settings` to `NoMipmaps`
 5. Save your texture.  
 
![Texture Settings](/assets/modleveldata/texture_settings.png){: w="443" h="246" }
_Example Map screenshot texture settings_

## Mission Selector Level

While you can create one from scratch, copying the ExampleMap's and using it as a template is recommended.

 1. Open a second content browser if one isn't open.
	- Navigate the first to your level asset directory.
	- Navigate the second to `/Content/Mods/Template/Levels/`{: .filepath}
 2. Copy the `RoN_ExampleMap_MissionSelect` level to your folder by dragging it and choosing `Copy Here` from the prompt.
 3. Rename the copied level to `YOURLEVELNAME_MissionSelect`
	* Naming is option, but this format is recommended.
    * Ensure the renamed level is saved, then, right-click your folder and run `Fix Up Redirects`
 4. Open the level.
 
### Screenshot Texture Setup

Mission Select levels are meant to be extremely light-weight so they load quickly. 
 - Most levels are going to consist of an image plane mesh, assigned an unlit material with a screenshot texture.
 - A camera is pointed at it with the actor tag `LosSuenosCamera` added to indicate to the game which camera to view.  
 
![Mission Select Level](/assets/modleveldata/mld_missionselectLevel.png){: w="1691" h="518" }
 
Since you have a copy of the example mission select map, you just need to swap the material to show your new screenshot texture.

 1. Open your second content browser if one isn't open.
	 - Navigate one to your levels `/UI` folder from before  
	 - Navigate the other to `/Content/Mods/Template/Levels/UI/` 
 2. Select both `M_MissionSelect_Template` and `MI_MissionSelect_ExampleMap`
 3. With both selected, drag both to your `/UI`{: .filepath} folder
 4. IMPORTANT: Select `Advanced Copy Here` then `OK` in the pop-up window.
	> Do not use the regular copy! Otherwise the Material Instance will have it's parent and reference still set to the original material in the template folder,  
	> which you DO NOT want in order to stop conflicts with other mappers.
	{: .prompt-warning }
 5. Optionally rename both the material and instance with `_YourLevelName` appended (instead of "ExampleMap" or "Template"), then on your `/UI`{: .filepath} folder run `Fix Up Redirects`
 6. Open your copy of `M_MissionSelect_Template`
 7. Find the `Texture Sample` node to the left and select it.
	 - Assign your new screenshot texture via the details panel on the left.
 8. In the top left of the window press `Apply` and save. Close the window.
 
	 ![Texture Node](/assets/modleveldata/mld_material_texturenode.png){: w="653" h="315" }
	 _Material texture node assignment_

 9. Open your `_MissionSelect` level if it's not open.
 10. Select the `Plane` static mesh actor that has the template's screenshot material assigned.
	 - From the details window, change the assigned material to your material instance.
 11. Adjust the level as needed.
	 - You can view the camera via the top-left menu in the viewport, just be careful not to move it.
		 ![Perspective Button](/assets/modleveldata/viewport_views.png){: w="151" h="23" }
	 - Remove the `TextRenderActor` in front of the plane static mesh actor since it will be in the way.
	 - You can customize the view with basic particles or animated materials for water etc.
	 - You may need to add lights such as a moveable spotlight if you add actors to the scene which you want to see.
 12. Save your Level
 
## MLD Level Picture, Mission Select Map and extra MLD

 1. Open your MLD
 2. Assign your new screen shot texture to `Level Picture`
	 - This is used in the top-left lobby HUD when a level has been chosen, as well as on the projector screen in the HQ lobby.
 3. Assign `Mission Select Map` to your `_MissionSelect` level.
 
![Example Map MLD texture assignments](/assets/modleveldata/mld_examplemap_images.png){: w="316" h="313" }
_Example Map MLD assigned screenshot texture and _missionSelect level_
 
Now that you have another level, by default, it will be selectable as a playable level in game, which you don't want. To fix this;
 
 1. Create a new `Mod Level Data` data asset for your `_MissionSelect` level using the same methods in [#basic-mld-setup](#basic-mld-setup).
	 - This MLD does not require any objectives to be set etc.
	 - Only the `Level Name` **MUST** be set
 2. In the new `_MissionSelect` MLD change `Show in Mission Select` to `false`
 3. Open your actual, playable Level
 4. In your `BP_ModLevelDataReferencer` actor, add an entry and assign your new MLD for the `_MissionSelect` level so that it is included in your cook.
 
 ![Example Map MLDs](/assets/modleveldata/mld_examplemap_mlds.png){: w="381" h="204" }
_Example Map MLD and the mission select level's MLD ("MLD_ExampleMap_MS")_
 
# Entry points

TBD

# Objectives

TBD

# Using Vanilla Levels for Reference

Ready or Not's vanilla levels now use a similar data asset class to fulfill the same purpose that the MLD does for modded levels.  
If there's something you want to know that the guide doesn't cover, you can often check out how it's done in vanilla levels.
However with UE5 you can no longer even open the read-only cooked game assets.  

Instead you can use the EUW_Tool_ObjectViewer widget located in `/Content/Mods/Tools/`  
With this you can drag in any cooked game asset that doesn't crash when loaded (and isn't a data TABLE), and see what properties have been configured in a GUI format.

 > Although it will let you edit values, they will not be saved/saveable and often crash your editor so don't do that ;)
 {: .prompt-danger }
 
# Briefing Audio

Because the briefing audios are hard-coded to FMOD events there's no direct way to customize this for your level.
There is the old `/Content/Mods/Template/Blueprints/Audio/BP_BriefingAudioSpawner` which uses the Mod Sound event and FMOD programmer sounds to hackily play audio somewhat unreliably.

Guide/Rework of that TBD