---
title: UAsset Automation
date: 2022-07-19 00:00:00 +0000
categories: [UAsset Modding]
tags: [uasset, python, automation]
description: An in depth guide on how to automatically edit and parse data from a UAsset file. Useful for quickly updating mods when a new Ready or Not update comes out.
author: "QuantumNuke75|https://www.nexusmods.com/users/62784961,UMG|https://unofficial-modding-guide.com"
---

## UAsset Automation

### JSON Parsing via Python
Once you have a firm understanding of manually editing UAssets, you can semi-easily automate tasks. To start, you'll need some Python, or other programming knowledge. I'll be using Python for this tutorial because of the simple to use json library that comes with Python 3+. I highly recommend doing this if you need to change a lot of data every time the game updates. If you would like specific help with this, ask QuantumNuke75#3593 on Discord.  


### Ammo Mod
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

Within this data variable will be layers of dictionaries, lists, and key-value pairs witin the dictionaries. From this, you'll be able to easily automate adding, data, changing values, or anything. Now we'll need to loop through every item in the export datatable, which is where the majority of the data we need is held.
```python
for item in data["Exports"][0]["Table"]["Data"]:
```

Now we need to loop through every value for every item, since the ammo count for a gun is just one of many values an item has.
```python
	for item_data in item["Value"]:
```

Now, we check for specific tags, in our case, these tags are `MagazineCountDefault(0)` and `MagazineCountMax(0)`. Once we've found these tags, we can set the values of these to whatever we want. In this specific case, the code is getting the value, and adding a number of mags to it.
```python
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
```

The full code is below:
```python
import json

num_mags = 15

file = open('ItemDataTable.json')
data = json.load(file)

# For every item in the export table.
for item in data["Exports"][0]["Table"]["Data"]:
    # For every piece of the item data.
    for item_data in item["Value"]:
        # If the item's name is MagazineCount
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
> **More Ammo** is an outdated mod, and this code will no longer effect anything in the game.
{: .prompt-warning }


### Everything Unlocked
I'll be skipping basic portions of parsing, and will explain more complicated changes instead. Adding data with this method is significantly harder than just changing values. There are two different files we need to edit for Everything Unlocked, `ItemDataTable.uasset` and `ItemData.uasset`.

#### ItemData

In order to add entries to the `ItemData` we'll need know what data to add. Every weapon has the following distinct attributes: name, gun blueprint location, default class name, class name, and the item type. In order to make this easier, a struct class was created.
```python
class ItemDataStruct:
    def __init__(self, name, location, default, clas, type):
        self.name = name
        self.location = location
        self.default = default
        self.clas = clas
        self.type = type
```

This class holds all the information needed to add a specific gun. Now, we need to add a bunch of values. Since we are adding both primary weapons, secondary weapons, tacticals, and helmets accessory options, it's important to distinguish them all. We'll store each category of items in their separate arrays.
```python
primary_weapons = []
primary_weapons.append(ItemDataStruct("P90", "/Game/Blueprints/Items/WeaponsRevised/Primary_P90(0)", "Default__Primary_P90_C(0)", "Primary_P90_C(0)", "SMG"))

primary_weapons.append(ItemDataStruct("Primary_M16A4", "/Game/Blueprints/Items/WeaponsRevised/Primary_M16A4(0)", "Default__Primary_M16A4_C(0)", "Primary_M16A4_C(0)", "AR"))

primary_weapons.append(ItemDataStruct("Primary_Saiga12", "/Game/Blueprints/Items/WeaponsRevised/Primary_Saiga12(0)", "Default__Primary_Saiga12_C(0)", "Primary_Saiga12_C(0)", "Shotgun"))

secondary_weapons = []
secondary_weapons.append(ItemDataStruct("P250", "/Game/Blueprints/Items/WeaponsRevised/Secondary_P250(0)", "Default__Secondary_P250_C(0)", "Secondary_P250_C(0)", "Pistol"))

tacticals = []
tacticals.append(ItemDataStruct("9Banger", "/Game/Blueprints/Items/WeaponsRevised/Grenade_9Banger_V2(0)", "Default__Grenade_9Banger_V2_C(0)", "Grenade_9Banger_V2_C(0)", "Grenade"))

