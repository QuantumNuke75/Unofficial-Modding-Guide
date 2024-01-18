---
title: Reference - FMOD Parameters
date: 2024-01-14 00:00:00 +0000
categories: [Reference]
tags: [reference, maps, audio]
description: Reference document for named parameters in FMOD Events to control ambience, music or stings
author: Zack|https://voidinteractive.net/, Delta|https://www.nexusmods.com/readyornot/mods/3072/
---

# Reference - FMOD Parameters

The following tables list the different parameters to use with the Sound_ParameterTransition_V2_BP_C Blueprint to modifier Ambient and Music queues within your level.

**[D] = Dynamic parameter**: if x parameter = 1, a layer's volume is brought up, if 0, it's back down again. You can transition between these parameters freely.

**[S] = Static parameter**: once it's triggered, it shouldn't be set back to 0. It's a one and done kinda parameter. You cannot go backwards on the music timelines once these are called

## Agency

### Ambience: *Agency_Amb*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| AgencyAmbIN | [D] | |
| AgencyAmbOUT | [D] | |
| AgencyAmbSTORE | [D] | |
| AgencyAmbWAREHOUSE | [D] | |
| AgencyAmbWAREHOUSECOVER | [D] | Muffles warehouse ambience. |
| AgencyClothesRain | [D] | Rain on clothes volume. |
| AmbSwitch | [D] | Muffles rain ambience depending on amount, 0 = unmuffled, 1 = muffled, etc. |
| AgencyExtEventsPlay | [D] | This is automated by AmbSwitch, do not change. |

### Music: *Main_Agency_Timeline*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| AgencyMusicIN | [S] | transitions the music into the inside sections |
| AgencyMusicQUIET | [D] | lowers the volume of certain layers |

## Beachfront

### Ambience: *Beachfront_Amb*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| BeachfrontAmbHOUSE | [D] | House ambience |
| BeachfrontAmbHOUSEDEEP | [D] | Deeper house ambience |
| BeachfrontAmbOUT | [D] | Outside ambience |

### Music: *Main_Beachfront_Timeline*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| BeachfrontHOUSEENTER | [D] | transitions the music into the inside sections |
| BeachfrontATTICENTER | [S] | allows the timeline to flow to the piano section |

Two FMOD events, `Beachfront_Chimes_Spatial` and `Beachfront_Flutes_Spatial`, can be placed on your map and act as spatial accompaniments

## Campus

### Ambience: *Campus_Amb*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| CampusAmbBATHROOM | [D] | |
| CampusAmbCL1 | [D] | |
| CampusAmbCL2 | [D] | |
| CampusAmbHALL1 | [D] | |
| CampusAmbHALL2 | [D] | |
| CampusAmbLECTURE | [D] | |
| CampusAmbLIBRARY | [D] | |
| CampusAmbOUT | [D] | |
| CampusAmbROOMSMALL | [D] | |

### Music: None available.

## Club

### Ambience: *Club_Amb_V2*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| ClubAmbBAR | [D] | |
| ClubAmbBIG | [D] | |
| ClubAmbDEEP | [D] | |
| ClubAmbMAIN | [D] | |
| ClubAmbMETAL | [D] | adds an eerie metal layer over the ambience, like metal clangs.

### Music: *Main_Club_Timeline*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| MasterZackVolume | [D] | transitions the music to the 'club music turned off' sections |
| ClubOSTRooms | [D] | transitions to a variant of certain layers |
| ClubOSTHalls | [D] | transitions to a variant of certain layers |
| ClubOSTDeep | [D] | transitions to a variant of certain layers |
| ClubOSTSauna | [D] | transitions to a variant of certain layers |
| ClubOSTBodyRoom | [D] | ups the volume on a disturbing layer |

## Coyote

