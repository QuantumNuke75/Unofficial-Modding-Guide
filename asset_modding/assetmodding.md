## Asset Modding


### Texture Replacement  
Texture replacement is the easiest to mod. An example can be found in [PAK Example](importantinformation.md). If you are doing more than recoloring, you will also need to edit the normal and ORM maps.
1. When ripping files from the game, look for files that contain `T_`, `BaseColor`, `_B`, as these files are usually the texture files. 
2. Modify the texture however you would like with GIMP, Photoshop, or any other image editing software. You can also use Substance Painter, and doing such will make texturing much easier. 
3. As with overriding any other object from the game, make sure to replicate the location of the texture. If you don’t, the changes won’t apply.
4. Create a .pak file, and everything should work properly. 

### Skeletal Mesh Replacement Pt. 1  
1. Extract the model as a .psk using UModel.
2. Import file into Blender.
3. Change the units into Metric, Meters, with a scale of 0.01.
4. Scale the model and skeleton by 100.
5. Unparent the skeleton from the model.
6. Import the model you want to replace the normal model with, and resize it to fit properly.
7. Delete the old model. And apply all transforms with Ctrl + A.
8. Parent the skeleton to the new model using Ctrl + P. I recommend not automatically weight painting, and doing everything manually. Also make sure the root bone is the correct one. For guns this should be `J_Gun`. For other skeletal meshes, this will be something different. You can view the root bone in UModel. If you have another bone as the root, rename it to `Armature`, this makes Blender ignore that bone.
9. Paint the weights accordingly. For guns you’ll most likely want to paint each moving piece with a value of 1.0.
10. Export the file as an .fbx without leaf bones.
11. Import the file into UE4.
12. In order to make material files work, they must be instances of preexisting materials in the game. Instance a material, edit as you would like. Hook up your texture assets. This will be talked about in part two.
13. Cook the content, and put the texture, material, and mesh files in the correct places. 
14. Make sure to add a `_P` to the end of your .pak file name. This makes it a patch file.

### Skeletal Mesh Replacement Pt. 2 / Material Replacement  
1. Using FModel, locate the master material you wish to use. Ensure that the material name somewhat correlates to what you are modding. For example, an attachment should have the master material `Weapon_1P_Toprain_MASTER`. Alternatively, you can use UModel to export the material and look at the .txt file.
2. In that file, while still using FModel, locate three parameters. These parameters will point to the Normal, Texture, and ORM maps. If you are using UModel instead, you can also view these parameters.
3. In UE4, create a fake master material with the same name in the same location as where it is within the game. You will not be exporting this file unless you uncheck the `Share Material Shader Code` in `Project Settings > Packaging`.
4. In that master material, make sure to create three texture parameters named the same as the parameters you found using FModel or UModel. Make sure to hook up these nodes accordingly.
5. Create a new material instance with the master material being the `Parent`, and pass in the relevant Normal, Texture, and ORM maps.
6. Assign this material to the model you are overriding. 