helmets = []
helmets.append(ItemDataStruct("Helmet_UpArmor", "/Game/Blueprints/Items/ArmorRevised/Helmet_UpArmor(0)", "Default__Helmet_UpArmor_C(0)", "Helmet_UpArmor_C(0)", "Helmet"))
```

Now we can begin parsing through the data. Similarly to More Ammo, we'll be accessing the data in the same way but instead we'll checking if the item is a `PrimaryWeapons(0)`, `SecondaryWeapon(0)`, `TacticalItems(0)`, or `HeadSelection(0)`.
```python
if items["Name"] == "PrimaryWeapons(0)":
elif items["Name"] == "SecondaryWeapons(0)":
elif items["Name"] == "TacticalItems(0)":
elif items["Name"] == "HeadSelection(0)":
```

I'll only be covering how to automate the primary weapons to prevent this guide from getting longer. Each category is very similar, with some slight changes. Once we've establish that we're in the `PrimaryWeapons(0)` category, we can begin making changes. Now we can parse through all the weapon structs we created for primary weapons.
```python
for weapon_struct in primary_weapons:
```

The second thing we'll need to to is add the imports. Without imports, the game will have no idea what you've added to the table. However, we need to get the current import number.
```python
last_import_index = len(data["Imports"])
```

Once we've done that, we can add all the imports we need.
```python
dic_1 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': '/Script/CoreUObject(0)', 'ClassName': 'Package(0)', 'ObjectName': weapon_struct.location, 'OuterIndex': 0}
last_import_index += 1
dic_2 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': '/Script/Engine(0)', 'ClassName': 'BlueprintGeneratedClass(0)', 'ObjectName': weapon_struct.clas, 'OuterIndex': -last_import_index}
last_import_index += 1
dic_3 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': weapon_struct.location, 'ClassName': weapon_struct.clas, 'ObjectName': weapon_struct.default, 'OuterIndex': -(last_import_index-1)}
last_import_index += 1

data["Imports"].append(dic_1)
data["Imports"].append(dic_2)
data["Imports"].append(dic_3)
```

Now we can add the actual weapons to `ItemData`. We first need to distinguish between what type of weapon we have, this changes what `Type`, `CultureInvariantString`, and `ItemClass` we need. We'll also be copying a related gun entry so we don't have to create everything from scratch.
```python
last_copy = None

type = None
CultureInvariantString = None
item_class = None
if weapon_struct.type == "SMG":
	type = "EWeaponType::WT_SubmachineGun(0)"
	CultureInvariantString = "SMG"
	item_class = "EItemClass::IC_SMG(0)"

	last_copy = copy.deepcopy(items["Value"][0])

elif weapon_struct.type == "AR":
	type = "EWeaponType::WT_Rifles(0)"
	CultureInvariantString = "Rifle"
	item_class = "EItemClass::IC_AssaultRifle(0)"

	last_copy = copy.deepcopy(items["Value"][12])

elif weapon_struct.type == "Shotgun":
	type = "EWeaponType::WT_Shotgun(0)"
	CultureInvariantString = "Shotgun"
	item_class = "EItemClass::IC_Shotgun(0)"

	last_copy = copy.deepcopy(items["Value"][7])
```

Now, we set the related data in the copy.
```python
# Set gun type
last_copy["Value"][0]["Value"][0]["Value"] = type

# Set Category
last_copy["Value"][4]["Value"] = item_class

#Set name
last_copy["Value"][1]['Value'] = weapon_struct.name

# Set culture invariant string
last_copy["Value"][3]["CultureInvariantString"] = CultureInvariantString
```

Then, we set the import reference to the imports we just created, and append the new weapon to the table.
```python
# Set import ref
last_copy["Value"][5]["Value"] = -(last_import_index-1)

# Append item to table
items["Value"].append(last_copy)
```

The final code:
```python
import copy, json
from ItemDataStruct import ItemDataStruct

f = open('json/ItemData.json')
data = json.load(f)

primary_weapons = []
primary_weapons.append(ItemDataStruct("P90", "/Game/Blueprints/Items/WeaponsRevised/Primary_P90(0)", "Default__Primary_P90_C(0)", "Primary_P90_C(0)", "SMG"))

primary_weapons.append(ItemDataStruct("Primary_M16A4", "/Game/Blueprints/Items/WeaponsRevised/Primary_M16A4(0)", "Default__Primary_M16A4_C(0)", "Primary_M16A4_C(0)", "AR"))

primary_weapons.append(ItemDataStruct("Primary_Saiga12", "/Game/Blueprints/Items/WeaponsRevised/Primary_Saiga12(0)", "Default__Primary_Saiga12_C(0)", "Primary_Saiga12_C(0)", "Shotgun"))

