#!/bin/ksh
# Dump SWDL file

# Info
TOPIC=swdl
DESCRIPTION="This script will dump SWDL file"

# Volumes/files
ORIGINAL=/tsd/bin/swdownload/tsd.mibstd2.system.swdownload

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later
. /tsd/scripts/util_checksd.sh
if [[ -z "$VOLUME" ]] 
then
	echo "No SD card found, quitting"
	exit 0
fi

#Make dump folder
DUMPFOLDER=$VOLUME/dump/$TOPIC

echo "Dump-folder: $DUMPFOLDER"
/bin/mkdir -p $DUMPFOLDER
echo "Dumping, please wait"
sleep 1

# Mount system as read/write
echo "Mount system as read/write"
/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /
sleep 1

echo "Copying SWDL file to SD"
/bin/cp  $ORIGINAL $DUMPFOLDER/
sleep 1

echo "Done. SWDL is dumped to $DUMPFOLDER"

exit 0 
 