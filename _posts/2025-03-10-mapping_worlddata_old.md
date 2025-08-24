---
title: World Data Authoring Guide Old
date: 2025-03-10 00:00:00 +0000
categories: [Map Modding]
tags: [maps, world data]
description: An guide on how to author your own world data with your level.
author: RareKiwi
pin: false
hidden: true
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

 > This is for the Dark Waters version of the Framework or the door spawner and blueprints in the Deprecated.zip of the LSS framework.  
 > If you are making a new level, do not follow this guide and instead use the guide for the base Door class.
 {: .prompt-danger }

# Temporary Download
All the needed files will be included in a future Framework version, but for now you can download this ["Patch.zip"](https://drive.google.com/uc?export=download&id=11ivhVPC6Tn8lsWnshwBHu5BcBq0GDdmM) which you can extract into a DarkWaters version of the framework, overwriting when prompted.

# Overview
World data is the info needed by AI to know about rooms. It is intertwined with doors to let SWAT know how to stack up, clear rooms, know where to look as-well-as by the suspects and civilians for fleeing and retreating.
![An example of world data for 3 rooms](/assets/world-data/WorldData_All.jpg){: w="1920" h="1080" }
_An example of world data for 3 rooms_  
This is a brief overview of the contents of `/Content/Mods/Template/Blueprints/WorldData/`which you will be using to author your level's World Data.  
>As these blueprints have interlinked references, they should be used in place, or, as assets in the above `/Blueprints` folder are also referenced, you should `Move` or `Advanced Copy` the entire `/Content/Mods/Template/Blueprints/` folder if you wish to make a unique copy for your level.
{: .prompt-warning }

## Overview: World Data Actor ![](/assets/world-data/T_WorldAction.png) 
The core of the world data in your level is contained in a single actor in your level based on the "WorldDataGenerator" Ready Or Not class.  

This `World Data` actor contains an array of `Room Data` which contains a reference to their `Doors` and `Threat Awareness Actors`, along with a unique name, location and other linked rooms.  

To make this work with the Framework's door spawners you will use a child class called the **`BP_WorldDataGen_ModdedRoomData`** along with visual helper actors called `BP_RoomProxy` which will populate the `Room Data` at run-time.  

>Placing one in your level will disable automatic world data generation in game due to "Has World Ever Been Generated" being automatically set to True.
{: .prompt-info }
 
## Overview: Room Proxy ![](/assets/world-data/RT_CORRIDOR.png) 

**BP_RoomProxy**

This is a Framework only blueprint which is used to contain a single room's `Room Data` in a visual form, so that you're less likely to make mistakes when setting things up.  

It has selection based visuals for assigned doors and linked rooms, as well as an automatic name check so you can't create conflicts.  

The rooms' "Threats" arrays will also be auto-populated based on the name.  
 
## Overview: Threat Awareness Actors ![](/assets/world-data/WorldData_Threats.png) 

These are scattered throughout a room, usually at a 250x250 grid interval, but tighter in narrow nav areas.  

They have 3 main functions.
1. When `clearing` a room, SWAT needs to clear each by getting line-of-sight to it's position.  
2. They are used by SWAT to determine where to stand in a room based on the `Threat Level`.  
3. The nearest Threat will have an array of `Swat Look At Points` so they have an appropriate angle to cover when not in combat.

You will use the child class **BP_ThreatAwarenessActor** which has loads of helpful construction script logic and visuals. Notably, the essential `Pathable Threat Awareness Actors` array will be auto-populated based on the assigned "Owning Room" and "Pathable Group ID"

## Overview: Look At Proxy ![](/assets/world-data/T_Swat_look_at_proxy.png) ![](/assets/world-data/T_Swat_look_at_proxy_noauto.png) 

**BP_LookAtProxy**  
This is a Framework only helper blueprint which is used to auto-populate and/or auto-trace additional "Swat Look at Points" when using the `World Data Helper` tool

# Setting Up World Data
This guide will cover setting up a simple map with 3 rooms, but can be extrapolated to any sized map.
Most blueprints which I say "drag" or "place" into the level will be found at `/Content/Mods/Template/Blueprints/WorldData/`  
  
Keep in mind, in vanilla RoN maps, world data is mostly automatically generated, so manually setting this up isn't an exact science concerning measurements/spacing.

## Tool
This guide makes heavy use of the Editor Utility Widget called `BPW_WorldDataHelper`.  
It's also used to display extra actor visuals when they are selected. If I refer to "the Tool" in the guide, I'm referencing this widget.  
To run it; find it in `/Content/Mods/Template/Blueprints/WorldData/` and press `Right-Click | Run Editor Utility Widget`

## 1. World Data Generator
1. Place a single `BP_WorldDataGen_ModdedRoomData` anywhere in your level.
2. Make sure `Has World Ever Been Generated` is **True**. This will skip the game's auto-generation at run-time.

>Make sure there are no other `World Data Generator` placed in your level
{: .prompt-warning }

>After placing a World Data Generator with `Has World Ever Been Generated` = `True`, your map will no longer have any cover point generation.  
To remedy this you should place a `BP_CoverGen_Saver` and RoN `Cover Gen Override Volumes` in your level.
{: .prompt-danger }

## 2. Rooms
* I'd suggest just setting up two rooms to begin with, even if you have placed all your doors already. You can expand later.  
* A room should always have it's nav-mesh separated by a door or doorway  
* Outdoor areas should also be rooms. Large spaces should be split at thresholds to limit how much SWAT needs to clear, but it's not required.  
![World Data Rooms](/assets/world-data/WorldData_Rooms.jpg){: w="1920" h="1080" }  
	
1. Place two BP_RoomProxy on either side of a threshold where there is/will be a door or doorway. 
    * The "Location Offset" visual, should be at the height of the nav mesh.
	* The `Room | Location` will be auto-calculated from this offset location.
	* Room XY position isn't too critical, just try to make it centred and visible for yourself.
	![RoomHeight](/assets/world-data/WorldData_RoomHeight.png){: w="1154" h="729" }  
2. Each room needs a unique `Room | Name`. The construction script will give a new one if a conflict is found in the level.
3. `Room | Connecting Rooms` needs to be populated with each room directly connected with a door in the current room.  
    * To avoid mistakes, you should use the `Quick Add Connecting Rooms` picker to do this, as it will also populate the other room's list with the currently selected room.  
    * If the Tool is running, you should see a large arrow pointing at connected rooms when a room is selected.  
    ![](/assets/world-data/WorldData_QuickAddRoom.png){: w="222" h="38" }  
    ![](/assets/world-data/WorldData_LinkedRooms.jpg){: w="1920" h="1080" }  
4. `Room | RootDoorSpawner` needs to be assigned. 
    * This can be shared between other rooms.
	* See [Doors Placement](#placement) briefly if you don't have doors yet.
5. `Room | AdditionalRootDoorSpawners` All other doors for the room should be assigned.
	* This needs the RootDoorSpawner assigned too. Construction script will try to add it.  

![Root Door and Additional Root Door](/assets/world-data/WorldData_DoorGIF.webp){: w="1920" h="1080" }
_Root Door and Additional Root Doors_

> If you are duplicating rooms and changed the `RootDoorSpawner`, be sure to remove it from `AdditionalRootDoorSpawners` if needed.  
{: .prompt-warning }
* `Room | Threats` needs to be populated, but we will come back to this [later](#5-rooms-final)  

![Room Details Example](/assets/world-data/WorldData_Room_DetailsExample.png){: w="555" h="466" }
*Example Room Details View*  


## 3. Threats
For each room;
1. Place a `BP_ThreatAwarenessActor` in the room. It should have nav mesh near it, placed just above nav-mesh height.
2. Set the `Owning Room`  
	* This can be set with the `Quick Add Room` picker to avoid typos.
	* Each room name will generate a randomly coloured cone that should match the other's in the room.
3. Check `Is Outside` if applicable.
4. Keep duplicating your threats to cover the entire nav-mesh of your room. See placement;
    * Auto generation spaces them at 150-250u with closer points when nav-mesh edges are closer.
![Meth Outside Threats](/assets/world-data/worlddata_mth_outside.jpg){: w="1615" h="999" }
_Meth Outside Threats_
	* Threats are points that the SWAT has to visually check in order to clear a room. If SWAT can see all points from their clear path, they will stop following the path and resume their other activities. Keep that in mind for corners, you may want to offset a threat closer to an inside wall or behind an obstruction of a corner so that SWAT has to check more of an angle in that location.
	* Threats are also used to determine where the SWAT should stand to minimise their perceived threat.
	    * ![](/assets/world-data/THREAT_LEVEL_MEDIUM.png){: .right } ![](/assets/world-data/THREAT_LEVEL_HIGH.png){: .right } Most maps have a single default threat level with one safer threat level to mark preferred safe standing locations in a room.
	* ![](/assets/world-data/THREAT_LEVEL_EXTREME.png){: .right } Doors always have extra `TL Extreme` threats placed in front/back of them. They are almost always off place from the main grid spacing, about 80 units away from each side.  
![Meth Door Threat Placement](/assets/world-data/worlddata_mth_doorthreatspacing.jpg){: w="1965" h="847" }
_Meth Door Threat Placement_
	* Stair threats use the `TL Stairs` threat level and should be; ![](/assets/world-data/THREAT_LEVEL_STAIRS.png){: .right }
	    * Placed on one side of the nav-mesh boundary (or both if wide enough)
		* Elevated much higher, usually above any ballistrades or rails so that look-at-traces have clearer line-of-sights to doors and proxies for tracing.
		* Placed much tighter together, about 60 units. This is probably to give more accurate SWAT look-at-points.
![Meth stair threats](/assets/world-data/worlddata_mth_stairs.jpg){: w="1448" h="1132" }
_Meth Stair Threats_
5. ![](/assets/world-data/FallbackIcon.png){: .right } You can mark a single threat per room as `Preferred Exit` for use in the later sync step.
    * Exits are supposed to be used by suspects and civs in some capacity when fleeing or retreating.
    * I don't have much more info beyond that, most RON maps seem pretty random where this is placed in each room, but I'd imagine somewhere with cover or a corner would be preferred.
    * If one isn't manually assigned for a room, it will be randomly chosen for each room later.  

![Example Threats for 3 rooms](/assets/world-data/WorldData_Threats.jpg){: w="1920" h="1080" }
_Example Threats for 3 rooms_
* `Pathable Threat Awareness Actors` will need to be populated with all the other room's threats.  
This is done by the BP's construction script so long as the `Owning Room` matches, the `Pathable Group ID` matches and `Setup Pathable Automatically` is enabled.  
However a construction script is only ran when the placed actor is modified, so in a later step we will use the Tool's `Sync Threat Awareness` button to ensure all the threats are linked. 
    * If the Tool is running, you should see arrows pointed at nearby pathable threats when a threat is selected. Just keep in mind, for editor responsiveness, this wont show EVERY linked threat if there's many in the same room or they are too far.  

> ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Threats_Sync.png){: .right }{: w="222" h="38" } This button can be pressed whenever, if you would like to see its effects as you set things up.  
You should see your Room Proxies' `Room | Threats` arrays also populate after pressing.
{: .prompt-info }
> ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Threats_SelectByPathable.png){: .right }{: w="222" h="38" } You can use the `Select by Pathable` Tool button when you have a threat selected, to add all the other room's threats to your selected actors.  
{: .prompt-tip }

### SWAT Look At Points
![](/assets/world-data/WorldData_Proxy_Gif.gif){: w="1920" h="1080" }
* Each Threat can have an array of `Swat Look at Points` which is usually populated with world-space locations of visible doors.  
Instead of directly editing that, the BP_ThreatAwarenessActor class has an array called `Swat Look at Point Proxy` which will populate that other array at run time. Locations in this array are in local-space, so you can use the 3D gizmo to edit/visulize them.  
* The proxy structure used can also optionally link to a Door Spawner or BP_LookAtProxy which the construction uses to keep the locations relative.  

1. To populate the `Swat Look at Point Proxy`, you should use the Tool's `Do Look At Traces` **with the Threats selected** that you want to edit.  
Without needing to do any additional setup, this will trace to nearby door spawners and add them to the `Swat Look at Point Proxy` array if there is a clear line-of-sight.
    * If you want a door to be ignored for tracing (for a doorway for example), in the door spawner's details you can enable the `Ignore for Look At` variable.

![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Threats_DoTraces.png){: w="222" h="38" }  

> ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_ClearDebugLines.png){: .right }{: w="222" h="38" } If the trace line previews don't fade, you can press the `Clear Debug Lines` button at the top of the Tool.
{: .prompt-tip }
* You can also manually add extra locations to the `Swat Look at Point Proxy` for each Threat that the `Do Look At Traces` will ignore when running. But to help with automating that instead, you can use the Framework's BP_LookAtProxy actors.

