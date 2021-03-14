#!/bin/ksh
# MIB2 utility script, part of the MIB2STD toolbox.
# Coded by Olli
# This script will restore files from backup.
# Based on the copy script by Jille from MIB2 High Toolbox. Modified for MIB2STD Toolbox by Olli

# Mount system as read/write
. /tsd/scripts/util_mount.sh
sleep 1

OLDFILES=$VOLUME/backup/$SDPATH

echo "Restoring from backup on SD card to the unit"

if [ "$TYPE" == "folder" ]; then
	if [ -d ${OLDFILES} ]; then
		echo "Restoring files recursively from backup/$TOPIC folder on SD card"
		echo "This can take some time. Please wait"
        cp -r ${OLDFILES}/* ${MIBPATH}
	else
		echo "No backup found"
		exit 0
	fi	
else
	if [ -f ${OLDFILES} ]; then
		echo "Restoring file from backup/$TOPIC folder on SD card"
		cp -f ${OLDFILES} ${MIBPATH}
	else
		echo "No backup found"
		exit 0
	fi
fi 

echo "Restore done"

sleep .5