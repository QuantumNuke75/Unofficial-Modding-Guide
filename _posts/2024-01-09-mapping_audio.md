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

## Actor Overview
>Any property not listed in the tables below are meant to be private and we shouldn't modify them
{: .prompt-info }

### Ready Or Not Audio Volume
* A volume that controls how Reverb and Ambient Sounds behave when players are within it
* Only 1 of these are required and should cover the entire playable space

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
| Attached Objects | Add your doors that are within the Volume to this array. **DO NOT ADD TO "Doors"!** |
| Breakable Glass Soft Pointer | Pointer to the Breakable Glass BP the Portal Volume covers, currently we dont have a working breakable glass example |

>DO NOT Edit the scale of these. If you require to edit the shape, modify the Volume in Brush Edit mode (Shift+4).
{: .prompt-warning }

### Sound_ParameterTransition_V2_BP_C Blueprint
* This Blueprint is used to help transition between different FMOD and Reverb states. Specifically used when passing through doors and thresholds.

| Property | Description |
|:---|:---|
| FMOD Ambient / Music Events | Contains the FMOD Event for Ambient sounds - choose which map Ambient sounds to go here (will contain `*_Amb` in the file name, eg: `Gas_Amb_V2` |
| INParameter | FMOD Parameter taken from the Amb FMOD Event you added above, suffix with `IN` (eg: `GasAmbIN`). Double click the FMOD event to find these values. |
| OUTParameter | Exactly the same as above, but suffix with `OUT` (eg: `GasAmbOUT`) |
| Reverb IN | Select the drop down that best represents the Room Reverb you are moving into |
| Reverb OUT | Select the drop down that best represents the Outside Reverb |
| Global Parameter IN | The FMOD modifier for Indoor Audio. Set to `1` as a good default |
| Global Parameter OUT | The FMOD modifier for Outdoor Audiot. Set to `0` as a good default |
| Use Door Check Feature | Enable if the transition between Rooms uses doors. Helps with determining reverb on different door open states. |
| Gobal Parameter Door Check? | Leave `Disabled`. *Unsure what it does.* |
| Doors Open | *Unable to modify, but within the official editor, is auto populated via the Construction script.* |

>Distance Along Spline Threshold, Min/Max Range OUTSIDE/INSIDE can be edited but should be left default values.
{: .prompt-info }

>DO NOT Edit the scale of these. If you require to edit the shape, modify the `Box` component's `Box Extent`. Editing the object scales will break QSM.
{: .prompt-warning }

## Setting up Audio
> Before beginning, it is **highly** recommended that each one of these steps are done within a folder (or sub-level) within the World Outliner to keep things ordered. In this particular case you should be renaming assets (F2) as you create them to keep things managable.
{: .prompt-tip }

### Part 1 - Getting the FMOD Assets into your Project
TODO

### Part 2 - Ready or Not Audio Volume and Level Ambience & Reverb
1. Drag a `Ready or Not Audio Volume` from the actor's tab into the scene.
2. Edit the brush to cover the playable area. It is recommended to scale it just a bit over to encapsulate the some of the outside area as a safety net against players
3. Go to `Content > FMOD > Levels > Reverbs` in the Content Browser and select the `ReverbMaster` FMOD Event and drag it into your scene.
4. **IMPORTANT**: Within the World Outliner, find this Event and drag it ONTOP of the `Ready or Not Audio Volume` to make it a child actor of it.
5. Decide which Level's ambience is appropriate for your map and navigate to `Content > FMOD > Levels` and enter the appropriate level folder.
6. Find the `FMOD Event` that has `*_Amb` in the name. (eg: `Gas_Amb_V2`) and drag that into your scene
7. **IMPORTANT**: Within the World Outliner, find this Event and drag it ONTOP of the `Ready or Not Audio Volume` to make it a child actor of it, just like before.

### Part 3 - Setting up Room Volumes

Room Volumes (RV) have a couple of requirements and quirks that you **MUST** follow:
* You DO NOT need a RV for the Exterior/Outside portions of your map. Only Interior sections. 
* A room's RV can consist of 1 or multiple RVs. If you are using multiple RVs for a single room, make sure they share the same `Room Group ID`. 
    * It is best to just keep RV as simple Boxes if you are using many.
    * RVs cannot be concave.
* RVs of the same ID can overlap, and it is recommended to slightly overlap volumes to be safe.
* HOWEVER RVs of different IDs **CANNOT** overlap **AND** their faces must be touching/meeting (see Figure below). Failure to meet these requirements will mean that QSM will not work correctly. 
    * It is HIGHLY recommended that for this process you keep World grid snapping enabled for your entire process to make 'meeting' the walls an easier task.
* It is recommended that the RVs conform to the shape of the room they are in as closely as possible. 
* It is also recommended that the volumes also slightly extend into the walls rather than undershoot them as so the Audio bounces retain their accuracy

### Part 4 - Setting up Portal Volumes

### Part 5 - Setting up Sound_ParameterTransition_V2_BP_C Blueprints

## Setting up OST Triggers