### BP_LookAtProxy

* Place these at extra locations you'd like SWAT to look at.  
* You can add Threats to the `Forced Linked Threat Awareness` array which will add this proxies' location to them when `Do Look At Traces` is pressed.  
* Selecting a proxy after `Do Look At Traces` is run will show where it's used (unless it was forced, then it's always shown)  

>The selection-only debug previews only work/update when the Tool is open.
{: .prompt-info }

![Selected Proxy with Forced Threats](/assets/world-data/WorldData_Proxy_Force.png){: w="1606" h="907" }
_Selected Proxy with Forced Threats_

You can also switch the proxy to an automatic mode which will perform a trace by enabling `Use for Auto Trace`. This will make the proxy's icon blue instead of purple and show radius previews for the `Auto Min Distance` and `Auto Max Distance`  
* `Auto Min Distance` and `Auto Max Distance` can be used to constrain the trace. Not too close so the SWAT doesn't twist weirdly and not too far for optimisation.
* `Use Clip Plane` will use the `Clip Plane` transform to further constrain valid Threats. 
    * You can use this make SWAT look at upstairs balconies from below but not above or at a corner from one side, but not the other etc.
    * `Clip Plane` can be selected in the view-port to be moved or rotated.
    * The plane is infinite, with Threats on the green side being kept. 
    * If you've already ran `Do Look At Traces`, you will see a temporary debug coloured point as you adjust the plane.  
	
