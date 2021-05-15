#!/bin/ksh
export TOPIC=navigation
export MIBPATH=/tsd/etc/nav/mibstd2_nav_target.ini 
export SDPATH=$TOPIC/mibstd2_nav_target.ini 
export TYPE="file"

echo "This script will backup and patch Navigation config file"
echo

# Make Backup
. /tsd/etc/persistence/esd/scripts/util_backup.sh

FILE=mibstd2_nav_target.ini 
# Patch only if backup was successful
if [ -f $BACKUPFOLDER/$FILE ]; then
	# Check if it's already patched
	if grep -q "NavigateFromAllMedia" "$MIBPATH"; then
		echo "$FILE is already patched. Aborting"
		exit 0
	else # Patching
		# Mount system partition in read/write mode
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		echo "Patching $MIBPATH"
		echo "" >> $MIBPATH
		echo "[NavigateFromAllMedia]" >> $MIBPATH
		echo "NavigateFromAllMedia = 42" >> $MIBPATH
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