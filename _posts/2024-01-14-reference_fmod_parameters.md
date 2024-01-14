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

| Parameter Name | [S] or [D] | Description |
|:---|:--:|:---|
| **AgencyMusicIN** | [S] | transitions the music into the inside sections |
| **AgencyMusicQUIET** | [D] | lowers the volume of certain layers |
