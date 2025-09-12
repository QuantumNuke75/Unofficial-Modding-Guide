---
title: UE4SS and Mappings [UE5.3+]
date: 2024-07-23 00:00:00 +0000
categories: [UAsset Modding]
tags: [ue4ss, mappings, fmodel, uassetgui]
description: A quick guide on how to setup UE4SS and the Mappings.usmap.
author: "RareKiwi"
pin: true
---

## Mappings Download
With the Unreal Engine upgrade to 5.3, you will now need a Mappings.usmap for UAssetGUI and Fmodel to fully function.  
You can download a shared version of the Mappings.usmap for Ready Or Not below:  
[Ready Or Mod Discord](https://discord.com/channels/925225229175906324/1143385363130351636)  
[UMG Mappings.usmap](/downloads/Mappings.usmap) **[12-September-2025 Build:94572 "Los Sueños Stories Patch # 3"]**  

## UAssetGUI Import
>Ensure UAssetGUI is updated for UE5.3 (Versions 1.0.1.0+)  

1. Open `Utils > Import mappings...`  
![UassetGUI_Mappings_1](/assets/UassetGUI_Mappings_1.png)  
2. Navigate to your downloaded or generated `Mappings.usmap`  
3. Give it a name.  
![UassetGUI_Mappings_2](/assets/UassetGUI_Mappings_2.png)
4. Happy Modding!  

>You can find your stored mappings in the config directory, `Help > Open Config Directory...`  
>Or in `%localappdata%\UAssetGUI`  


## FModel Import
>Ensure FModel is already configured for Ready Or Not and UE5.3 

1. Open `Settings`  
2. Enable the `Enable Local Mapping File` checkbox
![Fmodel_Mapping](/assets/FModel_mapping.png)  
3. Press the `...` and navigate to your downloaded or generated `Mappings.usmap`
4. Press OK to close the settings, then restart Fmodel.


## UE4SS

### Install

1. Download `UE4SS_v3.0.1.zip` from [Github UE4SS Releases](https://github.com/UE4SS-RE/RE-UE4SS/releases/)  
2. Extract the contents next to the `ReadyOrNot-Win64-Shipping.exe` in  
`...\Ready Or Not\ReadyOrNot\Binaries\Win64\`

### Generating Mappings

How to create a new `Mappings.usmap`

1. Open `UE4SS-settings.ini` and change the following:
```ini
MajorVersion = 5
MinorVersion = 3
ConsoleEnabled = 1
GuiConsoleEnabled = 1
GuiConsoleVisible = 1
GraphicsAPI = dx11
```

2. Start the game, wait to load to menu, switch to the UE4SS window.  
	> If the game crashes after Epic Online Services says connected/offline, you may need to start the game with your pc disconnected from a network.  
	{: .prompt-warning }
3. Under the `Dumpers` tab press `Generate .usmap file.....`
4. It should work instantly, but you can confirm on the `Console` tab.  
The file `Mappings.usmap` should be create next to your .exe  
5. You can close the game now.  
	>If you want to disable UE4SS you can rename dwmapi.dll or remove it's files.  
	>Otherwise it's quite handy for enabling the in game console, you may just want to hide the GUI window if your not using it  
	>```ini
	GuiConsoleVisible = 0
	```
	{: .prompt-tip }