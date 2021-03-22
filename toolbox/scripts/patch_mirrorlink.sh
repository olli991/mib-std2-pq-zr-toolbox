#!/bin/sh
# Info
export TOPIC=mirrorlink
export MIBPATH=/tsd/etc/mirrorlink/mirrorlink.config.common.xml
export SDPATH=$TOPIC/mirrorlink.config.common.xml
export FILE=mirrorlink.config.common.xml
export TYPE="file"
DESCRIPTION="This script will backup and patch Mirrorlink config file"

echo $DESCRIPTION
echo
sleep 2

#. /eso/hmi/engdefs/scripts/mqb/util_info.sh # for later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Make Backup
. /tsd/etc/persistence/esd/scripts/util_backup.sh
sleep 1

# Patching - Only start patching when a backup is there
PATCHCHECK="GEMIgnoreRestrictedMode Value=\"True\""

if [ -f $BACKUPFOLDER/$FILE ]; then
    echo "Start patching"
	
	# Mount system volume   
	. /tsd/etc/persistence/esd/scripts/util_mount.sh
	
	# Check if it's already patched
	if grep -q "$PATCHCHECK" "$MIBPATH"; then
		echo "mirrorlink.config.common.xml already patched. Aborting"
		exit 0
		
	else
		# Patching
		echo "Patching mirrorlink.config.common.xml"
		sed -i 's/GEMIgnoreRestrictedMode Value=\"False\"/GEMIgnoreRestrictedMode Value=\"True\"/g' $MIBPATH  
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
