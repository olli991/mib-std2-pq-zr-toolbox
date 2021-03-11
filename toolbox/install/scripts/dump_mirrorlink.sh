#!/bin/ksh
# Dump Mirrorlink config file

# Info
TOPIC=mirrorlink
DESCRIPTION="This script will dump Mirrorlink config file"

# Volumes/files
ORIGINAL=/tsd/etc/mirrorlink/mirrorlink.config.common.xml

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

echo "Copying Mirrorlink config file to SD"
/bin/cp  $ORIGINAL $DUMPFOLDER/
sleep 1

echo "Done. Mirrorlink config is dumped to $DUMPFOLDER"

exit 0 
 