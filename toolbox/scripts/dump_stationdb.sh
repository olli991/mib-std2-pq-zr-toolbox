#!/bin/ksh
# Info
export TOPIC=stationdb
export MIBPATH=/tsd/etc/stationdb/VW_STL_DB.sqlite
export SDPATH=$TOPIC
export TYPE="file"
DESCRIPTION="This script will dump the radio station logo database"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Dump files
. /tsd/etc/persistence/esd/scripts/util_dump.sh

exit 0
 