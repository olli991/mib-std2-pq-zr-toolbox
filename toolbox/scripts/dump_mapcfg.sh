#!/bin/ksh
# Info
export TOPIC=mapcfg
export MIBPATH=/tsd/var/nav/cfg/mapcfg
export SDPATH=$TOPIC
export TYPE="folder"
DESCRIPTION="This script will dump navigation graphics"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Dump files
. /tsd/etc/persistence/esd/scripts/util_dump.sh

exit 0
 