### Ambience: *Amb_Coyote*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| CoyoteAmbBARN | [D] | |
| CoyoteAmbCAVE | [D] | |
| CoyoteAmbGARAGE | [D] | |
| CoyoteAmbHOUSE | [D] | |
| CoyoteAmbOUT | [D] | |
| CoyoteAmbROOM | [D] | |
| CoyoteAmbTUNNEL | [D] | |
| CoyoteWINDVOL | [D] | this controls the volume of the exterior wind. No changes needed. |

### Music: *Main_Coyote_Timeline*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| CoyoteTUNNELSPOTTED | [S] | transitions the music past the intro section |
| CoyoteCAVEDEPTH1 | [S] | transitions further into the music timeline |
| CoyoteCAVEDEPTH2 | [S] | transitions further into the music timeline |
| CoyoteCAVEDEPTH3 | [S] | transitions further into the music timeline |
| CoyoteSIDECAVES | [D] | adds a shaker layer |

## DataCenter

### Ambience: *Data_Center_Amb*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| DataAmbINT | [D] | |
| DataAmbINTCOVER | [D] | Muffles inside ambience |
| DataAmbKITCHEN | [D] | |
| DataAmbOUT | [D] | |
| DataAmbSERVER | [D] | |
| DataAmbSERVERCOVER | [D] | Muffles server room ambience |
| AmbSwitch | [D] | referenced but not used |

### Music: *Main_Data_Center_Timeline*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| DataCenter Entered [^nameWithSpace] | [D] | transitions the music into the inside sections |
| AmbSwitch | [D] | changes certain layers coming in, having it go from 1-3 should adjust the intensity |

## Dealer

### Ambience: *Dealer_Amb_V2*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| DealerAmbACHUM | [D] | AmbSwitch muffles this value if set to 2 |
| DealerAmbBIGROOMHUM | [D] | |
| DealerAmbBOILERROOM | [D] | |
| DealerAmbMAINROOMHUM | [D] | AmbSwitch muffles this value if set to 2 |
| DealerAmbOUTSIDE | [D] | AmbSwitch muffles this value if set to 1 |
| AmbSwitch | [D] | see above for descriptors on what ambswitch does to each |

### Music: *Main_Dealer_Timeline_V2*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| DealerEXPMurderRoom | [D] | makes certain layers all distorted |

## Farm

### Ambience: *Farm_Amb_V3*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| FarmAmbCELLAR | [D] | |
| FarmAmbCHURCH | [D] | |
| FarmAmbGRHOUSE | [D] | |
| FarmAmbHOUSE | [D] | |
| FarmAmbOUT | [D] | |
| FarmAmbOUTCOVER | [D] | Muffles exterior ambience |
| FarmAmbSTAIRS | [D] | |
| FarmAmbWOODS | [D] | |

### Music: *Main_Farm_Timeline*

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

### Ambience: *Gas_Amb_V2*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| GasAmbIN | [D] | |
| GasAmbINCOVER | [D] | Muffles inside ambience |
| GasAmbOUT | [D] | AmbSwitch lowers reverb volume for certain sounds within the ambience... Not sure... why. Oopsies. |

### Music: *Main_Gas_Timeline*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| GasMainBuilding | [D] | transitions the music past the intro |
| GasSideBuilding | [D] | muffles the music - this is unused in vanilla but still works |
| GasDiegetic | [D] | muffles the music as well, this is used around diegetic music sources |

## Hospital

### Ambience: *Hospital_Amb_V2*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| HospitalAmbDEEP | [D] | if AmbSwitch < 3, this ambience is muffled |
| HospitalAmbINT | [D] | if AmbSwitch < 3, this ambience is muffled |
| HospitalAmbMORGUE | [D] | |
| HospitalAmbOUT | [D] | |

### Music: *Main_Hospital_Timeline*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| HospitalLIGHTSPOTTED | [S] | triggers a light stinger |
| HospitalHEAVYSPOTTED | [S] | triggers a heavier stinger |
| HospitalDEPTH1 | [S] | once triggered, each step advances the timeline further and adds more layers. So the deeper you go through hospital for example, it fires 1 through 4 respectively. |
| HospitalDEPTH2 | [S] | "" |
| HospitalDEPTH3 | [S] | "" |
| HospitalDEPTH4 | [S] | "" |

