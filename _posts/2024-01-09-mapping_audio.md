---
title: Setting up Audio and Working with QSM for Maps
date: 2024-01-09 00:00:00 +0000
categories: [Map Modding]
tags: [maps, audio]
description: An in-depth guide on making your map compatible with the Quantum Sound Manager (QSM)
author: Delta|https://www.nexusmods.com/readyornot/mods/3072/, Zack|https://voidinteractive.net/
---

# Setting up Audio and Working with QSM for Maps

## Introduction
Ready or Not uses a combination of FMOD and an in-house built audio solver called the [Quantum Sound Manager (QSM)](https://www.youtube.com/watch?v=ATLRmTDEfG8){:target="_blank"}. QSM is a method to help with reverb and audio occlusion from around the map and takes into consideration room sizes, door states and even whether or not glass is broken and adjust volumes accordingly.

This guide will explain the requirements to get QSM working within your map and how to integrate it with FMOD ambience and events. 

The Example Map provided in the Template has QSM set up for a generic house, so check it out if you're curious.

The second part of this guide is [Setting up Music Events for Maps](/posts/mapping_music)

## Setting up FMOD
>You do not actually need to complete the steps below to implement QSM. However it is likely you will want to mess with some events if you want to tweak Ambient events. The steps below will tell you how to get it working. 
{: .prompt-info }

Currently the Template has placeholders for the FMOD events - you cannot actually listen to them. If you wish to hear them you will need to:

1. Navigate to `C:\SteamLibrary\steamapps\common\Ready Or Not\ReadyOrNot\Content\FMOD` and copy the `Desktop` folder
2. Within your project folder, paste the `Desktop` folder to `...\RonTemplate\Content\FMOD`

This should be all you need to do to start hearing FMOD events if you press Play.

## Actor Overview
>Any property not listed in the tables below are meant to be private and we shouldn't modify them
{: .prompt-info }

### Ready Or Not Audio Volume
* A Volume that controls FMOD Events when players are in them, it essentially acts as a trigger volume for child/nested events.
* Maps require at least one for Reverb and Ambient Sounds that cover the entire playable space
* ALL FMOD Events should be nested to a Ready Or Not Audio Volume

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
| Reflection Probe | Reference to the Reflection Probe object to be assigned for this specific Room Volume (see below) |

>DO NOT Edit the scale of these. If you require to edit the shape, modify the Volume in Brush Edit mode (Shift+4).
{: .prompt-warning }

### [NEW] Reflection Probe
* A probe placed in the middle of the Room Volume to communicate the center and size of the room to QSM
* There is a Tool available called **EUW_Tool_RoomVolumeHelper** which will automate the process for you
* This is not a requirement but Zack HIGHLY RECOMMENDS IT.

| Property | Description |
|:---|:---|
| Room Size | Approxiate volumetric size of the room - can be auto generated with the Blueprint mentioned above |

### Portal Volume
* These volumes act as portals for QSM to pass through into other rooms. These are specifically placed in doorways, open windows, arches & holes and even managing when glass is broken.

>You will need to use the modified Door Blueprint `BP_Door_Reap_V2_QSM` provided in the download above for door audio to function properly. Not doing so will cause the sound to be muffled on one-side of the door.
{: .prompt-info }

| Property | Description |
|:---|:---|
| Is Outside | Enable if the Portal connects to the outside   |
| Portal Type | Used to determine the direction in which sound will pass through the portal: **HORIZONTAL** for regular use through doors and windows. **VERTICAL** for upward sound direction through a well or hole in the ground. |
| Attached Objects | ~~Add your doors that are within the Volume to this array. **DO NOT ADD TO "Doors"!**~~  WORK-AROUND: Assign the Portal Volume to  `BP_Door_Spawner`'s `Add to Audio Room Portal` |
| Breakable Glass Soft Pointer | Pointer to the Breakable Glass BP the Portal Volume covers. The Breakable Glass BP is located: `Content > ThirdParty > BreakableGlass > Blueprints > BP_BreakableGlass_v01_C`. 1 BP per Portal. |

>DO NOT Edit the scale of these. If you require to edit the shape, modify the Volume in Brush Edit mode (Shift+4).
{: .prompt-warning }

### Sound_ParameterTransition_V2_BP_C Blueprint
* This Blueprint is used to help transition between different FMOD and Reverb states. Specifically used when passing through doors and thresholds into other rooms.
* They can also be used to activate parameters for the music in the game to make it more dynamic.

| Property | Description |
|:---|:---|
| FMOD Ambient / Music Events | Contains the FMOD Events that control the Transitions. For Ambient sound Outdoor-to-Indoor Transitions - choose which map Ambient sounds to go here (will contain `*_Amb` in the file name, eg: `Gas_Amb_V2` |
| INParameter | FMOD Parameter taken from the Amb FMOD Event you added above. You can find these values here: [Reference - FMOD Parameters](){:target="_blank"} |
| OUTParameter | Exactly the same as above, but usually suffix with `OUT` (eg: `GasAmbOUT`) |
| Reverb IN | Select the drop down that best represents the Room Reverb you are moving into |
| Reverb IN Material | Select the drop down that best represents the physical material of the room you are moving into |
| Reverb OUT | Select the drop down that best represents the Reverb in the room you are entering from |
| Reverb OUT Material | Select the drop down that best represents the physical material of the room you are entering from |
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

### [NEW] QSM_Weapon_Reflection_Probe
* Located `Content > FMOD > Events > Levels > Reverbs`
* The best way to describe it is that it's akin to a sound version of a Map's Facade. Its a fake Reverb/Echo probe placed outside the map to mimic where sound would Reverb off of back to the player. 
    * eg: Bouncing off distance large buildings or a neighbours house, Echos/Reverbs from an underpass or cave outside the map, or just a simulated reverb from a large valley or open field
    * These are more artistically placed around the map to give that je ne sais quoi to the echoes

>DO NOT Exceed more than 6 of these probes per map. You may usually need less. 
{: .prompt-warning }

### [NEW] Sound_StarterAmbience_V2_BP_C Blueprint
* Works very similar to the Transition Blueprint above, however is meant to set the starting values for Ambience through *"*AmbSwitch"* when a player loads into a map. It covers the player spawns.

| Property | Description |
|:---|:---|
| FMOD Ambient / Music Events | Contains the FMOD Events that control the Transitions. Mainly for Ambience but OST Timelines can be used as well
| STARTINGParameter | FMOD Parameter taken from the Amb FMOD Event you added above. You can find these values here: [Reference - FMOD Parameters](){:target="_blank"} |
| Starting Global Parameter | Just set this to *"AmbSwitch"* |
| Starting Global Parameter Value | The value of AmbSwitch to be set when a player loads in |
| Starting Reverb | Select the drop down that best represents the Reverb of the starting area |
| Starting Reverb Material | Select the drop down that best represents the make of the materials of the starting area |


## Setting up Audio
> Before beginning, it is **highly** recommended that each one of these steps are done within a folder (or sub-level) within the World Outliner to keep things ordered. In this particular case you should be renaming assets (F2) as you create them to keep things managable.
{: .prompt-tip }

### Part 1 - [NEW] Important Notes about FMOD Events
All FMOD events must follow these 2 guidelines so they work flawlessly in the map:
1. Always Disable `Auto Activate` for all Events
2. Always nest/make events a child of a Ready Or Not Audio Volume

The reasoning is that there are "way too many instances where FMOD for whatever reason stops the audio for certain events since they load before the game initializes" - Zack c. 2024

### Part 2 - Ready or Not Audio Volume and Level Ambience & Reverb
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

### Part 3 - Setting up Room Volumes

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

### Part 4 - [NEW] Setting Up Reflection Probes

1. Go to *Content > Mods > Template > Tools* and right-click and Run the **EUW_Tool_Room_VolumeHelper**
2. Click on `Make/Assign Probes`, it will go through and make and assign probes and place them in their appropriate location to the Volumes they get assigned to.
3. Select all the newly generated Reflection Probes, click on the new Reflection Probes and press `Guess Room Sizes (Selected Probe/s)` in the tool.
4. Thats it! Though I would double check all the assignments just to be safe.

### Part 5 - Setting up Portal Volumes

Portal Volumes (PV) are relatively easier to set up in comparison to Room Volumes and don't require as many special rules

1. Drag a  `Portal Volume` from the actor's tab into the scene.
2. Drag the PV so that it covers the threshold between 2 different Rooms. e.g. Between a doorway or going from an outdoor area to an interior one.
3. Edit the PV in Brush Edit Mode (Shift+4) so that it completely covers the doorframe/window/hole and extends out a little bit. See the picture below for an example:
    * **DO NOT Scale** the PV, they should only be edited via Brush Edit Mode
    * PVs do not need to be exactly the same size as the hole, and it is fine if it is larger or extends wider/higher than the hole that it covers
    * The PV's box needs to be present in both rooms it is creating a Portal for.

![Portal Volume Example](/assets/mapping-audio/PortalVolumeExample.jpg)
 
3. If the PV goes from an exterior/outdoor area into an interior area with Room Volumes, Enable the `Is Outside` property
4. In most cases, leave `Portal Type` to `HORIZONTAL`.
5. If you are using Breakable Glass, set the  `Breakable Glass Soft Pointer` to the corresponding `BP_BreakableGlass_C` Blueprint.
6. If you have doors within your PV, you will need to replace any previous version of that door with the newer version provided in the download above located at `Content > Mods > RareKiwi > BP_Door_Reap_V2_QSM`
     * This contains a workaround that allows us to link the Door and PV together in run-time
7. Select the new Door Actor and within the Door Actor's properties find `Add to Audio Room Portal` and use the eye dropper to select the appropriate PV.
     * Not doing so will cause the door's audio to be muffled on one side of the door when interacting with it.

>Zack recommends to approach doing Portal Volumes by completeing the Outdoor-to-Indoor thresholds first for testing. You will need to make sure that all of these thresholds are covered for QSM to correctly identify the Interior and Exterior areas. 
{: .prompt-tip }

### Part 6 - Setting up Sound_ParameterTransition_V2_BP_C Blueprints

#### Part 6.1 Placing the Transition BP
1. Drag a `Sound_ParameterTransition_V2_BP_C` into the scene, located within the Content Browser at `Content > Blueprints > Sound`.
2. Identify which side of the BP is the `IN` side by **UNSELECTING** the BP and noting down what side the white spline line inside the box is on. The side the line is on is your `IN` direction. 
    * When you select the BP there will be splines on either side.

![Identifying IN and OUT](/assets/mapping-audio/IdentifyingINandOUT.jpg)

3. Rotate the Transition BP appropriately so you know which part of the BP is `IN` & `OUT`
4. You will likely need to resize the BP, but it is imporant that you **DO NOT SCALE** it. To change the size select the `Box Component` of the BP and adjust the `Box Extent` values instead.
    * The size of the box is an artistic choice but note that as soon as a player steps into it, the transitions will begin. So take careful consideration to not place them in areas that do not make sense logically. 
5. The spline values determines the ratio in which the volume of the ambience changes when moving through the BP. You should make sure that if you edit the `Box Component`, you also edit the `Spline Component` points on either end to be WITHIN the `Box Component`
    * You should only need to change the `X` value for the spline point's `Location`

>Transition BP's require different property settings for Outdoor-to-Indoor and Indoor-to-Indoor thresholds. Please read the requirements properly. 
{: .prompt-warning }

#### Part 6.2 Properties for OUTDOOR-to-INDOOR Transitions
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

#### Part 6.3 Properties for INDOOR-to-INDOOR Transitions
1. Select the appropriate reverbs for your rooms for `ReverbIN` & `ReverbOUT`
4. Thats it! You don't need to modify any of the other properties like above. It is actually recommended not to modify anything else as the BP has checks that will mess up audio for smooth Interior transitions.

### Part 7 - [NEW] Breakable Glass

Breakable glass is extremely easy to implement but they need to use Portals to allow sound to allow sound pass through when they're broken.

1. Create a Portal Volume that *tightly* fits the area where the breakable glass will go
2. Drop a `BP_BreakableGlass_v01_C` (located: `Content > ThirdParty > BreakableGlass > Blueprints`) into your scene
    * You can select the Material and Mesh for the Blueprint to use
3. Select the Portal Volume you wish to match with the glass and under `Breakable Glass Soft Point` use the eye-dropper to select the Breakable Glass Blueprint in the scene.
4. If your Breakable Glass crosses the threshold of Indoor-Outdoor (like most windows do), Enable `Is Outside`

### Part 8 - [NEW] Placing down QSM_Weapon_Reflection_Probes
As mentioned in the Actor Overview, these are akin to a sound version of a Map's Facade. It's a fake Reverb/Echo probe placed outside the map to mimic where sound (specifically gunshots) would echo/reverb off of back towards the player. 

Examples: Bouncing off distance large buildings or a neighbours house, echos/reverbs from an underpass or cave outside the map, or just a simulated reverb from a large valley or open field. These are more artistically placed around the map to give it that *je ne sais quoi*. There really isn't a science to it, just where you think some reverb and echoes should come from.

To set them up:
1. Place a `QSM_Weapon_Reflection_Probe` in your map from *Content > FMOD > Events > Levels > Reverbs*.
2. As with all FMOD Events, nest it in a Ready Or Not Audio Volume and Disable `Auto Activate`.
3. That's it!

Some additional notes, Zack mentions you can place up to around 6 probes in your map, but you shouldn't exceed 6. Additionally only 2 probes are active at a time based on proximity to the player. They can be nested in a RoNAudioVolume, but do not need to be physically inside it.

### Part 9 - [NEW] Using the Sound_StarterAmbience_V2_BP_C Blueprint

These work very similar to the Transition Blueprints, however is meant to set the starting values for Ambience through *"*AmbSwitch"* when a player loads into a map. 

1. Place a `Sound_StarterAmbience_V2_BP_C` into your scene and make sure it covers the PlayerStart
    * You do not need one BP per PlayerStart (as one can cover many), but it really should be 1 BP per location
        * Do not just encompass the map in one BP, it should be as localised as possible.
2. The rest of it works the same as a Transition Blueprint, just select the Event to edits and the starting AmbSwitch parameters and values that you wish.


## Tools & Testing

RareKiwi has created a bunch of useful tools to help test and debug QSM and OST Values. All these tools are provided in the Blueprint and Tools folders. 

### BP_AudioPropagationQSMTester

*Content > Mods > Template > Blueprints*

This is a BP that you place anywhere in your level. When you play your level in the game it will constantly fire a gun shot so you can debug and see if QSM is working correctly. 

| Control | Action |
|:---|:---|
| P | Move Here |
| [ (Left Bracket) | Trace there |
| ] (Right Bracket) | Occlusion Type |
| \ (Backslash) | Toggle Active |

>Pressing \ (Backslash) during the mission countdown will crash RoN
{: .prompt-danger }

### BP_AudioSampler

*Content > Mods > Template > Blueprints*

When placed in your level, it allows you to test the effect different FMOD Parameters have on FMOD Events. This is meant to be used within the Editor. You can changed what Event to preview by selecting the `FMODAudio` component in the Details panel. You can use any FMOD Event in here; Timelines, Ambients and regular sound effects!

When you are playing in the editor, the Blueprint will auto-populate the sliders to show what you can edit. However the sliders will not update the audio automatically and you will need press the Play button for each change you make. 

**Example Use:** The FMOD event `Ridgeline_Cicadas` can be controlled by AmbSwitch to lower the volume for entering interior sections. To would be hard to figure out the correct values to use without lots iterative builds, but using the AudioSampler allows us to quickly identify the values needed without leaving the editor.

### EUW_Tool_RoomVolumeHelper

*Content > Mods > Tools*

Used to help keep track and change the Room IDs of Room Volumes. It creates a list of all Room IDs you have and select specific IDs.

### EUW_Tool_ListRoomIDs

*Content > Mods > Tools*

Used to help keep track and change the Room IDs of Room Volumes. It creates a list of all Room IDs you have and select specific IDs.

## What Next? Music!

If you got QSM all set up, you should look at the next part of the guide: [Setting up Music Events for Maps](/posts/mapping_music) to allow you add music to your map and let it react dynamically to combat and other parameters. 
