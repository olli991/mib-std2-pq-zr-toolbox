#!/bin/sh
# Info
export TOPIC=skins/skin1
export MIBPATH=/tsd/hmi/Resources/skin1/ambienceColorMap.res
export SDPATH=$TOPIC/ambienceColorMap.res
export TYPE="file"
DESCRIPTION="This script will install custom skin1 ambienceColorMap.res"

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

echo
echo "Done. Now restart the unit"

exit 0
