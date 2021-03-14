#!/bin/ksh
# Info
export TOPIC=startanim
export MIBPATH=/tsd/etc/startanim
export SDPATH=$TOPIC
export TYPE="folder"
DESCRIPTION="This script will dump startup animations / bootscreens"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/scripts/util_checksd.sh

# Dump files
. /tsd/scripts/util_dump.sh

exit 0
 