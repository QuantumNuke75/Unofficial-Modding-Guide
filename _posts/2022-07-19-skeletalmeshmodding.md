---
title: Skeletal Mesh Modding
date: 2022-07-19 00:00:00 +0000
categories: [Skeletal Mesh Modding]
tags: [skeletal mesh]
---

## Skeletal Mesh Modding

### Skeletal Mesh Replacement 
1. Extract the model as a .psk using UModel.
2. Import file into Blender using the [Blender PSK plugin](https://unofficial-modding-guide.com/posts/tools).
3. Change the units into Metric, Meters, with a scale of 0.01.
4. Scale the model and skeleton by 100.
5. Unparent the skeleton from the model.
6. Import the model you want to replace the normal model with, and resize it to fit properly.
7. Delete the old model. And apply all transforms with Ctrl + A.
8. Parent the skeleton to the new model using Ctrl + P. I recommend not automatically weight painting, and doing everything manually. Also make sure the root bone is the correct one. For guns this should be `J_Gun`. For other skeletal meshes, this will be something different. You can view the root bone in UModel. If you have another bone as the root, rename it to `Armature`, this makes Blender ignore that bone.
9. Paint the weights accordingly. For guns you’ll most likely want to paint each moving piece with a value of 1.0.
10. Export the file as an .fbx without leaf bones.
11. Import the file into UE4.
12. In order to make material files work, they must be instances of preexisting materials in the game. Instance a material, edit as you would like. Hook up your texture assets. This will be talked about in [Material Replacement](https://unofficial-modding-guide.com/posts/materialmodding).
13. Cook the content, and put the texture, material, and mesh files in the correct places. 
14. Make sure to add a `_P` to the end of your .pak file name. This makes it a patch file.
