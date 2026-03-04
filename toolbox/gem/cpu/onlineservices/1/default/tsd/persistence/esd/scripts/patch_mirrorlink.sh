#!/bin/ksh
export TOPIC=mirrorlink
export MIBPATH=/tsd/etc/mirrorlink/mirrorlink.config.common.xml
export SDPATH=$TOPIC/mirrorlink.config.common.xml
export TYPE="file"

echo "This script will backup and patch MirrorLink config file"
echo

# Make Backup
. /tsd/etc/persistence/esd/scripts/util_backup.sh

FILE=mirrorlink.config.common.xml
# Patch only if backup was successful
if [ -f $BACKUPFOLDER/$FILE ]; then
	# Check if it's already patched
	if grep -q "GEMIgnoreRestrictedMode Value=\"True\"" "$MIBPATH"; then
		echo "$FILE is already patched. Aborting"
		exit 0
	else # Patching
		# Mount system partition in read/write mode
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		echo "Patching $MIBPATH"
		sed -i 's/GEMIgnoreRestrictedMode Value=\"False\"/GEMIgnoreRestrictedMode Value=\"True\"/g' $MIBPATH
		# Mount system partition in read/only mode
		. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
    fi
else
	echo "Backup failed. Patching is aborted."
	exit 0
fi

echo
echo "Successfully patched. Please reboot the unit to apply changes."
echo "If something does not work as expected, use a restore function."
exit 0