![Selected Proxy with Auto Trace and a Clip Plane](/assets/world-data/WorldData_Proxy_AutoTrace_ClipPlane.png){: w="1944" h="1122" }
_Selected Proxy with Auto Trace and a Clip Plane_

## 4. Doors
>The selection-only debug previews only work/update when the Tool is open. That includes Front/Back text, clear-points and stack-up point info.
{: .prompt-info }

### Placement
* A room should always have it's nav-mesh separated by a door or doorway  
* Large spaces should be split at thresholds (usually with a doorway) to limit how much SWAT needs to clear, but it's not required.  
    * Doors should NOT be scaled, instead you should select the `DoorWayBox` component and edit it's `Box Extent` variable. DO NOT scale it.
	* The `DoorWayBox` can be moved on the Y and Z axis. The actor's root seems to usually be in the corner or towards the centre of a doors threshold.
* Using a custom door mesh smaller than the RoN door sizes is not recommended. Often this will lead to AI being able to path normally through a door, but SWAT not being able to do clear activities (probably due to the swung door's nav modifier blocking the small threshold)

![A Doorway Box on Meth that is offset slightly from the actor root](/assets/world-data/worlddata_mth_garage_doorway.jpg){: w="1972" h="1105" }
_A Doorway Box on Meth that is offset slightly from the actor root_
### Front & Back Threats
1. `Front Threat` should be assigned to an `TL Extreme` threat placed right in front of the door with the correct room.
2. `Back Threat` should be assigned to an `TL Extreme` threat placed right in back of the door with the correct room.  
    > When you select a door spawner with the tool open, you will see front/back left/right texts which indicate what side you are facing.  
    > When the text is readable, you are on that side of the door.
    {: .prompt-info }
	> Once assigned, a green arrow (front) and red arrow (back) will be permanently visible to indicate assigned threats.
    {: .prompt-tip }
3. ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Threats_Sync.png){: .right }{: w="222" h="38" } In the tool, press the `Sync Threat Awareness` button.  
This will populate the `Front/Back Threat Awareness Points` arrays on ALL your door spawners based on the two above assigned threats.

