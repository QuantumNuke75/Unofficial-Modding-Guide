---
title: Quick Cook Setup
date: 2023-01-19 00:00:00 +0100
categories: [Map Modding]
tags: [maps]
description: How to utilise quick cook to speed up game testing iterations.
author: RareKiwi|https://discordapp.com/users/RareKiwi#5360
---

This is a guide to setup and use the quick cook editor scripting widget.  
The widget automates repetitive cooking, copying, paking and starting the game to load a specific level. Also supports separate profiles for maps or mods.
![](/assets/QuickCookHeader.png) 
## Quick Cook Setup:

1. [Download the .zip](/posts/tools/#quickcook--quickmap) containing the widget and python dependencies.  
2. Extract the .zip contents into your UE4 Project's content folder so that you have two sub folders as shown;
	- `.../Content/QuickCook`
	- `.../Content/Python`
3. Restart UE4 if it was open to ensure the new python modules are available.
4. In UE4; Navigate to `/Content/QuickCook/` in the content browser. Then right-click `"QuickCook"` and select `"Run Editor Utility Widget"`  
![](/assets/RunEditorScriptingWidget.png) 
  
5. Fill out the configuration to match your setup for:
	- Project Folder: Should be your covered bones folder etc containing the `.uproject`
	- Staging Folder: Should be the parent of the after-cooking copy folder which you use with UnrealPak.exe to create .paks.
	> This should be the parent folder of your pakchunk99-YOURMOD folder etc.
	- Unreal Engine Dir: Should be where your engine files for UE 4.27 are located.
	- Game Folder: Should be the top directory of your Ready Or Not game installation.  

![](/assets/QuickCookConfig.png) {: .left }  

> This configuration will be saved and loaded automatically to your UE4 Project's directory at;  
>`...\Saved\QuickCook\QuickCook.cfg`
{: .prompt-tip }

> You should add `/Content/QuickCook/` to your "Directories to never cook" in your project settings.
{: .prompt-warning }

## Quick Cook Usage:

> This widget doesn't modify or bypass your project's “Directories to never cook” or "List of maps to include in a packaged build"    
> Therefore, please ensure you have manually cooked, named your staged mod folder and paked it successfully before using this tool.
{: .prompt-danger }

### Profiles:
1. Open your map.  
2. Opening a map will try to load a profile with matching name.  
	- To create your own, under "PAK NAME" enter your staging folder name (i.e. your pak name without .pak)  
	- In the right field enter your map name exactly as seen in the top-left tab or content browser.  
	- Press the `Save` button.
	> Profiles are saved as .ini files in the project's `...\Saved\QuickCook\`  
	{: .prompt-tip }
	![](/assets/QuickCookProfile.png)
3. Add the folders you wish to be synced when pressing the `Copy` button from `...\Saved\Cooked\` to the profile's folder within "Staging Folder"  
Although you can't drag folders from the content browser, you CAN drag an asset within on to the `None` next to "Drag Here to Add" to quickly add their parent folder. ![](/assets/QuickCookFolderAdd.png){: .right }
4. Press `Save`

> Folders are copied relative to `.../Saved/Cooked/WindowsNoEditor/` to allow copying Engine content if needed.  
> The [popular pak.bat](/posts/batchfiles/#pak-to-same-directory) includes `/ReadyOrNot/` which these tools wont work with.  
> To modify an existing staged folder simply make sure your cooked copy of `/Content/` is inside a `/ReadyOrNot/` folder.  
> Eg; `.../pakchunk99-YOURMOD/ReadyOrNot/Content/`  
> To modify your `pak.bat` simply replace `"../../../ReadyOrNot/"` with `"../../../"`
{: .prompt-warning }

> The Copy Button uses the dirsync python command `sync`  
> This syncs folders one way and only if files have changed data rather than by date to increase speed.  
{: .prompt-tip }

### Usage Notes:

- For `Play` to work correctly ensure QuickMap is [installed and configured](#quickmap-setup).
- Check box state and game mode selection state is saved to config, not profile.
- ![](/assets/QuickCookCont.png) ![](/assets/QuickCookStop.png) Check boxes below Copy, Pak and Play allow the tool to continue after the button to the left has finished it's action.  
This let's you in one click, press cook, then (after some time) automatically spawn in your level in game with a chosen gamemode.
- Freemode skips the 10 second game countdown and disables AI. No loadouts are loaded.
- Teleport requires a `/QuickCook/QuickTeleport` blueprint placed in your level. If ticked, it will move your player in Freemode to your UE4 viewport camera's location
- Windowed requires a `/QuickCook/QuickTeleport` blueprint placed in your level. If ticked, it will run `r.SetRes` with the selected options

## QuickMap Setup

Quickmap is an empty level that can be loaded before the game's MainMenu level to enable extra game launch parameter options such as level loading.

1. Download the `pakchunk99-QuickLoad.pak` from [here](/posts/tools/#quickcook--quickmap) or [Nexus Mods](https://www.nexusmods.com/readyornot/mods/2313) or [mod.io](https://mod.io/g/readyornot/m/quickload)
2. If in a .zip, extract it, then copy it your game's pak folder like any other mod.  
	`/Ready Or Not/ReadyOrNot/Content/Paks/`  
3. Open `%localappdata%\ReadyOrNot\Saved\Config\WindowsNoEditor\Engine.ini`
4. Add an empty line then add this override;  
```ini
[/Script/EngineSettings.GameMapsSettings]
GameDefaultMap=/Game/QuickCook/QuickMap.QuickMap
```
5. Save the `Engine.ini`

> Be sure to remove this line, or update QuickLoad after a major update if the MainMenu level name changes.
{: .prompt-tip }