There are 6 FMOD events that you can place if this music is used, that have synchronized beeps to the music (`Hospital_OST_Beeps_1 - 6`)

## Importer

### Ambience: *Imp_Amb*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| ImporterToBathroom | [D] | |
| ImporterToConveyor | [D] | |
| ImporterToPost | [D] | |
| ImporterToRoomA | [D] | |
| ImporterToRoomB | [D] | |
| AmbSwitch | [D] | AmbSwitch is used to lower the exterior ambience volume for this level. 0 = full volume, 1 = silent. |

### Music: *Main_Importer_Timeline*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| ImporterMusicINSIDE | [D] | transitions the music to the inside sections |
| mporterMusicILLEGALACTIVITYSEEN | [S] | triggers certain lead lines to come in |

## Meth

### Ambience: *Meth_Amb_V2*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| MethAmbLAUNDRY | [D] | |
| MethAmbSTREETINT | [D] | AmbSwitch is used to change between inside / outside ambiences. 0 = exterior, 1 = interior. |
| MethAmbTUNNEL | [D] | |
| MethOutdoorEventsPlay | [D] | AmbSwitch automates this. Don't change. |

### Music: *Main_Meth_Timeline_V2*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| AmbSwitch | [D] | 0 = outside sections play, 1 = inside sections play, 2 = outdated laundry section plays, 3 = tunnel section plays |

## Penthouse

### Ambience: *Penthouse_Amb_V2*

| Parameter Name | Type | Description |
|:---|:--:|:---|
PenthouseAmbBALCONY | [D] | |
PenthouseAmbHALL | [D] | |
PenthouseAmbROOMS | [D] | |
PenthouseAmbSTAIRWELL | [D] | |

### Music: *Main_Penthouse_Timeline_V2*

*No Parameters to edit.*

## Port

### Ambience: *Port_V2_Amb*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| PortAmbAUCTION | [D] | |
| PortAmbCONTAINER | [D] | |
| PortAmbOUT | [D] | |
| PortAmbOUTCOVER | [D] | muffles exterior ambience |
| PortAmbRAINCLOTHES | [D] | Rain on clothes volume. |
| PortAmbSHACK | [D] | |
| PortAmbTOWER | [D] | |
| PortAmbTOWEROUT | [D] | |
| PortAmbTRAFFICKINGCONTAINER_SFX | [D] | muffles all ambiences if value is 1. |
| PortAmbWAREHOUSE | [D] | |
| PortAmbWAREHOUSEDEEP | [D] | Muffles warehouse ambience. |

### Music: *Main_Port_Timeline_V2*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| PortCRANEAREALEAFT | [S] | advances timeline past silence |
| PortINTERIOR | [D] | plays interior layer |
| PortWAREHOUSE | [D] | plays warehouse layer |
| PortAUCTION | [D] | plays auction area layer |
| PortAUCTIONDEEP | [D] | plays deep auction layer |
| PortTRAFFICK | [D] | triggers crate section |

## Ridgeline

### Ambience: *Ridgeline_Amb*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| AmbSwitch | [D] | controls the ambience on this map. 0 = exterior, 1 = interior.|

### Music: *Main_Ridgeline_Timeline*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| AmbSwitch | [D] | 1.5 = triggers basement section |
| RidgelineTOINT | [D] | plays inside layers |

## Sins

### Ambience: *Sins_Amb*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| SinsAmbBAR | [D] | |
| SinsAmbBATHROOM | [D] | |
| SinsAmbCLOTHESRAIN | [D] | rain on clothes volume. |
| SinsAmbHALL | [D] | |
| SinsAmbKITCHEN | [D] | |
| SinsAmbLOBBY | [D] | |
| SinsAmbLOUNGE | [D] | |
| SinsAmbOUT | [D] | |
| SinsAmbROOM | [D] | |