> These are super critical. Your SWAT will stack, but not clear if these are missing.  
> If these are assigned to the wrong room your game will crash when SWAT tries to clear the door, so be careful when duplicating already configured doors.
{: .prompt-danger }

### Stack-Up Actors
* We will use the `BP_StackUpActor` class based on the RoN class "StackUpActor". This contains some helpful debug previews and compatibility with door spawners.
* There should be 4 for each position; `Front/Back left/Right Stack Up Points`. These are variable arrays on the door spawner, in the `World Gen > Stackup` category.
* `Depth` and `Stack Up Position` need to match on the Stackup actors. `0 = SP Alpha`,`1 = SP Beta` etc
* `Door Spawner` should be linked on each BP_StackUpActor to it's owning door.
* To avoid manually doing this, you should use the Tool.

1. Select a door spawner.
2. In the tool, press the `Add Stackup Points` button.
3. Adjust the location of each `BP_StackUpActor` as needed.
    * Make sure it is above valid nav-mesh
	* Keep in mind the swing of the Door
	* When selected, you will see the capsule size of the player/SWAT so you can place them far enough apart.
	* You can rotate (usually the last two) points so SWAT covers more angles.

![Add Stackup Points](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Door_AddStackupPoints.png){: w="222" h="38" }
_Add Stackup Points_

> ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Door_AddStackupPoints_Folder.png){: .right }{: w="222" h="38" } The text box below that button is the folder location the new actors will be placed in the Outliner. 
{: .prompt-info }
> ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Door_AddStackupPoints_Offset.png){: .right }{: w="222" h="38" } The selector box to the right let's you choose the initial offset of the new stackup actors. `Place in Front` can be more useful for corners or doorways placed 90° against a wall.
{: .prompt-info }
> You can use `Undo` to remove the added stackup actors, but double-check that there are not empty references left in your door spawner's stackup arrays.
{: .prompt-warning }

![Stackup Points Selected](/assets/world-data/WorldData_Door_Stackups.png){: w="1866" h="761" }
_Stackup Points when selected show assigned door and capsule size_

<a id="roompos"></a>
* [Room position](#room-position) can be used to limit stack-up points to one side in the command menu, but SWAT may not always respect it or may still "Pie it" or "Check the threshold".  
In that case, you should delete the undesired side's `BP_StackUpActors` from the level and assign the desired side's array to the undesired now empty array in the door spawner's properties.

> You can copy a variable quickly by `Shift + Right Mouse Button` clicking on the source and `Shift + Left Mouse Button` clicking on the target.  
> ![](/assets/world-data/Unreal_ShiftCopyPaste.gif){: w="467" h="316" }
{: .prompt-tip }

![Stackup Points Corner](/assets/world-data/WorldData_Door_Stackup_Corner.png){: w="1919" h="796" }
_Stackup Points in a Corner, with room position indicating undesired `[X]` stackups_

### Clear Points
![](/assets/world-data/worlddata_door_Clearpoint.png){: w="370" h="435" }{: .right }
* There are 4 clear point arrays for each door spawner; `Front/Back left/Right Stack Up Points`. These are in the `World Gen > Clear Points` category.
* For the arrow and sprite previews to be visible when selected, the Tool needs to be running.
* For each clear point added to the array;
    * The first clear point in each array, index [0] should usually be right in front of the door’s swing and `Direction` **MUST** be set to `None`
    * The next Clear Points’ Directions should be `Right` and incrementing `Stage`.
    * `Clear Point Trace Door LOS` can be run from the tool with door/s selected to set the **Has Line of Sight to Door** bool variable on each clear point.
	* Each clear point has a diamond-shaped gizmo to control it's location in the viewport. 
	
I’d recommend using the `Add Clear Point` and `Remove Clear Point` buttons in the tool, since it will set all of this automatically and give a nice offset based on the last point.
#### Add Clear Point	
1. Select a door spawner.
2. In the tool, under the **Add Clear Point** button, chose which side and face to work on, such as `Front Left`
    ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Door_AddClearPoints_WorkingSide.png){: w="222" h="38" }
    > ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Door_AddStackupPoints_ColourFilter.png){: .right }{: w="222" h="38" } To the right of the working side drop down selector, there is a check-box. This will change the sprite previews of the clear points when the door spawner is selected, showing only the currently "active" clear point array with colours.
    {: .prompt-info }
3.  ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Door_AddClearPoints.png){: w="222" h="38" }{: .right } In the tool, press the `Add Clear Point` button.

