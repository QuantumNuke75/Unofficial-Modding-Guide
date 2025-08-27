---
title: Getting Started with Ready or Not Mapping in UE5
date: 2024-08-08 00:00:00 +0000
categories: [Map Modding]
tags: [maps, essential, introduction]
description: An in-depth guide on getting started with Ready or Not Mapping
author: Delta|https://www.nexusmods.com/readyornot/mods/3072/
pin: true
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

![Ready or Not Development Cycle](/assets/mapping-gettingstarted/DevCycleUE5.png){: w="1098" h="494" }

### Development Example
If you would like to see what it's like to make a map for Ready or Not, I recorded my entire development for [Hell Comes to the Hills](https://www.nexusmods.com/readyornot/mods/3072/){:target="_blank"}. 

[YouTube Playlist: Ready or Not: Custom Map Development by Delta](https://www.youtube.com/playlist?list=PLeMpdkJrX_CGU-kIZJz4nbZ8KMNNWhWz3){:target="_blank"}  

{%
  include embed/youtube.html
  id='zBHjZC462_4'
  autoplay=false
  loop=false
  muted=false
%}


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
3. **RoN_Template**
    * This is a barebones level that will cook and play in the game. You can use this as a template if you are making a new map, but we will make one from scratch in a little bit below to explain the requirements.
4. **RoN_WorldGen**
	* This is an advanced example map made showcasing what can be done with the [World Data Guide](/posts/mapping_worlddata)
5. **RoN_DifficultyExampleMap**
	* This is an intermediate example map made showcasing what can be done with [Custom Map Difficulties](/posts/mapping_CustomDifficulty)

## Your First Map
>If you have seen previous YouTube tutorials it may have said you need to set up the Render Settings, or modify the Packaging settings. With the latest version of the Template, you do not need to change or extract any settings. You should be good to go from the first time you launch.
{: .prompt-info }

### The Folder Structure
Before we continue, it is very important to understand the folder structure of an Unreal Project. 

Unreal uses this concept of a `Content` folder, this is where all the game content and maps for the game reside (located at: `...\ReadyOrNot\Content`).

When you install a `.PAK` file you are essentially adding or overriding assets in `Content`. Any change you make here will likely affect other mods that people use. This a more common occurance when a lot of us are using the same Marketplace or Quixel/Megascans assets. 

**More importantly**, it can also cause conflicts with the core Blueprints required for gameplay! 

To prevent us from stepping on each other's work and causing game crashing conflicts:

1. Create a directory for yourself within the `Mods` folder using your username and place **ALL** your assets (including 3rd Party/Marketplace/Quixel/Megascans) there. 
2. Drag the *Mods > Template > `Blueprints`* folder into your newly created folder from Step 1.
3. Within the Content Browser, right click on the `Mods` folder and select *"Fix Up Redirectors"*
4. Within your folder from Step 1, create a empty folder called *"ModLevelData"*
    * We will use this later on to put our Mission Select and Level Select data


The `Mods` folder should now look like the following:
```
Content  
    Mods
        ModLevelData
        Template 
        Tools
        YourUserName
            Blueprints
            ModLevelData
```

> You may want to copy the `Mods` folder back into your project from the Framework.7z for future reference. The reason we move the Blueprints folder into our own is because as development continues newer version of the Blueprints may come out that fix bugs or improve functionality. If we just overwrite the previous version within the Template directory, it **WILL** cause issues for other mappers.
{: .prompt-info }

> Since you will be visiting your folder frequently I would consider changing the the folder color and adding it your favourites within the Content Browser. You can do this by simply right-clicking the folder here. 
{: .prompt-tip }

### Bare Essentials for Gameplay

1. Before proceeding: **It is CRITICAL that you have read the previous section on Folder Structure**. Do not proceed until you have completed the steps above.
2. *Following the previous steps in Folder Structure*, go to your `...\Mod\YourUsername` directory in the Content Browser and create a new Level then open it
    * Whatever you name it will be what it shows up as in-game
        * But do not name it "House" - it is a restricted namespace and will not load in game
3. Once opened, on the toolbar click Blueprints button and click `Open Level Blueprint`
![Level Blueprint Location](/assets/mapping-gettingstarted/OpenLevelBlueprintLocation.png){: w="643" h="403" }
4. Under `Class Settings`, check the details panel and change the `Parent Class` to `ReadyOrNotLevelScript`
5. Click `Compile`, and you can save and exit the window
6. On the toolbar select *Window > Place Actors*
7. Within the new *Place Actors* window select the Geometry Tab ![Geometry Tab](/assets/mapping-gettingstarted/PlaceActorsGeometry.png) and chuck down a couple of boxes to make a floor and a couple of walls to act as a space to play in.
    * If everything is black, press `Alt+3` to switch to `Unlit Mode`
8. Back in the *Place Actors* window, search for, and place down the following:
    - [ ] ***1 Player Start Actor***
      * This is where your Player and Team Spawn
          
    - [ ] ***Nav Mesh Bounds Volume***
      * Required for your AI to function, whatever this covers will be where your AI can walk
          
    - [ ] ***Roster Scenario Spawner Actor***
      * This creates your gameplay objectives and spawns
          
9. In the Content Browser, navigate to `...\Content\YourUserName\Blueprints` and place down the following:
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
        * With it still selected, Go to *Cascaded Shadow Maps* and set the `Dynamic Shadow Distance StationaryLight` to *4000* and set the `Num Dynamic Shadow Cascades` to *1*.
            * These values will be what you will see in game
    - [ ] ***Create Sky Atmosphere***
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

![AISpawn Detail Example](/assets/mapping-gettingstarted/AISpawnExampleUE5.png){: w="492" h="1121" }

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
1. In the Place Actors window, search for `Door` and place down a `Door` actor.
	 > This may sometimes show as BP_Door_New
2. You can change which door you want by going to *Door > Type of Door* and selecting the desired door from the `Row Name` dropdown.

 > The basic Template includes the Static Meshes so you can preview the door but not the materials. To get them you will need to follow the steps in [Using Ready or Not Game Assets and Content](#using-ready-or-not-game-assets-and-content)
 {: .prompt-info }

 > To use double doors, add a second door actor and rotate it 180° into position.  
 > In both door actors set `Drive Sub Door` to the other actor and in **ONE** door actor, enable `Main Sub Door`.  
 > Some doors have a left/right variant so the hinge/handle models are correct. However some are unfinished/unused and have the wrong rotation, so should not be used.
 {: .prompt-tip }


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

 > Building times can vary, but the largest determining factor is usually Lighting. As map size increases and the quality of Lighting is changed, builds can take anywhere from 2mins all the way up to 6hrs and longer. At the moment the map should probably only take a couple of seconds. 
 {: .prompt-info }


## Cooking
Cooking is the process of turning the project into content that can be deployed on other machines. We also only want cook content that is only important for the map to keep file size small. We need to configure this first:

1. Go to `Edit > Project Settings` and on the side tab select `Project > Packaging`
2. Under `Packaging` Disable `Share material Shader Code`

    > We Disable it to stop us from sharing shadercode. If we cook a map with shared shadercode, it is very likely it will break other people's map and even cause their games to crash. 
    {: .prompt-danger }

    > If you have Cooked Content installed in your project this option allows you to see materials in the Editor if enabled. However If you have it disabled when you close the Editor, the materials will be black next time you open it. You can fix it by enabling it again and restarting the Editor.
    {: .prompt-warning }

2. Under `Packaging > List of maps to include in a packaged build` you should see an element that shows the directory for the *RoN_ExampleMap* and *RoN_Template*. 
    * If you do not see `List of maps to include in a packaged build` you may need to expand the `Advanced` category.
3. Delete these 2 entries for now.
4. Press the `+` and create an entry and enter your map's directory within the project folder.
5. Press the `+` again but this time, use your map's BuildData, it should be in the exact same location as your map.
6. You do not need to change any other settings and it should look something like this:
![Packaging Settings Example](/assets/mapping-gettingstarted/MapsToPackageUE5.png){: w="689" h="84" }
7. Make sure you Save All before proceeding
8. On the Toolbar click *Platforms > Windows > Cook Content*
![UE5 Cook Location](/assets/mapping-gettingstarted/UE5CookLocation.png){: w="709" h="500" }
    * This could take some time for your first cook as it compiles all the shaders. Just be patient.
9. Once cooking has completed re-Enable *Project Settings > Packaging* `Share Material Shader Code`

>You should hear it succeed, but a message will not remain on screen when it completes. If it failed the notification will stay on the screen. You will need to look at the Output log in the Editor to find out what the Errors are (you can ignore warnings - there will be a lot of them).
{: .prompt-info }

## Custom Cook ![Custom Cook](/assets/CookIcon.png){: w="24" h="24" }

With the Los Suenos Stories update to the Framework, a custom Cook button was added to the level editor toolbar.  
This will, by default, automatically;  
 1. Write a Game.ini to `/Saved/Config/WindowsEditor/`{: .filepath} which disables Share material Shader Code, regardless of your project setting.
 2. Start a cook via UnrealEditor-Cmd.exe
 3. Remove the Game.ini after it finishes
 4. Copy the `/Config/Difficulties/`{: .filepath} folder to your cooked files.  
 
 > If the editor is unfocused you won't hear the completion sound effects. However, by default the notification is set to not auto-fade.
 {: .prompt-warning }
 
 > To cancel the cook, find the Unreal command prompt that opened, and close it.
 {: .prompt-info }


## Packaging & Installing your Map
Packaging will turn our cooked content into a single compressed file that we can actually use to play in game and distribute to other people. 

 > There are a bunch of Unreal packers out in the wild, but only use the following method for maps.
 {: .prompt-danger }

1. Create a folder somewhere to act as your staging location for packing, name doesn't matter but I use `Paking`.
    * I wouldn't create it in your project folder however.  
	
	 > With the LSS update there is a folder shortcut button on the toolbar which you can configure.  ![Custom Cook](/assets/OpenStagedMods.png){: w="16" h="16" }{: .right }
	 {: .prompt-info }
	 
2. Within this folder create a new folder using the following naming convention: `pakchunk99-YOURMAPNAME`
    * the 99 after `pakchunk` indicates the load order of paks. We keep maps at 99.
    * Replace `YOURMAPNAME` with whatever your map's name is. This will not show up in game, but will help identify your map/mod to people downloading your mod.

>A lot of mods have _P appended to the end of their .paks. For maps we do not need it and should not use this namespace. Using _P in your package actually patches over files and we do not want to to this! There could be a bunch of Blueprints or shadercaches that are generated when we cook our map and it will conflict with other mods if you include them.
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
	 > With the LSS update there is a folder shortcut button on the toolbar for this.  ![Custom Cook](/assets/OpenCookedContent.png){: w="16" h="16" }{: .right }
	 {: .prompt-info }

6. Paste your `Content` folder into your `pakchunk99-YOURMAPNAME` folder
7. Drag your `pakchunk99-YOURMAPNAME` folder onto your .bat shortcut. A command window will pop up and tell you when it is complete. If successful you should have a new file in your staging directory named `pakchunk99-YOURMAPNAME.pak`
8. Copy your `pakchunk99-YOURMAPNAME.pak` to `C:\SteamLibrary\steamapps\common\Ready Or Not\ReadyOrNot\Content\Paks`
	 > With the LSS update there is a folder shortcut button on the toolbar which you can configure.  ![Custom Cook](/assets/OpenPaks.png){: w="16" h="16" }{: .right }
	 {: .prompt-info }
9. Your map should now be available in the game

This is an example of what a Staging folder can look like:
![Staging Folder Example](/assets/mapping-gettingstarted/StagingExample.png){: w="772" h="104" }

>You will be jumping between these folders a lot, I really recommend putting your Staging folder, Project Cooked folder Ready or Not Pak directory to your Quick Access bar.
{: .prompt-tip }

## Testing your Map
The easiest way to test your map is to simply load up the game and select it from the Mission Select screen. If all works well then it should take a couple of seconds to build WorldGen and plops you into the map.

### Common Issues with a Map not Loading

Make sure you did the following:
- [ ] Using the up-to-date version of the template [linked above in this guide](#the-template-project).
- [ ] You are using the packing method [described above in this guide](#packaging--installing-your-map).
- [ ] Only include the `Content` folder from `\RoNTemplate\Saved\Cooked\WindowsNoEditor\ReadyOrNot`
- [ ] Disabled `Share Material Shader Code`
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

 > You will at least around 100GB free for the next part, we will be extracting the game's cooked assets so they will show up in your map, and unfortunately require a lot of space.
 {: .prompt-warning }

Download FModel: [https://fmodel.app/](https://fmodel.app/){:target="_blank"}

Download Mappings file: [Mapping File](/posts/ue4ss_and_mappings/#mappings-download){:target="_blank"}

 > **BEFORE PROCEEDING:** Remove *ALL* mods from your game. FModel will load them and cause issues and materials may not load properly.
 {: .prompt-danger }

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
2. Navigate to where FModel exported the cooked assets and copy the `/Content/` folder (or drag if storage space is limited) to your Project's Content Folder.
     > This INCLUDES all the shadercaches.
	 {: .prompt-warning }
	 > Make sure you copy the extracted Content folder to your Project's root.  
	 > **DO NOT** copy into the Project's Content.  
	 > **DO NOT** end up with `.../ReadyOrNot/Content/Content/`{: .filepath} (<-- **BAD**)
	 {: .prompt-danger }
	
3. **DO NOT overwrite any files if prompted!** Just skip these files. If you overwrite them, you will need to start again from scratch with a new Project.

For the DLCs you will also need to copy their content folders if you wish to use more than their AI data tables the Framework includes. You will have these even if you don't own them.  

 - Home Invasion is included in `/Content/` already.
 1. `.../FmodelExports/ReadyOrNot/Plugins/GameFeatures/ReadyOrNotDLC2/Content` needs to be copied to the Project's `.../ReadyOrNot/Plugins/GameFeatures/ReadyOrNotDLC2/` folder. This is DarkWaters.
 2. `.../FmodelExports/ReadyOrNot/Plugins/GameFeatures/ReadyOrNotDLC3/Content` needs to be copied to the Project's `.../ReadyOrNot/Plugins/GameFeatures/ReadyOrNotDLC3/` folder. This is Los Suenos Stories.

All the game's assets should be available in the project now, including working Materials, Decals and Particle Effects!

### Optional: Importing FMOD Events

If you wish to hear the QSM or ambient sounds follow these steps:

 1. Navigate to `C:\SteamLibrary\steamapps\common\Ready Or Not\ReadyOrNot\Content\FMOD\` and copy the `Desktop` folder.
 2. Navigate to your projects `...\Content\FMOD\` folder and paste the `Desktop` folder here.


## Where to Next?
We have other guides that cover some more in-depth aspects of mapping that you can check out below:

### [Setting up Audio and Working with QSM](/posts/mapping_audio){:target="_blank"}
### [Setting up Music Events for Levels](/posts/mapping_music){:target="_blank"}
### Mission Select, Objectives, Entry Points; [Mod Level Data guide](/posts/mapping_ModLevelData)
### Map Optimization - COMING SOON


