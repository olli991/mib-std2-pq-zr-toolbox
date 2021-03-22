# MIB2 Standard Toolbox
⚠️ **Currently only working on Technisat devices with navigation and GEM 4.1 and higher!!** ⚠️

![SCREENSHOT_Nr_5](https://user-images.githubusercontent.com/55631413/112053673-eb87ee80-8b54-11eb-9001-96d6dbf8598e.png)

Note: This screens has the potential to ruin your MIB2 STD unit. The developers are not responsible for any troubles to anyone or anything caused by this toolbox. It's never our intention to harm any person, car or brand. Use the tools wisely, don't be a douche.

## Requirements
- Read the entire readme
- At least 1 healthy set of brains
- A MIB2 STD by Technisat with navigation. It will not work on MIB2 High or Delphi units!
- 1 empty, FAT32 formatted SD card, with enough space. Everything bigger than 1GB is fine
- Some place to save your backups
- Diagnostic software to activate developer mode on the unit to get access to the GreenMenu

## Optional requirements
- Python 3, if you want to extract/compress graphics containers (boot/mcf)
- Picture editing software, if you want to customize graphics files

## How to install (SD method)
1. Copy everything to SD card
2. Put SD card into slot 1
3. Install it via `Service Menu -> Software Update`
4. After reboot open GreenMenu and run `Install Toolbox` to install all menus and scripts
5. Restart GreenMenu
6. Have fun 🙂

## How to install (manual method)
If you have already access to your unit via telnet you can always install the toolbox manually.
1. Login via telnet
2. Place the SD card into a slot
3. Run the `until_install.sh` from SD `/toolbox/scripts/`

If you can't run this script from SD because of missing permissions, copy the file to the unit:
1. Mount the volume writeable: `mount -t qnx6 -o remount,rw /dev/hd0t177 /`
2. Create scripts folder: `mkdir -p /tsd/etc/persistence/esd/scripts`
3. Copy script to folder: `cp /media/mp000/toolbox/scripts/until_install.sh tsd/etc/persistence/esd/scripts`
4. Set chmod (just to be safe): `chmod a+rwx /tsd/etc/persistence/esd/scripts/until_install.sh`
5. Run the script 

## How to use
1. Make dumps of the files you want to modify via `dump` menu
2. Dumps will be placed in the corresponding `dump` folder on SD
3. Modify the files how you'd like and place them in the corresponing folder inside `custom` on SD
4. Import modified files via `customization` menu

Notice: Every time you copy files to the unit the script will check if there is a backup. If not, it will make a backup of the original files from to unit to `backup` folder. This way you can always use the `restore` functions to roll back to original. 

⚠️ **DO NOT TOUCH THE FILES IN BACKUP FOLDER!!** ⚠️

### Overview
```
MIB2STD Toolbox Main
|
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
|   +---Network                         # Telnet activation and more
|   +---Skins                           # Modify skins
|   +---Sounds                          # Modify ringtones and system sounds
|   +---Update                          # Enable manual SWDL
|
+---Disclaimer                          # Disclaimer and mentioning of involved people
|
+---Dump                                # Dump various data to SD card
|
+---History                             # Version history of the toolbox
|
+---MIB_info                            # Hardware infos and such
|
+---Privacy                             # Privacy related functions
|
+---Uninstall                           # Uninstalls MIB2STD Toolbox
```

## How to use the tools
Currently there are four tools included:

### extract-mcf.py (by jille)
This is a python script to extract skinfile containers (.mcf).<br>
Usage for instance: `extract-mcf.py <INPUTFILE> <EXTRACTIONFOLDER>`<br>
Example: `extract-mcf.py images.mcf .\extracted\`

### compress-mcf.py (by jille)
This is a script to compress the MCF-container.<br>
Usage for instance: `compress-mcf.py <ORIGINAL-BASEFILE> <NEWFILE> <FOLDER-WHERE-TO-COMPRESS-FROM>`<br>
Example: `compress-mcf.py images.mcf images2.mcf .\extracted\`

### extract-startup_x.boot.py (by jille) *currently not fully working*
This is a python script to extract startup screen containers (.boot).<br>
Usage for instance: `extract-startup_x.boot.py <INPUTFILE> <EXTRACTIONFOLDER>`<br>
Example: `extract-startup_x.boot.py startup_x.boot .\extracted\`

### compress-startup_x.boot.py (by jille) *currently not fully working*
This is a script to compress the BOOT-container.<br>
Usage for instance: `compress-startup_x.boot.py <ORIGINAL-BASEFILE> <NEWFILE> <FOLDER-WHERE-TO-COMPRESS-FROM>`<br>
Example: `compress-startup_x.boot.py startup_x.boot startup2_x.boot .\extracted\`

## Supported firmwares
- It should run on all Technisat units. SD installation is only possible on navigation units. If you have a really old firmware and GEM 3.5 is present you have to use the dedicated installer for that case. Please read the next part for more informations.
- It will **not** work on MIB2STD units with hardware H50 and newer (currently Seat units which came with firmware 05xx from factory) because the variant is missing in our backdoor and we can't add this because of file integrity. But you can install it manually if you activated telnet on your unit with BDM pins or something in the first place. Just run `util_install.sh` from SD `toolbox/scripts` manually.

### Support and how-to for older devices with GEM 3.5
We've built a special installer package for this older devices because this toolbox only works with GEM 4.1 and higher.
If you have an unit with GEM 3.5, then please download the dedicated release bundle `MIB2STD-Toolbox-vX.X-GEM-Update.zip` from latest release.
Don't panic within the update process, it will take longer and the bootscreen will be shown several times for quite some time. It seems like nothing is happening. This is correct! Please just wait until it proceeds. The update could take up to 5 minutes.

## Disclaimer
WE'RE NOT RESPONSABLE FOR ANY DAMAGE OF YOUR UNIT. YOU'RE DOING EVERYTHING AT YOUR OWN RISK! USE YOUR BRAIN AND BE CAREFUL!
