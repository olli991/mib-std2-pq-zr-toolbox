#!/bin/sh
# Info
export TOPIC=mapcfg
export MIBPATH=/tsd/var/nav/cfg/mapcfg
export SDPATH=$TOPIC
export TYPE="folder"
DESCRIPTION="This script will restore navigation grapics from backup"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Restore file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_restore.sh

echo
echo "Done. Now restart the unit"

exit 0