secondary_weapons = []
secondary_weapons.append(ItemDataStruct("P250", "/Game/Blueprints/Items/WeaponsRevised/Secondary_P250(0)", "Default__Secondary_P250_C(0)", "Secondary_P250_C(0)", "Pistol"))

tacticals = []
tacticals.append(ItemDataStruct("9Banger", "/Game/Blueprints/Items/WeaponsRevised/Grenade_9Banger_V2(0)", "Default__Grenade_9Banger_V2_C(0)", "Grenade_9Banger_V2_C(0)", "Grenade"))

helmets = []
helmets.append(ItemDataStruct("Helmet_UpArmor", "/Game/Blueprints/Items/ArmorRevised/Helmet_UpArmor(0)", "Default__Helmet_UpArmor_C(0)", "Helmet_UpArmor_C(0)", "Helmet"))

last_import_index = len(data["Imports"])

# For every item in the table.
for items in data["Exports"][0]["Data"]:
    if items["Name"] == "PrimaryWeapons(0)":
        for weapon_struct in primary_weapons:

            # START IMPORTS
            dic_1 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': '/Script/CoreUObject(0)', 'ClassName': 'Package(0)', 'ObjectName': weapon_struct.location, 'OuterIndex': 0}
            last_import_index += 1
            dic_2 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': '/Script/Engine(0)', 'ClassName': 'BlueprintGeneratedClass(0)', 'ObjectName': weapon_struct.clas, 'OuterIndex': -last_import_index}
            last_import_index += 1
            dic_3 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': weapon_struct.location, 'ClassName': weapon_struct.clas, 'ObjectName': weapon_struct.default, 'OuterIndex': -(last_import_index-1)}
            last_import_index += 1

            data["Imports"].append(dic_1)
            data["Imports"].append(dic_2)
            data["Imports"].append(dic_3)
            # END IMPORTS

            last_copy = None

            type = None
            CultureInvariantString = None
            item_class = None
            if weapon_struct.type == "SMG":
                type = "EWeaponType::WT_SubmachineGun(0)"
                CultureInvariantString = "SMG"
                item_class = "EItemClass::IC_SMG(0)"

                last_copy = copy.deepcopy(items["Value"][0])

            elif weapon_struct.type == "AR":
                type = "EWeaponType::WT_Rifles(0)"
                CultureInvariantString = "Rifle"
                item_class = "EItemClass::IC_AssaultRifle(0)"

                last_copy = copy.deepcopy(items["Value"][12])

            elif weapon_struct.type == "Shotgun":
                type = "EWeaponType::WT_Shotgun(0)"
                CultureInvariantString = "Shotgun"
                item_class = "EItemClass::IC_Shotgun(0)"

                last_copy = copy.deepcopy(items["Value"][7])

            # Set gun type
            last_copy["Value"][0]["Value"][0]["Value"] = type

            # Set Category
            last_copy["Value"][4]["Value"] = item_class

            #Set name
            last_copy["Value"][1]['Value'] = weapon_struct.name

            # Set culture invariant string
            last_copy["Value"][3]["CultureInvariantString"] = CultureInvariantString

            # Set import ref
            last_copy["Value"][5]["Value"] = -(last_import_index-1)

            items["Value"].append(last_copy)

    elif items["Name"] == "SecondaryWeapons(0)":
        for weapon_struct in secondary_weapons:

            # START IMPORTS
            dic_1 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': '/Script/CoreUObject(0)',
                     'ClassName': 'Package(0)', 'ObjectName': weapon_struct.location, 'OuterIndex': 0}
            last_import_index += 1
            dic_2 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': '/Script/Engine(0)',
                     'ClassName': 'BlueprintGeneratedClass(0)', 'ObjectName': weapon_struct.clas,
                     'OuterIndex': -last_import_index}
            last_import_index += 1
            dic_3 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': weapon_struct.location,
                     'ClassName': weapon_struct.clas, 'ObjectName': weapon_struct.default,
                     'OuterIndex': -(last_import_index - 1)}
            last_import_index += 1

            data["Imports"].append(dic_1)
            data["Imports"].append(dic_2)
            data["Imports"].append(dic_3)
            # END IMPORTS

            last_copy = copy.deepcopy(items["Value"][0])

            type = None
            CultureInvariantString = None
            item_class = None
            if weapon_struct.type == "Pistol":
                type = "EWeaponType::WT_PistolsLethal(0)"
                CultureInvariantString = "Semi-Automatic"
                item_class = "EItemClass::IC_Pistol(0)"

            # Set Weapon Type
            last_copy["Value"][0]["Value"][0]["Value"] = type

            # Set ItemClass
            last_copy["Value"][4]["Value"] = item_class

            # Set name
            last_copy["Value"][1]['Value'] = weapon_struct.name

            # Set culture invariant string
            last_copy["Value"][3]["CultureInvariantString"] = CultureInvariantString

            # Set import ref
            last_copy["Value"][5]["Value"] = -(last_import_index - 1)

            items["Value"].append(last_copy)

    elif items["Name"] == "TacticalItems(0)":
        for item_struct in tacticals:
            # START IMPORTS
            dic_1 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': '/Script/CoreUObject(0)',
                     'ClassName': 'Package(0)', 'ObjectName': item_struct.location, 'OuterIndex': 0}
            last_import_index += 1
            dic_2 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': '/Script/Engine(0)',
                     'ClassName': 'BlueprintGeneratedClass(0)', 'ObjectName': item_struct.clas,
                     'OuterIndex': -last_import_index}
            last_import_index += 1
            dic_3 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': item_struct.location,
                     'ClassName': item_struct.clas, 'ObjectName': item_struct.default,
                     'OuterIndex': -(last_import_index - 1)}
            last_import_index += 1

            data["Imports"].append(dic_1)
            data["Imports"].append(dic_2)
            data["Imports"].append(dic_3)
            # END IMPORTS

            last_copy = copy.deepcopy(items["Value"][0])

            item_class = "EItemClass::IC_Grenade(0)"

            # Set Name
            last_copy["Value"][0]["Value"] = item_struct.name

            #Set ItemClass
            last_copy["Value"][10]["Value"] = item_class

            # Set import ref
            last_copy["Value"][13]["Value"] = -(last_import_index - 1)

            print(len(last_copy["Value"]))

            items["Value"].append(last_copy)

    elif items["Name"] == "HeadSelection(0)":
        for item_struct in helmets:
            # START IMPORTS
            dic_1 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': '/Script/CoreUObject(0)',
                     'ClassName': 'Package(0)', 'ObjectName': item_struct.location, 'OuterIndex': 0}
            last_import_index += 1
            dic_2 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': '/Script/Engine(0)',
                     'ClassName': 'BlueprintGeneratedClass(0)', 'ObjectName': item_struct.clas,
                     'OuterIndex': -last_import_index}
            last_import_index += 1
            dic_3 = {'$type': 'UAssetAPI.Import, UAssetAPI', 'ClassPackage': item_struct.location,
                     'ClassName': item_struct.clas, 'ObjectName': item_struct.default,
                     'OuterIndex': -(last_import_index - 1)}
            last_import_index += 1

            data["Imports"].append(dic_1)
            data["Imports"].append(dic_2)
            data["Imports"].append(dic_3)
            # END IMPORTS

            item_class = "EItemClass::IC_Headgear(0)"

            last_copy = copy.deepcopy(items["Value"][0])

            # Set Name
            last_copy["Value"][0]["Value"] = item_struct.name

            # Set Item Class
            last_copy["Value"][3]["Value"] = item_class

            # Set import ref
            last_copy["Value"][4]["Value"] = -(last_import_index - 1)

            items["Value"].append(last_copy)


