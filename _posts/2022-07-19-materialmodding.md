---
title: Material Modding
date: 2022-07-19 00:00:00 +0000
categories: [Material Modding]
tags: [material]
---

## Material Modding

### Material Replacement  
1. Using FModel, locate the master material you wish to use. Ensure that the material name somewhat correlates to what you are modding. For example, an attachment should have the master material `Weapon_1P_Toprain_MASTER`. Alternatively, you can use UModel to export the material and look at the .txt file.
2. In that file, while still using FModel, locate three parameters. These parameters will point to the Normal, Texture, and ORM maps. If you are using UModel instead, you can also view these parameters.
3. In UE4, create a fake master material with the same name in the same location as where it is within the game. You will not be exporting this file unless you uncheck the `Share Material Shader Code` in `Project Settings > Packaging`.
4. In that master material, make sure to create three texture parameters named the same as the parameters you found using FModel or UModel. Make sure to hook up these nodes accordingly.
5. Create a new material instance with the master material being the `Parent`, and pass in the relevant Normal, Texture, and ORM maps.
6. Assign this material to the model you are overriding. 
