---
title: Batch Files
date: 2022-07-19 12:00:00 +0800
categories: [General Information]
tags: [batch]
pin: true
desc: Various options for batch files to extract games files or to create a .pak file.
---

## Batch Files

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
