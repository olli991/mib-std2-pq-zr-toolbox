#!/bin/ksh

# Check if SD card is inserted
. /tsd/scripts/util_checksd.sh
sleep 1

#Make dump folder
DUMPFOLDER=$VOLUME/dump/dev

echo "Dump-folder: dump/dev/tsd"
mkdir -p $DUMPFOLDER
echo "Dumping, please wait"
sleep 1

# Mount system as read/write
. /tsd/scripts/util_mount.sh
sleep 1

echo "Copying whole /tsd path to SD"

cp -r /tsd $VOLUME/dump/dev

echo
echo "Copy done"

sleep .5