json.dump(data, open(f"output/everything_unlocked_itemdata.json", "w"))
```



#### ItemDataTable
This is an easier table to edit, but required more data. To start, you'll need a dictionary of attachments mapped to their respective socket for each category of attachment: sight, muzzle, underbarrel. You'll also need a dictionary of item names, mapped to a list of sockets they have.  
Here's an example of the underbarrel attachment:
```python
all_under = {-38:"combat_grip",
-39:"combat_grip",
-65:"mp5_foregrip",
-66:"mp5_foregrip",
-70:"mp5_foregrip",
-81:"light_socket",
-82:"laser_socket",
-83:"laser_socket",
-86:"foregrip_socket",
-87:"afg_mlok_grip",
-90:"foregrip_socket",
-91:"pointer_socket",
-92:"pointer_socket",
-102:"foregrip_VFG_socket",
-103:"foregrip_socket",
-104:"vfg_mlok_grip",
-136:"foregrip_socket"}
```

And here's an example of the weapon names mapped to attachments:
```python
weapon_to_attachments = {'M1911A1':{'RMRPistol_Socket', 'comp_socket', 'supressor_socket', 'light_socket', 'laser_socket', 'SROPistol_Socket', 'flash_socket', 'Reflex_Socket'},
'G19':{'RMRPistol_Socket', 'comp_socket', 'supressor_socket', 'light_socket', 'laser_socket', 'SROPistol_Socket', 'flash_socket', 'Reflex_Socket'}}
```

Now we parse through the `ItemDataTable` and look for the corresponding attachment `AvailableUnderbarrelAttachments(0)`.
```python
for item in data["Exports"][0]["Table"]["Data"]:
    for item_data in item["Value"]:
	    if item_data["Name"] == "AvailableUnderbarrelAttachments(0)":
            name = item["Value"][0]["CultureInvariantString"]
            try:
                comp_attachments = weapon_to_attachments[name]
            except:
                continue

            attachments_to_add = []
            for under in all_under:
                if all_under[under] in comp_attachments:
                    attachments_to_add.append(under)

            for attachment in attachments_to_add:
                copied = copy.deepcopy(attachment_dic_format)
                copied["Value"] = attachment
                if copied not in item_data["Value"]:
                    item_data["Value"].append(copied)
            continue
