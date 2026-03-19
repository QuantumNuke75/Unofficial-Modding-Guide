---
title: Setting up Auto World Data Generation
date: 2025-11-21 00:00:00 +0000
categories: [Map Modding]
tags: [maps, essential, world data, boiling point]
description: A Guide on how to prepare your Map for Auto-World Data Generation and Importing it into the Editor
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
</style>

# Introduction

With the release of Boiling Point, the Community Mapping Framework can now import and author the Auto-Gen World Data that is created each time a Custom Map is first played. This is a pretty substantial leap for us, we no longer have to manually set up the entire World Data and players not longer need to wait for it either!

Originally the Auto-Gen was not that reliable, but VOID have done some bugfixing so that the World Generation created by the game is working identical to their set-up.

> If you are already familiar with the World Data Actors, and just want to get into importing WorldGen, click here: [Recommended Workflow](#recommended-workflow)
{: .prompt-tip }

# World Data Overview

> **RareKiwi** has already created an extremely in-depth guide on how to create World Data here: [World Data Authoring Guide](/posts/mapping_worlddata){:target="_blank"}
>
> The guide is very comprehensive, but a little bit daunting so this will give you the cliff-notes summary on the important aspects to make this as digestable as possible.
{: .prompt-info }

## Tools

### World Gen Loader (EUW_Tool_WorldGenLoader)
* *Content > Mods > Tools > EUW_Tool_WorldGenLoader*
* Also found in the Framework toolbar dropdown for quick access

The main tool required to import and generate World Data from the game's *WorldGen.sav* files. It also contains some QoL features to help clean-up & fix some errors that can result from importing. 

### World Data Helper (EUW_Tool_WorldDataHelper_Framework)

* *Content > Mods > Tools > EUW_Tool_WorldDataHelper_Framework*
* Also found in the Framework toolbar dropdown for quick access

This is the core tool to edit and modify World Data, and critical if you want to create the World Data from scratch. We will likely not need to use it much, **but we will need it running in the background *(Right Click > Run Editor Utility Widget)*.**

It is mostly used in this guide to visually identify Rooms, Stack-Up Point & Clear Points.


## Actors 

### World Data Generator ![WorldDataGenerator](/assets/world-data/T_WorldAction.png) 

This is the core of the World Data. It contains an array of Rooms which contains a reference to their `Door` and `Threat Awareness Actors`, their unique names, location and other linked rooms.  

One will be automatically created after you import WorldGen.sav data.

> Placing one in your level will disable automatic world data generation in game due to `Has World Ever Been Generated` being automatically set to **TRUE**.
>
> You will need to delete this if you need to regenerate and reimport World Data from the game.
{: .prompt-warning }

### Door Actors ![Door](/assets/world-data/DoorCenterfed.png) 

Native versions of the old Door Blueprint. They work the same as the BP version, but have some important changes that are critical for successful World Gen. 

> Read here for information on updating doors: [Doors](#doors)
{: .prompt-info }

### Editor Only Room Proxy ![Room](/assets/world-data/RT_CORRIDOR.png) 

This is a Framework only class which is used to contain a single room's `Room Data` in a visual form to help debug the world data. They are usually generated in front of a Door and contain visuals to show assigned doors and linked rooms. 
 
### Threat Awareness Actors (TAA) ![Threats](/assets/world-data/WorldData_Threats.png) 

These are scattered throughout a level/room - we **won't** be editing these. They have 3 main functions:

1. When clearing a room, SWAT needs to clear each by getting line-of-sight to it's position.  
2. They are used by SWAT to determine where to stand in a room based on the `Threat Level`.  
3. The nearest Threat will have an array of `Swat Look At Points` so they have an appropriate angle to cover when not in combat.

TAAs are generated in a 20x20 grid from each **Door** actor, approximately spaced 250uu from each other, or closer if the NavMesh is tighter (like in corridors or angled areas). Essentially a 5000 x 5000uu square from the center of the door. 

![1](/assets/world-data/THREAT_LEVEL_LOW.png){: .left } ![2](/assets/world-data/THREAT_LEVEL_MEDIUM.png){: .left } **Threat Level Low and Medium** 
: Usually where there are no direct line of sights to doors or where the NavMesh is marked for *"No Suspects"*

![3](/assets/world-data/THREAT_LEVEL_HIGH.png){: .left } **Threat Level High** 
: 90% of the map will be these.

![4](/assets/world-data/THREAT_LEVEL_EXTREME.png){: .left } **Threat Level Extreme** 
: These are usually reserved for TAAs that are connected to Doors

![Stairs](/assets/world-data/THREAT_LEVEL_STAIRS.png){: .left } **Threat Level Stairs** 
: Just a special use-case when generation detects stairs. 

![PreferredExit](/assets/world-data/FallbackIcon.png){: .left } **Preferred Exit** 
: These are editor only icons to help debug/assign door `Exits`, they have no impact on gameplay

### Stack-Up Points ![StackUpPoints](/assets/world-data/STACKING_ALL.png)
Where the SWAT will stack up on a door when commanded to do so. These can be edited after import to provide more realistic stacking scenarios.
* Arrow Rotation **DOES NOT** affect the direction SWAT will look, and is a visual indicator to show what door they are assigned to.
* If doors do not have Stack-Up Points, then SWAT commands cannot be given on that side of the door.
  * This is a feature, not a bug. Usually only occurs on very tiny rooms.

### Clear Points ![ClearPoints](/assets/world-data/T_Clear_34plus.png)
The path SWAT will follow when ordered to clear a room. When a door is selected these will appear. The sprites will only show if the [World Data Helper](#world-data-helper-euw_tool_worlddatahelper_framework) tool is running.

Editing these also require the use of the **World Data Helper** to add/remove points and to clean them up to update *Look-At* traces.

### Cover Points ![CoverPoints](/assets/world-data/Cover_Combined_Small.png)
Where AI will use cover on the map. We are **not** editing these. 

Editing them can be extremely finnicky and out of scope of this guide, please refer here to learn more about it: [Adjusting Cover Points](#adjusting-cover-points)
# Recommended Workflow

Before we dive too deep, we should establish something important:

> The whole point of using Auto World Gen is ***to do as little as possible*** to get maximum results.
{: .prompt-danger }

We are not trying to edit every single actor, in fact it is recommended to not edit the majority of data. The only actors recommended to change are the more "tactical" themed mechanics such as Stack-Up Points and Room Clearing. 

This means we are **NOT** manually modifying Room set-up, Threat Awareness Actors placement and Cover placement. All these actors should remain unedited; solely generated by the state of your NavMesh and Door placement using the recommended steps below: [Preparing Your Map for Auto World Gen](#preparing-your-map-for-auto-world-gen).

If there are errors in your World Data simply adjust the NavMesh and Doors - rebuild, play and re-import the WorldGen.sav again.

### Custom Stack-up and Clear Point Workflow

If you edit these elements you need to alter your workflow slightly as not to reimport what the game auto-generates. The **World Gen Loader** has checkboxes for some buttons that you need to disable to specifically ignore importing and overriding these values so you can keep your existing changes.

> You can decide to create Stack-Up or Clear Points either before or after Auto-Gen, it is a matter of preference. Though it might be good to see how the game thinks the points should be created first - to save some time/work. 😉
{: .prompt-tip }


# Preparing Your Map for Auto World Gen

To our understanding, VOID do not author/edit any of their World Data, it is all procedural. Currently, the World Generation created by the game is working identical to their set-up.

To match their generation we need to prep the map like they do:

1. If you are not already using them, you need to update all Doors to use the native **Door** actors (not Blueprints).
2. Adjusting a Door's `Doorway` component correctly.
3. Cleaning/Removing the NavMesh of unplayable areas.

## Doors

> It is ***HIGHLY*** recommended naming your doors. World Gen doesn't create names for rooms, and due to how iterative it can be, it isn't wise to waste time naming rooms. The Doors are the best thing to help identify if World Gen gets set up correctly. 
{: .prompt-tip }

### Updating Doors

If you are updating your map from older versions, you **NEED** to switch over to the *native* versions of the Door; these are not Blueprints but official game actors.

You will need to drag in new Door actors from the *Place Actors* window (simply named *"Door"*). These need to be completely fresh actors. **DO NOT** Replace them using the editor.


> If updating your Blueprint doors: **DO NOT** use *Right-Click > Replace Selected Actors with* `Door` Actors.
> 
> If you simply replace them it introduces a pretty tedious bug with Doors. It does not clean up the BP_Door actor correctly and results in issues with World Gen and SWAT commands. In worst cases, will require you to completely redo any edits made to custom Clear Points you make.
{: .prompt-danger }

### The Doorway Component

For Rooms to be correctly identified and created during Auto-Gen, the Room's NavMesh needs to be isolated into its own "island". Doors are used to cut into the NavMesh to create these islands and help separate one room from another. 

![NavMeshIslands](/assets/mapping-autoworldgen/NavMeshIslands.jpg)
_How a room's NavMesh should look now; Notice that any location where a door would be, it divides the NavMesh. Each room has its own distinct NavMesh 'island'. This is done automatically by placing down a Door actor (you do not need to do any additional set-up)._

The component that controls this on the Door is the `Doorway` Component. 

The Doorway's `Box Component` represents the actual size of the door and what needs to cover the "door" area/space. 

> You should **NOT** scale Door actor or the Doorway component to cover the space! 
*Scaling the door will *not* actually scale the `Box Extent` of the Doorway component.  This will lead to World Gen Issues. This is especially important for the *"Doorway"* `Type of Door` where you usually need to extend the length of the door.
{: .prompt-warning }

To correctly adjust the Door's Doorway component:

1. Within the "Details" panel, click on the `Doorway (Doorway)` component of the actor.
2.  Within *Shape* adjust the `Box Extent` and *Transform* `Location` (do not mess with rotation or scale!) to fill out the size of the door.

![DoorwaySetup](/assets/mapping-autoworldgen/DoorwaySetup.jpg)
_The Doorway Box Extent Y value was increased to 130 and moved to the center of the doorway to cover the empty space completely. Also not the NavMesh is cut up where the Doorway is, helping creating those NavMesh islands needed to help identify Rooms._

> Although you definitely should not scale the Door actor drastically, scaling it very minutely will likely not cause massive issues. 
> 
> *Example: Scaling the X/Y/Z by 1.01-1.05 will likely not cause major issues (We have not encountered any), but just be mindful of what you are doing. Always playtest!*
{: .prompt-info }

### Double Doors

1. Place down 2 matching doors next to each other and rotate one 180° (it doesn't matter which one)
    * Some doors have dedicated Left and Right versions
    * If the door meshes are offset, you can move the whole Door actor to align them to be flush.
2. Select one Door to be "main" door and under *Door > Sub Door*,  **Enable** `Main Sub Door` & then use the selector to assign the other door to `Drive Sub Door`
3. Select the other door and assign the previous door to the `Drive Sub Door`. 
    * DO NOT enable the Main Sub Door for this door.

![DoubleDoorSetup](/assets/mapping-autoworldgen/DoubleDoorSetup.jpg)
_Double Door Setup_

## NavMesh

> UE5 NavMesh does not work well with Physically Based Lighting/Bright values and often looks black. You can fix this by editing the Engine Material `DebugMeshMaterial` to match the image below:
> 
> ![NavMeshBugFix](/assets/mapping-autoworldgen/NavMeshBugFix.png)
{: .prompt-tip }


### Cleaning the NavMesh

You should restrict the NavMesh to only the playable area. The larger the NavMesh, the longer it takes for World Gen to complete. If you have areas where the player cannot access, the World Gen will still create data points there. 

You also want to restrict situtations where the NavMesh creates little islands of un-navigatable areas. Common places for this are on top of furniture (like beds and tables), beneath the map or on top of roofs.

![NavMeshGenProblems](/assets/mapping-autoworldgen/NavMeshGenProblems.jpg)
_A bunch of scenarios showing the World Generation being created in areas that are technically non-playable areas. To note, the **Clear Points** in the first image also extend into the non-playable area._

There are 3 main methods for cleaning up your NavMesh:

1. Make your **Nav Mesh Bounds Volumes** only cover the playable area
2. Use **Nav Modifier Volumes** with the `Area Class` set to **"NavArea_Null"** to remove unwanted areas/islands
    * This is the best way of nulling out the NavMesh - straight forward and easy to place down.
3. Use **Blocking Volumes** to restrict the NavMesh by providing collision over the area
    * This method works most of the time, but it still allows the NavMesh to create little islands inside the volume if it is too large and on top of it.
    * You should also change the `Collision  Presets` to **"InvisibleWallDynamic"** so particle effects dont get stuck on the volumes.

![navMeshGenFixed](/assets/mapping-autoworldgen/NavMeshGenFixed.jpg)
_The previous issues above are fixed using a combination of Blocking and Modifier Volumes. The **Clear Points** are also looking better in this scenario. The total amount of World Data actors went from 1224 to 856, and the build World Gen time went from 13.4s to 4.2s after optimizing the NavMesh. You can imagine the implication of this on slower machines and larger maps._

### Designating *"No Suspect"* Zones

*"No Suspect"* zones turn the NavMesh red and prevent suspects from being able to path to the marked areas. Technically not required, but it may be useful to prevent AI from encroaching on Spawns/Safe places. 

1. Place down and shape a **Nav Modifier Volume** like usual
2. Change the `Area Class` to **"NavArea_NoSuspects"**
    > The drop down contains a lot of other area classes, but only *"No Suspects"* are used in Official maps. The rest of the modifiers either do not work or are remenants from very early development and are unusable.
    {: .prompt-info }

# Importing WorldGen.sav 

## How to Import

1. Make sure you delete any previous *WorldGen.sav* of your map. 
    * These are located at: `C:\Users\Username\AppData\Local\ReadyOrNot\Saved\SaveGames`

      > If you do not delete existing WorldGen.sav files, than World Data will not be generated again if it sees existing files, and you will use old data.
      {: .prompt-warning }

      > They will be named something along the lines of: *"HCttH_WorldGen_112610.sav"*. It will be named after your Level's **filename** not the pak, and the numbers at the end represent the game version it was generated on.
      {: .prompt-info }

2. Cook, Pak and Play your Map as usual. After your map fully loads and you ***Spawn In*** you can close the game and go back to the Editor.
    
    > While in the Bearcat as the timer sits at 0s, the game is running the world generation. You will only Spawn into the game when generation has completed - so you will need to wait until this happens. This can take a varying amount of time based on the size of your NavMesh.
    {: .prompt-warning }

3. Run the **World Data Helper** (if not already running)
    * Right-Click and Run `EUW_Tool_WorldDataHelper_Framework` located at: *Content > Mods > Tools > EUW_Tool_WorldDataHelper_Framework*
    * Alternatively, on the toolbar open the Framework dropdown and click `Open World Data Helper`

4. Run the **World Gen Loader**
    * Right-Click and Run `EUW_Tool_WorldGenLoader` located at: *Content > Mods > Tools > EUW_Tool_WorldGenLoader*
    * Alternatively, on the toolbar open the Framework dropdown and click `Open World Gen Loader`

5. The **World Gen Loader** tool should automatically find the *WorldGen.sav* file if it exists in the directory while your map is open.
    * If it does exists and doesn't show, press the most **top-left** button (*Swap Search Directoy*) once or twice to "Change Directory" to refresh the tool.
    ![SwapSearchDirectory](/assets/mapping-autoworldgen/SwapSearchDirectory.png){: .right }

6. ![LoadWorldDataButton](/assets/mapping-autoworldgen/LoadWorldDataButton.png){: .right } Click  `Load World Data Save from disk` and it should make the other buttons available.

      > Before continuing, It is highly recommended that you save your map, just in case the Editor freezes and needs restarting. 
      {: .prompt-tip }

7. ![CreateAllActorsButton](/assets/mapping-autoworldgen/CreateAllActorsButton.png){: .right } Click `Create All Actors`
    * The checkbox on the button determines whether you want to import `Stack-Up` Actors. If disabled, it will not import/override existing ones.

8. ![ApplyValuesToActorsButton](/assets/mapping-autoworldgen/ApplyValuesToActorsButton.png){: .right } Once complete, then click `Apply Values to Actors`
    * The checkbox on the button determines whether you want to assign `Stack-Up` & `Clear Point` actors to doors. If disabled, it will not override existing values.

    > The **World Gen Loader** also has buttons to manually add World Data elements one-by-one instead of all at once.
    {: .prompt-info }

9. Congratulations! Your map now has World Data! The next step is to go through and [check the data to see if there are any errors](#checking-the-data-and-fixing-common-issues).

## Cleaning and Reimporting

If you end up editing your map or need to regenerate the World Data, then you will need to delete the existing imported data and repak & play your map again. 

1. ![DeleteWorldDataButton](/assets/mapping-autoworldgen/DeleteWorldDataButton.png){: .right } Within the **World Gen Loader** tool, press `Delete World Data Actors`.
    * If you have edited `Stack-Up Points`, make sure you **disable** the checkmark on the button to keep these actors.
    > You do not need to remove the Stack-Up and Clear Point Arrays for Doors - the tool will clean this up for you when you import new World Gen - unless the previously mentioned flag is enabled.
    {: .prompt-info }
    
    > The `World Data Generator` actor should be deleted when you press this button as well. If your map doesn't create new WorldGen.sav files make sure that it is actually removed from the map.
    {: .prompt-info }
2. Delete the previous *WorldGen.sav* of your map. 
    * ![DeleteWorldSav](/assets/mapping-autoworldgen/DeleteWorldSav.png){: .right } You can delete this quickly by using the **World Gen Loader** tool and clicking the red 
    `Delete` button next to the .sav
    * Or just delete it through the Explorer. 
3. Recook, pak and play your map again
4. Follow the previous to reimport your newly generated *WorldGen.sav* and  reassess the changes.
    * If you have edited `Stack-Up` or `Clear Points`, than make sure you have **disabled** the checkmarks next on the *Create All Actors* & *Apply Values to Actors* buttons make sure you do not override your changes!

## Finalizing

Once you are satisfied with how your World Data looks, we need to make sure the level no longer generates WorldGen.sav files.

1. In the *Place Actors* window, drag a ![WDA](/assets/world-data/T_WorldAction.png) `World Data Generator` into your scene. 
2. It will automatically populate and set the `Has World Ever Been Generated` to **TRUE**.
3. Save your map and you're done!

> If you do not include a `World Data Generator`, when someone plays your map they will generate their own WorldGen.sav and it will override your imported World Data.
{: .prompt-warning }

# Checking the Data and Fixing Common Issues

> Most of these issues will require you to regeneration the WorldGen.sav after fixing them in the Editor. You can manually fix it up without regenerating them - but you are likely to miss something and it is cleaner/faster to just let the game redo it. 
{: .prompt-warning }

You should check the following in order of importance. Once one is solved, move to the next:

1.  Do the newly created rooms actually make sense?
    * Check to see if they are connected and the doors are linked correctly.
2. Do all areas on the NavMesh where the SWAT need to clear contain `Threat Awareness Actors`?
3. Are there any instances of TAAs or Cover Points outside the playable area?
4. Check **every single** door
    * Does each door contain `Stack-Up Points`? 
    * Do the `Clear Points` cover the entire room? [Do they clip through Geometry?](#issue-clear-points-clip-through-the-geometry)
5. Check Double Doors
    * [Most likely, one of the Sub Doors will have their Stack-Up and Clear Points inverted and need fixing.](#issue-one-of-the-sub-doors-of-double-doors-will-have-their-stack-up-points-and-clear-points-reversedwrong) 

## ISSUE: Rooms & Doors are generating incorrectly or not making sense.

The most likely candidate is that the door's `Doorway` components are not set up correctly or the doors do not isolate & separate the NavMesh into clear Room islands.

### SOLUTION: Double check Doorway components on the affected areas

* If you haven't already, make sure you have named all your Doors - this will greatly help you to mentally parse the World Data.
* Make sure the **World Data Helper** is running - this helps identify which doors and rooms are linked by displaying arrows to them.
* Make sure the doors are not overly scaled, the `Doorway` component is scaled to (1,1,1) and that you are only adjusting the Doorway's `Box Extent`.
* Check to make sure the Door actually carves into the NavMesh and separates the map into distinct NavMesh Islands/Rooms.


## ISSUE: Treat Awareness Actors are not generating in areas SWAT need to clear.

* The entire NavMesh does not need to be completely covered in TAAs, only bits relevant to SWAT clearing.
* **HOWEVER:** If TAAs are missing from an area SWAT needs to clear, this is often caused by ground/playable space being more than 50uu from the location of the door. 
    * There is a rule in the generation to avoid creating TAA when the ground gets too low beneath a door (think balcony overhangs or blocking volumes under the map).

### SOLUTION: Add additional Door Actors at the lower area to help generate TAAs

* This allows the generation to create TAA at the Z-level of the new doors. 
* Change these Doors to *Doorways* and **Disable** `Can Issue Orders on Front Side` & `Can Issue Orders on Back Side`
  * This will not generate a new Room where the new doors are added, and will be simply be part of the existing room.
  * This is important for larger rooms/exteriors that may need to clear the entire area instead of segmenting it into illogical rooms.

![MissingTAAFix](/assets/mapping-autoworldgen/MissingTAAFix.jpg)
_TAAs are missing on the lower portion of the yard, it was over 50uu below the closet door and World Gen considered it an overhang despite stairs being present. The solution was to introduce doors to the bottom of the stairs which help generate TAAs correctly._

  > **NOTE:** A lack of TAAs is not a game breaking bug, but they should definitely be present in any location suspects can roam and SWAT can clear. 
  > 
  > *Example: If there are missing TAAs at spawn or the perimeter of the map, where suspects cannot path to, this is not a massive deal and can probably be safely ignored (Official VOID maps also are set up like this)*.
  {: .prompt-info }

## ISSUE: No Stack-Up Points Generated on one side of the Door

* This is likely caused by the room on that side of the door being too small for any points to be generated.
* ***This is not a bug and is intentional.***
    * If the room is so small that points cannot be generated, in real life it would be unlikely that you would attempt to stack up in a tiny room. It would be an in-n-out sort of situation. 

### SOLUTION: Manually Add Stack-Up Points

* If it is absolutely critical that you need points than you will need to manually add them.
  * Details here: [Adjusting Stack-Up Points](#adjusting-stack-up-points)

## ISSUE: Clear Points clip through the Geometry.

* This is actually not an issue, SWAT will still be able to clear the room. This usually happens with rooms that have concave and complex NavMeshes.
    * If the visual line connecting **Clear Points** goes through Rooms, it is fine as long as the points are all in the original same Room.
    * If a **Clear Point** node touches another Room, ***this is a problem.***

![ClearPointClippingIssues](/assets/mapping-autoworldgen/ClearPointClippingIssues.jpg)
_Some examples of the Clear Points clipping through the map/geometry. These are all in rooms that have complex concave layouts with the NavMesh but all points are in the same room. Despite visuals, SWAT are still able to successfully clear these rooms and do not have any gameplay issues._

### SOLUTION 1: Test the map and confirm that it is working

* Although the clearing path may look a little janky in the Editor, it might actually be "good enough" in game. 
* It is best to actually just playtest your map. You can remove all AI apart from 1 so you can take your time and test each door from either side.
    * If there are issues move onto the next solution.

### SOLUTION 2: Edit the Clear Points on how you think it should work.

* Simply move the Clear Points to make sense. A full guide is discussed below: [Adjusting Clear Points](#adjusting-clear-points)

### SOLUTION 3: Double check your Door/Doorway set-up

* If Stack-Up points are actually going into other rooms, it is likely the Rooms/Doors were not generated correctly. You will need to double check to see if they are: [ISSUE: Rooms & Doors are generating incorrectly or not making sense.](#issue-rooms--doors-are-generating-incorrectly-or-not-making-sense)

## ISSUE: One of the Sub-Doors of Double Doors will have their Stack-Up Points and Clear Points reversed/wrong.

This is currently an issue with importing the World Data. Usually one door will have its data reversed (eg: the Back Stack-Up/Clear points will be incorrectly imported as the Front, and vice-versa), but luckily we have a 1 click solution.

### SOLUTION: Check every Double Door, and flip the values with the World Gen Loader tool

1. Find and select the Sub Door with the inverted/reversed Stack-Up and Clear Points.
2. ![](/assets/mapping-autoworldgen/FlipSelectedSubDoor.png){: .right } With the door selected, press `Flip Selected Sub Doors` button on the **World Gen Loader** tool

## ISSUE: Cover Points/Threat Awareness Actors are generating outside the playable space

* This is likely caused by rogue NavMesh islands around the map that were not removed.

### SOLUTION: Clean up the NavMesh
* Simply remove any NavMesh islands that you see outside of the playable space or where Players/SWAT cannot walk on with **Navmesh Modifier Volumes** set to *NavArea_Null*
  * As discussed above: [Cleaning the NavMesh](#cleaning-the-navmesh)

  > You should avoid deleting actors while using the Auto-Gen because the more you edit it, the more you have to maintain it with each iteration/update of the map. Having a 1 or 2 of instances of World Data in undesirable locations is far from game breaking and not worth the effort stressing over it. When in doubt, play test it.
  {: .prompt-warning }
  
# Editing World Data

Each of these Actors have a dedicated and comprehensive guide in the [World Data Authoring Guide](/posts/mapping_worlddata){:target="_blank"}, but here are some general notes when it comes to editing so you know what you are getting yourself into. 

## Adjusting Stack-Up Points

You can move Stack-Up Points virtually anywhere you want but there are a couple of things to note:
1. All points should be contained within a single Room and on the NavMesh
    * Do not have them overflow into other Rooms
2. You do not need to have 4 points on both Left/Right sides of a door
   * A lot of the time Auto Gen will generate only 1 or 2 if there is not enough space.
      * This just means that if asked to stack on that side, the remaining SWAT that cannot reach a spot will move to the opposite side.
    * You ARE allowed to have stack up points on exclusively Left or Right sides of the door
      * If there are not points on the opposing side, the command will just be disabled.
3. If no points exist on one side of the door, you will not be able to command SWAT from that side.
    * *Example: If you have no points on the Back side of the door, you will not be able to command SWAT from that side.*
4. If deleting points, make sure there are no empty entries in the Door's `Stack Up` Arrays
    * If there are empty array values, it may cause a CTD. These should be deleted instead of remaining empty.
5. Make sure the points are on the correct side of the Door
    * *Example: Back Stack-Up Points are on the Front side of the Door*
    * If you do not, you will immediately CTD when you look at the Door.

**Further Reading:** [World Data Authoring Guide - Stack-Up Actors](/posts/mapping_worlddata#stack-up-actors){:target="_blank"}

## Adjusting Clear Points

You can freely move Clear Points around a room (just make sure keep them to one room only). However, adding/removing points should be done with the **World Data Helper** tool.

After any modifications to Clear Points, it is required that you to press the `Clear Point Trace LOS` and `Clear Point Direction by Angle` buttons on the **World Data Helper**.
![CPTrace](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Door_ClearPointLOSTrace.png){: w="222" h="38" } ![CPDirection](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Door_ClearPointDirectionByAngle.png){: w="222" h="38" }

**Further Reading:** [World Data Authoring Guide - Clear Points](/posts/mapping_worlddata#clear-points){:target="_blank"}

## Adjusting Threat Awareness Actors

For the Auto-Gen method it is highly recommended to avoid moving or adding/deleting TAAs entirely.

**Further Reading:** [World Data Authoring Guide - Threats](/posts/mapping_worlddata/#3-threats){:target="_blank"}

### Look-At Points

The most likely reason to adjust TAA is to add additional Look-At points. You should leave these as what the game thinks they are, but there may be situations that need manual adjustment.

  * *Example: You have large open windows that you may want the SWAT to pay attention to, you can add an `Editor Only Look-At Proxy`* and assign it to the relevant 

**Further Reading:** [World Data Authoring Guide - Look-At Points](/posts/mapping_worlddata/#swat-look-at-points){:target="_blank"}

## Adjusting Cover Points

Much like editing TAAs, it is advised against modifying them. 

There may be instances where you want to create some Cover for unique scenarios, in this case it is best to follow the original guide below.

**Further Reading:**  [World Data Authoring Guide: Cover Points](/posts/mapping_worlddata#cover-points){:target="_blank"}


  

