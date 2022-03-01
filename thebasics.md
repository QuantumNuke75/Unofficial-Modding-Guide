## The Basics

**Extracting Game Files**  
There are two methods of easily accessing the files within the game. One will be covered as it remains the best method. That is to use UModel, directing it towards the location of the .pak files within Ready or Not: `<GameInstallLocation>\Ready Or Not\ReadyOrNot\Content\Paks`. This will allow you to extract almost anything you want. Texture files will be in .tga, and models should be in .psk.

**Cooking Modified Files**  
In order to override any assets within the game or add new content, the files must be in a format that the game can recognize. The files you extracted via UModel will be in a format that is easily accessible by you, not the game. You will first need to cook these before PAKing the files.

1. Install the latest version of Unreal Engine 4.27. The current latest version is 4.27.2.
2. Import all the files you want to pack with your mod into a new blank project. Any other template can work, but will result in significantly longer cooking times.
3. Go to `File > Cook Content for Windows`. This converts the files into a UE4 exported format. Retrieve the cooked files in `<ProjectLocation/><ProjectName>/Saved/Cooked/WindowsNoEditor/`.

**Creating a PAK File**  
1. Make sure the folder you are PAKing, for example `pakchunk99-Mods_MyMod`, contains the same file structure as Ready or Not. This is the file structure. Make sure to read all of it, and completely understand it before continuing. The number after `pakchunk` indicated the load order of the .pak.
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
4. Drag the folder you want to PAK, for example `pakchunk99-Mods_MyMod`, directly onto the .bat file you just created.  This will create a .pak file in the same directory as 5. the folder you just dragged. This file should mimic something like this: `pakchunk99-Mods_MyMod/Content/ReadyOrNot/Assets/…`.
6. As long as your file structure mimics Ready or Not, and you followed these instructions, you will have a working mod.
