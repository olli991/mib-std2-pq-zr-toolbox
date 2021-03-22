#!/bin/ksh
# MIB2 utility script, part of the MIB2STD toolbox.
# Coded by Olli
# This script will update the toolbox.

# Info
DESCRIPTION="This script will update the MIB2STD Toolbox"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Mount system as read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh
sleep 1

# Copy GreenMenu screens
echo "Updating GreenMenu screens"
cp -r $VOLUME/toolbox/esd/*.esd /tsd/etc/persistence/esd
sleep 1

# Copy scripts
echo "Updating scripts"
cp -r $VOLUME/toolbox/scripts/*.sh /tsd/etc/persistence/esd/scripts	
chmod a+rwx /tsd/etc/persistence/esd/scripts/*.sh
echo
sleep 1

echo "Update done. Please restart GreenMenu!"

exit 0
