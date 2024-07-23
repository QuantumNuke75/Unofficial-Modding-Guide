---
title: UAsset Modding
date: 2022-07-19 00:00:00 +0000
categories: [UAsset Modding]
tags: [uasset]
description: A general guide on how to edit UAsset files by changing values and adding data.
author: "QuantumNuke75|https://www.nexusmods.com/users/62784961,UMG|https://unofficial-modding-guide.com"
---

## UAsset Modding
>**[UE5.3]** UassetGUI now needs a [Mappings.usmap](/posts/ue4ss_and_mappings/#mappings-download) for full functionality
{: .prompt-warning }

To do  UAsset modding, you'll need to be able to extract the raw files from the game. Make sure to use this .bat file in your UE4 install directory to unpack the game files:
```batch
@if "%~1"=="" goto skip

@setlocal enableextensions
@pushd %~dp0
.\UnrealPak.exe %1 -extract "%~n1"
@popd
@pause

:skip
```

### Numerical/String Edits  
These are by far the easiest edits to do. 
1. Open UAssetGUI and open the UAsset file you wish to edit.
2. On the left side you'll see a series of dropdowns. Within these, you'll find various structs that you can edit. Find the struct that you would like to edit, and find the value within that you would like to change.
3. Change the value. 
4. Save the file to anywhere. Two files will have been created, a .uasset and a .uexp, make sure to pak both of these files into your .pak mod in the correct location.
	
### Adding Data  
This can be a very complicated portion of modding. **Make sure to read all of this very carefully.** This section will be specific in what to do and what to not do, but will not explain everything, as each file can be a little different. As long as you make sure the imports are correct and that you added the data correctly, the file should work.

1. Open the UAsset file in UAssetGUI.
2. Export the JSON file, and open that file in a text editor of your choice. I would suggest using Notepad++ and the `JSON Parser` plugin. This will let you auto-format the JSON file. 
3. When adding data, you'll need to copy and paste whatever data you're trying to add more of. If if this is a new item in `ItemDataTable.uasset`, then you'll need to copy another item in the datatable. Copy and paste whatever you would like to duplicate into the correct location. Keep in mind all of the commas and brackets.
4. If you see a negative number that doesn't correlate to coordinates, or scale, or rotation, this is an import reference.  
	- If you open `Import Data` located in the left pane of UAssetGUI, you'll see a bunch of negative numbers in the first column and other data stored in rows. This is the  	  portion of the file that contains all the references and imports the file uses. Also within this file, you'll see a column label called `OuterIndex`. This column will also contain a bunch of negative nunber and 0s. The 0s indicate that the row is not a child of another row. If this row contains a negative number within that column, then that row depends on another dependency. You can find this dependency as you would any other import, locatin the row with said negative number.  
	- When adding a reference from the game, it's a good idea to copy and paste similar references and then change the strings slightly. This ensures that you will retain the correct formatting. You can add this reference either in the JSON file or in UAssetGUI. Both are better in different scenarios. If you're going to add a bunch of imports, use the JSON file, otherwise use UAssetGUI.
5. Save the JSON file with all your edits and open that JSON file in UAssetGUI. If you get an error, you messed up the JSON formatting.
6. If you have made all your data additions and made sure to have the proper imports (you may need to import multiple times for just one thing), then the mod should work. You can tell if it's working if the game does't freeze or crash on launch (wait until the intro screen ends). If this occurs there is a high chance you messed up something with the imports.
