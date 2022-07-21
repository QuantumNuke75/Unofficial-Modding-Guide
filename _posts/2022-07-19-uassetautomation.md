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
Once you have a firm understanding of manually editing UAssets, you can semi-easily automate tasks. To start, you'll need some Python, or other programming knowledge. I'll be using Python for this tutorial because of the simple to use json library that comes with Python 3+. I highly recommend doing this if you need to change a lot of data every time the game updates. If you would like specific help with this, ask QuantumNuke75#3593 on Discord. Note that the code down below may not be pretty, as it's gone under numerous changes as the game updates. 


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
Here's an example of the underbarrel attachment list, which we'll be using as an example:
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

And here's an example of the weapon names mapped to attachments (Note: *This list may be outdated.*):
```python
weapon_to_attachments = {'M1911A1':{'RMRPistol_Socket', 'comp_socket', 'supressor_socket', 'light_socket', 'laser_socket', 'SROPistol_Socket', 'flash_socket', 'Reflex_Socket'},
'G19':{'RMRPistol_Socket', 'comp_socket', 'supressor_socket', 'light_socket', 'laser_socket', 'SROPistol_Socket', 'flash_socket', 'Reflex_Socket'}}
```

Now we parse through the `ItemDataTable` and look for the corresponding attachment `AvailableUnderbarrelAttachments(0)`. Once we do, we check the `weapon_to_attachments` dictionary, and add all the attachments to the weapon.
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

