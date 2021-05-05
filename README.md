# MIB STD2 Toolbox
⚠️ **Currently is working only on MIB STD2 PQ/ZR Technisat/Preh and is NOT COMPATIBLE with MIB2 STD Delphi and MIB2 HIGH Harman units!** ⚠️

## Disclaimer
WE ARE NOT RESPONSIBLE FOR ANY DAMAGE OF YOUR UNIT. YOU ARE DOING EVERYTHING AT YOUR OWN RISK! READ THIS README, USE YOUR BRAIN AND BE CAREFUL!

## Requirements
- Any OBD2 adapter with a software that can enable developer mode (Green Engineering Menu) on the unit
- Empty FAT32 formatted SD card or USB flashdrive, with enough space to save your backups. Everything bigger than 1GB is recommended

## How to install from SD card via "Service Mode" on supported units with navigation
1. Unzip `MIBSTD2-Toolbox-vX.X.X.zip` to the root of SD card. 

NOTE: Additionally, **ONLY** for firmwares 02xx with GEM 3.5, replace `cpu` folder in the root of the SD card with `cpu` folder from `\toolbox\gem` folder.
2. Turn on ignition and insert SD card into slot 1 of the unit
3. Press and hold MENU button to open `Service Mode -> Software Update` and install `MIBStd2_Online_Approval`.
4. Open Green Engineering Menu and have fun 🙂

Note: This installation method is NOT possible on Seat Navi units with HW H50+ (firmwares 05xx) as metainfo2.txt does not contain variants 47213, 47214, 47215, 47216 and cannot just be edited (because of digital signature at the end of the file).

## How to install via serial console or telnet
1. Unzip `MIBSTD2-Toolbox-vX.X.X.zip` to the root of SD card or USB drive
2. Delete `metainfo2.txt`, this helps to avoid endless reading spinner when connecting USB drive to the unit.
3. Login via console/telnet as root/root
4. Insert SD card or connect USB drive to the unit
5. Enter `mount` to see where inserted card/connected drive is mounted. Usually /media/mp000 is slot SD1, /media/mp001 slot SD2, /media/mp002 port USB1 and so on.
6. Run `ksh /media/mp000/install.sh` to install the toolbox. GEM 3.5 will be automatically updated if found.
7. Open Green Engineering Menu and have fun 🙂

## How to use the toolbox to do customizations
1. Use `dump` menu to copy files from unit's filesystem into corresponding `dump` subfolder on SD card or USB drive 
2. Modify those files as you wish and copy into corresponding `custom` subfolder on SD card or USB drive
3. Use `customization` menu to copy modified files back to unit's filesystem  

NOTE: Every time you copy files to the unit, scripts will make a backup of original files to `backup` folder on SD card/USB drive. Any time later you can use `restore` functions to revert changes. 

⚠️ **DO NOT TOUCH FILES IN THE BACKUP FOLDER!!** ⚠️

### Menu overview
```
MIB STD2 Toolbox Main
+---About
|   +---Disclaimer                      # Disclaimer and mentioning of involved people
|   +---History                         # Version history of the toolbox
+---Customization                       # Customization features
|   +---Adaptation                      # View and change adaptation of the unit
|       +---Car_BAP_device_list   
|       +---Car_CAN_device_list    
|       +---Car_device_BUS
|       +---Car_menu_operations         
|   +---Advanced                        # Patching stuff like SWDL, SWAP, HMI CP and more
|   +---GreenMenu                       # Import custom GreenMenus and scripts
|   +---Mirror-link                     # Unlock apps while driving
|   +---Navi                            # Unlock SD card usage from every brand and more
|   +---Skins                           # Modify skins
|   +---Sounds                          # Modify ringtones and system sounds
|   +---Update                          # Enable manual SWDL
|
+---Dump                                # Dump various data to SD card
|
+---MIB_info                            # Hardware infos and such
|
+---Network                         	  # Telnet activation and more
|
+---Privacy                             # Privacy related functions
|
+---Update_and_Uninstall                # Allows to update & uninstall the Toolbox
```

## How to use Python3 scripts from the tools folder

### extract-mcf.py (by jille)
Extracts files from *.mcf skin file containers<br>
Syntax: `extract-mcf.py <INPUTFILE> <EXTRACTION-FOLDER>`<br>
Example: `extract-mcf.py images.mcf .\extracted\`

### compress-mcf.py (by jille)
Compresses files from extracted folder back into *.mcf container<br>
Syntax: `compress-mcf.py <ORIGINAL-BASEFILE> <NEWFILE> <FOLDER-WITH-EXTRACTED-FILES>`<br>
Example: `compress-mcf.py images.mcf images2.mcf .\extracted\`

### extract-startup_x.boot.py (by jille) *currently not fully working*
Extracts files from *.boot startup screen containers<br>
Syntax: `extract-startup_x.boot.py <INPUTFILE> <EXTRACTION-FOLDER>`<br>
Example: `extract-startup_x.boot.py startup_x.boot .\extracted\`

### compress-startup_x.boot.py (by jille) *currently not fully working*
Compresses files from extracted folder back into *.boot container<br>
Syntax: `compress-startup_x.boot.py <ORIGINAL-BASEFILE> <NEWFILE> <FOLDER-WITH-EXTRACTED-FILES>`<br>
Example: `compress-startup_x.boot.py startup_x.boot startup2_x.boot .\extracted\`