4. I'd recommend adding the first clear point for each side and face, as it will be added at an offset, indicating which way the clear path should head off in.
     ![](/assets/world-data/worlddata_door_clearpoint_0s.png){: w="1280" h="720" }
	 _Clear Points `[0]` added with the Tool button. Each will have slight offset_
5. The first point `[0]` should be placed in front of the door. It can be offset (along the doors threshold) for very long doorways, closer to the stackup actors. For double doors, it should be near the centre of the overall threshold, but offset to the relevant side. See [Wide Doorway Image](#widedoorway)
6. Keep using the `Add Clear Point` button to add to the clear path, following the outer edge of your room usually. Keep in mind;
    * You should try to visit every Threat Awareness Actor in the room with either the **Left** or **Right** clear path for that face of the door.
	* The first clear points should be close (~100 units) to the stack up points, so that the 2nd SWAT isn’t waiting for the 1st to reach his first clear point to enter the room and start their own clear.
	* Clear points should be above nav-mesh and the clear path shouldn't leave the room.
7. Usually for the final element on each clear path, you should add the nearest **Cover Landmarks** to the relevant array. Each landmark should be added to one clear point element.
8. Repeat the same process for the other 3 sides/faces.
9. ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Door_ClearPointLOSTrace.png){: w="222" h="38" }{: .right } After placing or editing your clear points, in the tool with the door selected, press the `Clear Point Trace LOS` button.

10. ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Door_ClearPointDirectionByAngle.png){: w="222" h="38" }{: .right } And also after editing your clear points, in the tool with the door selected, press the `Clear Point Direction by Angle` button.  
  
<a id="widedoorway"></a>
![](/assets/world-data/worlddata_door_clearpath.png){: w="1920" h="1080" }
_The 4 clear paths of a single door. Note that for each room, the clear points will take the SWAT along a path where they can see every threat._
![WideDoorway](/assets/world-data/worlddata_door_clearpoints_wide_doorway.png){: w="1920" h="1080" }
_A wide doorway, with the first clear points moved closer to the stackup actors, on the opposite sides_  

#### Add Clear Point (by Nav)
If you want a more rapid process for this you can use the `Add Clear Point (by Nav)` in the tool. This is more useful for large areas like outdoors.  
![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Door_ClearPointByNav.png){: w="222" h="38" }  

1. Select a door spawner.
2. In the tool, above the **Add Clear Point (by Nav)** button, chose which side and face to work on, such as `Front Left`
3. Ensure at least the first clear point `[0]` has been added for the side/face you are working on. Press the `Add Clear Point` button if not, and adjust position if needed.
4. To the right of the **Add Clear Point (by Nav)** button, use the number input to define your final clear point spacing. **100** is what the auto-gen spaces and is good for small rooms. **150** for medium rooms and **200/250** is great for large spaces.
     > ![](/assets/world-data/T_Clear_34plus.png){: w="48" h="48" }{: .right } The selection numbered sprite previews only go up to 34, so you should probably adjust your spacing if you reach that many clear points 😉
	 {: .prompt-info }
5. Hold shift and select an additional actor (like a Threat) where you would like your path to navigate to. 
     > Add additional actors to your selection as needed to define a path all at once.
	 {: .prompt-tip }
6. Finally press the `Add Clear Point (by Nav)` button. This will try to attempt to find a path from the last element in the clear point array to each additional selected actor. A spline will temporarily be created and sampled along it's path based on the spacing set in step `#4`. For each sampled point, a clear point will be added to the array you currently have selected in step `#2`
7. When done, with the door selected press the `Clear Point Trace LOS` and `Clear Point Direction by Angle` buttons like in `#9` and `#10` from the above section.

{%
  include embed/youtube.html
  id='tinhvt2TPfY'
  autoplay=false
  loop=true
  muted=true
%}

### Room Position
`World Gen > Room Position`
Room position has a minor effect on SWAT clearing but mainly effects stack up behaviour.  
The main differences of Centre vs Hallway are;
* Centre - Allows stack ups on either side of the door Front and Back.
* Hallway - Allows one stack, Front/Back (Not tested. `Can Issue Orders on Front/Back Side` may be more reliable if needed).  
When clearing, after passing the threshold, they will skip corner checks and focus/aim at further distances. SWAT voice lines will also be different when clearing and mirroring.

