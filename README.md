# MIB STD2 Toolbox
⚠️ **This toolbox version is only compatible with MIB STD2 PQ/ZR Technisat/Preh units and is NOT COMPATIBLE with MIB2 STD Delphi and MIB2 HIGH Harman units!** ⚠️

## Disclaimer
WE ARE NOT RESPONSIBLE FOR ANY DAMAGE OF YOUR UNIT. YOU ARE DOING EVERYTHING AT YOUR OWN RISK! READ THIS README, USE YOUR BRAIN AND BE CAREFUL!

![Toolbox-v1 1](https://user-images.githubusercontent.com/55631413/164947549-1cf46837-ea2d-49a6-b841-f54ba4452ab9.png)

## Requirements
- Green Engineering Menu (developer mode) enabled in adaptations of block 5F. Use any OBD2 adapter and software that can enable it.
- Empty FAT32 formatted SD card or soldering skills + USB flashdrive, with enough space to save your backups. Everything bigger than 1GB is recommended
- Read FAQ at the bottom of this file!

## How to install from SD card via "Service Mode" on units with navigation (units with two SD slots)
**NOTE:** This SD installation method is NOT possible on Seat units with HW H50+ (firmwares 05xx) also known as variants 47213, 47214, 47215, 47216.
Metainfo2.txt of the Toolbox does not contain these variant numbers. Metainfo2.txt cannot be edited because has digital signature at the end of the file. The ONLY KNOWN way to install Toolbox onto this kind of units is soldering USB SD card reader to eMMC.
1. Unzip `MIBSTD2-Toolbox-vX.X.X.zip` to the root of SD card.
2. **IMPORTANT!** If your firmware is version 01xx or 02xx having GEM (Green Engineering Menu) version 3.x, you must use special edition of Toolbox to update it. To do this, replace `cpu` folder in the root of the SD card with `cpu` folder from `\toolbox\gem` folder. If GEM is version 4.x+, skip this step.
3. Turn on ignition and insert SD card into SD1 slot of the unit
4. Press and hold MENU button to open `Service Mode -> Software Update` and install `MIBStd2_Online_Approval`.
5. Open Green Engineering Menu and have fun 🙂

## How to install if you already have serial console or telnet access to your unit
**IMPORTANT!** By default console/telnet access on all units is disabled and you first need to install Toolbox to enable it!
1. Unzip `MIBSTD2-Toolbox-vX.X.X.zip` to the root of SD card or USB drive
2. Delete `metainfo2.txt`, this helps to avoid endless reading spinner when connecting USB drive to the unit.
3. Login via console/telnet as root/root
4. Insert SD card or connect USB drive to the unit
5. Enter `mount` to see where inserted card/connected drive is mounted. Usually /media/mp000 is slot SD1, /media/mp001 slot SD2, /media/mp002 port USB1 and so on.
6. Run `ksh /media/mp000/install.sh` to install the toolbox. Old GEM will be automatically updated if found.
7. Open Green Engineering Menu and have fun 🙂

## How to install with USB SD card reader soldered to eMMC chip by using QNX Virtual Machine
1. Unzip `MIBSTD2-Toolbox-vX.X.X.zip` to the root of any USB flash drive. Eject and physically disconnect all USB drives.
2. Start Neutrino 6.5 Virtual Machine, insert USB SD card reader into any USB port of the PC/laptop and allow to connect to VM
3. Insert the USB flash drive with the Toolbox to any USB port of PC/laptop and allow to connect to VM
4. Inside VM, open Utilities->Terminal and enter `mount` to see where USB drive with Toolbox is mounted. Normally it will be /fs/usb1.
5. Enter `ksh /fs/usb1/install.sh`
   - **If you encounter VM freezes or I/O errors while copying:** try to create an .iso (via `AnyToIso Lite` as example) from the contents of the toolbox and mount the iso via CD drive. You can then run `ksh /fs/cd0/install.sh`! - OR - use the eMMC backup method.
7. Turn off VM assemble back the unit, Open Green Engineering Menu and have fun 🙂
NOTE: If you do not want to use USB drive but have sshd running inside of the VM and have WinSCP access, just copy `MIBSTD2-Toolbox-vX.X.X.zip` content to into `/tmp` folder inside VM. And run `ksh /tmp/install.sh`

## How to install into eMMC backup image with QNX Virtual Machine
1. Unzip `MIBSTD2-Toolbox-vX.X.X.zip` to the root of any USB flash drive. Eject and physically disconnect all USB drives.
2. Make eMMC dump from the unit into raw format for example with USB Image Tool
3. Convert backup image to VMDK format `qemu-img convert -f raw backup.img -O vmdk backup.vmdk`, add it to Neutrino 6.5 Virtual Machine and start it
4. Insert the Toolbox USB flash drive to any USB port of PC/laptop and allow to connect to VM
5. Inside VM, open Utilities->Terminal and enter `mount` to see where USB drive with Toolbox is mounted. Normally it will be /fs/usb0 or /fs/hd10-dos-1.
6. Run `ksh /fs/usb0/install.sh` or `ksh /fs/hd10-dos-1/install.sh`
   - **If you encounter VM freezes or I/O errors while copying:** try to create an .iso (via `AnyToIso Lite` as example) from the contents of the toolbox and mount the iso via CD drive. You can then run `ksh /fs/cd0/install.sh`!
8. Turn off VM and convert VMDK back to raw `qemu-img convert -f vmdk backup.vmdk -O raw new_backup.img`
9. Flash new_backup.img back into eMMC chip, assemble back the unit, Open Green Engineering Menu and have fun 🙂
NOTE: If you do not want to use USB drive but have sshd running inside of the VM and have WinSCP access, just copy `MIBSTD2-Toolbox-vX.X.X.zip` content to into `/tmp` folder inside VM. And run `ksh /tmp/install.sh`

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

## FAQ (Frequently Asked Questions)
Q: I already installed Toolbox and want to install new version do I need to uninstall the old one? What is a proper way to update?  
A: No, you do not need to uninstall. Simply do `update_and_uninstall->Update Toolbox from SD card or USB drive`

Q: I got unit with part number X. How to know if that is Technisat/Preh/Delphi/Harman?  
A: Google that part number in picture mode and take a look at the label or look for the letter in software version string.  
For example MST2_EU_SK_ZR_P0478T. Letter T at the end means it's Technisat/Preh. If there is no letter it's Harman, correspondingly D=Delphi.

Q: Is Toolbox compatible with non Navi (single SD slot) units?  
A: Yes, but to install you need to use eMMC soldering method or console/telnet installation method.

Q: I installed Toolbox from SD but when I try to use it does nothing and prints errors!  
A: Your fw is 01xx/02xx with GEM 3.5. Read installation steps carefully!

Q: Why Toolbox does not work with GEM 3.5 or lower?  
A: GEM 3.5 and lower cannot run scripts

Q: Where to find GEM (Green Egineering Menu) version?  
A: In the top left corner of the Green Engineering Menu screen.

Q: I already have the Toolbox installed and want to update my firmware from 02xx/03xx to 04xx/05xx/06xx etc version. Will Toolbox remain installed after the update?  
A: Yes, but you need to update fw manually via `Testmode->SWDL->Software Download Manual Download->Start Download`.  
Tap on "Select all", open `cpu` or `cpuplus` folder there and untick `esd_sec` module and start the update.  
If you forget to untick `esd_sec`, the update will clean /tsd/etc/persistence/esd folder and delete the toolbox.  

Q: How to make screenshots?  
A: Press and hold MEDIA key until you hear confirmation sound

Q: Where to find screenshots?  
A: In the root folder of SD card. You can also use `Tools->Move screenshots from root of all drives to the Toolbox drive` to collect them in `screenshots` folder on the Toolbox drive.

Q: After Toolbox installation I got OBD error 1556. How to fix it?  
A: Usually just running `Tools->Clean SWDL history and keep only non-duplicated FW updates` helps. Then reboot the unit and clear OBD2 error.  
If the error still there, long press MENU and enter `Testmode->Green Engineering Menu->debugging->additional debug destination`.  
Select where to save the log onto SD or USB. Open the log from SD/USB and look for strings like `SW incompatible`. They will contain the reason of the error.

Q: Can I make eMMC backup of my unit?  
A: Sure, just use `Dump->eMMC content (exFAT/NTFS SD card/USB drive + ~7.3 GB free space required)` menu.  
As most of the units have 7.3 GB eMMC chips, FAT32 formatted media cannot be used because of 4 GB max filesize limitation.  
Also it is strongly recommended to use exFAT/NTFS formatted SD card because USB port on MIB STD2 is capped to 5 MB/s.  
Class 10 SD card allows to achieve the dump speed upto 10 GB/s so the process finishes in just ~15 minutes :)

Q: Which firmware trains are currently supported for direct SWDL/SWAP/CP patching?  
A: Look lists for SWDL [here](https://github.com/olli991/mib-std2-pq-zr-toolbox/blob/master/cpu/onlineservices/1/default/tsd/etc/persistence/esd/scripts/patch_swdl.sh)
SWAP [here](https://github.com/olli991/mib-std2-pq-zr-toolbox/blob/master/cpu/onlineservices/1/default/tsd/etc/persistence/esd/scripts/patch_swap.sh)
, and CP [here](https://github.com/olli991/mib-std2-pq-zr-toolbox/blob/master/cpu/onlineservices/1/default/tsd/etc/persistence/esd/scripts/patch_cp.sh)  
**IMPORTANT!** If you get the error "Unknown file size detected", please use the "Dump necessary files to SD folder /dump/.../support" option in the "Tools" section and open up an issue on GitHub and attach the archive with those files!
