#!/bin/ksh
# Dump HMI file

# Info
TOPIC=hmi
DESCRIPTION="This script will dump HMI file"

# Volumes/files
ORIGINAL=/tsd/hmi/tsd.mibstd2.hmi.ifs

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
. /tsd/scripts/util_mount.sh
sleep 1

echo "Copying HMI file to SD"
/bin/cp  $ORIGINAL $DUMPFOLDER/
sleep 1

echo "Done. HMI is dumped to $DUMPFOLDER"

exit 0 
 