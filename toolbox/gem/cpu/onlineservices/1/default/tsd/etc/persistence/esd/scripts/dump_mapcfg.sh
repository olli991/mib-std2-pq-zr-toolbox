#!/bin/ksh
export TOPIC=mapcfg
export MIBPATH=/tsd/var/nav/cfg/mapcfg
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will dump navigation graphics"
. /tsd/etc/persistence/esd/scripts/util_dump.sh
