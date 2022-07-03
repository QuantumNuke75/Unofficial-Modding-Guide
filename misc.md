---
title: Misc
layout: default
--- 

## Misc

## Batch Game File Extraction  
1. If you already have an <a href="downloads/AILevelData.ini" download>`AILevelData.ini`</a> file you would like to use, skip steps 1-3. Create a new .bat file in the UnrealPak.exe location. In this .bat file put the following:
```batch
@if "%~1"=="" goto skip
@setlocal enableextensions
@pushd %~dp0
.\UnrealPak.exe %1 -extract "%~n1"
@popd
@pause
:skip
```
2. From the game .paks folder, drag `pakchunk0-WindowsNoEditor_0_P.pak` onto the .bat file. This will create a new folder with all the unpacked contents in the same directory as a .bat file.


### AI Modding  
1. Go to your extracted `.../pakchunk0-WindowsNoEditor_0_P/ReadyOrNot/Config/…` and open `AILevelData.ini`.
2. Edit the `AILevelData.ini` file however you would like.
3. Create a new pakchunk mod folder, just as you would with any other mod. However, make sure to add `_P` to the end of the folder name. Inside that folder, create the directory `Config`, and put your `AILevelData.ini` file inside. 
4. Pak the mod.
