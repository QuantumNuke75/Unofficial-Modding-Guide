## Map Modding

**Creating a Map**  
1. Create a Level, or acquire one from elsewhere. 
2. In `/Content/Blueprints/Games/COOPModes/`, create a fake gamemode that replicated the name of any one of these from Ready or Not: GM_COOP_ActiveShooter, GM_COOP_BarricadedSuspects, GM_COOP_BombThreat, GM_COOP_HostageRescue, GM_COOP_Raid.
3. Open your level, and at the top-ish of the editor press `Blueprints` and select the `World Override` gamemode to be the one that you just created.
4. At this point the level can be played via the method in Misc.

**Adding Props from the Game**  
1. Locate the prop[s] that you want to use on your map. These will have the .uasset format as any other file. However, make sure the .uasset you are looking at is the static mesh, not texture file or anything else. You can verify this by opening that file in UModel. If the class says `StaticMesh`, you’re good to go.
2. Mimic the location of the folder structure in UE4 up to the location of the asset.
3. Go to `Place Actors > Basic` and drag the Cube to the Content Browser and click `Copy Here`. You can use this in your level wherever and upon loading into your map, this will turn into the appropriate asset. Only go beyond this step if you want to see the asset within the editor.
4. Export the static mesh you want to use as a .psk using UModel. 
5. Using Blender and the .psk plugin for it, export the model as a .fbx. 
6. Import the .fbx into UE4 with the same name as the asset you are attempting to use within your map. Make sure the file is in the same directory as the sibling file in the game files.

**Adding Doors**  
Note that the following files may be changed on a daily basis as they get more updates. Credit to Lewd SCP-1471-A#0880 for some assistance.
1. Download the following files from [here](https://drive.google.com/file/d/1wmxcIwHvz_2T4bVMNsyWJPVEmVt-WDZ0/view?usp=sharing) and put them in their associated directory:  
  a. BP_Door, goes in `.../Content/BlueprintSpawners/…`, do package.  
  b. BP_Door_New, goes in `.../Content/Blueprints/Environment/…`, do not package.  
  c. DoorDataTable, goes in `.../Content/Blueprints/DataTables/…`, do not package.  
  d. DoorDataTableStructure, goes in `.../Content/Blueprints/DataTables/…`, do not package.  
  e. TrapDataTable, goes in `.../Content/Blueprints/DataTables/…`, do not package.  
  f. TrapDataTableStructure, goes in `.../Content/Blueprints/DataTables/…`, do not package.  
2. Place an instance of BP_Door onto the map and change the desired values:  
  a. Door Type, can be: Default_Wood, Meth_Garage_01, Meth_Garage_02,  Meth_Wood_01, Meth_Wood_02, Meth_Wood_Slat, Hotel_Wood_01, Hotel_Wood_02, Hotel_Wood_03, Hotel_Steel_01, Hotel_Steel_02, Hotel_Steel_03, Hotel_Wood_04, Gas_Metal_01, Port_Metal_01, Wood_Door_Painted, Wood_Door_Unpainted, Wood_Door_Fancy, Port_ShippingDoor_Right, Port_ShippingDoor_Left, Port_Jaildoor, Port_Chaindoor.   
  b. Trap Type, can be: Explosive, Flashbang, Alarm, NoTrap.  
  c. Lockchance, can be 0.0 - 1.0. Currently, this value does not work.  
  d. Doorway Mesh, the static mesh location of the mesh to be used as the doorway. You can do this through adding props.  

**Easier Loading / Multiplayer**  
In a recent Ready or Not update, the developers have mad map modding more seamlessly integrated with the game. You are no longer required to override maps within the game,
and are encouraged not to do so. You'll still need to add at least 5 player starts in order ot prevent players from clipping into eachother.

**General Mapping Tips**  
- In order to efficiently make level geometry, use BSP Brushes.
- To make Swat AI move around, ensure that you have at least one Nav Mesh Bounds Volume.

**FMOD Sound Integation**  
For this you'll need UE4 FMOD integration, as well as a good understanding of UE4. Create a header file named `ReadyOrNotAudioVolume.h` with the following contents:
```C++
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
Once you've creatd the header file, follow this PDF provided by Zack Bower:
<embed src="https://quantumnuke75.github.io/Unofficial-Modding-Guide/downloads/fmod.pdf" type="application/pdf" />
