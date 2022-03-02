## Misc

**Custom Map Loading / Console Unlocking**  
1. Download the latest version of Universal Unreal Engine 4 Unlocker, UUU.
2. Extract the files and run `UuuClient.exe`.
3. Open Ready or Not, you’ll have to have the game open in order to inject the console unlocker. 
4. On the left in UUU, select `General` and press select to choose the process to inject into. 
5. Select `ReadyOrNot-Win64-Shipping.exe` and press inject. 
6. Go back to your game window. You should see messages pop up in the upper left of your screen indicating that the injection of the console was successful, and that the camera was successfully hooked into.
7. Press your `~` key in order to open the console. 
8. If you want to load a map, simply type `open <MapName>`.

**Easy AI Modding**  
1. If you already have an <a href="downloads/AILevelData.ini">`AILevelData.ini`</a> file you would like to use, skip steps 1-3. Create a new .bat file in the UnrealPak.exe location. In this .bat file put the following:
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
3. Go to `.../pakchunk0-WindowsNoEditor_0_P/ReadyOrNot/Config/…` and open `AILevelData.ini`.
4. Edit the `AILevelData.ini` file however you would like.
5. Create a new pakchunk mod folder, just as you would with any other mod. However, make sure to add `_P` to the end of the folder name. Inside that folder, create the directory `Config`, and put your `AILevelData.ini` file inside. 
6. Pak the mod, and everything will work the same as Kronzky’s AI mod.