As mentioned in [#Stack-Ups](#roompos) the main purpose I've found for room position is to limit the command menu so there is only one stackup option.
However SWAT may not always respect a left/right only room position if a stack-up is on the wrong side, or in front of the opening and may also still "PIE it" or "Check the threshold" if both stack-up arrays use separate actors.  
In that case, you should delete the undesired side's `BP_StackUpActors` from the level and assign the desired side's array to the undesired now empty array in the door spawner's properties.
> When selecting a left or right room position, a red `[X]` will overlay the "disabled" stack-up actors. If the left and right arrays are set to the same actors these are always shown, so just ignore them.
{: .prompt-tip }

### Double Doors
Note, traps don’t cover both doors and should be disabled for double doors.

The basic setup for interactions on doors A and B;
1. Set `Sub Door Spawner` on door A to door B
2. Set `Sub Door Spawner` on door B to door A
3. Pick one door, and enable `Main Sub Door`. Ensure this is disabled on the other door.

For World Data related values;
* Stack-Up Actors are shared
* Because one door has 180° of yaw rotation, the arrays will need to be re-ordered.
* Room Position would need to be swapped if relevant.
* Clear Points will want to be copied but are going to be 180° in the wrong direction.
* Front and Back threat **ABSOULUTELY** needs to be re-assigned to the correct Threat actors.

Therefore you can use the Tool to quickly fix this up;
1. Start with only one door. Delete the sub-door if it exists. Setup stack up actors and clear points as usual for Door A. Stack up actors should be moved to the sides of the threshold for the side with the sub-door.
	> The Stack-Up Actors' `Door Spawner` variable can remain pointed at Door A for every side.
	{: .prompt-info }
2. Duplicate Door A and rotate/offset the new Door B as needed.
3. Set the `Sub Door Spawner` references and `Main Sub Door` variables on door A and B.
	> **Don't forget** to untick `Main Sub Door` on door B if it was enabled for door A when you duplicated it!
	{: .prompt-danger }
4. For the new door B, be sure to set the new correct `Front Threat` and `Back Threat` and run the `Sync Threat Awareness` Tool function at some point.
	![](/assets/world-data/WorldData_DoubleDoor_Threats.png){: w="1920" h="1080" }
	> If you forget this, your game will probably crash when SWAT interacts with the door.
	{: .prompt-warning }
5. Select Door B.
6. In the Tool, press the `Flip Stackup Points` button. This should flip the door's *Stack Up Points* arrays so that they are correct for a 180° yaw rotation.
	> ![](/assets/world-data/Unreal_Select.png){: w="20" h="20" }{: .right } To check this, use the select button by one of the arrays' elements to confirm the stack up actor matches the Front/Back Left/Right texts.
	{: .prompt-info }
7. In the Tool, find the **Flip Clear Points** button and ensure the selector box to it's right is set to `2x`
8. ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Door_FlipClearPoints.png){: w="222" h="38" }{: .right } In the Tool, press the `Flip Clear Points` button.  
9. Adjust each clear point `[0]` element's position so it's at the centre of the threshold or at least nearer the side of Door B.  
  
> You can also use these buttons if you want to flip a single door around and keep your setup stack-ups and clear points.  
> Just be sure to set the offset in **step #7** to `1x` before running, `Flip Stackup Points`  
> Also don't forget to flip the `Front Threat` and `Back Threat` and run `Sync Threat Awareness`
{: .prompt-tip }


## 5. Rooms Final
Now that our Door's and Threats are placed and referencing each other and assigned to Rooms, we want to ensure our Rooms' variables are configured correctly.
1. For each [Room Proxy](#2-rooms), select it and;
2. Check that each of the Room's doors are assigned to the `Room | AdditionalRootDoorSpawners`. A large orange bounds box and arrow should be surrounding them if the Tool is running.
3. Check that `Room | Connecting Rooms` is populated with the names of the other Rooms which have shared doors with assigned Front/Back threats. A big orange arrow should link them if the Tool is running.
4. ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Threats_Sync.png){: w="222" h="38" }{: .right } Finally, in the Tool, run the `Sync Threat Awareness` button.  
Nothing needs to be selected when doing so.  
This function will;
	* For Door Spawners; based on the `Front/Back Threat` populate the `Front/Back Threat Awareness Points` arrays, by matching `Owning Room` and `Pathable Group ID`.
	* For Threats; populate the `Pathable Threat Awareness Actors` elements based on `Owning Room` and `Pathable Group ID`
	* For Room Proxies; populate the `Threats` array by matching `Room | Name` to each threat's `Owning Room`
	* For Threats also; pick a `Preferred Exit` for each `Owning Room` if missing and add it's world location to each threat's `Exits` element `[0]`
  

  
> You much re-run this button once before launching your game if you;
* Delete or add a Threat Actor.
* Change a threats `Owning Room` or `Pathable ID`.
* Change a Door's `Front or Back Threat` variables.
* Change Threat Actor's `Preferred Exit` variable.
{: .prompt-danger }

# Cover Points

![](/assets/world-data/worlddata_coverpoint_showcase.webp){: w="1920" h="1080" }

Cover Points are locations that Civs or Suspects can use to take cover. 
 * They are auto generated, pretty well, as long as your collisions are clean or you have helper blocking volumes set to the `Cover` collision profile.
 * They are generated as an element of a collection called a `Rail`. Each rail has a Start and End world location and a struct array of the other cover point actors world location and a global unique ID number.
 * Cover point actors for that reason, usually have a meta-data tag to prevent manual placement (disabled in newer framework builds) and have their transforms/location locked.
 * Civilians will crouch/lean against cover.
 * Suspects can shoot over or lean around cover based on it's type.  
 
## Cover Point Overview

