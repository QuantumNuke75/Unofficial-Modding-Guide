## Important Information

### Mod Installation  
Navigate to `<GameInstallLocation>\Ready Or Not\ReadyOrNot\Content\Paks` and put your .pak file there. Ensure that the .pak load order is correct.

### Understanding the File Structure  
Let's make this braindead easy. When creating a project in Unreal Engine 4, the project will be saved to a directory. Within that directory will be the project. For example: `<SaveDirectory>/<ProjectName>/…`. `<ProjectName>` houses all of the contents of the Unreal Engine 4 project. In that project folder, there will be a subfolder named `Content`. That folder houses all of the assets and blueprints within a game.

In the case of Ready or Not, the project name is `ReadyOrNot`. Within that folder, there is a folder called `Content`. Again, this houses everything inside a game except for configuration files. However, when you open the game files in UModel, there may not be a `Content` folder, instead, it’ll have been replaced with a `Game` folder. When .paking your mod, you should replace `Game` with `Content`. Any of the sub folders will remain the same.

The majority of the modding that you will do will be under the `Content` folder. If a file that you are looking to override is in `.../ReadyOrNot/Game/ReadyOrNot/Assets/Weapons/Python`, the file path to copy would be `.../Content/ReadyOrNot/Assets/Weapons/Python`.

### File Formats  
There are multiple different file formats that you may encounter while modding. Here is a list of most of them, and what each of them are.
- .psk - A skeletal or static mesh. May contain the skeleton.
- .psa - An animation for a specific mesh.
- .uasset - Two types.
  1. Raw .uasset files are the ones created after cooking a UE4 project. 
  2. UE4 .uasset files are the ones that are taken directly from a UE4 project, they are uncooked and can be transferred between projects.
- .uexp - An raw complementary file to uassets, usually containing import and export maps.
- .ubulk - Another data storage file that UE4 uses. 
- .umap - A level/map file, similar to .uasset in the way that there is an uncooked and cooked version.

### Example Mod  
To see if your PAKing is working, download this [example mod](https://drive.google.com/file/d/1iSbu8JqFbry1lioBEIuB5ks0D8bhKQ7c/view?usp=sharing). This will turn your gun on the main menu pink if the .pak is correctly PAKed. Download and extract the .zip file before PAKing. 

### Debugging  
The best way to debug any issues is to use the builtin UnrealPak.exe. Simply open this with cmd with the line: `unreakpak.exe -List This_Is_A_Pak.pak`. Look at the mounting point. If you have a single innermost directory that contains all your files, and the mounting point is that directory, you are fine. Otherwise, with multiple directories, the mounting point should be `../../../ReadyOrNot/`.
