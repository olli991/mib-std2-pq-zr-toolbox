#!/bin/ksh
# This script will dump files
# Created by Olli, based on scripts by Jille
# Info
export DUMPFOLDER=$VOLUME/dump/$SDPATH

# Mount system as read/write
. /tsd/scripts/util_mount.sh
sleep 1

# Dumping files
if [ -d "$DUMPFOLDER" ]; then
	if [ "$TYPE" == "folder" ]; then
		echo "Dumping content recursively to dump folder on SD card"
		echo "This can take some time. Please wait"
        cp -r ${MIBPATH}/* ${DUMPFOLDER}
    else 
		echo "Dumping file to dump folder on SD card"
        cp ${MIBPATH} ${DUMPFOLDER}
    fi 
else
	echo "Making dump folder"
	mkdir -p $DUMPFOLDER
	if [ "$TYPE" == "folder" ]; then
		echo "Dumping content recursively to dump folder on SD card"
		echo "This can take some time. Please wait"
        cp -r ${MIBPATH}/* ${DUMPFOLDER}
    else 
		echo "Dumping file to dump folder on SD card"
        cp ${MIBPATH} ${DUMPFOLDER}
    fi 
fi

echo "Dump done. Saved at dump/$SDPATH" 
echo 