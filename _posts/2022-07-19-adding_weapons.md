---
title: Adding Weapons
date: 2022-07-19 00:00:00 +0000
categories: [UAsset Modding]
tags: [weapon, uasset]
author: "0w0-Yui"
---

# UAsset Editing: Adding New Weapons (WIP)

**Tutorial Provided by 0w0-Yui**
## Requirements

-  [UAssetGUI](https://github.com/atenfyr/UAssetGUI "UAssetGUI")/[Asset Editor](https://github.com/kaiheilos/Utilities "Asset Editor")  (Reccomend use both to get higher efficiency)

- [UModel](https://www.gildor.org/en/projects/umodel "UModel")/[FModel](https://github.com/iAmAsval/FModel "FModel") (Recommend UModel Here, FModel includes bugs will affect the modding)

- python (Optional)

- JSON Viewer (Optional, I use VS Code)

## Getting Start
### Preparations
1. You need a weapon replacement mod first.
2. I will list some definitions before the tutorial start. It will be easier to understand.
3. Save **IDT** and **UI** using UModel "Save selected packages".
4. Navigate to "Game\Blueprints\Items\WeaponRevised", and export the blueprint of the weapon you're replacing. 

| Defined_Name  |  Description |
| :------------------------ | :------------ |
|**IDT**|"Game\Blueprints\DataTables\ItemDataTable.uasset"  |
|**UI**|"Game\ReadyOrNot\UI\Planning\ItemData.uasset"  |
|**WP-BP**|"Game\Blueprints\Items\WeaponRevised"(UAssets Exported from this Location) |
|**AT-BP**|"Game\Blueprints\Items\WeaponRevised"(UAssets Exported from this Location) |
|**Index**| The index of weapon in DataTable. (You will need to come up with your own index to replace the **Index** in the Tutorial, make sure there are no index with the same name in the **IDT**)|


### Understanding How the Blueprint Work

Data include in .uasset, I call it headers
- **Name Map/Header List**: Include all object names used in this Blueprint.
- **Import Data/Linked Class**: To link other file (Blueprint, Model, Skeleton, etc.) to this Blueprint.
- **Export Data/Code Blocks**: Manage external file access to this Blueprint. 

Data include in .uexp
- **Export Data/Block 1**: This is where the data acutally saved.

.uasset point to .uexp, if you rename the file, they will broken. 
The right way is open the editor, and use "save as" to rename.

![Editor Preview](https://raw.githubusercontent.com/QuantumNuke75/Unofficial-Modding-Guide/gh-pages/images/editor_preview.png "Editor Preview")

## Tutorials
1. Close the UAssetGUI open before.
2. Launch the Asset Editor, choose 4.25 at top right. Open **IDT**.
3. Find the weapon you are replacing at "\Code Block\Block 1\DataTable\<WeaponName>", select it at the left side, and export sub (Edit->Export Sub)
4. Choose one method
	- Go to the exported sub open it, rename the "\CoreItem\NameString" and "CoreItem\SubTypeString" to **Index**
	- Import the sub (Edit->Import sub), rename the index at "\Code Block\Block 1\DataTable". (You can skip next step 5 if you choose this method)
