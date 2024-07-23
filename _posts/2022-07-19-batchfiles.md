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

### Pak Dragged Folder
You will need a ReadyOrNot folder within.  
> For example: `...\pakchunk99-Mod_PlayerLimitEdit_P\ReadyOrNot\Content\...`
{: .prompt-info }
```batch
@setlocal ENABLEDELAYEDEXPANSION
@if "%~1"=="" goto skip
@setlocal enableextensions
@pushd %~1
(for /R %%f in (*) do @set "filePath=%%f" & set "relativePath=!filePath:%~1=!" & @echo "%%f" "../../..!relativePath!")>"%~dp0/filelist.txt"
@pushd %~dp0
::-compresslevel=4 for Normal, -compresslevel=-4 for uncompressed hyperfast paking
.\UnrealPak.exe "%~1.pak" -create=filelist.txt -compress -compressionformats=Oodle -compressmethod=Kraken -compresslevel=4
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