Full code below. As a bonus, weapon inertia was also changed for items, making unlocked weapons more usable.
```python
import copy, json

file = open('json/ItemDataTable.json')
data = json.load(file)

all_scopes = {-42:"SRO_FBI_Socket",
-43:"RMR_FBI_Socket",
-44:"RMRPistol_Socket",
-45:"RMR_Socket",
-46:"RMRPistol_Socket",
-47:"SRO_Socket",
-48:"SROPistol_Socket",
-49:"SROPistol_Socket",
-50:"SRORaised_socket",
-51:"Delta_Socket",
-52:"ACOG_Socket",
-53:"atac_Socket",
-54:"HAMR_Socket",
-55:"Harris_Socket",
-56:"M5B_Socket",
-57:"sdr_Socket",
-105:"Scope_Socket",
-106:"Reflex_Socket",
-107:"EXPS3_socket",
-108:"Holosight_XPS3",
-109:"Rail_Socket",
-110:"Rail_Socket",
-111:"Rail_Socket",
-112:"Reflex_Socket",
-113:"Reflex_Socket",
-114:"Reflex_Socket",
-115:"Reflex_Socket",
-116:"Reflex_Socket",
-117:"Reflex_Socket",
-118:"Reflex_Socket",
-119:"MicroT2_Socket",
-120:"MicroT2_FBI_Socket",
-121:"MicroT2Raised_Socket",
-122:"EXPS3_MP5_optic",
-123:"SRO_MP5_optic",
-124:"mp5_optic",
-125:"MicroT2_mp5_optic",
-126:"Reflex_Socket",
-127:"Reflex_Socket",
-128:"Reflex_Socket",
-129:"SRSRaised_socket"}

all_muzzles = {-28:"muzzle_socket",
-29:"asr_socket",
-30:"asr_socket",
-31:"sfmb_socket",
-32:"sfmb_socket",
-33:"shotgunbrake_socket",
-40:"brake_socket",
-60:"socom338_socket",
-61:"tag_mp9suppressor",
-62:"PBS_socket",
-63:"socom338_socket",
-64:"socom338_socket",
-78:"comp_socket",
-79:"comp_socket",
-80:"flash_socket",
-84:"supressor_socket",
-85:"supressor_socket",
-88:"compensator_socket",
-97:"Barrel_Socket",
-100:"Barrel_Socket",
-101:"supressor_socket",
-130:"Choke_Socket",
-131:"tube_socket",
-135:"supressor_socket"}

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

weapon_to_attachments = {'M1911A1':{'RMRPistol_Socket', 'comp_socket', 'supressor_socket', 'light_socket', 'laser_socket', 'SROPistol_Socket', 'flash_socket', 'Reflex_Socket'},
'G19':{'RMRPistol_Socket', 'comp_socket', 'supressor_socket', 'light_socket', 'laser_socket', 'SROPistol_Socket', 'flash_socket', 'Reflex_Socket'},
'G18 Auto':{'light_socket', 'laser_socket', 'comp_socket', 'RMRPistol_Socket', 'supressor_socket', 'flash_socket', 'Reflex_Socket', 'SROPistol_Socket'},
'SKL_Pistol_M92FS':{'light_socket', 'brake_socket', 'comp_socket', 'supressor_socket'},
'P250':{'comp_socket', 'supressor_socket', 'light_socket', 'laser_socket', 'brake_socket'},
'P99':{'comp_socket', 'Delta_Socket', 'supressor_socket', 'laser_socket', 'light_socket', 'flash_socket', 'Reflex_Socket', 'Harris_Socket'},
'.357 Magnum':{'muzzle_socket', 'pointer_socket', 'Reflex_Socket', 'supressor_socket'},
'Taser':{'laser_socket'},
'USP45':{'RMRPistol_Socket', 'comp_socket', 'supressor_socket', 'light_socket', 'laser_socket', 'SROPistol_Socket', 'brake_socket'},
'P92X':{'RMRPistol_Socket', 'supressor_socket', 'light_socket', 'laser_socket', 'SROPistol_Socket', 'brake_socket'},
'G36C':{'asr_socket', 'RMR_Socket', 'pointer_socket', 'HAMR_Socket', 'laser_socket', 'light_socket', 'combat_grip', 'socom338_socket', 'M5B_Socket', 'sfmb_socket', 'foregrip_socket', 'EXPS3_socket', 'SRO_Socket', 'Reflex_Socket'},
'M14':{'Rail_Socket', 'foregrip_socket', 'laser_socket', 'supressor_socket'},
'M24':{'ACOG_Socket', 'Scope_Socket', 'Reflex_Socket', 'supressor_socket'},
'M4A1':{'asr_socket', 'pointer_socket', 'HAMR_Socket', 'ACOG_Socket', 'supressor_socket', 'MicroT2Raised_Socket', 'laser_socket', 'light_socket', 'combat_grip', 'compensator_socket', 'M5B_Socket', 'sfmb_socket', 'socom338_socket', 'foregrip_socket', 'Reflex_Socket'},
'AK102':{'pointer_socket', 'HAMR_Socket', 'ACOG_Socket', 'supressor_socket', 'laser_socket', 'light_socket', 'foregrip_socket', 'Reflex_Socket', 'Harris_Socket'},
'MK1 Carbine':{'asr_socket', 'pointer_socket', 'SRSRaised_socket', 'laser_socket', 'socom338_socket', 'combat_grip', 'sfmb_socket', 'foregrip_socket'},
'ARN-18':{'asr_socket', 'laser_socket', 'socom338_socket', 'combat_grip', 'sfmb_socket', 'EXPS3_socket', 'vfg_mlok_grip', 'Reflex_Socket', 'afg_mlok_grip'},
'SA-58':{'asr_socket', 'sdr_Socket', 'pointer_socket', 'MicroT2Raised_Socket', 'laser_socket', 'light_socket', 'combat_grip', 'socom338_socket', 'M5B_Socket', 'sfmb_socket', 'foregrip_socket', 'EXPS3_socket', 'SRO_Socket', 'atac_Socket', 'Reflex_Socket'},
'GA416':{'asr_socket', 'sdr_Socket', 'pointer_socket', 'ACOG_Socket', 'SRSRaised_socket', 'laser_socket', 'socom338_socket', 'combat_grip', 'M5B_Socket', 'sfmb_socket', 'EXPS3_socket', 'vfg_mlok_grip', 'atac_Socket', 'Reflex_Socket', 'afg_mlok_grip'},
'M16A4':{'HAMR_Socket', 'ACOG_Socket', 'Scope_Socket', 'supressor_socket', 'Reflex_Socket'},
'SCAR-H':{'asr_socket', 'pointer_socket', 'SRSRaised_socket', 'socom338_socket', 'combat_grip', 'sfmb_socket', 'foregrip_socket', 'atac_Socket'},
'SLR47':{'pointer_socket', 'laser_socket', 'combat_grip', 'PBS_socket', 'afg_mlok_grip'},
'SR-16':{'asr_socket', 'Harris_Socket', 'pointer_socket', 'HAMR_Socket', 'ACOG_Socket', 'supressor_socket', 'SRSRaised_socket', 'laser_socket', 'light_socket', 'combat_grip', 'socom338_socket', 'M5B_Socket', 'sfmb_socket', 'foregrip_socket', 'EXPS3_socket', 'vfg_mlok_grip', 'Reflex_Socket', 'afg_mlok_grip'},
'Pepperball Gun':{'pointer_socket', 'combat_grip', 'M5B_Socket', 'foregrip_socket', 'Reflex_Socket'},
'B1301':{'Choke_Socket', 'MicroT2_Socket', 'RMR_Socket', 'pointer_socket', 'shotgunbrake_socket', 'SRO_FBI_Socket', 'RMR_FBI_Socket', 'MicroT2_FBI_Socket', 'brake_socket', 'SRO_Socket'},
'B1301 "Entryman"':{'Choke_Socket', 'MicroT2_Socket', 'RMR_Socket', 'pointer_socket', 'shotgunbrake_socket', 'SRO_FBI_Socket', 'RMR_FBI_Socket', 'MicroT2_FBI_Socket', 'brake_socket', 'SRO_Socket'},
'M4 Super 90':{'Choke_Socket', 'Barrel_Socket', 'supressor_socket', 'light_socket', 'foregrip_socket', 'Reflex_Socket'},
'M590-A':{'tube_socket', 'supressor_socket', 'light_socket', 'foregrip_socket', 'Reflex_Socket'},
'Saiga 12':{'pointer_socket', 'Reflex_Socket'},
'870 CQB':{'RMR_Socket', 'supressor_socket', 'light_socket', 'shotgunbrake_socket', 'brake_socket', 'SRO_Socket', 'Reflex_Socket'},
'MP5/10MM':{'MicroT2_Socket', 'RMR_Socket', 'pointer_socket', 'laser_socket', 'foregrip_VFG_socket', 'combat_grip', 'socom338_socket', 'foregrip_socket', 'SRO_Socket'},
'MP5A3':{'MicroT2_Socket', 'RMR_Socket', 'pointer_socket', 'laser_socket', 'foregrip_VFG_socket', 'combat_grip', 'socom338_socket', 'foregrip_socket', 'EXPS3_socket', 'SRO_Socket'},
'MP9':{'MicroT2_Socket', 'RMR_Socket', 'pointer_socket', 'tag_mp9suppressor', 'laser_socket', 'SRO_Socket'},
'MPX':{'pointer_socket', 'supressor_socket', 'light_socket', 'socom338_socket', 'combat_grip', 'SRORaised_socket', 'vfg_mlok_grip', 'Reflex_Socket', 'afg_mlok_grip'},
'P90':{'RMR_Socket', 'pointer_socket', 'socom338_socket', 'light_socket', 'Reflex_Socket'},
'57 USG':{'RMRPistol_Socket', 'supressor_socket', 'light_socket', 'laser_socket', 'socom338_socket', 'SROPistol_Socket'},
'MK16':{'asr_socket', 'Barrel_Socket', 'pointer_socket', 'HAMR_Socket', 'supressor_socket', 'MicroT2Raised_Socket', 'laser_socket', 'light_socket', 'socom338_socket', 'compensator_socket', 'sfmb_socket', 'foregrip_socket', 'Reflex_Socket', 'Harris_Socket'},
'ARWC':{'asr_socket', 'sdr_Socket', 'pointer_socket', 'HAMR_Socket', 'SRSRaised_socket', 'laser_socket', 'light_socket', 'combat_grip', 'socom338_socket', 'sfmb_socket', 'EXPS3_socket', 'vfg_mlok_grip', 'atac_Socket', 'Reflex_Socket', 'afg_mlok_grip'},
'UMP-45':{'comp_socket', 'pointer_socket', 'supressor_socket', 'MicroT2Raised_Socket', 'SRSRaised_socket', 'laser_socket', 'light_socket', 'combat_grip', 'SRORaised_socket', 'foregrip_socket', 'EXPS3_socket', 'Reflex_Socket'},
'PFC9':{'SROPistol_Socket', 'laser_socket', 'comp_socket', 'light_socket', 'RMRPistol_Socket', 'supressor_socket'}}

attachment_dic_format = {'$type': 'UAssetAPI.PropertyTypes.ObjectPropertyData, UAssetAPI', 'Name': '3', 'DuplicationIndex': 0, 'Value': -95}


# For every item in the table.
for item in data["Exports"][0]["Table"]["Data"]:


    # For every piece of the item data.
    for item_data in item["Value"]:

        #
        # Set inertia
        #
        if item_data["Name"] == "InertiaDragAimRotation(0)":
            item_data["Value"] = 0.8
            continue
        elif item_data["Name"] == "InertiaDragAimLocation(0)":
            item_data["Value"] = 0.15
            continue
        elif item_data["Name"] == "InertiaDragStrafeRotation(0)":
            item_data["Value"] = 0.4
            continue
        elif item_data["Name"] == "InertiaDragStrafeLocation(0)":
            item_data["Value"] = 0.2
            continue


        # Attachments
        elif item_data["Name"] == "AvailableScopeAttachments(0)":
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

