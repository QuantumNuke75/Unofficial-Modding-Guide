---
title: Batch Files
date: 2022-07-19 00:00:00 +0000
categories: [General Information]
tags: [batch]
pin: true
description: Various options for batch files to extract games files or to create a .pak file.
author: "QuantumNuke75|https://www.nexusmods.com/users/62784961,UMG|https://unofficial-modding-guide.com"
---

## Batch Files 5.3

> These UnrealPak bat files are placed in your engine folder, next to UnrealPak.exe  
> You can create file shortcuts for easier access.
> `...\UE_5.3\Engine\Binaries\Win64\`
{: .prompt-warning }

### Pak Dragged Folder
Download: [Pak.bat](/downloads/Pak.bat)  
{: .prompt-info }
> Example folder contents: `...\pakchunk99-Mod_ExampleMod_P\Content\...`
{: .prompt-info }

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

> You can change `../../../ReadyOrNot` to `../../..`  
> This allows you to include engine assets for a level's master material dependencies for example, but you need to then add a top `\ReadyOrNot\` folder before paking.  
> For example: `...\pakchunk99-Mod_ExampleLevel\ReadyOrNot\Content\...`
{: .prompt-tip }

### Extract to the Pak's containing folder with folders intact
Download: [Unpak.bat](/downloads/Unpak.bat)  
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

## Batch Files 4.27

### Extract to Win64
```batch
@if "%~1"=="" goto skip

@setlocal enableextensions
@pushd %~dp0
.\UnrealPak.exe %1 -extract "%~n1"
@popd
@pause

:skip
```

### Extract to Custom Directory
```batch
@if "%~1"=="" goto skip

::REPLACE WITH YOUR DIRECTORY TO EXTRACT TO
@set output_location=C:\Program Files (x86)\Steam\steamapps\common\Ready Or Not\ReadyOrNot\Content\Paks
@setlocal enableextensions
@pushd %~dp0
@echo %output_location%/%~n1
.\UnrealPak.exe %1 -extract "%output_location%\%~n1"
@popd
@pause

:skip
```
> The following create Pak batch files may need to be updated for the Ready Or Not UE5.3/Home Invasion update 
{: .prompt-danger }

### Pak to Same Directory
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

### Pak to Custom Directory
```batch
@if "%~1"=="" goto skip

::REPLACE WITH YOUR DIRECTORY
@set output_location=C:\Program Files (x86)\Steam\steamapps\common\Ready Or Not\ReadyOrNot\Content\Paks
@setlocal enableextensions
@pushd %~dp0
@echo %output_location%%~n1.pak
@echo "%~1\*.*" "../../../ReadyOrNot/" >filelist.txt
.\UnrealPak.exe "%output_location%\%~n1.pak" -create=filelist.txt -compress
@popd
@pause

:skip
```
