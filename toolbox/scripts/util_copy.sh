#!/bin/ksh
# MIB2 utility script, part of the MIB High toolbox.
# Coded by Jille
# This script will make a backup if it's not already there
# Modified for MIB2STD toolbox by Olli

# Mount system as read/write
. /tsd/scripts/util_mount.sh
sleep 1

NEWFILES=$VOLUME/custom/$SDPATH

echo "Copying data from SD card to unit"

if [ "$TYPE" == "folder" ]; then
	if [ -d ${NEWFILES} ]; then
    	echo "Copying files recursively from custom/$TOPIC folder on SD card"
		echo "This can take some time. Please wait"
        cp -r ${NEWFILES}/* ${MIBPATH}
	else
		echo "No files found"
		exit 0
	fi	
else
	if [ -f ${NEWFILES} ]; then
		echo "Copying file from custom/$TOPIC folder on SD card"
        cp -f ${NEWFILES} ${MIBPATH}
	else
		echo "No files found"
		exit 0
	fi
fi 

echo "Copy done"

sleep .5