---
title: Sound Modding
date: 2022-07-19 00:00:00 +0000
categories: [Sound Modding]
tags: [sound, fmod]
description: A guide on how to replace various sound files within the game.
author: "QuantumNuke75|https://www.nexusmods.com/users/62784961,UMG|https://unofficial-modding-guide.com,RareKiwi|https://discordapp.com/users/RareKiwi#5360"
---

## Sound Modding

### Voiceover Modding  
Voice over modding is incredibly easy.  
Simply navigate to `…/Ready Or Not/ReadyOrNot/Content/VO/…` and replace any lines you wish to replace.

### FMOD Modding with FMOD Bank Tool

> FMOD Bank Tool will only work on the first FSB in a bank. See below for compatible single FSB banks; 
{: .prompt-info }
> CmndMenu, Data Center, Dealer Level, Farm Level, Fast Food, Gas Level, Hotel Civ Lines, Importer Level, Killhouse Level, Lobby Level, MainMenu, Meth Apartments, Meth Level, Police Station Level, Port Level, PVP Lines, Ridgeline, RUS, School Level, SWAT Lines, Training Level


1. Extract an FMOD Bank with [FMOD Bank Tool](/posts/tools/#fmod-bank-tools) from `.../Ready Or Not/ReadyOrNot/Content/FMOD/Desktop/…`.
2. Edit or replace any sounds you wish. Make sure the file you are replacing with is the same format as the original file.
3. Using FMOD Bank Tools, repack all the files and replace the FMOD Bank within the game files.

### FMOD Modding with Bank Injection and FSB tools

> Use this method for banks with multiple .fsb and .wav files. See below for notable multi-FSB banks; 
{: .prompt-info }
> Agency, Club, Global Amb, Hospital, Hotel Level, Interactions, Master, Penthouse, Shield, SWAT, Tools, UI, Valley Level, Weapons

#### Bank and FSB Extraction
1. Setup a directory to extract and repack from with no file permission issues.  
I'm working from `C:/Files/ronFMOD/`  
Put your FMOD tool folders here ([bmsbank](/posts/tools/#bmsbank) and [fsbext](/posts/tools/#fsb-files-extractor-fsbext)) for ease of use.  
Also create a `/banks` or individual project folder.
```
/ronFMOD
    /banks
    /bmsbank
    /fsbext
```
2. Copy `.bank` file/s from the game's install location to your `/banks` folder  
> `.bank` are located in `.../Ready Or Not/ReadyOrNot/Content/FMOD/Desktop/`{: .filepath}
3. Open the `/bmsbank` tool folder in another window, then drag a bank from `/banks` onto `/bmsbank/extractBank.bat`  
> Usually two `.fsb` files should now be in `/banks/out/<BANKNAME>/`{: .filepath}  
`00000000.fsb`{: .filepath} and `00000001.fsb`{: .filepath} for example
4. Navigate to `/banks/out/<BANKNAME>/`  
Open the `/fsbext` folder in another window,  
Drag the `.fsb` containing desired audio onto `/fsbext/extractFSB.bat`
> For weapon SFX it is `00000001.fsb`{: .filepath}  
> A `.dat` file will be created for rebuilding the fsb later.  
> Extracted audio files should be in `/banks/out/<BANKNAME>/<FSBNAME>/`{: .filepath}  and `.wav`, not `.ogg` file format.

> Windows will optimize the folder to music, reducing navigation speed and sorting. You can change the properties on this folder or all sub directories of `/ronFMOD` to General.  
![explorerFolderCustomize](/assets/explorerFolderCustomize.png){: .left }
{: .prompt-tip }

#### Audio Editing

- Use a program such as [Audacity](/posts/tools/#audacity) to open, edit and export your .wav files
- Audio length needs to match the source
- Project Rate is usually 48000Hz
- Encoding needs to match the source which for RoN .wav, I think, is Signed 16-bit PCM. Check file sizes are identical to confirm.
- Video of [mostly relevant Audacity editing](https://youtu.be/l5Zgiuehrks?t=624)

#### FSB Rebuild and Bank Injection

1. Navigate to `/banks/out/<BANKNAME>/`  
With the `/fsbext` folder open in another window, drag `<FSBNAME>.dat` onto `/fsbext/makeFSB.bat`
> For weapon SFX it is `00000001.dat`{: .filepath}
2. Navigate to `/banks/out/<BANKNAME>/new/`  
Copy your new `fsb` to `/banks/in/<BANKNAME>/`
> Confirm the size is identical to the original just outside of `/new`
3. Navigate to `/banks/`  
With the `/bmsbank` folder open in another window, drag your `.bank` onto `/fsbext/makeFSB.bat` to inject your modified `.fsb` into the file.
4. Backup the original `.bank` from `.../Ready Or Not/ReadyOrNot/Content/FMOD/Desktop/`
> Change the file extension of your backup to something else like `.bankoriginal`{: .filepath} for example to keep it in the same folder.
5. Copy your injected `.bank` file from `/banks` to your games `.../FMOD/Desktop/` folder.  
Confirm the filesize matches the original file.