### Music: *Sins_Club_Timeline*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| SinsENTRY | [S] | advances timeline past silence |

For this level, there are 6 special spatial events - 5 opera singer events (`Sins_Opera_Pos_1 - 5`) and 1 star spangled event (`Sins_StarSpangled_Spatial`)

## Station

### Ambience: *StationV2_Amb*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| StationAmbBASEMENT | [D] | |
| StationAmbBASEMENTBIG | [D] | |
| StationAmbHONOUR | [D] | |
| StationAmbIN | [D] | |
| StationAmbOFFICE | [D] | |
| StationAmbOFFICE2 | [D] | |
| StationAmbOUT | [D] | |
| StationAmbRANGE | [D] | |
| StationAmbROSTER | [D] | |

### Music: *Main_Station_Timeline*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| LobbyMusicKILLHOUSE | [D] | |
| LobbyMusicLOADOUT | [D] | |
| LobbyMusicMEMORIAL | [D] | |
| LobbyMusicMEMORIALSTATUE | [D] | |
| LobbyMusicMISSIONSELECT | [D] | |
| LobbyMusicMORALE | [D] | |
| LobbyMusicOUTSIDE | [D] | |
| LobbyMusicRANGE | [D] | |
| LobbyMusicREADYROOM | [D] | |
| LobbyMusicSELECT | [D] | |
| LobbyMusicSELECTED | [D] | |
| LobbyMusicUNDER | [D] | |
| LobbyMusicVOLUME | [D] | |
| Lobby_Ready | [D] | |

>A lot of these parameters for the Station OST are set in code, so be cautious if you decide to use these...
{: .prompt-warning }

>Fun fact with the station OST, depending on how far through the campaign you are, if you go into the memorial room, there's a horn section layer that plays spatially if you go straight to it when loading in. You might have to wait a few seconds to hear it
{: .prompt-info }

## Streamer

### Ambience: *Streamer_Amb*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| StreamerAmbAPARTMENT | [D] | |
| StreamerAmbBATHROOM | [D] | |
| StreamerAmbIN | [D] | Ambswitch lowers volume. 0 = full volume, 1 = lower volume. |
| StreamerAmbMINING | [D] | |
| StreamerAmbOUT | [D] | Ambswitch lowers volume. 0 = full volume, 1 = lower volume. |

### Music: *Main_Streamer_Timeline*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| StreamerENTRY | [S] | advances timeline past intro |
| StreamerSERVERROOM | [S] | advances timeline to server section |
| StreamerAGENCYPICSSEEN | [S] | plays agency stinger |
| StreamerROOMENTERED | [D] | lowers volume of certain layers. If AmbSwitch <= 1.35, this value will be 0. If AmbSwitch >= 2, this value will be 1. |
| StreamerMAINROOM | [D] | changes volume of certain layers. |

There are 2 spatial events, `Streamer_Spatial_Server_A` and `Streamer_Spatial_Server_B`, these play those lil server chirps that sync with the track

## Training

### Ambience: *Training_Amb_V2*
| Parameter Name | Type | Description |
|:---|:--:|:---|
| AmbSwitch | [D] | If AmbSwitch > 0, the sound becomes muffled |

### Music: None available.

## Valley

### Ambience: *Valley_Amb_V2*

| Parameter Name | Type | Description |
|:---|:--:|:---|
ValleyAmbBUNKER
ValleyAmbEXT
ValleyAmbINT | [S] | Ambswitch > 1 muffles this layer. |

### Music: *Main_Valley_Timeline_V2*

| Parameter Name | Type | Description |
|:---|:--:|:---|
| ValleyAmbBUNKER | [D] | transitions to bunker section |
| ValleyMusicBUNKERDEEP | [D] | plays disturbing bunker layer |

[^nameWithSpace]: The space is part of the name and not a typo.
