---
title: Setting up Audio and Working with QSM
date: 2024-01-09 00:00:00 +0000
categories: [Map Modding]
tags: [maps, audio]
description: An in-depth guide on making your map compatible with the Quantum Sound Manager (QSM)
author: Delta|https://www.nexusmods.com/readyornot/mods/3072/, Zack|https://voidinteractive.net/
---

# Setting up Audio and Working with QSM

>This information is very temporary at the moment and highly likely to change.
{: .prompt-danger }

## Introduction
Ready or Not uses a combination of FMOD and an in-house built audio solver called the [Quantum Sound Manager (QSM)](https://www.youtube.com/watch?v=ATLRmTDEfG8){:target="_blank"}. QSM is a method to help with reverb and audio occlusion from around the map and takes into consideration room sizes, door states and even whether or not glass is broken and adjust volumes accordingly.

This documentation will explain the requirements to get QSM working within your map and how to integrate it with FMOD ambience and events.

If you want documentation on how to set up dynamic music for levels, the below documentation is pre-requisite knowledge. Once understood you can check out: [Setting up Music Events for Levels](){:target="_blank"}.

## Actor Overview
>Any property not listed in the tables below are meant to be private and we shouldn't modify them
{: .prompt-info }

### Ready Or Not Audio Volume
* A Volume that controls FMOD Events when players are in them
* Maps require at least one for Reverb and Ambient Sounds that cover the entire playable space

| Property | Description |
|:---|:---|
| Reverb Events | *Unknown use* |

### Room Volume
* These are volumes that are placed within the interior sections of your map. They aim to represent the different shapes and sizes of the rooms they occupy.
* QSM will use these volumes to determine how the audio will bounce around the room according to the shape of the volumes.
* They can be comprised of 1 or many different volumes

| Property | Description |
|:---|:---|
| Room Group ID | Used to group multiple Room Volumes covering the same room |

>DO NOT Edit the scale of these. If you require to edit the shape, modify the Volume in Brush Edit mode (Shift+4).
{: .prompt-warning }

### Portal Volume
* These volumes act as portals for QSM to pass through into other rooms. These are specifically placed in doorways, open windows, arches & holes and even managing when glass is broken.

| Property | Description |
|:---|:---|
| Is Outside | Enable if the Portal connects to the outside   |
| Portal Type | Used to determine the direction in which sound will pass through the portal: **HORIZONTAL** for regular use through doors and windows. **VERTICAL** for upward sound direction through a well or hole in the ground. |
| Attached Objects | ~~Add your doors that are within the Volume to this array. **DO NOT ADD TO "Doors"!**~~  WORK-AROUND: Assign the Portal Volume to the *Door's* `Add to Audio Portal Volume` |
| Breakable Glass Soft Pointer | Pointer to the Breakable Glass BP the Portal Volume covers, currently we dont have a working breakable glass example |

>DO NOT Edit the scale of these. If you require to edit the shape, modify the Volume in Brush Edit mode (Shift+4).
{: .prompt-warning }

### Sound_ParameterTransition_V2_BP_C Blueprint
* This Blueprint is used to help transition between different FMOD and Reverb states. Specifically used when passing through doors and thresholds into other rooms. They can also be used to activate parameters for the music in the game to make it more dynamic.

| Property | Description |
|:---|:---|
| FMOD Ambient / Music Events | Contains the FMOD Events that control the Transitions. For Ambient sound Outdoor-to-Indoor Transitions - choose which map Ambient sounds to go here (will contain `*_Amb` in the file name, eg: `Gas_Amb_V2` |
| INParameter | FMOD Parameter taken from the Amb FMOD Event you added above. You can find these values here: [Reference - FMOD Parameters](){:target="_blank"} |
| OUTParameter | Exactly the same as above, but usually suffix with `OUT` (eg: `GasAmbOUT`) |
| Reverb IN | Select the drop down that best represents the Room Reverb you are moving into |
| Reverb OUT | Select the drop down that best represents the Reverb in the room you are entering from |
| Global Parameter IN | The FMOD modifier for Indoor Audio. Set to `1` as a good default |
| Global Parameter OUT | The FMOD modifier for Outdoor Audiot. Set to `0` as a good default |
| Use Door Check Feature | Enable if the transition between Rooms uses doors. Helps with determining reverb on different door open states. |
| Gobal Parameter Door Check? | Leave `Disabled`. *Unsure what it does.* |
| Doors Open | *Unable to modify, but within the official editor, is auto populated via the Construction script.* |

>The 'IN' part of the BP can be identified by the white spline line inside the box when the BP is UNSELECTED.
{: .prompt-info }

>Distance Along Spline Threshold, Min/Max Range OUTSIDE/INSIDE can be edited but should be left default values. These are spline editing values used for more artistic control on fringe case audio transitions. An example of this is the long corridor in the club that heads towards the dance floor.
{: .prompt-info }

>DO NOT Edit the scale of these. If you require to edit the shape, modify the `Box` component's `Box Extent`. Editing the object scales will mess with the FMOD transitions.
{: .prompt-warning }

## Setting up Audio
> Before beginning, it is **highly** recommended that each one of these steps are done within a folder (or sub-level) within the World Outliner to keep things ordered. In this particular case you should be renaming assets (F2) as you create them to keep things managable.
{: .prompt-tip }

### Part 1 - Ready or Not Audio Volume and Level Ambience & Reverb
1. Drag a `Ready or Not Audio Volume` from the actor's tab into the scene.
2. Edit the brush to cover the playable area. 
    * It is recommended to scale it just a bit over to encapsulate the some of the outside area as a safety net against players
3. Go to `Content > FMOD > Levels > Reverbs` in the Content Browser and select the `ReverbMaster` FMOD Event and drag it into your scene.
4. **IMPORTANT**: Within the World Outliner, find this Event and drag it ONTOP of the `Ready or Not Audio Volume` to make it a child actor of it.
5. Decide which Level's ambience is appropriate for your map and navigate to `Content > FMOD > Levels` and enter the appropriate level folder.
6. Find the correct Ambient FMOD Event for your specific level listed here: [Reference - FMOD Parameters](){:target="_blank"} and drag it into your scene.
7. **IMPORTANT**: Within the World Outliner, find this Event and drag it ONTOP of the `Ready or Not Audio Volume` to make it a child actor of it, just like before.

The Ready or Not Audio Volumes can also be used to control FMOD events that should play persistantly around the map but shouldn't be heard all the time. e.g. The hum of a fridge that was in a room, but you didn't want to hear it if you were outside. Another example would be hearing the splash of a water feature outside, but only if you were close to it. 

You can think of them as trigger volumes to control scenarios by setting them up in the same manner as above, by making any relevant FMOD Events a child actor of the Volume. 

### Part 2 - Setting up Room Volumes

Room Volumes (RV) have a couple of requirements and quirks that you **MUST** follow:
* You DO NOT need a RV for the Exterior/Outside portions of your map. Only Interior sections. 
* A room's RV can consist of 1 or multiple RVs. If you are using multiple RVs for a single room, make sure they share the same `Room Group ID`. 
    * It is best to just keep RV as simple Boxes if you are using many.
    * RVs cannot be concave.
* RVs of the same ID can overlap, and it is recommended to slightly overlap volumes to be safe.
* HOWEVER RVs of different IDs **CANNOT** overlap **AND** their faces must be touching/meeting (see Figure below). Failure to meet these requirements will mean that QSM will not work correctly. 
    * It is HIGHLY recommended that for this process you keep World grid snapping enabled for your entire process to make 'meeting' the walls an easier task.
    * Snapping to 5uu is an excellent increment to work fast and accurately.
* It is recommended that the RVs conform to the shape of the room they are in as closely as possible. 
* It is also recommended that the volumes also slightly extend into the floors, walls & ceilings rather than undershoot them as so the Audio bounces retain their accuracy. 
    * Having the RV not extend outside the walls a little bit might cause issues such as footsteps not being heard on the floor or gunshots not being registered inside the room if they hit the ceiling or walls.
    * I have used a spacing of 5uu as a good buffer for my extra extending.

### Part 3 - Setting up Portal Volumes

Portal Volumes (PV) are relatively easier to set up in comparison to Room Volumes and don't require as many special rules

1. Drag a  `Portal Volume` from the actor's tab into the scene.
2. Drag the PV so that it covers the threshold between 2 different Rooms. e.g. Between a doorway or going from an outdoor area to an interior one.
3. Edit the PV in Brush Edit Mode (Shift+4) so that it completely covers the doorframe/window/hole and extends out a little bit. See pictures below for examples (TODO)
    * **DO NOT Scale** the PV, they should only be edited via Brush Edit Mode
3. If the PV goes from an exterior/outdoor area into an interior area with Room Volumes, Enable the `Is Outside` property
4. In most cases, leave `Portal Type` to `HORIZONTAL`.
5. You do not need to change the `Breakable Glass Soft Pointer` as we do not have a working example for Breakable Glass
6. Finally, if you have doors within your PV, select the Door Actor and within the Door Actor's properties find `Add to Audio Room Portal` and use the eye dropper to select the appropriate PV.
     * Not doing so will cause the door's audio to be muffled on one side of the door when interacting with it.

>Zack recommends to approach doing Portal Volumes by completeing the Outdoor-to-Indoor thresholds first for testing. You will need to make sure that all of these thresholds are covered for QSM to correctly identify the Interior and Exterior areas. 
{: .prompt-tip }

### Part 4 - Setting up Sound_ParameterTransition_V2_BP_C Blueprints

#### Part 4.1 Placing the Transition BP
1. Drag a `Sound_ParameterTransition_V2_BP_C` into the scene, located within the Content Browser at `Content > Blueprints > Sound`.
2. Identify which side of the BP is the `IN` side by **UNSELECTING** the BP and noting down what side the white spline line inside the box is on. The side the line is on is your `IN` direction. 
    * When you select the BP there will be splines on either side.
3. Rotate the Transition BP appropriately so you know which part of the BP is `IN` & `OUT`
4. You will likely need to resize the BP, but it is imporant that you **DO NOT SCALE** it. To change the size select the `Box Component` of the BP and adjust the `Box Extent` values instead.
    * The size of the box is an artistic choice but note that as soon as a player steps into it, the transitions will begin. So take careful consideration to not place them in areas that do not make sense logically. 
5. The spline values determines the ratio in which the volume of the ambience changes when moving through the BP. You should make sure that if you edit the `Box Component`, you also edit the `Spline Component` points on either end to be WITHIN the `Box Component`
    * You should only need to change the `X` value for the spline point's `Location`

>Transition BP's require different property settings for Outdoor-to-Indoor and Indoor-to-Indoor thresholds. Please read the requirements properly. 
{: .prompt-warning }

#### Part 4.2 Properties for OUTDOOR-to-INDOOR Transitions
1. Add (`+`) an element to `FMOD Ambient / Music Events` and add your Ambient Event you selected from step 1.
2. For the same element, type the corresponding `INParameter` & `OUTParameter` that is defined within the same FMOD Event
    * These do not have a consistent naming convention, however the OUT parameter is usually named `OUT` or `EXT`
        * Eg: `Gas_Amb_V2` is `GasAmbIN` & `GasAmbOUT`, while `Valley_Amb_V2` uses `ValleyAmbINT` & `ValleyAmbEXT`
    * You will need to locate these identifiers defined here [Reference - FMOD Parameters](){:target="_blank"}
3. Select the appropriate reverbs for your rooms for `ReverbIN` & `ReverbOUT`
4. For `FMOD Global Parameter` type in exactly: `AmbSwitch`
5. Enable `Use Door Check Feature` if your Transition BP contains doors
6. You cannot add elements to `Doors Open`, this is supposed to self-populate via the BP's construction script.
7. Se the `Global Parameter IN` to be set to `1` & `Global Parameter OUT` to be set to `0`

#### Part 4.3 Properties for INDOOR-to-INDOOR Transitions
1. Select the appropriate reverbs for your rooms for `ReverbIN` & `ReverbOUT`
4. Thats it! You don't need to modify any of the other properties like above. It is actually recommended not to modify anything else as the BP has checks that will mess up audio for smooth Interior transitions.
