---
title: The Basics
date: 2025-02-28 00:00:00 +0000
categories: [General Information]
tags: [essential, batch]
pin: true
description: The basics of modding for Ready or Not. Covers extracting game files, the game's file structure, file formats, cooking files, and creating .pak files.
author: "QuantumNuke75|https://www.nexusmods.com/users/62784961,UMG|https://unofficial-modding-guide.com,RareKiwi(Updated)"
---

## Important Information

### Understanding the File Structure  
When creating a project in Unreal Engine 5, the project will be saved to a directory. Within that directory will be the project. For example: `<SaveDirectory>/<ProjectName>/…`. `<ProjectName>` houses all of the contents of the Unreal Engine 5 project. In that project folder, there will be a subfolder named `Content`. That folder houses all of the assets and blueprints within a game.

In the case of Ready or Not, the project name is `ReadyOrNot`. Within that folder, there is a folder called `Content`. Again, this houses everything inside a game except for configuration files. However, when you open the game files in UModel, there may not be a `Content` folder, instead, it’ll have been replaced with a `Game` folder. When .paking your mod, you should replace `Game` with `Content`. Any of the sub folders will remain the same.

The majority of the modding that you will do will be under the `Content` folder. If a file that you are looking to override is in `.../ReadyOrNot/Game/ReadyOrNot/Assets/Weapons/Python`, the file path to copy would be `.../Content/ReadyOrNot/Assets/Weapons/Python`.

> Failure to copy the exact path of Ready or Not will result in a broken mod.
{: .prompt-danger }

### File Formats  
There are multiple different file formats that you may encounter while modding. Here is a list of most of them, and what each of them are.
- **.psk** - A skeletal or static mesh. May contain the skeleton.
- **.psa** - An animation for a specific mesh.
- **.uasset** - Two types.
  1. Raw .uasset files are the ones created after cooking a UE5 project. 
  2. UE5 .uasset files are the ones that are taken directly from a UE5 project, they are uncooked and can be transferred between projects.
- **.uexp** - An raw complementary file to uassets, usually containing import and export maps.
- **.ubulk** - Another data storage file that UE5 uses. 
- **.umap** - A level/map file, similar to .uasset in the way that there is an uncooked and cooked version.

  
  
## Essentials

