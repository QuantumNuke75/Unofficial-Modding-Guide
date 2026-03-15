---
title: UModel Guide (UE5 Updated)
date: 2026-03-15 00:00:00 +0000
categories: [Tools, Modding]
tags: [umodel, ue5, asset extraction, ready-or-not]
description: Updated guide for using UE Viewer (UModel) with Unreal Engine 5 Ready or Not builds.
author: "AkamiOnTop|https://www.nexusmods.com/profile/AkamiOnTop"
---

## Overview

UModel (also known as **UE Viewer**) is a tool used to view and export assets from Unreal Engine games.

Many older UModel tutorials reference **UE4 builds of the tool**, but **Ready or Not now runs on Unreal Engine 5**, which requires updated UModel builds to properly read asset packages.

This guide explains how to download and use a **UE5-compatible UModel build** to browse and export Ready or Not assets.

---

## Download

Download the UE5 compatible version of UModel.

[Download UE5 UModel Build](https://www.nexusmods.com/readyornot/mods/7328)

The download includes the executable `umodel_materials_ue5.exe`.

---

## Using UModel with Ready or Not

1. Download and extract the executable.
2. Run `umodel_materials_ue5.exe`.
3. When the UModel window opens, click the **"..."** button to browse for the game files.
4. Navigate to the Ready or Not pak directory: `ReadyOrNot\ReadyOrNot\Content\Paks`.

Typical Steam install location:

`C:\Program Files (x86)\Steam\steamapps\common\Ready Or Not\ReadyOrNot\Content\Paks`

5. Select the **Paks** folder and press **OK**.
6. If prompted for an engine version, select **Unreal Engine 5**.

UModel will now load the packages and allow you to browse assets.

---

## Browsing and Exporting Assets

Once packages are loaded you can view assets such as:

- Textures  
- Materials  
- Static Meshes  
- Skeletal Meshes  
- Animations  

To export an asset:

1. Select the asset
2. Click **Export**

Exported assets will appear in a folder named `UmodelExport` created next to the executable.

---

## Common Issues

**Game Not Detected**

Make sure you selected the correct folder: `ReadyOrNot\Content\Paks`.

**Incorrect Engine Version**

If assets fail to load or appear broken, manually select **UE5** when launching UModel.

---

## Credits

UModel created by **Gildor**  
https://www.gildor.org

Guide written by **AkamiOnTop**  
https://www.nexusmods.com/profile/AkamiOnTop
