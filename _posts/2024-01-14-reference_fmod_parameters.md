---
title: Reference - FMOD Parameters
date: 2024-01-14 00:00:00 +0000
categories: [Reference]
tags: [reference, maps, audio]
description: Reference document for named parameters in FMOD Events to control ambience, music or stings
author: Zack|https://voidinteractive.net/, Delta|https://www.nexusmods.com/readyornot/mods/3072/
---

# Reference - FMOD Parameters

[S] = Static parameter: once it's triggered, it shouldn't be set back to 0. It's a one and done kinda parameter.

[D] = Dynamic paraneter: if x parameter = 1, a layer's volume is brought up, if 0, it's back down again.

## Agency

| Parameter Name | Type | Description |
|:---|:--:|:---|
| AgencyMusicIN | [S] | transitions the music into the inside sections |
| AgencyMusicQUIET | [D] | lowers the volume of certain layers |

## Beachfront

| Parameter Name | Type | Description |
|:---|:--:|:---|
| BeachfrontHOUSEENTER | [D] | transitions the music into the inside sections |
| BeachfrontATTICENTER | [S] | allows the timeline to flow to the piano section |

Two FMOD events, `Beachfront Chimes Spatial` and `Beachfront Flutes Spatial`, can be placed on your map and act as spatial accompaniments

## Club

| Parameter Name | Type | Description |
|:---|:--:|:---|
| MasterZackVolume | [D] | transitions the music to the 'club music turned off' sections |
| ClubOSTRooms | [D] | transitions to a variant of certain layers |
| ClubOSTHalls | [D] | transitions to a variant of certain layers |
| ClubOSTDeep | [D] | transitions to a variant of certain layers |
| ClubOSTSauna | [D] | transitions to a variant of certain layers |
| ClubOSTBodyRoom | [D] | ups the volume on a disturbing layer |

## Coyote

| Parameter Name | Type | Description |
|:---|:--:|:---|
| CoyoteTUNNELSPOTTED | [S] | transitions the music past the intro section |
| CoyoteCAVEDEPTH1 | [S] | transitions further into the music timeline |
| CoyoteCAVEDEPTH2 | [S] | transitions further into the music timeline |
| CoyoteCAVEDEPTH3 | [S] | transitions further into the music timeline |
| CoyoteSIDECAVES | [D] | adds a shaker layer |

## DataCenter

| Parameter Name | Type | Description |
|:---|:--:|:---|
| DataCenter Entered [^nameWithSpace] | [D] | transitions the music into the inside sections |
| AmbSwitch | [D] | changes certain layers coming in, having it go from 1-3 should adjust the intensity |

## Dealer

| Parameter Name | Type | Description |
|:---|:--:|:---|
| DealerEXPMurderRoom | [D] | makes certain layers all distorted |

## Farm

| Parameter Name | Type | Description |
|:---|:--:|:---|
| FarmMusicENTRYAPPROACH | [D] | adjusts the volume of the initial entry choir sound |
| FarmMusicENTRY | [S] | transitions to a sudden drum hit and continues the timeline |
| FarmMusicDRONEINSIDE | [D] | volume for inside drone layer |
| FarmMusicDRONEOUTSIDE | [D] | volume for outside drone layer |
| | | |
| FarmMusicCHURCHAPPROACH | [D] | used when approaching church |
| FarmMusicDRONECHURCH | [D] | volume for church drone / scarier rooms |
| FarmMusicDRONECHURCHCLOSER | [D] | volume for more intense church drone |
| FarmMusicTREE | [S] | triggers the tree stinger and subsequent eerie organ section |
| | | |
| FarmMusicCHURCHAPPROACH | [D] | used when approaching church |
| FarmMusicDRONECHURCH | [D] | volume for church drone / scarier rooms |
| FarmMusicDRONECHURCHCLOSER | [D] | volume for more intense church drone |

## Gas

| Parameter Name | Type | Description |
|:---|:--:|:---|
| GasMainBuilding | [D] | transitions the music past the intro |
| GasSideBuilding | [D] | muffles the music - this is unused in vanilla but still works |
| GasDiegetic | [D] | muffles the music as well, this is used around diegetic music sources |

## Hospital
| Parameter Name | Type | Description |
|:---|:--:|:---|
| HospitalLIGHTSPOTTED | [S] | triggers a light stinger |
| HospitalHEAVYSPOTTED | [S] | triggers a heavier stinger |
| HospitalDEPTH1 | [S] | once triggered, each step advances the timeline further and adds more layers. So the deeper you go through hospital for example, it fires 1 through 4 respectively. |
| HospitalDEPTH2 | [S] | "" |
| HospitalDEPTH3 | [S] | "" |
| HospitalDEPTH4 | [S] | "" |

There are 6 FMOD events that you can place if this music is used, that have synchronized beeps to the music (`Hospital OST Beeps 1 - 6`)

## Importer

| Parameter Name | Type | Description |
|:---|:--:|:---|
| ImporterMusicINSIDE | [D] | transitions the music to the inside sections |
| mporterMusicILLEGALACTIVITYSEEN | [S] | triggers certain lead lines to come in |

## Meth

| Parameter Name | Type | Description |
|:---|:--:|:---|
| AmbSwitch | [D] | 0 = outside sections play, 1 = inside sections play, 2 = outdated laundry section plays, 3 = tunnel section plays |

## Port

| Parameter Name | Type | Description |
|:---|:--:|:---|
| PortCRANEAREALEAFT | [S] | advances timeline past silence |
| PortINTERIOR | [D] | plays interior layer |
| PortWAREHOUSE | [D] | plays warehouse layer |
| PortAUCTION | [D] | plays auction area layer |
| PortAUCTIONDEEP | [D] | plays deep auction layer |
| PortTRAFFICK | [D] | triggers crate section |

## Ridgeline

| Parameter Name | Type | Description |
|:---|:--:|:---|
| AmbSwitch | [D] | 1.5 = triggers basement section |
| RidgelineTOINT | [D] | plays inside layers |

## Sins

| Parameter Name | Type | Description |
|:---|:--:|:---|
| SinsENTRY | [S] | advances timeline past silence |

For this level, there are 6 special spatial events - 5 opera singer events (`Sins Opera Pos 1-5`) and 1 star spangled event (`Sins StarSpangled Spatial`)

## Streamer

| Parameter Name | Type | Description |
|:---|:--:|:---|
| StreamerENTRY | [S] | advances timeline past intro |
| StreamerSERVERROOM | [S] | advances timeline to server section |
| StreamerAGENCYPICSSEEN | [S] | plays agency stinger |
| StreamerROOMENTERED | [D] | lowers volume of certain layers |

There are 2 spatial events, `Streamer Spatial Server A` and `Streamer Spatial Server B`, these play those lil server chirps that sync with the track

## Valley
| Parameter Name | Type | Description |
|:---|:--:|:---|
| ValleyAmbBUNKER | [D] | transitions to bunker section |
| ValleyMusicBUNKERDEEP | [D] | plays disturbing bunker layer |

[^nameWithSpace]: The space is part of the name and not a typo.
