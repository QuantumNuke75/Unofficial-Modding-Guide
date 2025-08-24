---
title: Custom Difficulty for Custom Levels
date: 2025-08-17 00:00:00 +0000
categories: [Map Modding]
tags: [mapping]
description: How to create custom difficulties for custom levels.
author: RareKiwi
pin: false
hidden: false
---

<style>
.embed-video {
  width: 100%;
  height: 100%;
  margin-bottom: 1rem;
  aspect-ratio: 16 / 9;

  @extend %rounded;

  &.file {
    display: block;
    width: auto;
    height: auto;
    max-width: 100%;
    max-height: 100%;
    margin: auto;
    margin-bottom: 0;
  }

  @extend %img-caption;
}
</style>

# Custom Map Difficulty Overview

With the Los Suenos Stories update, the AILevelData.ini was refactored into three Difficulty.ini  

Custom difficulties can also be created and included with your map pak. 
This can be loaded with your map, without other map or mods conflicting. 
Users/other modders can also create patch `_P` difficulty paks specifically for your map if they want to tweak the experience.

This means, optionally, you can stop using the BP_SpawnManager_v3 and instead use the game's native spawn Min and Max configs as well as spawn groups. 

This also lets you configure much more such as

 - The number of bomb actors so you don't need a BP_BombSpawner either. Also bomb times.
 - The number of roaming suspects or civs
 - Open doors percentage
 - Locked doors percentage
 - The max amount of traps and pre-placed traps
 - Allowed trap types
 - Explosive vest civs and suspects
 - AS timers

# Setup

## A) Gameplay Tags

Unreal gameplay tags are used as the "key" values in the gameplay code, so we need to add one for each new difficulty.

1. In Unreal Engine, open Project Settings > Gameplay Tags
2. Open `Manage Gameplay Tags...`
3. Select `CustomDifficulty` and press the `+` plus icon.
4. Name your new tag CustomDifficulty.MAPNAME.DIFFLEVEL  
	 > If your just creating one difficulty, just use CustomDifficulty.MAPNAME.Standard  
	 > If you want one for each diff add a `Standard`, `Casual`, and `Hard`  
	 {: .prompt-tip }
 
	 > The name doesn't matter, however **DO NOT** create your tags under the base *Difficulty* group as this will make it show in the selector for players in quickplay for example, which is not how we want to use it.  
	 {: .prompt-warning }
	 > Make sure you create the new diff in the `MyCustomGameplayTags.ini` source. You can find this in your configs and can migrate it when the framework updates.
	 {: .prompt-warning }
	
![Copy Difficulties](/assets/gameplayTags_Difficulty.png){: w="576" h="474" }
	
## B) Difficulty.ini

1. In your project's `/Config/Difficulties/` create your new difficulty either by renaming/copying the example *CustomMapDifficulty_RoN_Difficulty_Standard.ini*
or export a difficulty from the game files using FModel.
2. Rename your new difficulty CustomMapDifficulty_MAPNAME_DIFFLEVEL.ini
	 > This name doesn't matter, just a suggested convention.  
	 {: .prompt-info }
	 > Delete the example difficulty if you don't want to do it every time you cook your map.  
	 {: .prompt-tip }
3. Open the new diff to edit.
4. Set `DifficultyGameplayTag = ` to the tag you created in [Step A)](#a-gameplay-tags).
5. Also edit the tag in `GameplayTagList` to the tag you created, within `""`.   
	```ini
	[Info]
	DifficultyGameplayTag = CustomDifficulty.ExampleMap.Standard
	DifficultyNameKey = 
	DifficultyDescriptionKey = DO NOT USE

	[/Script/GameplayTags.GameplayTagsList]
	GameplayTagList=(Tag="CustomDifficulty.ExampleMap.Standard",DevComment="")
	```
	{: file="Example ini header" }
6. At the bottom of the ini, add the file name of your custom level with square brackets `[]`.  
	 If you copied the example ini, you can replace "[RoN_DifficultyExampleMap]"
7. Add your map configs below this header and save the file.  
	```ini 
	[RoN_DifficultyExampleMap]
	MinCivilians = 1
	MaxCivilians = 10
	MinSuspects = 1
	MaxSuspects = 10
	UseSpawnGroups = true
	MinSuspects_Group1 = 1
	MinSuspects_Group1 = 3
	MinCivilians_Group1 = 1
	MaxCivilians_Group1 = 1 ; use semi colons for comments
	```
	{: file="Example map section" }
	
## C) Map Setup

1. Delete your spawn manager or set `Is Editor Only Actor = True`, so it won't interfere.
2. For AI spawns, you won't be using `Spawn with Tags` for groups. 
	 - Instead, set the `Group ID` to the number at the end of `MinSuspects_Group` or `MinSuspects_Group` etc that you defined in your CustomDifficulty.ini  
	 - I'd recommend NOT using group 0, so that your sure your changes are working.
	 - If your not using groups, then nothing needs to be set. Civs and suspects will spawn according to the Min/MaxCivilians and Min/MaxSuspects values.
	 ![Copy Difficulties](/assets/difficulty_aispawn.png){: w="610" h="275" }
	 
3. To load your custom diff, place a `/Content/Mods/Template/Blueprints/BP_LoadCustomDifficulty` blueprint in your level.
4. Set the `Fallback Difficulty` to the tag you created in [Step A)](#a-gameplay-tags).
5. Expand the `Difficulty Map` fully (shift + click).
	 - For the value of each key, add your custom gameplay tag.
	 - If you created 3 difficulties, map each to the relevant vanilla gameplay tag.  
	 This lets the user pick which they want to use based on their vanilla selection.
	 ![Copy Difficulties](/assets/difficulty_BP_LoadCustomDifficulty.png){: w="613" h="389" }
	 
## D) Cooking

By default, unreal won't copy the `/Config/Difficulties/` folder.  
To make things easier, we added a custom cook button to the level editor toolbar.  
After cooking is completed, **/Config/Difficulties/** is copied to your cooked folder, next to content.

To include your CustomDifficulty.ini 
1. Press the Custom cook button:   ![Custom Cook](/assets/CookIcon.png){: w="24" h="24" }
	 > You can see successful copy actions in the output log.  
	 
	 > You can disable the custom cook copy step in **Project Settings > Plugins > Framework Plugin Settings**  
	 {: .prompt-info }
	 
2. When copying your cooked files to be paked, be sure to copy both `/Content` and `/Config` to your staged mod folder.
3. If you want to copy without cooking, press the `Copy Difficulties` button:   ![Copy Difficulties](/assets/CopyDiff.png){: w="24" h="24" }
	 > You can see successful copy actions in the output log.  
	 
	 > You can use this to make changes to your CustomDifficulty.ini if your content is unchanged.  
	 {: .prompt-info }
4. Play your map in game to confirm your config has loaded.