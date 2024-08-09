---
title: Setting up Music Events for Maps
date: 2024-01-14 00:00:00 +0000
categories: [Map Modding]
tags: [maps, audio]
description: An in-depth guide on setting up event queues to dynamically change the music in your map. 
author: Delta|https://www.nexusmods.com/readyornot/mods/3072/, Zack|https://voidinteractive.net/, 
---

# Setting up Music Events for Maps

>[Setting up Audio and Working with QSM for Maps](posts/mapping_audio) is REQUIRED knowledge for this page. Please read it before continuing.
{: .prompt-danger }

## Introduction

This guide will step you through the requirements to get music implemented into your game. It will also discuss how to use the more dynamic elements of the OST to make your levels feel much more polished. 

There is an Example map provided in the Community Mapping Framework that demonstrates the use of the OST and some of the additional actors you can use with it.

## Level Blueprint Setup
 
For music to react dynamically to combat, the bare minimum you need to do is to set it up in the Level Blueprint. 

1. Open the Level Blueprint for you main Level
2. Click on the `Class Defaults` button at the top and under details panel locate `Ready or Not Level Script > Level Data > Music Data`
3. In `Music Data` assign the Data Asset for the music you wish to use for you level. These are located at `Content > ReadyOrNot > Data > Music`
4. Click Compile and Save. You can close the Blueprint and next time you play your Level, it should play the music assigned and dynamically change when you enter combat!

>If you just want some general music in your level to react to combat, this is all you need! You do not need to implement the complex sections below to get music working.
{: .prompt-tip }

## Controlling the OST

>The information here is very nuanced and hard to explain. Not many people have worked with this, so information and support is limited. The info below should give you a general understanding of the concepts needed to start tinkering with it, but it is not comprehensive. The main bulk of information comes from Zack and he is the person to talk to if you have a specific question about the interactions.
{: .prompt-warning }

If you want to take full advantage of the OST of the game, you will need to leverage the `Sound_ParameterTransition_V2_BP_C` Blueprint (**T-BP** from here on) to control FMOD Parameters. This is pretty much the only actor needed to control the OST.

>ALL the values and parameters you will need are documented here: [Reference - FMOD Parameters](/posts/reference_fmod_parameters)
{: .prompt-info }

The OST Timelines are different for each map. Depending on the map chosen, you may need to adjust the timeline in different ways. 

There are generally 2 ways to do this:

1. As simple named Parameter with no values
    * These require you to add the Level's music timeline to the `FMOD Ambient / Music Events` array of existing T-BP for Ambients/Doors or used by themselves on a dedicated T-BP. You then add the Parameter name to the `INParameter`/`OUTParameter` of said element.
        * e.g. Just like you would for `GasAmbIN` or `GasAmbOUT` for Ambient Events.
    * These events do not need anything special to be done to them and will advance the OST timeline on the corresponding IN/OUT side of the T-BP.
    
2. Controlled by _AmbSwitch_
    * If a Parameter is controlled by _AmbSwitch_, you do not need to add the music timeline to the `FMOD Ambient / Music Events` of the T-BP, only `FMOD Global Parameter` needs to be set to "_AmbSwitch_".
    * These are typically used for when you are going deeper into a structure and things need to get muffled. Most of these are dynamic and have values that can be used between 0-3 depending on the map and generally match up with the same level's Ambient Event.
    * If you are using a Music Timeline and Ambient Event from different maps, you will likely encounter weird behavior. In these cases it's recommended to use 2 separate T-BPs in the same spot with different values for _AmbSwitch_ to avoid conflicts.

Up until this point, the T-BP has just been used for controlling the ambient sounds when you enter through doors, however you can use T-BPs as ways to section off zones and you can be a little more fluid with their size and placement. Not all areas are cut+paste rooms with door thresholds, sometimes we have open areas (think Farm) that need to advance the timeline when players pass a certain threshold.

The example map provided does this, In the picture below, I have selected 4 different T-BP with the same variables but have been arranged to form a zone the player can't avoid if they wish to pass. It affectly makes it so when you pass the blue line (visual representation) from any location, the timeline will progress. In this case it triggers the `StreamerENTRY` parameter on the IN side of the T-BP. 

You may want to use a method similar to this if you have a map with multiple spawn locations that eventually converge to the same locations. This is what was done in Hospital. Players can start on different sides of the map, but the timeline will progress the same no matter which spawn they choose as they progress deeper into the map. Regardless of where they start or end, the timeline will hit the same beats as the T-BPs have been set up to activate equally on either side as they cascade deeper into the structure. 

## Sound_LookAtParameterTrigger_BP_C

This is a blueprint that plays a sting when you look at a specific location. It was used in the game for musical stings when players looked at _those photos_ in Streamer, or Blood/Bullet holes in Hospital. These events will ONLY work on those timelines and you cannot mix-and-match them. They are usually static events (only played once and cannot be trigger again).

The following maps have events that are compatible with the Music Timelines:
* Streamer
* Hospital
* Dorms

| Property | Description |
|:---|:---|
| FMOD Event to Change | Chuck the timeline you are using in here  |
| FMOD Parameter to Change | Self explanatory. eg: For Streamer, you would play `StreamerAGENCYPICSSEEN` to activate the sting |

DO NOT Edit the scale of these or any of their components! If you require to edit the shape - modify the Box's `Box Extent` or LookAtTrigger's `Sphere Radius` .
{: .prompt-warning }

## Sound_MusicParameterChanger_BP_C

This blueprints acts as a way to dynamically change some specific Timeline parameters as players get closer or further away from them. eg: Muffling the Timeline when the player gets closer to the Jukebox in Gas, you can hear the Jukebox music clearer.

| Property | Description |
|:---|:---|
| Radius | Self-explanatory  |
| Event | The Timeline event to modify |
| Parameter Name | Parameter name to edit. eg: In Gas it would be `GasDiegetic` |
| Indoor / Outdoor Check | If the change needs to take into account being inside or outside |
| Amb Switch Min Value To Check | Self-explanatory |
| Amb Switch Max Value To Check | Self-explanatory |
