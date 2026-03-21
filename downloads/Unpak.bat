@if "%~1"=="" goto skip
@setlocal enableextensions
@pushd %~dp0
md "%~dpn1\"
.\UnrealPak.exe %1 -extract "%~dpn1\\"  -extracttomountpoint
@popd
@pause
:skip