### Extracting Game Files  
There are three methods of extracting games files, both have important differences:
1. [FModel](/posts/tools/#fmodel) This is the most supported for engine versions beyond UE5, but requires some setup and a RoN specific mapping file (See [Mappings](/posts/ue4ss_and_mappings/)). FModel can save original cooked assets for editing in programs like [UAssetGUI](/posts/tools/#uassetgui) as-well-as export resources like textures, static meshes and skeletal meshes into editable formats.
2. [UModel](/posts/tools/#umodel). This program can export non-raw files, allowing you to gain access to textures, models, and animations. To use it, direct it towards the location of the .pak files within Ready or Not: `<GameInstallLocation>\Ready Or Not\ReadyOrNot\Content\Paks`. You'll be able to extract individual assets once loaded.
	> However, it's main source has been unsupported for versions of Unreal Engine beyond UE5. There is a community build linked above for UE5+, but use it at your own risk.
	{: .prompt-danger }
3. Manual unpaking. This can be done simply by setting up an unpak batch script. You can only extract raw cooked files this way.
	1. Create a .bat file in your UnrealPak install location (located within your Unreal Engine 5 install), usually `<InstallLocation>\UE_5.3\Engine\Binaries\Win64\UnrealPak.exe`.
	2. In the .bat file, paste the following lines in and save:
	```batch
	@if "%~1"=="" goto skip
	@setlocal enableextensions
	@pushd %~dp0
	md "%~dpn1\"
	.\UnrealPak.exe %1 -extract "%~dpn1\\"  -extracttomountpoint
	@popd
	@pause
	:skip
	```
	3. Drag the .pak file you want to unpak, for example `pakchunk0-Windows`, directly onto the .bat file you just created.  This will extract the pak's files in the same location as the pak file, in a new folder with its name.  
	
	> Now that the game is split into multiple paks, this method isn't really recommended except for debugging your own mod pak files. You should usually use umodel or fmodel for extracting specific assets (umodel has a better flat view search, fmodel is better supported and lets you directly scoop through assets json).  
	> Usually you'd use fmodel if you want to export the entire game's pak content.
	{: .prompt-info }

### Cooking Modified Files  
In order to override any assets within the game or add new content, the files must be in a format that the game can recognize. The files you extracted via UModel will be in a format that is easily accessible by you, not the game. You will first need to cook these before PAKing the files.

1. Install the latest version of Unreal Engine 5.3. The current latest version is `5.3.2`.
2. Import all the files you want to pack with your mod into a new blank project. Any other template can work, but will result in significantly longer cooking times.
3. Go to `File > Cook Content for Windows`. This converts the files into a UE5 exported format (\*.uasset, \*.uexp, \*.ubulk). Retrieve the cooked files in `<ProjectLocation/><ProjectName>/Saved/Cooked/WindowsNoEditor/`.

### Creating a PAK File  
1. Make sure the folder you are paking, for example `pakchunk99-Mods_MyMod_P`, contains the same file structure as Ready or Not. Also ensure that `_P` is at the end of your pak name. Not doing so will likely result in the mod not loading. The number after `pakchunk` indicates the load order of the .pak. Make sure to understand the directory structure first, before paking your mod. Incorrect directory structure will lead to issues. Your structure should mimic something like this: `pakchunk99-Mods_MyMod/Content/ReadyOrNot/Assets/…`.
2. Create a .bat file in your UnrealPak install location (located within your Unreal Engine 5 install), usually `<InstallLocation>\UE_5.3\Engine\Binaries\Win64\UnrealPak.exe`.
3. In the .bat file, paste the following lines in and save:
```batch
@setlocal ENABLEDELAYEDEXPANSION
@if "%~1"=="" goto skip
@setlocal enableextensions
@pushd %~1
(for /R %%f in (*) do @set "filePath=%%f" & set "relativePath=!filePath:%~1=!" & @echo "%%f" "../../../ReadyOrNot!relativePath!")>"%~dp0/filelist.txt"
@pushd %~dp0
::-compresslevel=4 for Normal, -compresslevel=-4 for uncompressed hyperfast paking
.\UnrealPak.exe "%~1.pak" -create=filelist.txt -compress -compressionformats=Oodle -compressmethod=Kraken -compresslevel=4
@popd
@pause
:skip
```  
	> Do not include any symbols besides `- _` in your full folder paths.  
	> Broken Folder Structure Example: `C:\Mods, Bats & Stuff\pakchunk99-Mod_ExampleMod_P\`   
	{: .prompt-danger }  
	> See more info and downloads for batch scripts [@Batch Files](/posts/batchfiles)
	{: .prompt-tip }  
	> This pak script needed to be updated for UE5, so if you modded before on UE4.27, be sure to update it.
	{: .prompt-info } 
4. Drag the folder you want to PAK, for example `pakchunk99-Mods_MyMod_P`, directly onto the .bat file you just created.  This will create a .pak file in the same directory as the folder you just dragged.

> If the .pak file size is 1 KB, change the locations of the contents you are attempting to pak.
{: .prompt-warning }


## Additional Information

### Mod Installation  
All .pak mods go here. `<GameInstallLocation>\Ready Or Not\ReadyOrNot\Content\Paks`. Ensure that the .pak load order is correct.

### Example Mod
To see if your PAKing is working, download this [example mod](/downloads/pakchunk99-Mods_Am_I_PAKing_Right_P.zip). This will turn your logo on the main menu pink if the .pak is correctly PAKed. Download and extract the .zip file before PAKing. 
![Pink Logo](/assets/ReadyOrNot-PinkLogo.jpg)
_Replaces the Ready or Not main menu title logo with a pink texture_

### Debugging  
If your mod is not working, make sure to check these common error points:
- Check the file structure. This must perfectly match the files within the game, otherwise it will not load.
- No `_P` at the end of the mod name. This is needed when a patch pak is used for the main game files.
- Load order. Incorrectly load order may cause issues between mods, change the numerical elements of the pak name to change the load order.
- Mount point (The best way to debug any issues is to use the builtin UnrealPak.exe. Simply open this with cmd with the line: `unreakpak.exe -List This_Is_A_Pak.pak`. Look at the mounting point. The mounting point will be the deepest folder that encapsulates all of your content. If it is not, you may have an issue.)
