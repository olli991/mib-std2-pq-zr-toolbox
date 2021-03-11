#!/bin/ksh
# MIB2 utility script, part of the MIB High toolbox.
# Coded by Jille
# This script will make a backup if it's not already there
# Modified for MIB2STD toolbox by Olli

# Mount system as read/write
. /tsd/scripts/util_mount.sh
sleep 1

NEWFILES=$VOLUME/custom/$SDPATH

echo "Copying data from SD-card to unit."

if [ "$TYPE" == "folder" ]
    then
		echo "Copying files recursively from custom/$TOPIC folder on SD card"
		echo "This can take some time. Please wait"
        /bin/cp -R "$NEWFILES" "$MIBPATH"
    else 
		echo "Copying file from custom/$TOPIC folder on SD card"
        /bin/cp -f $NEWFILES "$MIBPATH"
fi 

echo "Copy done"

sleep .5