---
title: Getting Started With UAssetGUI
date: 2024-08-19 00:00:00 +0000
categories: [UAsset Modding]
tags: [ue4ss, uassetgui]
description: Getting Started With UAssetGUI
author: "mr eman|https://next.nexusmods.com/profile/eman734/mods, QuantumNuke75|https://www.nexusmods.com/users/62784961"
---

# Getting Started With UAssetGUI

## Introduction

This guide will give you a general overview on how to use UAssetGUI, so that you can edit games files (such as creating cosmetic additions, weapon/attachment mods, in-depth AI mods, and more).

## UAssetGUI Setup

**Download**: [https://github.com/atenfyr/UAssetGUI](https://github.com/atenfyr/UAssetGUI) is the official source for UAssetGUI

> Sometimes the most recent version does not have a full binary release (standalone .exe) download. If you need the absolute most recent version, follow the instructions at the bottom of the page to compile it yourself. After doing so, the .exe and other required files are in `C:/Users/UserName/UAssetGUI/UAssetGUI/bin/Debug/net8.0-windows`. You can copy paste the contents of this folder into elsewhere on your computer if you wish, and run it from there.
{: .prompt-note }

**Download Mappings file:** [Mapping File](/posts/ue4ss_and_mappings/#mappings-download){:target="_blank"}

1. Open UAssetGUI and set the Engine version to `5.3` at the top right drop-down.
	* If you don’t see the current version, then you don’t have the most recent version of UAssetGUI.
2. Go to *Utils > Import mappings...* and select and open the mapping file downloaded from above and give it a name. 
3. Finally next to the drop-down where you set the engine version - select the mapping file you just opened from the drop-down.

## FModel Setup

The first step to modifying cooked assets is to extract them from the game files. The recommended method currently is **FModel** for targeted extractions. 

**Download FModel:** [https://fmodel.app/](https://fmodel.app/){:target="_blank"}

If this is your first time using FModel start from 1, if not skip to 5:

1. Launch FModel, on the window, click the arrows for `ADD UNDETECTED GAME` and select `C:\SteamLibrary\steamapps\common\Ready Or Not\ReadyOrNot` (or the corresponding location in your custom library) as your directory AND press the `+` button.
2. Select the UE Version to be `GAME_UE5_3` and press OK
3. Go to Settings and under *General > Advanced*, Enable `Local Mapping File` and set the `Mapping File Path` to the downloaded Mappings file. (This will allow you to view the cooked content in FModel)
    * Take note of your export "Output Directory"
4. On the Archives Tab, select all the .paks from the game and click Load.
5. Find the asset you wish to modify by navigating through the folders. 
6. Once found, right click on the file name and select `Export Raw Data (.uasset)`.
7. The Console on the bottom of FModel should let you know when the export has completed. Click on the underlined link in the console which takes you to the export directory it saved in.
	* Otherwise just navigate to it as you would usually do for any file.

The asset will have at minimum a `.uasset` file, but it also very likely have a `.uexp` and possibly a `.ubulk file`. These extra files are necessary components for the data storage format that cooked assets use. They must be kept in the same folder and named the same as the corresponding .uasset that they belong to. This applies for editing assets with UAssetGUI, as well as including them in the mod (and ending .pak file) so that the asset works in game.

> It is recommended that you copy and then paste the relevant asset files for the one you are modifying into another directory that you make yourself. This way you can keep a copy of the original for you to fall back onto if you mess up editing your working copy (quite likely when you are starting out). This allows you to avoid having to extract the asset again.
{: .prompt-tip }

## Opening an Asset

To open an asset, drag the .uasset file onto the open UAssetGUI window or do *File > Open* and point it towards the .uasset file.

Once you open the file, there are some potential errors to be aware of:
* If it says ```“System.ArgumentOutOfRangeException”```, then you likely didn’t include the .uexp or .ubulk components of the asset in the folder. 
* If it says ```“File format not recognized”```, then you likely are trying to open something that isn’t a .uasset (the only type that can be opened in UAssetGUI). 
* If it says ```“Failed to parse x export!”``` and then provides a list of assets that it could not access, then it means those assets are not present in the folder/structure you are opening the asset from. It depends on what you are modifying and what you need to do, but sometimes you can ignore the error **if you don’t need to change anything about the export that is broken**. If you do need to change the export that is broken with this error, then you need to extract the referenced asset and place them in the folder structure that the game files use and are expecting.

There are more potential errors, such as ```“Failed to serialize”```, that have various causes. You should not experience this particular error when opening unmodified game assets, as they should only happen when someone has made an error when modifying the asset.

## General File Overview

Once you get in, here is some relevant info on the parts of the file:

* The ```Name Map``` is a registry of sorts for data within your file. This is used on the back-end of your file to know what goes into certain entries. The items here can be changed, and it will change the corresponding items elsewhere in the file automatically (do so with caution).
* The ```Import Data``` is a list of references to parts of other things (other assets or C++) that your file needs to work. You don’t need to include these in your mod unless it is part of the list of assets that GUI specifically requests, and is one you need to modify. The import list can be added to in order to facilitate referencing more game assets (such as using more models). To do so, follow the formatting of similar imports. This may be 1-3 separate entries on the list.
* The ```Export Data``` is the list of data stored within your file, where it has properties that the game uses. This is where you will be doing most of the modding.  Every asset is different, so have a look around. Not everything you might want can be changed, but some of the exposed data can be changed, added to, or redirected to change what the asset does (to a degree).
   
## Modifying Entries

General guidelines for modifying entries in the file:

* Double click on an entry to modify it. Press tab to confirm and move to the right, or enter to confirm and move down.
* Number swaps are the easiest thing to do. Do note that the same value (that you need to change) may appear in more than one location, it just depends on the asset.
* If you are trying to change references to other assets within your asset (example of a model swap), it is usually better to change the references on the name map (which it will most likely be on). Such a reference will have an entry for the file name itself, plus one for the file-path as a whole. Both need to be changed accordingly to what you need. After saving and reloading the file, all references to these will be changed elsewhere in the file.
* The reference to "/Game/..." in file-paths is equivalent to the "Content" folder in the game files. This is a carryover of how UE works in general.
* Not every entry on an export may do things. RoN has many artifacts of development that may or may not have been used at some time, but no longer do anything. There is no way to tell unless someone tells you, or you try yourself.
* It is recommended that you press `Enter` to confirm that you are done editing after finishing on a row. It is unknown if it is necessary, but sometimes edits have not saved properly if Enter was not pressed.
* Make sure you are spelling and capitalizing, as well as using symbols correctly. The game is expecting very specific rules, so you need to match what it wants. File names may not be internally consistent, so be diligent when typing. Copy paste works from within the text boxes, so you can use it.
* If you are having difficulty understanding an asset, you can also use FModel for reference on assets. It will show most of the things on the exports list, although they may not be formatted the same or in the same order. But it may be more readable for you than UAssetGUI.
* ***VERY IMPORTANT: follow the formatting that similar entries use***. The game/another file is expecting things to be a certain way, so give it what it is looking for. Free-forming entries will likely result in an error, or the file not working. *The order that things appear (or the lack thereof) in columns on an entry is important.*

## Saving

* Once you are done modifying the file, do *File > Save*. If it gives you an error here, it most likely did not save. You will need to address the error before it will let you save. 
	* *It is not possible to list all potential errors as they can change depending on version and what is wrong with the file.*
* When you are able to save, be sure to try to re-open the file again. If it gives a new error, then something is wrong with the file, and it will most likely not work in game. You may have modified something wrong or made a bad reference.
* All components of the file (.uasset and possibly .uexp and .ubulk) need to be included in the .pak for your mod. Don't forget to copy them over when doing that.

> By default, UAssetGUI is set to create .bak files when you save. These are just archived versions of the previous version (when the file was opened or from before the most recent save). To be able to use them again, just edit the filename to remove ".bak" and they will work as normal. You can also disable this feature as a whole in the settings in *Edit > Settings*. Including these in your mod will have no effect, but it is doubling the file size of the assets you modified.
{: .prompt-info }

## Using JSON

> This section describes an optional feature, which is (at least at the time of writing) not required.
{: .prompt-info }

UAssetGUI has the capability to save the file to UAssetAPI JSON (UAssetAPI is a foundation that UAssetGUI is built on). You can do this as an alternative to editing one entry at a time in UAssetGUI, or for large changes. 

Notepad++ or Visual Studio Code, with some good plugins for JSON and the ability to compare files is ***(very useful for inspecting other mods to see what they changed).***

As the UAssetGUI software and game engine changes, it may or may not become necessary to use JSON to make certain changes.

As always, follow formatting for similar entries if you want things to work. You can consult similar asset files (from the game or mods) to get a more comprehensive idea of what to do. 

**Any error at all in JSON formatting will likely break the file upon trying to import it back into UAssetGUI**, and it may not be obvious why.

### Adding Data  

*The following was written by [QuantumNuke75](https://www.nexusmods.com/users/62784961) on how to use the JSON formatting to modify files:*

This can be a very complicated portion of modding. **Make sure to read all of this very carefully.** This section will be specific in what to do and what to not do, but will not explain everything, as each file can be a little different. As long as you make sure the imports are correct and that you added the data correctly, the file should work.

1. Open the UAsset file in UAssetGUI.
2. Export the JSON file, and open that file in a text editor of your choice. I would suggest using Notepad++ and the `JSON Parser` plugin. This will let you auto-format the JSON file. 
3. When adding data, you'll need to copy and paste whatever data you're trying to add more of. If if this is a new item in `ItemDataTable.uasset`, then you'll need to copy another item in the datatable. Copy and paste whatever you would like to duplicate into the correct location. Keep in mind all of the commas and brackets.
4. If you see a negative number that doesn't correlate to coordinates, or scale, or rotation, this is an import reference.  
	- If you open `Import Data` located in the left pane of UAssetGUI, you'll see a bunch of negative numbers in the first column and other data stored in rows. This is the  	  portion of the file that contains all the references and imports the file uses. Also within this file, you'll see a column label called `OuterIndex`. This column will also contain a bunch of negative nunber and 0s. The 0s indicate that the row is not a child of another row. If this row contains a negative number within that column, then that row depends on another dependency. You can find this dependency as you would any other import, locatin the row with said negative number.  
	- When adding a reference from the game, it's a good idea to copy and paste similar references and then change the strings slightly. This ensures that you will retain the correct formatting. You can add this reference either in the JSON file or in UAssetGUI. Both are better in different scenarios. If you're going to add a bunch of imports, use the JSON file, otherwise use UAssetGUI.
5. Save the JSON file with all your edits and open that JSON file in UAssetGUI. If you get an error, you messed up the JSON formatting.
6. If you have made all your data additions and made sure to have the proper imports (you may need to import multiple times for just one thing), then the mod should work. You can tell if it's working if the game does't freeze or crash on launch (wait until the intro screen ends). If this occurs there is a high chance you messed up something with the imports.

## Ask For Help!

UAssetGUI is a complex thing to work with. You will likely have some learning curve issues if you are doing anything beyond an easy number change. The Ready Or Mod server (https://discord.gg/9AHSaF6dNM) has a tech-support channel where someone can answer questions you may have, about UAssetGUI or other aspects of modding. 

Otherwise, hopefully elsewhere on this site will have something that will help you out on other aspects of making mods for RoN.