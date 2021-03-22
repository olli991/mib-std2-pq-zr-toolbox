#!/bin/sh
# Info
export TOPIC=greenmenu
export MIBPATH=/tsd/etc/persistence/esd
export SDPATH=$TOPIC
export TYPE="folder"
DESCRIPTION="This script will install custom GreenMenus"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh
sleep 1

# Copy file(s) to unit
NEWFILES=$VOLUME/custom/$SDPATH

echo "Copying files from custom/$TOPIC folder on SD card"
echo "This can take some time. Please wait"
echo "Copying new GreenMenu screens"
cp -r ${NEWFILES}/*.esd ${MIBPATH}
echo "Copying new scripts"
cp -r ${NEWFILES}/scripts/*.sh ${MIBPATH}/scripts	
sleep 1

echo
echo "Done. Now restart the GreenMenu"

exit 0
