#!/bin/sh
# Info
export TOPIC=stationdb
export MIBPATH=/tsd/etc/stationdb/VW_STL_DB.sqlite
export SDPATH=$TOPIC/VW_STL_DB.sqlite
export TYPE="file"
DESCRIPTION="This script will copy VW_STL_DB.sqlite"

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