```

And you're done! Code below.
```python
import copy, json

file = open('json/ItemDataTable.json')
data = json.load(file)


all_under = {-38:"combat_grip",
-39:"combat_grip",
-65:"mp5_foregrip",
-66:"mp5_foregrip",
-70:"mp5_foregrip",
-81:"light_socket",
-82:"laser_socket",
-83:"laser_socket",
-86:"foregrip_socket",
-87:"afg_mlok_grip",
-90:"foregrip_socket",
-91:"pointer_socket",
-92:"pointer_socket",
-102:"foregrip_VFG_socket",
-103:"foregrip_socket",
-104:"vfg_mlok_grip",
-136:"foregrip_socket"}

all_scopes = {}
all_muzzles = {}

weapon_to_attachments = {'M1911A1':{'RMRPistol_Socket', 'comp_socket', 'supressor_socket', 'light_socket', 'laser_socket', 'SROPistol_Socket', 'flash_socket', 'Reflex_Socket'},
'G19':{'RMRPistol_Socket', 'comp_socket', 'supressor_socket', 'light_socket', 'laser_socket', 'SROPistol_Socket', 'flash_socket', 'Reflex_Socket'}}


attachment_dic_format = {'$type': 'UAssetAPI.PropertyTypes.ObjectPropertyData, UAssetAPI', 'Name': '3', 'DuplicationIndex': 0, 'Value': -95}


scope_attachments.remove(-75)

# For every item in the table.
for item in data["Exports"][0]["Table"]["Data"]:


    # For every piece of the item data.
    for item_data in item["Value"]:

        # Attachments
        if item_data["Name"] == "AvailableScopeAttachments(0)":
            name = item["Value"][0]["CultureInvariantString"]
            try:
                comp_attachments = weapon_to_attachments[name]
            except:
                continue

            attachments_to_add = []
            for scope in all_scopes:
                if all_scopes[scope] in comp_attachments:
                    attachments_to_add.append(scope)

            for attachment in attachments_to_add:
                copied = copy.deepcopy(attachment_dic_format)
                copied["Value"] = attachment

                if copied not in item_data["Value"]:
                    item_data["Value"].append(copied)
            continue

        elif item_data["Name"] == "AvailableMuzzleAttachments(0)":
            name = item["Value"][0]["CultureInvariantString"]
            try:
                comp_attachments = weapon_to_attachments[name]
            except:
                continue

            attachments_to_add = []
            for muzzle in all_muzzles:
                if all_muzzles[muzzle] in comp_attachments:
                    attachments_to_add.append(muzzle)

            for attachment in attachments_to_add:
                copied = copy.deepcopy(attachment_dic_format)
                copied["Value"] = attachment
                if copied not in item_data["Value"]:
                    item_data["Value"].append(copied)
            continue
        elif item_data["Name"] == "AvailableUnderbarrelAttachments(0)":
            name = item["Value"][0]["CultureInvariantString"]
            try:
                comp_attachments = weapon_to_attachments[name]
            except:
                continue

            attachments_to_add = []
            for under in all_under:
                if all_under[under] in comp_attachments:
                    attachments_to_add.append(under)

            for attachment in attachments_to_add:
                copied = copy.deepcopy(attachment_dic_format)
                copied["Value"] = attachment
                if copied not in item_data["Value"]:
                    item_data["Value"].append(copied)
            continue

json.dump(data, open(f"output/everything_unlocked_itemdatatable.json", "w"))

```