For the framework, you will be using the `BP_CoverPoint` blueprint based on the "CoverPoint" DynamicCoverSystem class.
You should never manually place, copy or duplicate a BP_CoverPoint.  
 * If you need to add a single cover point, use the `BP_CoverPoint_Single` actor.  
 * If you want a new Rail of cover points, you will use a `BP_CoverPointRailPreview` and the Tool, as explained later.  
 * The location of a cover point is locked and shouldn't be manually edited along with it's rotation. You can edit it's transform with the Tool's `Cover Rails` section, covered in [#Cover Rails](#cover-rails)
 
![](/assets/world-data/worlddata_coverpoint_overview.webp){: w="1920" h="1080" }

 * `Index`: A unique number that needs to be unique across the whole level. This is the number shown in the view-port.
 * `Is Crouch Only Cover`: Crouch or Crouch+Standing cover. If true, will only show the bottom Type sprite and direction arrows. Also changes the yellow box preview when selected.
 * `Stand Cover Type`: Whether the user considers this a middle wall section, or if they have the option to lean based on a selected direction. This is shown by the top sprite, which is hidden if Crouch-Only is True.
 * `Crouch Cover Type`: The same as above, but with the added combination option of `Up` if Crouch-Only is True. This is shown by the bottom sprite.  
     * Type sprites sizes are based on their location in a rail. First and Last elements are bigger than the elements in between. (You may require selecting with the Tool open to update this preview sometimes)
   
 * `Stand Cover Direction/ Crouch Cover Direction`: Used when the user leans. The Direction is always just the Rail Start to Rail End vector or inverted, based on Left/Right. This is previewed by the Green Arrow (Left) and Blue arrow (Right)
 * `Cover Rail`: A struct with the World Position Start and End, Direction and World Position + Index array of self and other Cover Point actors contributing to the rail. The Start and End are previewed by a 3D gizmo when selected.
     * When selected and the Tool is open, the Rail will also be previewed with a yellow box with a height based on Crouch-Only. This doesn't actually represent any surface, it's just a preview I based on how far and high imported generated cover points are usually from the floor/wall.

## Automatic Generation

1. Place a `BP_CoverGen_Saver`  
2. Place one or multiple `Cover Gen Override Volumes` to cover the playable nav mesh you want cover points to generate on. Don't change any settings.
3. When generating, sample traces will "walk" along the edge of the nav-mesh testing for a hit in the Cover channel at crouch and standing height. For better generation you should plug holes between props where you may want suspects to take cover behind.  
Regular Blocking Volumes can be used or they can also be set to `Cover` to not affect character collisions. You can cover gaps in balustrades, low car engine blocks, barricades of crates, tables and chairs etc.
     ![](/assets/world-data/worlddata_coverpoint_sampling.webp){: w="1920" h="1080" }
     _An example of how a ballistrade may be sampled when generating cover which may cause a cover point to not be generated, or an incorrect lean angle to be set_  
     ![](/assets/world-data/worlddata_coverpoint_coverblockingvolume.webp){: w="1920" h="1080" }
     _An example of a blocking volume with `Cover` collision profile, placed over a static mesh to provide cleaner generation._
4. Nothing more needs to be done if you want to just use automatic cover generation, which I'd recommend when iterating on your level. 
However, if your level geometry is locked-in you may wish to export out what is being generated and to edit and include with your level.

## Importing Automatic Generation

0. Make sure a `BP_CoverGen_Saver` and or supporting actors are in the level as per above section.
1. On the placed `BP_CoverGen_Saver`, set `Save Cover Points` to `True` (and also make sure `Enabled` is `True`).
2. Save, Cook and Pak your level to your game install.
3. Open the game and load your level. Wait for the countdown to finish and for you to spawn in game. Wait 4 to 10 seconds for the cover points to generate and save to disk.
4. Close the game and navigate to `%localappdata%\ReadyOrNot\Saved\SaveGames\Cover\` in windows explorer.  
	 > ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Cover_OpenGameSaveGames.png){: w="222" h="38" }{: .right } In the Tool, there is a button shortcut;  
     {: .prompt-tip }
5. You should find a `.Cover.sav` file that has your level name prefixed. Copy it.
6. In your Framework Project's directory, navigate to `...\Saved\`, from here create a `SaveGames` folder if missing and within, a `Cover` folder if missing.  
     > ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Cover_OpenProjectSaveGames.png){: w="222" h="38" }{: .right } In the Tool, there is another button shortcut, which also makes the folders if missing; 
     {: .prompt-tip }
7. Paste your LEVELNAME.cover.sav file into the project's `\Saved\SaveGames\Cover\` folder.
8. Back in Unreal Engine, with your level open, in the Tool, press the `Load Cover Point Save` button.  
You should see below the number of Cover Point's that have been read.
     > ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Cover_SaveName.png){: w="222" h="38" }{: .right } If "No save file loaded/found." is displayed, check that the correct level is loaded. You can see what .sav file is trying to be loaded in the text field to the left of the button.
     {: .prompt-warning }
9. ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Cover_CreateRailGizmo.png){: w="222" h="38" }{: .right } You can now press the `Create Cover Point from Save` button. A task will start and actors will start to be placed. Keep the editor focused until it completes.  
     > After importing and creating the cover points, the Tool will set any `BP_CoverGen_Saver's` `Enabled` variable to `False` effectively disabling it to avoid user error. If you want to iterate making changes for generation and visualising them in editor, you should delete every cover point in your level and set the `Enabled` to `True` before cooking, paking and loading your map.
     {: .prompt-danger }
	 > The `BP_CoverGen_Saver` should be disabled and can be deleted from the level once cover points have been created/imported.
     {: .prompt-info }  
	 
## Editing Cover Points

### Clean-up
After importing there may be some overlapping cover points/rails.  
  
1. ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Cover_SelectOverlap.png){: w="222" h="38" }{: .right } To quickly find these, press the `Select Next Overlap` button. This will compare every cover point's location in the level and find overlaps.  
It will select one set of cover points by the rail and focus the camera on them.
2. You can usually press `Delete` to remove the selected cover points rail, then repeat from step `#1` until `Select Next Overlap` is no longer selecting anything.
	 > BUG: Make sure you have no cover point selected before pressing the button. Looks like I forgot to clear your selection, so rails are still selected if nothing overlapping is found.
     {: .prompt-warning }  

