#!/bin/ksh
# Dump SWAP file

# Info
TOPIC=swap
DESCRIPTION="This script will dump SWAP file"

# Volumes/files
ORIGINAL=/tsd/bin/swap/tsd.mibstd2.system.swap

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

echo "Copying SWAP file to SD"
/bin/cp  $ORIGINAL $DUMPFOLDER/
sleep 1

echo "Done. SWAP is dumped to $DUMPFOLDER"

exit 0
 