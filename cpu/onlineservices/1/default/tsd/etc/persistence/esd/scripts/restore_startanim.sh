#!/bin/ksh
export TOPIC=startanim
export MIBPATH=/tsd/etc/startanim
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will restore system sounds from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh