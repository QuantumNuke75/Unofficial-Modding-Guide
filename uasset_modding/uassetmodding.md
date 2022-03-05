## UAsset Modding
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
1. Open `REDACTED` and open the UAsset file you wish to edit.
2. On the left side you'll see a series of dropdowns. Within these, you'll find various structs that you can edit. Find the struct that you would like to edit, and find the value within that you would like to change.
3. Change the value. 
4. Save the file to anywhere. Two files will have been created, a .uasset and a .uexp, make sure to pak both of these files into your .pak mod in the correct location.
	
### Adding Data  
This can be a very complicated portion of modding. **Make sure to read all of this very carefully.** 

1. Open the UAsset file in `REDACTED`.
2. Export the JSON file, and open that file in a text editor of your choice. I would suggest using Notepad++ and the `JSON Parser` plugin. This will let you auto-format the JSON file. 
3. When adding data, you'll need to copy and paste whatever data you're trying to add more of. If if this is a new item in `ItemDataTable.uasset`, then you'll need to copy another item in the datatable. Copy and paste whatever you would like to duplicate into the correct location. Keep in mind all of the commas and brackets.
4. If you see a negative number that doesn't correlate to coordinates, or scale, or rotation, this is an import reference. If you open `Import Data` located in the left pane, you'll see a bunch of negative numbers and other data stored in rows. This is the portion of the file that contains all the references and imports the file uses. Also within this file, you'll see a column label called `OuterIndex`. This column 


### JSON Parsing