### Type Changing  
![Cover Point types](/assets/world-data/Cover_Combined.png){: w="432" h="54" }
_Cover Point types_  
  
You'll probably come across a few cover points which you may want to tweak the type on.  
Your free to do so, however keep in mind types that didn't generate with a direction (ie Walls), will have no Direction vectors set.  
  
![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Cover_GuessDirection.png){: w="222" h="38" }{: .right } You can fix this by selecting the cover point/s and pressing the `Guess Cover Direction` button in the Tool which will pull the direction from the rail locations. 
Honestly you can probably just select every cover point (Ctrl + Shift + A) and run this if you want, since it seems to match what is generated normally.  
  
### Removing Cover Point/s

![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Cover_DeletePoint.png){: w="222" h="38" }{: .right } If you want to remove a cover point that is a part of a remaining rail, you should use use the `Delete Cover Point & Update` button in the tool.  
  
If you want to remove an entire rail set of cover points, with them all selected, you can use the regular `Delete` key since there will be no remaining references.  
  
> ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Cover_SelectByRail.png){: w="222" h="38" }{: .right } You can use `Select Cover Points by Rail Group` for quick selecting.  
{: .prompt-tip }

### Appending Cover Point

![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Cover_AppendPoint.png){: w="222" h="38" }{: .right } You can add a cover point to a rail using the `Append Cover Point & Update` button.  
This is based on the location of the selected cover point in a rail, determining which side of the rail it will be placed.
You edit it's location you can use the Tools [#Cover Rails](#cover-rails) section.

## Cover Rails

### Gizmo Blueprint

The `BP_CoverPointRailGizmo` is a custom Framework blueprint which is for manipulating the transforms of cover points in a rail. It's NOT meant to be manually placed.
Usage:
1. ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Cover_CreateRailGizmo.png){: w="222" h="38" }{: .right } Select a cover point or multiple.
2. Press `Create Rail Gizmo from Point` to create a rail gizmo.  
  
  
 > If multiple points from the same rail was selected, only one gizmo will be created.  
 > If a rail gizmo already exists for that cover point's rail, it will be selected instead.  
 > Therefore, if you wanted to create gizmos for the whole level, it is safe to just select every cover point and create rail gizmos.
 {: .prompt-info }
 
![](/assets/world-data/worlddata_coverpoint_railGizmo.png){: w="1156" h="563" }
 
 * Rail gizmos can be freely deleted and remade.
 * Rail gizmos are selected via the now always visible blue mesh preview, or the `<--- Rail Gizmo --->` text.
 * Rail gizmos can be moved or rotated to move every cover point in the rail set that it has been assigned. Don't scale.
 * Individual cover point locations can now be manipulated by first selecting the rail gizmo, then using the diamond gizmos to edit. 
	Be sure to select the gizmo's wire-frame and not the cover point sprite so you don't change your actor selection.
 * The Delete and Append cover point Tool buttons will update rail gizmos when used, but work best on the start and end cover points of a rail. 
    Even then, the logic isn't great, so you may end up with some weird behaviour with new points on the wrong side or the need to delete and remake a rail gizmo.
  
### Preview Blueprint
![](/assets/world-data/worlddata_coverpoint_railPreview.gif){: w="979" h="583" }
_Preview Rail gizmo handles_  
  
The `BP_CoverPointRailPreview` is a preparation tool. It can be used to create a completely new rail and set of cover actors.  
Usage:
1. Place a `BP_CoverPointRailPreview` in the level. Adjust it's location so the points are above the ground. The preview wall offset will match what you see when you select a regular cover point.
2. You can use the Rail Start and End diamond wire-frame gizmos to size your rail and preview your cover points.
3. You can edit various variables to automatically set properties on the cover point actors that will be created as-well-as spacing options.
4. ![](/assets/world-data/WorldDataToolImages/Image_WorldDataTool_Cover_ConvertRailPreview.png){: w="222" h="38" }{: .right } When ready, press `Convert Rail Preview` to create your new cover point actors and delete the preview blueprint.  

 > The `Convert Rail Preview` performs the actor creation then preview deletion as two separate "Transactions".  
 > This means if you want to reuse the preview blueprint, you can run `Undo` once to get the blueprint while also retaining the new actors.  
 > Press `Undo` twice to fully undo the operation if needed.
 {: .prompt-tip }
 
### Cover Point Single
![](/assets/world-data/worlddata_coverpoint_single.gif){: w="871" h="500" }
_It's single, not meant to mingle._

The `BP_CoverPoint_Single` blueprint is also based on the "CoverPoint" DynamicCoverSystem class, however, it has no transform locks.
 * It's rail is set relative to itself.
 * It's rail is not meant to be expanded with other cover points.
 * While the Tool _does_ work with it, you shouldn't ever use it with this blueprint to append etc. 
 * Great when you just need an extra cover point somewhere on it's own, like around a tree trunk or column etc.