---
title: Getting Started with Ready or Not Mapping in UE5
date: 2024-08-08 00:00:00 +0000
categories: [Map Modding]
tags: [maps, essential, introduction]
description: An in-depth guide on getting started with Ready or Not Mapping
author: Delta|https://www.nexusmods.com/readyornot/mods/3072/
pin: true
---

# Getting Started with Ready or Not Mapping in UE5 [POST DLC1 Home Invasion]

> If you already have a map made in UE4 for Ready or Not we have a [Migration Guide into UE5](/posts/mapping_ue5migration) for you.
{: .prompt-tip } 

## Introduction
Ready or Not is currently *Unofficially* supported by dedicated modders. Due to the hard work of them we are currently able to get around 80-90% of the experience that Official Maps have; there is expected to be a little bit of Jank when creating maps. 

This guide will step you through the basic set of requirements needed to build custom levels for Ready or Not and complete your first iteration by getting your map into the game.

>Ready or Not mapping **REQUIRES** that you download and use **Unreal Engine 5.3.2**. Do not download or use any other version.
{: .prompt-danger }

>If this is your first time creating a map, be aware that the level of experience to create something functioning is considered *Intemediate*. 
It is recommended that you spend some time watching and learning some beginner videos for Unreal Engine on youtube before you start asking too many newbie questions.
{: .prompt-info }

If you need help or have any questions, don't hesitate to join the [RoN Custom Maps Discord](https://discord.gg/NGAtrTmXBR){:target="_blank"}!

### The Level Design Cycle for RoN

