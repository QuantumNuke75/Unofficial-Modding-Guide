## The Basics

**Extracting Game Files**  
There are two methods of easily accessing the files within the game. One will be covered as it remains the best method. That is to use UModel, directing it towards the location of the .pak files within Ready or Not: `<GameInstallLocation>\Ready Or Not\ReadyOrNot\Content\Paks`. This will allow you to extract almost anything you want. Texture files will be in .tga, and models should be in .psk.

**Cooking Modified Files**  
In order to override any assets within the game or add new content, the files must be in a format that the game can recognize. The files you extracted via UModel will be in a format that is easily accessible by you, not the game. You will first need to cook these before PAKing the files.

1. Install the latest version of Unreal Engine 4.27. The current latest version is 4.27.2.
2. Import all the files you want to pack with your mod into a new blank project. Any other template can work, but will result in significantly longer cooking times.
3. Go to `File > Cook Content for Windows`. This converts the files into a UE4 exported format. Retrieve the cooked files in `<ProjectLocation/><ProjectName>/Saved/Cooked/WindowsNoEditor/`.

  
