#!/bin/ksh
export TOPIC=mapcfg
export MIBPATH=/tsd/var/nav/cfg/mapcfg
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will restore navigation grapics from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh