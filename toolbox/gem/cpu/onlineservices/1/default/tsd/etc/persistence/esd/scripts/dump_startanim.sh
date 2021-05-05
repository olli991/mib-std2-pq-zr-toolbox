#!/bin/ksh
export TOPIC=startanim
export MIBPATH=/tsd/etc/startanim
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will dump startup animations / bootscreens"
. /tsd/etc/persistence/esd/scripts/util_dump.sh