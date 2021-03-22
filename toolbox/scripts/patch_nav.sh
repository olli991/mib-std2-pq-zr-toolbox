#!/bin/sh
# Info
export TOPIC=navigation
export MIBPATH=/tsd/etc/nav/mibstd2_nav_target.ini 
export SDPATH=$TOPIC/mibstd2_nav_target.ini 
export FILE=mibstd2_nav_target.ini 
export TYPE="file"
DESCRIPTION="This script will backup and patch Navigation config file"

echo $DESCRIPTION
echo
sleep 2

#. /eso/hmi/engdefs/scripts/mqb/util_info.sh # for later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Make Backup
. /tsd/etc/persistence/esd/scripts/util_backup.sh
sleep 1

# Patching - Only start patching when a backup is present
PATCHLINE1="[NavigateFromAllMedia]"
PATCHLINE2="NavigateFromAllMedia = 42"

if [ -f $BACKUPFOLDER/$FILE ]; then
    echo "Start patching"
   
	# Mount system volume
	. /tsd/etc/persistence/esd/scripts/util_mount.sh
	
	# Check if it's already patched
	if grep -q "$PATCHLINE2" "$MIBPATH"; then
		echo "mibstd2_nav_target.ini is already patched. Aborting"
		exit 0	
		
	else
		# Patching
		echo "Patching mibstd2_nav_target.ini"
		echo "" >> $MIBPATH
		echo $PATCHLINE1 >> $MIBPATH
		echo $PATCHLINE2 >> $MIBPATH
		sleep 1			
	fi    
	
else 
    echo "Backup not found. It's not safe to continue"
    exit 0   
fi

echo
echo "Done patching. Please reboot unit"
echo "If something does not work like it should, run the restore script"
echo "Backup is stored at backup/$TOPIC"

exit 0
