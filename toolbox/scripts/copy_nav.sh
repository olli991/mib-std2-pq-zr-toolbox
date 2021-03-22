#!/bin/sh
# Info
export TOPIC=navigation
export MIBPATH=/tsd/etc/nav/mibstd2_nav_target.ini 
export SDPATH=$TOPIC/mibstd2_nav_target.ini 
export TYPE="file"
DESCRIPTION="This script will copy mibstd2_nav_target.ini "

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
. /tsd/etc/persistence/esd/scripts/util_copy.sh
sleep 1

chmod 777 $MIBPATH

echo
echo "Done. Now restart the unit"

exit 0
