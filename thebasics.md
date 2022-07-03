---
title: The Basics
layout: default
--- 

## The Basics

### Extracting Game Files  
There are two methods of easily accessing the files within the game. 
1. [UModel](https://unofficial-modding-guide.com/tools.html), directing it towards the location of the .pak files within Ready or Not: `<GameInstallLocation>\Ready Or Not\ReadyOrNot\Content\Paks`. This will allow you to extract almost anything you want. Texture files will be in .tga, and models should be in .psk.
2. Unpaking, which can be done simply by setting up an unpak batch script, coverd in [Misc](https://unofficial-modding-guide.com/misc.html).

### Cooking Modified Files  
In order to override any assets within the game or add new content, the files must be in a format that the game can recognize. The files you extracted via UModel will be in a format that is easily accessible by you, not the game. You will first need to cook these before PAKing the files.

1. Install the latest version of Unreal Engine 4.27. The current latest version is 4.27.2.
2. Import all the files you want to pack with your mod into a new blank project. Any other template can work, but will result in significantly longer cooking times.
3. Go to `File > Cook Content for Windows`. This converts the files into a UE4 exported format. Retrieve the cooked files in `<ProjectLocation/><ProjectName>/Saved/Cooked/WindowsNoEditor/`.

### Creating a PAK File  
1. Make sure the folder you are PAKing, for example `pakchunk99-Mods_MyMod`, contains the same file structure as Ready or Not. This is the file structure. Make sure to read all of it, and completely understand it before continuing. The number after `pakchunk` indicates the load order of the .pak.
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
4. Drag the folder you want to PAK, for example `pakchunk99-Mods_MyMod`, directly onto the .bat file you just created.  This will create a .pak file in the same directory as the folder you just dragged. This file should mimic something like this: `pakchunk99-Mods_MyMod/Content/ReadyOrNot/Assets/…`.
6. As long as your file structure mimics Ready or Not, and you followed these instructions, you will have a working mod.

### Mod Installation  
Navigate to `<GameInstallLocation>\Ready Or Not\ReadyOrNot\Content\Paks` and put your .pak file there. Ensure that the .pak load order is correct.

### Understanding the File Structure  
Let's make this braindead easy. When creating a project in Unreal Engine 4, the project will be saved to a directory. Within that directory will be the project. For example: `<SaveDirectory>/<ProjectName>/…`. `<ProjectName>` houses all of the contents of the Unreal Engine 4 project. In that project folder, there will be a subfolder named `Content`. That folder houses all of the assets and blueprints within a game.

In the case of Ready or Not, the project name is `ReadyOrNot`. Within that folder, there is a folder called `Content`. Again, this houses everything inside a game except for configuration files. However, when you open the game files in UModel, there may not be a `Content` folder, instead, it’ll have been replaced with a `Game` folder. When .paking your mod, you should replace `Game` with `Content`. Any of the sub folders will remain the same.

The majority of the modding that you will do will be under the `Content` folder. If a file that you are looking to override is in `.../ReadyOrNot/Game/ReadyOrNot/Assets/Weapons/Python`, the file path to copy would be `.../Content/ReadyOrNot/Assets/Weapons/Python`.

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

### Example Mod  
To see if your PAKing is working, download this [example mod](https://drive.google.com/file/d/1iSbu8JqFbry1lioBEIuB5ks0D8bhKQ7c/view?usp=sharing). This will turn your gun on the main menu pink if the .pak is correctly PAKed. Download and extract the .zip file before PAKing. 

### Debugging  
The best way to debug any issues is to use the builtin UnrealPak.exe. Simply open this with cmd with the line: `unreakpak.exe -List This_Is_A_Pak.pak`. Look at the mounting point. If you have a single innermost directory that contains all your files, and the mounting point is that directory, you are fine. Otherwise, with multiple directories, the mounting point should be `../../../ReadyOrNot/`.