We currently provide a template project that contains all the gameplay features/blueprints needed to make RoN maps here: [Installation](#installation).

For the Level Design process, you pretty much do it all within Unreal Engine, and can use whatever (reasonable) method you want to create your level. 

It is important to note that currently we cannot test gameplay within Unreal Engine and can only do it within the Game. To actually play the level you need to pack your level into a deployable `.PAK` file. More info here: [Cooking](#cooking) & [Packaging & Installing](#packaging--installing-your-map)

![Ready or Not Development Cycle](/assets/mapping-gettingstarted/DevCycleUE5.png)

### Development Example
If you would like to see what it's like to make a map for Ready or Not, I recorded my entire development for [Hell Comes to the Hills](https://www.nexusmods.com/readyornot/mods/3072/){:target="_blank"}. 

[YouTube Playlist: Ready or Not: Custom Map Development by Delta](https://www.youtube.com/playlist?list=PLeMpdkJrX_CGU-kIZJz4nbZ8KMNNWhWz3){:target="_blank"}


## Installation

### Unreal Engine 
1. Download and install the [Epic Launcher](https://store.epicgames.com/en-US/download){:target="_blank"}.
2. Open the Launcher, go `Unreal Engine` on the left side bar, then `Library` along the top toolbar
3. Under `Engine Versions` press the `+` icon and next to the Version Number, click the drop down and select `5.3.2` and Install

### The Template Project

1. Download the Template from Nexus and extract it to your preferred location: [Ready Or Not Community Mapping Framework](https://www.nexusmods.com/readyornot/mods/1384){:target="_blank"}
2. Open the extracted ReadyOrNot folder and run `ReadyOrNot.uproject`

If you open the Content Browser (Ctrl+Spacebar) and navigate to `Content > Mods > Template > Levels`, there are 3 levels here:
1. **RoN_ExampleMap**
    * This is as the name suggests an Example Map which shows how the different mechanics of the game need to be implemented: Including Spawning, Doors, AI, Lighting, QSM and Ambient Sounds. It's meant as a learning and reference level if you need to check how things should be implemented. 
2. **RoN_ExampleMap_MissionSelect**
    * A very basic level that is only used when you are selecting a level in the Station.
2. **RoN_Template**
    * This is a barebones level that will cook and play in the game. You can use this as a template if you are making a new map, but we will make one from scratch in a little bit below to explain the requirements.

## Your First Map
>If you have seen previous YouTube tutorials it may have said you need to set up the Render Settings, or modify the Packaging settings. With the latest version of the Template, you do not need to change or extract any settings. You should be good to go from the first time you launch.
{: .prompt-info }

### The Folder Structure
Before we continue, it is very important to understand the folder structure of an Unreal Project. 

Unreal uses this concept of a `Content` folder, this is where all the game content and maps for the game reside (located at: `...\ReadyOrNot\Content`).

When you install a `.PAK` file you are essentially adding or overriding assets in `Content`. Any change you make here will likely affect other mods that people use. This a more common occurance when a lot of us are using the same Marketplace or Quixel/Megascans assets. 

To prevent us from stepping on each other's work, It is highly suggested that you create a directory for yourself within the `Mods` folder using your username and place **ALL** your assets (including 3rd Party/Marketplace/Quixel/Megascans) there. The `Mods` folder should look like the following:
```
Content  
    Mods
        ModLevelData
        Template 
        Tools
        YourUsername
```
> You will see other folders in here such as `Template` & `Tools`. **DO NOT** edit the files in here. 
{: .prompt-danger }

> Since you will be visiting your folder frequently I would consider changing the the folder color and adding it your favourites within the Content Browser. You can do this by simply right-clicking the folder here. 
{: .prompt-tip }

### Bare Essentials for Gameplay
1. *Following the previous steps in Folder Structure*, go to your `...\Mod\YourUsername` directory in the Content Browser and create a new Level then open it
    * Whatever you name it will be what it shows up as in-game
        * But do not name it "House" - it is a restricted namespace and will not load in game
2. Once opened, on the toolbar click Blueprints button and click `Open Level Blueprint`
![Level Blueprint Location](/assets/mapping-gettingstarted/OpenLevelBlueprintLocation.png)
3. Under `Class Settings`, check the details panel and change the `Parent Class` to `ReadyOrNotLevelScript`
4. Click `Compile`, and you can save and exit the window
5. On the toolbar select *Window > Place Actors*
6. Within the new *Place Actors* window select the Geometry Tab ![Geometry Tab](/assets/mapping-gettingstarted/PlaceActorsGeometry.png) and chuck down a couple of boxes to make a floor and a couple of walls to act as a space to play in.
    * If everything is black, press `Alt+3` to switch to `Unlit Mode`
7. Back in the *Place Actors* window, search for, and place down the following:
    - [ ] ***1 Player Start Actor***
      * This is where your Player and Team Spawn
          
    - [ ] ***Nav Mesh Bounds Volume***
      * Required for your AI to function, whatever this covers will be where your AI can walk
          
    - [ ] ***World Data Generator Actor***
      * This will build the navigation and gameplay elements when you load your map
          
    - [ ] ***Roster Scenario Spawner Actor***
      * This creates your gameplay objectives and spawns
          
8. In the Content Browser, navigate to `...\Content\Template\Blueprints` and place down the following:
    - [ ] ***2 BP_AISpawn_Managed***
      * Spawn points for AI - we will come back to this in a little bit
      * Also move them up from the ground about 50uu - Sometimes AI will not spawn if flush with the ground
      * AI are technically not needed, but without it the map will automatically complete when you play it and you wont be able to test it.
    - [ ] ***BP_SpawnManager_V3***
      * Required to spawn AI
    - [ ] ***BP_CoverGen***
      * Required for the AI to actually be active and move around the map during combat

> After you place down these Blueprints in your map you can search it in the `Place Actors` tab.
{: .prompt-tip }   


## Additional Things 

### Lighting
Currently your level doesn't have any light, so we should set up the basic stuff so we can actually see when we playtest it. Add the following:
1. On the toolbar select *Window > Env. Lighting Mixer* and in the new window click on:
    - [ ] ***Create Sky Light***
        * In the *Outliner* select it and set the Mobility to `Static`
    - [ ] ***Create Atmosphereic Light*** (our Directional Light)
        * In the *Outliner* select the `DirectionalLight` it and set the Mobility to `Stationary`
    - [ ] ***Create Sky Atmosphere***
    - [ ] ***Create Sky Volumetric Cloud***
    - [ ] ***Create Height Fog***

2. In the *Place Actors* window search for and place down:
    - [ ] ***Lightmass Importance Volume*** and adjust it to cover the playable area
    - [ ] ***1 Sphere Reflection Probe*** that encompasses the map
        * Without reflections the models/guns in game can look flat and not properly lit.

>If you set your Directional Light to be the Atmosphere Sun Light (done by default if you did the above), you can use `Ctrl+L` to change the direction of your sun now
{: .prompt-tip }

### AI Spawns

The 2 `BP_AISpawns_Managed` blueprints that we placed down are not configured yet, so lets do that by adding a Civilian and Suspect:
1. Select an AISpawn and under *AISpawn > Spawn Array* press the `+` symbol
2. Expand the new array element and also expand `Spawned AI`
    * This is where you choose what AI to Spawn
3. To begin with change the `Data Table` to `AIDataTable_Gas` & the `Row Name` to `Civilian_Gas_Woman_01`
4. Select the other AISpawn and follow the same steps but change the `Row Name` to `Suspect_01_Shotgun`
5. Check for both of these AISpawns that the `Spawn with Tags` in the `Spawn AI` array element is set to *"group1"*
    * The `Spawn with Tags` allows us to use the `BP_SpawnManager_V3` to control what spawns with specific tags
    * It should be set to "group1" by default.
6. Additionally check that for each AISpawn that under *Actor > Tags* there is an entry of *"Managed"*
    * Without this the Spawn Manager cannot find the AISpawn and will not spawn them.
    * It should be set to "Managed" by default.

>You can select any Data Table and Row Name for your map and you are not restricted to 1 Data Table.
{: .prompt-info }

Your AISpawn details should look something similar to this:

![AISpawn Detail Example](/assets/mapping-gettingstarted/AISpawnExampleUE5.png)

### Spawn Manager

The ***BP_SpawnManager_V3*** is required to spawn AI. By default it is set up work with any AISpawn that uses *"group1"*. This can be found under *Default > AISpawn Configs* in the manager.

You are free to add and change the tags on the Spawns and Manager how you see fit for you level. There are a couple of notes:
* You can have AISpawns with different AIDataTable and/or Row Values spawn on the same tag without any issues. (it's how we set it up above).
    * eg: Notice that the 2 AISpawns have `Civilian_Gas_Woman_01` & `Suspect_01_Shotgun` but share the same tag of *"group1"*
    * You can use this to create a variety of scenarios for your map!
* If you want a set number of a specific AI tag group to spawn, set the `MinimumAmount` & `MaximumAmount` to be the same number.
* If you want to spawn a random range of enemies of a tag, set a min and max value but also *Enable* `RandomizeWithinRange`.
* For now we can just leave everything as default.

### Doors
Doors are pretty simple to place down and edit into your map. 
1. In the Content Browser, navigate to `...\Content\Template\Blueprints` and place down a `BP_Door_Spawner`.
2. You can change which door you want by going to *Default > Door Type* and selecting the desired door from the `Row Name` dropdown.

>The basic Template includes the Static Meshes so you can preview the door but not the materials. To get them you will need to follow the steps in [Using Ready or Not Game Assets and Content](#using-ready-or-not-game-assets-and-content)
{: .prompt-info }

>Currently double doors do not work, it's a bug and limitation we do not have the ability to address at the moment. They do work on the first time you load a map, but on subsequent loads they will not show as double doors anymore. 
{: .prompt-info }


## Building / Baking
> DO NOT SELECT **"BUILD ALL LEVELS"**! Doing so will lock the editor in Texture Streaming and you will need to force close the editor through Task Manager. You have been warned!
{: .prompt-danger }

If you've been following along so far, then you probably have not built your map. Building parts of your map fixes up changes in Geometry & Volumes, Lighting & Reflections and Pathing. You should do it whenever you want to update/preview changes in your map.

To build your map, on the Toolbar, drop down Build and select what is appropriate:
* ***Map Check***
    * Check for errors in your map - this will usually run if you do any build settings regardless but useful if you dont want to modify anything.
* ***Build Geometry***
    * This will rebuild your brushes and volumes after editing
    * Usually best to do this first before any other builds
* ***Build Pathing***
    * Will update the NavMesh of any changes, best to do it after building geometry.
* ***Build Lighting Only***
    * As the name suggests, will build lighting on your map. This is what you'll be building 90% of the time.
* ***Build Reflection Captures***
    * Self-explanatory, if you build lighting it will also usually build reflections, but if you want to save time and just update reflections use this.
* ***Build Landscapes***
    * Self-explanatory.
* ***Precompute Static Visibility***
    * NOTE: In UE5.3.2 Precomputed Visibility (PCV) is sorta broken - you cannot visualize cells in the Editor and you can never really get rid of the Error Message. 
    * You can disable the Error Message in *Project Settings > Engine Settings > Rendering > Culling* and disable `Warn about no precomputed visibiilty`.
    * You can STILL build PCV and the data will remain, but you will not be able to verify it. You will need to enable `Precompute Visibility` in World Settings to get it to build. 
    * PCV will usually build after lighting.

My usual build process currently is: Build Geometery > Pathing > Lighting. Once the builds complete, you should `File > Save All`

>Building times can vary, but the largest determining factor is usually Lighting. As map size increases and the quality of Lighting is changed, builds can take anywhere from 2mins all the way up to 6hrs and longer. At the moment the map should probably only take a couple of seconds. 
{: .prompt-info }


## Cooking
Cooking is the process of turning the project into content that can be deployed on other machines. We also only want cook content that is only important for the map to keep file size small. We need to configure this first:

1. Go to `Edit > Project Settings` and on the side tab select `Project > Packaging`
2. Under `Packaging > List of maps to include in a packaged build` you should see an element that shows the directory for the *RoN_ExampleMap* and *RoN_Template*. 
    * If you do not see `List of maps to include in a packaged build` you may need to expand the `Advanced` category.
3. Delete these 2 entries for now.
4. Press the `+` and create an entry and enter your map's directory within the project folder.
5. Press the `+` again but this time, use your map's BuildData, it should be in the exact same location as your map.
6. You do not need to change any other settings and it should look something like this:
![Packaging Settings Example](/assets/mapping-gettingstarted/MapsToPackageUE5.png)
7. Make sure you Save All before proceeding
8. On the Toolbar click *Platforms > Windows > Cook Content*
![UE5 Cook Location](/assets/mapping-gettingstarted/UE5CookLocation.png)
    * This could take some time for your first cook as it compiles all the shaders. Just be patient.

>You should hear it succeed, but a message will not remain on screen when it completes. If it failed the notification will stay on the screen. You will need to look at the Output log in the Editor to find out what the Errors are (you can ignore warnings - there will be a lot of them).
{: .prompt-warning }


## Packaging & Installing your Map
Packaging will turn our cooked content into a single compressed file that we can actually use to play in game and distribute to other people. 

>There are a bunch of Unreal packers out in the wild, but only use the following method for maps.
{: .prompt-danger }

1. Create a folder somewhere to act as your staging location for packing, name doesn't matter but I use `Paking`.
    * I wouldn't create it in your project folder however.
2. Within this folder create a new folder using the following naming convention: `pakchunk99-YOURMAPNAME`
    * the 99 after `pakchunk` indicates the load order of paks. We keep maps at 99.
    * Replace `YOURMAPNAME` with whatever your map's name is. This will not show up in game, but will help identify your map/mod to people downloading your mod.

>A lot of mods have _P appended to the end of their .paks. For maps we do not need it and should not use this namespace. Using _P in your package actually patches over files and we do not want to to this! There are a bunch of shadercaches that are generated when wee cook our map and it will conflict with other mods if you include them.
**AGAIN. DO NOT ADD _P TO YOUR PAK NAME.**
{: .prompt-danger }

3. Go to `C:\Program Files\Epic Games\UE_5.3\Engine\Binaries\Win64` and create a `.bat` file here with the following arguments:
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
4. Create a Shortcut to the .bat file you created and move it to your staging folder from step 1.
5. Navigate to your Template/Project folder and go to: `...\RoNTemplate\Saved\Cooked\Windows\ReadyOrNot` and copy **ONLY** the `Content` folder
6. Paste your `Content` folder into your `pakchunk99-YOURMAPNAME` folder
7. From this pasted `Content` folder, enter it and delete the files that start with *"ShaderArchive-Global"* but do not delete any others
    * If you include these files the game will immediately crash when you launch it.
    * If you delete the others then materials in your map may be broken
7. Drag your `pakchunk99-YOURMAPNAME` folder onto your .bat shortcut. A command window will pop up and tell you when it is complete. If successful you should have a new file in your staging directory named `pakchunk99-YOURMAPNAME.pak`
8. Copy your `pakchunk99-YOURMAPNAME.pak` to `C:\SteamLibrary\steamapps\common\Ready Or Not\ReadyOrNot\Content\Paks`
9. Your map should now be available in the game

This is an example of what a Staging folder can look like:
![Staging Folder Example](/assets/mapping-gettingstarted/StagingExample.png)

>You will be jumping between these folders a lot, I really recommend putting your Staging folder, Project Cooked folder Ready or Not Pak directory to your Quick Access bar.
{: .prompt-tip }

### Alternative Cooking & Packaging Method
There is another way to cook your map that does not produce shadercaches. But it requires some extra clicks and slower in the overall scheme of things. But if your Map is not loading correctly in game it is worth trying. 

1. Before you cook your map, open up *Project Settings > Packaging* and Disable `Share Material Shader Code` **BUT DO NOT RESTART THE EDITOR!**
    * If you restart the editor, materials from cooked RoN assets will be broken. 
2. Cook the map as usual.
3. After cooking completes, Re-Enable `Share Material Shader Code`.
4. Stage your package as usual, however you will not need to delete the *"ShaderArchive-Global"* files.


## Testing your Map
The easiest way to test your map is to simply load up the game and select it from the Mission Select screen. If all works well then it should take a couple of seconds to build WorldGen and plops you into the map.

If you installed the Console Unlocker mod, you can also load into it faster by hitting ~ and typing `open YOURMAPNAME` and pressing execute. 
* `YOURMAPNAME` should be what the .umap name is called within your project. NOT the package name. 
* For Hell Comes to the Hills the command for opening it is `open Hell_Comes_to_the_Hills`.

### Common Issues with a Map not Loading

Make sure you did the following:
- [ ] Using the up-to-date version of the template [linked above in this guide](#the-template-project).
- [ ] You are using the packing method [described above in this guide](#packaging--installing-your-map).
- [ ] Only include the `Content` folder from `\RoNTemplate\Saved\Cooked\WindowsNoEditor\ReadyOrNot`
- [ ] Delete the *"ShaderArchive-Global"* files
    * If you are still having issues try also deleting the files starting with *"ShaderAssetInfo-Global"*
    * Or try the [alternate method for cooking your map](#alternative-cooking--packaging-method).
- [ ] You have all the actors mentioned in [Bare Essentials for Gameplay](#bare-essentials-for-gameplay).

If your map is still not not launching, then you may want to reach out for help on the Mapping Discord linked above.


## Updating your Map after Playtesting
And Voilà! You've just gone through your first iteration of RoN Mapping! 

There are just some final important steps needed to know when you re-cook and package your map to test updates:

1. After you recook your map, it is recommended that you delete the `Content` folder within your staged `pakchunk99-YOURMAPNAME` folder instead of overwriting it. 
    * Overwriting your folders may leave residual files and settings that may mess with your playtest
2. **BEFORE** you launch the game. Navigate to `C:\Users\USERNAME\AppData\Local\ReadyOrNot\Saved\SaveGames` and delete the WorldGen.sav file that has the same map name as your map (e.g. Hell Comes to the Hills filename looks like `Hell_Comes_to_the_Hills_WorldGen_40173.sav`).
    * **This step is critical!** Each time the game launches your map for the first time, it generates World Data and stores it so the map launches faster the next time you play it. However the game does not know when your map has been changed. So you will likely be playing on a map with outdated build information resulting in quite a few bugs.
    * The WorldGen contains information such as how doors are positions and connected, room sizes and layouts, stacking points, navigation, hiding spots and cover and a probably a lot of other things we don't know about yet. So it is important to make sure you generate new World data with each iteration!

>Just like with the other folders, it is recommended you add the SaveGames directory to your quick access, as you will be visiting it quite a fair bit!
{: .prompt-tip }

## Using Ready or Not Game Assets and Content

### FModel Setup

>You will at least around 100GB free for the next part, we will be extracting the game's cooked assets so they will show up in your map, and unfortunately require a lot of space.
{: .prompt-warning }

Download FModel: [https://fmodel.app/](https://fmodel.app/){:target="_blank"}

Download Mappings file: [Mapping File](https://unofficial-modding-guide.com/posts/ue4ss_and_mappings/#mappings-download){:target="_blank"}

1. If first time using, click the arrows for `ADD UNDETECTED GAME` and select `C:\SteamLibrary\steamapps\common\Ready Or Not\ReadyOrNot` as your directory AND press the `+` button.
2. Select the UE Version to be `GAME_UE5_3` and press OK
3. Go to Settings and under *General > Advanced*, Enable `Local Mapping File` and set the `Mapping File Path` to the downloaded Mappings file. (This will allow you to view the cooked content in FModel)
    * OPTIONAL: In *Settings > Models > Mesh Format*, change it to `glTF 2.0 (binary)` so you can export static meshes
    * Take note of your Export Directory
4. On the Archives Tab, select all the .paks from the game and click Load.
5. On the Folders Tab, navigate to the `Content` folder and right-click and select `Export Folder's Packages Raw Data (.uasset)`. This will save all the cooked content from the game and might take some time.

Once complete move onto the next step

### Copy Cooked Content to your Project

1. Close the new UE5 Template before continuing.
2. Navigate to where FModel exported the cooked assets and copy the `Content` folder (or drag if storage space is limited) to your Project's Content Folder.
    * This INCLUDES the shadercaches.
3. **DO NOT overwrite any files if prompted!** Just skip these files. If you overwrite them, you will need to start again from scratch with a new Project.

All the game's assets should be available in the project now, including working Materials, Decals and Particle Effects!

### Optional: Importing FMOD Events

If you wish to hear the QSM or ambient sounds follow these steps:

1. Navigate to `C:\SteamLibrary\steamapps\common\Ready Or Not\ReadyOrNot\Content\FMOD` and copy the `Desktop` folder.
2. Navigate to your projects `...Content\FMOD` folder and paste the `Desktop` folder here.


## Where to Next?
We have other guides that cover some more in-depth aspects of mapping that you can check out below:

### [Setting up Audio and Working with QSM](posts/-mapping_audio){:target="_blank"}
### [Setting up Music Events for Levels](/posts/mapping_music){:target="_blank"}
### Mission Select (ModLevelData) - COMING SOON
### Map Optimization - COMING SOON


