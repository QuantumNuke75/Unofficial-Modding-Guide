---
title: Batch Files
layout: default
--- 

## Batch Files

### Un-pak to Win64
```batch
@if "%~1"=="" goto skip

@setlocal enableextensions
@pushd %~dp0
.\UnrealPak.exe %1 -extract "%~n1"
@popd
@pause

:skip
```

### Un-pak to Custom Directory
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

### pak to Same Directory
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

### pak to Custom Directory
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
