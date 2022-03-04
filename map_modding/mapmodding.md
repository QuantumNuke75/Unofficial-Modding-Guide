## Map Modding

 
#### Special thanks to:    

`ACowBoyBishop#7664` and `Vegriv#8646` for testing and help! 
Thanks to `matthew9324#3567` for C++ help and RoN Dev `Zack Bower#0466` for FMOD integration.  
Guide written by `The Real Sourc3#7480`.

If you need help don't hesitate to visit the [RoN Custom Maps Discord](https://discord.gg/NGAtrTmXBR) and tag me \:)

### Folder Structure 
Folder structure in UE4 4.27.2 needs to be as shown under to work. Content is the base folder your UE4 projects starts from.

YourProjectName is only a placeholder for what you name your project when you make it in the New Project menu in Epic's UE4 Launcher.
The project name for the Meth house map for example is listed as `RoN_Meth`.

To make a map you should start by downloading the Bare Bones mapping template on [Nexus Mods](https://www.nexusmods.com/readyornot/mods/472?tab=files)  
It includes all the C++ files and Folder Structs like listed below and should provide you with a clean slate to start map modding.  
The Folder struct below is only the nessescary files required for the map to work (using all features) but the Bare Bones includes more files for conveniency.  

```
Content  
    BlueprintSpawners  
      BP_Door.uasset  
    Blueprints  
      DataTables  
        DoorDataTable.uasset   
        DoorType.uasset  
        TrapDataTable.uasset  
        AI_DataTable.uasset  
        AI_DataTable_V3.uasset  
        AI  
          AI_DataTable_Dealer.uasset  
          AI_DataTable_Gas.uasset  
          AI_DataTable_Hotel.uasset  
          AI_DataTable_Meth.uasset  
      Environment  
        BP_Door_New.uasset  
      Games  
        GM_COOP.uasset 
      E_WorldGenType.uasset  
    ReadyOrNot  
      Mods  
        YourProjectName  
          YourMapName.umap  
        // Custom models, materials and textures are placed here in sorted folders.
```

### Project Settings  

Project settings are important when making maps. They tell the engine how to interact with the assets and how they are cooked. When making maps you will need to change some of these to fit what content you want to include in your map. Some of the stuff are not optional. They will break certain elements of your game if they're cooked. Don't worry though - it's nothing permanent. 

Go to the top to *Settings* drop down button and pick **Project Settings** (2nd from the top).  
Navigate to *Packaging* and scroll down to **Ini Section Blacklist** - there will be a tiny bar with an arrow on it to expand the menu further. Click on it and scroll down to *Directories To Never Cook* and add 2 array elements. Edit them with the 3 dots to this:  
![Directories](https://quantumnuke75.github.io/Unofficial-Modding-Guide/images/mapmodding_dontcook.png)

The Folders in the Bare Bones Template that need this treatment are:  
![List of folders](https://quantumnuke75.github.io/Unofficial-Modding-Guide/images/mapmodding_docook.png)

For custom materials to work we need to edit some **Packaging** settings that can be found in **Project Settings**.  
Look for the tick box called *Share Material Shader Code* and make sure it is NOT ticked. It should be ticked off in the BB template by default.  
You're then free to use all kinds of materials with both translucency and emissive properties without the need of instancing game master materials, making Quixel and Megascans importing a lot more user friendly.  

### GameModes

A gamemode blueprint must be constructed manually as no blueprints can be imported from the base game.  
With the Bare Bones project this will be called **GM_COOP**.  
Create an empty GameMode from the GameMode base class and rename it, then place it in the corresponding folder structure listed above. 

#### GameMode Override:   
 At the top of your editor screen you will find the *Blueprints* tab, where you can edit Asset Blueprints and World Blueprints.  
 In order for your game to work you must override the default gamemode and pick **World Override**: and pick your intended gamemode blueprint class.  

### World Geometry:
   If you make a new level instead of using the `ron_wb_combat_01b` included in BB, just note that the standard level of UE4 includes a floor which is a static mesh. This will usually not show up in-game and you'll fall through the world upon launch.  
If you want static / physics meshes in your world you must either reference base game meshes under the ReadyOrNot folder or provide your own in the correct folders.

For prototyping or if you don't have access to a lot of high poly assets it can be desirable to use BSP brushes. These are usually just convex hull geometry that you can piece together. You can actually make most of your map with this, then add models to enhance the level afterwards.  

To make a walkable floor you have to use the *Place Actor* menu's **Geometry** tab and choose the *Box* primitive.  
Use the right side menu to adjust the size of the floor or use the *Brush Editing Mode* (Shift + 4) to adjust the shape and size of your primitive.
You only really need a floor, but it can be favorable to include walls and ceilings to get a sense of scale as well as for AI generation.

A trick would be to use the included `SM_Farm_Door_A` door model to align doorways and ceilings for the scale.

### Lighting
    
Include at least one light if not using the "sun" light standard to the scene. This helps bake the correct lightdata on your geometry. Without any light you can sometimes recieve weird shadow artifacts or weird colors. This also helps those weird people who don't put any attachments on their guns.  

You can add multiple lights in your scene, but adjust the Attenuation Radius so that too many don't overlap. UE4 is very limited when it comes to light overlapping, so you'll need to tinker with this to get a good feel for it.
If a red X is displayed on the light it will not render in the final product or be glitched.

## World Generation and AI Navigation

#### World Gen:  
This is probably one of the more complex steps as it involves messing a bit with the World Blueprint so I made the title a bit bigger.  
In the new update the devs added world generation to custom maps so I will need to test a bit with that, but the previous way to go was to include *RosterScenarioSpawner* and  *WorldDataGenerator* C++ Actors in the map so that they would generate these points. The Bare Bones template should already have this included but if it doesn't or you create a new map from scratch you'll need to add these manually by going to the bottom of the Content section and look for **C++ Classes** and dragging these out into your world.  
(Still need to add more info to this chapter - unfinished)

#### Navigation:
To make the AI know which part of your map is intended to walk on you'll need to set up a volume that touches the floor that you want them to be able to navigate.  
This volume is called *Nav Mesh Bounds Volume* and can be found in the **Volumes** Tab in *Place Actors*. This volume should ideally intersect the walkable floor. Navigation area only generates inside of this volume so make sure that all your walkable floor is encompassed in this volume. It also doesn't matter if the volume is sticking out underneath of the floor or is not the same size, the engine pulls navigation info from the *Project Settings* when it generates paths.  
After building the paths from the **Build** button you can display the walkable paths generated by pressing **P**.  

### Adding Props / Models
1. Locate the prop[s] that you want to use on your map. These will have the .uasset format as any other file. However, make sure the .uasset you are looking at is the static mesh, not texture file or anything else. You can verify this by opening that file in UModel. If the class says `StaticMesh`, you’re good to go.  
An easier route is to download the [Mapping Reference Project](https://www.nexusmods.com/readyornot/mods/666/) made by **RareKiwi** and delete the assets from folder after cooking.
2. Make the folder struct the same as the asset file path.
3. Go to `Place Actors > Basic` and drag the Cube to the Content Browser and click `Copy Here`. You can use this in your level wherever and upon loading into your map, this will turn into the appropriate asset. Only go beyond this step if you want to see the asset within the editor.
4. Export the static mesh you want to use as a .psk using UModel. 
5. Using Blender and the .psk plugin for it, export the model as a .fbx. 
6. Import the .fbx into UE4 with the same name as the asset you are attempting to use within your map. Make sure the file is in the same directory as the sibling file in the game files.

### Adding Doors  
To get a door into the game you place all the provided files into the folder structure as shown above.  
Set up the BP_Door in the Blueprint Editor under BeginPlay like this:  

[Blueprint Pastebin - BP_Door](https://blueprintue.com/render/0cpu2ok8/)  

This will make a **BP_Door_New** entity be spawned at the location of this blueprint with all the provided variables from BP_Door.  
The BP_Door gets these variables from the *DoorDataTable* and the *TrapDataTable* - so if you can’t see these variables be sure to look on the right side and see that the Data Table is linked to the blueprint.  
The red arrow in the BP shows which way the trap will be placed and marks the back side of the door.  

- Place an instance of BP_Door onto the map and change the desired values:  
  - Door Type: Use the *DoorDataTable* in the data table block and select the wanted door.  
  - Trap Type: Doors can have pre-attached traps. The types to choose from comes from the *TrapDataTable* and are Explosive, Flashbang, Alarm, NoTrap. Note that the NoTrap doesn't disable the trap, it makes it random.   
  - Lockchance, can be 0.0 - 1.0 We're unsure if this value does anything, but we would expect higher probability of locking the closer to 1.  
  - Lockable: If the door can be locked or not. If you want a door to always be open you tick this box to False.   
  - NoSpawnTrap: If ticked it will disable any traps from pre-attaching to this door. Leave unticked if you want the *TrapType* to propigate.
  - UseBrokenDoorMesh: We're unsure if this does anything other than spawning the ruined door from the training course in the lobby map.
  - MinOpenClose / MaxOpenClose: Probably has something to do with the max angle the door can swing, but I have yet to notice any difference after changing these values..  

### Multiplayer 

Multiplayer works by default if you place enough spawn points in your map. This spawn point is called *PlayerStart* and you'll need at least 5 for normal multiplayer function.  

### Building and Cooking

At this point the map should be ready for rendering and packaging (you don't really need doors but maps are very lacklusting without).  
You firstly need to Build the data into the map by pressing the *Build* button at the top of the screen. It will take some time to finish.  
Once it is done you can cook the files.

You cook the map so that the game can recognise the level as a playable map.  
Before cooking be sure to select the *Content* folder as the cooker will cook everything down from that folder.

Go to top left at **File** and choose under **Project** -> *Cook Content For Windows*.  
The cooked project will be located in your projects folder under `<yourprojectname>/Saved/Cooked/WindowsNoEditor/`  

To make the map appear in game you must pak the project folder with the pak bat file mentioned in [The Basics](https://quantumnuke75.github.io/Unofficial-Modding-Guide/thebasics.html).
Only pak the Project folder with the **Content** folder inside, not the *MetaData* or *AssetRegistry* and it should work from the mat \:)  
Name the pak to `pakchunk99-Mods-<yourprojectname>_P` - Replace the brackets and what's in them with your project's name.  

### Materials

TODO: Add content to this chapter.  

### Post Processing and visual tech

TODO: Add content to this chapter.  

### FMOD Sound Integation  

WIP! MORE INFO COMING SOON.    
For this you'll need [FMOD for UE4](https://www.fmod.com/download), and the Visual Studio C++ editor. Create a new C++ *Volume* Class file named *ReadyOrNotAudioVolume* and open it in Visual Studio. Paste then this content into the header file (the file named *ReadyOrNotAudioVolume.h*):

```cpp
UCLASS()
class READYORNOT_API AReadyOrNotAudioVolume : public AVolume
{
    GENERATED_BODY()
    
    // Sets default values for this actor's properties
    AReadyOrNotAudioVolume();

    virtual void BeginPlay() override;
    virtual void Tick(float DeltaSeconds) override;

    UPROPERTY(VisibleDefaultsOnly, BlueprintReadOnly, Category = Billboard, meta = (AllowPrivateAccess = "true"))
    UBillboardComponent* BillboardComponent;
    public:    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    TArray<UFMODEvent*> ReverbEvents;

    UPROPERTY()
    TArray<FFMODEventInstance> EventInstances;

    UPROPERTY()
    bool bReverbActivated = false;

    UPROPERTY()
    TArray<UFMODAudioComponent*> AttachedAudioComponents;

    bool IsAnotherVolumeActivatedAndPlayingEvent(UFMODEvent* Event, FFMODEventInstance& EventInstance);
    bool IsAnotherVolumeActivatedAndPlayingEventInst(FFMODEventInstance EventInst);

public:
    bool IsReverbVolumeActivated();
    TArray<UFMODEvent*> GetReverbEvents();
    TArray<FFMODEventInstance> GetReverbEventInstances();
    
};
```
Once you've created the header file and installed FMOD Studio 2.02.03, follow this PDF provided by Zack Bower:  
    [Ambient Implementation](https://quantumnuke75.github.io/Unofficial-Modding-Guide/downloads/fmod.pdf)  
    If you don't know how to install FMOD visit the [RoN Custom Maps Discord](https://discord.gg/NGAtrTmXBR) and check out the *Guides* Links
