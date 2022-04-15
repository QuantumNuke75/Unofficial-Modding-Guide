---
title: UAsset Modding
layout: default
--- 

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


### JSON Parsing via Python
Once you have a firm understanding of `Adding Data`, you can semi-easily automate tasks. To start, you'll need some Python, or other programming knowledge. I'll be using Python for this tutorial because of the simple to use json library that comes with Python 3+. I highly recommend doing this if you need to change a lot of data every time the game updates. If you would like specific help with this, ask QuantumNuke75#3593 on Discord.  

Your first line should be the import statement.
```python
import json
```
Next, you'll want to open the file. To do this, replace FILE_NAME with the location of your JSON file that you extracted with UAssetGUI.
```python
file = open('FILE_NAME')
```
At the bottom of the file, you'll want to export your JSON file, which you can then load back up in UAssetGUI and save it as a .uasset.
```python
json.dump(data, open("export.json", "w"))
```

But, you'll then want to load this file as a JSON file. `data` will become a Python dictionary.
```python
data = json.load(file)
```
Within this data variable will be layers of dictionaries, lists, and key-value pairs witin the dictionaries. From this, you'll be able to easily automate adding, data, changing values, or anything. Below I will attach the code that automates making the mod, More Ammo. I ask that you take this as an example, and **don't try to steal this code to make a competitor ammo mod, that would be a shitty thing to do.** In the future, I will also upload the code that automates Everything Unlocked, as that is a more complex example.   
```python
import json

num_mags = 15

file = open('ItemDataTable.json')
data = json.load(file)

# For every item in the table.
for item in data["Exports"][0]["Table"]["Data"]:
    # For every piece of the item data.
    for item_data in item["Value"]:
        if item_data["Name"] == "MagazineCountDefault(0)":
            amount = int(item_data["Value"])
            if 3 < amount < 30:
                item_data["Value"] = num_mags
                continue
        if item_data["Name"] == "MagazineCountMax(0)":
            amount = int(item_data["Value"])
            if 3 < amount < 30:
                item_data["Value"] = num_mags
                continue

json.dump(data, open(f"ammo_export_{num_mags}.json", "w"))

```
