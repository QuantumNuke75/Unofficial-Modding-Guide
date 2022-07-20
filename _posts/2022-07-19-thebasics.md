---
title: The Basics
author: QuantumNuke75
date: 2022-07-20 00:00:00 +0000
categories: [General Information]
tags: [essential, batch]
pin: true
description: The basics of modding for Ready or Not. Covers extracting game files, the game's file structure, file formats, cooking files, and creating .pak files.
---

## Important Information

### Understanding the File Structure  
When creating a project in Unreal Engine 4, the project will be saved to a directory. Within that directory will be the project. For example: `<SaveDirectory>/<ProjectName>/…`. `<ProjectName>` houses all of the contents of the Unreal Engine 4 project. In that project folder, there will be a subfolder named `Content`. That folder houses all of the assets and blueprints within a game.

In the case of Ready or Not, the project name is `ReadyOrNot`. Within that folder, there is a folder called `Content`. Again, this houses everything inside a game except for configuration files. However, when you open the game files in UModel, there may not be a `Content` folder, instead, it’ll have been replaced with a `Game` folder. When .paking your mod, you should replace `Game` with `Content`. Any of the sub folders will remain the same.

The majority of the modding that you will do will be under the `Content` folder. If a file that you are looking to override is in `.../ReadyOrNot/Game/ReadyOrNot/Assets/Weapons/Python`, the file path to copy would be `.../Content/ReadyOrNot/Assets/Weapons/Python`.

> Failure to copy the exact path of Ready or Not will result in a broken mod.
{: .prompt-danger }

### File Formats  
There are multiple different file formats that you may encounter while modding. Here is a list of most of them, and what each of them are.
- **.psk** - A skeletal or static mesh. May contain the skeleton.
- **.psa** - An animation for a specific mesh.
- **.uasset** - Two types.
  1. Raw .uasset files are the ones created after cooking a UE4 project. 
  2. UE4 .uasset files are the ones that are taken directly from a UE4 project, they are uncooked and can be transferred between projects.
- **.uexp** - An raw complementary file to uassets, usually containing import and export maps.
- **.ubulk** - Another data storage file that UE4 uses. 
- **.umap** - A level/map file, similar to .uasset in the way that there is an uncooked and cooked version.

  
  
## Essentials

### Extracting Game Files  
There are two methods of extracting games files, both have important differences:
1. [UModel](https://unofficial-modding-guide.com/posts/tools). This program can extract non-raw files, allowing you to gain access to textures, models, and animations. To use it, direct it towards the location of the .pak files within Ready or Not: `<GameInstallLocation>\Ready Or Not\ReadyOrNot\Content\Paks`. You'll be able to extract individual assets once loaded.
2. Manual unpaking. This can be done simply by setting up an unpak batch script. 
	1. Create a .bat file in your UnrealPak install location (located within your Unreal Engine 4 install), usually `<InstallLocation>\UE_4.27\Engine\Binaries\Win64\UnrealPak.exe`.
	2. In the .bat file, paste the following lines in and save:
	```batch
	@if "%~1"=="" goto skip
	@setlocal enableextensions
	@pushd %~dp0
	.\UnrealPak.exe %1 -extract "%~n1"
	@popd
	@pause
	:skip
	```
	3. Drag the .pak file you want to unpak, for example `pakchunk0-WindownNoEditor_0_P`, directly onto the .bat file you just created.  This will extract the pak's files in the same location as the batch file.

### Cooking Modified Files  
In order to override any assets within the game or add new content, the files must be in a format that the game can recognize. The files you extracted via UModel will be in a format that is easily accessible by you, not the game. You will first need to cook these before PAKing the files.

1. Install the latest version of Unreal Engine 4.27. The current latest version is 4.27.2.
2. Import all the files you want to pack with your mod into a new blank project. Any other template can work, but will result in significantly longer cooking times.
3. Go to `File > Cook Content for Windows`. This converts the files into a UE4 exported format (\*.uasset, \*.uexp, \*.ubulk). Retrieve the cooked files in `<ProjectLocation/><ProjectName>/Saved/Cooked/WindowsNoEditor/`.

### Creating a PAK File  
1. Make sure the folder you are paking, for example `pakchunk99-Mods_MyMod_P`, contains the same file structure as Ready or Not. The number after `pakchunk` indicates the load order of the .pak. Make sure to understand the directory structure first, before paking your mod. Incorrect directory structure will lead to issues. Your structure should mimic something like this: `pakchunk99-Mods_MyMod/Content/ReadyOrNot/Assets/…`.
2. Create a .bat file in your UnrealPak install location (located within your Unreal Engine 4 install), usually `<InstallLocation>\UE_4.27\Engine\Binaries\Win64\UnrealPak.exe`.
3. In the .bat file, paste the following lines in and save:
```batch
@if "%~1"=="" goto skip
@setlocal enableextensions
@pushd %~dp0
@echo "%~1\*.*" "../../../ReadyOrNot/" >filelist.txt
.\UnrealPak.exe "%~1.pak" -create=filelist.txt -compress
@popd
@pause
:skip
```
4. Drag the folder you want to PAK, for example `pakchunk99-Mods_MyMod_P`, directly onto the .bat file you just created.  This will create a .pak file in the same directory as the folder you just dragged.

> If the .pak file size is 1 KB, change the locations of the contents you are attempting to pak.
{: .prompt-warning }


## Additional Information

### Mod Installation  
All .pak mods go here. `<GameInstallLocation>\Ready Or Not\ReadyOrNot\Content\Paks`. Ensure that the .pak load order is correct.

### Example Mod  
To see if your PAKing is working, download this [example mod](https://drive.google.com/file/d/1iSbu8JqFbry1lioBEIuB5ks0D8bhKQ7c/view?usp=sharing). This will turn your gun on the main menu pink if the .pak is correctly PAKed. Download and extract the .zip file before PAKing. 

### Debugging  
If your mod is not working, make sure to check these common error points:
- Check the file strucuture. This must perfectly match the files within the game, otherwise it will not load.
- No `_P` at the end of the mod name. This is needed when a patch pak is used for the main game files.
- Load order. Incorrecy load order may cause issues between mods, change the numberical elements of the pak name to change the load order.
- Mount point (The best way to debug any issues is to use the builtin UnrealPak.exe. Simply open this with cmd with the line: `unreakpak.exe -List This_Is_A_Pak.pak`. Look at the mounting point. The mounting point will be the deepest folder that encapulates all of your content. If it is not, you may have an issue.)
