# MIB STD2 Toolbox
⚠️ **Currently is working only on MIB STD2 PQ/ZR Technisat/Preh and is NOT COMPATIBLE with MIB2 STD Delphi and MIB2 HIGH Harman units!** ⚠️

## Disclaimer
WE ARE NOT RESPONSIBLE FOR ANY DAMAGE OF YOUR UNIT. YOU ARE DOING EVERYTHING AT YOUR OWN RISK! READ THIS README, USE YOUR BRAIN AND BE CAREFUL!

![MST2-Toolbox-v0 8](https://user-images.githubusercontent.com/55631413/125124008-bb5e5e80-e0f7-11eb-9112-0cbaeb580b51.png)

## Requirements
- Any OBD2 adapter with a software that can enable developer mode (Green Engineering Menu) on the unit
- Empty FAT32 formatted SD card or USB flashdrive, with enough space to save your backups. Everything bigger than 1GB is recommended

## How to install from SD card via "Service Mode" on supported units with navigation
1. Unzip `MIBSTD2-Toolbox-vX.X.X.zip` to the root of SD card. 

NOTE: Additionally, **ONLY** for firmwares 01xx with GEM 3.4 and 02xx with GEM 3.5, replace `cpu` folder in the root of the SD card with `cpu` folder from `\toolbox\gem` folder.

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
6. Run `ksh /media/mp000/install.sh` to install the toolbox. Old GEM will be automatically updated if found.
7. Open Green Engineering Menu and have fun 🙂

## How to install with USB SD card reader directly connected (soldered) to eMMC chip via QNX Virtual Machine 
1. Unzip `MIBSTD2-Toolbox-vX.X.X.zip` to the root of any USB flash drive. Eject and physically disconnect all USB drives.
2. Start Neutrino 6.5 Virtual Machine, insert USB SD card reader into any USB port of the PC/laptop and allow to connect to VM
3. Insert the USB flash drive with the Toolbox to any USB port of PC/laptop and allow to connect to VM
4. Inside VM, open Utilities->Terminal and enter `mount` to see where USB drive with Toolbox is mounted. Normally it will be /fs/usb1.
5. Enter `ksh /fs/usb1/install.sh`
6. Turn off VM assemble back the unit, Open Green Engineering Menu and have fun 🙂
NOTE: If you do not want to use USB drive but have sshd running inside of the VM and have WinSCP access, just copy `MIBSTD2-Toolbox-vX.X.X.zip` content to into `/tmp` folder inside VM. And run install.sh.

## How to install into eMMC backup image with QNX Virtual Machine
1. Unzip `MIBSTD2-Toolbox-vX.X.X.zip` to the root of any USB flash drive. Eject and physically disconnect all USB drives.
2. Make eMMC dump from the unit into raw format for example with USB Image Tool
3. Convert backup image to VMDK format `qemu-img convert -f raw backup.img -O vmdk backup.vmdk`, add it to Neutrino 6.5 Virtual Machine and start it
4. Insert the Toolbox USB flash drive to any USB port of PC/laptop and allow to connect to VM
5. Inside VM, open Utilities->Terminal and enter `mount` to see where USB drive with Toolbox is mounted. Normally it will be /fs/usb0 or /fs/hd10-dos-1.
6. Run `ksh /fs/usb0/install.sh` or `ksh /fs/hd10-dos-1/install.sh`
7. Turn off VM and convert VMDK back to raw `qemu-img convert -f vmdk backup.vmdk -O raw new_backup.img`
8. Flash new_backup.img back into eMMC chip, assemble back the unit, Open Green Engineering Menu and have fun 🙂
NOTE: If you do not want to use USB drive but have sshd running inside of the VM and have WinSCP access, just copy `MIBSTD2-Toolbox-vX.X.X.zip` content to into `/tmp` folder inside VM. And run install.sh.

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
|   +---Skins                           # Modify skins
|   +---Sounds                          # Modify ringtones and system sounds
|
+---Dump                                # Dump various data to SD card
|
+---MIB_info                            # Hardware infos and such
|
+---Network                             # Telnet activation and more
|
+---Tools                               # Tools and privacy related functions
|   +---Update                          # Enable manual SWDL
|
+---Update_and_Uninstall                # Allows to update & uninstall the Toolbox
|   +---Update Toolbox                  # Update Toolbox from SD card or USB drive"
+   +---Uninstall Toolbox               # Completely uninstalls Toolbox
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

### extract-startup_x.boot.py (by jille)
Extracts files from *.boot startup screen containers<br>
Syntax: `extract-startup_x.boot.py <INPUTFILE> <EXTRACTION-FOLDER>`<br>
Example: `extract-startup_x.boot.py startup_x.boot .\extracted\`

### compress-startup_x.boot.py (by jille)
Compresses files from extracted folder back into *.boot container<br>
Syntax: `compress-startup_x.boot.py <ORIGINAL-BASEFILE> <NEWFILE> <FOLDER-WITH-EXTRACTED-FILES>`<br>
Example: `compress-startup_x.boot.py startup_x.boot startup2_x.boot .\extracted\`

### generate_shadow.py (by lprot)
Converts password to shadow file

## Frequently asked questions
```
Q: I already installed Toolbox and want to install new version do I need to uninstall the old one?
What is a proper way to update?
A: No, you do not need to uninstall. Simply do `update_and_unistall->Update Toolbox from SD card or USB drive`

Q: I got unit with part number X. How to know if that is Technisat/Preh/Delphi/Harman?
A: Google that part number in picture mode and take a look at the label or look for the letter in software version string.
For example MST2_EU_SK_ZR_P0478T. Letter T at the end means it's Technisat. If there is no letter it's Harman.

Q: Is Toolbox compatible with non Navi (single SD slot) units?
A: Yes, but to install you need to use console/telnet installation method.

Q: Where to find GEM (Green Egineering Menu) version?
A: In the top left corner of the Green Engineering Menu screen.

Q: Why Toolbox is not compatible with GEM 3.5 or lower?
A: GEM 3.5 and lower cannot run scripts

Q: I instaled Toolbox and want to update my firmware from 02xx version to 04xx version. Will Toolbox remain installed after the update?
A: No, Toolbox will be deleted as when update happens /tsd/etc/persistence/esd folder gets cleaned. So you will need to install the Toolbox again.

Q: How to make screenshots?
A: Press and hold MEDIA key until you hear confirmation sound

Q: Where to find screenshots?
A: In the root folder of SD card. You can also use `Tools->Move screenshots from root of all drives to the Toolbox drive`
function to collect them in screenshots folder of Toolbox drive.

Q: After Toolbox installation I got OBD error 1556. How to fix it?
A: Just run Tools->Clean SWDL history and keep only non-duplicated FW updates. Then reboot the unit and clear OBD2 error
with any software that can do that.

Q: Can I make eMMC backup of my unit?
A: Use `Dump->eMMC content (exFAT/NTFS SD card/USB drive + ~7.3 GB free space required)` menu.
As most of the units have 7.3 GB eMMC chips, FAT32 formatted media cannot be used because of 4 GB max filesize limitation.
Also it is strongly recommended to use exFAT/NTFS formatted SD card because USB port on MIB STD2 is capped to 5 MB/s.
Class 10 SD card allows to achieve the dump speed upto 10 GB/s so the process finishes in just ~15 minutes :)
```
